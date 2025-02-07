// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {NftFarmStrategy} from "../src/strategies/NftFarmStrategy.sol";
import {SickleFactory} from "../src/modules/StrategyModule.sol";
import {ConnectorRegistry} from "../src/ConnectorRegistry.sol";
import {INftSettingsRegistry} from "../src/interfaces/INftSettingsRegistry.sol";

import {INftTransferLib} from "../src/interfaces/libraries/INftTransferLib.sol";
import {ITransferLib} from "../src/interfaces/libraries/ITransferLib.sol";
import {IFeesLib} from "../src/interfaces/libraries/IFeesLib.sol";
import {ISwapLib} from "../src/interfaces/libraries/ISwapLib.sol";
import {INftZapLib} from "../src/interfaces/libraries/INftZapLib.sol";
import {INftSettingsLib} from "../src/interfaces/libraries/INftSettingsLib.sol";




contract NftFarmStrategyScript is Script {
    NftFarmStrategy public connector;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address factoryAddress = 0x62fB598f4a7379Ca36c2d031443F6c97B8F60C3f; 
        address connectorRegistry = 0xdBaE2aA28b83b952f7542F87420897F4e12F1A99; 
        address nftSettingsRegistryAddress = 0xcec6e003108B15FA31A7F5BD80f91aAab3E565CF;

        NftFarmStrategy.Libraries memory libraries = NftFarmStrategy.Libraries({
            nftTransferLib: INftTransferLib(0xa2C3056E4150A9Df0459FEd70Bc735702dC6Cc30), 
            transferLib: ITransferLib(0x64e72a67eaE17aa771D97eA07e3407b171f33Fe5),       
            swapLib: ISwapLib(0xd98634607C1FEc0dfB925c64037a675eb17a2fc2),               
            feesLib: IFeesLib(0x2c2fC8A1CDa7d853a214e294ea40De03d9fC1d2D),               
            nftZapLib: INftZapLib(0x758a3B49A4Fee14B18CC8dFA5CeB547Acc594f21),           
            nftSettingsLib: INftSettingsLib(0x4FDAd64621cd20CCC94164bF81C299ff75346E6a)
        });

        connector = new NftFarmStrategy(
            SickleFactory(factoryAddress),
            ConnectorRegistry(connectorRegistry),
            INftSettingsRegistry(nftSettingsRegistryAddress),
            libraries
        );

        vm.stopBroadcast();
    }
}
