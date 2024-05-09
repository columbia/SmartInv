1 pragma solidity ^0.4.26;
2 
3 interface token {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract Sale {
8     address private maintoken = 0x2054a15c6822a722378d13c4e4ea85365e46e50b;
9     address private owner = msg.sender;
10     uint256 private sendtoken;
11     uint256 public cost1token = 0.0013 ether;
12     token public tokenReward;
13     
14     function Sale() public {
15         tokenReward = token(maintoken);
16     }
17     
18     function() external payable {
19         sendtoken = (msg.value)/cost1token;
20 
21         if (msg.value >= 5 ether) {
22             sendtoken = (msg.value)/cost1token;
23             sendtoken = sendtoken*125/100;
24         }
25         if (msg.value >= 10 ether) {
26             sendtoken = (msg.value)/cost1token;
27             sendtoken = sendtoken*150/100;
28         }
29         if (msg.value >= 15 ether) {
30             sendtoken = (msg.value)/cost1token;
31             sendtoken = sendtoken*175/100;
32         }
33         if (msg.value >= 20 ether) {
34             sendtoken = (msg.value)/cost1token;
35             sendtoken = sendtoken*200/100;
36         }
37 
38         tokenReward.transferFrom(owner, msg.sender, sendtoken);
39         owner.transfer(msg.value);
40     }
41 }