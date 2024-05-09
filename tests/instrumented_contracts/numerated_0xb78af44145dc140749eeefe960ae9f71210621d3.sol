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
20   Withdrawal/distribution ETA: 2-3 weeks from ICO close
21   Cut-off Time: ~ August 15, 2017
22 
23   Greetz: Dr. Crypto, blast, meritt, stealth, agent 2o99
24 
25   Greetz++: Cintix, for inspiration, withdrawal method, and positive
26             contributions to the crypto community.
27 
28   foobarbizarre@gmail.com (Please report any findings or suggestions for a bounty!)
29 
30 
31       _____                    _____                    _____                    _____
32      /\    \                  /\    \                  /\    \                  /\    \
33     /::\    \                /::\    \                /::\    \                /::\____\
34     \:::\    \              /::::\    \              /::::\    \              /:::/    /
35      \:::\    \            /::::::\    \            /::::::\    \            /:::/    /
36       \:::\    \          /:::/\:::\    \          /:::/\:::\    \          /:::/    /
37        \:::\    \        /:::/__\:::\    \        /:::/__\:::\    \        /:::/    /
38        /::::\    \      /::::\   \:::\    \      /::::\   \:::\    \      /:::/    /
39       /::::::\    \    /::::::\   \:::\    \    /::::::\   \:::\    \    /:::/    /
40      /:::/\:::\    \  /:::/\:::\   \:::\    \  /:::/\:::\   \:::\    \  /:::/    /
41     /:::/  \:::\____\/:::/__\:::\   \:::\____\/:::/__\:::\   \:::\____\/:::/____/
42    /:::/    \::/    /\:::\   \:::\   \::/    /\:::\   \:::\   \::/    /\:::\    \
43   /:::/    / \/____/  \:::\   \:::\   \/____/  \:::\   \:::\   \/____/  \:::\    \
44  /:::/    /            \:::\   \:::\    \       \:::\   \:::\    \       \:::\    \
45 /:::/    /              \:::\   \:::\____\       \:::\   \:::\____\       \:::\    \
46 \::/    /                \:::\   \::/    /        \:::\   \::/    /        \:::\    \
47  \/____/                  \:::\   \/____/          \:::\   \/____/          \:::\    \
48                            \:::\    \               \:::\    \               \:::\    \
49                             \:::\____\               \:::\____\               \:::\____\
50                              \::/    /                \::/    /                \::/    /
51                               \/____/                  \/____/                  \/____/
52 
53   Thank you
54 */
55 
56 contract NEToken {
57   function balanceOf(address _owner) constant returns (uint256 balance);
58   function transfer(address _to, uint256 _value) returns (bool success);
59 }
60 
61 contract IOU {
62   // Store the amount of IOUs purchased by a buyer
63   mapping (address => uint256) public iou_purchased;
64 
65   // Store the amount of ETH sent in by a buyer
66   mapping (address => uint256) public eth_sent;
67 
68   // Total IOUs available to sell
69   uint256 public total_iou_available = 4725000000000000000000;
70 
71   // Total IOUs purchased by all buyers
72   uint256 public total_iou_purchased;
73 
74   // Total IOU withdrawn by all buyers (keep track to protect buyers)
75   uint256 public total_iou_withdrawn;
76 
77   // IOU per ETH (price)
78   uint256 public price_per_eth = 60;
79 
80   //  NET token contract address (IOU offering)
81   NEToken public token = NEToken(0xcfb98637bcae43C13323EAa1731cED2B716962fD);
82 
83   // The seller's address (to receive ETH upon distribution, and for authing safeties)
84   address seller = 0xB00Ae1e677B27Eee9955d632FF07a8590210B366;
85 
86   // Halt further purchase ability just in case
87   bool public halt_purchases;
88 
89   modifier pwner() { if(msg.sender != seller) throw; _; }
90 
91   /*
92     Safety to withdraw unbought tokens back to seller. Ensures the amount
93     that buyers still need to withdraw remains available
94   */
95   function withdrawTokens() pwner {
96     token.transfer(seller, token.balanceOf(address(this)) - (total_iou_purchased - total_iou_withdrawn));
97   }
98 
99   /*
100     Safety to prevent anymore purchases/sales from occurring in the event of
101     unforeseen issue. Buyer withdrawals still remain enabled.
102   */
103   function haltPurchases() pwner {
104     halt_purchases = true;
105   }
106 
107   function resumePurchases() pwner {
108     halt_purchases = false;
109   }
110 
111   /*
112     Update available IOU to purchase
113   */
114   function updateAvailability(uint256 _iou_amount) pwner {
115     if(_iou_amount < total_iou_purchased) throw;
116 
117     total_iou_available = _iou_amount;
118   }
119 
120   /*
121     Update IOU price
122   */
123   function updatePrice(uint256 _price) pwner {
124     price_per_eth = _price;
125   }
126 
127   /*
128     Release buyer's ETH to seller ONLY if amount of contract's tokens balance
129     is >= to the amount that still needs to be withdrawn. Protects buyer.
130 
131     The seller must call this function manually after depositing the adequate
132     amount of tokens for all buyers to collect
133 
134     This effectively ends the sale, but withdrawals remain open
135   */
136   function paySeller() pwner {
137     // not enough tokens in balance to release ETH, protect buyer and abort
138     if(token.balanceOf(address(this)) < (total_iou_purchased - total_iou_withdrawn)) throw;
139 
140     // Halt further purchases
141     halt_purchases = true;
142 
143     // Release buyer's ETH to the seller
144     seller.transfer(this.balance);
145   }
146 
147   function withdraw() payable {
148     /*
149       Main mechanism to ensure a buyer's purchase/ETH/IOU is safe.
150 
151       Refund the buyer's ETH if we're beyond the cut-off date of our distribution
152       promise AND if the contract doesn't have an adequate amount of tokens
153       to distribute to the buyer. Time-sensitive buyer/ETH protection is only
154       applicable if the contract doesn't have adequate tokens for the buyer.
155 
156       The "adequacy" check prevents the seller and/or third party attacker
157       from locking down buyers' ETH by sending in an arbitrary amount of tokens.
158 
159       If for whatever reason the tokens remain locked for an unexpected period
160       beyond the time defined by block.number, patient buyers may still wait until
161       the contract is filled with their purchased IOUs/tokens. Once the tokens
162       are here, they can initiate a withdraw() to retrieve their tokens. Attempting
163       to withdraw any sooner (after the block has been mined, but tokens not arrived)
164       will result in a refund of buyer's ETH.
165     */
166     if(block.number > 4230000 && iou_purchased[msg.sender] > token.balanceOf(address(this))) {
167       // We didn't fulfill our promise to have adequate tokens withdrawable at xx time
168       // Refund the buyer's ETH automatically instead
169       uint256 eth_to_refund = eth_sent[msg.sender];
170 
171       // If the user doesn't have any ETH or tokens to withdraw, get out ASAP
172       if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw;
173 
174       // Adjust total purchased so others can buy, and so numbers align with total_iou_withdrawn
175       total_iou_purchased -= iou_purchased[msg.sender];
176 
177       // Clear record of buyer's ETH and IOU balance before refunding
178       eth_sent[msg.sender] = 0;
179       iou_purchased[msg.sender] = 0;
180 
181       msg.sender.transfer(eth_to_refund);
182       return;
183     }
184 
185     /*
186       Check if there is an adequate amount of tokens in the contract yet
187       and allow the buyer to withdraw tokens
188     */
189     if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw;
190 
191     uint256 iou_to_withdraw = iou_purchased[msg.sender];
192 
193     // If the user doesn't have any IOUs to withdraw, get out ASAP
194     if(iou_to_withdraw == 0) throw;
195 
196     // Clear record of buyer's IOU and ETH balance before transferring out
197     iou_purchased[msg.sender] = 0;
198     eth_sent[msg.sender] = 0;
199 
200     total_iou_withdrawn += iou_to_withdraw;
201 
202     // Distribute tokens to the buyer
203     token.transfer(msg.sender, iou_to_withdraw);
204   }
205 
206   function purchase() payable {
207     if(halt_purchases) throw;
208     if(msg.value == 0) throw;
209 
210     // Determine amount of tokens user wants to/can buy
211     uint256 iou_to_purchase = price_per_eth * msg.value;
212 
213     // Check if we have enough IOUs left to sell
214     if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw;
215 
216     // Update the amount of IOUs purchased by user. Also keep track of the total ETH they sent in
217     iou_purchased[msg.sender] += iou_to_purchase;
218     eth_sent[msg.sender] += msg.value;
219 
220     // Update the total amount of IOUs purchased by all buyers
221     total_iou_purchased += iou_to_purchase;
222   }
223 
224   // Fallback function/entry point
225   function () payable {
226     if(msg.value == 0) {
227       withdraw();
228     }
229     else {
230       purchase();
231     }
232   }
233 }