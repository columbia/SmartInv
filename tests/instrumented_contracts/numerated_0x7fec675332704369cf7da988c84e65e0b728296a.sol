1 pragma solidity ^0.5.0;
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
286  * @title Ownable
287  * @dev The Ownable contract has an owner address, and provides basic authorization control
288  * functions, this simplifies the implementation of "user permissions".
289  */
290 contract Ownable {
291     address private _owner;
292 
293     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
294 
295     /**
296      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
297      * account.
298      */
299     constructor () internal {
300         _owner = msg.sender;
301         emit OwnershipTransferred(address(0), _owner);
302     }
303 
304     /**
305      * @return the address of the owner.
306      */
307     function owner() public view returns (address) {
308         return _owner;
309     }
310 
311     /**
312      * @dev Throws if called by any account other than the owner.
313      */
314     modifier onlyOwner() {
315         require(isOwner());
316         _;
317     }
318 
319     /**
320      * @return true if `msg.sender` is the owner of the contract.
321      */
322     function isOwner() public view returns (bool) {
323         return msg.sender == _owner;
324     }
325 
326     /**
327      * @dev Allows the current owner to relinquish control of the contract.
328      * It will not be possible to call the functions with the `onlyOwner`
329      * modifier anymore.
330      * @notice Renouncing ownership will leave the contract without an owner,
331      * thereby removing any functionality that is only available to the owner.
332      */
333     function renounceOwnership() public onlyOwner {
334         emit OwnershipTransferred(_owner, address(0));
335         _owner = address(0);
336     }
337 
338     /**
339      * @dev Allows the current owner to transfer control of the contract to a newOwner.
340      * @param newOwner The address to transfer ownership to.
341      */
342     function transferOwnership(address newOwner) public onlyOwner {
343         _transferOwnership(newOwner);
344     }
345 
346     /**
347      * @dev Transfers control of the contract to a newOwner.
348      * @param newOwner The address to transfer ownership to.
349      */
350     function _transferOwnership(address newOwner) internal {
351         require(newOwner != address(0));
352         emit OwnershipTransferred(_owner, newOwner);
353         _owner = newOwner;
354     }
355 }
356 
357 /**
358  * @title Roles
359  * @dev Library for managing addresses assigned to a Role.
360  */
361 library Roles {
362     struct Role {
363         mapping (address => bool) bearer;
364     }
365 
366     /**
367      * @dev Give an account access to this role.
368      */
369     function add(Role storage role, address account) internal {
370         require(account != address(0));
371         require(!has(role, account));
372 
373         role.bearer[account] = true;
374     }
375 
376     /**
377      * @dev Remove an account's access to this role.
378      */
379     function remove(Role storage role, address account) internal {
380         require(account != address(0));
381         require(has(role, account));
382 
383         role.bearer[account] = false;
384     }
385 
386     /**
387      * @dev Check if an account has this role.
388      * @return bool
389      */
390     function has(Role storage role, address account) internal view returns (bool) {
391         require(account != address(0));
392         return role.bearer[account];
393     }
394 }
395 contract PauserRole {
396     using Roles for Roles.Role;
397 
398     event PauserAdded(address indexed account);
399     event PauserRemoved(address indexed account);
400 
401     Roles.Role private _pausers;
402 
403     constructor () internal {
404         _addPauser(msg.sender);
405     }
406 
407     modifier onlyPauser() {
408         require(isPauser(msg.sender));
409         _;
410     }
411 
412     function isPauser(address account) public view returns (bool) {
413         return _pausers.has(account);
414     }
415 
416     function addPauser(address account) public onlyPauser {
417         _addPauser(account);
418     }
419 
420     function renouncePauser() public {
421         _removePauser(msg.sender);
422     }
423 
424     function _addPauser(address account) internal {
425         _pausers.add(account);
426         emit PauserAdded(account);
427     }
428 
429     function _removePauser(address account) internal {
430         _pausers.remove(account);
431         emit PauserRemoved(account);
432     }
433 }
434 
435 contract BurnRole{
436     using Roles for Roles.Role;
437 
438     event BurnerAdded(address indexed account);
439     event BurnerRemoved(address indexed account);
440 
441     Roles.Role private _burners;
442 
443     constructor () internal {
444         _addBurner(msg.sender);
445     }
446 
447     modifier onlyBurner() {
448         require(isBurner(msg.sender));
449         _;
450     }
451 
452     function isBurner(address account) public view returns (bool) {
453         return _burners.has(account);
454     }
455 
456     function addBurner(address account) public onlyBurner {
457         _addBurner(account);
458     }
459 
460     function renounceBurner() public {
461         _removeBurner(msg.sender);
462     }
463 
464     function _addBurner(address account) internal {
465         _burners.add(account);
466         emit BurnerAdded(account);
467     }
468 
469     function _removeBurner(address account) internal {
470         _burners.remove(account);
471         emit BurnerRemoved(account);
472     }
473 }
474 
475 contract MinterRole {
476     using Roles for Roles.Role;
477 
478     event MinterAdded(address indexed account);
479     event MinterRemoved(address indexed account);
480 
481     Roles.Role private _minters;
482 
483     constructor () internal {
484         _addMinter(msg.sender);
485     }
486 
487     modifier onlyMinter() {
488         require(isMinter(msg.sender));
489         _;
490     }
491 
492     function isMinter(address account) public view returns (bool) {
493         return _minters.has(account);
494     }
495 
496     function addMinter(address account) public onlyMinter {
497         _addMinter(account);
498     }
499 
500     function renounceMinter() public {
501         _removeMinter(msg.sender);
502     }
503 
504     function _addMinter(address account) internal {
505         _minters.add(account);
506         emit MinterAdded(account);
507     }
508 
509     function _removeMinter(address account) internal {
510         _minters.remove(account);
511         emit MinterRemoved(account);
512     }
513 }
514 
515 /**
516  * @title Pausable
517  * @dev Base contract which allows children to implement an emergency stop mechanism.
518  */
519 contract Pausable is PauserRole {
520     event Paused(address account);
521     event Unpaused(address account);
522 
523     bool private _paused;
524 
525     constructor () internal {
526         _paused = false;
527     }
528 
529     /**
530      * @return True if the contract is paused, false otherwise.
531      */
532     function paused() public view returns (bool) {
533         return _paused;
534     }
535 
536     /**
537      * @dev Modifier to make a function callable only when the contract is not paused.
538      */
539     modifier whenNotPaused() {
540         require(!_paused);
541         _;
542     }
543 
544     /**
545      * @dev Modifier to make a function callable only when the contract is paused.
546      */
547     modifier whenPaused() {
548         require(_paused);
549         _;
550     }
551 
552     /**
553      * @dev Called by a pauser to pause, triggers stopped state.
554      */
555     function pause() public onlyPauser whenNotPaused {
556         _paused = true;
557         emit Paused(msg.sender);
558     }
559 
560     /**
561      * @dev Called by a pauser to unpause, returns to normal state.
562      */
563     function unpause() public onlyPauser whenPaused {
564         _paused = false;
565         emit Unpaused(msg.sender);
566     }
567 }
568 
569 /**
570  * @title Pausable token
571  * @dev ERC20 modified with pausable transfers.
572  */
573 contract ERC20Pausable is ERC20, Pausable {
574     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
575         return super.transfer(to, value);
576     }
577 
578     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
579         return super.transferFrom(from, to, value);
580     }
581 
582     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
583         return super.approve(spender, value);
584     }
585 
586     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
587         return super.increaseAllowance(spender, addedValue);
588     }
589 
590     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
591         return super.decreaseAllowance(spender, subtractedValue);
592     }
593 }
594 
595 contract ERC20Mintable is ERC20, MinterRole, Pausable {
596     /**
597      * @dev Function to mint tokens
598      * @param to The address that will receive the minted tokens.
599      * @param value The amount of tokens to mint.
600      * @return A boolean that indicates if the operation was successful.
601      */
602     function mint(address to, uint256 value) public onlyMinter whenNotPaused returns (bool) {
603         _mint(to, value);
604         return true;
605     }
606 }
607 
608 contract ERC20Capped is ERC20Mintable {
609     uint256 private _cap;
610 
611     constructor (uint256 cap) public {
612         require(cap > 0);
613         _cap = cap;
614     }
615 
616     /**
617      * @return the cap for the token minting.
618      */
619     function cap() public view returns (uint256) {
620         return _cap;
621     }
622 
623     function _mint(address account, uint256 value) internal {
624         require(totalSupply().add(value) <= _cap);
625         super._mint(account, value);
626     }
627 }
628 
629 contract ERC20Burnable is ERC20, BurnRole, Pausable {
630     /**
631      * @dev Burns a specific amount of tokens.
632      * @param value The amount of token to be burned.
633      */
634     function burn(uint256 value) public onlyBurner whenNotPaused returns (bool){
635         _burn(msg.sender, value);
636         return true;
637     }
638 }
639 
640 /**
641  * Utility library of inline functions on addresses
642  */
643 library Address {
644     /**
645      * Returns whether the target address is a contract
646      * @dev This function will return false if invoked during the constructor of a contract,
647      * as the code is not actually created until after the constructor finishes.
648      * @param account address of the account to check
649      * @return whether the target address is a contract
650      */
651     function isContract(address account) internal view returns (bool) {
652         uint256 size;
653         // XXX Currently there is no better way to check if there is a contract in an address
654         // than to check the size of the code at that address.
655         // See https://ethereum.stackexchange.com/a/14016/36603
656         // for more details about how this works.
657         // TODO Check this again before the Serenity release, because all addresses will be
658         // contracts then.
659         // solhint-disable-next-line no-inline-assembly
660         assembly { size := extcodesize(account) }
661         return size > 0;
662     }
663 }
664 
665 library SafeERC20 {
666     using SafeMath for uint256;
667     using Address for address;
668 
669     function safeTransfer(IERC20 token, address to, uint256 value) internal {
670         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
671     }
672 
673     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
674         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
675     }
676 
677     function safeApprove(IERC20 token, address spender, uint256 value) internal {
678         // safeApprove should only be called when setting an initial allowance,
679         // or when resetting it to zero. To increase and decrease it, use
680         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
681         require((value == 0) || (token.allowance(address(this), spender) == 0));
682         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
683     }
684 
685     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
686         uint256 newAllowance = token.allowance(address(this), spender).add(value);
687         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
688     }
689 
690     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
691         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
692         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
693     }
694 
695     /**
696      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
697      * on the return value: the return value is optional (but if data is returned, it must not be false).
698      * @param token The token targeted by the call.
699      * @param data The call data (encoded using abi.encode or one of its variants).
700      */
701     function callOptionalReturn(IERC20 token, bytes memory data) private {
702         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
703         // we're implementing it ourselves.
704 
705         // A Solidity high level call has three parts:
706         //  1. The target address is checked to verify it contains contract code
707         //  2. The call itself is made, and success asserted
708         //  3. The return value is decoded, which in turn checks the size of the returned data.
709 
710         require(address(token).isContract());
711 
712         // solhint-disable-next-line avoid-low-level-calls
713         (bool success, bytes memory returndata) = address(token).call(data);
714         require(success);
715 
716         if (returndata.length > 0) { // Return data is optional
717             require(abi.decode(returndata, (bool)));
718         }
719     }
720 }
721 
722 /**
723  * @title TokenVesting
724  * @dev A token holder contract that can release its token balance gradually like a
725  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
726  * owner.
727  */
728 contract TokenVesting is Ownable {
729     // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
730     // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,
731     // it is recommended to avoid using short time durations (less than a minute). Typical vesting schemes, with a
732     // cliff period of a year and a duration of four years, are safe to use.
733     // solhint-disable not-rely-on-time
734 
735     using SafeMath for uint256;
736     using SafeERC20 for IERC20;
737 
738     event TokensReleased(address token, uint256 amount);
739     event TokenVestingRevoked(address token);
740 
741     // beneficiary of tokens after they are released
742     address private _beneficiary;
743 
744     // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
745     uint256 private _phase;
746     uint256 private _start;
747     uint256 private _duration;
748 
749     bool private _revocable;
750 
751     mapping (address => uint256) private _released;
752     mapping (address => bool) private _revoked;
753 
754     /**
755      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
756      * beneficiary, gradually in a linear fashion until start + duration. By then all
757      * of the balance will have vested.
758      * @param beneficiary address of the beneficiary to whom vested tokens are transferred
759      * @param phase duration in seconds of the cliff in which tokens will begin to vest
760      * @param start the time (as Unix time) at which point vesting starts
761      * @param duration duration in seconds of the period in which the tokens will vest
762      * @param revocable whether the vesting is revocable or not
763      */
764     constructor (address beneficiary, uint256 start, uint256 phase, uint256 duration, bool revocable) public {
765         require(beneficiary != address(0));
766         require(phase >= 1);
767         require(duration > 0);
768         require(start.add(duration) > block.timestamp);
769 
770         _beneficiary = beneficiary;
771         _revocable = revocable;
772         _duration = duration;
773         _phase = phase;
774         _start = start;
775     }
776 
777     /**
778      * @return the beneficiary of the tokens.
779      */
780     function beneficiary() public view returns (address) {
781         return _beneficiary;
782     }
783 
784     /**
785      * @return the cliff time of the token vesting.
786      */
787     function phase() public view returns (uint256) {
788         return _phase;
789     }
790 
791     /**
792      * @return the start time of the token vesting.
793      */
794     function start() public view returns (uint256) {
795         return _start;
796     }
797 
798     /**
799      * @return the duration of the token vesting.
800      */
801     function duration() public view returns (uint256) {
802         return _duration;
803     }
804 
805     /**
806      * @return true if the vesting is revocable.
807      */
808     function revocable() public view returns (bool) {
809         return _revocable;
810     }
811 
812     /**
813      * @return the amount of the token released.
814      */
815     function released(address token) public view returns (uint256) {
816         return _released[token];
817     }
818 
819     /**
820      * @return true if the token is revoked.
821      */
822     function revoked(address token) public view returns (bool) {
823         return _revoked[token];
824     }
825 
826     /**
827      * @notice Transfers vested tokens to beneficiary.
828      * @param token ERC20 token which is being vested
829      */
830     function release(IERC20 token) public {
831         uint256 unreleased = _releasableAmount(token);
832 
833         require(unreleased > 0);
834 
835         _released[address(token)] = _released[address(token)].add(unreleased);
836 
837         token.safeTransfer(_beneficiary, unreleased);
838 
839         emit TokensReleased(address(token), unreleased);
840     }
841 
842     /**
843      * @notice Allows the owner to revoke the vesting. Tokens already vested
844      * remain in the contract, the rest are returned to the owner.
845      * @param token ERC20 token which is being vested
846      */
847     function revoke(IERC20 token) public onlyOwner {
848         require(_revocable);
849         require(!_revoked[address(token)]);
850 
851         uint256 balance = token.balanceOf(address(this));
852 
853         uint256 unreleased = _releasableAmount(token);
854         uint256 refund = balance.sub(unreleased);
855 
856         _revoked[address(token)] = true;
857 
858         token.safeTransfer(owner(), refund);
859 
860         emit TokenVestingRevoked(address(token));
861     }
862 
863     /**
864      * @dev Calculates the amount that has already vested but hasn't been released yet.
865      * @param token ERC20 token which is being vested
866      */
867     function _releasableAmount(IERC20 token) private view returns (uint256) {
868         return _vestedAmount(token).sub(_released[address(token)]);
869     }
870 
871     /**
872      * @dev Calculates the amount that has already vested.
873      * @param token ERC20 token which is being vested
874      */
875     function _vestedAmount(IERC20 token) private view returns (uint256) {
876         uint256 currentBalance = token.balanceOf(address(this));
877         uint256 totalBalance = currentBalance.add(_released[address(token)]);
878 
879         if (block.timestamp < _start) {
880             return 0;
881         } else if (block.timestamp >= _start.add(_duration) || _revoked[address(token)]) {
882             return totalBalance;
883         } else {
884             uint256 everyPhaseDuration = _duration.div(_phase);
885             uint256 currentPhase = (block.timestamp - _start).div(everyPhaseDuration);
886             return totalBalance.div(_phase).mul(currentPhase);
887         }
888     }
889 }
890 
891 
892 contract MToken is ERC20, ERC20Detailed, ERC20Pausable, ERC20Capped, ERC20Burnable {
893     using Address for address;
894 
895     event TransferExtend(address indexed from, address indexed to, uint256 value, string name);
896     
897     constructor(string memory name, string memory symbol, uint8 decimals, uint256 cap) ERC20Pausable() ERC20Burnable() ERC20Capped(cap) ERC20Detailed(name, symbol, decimals) ERC20() public {}
898 
899     function mintVesting(address _to, uint256 _amount, uint256 start, uint256 phase, uint256 duration, bool revocable) public onlyMinter whenNotPaused returns (TokenVesting) {
900         TokenVesting vesting = new TokenVesting(_to, start, phase, duration, revocable);
901         mint(address(vesting), _amount);
902         return vesting;
903     }
904 
905     function revokeVesting(TokenVesting vesting) public onlyMinter whenNotPaused returns(bool) {
906         require(address(vesting).isContract());
907         vesting.revoke(this);
908         return true;
909     }
910   
911     /**
912      * @dev Transfer token to a specified address.
913      * @param to The address to transfer to.
914      * @param value The amount to be transferred.
915      * @param name Custom string
916      */
917     function transfer(address to, uint256 value, string memory name) public whenNotPaused returns (bool) {
918         _transfer(msg.sender, to, value);
919         emit TransferExtend(msg.sender, to, value, name);
920         return true;
921     }
922 
923     /**
924      * @dev Batch transfer token.
925      * @param tos The address list to transfer to.
926      * @param value The amount to be transferred.
927      */
928     function transfer(address[] memory tos, uint256 value) public whenNotPaused returns (bool) {
929         require(tos.length > 0);
930         require(tos.length <= 50);
931 
932         for(uint i = 0; i < tos.length; i ++){
933             _transfer(msg.sender, tos[i], value);
934         }
935         return true;
936     }
937 
938     /**
939      * @dev Batch transfer token.
940      * @param tos The address list to transfer to.
941      * @param values The amount list to be transferred.
942      */
943     function transfer(address[] memory tos, uint256[] memory values) public whenNotPaused returns (bool) {
944         require(tos.length > 0);
945         require(tos.length <= 50);
946         require(values.length == tos.length);
947 
948         for(uint i = 0; i < tos.length; i ++){
949             _transfer(msg.sender, tos[i], values[i]);
950         }
951         return true;
952     }
953 }