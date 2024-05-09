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
396 contract SafePercent {
397   using SafeMath for uint256;
398 
399   function percent(uint256 numerator, uint256 denominator, uint256 precision)
400     pure
401     public
402     returns(uint256)
403   {
404     uint256 _numerator = numerator.mul(10 ** (precision + 1));
405     // we get rid of that precision + 1 by dividing by 10 here
406     //  (adding 5 first to correctly floor() the result)
407     uint256 quotient = ((_numerator.div(denominator)).add(5)).div(10);
408 
409     return (quotient);
410   }
411 }
412 
413 contract SafePayloadChecker {
414   modifier onlyPayloadSize(uint size) {
415     assert(msg.data.length == size + 4);
416     _;
417   }
418 }
419 
420 contract PATH is MintableToken, BurnableToken, SafePayloadChecker {
421   /**
422    * @dev the original supply, for posterity, since totalSupply will decrement on burn
423    */
424   uint256 public initialSupply = 400000000 * (10 ** uint256(decimals));
425 
426   /**
427    * ERC20 Identification Functions
428    */
429   string public constant name    = "PATH Token"; // solium-disable-line uppercase
430   string public constant symbol  = "PATH"; // solium-disable-line uppercase
431   uint8 public constant decimals = 18; // solium-disable-line uppercase
432 
433   /**
434    * @dev the time at which token holders can begin transferring tokens
435    */
436   uint256 public transferableStartTime;
437 
438   address privatePresaleWallet;
439   address publicPresaleContract;
440   address publicCrowdsaleContract;
441   address pathTeamMultisig;
442   TokenVesting public founderTokenVesting;
443 
444   /**
445    * @dev the token sale contract(s) and team can move tokens
446    * @dev   before the lockup expires
447    */
448   modifier onlyWhenTransferEnabled()
449   {
450     if (now <= transferableStartTime) {
451       require(
452         msg.sender == privatePresaleWallet || // solium-disable-line operator-whitespace
453         msg.sender == publicPresaleContract || // solium-disable-line operator-whitespace
454         msg.sender == publicCrowdsaleContract || // solium-disable-line operator-whitespace
455         msg.sender == pathTeamMultisig
456       );
457     }
458     _;
459   }
460 
461   /**
462    * @dev require that this contract cannot affect itself
463    */
464   modifier validDestination(address _addr)
465   {
466     require(_addr != address(this));
467     _;
468   }
469 
470   /**
471    * @dev Constructor
472    */
473   function PATH(uint256 _transferableStartTime)
474     public
475   {
476     transferableStartTime = _transferableStartTime;
477   }
478 
479   /**
480    * @dev override transfer token for a specified address to add validDestination
481    * @param _to The address to transfer to.
482    * @param _value The amount to be transferred.
483    */
484   function transfer(address _to, uint256 _value)
485     onlyPayloadSize(32 + 32) // address (32) + uint256 (32)
486     validDestination(_to)
487     onlyWhenTransferEnabled
488     public
489     returns (bool)
490   {
491     return super.transfer(_to, _value);
492   }
493 
494   /**
495    * @dev override transferFrom token for a specified address to add validDestination
496    * @param _from The address to transfer from.
497    * @param _to The address to transfer to.
498    * @param _value The amount to be transferred.
499    */
500   function transferFrom(address _from, address _to, uint256 _value)
501     onlyPayloadSize(32 + 32 + 32) // address (32) + address (32) + uint256 (32)
502     validDestination(_to)
503     onlyWhenTransferEnabled
504     public
505     returns (bool)
506   {
507     return super.transferFrom(_from, _to, _value);
508   }
509 
510   /**
511    * @dev burn tokens, but also include a Transfer(sender, 0x0, value) event
512    * @param _value The amount to be burned.
513    */
514   function burn(uint256 _value)
515     onlyWhenTransferEnabled
516     public
517   {
518     super.burn(_value);
519   }
520 
521   /**
522    * @dev burn tokens on behalf of someone
523    * @param _from The address of the owner of the token.
524    * @param _value The amount to be burned.
525    */
526   function burnFrom(address _from, uint256 _value)
527     onlyPayloadSize(32 + 32) // address (32) + uint256 (32)
528     onlyWhenTransferEnabled
529     public
530   {
531     require(_value <= allowed[_from][msg.sender]);
532     require(_value <= balances[_from]);
533 
534     balances[_from] = balances[_from].sub(_value);
535     totalSupply_ = totalSupply_.sub(_value);
536     Burn(_from, _value);
537     Transfer(_from, address(0), _value);
538   }
539 
540   /**
541    * @dev override approval functions to include safe payload checking
542    */
543   function approve(address _spender, uint256 _value)
544     onlyPayloadSize(32 + 32) // address (32) + uint256 (32)
545     public
546     returns (bool)
547   {
548     return super.approve(_spender, _value);
549   }
550 
551   function increaseApproval(address _spender, uint256 _addedValue)
552     onlyPayloadSize(32 + 32) // address (32) + uint256 (32)
553     public
554     returns (bool)
555   {
556     return super.increaseApproval(_spender, _addedValue);
557   }
558 
559   function decreaseApproval(address _spender, uint256 _subtractedValue)
560     onlyPayloadSize(32 + 32) // address (32) + uint256 (32)
561     public
562     returns (bool)
563   {
564     return super.decreaseApproval(_spender, _subtractedValue);
565   }
566 
567 
568   /**
569    * @dev distribute the tokens once the crowdsale addresses are known
570    * @dev only callable once and disables minting at the end
571    */
572   function distributeTokens(
573     address _privatePresaleWallet,
574     address _publicPresaleContract,
575     address _publicCrowdsaleContract,
576     address _pathCompanyMultisig,
577     address _pathAdvisorVault,
578     address _pathFounderAddress
579   )
580     onlyOwner
581     canMint
582     external
583   {
584     // Set addresses
585     privatePresaleWallet = _privatePresaleWallet;
586     publicPresaleContract = _publicPresaleContract;
587     publicCrowdsaleContract = _publicCrowdsaleContract;
588     pathTeamMultisig = _pathCompanyMultisig;
589 
590     // Mint all tokens according to the established allocations
591     mint(_privatePresaleWallet, 200000000 * (10 ** uint256(decimals)));
592     // ^ 50%
593     mint(_publicPresaleContract, 32000000 * (10 ** uint256(decimals)));
594     // ^ 8%
595     mint(_publicCrowdsaleContract, 8000000 * (10 ** uint256(decimals)));
596     // ^ 2%
597     mint(_pathCompanyMultisig, 80000000 * (10 ** uint256(decimals)));
598     // ^ 20%
599     mint(_pathAdvisorVault, 40000000 * (10 ** uint256(decimals)));
600     // ^ 10%
601 
602     // deploy a token vesting contract for the founder tokens
603     uint256 cliff = 6 * 4 weeks; // 4 months
604     founderTokenVesting = new TokenVesting(
605       _pathFounderAddress,
606       now,   // start vesting now
607       cliff, // cliff time
608       cliff, // 100% unlocked at cliff
609       false  // irrevocable
610     );
611     // and then mint tokens to the vesting contract
612     mint(address(founderTokenVesting), 40000000 * (10 ** uint256(decimals)));
613     // ^ 10%
614 
615     // immediately finish minting
616     finishMinting();
617 
618     assert(totalSupply_ == initialSupply);
619   }
620 }
621 
622 contract StandardCrowdsale {
623   using SafeMath for uint256;
624 
625   // The token being sold
626   PATH public token;  // Path Modification
627 
628   // start and end timestamps where investments are allowed (both inclusive)
629   uint256 public startTime;
630   uint256 public endTime;
631 
632   // address where funds are collected
633   address public wallet;
634 
635   // how many token units a buyer gets per wei
636   uint256 public rate;
637 
638   // amount of raised money in wei
639   uint256 public weiRaised;
640 
641   /**
642    * event for token purchase logging
643    * @param purchaser who paid for the tokens
644    * @param beneficiary who got the tokens
645    * @param value weis paid for purchase
646    * @param amount amount of tokens purchased
647    */
648   event TokenPurchase(
649     address indexed purchaser,
650     address indexed beneficiary,
651     uint256 value,
652     uint256 amount
653   );
654 
655   function StandardCrowdsale(
656     uint256 _startTime,
657     uint256 _endTime,
658     uint256 _rate,
659     address _wallet,
660     PATH _token
661   )
662     public
663   {
664     require(_startTime >= now);
665     require(_endTime >= _startTime);
666     require(_rate > 0);
667     require(_wallet != address(0));
668     require(_token != address(0));
669 
670     startTime = _startTime;
671     endTime = _endTime;
672     rate = _rate;
673     wallet = _wallet;
674     token = _token;
675   }
676 
677   // fallback function can be used to buy tokens
678   function () external payable {
679     buyTokens(msg.sender);
680   }
681 
682   // low level token purchase function
683   function buyTokens(address beneficiary) public payable {
684     require(beneficiary != address(0));
685     require(validPurchase());
686 
687     uint256 weiAmount = msg.value;
688 
689     // calculate token amount to be created
690     uint256 tokens = getTokenAmount(weiAmount);
691 
692     // update state
693     weiRaised = weiRaised.add(weiAmount);
694 
695     require(token.transfer(beneficiary, tokens)); // PATH Modification
696 
697     TokenPurchase(
698       msg.sender,
699       beneficiary,
700       weiAmount,
701       tokens
702     );
703 
704     forwardFunds();
705   }
706 
707   // @return true if crowdsale event has ended
708   function hasEnded() public view returns (bool) {
709     return now > endTime;
710   }
711 
712   // Override this method to have a way to add business logic to your crowdsale when buying
713   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
714     return weiAmount.mul(rate);
715   }
716 
717   // send ether to the fund collection wallet
718   // override to create custom fund forwarding mechanisms
719   function forwardFunds() internal {
720     wallet.transfer(msg.value);
721   }
722 
723   // @return true if the transaction can buy tokens
724   function validPurchase() internal view returns (bool) {
725     bool withinPeriod = now >= startTime && now <= endTime;
726     bool nonZeroPurchase = msg.value != 0;
727     return withinPeriod && nonZeroPurchase;
728   }
729 }
730 
731 contract FinalizableCrowdsale is StandardCrowdsale, Ownable {
732   using SafeMath for uint256;
733 
734   bool public isFinalized = false;
735 
736   event Finalized();
737 
738   /**
739    * @dev Must be called after crowdsale ends, to do some extra finalization
740    * work. Calls the contract's finalization function.
741    */
742   function finalize() public {
743     require(!isFinalized);
744     require(hasEnded());
745 
746     finalization();
747     Finalized();
748 
749     isFinalized = true;
750   }
751 
752   /**
753    * @dev Can be overridden to add finalization logic. The overriding function
754    * should call super.finalization() to ensure the chain of finalization is
755    * executed entirely.
756    */
757   function finalization() internal {
758   }
759 
760 }
761 
762 contract BurnableCrowdsale is FinalizableCrowdsale {
763   /**
764    * @dev Burns any tokens held by this address.
765    */
766   function finalization() internal {
767     token.burn(token.balanceOf(address(this)));
768     super.finalization();
769   }
770 }
771 
772 contract RateConfigurable is StandardCrowdsale, Ownable {
773 
774   modifier onlyBeforeStart() {
775     require(now < startTime);
776     _;
777   }
778 
779   /**
780    * @dev allow the owner to update the rate before the crowdsale starts
781    * @dev in order to account for ether valuation fluctuation
782    */
783   function updateRate(uint256 _rate)
784     onlyOwner
785     onlyBeforeStart
786     external
787   {
788     rate = _rate;
789   }
790 }
791 
792 contract ReallocatableCrowdsale is StandardCrowdsale, Ownable {
793 
794   /**
795    * @dev reallocate funds from this crowdsale to another
796    */
797   function reallocate(uint256 _value)
798     external
799     onlyOwner
800   {
801     require(!hasEnded());
802     reallocation(_value);
803   }
804 
805   /**
806    * @dev perform the actual reallocation
807    * @dev must be overridden to do anything
808    */
809   function reallocation(uint256 _value)
810     internal
811   {
812   }
813 }
814 
815 contract PathPublicCrowdsale is RateConfigurable, BurnableCrowdsale, ReallocatableCrowdsale, SafePercent {
816   using SafeMath for uint256;
817 
818   address public pathAdvisorVault;
819   address public privatePresaleWallet;
820 
821   function PathPublicCrowdsale (
822     uint256 _startTime,
823     uint256 _endTime,
824     uint256 _rate,
825     address _wallet,
826     address _pathAdvisorVault,
827     PATH _token,
828     address _privatePresaleWallet
829   )
830     BurnableCrowdsale()
831     StandardCrowdsale(_startTime, _endTime, _rate, _wallet, _token)
832     public
833   {
834     pathAdvisorVault = _pathAdvisorVault;
835     privatePresaleWallet = _privatePresaleWallet;
836   }
837 
838   function finalization() internal {
839     // First Burn the Crowdsale and then the advisors
840     super.finalization();
841     uint256 amountToBurn = calculateBurnAmount();
842     TokenVault(pathAdvisorVault).approve(
843       address(this),
844       token,
845       amountToBurn
846     );
847     token.burnFrom(pathAdvisorVault, amountToBurn);
848     TokenVault(pathAdvisorVault).open();
849   }
850 
851   function calculateBurnAmount()
852     internal
853     view
854     returns (uint256)
855   {
856     // @TODO(shrugs) - remove 0.6 constant (ideally)
857     // 0.6 is the percent of the tokens that are handled by the sale
858     // and therefore the only tokens that affect advisor burning
859     uint256 maxPossibleRaised = token.initialSupply().mul(3).div(5); // 60%
860     uint256 actuallyRaised = token.totalSupply().sub(
861       token.initialSupply().mul(2).div(5) // 40%
862     );
863 
864     uint256 precision = 4; // decimal places of precision
865     uint256 raisedRatio = percent(actuallyRaised, maxPossibleRaised, precision);
866     // ^ [00000, 10000]
867     uint256 burnRatio = (10 ** precision).sub(raisedRatio);
868     // 10000 is for the 4 decimals of precision
869     uint256 amountToBurnWithPrecision = token.balanceOf(pathAdvisorVault).mul(burnRatio);
870     // balance * burnRatio = amountToBurn, but *10^4
871 
872     return amountToBurnWithPrecision.div(10 ** precision);
873   }
874 
875   /**
876    * @dev Implements tiered token amount based on number of weeks since startTime
877    * @dev Overrides getTokenAmount method from StandardCrowdsale.sol
878    */
879   function getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
880     var timeSinceStart = now - startTime;
881 
882     uint256 discountMultiplier;
883     if (timeSinceStart <= 1 weeks) {
884       discountMultiplier = 70;
885     } else if (timeSinceStart <= 2 weeks) {
886       discountMultiplier = 80;
887     } else if (timeSinceStart <= 3 weeks) {
888       discountMultiplier = 90;
889     } else {
890       discountMultiplier = 100;
891     }
892 
893     return weiAmount.mul(rate).mul(100).div(discountMultiplier);
894   }
895 
896   function reallocation(uint256 _value)
897     internal
898   {
899     require(token.transfer(privatePresaleWallet, _value));
900   }
901 }
902 
903 contract TokenVault is Ownable {
904 
905   /**
906    * @dev whether or not this vault is open and the tokens are available for withdrawal
907    */
908   bool public open = false;
909 
910   address public beneficiary;
911 
912   modifier isOpen() {
913     require(open);
914     _;
915   }
916 
917   modifier onlyBeneficiary() {
918     require(msg.sender == beneficiary);
919     _;
920   }
921 
922   function TokenVault(address _beneficiary)
923     public
924   {
925     beneficiary = _beneficiary;
926   }
927 
928   /**
929    * @dev opens the vault, allowing the Tokens to be withdrawn,
930    * @dev   only callable by the owner (crowdsale)
931    */
932   function open()
933     onlyOwner
934     external
935   {
936     open = true;
937   }
938 
939   /**
940    * @dev withdraw all tokens to the caller
941    */
942   function withdraw(StandardToken _token)
943     isOpen
944     onlyBeneficiary
945     external
946   {
947     require(_token.transfer(msg.sender, _token.balanceOf(address(this))));
948   }
949 
950   function approve(
951     address _beneficiary,
952     StandardToken _token,
953     uint256 _value
954   )
955     onlyOwner
956     public
957   {
958     require(_token.approve(_beneficiary, _value));
959   }
960 }