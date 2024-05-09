1 pragma solidity ^0.4.9;
2 
3 contract TimeLock {
4     address user;
5     uint balance;
6     uint depositTime;
7     function () payable {
8       if (user!=0)
9         throw;
10       user = msg.sender;
11       balance = msg.value;
12       depositTime = block.timestamp;
13     }
14     function withdraw (){
15         if (user==0){
16             throw;
17         }
18         
19         if (block.timestamp-depositTime<20*60){
20             throw;
21         }
22         
23         if(!user.send(balance))
24             throw;
25         
26         delete user;
27         
28         
29         
30     }
31 }