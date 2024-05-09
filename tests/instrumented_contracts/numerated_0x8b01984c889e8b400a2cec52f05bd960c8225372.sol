1 // Automatically forwards any funds received back to the sender
2 pragma solidity ^0.4.0;
3 contract NoopTransfer {
4     address owner;
5     
6     function NoopTransfer() public {
7         owner = msg.sender;
8     }
9 
10     function () public payable {
11         msg.sender.transfer(this.balance);
12     }
13     
14     function kill() public {
15         require(msg.sender == owner);
16         selfdestruct(owner);
17     }
18 }