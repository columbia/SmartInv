1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: zeppelin-solidity/contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: zeppelin-solidity/contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    */
211   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
218     uint oldValue = allowed[msg.sender][_spender];
219     if (_subtractedValue > oldValue) {
220       allowed[msg.sender][_spender] = 0;
221     } else {
222       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223     }
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228 }
229 
230 // File: zeppelin-solidity/contracts/token/MintableToken.sol
231 
232 /**
233  * @title Mintable token
234  * @dev Simple ERC20 Token example, with mintable token creation
235  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
236  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
237  */
238 
239 contract MintableToken is StandardToken, Ownable {
240   event Mint(address indexed to, uint256 amount);
241   event MintFinished();
242 
243   bool public mintingFinished = false;
244 
245 
246   modifier canMint() {
247     require(!mintingFinished);
248     _;
249   }
250 
251   /**
252    * @dev Function to mint tokens
253    * @param _to The address that will receive the minted tokens.
254    * @param _amount The amount of tokens to mint.
255    * @return A boolean that indicates if the operation was successful.
256    */
257   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
258     totalSupply = totalSupply.add(_amount);
259     balances[_to] = balances[_to].add(_amount);
260     Mint(_to, _amount);
261     Transfer(address(0), _to, _amount);
262     return true;
263   }
264 
265   /**
266    * @dev Function to stop minting new tokens.
267    * @return True if the operation was successful.
268    */
269   function finishMinting() onlyOwner canMint public returns (bool) {
270     mintingFinished = true;
271     MintFinished();
272     return true;
273   }
274 }
275 
276 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
277 
278 /**
279  * @title Crowdsale
280  * @dev Crowdsale is a base contract for managing a token crowdsale.
281  * Crowdsales have a start and end timestamps, where investors can make
282  * token purchases and the crowdsale will assign them tokens based
283  * on a token per ETH rate. Funds collected are forwarded to a wallet
284  * as they arrive.
285  */
286 contract Crowdsale {
287   using SafeMath for uint256;
288 
289   // The token being sold
290   MintableToken public token;
291 
292   // start and end timestamps where investments are allowed (both inclusive)
293   uint256 public startTime;
294   uint256 public endTime;
295 
296   // address where funds are collected
297   address public wallet;
298 
299   // how many token units a buyer gets per wei
300   uint256 public rate;
301 
302   // amount of raised money in wei
303   uint256 public weiRaised;
304 
305   /**
306    * event for token purchase logging
307    * @param purchaser who paid for the tokens
308    * @param beneficiary who got the tokens
309    * @param value weis paid for purchase
310    * @param amount amount of tokens purchased
311    */
312   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
313 
314 
315   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
316     require(_startTime >= now);
317     require(_endTime >= _startTime);
318     require(_rate > 0);
319     require(_wallet != address(0));
320 
321     token = createTokenContract();
322     startTime = _startTime;
323     endTime = _endTime;
324     rate = _rate;
325     wallet = _wallet;
326   }
327 
328   // creates the token to be sold.
329   // override this method to have crowdsale of a specific mintable token.
330   function createTokenContract() internal returns (MintableToken) {
331     return new MintableToken();
332   }
333 
334 
335   // fallback function can be used to buy tokens
336   function () external payable {
337     buyTokens(msg.sender);
338   }
339 
340   // low level token purchase function
341   function buyTokens(address beneficiary) public payable {
342     require(beneficiary != address(0));
343     require(validPurchase());
344 
345     uint256 weiAmount = msg.value;
346 
347     // calculate token amount to be created
348     uint256 tokens = weiAmount.mul(rate);
349 
350     // update state
351     weiRaised = weiRaised.add(weiAmount);
352 
353     token.mint(beneficiary, tokens);
354     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
355 
356     forwardFunds();
357   }
358 
359   // send ether to the fund collection wallet
360   // override to create custom fund forwarding mechanisms
361   function forwardFunds() internal {
362     wallet.transfer(msg.value);
363   }
364 
365   // @return true if the transaction can buy tokens
366   function validPurchase() internal view returns (bool) {
367     bool withinPeriod = now >= startTime && now <= endTime;
368     bool nonZeroPurchase = msg.value != 0;
369     return withinPeriod && nonZeroPurchase;
370   }
371 
372   // @return true if crowdsale event has ended
373   function hasEnded() public view returns (bool) {
374     return now > endTime;
375   }
376 
377 
378 }
379 
380 // File: libs/BonusCrowdsale.sol
381 
382 /**
383 * @dev Parent crowdsale contract with support for time-based and amount based bonuses 
384 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
385 * 
386 */
387 contract BonusCrowdsale is Crowdsale, Ownable {
388 
389     // Constants
390     // The following will be populated by main crowdsale contract
391     uint32[] public BONUS_TIMES;
392     uint32[] public BONUS_TIMES_VALUES;
393     uint32[] public BONUS_AMOUNTS;
394     uint32[] public BONUS_AMOUNTS_VALUES;
395     uint public constant BONUS_COEFF = 1000; // Values should be 10x percents, value 1000 = 100%
396     
397     // Members
398     uint public tokenPriceInCents;
399 
400     /**
401     * @dev Contructor
402     * @param _tokenPriceInCents token price in USD cents. The price is fixed
403     */
404     function BonusCrowdsale(uint256 _tokenPriceInCents) public {
405         tokenPriceInCents = _tokenPriceInCents;
406     }
407 
408     /**
409     * @dev Retrieve length of bonuses by time array
410     * @return Bonuses by time array length
411     */
412     function bonusesForTimesCount() public constant returns(uint) {
413         return BONUS_TIMES.length;
414     }
415 
416     /**
417     * @dev Sets bonuses for time
418     */
419     function setBonusesForTimes(uint32[] times, uint32[] values) public onlyOwner {
420         require(times.length == values.length);
421         for (uint i = 0; i + 1 < times.length; i++) {
422             require(times[i] < times[i+1]);
423         }
424 
425         BONUS_TIMES = times;
426         BONUS_TIMES_VALUES = values;
427     }
428 
429     /**
430     * @dev Retrieve length of bonuses by amounts array
431     * @return Bonuses by amounts array length
432     */
433     function bonusesForAmountsCount() public constant returns(uint) {
434         return BONUS_AMOUNTS.length;
435     }
436 
437     /**
438     * @dev Sets bonuses for USD amounts
439     */
440     function setBonusesForAmounts(uint32[] amounts, uint32[] values) public onlyOwner {
441         require(amounts.length == values.length);
442         for (uint i = 0; i + 1 < amounts.length; i++) {
443             require(amounts[i] > amounts[i+1]);
444         }
445 
446         BONUS_AMOUNTS = amounts;
447         BONUS_AMOUNTS_VALUES = values;
448     }
449 
450     /**
451     * @dev Overrided buyTokens method of parent Crowdsale contract  to provide bonus by changing and restoring rate variable
452     * @param beneficiary walelt of investor to receive tokens
453     */
454     function buyTokens(address beneficiary) public payable {
455         // Compute usd amount = wei * catsInEth * usdcentsInCat / usdcentsPerUsd / weisPerEth
456         uint256 usdValue = msg.value.mul(rate).mul(tokenPriceInCents).div(1000).div(1 ether);
457         
458         // Compute time and amount bonus
459         uint256 bonus = computeBonus(usdValue);
460 
461         // Apply bonus by adjusting and restoring rate member
462         uint256 oldRate = rate;
463         rate = rate.mul(BONUS_COEFF.add(bonus)).div(BONUS_COEFF);
464         super.buyTokens(beneficiary);
465         rate = oldRate;
466     }
467 
468     /**
469     * @dev Computes overall bonus based on time of contribution and amount of contribution. 
470     * The total bonus is the sum of bonus by time and bonus by amount
471     * @return bonus percentage scaled by 10
472     */
473     function computeBonus(uint256 usdValue) public constant returns(uint256) {
474         return computeAmountBonus(usdValue).add(computeTimeBonus());
475     }
476 
477     /**
478     * @dev Computes bonus based on time of contribution relative to the beginning of crowdsale
479     * @return bonus percentage scaled by 10
480     */
481     function computeTimeBonus() public constant returns(uint256) {
482         require(now >= startTime);
483 
484         for (uint i = 0; i < BONUS_TIMES.length; i++) {
485             if (now.sub(startTime) <= BONUS_TIMES[i]) {
486                 return BONUS_TIMES_VALUES[i];
487             }
488         }
489 
490         return 0;
491     }
492 
493     /**
494     * @dev Computes bonus based on amount of contribution
495     * @return bonus percentage scaled by 10
496     */
497     function computeAmountBonus(uint256 usdValue) public constant returns(uint256) {
498         for (uint i = 0; i < BONUS_AMOUNTS.length; i++) {
499             if (usdValue >= BONUS_AMOUNTS[i]) {
500                 return BONUS_AMOUNTS_VALUES[i];
501             }
502         }
503 
504         return 0;
505     }
506 
507 }
508 
509 // File: libs/TokensCappedCrowdsale.sol
510 
511 /**
512 * @dev Parent crowdsale contract is extended with support for cap in tokens
513 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
514 * 
515 */
516 contract TokensCappedCrowdsale is Crowdsale {
517 
518     uint256 public tokensCap;
519 
520     function TokensCappedCrowdsale(uint256 _tokensCap) public {
521         tokensCap = _tokensCap;
522     }
523 
524     // overriding Crowdsale#validPurchase to add extra tokens cap logic
525     // @return true if investors can buy at the moment
526     function validPurchase() internal constant returns(bool) {
527         uint256 tokens = token.totalSupply().add(msg.value.mul(rate));
528         bool withinCap = tokens <= tokensCap;
529         return super.validPurchase() && withinCap;
530     }
531 
532     // overriding Crowdsale#hasEnded to add tokens cap logic
533     // @return true if crowdsale event has ended
534     function hasEnded() public constant returns(bool) {
535         bool capReached = token.totalSupply() >= tokensCap;
536         return super.hasEnded() || capReached;
537     }
538 
539 }
540 
541 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
542 
543 /**
544  * @title Pausable
545  * @dev Base contract which allows children to implement an emergency stop mechanism.
546  */
547 contract Pausable is Ownable {
548   event Pause();
549   event Unpause();
550 
551   bool public paused = false;
552 
553 
554   /**
555    * @dev Modifier to make a function callable only when the contract is not paused.
556    */
557   modifier whenNotPaused() {
558     require(!paused);
559     _;
560   }
561 
562   /**
563    * @dev Modifier to make a function callable only when the contract is paused.
564    */
565   modifier whenPaused() {
566     require(paused);
567     _;
568   }
569 
570   /**
571    * @dev called by the owner to pause, triggers stopped state
572    */
573   function pause() onlyOwner whenNotPaused public {
574     paused = true;
575     Pause();
576   }
577 
578   /**
579    * @dev called by the owner to unpause, returns to normal state
580    */
581   function unpause() onlyOwner whenPaused public {
582     paused = false;
583     Unpause();
584   }
585 }
586 
587 // File: zeppelin-solidity/contracts/token/PausableToken.sol
588 
589 /**
590  * @title Pausable token
591  *
592  * @dev StandardToken modified with pausable transfers.
593  **/
594 
595 contract PausableToken is StandardToken, Pausable {
596 
597   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
598     return super.transfer(_to, _value);
599   }
600 
601   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
602     return super.transferFrom(_from, _to, _value);
603   }
604 
605   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
606     return super.approve(_spender, _value);
607   }
608 
609   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
610     return super.increaseApproval(_spender, _addedValue);
611   }
612 
613   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
614     return super.decreaseApproval(_spender, _subtractedValue);
615   }
616 }
617 
618 // File: zeppelin-solidity/contracts/token/SafeERC20.sol
619 
620 /**
621  * @title SafeERC20
622  * @dev Wrappers around ERC20 operations that throw on failure.
623  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
624  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
625  */
626 library SafeERC20 {
627   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
628     assert(token.transfer(to, value));
629   }
630 
631   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
632     assert(token.transferFrom(from, to, value));
633   }
634 
635   function safeApprove(ERC20 token, address spender, uint256 value) internal {
636     assert(token.approve(spender, value));
637   }
638 }
639 
640 // File: zeppelin-solidity/contracts/token/TokenTimelock.sol
641 
642 /**
643  * @title TokenTimelock
644  * @dev TokenTimelock is a token holder contract that will allow a
645  * beneficiary to extract the tokens after a given release time
646  */
647 contract TokenTimelock {
648   using SafeERC20 for ERC20Basic;
649 
650   // ERC20 basic token contract being held
651   ERC20Basic public token;
652 
653   // beneficiary of tokens after they are released
654   address public beneficiary;
655 
656   // timestamp when token release is enabled
657   uint64 public releaseTime;
658 
659   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
660     require(_releaseTime > now);
661     token = _token;
662     beneficiary = _beneficiary;
663     releaseTime = _releaseTime;
664   }
665 
666   /**
667    * @notice Transfers tokens held by timelock to beneficiary.
668    */
669   function release() public {
670     require(now >= releaseTime);
671 
672     uint256 amount = token.balanceOf(this);
673     require(amount > 0);
674 
675     token.safeTransfer(beneficiary, amount);
676   }
677 }
678 
679 // File: zeppelin-solidity/contracts/token/TokenVesting.sol
680 
681 /**
682  * @title TokenVesting
683  * @dev A token holder contract that can release its token balance gradually like a
684  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
685  * owner.
686  */
687 contract TokenVesting is Ownable {
688   using SafeMath for uint256;
689   using SafeERC20 for ERC20Basic;
690 
691   event Released(uint256 amount);
692   event Revoked();
693 
694   // beneficiary of tokens after they are released
695   address public beneficiary;
696 
697   uint256 public cliff;
698   uint256 public start;
699   uint256 public duration;
700 
701   bool public revocable;
702 
703   mapping (address => uint256) public released;
704   mapping (address => bool) public revoked;
705 
706   /**
707    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
708    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
709    * of the balance will have vested.
710    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
711    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
712    * @param _duration duration in seconds of the period in which the tokens will vest
713    * @param _revocable whether the vesting is revocable or not
714    */
715   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
716     require(_beneficiary != address(0));
717     require(_cliff <= _duration);
718 
719     beneficiary = _beneficiary;
720     revocable = _revocable;
721     duration = _duration;
722     cliff = _start.add(_cliff);
723     start = _start;
724   }
725 
726   /**
727    * @notice Transfers vested tokens to beneficiary.
728    * @param token ERC20 token which is being vested
729    */
730   function release(ERC20Basic token) public {
731     uint256 unreleased = releasableAmount(token);
732 
733     require(unreleased > 0);
734 
735     released[token] = released[token].add(unreleased);
736 
737     token.safeTransfer(beneficiary, unreleased);
738 
739     Released(unreleased);
740   }
741 
742   /**
743    * @notice Allows the owner to revoke the vesting. Tokens already vested
744    * remain in the contract, the rest are returned to the owner.
745    * @param token ERC20 token which is being vested
746    */
747   function revoke(ERC20Basic token) public onlyOwner {
748     require(revocable);
749     require(!revoked[token]);
750 
751     uint256 balance = token.balanceOf(this);
752 
753     uint256 unreleased = releasableAmount(token);
754     uint256 refund = balance.sub(unreleased);
755 
756     revoked[token] = true;
757 
758     token.safeTransfer(owner, refund);
759 
760     Revoked();
761   }
762 
763   /**
764    * @dev Calculates the amount that has already vested but hasn't been released yet.
765    * @param token ERC20 token which is being vested
766    */
767   function releasableAmount(ERC20Basic token) public view returns (uint256) {
768     return vestedAmount(token).sub(released[token]);
769   }
770 
771   /**
772    * @dev Calculates the amount that has already vested.
773    * @param token ERC20 token which is being vested
774    */
775   function vestedAmount(ERC20Basic token) public view returns (uint256) {
776     uint256 currentBalance = token.balanceOf(this);
777     uint256 totalBalance = currentBalance.add(released[token]);
778 
779     if (now < cliff) {
780       return 0;
781     } else if (now >= start.add(duration) || revoked[token]) {
782       return totalBalance;
783     } else {
784       return totalBalance.mul(now.sub(start)).div(duration);
785     }
786   }
787 }
788 
789 // File: contracts/MDKToken.sol
790 
791 contract MDKToken is MintableToken, PausableToken {
792   string public constant name = "MDKToken";
793   string public constant symbol = "MDK";
794   uint8 public constant decimals = 18;
795 
796   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
797 
798   TokenTimelock public reserveTokens;
799   TokenVesting public teamTokens;
800 
801   address public PreICO = address(0);
802   address public ICO = address(0);
803 
804   /**
805   * @dev Constructor
806   * Initializing token contract, locking team and reserve funds, sending renumeration fund to owner
807   */
808   function MDKToken(address _teamFund) public {
809     lockTeamTokens(_teamFund);
810     lockReserveTokens(_teamFund);
811 
812     mint(_teamFund, 250000000 * (10 ** uint256(decimals)));
813     pause();
814   }
815 
816   /**
817   * @dev Lock team tokens for 3 years with vesting contract. Team can receive first portion of tokens 3 months after contract created, after that they can get portion of tokens proportional to time left until full unlock
818   */
819   function lockTeamTokens(address _teamFund) private {
820     teamTokens = new TokenVesting(_teamFund, now, 90 days, 1095 days, false);
821     mint(teamTokens, 200000000 * (10 ** uint256(decimals)));
822   }
823 
824   /**
825   * @dev Lock reserve tokens for 1 year
826   */
827   function lockReserveTokens(address _teamFund) private {
828     reserveTokens = new TokenTimelock(this, _teamFund, uint64(now + 1 years));
829     mint(reserveTokens, 50000000 * (10 ** uint256(decimals)));
830   }
831 
832   /**
833   * @dev Starts ICO, making ICO contract owner, so it can mint
834   */
835   function startICO(address _icoAddress) onlyOwner public {
836     require(ICO == address(0));
837     require(PreICO != address(0));
838     require(_icoAddress != address(0));
839 
840     ICO = _icoAddress;
841     transferOwnership(_icoAddress);
842   }
843 
844   /**
845   * @dev Starts PreICO, making PreICO contract owner, so it can mint
846   */
847   function startPreICO(address _icoAddress) onlyOwner public {
848     require(PreICO == address(0));
849     require(_icoAddress != address(0));
850 
851     PreICO = _icoAddress;
852     transferOwnership(_icoAddress);
853   }
854 
855 }
856 
857 // File: zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
858 
859 /**
860  * @title FinalizableCrowdsale
861  * @dev Extension of Crowdsale where an owner can do extra work
862  * after finishing.
863  */
864 contract FinalizableCrowdsale is Crowdsale, Ownable {
865   using SafeMath for uint256;
866 
867   bool public isFinalized = false;
868 
869   event Finalized();
870 
871   /**
872    * @dev Must be called after crowdsale ends, to do some extra finalization
873    * work. Calls the contract's finalization function.
874    */
875   function finalize() onlyOwner public {
876     require(!isFinalized);
877     require(hasEnded());
878 
879     finalization();
880     Finalized();
881 
882     isFinalized = true;
883   }
884 
885   /**
886    * @dev Can be overridden to add finalization logic. The overriding function
887    * should call super.finalization() to ensure the chain of finalization is
888    * executed entirely.
889    */
890   function finalization() internal {
891   }
892 }
893 
894 // File: contracts/MDKICO.sol
895 
896 contract MDKICO is TokensCappedCrowdsale(MDKICO.TOKENS_CAP), FinalizableCrowdsale, BonusCrowdsale(MDKICO.TOKEN_USDCENT_PRICE) {
897 
898   uint8 public constant decimals = 18;
899   uint256 constant TOKENS_CAP = 600000000 * (10 ** uint256(decimals));
900   uint256 public constant TOKEN_USDCENT_PRICE = 18;
901 
902   event RateChange(uint256 rate);
903 
904   /**
905   * @dev Contructor
906   * @param _startTime startTime of crowdsale
907   * @param _endTime endTime of crowdsale
908   * @param _rate MDK / ETH rate
909   * @param _token Address of MDKToken contract
910   */
911   function MDKICO(
912     uint _startTime,
913     uint _endTime,
914     uint256 _rate,
915     address _token,
916     address _teamWallet
917   ) public
918     Crowdsale(_startTime, _endTime, _rate, _teamWallet)
919   {
920     require(_token != address(0));
921     token = MintableToken(_token);
922   }
923 
924   /**
925   * @dev Sets MDK to Ether rate. Will be called multiple times durign the crowdsale to adjsut the rate
926   * since MDK cost is fixed in USD, but USD/ETH rate is changing
927   * @param _rate defines MDK/ETH rate: 1 ETH = _rate MDKs
928   */
929   function setRate(uint256 _rate) external onlyOwner {
930       require(_rate != 0x0);
931       rate = _rate;
932       RateChange(_rate);
933   }
934 
935   /**
936   * @dev Gives user tokens for contribution in bitcoins
937   * @param _beneficiary User who'll receive tokens
938   * @param tokens Amount of tokens
939   */
940   function buyForBitcoin(address _beneficiary, uint256 tokens) public onlyOwner {
941     mintTokens(_beneficiary, tokens);
942   }
943 
944   function mintTokens(address beneficiary, uint256 tokens) public onlyOwner {
945     require(beneficiary != 0);
946     require(tokens > 0);
947     require(now <= endTime);                               // Crowdsale (without startTime check)
948     require(!isFinalized);                                 // FinalizableCrowdsale
949     require(token.totalSupply().add(tokens) <= TOKENS_CAP); // TokensCappedCrowdsale
950 
951     token.mint(beneficiary, tokens);
952   }
953 
954   /**
955   * @dev Allows to adjust the crowdsale end time
956   */
957   function setEndTime(uint256 _endTime) external onlyOwner {
958     require(!isFinalized);
959     require(_endTime >= startTime);
960     require(_endTime >= now);
961     endTime = _endTime;
962   }
963 
964   /**
965   * @dev Override super createTokenContract, so it'll not deploy MintableToke
966   */
967   function createTokenContract() internal returns (MintableToken) {
968     return MintableToken(0);
969   }
970 
971   /**
972   * @dev Give not bought tokens to owner, also give back ownership of MDKToken contract
973   */
974   function finalization() internal {
975     /*
976     We don't call finishMinting in finalization,
977     because after ICO we will held main round of ICO few months later
978     */
979     token.transferOwnership(owner);
980   }
981 
982 
983 }