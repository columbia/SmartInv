1 /*
2    SAV3  Fork
3 */
4 
5 // File: @openzeppelin/contracts/GSN/Context.sol
6 
7 pragma solidity ^0.5.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 contract Context {
20     // Empty internal constructor, to prevent people from mistakenly deploying
21     // an instance of this contract, which should be used via inheritance.
22     constructor () internal { }
23     // solhint-disable-previous-line no-empty-blocks
24 
25     function _msgSender() internal view returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
36 
37 pragma solidity ^0.5.0;
38 
39 /**
40  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
41  * the optional functions; to access them see {ERC20Detailed}.
42  */
43 interface IERC20 {
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 // File: @openzeppelin/contracts/math/SafeMath.sol
115 
116 pragma solidity ^0.5.0;
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      * - Addition cannot overflow.
140      */
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a, "SafeMath: addition overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      * - Subtraction cannot overflow.
169      *
170      * _Available since v2.4.0._
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return div(a, b, "SafeMath: division by zero");
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      * - The divisor cannot be zero.
227      *
228      * _Available since v2.4.0._
229      */
230     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         // Solidity only automatically asserts when dividing by 0
232         require(b > 0, errorMessage);
233         uint256 c = a / b;
234         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         return mod(a, b, "SafeMath: modulo by zero");
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts with custom message when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      * - The divisor cannot be zero.
264      *
265      * _Available since v2.4.0._
266      */
267     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b != 0, errorMessage);
269         return a % b;
270     }
271 }
272 
273 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
274 
275 pragma solidity ^0.5.0;
276 
277 /**
278  * @dev Implementation of the {IERC20} interface.
279  *
280  * This implementation is agnostic to the way tokens are created. This means
281  * that a supply mechanism has to be added in a derived contract using {_mint}.
282  * For a generic mechanism see {ERC20Mintable}.
283  *
284  * TIP: For a detailed writeup see our guide
285  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
286  * to implement supply mechanisms].
287  *
288  * We have followed general OpenZeppelin guidelines: functions revert instead
289  * of returning `false` on failure. This behavior is nonetheless conventional
290  * and does not conflict with the expectations of ERC20 applications.
291  *
292  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
293  * This allows applications to reconstruct the allowance for all accounts just
294  * by listening to said events. Other implementations of the EIP may not emit
295  * these events, as it isn't required by the specification.
296  *
297  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
298  * functions have been added to mitigate the well-known issues around setting
299  * allowances. See {IERC20-approve}.
300  */
301 contract ERC20 is Context, IERC20 {
302     using SafeMath for uint256;
303 
304     mapping (address => uint256) private _balances;
305 
306     mapping (address => mapping (address => uint256)) private _allowances;
307 
308     uint256 private _totalSupply;
309     constructor (uint256 totalSupply) public {
310         _mint(_msgSender(),totalSupply);
311     }
312     /**
313      * @dev See {IERC20-totalSupply}.
314      */
315     function totalSupply() public view returns (uint256) {
316         return _totalSupply;
317     }
318 
319     /**
320      * @dev See {IERC20-balanceOf}.
321      */
322     function balanceOf(address account) public view returns (uint256) {
323         return _balances[account];
324     }
325 
326     /**
327      * @dev See {IERC20-transfer}.
328      *
329      * Requirements:
330      *
331      * - `recipient` cannot be the zero address.
332      * - the caller must have a balance of at least `amount`.
333      */
334     function transfer(address recipient, uint256 amount) public returns (bool) {
335         _transfer(_msgSender(), recipient, amount);
336         return true;
337     }
338 
339     /**
340      * @dev See {IERC20-allowance}.
341      */
342     function allowance(address owner, address spender) public view returns (uint256) {
343         return _allowances[owner][spender];
344     }
345 
346     /**
347      * @dev See {IERC20-approve}.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      */
353     function approve(address spender, uint256 amount) public returns (bool) {
354         _approve(_msgSender(), spender, amount);
355         return true;
356     }
357 
358     /**
359      * @dev See {IERC20-transferFrom}.
360      *
361      * Emits an {Approval} event indicating the updated allowance. This is not
362      * required by the EIP. See the note at the beginning of {ERC20};
363      *
364      * Requirements:
365      * - `sender` and `recipient` cannot be the zero address.
366      * - `sender` must have a balance of at least `amount`.
367      * - the caller must have allowance for `sender`'s tokens of at least
368      * `amount`.
369      */
370     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
371         _transfer(sender, recipient, amount);
372         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
373         return true;
374     }
375 
376     /**
377      * @dev Atomically increases the allowance granted to `spender` by the caller.
378      *
379      * This is an alternative to {approve} that can be used as a mitigation for
380      * problems described in {IERC20-approve}.
381      *
382      * Emits an {Approval} event indicating the updated allowance.
383      *
384      * Requirements:
385      *
386      * - `spender` cannot be the zero address.
387      */
388     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
389         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
390         return true;
391     }
392 
393     /**
394      * @dev Atomically decreases the allowance granted to `spender` by the caller.
395      *
396      * This is an alternative to {approve} that can be used as a mitigation for
397      * problems described in {IERC20-approve}.
398      *
399      * Emits an {Approval} event indicating the updated allowance.
400      *
401      * Requirements:
402      *
403      * - `spender` cannot be the zero address.
404      * - `spender` must have allowance for the caller of at least
405      * `subtractedValue`.
406      */
407     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
408         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
409         return true;
410     }
411 
412     /**
413      * @dev Moves tokens `amount` from `sender` to `recipient`.
414      *
415      * This is internal function is equivalent to {transfer}, and can be used to
416      * e.g. implement automatic token fees, slashing mechanisms, etc.
417      *
418      * Emits a {Transfer} event.
419      *
420      * Requirements:
421      *
422      * - `sender` cannot be the zero address.
423      * - `recipient` cannot be the zero address.
424      * - `sender` must have a balance of at least `amount`.
425      */
426     function _transfer(address sender, address recipient, uint256 amount) internal {
427         require(sender != address(0), "ERC20: transfer from the zero address");
428         require(recipient != address(0), "ERC20: transfer to the zero address");
429 
430         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
431         _balances[recipient] = _balances[recipient].add(amount);
432         emit Transfer(sender, recipient, amount);
433     }
434 
435     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
436      * the total supply.
437      *
438      * Emits a {Transfer} event with `from` set to the zero address.
439      *
440      * Requirements
441      *
442      * - `to` cannot be the zero address.
443      */
444     function _mint(address account, uint256 amount) internal {
445         require(account != address(0), "ERC20: mint to the zero address");
446 
447         _totalSupply = _totalSupply.add(amount);
448         _balances[account] = _balances[account].add(amount);
449         emit Transfer(address(0), account, amount);
450     }
451 
452     /**
453      * @dev Destroys `amount` tokens from `account`, reducing the
454      * total supply.
455      *
456      * Emits a {Transfer} event with `to` set to the zero address.
457      *
458      * Requirements
459      *
460      * - `account` cannot be the zero address.
461      * - `account` must have at least `amount` tokens.
462      */
463     function _burn(address account, uint256 amount) internal {
464         require(account != address(0), "ERC20: burn from the zero address");
465 
466         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
467         _totalSupply = _totalSupply.sub(amount);
468         emit Transfer(account, address(0), amount);
469     }
470 
471     /**
472      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
473      *
474      * This is internal function is equivalent to `approve`, and can be used to
475      * e.g. set automatic allowances for certain subsystems, etc.
476      *
477      * Emits an {Approval} event.
478      *
479      * Requirements:
480      *
481      * - `owner` cannot be the zero address.
482      * - `spender` cannot be the zero address.
483      */
484     function _approve(address owner, address spender, uint256 amount) internal {
485         require(owner != address(0), "ERC20: approve from the zero address");
486         require(spender != address(0), "ERC20: approve to the zero address");
487 
488         _allowances[owner][spender] = amount;
489         emit Approval(owner, spender, amount);
490     }
491 
492     /**
493      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
494      * from the caller's allowance.
495      *
496      * See {_burn} and {_approve}.
497      */
498     function _burnFrom(address account, uint256 amount) internal {
499         _burn(account, amount);
500         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
501     }
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
505 
506 pragma solidity ^0.5.0;
507 
508 /**
509  * @dev Extension of {ERC20} that allows token holders to destroy both their own
510  * tokens and those that they have an allowance for, in a way that can be
511  * recognized off-chain (via event analysis).
512  */
513 contract ERC20Burnable is Context, ERC20 {
514     /**
515      * @dev Destroys `amount` tokens from the caller.
516      *
517      * See {ERC20-_burn}.
518      */
519     function burn(uint256 amount) public {
520         _burn(_msgSender(), amount);
521     }
522 
523     /**
524      * @dev See {ERC20-_burnFrom}.
525      */
526     function burnFrom(address account, uint256 amount) public {
527         _burnFrom(account, amount);
528     }
529 }
530 
531 // File: @openzeppelin/contracts/access/Roles.sol
532 
533 pragma solidity ^0.5.0;
534 
535 /**
536  * @title Roles
537  * @dev Library for managing addresses assigned to a Role.
538  */
539 library Roles {
540     struct Role {
541         mapping (address => bool) bearer;
542     }
543 
544     /**
545      * @dev Give an account access to this role.
546      */
547     function add(Role storage role, address account) internal {
548         require(!has(role, account), "Roles: account already has role");
549         role.bearer[account] = true;
550     }
551 
552     /**
553      * @dev Remove an account's access to this role.
554      */
555     function remove(Role storage role, address account) internal {
556         require(has(role, account), "Roles: account does not have role");
557         role.bearer[account] = false;
558     }
559 
560     /**
561      * @dev Check if an account has this role.
562      * @return bool
563      */
564     function has(Role storage role, address account) internal view returns (bool) {
565         require(account != address(0), "Roles: account is the zero address");
566         return role.bearer[account];
567     }
568 }
569 
570 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
571 
572 pragma solidity ^0.5.0;
573 
574 /**
575  * @dev Optional functions from the ERC20 standard.
576  */
577 contract ERC20Detailed is IERC20 {
578     string private _name;
579     string private _symbol;
580     uint8 private _decimals;
581 
582     /**
583      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
584      * these values are immutable: they can only be set once during
585      * construction.
586      */
587     constructor (string memory name, string memory symbol, uint8 decimals) public {
588         _name = name;
589         _symbol = symbol;
590         _decimals = decimals;
591     }
592 
593     /**
594      * @dev Returns the name of the token.
595      */
596     function name() public view returns (string memory) {
597         return _name;
598     }
599 
600     /**
601      * @dev Returns the symbol of the token, usually a shorter version of the
602      * name.
603      */
604     function symbol() public view returns (string memory) {
605         return _symbol;
606     }
607 
608     /**
609      * @dev Returns the number of decimals used to get its user representation.
610      * For example, if `decimals` equals `2`, a balance of `505` tokens should
611      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
612      *
613      * Tokens usually opt for a value of 18, imitating the relationship between
614      * Ether and Wei.
615      *
616      * NOTE: This information is only used for _display_ purposes: it in
617      * no way affects any of the arithmetic of the contract, including
618      * {IERC20-balanceOf} and {IERC20-transfer}.
619      */
620     function decimals() public view returns (uint8) {
621         return _decimals;
622     }
623 }
624 
625 // File: @openzeppelin/contracts/access/roles/WhitelistAdminRole.sol
626 
627 pragma solidity ^0.5.0;
628 
629 /**
630  * @title WhitelistAdminRole
631  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
632  */
633 contract WhitelistAdminRole is Context {
634     using Roles for Roles.Role;
635 
636     event WhitelistAdminAdded(address indexed account);
637     event WhitelistAdminRemoved(address indexed account);
638 
639     Roles.Role private _whitelistAdmins;
640 
641     constructor () internal {
642         _addWhitelistAdmin(_msgSender());
643     }
644 
645     modifier onlyWhitelistAdmin() {
646         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
647         _;
648     }
649 
650     function isWhitelistAdmin(address account) public view returns (bool) {
651         return _whitelistAdmins.has(account);
652     }
653 
654     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
655         _addWhitelistAdmin(account);
656     }
657 
658     function renounceWhitelistAdmin() public {
659         _removeWhitelistAdmin(_msgSender());
660     }
661 
662     function _addWhitelistAdmin(address account) internal {
663         _whitelistAdmins.add(account);
664         emit WhitelistAdminAdded(account);
665     }
666 
667     function _removeWhitelistAdmin(address account) internal {
668         _whitelistAdmins.remove(account);
669         emit WhitelistAdminRemoved(account);
670     }
671 }
672 
673 // File: contracts/ERC20/ERC20TransferLiquidityLock.sol
674 
675 pragma solidity ^0.5.17;
676 
677 contract ERC20TransferLiquidityLock is ERC20 {
678     using SafeMath for uint256;
679 
680 
681     event Rebalance(uint256 tokenBurnt);
682     event SupplyRenaSwap(uint256 tokenAmount);
683     event RewardLiquidityProviders(uint256 liquidityRewards);
684     
685     address public uniswapV2Router;
686     address public uniswapV2Pair;
687     address public RenaSwap;
688     address payable public treasury;
689     address public bounce = 0x73282A63F0e3D7e9604575420F777361ecA3C86A;
690     mapping(address => bool) feelessAddr;
691     mapping(address => bool) unlocked;
692     
693     // the amount of tokens to lock for liquidity during every transfer, i.e. 100 = 1%, 50 = 2%, 40 = 2.5%
694     uint256 public liquidityLockDivisor;
695     uint256 public callerRewardDivisor;
696     uint256 public rebalanceDivisor;
697     
698     uint256 public minRebalanceAmount;
699     uint256 public lastRebalance;
700     uint256 public rebalanceInterval;
701     
702     uint256 public lpUnlocked;
703     bool public locked;
704     
705     Balancer balancer;
706     
707     constructor() public {
708         lastRebalance = block.timestamp;
709         liquidityLockDivisor = 100;
710         callerRewardDivisor = 25;
711         rebalanceDivisor = 50;
712         rebalanceInterval = 1 hours;
713         lpUnlocked = block.timestamp + 90 days;
714         minRebalanceAmount = 100 ether;
715         treasury = msg.sender;
716         balancer = new Balancer(treasury);
717         feelessAddr[address(this)] = true;
718         feelessAddr[address(balancer)] = true;
719         feelessAddr[bounce] = true;
720         locked = true;
721         unlocked[msg.sender] = true;
722         unlocked[bounce] = true;
723         unlocked[address(balancer)] = true;
724     }
725     
726     //sav3 transfer function
727     function _transfer(address from, address to, uint256 amount) internal {
728         // calculate liquidity lock amount
729         // dont transfer burn from this contract
730         // or can never lock full lockable amount
731         if(locked && unlocked[from] != true && unlocked[to] != true)
732             revert("Locked until end of presale");
733             
734         if (liquidityLockDivisor != 0 && feelessAddr[from] == false && feelessAddr[to] == false) {
735             uint256 liquidityLockAmount = amount.div(liquidityLockDivisor);
736             super._transfer(from, address(this), liquidityLockAmount);
737             super._transfer(from, to, amount.sub(liquidityLockAmount));
738         }
739         else {
740             super._transfer(from, to, amount);
741         }
742     }
743 
744     // receive eth from uniswap swap
745     function () external payable {}
746 
747     function rebalanceLiquidity() public {
748         require(balanceOf(msg.sender) >= minRebalanceAmount, "You are not part of the syndicate.");
749         require(block.timestamp > lastRebalance + rebalanceInterval, 'Too Soon.');
750         lastRebalance = block.timestamp;
751         // lockable supply is the token balance of this contract
752         uint256 _lockableSupply = balanceOf(address(this));
753         _rewardLiquidityProviders(_lockableSupply);
754         
755         uint256 amountToRemove = ERC20(uniswapV2Pair).balanceOf(address(this)).div(rebalanceDivisor);
756         // needed in case contract already owns eth
757         
758         remLiquidity(amountToRemove);
759         uint _locked = balancer.rebalance(callerRewardDivisor);
760 
761         emit Rebalance(_locked);
762     }
763 
764     function _rewardLiquidityProviders(uint256 liquidityRewards) private {
765         if(RenaSwap != address(0)) {
766             super._transfer(address(this), RenaSwap, liquidityRewards);
767             IUniswapV2Pair(RenaSwap).sync();
768             emit SupplyRenaSwap(liquidityRewards);
769         }
770         else {
771             super._transfer(address(this), uniswapV2Pair, liquidityRewards);
772             IUniswapV2Pair(uniswapV2Pair).sync();
773             emit RewardLiquidityProviders(liquidityRewards);
774         }
775     }
776 
777     function remLiquidity(uint256 lpAmount) private returns(uint ETHAmount) {
778         ERC20(uniswapV2Pair).approve(uniswapV2Router, lpAmount);
779         (ETHAmount) = IUniswapV2Router02(uniswapV2Router)
780             .removeLiquidityETHSupportingFeeOnTransferTokens(
781                 address(this),
782                 lpAmount,
783                 0,
784                 0,
785                 address(balancer),
786                 block.timestamp
787             );
788     }
789 
790     // returns token amount
791     function lockableSupply() external view returns (uint256) {
792         return balanceOf(address(this));
793     }
794 
795     // returns token amount
796     function lockedSupply() external view returns (uint256) {
797         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
798         uint256 lpBalance = lockedLiquidity();
799         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
800 
801         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
802         uint256 _lockedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
803         return _lockedSupply;
804     }
805 
806     // returns token amount
807     function burnedSupply() external view returns (uint256) {
808         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
809         uint256 lpBalance = burnedLiquidity();
810         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
811 
812         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
813         uint256 _burnedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
814         return _burnedSupply;
815     }
816 
817     // returns LP amount, not token amount
818     function burnableLiquidity() public view returns (uint256) {
819         return ERC20(uniswapV2Pair).balanceOf(address(this));
820     }
821 
822     // returns LP amount, not token amount
823     function burnedLiquidity() public view returns (uint256) {
824         return ERC20(uniswapV2Pair).balanceOf(address(0));
825     }
826 
827     // returns LP amount, not token amount
828     function lockedLiquidity() public view returns (uint256) {
829         return burnableLiquidity().add(burnedLiquidity());
830     }
831 }
832 
833 interface IUniswapV2Router02 {
834     function WETH() external pure returns (address);
835     function swapExactETHForTokensSupportingFeeOnTransferTokens(
836       uint amountOutMin,
837       address[] calldata path,
838       address to,
839       uint deadline
840     ) external payable;
841     function removeLiquidityETH(
842       address token,
843       uint liquidity,
844       uint amountTokenMin,
845       uint amountETHMin,
846       address to,
847       uint deadline
848     ) external returns (uint amountToken, uint amountETH);
849     function removeLiquidityETHSupportingFeeOnTransferTokens(
850       address token,
851       uint liquidity,
852       uint amountTokenMin,
853       uint amountETHMin,
854       address to,
855       uint deadline
856     ) external returns (uint amountETH);    
857 }
858 
859 interface IUniswapV2Pair {
860     function sync() external;
861 }
862 
863 // File: contracts/ERC20/ERC20Governance.sol
864 
865 pragma solidity ^0.5.17;
866 
867 contract ERC20Governance is ERC20, ERC20Detailed {
868     using SafeMath for uint256;
869 
870     function _transfer(address from, address to, uint256 amount) internal {
871         _moveDelegates(_delegates[from], _delegates[to], amount);
872         super._transfer(from, to, amount);
873     }
874 
875     function _mint(address account, uint256 amount) internal {
876         _moveDelegates(address(0), _delegates[account], amount);
877         super._mint(account, amount);
878     }
879 
880     function _burn(address account, uint256 amount) internal {
881         _moveDelegates(_delegates[account], address(0), amount);
882         super._burn(account, amount);
883     }
884 
885     // Copied and modified from YAM code:
886     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
887     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
888     // Which is copied and modified from COMPOUND:
889     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
890 
891     /// @notice A record of each accounts delegate
892     mapping (address => address) internal _delegates;
893 
894     /// @notice A checkpoint for marking number of votes from a given block
895     struct Checkpoint {
896         uint32 fromBlock;
897         uint256 votes;
898     }
899 
900     /// @notice A record of votes checkpoints for each account, by index
901     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
902 
903     /// @notice The number of checkpoints for each account
904     mapping (address => uint32) public numCheckpoints;
905 
906     /// @notice The EIP-712 typehash for the contract's domain
907     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
908 
909     /// @notice The EIP-712 typehash for the delegation struct used by the contract
910     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
911 
912     /// @notice A record of states for signing / validating signatures
913     mapping (address => uint) public nonces;
914 
915       /// @notice An event thats emitted when an account changes its delegate
916     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
917 
918     /// @notice An event thats emitted when a delegate account's vote balance changes
919     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
920 
921     /**
922      * @notice Delegate votes from `msg.sender` to `delegatee`
923      * @param delegator The address to get delegatee for
924      */
925     function delegates(address delegator)
926         external
927         view
928         returns (address)
929     {
930         return _delegates[delegator];
931     }
932 
933    /**
934     * @notice Delegate votes from `msg.sender` to `delegatee`
935     * @param delegatee The address to delegate votes to
936     */
937     function delegate(address delegatee) external {
938         return _delegate(msg.sender, delegatee);
939     }
940 
941     /**
942      * @notice Delegates votes from signatory to `delegatee`
943      * @param delegatee The address to delegate votes to
944      * @param nonce The contract state required to match the signature
945      * @param expiry The time at which to expire the signature
946      * @param v The recovery byte of the signature
947      * @param r Half of the ECDSA signature pair
948      * @param s Half of the ECDSA signature pair
949      */
950     function delegateBySig(
951         address delegatee,
952         uint nonce,
953         uint expiry,
954         uint8 v,
955         bytes32 r,
956         bytes32 s
957     )
958         external
959     {
960         bytes32 domainSeparator = keccak256(
961             abi.encode(
962                 DOMAIN_TYPEHASH,
963                 keccak256(bytes(name())),
964                 getChainId(),
965                 address(this)
966             )
967         );
968 
969         bytes32 structHash = keccak256(
970             abi.encode(
971                 DELEGATION_TYPEHASH,
972                 delegatee,
973                 nonce,
974                 expiry
975             )
976         );
977 
978         bytes32 digest = keccak256(
979             abi.encodePacked(
980                 "\x19\x01",
981                 domainSeparator,
982                 structHash
983             )
984         );
985 
986         address signatory = ecrecover(digest, v, r, s);
987         require(signatory != address(0), "ERC20Governance::delegateBySig: invalid signature");
988         require(nonce == nonces[signatory]++, "ERC20Governance::delegateBySig: invalid nonce");
989         require(now <= expiry, "ERC20Governance::delegateBySig: signature expired");
990         return _delegate(signatory, delegatee);
991     }
992 
993     /**
994      * @notice Gets the current votes balance for `account`
995      * @param account The address to get votes balance
996      * @return The number of current votes for `account`
997      */
998     function getCurrentVotes(address account)
999         external
1000         view
1001         returns (uint256)
1002     {
1003         uint32 nCheckpoints = numCheckpoints[account];
1004         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1005     }
1006 
1007     /**
1008      * @notice Determine the prior number of votes for an account as of a block number
1009      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1010      * @param account The address of the account to check
1011      * @param blockNumber The block number to get the vote balance at
1012      * @return The number of votes the account had as of the given block
1013      */
1014     function getPriorVotes(address account, uint blockNumber)
1015         external
1016         view
1017         returns (uint256)
1018     {
1019         require(blockNumber < block.number, "ERC20Governance::getPriorVotes: not yet determined");
1020 
1021         uint32 nCheckpoints = numCheckpoints[account];
1022         if (nCheckpoints == 0) {
1023             return 0;
1024         }
1025 
1026         // First check most recent balance
1027         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1028             return checkpoints[account][nCheckpoints - 1].votes;
1029         }
1030 
1031         // Next check implicit zero balance
1032         if (checkpoints[account][0].fromBlock > blockNumber) {
1033             return 0;
1034         }
1035 
1036         uint32 lower = 0;
1037         uint32 upper = nCheckpoints - 1;
1038         while (upper > lower) {
1039             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1040             Checkpoint memory cp = checkpoints[account][center];
1041             if (cp.fromBlock == blockNumber) {
1042                 return cp.votes;
1043             } else if (cp.fromBlock < blockNumber) {
1044                 lower = center;
1045             } else {
1046                 upper = center - 1;
1047             }
1048         }
1049         return checkpoints[account][lower].votes;
1050     }
1051 
1052     function _delegate(address delegator, address delegatee)
1053         internal
1054     {
1055         address currentDelegate = _delegates[delegator];
1056         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying ERC20Governances (not scaled);
1057         _delegates[delegator] = delegatee;
1058 
1059         emit DelegateChanged(delegator, currentDelegate, delegatee);
1060 
1061         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1062     }
1063 
1064     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1065         if (srcRep != dstRep && amount > 0) {
1066             if (srcRep != address(0)) {
1067                 // decrease old representative
1068                 uint32 srcRepNum = numCheckpoints[srcRep];
1069                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1070                 uint256 srcRepNew = srcRepOld.sub(amount);
1071                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1072             }
1073 
1074             if (dstRep != address(0)) {
1075                 // increase new representative
1076                 uint32 dstRepNum = numCheckpoints[dstRep];
1077                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1078                 uint256 dstRepNew = dstRepOld.add(amount);
1079                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1080             }
1081         }
1082     }
1083 
1084     function _writeCheckpoint(
1085         address delegatee,
1086         uint32 nCheckpoints,
1087         uint256 oldVotes,
1088         uint256 newVotes
1089     )
1090         internal
1091     {
1092         uint32 blockNumber = safe32(block.number, "ERC20Governance::_writeCheckpoint: block number exceeds 32 bits");
1093 
1094         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1095             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1096         } else {
1097             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1098             numCheckpoints[delegatee] = nCheckpoints + 1;
1099         }
1100 
1101         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1102     }
1103 
1104     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1105         require(n < 2**32, errorMessage);
1106         return uint32(n);
1107     }
1108 
1109     function getChainId() internal pure returns (uint) {
1110         uint256 chainId;
1111         assembly { chainId := chainid() }
1112         return chainId;
1113     }
1114 }
1115 
1116 pragma solidity ^0.5.17;
1117 
1118 contract Balancer {
1119     using SafeMath for uint256;    
1120     IterationSyndicate token;
1121     address public burnAddr = 0x000000000000000000000000000000000000dEaD;
1122     address payable public treasury;
1123     
1124     constructor(address payable treasury_) public {
1125         token = IterationSyndicate(msg.sender);
1126         treasury = treasury_;
1127     }
1128     function () external payable {}
1129     function rebalance(uint callerRewardDivisor) external returns (uint256) { 
1130         require(msg.sender == address(token), "only token");
1131         swapEthForTokens(address(this).balance, callerRewardDivisor);
1132         uint256 lockableBalance = token.balanceOf(address(this));
1133         uint256 callerReward = lockableBalance.div(callerRewardDivisor);
1134         token.transfer(tx.origin, callerReward);
1135         token.transfer(burnAddr, lockableBalance.sub(callerReward));        
1136         return lockableBalance.sub(callerReward);
1137     }
1138 
1139     function swapEthForTokens(uint256 EthAmount, uint callerRewardDivisor) private {
1140         address[] memory uniswapPairPath = new address[](2);
1141         uniswapPairPath[0] = IUniswapV2Router02(token.uniswapV2Router()).WETH();
1142         uniswapPairPath[1] = address(token);
1143         uint256 treasuryAmount = EthAmount.div(callerRewardDivisor);
1144         treasury.transfer(treasuryAmount);
1145         
1146         token.approve(token.uniswapV2Router(), EthAmount);
1147         
1148         IUniswapV2Router02(token.uniswapV2Router())
1149             .swapExactETHForTokensSupportingFeeOnTransferTokens.value(EthAmount.sub(treasuryAmount))(
1150                 0,
1151                 uniswapPairPath,
1152                 address(this),
1153                 block.timestamp
1154             );
1155     }    
1156 }
1157 
1158 contract IterationSyndicate is 
1159     ERC20(100000 ether), 
1160     ERC20Detailed("IterationSyndicate", "ITS", 18), 
1161     ERC20Burnable, 
1162     // governance must be before transfer liquidity lock
1163     // or delegates are not updated correctly
1164     ERC20Governance,
1165     ERC20TransferLiquidityLock,
1166     WhitelistAdminRole 
1167 {
1168     function setUniswapV2Router(address _uniswapV2Router) public onlyWhitelistAdmin {
1169         require(uniswapV2Router == address(0), "ITSToken::setUniswapV2Router: already set");
1170         uniswapV2Router = _uniswapV2Router;
1171     }
1172 
1173     function setUniswapV2Pair(address _uniswapV2Pair) public onlyWhitelistAdmin {
1174         require(uniswapV2Pair == address(0), "ITSToken::setUniswapV2Pair: already set");
1175         uniswapV2Pair = _uniswapV2Pair;
1176     }
1177 
1178     function setLiquidityLockDivisor(uint256 _liquidityLockDivisor) public onlyWhitelistAdmin {
1179         if (_liquidityLockDivisor != 0) {
1180             require(_liquidityLockDivisor >= 10, "ITSToken::setLiquidityLockDivisor: too small");
1181         }
1182         liquidityLockDivisor = _liquidityLockDivisor;
1183     }
1184 
1185     function setRebalanceDivisor(uint256 _rebalanceDivisor) public onlyWhitelistAdmin {
1186         if (_rebalanceDivisor != 0) {
1187             require(_rebalanceDivisor >= 10, "ITSToken::setRebalanceDivisor: too small");
1188         }        
1189         rebalanceDivisor = _rebalanceDivisor;
1190     }
1191     
1192     function setRenaSwap(address _rena) public onlyWhitelistAdmin {
1193         RenaSwap = _rena;
1194     }
1195     
1196     function setRebalanceInterval(uint256 _interval) public onlyWhitelistAdmin {
1197         rebalanceInterval = _interval;
1198     }
1199     
1200     function setCallerRewardDivisior(uint256 _rewardDivisor) public onlyWhitelistAdmin {
1201         if (_rewardDivisor != 0) {
1202             require(_rewardDivisor >= 10, "ITSToken::setCallerRewardDivisor: too small");
1203         }        
1204         callerRewardDivisor = _rewardDivisor;
1205     }
1206     
1207     function unlockLP() public onlyWhitelistAdmin {
1208         require(now > lpUnlocked, "Not unlocked yet");
1209         uint256 amount = IERC20(uniswapV2Pair).balanceOf(address(this));
1210         IERC20(uniswapV2Pair).transfer(msg.sender, amount);
1211     }
1212     
1213     function toggleFeeless(address _addr) public onlyWhitelistAdmin {
1214         feelessAddr[_addr] = !feelessAddr[_addr];
1215     }
1216     function toggleUnlockable(address _addr) public onlyWhitelistAdmin {
1217         unlocked[_addr] = !unlocked[_addr];
1218     }    
1219     function unlock() public onlyWhitelistAdmin {
1220         locked = false;
1221     }    
1222 
1223     function setMinRebalanceAmount(uint256 amount_) public onlyWhitelistAdmin {
1224         minRebalanceAmount = amount_;
1225     }
1226 }