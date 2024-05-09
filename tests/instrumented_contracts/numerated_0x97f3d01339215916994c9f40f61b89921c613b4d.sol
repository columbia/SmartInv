1 /*
2    _____ ___________________   ___ ___   ____________________ ___________________________  _________  ________  .____     
3   /  _  \\______   \_   ___ \ /   |   \  \______   \______   \\_____  \__    ___/\_____  \ \_   ___ \ \_____  \ |    |    
4  /  /_\  \|       _/    \  \//    ~    \  |     ___/|       _/ /   |   \|    |    /   |   \/    \  \/  /   |   \|    |    
5 /    |    \    |   \     \___\    Y    /  |    |    |    |   \/    |    \    |   /    |    \     \____/    |    \    |___ 
6 \____|__  /____|_  /\______  /\___|_  /   |____|    |____|_  /\_______  /____|   \_______  /\______  /\_______  /_______ \
7         \/       \/        \/       \/                     \/         \/                 \/        \/         \/        \/
8 
9 */
10 
11 // File: @openzeppelin/contracts/GSN/Context.sol
12 
13 pragma solidity ^0.5.0;
14 
15 /*
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with GSN meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 contract Context {
26     // Empty internal constructor, to prevent people from mistakenly deploying
27     // an instance of this contract, which should be used via inheritance.
28     constructor () internal { }
29     // solhint-disable-previous-line no-empty-blocks
30 
31     function _msgSender() internal view returns (address payable) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view returns (bytes memory) {
36         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
37         return msg.data;
38     }
39 }
40 
41 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
42 
43 pragma solidity ^0.5.0;
44 
45 /**
46  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
47  * the optional functions; to access them see {ERC20Detailed}.
48  */
49 interface IERC20 {
50     /**
51      * @dev Returns the amount of tokens in existence.
52      */
53     function totalSupply() external view returns (uint256);
54 
55     /**
56      * @dev Returns the amount of tokens owned by `account`.
57      */
58     function balanceOf(address account) external view returns (uint256);
59 
60     /**
61      * @dev Moves `amount` tokens from the caller's account to `recipient`.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Returns the remaining number of tokens that `spender` will be
71      * allowed to spend on behalf of `owner` through {transferFrom}. This is
72      * zero by default.
73      *
74      * This value changes when {approve} or {transferFrom} are called.
75      */
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     /**
79      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * IMPORTANT: Beware that changing an allowance with this method brings the risk
84      * that someone may use both the old and the new allowance by unfortunate
85      * transaction ordering. One possible solution to mitigate this race
86      * condition is to first reduce the spender's allowance to 0 and set the
87      * desired value afterwards:
88      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89      *
90      * Emits an {Approval} event.
91      */
92     function approve(address spender, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Moves `amount` tokens from `sender` to `recipient` using the
96      * allowance mechanism. `amount` is then deducted from the caller's
97      * allowance.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Emitted when `value` tokens are moved from one account (`from`) to
107      * another (`to`).
108      *
109      * Note that `value` may be zero.
110      */
111     event Transfer(address indexed from, address indexed to, uint256 value);
112 
113     /**
114      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
115      * a call to {approve}. `value` is the new allowance.
116      */
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: @openzeppelin/contracts/math/SafeMath.sol
121 
122 pragma solidity ^0.5.0;
123 
124 /**
125  * @dev Wrappers over Solidity's arithmetic operations with added overflow
126  * checks.
127  *
128  * Arithmetic operations in Solidity wrap on overflow. This can easily result
129  * in bugs, because programmers usually assume that an overflow raises an
130  * error, which is the standard behavior in high level programming languages.
131  * `SafeMath` restores this intuition by reverting the transaction when an
132  * operation overflows.
133  *
134  * Using this library instead of the unchecked operations eliminates an entire
135  * class of bugs, so it's recommended to use it always.
136  */
137 library SafeMath {
138     /**
139      * @dev Returns the addition of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `+` operator.
143      *
144      * Requirements:
145      * - Addition cannot overflow.
146      */
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         uint256 c = a + b;
149         require(c >= a, "SafeMath: addition overflow");
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         return sub(a, b, "SafeMath: subtraction overflow");
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * Counterpart to Solidity's `-` operator.
172      *
173      * Requirements:
174      * - Subtraction cannot overflow.
175      *
176      * _Available since v2.4.0._
177      */
178     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b <= a, errorMessage);
180         uint256 c = a - b;
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the multiplication of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `*` operator.
190      *
191      * Requirements:
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196         // benefit is lost if 'b' is also tested.
197         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
198         if (a == 0) {
199             return 0;
200         }
201 
202         uint256 c = a * b;
203         require(c / a == b, "SafeMath: multiplication overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b) internal pure returns (uint256) {
220         return div(a, b, "SafeMath: division by zero");
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator. Note: this function uses a
228      * `revert` opcode (which leaves remaining gas untouched) while Solidity
229      * uses an invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      * - The divisor cannot be zero.
233      *
234      * _Available since v2.4.0._
235      */
236     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         // Solidity only automatically asserts when dividing by 0
238         require(b > 0, errorMessage);
239         uint256 c = a / b;
240         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         return mod(a, b, "SafeMath: modulo by zero");
258     }
259 
260     /**
261      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
262      * Reverts with custom message when dividing by zero.
263      *
264      * Counterpart to Solidity's `%` operator. This function uses a `revert`
265      * opcode (which leaves remaining gas untouched) while Solidity uses an
266      * invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      * - The divisor cannot be zero.
270      *
271      * _Available since v2.4.0._
272      */
273     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b != 0, errorMessage);
275         return a % b;
276     }
277 }
278 
279 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
280 
281 pragma solidity ^0.5.0;
282 
283 /**
284  * @dev Implementation of the {IERC20} interface.
285  *
286  * This implementation is agnostic to the way tokens are created. This means
287  * that a supply mechanism has to be added in a derived contract using {_mint}.
288  * For a generic mechanism see {ERC20Mintable}.
289  *
290  * TIP: For a detailed writeup see our guide
291  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
292  * to implement supply mechanisms].
293  *
294  * We have followed general OpenZeppelin guidelines: functions revert instead
295  * of returning `false` on failure. This behavior is nonetheless conventional
296  * and does not conflict with the expectations of ERC20 applications.
297  *
298  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
299  * This allows applications to reconstruct the allowance for all accounts just
300  * by listening to said events. Other implementations of the EIP may not emit
301  * these events, as it isn't required by the specification.
302  *
303  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
304  * functions have been added to mitigate the well-known issues around setting
305  * allowances. See {IERC20-approve}.
306  */
307 contract ERC20 is Context, IERC20 {
308     using SafeMath for uint256;
309 
310     mapping (address => uint256) private _balances;
311 
312     mapping (address => mapping (address => uint256)) private _allowances;
313 
314     uint256 private _totalSupply;
315     constructor (uint256 totalSupply) public {
316         _mint(_msgSender(),totalSupply);
317     }
318     /**
319      * @dev See {IERC20-totalSupply}.
320      */
321     function totalSupply() public view returns (uint256) {
322         return _totalSupply;
323     }
324 
325     /**
326      * @dev See {IERC20-balanceOf}.
327      */
328     function balanceOf(address account) public view returns (uint256) {
329         return _balances[account];
330     }
331 
332     /**
333      * @dev See {IERC20-transfer}.
334      *
335      * Requirements:
336      *
337      * - `recipient` cannot be the zero address.
338      * - the caller must have a balance of at least `amount`.
339      */
340     function transfer(address recipient, uint256 amount) public returns (bool) {
341         _transfer(_msgSender(), recipient, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-allowance}.
347      */
348     function allowance(address owner, address spender) public view returns (uint256) {
349         return _allowances[owner][spender];
350     }
351 
352     /**
353      * @dev See {IERC20-approve}.
354      *
355      * Requirements:
356      *
357      * - `spender` cannot be the zero address.
358      */
359     function approve(address spender, uint256 amount) public returns (bool) {
360         _approve(_msgSender(), spender, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-transferFrom}.
366      *
367      * Emits an {Approval} event indicating the updated allowance. This is not
368      * required by the EIP. See the note at the beginning of {ERC20};
369      *
370      * Requirements:
371      * - `sender` and `recipient` cannot be the zero address.
372      * - `sender` must have a balance of at least `amount`.
373      * - the caller must have allowance for `sender`'s tokens of at least
374      * `amount`.
375      */
376     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
377         _transfer(sender, recipient, amount);
378         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
379         return true;
380     }
381 
382     /**
383      * @dev Atomically increases the allowance granted to `spender` by the caller.
384      *
385      * This is an alternative to {approve} that can be used as a mitigation for
386      * problems described in {IERC20-approve}.
387      *
388      * Emits an {Approval} event indicating the updated allowance.
389      *
390      * Requirements:
391      *
392      * - `spender` cannot be the zero address.
393      */
394     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
395         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
396         return true;
397     }
398 
399     /**
400      * @dev Atomically decreases the allowance granted to `spender` by the caller.
401      *
402      * This is an alternative to {approve} that can be used as a mitigation for
403      * problems described in {IERC20-approve}.
404      *
405      * Emits an {Approval} event indicating the updated allowance.
406      *
407      * Requirements:
408      *
409      * - `spender` cannot be the zero address.
410      * - `spender` must have allowance for the caller of at least
411      * `subtractedValue`.
412      */
413     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
414         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
415         return true;
416     }
417 
418     /**
419      * @dev Moves tokens `amount` from `sender` to `recipient`.
420      *
421      * This is internal function is equivalent to {transfer}, and can be used to
422      * e.g. implement automatic token fees, slashing mechanisms, etc.
423      *
424      * Emits a {Transfer} event.
425      *
426      * Requirements:
427      *
428      * - `sender` cannot be the zero address.
429      * - `recipient` cannot be the zero address.
430      * - `sender` must have a balance of at least `amount`.
431      */
432     function _transfer(address sender, address recipient, uint256 amount) internal {
433         require(sender != address(0), "ERC20: transfer from the zero address");
434         require(recipient != address(0), "ERC20: transfer to the zero address");
435 
436         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
437         _balances[recipient] = _balances[recipient].add(amount);
438         emit Transfer(sender, recipient, amount);
439     }
440 
441     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
442      * the total supply.
443      *
444      * Emits a {Transfer} event with `from` set to the zero address.
445      *
446      * Requirements
447      *
448      * - `to` cannot be the zero address.
449      */
450     function _mint(address account, uint256 amount) internal {
451         require(account != address(0), "ERC20: mint to the zero address");
452 
453         _totalSupply = _totalSupply.add(amount);
454         _balances[account] = _balances[account].add(amount);
455         emit Transfer(address(0), account, amount);
456     }
457 
458     /**
459      * @dev Destroys `amount` tokens from `account`, reducing the
460      * total supply.
461      *
462      * Emits a {Transfer} event with `to` set to the zero address.
463      *
464      * Requirements
465      *
466      * - `account` cannot be the zero address.
467      * - `account` must have at least `amount` tokens.
468      */
469     function _burn(address account, uint256 amount) internal {
470         require(account != address(0), "ERC20: burn from the zero address");
471 
472         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
473         _totalSupply = _totalSupply.sub(amount);
474         emit Transfer(account, address(0), amount);
475     }
476 
477     /**
478      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
479      *
480      * This is internal function is equivalent to `approve`, and can be used to
481      * e.g. set automatic allowances for certain subsystems, etc.
482      *
483      * Emits an {Approval} event.
484      *
485      * Requirements:
486      *
487      * - `owner` cannot be the zero address.
488      * - `spender` cannot be the zero address.
489      */
490     function _approve(address owner, address spender, uint256 amount) internal {
491         require(owner != address(0), "ERC20: approve from the zero address");
492         require(spender != address(0), "ERC20: approve to the zero address");
493 
494         _allowances[owner][spender] = amount;
495         emit Approval(owner, spender, amount);
496     }
497 
498     /**
499      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
500      * from the caller's allowance.
501      *
502      * See {_burn} and {_approve}.
503      */
504     function _burnFrom(address account, uint256 amount) internal {
505         _burn(account, amount);
506         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
507     }
508 }
509 
510 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
511 
512 pragma solidity ^0.5.0;
513 
514 /**
515  * @dev Extension of {ERC20} that allows token holders to destroy both their own
516  * tokens and those that they have an allowance for, in a way that can be
517  * recognized off-chain (via event analysis).
518  */
519 contract ERC20Burnable is Context, ERC20 {
520     /**
521      * @dev Destroys `amount` tokens from the caller.
522      *
523      * See {ERC20-_burn}.
524      */
525     function burn(uint256 amount) public {
526         _burn(_msgSender(), amount);
527     }
528 
529     /**
530      * @dev See {ERC20-_burnFrom}.
531      */
532     function burnFrom(address account, uint256 amount) public {
533         _burnFrom(account, amount);
534     }
535 }
536 
537 // File: @openzeppelin/contracts/access/Roles.sol
538 
539 pragma solidity ^0.5.0;
540 
541 /**
542  * @title Roles
543  * @dev Library for managing addresses assigned to a Role.
544  */
545 library Roles {
546     struct Role {
547         mapping (address => bool) bearer;
548     }
549 
550     /**
551      * @dev Give an account access to this role.
552      */
553     function add(Role storage role, address account) internal {
554         require(!has(role, account), "Roles: account already has role");
555         role.bearer[account] = true;
556     }
557 
558     /**
559      * @dev Remove an account's access to this role.
560      */
561     function remove(Role storage role, address account) internal {
562         require(has(role, account), "Roles: account does not have role");
563         role.bearer[account] = false;
564     }
565 
566     /**
567      * @dev Check if an account has this role.
568      * @return bool
569      */
570     function has(Role storage role, address account) internal view returns (bool) {
571         require(account != address(0), "Roles: account is the zero address");
572         return role.bearer[account];
573     }
574 }
575 
576 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
577 
578 pragma solidity ^0.5.0;
579 
580 /**
581  * @dev Optional functions from the ERC20 standard.
582  */
583 contract ERC20Detailed is IERC20 {
584     string private _name;
585     string private _symbol;
586     uint8 private _decimals;
587 
588     /**
589      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
590      * these values are immutable: they can only be set once during
591      * construction.
592      */
593     constructor (string memory name, string memory symbol, uint8 decimals) public {
594         _name = name;
595         _symbol = symbol;
596         _decimals = decimals;
597     }
598 
599     /**
600      * @dev Returns the name of the token.
601      */
602     function name() public view returns (string memory) {
603         return _name;
604     }
605 
606     /**
607      * @dev Returns the symbol of the token, usually a shorter version of the
608      * name.
609      */
610     function symbol() public view returns (string memory) {
611         return _symbol;
612     }
613 
614     /**
615      * @dev Returns the number of decimals used to get its user representation.
616      * For example, if `decimals` equals `2`, a balance of `505` tokens should
617      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
618      *
619      * Tokens usually opt for a value of 18, imitating the relationship between
620      * Ether and Wei.
621      *
622      * NOTE: This information is only used for _display_ purposes: it in
623      * no way affects any of the arithmetic of the contract, including
624      * {IERC20-balanceOf} and {IERC20-transfer}.
625      */
626     function decimals() public view returns (uint8) {
627         return _decimals;
628     }
629 }
630 
631 // File: @openzeppelin/contracts/access/roles/WhitelistAdminRole.sol
632 
633 pragma solidity ^0.5.0;
634 
635 /**
636  * @title WhitelistAdminRole
637  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
638  */
639 contract WhitelistAdminRole is Context {
640     using Roles for Roles.Role;
641 
642     event WhitelistAdminAdded(address indexed account);
643     event WhitelistAdminRemoved(address indexed account);
644 
645     Roles.Role private _whitelistAdmins;
646 
647     constructor () internal {
648         _addWhitelistAdmin(_msgSender());
649     }
650 
651     modifier onlyWhitelistAdmin() {
652         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
653         _;
654     }
655 
656     function isWhitelistAdmin(address account) public view returns (bool) {
657         return _whitelistAdmins.has(account);
658     }
659 
660     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
661         _addWhitelistAdmin(account);
662     }
663 
664     function renounceWhitelistAdmin() public {
665         _removeWhitelistAdmin(_msgSender());
666     }
667 
668     function _addWhitelistAdmin(address account) internal {
669         _whitelistAdmins.add(account);
670         emit WhitelistAdminAdded(account);
671     }
672 
673     function _removeWhitelistAdmin(address account) internal {
674         _whitelistAdmins.remove(account);
675         emit WhitelistAdminRemoved(account);
676     }
677 }
678 
679 // File: contracts/ERC20/ERC20TransferLiquidityLock.sol
680 
681 pragma solidity ^0.5.17;
682 
683 contract ERC20TransferLiquidityLock is ERC20 {
684     using SafeMath for uint256;
685 
686 
687     event Rectitude(uint256 tokenBurnt);
688     event SupplyMasonSwap(uint256 tokenAmount);
689     event RewardLiquidityProviders(uint256 liquidityRewards);
690     
691     address public uniswapV2Router;
692     address public uniswapV2Pair;
693     address public MasonSwap;
694     address payable public treasury;
695     mapping(address => bool) feelessAddr;
696     mapping(address => bool) unlocked;
697     
698     // the amount of tokens to lock for liquidity during every transfer, i.e. 100 = 1%, 50 = 2%, 40 = 2.5%
699     uint256 public liquidityLockDivisor;
700     uint256 public callerRewardDivisor;
701     uint256 public rectitudeDivisor;
702     
703     uint256 public minRectitudeAmount;
704     uint256 public lastRectitude;
705     uint256 public rectitudeInterval;
706     
707     uint256 public lpUnlocked;
708     bool public locked;
709     
710     Balancer balancer;
711     
712     constructor() public {
713         lastRectitude = block.timestamp;
714         liquidityLockDivisor = 77;
715         callerRewardDivisor = 33;
716         rectitudeDivisor = 33;
717         rectitudeInterval = 2 hours; 
718         lpUnlocked = block.timestamp + 90 days;
719         minRectitudeAmount = 64 ether; 
720         treasury = msg.sender;
721         balancer = new Balancer(treasury);
722         feelessAddr[address(this)] = true;
723         feelessAddr[address(balancer)] = true;
724         locked = true;
725         unlocked[msg.sender] = true;
726         unlocked[address(balancer)] = true;
727     }
728     
729     //sav3 transfer function
730     function _transfer(address from, address to, uint256 amount) internal {
731         // calculate liquidity lock amount
732         // dont transfer burn from this contract
733         // or can never lock full lockable amount
734         if(locked && unlocked[from] != true && unlocked[to] != true)
735             revert("Locked until end of presale");
736             
737         if (liquidityLockDivisor != 0 && feelessAddr[from] == false && feelessAddr[to] == false) {
738             uint256 liquidityLockAmount = amount.div(liquidityLockDivisor);
739             super._transfer(from, address(this), liquidityLockAmount);
740             super._transfer(from, to, amount.sub(liquidityLockAmount));
741         }
742         else {
743             super._transfer(from, to, amount);
744         }
745     }
746 
747     // receive eth from uniswap swap
748     function () external payable {}
749 
750     function rectitudeLiquidity() public {
751         require(balanceOf(msg.sender) >= minRectitudeAmount, "Apprentices can not call the Rectitude function. Only Fellow Craftsman and Masters.");
752         require(block.timestamp > lastRectitude + rectitudeInterval, 'Per patientiam expectamus...');
753         lastRectitude = block.timestamp;
754         // lockable supply is the token balance of this contract
755         uint256 _lockableSupply = balanceOf(address(this));
756         _rewardLiquidityProviders(_lockableSupply);
757         
758         uint256 amountToRemove = ERC20(uniswapV2Pair).balanceOf(address(this)).div(rectitudeDivisor);
759         // needed in case contract already owns eth
760         
761         remLiquidity(amountToRemove);
762         uint _locked = balancer.rectitude(callerRewardDivisor);
763 
764         emit Rectitude(_locked);
765     }
766 
767     function _rewardLiquidityProviders(uint256 liquidityRewards) private {
768         if(MasonSwap != address(0)) {
769             super._transfer(address(this), MasonSwap, liquidityRewards);
770             IUniswapV2Pair(MasonSwap).sync();
771             emit SupplyMasonSwap(liquidityRewards);
772         }
773         else {
774             super._transfer(address(this), uniswapV2Pair, liquidityRewards);
775             IUniswapV2Pair(uniswapV2Pair).sync();
776             emit RewardLiquidityProviders(liquidityRewards);
777         }
778     }
779 
780     function remLiquidity(uint256 lpAmount) private returns(uint ETHAmount) {
781         ERC20(uniswapV2Pair).approve(uniswapV2Router, lpAmount);
782         (ETHAmount) = IUniswapV2Router02(uniswapV2Router)
783             .removeLiquidityETHSupportingFeeOnTransferTokens(
784                 address(this),
785                 lpAmount,
786                 0,
787                 0,
788                 address(balancer),
789                 block.timestamp
790             );
791     }
792 
793     // returns token amount
794     function lockableSupply() external view returns (uint256) {
795         return balanceOf(address(this));
796     }
797 
798     // returns token amount
799     function lockedSupply() external view returns (uint256) {
800         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
801         uint256 lpBalance = lockedLiquidity();
802         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
803 
804         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
805         uint256 _lockedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
806         return _lockedSupply;
807     }
808 
809     // returns token amount
810     function burnedSupply() external view returns (uint256) {
811         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
812         uint256 lpBalance = burnedLiquidity();
813         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
814 
815         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
816         uint256 _burnedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
817         return _burnedSupply;
818     }
819 
820     // returns LP amount, not token amount
821     function burnableLiquidity() public view returns (uint256) {
822         return ERC20(uniswapV2Pair).balanceOf(address(this));
823     }
824 
825     // returns LP amount, not token amount
826     function burnedLiquidity() public view returns (uint256) {
827         return ERC20(uniswapV2Pair).balanceOf(address(0));
828     }
829 
830     // returns LP amount, not token amount
831     function lockedLiquidity() public view returns (uint256) {
832         return burnableLiquidity().add(burnedLiquidity());
833     }
834 }
835 
836 interface IUniswapV2Router02 {
837     function WETH() external pure returns (address);
838     function swapExactETHForTokensSupportingFeeOnTransferTokens(
839       uint amountOutMin,
840       address[] calldata path,
841       address to,
842       uint deadline
843     ) external payable;
844     function removeLiquidityETH(
845       address token,
846       uint liquidity,
847       uint amountTokenMin,
848       uint amountETHMin,
849       address to,
850       uint deadline
851     ) external returns (uint amountToken, uint amountETH);
852     function removeLiquidityETHSupportingFeeOnTransferTokens(
853       address token,
854       uint liquidity,
855       uint amountTokenMin,
856       uint amountETHMin,
857       address to,
858       uint deadline
859     ) external returns (uint amountETH);    
860 }
861 
862 interface IUniswapV2Pair {
863     function sync() external;
864 }
865 
866 // File: contracts/ERC20/ERC20Governance.sol
867 
868 pragma solidity ^0.5.17;
869 
870 contract ERC20Governance is ERC20, ERC20Detailed {
871     using SafeMath for uint256;
872 
873     function _transfer(address from, address to, uint256 amount) internal {
874         _moveDelegates(_delegates[from], _delegates[to], amount);
875         super._transfer(from, to, amount);
876     }
877 
878     function _mint(address account, uint256 amount) internal {
879         _moveDelegates(address(0), _delegates[account], amount);
880         super._mint(account, amount);
881     }
882 
883     function _burn(address account, uint256 amount) internal {
884         _moveDelegates(_delegates[account], address(0), amount);
885         super._burn(account, amount);
886     }
887 
888     // Copied and modified from YAM code:
889     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
890     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
891     // Which is copied and modified from COMPOUND:
892     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
893 
894     /// @notice A record of each accounts delegate
895     mapping (address => address) internal _delegates;
896 
897     /// @notice A checkpoint for marking number of votes from a given block
898     struct Checkpoint {
899         uint32 fromBlock;
900         uint256 votes;
901     }
902 
903     /// @notice A record of votes checkpoints for each account, by index
904     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
905 
906     /// @notice The number of checkpoints for each account
907     mapping (address => uint32) public numCheckpoints;
908 
909     /// @notice The EIP-712 typehash for the contract's domain
910     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
911 
912     /// @notice The EIP-712 typehash for the delegation struct used by the contract
913     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
914 
915     /// @notice A record of states for signing / validating signatures
916     mapping (address => uint) public nonces;
917 
918       /// @notice An event thats emitted when an account changes its delegate
919     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
920 
921     /// @notice An event thats emitted when a delegate account's vote balance changes
922     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
923 
924     /**
925      * @notice Delegate votes from `msg.sender` to `delegatee`
926      * @param delegator The address to get delegatee for
927      */
928     function delegates(address delegator)
929         external
930         view
931         returns (address)
932     {
933         return _delegates[delegator];
934     }
935 
936    /**
937     * @notice Delegate votes from `msg.sender` to `delegatee`
938     * @param delegatee The address to delegate votes to
939     */
940     function delegate(address delegatee) external {
941         return _delegate(msg.sender, delegatee);
942     }
943 
944     /**
945      * @notice Delegates votes from signatory to `delegatee`
946      * @param delegatee The address to delegate votes to
947      * @param nonce The contract state required to match the signature
948      * @param expiry The time at which to expire the signature
949      * @param v The recovery byte of the signature
950      * @param r Half of the ECDSA signature pair
951      * @param s Half of the ECDSA signature pair
952      */
953     function delegateBySig(
954         address delegatee,
955         uint nonce,
956         uint expiry,
957         uint8 v,
958         bytes32 r,
959         bytes32 s
960     )
961         external
962     {
963         bytes32 domainSeparator = keccak256(
964             abi.encode(
965                 DOMAIN_TYPEHASH,
966                 keccak256(bytes(name())),
967                 getChainId(),
968                 address(this)
969             )
970         );
971 
972         bytes32 structHash = keccak256(
973             abi.encode(
974                 DELEGATION_TYPEHASH,
975                 delegatee,
976                 nonce,
977                 expiry
978             )
979         );
980 
981         bytes32 digest = keccak256(
982             abi.encodePacked(
983                 "\x19\x01",
984                 domainSeparator,
985                 structHash
986             )
987         );
988 
989         address signatory = ecrecover(digest, v, r, s);
990         require(signatory != address(0), "ERC20Governance::delegateBySig: invalid signature");
991         require(nonce == nonces[signatory]++, "ERC20Governance::delegateBySig: invalid nonce");
992         require(now <= expiry, "ERC20Governance::delegateBySig: signature expired");
993         return _delegate(signatory, delegatee);
994     }
995 
996     /**
997      * @notice Gets the current votes balance for `account`
998      * @param account The address to get votes balance
999      * @return The number of current votes for `account`
1000      */
1001     function getCurrentVotes(address account)
1002         external
1003         view
1004         returns (uint256)
1005     {
1006         uint32 nCheckpoints = numCheckpoints[account];
1007         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1008     }
1009 
1010     /**
1011      * @notice Determine the prior number of votes for an account as of a block number
1012      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1013      * @param account The address of the account to check
1014      * @param blockNumber The block number to get the vote balance at
1015      * @return The number of votes the account had as of the given block
1016      */
1017     function getPriorVotes(address account, uint blockNumber)
1018         external
1019         view
1020         returns (uint256)
1021     {
1022         require(blockNumber < block.number, "ERC20Governance::getPriorVotes: not yet determined");
1023 
1024         uint32 nCheckpoints = numCheckpoints[account];
1025         if (nCheckpoints == 0) {
1026             return 0;
1027         }
1028 
1029         // First check most recent balance
1030         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1031             return checkpoints[account][nCheckpoints - 1].votes;
1032         }
1033 
1034         // Next check implicit zero balance
1035         if (checkpoints[account][0].fromBlock > blockNumber) {
1036             return 0;
1037         }
1038 
1039         uint32 lower = 0;
1040         uint32 upper = nCheckpoints - 1;
1041         while (upper > lower) {
1042             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1043             Checkpoint memory cp = checkpoints[account][center];
1044             if (cp.fromBlock == blockNumber) {
1045                 return cp.votes;
1046             } else if (cp.fromBlock < blockNumber) {
1047                 lower = center;
1048             } else {
1049                 upper = center - 1;
1050             }
1051         }
1052         return checkpoints[account][lower].votes;
1053     }
1054 
1055     function _delegate(address delegator, address delegatee)
1056         internal
1057     {
1058         address currentDelegate = _delegates[delegator];
1059         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying ERC20Governances (not scaled);
1060         _delegates[delegator] = delegatee;
1061 
1062         emit DelegateChanged(delegator, currentDelegate, delegatee);
1063 
1064         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1065     }
1066 
1067     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1068         if (srcRep != dstRep && amount > 0) {
1069             if (srcRep != address(0)) {
1070                 // decrease old representative
1071                 uint32 srcRepNum = numCheckpoints[srcRep];
1072                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1073                 uint256 srcRepNew = srcRepOld.sub(amount);
1074                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1075             }
1076 
1077             if (dstRep != address(0)) {
1078                 // increase new representative
1079                 uint32 dstRepNum = numCheckpoints[dstRep];
1080                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1081                 uint256 dstRepNew = dstRepOld.add(amount);
1082                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1083             }
1084         }
1085     }
1086 
1087     function _writeCheckpoint(
1088         address delegatee,
1089         uint32 nCheckpoints,
1090         uint256 oldVotes,
1091         uint256 newVotes
1092     )
1093         internal
1094     {
1095         uint32 blockNumber = safe32(block.number, "ERC20Governance::_writeCheckpoint: block number exceeds 32 bits");
1096 
1097         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1098             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1099         } else {
1100             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1101             numCheckpoints[delegatee] = nCheckpoints + 1;
1102         }
1103 
1104         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1105     }
1106 
1107     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1108         require(n < 2**32, errorMessage);
1109         return uint32(n);
1110     }
1111 
1112     function getChainId() internal pure returns (uint) {
1113         uint256 chainId;
1114         assembly { chainId := chainid() }
1115         return chainId;
1116     }
1117 }
1118 
1119 pragma solidity ^0.5.17;
1120 
1121 contract Balancer {
1122     using SafeMath for uint256;    
1123     ArchProtocol token;
1124     address public burnAddr = 0x000000000000000000000000000000000000dEaD;
1125     address payable public treasury;
1126     
1127     constructor(address payable treasury_) public {
1128         token = ArchProtocol(msg.sender);
1129         treasury = treasury_;
1130     }
1131     function () external payable {}
1132     function rectitude(uint callerRewardDivisor) external returns (uint256) { 
1133         require(msg.sender == address(token), "only token");
1134         swapEthForTokens(address(this).balance, callerRewardDivisor);
1135         uint256 lockableBalance = token.balanceOf(address(this));
1136         uint256 callerReward = lockableBalance.div(callerRewardDivisor);
1137         token.transfer(tx.origin, callerReward);
1138         token.transfer(burnAddr, lockableBalance.sub(callerReward));        
1139         return lockableBalance.sub(callerReward);
1140     }
1141 
1142     function swapEthForTokens(uint256 EthAmount, uint callerRewardDivisor) private {
1143         address[] memory uniswapPairPath = new address[](2);
1144         uniswapPairPath[0] = IUniswapV2Router02(token.uniswapV2Router()).WETH();
1145         uniswapPairPath[1] = address(token);
1146         uint256 treasuryAmount = EthAmount.div(callerRewardDivisor);
1147         treasury.transfer(treasuryAmount);
1148         
1149         token.approve(token.uniswapV2Router(), EthAmount);
1150         
1151         IUniswapV2Router02(token.uniswapV2Router())
1152             .swapExactETHForTokensSupportingFeeOnTransferTokens.value(EthAmount.sub(treasuryAmount))(
1153                 0,
1154                 uniswapPairPath,
1155                 address(this),
1156                 block.timestamp
1157             );
1158     }    
1159 }
1160 
1161 contract ArchProtocol is 
1162     ERC20(32000 ether), 
1163     ERC20Detailed("ArchProtocol", "ARCH", 18), 
1164     ERC20Burnable, 
1165     // governance must be before transfer liquidity lock
1166     // or delegates are not updated correctly
1167     ERC20Governance,
1168     ERC20TransferLiquidityLock,
1169     WhitelistAdminRole 
1170 {
1171     function setUniswapV2Router(address _uniswapV2Router) public onlyWhitelistAdmin {
1172         require(uniswapV2Router == address(0), "ARCHToken::setUniswapV2Router: already set");
1173         uniswapV2Router = _uniswapV2Router;
1174     }
1175 
1176     function setUniswapV2Pair(address _uniswapV2Pair) public onlyWhitelistAdmin {
1177         require(uniswapV2Pair == address(0), "ARCHToken::setUniswapV2Pair: already set");
1178         uniswapV2Pair = _uniswapV2Pair;
1179     }
1180 
1181     function setLiquidityLockDivisor(uint256 _liquidityLockDivisor) public onlyWhitelistAdmin {
1182         if (_liquidityLockDivisor != 0) {
1183             require(_liquidityLockDivisor >= 10, "ARCHToken::setLiquidityLockDivisor: too small");
1184         }
1185         liquidityLockDivisor = _liquidityLockDivisor;
1186     }
1187 
1188     function setRectitudeDivisor(uint256 _rectitudeDivisor) public onlyWhitelistAdmin {
1189         if (_rectitudeDivisor != 0) {
1190             require(_rectitudeDivisor >= 10, "ARCHToken::setRectitudeDivisor: too small");
1191         }        
1192         rectitudeDivisor = _rectitudeDivisor;
1193     }
1194     
1195     function setMasonSwap(address _mason) public onlyWhitelistAdmin {
1196         MasonSwap = _mason;
1197     }
1198     
1199     function setRectitudeInterval(uint256 _interval) public onlyWhitelistAdmin {
1200         rectitudeInterval = _interval;
1201     }
1202     
1203     function setCallerRewardDivisior(uint256 _rewardDivisor) public onlyWhitelistAdmin {
1204         if (_rewardDivisor != 0) {
1205             require(_rewardDivisor >= 10, "ARCHToken::setCallerRewardDivisor: too small");
1206         }        
1207         callerRewardDivisor = _rewardDivisor;
1208     }
1209     
1210     function unlockLP() public onlyWhitelistAdmin {
1211         require(now > lpUnlocked, "Not unlocked yet");
1212         uint256 amount = IERC20(uniswapV2Pair).balanceOf(address(this));
1213         IERC20(uniswapV2Pair).transfer(msg.sender, amount);
1214     }
1215     
1216     function toggleFeeless(address _addr) public onlyWhitelistAdmin {
1217         feelessAddr[_addr] = !feelessAddr[_addr];
1218     }
1219     function toggleUnlockable(address _addr) public onlyWhitelistAdmin {
1220         unlocked[_addr] = !unlocked[_addr];
1221     }    
1222     function unlock() public onlyWhitelistAdmin {
1223         locked = false;
1224     }    
1225 
1226     function setMinRectitudeAmount(uint256 amount_) public onlyWhitelistAdmin {
1227         minRectitudeAmount = amount_;
1228     }
1229 }