1 /*
2 * ETHEREUM ACCUMULATIVE SMARTCONTRACT
3 * Web              - https://EasyCash.co
4 * EN  Telegram_chat: https://t.me/EasyCash_en
5 * RU  Telegram_chat: https://t.me/EasyCash_ru
6 * CN  Telegram_chat: https://t.me/EasyCash_cn
7 * 
8 *  - GAIN 4-5% OF YOUR DEPOSIT  PER 24 HOURS (every 5900 blocks)
9 *  - 4% IF YOUR TOTAL DEPOSIT 0.01-1 ETH
10 *  - 4.25% IF YOUR TOTAL DEPOSIT 1-10 ETH
11 *  - 4.5% IF YOUR TOTAL DEPOSIT 10-20 ETH
12 *  - 4.75% IF YOUR TOTAL DEPOSIT 20-40 ETH
13 *  - 5% IF YOUR TOTAL DEPOSIT 40+ ETH
14 *  - Life-long payments
15 *  - The revolutionary reliability
16 *  - Minimal contribution is 0.01 eth
17 *  - Currency and payment - ETH
18 *  - !!!It is not allowed to transfer from exchanges, only from your personal ETH wallet!!!
19 *
20 *  - Contribution allocation schemes:
21 *    -- 90% payments
22 *    -- 10% Marketing + Operating Expenses
23 *
24 * ---How to use:
25 *  1. Send from ETH wallet to the smart contract address "0x342D4b16B3856cD468cf9d4d33379b8dbC289752"
26 *     any amount above 0.01 ETH.
27 *  2. Verify your transaction in the history of your application or etherscan.io, specifying the address 
28 *     of your wallet.
29 *  3a. Claim your profit by sending 0 ether transaction 
30 *  OR
31 *  3b. For reinvest, you need first to remove the accumulated percentage of charges (by sending 0 ether 
32 *      transaction), and only after that, deposit the amount that you want to reinvest.
33 *  
34 * RECOMMENDED GAS LIMIT: 200000
35 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
36 * You can check the payments on the etherscan.io site, in the "Internal Txns" tab of your wallet.
37 *
38 * 
39 * Contracts reviewed and approved by pros!
40 */
41 pragma solidity ^0.4.24;
42 
43 contract EasyCash {
44     mapping (address => uint256) invested;
45     mapping (address => uint256) atBlock;
46     uint256 minValue; 
47     address owner1;    // 10%
48     event Withdraw (address indexed _to, uint256 _amount);
49     event Invested (address indexed _to, uint256 _amount);
50     
51     constructor () public {
52         owner1 = 0x0D257779Bbe6321d8349eEbCb2f0f5a90409DB80;    // 10%
53         minValue = 0.01 ether; //min amount for transaction
54     }
55     
56     /**
57      * This function calculated percent
58      * less than 1 Ether    - 4.0  %
59      * 1-10 Ether           - 4.25 %
60      * 10-20 Ether          - 4.5  %
61      * 20-40 Ether          - 4.75 %
62      * more than 40 Ether   - 5.0  %
63      */
64         function getPercent(address _investor) internal view returns (uint256) {
65         uint256 percent = 400;
66         if(invested[_investor] >= 1 ether && invested[_investor] < 10 ether) {
67             percent = 425;
68         }
69 
70         if(invested[_investor] >= 10 ether && invested[_investor] < 20 ether) {
71             percent = 450;
72         }
73 
74         if(invested[_investor] >= 20 ether && invested[_investor] < 40 ether) {
75             percent = 475;
76         }
77 
78         if(invested[_investor] >= 40 ether) {
79             percent = 500;
80         }
81         
82         return percent;
83     }
84     
85     /**
86      * Main function
87      */
88     function () external payable {
89         require (msg.value == 0 || msg.value >= minValue,"Min Amount for investing is 0.01 Ether.");
90         
91         uint256 invest = msg.value;
92         address sender = msg.sender;
93         //fee owners
94         owner1.transfer(invest / 10);
95             
96         if (invested[sender] != 0) {
97             uint256 amount = invested[sender] * getPercent(sender) / 10000 * (block.number - atBlock[sender]) / 5900;
98 
99             //fee sender
100             sender.transfer(amount);
101             emit Withdraw (sender, amount);
102         }
103 
104         atBlock[sender] = block.number;
105         invested[sender] += invest;
106         if (invest > 0){
107             emit Invested(sender, invest);
108         }
109     }
110     
111     /**
112      * This function show deposit
113      */
114     function showDeposit (address _deposit) public view returns(uint256) {
115         return invested[_deposit];
116     }
117 
118     /**
119      * This function show block of last change
120      */
121     function showLastChange (address _deposit) public view returns(uint256) {
122         return atBlock[_deposit];
123     }
124 
125     /**
126      * This function show unpayed percent of deposit
127      */
128     function showUnpayedPercent (address _deposit) public view returns(uint256) {
129         uint256 amount = invested[_deposit] * getPercent(_deposit) / 10000 * (block.number - atBlock[_deposit]) / 5900;
130         return amount;
131     }
132 
133 
134 }