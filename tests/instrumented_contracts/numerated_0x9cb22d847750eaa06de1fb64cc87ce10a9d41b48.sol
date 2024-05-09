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
79  * See https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   function totalSupply() public view returns (uint256);
83   function balanceOf(address who) public view returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender)
93     public view returns (uint256);
94 
95   function transferFrom(address from, address to, uint256 value)
96     public returns (bool);
97 
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(
100     address indexed owner,
101     address indexed spender,
102     uint256 value
103   );
104 }
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is ERC20Basic {
110   using SafeMath for uint256;
111 
112   mapping(address => uint256) balances;
113 
114   uint256 totalSupply_;
115 
116   /**
117   * @dev Total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return totalSupply_;
121   }
122 
123   /**
124   * @dev Transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[msg.sender]);
131 
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     emit Transfer(msg.sender, _to, _value);
135     return true;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of.
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) public view returns (uint256) {
144     return balances[_owner];
145   }
146 
147 }
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * https://github.com/ethereum/EIPs/issues/20
153  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
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
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * @param _spender The address which will spend the funds.
192    * @param _value The amount of tokens to be spent.
193    */
194   function approve(address _spender, uint256 _value) public returns (bool) {
195     allowed[msg.sender][_spender] = _value;
196     emit Approval(msg.sender, _spender, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Function to check the amount of tokens that an owner allowed to a spender.
202    * @param _owner address The address which owns the funds.
203    * @param _spender address The address which will spend the funds.
204    * @return A uint256 specifying the amount of tokens still available for the spender.
205    */
206   function allowance(
207     address _owner,
208     address _spender
209    )
210     public
211     view
212     returns (uint256)
213   {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * @dev Increase the amount of tokens that an owner allowed to a spender.
219    * approve should be called when allowed[_spender] == 0. To increment
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _addedValue The amount of tokens to increase the allowance by.
225    */
226   function increaseApproval(
227     address _spender,
228     uint256 _addedValue
229   )
230     public
231     returns (bool)
232   {
233     allowed[msg.sender][_spender] = (
234       allowed[msg.sender][_spender].add(_addedValue));
235     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239   /**
240    * @dev Decrease the amount of tokens that an owner allowed to a spender.
241    * approve should be called when allowed[_spender] == 0. To decrement
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _subtractedValue The amount of tokens to decrease the allowance by.
247    */
248   function decreaseApproval(
249     address _spender,
250     uint256 _subtractedValue
251   )
252     public
253     returns (bool)
254   {
255     uint256 oldValue = allowed[msg.sender][_spender];
256     if (_subtractedValue > oldValue) {
257       allowed[msg.sender][_spender] = 0;
258     } else {
259       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
260     }
261     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262     return true;
263   }
264 
265 }
266 /**
267  * @title Ownable
268  * @dev The Ownable contract has an owner address, and provides basic authorization control
269  * functions, this simplifies the implementation of 'user permissions'.
270  */
271 
272 /// @title Ownable
273 /// @author Applicature
274 /// @notice helper mixed to other contracts to link contract on an owner
275 /// @dev Base class
276 contract Ownable {
277     //Variables
278     address public owner;
279     address public newOwner;
280 
281     //    Modifiers
282     /**
283      * @dev Throws if called by any account other than the owner.
284      */
285     modifier onlyOwner() {
286         require(msg.sender == owner);
287         _;
288     }
289 
290     /**
291      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
292      * account.
293      */
294     constructor() public {
295         owner = msg.sender;
296     }
297 
298     /**
299      * @dev Allows the current owner to transfer control of the contract to a newOwner.
300      * @param _newOwner The address to transfer ownership to.
301      */
302     function transferOwnership(address _newOwner) public onlyOwner {
303         require(_newOwner != address(0));
304         newOwner = _newOwner;
305 
306     }
307 
308     function acceptOwnership() public {
309         if (msg.sender == newOwner) {
310             owner = newOwner;
311         }
312     }
313 }
314 /**
315  * @title TokenVesting
316  * @dev A token holder contract that can release its token balance gradually like a
317  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
318  * owner.
319  */
320 contract TokenVesting is Ownable {
321   using SafeMath for uint256;
322   using SafeERC20 for ERC20Basic;
323 
324   event Released(uint256 amount);
325   event Revoked();
326 
327   // beneficiary of tokens after they are released
328   address public beneficiary;
329 
330   uint256 public cliff;
331   uint256 public start;
332   uint256 public duration;
333 
334   bool public revocable;
335 
336   mapping (address => uint256) public released;
337   mapping (address => bool) public revoked;
338 
339   /**
340    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
341    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
342    * of the balance will have vested.
343    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
344    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
345    * @param _start the time (as Unix time) at which point vesting starts 
346    * @param _duration duration in seconds of the period in which the tokens will vest
347    * @param _revocable whether the vesting is revocable or not
348    */
349   constructor(
350     address _beneficiary,
351     uint256 _start,
352     uint256 _cliff,
353     uint256 _duration,
354     bool _revocable
355   )
356     public
357   {
358     require(_beneficiary != address(0));
359     require(_cliff <= _duration);
360 
361     beneficiary = _beneficiary;
362     revocable = _revocable;
363     duration = _duration;
364     cliff = _start.add(_cliff);
365     start = _start;
366   }
367 
368   /**
369    * @notice Transfers vested tokens to beneficiary.
370    * @param token ERC20 token which is being vested
371    */
372   function release(ERC20Basic token) public {
373     uint256 unreleased = releasableAmount(token);
374 
375     require(unreleased > 0);
376 
377     released[token] = released[token].add(unreleased);
378 
379     token.safeTransfer(beneficiary, unreleased);
380 
381     emit Released(unreleased);
382   }
383 
384   /**
385    * @notice Allows the owner to revoke the vesting. Tokens already vested
386    * remain in the contract, the rest are returned to the owner.
387    * @param token ERC20 token which is being vested
388    */
389   function revoke(ERC20Basic token) public onlyOwner {
390     require(revocable);
391     require(!revoked[token]);
392 
393     uint256 balance = token.balanceOf(this);
394 
395     uint256 unreleased = releasableAmount(token);
396     uint256 refund = balance.sub(unreleased);
397 
398     revoked[token] = true;
399 
400     token.safeTransfer(owner, refund);
401 
402     emit Revoked();
403   }
404 
405   /**
406    * @dev Calculates the amount that has already vested but hasn't been released yet.
407    * @param token ERC20 token which is being vested
408    */
409   function releasableAmount(ERC20Basic token) public view returns (uint256) {
410     return vestedAmount(token).sub(released[token]);
411   }
412 
413   /**
414    * @dev Calculates the amount that has already vested.
415    * @param token ERC20 token which is being vested
416    */
417   function vestedAmount(ERC20Basic token) public view returns (uint256) {
418     uint256 currentBalance = token.balanceOf(this);
419     uint256 totalBalance = currentBalance.add(released[token]);
420 
421     if (block.timestamp < cliff) {
422       return 0;
423     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
424       return totalBalance;
425     } else {
426       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
427     }
428   }
429 }
430 /// @title OpenZeppelinERC20
431 /// @author Applicature
432 /// @notice Open Zeppelin implementation of standart ERC20
433 /// @dev Base class
434 contract OpenZeppelinERC20 is StandardToken, Ownable {
435     using SafeMath for uint256;
436 
437     uint8 public decimals;
438     string public name;
439     string public symbol;
440     string public standard;
441 
442     constructor(
443         uint256 _totalSupply,
444         string _tokenName,
445         uint8 _decimals,
446         string _tokenSymbol,
447         bool _transferAllSupplyToOwner
448     ) public {
449         standard = 'ERC20 0.1';
450         totalSupply_ = _totalSupply;
451 
452         if (_transferAllSupplyToOwner) {
453             balances[msg.sender] = _totalSupply;
454         } else {
455             balances[this] = _totalSupply;
456         }
457 
458         name = _tokenName;
459         // Set the name for display purposes
460         symbol = _tokenSymbol;
461         // Set the symbol for display purposes
462         decimals = _decimals;
463     }
464 
465 }
466 /// @title MintableToken
467 /// @author Applicature
468 /// @notice allow to mint tokens
469 /// @dev Base class
470 contract MintableToken is BasicToken, Ownable {
471 
472     using SafeMath for uint256;
473 
474     uint256 public maxSupply;
475     bool public allowedMinting;
476     mapping(address => bool) public mintingAgents;
477     mapping(address => bool) public stateChangeAgents;
478 
479     event Mint(address indexed holder, uint256 tokens);
480 
481     modifier onlyMintingAgents () {
482         require(mintingAgents[msg.sender]);
483         _;
484     }
485 
486     modifier onlyStateChangeAgents () {
487         require(stateChangeAgents[msg.sender]);
488         _;
489     }
490 
491     constructor(uint256 _maxSupply, uint256 _mintedSupply, bool _allowedMinting) public {
492         maxSupply = _maxSupply;
493         totalSupply_ = totalSupply_.add(_mintedSupply);
494         allowedMinting = _allowedMinting;
495         mintingAgents[msg.sender] = true;
496     }
497 
498     /// @notice allow to mint tokens
499     function mint(address _holder, uint256 _tokens) public onlyMintingAgents() {
500         require(allowedMinting == true && totalSupply_.add(_tokens) <= maxSupply);
501 
502         totalSupply_ = totalSupply_.add(_tokens);
503 
504         balances[_holder] = balances[_holder].add(_tokens);
505 
506         if (totalSupply_ == maxSupply) {
507             allowedMinting = false;
508         }
509         emit Transfer(address(0), _holder, _tokens);
510         emit Mint(_holder, _tokens);
511     }
512 
513     /// @notice update allowedMinting flat
514     function disableMinting() public onlyStateChangeAgents() {
515         allowedMinting = false;
516     }
517 
518     /// @notice update minting agent
519     function updateMintingAgent(address _agent, bool _status) public onlyOwner {
520         mintingAgents[_agent] = _status;
521     }
522 
523     /// @notice update state change agent
524     function updateStateChangeAgent(address _agent, bool _status) public onlyOwner {
525         stateChangeAgents[_agent] = _status;
526     }
527 
528     /// @return available tokens
529     function availableTokens() public view returns (uint256 tokens) {
530         return maxSupply.sub(totalSupply_);
531     }
532 }
533 /**
534  * @title Burnable Token
535  * @dev Token that can be irreversibly burned (destroyed).
536  */
537 contract BurnableToken is BasicToken {
538 
539   event Burn(address indexed burner, uint256 value);
540 
541   /**
542    * @dev Burns a specific amount of tokens.
543    * @param _value The amount of token to be burned.
544    */
545   function burn(uint256 _value) public {
546     _burn(msg.sender, _value);
547   }
548 
549   function _burn(address _who, uint256 _value) internal {
550     require(_value <= balances[_who]);
551     // no need to require value <= totalSupply, since that would imply the
552     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
553 
554     balances[_who] = balances[_who].sub(_value);
555     totalSupply_ = totalSupply_.sub(_value);
556     emit Burn(_who, _value);
557     emit Transfer(_who, address(0), _value);
558   }
559 }
560 /// @title MintableBurnableToken
561 /// @author Applicature
562 /// @notice helper mixed to other contracts to burn tokens
563 /// @dev implementation
564 contract MintableBurnableToken is MintableToken, BurnableToken {
565 
566     mapping (address => bool) public burnAgents;
567 
568     modifier onlyBurnAgents () {
569         require(burnAgents[msg.sender]);
570         _;
571     }
572 
573     constructor(
574         uint256 _maxSupply,
575         uint256 _mintedSupply,
576         bool _allowedMinting
577     ) public MintableToken(
578         _maxSupply,
579         _mintedSupply,
580         _allowedMinting
581     ) {
582 
583     }
584 
585     /// @notice update burn agent
586     function updateBurnAgent(address _agent, bool _status) public onlyOwner {
587         burnAgents[_agent] = _status;
588     }
589 
590     function burnByAgent(address _holder, uint256 _tokensToBurn) public onlyBurnAgents() returns (uint256) {
591         if (_tokensToBurn == 0) {
592             _tokensToBurn = balances[_holder];
593         }
594         _burn(_holder, _tokensToBurn);
595 
596         return _tokensToBurn;
597     }
598 
599     function _burn(address _who, uint256 _value) internal {
600         super._burn(_who, _value);
601         maxSupply = maxSupply.sub(_value);
602     }
603 }
604 /// @title TimeLocked
605 /// @author Applicature
606 /// @notice helper mixed to other contracts to lock contract on a timestamp
607 /// @dev Base class
608 contract TimeLocked {
609     uint256 public time;
610     mapping(address => bool) public excludedAddresses;
611 
612     modifier isTimeLocked(address _holder, bool _timeLocked) {
613         bool locked = (block.timestamp < time);
614         require(excludedAddresses[_holder] == true || locked == _timeLocked);
615         _;
616     }
617 
618     constructor(uint256 _time) public {
619         time = _time;
620     }
621 
622     function updateExcludedAddress(address _address, bool _status) public;
623 }
624 /// @title TimeLockedToken
625 /// @author Applicature
626 /// @notice helper mixed to other contracts to lock contract on a timestamp
627 /// @dev Base class
628 contract TimeLockedToken is TimeLocked, StandardToken {
629 
630     constructor(uint256 _time) public TimeLocked(_time) {}
631 
632     function transfer(address _to, uint256 _tokens) public isTimeLocked(msg.sender, false) returns (bool) {
633         return super.transfer(_to, _tokens);
634     }
635 
636     function transferFrom(address _holder, address _to, uint256 _tokens)
637         public
638         isTimeLocked(_holder, false)
639         returns (bool)
640     {
641         return super.transferFrom(_holder, _to, _tokens);
642     }
643 }
644 contract ICUToken is OpenZeppelinERC20, MintableBurnableToken, TimeLockedToken {
645 
646     ICUCrowdsale public crowdsale;
647 
648     bool public isSoftCapAchieved;
649 
650     constructor(uint256 _unlockTokensTime)
651         public
652         OpenZeppelinERC20(0, 'iCumulate', 18, 'ICU', false)
653         MintableBurnableToken(4700000000e18, 0, true)
654         TimeLockedToken(_unlockTokensTime)
655     {}
656 
657     function setUnlockTime(uint256 _unlockTokensTime) public onlyStateChangeAgents {
658         time = _unlockTokensTime;
659     }
660 
661     function setIsSoftCapAchieved() public onlyStateChangeAgents {
662         isSoftCapAchieved = true;
663     }
664 
665     function setCrowdSale(address _crowdsale) public onlyOwner {
666         require(_crowdsale != address(0));
667         crowdsale = ICUCrowdsale(_crowdsale);
668     }
669 
670     function updateExcludedAddress(address _address, bool _status) public onlyOwner {
671         excludedAddresses[_address] = _status;
672     }
673 
674     function transfer(address _to, uint256 _tokens) public returns (bool) {
675         require(true == isTransferAllowed(msg.sender));
676         return super.transfer(_to, _tokens);
677     }
678 
679     function transferFrom(address _holder, address _to, uint256 _tokens) public returns (bool) {
680         require(true == isTransferAllowed(_holder));
681         return super.transferFrom(_holder, _to, _tokens);
682     }
683 
684     function isTransferAllowed(address _address) public view returns (bool) {
685         if (excludedAddresses[_address] == true) {
686             return true;
687         }
688 
689         if (!isSoftCapAchieved && (address(crowdsale) == address(0) || false == crowdsale.isSoftCapAchieved(0))) {
690             return false;
691         }
692 
693         return true;
694     }
695 
696     function burnUnsoldTokens(uint256 _tokensToBurn) public onlyBurnAgents() returns (uint256) {
697         require(maxSupply.sub(_tokensToBurn) >= totalSupply_);
698 
699         maxSupply = maxSupply.sub(_tokensToBurn);
700 
701         emit Burn(address(0), _tokensToBurn);
702 
703         return _tokensToBurn;
704     }
705 
706 }
707 /// @title Agent
708 /// @author Applicature
709 /// @notice Contract which takes actions on state change and contribution
710 /// @dev Base class
711 contract Agent {
712     using SafeMath for uint256;
713 
714     function isInitialized() public view returns (bool) {
715         return false;
716     }
717 }
718 /// @title CrowdsaleAgent
719 /// @author Applicature
720 /// @notice Contract which takes actions on state change and contribution
721 /// @dev Base class
722 contract CrowdsaleAgent is Agent {
723 
724     Crowdsale public crowdsale;
725     bool public _isInitialized;
726 
727     modifier onlyCrowdsale() {
728         require(msg.sender == address(crowdsale));
729         _;
730     }
731 
732     constructor(Crowdsale _crowdsale) public {
733         crowdsale = _crowdsale;
734 
735         if (address(0) != address(_crowdsale)) {
736             _isInitialized = true;
737         } else {
738             _isInitialized = false;
739         }
740     }
741 
742     function isInitialized() public view returns (bool) {
743         return _isInitialized;
744     }
745 
746     function onContribution(address _contributor, uint256 _weiAmount, uint256 _tokens, uint256 _bonus)
747         public onlyCrowdsale();
748 
749     function onStateChange(Crowdsale.State _state) public onlyCrowdsale();
750 
751     function onRefund(address _contributor, uint256 _tokens) public onlyCrowdsale() returns (uint256 burned);
752 }
753 /// @title MintableCrowdsaleOnSuccessAgent
754 /// @author Applicature
755 /// @notice Contract which takes actions on state change and contribution
756 /// un-pause tokens and disable minting on Crowdsale success
757 /// @dev implementation
758 contract MintableCrowdsaleOnSuccessAgent is CrowdsaleAgent {
759 
760     MintableToken public token;
761     bool public _isInitialized;
762 
763     constructor(Crowdsale _crowdsale, MintableToken _token) public CrowdsaleAgent(_crowdsale) {
764         token = _token;
765 
766         if (address(0) != address(_token) && address(0) != address(_crowdsale)) {
767             _isInitialized = true;
768         } else {
769             _isInitialized = false;
770         }
771     }
772 
773     /// @notice Check whether contract is initialised
774     /// @return true if initialized
775     function isInitialized() public view returns (bool) {
776         return _isInitialized;
777     }
778 
779     /// @notice Takes actions on contribution
780     function onContribution(address _contributor, uint256 _weiAmount, uint256 _tokens, uint256 _bonus) public onlyCrowdsale;
781 
782     /// @notice Takes actions on state change,
783     /// un-pause tokens and disable minting on Crowdsale success
784     /// @param _state Crowdsale.State
785     function onStateChange(Crowdsale.State _state) public onlyCrowdsale;
786 }
787 contract ICUAgent is MintableCrowdsaleOnSuccessAgent {
788 
789     ICUStrategy public strategy;
790     ICUCrowdsale public crowdsale;
791 
792     bool public burnStatus;
793 
794     constructor(
795         ICUCrowdsale _crowdsale,
796         ICUToken _token,
797         ICUStrategy _strategy
798     ) public MintableCrowdsaleOnSuccessAgent(_crowdsale, _token) {
799         require(address(_strategy) != address(0) && address(_crowdsale) != address(0));
800         strategy = _strategy;
801         crowdsale = _crowdsale;
802     }
803 
804     /// @notice Takes actions on contribution
805     function onContribution(
806         address,
807         uint256 _tierIndex,
808         uint256 _tokens,
809         uint256 _bonus
810     ) public onlyCrowdsale() {
811         strategy.updateTierState(_tierIndex, _tokens, _bonus);
812     }
813 
814     function onStateChange(Crowdsale.State _state) public onlyCrowdsale() {
815         ICUToken icuToken = ICUToken(token);
816         if (
817             icuToken.isSoftCapAchieved() == false
818             && (_state == Crowdsale.State.Success || _state == Crowdsale.State.Finalized)
819             && crowdsale.isSoftCapAchieved(0)
820         ) {
821             icuToken.setIsSoftCapAchieved();
822         }
823 
824         if (_state > Crowdsale.State.InCrowdsale && burnStatus == false) {
825             uint256 unsoldTokensAmount = strategy.getUnsoldTokens();
826 
827             burnStatus = true;
828 
829             icuToken.burnUnsoldTokens(unsoldTokensAmount);
830         }
831 
832     }
833 
834     function onRefund(address _contributor, uint256 _tokens) public onlyCrowdsale() returns (uint256 burned) {
835         burned = ICUToken(token).burnByAgent(_contributor, _tokens);
836     }
837 
838     function updateLockPeriod(uint256 _time) public {
839         require(msg.sender == address(strategy));
840         ICUToken(token).setUnlockTime(_time);
841     }
842 
843 }
844 /// @title TokenAllocator
845 /// @author Applicature
846 /// @notice Contract responsible for defining distribution logic of tokens.
847 /// @dev Base class
848 contract TokenAllocator is Ownable {
849 
850 
851     mapping(address => bool) public crowdsales;
852 
853     modifier onlyCrowdsale() {
854         require(crowdsales[msg.sender]);
855         _;
856     }
857 
858     function addCrowdsales(address _address) public onlyOwner {
859         crowdsales[_address] = true;
860     }
861 
862     function removeCrowdsales(address _address) public onlyOwner {
863         crowdsales[_address] = false;
864     }
865 
866     function isInitialized() public view returns (bool) {
867         return false;
868     }
869 
870     function allocate(address _holder, uint256 _tokens) public onlyCrowdsale() {
871         internalAllocate(_holder, _tokens);
872     }
873 
874     function tokensAvailable() public view returns (uint256);
875 
876     function internalAllocate(address _holder, uint256 _tokens) internal onlyCrowdsale();
877 }
878 /// @title MintableTokenAllocator
879 /// @author Applicature
880 /// @notice Contract responsible for defining distribution logic of tokens.
881 /// @dev implementation
882 contract MintableTokenAllocator is TokenAllocator {
883 
884     using SafeMath for uint256;
885 
886     MintableToken public token;
887 
888     constructor(MintableToken _token) public {
889         require(address(0) != address(_token));
890         token = _token;
891     }
892 
893     /// @notice update instance of MintableToken
894     function setToken(MintableToken _token) public onlyOwner {
895         token = _token;
896     }
897 
898     function internalAllocate(address _holder, uint256 _tokens) internal {
899         token.mint(_holder, _tokens);
900     }
901 
902     /// @notice Check whether contract is initialised
903     /// @return true if initialized
904     function isInitialized() public view returns (bool) {
905         return token.mintingAgents(this);
906     }
907 
908     /// @return available tokens
909     function tokensAvailable() public view returns (uint256) {
910         return token.availableTokens();
911     }
912 
913 }
914 /// @title ContributionForwarder
915 /// @author Applicature
916 /// @notice Contract is responsible for distributing collected ethers, that are received from CrowdSale.
917 /// @dev Base class
918 contract ContributionForwarder {
919 
920     using SafeMath for uint256;
921 
922     uint256 public weiCollected;
923     uint256 public weiForwarded;
924 
925     event ContributionForwarded(address receiver, uint256 weiAmount);
926 
927     function isInitialized() public view returns (bool) {
928         return false;
929     }
930 
931     /// @notice transfer wei to receiver
932     function forward() public payable {
933         require(msg.value > 0);
934 
935         weiCollected += msg.value;
936 
937         internalForward();
938     }
939 
940     function internalForward() internal;
941 }
942 /// @title DistributedDirectContributionForwarder
943 /// @author Applicature
944 /// @notice Contract is responsible for distributing collected ethers, that are received from CrowdSale.
945 /// @dev implementation
946 contract DistributedDirectContributionForwarder is ContributionForwarder {
947     Receiver[] public receivers;
948     uint256 public proportionAbsMax;
949     bool public isInitialized_;
950 
951     struct Receiver {
952         address receiver;
953         uint256 proportion; // abslolute value in range of 0 - proportionAbsMax
954         uint256 forwardedWei;
955     }
956 
957     constructor(uint256 _proportionAbsMax, address[] _receivers, uint256[] _proportions) public {
958         proportionAbsMax = _proportionAbsMax;
959 
960         require(_receivers.length == _proportions.length);
961 
962         require(_receivers.length > 0);
963 
964         uint256 totalProportion;
965 
966         for (uint256 i = 0; i < _receivers.length; i++) {
967             uint256 proportion = _proportions[i];
968 
969             totalProportion = totalProportion.add(proportion);
970 
971             receivers.push(Receiver(_receivers[i], proportion, 0));
972         }
973 
974         require(totalProportion == proportionAbsMax);
975         isInitialized_ = true;
976     }
977 
978     /// @notice Check whether contract is initialised
979     /// @return true if initialized
980     function isInitialized() public view returns (bool) {
981         return isInitialized_;
982     }
983 
984     function internalForward() internal {
985         uint256 transferred;
986 
987         for (uint256 i = 0; i < receivers.length; i++) {
988             Receiver storage receiver = receivers[i];
989 
990             uint256 value = msg.value.mul(receiver.proportion).div(proportionAbsMax);
991 
992             if (i == receivers.length - 1) {
993                 value = msg.value.sub(transferred);
994             }
995 
996             transferred = transferred.add(value);
997 
998             receiver.receiver.transfer(value);
999 
1000             emit ContributionForwarded(receiver.receiver, value);
1001         }
1002 
1003         weiForwarded = weiForwarded.add(transferred);
1004     }
1005 }
1006 contract Crowdsale {
1007 
1008     uint256 public tokensSold;
1009 
1010     enum State {Unknown, Initializing, BeforeCrowdsale, InCrowdsale, Success, Finalized, Refunding}
1011 
1012     function externalContribution(address _contributor, uint256 _wei) public payable;
1013 
1014     function contribute(uint8 _v, bytes32 _r, bytes32 _s) public payable;
1015 
1016     function getState() public view returns (State);
1017 
1018     function updateState() public;
1019 
1020     function internalContribution(address _contributor, uint256 _wei) internal;
1021 
1022 }
1023 /// @title Crowdsale
1024 /// @author Applicature
1025 /// @notice Contract is responsible for collecting, refunding, allocating tokens during different stages of Crowdsale.
1026 contract CrowdsaleImpl is Crowdsale, Ownable {
1027 
1028     using SafeMath for uint256;
1029 
1030     State public currentState;
1031     TokenAllocator public allocator;
1032     ContributionForwarder public contributionForwarder;
1033     PricingStrategy public pricingStrategy;
1034     CrowdsaleAgent public crowdsaleAgent;
1035     bool public finalized;
1036     uint256 public startDate;
1037     uint256 public endDate;
1038     bool public allowWhitelisted;
1039     bool public allowSigned;
1040     bool public allowAnonymous;
1041     mapping(address => bool) public whitelisted;
1042     mapping(address => bool) public signers;
1043     mapping(address => bool) public externalContributionAgents;
1044 
1045     event Contribution(address _contributor, uint256 _wei, uint256 _tokensExcludingBonus, uint256 _bonus);
1046 
1047     constructor(
1048         TokenAllocator _allocator,
1049         ContributionForwarder _contributionForwarder,
1050         PricingStrategy _pricingStrategy,
1051         uint256 _startDate,
1052         uint256 _endDate,
1053         bool _allowWhitelisted,
1054         bool _allowSigned,
1055         bool _allowAnonymous
1056     ) public {
1057         allocator = _allocator;
1058         contributionForwarder = _contributionForwarder;
1059         pricingStrategy = _pricingStrategy;
1060 
1061         startDate = _startDate;
1062         endDate = _endDate;
1063 
1064         allowWhitelisted = _allowWhitelisted;
1065         allowSigned = _allowSigned;
1066         allowAnonymous = _allowAnonymous;
1067 
1068         currentState = State.Unknown;
1069     }
1070 
1071     /// @notice default payable function
1072     function() public payable {
1073         require(allowWhitelisted || allowAnonymous);
1074 
1075         if (!allowAnonymous) {
1076             if (allowWhitelisted) {
1077                 require(whitelisted[msg.sender]);
1078             }
1079         }
1080 
1081         internalContribution(msg.sender, msg.value);
1082     }
1083 
1084     /// @notice update crowdsale agent
1085     function setCrowdsaleAgent(CrowdsaleAgent _crowdsaleAgent) public onlyOwner {
1086         require(address(_crowdsaleAgent) != address(0));
1087         crowdsaleAgent = _crowdsaleAgent;
1088     }
1089 
1090     /// @notice allows external user to do contribution
1091     function externalContribution(address _contributor, uint256 _wei) public payable {
1092         require(externalContributionAgents[msg.sender]);
1093         internalContribution(_contributor, _wei);
1094     }
1095 
1096     /// @notice update external contributor
1097     function addExternalContributor(address _contributor) public onlyOwner {
1098         externalContributionAgents[_contributor] = true;
1099     }
1100 
1101     /// @notice update external contributor
1102     function removeExternalContributor(address _contributor) public onlyOwner {
1103         externalContributionAgents[_contributor] = false;
1104     }
1105 
1106     /// @notice update whitelisting address
1107     function updateWhitelist(address _address, bool _status) public onlyOwner {
1108         whitelisted[_address] = _status;
1109     }
1110 
1111     /// @notice update signer
1112     function addSigner(address _signer) public onlyOwner {
1113         signers[_signer] = true;
1114     }
1115 
1116     /// @notice update signer
1117     function removeSigner(address _signer) public onlyOwner {
1118         signers[_signer] = false;
1119     }
1120 
1121     /// @notice allows to do signed contributions
1122     function contribute(uint8 _v, bytes32 _r, bytes32 _s) public payable {
1123         address recoveredAddress = verify(msg.sender, _v, _r, _s);
1124         require(signers[recoveredAddress]);
1125         internalContribution(msg.sender, msg.value);
1126     }
1127 
1128     /// @notice check sign
1129     function verify(address _sender, uint8 _v, bytes32 _r, bytes32 _s) public view returns (address) {
1130         bytes32 hash = keccak256(abi.encodePacked(this, _sender));
1131 
1132         bytes memory prefix = '\x19Ethereum Signed Message:\n32';
1133 
1134         return ecrecover(keccak256(abi.encodePacked(prefix, hash)), _v, _r, _s);
1135     }
1136 
1137     /// @return Crowdsale state
1138     function getState() public view returns (State) {
1139         if (finalized) {
1140             return State.Finalized;
1141         } else if (allocator.isInitialized() == false) {
1142             return State.Initializing;
1143         } else if (contributionForwarder.isInitialized() == false) {
1144             return State.Initializing;
1145         } else if (pricingStrategy.isInitialized() == false) {
1146             return State.Initializing;
1147         } else if (block.timestamp < startDate) {
1148             return State.BeforeCrowdsale;
1149         } else if (block.timestamp >= startDate && block.timestamp <= endDate) {
1150             return State.InCrowdsale;
1151         } else if (block.timestamp > endDate) {
1152             return State.Success;
1153         }
1154 
1155         return State.Unknown;
1156     }
1157 
1158     /// @notice Crowdsale state
1159     function updateState() public {
1160         State state = getState();
1161 
1162         if (currentState != state) {
1163             if (crowdsaleAgent != address(0)) {
1164                 crowdsaleAgent.onStateChange(state);
1165             }
1166 
1167             currentState = state;
1168         }
1169     }
1170 
1171     function internalContribution(address _contributor, uint256 _wei) internal {
1172         require(getState() == State.InCrowdsale);
1173 
1174         uint256 tokensAvailable = allocator.tokensAvailable();
1175         uint256 collectedWei = contributionForwarder.weiCollected();
1176 
1177         uint256 tokens;
1178         uint256 tokensExcludingBonus;
1179         uint256 bonus;
1180 
1181         (tokens, tokensExcludingBonus, bonus) = pricingStrategy.getTokens(
1182             _contributor, tokensAvailable, tokensSold, _wei, collectedWei);
1183 
1184         require(tokens > 0 && tokens <= tokensAvailable);
1185         tokensSold = tokensSold.add(tokens);
1186 
1187         allocator.allocate(_contributor, tokens);
1188 
1189         if (msg.value > 0) {
1190             contributionForwarder.forward.value(msg.value)();
1191         }
1192 
1193         emit Contribution(_contributor, _wei, tokensExcludingBonus, bonus);
1194     }
1195 
1196 }
1197 /// @title HardCappedCrowdsale
1198 /// @author Applicature
1199 /// @notice Contract is responsible for collecting, refunding, allocating tokens during different stages of Crowdsale.
1200 /// with hard limit
1201 contract HardCappedCrowdsale is CrowdsaleImpl {
1202 
1203     using SafeMath for uint256;
1204 
1205     uint256 public hardCap;
1206 
1207     constructor(
1208         TokenAllocator _allocator,
1209         ContributionForwarder _contributionForwarder,
1210         PricingStrategy _pricingStrategy,
1211         uint256 _startDate,
1212         uint256 _endDate,
1213         bool _allowWhitelisted,
1214         bool _allowSigned,
1215         bool _allowAnonymous,
1216         uint256 _hardCap
1217     ) public CrowdsaleImpl(
1218         _allocator,
1219         _contributionForwarder,
1220         _pricingStrategy,
1221         _startDate,
1222         _endDate,
1223         _allowWhitelisted,
1224         _allowSigned,
1225         _allowAnonymous
1226     ) {
1227         hardCap = _hardCap;
1228     }
1229 
1230     /// @return Crowdsale state
1231     function getState() public view returns (State) {
1232         State state = super.getState();
1233 
1234         if (state == State.InCrowdsale) {
1235             if (isHardCapAchieved(0)) {
1236                 return State.Success;
1237             }
1238         }
1239 
1240         return state;
1241     }
1242 
1243     function isHardCapAchieved(uint256 _value) public view returns (bool) {
1244         if (hardCap <= tokensSold.add(_value)) {
1245             return true;
1246         }
1247         return false;
1248     }
1249 
1250     function internalContribution(address _contributor, uint256 _wei) internal {
1251         require(getState() == State.InCrowdsale);
1252 
1253         uint256 tokensAvailable = allocator.tokensAvailable();
1254         uint256 collectedWei = contributionForwarder.weiCollected();
1255 
1256         uint256 tokens;
1257         uint256 tokensExcludingBonus;
1258         uint256 bonus;
1259 
1260         (tokens, tokensExcludingBonus, bonus) = pricingStrategy.getTokens(
1261             _contributor, tokensAvailable, tokensSold, _wei, collectedWei);
1262 
1263         require(tokens <= tokensAvailable && tokens > 0 && false == isHardCapAchieved(tokens.sub(1)));
1264 
1265         tokensSold = tokensSold.add(tokens);
1266 
1267         allocator.allocate(_contributor, tokens);
1268 
1269         if (msg.value > 0) {
1270             contributionForwarder.forward.value(msg.value)();
1271         }
1272         crowdsaleAgent.onContribution(_contributor, _wei, tokensExcludingBonus, bonus);
1273         emit Contribution(_contributor, _wei, tokensExcludingBonus, bonus);
1274     }
1275 }
1276 /// @title RefundableCrowdsale
1277 /// @author Applicature
1278 /// @notice Contract is responsible for collecting, refunding, allocating tokens during different stages of Crowdsale.
1279 /// with hard and soft limits
1280 contract RefundableCrowdsale is HardCappedCrowdsale {
1281 
1282     using SafeMath for uint256;
1283 
1284     uint256 public softCap;
1285     mapping(address => uint256) public contributorsWei;
1286     address[] public contributors;
1287 
1288     event Refund(address _holder, uint256 _wei, uint256 _tokens);
1289 
1290     constructor(
1291         TokenAllocator _allocator,
1292         ContributionForwarder _contributionForwarder,
1293         PricingStrategy _pricingStrategy,
1294         uint256 _startDate,
1295         uint256 _endDate,
1296         bool _allowWhitelisted,
1297         bool _allowSigned,
1298         bool _allowAnonymous,
1299         uint256 _softCap,
1300         uint256 _hardCap
1301 
1302     ) public HardCappedCrowdsale(
1303         _allocator, _contributionForwarder, _pricingStrategy,
1304         _startDate, _endDate,
1305         _allowWhitelisted, _allowSigned, _allowAnonymous, _hardCap
1306     ) {
1307         softCap = _softCap;
1308     }
1309 
1310     /// @return Crowdsale state
1311     function getState() public view returns (State) {
1312         State state = super.getState();
1313 
1314         if (state == State.Success) {
1315             if (!isSoftCapAchieved(0)) {
1316                 return State.Refunding;
1317             }
1318         }
1319 
1320         return state;
1321     }
1322 
1323     function isSoftCapAchieved(uint256 _value) public view returns (bool) {
1324         if (softCap <= tokensSold.add(_value)) {
1325             return true;
1326         }
1327         return false;
1328     }
1329 
1330     /// @notice refund ethers to contributor
1331     function refund() public {
1332         internalRefund(msg.sender);
1333     }
1334 
1335     /// @notice refund ethers to delegate
1336     function delegatedRefund(address _address) public {
1337         internalRefund(_address);
1338     }
1339 
1340     function internalContribution(address _contributor, uint256 _wei) internal {
1341         require(block.timestamp >= startDate && block.timestamp <= endDate);
1342 
1343         uint256 tokensAvailable = allocator.tokensAvailable();
1344         uint256 collectedWei = contributionForwarder.weiCollected();
1345 
1346         uint256 tokens;
1347         uint256 tokensExcludingBonus;
1348         uint256 bonus;
1349 
1350         (tokens, tokensExcludingBonus, bonus) = pricingStrategy.getTokens(
1351             _contributor, tokensAvailable, tokensSold, _wei, collectedWei);
1352 
1353         require(tokens <= tokensAvailable && tokens > 0 && hardCap > tokensSold.add(tokens));
1354 
1355         tokensSold = tokensSold.add(tokens);
1356 
1357         allocator.allocate(_contributor, tokens);
1358 
1359         // transfer only if softcap is reached
1360         if (isSoftCapAchieved(0)) {
1361             if (msg.value > 0) {
1362                 contributionForwarder.forward.value(address(this).balance)();
1363             }
1364         } else {
1365             // store contributor if it is not stored before
1366             if (contributorsWei[_contributor] == 0) {
1367                 contributors.push(_contributor);
1368             }
1369             contributorsWei[_contributor] = contributorsWei[_contributor].add(msg.value);
1370         }
1371         crowdsaleAgent.onContribution(_contributor, _wei, tokensExcludingBonus, bonus);
1372         emit Contribution(_contributor, _wei, tokensExcludingBonus, bonus);
1373     }
1374 
1375     function internalRefund(address _holder) internal {
1376         updateState();
1377         require(block.timestamp > endDate);
1378         require(!isSoftCapAchieved(0));
1379         require(crowdsaleAgent != address(0));
1380 
1381         uint256 value = contributorsWei[_holder];
1382 
1383         require(value > 0);
1384 
1385         contributorsWei[_holder] = 0;
1386         uint256 burnedTokens = crowdsaleAgent.onRefund(_holder, 0);
1387 
1388         _holder.transfer(value);
1389 
1390         emit Refund(_holder, value, burnedTokens);
1391     }
1392 }
1393 contract ICUCrowdsale is RefundableCrowdsale {
1394 
1395     uint256 public maxSaleSupply = 2350000000e18;
1396 
1397     uint256 public availableBonusAmount = 447500000e18;
1398 
1399     uint256 public usdCollected;
1400 
1401     mapping(address => uint256) public contributorBonuses;
1402 
1403     constructor(
1404         MintableTokenAllocator _allocator,
1405         DistributedDirectContributionForwarder _contributionForwarder,
1406         ICUStrategy _pricingStrategy,
1407         uint256 _startTime,
1408         uint256 _endTime
1409     ) public RefundableCrowdsale(
1410         _allocator,
1411         _contributionForwarder,
1412         _pricingStrategy,
1413         _startTime,
1414         _endTime,
1415         true,
1416         true,
1417         false,
1418         2500000e5, //softCap
1419         23500000e5//hardCap
1420     ) {}
1421 
1422     function updateState() public {
1423         (startDate, endDate) = ICUStrategy(pricingStrategy).getActualDates();
1424         super.updateState();
1425     }
1426 
1427     function claimBonuses() public {
1428         require(isSoftCapAchieved(0) && contributorBonuses[msg.sender] > 0);
1429 
1430         uint256 bonus = contributorBonuses[msg.sender];
1431         contributorBonuses[msg.sender] = 0;
1432         allocator.allocate(msg.sender, bonus);
1433     }
1434 
1435     function addExternalContributor(address) public onlyOwner {
1436         require(false);
1437     }
1438 
1439     function isHardCapAchieved(uint256 _value) public view returns (bool) {
1440         if (hardCap <= usdCollected.add(_value)) {
1441             return true;
1442         }
1443         return false;
1444     }
1445 
1446     function isSoftCapAchieved(uint256 _value) public view returns (bool) {
1447         if (softCap <= usdCollected.add(_value)) {
1448             return true;
1449         }
1450         return false;
1451     }
1452 
1453     function internalContribution(address _contributor, uint256 _wei) internal {
1454         updateState();
1455         require(currentState == State.InCrowdsale);
1456 
1457         ICUStrategy pricing = ICUStrategy(pricingStrategy);
1458         uint256 usdAmount = pricing.getUSDAmount(_wei);
1459         require(!isHardCapAchieved(usdAmount.sub(1)));
1460 
1461         uint256 tokensAvailable = allocator.tokensAvailable();
1462         uint256 collectedWei = contributionForwarder.weiCollected();
1463         uint256 tierIndex = pricing.getTierIndex();
1464         uint256 tokens;
1465         uint256 tokensExcludingBonus;
1466         uint256 bonus;
1467 
1468         (tokens, tokensExcludingBonus, bonus) = pricing.getTokens(
1469             _contributor, tokensAvailable, tokensSold, _wei, collectedWei
1470         );
1471 
1472         require(tokens > 0);
1473         tokensSold = tokensSold.add(tokens);
1474         allocator.allocate(_contributor, tokensExcludingBonus);
1475 
1476         if (isSoftCapAchieved(usdAmount)) {
1477             if (msg.value > 0) {
1478                 contributionForwarder.forward.value(address(this).balance)();
1479             }
1480         } else {
1481             // store contributor if it is not stored before
1482             if (contributorsWei[_contributor] == 0) {
1483                 contributors.push(_contributor);
1484             }
1485             contributorsWei[_contributor] = contributorsWei[_contributor].add(msg.value);
1486         }
1487 
1488         usdCollected = usdCollected.add(usdAmount);
1489 
1490         if (availableBonusAmount > 0) {
1491             if (availableBonusAmount >= bonus) {
1492                 availableBonusAmount -= bonus;
1493             } else {
1494                 bonus = availableBonusAmount;
1495                 availableBonusAmount = 0;
1496             }
1497             contributorBonuses[_contributor] = contributorBonuses[_contributor].add(bonus);
1498         } else {
1499             bonus = 0;
1500         }
1501 
1502         crowdsaleAgent.onContribution(pricing, tierIndex, tokensExcludingBonus, bonus);
1503         emit Contribution(_contributor, _wei, tokensExcludingBonus, bonus);
1504     }
1505 
1506 }
1507 /// @title PricingStrategy
1508 /// @author Applicature
1509 /// @notice Contract is responsible for calculating tokens amount depending on different criterias
1510 /// @dev Base class
1511 contract PricingStrategy {
1512 
1513     function isInitialized() public view returns (bool);
1514 
1515     function getTokens(
1516         address _contributor,
1517         uint256 _tokensAvailable,
1518         uint256 _tokensSold,
1519         uint256 _weiAmount,
1520         uint256 _collectedWei
1521     )
1522         public
1523         view
1524         returns (uint256 tokens, uint256 tokensExludingBonus, uint256 bonus);
1525 
1526     function getWeis(
1527         uint256 _collectedWei,
1528         uint256 _tokensSold,
1529         uint256 _tokens
1530     )
1531         public
1532         view
1533         returns (uint256 weiAmount, uint256 tokensBonus);
1534 }
1535 /// @title TokenDateCappedTiersPricingStrategy
1536 /// @author Applicature
1537 /// @notice Contract is responsible for calculating tokens amount depending on price in USD
1538 /// @dev implementation
1539 contract TokenDateCappedTiersPricingStrategy is PricingStrategy, Ownable {
1540 
1541     using SafeMath for uint256;
1542 
1543     uint256 public etherPriceInUSD;
1544 
1545     uint256 public capsAmount;
1546 
1547     struct Tier {
1548         uint256 tokenInUSD;
1549         uint256 maxTokensCollected;
1550         uint256 soldTierTokens;
1551         uint256 bonusTierTokens;
1552         uint256 discountPercents;
1553         uint256 minInvestInUSD;
1554         uint256 startDate;
1555         uint256 endDate;
1556         bool unsoldProcessed;
1557         uint256[] capsData;
1558     }
1559 
1560     Tier[] public tiers;
1561     uint256 public decimals;
1562 
1563     constructor(
1564         uint256[] _tiers,
1565         uint256[] _capsData,
1566         uint256 _decimals,
1567         uint256 _etherPriceInUSD
1568     )
1569         public
1570     {
1571         decimals = _decimals;
1572         require(_etherPriceInUSD > 0);
1573         etherPriceInUSD = _etherPriceInUSD;
1574 
1575         require(_tiers.length % 6 == 0);
1576         uint256 length = _tiers.length / 6;
1577 
1578         require(_capsData.length % 2 == 0);
1579         uint256 lengthCaps = _capsData.length / 2;
1580 
1581         uint256[] memory emptyArray;
1582 
1583         for (uint256 i = 0; i < length; i++) {
1584             tiers.push(
1585                 Tier(
1586                     _tiers[i * 6],//tokenInUSD
1587                     _tiers[i * 6 + 1],//maxTokensCollected
1588                     0,//soldTierTokens
1589                     0,//bonusTierTokens
1590                     _tiers[i * 6 + 2],//discountPercents
1591                     _tiers[i * 6 + 3],//minInvestInUSD
1592                     _tiers[i * 6 + 4],//startDate
1593                     _tiers[i * 6 + 5],//endDate
1594                     false,
1595                     emptyArray//capsData
1596                 )
1597             );
1598 
1599             for (uint256 j = 0; j < lengthCaps; j++) {
1600                 tiers[i].capsData.push(_capsData[i * lengthCaps + j]);
1601             }
1602         }
1603     }
1604 
1605     /// @return tier index
1606     function getTierIndex() public view returns (uint256) {
1607         for (uint256 i = 0; i < tiers.length; i++) {
1608             if (
1609                 block.timestamp >= tiers[i].startDate &&
1610                 block.timestamp < tiers[i].endDate &&
1611                 tiers[i].maxTokensCollected > tiers[i].soldTierTokens
1612             ) {
1613                 return i;
1614             }
1615         }
1616 
1617         return tiers.length;
1618     }
1619 
1620     function getActualTierIndex() public view returns (uint256) {
1621         for (uint256 i = 0; i < tiers.length; i++) {
1622             if (
1623                 block.timestamp >= tiers[i].startDate
1624                 && block.timestamp < tiers[i].endDate
1625                 && tiers[i].maxTokensCollected > tiers[i].soldTierTokens
1626                 || block.timestamp < tiers[i].startDate
1627             ) {
1628                 return i;
1629             }
1630         }
1631 
1632         return tiers.length.sub(1);
1633     }
1634 
1635     /// @return actual dates
1636     function getActualDates() public view returns (uint256 startDate, uint256 endDate) {
1637         uint256 tierIndex = getActualTierIndex();
1638         startDate = tiers[tierIndex].startDate;
1639         endDate = tiers[tierIndex].endDate;
1640     }
1641 
1642     function getTokensWithoutRestrictions(uint256 _weiAmount) public view returns (
1643         uint256 tokens,
1644         uint256 tokensExcludingBonus,
1645         uint256 bonus
1646     ) {
1647         if (_weiAmount == 0) {
1648             return (0, 0, 0);
1649         }
1650 
1651         uint256 tierIndex = getActualTierIndex();
1652 
1653         tokensExcludingBonus = _weiAmount.mul(etherPriceInUSD).div(getTokensInUSD(tierIndex));
1654         bonus = calculateBonusAmount(tierIndex, tokensExcludingBonus);
1655         tokens = tokensExcludingBonus.add(bonus);
1656     }
1657 
1658     /// @return tokens based on sold tokens and wei amount
1659     function getTokens(
1660         address,
1661         uint256 _tokensAvailable,
1662         uint256,
1663         uint256 _weiAmount,
1664         uint256
1665     ) public view returns (uint256 tokens, uint256 tokensExcludingBonus, uint256 bonus) {
1666         if (_weiAmount == 0) {
1667             return (0, 0, 0);
1668         }
1669 
1670         uint256 tierIndex = getTierIndex();
1671         if (tierIndex == tiers.length || _weiAmount.mul(etherPriceInUSD).div(1e18) < tiers[tierIndex].minInvestInUSD) {
1672             return (0, 0, 0);
1673         }
1674 
1675         tokensExcludingBonus = _weiAmount.mul(etherPriceInUSD).div(getTokensInUSD(tierIndex));
1676 
1677         if (tiers[tierIndex].maxTokensCollected < tiers[tierIndex].soldTierTokens.add(tokensExcludingBonus)) {
1678             return (0, 0, 0);
1679         }
1680 
1681         bonus = calculateBonusAmount(tierIndex, tokensExcludingBonus);
1682         tokens = tokensExcludingBonus.add(bonus);
1683 
1684         if (tokens > _tokensAvailable) {
1685             return (0, 0, 0);
1686         }
1687     }
1688 
1689     /// @return weis based on sold and required tokens
1690     function getWeis(
1691         uint256,
1692         uint256,
1693         uint256 _tokens
1694     ) public view returns (uint256 totalWeiAmount, uint256 tokensBonus) {
1695         if (_tokens == 0) {
1696             return (0, 0);
1697         }
1698 
1699         uint256 tierIndex = getTierIndex();
1700         if (tierIndex == tiers.length) {
1701             return (0, 0);
1702         }
1703         if (tiers[tierIndex].maxTokensCollected < tiers[tierIndex].soldTierTokens.add(_tokens)) {
1704             return (0, 0);
1705         }
1706         uint256 usdAmount = _tokens.mul(getTokensInUSD(tierIndex)).div(1e18);
1707         totalWeiAmount = usdAmount.mul(1e18).div(etherPriceInUSD);
1708 
1709         if (totalWeiAmount < uint256(1 ether).mul(tiers[tierIndex].minInvestInUSD).div(etherPriceInUSD)) {
1710             return (0, 0);
1711         }
1712 
1713         tokensBonus = calculateBonusAmount(tierIndex, _tokens);
1714     }
1715 
1716     function calculateBonusAmount(uint256 _tierIndex, uint256 _tokens) public view returns (uint256 bonus) {
1717         uint256 length = tiers[_tierIndex].capsData.length.div(2);
1718 
1719         uint256 remainingTokens = _tokens;
1720         uint256 newSoldTokens = tiers[_tierIndex].soldTierTokens;
1721 
1722         for (uint256 i = 0; i < length; i++) {
1723             if (tiers[_tierIndex].capsData[i.mul(2)] == 0) {
1724                 break;
1725             }
1726             if (newSoldTokens.add(remainingTokens) <= tiers[_tierIndex].capsData[i.mul(2)]) {
1727                 bonus += remainingTokens.mul(tiers[_tierIndex].capsData[i.mul(2).add(1)]).div(100);
1728                 break;
1729             } else {
1730                 uint256 diff = tiers[_tierIndex].capsData[i.mul(2)].sub(newSoldTokens);
1731                 remainingTokens -= diff;
1732                 newSoldTokens += diff;
1733                 bonus += diff.mul(tiers[_tierIndex].capsData[i.mul(2).add(1)]).div(100);
1734             }
1735         }
1736     }
1737 
1738     function getTokensInUSD(uint256 _tierIndex) public view returns (uint256) {
1739         if (_tierIndex < uint256(tiers.length)) {
1740             return tiers[_tierIndex].tokenInUSD;
1741         }
1742     }
1743 
1744     function getDiscount(uint256 _tierIndex) public view returns (uint256) {
1745         if (_tierIndex < uint256(tiers.length)) {
1746             return tiers[_tierIndex].discountPercents;
1747         }
1748     }
1749 
1750     function getMinEtherInvest(uint256 _tierIndex) public view returns (uint256) {
1751         if (_tierIndex < uint256(tiers.length)) {
1752             return tiers[_tierIndex].minInvestInUSD.mul(1 ether).div(etherPriceInUSD);
1753         }
1754     }
1755 
1756     function getUSDAmount(uint256 _weiAmount) public view returns (uint256) {
1757         return _weiAmount.mul(etherPriceInUSD).div(1 ether);
1758     }
1759 
1760     /// @notice Check whether contract is initialised
1761     /// @return true if initialized
1762     function isInitialized() public view returns (bool) {
1763         return true;
1764     }
1765 
1766     /// @notice updates tier start/end dates by id
1767     function updateDates(uint8 _tierId, uint256 _start, uint256 _end) public onlyOwner() {
1768         if (_start != 0 && _start < _end && _tierId < tiers.length) {
1769             Tier storage tier = tiers[_tierId];
1770             tier.startDate = _start;
1771             tier.endDate = _end;
1772         }
1773     }
1774 }
1775 contract ICUStrategy is TokenDateCappedTiersPricingStrategy {
1776 
1777     ICUAgent public agent;
1778 
1779     event UnsoldTokensProcessed(uint256 fromTier, uint256 toTier, uint256 tokensAmount);
1780 
1781     constructor(
1782         uint256[] _emptyArray,
1783         uint256 _etherPriceInUSD
1784     ) public TokenDateCappedTiersPricingStrategy(
1785         _emptyArray,
1786         _emptyArray,
1787         18,
1788         _etherPriceInUSD
1789     ) {
1790         //Pre-ICO
1791         tiers.push(
1792             Tier(
1793                 0.01e5,//tokenInUSD
1794                 1000000000e18,//maxTokensCollected
1795                 0,//soldTierTokens
1796                 0,//bonusTierTokens
1797                 0,//discountPercents
1798                 uint256(20).mul(_etherPriceInUSD),//minInvestInUSD | 20 ethers
1799                 1543579200,//startDate | 2018/11/30 12:00:00 PM UTC
1800                 1544184000,//endDate | 2018/12/07 12:00:00 PM UTC
1801                 false,
1802                 _emptyArray
1803             )
1804         );
1805         //ICO
1806         tiers.push(
1807             Tier(
1808                 0.01e5,//tokenInUSD
1809                 1350000000e18,//maxTokensCollected
1810                 0,//soldTierTokens
1811                 0,//bonusTierTokens
1812                 0,//discountPercents
1813                 uint256(_etherPriceInUSD).div(10),//minInvestInUSD | 0.1 ether
1814                 1544443200,//startDate | 2018/12/10	12:00:00 PM UTC
1815                 1546257600,//endDate | 2018/12/31 12:00:00 PM UTC
1816                 false,
1817                 _emptyArray
1818             )
1819         );
1820 
1821         //Pre-ICO caps data
1822         tiers[0].capsData.push(1000000000e18);//cap $10,000,000 in tokens
1823         tiers[0].capsData.push(30);//bonus percents
1824 
1825         //ICO caps data
1826         tiers[1].capsData.push(400000000e18);//cap $4,000,000 in tokens
1827         tiers[1].capsData.push(20);//bonus percents
1828 
1829         tiers[1].capsData.push(800000000e18);//cap $4,000,000 in tokens
1830         tiers[1].capsData.push(10);//bonus percents
1831 
1832         tiers[1].capsData.push(1350000000e18);//cap $5,500,000 in tokens
1833         tiers[1].capsData.push(5);//bonus percents
1834 
1835     }
1836 
1837     function getArrayOfTiers() public view returns (uint256[14] tiersData) {
1838         uint256 j = 0;
1839         for (uint256 i = 0; i < tiers.length; i++) {
1840             tiersData[j++] = uint256(tiers[i].tokenInUSD);
1841             tiersData[j++] = uint256(tiers[i].maxTokensCollected);
1842             tiersData[j++] = uint256(tiers[i].soldTierTokens);
1843             tiersData[j++] = uint256(tiers[i].discountPercents);
1844             tiersData[j++] = uint256(tiers[i].minInvestInUSD);
1845             tiersData[j++] = uint256(tiers[i].startDate);
1846             tiersData[j++] = uint256(tiers[i].endDate);
1847         }
1848     }
1849 
1850     function updateTier(
1851         uint256 _tierId,
1852         uint256 _start,
1853         uint256 _end,
1854         uint256 _minInvest,
1855         uint256 _price,
1856         uint256 _discount,
1857         uint256[] _capsData,
1858         bool updateLockNeeded
1859     ) public onlyOwner() {
1860         require(
1861             _start != 0 &&
1862             _price != 0 &&
1863             _start < _end &&
1864             _tierId < tiers.length &&
1865             _capsData.length > 0 &&
1866             _capsData.length % 2 == 0
1867         );
1868 
1869         if (updateLockNeeded) {
1870             agent.updateLockPeriod(_end);
1871         }
1872 
1873         Tier storage tier = tiers[_tierId];
1874         tier.tokenInUSD = _price;
1875         tier.discountPercents = _discount;
1876         tier.minInvestInUSD = _minInvest;
1877         tier.startDate = _start;
1878         tier.endDate = _end;
1879         tier.capsData = _capsData;
1880     }
1881 
1882     function setCrowdsaleAgent(ICUAgent _crowdsaleAgent) public onlyOwner {
1883         agent = _crowdsaleAgent;
1884     }
1885 
1886     function updateTierState(uint256 _tierId, uint256 _soldTokens, uint256 _bonusTokens) public {
1887         require(
1888             msg.sender == address(agent) &&
1889             _tierId < tiers.length &&
1890             _soldTokens > 0
1891         );
1892 
1893         Tier storage tier = tiers[_tierId];
1894 
1895         if (_tierId > 0 && !tiers[_tierId.sub(1)].unsoldProcessed) {
1896             Tier storage prevTier = tiers[_tierId.sub(1)];
1897             prevTier.unsoldProcessed = true;
1898 
1899             uint256 unsold = prevTier.maxTokensCollected.sub(prevTier.soldTierTokens);
1900             tier.maxTokensCollected = tier.maxTokensCollected.add(unsold);
1901             tier.capsData[0] = tier.capsData[0].add(unsold);
1902 
1903             emit UnsoldTokensProcessed(_tierId.sub(1), _tierId, unsold);
1904         }
1905 
1906         tier.soldTierTokens = tier.soldTierTokens.add(_soldTokens);
1907         tier.bonusTierTokens = tier.bonusTierTokens.add(_bonusTokens);
1908     }
1909 
1910     function getTierUnsoldTokens(uint256 _tierId) public view returns (uint256) {
1911         if (_tierId >= tiers.length || tiers[_tierId].unsoldProcessed) {
1912             return 0;
1913         }
1914 
1915         return tiers[_tierId].maxTokensCollected.sub(tiers[_tierId].soldTierTokens);
1916     }
1917 
1918     function getUnsoldTokens() public view returns (uint256 unsoldTokens) {
1919         for (uint256 i = 0; i < tiers.length; i++) {
1920             unsoldTokens += getTierUnsoldTokens(i);
1921         }
1922     }
1923 
1924     function getCapsData(uint256 _tierId) public view returns (uint256[]) {
1925         if (_tierId < tiers.length) {
1926             return tiers[_tierId].capsData;
1927         }
1928     }
1929 
1930 }
1931 contract Referral is Ownable {
1932 
1933     using SafeMath for uint256;
1934 
1935     MintableTokenAllocator public allocator;
1936     CrowdsaleImpl public crowdsale;
1937 
1938     uint256 public constant DECIMALS = 18;
1939 
1940     uint256 public totalSupply;
1941     bool public unLimited;
1942     bool public sentOnce;
1943 
1944     mapping(address => bool) public claimed;
1945     mapping(address => uint256) public claimedBalances;
1946 
1947     constructor(
1948         uint256 _totalSupply,
1949         address _allocator,
1950         address _crowdsale,
1951         bool _sentOnce
1952     ) public {
1953         require(_allocator != address(0) && _crowdsale != address(0));
1954         totalSupply = _totalSupply;
1955         if (totalSupply == 0) {
1956             unLimited = true;
1957         }
1958         allocator = MintableTokenAllocator(_allocator);
1959         crowdsale = CrowdsaleImpl(_crowdsale);
1960         sentOnce = _sentOnce;
1961     }
1962 
1963     function setAllocator(address _allocator) public onlyOwner {
1964         require(_allocator != address(0));
1965         allocator = MintableTokenAllocator(_allocator);
1966     }
1967 
1968     function setCrowdsale(address _crowdsale) public onlyOwner {
1969         require(_crowdsale != address(0));
1970         crowdsale = CrowdsaleImpl(_crowdsale);
1971     }
1972 
1973     function multivestMint(
1974         address _address,
1975         uint256 _amount,
1976         uint8 _v,
1977         bytes32 _r,
1978         bytes32 _s
1979     ) public {
1980         require(true == crowdsale.signers(verify(msg.sender, _amount, _v, _r, _s)));
1981         if (true == sentOnce) {
1982             require(claimed[_address] == false);
1983             claimed[_address] = true;
1984         }
1985         require(
1986             _address == msg.sender &&
1987             _amount > 0 &&
1988             (true == unLimited || _amount <= totalSupply)
1989         );
1990         claimedBalances[_address] = claimedBalances[_address].add(_amount);
1991         if (false == unLimited) {
1992             totalSupply = totalSupply.sub(_amount);
1993         }
1994         allocator.allocate(_address, _amount);
1995     }
1996 
1997     /// @notice check sign
1998     function verify(address _sender, uint256 _amount, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address) {
1999         bytes32 hash = keccak256(abi.encodePacked(_sender, _amount));
2000 
2001         bytes memory prefix = '\x19Ethereum Signed Message:\n32';
2002 
2003         return ecrecover(keccak256(abi.encodePacked(prefix, hash)), _v, _r, _s);
2004     }
2005 }
2006 contract ICUReferral is Referral {
2007 
2008     constructor(
2009         address _allocator,
2010         address _crowdsale
2011     ) public Referral(35000000e18, _allocator, _crowdsale, true) {}
2012 
2013     function multivestMint(
2014         address _address,
2015         uint256 _amount,
2016         uint8 _v,
2017         bytes32 _r,
2018         bytes32 _s
2019     ) public {
2020         ICUCrowdsale icuCrowdsale = ICUCrowdsale(crowdsale);
2021         icuCrowdsale.updateState();
2022         require(icuCrowdsale.isSoftCapAchieved(0) && block.timestamp > icuCrowdsale.endDate());
2023         super.multivestMint(_address, _amount, _v, _r, _s);
2024     }
2025 }
2026 contract Stats {
2027 
2028     using SafeMath for uint256;
2029 
2030     MintableToken public token;
2031     MintableTokenAllocator public allocator;
2032     ICUCrowdsale public crowdsale;
2033     ICUStrategy public pricing;
2034 
2035     constructor(
2036         MintableToken _token,
2037         MintableTokenAllocator _allocator,
2038         ICUCrowdsale _crowdsale,
2039         ICUStrategy _pricing
2040     ) public {
2041         token = _token;
2042         allocator = _allocator;
2043         crowdsale = _crowdsale;
2044         pricing = _pricing;
2045     }
2046 
2047     function getTokens(
2048         uint256,
2049         uint256 _weiAmount
2050     ) public view returns (uint256 tokens, uint256 tokensExcludingBonus, uint256 bonus) {
2051         return pricing.getTokensWithoutRestrictions(_weiAmount);
2052     }
2053 
2054     function getWeis(
2055         uint256,
2056         uint256 _tokenAmount
2057     ) public view returns (uint256 totalWeiAmount, uint256 tokensBonus) {
2058         return pricing.getWeis(0, 0, _tokenAmount);
2059     }
2060 
2061     function getStats(uint256 _userType, uint256[7] _ethPerCurrency) public view returns (
2062         uint256[8] stats,
2063         uint256[26] tiersData,
2064         uint256[21] currencyContr //tokensPerEachCurrency,
2065     ) {
2066         stats = getStatsData(_userType);
2067         tiersData = getTiersData(_userType);
2068         currencyContr = getCurrencyContrData(_userType, _ethPerCurrency);
2069     }
2070 
2071     function getTiersData(uint256) public view returns (
2072         uint256[26] tiersData
2073     ) {
2074         uint256[14] memory tiers = pricing.getArrayOfTiers();
2075         uint256 tierElements = tiers.length.div(2);
2076         uint256 j = 0;
2077         for (uint256 i = 0; i <= tierElements; i += tierElements) {
2078             tiersData[j++] = uint256(1e23).div(tiers[i]);// tokenInUSD;
2079             tiersData[j++] = 0;// tokenInWei;
2080             tiersData[j++] = uint256(tiers[i.add(1)]);// maxTokensCollected;
2081             tiersData[j++] = uint256(tiers[i.add(2)]);// soldTierTokens;
2082             tiersData[j++] = 0;// discountPercents;
2083             tiersData[j++] = 0;// bonusPercents;
2084             tiersData[j++] = uint256(tiers[i.add(4)]);// minInvestInUSD;
2085             tiersData[j++] = 0;// minInvestInWei;
2086             tiersData[j++] = 0;// maxInvestInUSD;
2087             tiersData[j++] = 0;// maxInvestInWei;
2088             tiersData[j++] = uint256(tiers[i.add(5)]);// startDate;
2089             tiersData[j++] = uint256(tiers[i.add(6)]);// endDate;
2090             tiersData[j++] = 1;
2091         }
2092 
2093         tiersData[25] = 2;
2094     }
2095 
2096     function getStatsData(uint256 _type) public view returns (
2097         uint256[8] stats
2098     ) {
2099         _type = _type;
2100         stats[0] = token.maxSupply();
2101         stats[1] = token.totalSupply();
2102         stats[2] = crowdsale.maxSaleSupply();
2103         stats[3] = crowdsale.tokensSold();
2104         stats[4] = uint256(crowdsale.currentState());
2105         stats[5] = pricing.getActualTierIndex();
2106         stats[6] = pricing.getTierUnsoldTokens(stats[5]);
2107         stats[7] = pricing.getMinEtherInvest(stats[5]);
2108     }
2109 
2110     function getCurrencyContrData(uint256 _type, uint256[7] _ethPerCurrency) public view returns (
2111         uint256[21] currencyContr
2112     ) {
2113         _type = _type;
2114         uint256 j = 0;
2115         for (uint256 i = 0; i < _ethPerCurrency.length; i++) {
2116             (currencyContr[j++], currencyContr[j++], currencyContr[j++]) = pricing.getTokensWithoutRestrictions(
2117                 _ethPerCurrency[i]
2118             );
2119         }
2120     }
2121 
2122 }
2123 contract PeriodicTokenVesting is TokenVesting {
2124     address public unreleasedHolder;
2125     uint256 public periods;
2126 
2127     constructor(
2128         address _beneficiary,
2129         uint256 _start,
2130         uint256 _cliff,
2131         uint256 _duration,
2132         uint256 _periods,
2133         bool _revocable,
2134         address _unreleasedHolder
2135     )
2136         public TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable)
2137     {
2138         require(_revocable == false || _unreleasedHolder != address(0));
2139         periods = _periods;
2140         unreleasedHolder = _unreleasedHolder;
2141     }
2142 
2143     /**
2144     * @dev Calculates the amount that has already vested.
2145     * @param token ERC20 token which is being vested
2146     */
2147     function vestedAmount(ERC20Basic token) public view returns (uint256) {
2148         uint256 currentBalance = token.balanceOf(this);
2149         uint256 totalBalance = currentBalance.add(released[token]);
2150 
2151         if (now < cliff) {
2152             return 0;
2153         } else if (now >= start.add(duration * periods) || revoked[token]) {
2154             return totalBalance;
2155         } else {
2156 
2157             uint256 periodTokens = totalBalance.div(periods);
2158 
2159             uint256 periodsOver = now.sub(start).div(duration);
2160 
2161             if (periodsOver >= periods) {
2162                 return totalBalance;
2163             }
2164 
2165             return periodTokens.mul(periodsOver);
2166         }
2167     }
2168 
2169     /**
2170  * @notice Allows the owner to revoke the vesting. Tokens already vested
2171  * remain in the contract, the rest are returned to the owner.
2172  * @param token ERC20 token which is being vested
2173  */
2174     function revoke(ERC20Basic token) public onlyOwner {
2175         require(revocable);
2176         require(!revoked[token]);
2177 
2178         uint256 balance = token.balanceOf(this);
2179 
2180         uint256 unreleased = releasableAmount(token);
2181         uint256 refund = balance.sub(unreleased);
2182 
2183         revoked[token] = true;
2184 
2185         token.safeTransfer(unreleasedHolder, refund);
2186 
2187         emit Revoked();
2188     }
2189 }
2190 contract ICUAllocation is Ownable {
2191 
2192     using SafeERC20 for ERC20Basic;
2193     using SafeMath for uint256;
2194 
2195     uint256 public constant BOUNTY_TOKENS = 47000000e18;
2196     uint256 public constant MAX_TREASURY_TOKENS = 2350000000e18;
2197 
2198     uint256 public icoEndTime;
2199 
2200     address[] public vestings;
2201 
2202     address public bountyAddress;
2203 
2204     address public treasuryAddress;
2205 
2206     bool public isBountySent;
2207 
2208     bool public isTeamSent;
2209 
2210     event VestingCreated(
2211         address _vesting,
2212         address _beneficiary,
2213         uint256 _start,
2214         uint256 _cliff,
2215         uint256 _duration,
2216         uint256 _periods,
2217         bool _revocable
2218     );
2219 
2220     event VestingRevoked(address _vesting);
2221 
2222     constructor(address _bountyAddress, address _treasuryAddress) public {
2223         require(_bountyAddress != address(0) && _treasuryAddress != address(0));
2224         bountyAddress = _bountyAddress;
2225         treasuryAddress = _treasuryAddress;
2226     }
2227 
2228     function setICOEndTime(uint256 _icoEndTime) public onlyOwner {
2229         icoEndTime = _icoEndTime;
2230     }
2231 
2232     function allocateBounty(MintableTokenAllocator _allocator, ICUCrowdsale _crowdsale) public onlyOwner {
2233         require(!isBountySent && icoEndTime < block.timestamp && _crowdsale.isSoftCapAchieved(0));
2234 
2235         isBountySent = true;
2236         _allocator.allocate(bountyAddress, BOUNTY_TOKENS);
2237     }
2238 
2239     function allocateTreasury(MintableTokenAllocator _allocator) public onlyOwner {
2240         require(icoEndTime < block.timestamp, 'ICO is not ended');
2241         require(isBountySent, 'Bounty is not sent');
2242         require(isTeamSent, 'Team vesting is not created');
2243         require(MAX_TREASURY_TOKENS >= _allocator.tokensAvailable(), 'Unsold tokens are not burned');
2244 
2245         _allocator.allocate(treasuryAddress, _allocator.tokensAvailable());
2246     }
2247 
2248     function createVesting(
2249         address _beneficiary,
2250         uint256 _start,
2251         uint256 _cliff,
2252         uint256 _duration,
2253         uint256 _periods,
2254         bool _revocable,
2255         address _unreleasedHolder,
2256         MintableTokenAllocator _allocator,
2257         uint256 _amount
2258     ) public onlyOwner returns (PeriodicTokenVesting) {
2259         require(icoEndTime > 0 && _amount > 0);
2260 
2261         isTeamSent = true;
2262 
2263         PeriodicTokenVesting vesting = new PeriodicTokenVesting(
2264             _beneficiary, _start, _cliff, _duration, _periods, _revocable, _unreleasedHolder
2265         );
2266 
2267         vestings.push(vesting);
2268 
2269         emit VestingCreated(vesting, _beneficiary, _start, _cliff, _duration, _periods, _revocable);
2270 
2271         _allocator.allocate(address(vesting), _amount);
2272 
2273         return vesting;
2274     }
2275 
2276     function revokeVesting(PeriodicTokenVesting _vesting, ERC20Basic token) public onlyOwner() {
2277         _vesting.revoke(token);
2278 
2279         emit VestingRevoked(_vesting);
2280     }
2281 }