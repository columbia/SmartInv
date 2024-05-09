1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev give an account access to this role
14      */
15     function add(Role storage role, address account) internal {
16         require(account != address(0));
17         require(!has(role, account));
18 
19         role.bearer[account] = true;
20     }
21 
22     /**
23      * @dev remove an account's access to this role
24      */
25     function remove(Role storage role, address account) internal {
26         require(account != address(0));
27         require(has(role, account));
28 
29         role.bearer[account] = false;
30     }
31 
32     /**
33      * @dev check if an account has this role
34      * @return bool
35      */
36     function has(Role storage role, address account) internal view returns (bool) {
37         require(account != address(0));
38         return role.bearer[account];
39     }
40 }
41 
42 contract PauserRole {
43     using Roles for Roles.Role;
44 
45     event PauserAdded(address indexed account);
46     event PauserRemoved(address indexed account);
47 
48     Roles.Role private _pausers;
49 
50     constructor () internal {
51         _addPauser(msg.sender);
52     }
53 
54     modifier onlyPauser() {
55         require(isPauser(msg.sender));
56         _;
57     }
58 
59     function isPauser(address account) public view returns (bool) {
60         return _pausers.has(account);
61     }
62 
63     function addPauser(address account) public onlyPauser {
64         _addPauser(account);
65     }
66 
67     function renouncePauser() public {
68         _removePauser(msg.sender);
69     }
70 
71     function _addPauser(address account) internal {
72         _pausers.add(account);
73         emit PauserAdded(account);
74     }
75 
76     function _removePauser(address account) internal {
77         _pausers.remove(account);
78         emit PauserRemoved(account);
79     }
80 }
81 
82 /**
83  * @title Pausable
84  * @dev Base contract which allows children to implement an emergency stop mechanism.
85  */
86 contract Pausable is PauserRole {
87     event Paused(address account);
88     event Unpaused(address account);
89 
90     bool private _paused;
91 
92     constructor () internal {
93         _paused = false;
94     }
95 
96     /**
97      * @return true if the contract is paused, false otherwise.
98      */
99     function paused() public view returns (bool) {
100         return _paused;
101     }
102 
103     /**
104      * @dev Modifier to make a function callable only when the contract is not paused.
105      */
106     modifier whenNotPaused() {
107         require(!_paused);
108         _;
109     }
110 
111     /**
112      * @dev Modifier to make a function callable only when the contract is paused.
113      */
114     modifier whenPaused() {
115         require(_paused);
116         _;
117     }
118 
119     /**
120      * @dev called by the owner to pause, triggers stopped state
121      */
122     function pause() public onlyPauser whenNotPaused {
123         _paused = true;
124         emit Paused(msg.sender);
125     }
126 
127     /**
128      * @dev called by the owner to unpause, returns to normal state
129      */
130     function unpause() public onlyPauser whenPaused {
131         _paused = false;
132         emit Unpaused(msg.sender);
133     }
134 }
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 interface IERC20 {
141     function transfer(address to, uint256 value) external returns (bool);
142 
143     function approve(address spender, uint256 value) external returns (bool);
144 
145     function transferFrom(address from, address to, uint256 value) external returns (bool);
146 
147     function totalSupply() external view returns (uint256);
148 
149     function balanceOf(address who) external view returns (uint256);
150 
151     function allowance(address owner, address spender) external view returns (uint256);
152 
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 /**
159  * @title ERC20Detailed token
160  * @dev The decimals are only for visualization purposes.
161  * All the operations are done using the smallest and indivisible token unit,
162  * just as on Ethereum all the operations are done in wei.
163  */
164 contract ERC20Detailed is IERC20 {
165     string private _name;
166     string private _symbol;
167     uint8 private _decimals;
168 
169     constructor (string memory name, string memory symbol, uint8 decimals) public {
170         _name = name;
171         _symbol = symbol;
172         _decimals = decimals;
173     }
174 
175     /**
176      * @return the name of the token.
177      */
178     function name() public view returns (string memory) {
179         return _name;
180     }
181 
182     /**
183      * @return the symbol of the token.
184      */
185     function symbol() public view returns (string memory) {
186         return _symbol;
187     }
188 
189     /**
190      * @return the number of decimals of the token.
191      */
192     function decimals() public view returns (uint8) {
193         return _decimals;
194     }
195 }
196 
197 /**
198  * @title SafeMath
199  * @dev Unsigned math operations with safety checks that revert on error
200  */
201 library SafeMath {
202     /**
203      * @dev Multiplies two unsigned integers, reverts on overflow.
204      */
205     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
206         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
207         // benefit is lost if 'b' is also tested.
208         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
209         if (a == 0) {
210             return 0;
211         }
212 
213         uint256 c = a * b;
214         require(c / a == b);
215 
216         return c;
217     }
218 
219     /**
220      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         // Solidity only automatically asserts when dividing by 0
224         require(b > 0);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
233      */
234     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
235         require(b <= a);
236         uint256 c = a - b;
237 
238         return c;
239     }
240 
241     /**
242      * @dev Adds two unsigned integers, reverts on overflow.
243      */
244     function add(uint256 a, uint256 b) internal pure returns (uint256) {
245         uint256 c = a + b;
246         require(c >= a);
247 
248         return c;
249     }
250 
251     /**
252      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
253      * reverts when dividing by zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         require(b != 0);
257         return a % b;
258     }
259 }
260 
261 /**
262  * @title Standard ERC20 token
263  *
264  * @dev Implementation of the basic standard token.
265  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
266  * Originally based on code by FirstBlood:
267  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
268  *
269  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
270  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
271  * compliant implementations may not do it.
272  */
273 contract ERC20 is IERC20 {
274     using SafeMath for uint256;
275 
276     mapping (address => uint256) private _balances;
277 
278     mapping (address => mapping (address => uint256)) private _allowed;
279 
280     uint256 private _totalSupply;
281 
282     /**
283      * @dev Total number of tokens in existence
284      */
285     function totalSupply() public view returns (uint256) {
286         return _totalSupply;
287     }
288 
289     /**
290      * @dev Gets the balance of the specified address.
291      * @param owner The address to query the balance of.
292      * @return An uint256 representing the amount owned by the passed address.
293      */
294     function balanceOf(address owner) public view returns (uint256) {
295         return _balances[owner];
296     }
297 
298     /**
299      * @dev Function to check the amount of tokens that an owner allowed to a spender.
300      * @param owner address The address which owns the funds.
301      * @param spender address The address which will spend the funds.
302      * @return A uint256 specifying the amount of tokens still available for the spender.
303      */
304     function allowance(address owner, address spender) public view returns (uint256) {
305         return _allowed[owner][spender];
306     }
307 
308     /**
309      * @dev Transfer token for a specified address
310      * @param to The address to transfer to.
311      * @param value The amount to be transferred.
312      */
313     function transfer(address to, uint256 value) public returns (bool) {
314         _transfer(msg.sender, to, value);
315         return true;
316     }
317 
318     /**
319      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
320      * Beware that changing an allowance with this method brings the risk that someone may use both the old
321      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
322      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
323      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
324      * @param spender The address which will spend the funds.
325      * @param value The amount of tokens to be spent.
326      */
327     function approve(address spender, uint256 value) public returns (bool) {
328         _approve(msg.sender, spender, value);
329         return true;
330     }
331 
332     /**
333      * @dev Transfer tokens from one address to another.
334      * Note that while this function emits an Approval event, this is not required as per the specification,
335      * and other compliant implementations may not emit the event.
336      * @param from address The address which you want to send tokens from
337      * @param to address The address which you want to transfer to
338      * @param value uint256 the amount of tokens to be transferred
339      */
340     function transferFrom(address from, address to, uint256 value) public returns (bool) {
341         _transfer(from, to, value);
342         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
343         return true;
344     }
345 
346     /**
347      * @dev Increase the amount of tokens that an owner allowed to a spender.
348      * approve should be called when allowed_[_spender] == 0. To increment
349      * allowed value is better to use this function to avoid 2 calls (and wait until
350      * the first transaction is mined)
351      * From MonolithDAO Token.sol
352      * Emits an Approval event.
353      * @param spender The address which will spend the funds.
354      * @param addedValue The amount of tokens to increase the allowance by.
355      */
356     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
357         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
358         return true;
359     }
360 
361     /**
362      * @dev Decrease the amount of tokens that an owner allowed to a spender.
363      * approve should be called when allowed_[_spender] == 0. To decrement
364      * allowed value is better to use this function to avoid 2 calls (and wait until
365      * the first transaction is mined)
366      * From MonolithDAO Token.sol
367      * Emits an Approval event.
368      * @param spender The address which will spend the funds.
369      * @param subtractedValue The amount of tokens to decrease the allowance by.
370      */
371     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
372         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
373         return true;
374     }
375 
376     /**
377      * @dev Transfer token for a specified addresses
378      * @param from The address to transfer from.
379      * @param to The address to transfer to.
380      * @param value The amount to be transferred.
381      */
382     function _transfer(address from, address to, uint256 value) internal {
383         require(to != address(0));
384 
385         _balances[from] = _balances[from].sub(value);
386         _balances[to] = _balances[to].add(value);
387         emit Transfer(from, to, value);
388     }
389 
390     /**
391      * @dev Internal function that mints an amount of the token and assigns it to
392      * an account. This encapsulates the modification of balances such that the
393      * proper events are emitted.
394      * @param account The account that will receive the created tokens.
395      * @param value The amount that will be created.
396      */
397     function _mint(address account, uint256 value) internal {
398         require(account != address(0));
399 
400         _totalSupply = _totalSupply.add(value);
401         _balances[account] = _balances[account].add(value);
402         emit Transfer(address(0), account, value);
403     }
404 
405     /**
406      * @dev Internal function that burns an amount of the token of a given
407      * account.
408      * @param account The account whose tokens will be burnt.
409      * @param value The amount that will be burnt.
410      */
411     function _burn(address account, uint256 value) internal {
412         require(account != address(0));
413 
414         _totalSupply = _totalSupply.sub(value);
415         _balances[account] = _balances[account].sub(value);
416         emit Transfer(account, address(0), value);
417     }
418 
419     /**
420      * @dev Approve an address to spend another addresses' tokens.
421      * @param owner The address that owns the tokens.
422      * @param spender The address that will spend the tokens.
423      * @param value The number of tokens that can be spent.
424      */
425     function _approve(address owner, address spender, uint256 value) internal {
426         require(spender != address(0));
427         require(owner != address(0));
428 
429         _allowed[owner][spender] = value;
430         emit Approval(owner, spender, value);
431     }
432 
433     /**
434      * @dev Internal function that burns an amount of the token of a given
435      * account, deducting from the sender's allowance for said account. Uses the
436      * internal burn function.
437      * Emits an Approval event (reflecting the reduced allowance).
438      * @param account The account whose tokens will be burnt.
439      * @param value The amount that will be burnt.
440      */
441     function _burnFrom(address account, uint256 value) internal {
442         _burn(account, value);
443         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
444     }
445 }
446 
447 /**
448  * @title Burnable Token
449  * @dev Token that can be irreversibly burned (destroyed).
450  */
451 contract ERC20Burnable is ERC20 {
452     /**
453      * @dev Burns a specific amount of tokens.
454      * @param value The amount of token to be burned.
455      */
456     function burn(uint256 value) public {
457         _burn(msg.sender, value);
458     }
459 
460     /**
461      * @dev Burns a specific amount of tokens from the target address and decrements allowance
462      * @param from address The account whose tokens will be burned.
463      * @param value uint256 The amount of token to be burned.
464      */
465     function burnFrom(address from, uint256 value) public {
466         _burnFrom(from, value);
467     }
468 }
469 
470 /**
471  * @title Ownable
472  * @dev The Ownable contract has an owner address, and provides basic authorization control
473  * functions, this simplifies the implementation of "user permissions".
474  */
475 contract Ownable {
476     address private _owner;
477 
478     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
479 
480     /**
481      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
482      * account.
483      */
484     constructor () internal {
485         _owner = msg.sender;
486         emit OwnershipTransferred(address(0), _owner);
487     }
488 
489     /**
490      * @return the address of the owner.
491      */
492     function owner() public view returns (address) {
493         return _owner;
494     }
495 
496     /**
497      * @dev Throws if called by any account other than the owner.
498      */
499     modifier onlyOwner() {
500         require(isOwner());
501         _;
502     }
503 
504     /**
505      * @return true if `msg.sender` is the owner of the contract.
506      */
507     function isOwner() public view returns (bool) {
508         return msg.sender == _owner;
509     }
510 
511     /**
512      * @dev Allows the current owner to relinquish control of the contract.
513      * @notice Renouncing to ownership will leave the contract without an owner.
514      * It will not be possible to call the functions with the `onlyOwner`
515      * modifier anymore.
516      */
517     function renounceOwnership() public onlyOwner {
518         emit OwnershipTransferred(_owner, address(0));
519         _owner = address(0);
520     }
521 
522     /**
523      * @dev Allows the current owner to transfer control of the contract to a newOwner.
524      * @param newOwner The address to transfer ownership to.
525      */
526     function transferOwnership(address newOwner) public onlyOwner {
527         _transferOwnership(newOwner);
528     }
529 
530     /**
531      * @dev Transfers control of the contract to a newOwner.
532      * @param newOwner The address to transfer ownership to.
533      */
534     function _transferOwnership(address newOwner) internal {
535         require(newOwner != address(0));
536         emit OwnershipTransferred(_owner, newOwner);
537         _owner = newOwner;
538     }
539 }
540 
541 contract MinterRole {
542     using Roles for Roles.Role;
543 
544     event MinterAdded(address indexed account);
545     event MinterRemoved(address indexed account);
546 
547     Roles.Role private _minters;
548 
549     constructor () internal {
550         _addMinter(msg.sender);
551     }
552 
553     modifier onlyMinter() {
554         require(isMinter(msg.sender));
555         _;
556     }
557 
558     function isMinter(address account) public view returns (bool) {
559         return _minters.has(account);
560     }
561 
562     function addMinter(address account) public onlyMinter {
563         _addMinter(account);
564     }
565 
566     function renounceMinter() public {
567         _removeMinter(msg.sender);
568     }
569 
570     function _addMinter(address account) internal {
571         _minters.add(account);
572         emit MinterAdded(account);
573     }
574 
575     function _removeMinter(address account) internal {
576         _minters.remove(account);
577         emit MinterRemoved(account);
578     }
579 }
580 
581 /// @title Migration Agent interface
582 contract MigrationAgent {
583 
584     function migrateFrom(address _from, uint256 _value) public;
585 }
586 
587 /// @title Locked
588 /// @dev Smart contract to enable locking and unlocking of token holders. 
589 contract Locked is Ownable {
590 
591     mapping (address => bool) public lockedList;
592 
593     event AddedLock(address user);
594     event RemovedLock(address user);
595 
596 
597     /// @dev terminate transaction if any of the participants is locked
598     /// @param _from - user initiating process
599     /// @param _to  - user involved in process
600     modifier isNotLocked(address _from, address _to) {
601 
602         if (_from != owner()) {  // allow contract owner on sending tokens even if recipient is locked
603             require(!lockedList[_from], "User is locked");
604             require(!lockedList[_to], "User is locked");
605         }
606         _;
607     }
608 
609     /// @dev check if user has been locked
610     /// @param _user - usr to check
611     /// @return true or false
612     function isLocked(address _user) public view returns (bool) {
613         return lockedList[_user];
614     }
615     
616     /// @dev add user to lock
617     /// @param _user to lock
618     function addLock (address _user) public onlyOwner {
619         _addLock(_user);
620     }
621 
622     /// @dev unlock user
623     /// @param _user - user to unlock
624     function removeLock (address _user) public onlyOwner {
625         _removeLock(_user);
626     }
627 
628 
629     /// @dev add user to lock for internal needs
630     /// @param _user to lock
631     function _addLock(address _user) internal {
632         lockedList[_user] = true;
633         emit AddedLock(_user);
634     }
635 
636     /// @dev unlock user for internal needs
637     /// @param _user - user to unlock
638     function _removeLock (address _user) internal {
639         lockedList[_user] = false;
640         emit RemovedLock(_user);
641     }
642 
643 }
644 
645 /**
646  * @title Token
647  * @dev Burnable, Mintabble, Ownable, Pausable, with Locking ability per user.
648  */
649 contract Token is Pausable, ERC20Detailed, Ownable, ERC20Burnable, MinterRole, Locked {
650 
651     uint8 constant DECIMALS = 18;
652     uint256 public constant INITIAL_SUPPLY = 250000000 * (10 ** uint256(DECIMALS));
653     uint256 public constant ONE_YEAR_SUPPLY = 12500000 * (10 ** uint256(DECIMALS));
654     address initialAllocation = 0xd15F967c36870D8dA92208235770167DDbD66b42;
655     address public migrationAgent;
656     uint256 public totalMigrated;
657     address public mintAgent;
658 
659     uint16 constant ORIGIN_YEAR = 1970;
660     uint constant YEAR_IN_SECONDS = 31557600;  //average of seconds in 4 years including one leap year
661                                                //giving approximate length of year without using precise calender
662 
663     mapping (uint => bool) public mintedYears;
664 
665     event Migrate(address indexed from, address indexed to, uint256 value);
666     event MintAgentSet(address indexed mintAgent);
667     event MigrationAgentSet(address indexed migrationAgent);
668 
669     /// @dev prevent accidental sending of tokens to this token contract
670     /// @param _self - address of this contract
671     modifier notSelf(address _self) {
672         require(_self != address(this), "You are trying to send tokens to token contract");
673         _;
674     }
675 
676     /// @dev Constructor that gives msg.sender all of existing tokens and initiates token.
677     constructor () public ERC20Detailed("Auditchain", "AUDT", DECIMALS)  {
678         _mint(initialAllocation, INITIAL_SUPPLY + ONE_YEAR_SUPPLY);
679         mintedYears[returnYear()] = true;
680     }
681      
682     /// @dev Function to determine year based on the current time
683     /// There is no need to deal with leap years as only once per year mining can be run and
684     /// one day is meaningless
685     function returnYear() internal view returns (uint) {
686 
687         uint year = ORIGIN_YEAR + (block.timestamp / YEAR_IN_SECONDS);
688         return year;
689     }
690 
691      /// @dev Function to mint tokens once per year
692      /// @return A boolean that indicates if the operation was successful.
693     function mint() public onlyMinter returns (bool) {
694 
695         require(mintAgent != address(0), "Mint agent address can't be 0");
696         require (!mintedYears[returnYear()], "Tokens have been already minted for this year.");
697 
698         _mint(mintAgent, ONE_YEAR_SUPPLY);
699         mintedYears[returnYear()] = true;
700 
701         return true;
702     }
703 
704     /// @notice Set contract to which yearly tokens will be minted
705     /// @param _mintAgent - address of the contract to set
706     function setMintContract(address _mintAgent) external onlyOwner() {
707 
708         require(_mintAgent != address(0), "Mint agent address can't be 0");
709         mintAgent = _mintAgent;
710         emit MintAgentSet(_mintAgent);
711     }
712 
713     /// @notice Migrate tokens to the new token contract.
714     function migrate() external whenNotPaused() {
715 
716         uint value = balanceOf(msg.sender);
717         require(migrationAgent != address(0), "Enter migration agent address");
718         require(value > 0, "Amount of tokens is required");
719 
720         _addLock(msg.sender);
721         burn(balanceOf(msg.sender));
722         totalMigrated += value;
723         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
724         _removeLock(msg.sender);
725         emit Migrate(msg.sender, migrationAgent, value);
726     }
727 
728     /// @notice Set address of migration target contract and enable migration process
729     /// @param _agent The address of the MigrationAgent contract
730     function setMigrationAgent(address _agent) external onlyOwner() {
731 
732         require(_agent != address(0), "Migration agent can't be 0");
733         migrationAgent = _agent;
734         emit MigrationAgentSet(_agent);
735     }
736 
737     /// @notice Overwrite parent implementation to add locked verification and notSelf modifiers
738     function transfer(address to, uint256 value) public
739                                                     isNotLocked(msg.sender, to)
740                                                     notSelf(to)
741                                                     returns (bool) {
742         return super.transfer(to, value);
743     }
744 
745     /// @notice Overwrite parent implementation to add locked verification and notSelf modifiers
746     function transferFrom(address from, address to, uint256 value) public
747                                                                     isNotLocked(from, to)
748                                                                     notSelf(to)
749                                                                     returns (bool) {
750         return super.transferFrom(from, to, value);
751     }
752 
753     /// @notice Overwrite parent implementation to add locked verification and notSelf modifiers
754     function approve(address spender, uint256 value) public
755                                                         isNotLocked(msg.sender, spender)
756                                                         notSelf(spender)
757                                                         returns (bool) {
758         return super.approve(spender, value);
759     }
760 
761     /// @notice Overwrite parent implementation to add locked verification and notSelf modifiers
762     function increaseAllowance(address spender, uint addedValue) public
763                                                                 isNotLocked(msg.sender, spender)
764                                                                 notSelf(spender)
765                                                                 returns (bool success) {
766         return super.increaseAllowance(spender, addedValue);
767     }
768 
769     /// @notice Overwrite parent implementation to add locked verification and notSelf modifiers
770     function decreaseAllowance(address spender, uint subtractedValue) public
771                                                                         isNotLocked(msg.sender, spender)
772                                                                         notSelf(spender)
773                                                                         returns (bool success) {
774         return super.decreaseAllowance(spender, subtractedValue);
775     }
776 
777 }