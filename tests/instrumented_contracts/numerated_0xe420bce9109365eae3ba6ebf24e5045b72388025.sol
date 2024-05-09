1 pragma solidity ^0.5.17;
2 pragma experimental ABIEncoderV2;
3 
4 // File: @openzeppelin/contracts/GSN/Context.sol
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 contract Context {
17     // Empty internal constructor, to prevent people from mistakenly deploying
18     // an instance of this contract, which should be used via inheritance.
19     constructor () internal { }
20     // solhint-disable-previous-line no-empty-blocks
21 
22     function _msgSender() internal view returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
33 
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `+` operator.
132      *
133      * Requirements:
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         return sub(a, b, "SafeMath: subtraction overflow");
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      * - Subtraction cannot overflow.
164      *
165      * _Available since v2.4.0._
166      */
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b <= a, errorMessage);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the multiplication of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `*` operator.
179      *
180      * Requirements:
181      * - Multiplication cannot overflow.
182      */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185         // benefit is lost if 'b' is also tested.
186         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b, "SafeMath: multiplication overflow");
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      * - The divisor cannot be zero.
222      *
223      * _Available since v2.4.0._
224      */
225     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         // Solidity only automatically asserts when dividing by 0
227         require(b > 0, errorMessage);
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         return mod(a, b, "SafeMath: modulo by zero");
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts with custom message when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      * - The divisor cannot be zero.
259      *
260      * _Available since v2.4.0._
261      */
262     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b != 0, errorMessage);
264         return a % b;
265     }
266 }
267 
268 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
269 
270 
271 
272 
273 
274 /**
275  * @dev Implementation of the {IERC20} interface.
276  *
277  * This implementation is agnostic to the way tokens are created. This means
278  * that a supply mechanism has to be added in a derived contract using {_mint}.
279  * For a generic mechanism see {ERC20Mintable}.
280  *
281  * TIP: For a detailed writeup see our guide
282  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
283  * to implement supply mechanisms].
284  *
285  * We have followed general OpenZeppelin guidelines: functions revert instead
286  * of returning `false` on failure. This behavior is nonetheless conventional
287  * and does not conflict with the expectations of ERC20 applications.
288  *
289  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
290  * This allows applications to reconstruct the allowance for all accounts just
291  * by listening to said events. Other implementations of the EIP may not emit
292  * these events, as it isn't required by the specification.
293  *
294  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
295  * functions have been added to mitigate the well-known issues around setting
296  * allowances. See {IERC20-approve}.
297  */
298 contract ERC20 is Context, IERC20 {
299     using SafeMath for uint256;
300 
301     mapping (address => uint256) private _balances;
302 
303     mapping (address => mapping (address => uint256)) private _allowances;
304 
305     uint256 private _totalSupply;
306 
307     /**
308      * @dev See {IERC20-totalSupply}.
309      */
310     function totalSupply() public view returns (uint256) {
311         return _totalSupply;
312     }
313 
314     /**
315      * @dev See {IERC20-balanceOf}.
316      */
317     function balanceOf(address account) public view returns (uint256) {
318         return _balances[account];
319     }
320 
321     /**
322      * @dev See {IERC20-transfer}.
323      *
324      * Requirements:
325      *
326      * - `recipient` cannot be the zero address.
327      * - the caller must have a balance of at least `amount`.
328      */
329     function transfer(address recipient, uint256 amount) public returns (bool) {
330         _transfer(_msgSender(), recipient, amount);
331         return true;
332     }
333 
334     /**
335      * @dev See {IERC20-allowance}.
336      */
337     function allowance(address owner, address spender) public view returns (uint256) {
338         return _allowances[owner][spender];
339     }
340 
341     /**
342      * @dev See {IERC20-approve}.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      */
348     function approve(address spender, uint256 amount) public returns (bool) {
349         _approve(_msgSender(), spender, amount);
350         return true;
351     }
352 
353     /**
354      * @dev See {IERC20-transferFrom}.
355      *
356      * Emits an {Approval} event indicating the updated allowance. This is not
357      * required by the EIP. See the note at the beginning of {ERC20};
358      *
359      * Requirements:
360      * - `sender` and `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      * - the caller must have allowance for `sender`'s tokens of at least
363      * `amount`.
364      */
365     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
366         _transfer(sender, recipient, amount);
367         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
368         return true;
369     }
370 
371     /**
372      * @dev Atomically increases the allowance granted to `spender` by the caller.
373      *
374      * This is an alternative to {approve} that can be used as a mitigation for
375      * problems described in {IERC20-approve}.
376      *
377      * Emits an {Approval} event indicating the updated allowance.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      */
383     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
384         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
385         return true;
386     }
387 
388     /**
389      * @dev Atomically decreases the allowance granted to `spender` by the caller.
390      *
391      * This is an alternative to {approve} that can be used as a mitigation for
392      * problems described in {IERC20-approve}.
393      *
394      * Emits an {Approval} event indicating the updated allowance.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      * - `spender` must have allowance for the caller of at least
400      * `subtractedValue`.
401      */
402     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
403         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
404         return true;
405     }
406 
407     /**
408      * @dev Moves tokens `amount` from `sender` to `recipient`.
409      *
410      * This is internal function is equivalent to {transfer}, and can be used to
411      * e.g. implement automatic token fees, slashing mechanisms, etc.
412      *
413      * Emits a {Transfer} event.
414      *
415      * Requirements:
416      *
417      * - `sender` cannot be the zero address.
418      * - `recipient` cannot be the zero address.
419      * - `sender` must have a balance of at least `amount`.
420      */
421     function _transfer(address sender, address recipient, uint256 amount) internal {
422         require(sender != address(0), "ERC20: transfer from the zero address");
423         require(recipient != address(0), "ERC20: transfer to the zero address");
424 
425         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
426         _balances[recipient] = _balances[recipient].add(amount);
427         emit Transfer(sender, recipient, amount);
428     }
429 
430     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
431      * the total supply.
432      *
433      * Emits a {Transfer} event with `from` set to the zero address.
434      *
435      * Requirements
436      *
437      * - `to` cannot be the zero address.
438      */
439     function _mint(address account, uint256 amount) internal {
440         require(account != address(0), "ERC20: mint to the zero address");
441 
442         _totalSupply = _totalSupply.add(amount);
443         _balances[account] = _balances[account].add(amount);
444         emit Transfer(address(0), account, amount);
445     }
446 
447     /**
448      * @dev Destroys `amount` tokens from `account`, reducing the
449      * total supply.
450      *
451      * Emits a {Transfer} event with `to` set to the zero address.
452      *
453      * Requirements
454      *
455      * - `account` cannot be the zero address.
456      * - `account` must have at least `amount` tokens.
457      */
458     function _burn(address account, uint256 amount) internal {
459         require(account != address(0), "ERC20: burn from the zero address");
460 
461         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
462         _totalSupply = _totalSupply.sub(amount);
463         emit Transfer(account, address(0), amount);
464     }
465 
466     /**
467      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
468      *
469      * This is internal function is equivalent to `approve`, and can be used to
470      * e.g. set automatic allowances for certain subsystems, etc.
471      *
472      * Emits an {Approval} event.
473      *
474      * Requirements:
475      *
476      * - `owner` cannot be the zero address.
477      * - `spender` cannot be the zero address.
478      */
479     function _approve(address owner, address spender, uint256 amount) internal {
480         require(owner != address(0), "ERC20: approve from the zero address");
481         require(spender != address(0), "ERC20: approve to the zero address");
482 
483         _allowances[owner][spender] = amount;
484         emit Approval(owner, spender, amount);
485     }
486 
487     /**
488      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
489      * from the caller's allowance.
490      *
491      * See {_burn} and {_approve}.
492      */
493     function _burnFrom(address account, uint256 amount) internal {
494         _burn(account, amount);
495         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
496     }
497 }
498 
499 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
500 
501 
502 
503 
504 /**
505  * @dev Extension of {ERC20} that allows token holders to destroy both their own
506  * tokens and those that they have an allowance for, in a way that can be
507  * recognized off-chain (via event analysis).
508  */
509 contract ERC20Burnable is Context, ERC20 {
510     /**
511      * @dev Destroys `amount` tokens from the caller.
512      *
513      * See {ERC20-_burn}.
514      */
515     function burn(uint256 amount) public {
516         _burn(_msgSender(), amount);
517     }
518 
519     /**
520      * @dev See {ERC20-_burnFrom}.
521      */
522     function burnFrom(address account, uint256 amount) public {
523         _burnFrom(account, amount);
524     }
525 }
526 
527 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
528 
529 
530 
531 /**
532  * @dev Optional functions from the ERC20 standard.
533  */
534 contract ERC20Detailed is IERC20 {
535     string private _name;
536     string private _symbol;
537     uint8 private _decimals;
538 
539     /**
540      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
541      * these values are immutable: they can only be set once during
542      * construction.
543      */
544     constructor (string memory name, string memory symbol, uint8 decimals) public {
545         _name = name;
546         _symbol = symbol;
547         _decimals = decimals;
548     }
549 
550     /**
551      * @dev Returns the name of the token.
552      */
553     function name() public view returns (string memory) {
554         return _name;
555     }
556 
557     /**
558      * @dev Returns the symbol of the token, usually a shorter version of the
559      * name.
560      */
561     function symbol() public view returns (string memory) {
562         return _symbol;
563     }
564 
565     /**
566      * @dev Returns the number of decimals used to get its user representation.
567      * For example, if `decimals` equals `2`, a balance of `505` tokens should
568      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
569      *
570      * Tokens usually opt for a value of 18, imitating the relationship between
571      * Ether and Wei.
572      *
573      * NOTE: This information is only used for _display_ purposes: it in
574      * no way affects any of the arithmetic of the contract, including
575      * {IERC20-balanceOf} and {IERC20-transfer}.
576      */
577     function decimals() public view returns (uint8) {
578         return _decimals;
579     }
580 }
581 
582 // File: @openzeppelin/contracts/access/Roles.sol
583 
584 
585 /**
586  * @title Roles
587  * @dev Library for managing addresses assigned to a Role.
588  */
589 library Roles {
590     struct Role {
591         mapping (address => bool) bearer;
592     }
593 
594     /**
595      * @dev Give an account access to this role.
596      */
597     function add(Role storage role, address account) internal {
598         require(!has(role, account), "Roles: account already has role");
599         role.bearer[account] = true;
600     }
601 
602     /**
603      * @dev Remove an account's access to this role.
604      */
605     function remove(Role storage role, address account) internal {
606         require(has(role, account), "Roles: account does not have role");
607         role.bearer[account] = false;
608     }
609 
610     /**
611      * @dev Check if an account has this role.
612      * @return bool
613      */
614     function has(Role storage role, address account) internal view returns (bool) {
615         require(account != address(0), "Roles: account is the zero address");
616         return role.bearer[account];
617     }
618 }
619 
620 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
621 
622 
623 
624 
625 contract MinterRole is Context {
626     using Roles for Roles.Role;
627 
628     event MinterAdded(address indexed account);
629     event MinterRemoved(address indexed account);
630 
631     Roles.Role private _minters;
632 
633     constructor () internal {
634         _addMinter(_msgSender());
635     }
636 
637     modifier onlyMinter() {
638         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
639         _;
640     }
641 
642     function isMinter(address account) public view returns (bool) {
643         return _minters.has(account);
644     }
645 
646     function addMinter(address account) public onlyMinter {
647         _addMinter(account);
648     }
649 
650     function renounceMinter() public {
651         _removeMinter(_msgSender());
652     }
653 
654     function _addMinter(address account) internal {
655         _minters.add(account);
656         emit MinterAdded(account);
657     }
658 
659     function _removeMinter(address account) internal {
660         _minters.remove(account);
661         emit MinterRemoved(account);
662     }
663 }
664 
665 // File: contracts/external/Require.sol
666 
667 /*
668     Copyright 2019 dYdX Trading Inc.
669 
670     Licensed under the Apache License, Version 2.0 (the "License");
671     you may not use this file except in compliance with the License.
672     You may obtain a copy of the License at
673 
674     http://www.apache.org/licenses/LICENSE-2.0
675 
676     Unless required by applicable law or agreed to in writing, software
677     distributed under the License is distributed on an "AS IS" BASIS,
678     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
679     See the License for the specific language governing permissions and
680     limitations under the License.
681 */
682 
683 
684 /**
685  * @title Require
686  * @author dYdX
687  *
688  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
689  */
690 library Require {
691 
692     // ============ Constants ============
693 
694     uint256 constant ASCII_ZERO = 48; // '0'
695     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
696     uint256 constant ASCII_LOWER_EX = 120; // 'x'
697     bytes2 constant COLON = 0x3a20; // ': '
698     bytes2 constant COMMA = 0x2c20; // ', '
699     bytes2 constant LPAREN = 0x203c; // ' <'
700     byte constant RPAREN = 0x3e; // '>'
701     uint256 constant FOUR_BIT_MASK = 0xf;
702 
703     // ============ Library Functions ============
704 
705     function that(
706         bool must,
707         bytes32 file,
708         bytes32 reason
709     )
710     internal
711     pure
712     {
713         if (!must) {
714             revert(
715                 string(
716                     abi.encodePacked(
717                         stringifyTruncated(file),
718                         COLON,
719                         stringifyTruncated(reason)
720                     )
721                 )
722             );
723         }
724     }
725 
726     function that(
727         bool must,
728         bytes32 file,
729         bytes32 reason,
730         uint256 payloadA
731     )
732     internal
733     pure
734     {
735         if (!must) {
736             revert(
737                 string(
738                     abi.encodePacked(
739                         stringifyTruncated(file),
740                         COLON,
741                         stringifyTruncated(reason),
742                         LPAREN,
743                         stringify(payloadA),
744                         RPAREN
745                     )
746                 )
747             );
748         }
749     }
750 
751     function that(
752         bool must,
753         bytes32 file,
754         bytes32 reason,
755         uint256 payloadA,
756         uint256 payloadB
757     )
758     internal
759     pure
760     {
761         if (!must) {
762             revert(
763                 string(
764                     abi.encodePacked(
765                         stringifyTruncated(file),
766                         COLON,
767                         stringifyTruncated(reason),
768                         LPAREN,
769                         stringify(payloadA),
770                         COMMA,
771                         stringify(payloadB),
772                         RPAREN
773                     )
774                 )
775             );
776         }
777     }
778 
779     function that(
780         bool must,
781         bytes32 file,
782         bytes32 reason,
783         address payloadA
784     )
785     internal
786     pure
787     {
788         if (!must) {
789             revert(
790                 string(
791                     abi.encodePacked(
792                         stringifyTruncated(file),
793                         COLON,
794                         stringifyTruncated(reason),
795                         LPAREN,
796                         stringify(payloadA),
797                         RPAREN
798                     )
799                 )
800             );
801         }
802     }
803 
804     function that(
805         bool must,
806         bytes32 file,
807         bytes32 reason,
808         address payloadA,
809         uint256 payloadB
810     )
811     internal
812     pure
813     {
814         if (!must) {
815             revert(
816                 string(
817                     abi.encodePacked(
818                         stringifyTruncated(file),
819                         COLON,
820                         stringifyTruncated(reason),
821                         LPAREN,
822                         stringify(payloadA),
823                         COMMA,
824                         stringify(payloadB),
825                         RPAREN
826                     )
827                 )
828             );
829         }
830     }
831 
832     function that(
833         bool must,
834         bytes32 file,
835         bytes32 reason,
836         address payloadA,
837         uint256 payloadB,
838         uint256 payloadC
839     )
840     internal
841     pure
842     {
843         if (!must) {
844             revert(
845                 string(
846                     abi.encodePacked(
847                         stringifyTruncated(file),
848                         COLON,
849                         stringifyTruncated(reason),
850                         LPAREN,
851                         stringify(payloadA),
852                         COMMA,
853                         stringify(payloadB),
854                         COMMA,
855                         stringify(payloadC),
856                         RPAREN
857                     )
858                 )
859             );
860         }
861     }
862 
863     function that(
864         bool must,
865         bytes32 file,
866         bytes32 reason,
867         bytes32 payloadA
868     )
869     internal
870     pure
871     {
872         if (!must) {
873             revert(
874                 string(
875                     abi.encodePacked(
876                         stringifyTruncated(file),
877                         COLON,
878                         stringifyTruncated(reason),
879                         LPAREN,
880                         stringify(payloadA),
881                         RPAREN
882                     )
883                 )
884             );
885         }
886     }
887 
888     function that(
889         bool must,
890         bytes32 file,
891         bytes32 reason,
892         bytes32 payloadA,
893         uint256 payloadB,
894         uint256 payloadC
895     )
896     internal
897     pure
898     {
899         if (!must) {
900             revert(
901                 string(
902                     abi.encodePacked(
903                         stringifyTruncated(file),
904                         COLON,
905                         stringifyTruncated(reason),
906                         LPAREN,
907                         stringify(payloadA),
908                         COMMA,
909                         stringify(payloadB),
910                         COMMA,
911                         stringify(payloadC),
912                         RPAREN
913                     )
914                 )
915             );
916         }
917     }
918 
919     // ============ Private Functions ============
920 
921     function stringifyTruncated(
922         bytes32 input
923     )
924     private
925     pure
926     returns (bytes memory)
927     {
928         // put the input bytes into the result
929         bytes memory result = abi.encodePacked(input);
930 
931         // determine the length of the input by finding the location of the last non-zero byte
932         for (uint256 i = 32; i > 0; ) {
933             // reverse-for-loops with unsigned integer
934             /* solium-disable-next-line security/no-modify-for-iter-var */
935             i--;
936 
937             // find the last non-zero byte in order to determine the length
938             if (result[i] != 0) {
939                 uint256 length = i + 1;
940 
941                 /* solium-disable-next-line security/no-inline-assembly */
942                 assembly {
943                     mstore(result, length) // r.length = length;
944                 }
945 
946                 return result;
947             }
948         }
949 
950         // all bytes are zero
951         return new bytes(0);
952     }
953 
954     function stringify(
955         uint256 input
956     )
957     private
958     pure
959     returns (bytes memory)
960     {
961         if (input == 0) {
962             return "0";
963         }
964 
965         // get the final string length
966         uint256 j = input;
967         uint256 length;
968         while (j != 0) {
969             length++;
970             j /= 10;
971         }
972 
973         // allocate the string
974         bytes memory bstr = new bytes(length);
975 
976         // populate the string starting with the least-significant character
977         j = input;
978         for (uint256 i = length; i > 0; ) {
979             // reverse-for-loops with unsigned integer
980             /* solium-disable-next-line security/no-modify-for-iter-var */
981             i--;
982 
983             // take last decimal digit
984             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
985 
986             // remove the last decimal digit
987             j /= 10;
988         }
989 
990         return bstr;
991     }
992 
993     function stringify(
994         address input
995     )
996     private
997     pure
998     returns (bytes memory)
999     {
1000         uint256 z = uint256(input);
1001 
1002         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
1003         bytes memory result = new bytes(42);
1004 
1005         // populate the result with "0x"
1006         result[0] = byte(uint8(ASCII_ZERO));
1007         result[1] = byte(uint8(ASCII_LOWER_EX));
1008 
1009         // for each byte (starting from the lowest byte), populate the result with two characters
1010         for (uint256 i = 0; i < 20; i++) {
1011             // each byte takes two characters
1012             uint256 shift = i * 2;
1013 
1014             // populate the least-significant character
1015             result[41 - shift] = char(z & FOUR_BIT_MASK);
1016             z = z >> 4;
1017 
1018             // populate the most-significant character
1019             result[40 - shift] = char(z & FOUR_BIT_MASK);
1020             z = z >> 4;
1021         }
1022 
1023         return result;
1024     }
1025 
1026     function stringify(
1027         bytes32 input
1028     )
1029     private
1030     pure
1031     returns (bytes memory)
1032     {
1033         uint256 z = uint256(input);
1034 
1035         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
1036         bytes memory result = new bytes(66);
1037 
1038         // populate the result with "0x"
1039         result[0] = byte(uint8(ASCII_ZERO));
1040         result[1] = byte(uint8(ASCII_LOWER_EX));
1041 
1042         // for each byte (starting from the lowest byte), populate the result with two characters
1043         for (uint256 i = 0; i < 32; i++) {
1044             // each byte takes two characters
1045             uint256 shift = i * 2;
1046 
1047             // populate the least-significant character
1048             result[65 - shift] = char(z & FOUR_BIT_MASK);
1049             z = z >> 4;
1050 
1051             // populate the most-significant character
1052             result[64 - shift] = char(z & FOUR_BIT_MASK);
1053             z = z >> 4;
1054         }
1055 
1056         return result;
1057     }
1058 
1059     function char(
1060         uint256 input
1061     )
1062     private
1063     pure
1064     returns (byte)
1065     {
1066         // return ASCII digit (0-9)
1067         if (input < 10) {
1068             return byte(uint8(input + ASCII_ZERO));
1069         }
1070 
1071         // return ASCII letter (a-f)
1072         return byte(uint8(input + ASCII_RELATIVE_ZERO));
1073     }
1074 }
1075 
1076 // File: contracts/external/LibEIP712.sol
1077 
1078 /*
1079     Copyright 2019 ZeroEx Intl.
1080 
1081     Licensed under the Apache License, Version 2.0 (the "License");
1082     you may not use this file except in compliance with the License.
1083     You may obtain a copy of the License at
1084 
1085     http://www.apache.org/licenses/LICENSE-2.0
1086 
1087     Unless required by applicable law or agreed to in writing, software
1088     distributed under the License is distributed on an "AS IS" BASIS,
1089     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1090     See the License for the specific language governing permissions and
1091     limitations under the License.
1092 */
1093 
1094 
1095 
1096 library LibEIP712 {
1097 
1098     // Hash of the EIP712 Domain Separator Schema
1099     // keccak256(abi.encodePacked(
1100     //     "EIP712Domain(",
1101     //     "string name,",
1102     //     "string version,",
1103     //     "uint256 chainId,",
1104     //     "address verifyingContract",
1105     //     ")"
1106     // ))
1107     bytes32 constant internal _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
1108 
1109     /// @dev Calculates a EIP712 domain separator.
1110     /// @param name The EIP712 domain name.
1111     /// @param version The EIP712 domain version.
1112     /// @param verifyingContract The EIP712 verifying contract.
1113     /// @return EIP712 domain separator.
1114     function hashEIP712Domain(
1115         string memory name,
1116         string memory version,
1117         uint256 chainId,
1118         address verifyingContract
1119     )
1120     internal
1121     pure
1122     returns (bytes32 result)
1123     {
1124         bytes32 schemaHash = _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH;
1125 
1126         // Assembly for more efficient computing:
1127         // keccak256(abi.encodePacked(
1128         //     _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
1129         //     keccak256(bytes(name)),
1130         //     keccak256(bytes(version)),
1131         //     chainId,
1132         //     uint256(verifyingContract)
1133         // ))
1134 
1135         assembly {
1136         // Calculate hashes of dynamic data
1137             let nameHash := keccak256(add(name, 32), mload(name))
1138             let versionHash := keccak256(add(version, 32), mload(version))
1139 
1140         // Load free memory pointer
1141             let memPtr := mload(64)
1142 
1143         // Store params in memory
1144             mstore(memPtr, schemaHash)
1145             mstore(add(memPtr, 32), nameHash)
1146             mstore(add(memPtr, 64), versionHash)
1147             mstore(add(memPtr, 96), chainId)
1148             mstore(add(memPtr, 128), verifyingContract)
1149 
1150         // Compute hash
1151             result := keccak256(memPtr, 160)
1152         }
1153         return result;
1154     }
1155 
1156     /// @dev Calculates EIP712 encoding for a hash struct with a given domain hash.
1157     /// @param eip712DomainHash Hash of the domain domain separator data, computed
1158     ///                         with getDomainHash().
1159     /// @param hashStruct The EIP712 hash struct.
1160     /// @return EIP712 hash applied to the given EIP712 Domain.
1161     function hashEIP712Message(bytes32 eip712DomainHash, bytes32 hashStruct)
1162     internal
1163     pure
1164     returns (bytes32 result)
1165     {
1166         // Assembly for more efficient computing:
1167         // keccak256(abi.encodePacked(
1168         //     EIP191_HEADER,
1169         //     EIP712_DOMAIN_HASH,
1170         //     hashStruct
1171         // ));
1172 
1173         assembly {
1174         // Load free memory pointer
1175             let memPtr := mload(64)
1176 
1177             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
1178             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
1179             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
1180 
1181         // Compute hash
1182             result := keccak256(memPtr, 66)
1183         }
1184         return result;
1185     }
1186 }
1187 
1188 // File: contracts/external/Decimal.sol
1189 
1190 /*
1191     Copyright 2019 dYdX Trading Inc.
1192     Copyright 2020 Zero Collateral Devs, standing on the shoulders of the Empty Set Squad <zaifinance@protonmail.com>
1193 
1194     Licensed under the Apache License, Version 2.0 (the "License");
1195     you may not use this file except in compliance with the License.
1196     You may obtain a copy of the License at
1197 
1198     http://www.apache.org/licenses/LICENSE-2.0
1199 
1200     Unless required by applicable law or agreed to in writing, software
1201     distributed under the License is distributed on an "AS IS" BASIS,
1202     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1203     See the License for the specific language governing permissions and
1204     limitations under the License.
1205 */
1206 
1207 
1208 
1209 /**
1210  * @title Decimal
1211  * @author dYdX
1212  *
1213  * Library that defines a fixed-point number with 18 decimal places.
1214  */
1215 library Decimal {
1216     using SafeMath for uint256;
1217 
1218     // ============ Constants ============
1219 
1220     uint256 constant BASE = 10**18;
1221 
1222     // ============ Structs ============
1223 
1224     struct D256 {
1225         uint256 value;
1226     }
1227 
1228     // ============ Static Functions ============
1229 
1230     function zero() internal pure returns (D256 memory) {
1231         return D256({value: 0});
1232     }
1233 
1234     function one() internal pure returns (D256 memory) {
1235         return D256({value: BASE});
1236     }
1237 
1238     function from(uint256 a) internal pure returns (D256 memory) {
1239         return D256({value: a.mul(BASE)});
1240     }
1241 
1242     function ratio(uint256 a, uint256 b) internal pure returns (D256 memory) {
1243         return D256({value: getPartial(a, BASE, b)});
1244     }
1245 
1246     // ============ Self Functions ============
1247 
1248     function add(D256 memory self, uint256 b)
1249         internal
1250         pure
1251         returns (D256 memory)
1252     {
1253         return D256({value: self.value.add(b.mul(BASE))});
1254     }
1255 
1256     function sub(D256 memory self, uint256 b)
1257         internal
1258         pure
1259         returns (D256 memory)
1260     {
1261         return D256({value: self.value.sub(b.mul(BASE))});
1262     }
1263 
1264     function sub(
1265         D256 memory self,
1266         uint256 b,
1267         string memory reason
1268     ) internal pure returns (D256 memory) {
1269         return D256({value: self.value.sub(b.mul(BASE), reason)});
1270     }
1271 
1272     function mul(D256 memory self, uint256 b)
1273         internal
1274         pure
1275         returns (D256 memory)
1276     {
1277         return D256({value: self.value.mul(b)});
1278     }
1279 
1280     function div(D256 memory self, uint256 b)
1281         internal
1282         pure
1283         returns (D256 memory)
1284     {
1285         return D256({value: self.value.div(b)});
1286     }
1287 
1288     function pow(D256 memory self, uint256 b)
1289         internal
1290         pure
1291         returns (D256 memory)
1292     {
1293         if (b == 0) {
1294             return from(1);
1295         }
1296 
1297         D256 memory temp = D256({value: self.value});
1298         for (uint256 i = 1; i < b; i++) {
1299             temp = mul(temp, self);
1300         }
1301 
1302         return temp;
1303     }
1304 
1305     function add(D256 memory self, D256 memory b)
1306         internal
1307         pure
1308         returns (D256 memory)
1309     {
1310         return D256({value: self.value.add(b.value)});
1311     }
1312 
1313     function sub(D256 memory self, D256 memory b)
1314         internal
1315         pure
1316         returns (D256 memory)
1317     {
1318         return D256({value: self.value.sub(b.value)});
1319     }
1320 
1321     function sub(
1322         D256 memory self,
1323         D256 memory b,
1324         string memory reason
1325     ) internal pure returns (D256 memory) {
1326         return D256({value: self.value.sub(b.value, reason)});
1327     }
1328 
1329     function mul(D256 memory self, D256 memory b)
1330         internal
1331         pure
1332         returns (D256 memory)
1333     {
1334         return D256({value: getPartial(self.value, b.value, BASE)});
1335     }
1336 
1337     function div(D256 memory self, D256 memory b)
1338         internal
1339         pure
1340         returns (D256 memory)
1341     {
1342         return D256({value: getPartial(self.value, BASE, b.value)});
1343     }
1344 
1345     function equals(D256 memory self, D256 memory b)
1346         internal
1347         pure
1348         returns (bool)
1349     {
1350         return self.value == b.value;
1351     }
1352 
1353     function greaterThan(D256 memory self, D256 memory b)
1354         internal
1355         pure
1356         returns (bool)
1357     {
1358         return compareTo(self, b) == 2;
1359     }
1360 
1361     function lessThan(D256 memory self, D256 memory b)
1362         internal
1363         pure
1364         returns (bool)
1365     {
1366         return compareTo(self, b) == 0;
1367     }
1368 
1369     function greaterThanOrEqualTo(D256 memory self, D256 memory b)
1370         internal
1371         pure
1372         returns (bool)
1373     {
1374         return compareTo(self, b) > 0;
1375     }
1376 
1377     function lessThanOrEqualTo(D256 memory self, D256 memory b)
1378         internal
1379         pure
1380         returns (bool)
1381     {
1382         return compareTo(self, b) < 2;
1383     }
1384 
1385     function isZero(D256 memory self) internal pure returns (bool) {
1386         return self.value == 0;
1387     }
1388 
1389     function asUint256(D256 memory self) internal pure returns (uint256) {
1390         return self.value.div(BASE);
1391     }
1392 
1393     // ============ Core Methods ============
1394 
1395     function getPartial(
1396         uint256 target,
1397         uint256 numerator,
1398         uint256 denominator
1399     ) private pure returns (uint256) {
1400         return target.mul(numerator).div(denominator);
1401     }
1402 
1403     function compareTo(D256 memory a, D256 memory b)
1404         private
1405         pure
1406         returns (uint256)
1407     {
1408         if (a.value == b.value) {
1409             return 1;
1410         }
1411         return a.value > b.value ? 2 : 0;
1412     }
1413 }
1414 
1415 // File: contracts/Constants.sol
1416 
1417 /*
1418     Copyright 2020 Zero Collateral Devs, standing on the shoulders of the Empty Set Squad <zaifinance@protonmail.com>
1419 
1420     Licensed under the Apache License, Version 2.0 (the "License");
1421     you may not use this file except in compliance with the License.
1422     You may obtain a copy of the License at
1423 
1424     http://www.apache.org/licenses/LICENSE-2.0
1425 
1426     Unless required by applicable law or agreed to in writing, software
1427     distributed under the License is distributed on an "AS IS" BASIS,
1428     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1429     See the License for the specific language governing permissions and
1430     limitations under the License.
1431 */
1432 
1433 
1434 
1435 library Constants {
1436     /* Chain */
1437     uint256 private constant CHAIN_ID = 1; // Mainnet
1438 
1439     /* Bootstrapping */
1440     uint256 private constant BOOTSTRAPPING_PERIOD = 240; // 5 cycles
1441     uint256 private constant BOOTSTRAPPING_PRICE = 11e17; // 1.10 DAI
1442 
1443     /* Oracle */
1444     address private constant DAI_ADDRESS =
1445         address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
1446     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e22; // 10,000 DAI
1447 
1448     /* Bonding */
1449     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 ZAI -> 100M ZAIS
1450 
1451     /* Epoch */
1452     struct EpochStrategy {
1453         uint256 offset;
1454         uint256 start;
1455         uint256 period;
1456     }
1457 
1458     uint256 private constant CURRENT_EPOCH_OFFSET = 0;
1459     uint256 private constant CURRENT_EPOCH_START = 1611014400;
1460     uint256 private constant CURRENT_EPOCH_PERIOD = 1800;
1461 
1462     /* Governance */
1463     uint256 private constant GOVERNANCE_PERIOD = 144; // 3 cycles
1464     uint256 private constant GOVERNANCE_EXPIRATION = 48;
1465     uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
1466     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 5e15; // 0.5%
1467     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
1468     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 96; // 2 cycles
1469 
1470     /* DAO */
1471     uint256 private constant ADVANCE_INCENTIVE = 1e20; // 100 ZAI
1472     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 240; // 5 cycles fluid
1473 
1474     /* Pool */
1475     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 144; // 3 cycles fluid
1476 
1477     /* Market */
1478     uint256 private constant COUPON_EXPIRATION = 17520; // 365 cycles
1479     uint256 private constant DEBT_RATIO_CAP = 20e16; // 20%
1480 
1481     /* Regulator */
1482     uint256 private constant SUPPLY_CHANGE_LIMIT = 1e16; // 1%
1483     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 2e16; // 2%
1484     uint256 private constant ORACLE_POOL_RATIO = 50; // 50%
1485     uint256 private constant TREASURY_RATIO = 0; // 0%
1486 
1487     /* Deployed */
1488     address private constant TREASURY_ADDRESS =
1489         address(0x0000000000000000000000000000000000000000);
1490 
1491     /**
1492      * Getters
1493      */
1494 
1495     function getDaiAddress() internal pure returns (address) {
1496         return DAI_ADDRESS;
1497     }
1498 
1499     function getOracleReserveMinimum() internal pure returns (uint256) {
1500         return ORACLE_RESERVE_MINIMUM;
1501     }
1502 
1503     function getCurrentEpochStrategy()
1504         internal
1505         pure
1506         returns (EpochStrategy memory)
1507     {
1508         return
1509             EpochStrategy({
1510                 offset: CURRENT_EPOCH_OFFSET,
1511                 start: CURRENT_EPOCH_START,
1512                 period: CURRENT_EPOCH_PERIOD
1513             });
1514     }
1515 
1516     function getInitialStakeMultiple() internal pure returns (uint256) {
1517         return INITIAL_STAKE_MULTIPLE;
1518     }
1519 
1520     function getBootstrappingPeriod() internal pure returns (uint256) {
1521         return BOOTSTRAPPING_PERIOD;
1522     }
1523 
1524     function getBootstrappingPrice()
1525         internal
1526         pure
1527         returns (Decimal.D256 memory)
1528     {
1529         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1530     }
1531 
1532     function getGovernancePeriod() internal pure returns (uint256) {
1533         return GOVERNANCE_PERIOD;
1534     }
1535 
1536     function getGovernanceExpiration() internal pure returns (uint256) {
1537         return GOVERNANCE_EXPIRATION;
1538     }
1539 
1540     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1541         return Decimal.D256({value: GOVERNANCE_QUORUM});
1542     }
1543 
1544     function getGovernanceProposalThreshold()
1545         internal
1546         pure
1547         returns (Decimal.D256 memory)
1548     {
1549         return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
1550     }
1551 
1552     function getGovernanceSuperMajority()
1553         internal
1554         pure
1555         returns (Decimal.D256 memory)
1556     {
1557         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1558     }
1559 
1560     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1561         return GOVERNANCE_EMERGENCY_DELAY;
1562     }
1563 
1564     function getAdvanceIncentive() internal pure returns (uint256) {
1565         return ADVANCE_INCENTIVE;
1566     }
1567 
1568     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1569         return DAO_EXIT_LOCKUP_EPOCHS;
1570     }
1571 
1572     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1573         return POOL_EXIT_LOCKUP_EPOCHS;
1574     }
1575 
1576     function getCouponExpiration() internal pure returns (uint256) {
1577         return COUPON_EXPIRATION;
1578     }
1579 
1580     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1581         return Decimal.D256({value: DEBT_RATIO_CAP});
1582     }
1583 
1584     function getSupplyChangeLimit()
1585         internal
1586         pure
1587         returns (Decimal.D256 memory)
1588     {
1589         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1590     }
1591 
1592     function getCouponSupplyChangeLimit()
1593         internal
1594         pure
1595         returns (Decimal.D256 memory)
1596     {
1597         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
1598     }
1599 
1600     function getOraclePoolRatio() internal pure returns (uint256) {
1601         return ORACLE_POOL_RATIO;
1602     }
1603 
1604     function getTreasuryRatio() internal pure returns (uint256) {
1605         return TREASURY_RATIO;
1606     }
1607 
1608     function getChainId() internal pure returns (uint256) {
1609         return CHAIN_ID;
1610     }
1611 
1612     function getTreasuryAddress() internal pure returns (address) {
1613         return TREASURY_ADDRESS;
1614     }
1615 }
1616 
1617 // File: contracts/token/Permittable.sol
1618 
1619 /*
1620     Copyright 2020 Zero Collateral Devs, standing on the shoulders of the Empty Set Squad <zaifinance@protonmail.com>
1621 
1622     Licensed under the Apache License, Version 2.0 (the "License");
1623     you may not use this file except in compliance with the License.
1624     You may obtain a copy of the License at
1625 
1626     http://www.apache.org/licenses/LICENSE-2.0
1627 
1628     Unless required by applicable law or agreed to in writing, software
1629     distributed under the License is distributed on an "AS IS" BASIS,
1630     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1631     See the License for the specific language governing permissions and
1632     limitations under the License.
1633 */
1634 
1635 
1636 
1637 
1638 
1639 
1640 
1641 contract Permittable is ERC20Detailed, ERC20 {
1642     bytes32 constant FILE = "Permittable";
1643 
1644     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1645     bytes32
1646         public constant EIP712_PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1647     string private constant EIP712_VERSION = "1";
1648 
1649     bytes32 public EIP712_DOMAIN_SEPARATOR;
1650 
1651     mapping(address => uint256) nonces;
1652 
1653     constructor() public {
1654         EIP712_DOMAIN_SEPARATOR = LibEIP712.hashEIP712Domain(
1655             name(),
1656             EIP712_VERSION,
1657             Constants.getChainId(),
1658             address(this)
1659         );
1660     }
1661 
1662     function permit(
1663         address owner,
1664         address spender,
1665         uint256 value,
1666         uint256 deadline,
1667         uint8 v,
1668         bytes32 r,
1669         bytes32 s
1670     ) external {
1671         bytes32 digest = LibEIP712.hashEIP712Message(
1672             EIP712_DOMAIN_SEPARATOR,
1673             keccak256(
1674                 abi.encode(
1675                     EIP712_PERMIT_TYPEHASH,
1676                     owner,
1677                     spender,
1678                     value,
1679                     nonces[owner]++,
1680                     deadline
1681                 )
1682             )
1683         );
1684 
1685         address recovered = ecrecover(digest, v, r, s);
1686         Require.that(recovered == owner, FILE, "Invalid signature");
1687 
1688         Require.that(recovered != address(0), FILE, "Zero address");
1689 
1690         Require.that(now <= deadline, FILE, "Expired");
1691 
1692         _approve(owner, spender, value);
1693     }
1694 }
1695 
1696 // File: contracts/token/IDollar.sol
1697 
1698 /*
1699     Copyright 2020 Zero Collateral Devs, standing on the shoulders of the Empty Set Squad <zaifinance@protonmail.com>
1700 
1701     Licensed under the Apache License, Version 2.0 (the "License");
1702     you may not use this file except in compliance with the License.
1703     You may obtain a copy of the License at
1704 
1705     http://www.apache.org/licenses/LICENSE-2.0
1706 
1707     Unless required by applicable law or agreed to in writing, software
1708     distributed under the License is distributed on an "AS IS" BASIS,
1709     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1710     See the License for the specific language governing permissions and
1711     limitations under the License.
1712 */
1713 
1714 
1715 
1716 contract IDollar is IERC20 {
1717     function burn(uint256 amount) public;
1718 
1719     function burnFrom(address account, uint256 amount) public;
1720 
1721     function mint(address account, uint256 amount) public returns (bool);
1722 }
1723 
1724 // File: contracts/token/Dollar.sol
1725 
1726 /*
1727     Copyright 2020 Zero Collateral Devs, standing on the shoulders of the Empty Set Squad <zaifinance@protonmail.com>
1728 
1729     Licensed under the Apache License, Version 2.0 (the "License");
1730     you may not use this file except in compliance with the License.
1731     You may obtain a copy of the License at
1732 
1733     http://www.apache.org/licenses/LICENSE-2.0
1734 
1735     Unless required by applicable law or agreed to in writing, software
1736     distributed under the License is distributed on an "AS IS" BASIS,
1737     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1738     See the License for the specific language governing permissions and
1739     limitations under the License.
1740 */
1741 
1742 
1743 
1744 
1745 
1746 
1747 
1748 contract Dollar is
1749     IDollar,
1750     MinterRole,
1751     ERC20Detailed,
1752     Permittable,
1753     ERC20Burnable
1754 {
1755     constructor()
1756         public
1757         ERC20Detailed("Zero Collateral Dai: V2", "ZAIv2", 18)
1758         Permittable()
1759     {}
1760 
1761     function mint(address account, uint256 amount)
1762         public
1763         onlyMinter
1764         returns (bool)
1765     {
1766         _mint(account, amount);
1767         return true;
1768     }
1769 
1770     function transferFrom(
1771         address sender,
1772         address recipient,
1773         uint256 amount
1774     ) public returns (bool) {
1775         _transfer(sender, recipient, amount);
1776         if (allowance(sender, _msgSender()) != uint256(-1)) {
1777             _approve(
1778                 sender,
1779                 _msgSender(),
1780                 allowance(sender, _msgSender()).sub(
1781                     amount,
1782                     "Dollar: transfer amount exceeds allowance"
1783                 )
1784             );
1785         }
1786         return true;
1787     }
1788 }
1789 
1790 // File: contracts/token/ZaiV2.sol
1791 
1792 /*
1793     Copyright 2020 Zero Collateral Devs, standing on the shoulders of the Empty Set Squad <zaifinance@protonmail.com>
1794 
1795     Licensed under the Apache License, Version 2.0 (the "License");
1796     you may not use this file except in compliance with the License.
1797     You may obtain a copy of the License at
1798 
1799     http://www.apache.org/licenses/LICENSE-2.0
1800 
1801     Unless required by applicable law or agreed to in writing, software
1802     distributed under the License is distributed on an "AS IS" BASIS,
1803     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1804     See the License for the specific language governing permissions and
1805     limitations under the License.
1806 */
1807 
1808 
1809 
1810 
1811 contract ZaiV2 is Dollar {
1812     // 100:1 ZAI for ZAIv2
1813     uint256 public constant SWAP_EXCHANGE_RATE = 100;
1814 
1815     // Total supply of ZAI at the time of reset. Cannot swap more than that
1816     uint256 public constant MAX_ZAI_SWAPPABLE = 395407172763503943977588203;
1817 
1818     // Track zai that has been swapped
1819     uint256 public oldZaiSwapped = 0;
1820 
1821     // Original ZAI token address must be this on mainnet.
1822     // address(0x9d1233cc46795E94029fDA81aAaDc1455D510f15);
1823     // Only settable in the constructor for testing
1824     IDollar internal _oldZai;
1825 
1826     event BurnAndSwap(
1827         address indexed operator,
1828         address indexed from,
1829         uint256 burnAmount,
1830         uint256 mintAmount
1831     );
1832 
1833     constructor(address oldZaiAddress) public Dollar() {
1834         _oldZai = IDollar(oldZaiAddress);
1835     }
1836 
1837     // Approve the amount of ZAI for the ZAIv2 contract to burn and swap, then
1838     // call burnAndSwap for the address.
1839     function burnAndSwap(address from) public {
1840         uint256 burnAmount = _oldZai.allowance(from, address(this));
1841         require(burnAmount > 0, "gotta burn if you wanna earn...");
1842 
1843         oldZaiSwapped = oldZaiSwapped.add(burnAmount);
1844         require(
1845             oldZaiSwapped <= MAX_ZAI_SWAPPABLE,
1846             "where did all that ZAI come from..."
1847         );
1848 
1849         uint256 mintAmount = burnAmount.div(SWAP_EXCHANGE_RATE);
1850         require(mintAmount > 0, "how you gonna mint 0 of something?");
1851 
1852         _oldZai.transferFrom(from, address(this), burnAmount);
1853         _oldZai.burn(burnAmount);
1854 
1855         _mint(from, mintAmount);
1856 
1857         emit BurnAndSwap(msg.sender, from, burnAmount, mintAmount);
1858     }
1859 }