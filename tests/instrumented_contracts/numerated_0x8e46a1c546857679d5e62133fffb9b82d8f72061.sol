1 /*
2 
3 Custom ETH Contract to send funds to multiple addresses in a single call
4 
5 */
6 
7 
8 pragma solidity  ^0.6.3;
9 
10 contract AutoEtherBot {
11    
12 function multisend(uint256[] memory amounts, address payable[] memory receivers) payable public {
13 assert(amounts.length == receivers.length);
14 assert(receivers.length <= 100); //maximum receievers can be 100
15    
16         for(uint i = 0; i< receivers.length; i++){
17             receivers[i].transfer(amounts[i]);
18         }
19     }
20 }