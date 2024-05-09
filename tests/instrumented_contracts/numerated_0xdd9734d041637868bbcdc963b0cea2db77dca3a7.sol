1 pragma solidity ^0.4.10;
2 
3 contract FunGame 
4 {
5     address owner;
6     modifier OnlyOwner() 
7     {
8         if (msg.sender == owner) 
9         _;
10     }
11     function FunGame()
12     {
13         owner = msg.sender;
14     }
15     function TakeMoney() OnlyOwner
16     {
17         owner.transfer(this.balance);
18     }
19     function ChangeOwner(address NewOwner) OnlyOwner 
20     {
21         owner = NewOwner;
22     }
23 }