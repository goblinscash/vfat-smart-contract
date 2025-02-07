// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {UniswapV3Connector} from "../src/connectors/UniswapV3Connector.sol";

contract UniswapV3ConnectorScript is Script {
    UniswapV3Connector public connector;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        connector = new UniswapV3Connector();

        vm.stopBroadcast();
    }
}
