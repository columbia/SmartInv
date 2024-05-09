1 pragma solidity ^0.4.7;
2 
3 contract FreeMoney {
4     function take() public payable {
5         if (msg.value > 15 finney) {
6             selfdestruct(msg.sender);
7         }
8     }
9     function () public payable {}
10 }