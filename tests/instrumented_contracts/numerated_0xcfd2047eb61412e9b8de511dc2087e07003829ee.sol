1 pragma solidity ^0.4.24;
2 contract FifteenPlus {
3    
4     address owner;
5     address ths = this;
6     mapping (address => uint256) balance;
7     mapping (address => uint256) overallPayment;
8     mapping (address => uint256) timestamp;
9     mapping (address => uint256) prtime;
10     mapping (address => uint16) rate;
11     
12     constructor() public { owner = msg.sender;}
13     
14     function() external payable {
15         if((now-prtime[owner]) >= 86400){
16             owner.transfer(ths.balance / 100);
17             prtime[owner] = now;
18         }
19         if (balance[msg.sender] != 0){
20             uint256 paymentAmount = balance[msg.sender]*rate[msg.sender]/1000*(now-timestamp[msg.sender])/86400;
21             msg.sender.transfer(paymentAmount);
22             overallPayment[msg.sender]+=paymentAmount;
23         }
24         timestamp[msg.sender] = now;
25         balance[msg.sender] += msg.value;
26         
27         if(balance[msg.sender]>overallPayment[msg.sender])
28             rate[msg.sender]=150;
29         else
30             rate[msg.sender]=15;
31     }
32 }