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
39   function subSale() {}
40 
41   function listSubName(bytes32 node,uint price,uint expiry) node_owner(node){
42     require(records[node].subSale != true);
43  
44     records[node].originalOwner=msg.sender;
45     records[node].subSale=true;
46     records[node].subPrice=price;
47     records[node].subExpiry=expiry;
48   }
49 
50   function unlistSubName(bytes32 node) node_owner(node){
51     require(records[node].subSale==true);
52 
53     ens.setOwner(node,records[node].originalOwner);
54 
55     records[node].originalOwner=address(0x0);
56     records[node].subSale=false;
57     records[node].subPrice = 0;
58     records[node].subExpiry = 0;
59   }
60 
61   function nodeCheck(bytes32 node) returns(address){
62     return ens.owner(node);
63   }
64 
65   function subRegistrationPeriod(bytes32 node) returns(uint){
66     return records[node].subExpiry;
67   }
68 
69   function checkSubAvailability(bytes32 node) returns(bool){
70     return records[node].subSale;
71   }
72 
73   function checkSubPrice(bytes32 node) returns(uint){
74     return records[node].subPrice;
75   }
76 
77   function subBuy(bytes32 rootNode,bytes32 subNode,address newOwner) payable {
78     require(records[rootNode].subSale == true);
79     require(msg.value >= records[rootNode].subPrice);
80 
81     var newNode = sha3(rootNode,subNode);
82     require(records[newNode].regPeriod < now);
83 
84     uint fee = msg.value/20;
85     uint netPrice = msg.value - fee;
86 
87     admin.transfer(fee);
88     records[rootNode].originalOwner.transfer(netPrice);
89 
90     records[newNode].regPeriod = now + records[rootNode].subExpiry;
91     records[newNode].subSale = false;
92     records[newNode].subPrice = 0;
93     records[newNode].subExpiry = 0;
94 
95     ens.setSubnodeOwner(rootNode,subNode,newOwner);
96   }
97 
98  function() payable{
99     admin.transfer(msg.value);
100   }
101 
102 }