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
417         emit Mint(_holder, _tokens);
418     }
419 
420     /// @notice update allowedMinting flat
421     function disableMinting() public onlyStateChangeAgents() {
422         allowedMinting = false;
423     }
424 
425     /// @notice update minting agent
426     function updateMintingAgent(address _agent, bool _status) public onlyOwner {
427         mintingAgents[_agent] = _status;
428     }
429 
430     /// @notice update state change agent
431     function updateStateChangeAgent(address _agent, bool _status) public onlyOwner {
432         stateChangeAgents[_agent] = _status;
433     }
434 
435     /// @return available tokens
436     function availableTokens() public view returns (uint256 tokens) {
437         return maxSupply.sub(totalSupply_);
438     }
439 }
440 /// @title MintableBurnableToken
441 /// @author Applicature
442 /// @notice helper mixed to other contracts to burn tokens
443 /// @dev implementation
444 contract MintableBurnableToken is MintableToken, BurnableToken {
445 
446     mapping (address => bool) public burnAgents;
447 
448     modifier onlyBurnAgents () {
449         require(burnAgents[msg.sender]);
450         _;
451     }
452 
453     event Burn(address indexed burner, uint256 value);
454 
455     constructor(
456         uint256 _maxSupply,
457         uint256 _mintedSupply,
458         bool _allowedMinting
459     ) public MintableToken(
460         _maxSupply,
461         _mintedSupply,
462         _allowedMinting
463     ) {
464 
465     }
466 
467     /// @notice update minting agent
468     function updateBurnAgent(address _agent, bool _status) public onlyOwner {
469         burnAgents[_agent] = _status;
470     }
471 
472     function burnByAgent(address _holder, uint256 _tokensToBurn) public onlyBurnAgents() returns (uint256) {
473         if (_tokensToBurn == 0) {
474             _tokensToBurn = balanceOf(_holder);
475         }
476         _burn(_holder, _tokensToBurn);
477 
478         return _tokensToBurn;
479     }
480 
481     function _burn(address _who, uint256 _value) internal {
482         require(_value <= balances[_who]);
483         // no need to require value <= totalSupply, since that would imply the
484         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
485 
486         balances[_who] = balances[_who].sub(_value);
487         totalSupply_ = totalSupply_.sub(_value);
488         maxSupply = maxSupply.sub(_value);
489         emit Burn(_who, _value);
490         emit Transfer(_who, address(0), _value);
491     }
492 }
493 /// @title TimeLocked
494 /// @author Applicature
495 /// @notice helper mixed to other contracts to lock contract on a timestamp
496 /// @dev Base class
497 contract TimeLocked {
498     uint256 public time;
499     mapping(address => bool) public excludedAddresses;
500 
501     modifier isTimeLocked(address _holder, bool _timeLocked) {
502         bool locked = (block.timestamp < time);
503         require(excludedAddresses[_holder] == true || locked == _timeLocked);
504         _;
505     }
506 
507     constructor(uint256 _time) public {
508         time = _time;
509     }
510 
511     function updateExcludedAddress(address _address, bool _status) public;
512 }
513 /// @title TimeLockedToken
514 /// @author Applicature
515 /// @notice helper mixed to other contracts to lock contract on a timestamp
516 /// @dev Base class
517 contract TimeLockedToken is TimeLocked, StandardToken {
518 
519     constructor(uint256 _time) public TimeLocked(_time) {}
520 
521     function transfer(address _to, uint256 _tokens) public isTimeLocked(msg.sender, false) returns (bool) {
522         return super.transfer(_to, _tokens);
523     }
524 
525     function transferFrom(
526         address _holder,
527         address _to,
528         uint256 _tokens
529     ) public isTimeLocked(_holder, false) returns (bool) {
530         return super.transferFrom(_holder, _to, _tokens);
531     }
532 }
533 contract CHLToken is OpenZeppelinERC20, MintableBurnableToken, TimeLockedToken {
534 
535     CHLCrowdsale public crowdsale;
536 
537     bool public isSoftCapAchieved;
538 
539     //_unlockTokensTime - Lockup 3 months after end of the ICO
540     constructor(uint256 _unlockTokensTime) public
541     OpenZeppelinERC20(0, 'ChelleCoin', 18, 'CHL', false)
542     MintableBurnableToken(59500000e18, 0, true)
543     TimeLockedToken(_unlockTokensTime) {
544 
545     }
546 
547     function updateMaxSupply(uint256 _newMaxSupply) public onlyOwner {
548         require(_newMaxSupply > 0);
549         maxSupply = _newMaxSupply;
550     }
551 
552     function updateExcludedAddress(address _address, bool _status) public onlyOwner {
553         excludedAddresses[_address] = _status;
554     }
555 
556     function setCrowdSale(address _crowdsale) public onlyOwner {
557         require(_crowdsale != address(0));
558         crowdsale = CHLCrowdsale(_crowdsale);
559     }
560 
561     function setUnlockTime(uint256 _unlockTokensTime) public onlyStateChangeAgents {
562         time = _unlockTokensTime;
563     }
564 
565     function setIsSoftCapAchieved() public onlyStateChangeAgents {
566         isSoftCapAchieved = true;
567     }
568 
569     function transfer(address _to, uint256 _tokens) public returns (bool) {
570         require(true == isTransferAllowed(msg.sender, _tokens));
571         return super.transfer(_to, _tokens);
572     }
573 
574     function transferFrom(address _holder, address _to, uint256 _tokens) public returns (bool) {
575         require(true == isTransferAllowed(_holder, _tokens));
576         return super.transferFrom(_holder, _to, _tokens);
577     }
578 
579     function isTransferAllowed(address _address, uint256 _value) public view returns (bool) {
580         if (excludedAddresses[_address] == true) {
581             return true;
582         }
583 
584         if (!isSoftCapAchieved && (address(crowdsale) == address(0) || false == crowdsale.isSoftCapAchieved(0))) {
585             return false;
586         }
587 
588         return true;
589     }
590 
591     function burnUnsoldTokens(uint256 _tokensToBurn) public onlyBurnAgents() returns (uint256) {
592         require(totalSupply_.add(_tokensToBurn) <= maxSupply);
593 
594         maxSupply = maxSupply.sub(_tokensToBurn);
595 
596         emit Burn(address(0), _tokensToBurn);
597 
598         return _tokensToBurn;
599     }
600 
601 }
602 /// @title Agent
603 /// @author Applicature
604 /// @notice Contract which takes actions on state change and contribution
605 /// @dev Base class
606 contract Agent {
607     using SafeMath for uint256;
608 
609     function isInitialized() public constant returns (bool) {
610         return false;
611     }
612 }
613 /// @title CrowdsaleAgent
614 /// @author Applicature
615 /// @notice Contract which takes actions on state change and contribution
616 /// @dev Base class
617 contract CrowdsaleAgent is Agent {
618 
619 
620     Crowdsale public crowdsale;
621     bool public _isInitialized;
622 
623     modifier onlyCrowdsale() {
624         require(msg.sender == address(crowdsale));
625         _;
626     }
627 
628     constructor(Crowdsale _crowdsale) public {
629         crowdsale = _crowdsale;
630 
631         if (address(0) != address(_crowdsale)) {
632             _isInitialized = true;
633         } else {
634             _isInitialized = false;
635         }
636     }
637 
638     function isInitialized() public constant returns (bool) {
639         return _isInitialized;
640     }
641 
642     function onContribution(address _contributor, uint256 _weiAmount, uint256 _tokens, uint256 _bonus)
643         public onlyCrowdsale();
644 
645     function onStateChange(Crowdsale.State _state) public onlyCrowdsale();
646 
647     function onRefund(address _contributor, uint256 _tokens) public onlyCrowdsale() returns (uint256 burned);
648 }
649 /// @title MintableCrowdsaleOnSuccessAgent
650 /// @author Applicature
651 /// @notice Contract which takes actions on state change and contribution
652 /// un-pause tokens and disable minting on Crowdsale success
653 /// @dev implementation
654 contract MintableCrowdsaleOnSuccessAgent is CrowdsaleAgent {
655 
656     Crowdsale public crowdsale;
657     MintableToken public token;
658     bool public _isInitialized;
659 
660     constructor(Crowdsale _crowdsale, MintableToken _token) public CrowdsaleAgent(_crowdsale) {
661         crowdsale = _crowdsale;
662         token = _token;
663 
664         if (address(0) != address(_token) &&
665         address(0) != address(_crowdsale)) {
666             _isInitialized = true;
667         } else {
668             _isInitialized = false;
669         }
670     }
671 
672     /// @notice Check whether contract is initialised
673     /// @return true if initialized
674     function isInitialized() public constant returns (bool) {
675         return _isInitialized;
676     }
677 
678     /// @notice Takes actions on contribution
679     function onContribution(address _contributor, uint256 _weiAmount, uint256 _tokens, uint256 _bonus)
680     public onlyCrowdsale() {
681         _contributor = _contributor;
682         _weiAmount = _weiAmount;
683         _tokens = _tokens;
684         _bonus = _bonus;
685         // TODO: add impl
686     }
687 
688     /// @notice Takes actions on state change,
689     /// un-pause tokens and disable minting on Crowdsale success
690     /// @param _state Crowdsale.State
691     function onStateChange(Crowdsale.State _state) public onlyCrowdsale() {
692         if (_state == Crowdsale.State.Success) {
693             token.disableMinting();
694         }
695     }
696 
697     function onRefund(address _contributor, uint256 _tokens) public onlyCrowdsale() returns (uint256 burned) {
698         _contributor = _contributor;
699         _tokens = _tokens;
700     }
701 }
702 contract CHLAgent is MintableCrowdsaleOnSuccessAgent, Ownable {
703 
704     CHLPricingStrategy public strategy;
705     CHLCrowdsale public crowdsale;
706     CHLAllocation public allocation;
707 
708     bool public isEndProcessed;
709 
710     constructor(
711         CHLCrowdsale _crowdsale,
712         CHLToken _token,
713         CHLPricingStrategy _strategy,
714         CHLAllocation _allocation
715     ) public MintableCrowdsaleOnSuccessAgent(_crowdsale, _token) {
716         strategy = _strategy;
717         crowdsale = _crowdsale;
718         allocation = _allocation;
719     }
720 
721     /// @notice update pricing strategy
722     function setPricingStrategy(CHLPricingStrategy _strategy) public onlyOwner {
723         strategy = _strategy;
724     }
725 
726     /// @notice update allocation
727     function setAllocation(CHLAllocation _allocation) public onlyOwner {
728         allocation = _allocation;
729     }
730 
731     function burnUnsoldTokens(uint256 _tierId) public onlyOwner {
732         uint256 tierUnsoldTokensAmount = strategy.getTierUnsoldTokens(_tierId);
733         require(tierUnsoldTokensAmount > 0);
734 
735         CHLToken(token).burnUnsoldTokens(tierUnsoldTokensAmount);
736     }
737 
738     /// @notice Takes actions on contribution
739     function onContribution(
740         address,
741         uint256 _tierId,
742         uint256 _tokens,
743         uint256 _bonus
744     ) public onlyCrowdsale() {
745         strategy.updateTierTokens(_tierId, _tokens, _bonus);
746     }
747 
748     function onStateChange(Crowdsale.State _state) public onlyCrowdsale() {
749         CHLToken chlToken = CHLToken(token);
750         if (
751             chlToken.isSoftCapAchieved() == false
752             && (_state == Crowdsale.State.Success || _state == Crowdsale.State.Finalized)
753             && crowdsale.isSoftCapAchieved(0)
754         ) {
755             chlToken.setIsSoftCapAchieved();
756         }
757 
758         if (_state > Crowdsale.State.InCrowdsale && isEndProcessed == false) {
759             allocation.allocateFoundersTokens(strategy.getSaleEndDate());
760         }
761     }
762 
763     function onRefund(address _contributor, uint256 _tokens) public onlyCrowdsale() returns (uint256 burned) {
764         burned = CHLToken(token).burnByAgent(_contributor, _tokens);
765     }
766 
767     function updateStateWithPrivateSale(
768         uint256 _tierId,
769         uint256 _tokensAmount,
770         uint256 _usdAmount
771     ) public {
772         require(msg.sender == address(allocation));
773 
774         strategy.updateMaxTokensCollected(_tierId, _tokensAmount);
775         crowdsale.updateStatsVars(_usdAmount, _tokensAmount);
776     }
777 
778     function updateLockPeriod(uint256 _time) public {
779         require(msg.sender == address(strategy));
780         CHLToken(token).setUnlockTime(_time.add(12 weeks));
781     }
782 
783 }
784 /// @title TokenAllocator
785 /// @author Applicature
786 /// @notice Contract responsible for defining distribution logic of tokens.
787 /// @dev Base class
788 contract TokenAllocator is Ownable {
789 
790 
791     mapping(address => bool) public crowdsales;
792 
793     modifier onlyCrowdsale() {
794         require(crowdsales[msg.sender]);
795         _;
796     }
797 
798     function addCrowdsales(address _address) public onlyOwner {
799         crowdsales[_address] = true;
800     }
801 
802     function removeCrowdsales(address _address) public onlyOwner {
803         crowdsales[_address] = false;
804     }
805 
806     function isInitialized() public constant returns (bool) {
807         return false;
808     }
809 
810     function allocate(address _holder, uint256 _tokens) public onlyCrowdsale() {
811         internalAllocate(_holder, _tokens);
812     }
813 
814     function tokensAvailable() public constant returns (uint256);
815 
816     function internalAllocate(address _holder, uint256 _tokens) internal onlyCrowdsale();
817 }
818 /// @title MintableTokenAllocator
819 /// @author Applicature
820 /// @notice Contract responsible for defining distribution logic of tokens.
821 /// @dev implementation
822 contract MintableTokenAllocator is TokenAllocator {
823 
824     using SafeMath for uint256;
825 
826     MintableToken public token;
827 
828     constructor(MintableToken _token) public {
829         require(address(0) != address(_token));
830         token = _token;
831     }
832 
833     /// @return available tokens
834     function tokensAvailable() public constant returns (uint256) {
835         return token.availableTokens();
836     }
837 
838     /// @notice transfer tokens on holder account
839     function allocate(address _holder, uint256 _tokens) public onlyCrowdsale() {
840         internalAllocate(_holder, _tokens);
841     }
842 
843     /// @notice Check whether contract is initialised
844     /// @return true if initialized
845     function isInitialized() public constant returns (bool) {
846         return token.mintingAgents(this);
847     }
848 
849     /// @notice update instance of MintableToken
850     function setToken(MintableToken _token) public onlyOwner {
851         token = _token;
852     }
853 
854     function internalAllocate(address _holder, uint256 _tokens) internal {
855         token.mint(_holder, _tokens);
856     }
857 
858 }
859 /// @title ContributionForwarder
860 /// @author Applicature
861 /// @notice Contract is responsible for distributing collected ethers, that are received from CrowdSale.
862 /// @dev Base class
863 contract ContributionForwarder {
864 
865     using SafeMath for uint256;
866 
867     uint256 public weiCollected;
868     uint256 public weiForwarded;
869 
870     event ContributionForwarded(address receiver, uint256 weiAmount);
871 
872     function isInitialized() public constant returns (bool) {
873         return false;
874     }
875 
876     /// @notice transfer wei to receiver
877     function forward() public payable {
878         require(msg.value > 0);
879 
880         weiCollected += msg.value;
881 
882         internalForward();
883     }
884 
885     function internalForward() internal;
886 }
887 /// @title DistributedDirectContributionForwarder
888 /// @author Applicature
889 /// @notice Contract is responsible for distributing collected ethers, that are received from CrowdSale.
890 /// @dev implementation
891 contract DistributedDirectContributionForwarder is ContributionForwarder {
892     Receiver[] public receivers;
893     uint256 public proportionAbsMax;
894     bool public isInitialized_;
895 
896     struct Receiver {
897         address receiver;
898         uint256 proportion; // abslolute value in range of 0 - proportionAbsMax
899         uint256 forwardedWei;
900     }
901 
902     // @TODO: should we use uint256 [] for receivers & proportions?
903     constructor(uint256 _proportionAbsMax, address[] _receivers, uint256[] _proportions) public {
904         proportionAbsMax = _proportionAbsMax;
905 
906         require(_receivers.length == _proportions.length);
907 
908         require(_receivers.length > 0);
909 
910         uint256 totalProportion;
911 
912         for (uint256 i = 0; i < _receivers.length; i++) {
913             uint256 proportion = _proportions[i];
914 
915             totalProportion = totalProportion.add(proportion);
916 
917             receivers.push(Receiver(_receivers[i], proportion, 0));
918         }
919 
920         require(totalProportion == proportionAbsMax);
921         isInitialized_ = true;
922     }
923 
924     /// @notice Check whether contract is initialised
925     /// @return true if initialized
926     function isInitialized() public constant returns (bool) {
927         return isInitialized_;
928     }
929 
930     function internalForward() internal {
931         uint256 transferred;
932 
933         for (uint256 i = 0; i < receivers.length; i++) {
934             Receiver storage receiver = receivers[i];
935 
936             uint256 value = msg.value.mul(receiver.proportion).div(proportionAbsMax);
937 
938             if (i == receivers.length - 1) {
939                 value = msg.value.sub(transferred);
940             }
941 
942             transferred = transferred.add(value);
943 
944             receiver.receiver.transfer(value);
945 
946             emit ContributionForwarded(receiver.receiver, value);
947         }
948 
949         weiForwarded = weiForwarded.add(transferred);
950     }
951 }
952 contract Crowdsale {
953 
954     uint256 public tokensSold;
955 
956     enum State {Unknown, Initializing, BeforeCrowdsale, InCrowdsale, Success, Finalized, Refunding}
957 
958     function externalContribution(address _contributor, uint256 _wei) public payable;
959 
960     function contribute(uint8 _v, bytes32 _r, bytes32 _s) public payable;
961 
962     function updateState() public;
963 
964     function internalContribution(address _contributor, uint256 _wei) internal;
965 
966     function getState() public view returns (State);
967 
968 }
969 /// @title Crowdsale
970 /// @author Applicature
971 /// @notice Contract is responsible for collecting, refunding, allocating tokens during different stages of Crowdsale.
972 contract CrowdsaleImpl is Crowdsale, Ownable {
973 
974     using SafeMath for uint256;
975 
976     State public currentState;
977     TokenAllocator public allocator;
978     ContributionForwarder public contributionForwarder;
979     PricingStrategy public pricingStrategy;
980     CrowdsaleAgent public crowdsaleAgent;
981     bool public finalized;
982     uint256 public startDate;
983     uint256 public endDate;
984     bool public allowWhitelisted;
985     bool public allowSigned;
986     bool public allowAnonymous;
987     mapping(address => bool) public whitelisted;
988     mapping(address => bool) public signers;
989     mapping(address => bool) public externalContributionAgents;
990 
991     event Contribution(address _contributor, uint256 _wei, uint256 _tokensExcludingBonus, uint256 _bonus);
992 
993     constructor(
994         TokenAllocator _allocator,
995         ContributionForwarder _contributionForwarder,
996         PricingStrategy _pricingStrategy,
997         uint256 _startDate,
998         uint256 _endDate,
999         bool _allowWhitelisted,
1000         bool _allowSigned,
1001         bool _allowAnonymous
1002     ) public {
1003         allocator = _allocator;
1004         contributionForwarder = _contributionForwarder;
1005         pricingStrategy = _pricingStrategy;
1006 
1007         startDate = _startDate;
1008         endDate = _endDate;
1009 
1010         allowWhitelisted = _allowWhitelisted;
1011         allowSigned = _allowSigned;
1012         allowAnonymous = _allowAnonymous;
1013 
1014         currentState = State.Unknown;
1015     }
1016 
1017     /// @notice default payable function
1018     function() public payable {
1019         require(allowWhitelisted || allowAnonymous);
1020 
1021         if (!allowAnonymous) {
1022             if (allowWhitelisted) {
1023                 require(whitelisted[msg.sender]);
1024             }
1025         }
1026 
1027         internalContribution(msg.sender, msg.value);
1028     }
1029 
1030     /// @notice update crowdsale agent
1031     function setCrowdsaleAgent(CrowdsaleAgent _crowdsaleAgent) public onlyOwner {
1032         crowdsaleAgent = _crowdsaleAgent;
1033     }
1034 
1035     /// @notice allows external user to do contribution
1036     function externalContribution(address _contributor, uint256 _wei) public payable {
1037         require(externalContributionAgents[msg.sender]);
1038         internalContribution(_contributor, _wei);
1039     }
1040 
1041     /// @notice update external contributor
1042     function addExternalContributor(address _contributor) public onlyOwner {
1043         externalContributionAgents[_contributor] = true;
1044     }
1045 
1046     /// @notice update external contributor
1047     function removeExternalContributor(address _contributor) public onlyOwner {
1048         externalContributionAgents[_contributor] = false;
1049     }
1050 
1051     /// @notice update whitelisting address
1052     function updateWhitelist(address _address, bool _status) public onlyOwner {
1053         whitelisted[_address] = _status;
1054     }
1055 
1056     /// @notice update signer
1057     function addSigner(address _signer) public onlyOwner {
1058         signers[_signer] = true;
1059     }
1060 
1061     /// @notice update signer
1062     function removeSigner(address _signer) public onlyOwner {
1063         signers[_signer] = false;
1064     }
1065 
1066     /// @notice allows to do signed contributions
1067     function contribute(uint8 _v, bytes32 _r, bytes32 _s) public payable {
1068         address recoveredAddress = verify(msg.sender, _v, _r, _s);
1069         require(signers[recoveredAddress]);
1070         internalContribution(msg.sender, msg.value);
1071     }
1072 
1073     /// @notice Crowdsale state
1074     function updateState() public {
1075         State state = getState();
1076 
1077         if (currentState != state) {
1078             if (crowdsaleAgent != address(0)) {
1079                 crowdsaleAgent.onStateChange(state);
1080             }
1081 
1082             currentState = state;
1083         }
1084     }
1085 
1086     function internalContribution(address _contributor, uint256 _wei) internal {
1087         require(getState() == State.InCrowdsale);
1088 
1089         uint256 tokensAvailable = allocator.tokensAvailable();
1090         uint256 collectedWei = contributionForwarder.weiCollected();
1091 
1092         uint256 tokens;
1093         uint256 tokensExcludingBonus;
1094         uint256 bonus;
1095 
1096         (tokens, tokensExcludingBonus, bonus) = pricingStrategy.getTokens(
1097             _contributor, tokensAvailable, tokensSold, _wei, collectedWei);
1098 
1099         require(tokens > 0 && tokens <= tokensAvailable);
1100         tokensSold = tokensSold.add(tokens);
1101 
1102         allocator.allocate(_contributor, tokens);
1103 
1104         if (msg.value > 0) {
1105             contributionForwarder.forward.value(msg.value)();
1106         }
1107 
1108         emit Contribution(_contributor, _wei, tokensExcludingBonus, bonus);
1109     }
1110 
1111     /// @notice check sign
1112     function verify(address _sender, uint8 _v, bytes32 _r, bytes32 _s) public view returns (address) {
1113         bytes32 hash = keccak256(abi.encodePacked(this, _sender));
1114 
1115         bytes memory prefix = '\x19Ethereum Signed Message:\n32';
1116 
1117         return ecrecover(keccak256(abi.encodePacked(prefix, hash)), _v, _r, _s);
1118     }
1119 
1120     /// @return Crowdsale state
1121     function getState() public view returns (State) {
1122         if (finalized) {
1123             return State.Finalized;
1124         } else if (allocator.isInitialized() == false) {
1125             return State.Initializing;
1126         } else if (contributionForwarder.isInitialized() == false) {
1127             return State.Initializing;
1128         } else if (pricingStrategy.isInitialized() == false) {
1129             return State.Initializing;
1130         } else if (block.timestamp < startDate) {
1131             return State.BeforeCrowdsale;
1132         } else if (block.timestamp >= startDate && block.timestamp <= endDate) {
1133             return State.InCrowdsale;
1134         } else if (block.timestamp > endDate) {
1135             return State.Success;
1136         }
1137 
1138         return State.Unknown;
1139     }
1140 }
1141 /// @title HardCappedCrowdsale
1142 /// @author Applicature
1143 /// @notice Contract is responsible for collecting, refunding, allocating tokens during different stages of Crowdsale.
1144 /// with hard limit
1145 contract HardCappedCrowdsale is CrowdsaleImpl {
1146 
1147     using SafeMath for uint256;
1148 
1149     uint256 public hardCap;
1150 
1151     constructor(
1152         TokenAllocator _allocator,
1153         ContributionForwarder _contributionForwarder,
1154         PricingStrategy _pricingStrategy,
1155         uint256 _startDate,
1156         uint256 _endDate,
1157         bool _allowWhitelisted,
1158         bool _allowSigned,
1159         bool _allowAnonymous,
1160         uint256 _hardCap
1161     ) public CrowdsaleImpl(
1162         _allocator,
1163         _contributionForwarder,
1164         _pricingStrategy,
1165         _startDate,
1166         _endDate,
1167         _allowWhitelisted,
1168         _allowSigned,
1169         _allowAnonymous
1170     ) {
1171         hardCap = _hardCap;
1172     }
1173 
1174     /// @return Crowdsale state
1175     function getState() public view returns (State) {
1176         State state = super.getState();
1177 
1178         if (state == State.InCrowdsale) {
1179             if (isHardCapAchieved(0)) {
1180                 return State.Success;
1181             }
1182         }
1183 
1184         return state;
1185     }
1186 
1187     function isHardCapAchieved(uint256 _value) public view returns (bool) {
1188         if (hardCap <= tokensSold.add(_value)) {
1189             return true;
1190         }
1191         return false;
1192     }
1193 
1194     function internalContribution(address _contributor, uint256 _wei) internal {
1195         require(getState() == State.InCrowdsale);
1196 
1197         uint256 tokensAvailable = allocator.tokensAvailable();
1198         uint256 collectedWei = contributionForwarder.weiCollected();
1199 
1200         uint256 tokens;
1201         uint256 tokensExcludingBonus;
1202         uint256 bonus;
1203 
1204         (tokens, tokensExcludingBonus, bonus) = pricingStrategy.getTokens(
1205             _contributor, tokensAvailable, tokensSold, _wei, collectedWei);
1206 
1207         require(tokens <= tokensAvailable && tokens > 0 && false == isHardCapAchieved(tokens.sub(1)));
1208 
1209         tokensSold = tokensSold.add(tokens);
1210 
1211         allocator.allocate(_contributor, tokens);
1212 
1213         if (msg.value > 0) {
1214             contributionForwarder.forward.value(msg.value)();
1215         }
1216         crowdsaleAgent.onContribution(_contributor, _wei, tokensExcludingBonus, bonus);
1217         emit Contribution(_contributor, _wei, tokensExcludingBonus, bonus);
1218     }
1219 }
1220 /// @title RefundableCrowdsale
1221 /// @author Applicature
1222 /// @notice Contract is responsible for collecting, refunding, allocating tokens during different stages of Crowdsale.
1223 /// with hard and soft limits
1224 contract RefundableCrowdsale is HardCappedCrowdsale {
1225 
1226     using SafeMath for uint256;
1227 
1228     uint256 public softCap;
1229     mapping(address => uint256) public contributorsWei;
1230     address[] public contributors;
1231 
1232     event Refund(address _holder, uint256 _wei, uint256 _tokens);
1233 
1234     constructor(
1235         TokenAllocator _allocator,
1236         ContributionForwarder _contributionForwarder,
1237         PricingStrategy _pricingStrategy,
1238         uint256 _startDate,
1239         uint256 _endDate,
1240         bool _allowWhitelisted,
1241         bool _allowSigned,
1242         bool _allowAnonymous,
1243         uint256 _softCap,
1244         uint256 _hardCap
1245 
1246     ) public HardCappedCrowdsale(
1247         _allocator, _contributionForwarder, _pricingStrategy,
1248         _startDate, _endDate,
1249         _allowWhitelisted, _allowSigned, _allowAnonymous, _hardCap
1250     ) {
1251         softCap = _softCap;
1252     }
1253 
1254     /// @notice refund ethers to contributor
1255     function refund() public {
1256         internalRefund(msg.sender);
1257     }
1258 
1259     /// @notice refund ethers to delegate
1260     function delegatedRefund(address _address) public {
1261         internalRefund(_address);
1262     }
1263 
1264     function internalContribution(address _contributor, uint256 _wei) internal {
1265         require(block.timestamp >= startDate && block.timestamp <= endDate);
1266 
1267         uint256 tokensAvailable = allocator.tokensAvailable();
1268         uint256 collectedWei = contributionForwarder.weiCollected();
1269 
1270         uint256 tokens;
1271         uint256 tokensExcludingBonus;
1272         uint256 bonus;
1273 
1274         (tokens, tokensExcludingBonus, bonus) = pricingStrategy.getTokens(
1275             _contributor, tokensAvailable, tokensSold, _wei, collectedWei);
1276 
1277         require(tokens <= tokensAvailable && tokens > 0 && hardCap > tokensSold.add(tokens));
1278 
1279         tokensSold = tokensSold.add(tokens);
1280 
1281         allocator.allocate(_contributor, tokens);
1282 
1283         // transfer only if softcap is reached
1284         if (isSoftCapAchieved(0)) {
1285             if (msg.value > 0) {
1286                 contributionForwarder.forward.value(address(this).balance)();
1287             }
1288         } else {
1289             // store contributor if it is not stored before
1290             if (contributorsWei[_contributor] == 0) {
1291                 contributors.push(_contributor);
1292             }
1293             contributorsWei[_contributor] = contributorsWei[_contributor].add(msg.value);
1294         }
1295         crowdsaleAgent.onContribution(_contributor, _wei, tokensExcludingBonus, bonus);
1296         emit Contribution(_contributor, _wei, tokensExcludingBonus, bonus);
1297     }
1298 
1299     function internalRefund(address _holder) internal {
1300         updateState();
1301         require(block.timestamp > endDate);
1302         require(!isSoftCapAchieved(0));
1303         require(crowdsaleAgent != address(0));
1304 
1305         uint256 value = contributorsWei[_holder];
1306 
1307         require(value > 0);
1308 
1309         contributorsWei[_holder] = 0;
1310         uint256 burnedTokens = crowdsaleAgent.onRefund(_holder, 0);
1311 
1312         _holder.transfer(value);
1313 
1314         emit Refund(_holder, value, burnedTokens);
1315     }
1316 
1317     /// @return Crowdsale state
1318     function getState() public view returns (State) {
1319         State state = super.getState();
1320 
1321         if (state == State.Success) {
1322             if (!isSoftCapAchieved(0)) {
1323                 return State.Refunding;
1324             }
1325         }
1326 
1327         return state;
1328     }
1329 
1330     function isSoftCapAchieved(uint256 _value) public view returns (bool) {
1331         if (softCap <= tokensSold.add(_value)) {
1332             return true;
1333         }
1334         return false;
1335     }
1336 }
1337 contract CHLCrowdsale is RefundableCrowdsale {
1338 
1339     uint256 public maxSaleSupply = 38972500e18;
1340 
1341     uint256 public usdCollected;
1342 
1343     address public processingFeeAddress;
1344     uint256 public percentageAbsMax = 1000;
1345     uint256 public processingFeePercentage = 25;
1346 
1347     event ProcessingFeeAllocation(address _contributor, uint256 _feeAmount);
1348 
1349     event Contribution(address _contributor, uint256 _usdAmount, uint256 _tokensExcludingBonus, uint256 _bonus);
1350 
1351     constructor(
1352         MintableTokenAllocator _allocator,
1353         DistributedDirectContributionForwarder _contributionForwarder,
1354         CHLPricingStrategy _pricingStrategy,
1355         uint256 _startTime,
1356         uint256 _endTime,
1357         address _processingFeeAddress
1358     ) public RefundableCrowdsale(
1359         _allocator,
1360         _contributionForwarder,
1361         _pricingStrategy,
1362         _startTime,
1363         _endTime,
1364         true,
1365         true,
1366         false,
1367         10000000e5,//softCap
1368         102860625e5//hardCap
1369     ) {
1370         require(_processingFeeAddress != address(0));
1371         processingFeeAddress = _processingFeeAddress;
1372     }
1373 
1374     function() public payable {
1375         require(allowWhitelisted || allowAnonymous);
1376 
1377         if (!allowAnonymous) {
1378             if (allowWhitelisted) {
1379                 require(whitelisted[msg.sender]);
1380             }
1381         }
1382 
1383         internalContribution(
1384             msg.sender,
1385             CHLPricingStrategy(pricingStrategy).getUSDAmountByWeis(msg.value)
1386         );
1387     }
1388 
1389     /// @notice allows to do signed contributions
1390     function contribute(uint8 _v, bytes32 _r, bytes32 _s) public payable {
1391         address recoveredAddress = verify(msg.sender, _v, _r, _s);
1392         require(signers[recoveredAddress]);
1393         internalContribution(
1394             msg.sender,
1395             CHLPricingStrategy(pricingStrategy).getUSDAmountByWeis(msg.value)
1396         );
1397     }
1398 
1399     /// @notice allows external user to do contribution
1400     function externalContribution(address _contributor, uint256 _usdAmount) public payable {
1401         require(externalContributionAgents[msg.sender]);
1402         internalContribution(_contributor, _usdAmount);
1403     }
1404 
1405     function updateState() public {
1406         (startDate, endDate) = CHLPricingStrategy(pricingStrategy).getActualDates();
1407         super.updateState();
1408     }
1409 
1410     function isHardCapAchieved(uint256 _value) public view returns (bool) {
1411         if (hardCap <= usdCollected.add(_value)) {
1412             return true;
1413         }
1414         return false;
1415     }
1416 
1417     function isSoftCapAchieved(uint256 _value) public view returns (bool) {
1418         if (softCap <= usdCollected.add(_value)) {
1419             return true;
1420         }
1421         return false;
1422     }
1423 
1424     function getUnsoldTokensAmount() public view returns (uint256) {
1425         return maxSaleSupply.sub(tokensSold);
1426     }
1427 
1428     function updateStatsVars(uint256 _usdAmount, uint256 _tokensAmount) public {
1429         require(msg.sender == address(crowdsaleAgent) && _tokensAmount > 0);
1430 
1431         tokensSold = tokensSold.add(_tokensAmount);
1432         usdCollected = usdCollected.add(_usdAmount);
1433     }
1434 
1435     function internalContribution(address _contributor, uint256 _usdAmount) internal {
1436         updateState();
1437 
1438         require(currentState == State.InCrowdsale);
1439 
1440         CHLPricingStrategy pricing = CHLPricingStrategy(pricingStrategy);
1441 
1442         require(!isHardCapAchieved(_usdAmount.sub(1)));
1443 
1444         uint256 tokensAvailable = allocator.tokensAvailable();
1445         uint256 collectedWei = contributionForwarder.weiCollected();
1446         uint256 tierIndex = pricing.getTierIndex();
1447         uint256 tokens;
1448         uint256 tokensExcludingBonus;
1449         uint256 bonus;
1450 
1451         (tokens, tokensExcludingBonus, bonus) = pricing.getTokens(
1452             _contributor, tokensAvailable, tokensSold, _usdAmount, collectedWei);
1453 
1454         require(tokens > 0);
1455 
1456         tokensSold = tokensSold.add(tokens);
1457 
1458         allocator.allocate(_contributor, tokens);
1459 
1460         //allocate Processing fee
1461         uint256 processingFeeAmount = tokens.mul(processingFeePercentage).div(percentageAbsMax);
1462         allocator.allocate(processingFeeAddress, processingFeeAmount);
1463 
1464         if (isSoftCapAchieved(_usdAmount)) {
1465             if (msg.value > 0) {
1466                 contributionForwarder.forward.value(address(this).balance)();
1467             }
1468         } else {
1469             // store contributor if it is not stored before
1470             if (contributorsWei[_contributor] == 0) {
1471                 contributors.push(_contributor);
1472             }
1473             if (msg.value > 0) {
1474                 contributorsWei[_contributor] = contributorsWei[_contributor].add(msg.value);
1475             }
1476         }
1477 
1478         usdCollected = usdCollected.add(_usdAmount);
1479 
1480         crowdsaleAgent.onContribution(_contributor, tierIndex, tokensExcludingBonus, bonus);
1481 
1482         emit Contribution(_contributor, _usdAmount, tokensExcludingBonus, bonus);
1483         emit ProcessingFeeAllocation(_contributor, processingFeeAmount);
1484     }
1485 
1486 }
1487 contract USDExchange is Ownable {
1488 
1489     using SafeMath for uint256;
1490 
1491     uint256 public etherPriceInUSD;
1492     uint256 public priceUpdateAt;
1493     mapping(address => bool) public trustedAddresses;
1494 
1495     event NewPriceTicker(string _price);
1496 
1497     modifier onlyTursted() {
1498         require(trustedAddresses[msg.sender] == true);
1499         _;
1500     }
1501 
1502     constructor(uint256 _etherPriceInUSD) public {
1503         etherPriceInUSD = _etherPriceInUSD;
1504         priceUpdateAt = block.timestamp;
1505         trustedAddresses[msg.sender] = true;
1506     }
1507 
1508     function setTrustedAddress(address _address, bool _status) public onlyOwner {
1509         trustedAddresses[_address] = _status;
1510     }
1511 
1512     // set ether price in USD with 5 digits after the decimal point
1513     //ex. 308.75000
1514     //for updating the price through  multivest
1515     function setEtherInUSD(string _price) public onlyTursted {
1516         bytes memory bytePrice = bytes(_price);
1517         uint256 dot = bytePrice.length.sub(uint256(6));
1518 
1519         // check if dot is in 6 position  from  the last
1520         require(0x2e == uint(bytePrice[dot]));
1521 
1522         uint256 newPrice = uint256(10 ** 23).div(parseInt(_price, 5));
1523 
1524         require(newPrice > 0);
1525 
1526         etherPriceInUSD = parseInt(_price, 5);
1527 
1528         priceUpdateAt = block.timestamp;
1529 
1530         emit NewPriceTicker(_price);
1531     }
1532 
1533     function parseInt(string _a, uint _b) internal pure returns (uint) {
1534         bytes memory bresult = bytes(_a);
1535         uint res = 0;
1536         bool decimals = false;
1537         for (uint i = 0; i < bresult.length; i++) {
1538             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
1539                 if (decimals) {
1540                     if (_b == 0) break;
1541                     else _b--;
1542                 }
1543                 res *= 10;
1544                 res += uint(bresult[i]) - 48;
1545             } else if (bresult[i] == 46) decimals = true;
1546         }
1547         if (_b > 0) res *= 10 ** _b;
1548         return res;
1549     }
1550 }
1551 /// @title PricingStrategy
1552 /// @author Applicature
1553 /// @notice Contract is responsible for calculating tokens amount depending on different criterias
1554 /// @dev Base class
1555 contract PricingStrategy {
1556 
1557     function isInitialized() public view returns (bool);
1558 
1559     function getTokens(
1560         address _contributor,
1561         uint256 _tokensAvailable,
1562         uint256 _tokensSold,
1563         uint256 _weiAmount,
1564         uint256 _collectedWei
1565     )
1566         public
1567         view
1568         returns (uint256 tokens, uint256 tokensExcludingBonus, uint256 bonus);
1569 
1570     function getWeis(
1571         uint256 _collectedWei,
1572         uint256 _tokensSold,
1573         uint256 _tokens
1574     )
1575         public
1576         view
1577         returns (uint256 weiAmount, uint256 tokensBonus);
1578 
1579 }
1580 /// @title USDDateTiersPricingStrategy
1581 /// @author Applicature
1582 /// @notice Contract is responsible for calculating tokens amount depending on price in USD
1583 /// @dev implementation
1584 contract USDDateTiersPricingStrategy is PricingStrategy, USDExchange {
1585 
1586     using SafeMath for uint256;
1587 
1588     //tokenInUSD token price in usd * 10 ^ 5
1589     //maxTokensCollected max tokens amount that can be distributed
1590     //bonusCap tokens amount cap; while sold tokens < bonus cap - contributors will receive bonus % tokens
1591     //soldTierTokens tokens that already been sold
1592     //bonusTierTokens bonus tokens that already been allocated
1593     //bonusPercents bonus percentage
1594     //minInvestInUSD min investment in usd * 10 * 5
1595     //startDate tier start time
1596     //endDate tier end time
1597     struct Tier {
1598         uint256 tokenInUSD;
1599         uint256 maxTokensCollected;
1600         uint256 bonusCap;
1601         uint256 soldTierTokens;
1602         uint256 bonusTierTokens;
1603         uint256 bonusPercents;
1604         uint256 minInvestInUSD;
1605         uint256 startDate;
1606         uint256 endDate;
1607     }
1608 
1609     Tier[] public tiers;
1610     uint256 public decimals;
1611 
1612     constructor(uint256[] _tiers, uint256 _decimals, uint256 _etherPriceInUSD) public USDExchange(_etherPriceInUSD) {
1613         decimals = _decimals;
1614         trustedAddresses[msg.sender] = true;
1615         require(_tiers.length % 9 == 0);
1616 
1617         uint256 length = _tiers.length / 9;
1618 
1619         for (uint256 i = 0; i < length; i++) {
1620             tiers.push(
1621                 Tier(
1622                     _tiers[i * 9],
1623                     _tiers[i * 9 + 1],
1624                     _tiers[i * 9 + 2],
1625                     _tiers[i * 9 + 3],
1626                     _tiers[i * 9 + 4],
1627                     _tiers[i * 9 + 5],
1628                     _tiers[i * 9 + 6],
1629                     _tiers[i * 9 + 7],
1630                     _tiers[i * 9 + 8]
1631                 )
1632             );
1633         }
1634     }
1635 
1636     /// @return tier index
1637     function getTierIndex() public view returns (uint256) {
1638         for (uint256 i = 0; i < tiers.length; i++) {
1639             if (
1640                 block.timestamp >= tiers[i].startDate &&
1641                 block.timestamp < tiers[i].endDate &&
1642                 tiers[i].maxTokensCollected > tiers[i].soldTierTokens
1643             ) {
1644                 return i;
1645             }
1646         }
1647 
1648         return tiers.length;
1649     }
1650 
1651     function getActualTierIndex() public view returns (uint256) {
1652         for (uint256 i = 0; i < tiers.length; i++) {
1653             if (
1654                 block.timestamp >= tiers[i].startDate
1655                 && block.timestamp < tiers[i].endDate
1656                 && tiers[i].maxTokensCollected > tiers[i].soldTierTokens
1657                 || block.timestamp < tiers[i].startDate
1658             ) {
1659                 return i;
1660             }
1661         }
1662 
1663         return tiers.length.sub(1);
1664     }
1665 
1666     /// @return actual dates
1667     function getActualDates() public view returns (uint256 startDate, uint256 endDate) {
1668         uint256 tierIndex = getActualTierIndex();
1669         startDate = tiers[tierIndex].startDate;
1670         endDate = tiers[tierIndex].endDate;
1671     }
1672 
1673     /// @return tokens based on sold tokens and wei amount
1674     function getTokens(
1675         address,
1676         uint256 _tokensAvailable,
1677         uint256,
1678         uint256 _usdAmount,
1679         uint256
1680     ) public view returns (uint256 tokens, uint256 tokensExcludingBonus, uint256 bonus) {
1681         if (_usdAmount == 0) {
1682             return (0, 0, 0);
1683         }
1684 
1685         uint256 tierIndex = getTierIndex();
1686 
1687         if (tierIndex < tiers.length && _usdAmount < tiers[tierIndex].minInvestInUSD) {
1688             return (0, 0, 0);
1689         }
1690         if (tierIndex == tiers.length) {
1691             return (0, 0, 0);
1692         }
1693         tokensExcludingBonus = _usdAmount.mul(1e18).div(getTokensInUSD(tierIndex));
1694         if (tiers[tierIndex].maxTokensCollected < tiers[tierIndex].soldTierTokens.add(tokensExcludingBonus)) {
1695             return (0, 0, 0);
1696         }
1697 
1698         bonus = calculateBonusAmount(tierIndex, tokensExcludingBonus);
1699 
1700         tokens = tokensExcludingBonus.add(bonus);
1701 
1702         if (tokens > _tokensAvailable) {
1703             return (0, 0, 0);
1704         }
1705     }
1706 
1707     /// @return usd amount based on required tokens
1708     function getUSDAmountByTokens(
1709         uint256 _tokens
1710     ) public view returns (uint256 totalUSDAmount, uint256 tokensBonus) {
1711         if (_tokens == 0) {
1712             return (0, 0);
1713         }
1714 
1715         uint256 tierIndex = getTierIndex();
1716         if (tierIndex == tiers.length) {
1717             return (0, 0);
1718         }
1719         if (tiers[tierIndex].maxTokensCollected < tiers[tierIndex].soldTierTokens.add(_tokens)) {
1720             return (0, 0);
1721         }
1722 
1723         totalUSDAmount = _tokens.mul(getTokensInUSD(tierIndex)).div(1e18);
1724 
1725         if (totalUSDAmount < tiers[tierIndex].minInvestInUSD) {
1726             return (0, 0);
1727         }
1728 
1729         tokensBonus = calculateBonusAmount(tierIndex, _tokens);
1730     }
1731 
1732     /// @return weis based on sold and required tokens
1733     function getWeis(
1734         uint256,
1735         uint256,
1736         uint256 _tokens
1737     ) public view returns (uint256 totalWeiAmount, uint256 tokensBonus) {
1738         uint256 usdAmount;
1739         (usdAmount, tokensBonus) = getUSDAmountByTokens(_tokens);
1740 
1741         if (usdAmount == 0) {
1742             return (0, 0);
1743         }
1744 
1745         totalWeiAmount = usdAmount.mul(1e18).div(etherPriceInUSD);
1746     }
1747 
1748     /// calculates bonus tokens amount by bonusPercents in case if bonusCap is not reached;
1749     /// if reached returns 0
1750     /// @return bonus tokens amount
1751     function calculateBonusAmount(uint256 _tierIndex, uint256 _tokens) public view returns (uint256 bonus) {
1752         if (tiers[_tierIndex].soldTierTokens < tiers[_tierIndex].bonusCap) {
1753             if (tiers[_tierIndex].soldTierTokens.add(_tokens) <= tiers[_tierIndex].bonusCap) {
1754                 bonus = _tokens.mul(tiers[_tierIndex].bonusPercents).div(100);
1755             } else {
1756                 bonus = (tiers[_tierIndex].bonusCap.sub(tiers[_tierIndex].soldTierTokens))
1757                     .mul(tiers[_tierIndex].bonusPercents).div(100);
1758             }
1759         }
1760     }
1761 
1762     function getTokensInUSD(uint256 _tierIndex) public view returns (uint256) {
1763         if (_tierIndex < uint256(tiers.length)) {
1764             return tiers[_tierIndex].tokenInUSD;
1765         }
1766     }
1767 
1768     function getMinEtherInvest(uint256 _tierIndex) public view returns (uint256) {
1769         if (_tierIndex < uint256(tiers.length)) {
1770             return tiers[_tierIndex].minInvestInUSD.mul(1 ether).div(etherPriceInUSD);
1771         }
1772     }
1773 
1774     function getUSDAmountByWeis(uint256 _weiAmount) public view returns (uint256) {
1775         return _weiAmount.mul(etherPriceInUSD).div(1 ether);
1776     }
1777 
1778     /// @notice Check whether contract is initialised
1779     /// @return true if initialized
1780     function isInitialized() public view returns (bool) {
1781         return true;
1782     }
1783 
1784     /// @notice updates tier start/end dates by id
1785     function updateDates(uint8 _tierId, uint256 _start, uint256 _end) public onlyOwner() {
1786         if (_start != 0 && _start < _end && _tierId < tiers.length) {
1787             Tier storage tier = tiers[_tierId];
1788             tier.startDate = _start;
1789             tier.endDate = _end;
1790         }
1791     }
1792 }
1793 contract CHLPricingStrategy is USDDateTiersPricingStrategy {
1794 
1795     CHLAgent public agent;
1796 
1797     modifier onlyAgent() {
1798         require(msg.sender == address(agent));
1799         _;
1800     }
1801 
1802     event MaxTokensCollectedDecreased(uint256 tierId, uint256 oldValue, uint256 amount);
1803 
1804     constructor(
1805         uint256[] _emptyArray,
1806         uint256[4] _periods,
1807         uint256 _etherPriceInUSD
1808     ) public USDDateTiersPricingStrategy(_emptyArray, 18, _etherPriceInUSD) {
1809         //pre-ico
1810         tiers.push(Tier(0.75e5, 6247500e18, 0, 0, 0, 0, 100e5, _periods[0], _periods[1]));
1811         //public ico
1812         tiers.push(Tier(3e5, 32725000e18, 0, 0, 0, 0, 100e5, _periods[2], _periods[3]));
1813     }
1814 
1815     function getArrayOfTiers() public view returns (uint256[12] tiersData) {
1816         uint256 j = 0;
1817         for (uint256 i = 0; i < tiers.length; i++) {
1818             tiersData[j++] = uint256(tiers[i].tokenInUSD);
1819             tiersData[j++] = uint256(tiers[i].maxTokensCollected);
1820             tiersData[j++] = uint256(tiers[i].soldTierTokens);
1821             tiersData[j++] = uint256(tiers[i].minInvestInUSD);
1822             tiersData[j++] = uint256(tiers[i].startDate);
1823             tiersData[j++] = uint256(tiers[i].endDate);
1824         }
1825     }
1826 
1827     function updateTier(
1828         uint256 _tierId,
1829         uint256 _start,
1830         uint256 _end,
1831         uint256 _minInvest,
1832         uint256 _price,
1833         uint256 _bonusCap,
1834         uint256 _bonus,
1835         bool _updateLockNeeded
1836     ) public onlyOwner() {
1837         require(
1838             _start != 0 &&
1839             _price != 0 &&
1840             _start < _end &&
1841             _tierId < tiers.length
1842         );
1843 
1844         if (_updateLockNeeded) {
1845             agent.updateLockPeriod(_end);
1846         }
1847 
1848         Tier storage tier = tiers[_tierId];
1849         tier.tokenInUSD = _price;
1850         tier.minInvestInUSD = _minInvest;
1851         tier.startDate = _start;
1852         tier.endDate = _end;
1853         tier.bonusCap = _bonusCap;
1854         tier.bonusPercents = _bonus;
1855     }
1856 
1857     function setCrowdsaleAgent(CHLAgent _crowdsaleAgent) public onlyOwner {
1858         agent = _crowdsaleAgent;
1859     }
1860 
1861     function updateTierTokens(uint256 _tierId, uint256 _soldTokens, uint256 _bonusTokens) public onlyAgent {
1862         require(_tierId < tiers.length && _soldTokens > 0);
1863 
1864         Tier storage tier = tiers[_tierId];
1865         tier.soldTierTokens = tier.soldTierTokens.add(_soldTokens);
1866         tier.bonusTierTokens = tier.bonusTierTokens.add(_bonusTokens);
1867     }
1868 
1869     function updateMaxTokensCollected(uint256 _tierId, uint256 _amount) public onlyAgent {
1870         require(_tierId < tiers.length && _amount > 0);
1871 
1872         Tier storage tier = tiers[_tierId];
1873 
1874         require(tier.maxTokensCollected.sub(_amount) >= tier.soldTierTokens.add(tier.bonusTierTokens));
1875 
1876         emit MaxTokensCollectedDecreased(_tierId, tier.maxTokensCollected, _amount);
1877 
1878         tier.maxTokensCollected = tier.maxTokensCollected.sub(_amount);
1879     }
1880 
1881     function getTokensWithoutRestrictions(uint256 _usdAmount) public view returns (
1882         uint256 tokens,
1883         uint256 tokensExcludingBonus,
1884         uint256 bonus
1885     ) {
1886         if (_usdAmount == 0) {
1887             return (0, 0, 0);
1888         }
1889 
1890         uint256 tierIndex = getActualTierIndex();
1891 
1892         tokensExcludingBonus = _usdAmount.mul(1e18).div(getTokensInUSD(tierIndex));
1893         bonus = calculateBonusAmount(tierIndex, tokensExcludingBonus);
1894         tokens = tokensExcludingBonus.add(bonus);
1895     }
1896 
1897     function getTierUnsoldTokens(uint256 _tierId) public view returns (uint256) {
1898         if (_tierId >= tiers.length) {
1899             return 0;
1900         }
1901 
1902         return tiers[_tierId].maxTokensCollected.sub(tiers[_tierId].soldTierTokens);
1903     }
1904 
1905     function getSaleEndDate() public view returns (uint256) {
1906         return tiers[tiers.length.sub(1)].endDate;
1907     }
1908 
1909 }
1910 contract Referral is Ownable {
1911 
1912     using SafeMath for uint256;
1913 
1914     MintableTokenAllocator public allocator;
1915     CrowdsaleImpl public crowdsale;
1916 
1917     uint256 public constant DECIMALS = 18;
1918 
1919     uint256 public totalSupply;
1920     bool public unLimited;
1921     bool public sentOnce;
1922 
1923     mapping(address => bool) public claimed;
1924     mapping(address => uint256) public claimedBalances;
1925 
1926     constructor(
1927         uint256 _totalSupply,
1928         address _allocator,
1929         address _crowdsale,
1930         bool _sentOnce
1931     ) public {
1932         require(_allocator != address(0) && _crowdsale != address(0));
1933         totalSupply = _totalSupply;
1934         if (totalSupply == 0) {
1935             unLimited = true;
1936         }
1937         allocator = MintableTokenAllocator(_allocator);
1938         crowdsale = CrowdsaleImpl(_crowdsale);
1939         sentOnce = _sentOnce;
1940     }
1941 
1942     function setAllocator(address _allocator) public onlyOwner {
1943         if (_allocator != address(0)) {
1944             allocator = MintableTokenAllocator(_allocator);
1945         }
1946     }
1947 
1948     function setCrowdsale(address _crowdsale) public onlyOwner {
1949         require(_crowdsale != address(0));
1950         crowdsale = CrowdsaleImpl(_crowdsale);
1951     }
1952 
1953     function multivestMint(
1954         address _address,
1955         uint256 _amount,
1956         uint8 _v,
1957         bytes32 _r,
1958         bytes32 _s
1959     ) public {
1960         require(true == crowdsale.signers(verify(msg.sender, _amount, _v, _r, _s)));
1961         if (true == sentOnce) {
1962             require(claimed[_address] == false);
1963             claimed[_address] = true;
1964         }
1965         require(
1966             _address == msg.sender &&
1967             _amount > 0 &&
1968             (true == unLimited || _amount <= totalSupply)
1969         );
1970         claimedBalances[_address] = claimedBalances[_address].add(_amount);
1971         if (false == unLimited) {
1972             totalSupply = totalSupply.sub(_amount);
1973         }
1974         allocator.allocate(_address, _amount);
1975     }
1976 
1977     /// @notice check sign
1978     function verify(address _sender, uint256 _amount, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address) {
1979         bytes32 hash = keccak256(abi.encodePacked(_sender, _amount));
1980 
1981         bytes memory prefix = '\x19Ethereum Signed Message:\n32';
1982 
1983         return ecrecover(keccak256(abi.encodePacked(prefix, hash)), _v, _r, _s);
1984     }
1985 
1986 }
1987 contract CHLReferral is Referral {
1988 
1989     CHLPricingStrategy public pricingStrategy;
1990 
1991     constructor(
1992         address _allocator,
1993         address _crowdsale,
1994         CHLPricingStrategy _strategy
1995     ) public Referral(1190000e18, _allocator, _crowdsale, true) {
1996         require(_strategy != address(0));
1997         pricingStrategy = _strategy;
1998     }
1999 
2000     function multivestMint(
2001         address _address,
2002         uint256 _amount,
2003         uint8 _v,
2004         bytes32 _r,
2005         bytes32 _s
2006     ) public {
2007         require(pricingStrategy.getSaleEndDate() <= block.timestamp);
2008         super.multivestMint(_address, _amount, _v, _r, _s);
2009     }
2010 }
2011 contract CHLAllocation is Ownable {
2012 
2013     using SafeMath for uint256;
2014 
2015     MintableTokenAllocator public allocator;
2016 
2017     CHLAgent public agent;
2018     //manualMintingSupply = Advisors 2975000 + Bounty 1785000 + LWL (Non Profit Initiative) 1190000
2019     uint256 public manualMintingSupply = 5950000e18;
2020 
2021     uint256 public foundersVestingAmountPeriodOne = 7140000e18;
2022     uint256 public foundersVestingAmountPeriodTwo = 2975000e18;
2023     uint256 public foundersVestingAmountPeriodThree = 1785000e18;
2024 
2025     address[] public vestings;
2026 
2027     address public foundersAddress;
2028 
2029     bool public isFoundersTokensSent;
2030 
2031     event VestingCreated(
2032         address _vesting,
2033         address _beneficiary,
2034         uint256 _start,
2035         uint256 _cliff,
2036         uint256 _duration,
2037         uint256 _periods,
2038         bool _revocable
2039     );
2040 
2041     event VestingRevoked(address _vesting);
2042 
2043     constructor(MintableTokenAllocator _allocator, address _foundersAddress) public {
2044         require(_foundersAddress != address(0));
2045         foundersAddress = _foundersAddress;
2046         allocator = _allocator;
2047     }
2048 
2049     function setAllocator(MintableTokenAllocator _allocator) public onlyOwner {
2050         require(_allocator != address(0));
2051         allocator = _allocator;
2052     }
2053 
2054     function setAgent(CHLAgent _agent) public onlyOwner {
2055         require(_agent != address(0));
2056         agent = _agent;
2057     }
2058 
2059     function allocateManualMintingTokens(address[] _addresses, uint256[] _tokens) public onlyOwner {
2060         require(_addresses.length == _tokens.length);
2061         for (uint256 i = 0; i < _addresses.length; i++) {
2062             require(_addresses[i] != address(0) && _tokens[i] > 0 && _tokens[i] <= manualMintingSupply);
2063             manualMintingSupply -= _tokens[i];
2064 
2065             allocator.allocate(_addresses[i], _tokens[i]);
2066         }
2067     }
2068 
2069     function allocatePrivateSaleTokens(
2070         uint256 _tierId,
2071         uint256 _totalTokensSupply,
2072         uint256 _tokenPriceInUsd,
2073         address[] _addresses,
2074         uint256[] _tokens
2075     ) public onlyOwner {
2076         require(
2077             _addresses.length == _tokens.length &&
2078             _totalTokensSupply > 0
2079         );
2080 
2081         agent.updateStateWithPrivateSale(_tierId, _totalTokensSupply, _totalTokensSupply.mul(_tokenPriceInUsd).div(1e18));
2082 
2083         for (uint256 i = 0; i < _addresses.length; i++) {
2084             require(_addresses[i] != address(0) && _tokens[i] > 0 && _tokens[i] <= _totalTokensSupply);
2085             _totalTokensSupply = _totalTokensSupply.sub(_tokens[i]);
2086 
2087             allocator.allocate(_addresses[i], _tokens[i]);
2088         }
2089 
2090         require(_totalTokensSupply == 0);
2091     }
2092 
2093     function allocateFoundersTokens(uint256 _start) public {
2094         require(!isFoundersTokensSent && msg.sender == address(agent));
2095 
2096         isFoundersTokensSent = true;
2097 
2098         allocator.allocate(foundersAddress, foundersVestingAmountPeriodOne);
2099 
2100         createVestingInternal(
2101             foundersAddress,
2102             _start,
2103             0,
2104             365 days,
2105             1,
2106             true,
2107             owner,
2108             foundersVestingAmountPeriodTwo
2109         );
2110 
2111         createVestingInternal(
2112             foundersAddress,
2113             _start,
2114             0,
2115             730 days,
2116             1,
2117             true,
2118             owner,
2119             foundersVestingAmountPeriodThree
2120         );
2121     }
2122 
2123     function createVesting(
2124         address _beneficiary,
2125         uint256 _start,
2126         uint256 _cliff,
2127         uint256 _duration,
2128         uint256 _periods,
2129         bool _revocable,
2130         address _unreleasedHolder,
2131         uint256 _amount
2132     ) public onlyOwner returns (PeriodicTokenVesting vesting) {
2133 
2134         vesting = createVestingInternal(
2135             _beneficiary,
2136             _start,
2137             _cliff,
2138             _duration,
2139             _periods,
2140             _revocable,
2141             _unreleasedHolder,
2142             _amount
2143         );
2144     }
2145 
2146     function revokeVesting(PeriodicTokenVesting _vesting, ERC20Basic token) public onlyOwner() {
2147         _vesting.revoke(token);
2148 
2149         emit VestingRevoked(_vesting);
2150     }
2151 
2152     function createVestingInternal(
2153         address _beneficiary,
2154         uint256 _start,
2155         uint256 _cliff,
2156         uint256 _duration,
2157         uint256 _periods,
2158         bool _revocable,
2159         address _unreleasedHolder,
2160         uint256 _amount
2161     ) internal returns (PeriodicTokenVesting) {
2162         PeriodicTokenVesting vesting = new PeriodicTokenVesting(
2163             _beneficiary, _start, _cliff, _duration, _periods, _revocable, _unreleasedHolder
2164         );
2165 
2166         vestings.push(vesting);
2167 
2168         emit VestingCreated(vesting, _beneficiary, _start, _cliff, _duration, _periods, _revocable);
2169 
2170         allocator.allocate(address(vesting), _amount);
2171 
2172         return vesting;
2173     }
2174 
2175 }
2176 /**
2177  * @title TokenVesting
2178  * @dev A token holder contract that can release its token balance gradually like a
2179  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
2180  * owner.
2181  */
2182 contract TokenVesting is Ownable {
2183   using SafeMath for uint256;
2184   using SafeERC20 for ERC20Basic;
2185 
2186   event Released(uint256 amount);
2187   event Revoked();
2188 
2189   // beneficiary of tokens after they are released
2190   address public beneficiary;
2191 
2192   uint256 public cliff;
2193   uint256 public start;
2194   uint256 public duration;
2195 
2196   bool public revocable;
2197 
2198   mapping (address => uint256) public released;
2199   mapping (address => bool) public revoked;
2200 
2201   /**
2202    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
2203    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
2204    * of the balance will have vested.
2205    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
2206    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
2207    * @param _start the time (as Unix time) at which point vesting starts 
2208    * @param _duration duration in seconds of the period in which the tokens will vest
2209    * @param _revocable whether the vesting is revocable or not
2210    */
2211   constructor(
2212     address _beneficiary,
2213     uint256 _start,
2214     uint256 _cliff,
2215     uint256 _duration,
2216     bool _revocable
2217   )
2218     public
2219   {
2220     require(_beneficiary != address(0));
2221     require(_cliff <= _duration);
2222 
2223     beneficiary = _beneficiary;
2224     revocable = _revocable;
2225     duration = _duration;
2226     cliff = _start.add(_cliff);
2227     start = _start;
2228   }
2229 
2230   /**
2231    * @notice Transfers vested tokens to beneficiary.
2232    * @param token ERC20 token which is being vested
2233    */
2234   function release(ERC20Basic token) public {
2235     uint256 unreleased = releasableAmount(token);
2236 
2237     require(unreleased > 0);
2238 
2239     released[token] = released[token].add(unreleased);
2240 
2241     token.safeTransfer(beneficiary, unreleased);
2242 
2243     emit Released(unreleased);
2244   }
2245 
2246   /**
2247    * @notice Allows the owner to revoke the vesting. Tokens already vested
2248    * remain in the contract, the rest are returned to the owner.
2249    * @param token ERC20 token which is being vested
2250    */
2251   function revoke(ERC20Basic token) public onlyOwner {
2252     require(revocable);
2253     require(!revoked[token]);
2254 
2255     uint256 balance = token.balanceOf(this);
2256 
2257     uint256 unreleased = releasableAmount(token);
2258     uint256 refund = balance.sub(unreleased);
2259 
2260     revoked[token] = true;
2261 
2262     token.safeTransfer(owner, refund);
2263 
2264     emit Revoked();
2265   }
2266 
2267   /**
2268    * @dev Calculates the amount that has already vested but hasn't been released yet.
2269    * @param token ERC20 token which is being vested
2270    */
2271   function releasableAmount(ERC20Basic token) public view returns (uint256) {
2272     return vestedAmount(token).sub(released[token]);
2273   }
2274 
2275   /**
2276    * @dev Calculates the amount that has already vested.
2277    * @param token ERC20 token which is being vested
2278    */
2279   function vestedAmount(ERC20Basic token) public view returns (uint256) {
2280     uint256 currentBalance = token.balanceOf(this);
2281     uint256 totalBalance = currentBalance.add(released[token]);
2282 
2283     if (block.timestamp < cliff) {
2284       return 0;
2285     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
2286       return totalBalance;
2287     } else {
2288       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
2289     }
2290   }
2291 }
2292 contract PeriodicTokenVesting is TokenVesting {
2293     address public unreleasedHolder;
2294     uint256 public periods;
2295 
2296     constructor(
2297         address _beneficiary,
2298         uint256 _start,
2299         uint256 _cliff,
2300         uint256 _periodDuration,
2301         uint256 _periods,
2302         bool _revocable,
2303         address _unreleasedHolder
2304     ) public TokenVesting(_beneficiary, _start, _cliff, _periodDuration, _revocable) {
2305         require(_revocable == false || _unreleasedHolder != address(0));
2306         periods = _periods;
2307         unreleasedHolder = _unreleasedHolder;
2308     }
2309 
2310     /**
2311     * @dev Calculates the amount that has already vested.
2312     * @param token ERC20 token which is being vested
2313     */
2314     function vestedAmount(ERC20Basic token) public view returns (uint256) {
2315         uint256 currentBalance = token.balanceOf(this);
2316         uint256 totalBalance = currentBalance.add(released[token]);
2317 
2318         if (now < cliff) {
2319             return 0;
2320         } else if (now >= start.add(duration * periods) || revoked[token]) {
2321             return totalBalance;
2322         } else {
2323 
2324             uint256 periodTokens = totalBalance.div(periods);
2325 
2326             uint256 periodsOver = now.sub(start).div(duration);
2327 
2328             if (periodsOver >= periods) {
2329                 return totalBalance;
2330             }
2331 
2332             return periodTokens.mul(periodsOver);
2333         }
2334     }
2335 
2336     /**
2337  * @notice Allows the owner to revoke the vesting. Tokens already vested
2338  * remain in the contract, the rest are returned to the owner.
2339  * @param token ERC20 token which is being vested
2340  */
2341     function revoke(ERC20Basic token) public onlyOwner {
2342         require(revocable);
2343         require(!revoked[token]);
2344 
2345         uint256 balance = token.balanceOf(this);
2346 
2347         uint256 unreleased = releasableAmount(token);
2348         uint256 refund = balance.sub(unreleased);
2349 
2350         revoked[token] = true;
2351 
2352         token.safeTransfer(unreleasedHolder, refund);
2353 
2354         emit Revoked();
2355     }
2356 }
2357 contract Stats {
2358 
2359     using SafeMath for uint256;
2360 
2361     MintableToken public token;
2362     MintableTokenAllocator public allocator;
2363     CHLCrowdsale public crowdsale;
2364     CHLPricingStrategy public pricing;
2365 
2366     constructor(
2367         MintableToken _token,
2368         MintableTokenAllocator _allocator,
2369         CHLCrowdsale _crowdsale,
2370         CHLPricingStrategy _pricing
2371     ) public {
2372         token = _token;
2373         allocator = _allocator;
2374         crowdsale = _crowdsale;
2375         pricing = _pricing;
2376     }
2377 
2378     function getTokens(
2379         uint256 _type,
2380         uint256 _usdAmount
2381     ) public view returns (uint256 tokens, uint256 tokensExcludingBonus, uint256 bonus) {
2382         _type = _type;
2383 
2384         return pricing.getTokensWithoutRestrictions(_usdAmount);
2385     }
2386 
2387     function getWeis(
2388         uint256 _type,
2389         uint256 _tokenAmount
2390     ) public view returns (uint256 totalWeiAmount, uint256 tokensBonus) {
2391         _type = _type;
2392 
2393         return pricing.getWeis(0, 0, _tokenAmount);
2394     }
2395 
2396     function getUSDAmount(
2397         uint256 _type,
2398         uint256 _tokenAmount
2399     ) public view returns (uint256 totalUSDAmount, uint256 tokensBonus) {
2400         _type = _type;
2401 
2402         return pricing.getUSDAmountByTokens(_tokenAmount);
2403     }
2404 
2405     function getStats(uint256 _userType, uint256[7] _ethPerCurrency) public view returns (
2406         uint256[8] stats,
2407         uint256[26] tiersData,
2408         uint256[21] currencyContr //tokensPerEachCurrency,
2409     ) {
2410         stats = getStatsData(_userType);
2411         tiersData = getTiersData(_userType);
2412         currencyContr = getCurrencyContrData(_userType, _ethPerCurrency);
2413     }
2414 
2415     function getTiersData(uint256 _type) public view returns (
2416         uint256[26] tiersData
2417     ) {
2418         _type = _type;
2419         uint256[12] memory tiers = pricing.getArrayOfTiers();
2420         uint256 length = tiers.length / 6;
2421 
2422         uint256 j = 0;
2423         for (uint256 i = 0; i < length; i++) {
2424             tiersData[j++] = uint256(1e23).div(tiers[i.mul(6)]);// tokenInUSD;
2425             tiersData[j++] = 0;// tokenInWei;
2426             tiersData[j++] = uint256(tiers[i.mul(6).add(1)]);// maxTokensCollected;
2427             tiersData[j++] = uint256(tiers[i.mul(6).add(2)]);// soldTierTokens;
2428             tiersData[j++] = 0;// discountPercents;
2429             tiersData[j++] = 0;// bonusPercents;
2430             tiersData[j++] = uint256(tiers[i.mul(6).add(3)]);// minInvestInUSD;
2431             tiersData[j++] = 0;// minInvestInWei;
2432             tiersData[j++] = 0;// maxInvestInUSD;
2433             tiersData[j++] = 0;// maxInvestInWei;
2434             tiersData[j++] = uint256(tiers[i.mul(6).add(4)]); // startDate;
2435             tiersData[j++] = uint256(tiers[i.mul(6).add(5)]); // endDate;
2436             tiersData[j++] = 1;
2437         }
2438 
2439         tiersData[25] = 2;
2440 
2441     }
2442 
2443     function getStatsData(uint256 _type) public view returns (
2444         uint256[8] stats
2445     ) {
2446         _type = _type;
2447         stats[0] = token.maxSupply();
2448         stats[1] = token.totalSupply();
2449         stats[2] = crowdsale.maxSaleSupply();
2450         stats[3] = crowdsale.tokensSold();
2451         stats[4] = uint256(crowdsale.currentState());
2452         stats[5] = pricing.getActualTierIndex();
2453         stats[6] = pricing.getTierUnsoldTokens(stats[5]);
2454         stats[7] = pricing.getMinEtherInvest(stats[5]);
2455     }
2456 
2457     function getCurrencyContrData(uint256 _type, uint256[7] _usdPerCurrency) public view returns (
2458         uint256[21] currencyContr
2459     ) {
2460         _type = _type;
2461         uint256 j = 0;
2462         for (uint256 i = 0; i < _usdPerCurrency.length; i++) {
2463             (currencyContr[j++], currencyContr[j++], currencyContr[j++]) = pricing.getTokensWithoutRestrictions(
2464                 _usdPerCurrency[i]
2465             );
2466         }
2467     }
2468 }