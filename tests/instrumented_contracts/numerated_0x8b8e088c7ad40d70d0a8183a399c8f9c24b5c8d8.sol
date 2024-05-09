1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 /**
51  * @title SafeERC20
52  * @dev Wrappers around ERC20 operations that throw on failure.
53  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
54  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
55  */
56 library SafeERC20 {
57   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
58     require(token.transfer(to, value));
59   }
60 
61   function safeTransferFrom(
62     ERC20 token,
63     address from,
64     address to,
65     uint256 value
66   )
67     internal
68   {
69     require(token.transferFrom(from, to, value));
70   }
71 
72   function safeApprove(ERC20 token, address spender, uint256 value) internal {
73     require(token.approve(spender, value));
74   }
75 }
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   function totalSupply() public view returns (uint256);
83   function balanceOf(address who) public view returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 /**
88  * @title Basic token
89  * @dev Basic version of StandardToken, with no allowances.
90  */
91 contract BasicToken is ERC20Basic {
92   using SafeMath for uint256;
93 
94   mapping(address => uint256) balances;
95 
96   uint256 totalSupply_;
97 
98   /**
99   * @dev total number of tokens in existence
100   */
101   function totalSupply() public view returns (uint256) {
102     return totalSupply_;
103   }
104 
105   /**
106   * @dev transfer token for a specified address
107   * @param _to The address to transfer to.
108   * @param _value The amount to be transferred.
109   */
110   function transfer(address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[msg.sender]);
113 
114     balances[msg.sender] = balances[msg.sender].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     emit Transfer(msg.sender, _to, _value);
117     return true;
118   }
119 
120   /**
121   * @dev Gets the balance of the specified address.
122   * @param _owner The address to query the the balance of.
123   * @return An uint256 representing the amount owned by the passed address.
124   */
125   function balanceOf(address _owner) public view returns (uint256) {
126     return balances[_owner];
127   }
128 
129 }
130 /**
131  * @title ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/20
133  */
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender)
136     public view returns (uint256);
137 
138   function transferFrom(address from, address to, uint256 value)
139     public returns (bool);
140 
141   function approve(address spender, uint256 value) public returns (bool);
142   event Approval(
143     address indexed owner,
144     address indexed spender,
145     uint256 value
146   );
147 }
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * @dev https://github.com/ethereum/EIPs/issues/20
153  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(
167     address _from,
168     address _to,
169     uint256 _value
170   )
171     public
172     returns (bool)
173   {
174     require(_to != address(0));
175     require(_value <= balances[_from]);
176     require(_value <= allowed[_from][msg.sender]);
177 
178     balances[_from] = balances[_from].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181     emit Transfer(_from, _to, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    *
188    * Beware that changing an allowance with this method brings the risk that someone may use both the old
189    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint256 _value) public returns (bool) {
196     allowed[msg.sender][_spender] = _value;
197     emit Approval(msg.sender, _spender, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Function to check the amount of tokens that an owner allowed to a spender.
203    * @param _owner address The address which owns the funds.
204    * @param _spender address The address which will spend the funds.
205    * @return A uint256 specifying the amount of tokens still available for the spender.
206    */
207   function allowance(
208     address _owner,
209     address _spender
210    )
211     public
212     view
213     returns (uint256)
214   {
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
228   function increaseApproval(
229     address _spender,
230     uint _addedValue
231   )
232     public
233     returns (bool)
234   {
235     allowed[msg.sender][_spender] = (
236       allowed[msg.sender][_spender].add(_addedValue));
237     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(
252     address _spender,
253     uint _subtractedValue
254   )
255     public
256     returns (bool)
257   {
258     uint oldValue = allowed[msg.sender][_spender];
259     if (_subtractedValue > oldValue) {
260       allowed[msg.sender][_spender] = 0;
261     } else {
262       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
263     }
264     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268 }
269 /// @title Ownable
270 /// @author Applicature
271 /// @notice helper mixed to other contracts to link contract on an owner
272 /// @dev Base class
273 contract Ownable {
274     //Variables
275     address public owner;
276     address public newOwner;
277 
278     //    Modifiers
279     /**
280      * @dev Throws if called by any account other than the owner.
281      */
282     modifier onlyOwner() {
283         require(msg.sender == owner);
284         _;
285     }
286 
287     /**
288      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
289      * account.
290      */
291     constructor() public {
292         owner = msg.sender;
293     }
294 
295     /**
296      * @dev Allows the current owner to transfer control of the contract to a newOwner.
297      * @param _newOwner The address to transfer ownership to.
298      */
299     function transferOwnership(address _newOwner) public onlyOwner {
300         require(_newOwner != address(0));
301         newOwner = _newOwner;
302 
303     }
304 
305     function acceptOwnership() public {
306         if (msg.sender == newOwner) {
307             owner = newOwner;
308         }
309     }
310 }
311 /// @title OpenZeppelinERC20
312 /// @author Applicature
313 /// @notice Open Zeppelin implementation of standart ERC20
314 /// @dev Base class
315 contract OpenZeppelinERC20 is StandardToken, Ownable {
316     using SafeMath for uint256;
317 
318     uint8 public decimals;
319     string public name;
320     string public symbol;
321     string public standard;
322 
323     constructor(
324         uint256 _totalSupply,
325         string _tokenName,
326         uint8 _decimals,
327         string _tokenSymbol,
328         bool _transferAllSupplyToOwner
329     ) public {
330         standard = 'ERC20 0.1';
331         totalSupply_ = _totalSupply;
332 
333         if (_transferAllSupplyToOwner) {
334             balances[msg.sender] = _totalSupply;
335         } else {
336             balances[this] = _totalSupply;
337         }
338 
339         name = _tokenName;
340         // Set the name for display purposes
341         symbol = _tokenSymbol;
342         // Set the symbol for display purposes
343         decimals = _decimals;
344     }
345 
346 }
347 /**
348  * @title Burnable Token
349  * @dev Token that can be irreversibly burned (destroyed).
350  */
351 contract BurnableToken is BasicToken {
352 
353   event Burn(address indexed burner, uint256 value);
354 
355   /**
356    * @dev Burns a specific amount of tokens.
357    * @param _value The amount of token to be burned.
358    */
359   function burn(uint256 _value) public {
360     _burn(msg.sender, _value);
361   }
362 
363   function _burn(address _who, uint256 _value) internal {
364     require(_value <= balances[_who]);
365     // no need to require value <= totalSupply, since that would imply the
366     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
367 
368     balances[_who] = balances[_who].sub(_value);
369     totalSupply_ = totalSupply_.sub(_value);
370     emit Burn(_who, _value);
371     emit Transfer(_who, address(0), _value);
372   }
373 }
374 /// @title MintableToken
375 /// @author Applicature
376 /// @notice allow to mint tokens
377 /// @dev Base class
378 contract MintableToken is BasicToken, Ownable {
379 
380     using SafeMath for uint256;
381 
382     uint256 public maxSupply;
383     bool public allowedMinting;
384     mapping(address => bool) public mintingAgents;
385     mapping(address => bool) public stateChangeAgents;
386 
387     event Mint(address indexed holder, uint256 tokens);
388 
389     modifier onlyMintingAgents () {
390         require(mintingAgents[msg.sender]);
391         _;
392     }
393 
394     modifier onlyStateChangeAgents () {
395         require(stateChangeAgents[msg.sender]);
396         _;
397     }
398 
399     constructor(uint256 _maxSupply, uint256 _mintedSupply, bool _allowedMinting) public {
400         maxSupply = _maxSupply;
401         totalSupply_ = totalSupply_.add(_mintedSupply);
402         allowedMinting = _allowedMinting;
403         mintingAgents[msg.sender] = true;
404     }
405 
406     /// @notice allow to mint tokens
407     function mint(address _holder, uint256 _tokens) public onlyMintingAgents() {
408         require(allowedMinting == true && totalSupply_.add(_tokens) <= maxSupply);
409 
410         totalSupply_ = totalSupply_.add(_tokens);
411 
412         balances[_holder] = balanceOf(_holder).add(_tokens);
413 
414         if (totalSupply_ == maxSupply) {
415             allowedMinting = false;
416         }
417         emit Transfer(address(0), _holder, _tokens);
418         emit Mint(_holder, _tokens);
419     }
420 
421     /// @notice update allowedMinting flat
422     function disableMinting() public onlyStateChangeAgents() {
423         allowedMinting = false;
424     }
425 
426     /// @notice update minting agent
427     function updateMintingAgent(address _agent, bool _status) public onlyOwner {
428         mintingAgents[_agent] = _status;
429     }
430 
431     /// @notice update state change agent
432     function updateStateChangeAgent(address _agent, bool _status) public onlyOwner {
433         stateChangeAgents[_agent] = _status;
434     }
435 
436     /// @return available tokens
437     function availableTokens() public view returns (uint256 tokens) {
438         return maxSupply.sub(totalSupply_);
439     }
440 }
441 /// @title MintableBurnableToken
442 /// @author Applicature
443 /// @notice helper mixed to other contracts to burn tokens
444 /// @dev implementation
445 contract MintableBurnableToken is MintableToken, BurnableToken {
446 
447     mapping (address => bool) public burnAgents;
448 
449     modifier onlyBurnAgents () {
450         require(burnAgents[msg.sender]);
451         _;
452     }
453 
454     event Burn(address indexed burner, uint256 value);
455 
456     constructor(
457         uint256 _maxSupply,
458         uint256 _mintedSupply,
459         bool _allowedMinting
460     ) public MintableToken(
461         _maxSupply,
462         _mintedSupply,
463         _allowedMinting
464     ) {
465 
466     }
467 
468     /// @notice update minting agent
469     function updateBurnAgent(address _agent, bool _status) public onlyOwner {
470         burnAgents[_agent] = _status;
471     }
472 
473     function burnByAgent(address _holder, uint256 _tokensToBurn) public onlyBurnAgents() returns (uint256) {
474         if (_tokensToBurn == 0) {
475             _tokensToBurn = balanceOf(_holder);
476         }
477         _burn(_holder, _tokensToBurn);
478 
479         return _tokensToBurn;
480     }
481 
482     function _burn(address _who, uint256 _value) internal {
483         require(_value <= balances[_who]);
484         // no need to require value <= totalSupply, since that would imply the
485         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
486 
487         balances[_who] = balances[_who].sub(_value);
488         totalSupply_ = totalSupply_.sub(_value);
489         maxSupply = maxSupply.sub(_value);
490         emit Burn(_who, _value);
491         emit Transfer(_who, address(0), _value);
492     }
493 }
494 /// @title TimeLocked
495 /// @author Applicature
496 /// @notice helper mixed to other contracts to lock contract on a timestamp
497 /// @dev Base class
498 contract TimeLocked {
499     uint256 public time;
500     mapping(address => bool) public excludedAddresses;
501 
502     modifier isTimeLocked(address _holder, bool _timeLocked) {
503         bool locked = (block.timestamp < time);
504         require(excludedAddresses[_holder] == true || locked == _timeLocked);
505         _;
506     }
507 
508     constructor(uint256 _time) public {
509         time = _time;
510     }
511 
512     function updateExcludedAddress(address _address, bool _status) public;
513 }
514 /// @title TimeLockedToken
515 /// @author Applicature
516 /// @notice helper mixed to other contracts to lock contract on a timestamp
517 /// @dev Base class
518 contract TimeLockedToken is TimeLocked, StandardToken {
519 
520     constructor(uint256 _time) public TimeLocked(_time) {}
521 
522     function transfer(address _to, uint256 _tokens) public isTimeLocked(msg.sender, false) returns (bool) {
523         return super.transfer(_to, _tokens);
524     }
525 
526     function transferFrom(
527         address _holder,
528         address _to,
529         uint256 _tokens
530     ) public isTimeLocked(_holder, false) returns (bool) {
531         return super.transferFrom(_holder, _to, _tokens);
532     }
533 }
534 contract CHLToken is OpenZeppelinERC20, MintableBurnableToken, TimeLockedToken {
535 
536     CHLCrowdsale public crowdsale;
537 
538     bool public isSoftCapAchieved;
539 
540     //_unlockTokensTime - Lockup 3 months after end of the ICO
541     constructor(uint256 _unlockTokensTime) public
542     OpenZeppelinERC20(0, 'ChelleCoin', 18, 'CHL', false)
543     MintableBurnableToken(59500000e18, 0, true)
544     TimeLockedToken(_unlockTokensTime) {
545 
546     }
547 
548     function updateMaxSupply(uint256 _newMaxSupply) public onlyOwner {
549         require(_newMaxSupply > 0);
550         maxSupply = _newMaxSupply;
551     }
552 
553     function updateExcludedAddress(address _address, bool _status) public onlyOwner {
554         excludedAddresses[_address] = _status;
555     }
556 
557     function setCrowdSale(address _crowdsale) public onlyOwner {
558         require(_crowdsale != address(0));
559         crowdsale = CHLCrowdsale(_crowdsale);
560     }
561 
562     function setUnlockTime(uint256 _unlockTokensTime) public onlyStateChangeAgents {
563         time = _unlockTokensTime;
564     }
565 
566     function setIsSoftCapAchieved() public onlyStateChangeAgents {
567         isSoftCapAchieved = true;
568     }
569 
570     function transfer(address _to, uint256 _tokens) public returns (bool) {
571         require(true == isTransferAllowed(msg.sender, _tokens));
572         return super.transfer(_to, _tokens);
573     }
574 
575     function transferFrom(address _holder, address _to, uint256 _tokens) public returns (bool) {
576         require(true == isTransferAllowed(_holder, _tokens));
577         return super.transferFrom(_holder, _to, _tokens);
578     }
579 
580     function isTransferAllowed(address _address, uint256 _value) public view returns (bool) {
581         if (excludedAddresses[_address] == true) {
582             return true;
583         }
584 
585         if (!isSoftCapAchieved && (address(crowdsale) == address(0) || false == crowdsale.isSoftCapAchieved(0))) {
586             return false;
587         }
588 
589         return true;
590     }
591 
592     function burnUnsoldTokens(uint256 _tokensToBurn) public onlyBurnAgents() returns (uint256) {
593         require(totalSupply_.add(_tokensToBurn) <= maxSupply);
594 
595         maxSupply = maxSupply.sub(_tokensToBurn);
596 
597         emit Burn(address(0), _tokensToBurn);
598 
599         return _tokensToBurn;
600     }
601 
602 }
603 /// @title Agent
604 /// @author Applicature
605 /// @notice Contract which takes actions on state change and contribution
606 /// @dev Base class
607 contract Agent {
608     using SafeMath for uint256;
609 
610     function isInitialized() public constant returns (bool) {
611         return false;
612     }
613 }
614 /// @title CrowdsaleAgent
615 /// @author Applicature
616 /// @notice Contract which takes actions on state change and contribution
617 /// @dev Base class
618 contract CrowdsaleAgent is Agent {
619 
620 
621     Crowdsale public crowdsale;
622     bool public _isInitialized;
623 
624     modifier onlyCrowdsale() {
625         require(msg.sender == address(crowdsale));
626         _;
627     }
628 
629     constructor(Crowdsale _crowdsale) public {
630         crowdsale = _crowdsale;
631 
632         if (address(0) != address(_crowdsale)) {
633             _isInitialized = true;
634         } else {
635             _isInitialized = false;
636         }
637     }
638 
639     function isInitialized() public constant returns (bool) {
640         return _isInitialized;
641     }
642 
643     function onContribution(address _contributor, uint256 _weiAmount, uint256 _tokens, uint256 _bonus)
644         public onlyCrowdsale();
645 
646     function onStateChange(Crowdsale.State _state) public onlyCrowdsale();
647 
648     function onRefund(address _contributor, uint256 _tokens) public onlyCrowdsale() returns (uint256 burned);
649 }
650 /// @title MintableCrowdsaleOnSuccessAgent
651 /// @author Applicature
652 /// @notice Contract which takes actions on state change and contribution
653 /// un-pause tokens and disable minting on Crowdsale success
654 /// @dev implementation
655 contract MintableCrowdsaleOnSuccessAgent is CrowdsaleAgent {
656 
657     Crowdsale public crowdsale;
658     MintableToken public token;
659     bool public _isInitialized;
660 
661     constructor(Crowdsale _crowdsale, MintableToken _token) public CrowdsaleAgent(_crowdsale) {
662         crowdsale = _crowdsale;
663         token = _token;
664 
665         if (address(0) != address(_token) &&
666         address(0) != address(_crowdsale)) {
667             _isInitialized = true;
668         } else {
669             _isInitialized = false;
670         }
671     }
672 
673     /// @notice Check whether contract is initialised
674     /// @return true if initialized
675     function isInitialized() public constant returns (bool) {
676         return _isInitialized;
677     }
678 
679     /// @notice Takes actions on contribution
680     function onContribution(address _contributor, uint256 _weiAmount, uint256 _tokens, uint256 _bonus)
681     public onlyCrowdsale() {
682         _contributor = _contributor;
683         _weiAmount = _weiAmount;
684         _tokens = _tokens;
685         _bonus = _bonus;
686         // TODO: add impl
687     }
688 
689     /// @notice Takes actions on state change,
690     /// un-pause tokens and disable minting on Crowdsale success
691     /// @param _state Crowdsale.State
692     function onStateChange(Crowdsale.State _state) public onlyCrowdsale() {
693         if (_state == Crowdsale.State.Success) {
694             token.disableMinting();
695         }
696     }
697 
698     function onRefund(address _contributor, uint256 _tokens) public onlyCrowdsale() returns (uint256 burned) {
699         _contributor = _contributor;
700         _tokens = _tokens;
701     }
702 }
703 contract CHLAgent is MintableCrowdsaleOnSuccessAgent, Ownable {
704 
705     CHLPricingStrategy public strategy;
706     CHLCrowdsale public crowdsale;
707     CHLAllocation public allocation;
708 
709     bool public isEndProcessed;
710 
711     constructor(
712         CHLCrowdsale _crowdsale,
713         CHLToken _token,
714         CHLPricingStrategy _strategy,
715         CHLAllocation _allocation
716     ) public MintableCrowdsaleOnSuccessAgent(_crowdsale, _token) {
717         strategy = _strategy;
718         crowdsale = _crowdsale;
719         allocation = _allocation;
720     }
721 
722     /// @notice update pricing strategy
723     function setPricingStrategy(CHLPricingStrategy _strategy) public onlyOwner {
724         strategy = _strategy;
725     }
726 
727     /// @notice update allocation
728     function setAllocation(CHLAllocation _allocation) public onlyOwner {
729         allocation = _allocation;
730     }
731 
732     function burnUnsoldTokens(uint256 _tierId) public onlyOwner {
733         uint256 tierUnsoldTokensAmount = strategy.getTierUnsoldTokens(_tierId);
734         require(tierUnsoldTokensAmount > 0);
735 
736         CHLToken(token).burnUnsoldTokens(tierUnsoldTokensAmount);
737     }
738 
739     /// @notice Takes actions on contribution
740     function onContribution(
741         address,
742         uint256 _tierId,
743         uint256 _tokens,
744         uint256 _bonus
745     ) public onlyCrowdsale() {
746         strategy.updateTierTokens(_tierId, _tokens, _bonus);
747     }
748 
749     function onStateChange(Crowdsale.State _state) public onlyCrowdsale() {
750         CHLToken chlToken = CHLToken(token);
751         if (
752             chlToken.isSoftCapAchieved() == false
753             && (_state == Crowdsale.State.Success || _state == Crowdsale.State.Finalized)
754             && crowdsale.isSoftCapAchieved(0)
755         ) {
756             chlToken.setIsSoftCapAchieved();
757         }
758 
759         if (_state > Crowdsale.State.InCrowdsale && isEndProcessed == false) {
760             allocation.allocateFoundersTokens(strategy.getSaleEndDate());
761         }
762     }
763 
764     function onRefund(address _contributor, uint256 _tokens) public onlyCrowdsale() returns (uint256 burned) {
765         burned = CHLToken(token).burnByAgent(_contributor, _tokens);
766     }
767 
768     function updateStateWithPrivateSale(
769         uint256 _tierId,
770         uint256 _tokensAmount,
771         uint256 _usdAmount
772     ) public {
773         require(msg.sender == address(allocation));
774 
775         strategy.updateMaxTokensCollected(_tierId, _tokensAmount);
776         crowdsale.updateStatsVars(_usdAmount, _tokensAmount);
777     }
778 
779     function updateLockPeriod(uint256 _time) public {
780         require(msg.sender == address(strategy));
781         CHLToken(token).setUnlockTime(_time.add(12 weeks));
782     }
783 
784 }
785 /// @title TokenAllocator
786 /// @author Applicature
787 /// @notice Contract responsible for defining distribution logic of tokens.
788 /// @dev Base class
789 contract TokenAllocator is Ownable {
790 
791 
792     mapping(address => bool) public crowdsales;
793 
794     modifier onlyCrowdsale() {
795         require(crowdsales[msg.sender]);
796         _;
797     }
798 
799     function addCrowdsales(address _address) public onlyOwner {
800         crowdsales[_address] = true;
801     }
802 
803     function removeCrowdsales(address _address) public onlyOwner {
804         crowdsales[_address] = false;
805     }
806 
807     function isInitialized() public constant returns (bool) {
808         return false;
809     }
810 
811     function allocate(address _holder, uint256 _tokens) public onlyCrowdsale() {
812         internalAllocate(_holder, _tokens);
813     }
814 
815     function tokensAvailable() public constant returns (uint256);
816 
817     function internalAllocate(address _holder, uint256 _tokens) internal onlyCrowdsale();
818 }
819 /// @title MintableTokenAllocator
820 /// @author Applicature
821 /// @notice Contract responsible for defining distribution logic of tokens.
822 /// @dev implementation
823 contract MintableTokenAllocator is TokenAllocator {
824 
825     using SafeMath for uint256;
826 
827     MintableToken public token;
828 
829     constructor(MintableToken _token) public {
830         require(address(0) != address(_token));
831         token = _token;
832     }
833 
834     /// @return available tokens
835     function tokensAvailable() public constant returns (uint256) {
836         return token.availableTokens();
837     }
838 
839     /// @notice transfer tokens on holder account
840     function allocate(address _holder, uint256 _tokens) public onlyCrowdsale() {
841         internalAllocate(_holder, _tokens);
842     }
843 
844     /// @notice Check whether contract is initialised
845     /// @return true if initialized
846     function isInitialized() public constant returns (bool) {
847         return token.mintingAgents(this);
848     }
849 
850     /// @notice update instance of MintableToken
851     function setToken(MintableToken _token) public onlyOwner {
852         token = _token;
853     }
854 
855     function internalAllocate(address _holder, uint256 _tokens) internal {
856         token.mint(_holder, _tokens);
857     }
858 
859 }
860 /// @title ContributionForwarder
861 /// @author Applicature
862 /// @notice Contract is responsible for distributing collected ethers, that are received from CrowdSale.
863 /// @dev Base class
864 contract ContributionForwarder {
865 
866     using SafeMath for uint256;
867 
868     uint256 public weiCollected;
869     uint256 public weiForwarded;
870 
871     event ContributionForwarded(address receiver, uint256 weiAmount);
872 
873     function isInitialized() public constant returns (bool) {
874         return false;
875     }
876 
877     /// @notice transfer wei to receiver
878     function forward() public payable {
879         require(msg.value > 0);
880 
881         weiCollected += msg.value;
882 
883         internalForward();
884     }
885 
886     function internalForward() internal;
887 }
888 /// @title DistributedDirectContributionForwarder
889 /// @author Applicature
890 /// @notice Contract is responsible for distributing collected ethers, that are received from CrowdSale.
891 /// @dev implementation
892 contract DistributedDirectContributionForwarder is ContributionForwarder {
893     Receiver[] public receivers;
894     uint256 public proportionAbsMax;
895     bool public isInitialized_;
896 
897     struct Receiver {
898         address receiver;
899         uint256 proportion; // abslolute value in range of 0 - proportionAbsMax
900         uint256 forwardedWei;
901     }
902 
903     // @TODO: should we use uint256 [] for receivers & proportions?
904     constructor(uint256 _proportionAbsMax, address[] _receivers, uint256[] _proportions) public {
905         proportionAbsMax = _proportionAbsMax;
906 
907         require(_receivers.length == _proportions.length);
908 
909         require(_receivers.length > 0);
910 
911         uint256 totalProportion;
912 
913         for (uint256 i = 0; i < _receivers.length; i++) {
914             uint256 proportion = _proportions[i];
915 
916             totalProportion = totalProportion.add(proportion);
917 
918             receivers.push(Receiver(_receivers[i], proportion, 0));
919         }
920 
921         require(totalProportion == proportionAbsMax);
922         isInitialized_ = true;
923     }
924 
925     /// @notice Check whether contract is initialised
926     /// @return true if initialized
927     function isInitialized() public constant returns (bool) {
928         return isInitialized_;
929     }
930 
931     function internalForward() internal {
932         uint256 transferred;
933 
934         for (uint256 i = 0; i < receivers.length; i++) {
935             Receiver storage receiver = receivers[i];
936 
937             uint256 value = msg.value.mul(receiver.proportion).div(proportionAbsMax);
938 
939             if (i == receivers.length - 1) {
940                 value = msg.value.sub(transferred);
941             }
942 
943             transferred = transferred.add(value);
944 
945             receiver.receiver.transfer(value);
946 
947             emit ContributionForwarded(receiver.receiver, value);
948         }
949 
950         weiForwarded = weiForwarded.add(transferred);
951     }
952 }
953 contract Crowdsale {
954 
955     uint256 public tokensSold;
956 
957     enum State {Unknown, Initializing, BeforeCrowdsale, InCrowdsale, Success, Finalized, Refunding}
958 
959     function externalContribution(address _contributor, uint256 _wei) public payable;
960 
961     function contribute(uint8 _v, bytes32 _r, bytes32 _s) public payable;
962 
963     function updateState() public;
964 
965     function internalContribution(address _contributor, uint256 _wei) internal;
966 
967     function getState() public view returns (State);
968 
969 }
970 /// @title Crowdsale
971 /// @author Applicature
972 /// @notice Contract is responsible for collecting, refunding, allocating tokens during different stages of Crowdsale.
973 contract CrowdsaleImpl is Crowdsale, Ownable {
974 
975     using SafeMath for uint256;
976 
977     State public currentState;
978     TokenAllocator public allocator;
979     ContributionForwarder public contributionForwarder;
980     PricingStrategy public pricingStrategy;
981     CrowdsaleAgent public crowdsaleAgent;
982     bool public finalized;
983     uint256 public startDate;
984     uint256 public endDate;
985     bool public allowWhitelisted;
986     bool public allowSigned;
987     bool public allowAnonymous;
988     mapping(address => bool) public whitelisted;
989     mapping(address => bool) public signers;
990     mapping(address => bool) public externalContributionAgents;
991 
992     event Contribution(address _contributor, uint256 _wei, uint256 _tokensExcludingBonus, uint256 _bonus);
993 
994     constructor(
995         TokenAllocator _allocator,
996         ContributionForwarder _contributionForwarder,
997         PricingStrategy _pricingStrategy,
998         uint256 _startDate,
999         uint256 _endDate,
1000         bool _allowWhitelisted,
1001         bool _allowSigned,
1002         bool _allowAnonymous
1003     ) public {
1004         allocator = _allocator;
1005         contributionForwarder = _contributionForwarder;
1006         pricingStrategy = _pricingStrategy;
1007 
1008         startDate = _startDate;
1009         endDate = _endDate;
1010 
1011         allowWhitelisted = _allowWhitelisted;
1012         allowSigned = _allowSigned;
1013         allowAnonymous = _allowAnonymous;
1014 
1015         currentState = State.Unknown;
1016     }
1017 
1018     /// @notice default payable function
1019     function() public payable {
1020         require(allowWhitelisted || allowAnonymous);
1021 
1022         if (!allowAnonymous) {
1023             if (allowWhitelisted) {
1024                 require(whitelisted[msg.sender]);
1025             }
1026         }
1027 
1028         internalContribution(msg.sender, msg.value);
1029     }
1030 
1031     /// @notice update crowdsale agent
1032     function setCrowdsaleAgent(CrowdsaleAgent _crowdsaleAgent) public onlyOwner {
1033         crowdsaleAgent = _crowdsaleAgent;
1034     }
1035 
1036     /// @notice allows external user to do contribution
1037     function externalContribution(address _contributor, uint256 _wei) public payable {
1038         require(externalContributionAgents[msg.sender]);
1039         internalContribution(_contributor, _wei);
1040     }
1041 
1042     /// @notice update external contributor
1043     function addExternalContributor(address _contributor) public onlyOwner {
1044         externalContributionAgents[_contributor] = true;
1045     }
1046 
1047     /// @notice update external contributor
1048     function removeExternalContributor(address _contributor) public onlyOwner {
1049         externalContributionAgents[_contributor] = false;
1050     }
1051 
1052     /// @notice update whitelisting address
1053     function updateWhitelist(address _address, bool _status) public onlyOwner {
1054         whitelisted[_address] = _status;
1055     }
1056 
1057     /// @notice update signer
1058     function addSigner(address _signer) public onlyOwner {
1059         signers[_signer] = true;
1060     }
1061 
1062     /// @notice update signer
1063     function removeSigner(address _signer) public onlyOwner {
1064         signers[_signer] = false;
1065     }
1066 
1067     /// @notice allows to do signed contributions
1068     function contribute(uint8 _v, bytes32 _r, bytes32 _s) public payable {
1069         address recoveredAddress = verify(msg.sender, _v, _r, _s);
1070         require(signers[recoveredAddress]);
1071         internalContribution(msg.sender, msg.value);
1072     }
1073 
1074     /// @notice Crowdsale state
1075     function updateState() public {
1076         State state = getState();
1077 
1078         if (currentState != state) {
1079             if (crowdsaleAgent != address(0)) {
1080                 crowdsaleAgent.onStateChange(state);
1081             }
1082 
1083             currentState = state;
1084         }
1085     }
1086 
1087     function internalContribution(address _contributor, uint256 _wei) internal {
1088         require(getState() == State.InCrowdsale);
1089 
1090         uint256 tokensAvailable = allocator.tokensAvailable();
1091         uint256 collectedWei = contributionForwarder.weiCollected();
1092 
1093         uint256 tokens;
1094         uint256 tokensExcludingBonus;
1095         uint256 bonus;
1096 
1097         (tokens, tokensExcludingBonus, bonus) = pricingStrategy.getTokens(
1098             _contributor, tokensAvailable, tokensSold, _wei, collectedWei);
1099 
1100         require(tokens > 0 && tokens <= tokensAvailable);
1101         tokensSold = tokensSold.add(tokens);
1102 
1103         allocator.allocate(_contributor, tokens);
1104 
1105         if (msg.value > 0) {
1106             contributionForwarder.forward.value(msg.value)();
1107         }
1108 
1109         emit Contribution(_contributor, _wei, tokensExcludingBonus, bonus);
1110     }
1111 
1112     /// @notice check sign
1113     function verify(address _sender, uint8 _v, bytes32 _r, bytes32 _s) public view returns (address) {
1114         bytes32 hash = keccak256(abi.encodePacked(this, _sender));
1115 
1116         bytes memory prefix = '\x19Ethereum Signed Message:\n32';
1117 
1118         return ecrecover(keccak256(abi.encodePacked(prefix, hash)), _v, _r, _s);
1119     }
1120 
1121     /// @return Crowdsale state
1122     function getState() public view returns (State) {
1123         if (finalized) {
1124             return State.Finalized;
1125         } else if (allocator.isInitialized() == false) {
1126             return State.Initializing;
1127         } else if (contributionForwarder.isInitialized() == false) {
1128             return State.Initializing;
1129         } else if (pricingStrategy.isInitialized() == false) {
1130             return State.Initializing;
1131         } else if (block.timestamp < startDate) {
1132             return State.BeforeCrowdsale;
1133         } else if (block.timestamp >= startDate && block.timestamp <= endDate) {
1134             return State.InCrowdsale;
1135         } else if (block.timestamp > endDate) {
1136             return State.Success;
1137         }
1138 
1139         return State.Unknown;
1140     }
1141 }
1142 /// @title HardCappedCrowdsale
1143 /// @author Applicature
1144 /// @notice Contract is responsible for collecting, refunding, allocating tokens during different stages of Crowdsale.
1145 /// with hard limit
1146 contract HardCappedCrowdsale is CrowdsaleImpl {
1147 
1148     using SafeMath for uint256;
1149 
1150     uint256 public hardCap;
1151 
1152     constructor(
1153         TokenAllocator _allocator,
1154         ContributionForwarder _contributionForwarder,
1155         PricingStrategy _pricingStrategy,
1156         uint256 _startDate,
1157         uint256 _endDate,
1158         bool _allowWhitelisted,
1159         bool _allowSigned,
1160         bool _allowAnonymous,
1161         uint256 _hardCap
1162     ) public CrowdsaleImpl(
1163         _allocator,
1164         _contributionForwarder,
1165         _pricingStrategy,
1166         _startDate,
1167         _endDate,
1168         _allowWhitelisted,
1169         _allowSigned,
1170         _allowAnonymous
1171     ) {
1172         hardCap = _hardCap;
1173     }
1174 
1175     /// @return Crowdsale state
1176     function getState() public view returns (State) {
1177         State state = super.getState();
1178 
1179         if (state == State.InCrowdsale) {
1180             if (isHardCapAchieved(0)) {
1181                 return State.Success;
1182             }
1183         }
1184 
1185         return state;
1186     }
1187 
1188     function isHardCapAchieved(uint256 _value) public view returns (bool) {
1189         if (hardCap <= tokensSold.add(_value)) {
1190             return true;
1191         }
1192         return false;
1193     }
1194 
1195     function internalContribution(address _contributor, uint256 _wei) internal {
1196         require(getState() == State.InCrowdsale);
1197 
1198         uint256 tokensAvailable = allocator.tokensAvailable();
1199         uint256 collectedWei = contributionForwarder.weiCollected();
1200 
1201         uint256 tokens;
1202         uint256 tokensExcludingBonus;
1203         uint256 bonus;
1204 
1205         (tokens, tokensExcludingBonus, bonus) = pricingStrategy.getTokens(
1206             _contributor, tokensAvailable, tokensSold, _wei, collectedWei);
1207 
1208         require(tokens <= tokensAvailable && tokens > 0 && false == isHardCapAchieved(tokens.sub(1)));
1209 
1210         tokensSold = tokensSold.add(tokens);
1211 
1212         allocator.allocate(_contributor, tokens);
1213 
1214         if (msg.value > 0) {
1215             contributionForwarder.forward.value(msg.value)();
1216         }
1217         crowdsaleAgent.onContribution(_contributor, _wei, tokensExcludingBonus, bonus);
1218         emit Contribution(_contributor, _wei, tokensExcludingBonus, bonus);
1219     }
1220 }
1221 /// @title RefundableCrowdsale
1222 /// @author Applicature
1223 /// @notice Contract is responsible for collecting, refunding, allocating tokens during different stages of Crowdsale.
1224 /// with hard and soft limits
1225 contract RefundableCrowdsale is HardCappedCrowdsale {
1226 
1227     using SafeMath for uint256;
1228 
1229     uint256 public softCap;
1230     mapping(address => uint256) public contributorsWei;
1231     address[] public contributors;
1232 
1233     event Refund(address _holder, uint256 _wei, uint256 _tokens);
1234 
1235     constructor(
1236         TokenAllocator _allocator,
1237         ContributionForwarder _contributionForwarder,
1238         PricingStrategy _pricingStrategy,
1239         uint256 _startDate,
1240         uint256 _endDate,
1241         bool _allowWhitelisted,
1242         bool _allowSigned,
1243         bool _allowAnonymous,
1244         uint256 _softCap,
1245         uint256 _hardCap
1246 
1247     ) public HardCappedCrowdsale(
1248         _allocator, _contributionForwarder, _pricingStrategy,
1249         _startDate, _endDate,
1250         _allowWhitelisted, _allowSigned, _allowAnonymous, _hardCap
1251     ) {
1252         softCap = _softCap;
1253     }
1254 
1255     /// @notice refund ethers to contributor
1256     function refund() public {
1257         internalRefund(msg.sender);
1258     }
1259 
1260     /// @notice refund ethers to delegate
1261     function delegatedRefund(address _address) public {
1262         internalRefund(_address);
1263     }
1264 
1265     function internalContribution(address _contributor, uint256 _wei) internal {
1266         require(block.timestamp >= startDate && block.timestamp <= endDate);
1267 
1268         uint256 tokensAvailable = allocator.tokensAvailable();
1269         uint256 collectedWei = contributionForwarder.weiCollected();
1270 
1271         uint256 tokens;
1272         uint256 tokensExcludingBonus;
1273         uint256 bonus;
1274 
1275         (tokens, tokensExcludingBonus, bonus) = pricingStrategy.getTokens(
1276             _contributor, tokensAvailable, tokensSold, _wei, collectedWei);
1277 
1278         require(tokens <= tokensAvailable && tokens > 0 && hardCap > tokensSold.add(tokens));
1279 
1280         tokensSold = tokensSold.add(tokens);
1281 
1282         allocator.allocate(_contributor, tokens);
1283 
1284         // transfer only if softcap is reached
1285         if (isSoftCapAchieved(0)) {
1286             if (msg.value > 0) {
1287                 contributionForwarder.forward.value(address(this).balance)();
1288             }
1289         } else {
1290             // store contributor if it is not stored before
1291             if (contributorsWei[_contributor] == 0) {
1292                 contributors.push(_contributor);
1293             }
1294             contributorsWei[_contributor] = contributorsWei[_contributor].add(msg.value);
1295         }
1296         crowdsaleAgent.onContribution(_contributor, _wei, tokensExcludingBonus, bonus);
1297         emit Contribution(_contributor, _wei, tokensExcludingBonus, bonus);
1298     }
1299 
1300     function internalRefund(address _holder) internal {
1301         updateState();
1302         require(block.timestamp > endDate);
1303         require(!isSoftCapAchieved(0));
1304         require(crowdsaleAgent != address(0));
1305 
1306         uint256 value = contributorsWei[_holder];
1307 
1308         require(value > 0);
1309 
1310         contributorsWei[_holder] = 0;
1311         uint256 burnedTokens = crowdsaleAgent.onRefund(_holder, 0);
1312 
1313         _holder.transfer(value);
1314 
1315         emit Refund(_holder, value, burnedTokens);
1316     }
1317 
1318     /// @return Crowdsale state
1319     function getState() public view returns (State) {
1320         State state = super.getState();
1321 
1322         if (state == State.Success) {
1323             if (!isSoftCapAchieved(0)) {
1324                 return State.Refunding;
1325             }
1326         }
1327 
1328         return state;
1329     }
1330 
1331     function isSoftCapAchieved(uint256 _value) public view returns (bool) {
1332         if (softCap <= tokensSold.add(_value)) {
1333             return true;
1334         }
1335         return false;
1336     }
1337 }
1338 contract CHLCrowdsale is RefundableCrowdsale {
1339 
1340     uint256 public maxSaleSupply = 38972500e18;
1341 
1342     uint256 public usdCollected;
1343 
1344     address public processingFeeAddress;
1345     uint256 public percentageAbsMax = 1000;
1346     uint256 public processingFeePercentage = 25;
1347 
1348     event ProcessingFeeAllocation(address _contributor, uint256 _feeAmount);
1349 
1350     event Contribution(address _contributor, uint256 _usdAmount, uint256 _tokensExcludingBonus, uint256 _bonus);
1351 
1352     constructor(
1353         MintableTokenAllocator _allocator,
1354         DistributedDirectContributionForwarder _contributionForwarder,
1355         CHLPricingStrategy _pricingStrategy,
1356         uint256 _startTime,
1357         uint256 _endTime,
1358         address _processingFeeAddress
1359     ) public RefundableCrowdsale(
1360         _allocator,
1361         _contributionForwarder,
1362         _pricingStrategy,
1363         _startTime,
1364         _endTime,
1365         true,
1366         true,
1367         false,
1368         10000000e5,//softCap
1369         102860625e5//hardCap
1370     ) {
1371         require(_processingFeeAddress != address(0));
1372         processingFeeAddress = _processingFeeAddress;
1373     }
1374 
1375     function() public payable {
1376         require(allowWhitelisted || allowAnonymous);
1377 
1378         if (!allowAnonymous) {
1379             if (allowWhitelisted) {
1380                 require(whitelisted[msg.sender]);
1381             }
1382         }
1383 
1384         internalContribution(
1385             msg.sender,
1386             CHLPricingStrategy(pricingStrategy).getUSDAmountByWeis(msg.value)
1387         );
1388     }
1389 
1390     /// @notice allows to do signed contributions
1391     function contribute(uint8 _v, bytes32 _r, bytes32 _s) public payable {
1392         address recoveredAddress = verify(msg.sender, _v, _r, _s);
1393         require(signers[recoveredAddress]);
1394         internalContribution(
1395             msg.sender,
1396             CHLPricingStrategy(pricingStrategy).getUSDAmountByWeis(msg.value)
1397         );
1398     }
1399 
1400     /// @notice allows external user to do contribution
1401     function externalContribution(address _contributor, uint256 _usdAmount) public payable {
1402         require(externalContributionAgents[msg.sender]);
1403         internalContribution(_contributor, _usdAmount);
1404     }
1405 
1406     function updateState() public {
1407         (startDate, endDate) = CHLPricingStrategy(pricingStrategy).getActualDates();
1408         super.updateState();
1409     }
1410 
1411     function isHardCapAchieved(uint256 _value) public view returns (bool) {
1412         if (hardCap <= usdCollected.add(_value)) {
1413             return true;
1414         }
1415         return false;
1416     }
1417 
1418     function isSoftCapAchieved(uint256 _value) public view returns (bool) {
1419         if (softCap <= usdCollected.add(_value)) {
1420             return true;
1421         }
1422         return false;
1423     }
1424 
1425     function getUnsoldTokensAmount() public view returns (uint256) {
1426         return maxSaleSupply.sub(tokensSold);
1427     }
1428 
1429     function updateStatsVars(uint256 _usdAmount, uint256 _tokensAmount) public {
1430         require(msg.sender == address(crowdsaleAgent) && _tokensAmount > 0);
1431 
1432         tokensSold = tokensSold.add(_tokensAmount);
1433         usdCollected = usdCollected.add(_usdAmount);
1434     }
1435 
1436     function internalContribution(address _contributor, uint256 _usdAmount) internal {
1437         updateState();
1438 
1439         require(currentState == State.InCrowdsale);
1440 
1441         CHLPricingStrategy pricing = CHLPricingStrategy(pricingStrategy);
1442 
1443         require(!isHardCapAchieved(_usdAmount.sub(1)));
1444 
1445         uint256 tokensAvailable = allocator.tokensAvailable();
1446         uint256 collectedWei = contributionForwarder.weiCollected();
1447         uint256 tierIndex = pricing.getTierIndex();
1448         uint256 tokens;
1449         uint256 tokensExcludingBonus;
1450         uint256 bonus;
1451 
1452         (tokens, tokensExcludingBonus, bonus) = pricing.getTokens(
1453             _contributor, tokensAvailable, tokensSold, _usdAmount, collectedWei);
1454 
1455         require(tokens > 0);
1456 
1457         tokensSold = tokensSold.add(tokens);
1458 
1459         allocator.allocate(_contributor, tokens);
1460 
1461         //allocate Processing fee
1462         uint256 processingFeeAmount = tokens.mul(processingFeePercentage).div(percentageAbsMax);
1463         allocator.allocate(processingFeeAddress, processingFeeAmount);
1464 
1465         if (isSoftCapAchieved(_usdAmount)) {
1466             if (msg.value > 0) {
1467                 contributionForwarder.forward.value(address(this).balance)();
1468             }
1469         } else {
1470             // store contributor if it is not stored before
1471             if (contributorsWei[_contributor] == 0) {
1472                 contributors.push(_contributor);
1473             }
1474             if (msg.value > 0) {
1475                 contributorsWei[_contributor] = contributorsWei[_contributor].add(msg.value);
1476             }
1477         }
1478 
1479         usdCollected = usdCollected.add(_usdAmount);
1480 
1481         crowdsaleAgent.onContribution(_contributor, tierIndex, tokensExcludingBonus, bonus);
1482 
1483         emit Contribution(_contributor, _usdAmount, tokensExcludingBonus, bonus);
1484         emit ProcessingFeeAllocation(_contributor, processingFeeAmount);
1485     }
1486 
1487 }
1488 contract USDExchange is Ownable {
1489 
1490     using SafeMath for uint256;
1491 
1492     uint256 public etherPriceInUSD;
1493     uint256 public priceUpdateAt;
1494     mapping(address => bool) public trustedAddresses;
1495 
1496     event NewPriceTicker(string _price);
1497 
1498     modifier onlyTursted() {
1499         require(trustedAddresses[msg.sender] == true);
1500         _;
1501     }
1502 
1503     constructor(uint256 _etherPriceInUSD) public {
1504         etherPriceInUSD = _etherPriceInUSD;
1505         priceUpdateAt = block.timestamp;
1506         trustedAddresses[msg.sender] = true;
1507     }
1508 
1509     function setTrustedAddress(address _address, bool _status) public onlyOwner {
1510         trustedAddresses[_address] = _status;
1511     }
1512 
1513     // set ether price in USD with 5 digits after the decimal point
1514     //ex. 308.75000
1515     //for updating the price through  multivest
1516     function setEtherInUSD(string _price) public onlyTursted {
1517         bytes memory bytePrice = bytes(_price);
1518         uint256 dot = bytePrice.length.sub(uint256(6));
1519 
1520         // check if dot is in 6 position  from  the last
1521         require(0x2e == uint(bytePrice[dot]));
1522 
1523         uint256 newPrice = uint256(10 ** 23).div(parseInt(_price, 5));
1524 
1525         require(newPrice > 0);
1526 
1527         etherPriceInUSD = parseInt(_price, 5);
1528 
1529         priceUpdateAt = block.timestamp;
1530 
1531         emit NewPriceTicker(_price);
1532     }
1533 
1534     function parseInt(string _a, uint _b) internal pure returns (uint) {
1535         bytes memory bresult = bytes(_a);
1536         uint res = 0;
1537         bool decimals = false;
1538         for (uint i = 0; i < bresult.length; i++) {
1539             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
1540                 if (decimals) {
1541                     if (_b == 0) break;
1542                     else _b--;
1543                 }
1544                 res *= 10;
1545                 res += uint(bresult[i]) - 48;
1546             } else if (bresult[i] == 46) decimals = true;
1547         }
1548         if (_b > 0) res *= 10 ** _b;
1549         return res;
1550     }
1551 }
1552 /// @title PricingStrategy
1553 /// @author Applicature
1554 /// @notice Contract is responsible for calculating tokens amount depending on different criterias
1555 /// @dev Base class
1556 contract PricingStrategy {
1557 
1558     function isInitialized() public view returns (bool);
1559 
1560     function getTokens(
1561         address _contributor,
1562         uint256 _tokensAvailable,
1563         uint256 _tokensSold,
1564         uint256 _weiAmount,
1565         uint256 _collectedWei
1566     )
1567         public
1568         view
1569         returns (uint256 tokens, uint256 tokensExcludingBonus, uint256 bonus);
1570 
1571     function getWeis(
1572         uint256 _collectedWei,
1573         uint256 _tokensSold,
1574         uint256 _tokens
1575     )
1576         public
1577         view
1578         returns (uint256 weiAmount, uint256 tokensBonus);
1579 
1580 }
1581 /// @title USDDateTiersPricingStrategy
1582 /// @author Applicature
1583 /// @notice Contract is responsible for calculating tokens amount depending on price in USD
1584 /// @dev implementation
1585 contract USDDateTiersPricingStrategy is PricingStrategy, USDExchange {
1586 
1587     using SafeMath for uint256;
1588 
1589     //tokenInUSD token price in usd * 10 ^ 5
1590     //maxTokensCollected max tokens amount that can be distributed
1591     //bonusCap tokens amount cap; while sold tokens < bonus cap - contributors will receive bonus % tokens
1592     //soldTierTokens tokens that already been sold
1593     //bonusTierTokens bonus tokens that already been allocated
1594     //bonusPercents bonus percentage
1595     //minInvestInUSD min investment in usd * 10 * 5
1596     //startDate tier start time
1597     //endDate tier end time
1598     struct Tier {
1599         uint256 tokenInUSD;
1600         uint256 maxTokensCollected;
1601         uint256 bonusCap;
1602         uint256 soldTierTokens;
1603         uint256 bonusTierTokens;
1604         uint256 bonusPercents;
1605         uint256 minInvestInUSD;
1606         uint256 startDate;
1607         uint256 endDate;
1608     }
1609 
1610     Tier[] public tiers;
1611     uint256 public decimals;
1612 
1613     constructor(uint256[] _tiers, uint256 _decimals, uint256 _etherPriceInUSD) public USDExchange(_etherPriceInUSD) {
1614         decimals = _decimals;
1615         trustedAddresses[msg.sender] = true;
1616         require(_tiers.length % 9 == 0);
1617 
1618         uint256 length = _tiers.length / 9;
1619 
1620         for (uint256 i = 0; i < length; i++) {
1621             tiers.push(
1622                 Tier(
1623                     _tiers[i * 9],
1624                     _tiers[i * 9 + 1],
1625                     _tiers[i * 9 + 2],
1626                     _tiers[i * 9 + 3],
1627                     _tiers[i * 9 + 4],
1628                     _tiers[i * 9 + 5],
1629                     _tiers[i * 9 + 6],
1630                     _tiers[i * 9 + 7],
1631                     _tiers[i * 9 + 8]
1632                 )
1633             );
1634         }
1635     }
1636 
1637     /// @return tier index
1638     function getTierIndex() public view returns (uint256) {
1639         for (uint256 i = 0; i < tiers.length; i++) {
1640             if (
1641                 block.timestamp >= tiers[i].startDate &&
1642                 block.timestamp < tiers[i].endDate &&
1643                 tiers[i].maxTokensCollected > tiers[i].soldTierTokens
1644             ) {
1645                 return i;
1646             }
1647         }
1648 
1649         return tiers.length;
1650     }
1651 
1652     function getActualTierIndex() public view returns (uint256) {
1653         for (uint256 i = 0; i < tiers.length; i++) {
1654             if (
1655                 block.timestamp >= tiers[i].startDate
1656                 && block.timestamp < tiers[i].endDate
1657                 && tiers[i].maxTokensCollected > tiers[i].soldTierTokens
1658                 || block.timestamp < tiers[i].startDate
1659             ) {
1660                 return i;
1661             }
1662         }
1663 
1664         return tiers.length.sub(1);
1665     }
1666 
1667     /// @return actual dates
1668     function getActualDates() public view returns (uint256 startDate, uint256 endDate) {
1669         uint256 tierIndex = getActualTierIndex();
1670         startDate = tiers[tierIndex].startDate;
1671         endDate = tiers[tierIndex].endDate;
1672     }
1673 
1674     /// @return tokens based on sold tokens and wei amount
1675     function getTokens(
1676         address,
1677         uint256 _tokensAvailable,
1678         uint256,
1679         uint256 _usdAmount,
1680         uint256
1681     ) public view returns (uint256 tokens, uint256 tokensExcludingBonus, uint256 bonus) {
1682         if (_usdAmount == 0) {
1683             return (0, 0, 0);
1684         }
1685 
1686         uint256 tierIndex = getTierIndex();
1687 
1688         if (tierIndex < tiers.length && _usdAmount < tiers[tierIndex].minInvestInUSD) {
1689             return (0, 0, 0);
1690         }
1691         if (tierIndex == tiers.length) {
1692             return (0, 0, 0);
1693         }
1694         tokensExcludingBonus = _usdAmount.mul(1e18).div(getTokensInUSD(tierIndex));
1695         if (tiers[tierIndex].maxTokensCollected < tiers[tierIndex].soldTierTokens.add(tokensExcludingBonus)) {
1696             return (0, 0, 0);
1697         }
1698 
1699         bonus = calculateBonusAmount(tierIndex, tokensExcludingBonus);
1700 
1701         tokens = tokensExcludingBonus.add(bonus);
1702 
1703         if (tokens > _tokensAvailable) {
1704             return (0, 0, 0);
1705         }
1706     }
1707 
1708     /// @return usd amount based on required tokens
1709     function getUSDAmountByTokens(
1710         uint256 _tokens
1711     ) public view returns (uint256 totalUSDAmount, uint256 tokensBonus) {
1712         if (_tokens == 0) {
1713             return (0, 0);
1714         }
1715 
1716         uint256 tierIndex = getTierIndex();
1717         if (tierIndex == tiers.length) {
1718             return (0, 0);
1719         }
1720         if (tiers[tierIndex].maxTokensCollected < tiers[tierIndex].soldTierTokens.add(_tokens)) {
1721             return (0, 0);
1722         }
1723 
1724         totalUSDAmount = _tokens.mul(getTokensInUSD(tierIndex)).div(1e18);
1725 
1726         if (totalUSDAmount < tiers[tierIndex].minInvestInUSD) {
1727             return (0, 0);
1728         }
1729 
1730         tokensBonus = calculateBonusAmount(tierIndex, _tokens);
1731     }
1732 
1733     /// @return weis based on sold and required tokens
1734     function getWeis(
1735         uint256,
1736         uint256,
1737         uint256 _tokens
1738     ) public view returns (uint256 totalWeiAmount, uint256 tokensBonus) {
1739         uint256 usdAmount;
1740         (usdAmount, tokensBonus) = getUSDAmountByTokens(_tokens);
1741 
1742         if (usdAmount == 0) {
1743             return (0, 0);
1744         }
1745 
1746         totalWeiAmount = usdAmount.mul(1e18).div(etherPriceInUSD);
1747     }
1748 
1749     /// calculates bonus tokens amount by bonusPercents in case if bonusCap is not reached;
1750     /// if reached returns 0
1751     /// @return bonus tokens amount
1752     function calculateBonusAmount(uint256 _tierIndex, uint256 _tokens) public view returns (uint256 bonus) {
1753         if (tiers[_tierIndex].soldTierTokens < tiers[_tierIndex].bonusCap) {
1754             if (tiers[_tierIndex].soldTierTokens.add(_tokens) <= tiers[_tierIndex].bonusCap) {
1755                 bonus = _tokens.mul(tiers[_tierIndex].bonusPercents).div(100);
1756             } else {
1757                 bonus = (tiers[_tierIndex].bonusCap.sub(tiers[_tierIndex].soldTierTokens))
1758                     .mul(tiers[_tierIndex].bonusPercents).div(100);
1759             }
1760         }
1761     }
1762 
1763     function getTokensInUSD(uint256 _tierIndex) public view returns (uint256) {
1764         if (_tierIndex < uint256(tiers.length)) {
1765             return tiers[_tierIndex].tokenInUSD;
1766         }
1767     }
1768 
1769     function getMinEtherInvest(uint256 _tierIndex) public view returns (uint256) {
1770         if (_tierIndex < uint256(tiers.length)) {
1771             return tiers[_tierIndex].minInvestInUSD.mul(1 ether).div(etherPriceInUSD);
1772         }
1773     }
1774 
1775     function getUSDAmountByWeis(uint256 _weiAmount) public view returns (uint256) {
1776         return _weiAmount.mul(etherPriceInUSD).div(1 ether);
1777     }
1778 
1779     /// @notice Check whether contract is initialised
1780     /// @return true if initialized
1781     function isInitialized() public view returns (bool) {
1782         return true;
1783     }
1784 
1785     /// @notice updates tier start/end dates by id
1786     function updateDates(uint8 _tierId, uint256 _start, uint256 _end) public onlyOwner() {
1787         if (_start != 0 && _start < _end && _tierId < tiers.length) {
1788             Tier storage tier = tiers[_tierId];
1789             tier.startDate = _start;
1790             tier.endDate = _end;
1791         }
1792     }
1793 }
1794 contract CHLPricingStrategy is USDDateTiersPricingStrategy {
1795 
1796     CHLAgent public agent;
1797 
1798     modifier onlyAgent() {
1799         require(msg.sender == address(agent));
1800         _;
1801     }
1802 
1803     event MaxTokensCollectedDecreased(uint256 tierId, uint256 oldValue, uint256 amount);
1804 
1805     constructor(
1806         uint256[] _emptyArray,
1807         uint256[4] _periods,
1808         uint256 _etherPriceInUSD
1809     ) public USDDateTiersPricingStrategy(_emptyArray, 18, _etherPriceInUSD) {
1810         //pre-ico
1811         tiers.push(Tier(0.75e5, 6247500e18, 0, 0, 0, 0, 100e5, _periods[0], _periods[1]));
1812         //public ico
1813         tiers.push(Tier(3e5, 32725000e18, 0, 0, 0, 0, 100e5, _periods[2], _periods[3]));
1814     }
1815 
1816     function getArrayOfTiers() public view returns (uint256[12] tiersData) {
1817         uint256 j = 0;
1818         for (uint256 i = 0; i < tiers.length; i++) {
1819             tiersData[j++] = uint256(tiers[i].tokenInUSD);
1820             tiersData[j++] = uint256(tiers[i].maxTokensCollected);
1821             tiersData[j++] = uint256(tiers[i].soldTierTokens);
1822             tiersData[j++] = uint256(tiers[i].minInvestInUSD);
1823             tiersData[j++] = uint256(tiers[i].startDate);
1824             tiersData[j++] = uint256(tiers[i].endDate);
1825         }
1826     }
1827 
1828     function updateTier(
1829         uint256 _tierId,
1830         uint256 _start,
1831         uint256 _end,
1832         uint256 _minInvest,
1833         uint256 _price,
1834         uint256 _bonusCap,
1835         uint256 _bonus,
1836         bool _updateLockNeeded
1837     ) public onlyOwner() {
1838         require(
1839             _start != 0 &&
1840             _price != 0 &&
1841             _start < _end &&
1842             _tierId < tiers.length
1843         );
1844 
1845         if (_updateLockNeeded) {
1846             agent.updateLockPeriod(_end);
1847         }
1848 
1849         Tier storage tier = tiers[_tierId];
1850         tier.tokenInUSD = _price;
1851         tier.minInvestInUSD = _minInvest;
1852         tier.startDate = _start;
1853         tier.endDate = _end;
1854         tier.bonusCap = _bonusCap;
1855         tier.bonusPercents = _bonus;
1856     }
1857 
1858     function setCrowdsaleAgent(CHLAgent _crowdsaleAgent) public onlyOwner {
1859         agent = _crowdsaleAgent;
1860     }
1861 
1862     function updateTierTokens(uint256 _tierId, uint256 _soldTokens, uint256 _bonusTokens) public onlyAgent {
1863         require(_tierId < tiers.length && _soldTokens > 0);
1864 
1865         Tier storage tier = tiers[_tierId];
1866         tier.soldTierTokens = tier.soldTierTokens.add(_soldTokens);
1867         tier.bonusTierTokens = tier.bonusTierTokens.add(_bonusTokens);
1868     }
1869 
1870     function updateMaxTokensCollected(uint256 _tierId, uint256 _amount) public onlyAgent {
1871         require(_tierId < tiers.length && _amount > 0);
1872 
1873         Tier storage tier = tiers[_tierId];
1874 
1875         require(tier.maxTokensCollected.sub(_amount) >= tier.soldTierTokens.add(tier.bonusTierTokens));
1876 
1877         emit MaxTokensCollectedDecreased(_tierId, tier.maxTokensCollected, _amount);
1878 
1879         tier.maxTokensCollected = tier.maxTokensCollected.sub(_amount);
1880     }
1881 
1882     function getTokensWithoutRestrictions(uint256 _usdAmount) public view returns (
1883         uint256 tokens,
1884         uint256 tokensExcludingBonus,
1885         uint256 bonus
1886     ) {
1887         if (_usdAmount == 0) {
1888             return (0, 0, 0);
1889         }
1890 
1891         uint256 tierIndex = getActualTierIndex();
1892 
1893         tokensExcludingBonus = _usdAmount.mul(1e18).div(getTokensInUSD(tierIndex));
1894         bonus = calculateBonusAmount(tierIndex, tokensExcludingBonus);
1895         tokens = tokensExcludingBonus.add(bonus);
1896     }
1897 
1898     function getTierUnsoldTokens(uint256 _tierId) public view returns (uint256) {
1899         if (_tierId >= tiers.length) {
1900             return 0;
1901         }
1902 
1903         return tiers[_tierId].maxTokensCollected.sub(tiers[_tierId].soldTierTokens);
1904     }
1905 
1906     function getSaleEndDate() public view returns (uint256) {
1907         return tiers[tiers.length.sub(1)].endDate;
1908     }
1909 
1910 }
1911 contract Referral is Ownable {
1912 
1913     using SafeMath for uint256;
1914 
1915     MintableTokenAllocator public allocator;
1916     CrowdsaleImpl public crowdsale;
1917 
1918     uint256 public constant DECIMALS = 18;
1919 
1920     uint256 public totalSupply;
1921     bool public unLimited;
1922     bool public sentOnce;
1923 
1924     mapping(address => bool) public claimed;
1925     mapping(address => uint256) public claimedBalances;
1926 
1927     constructor(
1928         uint256 _totalSupply,
1929         address _allocator,
1930         address _crowdsale,
1931         bool _sentOnce
1932     ) public {
1933         require(_allocator != address(0) && _crowdsale != address(0));
1934         totalSupply = _totalSupply;
1935         if (totalSupply == 0) {
1936             unLimited = true;
1937         }
1938         allocator = MintableTokenAllocator(_allocator);
1939         crowdsale = CrowdsaleImpl(_crowdsale);
1940         sentOnce = _sentOnce;
1941     }
1942 
1943     function setAllocator(address _allocator) public onlyOwner {
1944         if (_allocator != address(0)) {
1945             allocator = MintableTokenAllocator(_allocator);
1946         }
1947     }
1948 
1949     function setCrowdsale(address _crowdsale) public onlyOwner {
1950         require(_crowdsale != address(0));
1951         crowdsale = CrowdsaleImpl(_crowdsale);
1952     }
1953 
1954     function multivestMint(
1955         address _address,
1956         uint256 _amount,
1957         uint8 _v,
1958         bytes32 _r,
1959         bytes32 _s
1960     ) public {
1961         require(true == crowdsale.signers(verify(msg.sender, _amount, _v, _r, _s)));
1962         if (true == sentOnce) {
1963             require(claimed[_address] == false);
1964             claimed[_address] = true;
1965         }
1966         require(
1967             _address == msg.sender &&
1968             _amount > 0 &&
1969             (true == unLimited || _amount <= totalSupply)
1970         );
1971         claimedBalances[_address] = claimedBalances[_address].add(_amount);
1972         if (false == unLimited) {
1973             totalSupply = totalSupply.sub(_amount);
1974         }
1975         allocator.allocate(_address, _amount);
1976     }
1977 
1978     /// @notice check sign
1979     function verify(address _sender, uint256 _amount, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address) {
1980         bytes32 hash = keccak256(abi.encodePacked(_sender, _amount));
1981 
1982         bytes memory prefix = '\x19Ethereum Signed Message:\n32';
1983 
1984         return ecrecover(keccak256(abi.encodePacked(prefix, hash)), _v, _r, _s);
1985     }
1986 
1987 }
1988 contract CHLReferral is Referral {
1989 
1990     CHLPricingStrategy public pricingStrategy;
1991 
1992     constructor(
1993         address _allocator,
1994         address _crowdsale,
1995         CHLPricingStrategy _strategy
1996     ) public Referral(1190000e18, _allocator, _crowdsale, true) {
1997         require(_strategy != address(0));
1998         pricingStrategy = _strategy;
1999     }
2000 
2001     function multivestMint(
2002         address _address,
2003         uint256 _amount,
2004         uint8 _v,
2005         bytes32 _r,
2006         bytes32 _s
2007     ) public {
2008         require(pricingStrategy.getSaleEndDate() <= block.timestamp);
2009         super.multivestMint(_address, _amount, _v, _r, _s);
2010     }
2011 }
2012 contract CHLAllocation is Ownable {
2013 
2014     using SafeMath for uint256;
2015 
2016     MintableTokenAllocator public allocator;
2017 
2018     CHLAgent public agent;
2019     //manualMintingSupply = Advisors 2975000 + Bounty 1785000 + LWL (Non Profit Initiative) 1190000
2020     uint256 public manualMintingSupply = 5950000e18;
2021 
2022     uint256 public foundersVestingAmountPeriodOne = 7140000e18;
2023     uint256 public foundersVestingAmountPeriodTwo = 2975000e18;
2024     uint256 public foundersVestingAmountPeriodThree = 1785000e18;
2025 
2026     address[] public vestings;
2027 
2028     address public foundersAddress;
2029 
2030     bool public isFoundersTokensSent;
2031 
2032     event VestingCreated(
2033         address _vesting,
2034         address _beneficiary,
2035         uint256 _start,
2036         uint256 _cliff,
2037         uint256 _duration,
2038         uint256 _periods,
2039         bool _revocable
2040     );
2041 
2042     event VestingRevoked(address _vesting);
2043 
2044     constructor(MintableTokenAllocator _allocator, address _foundersAddress) public {
2045         require(_foundersAddress != address(0));
2046         foundersAddress = _foundersAddress;
2047         allocator = _allocator;
2048     }
2049 
2050     function setAllocator(MintableTokenAllocator _allocator) public onlyOwner {
2051         require(_allocator != address(0));
2052         allocator = _allocator;
2053     }
2054 
2055     function setAgent(CHLAgent _agent) public onlyOwner {
2056         require(_agent != address(0));
2057         agent = _agent;
2058     }
2059 
2060     function allocateManualMintingTokens(address[] _addresses, uint256[] _tokens) public onlyOwner {
2061         require(_addresses.length == _tokens.length);
2062         for (uint256 i = 0; i < _addresses.length; i++) {
2063             require(_addresses[i] != address(0) && _tokens[i] > 0 && _tokens[i] <= manualMintingSupply);
2064             manualMintingSupply -= _tokens[i];
2065 
2066             allocator.allocate(_addresses[i], _tokens[i]);
2067         }
2068     }
2069 
2070     function allocatePrivateSaleTokens(
2071         uint256 _tierId,
2072         uint256 _totalTokensSupply,
2073         uint256 _tokenPriceInUsd,
2074         address[] _addresses,
2075         uint256[] _tokens
2076     ) public onlyOwner {
2077         require(
2078             _addresses.length == _tokens.length &&
2079             _totalTokensSupply > 0
2080         );
2081 
2082         agent.updateStateWithPrivateSale(_tierId, _totalTokensSupply, _totalTokensSupply.mul(_tokenPriceInUsd).div(1e18));
2083 
2084         for (uint256 i = 0; i < _addresses.length; i++) {
2085             require(_addresses[i] != address(0) && _tokens[i] > 0 && _tokens[i] <= _totalTokensSupply);
2086             _totalTokensSupply = _totalTokensSupply.sub(_tokens[i]);
2087 
2088             allocator.allocate(_addresses[i], _tokens[i]);
2089         }
2090 
2091         require(_totalTokensSupply == 0);
2092     }
2093 
2094     function allocateFoundersTokens(uint256 _start) public {
2095         require(!isFoundersTokensSent && msg.sender == address(agent));
2096 
2097         isFoundersTokensSent = true;
2098 
2099         allocator.allocate(foundersAddress, foundersVestingAmountPeriodOne);
2100 
2101         createVestingInternal(
2102             foundersAddress,
2103             _start,
2104             0,
2105             365 days,
2106             1,
2107             true,
2108             owner,
2109             foundersVestingAmountPeriodTwo
2110         );
2111 
2112         createVestingInternal(
2113             foundersAddress,
2114             _start,
2115             0,
2116             730 days,
2117             1,
2118             true,
2119             owner,
2120             foundersVestingAmountPeriodThree
2121         );
2122     }
2123 
2124     function createVesting(
2125         address _beneficiary,
2126         uint256 _start,
2127         uint256 _cliff,
2128         uint256 _duration,
2129         uint256 _periods,
2130         bool _revocable,
2131         address _unreleasedHolder,
2132         uint256 _amount
2133     ) public onlyOwner returns (PeriodicTokenVesting vesting) {
2134 
2135         vesting = createVestingInternal(
2136             _beneficiary,
2137             _start,
2138             _cliff,
2139             _duration,
2140             _periods,
2141             _revocable,
2142             _unreleasedHolder,
2143             _amount
2144         );
2145     }
2146 
2147     function revokeVesting(PeriodicTokenVesting _vesting, ERC20Basic token) public onlyOwner() {
2148         _vesting.revoke(token);
2149 
2150         emit VestingRevoked(_vesting);
2151     }
2152 
2153     function createVestingInternal(
2154         address _beneficiary,
2155         uint256 _start,
2156         uint256 _cliff,
2157         uint256 _duration,
2158         uint256 _periods,
2159         bool _revocable,
2160         address _unreleasedHolder,
2161         uint256 _amount
2162     ) internal returns (PeriodicTokenVesting) {
2163         PeriodicTokenVesting vesting = new PeriodicTokenVesting(
2164             _beneficiary, _start, _cliff, _duration, _periods, _revocable, _unreleasedHolder
2165         );
2166 
2167         vestings.push(vesting);
2168 
2169         emit VestingCreated(vesting, _beneficiary, _start, _cliff, _duration, _periods, _revocable);
2170 
2171         allocator.allocate(address(vesting), _amount);
2172 
2173         return vesting;
2174     }
2175 
2176 }
2177 /**
2178  * @title TokenVesting
2179  * @dev A token holder contract that can release its token balance gradually like a
2180  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
2181  * owner.
2182  */
2183 contract TokenVesting is Ownable {
2184   using SafeMath for uint256;
2185   using SafeERC20 for ERC20Basic;
2186 
2187   event Released(uint256 amount);
2188   event Revoked();
2189 
2190   // beneficiary of tokens after they are released
2191   address public beneficiary;
2192 
2193   uint256 public cliff;
2194   uint256 public start;
2195   uint256 public duration;
2196 
2197   bool public revocable;
2198 
2199   mapping (address => uint256) public released;
2200   mapping (address => bool) public revoked;
2201 
2202   /**
2203    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
2204    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
2205    * of the balance will have vested.
2206    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
2207    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
2208    * @param _start the time (as Unix time) at which point vesting starts 
2209    * @param _duration duration in seconds of the period in which the tokens will vest
2210    * @param _revocable whether the vesting is revocable or not
2211    */
2212   constructor(
2213     address _beneficiary,
2214     uint256 _start,
2215     uint256 _cliff,
2216     uint256 _duration,
2217     bool _revocable
2218   )
2219     public
2220   {
2221     require(_beneficiary != address(0));
2222     require(_cliff <= _duration);
2223 
2224     beneficiary = _beneficiary;
2225     revocable = _revocable;
2226     duration = _duration;
2227     cliff = _start.add(_cliff);
2228     start = _start;
2229   }
2230 
2231   /**
2232    * @notice Transfers vested tokens to beneficiary.
2233    * @param token ERC20 token which is being vested
2234    */
2235   function release(ERC20Basic token) public {
2236     uint256 unreleased = releasableAmount(token);
2237 
2238     require(unreleased > 0);
2239 
2240     released[token] = released[token].add(unreleased);
2241 
2242     token.safeTransfer(beneficiary, unreleased);
2243 
2244     emit Released(unreleased);
2245   }
2246 
2247   /**
2248    * @notice Allows the owner to revoke the vesting. Tokens already vested
2249    * remain in the contract, the rest are returned to the owner.
2250    * @param token ERC20 token which is being vested
2251    */
2252   function revoke(ERC20Basic token) public onlyOwner {
2253     require(revocable);
2254     require(!revoked[token]);
2255 
2256     uint256 balance = token.balanceOf(this);
2257 
2258     uint256 unreleased = releasableAmount(token);
2259     uint256 refund = balance.sub(unreleased);
2260 
2261     revoked[token] = true;
2262 
2263     token.safeTransfer(owner, refund);
2264 
2265     emit Revoked();
2266   }
2267 
2268   /**
2269    * @dev Calculates the amount that has already vested but hasn't been released yet.
2270    * @param token ERC20 token which is being vested
2271    */
2272   function releasableAmount(ERC20Basic token) public view returns (uint256) {
2273     return vestedAmount(token).sub(released[token]);
2274   }
2275 
2276   /**
2277    * @dev Calculates the amount that has already vested.
2278    * @param token ERC20 token which is being vested
2279    */
2280   function vestedAmount(ERC20Basic token) public view returns (uint256) {
2281     uint256 currentBalance = token.balanceOf(this);
2282     uint256 totalBalance = currentBalance.add(released[token]);
2283 
2284     if (block.timestamp < cliff) {
2285       return 0;
2286     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
2287       return totalBalance;
2288     } else {
2289       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
2290     }
2291   }
2292 }
2293 contract PeriodicTokenVesting is TokenVesting {
2294     address public unreleasedHolder;
2295     uint256 public periods;
2296 
2297     constructor(
2298         address _beneficiary,
2299         uint256 _start,
2300         uint256 _cliff,
2301         uint256 _periodDuration,
2302         uint256 _periods,
2303         bool _revocable,
2304         address _unreleasedHolder
2305     ) public TokenVesting(_beneficiary, _start, _cliff, _periodDuration, _revocable) {
2306         require(_revocable == false || _unreleasedHolder != address(0));
2307         periods = _periods;
2308         unreleasedHolder = _unreleasedHolder;
2309     }
2310 
2311     /**
2312     * @dev Calculates the amount that has already vested.
2313     * @param token ERC20 token which is being vested
2314     */
2315     function vestedAmount(ERC20Basic token) public view returns (uint256) {
2316         uint256 currentBalance = token.balanceOf(this);
2317         uint256 totalBalance = currentBalance.add(released[token]);
2318 
2319         if (now < cliff) {
2320             return 0;
2321         } else if (now >= start.add(duration * periods) || revoked[token]) {
2322             return totalBalance;
2323         } else {
2324 
2325             uint256 periodTokens = totalBalance.div(periods);
2326 
2327             uint256 periodsOver = now.sub(start).div(duration);
2328 
2329             if (periodsOver >= periods) {
2330                 return totalBalance;
2331             }
2332 
2333             return periodTokens.mul(periodsOver);
2334         }
2335     }
2336 
2337     /**
2338  * @notice Allows the owner to revoke the vesting. Tokens already vested
2339  * remain in the contract, the rest are returned to the owner.
2340  * @param token ERC20 token which is being vested
2341  */
2342     function revoke(ERC20Basic token) public onlyOwner {
2343         require(revocable);
2344         require(!revoked[token]);
2345 
2346         uint256 balance = token.balanceOf(this);
2347 
2348         uint256 unreleased = releasableAmount(token);
2349         uint256 refund = balance.sub(unreleased);
2350 
2351         revoked[token] = true;
2352 
2353         token.safeTransfer(unreleasedHolder, refund);
2354 
2355         emit Revoked();
2356     }
2357 }
2358 contract Stats {
2359 
2360     using SafeMath for uint256;
2361 
2362     MintableToken public token;
2363     MintableTokenAllocator public allocator;
2364     CHLCrowdsale public crowdsale;
2365     CHLPricingStrategy public pricing;
2366 
2367     constructor(
2368         MintableToken _token,
2369         MintableTokenAllocator _allocator,
2370         CHLCrowdsale _crowdsale,
2371         CHLPricingStrategy _pricing
2372     ) public {
2373         token = _token;
2374         allocator = _allocator;
2375         crowdsale = _crowdsale;
2376         pricing = _pricing;
2377     }
2378 
2379     function getTokens(
2380         uint256 _type,
2381         uint256 _usdAmount
2382     ) public view returns (uint256 tokens, uint256 tokensExcludingBonus, uint256 bonus) {
2383         _type = _type;
2384 
2385         return pricing.getTokensWithoutRestrictions(_usdAmount);
2386     }
2387 
2388     function getWeis(
2389         uint256 _type,
2390         uint256 _tokenAmount
2391     ) public view returns (uint256 totalWeiAmount, uint256 tokensBonus) {
2392         _type = _type;
2393 
2394         return pricing.getWeis(0, 0, _tokenAmount);
2395     }
2396 
2397     function getUSDAmount(
2398         uint256 _type,
2399         uint256 _tokenAmount
2400     ) public view returns (uint256 totalUSDAmount, uint256 tokensBonus) {
2401         _type = _type;
2402 
2403         return pricing.getUSDAmountByTokens(_tokenAmount);
2404     }
2405 
2406     function getStats(uint256 _userType, uint256[7] _ethPerCurrency) public view returns (
2407         uint256[8] stats,
2408         uint256[26] tiersData,
2409         uint256[21] currencyContr //tokensPerEachCurrency,
2410     ) {
2411         stats = getStatsData(_userType);
2412         tiersData = getTiersData(_userType);
2413         currencyContr = getCurrencyContrData(_userType, _ethPerCurrency);
2414     }
2415 
2416     function getTiersData(uint256 _type) public view returns (
2417         uint256[26] tiersData
2418     ) {
2419         _type = _type;
2420         uint256[12] memory tiers = pricing.getArrayOfTiers();
2421         uint256 length = tiers.length / 6;
2422 
2423         uint256 j = 0;
2424         for (uint256 i = 0; i < length; i++) {
2425             tiersData[j++] = uint256(1e23).div(tiers[i.mul(6)]);// tokenInUSD;
2426             tiersData[j++] = 0;// tokenInWei;
2427             tiersData[j++] = uint256(tiers[i.mul(6).add(1)]);// maxTokensCollected;
2428             tiersData[j++] = uint256(tiers[i.mul(6).add(2)]);// soldTierTokens;
2429             tiersData[j++] = 0;// discountPercents;
2430             tiersData[j++] = 0;// bonusPercents;
2431             tiersData[j++] = uint256(tiers[i.mul(6).add(3)]);// minInvestInUSD;
2432             tiersData[j++] = 0;// minInvestInWei;
2433             tiersData[j++] = 0;// maxInvestInUSD;
2434             tiersData[j++] = 0;// maxInvestInWei;
2435             tiersData[j++] = uint256(tiers[i.mul(6).add(4)]); // startDate;
2436             tiersData[j++] = uint256(tiers[i.mul(6).add(5)]); // endDate;
2437             tiersData[j++] = 1;
2438         }
2439 
2440         tiersData[25] = 2;
2441 
2442     }
2443 
2444     function getStatsData(uint256 _type) public view returns (
2445         uint256[8] stats
2446     ) {
2447         _type = _type;
2448         stats[0] = token.maxSupply();
2449         stats[1] = token.totalSupply();
2450         stats[2] = crowdsale.maxSaleSupply();
2451         stats[3] = crowdsale.tokensSold();
2452         stats[4] = uint256(crowdsale.currentState());
2453         stats[5] = pricing.getActualTierIndex();
2454         stats[6] = pricing.getTierUnsoldTokens(stats[5]);
2455         stats[7] = pricing.getMinEtherInvest(stats[5]);
2456     }
2457 
2458     function getCurrencyContrData(uint256 _type, uint256[7] _usdPerCurrency) public view returns (
2459         uint256[21] currencyContr
2460     ) {
2461         _type = _type;
2462         uint256 j = 0;
2463         for (uint256 i = 0; i < _usdPerCurrency.length; i++) {
2464             (currencyContr[j++], currencyContr[j++], currencyContr[j++]) = pricing.getTokensWithoutRestrictions(
2465                 _usdPerCurrency[i]
2466             );
2467         }
2468     }
2469 }