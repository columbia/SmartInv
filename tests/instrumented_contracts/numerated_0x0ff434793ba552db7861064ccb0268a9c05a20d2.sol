1 pragma solidity ^0.4.25;
2 /**
3 *
4 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
5 * Web              - https://doeth.io/
6 * Twitter          - https://twitter.com/eth_do
7 * Telegram_channel - https://t.me/joinchat/JnIiXhAlqjy-7FYaMRso1g
8 *
9 *  - GAIN 4% PER 24 HOURS (every 5900 blocks)
10 *  - Life-long payments
11 *  - The revolutionary reliability
12 *  - Minimal contribution 0.01 eth
13 *  - Currency and payment - ETH
14 *  - Contribution allocation schemes:
15 *    -- 85% payments
16 *    -- 15% Marketing + Operating Expenses
17 *
18 *   ---About the Project
19 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without
20 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment
21 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be
22 *  freely accessed online. In order to insure our investors' complete security, full control over the
23 *  project has been transferred from the organizers to the smart contract: nobody can influence the
24 *  system's permanent autonomous functioning.
25 *
26 * ---How to use:
27 *  1. Send from ETH wallet to the smart contract address 0x0ff434793ba552db7861064ccb0268a9c05a20d2
28 *     any amount from 0.01 ETH.
29 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address
30 *     of your wallet.
31 *  3a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're
32 *      spending too much on GAS)
33 *  OR
34 *  3b. For reinvest, you need to first remove the accumulated percentage of charges (by sending 0 ether
35 *      transaction), and only after that, deposit the amount that you want to reinvest.
36 * 
37 * RECOMMENDED GAS LIMIT: 200000
38 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
39 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
40 *
41 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you
42 * have private keys.
43 *
44 * Contracts reviewed and approved by pros!
45 *
46 * Main contract - DOETH.
47 */
48 library SafeMath {
49   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     if (_a == 0) {
51       return 0;
52     }
53     c = _a * _b;
54     assert(c / _a == _b);
55     return c;
56   }
57 
58   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
59     return _a / _b;
60   }
61 
62   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
63     assert(_b <= _a);
64     return _a - _b;
65   }
66 
67   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
68     c = _a + _b;
69     assert(c >= _a);
70     return c;
71   }
72 }
73 
74 contract DOETH {
75     using SafeMath for uint256;
76 
77     address public constant marketingAddress = 0x2dB7088799a5594A152c8dCf05976508e4EaA3E4;
78 
79     mapping (address => uint256) deposited;
80     mapping (address => uint256) withdrew;
81     mapping (address => uint256) refearned;
82     mapping (address => uint256) blocklock;
83 
84     uint256 public totalDepositedWei = 0;
85     uint256 public totalWithdrewWei = 0;
86 
87     function() payable external
88     {
89         uint256 marketingPerc = msg.value.mul(15).div(100);
90 
91         marketingAddress.transfer(marketingPerc);
92         
93         if (deposited[msg.sender] != 0)
94         {
95             address investor = msg.sender;
96             uint256 depositsPercents = deposited[msg.sender].mul(4).div(100).mul(block.number-blocklock[msg.sender]).div(5900);
97             investor.transfer(depositsPercents);
98 
99             withdrew[msg.sender] += depositsPercents;
100             totalWithdrewWei = totalWithdrewWei.add(depositsPercents);
101         }
102 
103         address referrer = bytesToAddress(msg.data);
104         uint256 refPerc = msg.value.mul(4).div(100);
105         
106         if (referrer > 0x0 && referrer != msg.sender)
107         {
108             referrer.transfer(refPerc);
109 
110             refearned[referrer] += refPerc;
111         }
112 
113         blocklock[msg.sender] = block.number;
114         deposited[msg.sender] += msg.value;
115 
116         totalDepositedWei = totalDepositedWei.add(msg.value);
117     }
118 
119     function userDepositedWei(address _address) public view returns (uint256)
120     {
121         return deposited[_address];
122     }
123 
124     function userWithdrewWei(address _address) public view returns (uint256)
125     {
126         return withdrew[_address];
127     }
128 
129     function userDividendsWei(address _address) public view returns (uint256)
130     {
131         return deposited[_address].mul(4).div(100).mul(block.number-blocklock[_address]).div(5900);
132     }
133 
134     function userReferralsWei(address _address) public view returns (uint256)
135     {
136         return refearned[_address];
137     }
138 
139     function bytesToAddress(bytes bys) private pure returns (address addr)
140     {
141         assembly {
142             addr := mload(add(bys, 20))
143         }
144     }
145 }