1 pragma solidity ^0.5.0;
2 
3 
4 library Roles {
5     struct Role {
6         mapping (address => bool) bearer;
7     }
8 
9     /**
10      * @dev give an account access to this role
11      */
12     function add(Role storage role, address account) internal {
13         require(account != address(0));
14         require(!has(role, account));
15 
16         role.bearer[account] = true;
17     }
18 
19     /**
20      * @dev remove an account's access to this role
21      */
22     function remove(Role storage role, address account) internal {
23         require(account != address(0));
24         require(has(role, account));
25 
26         role.bearer[account] = false;
27     }
28 
29     /**
30      * @dev check if an account has this role
31      * @return bool
32      */
33     function has(Role storage role, address account) internal view returns (bool) {
34         require(account != address(0));
35         return role.bearer[account];
36     }
37 }
38 
39 
40 contract Ownable {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     constructor () internal {
50         _owner = msg.sender;
51         emit OwnershipTransferred(address(0), _owner);
52     }
53 
54     /**
55      * @return the address of the owner.
56      */
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(isOwner());
66         _;
67     }
68 
69     /**
70      * @return true if `msg.sender` is the owner of the contract.
71      */
72     function isOwner() public view returns (bool) {
73         return msg.sender == _owner;
74     }
75 
76     /**
77      * @dev Allows the current owner to relinquish control of the contract.
78      * @notice Renouncing to ownership will leave the contract without an owner.
79      * It will not be possible to call the functions with the `onlyOwner`
80      * modifier anymore.
81      */
82     function renounceOwnership() public onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Allows the current owner to transfer control of the contract to a newOwner.
89      * @param newOwner The address to transfer ownership to.
90      */
91     function transferOwnership(address newOwner) public onlyOwner {
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers control of the contract to a newOwner.
97      * @param newOwner The address to transfer ownership to.
98      */
99     function _transferOwnership(address newOwner) internal {
100         require(newOwner != address(0));
101         emit OwnershipTransferred(_owner, newOwner);
102         _owner = newOwner;
103     }
104 }
105 
106 
107 /**
108  * @title SafeMath
109  * @dev Math operations with safety checks that throw on error
110  */
111 library SafeMath {
112 
113   /**
114   * @dev Multiplies two numbers, throws on overflow.
115   */
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) {
118         return 0;
119         }
120         uint256 c = a * b;
121         assert(c / a == b);
122         return c;
123     }
124 
125     /**
126     * @dev Integer division of two numbers, truncating the quotient.
127     */
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         // assert(b > 0); // Solidity automatically throws when dividing by 0
130         uint256 c = a / b;
131         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132         return c;
133     }
134 
135     /**
136     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
137     */
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         assert(b <= a);
140         return a - b;
141     }
142 
143     /**
144     * @dev Adds two numbers, throws on overflow.
145     */
146     function add(uint256 a, uint256 b) internal pure returns (uint256) {
147         uint256 c = a + b;
148         assert(c >= a);
149         return c;
150     }
151 }
152 
153 interface IERC20 {
154     function transfer(address to, uint256 value) external returns (bool);
155 
156     function approve(address spender, uint256 value) external returns (bool);
157 
158     function transferFrom(address from, address to, uint256 value) external returns (bool);
159 
160     function totalSupply() external view returns (uint256);
161 
162     function balanceOf(address who) external view returns (uint256);
163 
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 contract ERC20 is IERC20 {
172     using SafeMath for uint256;
173 
174     mapping (address => uint256) private _balances;
175 
176     mapping (address => mapping (address => uint256)) private _allowed;
177 
178     uint256 private _totalSupply;
179 
180     /**
181     * @dev Total number of tokens in existence
182     */
183     function totalSupply() public view returns (uint256) {
184         return _totalSupply;
185     }
186 
187     /**
188     * @dev Gets the balance of the specified address.
189     * @param owner The address to query the balance of.
190     * @return An uint256 representing the amount owned by the passed address.
191     */
192     function balanceOf(address owner) public view returns (uint256) {
193         return _balances[owner];
194     }
195 
196     /**
197      * @dev Function to check the amount of tokens that an owner allowed to a spender.
198      * @param owner address The address which owns the funds.
199      * @param spender address The address which will spend the funds.
200      * @return A uint256 specifying the amount of tokens still available for the spender.
201      */
202     function allowance(address owner, address spender) public view returns (uint256) {
203         return _allowed[owner][spender];
204     }
205 
206     /**
207     * @dev Transfer token for a specified address
208     * @param to The address to transfer to.
209     * @param value The amount to be transferred.
210     */
211     function transfer(address to, uint256 value) public returns (bool) {
212         _transfer(msg.sender, to, value);
213         return true;
214     }
215 
216     /**
217      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218      * Beware that changing an allowance with this method brings the risk that someone may use both the old
219      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222      * @param spender The address which will spend the funds.
223      * @param value The amount of tokens to be spent.
224      */
225     function approve(address spender, uint256 value) public returns (bool) {
226         require(spender != address(0));
227 
228         _allowed[msg.sender][spender] = value;
229         emit Approval(msg.sender, spender, value);
230         return true;
231     }
232 
233     /**
234      * @dev Transfer tokens from one address to another.
235      * Note that while this function emits an Approval event, this is not required as per the specification,
236      * and other compliant implementations may not emit the event.
237      * @param from address The address which you want to send tokens from
238      * @param to address The address which you want to transfer to
239      * @param value uint256 the amount of tokens to be transferred
240      */
241     function transferFrom(address from, address to, uint256 value) public returns (bool) {
242         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
243         _transfer(from, to, value);
244         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
245         return true;
246     }
247 
248     /**
249      * @dev Increase the amount of tokens that an owner allowed to a spender.
250      * approve should be called when allowed_[_spender] == 0. To increment
251      * allowed value is better to use this function to avoid 2 calls (and wait until
252      * the first transaction is mined)
253      * From MonolithDAO Token.sol
254      * Emits an Approval event.
255      * @param spender The address which will spend the funds.
256      * @param addedValue The amount of tokens to increase the allowance by.
257      */
258     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
259         require(spender != address(0));
260 
261         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
262         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
263         return true;
264     }
265 
266     /**
267      * @dev Decrease the amount of tokens that an owner allowed to a spender.
268      * approve should be called when allowed_[_spender] == 0. To decrement
269      * allowed value is better to use this function to avoid 2 calls (and wait until
270      * the first transaction is mined)
271      * From MonolithDAO Token.sol
272      * Emits an Approval event.
273      * @param spender The address which will spend the funds.
274      * @param subtractedValue The amount of tokens to decrease the allowance by.
275      */
276     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
277         require(spender != address(0));
278 
279         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
280         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
281         return true;
282     }
283 
284     /**
285     * @dev Transfer token for a specified addresses
286     * @param from The address to transfer from.
287     * @param to The address to transfer to.
288     * @param value The amount to be transferred.
289     */
290     function _transfer(address from, address to, uint256 value) internal {
291         require(to != address(0));
292 
293         _balances[from] = _balances[from].sub(value);
294         _balances[to] = _balances[to].add(value);
295         emit Transfer(from, to, value);
296     }
297 
298     /**
299      * @dev Internal function that mints an amount of the token and assigns it to
300      * an account. This encapsulates the modification of balances such that the
301      * proper events are emitted.
302      * @param account The account that will receive the created tokens.
303      * @param value The amount that will be created.
304      */
305     function _mint(address account, uint256 value) internal {
306         require(account != address(0));
307 
308         _totalSupply = _totalSupply.add(value);
309         _balances[account] = _balances[account].add(value);
310         emit Transfer(address(0), account, value);
311     }
312 
313     /**
314      * @dev Internal function that burns an amount of the token of a given
315      * account.
316      * @param account The account whose tokens will be burnt.
317      * @param value The amount that will be burnt.
318      */
319     function _burn(address account, uint256 value) internal {
320         require(account != address(0));
321 
322         _totalSupply = _totalSupply.sub(value);
323         _balances[account] = _balances[account].sub(value);
324         emit Transfer(account, address(0), value);
325     }
326 
327     /**
328      * @dev Internal function that burns an amount of the token of a given
329      * account, deducting from the sender's allowance for said account. Uses the
330      * internal burn function.
331      * Emits an Approval event (reflecting the reduced allowance).
332      * @param account The account whose tokens will be burnt.
333      * @param value The amount that will be burnt.
334      */
335     function _burnFrom(address account, uint256 value) internal {
336         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
337         _burn(account, value);
338         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
339     }
340 }
341 
342 contract ERC20Burnable is ERC20 {
343     /**
344      * @dev Burns a specific amount of tokens.
345      * @param value The amount of token to be burned.
346      */
347     function burn(uint256 value) public {
348         _burn(msg.sender, value);
349     }
350 
351     /**
352      * @dev Burns a specific amount of tokens from the target address and decrements allowance
353      * @param from address The address which you want to send tokens from
354      * @param value uint256 The amount of token to be burned
355      */
356     function burnFrom(address from, uint256 value) public {
357         _burnFrom(from, value);
358     }
359 }
360 
361 
362 contract PauserRole {
363     using Roles for Roles.Role;
364 
365     event PauserAdded(address indexed account);
366     event PauserRemoved(address indexed account);
367 
368     Roles.Role private _pausers;
369 
370     constructor () internal {
371         _addPauser(msg.sender);
372     }
373 
374     modifier onlyPauser() {
375         require(isPauser(msg.sender));
376         _;
377     }
378 
379     function isPauser(address account) public view returns (bool) {
380         return _pausers.has(account);
381     }
382 
383     function addPauser(address account) public onlyPauser {
384         _addPauser(account);
385     }
386 
387     function renouncePauser() public {
388         _removePauser(msg.sender);
389     }
390 
391     function _addPauser(address account) internal {
392         _pausers.add(account);
393         emit PauserAdded(account);
394     }
395 
396     function _removePauser(address account) internal {
397         _pausers.remove(account);
398         emit PauserRemoved(account);
399     }
400 }
401 
402 contract Pausable is PauserRole {
403     event Paused(address account);
404     event Unpaused(address account);
405 
406     bool private _paused;
407 
408     constructor () internal {
409         _paused = false;
410     }
411 
412     /**
413      * @return true if the contract is paused, false otherwise.
414      */
415     function paused() public view returns (bool) {
416         return _paused;
417     }
418 
419     /**
420      * @dev Modifier to make a function callable only when the contract is not paused.
421      */
422     modifier whenNotPaused() {
423         require(!_paused);
424         _;
425     }
426 
427     /**
428      * @dev Modifier to make a function callable only when the contract is paused.
429      */
430     modifier whenPaused() {
431         require(_paused);
432         _;
433     }
434 
435     /**
436      * @dev called by the owner to pause, triggers stopped state
437      */
438     function pause() public onlyPauser whenNotPaused {
439         _paused = true;
440         emit Paused(msg.sender);
441     }
442 
443     /**
444      * @dev called by the owner to unpause, returns to normal state
445      */
446     function unpause() public onlyPauser whenPaused {
447         _paused = false;
448         emit Unpaused(msg.sender);
449     }
450 }
451 
452 
453 contract ERC20Pausable is ERC20, Pausable {
454     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
455         return super.transfer(to, value);
456     }
457 
458     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
459         return super.transferFrom(from, to, value);
460     }
461 
462     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
463         return super.approve(spender, value);
464     }
465 
466     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
467         return super.increaseAllowance(spender, addedValue);
468     }
469 
470     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
471         return super.decreaseAllowance(spender, subtractedValue);
472     }
473 }
474 
475 
476 contract MintableAndPausableToken is ERC20Pausable, Ownable {
477     uint8 public constant decimals = 18;
478     uint256 public maxTokenSupply = 183500000 * 10 ** uint256(decimals);
479 
480     bool public mintingFinished = false;
481 
482     event Mint(address indexed to, uint256 amount);
483     event MintFinished();
484     event MintStarted();
485 
486     modifier canMint() {
487         require(!mintingFinished);
488         _;
489     }
490 
491     modifier checkMaxSupply(uint256 _amount) {
492         require(maxTokenSupply >= totalSupply().add(_amount));
493         _;
494     }
495 
496     modifier cannotMint() {
497         require(mintingFinished);
498         _;
499     }
500 
501     function mint(address _to, uint256 _amount)
502         external
503         onlyOwner
504         canMint
505         checkMaxSupply (_amount)
506         whenNotPaused
507         returns (bool)
508     {
509         super._mint(_to, _amount);
510         return true;
511     }
512 
513     function _mint(address _to, uint256 _amount)
514         internal
515         canMint
516         checkMaxSupply (_amount)
517     {
518         super._mint(_to, _amount);
519     }
520 
521     function finishMinting() external onlyOwner canMint returns (bool) {
522         mintingFinished = true;
523         emit MintFinished();
524         return true;
525     }
526 
527     function startMinting() external onlyOwner cannotMint returns (bool) {
528         mintingFinished = false;
529         emit MintStarted();
530         return true;
531     }
532 }
533 
534 
535 
536 /**
537  * Token upgrader interface inspired by Lunyr.
538  *
539  * Token upgrader transfers previous version tokens to a newer version.
540  * Token upgrader itself can be the token contract, or just a middle man contract doing the heavy lifting.
541  */
542 contract TokenUpgrader {
543     uint public originalSupply;
544 
545     /** Interface marker */
546     function isTokenUpgrader() external pure returns (bool) {
547         return true;
548     }
549 
550     function upgradeFrom(address _from, uint256 _value) public;
551 }
552 
553 
554 
555 contract UpgradeableToken is MintableAndPausableToken {
556     // Contract or person who can set the upgrade path.
557     address public upgradeMaster;
558     
559     // Bollean value needs to be true to start upgrades
560     bool private upgradesAllowed;
561 
562     // The next contract where the tokens will be migrated.
563     TokenUpgrader public tokenUpgrader;
564 
565     // How many tokens we have upgraded by now.
566     uint public totalUpgraded;
567 
568     /**
569     * Upgrade states.
570     * - NotAllowed: The child contract has not reached a condition where the upgrade can begin
571     * - Waiting: Token allows upgrade, but we don't have a new token version
572     * - ReadyToUpgrade: The token version is set, but not a single token has been upgraded yet
573     * - Upgrading: Token upgrader is set and the balance holders can upgrade their tokens
574     */
575     enum UpgradeState { NotAllowed, Waiting, ReadyToUpgrade, Upgrading }
576 
577     // Somebody has upgraded some of his tokens.
578     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
579 
580     // New token version available.
581     event TokenUpgraderIsSet(address _newToken);
582 
583     modifier onlyUpgradeMaster {
584         // Only a master can designate the next token
585         require(msg.sender == upgradeMaster);
586         _;
587     }
588 
589     modifier notInUpgradingState {
590         // Upgrade has already begun for token
591         require(getUpgradeState() != UpgradeState.Upgrading);
592         _;
593     }
594 
595     // Do not allow construction without upgrade master set.
596     constructor(address _upgradeMaster) public {
597         upgradeMaster = _upgradeMaster;
598     }
599 
600     // set a token upgrader
601     function setTokenUpgrader(address _newToken)
602         external
603         onlyUpgradeMaster
604         notInUpgradingState
605     {
606         require(canUpgrade());
607         require(_newToken != address(0));
608 
609         tokenUpgrader = TokenUpgrader(_newToken);
610 
611         // Handle bad interface
612         require(tokenUpgrader.isTokenUpgrader());
613 
614         // Make sure that token supplies match in source and target
615         require(tokenUpgrader.originalSupply() == totalSupply());
616 
617         emit TokenUpgraderIsSet(address(tokenUpgrader));
618     }
619 
620     // Allow the token holder to upgrade some of their tokens to a new contract.
621     function upgrade(uint _value) external {
622         UpgradeState state = getUpgradeState();
623         
624         // Check upgrate state 
625         require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
626         // Validate input value
627         require(_value != 0);
628 
629         //balances[msg.sender] = balances[msg.sender].sub(_value);
630         // Take tokens out from circulation
631         //totalSupply_ = totalSupply_.sub(_value);
632         //the _burn method emits the Transfer event
633         _burn(msg.sender, _value);
634 
635         totalUpgraded = totalUpgraded.add(_value);
636 
637         // Token Upgrader reissues the tokens
638         tokenUpgrader.upgradeFrom(msg.sender, _value);
639         emit Upgrade(msg.sender, address(tokenUpgrader), _value);
640     }
641 
642     /**
643     * Change the upgrade master.
644     * This allows us to set a new owner for the upgrade mechanism.
645     */
646     function setUpgradeMaster(address _newMaster) external onlyUpgradeMaster {
647         require(_newMaster != address(0));
648         upgradeMaster = _newMaster;
649     }
650 
651     // To be overriden to add functionality
652     function allowUpgrades() external onlyUpgradeMaster () {
653         upgradesAllowed = true;
654     }
655 
656     // To be overriden to add functionality
657     function rejectUpgrades() external onlyUpgradeMaster () {
658         require(!(totalUpgraded > 0));
659         upgradesAllowed = false;
660     }
661 
662     // Get the state of the token upgrade.
663     function getUpgradeState() public view returns(UpgradeState) {
664         if (!canUpgrade()) return UpgradeState.NotAllowed;
665         else if (address(tokenUpgrader) == address(0)) return UpgradeState.Waiting;
666         else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
667         else return UpgradeState.Upgrading;
668     }
669 
670     // To be overriden to add functionality
671     function canUpgrade() public view returns(bool) {
672         return upgradesAllowed;
673     }
674 }
675 
676 
677 
678 contract Token is UpgradeableToken, ERC20Burnable {
679     string public name;
680     string public symbol;
681 
682     // For patient incentive programs
683     uint256 public INITIAL_SUPPLY;
684     uint256 public hodlPremiumCap;
685     uint256 public hodlPremiumMinted;
686 
687     // After 180 days you get a constant maximum bonus of 25% of tokens transferred
688     // Before that it is spread out linearly(from 0% to 25%) starting from the
689     // contribution time till 180 days after that
690     uint256 constant maxBonusDuration = 180 days;
691 
692     struct Bonus {
693         uint256 hodlTokens;
694         uint256 contributionTime;
695         uint256 buybackTokens;
696     }
697 
698     mapping( address => Bonus ) public hodlPremium;
699 
700     IERC20 stablecoin;
701     address stablecoinPayer;
702 
703     uint256 public signupWindowStart;
704     uint256 public signupWindowEnd;
705 
706     uint256 public refundWindowStart;
707     uint256 public refundWindowEnd;
708 
709     event UpdatedTokenInformation(string newName, string newSymbol);
710     event HodlPremiumSet(address beneficiary, uint256 tokens, uint256 contributionTime);
711     event HodlPremiumCapSet(uint256 newhodlPremiumCap);
712     event RegisteredForRefund( address holder, uint256 tokens );
713 
714     constructor (address _litWallet, address _upgradeMaster, uint256 _INITIAL_SUPPLY, uint256 _hodlPremiumCap)
715         public
716         UpgradeableToken(_upgradeMaster)
717         Ownable()
718     {
719         require(maxTokenSupply >= _INITIAL_SUPPLY.mul(10 ** uint256(decimals)));
720         INITIAL_SUPPLY = _INITIAL_SUPPLY.mul(10 ** uint256(decimals));
721         setHodlPremiumCap(_hodlPremiumCap)  ;
722         _mint(_litWallet, INITIAL_SUPPLY);
723     }
724 
725     /**
726     * Owner can update token information here
727     */
728     function setTokenInformation(string calldata _name, string calldata _symbol) external onlyOwner {
729         name = _name;
730         symbol = _symbol;
731 
732         emit UpdatedTokenInformation(name, symbol);
733     }
734 
735     function setRefundSignupDetails( uint256 _startTime,  uint256 _endTime, ERC20 _stablecoin, address _payer ) public onlyOwner {
736         require( _startTime < _endTime );
737         stablecoin = _stablecoin;
738         stablecoinPayer = _payer;
739         signupWindowStart = _startTime;
740         signupWindowEnd = _endTime;
741         refundWindowStart = signupWindowStart + 182 days;
742         refundWindowEnd = signupWindowEnd + 182 days;
743         require( refundWindowStart > signupWindowEnd);
744     }
745 
746     function signUpForRefund( uint256 _value ) public {
747         require( hodlPremium[msg.sender].hodlTokens != 0 || hodlPremium[msg.sender].buybackTokens != 0, "You must be ICO user to sign up" ); //the user was registered in ICO
748         require( block.timestamp >= signupWindowStart&& block.timestamp <= signupWindowEnd, "Cannot sign up at this time" );
749         uint256 value = _value;
750         value = value.add(hodlPremium[msg.sender].buybackTokens);
751 
752         if( value > balanceOf(msg.sender)) //cannot register more than he or she has; since refund has to happen while token is paused, we don't need to check anything else
753             value = balanceOf(msg.sender);
754 
755         hodlPremium[ msg.sender].buybackTokens = value;
756         //buyback cancels hodl highway
757         if( hodlPremium[msg.sender].hodlTokens > 0 ){
758             hodlPremium[msg.sender].hodlTokens = 0;
759             emit HodlPremiumSet( msg.sender, 0, hodlPremium[msg.sender].contributionTime );
760         }
761 
762         emit RegisteredForRefund(msg.sender, value);
763     }
764 
765     function refund( uint256 _value ) public {
766         require( block.timestamp >= refundWindowStart && block.timestamp <= refundWindowEnd, "cannot refund now" );
767         require( hodlPremium[msg.sender].buybackTokens >= _value, "not enough tokens in refund program" );
768         require( balanceOf(msg.sender) >= _value, "not enough tokens" ); //this check is probably redundant to those in _burn, but better check twice
769         hodlPremium[msg.sender].buybackTokens = hodlPremium[msg.sender].buybackTokens.sub(_value);
770         _burn( msg.sender, _value );
771         require( stablecoin.transferFrom( stablecoinPayer, msg.sender, _value.div(20) ), "transfer failed" ); //we pay 1/20 = 0.05 DAI for 1 LIT
772     }
773 
774     function setHodlPremiumCap(uint256 newhodlPremiumCap) public onlyOwner {
775         require(newhodlPremiumCap > 0);
776         hodlPremiumCap = newhodlPremiumCap;
777         emit HodlPremiumCapSet(hodlPremiumCap);
778     }
779 
780     /**
781     * Owner can burn token here
782     */
783     function burn(uint256 _value) public onlyOwner {
784         super.burn(_value);
785     }
786 
787     function sethodlPremium(
788         address beneficiary,
789         uint256 value,
790         uint256 contributionTime
791     )
792         public
793         onlyOwner
794         returns (bool)
795     {
796         require(beneficiary != address(0) && value > 0 && contributionTime > 0, "Not eligible for HODL Premium");
797 
798         if (hodlPremium[beneficiary].hodlTokens != 0) {
799             hodlPremium[beneficiary].hodlTokens = hodlPremium[beneficiary].hodlTokens.add(value);
800             emit HodlPremiumSet(beneficiary, hodlPremium[beneficiary].hodlTokens, hodlPremium[beneficiary].contributionTime);
801         } else {
802             hodlPremium[beneficiary] = Bonus(value, contributionTime, 0);
803             emit HodlPremiumSet(beneficiary, value, contributionTime);
804         }
805 
806         return true;
807     }
808 
809     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
810         require(_to != address(0));
811         require(_value <= balanceOf(msg.sender));
812 
813         if (hodlPremiumMinted < hodlPremiumCap && hodlPremium[msg.sender].hodlTokens > 0) {
814             uint256 amountForBonusCalculation = calculateAmountForBonus(msg.sender, _value);
815             uint256 bonus = calculateBonus(msg.sender, amountForBonusCalculation);
816 
817             //subtract the tokens token into account here to avoid the above calculations in the future, e.g. in case I withdraw everything in 0 days (bonus 0), and then refund, I shall not be eligible for any bonuses
818             hodlPremium[msg.sender].hodlTokens = hodlPremium[msg.sender].hodlTokens.sub(amountForBonusCalculation);
819             if ( bonus > 0) {
820                 //balances[msg.sender] = balances[msg.sender].add(bonus);
821                 _mint( msg.sender, bonus );
822                 //emit Transfer(address(0), msg.sender, bonus);
823             }
824         }
825 
826         ERC20Pausable.transfer( _to, _value );
827 //        balances[msg.sender] = balances[msg.sender].sub(_value);
828 //        balances[_to] = balances[_to].add(_value);
829 //        emit Transfer(msg.sender, _to, _value);
830 
831         //TODO: optimize to avoid setting values outside of buyback window
832         if( balanceOf(msg.sender) < hodlPremium[msg.sender].buybackTokens )
833             hodlPremium[msg.sender].buybackTokens = balanceOf(msg.sender);
834         return true;
835     }
836 
837     function transferFrom(
838         address _from,
839         address _to,
840         uint256 _value
841     )
842         public
843         whenNotPaused
844         returns (bool)
845     {
846         require(_to != address(0));
847 
848         if (hodlPremiumMinted < hodlPremiumCap && hodlPremium[_from].hodlTokens > 0) {
849             uint256 amountForBonusCalculation = calculateAmountForBonus(_from, _value);
850             uint256 bonus = calculateBonus(_from, amountForBonusCalculation);
851 
852             //subtract the tokens token into account here to avoid the above calculations in the future, e.g. in case I withdraw everything in 0 days (bonus 0), and then refund, I shall not be eligible for any bonuses
853             hodlPremium[_from].hodlTokens = hodlPremium[_from].hodlTokens.sub(amountForBonusCalculation);
854             if ( bonus > 0) {
855                 //balances[_from] = balances[_from].add(bonus);
856                 _mint( _from, bonus );
857                 //emit Transfer(address(0), _from, bonus);
858             }
859         }
860 
861         ERC20Pausable.transferFrom( _from, _to, _value);
862         if( balanceOf(_from) < hodlPremium[_from].buybackTokens )
863             hodlPremium[_from].buybackTokens = balanceOf(_from);
864         return true;
865     }
866 
867     function calculateBonus(address beneficiary, uint256 amount) internal returns (uint256) {
868         uint256 bonusAmount;
869 
870         uint256 contributionTime = hodlPremium[beneficiary].contributionTime;
871         uint256 bonusPeriod;
872         if (now <= contributionTime) {
873             bonusPeriod = 0;
874         } else if (now.sub(contributionTime) >= maxBonusDuration) {
875             bonusPeriod = maxBonusDuration;
876         } else {
877             bonusPeriod = now.sub(contributionTime);
878         }
879 
880         if (bonusPeriod != 0) {
881             bonusAmount = (((bonusPeriod.mul(amount)).div(maxBonusDuration)).mul(25)).div(100);
882             if (hodlPremiumMinted.add(bonusAmount) > hodlPremiumCap) {
883                 bonusAmount = hodlPremiumCap.sub(hodlPremiumMinted);
884                 hodlPremiumMinted = hodlPremiumCap;
885             } else {
886                 hodlPremiumMinted = hodlPremiumMinted.add(bonusAmount);
887             }
888 
889             if( totalSupply().add(bonusAmount) > maxTokenSupply )
890                 bonusAmount = maxTokenSupply.sub(totalSupply());
891         }
892 
893         return bonusAmount;
894     }
895 
896     function calculateAmountForBonus(address beneficiary, uint256 _value) internal view returns (uint256) {
897         uint256 amountForBonusCalculation;
898 
899         if(_value >= hodlPremium[beneficiary].hodlTokens) {
900             amountForBonusCalculation = hodlPremium[beneficiary].hodlTokens;
901         } else {
902             amountForBonusCalculation = _value;
903         }
904 
905         return amountForBonusCalculation;
906     }
907 
908 }
909 
910 
911 contract TestToken is ERC20{
912     constructor ( uint256 _balance)public {
913         _mint(msg.sender, _balance);
914     }
915 }