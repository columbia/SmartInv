1 pragma solidity =0.8.7;
2 
3 import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
4 
5 contract TestToken is ERC20 {
6     constructor(string memory name, string memory symbol) ERC20(name, symbol) public {
7 
8     }
9 
10     function mint(uint256 amount) public {
11         _mint(msg.sender, amount);
12     }
13 }