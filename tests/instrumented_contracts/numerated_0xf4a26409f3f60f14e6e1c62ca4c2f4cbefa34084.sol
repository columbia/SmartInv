1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // WhiteListed - SENC Token Sale Whitelisting Contract
5 //
6 // Copyright (c) 2018 InfoCorp Technologies Pte Ltd.
7 // http://www.sentinel-chain.org/
8 //
9 // The MIT Licence.
10 // ----------------------------------------------------------------------------
11 
12 // ----------------------------------------------------------------------------
13 // The SENC Token Sale Whitelist Contract is designed to facilitate the features:
14 //
15 // 1. Track whitelisted users and allocations
16 // Each whitelisted user is tracked by its wallet address as well as the maximum
17 // SENC allocation it can purchase.
18 //
19 // 2. Track batches
20 // To prevent a gas war, each contributor will be assigned a batch number that
21 // corresponds to the time that the contributor can start purchasing.
22 //
23 // 3. Whitelist Operators
24 // A primary and a secondary operators can be assigned to facilitate the management
25 // of the whiteList.
26 //
27 // ----------------------------------------------------------------------------
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) public onlyOwner {
57     require(newOwner != address(0));
58     OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60   }
61 
62 }
63 
64 contract OperatableBasic {
65     function setPrimaryOperator (address addr) public;
66     function setSecondaryOperator (address addr) public;
67     function isPrimaryOperator(address addr) public view returns (bool);
68     function isSecondaryOperator(address addr) public view returns (bool);
69 }
70 
71 contract Operatable is Ownable, OperatableBasic {
72     address public primaryOperator;
73     address public secondaryOperator;
74 
75     modifier canOperate() {
76         require(msg.sender == primaryOperator || msg.sender == secondaryOperator || msg.sender == owner);
77         _;
78     }
79 
80     function Operatable() public {
81         primaryOperator = owner;
82         secondaryOperator = owner;
83     }
84 
85     function setPrimaryOperator (address addr) public onlyOwner {
86         primaryOperator = addr;
87     }
88 
89     function setSecondaryOperator (address addr) public onlyOwner {
90         secondaryOperator = addr;
91     }
92 
93     function isPrimaryOperator(address addr) public view returns (bool) {
94         return (addr == primaryOperator);
95     }
96 
97     function isSecondaryOperator(address addr) public view returns (bool) {
98         return (addr == secondaryOperator);
99     }
100 }
101 
102 contract WhiteListedBasic is OperatableBasic {
103     function addWhiteListed(address[] addrs, uint[] batches, uint[] weiAllocation) external;
104     function getAllocated(address addr) public view returns (uint);
105     function getBatchNumber(address addr) public view returns (uint);
106     function getWhiteListCount() public view returns (uint);
107     function isWhiteListed(address addr) public view returns (bool);
108     function removeWhiteListed(address addr) public;
109     function setAllocation(address[] addrs, uint[] allocation) public;
110     function setBatchNumber(address[] addrs, uint[] batch) public;
111 }
112 
113 contract WhiteListed is Operatable, WhiteListedBasic {
114 
115     struct Batch {
116         bool isWhitelisted;
117         uint weiAllocated;
118         uint batchNumber;
119     }
120 
121     uint public count;
122     mapping (address => Batch) public batchMap;
123 
124     event Whitelisted(address indexed addr, uint whitelistedCount, bool isWhitelisted, uint indexed batch, uint weiAllocation);
125 
126     function addWhiteListed(address[] addrs, uint[] batches, uint[] weiAllocation) external canOperate {
127         require(addrs.length == batches.length);
128         require(addrs.length == weiAllocation.length);
129         for (uint i = 0; i < addrs.length; i++) {
130             Batch storage batch = batchMap[addrs[i]];
131             if (batch.isWhitelisted != true) {
132                 batch.isWhitelisted = true;
133                 batch.weiAllocated = weiAllocation[i];
134                 batch.batchNumber = batches[i];
135                 count++;
136                 Whitelisted(addrs[i], count, true, batches[i], weiAllocation[i]);
137             }
138         }
139     }
140 
141     function getAllocated(address addr) public view returns (uint) {
142         return batchMap[addr].weiAllocated;
143     }
144 
145     function getBatchNumber(address addr) public view returns (uint) {
146         return batchMap[addr].batchNumber;
147     }
148 
149     function getWhiteListCount() public view returns (uint) {
150         return count;
151     }
152 
153     function isWhiteListed(address addr) public view returns (bool) {
154         return batchMap[addr].isWhitelisted;
155     }
156 
157     function removeWhiteListed(address addr) public canOperate {
158         Batch storage batch = batchMap[addr];
159         require(batch.isWhitelisted == true); 
160         batch.isWhitelisted = false;
161         count--;
162         Whitelisted(addr, count, false, batch.batchNumber, batch.weiAllocated);
163     }
164 
165     function setAllocation(address[] addrs, uint[] weiAllocation) public canOperate {
166         require(addrs.length == weiAllocation.length);
167         for (uint i = 0; i < addrs.length; i++) {
168             if (batchMap[addrs[i]].isWhitelisted == true) {
169                 batchMap[addrs[i]].weiAllocated = weiAllocation[i];
170             }
171         }
172     }
173 
174     function setBatchNumber(address[] addrs, uint[] batch) public canOperate {
175         require(addrs.length == batch.length);
176         for (uint i = 0; i < addrs.length; i++) {
177             if (batchMap[addrs[i]].isWhitelisted == true) {
178                 batchMap[addrs[i]].batchNumber = batch[i];
179             }
180         }
181     }
182 }