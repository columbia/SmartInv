1 /*
2 * ETHEREUM ACCUMULATIVE SMARTCONTRACT
3 * Web              - https://highfiveeth.org
4 * Twitter          - https://twitter.com/highfiveeth
5 * Telegram_channel - https://t.me/highfiveeth
6 * EN  Telegram_chat: https://t.me/highfiveeth_en		
7 * RU  Telegram_chat: https://t.me/highfiveeth_ru
8 * CN  Telegram_chat: https://t.me/highfiveeth_cn
9 * 
10 *  - GAIN 4-5% OF YOUR DEPOSIT  PER 24 HOURS (every 5900 blocks)
11 *  - 4% IF YOUR TOTAL DEPOSIT 0.01-1 ETH
12 *  - 4.25% IF YOUR TOTAL DEPOSIT 1-10 ETH
13 *  - 4.5% IF YOUR TOTAL DEPOSIT 10-20 ETH
14 *  - 4.75% IF YOUR TOTAL DEPOSIT 20-40 ETH
15 *  - 5% IF YOUR TOTAL DEPOSIT 40+ ETH
16 *  - Life-long payments
17 *  - The revolutionary reliability
18 *  - Minimal contribution is 0.01 eth
19 *  - Currency and payment - ETH
20 *  - !!!It is not allowed to transfer from exchanges, only from your personal ETH wallet!!!
21 *  - Contribution allocation schemes:
22 *    -- 88% payments
23 *    -- 12% Marketing + Operating Expenses
24 *
25 *   ---About the Project
26 *  Blockchain-enabled smart contracts have opened a new era of trustless relationships without 
27 *  intermediaries. This technology opens incredible financial possibilities. Our automated investment 
28 *  distribution model is written into a smart contract, uploaded to the Ethereum blockchain and can be 
29 *  freely accessed online. In order to insure our investors' complete security, full control over the 
30 *  project has been transferred from the organizers to the smart contract: nobody can influence the 
31 *  system's permanent autonomous functioning.
32 * 
33 * ---How to use:
34 *  1. Send from ETH wallet to the smart contract address "0x7c2d76735b09de69c1ead5849b3a5176fa688f4a"
35 *     any amount above 0.01 ETH.
36 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
37 *     of your wallet.
38 *  3a. Claim your profit by sending 0 ether transaction 
39 *  OR
40 *  3b. For reinvest, you need first to remove the accumulated percentage of charges (by sending 0 ether 
41 *      transaction), and only after that, deposit the amount that you want to reinvest.
42 *  
43 * RECOMMENDED GAS LIMIT: 200000
44 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
45 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
46 *
47 * 
48 * Contracts reviewed and approved by pros!
49 */
50 pragma solidity ^0.4.25;
51 
52 contract Highfiveeth {
53     mapping (address => uint256) invested;
54     mapping (address => uint256) atBlock;
55     uint256 minValue; 
56     address owner1;    // 10%
57     address owner2;    // 1%
58     address owner3;    // 1%
59     event Withdraw (address indexed _to, uint256 _amount);
60     event Invested (address indexed _to, uint256 _amount);
61     
62     constructor () public {
63         owner1 = 0xA20AFFf23F2F069b7DE37D8bbf9E5ce0BA97989C;    // 10%
64         owner2 = 0x9712dF59b31226C48F1c405E7C7e36c0D1c00031;    // 1%
65         owner3 = 0xC0a411924b146c19e8E07c180aeE4cC945Cc28a2;    // 1%
66         minValue = 0.01 ether; //min amount for transaction
67     }
68     
69     /**
70      * This function calculated percent
71      * less than 1 Ether    - 4.0  %
72      * 1-10 Ether           - 4.25 %
73      * 10-20 Ether          - 4.5  %
74      * 20-40 Ether          - 4.75 %
75      * more than 40 Ether   - 5.0  %
76      */
77         function getPercent(address _investor) internal view returns (uint256) {
78         uint256 percent = 400;
79         if(invested[_investor] >= 1 ether && invested[_investor] < 10 ether) {
80             percent = 425;
81         }
82 
83         if(invested[_investor] >= 10 ether && invested[_investor] < 20 ether) {
84             percent = 450;
85         }
86 
87         if(invested[_investor] >= 20 ether && invested[_investor] < 40 ether) {
88             percent = 475;
89         }
90 
91         if(invested[_investor] >= 40 ether) {
92             percent = 500;
93         }
94         
95         return percent;
96     }
97     
98     /**
99      * Main function
100      */
101     function () external payable {
102         require (msg.value == 0 || msg.value >= minValue,"Min Amount for investing is 0.01 Ether.");
103         
104         uint256 invest = msg.value;
105         address sender = msg.sender;
106         //fee owners
107         owner1.transfer(invest / 10);
108         owner2.transfer(invest / 100);
109         owner3.transfer(invest / 100);
110             
111         if (invested[sender] != 0) {
112             uint256 amount = invested[sender] * getPercent(sender) / 10000 * (block.number - atBlock[sender]) / 5900;
113 
114             //fee sender
115             sender.transfer(amount);
116             emit Withdraw (sender, amount);
117         }
118 
119         atBlock[sender] = block.number;
120         invested[sender] += invest;
121         if (invest > 0){
122             emit Invested(sender, invest);
123         }
124     }
125     
126     /**
127      * This function show deposit
128      */
129     function showDeposit (address _deposit) public view returns(uint256) {
130         return invested[_deposit];
131     }
132 
133     /**
134      * This function show block of last change
135      */
136     function showLastChange (address _deposit) public view returns(uint256) {
137         return atBlock[_deposit];
138     }
139 
140     /**
141      * This function show unpayed percent of deposit
142      */
143     function showUnpayedPercent (address _deposit) public view returns(uint256) {
144         uint256 amount = invested[_deposit] * getPercent(_deposit) / 10000 * (block.number - atBlock[_deposit]) / 5900;
145         return amount;
146     }
147 
148 
149 }