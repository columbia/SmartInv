1 pragma solidity ^0.4.8;
2 
3 contract ventil_ii{ 
4 
5 mapping(address => uint) public balances;
6 
7 event LogDeposit(address sender, uint amount);
8 event LogWithdrawal(address receiver, uint amount);
9 
10 function withdrawFunds(uint amount) public returns(bool success) {
11     require(amount < balances[msg.sender]);
12     LogWithdrawal(msg.sender, amount);
13     msg.sender.transfer(amount);
14     return true;
15 }
16 
17 function () public payable {
18     require(msg.value > 0);
19     uint change;
20     uint dep;
21     if(msg.value > 20) {
22         dep = 20;
23         change = msg.value - change;
24     }
25     balances[msg.sender] += dep;
26     if(change > 0) balances[msg.sender] += change;
27     LogDeposit(msg.sender, msg.value);
28 }
29 
30 }