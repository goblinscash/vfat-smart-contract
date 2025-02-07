// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { SwapParams } from "../structs/LiquidityStructs.sol";
import {
    NftAddLiquidity,
    NftRemoveLiquidity
} from "../structs/NftLiquidityStructs.sol";

interface INftLiquidityConnector {
    function addLiquidity(
        NftAddLiquidity memory addLiquidityParams
    ) external payable;

    function removeLiquidity(
        NftRemoveLiquidity memory removeLiquidityParams
    ) external;

    function swapExactTokensForTokens(
        SwapParams memory swap
    ) external payable;
}
