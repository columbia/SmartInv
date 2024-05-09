1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52   function totalSupply() public view returns (uint256);
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
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
73   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74     if (a == 0) {
75       return 0;
76     }
77     uint256 c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return c;
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
103   function add(uint256 a, uint256 b) internal pure returns (uint256) {
104     uint256 c = a + b;
105     assert(c >= a);
106     return c;
107   }
108 }
109 
110 
111 
112 
113 
114 /**
115  * @title Crowdsale
116  * @dev Crowdsale is a base contract for managing a token crowdsale,
117  * allowing investors to purchase tokens with ether. This contract implements
118  * such functionality in its most fundamental form and can be extended to provide additional
119  * functionality and/or custom behavior.
120  * The external interface represents the basic interface for purchasing tokens, and conform
121  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
122  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
123  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
124  * behavior.
125  */
126 
127 contract Crowdsale {
128   using SafeMath for uint256;
129 
130   // The token being sold
131   ERC20 public token;
132 
133   // Address where funds are collected
134   address public wallet;
135 
136   // How many token units a buyer gets per wei
137   //uint256 public rate;
138 
139   // Amount of wei raised
140   uint256 public weiRaised;
141 
142   // Amount of wei raised
143   uint256 public tokensDistributed;
144 
145   /**
146    * Event for token purchase logging
147    * @param purchaser who paid for the tokens
148    * @param beneficiary who got the tokens
149    * @param value weis paid for purchase
150    * @param amount amount of tokens purchased
151    */
152   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
153 
154   /**
155    * @param _wallet Address where collected funds will be forwarded to
156    * @param _token Address of the token being sold
157    */
158   function Crowdsale(address _wallet, ERC20 _token) public {
159     require(_wallet != address(0));
160     require(_token != address(0));
161 
162     wallet = _wallet;
163     token = _token;
164   }
165 
166   // -----------------------------------------
167   // Crowdsale external interface
168   // -----------------------------------------
169 
170   /**
171    * @dev fallback function ***DO NOT OVERRIDE***
172    */
173   function () external payable {
174     buyTokens(msg.sender);
175   }
176 
177   /**
178    * @dev low level token purchase ***DO NOT OVERRIDE***
179    * @param _beneficiary Address performing the token purchase
180    */
181   function buyTokens(address _beneficiary) public payable {
182 
183     uint256 weiAmount = msg.value;
184     _preValidatePurchase(_beneficiary, weiAmount);
185 
186     // calculate token amount to be created
187     uint256 tokens = _getTokenAmount(weiAmount);
188 
189     // update state
190     weiRaised = weiRaised.add(weiAmount);
191     tokensDistributed = tokensDistributed.add(tokens);
192 
193     _processPurchase(_beneficiary, tokens);
194     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
195 
196     _updatePurchasingState(_beneficiary, weiAmount);
197 
198     _forwardFunds();
199     _postValidatePurchase(_beneficiary, weiAmount);
200   }
201 
202   // -----------------------------------------
203   // Internal interface (extensible)
204   // -----------------------------------------
205 
206   /**
207    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
208    * @param _beneficiary Address performing the token purchase
209    * @param _weiAmount Value in wei involved in the purchase
210    */
211   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
212     require(_beneficiary != address(0));
213     require(_weiAmount != 0);
214   }
215 
216   /**
217    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
218    * @param _beneficiary Address performing the token purchase
219    * @param _weiAmount Value in wei involved in the purchase
220    */
221   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
222     // optional override
223   }
224 
225   /**
226    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
227    * @param _beneficiary Address performing the token purchase
228    * @param _tokenAmount Number of tokens to be emitted
229    */
230   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
231     token.transferFrom(wallet, _beneficiary, _tokenAmount);
232     //token.transfer(_beneficiary, _tokenAmount);
233   }
234 
235   /**
236    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
237    * @param _beneficiary Address receiving the tokens
238    * @param _tokenAmount Number of tokens to be purchased
239    */
240   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
241     _deliverTokens(_beneficiary, _tokenAmount);
242   }
243 
244   /**
245    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
246    * @param _beneficiary Address receiving the tokens
247    * @param _weiAmount Value in wei involved in the purchase
248    */
249   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
250     // optional override
251   }
252 
253   /**
254    * @dev Override to extend the way in which ether is converted to tokens.
255    * @param _weiAmount Value in wei to be converted into tokens
256    * @return Number of tokens that can be purchased with the specified _weiAmount
257    */
258   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
259     // must override
260   }
261 
262   /**
263    * @dev Determines how ETH is stored/forwarded on purchases.
264    */
265   function _forwardFunds() internal {
266     wallet.transfer(msg.value);
267   }
268 }
269 
270 
271 /**
272  * @title TimedCrowdsale
273  * @dev Crowdsale accepting contributions only within a time frame.
274  */
275 contract TimedCrowdsale is Crowdsale {
276   using SafeMath for uint256;
277 
278   uint256 public openingTime;
279   uint256 public closingTime;
280 
281   /**
282    * @dev Reverts if not in crowdsale time range. 
283    */
284   modifier onlyWhileOpen {
285     require(now >= openingTime && now <= closingTime);
286     _;
287   }
288 
289   /**
290    * @dev Constructor, takes crowdsale opening and closing times.
291    * @param _openingTime Crowdsale opening time
292    * @param _closingTime Crowdsale closing time
293    */
294   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
295     //require(_openingTime >= now);
296     require(_closingTime >= _openingTime);
297 
298     openingTime = _openingTime;
299     closingTime = _closingTime;
300   }
301 
302   /**
303    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
304    * @return Whether crowdsale period has elapsed
305    */
306   function hasClosed() public view returns (bool) {
307     return now > closingTime;
308   }
309   
310   /**
311    * @dev Extend parent behavior requiring to be within contributing period
312    * @param _beneficiary Token purchaser
313    * @param _weiAmount Amount of wei contributed
314    */
315   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
316     super._preValidatePurchase(_beneficiary, _weiAmount);
317   }
318 
319 }
320 
321 
322 
323 /**
324  * @title FinalizableCrowdsale
325  * @dev Extension of Crowdsale where an owner can do extra work
326  * after finishing.
327  */
328 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
329   using SafeMath for uint256;
330 
331   bool public isFinalized = false;
332 
333   event Finalized();
334 
335   /**
336    * @dev Must be called after crowdsale ends, to do some extra finalization
337    * work. Calls the contract's finalization function.
338    */
339   function finalize() onlyOwner public {
340     require(!isFinalized);
341     require(hasClosed());
342 
343     finalization();
344     emit Finalized();
345 
346     isFinalized = true;
347   }
348 
349   /**
350    * @dev Can be overridden to add finalization logic. The overriding function
351    * should call super.finalization() to ensure the chain of finalization is
352    * executed entirely.
353    */
354   function finalization() internal {
355   }
356 }
357 
358 
359 
360 
361 
362 
363 
364 /**
365  * @title CappedCrowdsale
366  * @dev Crowdsale with a limit for total contributions.
367  */
368 contract CappedCrowdsale is Crowdsale {
369   using SafeMath for uint256;
370 
371   uint256 public cap;
372 
373   /**
374    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
375    * @param _cap Max amount of wei to be contributed
376    */
377   function CappedCrowdsale(uint256 _cap) public {
378     require(_cap > 0);
379     cap = _cap;
380   }
381 
382   /**
383    * @dev Checks whether the cap has been reached. 
384    * @return Whether the cap was reached
385    */
386   function capReached() public view returns (bool) {
387     return weiRaised >= cap;
388   }
389 
390   /**
391    * @dev Extend parent behavior requiring purchase to respect the funding cap.
392    * @param _beneficiary Token purchaser
393    * @param _weiAmount Amount of wei contributed
394    */
395   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
396     super._preValidatePurchase(_beneficiary, _weiAmount);
397     require(weiRaised.add(_weiAmount) <= cap);
398   }
399 
400 }
401 
402 
403 
404 
405 
406 
407 
408 
409 
410 
411 
412 
413 /**
414  * @title RefundVault
415  * @dev This contract is used for storing funds while a crowdsale
416  * is in progress. Supports refunding the money if crowdsale fails,
417  * and forwarding it if crowdsale is successful.
418  */
419 contract RefundVault is Ownable {
420   using SafeMath for uint256;
421 
422   enum State { Active, Refunding, Closed }
423 
424   mapping (address => uint256) public deposited;
425   address public wallet;
426   State public state;
427 
428   event Closed();
429   event RefundsEnabled();
430   event Refunded(address indexed beneficiary, uint256 weiAmount);
431 
432   /**
433    * @param _wallet Vault address
434    */
435   function RefundVault(address _wallet) public {
436     require(_wallet != address(0));
437     wallet = _wallet;
438     state = State.Active;
439   }
440 
441   /**
442    * @param investor Investor address
443    */
444   function deposit(address investor) onlyOwner public payable {
445     require(state == State.Active);
446     deposited[investor] = deposited[investor].add(msg.value);
447   }
448 
449   function close() onlyOwner public {
450     state = State.Closed;
451     emit Closed();
452     wallet.transfer(address(this).balance);
453   }
454 
455   function enableRefunds() onlyOwner public {
456     require(state == State.Active);
457     state = State.Refunding;
458     emit RefundsEnabled();
459   }
460 
461   /**
462    * @param investor Investor address
463    */
464   function refund(address investor) public {
465     require(state == State.Refunding);
466     uint256 depositedValue = deposited[investor];
467     deposited[investor] = 0;
468     investor.transfer(depositedValue);
469     emit Refunded(investor, depositedValue);
470   }
471 }
472 
473 
474 
475 /**
476  * @title RefundableCrowdsale
477  * @dev Extension of Crowdsale contract that adds a funding goal, and
478  * the possibility of users getting a refund if goal is not met.
479  * Uses a RefundVault as the crowdsale's vault.
480  */
481 contract RefundableCrowdsale is FinalizableCrowdsale {
482   using SafeMath for uint256;
483 
484   // minimum amount of funds to be raised in weis
485   uint256 public goal;
486 
487   // refund vault used to hold funds while crowdsale is running
488   RefundVault public vault;
489  
490   /**
491    * @dev Constructor, creates RefundVault. 
492    * @param _goal Funding goal
493    */
494   function RefundableCrowdsale(uint256 _goal) public {
495     require(_goal > 0);
496     vault = new RefundVault(wallet);
497     goal = _goal;
498   }
499 
500   /**
501    * @dev Investors can claim refunds here if crowdsale is unsuccessful
502    */
503   function claimRefund() public {
504     require(isFinalized);
505     require(!goalReached());
506 
507     vault.refund(msg.sender);
508   }
509 
510   /**
511    * @dev Checks whether funding goal was reached. 
512    * @return Whether funding goal was reached
513    */
514   function goalReached() public view returns (bool) {
515     return weiRaised >= goal;
516   }
517 
518   /**
519    * @dev vault finalization task, called when owner calls finalize()
520    */
521   function finalization() internal {
522     if (goalReached()) {
523       vault.close();
524     } else {
525       vault.transferOwnership(owner);
526     }
527 
528     super.finalization();
529   }
530 
531   /**
532    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
533    */
534   function _forwardFunds() internal {
535     vault.deposit.value(msg.value)(msg.sender);
536   }
537 
538 }
539 
540 
541 
542 
543 
544 
545 
546 
547 /**
548  * @title PostDeliveryCrowdsale
549  * @dev Crowdsale that locks tokens from withdrawal until it ends.
550  */
551 contract PostDeliveryCrowdsale is TimedCrowdsale, Ownable {
552   using SafeMath for uint256;
553 
554   mapping(address => uint256) public balances;
555 
556   /**
557    * @dev Overrides parent by storing balances instead of issuing tokens right away.
558    * @param _beneficiary Token purchaser
559    * @param _tokenAmount Amount of tokens purchased
560    */
561   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
562     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
563   }
564 
565   /**
566    * @dev Withdraw tokens only after crowdsale ends.
567    */
568   function withdrawTokens(address _beneficiary) public onlyOwner {
569     require(hasClosed());
570     uint256 amount = balances[_beneficiary];
571     require(amount > 0);
572     balances[_beneficiary] = 0;
573     _deliverTokens(_beneficiary, amount);
574   }
575 }
576 
577 
578 
579 
580 
581 
582 /**
583  * @title ERC20 interface
584  * @dev see https://github.com/ethereum/EIPs/issues/20
585  */
586 contract ERC20 is ERC20Basic {
587   function allowance(address owner, address spender) public view returns (uint256);
588   function transferFrom(address from, address to, uint256 value) public returns (bool);
589   function approve(address spender, uint256 value) public returns (bool);
590   event Approval(address indexed owner, address indexed spender, uint256 value);
591 }
592 
593 
594 contract CxNcontract is CappedCrowdsale, RefundableCrowdsale, PostDeliveryCrowdsale {
595     
596     // Only for testNet:
597     //uint privSale1start = now;
598 
599     // Bounty hive
600     address partnerAddress;
601 
602     //    //  20 Mar 2018  07:00:00 PM CST
603     uint privSale1start = 1521594000;
604 
605     //  10 Apr 2018  11:59:00 PM CST
606     uint privSale1end = 1523426400;
607 
608     // 16 Apr 2018  07:00:00 PM CST
609     uint privSale2start = 1523926800;
610 
611     // 07 May 2018  11:59:00 PM CST
612     uint privSale2end = 1525759200;
613 
614     // 11 May 2018 07:00:00 PM CST
615     uint saleStart = 1526086800;
616 
617     // 18 Jun 2018 11:59:00 PM CST
618     uint saleEnd = 1526709600;
619 
620     function CxNcontract(uint256 _openingTime, uint256 _closingTime, address _wallet, uint256 _cap, ERC20 _token, uint256 _goal, address _partnerAddress) public payable
621         Crowdsale(_wallet, _token)
622         CappedCrowdsale(_cap)
623         TimedCrowdsale(_openingTime, _closingTime)
624         RefundableCrowdsale(_goal) 
625     {
626         //As goal needs to be met for a successful crowdsale
627         //the value needs to less or equal than a cap which is limit for accepted funds
628         partnerAddress = _partnerAddress;
629         require(_goal <= _cap);
630     }
631 
632     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
633         require(checkValue(_weiAmount));
634         super._preValidatePurchase(_beneficiary, _weiAmount);
635     }
636 
637     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
638         return _weiAmount.mul(getRate());
639     }
640 
641     function checkValue(uint256 amount) internal view returns (bool) {
642         if (now > privSale1start && now < privSale1end) 
643             return (amount >= 5 ether);
644         else if (now > privSale2start && now < privSale2end) 
645             return (amount >= 5 ether);
646         else if (now > saleStart && now < saleEnd) 
647             return (amount >= 0.1 ether);
648         return false;
649     }
650 
651     function getRate() public view returns (uint256) {
652         if (now > privSale1start && now < privSale1end) 
653             return 14375; // Stage I
654         else if (now > privSale2start && now < privSale2end) 
655             return 13750; // Stage II
656         else if (now > saleStart && now < saleEnd) 
657             return 12500; // Public Sale
658         return 0;
659     }
660 
661     function finalization() internal {
662         uint256 tokensForPartners = 2800000 ether;
663         uint256 tokensNeededToClose = tokensForPartners.add(tokensDistributed);
664         
665         require(token.balanceOf(wallet) >= tokensNeededToClose);
666 
667         token.transferFrom(wallet, partnerAddress, tokensForPartners);
668 
669         super.finalization();
670     }
671 }