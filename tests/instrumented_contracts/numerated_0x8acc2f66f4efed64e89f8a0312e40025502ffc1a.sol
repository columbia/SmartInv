1 pragma solidity ^0.4.23;
2 
3 // File: contracts/openzeppelin-solidity/contracts/math/SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
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
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: contracts/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
65 // File: contracts/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender)
73     public view returns (uint256);
74 
75   function transferFrom(address from, address to, uint256 value)
76     public returns (bool);
77 
78   function approve(address spender, uint256 value) public returns (bool);
79   event Approval(
80     address indexed owner,
81     address indexed spender,
82     uint256 value
83   );
84 }
85 
86 // File: contracts/openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
87 
88 /**
89  * @title Crowdsale
90  * @dev Crowdsale is a base contract for managing a token crowdsale,
91  * allowing investors to purchase tokens with ether. This contract implements
92  * such functionality in its most fundamental form and can be extended to provide additional
93  * functionality and/or custom behavior.
94  * The external interface represents the basic interface for purchasing tokens, and conform
95  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
96  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
97  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
98  * behavior.
99  */
100 contract Crowdsale {
101   using SafeMath for uint256;
102 
103   // The token being sold
104   ERC20 public token;
105 
106   // Address where funds are collected
107   address public wallet;
108 
109   // How many token units a buyer gets per wei
110   uint256 public rate;
111 
112   // Amount of wei raised
113   uint256 public weiRaised;
114 
115   /**
116    * Event for token purchase logging
117    * @param purchaser who paid for the tokens
118    * @param beneficiary who got the tokens
119    * @param value weis paid for purchase
120    * @param amount amount of tokens purchased
121    */
122   event TokenPurchase(
123     address indexed purchaser,
124     address indexed beneficiary,
125     uint256 value,
126     uint256 amount
127   );
128 
129   /**
130    * @param _rate Number of token units a buyer gets per wei
131    * @param _wallet Address where collected funds will be forwarded to
132    * @param _token Address of the token being sold
133    */
134   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
135     require(_rate > 0);
136     require(_wallet != address(0));
137     require(_token != address(0));
138 
139     rate = _rate;
140     wallet = _wallet;
141     token = _token;
142   }
143 
144   // -----------------------------------------
145   // Crowdsale external interface
146   // -----------------------------------------
147 
148   /**
149    * @dev fallback function ***DO NOT OVERRIDE***
150    */
151   function () external payable {
152     buyTokens(msg.sender);
153   }
154 
155   /**
156    * @dev low level token purchase ***DO NOT OVERRIDE***
157    * @param _beneficiary Address performing the token purchase
158    */
159   function buyTokens(address _beneficiary) public payable {
160 
161     uint256 weiAmount = msg.value;
162     _preValidatePurchase(_beneficiary, weiAmount);
163 
164     // calculate token amount to be created
165     uint256 tokens = _getTokenAmount(weiAmount);
166 
167     // update state
168     weiRaised = weiRaised.add(weiAmount);
169 
170     _processPurchase(_beneficiary, tokens);
171     emit TokenPurchase(
172       msg.sender,
173       _beneficiary,
174       weiAmount,
175       tokens
176     );
177 
178     _updatePurchasingState(_beneficiary, weiAmount);
179 
180     _forwardFunds();
181     _postValidatePurchase(_beneficiary, weiAmount);
182   }
183 
184   // -----------------------------------------
185   // Internal interface (extensible)
186   // -----------------------------------------
187 
188   /**
189    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
190    * @param _beneficiary Address performing the token purchase
191    * @param _weiAmount Value in wei involved in the purchase
192    */
193   function _preValidatePurchase(
194     address _beneficiary,
195     uint256 _weiAmount
196   )
197     internal
198   {
199     require(_beneficiary != address(0));
200     require(_weiAmount != 0);
201   }
202 
203   /**
204    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
205    * @param _beneficiary Address performing the token purchase
206    * @param _weiAmount Value in wei involved in the purchase
207    */
208   function _postValidatePurchase(
209     address _beneficiary,
210     uint256 _weiAmount
211   )
212     internal
213   {
214     // optional override
215   }
216 
217   /**
218    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
219    * @param _beneficiary Address performing the token purchase
220    * @param _tokenAmount Number of tokens to be emitted
221    */
222   function _deliverTokens(
223     address _beneficiary,
224     uint256 _tokenAmount
225   )
226     internal
227   {
228     token.transfer(_beneficiary, _tokenAmount);
229   }
230 
231   /**
232    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
233    * @param _beneficiary Address receiving the tokens
234    * @param _tokenAmount Number of tokens to be purchased
235    */
236   function _processPurchase(
237     address _beneficiary,
238     uint256 _tokenAmount
239   )
240     internal
241   {
242     _deliverTokens(_beneficiary, _tokenAmount);
243   }
244 
245   /**
246    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
247    * @param _beneficiary Address receiving the tokens
248    * @param _weiAmount Value in wei involved in the purchase
249    */
250   function _updatePurchasingState(
251     address _beneficiary,
252     uint256 _weiAmount
253   )
254     internal
255   {
256     // optional override
257   }
258 
259   /**
260    * @dev Override to extend the way in which ether is converted to tokens.
261    * @param _weiAmount Value in wei to be converted into tokens
262    * @return Number of tokens that can be purchased with the specified _weiAmount
263    */
264   function _getTokenAmount(uint256 _weiAmount)
265     internal view returns (uint256)
266   {
267     return _weiAmount.mul(rate);
268   }
269 
270   /**
271    * @dev Determines how ETH is stored/forwarded on purchases.
272    */
273   function _forwardFunds() internal {
274     wallet.transfer(msg.value);
275   }
276 }
277 
278 // File: contracts/openzeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol
279 
280 /**
281  * @title AllowanceCrowdsale
282  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
283  */
284 contract AllowanceCrowdsale is Crowdsale {
285   using SafeMath for uint256;
286 
287   address public tokenWallet;
288 
289   /**
290    * @dev Constructor, takes token wallet address.
291    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
292    */
293   constructor(address _tokenWallet) public {
294     require(_tokenWallet != address(0));
295     tokenWallet = _tokenWallet;
296   }
297 
298   /**
299    * @dev Checks the amount of tokens left in the allowance.
300    * @return Amount of tokens left in the allowance
301    */
302   function remainingTokens() public view returns (uint256) {
303     return token.allowance(tokenWallet, this);
304   }
305 
306   /**
307    * @dev Overrides parent behavior by transferring tokens from wallet.
308    * @param _beneficiary Token purchaser
309    * @param _tokenAmount Amount of tokens purchased
310    */
311   function _deliverTokens(
312     address _beneficiary,
313     uint256 _tokenAmount
314   )
315     internal
316   {
317     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
318   }
319 }
320 
321 // File: contracts/openzeppelin-solidity/contracts/ownership/Ownable.sol
322 
323 /**
324  * @title Ownable
325  * @dev The Ownable contract has an owner address, and provides basic authorization control
326  * functions, this simplifies the implementation of "user permissions".
327  */
328 contract Ownable {
329   address public owner;
330 
331 
332   event OwnershipRenounced(address indexed previousOwner);
333   event OwnershipTransferred(
334     address indexed previousOwner,
335     address indexed newOwner
336   );
337 
338 
339   /**
340    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
341    * account.
342    */
343   constructor() public {
344     owner = msg.sender;
345   }
346 
347   /**
348    * @dev Throws if called by any account other than the owner.
349    */
350   modifier onlyOwner() {
351     require(msg.sender == owner);
352     _;
353   }
354 
355   /**
356    * @dev Allows the current owner to transfer control of the contract to a newOwner.
357    * @param newOwner The address to transfer ownership to.
358    */
359   function transferOwnership(address newOwner) public onlyOwner {
360     require(newOwner != address(0));
361     emit OwnershipTransferred(owner, newOwner);
362     owner = newOwner;
363   }
364 
365   /**
366    * @dev Allows the current owner to relinquish control of the contract.
367    */
368   function renounceOwnership() public onlyOwner {
369     emit OwnershipRenounced(owner);
370     owner = address(0);
371   }
372 }
373 
374 // File: contracts/UpdatableCrowdsale.sol
375 
376 /**
377  * @title UpdatableCrowdsale
378  * @dev Extension of AllowanceCrowdsale contract that allows updates to the exchange rate used to 
379  * calculate the token sale price (rate of tokens to issue per wei contributed).  
380  * Note that what should be provided to the constructor is the _initialRate (price per token in wei),
381  * and the _tokenWallet that is going to provide an allowance from which the token sale can distribute
382  * the tokent.
383  */
384 contract UpdatableCrowdsale is AllowanceCrowdsale, Ownable {
385   // using SafeMath for uint256; // using from parent
386 
387   event RateUpdated(uint256 oldRate, uint256 newRate);
388 
389   // The number of decimals for the rate
390   uint256 public rateDecimals = 9;
391 
392   /**
393    * @dev Constructor, takes the rate of tokens received per wei contributed, the
394    * wallet address which will hold the authorized tokens for the sale (and also
395    * is the recipient of the Ether contrubited), and the ERC20 token contract
396    * for which we will be selling tokens.
397    * @param _rate Number of tokens a buyer gets per wei at the start of the crowdsale
398    * @param _wallet The address of the wallet from which tokens will be sold
399    * @param _token The ERC20 token contract that holds the tokens we're selling
400    */
401   constructor (uint256 _rate, address _wallet, ERC20 _token) public
402     AllowanceCrowdsale(_wallet)
403     Crowdsale(_rate, _wallet, _token)
404   {
405     // Everything handled in parents
406   }
407 
408   /**
409    * @dev Returns the rate of tokens per wei at the present time. 
410    * @return The number of tokens a buyer gets per wei at a given time
411    */
412   function setCurrentRate(uint256 _newRate) public onlyOwner returns (uint256) {
413     require(_newRate > 0); 
414     uint256 oldRate_ = rate;
415     rate = _newRate;
416     emit RateUpdated(oldRate_, rate);
417   }
418 
419   /**
420    * @dev Overrides parent method taking into account variable rate.
421    * @param _weiAmount The value in wei to be converted into tokens
422    * @return The number of tokens _weiAmount wei will buy at present time
423    */
424   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
425     return rate.mul(_weiAmount).div(10**rateDecimals);
426   }
427 
428   /**
429    * @dev Get token estimate based on current rate
430    * @param _weiAmount The amount of wei that will be sent
431    */ 
432   function estimate(uint256 _weiAmount) public view returns (uint256) {
433     return _getTokenAmount(_weiAmount);
434   }
435 
436 }