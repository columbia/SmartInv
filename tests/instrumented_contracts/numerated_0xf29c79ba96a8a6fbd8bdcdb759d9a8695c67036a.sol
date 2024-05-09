1 
2 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
3 
4 pragma solidity ^0.5.0;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
8  * the optional functions; to access them see {ERC20Detailed}.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin\contracts\token\ERC20\ERC20Detailed.sol
82 
83 pragma solidity ^0.5.0;
84 
85 
86 /**
87  * @dev Optional functions from the ERC20 standard.
88  */
89 contract ERC20Detailed is IERC20 {
90     string private _name;
91     string private _symbol;
92     uint8 private _decimals;
93 
94     /**
95      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
96      * these values are immutable: they can only be set once during
97      * construction.
98      */
99     constructor (string memory name, string memory symbol, uint8 decimals) public {
100         _name = name;
101         _symbol = symbol;
102         _decimals = decimals;
103     }
104 
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() public view returns (string memory) {
109         return _name;
110     }
111 
112     /**
113      * @dev Returns the symbol of the token, usually a shorter version of the
114      * name.
115      */
116     function symbol() public view returns (string memory) {
117         return _symbol;
118     }
119 
120     /**
121      * @dev Returns the number of decimals used to get its user representation.
122      * For example, if `decimals` equals `2`, a balance of `505` tokens should
123      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
124      *
125      * Tokens usually opt for a value of 18, imitating the relationship between
126      * Ether and Wei.
127      *
128      * NOTE: This information is only used for _display_ purposes: it in
129      * no way affects any of the arithmetic of the contract, including
130      * {IERC20-balanceOf} and {IERC20-transfer}.
131      */
132     function decimals() public view returns (uint8) {
133         return _decimals;
134     }
135 }
136 
137 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
138 
139 pragma solidity ^0.5.0;
140 
141 /*
142  * @dev Provides information about the current execution context, including the
143  * sender of the transaction and its data. While these are generally available
144  * via msg.sender and msg.data, they should not be accessed in such a direct
145  * manner, since when dealing with GSN meta-transactions the account sending and
146  * paying for execution may not be the actual sender (as far as an application
147  * is concerned).
148  *
149  * This contract is only required for intermediate, library-like contracts.
150  */
151 contract Context {
152     // Empty internal constructor, to prevent people from mistakenly deploying
153     // an instance of this contract, which should be used via inheritance.
154     constructor () internal { }
155     // solhint-disable-previous-line no-empty-blocks
156 
157     function _msgSender() internal view returns (address payable) {
158         return msg.sender;
159     }
160 
161     function _msgData() internal view returns (bytes memory) {
162         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
163         return msg.data;
164     }
165 }
166 
167 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
168 
169 pragma solidity ^0.5.0;
170 
171 /**
172  * @dev Wrappers over Solidity's arithmetic operations with added overflow
173  * checks.
174  *
175  * Arithmetic operations in Solidity wrap on overflow. This can easily result
176  * in bugs, because programmers usually assume that an overflow raises an
177  * error, which is the standard behavior in high level programming languages.
178  * `SafeMath` restores this intuition by reverting the transaction when an
179  * operation overflows.
180  *
181  * Using this library instead of the unchecked operations eliminates an entire
182  * class of bugs, so it's recommended to use it always.
183  */
184 library SafeMath {
185     /**
186      * @dev Returns the addition of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `+` operator.
190      *
191      * Requirements:
192      * - Addition cannot overflow.
193      */
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         require(c >= a, "SafeMath: addition overflow");
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the subtraction of two unsigned integers, reverting on
203      * overflow (when the result is negative).
204      *
205      * Counterpart to Solidity's `-` operator.
206      *
207      * Requirements:
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         return sub(a, b, "SafeMath: subtraction overflow");
212     }
213 
214     /**
215      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
216      * overflow (when the result is negative).
217      *
218      * Counterpart to Solidity's `-` operator.
219      *
220      * Requirements:
221      * - Subtraction cannot overflow.
222      *
223      * _Available since v2.4.0._
224      */
225     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b <= a, errorMessage);
227         uint256 c = a - b;
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the multiplication of two unsigned integers, reverting on
234      * overflow.
235      *
236      * Counterpart to Solidity's `*` operator.
237      *
238      * Requirements:
239      * - Multiplication cannot overflow.
240      */
241     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
242         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
243         // benefit is lost if 'b' is also tested.
244         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
245         if (a == 0) {
246             return 0;
247         }
248 
249         uint256 c = a * b;
250         require(c / a == b, "SafeMath: multiplication overflow");
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the integer division of two unsigned integers. Reverts on
257      * division by zero. The result is rounded towards zero.
258      *
259      * Counterpart to Solidity's `/` operator. Note: this function uses a
260      * `revert` opcode (which leaves remaining gas untouched) while Solidity
261      * uses an invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      * - The divisor cannot be zero.
265      */
266     function div(uint256 a, uint256 b) internal pure returns (uint256) {
267         return div(a, b, "SafeMath: division by zero");
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
272      * division by zero. The result is rounded towards zero.
273      *
274      * Counterpart to Solidity's `/` operator. Note: this function uses a
275      * `revert` opcode (which leaves remaining gas untouched) while Solidity
276      * uses an invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      * - The divisor cannot be zero.
280      *
281      * _Available since v2.4.0._
282      */
283     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         // Solidity only automatically asserts when dividing by 0
285         require(b > 0, errorMessage);
286         uint256 c = a / b;
287         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
288 
289         return c;
290     }
291 
292     /**
293      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
294      * Reverts when dividing by zero.
295      *
296      * Counterpart to Solidity's `%` operator. This function uses a `revert`
297      * opcode (which leaves remaining gas untouched) while Solidity uses an
298      * invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      * - The divisor cannot be zero.
302      */
303     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
304         return mod(a, b, "SafeMath: modulo by zero");
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * Reverts with custom message when dividing by zero.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      * - The divisor cannot be zero.
317      *
318      * _Available since v2.4.0._
319      */
320     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
321         require(b != 0, errorMessage);
322         return a % b;
323     }
324 }
325 
326 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
327 
328 pragma solidity ^0.5.0;
329 
330 
331 
332 
333 /**
334  * @dev Implementation of the {IERC20} interface.
335  *
336  * This implementation is agnostic to the way tokens are created. This means
337  * that a supply mechanism has to be added in a derived contract using {_mint}.
338  * For a generic mechanism see {ERC20Mintable}.
339  *
340  * TIP: For a detailed writeup see our guide
341  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
342  * to implement supply mechanisms].
343  *
344  * We have followed general OpenZeppelin guidelines: functions revert instead
345  * of returning `false` on failure. This behavior is nonetheless conventional
346  * and does not conflict with the expectations of ERC20 applications.
347  *
348  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
349  * This allows applications to reconstruct the allowance for all accounts just
350  * by listening to said events. Other implementations of the EIP may not emit
351  * these events, as it isn't required by the specification.
352  *
353  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
354  * functions have been added to mitigate the well-known issues around setting
355  * allowances. See {IERC20-approve}.
356  */
357 contract ERC20 is Context, IERC20 {
358     using SafeMath for uint256;
359 
360     mapping (address => uint256) private _balances;
361 
362     mapping (address => mapping (address => uint256)) private _allowances;
363 
364     uint256 private _totalSupply;
365 
366     /**
367      * @dev See {IERC20-totalSupply}.
368      */
369     function totalSupply() public view returns (uint256) {
370         return _totalSupply;
371     }
372 
373     /**
374      * @dev See {IERC20-balanceOf}.
375      */
376     function balanceOf(address account) public view returns (uint256) {
377         return _balances[account];
378     }
379 
380     /**
381      * @dev See {IERC20-transfer}.
382      *
383      * Requirements:
384      *
385      * - `recipient` cannot be the zero address.
386      * - the caller must have a balance of at least `amount`.
387      */
388     function transfer(address recipient, uint256 amount) public returns (bool) {
389         _transfer(_msgSender(), recipient, amount);
390         return true;
391     }
392 
393     /**
394      * @dev See {IERC20-allowance}.
395      */
396     function allowance(address owner, address spender) public view returns (uint256) {
397         return _allowances[owner][spender];
398     }
399 
400     /**
401      * @dev See {IERC20-approve}.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      */
407     function approve(address spender, uint256 amount) public returns (bool) {
408         _approve(_msgSender(), spender, amount);
409         return true;
410     }
411 
412     /**
413      * @dev See {IERC20-transferFrom}.
414      *
415      * Emits an {Approval} event indicating the updated allowance. This is not
416      * required by the EIP. See the note at the beginning of {ERC20};
417      *
418      * Requirements:
419      * - `sender` and `recipient` cannot be the zero address.
420      * - `sender` must have a balance of at least `amount`.
421      * - the caller must have allowance for `sender`'s tokens of at least
422      * `amount`.
423      */
424     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
425         _transfer(sender, recipient, amount);
426         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
427         return true;
428     }
429 
430     /**
431      * @dev Atomically increases the allowance granted to `spender` by the caller.
432      *
433      * This is an alternative to {approve} that can be used as a mitigation for
434      * problems described in {IERC20-approve}.
435      *
436      * Emits an {Approval} event indicating the updated allowance.
437      *
438      * Requirements:
439      *
440      * - `spender` cannot be the zero address.
441      */
442     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
443         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
444         return true;
445     }
446 
447     /**
448      * @dev Atomically decreases the allowance granted to `spender` by the caller.
449      *
450      * This is an alternative to {approve} that can be used as a mitigation for
451      * problems described in {IERC20-approve}.
452      *
453      * Emits an {Approval} event indicating the updated allowance.
454      *
455      * Requirements:
456      *
457      * - `spender` cannot be the zero address.
458      * - `spender` must have allowance for the caller of at least
459      * `subtractedValue`.
460      */
461     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
462         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
463         return true;
464     }
465 
466     /**
467      * @dev Moves tokens `amount` from `sender` to `recipient`.
468      *
469      * This is internal function is equivalent to {transfer}, and can be used to
470      * e.g. implement automatic token fees, slashing mechanisms, etc.
471      *
472      * Emits a {Transfer} event.
473      *
474      * Requirements:
475      *
476      * - `sender` cannot be the zero address.
477      * - `recipient` cannot be the zero address.
478      * - `sender` must have a balance of at least `amount`.
479      */
480     function _transfer(address sender, address recipient, uint256 amount) internal {
481         require(sender != address(0), "ERC20: transfer from the zero address");
482         require(recipient != address(0), "ERC20: transfer to the zero address");
483 
484         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
485         _balances[recipient] = _balances[recipient].add(amount);
486         emit Transfer(sender, recipient, amount);
487     }
488 
489     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
490      * the total supply.
491      *
492      * Emits a {Transfer} event with `from` set to the zero address.
493      *
494      * Requirements
495      *
496      * - `to` cannot be the zero address.
497      */
498     function _mint(address account, uint256 amount) internal {
499         require(account != address(0), "ERC20: mint to the zero address");
500 
501         _totalSupply = _totalSupply.add(amount);
502         _balances[account] = _balances[account].add(amount);
503         emit Transfer(address(0), account, amount);
504     }
505 
506     /**
507      * @dev Destroys `amount` tokens from `account`, reducing the
508      * total supply.
509      *
510      * Emits a {Transfer} event with `to` set to the zero address.
511      *
512      * Requirements
513      *
514      * - `account` cannot be the zero address.
515      * - `account` must have at least `amount` tokens.
516      */
517     function _burn(address account, uint256 amount) internal {
518         require(account != address(0), "ERC20: burn from the zero address");
519 
520         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
521         _totalSupply = _totalSupply.sub(amount);
522         emit Transfer(account, address(0), amount);
523     }
524 
525     /**
526      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
527      *
528      * This is internal function is equivalent to `approve`, and can be used to
529      * e.g. set automatic allowances for certain subsystems, etc.
530      *
531      * Emits an {Approval} event.
532      *
533      * Requirements:
534      *
535      * - `owner` cannot be the zero address.
536      * - `spender` cannot be the zero address.
537      */
538     function _approve(address owner, address spender, uint256 amount) internal {
539         require(owner != address(0), "ERC20: approve from the zero address");
540         require(spender != address(0), "ERC20: approve to the zero address");
541 
542         _allowances[owner][spender] = amount;
543         emit Approval(owner, spender, amount);
544     }
545 
546     /**
547      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
548      * from the caller's allowance.
549      *
550      * See {_burn} and {_approve}.
551      */
552     function _burnFrom(address account, uint256 amount) internal {
553         _burn(account, amount);
554         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
555     }
556 }
557 
558 // File: @openzeppelin\contracts\token\ERC20\ERC20Burnable.sol
559 
560 pragma solidity ^0.5.0;
561 
562 
563 
564 /**
565  * @dev Extension of {ERC20} that allows token holders to destroy both their own
566  * tokens and those that they have an allowance for, in a way that can be
567  * recognized off-chain (via event analysis).
568  */
569 contract ERC20Burnable is Context, ERC20 {
570     /**
571      * @dev Destroys `amount` tokens from the caller.
572      *
573      * See {ERC20-_burn}.
574      */
575     function burn(uint256 amount) public {
576         _burn(_msgSender(), amount);
577     }
578 
579     /**
580      * @dev See {ERC20-_burnFrom}.
581      */
582     function burnFrom(address account, uint256 amount) public {
583         _burnFrom(account, amount);
584     }
585 }
586 
587 // File: node_modules\@openzeppelin\contracts\access\Roles.sol
588 
589 pragma solidity ^0.5.0;
590 
591 /**
592  * @title Roles
593  * @dev Library for managing addresses assigned to a Role.
594  */
595 library Roles {
596     struct Role {
597         mapping (address => bool) bearer;
598     }
599 
600     /**
601      * @dev Give an account access to this role.
602      */
603     function add(Role storage role, address account) internal {
604         require(!has(role, account), "Roles: account already has role");
605         role.bearer[account] = true;
606     }
607 
608     /**
609      * @dev Remove an account's access to this role.
610      */
611     function remove(Role storage role, address account) internal {
612         require(has(role, account), "Roles: account does not have role");
613         role.bearer[account] = false;
614     }
615 
616     /**
617      * @dev Check if an account has this role.
618      * @return bool
619      */
620     function has(Role storage role, address account) internal view returns (bool) {
621         require(account != address(0), "Roles: account is the zero address");
622         return role.bearer[account];
623     }
624 }
625 
626 // File: node_modules\@openzeppelin\contracts\access\roles\MinterRole.sol
627 
628 pragma solidity ^0.5.0;
629 
630 
631 
632 contract MinterRole is Context {
633     using Roles for Roles.Role;
634 
635     event MinterAdded(address indexed account);
636     event MinterRemoved(address indexed account);
637 
638     Roles.Role private _minters;
639 
640     constructor () internal {
641         _addMinter(_msgSender());
642     }
643 
644     modifier onlyMinter() {
645         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
646         _;
647     }
648 
649     function isMinter(address account) public view returns (bool) {
650         return _minters.has(account);
651     }
652 
653     function addMinter(address account) public onlyMinter {
654         _addMinter(account);
655     }
656 
657     function renounceMinter() public {
658         _removeMinter(_msgSender());
659     }
660 
661     function _addMinter(address account) internal {
662         _minters.add(account);
663         emit MinterAdded(account);
664     }
665 
666     function _removeMinter(address account) internal {
667         _minters.remove(account);
668         emit MinterRemoved(account);
669     }
670 }
671 
672 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20Mintable.sol
673 
674 pragma solidity ^0.5.0;
675 
676 
677 
678 /**
679  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
680  * which have permission to mint (create) new tokens as they see fit.
681  *
682  * At construction, the deployer of the contract is the only minter.
683  */
684 contract ERC20Mintable is ERC20, MinterRole {
685     /**
686      * @dev See {ERC20-_mint}.
687      *
688      * Requirements:
689      *
690      * - the caller must have the {MinterRole}.
691      */
692     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
693         _mint(account, amount);
694         return true;
695     }
696 }
697 
698 // File: @openzeppelin\contracts\token\ERC20\ERC20Capped.sol
699 
700 pragma solidity ^0.5.0;
701 
702 
703 /**
704  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
705  */
706 contract ERC20Capped is ERC20Mintable {
707     uint256 private _cap;
708 
709     /**
710      * @dev Sets the value of the `cap`. This value is immutable, it can only be
711      * set once during construction.
712      */
713     constructor (uint256 cap) public {
714         require(cap > 0, "ERC20Capped: cap is 0");
715         _cap = cap;
716     }
717 
718     /**
719      * @dev Returns the cap on the token's total supply.
720      */
721     function cap() public view returns (uint256) {
722         return _cap;
723     }
724 
725     /**
726      * @dev See {ERC20Mintable-mint}.
727      *
728      * Requirements:
729      *
730      * - `value` must not cause the total supply to go over the cap.
731      */
732     function _mint(address account, uint256 value) internal {
733         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
734         super._mint(account, value);
735     }
736 }
737 
738 // File: contracts\SimpleCoin.sol
739 
740 pragma solidity ^0.5.0;
741 
742 contract BGOEX is ERC20Detailed, ERC20Burnable {
743     constructor ()
744     public
745     ERC20Detailed("BGOEX", "BGO", 18)
746     {
747         _mint(msg.sender, 520000000 * (10 ** uint256(decimals())));
748     }
749 }
