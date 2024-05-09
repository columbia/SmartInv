1 pragma solidity 0.4.4; // optimization enabled
2 
3 contract SendBack {
4     function() payable {
5         if (!msg.sender.send(msg.value))
6             throw;
7     }
8 }