1 pragma solidity 0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     /**
27      * @dev Multiplies two unsigned integers, reverts on overflow.
28      */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b);
39 
40         return c;
41     }
42 
43     /**
44      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
45      */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Solidity only automatically asserts when dividing by 0
48         require(b > 0);
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51 
52         return c;
53     }
54 
55     /**
56      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b <= a);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Adds two unsigned integers, reverts on overflow.
67      */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a);
71 
72         return c;
73     }
74 
75     /**
76      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
77      * reverts when dividing by zero.
78      */
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b != 0);
81         return a % b;
82     }
83 }
84 
85 /**
86  * @title ERC20Detailed token
87  * @dev The decimals are only for visualization purposes.
88  * All the operations are done using the smallest and indivisible token unit,
89  * just as on Ethereum all the operations are done in wei.
90  */
91 contract ERC20Detailed is IERC20 {
92     string private _name;
93     string private _symbol;
94     uint8 private _decimals;
95 
96     constructor (string memory name, string memory symbol, uint8 decimals) public {
97         _name = name;
98         _symbol = symbol;
99         _decimals = decimals;
100     }
101 
102     /**
103      * @return the name of the token.
104      */
105     function name() public view returns (string memory) {
106         return _name;
107     }
108 
109     /**
110      * @return the symbol of the token.
111      */
112     function symbol() public view returns (string memory) {
113         return _symbol;
114     }
115 
116     /**
117      * @return the number of decimals of the token.
118      */
119     function decimals() public view returns (uint8) {
120         return _decimals;
121     }
122 }
123 
124 contract ERC20 is IERC20 {
125     using SafeMath for uint256;
126 
127     mapping (address => uint256) private _balances;
128 
129     mapping (address => mapping (address => uint256)) private _allowed;
130 
131     uint256 private _totalSupply;
132 
133     /**
134      * @dev Total number of tokens in existence.
135      */
136     function totalSupply() public view returns (uint256) {
137         return _totalSupply;
138     }
139 
140     /**
141      * @dev Gets the balance of the specified address.
142      * @param owner The address to query the balance of.
143      * @return A uint256 representing the amount owned by the passed address.
144      */
145     function balanceOf(address owner) public view returns (uint256) {
146         return _balances[owner];
147     }
148 
149     /**
150      * @dev Function to check the amount of tokens that an owner allowed to a spender.
151      * @param owner address The address which owns the funds.
152      * @param spender address The address which will spend the funds.
153      * @return A uint256 specifying the amount of tokens still available for the spender.
154      */
155     function allowance(address owner, address spender) public view returns (uint256) {
156         return _allowed[owner][spender];
157     }
158 
159     /**
160      * @dev Transfer token to a specified address.
161      * @param to The address to transfer to.
162      * @param value The amount to be transferred.
163      */
164     function transfer(address to, uint256 value) public returns (bool) {
165         _transfer(msg.sender, to, value);
166         return true;
167     }
168 
169     /**
170      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171      * Beware that changing an allowance with this method brings the risk that someone may use both the old
172      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175      * @param spender The address which will spend the funds.
176      * @param value The amount of tokens to be spent.
177      */
178     function approve(address spender, uint256 value) public returns (bool) {
179         _approve(msg.sender, spender, value);
180         return true;
181     }
182 
183     /**
184      * @dev Transfer tokens from one address to another.
185      * Note that while this function emits an Approval event, this is not required as per the specification,
186      * and other compliant implementations may not emit the event.
187      * @param from address The address which you want to send tokens from
188      * @param to address The address which you want to transfer to
189      * @param value uint256 the amount of tokens to be transferred
190      */
191     function transferFrom(address from, address to, uint256 value) public returns (bool) {
192         _transfer(from, to, value);
193         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
194         return true;
195     }
196 
197     /**
198      * @dev Increase the amount of tokens that an owner allowed to a spender.
199      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * Emits an Approval event.
204      * @param spender The address which will spend the funds.
205      * @param addedValue The amount of tokens to increase the allowance by.
206      */
207     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
208         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
209         return true;
210     }
211 
212     /**
213      * @dev Decrease the amount of tokens that an owner allowed to a spender.
214      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
215      * allowed value is better to use this function to avoid 2 calls (and wait until
216      * the first transaction is mined)
217      * From MonolithDAO Token.sol
218      * Emits an Approval event.
219      * @param spender The address which will spend the funds.
220      * @param subtractedValue The amount of tokens to decrease the allowance by.
221      */
222     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
223         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
224         return true;
225     }
226 
227     /**
228      * @dev Transfer token for a specified addresses.
229      * @param from The address to transfer from.
230      * @param to The address to transfer to.
231      * @param value The amount to be transferred.
232      */
233     function _transfer(address from, address to, uint256 value) internal {
234         require(to != address(0));
235 
236         _balances[from] = _balances[from].sub(value);
237         _balances[to] = _balances[to].add(value);
238         emit Transfer(from, to, value);
239     }
240 
241     /**
242      * @dev Internal function that mints an amount of the token and assigns it to
243      * an account. This encapsulates the modification of balances such that the
244      * proper events are emitted.
245      * @param account The account that will receive the created tokens.
246      * @param value The amount that will be created.
247      */
248     function _mint(address account, uint256 value) internal {
249         require(account != address(0));
250 
251         _totalSupply = _totalSupply.add(value);
252         _balances[account] = _balances[account].add(value);
253         emit Transfer(address(0), account, value);
254     }
255 
256     /**
257      * @dev Internal function that burns an amount of the token of a given
258      * account.
259      * @param account The account whose tokens will be burnt.
260      * @param value The amount that will be burnt.
261      */
262     function _burn(address account, uint256 value) internal {
263         require(account != address(0));
264 
265         _totalSupply = _totalSupply.sub(value);
266         _balances[account] = _balances[account].sub(value);
267         emit Transfer(account, address(0), value);
268     }
269 
270     /**
271      * @dev Approve an address to spend another addresses' tokens.
272      * @param owner The address that owns the tokens.
273      * @param spender The address that will spend the tokens.
274      * @param value The number of tokens that can be spent.
275      */
276     function _approve(address owner, address spender, uint256 value) internal {
277         require(spender != address(0));
278         require(owner != address(0));
279 
280         _allowed[owner][spender] = value;
281         emit Approval(owner, spender, value);
282     }
283 }
284 
285 /**
286  * @title Roles
287  * @dev Library for managing addresses assigned to a Role.
288  */
289 library Roles {
290     struct Role {
291         mapping (address => bool) bearer;
292     }
293 
294     /**
295      * @dev Give an account access to this role.
296      */
297     function add(Role storage role, address account) internal {
298         require(account != address(0));
299         require(!has(role, account));
300 
301         role.bearer[account] = true;
302     }
303 
304     /**
305      * @dev Remove an account's access to this role.
306      */
307     function remove(Role storage role, address account) internal {
308         require(account != address(0));
309         require(has(role, account));
310 
311         role.bearer[account] = false;
312     }
313 
314     /**
315      * @dev Check if an account has this role.
316      * @return bool
317      */
318     function has(Role storage role, address account) internal view returns (bool) {
319         require(account != address(0));
320         return role.bearer[account];
321     }
322 }
323 contract PauserRole {
324     using Roles for Roles.Role;
325 
326     event PauserAdded(address indexed account);
327     event PauserRemoved(address indexed account);
328 
329     Roles.Role private _pausers;
330 
331     constructor () internal {
332         _addPauser(msg.sender);
333     }
334 
335     modifier onlyPauser() {
336         require(isPauser(msg.sender));
337         _;
338     }
339 
340     function isPauser(address account) public view returns (bool) {
341         return _pausers.has(account);
342     }
343 
344     function addPauser(address account) public onlyPauser {
345         _addPauser(account);
346     }
347 
348     function renouncePauser() public {
349         _removePauser(msg.sender);
350     }
351 
352     function _addPauser(address account) internal {
353         _pausers.add(account);
354         emit PauserAdded(account);
355     }
356 
357     function _removePauser(address account) internal {
358         _pausers.remove(account);
359         emit PauserRemoved(account);
360     }
361 }
362 
363 contract BurnRole{
364     using Roles for Roles.Role;
365 
366     event BurnerAdded(address indexed account);
367     event BurnerRemoved(address indexed account);
368 
369     Roles.Role private _burners;
370 
371     constructor () internal {
372         _addBurner(msg.sender);
373     }
374 
375     modifier onlyBurner() {
376         require(isBurner(msg.sender));
377         _;
378     }
379 
380     function isBurner(address account) public view returns (bool) {
381         return _burners.has(account);
382     }
383 
384     function addBurner(address account) public onlyBurner {
385         _addBurner(account);
386     }
387 
388     function renounceBurner() public {
389         _removeBurner(msg.sender);
390     }
391 
392     function _addBurner(address account) internal {
393         _burners.add(account);
394         emit BurnerAdded(account);
395     }
396 
397     function _removeBurner(address account) internal {
398         _burners.remove(account);
399         emit BurnerRemoved(account);
400     }
401 }
402 
403 contract MinterRole {
404     using Roles for Roles.Role;
405 
406     event MinterAdded(address indexed account);
407     event MinterRemoved(address indexed account);
408 
409     Roles.Role private _minters;
410 
411     constructor () internal {
412         _addMinter(msg.sender);
413     }
414 
415     modifier onlyMinter() {
416         require(isMinter(msg.sender));
417         _;
418     }
419 
420     function isMinter(address account) public view returns (bool) {
421         return _minters.has(account);
422     }
423 
424     function addMinter(address account) public onlyMinter {
425         _addMinter(account);
426     }
427 
428     function renounceMinter() public {
429         _removeMinter(msg.sender);
430     }
431 
432     function _addMinter(address account) internal {
433         _minters.add(account);
434         emit MinterAdded(account);
435     }
436 
437     function _removeMinter(address account) internal {
438         _minters.remove(account);
439         emit MinterRemoved(account);
440     }
441 }
442 
443 /**
444  * @title Pausable
445  * @dev Base contract which allows children to implement an emergency stop mechanism.
446  */
447 contract Pausable is PauserRole {
448     event Paused(address account);
449     event Unpaused(address account);
450 
451     bool private _paused;
452 
453     constructor () internal {
454         _paused = false;
455     }
456 
457     /**
458      * @return True if the contract is paused, false otherwise.
459      */
460     function paused() public view returns (bool) {
461         return _paused;
462     }
463 
464     /**
465      * @dev Modifier to make a function callable only when the contract is not paused.
466      */
467     modifier whenNotPaused() {
468         require(!_paused);
469         _;
470     }
471 
472     /**
473      * @dev Modifier to make a function callable only when the contract is paused.
474      */
475     modifier whenPaused() {
476         require(_paused);
477         _;
478     }
479 
480     /**
481      * @dev Called by a pauser to pause, triggers stopped state.
482      */
483     function pause() public onlyPauser whenNotPaused {
484         _paused = true;
485         emit Paused(msg.sender);
486     }
487 
488     /**
489      * @dev Called by a pauser to unpause, returns to normal state.
490      */
491     function unpause() public onlyPauser whenPaused {
492         _paused = false;
493         emit Unpaused(msg.sender);
494     }
495 }
496 
497 /**
498  * @title Pausable token
499  * @dev ERC20 modified with pausable transfers.
500  */
501 contract ERC20Pausable is ERC20, Pausable {
502     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
503         return super.transfer(to, value);
504     }
505 
506     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
507         return super.transferFrom(from, to, value);
508     }
509 
510     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
511         return super.approve(spender, value);
512     }
513 
514     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
515         return super.increaseAllowance(spender, addedValue);
516     }
517 
518     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
519         return super.decreaseAllowance(spender, subtractedValue);
520     }
521 }
522 
523 contract ERC20Mintable is ERC20, MinterRole, Pausable {
524     /**
525      * @dev Function to mint tokens
526      * @param to The address that will receive the minted tokens.
527      * @param value The amount of tokens to mint.
528      * @return A boolean that indicates if the operation was successful.
529      */
530     function mint(address to, uint256 value) public onlyMinter whenNotPaused returns (bool) {
531         _mint(to, value);
532         return true;
533     }
534 }
535 
536 contract ERC20Capped is ERC20Mintable {
537     uint256 private _cap;
538 
539     constructor (uint256 cap) public {
540         require(cap > 0);
541         _cap = cap;
542     }
543 
544     /**
545      * @return the cap for the token minting.
546      */
547     function cap() public view returns (uint256) {
548         return _cap;
549     }
550 
551     function _mint(address account, uint256 value) internal {
552         require(totalSupply().add(value) <= _cap);
553         super._mint(account, value);
554     }
555 }
556 
557 contract ERC20Burnable is ERC20, BurnRole, Pausable {
558     /**
559      * @dev Burns a specific amount of tokens.
560      * @param value The amount of token to be burned.
561      */
562     function burn(uint256 value) public onlyBurner whenNotPaused returns (bool){
563         _burn(msg.sender, value);
564         return true;
565     }
566 }
567 
568 /**
569  * Utility library of inline functions on addresses
570  */
571 library Address {
572     /**
573      * Returns whether the target address is a contract
574      * @dev This function will return false if invoked during the constructor of a contract,
575      * as the code is not actually created until after the constructor finishes.
576      * @param account address of the account to check
577      * @return whether the target address is a contract
578      */
579     function isContract(address account) internal view returns (bool) {
580         uint256 size;
581         // XXX Currently there is no better way to check if there is a contract in an address
582         // than to check the size of the code at that address.
583         // See https://ethereum.stackexchange.com/a/14016/36603
584         // for more details about how this works.
585         // TODO Check this again before the Serenity release, because all addresses will be
586         // contracts then.
587         // solhint-disable-next-line no-inline-assembly
588         assembly { size := extcodesize(account) }
589         return size > 0;
590     }
591 }
592 
593 library SafeERC20 {
594     using SafeMath for uint256;
595     using Address for address;
596 
597     function safeTransfer(IERC20 token, address to, uint256 value) internal {
598         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
599     }
600 
601     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
602         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
603     }
604 
605     function safeApprove(IERC20 token, address spender, uint256 value) internal {
606         // safeApprove should only be called when setting an initial allowance,
607         // or when resetting it to zero. To increase and decrease it, use
608         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
609         require((value == 0) || (token.allowance(address(this), spender) == 0));
610         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
611     }
612 
613     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
614         uint256 newAllowance = token.allowance(address(this), spender).add(value);
615         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
616     }
617 
618     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
619         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
620         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
621     }
622 
623     /**
624      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
625      * on the return value: the return value is optional (but if data is returned, it must not be false).
626      * @param token The token targeted by the call.
627      * @param data The call data (encoded using abi.encode or one of its variants).
628      */
629     function callOptionalReturn(IERC20 token, bytes memory data) private {
630         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
631         // we're implementing it ourselves.
632 
633         // A Solidity high level call has three parts:
634         //  1. The target address is checked to verify it contains contract code
635         //  2. The call itself is made, and success asserted
636         //  3. The return value is decoded, which in turn checks the size of the returned data.
637 
638         require(address(token).isContract());
639 
640         // solhint-disable-next-line avoid-low-level-calls
641         (bool success, bytes memory returndata) = address(token).call(data);
642         require(success);
643 
644         if (returndata.length > 0) { // Return data is optional
645             require(abi.decode(returndata, (bool)));
646         }
647     }
648 }
649 
650 
651 contract TransferLockerRole {
652     using Roles for Roles.Role;
653 
654     event LockerAdded(address indexed account);
655     event LockerRemoved(address indexed account);
656 
657     Roles.Role private _lockers;
658 
659     constructor () internal {
660         _addLocker(msg.sender);
661     }
662 
663     modifier onlyLocker() {
664         require(isLocker(msg.sender));
665         _;
666     }
667 
668     function isLocker(address account) public view returns (bool) {
669         return _lockers.has(account);
670     }
671 
672     function addLocker(address account) public onlyLocker {
673         _addLocker(account);
674     }
675 
676     function renounceLocker() public {
677         _removeLocker(msg.sender);
678     }
679 
680     function _addLocker(address account) internal {
681         _lockers.add(account);
682         emit LockerAdded(account);
683     }
684 
685     function _removeLocker(address account) internal {
686         _lockers.remove(account);
687         emit LockerRemoved(account);
688     }
689 }
690 
691 
692 /**
693  * @title TransferLockable
694  */
695 contract ERC20TransferLockable is ERC20Pausable, TransferLockerRole {
696     using SafeMath for uint256;
697 
698     event TransferLocked(address account, uint256 amount);
699     event TransferUnlocked(address account, uint256 amount);
700 
701     mapping(address => uint256) private _lockedBalance;
702 
703     /**
704      * @dev Modifier to make a function callable only when the address is not locked.
705      */
706     modifier whenNotLocked(address addr, uint256 value) {
707         require(balanceOf(addr).sub(_lockedBalance[addr]) >= value);
708         _;
709     }
710 
711     /**
712      * @return locked balance of address
713      */
714     function lockedBalance(address addr) public view returns (uint256) {
715         return _lockedBalance[addr];
716     }
717 
718     /**
719      * @dev Called by a locker to lock transfer.
720      */
721     function lockTransfer(address addr, uint256 amount) public onlyLocker {
722         require(addr != address(0));
723         require(amount > 0);
724 
725         _lockedBalance[addr] = _lockedBalance[addr].add(amount);
726         emit TransferLocked(addr, amount);
727     }
728 
729     /**
730      * @dev Called by a locker to unlock transfer.
731      */
732     function unlockTransfer(address addr, uint256 amount) public onlyLocker {
733         require(addr != address(0));
734         require(amount > 0);
735 
736         _lockedBalance[addr] = _lockedBalance[addr].sub(amount);
737         emit TransferUnlocked(addr, amount);
738     }
739 
740     function transfer(address to, uint256 value) public whenNotPaused whenNotLocked(msg.sender, value) returns (bool) {
741         return super.transfer(to, value);
742     }
743 
744     function transferFrom(address from, address to, uint256 value) public whenNotPaused whenNotLocked(from, value) returns (bool) {
745         return super.transferFrom(from, to, value);
746     }
747 }
748 
749 
750 contract LockableMixMarvelTokenAll is ERC20, ERC20Detailed, ERC20TransferLockable, ERC20Capped, ERC20Burnable {
751     using Address for address;
752 
753     constructor(string memory name, string memory symbol, uint8 decimals, uint256 cap) ERC20TransferLockable() ERC20Burnable() ERC20Capped(cap) ERC20Detailed(name, symbol, decimals) ERC20() public {}
754 }