1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.4.24 <0.6.0;

3 contract Lottery {

4         mapping (address => mapping(uint64 => uint))
5         public tickets;
6         uint64 winningId; 
7         bool drawingPhase; 
8         }
9         function reset() external{
10                 delete tickets;
11                 winningId = 0; 
12                 drawingPhase = false;
13         }

14         function enterDrawingPhase() external {
15                 drawingPhase = true;
16         }

17         function draw(uint64 id) external {
18                 require(winningId == 0, "already drawn");
19                 require(id != 0, "invalid winning number");
20                 winningId = id;
21         }
22         function claimReward() external {
23                 require(winningId != 0, "not drawn");
      
24         }
25         function multiBuy(uint[] ids, uint[] amounts)
26         external {
27                 require(winningId == 0, "already drawn");
28                 uint totalAmount = 0;
29                 for (int i = 0; i < ids.length; i++) {
30                 tickets[msg.sender][ids[i]] += amounts[i];
31                 totalAmount += amounts[i];
32         }
33              receivePayment(msg.sender, totalAmount);
34         }
35  }