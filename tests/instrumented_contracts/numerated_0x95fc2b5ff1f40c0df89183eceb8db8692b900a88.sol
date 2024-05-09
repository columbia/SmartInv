1 pragma solidity ^0.4.24;
2 // ----------------------------------------------------------------------------
3 // AiBe Token Smart Contract V.1.0
4 // Symbol       : AiBe
5 // Name         : AiBe Token
6 // Decimals     : 18
7 // Total supply : 6,000,000
8 // ----------------------------------------------------------------------------
9 
10 /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /**
21      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22      * account.
23      */
24     constructor () internal {
25         _owner = msg.sender;
26         emit OwnershipTransferred(address(0), _owner);
27     }
28 
29     /**
30      * @return the address of the owner.
31      */
32     function owner() public view returns (address) {
33         return _owner;
34     }
35 
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         require(isOwner());
41         _;
42     }
43 
44     /**
45      * @return true if `msg.sender` is the owner of the contract.
46      */
47     function isOwner() public view returns (bool) {
48         return msg.sender == _owner;
49     }
50 
51     /**
52      * @dev Allows the current owner to relinquish control of the contract.
53      * @notice Renouncing to ownership will leave the contract without an owner.
54      * It will not be possible to call the functions with the `onlyOwner`
55      * modifier anymore.
56      */
57     function renounceOwnership() public onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) public onlyOwner {
67         _transferOwnership(newOwner);
68     }
69 
70     /**
71      * @dev Transfers control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      */
74     function _transferOwnership(address newOwner) internal {
75         require(newOwner != address(0));
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 }
80 
81 
82 /**
83  * @title SafeMath
84  * @dev Math operations with safety checks that revert on error
85  */
86 library SafeMath {
87     int256 constant private INT256_MIN = -2**255;
88 
89     /**
90     * @dev Multiplies two unsigned integers, reverts on overflow.
91     */
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
94         // benefit is lost if 'b' is also tested.
95         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
96         if (a == 0) {
97             return 0;
98         }
99 
100         uint256 c = a * b;
101         require(c / a == b);
102 
103         return c;
104     }
105 
106     /**
107     * @dev Multiplies two signed integers, reverts on overflow.
108     */
109     function mul(int256 a, int256 b) internal pure returns (int256) {
110         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
111         // benefit is lost if 'b' is also tested.
112         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
113         if (a == 0) {
114             return 0;
115         }
116 
117         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
118 
119         int256 c = a * b;
120         require(c / a == b);
121 
122         return c;
123     }
124 
125     /**
126     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
127     */
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         // Solidity only automatically asserts when dividing by 0
130         require(b > 0);
131         uint256 c = a / b;
132         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133 
134         return c;
135     }
136 
137     /**
138     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
139     */
140     function div(int256 a, int256 b) internal pure returns (int256) {
141         require(b != 0); // Solidity only automatically asserts when dividing by 0
142         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
143 
144         int256 c = a / b;
145 
146         return c;
147     }
148 
149     /**
150     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
151     */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b <= a);
154         uint256 c = a - b;
155 
156         return c;
157     }
158 
159     /**
160     * @dev Subtracts two signed integers, reverts on overflow.
161     */
162     function sub(int256 a, int256 b) internal pure returns (int256) {
163         int256 c = a - b;
164         require((b >= 0 && c <= a) || (b < 0 && c > a));
165 
166         return c;
167     }
168 
169     /**
170     * @dev Adds two unsigned integers, reverts on overflow.
171     */
172     function add(uint256 a, uint256 b) internal pure returns (uint256) {
173         uint256 c = a + b;
174         require(c >= a);
175 
176         return c;
177     }
178 
179     /**
180     * @dev Adds two signed integers, reverts on overflow.
181     */
182     function add(int256 a, int256 b) internal pure returns (int256) {
183         int256 c = a + b;
184         require((b >= 0 && c >= a) || (b < 0 && c < a));
185 
186         return c;
187     }
188 
189     /**
190     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
191     * reverts when dividing by zero.
192     */
193     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
194         require(b != 0);
195         return a % b;
196     }
197 }
198 
199 
200 /**
201  * @title ERC20 interface
202  * @dev see https://github.com/ethereum/EIPs/issues/20
203  */
204 interface IERC20 {
205     function totalSupply() external view returns (uint256);
206 
207     function balanceOf(address who) external view returns (uint256);
208 
209     function allowance(address owner, address spender) external view returns (uint256);
210 
211     function transfer(address to, uint256 value) external returns (bool);
212 
213     function approve(address spender, uint256 value) external returns (bool);
214 
215     function transferFrom(address from, address to, uint256 value) external returns (bool);
216 
217     event Transfer(address indexed from, address indexed to, uint256 value);
218 
219     event Approval(address indexed owner, address indexed spender, uint256 value);
220 }
221 
222 /**
223  * @title SafeERC20
224  * @dev Wrappers around ERC20 operations that throw on failure.
225  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
226  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
227  */
228 library SafeERC20 {
229     using SafeMath for uint256;
230 
231     function safeTransfer(IERC20 token, address to, uint256 value) internal {
232         require(token.transfer(to, value));
233     }
234 
235     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
236         require(token.transferFrom(from, to, value));
237     }
238 
239     function safeApprove(IERC20 token, address spender, uint256 value) internal {
240         // safeApprove should only be called when setting an initial allowance,
241         // or when resetting it to zero. To increase and decrease it, use
242         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
243         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
244         require(token.approve(spender, value));
245     }
246 
247     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
248         uint256 newAllowance = token.allowance(address(this), spender).add(value);
249         require(token.approve(spender, newAllowance));
250     }
251 
252     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
253         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
254         require(token.approve(spender, newAllowance));
255     }
256 }
257 
258 /**
259  * @title ERC20Detailed token
260  * @dev The decimals are only for visualization purposes.
261  * All the operations are done using the smallest and indivisible token unit,
262  * just as on Ethereum all the operations are done in wei.
263  */
264 contract ERC20Detailed is IERC20 {
265     string private _name;
266     string private _symbol;
267     uint8 private _decimals;
268 
269     constructor (string name, string symbol, uint8 decimals) public {
270         _name = name;
271         _symbol = symbol;
272         _decimals = decimals;
273     }
274 
275     /**
276      * @return the name of the token.
277      */
278     function name() public view returns (string) {
279         return _name;
280     }
281 
282     /**
283      * @return the symbol of the token.
284      */
285     function symbol() public view returns (string) {
286         return _symbol;
287     }
288 
289     /**
290      * @return the number of decimals of the token.
291      */
292     function decimals() public view returns (uint8) {
293         return _decimals;
294     }
295 }
296 
297 /**
298  * @title Roles
299  * @dev Library for managing addresses assigned to a Role.
300  */
301 library Roles {
302     struct Role {
303         mapping (address => bool) bearer;
304     }
305 
306     /**
307      * @dev give an account access to this role
308      */
309     function add(Role storage role, address account) internal {
310         require(account != address(0));
311         require(!has(role, account));
312 
313         role.bearer[account] = true;
314     }
315 
316     /**
317      * @dev remove an account's access to this role
318      */
319     function remove(Role storage role, address account) internal {
320         require(account != address(0));
321         require(has(role, account));
322 
323         role.bearer[account] = false;
324     }
325 
326     /**
327      * @dev check if an account has this role
328      * @return bool
329      */
330     function has(Role storage role, address account) internal view returns (bool) {
331         require(account != address(0));
332         return role.bearer[account];
333     }
334 }
335 
336 
337 contract SignerRole {
338     using Roles for Roles.Role;
339 
340     event SignerAdded(address indexed account);
341     event SignerRemoved(address indexed account);
342 
343     Roles.Role private _signers;
344 
345     constructor () internal {
346         _addSigner(msg.sender);
347     }
348 
349     modifier onlySigner() {
350         require(isSigner(msg.sender));
351         _;
352     }
353 
354     function isSigner(address account) public view returns (bool) {
355         return _signers.has(account);
356     }
357 
358     function addSigner(address account) public onlySigner {
359         _addSigner(account);
360     }
361 
362     function renounceSigner() public {
363         _removeSigner(msg.sender);
364     }
365 
366     function _addSigner(address account) internal {
367         _signers.add(account);
368         emit SignerAdded(account);
369     }
370 
371     function _removeSigner(address account) internal {
372         _signers.remove(account);
373         emit SignerRemoved(account);
374     }
375 }
376 
377 
378 contract MinterRole {
379     using Roles for Roles.Role;
380 
381     event MinterAdded(address indexed account);
382     event MinterRemoved(address indexed account);
383 
384     Roles.Role private _minters;
385 
386     constructor () internal {
387         _addMinter(msg.sender);
388     }
389 
390     modifier onlyMinter() {
391         require(isMinter(msg.sender));
392         _;
393     }
394 
395     function isMinter(address account) public view returns (bool) {
396         return _minters.has(account);
397     }
398 
399     function addMinter(address account) public onlyMinter {
400         _addMinter(account);
401     }
402 
403     function renounceMinter() public {
404         _removeMinter(msg.sender);
405     }
406 
407     function _addMinter(address account) internal {
408         _minters.add(account);
409         emit MinterAdded(account);
410     }
411 
412     function _removeMinter(address account) internal {
413         _minters.remove(account);
414         emit MinterRemoved(account);
415     }
416 }
417 
418 contract PauserRole {
419     using Roles for Roles.Role;
420 
421     event PauserAdded(address indexed account);
422     event PauserRemoved(address indexed account);
423 
424     Roles.Role private _pausers;
425 
426     constructor () internal {
427         _addPauser(msg.sender);
428     }
429 
430     modifier onlyPauser() {
431         require(isPauser(msg.sender));
432         _;
433     }
434 
435     function isPauser(address account) public view returns (bool) {
436         return _pausers.has(account);
437     }
438 
439     function addPauser(address account) public onlyPauser {
440         _addPauser(account);
441     }
442 
443     function renouncePauser() public {
444         _removePauser(msg.sender);
445     }
446 
447     function _addPauser(address account) internal {
448         _pausers.add(account);
449         emit PauserAdded(account);
450     }
451 
452     function _removePauser(address account) internal {
453         _pausers.remove(account);
454         emit PauserRemoved(account);
455     }
456 }
457 
458 /**
459  * @title Standard ERC20 token
460  *
461  * @dev Implementation of the basic standard token.
462  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
463  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
464  *
465  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
466  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
467  * compliant implementations may not do it.
468  */
469 contract ERC20 is IERC20, Ownable {
470     using SafeMath for uint256;
471 
472     mapping (address => uint256) private _balances;
473 
474     mapping (address => mapping (address => uint256)) private _allowed;
475 
476     uint256 private _totalSupply;
477 
478     /**
479     * @dev Total number of tokens in existence
480     */
481     function totalSupply() public view returns (uint256) {
482         return _totalSupply;
483     }
484 
485     /**
486     * @dev Gets the balance of the specified address.
487     * @param owner The address to query the balance of.
488     * @return An uint256 representing the amount owned by the passed address.
489     */
490     function balanceOf(address owner) public view returns (uint256) {
491         return _balances[owner];
492     }
493 
494     /**
495      * @dev Function to check the amount of tokens that an owner allowed to a spender.
496      * @param owner address The address which owns the funds.
497      * @param spender address The address which will spend the funds.
498      * @return A uint256 specifying the amount of tokens still available for the spender.
499      */
500     function allowance(address owner, address spender) public view returns (uint256) {
501         return _allowed[owner][spender];
502     }
503 
504     /**
505     * @dev Transfer token for a specified address
506     * @param to The address to transfer to.
507     * @param value The amount to be transferred.
508     */
509     function transfer(address to, uint256 value) public returns (bool) {
510         _transfer(msg.sender, to, value);
511         return true;
512     }
513 
514     /**
515      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
516      * Beware that changing an allowance with this method brings the risk that someone may use both the old
517      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
518      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
519      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
520      * @param spender The address which will spend the funds.
521      * @param value The amount of tokens to be spent.
522      */
523     function approve(address spender, uint256 value) public returns (bool) {
524         require(spender != address(0));
525 
526         _allowed[msg.sender][spender] = value;
527         emit Approval(msg.sender, spender, value);
528         return true;
529     }
530 
531     /**
532      * @dev Transfer tokens from one address to another.
533      * Note that while this function emits an Approval event, this is not required as per the specification,
534      * and other compliant implementations may not emit the event.
535      * @param from address The address which you want to send tokens from
536      * @param to address The address which you want to transfer to
537      * @param value uint256 the amount of tokens to be transferred
538      */
539     function transferFrom(address from, address to, uint256 value) public returns (bool) {
540         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
541         _transfer(from, to, value);
542         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
543         return true;
544     }
545 
546     /**
547      * @dev Increase the amount of tokens that an owner allowed to a spender.
548      * approve should be called when allowed_[_spender] == 0. To increment
549      * allowed value is better to use this function to avoid 2 calls (and wait until
550      * the first transaction is mined)
551      * From MonolithDAO Token.sol
552      * Emits an Approval event.
553      * @param spender The address which will spend the funds.
554      * @param addedValue The amount of tokens to increase the allowance by.
555      */
556     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
557         require(spender != address(0));
558 
559         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
560         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
561         return true;
562     }
563 
564     /**
565      * @dev Decrease the amount of tokens that an owner allowed to a spender.
566      * approve should be called when allowed_[_spender] == 0. To decrement
567      * allowed value is better to use this function to avoid 2 calls (and wait until
568      * the first transaction is mined)
569      * From MonolithDAO Token.sol
570      * Emits an Approval event.
571      * @param spender The address which will spend the funds.
572      * @param subtractedValue The amount of tokens to decrease the allowance by.
573      */
574     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
575         require(spender != address(0));
576 
577         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
578         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
579         return true;
580     }
581 
582     /**
583     * @dev Transfer token for a specified addresses
584     * @param from The address to transfer from.
585     * @param to The address to transfer to.
586     * @param value The amount to be transferred.
587     */
588     function _transfer(address from, address to, uint256 value) internal {
589         require(to != address(0));
590 
591         _balances[from] = _balances[from].sub(value);
592         _balances[to] = _balances[to].add(value);
593         emit Transfer(from, to, value);
594     }
595 
596     /**
597      * @dev Internal function that mints an amount of the token and assigns it to
598      * an account. This encapsulates the modification of balances such that the
599      * proper events are emitted.
600      * @param account The account that will receive the created tokens.
601      * @param value The amount that will be created.
602      */
603     function _mint(address account, uint256 value) internal {
604         require(account != address(0));
605 
606         _totalSupply = _totalSupply.add(value);
607         _balances[account] = _balances[account].add(value);
608         emit Transfer(address(0), account, value);
609     }
610 
611     /**
612      * @dev Internal function that burns an amount of the token of a given
613      * account.
614      * @param account The account whose tokens will be burnt.
615      * @param value The amount that will be burnt.
616      */
617     function _burn(address account, uint256 value) internal {
618         require(account != address(0));
619 
620         _totalSupply = _totalSupply.sub(value);
621         _balances[account] = _balances[account].sub(value);
622         emit Transfer(account, address(0), value);
623     }
624 
625     /**
626      * @dev Internal function that burns an amount of the token of a given
627      * account, deducting from the sender's allowance for said account. Uses the
628      * internal burn function.
629      * Emits an Approval event (reflecting the reduced allowance).
630      * @param account The account whose tokens will be burnt.
631      * @param value The amount that will be burnt.
632      */
633     function _burnFrom(address account, uint256 value) internal {
634         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
635         _burn(account, value);
636         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
637     }
638 }
639 
640 
641 /**
642  * @title Pausable
643  * @dev Base contract which allows children to implement an emergency stop mechanism.
644  */
645 contract Pausable is PauserRole {
646     event Paused(address account);
647     event Unpaused(address account);
648 
649     bool private _paused;
650 
651     constructor () internal {
652         _paused = false;
653     }
654 
655     /**
656      * @return true if the contract is paused, false otherwise.
657      */
658     function paused() public view returns (bool) {
659         return _paused;
660     }
661 
662     /**
663      * @dev Modifier to make a function callable only when the contract is not paused.
664      */
665     modifier whenNotPaused() {
666         require(!_paused);
667         _;
668     }
669 
670     /**
671      * @dev Modifier to make a function callable only when the contract is paused.
672      */
673     modifier whenPaused() {
674         require(_paused);
675         _;
676     }
677 
678     /**
679      * @dev called by the owner to pause, triggers stopped state
680      */
681     function pause() public onlyPauser whenNotPaused {
682         _paused = true;
683         emit Paused(msg.sender);
684     }
685 
686     /**
687      * @dev called by the owner to unpause, returns to normal state
688      */
689     function unpause() public onlyPauser whenPaused {
690         _paused = false;
691         emit Unpaused(msg.sender);
692     }
693 }
694 
695 
696 /**
697  * @title Burnable Token
698  * @dev Token that can be irreversibly burned (destroyed).
699  */
700 contract ERC20Burnable is ERC20 {
701     /**
702      * @dev Burns a specific amount of tokens.
703      * @param value The amount of token to be burned.
704      */
705     function burn(uint256 value) public {
706         _burn(msg.sender, value);
707     }
708 
709     /**
710      * @dev Burns a specific amount of tokens from the target address and decrements allowance
711      * @param from address The address which you want to send tokens from
712      * @param value uint256 The amount of token to be burned
713      */
714     function burnFrom(address from, uint256 value) public {
715         _burnFrom(from, value);
716     }
717 }
718 
719 
720 /**
721  * @title Pausable token
722  * @dev ERC20 modified with pausable transfers.
723  **/
724 contract ERC20Pausable is ERC20, Pausable {
725     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
726         return super.transfer(to, value);
727     }
728 
729     function transferFrom(address from,address to, uint256 value) public whenNotPaused returns (bool) {
730         return super.transferFrom(from, to, value);
731     }
732 
733     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
734         return super.approve(spender, value);
735     }
736 
737     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
738         return super.increaseAllowance(spender, addedValue);
739     }
740 
741     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
742         return super.decreaseAllowance(spender, subtractedValue);
743     }
744 }
745 
746 /**
747  * @title ERC20Mintable
748  * @dev ERC20 minting logic
749  */
750 contract ERC20Mintable is ERC20, MinterRole {
751     /**
752      * @dev Function to mint tokens
753      * @param to The address that will receive the minted tokens.
754      * @param value The amount of tokens to mint.
755      * @return A boolean that indicates if the operation was successful.
756      */
757     function mint(address to, uint256 value) public onlyMinter returns (bool) {
758         _mint(to, value);
759         return true;
760     }
761 }
762 
763 contract AiBe is ERC20Pausable, ERC20Burnable, ERC20Mintable, ERC20Detailed {
764     uint256 public constant INITIAL_SUPPLY = 6000000 * (10 ** uint256(decimals()));
765     address supplier = 0xf1233CeF0f5cA88d9bbB0749ef62203362B6889f;
766     /**
767      * @dev Constructor that gives msg.sender all of existing tokens.
768      */
769     constructor () public ERC20Detailed("AiBe", "AiBe", 18) {
770         _mint(supplier, INITIAL_SUPPLY);
771     }
772 }