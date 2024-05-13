1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 import "./Melodity-v2.sol";
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "@openzeppelin/contracts/security/Pausable.sol";
7 
8 contract MelodityCrowdsaleV2 is Ownable, Pausable {
9     Melodity token;
10     PaymentTier[] payment_tier;
11     uint256 sale_start;
12     uint256 sale_end;
13 
14     // used to store the amount of funds actually in the contract,
15     // this value is created in order to avoid eventually running out of funds in case of a large number of
16     // interactions occurring at the same time.
17     // it will be set to the balance of the contract and reduce at every round of _computeTokensAmount
18     // if the reduce flag is set to true, otherwise it won't be reduced
19     // TODO: initialize the supply value if not initialized yet
20     uint256 supply;
21     uint256 distributed;
22 
23     event Buy(address indexed from, uint256 amount);
24     event Finalize();
25     event Redeemed(uint256 amount);
26     event SupplyInitialized(uint256 _supply);
27     event SalePaused();
28     event SaleResumed();
29 
30     struct PaymentTier {
31         uint256 rate;
32         uint256 lower_limit;
33         uint256 upper_limit;
34     }
35 
36     receive() payable external {
37         buy();
38     }
39 
40     modifier whenClosed() {
41         require(
42             block.timestamp >= sale_end || token.balanceOf(address(this)) == 0, 
43             "Crowdsale not yet closed"
44         );
45         _;
46     }
47 
48     modifier whenRunning() {
49         require(
50             block.timestamp >= sale_start && block.timestamp < sale_end && token.balanceOf(address(this)) > 0, 
51             "Crowdsale not running"
52         );
53         _;
54     }
55 
56     modifier tierSetUp() {
57         require(
58             payment_tier.length > 0,
59             "At least one payment tier is required"
60         );
61         _;
62     }
63 
64     /**
65     @param _start Ico starting time
66     @param _end Ico ending time, if goal is not reached first
67     @param _token Melody token instance
68     @param _payment_tier Array of crowdsale price tier
69      */
70     constructor(uint256 _start, uint256 _end, Melodity _token, PaymentTier[] memory _payment_tier) {
71         // this allowes the start time to be set to 0, this mean that the starting time is not set yet
72         // so the sale has not yet a scheduled starting time
73         if(_start != 0) {
74             require(block.timestamp < _start, "Sale starting time cannot be in the past");
75         }
76 
77         // this allowes the end time to be set to 0, this mean that the end time is not set yet
78         // so the sale has not yet a scheduled ending time
79         if(_end != 0) {
80             require(block.timestamp < _end, "Ending time cannot be in the past");
81         }
82         
83         // empty payment tier is allowed at start, this because the tiers may change due to 
84         // unspent pre-ico funds
85         
86         require(_token != Melodity(payable(address(0))), "Token address cannot be null");
87 
88         sale_start = _start;
89         sale_end = _end;
90         token = _token;
91 
92         for(uint256 i = 0; i < _payment_tier.length; i++) {
93             payment_tier.push(_payment_tier[i]);
94         }
95     }
96 
97     function initSupply(uint256 _supply) public onlyOwner {
98         supply = _supply;
99         emit SupplyInitialized(_supply);
100     }
101 
102     function pause() public whenNotPaused onlyOwner {
103         _pause();
104         emit SalePaused();
105     }
106 
107     function resume() public whenPaused onlyOwner {
108         _unpause();
109         emit SaleResumed();
110     }
111 
112     function setStartTime(uint256 _start) public onlyOwner {
113         require(block.timestamp < _start, "Sale starting time cannot be in the past");
114         sale_start = _start;
115     }
116 
117     function setEndTime(uint256 _end) public onlyOwner {
118         require(block.timestamp < _end, "Ending time cannot be in the past");
119         sale_end = _end;
120     }
121 
122     function setPaymentTiers(PaymentTier[] memory _payment_tier) public onlyOwner {
123         require(_payment_tier.length > 0, "At least one payment tier must be defined");
124         delete payment_tier;
125         for(uint256 i = 0; i < _payment_tier.length; i++) {
126             payment_tier.push(_payment_tier[i]);
127         }
128     }
129 
130     function buy() public whenRunning whenNotPaused payable {
131         // If a fixed rate is provided compute the amount of token to buy based on the rate
132         (uint256 tokens_to_buy, uint256 exceedingEther) = _computeTokensAmount(msg.value, true);
133         if(exceedingEther > 0) {
134             payable(msg.sender).transfer(exceedingEther);
135         }
136         
137         // Mint new tokens for each submission
138 		token.saleLock(msg.sender, tokens_to_buy);
139         emit Buy(msg.sender, tokens_to_buy);
140     }    
141 
142     function computeTokensAmount(uint256 funds) public whenRunning whenNotPaused returns(uint256, uint256) {
143         return _computeTokensAmount(funds, false);
144     }
145 
146     function _computeTokensAmount(uint256 funds, bool reduce) private whenRunning whenNotPaused returns(uint256, uint256) {
147         uint256 future_minted = distributed;
148         uint256 tokens_to_buy;
149         uint256 current_round_tokens;      
150         uint256 ether_used = funds; 
151         uint256 future_round; 
152         uint256 rate;
153         uint256 upper_limit;
154 
155         for(uint256 i = 0; i < payment_tier.length; i++) {
156             // minor performance improvement, caches the value
157             upper_limit = payment_tier[i].upper_limit;
158 
159             if(
160                 ether_used > 0 &&                                   // Check if there are still some funds in the request
161                 future_minted >= payment_tier[i].lower_limit &&     // Check if the current rate can be applied with the lower_limit
162                 future_minted < upper_limit                         // Check if the current rate can be applied with the upper_limit
163                 ) {
164                 // minor performance improvement, caches the value
165                 rate = payment_tier[i].rate;
166                 
167                 // Keep a static counter and reset it in each round
168                 // NOTE: Order is important in value calculation
169                 current_round_tokens = ether_used * 1e18 / 1 ether * rate;
170 
171                 // minor performance optimization, caches the value
172                 future_round = future_minted + current_round_tokens;
173                 // If the tokens to mint exceed the upper limit of the tier reduce the number of token bounght in this round
174                 if(future_round >= upper_limit) {
175                     current_round_tokens -= future_round - upper_limit;
176                 }
177 
178                 // Update the future_minted counter with the current_round_tokens
179                 future_minted += current_round_tokens;
180 
181                 // Recomputhe the available funds
182                 ether_used -= current_round_tokens * 1 ether / rate / 1e18;
183 
184                 // And add the funds to the total calculation
185                 tokens_to_buy += current_round_tokens;
186             }
187         }
188 
189         // minor performance optimization, caches the value
190         uint256 new_minted = distributed + tokens_to_buy;
191         uint256 exceedingEther;
192         // Check if we have reached and exceeded the funding goal to refund the exceeding ether
193         if(new_minted >= supply) {
194             uint256 exceedingTokens = new_minted - supply;
195             
196             // Convert the exceedingTokens to ether and refund that ether
197             exceedingEther = ether_used + (exceedingTokens * 1 ether / payment_tier[payment_tier.length -1].rate / 1e18);
198 
199             // Change the tokens to buy to the new number
200             tokens_to_buy -= exceedingTokens;
201         }
202 
203         if(reduce) {
204             // change the core value asap
205             distributed += tokens_to_buy;
206             supply -= tokens_to_buy;
207         }
208 
209         return (tokens_to_buy, exceedingEther);
210     }
211 
212     function redeem() public onlyOwner whenClosed payable {
213         uint256 balance = address(this).balance;
214         payable(owner()).transfer(balance);
215 
216         // burn all unsold MELD
217 		if(supply > 0) {
218 			token.burnUnsold(supply);
219 		}
220 
221         emit Redeemed(balance);
222     }
223 
224     function emergencyRedeem() public onlyOwner payable {
225         require(paused(), "Emergency redemption of tokens can be called only if the sale is paused");
226 
227         uint256 balance = address(this).balance;
228         payable(owner()).transfer(balance);
229 
230         emit Redeemed(balance);
231     }
232 
233     function getBalance() public view returns(uint256) { return address(this).balance; }
234     function getDistributed() public view returns(uint256) { return distributed; }
235     function getStartingTime() public view returns(uint256) { return sale_start; }
236     function getEndingTime() public view returns(uint256) { return sale_end; }
237     function getSupply() public view returns(uint256) { return supply; }
238     function getTiers() public view returns(PaymentTier[] memory) { return payment_tier; }
239     function isStarted() public view returns(bool) { return block.timestamp >= sale_start; }
240 }
