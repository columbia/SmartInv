1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4     function transfer(address _recipient, uint256 amount) public;
5     
6 } 
7 
8 
9 contract MultiTransfer {
10     
11     address[] public Airdrop2;
12         
13         
14     function multiTransfer(ERC20 token, address[] Airdrop2, uint256 amount) public {
15         for (uint256 i = 0; i < Airdrop2.length; i++) {
16             token.transfer( Airdrop2[i], amount * 10 ** 18);
17         }
18     }
19 }