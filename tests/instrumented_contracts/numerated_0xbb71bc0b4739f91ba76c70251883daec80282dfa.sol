1 pragma solidity ^0.4.18;
2 
3 // File: contracts/zeppelin/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/zeppelin/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     // uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return a / b;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: contracts/zeppelin/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: contracts/zeppelin/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256 balance) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 // File: contracts/zeppelin/token/ERC20/ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: contracts/zeppelin/token/ERC20/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address _owner, address _spender) public view returns (uint256) {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 // File: contracts/zeppelin/token/ERC20/MintableToken.sol
264 
265 /**
266  * @title Mintable token
267  * @dev Simple ERC20 Token example, with mintable token creation
268  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
269  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
270  */
271 contract MintableToken is StandardToken, Ownable {
272   event Mint(address indexed to, uint256 amount);
273   event MintFinished();
274 
275   bool public mintingFinished = false;
276 
277 
278   modifier canMint() {
279     require(!mintingFinished);
280     _;
281   }
282 
283   /**
284    * @dev Function to mint tokens
285    * @param _to The address that will receive the minted tokens.
286    * @param _amount The amount of tokens to mint.
287    * @return A boolean that indicates if the operation was successful.
288    */
289   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
290     totalSupply_ = totalSupply_.add(_amount);
291     balances[_to] = balances[_to].add(_amount);
292     Mint(_to, _amount);
293     Transfer(address(0), _to, _amount);
294     return true;
295   }
296 
297   /**
298    * @dev Function to stop minting new tokens.
299    * @return True if the operation was successful.
300    */
301   function finishMinting() onlyOwner canMint public returns (bool) {
302     mintingFinished = true;
303     MintFinished();
304     return true;
305   }
306 }
307 
308 // File: contracts/Circle.sol
309 
310 contract Circle is MintableToken {
311     string public name = "Circle Plus";
312     string public symbol = "Circle";
313     uint8 public decimals = 18;
314 }
315 
316 // File: contracts/zeppelin/crowdsale/Crowdsale.sol
317 
318 /**
319  * @title Crowdsale
320  * @dev Crowdsale is a base contract for managing a token crowdsale,
321  * allowing investors to purchase tokens with ether. This contract implements
322  * such functionality in its most fundamental form and can be extended to provide additional
323  * functionality and/or custom behavior.
324  * The external interface represents the basic interface for purchasing tokens, and conform
325  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
326  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
327  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
328  * behavior.
329  */
330 contract Crowdsale {
331   using SafeMath for uint256;
332 
333   // The token being sold
334   ERC20 public token;
335 
336   // Address where funds are collected
337   address public wallet;
338 
339   // How many token units a buyer gets per wei
340   uint256 public rate;
341 
342   // Amount of wei raised
343   uint256 public weiRaised;
344 
345   /**
346    * Event for token purchase logging
347    * @param purchaser who paid for the tokens
348    * @param beneficiary who got the tokens
349    * @param value weis paid for purchase
350    * @param amount amount of tokens purchased
351    */
352   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
353 
354   /**
355    * @param _rate Number of token units a buyer gets per wei
356    * @param _wallet Address where collected funds will be forwarded to
357    * @param _token Address of the token being sold
358    */
359   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
360     require(_rate > 0);
361     require(_wallet != address(0));
362     require(_token != address(0));
363 
364     rate = _rate;
365     wallet = _wallet;
366     token = _token;
367   }
368 
369   // -----------------------------------------
370   // Crowdsale external interface
371   // -----------------------------------------
372 
373   /**
374    * @dev fallback function ***DO NOT OVERRIDE***
375    */
376   function () external payable {
377     buyTokens(msg.sender);
378   }
379 
380   /**
381    * @dev low level token purchase ***DO NOT OVERRIDE***
382    * @param _beneficiary Address performing the token purchase
383    */
384   function buyTokens(address _beneficiary) public payable {
385 
386     uint256 weiAmount = msg.value;
387     _preValidatePurchase(_beneficiary, weiAmount);
388 
389     // calculate token amount to be created
390     uint256 tokens = _getTokenAmount(weiAmount);
391 
392     // update state
393     weiRaised = weiRaised.add(weiAmount);
394 
395     _processPurchase(_beneficiary, tokens);
396     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
397 
398     _updatePurchasingState(_beneficiary, weiAmount);
399 
400     _forwardFunds();
401     _postValidatePurchase(_beneficiary, weiAmount);
402   }
403 
404   // -----------------------------------------
405   // Internal interface (extensible)
406   // -----------------------------------------
407 
408   /**
409    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
410    * @param _beneficiary Address performing the token purchase
411    * @param _weiAmount Value in wei involved in the purchase
412    */
413   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
414     require(_beneficiary != address(0));
415     require(_weiAmount != 0);
416   }
417 
418   /**
419    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
420    * @param _beneficiary Address performing the token purchase
421    * @param _weiAmount Value in wei involved in the purchase
422    */
423   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
424     // optional override
425   }
426 
427   /**
428    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
429    * @param _beneficiary Address performing the token purchase
430    * @param _tokenAmount Number of tokens to be emitted
431    */
432   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
433     token.transfer(_beneficiary, _tokenAmount);
434   }
435 
436   /**
437    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
438    * @param _beneficiary Address receiving the tokens
439    * @param _tokenAmount Number of tokens to be purchased
440    */
441   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
442     _deliverTokens(_beneficiary, _tokenAmount);
443   }
444 
445   /**
446    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
447    * @param _beneficiary Address receiving the tokens
448    * @param _weiAmount Value in wei involved in the purchase
449    */
450   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
451     // optional override
452   }
453 
454   /**
455    * @dev Override to extend the way in which ether is converted to tokens.
456    * @param _weiAmount Value in wei to be converted into tokens
457    * @return Number of tokens that can be purchased with the specified _weiAmount
458    */
459   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
460     return _weiAmount.mul(rate);
461   }
462 
463   /**
464    * @dev Determines how ETH is stored/forwarded on purchases.
465    */
466   function _forwardFunds() internal {
467     wallet.transfer(msg.value);
468   }
469 }
470 
471 // File: contracts/zeppelin/crowdsale/emission/MintedCrowdsale.sol
472 
473 /**
474  * @title MintedCrowdsale
475  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
476  * Token ownership should be transferred to MintedCrowdsale for minting. 
477  */
478 contract MintedCrowdsale is Crowdsale {
479 
480   /**
481    * @dev Overrides delivery by minting tokens upon purchase.
482    * @param _beneficiary Token purchaser
483    * @param _tokenAmount Number of tokens to be minted
484    */
485   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
486     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
487   }
488 }
489 
490 // File: contracts/zeppelin/crowdsale/validation/TimedCrowdsale.sol
491 
492 /**
493  * @title TimedCrowdsale
494  * @dev Crowdsale accepting contributions only within a time frame.
495  */
496 contract TimedCrowdsale is Crowdsale {
497   using SafeMath for uint256;
498 
499   uint256 public openingTime;
500   uint256 public closingTime;
501 
502   /**
503    * @dev Reverts if not in crowdsale time range.
504    */
505   modifier onlyWhileOpen {
506     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
507     _;
508   }
509 
510   /**
511    * @dev Constructor, takes crowdsale opening and closing times.
512    * @param _openingTime Crowdsale opening time
513    * @param _closingTime Crowdsale closing time
514    */
515   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
516     require(_openingTime >= block.timestamp);
517     require(_closingTime >= _openingTime);
518 
519     openingTime = _openingTime;
520     closingTime = _closingTime;
521   }
522 
523   /**
524    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
525    * @return Whether crowdsale period has elapsed
526    */
527   function hasClosed() public view returns (bool) {
528     return block.timestamp > closingTime;
529   }
530 
531   /**
532    * @dev Extend parent behavior requiring to be within contributing period
533    * @param _beneficiary Token purchaser
534    * @param _weiAmount Amount of wei contributed
535    */
536   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
537     super._preValidatePurchase(_beneficiary, _weiAmount);
538   }
539 
540 }
541 
542 // File: contracts/zeppelin/token/ERC20/SafeERC20.sol
543 
544 /**
545  * @title SafeERC20
546  * @dev Wrappers around ERC20 operations that throw on failure.
547  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
548  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
549  */
550 library SafeERC20 {
551   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
552     assert(token.transfer(to, value));
553   }
554 
555   function safeTransferFrom(
556     ERC20 token,
557     address from,
558     address to,
559     uint256 value
560   )
561     internal
562   {
563     assert(token.transferFrom(from, to, value));
564   }
565 
566   function safeApprove(ERC20 token, address spender, uint256 value) internal {
567     assert(token.approve(spender, value));
568   }
569 }
570 
571 // File: contracts/zeppelin/token/ERC20/TokenTimelock.sol
572 
573 /**
574  * @title TokenTimelock
575  * @dev TokenTimelock is a token holder contract that will allow a
576  * beneficiary to extract the tokens after a given release time
577  */
578 contract TokenTimelock {
579   using SafeERC20 for ERC20Basic;
580 
581   // ERC20 basic token contract being held
582   ERC20Basic public token;
583 
584   // beneficiary of tokens after they are released
585   address public beneficiary;
586 
587   // timestamp when token release is enabled
588   uint256 public releaseTime;
589 
590   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
591     require(_releaseTime > block.timestamp);
592     token = _token;
593     beneficiary = _beneficiary;
594     releaseTime = _releaseTime;
595   }
596 
597   /**
598    * @notice Transfers tokens held by timelock to beneficiary.
599    */
600   function release() public {
601     require(block.timestamp >= releaseTime);
602 
603     uint256 amount = token.balanceOf(this);
604     require(amount > 0);
605 
606     token.safeTransfer(beneficiary, amount);
607   }
608 }
609 
610 // File: contracts/zeppelin/token/ERC20/TokenVesting.sol
611 
612 /**
613  * @title TokenVesting
614  * @dev A token holder contract that can release its token balance gradually like a
615  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
616  * owner.
617  */
618 contract TokenVesting is Ownable {
619   using SafeMath for uint256;
620   using SafeERC20 for ERC20Basic;
621 
622   event Released(uint256 amount);
623   event Revoked();
624 
625   // beneficiary of tokens after they are released
626   address public beneficiary;
627 
628   uint256 public cliff;
629   uint256 public start;
630   uint256 public duration;
631 
632   bool public revocable;
633 
634   mapping (address => uint256) public released;
635   mapping (address => bool) public revoked;
636 
637   /**
638    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
639    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
640    * of the balance will have vested.
641    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
642    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
643    * @param _duration duration in seconds of the period in which the tokens will vest
644    * @param _revocable whether the vesting is revocable or not
645    */
646   function TokenVesting(
647     address _beneficiary,
648     uint256 _start,
649     uint256 _cliff,
650     uint256 _duration,
651     bool _revocable
652   )
653     public
654   {
655     require(_beneficiary != address(0));
656     require(_cliff <= _duration);
657 
658     beneficiary = _beneficiary;
659     revocable = _revocable;
660     duration = _duration;
661     cliff = _start.add(_cliff);
662     start = _start;
663   }
664 
665   /**
666    * @notice Transfers vested tokens to beneficiary.
667    * @param token ERC20 token which is being vested
668    */
669   function release(ERC20Basic token) public {
670     uint256 unreleased = releasableAmount(token);
671 
672     require(unreleased > 0);
673 
674     released[token] = released[token].add(unreleased);
675 
676     token.safeTransfer(beneficiary, unreleased);
677 
678     Released(unreleased);
679   }
680 
681   /**
682    * @notice Allows the owner to revoke the vesting. Tokens already vested
683    * remain in the contract, the rest are returned to the owner.
684    * @param token ERC20 token which is being vested
685    */
686   function revoke(ERC20Basic token) public onlyOwner {
687     require(revocable);
688     require(!revoked[token]);
689 
690     uint256 balance = token.balanceOf(this);
691 
692     uint256 unreleased = releasableAmount(token);
693     uint256 refund = balance.sub(unreleased);
694 
695     revoked[token] = true;
696 
697     token.safeTransfer(owner, refund);
698 
699     Revoked();
700   }
701 
702   /**
703    * @dev Calculates the amount that has already vested but hasn't been released yet.
704    * @param token ERC20 token which is being vested
705    */
706   function releasableAmount(ERC20Basic token) public view returns (uint256) {
707     return vestedAmount(token).sub(released[token]);
708   }
709 
710   /**
711    * @dev Calculates the amount that has already vested.
712    * @param token ERC20 token which is being vested
713    */
714   function vestedAmount(ERC20Basic token) public view returns (uint256) {
715     uint256 currentBalance = token.balanceOf(this);
716     uint256 totalBalance = currentBalance.add(released[token]);
717 
718     if (block.timestamp < cliff) {
719       return 0;
720     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
721       return totalBalance;
722     } else {
723       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
724     }
725   }
726 }
727 
728 // File: contracts/CircleCrowdsale.sol
729 
730 contract CircleCrowdsale is Ownable, MintedCrowdsale {
731 
732     // Crowdsale Stage
733     // ============
734     enum CrowdsaleStage {
735         AngelRound,
736         PreSaleRound,
737         OpenRound}
738 
739     // Token Distribution
740     // =============================
741     uint256 public totalSupplyMax = 2000000000 * (10 ** 18); // There will be total 2,000,000,000 Circle Tokens
742 
743     uint256 public angelRound = 200000000 * (10 ** 18);   // Angel Investors 200,000,000 (10%)
744     uint256 public preSaleRound = 400000000 * (10 ** 18);   // PreSale Round 400,000,000 (20%)
745     uint256 public openRound = 200000000 * (10 ** 18);   // Open Round 100,000,000 (10%)
746 
747     uint256 public teamFund = 400000000 * (10 ** 18);   // Team/Foundation 400,000,000 (20%) cliff 6mon
748     uint256 public communityFund = 400000000 * (10 ** 18);   // Community 400,000,000 (20%)
749     uint256 public marketingFund = 400000000 * (10 ** 18);   // Marketing 400,000,000 (20%)
750     // ==============================
751 
752     // Amount minted in Every Stage
753     // ==================
754     uint256 public totalTokenMintedAngel;
755     uint256 public totalTokenMintedPreSale;
756     uint256 public totalTokenMintedOpen;
757 
758     uint256 public totalTeamFundMinted;
759     uint256 public totalCommunityFundMinted;
760     uint256 public totalMarketingFundMinted;
761     // ===================
762 
763     // Stage Rate
764     // ============
765     uint256 private _angelRate = 60000;
766     uint256 private _preSaleRate = 30000;
767     uint256 private _openRate = 20000;
768     // ============
769 
770     // angel locked tokens
771     TokenTimelock public angelTimeLock;
772 
773     // team vesting tokens
774     TokenVesting public teamTokenVesting;
775 
776     // team vesting
777     uint256 public constant TEAM_VESTING_CLIFF = 6 * 30 days;
778     uint256 public constant TEAM_VESTING_DURATION = 2 years;
779 
780     ERC20 _token = new Circle();
781 
782     // Constructor
783     // ============
784     function CircleCrowdsale(uint256 _rate, address _wallet) public
785     Crowdsale(_rate, _wallet, _token)
786     {
787     }
788     // =============
789 
790     function() external payable {
791         revert();
792     }
793 
794     function buyTokens(address _beneficiary) public payable {
795         revert();
796     }
797 
798     function investByLegalTender(address _beneficiary, uint256 _value, uint _stage) onlyOwner external returns (bool)  {
799         uint256 _amount;
800         if (_stage == uint(CrowdsaleStage.PreSaleRound)) {
801             _amount = _preSaleRate * _value;
802             if (totalTokenMintedPreSale + _amount > preSaleRound) {
803                 return false;
804             }
805             MintableToken(token).mint(_beneficiary, _amount);
806             totalTokenMintedPreSale += _amount;
807         } else if (_stage == uint(CrowdsaleStage.OpenRound)) {
808 
809             _amount = _openRate * _value;
810             if (totalTokenMintedOpen + _amount > preSaleRound) {
811                 return false;
812             }
813 
814             MintableToken(token).mint(_beneficiary, _amount);
815             totalTokenMintedOpen += _amount;
816         } else {
817             return false;
818         }
819 
820         return true;
821     }
822 
823     function setAngelHolder(address _angelFundWallet) onlyOwner external {
824         if (angelRound - totalTokenMintedAngel > 0) {
825             angelTimeLock = new TokenTimelock(token, _angelFundWallet, uint64(now + 90 days));
826             MintableToken(token).mint(angelTimeLock, angelRound - totalTokenMintedAngel);
827             totalTokenMintedAngel = angelRound - totalTokenMintedAngel;
828         }
829     }
830 
831     function setReservedHolder(address _teamFundWallet, address _communityFundWallet, address _marketingFundWallet) onlyOwner external {
832         if (teamFund - totalTeamFundMinted > 0) {
833             teamTokenVesting = new TokenVesting(_teamFundWallet, now, TEAM_VESTING_CLIFF, TEAM_VESTING_DURATION, true);
834             MintableToken(token).mint(teamTokenVesting, teamFund - totalTeamFundMinted);
835             totalTeamFundMinted = teamFund - totalTeamFundMinted;
836         }
837 
838         if (communityFund - totalCommunityFundMinted > 0) {
839             MintableToken(token).mint(_communityFundWallet, communityFund - totalCommunityFundMinted);
840             totalCommunityFundMinted += communityFund - totalCommunityFundMinted;
841         }
842         if (marketingFund - totalMarketingFundMinted > 0) {
843             MintableToken(token).mint(_marketingFundWallet, marketingFund - totalMarketingFundMinted);
844             totalMarketingFundMinted += marketingFund - totalMarketingFundMinted;
845         }
846     }
847 
848 }