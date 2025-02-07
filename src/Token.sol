// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {
    constructor()
        ERC20("ASHU", "ASHU")
        Ownable(msg.sender) 
    {
        // Mint 1,000,000 tokens directly to the initial owner
        _mint(msg.sender, 5000000 * 10 ** decimals());
    }
}
