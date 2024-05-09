1 pragma solidity 0.4.18;
2 
3 contract Verification{
4     function() payable public{
5         msg.sender.transfer(msg.value);
6     }
7 }