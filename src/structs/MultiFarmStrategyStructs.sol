// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Farm } from "./FarmStrategyStructs.sol";
import { ZapIn } from "./ZapStructs.sol";
import {
    NftPosition,
    SimpleNftHarvest
} from "./NftFarmStrategyStructs.sol";
import { SwapParams } from "./LiquidityStructs.sol";
import { NftZapIn } from "./NftZapStructs.sol";

struct ClaimParams {
    Farm claimFarm;
    bytes claimExtraData;
}

struct NftClaimParams {
    NftPosition position;
    SimpleNftHarvest harvest;
}

struct MultiCompoundParams {
    ClaimParams[] claims;
    NftClaimParams[] nftClaims;
    address[] rewardTokens;
    ZapIn zap;
    Farm depositFarm;
    bytes depositExtraData;
}

struct NftMultiCompoundParams {
    ClaimParams[] claims;
    NftClaimParams[] nftClaims;
    address[] rewardTokens;
    NftZapIn zap;
    NftPosition depositPosition;
    bytes depositExtraData;
    bool compoundInPlace;
}

struct MultiHarvestParams {
    ClaimParams[] claims;
    NftClaimParams[] nftClaims;
    SwapParams[] swaps;
    address[] tokensOut;
}
