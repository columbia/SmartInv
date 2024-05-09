1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that revert on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, reverts on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (a == 0) {
50       return 0;
51     }
52 
53     uint256 c = a * b;
54     require(c / a == b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b > 0); // Solidity only automatically asserts when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     uint256 c = a - b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, reverts on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
86 
87     return c;
88   }
89 
90   /**
91   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
92   * reverts when dividing by zero.
93   */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 /**
101  * @title SafeERC20
102  * @dev Wrappers around ERC20 operations that throw on failure.
103  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
104  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
105  */
106 library SafeERC20 {
107 
108   using SafeMath for uint256;
109 
110   function safeTransfer(
111     IERC20 token,
112     address to,
113     uint256 value
114   )
115     internal
116   {
117     require(token.transfer(to, value));
118   }
119 
120   function safeTransferFrom(
121     IERC20 token,
122     address from,
123     address to,
124     uint256 value
125   )
126     internal
127   {
128     require(token.transferFrom(from, to, value));
129   }
130 
131   function safeApprove(
132     IERC20 token,
133     address spender,
134     uint256 value
135   )
136     internal
137   {
138     // safeApprove should only be called when setting an initial allowance,
139     // or when resetting it to zero. To increase and decrease it, use
140     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
141     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
142     require(token.approve(spender, value));
143   }
144 
145   function safeIncreaseAllowance(
146     IERC20 token,
147     address spender,
148     uint256 value
149   )
150     internal
151   {
152     uint256 newAllowance = token.allowance(address(this), spender).add(value);
153     require(token.approve(spender, newAllowance));
154   }
155 
156   function safeDecreaseAllowance(
157     IERC20 token,
158     address spender,
159     uint256 value
160   )
161     internal
162   {
163     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
164     require(token.approve(spender, newAllowance));
165   }
166 }
167 /**
168  * @title Helps contracts guard against reentrancy attacks.
169  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
170  * @dev If you mark a function `nonReentrant`, you should also
171  * mark it `external`.
172  */
173 contract ReentrancyGuard {
174 
175   /// @dev counter to allow mutex lock with only one SSTORE operation
176   uint256 private _guardCounter;
177 
178   constructor() internal {
179     // The counter starts at one to prevent changing it from zero to a non-zero
180     // value, which is a more expensive operation.
181     _guardCounter = 1;
182   }
183 
184   /**
185    * @dev Prevents a contract from calling itself, directly or indirectly.
186    * Calling a `nonReentrant` function from another `nonReentrant`
187    * function is not supported. It is possible to prevent this from happening
188    * by making the `nonReentrant` function external, and make it call a
189    * `private` function that does the actual work.
190    */
191   modifier nonReentrant() {
192     _guardCounter += 1;
193     uint256 localCounter = _guardCounter;
194     _;
195     require(localCounter == _guardCounter);
196   }
197 
198 }
199 
200 /**
201  * @title Crowdsale
202  * @dev Crowdsale is a base contract for managing a token crowdsale,
203  * allowing investors to purchase tokens with ether. This contract implements
204  * such functionality in its most fundamental form and can be extended to provide additional
205  * functionality and/or custom behavior.
206  * The external interface represents the basic interface for purchasing tokens, and conform
207  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
208  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
209  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
210  * behavior.
211  */
212 contract Crowdsale is ReentrancyGuard {
213   using SafeMath for uint256;
214   using SafeERC20 for IERC20;
215 
216   // The token being sold
217   IERC20 private _token;
218 
219   // Address where funds are collected
220   address private _wallet;
221 
222   // How many token units a buyer gets per wei.
223   // The rate is the conversion between wei and the smallest and indivisible token unit.
224   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
225   // 1 wei will give you 1 unit, or 0.001 TOK.
226   uint256 private _rate;
227 
228   // Amount of wei raised
229   uint256 private _weiRaised;
230 
231   /**
232    * Event for token purchase logging
233    * @param purchaser who paid for the tokens
234    * @param beneficiary who got the tokens
235    * @param value weis paid for purchase
236    * @param amount amount of tokens purchased
237    */
238   event TokensPurchased(
239     address indexed purchaser,
240     address indexed beneficiary,
241     uint256 value,
242     uint256 amount
243   );
244 
245   /**
246    * @param rate Number of token units a buyer gets per wei
247    * @dev The rate is the conversion between wei and the smallest and indivisible
248    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
249    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
250    * @param wallet Address where collected funds will be forwarded to
251    * @param token Address of the token being sold
252    */
253   constructor(uint256 rate, address wallet, IERC20 token) public {
254     require(rate > 0);
255     require(wallet != address(0));
256     require(token != address(0));
257 
258     _rate = rate;
259     _wallet = wallet;
260     _token = token;
261   }
262 
263   // -----------------------------------------
264   // Crowdsale external interface
265   // -----------------------------------------
266 
267   /**
268    * @dev fallback function ***DO NOT OVERRIDE***
269    * Note that other contracts will transfer fund with a base gas stipend
270    * of 2300, which is not enough to call buyTokens. Consider calling
271    * buyTokens directly when purchasing tokens from a contract.
272    */
273   function () external payable {
274     buyTokens(msg.sender);
275   }
276 
277   /**
278    * @return the token being sold.
279    */
280   function token() public view returns(IERC20) {
281     return _token;
282   }
283 
284   /**
285    * @return the address where funds are collected.
286    */
287   function wallet() public view returns(address) {
288     return _wallet;
289   }
290 
291   /**
292    * @return the number of token units a buyer gets per wei.
293    */
294   function rate() public view returns(uint256) {
295     return _rate;
296   }
297 
298   /**
299    * @return the amount of wei raised.
300    */
301   function weiRaised() public view returns (uint256) {
302     return _weiRaised;
303   }
304 
305   /**
306    * @dev low level token purchase ***DO NOT OVERRIDE***
307    * This function has a non-reentrancy guard, so it shouldn't be called by
308    * another `nonReentrant` function.
309    * @param beneficiary Recipient of the token purchase
310    */
311   function buyTokens(address beneficiary) public nonReentrant payable {
312 
313     uint256 weiAmount = msg.value;
314     _preValidatePurchase(beneficiary, weiAmount);
315 
316     // calculate token amount to be created
317     uint256 tokens = _getTokenAmount(weiAmount);
318 
319     // update state
320     _weiRaised = _weiRaised.add(weiAmount);
321 
322     _processPurchase(beneficiary, tokens);
323     emit TokensPurchased(
324       msg.sender,
325       beneficiary,
326       weiAmount,
327       tokens
328     );
329 
330     _forwardFunds();
331   }
332 
333   // -----------------------------------------
334   // Internal interface (extensible)
335   // -----------------------------------------
336 
337   /**
338    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
339    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
340    *   super._preValidatePurchase(beneficiary, weiAmount);
341    *   require(weiRaised().add(weiAmount) <= cap);
342    * @param beneficiary Address performing the token purchase
343    * @param weiAmount Value in wei involved in the purchase
344    */
345   function _preValidatePurchase(
346     address beneficiary,
347     uint256 weiAmount
348   )
349     internal
350     view
351   {
352     require(beneficiary != address(0));
353     require(weiAmount != 0);
354   }
355 
356 
357   /**
358    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
359    * @param beneficiary Address performing the token purchase
360    * @param tokenAmount Number of tokens to be emitted
361    */
362   function _deliverTokens(
363     address beneficiary,
364     uint256 tokenAmount
365   )
366     internal
367   {
368     _token.safeTransfer(beneficiary, tokenAmount);
369   }
370 
371   /**
372    * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
373    * @param beneficiary Address receiving the tokens
374    * @param tokenAmount Number of tokens to be purchased
375    */
376   function _processPurchase(
377     address beneficiary,
378     uint256 tokenAmount
379   )
380     internal
381   {
382     _deliverTokens(beneficiary, tokenAmount);
383   }
384 
385 
386   /**
387    * @dev Override to extend the way in which ether is converted to tokens.
388    * @param weiAmount Value in wei to be converted into tokens
389    * @return Number of tokens that can be purchased with the specified _weiAmount
390    */
391   function _getTokenAmount(uint256 weiAmount)
392     internal view returns (uint256)
393   {
394     return weiAmount.mul(_rate);
395   }
396 
397   /**
398    * @dev Determines how ETH is stored/forwarded on purchases.
399    */
400   function _forwardFunds() internal {
401     _wallet.transfer(msg.value);
402   }
403 }