1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35      * @dev Multiplies two unsigned integers, reverts on overflow.
36      */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53      */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Adds two unsigned integers, reverts on overflow.
75      */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85      * reverts when dividing by zero.
86      */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * https://eips.ethereum.org/EIPS/eip-20
100  * Originally based on code by FirstBlood:
101  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  *
103  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
104  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
105  * compliant implementations may not do it.
106  */
107 contract ERC20 is IERC20 {
108     using SafeMath for uint256;
109 
110     mapping (address => uint256) private _balances;
111 
112     mapping (address => mapping (address => uint256)) private _allowed;
113 
114     uint256 private _totalSupply;
115 
116     /**
117      * @dev Total number of tokens in existence
118      */
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     /**
124      * @dev Gets the balance of the specified address.
125      * @param owner The address to query the balance of.
126      * @return A uint256 representing the amount owned by the passed address.
127      */
128     function balanceOf(address owner) public view returns (uint256) {
129         return _balances[owner];
130     }
131 
132     /**
133      * @dev Function to check the amount of tokens that an owner allowed to a spender.
134      * @param owner address The address which owns the funds.
135      * @param spender address The address which will spend the funds.
136      * @return A uint256 specifying the amount of tokens still available for the spender.
137      */
138     function allowance(address owner, address spender) public view returns (uint256) {
139         return _allowed[owner][spender];
140     }
141 
142     /**
143      * @dev Transfer token to a specified address
144      * @param to The address to transfer to.
145      * @param value The amount to be transferred.
146      */
147     function transfer(address to, uint256 value) public returns (bool) {
148         _transfer(msg.sender, to, value);
149         return true;
150     }
151 
152     /**
153      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154      * Beware that changing an allowance with this method brings the risk that someone may use both the old
155      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      * @param spender The address which will spend the funds.
159      * @param value The amount of tokens to be spent.
160      */
161     function approve(address spender, uint256 value) public returns (bool) {
162         _approve(msg.sender, spender, value);
163         return true;
164     }
165 
166     /**
167      * @dev Transfer tokens from one address to another.
168      * Note that while this function emits an Approval event, this is not required as per the specification,
169      * and other compliant implementations may not emit the event.
170      * @param from address The address which you want to send tokens from
171      * @param to address The address which you want to transfer to
172      * @param value uint256 the amount of tokens to be transferred
173      */
174     function transferFrom(address from, address to, uint256 value) public returns (bool) {
175         _transfer(from, to, value);
176         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
177         return true;
178     }
179 
180     /**
181      * @dev Increase the amount of tokens that an owner allowed to a spender.
182      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
183      * allowed value is better to use this function to avoid 2 calls (and wait until
184      * the first transaction is mined)
185      * From MonolithDAO Token.sol
186      * Emits an Approval event.
187      * @param spender The address which will spend the funds.
188      * @param addedValue The amount of tokens to increase the allowance by.
189      */
190     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
191         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
192         return true;
193     }
194 
195     /**
196      * @dev Decrease the amount of tokens that an owner allowed to a spender.
197      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
198      * allowed value is better to use this function to avoid 2 calls (and wait until
199      * the first transaction is mined)
200      * From MonolithDAO Token.sol
201      * Emits an Approval event.
202      * @param spender The address which will spend the funds.
203      * @param subtractedValue The amount of tokens to decrease the allowance by.
204      */
205     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
206         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
207         return true;
208     }
209 
210     /**
211      * @dev Transfer token for a specified addresses
212      * @param from The address to transfer from.
213      * @param to The address to transfer to.
214      * @param value The amount to be transferred.
215      */
216     function _transfer(address from, address to, uint256 value) internal {
217         require(to != address(0));
218 
219         _balances[from] = _balances[from].sub(value);
220         _balances[to] = _balances[to].add(value);
221         emit Transfer(from, to, value);
222     }
223 
224     /**
225      * @dev Internal function that mints an amount of the token and assigns it to
226      * an account. This encapsulates the modification of balances such that the
227      * proper events are emitted.
228      * @param account The account that will receive the created tokens.
229      * @param value The amount that will be created.
230      */
231     function _mint(address account, uint256 value) internal {
232         require(account != address(0));
233 
234         _totalSupply = _totalSupply.add(value);
235         _balances[account] = _balances[account].add(value);
236         emit Transfer(address(0), account, value);
237     }
238 
239     /**
240      * @dev Internal function that burns an amount of the token of a given
241      * account.
242      * @param account The account whose tokens will be burnt.
243      * @param value The amount that will be burnt.
244      */
245     function _burn(address account, uint256 value) internal {
246         require(account != address(0));
247 
248         _totalSupply = _totalSupply.sub(value);
249         _balances[account] = _balances[account].sub(value);
250         emit Transfer(account, address(0), value);
251     }
252 
253     /**
254      * @dev Approve an address to spend another addresses' tokens.
255      * @param owner The address that owns the tokens.
256      * @param spender The address that will spend the tokens.
257      * @param value The number of tokens that can be spent.
258      */
259     function _approve(address owner, address spender, uint256 value) internal {
260         require(spender != address(0));
261         require(owner != address(0));
262 
263         _allowed[owner][spender] = value;
264         emit Approval(owner, spender, value);
265     }
266 
267     /**
268      * @dev Internal function that burns an amount of the token of a given
269      * account, deducting from the sender's allowance for said account. Uses the
270      * internal burn function.
271      * Emits an Approval event (reflecting the reduced allowance).
272      * @param account The account whose tokens will be burnt.
273      * @param value The amount that will be burnt.
274      */
275     function _burnFrom(address account, uint256 value) internal {
276         _burn(account, value);
277         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
278     }
279 }
280 
281 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
282 
283 /**
284  * @title Ownable
285  * @dev The Ownable contract has an owner address, and provides basic authorization control
286  * functions, this simplifies the implementation of "user permissions".
287  */
288 contract Ownable {
289     address private _owner;
290 
291     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
292 
293     /**
294      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
295      * account.
296      */
297     constructor () internal {
298         _owner = msg.sender;
299         emit OwnershipTransferred(address(0), _owner);
300     }
301 
302     /**
303      * @return the address of the owner.
304      */
305     function owner() public view returns (address) {
306         return _owner;
307     }
308 
309     /**
310      * @dev Throws if called by any account other than the owner.
311      */
312     modifier onlyOwner() {
313         require(isOwner());
314         _;
315     }
316 
317     /**
318      * @return true if `msg.sender` is the owner of the contract.
319      */
320     function isOwner() public view returns (bool) {
321         return msg.sender == _owner;
322     }
323 
324     /**
325      * @dev Allows the current owner to relinquish control of the contract.
326      * It will not be possible to call the functions with the `onlyOwner`
327      * modifier anymore.
328      * @notice Renouncing ownership will leave the contract without an owner,
329      * thereby removing any functionality that is only available to the owner.
330      */
331     function renounceOwnership() public onlyOwner {
332         emit OwnershipTransferred(_owner, address(0));
333         _owner = address(0);
334     }
335 
336     /**
337      * @dev Allows the current owner to transfer control of the contract to a newOwner.
338      * @param newOwner The address to transfer ownership to.
339      */
340     function transferOwnership(address newOwner) public onlyOwner {
341         _transferOwnership(newOwner);
342     }
343 
344     /**
345      * @dev Transfers control of the contract to a newOwner.
346      * @param newOwner The address to transfer ownership to.
347      */
348     function _transferOwnership(address newOwner) internal {
349         require(newOwner != address(0));
350         emit OwnershipTransferred(_owner, newOwner);
351         _owner = newOwner;
352     }
353 }
354 
355 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
356 
357 /**
358  * @title Burnable Token
359  * @dev Token that can be irreversibly burned (destroyed).
360  */
361 contract ERC20Burnable is ERC20 {
362     /**
363      * @dev Burns a specific amount of tokens.
364      * @param value The amount of token to be burned.
365      */
366     function burn(uint256 value) public {
367         _burn(msg.sender, value);
368     }
369 
370     /**
371      * @dev Burns a specific amount of tokens from the target address and decrements allowance
372      * @param from address The account whose tokens will be burned.
373      * @param value uint256 The amount of token to be burned.
374      */
375     function burnFrom(address from, uint256 value) public {
376         _burnFrom(from, value);
377     }
378 }
379 
380 // File: openzeppelin-solidity/contracts/access/Roles.sol
381 
382 /**
383  * @title Roles
384  * @dev Library for managing addresses assigned to a Role.
385  */
386 library Roles {
387     struct Role {
388         mapping (address => bool) bearer;
389     }
390 
391     /**
392      * @dev give an account access to this role
393      */
394     function add(Role storage role, address account) internal {
395         require(account != address(0));
396         require(!has(role, account));
397 
398         role.bearer[account] = true;
399     }
400 
401     /**
402      * @dev remove an account's access to this role
403      */
404     function remove(Role storage role, address account) internal {
405         require(account != address(0));
406         require(has(role, account));
407 
408         role.bearer[account] = false;
409     }
410 
411     /**
412      * @dev check if an account has this role
413      * @return bool
414      */
415     function has(Role storage role, address account) internal view returns (bool) {
416         require(account != address(0));
417         return role.bearer[account];
418     }
419 }
420 
421 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
422 
423 contract MinterRole {
424     using Roles for Roles.Role;
425 
426     event MinterAdded(address indexed account);
427     event MinterRemoved(address indexed account);
428 
429     Roles.Role private _minters;
430 
431     constructor () internal {
432         _addMinter(msg.sender);
433     }
434 
435     modifier onlyMinter() {
436         require(isMinter(msg.sender));
437         _;
438     }
439 
440     function isMinter(address account) public view returns (bool) {
441         return _minters.has(account);
442     }
443 
444     function addMinter(address account) public onlyMinter {
445         _addMinter(account);
446     }
447 
448     function renounceMinter() public {
449         _removeMinter(msg.sender);
450     }
451 
452     function _addMinter(address account) internal {
453         _minters.add(account);
454         emit MinterAdded(account);
455     }
456 
457     function _removeMinter(address account) internal {
458         _minters.remove(account);
459         emit MinterRemoved(account);
460     }
461 }
462 
463 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
464 
465 /**
466  * @title ERC20Mintable
467  * @dev ERC20 minting logic
468  */
469 contract ERC20Mintable is ERC20, MinterRole {
470     /**
471      * @dev Function to mint tokens
472      * @param to The address that will receive the minted tokens.
473      * @param value The amount of tokens to mint.
474      * @return A boolean that indicates if the operation was successful.
475      */
476     function mint(address to, uint256 value) public onlyMinter returns (bool) {
477         _mint(to, value);
478         return true;
479     }
480 }
481 
482 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
483 
484 /**
485  * @title Capped token
486  * @dev Mintable token with a token cap.
487  */
488 contract ERC20Capped is ERC20Mintable {
489     uint256 private _cap;
490 
491     constructor (uint256 cap) public {
492         require(cap > 0);
493         _cap = cap;
494     }
495 
496     /**
497      * @return the cap for the token minting.
498      */
499     function cap() public view returns (uint256) {
500         return _cap;
501     }
502 
503     function _mint(address account, uint256 value) internal {
504         require(totalSupply().add(value) <= _cap);
505         super._mint(account, value);
506     }
507 }
508 
509 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
510 
511 /**
512  * @title ERC20Detailed token
513  * @dev The decimals are only for visualization purposes.
514  * All the operations are done using the smallest and indivisible token unit,
515  * just as on Ethereum all the operations are done in wei.
516  */
517 contract ERC20Detailed is IERC20 {
518     string private _name;
519     string private _symbol;
520     uint8 private _decimals;
521 
522     constructor (string memory name, string memory symbol, uint8 decimals) public {
523         _name = name;
524         _symbol = symbol;
525         _decimals = decimals;
526     }
527 
528     /**
529      * @return the name of the token.
530      */
531     function name() public view returns (string memory) {
532         return _name;
533     }
534 
535     /**
536      * @return the symbol of the token.
537      */
538     function symbol() public view returns (string memory) {
539         return _symbol;
540     }
541 
542     /**
543      * @return the number of decimals of the token.
544      */
545     function decimals() public view returns (uint8) {
546         return _decimals;
547     }
548 }
549 
550 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
551 
552 contract PauserRole {
553     using Roles for Roles.Role;
554 
555     event PauserAdded(address indexed account);
556     event PauserRemoved(address indexed account);
557 
558     Roles.Role private _pausers;
559 
560     constructor () internal {
561         _addPauser(msg.sender);
562     }
563 
564     modifier onlyPauser() {
565         require(isPauser(msg.sender));
566         _;
567     }
568 
569     function isPauser(address account) public view returns (bool) {
570         return _pausers.has(account);
571     }
572 
573     function addPauser(address account) public onlyPauser {
574         _addPauser(account);
575     }
576 
577     function renouncePauser() public {
578         _removePauser(msg.sender);
579     }
580 
581     function _addPauser(address account) internal {
582         _pausers.add(account);
583         emit PauserAdded(account);
584     }
585 
586     function _removePauser(address account) internal {
587         _pausers.remove(account);
588         emit PauserRemoved(account);
589     }
590 }
591 
592 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
593 
594 /**
595  * @title Pausable
596  * @dev Base contract which allows children to implement an emergency stop mechanism.
597  */
598 contract Pausable is PauserRole {
599     event Paused(address account);
600     event Unpaused(address account);
601 
602     bool private _paused;
603 
604     constructor () internal {
605         _paused = false;
606     }
607 
608     /**
609      * @return true if the contract is paused, false otherwise.
610      */
611     function paused() public view returns (bool) {
612         return _paused;
613     }
614 
615     /**
616      * @dev Modifier to make a function callable only when the contract is not paused.
617      */
618     modifier whenNotPaused() {
619         require(!_paused);
620         _;
621     }
622 
623     /**
624      * @dev Modifier to make a function callable only when the contract is paused.
625      */
626     modifier whenPaused() {
627         require(_paused);
628         _;
629     }
630 
631     /**
632      * @dev called by the owner to pause, triggers stopped state
633      */
634     function pause() public onlyPauser whenNotPaused {
635         _paused = true;
636         emit Paused(msg.sender);
637     }
638 
639     /**
640      * @dev called by the owner to unpause, returns to normal state
641      */
642     function unpause() public onlyPauser whenPaused {
643         _paused = false;
644         emit Unpaused(msg.sender);
645     }
646 }
647 
648 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
649 
650 /**
651  * @title Pausable token
652  * @dev ERC20 modified with pausable transfers.
653  */
654 contract ERC20Pausable is ERC20, Pausable {
655     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
656         return super.transfer(to, value);
657     }
658 
659     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
660         return super.transferFrom(from, to, value);
661     }
662 
663     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
664         return super.approve(spender, value);
665     }
666 
667     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
668         return super.increaseAllowance(spender, addedValue);
669     }
670 
671     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
672         return super.decreaseAllowance(spender, subtractedValue);
673     }
674 }
675 
676 // File: openzeppelin-solidity/contracts/utils/Address.sol
677 
678 /**
679  * Utility library of inline functions on addresses
680  */
681 library Address {
682     /**
683      * Returns whether the target address is a contract
684      * @dev This function will return false if invoked during the constructor of a contract,
685      * as the code is not actually created until after the constructor finishes.
686      * @param account address of the account to check
687      * @return whether the target address is a contract
688      */
689     function isContract(address account) internal view returns (bool) {
690         uint256 size;
691         // XXX Currently there is no better way to check if there is a contract in an address
692         // than to check the size of the code at that address.
693         // See https://ethereum.stackexchange.com/a/14016/36603
694         // for more details about how this works.
695         // TODO Check this again before the Serenity release, because all addresses will be
696         // contracts then.
697         // solhint-disable-next-line no-inline-assembly
698         assembly { size := extcodesize(account) }
699         return size > 0;
700     }
701 }
702 
703 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
704 
705 /**
706  * @title SafeERC20
707  * @dev Wrappers around ERC20 operations that throw on failure (when the token
708  * contract returns false). Tokens that return no value (and instead revert or
709  * throw on failure) are also supported, non-reverting calls are assumed to be
710  * successful.
711  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
712  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
713  */
714 library SafeERC20 {
715     using SafeMath for uint256;
716     using Address for address;
717 
718     function safeTransfer(IERC20 token, address to, uint256 value) internal {
719         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
720     }
721 
722     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
723         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
724     }
725 
726     function safeApprove(IERC20 token, address spender, uint256 value) internal {
727         // safeApprove should only be called when setting an initial allowance,
728         // or when resetting it to zero. To increase and decrease it, use
729         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
730         require((value == 0) || (token.allowance(address(this), spender) == 0));
731         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
732     }
733 
734     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
735         uint256 newAllowance = token.allowance(address(this), spender).add(value);
736         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
737     }
738 
739     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
740         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
741         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
742     }
743 
744     /**
745      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
746      * on the return value: the return value is optional (but if data is returned, it must equal true).
747      * @param token The token targeted by the call.
748      * @param data The call data (encoded using abi.encode or one of its variants).
749      */
750     function callOptionalReturn(IERC20 token, bytes memory data) private {
751         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
752         // we're implementing it ourselves.
753 
754         // A Solidity high level call has three parts:
755         //  1. The target address is checked to verify it contains contract code
756         //  2. The call itself is made, and success asserted
757         //  3. The return value is decoded, which in turn checks the size of the returned data.
758 
759         require(address(token).isContract());
760 
761         // solhint-disable-next-line avoid-low-level-calls
762         (bool success, bytes memory returndata) = address(token).call(data);
763         require(success);
764 
765         if (returndata.length > 0) { // Return data is optional
766             require(abi.decode(returndata, (bool)));
767         }
768     }
769 }
770 
771 // File: contracts/PRDXToken.sol
772 
773 contract PRDXToken is  ERC20, ERC20Detailed, ERC20Capped, ERC20Burnable, ERC20Pausable, Ownable {
774 
775   using SafeERC20 for ERC20;
776 
777   constructor(string memory name, string memory symbol, uint8 decimals, uint256 cap)
778     public
779     ERC20()
780     ERC20Detailed(name, symbol, decimals)
781     ERC20Capped(cap)
782     ERC20Burnable()
783     ERC20Pausable()
784     Ownable() {}
785 }