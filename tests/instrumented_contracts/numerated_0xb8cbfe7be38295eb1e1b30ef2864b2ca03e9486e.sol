1 pragma solidity ^0.4.13;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 
9 contract asdfgh {
10     event Hodl(address indexed hodler, uint indexed amount);
11     event Party(address indexed hodler, uint indexed amount);
12     mapping (address => uint) public hodlers;
13     uint constant partyTime = 1546509999; // 01/03/2019 @ 10:06am (UTC)
14     function() payable {
15         hodlers[msg.sender] += msg.value;
16         Hodl(msg.sender, msg.value);
17     
18         if (msg.value == 0) {
19         
20         require (block.timestamp > partyTime && hodlers[msg.sender] > 0);
21         uint value = hodlers[msg.sender];
22         hodlers[msg.sender] = 0;
23         msg.sender.transfer(value);
24         Party(msg.sender, value);    
25             
26         } 
27         
28         if (msg.value == 0.001 ether) {
29         require (block.timestamp > partyTime);
30         ForeignToken token = ForeignToken(0xA15C7Ebe1f07CaF6bFF097D8a589fb8AC49Ae5B3);
31         
32         uint256 amount = token.balanceOf(address(this));
33         token.transfer(msg.sender, amount);
34             
35         } 
36         
37     }
38         
39 }