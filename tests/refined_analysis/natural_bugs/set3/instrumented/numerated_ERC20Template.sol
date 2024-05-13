1 pragma solidity ^0.5.0;
2 
3 import "./../../../libs/GSN/Context.sol";
4 import "./../../../libs/token/ERC20/ERC20.sol";
5 import "./../../../libs/token/ERC20/ERC20Detailed.sol";
6 
7 contract ERC20Template is Context, ERC20, ERC20Detailed {
8     
9     constructor () public ERC20Detailed("ERC20 Template", "ERC20T", 9) {
10         _mint(_msgSender(), 10000000000000);
11     }
12 }