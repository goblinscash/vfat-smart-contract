// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { Script, console } from "forge-std/Script.sol";
import { NftZapLib } from "../../src/libraries/NftZapLib.sol";
import { ConnectorRegistry } from "../../src/ConnectorRegistry.sol";
import { ISwapLib } from "../../src/interfaces/libraries/ISwapLib.sol";

contract NftZapLibScript is Script {
    NftZapLib public nftZapLib;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address connectorRegistry = 0x7d540FC712004c30A288962abAc7b47A86907734;
        address swapLib = 0x98dc8aC4a5AcCbc17bBd91E8cFceb9fc2F317802;

        nftZapLib = new NftZapLib(ConnectorRegistry(connectorRegistry), ISwapLib(swapLib));

        vm.stopBroadcast();
    }
}
