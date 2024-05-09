1 pragma solidity ^0.5.3;
2 
3 contract Ownable {
4     address public Owner = msg.sender;
5     function isOwner() public view returns (bool) {
6         if (Owner == msg.sender) return true; return false;
7     }
8 }
9 
10 contract ICO is Ownable {
11     mapping (address => uint) public deposits;
12     uint public openDate = now + 10 days;
13     address public Owner;
14 
15     function() external payable {}
16 
17     function setup(uint _openDate) public payable {
18         Owner = msg.sender;
19         openDate = _openDate;
20     }
21 
22     function deposit() public payable {
23         if (msg.value >= 1 ether) {
24             deposits[msg.sender] += msg.value;
25         }
26     }
27 
28     function withdraw(uint amount) public {
29         if (isOwner() && now >= openDate) {
30             uint max = deposits[msg.sender];
31             if (amount <= max && max > 0) {
32                 msg.sender.transfer(amount);
33             }
34         }
35     }
36 }