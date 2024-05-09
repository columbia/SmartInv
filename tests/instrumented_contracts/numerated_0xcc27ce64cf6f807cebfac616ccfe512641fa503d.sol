1 pragma solidity ^0.4.19;
2 
3 contract SIMPLE_PIGGY_BANK
4 {
5     address creator = msg.sender;
6     
7     mapping (address => uint) public Bal;
8     
9     uint public MinSum = 1 ether;
10     
11     function() 
12     public 
13     payable
14     {
15         Bal[msg.sender]+=msg.value;
16     }  
17     
18     function Collect(uint _am)
19     public
20     payable
21     {
22         if(Bal[msg.sender]>=MinSum && _am<=Bal[msg.sender])
23         {
24             msg.sender.call.value(_am);
25             Bal[msg.sender]-=_am;
26         }
27     }
28     
29     function Break()
30     public
31     payable
32     {
33         if(msg.sender==creator && this.balance>= MinSum)
34         {
35             selfdestruct(msg.sender);
36         }
37     }
38 }