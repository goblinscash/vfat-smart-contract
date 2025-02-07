// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { SwapParams } from "../structs/LiquidityStructs.sol";
import {
    NftAddLiquidity,
    NftRemoveLiquidity
} from "../structs/NftLiquidityStructs.sol";

struct NftZapIn {
    SwapParams[] swaps;
    NftAddLiquidity addLiquidityParams;
}

struct NftZapOut {
    NftRemoveLiquidity removeLiquidityParams;
    SwapParams[] swaps;
}
