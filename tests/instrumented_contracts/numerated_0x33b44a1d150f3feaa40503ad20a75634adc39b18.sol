1 pragma solidity ^0.4.17;
2 
3 contract Ownable {
4     address public Owner;
5     
6     function Ownable() { Owner = msg.sender; }
7     function isOwner() internal constant returns (bool) { return( Owner == msg.sender); }
8 }
9 
10 contract TimeCapsule is Ownable {
11     address public Owner;
12     mapping (address=>uint) public deposits;
13     uint public openDate;
14     
15     function initCapsule(uint open) {
16         Owner = msg.sender;
17         openDate = open;
18     }
19 
20     function() payable { deposit(); }
21     
22     function deposit() {
23         if( msg.value >= 0.5 ether )
24             deposits[msg.sender] += msg.value;
25         else throw;
26     }
27     
28     function withdraw(uint amount) {
29         if( isOwner() && now >= openDate ) {
30             uint max = deposits[msg.sender];
31             if( amount <= max && max > 0 )
32                 msg.sender.send( amount );
33         }
34     }
35 
36     function kill() {
37         if( isOwner() && this.balance == 0 )
38             suicide( msg.sender );
39 	}
40 }