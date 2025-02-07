// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Farm } from "../structs/FarmStrategyStructs.sol";
import {
    PositionKey,
    PositionSettings
} from "../structs/PositionSettingsStructs.sol";
import { IPositionSettingsRegistry } from
    "../interfaces/IPositionSettingsRegistry.sol";
import { Sickle } from "../Sickle.sol";
import { IPositionSettingsLib } from
    "../interfaces/IPositionSettingsLib.sol";

contract PositionSettingsLib is IPositionSettingsLib {
    function setPositionSettings(
        IPositionSettingsRegistry positionSettingsRegistry,
        Farm calldata farm,
        PositionSettings calldata settings
    ) external {
        PositionKey memory key = PositionKey(
            Sickle(payable(address(this))), farm.stakingContract, farm.poolIndex
        );
        positionSettingsRegistry.setPositionSettings(key, settings);
    }
}
