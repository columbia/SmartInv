1 pragma solidity ^0.4.21;
2 
3 interface token {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract Sale {
8     address private maintoken = 0x2f7823aaf1ad1df0d5716e8f18e1764579f4abe6;
9     address private owner90 = 0xf2b9DA535e8B8eF8aab29956823df7237f1863A3;
10     address private owner10 = 0x966c0FD16a4f4292E6E0372e04fbB5c7013AD02e;
11     uint256 private sendtoken;
12     uint256 public cost1token = 0.00379 ether;
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
23         tokenReward.transferFrom(owner90, msg.sender, sendtoken);
24         
25         ether10 = (msg.value)/10;
26         ether90 = (msg.value)-ether10;
27         owner90.transfer(ether90);
28         owner10.transfer(ether10);
29     }
30 }