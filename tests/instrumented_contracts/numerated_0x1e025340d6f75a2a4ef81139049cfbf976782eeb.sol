1 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 pragma solidity ^0.4.18;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 //File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
18 pragma solidity ^0.4.18;
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   /**
50   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
68 pragma solidity ^0.4.18;
69 
70 
71 
72 
73 
74 
75 /**
76  * @title Basic token
77  * @dev Basic version of StandardToken, with no allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83 
84   uint256 totalSupply_;
85 
86   /**
87   * @dev total number of tokens in existence
88   */
89   function totalSupply() public view returns (uint256) {
90     return totalSupply_;
91   }
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) public returns (bool) {
99     require(_to != address(0));
100     require(_value <= balances[msg.sender]);
101 
102     // SafeMath.sub will throw if there is not enough balance.
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256 balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
121 pragma solidity ^0.4.18;
122 
123 
124 
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) public view returns (uint256);
132   function transferFrom(address from, address to, uint256 value) public returns (bool);
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
138 pragma solidity ^0.4.18;
139 
140 
141 
142 
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * @dev https://github.com/ethereum/EIPs/issues/20
149  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public view returns (uint256) {
197     return allowed[_owner][_spender];
198   }
199 
200   /**
201    * @dev Increase the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _addedValue The amount of tokens to increase the allowance by.
209    */
210   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
211     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   /**
217    * @dev Decrease the amount of tokens that an owner allowed to a spender.
218    *
219    * approve should be called when allowed[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
227     uint oldValue = allowed[msg.sender][_spender];
228     if (_subtractedValue > oldValue) {
229       allowed[msg.sender][_spender] = 0;
230     } else {
231       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232     }
233     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237 }
238 
239 //File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
240 pragma solidity ^0.4.18;
241 
242 
243 /**
244  * @title Ownable
245  * @dev The Ownable contract has an owner address, and provides basic authorization control
246  * functions, this simplifies the implementation of "user permissions".
247  */
248 contract Ownable {
249   address public owner;
250 
251 
252   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
253 
254 
255   /**
256    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
257    * account.
258    */
259   function Ownable() public {
260     owner = msg.sender;
261   }
262 
263   /**
264    * @dev Throws if called by any account other than the owner.
265    */
266   modifier onlyOwner() {
267     require(msg.sender == owner);
268     _;
269   }
270 
271   /**
272    * @dev Allows the current owner to transfer control of the contract to a newOwner.
273    * @param newOwner The address to transfer ownership to.
274    */
275   function transferOwnership(address newOwner) public onlyOwner {
276     require(newOwner != address(0));
277     OwnershipTransferred(owner, newOwner);
278     owner = newOwner;
279   }
280 
281 }
282 
283 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
284 pragma solidity ^0.4.18;
285 
286 
287 
288 
289 
290 /**
291  * @title Mintable token
292  * @dev Simple ERC20 Token example, with mintable token creation
293  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
294  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
295  */
296 contract MintableToken is StandardToken, Ownable {
297   event Mint(address indexed to, uint256 amount);
298   event MintFinished();
299 
300   bool public mintingFinished = false;
301 
302 
303   modifier canMint() {
304     require(!mintingFinished);
305     _;
306   }
307 
308   /**
309    * @dev Function to mint tokens
310    * @param _to The address that will receive the minted tokens.
311    * @param _amount The amount of tokens to mint.
312    * @return A boolean that indicates if the operation was successful.
313    */
314   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
315     totalSupply_ = totalSupply_.add(_amount);
316     balances[_to] = balances[_to].add(_amount);
317     Mint(_to, _amount);
318     Transfer(address(0), _to, _amount);
319     return true;
320   }
321 
322   /**
323    * @dev Function to stop minting new tokens.
324    * @return True if the operation was successful.
325    */
326   function finishMinting() onlyOwner canMint public returns (bool) {
327     mintingFinished = true;
328     MintFinished();
329     return true;
330   }
331 }
332 
333 //File: node_modules/zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
334 pragma solidity ^0.4.18;
335 
336 
337 
338 
339 
340 /**
341  * @title Crowdsale
342  * @dev Crowdsale is a base contract for managing a token crowdsale.
343  * Crowdsales have a start and end timestamps, where investors can make
344  * token purchases and the crowdsale will assign them tokens based
345  * on a token per ETH rate. Funds collected are forwarded to a wallet
346  * as they arrive.
347  */
348 contract Crowdsale {
349   using SafeMath for uint256;
350 
351   // The token being sold
352   MintableToken public token;
353 
354   // start and end timestamps where investments are allowed (both inclusive)
355   uint256 public startTime;
356   uint256 public endTime;
357 
358   // address where funds are collected
359   address public wallet;
360 
361   // how many token units a buyer gets per wei
362   uint256 public rate;
363 
364   // amount of raised money in wei
365   uint256 public weiRaised;
366 
367   /**
368    * event for token purchase logging
369    * @param purchaser who paid for the tokens
370    * @param beneficiary who got the tokens
371    * @param value weis paid for purchase
372    * @param amount amount of tokens purchased
373    */
374   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
375 
376 
377   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
378     require(_startTime >= now);
379     require(_endTime >= _startTime);
380     require(_rate > 0);
381     require(_wallet != address(0));
382 
383     token = createTokenContract();
384     startTime = _startTime;
385     endTime = _endTime;
386     rate = _rate;
387     wallet = _wallet;
388   }
389 
390   // fallback function can be used to buy tokens
391   function () external payable {
392     buyTokens(msg.sender);
393   }
394 
395   // low level token purchase function
396   function buyTokens(address beneficiary) public payable {
397     require(beneficiary != address(0));
398     require(validPurchase());
399 
400     uint256 weiAmount = msg.value;
401 
402     // calculate token amount to be created
403     uint256 tokens = getTokenAmount(weiAmount);
404 
405     // update state
406     weiRaised = weiRaised.add(weiAmount);
407 
408     token.mint(beneficiary, tokens);
409     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
410 
411     forwardFunds();
412   }
413 
414   // @return true if crowdsale event has ended
415   function hasEnded() public view returns (bool) {
416     return now > endTime;
417   }
418 
419   // creates the token to be sold.
420   // override this method to have crowdsale of a specific mintable token.
421   function createTokenContract() internal returns (MintableToken) {
422     return new MintableToken();
423   }
424 
425   // Override this method to have a way to add business logic to your crowdsale when buying
426   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
427     return weiAmount.mul(rate);
428   }
429 
430   // send ether to the fund collection wallet
431   // override to create custom fund forwarding mechanisms
432   function forwardFunds() internal {
433     wallet.transfer(msg.value);
434   }
435 
436   // @return true if the transaction can buy tokens
437   function validPurchase() internal view returns (bool) {
438     bool withinPeriod = now >= startTime && now <= endTime;
439     bool nonZeroPurchase = msg.value != 0;
440     return withinPeriod && nonZeroPurchase;
441   }
442 
443 }
444 
445 //File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
446 pragma solidity ^0.4.18;
447 
448 
449 
450 
451 
452 /**
453  * @title Pausable
454  * @dev Base contract which allows children to implement an emergency stop mechanism.
455  */
456 contract Pausable is Ownable {
457   event Pause();
458   event Unpause();
459 
460   bool public paused = false;
461 
462 
463   /**
464    * @dev Modifier to make a function callable only when the contract is not paused.
465    */
466   modifier whenNotPaused() {
467     require(!paused);
468     _;
469   }
470 
471   /**
472    * @dev Modifier to make a function callable only when the contract is paused.
473    */
474   modifier whenPaused() {
475     require(paused);
476     _;
477   }
478 
479   /**
480    * @dev called by the owner to pause, triggers stopped state
481    */
482   function pause() onlyOwner whenNotPaused public {
483     paused = true;
484     Pause();
485   }
486 
487   /**
488    * @dev called by the owner to unpause, returns to normal state
489    */
490   function unpause() onlyOwner whenPaused public {
491     paused = false;
492     Unpause();
493   }
494 }
495 
496 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
497 pragma solidity ^0.4.18;
498 
499 
500 
501 
502 
503 /**
504  * @title SafeERC20
505  * @dev Wrappers around ERC20 operations that throw on failure.
506  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
507  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
508  */
509 library SafeERC20 {
510   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
511     assert(token.transfer(to, value));
512   }
513 
514   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
515     assert(token.transferFrom(from, to, value));
516   }
517 
518   function safeApprove(ERC20 token, address spender, uint256 value) internal {
519     assert(token.approve(spender, value));
520   }
521 }
522 
523 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
524 pragma solidity ^0.4.18;
525 
526 
527 
528 
529 
530 
531 
532 /**
533  * @title TokenVesting
534  * @dev A token holder contract that can release its token balance gradually like a
535  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
536  * owner.
537  */
538 contract TokenVesting is Ownable {
539   using SafeMath for uint256;
540   using SafeERC20 for ERC20Basic;
541 
542   event Released(uint256 amount);
543   event Revoked();
544 
545   // beneficiary of tokens after they are released
546   address public beneficiary;
547 
548   uint256 public cliff;
549   uint256 public start;
550   uint256 public duration;
551 
552   bool public revocable;
553 
554   mapping (address => uint256) public released;
555   mapping (address => bool) public revoked;
556 
557   /**
558    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
559    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
560    * of the balance will have vested.
561    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
562    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
563    * @param _duration duration in seconds of the period in which the tokens will vest
564    * @param _revocable whether the vesting is revocable or not
565    */
566   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
567     require(_beneficiary != address(0));
568     require(_cliff <= _duration);
569 
570     beneficiary = _beneficiary;
571     revocable = _revocable;
572     duration = _duration;
573     cliff = _start.add(_cliff);
574     start = _start;
575   }
576 
577   /**
578    * @notice Transfers vested tokens to beneficiary.
579    * @param token ERC20 token which is being vested
580    */
581   function release(ERC20Basic token) public {
582     uint256 unreleased = releasableAmount(token);
583 
584     require(unreleased > 0);
585 
586     released[token] = released[token].add(unreleased);
587 
588     token.safeTransfer(beneficiary, unreleased);
589 
590     Released(unreleased);
591   }
592 
593   /**
594    * @notice Allows the owner to revoke the vesting. Tokens already vested
595    * remain in the contract, the rest are returned to the owner.
596    * @param token ERC20 token which is being vested
597    */
598   function revoke(ERC20Basic token) public onlyOwner {
599     require(revocable);
600     require(!revoked[token]);
601 
602     uint256 balance = token.balanceOf(this);
603 
604     uint256 unreleased = releasableAmount(token);
605     uint256 refund = balance.sub(unreleased);
606 
607     revoked[token] = true;
608 
609     token.safeTransfer(owner, refund);
610 
611     Revoked();
612   }
613 
614   /**
615    * @dev Calculates the amount that has already vested but hasn't been released yet.
616    * @param token ERC20 token which is being vested
617    */
618   function releasableAmount(ERC20Basic token) public view returns (uint256) {
619     return vestedAmount(token).sub(released[token]);
620   }
621 
622   /**
623    * @dev Calculates the amount that has already vested.
624    * @param token ERC20 token which is being vested
625    */
626   function vestedAmount(ERC20Basic token) public view returns (uint256) {
627     uint256 currentBalance = token.balanceOf(this);
628     uint256 totalBalance = currentBalance.add(released[token]);
629 
630     if (now < cliff) {
631       return 0;
632     } else if (now >= start.add(duration) || revoked[token]) {
633       return totalBalance;
634     } else {
635       return totalBalance.mul(now.sub(start)).div(duration);
636     }
637   }
638 }
639 
640 //File: node_modules/zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
641 pragma solidity ^0.4.18;
642 
643 
644 
645 
646 
647 /**
648  * @title Pausable token
649  * @dev StandardToken modified with pausable transfers.
650  **/
651 contract PausableToken is StandardToken, Pausable {
652 
653   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
654     return super.transfer(_to, _value);
655   }
656 
657   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
658     return super.transferFrom(_from, _to, _value);
659   }
660 
661   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
662     return super.approve(_spender, _value);
663   }
664 
665   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
666     return super.increaseApproval(_spender, _addedValue);
667   }
668 
669   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
670     return super.decreaseApproval(_spender, _subtractedValue);
671   }
672 }
673 
674 //File: src/contracts/ico/DividendToken.sol
675 /**
676  * @title Dividend contract
677  *
678  * @version 1.0
679  * @author Validity Labs AG <info@validitylabs.org>
680  */
681 pragma solidity ^0.4.18;
682 
683 
684 
685 
686 
687 contract DividendToken is StandardToken, Ownable {
688     using SafeMath for uint256;
689 
690     // time before dividendEndTime during which dividend cannot be claimed by token holders
691     // instead the unclaimed dividend can be claimed by treasury in that time span
692     uint256 public claimTimeout = 20 days;
693 
694     uint256 public dividendCycleTime = 350 days;
695 
696     uint256 public currentDividend;
697 
698     mapping(address => uint256) unclaimedDividend;
699 
700     // tracks when the dividend balance has been updated last time
701     mapping(address => uint256) public lastUpdate;
702 
703     uint256 public lastDividendIncreaseDate;
704 
705     // allow payment of dividend only by special treasury account (treasury can be set and altered by owner,
706     // multiple treasurer accounts are possible
707     mapping(address => bool) public isTreasurer;
708 
709     uint256 public dividendEndTime = 0;
710 
711     event Payin(address _owner, uint256 _value, uint256 _endTime);
712 
713     event Payout(address _tokenHolder, uint256 _value);
714 
715     event Reclaimed(uint256 remainingBalance, uint256 _endTime, uint256 _now);
716 
717     event ChangedTreasurer(address treasurer, bool active);
718 
719     /**
720      * @dev Deploy the DividendToken contract and set the owner of the contract
721      */
722     function DividendToken() public {
723         isTreasurer[owner] = true;
724     }
725 
726     /**
727      * @dev Request payout dividend (claim) (requested by tokenHolder -> pull)
728      * dividends that have not been claimed within 330 days expire and cannot be claimed anymore by the token holder.
729      */
730     function claimDividend() public returns (bool) {
731         // unclaimed dividend fractions should expire after 330 days and the owner can reclaim that fraction
732         require(dividendEndTime > 0 && dividendEndTime.sub(claimTimeout) > now);
733 
734         updateDividend(msg.sender);
735 
736         uint256 payment = unclaimedDividend[msg.sender];
737         unclaimedDividend[msg.sender] = 0;
738 
739         msg.sender.transfer(payment);
740 
741         // Trigger payout event
742         Payout(msg.sender, payment);
743 
744         return true;
745     }
746 
747     /**
748      * @dev Transfer dividend (fraction) to new token holder
749      * @param _from address The address of the old token holder
750      * @param _to address The address of the new token holder
751      * @param _value uint256 Number of tokens to transfer
752      */
753     function transferDividend(address _from, address _to, uint256 _value) internal {
754         updateDividend(_from);
755         updateDividend(_to);
756 
757         uint256 transAmount = unclaimedDividend[_from].mul(_value).div(balanceOf(_from));
758 
759         unclaimedDividend[_from] = unclaimedDividend[_from].sub(transAmount);
760         unclaimedDividend[_to] = unclaimedDividend[_to].add(transAmount);
761     }
762 
763     /**
764      * @dev Update the dividend of hodler
765      * @param _hodler address The Address of the hodler
766      */
767     function updateDividend(address _hodler) internal {
768         // last update in previous period -> reset claimable dividend
769         if (lastUpdate[_hodler] < lastDividendIncreaseDate) {
770             unclaimedDividend[_hodler] = calcDividend(_hodler, totalSupply_);
771             lastUpdate[_hodler] = now;
772         }
773     }
774 
775     /**
776      * @dev Get claimable dividend for the hodler
777      * @param _hodler address The Address of the hodler
778      */
779     function getClaimableDividend(address _hodler) public constant returns (uint256 claimableDividend) {
780         if (lastUpdate[_hodler] < lastDividendIncreaseDate) {
781             return calcDividend(_hodler, totalSupply_);
782         } else {
783             return (unclaimedDividend[_hodler]);
784         }
785     }
786 
787     /**
788      * @dev Overrides transfer method from BasicToken
789      * transfer token for a specified address
790      * @param _to address The address to transfer to.
791      * @param _value uint256 The amount to be transferred.
792      */
793     function transfer(address _to, uint256 _value) public returns (bool) {
794         transferDividend(msg.sender, _to, _value);
795 
796         // Return from inherited transfer method
797         return super.transfer(_to, _value);
798     }
799 
800     /**
801      * @dev Transfer tokens from one address to another
802      * @param _from address The address which you want to send tokens from
803      * @param _to address The address which you want to transfer to
804      * @param _value uint256 the amount of tokens to be transferred
805      */
806     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
807         // Prevent dividend to be claimed twice
808         transferDividend(_from, _to, _value);
809 
810         // Return from inherited transferFrom method
811         return super.transferFrom(_from, _to, _value);
812     }
813 
814     /**
815      * @dev Set / alter treasurer "account". This can be done from owner only
816      * @param _treasurer address Address of the treasurer to create/alter
817      * @param _active bool Flag that shows if the treasurer account is active
818      */
819     function setTreasurer(address _treasurer, bool _active) public onlyOwner {
820         isTreasurer[_treasurer] = _active;
821         ChangedTreasurer(_treasurer, _active);
822     }
823 
824     /**
825      * @dev Request unclaimed ETH, payback to beneficiary (owner) wallet
826      * dividend payment is possible every 330 days at the earliest - can be later, this allows for some flexibility,
827      * e.g. board meeting had to happen a bit earlier this year than previous year.
828      */
829     function requestUnclaimed() public onlyOwner {
830         // Send remaining ETH to beneficiary (back to owner) if dividend round is over
831         require(now >= dividendEndTime.sub(claimTimeout));
832 
833         msg.sender.transfer(this.balance);
834 
835         Reclaimed(this.balance, dividendEndTime, now);
836     }
837 
838     /**
839      * @dev ETH Payin for Treasurer
840      * Only owner or treasurer can do a payin for all token holder.
841      * Owner / treasurer can also increase dividend by calling fallback function multiple times.
842      */
843     function() public payable {
844         require(isTreasurer[msg.sender]);
845         require(dividendEndTime < now);
846 
847         // pay back unclaimed dividend that might not have been claimed by owner yet
848         if (this.balance > msg.value) {
849             uint256 payout = this.balance.sub(msg.value);
850             owner.transfer(payout);
851             Reclaimed(payout, dividendEndTime, now);
852         }
853 
854         currentDividend = this.balance;
855 
856         // No active dividend cycle found, initialize new round
857         dividendEndTime = now.add(dividendCycleTime);
858 
859         // Trigger payin event
860         Payin(msg.sender, msg.value, dividendEndTime);
861 
862         lastDividendIncreaseDate = now;
863     }
864 
865     /**
866      * @dev calculate the dividend
867      * @param _hodler address
868      * @param _totalSupply uint256
869      */
870     function calcDividend(address _hodler, uint256 _totalSupply) public view returns(uint256) {
871         return (currentDividend.mul(balanceOf(_hodler))).div(_totalSupply);
872     }
873 }
874 
875 //File: src/contracts/ico/IcoToken.sol
876 /**
877  * @title ICO token
878  * @version 1.0
879  * @author Validity Labs AG <info@validitylabs.org>
880  */
881 pragma solidity ^0.4.18;
882 
883 
884 
885 
886 
887 contract IcoToken is MintableToken, PausableToken, DividendToken {
888     string public constant name = "Tend Token";
889     string public constant symbol = "TND";
890     uint8 public constant decimals = 18;
891 
892     /**
893      * @dev Constructor of IcoToken that instantiate a new DividendToken
894      */
895     function IcoToken() public DividendToken() {
896         // token should not be transferrable until after all tokens have been issued
897         paused = true;
898     }
899 }
900 
901 //File: src/contracts/ico/IcoCrowdsale.sol
902 /**
903  * @title IcoCrowdsale
904  * Simple time and capped based crowdsale.
905  *
906  * @version 1.0
907  * @author Validity Labs AG <info@validitylabs.org>
908  */
909 pragma solidity ^0.4.18;
910 
911 
912 
913 
914 
915 
916 
917 contract IcoCrowdsale is Crowdsale, Ownable {
918     /*** CONSTANTS ***/
919     // Different levels of caps per allotment
920     uint256 public constant MAX_TOKEN_CAP = 13e6 * 1e18;        // 13 million * 1e18
921 
922     // // Bottom three should add to above
923     uint256 public constant ICO_ENABLERS_CAP = 15e5 * 1e18;     // 1.5 million * 1e18
924     uint256 public constant DEVELOPMENT_TEAM_CAP = 2e6 * 1e18;  // 2 million * 1e18
925     uint256 public constant ICO_TOKEN_CAP = 9.5e6 * 1e18;        // 9.5 million  * 1e18
926 
927     uint256 public constant CHF_CENT_PER_TOKEN = 1000;          // standard CHF per token rate - in cents - 10 CHF => 1000 CHF cents
928     uint256 public constant MIN_CONTRIBUTION_CHF = 250;
929 
930     uint256 public constant VESTING_CLIFF = 1 years;
931     uint256 public constant VESTING_DURATION = 3 years;
932 
933     // Amount of discounted tokens per discount stage (2 stages total; each being the same amount)
934     uint256 public constant DISCOUNT_TOKEN_AMOUNT_T1 = 3e6 * 1e18; // 3 million * 1e18
935     uint256 public constant DISCOUNT_TOKEN_AMOUNT_T2 = DISCOUNT_TOKEN_AMOUNT_T1 * 2;
936 
937     // Track tokens depending which stage that the ICO is in
938     uint256 public tokensToMint;            // tokens to be minted after confirmation
939     uint256 public tokensMinted;            // already minted tokens (maximally = cap)
940     uint256 public icoEnablersTokensMinted;
941     uint256 public developmentTeamTokensMinted;
942 
943     uint256 public minContributionInWei;
944     uint256 public tokenPerWei;
945     uint256 public totalTokensPurchased;
946     bool public capReached;
947     bool public tier1Reached;
948     bool public tier2Reached;
949 
950     address public underwriter;
951 
952     // allow managers to blacklist and confirm contributions by manager accounts
953     // (managers can be set and altered by owner, multiple manager accounts are possible
954     mapping(address => bool) public isManager;
955 
956     // true if addess is not allowed to invest
957     mapping(address => bool) public isBlacklisted;
958 
959     uint256 public confirmationPeriod;
960     bool public confirmationPeriodOver;     // can be set by owner to finish confirmation in under 30 days
961 
962     // for convenience we store vesting wallets
963     address[] public vestingWallets;
964 
965     uint256 public investmentIdLastAttemptedToSettle;
966 
967     struct Payment {
968         address investor;
969         address beneficiary;
970         uint256 weiAmount;
971         uint256 tokenAmount;
972         bool confirmed;
973         bool attemptedSettlement;
974         bool completedSettlement;
975     }
976 
977     Payment[] public investments;
978 
979     /*** EVENTS ***/
980     event ChangedInvestorBlacklisting(address investor, bool blacklisted);
981     event ChangedManager(address manager, bool active);
982     event ChangedInvestmentConfirmation(uint256 investmentId, address investor, bool confirmed);
983 
984     /*** MODIFIERS ***/
985     modifier onlyUnderwriter() {
986         require(msg.sender == underwriter);
987         _;
988     }
989 
990     modifier onlyManager() {
991         require(isManager[msg.sender]);
992         _;
993     }
994 
995     modifier onlyNoneZero(address _to, uint256 _amount) {
996         require(_to != address(0));
997         require(_amount > 0);
998         _;
999     }
1000 
1001     modifier onlyConfirmPayment() {
1002         require(now > endTime && now <= endTime.add(confirmationPeriod));
1003         require(!confirmationPeriodOver);
1004         _;
1005     }
1006 
1007     modifier onlyConfirmationOver() {
1008         require(confirmationPeriodOver || now > endTime.add(confirmationPeriod));
1009         _;
1010     }
1011 
1012     /**
1013      * @dev Deploy capped ico crowdsale contract
1014      * @param _startTime uint256 Start time of the crowdsale
1015      * @param _endTime uint256 End time of the crowdsale
1016      * @param _rateChfPerEth uint256 CHF per ETH rate
1017      * @param _wallet address Wallet address of the crowdsale
1018      * @param _confirmationPeriodDays uint256 Confirmation period in days
1019      * @param _underwriter address of the underwriter
1020      */
1021     function IcoCrowdsale(
1022         uint256 _startTime,
1023         uint256 _endTime,
1024         uint256 _rateChfPerEth,
1025         address _wallet,
1026         uint256 _confirmationPeriodDays,
1027         address _underwriter
1028     )
1029         public
1030         Crowdsale(_startTime, _endTime, _rateChfPerEth, _wallet)
1031     {
1032         require(MAX_TOKEN_CAP == ICO_ENABLERS_CAP.add(ICO_TOKEN_CAP).add(DEVELOPMENT_TEAM_CAP));
1033         require(_underwriter != address(0));
1034 
1035         setManager(msg.sender, true);
1036 
1037         tokenPerWei = (_rateChfPerEth.mul(1e2)).div(CHF_CENT_PER_TOKEN);
1038         minContributionInWei = (MIN_CONTRIBUTION_CHF.mul(1e18)).div(_rateChfPerEth);
1039 
1040         confirmationPeriod = _confirmationPeriodDays * 1 days;
1041         underwriter = _underwriter;
1042     }
1043 
1044     /**
1045      * @dev Set / alter manager / blacklister account. This can be done from owner only
1046      * @param _manager address address of the manager to create/alter
1047      * @param _active bool flag that shows if the manager account is active
1048      */
1049     function setManager(address _manager, bool _active) public onlyOwner {
1050         isManager[_manager] = _active;
1051         ChangedManager(_manager, _active);
1052     }
1053 
1054     /**
1055      * @dev blacklist investor from participating in the crowdsale
1056      * @param _investor address address of the investor to disallowed participation
1057      */
1058     function blackListInvestor(address _investor, bool _active) public onlyManager {
1059         isBlacklisted[_investor] = _active;
1060         ChangedInvestorBlacklisting(_investor, _active);
1061     }
1062 
1063     /**
1064      * @dev override (not extend! because we only issues tokens after final KYC confirm phase)
1065      *      core functionality by blacklist check and registration of payment
1066      * @param _beneficiary address address of the beneficiary to receive tokens after they have been confirmed
1067      */
1068     function buyTokens(address _beneficiary) public payable {
1069         require(_beneficiary != address(0));
1070         require(validPurchase());
1071         require(!isBlacklisted[msg.sender]);
1072 
1073         uint256 weiAmount = msg.value;
1074         uint256 tokenAmount;
1075         uint256 purchasedTokens = weiAmount.mul(tokenPerWei);
1076         uint256 tempTotalTokensPurchased = totalTokensPurchased.add(purchasedTokens);
1077         uint256 overflowTokens;
1078         uint256 overflowTokens2;
1079         // 20% discount bonus amount
1080         uint256 tier1BonusTokens;
1081         // 10% discount bonus amount
1082         uint256 tier2BonusTokens;
1083 
1084         // tier 1 20% discount - 1st 3 million tokens purchased
1085         if (!tier1Reached) {
1086 
1087             // tx tokens overflowed into next tier 2 - 10% discount - mark tier1Reached! else all tokens are tier 1 discounted
1088             if (tempTotalTokensPurchased > DISCOUNT_TOKEN_AMOUNT_T1) {
1089                 tier1Reached = true;
1090                 overflowTokens = tempTotalTokensPurchased.sub(DISCOUNT_TOKEN_AMOUNT_T1);
1091                 tier1BonusTokens = purchasedTokens.sub(overflowTokens);
1092             // tx tokens did not overflow into next tier 2 (10% discount)
1093             } else {
1094                 tier1BonusTokens = purchasedTokens;
1095             }
1096             //apply discount
1097             tier1BonusTokens = tier1BonusTokens.mul(10).div(8);
1098             tokenAmount = tokenAmount.add(tier1BonusTokens);
1099         }
1100 
1101         // tier 2 10% discount - 2nd 3 million tokens purchased
1102         if (tier1Reached && !tier2Reached) {
1103 
1104             // tx tokens overflowed into next tier 3 - 0% - marked tier2Reached! else all tokens are tier 2 discounted
1105             if (tempTotalTokensPurchased > DISCOUNT_TOKEN_AMOUNT_T2) {
1106                 tier2Reached = true;
1107                 overflowTokens2 = tempTotalTokensPurchased.sub(DISCOUNT_TOKEN_AMOUNT_T2);
1108                 tier2BonusTokens = purchasedTokens.sub(overflowTokens2);
1109             // tx tokens did not overflow into next tier 3 (tier 3 == no discount)
1110             } else {
1111                 // tokens overflowed from tier1 else this tx started in tier2
1112                 if (overflowTokens > 0) {
1113                     tier2BonusTokens = overflowTokens;
1114                 } else {
1115                     tier2BonusTokens = purchasedTokens;
1116                 }
1117             }
1118             // apply discount for tier 2 tokens
1119             tier2BonusTokens = tier2BonusTokens.mul(10).div(9);
1120             tokenAmount = tokenAmount.add(tier2BonusTokens).add(overflowTokens2);
1121         }
1122 
1123         // this triggers when both tier 1 and tier 2 discounted tokens have be filled - but ONLY afterwards, not if the flags got set during the same tx
1124         // aka this is tier 3
1125         if (tier2Reached && tier1Reached && tier2BonusTokens == 0) {
1126             tokenAmount = purchasedTokens;
1127         }
1128 
1129         /*** Record & update state variables  ***/
1130         // Tracks purchased tokens for 2 tiers of discounts
1131         totalTokensPurchased = totalTokensPurchased.add(purchasedTokens);
1132         // Tracks total tokens pending to be minted - this includes presale tokens
1133         tokensToMint = tokensToMint.add(tokenAmount);
1134 
1135         weiRaised = weiRaised.add(weiAmount);
1136 
1137         TokenPurchase(msg.sender, _beneficiary, weiAmount, tokenAmount);
1138 
1139         // register payment so that later on it can be confirmed (and tokens issued and Ether paid out)
1140         Payment memory newPayment = Payment(msg.sender, _beneficiary, weiAmount, tokenAmount, false, false, false);
1141         investments.push(newPayment);
1142     }
1143 
1144     /**
1145      * @dev confirms payment
1146      * @param _investmentId uint256 uint256 of the investment id to confirm
1147      */
1148     function confirmPayment(uint256 _investmentId) public onlyManager onlyConfirmPayment {
1149         investments[_investmentId].confirmed = true;
1150         ChangedInvestmentConfirmation(_investmentId, investments[_investmentId].investor, true);
1151     }
1152 
1153     /**
1154      * @dev confirms payments via a batch method
1155      * @param _investmentIds uint256[] array of uint256 of the investment ids to confirm
1156      */
1157     function batchConfirmPayments(uint256[] _investmentIds) public onlyManager onlyConfirmPayment {
1158         uint256 investmentId;
1159 
1160         for (uint256 c; c < _investmentIds.length; c = c.add(1)) {
1161             investmentId = _investmentIds[c]; // gas optimization
1162             confirmPayment(investmentId);
1163         }
1164     }
1165 
1166     /**
1167      * @dev unconfirms payment made via investment id
1168      * @param _investmentId uint256 uint256 of the investment to unconfirm
1169      */
1170     function unConfirmPayment(uint256 _investmentId) public onlyManager onlyConfirmPayment {
1171         investments[_investmentId].confirmed = false;
1172         ChangedInvestmentConfirmation(_investmentId, investments[_investmentId].investor, false);
1173     }
1174 
1175    /**
1176     * @dev allows contract owner to mint tokens for presale or non-ETH contributions in batches
1177      * @param _toList address[] array of the beneficiaries to receive tokens
1178      * @param _tokenList uint256[] array of the token amounts to mint for the corresponding users
1179     */
1180     function batchMintTokenDirect(address[] _toList, uint256[] _tokenList) public onlyOwner {
1181         require(_toList.length == _tokenList.length);
1182 
1183         for (uint256 i; i < _toList.length; i = i.add(1)) {
1184             mintTokenDirect(_toList[i], _tokenList[i]);
1185         }
1186     }
1187 
1188     /**
1189      * @dev allows contract owner to mint tokens for presale or non-ETH contributions
1190      * @param _to address of the beneficiary to receive tokens
1191      * @param _tokens uint256 of the token amount to mint
1192      */
1193     function mintTokenDirect(address _to, uint256 _tokens) public onlyOwner {
1194         require(tokensToMint.add(_tokens) <= ICO_TOKEN_CAP);
1195 
1196         tokensToMint = tokensToMint.add(_tokens);
1197 
1198         // register payment so that later on it can be confirmed (and tokens issued and Ether paid out)
1199         Payment memory newPayment = Payment(address(0), _to, 0, _tokens, false, false, false);
1200         investments.push(newPayment);
1201         TokenPurchase(msg.sender, _to, 0, _tokens);
1202     }
1203 
1204     /**
1205      * @dev allows contract owner to mint tokens for ICO enablers respecting the ICO_ENABLERS_CAP (no vesting)
1206      * @param _to address for beneficiary
1207      * @param _tokens uint256 token amount to mint
1208      */
1209     function mintIcoEnablersTokens(address _to, uint256 _tokens) public onlyOwner onlyNoneZero(_to, _tokens) {
1210         require(icoEnablersTokensMinted.add(_tokens) <= ICO_ENABLERS_CAP);
1211 
1212         token.mint(_to, _tokens);
1213         icoEnablersTokensMinted = icoEnablersTokensMinted.add(_tokens);
1214     }
1215 
1216     /**
1217      * @dev allows contract owner to mint team tokens per DEVELOPMENT_TEAM_CAP and transfer to the development team's wallet (yes vesting)
1218      * @param _to address for beneficiary
1219      * @param _tokens uint256 token amount to mint
1220      */
1221     function mintDevelopmentTeamTokens(address _to, uint256 _tokens) public onlyOwner onlyNoneZero(_to, _tokens) {
1222         require(developmentTeamTokensMinted.add(_tokens) <= DEVELOPMENT_TEAM_CAP);
1223 
1224         developmentTeamTokensMinted = developmentTeamTokensMinted.add(_tokens);
1225         TokenVesting newVault = new TokenVesting(_to, now, VESTING_CLIFF, VESTING_DURATION, false);
1226         vestingWallets.push(address(newVault)); // for convenience we keep them in storage so that they are easily accessible via MEW or etherscan
1227         token.mint(address(newVault), _tokens);
1228     }
1229 
1230     /**
1231      * @dev returns number of elements in the vestinWallets array
1232      */
1233     function getVestingWalletLength() public view returns (uint256) {
1234         return vestingWallets.length;
1235     }
1236 
1237     /**
1238      * @dev set final the confirmation period
1239      */
1240     function finalizeConfirmationPeriod() public onlyOwner onlyConfirmPayment {
1241         confirmationPeriodOver = true;
1242     }
1243 
1244     /**
1245      * @dev settlement of investment made via investment id
1246      * @param _investmentId uint256 uint256 being the investment id
1247      */
1248     function settleInvestment(uint256 _investmentId) public onlyConfirmationOver {
1249         Payment storage p = investments[_investmentId];
1250 
1251         // investment should not be settled already (prevent double token issueing or repayment)
1252         require(!p.completedSettlement);
1253 
1254         // investments have to be processed in right order
1255         // unless we're at first investment, the previous has needs to have undergone an attempted settlement
1256 
1257         require(_investmentId == 0 || investments[_investmentId.sub(1)].attemptedSettlement);
1258 
1259         p.attemptedSettlement = true;
1260 
1261         // just so that we can see which one we attempted last time and can continue with next
1262         investmentIdLastAttemptedToSettle = _investmentId;
1263 
1264         if (p.confirmed && !capReached) {
1265             // if confirmed -> issue tokens, send ETH to wallet and complete settlement
1266 
1267             // calculate number of tokens to be issued to investor
1268             uint256 tokens = p.tokenAmount;
1269 
1270             // check to see if this purchase sets it over the crowdsale token cap
1271             // if so, refund
1272             if (tokensMinted.add(tokens) > ICO_TOKEN_CAP) {
1273                 capReached = true;
1274                 if (p.weiAmount > 0) {
1275                     p.investor.send(p.weiAmount); // does not throw (otherwise we'd block all further settlements)
1276                 }
1277             } else {
1278                 tokensToMint = tokensToMint.sub(tokens);
1279                 tokensMinted = tokensMinted.add(tokens);
1280 
1281                 // mint tokens for beneficiary
1282                 token.mint(p.beneficiary, tokens);
1283                 if (p.weiAmount > 0) {
1284                     // send Ether to project wallet (throws if wallet throws)
1285                     wallet.transfer(p.weiAmount);
1286                 }
1287             }
1288 
1289             p.completedSettlement = true;
1290         } else {
1291             // if not confirmed -> reimburse ETH or if fiat (presale) investor: do nothing
1292             // only complete settlement if investor got their money back
1293             // (does not throw (as .transfer would)
1294             // otherwise we would block settlement process of all following investments)
1295             if (p.investor != address(0) && p.weiAmount > 0) {
1296                 if (p.investor.send(p.weiAmount)) {
1297                     p.completedSettlement = true;
1298                 }
1299             }
1300         }
1301     }
1302 
1303     /**
1304      * @dev allows the batch settlement of investments made
1305      * @param _investmentIds uint256[] array of uint256 of investment ids
1306      */
1307     function batchSettleInvestments(uint256[] _investmentIds) public {
1308         for (uint256 c; c < _investmentIds.length; c = c.add(1)) {
1309             settleInvestment(_investmentIds[c]);
1310         }
1311     }
1312 
1313     /**
1314      * @dev allows contract owner to finalize the ICO, unpause tokens, set treasurer, finish minting, and transfer ownship of the token contract
1315      */
1316     function finalize() public onlyUnderwriter onlyConfirmationOver {
1317         Pausable(token).unpause();
1318 
1319         // this crowdsale also should not be treasurer of the token anymore
1320         IcoToken(token).setTreasurer(this, false);
1321 
1322         // do not allow new owner to mint further tokens
1323         MintableToken(token).finishMinting();
1324 
1325         // until now the owner of the token is this crowdsale contract
1326         // in order for a human owner to make use of the tokens onlyOwner functions
1327         // we need to transfer the ownership
1328         // in the end the owner of this crowdsale will also be the owner of the token
1329         Ownable(token).transferOwnership(owner);
1330     }
1331 
1332     /**
1333      * @dev Create new instance of ico token contract
1334      */
1335     function createTokenContract() internal returns (MintableToken) {
1336         return new IcoToken();
1337     }
1338 
1339     /**
1340      * @dev extend base functionality with min investment amount
1341      */
1342     function validPurchase() internal view returns (bool) {
1343         // minimal investment: 250 CHF (represented in wei)
1344         require (msg.value >= minContributionInWei);
1345         return super.validPurchase();
1346     }
1347 }