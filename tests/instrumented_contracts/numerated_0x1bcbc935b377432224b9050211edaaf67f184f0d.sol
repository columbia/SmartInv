1 pragma solidity ^0.4.13;
2 
3 contract AbstractENS{
4 
5     function owner(bytes32 node) constant returns(address);
6     function resolver(bytes32 node) constant returns(address);
7     function ttl(bytes32 node) constant returns(uint64);
8     function setOwner(bytes32 node, address owner);
9     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
10     function setResolver(bytes32 node, address resolver);
11     function setTTL(bytes32 node, uint64 ttl);
12 
13     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
14     event Transfer(bytes32 indexed node, address owner);
15     event NewResolver(bytes32 indexed node, address resolver);
16     event NewTTL(bytes32 indexed node, uint64 ttl);
17 }
18 
19 contract subSale{
20 
21   AbstractENS ens = AbstractENS(0x314159265dD8dbb310642f98f50C066173C1259b);
22   address admin = 0x1f51d1d29AaFb00188168227a49d8f7E5D5b5bD9;
23 
24   struct Domain{
25     address originalOwner;
26     uint regPeriod;
27     bool subSale;
28     uint subPrice;
29     uint subExpiry;
30   }
31 
32   mapping(bytes32=>Domain) records;
33 
34   modifier node_owner(bytes32 node){
35     if (ens.owner(node) != msg.sender) throw;
36     _;
37   }
38 
39   modifier recorded_owner(bytes32 node){
40     if (records[node].originalOwner != msg.sender) throw;
41     _;
42   }
43 
44   function subSale() {}
45 
46   function listSubName(bytes32 node,uint price,uint expiry) node_owner(node){
47     require(records[node].subSale != true);
48  
49     records[node].originalOwner=msg.sender;
50     records[node].subSale=true;
51     records[node].subPrice=price;
52     records[node].subExpiry=expiry;
53   }
54 
55   function unlistSubName(bytes32 node) recorded_owner(node){
56     require(records[node].subSale==true);
57 
58     ens.setOwner(node,records[node].originalOwner);
59 
60     records[node].originalOwner=address(0x0);
61     records[node].subSale=false;
62     records[node].subPrice = 0;
63     records[node].subExpiry = 0;
64   }
65 
66   function nodeCheck(bytes32 node) returns(address){
67     return ens.owner(node);
68   }
69 
70   function subRegistrationPeriod(bytes32 node) returns(uint){
71     return records[node].subExpiry;
72   }
73 
74   function checkSubAvailability(bytes32 node) returns(bool){
75     return records[node].subSale;
76   }
77 
78   function checkSubPrice(bytes32 node) returns(uint){
79     return records[node].subPrice;
80   }
81 
82   function subBuy(bytes32 rootNode,bytes32 subNode,address newOwner) payable {
83     require(records[rootNode].subSale == true);
84     require(msg.value >= records[rootNode].subPrice);
85 
86     var newNode = sha3(rootNode,subNode);
87     require(records[newNode].regPeriod < now);
88 
89     uint fee = msg.value/20;
90     uint netPrice = msg.value - fee;
91 
92     admin.transfer(fee);
93     records[rootNode].originalOwner.transfer(netPrice);
94 
95     records[newNode].regPeriod = now + records[rootNode].subExpiry;
96     records[newNode].subSale = false;
97     records[newNode].subPrice = 0;
98     records[newNode].subExpiry = 0;
99 
100     ens.setSubnodeOwner(rootNode,subNode,newOwner);
101   }
102 
103  function() payable{
104     admin.transfer(msg.value);
105   }
106 
107 }