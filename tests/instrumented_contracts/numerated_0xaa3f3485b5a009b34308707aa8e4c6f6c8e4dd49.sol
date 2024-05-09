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
23   Greetz: blast
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
42   uint256 public total_iou_available = 52500000000000000000000;
43 
44   // Total IOUs purchased by all buyers
45   uint256 public total_iou_purchased;
46 
47   // Total IOU withdrawn by all buyers (keep track to protect buyers)
48   uint256 public total_iou_withdrawn;
49 
50   // IOU per ETH (price)
51   uint256 public price_per_eth = 160;
52 
53   //  PAY token contract address (IOU offering)
54   ERC20 public token = ERC20(0xB97048628DB6B661D4C2aA833e95Dbe1A905B280);
55 
56   // The seller's address (to receive ETH upon distribution, and for authing safeties)
57   address seller = 0xB00Ae1e677B27Eee9955d632FF07a8590210B366;
58 
59   // Halt further purchase ability just in case
60   bool public halt_purchases;
61 
62   modifier pwner() { if(msg.sender != seller) throw; _; }
63 
64   /*
65     Safety to withdraw unbought tokens back to seller. Ensures the amount
66     that buyers still need to withdraw remains available
67   */
68   function withdrawTokens() pwner {
69     token.transfer(seller, token.balanceOf(address(this)) - (total_iou_purchased - total_iou_withdrawn));
70   }
71 
72   /*
73     Safety to prevent anymore purchases/sales from occurring in the event of
74     unforeseen issue. Buyer withdrawals still remain enabled.
75   */
76   function haltPurchases() pwner {
77     halt_purchases = true;
78   }
79 
80   function resumePurchases() pwner {
81     halt_purchases = false;
82   }
83 
84   /*
85     Update available IOU to purchase
86   */
87   function updateAvailability(uint256 _iou_amount) pwner {
88     if(_iou_amount < total_iou_purchased) throw;
89 
90     total_iou_available = _iou_amount;
91   }
92 
93   /*
94     Update IOU price
95   */
96   function updatePrice(uint256 _price) pwner {
97     price_per_eth = _price;
98   }
99 
100   /*
101     Release buyer's ETH to seller ONLY if amount of contract's tokens balance
102     is >= to the amount that still needs to be withdrawn. Protects buyer.
103 
104     The seller must call this function manually after depositing the adequate
105     amount of tokens for all buyers to collect
106 
107     This effectively ends the sale, but withdrawals remain open
108   */
109   function paySeller() pwner {
110     // not enough tokens in balance to release ETH, protect buyer and abort
111     if(token.balanceOf(address(this)) < (total_iou_purchased - total_iou_withdrawn)) throw;
112 
113     // Halt further purchases to prevent accidental over-selling
114     halt_purchases = true;
115 
116     // Release buyer's ETH to the seller
117     seller.transfer(this.balance);
118   }
119 
120   function withdraw() payable {
121     /*
122       Main mechanism to ensure a buyer's purchase/ETH/IOU is safe.
123 
124       Refund the buyer's ETH if we're beyond the cut-off date of our distribution
125       promise AND if the contract doesn't have an adequate amount of tokens
126       to distribute to the buyer. Time-sensitive buyer/ETH protection is only
127       applicable if the contract doesn't have adequate tokens for the buyer.
128 
129       The "adequacy" check prevents the seller and/or third party attacker
130       from locking down buyers' ETH by sending in an arbitrary amount of tokens.
131 
132       If for whatever reason the tokens remain locked for an unexpected period
133       beyond the time defined by block.number, patient buyers may still wait until
134       the contract is filled with their purchased IOUs/tokens. Once the tokens
135       are here, they can initiate a withdraw() to retrieve their tokens. Attempting
136       to withdraw any sooner (after the block has been mined, but tokens not arrived)
137       will result in a refund of buyer's ETH.
138     */
139     if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) {
140       // We didn't fulfill our promise to have adequate tokens withdrawable at xx time
141       // Refund the buyer's ETH automatically instead
142       uint256 eth_to_refund = eth_sent[msg.sender];
143 
144       // If the user doesn't have any ETH or tokens to withdraw, get out ASAP
145       if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw;
146 
147       // Adjust total purchased so others can buy, and so numbers align with total_iou_withdrawn
148       total_iou_purchased -= iou_purchased[msg.sender];
149 
150       // Clear record of buyer's ETH and IOU balance before refunding
151       eth_sent[msg.sender] = 0;
152       iou_purchased[msg.sender] = 0;
153 
154       msg.sender.transfer(eth_to_refund);
155       return;
156     }
157 
158     /*
159       Check if there is an adequate amount of tokens in the contract yet
160       and allow the buyer to withdraw tokens
161     */
162     if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw;
163 
164     uint256 iou_to_withdraw = iou_purchased[msg.sender];
165 
166     // If the user doesn't have any IOUs to withdraw, get out ASAP
167     if(iou_to_withdraw == 0) throw;
168 
169     // Clear record of buyer's IOU and ETH balance before transferring out
170     iou_purchased[msg.sender] = 0;
171     eth_sent[msg.sender] = 0;
172 
173     total_iou_withdrawn += iou_to_withdraw;
174 
175     // Distribute tokens to the buyer
176     token.transfer(msg.sender, iou_to_withdraw);
177   }
178 
179   function purchase() payable {
180     if(halt_purchases) throw;
181     if(msg.value == 0) throw;
182 
183     // Determine amount of tokens user wants to/can buy
184     uint256 iou_to_purchase = price_per_eth * msg.value;
185 
186     // Check if we have enough IOUs left to sell
187     if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw;
188 
189     // Update the amount of IOUs purchased by user. Also keep track of the total ETH they sent in
190     iou_purchased[msg.sender] += iou_to_purchase;
191     eth_sent[msg.sender] += msg.value;
192 
193     // Update the total amount of IOUs purchased by all buyers
194     total_iou_purchased += iou_to_purchase;
195   }
196 
197   // Fallback function/entry point
198   function () payable {
199     if(msg.value == 0) {
200       withdraw();
201     }
202     else {
203       purchase();
204     }
205   }
206 }