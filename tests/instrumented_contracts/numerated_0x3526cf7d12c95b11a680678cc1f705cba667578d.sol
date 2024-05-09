1 pragma solidity ^0.4.17;
2 
3 contract Owned {
4     address public Owner;
5     function Owned() { Owner = msg.sender; }
6     modifier onlyOwner { if ( msg.sender == Owner ) _; }
7 }
8 
9 contract StaffFunds is Owned {
10     address public Owner;
11     mapping (address=>uint) public deposits;
12     
13     function StaffWallet() { Owner = msg.sender; }
14     
15     function() payable { }
16     
17     function deposit() payable { // For employee benefits
18         if( msg.value >= 1 ether ) // prevent dust payments
19             deposits[msg.sender] += msg.value;
20         else return;
21     }
22     
23     function withdraw(uint amount) onlyOwner {  // only BOD can initiate payments as requested
24         uint depo = deposits[msg.sender];
25         deposits[msg.sender] -= msg.value; // MAX: for security re entry attack dnr
26         if( amount <= depo && depo > 0 )
27             msg.sender.send(amount);
28     }
29 //TODO
30     function kill() onlyOwner { 
31         require(this.balance == 0); // MAX: prevent losing funds
32         suicide(msg.sender);
33 	}
34 } // Copyright 2017 RDev, developed for