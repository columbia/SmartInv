1 pragma solidity ^0.4.13;
2 
3 contract PizzaPoll {
4     mapping (address => bool) pizzaIsLiked;
5     mapping (address => uint) likeCount;
6     mapping (address => uint) dislikeCount;
7 
8     function PizzaPoll() { 
9         likeCount[msg.sender] = 0;
10         dislikeCount[msg.sender] = 0;
11     }
12 
13     function GetLikeCount() returns (uint count){
14         return likeCount[msg.sender];
15     }
16 
17     function GetDislikeCount() returns (uint count) {
18         return dislikeCount[msg.sender];
19     }
20 
21     function Vote (address voterAddress, bool isLiked)
22     {
23         pizzaIsLiked[voterAddress] = isLiked;
24 
25         if (isLiked)
26         {
27             likeCount[msg.sender] += 1;    
28         }
29         else
30         {
31             dislikeCount[msg.sender] += 1;
32         }
33     }
34 }