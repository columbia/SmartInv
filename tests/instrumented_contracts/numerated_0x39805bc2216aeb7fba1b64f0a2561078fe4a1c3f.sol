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
25 /**
26  * @title Standard ERC20 token
27  *
28  * @dev Implementation of the basic standard token.
29  * https://eips.ethereum.org/EIPS/eip-20
30  * Originally based on code by FirstBlood:
31  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
32  *
33  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
34  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
35  * compliant implementations may not do it.
36  */
37 contract ERC20 is IERC20 {
38     using SafeMath for uint256;
39 
40     mapping (address => uint256) private _balances;
41 
42     mapping (address => mapping (address => uint256)) private _allowed;
43 
44     uint256 private _totalSupply;
45 
46     /**
47      * @dev Total number of tokens in existence.
48      */
49     function totalSupply() public view returns (uint256) {
50         return _totalSupply;
51     }
52 
53     /**
54      * @dev Gets the balance of the specified address.
55      * @param owner The address to query the balance of.
56      * @return A uint256 representing the amount owned by the passed address.
57      */
58     function balanceOf(address owner) public view returns (uint256) {
59         return _balances[owner];
60     }
61 
62     /**
63      * @dev Function to check the amount of tokens that an owner allowed to a spender.
64      * @param owner address The address which owns the funds.
65      * @param spender address The address which will spend the funds.
66      * @return A uint256 specifying the amount of tokens still available for the spender.
67      */
68     function allowance(address owner, address spender) public view returns (uint256) {
69         return _allowed[owner][spender];
70     }
71 
72     /**
73      * @dev Transfer token to a specified address.
74      * @param to The address to transfer to.
75      * @param value The amount to be transferred.
76      */
77     function transfer(address to, uint256 value) public returns (bool) {
78         _transfer(msg.sender, to, value);
79         return true;
80     }
81 
82     /**
83      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
84      * Beware that changing an allowance with this method brings the risk that someone may use both the old
85      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
86      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
87      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88      * @param spender The address which will spend the funds.
89      * @param value The amount of tokens to be spent.
90      */
91     function approve(address spender, uint256 value) public returns (bool) {
92         _approve(msg.sender, spender, value);
93         return true;
94     }
95 
96     /**
97      * @dev Transfer tokens from one address to another.
98      * Note that while this function emits an Approval event, this is not required as per the specification,
99      * and other compliant implementations may not emit the event.
100      * @param from address The address which you want to send tokens from
101      * @param to address The address which you want to transfer to
102      * @param value uint256 the amount of tokens to be transferred
103      */
104     function transferFrom(address from, address to, uint256 value) public returns (bool) {
105         _transfer(from, to, value);
106         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
107         return true;
108     }
109 
110     /**
111      * @dev Increase the amount of tokens that an owner allowed to a spender.
112      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
113      * allowed value is better to use this function to avoid 2 calls (and wait until
114      * the first transaction is mined)
115      * From MonolithDAO Token.sol
116      * Emits an Approval event.
117      * @param spender The address which will spend the funds.
118      * @param addedValue The amount of tokens to increase the allowance by.
119      */
120     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
121         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
122         return true;
123     }
124 
125     /**
126      * @dev Decrease the amount of tokens that an owner allowed to a spender.
127      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
128      * allowed value is better to use this function to avoid 2 calls (and wait until
129      * the first transaction is mined)
130      * From MonolithDAO Token.sol
131      * Emits an Approval event.
132      * @param spender The address which will spend the funds.
133      * @param subtractedValue The amount of tokens to decrease the allowance by.
134      */
135     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
136         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
137         return true;
138     }
139 
140     /**
141      * @dev Transfer token for a specified addresses.
142      * @param from The address to transfer from.
143      * @param to The address to transfer to.
144      * @param value The amount to be transferred.
145      */
146     function _transfer(address from, address to, uint256 value) internal {
147         require(to != address(0), "ERC20: transfer to the zero address");
148 
149         _balances[from] = _balances[from].sub(value);
150         _balances[to] = _balances[to].add(value);
151         emit Transfer(from, to, value);
152     }
153 
154     /**
155      * @dev Internal function that mints an amount of the token and assigns it to
156      * an account. This encapsulates the modification of balances such that the
157      * proper events are emitted.
158      * @param account The account that will receive the created tokens.
159      * @param value The amount that will be created.
160      */
161     function _mint(address account, uint256 value) internal {
162         require(account != address(0), "ERC20: mint to the zero address");
163 
164         _totalSupply = _totalSupply.add(value);
165         _balances[account] = _balances[account].add(value);
166         emit Transfer(address(0), account, value);
167     }
168 
169     /**
170      * @dev Internal function that burns an amount of the token of a given
171      * account.
172      * @param account The account whose tokens will be burnt.
173      * @param value The amount that will be burnt.
174      */
175     function _burn(address account, uint256 value) internal {
176         require(account != address(0), "ERC20: burn from the zero address");
177 
178         _totalSupply = _totalSupply.sub(value);
179         _balances[account] = _balances[account].sub(value);
180         emit Transfer(account, address(0), value);
181     }
182 
183     /**
184      * @dev Approve an address to spend another addresses' tokens.
185      * @param owner The address that owns the tokens.
186      * @param spender The address that will spend the tokens.
187      * @param value The number of tokens that can be spent.
188      */
189     function _approve(address owner, address spender, uint256 value) internal {
190         require(owner != address(0), "ERC20: approve from the zero address");
191         require(spender != address(0), "ERC20: approve to the zero address");
192 
193         _allowed[owner][spender] = value;
194         emit Approval(owner, spender, value);
195     }
196 
197     /**
198      * @dev Internal function that burns an amount of the token of a given
199      * account, deducting from the sender's allowance for said account. Uses the
200      * internal burn function.
201      * Emits an Approval event (reflecting the reduced allowance).
202      * @param account The account whose tokens will be burnt.
203      * @param value The amount that will be burnt.
204      */
205     function _burnFrom(address account, uint256 value) internal {
206         _burn(account, value);
207         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
208     }
209 }
210 
211 /**
212  * @title SafeMath
213  * @dev Unsigned math operations with safety checks that revert on error.
214  */
215 library SafeMath {
216     /**
217      * @dev Multiplies two unsigned integers, reverts on overflow.
218      */
219     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
220         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
221         // benefit is lost if 'b' is also tested.
222         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
223         if (a == 0) {
224             return 0;
225         }
226 
227         uint256 c = a * b;
228         require(c / a == b, "SafeMath: multiplication overflow");
229 
230         return c;
231     }
232 
233     /**
234      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
235      */
236     function div(uint256 a, uint256 b) internal pure returns (uint256) {
237         // Solidity only automatically asserts when dividing by 0
238         require(b > 0, "SafeMath: division by zero");
239         uint256 c = a / b;
240         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241 
242         return c;
243     }
244 
245     /**
246      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
247      */
248     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
249         require(b <= a, "SafeMath: subtraction overflow");
250         uint256 c = a - b;
251 
252         return c;
253     }
254 
255     /**
256      * @dev Adds two unsigned integers, reverts on overflow.
257      */
258     function add(uint256 a, uint256 b) internal pure returns (uint256) {
259         uint256 c = a + b;
260         require(c >= a, "SafeMath: addition overflow");
261 
262         return c;
263     }
264 
265     /**
266      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
267      * reverts when dividing by zero.
268      */
269     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
270         require(b != 0, "SafeMath: modulo by zero");
271         return a % b;
272     }
273 }
274 
275 /**
276  * @title ERC20Detailed token
277  * @dev The decimals are only for visualization purposes.
278  * All the operations are done using the smallest and indivisible token unit,
279  * just as on Ethereum all the operations are done in wei.
280  */
281 contract ERC20Detailed is IERC20 {
282     string private _name;
283     string private _symbol;
284     uint8 private _decimals;
285 
286     constructor (string memory name, string memory symbol, uint8 decimals) public {
287         _name = name;
288         _symbol = symbol;
289         _decimals = decimals;
290     }
291 
292     /**
293      * @return the name of the token.
294      */
295     function name() public view returns (string memory) {
296         return _name;
297     }
298 
299     /**
300      * @return the symbol of the token.
301      */
302     function symbol() public view returns (string memory) {
303         return _symbol;
304     }
305 
306     /**
307      * @return the number of decimals of the token.
308      */
309     function decimals() public view returns (uint8) {
310         return _decimals;
311     }
312 }
313 
314 /**
315  * @title Burnable Token
316  * @dev Token that can be irreversibly burned (destroyed).
317  */
318 contract ERC20Burnable is ERC20 {
319     /**
320      * @dev Burns a specific amount of tokens.
321      * @param value The amount of token to be burned.
322      */
323     function burn(uint256 value) public {
324         _burn(msg.sender, value);
325     }
326 
327     /**
328      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
329      * @param from address The account whose tokens will be burned.
330      * @param value uint256 The amount of token to be burned.
331      */
332     function burnFrom(address from, uint256 value) public {
333         _burnFrom(from, value);
334     }
335 }
336 
337 /**
338  * @title Roles
339  * @dev Library for managing addresses assigned to a Role.
340  */
341 library Roles {
342     struct Role {
343         mapping (address => bool) bearer;
344     }
345 
346     /**
347      * @dev Give an account access to this role.
348      */
349     function add(Role storage role, address account) internal {
350         require(!has(role, account), "Roles: account already has role");
351         role.bearer[account] = true;
352     }
353 
354     /**
355      * @dev Remove an account's access to this role.
356      */
357     function remove(Role storage role, address account) internal {
358         require(has(role, account), "Roles: account does not have role");
359         role.bearer[account] = false;
360     }
361 
362     /**
363      * @dev Check if an account has this role.
364      * @return bool
365      */
366     function has(Role storage role, address account) internal view returns (bool) {
367         require(account != address(0), "Roles: account is the zero address");
368         return role.bearer[account];
369     }
370 }
371 
372 contract PauserRole {
373     using Roles for Roles.Role;
374 
375     event PauserAdded(address indexed account);
376     event PauserRemoved(address indexed account);
377 
378     Roles.Role private _pausers;
379 
380     constructor () internal {
381         _addPauser(msg.sender);
382     }
383 
384     modifier onlyPauser() {
385         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
386         _;
387     }
388 
389     function isPauser(address account) public view returns (bool) {
390         return _pausers.has(account);
391     }
392 
393     function addPauser(address account) public onlyPauser {
394         _addPauser(account);
395     }
396 
397     function renouncePauser() public {
398         _removePauser(msg.sender);
399     }
400 
401     function _addPauser(address account) internal {
402         _pausers.add(account);
403         emit PauserAdded(account);
404     }
405 
406     function _removePauser(address account) internal {
407         _pausers.remove(account);
408         emit PauserRemoved(account);
409     }
410 }
411 
412 /**
413  * @title Pausable
414  * @dev Base contract which allows children to implement an emergency stop mechanism.
415  */
416 contract Pausable is PauserRole {
417     event Paused(address account);
418     event Unpaused(address account);
419 
420     bool private _paused;
421 
422     constructor () internal {
423         _paused = false;
424     }
425 
426     /**
427      * @return True if the contract is paused, false otherwise.
428      */
429     function paused() public view returns (bool) {
430         return _paused;
431     }
432 
433     /**
434      * @dev Modifier to make a function callable only when the contract is not paused.
435      */
436     modifier whenNotPaused() {
437         require(!_paused, "Pausable: paused");
438         _;
439     }
440 
441     /**
442      * @dev Modifier to make a function callable only when the contract is paused.
443      */
444     modifier whenPaused() {
445         require(_paused, "Pausable: not paused");
446         _;
447     }
448 
449     /**
450      * @dev Called by a pauser to pause, triggers stopped state.
451      */
452     function pause() public onlyPauser whenNotPaused {
453         _paused = true;
454         emit Paused(msg.sender);
455     }
456 
457     /**
458      * @dev Called by a pauser to unpause, returns to normal state.
459      */
460     function unpause() public onlyPauser whenPaused {
461         _paused = false;
462         emit Unpaused(msg.sender);
463     }
464 }
465 
466 /**
467  * @title Pausable token
468  * @dev ERC20 modified with pausable transfers.
469  */
470 contract ERC20Pausable is ERC20, Pausable {
471     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
472         return super.transfer(to, value);
473     }
474 
475     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
476         return super.transferFrom(from, to, value);
477     }
478 
479     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
480         return super.approve(spender, value);
481     }
482 
483     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
484         return super.increaseAllowance(spender, addedValue);
485     }
486 
487     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
488         return super.decreaseAllowance(spender, subtractedValue);
489     }
490 }
491 
492 contract MinterRole {
493     using Roles for Roles.Role;
494 
495     event MinterAdded(address indexed account);
496     event MinterRemoved(address indexed account);
497 
498     Roles.Role private _minters;
499 
500     constructor () internal {
501         _addMinter(msg.sender);
502     }
503 
504     modifier onlyMinter() {
505         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
506         _;
507     }
508 
509     function isMinter(address account) public view returns (bool) {
510         return _minters.has(account);
511     }
512 
513     function addMinter(address account) public onlyMinter {
514         _addMinter(account);
515     }
516 
517     function renounceMinter() public {
518         _removeMinter(msg.sender);
519     }
520 
521     function _addMinter(address account) internal {
522         _minters.add(account);
523         emit MinterAdded(account);
524     }
525 
526     function _removeMinter(address account) internal {
527         _minters.remove(account);
528         emit MinterRemoved(account);
529     }
530 }
531 
532 /**
533  * @title ERC20Mintable
534  * @dev ERC20 minting logic.
535  */
536 contract ERC20Mintable is ERC20, MinterRole {
537     /**
538      * @dev Function to mint tokens
539      * @param to The address that will receive the minted tokens.
540      * @param value The amount of tokens to mint.
541      * @return A boolean that indicates if the operation was successful.
542      */
543     function mint(address to, uint256 value) public onlyMinter returns (bool) {
544         _mint(to, value);
545         return true;
546     }
547 }
548 
549 /**
550  * Utility library of inline functions on addresses
551  */
552 library Address {
553     /**
554      * Returns whether the target address is a contract
555      * @dev This function will return false if invoked during the constructor of a contract,
556      * as the code is not actually created until after the constructor finishes.
557      * @param account address of the account to check
558      * @return whether the target address is a contract
559      */
560     function isContract(address account) internal view returns (bool) {
561         uint256 size;
562         // XXX Currently there is no better way to check if there is a contract in an address
563         // than to check the size of the code at that address.
564         // See https://ethereum.stackexchange.com/a/14016/36603
565         // for more details about how this works.
566         // TODO Check this again before the Serenity release, because all addresses will be
567         // contracts then.
568         // solhint-disable-next-line no-inline-assembly
569         assembly { size := extcodesize(account) }
570         return size > 0;
571     }
572 }
573 
574 /**
575  * @title SafeERC20
576  * @dev Wrappers around ERC20 operations that throw on failure (when the token
577  * contract returns false). Tokens that return no value (and instead revert or
578  * throw on failure) are also supported, non-reverting calls are assumed to be
579  * successful.
580  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
581  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
582  */
583 library SafeERC20 {
584     using SafeMath for uint256;
585     using Address for address;
586 
587     function safeTransfer(IERC20 token, address to, uint256 value) internal {
588         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
589     }
590 
591     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
592         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
593     }
594 
595     function safeApprove(IERC20 token, address spender, uint256 value) internal {
596         // safeApprove should only be called when setting an initial allowance,
597         // or when resetting it to zero. To increase and decrease it, use
598         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
599         // solhint-disable-next-line max-line-length
600         require((value == 0) || (token.allowance(address(this), spender) == 0),
601             "SafeERC20: approve from non-zero to non-zero allowance"
602         );
603         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
604     }
605 
606     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
607         uint256 newAllowance = token.allowance(address(this), spender).add(value);
608         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
609     }
610 
611     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
612         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
613         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
614     }
615 
616     /**
617      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
618      * on the return value: the return value is optional (but if data is returned, it must not be false).
619      * @param token The token targeted by the call.
620      * @param data The call data (encoded using abi.encode or one of its variants).
621      */
622     function callOptionalReturn(IERC20 token, bytes memory data) private {
623         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
624         // we're implementing it ourselves.
625 
626         // A Solidity high level call has three parts:
627         //  1. The target address is checked to verify it contains contract code
628         //  2. The call itself is made, and success asserted
629         //  3. The return value is decoded, which in turn checks the size of the returned data.
630         // solhint-disable-next-line max-line-length
631         require(address(token).isContract(), "SafeERC20: call to non-contract");
632 
633         // solhint-disable-next-line avoid-low-level-calls
634         (bool success, bytes memory returndata) = address(token).call(data);
635         require(success, "SafeERC20: low-level call failed");
636 
637         if (returndata.length > 0) { // Return data is optional
638             // solhint-disable-next-line max-line-length
639             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
640         }
641     }
642 }
643 
644 /**
645  * @title TokenTimelock
646  * @dev TokenTimelock is a token holder contract that will allow a
647  * beneficiary to extract the tokens after a given release time.
648  */
649 contract TokenTimelock {
650     using SafeERC20 for IERC20;
651 
652     // ERC20 basic token contract being held
653     IERC20 private _token;
654 
655     // beneficiary of tokens after they are released
656     address private _beneficiary;
657 
658     // timestamp when token release is enabled
659     uint256 private _releaseTime;
660 
661     constructor (IERC20 token, address beneficiary, uint256 releaseTime) public {
662         // solhint-disable-next-line not-rely-on-time
663         require(releaseTime > block.timestamp, "TokenTimelock: release time is before current time");
664         _token = token;
665         _beneficiary = beneficiary;
666         _releaseTime = releaseTime;
667     }
668 
669     /**
670      * @return the token being held.
671      */
672     function token() public view returns (IERC20) {
673         return _token;
674     }
675 
676     /**
677      * @return the beneficiary of the tokens.
678      */
679     function beneficiary() public view returns (address) {
680         return _beneficiary;
681     }
682 
683     /**
684      * @return the time when the tokens are released.
685      */
686     function releaseTime() public view returns (uint256) {
687         return _releaseTime;
688     }
689 
690     /**
691      * @notice Transfers tokens held by timelock to beneficiary.
692      */
693     function release() public {
694         // solhint-disable-next-line not-rely-on-time
695         require(block.timestamp >= _releaseTime, "TokenTimelock: current time is before release time");
696 
697         uint256 amount = _token.balanceOf(address(this));
698         require(amount > 0, "TokenTimelock: no tokens to release");
699 
700         _token.safeTransfer(_beneficiary, amount);
701     }
702 }
703 
704 /**
705  * @title SimpleToken
706  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
707  * Note they can later distribute these tokens as they wish using `transfer` and other
708  * `ERC20` functions.
709  */
710 contract SimpleToken is ERC20, ERC20Detailed, ERC20Burnable, ERC20Pausable, ERC20Mintable {
711     uint8 public constant DECIMALS = 18;
712     uint256 public constant INITIAL_SUPPLY = 100000000000 * (10 ** uint256(DECIMALS));
713 
714     /**
715      * @dev Constructor that gives msg.sender all of existing tokens.
716      */
717     constructor () public ERC20Detailed("CoinState", "CNT", DECIMALS) {
718         _mint(msg.sender, INITIAL_SUPPLY);
719     }
720 }