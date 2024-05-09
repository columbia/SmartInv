1 pragma solidity ^0.4.25;
2 
3 interface token {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract Partner {
8     address private maintoken = 0x1ad1b64f47a9c25cdceff021e5fd124a856ba1b1;
9     address private owner = 0xA07eAaac653e2502139Ad23E69b9348CB235C2BC;
10     address private partner = 0xef189f9182ed3f78903b17144994f389dc4ab24c;
11     uint256 private sendtoken;
12     uint256 public cost1token;
13     uint256 private ether60;
14     uint256 private ether40;
15     token public tokenReward;
16     
17     function Partner() public {
18         tokenReward = token(maintoken);
19     }
20     
21     function() external payable {
22         cost1token = 0.0000056 ether;
23         
24         if ( now > 1547586000 ) {
25             cost1token = 0.0000195 ether;
26         }
27 
28         if ( now > 1556226000 ) {
29             cost1token = 0.000028 ether;
30         }
31 
32         sendtoken = (msg.value)/cost1token;
33         tokenReward.transferFrom(owner, msg.sender, sendtoken);
34         
35         ether40 = (msg.value)*40/100;
36         ether60 = (msg.value)-ether40;
37         owner.transfer(ether60);
38         partner.transfer(ether40);
39     }
40 }