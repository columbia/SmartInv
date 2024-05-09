1 pragma solidity ^0.4.21;
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
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     emit OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 
60 
61 
62 
63 
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that throw on error
67  */
68 library SafeMath {
69 
70   /**
71   * @dev Multiplies two numbers, throws on overflow.
72   */
73   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
74     if (a == 0) {
75       return 0;
76     }
77     c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     // uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return a / b;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
104     c = a + b;
105     assert(c >= a);
106     return c;
107   }
108 }
109 
110 
111 
112 
113 
114 
115 
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender) public view returns (uint256);
123   function transferFrom(address from, address to, uint256 value) public returns (bool);
124   function approve(address spender, uint256 value) public returns (bool);
125   event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 
129 
130 
131 /**
132  * @title Crowdsale
133  * @dev Crowdsale is a base contract for managing a token crowdsale,
134  * allowing investors to purchase tokens with ether. This contract implements
135  * such functionality in its most fundamental form and can be extended to provide additional
136  * functionality and/or custom behavior.
137  * The external interface represents the basic interface for purchasing tokens, and conform
138  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
139  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
140  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
141  * behavior.
142  */
143 contract Crowdsale {
144   using SafeMath for uint256;
145 
146   // The token being sold
147   ERC20 public token;
148 
149   // Address where funds are collected
150   address public wallet;
151 
152   // How many token units a buyer gets per wei
153   uint256 public rate;
154 
155   // Amount of wei raised
156   uint256 public weiRaised;
157 
158   /**
159    * Event for token purchase logging
160    * @param purchaser who paid for the tokens
161    * @param beneficiary who got the tokens
162    * @param value weis paid for purchase
163    * @param amount amount of tokens purchased
164    */
165   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
166 
167   /**
168    * @param _rate Number of token units a buyer gets per wei
169    * @param _wallet Address where collected funds will be forwarded to
170    * @param _token Address of the token being sold
171    */
172   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
173     require(_rate > 0);
174     require(_wallet != address(0));
175     require(_token != address(0));
176 
177     rate = _rate;
178     wallet = _wallet;
179     token = _token;
180   }
181 
182   // -----------------------------------------
183   // Crowdsale external interface
184   // -----------------------------------------
185 
186   /**
187    * @dev fallback function ***DO NOT OVERRIDE***
188    */
189   function () external payable {
190     buyTokens(msg.sender);
191   }
192 
193   /**
194    * @dev low level token purchase ***DO NOT OVERRIDE***
195    * @param _beneficiary Address performing the token purchase
196    */
197   function buyTokens(address _beneficiary) public payable {
198 
199     uint256 weiAmount = msg.value;
200     _preValidatePurchase(_beneficiary, weiAmount);
201 
202     // calculate token amount to be created
203     uint256 tokens = _getTokenAmount(weiAmount);
204 
205     // update state
206     weiRaised = weiRaised.add(weiAmount);
207 
208     _processPurchase(_beneficiary, tokens);
209     emit TokenPurchase(
210       msg.sender,
211       _beneficiary,
212       weiAmount,
213       tokens
214     );
215 
216     _updatePurchasingState(_beneficiary, weiAmount);
217 
218     _forwardFunds();
219     _postValidatePurchase(_beneficiary, weiAmount);
220   }
221 
222   // -----------------------------------------
223   // Internal interface (extensible)
224   // -----------------------------------------
225 
226   /**
227    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
228    * @param _beneficiary Address performing the token purchase
229    * @param _weiAmount Value in wei involved in the purchase
230    */
231   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
232     require(_beneficiary != address(0));
233     require(_weiAmount != 0);
234   }
235 
236   /**
237    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
238    * @param _beneficiary Address performing the token purchase
239    * @param _weiAmount Value in wei involved in the purchase
240    */
241   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
242     // optional override
243   }
244 
245   /**
246    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
247    * @param _beneficiary Address performing the token purchase
248    * @param _tokenAmount Number of tokens to be emitted
249    */
250   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
251     token.transfer(_beneficiary, _tokenAmount);
252   }
253 
254   /**
255    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
256    * @param _beneficiary Address receiving the tokens
257    * @param _tokenAmount Number of tokens to be purchased
258    */
259   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
260     _deliverTokens(_beneficiary, _tokenAmount);
261   }
262 
263   /**
264    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
265    * @param _beneficiary Address receiving the tokens
266    * @param _weiAmount Value in wei involved in the purchase
267    */
268   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
269     // optional override
270   }
271 
272   /**
273    * @dev Override to extend the way in which ether is converted to tokens.
274    * @param _weiAmount Value in wei to be converted into tokens
275    * @return Number of tokens that can be purchased with the specified _weiAmount
276    */
277   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
278     return _weiAmount.mul(rate);
279   }
280 
281   /**
282    * @dev Determines how ETH is stored/forwarded on purchases.
283    */
284   function _forwardFunds() internal {
285     wallet.transfer(msg.value);
286   }
287 }
288 
289 
290 
291 /**
292  * @title CappedCrowdsale
293  * @dev Crowdsale with a limit for total contributions.
294  */
295 contract CappedCrowdsale is Crowdsale {
296   using SafeMath for uint256;
297 
298   uint256 public cap;
299 
300   /**
301    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
302    * @param _cap Max amount of wei to be contributed
303    */
304   function CappedCrowdsale(uint256 _cap) public {
305     require(_cap > 0);
306     cap = _cap;
307   }
308 
309   /**
310    * @dev Checks whether the cap has been reached. 
311    * @return Whether the cap was reached
312    */
313   function capReached() public view returns (bool) {
314     return weiRaised >= cap;
315   }
316 
317   /**
318    * @dev Extend parent behavior requiring purchase to respect the funding cap.
319    * @param _beneficiary Token purchaser
320    * @param _weiAmount Amount of wei contributed
321    */
322   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
323     super._preValidatePurchase(_beneficiary, _weiAmount);
324     require(weiRaised.add(_weiAmount) <= cap);
325   }
326 
327 }
328 
329 
330 
331 
332 
333 
334 
335 /**
336  * @title TimedCrowdsale
337  * @dev Crowdsale accepting contributions only within a time frame.
338  */
339 contract TimedCrowdsale is Crowdsale {
340   using SafeMath for uint256;
341 
342   uint256 public openingTime;
343   uint256 public closingTime;
344 
345   /**
346    * @dev Reverts if not in crowdsale time range.
347    */
348   modifier onlyWhileOpen {
349     // solium-disable-next-line security/no-block-members
350     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
351     _;
352   }
353 
354   /**
355    * @dev Constructor, takes crowdsale opening and closing times.
356    * @param _openingTime Crowdsale opening time
357    * @param _closingTime Crowdsale closing time
358    */
359   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
360     // solium-disable-next-line security/no-block-members
361     require(_openingTime >= block.timestamp);
362     require(_closingTime >= _openingTime);
363 
364     openingTime = _openingTime;
365     closingTime = _closingTime;
366   }
367 
368   /**
369    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
370    * @return Whether crowdsale period has elapsed
371    */
372   function hasClosed() public view returns (bool) {
373     // solium-disable-next-line security/no-block-members
374     return block.timestamp > closingTime;
375   }
376 
377   /**
378    * @dev Extend parent behavior requiring to be within contributing period
379    * @param _beneficiary Token purchaser
380    * @param _weiAmount Amount of wei contributed
381    */
382   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
383     super._preValidatePurchase(_beneficiary, _weiAmount);
384   }
385 
386 }
387 
388 
389 
390 
391 
392 
393 
394 
395 /**
396  * @title FinalizableCrowdsale
397  * @dev Extension of Crowdsale where an owner can do extra work
398  * after finishing.
399  */
400 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
401   using SafeMath for uint256;
402 
403   bool public isFinalized = false;
404 
405   event Finalized();
406 
407   /**
408    * @dev Must be called after crowdsale ends, to do some extra finalization
409    * work. Calls the contract's finalization function.
410    */
411   function finalize() onlyOwner public {
412     require(!isFinalized);
413     require(hasClosed());
414 
415     finalization();
416     emit Finalized();
417 
418     isFinalized = true;
419   }
420 
421   /**
422    * @dev Can be overridden to add finalization logic. The overriding function
423    * should call super.finalization() to ensure the chain of finalization is
424    * executed entirely.
425    */
426   function finalization() internal {
427   }
428 
429 }
430 
431 
432 
433 
434 
435 
436 
437 /**
438  * @title Whitelist
439  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
440  * @dev This simplifies the implementation of "user permissions".
441  */
442 contract Whitelist is Ownable {
443   mapping(address => bool) public whitelist;
444 
445   event WhitelistedAddressAdded(address addr);
446   event WhitelistedAddressRemoved(address addr);
447 
448   /**
449    * @dev Throws if called by any account that's not whitelisted.
450    */
451   modifier onlyWhitelisted() {
452     require(whitelist[msg.sender]);
453     _;
454   }
455 
456   /**
457    * @dev add an address to the whitelist
458    * @param addr address
459    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
460    */
461   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
462     if (!whitelist[addr]) {
463       whitelist[addr] = true;
464       emit WhitelistedAddressAdded(addr);
465       success = true;
466     }
467   }
468 
469   /**
470    * @dev add addresses to the whitelist
471    * @param addrs addresses
472    * @return true if at least one address was added to the whitelist,
473    * false if all addresses were already in the whitelist
474    */
475   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
476     for (uint256 i = 0; i < addrs.length; i++) {
477       if (addAddressToWhitelist(addrs[i])) {
478         success = true;
479       }
480     }
481   }
482 
483   /**
484    * @dev remove an address from the whitelist
485    * @param addr address
486    * @return true if the address was removed from the whitelist,
487    * false if the address wasn't in the whitelist in the first place
488    */
489   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
490     if (whitelist[addr]) {
491       whitelist[addr] = false;
492       emit WhitelistedAddressRemoved(addr);
493       success = true;
494     }
495   }
496 
497   /**
498    * @dev remove addresses from the whitelist
499    * @param addrs addresses
500    * @return true if at least one address was removed from the whitelist,
501    * false if all addresses weren't in the whitelist in the first place
502    */
503   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
504     for (uint256 i = 0; i < addrs.length; i++) {
505       if (removeAddressFromWhitelist(addrs[i])) {
506         success = true;
507       }
508     }
509   }
510 
511 }
512 
513 
514 
515 
516 
517 
518 
519 /**
520  * @title Pausable
521  * @dev Base contract which allows children to implement an emergency stop mechanism.
522  */
523 contract Pausable is Ownable {
524   event Pause();
525   event Unpause();
526 
527   bool public paused = false;
528 
529 
530   /**
531    * @dev Modifier to make a function callable only when the contract is not paused.
532    */
533   modifier whenNotPaused() {
534     require(!paused);
535     _;
536   }
537 
538   /**
539    * @dev Modifier to make a function callable only when the contract is paused.
540    */
541   modifier whenPaused() {
542     require(paused);
543     _;
544   }
545 
546   /**
547    * @dev called by the owner to pause, triggers stopped state
548    */
549   function pause() onlyOwner whenNotPaused public {
550     paused = true;
551     emit Pause();
552   }
553 
554   /**
555    * @dev called by the owner to unpause, returns to normal state
556    */
557   function unpause() onlyOwner whenPaused public {
558     paused = false;
559     emit Unpause();
560   }
561 }
562 
563 
564 contract TokenSale is Ownable, CappedCrowdsale, FinalizableCrowdsale, Whitelist, Pausable {
565 
566   bool public initialized;
567   uint[10] public rates;
568   uint[10] public times;
569   uint public noOfWaves;
570   address public wallet;
571   address public reserveWallet;
572   uint public minContribution;
573   uint public maxContribution;
574 
575   function TokenSale(uint _openingTime, uint _endTime, uint _rate, uint _hardCap, ERC20 _token, address _reserveWallet, uint _minContribution, uint _maxContribution)
576   Crowdsale(_rate, _reserveWallet, _token)
577   CappedCrowdsale(_hardCap) TimedCrowdsale(_openingTime, _endTime) {
578     require(_token != address(0));
579     require(_reserveWallet !=address(0));
580     require(_maxContribution > 0);
581     require(_minContribution > 0);
582     reserveWallet = _reserveWallet;
583     minContribution = _minContribution;
584     maxContribution = _maxContribution;
585   }
586 
587   function initRates(uint[] _rates, uint[] _times) external onlyOwner {
588     require(now < openingTime);
589     require(_rates.length == _times.length);
590     require(_rates.length > 0);
591     noOfWaves = _rates.length;
592 
593     for(uint8 i=0;i<_rates.length;i++) {
594       rates[i] = _rates[i];
595       times[i] = _times[i];
596     }
597     initialized = true;
598   }
599 
600   function getCurrentRate() public view returns (uint256) {
601     for(uint i=0;i<noOfWaves;i++) {
602       if(now <= times[i]) {
603         return rates[i];
604       }
605     }
606     return 0;
607   }
608 
609   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
610     uint rate  = getCurrentRate();
611     return _weiAmount.mul(rate);
612   }
613 
614   function setWallet(address _wallet) onlyOwner public {
615     wallet = _wallet;
616   }
617 
618   function setReserveWallet(address _reserve) onlyOwner public {
619     require(_reserve != address(0));
620     reserveWallet = _reserve;
621   }
622 
623   function setMinContribution(uint _min) onlyOwner public {
624     require(_min > 0);
625     minContribution = _min;
626   }
627 
628   function setMaxContribution(uint _max) onlyOwner public {
629     require(_max > 0);
630     maxContribution = _max;
631   }
632 
633   function finalization() internal {
634     require(wallet != address(0));
635     wallet.transfer(this.balance);
636     token.transfer(reserveWallet, token.balanceOf(this));
637     super.finalization();
638   }
639 
640   function _forwardFunds() internal {
641     //overridden to make the smart contracts hold funds and not the wallet
642   }
643 
644   function withdrawFunds(uint value) onlyWhitelisted external {
645     require(this.balance >= value);
646     msg.sender.transfer(value);
647   }
648 
649   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) whenNotPaused internal {
650     require(_weiAmount >= minContribution);
651     require(_weiAmount <= maxContribution);
652     super._preValidatePurchase(_beneficiary, _weiAmount);
653   }
654 }