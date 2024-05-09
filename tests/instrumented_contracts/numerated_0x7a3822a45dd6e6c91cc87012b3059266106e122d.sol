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
37  * @title SafeERC20
38  * @dev Wrappers around ERC20 operations that throw on failure.
39  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
40  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
41  */
42 library SafeERC20Transfer {
43   function safeTransfer(
44     IERC20 token,
45     address to,
46     uint256 value
47   )
48     internal
49   {
50     require(token.transfer(to, value));
51   }
52 }
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that revert on error
57  */
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, reverts on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65     // benefit is lost if 'b' is also tested.
66     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
67     if (a == 0) {
68       return 0;
69     }
70 
71     uint256 c = a * b;
72     require(c / a == b);
73 
74     return c;
75   }
76 
77   /**
78   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
79   */
80   function div(uint256 a, uint256 b) internal pure returns (uint256) {
81     require(b > 0); // Solidity only automatically asserts when dividing by 0
82     uint256 c = a / b;
83     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84 
85     return c;
86   }
87 
88   /**
89   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
90   */
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     require(b <= a);
93     uint256 c = a - b;
94 
95     return c;
96   }
97 
98   /**
99   * @dev Adds two numbers, reverts on overflow.
100   */
101   function add(uint256 a, uint256 b) internal pure returns (uint256) {
102     uint256 c = a + b;
103     require(c >= a);
104 
105     return c;
106   }
107 
108   /**
109   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
110   * reverts when dividing by zero.
111   */
112   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
113     require(b != 0);
114     return a % b;
115   }
116 }
117 
118 
119 /**
120  * @title Ownable
121  * @dev The Ownable contract has an owner address, and provides basic authorization control
122  * functions, this simplifies the implementation of "user permissions".
123  */
124 contract Ownable {
125   address private _owner;
126 
127   event OwnershipTransferred(
128     address indexed previousOwner,
129     address indexed newOwner
130   );
131 
132   /**
133    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
134    * account.
135    */
136   constructor() public {
137     _owner = msg.sender;
138     emit OwnershipTransferred(address(0), _owner);
139   }
140 
141   /**
142    * @return the address of the owner.
143    */
144   function owner() public view returns(address) {
145     return _owner;
146   }
147 
148   /**
149    * @dev Throws if called by any account other than the owner.
150    */
151   modifier onlyOwner() {
152     require(isOwner());
153     _;
154   }
155 
156   /**
157    * @return true if `msg.sender` is the owner of the contract.
158    */
159   function isOwner() public view returns(bool) {
160     return msg.sender == _owner;
161   }
162 
163   /**
164    * @dev Allows the current owner to relinquish control of the contract.
165    * @notice Renouncing to ownership will leave the contract without an owner.
166    * It will not be possible to call the functions with the `onlyOwner`
167    * modifier anymore.
168    */
169   function renounceOwnership() public onlyOwner {
170     emit OwnershipTransferred(_owner, address(0));
171     _owner = address(0);
172   }
173 
174   /**
175    * @dev Allows the current owner to transfer control of the contract to a newOwner.
176    * @param newOwner The address to transfer ownership to.
177    */
178   function transferOwnership(address newOwner) public onlyOwner {
179     _transferOwnership(newOwner);
180   }
181 
182   /**
183    * @dev Transfers control of the contract to a newOwner.
184    * @param newOwner The address to transfer ownership to.
185    */
186   function _transferOwnership(address newOwner) internal {
187     require(newOwner != address(0));
188     emit OwnershipTransferred(_owner, newOwner);
189     _owner = newOwner;
190   }
191 }
192 
193 /**
194  * @title Crowdsale
195  * @dev Crowdsale is a base contract for managing a token crowdsale,
196  * allowing investors to purchase tokens with ether. This contract implements
197  * such functionality in its most fundamental form and can be extended to provide additional
198  * functionality and/or custom behavior.
199  * The external interface represents the basic interface for purchasing tokens, and conform
200  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
201  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
202  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
203  * behavior.
204  */
205 contract Crowdsale is Ownable {
206   using SafeMath for uint256;
207   using SafeERC20Transfer for IERC20;
208 
209   // The token being sold
210   IERC20 private _token;
211 
212   // Address where funds are collected
213   address private _wallet;
214 
215   // How many token units a buyer gets per 1 ETH.
216   uint256 private _rate = 5000;
217 
218   // Amount of wei raised
219   uint256 private _weiRaised;
220 
221   // Accrued tokens amount
222   uint256 private _accruedTokensAmount;
223 
224   // freezing periods in seconds
225   uint256 private _threeMonths = 5256000;
226   uint256 private _sixMonths = 15768000;
227   uint256 private _nineMonths = 21024000;
228   uint256 private _twelveMonths = 31536000;
229 
230   // ICO configuration
231   uint256 private _foundersTokens = 4e7;
232   uint256 private _distributedTokens = 1e9;
233   uint256 public softCap = 1000 ether;
234   uint256 public hardCap = 35000 ether;
235   uint256 public preICO_1_Start = 1541030400; // 01/11/2018 00:00:00
236   uint256 public preICO_2_Start = 1541980800; // 12/11/2018 00:00:00
237   uint256 public preICO_3_Start = 1542844800; // 22/11/2018 00:00:00
238   uint256 public ICO_Start = 1543622400; // 01/12/2018 00:00:00
239   uint256 public ICO_End = 1548979199; // 31/01/2019 23:59:59
240   uint32 public bonus1 = 30; // pre ICO phase 1
241   uint32 public bonus2 = 20; // pre ICO phase 2
242   uint32 public bonus3 = 10; // pre ICO phase 3
243   uint32 public whitelistedBonus = 10;
244 
245   mapping (address => bool) private _whitelist;
246 
247   // tokens accrual
248   mapping (address => uint256) public threeMonthsFreezingAccrual;
249   mapping (address => uint256) public sixMonthsFreezingAccrual;
250   mapping (address => uint256) public nineMonthsFreezingAccrual;
251   mapping (address => uint256) public twelveMonthsFreezingAccrual;
252 
253   // investors ledger
254   mapping (address => uint256) public ledger;
255 
256   /**
257    * Event for tokens accrual logging
258    * @param to who tokens where accrued to
259    * @param accruedAmount amount of tokens accrued
260    * @param freezingTime period for freezing in seconds
261    * @param purchasedAmount amount of tokens purchased
262    * @param weiValue amount of ether contributed
263    */
264   event Accrual(
265     address to,
266     uint256 accruedAmount,
267     uint256 freezingTime,
268     uint256 purchasedAmount,
269     uint256 weiValue
270   );
271 
272   /**
273    * Event for accrued tokens releasing logging
274    * @param to who tokens where release to
275    * @param amount amount of tokens released
276    */
277   event Released(
278     address to,
279     uint256 amount
280   );
281 
282   /**
283    * Event for refund logging
284    * @param to who have got refund
285    * @param value ether refunded
286    */
287   event Refunded(
288     address to,
289     uint256 value
290   );
291 
292   /**
293    * Event for token purchase logging
294    * @param purchaser who paid for the tokens
295    * @param beneficiary who got the tokens
296    * @param value weis paid for purchase
297    * @param amount amount of tokens purchased
298    */
299   event TokensPurchased(
300     address indexed purchaser,
301     address indexed beneficiary,
302     uint256 value,
303     uint256 amount
304   );
305 
306   /**
307    * @dev The rate is the conversion between wei and the smallest and indivisible
308    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
309    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
310    * @param wallet Address where collected funds will be forwarded to
311    * @param founders Address for founders tokens accrual
312    * @param token Address of the token being sold
313    */
314   constructor(address newOwner, address wallet, address founders, IERC20 token) public {
315     require(wallet != address(0));
316     require(founders != address(0));
317     require(token != address(0));
318     require(newOwner != address(0));
319     transferOwnership(newOwner);
320 
321     _wallet = wallet;
322     _token = token;
323 
324     twelveMonthsFreezingAccrual[founders] = _foundersTokens;
325     _accruedTokensAmount = _foundersTokens;
326     emit Accrual(founders, _foundersTokens, _twelveMonths, 0, 0);
327   }
328 
329   // -----------------------------------------
330   // Crowdsale external interface
331   // -----------------------------------------
332 
333   /**
334    * @dev fallback function ***DO NOT OVERRIDE***
335    */
336   function () external payable {
337     buyTokens(msg.sender);
338   }
339 
340   /**
341    * @return the token being sold.
342    */
343   function token() public view returns(IERC20) {
344     return _token;
345   }
346 
347   /**
348    * @return the address where funds are collected.
349    */
350   function wallet() public view returns(address) {
351     return _wallet;
352   }
353 
354   /**
355    * @return the number of token units a buyer gets per wei.
356    */
357   function rate() public view returns(uint256) {
358     return _rate;
359   }
360 
361   /**
362    * @return the amount of wei raised.
363    */
364   function weiRaised() public view returns (uint256) {
365     return _weiRaised;
366   }
367 
368   /**
369    * @return if who is whitelisted.
370    * @param who investors address
371    */
372   function whitelist(address who) public view returns (bool) {
373     return _whitelist[who];
374   }
375 
376   /**
377    * add investor to whitelist
378    * @param who investors address
379    */
380   function addToWhitelist(address who) public onlyOwner {
381     _whitelist[who] = true;
382   }
383 
384   /**
385    * remove investor from whitelist
386    * @param who investors address
387    */
388   function removeFromWhitelist(address who) public onlyOwner {
389     _whitelist[who] = false;
390   }
391 
392   /**
393    * Accrue bonuses to advisors
394    * @param to address for accrual
395    * @param amount tokem amount
396    */
397   function accrueAdvisorsTokens(address to, uint256 amount) public onlyOwner {
398     require(now > ICO_End);
399     uint256 tokenBalance = _token.balanceOf(address(this));
400     require(tokenBalance >= _accruedTokensAmount.add(amount));
401 
402     _accruedTokensAmount = _accruedTokensAmount.add(amount);
403     
404     sixMonthsFreezingAccrual[to] = sixMonthsFreezingAccrual[to].add(amount);
405 
406     emit Accrual(to, amount, _sixMonths, 0, 0);    
407   }
408 
409   /**
410    * Accrue bonuses to partners
411    * @param to address for accrual
412    * @param amount tokem amount
413    */
414   function accruePartnersTokens(address to, uint256 amount) public onlyOwner {
415     require(now > ICO_End);
416     uint256 tokenBalance = _token.balanceOf(address(this));
417     require(tokenBalance >= _accruedTokensAmount.add(amount));
418 
419     _accruedTokensAmount = _accruedTokensAmount.add(amount);
420     
421     nineMonthsFreezingAccrual[to] = nineMonthsFreezingAccrual[to].add(amount);
422 
423     emit Accrual(to, amount, _nineMonths, 0, 0);    
424   }
425 
426   /**
427    * Accrue bounty and airdrop bonuses
428    * @param to address for accrual
429    * @param amount tokem amount
430    */
431   function accrueBountyTokens(address to, uint256 amount) public onlyOwner {
432     require(now > ICO_End);
433     uint256 tokenBalance = _token.balanceOf(address(this));
434     require(tokenBalance >= _accruedTokensAmount.add(amount));
435 
436     _accruedTokensAmount = _accruedTokensAmount.add(amount);
437     
438     twelveMonthsFreezingAccrual[to] = twelveMonthsFreezingAccrual[to].add(amount);
439 
440     emit Accrual(to, amount, _twelveMonths, 0, 0);    
441   }
442 
443   /**
444    * release accrued tokens
445    */
446   function release() public {
447     address who = msg.sender;
448     uint256 amount;
449     if (now > ICO_End.add(_twelveMonths) && twelveMonthsFreezingAccrual[who] > 0) {
450       amount = amount.add(twelveMonthsFreezingAccrual[who]);
451       _accruedTokensAmount = _accruedTokensAmount.sub(twelveMonthsFreezingAccrual[who]);
452       twelveMonthsFreezingAccrual[who] = 0;
453     }
454     if (now > ICO_End.add(_nineMonths) && nineMonthsFreezingAccrual[who] > 0) {
455       amount = amount.add(nineMonthsFreezingAccrual[who]);
456       _accruedTokensAmount = _accruedTokensAmount.sub(nineMonthsFreezingAccrual[who]);
457       nineMonthsFreezingAccrual[who] = 0;
458     }
459     if (now > ICO_End.add(_sixMonths) && sixMonthsFreezingAccrual[who] > 0) {
460       amount = amount.add(sixMonthsFreezingAccrual[who]);
461       _accruedTokensAmount = _accruedTokensAmount.sub(sixMonthsFreezingAccrual[who]);
462       sixMonthsFreezingAccrual[who] = 0;
463     }
464     if (now > ICO_End.add(_threeMonths) && threeMonthsFreezingAccrual[who] > 0) {
465       amount = amount.add(threeMonthsFreezingAccrual[who]);
466       _accruedTokensAmount = _accruedTokensAmount.sub(threeMonthsFreezingAccrual[who]);
467       threeMonthsFreezingAccrual[who] = 0;
468     }
469     if (amount > 0) {
470       _deliverTokens(who, amount);
471       emit Released(who, amount);
472     }
473   }
474 
475   /**
476    * refund ether
477    */
478   function refund() public {
479     address investor = msg.sender;
480     require(now > ICO_End);
481     require(_weiRaised < softCap);
482     require(ledger[investor] > 0);
483     uint256 value = ledger[investor];
484     ledger[investor] = 0;
485     investor.transfer(value);
486     emit Refunded(investor, value);
487   }
488 
489   /**
490    * @dev low level token purchase ***DO NOT OVERRIDE***
491    * @param beneficiary Address performing the token purchase
492    */
493   function buyTokens(address beneficiary) public payable {
494     uint256 weiAmount = msg.value;
495     _preValidatePurchase(beneficiary, weiAmount);
496 
497     // calculate token amount to be created
498     uint256 tokens = _getTokenAmount(weiAmount);
499 
500     // bonus tokens accrual and ensure token balance is enough for accrued tokens release
501     _accrueBonusTokens(beneficiary, tokens, weiAmount);
502 
503     // update state
504     _weiRaised = _weiRaised.add(weiAmount);
505 
506     _processPurchase(beneficiary, tokens);
507     emit TokensPurchased(
508       msg.sender,
509       beneficiary,
510       weiAmount,
511       tokens
512     );
513 
514     if (_weiRaised >= softCap) _forwardFunds();
515 
516     ledger[msg.sender] = ledger[msg.sender].add(msg.value);
517   }
518 
519   // -----------------------------------------
520   // Internal interface (extensible)
521   // -----------------------------------------
522 
523     /**
524    * @dev Accrue bonus tokens.
525    * @param beneficiary Address for tokens accrual
526    * @param tokenAmount amount of tokens that beneficiary get
527    */
528   function _accrueBonusTokens(address beneficiary, uint256 tokenAmount, uint256 weiAmount) internal {
529     uint32 bonus = 0;
530     uint256 bonusTokens = 0;
531     uint256 tokenBalance = _token.balanceOf(address(this));
532     if (_whitelist[beneficiary] && now < ICO_Start) bonus = bonus + whitelistedBonus;
533     if (now < preICO_2_Start) {
534       bonus = bonus + bonus1;
535       bonusTokens = tokenAmount.mul(bonus).div(100);
536 
537       require(tokenBalance >= _accruedTokensAmount.add(bonusTokens).add(tokenAmount));
538 
539       _accruedTokensAmount = _accruedTokensAmount.add(bonusTokens);
540 
541       nineMonthsFreezingAccrual[beneficiary] = nineMonthsFreezingAccrual[beneficiary].add(bonusTokens);
542 
543       emit Accrual(beneficiary, bonusTokens, _nineMonths, tokenAmount, weiAmount);
544     } else if (now < preICO_3_Start) {
545       bonus = bonus + bonus2;
546       bonusTokens = tokenAmount.mul(bonus).div(100);
547 
548       require(tokenBalance >= _accruedTokensAmount.add(bonusTokens).add(tokenAmount));
549 
550       _accruedTokensAmount = _accruedTokensAmount.add(bonusTokens);
551       
552       sixMonthsFreezingAccrual[beneficiary] = sixMonthsFreezingAccrual[beneficiary].add(bonusTokens);
553 
554       emit Accrual(beneficiary, bonusTokens, _sixMonths, tokenAmount, weiAmount);
555     } else if (now < ICO_Start) {
556       bonus = bonus + bonus3;
557       bonusTokens = tokenAmount.mul(bonus).div(100);
558 
559       require(tokenBalance >= _accruedTokensAmount.add(bonusTokens).add(tokenAmount));
560 
561       _accruedTokensAmount = _accruedTokensAmount.add(bonusTokens);
562       
563       threeMonthsFreezingAccrual[beneficiary] = threeMonthsFreezingAccrual[beneficiary].add(bonusTokens);
564 
565       emit Accrual(beneficiary, bonusTokens, _threeMonths, tokenAmount, weiAmount);
566     } else {
567       require(tokenBalance >= _accruedTokensAmount.add(tokenAmount));
568 
569       emit Accrual(beneficiary, 0, 0, tokenAmount, weiAmount);
570     }
571   }
572 
573   /**
574    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
575    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
576    *   super._preValidatePurchase(beneficiary, weiAmount);
577    *   require(weiRaised().add(weiAmount) <= cap);
578    * @param beneficiary Address performing the token purchase
579    * @param weiAmount Value in wei involved in the purchase
580    */
581   function _preValidatePurchase(
582     address beneficiary,
583     uint256 weiAmount
584   )
585     internal view
586   {
587     require(beneficiary != address(0));
588     require(weiAmount != 0);
589     require(_weiRaised.add(weiAmount) <= hardCap);
590     require(now >= preICO_1_Start);
591     require(now <= ICO_End);
592   }
593 
594   /**
595    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
596    * @param beneficiary Address performing the token purchase
597    * @param tokenAmount Number of tokens to be emitted
598    */
599   function _deliverTokens(
600     address beneficiary,
601     uint256 tokenAmount
602   )
603     internal
604   {
605     _token.safeTransfer(beneficiary, tokenAmount);
606   }
607 
608   /**
609    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
610    * @param beneficiary Address receiving the tokens
611    * @param tokenAmount Number of tokens to be purchased
612    */
613   function _processPurchase(
614     address beneficiary,
615     uint256 tokenAmount
616   )
617     internal
618   {
619     _deliverTokens(beneficiary, tokenAmount);
620   }
621 
622   /**
623    * @dev The way in which ether is converted to tokens.
624    * @param weiAmount Value in wei to be converted into tokens
625    * @return Number of tokens that can be purchased with the specified _weiAmount
626    */
627   function _getTokenAmount(
628     uint256 weiAmount
629   )
630     internal view returns (uint256)
631   {
632     return weiAmount.mul(_rate).div(1e18);
633   }
634 
635   /**
636    * @dev Determines how ETH is stored/forwarded on purchases.
637    */
638   function _forwardFunds() internal {
639     uint256 balance = address(this).balance;
640     _wallet.transfer(balance);
641   }
642 }