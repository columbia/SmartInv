1 pragma solidity ^0.4.19;
2 
3 contract MultiSendEth {
4     address public owner;
5     
6     function MultiSendEth() public {
7         owner = msg.sender;
8     }
9     
10     function sendEth(address[] dests, uint256[] values) public payable {
11         require(owner==msg.sender);
12         require(dests.length == values.length);
13         uint256 i = 0;
14         while (i < dests.length) {
15             require(this.balance>=values[i]);
16             dests[i].transfer(values[i]);
17             i++;
18         }
19     }
20     
21     function kill() public {
22         require(owner==msg.sender);
23         selfdestruct(owner);
24     }
25 }