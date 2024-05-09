1 pragma solidity ^0.4.11;
2 
3 contract PTOYToken {
4   function transfer(address _to, uint256 _value);
5   function balanceOf(address _owner) constant returns (uint256 balance);
6 }
7 
8 contract IOU {
9   // Store the amount of IOUs purchased by a buyer
10   mapping (address => uint256) public iou_purchased;
11 
12   // Store the amount of ETH sent in by a buyer
13   mapping (address => uint256) public eth_sent;
14 
15   // Total IOUs available to sell
16   uint256 public total_iou_available = 400000000;
17 
18   // Total IOUs purchased by all buyers
19   uint256 public total_iou_purchased;
20 
21   // Total IOU withdrawn by all buyers (keep track to protect buyers)
22   uint256 public total_iou_withdrawn;
23 
24   uint256 public price_in_wei = 100000000000000;
25 
26   //  MTL token contract address (IOU offering)
27   PTOYToken public token = PTOYToken(0x8Ae4BF2C33a8e667de34B54938B0ccD03Eb8CC06);
28 
29   // The seller's address (to receive ETH upon distribution, and for authing safeties)
30   address seller = 0x006FEd95aD39777938AaE0BaAA11b4cB33dF0F5a;
31 
32   // Halt further purchase ability just in case
33   bool public halt_purchases;
34 
35   modifier pwner() { if(msg.sender != seller) throw; _; }
36 
37   /*
38     Safety to withdraw unbought tokens back to seller. Ensures the amount
39     that buyers still need to withdraw remains available
40   */
41   function withdrawTokens() pwner {
42     token.transfer(seller, token.balanceOf(address(this)) - (total_iou_purchased - total_iou_withdrawn));
43   }
44 
45   /*
46     Safety to prevent anymore purchases/sales from occurring in the event of
47     unforeseen issue. Buyer withdrawals still remain enabled.
48   */
49   function haltPurchases() pwner {
50     halt_purchases = true;
51   }
52 
53   function resumePurchases() pwner {
54     halt_purchases = false;
55   }
56 
57   /*
58     Update available IOU to purchase
59   */
60   function updateAvailability(uint256 _iou_amount) pwner {
61     if(_iou_amount < total_iou_purchased) throw;
62 
63     total_iou_available = _iou_amount;
64   }
65 
66   /*
67     Update IOU price
68   */
69   function updatePrice(uint256 _price) pwner {
70     price_in_wei = _price;
71   }
72 
73   /*
74     Release buyer's ETH to seller ONLY if amount of contract's tokens balance
75     is >= to the amount that still needs to be withdrawn. Protects buyer.
76 
77     The seller must call this function manually after depositing the adequate
78     amount of tokens for all buyers to collect
79 
80     This effectively ends the sale, but withdrawals remain open
81   */
82   function paySeller() pwner {
83     // not enough tokens in balance to release ETH, protect buyer and abort
84     if(token.balanceOf(address(this)) < (total_iou_purchased - total_iou_withdrawn)) throw;
85 
86     // Halt further purchases to prevent accidental over-selling
87     halt_purchases = true;
88 
89     // Release buyer's ETH to the seller
90     seller.transfer(this.balance);
91   }
92 
93   function withdraw() payable {
94     /*
95       Main mechanism to ensure a buyer's purchase/ETH/IOU is safe.
96 
97       Refund the buyer's ETH if we're beyond the cut-off date of our distribution
98       promise AND if the contract doesn't have an adequate amount of tokens
99       to distribute to the buyer. Time-sensitive buyer/ETH protection is only
100       applicable if the contract doesn't have adequate tokens for the buyer.
101 
102       The "adequacy" check prevents the seller and/or third party attacker
103       from locking down buyers' ETH by sending in an arbitrary amount of tokens.
104 
105       If for whatever reason the tokens remain locked for an unexpected period
106       beyond the time defined by block.number, patient buyers may still wait until
107       the contract is filled with their purchased IOUs/tokens. Once the tokens
108       are here, they can initiate a withdraw() to retrieve their tokens. Attempting
109       to withdraw any sooner (after the block has been mined, but tokens not arrived)
110       will result in a refund of buyer's ETH.
111     */
112     if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) {
113       // We didn't fulfill our promise to have adequate tokens withdrawable at xx time
114       // Refund the buyer's ETH automatically instead
115       uint256 eth_to_refund = eth_sent[msg.sender];
116 
117       // If the user doesn't have any ETH or tokens to withdraw, get out ASAP
118       if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw;
119 
120       // Adjust total purchased so others can buy, and so numbers align with total_iou_withdrawn
121       total_iou_purchased -= iou_purchased[msg.sender];
122 
123       // Clear record of buyer's ETH and IOU balance before refunding
124       eth_sent[msg.sender] = 0;
125       iou_purchased[msg.sender] = 0;
126 
127       msg.sender.transfer(eth_to_refund);
128       return;
129     }
130 
131     /*
132       Check if there is an adequate amount of tokens in the contract yet
133       and allow the buyer to withdraw tokens
134     */
135     if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw;
136 
137     uint256 iou_to_withdraw = iou_purchased[msg.sender];
138 
139     // If the user doesn't have any IOUs to withdraw, get out ASAP
140     if(iou_to_withdraw == 0) throw;
141 
142     // Clear record of buyer's IOU and ETH balance before transferring out
143     iou_purchased[msg.sender] = 0;
144     eth_sent[msg.sender] = 0;
145 
146     total_iou_withdrawn += iou_to_withdraw;
147 
148     // Distribute tokens to the buyer
149     token.transfer(msg.sender, iou_to_withdraw);
150   }
151 
152   function purchase() payable {
153     if(halt_purchases) throw;
154     if(msg.value == 0) throw;
155 
156     // Determine amount of tokens user wants to/can buy
157     uint256 iou_to_purchase = (msg.value * 10**8) / price_in_wei;
158 
159     // Check if we have enough IOUs left to sell
160     if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw;
161 
162     // Update the amount of IOUs purchased by user. Also keep track of the total ETH they sent in
163     iou_purchased[msg.sender] += iou_to_purchase;
164     eth_sent[msg.sender] += msg.value;
165 
166     // Update the total amount of IOUs purchased by all buyers
167     total_iou_purchased += iou_to_purchase;
168   }
169 
170   // Fallback function/entry point
171   function () payable {
172     if(msg.value == 0) {
173       withdraw();
174     }
175     else {
176       purchase();
177     }
178   }
179 }