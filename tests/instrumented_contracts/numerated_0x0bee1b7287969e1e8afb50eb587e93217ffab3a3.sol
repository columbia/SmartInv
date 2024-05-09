1 pragma solidity ^0.4.18;
2 /**
3 * @title ICO CONTRACT
4 * @dev ERC-20 Token Standard Complian
5 */
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 contract Ownable {
41   address public owner;
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() public{
48     owner = msg.sender;
49   }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) onlyOwner public {
64     require(newOwner != address(0));
65     OwnershipTransferred(owner, newOwner);
66     owner = newOwner;
67   }
68 
69 }
70 
71 contract token {
72 
73   function balanceOf(address _owner) public constant returns (uint256 balance);
74   function transfer(address _to, uint256 _value) public returns (bool success);
75 
76 }
77 
78 
79 contract Crowdsale is Ownable {
80   using SafeMath for uint256;
81   // The token being sold
82   token public token_reward;
83   // start and end timestamps where investments are allowed (both inclusive
84   
85   uint256 public start_time = now; //for testing
86   //uint256 public start_time = 1517846400; //02/05/2018 @ 4:00pm (UTC) or 5 PM (UTC + 1)
87   uint256 public end_Time = 1524355200; // 04/22/2018 @ 12:00am (UTC)
88 
89   uint256 public phase_1_remaining_tokens  = 50000000 * (10 ** uint256(8));
90   uint256 public phase_2_remaining_tokens  = 50000000 * (10 ** uint256(8));
91   uint256 public phase_3_remaining_tokens  = 50000000 * (10 ** uint256(8));
92   uint256 public phase_4_remaining_tokens  = 50000000 * (10 ** uint256(8));
93   uint256 public phase_5_remaining_tokens  = 50000000 * (10 ** uint256(8));
94 
95   uint256 public phase_1_bonus  = 40;
96   uint256 public phase_2_bonus  = 20;
97   uint256 public phase_3_bonus  = 15;
98   uint256 public phase_4_bonus  = 10;
99   uint256 public phase_5_bonus  = 5;
100 
101   uint256 public token_price  = 2;// 2 cents
102 
103   // address where funds are collected
104   address public wallet;
105   // Ether to $ price
106   uint256 public eth_to_usd = 1000;
107   // amount of raised money in wei
108   uint256 public weiRaised;
109   /**
110    * event for token purchase logging
111    * @param purchaser who paid for the tokens
112    * @param beneficiary who got the tokens
113    * @param value weis paid for purchase
114    * @param amount amount of tokens purchased
115    */
116   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
117   // rate change event
118   event EthToUsdChanged(address indexed owner, uint256 old_eth_to_usd, uint256 new_eth_to_usd);
119   
120   // constructor
121   function Crowdsale(address tokenContractAddress) public{
122     wallet = 0x1aC024482b91fa9AaF22450Ff60680BAd60bF8D3;//wallet where ETH will be transferred
123     token_reward = token(tokenContractAddress);
124   }
125   
126  function tokenBalance() constant public returns (uint256){
127     return token_reward.balanceOf(this);
128   }
129 
130   function getRate() constant public returns (uint256){
131     return eth_to_usd.mul(100).div(token_price);
132   }
133 
134   // @return true if the transaction can buy tokens
135   function validPurchase() internal constant returns (bool) {
136     bool withinPeriod = now >= start_time && now <= end_Time;
137     bool allPhaseFinished = phase_5_remaining_tokens > 0;
138     bool nonZeroPurchase = msg.value != 0;
139     bool minPurchase = eth_to_usd*msg.value >= 100; // minimum purchase $100
140     return withinPeriod && nonZeroPurchase && allPhaseFinished && minPurchase;
141   }
142 
143   // @return true if the admin can send tokens manually
144   function validPurchaseForManual() internal constant returns (bool) {
145     bool withinPeriod = now >= start_time && now <= end_Time;
146     bool allPhaseFinished = phase_5_remaining_tokens > 0;
147     return withinPeriod && allPhaseFinished;
148   }
149 
150 
151   // check token availibility for current phase and max allowed token balance
152   function checkAndUpdateTokenForManual(uint256 _tokens) internal returns (bool){
153     if(phase_1_remaining_tokens > 0){
154       if(_tokens > phase_1_remaining_tokens){
155         uint256 tokens_from_phase_2 = _tokens.sub(phase_1_remaining_tokens);
156         phase_1_remaining_tokens = 0;
157         phase_2_remaining_tokens = phase_2_remaining_tokens.sub(tokens_from_phase_2);
158       }else{
159         phase_1_remaining_tokens = phase_1_remaining_tokens.sub(_tokens);
160       }
161       return true;
162     }else if(phase_2_remaining_tokens > 0){
163       if(_tokens > phase_2_remaining_tokens){
164         uint256 tokens_from_phase_3 = _tokens.sub(phase_2_remaining_tokens);
165         phase_2_remaining_tokens = 0;
166         phase_3_remaining_tokens = phase_3_remaining_tokens.sub(tokens_from_phase_3);
167       }else{
168         phase_2_remaining_tokens = phase_2_remaining_tokens.sub(_tokens);
169       }
170       return true;
171     }else if(phase_3_remaining_tokens > 0){
172       if(_tokens > phase_3_remaining_tokens){
173         uint256 tokens_from_phase_4 = _tokens.sub(phase_3_remaining_tokens);
174         phase_3_remaining_tokens = 0;
175         phase_4_remaining_tokens = phase_4_remaining_tokens.sub(tokens_from_phase_4);
176       }else{
177         phase_3_remaining_tokens = phase_3_remaining_tokens.sub(_tokens);
178       }
179       return true;
180     }else if(phase_4_remaining_tokens > 0){
181       if(_tokens > phase_4_remaining_tokens){
182         uint256 tokens_from_phase_5 = _tokens.sub(phase_4_remaining_tokens);
183         phase_4_remaining_tokens = 0;
184         phase_5_remaining_tokens = phase_5_remaining_tokens.sub(tokens_from_phase_5);
185       }else{
186         phase_4_remaining_tokens = phase_4_remaining_tokens.sub(_tokens);
187       }
188       return true;
189     }else if(phase_5_remaining_tokens > 0){
190       if(_tokens > phase_5_remaining_tokens){
191         return false;
192       }else{
193         phase_5_remaining_tokens = phase_5_remaining_tokens.sub(_tokens);
194        }
195     }else{
196       return false;
197     }
198   }
199 
200   // function to transfer token manually
201   function transferManually(uint256 _tokens, address to_address) onlyOwner public returns (bool){
202     require(to_address != 0x0);
203     require(validPurchaseForManual());
204     require(checkAndUpdateTokenForManual(_tokens));
205     token_reward.transfer(to_address, _tokens);
206     return true;
207   }
208 
209 
210   // check token availibility for current phase and max allowed token balance
211   function transferIfTokenAvailable(uint256 _tokens, uint256 _weiAmount, address _beneficiary) internal returns (bool){
212 
213     uint256 total_token_to_transfer = 0;
214     uint256 bonus = 0;
215     if(phase_1_remaining_tokens > 0){
216       if(_tokens > phase_1_remaining_tokens){
217         uint256 tokens_from_phase_2 = _tokens.sub(phase_1_remaining_tokens);
218         bonus = (phase_1_remaining_tokens.mul(phase_1_bonus).div(100)).add(tokens_from_phase_2.mul(phase_2_bonus).div(100));
219         phase_1_remaining_tokens = 0;
220         phase_2_remaining_tokens = phase_2_remaining_tokens.sub(tokens_from_phase_2);
221       }else{
222         phase_1_remaining_tokens = phase_1_remaining_tokens.sub(_tokens);
223         bonus = _tokens.mul(phase_1_bonus).div(100);
224       }
225       total_token_to_transfer = _tokens + bonus;
226     }else if(phase_2_remaining_tokens > 0){
227       if(_tokens > phase_2_remaining_tokens){
228         uint256 tokens_from_phase_3 = _tokens.sub(phase_2_remaining_tokens);
229         bonus = (phase_2_remaining_tokens.mul(phase_2_bonus).div(100)).add(tokens_from_phase_3.mul(phase_3_bonus).div(100));
230         phase_2_remaining_tokens = 0;
231         phase_3_remaining_tokens = phase_3_remaining_tokens.sub(tokens_from_phase_3);
232       }else{
233         phase_2_remaining_tokens = phase_2_remaining_tokens.sub(_tokens);
234         bonus = _tokens.mul(phase_2_bonus).div(100);
235       }
236       total_token_to_transfer = _tokens + bonus;
237     }else if(phase_3_remaining_tokens > 0){
238       if(_tokens > phase_3_remaining_tokens){
239         uint256 tokens_from_phase_4 = _tokens.sub(phase_3_remaining_tokens);
240         bonus = (phase_3_remaining_tokens.mul(phase_3_bonus).div(100)).add(tokens_from_phase_4.mul(phase_4_bonus).div(100));
241         phase_3_remaining_tokens = 0;
242         phase_4_remaining_tokens = phase_4_remaining_tokens.sub(tokens_from_phase_4);
243       }else{
244         phase_3_remaining_tokens = phase_3_remaining_tokens.sub(_tokens);
245         bonus = _tokens.mul(phase_3_bonus).div(100);
246       }
247       total_token_to_transfer = _tokens + bonus;
248     }else if(phase_4_remaining_tokens > 0){
249       if(_tokens > phase_4_remaining_tokens){
250         uint256 tokens_from_phase_5 = _tokens.sub(phase_4_remaining_tokens);
251         bonus = (phase_4_remaining_tokens.mul(phase_4_bonus).div(100)).add(tokens_from_phase_5.mul(phase_5_bonus).div(100));
252         phase_4_remaining_tokens = 0;
253         phase_5_remaining_tokens = phase_5_remaining_tokens.sub(tokens_from_phase_5);
254       }else{
255         phase_4_remaining_tokens = phase_4_remaining_tokens.sub(_tokens);
256         bonus = _tokens.mul(phase_4_bonus).div(100);
257       }
258       total_token_to_transfer = _tokens + bonus;
259     }else if(phase_5_remaining_tokens > 0){
260       if(_tokens > phase_5_remaining_tokens){
261         total_token_to_transfer = 0;
262       }else{
263         phase_5_remaining_tokens = phase_5_remaining_tokens.sub(_tokens);
264         bonus = _tokens.mul(phase_5_bonus).div(100);
265         total_token_to_transfer = _tokens + bonus;
266       }
267     }else{
268       total_token_to_transfer = 0;
269     }
270     if(total_token_to_transfer > 0){
271       token_reward.transfer(_beneficiary, total_token_to_transfer);
272       TokenPurchase(msg.sender, _beneficiary, _weiAmount, total_token_to_transfer);
273       return true;
274     }else{
275       return false;
276     }
277     
278   }
279 
280   // fallback function can be used to buy tokens
281   function () payable public{
282     buyTokens(msg.sender);
283   }
284 
285   // low level token purchase function
286   function buyTokens(address beneficiary) public payable {
287     require(beneficiary != 0x0);
288     require(validPurchase());
289     uint256 weiAmount = msg.value;
290     // calculate token amount to be created
291     uint256 tokens = (weiAmount.mul(getRate())).div(10 ** uint256(10));
292     // Check is there are enough token available for current phase and per person  
293     require(transferIfTokenAvailable(tokens, weiAmount, beneficiary));
294     // update state
295     weiRaised = weiRaised.add(weiAmount);
296     
297     forwardFunds();
298   }
299   
300   // send ether to the fund collection wallet
301   // override to create custom fund forwarding mechanisms
302   function forwardFunds() internal {
303     wallet.transfer(msg.value);
304   }
305   
306   // @return true if crowdsale event has ended
307   function hasEnded() public constant returns (bool) {
308     return now > end_Time;
309   }
310   // function to transfer token back to owner
311   function transferBack(uint256 tokens, address to_address) onlyOwner public returns (bool){
312     token_reward.transfer(to_address, tokens);
313     return true;
314   }
315   // function to change rate
316   function changeEth_to_usd(uint256 _eth_to_usd) onlyOwner public returns (bool){
317     EthToUsdChanged(msg.sender, eth_to_usd, _eth_to_usd);
318     eth_to_usd = _eth_to_usd;
319     return true;
320   }
321 }