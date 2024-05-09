1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   function totalSupply() public view returns (uint256);
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
131 
132 /**
133  * @title Basic token
134  * @dev Basic version of StandardToken, with no allowances.
135  */
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   uint256 totalSupply_;
142 
143   /**
144   * @dev total number of tokens in existence
145   */
146   function totalSupply() public view returns (uint256) {
147     return totalSupply_;
148   }
149 
150   /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[msg.sender]);
158 
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     emit Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
177 
178 /**
179  * @title ERC20 interface
180  * @dev see https://github.com/ethereum/EIPs/issues/20
181  */
182 contract ERC20 is ERC20Basic {
183   function allowance(address owner, address spender)
184     public view returns (uint256);
185 
186   function transferFrom(address from, address to, uint256 value)
187     public returns (bool);
188 
189   function approve(address spender, uint256 value) public returns (bool);
190   event Approval(
191     address indexed owner,
192     address indexed spender,
193     uint256 value
194   );
195 }
196 
197 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * @dev https://github.com/ethereum/EIPs/issues/20
204  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20, BasicToken {
207 
208   mapping (address => mapping (address => uint256)) internal allowed;
209 
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(
218     address _from,
219     address _to,
220     uint256 _value
221   )
222     public
223     returns (bool)
224   {
225     require(_to != address(0));
226     require(_value <= balances[_from]);
227     require(_value <= allowed[_from][msg.sender]);
228 
229     balances[_from] = balances[_from].sub(_value);
230     balances[_to] = balances[_to].add(_value);
231     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232     emit Transfer(_from, _to, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238    *
239    * Beware that changing an allowance with this method brings the risk that someone may use both the old
240    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
241    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
242    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243    * @param _spender The address which will spend the funds.
244    * @param _value The amount of tokens to be spent.
245    */
246   function approve(address _spender, uint256 _value) public returns (bool) {
247     allowed[msg.sender][_spender] = _value;
248     emit Approval(msg.sender, _spender, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Function to check the amount of tokens that an owner allowed to a spender.
254    * @param _owner address The address which owns the funds.
255    * @param _spender address The address which will spend the funds.
256    * @return A uint256 specifying the amount of tokens still available for the spender.
257    */
258   function allowance(
259     address _owner,
260     address _spender
261    )
262     public
263     view
264     returns (uint256)
265   {
266     return allowed[_owner][_spender];
267   }
268 
269   /**
270    * @dev Increase the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _addedValue The amount of tokens to increase the allowance by.
278    */
279   function increaseApproval(
280     address _spender,
281     uint _addedValue
282   )
283     public
284     returns (bool)
285   {
286     allowed[msg.sender][_spender] = (
287       allowed[msg.sender][_spender].add(_addedValue));
288     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292   /**
293    * @dev Decrease the amount of tokens that an owner allowed to a spender.
294    *
295    * approve should be called when allowed[_spender] == 0. To decrement
296    * allowed value is better to use this function to avoid 2 calls (and wait until
297    * the first transaction is mined)
298    * From MonolithDAO Token.sol
299    * @param _spender The address which will spend the funds.
300    * @param _subtractedValue The amount of tokens to decrease the allowance by.
301    */
302   function decreaseApproval(
303     address _spender,
304     uint _subtractedValue
305   )
306     public
307     returns (bool)
308   {
309     uint oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue > oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
327  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
328  */
329 contract MintableToken is StandardToken, Ownable {
330   event Mint(address indexed to, uint256 amount);
331   event MintFinished();
332 
333   bool public mintingFinished = false;
334 
335 
336   modifier canMint() {
337     require(!mintingFinished);
338     _;
339   }
340 
341   modifier hasMintPermission() {
342     require(msg.sender == owner);
343     _;
344   }
345 
346   /**
347    * @dev Function to mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(
353     address _to,
354     uint256 _amount
355   )
356     hasMintPermission
357     canMint
358     public
359     returns (bool)
360   {
361     totalSupply_ = totalSupply_.add(_amount);
362     balances[_to] = balances[_to].add(_amount);
363     emit Mint(_to, _amount);
364     emit Transfer(address(0), _to, _amount);
365     return true;
366   }
367 
368   /**
369    * @dev Function to stop minting new tokens.
370    * @return True if the operation was successful.
371    */
372   function finishMinting() onlyOwner canMint public returns (bool) {
373     mintingFinished = true;
374     emit MintFinished();
375     return true;
376   }
377 }
378 
379 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
380 
381 /**
382  * @title Capped token
383  * @dev Mintable token with a token cap.
384  */
385 contract CappedToken is MintableToken {
386 
387   uint256 public cap;
388 
389   constructor(uint256 _cap) public {
390     require(_cap > 0);
391     cap = _cap;
392   }
393 
394   /**
395    * @dev Function to mint tokens
396    * @param _to The address that will receive the minted tokens.
397    * @param _amount The amount of tokens to mint.
398    * @return A boolean that indicates if the operation was successful.
399    */
400   function mint(
401     address _to,
402     uint256 _amount
403   )
404     onlyOwner
405     canMint
406     public
407     returns (bool)
408   {
409     require(totalSupply_.add(_amount) <= cap);
410 
411     return super.mint(_to, _amount);
412   }
413 
414 }
415 
416 // File: contracts/GambioToken.sol
417 
418 contract GambioToken is CappedToken {
419 
420 
421   using SafeMath for uint256;
422 
423   string public name = "GMB";
424   string public symbol = "GMB";
425   uint8 public decimals = 18;
426 
427   event Burn(address indexed burner, uint256 value);
428   event BurnTransferred(address indexed previousBurner, address indexed newBurner);
429 
430   address burnerRole;
431 
432   modifier onlyBurner() {
433     require(msg.sender == burnerRole);
434     _;
435   }
436 
437   constructor(address _burner, uint256 _cap) public CappedToken(_cap) {
438     burnerRole = _burner;
439   }
440 
441   function transferBurnRole(address newBurner) public onlyBurner {
442     require(newBurner != address(0));
443     emit BurnTransferred(burnerRole, newBurner);
444     burnerRole = newBurner;
445   }
446 
447   function burn(uint256 _value) public onlyBurner {
448     require(_value <= balances[msg.sender]);
449     balances[msg.sender] = balances[msg.sender].sub(_value);
450     totalSupply_ = totalSupply_.sub(_value);
451     emit Burn(msg.sender, _value);
452     emit Transfer(msg.sender, address(0), _value);
453   }
454 }
455 
456 // File: contracts/Crowdsale.sol
457 
458 contract Crowdsale {
459 
460 
461   using SafeMath for uint256;
462 
463   // The token being sold
464   GambioToken public token;
465 
466   // start and end timestamps where investments are allowed (both inclusive)
467   uint256 public startTime;
468   uint256 public endTime;
469 
470   uint256 public rate;
471 
472   // address where funds are collected
473   address public wallet;
474 
475   // amount of raised money in wei
476   uint256 public weiRaised;
477 
478   event TokenPurchase(address indexed beneficiary, uint256 indexed value, uint256 indexed amount, uint256 transactionId);
479 
480   constructor(
481     uint256 _startTime,
482     uint256 _endTime,
483     uint256 _rate,
484     address _wallet,
485     uint256 _initialWeiRaised,
486     uint256 _tokenCap) public {
487     require(_startTime >= now);
488     require(_endTime >= _startTime);
489     require(_wallet != address(0));
490     require(_rate > 0);
491     require(_tokenCap > 0);
492 
493     token = new GambioToken(_wallet, _tokenCap);
494     startTime = _startTime;
495     endTime = _endTime;
496     rate = _rate;
497     wallet = _wallet;
498     weiRaised = _initialWeiRaised;
499   }
500 
501   // @return true if crowdsale event has ended
502   function hasEnded() public view returns (bool) {
503     return now > endTime;
504   }
505 }
506 
507 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
508 
509 /**
510  * @title SafeERC20
511  * @dev Wrappers around ERC20 operations that throw on failure.
512  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
513  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
514  */
515 library SafeERC20 {
516   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
517     require(token.transfer(to, value));
518   }
519 
520   function safeTransferFrom(
521     ERC20 token,
522     address from,
523     address to,
524     uint256 value
525   )
526     internal
527   {
528     require(token.transferFrom(from, to, value));
529   }
530 
531   function safeApprove(ERC20 token, address spender, uint256 value) internal {
532     require(token.approve(spender, value));
533   }
534 }
535 
536 // File: openzeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
537 
538 /* solium-disable security/no-block-members */
539 
540 pragma solidity ^0.4.23;
541 
542 
543 
544 
545 
546 
547 /**
548  * @title TokenVesting
549  * @dev A token holder contract that can release its token balance gradually like a
550  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
551  * owner.
552  */
553 contract TokenVesting is Ownable {
554   using SafeMath for uint256;
555   using SafeERC20 for ERC20Basic;
556 
557   event Released(uint256 amount);
558   event Revoked();
559 
560   // beneficiary of tokens after they are released
561   address public beneficiary;
562 
563   uint256 public cliff;
564   uint256 public start;
565   uint256 public duration;
566 
567   bool public revocable;
568 
569   mapping (address => uint256) public released;
570   mapping (address => bool) public revoked;
571 
572   /**
573    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
574    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
575    * of the balance will have vested.
576    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
577    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
578    * @param _start the time (as Unix time) at which point vesting starts 
579    * @param _duration duration in seconds of the period in which the tokens will vest
580    * @param _revocable whether the vesting is revocable or not
581    */
582   constructor(
583     address _beneficiary,
584     uint256 _start,
585     uint256 _cliff,
586     uint256 _duration,
587     bool _revocable
588   )
589     public
590   {
591     require(_beneficiary != address(0));
592     require(_cliff <= _duration);
593 
594     beneficiary = _beneficiary;
595     revocable = _revocable;
596     duration = _duration;
597     cliff = _start.add(_cliff);
598     start = _start;
599   }
600 
601   /**
602    * @notice Transfers vested tokens to beneficiary.
603    * @param token ERC20 token which is being vested
604    */
605   function release(ERC20Basic token) public {
606     uint256 unreleased = releasableAmount(token);
607 
608     require(unreleased > 0);
609 
610     released[token] = released[token].add(unreleased);
611 
612     token.safeTransfer(beneficiary, unreleased);
613 
614     emit Released(unreleased);
615   }
616 
617   /**
618    * @notice Allows the owner to revoke the vesting. Tokens already vested
619    * remain in the contract, the rest are returned to the owner.
620    * @param token ERC20 token which is being vested
621    */
622   function revoke(ERC20Basic token) public onlyOwner {
623     require(revocable);
624     require(!revoked[token]);
625 
626     uint256 balance = token.balanceOf(this);
627 
628     uint256 unreleased = releasableAmount(token);
629     uint256 refund = balance.sub(unreleased);
630 
631     revoked[token] = true;
632 
633     token.safeTransfer(owner, refund);
634 
635     emit Revoked();
636   }
637 
638   /**
639    * @dev Calculates the amount that has already vested but hasn't been released yet.
640    * @param token ERC20 token which is being vested
641    */
642   function releasableAmount(ERC20Basic token) public view returns (uint256) {
643     return vestedAmount(token).sub(released[token]);
644   }
645 
646   /**
647    * @dev Calculates the amount that has already vested.
648    * @param token ERC20 token which is being vested
649    */
650   function vestedAmount(ERC20Basic token) public view returns (uint256) {
651     uint256 currentBalance = token.balanceOf(this);
652     uint256 totalBalance = currentBalance.add(released[token]);
653 
654     if (block.timestamp < cliff) {
655       return 0;
656     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
657       return totalBalance;
658     } else {
659       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
660     }
661   }
662 }
663 
664 // File: contracts/GambioVesting.sol
665 
666 contract GambioVesting is TokenVesting {
667 
668 
669   using SafeMath for uint256;
670 
671   uint256 public previousRelease;
672   uint256 period;
673 
674   constructor(uint256 _period, address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable)
675   public
676   TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable) {
677     //require(period > 0);
678 
679     period = _period;
680     previousRelease = now;
681   }
682 
683   //overriding release function
684   function release(ERC20Basic token) public {
685     require(now >= previousRelease.add(period));
686 
687     uint256 unreleased = releasableAmount(token);
688 
689     require(unreleased > 0);
690 
691     released[token] = released[token].add(unreleased);
692 
693     token.safeTransfer(beneficiary, unreleased);
694 
695     previousRelease = now;
696 
697     emit Released(unreleased);
698   }
699 
700 }
701 
702 // File: contracts/CappedCrowdsale.sol
703 
704 contract CappedCrowdsale is Crowdsale, Ownable {
705 
706 
707   using SafeMath for uint256;
708 
709   uint256 public hardCap;
710   bool public isFinalized = false;
711 
712   //vesting
713   uint256 public vestingTokens;
714   uint256 public vestingDuration;
715   uint256 public vestingPeriod;
716   address public vestingBeneficiary;
717   GambioVesting public vesting;
718 
719   event Finalized();
720   event FinishMinting();
721 
722   event TokensMinted(
723     address indexed beneficiary,
724     uint256 indexed amount
725   );
726 
727   constructor(uint256 _hardCap, uint256[] _vestingData, address _beneficiary)
728   public {
729 
730     require(_vestingData.length == 3);
731     require(_hardCap > 0);
732     require(_vestingData[0] > 0);
733     require(_vestingData[1] > 0);
734     require(_vestingData[2] > 0);
735     require(_beneficiary != address(0));
736 
737     hardCap = _hardCap;
738     vestingTokens = _vestingData[0];
739     vestingDuration = _vestingData[1];
740     vestingPeriod = _vestingData[2];
741     vestingBeneficiary = _beneficiary;
742   }
743 
744   /**
745      * @dev Must be called after crowdsale ends, to do some extra finalization
746      * work. Calls the contract's finalization function.
747      */
748   function finalize() public onlyOwner {
749     require(!isFinalized);
750 
751     vesting = new GambioVesting(vestingPeriod, vestingBeneficiary, now, 0, vestingDuration, false);
752 
753     token.mint(address(vesting), vestingTokens);
754 
755     emit Finalized();
756     isFinalized = true;
757   }
758 
759   function finishMinting() public onlyOwner {
760     require(token.mintingFinished() == false);
761     require(isFinalized);
762     token.finishMinting();
763 
764     emit FinishMinting();
765   }
766 
767   function mint(address beneficiary, uint256 amount) public onlyOwner {
768     require(!token.mintingFinished());
769     require(isFinalized);
770     require(amount > 0);
771     require(beneficiary != address(0));
772     token.mint(beneficiary, amount);
773 
774     emit TokensMinted(beneficiary, amount);
775   }
776 
777   // overriding Crowdsale#hasEnded to add cap logic
778   // @return true if crowdsale event has ended
779   function hasEnded() public view returns (bool) {
780     bool capReached = weiRaised >= hardCap;
781     return super.hasEnded() || capReached || isFinalized;
782   }
783 
784 }
785 
786 // File: contracts/OnlyWhiteListedAddresses.sol
787 
788 contract OnlyWhiteListedAddresses is Ownable {
789 
790 
791   using SafeMath for uint256;
792   address utilityAccount;
793   mapping(address => bool) whitelist;
794   mapping(address => address) public referrals;
795 
796   modifier onlyOwnerOrUtility() {
797     require(msg.sender == owner || msg.sender == utilityAccount);
798     _;
799   }
800 
801   event WhitelistedAddresses(
802     address[] users
803   );
804 
805   event ReferralsAdded(
806     address[] user,
807     address[] referral
808   );
809 
810   constructor(address _utilityAccount) public {
811     utilityAccount = _utilityAccount;
812   }
813 
814   function whitelistAddress(address[] users) public onlyOwnerOrUtility {
815     for (uint i = 0; i < users.length; i++) {
816       whitelist[users[i]] = true;
817     }
818     emit WhitelistedAddresses(users);
819   }
820 
821   function addAddressReferrals(address[] users, address[] _referrals) public onlyOwnerOrUtility {
822     require(users.length == _referrals.length);
823     for (uint i = 0; i < users.length; i++) {
824       require(isWhiteListedAddress(users[i]));
825 
826       referrals[users[i]] = _referrals[i];
827     }
828     emit ReferralsAdded(users, _referrals);
829   }
830 
831   function isWhiteListedAddress(address addr) public view returns (bool) {
832     return whitelist[addr];
833   }
834 }
835 
836 // File: contracts/GambioCrowdsale.sol
837 
838 contract GambioCrowdsale is CappedCrowdsale, OnlyWhiteListedAddresses {
839   using SafeMath for uint256;
840 
841   struct TokenPurchaseRecord {
842     uint256 timestamp;
843     uint256 weiAmount;
844     address beneficiary;
845   }
846 
847   uint256 transactionId = 1;
848 
849   mapping(uint256 => TokenPurchaseRecord) pendingTransactions;
850 
851   mapping(uint256 => bool) completedTransactions;
852 
853   uint256 public referralPercentage;
854 
855   uint256 public individualCap;
856 
857   /**
858    * event for token purchase logging
859    * @param transactionId transaction identifier
860    * @param beneficiary who will get the tokens
861    * @param timestamp when the token purchase request was made
862    * @param weiAmount wei invested
863    */
864   event TokenPurchaseRequest(
865     uint256 indexed transactionId,
866     address beneficiary,
867     uint256 indexed timestamp,
868     uint256 indexed weiAmount,
869     uint256 tokensAmount
870   );
871 
872   event ReferralTokensSent(
873     address indexed beneficiary,
874     uint256 indexed tokensAmount,
875     uint256 indexed transactionId
876   );
877 
878   event BonusTokensSent(
879     address indexed beneficiary,
880     uint256 indexed tokensAmount,
881     uint256 indexed transactionId
882   );
883 
884   constructor(
885     uint256 _startTime,
886     uint256 _endTime,
887     uint256 _icoHardCapWei,
888     uint256 _referralPercentage,
889     uint256 _rate,
890     address _wallet,
891     uint256 _privateWeiRaised,
892     uint256 _individualCap,
893     address _utilityAccount,
894     uint256 _tokenCap,
895     uint256[] _vestingData
896   )
897   public
898   OnlyWhiteListedAddresses(_utilityAccount)
899   CappedCrowdsale(_icoHardCapWei, _vestingData, _wallet)
900   Crowdsale(_startTime, _endTime, _rate, _wallet, _privateWeiRaised, _tokenCap)
901   {
902     referralPercentage = _referralPercentage;
903     individualCap = _individualCap;
904   }
905 
906   // fallback function can be used to buy tokens
907   function() external payable {
908     buyTokens(msg.sender);
909   }
910 
911   // low level token purchase function
912   function buyTokens(address beneficiary) public payable {
913     require(!isFinalized);
914     require(beneficiary == msg.sender);
915     require(msg.value != 0);
916     require(msg.value >= individualCap);
917 
918     uint256 weiAmount = msg.value;
919     require(isWhiteListedAddress(beneficiary));
920     require(validPurchase(weiAmount));
921 
922     // update state
923     weiRaised = weiRaised.add(weiAmount);
924 
925     uint256 _transactionId = transactionId;
926     uint256 tokensAmount = weiAmount.mul(rate);
927 
928     pendingTransactions[_transactionId] = TokenPurchaseRecord(now, weiAmount, beneficiary);
929     transactionId += 1;
930 
931 
932     emit TokenPurchaseRequest(_transactionId, beneficiary, now, weiAmount, tokensAmount);
933     forwardFunds();
934   }
935 
936   function delayIcoEnd(uint256 newDate) public onlyOwner {
937     require(newDate != 0);
938     require(newDate > now);
939     require(!hasEnded());
940     require(newDate > endTime);
941 
942     endTime = newDate;
943   }
944 
945   function increaseWeiRaised(uint256 amount) public onlyOwner {
946     require(now < startTime);
947     require(amount > 0);
948     require(weiRaised.add(amount) <= hardCap);
949 
950     weiRaised = weiRaised.add(amount);
951   }
952 
953   function decreaseWeiRaised(uint256 amount) public onlyOwner {
954     require(now < startTime);
955     require(amount > 0);
956     require(weiRaised > 0);
957     require(weiRaised >= amount);
958 
959     weiRaised = weiRaised.sub(amount);
960   }
961 
962   function issueTokensMultiple(uint256[] _transactionIds, uint256[] bonusTokensAmounts) public onlyOwner {
963     require(isFinalized);
964     require(_transactionIds.length == bonusTokensAmounts.length);
965     for (uint i = 0; i < _transactionIds.length; i++) {
966       issueTokens(_transactionIds[i], bonusTokensAmounts[i]);
967     }
968   }
969 
970   function issueTokens(uint256 _transactionId, uint256 bonusTokensAmount) internal {
971     require(completedTransactions[_transactionId] != true);
972     require(pendingTransactions[_transactionId].timestamp != 0);
973 
974     TokenPurchaseRecord memory record = pendingTransactions[_transactionId];
975     uint256 tokens = record.weiAmount.mul(rate);
976     address referralAddress = referrals[record.beneficiary];
977 
978     token.mint(record.beneficiary, tokens);
979     emit TokenPurchase(record.beneficiary, record.weiAmount, tokens, _transactionId);
980 
981     completedTransactions[_transactionId] = true;
982 
983     if (bonusTokensAmount != 0) {
984       require(bonusTokensAmount != 0);
985       token.mint(record.beneficiary, bonusTokensAmount);
986       emit BonusTokensSent(record.beneficiary, bonusTokensAmount, _transactionId);
987     }
988 
989     if (referralAddress != address(0)) {
990       uint256 referralAmount = tokens.mul(referralPercentage).div(uint256(100));
991       token.mint(referralAddress, referralAmount);
992       emit ReferralTokensSent(referralAddress, referralAmount, _transactionId);
993     }
994   }
995 
996   function validPurchase(uint256 weiAmount) internal view returns (bool) {
997     bool withinCap = weiRaised.add(weiAmount) <= hardCap;
998     bool withinCrowdsaleInterval = now >= startTime && now <= endTime;
999     return withinCrowdsaleInterval && withinCap;
1000   }
1001 
1002   function forwardFunds() internal {
1003     wallet.transfer(msg.value);
1004   }
1005 }
1006 
1007 // File: contracts/Migrations.sol
1008 
1009 contract Migrations {
1010 
1011 
1012   address public owner;
1013   uint public lastCompletedMigration;
1014 
1015   modifier restricted() {
1016     if (msg.sender == owner) _;
1017   }
1018 
1019   constructor() public {
1020     owner = msg.sender;
1021   }
1022 
1023   function setCompleted(uint completed) public restricted {
1024     lastCompletedMigration = completed;
1025   }
1026 
1027   function upgrade(address newAddress) public restricted {
1028     Migrations upgraded = Migrations(newAddress);
1029     upgraded.setCompleted(lastCompletedMigration);
1030   }
1031 }