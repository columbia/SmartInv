1 pragma solidity ^0.4.25;
2 
3 interface token {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract Sale {
8     address private maintoken = 0x1ad1b64f47a9c25cdceff021e5fd124a856ba1b1;
9     address private owner = msg.sender;
10     uint256 private sendtoken;
11     uint256 private cost1token;
12     token public tokenReward;
13     
14     function Sale() public {
15         tokenReward = token(maintoken);
16     }
17     
18     function() external payable {
19         cost1token = 0.0000056 ether;
20         
21         if ( now > 1547586000 ) {
22             cost1token = 0.0000195 ether;
23         }
24 
25         if ( now > 1556226000 ) {
26             cost1token = 0.000028 ether;
27         }
28         
29         sendtoken = (msg.value)/cost1token;
30         tokenReward.transferFrom(owner, msg.sender, sendtoken);
31         owner.transfer(msg.value);
32     }
33 }