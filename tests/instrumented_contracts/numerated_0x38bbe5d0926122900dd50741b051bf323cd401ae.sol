1 pragma solidity ^0.4.11;
2 
3 /*
4   Allows owner/seller to deposit ETH in order to participate in
5   an ICO on behalf of the contract so that users can buy directly
6   from this contract with assurances that they will receive their
7   tokens via a user-invoked withdrawal() call once the ICO token
8   creator releases tokens for trading.
9 
10   This affords users the ability to reserve/claim tokens that they
11   were not able to buy in an ICO, before they hit the exchanges.
12 
13 */
14 contract DaoCasinoToken {
15   uint256 public CAP;
16   uint256 public totalEthers;
17   function proxyPayment(address participant) payable;
18   function transfer(address _to, uint _amount) returns (bool success);
19   function balanceOf(address _owner) constant returns (uint256 balance);
20 }
21 
22 contract BETSale {
23   // Store the amount of BET purchased by a buyer
24   mapping (address => uint256) public bet_purchased;
25 
26   // Store the amount of ETH sent in by a buyer. Good to have this record just in case
27   mapping (address => uint256) public eth_sent;
28 
29   // Total BET available to sell
30   uint256 public total_bet_available;
31 
32   // Total BET purchased by all buyers
33   uint256 public total_bet_purchased;
34 
35   // Total BET withdrawn by all buyers
36   uint256 public total_bet_withdrawn;
37 
38   // BET per ETH (price)
39   uint256 public price_per_eth = 900;
40 
41   //  BET token contract address (IOU offering)
42   DaoCasinoToken public token = DaoCasinoToken(0x725803315519de78D232265A8f1040f054e70B98);
43 
44   // The seller's address
45   address seller = 0xB00Ae1e677B27Eee9955d632FF07a8590210B366;
46 
47   // Halt further purchase ability just in case
48   bool public halt_purchases;
49 
50   /*
51     Safety to withdraw all tokens, ONLY if all buyers have already withdrawn their purchases
52   */
53   function withdrawTokens() {
54     if(msg.sender != seller) throw;
55     if(total_bet_withdrawn != total_bet_purchased) throw;
56 
57     // reset everything
58     total_bet_available = 0;
59     total_bet_purchased = 0;
60     total_bet_withdrawn = 0;
61 
62     token.transfer(seller, token.balanceOf(address(this)));
63   }
64 
65   /*
66     Safety to withdraw ETH
67   */
68   function withdrawETH() {
69     if(msg.sender != seller) throw;
70     msg.sender.transfer(this.balance);
71   }
72 
73   /*
74     Initiate ICO purchase
75   */
76   function buyTokens() payable {
77     if(msg.sender != seller) throw;
78     if(token.totalEthers() < token.CAP()) {
79       token.proxyPayment.value(this.balance)(address(this));
80     }
81   }
82 
83   /*
84     Update available BET to purchase
85   */
86   function updateAvailability(uint256 _bet_amount) {
87     if(msg.sender != seller) throw;
88     total_bet_available += _bet_amount;
89   }
90 
91   /*
92     Update BET price
93   */
94   function updatePrice(uint256 _price) {
95     if(msg.sender != seller) throw;
96     price_per_eth = _price;
97   }
98 
99   /*
100     Safety to prevent anymore purchases/sales from occurring in the event of
101     unforeseen issue. Buyer token withdrawals still allowed
102   */
103   function haltPurchases() {
104     if(msg.sender != seller) throw;
105     halt_purchases = true;
106   }
107 
108   function resumePurchases() {
109     if(msg.sender != seller) throw;
110     halt_purchases = false;
111   }
112 
113   function withdraw() {
114     // Dismiss any early or ill attempts at withdrawing
115     if(token.balanceOf(address(this)) == 0 || bet_purchased[msg.sender] == 0) throw;
116 
117     uint256 bet_to_withdraw = bet_purchased[msg.sender];
118 
119     // Clear record of buyer's BET balance before transferring out
120     bet_purchased[msg.sender] = 0;
121 
122     total_bet_withdrawn += bet_to_withdraw;
123 
124     // Distribute tokens to the buyer
125     if(!token.transfer(msg.sender, bet_to_withdraw)) throw;
126   }
127 
128   function purchase() payable {
129     if(halt_purchases) throw;
130 
131     // Determine amount of tokens user wants to/can buy
132     uint256 bet_to_purchase = price_per_eth * msg.value;
133 
134     // Check if we have enough BET left to sell
135     if((total_bet_purchased + bet_to_purchase) > total_bet_available) throw;
136 
137     // Update the amount of BET purchased by user. Also keep track of the total ETH they sent in
138     bet_purchased[msg.sender] += bet_to_purchase;
139     eth_sent[msg.sender] += msg.value;
140 
141     // Update the total amount of BET purchased by all buyers over all periods of availability
142     total_bet_purchased += bet_to_purchase;
143 
144     // Tokens are clearly in the contract, therefore we can release ETH to seller's address
145     seller.transfer(msg.value);
146   }
147 
148   // Fallback function/entry point
149   function () payable {
150     if(msg.value == 0) {
151       withdraw();
152     }
153     else {
154       if(msg.sender == seller) {
155         return;
156       }
157       purchase();
158     }
159   }
160 }