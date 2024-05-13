1 pragma solidity ^0.5.0;
2 
3 import "./../../../libs/GSN/Context.sol";
4 import "./../../../libs/token/ERC20/ERC20.sol";
5 import "./../../../libs/token/ERC20/ERC20Detailed.sol";
6 
7 contract LPToken is Context, ERC20, ERC20Detailed {
8     
9     constructor(string memory name, string memory symbol, uint8 decimal, address initReceiver, uint initAmount) 
10     public ERC20Detailed(name, symbol, decimal) {
11         _mint(initReceiver, initAmount);
12     }
13 }