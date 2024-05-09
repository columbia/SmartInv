1 pragma solidity ^0.4.21;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 
9 contract tokenTrust {
10     event Hodl(address indexed hodler, uint indexed amount);
11     event Party(address indexed hodler, uint indexed amount);
12     mapping (address => uint) public hodlers;
13     uint partyTime = 1522095322; // test
14     function() payable {
15         hodlers[msg.sender] += msg.value;
16         Hodl(msg.sender, msg.value);
17     }
18     function party() {
19         require (block.timestamp > partyTime && hodlers[msg.sender] > 0);
20         uint value = hodlers[msg.sender];
21         uint amount = value/100;
22         msg.sender.transfer(amount);
23         Party(msg.sender, amount);
24         partyTime = partyTime + 120;
25     }
26     function withdrawForeignTokens(address _tokenContract) returns (bool) {
27         if (msg.sender != 0x239C09c910ea910994B320ebdC6bB159E71d0b30) { throw; }
28         require (block.timestamp > partyTime);
29         
30         ForeignToken token = ForeignToken(_tokenContract);
31 
32         uint256 amount = token.balanceOf(address(this))/100;
33         return token.transfer(0x239C09c910ea910994B320ebdC6bB159E71d0b30, amount);
34         partyTime = partyTime + 120;
35     }
36 }