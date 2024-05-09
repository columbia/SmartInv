1 pragma solidity ^0.4.23;
2 
3 /**
4 *
5 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
6 * Web              - https://333eth.io
7 * Twitter          - https://twitter.com/333eth_io
8 * Telegram_channel - https://t.me/Ethereum333
9 * EN  Telegram_chat: https://t.me/Ethereum333_chat_en
10 * RU  Telegram_chat: https://t.me/Ethereum333_chat_ru
11 * KOR Telegram_chat: https://t.me/Ethereum333_chat_kor
12 * Email:             mailto:support(at sign)333eth.io
13 * 
14 *  - GAIN 3,33% PER 24 HOURS (every 5900 blocks)
15 *  - Life-long payments
16 *  - The revolutionary reliability
17 *  - Minimal contribution 0.01 eth
18 *  - Currency and payment - ETH
19 *  - Contribution allocation schemes:
20 *    -- 83% payments
21 *    -- 17% Marketing + Operating Expenses
22 *
23 *   ---About the Project
24 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
25 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
26 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
27 *  freely accessed online. In order to insure our investors' complete security, full control over the 
28 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
29 *  system's permanent autonomous functioning.
30 * 
31 * ---How to use:
32 *  1. Send from ETH wallet to the smart contract address 0x311f71389e3DE68f7B2097Ad02c6aD7B2dDE4C71
33 *     any amount from 0.01 ETH.
34 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
35 *     of your wallet.
36 *  3a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're 
37 *      spending too much on GAS)
38 *  OR
39 *  3b. For reinvest, you need to first remove the accumulated percentage of charges (by sending 0 ether 
40 *      transaction), and only after that, deposit the amount that you want to reinvest.
41 *  
42 * RECOMMENDED GAS LIMIT: 200000
43 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
44 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
45 *
46 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
47 * have private keys.
48 * 
49 * Contracts reviewed and approved by pros!
50 * 
51 * Main contract - Revolution. Scroll down to find it.
52 */
53 
54 
55 contract InvestorsStorage {
56   struct investor {
57     uint keyIndex;
58     uint value;
59     uint paymentTime;
60     uint refBonus;
61   }
62   struct itmap {
63     mapping(address => investor) data;
64     address[] keys;
65   }
66   itmap private s;
67   address private owner;
68 
69   modifier onlyOwner() {
70     require(msg.sender == owner, "access denied");
71     _;
72   }
73 
74   constructor() public {
75     owner = msg.sender;
76     s.keys.length++;
77   }
78 
79   function insert(address addr, uint value) public onlyOwner returns (bool) {
80     uint keyIndex = s.data[addr].keyIndex;
81     if (keyIndex != 0) return false;
82     s.data[addr].value = value;
83     keyIndex = s.keys.length++;
84     s.data[addr].keyIndex = keyIndex;
85     s.keys[keyIndex] = addr;
86     return true;
87   }
88 
89   function investorFullInfo(address addr) public view returns(uint, uint, uint, uint) {
90     return (
91       s.data[addr].keyIndex,
92       s.data[addr].value,
93       s.data[addr].paymentTime,
94       s.data[addr].refBonus
95     );
96   }
97 
98   function investorBaseInfo(address addr) public view returns(uint, uint, uint) {
99     return (
100       s.data[addr].value,
101       s.data[addr].paymentTime,
102       s.data[addr].refBonus
103     );
104   }
105 
106   function investorShortInfo(address addr) public view returns(uint, uint) {
107     return (
108       s.data[addr].value,
109       s.data[addr].refBonus
110     );
111   }
112 
113   function addRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
114     if (s.data[addr].keyIndex == 0) return false;
115     s.data[addr].refBonus += refBonus;
116     return true;
117   }
118 
119   function addValue(address addr, uint value) public onlyOwner returns (bool) {
120     if (s.data[addr].keyIndex == 0) return false;
121     s.data[addr].value += value;
122     return true;
123   }
124 
125   function setPaymentTime(address addr, uint paymentTime) public onlyOwner returns (bool) {
126     if (s.data[addr].keyIndex == 0) return false;
127     s.data[addr].paymentTime = paymentTime;
128     return true;
129   }
130 
131   function setRefBonus(address addr, uint refBonus) public onlyOwner returns (bool) {
132     if (s.data[addr].keyIndex == 0) return false;
133     s.data[addr].refBonus = refBonus;
134     return true;
135   }
136 
137   function keyFromIndex(uint i) public view returns (address) {
138     return s.keys[i];
139   }
140 
141   function contains(address addr) public view returns (bool) {
142     return s.data[addr].keyIndex > 0;
143   }
144 
145   function size() public view returns (uint) {
146     return s.keys.length;
147   }
148 
149   function iterStart() public pure returns (uint) {
150     return 1;
151   }
152 }