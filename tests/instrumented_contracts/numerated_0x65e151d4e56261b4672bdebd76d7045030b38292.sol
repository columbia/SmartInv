1 pragma solidity ^0.4.18;
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
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
172    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
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
234 // File: zeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
235 
236 /**
237  * @title TimedCrowdsale
238  * @dev Crowdsale accepting contributions only within a time frame.
239  */
240 contract TimedCrowdsale is Crowdsale {
241   using SafeMath for uint256;
242 
243   uint256 public openingTime;
244   uint256 public closingTime;
245 
246   /**
247    * @dev Reverts if not in crowdsale time range. 
248    */
249   modifier onlyWhileOpen {
250     require(now >= openingTime && now <= closingTime);
251     _;
252   }
253 
254   /**
255    * @dev Constructor, takes crowdsale opening and closing times.
256    * @param _openingTime Crowdsale opening time
257    * @param _closingTime Crowdsale closing time
258    */
259   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
260     require(_openingTime >= now);
261     require(_closingTime >= _openingTime);
262 
263     openingTime = _openingTime;
264     closingTime = _closingTime;
265   }
266 
267   /**
268    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
269    * @return Whether crowdsale period has elapsed
270    */
271   function hasClosed() public view returns (bool) {
272     return now > closingTime;
273   }
274   
275   /**
276    * @dev Extend parent behavior requiring to be within contributing period
277    * @param _beneficiary Token purchaser
278    * @param _weiAmount Amount of wei contributed
279    */
280   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
281     super._preValidatePurchase(_beneficiary, _weiAmount);
282   }
283 
284 }
285 
286 // File: zeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
287 
288 /**
289  * @title PostDeliveryCrowdsale
290  * @dev Crowdsale that locks tokens from withdrawal until it ends.
291  */
292 contract PostDeliveryCrowdsale is TimedCrowdsale {
293   using SafeMath for uint256;
294 
295   mapping(address => uint256) public balances;
296 
297   /**
298    * @dev Overrides parent by storing balances instead of issuing tokens right away.
299    * @param _beneficiary Token purchaser
300    * @param _tokenAmount Amount of tokens purchased
301    */
302   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
303     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
304   }
305 
306   /**
307    * @dev Withdraw tokens only after crowdsale ends.
308    */
309   function withdrawTokens() public {
310     require(hasClosed());
311     uint256 amount = balances[msg.sender];
312     require(amount > 0);
313     balances[msg.sender] = 0;
314     _deliverTokens(msg.sender, amount);
315   }
316 }
317 
318 // File: zeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol
319 
320 /**
321  * @title AllowanceCrowdsale
322  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
323  */
324 contract AllowanceCrowdsale is Crowdsale {
325   using SafeMath for uint256;
326 
327   address public tokenWallet;
328 
329   /**
330    * @dev Constructor, takes token wallet address. 
331    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
332    */
333   function AllowanceCrowdsale(address _tokenWallet) public {
334     require(_tokenWallet != address(0));
335     tokenWallet = _tokenWallet;
336   }
337 
338   /**
339    * @dev Checks the amount of tokens left in the allowance.
340    * @return Amount of tokens left in the allowance
341    */
342   function remainingTokens() public view returns (uint256) {
343     return token.allowance(tokenWallet, this);
344   }
345 
346   /**
347    * @dev Overrides parent behavior by transferring tokens from wallet.
348    * @param _beneficiary Token purchaser
349    * @param _tokenAmount Amount of tokens purchased
350    */
351   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
352     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
353   }
354 }
355 
356 // File: zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
357 
358 /**
359  * @title CappedCrowdsale
360  * @dev Crowdsale with a limit for total contributions.
361  */
362 contract CappedCrowdsale is Crowdsale {
363   using SafeMath for uint256;
364 
365   uint256 public cap;
366 
367   /**
368    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
369    * @param _cap Max amount of wei to be contributed
370    */
371   function CappedCrowdsale(uint256 _cap) public {
372     require(_cap > 0);
373     cap = _cap;
374   }
375 
376   /**
377    * @dev Checks whether the cap has been reached. 
378    * @return Whether the cap was reached
379    */
380   function capReached() public view returns (bool) {
381     return weiRaised >= cap;
382   }
383 
384   /**
385    * @dev Extend parent behavior requiring purchase to respect the funding cap.
386    * @param _beneficiary Token purchaser
387    * @param _weiAmount Amount of wei contributed
388    */
389   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
390     super._preValidatePurchase(_beneficiary, _weiAmount);
391     require(weiRaised.add(_weiAmount) <= cap);
392   }
393 
394 }
395 
396 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
397 
398 /**
399  * @title Ownable
400  * @dev The Ownable contract has an owner address, and provides basic authorization control
401  * functions, this simplifies the implementation of "user permissions".
402  */
403 contract Ownable {
404   address public owner;
405 
406 
407   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
408 
409 
410   /**
411    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
412    * account.
413    */
414   function Ownable() public {
415     owner = msg.sender;
416   }
417 
418   /**
419    * @dev Throws if called by any account other than the owner.
420    */
421   modifier onlyOwner() {
422     require(msg.sender == owner);
423     _;
424   }
425 
426   /**
427    * @dev Allows the current owner to transfer control of the contract to a newOwner.
428    * @param newOwner The address to transfer ownership to.
429    */
430   function transferOwnership(address newOwner) public onlyOwner {
431     require(newOwner != address(0));
432     OwnershipTransferred(owner, newOwner);
433     owner = newOwner;
434   }
435 
436 }
437 
438 // File: zeppelin-solidity/contracts/crowdsale/validation/IndividuallyCappedCrowdsale.sol
439 
440 /**
441  * @title IndividuallyCappedCrowdsale
442  * @dev Crowdsale with per-user caps.
443  */
444 contract IndividuallyCappedCrowdsale is Crowdsale, Ownable {
445   using SafeMath for uint256;
446 
447   mapping(address => uint256) public contributions;
448   mapping(address => uint256) public caps;
449 
450   /**
451    * @dev Sets a specific user's maximum contribution.
452    * @param _beneficiary Address to be capped
453    * @param _cap Wei limit for individual contribution
454    */
455   function setUserCap(address _beneficiary, uint256 _cap) external onlyOwner {
456     caps[_beneficiary] = _cap;
457   }
458 
459   /**
460    * @dev Sets a group of users' maximum contribution.
461    * @param _beneficiaries List of addresses to be capped
462    * @param _cap Wei limit for individual contribution
463    */
464   function setGroupCap(address[] _beneficiaries, uint256 _cap) external onlyOwner {
465     for (uint256 i = 0; i < _beneficiaries.length; i++) {
466       caps[_beneficiaries[i]] = _cap;
467     }
468   }
469 
470   /**
471    * @dev Returns the cap of a specific user.
472    * @param _beneficiary Address whose cap is to be checked
473    * @return Current cap for individual user
474    */
475   function getUserCap(address _beneficiary) public view returns (uint256) {
476     return caps[_beneficiary];
477   }
478 
479   /**
480    * @dev Returns the amount contributed so far by a sepecific user.
481    * @param _beneficiary Address of contributor
482    * @return User contribution so far
483    */
484   function getUserContribution(address _beneficiary) public view returns (uint256) {
485     return contributions[_beneficiary];
486   }
487 
488   /**
489    * @dev Extend parent behavior requiring purchase to respect the user's funding cap.
490    * @param _beneficiary Token purchaser
491    * @param _weiAmount Amount of wei contributed
492    */
493   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
494     super._preValidatePurchase(_beneficiary, _weiAmount);
495     require(contributions[_beneficiary].add(_weiAmount) <= caps[_beneficiary]);
496   }
497 
498   /**
499    * @dev Extend parent behavior to update user contributions
500    * @param _beneficiary Token purchaser
501    * @param _weiAmount Amount of wei contributed
502    */
503   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
504     super._updatePurchasingState(_beneficiary, _weiAmount);
505     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
506   }
507 
508 }
509 
510 // File: contracts/CarboneumCrowdsale.sol
511 
512 /**
513  * @title CarboneumCrowdsale
514  * @dev This is Carboneum fully fledged crowdsale.
515  * CappedCrowdsale - sets a max boundary for raised funds.
516  * AllowanceCrowdsale - token held by a wallet.
517  * IndividuallyCappedCrowdsale - Crowdsale with per-user caps.
518  * TimedCrowdsale - Crowdsale accepting contributions only within a time frame.
519  */
520 contract CarboneumCrowdsale is CappedCrowdsale, AllowanceCrowdsale, IndividuallyCappedCrowdsale, TimedCrowdsale, PostDeliveryCrowdsale {
521 
522   uint256 public pre_sale_end;
523 
524   function CarboneumCrowdsale(
525     uint256 _openingTime,
526     uint256 _closingTime,
527     uint256 _rate,
528     address _tokenWallet,
529     address _fundWallet,
530     uint256 _cap,
531     ERC20 _token,
532     uint256 _preSaleEnd) public
533   AllowanceCrowdsale(_tokenWallet)
534   Crowdsale(_rate, _fundWallet, _token)
535   CappedCrowdsale(_cap)
536   TimedCrowdsale(_openingTime, _closingTime)
537   {
538     require(_preSaleEnd < _closingTime);
539     pre_sale_end = _preSaleEnd;
540   }
541 
542   function setRate(uint256 _rate) external onlyOwner {
543     rate = _rate;
544   }
545 
546   /**
547    * @dev Add bonus to pre-sale period.
548    * @param _weiAmount Value in wei to be converted into tokens
549    * @return Number of tokens that can be purchased with the specified _weiAmount
550    */
551   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
552     if (now < pre_sale_end) {// solium-disable-line security/no-block-members
553       // Bonus 8%
554       return _weiAmount.mul(rate + (rate * 8 / 100));
555     }
556     return _weiAmount.mul(rate);
557   }
558 
559 }