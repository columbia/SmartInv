1 pragma solidity 0.4.15;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts/Authorizable.sol
48 
49 contract Authorizable is Ownable {
50     event LogAccess(address authAddress);
51     event Grant(address authAddress, bool grant);
52 
53     mapping(address => bool) public auth;
54 
55     modifier authorized() {
56         LogAccess(msg.sender);
57         require(auth[msg.sender]);
58         _;
59     }
60 
61     function authorize(address _address) onlyOwner public {
62         Grant(_address, true);
63         auth[_address] = true;
64     }
65 
66     function unauthorize(address _address) onlyOwner public {
67         Grant(_address, false);
68         auth[_address] = false;
69     }
70 }
71 
72 // File: zeppelin-solidity/contracts/math/SafeMath.sol
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
80     uint256 c = a * b;
81     assert(a == 0 || c / a == b);
82     return c;
83   }
84 
85   function div(uint256 a, uint256 b) internal constant returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return c;
90   }
91 
92   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   function add(uint256 a, uint256 b) internal constant returns (uint256) {
98     uint256 c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
105 
106 /**
107  * @title ERC20Basic
108  * @dev Simpler version of ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/179
110  */
111 contract ERC20Basic {
112   uint256 public totalSupply;
113   function balanceOf(address who) public constant returns (uint256);
114   function transfer(address to, uint256 value) public returns (bool);
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 // File: zeppelin-solidity/contracts/token/BasicToken.sol
119 
120 /**
121  * @title Basic token
122  * @dev Basic version of StandardToken, with no allowances.
123  */
124 contract BasicToken is ERC20Basic {
125   using SafeMath for uint256;
126 
127   mapping(address => uint256) balances;
128 
129   /**
130   * @dev transfer token for a specified address
131   * @param _to The address to transfer to.
132   * @param _value The amount to be transferred.
133   */
134   function transfer(address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136 
137     // SafeMath.sub will throw if there is not enough balance.
138     balances[msg.sender] = balances[msg.sender].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     Transfer(msg.sender, _to, _value);
141     return true;
142   }
143 
144   /**
145   * @dev Gets the balance of the specified address.
146   * @param _owner The address to query the the balance of.
147   * @return An uint256 representing the amount owned by the passed address.
148   */
149   function balanceOf(address _owner) public constant returns (uint256 balance) {
150     return balances[_owner];
151   }
152 
153 }
154 
155 // File: zeppelin-solidity/contracts/token/ERC20.sol
156 
157 /**
158  * @title ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/20
160  */
161 contract ERC20 is ERC20Basic {
162   function allowance(address owner, address spender) public constant returns (uint256);
163   function transferFrom(address from, address to, uint256 value) public returns (bool);
164   function approve(address spender, uint256 value) public returns (bool);
165   event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 // File: zeppelin-solidity/contracts/token/StandardToken.sol
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
189     require(_to != address(0));
190 
191     uint256 _allowance = allowed[_from][msg.sender];
192 
193     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
194     // require (_value <= _allowance);
195 
196     balances[_from] = balances[_from].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     allowed[_from][msg.sender] = _allowance.sub(_value);
199     Transfer(_from, _to, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
205    *
206    * Beware that changing an allowance with this method brings the risk that someone may use both the old
207    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210    * @param _spender The address which will spend the funds.
211    * @param _value The amount of tokens to be spent.
212    */
213   function approve(address _spender, uint256 _value) public returns (bool) {
214     allowed[msg.sender][_spender] = _value;
215     Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Function to check the amount of tokens that an owner allowed to a spender.
221    * @param _owner address The address which owns the funds.
222    * @param _spender address The address which will spend the funds.
223    * @return A uint256 specifying the amount of tokens still available for the spender.
224    */
225   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230    * approve should be called when allowed[_spender] == 0. To increment
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    */
235   function increaseApproval (address _spender, uint _addedValue)
236     returns (bool success) {
237     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242   function decreaseApproval (address _spender, uint _subtractedValue)
243     returns (bool success) {
244     uint oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue > oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
255 
256 // File: zeppelin-solidity/contracts/token/MintableToken.sol
257 
258 /**
259  * @title Mintable token
260  * @dev Simple ERC20 Token example, with mintable token creation
261  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
262  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
263  */
264 
265 contract MintableToken is StandardToken, Ownable {
266   event Mint(address indexed to, uint256 amount);
267   event MintFinished();
268 
269   bool public mintingFinished = false;
270 
271 
272   modifier canMint() {
273     require(!mintingFinished);
274     _;
275   }
276 
277   /**
278    * @dev Function to mint tokens
279    * @param _to The address that will receive the minted tokens.
280    * @param _amount The amount of tokens to mint.
281    * @return A boolean that indicates if the operation was successful.
282    */
283   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
284     totalSupply = totalSupply.add(_amount);
285     balances[_to] = balances[_to].add(_amount);
286     Mint(_to, _amount);
287     Transfer(0x0, _to, _amount);
288     return true;
289   }
290 
291   /**
292    * @dev Function to stop minting new tokens.
293    * @return True if the operation was successful.
294    */
295   function finishMinting() onlyOwner public returns (bool) {
296     mintingFinished = true;
297     MintFinished();
298     return true;
299   }
300 }
301 
302 // File: contracts/TutellusToken.sol
303 
304 /**
305  * @title Tutellus Token
306  * @author Javier Ortiz
307  *
308  * @dev ERC20 Tutellus Token (TUT)
309  */
310 contract TutellusToken is MintableToken {
311    string public name = "Tutellus";
312    string public symbol = "TUT";
313    uint8 public decimals = 18;
314 }
315 
316 // File: contracts/TutellusVault.sol
317 
318 contract TutellusVault is Authorizable {
319     event VaultMint(address indexed authAddress);
320 
321     TutellusToken public token;
322 
323     function TutellusVault() public {
324         token = new TutellusToken();
325     }
326 
327     function mint(address _to, uint256 _amount) authorized public returns (bool) {
328         require(_to != address(0));
329         require(_amount >= 0);
330 
331         VaultMint(msg.sender);
332         return token.mint(_to, _amount);
333     }
334 }
335 
336 // File: zeppelin-solidity/contracts/token/SafeERC20.sol
337 
338 /**
339  * @title SafeERC20
340  * @dev Wrappers around ERC20 operations that throw on failure.
341  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
342  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
343  */
344 library SafeERC20 {
345   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
346     assert(token.transfer(to, value));
347   }
348 
349   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
350     assert(token.transferFrom(from, to, value));
351   }
352 
353   function safeApprove(ERC20 token, address spender, uint256 value) internal {
354     assert(token.approve(spender, value));
355   }
356 }
357 
358 // File: contracts/TokenVesting.sol
359 
360 // This code was based on : https://github.com/OpenZeppelin/zeppelin-solidity.
361 pragma solidity ^0.4.15;
362 
363 
364 
365 
366 
367 
368 /**
369  * @title TokenVesting
370  * @dev A token holder contract that can release its token balance gradually like a
371  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
372  * owner.
373  */
374 contract TokenVesting is Ownable {
375   using SafeMath for uint256;
376   using SafeERC20 for ERC20Basic;
377 
378   event KYCValid(address beneficiary);
379   event Released(uint256 amount);
380   event Revoked();
381 
382   // beneficiary of tokens after they are released
383   address public beneficiary;
384 
385   uint256 public cliff;
386   uint256 public start;
387   uint256 public duration;
388 
389   bool public revocable;
390 
391   // KYC valid
392   bool public kycValid = false;
393 
394   mapping (address => uint256) public released;
395   mapping (address => bool) public revoked;
396 
397   /**
398    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
399    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
400    * of the balance will have vested.
401    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
402    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
403    * @param _duration duration in seconds of the period in which the tokens will vest
404    * @param _revocable whether the vesting is revocable or not
405    */
406   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
407     require(_beneficiary != address(0));
408     require(_cliff <= _duration);
409 
410     beneficiary = _beneficiary;
411     revocable = _revocable;
412     duration = _duration;
413     cliff = _start.add(_cliff);
414     start = _start;
415   }
416 
417   /**
418    * @notice Transfers vested tokens to beneficiary.
419    * @param token ERC20 token which is being vested
420    */
421   function release(ERC20Basic token) public {
422     require(kycValid);
423     uint256 unreleased = releasableAmount(token);
424 
425     require(unreleased > 0);
426 
427     released[token] = released[token].add(unreleased);
428 
429     token.safeTransfer(beneficiary, unreleased);
430 
431     Released(unreleased);
432   }
433 
434   /**
435    * @notice Allows the owner to revoke the vesting. Tokens already vested
436    * remain in the contract, the rest are returned to the owner.
437    * @param token ERC20 token which is being vested
438    */
439   function revoke(ERC20Basic token) public onlyOwner {
440     require(revocable);
441     require(!revoked[token]);
442 
443     uint256 balance = token.balanceOf(this);
444 
445     uint256 unreleased = releasableAmount(token);
446     uint256 refund = balance.sub(unreleased);
447 
448     revoked[token] = true;
449 
450     token.safeTransfer(owner, refund);
451 
452     Revoked();
453   }
454 
455   /**
456    * @dev Calculates the amount that has already vested but hasn't been released yet.
457    * @param token ERC20 token which is being vested
458    */
459   function releasableAmount(ERC20Basic token) public returns (uint256) {
460     return vestedAmount(token).sub(released[token]);
461   }
462 
463   /**
464    * @dev Calculates the amount that has already vested.
465    * @param token ERC20 token which is being vested
466    */
467   function vestedAmount(ERC20Basic token) public returns (uint256) {
468     uint256 currentBalance = token.balanceOf(this);
469     uint256 totalBalance = currentBalance.add(released[token]);
470 
471     if (now < cliff) {
472       return 0;
473     } else if (now >= start.add(duration) || revoked[token]) {
474       return totalBalance;
475     } else {
476       return totalBalance.mul(now.sub(start)).div(duration);
477     }
478   }
479 
480   function setValidKYC() onlyOwner public returns (bool) {
481     kycValid = true;
482     KYCValid(beneficiary);
483     return true;
484   }
485 }
486 
487 // File: contracts/TutellusVestingFactory.sol
488 
489 contract TutellusVestingFactory is Authorizable {
490     event VestingCreated(address indexed contractAddress, address indexed vestingAddress, address indexed wallet, uint256 startTime, uint256 cliff, uint256 duration);
491     event VestingKYCSetted(address indexed wallet, uint256 count);
492     event VestingReleased(address indexed wallet, uint256 count);
493 
494     mapping(address => mapping(address => address)) vestingsContracts;
495     address[] contracts;
496 
497     TutellusToken token;
498 
499     function TutellusVestingFactory(
500         address _token
501     ) public 
502     {
503         require(_token != address(0));
504         
505         token = TutellusToken(_token);
506     }
507 
508     function authorize(address _address) onlyOwner public {
509         super.authorize(_address);
510         contracts.push(_address);
511     }
512 
513     function getVesting(address _address) authorized public constant returns(address) {
514         require(_address != address(0));
515         return vestingsContracts[msg.sender][_address];
516     }
517 
518     function getVestingFromContract(address _contract, address _address) authorized public constant returns(address) {
519         require(_address != address(0));
520         require(_contract != address(0));
521         return vestingsContracts[_contract][_address];
522     }
523 
524     function createVesting(address _address, uint256 startTime, uint256 cliff, uint256 duration) authorized public {
525         address vestingAddress = getVesting(_address);
526         // check, if not have already one
527         if (vestingAddress == address(0)) {
528             // generate the vesting contract
529             vestingAddress = new TokenVesting(_address, startTime, cliff, duration, true);
530             VestingCreated(msg.sender, vestingAddress, _address, startTime, cliff, duration);
531             // saving for reuse
532             vestingsContracts[msg.sender][_address] = vestingAddress;
533         }
534     }
535 
536     function setValidKYC(address _address) authorized public returns(uint256) {
537         uint256 count = 0;
538         for (uint256 c = 0; c < contracts.length; c ++) {
539             address contractAddress = contracts[c];
540             address vestingAddress = vestingsContracts[contractAddress][_address];
541             if (vestingAddress != address(0)) {
542                 TokenVesting(vestingAddress).setValidKYC();
543                 count += 1;
544             }
545         }
546         VestingKYCSetted(_address, count);
547         return count;
548     }
549 
550     function release(address _address) authorized public returns(uint256) {
551         uint256 count = 0;
552         for (uint256 c = 0; c < contracts.length; c ++) {
553             address contractAddress = contracts[c];
554             address vestingAddress = vestingsContracts[contractAddress][_address];
555             if (vestingAddress != address(0)) {
556                 TokenVesting(vestingAddress).release(token);
557                 count += 1;
558             }
559         }
560         VestingReleased(_address, count);
561         return count;
562     }
563 }
564 
565 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
566 
567 /**
568  * @title Crowdsale
569  * @dev Crowdsale is a base contract for managing a token crowdsale.
570  * Crowdsales have a start and end timestamps, where investors can make
571  * token purchases and the crowdsale will assign them tokens based
572  * on a token per ETH rate. Funds collected are forwarded to a wallet
573  * as they arrive.
574  */
575 contract Crowdsale {
576   using SafeMath for uint256;
577 
578   // The token being sold
579   MintableToken public token;
580 
581   // start and end timestamps where investments are allowed (both inclusive)
582   uint256 public startTime;
583   uint256 public endTime;
584 
585   // address where funds are collected
586   address public wallet;
587 
588   // how many token units a buyer gets per wei
589   uint256 public rate;
590 
591   // amount of raised money in wei
592   uint256 public weiRaised;
593 
594   /**
595    * event for token purchase logging
596    * @param purchaser who paid for the tokens
597    * @param beneficiary who got the tokens
598    * @param value weis paid for purchase
599    * @param amount amount of tokens purchased
600    */
601   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
602 
603 
604   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
605     require(_startTime >= now);
606     require(_endTime >= _startTime);
607     require(_rate > 0);
608     require(_wallet != 0x0);
609 
610     token = createTokenContract();
611     startTime = _startTime;
612     endTime = _endTime;
613     rate = _rate;
614     wallet = _wallet;
615   }
616 
617   // creates the token to be sold.
618   // override this method to have crowdsale of a specific mintable token.
619   function createTokenContract() internal returns (MintableToken) {
620     return new MintableToken();
621   }
622 
623 
624   // fallback function can be used to buy tokens
625   function () payable {
626     buyTokens(msg.sender);
627   }
628 
629   // low level token purchase function
630   function buyTokens(address beneficiary) public payable {
631     require(beneficiary != 0x0);
632     require(validPurchase());
633 
634     uint256 weiAmount = msg.value;
635 
636     // calculate token amount to be created
637     uint256 tokens = weiAmount.mul(rate);
638 
639     // update state
640     weiRaised = weiRaised.add(weiAmount);
641 
642     token.mint(beneficiary, tokens);
643     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
644 
645     forwardFunds();
646   }
647 
648   // send ether to the fund collection wallet
649   // override to create custom fund forwarding mechanisms
650   function forwardFunds() internal {
651     wallet.transfer(msg.value);
652   }
653 
654   // @return true if the transaction can buy tokens
655   function validPurchase() internal constant returns (bool) {
656     bool withinPeriod = now >= startTime && now <= endTime;
657     bool nonZeroPurchase = msg.value != 0;
658     return withinPeriod && nonZeroPurchase;
659   }
660 
661   // @return true if crowdsale event has ended
662   function hasEnded() public constant returns (bool) {
663     return now > endTime;
664   }
665 
666 
667 }
668 
669 // File: zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol
670 
671 /**
672  * @title CappedCrowdsale
673  * @dev Extension of Crowdsale with a max amount of funds raised
674  */
675 contract CappedCrowdsale is Crowdsale {
676   using SafeMath for uint256;
677 
678   uint256 public cap;
679 
680   function CappedCrowdsale(uint256 _cap) {
681     require(_cap > 0);
682     cap = _cap;
683   }
684 
685   // overriding Crowdsale#validPurchase to add extra cap logic
686   // @return true if investors can buy at the moment
687   function validPurchase() internal constant returns (bool) {
688     bool withinCap = weiRaised.add(msg.value) <= cap;
689     return super.validPurchase() && withinCap;
690   }
691 
692   // overriding Crowdsale#hasEnded to add cap logic
693   // @return true if crowdsale event has ended
694   function hasEnded() public constant returns (bool) {
695     bool capReached = weiRaised >= cap;
696     return super.hasEnded() || capReached;
697   }
698 
699 }
700 
701 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
702 
703 /**
704  * @title Pausable
705  * @dev Base contract which allows children to implement an emergency stop mechanism.
706  */
707 contract Pausable is Ownable {
708   event Pause();
709   event Unpause();
710 
711   bool public paused = false;
712 
713 
714   /**
715    * @dev Modifier to make a function callable only when the contract is not paused.
716    */
717   modifier whenNotPaused() {
718     require(!paused);
719     _;
720   }
721 
722   /**
723    * @dev Modifier to make a function callable only when the contract is paused.
724    */
725   modifier whenPaused() {
726     require(paused);
727     _;
728   }
729 
730   /**
731    * @dev called by the owner to pause, triggers stopped state
732    */
733   function pause() onlyOwner whenNotPaused public {
734     paused = true;
735     Pause();
736   }
737 
738   /**
739    * @dev called by the owner to unpause, returns to normal state
740    */
741   function unpause() onlyOwner whenPaused public {
742     paused = false;
743     Unpause();
744   }
745 }
746 
747 // File: contracts/TutellusPartnerCrowdsale.sol
748 
749 /**
750  * @title TutellusPartnerCrowdsale
751  *
752  */
753 contract TutellusPartnerCrowdsale is CappedCrowdsale, Pausable {
754     event Withdrawal(address indexed beneficiary, uint256 amount);
755 
756     address public partner;   //Partner Address.
757     uint256 cliff;
758     uint256 duration;
759     uint256 percent;
760 
761     TutellusVault vault;
762     TutellusVestingFactory vestingFactory;
763 
764     function TutellusPartnerCrowdsale(
765         uint256 _startTime,
766         uint256 _endTime,
767         uint256 _cap, 
768         uint256 _cliff,
769         uint256 _duration,
770         uint256 _rate,
771         address _wallet,
772         address _partner,
773         uint256 _percent,
774         address _tutellusVault,
775         address _tutellusVestingFactory
776     )
777         CappedCrowdsale(_cap)
778         Crowdsale(_startTime, _endTime, _rate, _wallet)
779     {
780         require(_partner != address(0));
781         require(_tutellusVault != address(0));
782         require(_tutellusVestingFactory != address(0));
783         require(_cliff <= _duration);
784         require(_percent >= 0 && _percent <= 100);
785 
786         vault = TutellusVault(_tutellusVault);
787         token = MintableToken(vault.token());
788 
789         vestingFactory = TutellusVestingFactory(_tutellusVestingFactory);
790 
791         partner = _partner;
792         cliff = _cliff;
793         duration = _duration;
794         percent = _percent;
795     }
796 
797     function buyTokens(address beneficiary) whenNotPaused public payable {
798         require(beneficiary != address(0));
799         require(validPurchase());
800 
801         uint256 weiAmount = msg.value;
802 
803         // calculate token amount to be created
804         uint256 tokens = weiAmount.mul(rate);
805 
806         // update state
807         weiRaised = weiRaised.add(weiAmount);
808 
809         vestingFactory.createVesting(beneficiary, endTime, cliff, duration);
810         address vestingAddress = vestingFactory.getVesting(beneficiary);
811 
812         vault.mint(vestingAddress, tokens);
813         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
814 
815         forwardFunds();
816     }
817 
818     function forwardFunds() internal {
819         //We transfer the corresponding part, the rest remains in the contract
820         uint256 walletAmount = msg.value.mul(100 - percent).div(100);
821         wallet.transfer(walletAmount);
822     }
823 
824     function createTokenContract() internal returns (MintableToken) {}
825 
826     function withdraw() public {
827         require(hasEnded());
828         uint256 amount = this.balance;
829         if (amount > 0) {
830             partner.transfer(amount);
831             Withdrawal(msg.sender, amount);
832         }
833     }
834 }