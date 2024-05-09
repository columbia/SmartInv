1 /*
2 * ETHEREUM ACCUMULATIVE SMARTCONTRACT
3 * Web              - https://easycash.co
4 * EN  Telegram_chat: https://t.me/EasyCash_en
5 * 
6 *  - GAIN 4-5% OF YOUR DEPOSIT  PER 24 HOURS (every 5900 blocks)
7 *  - 4% IF YOUR TOTAL DEPOSIT 0.01-1 ETH
8 *  - 4.25% IF YOUR TOTAL DEPOSIT 1-10 ETH
9 *  - 4.5% IF YOUR TOTAL DEPOSIT 10-20 ETH
10 *  - 4.75% IF YOUR TOTAL DEPOSIT 20-40 ETH
11 *  - 5% IF YOUR TOTAL DEPOSIT 40+ ETH
12 *  - Life-long payments
13 *  - The revolutionary reliability
14 *  - Minimal contribution is 0.01 eth
15 *  - Currency and payment - ETH
16 *  - !!!It is not allowed to transfer from exchanges, only from your personal ETH wallet!!!
17 *  - Contribution allocation schemes:
18 *    -- 88% payments
19 *    -- 12% Marketing + Operating Expenses
20 *
21 *   ---About the Project
22 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
23 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
24 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
25 *  freely accessed online. In order to insure our investors' complete security, full control over the 
26 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
27 *  system's permanent autonomous functioning.
28 * 
29 * ---How to use:
30 *  1. Send from ETH wallet to the smart contract address "0xac0ef38712138479Ed76E0184937B753239dab03"
31 *     any amount above 0.01 ETH.
32 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
33 *     of your wallet.
34 *  3a. Claim your profit by sending 0 ether transaction 
35 *  OR
36 *  3b. For reinvest, you need first to remove the accumulated percentage of charges (by sending 0 ether 
37 *      transaction), and only after that, deposit the amount that you want to reinvest.
38 *  
39 * RECOMMENDED GAS LIMIT: 200000
40 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
41 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
42 *
43 * 
44 * Contracts reviewed and approved by pros!
45 */
46 pragma solidity ^0.4.18;
47 
48 contract EasyCash {
49     mapping (address => uint256) invested;
50     mapping (address => uint256) atBlock;
51     uint256 minValue; 
52     address owner1;    // 10%
53     address owner2;    // 1%
54     address owner3;    // 1%
55     event Withdraw (address indexed _to, uint256 _amount);
56     event Invested (address indexed _to, uint256 _amount);
57     
58     constructor () public {
59         owner1 = 0x6fDb012E4a57623eA74Cc1a6E5095Cda63f2C767;    // 10%
60         owner2 = 0xf62f85457f97CE475AAa5523C5739Aa8d4ba64C1;    // 1%
61         owner3 = 0xf62f85457f97CE475AAa5523C5739Aa8d4ba64C1;    // 1%
62         minValue = 0.01 ether; //min amount for transaction
63     }
64     
65     /**
66      * This function calculated percent
67      * less than 1 Ether    - 4.0  %
68      * 1-10 Ether           - 4.25 %
69      * 10-20 Ether          - 4.5  %
70      * 20-40 Ether          - 4.75 %
71      * more than 40 Ether   - 5.0  %
72      */
73         function getPercent(address _investor) internal view returns (uint256) {
74         uint256 percent = 400;
75         if(invested[_investor] >= 1 ether && invested[_investor] < 10 ether) {
76             percent = 425;
77         }
78 
79         if(invested[_investor] >= 10 ether && invested[_investor] < 20 ether) {
80             percent = 450;
81         }
82 
83         if(invested[_investor] >= 20 ether && invested[_investor] < 40 ether) {
84             percent = 475;
85         }
86 
87         if(invested[_investor] >= 40 ether) {
88             percent = 500;
89         }
90         
91         return percent;
92     }
93     
94     /**
95      * Main function
96      */
97     function () external payable {
98         require (msg.value == 0 || msg.value >= minValue,"Min Amount for investing is 0.01 Ether.");
99         
100         uint256 invest = msg.value;
101         address sender = msg.sender;
102         //fee owners
103         owner1.transfer(invest / 10);
104         owner2.transfer(invest / 100);
105         owner3.transfer(invest / 100);
106             
107         if (invested[sender] != 0) {
108             uint256 amount = invested[sender] * getPercent(sender) / 10000 * (block.number - atBlock[sender]) / 5900;
109 
110             //fee sender
111             sender.transfer(amount);
112             emit Withdraw (sender, amount);
113         }
114 
115         atBlock[sender] = block.number;
116         invested[sender] += invest;
117         if (invest > 0){
118             emit Invested(sender, invest);
119         }
120     }
121     
122     /**
123      * This function show deposit
124      */
125     function showDeposit (address _deposit) public view returns(uint256) {
126         return invested[_deposit];
127     }
128 
129     /**
130      * This function show block of last change
131      */
132     function showLastChange (address _deposit) public view returns(uint256) {
133         return atBlock[_deposit];
134     }
135 
136     /**
137      * This function show unpayed percent of deposit
138      */
139     function showUnpayedPercent (address _deposit) public view returns(uint256) {
140         uint256 amount = invested[_deposit] * getPercent(_deposit) / 10000 * (block.number - atBlock[_deposit]) / 5900;
141         return amount;
142     }
143 
144 
145 }