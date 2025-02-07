// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "solmate/tokens/ERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeTransferLib } from "solmate/utils/SafeTransferLib.sol";
import { DelegateModule } from "../modules/DelegateModule.sol";
import { ConnectorRegistry } from "../ConnectorRegistry.sol";
import { ILiquidityConnector } from
    "../interfaces/ILiquidityConnector.sol";
import { ISwapLib } from "../interfaces/libraries/ISwapLib.sol";
import { SwapParams } from "../structs/LiquidityStructs.sol";

contract SwapLib is DelegateModule, ISwapLib {
    error SwapAmountZero();

    ConnectorRegistry immutable connectorRegistry;

    constructor(
        ConnectorRegistry connectorRegistry_
    ) {
        connectorRegistry = connectorRegistry_;
    }

    function swap(
        SwapParams memory swapParams
    ) external payable {
        _swap(swapParams);
    }

    function swapMultiple(
        SwapParams[] memory swapParams
    ) external {
        uint256 swapDataLength = swapParams.length;
        for (uint256 i; i < swapDataLength;) {
            _swap(swapParams[i]);
            unchecked {
                i++;
            }
        }
    }

    /* Internal Functions */

    function _swap(
        SwapParams memory swapParams
    ) internal {
        address tokenIn = swapParams.tokenIn;

        if (swapParams.amountIn == 0) {
            swapParams.amountIn = IERC20(tokenIn).balanceOf(address(this));
        }

        if (swapParams.amountIn == 0) {
            revert SwapAmountZero();
        }

        // In case there is USDT dust approval, revoke it
        SafeTransferLib.safeApprove(ERC20(tokenIn), swapParams.router, 0);

        SafeTransferLib.safeApprove(
            ERC20(tokenIn), swapParams.router, swapParams.amountIn
        );

        address connectorAddress =
            connectorRegistry.connectorOf(swapParams.router);

        ILiquidityConnector routerConnector =
            ILiquidityConnector(connectorAddress);

        _delegateTo(
            address(routerConnector),
            abi.encodeCall(routerConnector.swapExactTokensForTokens, swapParams)
        );

        // Revoke any approval after swap in case the swap amount was estimated
        SafeTransferLib.safeApprove(ERC20(tokenIn), swapParams.router, 0);
    }
}
