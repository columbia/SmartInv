1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 import "./Melodity.sol";
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 
7 contract MelodityCrowdsale is Ownable {
8     Melodity token;
9     PaymentTier[] payment_tier;
10     uint256 sale_start;
11     uint256 sale_end;
12 
13     // emergency switch to pause the ico errors occurrs
14     bool paused;
15 
16     // used to store the amount of funds actually in the contract,
17     // this value is created in order to avoid eventually running out of funds in case of a large number of
18     // interactions occurring at the same time.
19     // it will be set to the balance of the contract and reduce at every round of _computeTokensAmount
20     // if the reduce flag is set to true, otherwise it won't be reduced
21     // TODO: initialize the supply value if not initialized yet
22     uint256 supply;
23     uint256 distributed;
24 
25     event Buy(address indexed from, uint256 amount);
26     event Finalize();
27     event Redeemed(uint256 amount);
28     event SupplyInitialized(uint256 _supply);
29     event SalePaused();
30     event SaleResumed();
31 
32     struct PaymentTier {
33         uint256 rate;
34         uint256 lower_limit;
35         uint256 upper_limit;
36     }
37 
38     receive() payable external {
39         buy();
40     }
41 
42     modifier whenClosed() {
43         require(
44             block.timestamp >= sale_end || token.balanceOf(address(this)) == 0, 
45             "Crowdsale not yet closed"
46         );
47         _;
48     }
49 
50     modifier whenRunning() {
51         require(
52             block.timestamp >= sale_start && block.timestamp < sale_end && token.balanceOf(address(this)) > 0, 
53             "Crowdsale not running"
54         );
55         _;
56     }
57 
58     modifier tierSetUp() {
59         require(
60             payment_tier.length > 0,
61             "At least one payment tier is required"
62         );
63         _;
64     }
65 
66     modifier isNotPaused() {
67         require(!paused, "Sorry the sale is temporarily paused due security concerns");
68         _;
69     }
70 
71     /**
72     @param _start Ico starting time
73     @param _end Ico ending time, if goal is not reached first
74     @param _token Melody token instance
75     @param _payment_tier Array of crowdsale price tier
76      */
77     constructor(uint256 _start, uint256 _end, Melodity _token, PaymentTier[] memory _payment_tier) {
78         // this allowes the start time to be set to 0, this mean that the starting time is not set yet
79         // so the sale has not yet a scheduled starting time
80         if(_start != 0) {
81             require(block.timestamp < _start, "Sale starting time cannot be in the past");
82         }
83 
84         // this allowes the end time to be set to 0, this mean that the end time is not set yet
85         // so the sale has not yet a scheduled ending time
86         if(_end != 0) {
87             require(block.timestamp < _end, "Ending time cannot be in the past");
88         }
89         
90         // empty payment tier is allowed at start, this because the tiers may change due to 
91         // unspent pre-ico funds
92         
93         require(_token != Melodity(payable(address(0))), "Token address cannot be null");
94 
95         sale_start = _start;
96         sale_end = _end;
97         token = _token;
98 
99         for(uint256 i = 0; i < _payment_tier.length; i++) {
100             payment_tier.push(_payment_tier[i]);
101         }
102     }
103 
104     function initSupply() public {
105         supply = token.balanceOf(address(this));
106         emit SupplyInitialized(supply);
107     }
108 
109     function pause() public isNotPaused onlyOwner {
110         paused = true;
111         emit SalePaused();
112     }
113 
114     function resume() public onlyOwner {
115         paused = false;
116         emit SaleResumed();
117     }
118 
119     function setStartTime(uint256 _start) public onlyOwner {
120         require(block.timestamp < _start, "Sale starting time cannot be in the past");
121         sale_start = _start;
122     }
123 
124     function setEndTime(uint256 _end) public onlyOwner {
125         require(block.timestamp < _end, "Ending time cannot be in the past");
126         sale_end = _end;
127     }
128 
129     function setPaymentTiers(PaymentTier[] memory _payment_tier) public onlyOwner {
130         require(_payment_tier.length > 0, "At least one payment tier must be defined");
131         delete payment_tier;
132         for(uint256 i = 0; i < _payment_tier.length; i++) {
133             payment_tier.push(_payment_tier[i]);
134         }
135     }
136 
137     function buy() public whenRunning isNotPaused payable {
138         // If a fixed rate is provided compute the amount of token to buy based on the rate
139         (uint256 tokens_to_buy, uint256 exceedingEther) = _computeTokensAmount(msg.value, true);
140         if(exceedingEther > 0) {
141             payable(msg.sender).transfer(exceedingEther);
142         }
143         
144         // Mint new tokens for each submission
145         token.transfer(msg.sender, tokens_to_buy);
146         emit Buy(msg.sender, tokens_to_buy);
147     }    
148 
149     function computeTokensAmount(uint256 funds) public whenRunning isNotPaused returns(uint256, uint256) {
150         return _computeTokensAmount(funds, false);
151     }
152 
153     function _computeTokensAmount(uint256 funds, bool reduce) private whenRunning isNotPaused returns(uint256, uint256) {
154         uint256 future_minted = distributed;
155         uint256 tokens_to_buy;
156         uint256 current_round_tokens;      
157         uint256 ether_used = funds; 
158         uint256 future_round; 
159         uint256 rate;
160         uint256 upper_limit;
161 
162         for(uint256 i = 0; i < payment_tier.length; i++) {
163             // minor performance improvement, caches the value
164             upper_limit = payment_tier[i].upper_limit;
165 
166             if(
167                 ether_used > 0 &&                                   // Check if there are still some funds in the request
168                 future_minted >= payment_tier[i].lower_limit &&     // Check if the current rate can be applied with the lower_limit
169                 future_minted < upper_limit                         // Check if the current rate can be applied with the upper_limit
170                 ) {
171                 // minor performance improvement, caches the value
172                 rate = payment_tier[i].rate;
173                 
174                 // Keep a static counter and reset it in each round
175                 // NOTE: Order is important in value calculation
176                 current_round_tokens = ether_used * 1e18 / 1 ether * rate;
177 
178                 // minor performance optimization, caches the value
179                 future_round = future_minted + current_round_tokens;
180                 // If the tokens to mint exceed the upper limit of the tier reduce the number of token bounght in this round
181                 if(future_round >= upper_limit) {
182                     current_round_tokens -= future_round - upper_limit;
183                 }
184 
185                 // Update the future_minted counter with the current_round_tokens
186                 future_minted += current_round_tokens;
187 
188                 // Recomputhe the available funds
189                 ether_used -= current_round_tokens * 1 ether / rate / 1e18;
190 
191                 // And add the funds to the total calculation
192                 tokens_to_buy += current_round_tokens;
193             }
194         }
195 
196         // minor performance optimization, caches the value
197         uint256 new_minted = distributed + tokens_to_buy;
198         uint256 exceedingEther;
199         // Check if we have reached and exceeded the funding goal to refund the exceeding ether
200         if(new_minted >= supply) {
201             uint256 exceedingTokens = new_minted - supply;
202             
203             // Convert the exceedingTokens to ether and refund that ether
204             exceedingEther = ether_used + (exceedingTokens * 1 ether / payment_tier[payment_tier.length -1].rate / 1e18);
205 
206             // Change the tokens to buy to the new number
207             tokens_to_buy -= exceedingTokens;
208         }
209 
210         if(reduce) {
211             // change the core value asap
212             distributed += tokens_to_buy;
213             supply -= tokens_to_buy;
214         }
215 
216         return (tokens_to_buy, exceedingEther);
217     }
218 
219     function redeem() public onlyOwner whenClosed payable {
220         uint256 balance = address(this).balance;
221         payable(owner()).transfer(balance);
222 
223         // transfer the exceeding MELD to the bridge wallet
224         uint256 remaining_meld = token.balanceOf(address(this));
225         // bridge wallet address 0x7C44bEfc22111e868b3a0B1bbF30Dd48F99682b3
226         token.transfer(payable(address(0x15DB902f721214fcf39F979E9b4FA0A3B8EDC7F5)), remaining_meld);
227 
228         emit Redeemed(balance);
229     }
230 
231     function emergencyRedeem() public onlyOwner payable {
232         require(paused, "Emergency redemption of tokens can be called only if the sale is paused");
233 
234         uint256 balance = address(this).balance;
235         payable(owner()).transfer(balance);
236 
237         // transfer the exceeding MELD to the bridge wallet
238         uint256 remaining_meld = token.balanceOf(address(this));
239         // bridge wallet address 0x7C44bEfc22111e868b3a0B1bbF30Dd48F99682b3
240         token.transfer(payable(address(0x15DB902f721214fcf39F979E9b4FA0A3B8EDC7F5)), remaining_meld);
241 
242         emit Redeemed(balance);
243     }
244 
245     function getBalance() public view returns(uint256) { return address(this).balance; }
246     function getDistributed() public view returns(uint256) { return distributed; }
247     function getStartingTime() public view returns(uint256) { return sale_start; }
248     function getEndingTime() public view returns(uint256) { return sale_end; }
249     function getSupply() public view returns(uint256) { return supply; }
250     function getTiers() public view returns(PaymentTier[] memory) { return payment_tier; }
251     function isPaused() public onlyOwner view returns(bool) { return paused; }
252     function isStarted() public view returns(bool) { return block.timestamp >= sale_start; }
253 }
