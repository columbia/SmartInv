1 pragma solidity ^0.4.10;
2 
3 contract ReverseBugBounty {
4     address owner;
5 
6     function () payable {
7         revert; 
8     }
9 
10     function ReverseBugBounty(){
11         owner = msg.sender;
12     }
13     
14     function destroy(){
15         selfdestruct(owner);
16     }
17 }