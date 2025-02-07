// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Farm } from "../structs/FarmStrategyStructs.sol";
import { PositionSettings } from "../structs/PositionSettingsStructs.sol";
import { IPositionSettingsRegistry } from
    "./IPositionSettingsRegistry.sol";

interface IPositionSettingsLib {
    function setPositionSettings(
        IPositionSettingsRegistry nftSettingsRegistry,
        Farm calldata farm,
        PositionSettings calldata settings
    ) external;
}
