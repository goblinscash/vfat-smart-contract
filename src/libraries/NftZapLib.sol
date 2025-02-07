// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "solmate/tokens/ERC20.sol";
import { IERC20 } from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { SafeTransferLib } from "solmate/utils/SafeTransferLib.sol";
import { INftZapLib } from "../interfaces/libraries/INftZapLib.sol";
import { INftLiquidityConnector } from
    "../interfaces/INftLiquidityConnector.sol";
import { ISwapLib } from "../interfaces/libraries/ISwapLib.sol";
import { ConnectorRegistry } from "../ConnectorRegistry.sol";
import { DelegateModule } from "../modules/DelegateModule.sol";
import { NftZapIn, NftZapOut } from "../structs/NftZapStructs.sol";
import { NftAddLiquidity } from "../structs/NftLiquidityStructs.sol";
import "forge-std/console.sol";

contract NftZapLib is DelegateModule, INftZapLib {
    error LiquidityAmountError(); // 0x4d0ab6b4

    ISwapLib public immutable swapLib;
    ConnectorRegistry public immutable connectorRegistry;

    constructor(ConnectorRegistry connectorRegistry_, ISwapLib swapLib_) {
        connectorRegistry = connectorRegistry_;
        swapLib = swapLib_;
    }

    function zapIn(
        NftZapIn memory zap
    ) external payable {
        console.log("<<<<<<<<<0000000000000000>>>>>>>>>>");
        uint256 swapDataLength = zap.swaps.length;
        for (uint256 i; i < swapDataLength;) {
            _delegateTo(
                address(swapLib), abi.encodeCall(ISwapLib.swap, (zap.swaps[i]))
            );
            unchecked {
                i++;
            }
        }
        console.log("<<<<<<<<<11111111+>>>>>>>>>>");

        bool atLeastOneNonZero = false;

        NftAddLiquidity memory addLiquidityParams = zap.addLiquidityParams;
        if (addLiquidityParams.amount0Desired == 0) {
            addLiquidityParams.amount0Desired =
                IERC20(addLiquidityParams.pool.token0).balanceOf(address(this));
                console.log("<<<<<<<<<222222222>>>>>>>>>>", IERC20(addLiquidityParams.pool.token0).balanceOf(address(this)));
        }
        if (addLiquidityParams.amount1Desired == 0) {
            addLiquidityParams.amount1Desired =
                IERC20(addLiquidityParams.pool.token1).balanceOf(address(this));
        }
        if (addLiquidityParams.amount0Desired > 0) {
            atLeastOneNonZero = true;
            SafeTransferLib.safeApprove(
               ERC20(addLiquidityParams.pool.token0),
                address(addLiquidityParams.nft),
                0
            );
            SafeTransferLib.safeApprove(
                ERC20(addLiquidityParams.pool.token0),
                address(addLiquidityParams.nft),
                addLiquidityParams.amount0Desired
            );
        }
        if (addLiquidityParams.amount1Desired > 0) {
            atLeastOneNonZero = true;
            SafeTransferLib.safeApprove(
                ERC20(addLiquidityParams.pool.token1),
                address(addLiquidityParams.nft),
                0
            );
            SafeTransferLib.safeApprove(
                ERC20(addLiquidityParams.pool.token1),
                address(addLiquidityParams.nft),
                addLiquidityParams.amount1Desired
            );
        }

        if (!atLeastOneNonZero) {
            revert LiquidityAmountError();
        }

        address routerConnector =
            connectorRegistry.connectorOf(address(addLiquidityParams.nft));

        _delegateTo(
            routerConnector,
            abi.encodeCall(
                INftLiquidityConnector.addLiquidity, (addLiquidityParams)
            )
        );

        SafeTransferLib.safeApprove(
            ERC20(addLiquidityParams.pool.token0), address(addLiquidityParams.nft), 0
        );
        SafeTransferLib.safeApprove(
            ERC20(addLiquidityParams.pool.token1), address(addLiquidityParams.nft), 0
        );
    }

    function zapOut(
        NftZapOut memory zap
    ) external {
        address routerConnector = connectorRegistry.connectorOf(
            address(zap.removeLiquidityParams.nft)
        );

        _delegateTo(
            routerConnector,
            abi.encodeCall(
                INftLiquidityConnector.removeLiquidity,
                zap.removeLiquidityParams
            )
        );

        uint256 swapDataLength = zap.swaps.length;
        for (uint256 i; i < swapDataLength;) {
            _delegateTo(
                address(swapLib), abi.encodeCall(ISwapLib.swap, (zap.swaps[i]))
            );
            unchecked {
                i++;
            }
        }
    }
}
