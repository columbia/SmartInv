1 /*
2 
3 _/\\\\\\\\\\\_______/\\\\\\\\\_____/\\\________/\\\_____/\\\\\\\\\\_______
4 /\\\/////////\\\___/\\\\\\\\\\\\\__\/\\\_______\/\\\___/\\\///////\\\_____
5 \//\\\______\///___/\\\/////////\\\_\//\\\______/\\\___\///______/\\\_____
6 __\////\\\_________\/\\\_______\/\\\__\//\\\____/\\\___________/\\\//_____
7 ______\////\\\______\/\\\\\\\\\\\\\\\___\//\\\__/\\\___________\////\\\___
8 __________\////\\\___\/\\\/////////\\\____\//\\\/\\\_______________\//\\\_
9 ____/\\\______\//\\\__\/\\\_______\/\\\_____\//\\\\\_______/\\\______/\\\_
10 ____\///\\\\\\\\\\\/___\/\\\_______\/\\\______\//\\\_______\///\\\\\\\\\/_
11 ______\///////////_____\///________\///________\///__________\/////////___
12 
13 Website: sav3.org
14 
15 SAV3 is an experimental uncensorable platform with no CEO, no servers, 
16 and no content policy, with one objective: save the world.
17 
18 How are liquidity providers incentivized?
19 
20 4% of all transfers are forever locked into liquidity, 4% are distributed 
21 to liquidity providers. Percents can be changed by the DAO.
22 
23 What is the governance?
24 
25 SAV3 is a DAO (forked from Compound), all governance decisions are voted 
26 on by SAV3 holders (on chain whenever possible).
27 
28 How is SAV3 distributed?
29 
30 It is fully distributed to whitelist participants from Nov 14 to Nov 15 (24h). 
31 The first to claim will receive 250% more than the last (bonding curve).
32 
33 */
34 
35 // File: @openzeppelin/contracts/GSN/Context.sol
36 
37 pragma solidity ^0.5.0;
38 
39 /*
40  * @dev Provides information about the current execution context, including the
41  * sender of the transaction and its data. While these are generally available
42  * via msg.sender and msg.data, they should not be accessed in such a direct
43  * manner, since when dealing with GSN meta-transactions the account sending and
44  * paying for execution may not be the actual sender (as far as an application
45  * is concerned).
46  *
47  * This contract is only required for intermediate, library-like contracts.
48  */
49 contract Context {
50     // Empty internal constructor, to prevent people from mistakenly deploying
51     // an instance of this contract, which should be used via inheritance.
52     constructor () internal { }
53     // solhint-disable-previous-line no-empty-blocks
54 
55     function _msgSender() internal view returns (address payable) {
56         return msg.sender;
57     }
58 
59     function _msgData() internal view returns (bytes memory) {
60         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
61         return msg.data;
62     }
63 }
64 
65 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
66 
67 pragma solidity ^0.5.0;
68 
69 /**
70  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
71  * the optional functions; to access them see {ERC20Detailed}.
72  */
73 interface IERC20 {
74     /**
75      * @dev Returns the amount of tokens in existence.
76      */
77     function totalSupply() external view returns (uint256);
78 
79     /**
80      * @dev Returns the amount of tokens owned by `account`.
81      */
82     function balanceOf(address account) external view returns (uint256);
83 
84     /**
85      * @dev Moves `amount` tokens from the caller's account to `recipient`.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transfer(address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Returns the remaining number of tokens that `spender` will be
95      * allowed to spend on behalf of `owner` through {transferFrom}. This is
96      * zero by default.
97      *
98      * This value changes when {approve} or {transferFrom} are called.
99      */
100     function allowance(address owner, address spender) external view returns (uint256);
101 
102     /**
103      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * IMPORTANT: Beware that changing an allowance with this method brings the risk
108      * that someone may use both the old and the new allowance by unfortunate
109      * transaction ordering. One possible solution to mitigate this race
110      * condition is to first reduce the spender's allowance to 0 and set the
111      * desired value afterwards:
112      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
113      *
114      * Emits an {Approval} event.
115      */
116     function approve(address spender, uint256 amount) external returns (bool);
117 
118     /**
119      * @dev Moves `amount` tokens from `sender` to `recipient` using the
120      * allowance mechanism. `amount` is then deducted from the caller's
121      * allowance.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Emitted when `value` tokens are moved from one account (`from`) to
131      * another (`to`).
132      *
133      * Note that `value` may be zero.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 value);
136 
137     /**
138      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
139      * a call to {approve}. `value` is the new allowance.
140      */
141     event Approval(address indexed owner, address indexed spender, uint256 value);
142 }
143 
144 // File: @openzeppelin/contracts/math/SafeMath.sol
145 
146 pragma solidity ^0.5.0;
147 
148 /**
149  * @dev Wrappers over Solidity's arithmetic operations with added overflow
150  * checks.
151  *
152  * Arithmetic operations in Solidity wrap on overflow. This can easily result
153  * in bugs, because programmers usually assume that an overflow raises an
154  * error, which is the standard behavior in high level programming languages.
155  * `SafeMath` restores this intuition by reverting the transaction when an
156  * operation overflows.
157  *
158  * Using this library instead of the unchecked operations eliminates an entire
159  * class of bugs, so it's recommended to use it always.
160  */
161 library SafeMath {
162     /**
163      * @dev Returns the addition of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `+` operator.
167      *
168      * Requirements:
169      * - Addition cannot overflow.
170      */
171     function add(uint256 a, uint256 b) internal pure returns (uint256) {
172         uint256 c = a + b;
173         require(c >= a, "SafeMath: addition overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the subtraction of two unsigned integers, reverting on
180      * overflow (when the result is negative).
181      *
182      * Counterpart to Solidity's `-` operator.
183      *
184      * Requirements:
185      * - Subtraction cannot overflow.
186      */
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         return sub(a, b, "SafeMath: subtraction overflow");
189     }
190 
191     /**
192      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
193      * overflow (when the result is negative).
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      * - Subtraction cannot overflow.
199      *
200      * _Available since v2.4.0._
201      */
202     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b <= a, errorMessage);
204         uint256 c = a - b;
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the multiplication of two unsigned integers, reverting on
211      * overflow.
212      *
213      * Counterpart to Solidity's `*` operator.
214      *
215      * Requirements:
216      * - Multiplication cannot overflow.
217      */
218     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
219         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
220         // benefit is lost if 'b' is also tested.
221         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
222         if (a == 0) {
223             return 0;
224         }
225 
226         uint256 c = a * b;
227         require(c / a == b, "SafeMath: multiplication overflow");
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers. Reverts on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      * - The divisor cannot be zero.
242      */
243     function div(uint256 a, uint256 b) internal pure returns (uint256) {
244         return div(a, b, "SafeMath: division by zero");
245     }
246 
247     /**
248      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
249      * division by zero. The result is rounded towards zero.
250      *
251      * Counterpart to Solidity's `/` operator. Note: this function uses a
252      * `revert` opcode (which leaves remaining gas untouched) while Solidity
253      * uses an invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      * - The divisor cannot be zero.
257      *
258      * _Available since v2.4.0._
259      */
260     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         // Solidity only automatically asserts when dividing by 0
262         require(b > 0, errorMessage);
263         uint256 c = a / b;
264         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
265 
266         return c;
267     }
268 
269     /**
270      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
271      * Reverts when dividing by zero.
272      *
273      * Counterpart to Solidity's `%` operator. This function uses a `revert`
274      * opcode (which leaves remaining gas untouched) while Solidity uses an
275      * invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      * - The divisor cannot be zero.
279      */
280     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
281         return mod(a, b, "SafeMath: modulo by zero");
282     }
283 
284     /**
285      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
286      * Reverts with custom message when dividing by zero.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      * - The divisor cannot be zero.
294      *
295      * _Available since v2.4.0._
296      */
297     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b != 0, errorMessage);
299         return a % b;
300     }
301 }
302 
303 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
304 
305 pragma solidity ^0.5.0;
306 
307 /**
308  * @dev Implementation of the {IERC20} interface.
309  *
310  * This implementation is agnostic to the way tokens are created. This means
311  * that a supply mechanism has to be added in a derived contract using {_mint}.
312  * For a generic mechanism see {ERC20Mintable}.
313  *
314  * TIP: For a detailed writeup see our guide
315  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
316  * to implement supply mechanisms].
317  *
318  * We have followed general OpenZeppelin guidelines: functions revert instead
319  * of returning `false` on failure. This behavior is nonetheless conventional
320  * and does not conflict with the expectations of ERC20 applications.
321  *
322  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
323  * This allows applications to reconstruct the allowance for all accounts just
324  * by listening to said events. Other implementations of the EIP may not emit
325  * these events, as it isn't required by the specification.
326  *
327  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
328  * functions have been added to mitigate the well-known issues around setting
329  * allowances. See {IERC20-approve}.
330  */
331 contract ERC20 is Context, IERC20 {
332     using SafeMath for uint256;
333 
334     mapping (address => uint256) private _balances;
335 
336     mapping (address => mapping (address => uint256)) private _allowances;
337 
338     uint256 private _totalSupply;
339 
340     /**
341      * @dev See {IERC20-totalSupply}.
342      */
343     function totalSupply() public view returns (uint256) {
344         return _totalSupply;
345     }
346 
347     /**
348      * @dev See {IERC20-balanceOf}.
349      */
350     function balanceOf(address account) public view returns (uint256) {
351         return _balances[account];
352     }
353 
354     /**
355      * @dev See {IERC20-transfer}.
356      *
357      * Requirements:
358      *
359      * - `recipient` cannot be the zero address.
360      * - the caller must have a balance of at least `amount`.
361      */
362     function transfer(address recipient, uint256 amount) public returns (bool) {
363         _transfer(_msgSender(), recipient, amount);
364         return true;
365     }
366 
367     /**
368      * @dev See {IERC20-allowance}.
369      */
370     function allowance(address owner, address spender) public view returns (uint256) {
371         return _allowances[owner][spender];
372     }
373 
374     /**
375      * @dev See {IERC20-approve}.
376      *
377      * Requirements:
378      *
379      * - `spender` cannot be the zero address.
380      */
381     function approve(address spender, uint256 amount) public returns (bool) {
382         _approve(_msgSender(), spender, amount);
383         return true;
384     }
385 
386     /**
387      * @dev See {IERC20-transferFrom}.
388      *
389      * Emits an {Approval} event indicating the updated allowance. This is not
390      * required by the EIP. See the note at the beginning of {ERC20};
391      *
392      * Requirements:
393      * - `sender` and `recipient` cannot be the zero address.
394      * - `sender` must have a balance of at least `amount`.
395      * - the caller must have allowance for `sender`'s tokens of at least
396      * `amount`.
397      */
398     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
399         _transfer(sender, recipient, amount);
400         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
401         return true;
402     }
403 
404     /**
405      * @dev Atomically increases the allowance granted to `spender` by the caller.
406      *
407      * This is an alternative to {approve} that can be used as a mitigation for
408      * problems described in {IERC20-approve}.
409      *
410      * Emits an {Approval} event indicating the updated allowance.
411      *
412      * Requirements:
413      *
414      * - `spender` cannot be the zero address.
415      */
416     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
417         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
418         return true;
419     }
420 
421     /**
422      * @dev Atomically decreases the allowance granted to `spender` by the caller.
423      *
424      * This is an alternative to {approve} that can be used as a mitigation for
425      * problems described in {IERC20-approve}.
426      *
427      * Emits an {Approval} event indicating the updated allowance.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      * - `spender` must have allowance for the caller of at least
433      * `subtractedValue`.
434      */
435     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
436         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
437         return true;
438     }
439 
440     /**
441      * @dev Moves tokens `amount` from `sender` to `recipient`.
442      *
443      * This is internal function is equivalent to {transfer}, and can be used to
444      * e.g. implement automatic token fees, slashing mechanisms, etc.
445      *
446      * Emits a {Transfer} event.
447      *
448      * Requirements:
449      *
450      * - `sender` cannot be the zero address.
451      * - `recipient` cannot be the zero address.
452      * - `sender` must have a balance of at least `amount`.
453      */
454     function _transfer(address sender, address recipient, uint256 amount) internal {
455         require(sender != address(0), "ERC20: transfer from the zero address");
456         require(recipient != address(0), "ERC20: transfer to the zero address");
457 
458         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
459         _balances[recipient] = _balances[recipient].add(amount);
460         emit Transfer(sender, recipient, amount);
461     }
462 
463     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
464      * the total supply.
465      *
466      * Emits a {Transfer} event with `from` set to the zero address.
467      *
468      * Requirements
469      *
470      * - `to` cannot be the zero address.
471      */
472     function _mint(address account, uint256 amount) internal {
473         require(account != address(0), "ERC20: mint to the zero address");
474 
475         _totalSupply = _totalSupply.add(amount);
476         _balances[account] = _balances[account].add(amount);
477         emit Transfer(address(0), account, amount);
478     }
479 
480     /**
481      * @dev Destroys `amount` tokens from `account`, reducing the
482      * total supply.
483      *
484      * Emits a {Transfer} event with `to` set to the zero address.
485      *
486      * Requirements
487      *
488      * - `account` cannot be the zero address.
489      * - `account` must have at least `amount` tokens.
490      */
491     function _burn(address account, uint256 amount) internal {
492         require(account != address(0), "ERC20: burn from the zero address");
493 
494         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
495         _totalSupply = _totalSupply.sub(amount);
496         emit Transfer(account, address(0), amount);
497     }
498 
499     /**
500      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
501      *
502      * This is internal function is equivalent to `approve`, and can be used to
503      * e.g. set automatic allowances for certain subsystems, etc.
504      *
505      * Emits an {Approval} event.
506      *
507      * Requirements:
508      *
509      * - `owner` cannot be the zero address.
510      * - `spender` cannot be the zero address.
511      */
512     function _approve(address owner, address spender, uint256 amount) internal {
513         require(owner != address(0), "ERC20: approve from the zero address");
514         require(spender != address(0), "ERC20: approve to the zero address");
515 
516         _allowances[owner][spender] = amount;
517         emit Approval(owner, spender, amount);
518     }
519 
520     /**
521      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
522      * from the caller's allowance.
523      *
524      * See {_burn} and {_approve}.
525      */
526     function _burnFrom(address account, uint256 amount) internal {
527         _burn(account, amount);
528         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
529     }
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
533 
534 pragma solidity ^0.5.0;
535 
536 /**
537  * @dev Extension of {ERC20} that allows token holders to destroy both their own
538  * tokens and those that they have an allowance for, in a way that can be
539  * recognized off-chain (via event analysis).
540  */
541 contract ERC20Burnable is Context, ERC20 {
542     /**
543      * @dev Destroys `amount` tokens from the caller.
544      *
545      * See {ERC20-_burn}.
546      */
547     function burn(uint256 amount) public {
548         _burn(_msgSender(), amount);
549     }
550 
551     /**
552      * @dev See {ERC20-_burnFrom}.
553      */
554     function burnFrom(address account, uint256 amount) public {
555         _burnFrom(account, amount);
556     }
557 }
558 
559 // File: @openzeppelin/contracts/access/Roles.sol
560 
561 pragma solidity ^0.5.0;
562 
563 /**
564  * @title Roles
565  * @dev Library for managing addresses assigned to a Role.
566  */
567 library Roles {
568     struct Role {
569         mapping (address => bool) bearer;
570     }
571 
572     /**
573      * @dev Give an account access to this role.
574      */
575     function add(Role storage role, address account) internal {
576         require(!has(role, account), "Roles: account already has role");
577         role.bearer[account] = true;
578     }
579 
580     /**
581      * @dev Remove an account's access to this role.
582      */
583     function remove(Role storage role, address account) internal {
584         require(has(role, account), "Roles: account does not have role");
585         role.bearer[account] = false;
586     }
587 
588     /**
589      * @dev Check if an account has this role.
590      * @return bool
591      */
592     function has(Role storage role, address account) internal view returns (bool) {
593         require(account != address(0), "Roles: account is the zero address");
594         return role.bearer[account];
595     }
596 }
597 
598 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
599 
600 pragma solidity ^0.5.0;
601 
602 contract MinterRole is Context {
603     using Roles for Roles.Role;
604 
605     event MinterAdded(address indexed account);
606     event MinterRemoved(address indexed account);
607 
608     Roles.Role private _minters;
609 
610     constructor () internal {
611         _addMinter(_msgSender());
612     }
613 
614     modifier onlyMinter() {
615         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
616         _;
617     }
618 
619     function isMinter(address account) public view returns (bool) {
620         return _minters.has(account);
621     }
622 
623     function addMinter(address account) public onlyMinter {
624         _addMinter(account);
625     }
626 
627     function renounceMinter() public {
628         _removeMinter(_msgSender());
629     }
630 
631     function _addMinter(address account) internal {
632         _minters.add(account);
633         emit MinterAdded(account);
634     }
635 
636     function _removeMinter(address account) internal {
637         _minters.remove(account);
638         emit MinterRemoved(account);
639     }
640 }
641 
642 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
643 
644 pragma solidity ^0.5.0;
645 
646 /**
647  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
648  * which have permission to mint (create) new tokens as they see fit.
649  *
650  * At construction, the deployer of the contract is the only minter.
651  */
652 contract ERC20Mintable is ERC20, MinterRole {
653     /**
654      * @dev See {ERC20-_mint}.
655      *
656      * Requirements:
657      *
658      * - the caller must have the {MinterRole}.
659      */
660     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
661         _mint(account, amount);
662         return true;
663     }
664 }
665 
666 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
667 
668 pragma solidity ^0.5.0;
669 
670 /**
671  * @dev Optional functions from the ERC20 standard.
672  */
673 contract ERC20Detailed is IERC20 {
674     string private _name;
675     string private _symbol;
676     uint8 private _decimals;
677 
678     /**
679      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
680      * these values are immutable: they can only be set once during
681      * construction.
682      */
683     constructor (string memory name, string memory symbol, uint8 decimals) public {
684         _name = name;
685         _symbol = symbol;
686         _decimals = decimals;
687     }
688 
689     /**
690      * @dev Returns the name of the token.
691      */
692     function name() public view returns (string memory) {
693         return _name;
694     }
695 
696     /**
697      * @dev Returns the symbol of the token, usually a shorter version of the
698      * name.
699      */
700     function symbol() public view returns (string memory) {
701         return _symbol;
702     }
703 
704     /**
705      * @dev Returns the number of decimals used to get its user representation.
706      * For example, if `decimals` equals `2`, a balance of `505` tokens should
707      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
708      *
709      * Tokens usually opt for a value of 18, imitating the relationship between
710      * Ether and Wei.
711      *
712      * NOTE: This information is only used for _display_ purposes: it in
713      * no way affects any of the arithmetic of the contract, including
714      * {IERC20-balanceOf} and {IERC20-transfer}.
715      */
716     function decimals() public view returns (uint8) {
717         return _decimals;
718     }
719 }
720 
721 // File: @openzeppelin/contracts/access/roles/WhitelistAdminRole.sol
722 
723 pragma solidity ^0.5.0;
724 
725 /**
726  * @title WhitelistAdminRole
727  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
728  */
729 contract WhitelistAdminRole is Context {
730     using Roles for Roles.Role;
731 
732     event WhitelistAdminAdded(address indexed account);
733     event WhitelistAdminRemoved(address indexed account);
734 
735     Roles.Role private _whitelistAdmins;
736 
737     constructor () internal {
738         _addWhitelistAdmin(_msgSender());
739     }
740 
741     modifier onlyWhitelistAdmin() {
742         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
743         _;
744     }
745 
746     function isWhitelistAdmin(address account) public view returns (bool) {
747         return _whitelistAdmins.has(account);
748     }
749 
750     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
751         _addWhitelistAdmin(account);
752     }
753 
754     function renounceWhitelistAdmin() public {
755         _removeWhitelistAdmin(_msgSender());
756     }
757 
758     function _addWhitelistAdmin(address account) internal {
759         _whitelistAdmins.add(account);
760         emit WhitelistAdminAdded(account);
761     }
762 
763     function _removeWhitelistAdmin(address account) internal {
764         _whitelistAdmins.remove(account);
765         emit WhitelistAdminRemoved(account);
766     }
767 }
768 
769 // File: contracts/ERC20/ERC20TransferLiquidityLock.sol
770 
771 pragma solidity ^0.5.17;
772 
773 contract ERC20TransferLiquidityLock is ERC20 {
774     using SafeMath for uint256;
775 
776     event LockLiquidity(uint256 tokenAmount, uint256 ethAmount);
777     event BurnLiquidity(uint256 lpTokenAmount);
778     event RewardLiquidityProviders(uint256 tokenAmount);
779 
780     address public uniswapV2Router;
781     address public uniswapV2Pair;
782 
783     // the amount of tokens to lock for liquidity during every transfer, i.e. 100 = 1%, 50 = 2%, 40 = 2.5%
784     uint256 public liquidityLockDivisor;
785     uint256 public liquidityRewardsDivisor;
786 
787     function _transfer(address from, address to, uint256 amount) internal {
788         // calculate liquidity lock amount
789         // dont transfer burn from this contract
790         // or can never lock full lockable amount
791         if (liquidityLockDivisor != 0 && from != address(this)) {
792             uint256 liquidityLockAmount = amount.div(liquidityLockDivisor);
793             super._transfer(from, address(this), liquidityLockAmount);
794             super._transfer(from, to, amount.sub(liquidityLockAmount));
795         }
796         else {
797             super._transfer(from, to, amount);
798         }
799     }
800 
801     // receive eth from uniswap swap
802     function () external payable {}
803 
804     function lockLiquidity(uint256 _lockableSupply) public {
805         // lockable supply is the token balance of this contract
806         require(_lockableSupply <= balanceOf(address(this)), "ERC20TransferLiquidityLock::lockLiquidity: lock amount higher than lockable balance");
807         require(_lockableSupply != 0, "ERC20TransferLiquidityLock::lockLiquidity: lock amount cannot be 0");
808 
809         // reward liquidity providers if needed
810         if (liquidityRewardsDivisor != 0) {
811             // if no balance left to lock, don't lock
812             if (liquidityRewardsDivisor == 1) {
813                 _rewardLiquidityProviders(_lockableSupply);
814                 return;
815             }
816 
817             uint256 liquidityRewards = _lockableSupply.div(liquidityRewardsDivisor);
818             _lockableSupply = _lockableSupply.sub(liquidityRewards);
819             _rewardLiquidityProviders(liquidityRewards);
820         }
821 
822         uint256 amountToSwapForEth = _lockableSupply.div(2);
823         uint256 amountToAddLiquidity = _lockableSupply.sub(amountToSwapForEth);
824 
825         // needed in case contract already owns eth
826         uint256 ethBalanceBeforeSwap = address(this).balance;
827         swapTokensForEth(amountToSwapForEth);
828         uint256 ethReceived = address(this).balance.sub(ethBalanceBeforeSwap);
829 
830         addLiquidity(amountToAddLiquidity, ethReceived);
831         emit LockLiquidity(amountToAddLiquidity, ethReceived);
832     }
833 
834     // external util so anyone can easily distribute rewards
835     // must call lockLiquidity first which automatically
836     // calls _rewardLiquidityProviders
837     function rewardLiquidityProviders() external {
838         // lock everything that is lockable
839         lockLiquidity(balanceOf(address(this)));
840     }
841 
842     function _rewardLiquidityProviders(uint256 liquidityRewards) private {
843         // avoid burn by calling super._transfer directly
844         super._transfer(address(this), uniswapV2Pair, liquidityRewards);
845         IUniswapV2Pair(uniswapV2Pair).sync();
846         emit RewardLiquidityProviders(liquidityRewards);
847     }
848 
849     function burnLiquidity() external {
850         uint256 balance = ERC20(uniswapV2Pair).balanceOf(address(this));
851         require(balance != 0, "ERC20TransferLiquidityLock::burnLiquidity: burn amount cannot be 0");
852         ERC20(uniswapV2Pair).transfer(address(0), balance);
853         emit BurnLiquidity(balance);
854     }
855 
856     function swapTokensForEth(uint256 tokenAmount) private {
857         address[] memory uniswapPairPath = new address[](2);
858         uniswapPairPath[0] = address(this);
859         uniswapPairPath[1] = IUniswapV2Router02(uniswapV2Router).WETH();
860 
861         _approve(address(this), uniswapV2Router, tokenAmount);
862 
863         IUniswapV2Router02(uniswapV2Router)
864             .swapExactTokensForETHSupportingFeeOnTransferTokens(
865                 tokenAmount,
866                 0,
867                 uniswapPairPath,
868                 address(this),
869                 block.timestamp
870             );
871     }
872 
873     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
874         _approve(address(this), uniswapV2Router, tokenAmount);
875 
876         IUniswapV2Router02(uniswapV2Router)
877             .addLiquidityETH
878             .value(ethAmount)(
879                 address(this),
880                 tokenAmount,
881                 0,
882                 0,
883                 address(this),
884                 block.timestamp
885             );
886     }
887 
888     // returns token amount
889     function lockableSupply() external view returns (uint256) {
890         return balanceOf(address(this));
891     }
892 
893     // returns token amount
894     function lockedSupply() external view returns (uint256) {
895         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
896         uint256 lpBalance = lockedLiquidity();
897         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
898 
899         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
900         uint256 _lockedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
901         return _lockedSupply;
902     }
903 
904     // returns token amount
905     function burnedSupply() external view returns (uint256) {
906         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
907         uint256 lpBalance = burnedLiquidity();
908         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
909 
910         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
911         uint256 _burnedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
912         return _burnedSupply;
913     }
914 
915     // returns LP amount, not token amount
916     function burnableLiquidity() public view returns (uint256) {
917         return ERC20(uniswapV2Pair).balanceOf(address(this));
918     }
919 
920     // returns LP amount, not token amount
921     function burnedLiquidity() public view returns (uint256) {
922         return ERC20(uniswapV2Pair).balanceOf(address(0));
923     }
924 
925     // returns LP amount, not token amount
926     function lockedLiquidity() public view returns (uint256) {
927         return burnableLiquidity().add(burnedLiquidity());
928     }
929 }
930 
931 interface IUniswapV2Router02 {
932     function WETH() external pure returns (address);
933     function swapExactTokensForETHSupportingFeeOnTransferTokens(
934         uint amountIn,
935         uint amountOutMin,
936         address[] calldata path,
937         address to,
938         uint deadline
939     ) external;
940     function addLiquidityETH(
941         address token,
942         uint amountTokenDesired,
943         uint amountTokenMin,
944         uint amountETHMin,
945         address to,
946         uint deadline
947     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
948 }
949 
950 interface IUniswapV2Pair {
951     function sync() external;
952 }
953 
954 // File: contracts/ERC20/ERC20Governance.sol
955 
956 pragma solidity ^0.5.17;
957 
958 contract ERC20Governance is ERC20, ERC20Detailed {
959     using SafeMath for uint256;
960 
961     function _transfer(address from, address to, uint256 amount) internal {
962         _moveDelegates(_delegates[from], _delegates[to], amount);
963         super._transfer(from, to, amount);
964     }
965 
966     function _mint(address account, uint256 amount) internal {
967         _moveDelegates(address(0), _delegates[account], amount);
968         super._mint(account, amount);
969     }
970 
971     function _burn(address account, uint256 amount) internal {
972         _moveDelegates(_delegates[account], address(0), amount);
973         super._burn(account, amount);
974     }
975 
976     // Copied and modified from YAM code:
977     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
978     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
979     // Which is copied and modified from COMPOUND:
980     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
981 
982     /// @notice A record of each accounts delegate
983     mapping (address => address) internal _delegates;
984 
985     /// @notice A checkpoint for marking number of votes from a given block
986     struct Checkpoint {
987         uint32 fromBlock;
988         uint256 votes;
989     }
990 
991     /// @notice A record of votes checkpoints for each account, by index
992     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
993 
994     /// @notice The number of checkpoints for each account
995     mapping (address => uint32) public numCheckpoints;
996 
997     /// @notice The EIP-712 typehash for the contract's domain
998     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
999 
1000     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1001     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1002 
1003     /// @notice A record of states for signing / validating signatures
1004     mapping (address => uint) public nonces;
1005 
1006       /// @notice An event thats emitted when an account changes its delegate
1007     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1008 
1009     /// @notice An event thats emitted when a delegate account's vote balance changes
1010     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1011 
1012     /**
1013      * @notice Delegate votes from `msg.sender` to `delegatee`
1014      * @param delegator The address to get delegatee for
1015      */
1016     function delegates(address delegator)
1017         external
1018         view
1019         returns (address)
1020     {
1021         return _delegates[delegator];
1022     }
1023 
1024    /**
1025     * @notice Delegate votes from `msg.sender` to `delegatee`
1026     * @param delegatee The address to delegate votes to
1027     */
1028     function delegate(address delegatee) external {
1029         return _delegate(msg.sender, delegatee);
1030     }
1031 
1032     /**
1033      * @notice Delegates votes from signatory to `delegatee`
1034      * @param delegatee The address to delegate votes to
1035      * @param nonce The contract state required to match the signature
1036      * @param expiry The time at which to expire the signature
1037      * @param v The recovery byte of the signature
1038      * @param r Half of the ECDSA signature pair
1039      * @param s Half of the ECDSA signature pair
1040      */
1041     function delegateBySig(
1042         address delegatee,
1043         uint nonce,
1044         uint expiry,
1045         uint8 v,
1046         bytes32 r,
1047         bytes32 s
1048     )
1049         external
1050     {
1051         bytes32 domainSeparator = keccak256(
1052             abi.encode(
1053                 DOMAIN_TYPEHASH,
1054                 keccak256(bytes(name())),
1055                 getChainId(),
1056                 address(this)
1057             )
1058         );
1059 
1060         bytes32 structHash = keccak256(
1061             abi.encode(
1062                 DELEGATION_TYPEHASH,
1063                 delegatee,
1064                 nonce,
1065                 expiry
1066             )
1067         );
1068 
1069         bytes32 digest = keccak256(
1070             abi.encodePacked(
1071                 "\x19\x01",
1072                 domainSeparator,
1073                 structHash
1074             )
1075         );
1076 
1077         address signatory = ecrecover(digest, v, r, s);
1078         require(signatory != address(0), "ERC20Governance::delegateBySig: invalid signature");
1079         require(nonce == nonces[signatory]++, "ERC20Governance::delegateBySig: invalid nonce");
1080         require(now <= expiry, "ERC20Governance::delegateBySig: signature expired");
1081         return _delegate(signatory, delegatee);
1082     }
1083 
1084     /**
1085      * @notice Gets the current votes balance for `account`
1086      * @param account The address to get votes balance
1087      * @return The number of current votes for `account`
1088      */
1089     function getCurrentVotes(address account)
1090         external
1091         view
1092         returns (uint256)
1093     {
1094         uint32 nCheckpoints = numCheckpoints[account];
1095         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1096     }
1097 
1098     /**
1099      * @notice Determine the prior number of votes for an account as of a block number
1100      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1101      * @param account The address of the account to check
1102      * @param blockNumber The block number to get the vote balance at
1103      * @return The number of votes the account had as of the given block
1104      */
1105     function getPriorVotes(address account, uint blockNumber)
1106         external
1107         view
1108         returns (uint256)
1109     {
1110         require(blockNumber < block.number, "ERC20Governance::getPriorVotes: not yet determined");
1111 
1112         uint32 nCheckpoints = numCheckpoints[account];
1113         if (nCheckpoints == 0) {
1114             return 0;
1115         }
1116 
1117         // First check most recent balance
1118         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1119             return checkpoints[account][nCheckpoints - 1].votes;
1120         }
1121 
1122         // Next check implicit zero balance
1123         if (checkpoints[account][0].fromBlock > blockNumber) {
1124             return 0;
1125         }
1126 
1127         uint32 lower = 0;
1128         uint32 upper = nCheckpoints - 1;
1129         while (upper > lower) {
1130             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1131             Checkpoint memory cp = checkpoints[account][center];
1132             if (cp.fromBlock == blockNumber) {
1133                 return cp.votes;
1134             } else if (cp.fromBlock < blockNumber) {
1135                 lower = center;
1136             } else {
1137                 upper = center - 1;
1138             }
1139         }
1140         return checkpoints[account][lower].votes;
1141     }
1142 
1143     function _delegate(address delegator, address delegatee)
1144         internal
1145     {
1146         address currentDelegate = _delegates[delegator];
1147         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying ERC20Governances (not scaled);
1148         _delegates[delegator] = delegatee;
1149 
1150         emit DelegateChanged(delegator, currentDelegate, delegatee);
1151 
1152         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1153     }
1154 
1155     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1156         if (srcRep != dstRep && amount > 0) {
1157             if (srcRep != address(0)) {
1158                 // decrease old representative
1159                 uint32 srcRepNum = numCheckpoints[srcRep];
1160                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1161                 uint256 srcRepNew = srcRepOld.sub(amount);
1162                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1163             }
1164 
1165             if (dstRep != address(0)) {
1166                 // increase new representative
1167                 uint32 dstRepNum = numCheckpoints[dstRep];
1168                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1169                 uint256 dstRepNew = dstRepOld.add(amount);
1170                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1171             }
1172         }
1173     }
1174 
1175     function _writeCheckpoint(
1176         address delegatee,
1177         uint32 nCheckpoints,
1178         uint256 oldVotes,
1179         uint256 newVotes
1180     )
1181         internal
1182     {
1183         uint32 blockNumber = safe32(block.number, "ERC20Governance::_writeCheckpoint: block number exceeds 32 bits");
1184 
1185         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1186             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1187         } else {
1188             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1189             numCheckpoints[delegatee] = nCheckpoints + 1;
1190         }
1191 
1192         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1193     }
1194 
1195     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1196         require(n < 2**32, errorMessage);
1197         return uint32(n);
1198     }
1199 
1200     function getChainId() internal pure returns (uint) {
1201         uint256 chainId;
1202         assembly { chainId := chainid() }
1203         return chainId;
1204     }
1205 }
1206 
1207 // File: contracts/Sav3Token.sol
1208 
1209 pragma solidity ^0.5.17;
1210 
1211 contract Sav3Token is 
1212     ERC20, 
1213     ERC20Detailed("Sav3Token", "SAV3", 18), 
1214     ERC20Burnable, 
1215     ERC20Mintable,
1216     // governance must be before transfer liquidity lock
1217     // or delegates are not updated correctly
1218     ERC20Governance,
1219     ERC20TransferLiquidityLock,
1220     WhitelistAdminRole 
1221 {
1222     function setUniswapV2Router(address _uniswapV2Router) public onlyWhitelistAdmin {
1223         require(uniswapV2Router == address(0), "Sav3Token::setUniswapV2Router: already set");
1224         uniswapV2Router = _uniswapV2Router;
1225     }
1226 
1227     function setUniswapV2Pair(address _uniswapV2Pair) public onlyWhitelistAdmin {
1228         require(uniswapV2Pair == address(0), "Sav3Token::setUniswapV2Pair: already set");
1229         uniswapV2Pair = _uniswapV2Pair;
1230     }
1231 
1232     function setLiquidityLockDivisor(uint256 _liquidityLockDivisor) public onlyWhitelistAdmin {
1233         if (_liquidityLockDivisor != 0) {
1234             require(_liquidityLockDivisor >= 10, "Sav3Token::setLiquidityLockDivisor: too small");
1235         }
1236         liquidityLockDivisor = _liquidityLockDivisor;
1237     }
1238 
1239     function setLiquidityRewardsDivisor(uint256 _liquidityRewardsDivisor) public onlyWhitelistAdmin {
1240         liquidityRewardsDivisor = _liquidityRewardsDivisor;
1241     }
1242 }