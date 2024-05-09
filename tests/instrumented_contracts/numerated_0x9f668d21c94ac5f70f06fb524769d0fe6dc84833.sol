1 pragma solidity ^0.4.4;
2 
3 
4 contract ERC20 {
5     function transfer(address _recipient, uint256 amount) public;
6     
7     
8 } 
9 
10 
11 contract ParaTransfer {
12     address public parachute;
13     
14     function ParaTransfer() public {
15         parachute = msg.sender;
16     }    
17         
18     function multiTransfer(ERC20 token, address[] Airdrop, uint256 amount) public {
19         require(msg.sender == parachute);
20         
21         for (uint256 i = 0; i < Airdrop.length; i++) {
22             token.transfer( Airdrop[i], amount * 10 ** 18);
23         }
24     }
25 }