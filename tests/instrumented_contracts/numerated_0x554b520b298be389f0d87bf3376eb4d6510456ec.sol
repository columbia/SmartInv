1 pragma solidity ^0.4.24;
2 // ----------------------------------------------------------------------------
3 // TOKENMOM DECENTRALIZED EXCHANGE Token(TM) Smart Contract V.1.1
4 // 토큰맘 탈중앙화거래소 토큰(TM) 스마트 컨트랙트 버전1.1
5 // Exchange URL : https://tokenmom.com
6 // Trading FEE  : 0.00% Event (Maker and Taker)
7 // Symbol       : TM
8 // Name         : TOKENMOM Token
9 // Decimals     : 18
10 // Total supply : 2,000,000,000
11 // 40%	800,000,000	Free TM token to Tokenmom users(Rewards & Referral)
12 // 40%	800,000,000	Founder, team, exchange ecosystem & maintenance
13 // 10%	200,000,000	Price stability and maintenance of TM Token(Burning)
14 // 10%	200,000,000	Reserved funds to prepare for future problems
15 // ----------------------------------------------------------------------------
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23     address private _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     /**
28      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29      * account.
30      */
31     constructor () internal {
32         _owner = msg.sender;
33         emit OwnershipTransferred(address(0), _owner);
34     }
35 
36     /**
37      * @return the address of the owner.
38      */
39     function owner() public view returns (address) {
40         return _owner;
41     }
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyOwner() {
47         require(isOwner());
48         _;
49     }
50 
51     /**
52      * @return true if `msg.sender` is the owner of the contract.
53      */
54     function isOwner() public view returns (bool) {
55         return msg.sender == _owner;
56     }
57 
58     /**
59      * @dev Allows the current owner to relinquish control of the contract.
60      * @notice Renouncing to ownership will leave the contract without an owner.
61      * It will not be possible to call the functions with the `onlyOwner`
62      * modifier anymore.
63      */
64     function renounceOwnership() public onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68 
69     /**
70      * @dev Allows the current owner to transfer control of the contract to a newOwner.
71      * @param newOwner The address to transfer ownership to.
72      */
73     function transferOwnership(address newOwner) public onlyOwner {
74         _transferOwnership(newOwner);
75     }
76 
77     /**
78      * @dev Transfers control of the contract to a newOwner.
79      * @param newOwner The address to transfer ownership to.
80      */
81     function _transferOwnership(address newOwner) internal {
82         require(newOwner != address(0));
83         emit OwnershipTransferred(_owner, newOwner);
84         _owner = newOwner;
85     }
86 }
87 
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that revert on error
92  */
93 library SafeMath {
94     int256 constant private INT256_MIN = -2**255;
95 
96     /**
97     * @dev Multiplies two unsigned integers, reverts on overflow.
98     */
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
101         // benefit is lost if 'b' is also tested.
102         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
103         if (a == 0) {
104             return 0;
105         }
106 
107         uint256 c = a * b;
108         require(c / a == b);
109 
110         return c;
111     }
112 
113     /**
114     * @dev Multiplies two signed integers, reverts on overflow.
115     */
116     function mul(int256 a, int256 b) internal pure returns (int256) {
117         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
118         // benefit is lost if 'b' is also tested.
119         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
120         if (a == 0) {
121             return 0;
122         }
123 
124         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
125 
126         int256 c = a * b;
127         require(c / a == b);
128 
129         return c;
130     }
131 
132     /**
133     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
134     */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         // Solidity only automatically asserts when dividing by 0
137         require(b > 0);
138         uint256 c = a / b;
139         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
140 
141         return c;
142     }
143 
144     /**
145     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
146     */
147     function div(int256 a, int256 b) internal pure returns (int256) {
148         require(b != 0); // Solidity only automatically asserts when dividing by 0
149         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
150 
151         int256 c = a / b;
152 
153         return c;
154     }
155 
156     /**
157     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
158     */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         require(b <= a);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167     * @dev Subtracts two signed integers, reverts on overflow.
168     */
169     function sub(int256 a, int256 b) internal pure returns (int256) {
170         int256 c = a - b;
171         require((b >= 0 && c <= a) || (b < 0 && c > a));
172 
173         return c;
174     }
175 
176     /**
177     * @dev Adds two unsigned integers, reverts on overflow.
178     */
179     function add(uint256 a, uint256 b) internal pure returns (uint256) {
180         uint256 c = a + b;
181         require(c >= a);
182 
183         return c;
184     }
185 
186     /**
187     * @dev Adds two signed integers, reverts on overflow.
188     */
189     function add(int256 a, int256 b) internal pure returns (int256) {
190         int256 c = a + b;
191         require((b >= 0 && c >= a) || (b < 0 && c < a));
192 
193         return c;
194     }
195 
196     /**
197     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
198     * reverts when dividing by zero.
199     */
200     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
201         require(b != 0);
202         return a % b;
203     }
204 }
205 
206 
207 /**
208  * @title ERC20 interface
209  * @dev see https://github.com/ethereum/EIPs/issues/20
210  */
211 interface IERC20 {
212     function totalSupply() external view returns (uint256);
213 
214     function balanceOf(address who) external view returns (uint256);
215 
216     function allowance(address owner, address spender) external view returns (uint256);
217 
218     function transfer(address to, uint256 value) external returns (bool);
219 
220     function approve(address spender, uint256 value) external returns (bool);
221 
222     function transferFrom(address from, address to, uint256 value) external returns (bool);
223 
224     event Transfer(address indexed from, address indexed to, uint256 value);
225 
226     event Approval(address indexed owner, address indexed spender, uint256 value);
227 }
228 
229 /**
230  * @title SafeERC20
231  * @dev Wrappers around ERC20 operations that throw on failure.
232  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
233  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
234  */
235 library SafeERC20 {
236     using SafeMath for uint256;
237 
238     function safeTransfer(IERC20 token, address to, uint256 value) internal {
239         require(token.transfer(to, value));
240     }
241 
242     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
243         require(token.transferFrom(from, to, value));
244     }
245 
246     function safeApprove(IERC20 token, address spender, uint256 value) internal {
247         // safeApprove should only be called when setting an initial allowance,
248         // or when resetting it to zero. To increase and decrease it, use
249         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
250         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
251         require(token.approve(spender, value));
252     }
253 
254     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
255         uint256 newAllowance = token.allowance(address(this), spender).add(value);
256         require(token.approve(spender, newAllowance));
257     }
258 
259     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
260         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
261         require(token.approve(spender, newAllowance));
262     }
263 }
264 
265 /**
266  * @title ERC20Detailed token
267  * @dev The decimals are only for visualization purposes.
268  * All the operations are done using the smallest and indivisible token unit,
269  * just as on Ethereum all the operations are done in wei.
270  */
271 contract ERC20Detailed is IERC20 {
272     string private _name;
273     string private _symbol;
274     uint8 private _decimals;
275 
276     constructor (string name, string symbol, uint8 decimals) public {
277         _name = name;
278         _symbol = symbol;
279         _decimals = decimals;
280     }
281 
282     /**
283      * @return the name of the token.
284      */
285     function name() public view returns (string) {
286         return _name;
287     }
288 
289     /**
290      * @return the symbol of the token.
291      */
292     function symbol() public view returns (string) {
293         return _symbol;
294     }
295 
296     /**
297      * @return the number of decimals of the token.
298      */
299     function decimals() public view returns (uint8) {
300         return _decimals;
301     }
302 }
303 
304 /**
305  * @title Roles
306  * @dev Library for managing addresses assigned to a Role.
307  */
308 library Roles {
309     struct Role {
310         mapping (address => bool) bearer;
311     }
312 
313     /**
314      * @dev give an account access to this role
315      */
316     function add(Role storage role, address account) internal {
317         require(account != address(0));
318         require(!has(role, account));
319 
320         role.bearer[account] = true;
321     }
322 
323     /**
324      * @dev remove an account's access to this role
325      */
326     function remove(Role storage role, address account) internal {
327         require(account != address(0));
328         require(has(role, account));
329 
330         role.bearer[account] = false;
331     }
332 
333     /**
334      * @dev check if an account has this role
335      * @return bool
336      */
337     function has(Role storage role, address account) internal view returns (bool) {
338         require(account != address(0));
339         return role.bearer[account];
340     }
341 }
342 
343 
344 contract SignerRole {
345     using Roles for Roles.Role;
346 
347     event SignerAdded(address indexed account);
348     event SignerRemoved(address indexed account);
349 
350     Roles.Role private _signers;
351 
352     constructor () internal {
353         _addSigner(msg.sender);
354     }
355 
356     modifier onlySigner() {
357         require(isSigner(msg.sender));
358         _;
359     }
360 
361     function isSigner(address account) public view returns (bool) {
362         return _signers.has(account);
363     }
364 
365     function addSigner(address account) public onlySigner {
366         _addSigner(account);
367     }
368 
369     function renounceSigner() public {
370         _removeSigner(msg.sender);
371     }
372 
373     function _addSigner(address account) internal {
374         _signers.add(account);
375         emit SignerAdded(account);
376     }
377 
378     function _removeSigner(address account) internal {
379         _signers.remove(account);
380         emit SignerRemoved(account);
381     }
382 }
383 
384 
385 contract MinterRole {
386     using Roles for Roles.Role;
387 
388     event MinterAdded(address indexed account);
389     event MinterRemoved(address indexed account);
390 
391     Roles.Role private _minters;
392 
393     constructor () internal {
394         _addMinter(msg.sender);
395     }
396 
397     modifier onlyMinter() {
398         require(isMinter(msg.sender));
399         _;
400     }
401 
402     function isMinter(address account) public view returns (bool) {
403         return _minters.has(account);
404     }
405 
406     function addMinter(address account) public onlyMinter {
407         _addMinter(account);
408     }
409 
410     function renounceMinter() public {
411         _removeMinter(msg.sender);
412     }
413 
414     function _addMinter(address account) internal {
415         _minters.add(account);
416         emit MinterAdded(account);
417     }
418 
419     function _removeMinter(address account) internal {
420         _minters.remove(account);
421         emit MinterRemoved(account);
422     }
423 }
424 
425 contract PauserRole {
426     using Roles for Roles.Role;
427 
428     event PauserAdded(address indexed account);
429     event PauserRemoved(address indexed account);
430 
431     Roles.Role private _pausers;
432 
433     constructor () internal {
434         _addPauser(msg.sender);
435     }
436 
437     modifier onlyPauser() {
438         require(isPauser(msg.sender));
439         _;
440     }
441 
442     function isPauser(address account) public view returns (bool) {
443         return _pausers.has(account);
444     }
445 
446     function addPauser(address account) public onlyPauser {
447         _addPauser(account);
448     }
449 
450     function renouncePauser() public {
451         _removePauser(msg.sender);
452     }
453 
454     function _addPauser(address account) internal {
455         _pausers.add(account);
456         emit PauserAdded(account);
457     }
458 
459     function _removePauser(address account) internal {
460         _pausers.remove(account);
461         emit PauserRemoved(account);
462     }
463 }
464 
465 /**
466  * @title Standard ERC20 token
467  *
468  * @dev Implementation of the basic standard token.
469  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
470  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
471  *
472  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
473  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
474  * compliant implementations may not do it.
475  */
476 contract ERC20 is IERC20, Ownable {
477     using SafeMath for uint256;
478 
479     mapping (address => uint256) private _balances;
480 
481     mapping (address => mapping (address => uint256)) private _allowed;
482 
483     uint256 private _totalSupply;
484 
485     /**
486     * @dev Total number of tokens in existence
487     */
488     function totalSupply() public view returns (uint256) {
489         return _totalSupply;
490     }
491 
492     /**
493     * @dev Gets the balance of the specified address.
494     * @param owner The address to query the balance of.
495     * @return An uint256 representing the amount owned by the passed address.
496     */
497     function balanceOf(address owner) public view returns (uint256) {
498         return _balances[owner];
499     }
500 
501     /**
502      * @dev Function to check the amount of tokens that an owner allowed to a spender.
503      * @param owner address The address which owns the funds.
504      * @param spender address The address which will spend the funds.
505      * @return A uint256 specifying the amount of tokens still available for the spender.
506      */
507     function allowance(address owner, address spender) public view returns (uint256) {
508         return _allowed[owner][spender];
509     }
510 
511     /**
512     * @dev Transfer token for a specified address
513     * @param to The address to transfer to.
514     * @param value The amount to be transferred.
515     */
516     function transfer(address to, uint256 value) public returns (bool) {
517         _transfer(msg.sender, to, value);
518         return true;
519     }
520 
521     /**
522      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
523      * Beware that changing an allowance with this method brings the risk that someone may use both the old
524      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
525      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
526      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
527      * @param spender The address which will spend the funds.
528      * @param value The amount of tokens to be spent.
529      */
530     function approve(address spender, uint256 value) public returns (bool) {
531         require(spender != address(0));
532 
533         _allowed[msg.sender][spender] = value;
534         emit Approval(msg.sender, spender, value);
535         return true;
536     }
537 
538     /**
539      * @dev Transfer tokens from one address to another.
540      * Note that while this function emits an Approval event, this is not required as per the specification,
541      * and other compliant implementations may not emit the event.
542      * @param from address The address which you want to send tokens from
543      * @param to address The address which you want to transfer to
544      * @param value uint256 the amount of tokens to be transferred
545      */
546     function transferFrom(address from, address to, uint256 value) public returns (bool) {
547         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
548         _transfer(from, to, value);
549         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
550         return true;
551     }
552 
553     /**
554      * @dev Increase the amount of tokens that an owner allowed to a spender.
555      * approve should be called when allowed_[_spender] == 0. To increment
556      * allowed value is better to use this function to avoid 2 calls (and wait until
557      * the first transaction is mined)
558      * From MonolithDAO Token.sol
559      * Emits an Approval event.
560      * @param spender The address which will spend the funds.
561      * @param addedValue The amount of tokens to increase the allowance by.
562      */
563     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
564         require(spender != address(0));
565 
566         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
567         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
568         return true;
569     }
570 
571     /**
572      * @dev Decrease the amount of tokens that an owner allowed to a spender.
573      * approve should be called when allowed_[_spender] == 0. To decrement
574      * allowed value is better to use this function to avoid 2 calls (and wait until
575      * the first transaction is mined)
576      * From MonolithDAO Token.sol
577      * Emits an Approval event.
578      * @param spender The address which will spend the funds.
579      * @param subtractedValue The amount of tokens to decrease the allowance by.
580      */
581     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
582         require(spender != address(0));
583 
584         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
585         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
586         return true;
587     }
588 
589     /**
590     * @dev Transfer token for a specified addresses
591     * @param from The address to transfer from.
592     * @param to The address to transfer to.
593     * @param value The amount to be transferred.
594     */
595     function _transfer(address from, address to, uint256 value) internal {
596         require(to != address(0));
597 
598         _balances[from] = _balances[from].sub(value);
599         _balances[to] = _balances[to].add(value);
600         emit Transfer(from, to, value);
601     }
602 
603     /**
604      * @dev Internal function that mints an amount of the token and assigns it to
605      * an account. This encapsulates the modification of balances such that the
606      * proper events are emitted.
607      * @param account The account that will receive the created tokens.
608      * @param value The amount that will be created.
609      */
610     function _mint(address account, uint256 value) internal {
611         require(account != address(0));
612 
613         _totalSupply = _totalSupply.add(value);
614         _balances[account] = _balances[account].add(value);
615         emit Transfer(address(0), account, value);
616     }
617 
618     /**
619      * @dev Internal function that burns an amount of the token of a given
620      * account.
621      * @param account The account whose tokens will be burnt.
622      * @param value The amount that will be burnt.
623      */
624     function _burn(address account, uint256 value) internal {
625         require(account != address(0));
626 
627         _totalSupply = _totalSupply.sub(value);
628         _balances[account] = _balances[account].sub(value);
629         emit Transfer(account, address(0), value);
630     }
631 
632     /**
633      * @dev Internal function that burns an amount of the token of a given
634      * account, deducting from the sender's allowance for said account. Uses the
635      * internal burn function.
636      * Emits an Approval event (reflecting the reduced allowance).
637      * @param account The account whose tokens will be burnt.
638      * @param value The amount that will be burnt.
639      */
640     function _burnFrom(address account, uint256 value) internal {
641         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
642         _burn(account, value);
643         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
644     }
645 }
646 
647 
648 /**
649  * @title Pausable
650  * @dev Base contract which allows children to implement an emergency stop mechanism.
651  */
652 contract Pausable is PauserRole {
653     event Paused(address account);
654     event Unpaused(address account);
655 
656     bool private _paused;
657 
658     constructor () internal {
659         _paused = false;
660     }
661 
662     /**
663      * @return true if the contract is paused, false otherwise.
664      */
665     function paused() public view returns (bool) {
666         return _paused;
667     }
668 
669     /**
670      * @dev Modifier to make a function callable only when the contract is not paused.
671      */
672     modifier whenNotPaused() {
673         require(!_paused);
674         _;
675     }
676 
677     /**
678      * @dev Modifier to make a function callable only when the contract is paused.
679      */
680     modifier whenPaused() {
681         require(_paused);
682         _;
683     }
684 
685     /**
686      * @dev called by the owner to pause, triggers stopped state
687      */
688     function pause() public onlyPauser whenNotPaused {
689         _paused = true;
690         emit Paused(msg.sender);
691     }
692 
693     /**
694      * @dev called by the owner to unpause, returns to normal state
695      */
696     function unpause() public onlyPauser whenPaused {
697         _paused = false;
698         emit Unpaused(msg.sender);
699     }
700 }
701 
702 
703 /**
704  * @title Burnable Token
705  * @dev Token that can be irreversibly burned (destroyed).
706  */
707 contract ERC20Burnable is ERC20 {
708     /**
709      * @dev Burns a specific amount of tokens.
710      * @param value The amount of token to be burned.
711      */
712     function burn(uint256 value) public {
713         _burn(msg.sender, value);
714     }
715 
716     /**
717      * @dev Burns a specific amount of tokens from the target address and decrements allowance
718      * @param from address The address which you want to send tokens from
719      * @param value uint256 The amount of token to be burned
720      */
721     function burnFrom(address from, uint256 value) public {
722         _burnFrom(from, value);
723     }
724 }
725 
726 
727 /**
728  * @title Pausable token
729  * @dev ERC20 modified with pausable transfers.
730  **/
731 contract ERC20Pausable is ERC20, Pausable {
732     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
733         return super.transfer(to, value);
734     }
735 
736     function transferFrom(address from,address to, uint256 value) public whenNotPaused returns (bool) {
737         return super.transferFrom(from, to, value);
738     }
739 
740     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
741         return super.approve(spender, value);
742     }
743 
744     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
745         return super.increaseAllowance(spender, addedValue);
746     }
747 
748     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
749         return super.decreaseAllowance(spender, subtractedValue);
750     }
751 }
752 
753 /**
754  * @title ERC20Mintable
755  * @dev ERC20 minting logic
756  */
757 contract ERC20Mintable is ERC20, MinterRole {
758     /**
759      * @dev Function to mint tokens
760      * @param to The address that will receive the minted tokens.
761      * @param value The amount of tokens to mint.
762      * @return A boolean that indicates if the operation was successful.
763      */
764     function mint(address to, uint256 value) public onlyMinter returns (bool) {
765         _mint(to, value);
766         return true;
767     }
768 }
769 
770 contract Tokenmom is ERC20Pausable, ERC20Burnable, ERC20Mintable, ERC20Detailed {
771     uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals()));
772 
773     /**
774      * @dev Constructor that gives msg.sender all of existing tokens.
775      */
776     constructor () public ERC20Detailed("Tokenmom", "TM", 18) {
777         _mint(msg.sender, INITIAL_SUPPLY);
778     }
779 }