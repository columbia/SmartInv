1 pragma solidity ^0.4.19;
2 
3 interface token {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract Sale {
8     address private maintoken = 0x2f7823aaf1ad1df0d5716e8f18e1764579f4abe6;
9     address private owner = msg.sender;
10     uint256 private sendtoken;
11     uint256 public cost1token = 0.001 ether;
12     token public tokenReward;
13     
14     function Sale() public {
15         tokenReward = token(maintoken);
16     }
17     
18     function() external payable {
19         sendtoken = (msg.value)/cost1token;
20         tokenReward.transferFrom(owner, msg.sender, sendtoken);
21         owner.transfer(msg.value);
22     }
23 }