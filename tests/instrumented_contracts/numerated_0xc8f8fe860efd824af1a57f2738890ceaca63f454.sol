1 pragma solidity ^0.5.17;
2 pragma experimental ABIEncoderV2;
3 
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
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
33  * the optional functions; to access them see {ERC20Detailed}.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      * - Subtraction cannot overflow.
157      *
158      * _Available since v2.4.0._
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      *
216      * _Available since v2.4.0._
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         // Solidity only automatically asserts when dividing by 0
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      * - The divisor cannot be zero.
252      *
253      * _Available since v2.4.0._
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 /**
262  * @dev Implementation of the {IERC20} interface.
263  *
264  * This implementation is agnostic to the way tokens are created. This means
265  * that a supply mechanism has to be added in a derived contract using {_mint}.
266  * For a generic mechanism see {ERC20Mintable}.
267  *
268  * TIP: For a detailed writeup see our guide
269  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
270  * to implement supply mechanisms].
271  *
272  * We have followed general OpenZeppelin guidelines: functions revert instead
273  * of returning `false` on failure. This behavior is nonetheless conventional
274  * and does not conflict with the expectations of ERC20 applications.
275  *
276  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
277  * This allows applications to reconstruct the allowance for all accounts just
278  * by listening to said events. Other implementations of the EIP may not emit
279  * these events, as it isn't required by the specification.
280  *
281  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
282  * functions have been added to mitigate the well-known issues around setting
283  * allowances. See {IERC20-approve}.
284  */
285 contract ERC20 is Context, IERC20 {
286     using SafeMath for uint256;
287 
288     mapping (address => uint256) private _balances;
289 
290     mapping (address => mapping (address => uint256)) private _allowances;
291 
292     uint256 private _totalSupply;
293 
294     /**
295      * @dev See {IERC20-totalSupply}.
296      */
297     function totalSupply() public view returns (uint256) {
298         return _totalSupply;
299     }
300 
301     /**
302      * @dev See {IERC20-balanceOf}.
303      */
304     function balanceOf(address account) public view returns (uint256) {
305         return _balances[account];
306     }
307 
308     /**
309      * @dev See {IERC20-transfer}.
310      *
311      * Requirements:
312      *
313      * - `recipient` cannot be the zero address.
314      * - the caller must have a balance of at least `amount`.
315      */
316     function transfer(address recipient, uint256 amount) public returns (bool) {
317         _transfer(_msgSender(), recipient, amount);
318         return true;
319     }
320 
321     /**
322      * @dev See {IERC20-allowance}.
323      */
324     function allowance(address owner, address spender) public view returns (uint256) {
325         return _allowances[owner][spender];
326     }
327 
328     /**
329      * @dev See {IERC20-approve}.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      */
335     function approve(address spender, uint256 amount) public returns (bool) {
336         _approve(_msgSender(), spender, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-transferFrom}.
342      *
343      * Emits an {Approval} event indicating the updated allowance. This is not
344      * required by the EIP. See the note at the beginning of {ERC20};
345      *
346      * Requirements:
347      * - `sender` and `recipient` cannot be the zero address.
348      * - `sender` must have a balance of at least `amount`.
349      * - the caller must have allowance for `sender`'s tokens of at least
350      * `amount`.
351      */
352     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
353         _transfer(sender, recipient, amount);
354         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
355         return true;
356     }
357 
358     /**
359      * @dev Atomically increases the allowance granted to `spender` by the caller.
360      *
361      * This is an alternative to {approve} that can be used as a mitigation for
362      * problems described in {IERC20-approve}.
363      *
364      * Emits an {Approval} event indicating the updated allowance.
365      *
366      * Requirements:
367      *
368      * - `spender` cannot be the zero address.
369      */
370     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
371         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
372         return true;
373     }
374 
375     /**
376      * @dev Atomically decreases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      * - `spender` must have allowance for the caller of at least
387      * `subtractedValue`.
388      */
389     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
390         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
391         return true;
392     }
393 
394     /**
395      * @dev Moves tokens `amount` from `sender` to `recipient`.
396      *
397      * This is internal function is equivalent to {transfer}, and can be used to
398      * e.g. implement automatic token fees, slashing mechanisms, etc.
399      *
400      * Emits a {Transfer} event.
401      *
402      * Requirements:
403      *
404      * - `sender` cannot be the zero address.
405      * - `recipient` cannot be the zero address.
406      * - `sender` must have a balance of at least `amount`.
407      */
408     function _transfer(address sender, address recipient, uint256 amount) internal {
409         require(sender != address(0), "ERC20: transfer from the zero address");
410         require(recipient != address(0), "ERC20: transfer to the zero address");
411 
412         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
413         _balances[recipient] = _balances[recipient].add(amount);
414         emit Transfer(sender, recipient, amount);
415     }
416 
417     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
418      * the total supply.
419      *
420      * Emits a {Transfer} event with `from` set to the zero address.
421      *
422      * Requirements
423      *
424      * - `to` cannot be the zero address.
425      */
426     function _mint(address account, uint256 amount) internal {
427         require(account != address(0), "ERC20: mint to the zero address");
428 
429         _totalSupply = _totalSupply.add(amount);
430         _balances[account] = _balances[account].add(amount);
431         emit Transfer(address(0), account, amount);
432     }
433 
434     /**
435      * @dev Destroys `amount` tokens from `account`, reducing the
436      * total supply.
437      *
438      * Emits a {Transfer} event with `to` set to the zero address.
439      *
440      * Requirements
441      *
442      * - `account` cannot be the zero address.
443      * - `account` must have at least `amount` tokens.
444      */
445     function _burn(address account, uint256 amount) internal {
446         require(account != address(0), "ERC20: burn from the zero address");
447 
448         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
449         _totalSupply = _totalSupply.sub(amount);
450         emit Transfer(account, address(0), amount);
451     }
452 
453     /**
454      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
455      *
456      * This is internal function is equivalent to `approve`, and can be used to
457      * e.g. set automatic allowances for certain subsystems, etc.
458      *
459      * Emits an {Approval} event.
460      *
461      * Requirements:
462      *
463      * - `owner` cannot be the zero address.
464      * - `spender` cannot be the zero address.
465      */
466     function _approve(address owner, address spender, uint256 amount) internal {
467         require(owner != address(0), "ERC20: approve from the zero address");
468         require(spender != address(0), "ERC20: approve to the zero address");
469 
470         _allowances[owner][spender] = amount;
471         emit Approval(owner, spender, amount);
472     }
473 
474     /**
475      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
476      * from the caller's allowance.
477      *
478      * See {_burn} and {_approve}.
479      */
480     function _burnFrom(address account, uint256 amount) internal {
481         _burn(account, amount);
482         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
483     }
484 }
485 
486 /**
487  * @dev Extension of {ERC20} that allows token holders to destroy both their own
488  * tokens and those that they have an allowance for, in a way that can be
489  * recognized off-chain (via event analysis).
490  */
491 contract ERC20Burnable is Context, ERC20 {
492     /**
493      * @dev Destroys `amount` tokens from the caller.
494      *
495      * See {ERC20-_burn}.
496      */
497     function burn(uint256 amount) public {
498         _burn(_msgSender(), amount);
499     }
500 
501     /**
502      * @dev See {ERC20-_burnFrom}.
503      */
504     function burnFrom(address account, uint256 amount) public {
505         _burnFrom(account, amount);
506     }
507 }
508 
509 /**
510  * @dev Optional functions from the ERC20 standard.
511  */
512 contract ERC20Detailed is IERC20 {
513     string private _name;
514     string private _symbol;
515     uint8 private _decimals;
516 
517     /**
518      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
519      * these values are immutable: they can only be set once during
520      * construction.
521      */
522     constructor (string memory name, string memory symbol, uint8 decimals) public {
523         _name = name;
524         _symbol = symbol;
525         _decimals = decimals;
526     }
527 
528     /**
529      * @dev Returns the name of the token.
530      */
531     function name() public view returns (string memory) {
532         return _name;
533     }
534 
535     /**
536      * @dev Returns the symbol of the token, usually a shorter version of the
537      * name.
538      */
539     function symbol() public view returns (string memory) {
540         return _symbol;
541     }
542 
543     /**
544      * @dev Returns the number of decimals used to get its user representation.
545      * For example, if `decimals` equals `2`, a balance of `505` tokens should
546      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
547      *
548      * Tokens usually opt for a value of 18, imitating the relationship between
549      * Ether and Wei.
550      *
551      * NOTE: This information is only used for _display_ purposes: it in
552      * no way affects any of the arithmetic of the contract, including
553      * {IERC20-balanceOf} and {IERC20-transfer}.
554      */
555     function decimals() public view returns (uint8) {
556         return _decimals;
557     }
558 }
559 
560 /**
561  * @title Roles
562  * @dev Library for managing addresses assigned to a Role.
563  */
564 library Roles {
565     struct Role {
566         mapping (address => bool) bearer;
567     }
568 
569     /**
570      * @dev Give an account access to this role.
571      */
572     function add(Role storage role, address account) internal {
573         require(!has(role, account), "Roles: account already has role");
574         role.bearer[account] = true;
575     }
576 
577     /**
578      * @dev Remove an account's access to this role.
579      */
580     function remove(Role storage role, address account) internal {
581         require(has(role, account), "Roles: account does not have role");
582         role.bearer[account] = false;
583     }
584 
585     /**
586      * @dev Check if an account has this role.
587      * @return bool
588      */
589     function has(Role storage role, address account) internal view returns (bool) {
590         require(account != address(0), "Roles: account is the zero address");
591         return role.bearer[account];
592     }
593 }
594 
595 contract MinterRole is Context {
596     using Roles for Roles.Role;
597 
598     event MinterAdded(address indexed account);
599     event MinterRemoved(address indexed account);
600 
601     Roles.Role private _minters;
602 
603     constructor () internal {
604         _addMinter(_msgSender());
605     }
606 
607     modifier onlyMinter() {
608         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
609         _;
610     }
611 
612     function isMinter(address account) public view returns (bool) {
613         return _minters.has(account);
614     }
615 
616     function addMinter(address account) public onlyMinter {
617         _addMinter(account);
618     }
619 
620     function renounceMinter() public {
621         _removeMinter(_msgSender());
622     }
623 
624     function _addMinter(address account) internal {
625         _minters.add(account);
626         emit MinterAdded(account);
627     }
628 
629     function _removeMinter(address account) internal {
630         _minters.remove(account);
631         emit MinterRemoved(account);
632     }
633 }
634 
635 /*
636     Copyright 2019 dYdX Trading Inc.
637 
638     Licensed under the Apache License, Version 2.0 (the "License");
639     you may not use this file except in compliance with the License.
640     You may obtain a copy of the License at
641 
642     http://www.apache.org/licenses/LICENSE-2.0
643 
644     Unless required by applicable law or agreed to in writing, software
645     distributed under the License is distributed on an "AS IS" BASIS,
646     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
647     See the License for the specific language governing permissions and
648     limitations under the License.
649 */
650 /**
651  * @title Require
652  * @author dYdX
653  *
654  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
655  */
656 library Require {
657 
658     // ============ Constants ============
659 
660     uint256 constant ASCII_ZERO = 48; // '0'
661     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
662     uint256 constant ASCII_LOWER_EX = 120; // 'x'
663     bytes2 constant COLON = 0x3a20; // ': '
664     bytes2 constant COMMA = 0x2c20; // ', '
665     bytes2 constant LPAREN = 0x203c; // ' <'
666     byte constant RPAREN = 0x3e; // '>'
667     uint256 constant FOUR_BIT_MASK = 0xf;
668 
669     // ============ Library Functions ============
670 
671     function that(
672         bool must,
673         bytes32 file,
674         bytes32 reason
675     )
676     internal
677     pure
678     {
679         if (!must) {
680             revert(
681                 string(
682                     abi.encodePacked(
683                         stringifyTruncated(file),
684                         COLON,
685                         stringifyTruncated(reason)
686                     )
687                 )
688             );
689         }
690     }
691 
692     function that(
693         bool must,
694         bytes32 file,
695         bytes32 reason,
696         uint256 payloadA
697     )
698     internal
699     pure
700     {
701         if (!must) {
702             revert(
703                 string(
704                     abi.encodePacked(
705                         stringifyTruncated(file),
706                         COLON,
707                         stringifyTruncated(reason),
708                         LPAREN,
709                         stringify(payloadA),
710                         RPAREN
711                     )
712                 )
713             );
714         }
715     }
716 
717     function that(
718         bool must,
719         bytes32 file,
720         bytes32 reason,
721         uint256 payloadA,
722         uint256 payloadB
723     )
724     internal
725     pure
726     {
727         if (!must) {
728             revert(
729                 string(
730                     abi.encodePacked(
731                         stringifyTruncated(file),
732                         COLON,
733                         stringifyTruncated(reason),
734                         LPAREN,
735                         stringify(payloadA),
736                         COMMA,
737                         stringify(payloadB),
738                         RPAREN
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
749         address payloadA
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
774         address payloadA,
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
802         address payloadA,
803         uint256 payloadB,
804         uint256 payloadC
805     )
806     internal
807     pure
808     {
809         if (!must) {
810             revert(
811                 string(
812                     abi.encodePacked(
813                         stringifyTruncated(file),
814                         COLON,
815                         stringifyTruncated(reason),
816                         LPAREN,
817                         stringify(payloadA),
818                         COMMA,
819                         stringify(payloadB),
820                         COMMA,
821                         stringify(payloadC),
822                         RPAREN
823                     )
824                 )
825             );
826         }
827     }
828 
829     function that(
830         bool must,
831         bytes32 file,
832         bytes32 reason,
833         bytes32 payloadA
834     )
835     internal
836     pure
837     {
838         if (!must) {
839             revert(
840                 string(
841                     abi.encodePacked(
842                         stringifyTruncated(file),
843                         COLON,
844                         stringifyTruncated(reason),
845                         LPAREN,
846                         stringify(payloadA),
847                         RPAREN
848                     )
849                 )
850             );
851         }
852     }
853 
854     function that(
855         bool must,
856         bytes32 file,
857         bytes32 reason,
858         bytes32 payloadA,
859         uint256 payloadB,
860         uint256 payloadC
861     )
862     internal
863     pure
864     {
865         if (!must) {
866             revert(
867                 string(
868                     abi.encodePacked(
869                         stringifyTruncated(file),
870                         COLON,
871                         stringifyTruncated(reason),
872                         LPAREN,
873                         stringify(payloadA),
874                         COMMA,
875                         stringify(payloadB),
876                         COMMA,
877                         stringify(payloadC),
878                         RPAREN
879                     )
880                 )
881             );
882         }
883     }
884 
885     // ============ Private Functions ============
886 
887     function stringifyTruncated(
888         bytes32 input
889     )
890     private
891     pure
892     returns (bytes memory)
893     {
894         // put the input bytes into the result
895         bytes memory result = abi.encodePacked(input);
896 
897         // determine the length of the input by finding the location of the last non-zero byte
898         for (uint256 i = 32; i > 0; ) {
899             // reverse-for-loops with unsigned integer
900             /* solium-disable-next-line security/no-modify-for-iter-var */
901             i--;
902 
903             // find the last non-zero byte in order to determine the length
904             if (result[i] != 0) {
905                 uint256 length = i + 1;
906 
907                 /* solium-disable-next-line security/no-inline-assembly */
908                 assembly {
909                     mstore(result, length) // r.length = length;
910                 }
911 
912                 return result;
913             }
914         }
915 
916         // all bytes are zero
917         return new bytes(0);
918     }
919 
920     function stringify(
921         uint256 input
922     )
923     private
924     pure
925     returns (bytes memory)
926     {
927         if (input == 0) {
928             return "0";
929         }
930 
931         // get the final string length
932         uint256 j = input;
933         uint256 length;
934         while (j != 0) {
935             length++;
936             j /= 10;
937         }
938 
939         // allocate the string
940         bytes memory bstr = new bytes(length);
941 
942         // populate the string starting with the least-significant character
943         j = input;
944         for (uint256 i = length; i > 0; ) {
945             // reverse-for-loops with unsigned integer
946             /* solium-disable-next-line security/no-modify-for-iter-var */
947             i--;
948 
949             // take last decimal digit
950             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
951 
952             // remove the last decimal digit
953             j /= 10;
954         }
955 
956         return bstr;
957     }
958 
959     function stringify(
960         address input
961     )
962     private
963     pure
964     returns (bytes memory)
965     {
966         uint256 z = uint256(input);
967 
968         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
969         bytes memory result = new bytes(42);
970 
971         // populate the result with "0x"
972         result[0] = byte(uint8(ASCII_ZERO));
973         result[1] = byte(uint8(ASCII_LOWER_EX));
974 
975         // for each byte (starting from the lowest byte), populate the result with two characters
976         for (uint256 i = 0; i < 20; i++) {
977             // each byte takes two characters
978             uint256 shift = i * 2;
979 
980             // populate the least-significant character
981             result[41 - shift] = char(z & FOUR_BIT_MASK);
982             z = z >> 4;
983 
984             // populate the most-significant character
985             result[40 - shift] = char(z & FOUR_BIT_MASK);
986             z = z >> 4;
987         }
988 
989         return result;
990     }
991 
992     function stringify(
993         bytes32 input
994     )
995     private
996     pure
997     returns (bytes memory)
998     {
999         uint256 z = uint256(input);
1000 
1001         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
1002         bytes memory result = new bytes(66);
1003 
1004         // populate the result with "0x"
1005         result[0] = byte(uint8(ASCII_ZERO));
1006         result[1] = byte(uint8(ASCII_LOWER_EX));
1007 
1008         // for each byte (starting from the lowest byte), populate the result with two characters
1009         for (uint256 i = 0; i < 32; i++) {
1010             // each byte takes two characters
1011             uint256 shift = i * 2;
1012 
1013             // populate the least-significant character
1014             result[65 - shift] = char(z & FOUR_BIT_MASK);
1015             z = z >> 4;
1016 
1017             // populate the most-significant character
1018             result[64 - shift] = char(z & FOUR_BIT_MASK);
1019             z = z >> 4;
1020         }
1021 
1022         return result;
1023     }
1024 
1025     function char(
1026         uint256 input
1027     )
1028     private
1029     pure
1030     returns (byte)
1031     {
1032         // return ASCII digit (0-9)
1033         if (input < 10) {
1034             return byte(uint8(input + ASCII_ZERO));
1035         }
1036 
1037         // return ASCII letter (a-f)
1038         return byte(uint8(input + ASCII_RELATIVE_ZERO));
1039     }
1040 }
1041 
1042 /*
1043     Copyright 2019 ZeroEx Intl.
1044 
1045     Licensed under the Apache License, Version 2.0 (the "License");
1046     you may not use this file except in compliance with the License.
1047     You may obtain a copy of the License at
1048 
1049     http://www.apache.org/licenses/LICENSE-2.0
1050 
1051     Unless required by applicable law or agreed to in writing, software
1052     distributed under the License is distributed on an "AS IS" BASIS,
1053     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1054     See the License for the specific language governing permissions and
1055     limitations under the License.
1056 */
1057 library LibEIP712 {
1058 
1059     // Hash of the EIP712 Domain Separator Schema
1060     // keccak256(abi.encodePacked(
1061     //     "EIP712Domain(",
1062     //     "string name,",
1063     //     "string version,",
1064     //     "uint256 chainId,",
1065     //     "address verifyingContract",
1066     //     ")"
1067     // ))
1068     bytes32 constant internal _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
1069 
1070     /// @dev Calculates a EIP712 domain separator.
1071     /// @param name The EIP712 domain name.
1072     /// @param version The EIP712 domain version.
1073     /// @param verifyingContract The EIP712 verifying contract.
1074     /// @return EIP712 domain separator.
1075     function hashEIP712Domain(
1076         string memory name,
1077         string memory version,
1078         uint256 chainId,
1079         address verifyingContract
1080     )
1081     internal
1082     pure
1083     returns (bytes32 result)
1084     {
1085         bytes32 schemaHash = _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH;
1086 
1087         // Assembly for more efficient computing:
1088         // keccak256(abi.encodePacked(
1089         //     _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
1090         //     keccak256(bytes(name)),
1091         //     keccak256(bytes(version)),
1092         //     chainId,
1093         //     uint256(verifyingContract)
1094         // ))
1095 
1096         assembly {
1097         // Calculate hashes of dynamic data
1098             let nameHash := keccak256(add(name, 32), mload(name))
1099             let versionHash := keccak256(add(version, 32), mload(version))
1100 
1101         // Load free memory pointer
1102             let memPtr := mload(64)
1103 
1104         // Store params in memory
1105             mstore(memPtr, schemaHash)
1106             mstore(add(memPtr, 32), nameHash)
1107             mstore(add(memPtr, 64), versionHash)
1108             mstore(add(memPtr, 96), chainId)
1109             mstore(add(memPtr, 128), verifyingContract)
1110 
1111         // Compute hash
1112             result := keccak256(memPtr, 160)
1113         }
1114         return result;
1115     }
1116 
1117     /// @dev Calculates EIP712 encoding for a hash struct with a given domain hash.
1118     /// @param eip712DomainHash Hash of the domain domain separator data, computed
1119     ///                         with getDomainHash().
1120     /// @param hashStruct The EIP712 hash struct.
1121     /// @return EIP712 hash applied to the given EIP712 Domain.
1122     function hashEIP712Message(bytes32 eip712DomainHash, bytes32 hashStruct)
1123     internal
1124     pure
1125     returns (bytes32 result)
1126     {
1127         // Assembly for more efficient computing:
1128         // keccak256(abi.encodePacked(
1129         //     EIP191_HEADER,
1130         //     EIP712_DOMAIN_HASH,
1131         //     hashStruct
1132         // ));
1133 
1134         assembly {
1135         // Load free memory pointer
1136             let memPtr := mload(64)
1137 
1138             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
1139             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
1140             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
1141 
1142         // Compute hash
1143             result := keccak256(memPtr, 66)
1144         }
1145         return result;
1146     }
1147 }
1148 
1149 /*
1150     Copyright 2019 dYdX Trading Inc.
1151     Copyright 2020 Apollo Dev, based on the works of the Empty Set Squad
1152 
1153     Licensed under the Apache License, Version 2.0 (the "License");
1154     you may not use this file except in compliance with the License.
1155     You may obtain a copy of the License at
1156 
1157     http://www.apache.org/licenses/LICENSE-2.0
1158 
1159     Unless required by applicable law or agreed to in writing, software
1160     distributed under the License is distributed on an "AS IS" BASIS,
1161     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1162     See the License for the specific language governing permissions and
1163     limitations under the License.
1164 */
1165 /**
1166  * @title Decimal
1167  * @author dYdX
1168  *
1169  * Library that defines a fixed-point number with 18 decimal places.
1170  */
1171 library Decimal {
1172     using SafeMath for uint256;
1173 
1174     // ============ Constants ============
1175 
1176     uint256 constant BASE = 10**18;
1177 
1178     // ============ Structs ============
1179 
1180 
1181     struct D256 {
1182         uint256 value;
1183     }
1184 
1185     // ============ Static Functions ============
1186 
1187     function zero()
1188     internal
1189     pure
1190     returns (D256 memory)
1191     {
1192         return D256({ value: 0 });
1193     }
1194 
1195     function one()
1196     internal
1197     pure
1198     returns (D256 memory)
1199     {
1200         return D256({ value: BASE });
1201     }
1202 
1203     function from(
1204         uint256 a
1205     )
1206     internal
1207     pure
1208     returns (D256 memory)
1209     {
1210         return D256({ value: a.mul(BASE) });
1211     }
1212 
1213     function ratio(
1214         uint256 a,
1215         uint256 b
1216     )
1217     internal
1218     pure
1219     returns (D256 memory)
1220     {
1221         return D256({ value: getPartial(a, BASE, b) });
1222     }
1223 
1224     // ============ Self Functions ============
1225 
1226     function add(
1227         D256 memory self,
1228         uint256 b
1229     )
1230     internal
1231     pure
1232     returns (D256 memory)
1233     {
1234         return D256({ value: self.value.add(b.mul(BASE)) });
1235     }
1236 
1237     function sub(
1238         D256 memory self,
1239         uint256 b
1240     )
1241     internal
1242     pure
1243     returns (D256 memory)
1244     {
1245         return D256({ value: self.value.sub(b.mul(BASE)) });
1246     }
1247 
1248     function sub(
1249         D256 memory self,
1250         uint256 b,
1251         string memory reason
1252     )
1253     internal
1254     pure
1255     returns (D256 memory)
1256     {
1257         return D256({ value: self.value.sub(b.mul(BASE), reason) });
1258     }
1259 
1260     function mul(
1261         D256 memory self,
1262         uint256 b
1263     )
1264     internal
1265     pure
1266     returns (D256 memory)
1267     {
1268         return D256({ value: self.value.mul(b) });
1269     }
1270 
1271     function div(
1272         D256 memory self,
1273         uint256 b
1274     )
1275     internal
1276     pure
1277     returns (D256 memory)
1278     {
1279         return D256({ value: self.value.div(b) });
1280     }
1281 
1282     function pow(
1283         D256 memory self,
1284         uint256 b
1285     )
1286     internal
1287     pure
1288     returns (D256 memory)
1289     {
1290         if (b == 0) {
1291             return from(1);
1292         }
1293 
1294         D256 memory temp = D256({ value: self.value });
1295         for (uint256 i = 1; i < b; i++) {
1296             temp = mul(temp, self);
1297         }
1298 
1299         return temp;
1300     }
1301 
1302     function add(
1303         D256 memory self,
1304         D256 memory b
1305     )
1306     internal
1307     pure
1308     returns (D256 memory)
1309     {
1310         return D256({ value: self.value.add(b.value) });
1311     }
1312 
1313     function sub(
1314         D256 memory self,
1315         D256 memory b
1316     )
1317     internal
1318     pure
1319     returns (D256 memory)
1320     {
1321         return D256({ value: self.value.sub(b.value) });
1322     }
1323 
1324     function sub(
1325         D256 memory self,
1326         D256 memory b,
1327         string memory reason
1328     )
1329     internal
1330     pure
1331     returns (D256 memory)
1332     {
1333         return D256({ value: self.value.sub(b.value, reason) });
1334     }
1335 
1336     function mul(
1337         D256 memory self,
1338         D256 memory b
1339     )
1340     internal
1341     pure
1342     returns (D256 memory)
1343     {
1344         return D256({ value: getPartial(self.value, b.value, BASE) });
1345     }
1346 
1347     function div(
1348         D256 memory self,
1349         D256 memory b
1350     )
1351     internal
1352     pure
1353     returns (D256 memory)
1354     {
1355         return D256({ value: getPartial(self.value, BASE, b.value) });
1356     }
1357 
1358     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
1359         return self.value == b.value;
1360     }
1361 
1362     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1363         return compareTo(self, b) == 2;
1364     }
1365 
1366     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1367         return compareTo(self, b) == 0;
1368     }
1369 
1370     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1371         return compareTo(self, b) > 0;
1372     }
1373 
1374     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1375         return compareTo(self, b) < 2;
1376     }
1377 
1378     function isZero(D256 memory self) internal pure returns (bool) {
1379         return self.value == 0;
1380     }
1381 
1382     function asUint256(D256 memory self) internal pure returns (uint256) {
1383         return self.value.div(BASE);
1384     }
1385 
1386     // ============ Core Methods ============
1387 
1388     function getPartial(
1389         uint256 target,
1390         uint256 numerator,
1391         uint256 denominator
1392     )
1393     private
1394     pure
1395     returns (uint256)
1396     {
1397         return target.mul(numerator).div(denominator);
1398     }
1399 
1400     function compareTo(
1401         D256 memory a,
1402         D256 memory b
1403     )
1404     private
1405     pure
1406     returns (uint256)
1407     {
1408         if (a.value == b.value) {
1409             return 1;
1410         }
1411         return a.value > b.value ? 2 : 0;
1412     }
1413 }
1414 
1415 /*
1416     Copyright 2020 Apollo Dev, based on the works of the Empty Set Squad
1417 
1418     Licensed under the Apache License, Version 2.0 (the "License");
1419     you may not use this file except in compliance with the License.
1420     You may obtain a copy of the License at
1421 
1422     http://www.apache.org/licenses/LICENSE-2.0
1423 
1424     Unless required by applicable law or agreed to in writing, software
1425     distributed under the License is distributed on an "AS IS" BASIS,
1426     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1427     See the License for the specific language governing permissions and
1428     limitations under the License.
1429 */
1430 library Constants {
1431     /* Chain */
1432     uint256 private constant CHAIN_ID = 1; // Mainnet
1433 
1434     /* Oracle */
1435     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
1436     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 USDC
1437 
1438     /* Price Peg */
1439     address private constant PEG_REGULATOR = 0xCEe3101c0A8167f083F34B95A2f243c9b0BEF6a6;
1440 
1441     /* Bonding */
1442     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 AOX -> 100M Phantom
1443 
1444     /* Epoch */
1445     struct EpochStrategy {
1446         uint256 offset;
1447         uint256 start;
1448         uint256 period;
1449     }
1450 
1451     uint256 private constant EPOCH_OFFSET = 0;
1452     uint256 private constant EPOCH_START = 1613921400;
1453     uint256 private constant EPOCH_PERIOD = 1800;
1454 
1455     /* Governance */
1456     uint256 private constant GOVERNANCE_PERIOD = 672;
1457     uint256 private constant GOVERNANCE_QUORUM = 15e16; // 15%
1458     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 10e15; // 1.0%
1459     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
1460     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 48; // 6 epochs
1461 
1462     /* DAO */
1463     uint256 private constant ADVANCE_INCENTIVE = 100e18; // 100 AOX
1464     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 288; // 288 epochs fluid
1465 
1466     /* Pool */
1467     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 144; // 144 epochs fluid
1468     uint256 private constant POOL_STAKING_FEE = 10; //10% staking fee
1469 
1470     /* Locker */
1471     uint256 private constant LOCKER_BOND_LOCKUP_EPOCHS = 192; // 192 epochs fluid
1472 
1473     /* Staker */
1474     uint256 private constant SHARE_SUPPLY_PER_EPOCH = 4000e18; //4000 per epoch
1475     uint256 private constant STAKER_EXIT_LOCKUP_EPOCHS = 288; //288 epochs fluid
1476     address private constant STAKING_REGULATOR = 0xCEe3101c0A8167f083F34B95A2f243c9b0BEF6a6;
1477     uint256 private constant STAKER_STAKING_FEE = 10; //10% staking fee
1478 
1479     /* Market */
1480     uint256 private constant COUPON_EXPIRATION = 672; //672 epochs fluid
1481     uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%
1482     uint256 private constant INITIAL_COUPON_REDEMPTION_PENALTY = 50e16; // 50%
1483     uint256 private constant COUPON_REDEMPTION_PENALTY_DECAY = 900; // 15 mins
1484 
1485     /* Regulator */
1486     uint256 private constant SUPPLY_CHANGE_LIMIT = 7e16; // 7%
1487     uint256 private constant DAO_RATIO = 15; //15%
1488     uint256 private constant ORACLE_POOL_RATIO = 60; // 60%
1489     uint256 private constant TREASURY_RATIO = 10; // 10%
1490 
1491     /* Treasury */
1492     address private constant TREASURY_ADDRESS = 0x79a4Df20B4CE64Cdeb38f4Ed6f74f4F87906082e;
1493 
1494     /**
1495      * Getters
1496      */
1497     function getUsdcAddress() internal pure returns (address) {
1498         return USDC;
1499     }
1500 
1501     function getOracleReserveMinimum() internal pure returns (uint256) {
1502         return ORACLE_RESERVE_MINIMUM;
1503     }
1504 
1505     function getEpochStrategy() internal pure returns (EpochStrategy memory) {
1506         return EpochStrategy({
1507             offset: EPOCH_OFFSET,
1508             start: EPOCH_START,
1509             period: EPOCH_PERIOD
1510         });
1511     }
1512 
1513     function getInitialStakeMultiple() internal pure returns (uint256) {
1514         return INITIAL_STAKE_MULTIPLE;
1515     }
1516 
1517     function getGovernancePeriod() internal pure returns (uint256) {
1518         return GOVERNANCE_PERIOD;
1519     }
1520 
1521     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1522         return Decimal.D256({value: GOVERNANCE_QUORUM});
1523     }
1524 
1525     function getGovernanceProposalThreshold() internal pure returns (Decimal.D256 memory) {
1526         return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
1527     }
1528 
1529     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1530         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1531     }
1532 
1533     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1534         return GOVERNANCE_EMERGENCY_DELAY;
1535     }
1536 
1537     function getAdvanceIncentive() internal pure returns (uint256) {
1538         return ADVANCE_INCENTIVE;
1539     }
1540 
1541     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1542         return DAO_EXIT_LOCKUP_EPOCHS;
1543     }
1544 
1545     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1546         return POOL_EXIT_LOCKUP_EPOCHS;
1547     }
1548 
1549     function getPoolStakingFee() internal pure returns (uint256) {
1550         return POOL_STAKING_FEE;
1551     }
1552 
1553     function getLockerBondLockupEpochs() internal pure returns (uint256) {
1554         return LOCKER_BOND_LOCKUP_EPOCHS;
1555     }
1556 
1557     function getShareSupplyPerEpoch() internal pure returns (uint256) {
1558         return SHARE_SUPPLY_PER_EPOCH;
1559     }
1560 
1561     function getStakerExitLockupEpochs() internal pure returns (uint256) {
1562         return STAKER_EXIT_LOCKUP_EPOCHS;
1563     }
1564 
1565     function getStakingRegulator() internal pure returns (address) {
1566         return STAKING_REGULATOR;
1567     }
1568 
1569     function getStakerStakingFee() internal pure returns (uint256) {
1570         return STAKER_STAKING_FEE;
1571     }
1572 
1573     function getCouponExpiration() internal pure returns (uint256) {
1574         return COUPON_EXPIRATION;
1575     }
1576 
1577     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1578         return Decimal.D256({value: DEBT_RATIO_CAP});
1579     }
1580     
1581     function getInitialCouponRedemptionPenalty() internal pure returns (Decimal.D256 memory) {
1582         return Decimal.D256({value: INITIAL_COUPON_REDEMPTION_PENALTY});
1583     }
1584 
1585     function getCouponRedemptionPenaltyDecay() internal pure returns (uint256) {
1586         return COUPON_REDEMPTION_PENALTY_DECAY;
1587     }
1588 
1589     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1590         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1591     }
1592 
1593     function getDAORatio() internal pure returns (uint256) {
1594         return DAO_RATIO;
1595     }
1596 
1597     function getOraclePoolRatio() internal pure returns (uint256) {
1598         return ORACLE_POOL_RATIO;
1599     }
1600 
1601     function getTreasuryRatio() internal pure returns (uint256) {
1602         return TREASURY_RATIO;
1603     }
1604 
1605     function getPegRegulator() internal pure returns (address) {
1606         return PEG_REGULATOR;
1607     }
1608 
1609     function getTreasuryAddress() internal pure returns (address) {
1610         return TREASURY_ADDRESS;
1611     }
1612 
1613     function getChainId() internal pure returns (uint256) {
1614         return CHAIN_ID;
1615     }
1616 }
1617 
1618 /*
1619     Copyright 2020 Apollo Dev, based on the works of the Empty Set Squad
1620 
1621     Licensed under the Apache License, Version 2.0 (the "License");
1622     you may not use this file except in compliance with the License.
1623     You may obtain a copy of the License at
1624 
1625     http://www.apache.org/licenses/LICENSE-2.0
1626 
1627     Unless required by applicable law or agreed to in writing, software
1628     distributed under the License is distributed on an "AS IS" BASIS,
1629     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1630     See the License for the specific language governing permissions and
1631     limitations under the License.
1632 */
1633 contract Permittable is ERC20Detailed, ERC20 {
1634     bytes32 constant FILE = "Permittable";
1635 
1636     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1637     bytes32 public constant EIP712_PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1638     string private constant EIP712_VERSION = "1";
1639 
1640     bytes32 public EIP712_DOMAIN_SEPARATOR;
1641 
1642     mapping(address => uint256) nonces;
1643 
1644     constructor() public {
1645         EIP712_DOMAIN_SEPARATOR = LibEIP712.hashEIP712Domain(name(), EIP712_VERSION, Constants.getChainId(), address(this));
1646     }
1647 
1648     function permit(
1649         address owner,
1650         address spender,
1651         uint256 value,
1652         uint256 deadline,
1653         uint8 v,
1654         bytes32 r,
1655         bytes32 s
1656     ) external {
1657         bytes32 digest = LibEIP712.hashEIP712Message(
1658             EIP712_DOMAIN_SEPARATOR,
1659             keccak256(abi.encode(
1660                 EIP712_PERMIT_TYPEHASH,
1661                 owner,
1662                 spender,
1663                 value,
1664                 nonces[owner]++,
1665                 deadline
1666             ))
1667         );
1668 
1669         address recovered = ecrecover(digest, v, r, s);
1670         Require.that(
1671             recovered == owner,
1672             FILE,
1673             "Invalid signature"
1674         );
1675 
1676         Require.that(
1677             recovered != address(0),
1678             FILE,
1679             "Zero address"
1680         );
1681 
1682         Require.that(
1683             now <= deadline,
1684             FILE,
1685             "Expired"
1686         );
1687 
1688         _approve(owner, spender, value);
1689     }
1690 }
1691 
1692 /*
1693     Copyright 2020 Apollo Dev, based on the works of the Empty Set Squad
1694 
1695     Licensed under the Apache License, Version 2.0 (the "License");
1696     you may not use this file except in compliance with the License.
1697     You may obtain a copy of the License at
1698 
1699     http://www.apache.org/licenses/LICENSE-2.0
1700 
1701     Unless required by applicable law or agreed to in writing, software
1702     distributed under the License is distributed on an "AS IS" BASIS,
1703     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1704     See the License for the specific language governing permissions and
1705     limitations under the License.
1706 */
1707 contract IShare is IERC20 {
1708     function burn(uint256 amount) public;
1709     function burnFrom(address account, uint256 amount) public;
1710     function mint(address account, uint256 amount) public returns (bool);
1711 }
1712 
1713 /*
1714     Copyright 2020 Apollo Dev, based on the works of the Empty Set Squad
1715 
1716     Licensed under the Apache License, Version 2.0 (the "License");
1717     you may not use this file except in compliance with the License.
1718     You may obtain a copy of the License at
1719 
1720     http://www.apache.org/licenses/LICENSE-2.0
1721 
1722     Unless required by applicable law or agreed to in writing, software
1723     distributed under the License is distributed on an "AS IS" BASIS,
1724     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1725     See the License for the specific language governing permissions and
1726     limitations under the License.
1727 */
1728 contract Share is IShare, MinterRole, ERC20Detailed, Permittable, ERC20Burnable {
1729 
1730     constructor()
1731     ERC20Detailed("Apollo Share", "AOZ", 18)
1732     Permittable()
1733     public
1734     { }
1735 
1736     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1737         _mint(account, amount);
1738         return true;
1739     }
1740 
1741     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1742         _transfer(sender, recipient, amount);
1743         if (allowance(sender, _msgSender()) != uint256(-1)) {
1744             _approve(
1745                 sender,
1746                 _msgSender(),
1747                 allowance(sender, _msgSender()).sub(amount, "Share: transfer amount exceeds allowance"));
1748         }
1749         return true;
1750     }
1751 }