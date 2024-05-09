1 pragma solidity ^0.4.18;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7   constructor() public {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 }
16 
17 
18 contract Hold is Ownable {
19     uint public deadline = 1546230000;
20     uint public amountRaised;
21 
22     event GoalReached(address recipient, uint totalAmountRaised);
23     event FundTransfer(address backer, uint amount, bool isContribution);
24 
25 
26     function () payable public {
27         uint amount = msg.value;
28         amountRaised += amount;
29     }
30 
31     modifier afterDeadline() { if (now >= deadline) _; }
32 
33     function safeWithdrawal() public afterDeadline {
34         if (owner.send(amountRaised)) {
35                emit FundTransfer(owner, amountRaised, false);
36         }
37     }
38 }