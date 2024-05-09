1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  *  - 12% PER 24 HOURS (every 86400 secs)
6  *  - NO COMMISSION
7  *  - NO FEES
8  */
9 contract Easy12 {
10 
11     mapping (address => uint256) dates;
12     mapping (address => uint256) invests;
13 
14     function() external payable {
15         address sender = msg.sender;
16         if (invests[sender] != 0) {
17             uint256 payout = invests[sender] / 100 * 12 * (now - dates[sender]) / 1 days;
18             if (payout > address(this).balance) {
19                 payout = address(this).balance;
20             }
21             sender.transfer(payout);
22         }
23         dates[sender]    = now;
24         invests[sender] += msg.value;
25     }
26 
27 }