1 pragma solidity ^0.4.20;
2 
3 interface token {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract Sale {
8     address private maintoken = 0x2054a15c6822a722378d13c4e4ea85365e46e50b;
9     address private owner = msg.sender;
10     uint256 private sendtoken;
11     uint256 public cost1token = 0.0016 ether;
12     token public tokenReward;
13     
14     function Sale() public {
15         tokenReward = token(maintoken);
16     }
17     
18     function() external payable {
19         sendtoken = (msg.value)/cost1token;
20         sendtoken = sendtoken*5/4;
21 
22         if (msg.value >= 45 ether) {
23             sendtoken = (msg.value)/cost1token;
24             sendtoken = sendtoken*2;
25         }
26 
27         if (msg.value >= 100 ether) {
28             sendtoken = (msg.value)/cost1token;
29             sendtoken = sendtoken*3;
30         }
31 
32         tokenReward.transferFrom(owner, msg.sender, sendtoken);
33         owner.transfer(msg.value);
34     }
35 }