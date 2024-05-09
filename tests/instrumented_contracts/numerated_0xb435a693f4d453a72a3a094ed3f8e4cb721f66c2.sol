1 pragma solidity ^0.4.24;
2 
3 contract WhaleKiller {
4     address WhaleAddr;
5     uint constant interest = 5;
6     uint constant whalefee = 1;
7     uint constant maxRoi = 150;
8     uint256 amount = 0;
9     mapping (address => uint256) invested;
10     mapping (address => uint256) timeInvest;
11     mapping (address => uint256) rewards;
12 
13     constructor() public {
14         WhaleAddr = msg.sender;
15     }
16     function () external payable {
17         address sender = msg.sender;
18         
19         if (invested[sender] != 0) {
20             amount = invested[sender] * interest / 100 * (now - timeInvest[sender]) / 1 days;
21             if (msg.value == 0) {
22                 if (amount >= address(this).balance) {
23                     amount = (address(this).balance);
24                 }
25                 if ((rewards[sender] + amount) > invested[sender] * maxRoi / 100) {
26                     amount = invested[sender] * maxRoi / 100 - rewards[sender];
27                     invested[sender] = 0;
28                     rewards[sender] = 0;
29                     sender.transfer(amount);
30                     return;
31                 } else {
32                     sender.transfer(amount);
33                     rewards[sender] += amount;
34                     amount = 0;
35                 }
36             }
37         }
38         timeInvest[sender] = now;
39         invested[sender] += (msg.value + amount);
40         
41         if (msg.value != 0) {
42             WhaleAddr.transfer(msg.value * whalefee / 100);
43             if (invested[sender] > invested[WhaleAddr]) {
44                 WhaleAddr = sender;
45             }  
46         }
47     }
48     function ShowDepositInfo(address _dep) public view returns(uint256 _invested, uint256 _rewards, uint256 _unpaidInterest) {
49         _unpaidInterest = invested[_dep] * interest / 100 * (now - timeInvest[_dep]) / 1 days;
50         return (invested[_dep], rewards[_dep], _unpaidInterest);
51     }
52     function ShowWhaleAddress() public view returns(address) {
53         return WhaleAddr;
54     }
55 }