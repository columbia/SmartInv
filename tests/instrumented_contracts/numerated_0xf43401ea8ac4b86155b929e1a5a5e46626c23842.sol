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
470 contract MinterRole {
471     using Roles for Roles.Role;
472 
473     event MinterAdded(address indexed account);
474     event MinterRemoved(address indexed account);
475 
476     Roles.Role private _minters;
477 
478     constructor () internal {
479         _addMinter(msg.sender);
480     }
481 
482     modifier onlyMinter() {
483         require(isMinter(msg.sender));
484         _;
485     }
486 
487     function isMinter(address account) public view returns (bool) {
488         return _minters.has(account);
489     }
490 
491     function addMinter(address account) public onlyMinter {
492         _addMinter(account);
493     }
494 
495     function renounceMinter() public {
496         _removeMinter(msg.sender);
497     }
498 
499     function _addMinter(address account) internal {
500         _minters.add(account);
501         emit MinterAdded(account);
502     }
503 
504     function _removeMinter(address account) internal {
505         _minters.remove(account);
506         emit MinterRemoved(account);
507     }
508 }
509 
510 /**
511  * @title ERC20Mintable
512  * @dev ERC20 minting logic
513  */
514 contract ERC20Mintable is ERC20, MinterRole {
515     /**
516      * @dev Function to mint tokens
517      * @param to The address that will receive the minted tokens.
518      * @param value The amount of tokens to mint.
519      * @return A boolean that indicates if the operation was successful.
520      */
521     function mint(address to, uint256 value) public onlyMinter returns (bool) {
522         _mint(to, value);
523         return true;
524     }
525 }
526 
527 /**
528  * @title Capped token
529  * @dev Mintable token with a token cap.
530  */
531 contract ERC20Capped is ERC20Mintable {
532     uint256 private _cap;
533 
534     constructor (uint256 cap) public {
535         require(cap > 0);
536         _cap = cap;
537     }
538 
539     /**
540      * @return the cap for the token minting.
541      */
542     function cap() public view returns (uint256) {
543         return _cap;
544     }
545 
546     function _mint(address account, uint256 value) internal {
547         require(totalSupply().add(value) <= _cap);
548         super._mint(account, value);
549     }
550 }
551 
552 /**
553  * @title Ownable
554  * @dev The Ownable contract has an owner address, and provides basic authorization control
555  * functions, this simplifies the implementation of "user permissions".
556  */
557 contract Ownable {
558     address private _owner;
559 
560     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
561 
562     /**
563      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
564      * account.
565      */
566     constructor () internal {
567         _owner = msg.sender;
568         emit OwnershipTransferred(address(0), _owner);
569     }
570 
571     /**
572      * @return the address of the owner.
573      */
574     function owner() public view returns (address) {
575         return _owner;
576     }
577 
578     /**
579      * @dev Throws if called by any account other than the owner.
580      */
581     modifier onlyOwner() {
582         require(isOwner());
583         _;
584     }
585 
586     /**
587      * @return true if `msg.sender` is the owner of the contract.
588      */
589     function isOwner() public view returns (bool) {
590         return msg.sender == _owner;
591     }
592 
593     /**
594      * @dev Allows the current owner to relinquish control of the contract.
595      * @notice Renouncing to ownership will leave the contract without an owner.
596      * It will not be possible to call the functions with the `onlyOwner`
597      * modifier anymore.
598      */
599     function renounceOwnership() public onlyOwner {
600         emit OwnershipTransferred(_owner, address(0));
601         _owner = address(0);
602     }
603 
604     /**
605      * @dev Allows the current owner to transfer control of the contract to a newOwner.
606      * @param newOwner The address to transfer ownership to.
607      */
608     function transferOwnership(address newOwner) public onlyOwner {
609         _transferOwnership(newOwner);
610     }
611 
612     /**
613      * @dev Transfers control of the contract to a newOwner.
614      * @param newOwner The address to transfer ownership to.
615      */
616     function _transferOwnership(address newOwner) internal {
617         require(newOwner != address(0));
618         emit OwnershipTransferred(_owner, newOwner);
619         _owner = newOwner;
620     }
621 }
622 
623 /// @title Migration Agent interface
624 contract MigrationAgent {
625 
626     function migrateFrom(address _from, uint256 _value) public;
627 }
628 
629 /// @title BlackList
630 /// @dev Smart contract to enable blacklisting of token holders. 
631 contract BlackList is Ownable {
632 
633     mapping (address => bool) public blacklist;
634 
635     event AddedBlackList(address user);
636     event RemovedBlackList(address user);
637 
638 
639     /// @dev terminate transaction if any of the participants is blacklisted
640     /// @param _from - user initiating process
641     /// @param _to  - user involved in process
642     modifier isNotBlacklisted(address _from, address _to) {
643         require(!blacklist[_from], "User is blacklisted");
644         require(!blacklist[_to], "User is blacklisted");
645         _;
646     }
647 
648     /// @dev check if user has been black listed
649     /// @param _user - usr to check
650     /// @return true or false
651     function isBlacklisted(address _user) public view returns (bool) {
652         return blacklist[_user];
653     }
654     
655     /// @dev add user to black list
656     /// @param _user to blacklist
657     function addBlackList (address _user) public onlyOwner {
658         blacklist[_user] = true;
659         emit AddedBlackList(_user);
660     }
661 
662     /// @dev remove user from black list
663     /// @param _user - user to be removed from black list
664     function removeBlackList (address _user) public onlyOwner {
665         blacklist[_user] = false;
666         emit RemovedBlackList(_user);
667     }
668 
669 }
670 
671 /**
672  * @title Token
673  * @dev No tokens are minted during the deployment.
674  * Note they can later distribute these tokens as they wish using `transfer` and other
675  * `ERC20` functions.
676  */
677 contract Token is Pausable, ERC20Detailed, ERC20Capped, Ownable, ERC20Burnable, BlackList {
678     uint8 public constant DECIMALS = 18;    
679     uint256 public constant MAX_SUPPLY = 5000000000 * (10 ** uint256(DECIMALS));
680     address public migrationAgent;
681     uint256 public totalMigrated;
682 
683     event Migrate(address indexed from, address indexed to, uint256 value);
684     event BlacklistedFundsBurned(address indexed from, uint256 value);
685 
686     /// @dev prevent accidental sending of tokens to this token contract
687     /// @param _self - address of this contract
688     modifier notSelf(address _self) {
689         require(_self != address(this), "You are trying to send tokens to token contract");
690         _;
691     }
692 
693     /// @dev Constructor which initiates name, ticker and max supply for the token. 
694     constructor () public ERC20Detailed("CannDollar", "CDAG", DECIMALS) ERC20Capped(MAX_SUPPLY) {           
695     }
696    
697 
698     /// @notice Migrate tokens to the new token contract.
699     /// @param _value The amount of token to be migrated
700     function migrate(uint256 _value) external whenNotPaused() {       
701         require(migrationAgent != address(0), "Enter migration agent address");
702         
703         // Validate input value.
704         require(_value > 0, "Amount of tokens is required");
705         require(_value <= balanceOf(msg.sender), "You entered more tokens than available");
706        
707         burn(balanceOf(msg.sender));
708         totalMigrated += _value;
709         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
710         emit Migrate(msg.sender, migrationAgent, _value);
711     }
712 
713     /// @notice Set address of migration target contract and enable migration
714     /// process.
715     /// @param _agent The address of the MigrationAgent contract
716     function setMigrationAgent(address _agent) external onlyOwner() {        
717         
718         require(migrationAgent == address(0), "Migration agent can't be 0");       
719         migrationAgent = _agent;
720     }
721 
722     /// @notice burns funds of blacklisted user
723     /// @param _blacklistedUser The address of user who is blacklisted
724     function burnBlacklistedFunds (address _blacklistedUser) public onlyOwner {
725         require(blacklist[_blacklistedUser], "These user is not blacklisted");
726         uint dirtyFunds = balanceOf(_blacklistedUser);
727         _burn(_blacklistedUser, dirtyFunds);        
728         emit BlacklistedFundsBurned(_blacklistedUser, dirtyFunds);
729     }
730 
731     /// @notice Overwrite parent implementation to add blacklisted modifier
732     function transfer(address to, uint256 value) public 
733                                                     isNotBlacklisted(msg.sender, to) 
734                                                     notSelf(to) 
735                                                     returns (bool) {
736         return super.transfer(to, value);
737     }
738 
739     /// @notice Overwrite parent implementation to add blacklisted and notSelf modifiers
740     function transferFrom(address from, address to, uint256 value) public 
741                                                                     isNotBlacklisted(from, to) 
742                                                                     notSelf(to) 
743                                                                     returns (bool) {
744         return super.transferFrom(from, to, value);
745     }
746 
747     /// @notice Overwrite parent implementation to add blacklisted and notSelf modifiers
748     function approve(address spender, uint256 value) public 
749                                                         isNotBlacklisted(msg.sender, spender) 
750                                                         notSelf(spender) 
751                                                         returns (bool) {
752         return super.approve(spender, value);
753     }
754 
755     /// @notice Overwrite parent implementation to add blacklisted and notSelf modifiers
756     function increaseAllowance(address spender, uint addedValue) public 
757                                                                 isNotBlacklisted(msg.sender, spender) 
758                                                                 notSelf(spender) 
759                                                                 returns (bool success) {
760         return super.increaseAllowance(spender, addedValue);
761     }
762 
763     /// @notice Overwrite parent implementation to add blacklisted and notSelf modifiers
764     function decreaseAllowance(address spender, uint subtractedValue) public 
765                                                                         isNotBlacklisted(msg.sender, spender) 
766                                                                         notSelf(spender) 
767                                                                         returns (bool success) {
768         return super.decreaseAllowance(spender, subtractedValue);
769     }
770 
771     /// @notice Overwrite parent implementation to add blacklisted check and notSelf modifiers
772     function mint(address to, uint256 value) public onlyOwner() notSelf(to) returns (bool) {       
773 
774         require(!isBlacklisted(to), "User is blacklisted"); 
775         return super.mint(to, value);
776     }
777     
778 }