1 pragma solidity ^0.4.24;
2 
3 interface token {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract Sale {
8     address private maintoken = 0x2054a15c6822a722378d13c4e4ea85365e46e50b;
9     address private owner = msg.sender;
10     address private owner10 = 0x966c0FD16a4f4292E6E0372e04fbB5c7013AD02e;
11     uint256 private sendtoken;
12     uint256 public cost1token = 0.00014 ether;
13     uint256 private ether90;
14     uint256 private ether10;
15     token public tokenReward;
16     
17     function Sale() public {
18         tokenReward = token(maintoken);
19     }
20     
21     function() external payable {
22         sendtoken = (msg.value)/cost1token;
23         if (msg.value >= 5 ether) {
24             sendtoken = (msg.value)/cost1token;
25             sendtoken = sendtoken*3/2;
26         }
27         if (msg.value >= 15 ether) {
28             sendtoken = (msg.value)/cost1token;
29             sendtoken = sendtoken*2;
30         }
31         if (msg.value >= 25 ether) {
32             sendtoken = (msg.value)/cost1token;
33             sendtoken = sendtoken*3;
34         }
35         tokenReward.transferFrom(owner, msg.sender, sendtoken);
36         
37         ether10 = (msg.value)/10;
38         ether90 = (msg.value)-ether10;
39         owner.transfer(ether90);
40         owner10.transfer(ether10);
41     }
42 }