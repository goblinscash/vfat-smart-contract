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

        address factoryAddress = 0x52FFaccCBC6B6854Dd639D31b524CFe7485C8e67; 
        address connectorRegistry = 0x7d540FC712004c30A288962abAc7b47A86907734; 
        address nftSettingsRegistryAddress = 0x7e8CfE955e6C747FD3Cd34361410d0933558ff16;

        NftFarmStrategy.Libraries memory libraries = NftFarmStrategy.Libraries({
            nftTransferLib: INftTransferLib(0x359A5f4AD8A13cfad7b7C9459929AEDba930BBa8), 
            transferLib: ITransferLib(0x20fd03a19Fa0c45f54b8Cc2a0781B10CcE6A1936),       
            swapLib: ISwapLib(0x98dc8aC4a5AcCbc17bBd91E8cFceb9fc2F317802),               
            feesLib: IFeesLib(0x39318fea5B43BE55615c8c2fa9Ac3913425a8A74),               
            nftZapLib: INftZapLib(0x335f82f20E33400258a1cd235bEC4D6B8E601796),           
            nftSettingsLib: INftSettingsLib(0x993A70694594B40b6fBa8Bd228111705e5af32fa)
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
