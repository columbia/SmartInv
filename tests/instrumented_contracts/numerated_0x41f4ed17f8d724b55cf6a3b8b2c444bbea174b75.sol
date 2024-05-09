1 pragma solidity >=0.4.22 <0.6.0;
2 contract LauWarmContract {
3     // Deployed As 0x41f4ed17f8d724b55cf6a3b8b2c444bbea174b75
4     address public owner;
5     mapping (address => bool) public allowed;
6     mapping (address => address) public account;
7     
8     constructor () public {
9       owner=msg.sender;
10     }
11 	
12 	modifier isOwner() {
13     if (msg.sender != owner) {
14         emit NotOwner(msg.sender);
15         return;
16     }
17     _; 
18     }
19     event NotOwner(address sender);
20     event Error(address sender, address from, address to, uint amount, string mac);
21     event Process(address sender, address from, address to, uint amount, string mac);
22     
23     function allow(address operator,address walletAddr) public isOwner{
24         allowed[operator]=true;
25 	    account[operator]=walletAddr;
26     }
27 
28     function disallow(address operator) public isOwner{
29         allowed[operator]=false;
30     }
31 
32     function process(address to,uint amount, string memory mac) public {
33      if( allowed[msg.sender] != true )  {
34       emit Error(msg.sender,account[msg.sender],to,amount,mac);
35       return ;
36      }
37      emit Process(msg.sender,account[msg.sender],to,amount,mac);
38      return ;
39     }
40     
41    
42 }