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
635 /**
636  * @title Require
637  * @author dYdX
638  *
639  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
640  */
641 library Require {
642 
643     // ============ Constants ============
644 
645     uint256 constant ASCII_ZERO = 48; // '0'
646     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
647     uint256 constant ASCII_LOWER_EX = 120; // 'x'
648     bytes2 constant COLON = 0x3a20; // ': '
649     bytes2 constant COMMA = 0x2c20; // ', '
650     bytes2 constant LPAREN = 0x203c; // ' <'
651     byte constant RPAREN = 0x3e; // '>'
652     uint256 constant FOUR_BIT_MASK = 0xf;
653 
654     // ============ Library Functions ============
655 
656     function that(
657         bool must,
658         bytes32 file,
659         bytes32 reason
660     )
661     internal
662     pure
663     {
664         if (!must) {
665             revert(
666                 string(
667                     abi.encodePacked(
668                         stringifyTruncated(file),
669                         COLON,
670                         stringifyTruncated(reason)
671                     )
672                 )
673             );
674         }
675     }
676 
677     function that(
678         bool must,
679         bytes32 file,
680         bytes32 reason,
681         uint256 payloadA
682     )
683     internal
684     pure
685     {
686         if (!must) {
687             revert(
688                 string(
689                     abi.encodePacked(
690                         stringifyTruncated(file),
691                         COLON,
692                         stringifyTruncated(reason),
693                         LPAREN,
694                         stringify(payloadA),
695                         RPAREN
696                     )
697                 )
698             );
699         }
700     }
701 
702     function that(
703         bool must,
704         bytes32 file,
705         bytes32 reason,
706         uint256 payloadA,
707         uint256 payloadB
708     )
709     internal
710     pure
711     {
712         if (!must) {
713             revert(
714                 string(
715                     abi.encodePacked(
716                         stringifyTruncated(file),
717                         COLON,
718                         stringifyTruncated(reason),
719                         LPAREN,
720                         stringify(payloadA),
721                         COMMA,
722                         stringify(payloadB),
723                         RPAREN
724                     )
725                 )
726             );
727         }
728     }
729 
730     function that(
731         bool must,
732         bytes32 file,
733         bytes32 reason,
734         address payloadA
735     )
736     internal
737     pure
738     {
739         if (!must) {
740             revert(
741                 string(
742                     abi.encodePacked(
743                         stringifyTruncated(file),
744                         COLON,
745                         stringifyTruncated(reason),
746                         LPAREN,
747                         stringify(payloadA),
748                         RPAREN
749                     )
750                 )
751             );
752         }
753     }
754 
755     function that(
756         bool must,
757         bytes32 file,
758         bytes32 reason,
759         address payloadA,
760         uint256 payloadB
761     )
762     internal
763     pure
764     {
765         if (!must) {
766             revert(
767                 string(
768                     abi.encodePacked(
769                         stringifyTruncated(file),
770                         COLON,
771                         stringifyTruncated(reason),
772                         LPAREN,
773                         stringify(payloadA),
774                         COMMA,
775                         stringify(payloadB),
776                         RPAREN
777                     )
778                 )
779             );
780         }
781     }
782 
783     function that(
784         bool must,
785         bytes32 file,
786         bytes32 reason,
787         address payloadA,
788         uint256 payloadB,
789         uint256 payloadC
790     )
791     internal
792     pure
793     {
794         if (!must) {
795             revert(
796                 string(
797                     abi.encodePacked(
798                         stringifyTruncated(file),
799                         COLON,
800                         stringifyTruncated(reason),
801                         LPAREN,
802                         stringify(payloadA),
803                         COMMA,
804                         stringify(payloadB),
805                         COMMA,
806                         stringify(payloadC),
807                         RPAREN
808                     )
809                 )
810             );
811         }
812     }
813 
814     function that(
815         bool must,
816         bytes32 file,
817         bytes32 reason,
818         bytes32 payloadA
819     )
820     internal
821     pure
822     {
823         if (!must) {
824             revert(
825                 string(
826                     abi.encodePacked(
827                         stringifyTruncated(file),
828                         COLON,
829                         stringifyTruncated(reason),
830                         LPAREN,
831                         stringify(payloadA),
832                         RPAREN
833                     )
834                 )
835             );
836         }
837     }
838 
839     function that(
840         bool must,
841         bytes32 file,
842         bytes32 reason,
843         bytes32 payloadA,
844         uint256 payloadB,
845         uint256 payloadC
846     )
847     internal
848     pure
849     {
850         if (!must) {
851             revert(
852                 string(
853                     abi.encodePacked(
854                         stringifyTruncated(file),
855                         COLON,
856                         stringifyTruncated(reason),
857                         LPAREN,
858                         stringify(payloadA),
859                         COMMA,
860                         stringify(payloadB),
861                         COMMA,
862                         stringify(payloadC),
863                         RPAREN
864                     )
865                 )
866             );
867         }
868     }
869 
870     // ============ Private Functions ============
871 
872     function stringifyTruncated(
873         bytes32 input
874     )
875     private
876     pure
877     returns (bytes memory)
878     {
879         // put the input bytes into the result
880         bytes memory result = abi.encodePacked(input);
881 
882         // determine the length of the input by finding the location of the last non-zero byte
883         for (uint256 i = 32; i > 0; ) {
884             // reverse-for-loops with unsigned integer
885             /* solium-disable-next-line security/no-modify-for-iter-var */
886             i--;
887 
888             // find the last non-zero byte in order to determine the length
889             if (result[i] != 0) {
890                 uint256 length = i + 1;
891 
892                 /* solium-disable-next-line security/no-inline-assembly */
893                 assembly {
894                     mstore(result, length) // r.length = length;
895                 }
896 
897                 return result;
898             }
899         }
900 
901         // all bytes are zero
902         return new bytes(0);
903     }
904 
905     function stringify(
906         uint256 input
907     )
908     private
909     pure
910     returns (bytes memory)
911     {
912         if (input == 0) {
913             return "0";
914         }
915 
916         // get the final string length
917         uint256 j = input;
918         uint256 length;
919         while (j != 0) {
920             length++;
921             j /= 10;
922         }
923 
924         // allocate the string
925         bytes memory bstr = new bytes(length);
926 
927         // populate the string starting with the least-significant character
928         j = input;
929         for (uint256 i = length; i > 0; ) {
930             // reverse-for-loops with unsigned integer
931             /* solium-disable-next-line security/no-modify-for-iter-var */
932             i--;
933 
934             // take last decimal digit
935             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
936 
937             // remove the last decimal digit
938             j /= 10;
939         }
940 
941         return bstr;
942     }
943 
944     function stringify(
945         address input
946     )
947     private
948     pure
949     returns (bytes memory)
950     {
951         uint256 z = uint256(input);
952 
953         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
954         bytes memory result = new bytes(42);
955 
956         // populate the result with "0x"
957         result[0] = byte(uint8(ASCII_ZERO));
958         result[1] = byte(uint8(ASCII_LOWER_EX));
959 
960         // for each byte (starting from the lowest byte), populate the result with two characters
961         for (uint256 i = 0; i < 20; i++) {
962             // each byte takes two characters
963             uint256 shift = i * 2;
964 
965             // populate the least-significant character
966             result[41 - shift] = char(z & FOUR_BIT_MASK);
967             z = z >> 4;
968 
969             // populate the most-significant character
970             result[40 - shift] = char(z & FOUR_BIT_MASK);
971             z = z >> 4;
972         }
973 
974         return result;
975     }
976 
977     function stringify(
978         bytes32 input
979     )
980     private
981     pure
982     returns (bytes memory)
983     {
984         uint256 z = uint256(input);
985 
986         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
987         bytes memory result = new bytes(66);
988 
989         // populate the result with "0x"
990         result[0] = byte(uint8(ASCII_ZERO));
991         result[1] = byte(uint8(ASCII_LOWER_EX));
992 
993         // for each byte (starting from the lowest byte), populate the result with two characters
994         for (uint256 i = 0; i < 32; i++) {
995             // each byte takes two characters
996             uint256 shift = i * 2;
997 
998             // populate the least-significant character
999             result[65 - shift] = char(z & FOUR_BIT_MASK);
1000             z = z >> 4;
1001 
1002             // populate the most-significant character
1003             result[64 - shift] = char(z & FOUR_BIT_MASK);
1004             z = z >> 4;
1005         }
1006 
1007         return result;
1008     }
1009 
1010     function char(
1011         uint256 input
1012     )
1013     private
1014     pure
1015     returns (byte)
1016     {
1017         // return ASCII digit (0-9)
1018         if (input < 10) {
1019             return byte(uint8(input + ASCII_ZERO));
1020         }
1021 
1022         // return ASCII letter (a-f)
1023         return byte(uint8(input + ASCII_RELATIVE_ZERO));
1024     }
1025 }
1026 
1027 library LibEIP712 {
1028 
1029     // Hash of the EIP712 Domain Separator Schema
1030     // keccak256(abi.encodePacked(
1031     //     "EIP712Domain(",
1032     //     "string name,",
1033     //     "string version,",
1034     //     "uint256 chainId,",
1035     //     "address verifyingContract",
1036     //     ")"
1037     // ))
1038     bytes32 constant internal _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
1039 
1040     /// @dev Calculates a EIP712 domain separator.
1041     /// @param name The EIP712 domain name.
1042     /// @param version The EIP712 domain version.
1043     /// @param verifyingContract The EIP712 verifying contract.
1044     /// @return EIP712 domain separator.
1045     function hashEIP712Domain(
1046         string memory name,
1047         string memory version,
1048         uint256 chainId,
1049         address verifyingContract
1050     )
1051     internal
1052     pure
1053     returns (bytes32 result)
1054     {
1055         bytes32 schemaHash = _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH;
1056 
1057         // Assembly for more efficient computing:
1058         // keccak256(abi.encodePacked(
1059         //     _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
1060         //     keccak256(bytes(name)),
1061         //     keccak256(bytes(version)),
1062         //     chainId,
1063         //     uint256(verifyingContract)
1064         // ))
1065 
1066         assembly {
1067         // Calculate hashes of dynamic data
1068             let nameHash := keccak256(add(name, 32), mload(name))
1069             let versionHash := keccak256(add(version, 32), mload(version))
1070 
1071         // Load free memory pointer
1072             let memPtr := mload(64)
1073 
1074         // Store params in memory
1075             mstore(memPtr, schemaHash)
1076             mstore(add(memPtr, 32), nameHash)
1077             mstore(add(memPtr, 64), versionHash)
1078             mstore(add(memPtr, 96), chainId)
1079             mstore(add(memPtr, 128), verifyingContract)
1080 
1081         // Compute hash
1082             result := keccak256(memPtr, 160)
1083         }
1084         return result;
1085     }
1086 
1087     /// @dev Calculates EIP712 encoding for a hash struct with a given domain hash.
1088     /// @param eip712DomainHash Hash of the domain domain separator data, computed
1089     ///                         with getDomainHash().
1090     /// @param hashStruct The EIP712 hash struct.
1091     /// @return EIP712 hash applied to the given EIP712 Domain.
1092     function hashEIP712Message(bytes32 eip712DomainHash, bytes32 hashStruct)
1093     internal
1094     pure
1095     returns (bytes32 result)
1096     {
1097         // Assembly for more efficient computing:
1098         // keccak256(abi.encodePacked(
1099         //     EIP191_HEADER,
1100         //     EIP712_DOMAIN_HASH,
1101         //     hashStruct
1102         // ));
1103 
1104         assembly {
1105         // Load free memory pointer
1106             let memPtr := mload(64)
1107 
1108             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
1109             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
1110             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
1111 
1112         // Compute hash
1113             result := keccak256(memPtr, 66)
1114         }
1115         return result;
1116     }
1117 }
1118 
1119 /**
1120  * @title Decimal
1121  * @author dYdX
1122  *
1123  * Library that defines a fixed-point number with 18 decimal places.
1124  */
1125 library Decimal {
1126     using SafeMath for uint256;
1127 
1128     // ============ Constants ============
1129 
1130     uint256 constant BASE = 10**18;
1131 
1132     // ============ Structs ============
1133 
1134 
1135     struct D256 {
1136         uint256 value;
1137     }
1138 
1139     // ============ Static Functions ============
1140 
1141     function zero()
1142     internal
1143     pure
1144     returns (D256 memory)
1145     {
1146         return D256({ value: 0 });
1147     }
1148 
1149     function one()
1150     internal
1151     pure
1152     returns (D256 memory)
1153     {
1154         return D256({ value: BASE });
1155     }
1156 
1157     function from(
1158         uint256 a
1159     )
1160     internal
1161     pure
1162     returns (D256 memory)
1163     {
1164         return D256({ value: a.mul(BASE) });
1165     }
1166 
1167     function ratio(
1168         uint256 a,
1169         uint256 b
1170     )
1171     internal
1172     pure
1173     returns (D256 memory)
1174     {
1175         return D256({ value: getPartial(a, BASE, b) });
1176     }
1177 
1178     // ============ Self Functions ============
1179 
1180     function add(
1181         D256 memory self,
1182         uint256 b
1183     )
1184     internal
1185     pure
1186     returns (D256 memory)
1187     {
1188         return D256({ value: self.value.add(b.mul(BASE)) });
1189     }
1190 
1191     function sub(
1192         D256 memory self,
1193         uint256 b
1194     )
1195     internal
1196     pure
1197     returns (D256 memory)
1198     {
1199         return D256({ value: self.value.sub(b.mul(BASE)) });
1200     }
1201 
1202     function sub(
1203         D256 memory self,
1204         uint256 b,
1205         string memory reason
1206     )
1207     internal
1208     pure
1209     returns (D256 memory)
1210     {
1211         return D256({ value: self.value.sub(b.mul(BASE), reason) });
1212     }
1213 
1214     function mul(
1215         D256 memory self,
1216         uint256 b
1217     )
1218     internal
1219     pure
1220     returns (D256 memory)
1221     {
1222         return D256({ value: self.value.mul(b) });
1223     }
1224 
1225     function div(
1226         D256 memory self,
1227         uint256 b
1228     )
1229     internal
1230     pure
1231     returns (D256 memory)
1232     {
1233         return D256({ value: self.value.div(b) });
1234     }
1235 
1236     function pow(
1237         D256 memory self,
1238         uint256 b
1239     )
1240     internal
1241     pure
1242     returns (D256 memory)
1243     {
1244         if (b == 0) {
1245             return from(1);
1246         }
1247 
1248         D256 memory temp = D256({ value: self.value });
1249         for (uint256 i = 1; i < b; i++) {
1250             temp = mul(temp, self);
1251         }
1252 
1253         return temp;
1254     }
1255 
1256     function add(
1257         D256 memory self,
1258         D256 memory b
1259     )
1260     internal
1261     pure
1262     returns (D256 memory)
1263     {
1264         return D256({ value: self.value.add(b.value) });
1265     }
1266 
1267     function sub(
1268         D256 memory self,
1269         D256 memory b
1270     )
1271     internal
1272     pure
1273     returns (D256 memory)
1274     {
1275         return D256({ value: self.value.sub(b.value) });
1276     }
1277 
1278     function sub(
1279         D256 memory self,
1280         D256 memory b,
1281         string memory reason
1282     )
1283     internal
1284     pure
1285     returns (D256 memory)
1286     {
1287         return D256({ value: self.value.sub(b.value, reason) });
1288     }
1289 
1290     function mul(
1291         D256 memory self,
1292         D256 memory b
1293     )
1294     internal
1295     pure
1296     returns (D256 memory)
1297     {
1298         return D256({ value: getPartial(self.value, b.value, BASE) });
1299     }
1300 
1301     function div(
1302         D256 memory self,
1303         D256 memory b
1304     )
1305     internal
1306     pure
1307     returns (D256 memory)
1308     {
1309         return D256({ value: getPartial(self.value, BASE, b.value) });
1310     }
1311 
1312     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
1313         return self.value == b.value;
1314     }
1315 
1316     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1317         return compareTo(self, b) == 2;
1318     }
1319 
1320     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1321         return compareTo(self, b) == 0;
1322     }
1323 
1324     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1325         return compareTo(self, b) > 0;
1326     }
1327 
1328     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1329         return compareTo(self, b) < 2;
1330     }
1331 
1332     function isZero(D256 memory self) internal pure returns (bool) {
1333         return self.value == 0;
1334     }
1335 
1336     function asUint256(D256 memory self) internal pure returns (uint256) {
1337         return self.value.div(BASE);
1338     }
1339 
1340     // ============ Core Methods ============
1341 
1342     function getPartial(
1343         uint256 target,
1344         uint256 numerator,
1345         uint256 denominator
1346     )
1347     private
1348     pure
1349     returns (uint256)
1350     {
1351         return target.mul(numerator).div(denominator);
1352     }
1353 
1354     function compareTo(
1355         D256 memory a,
1356         D256 memory b
1357     )
1358     private
1359     pure
1360     returns (uint256)
1361     {
1362         if (a.value == b.value) {
1363             return 1;
1364         }
1365         return a.value > b.value ? 2 : 0;
1366     }
1367 }
1368 
1369 library Constants {
1370     /* Chain */
1371     uint256 private constant CHAIN_ID = 1; // Mainnet
1372 
1373     /* Bootstrapping */
1374     uint256 private constant BOOTSTRAPPING_PERIOD = 56; // 14 days
1375     uint256 private constant BOOTSTRAPPING_PRICE = 11e17; // ESG price == 1.10 * sXAU
1376 
1377     /* Oracle */
1378     address private constant sXAU = address(0x261EfCdD24CeA98652B9700800a13DfBca4103fF);
1379     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e18;
1380 
1381     /* Bonding */
1382     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 ESG -> 100M ESGS
1383 
1384     /* Epoch */
1385     struct EpochStrategy {
1386         uint256 offset;
1387         uint256 start;
1388         uint256 period;
1389     }
1390 
1391     uint256 private constant EPOCH_START = 1609027200; // 2020-12-27T00:00:00+00:00
1392     uint256 private constant EPOCH_OFFSET = 0;
1393     uint256 private constant EPOCH_PERIOD = 21600; // 6 hours
1394 
1395     /* Governance */
1396     uint256 private constant GOVERNANCE_PERIOD = 9; // 9 epochs
1397     uint256 private constant GOVERNANCE_EXPIRATION = 2; // 2 + 1 epochs
1398     uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
1399     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 5e15; // 0.5%
1400     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
1401     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
1402 
1403     /* DAO */
1404     uint256 private constant ADVANCE_INCENTIVE = 1e17; // 0.1 ESG
1405     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 20; // 5 days
1406 
1407     /* Pool */
1408     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 8; // 2 days
1409 
1410     /* Market */
1411     uint256 private constant COUPON_EXPIRATION = 120; // 30 days
1412     uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%
1413 
1414     /* Regulator */
1415     uint256 private constant SUPPLY_CHANGE_LIMIT = 1e17; // 10%
1416     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 6e16; // 6%
1417     uint256 private constant ORACLE_POOL_RATIO = 20; // 20%
1418     uint256 private constant TREASURY_RATIO = 250; // 2.5%, until TREASURY_ADDRESS is set, this portion is sent to LP
1419 
1420     // TODO: vote on recipient
1421     address private constant TREASURY_ADDRESS = address(0x0000000000000000000000000000000000000000);
1422 
1423     function getSXAUAddress() internal pure returns (address) {
1424         return sXAU;
1425     }
1426 
1427     function getOracleReserveMinimum() internal pure returns (uint256) {
1428         return ORACLE_RESERVE_MINIMUM;
1429     }
1430 
1431     function getCurrentEpochStrategy() internal pure returns (EpochStrategy memory) {
1432         return EpochStrategy({
1433             offset: EPOCH_OFFSET,
1434             start: EPOCH_START,
1435             period: EPOCH_PERIOD
1436         });
1437     }
1438 
1439     function getInitialStakeMultiple() internal pure returns (uint256) {
1440         return INITIAL_STAKE_MULTIPLE;
1441     }
1442 
1443     function getBootstrappingPeriod() internal pure returns (uint256) {
1444         return BOOTSTRAPPING_PERIOD;
1445     }
1446 
1447     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1448         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1449     }
1450 
1451     function getGovernancePeriod() internal pure returns (uint256) {
1452         return GOVERNANCE_PERIOD;
1453     }
1454 
1455     function getGovernanceExpiration() internal pure returns (uint256) {
1456         return GOVERNANCE_EXPIRATION;
1457     }
1458 
1459     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1460         return Decimal.D256({value: GOVERNANCE_QUORUM});
1461     }
1462 
1463     function getGovernanceProposalThreshold() internal pure returns (Decimal.D256 memory) {
1464         return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
1465     }
1466 
1467     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1468         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1469     }
1470 
1471     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1472         return GOVERNANCE_EMERGENCY_DELAY;
1473     }
1474 
1475     function getAdvanceIncentive() internal pure returns (uint256) {
1476         return ADVANCE_INCENTIVE;
1477     }
1478 
1479     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1480         return DAO_EXIT_LOCKUP_EPOCHS;
1481     }
1482 
1483     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1484         return POOL_EXIT_LOCKUP_EPOCHS;
1485     }
1486 
1487     function getCouponExpiration() internal pure returns (uint256) {
1488         return COUPON_EXPIRATION;
1489     }
1490 
1491     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1492         return Decimal.D256({value: DEBT_RATIO_CAP});
1493     }
1494 
1495     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1496         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1497     }
1498 
1499     function getCouponSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1500         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
1501     }
1502 
1503     function getOraclePoolRatio() internal pure returns (uint256) {
1504         return ORACLE_POOL_RATIO;
1505     }
1506 
1507     function getTreasuryRatio() internal pure returns (uint256) {
1508         return TREASURY_RATIO;
1509     }
1510 
1511     function getChainId() internal pure returns (uint256) {
1512         return CHAIN_ID;
1513     }
1514 
1515     function getTreasuryAddress() internal pure returns (address) {
1516         return TREASURY_ADDRESS;
1517     }
1518 }
1519 
1520 contract Permittable is ERC20Detailed, ERC20 {
1521     bytes32 constant FILE = "Permittable";
1522 
1523     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1524     bytes32 public constant EIP712_PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1525     string private constant EIP712_VERSION = "1";
1526 
1527     bytes32 public EIP712_DOMAIN_SEPARATOR;
1528 
1529     mapping(address => uint256) nonces;
1530 
1531     constructor() public {
1532         EIP712_DOMAIN_SEPARATOR = LibEIP712.hashEIP712Domain(name(), EIP712_VERSION, Constants.getChainId(), address(this));
1533     }
1534 
1535     function permit(
1536         address owner,
1537         address spender,
1538         uint256 value,
1539         uint256 deadline,
1540         uint8 v,
1541         bytes32 r,
1542         bytes32 s
1543     ) external {
1544         bytes32 digest = LibEIP712.hashEIP712Message(
1545             EIP712_DOMAIN_SEPARATOR,
1546             keccak256(abi.encode(
1547                 EIP712_PERMIT_TYPEHASH,
1548                 owner,
1549                 spender,
1550                 value,
1551                 nonces[owner]++,
1552                 deadline
1553             ))
1554         );
1555 
1556         address recovered = ecrecover(digest, v, r, s);
1557         Require.that(
1558             recovered == owner,
1559             FILE,
1560             "Invalid signature"
1561         );
1562 
1563         Require.that(
1564             recovered != address(0),
1565             FILE,
1566             "Zero address"
1567         );
1568 
1569         Require.that(
1570             now <= deadline,
1571             FILE,
1572             "Expired"
1573         );
1574 
1575         _approve(owner, spender, value);
1576     }
1577 }
1578 
1579 contract IGold is IERC20 {
1580     function burn(uint256 amount) public;
1581     function burnFrom(address account, uint256 amount) public;
1582     function mint(address account, uint256 amount) public returns (bool);
1583 }
1584 
1585 contract Gold is IGold, MinterRole, ERC20Detailed, Permittable, ERC20Burnable {
1586 
1587     constructor()
1588     ERC20Detailed("Empty Set Gold", "ESG", 18)
1589     Permittable()
1590     public
1591     { }
1592 
1593     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1594         _mint(account, amount);
1595         return true;
1596     }
1597 
1598     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1599         _transfer(sender, recipient, amount);
1600         if (allowance(sender, _msgSender()) != uint256(-1)) {
1601             _approve(
1602                 sender,
1603                 _msgSender(),
1604                 allowance(sender, _msgSender()).sub(amount, "Gold: transfer amount exceeds allowance"));
1605         }
1606         return true;
1607     }
1608 }