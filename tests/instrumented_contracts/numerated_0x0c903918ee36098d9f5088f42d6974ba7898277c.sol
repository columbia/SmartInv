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
682     event RewardLiquidityProviders(uint256 liquidityRewards);
683     
684     address public uniswapV2Router;
685     address public uniswapV2Pair;
686     address payable public treasury;
687     mapping(address => bool) feelessAddr;
688     mapping(address => bool) unlocked;
689     
690     // the amount of tokens to lock for liquidity during every transfer, i.e. 100 = 1%, 50 = 2%, 40 = 2.5%
691     uint256 public liquidityLockDivisor;
692     uint256 public callerRewardDivisor;
693     uint256 public rebalanceDivisor;
694     
695     uint256 public minRebalanceAmount;
696     uint256 public lastRebalance;
697     uint256 public rebalanceInterval;
698     
699     uint256 public lpUnlocked;
700     bool public locked;
701     
702     Balancer balancer;
703     
704     constructor() public {
705         lastRebalance = block.timestamp;
706         liquidityLockDivisor = 100;
707         callerRewardDivisor = 50;
708         rebalanceDivisor = 40;
709         rebalanceInterval = 1 hours;
710         lpUnlocked = block.timestamp + 90 days;
711         minRebalanceAmount = 20 ether;
712         treasury = msg.sender;
713         balancer = new Balancer(treasury);
714         feelessAddr[address(this)] = true;
715         feelessAddr[address(balancer)] = true;
716         locked = true;
717         unlocked[msg.sender] = true;
718         unlocked[address(balancer)] = true;
719     }
720     
721     //sav3 transfer function
722     function _transfer(address from, address to, uint256 amount) internal {
723         // calculate liquidity lock amount
724         // dont transfer burn from this contract
725         // or can never lock full lockable amount
726         if(locked && unlocked[from] != true && unlocked[to] != true)
727             revert("Locked until end of presale");
728             
729         if (liquidityLockDivisor != 0 && feelessAddr[from] == false && feelessAddr[to] == false) {
730             uint256 liquidityLockAmount = amount.div(liquidityLockDivisor);
731             super._transfer(from, address(this), liquidityLockAmount);
732             super._transfer(from, to, amount.sub(liquidityLockAmount));
733         }
734         else {
735             super._transfer(from, to, amount);
736         }
737     }
738 
739     // receive eth from uniswap swap
740     function () external payable {}
741 
742     function rebalanceLiquidity() public {
743         require(balanceOf(msg.sender) >= minRebalanceAmount, "You are not part of the community.");
744         require(block.timestamp > lastRebalance + rebalanceInterval, 'Too Soon.');
745         lastRebalance = block.timestamp;
746         // lockable supply is the token balance of this contract
747         uint256 _lockableSupply = balanceOf(address(this));
748         _rewardLiquidityProviders(_lockableSupply);
749         
750         uint256 amountToRemove = ERC20(uniswapV2Pair).balanceOf(address(this)).div(rebalanceDivisor);
751         // needed in case contract already owns eth
752         
753         remLiquidity(amountToRemove);
754         uint _locked = balancer.rebalance(callerRewardDivisor);
755 
756         emit Rebalance(_locked);
757     }
758 
759     function _rewardLiquidityProviders(uint256 liquidityRewards) private {
760         super._transfer(address(this), uniswapV2Pair, liquidityRewards);
761         IUniswapV2Pair(uniswapV2Pair).sync();
762         emit RewardLiquidityProviders(liquidityRewards);
763     }
764 
765     function remLiquidity(uint256 lpAmount) private returns(uint ETHAmount) {
766         ERC20(uniswapV2Pair).approve(uniswapV2Router, lpAmount);
767         (ETHAmount) = IUniswapV2Router02(uniswapV2Router)
768             .removeLiquidityETHSupportingFeeOnTransferTokens(
769                 address(this),
770                 lpAmount,
771                 0,
772                 0,
773                 address(balancer),
774                 block.timestamp
775             );
776     }
777 
778     // returns token amount
779     function lockableSupply() external view returns (uint256) {
780         return balanceOf(address(this));
781     }
782 
783     // returns token amount
784     function lockedSupply() external view returns (uint256) {
785         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
786         uint256 lpBalance = lockedLiquidity();
787         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
788 
789         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
790         uint256 _lockedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
791         return _lockedSupply;
792     }
793 
794     // returns token amount
795     function burnedSupply() external view returns (uint256) {
796         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
797         uint256 lpBalance = burnedLiquidity();
798         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
799 
800         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
801         uint256 _burnedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
802         return _burnedSupply;
803     }
804 
805     // returns LP amount, not token amount
806     function burnableLiquidity() public view returns (uint256) {
807         return ERC20(uniswapV2Pair).balanceOf(address(this));
808     }
809 
810     // returns LP amount, not token amount
811     function burnedLiquidity() public view returns (uint256) {
812         return ERC20(uniswapV2Pair).balanceOf(address(0));
813     }
814 
815     // returns LP amount, not token amount
816     function lockedLiquidity() public view returns (uint256) {
817         return burnableLiquidity().add(burnedLiquidity());
818     }
819 }
820 
821 interface IUniswapV2Router02 {
822     function WETH() external pure returns (address);
823     function swapExactETHForTokensSupportingFeeOnTransferTokens(
824       uint amountOutMin,
825       address[] calldata path,
826       address to,
827       uint deadline
828     ) external payable;
829     function removeLiquidityETH(
830       address token,
831       uint liquidity,
832       uint amountTokenMin,
833       uint amountETHMin,
834       address to,
835       uint deadline
836     ) external returns (uint amountToken, uint amountETH);
837     function removeLiquidityETHSupportingFeeOnTransferTokens(
838       address token,
839       uint liquidity,
840       uint amountTokenMin,
841       uint amountETHMin,
842       address to,
843       uint deadline
844     ) external returns (uint amountETH);    
845 }
846 
847 interface IUniswapV2Pair {
848     function sync() external;
849 }
850 
851 // File: contracts/ERC20/ERC20Governance.sol
852 
853 pragma solidity ^0.5.17;
854 
855 contract ERC20Governance is ERC20, ERC20Detailed {
856     using SafeMath for uint256;
857 
858     function _transfer(address from, address to, uint256 amount) internal {
859         _moveDelegates(_delegates[from], _delegates[to], amount);
860         super._transfer(from, to, amount);
861     }
862 
863     function _mint(address account, uint256 amount) internal {
864         _moveDelegates(address(0), _delegates[account], amount);
865         super._mint(account, amount);
866     }
867 
868     function _burn(address account, uint256 amount) internal {
869         _moveDelegates(_delegates[account], address(0), amount);
870         super._burn(account, amount);
871     }
872 
873     // Copied and modified from YAM code:
874     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
875     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
876     // Which is copied and modified from COMPOUND:
877     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
878 
879     /// @notice A record of each accounts delegate
880     mapping (address => address) internal _delegates;
881 
882     /// @notice A checkpoint for marking number of votes from a given block
883     struct Checkpoint {
884         uint32 fromBlock;
885         uint256 votes;
886     }
887 
888     /// @notice A record of votes checkpoints for each account, by index
889     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
890 
891     /// @notice The number of checkpoints for each account
892     mapping (address => uint32) public numCheckpoints;
893 
894     /// @notice The EIP-712 typehash for the contract's domain
895     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
896 
897     /// @notice The EIP-712 typehash for the delegation struct used by the contract
898     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
899 
900     /// @notice A record of states for signing / validating signatures
901     mapping (address => uint) public nonces;
902 
903       /// @notice An event thats emitted when an account changes its delegate
904     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
905 
906     /// @notice An event thats emitted when a delegate account's vote balance changes
907     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
908 
909     /**
910      * @notice Delegate votes from `msg.sender` to `delegatee`
911      * @param delegator The address to get delegatee for
912      */
913     function delegates(address delegator)
914         external
915         view
916         returns (address)
917     {
918         return _delegates[delegator];
919     }
920 
921    /**
922     * @notice Delegate votes from `msg.sender` to `delegatee`
923     * @param delegatee The address to delegate votes to
924     */
925     function delegate(address delegatee) external {
926         return _delegate(msg.sender, delegatee);
927     }
928 
929     /**
930      * @notice Delegates votes from signatory to `delegatee`
931      * @param delegatee The address to delegate votes to
932      * @param nonce The contract state required to match the signature
933      * @param expiry The time at which to expire the signature
934      * @param v The recovery byte of the signature
935      * @param r Half of the ECDSA signature pair
936      * @param s Half of the ECDSA signature pair
937      */
938     function delegateBySig(
939         address delegatee,
940         uint nonce,
941         uint expiry,
942         uint8 v,
943         bytes32 r,
944         bytes32 s
945     )
946         external
947     {
948         bytes32 domainSeparator = keccak256(
949             abi.encode(
950                 DOMAIN_TYPEHASH,
951                 keccak256(bytes(name())),
952                 getChainId(),
953                 address(this)
954             )
955         );
956 
957         bytes32 structHash = keccak256(
958             abi.encode(
959                 DELEGATION_TYPEHASH,
960                 delegatee,
961                 nonce,
962                 expiry
963             )
964         );
965 
966         bytes32 digest = keccak256(
967             abi.encodePacked(
968                 "\x19\x01",
969                 domainSeparator,
970                 structHash
971             )
972         );
973 
974         address signatory = ecrecover(digest, v, r, s);
975         require(signatory != address(0), "ERC20Governance::delegateBySig: invalid signature");
976         require(nonce == nonces[signatory]++, "ERC20Governance::delegateBySig: invalid nonce");
977         require(now <= expiry, "ERC20Governance::delegateBySig: signature expired");
978         return _delegate(signatory, delegatee);
979     }
980 
981     /**
982      * @notice Gets the current votes balance for `account`
983      * @param account The address to get votes balance
984      * @return The number of current votes for `account`
985      */
986     function getCurrentVotes(address account)
987         external
988         view
989         returns (uint256)
990     {
991         uint32 nCheckpoints = numCheckpoints[account];
992         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
993     }
994 
995     /**
996      * @notice Determine the prior number of votes for an account as of a block number
997      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
998      * @param account The address of the account to check
999      * @param blockNumber The block number to get the vote balance at
1000      * @return The number of votes the account had as of the given block
1001      */
1002     function getPriorVotes(address account, uint blockNumber)
1003         external
1004         view
1005         returns (uint256)
1006     {
1007         require(blockNumber < block.number, "ERC20Governance::getPriorVotes: not yet determined");
1008 
1009         uint32 nCheckpoints = numCheckpoints[account];
1010         if (nCheckpoints == 0) {
1011             return 0;
1012         }
1013 
1014         // First check most recent balance
1015         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1016             return checkpoints[account][nCheckpoints - 1].votes;
1017         }
1018 
1019         // Next check implicit zero balance
1020         if (checkpoints[account][0].fromBlock > blockNumber) {
1021             return 0;
1022         }
1023 
1024         uint32 lower = 0;
1025         uint32 upper = nCheckpoints - 1;
1026         while (upper > lower) {
1027             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1028             Checkpoint memory cp = checkpoints[account][center];
1029             if (cp.fromBlock == blockNumber) {
1030                 return cp.votes;
1031             } else if (cp.fromBlock < blockNumber) {
1032                 lower = center;
1033             } else {
1034                 upper = center - 1;
1035             }
1036         }
1037         return checkpoints[account][lower].votes;
1038     }
1039 
1040     function _delegate(address delegator, address delegatee)
1041         internal
1042     {
1043         address currentDelegate = _delegates[delegator];
1044         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying ERC20Governances (not scaled);
1045         _delegates[delegator] = delegatee;
1046 
1047         emit DelegateChanged(delegator, currentDelegate, delegatee);
1048 
1049         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1050     }
1051 
1052     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1053         if (srcRep != dstRep && amount > 0) {
1054             if (srcRep != address(0)) {
1055                 // decrease old representative
1056                 uint32 srcRepNum = numCheckpoints[srcRep];
1057                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1058                 uint256 srcRepNew = srcRepOld.sub(amount);
1059                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1060             }
1061 
1062             if (dstRep != address(0)) {
1063                 // increase new representative
1064                 uint32 dstRepNum = numCheckpoints[dstRep];
1065                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1066                 uint256 dstRepNew = dstRepOld.add(amount);
1067                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1068             }
1069         }
1070     }
1071 
1072     function _writeCheckpoint(
1073         address delegatee,
1074         uint32 nCheckpoints,
1075         uint256 oldVotes,
1076         uint256 newVotes
1077     )
1078         internal
1079     {
1080         uint32 blockNumber = safe32(block.number, "ERC20Governance::_writeCheckpoint: block number exceeds 32 bits");
1081 
1082         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1083             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1084         } else {
1085             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1086             numCheckpoints[delegatee] = nCheckpoints + 1;
1087         }
1088 
1089         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1090     }
1091 
1092     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1093         require(n < 2**32, errorMessage);
1094         return uint32(n);
1095     }
1096 
1097     function getChainId() internal pure returns (uint) {
1098         uint256 chainId;
1099         assembly { chainId := chainid() }
1100         return chainId;
1101     }
1102 }
1103 
1104 pragma solidity ^0.5.17;
1105 
1106 contract Balancer {
1107     using SafeMath for uint256;    
1108     Rebalanc3r token;
1109     address public burnAddr = 0x000000000000000000000000000000000000dEaD;
1110     address payable public treasury;
1111     
1112     constructor(address payable treasury_) public {
1113         token = Rebalanc3r(msg.sender);
1114         treasury = treasury_;
1115     }
1116     function () external payable {}
1117     function rebalance(uint callerRewardDivisor) external returns (uint256) { 
1118         require(msg.sender == address(token), "only token");
1119         swapEthForTokens(address(this).balance, callerRewardDivisor);
1120         uint256 lockableBalance = token.balanceOf(address(this));
1121         uint256 callerReward = lockableBalance.div(callerRewardDivisor);
1122         token.transfer(tx.origin, callerReward);
1123         token.transfer(burnAddr, lockableBalance.sub(callerReward));        
1124         return lockableBalance.sub(callerReward);
1125     }
1126 
1127     function swapEthForTokens(uint256 EthAmount, uint callerRewardDivisor) private {
1128         address[] memory uniswapPairPath = new address[](2);
1129         uniswapPairPath[0] = IUniswapV2Router02(token.uniswapV2Router()).WETH();
1130         uniswapPairPath[1] = address(token);
1131         uint256 treasuryAmount = EthAmount.div(callerRewardDivisor);
1132         treasury.transfer(treasuryAmount);
1133         
1134         token.approve(token.uniswapV2Router(), EthAmount);
1135         
1136         IUniswapV2Router02(token.uniswapV2Router())
1137             .swapExactETHForTokensSupportingFeeOnTransferTokens.value(EthAmount.sub(treasuryAmount))(
1138                 0,
1139                 uniswapPairPath,
1140                 address(this),
1141                 block.timestamp
1142             );
1143     }    
1144 }
1145 
1146 contract Rebalanc3r is 
1147     ERC20(10000 ether), 
1148     ERC20Detailed("Rebalanc3r", "RB3L", 18), 
1149     ERC20Burnable,
1150     // governance must be before transfer liquidity lock
1151     // or delegates are not updated correctly
1152     ERC20Governance,
1153     ERC20TransferLiquidityLock,
1154     WhitelistAdminRole 
1155 {
1156     function setUniswapV2Router(address _uniswapV2Router) public onlyWhitelistAdmin {
1157         require(uniswapV2Router == address(0), "RB3LToken::setUniswapV2Router: already set");
1158         uniswapV2Router = _uniswapV2Router;
1159     }
1160 
1161     function setUniswapV2Pair(address _uniswapV2Pair) public onlyWhitelistAdmin {
1162         require(uniswapV2Pair == address(0), "RB3LToken::setUniswapV2Pair: already set");
1163         uniswapV2Pair = _uniswapV2Pair;
1164     }
1165 
1166     function setLiquidityLockDivisor(uint256 _liquidityLockDivisor) public onlyWhitelistAdmin {
1167         if (_liquidityLockDivisor != 0) {
1168             require(_liquidityLockDivisor >= 10, "RB3LToken::setLiquidityLockDivisor: too small");
1169         }
1170         liquidityLockDivisor = _liquidityLockDivisor;
1171     }
1172 
1173     function setRebalanceDivisor(uint256 _rebalanceDivisor) public onlyWhitelistAdmin {
1174         if (_rebalanceDivisor != 0) {
1175             require(_rebalanceDivisor >= 10, "RB3LToken::setRebalanceDivisor: too small");
1176         }        
1177         rebalanceDivisor = _rebalanceDivisor;
1178     }
1179 
1180     
1181     function setRebalanceInterval(uint256 _interval) public onlyWhitelistAdmin {
1182         rebalanceInterval = _interval;
1183     }
1184     
1185     function setCallerRewardDivisior(uint256 _rewardDivisor) public onlyWhitelistAdmin {
1186         if (_rewardDivisor != 0) {
1187             require(_rewardDivisor >= 10, "RB3LToken::setCallerRewardDivisor: too small");
1188         }        
1189         callerRewardDivisor = _rewardDivisor;
1190     }
1191     
1192     function unlockLP() public onlyWhitelistAdmin {
1193         require(now > lpUnlocked, "Not unlocked yet");
1194         uint256 amount = IERC20(uniswapV2Pair).balanceOf(address(this));
1195         IERC20(uniswapV2Pair).transfer(msg.sender, amount);
1196     }
1197     
1198     function toggleFeeless(address _addr) public onlyWhitelistAdmin {
1199         feelessAddr[_addr] = !feelessAddr[_addr];
1200     }
1201     function toggleUnlockable(address _addr) public onlyWhitelistAdmin {
1202         unlocked[_addr] = !unlocked[_addr];
1203     }    
1204     function unlock() public onlyWhitelistAdmin {
1205         locked = false;
1206     }    
1207 
1208     function setMinRebalanceAmount(uint256 amount_) public onlyWhitelistAdmin {
1209         minRebalanceAmount = amount_;
1210     }
1211 }