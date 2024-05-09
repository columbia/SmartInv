1 pragma solidity ^0.4.13;
2 
3 contract AbstractENS{
4     function owner(bytes32 node) constant returns(address);
5     function setOwner(bytes32 node, address owner);
6     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
7 }
8 
9 contract Registrar {
10   function transfer(bytes32 _hash, address newOwner);
11   function entries(bytes32 _hash) constant returns (uint, Deed, uint, uint, uint);
12 }
13 
14 contract Deed {
15   address public owner;
16   address public previousOwner;
17 }
18 
19 contract subdomainSale{
20   AbstractENS ens = AbstractENS(0x314159265dD8dbb310642f98f50C066173C1259b);
21   Registrar registrar = Registrar(0x6090A6e47849629b7245Dfa1Ca21D94cd15878Ef);  
22   address admin = 0x8301Fb8945760Fa2B3C669e8F420B8795Dc03766;
23 
24 
25   struct Domain{
26     address originalOwner;
27     uint commitPeriod;
28     uint regPeriod;
29     bool subSale;
30     uint subPrice;
31     uint subExpiry;
32   }
33 
34   mapping(bytes32=>Domain) records;
35 
36   modifier deed_check(bytes32 label){
37      Deed deed;
38      (,deed,,,) = registrar.entries(label); 
39      if(deed.owner() != address(this)) throw;
40      _;
41   }
42  
43   modifier prevOwn_check(bytes32 label){
44     Deed deed;
45      (,deed,,,) = registrar.entries(label); 
46      if(deed.previousOwner() != msg.sender) throw;
47      _;
48   }
49 
50   modifier ens_check(bytes32 node){
51     if(ens.owner(node) != address(this)) throw;
52     _;
53   }
54 
55 
56   modifier recorded_owner(bytes32 node){
57     if (records[node].originalOwner != msg.sender) throw;
58     _;
59   }
60 
61   function subdomainSale() {}
62 
63   function listSubName(bytes32 label,bytes32 node,uint commit, uint price,uint expiry) prevOwn_check(label) deed_check(label) ens_check(node){
64     require(records[node].subSale == false); 
65     require(expiry>=604800);   
66     require(expiry<=commit);
67 
68     records[node].originalOwner=msg.sender;
69     records[node].subSale=true;
70     records[node].subPrice=price;
71     records[node].subExpiry=expiry;
72     records[node].commitPeriod=now + commit + 86400;
73   }
74 
75   function unlistSubName(bytes32 label,bytes32 node) recorded_owner(node) ens_check(node) deed_check(label){
76     require(records[node].commitPeriod <= now);    
77 
78     ens.setOwner(node,records[node].originalOwner);
79     registrar.transfer(label,records[node].originalOwner);
80  
81     records[node].originalOwner=address(0x0);
82     records[node].subSale=false;
83     records[node].subPrice = 0;
84     records[node].subExpiry = 0;
85     records[node].commitPeriod=0;
86   }
87 
88   function nodeCheck(bytes32 node) returns(address){
89     return ens.owner(node);
90   }
91 
92   function subRegistrationPeriod(bytes32 node) returns(uint){
93     return records[node].subExpiry;
94   }
95 
96   function checkSubAvailability(bytes32 node) returns(bool){
97     return records[node].subSale;
98   }
99 
100   function checkSubPrice(bytes32 node) returns(uint){
101     return records[node].subPrice;
102   }
103 
104   function checkCommitPeriod(bytes32 node) returns(uint){
105     return records[node].commitPeriod;
106   }
107 
108   function checkRegPeriod(bytes32 node) returns(uint){
109     return records[node].regPeriod;
110   }
111 
112   function subBuy(bytes32 ensName,bytes32 subNode,bytes32 newNode,address newOwner) payable ens_check(ensName) {
113     require( (records[ensName].subExpiry + now + 5) < records[ensName].commitPeriod );
114     require(records[ensName].subSale == true);
115     require(msg.value >= records[ensName].subPrice);
116     
117     require(records[newNode].regPeriod < now);
118 
119     uint fee = msg.value/20;
120     uint netPrice = msg.value - fee;
121 
122     admin.transfer(fee);
123     records[ensName].originalOwner.transfer(netPrice);
124 
125     records[newNode].regPeriod = now + records[ensName].subExpiry;
126     records[newNode].subSale = false;
127     records[newNode].subPrice = 0;
128     records[newNode].subExpiry = 0;
129     records[newNode].commitPeriod=0;
130 
131     ens.setSubnodeOwner(ensName,subNode,newOwner);
132   }
133 
134  function() payable{
135     admin.transfer(msg.value);
136   }
137 
138 }