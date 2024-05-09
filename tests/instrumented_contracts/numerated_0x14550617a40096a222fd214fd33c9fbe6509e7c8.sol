1 pragma solidity ^0.4.24;
2 
3 contract WhaleKiller {
4     address WhaleAddr;
5     uint constant public interest = 5;
6     uint constant public whalefee = 1;
7     uint constant public maxRoi = 150;
8     uint256 amount = 0;
9     mapping (address => uint256) invested;
10     mapping (address => uint256) dateInvest;
11     mapping (address => uint256) rewards;
12 
13     constructor() public {
14         WhaleAddr = msg.sender;
15     }
16     function () external payable {
17         address sender = msg.sender;
18         
19         if (invested[sender] != 0) {
20             amount = invested[sender] * interest / 100 * (now - dateInvest[sender]) / 1 days;
21             if (msg.value == 0) {
22                 if (amount >= address(this).balance) {
23                     amount = (address(this).balance);
24                 }
25                 if ((rewards[sender] + amount) > invested[sender] * maxRoi / 100) {
26                     amount = invested[sender] * maxRoi / 100 - rewards[sender];
27                     invested[sender] = 0;
28                     rewards[sender] = 0;
29                     sender.send(amount);
30                     return;
31                 } else {
32                     sender.send(amount);
33                     rewards[sender] += amount;
34                     amount = 0;
35                 }
36             }
37         }
38         dateInvest[sender] = now;
39         invested[sender] += (msg.value + amount);
40         
41         if (msg.value != 0) {
42             WhaleAddr.send(msg.value * whalefee / 100);
43             if (invested[sender] > invested[WhaleAddr]) {
44                 WhaleAddr = sender;
45             }  
46         }
47     }
48     function showDeposit(address _dep) public view returns(uint256) {
49         return (invested[_dep] / 1**18);
50     }
51     function showRewards(address _rew) public view returns(uint256) {
52         return (invested[_rew] / 1**18);
53     }
54     function showWhaleAddr() public view returns(address) {
55         return WhaleAddr;
56     }
57 }