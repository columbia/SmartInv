1 pragma solidity ^0.4.4;
2 
3 contract BountyHunt {
4   mapping(address => uint) public bountyAmount;
5   uint public totalBountyAmount;
6 
7   modifier preventTheft {
8     _;  
9     if (this.balance < totalBountyAmount) throw;
10   }
11 
12   function grantBounty(address beneficiary, uint amount) payable preventTheft {
13     bountyAmount[beneficiary] += amount;
14     totalBountyAmount += amount;
15   }
16 
17   function claimBounty() preventTheft {
18     uint balance = bountyAmount[msg.sender];
19     if (msg.sender.call.value(balance)()) {
20       totalBountyAmount -= balance;
21       bountyAmount[msg.sender] = 0;
22     }   
23   }
24 
25   function transferBounty(address to, uint value) preventTheft {
26     if (bountyAmount[msg.sender] >= value) {
27       bountyAmount[to] += value;
28       bountyAmount[msg.sender] -= value;
29     }   
30   }
31 }