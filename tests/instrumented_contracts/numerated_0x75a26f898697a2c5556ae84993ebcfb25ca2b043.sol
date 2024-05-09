1 /***
2  *    ██████╗  ██████╗ ██╗     ██████╗ ██╗  ██╗██╗███╗   ██╗
3  *    ██╔══██╗██╔═══██╗██║     ██╔══██╗██║  ██║██║████╗  ██║
4  *    ██║  ██║██║   ██║██║     ██████╔╝███████║██║██╔██╗ ██║
5  *    ██║  ██║██║   ██║██║     ██╔═══╝ ██╔══██║██║██║╚██╗██║
6  *    ██████╔╝╚██████╔╝███████╗██║     ██║  ██║██║██║ ╚████║
7  *    ╚═════╝  ╚═════╝ ╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
8  * 
9  * https://dolphintoken.dev/
10  * https://t.me/dolphintoken
11  * 
12  * Experimental project by Seal Ze.
13  * 
14  * Contract has been tested, but could contain flaws.
15  * I am not liable if these flaws exist. Have fun!
16  * 
17  *
18  *                                                          
19  */
20 
21 
22 pragma solidity ^0.5.0;
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
26  * the optional functions; to access them see {ERC20Detailed}.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 // File: @openzeppelin\contracts\token\ERC20\ERC20Detailed.sol
100 
101 pragma solidity ^0.5.0;
102 
103 
104 /**
105  * @dev Optional functions from the ERC20 standard.
106  */
107 contract ERC20Detailed is IERC20 {
108     string private _name;
109     string private _symbol;
110     uint8 private _decimals;
111 
112     /**
113      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
114      * these values are immutable: they can only be set once during
115      * construction.
116      */
117     constructor (string memory name, string memory symbol, uint8 decimals) public {
118         _name = name;
119         _symbol = symbol;
120         _decimals = decimals;
121     }
122 
123     /**
124      * @dev Returns the name of the token.
125      */
126     function name() public view returns (string memory) {
127         return _name;
128     }
129 
130     /**
131      * @dev Returns the symbol of the token, usually a shorter version of the
132      * name.
133      */
134     function symbol() public view returns (string memory) {
135         return _symbol;
136     }
137 
138     /**
139      * @dev Returns the number of decimals used to get its user representation.
140      * For example, if `decimals` equals `2`, a balance of `505` tokens should
141      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
142      *
143      * Tokens usually opt for a value of 18, imitating the relationship between
144      * Ether and Wei.
145      *
146      * NOTE: This information is only used for _display_ purposes: it in
147      * no way affects any of the arithmetic of the contract, including
148      * {IERC20-balanceOf} and {IERC20-transfer}.
149      */
150     function decimals() public view returns (uint8) {
151         return _decimals;
152     }
153 }
154 
155 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
156 
157 pragma solidity ^0.5.0;
158 
159 /*
160  * @dev Provides information about the current execution context, including the
161  * sender of the transaction and its data. While these are generally available
162  * via msg.sender and msg.data, they should not be accessed in such a direct
163  * manner, since when dealing with GSN meta-transactions the account sending and
164  * paying for execution may not be the actual sender (as far as an application
165  * is concerned).
166  *
167  * This contract is only required for intermediate, library-like contracts.
168  */
169 contract Context {
170     // Empty internal constructor, to prevent people from mistakenly deploying
171     // an instance of this contract, which should be used via inheritance.
172     constructor () internal { }
173     // solhint-disable-previous-line no-empty-blocks
174 
175     function _msgSender() internal view returns (address payable) {
176         return msg.sender;
177     }
178 
179     function _msgData() internal view returns (bytes memory) {
180         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
181         return msg.data;
182     }
183 }
184 
185 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
186 
187 pragma solidity ^0.5.0;
188 
189 /**
190  * @dev Wrappers over Solidity's arithmetic operations with added overflow
191  * checks.
192  *
193  * Arithmetic operations in Solidity wrap on overflow. This can easily result
194  * in bugs, because programmers usually assume that an overflow raises an
195  * error, which is the standard behavior in high level programming languages.
196  * `SafeMath` restores this intuition by reverting the transaction when an
197  * operation overflows.
198  *
199  * Using this library instead of the unchecked operations eliminates an entire
200  * class of bugs, so it's recommended to use it always.
201  */
202 library SafeMath {
203     /**
204      * @dev Returns the addition of two unsigned integers, reverting on
205      * overflow.
206      *
207      * Counterpart to Solidity's `+` operator.
208      *
209      * Requirements:
210      * - Addition cannot overflow.
211      */
212     function add(uint256 a, uint256 b) internal pure returns (uint256) {
213         uint256 c = a + b;
214         require(c >= a, "SafeMath: addition overflow");
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the subtraction of two unsigned integers, reverting on
221      * overflow (when the result is negative).
222      *
223      * Counterpart to Solidity's `-` operator.
224      *
225      * Requirements:
226      * - Subtraction cannot overflow.
227      */
228     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229         return sub(a, b, "SafeMath: subtraction overflow");
230     }
231 
232     /**
233      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
234      * overflow (when the result is negative).
235      *
236      * Counterpart to Solidity's `-` operator.
237      *
238      * Requirements:
239      * - Subtraction cannot overflow.
240      *
241      * _Available since v2.4.0._
242      */
243     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b <= a, errorMessage);
245         uint256 c = a - b;
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the multiplication of two unsigned integers, reverting on
252      * overflow.
253      *
254      * Counterpart to Solidity's `*` operator.
255      *
256      * Requirements:
257      * - Multiplication cannot overflow.
258      */
259     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
260         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
261         // benefit is lost if 'b' is also tested.
262         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
263         if (a == 0) {
264             return 0;
265         }
266 
267         uint256 c = a * b;
268         require(c / a == b, "SafeMath: multiplication overflow");
269 
270         return c;
271     }
272 
273     /**
274      * @dev Returns the integer division of two unsigned integers. Reverts on
275      * division by zero. The result is rounded towards zero.
276      *
277      * Counterpart to Solidity's `/` operator. Note: this function uses a
278      * `revert` opcode (which leaves remaining gas untouched) while Solidity
279      * uses an invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      * - The divisor cannot be zero.
283      */
284     function div(uint256 a, uint256 b) internal pure returns (uint256) {
285         return div(a, b, "SafeMath: division by zero");
286     }
287 
288     /**
289      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
290      * division by zero. The result is rounded towards zero.
291      *
292      * Counterpart to Solidity's `/` operator. Note: this function uses a
293      * `revert` opcode (which leaves remaining gas untouched) while Solidity
294      * uses an invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      * - The divisor cannot be zero.
298      *
299      * _Available since v2.4.0._
300      */
301     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         // Solidity only automatically asserts when dividing by 0
303         require(b > 0, errorMessage);
304         uint256 c = a / b;
305         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
306 
307         return c;
308     }
309 
310     /**
311      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
312      * Reverts when dividing by zero.
313      *
314      * Counterpart to Solidity's `%` operator. This function uses a `revert`
315      * opcode (which leaves remaining gas untouched) while Solidity uses an
316      * invalid opcode to revert (consuming all remaining gas).
317      *
318      * Requirements:
319      * - The divisor cannot be zero.
320      */
321     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
322         return mod(a, b, "SafeMath: modulo by zero");
323     }
324 
325     /**
326      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
327      * Reverts with custom message when dividing by zero.
328      *
329      * Counterpart to Solidity's `%` operator. This function uses a `revert`
330      * opcode (which leaves remaining gas untouched) while Solidity uses an
331      * invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      * - The divisor cannot be zero.
335      *
336      * _Available since v2.4.0._
337      */
338     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
339         require(b != 0, errorMessage);
340         return a % b;
341     }
342 }
343 
344 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
345 
346 pragma solidity ^0.5.0;
347 
348 
349 
350 
351 /**
352  * @dev Implementation of the {IERC20} interface.
353  *
354  * This implementation is agnostic to the way tokens are created. This means
355  * that a supply mechanism has to be added in a derived contract using {_mint}.
356  * For a generic mechanism see {ERC20Mintable}.
357  *
358  * TIP: For a detailed writeup see our guide
359  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
360  * to implement supply mechanisms].
361  *
362  * We have followed general OpenZeppelin guidelines: functions revert instead
363  * of returning `false` on failure. This behavior is nonetheless conventional
364  * and does not conflict with the expectations of ERC20 applications.
365  *
366  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
367  * This allows applications to reconstruct the allowance for all accounts just
368  * by listening to said events. Other implementations of the EIP may not emit
369  * these events, as it isn't required by the specification.
370  *
371  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
372  * functions have been added to mitigate the well-known issues around setting
373  * allowances. See {IERC20-approve}.
374  */
375 contract ERC20 is Context, IERC20 {
376     using SafeMath for uint256;
377 
378     mapping (address => uint256) private _balances;
379 
380     mapping (address => mapping (address => uint256)) private _allowances;
381 
382     uint256 private _totalSupply;
383 
384     /**
385      * @dev See {IERC20-totalSupply}.
386      */
387     function totalSupply() public view returns (uint256) {
388         return _totalSupply;
389     }
390 
391     /**
392      * @dev See {IERC20-balanceOf}.
393      */
394     function balanceOf(address account) public view returns (uint256) {
395         return _balances[account];
396     }
397 
398     /**
399      * @dev See {IERC20-transfer}.
400      *
401      * Requirements:
402      *
403      * - `recipient` cannot be the zero address.
404      * - the caller must have a balance of at least `amount`.
405      */
406     function transfer(address recipient, uint256 amount) public returns (bool) {
407         _transfer(_msgSender(), recipient, amount);
408         return true;
409     }
410 
411     /**
412      * @dev See {IERC20-allowance}.
413      */
414     function allowance(address owner, address spender) public view returns (uint256) {
415         return _allowances[owner][spender];
416     }
417 
418     /**
419      * @dev See {IERC20-approve}.
420      *
421      * Requirements:
422      *
423      * - `spender` cannot be the zero address.
424      */
425     function approve(address spender, uint256 amount) public returns (bool) {
426         _approve(_msgSender(), spender, amount);
427         return true;
428     }
429 
430     /**
431      * @dev See {IERC20-transferFrom}.
432      *
433      * Emits an {Approval} event indicating the updated allowance. This is not
434      * required by the EIP. See the note at the beginning of {ERC20};
435      *
436      * Requirements:
437      * - `sender` and `recipient` cannot be the zero address.
438      * - `sender` must have a balance of at least `amount`.
439      * - the caller must have allowance for `sender`'s tokens of at least
440      * `amount`.
441      */
442     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
443         _transfer(sender, recipient, amount);
444         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
445         return true;
446     }
447 
448     /**
449      * @dev Atomically increases the allowance granted to `spender` by the caller.
450      *
451      * This is an alternative to {approve} that can be used as a mitigation for
452      * problems described in {IERC20-approve}.
453      *
454      * Emits an {Approval} event indicating the updated allowance.
455      *
456      * Requirements:
457      *
458      * - `spender` cannot be the zero address.
459      */
460     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
461         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
462         return true;
463     }
464 
465     /**
466      * @dev Atomically decreases the allowance granted to `spender` by the caller.
467      *
468      * This is an alternative to {approve} that can be used as a mitigation for
469      * problems described in {IERC20-approve}.
470      *
471      * Emits an {Approval} event indicating the updated allowance.
472      *
473      * Requirements:
474      *
475      * - `spender` cannot be the zero address.
476      * - `spender` must have allowance for the caller of at least
477      * `subtractedValue`.
478      */
479     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
480         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
481         return true;
482     }
483 
484     /**
485      * @dev Moves tokens `amount` from `sender` to `recipient`.
486      *
487      * This is internal function is equivalent to {transfer}, and can be used to
488      * e.g. implement automatic token fees, slashing mechanisms, etc.
489      *
490      * Emits a {Transfer} event.
491      *
492      * Requirements:
493      *
494      * - `sender` cannot be the zero address.
495      * - `recipient` cannot be the zero address.
496      * - `sender` must have a balance of at least `amount`.
497      */
498     function _transfer(address sender, address recipient, uint256 amount) internal {
499         require(sender != address(0), "ERC20: transfer from the zero address");
500         require(recipient != address(0), "ERC20: transfer to the zero address");
501 
502         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
503         _balances[recipient] = _balances[recipient].add(amount);
504         emit Transfer(sender, recipient, amount);
505     }
506 
507     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
508      * the total supply.
509      *
510      * Emits a {Transfer} event with `from` set to the zero address.
511      *
512      * Requirements
513      *
514      * - `to` cannot be the zero address.
515      */
516     function _mint(address account, uint256 amount) internal {
517         require(account != address(0), "ERC20: mint to the zero address");
518 
519         _totalSupply = _totalSupply.add(amount);
520         _balances[account] = _balances[account].add(amount);
521         emit Transfer(address(0), account, amount);
522     }
523 
524     /**
525      * @dev Destroys `amount` tokens from `account`, reducing the
526      * total supply.
527      *
528      * Emits a {Transfer} event with `to` set to the zero address.
529      *
530      * Requirements
531      *
532      * - `account` cannot be the zero address.
533      * - `account` must have at least `amount` tokens.
534      */
535     function _burn(address account, uint256 amount) internal {
536         require(account != address(0), "ERC20: burn from the zero address");
537 
538         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
539         _totalSupply = _totalSupply.sub(amount);
540         emit Transfer(account, address(0), amount);
541     }
542 
543     /**
544      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
545      *
546      * This is internal function is equivalent to `approve`, and can be used to
547      * e.g. set automatic allowances for certain subsystems, etc.
548      *
549      * Emits an {Approval} event.
550      *
551      * Requirements:
552      *
553      * - `owner` cannot be the zero address.
554      * - `spender` cannot be the zero address.
555      */
556     function _approve(address owner, address spender, uint256 amount) internal {
557         require(owner != address(0), "ERC20: approve from the zero address");
558         require(spender != address(0), "ERC20: approve to the zero address");
559 
560         _allowances[owner][spender] = amount;
561         emit Approval(owner, spender, amount);
562     }
563 
564     /**
565      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
566      * from the caller's allowance.
567      *
568      * See {_burn} and {_approve}.
569      */
570     function _burnFrom(address account, uint256 amount) internal {
571         _burn(account, amount);
572         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
573     }
574 }
575 
576 // File: node_modules\@openzeppelin\contracts\access\Roles.sol
577 
578 pragma solidity ^0.5.0;
579 
580 /**
581  * @title Roles
582  * @dev Library for managing addresses assigned to a Role.
583  */
584 library Roles {
585     struct Role {
586         mapping (address => bool) bearer;
587     }
588 
589     /**
590      * @dev Give an account access to this role.
591      */
592     function add(Role storage role, address account) internal {
593         require(!has(role, account), "Roles: account already has role");
594         role.bearer[account] = true;
595     }
596 
597     /**
598      * @dev Remove an account's access to this role.
599      */
600     function remove(Role storage role, address account) internal {
601         require(has(role, account), "Roles: account does not have role");
602         role.bearer[account] = false;
603     }
604 
605     /**
606      * @dev Check if an account has this role.
607      * @return bool
608      */
609     function has(Role storage role, address account) internal view returns (bool) {
610         require(account != address(0), "Roles: account is the zero address");
611         return role.bearer[account];
612     }
613 }
614 
615 // File: node_modules\@openzeppelin\contracts\access\roles\MinterRole.sol
616 
617 pragma solidity ^0.5.0;
618 
619 
620 
621 contract MinterRole is Context {
622     using Roles for Roles.Role;
623 
624     event MinterAdded(address indexed account);
625     event MinterRemoved(address indexed account);
626 
627     Roles.Role private _minters;
628 
629     constructor () internal {
630         _addMinter(_msgSender());
631     }
632 
633     modifier onlyMinter() {
634         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
635         _;
636     }
637 
638     function isMinter(address account) public view returns (bool) {
639         return _minters.has(account);
640     }
641 
642     function addMinter(address account) public onlyMinter {
643         _addMinter(account);
644     }
645 
646     function renounceMinter() public {
647         _removeMinter(_msgSender());
648     }
649 
650     function _addMinter(address account) internal {
651         _minters.add(account);
652         emit MinterAdded(account);
653     }
654 
655     function _removeMinter(address account) internal {
656         _minters.remove(account);
657         emit MinterRemoved(account);
658     }
659 }
660 
661 // File: @openzeppelin\contracts\token\ERC20\ERC20Mintable.sol
662 
663 pragma solidity ^0.5.0;
664 
665 
666 
667 /**
668  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
669  * which have permission to mint (create) new tokens as they see fit.
670  *
671  * At construction, the deployer of the contract is the only minter.
672  */
673 contract ERC20Mintable is ERC20, MinterRole {
674     /**
675      * @dev See {ERC20-_mint}.
676      *
677      * Requirements:
678      *
679      * - the caller must have the {MinterRole}.
680      */
681     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
682         _mint(account, amount);
683         return true;
684     }
685 }
686 
687 // File: @openzeppelin\contracts\token\ERC20\ERC20Burnable.sol
688 
689 pragma solidity ^0.5.0;
690 
691 
692 
693 /**
694  * @dev Extension of {ERC20} that allows token holders to destroy both their own
695  * tokens and those that they have an allowance for, in a way that can be
696  * recognized off-chain (via event analysis).
697  */
698 contract ERC20Burnable is Context, ERC20 {
699     /**
700      * @dev Destroys `amount` tokens from the caller.
701      *
702      * See {ERC20-_burn}.
703      */
704     function burn(uint256 amount) public {
705         _burn(_msgSender(), amount);
706     }
707 
708     /**
709      * @dev See {ERC20-_burnFrom}.
710      */
711     function burnFrom(address account, uint256 amount) public {
712         _burnFrom(account, amount);
713     }
714 }
715 
716 // File: node_modules\@openzeppelin\contracts\access\roles\WhitelistAdminRole.sol
717 
718 pragma solidity ^0.5.0;
719 
720 
721 
722 /**
723  * @title WhitelistAdminRole
724  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
725  */
726 contract WhitelistAdminRole is Context {
727     using Roles for Roles.Role;
728 
729     event WhitelistAdminAdded(address indexed account);
730     event WhitelistAdminRemoved(address indexed account);
731 
732     Roles.Role private _whitelistAdmins;
733 
734     constructor () internal {
735         _addWhitelistAdmin(_msgSender());
736     }
737 
738     modifier onlyWhitelistAdmin() {
739         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
740         _;
741     }
742 
743     function isWhitelistAdmin(address account) public view returns (bool) {
744         return _whitelistAdmins.has(account);
745     }
746 
747     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
748         _addWhitelistAdmin(account);
749     }
750 
751     function renounceWhitelistAdmin() public {
752         _removeWhitelistAdmin(_msgSender());
753     }
754 
755     function _addWhitelistAdmin(address account) internal {
756         _whitelistAdmins.add(account);
757         emit WhitelistAdminAdded(account);
758     }
759 
760     function _removeWhitelistAdmin(address account) internal {
761         _whitelistAdmins.remove(account);
762         emit WhitelistAdminRemoved(account);
763     }
764 }
765 
766 // File: @openzeppelin\contracts\access\roles\WhitelistedRole.sol
767 
768 pragma solidity ^0.5.0;
769 
770 
771 
772 
773 /**
774  * @title WhitelistedRole
775  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
776  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
777  * it), and not Whitelisteds themselves.
778  */
779 contract WhitelistedRole is Context, WhitelistAdminRole {
780     using Roles for Roles.Role;
781 
782     event WhitelistedAdded(address indexed account);
783     event WhitelistedRemoved(address indexed account);
784 
785     Roles.Role private _whitelisteds;
786 
787     modifier onlyWhitelisted() {
788         require(isWhitelisted(_msgSender()), "WhitelistedRole: caller does not have the Whitelisted role");
789         _;
790     }
791 
792     function isWhitelisted(address account) public view returns (bool) {
793         return _whitelisteds.has(account);
794     }
795 
796     function addWhitelisted(address account) public onlyWhitelistAdmin {
797         _addWhitelisted(account);
798     }
799 
800     function removeWhitelisted(address account) public onlyWhitelistAdmin {
801         _removeWhitelisted(account);
802     }
803 
804     function renounceWhitelisted() public {
805         _removeWhitelisted(_msgSender());
806     }
807 
808     function _addWhitelisted(address account) internal {
809         _whitelisteds.add(account);
810         emit WhitelistedAdded(account);
811     }
812 
813     function _removeWhitelisted(address account) internal {
814         _whitelisteds.remove(account);
815         emit WhitelistedRemoved(account);
816     }
817 }
818 
819 // File: contracts\ICallable.sol
820 
821 pragma solidity ^0.5.16;
822 
823 interface ICallable {
824 
825     function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
826 
827 }
828 
829 // File: contracts\Token.sol
830 
831 pragma solidity ^0.5.16;
832 
833 
834 
835 
836 
837 
838 contract Token is ERC20Detailed, ERC20Mintable, ERC20Burnable, WhitelistedRole {
839 
840     using SafeMath for uint256;
841 
842     uint256 public feePercentage;
843 
844     constructor(
845         string memory _name,
846         string memory _symbol,
847         uint8 _decimals,
848         uint256 _initialSupplyWithoutDecimals,
849         uint256 _feePercentage
850     )
851     public
852     ERC20Detailed(_name, _symbol, _decimals)
853     {
854         feePercentage = _feePercentage;
855         _mint(msg.sender, _initialSupplyWithoutDecimals * (10 ** uint256(decimals())));
856     }
857 
858     function transfer(address _recipient, uint256 _amount) public returns (bool) {
859         uint actualAmount = _amount;
860 
861         if (!isWhitelisted(_recipient)) {
862             // calculate and burn transfer fee
863             uint256 fee = _amount.mul(feePercentage).div(100);
864             actualAmount = _amount.sub(fee);
865 
866             burn(fee);
867         }
868 
869         super.transfer(_recipient, actualAmount);
870         return true;
871     }
872 
873     function addWhitelisted(address[] calldata _accounts)
874     external
875     {
876         for (uint256 i = 0; i < _accounts.length; i++) {
877             addWhitelisted(_accounts[i]);
878         }
879     }
880 
881     function removeWhitelisted(address[] calldata _accounts)
882     external
883     {
884         for (uint256 i = 0; i < _accounts.length; i++) {
885             removeWhitelisted(_accounts[i]);
886         }
887     }
888 
889     function transferAndCall(address _to, uint256 _tokens, bytes calldata _data)
890     external
891     returns (bool)
892     {
893         transfer(_to, _tokens);
894         uint32 _size;
895         assembly {
896             _size := extcodesize(_to)
897         }
898         if (_size > 0) {
899             require(ICallable(_to).tokenCallback(msg.sender, _tokens, _data));
900         }
901         return true;
902     }
903 }