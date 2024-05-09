1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
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
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract BasicToken is ERC20Basic {
88   using SafeMath for uint256;
89 
90   mapping(address => uint256) balances;
91 
92   uint256 totalSupply_;
93 
94   /**
95   * @dev total number of tokens in existence
96   */
97   function totalSupply() public view returns (uint256) {
98     return totalSupply_;
99   }
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) public returns (bool) {
107     require(_to != address(0));
108     require(_value <= balances[msg.sender]);
109 
110     // SafeMath.sub will throw if there is not enough balance.
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256 balance) {
123     return balances[_owner];
124   }
125 
126 }
127 
128 contract BurnableToken is BasicToken {
129 
130   event Burn(address indexed burner, uint256 value);
131 
132   /**
133    * @dev Burns a specific amount of tokens.
134    * @param _value The amount of token to be burned.
135    */
136   function burn(uint256 _value) public {
137     require(_value <= balances[msg.sender]);
138     // no need to require value <= totalSupply, since that would imply the
139     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
140 
141     address burner = msg.sender;
142     balances[burner] = balances[burner].sub(_value);
143     totalSupply_ = totalSupply_.sub(_value);
144     Burn(burner, _value);
145   }
146 }
147 
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) public view returns (uint256);
150   function transferFrom(address from, address to, uint256 value) public returns (bool);
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 library SafeERC20 {
156   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
157     assert(token.transfer(to, value));
158   }
159 
160   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
161     assert(token.transferFrom(from, to, value));
162   }
163 
164   function safeApprove(ERC20 token, address spender, uint256 value) internal {
165     assert(token.approve(spender, value));
166   }
167 }
168 
169 contract StandardToken is ERC20, BasicToken {
170 
171   mapping (address => mapping (address => uint256)) internal allowed;
172 
173 
174   /**
175    * @dev Transfer tokens from one address to another
176    * @param _from address The address which you want to send tokens from
177    * @param _to address The address which you want to transfer to
178    * @param _value uint256 the amount of tokens to be transferred
179    */
180   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
181     require(_to != address(0));
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184 
185     balances[_from] = balances[_from].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     Transfer(_from, _to, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    *
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(address _owner, address _spender) public view returns (uint256) {
215     return allowed[_owner][_spender];
216   }
217 
218   /**
219    * @dev Increase the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To increment
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _addedValue The amount of tokens to increase the allowance by.
227    */
228   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
229     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
230     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231     return true;
232   }
233 
234   /**
235    * @dev Decrease the amount of tokens that an owner allowed to a spender.
236    *
237    * approve should be called when allowed[_spender] == 0. To decrement
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
245     uint oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 contract TokenVesting is Ownable {
258   using SafeMath for uint256;
259   using SafeERC20 for ERC20Basic;
260 
261   event Released(uint256 amount);
262   event Revoked();
263 
264   // beneficiary of tokens after they are released
265   address public beneficiary;
266 
267   uint256 public cliff;
268   uint256 public start;
269   uint256 public duration;
270 
271   bool public revocable;
272 
273   mapping (address => uint256) public released;
274   mapping (address => bool) public revoked;
275 
276   /**
277    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
278    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
279    * of the balance will have vested.
280    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
281    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
282    * @param _duration duration in seconds of the period in which the tokens will vest
283    * @param _revocable whether the vesting is revocable or not
284    */
285   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
286     require(_beneficiary != address(0));
287     require(_cliff <= _duration);
288 
289     beneficiary = _beneficiary;
290     revocable = _revocable;
291     duration = _duration;
292     cliff = _start.add(_cliff);
293     start = _start;
294   }
295 
296   /**
297    * @notice Transfers vested tokens to beneficiary.
298    * @param token ERC20 token which is being vested
299    */
300   function release(ERC20Basic token) public {
301     uint256 unreleased = releasableAmount(token);
302 
303     require(unreleased > 0);
304 
305     released[token] = released[token].add(unreleased);
306 
307     token.safeTransfer(beneficiary, unreleased);
308 
309     Released(unreleased);
310   }
311 
312   /**
313    * @notice Allows the owner to revoke the vesting. Tokens already vested
314    * remain in the contract, the rest are returned to the owner.
315    * @param token ERC20 token which is being vested
316    */
317   function revoke(ERC20Basic token) public onlyOwner {
318     require(revocable);
319     require(!revoked[token]);
320 
321     uint256 balance = token.balanceOf(this);
322 
323     uint256 unreleased = releasableAmount(token);
324     uint256 refund = balance.sub(unreleased);
325 
326     revoked[token] = true;
327 
328     token.safeTransfer(owner, refund);
329 
330     Revoked();
331   }
332 
333   /**
334    * @dev Calculates the amount that has already vested but hasn't been released yet.
335    * @param token ERC20 token which is being vested
336    */
337   function releasableAmount(ERC20Basic token) public view returns (uint256) {
338     return vestedAmount(token).sub(released[token]);
339   }
340 
341   /**
342    * @dev Calculates the amount that has already vested.
343    * @param token ERC20 token which is being vested
344    */
345   function vestedAmount(ERC20Basic token) public view returns (uint256) {
346     uint256 currentBalance = token.balanceOf(this);
347     uint256 totalBalance = currentBalance.add(released[token]);
348 
349     if (now < cliff) {
350       return 0;
351     } else if (now >= start.add(duration) || revoked[token]) {
352       return totalBalance;
353     } else {
354       return totalBalance.mul(now.sub(start)).div(duration);
355     }
356   }
357 }
358 
359 contract MintableToken is StandardToken, Ownable {
360   event Mint(address indexed to, uint256 amount);
361   event MintFinished();
362 
363   bool public mintingFinished = false;
364 
365 
366   modifier canMint() {
367     require(!mintingFinished);
368     _;
369   }
370 
371   /**
372    * @dev Function to stop minting new tokens.
373    * @return True if the operation was successful.
374    */
375   function finishMinting() onlyOwner canMint public returns (bool) {
376     mintingFinished = true;
377     MintFinished();
378     return true;
379   }
380 
381   /**
382    * @dev Function to mint tokens
383    * @param _to The address that will receive the minted tokens.
384    * @param _amount The amount of tokens to mint.
385    * @return A boolean that indicates if the operation was successful.
386    */
387   function mint(address _to, uint256 _amount) onlyOwner canMint internal returns (bool) {
388     totalSupply_ = totalSupply_.add(_amount);
389     balances[_to] = balances[_to].add(_amount);
390     Mint(_to, _amount);
391     Transfer(address(0), _to, _amount);
392     return true;
393   }
394 }
395 
396 contract SafePayloadChecker {
397   modifier onlyPayloadSize(uint size) {
398     assert(msg.data.length == size + 4);
399     _;
400   }
401 }
402 
403 contract PATH is MintableToken, BurnableToken, SafePayloadChecker {
404   /**
405    * @dev the original supply, for posterity, since totalSupply will decrement on burn
406    */
407   uint256 public initialSupply = 400000000 * (10 ** uint256(decimals));
408 
409   /**
410    * ERC20 Identification Functions
411    */
412   string public constant name    = "PATH Token"; // solium-disable-line uppercase
413   string public constant symbol  = "PATH"; // solium-disable-line uppercase
414   uint8 public constant decimals = 18; // solium-disable-line uppercase
415 
416   /**
417    * @dev the time at which token holders can begin transferring tokens
418    */
419   uint256 public transferableStartTime;
420 
421   address privatePresaleWallet;
422   address publicPresaleContract;
423   address publicCrowdsaleContract;
424   address pathTeamMultisig;
425   TokenVesting public founderTokenVesting;
426 
427   /**
428    * @dev the token sale contract(s) and team can move tokens
429    * @dev   before the lockup expires
430    */
431   modifier onlyWhenTransferEnabled()
432   {
433     if (now <= transferableStartTime) {
434       require(
435         msg.sender == privatePresaleWallet || // solium-disable-line operator-whitespace
436         msg.sender == publicPresaleContract || // solium-disable-line operator-whitespace
437         msg.sender == publicCrowdsaleContract || // solium-disable-line operator-whitespace
438         msg.sender == pathTeamMultisig
439       );
440     }
441     _;
442   }
443 
444   /**
445    * @dev require that this contract cannot affect itself
446    */
447   modifier validDestination(address _addr)
448   {
449     require(_addr != address(this));
450     _;
451   }
452 
453   /**
454    * @dev Constructor
455    */
456   function PATH(uint256 _transferableStartTime)
457     public
458   {
459     transferableStartTime = _transferableStartTime;
460   }
461 
462   /**
463    * @dev override transfer token for a specified address to add validDestination
464    * @param _to The address to transfer to.
465    * @param _value The amount to be transferred.
466    */
467   function transfer(address _to, uint256 _value)
468     onlyPayloadSize(32 + 32) // address (32) + uint256 (32)
469     validDestination(_to)
470     onlyWhenTransferEnabled
471     public
472     returns (bool)
473   {
474     return super.transfer(_to, _value);
475   }
476 
477   /**
478    * @dev override transferFrom token for a specified address to add validDestination
479    * @param _from The address to transfer from.
480    * @param _to The address to transfer to.
481    * @param _value The amount to be transferred.
482    */
483   function transferFrom(address _from, address _to, uint256 _value)
484     onlyPayloadSize(32 + 32 + 32) // address (32) + address (32) + uint256 (32)
485     validDestination(_to)
486     onlyWhenTransferEnabled
487     public
488     returns (bool)
489   {
490     return super.transferFrom(_from, _to, _value);
491   }
492 
493   /**
494    * @dev burn tokens, but also include a Transfer(sender, 0x0, value) event
495    * @param _value The amount to be burned.
496    */
497   function burn(uint256 _value)
498     onlyWhenTransferEnabled
499     public
500   {
501     super.burn(_value);
502   }
503 
504   /**
505    * @dev burn tokens on behalf of someone
506    * @param _from The address of the owner of the token.
507    * @param _value The amount to be burned.
508    */
509   function burnFrom(address _from, uint256 _value)
510     onlyPayloadSize(32 + 32) // address (32) + uint256 (32)
511     onlyWhenTransferEnabled
512     public
513   {
514     // require(_value <= allowed[_from][msg.sender]);
515     require(_value <= balances[_from]);
516 
517     balances[_from] = balances[_from].sub(_value);
518     totalSupply_ = totalSupply_.sub(_value);
519     Burn(_from, _value);
520     Transfer(_from, address(0), _value);
521   }
522 
523   /**
524    * @dev override approval functions to include safe payload checking
525    */
526   function approve(address _spender, uint256 _value)
527     onlyPayloadSize(32 + 32) // address (32) + uint256 (32)
528     public
529     returns (bool)
530   {
531     return super.approve(_spender, _value);
532   }
533 
534   function increaseApproval(address _spender, uint256 _addedValue)
535     onlyPayloadSize(32 + 32) // address (32) + uint256 (32)
536     public
537     returns (bool)
538   {
539     return super.increaseApproval(_spender, _addedValue);
540   }
541 
542   function decreaseApproval(address _spender, uint256 _subtractedValue)
543     onlyPayloadSize(32 + 32) // address (32) + uint256 (32)
544     public
545     returns (bool)
546   {
547     return super.decreaseApproval(_spender, _subtractedValue);
548   }
549 
550 
551   /**
552    * @dev distribute the tokens once the crowdsale addresses are known
553    * @dev only callable once and disables minting at the end
554    */
555   function distributeTokens(
556     address _privatePresaleWallet,
557     address _publicPresaleContract,
558     address _publicCrowdsaleContract,
559     address _pathCompanyMultisig,
560     address _pathAdvisorVault,
561     address _pathFounderAddress
562   )
563     onlyOwner
564     canMint
565     external
566   {
567     // Set addresses
568     privatePresaleWallet = _privatePresaleWallet;
569     publicPresaleContract = _publicPresaleContract;
570     publicCrowdsaleContract = _publicCrowdsaleContract;
571     pathTeamMultisig = _pathCompanyMultisig;
572 
573     // Mint all tokens according to the established allocations
574     mint(_privatePresaleWallet, 200000000 * (10 ** uint256(decimals)));
575     // ^ 50%
576     mint(_publicPresaleContract, 32000000 * (10 ** uint256(decimals)));
577     // ^ 8%
578     mint(_publicCrowdsaleContract, 8000000 * (10 ** uint256(decimals)));
579     // ^ 2%
580     mint(_pathCompanyMultisig, 80000000 * (10 ** uint256(decimals)));
581     // ^ 20%
582     mint(_pathAdvisorVault, 40000000 * (10 ** uint256(decimals)));
583     // ^ 10%
584 
585     // deploy a token vesting contract for the founder tokens
586     uint256 cliff = 6 * 4 weeks; // 4 months
587     founderTokenVesting = new TokenVesting(
588       _pathFounderAddress,
589       now,   // start vesting now
590       cliff, // cliff time
591       cliff, // 100% unlocked at cliff
592       false  // irrevocable
593     );
594     // and then mint tokens to the vesting contract
595     mint(address(founderTokenVesting), 40000000 * (10 ** uint256(decimals)));
596     // ^ 10%
597 
598     // immediately finish minting
599     finishMinting();
600 
601     assert(totalSupply_ == initialSupply);
602   }
603 }
604 
605 contract StandardCrowdsale {
606   using SafeMath for uint256;
607 
608   // The token being sold
609   PATH public token;  // Path Modification
610 
611   // start and end timestamps where investments are allowed (both inclusive)
612   uint256 public startTime;
613   uint256 public endTime;
614 
615   // address where funds are collected
616   address public wallet;
617 
618   // how many token units a buyer gets per wei
619   uint256 public rate;
620 
621   // amount of raised money in wei
622   uint256 public weiRaised;
623 
624   /**
625    * event for token purchase logging
626    * @param purchaser who paid for the tokens
627    * @param beneficiary who got the tokens
628    * @param value weis paid for purchase
629    * @param amount amount of tokens purchased
630    */
631   event TokenPurchase(
632     address indexed purchaser,
633     address indexed beneficiary,
634     uint256 value,
635     uint256 amount
636   );
637 
638   function StandardCrowdsale(
639     uint256 _startTime,
640     uint256 _endTime,
641     uint256 _rate,
642     address _wallet,
643     PATH _token
644   )
645     public
646   {
647     require(_startTime >= now);
648     require(_endTime >= _startTime);
649     require(_rate > 0);
650     require(_wallet != address(0));
651     require(_token != address(0));
652 
653     startTime = _startTime;
654     endTime = _endTime;
655     rate = _rate;
656     wallet = _wallet;
657     token = _token;
658   }
659 
660   // fallback function can be used to buy tokens
661   function () external payable {
662     buyTokens(msg.sender);
663   }
664 
665   // low level token purchase function
666   function buyTokens(address beneficiary) public payable {
667     require(beneficiary != address(0));
668     require(validPurchase());
669 
670     uint256 weiAmount = msg.value;
671 
672     // calculate token amount to be created
673     uint256 tokens = getTokenAmount(weiAmount);
674 
675     // update state
676     weiRaised = weiRaised.add(weiAmount);
677 
678     require(token.transfer(beneficiary, tokens)); // PATH Modification
679 
680     TokenPurchase(
681       msg.sender,
682       beneficiary,
683       weiAmount,
684       tokens
685     );
686 
687     forwardFunds();
688   }
689 
690   // @return true if crowdsale event has ended
691   function hasEnded() public view returns (bool) {
692     return now > endTime;
693   }
694 
695   // Override this method to have a way to add business logic to your crowdsale when buying
696   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
697     return weiAmount.mul(rate);
698   }
699 
700   // send ether to the fund collection wallet
701   // override to create custom fund forwarding mechanisms
702   function forwardFunds() internal {
703     wallet.transfer(msg.value);
704   }
705 
706   // @return true if the transaction can buy tokens
707   function validPurchase() internal view returns (bool) {
708     bool withinPeriod = now >= startTime && now <= endTime;
709     bool nonZeroPurchase = msg.value != 0;
710     return withinPeriod && nonZeroPurchase;
711   }
712 }
713 
714 contract FinalizableCrowdsale is StandardCrowdsale, Ownable {
715   using SafeMath for uint256;
716 
717   bool public isFinalized = false;
718 
719   event Finalized();
720 
721   /**
722    * @dev Must be called after crowdsale ends, to do some extra finalization
723    * work. Calls the contract's finalization function.
724    */
725   function finalize() public {
726     require(!isFinalized);
727     require(hasEnded());
728 
729     finalization();
730     Finalized();
731 
732     isFinalized = true;
733   }
734 
735   /**
736    * @dev Can be overridden to add finalization logic. The overriding function
737    * should call super.finalization() to ensure the chain of finalization is
738    * executed entirely.
739    */
740   function finalization() internal {
741   }
742 
743 }
744 
745 contract BurnableCrowdsale is FinalizableCrowdsale {
746   /**
747    * @dev Burns any tokens held by this address.
748    */
749   function finalization() internal {
750     token.burn(token.balanceOf(address(this)));
751     super.finalization();
752   }
753 }
754 
755 contract RateConfigurable is StandardCrowdsale, Ownable {
756 
757   modifier onlyBeforeStart() {
758     require(now < startTime);
759     _;
760   }
761 
762   /**
763    * @dev allow the owner to update the rate before the crowdsale starts
764    * @dev in order to account for ether valuation fluctuation
765    */
766   function updateRate(uint256 _rate)
767     onlyOwner
768     onlyBeforeStart
769     external
770   {
771     rate = _rate;
772   }
773 }
774 
775 contract ReallocatableCrowdsale is StandardCrowdsale, Ownable {
776 
777   /**
778    * @dev reallocate funds from this crowdsale to another
779    */
780   function reallocate(uint256 _value)
781     external
782     onlyOwner
783   {
784     require(!hasEnded());
785     reallocation(_value);
786   }
787 
788   /**
789    * @dev perform the actual reallocation
790    * @dev must be overridden to do anything
791    */
792   function reallocation(uint256 _value)
793     internal
794   {
795   }
796 }
797 
798 contract WhitelistedCrowdsale is StandardCrowdsale, Ownable {
799 
800   mapping(address=>bool) public registered;
801 
802   event RegistrationStatusChanged(address target, bool isRegistered);
803 
804   /**
805     * @dev Changes registration status of an address for participation.
806     * @param target Address that will be registered/deregistered.
807     * @param isRegistered New registration status of address.
808     */
809   function changeRegistrationStatus(address target, bool isRegistered)
810     public
811     onlyOwner
812   {
813     registered[target] = isRegistered;
814     RegistrationStatusChanged(target, isRegistered);
815   }
816 
817   /**
818     * @dev Changes registration statuses of addresses for participation.
819     * @param targets Addresses that will be registered/deregistered.
820     * @param isRegistered New registration status of addresses.
821     */
822   function changeRegistrationStatuses(address[] targets, bool isRegistered)
823     public
824     onlyOwner
825   {
826     for (uint i = 0; i < targets.length; i++) {
827       changeRegistrationStatus(targets[i], isRegistered);
828     }
829   }
830 
831   /**
832     * @dev overriding Crowdsale#validPurchase to add whilelist
833     * @return true if investors can buy at the moment, false otherwise
834     */
835   function validPurchase() internal view returns (bool) {
836     return super.validPurchase() && registered[msg.sender];
837   }
838 }
839 
840 contract PathPublicPresale is RateConfigurable, WhitelistedCrowdsale, BurnableCrowdsale, ReallocatableCrowdsale {
841 
842   address public privatePresaleWallet;
843 
844   function PathPublicPresale (
845     uint256 _startTime,
846     uint256 _endTime,
847     uint256 _rate,
848     address _wallet,
849     PATH _token,
850     address _privatePresaleWallet
851   )
852     WhitelistedCrowdsale()
853     BurnableCrowdsale()
854     StandardCrowdsale(_startTime, _endTime, _rate, _wallet, _token)
855     public
856   {
857     privatePresaleWallet = _privatePresaleWallet;
858   }
859 
860   function reallocation(uint256 _value)
861     internal
862   {
863     require(token.transfer(privatePresaleWallet, _value));
864   }
865 }