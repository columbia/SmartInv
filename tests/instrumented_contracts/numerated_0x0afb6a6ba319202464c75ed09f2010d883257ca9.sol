1 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
2 
3 // pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 
32 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
33 
34 // pragma solidity ^0.5.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
38  * the optional functions; to access them see {ERC20Detailed}.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * // importANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
113 
114 // pragma solidity ^0.5.0;
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      * - Subtraction cannot overflow.
167      *
168      * _Available since v2.4.0._
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      * - The divisor cannot be zero.
225      *
226      * _Available since v2.4.0._
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         // Solidity only automatically asserts when dividing by 0
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      * - The divisor cannot be zero.
262      *
263      * _Available since v2.4.0._
264      */
265     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 
272 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20.sol
273 
274 // pragma solidity ^0.5.0;
275 
276 // import "@openzeppelin/contracts/GSN/Context.sol";
277 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
278 // import "@openzeppelin/contracts/math/SafeMath.sol";
279 
280 /**
281  * @dev Implementation of the {IERC20} interface.
282  *
283  * This implementation is agnostic to the way tokens are created. This means
284  * that a supply mechanism has to be added in a derived contract using {_mint}.
285  * For a generic mechanism see {ERC20Mintable}.
286  *
287  * TIP: For a detailed writeup see our guide
288  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
289  * to implement supply mechanisms].
290  *
291  * We have followed general OpenZeppelin guidelines: functions revert instead
292  * of returning `false` on failure. This behavior is nonetheless conventional
293  * and does not conflict with the expectations of ERC20 applications.
294  *
295  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
296  * This allows applications to reconstruct the allowance for all accounts just
297  * by listening to said events. Other implementations of the EIP may not emit
298  * these events, as it isn't required by the specification.
299  *
300  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
301  * functions have been added to mitigate the well-known issues around setting
302  * allowances. See {IERC20-approve}.
303  */
304 contract ERC20 is Context, IERC20 {
305     using SafeMath for uint256;
306 
307     mapping (address => uint256) private _balances;
308 
309     mapping (address => mapping (address => uint256)) private _allowances;
310 
311     uint256 private _totalSupply;
312 
313     /**
314      * @dev See {IERC20-totalSupply}.
315      */
316     function totalSupply() public view returns (uint256) {
317         return _totalSupply;
318     }
319 
320     /**
321      * @dev See {IERC20-balanceOf}.
322      */
323     function balanceOf(address account) public view returns (uint256) {
324         return _balances[account];
325     }
326 
327     /**
328      * @dev See {IERC20-transfer}.
329      *
330      * Requirements:
331      *
332      * - `recipient` cannot be the zero address.
333      * - the caller must have a balance of at least `amount`.
334      */
335     function transfer(address recipient, uint256 amount) public returns (bool) {
336         _transfer(_msgSender(), recipient, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-allowance}.
342      */
343     function allowance(address owner, address spender) public view returns (uint256) {
344         return _allowances[owner][spender];
345     }
346 
347     /**
348      * @dev See {IERC20-approve}.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      */
354     function approve(address spender, uint256 amount) public returns (bool) {
355         _approve(_msgSender(), spender, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-transferFrom}.
361      *
362      * Emits an {Approval} event indicating the updated allowance. This is not
363      * required by the EIP. See the note at the beginning of {ERC20};
364      *
365      * Requirements:
366      * - `sender` and `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `amount`.
368      * - the caller must have allowance for `sender`'s tokens of at least
369      * `amount`.
370      */
371     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
372         _transfer(sender, recipient, amount);
373         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
374         return true;
375     }
376 
377     /**
378      * @dev Atomically increases the allowance granted to `spender` by the caller.
379      *
380      * This is an alternative to {approve} that can be used as a mitigation for
381      * problems described in {IERC20-approve}.
382      *
383      * Emits an {Approval} event indicating the updated allowance.
384      *
385      * Requirements:
386      *
387      * - `spender` cannot be the zero address.
388      */
389     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
390         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
391         return true;
392     }
393 
394     /**
395      * @dev Atomically decreases the allowance granted to `spender` by the caller.
396      *
397      * This is an alternative to {approve} that can be used as a mitigation for
398      * problems described in {IERC20-approve}.
399      *
400      * Emits an {Approval} event indicating the updated allowance.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      * - `spender` must have allowance for the caller of at least
406      * `subtractedValue`.
407      */
408     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
409         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
410         return true;
411     }
412 
413     /**
414      * @dev Moves tokens `amount` from `sender` to `recipient`.
415      *
416      * This is internal function is equivalent to {transfer}, and can be used to
417      * e.g. implement automatic token fees, slashing mechanisms, etc.
418      *
419      * Emits a {Transfer} event.
420      *
421      * Requirements:
422      *
423      * - `sender` cannot be the zero address.
424      * - `recipient` cannot be the zero address.
425      * - `sender` must have a balance of at least `amount`.
426      */
427     function _transfer(address sender, address recipient, uint256 amount) internal {
428         require(sender != address(0), "ERC20: transfer from the zero address");
429         require(recipient != address(0), "ERC20: transfer to the zero address");
430 
431         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
432         _balances[recipient] = _balances[recipient].add(amount);
433         emit Transfer(sender, recipient, amount);
434     }
435 
436     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
437      * the total supply.
438      *
439      * Emits a {Transfer} event with `from` set to the zero address.
440      *
441      * Requirements
442      *
443      * - `to` cannot be the zero address.
444      */
445     function _mint(address account, uint256 amount) internal {
446         require(account != address(0), "ERC20: mint to the zero address");
447 
448         _totalSupply = _totalSupply.add(amount);
449         _balances[account] = _balances[account].add(amount);
450         emit Transfer(address(0), account, amount);
451     }
452 
453     /**
454      * @dev Destroys `amount` tokens from `account`, reducing the
455      * total supply.
456      *
457      * Emits a {Transfer} event with `to` set to the zero address.
458      *
459      * Requirements
460      *
461      * - `account` cannot be the zero address.
462      * - `account` must have at least `amount` tokens.
463      */
464     function _burn(address account, uint256 amount) internal {
465         require(account != address(0), "ERC20: burn from the zero address");
466 
467         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
468         _totalSupply = _totalSupply.sub(amount);
469         emit Transfer(account, address(0), amount);
470     }
471 
472     /**
473      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
474      *
475      * This is internal function is equivalent to `approve`, and can be used to
476      * e.g. set automatic allowances for certain subsystems, etc.
477      *
478      * Emits an {Approval} event.
479      *
480      * Requirements:
481      *
482      * - `owner` cannot be the zero address.
483      * - `spender` cannot be the zero address.
484      */
485     function _approve(address owner, address spender, uint256 amount) internal {
486         require(owner != address(0), "ERC20: approve from the zero address");
487         require(spender != address(0), "ERC20: approve to the zero address");
488 
489         _allowances[owner][spender] = amount;
490         emit Approval(owner, spender, amount);
491     }
492 
493     /**
494      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
495      * from the caller's allowance.
496      *
497      * See {_burn} and {_approve}.
498      */
499     function _burnFrom(address account, uint256 amount) internal {
500         _burn(account, amount);
501         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
502     }
503 }
504 
505 
506 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
507 
508 // pragma solidity ^0.5.0;
509 
510 // import "@openzeppelin/contracts/GSN/Context.sol";
511 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
512 
513 /**
514  * @dev Extension of {ERC20} that allows token holders to destroy both their own
515  * tokens and those that they have an allowance for, in a way that can be
516  * recognized off-chain (via event analysis).
517  */
518 contract ERC20Burnable is Context, ERC20 {
519     /**
520      * @dev Destroys `amount` tokens from the caller.
521      *
522      * See {ERC20-_burn}.
523      */
524     function burn(uint256 amount) public {
525         _burn(_msgSender(), amount);
526     }
527 
528     /**
529      * @dev See {ERC20-_burnFrom}.
530      */
531     function burnFrom(address account, uint256 amount) public {
532         _burnFrom(account, amount);
533     }
534 }
535 
536 
537 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
538 
539 // pragma solidity ^0.5.0;
540 
541 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
542 
543 /**
544  * @dev Optional functions from the ERC20 standard.
545  */
546 contract ERC20Detailed is IERC20 {
547     string private _name;
548     string private _symbol;
549     uint8 private _decimals;
550 
551     /**
552      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
553      * these values are immutable: they can only be set once during
554      * construction.
555      */
556     constructor (string memory name, string memory symbol, uint8 decimals) public {
557         _name = name;
558         _symbol = symbol;
559         _decimals = decimals;
560     }
561 
562     /**
563      * @dev Returns the name of the token.
564      */
565     function name() public view returns (string memory) {
566         return _name;
567     }
568 
569     /**
570      * @dev Returns the symbol of the token, usually a shorter version of the
571      * name.
572      */
573     function symbol() public view returns (string memory) {
574         return _symbol;
575     }
576 
577     /**
578      * @dev Returns the number of decimals used to get its user representation.
579      * For example, if `decimals` equals `2`, a balance of `505` tokens should
580      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
581      *
582      * Tokens usually opt for a value of 18, imitating the relationship between
583      * Ether and Wei.
584      *
585      * NOTE: This information is only used for _display_ purposes: it in
586      * no way affects any of the arithmetic of the contract, including
587      * {IERC20-balanceOf} and {IERC20-transfer}.
588      */
589     function decimals() public view returns (uint8) {
590         return _decimals;
591     }
592 }
593 
594 
595 // Dependency file: @openzeppelin/contracts/access/Roles.sol
596 
597 // pragma solidity ^0.5.0;
598 
599 /**
600  * @title Roles
601  * @dev Library for managing addresses assigned to a Role.
602  */
603 library Roles {
604     struct Role {
605         mapping (address => bool) bearer;
606     }
607 
608     /**
609      * @dev Give an account access to this role.
610      */
611     function add(Role storage role, address account) internal {
612         require(!has(role, account), "Roles: account already has role");
613         role.bearer[account] = true;
614     }
615 
616     /**
617      * @dev Remove an account's access to this role.
618      */
619     function remove(Role storage role, address account) internal {
620         require(has(role, account), "Roles: account does not have role");
621         role.bearer[account] = false;
622     }
623 
624     /**
625      * @dev Check if an account has this role.
626      * @return bool
627      */
628     function has(Role storage role, address account) internal view returns (bool) {
629         require(account != address(0), "Roles: account is the zero address");
630         return role.bearer[account];
631     }
632 }
633 
634 
635 // Dependency file: @openzeppelin/contracts/access/roles/MinterRole.sol
636 
637 // pragma solidity ^0.5.0;
638 
639 // import "@openzeppelin/contracts/GSN/Context.sol";
640 // import "@openzeppelin/contracts/access/Roles.sol";
641 
642 contract MinterRole is Context {
643     using Roles for Roles.Role;
644 
645     event MinterAdded(address indexed account);
646     event MinterRemoved(address indexed account);
647 
648     Roles.Role private _minters;
649 
650     constructor () internal {
651         _addMinter(_msgSender());
652     }
653 
654     modifier onlyMinter() {
655         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
656         _;
657     }
658 
659     function isMinter(address account) public view returns (bool) {
660         return _minters.has(account);
661     }
662 
663     function addMinter(address account) public onlyMinter {
664         _addMinter(account);
665     }
666 
667     function renounceMinter() public {
668         _removeMinter(_msgSender());
669     }
670 
671     function _addMinter(address account) internal {
672         _minters.add(account);
673         emit MinterAdded(account);
674     }
675 
676     function _removeMinter(address account) internal {
677         _minters.remove(account);
678         emit MinterRemoved(account);
679     }
680 }
681 
682 
683 // Dependency file: contracts/external/Require.sol
684 
685 /*
686     Copyright 2019 dYdX Trading Inc.
687 
688     Licensed under the Apache License, Version 2.0 (the "License");
689     you may not use this file except in compliance with the License.
690     You may obtain a copy of the License at
691 
692     http://www.apache.org/licenses/LICENSE-2.0
693 
694     Unless required by applicable law or agreed to in writing, software
695     distributed under the License is distributed on an "AS IS" BASIS,
696     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
697     See the License for the specific language governing permissions and
698     limitations under the License.
699 */
700 
701 // pragma solidity ^0.5.7;
702 
703 /**
704  * @title Require
705  * @author dYdX
706  *
707  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
708  */
709 library Require {
710 
711     // ============ Constants ============
712 
713     uint256 constant ASCII_ZERO = 48; // '0'
714     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
715     uint256 constant ASCII_LOWER_EX = 120; // 'x'
716     bytes2 constant COLON = 0x3a20; // ': '
717     bytes2 constant COMMA = 0x2c20; // ', '
718     bytes2 constant LPAREN = 0x203c; // ' <'
719     byte constant RPAREN = 0x3e; // '>'
720     uint256 constant FOUR_BIT_MASK = 0xf;
721 
722     // ============ Library Functions ============
723 
724     function that(
725         bool must,
726         bytes32 file,
727         bytes32 reason
728     )
729     internal
730     pure
731     {
732         if (!must) {
733             revert(
734                 string(
735                     abi.encodePacked(
736                         stringifyTruncated(file),
737                         COLON,
738                         stringifyTruncated(reason)
739                     )
740                 )
741             );
742         }
743     }
744 
745     function that(
746         bool must,
747         bytes32 file,
748         bytes32 reason,
749         uint256 payloadA
750     )
751     internal
752     pure
753     {
754         if (!must) {
755             revert(
756                 string(
757                     abi.encodePacked(
758                         stringifyTruncated(file),
759                         COLON,
760                         stringifyTruncated(reason),
761                         LPAREN,
762                         stringify(payloadA),
763                         RPAREN
764                     )
765                 )
766             );
767         }
768     }
769 
770     function that(
771         bool must,
772         bytes32 file,
773         bytes32 reason,
774         uint256 payloadA,
775         uint256 payloadB
776     )
777     internal
778     pure
779     {
780         if (!must) {
781             revert(
782                 string(
783                     abi.encodePacked(
784                         stringifyTruncated(file),
785                         COLON,
786                         stringifyTruncated(reason),
787                         LPAREN,
788                         stringify(payloadA),
789                         COMMA,
790                         stringify(payloadB),
791                         RPAREN
792                     )
793                 )
794             );
795         }
796     }
797 
798     function that(
799         bool must,
800         bytes32 file,
801         bytes32 reason,
802         address payloadA
803     )
804     internal
805     pure
806     {
807         if (!must) {
808             revert(
809                 string(
810                     abi.encodePacked(
811                         stringifyTruncated(file),
812                         COLON,
813                         stringifyTruncated(reason),
814                         LPAREN,
815                         stringify(payloadA),
816                         RPAREN
817                     )
818                 )
819             );
820         }
821     }
822 
823     function that(
824         bool must,
825         bytes32 file,
826         bytes32 reason,
827         address payloadA,
828         uint256 payloadB
829     )
830     internal
831     pure
832     {
833         if (!must) {
834             revert(
835                 string(
836                     abi.encodePacked(
837                         stringifyTruncated(file),
838                         COLON,
839                         stringifyTruncated(reason),
840                         LPAREN,
841                         stringify(payloadA),
842                         COMMA,
843                         stringify(payloadB),
844                         RPAREN
845                     )
846                 )
847             );
848         }
849     }
850 
851     function that(
852         bool must,
853         bytes32 file,
854         bytes32 reason,
855         address payloadA,
856         uint256 payloadB,
857         uint256 payloadC
858     )
859     internal
860     pure
861     {
862         if (!must) {
863             revert(
864                 string(
865                     abi.encodePacked(
866                         stringifyTruncated(file),
867                         COLON,
868                         stringifyTruncated(reason),
869                         LPAREN,
870                         stringify(payloadA),
871                         COMMA,
872                         stringify(payloadB),
873                         COMMA,
874                         stringify(payloadC),
875                         RPAREN
876                     )
877                 )
878             );
879         }
880     }
881 
882     function that(
883         bool must,
884         bytes32 file,
885         bytes32 reason,
886         bytes32 payloadA
887     )
888     internal
889     pure
890     {
891         if (!must) {
892             revert(
893                 string(
894                     abi.encodePacked(
895                         stringifyTruncated(file),
896                         COLON,
897                         stringifyTruncated(reason),
898                         LPAREN,
899                         stringify(payloadA),
900                         RPAREN
901                     )
902                 )
903             );
904         }
905     }
906 
907     function that(
908         bool must,
909         bytes32 file,
910         bytes32 reason,
911         bytes32 payloadA,
912         uint256 payloadB,
913         uint256 payloadC
914     )
915     internal
916     pure
917     {
918         if (!must) {
919             revert(
920                 string(
921                     abi.encodePacked(
922                         stringifyTruncated(file),
923                         COLON,
924                         stringifyTruncated(reason),
925                         LPAREN,
926                         stringify(payloadA),
927                         COMMA,
928                         stringify(payloadB),
929                         COMMA,
930                         stringify(payloadC),
931                         RPAREN
932                     )
933                 )
934             );
935         }
936     }
937 
938     // ============ Private Functions ============
939 
940     function stringifyTruncated(
941         bytes32 input
942     )
943     private
944     pure
945     returns (bytes memory)
946     {
947         // put the input bytes into the result
948         bytes memory result = abi.encodePacked(input);
949 
950         // determine the length of the input by finding the location of the last non-zero byte
951         for (uint256 i = 32; i > 0; ) {
952             // reverse-for-loops with unsigned integer
953             /* solium-disable-next-line security/no-modify-for-iter-var */
954             i--;
955 
956             // find the last non-zero byte in order to determine the length
957             if (result[i] != 0) {
958                 uint256 length = i + 1;
959 
960                 /* solium-disable-next-line security/no-inline-assembly */
961                 assembly {
962                     mstore(result, length) // r.length = length;
963                 }
964 
965                 return result;
966             }
967         }
968 
969         // all bytes are zero
970         return new bytes(0);
971     }
972 
973     function stringify(
974         uint256 input
975     )
976     private
977     pure
978     returns (bytes memory)
979     {
980         if (input == 0) {
981             return "0";
982         }
983 
984         // get the final string length
985         uint256 j = input;
986         uint256 length;
987         while (j != 0) {
988             length++;
989             j /= 10;
990         }
991 
992         // allocate the string
993         bytes memory bstr = new bytes(length);
994 
995         // populate the string starting with the least-significant character
996         j = input;
997         for (uint256 i = length; i > 0; ) {
998             // reverse-for-loops with unsigned integer
999             /* solium-disable-next-line security/no-modify-for-iter-var */
1000             i--;
1001 
1002             // take last decimal digit
1003             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
1004 
1005             // remove the last decimal digit
1006             j /= 10;
1007         }
1008 
1009         return bstr;
1010     }
1011 
1012     function stringify(
1013         address input
1014     )
1015     private
1016     pure
1017     returns (bytes memory)
1018     {
1019         uint256 z = uint256(input);
1020 
1021         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
1022         bytes memory result = new bytes(42);
1023 
1024         // populate the result with "0x"
1025         result[0] = byte(uint8(ASCII_ZERO));
1026         result[1] = byte(uint8(ASCII_LOWER_EX));
1027 
1028         // for each byte (starting from the lowest byte), populate the result with two characters
1029         for (uint256 i = 0; i < 20; i++) {
1030             // each byte takes two characters
1031             uint256 shift = i * 2;
1032 
1033             // populate the least-significant character
1034             result[41 - shift] = char(z & FOUR_BIT_MASK);
1035             z = z >> 4;
1036 
1037             // populate the most-significant character
1038             result[40 - shift] = char(z & FOUR_BIT_MASK);
1039             z = z >> 4;
1040         }
1041 
1042         return result;
1043     }
1044 
1045     function stringify(
1046         bytes32 input
1047     )
1048     private
1049     pure
1050     returns (bytes memory)
1051     {
1052         uint256 z = uint256(input);
1053 
1054         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
1055         bytes memory result = new bytes(66);
1056 
1057         // populate the result with "0x"
1058         result[0] = byte(uint8(ASCII_ZERO));
1059         result[1] = byte(uint8(ASCII_LOWER_EX));
1060 
1061         // for each byte (starting from the lowest byte), populate the result with two characters
1062         for (uint256 i = 0; i < 32; i++) {
1063             // each byte takes two characters
1064             uint256 shift = i * 2;
1065 
1066             // populate the least-significant character
1067             result[65 - shift] = char(z & FOUR_BIT_MASK);
1068             z = z >> 4;
1069 
1070             // populate the most-significant character
1071             result[64 - shift] = char(z & FOUR_BIT_MASK);
1072             z = z >> 4;
1073         }
1074 
1075         return result;
1076     }
1077 
1078     function char(
1079         uint256 input
1080     )
1081     private
1082     pure
1083     returns (byte)
1084     {
1085         // return ASCII digit (0-9)
1086         if (input < 10) {
1087             return byte(uint8(input + ASCII_ZERO));
1088         }
1089 
1090         // return ASCII letter (a-f)
1091         return byte(uint8(input + ASCII_RELATIVE_ZERO));
1092     }
1093 }
1094 
1095 // Dependency file: contracts/external/LibEIP712.sol
1096 
1097 /*
1098     Copyright 2019 ZeroEx Intl.
1099 
1100     Licensed under the Apache License, Version 2.0 (the "License");
1101     you may not use this file except in compliance with the License.
1102     You may obtain a copy of the License at
1103 
1104     http://www.apache.org/licenses/LICENSE-2.0
1105 
1106     Unless required by applicable law or agreed to in writing, software
1107     distributed under the License is distributed on an "AS IS" BASIS,
1108     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1109     See the License for the specific language governing permissions and
1110     limitations under the License.
1111 */
1112 
1113 // pragma solidity ^0.5.9;
1114 
1115 
1116 library LibEIP712 {
1117 
1118     // Hash of the EIP712 Domain Separator Schema
1119     // keccak256(abi.encodePacked(
1120     //     "EIP712Domain(",
1121     //     "string name,",
1122     //     "string version,",
1123     //     "uint256 chainId,",
1124     //     "address verifyingContract",
1125     //     ")"
1126     // ))
1127     bytes32 constant internal _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
1128 
1129     /// @dev Calculates a EIP712 domain separator.
1130     /// @param name The EIP712 domain name.
1131     /// @param version The EIP712 domain version.
1132     /// @param verifyingContract The EIP712 verifying contract.
1133     /// @return EIP712 domain separator.
1134     function hashEIP712Domain(
1135         string memory name,
1136         string memory version,
1137         uint256 chainId,
1138         address verifyingContract
1139     )
1140     internal
1141     pure
1142     returns (bytes32 result)
1143     {
1144         bytes32 schemaHash = _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH;
1145 
1146         // Assembly for more efficient computing:
1147         // keccak256(abi.encodePacked(
1148         //     _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
1149         //     keccak256(bytes(name)),
1150         //     keccak256(bytes(version)),
1151         //     chainId,
1152         //     uint256(verifyingContract)
1153         // ))
1154 
1155         assembly {
1156         // Calculate hashes of dynamic data
1157             let nameHash := keccak256(add(name, 32), mload(name))
1158             let versionHash := keccak256(add(version, 32), mload(version))
1159 
1160         // Load free memory pointer
1161             let memPtr := mload(64)
1162 
1163         // Store params in memory
1164             mstore(memPtr, schemaHash)
1165             mstore(add(memPtr, 32), nameHash)
1166             mstore(add(memPtr, 64), versionHash)
1167             mstore(add(memPtr, 96), chainId)
1168             mstore(add(memPtr, 128), verifyingContract)
1169 
1170         // Compute hash
1171             result := keccak256(memPtr, 160)
1172         }
1173         return result;
1174     }
1175 
1176     /// @dev Calculates EIP712 encoding for a hash struct with a given domain hash.
1177     /// @param eip712DomainHash Hash of the domain domain separator data, computed
1178     ///                         with getDomainHash().
1179     /// @param hashStruct The EIP712 hash struct.
1180     /// @return EIP712 hash applied to the given EIP712 Domain.
1181     function hashEIP712Message(bytes32 eip712DomainHash, bytes32 hashStruct)
1182     internal
1183     pure
1184     returns (bytes32 result)
1185     {
1186         // Assembly for more efficient computing:
1187         // keccak256(abi.encodePacked(
1188         //     EIP191_HEADER,
1189         //     EIP712_DOMAIN_HASH,
1190         //     hashStruct
1191         // ));
1192 
1193         assembly {
1194         // Load free memory pointer
1195             let memPtr := mload(64)
1196 
1197             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
1198             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
1199             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
1200 
1201         // Compute hash
1202             result := keccak256(memPtr, 66)
1203         }
1204         return result;
1205     }
1206 }
1207 
1208 // Dependency file: contracts/external/Decimal.sol
1209 
1210 /*
1211     Copyright 2019 dYdX Trading Inc.
1212     Copyright 2020 BullProtocol Devs 
1213 
1214     Licensed under the Apache License, Version 2.0 (the "License");
1215     you may not use this file except in compliance with the License.
1216     You may obtain a copy of the License at
1217 
1218     http://www.apache.org/licenses/LICENSE-2.0
1219 
1220     Unless required by applicable law or agreed to in writing, software
1221     distributed under the License is distributed on an "AS IS" BASIS,
1222     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1223     See the License for the specific language governing permissions and
1224     limitations under the License.
1225 */
1226 
1227 // pragma solidity ^0.5.7;
1228 pragma experimental ABIEncoderV2;
1229 
1230 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1231 
1232 /**
1233  * @title Decimal
1234  * @author dYdX
1235  *
1236  * Library that defines a fixed-point number with 18 decimal places.
1237  */
1238 library Decimal {
1239     using SafeMath for uint256;
1240 
1241     // ============ Constants ============
1242 
1243     uint256 constant BASE = 10**18;
1244 
1245     // ============ Structs ============
1246 
1247 
1248     struct D256 {
1249         uint256 value;
1250     }
1251 
1252     // ============ Static Functions ============
1253 
1254     function zero()
1255     internal
1256     pure
1257     returns (D256 memory)
1258     {
1259         return D256({ value: 0 });
1260     }
1261 
1262     function one()
1263     internal
1264     pure
1265     returns (D256 memory)
1266     {
1267         return D256({ value: BASE });
1268     }
1269 
1270     function from(
1271         uint256 a
1272     )
1273     internal
1274     pure
1275     returns (D256 memory)
1276     {
1277         return D256({ value: a.mul(BASE) });
1278     }
1279 
1280     function ratio(
1281         uint256 a,
1282         uint256 b
1283     )
1284     internal
1285     pure
1286     returns (D256 memory)
1287     {
1288         return D256({ value: getPartial(a, BASE, b) });
1289     }
1290 
1291     // ============ Self Functions ============
1292 
1293     function add(
1294         D256 memory self,
1295         uint256 b
1296     )
1297     internal
1298     pure
1299     returns (D256 memory)
1300     {
1301         return D256({ value: self.value.add(b.mul(BASE)) });
1302     }
1303 
1304     function sub(
1305         D256 memory self,
1306         uint256 b
1307     )
1308     internal
1309     pure
1310     returns (D256 memory)
1311     {
1312         return D256({ value: self.value.sub(b.mul(BASE)) });
1313     }
1314 
1315     function sub(
1316         D256 memory self,
1317         uint256 b,
1318         string memory reason
1319     )
1320     internal
1321     pure
1322     returns (D256 memory)
1323     {
1324         return D256({ value: self.value.sub(b.mul(BASE), reason) });
1325     }
1326 
1327     function mul(
1328         D256 memory self,
1329         uint256 b
1330     )
1331     internal
1332     pure
1333     returns (D256 memory)
1334     {
1335         return D256({ value: self.value.mul(b) });
1336     }
1337 
1338     function div(
1339         D256 memory self,
1340         uint256 b
1341     )
1342     internal
1343     pure
1344     returns (D256 memory)
1345     {
1346         return D256({ value: self.value.div(b) });
1347     }
1348 
1349     function pow(
1350         D256 memory self,
1351         uint256 b
1352     )
1353     internal
1354     pure
1355     returns (D256 memory)
1356     {
1357         if (b == 0) {
1358             return from(1);
1359         }
1360 
1361         D256 memory temp = D256({ value: self.value });
1362         for (uint256 i = 1; i < b; i++) {
1363             temp = mul(temp, self);
1364         }
1365 
1366         return temp;
1367     }
1368 
1369     function add(
1370         D256 memory self,
1371         D256 memory b
1372     )
1373     internal
1374     pure
1375     returns (D256 memory)
1376     {
1377         return D256({ value: self.value.add(b.value) });
1378     }
1379 
1380     function sub(
1381         D256 memory self,
1382         D256 memory b
1383     )
1384     internal
1385     pure
1386     returns (D256 memory)
1387     {
1388         return D256({ value: self.value.sub(b.value) });
1389     }
1390 
1391     function sub(
1392         D256 memory self,
1393         D256 memory b,
1394         string memory reason
1395     )
1396     internal
1397     pure
1398     returns (D256 memory)
1399     {
1400         return D256({ value: self.value.sub(b.value, reason) });
1401     }
1402 
1403     function mul(
1404         D256 memory self,
1405         D256 memory b
1406     )
1407     internal
1408     pure
1409     returns (D256 memory)
1410     {
1411         return D256({ value: getPartial(self.value, b.value, BASE) });
1412     }
1413 
1414     function div(
1415         D256 memory self,
1416         D256 memory b
1417     )
1418     internal
1419     pure
1420     returns (D256 memory)
1421     {
1422         return D256({ value: getPartial(self.value, BASE, b.value) });
1423     }
1424 
1425     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
1426         return self.value == b.value;
1427     }
1428 
1429     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1430         return compareTo(self, b) == 2;
1431     }
1432 
1433     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1434         return compareTo(self, b) == 0;
1435     }
1436 
1437     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1438         return compareTo(self, b) > 0;
1439     }
1440 
1441     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1442         return compareTo(self, b) < 2;
1443     }
1444 
1445     function isZero(D256 memory self) internal pure returns (bool) {
1446         return self.value == 0;
1447     }
1448 
1449     function asUint256(D256 memory self) internal pure returns (uint256) {
1450         return self.value.div(BASE);
1451     }
1452 
1453     // ============ Core Methods ============
1454 
1455     function getPartial(
1456         uint256 target,
1457         uint256 numerator,
1458         uint256 denominator
1459     )
1460     private
1461     pure
1462     returns (uint256)
1463     {
1464         return target.mul(numerator).div(denominator);
1465     }
1466 
1467     function compareTo(
1468         D256 memory a,
1469         D256 memory b
1470     )
1471     private
1472     pure
1473     returns (uint256)
1474     {
1475         if (a.value == b.value) {
1476             return 1;
1477         }
1478         return a.value > b.value ? 2 : 0;
1479     }
1480 }
1481 
1482 
1483 // Dependency file: contracts/Constants.sol
1484 
1485 /*
1486     Copyright 2020 BullProtocol Devs 
1487 
1488     Licensed under the Apache License, Version 2.0 (the "License");
1489     you may not use this file except in compliance with the License.
1490     You may obtain a copy of the License at
1491 
1492     http://www.apache.org/licenses/LICENSE-2.0
1493 
1494     Unless required by applicable law or agreed to in writing, software
1495     distributed under the License is distributed on an "AS IS" BASIS,
1496     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1497     See the License for the specific language governing permissions and
1498     limitations under the License.
1499 */
1500 
1501 // pragma solidity ^0.5.17;
1502 
1503 
1504 // import "contracts/external/Decimal.sol";
1505 
1506 library Constants {
1507     /* Chain */
1508     uint256 private constant CHAIN_ID = 1; // Mainnet
1509 
1510     /* Bootstrapping */
1511     uint256 private constant BOOTSTRAPPING_PERIOD = 300; // 300 epochs
1512     uint256 private constant BOOTSTRAPPING_PRICE = 130e16;
1513 
1514     /* Oracle */
1515     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
1516     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 USDC
1517 
1518     /* Bonding */
1519     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 BSD -> 100M BSDS
1520 
1521     /* Epoch */
1522     struct EpochStrategy {
1523         uint256 offset;
1524         uint256 start;
1525         uint256 period;
1526     }
1527 
1528     uint256 private constant EPOCH_OFFSET = 0;
1529     uint256 private constant EPOCH_START = 1609261200;
1530     uint256 private constant EPOCH_PERIOD = 3600; // 1 hour
1531 
1532     /* Governance */
1533     uint256 private constant GOVERNANCE_PERIOD = 72; // 72 epochs
1534     uint256 private constant GOVERNANCE_EXPIRATION = 24; // 24 epochs
1535     uint256 private constant GOVERNANCE_QUORUM = 33e16; // 33%
1536     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 5e15; // 0.5%
1537     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
1538     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 12; // 12 epochs
1539 
1540     /* DAO */
1541     uint256 private constant ADVANCE_INCENTIVE_BELOW_ONE_DOLLAR = 100e18; // 100 BSD for reward if price <=1 USDC
1542     uint256 private constant ADVANCE_INCENTIVE_ABOVE_ONE_DOLLAR = 100e6; // 100 USDC convert from BSD price for reward
1543     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 72; // 72 epochs fluid
1544 
1545     /* Pool */
1546     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 24; // 24 epochs fluid
1547 
1548     /* Market */
1549     uint256 private constant COUPON_EXPIRATION = 720;
1550     uint256 private constant DEBT_RATIO_CAP = 15e16; // 15%
1551 
1552     /* Regulator */
1553     uint256 private constant SUPPLY_CHANGE_LIMIT = 3e16; // 3%
1554     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 6e16; // 6%
1555     uint256 private constant ORACLE_POOL_RATIO = 40; // 40%
1556     uint256 private constant TREASURY_RATIO = 150; // 1.5%
1557 
1558     /* Assets */
1559     address private constant TREASURY_ADDRESS = address(0xB8f2F09adc4fA5c15600BC461a3a3beC2eDFE9b9);
1560 
1561     /**
1562      * Getters
1563      */
1564 
1565     function getUsdcAddress() internal pure returns (address) {
1566         return USDC;
1567     }
1568 
1569     function getOracleReserveMinimum() internal pure returns (uint256) {
1570         return ORACLE_RESERVE_MINIMUM;
1571     }
1572 
1573     function getEpochStrategy() internal pure returns (EpochStrategy memory) {
1574         return EpochStrategy({
1575             offset: EPOCH_OFFSET,
1576             start: EPOCH_START,
1577             period: EPOCH_PERIOD
1578         });
1579     }
1580 
1581     function getInitialStakeMultiple() internal pure returns (uint256) {
1582         return INITIAL_STAKE_MULTIPLE;
1583     }
1584 
1585     function getBootstrappingPeriod() internal pure returns (uint256) {
1586         return BOOTSTRAPPING_PERIOD;
1587     }
1588 
1589     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1590         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1591     }
1592 
1593     function getGovernancePeriod() internal pure returns (uint256) {
1594         return GOVERNANCE_PERIOD;
1595     }
1596 
1597     function getGovernanceExpiration() internal pure returns (uint256) {
1598         return GOVERNANCE_EXPIRATION;
1599     }
1600 
1601     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1602         return Decimal.D256({value: GOVERNANCE_QUORUM});
1603     }
1604 
1605     function getGovernanceProposalThreshold() internal pure returns (Decimal.D256 memory) {
1606         return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
1607     }
1608 
1609     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1610         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1611     }
1612 
1613     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1614         return GOVERNANCE_EMERGENCY_DELAY;
1615     }
1616 
1617     function getAdvanceIncentive() internal pure returns (uint256) {
1618         return ADVANCE_INCENTIVE_BELOW_ONE_DOLLAR;
1619     }
1620 
1621     function getAdvanceIncentiveRate() internal pure returns (uint256) {
1622         return ADVANCE_INCENTIVE_ABOVE_ONE_DOLLAR;
1623     }
1624 
1625     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1626         return DAO_EXIT_LOCKUP_EPOCHS;
1627     }
1628 
1629     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1630         return POOL_EXIT_LOCKUP_EPOCHS;
1631     }
1632 
1633     function getCouponExpiration() internal pure returns (uint256) {
1634         return COUPON_EXPIRATION;
1635     }
1636 
1637     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1638         return Decimal.D256({value: DEBT_RATIO_CAP});
1639     }
1640 
1641     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1642         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1643     }
1644 
1645     function getCouponSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1646         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
1647     }
1648 
1649     function getOraclePoolRatio() internal pure returns (uint256) {
1650         return ORACLE_POOL_RATIO;
1651     }
1652 
1653     function getTreasuryRatio() internal pure returns (uint256) {
1654         return TREASURY_RATIO;
1655     }
1656 
1657     function getChainId() internal pure returns (uint256) {
1658         return CHAIN_ID;
1659     }
1660 
1661     function getTreasuryAddress() internal pure returns (address) {
1662         return TREASURY_ADDRESS;
1663     }
1664 }
1665 
1666 
1667 // Dependency file: contracts/token/Permittable.sol
1668 
1669 /*
1670     Copyright 2020 BullProtocol Devs
1671 
1672     Licensed under the Apache License, Version 2.0 (the "License");
1673     you may not use this file except in compliance with the License.
1674     You may obtain a copy of the License at
1675 
1676     http://www.apache.org/licenses/LICENSE-2.0
1677 
1678     Unless required by applicable law or agreed to in writing, software
1679     distributed under the License is distributed on an "AS IS" BASIS,
1680     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1681     See the License for the specific language governing permissions and
1682     limitations under the License.
1683 */
1684 
1685 // pragma solidity ^0.5.17;
1686 
1687 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
1688 // import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
1689 // import "contracts/external/Require.sol";
1690 // import "contracts/external/LibEIP712.sol";
1691 // import "contracts/Constants.sol";
1692 
1693 contract Permittable is ERC20Detailed, ERC20 {
1694     bytes32 constant FILE = "Permittable";
1695 
1696     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1697     bytes32 public constant EIP712_PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1698     string private constant EIP712_VERSION = "1";
1699 
1700     bytes32 public EIP712_DOMAIN_SEPARATOR;
1701 
1702     mapping(address => uint256) nonces;
1703 
1704     constructor() public {
1705         EIP712_DOMAIN_SEPARATOR = LibEIP712.hashEIP712Domain(name(), EIP712_VERSION, Constants.getChainId(), address(this));
1706     }
1707 
1708     function permit(
1709         address owner,
1710         address spender,
1711         uint256 value,
1712         uint256 deadline,
1713         uint8 v,
1714         bytes32 r,
1715         bytes32 s
1716     ) external {
1717         bytes32 digest = LibEIP712.hashEIP712Message(
1718             EIP712_DOMAIN_SEPARATOR,
1719             keccak256(abi.encode(
1720                 EIP712_PERMIT_TYPEHASH,
1721                 owner,
1722                 spender,
1723                 value,
1724                 nonces[owner]++,
1725                 deadline
1726             ))
1727         );
1728 
1729         address recovered = ecrecover(digest, v, r, s);
1730         Require.that(
1731             recovered == owner,
1732             FILE,
1733             "Invalid signature"
1734         );
1735 
1736         Require.that(
1737             recovered != address(0),
1738             FILE,
1739             "Zero address"
1740         );
1741 
1742         Require.that(
1743             now <= deadline,
1744             FILE,
1745             "Expired"
1746         );
1747 
1748         _approve(owner, spender, value);
1749     }
1750 }
1751 
1752 // Dependency file: contracts/token/IDollar.sol
1753 
1754 /*
1755     Copyright 2020 BullProtocol Devs 
1756 
1757     Licensed under the Apache License, Version 2.0 (the "License");
1758     you may not use this file except in compliance with the License.
1759     You may obtain a copy of the License at
1760 
1761     http://www.apache.org/licenses/LICENSE-2.0
1762 
1763     Unless required by applicable law or agreed to in writing, software
1764     distributed under the License is distributed on an "AS IS" BASIS,
1765     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1766     See the License for the specific language governing permissions and
1767     limitations under the License.
1768 */
1769 
1770 // pragma solidity ^0.5.17;
1771 
1772 
1773 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
1774 
1775 contract IDollar is IERC20 {
1776     function burn(uint256 amount) public;
1777     function burnFrom(address account, uint256 amount) public;
1778     function mint(address account, uint256 amount) public returns (bool);
1779 }
1780 
1781 
1782 // Root file: contracts/token/Dollar.sol
1783 
1784 /*
1785     Copyright 2020 BullProtocol Devs
1786 
1787     Licensed under the Apache License, Version 2.0 (the "License");
1788     you may not use this file except in compliance with the License.
1789     You may obtain a copy of the License at
1790 
1791     http://www.apache.org/licenses/LICENSE-2.0
1792 
1793     Unless required by applicable law or agreed to in writing, software
1794     distributed under the License is distributed on an "AS IS" BASIS,
1795     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1796     See the License for the specific language governing permissions and
1797     limitations under the License.
1798 */
1799 
1800 pragma solidity ^0.5.17;
1801 
1802 
1803 // import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
1804 // import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
1805 // import "@openzeppelin/contracts/access/roles/MinterRole.sol";
1806 // import "contracts/token/Permittable.sol";
1807 // import "contracts/token/IDollar.sol";
1808 
1809 
1810 contract Dollar is IDollar, MinterRole, ERC20Detailed, Permittable, ERC20Burnable  {
1811 
1812     constructor()
1813     ERC20Detailed("Bull Set Dollar", "BSD", 18)
1814     Permittable()
1815     public
1816     { }
1817 
1818     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1819         _mint(account, amount);
1820         return true;
1821     }
1822 
1823     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1824         _transfer(sender, recipient, amount);
1825         if (allowance(sender, _msgSender()) != uint256(-1)) {
1826             _approve(
1827                 sender,
1828                 _msgSender(),
1829                 allowance(sender, _msgSender()).sub(amount, "Dollar: transfer amount exceeds allowance"));
1830         }
1831         return true;
1832     }
1833 }