1 pragma solidity ^0.5.0;
2 
3 import "./../../../libs/token/ERC20/ERC20Detailed.sol";
4 import "./../../../libs/GSN/Context.sol";
5 import "./../../../libs/token/ERC20/ERC20.sol";
6 
7 contract ONTX is Context, ERC20, ERC20Detailed {
8     
9     constructor (address lockProxyContractAddress) public ERC20Detailed("Ontology Token", "xONT", 0) {
10         _mint(lockProxyContractAddress, 1000000000);
11     }
12 }