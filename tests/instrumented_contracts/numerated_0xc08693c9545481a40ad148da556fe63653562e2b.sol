1 pragma solidity ^0.4.24;
2 
3 contract WhaleKiller2 {
4     address WhaleAddr;
5     uint constant interest = 15;
6     uint constant whalefee = 1;
7     uint constant maxRoi = 135;
8     mapping (address => uint256) invested;
9     mapping (address => uint256) timeInvest;
10     mapping (address => uint256) rewards;
11 
12     constructor() public {
13         WhaleAddr = msg.sender;
14     }
15     function () external payable {
16         address sender = msg.sender;
17         uint256 amount = 0;
18         if (invested[sender] != 0) {
19             amount = invested[sender] * interest / 10000 * (now - timeInvest[sender]) / 1 days * (now - timeInvest[sender]) / 1 days;
20             if (msg.value == 0) {
21                 if (amount >= address(this).balance) {
22                     amount = (address(this).balance);
23                 }
24                 if ((rewards[sender] + amount) > invested[sender] * maxRoi / 100) {
25                     amount = invested[sender] * maxRoi / 100 - rewards[sender];
26                     invested[sender] = 0;
27                     rewards[sender] = 0;
28                     sender.transfer(amount);
29                     return;
30                 } else {
31                     sender.transfer(amount);
32                     rewards[sender] += amount;
33                     amount = 0;
34                 }
35             }
36         }
37         timeInvest[sender] = now;
38         invested[sender] += (msg.value + amount);
39         
40         if (msg.value != 0) {
41             WhaleAddr.transfer(msg.value * whalefee / 100);
42             if (invested[sender] > invested[WhaleAddr]) {
43                 WhaleAddr = sender;
44             }  
45         }
46     }
47     function ShowDepositInfo(address _dep) public view returns(uint256 _invested, uint256 _rewards, uint256 _unpaidInterest) {
48         _unpaidInterest = invested[_dep] * interest / 10000 * (now - timeInvest[_dep]) / 1 days * (now - timeInvest[_dep]) / 1 days;
49         return (invested[_dep], rewards[_dep], _unpaidInterest);
50     }
51     function ShowWhaleAddress() public view returns(address) {
52         return WhaleAddr;
53     }
54     function ShowPercent(address _dep) public view returns(uint256 _percent, uint256 _timeInvest, uint256 _now) {
55     _percent = interest / 10000 * (now - timeInvest[_dep]) / 1 days * (now - timeInvest[_dep]) / 1 days;
56     return (_percent, timeInvest[_dep], now);
57     }
58 }