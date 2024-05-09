1 pragma solidity ^ 0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns(uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55     function totalSupply() public view returns(uint256);
56     function balanceOf(address who) public view returns(uint256);
57     function transfer(address to, uint256 value) public returns(bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66     using SafeMath for uint256;
67     
68     mapping(address => uint256) balances;
69     
70     uint256 totalSupply_;
71     
72     /**
73     * @dev total number of tokens in existence
74     */
75     function totalSupply() public view returns (uint256) {
76         return totalSupply_;
77     }
78     
79     /**
80     * @dev transfer token for a specified address
81     * @param _to The address to transfer to.
82     * @param _value The amount to be transferred.
83     */
84     function transfer(address _to, uint256 _value) public returns (bool) {
85         require(_to != address(0));
86         require(_value <= balances[msg.sender]);
87 
88         balances[msg.sender] = balances[msg.sender].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         emit Transfer(msg.sender, _to, _value);
91         return true;
92     }
93     
94     /**
95     * @dev Gets the balance of the specified address.
96     * @param _owner The address to query the the balance of.
97     * @return An uint256 representing the amount owned by the passed address.
98     */
99     function balanceOf(address _owner) public view returns (uint256) {
100         return balances[_owner];
101     }
102 }
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109     function allowance(address owner, address spender) public view returns(uint256);
110     function transferFrom(address from, address to, uint256 value) public returns(bool);
111     function approve(address spender, uint256 value) public returns(bool);
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125     mapping (address => mapping (address => uint256)) internal allowed;
126 
127 
128     /**
129      * @dev Transfer tokens from one address to another
130      * @param _from address The address which you want to send tokens from
131      * @param _to address The address which you want to transfer to
132      * @param _value uint256 the amount of tokens to be transferred
133      */
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135         require(_to != address(0));
136         require(_value <= balances[_from]);
137         require(_value <= allowed[_from][msg.sender]);
138         
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         emit Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      *
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param _spender The address which will spend the funds.
154      * @param _value The amount of tokens to be spent.
155      */
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         require((_value != 0) && (allowed[msg.sender][_spender] != 0));
158 
159         allowed[msg.sender][_spender] = _value;
160         emit Approval(msg.sender, _spender, _value);
161         return true;
162     }
163 
164     /**
165      * @dev Function to check the amount of tokens that an owner allowed to a spender.
166      * @param _owner address The address which owns the funds.
167      * @param _spender address The address which will spend the funds.
168      * @return A uint256 specifying the amount of tokens still available for the spender.
169      */
170     function allowance(address _owner, address _spender) public view returns (uint256) {
171         return allowed[_owner][_spender];
172     }
173 }
174 
175 /**
176  * @title Ownable
177  * @dev The Ownable contract has an owner address, and provides basic authorization control
178  * functions, this simplifies the implementation of "user permissions".
179  */
180 contract Ownable {
181     address public owner;
182 
183     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
184 
185 
186     /**
187      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
188      * account.
189      */
190     function Ownable() public {
191         owner = msg.sender;
192     }
193 
194     /**
195      * @dev Throws if called by any account other than the owner.
196      */
197     modifier onlyOwner() {
198         require(msg.sender == owner);
199         _;
200     }
201 
202     /**
203      * @dev Allows the current owner to transfer control of the contract to a newOwner.
204      * @param newOwner The address to transfer ownership to.
205      */
206     function transferOwnership(address newOwner) public onlyOwner {
207         require(newOwner != address(0));
208         emit OwnershipTransferred(owner, newOwner);
209         owner = newOwner;
210     }
211 }
212 
213 /**
214  * @title Claimable
215  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
216  * This allows the new owner to accept the transfer.
217  */
218 contract Claimable is Ownable {
219     address public pendingOwner;
220 
221     /**
222      * @dev Modifier throws if called by any account other than the pendingOwner.
223      */
224     modifier onlyPendingOwner() {
225         require(msg.sender == pendingOwner);
226         _;
227     }
228 
229     /**
230      * @dev Allows the current owner to set the pendingOwner address.
231      * @param newOwner The address to transfer ownership to.
232      */
233     function transferOwnership(address newOwner) public onlyOwner {
234         pendingOwner = newOwner;
235     }
236 
237     /**
238      * @dev Allows the pendingOwner address to finalize the transfer.
239      */
240     function claimOwnership() onlyPendingOwner public {
241         emit OwnershipTransferred(owner, pendingOwner);
242         owner = pendingOwner;
243         pendingOwner = address(0);
244     }
245 }
246 
247 /**
248  * @title Mintable token
249  * @dev Simple ERC20 Token example, with mintable token creation
250  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
251  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
252  */
253 contract MintableToken is StandardToken, Claimable {
254     event Mint(address indexed to, uint256 amount);
255     event MintFinished();
256 
257     bool public mintingFinished = false;
258 
259 
260     modifier canMint() {
261         require(!mintingFinished);
262         _;
263     }
264 
265     /**
266      * @dev Function to mint tokens
267      * @param _to The address that will receive the minted tokens.
268      * @param _amount The amount of tokens to mint.
269      * @return A boolean that indicates if the operation was successful.
270      */
271     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
272         return _mint(_to, _amount);
273     }
274 
275     function _mint(address _to, uint256 _amount) internal canMint returns (bool) {
276         totalSupply_ = totalSupply_.add(_amount);
277         balances[_to] = balances[_to].add(_amount);
278         emit Mint(_to, _amount);
279         emit Transfer(address(0), _to, _amount);
280     }
281 
282     /**
283      * @dev Function to stop minting new tokens.
284      * @return True if the operation was successful.
285      */
286     function finishMinting() public onlyOwner canMint returns (bool) {
287         mintingFinished = true;
288         emit MintFinished();
289         return true;
290     }
291 }
292 
293 /**
294  * @title Pausable
295  * @dev Base contract which allows children to implement an emergency stop mechanism.
296  */
297 contract Pausable is Claimable {
298     event Pause();
299     event Unpause();
300 
301     bool public paused = false;
302 
303 
304     /**
305      * @dev Modifier to make a function callable only when the contract is not paused.
306      */
307     modifier whenNotPaused() {
308         require(!paused);
309         _;
310     }
311 
312     /**
313      * @dev Modifier to make a function callable only when the contract is paused.
314      */
315     modifier whenPaused() {
316         require(paused);
317         _;
318     }
319 
320     /**
321      * @dev called by the owner to pause, triggers stopped state
322      */
323     function pause() public onlyOwner whenNotPaused {
324         paused = true;
325         emit Pause();
326     }
327 
328     /**
329      * @dev called by the owner to unpause, returns to normal state
330      */
331     function unpause() public onlyOwner whenPaused {
332         paused = false;
333         emit Unpause();
334     }
335 }
336 
337 /**
338  * @title Pausable token
339  * @dev StandardToken modified with pausable transfers.
340  **/
341 contract PausableToken is StandardToken, Pausable {
342 
343     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
344         return super.transfer(_to, _value);
345     }
346 
347     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
348         return super.transferFrom(_from, _to, _value);
349     }
350 
351     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
352         return super.approve(_spender, _value);
353     }
354 }
355 
356 /**
357  * @title Burnable Token
358  * @dev Token that can be irreversibly burned (destroyed).
359  */
360 contract BurnableToken is BasicToken {
361 
362     event Burn(address indexed burner, uint256 value);
363 
364     /**
365      * @dev Burns a specific amount of tokens.
366      * @param _value The amount of token to be burned.
367      */
368     function burn(uint256 _value) public {
369         _burn(msg.sender, _value);
370     }
371 
372     function _burn(address _who, uint256 _value) internal {
373         require(_value <= balances[_who]);
374         // no need to require value <= totalSupply, since that would imply the
375         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
376 
377         balances[_who] = balances[_who].sub(_value);
378         totalSupply_ = totalSupply_.sub(_value);
379         emit Burn(_who, _value);
380         emit Transfer(_who, address(0), _value);
381     }
382 }
383 
384 /**
385  * @title SafeERC20
386  * @dev Wrappers around ERC20 operations that throw on failure.
387  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
388  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
389  */
390 library SafeERC20 {
391     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
392         assert(token.transfer(to, value));
393     }
394 
395     function safeTransferFrom(
396         ERC20 token,
397         address from,
398         address to,
399         uint256 value
400     )
401         internal
402     {
403         assert(token.transferFrom(from, to, value));
404     }
405 
406     function safeApprove(ERC20 token, address spender, uint256 value) internal {
407         assert(token.approve(spender, value));
408     }
409 }
410 
411 /**
412  * @title TokenTimelock
413  * @dev TokenTimelock is a token holder contract that will allow a
414  * beneficiary to extract the tokens after a given release time
415  */
416 contract TokenTimelock {
417     using SafeERC20 for ERC20Basic;
418 
419     // ERC20 basic token contract being held
420     ERC20Basic public token;
421 
422     // beneficiary of tokens after they are released
423     address public beneficiary;
424 
425     // timestamp when token release is enabled
426     uint256 public releaseTime;
427 
428     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
429         // solium-disable-next-line security/no-block-members
430         require(_releaseTime > block.timestamp);
431         token = _token;
432         beneficiary = _beneficiary;
433         releaseTime = _releaseTime;
434     }
435 
436     function canRelease() public view returns (bool){
437         return block.timestamp >= releaseTime;
438     }
439 
440     /**
441      * @notice Transfers tokens held by timelock to beneficiary.
442      */
443     function release() public {
444         // solium-disable-next-line security/no-block-members
445         require(canRelease());
446 
447         uint256 amount = token.balanceOf(this);
448         require(amount > 0);
449 
450         token.safeTransfer(beneficiary, amount);
451     }
452 }
453 
454 /**
455  * @title Crowdsale
456  * @dev Crowdsale is a base contract for managing a token crowdsale,
457  * allowing investors to purchase tokens with ether. This contract implements
458  * such functionality in its most fundamental form and can be extended to provide additional
459  * functionality and/or custom behavior.
460  * The external interface represents the basic interface for purchasing tokens, and conform
461  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
462  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
463  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
464  * behavior.
465  */
466 contract Crowdsale{
467     using SafeMath for uint256;
468 
469     enum TokenLockType { TYPE_NOT_LOCK, TYPE_SEED_INVESTOR, TYPE_PRE_SALE, TYPE_TEAM}
470     uint256 internal constant UINT256_MAX = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
471     uint8 internal constant SEED_INVESTOR_BONUS_RATE = 50;
472     uint256 internal constant MAX_SALECOUNT_PER_ADDRESS = 30;
473 
474     // Address where funds are collected
475     address public wallet;
476 
477     // How many token units a buyer gets per ether. eg: 1 ETH = 5000 ISC
478     uint256 public rate = 5000;
479 
480     // Amount of wei raised
481     uint256 public weiRaised;
482 
483     Phase[] internal phases;
484 
485     struct Phase {
486         uint256 till;
487         uint256 bonusRate;
488     }
489 
490     uint256 public currentPhase = 0;
491     mapping (address => uint256 ) public saleCount;
492 
493     /**
494      * Event for token purchase logging
495      * @param purchaser who paid for the tokens
496      * @param beneficiary who got the tokens
497      * @param value weis paid for purchase
498      * @param amount amount of tokens purchased
499      */
500     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
501     
502     /**
503      * @param _wallet Address where collected funds will be forwarded to
504      */
505     function Crowdsale(address _wallet) public {
506         require(_wallet != address(0));
507 
508         phases.push(Phase({ till: 1527782400, bonusRate: 30 })); // 2018/6/01 00:00 UTC +8
509         phases.push(Phase({ till: 1531238400, bonusRate: 20 })); // 2018/07/11 00:00 UTC +8
510         phases.push(Phase({ till: 1533916800, bonusRate: 10 })); // 2018/08/11 00:00 UTC +8
511         phases.push(Phase({ till: UINT256_MAX, bonusRate: 0 })); // unlimited
512 
513         wallet = _wallet;
514     }
515 
516     // -----------------------------------------
517     // Crowdsale external interface
518     // -----------------------------------------
519 
520     /**
521      * @dev fallback function ***DO NOT OVERRIDE***
522      */
523     function () external payable {
524         buyTokens(msg.sender);
525     }
526 
527     /**
528      * @dev low level token purchase ***DO NOT OVERRIDE***
529      * @param _beneficiary Address performing the token purchase
530      */
531     function buyTokens(address _beneficiary) public payable {
532 
533         uint256 weiAmount = msg.value;
534         _preValidatePurchase(_beneficiary, weiAmount);
535 
536         uint256 nowTime = block.timestamp;
537         // this loop moves phases and insures correct stage according to date
538         while (currentPhase < phases.length && phases[currentPhase].till < nowTime) {
539             currentPhase = currentPhase.add(1);
540         }
541 
542         //check the min ether in pre-sale phase
543         if (currentPhase == 0) {
544             require(weiAmount >= 1 ether);
545         }
546 
547         // calculate token amount to be created
548         uint256 tokens = _getTokenAmount(weiAmount);
549         // calculate token lock type
550         TokenLockType lockType = _getTokenLockType(weiAmount);
551 
552         if (lockType != TokenLockType.TYPE_NOT_LOCK) {
553             require(saleCount[_beneficiary].add(1) <= MAX_SALECOUNT_PER_ADDRESS);
554             saleCount[_beneficiary] = saleCount[_beneficiary].add(1);
555         }
556 
557         // update state
558         weiRaised = weiRaised.add(weiAmount);
559 
560         _deliverTokens(_beneficiary, tokens, lockType);
561         emit TokenPurchase(
562             msg.sender,
563             _beneficiary,
564             weiAmount,
565             tokens
566         );
567 
568         _forwardFunds();
569     }
570 
571     // -----------------------------------------
572     // Internal interface (extensible)
573     // -----------------------------------------
574 
575     /**
576      * @dev Validation of an incoming purchase. Use require statements to revert state 
577      *      when conditions are not met. Use super to concatenate validations.
578      * @param _beneficiary Address performing the token purchase
579      * @param _weiAmount Value in wei involved in the purchase
580      */
581     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
582         require(_beneficiary != address(0));
583         require(_weiAmount != 0);
584         require(currentPhase < phases.length);
585     }
586 
587     /**
588      * @dev Source of tokens. Override this method to modify the way in which 
589      *      the crowdsale ultimately gets and sends its tokens.
590      * @param _beneficiary Address performing the token purchase
591      * @param _tokenAmount Number of tokens to be emitted
592      */
593     function _deliverTokens(address _beneficiary, uint256 _tokenAmount, TokenLockType lockType) internal {
594 
595     }
596 
597     /**
598      * @dev Override to extend the way in which ether is converted to tokens.
599      * @param _weiAmount Value in wei to be converted into tokens
600      * @return Number of tokens that can be purchased with the specified _weiAmount
601      */
602     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
603         uint256 tokens = _weiAmount.mul(rate);
604         uint256 bonusRate = 0;
605         if (_weiAmount >= 1000 ether) {
606             bonusRate = SEED_INVESTOR_BONUS_RATE;
607         } else {
608             bonusRate = phases[currentPhase].bonusRate;
609         }
610         uint256 bonus = tokens.mul(bonusRate).div(uint256(100));        
611         return tokens.add(bonus);
612     }
613 
614     /**
615      * @dev get the token lock type
616      * @param _weiAmount Value in wei to be converted into tokens
617      * @return token lock type
618      */
619     function _getTokenLockType(uint256 _weiAmount) internal view returns (TokenLockType) {
620         TokenLockType lockType = TokenLockType.TYPE_NOT_LOCK;
621         if (_weiAmount >= 1000 ether) {
622             lockType = TokenLockType.TYPE_SEED_INVESTOR;
623         } else if (currentPhase == 0 ) {
624             lockType = TokenLockType.TYPE_PRE_SALE;
625         }
626         return lockType;
627     }
628 
629     /**
630      * @dev Determines how ETH is stored/forwarded on purchases.
631      */
632     function _forwardFunds() internal {
633         wallet.transfer(msg.value);
634     }
635 }
636 
637 contract StopableCrowdsale is Crowdsale, Claimable{
638 
639     bool public crowdsaleStopped = false;
640     /**
641      * @dev Reverts if not in crowdsale time range.
642      */
643     modifier onlyNotStopped {
644         // solium-disable-next-line security/no-block-members
645         require(!crowdsaleStopped);
646         _;
647     }
648 
649     /**
650      * @dev Extend parent behavior requiring to be within contributing period
651      * @param _beneficiary Token purchaser
652      * @param _weiAmount Amount of wei contributed
653      */
654     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view onlyNotStopped {
655         super._preValidatePurchase(_beneficiary, _weiAmount);
656     }
657 
658     function stopCrowdsale() public onlyOwner {
659         require(!crowdsaleStopped);
660         crowdsaleStopped = true;
661     }
662 
663     function startCrowdsale() public onlyOwner {
664         require(crowdsaleStopped);
665         crowdsaleStopped = false;
666     }
667 }
668 
669 
670 /**
671  * @title ISCoin
672  * @dev IS Coin contract
673  */
674 contract ISCoin is PausableToken, MintableToken, BurnableToken, StopableCrowdsale {
675     using SafeMath for uint256;
676 
677     string public name = "Imperial Star Coin";
678     string public symbol = "ISC";
679     uint8 public decimals = 18;
680 
681     mapping (address => address[] ) public balancesLocked;
682 
683     function ISCoin(address _wallet) public Crowdsale(_wallet) {}
684 
685 
686     function setRate(uint256 _rate) public onlyOwner onlyNotStopped {
687         require(_rate > 0);
688         rate = _rate;
689     }
690 
691     function setWallet(address _wallet) public onlyOwner onlyNotStopped {
692         require(_wallet != address(0));
693         wallet = _wallet;
694     }    
695 
696     /**
697      * @dev mint timelocked tokens for owner use
698     */
699     function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime) 
700     public onlyOwner canMint returns (TokenTimelock) {
701         return _mintTimelocked(_to, _amount, _releaseTime);
702     }
703 
704     /**
705      * @dev Gets the locked balance of the specified address.
706      * @param _owner The address to query the locked balance of.
707      * @return An uint256 representing the amount owned by the passed address.
708      */
709     function balanceOfLocked(address _owner) public view returns (uint256) {
710         address[] memory timelockAddrs = balancesLocked[_owner];
711 
712         uint256 totalLockedBalance = 0;
713         for (uint i = 0; i < timelockAddrs.length; i++) {
714             totalLockedBalance = totalLockedBalance.add(balances[timelockAddrs[i]]);
715         }
716         
717         return totalLockedBalance;
718     }
719 
720     function releaseToken(address _owner) public {
721         address[] memory timelockAddrs = balancesLocked[_owner];
722         for (uint i = 0; i < timelockAddrs.length; i++) {
723             TokenTimelock timelock = TokenTimelock(timelockAddrs[i]);
724             if (timelock.canRelease() && balances[timelock] > 0) {
725                 timelock.release();
726             }
727         }
728     }
729 
730     /**
731      * @dev mint timelocked tokens
732     */
733     function _mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime)
734     internal canMint returns (TokenTimelock) {
735         TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
736         balancesLocked[_to].push(timelock);
737         _mint(timelock, _amount);
738         return timelock;
739     }
740 
741     /**
742      * @dev Source of tokens. Override this method to modify the way in which 
743      *      the crowdsale ultimately gets and sends its tokens.
744      * @param _beneficiary Address performing the token purchase
745      * @param _tokenAmount Number of tokens to be emitted
746      */
747     function _deliverTokens(address _beneficiary, uint256 _tokenAmount, TokenLockType lockType) internal {
748         if (lockType == TokenLockType.TYPE_NOT_LOCK) {
749             _mint(_beneficiary, _tokenAmount);
750         } else if (lockType == TokenLockType.TYPE_SEED_INVESTOR) {
751             //seed insvestor will be locked for 6 months and then unlocked at one time
752             _mintTimelocked(_beneficiary, _tokenAmount, now + 6 * 30 days);
753         } else if (lockType == TokenLockType.TYPE_PRE_SALE) {
754             //Pre-sale will be locked for 6 months and unlocked in 3 times(every 2 months)
755             uint256 amount1 = _tokenAmount.mul(30).div(100);    //first unlock 30%
756             uint256 amount2 = _tokenAmount.mul(30).div(100);    //second unlock 30%
757             uint256 amount3 = _tokenAmount.sub(amount1).sub(amount2);   //third unlock 50%
758             uint256 releaseTime1 = now + 2 * 30 days;
759             uint256 releaseTime2 = now + 4 * 30 days;
760             uint256 releaseTime3 = now + 6 * 30 days;
761             _mintTimelocked(_beneficiary, amount1, releaseTime1);
762             _mintTimelocked(_beneficiary, amount2, releaseTime2);
763             _mintTimelocked(_beneficiary, amount3, releaseTime3);
764         }
765     }
766 }