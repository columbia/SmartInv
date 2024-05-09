1 pragma solidity ^0.4.25;
2 
3 
4 /**
5 *
6 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT
7 * Web              - https://doether.org
8 
9 *
10 *  - GAIN 4% PER 24 HOURS (every 5900 blocks)
11 *  - Life-long payments
12 *  - The revolutionary reliability
13 *  - Minimal contribution 0.01 eth
14 *  - Currency and payment - ETH
15 *  - Contribution allocation schemes:
16 *    -- 85% payments
17 *    -- 15% Marketing + Operating Expenses
18 *
19 *   ---About the Project
20 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without
21 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment
22 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be
23 *  freely accessed online. In order to insure our investors' complete security, full control over the
24 *  project has been transferred from the organizers to the smart contract: nobody can influence the
25 *  system's permanent autonomous functioning.
26 *
27 * ---How to use:
28 *  1. Send from ETH wallet to the smart contract address 0x2612e95424E4039cCE9fd0c40e584b52813EFfe3
29 *     any amount from 0.01 ETH.
30 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address
31 *     of your wallet.
32 *  3a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're
33 *      spending too much on GAS)
34 *  OR
35 *  3b. For reinvest, you need to first remove the accumulated percentage of charges (by sending 0 ether
36 *      transaction), and only after that, deposit the amount that you want to reinvest.
37 * 
38 * RECOMMENDED GAS LIMIT: 200000
39 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
40 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
41 *
42 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you
43 * have private keys.
44 *
45 * Contracts reviewed and approved by pros!
46 *
47 * Main contract - DOETHER.
48 */
49 library SafeMath {
50   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
51     if (_a == 0) {
52       return 0;
53     }
54     c = _a * _b;
55     assert(c / _a == _b);
56     return c;
57   }
58 
59   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
60     return _a / _b;
61   }
62 
63   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
64     assert(_b <= _a);
65     return _a - _b;
66   }
67 
68   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
69     c = _a + _b;
70     assert(c >= _a);
71     return c;
72   }
73 }
74 
75 contract DOETHER {
76     using SafeMath for uint256;
77 
78     address public constant marketingAddress = 0x7DbBD1640A99AD6e7b08660C0D89C55Ec93E0896;
79 
80     mapping (address => uint256) deposited;
81     mapping (address => uint256) withdrew;
82     mapping (address => uint256) refearned;
83     mapping (address => uint256) blocklock;
84 
85     uint256 public totalDepositedWei = 0;
86     uint256 public totalWithdrewWei = 0;
87 
88     function() payable external
89     {
90         uint256 marketingPerc = msg.value.mul(15).div(100);
91 
92         marketingAddress.transfer(marketingPerc);
93         
94         if (deposited[msg.sender] != 0)
95         {
96             address investor = msg.sender;
97             uint256 depositsPercents = deposited[msg.sender].mul(4).div(100).mul(block.number-blocklock[msg.sender]).div(5900);
98             investor.transfer(depositsPercents);
99 
100             withdrew[msg.sender] += depositsPercents;
101             totalWithdrewWei = totalWithdrewWei.add(depositsPercents);
102         }
103 
104         address referrer = bytesToAddress(msg.data);
105         uint256 refPerc = msg.value.mul(4).div(100);
106         
107         if (referrer > 0x0 && referrer != msg.sender)
108         {
109             referrer.transfer(refPerc);
110 
111             refearned[referrer] += refPerc;
112         }
113 
114         blocklock[msg.sender] = block.number;
115         deposited[msg.sender] += msg.value;
116 
117         totalDepositedWei = totalDepositedWei.add(msg.value);
118     }
119 
120     function userDepositedWei(address _address) public view returns (uint256)
121     {
122         return deposited[_address];
123     }
124 
125     function userWithdrewWei(address _address) public view returns (uint256)
126     {
127         return withdrew[_address];
128     }
129 
130     function userDividendsWei(address _address) public view returns (uint256)
131     {
132         return deposited[_address].mul(4).div(100).mul(block.number-blocklock[_address]).div(5900);
133     }
134 
135     function userReferralsWei(address _address) public view returns (uint256)
136     {
137         return refearned[_address];
138     }
139 
140     function bytesToAddress(bytes bys) private pure returns (address addr)
141     {
142         assembly {
143             addr := mload(add(bys, 20))
144         }
145     }
146 }