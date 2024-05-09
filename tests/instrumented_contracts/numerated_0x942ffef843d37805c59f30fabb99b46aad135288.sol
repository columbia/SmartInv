1 pragma solidity ^0.4.4;
2 
3 // kovan:   0x722475921ebc15078d4d6c93b4cff43eadf099c2
4 // mainnet: 0x942ffef843d37805c59f30fabb99b46aad135288
5 
6 contract PreTgeExperty {
7 
8   // TGE
9   struct Contributor {
10     address addr;
11     uint256 amount;
12     uint256 timestamp;
13     bool rejected;
14   }
15   Contributor[] public contributors;
16   mapping(address => bool) public isWhitelisted;
17   address public managerAddr;
18   address public whitelistManagerAddr;
19 
20   // wallet
21   struct Tx {
22     address founder;
23     address destAddr;
24     uint256 amount;
25     bool active;
26   }
27   mapping (address => bool) public founders;
28   Tx[] public txs;
29 
30   // preTGE constructor
31   function PreTgeExperty() public {
32     whitelistManagerAddr = 0x8179C4797948cb4922bd775D3BcE90bEFf652b23;
33     managerAddr = 0x9B7A647b3e20d0c8702bAF6c0F79beb8E9B58b25;
34     founders[0xCE05A8Aa56E1054FAFC214788246707F5258c0Ae] = true;
35     founders[0xBb62A710BDbEAF1d3AD417A222d1ab6eD08C37f5] = true;
36     founders[0x009A55A3c16953A359484afD299ebdC444200EdB] = true;
37   }
38 
39   // whitelist address
40   function whitelist(address addr) public isWhitelistManager {
41     isWhitelisted[addr] = true;
42   }
43 
44   function reject(uint256 idx) public isManager {
45     // contributor must exist
46     assert(contributors[idx].addr != 0);
47     // contribution cant be rejected
48     assert(!contributors[idx].rejected);
49 
50     // de-whitelist address
51     isWhitelisted[contributors[idx].addr] = false;
52 
53     // reject contribution
54     contributors[idx].rejected = true;
55 
56     // return ETH to contributor
57     contributors[idx].addr.transfer(contributors[idx].amount);
58   }
59 
60   // contribute function
61   function() public payable {
62     // allow to contribute only whitelisted KYC addresses
63     assert(isWhitelisted[msg.sender]);
64 
65     // save contributor for further use
66     contributors.push(Contributor({
67       addr: msg.sender,
68       amount: msg.value,
69       timestamp: block.timestamp,
70       rejected: false
71     }));
72   }
73 
74   // one of founders can propose destination address for ethers
75   function proposeTx(address destAddr, uint256 amount) public isFounder {
76     txs.push(Tx({
77       founder: msg.sender,
78       destAddr: destAddr,
79       amount: amount,
80       active: true
81     }));
82   }
83 
84   // another founder can approve specified tx and send it to destAddr
85   function approveTx(uint8 txIdx) public isFounder {
86     assert(txs[txIdx].founder != msg.sender);
87     assert(txs[txIdx].active);
88 
89     txs[txIdx].active = false;
90     txs[txIdx].destAddr.transfer(txs[txIdx].amount);
91   }
92 
93   // founder who created tx can cancel it
94   function cancelTx(uint8 txIdx) {
95     assert(txs[txIdx].founder == msg.sender);
96     assert(txs[txIdx].active);
97 
98     txs[txIdx].active = false;
99   }
100 
101   // isManager modifier
102   modifier isManager() {
103     assert(msg.sender == managerAddr);
104     _;
105   }
106 
107   // isWhitelistManager modifier
108   modifier isWhitelistManager() {
109     assert(msg.sender == whitelistManagerAddr);
110     _;
111   }
112 
113   // check if msg.sender is founder
114   modifier isFounder() {
115     assert(founders[msg.sender]);
116     _;
117   }
118 
119   // view functions
120   function getContributionsCount(address addr) view returns (uint count) {
121     count = 0;
122     for (uint i = 0; i < contributors.length; ++i) {
123       if (contributors[i].addr == addr) {
124         ++count;
125       }
126     }
127     return count;
128   }
129 
130   function getContribution(address addr, uint idx) view returns (uint amount, uint timestamp, bool rejected) {
131     uint count = 0;
132     for (uint i = 0; i < contributors.length; ++i) {
133       if (contributors[i].addr == addr) {
134         if (count == idx) {
135           return (contributors[i].amount, contributors[i].timestamp, contributors[i].rejected);
136         }
137         ++count;
138       }
139     }
140     return (0, 0, false);
141   }
142 }