1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
27     // benefit is lost if 'b' is also tested.
28     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29     if (a == 0) {
30       return 0;
31     }
32 
33     c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   /**
39   * @dev Integer division of two numbers, truncating the quotient.
40   */
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     // uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return a / b;
46   }
47 
48   /**
49   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50   */
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   /**
57   * @dev Adds two numbers, throws on overflow.
58   */
59   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
60     c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 }
65 
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
86 
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
109   // How many token units a buyer gets per wei.
110   // The rate is the conversion between wei and the smallest and indivisible token unit.
111   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
112   // 1 wei will give you 1 unit, or 0.001 TOK.
113   uint256 public rate;
114 
115   // Amount of wei raised
116   uint256 public weiRaised;
117 
118   /**
119    * Event for token purchase logging
120    * @param purchaser who paid for the tokens
121    * @param beneficiary who got the tokens
122    * @param value weis paid for purchase
123    * @param amount amount of tokens purchased
124    */
125   event TokenPurchase(
126     address indexed purchaser,
127     address indexed beneficiary,
128     uint256 value,
129     uint256 amount
130   );
131 
132   /**
133    * @param _rate Number of token units a buyer gets per wei
134    * @param _wallet Address where collected funds will be forwarded to
135    * @param _token Address of the token being sold
136    */
137   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
138     require(_rate > 0);
139     require(_wallet != address(0));
140     require(_token != address(0));
141 
142     rate = _rate;
143     wallet = _wallet;
144     token = _token;
145   }
146 
147   // -----------------------------------------
148   // Crowdsale external interface
149   // -----------------------------------------
150 
151   /**
152    * @dev fallback function ***DO NOT OVERRIDE***
153    */
154   function () external payable {
155     buyTokens(msg.sender);
156   }
157 
158   /**
159    * @dev low level token purchase ***DO NOT OVERRIDE***
160    * @param _beneficiary Address performing the token purchase
161    */
162   function buyTokens(address _beneficiary) public payable {
163 
164     uint256 weiAmount = msg.value;
165     _preValidatePurchase(_beneficiary, weiAmount);
166 
167     // calculate token amount to be created
168     uint256 tokens = _getTokenAmount(weiAmount);
169 
170     // update state
171     weiRaised = weiRaised.add(weiAmount);
172 
173     _processPurchase(_beneficiary, tokens);
174     emit TokenPurchase(
175       msg.sender,
176       _beneficiary,
177       weiAmount,
178       tokens
179     );
180 
181     _updatePurchasingState(_beneficiary, weiAmount);
182 
183     _forwardFunds();
184     _postValidatePurchase(_beneficiary, weiAmount);
185   }
186 
187   // -----------------------------------------
188   // Internal interface (extensible)
189   // -----------------------------------------
190 
191   /**
192    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
193    * @param _beneficiary Address performing the token purchase
194    * @param _weiAmount Value in wei involved in the purchase
195    */
196   function _preValidatePurchase(
197     address _beneficiary,
198     uint256 _weiAmount
199   )
200     internal
201   {
202     require(_beneficiary != address(0));
203     require(_weiAmount != 0);
204   }
205 
206   /**
207    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
208    * @param _beneficiary Address performing the token purchase
209    * @param _weiAmount Value in wei involved in the purchase
210    */
211   function _postValidatePurchase(
212     address _beneficiary,
213     uint256 _weiAmount
214   )
215     internal
216   {
217     // optional override
218   }
219 
220   /**
221    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
222    * @param _beneficiary Address performing the token purchase
223    * @param _tokenAmount Number of tokens to be emitted
224    */
225   function _deliverTokens(
226     address _beneficiary,
227     uint256 _tokenAmount
228   )
229     internal
230   {
231     token.transfer(_beneficiary, _tokenAmount);
232   }
233 
234   /**
235    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
236    * @param _beneficiary Address receiving the tokens
237    * @param _tokenAmount Number of tokens to be purchased
238    */
239   function _processPurchase(
240     address _beneficiary,
241     uint256 _tokenAmount
242   )
243     internal
244   {
245     _deliverTokens(_beneficiary, _tokenAmount);
246   }
247 
248   /**
249    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
250    * @param _beneficiary Address receiving the tokens
251    * @param _weiAmount Value in wei involved in the purchase
252    */
253   function _updatePurchasingState(
254     address _beneficiary,
255     uint256 _weiAmount
256   )
257     internal
258   {
259     // optional override
260   }
261 
262   /**
263    * @dev Override to extend the way in which ether is converted to tokens.
264    * @param _weiAmount Value in wei to be converted into tokens
265    * @return Number of tokens that can be purchased with the specified _weiAmount
266    */
267   function _getTokenAmount(uint256 _weiAmount)
268     internal view returns (uint256)
269   {
270     return _weiAmount.mul(rate);
271   }
272 
273   /**
274    * @dev Determines how ETH is stored/forwarded on purchases.
275    */
276   function _forwardFunds() internal {
277     wallet.transfer(msg.value);
278   }
279 }
280 
281 
282 
283 
284 /**
285  * @title AllowanceCrowdsale
286  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
287  */
288 contract AllowanceCrowdsale is Crowdsale {
289   using SafeMath for uint256;
290 
291   address public tokenWallet;
292 
293   /**
294    * @dev Constructor, takes token wallet address.
295    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
296    */
297   constructor(address _tokenWallet) public {
298     require(_tokenWallet != address(0));
299     tokenWallet = _tokenWallet;
300   }
301 
302   /**
303    * @dev Checks the amount of tokens left in the allowance.
304    * @return Amount of tokens left in the allowance
305    */
306   function remainingTokens() public view returns (uint256) {
307     return token.allowance(tokenWallet, this);
308   }
309 
310   /**
311    * @dev Overrides parent behavior by transferring tokens from wallet.
312    * @param _beneficiary Token purchaser
313    * @param _tokenAmount Amount of tokens purchased
314    */
315   function _deliverTokens(
316     address _beneficiary,
317     uint256 _tokenAmount
318   )
319     internal
320   {
321     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
322   }
323 }
324 /**
325  * @title Ownable
326  * @dev The Ownable contract has an owner address, and provides basic authorization control
327  * functions, this simplifies the implementation of "user permissions".
328  */
329 contract Ownable {
330   address public owner;
331 
332 
333   event OwnershipRenounced(address indexed previousOwner);
334   event OwnershipTransferred(
335     address indexed previousOwner,
336     address indexed newOwner
337   );
338 
339 
340   /**
341    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
342    * account.
343    */
344   constructor() public {
345     owner = msg.sender;
346   }
347 
348   /**
349    * @dev Throws if called by any account other than the owner.
350    */
351   modifier onlyOwner() {
352     require(msg.sender == owner);
353     _;
354   }
355 
356   /**
357    * @dev Allows the current owner to relinquish control of the contract.
358    */
359   function renounceOwnership() public onlyOwner {
360     emit OwnershipRenounced(owner);
361     owner = address(0);
362   }
363 
364   /**
365    * @dev Allows the current owner to transfer control of the contract to a newOwner.
366    * @param _newOwner The address to transfer ownership to.
367    */
368   function transferOwnership(address _newOwner) public onlyOwner {
369     _transferOwnership(_newOwner);
370   }
371 
372   /**
373    * @dev Transfers control of the contract to a newOwner.
374    * @param _newOwner The address to transfer ownership to.
375    */
376   function _transferOwnership(address _newOwner) internal {
377     require(_newOwner != address(0));
378     emit OwnershipTransferred(owner, _newOwner);
379     owner = _newOwner;
380   }
381 }
382 
383 
384 /**
385  * @title WhitelistedCrowdsale
386  * @dev Crowdsale in which only whitelisted users can contribute.
387  */
388 contract WhitelistedCrowdsale is Crowdsale, Ownable {
389 
390   mapping(address => bool) public whitelist;
391 
392   /**
393    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
394    */
395   modifier isWhitelisted(address _beneficiary) {
396     require(whitelist[_beneficiary]);
397     _;
398   }
399 
400   /**
401    * @dev Adds single address to whitelist.
402    * @param _beneficiary Address to be added to the whitelist
403    */
404   function addToWhitelist(address _beneficiary) external onlyOwner {
405     whitelist[_beneficiary] = true;
406   }
407 
408   /**
409    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
410    * @param _beneficiaries Addresses to be added to the whitelist
411    */
412   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
413     for (uint256 i = 0; i < _beneficiaries.length; i++) {
414       whitelist[_beneficiaries[i]] = true;
415     }
416   }
417 
418   /**
419    * @dev Removes single address from whitelist.
420    * @param _beneficiary Address to be removed to the whitelist
421    */
422   function removeFromWhitelist(address _beneficiary) external onlyOwner {
423     whitelist[_beneficiary] = false;
424   }
425 
426   /**
427    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
428    * @param _beneficiary Token beneficiary
429    * @param _weiAmount Amount of wei contributed
430    */
431   function _preValidatePurchase(
432     address _beneficiary,
433     uint256 _weiAmount
434   )
435     internal
436     isWhitelisted(_beneficiary)
437   {
438     super._preValidatePurchase(_beneficiary, _weiAmount);
439   }
440 
441 }
442 
443 
444 // contract PresaleCrowdsale is AllowanceCrowdsale, WhitelistedCrowdsale {
445 contract PresaleCrowdsale is AllowanceCrowdsale {
446   constructor(
447     uint256 _rate,
448     address _wallet,
449     ERC20 _token,
450     address _tokenWallet
451   )
452     Crowdsale(_rate, _wallet, _token)
453     AllowanceCrowdsale(_tokenWallet)
454     public
455   {}
456 }