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

        address connectorRegistry = 0xdBaE2aA28b83b952f7542F87420897F4e12F1A99;
        address swapLib = 0xd98634607C1FEc0dfB925c64037a675eb17a2fc2;

        nftZapLib = new NftZapLib(ConnectorRegistry(connectorRegistry), ISwapLib(swapLib));

        vm.stopBroadcast();
    }
}
