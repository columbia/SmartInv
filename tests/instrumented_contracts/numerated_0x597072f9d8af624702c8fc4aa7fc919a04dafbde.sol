1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-24
3 */
4 
5 pragma solidity ^0.5.17;
6 pragma experimental ABIEncoderV2;
7 
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
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      * - Addition cannot overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         require(c >= a, "SafeMath: addition overflow");
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      * - Subtraction cannot overflow.
161      *
162      * _Available since v2.4.0._
163      */
164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `*` operator.
176      *
177      * Requirements:
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return div(a, b, "SafeMath: division by zero");
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      * - The divisor cannot be zero.
219      *
220      * _Available since v2.4.0._
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         // Solidity only automatically asserts when dividing by 0
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      * - The divisor cannot be zero.
256      *
257      * _Available since v2.4.0._
258      */
259     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b != 0, errorMessage);
261         return a % b;
262     }
263 }
264 
265 /**
266  * @dev Implementation of the {IERC20} interface.
267  *
268  * This implementation is agnostic to the way tokens are created. This means
269  * that a supply mechanism has to be added in a derived contract using {_mint}.
270  * For a generic mechanism see {ERC20Mintable}.
271  *
272  * TIP: For a detailed writeup see our guide
273  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
274  * to implement supply mechanisms].
275  *
276  * We have followed general OpenZeppelin guidelines: functions revert instead
277  * of returning `false` on failure. This behavior is nonetheless conventional
278  * and does not conflict with the expectations of ERC20 applications.
279  *
280  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
281  * This allows applications to reconstruct the allowance for all accounts just
282  * by listening to said events. Other implementations of the EIP may not emit
283  * these events, as it isn't required by the specification.
284  *
285  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
286  * functions have been added to mitigate the well-known issues around setting
287  * allowances. See {IERC20-approve}.
288  */
289 contract ERC20 is Context, IERC20 {
290     using SafeMath for uint256;
291 
292     mapping (address => uint256) private _balances;
293 
294     mapping (address => mapping (address => uint256)) private _allowances;
295 
296     uint256 private _totalSupply;
297 
298     /**
299      * @dev See {IERC20-totalSupply}.
300      */
301     function totalSupply() public view returns (uint256) {
302         return _totalSupply;
303     }
304 
305     /**
306      * @dev See {IERC20-balanceOf}.
307      */
308     function balanceOf(address account) public view returns (uint256) {
309         return _balances[account];
310     }
311 
312     /**
313      * @dev See {IERC20-transfer}.
314      *
315      * Requirements:
316      *
317      * - `recipient` cannot be the zero address.
318      * - the caller must have a balance of at least `amount`.
319      */
320     function transfer(address recipient, uint256 amount) public returns (bool) {
321         _transfer(_msgSender(), recipient, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See {IERC20-allowance}.
327      */
328     function allowance(address owner, address spender) public view returns (uint256) {
329         return _allowances[owner][spender];
330     }
331 
332     /**
333      * @dev See {IERC20-approve}.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      */
339     function approve(address spender, uint256 amount) public returns (bool) {
340         _approve(_msgSender(), spender, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-transferFrom}.
346      *
347      * Emits an {Approval} event indicating the updated allowance. This is not
348      * required by the EIP. See the note at the beginning of {ERC20};
349      *
350      * Requirements:
351      * - `sender` and `recipient` cannot be the zero address.
352      * - `sender` must have a balance of at least `amount`.
353      * - the caller must have allowance for `sender`'s tokens of at least
354      * `amount`.
355      */
356     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
357         _transfer(sender, recipient, amount);
358         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
359         return true;
360     }
361 
362     /**
363      * @dev Atomically increases the allowance granted to `spender` by the caller.
364      *
365      * This is an alternative to {approve} that can be used as a mitigation for
366      * problems described in {IERC20-approve}.
367      *
368      * Emits an {Approval} event indicating the updated allowance.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
375         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
376         return true;
377     }
378 
379     /**
380      * @dev Atomically decreases the allowance granted to `spender` by the caller.
381      *
382      * This is an alternative to {approve} that can be used as a mitigation for
383      * problems described in {IERC20-approve}.
384      *
385      * Emits an {Approval} event indicating the updated allowance.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      * - `spender` must have allowance for the caller of at least
391      * `subtractedValue`.
392      */
393     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
394         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
395         return true;
396     }
397 
398     /**
399      * @dev Moves tokens `amount` from `sender` to `recipient`.
400      *
401      * This is internal function is equivalent to {transfer}, and can be used to
402      * e.g. implement automatic token fees, slashing mechanisms, etc.
403      *
404      * Emits a {Transfer} event.
405      *
406      * Requirements:
407      *
408      * - `sender` cannot be the zero address.
409      * - `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      */
412     function _transfer(address sender, address recipient, uint256 amount) internal {
413         require(sender != address(0), "ERC20: transfer from the zero address");
414         require(recipient != address(0), "ERC20: transfer to the zero address");
415 
416         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
417         _balances[recipient] = _balances[recipient].add(amount);
418         emit Transfer(sender, recipient, amount);
419     }
420 
421     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
422      * the total supply.
423      *
424      * Emits a {Transfer} event with `from` set to the zero address.
425      *
426      * Requirements
427      *
428      * - `to` cannot be the zero address.
429      */
430     function _mint(address account, uint256 amount) internal {
431         require(account != address(0), "ERC20: mint to the zero address");
432 
433         _totalSupply = _totalSupply.add(amount);
434         _balances[account] = _balances[account].add(amount);
435         emit Transfer(address(0), account, amount);
436     }
437 
438     /**
439      * @dev Destroys `amount` tokens from `account`, reducing the
440      * total supply.
441      *
442      * Emits a {Transfer} event with `to` set to the zero address.
443      *
444      * Requirements
445      *
446      * - `account` cannot be the zero address.
447      * - `account` must have at least `amount` tokens.
448      */
449     function _burn(address account, uint256 amount) internal {
450         require(account != address(0), "ERC20: burn from the zero address");
451 
452         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
453         _totalSupply = _totalSupply.sub(amount);
454         emit Transfer(account, address(0), amount);
455     }
456 
457     /**
458      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
459      *
460      * This is internal function is equivalent to `approve`, and can be used to
461      * e.g. set automatic allowances for certain subsystems, etc.
462      *
463      * Emits an {Approval} event.
464      *
465      * Requirements:
466      *
467      * - `owner` cannot be the zero address.
468      * - `spender` cannot be the zero address.
469      */
470     function _approve(address owner, address spender, uint256 amount) internal {
471         require(owner != address(0), "ERC20: approve from the zero address");
472         require(spender != address(0), "ERC20: approve to the zero address");
473 
474         _allowances[owner][spender] = amount;
475         emit Approval(owner, spender, amount);
476     }
477 
478     /**
479      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
480      * from the caller's allowance.
481      *
482      * See {_burn} and {_approve}.
483      */
484     function _burnFrom(address account, uint256 amount) internal {
485         _burn(account, amount);
486         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
487     }
488 }
489 
490 /**
491  * @dev Extension of {ERC20} that allows token holders to destroy both their own
492  * tokens and those that they have an allowance for, in a way that can be
493  * recognized off-chain (via event analysis).
494  */
495 contract ERC20Burnable is Context, ERC20 {
496     /**
497      * @dev Destroys `amount` tokens from the caller.
498      *
499      * See {ERC20-_burn}.
500      */
501     function burn(uint256 amount) public {
502         _burn(_msgSender(), amount);
503     }
504 
505     /**
506      * @dev See {ERC20-_burnFrom}.
507      */
508     function burnFrom(address account, uint256 amount) public {
509         _burnFrom(account, amount);
510     }
511 }
512 
513 /**
514  * @dev Optional functions from the ERC20 standard.
515  */
516 contract ERC20Detailed is IERC20 {
517     string private _name;
518     string private _symbol;
519     uint8 private _decimals;
520 
521     /**
522      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
523      * these values are immutable: they can only be set once during
524      * construction.
525      */
526     constructor (string memory name, string memory symbol, uint8 decimals) public {
527         _name = name;
528         _symbol = symbol;
529         _decimals = decimals;
530     }
531 
532     /**
533      * @dev Returns the name of the token.
534      */
535     function name() public view returns (string memory) {
536         return _name;
537     }
538 
539     /**
540      * @dev Returns the symbol of the token, usually a shorter version of the
541      * name.
542      */
543     function symbol() public view returns (string memory) {
544         return _symbol;
545     }
546 
547     /**
548      * @dev Returns the number of decimals used to get its user representation.
549      * For example, if `decimals` equals `2`, a balance of `505` tokens should
550      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
551      *
552      * Tokens usually opt for a value of 18, imitating the relationship between
553      * Ether and Wei.
554      *
555      * NOTE: This information is only used for _display_ purposes: it in
556      * no way affects any of the arithmetic of the contract, including
557      * {IERC20-balanceOf} and {IERC20-transfer}.
558      */
559     function decimals() public view returns (uint8) {
560         return _decimals;
561     }
562 }
563 
564 /**
565  * @title Roles
566  * @dev Library for managing addresses assigned to a Role.
567  */
568 library Roles {
569     struct Role {
570         mapping (address => bool) bearer;
571     }
572 
573     /**
574      * @dev Give an account access to this role.
575      */
576     function add(Role storage role, address account) internal {
577         require(!has(role, account), "Roles: account already has role");
578         role.bearer[account] = true;
579     }
580 
581     /**
582      * @dev Remove an account's access to this role.
583      */
584     function remove(Role storage role, address account) internal {
585         require(has(role, account), "Roles: account does not have role");
586         role.bearer[account] = false;
587     }
588 
589     /**
590      * @dev Check if an account has this role.
591      * @return bool
592      */
593     function has(Role storage role, address account) internal view returns (bool) {
594         require(account != address(0), "Roles: account is the zero address");
595         return role.bearer[account];
596     }
597 }
598 
599 contract MinterRole is Context {
600     using Roles for Roles.Role;
601 
602     event MinterAdded(address indexed account);
603     event MinterRemoved(address indexed account);
604 
605     Roles.Role private _minters;
606 
607     constructor () internal {
608         _addMinter(_msgSender());
609     }
610 
611     modifier onlyMinter() {
612         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
613         _;
614     }
615 
616     function isMinter(address account) public view returns (bool) {
617         return _minters.has(account);
618     }
619 
620     function addMinter(address account) public onlyMinter {
621         _addMinter(account);
622     }
623 
624     function renounceMinter() public {
625         _removeMinter(_msgSender());
626     }
627 
628     function _addMinter(address account) internal {
629         _minters.add(account);
630         emit MinterAdded(account);
631     }
632 
633     function _removeMinter(address account) internal {
634         _minters.remove(account);
635         emit MinterRemoved(account);
636     }
637 }
638 
639 /*
640     Copyright 2019 dYdX Trading Inc.
641 
642     Licensed under the Apache License, Version 2.0 (the "License");
643     you may not use this file except in compliance with the License.
644     You may obtain a copy of the License at
645 
646     http://www.apache.org/licenses/LICENSE-2.0
647 
648     Unless required by applicable law or agreed to in writing, software
649     distributed under the License is distributed on an "AS IS" BASIS,
650     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
651     See the License for the specific language governing permissions and
652     limitations under the License.
653 */
654 /**
655  * @title Require
656  * @author dYdX
657  *
658  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
659  */
660 library Require {
661 
662     // ============ Constants ============
663 
664     uint256 constant ASCII_ZERO = 48; // '0'
665     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
666     uint256 constant ASCII_LOWER_EX = 120; // 'x'
667     bytes2 constant COLON = 0x3a20; // ': '
668     bytes2 constant COMMA = 0x2c20; // ', '
669     bytes2 constant LPAREN = 0x203c; // ' <'
670     byte constant RPAREN = 0x3e; // '>'
671     uint256 constant FOUR_BIT_MASK = 0xf;
672 
673     // ============ Library Functions ============
674 
675     function that(
676         bool must,
677         bytes32 file,
678         bytes32 reason
679     )
680     internal
681     pure
682     {
683         if (!must) {
684             revert(
685                 string(
686                     abi.encodePacked(
687                         stringifyTruncated(file),
688                         COLON,
689                         stringifyTruncated(reason)
690                     )
691                 )
692             );
693         }
694     }
695 
696     function that(
697         bool must,
698         bytes32 file,
699         bytes32 reason,
700         uint256 payloadA
701     )
702     internal
703     pure
704     {
705         if (!must) {
706             revert(
707                 string(
708                     abi.encodePacked(
709                         stringifyTruncated(file),
710                         COLON,
711                         stringifyTruncated(reason),
712                         LPAREN,
713                         stringify(payloadA),
714                         RPAREN
715                     )
716                 )
717             );
718         }
719     }
720 
721     function that(
722         bool must,
723         bytes32 file,
724         bytes32 reason,
725         uint256 payloadA,
726         uint256 payloadB
727     )
728     internal
729     pure
730     {
731         if (!must) {
732             revert(
733                 string(
734                     abi.encodePacked(
735                         stringifyTruncated(file),
736                         COLON,
737                         stringifyTruncated(reason),
738                         LPAREN,
739                         stringify(payloadA),
740                         COMMA,
741                         stringify(payloadB),
742                         RPAREN
743                     )
744                 )
745             );
746         }
747     }
748 
749     function that(
750         bool must,
751         bytes32 file,
752         bytes32 reason,
753         address payloadA
754     )
755     internal
756     pure
757     {
758         if (!must) {
759             revert(
760                 string(
761                     abi.encodePacked(
762                         stringifyTruncated(file),
763                         COLON,
764                         stringifyTruncated(reason),
765                         LPAREN,
766                         stringify(payloadA),
767                         RPAREN
768                     )
769                 )
770             );
771         }
772     }
773 
774     function that(
775         bool must,
776         bytes32 file,
777         bytes32 reason,
778         address payloadA,
779         uint256 payloadB
780     )
781     internal
782     pure
783     {
784         if (!must) {
785             revert(
786                 string(
787                     abi.encodePacked(
788                         stringifyTruncated(file),
789                         COLON,
790                         stringifyTruncated(reason),
791                         LPAREN,
792                         stringify(payloadA),
793                         COMMA,
794                         stringify(payloadB),
795                         RPAREN
796                     )
797                 )
798             );
799         }
800     }
801 
802     function that(
803         bool must,
804         bytes32 file,
805         bytes32 reason,
806         address payloadA,
807         uint256 payloadB,
808         uint256 payloadC
809     )
810     internal
811     pure
812     {
813         if (!must) {
814             revert(
815                 string(
816                     abi.encodePacked(
817                         stringifyTruncated(file),
818                         COLON,
819                         stringifyTruncated(reason),
820                         LPAREN,
821                         stringify(payloadA),
822                         COMMA,
823                         stringify(payloadB),
824                         COMMA,
825                         stringify(payloadC),
826                         RPAREN
827                     )
828                 )
829             );
830         }
831     }
832 
833     function that(
834         bool must,
835         bytes32 file,
836         bytes32 reason,
837         bytes32 payloadA
838     )
839     internal
840     pure
841     {
842         if (!must) {
843             revert(
844                 string(
845                     abi.encodePacked(
846                         stringifyTruncated(file),
847                         COLON,
848                         stringifyTruncated(reason),
849                         LPAREN,
850                         stringify(payloadA),
851                         RPAREN
852                     )
853                 )
854             );
855         }
856     }
857 
858     function that(
859         bool must,
860         bytes32 file,
861         bytes32 reason,
862         bytes32 payloadA,
863         uint256 payloadB,
864         uint256 payloadC
865     )
866     internal
867     pure
868     {
869         if (!must) {
870             revert(
871                 string(
872                     abi.encodePacked(
873                         stringifyTruncated(file),
874                         COLON,
875                         stringifyTruncated(reason),
876                         LPAREN,
877                         stringify(payloadA),
878                         COMMA,
879                         stringify(payloadB),
880                         COMMA,
881                         stringify(payloadC),
882                         RPAREN
883                     )
884                 )
885             );
886         }
887     }
888 
889     // ============ Private Functions ============
890 
891     function stringifyTruncated(
892         bytes32 input
893     )
894     private
895     pure
896     returns (bytes memory)
897     {
898         // put the input bytes into the result
899         bytes memory result = abi.encodePacked(input);
900 
901         // determine the length of the input by finding the location of the last non-zero byte
902         for (uint256 i = 32; i > 0; ) {
903             // reverse-for-loops with unsigned integer
904             /* solium-disable-next-line security/no-modify-for-iter-var */
905             i--;
906 
907             // find the last non-zero byte in order to determine the length
908             if (result[i] != 0) {
909                 uint256 length = i + 1;
910 
911                 /* solium-disable-next-line security/no-inline-assembly */
912                 assembly {
913                     mstore(result, length) // r.length = length;
914                 }
915 
916                 return result;
917             }
918         }
919 
920         // all bytes are zero
921         return new bytes(0);
922     }
923 
924     function stringify(
925         uint256 input
926     )
927     private
928     pure
929     returns (bytes memory)
930     {
931         if (input == 0) {
932             return "0";
933         }
934 
935         // get the final string length
936         uint256 j = input;
937         uint256 length;
938         while (j != 0) {
939             length++;
940             j /= 10;
941         }
942 
943         // allocate the string
944         bytes memory bstr = new bytes(length);
945 
946         // populate the string starting with the least-significant character
947         j = input;
948         for (uint256 i = length; i > 0; ) {
949             // reverse-for-loops with unsigned integer
950             /* solium-disable-next-line security/no-modify-for-iter-var */
951             i--;
952 
953             // take last decimal digit
954             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
955 
956             // remove the last decimal digit
957             j /= 10;
958         }
959 
960         return bstr;
961     }
962 
963     function stringify(
964         address input
965     )
966     private
967     pure
968     returns (bytes memory)
969     {
970         uint256 z = uint256(input);
971 
972         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
973         bytes memory result = new bytes(42);
974 
975         // populate the result with "0x"
976         result[0] = byte(uint8(ASCII_ZERO));
977         result[1] = byte(uint8(ASCII_LOWER_EX));
978 
979         // for each byte (starting from the lowest byte), populate the result with two characters
980         for (uint256 i = 0; i < 20; i++) {
981             // each byte takes two characters
982             uint256 shift = i * 2;
983 
984             // populate the least-significant character
985             result[41 - shift] = char(z & FOUR_BIT_MASK);
986             z = z >> 4;
987 
988             // populate the most-significant character
989             result[40 - shift] = char(z & FOUR_BIT_MASK);
990             z = z >> 4;
991         }
992 
993         return result;
994     }
995 
996     function stringify(
997         bytes32 input
998     )
999     private
1000     pure
1001     returns (bytes memory)
1002     {
1003         uint256 z = uint256(input);
1004 
1005         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
1006         bytes memory result = new bytes(66);
1007 
1008         // populate the result with "0x"
1009         result[0] = byte(uint8(ASCII_ZERO));
1010         result[1] = byte(uint8(ASCII_LOWER_EX));
1011 
1012         // for each byte (starting from the lowest byte), populate the result with two characters
1013         for (uint256 i = 0; i < 32; i++) {
1014             // each byte takes two characters
1015             uint256 shift = i * 2;
1016 
1017             // populate the least-significant character
1018             result[65 - shift] = char(z & FOUR_BIT_MASK);
1019             z = z >> 4;
1020 
1021             // populate the most-significant character
1022             result[64 - shift] = char(z & FOUR_BIT_MASK);
1023             z = z >> 4;
1024         }
1025 
1026         return result;
1027     }
1028 
1029     function char(
1030         uint256 input
1031     )
1032     private
1033     pure
1034     returns (byte)
1035     {
1036         // return ASCII digit (0-9)
1037         if (input < 10) {
1038             return byte(uint8(input + ASCII_ZERO));
1039         }
1040 
1041         // return ASCII letter (a-f)
1042         return byte(uint8(input + ASCII_RELATIVE_ZERO));
1043     }
1044 }
1045 
1046 /*
1047     Copyright 2019 ZeroEx Intl.
1048 
1049     Licensed under the Apache License, Version 2.0 (the "License");
1050     you may not use this file except in compliance with the License.
1051     You may obtain a copy of the License at
1052 
1053     http://www.apache.org/licenses/LICENSE-2.0
1054 
1055     Unless required by applicable law or agreed to in writing, software
1056     distributed under the License is distributed on an "AS IS" BASIS,
1057     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1058     See the License for the specific language governing permissions and
1059     limitations under the License.
1060 */
1061 library LibEIP712 {
1062 
1063     // Hash of the EIP712 Domain Separator Schema
1064     // keccak256(abi.encodePacked(
1065     //     "EIP712Domain(",
1066     //     "string name,",
1067     //     "string version,",
1068     //     "uint256 chainId,",
1069     //     "address verifyingContract",
1070     //     ")"
1071     // ))
1072     bytes32 constant internal _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
1073 
1074     /// @dev Calculates a EIP712 domain separator.
1075     /// @param name The EIP712 domain name.
1076     /// @param version The EIP712 domain version.
1077     /// @param verifyingContract The EIP712 verifying contract.
1078     /// @return EIP712 domain separator.
1079     function hashEIP712Domain(
1080         string memory name,
1081         string memory version,
1082         uint256 chainId,
1083         address verifyingContract
1084     )
1085     internal
1086     pure
1087     returns (bytes32 result)
1088     {
1089         bytes32 schemaHash = _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH;
1090 
1091         // Assembly for more efficient computing:
1092         // keccak256(abi.encodePacked(
1093         //     _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
1094         //     keccak256(bytes(name)),
1095         //     keccak256(bytes(version)),
1096         //     chainId,
1097         //     uint256(verifyingContract)
1098         // ))
1099 
1100         assembly {
1101         // Calculate hashes of dynamic data
1102             let nameHash := keccak256(add(name, 32), mload(name))
1103             let versionHash := keccak256(add(version, 32), mload(version))
1104 
1105         // Load free memory pointer
1106             let memPtr := mload(64)
1107 
1108         // Store params in memory
1109             mstore(memPtr, schemaHash)
1110             mstore(add(memPtr, 32), nameHash)
1111             mstore(add(memPtr, 64), versionHash)
1112             mstore(add(memPtr, 96), chainId)
1113             mstore(add(memPtr, 128), verifyingContract)
1114 
1115         // Compute hash
1116             result := keccak256(memPtr, 160)
1117         }
1118         return result;
1119     }
1120 
1121     /// @dev Calculates EIP712 encoding for a hash struct with a given domain hash.
1122     /// @param eip712DomainHash Hash of the domain domain separator data, computed
1123     ///                         with getDomainHash().
1124     /// @param hashStruct The EIP712 hash struct.
1125     /// @return EIP712 hash applied to the given EIP712 Domain.
1126     function hashEIP712Message(bytes32 eip712DomainHash, bytes32 hashStruct)
1127     internal
1128     pure
1129     returns (bytes32 result)
1130     {
1131         // Assembly for more efficient computing:
1132         // keccak256(abi.encodePacked(
1133         //     EIP191_HEADER,
1134         //     EIP712_DOMAIN_HASH,
1135         //     hashStruct
1136         // ));
1137 
1138         assembly {
1139         // Load free memory pointer
1140             let memPtr := mload(64)
1141 
1142             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
1143             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
1144             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
1145 
1146         // Compute hash
1147             result := keccak256(memPtr, 66)
1148         }
1149         return result;
1150     }
1151 }
1152 
1153 /*
1154     Copyright 2019 dYdX Trading Inc.
1155     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1156 
1157     Licensed under the Apache License, Version 2.0 (the "License");
1158     you may not use this file except in compliance with the License.
1159     You may obtain a copy of the License at
1160 
1161     http://www.apache.org/licenses/LICENSE-2.0
1162 
1163     Unless required by applicable law or agreed to in writing, software
1164     distributed under the License is distributed on an "AS IS" BASIS,
1165     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1166     See the License for the specific language governing permissions and
1167     limitations under the License.
1168 */
1169 /**
1170  * @title Decimal
1171  * @author dYdX
1172  *
1173  * Library that defines a fixed-point number with 18 decimal places.
1174  */
1175 library Decimal {
1176     using SafeMath for uint256;
1177 
1178     // ============ Constants ============
1179 
1180     uint256 constant BASE = 10**18;
1181 
1182     // ============ Structs ============
1183 
1184 
1185     struct D256 {
1186         uint256 value;
1187     }
1188 
1189     // ============ Static Functions ============
1190 
1191     function zero()
1192     internal
1193     pure
1194     returns (D256 memory)
1195     {
1196         return D256({ value: 0 });
1197     }
1198 
1199     function one()
1200     internal
1201     pure
1202     returns (D256 memory)
1203     {
1204         return D256({ value: BASE });
1205     }
1206 
1207     function from(
1208         uint256 a
1209     )
1210     internal
1211     pure
1212     returns (D256 memory)
1213     {
1214         return D256({ value: a.mul(BASE) });
1215     }
1216 
1217     function ratio(
1218         uint256 a,
1219         uint256 b
1220     )
1221     internal
1222     pure
1223     returns (D256 memory)
1224     {
1225         return D256({ value: getPartial(a, BASE, b) });
1226     }
1227 
1228     // ============ Self Functions ============
1229 
1230     function add(
1231         D256 memory self,
1232         uint256 b
1233     )
1234     internal
1235     pure
1236     returns (D256 memory)
1237     {
1238         return D256({ value: self.value.add(b.mul(BASE)) });
1239     }
1240 
1241     function sub(
1242         D256 memory self,
1243         uint256 b
1244     )
1245     internal
1246     pure
1247     returns (D256 memory)
1248     {
1249         return D256({ value: self.value.sub(b.mul(BASE)) });
1250     }
1251 
1252     function sub(
1253         D256 memory self,
1254         uint256 b,
1255         string memory reason
1256     )
1257     internal
1258     pure
1259     returns (D256 memory)
1260     {
1261         return D256({ value: self.value.sub(b.mul(BASE), reason) });
1262     }
1263 
1264     function mul(
1265         D256 memory self,
1266         uint256 b
1267     )
1268     internal
1269     pure
1270     returns (D256 memory)
1271     {
1272         return D256({ value: self.value.mul(b) });
1273     }
1274 
1275     function div(
1276         D256 memory self,
1277         uint256 b
1278     )
1279     internal
1280     pure
1281     returns (D256 memory)
1282     {
1283         return D256({ value: self.value.div(b) });
1284     }
1285 
1286     function pow(
1287         D256 memory self,
1288         uint256 b
1289     )
1290     internal
1291     pure
1292     returns (D256 memory)
1293     {
1294         if (b == 0) {
1295             return from(1);
1296         }
1297 
1298         D256 memory temp = D256({ value: self.value });
1299         for (uint256 i = 1; i < b; i++) {
1300             temp = mul(temp, self);
1301         }
1302 
1303         return temp;
1304     }
1305 
1306     function add(
1307         D256 memory self,
1308         D256 memory b
1309     )
1310     internal
1311     pure
1312     returns (D256 memory)
1313     {
1314         return D256({ value: self.value.add(b.value) });
1315     }
1316 
1317     function sub(
1318         D256 memory self,
1319         D256 memory b
1320     )
1321     internal
1322     pure
1323     returns (D256 memory)
1324     {
1325         return D256({ value: self.value.sub(b.value) });
1326     }
1327 
1328     function sub(
1329         D256 memory self,
1330         D256 memory b,
1331         string memory reason
1332     )
1333     internal
1334     pure
1335     returns (D256 memory)
1336     {
1337         return D256({ value: self.value.sub(b.value, reason) });
1338     }
1339 
1340     function mul(
1341         D256 memory self,
1342         D256 memory b
1343     )
1344     internal
1345     pure
1346     returns (D256 memory)
1347     {
1348         return D256({ value: getPartial(self.value, b.value, BASE) });
1349     }
1350 
1351     function div(
1352         D256 memory self,
1353         D256 memory b
1354     )
1355     internal
1356     pure
1357     returns (D256 memory)
1358     {
1359         return D256({ value: getPartial(self.value, BASE, b.value) });
1360     }
1361 
1362     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
1363         return self.value == b.value;
1364     }
1365 
1366     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1367         return compareTo(self, b) == 2;
1368     }
1369 
1370     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1371         return compareTo(self, b) == 0;
1372     }
1373 
1374     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1375         return compareTo(self, b) > 0;
1376     }
1377 
1378     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1379         return compareTo(self, b) < 2;
1380     }
1381 
1382     function isZero(D256 memory self) internal pure returns (bool) {
1383         return self.value == 0;
1384     }
1385 
1386     function asUint256(D256 memory self) internal pure returns (uint256) {
1387         return self.value.div(BASE);
1388     }
1389 
1390     // ============ Core Methods ============
1391 
1392     function getPartial(
1393         uint256 target,
1394         uint256 numerator,
1395         uint256 denominator
1396     )
1397     private
1398     pure
1399     returns (uint256)
1400     {
1401         return target.mul(numerator).div(denominator);
1402     }
1403 
1404     function compareTo(
1405         D256 memory a,
1406         D256 memory b
1407     )
1408     private
1409     pure
1410     returns (uint256)
1411     {
1412         if (a.value == b.value) {
1413             return 1;
1414         }
1415         return a.value > b.value ? 2 : 0;
1416     }
1417 }
1418 
1419 /*
1420     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1421 
1422     Licensed under the Apache License, Version 2.0 (the "License");
1423     you may not use this file except in compliance with the License.
1424     You may obtain a copy of the License at
1425 
1426     http://www.apache.org/licenses/LICENSE-2.0
1427 
1428     Unless required by applicable law or agreed to in writing, software
1429     distributed under the License is distributed on an "AS IS" BASIS,
1430     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1431     See the License for the specific language governing permissions and
1432     limitations under the License.
1433 */
1434 library Constants {
1435     /* Chain */
1436     uint256 private constant CHAIN_ID = 1; // Mainnet
1437 
1438     /* Bootstrapping */
1439     uint256 private constant BOOTSTRAPPING_PERIOD = 300;
1440     uint256 private constant BOOTSTRAPPING_PRICE = 154e16; // 1.54 USDC
1441     uint256 private constant BOOTSTRAPPING_SPEEDUP_FACTOR = 3; // 30 days @ 8 hours
1442 
1443     /* Oracle */
1444     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
1445     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 USDC
1446 
1447     /* Bonding */
1448     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 ESD -> 100M ESDS
1449 
1450     /* Epoch */
1451     uint256 private constant EPOCH_PERIOD = 3600; // 1 hour
1452 
1453     /* Governance */
1454     uint256 private constant GOVERNANCE_PERIOD = 72;
1455     uint256 private constant GOVERNANCE_QUORUM = 33e16; // 33%
1456 
1457     /* DAO */
1458     uint256 private constant ADVANCE_INCENTIVE = 1e20; // 100 ESD
1459 
1460     /* Market */
1461     uint256 private constant COUPON_EXPIRATION = 360;
1462 
1463     /* Regulator */
1464     uint256 private constant SUPPLY_CHANGE_LIMIT = 2e16; // 2%
1465     uint256 private constant ORACLE_POOL_RATIO = 40; // 40%
1466 
1467 
1468     /**
1469      * Getters
1470      */
1471 
1472     function getUsdc() internal pure returns (address) {
1473         return USDC;
1474     }
1475 
1476     function getOracleReserveMinimum() internal pure returns (uint256) {
1477         return ORACLE_RESERVE_MINIMUM;
1478     }
1479 
1480     function getEpochPeriod() internal pure returns (uint256) {
1481         return EPOCH_PERIOD;
1482     }
1483 
1484     function getInitialStakeMultiple() internal pure returns (uint256) {
1485         return INITIAL_STAKE_MULTIPLE;
1486     }
1487 
1488     function getBootstrappingPeriod() internal pure returns (uint256) {
1489         return BOOTSTRAPPING_PERIOD;
1490     }
1491 
1492     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1493         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1494     }
1495 
1496     function getBootstrappingSpeedupFactor() internal pure returns (uint256) {
1497         return BOOTSTRAPPING_SPEEDUP_FACTOR;
1498     }
1499 
1500     function getGovernancePeriod() internal pure returns (uint256) {
1501         return GOVERNANCE_PERIOD;
1502     }
1503 
1504     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1505         return Decimal.D256({value: GOVERNANCE_QUORUM});
1506     }
1507 
1508     function getAdvanceIncentive() internal pure returns (uint256) {
1509         return ADVANCE_INCENTIVE;
1510     }
1511 
1512     function getCouponExpiration() internal pure returns (uint256) {
1513         return COUPON_EXPIRATION;
1514     }
1515 
1516     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1517         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1518     }
1519 
1520     function getOraclePoolRatio() internal pure returns (uint256) {
1521         return ORACLE_POOL_RATIO;
1522     }
1523 
1524     function getChainId() internal pure returns (uint256) {
1525         return CHAIN_ID;
1526     }
1527 }
1528 
1529 /*
1530     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1531 
1532     Licensed under the Apache License, Version 2.0 (the "License");
1533     you may not use this file except in compliance with the License.
1534     You may obtain a copy of the License at
1535 
1536     http://www.apache.org/licenses/LICENSE-2.0
1537 
1538     Unless required by applicable law or agreed to in writing, software
1539     distributed under the License is distributed on an "AS IS" BASIS,
1540     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1541     See the License for the specific language governing permissions and
1542     limitations under the License.
1543 */
1544 contract Permittable is ERC20Detailed, ERC20 {
1545     bytes32 constant FILE = "Permittable";
1546 
1547     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1548     bytes32 public constant EIP712_PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1549     string private constant EIP712_VERSION = "1";
1550 
1551     bytes32 public EIP712_DOMAIN_SEPARATOR;
1552 
1553     mapping(address => uint256) nonces;
1554 
1555     constructor() public {
1556         EIP712_DOMAIN_SEPARATOR = LibEIP712.hashEIP712Domain(name(), EIP712_VERSION, Constants.getChainId(), address(this));
1557     }
1558 
1559     function permit(
1560         address owner,
1561         address spender,
1562         uint256 value,
1563         uint256 deadline,
1564         uint8 v,
1565         bytes32 r,
1566         bytes32 s
1567     ) external {
1568         bytes32 digest = LibEIP712.hashEIP712Message(
1569             EIP712_DOMAIN_SEPARATOR,
1570             keccak256(abi.encode(
1571                 EIP712_PERMIT_TYPEHASH,
1572                 owner,
1573                 spender,
1574                 value,
1575                 nonces[owner]++,
1576                 deadline
1577             ))
1578         );
1579 
1580         address recovered = ecrecover(digest, v, r, s);
1581         Require.that(
1582             recovered == owner,
1583             FILE,
1584             "Invalid signature"
1585         );
1586 
1587         Require.that(
1588             recovered != address(0),
1589             FILE,
1590             "Zero address"
1591         );
1592 
1593         Require.that(
1594             now <= deadline,
1595             FILE,
1596             "Expired"
1597         );
1598 
1599         _approve(owner, spender, value);
1600     }
1601 }
1602 
1603 /*
1604     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1605 
1606     Licensed under the Apache License, Version 2.0 (the "License");
1607     you may not use this file except in compliance with the License.
1608     You may obtain a copy of the License at
1609 
1610     http://www.apache.org/licenses/LICENSE-2.0
1611 
1612     Unless required by applicable law or agreed to in writing, software
1613     distributed under the License is distributed on an "AS IS" BASIS,
1614     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1615     See the License for the specific language governing permissions and
1616     limitations under the License.
1617 */
1618 contract IDollar is IERC20 {
1619     function burn(uint256 amount) public;
1620     function burnFrom(address account, uint256 amount) public;
1621     function mint(address account, uint256 amount) public returns (bool);
1622 }
1623 
1624 /*
1625     Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>
1626 
1627     Licensed under the Apache License, Version 2.0 (the "License");
1628     you may not use this file except in compliance with the License.
1629     You may obtain a copy of the License at
1630 
1631     http://www.apache.org/licenses/LICENSE-2.0
1632 
1633     Unless required by applicable law or agreed to in writing, software
1634     distributed under the License is distributed on an "AS IS" BASIS,
1635     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1636     See the License for the specific language governing permissions and
1637     limitations under the License.
1638 */
1639 contract Dollar is IDollar, MinterRole, ERC20Detailed, Permittable, ERC20Burnable {
1640 
1641     constructor()
1642     ERC20Detailed("PENNY PROTOCOL", "PEN", 18)
1643     Permittable()
1644     public
1645     { }
1646 
1647     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1648         _mint(account, amount);
1649         return true;
1650     }
1651 
1652     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1653         _transfer(sender, recipient, amount);
1654         if (allowance(sender, _msgSender()) != uint256(-1)) {
1655             _approve(
1656                 sender,
1657                 _msgSender(),
1658                 allowance(sender, _msgSender()).sub(amount, "Dollar: transfer amount exceeds allowance"));
1659         }
1660         return true;
1661     }
1662 }