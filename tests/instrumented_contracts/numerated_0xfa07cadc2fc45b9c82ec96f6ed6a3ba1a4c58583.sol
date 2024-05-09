1 pragma solidity  ^0.6.3;
2 
3 contract SMatrixMoney {
4    
5 function multisend(uint256[] memory amounts, address payable[] memory receivers) payable public {
6 assert(amounts.length == receivers.length);
7 assert(receivers.length <= 100); //maximum receievers can be 100
8    
9         for(uint i = 0; i< receivers.length; i++){
10             receivers[i].transfer(amounts[i]);
11         }
12     }
13 }