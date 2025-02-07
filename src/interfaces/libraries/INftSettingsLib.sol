// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { INonfungiblePositionManager } from
    "../../interfaces/uniswap/INonfungiblePositionManager.sol";

import {
    INftSettingsRegistry,
    NftSettings,
    NftKey
} from "../INftSettingsRegistry.sol";

interface INftSettingsLib {
    error TokenIdUnchanged();

    function resetNftSettings(
        INftSettingsRegistry nftSettingsRegistry,
        INonfungiblePositionManager nftManager,
        uint256 tokenId
    ) external;

    function setNftSettings(
        INftSettingsRegistry nftSettingsRegistry,
        INonfungiblePositionManager nftManager,
        uint256 tokenId,
        NftSettings calldata settings
    ) external;
}
