1 pragma solidity 0.4.19;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) public view returns (uint256);
73   function transferFrom(address from, address to, uint256 value) public returns (bool);
74   function approve(address spender, uint256 value) public returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
79 
80 /**
81  * @title Crowdsale
82  * @dev Crowdsale is a base contract for managing a token crowdsale,
83  * allowing investors to purchase tokens with ether. This contract implements
84  * such functionality in its most fundamental form and can be extended to provide additional
85  * functionality and/or custom behavior.
86  * The external interface represents the basic interface for purchasing tokens, and conform
87  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
88  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
89  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
90  * behavior.
91  */
92 
93 contract Crowdsale {
94   using SafeMath for uint256;
95 
96   // The token being sold
97   ERC20 public token;
98 
99   // Address where funds are collected
100   address public wallet;
101 
102   // How many token units a buyer gets per wei
103   uint256 public rate;
104 
105   // Amount of wei raised
106   uint256 public weiRaised;
107 
108   /**
109    * Event for token purchase logging
110    * @param purchaser who paid for the tokens
111    * @param beneficiary who got the tokens
112    * @param value weis paid for purchase
113    * @param amount amount of tokens purchased
114    */
115   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
116 
117   /**
118    * @param _rate Number of token units a buyer gets per wei
119    * @param _wallet Address where collected funds will be forwarded to
120    * @param _token Address of the token being sold
121    */
122   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
123     require(_rate > 0);
124     require(_wallet != address(0));
125     require(_token != address(0));
126 
127     rate = _rate;
128     wallet = _wallet;
129     token = _token;
130   }
131 
132   // -----------------------------------------
133   // Crowdsale external interface
134   // -----------------------------------------
135 
136   /**
137    * @dev fallback function ***DO NOT OVERRIDE***
138    */
139   function () external payable {
140     buyTokens(msg.sender);
141   }
142 
143   /**
144    * @dev low level token purchase ***DO NOT OVERRIDE***
145    * @param _beneficiary Address performing the token purchase
146    */
147   function buyTokens(address _beneficiary) public payable {
148 
149     uint256 weiAmount = msg.value;
150     _preValidatePurchase(_beneficiary, weiAmount);
151 
152     // calculate token amount to be created
153     uint256 tokens = _getTokenAmount(weiAmount);
154 
155     // update state
156     weiRaised = weiRaised.add(weiAmount);
157 
158     _processPurchase(_beneficiary, tokens);
159     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
160 
161     _updatePurchasingState(_beneficiary, weiAmount);
162 
163     _forwardFunds();
164     _postValidatePurchase(_beneficiary, weiAmount);
165   }
166 
167   // -----------------------------------------
168   // Internal interface (extensible)
169   // -----------------------------------------
170 
171   /**
172    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
173    * @param _beneficiary Address performing the token purchase
174    * @param _weiAmount Value in wei involved in the purchase
175    */
176   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
177     require(_beneficiary != address(0));
178     require(_weiAmount != 0);
179   }
180 
181   /**
182    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
183    * @param _beneficiary Address performing the token purchase
184    * @param _weiAmount Value in wei involved in the purchase
185    */
186   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
187     // optional override
188   }
189 
190   /**
191    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
192    * @param _beneficiary Address performing the token purchase
193    * @param _tokenAmount Number of tokens to be emitted
194    */
195   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
196     token.transfer(_beneficiary, _tokenAmount);
197   }
198 
199   /**
200    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
201    * @param _beneficiary Address receiving the tokens
202    * @param _tokenAmount Number of tokens to be purchased
203    */
204   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
205     _deliverTokens(_beneficiary, _tokenAmount);
206   }
207 
208   /**
209    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
210    * @param _beneficiary Address receiving the tokens
211    * @param _weiAmount Value in wei involved in the purchase
212    */
213   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
214     // optional override
215   }
216 
217   /**
218    * @dev Override to extend the way in which ether is converted to tokens.
219    * @param _weiAmount Value in wei to be converted into tokens
220    * @return Number of tokens that can be purchased with the specified _weiAmount
221    */
222   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
223     return _weiAmount.mul(rate);
224   }
225 
226   /**
227    * @dev Determines how ETH is stored/forwarded on purchases.
228    */
229   function _forwardFunds() internal {
230     wallet.transfer(msg.value);
231   }
232 }
233 
234 // File: zeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol
235 
236 /**
237  * @title AllowanceCrowdsale
238  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
239  */
240 contract AllowanceCrowdsale is Crowdsale {
241   using SafeMath for uint256;
242 
243   address public tokenWallet;
244 
245   /**
246    * @dev Constructor, takes token wallet address. 
247    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
248    */
249   function AllowanceCrowdsale(address _tokenWallet) public {
250     require(_tokenWallet != address(0));
251     tokenWallet = _tokenWallet;
252   }
253 
254   /**
255    * @dev Checks the amount of tokens left in the allowance.
256    * @return Amount of tokens left in the allowance
257    */
258   function remainingTokens() public view returns (uint256) {
259     return token.allowance(tokenWallet, this);
260   }
261 
262   /**
263    * @dev Overrides parent behavior by transferring tokens from wallet.
264    * @param _beneficiary Token purchaser
265    * @param _tokenAmount Amount of tokens purchased
266    */
267   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
268     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
269   }
270 }
271 
272 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
273 
274 /**
275  * @title TimedCrowdsale
276  * @dev Crowdsale accepting contributions only within a time frame.
277  */
278 contract TimedCrowdsale is Crowdsale {
279   using SafeMath for uint256;
280 
281   uint256 public openingTime;
282   uint256 public closingTime;
283 
284   /**
285    * @dev Reverts if not in crowdsale time range. 
286    */
287   modifier onlyWhileOpen {
288     require(now >= openingTime && now <= closingTime);
289     _;
290   }
291 
292   /**
293    * @dev Constructor, takes crowdsale opening and closing times.
294    * @param _openingTime Crowdsale opening time
295    * @param _closingTime Crowdsale closing time
296    */
297   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
298     require(_openingTime >= now);
299     require(_closingTime >= _openingTime);
300 
301     openingTime = _openingTime;
302     closingTime = _closingTime;
303   }
304 
305   /**
306    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
307    * @return Whether crowdsale period has elapsed
308    */
309   function hasClosed() public view returns (bool) {
310     return now > closingTime;
311   }
312   
313   /**
314    * @dev Extend parent behavior requiring to be within contributing period
315    * @param _beneficiary Token purchaser
316    * @param _weiAmount Amount of wei contributed
317    */
318   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
319     super._preValidatePurchase(_beneficiary, _weiAmount);
320   }
321 
322 }
323 
324 // File: contracts/IOVOTokenPrivate.sol
325 
326 contract IOVOTokenPrivate2 is AllowanceCrowdsale, TimedCrowdsale {
327     function IOVOTokenPrivate2(address _tokenWallet,
328                               uint256 _openingTime,
329                               uint256 _closingTime,
330                               uint256 _rate,
331                               address _wallet,
332                               ERC20 _token) public
333                               AllowanceCrowdsale(_tokenWallet)
334                               TimedCrowdsale(_openingTime, _closingTime)
335                               Crowdsale(_rate, _wallet, _token)
336     {
337     }
338 }