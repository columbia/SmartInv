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
13   The buyer's ETH will ONLY be released to the seller AFTER the buyer
14   manually withdraws their tokens by sending this contract a transaction
15   with 0 ETH.
16 
17   In other words, the seller must fulfill the IOU token purchases any time
18   before the cut-off time defined below, otherwise the buyer gains the
19   ability to withdraw their ETH.
20 
21   Estimated Time of Distribution: 3-5 weeks from ICO according to TenX
22   Cut-off Time: ~ August 9, 2017
23 
24   Greetz: blast, cintix
25   Bounty: foobarbizarre@gmail.com (Please report any findings or suggestions!)
26 
27   Thank you
28 */
29 
30 contract ERC20 {
31   function transfer(address _to, uint _value);
32   function balanceOf(address _owner) constant returns (uint balance);
33 }
34 
35 contract IOU {
36   // Store the amount of IOUs purchased by a buyer
37   mapping (address => uint256) public iou_purchased;
38 
39   // Store the amount of ETH sent in by a buyer
40   mapping (address => uint256) public eth_sent;
41 
42   // Total IOUs available to sell
43   uint256 public total_iou_available = 52500000000000000000000;
44 
45   // Total IOUs purchased by all buyers
46   uint256 public total_iou_purchased;
47 
48   //  PAY token contract address (IOU offering)
49   ERC20 public token = ERC20(0xB97048628DB6B661D4C2aA833e95Dbe1A905B280);
50 
51   // The seller's address (to receive ETH upon distribution, and for authing safeties)
52   address seller = 0xB00Ae1e677B27Eee9955d632FF07a8590210B366;
53 
54   // Halt further purchase ability just in case
55   bool public halt_purchases;
56 
57   /*
58     Safety to withdraw all tokens back to seller in the event any get stranded.
59     Does not leave buyers susceptible. If anything, not enough tokens in the contract
60     will enable them to withdraw their ETH so long as the specified block.number has been mined
61   */
62   function withdrawTokens() {
63     if(msg.sender != seller) throw;
64     token.transfer(seller, token.balanceOf(address(this)));
65   }
66 
67   /*
68     Safety to prevent anymore purchases/sales from occurring in the event of
69     unforeseen issue, or if seller wishes to limit this particular sale price
70     and start a new contract with a new price. The contract will of course
71     allow withdrawals to occur still.
72   */
73   function haltPurchases() {
74     if(msg.sender != seller) throw;
75     halt_purchases = true;
76   }
77 
78   function resumePurchases() {
79     if(msg.sender != seller) throw;
80     halt_purchases = false;
81   }
82 
83   function withdraw() payable {
84     /*
85       Main mechanism to ensure a buyer's purchase/ETH/IOU is safe.
86 
87       Refund the buyer's ETH if we're beyond the cut-off date of our distribution
88       promise AND if the contract doesn't have an adequate amount of tokens
89       to distribute to the buyer. Time-sensitive buyer/ETH protection is only
90       applicable if the contract doesn't have adequate tokens for the buyer.
91 
92       The "adequacy" check prevents the seller and/or third party attacker
93       from locking down buyers' ETH by sending in an arbitrary amount of tokens.
94 
95       If for whatever reason the tokens remain locked for an unexpected period
96       beyond the time defined by block.number, patient buyers may still wait until
97       the contract is filled with their purchased IOUs/tokens. Once the tokens
98       are here, they can initiate a withdraw() to retrieve their tokens. Attempting
99       to withdraw any sooner (after the block has been mined, but tokens not arrived)
100       will result in a refund of buyer's ETH.
101     */
102     if(block.number > 4199999 && iou_purchased[msg.sender] > token.balanceOf(address(this))) {
103       // We didn't fulfill our promise to have adequate tokens withdrawable at xx time
104       // Refund the buyer's ETH automatically instead
105       uint256 eth_to_refund = eth_sent[msg.sender];
106 
107       // If the user doesn't have any ETH or tokens to withdraw, get out ASAP
108       if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw;
109 
110       // Adjust total purchased so others can buy
111       total_iou_purchased -= iou_purchased[msg.sender];
112 
113       // Clear record of buyer's ETH and IOU balance before refunding
114       eth_sent[msg.sender] = 0;
115       iou_purchased[msg.sender] = 0;
116 
117       msg.sender.transfer(eth_to_refund);
118       return;
119     }
120 
121     /*
122       Check if there is an adequate amount of tokens in the contract yet
123       and allow the buyer to withdraw tokens and release ETH to the seller if so
124     */
125     if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw;
126 
127     uint256 iou_to_withdraw = iou_purchased[msg.sender];
128     uint256 eth_to_release = eth_sent[msg.sender];
129 
130     // If the user doesn't have any IOUs or ETH to withdraw/release, get out ASAP
131     if(iou_to_withdraw == 0 || eth_to_release == 0) throw;
132 
133     // Clear record of buyer's IOU and ETH balance before transferring out
134     iou_purchased[msg.sender] = 0;
135     eth_sent[msg.sender] = 0;
136 
137     // Distribute tokens to the buyer
138     token.transfer(msg.sender, iou_to_withdraw);
139 
140     // Release buyer's ETH to the seller
141     seller.transfer(eth_to_release);
142   }
143 
144   function purchase() payable {
145     if(halt_purchases) throw;
146 
147     // Determine amount of tokens user wants to/can buy
148     uint256 iou_to_purchase = 160 * msg.value; // price is 160 per ETH
149 
150     // Check if we have enough IOUs left to sell
151     if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw;
152 
153     // Update the amount of IOUs purchased by user. Also keep track of the total ETH they sent in
154     iou_purchased[msg.sender] += iou_to_purchase;
155     eth_sent[msg.sender] += msg.value;
156 
157     // Update the total amount of IOUs purchased by all buyers
158     total_iou_purchased += iou_to_purchase;
159   }
160 
161   // Fallback function/entry point
162   function () payable {
163     if(msg.value == 0) {
164       withdraw();
165     }
166     else {
167       purchase();
168     }
169   }
170 }