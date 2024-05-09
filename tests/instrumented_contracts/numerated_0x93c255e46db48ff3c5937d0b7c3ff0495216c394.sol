1 pragma solidity ^0.4.11;
2 
3 contract ERC20 {
4   function transfer(address _to, uint _value);
5   function balanceOf(address _owner) constant returns (uint balance);
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
16   uint256 public total_iou_available = 20000000000000000000;
17 
18   // Total IOUs purchased by all buyers
19   uint256 public total_iou_purchased;
20 
21   //  BAT token contract address (IOU offering)
22   ERC20 public token = ERC20(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
23 
24   // The seller's address (to receive ETH upon distribution, and for auth withdrawTokens())
25   address seller = 0x00203F5b27CB688a402fBDBdd2EaF8542ffF72B6;
26 
27   // Safety to withdraw all tokens back to seller in the event any get stranded
28   function withdrawTokens() {
29     if(msg.sender != seller) throw;
30     token.transfer(seller, token.balanceOf(address(this)));
31   }
32 
33   function withdrawEth() {
34     if(msg.sender != seller) throw;
35     msg.sender.transfer(this.balance);
36   }
37 
38   function killya() {
39     if(msg.sender != seller) throw;
40     selfdestruct(seller);
41   }
42 
43   function withdraw() payable {
44     /*
45       Main mechanism to ensure a buyer's purchase/ETH/IOU is safe.
46 
47       Refund the buyer's ETH if we're beyond the date of our distribution
48       promise AND if the contract doesn't have an adequate amount of tokens
49       to distribute to the buyer. If we're beyond the given date, yet there
50       is an adequate amount of tokens in the contract's balance, then the
51       buyer can withdraw accordingly. This allows buyers to withdraw well
52       into the future if they need to. It also allows us to extend the sale.
53       Time-sensitive ETH protection is only applicable if the contract
54       doesn't have adequate tokens for the buyer.
55 
56       The "adequacy" check prevents the seller and/or third party attacker
57       from locking down buyers' ETH. i.e. The attacker sends 1 token into our
58       contract to falsely signal that the contract has been filled and is ready
59       for token distribution. If we simply check for a >0 token balance, we risk
60       distribution errors AND stranding/locking the buyer's ETH.
61 
62       TODO: confirm there are no logical errors that will allow a buyer/attacker to
63             withdraw ETH early/unauthorized/doubly/etc
64     */
65     if(block.number > 3943365 && iou_purchased[msg.sender] > token.balanceOf(address(this))) {
66       // We didn't fulfill our promise to have adequate tokens withdrawable at xx time.
67       // Refund the buyer's ETH automatically instead.
68       uint256 eth_to_refund = eth_sent[msg.sender];
69 
70       // If the user doesn't have any ETH or tokens to withdraw, get out ASAP
71       if(eth_to_refund == 0 || iou_purchased[msg.sender] == 0) throw;
72 
73       // Adjust total accurately in the event we allow purchases in the future
74       total_iou_purchased -= iou_purchased[msg.sender];
75 
76       // Clear record of buyer's ETH and IOU balance before refunding
77       eth_sent[msg.sender] = 0;
78       iou_purchased[msg.sender] = 0;
79 
80       msg.sender.transfer(eth_to_refund);
81       return; // ?
82     }
83 
84     /*
85       At this point, we are still before our distribution date promise.
86       Check if there is an adequate amount of tokens in the contract yet
87       and allow buyer's token withdrawal and seller's ETH distribution if so.
88 
89       TODO: confirm there are no logical errors that will allow a buyer/attacker to
90             withdraw IOU tokens early/unauthorized/doubly/etc
91     */
92     if(token.balanceOf(address(this)) == 0 || iou_purchased[msg.sender] > token.balanceOf(address(this))) throw;
93 
94     uint256 iou_to_withdraw = iou_purchased[msg.sender];
95     uint256 eth_to_release = eth_sent[msg.sender];
96 
97     // If the user doesn't have any IOUs or ETH to withdraw/release, get out ASAP
98     if(iou_to_withdraw == 0 || eth_to_release == 0) throw;
99 
100     // Clear record of buyer's IOU and ETH balance before transferring out
101     iou_purchased[msg.sender] = 0;
102     eth_sent[msg.sender] = 0;
103 
104     // Distribute tokens to the buyer
105     token.transfer(msg.sender, iou_to_withdraw);
106 
107     // Release buyer's ETH to the seller
108     seller.transfer(eth_to_release);
109   }
110 
111   function purchase() payable {
112     // Check for pre-determined sale start time
113     //if(block.number < 3960990) throw;
114     // Check if sale window is still open or not (date of promised distribution - grace?)
115     //if(block.number > 3990990) throw;
116 
117     // Determine amount of tokens user wants to/can buy
118     uint256 iou_to_purchase = 8600 * msg.value; // price is 8600 per ETH
119 
120     // Check if we have enough IOUs left to sell
121     if((total_iou_purchased + iou_to_purchase) > total_iou_available) throw;
122 
123     // Update the amount of IOUs purchased by user. Also keep track of the total ETH they sent in
124     iou_purchased[msg.sender] += iou_to_purchase;
125     eth_sent[msg.sender] += msg.value;
126 
127     // Update the total amount of IOUs purchased by all buyers
128     total_iou_purchased += iou_to_purchase;
129   }
130 
131   // Fallback function/entry point
132   function () payable {
133     if(msg.value == 0) { // If the user sent a 0 ETH transaction, withdraw()
134       withdraw();
135     }
136     else { // If the user sent ETH, purchase IOU
137       purchase();
138     }
139   }
140 }