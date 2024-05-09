1 pragma solidity ^0.4.10;
2 
3 contract Owned {
4     address public Owner;
5     function Owned() { Owner = msg.sender; }
6     modifier onlyOwner { if( msg.sender == Owner ) _; }
7 }
8 
9 contract ETHVault is Owned {
10     address public Owner;
11     mapping (address=>uint) public deposits;
12     
13     function init() { Owner = msg.sender; }
14     
15     function() payable { deposit(); }
16     
17     function deposit() payable {
18         if( msg.value >= 100 finney )
19             deposits[msg.sender] += msg.value;
20         else throw;
21     }
22     
23     function withdraw(uint amount) onlyOwner {
24         uint max = deposits[msg.sender];
25         if( amount <= max && max > 0 )
26             msg.sender.send(amount);
27     }
28     
29     function kill() onlyOwner {
30         require(this.balance == 0);
31         suicide(msg.sender);
32     }
33 }