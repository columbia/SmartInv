1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.8.2;
3 
4 contract Squeue {
5   address admin_address;
6   uint32 public numOrders; //max order num
7   bool public allowTipRemoval;
8   bool public paused;
9 
10   event eTip(uint32 oid,uint256 amount);
11   
12   struct OrderStruct {
13     uint32 id; 
14     address owner;    
15     uint256 tipAmount; 
16   }
17   
18   mapping(uint32 => OrderStruct) orders;
19 
20   modifier requireAdmin() {
21     require(admin_address == msg.sender,"Requires admin privileges");
22     _;
23   }
24 
25   modifier requireOwner(uint32 oid) {
26     if (oid >= numOrders) {
27       revert("Order ID out of range");
28     }
29     
30     require(msg.sender == orders[oid].owner,"Not owner of order");
31     _;
32   }
33 
34   modifier requireOwnerOrAdmin(uint32 oid) {
35     if (oid >= numOrders) {
36       revert("Order ID out of range");
37     }
38     
39     require(msg.sender == orders[oid].owner ||
40 	    admin_address == msg.sender,"Not owner or admin");
41     _;
42   }
43 
44   constructor() {
45     numOrders = 0;
46     admin_address = msg.sender;    
47     paused = true;
48     allowTipRemoval = true;
49   }
50   
51   function orderByAddress(address a) public view returns(uint32) {
52     uint32 oid = 0;
53     
54     for (uint32 i = 0;i<numOrders;i++) {
55       if (orders[i].owner == a) {
56 	oid = i;
57 	break;
58       }
59     }
60     return oid;
61   }  
62   
63   function orderDetails(uint32 oid) public view returns (uint32 id, uint256 tipAmount, address owner) {
64     require(oid < numOrders,"Order id not in range");
65     id = orders[oid].id;
66     tipAmount = orders[oid].tipAmount;
67     owner = orders[oid].owner;
68   }
69 
70   function changeTip(uint32 oid,uint256 amount) public requireOwner(oid) {
71     require(!paused,"Contract is paused");
72     if (!allowTipRemoval && amount < orders[oid].tipAmount) {
73       revert("Can only increase tip amount");
74     }
75     orders[oid].tipAmount = amount;
76     emit eTip(oid,amount);
77   }
78 
79   function ownerOf(uint32 oid) public view returns(address) {
80     return orders[oid].owner;
81   }
82 
83   function setPaused(bool p) public requireAdmin {
84     paused = p;
85   }
86 
87   function setAllowTipRemoval(bool p) public requireAdmin {
88     allowTipRemoval = p;
89   }
90 
91   //add addresses and positions. Overwrites existing entries
92   function addEntries(address[] memory a, uint32[] memory ids) public requireAdmin {
93     for (uint32 j=0;j<ids.length;j++) {
94       uint32 i = ids[j];
95       orders[i].owner = a[j];
96       orders[i].id = i;
97       if (i >= numOrders) numOrders = i+1;
98     }
99   }
100   
101   // won't overwrite existing entries
102   function addEntriesNoOverwrite(address[] memory a, uint32[] memory ids) public requireAdmin {
103     for (uint32 j=0;j<ids.length;j++) {
104       uint32 i = ids[j];
105       if (orders[i].id == 0) {
106 	orders[i].owner = a[j];
107 	orders[i].id = i;
108 	if (i >= numOrders) numOrders = i+1;
109       }
110     }
111   }
112 
113   // Allow admin to zero out a tip in case of a mistake
114   function zeroTip(uint32 oid) public requireAdmin {
115     require(!paused,"Contract is paused");    
116     orders[oid].tipAmount = 0;
117     emit eTip(oid,0);
118   }
119 }