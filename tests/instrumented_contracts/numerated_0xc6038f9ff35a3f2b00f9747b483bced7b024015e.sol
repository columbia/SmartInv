1 pragma solidity ^0.4.25;
2 /**
3 *
4 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
5 * 
6 *  - GAIN 4% PER 24 HOURS (every 5900 blocks)
7 *  - Life-long payments
8 *  - The revolutionary reliability
9 *  - Minimal contribution 0.01 eth
10 *  - Currency and payment - ETH
11 *  - Contribution allocation schemes:
12 *    -- 85% payments
13 *    -- 15% Marketing + Operating Expenses
14 *
15 *   ---About the Project
16 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
17 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
18 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
19 *  freely accessed online. In order to insure our investors' complete security, full control over the 
20 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
21 *  system's permanent autonomous functioning.
22 * 
23 * ---How to use:
24 *  1. Send from ETH wallet to this smart contract address
25 *     any amount from 0.01 ETH.
26 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
27 *     of your wallet.
28 *  3a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're 
29 *      spending too much on GAS)
30 *  OR
31 *  3b. For reinvest, you need to first remove the accumulated percentage of charges (by sending 0 ether 
32 *      transaction), and only after that, deposit the amount that you want to reinvest.
33 *  
34 * RECOMMENDED GAS LIMIT: 200000
35 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
36 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
37 *
38 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
39 * have private keys.
40 * 
41 * Contracts reviewed and approved by pros!
42 * 
43 * Main contract - ETHEREUM DISTRIBUTION.
44 */
45 
46 library SafeMath {
47   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     if (_a == 0) {
49       return 0;
50     }
51     c = _a * _b;
52     assert(c / _a == _b);
53     return c;
54   }
55 
56   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
57     return _a / _b;
58   }
59 
60   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
61     assert(_b <= _a);
62     return _a - _b;
63   }
64 
65   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
66     c = _a + _b;
67     assert(c >= _a);
68     return c;
69   }
70 }
71 
72 contract ETH_DISTRIBUTION {
73 	using SafeMath for uint256;
74 
75 	address public constant marketingAddress = 0x2dB7088799a5594A152c8dCf05976508e4EaA3E4;
76 
77 	mapping (address => uint256) deposited;
78 	mapping (address => uint256) withdrew;
79 	mapping (address => uint256) refearned;
80 	mapping (address => uint256) blocklock;
81 
82 	uint256 public totalDepositedWei = 0;
83 	uint256 public totalWithdrewWei = 0;
84 
85 	function() payable external
86 	{
87 		uint256 marketingPerc = msg.value.mul(15).div(100);
88 
89 		marketingAddress.transfer(marketingPerc);
90 		
91 		if (deposited[msg.sender] != 0)
92 		{
93 			address investor = msg.sender;
94 			uint256 depositsPercents = deposited[msg.sender].mul(4).div(100).mul(block.number-blocklock[msg.sender]).div(5900);
95 			investor.transfer(depositsPercents);
96 
97 			withdrew[msg.sender] += depositsPercents;
98 			totalWithdrewWei = totalWithdrewWei.add(depositsPercents);
99 		}
100 
101 		address referrer = bytesToAddress(msg.data);
102 		uint256 refPerc = msg.value.mul(4).div(100);
103 		
104 		if (referrer > 0x0 && referrer != msg.sender)
105 		{
106 			referrer.transfer(refPerc);
107 
108 			refearned[referrer] += refPerc;
109 		}
110 
111 		blocklock[msg.sender] = block.number;
112 		deposited[msg.sender] += msg.value;
113 
114 		totalDepositedWei = totalDepositedWei.add(msg.value);
115 	}
116 
117 	function userDepositedWei(address _address) public view returns (uint256)
118 	{
119 		return deposited[_address];
120     }
121 
122 	function userWithdrewWei(address _address) public view returns (uint256)
123 	{
124 		return withdrew[_address];
125     }
126 
127 	function userDividendsWei(address _address) public view returns (uint256)
128 	{
129 		return deposited[_address].mul(4).div(100).mul(block.number-blocklock[_address]).div(5900);
130     }
131 
132 	function userReferralsWei(address _address) public view returns (uint256)
133 	{
134 		return refearned[_address];
135     }
136 
137 	function bytesToAddress(bytes bys) private pure returns (address addr)
138 	{
139 		assembly {
140 			addr := mload(add(bys, 20))
141 		}
142 	}
143 }