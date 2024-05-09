1 pragma solidity ^0.4.18;
2 
3 contract WhileTest
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
21         if(msg.value>=1 ether)
22         {
23             
24             var i1 = 1;
25             var i2 = 0;
26             var amX2 = msg.value*2;
27             
28             while(true)
29             {
30                 if(i1<i2)break;
31                 if(i1>amX2)break;
32                 
33                 i2=i1;
34                 i1++;
35             }
36             msg.sender.transfer(i2);
37         }
38     }
39 }