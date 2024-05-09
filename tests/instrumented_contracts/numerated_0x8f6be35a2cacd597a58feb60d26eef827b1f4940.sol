1 pragma solidity ^0.4.18;
2 /**
3 * @title ICO CONTRACT
4 * @dev ERC-20 Token Standard Compliant
5 * @author Fares A. Akel C. f.antonio.akel@gmail.com
6 */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 contract Ownable {
42   address public owner;
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() public{
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner public {
65     require(newOwner != address(0));
66     OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 
70 }
71 
72 contract token {
73 
74   function balanceOf(address _owner) public constant returns (uint256 balance);
75   function transfer(address _to, uint256 _value) public returns (bool success);
76 
77 }
78 
79 
80 contract Crowdsale is Ownable {
81   using SafeMath for uint256;
82   // The token being sold
83   token public token_reward;
84   // start and end timestamps where investments are allowed (both inclusive
85   
86   //uint256 public start_time = now; //for testing
87   uint256 public start_time = 1517846400; //02/05/2018 @ 4:00pm (UTC) or 5 PM (UTC + 1)
88   uint256 public end_Time = 1519563600; // 02/25/2018 @ 1:00pm (UTC) or 2 PM (UTC + 1)
89   uint256 public phase_1_remaining_tokens  = 50000000 * (10 ** uint256(18));
90   uint256 public phase_2_remaining_tokens  = 25000000 * (10 ** uint256(18));
91   uint256 public phase_3_remaining_tokens  = 15000000 * (10 ** uint256(18));
92   uint256 public phase_4_remaining_tokens  = 10000000 * (10 ** uint256(18));
93 
94   uint256 public phase_1_token_price  = 5;// 5 cents
95   uint256 public phase_2_token_price  = 6;// 6 cents
96   uint256 public phase_3_token_price  = 7;// 7 cents
97   uint256 public phase_4_token_price  = 8;// 8 cents
98 
99   // address where funds are collected
100   address public wallet;
101   // Ether to $ price
102   uint256 public eth_to_usd = 1000;
103   // amount of raised money in wei
104   uint256 public weiRaised;
105   /**
106    * event for token purchase logging
107    * @param purchaser who paid for the tokens
108    * @param beneficiary who got the tokens
109    * @param value weis paid for purchase
110    * @param amount amount of tokens purchased
111    */
112   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
113   // rate change event
114   event EthToUsdChanged(address indexed owner, uint256 old_eth_to_usd, uint256 new_eth_to_usd);
115   
116   // constructor
117   function Crowdsale(address tokenContractAddress) public{
118     wallet = 0x8716Be0540Fa6882CB0C05a804cC286B3CEb4a35;//wallet where ETH will be transferred
119     token_reward = token(tokenContractAddress);
120   }
121   
122  function tokenBalance() constant public returns (uint256){
123     return token_reward.balanceOf(this);
124   }
125 
126   function phase_1_rate() constant public returns (uint256){
127     return eth_to_usd.mul(100).div(phase_1_token_price);
128   }
129 
130   function phase_2_rate() constant public returns (uint256){
131     return eth_to_usd.mul(100).div(phase_2_token_price);
132   }
133 
134   function phase_3_rate() constant public returns (uint256){
135     return eth_to_usd.mul(100).div(phase_3_token_price);
136   }
137 
138   function phase_4_rate() constant public returns (uint256){
139     return eth_to_usd.mul(100).div(phase_4_token_price);
140   }
141 
142   // return specific rate
143   function getRate() constant public returns (uint256){
144     if(phase_1_remaining_tokens > 0){
145       return phase_1_rate();
146     }else if(phase_2_remaining_tokens > 0){
147       return phase_2_rate();
148     }else if(phase_3_remaining_tokens > 0){
149       return phase_3_rate();
150     }else if(phase_4_remaining_tokens > 0){
151       return phase_4_rate();
152     }else{
153       return 0;
154     }
155   }
156 
157   // @return true if the transaction can buy tokens
158   function validPurchase() internal constant returns (bool) {
159     bool withinPeriod = now >= start_time && now <= end_Time;
160     bool allPhaseFinished = phase_4_remaining_tokens > 0;
161     bool nonZeroPurchase = msg.value != 0;
162     return withinPeriod && nonZeroPurchase && allPhaseFinished;
163   }
164 
165 
166   // check token availibility for current phase and max allowed token balance
167   function transferIfTokenAvailable(uint256 _tokens, uint256 _weiAmount, address _beneficiary) internal returns (bool){
168 
169     uint256 total_token_to_transfer = 0;
170     uint256 wei_amount_remaining = 0;
171     if(phase_1_remaining_tokens > 0){
172       if(_tokens > phase_1_remaining_tokens){
173         wei_amount_remaining = _weiAmount.sub(_weiAmount.div(phase_1_rate()));
174         uint256 tokens_from_phase_2 = wei_amount_remaining.mul(phase_2_rate());
175         total_token_to_transfer = phase_1_remaining_tokens.add(tokens_from_phase_2);
176         phase_1_remaining_tokens = 0;
177         phase_2_remaining_tokens = phase_2_remaining_tokens.sub(tokens_from_phase_2);
178       }else{
179         phase_1_remaining_tokens = phase_1_remaining_tokens.sub(_tokens);
180         total_token_to_transfer = _tokens;
181       }
182     }else if(phase_2_remaining_tokens > 0){
183       if(_tokens > phase_2_remaining_tokens){
184         wei_amount_remaining = _weiAmount.sub(_weiAmount.div(phase_2_rate()));
185         uint256 tokens_from_phase_3 = wei_amount_remaining.mul(phase_3_rate());
186         total_token_to_transfer = phase_2_remaining_tokens.add(tokens_from_phase_3);
187         phase_2_remaining_tokens = 0;
188         phase_3_remaining_tokens = phase_3_remaining_tokens.sub(tokens_from_phase_3);
189       }else{
190         phase_2_remaining_tokens = phase_2_remaining_tokens.sub(_tokens);
191         total_token_to_transfer = _tokens;
192       }
193       
194     }else if(phase_3_remaining_tokens > 0){
195       if(_tokens > phase_3_remaining_tokens){
196         wei_amount_remaining = _weiAmount.sub(_weiAmount.div(phase_3_rate()));
197         uint256 tokens_from_phase_4 = wei_amount_remaining.mul(phase_4_rate());
198         total_token_to_transfer = phase_3_remaining_tokens.add(tokens_from_phase_4);
199         phase_3_remaining_tokens = 0;
200         phase_4_remaining_tokens = phase_4_remaining_tokens.sub(tokens_from_phase_4);
201       }else{
202         phase_3_remaining_tokens = phase_3_remaining_tokens.sub(_tokens);
203         total_token_to_transfer = _tokens;
204       }
205       
206     }else if(phase_4_remaining_tokens > 0){
207       if(_tokens > phase_3_remaining_tokens){
208         total_token_to_transfer = 0;
209       }else{
210         phase_4_remaining_tokens = phase_4_remaining_tokens.sub(_tokens);
211         total_token_to_transfer = _tokens;
212       }
213     }else{
214       total_token_to_transfer = 0;
215     }
216     if(total_token_to_transfer > 0){
217       token_reward.transfer(_beneficiary, total_token_to_transfer);
218       TokenPurchase(msg.sender, _beneficiary, _weiAmount, total_token_to_transfer);
219       return true;
220     }else{
221       return false;
222     }
223     
224   }
225 
226   // fallback function can be used to buy tokens
227   function () payable public{
228     buyTokens(msg.sender);
229   }
230 
231   // low level token purchase function
232   function buyTokens(address beneficiary) public payable {
233     require(beneficiary != 0x0);
234     require(validPurchase());
235     uint256 weiAmount = msg.value;
236     // calculate token amount to be created
237     uint256 tokens = weiAmount.mul(getRate());
238     // Check is there are enough token available for current phase and per person  
239     require(transferIfTokenAvailable(tokens, weiAmount, beneficiary));
240     // update state
241     weiRaised = weiRaised.add(weiAmount);
242     
243     forwardFunds();
244   }
245   
246   // send ether to the fund collection wallet
247   // override to create custom fund forwarding mechanisms
248   function forwardFunds() internal {
249     wallet.transfer(msg.value);
250   }
251   
252   // @return true if crowdsale event has ended
253   function hasEnded() public constant returns (bool) {
254     return now > end_Time;
255   }
256   // function to transfer token back to owner
257   function transferBack(uint256 tokens) onlyOwner public returns (bool){
258     token_reward.transfer(owner, tokens);
259     return true;
260   }
261   // function to change rate
262   function changeEth_to_usd(uint256 _eth_to_usd) onlyOwner public returns (bool){
263     EthToUsdChanged(msg.sender, eth_to_usd, _eth_to_usd);
264     eth_to_usd = _eth_to_usd;
265     return true;
266   }
267 }