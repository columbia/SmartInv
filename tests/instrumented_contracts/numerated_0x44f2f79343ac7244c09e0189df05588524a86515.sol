1 pragma solidity ^0.4.11;
2 
3 /*
4   Allows buyers to securely/confidently buy recent ICO tokens that are
5   still non-transferrable, on an IOU basis. Like HitBTC, but with protection,
6   control, and guarantee of either the purchased tokens or ETH refunded.
7 
8   The Buyer's ETH will be locked into the contract until the purchased
9   IOU/tokens arrive here and are ready for the buyer to invoke withdraw(),
10   OR until cut-off time defined below is exceeded and as a result ETH
11   refunds/withdrawals become enabled.
12 
13   In other words, the seller must fulfill the IOU token purchases any time
14   before the cut-off time defined below, otherwise the buyer gains the
15   ability to withdraw their ETH.
16 
17   The buyer's ETH will ONLY be released to the seller AFTER the adequate
18   amount of tokens have been deposited for ALL purchases.
19 
20   Estimated Time of Distribution: 3-5 weeks from ICO according to TenX
21   Cut-off Time: ~ August 9, 2017
22 
23   Greetz: blast, cintix
24   foobarbizarre@gmail.com (Please report any findings or suggestions for a 1 ETH bounty!)
25 
26   Thank you
27 */
28 
29 contract ERC20 {
30   function transfer(address _to, uint _value);
31   function balanceOf(address _owner) constant returns (uint balance);
32 }
33 
34 contract IOU {
35   // Store the amount of IOUs purchased by a buyer
36   mapping (address => uint256) public iou_purchased;
37 
38   // Store the amount of ETH sent in by a buyer
39   mapping (address => uint256) public eth_sent;
40 
41   // Total IOUs available to sell
42   uint256 public total_iou_available = 20000000000000000000;
43 
44   // Total IOUs purchased by all buyers
45   uint256 public total_iou_purchased;
46 
47   // Total IOU withdrawn by all buyers (keep track to protect buyers)
48   uint256 public total_iou_withdrawn;
49 
50   // IOU per ETH (price)
51   uint256 public price_per_eth = 8600;
52 
53   //  PAY token contract address (IOU offering)
54   ERC20 public token = ERC20(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
55 
56   // The seller's address (to receive ETH upon distribution, and for authing safeties)
57   address seller = 0x007937cd579875A1b9e4E485a49Ee8147BC03a37;
58 
59   // Halt further purchase ability just in case
60   bool public halt_purchases;
61 
62   /*
63     Safety to withdraw unbought tokens back to seller. Ensures the amount
64     that buyers still need to withdraw remains available
65   */
66   function withdrawTokens() {
67     if(msg.sender != seller) throw;
68     token.transfer(seller, token.balanceOf(address(this)) - (total_iou_purchased - total_iou_withdrawn));
69   }
70 
71   /*
72     Safety to prevent anymore purchases/sales from occurring in the event of
73     unforeseen issue. Buyer withdrawals still remain enabled.
74   */
75   function haltPurchases() {
76     if(msg.sender != seller) throw;
77     halt_purchases = true;
78   }
79 
80   function resumePurchases() {
81     if(msg.sender != seller) throw;
82     halt_purchases = false;
83   }
84 
85   /*
86     Update available IOU to purchase
87   */
88   function updateAvailability(uint256 _iou_amount) {
89     if(msg.sender != seller) throw;
90     if(_iou_amount < total_iou_purchased) throw;
91 
92     total_iou_available = _iou_amount;
93   }
94 
95   /*
96     Update IOU price
97   */
98   function updatePrice(uint256 _price) {
99     if(msg.sender != seller) throw;
100     price_per_eth = _price;
101   }
102 
103   /*
104     Release buyer's ETH to seller ONLY if amount of contract's tokens balance
105     is >= to the amount that still needs to be withdrawn. Protects buyer.
106 
107     The seller must call this function manually after depositing the adequate
108     amount of tokens for all buyers to collect, as defined by total_iou_purchased
109 
110     This effectively ends the sale, but withdrawals remain open indefinitely
111   */
112   function paySeller() {
113     if(msg.sender != seller) throw;
114 
115     // not enough tokens in balance to release ETH, protect buyer and abort
116     if(token.balanceOf(address(this)) < (total_iou_purchased - total_iou_withdrawn)) throw;
117 
118     // Halt further purchases to prevent accidental over-selling
119     halt_purchases = true;
120 
121     // Release buyer's ETH to the seller
122     seller.transfer(this.balance);
123   }
124 
125   function withdraw() payable {
126     /*
127       Main mechanism to ensure a buyer's purchase/ETH/IOU is safe.
128 
129       Refund the buyer's ETH if we're beyond the cut-off date of our distribution
130       promise AND if the contract doesn't have an adequate amount of tokens
131       to distribute to the buyer. Time-sensitive buyer/ETH protection is only
132       applicable if the contract doesn't have adequate tokens for the buyer.
133 
134       The "adequacy" check prevents the seller and/or third party attacker
135       from locking down buyers' ETH by sending in an arbitrary amount of tokens.
136 
137       If for whatever reason the tokens remain locked for an unexpected period
138       beyond the time defined by block.number, patient buyers may still wait until
139       the contract is filled with their purchased IOUs/tokens. Once the tokens
140       are here, they can initiate a withdraw() to retrieve their tokens. Attempting
141       to withdraw any sooner (after the block has been mined, but tokens not arrived)
142       will result in a refund of buyer's ETH.
143     */
144     if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) {
145       // We didn't fulfill our promise to have adequate tokens withdrawable at xx time
146       // Refund the buyer's ETH automatically instead
147       uint256 eth_to_refund = eth_sent[msg.sender];
148 
149       // If the user doesn't have any ETH or tokens to withdraw, get out ASAP
150       if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw;
151 
152       // Adjust total purchased so others can buy, and so numbers align with total_iou_withdrawn
153       total_iou_purchased -= iou_purchased[msg.sender];
154 
155       // Clear record of buyer's ETH and IOU balance before refunding
156       eth_sent[msg.sender] = 0;
157       iou_purchased[msg.sender] = 0;
158 
159       msg.sender.transfer(eth_to_refund);
160       return;
161     }
162 
163     /*
164       Check if there is an adequate amount of tokens in the contract yet
165       and allow the buyer to withdraw tokens and release ETH to the seller if so
166     */
167     if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw;
168 
169     uint256 iou_to_withdraw = iou_purchased[msg.sender];
170 
171     // If the user doesn't have any IOUs to withdraw/release, get out ASAP
172     if(iou_to_withdraw == 0) throw;
173 
174     // Clear record of buyer's IOU and ETH balance before transferring out
175     iou_purchased[msg.sender] = 0;
176     eth_sent[msg.sender] = 0;
177 
178     total_iou_withdrawn += iou_to_withdraw;
179 
180     // Distribute tokens to the buyer
181     token.transfer(msg.sender, iou_to_withdraw);
182   }
183 
184   function purchase() payable {
185     if(halt_purchases) throw;
186 
187     // Determine amount of tokens user wants to/can buy
188     uint256 iou_to_purchase = price_per_eth * msg.value; // price is 160 per ETH
189 
190     // Check if we have enough IOUs left to sell
191     if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw;
192 
193     // Update the amount of IOUs purchased by user. Also keep track of the total ETH they sent in
194     iou_purchased[msg.sender] += iou_to_purchase;
195     eth_sent[msg.sender] += msg.value;
196 
197     // Update the total amount of IOUs purchased by all buyers
198     total_iou_purchased += iou_to_purchase;
199   }
200 
201   // Fallback function/entry point
202   function () payable {
203     if(msg.value == 0) {
204       withdraw();
205     }
206     else {
207       purchase();
208     }
209   }
210 }