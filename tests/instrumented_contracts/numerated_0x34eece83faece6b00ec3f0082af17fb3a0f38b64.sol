1 pragma solidity ^0.4.25;
2 
3 contract Simply {
4 
5     mapping (address => uint256) dates;
6     mapping (address => uint256) invests;
7 
8     function() external payable {
9         address sender = msg.sender;
10         if (invests[sender] != 0) {
11             uint256 payout = invests[sender] / 100 * (now - dates[sender]) / 1 days;
12             if (payout > address(this).balance) {
13                 payout = address(this).balance;
14             }
15             sender.transfer(payout);
16         }
17         dates[sender]    = now;
18         invests[sender] += msg.value;
19     }
20 
21 }