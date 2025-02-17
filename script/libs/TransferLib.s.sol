// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TransferLib} from "../../src/libraries/TransferLib.sol";
import {IFeesLib} from "../../src/interfaces/libraries/IFeesLib.sol";
import {WETH} from "solmate/tokens/WETH.sol";

contract TransferLibScript is Script {
    TransferLib public _transferLib;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address feesLibAddress = 0x39318fea5B43BE55615c8c2fa9Ac3913425a8A74; 
        address payable weth = payable(0x4200000000000000000000000000000000000006); 

        _transferLib = new TransferLib(IFeesLib(feesLibAddress), WETH(weth));

        vm.stopBroadcast();
    }
}
