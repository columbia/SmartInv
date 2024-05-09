1 pragma solidity ^0.4.8;
2     contract MyEtherTellerEntityDB  {
3         
4         //Author: Nidscom.io
5         //Date: 23 March 2017
6         //Version: MyEtherTellerEntityDB v1.0
7         
8         address public owner;
9         
10 
11         //Entity struct, used to store the Buyer, Seller or Escrow Agent's info.
12         //It is optional, Entities can choose not to register their info/name on the blockchain.
13 
14 
15         struct Entity{
16             string name;
17             string info;      
18         }
19 
20 
21         
22                
23         mapping(address => Entity) public buyerList;
24         mapping(address => Entity) public sellerList;
25         mapping(address => Entity) public escrowList;
26 
27       
28         //Run once the moment contract is created. Set contract creator
29         function MyEtherTellerEntityDB() {
30             owner = msg.sender;
31 
32 
33         }
34 
35 
36 
37         function() payable
38         {
39             //LogFundsReceived(msg.sender, msg.value);
40         }
41 
42         
43         function registerBuyer(string _name, string _info)
44         {
45            
46             buyerList[msg.sender].name = _name;
47             buyerList[msg.sender].info = _info;
48 
49         }
50 
51     
52        
53         function registerSeller(string _name, string _info)
54         {
55             sellerList[msg.sender].name = _name;
56             sellerList[msg.sender].info = _info;
57 
58         }
59 
60         function registerEscrow(string _name, string _info)
61         {
62             escrowList[msg.sender].name = _name;
63             escrowList[msg.sender].info = _info;
64             
65         }
66 
67         function getBuyerFullInfo(address buyerAddress) constant returns (string, string)
68         {
69             return (buyerList[buyerAddress].name, buyerList[buyerAddress].info);
70         }
71 
72         function getSellerFullInfo(address sellerAddress) constant returns (string, string)
73         {
74             return (sellerList[sellerAddress].name, sellerList[sellerAddress].info);
75         }
76 
77         function getEscrowFullInfo(address escrowAddress) constant returns (string, string)
78         {
79             return (escrowList[escrowAddress].name, escrowList[escrowAddress].info);
80         }
81         
82 }