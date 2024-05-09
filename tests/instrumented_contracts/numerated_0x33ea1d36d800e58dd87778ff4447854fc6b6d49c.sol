1 pragma solidity ^ 0.4 .24;
2 
3 
4 contract HermesPayoutAllKiller {
5     function pay(address hermes) public payable {
6         require(hermes.call.value(msg.value)(), "Error");
7     }
8 }