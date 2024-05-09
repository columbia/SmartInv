1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.17;
4 pragma experimental ABIEncoderV2;
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
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
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
111 // File: @openzeppelin/contracts/math/SafeMath.sol
112 
113 
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      * - Subtraction cannot overflow.
166      *
167      * _Available since v2.4.0._
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      * - Multiplication cannot overflow.
184      */
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
187         // benefit is lost if 'b' is also tested.
188         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
189         if (a == 0) {
190             return 0;
191         }
192 
193         uint256 c = a * b;
194         require(c / a == b, "SafeMath: multiplication overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return div(a, b, "SafeMath: division by zero");
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      * - The divisor cannot be zero.
224      *
225      * _Available since v2.4.0._
226      */
227     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         // Solidity only automatically asserts when dividing by 0
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         return mod(a, b, "SafeMath: modulo by zero");
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts with custom message when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      * - The divisor cannot be zero.
261      *
262      * _Available since v2.4.0._
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
271 
272 
273 
274 
275 
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
309 
310     /**
311      * @dev See {IERC20-totalSupply}.
312      */
313     function totalSupply() public view returns (uint256) {
314         return _totalSupply;
315     }
316 
317     /**
318      * @dev See {IERC20-balanceOf}.
319      */
320     function balanceOf(address account) public view returns (uint256) {
321         return _balances[account];
322     }
323 
324     /**
325      * @dev See {IERC20-transfer}.
326      *
327      * Requirements:
328      *
329      * - `recipient` cannot be the zero address.
330      * - the caller must have a balance of at least `amount`.
331      */
332     function transfer(address recipient, uint256 amount) public returns (bool) {
333         _transfer(_msgSender(), recipient, amount);
334         return true;
335     }
336 
337     /**
338      * @dev See {IERC20-allowance}.
339      */
340     function allowance(address owner, address spender) public view returns (uint256) {
341         return _allowances[owner][spender];
342     }
343 
344     /**
345      * @dev See {IERC20-approve}.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      */
351     function approve(address spender, uint256 amount) public returns (bool) {
352         _approve(_msgSender(), spender, amount);
353         return true;
354     }
355 
356     /**
357      * @dev See {IERC20-transferFrom}.
358      *
359      * Emits an {Approval} event indicating the updated allowance. This is not
360      * required by the EIP. See the note at the beginning of {ERC20};
361      *
362      * Requirements:
363      * - `sender` and `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `amount`.
365      * - the caller must have allowance for `sender`'s tokens of at least
366      * `amount`.
367      */
368     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
369         _transfer(sender, recipient, amount);
370         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
371         return true;
372     }
373 
374     /**
375      * @dev Atomically increases the allowance granted to `spender` by the caller.
376      *
377      * This is an alternative to {approve} that can be used as a mitigation for
378      * problems described in {IERC20-approve}.
379      *
380      * Emits an {Approval} event indicating the updated allowance.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      */
386     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
387         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
388         return true;
389     }
390 
391     /**
392      * @dev Atomically decreases the allowance granted to `spender` by the caller.
393      *
394      * This is an alternative to {approve} that can be used as a mitigation for
395      * problems described in {IERC20-approve}.
396      *
397      * Emits an {Approval} event indicating the updated allowance.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      * - `spender` must have allowance for the caller of at least
403      * `subtractedValue`.
404      */
405     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
406         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
407         return true;
408     }
409 
410     /**
411      * @dev Moves tokens `amount` from `sender` to `recipient`.
412      *
413      * This is internal function is equivalent to {transfer}, and can be used to
414      * e.g. implement automatic token fees, slashing mechanisms, etc.
415      *
416      * Emits a {Transfer} event.
417      *
418      * Requirements:
419      *
420      * - `sender` cannot be the zero address.
421      * - `recipient` cannot be the zero address.
422      * - `sender` must have a balance of at least `amount`.
423      */
424     function _transfer(address sender, address recipient, uint256 amount) internal {
425         require(sender != address(0), "ERC20: transfer from the zero address");
426         require(recipient != address(0), "ERC20: transfer to the zero address");
427 
428         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
429         _balances[recipient] = _balances[recipient].add(amount);
430         emit Transfer(sender, recipient, amount);
431     }
432 
433     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
434      * the total supply.
435      *
436      * Emits a {Transfer} event with `from` set to the zero address.
437      *
438      * Requirements
439      *
440      * - `to` cannot be the zero address.
441      */
442     function _mint(address account, uint256 amount) internal {
443         require(account != address(0), "ERC20: mint to the zero address");
444 
445         _totalSupply = _totalSupply.add(amount);
446         _balances[account] = _balances[account].add(amount);
447         emit Transfer(address(0), account, amount);
448     }
449 
450     /**
451      * @dev Destroys `amount` tokens from `account`, reducing the
452      * total supply.
453      *
454      * Emits a {Transfer} event with `to` set to the zero address.
455      *
456      * Requirements
457      *
458      * - `account` cannot be the zero address.
459      * - `account` must have at least `amount` tokens.
460      */
461     function _burn(address account, uint256 amount) internal {
462         require(account != address(0), "ERC20: burn from the zero address");
463 
464         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
465         _totalSupply = _totalSupply.sub(amount);
466         emit Transfer(account, address(0), amount);
467     }
468 
469     /**
470      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
471      *
472      * This is internal function is equivalent to `approve`, and can be used to
473      * e.g. set automatic allowances for certain subsystems, etc.
474      *
475      * Emits an {Approval} event.
476      *
477      * Requirements:
478      *
479      * - `owner` cannot be the zero address.
480      * - `spender` cannot be the zero address.
481      */
482     function _approve(address owner, address spender, uint256 amount) internal {
483         require(owner != address(0), "ERC20: approve from the zero address");
484         require(spender != address(0), "ERC20: approve to the zero address");
485 
486         _allowances[owner][spender] = amount;
487         emit Approval(owner, spender, amount);
488     }
489 
490     /**
491      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
492      * from the caller's allowance.
493      *
494      * See {_burn} and {_approve}.
495      */
496     function _burnFrom(address account, uint256 amount) internal {
497         _burn(account, amount);
498         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
499     }
500 }
501 
502 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
503 
504 
505 
506 
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
531 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
532 
533 
534 
535 
536 /**
537  * @dev Optional functions from the ERC20 standard.
538  */
539 contract ERC20Detailed is IERC20 {
540     string private _name;
541     string private _symbol;
542     uint8 private _decimals;
543 
544     /**
545      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
546      * these values are immutable: they can only be set once during
547      * construction.
548      */
549     constructor (string memory name, string memory symbol, uint8 decimals) public {
550         _name = name;
551         _symbol = symbol;
552         _decimals = decimals;
553     }
554 
555     /**
556      * @dev Returns the name of the token.
557      */
558     function name() public view returns (string memory) {
559         return _name;
560     }
561 
562     /**
563      * @dev Returns the symbol of the token, usually a shorter version of the
564      * name.
565      */
566     function symbol() public view returns (string memory) {
567         return _symbol;
568     }
569 
570     /**
571      * @dev Returns the number of decimals used to get its user representation.
572      * For example, if `decimals` equals `2`, a balance of `505` tokens should
573      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
574      *
575      * Tokens usually opt for a value of 18, imitating the relationship between
576      * Ether and Wei.
577      *
578      * NOTE: This information is only used for _display_ purposes: it in
579      * no way affects any of the arithmetic of the contract, including
580      * {IERC20-balanceOf} and {IERC20-transfer}.
581      */
582     function decimals() public view returns (uint8) {
583         return _decimals;
584     }
585 }
586 
587 // File: @openzeppelin/contracts/access/Roles.sol
588 
589 
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
626 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
627 
628 
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
672 // File: contracts/external/Require.sol
673 
674 /*
675     Copyright 2019 dYdX Trading Inc.
676 
677     Licensed under the Apache License, Version 2.0 (the "License");
678     you may not use this file except in compliance with the License.
679     You may obtain a copy of the License at
680 
681     http://www.apache.org/licenses/LICENSE-2.0
682 
683     Unless required by applicable law or agreed to in writing, software
684     distributed under the License is distributed on an "AS IS" BASIS,
685     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
686     See the License for the specific language governing permissions and
687     limitations under the License.
688 */
689 
690 
691 
692 /**
693  * @title Require
694  * @author dYdX
695  *
696  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
697  */
698 library Require {
699 
700     // ============ Constants ============
701 
702     uint256 constant ASCII_ZERO = 48; // '0'
703     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
704     uint256 constant ASCII_LOWER_EX = 120; // 'x'
705     bytes2 constant COLON = 0x3a20; // ': '
706     bytes2 constant COMMA = 0x2c20; // ', '
707     bytes2 constant LPAREN = 0x203c; // ' <'
708     byte constant RPAREN = 0x3e; // '>'
709     uint256 constant FOUR_BIT_MASK = 0xf;
710 
711     // ============ Library Functions ============
712 
713     function that(
714         bool must,
715         bytes32 file,
716         bytes32 reason
717     )
718     internal
719     pure
720     {
721         if (!must) {
722             revert(
723                 string(
724                     abi.encodePacked(
725                         stringifyTruncated(file),
726                         COLON,
727                         stringifyTruncated(reason)
728                     )
729                 )
730             );
731         }
732     }
733 
734     function that(
735         bool must,
736         bytes32 file,
737         bytes32 reason,
738         uint256 payloadA
739     )
740     internal
741     pure
742     {
743         if (!must) {
744             revert(
745                 string(
746                     abi.encodePacked(
747                         stringifyTruncated(file),
748                         COLON,
749                         stringifyTruncated(reason),
750                         LPAREN,
751                         stringify(payloadA),
752                         RPAREN
753                     )
754                 )
755             );
756         }
757     }
758 
759     function that(
760         bool must,
761         bytes32 file,
762         bytes32 reason,
763         uint256 payloadA,
764         uint256 payloadB
765     )
766     internal
767     pure
768     {
769         if (!must) {
770             revert(
771                 string(
772                     abi.encodePacked(
773                         stringifyTruncated(file),
774                         COLON,
775                         stringifyTruncated(reason),
776                         LPAREN,
777                         stringify(payloadA),
778                         COMMA,
779                         stringify(payloadB),
780                         RPAREN
781                     )
782                 )
783             );
784         }
785     }
786 
787     function that(
788         bool must,
789         bytes32 file,
790         bytes32 reason,
791         address payloadA
792     )
793     internal
794     pure
795     {
796         if (!must) {
797             revert(
798                 string(
799                     abi.encodePacked(
800                         stringifyTruncated(file),
801                         COLON,
802                         stringifyTruncated(reason),
803                         LPAREN,
804                         stringify(payloadA),
805                         RPAREN
806                     )
807                 )
808             );
809         }
810     }
811 
812     function that(
813         bool must,
814         bytes32 file,
815         bytes32 reason,
816         address payloadA,
817         uint256 payloadB
818     )
819     internal
820     pure
821     {
822         if (!must) {
823             revert(
824                 string(
825                     abi.encodePacked(
826                         stringifyTruncated(file),
827                         COLON,
828                         stringifyTruncated(reason),
829                         LPAREN,
830                         stringify(payloadA),
831                         COMMA,
832                         stringify(payloadB),
833                         RPAREN
834                     )
835                 )
836             );
837         }
838     }
839 
840     function that(
841         bool must,
842         bytes32 file,
843         bytes32 reason,
844         address payloadA,
845         uint256 payloadB,
846         uint256 payloadC
847     )
848     internal
849     pure
850     {
851         if (!must) {
852             revert(
853                 string(
854                     abi.encodePacked(
855                         stringifyTruncated(file),
856                         COLON,
857                         stringifyTruncated(reason),
858                         LPAREN,
859                         stringify(payloadA),
860                         COMMA,
861                         stringify(payloadB),
862                         COMMA,
863                         stringify(payloadC),
864                         RPAREN
865                     )
866                 )
867             );
868         }
869     }
870 
871     function that(
872         bool must,
873         bytes32 file,
874         bytes32 reason,
875         bytes32 payloadA
876     )
877     internal
878     pure
879     {
880         if (!must) {
881             revert(
882                 string(
883                     abi.encodePacked(
884                         stringifyTruncated(file),
885                         COLON,
886                         stringifyTruncated(reason),
887                         LPAREN,
888                         stringify(payloadA),
889                         RPAREN
890                     )
891                 )
892             );
893         }
894     }
895 
896     function that(
897         bool must,
898         bytes32 file,
899         bytes32 reason,
900         bytes32 payloadA,
901         uint256 payloadB,
902         uint256 payloadC
903     )
904     internal
905     pure
906     {
907         if (!must) {
908             revert(
909                 string(
910                     abi.encodePacked(
911                         stringifyTruncated(file),
912                         COLON,
913                         stringifyTruncated(reason),
914                         LPAREN,
915                         stringify(payloadA),
916                         COMMA,
917                         stringify(payloadB),
918                         COMMA,
919                         stringify(payloadC),
920                         RPAREN
921                     )
922                 )
923             );
924         }
925     }
926 
927     // ============ Private Functions ============
928 
929     function stringifyTruncated(
930         bytes32 input
931     )
932     private
933     pure
934     returns (bytes memory)
935     {
936         // put the input bytes into the result
937         bytes memory result = abi.encodePacked(input);
938 
939         // determine the length of the input by finding the location of the last non-zero byte
940         for (uint256 i = 32; i > 0; ) {
941             // reverse-for-loops with unsigned integer
942             /* solium-disable-next-line security/no-modify-for-iter-var */
943             i--;
944 
945             // find the last non-zero byte in order to determine the length
946             if (result[i] != 0) {
947                 uint256 length = i + 1;
948 
949                 /* solium-disable-next-line security/no-inline-assembly */
950                 assembly {
951                     mstore(result, length) // r.length = length;
952                 }
953 
954                 return result;
955             }
956         }
957 
958         // all bytes are zero
959         return new bytes(0);
960     }
961 
962     function stringify(
963         uint256 input
964     )
965     private
966     pure
967     returns (bytes memory)
968     {
969         if (input == 0) {
970             return "0";
971         }
972 
973         // get the final string length
974         uint256 j = input;
975         uint256 length;
976         while (j != 0) {
977             length++;
978             j /= 10;
979         }
980 
981         // allocate the string
982         bytes memory bstr = new bytes(length);
983 
984         // populate the string starting with the least-significant character
985         j = input;
986         for (uint256 i = length; i > 0; ) {
987             // reverse-for-loops with unsigned integer
988             /* solium-disable-next-line security/no-modify-for-iter-var */
989             i--;
990 
991             // take last decimal digit
992             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
993 
994             // remove the last decimal digit
995             j /= 10;
996         }
997 
998         return bstr;
999     }
1000 
1001     function stringify(
1002         address input
1003     )
1004     private
1005     pure
1006     returns (bytes memory)
1007     {
1008         uint256 z = uint256(input);
1009 
1010         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
1011         bytes memory result = new bytes(42);
1012 
1013         // populate the result with "0x"
1014         result[0] = byte(uint8(ASCII_ZERO));
1015         result[1] = byte(uint8(ASCII_LOWER_EX));
1016 
1017         // for each byte (starting from the lowest byte), populate the result with two characters
1018         for (uint256 i = 0; i < 20; i++) {
1019             // each byte takes two characters
1020             uint256 shift = i * 2;
1021 
1022             // populate the least-significant character
1023             result[41 - shift] = char(z & FOUR_BIT_MASK);
1024             z = z >> 4;
1025 
1026             // populate the most-significant character
1027             result[40 - shift] = char(z & FOUR_BIT_MASK);
1028             z = z >> 4;
1029         }
1030 
1031         return result;
1032     }
1033 
1034     function stringify(
1035         bytes32 input
1036     )
1037     private
1038     pure
1039     returns (bytes memory)
1040     {
1041         uint256 z = uint256(input);
1042 
1043         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
1044         bytes memory result = new bytes(66);
1045 
1046         // populate the result with "0x"
1047         result[0] = byte(uint8(ASCII_ZERO));
1048         result[1] = byte(uint8(ASCII_LOWER_EX));
1049 
1050         // for each byte (starting from the lowest byte), populate the result with two characters
1051         for (uint256 i = 0; i < 32; i++) {
1052             // each byte takes two characters
1053             uint256 shift = i * 2;
1054 
1055             // populate the least-significant character
1056             result[65 - shift] = char(z & FOUR_BIT_MASK);
1057             z = z >> 4;
1058 
1059             // populate the most-significant character
1060             result[64 - shift] = char(z & FOUR_BIT_MASK);
1061             z = z >> 4;
1062         }
1063 
1064         return result;
1065     }
1066 
1067     function char(
1068         uint256 input
1069     )
1070     private
1071     pure
1072     returns (byte)
1073     {
1074         // return ASCII digit (0-9)
1075         if (input < 10) {
1076             return byte(uint8(input + ASCII_ZERO));
1077         }
1078 
1079         // return ASCII letter (a-f)
1080         return byte(uint8(input + ASCII_RELATIVE_ZERO));
1081     }
1082 }
1083 
1084 // File: contracts/external/LibEIP712.sol
1085 
1086 /*
1087     Copyright 2019 ZeroEx Intl.
1088 
1089     Licensed under the Apache License, Version 2.0 (the "License");
1090     you may not use this file except in compliance with the License.
1091     You may obtain a copy of the License at
1092 
1093     http://www.apache.org/licenses/LICENSE-2.0
1094 
1095     Unless required by applicable law or agreed to in writing, software
1096     distributed under the License is distributed on an "AS IS" BASIS,
1097     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1098     See the License for the specific language governing permissions and
1099     limitations under the License.
1100 */
1101 
1102 
1103 
1104 
1105 library LibEIP712 {
1106 
1107     // Hash of the EIP712 Domain Separator Schema
1108     // keccak256(abi.encodePacked(
1109     //     "EIP712Domain(",
1110     //     "string name,",
1111     //     "string version,",
1112     //     "uint256 chainId,",
1113     //     "address verifyingContract",
1114     //     ")"
1115     // ))
1116     bytes32 constant internal _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
1117 
1118     /// @dev Calculates a EIP712 domain separator.
1119     /// @param name The EIP712 domain name.
1120     /// @param version The EIP712 domain version.
1121     /// @param verifyingContract The EIP712 verifying contract.
1122     /// @return EIP712 domain separator.
1123     function hashEIP712Domain(
1124         string memory name,
1125         string memory version,
1126         uint256 chainId,
1127         address verifyingContract
1128     )
1129     internal
1130     pure
1131     returns (bytes32 result)
1132     {
1133         bytes32 schemaHash = _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH;
1134 
1135         // Assembly for more efficient computing:
1136         // keccak256(abi.encodePacked(
1137         //     _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
1138         //     keccak256(bytes(name)),
1139         //     keccak256(bytes(version)),
1140         //     chainId,
1141         //     uint256(verifyingContract)
1142         // ))
1143 
1144         assembly {
1145         // Calculate hashes of dynamic data
1146             let nameHash := keccak256(add(name, 32), mload(name))
1147             let versionHash := keccak256(add(version, 32), mload(version))
1148 
1149         // Load free memory pointer
1150             let memPtr := mload(64)
1151 
1152         // Store params in memory
1153             mstore(memPtr, schemaHash)
1154             mstore(add(memPtr, 32), nameHash)
1155             mstore(add(memPtr, 64), versionHash)
1156             mstore(add(memPtr, 96), chainId)
1157             mstore(add(memPtr, 128), verifyingContract)
1158 
1159         // Compute hash
1160             result := keccak256(memPtr, 160)
1161         }
1162         return result;
1163     }
1164 
1165     /// @dev Calculates EIP712 encoding for a hash struct with a given domain hash.
1166     /// @param eip712DomainHash Hash of the domain domain separator data, computed
1167     ///                         with getDomainHash().
1168     /// @param hashStruct The EIP712 hash struct.
1169     /// @return EIP712 hash applied to the given EIP712 Domain.
1170     function hashEIP712Message(bytes32 eip712DomainHash, bytes32 hashStruct)
1171     internal
1172     pure
1173     returns (bytes32 result)
1174     {
1175         // Assembly for more efficient computing:
1176         // keccak256(abi.encodePacked(
1177         //     EIP191_HEADER,
1178         //     EIP712_DOMAIN_HASH,
1179         //     hashStruct
1180         // ));
1181 
1182         assembly {
1183         // Load free memory pointer
1184             let memPtr := mload(64)
1185 
1186             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
1187             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
1188             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
1189 
1190         // Compute hash
1191             result := keccak256(memPtr, 66)
1192         }
1193         return result;
1194     }
1195 }
1196 
1197 // File: contracts/external/Decimal.sol
1198 
1199 /*
1200     Copyright 2019 dYdX Trading Inc.
1201     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1202 
1203     Licensed under the Apache License, Version 2.0 (the "License");
1204     you may not use this file except in compliance with the License.
1205     You may obtain a copy of the License at
1206 
1207     http://www.apache.org/licenses/LICENSE-2.0
1208 
1209     Unless required by applicable law or agreed to in writing, software
1210     distributed under the License is distributed on an "AS IS" BASIS,
1211     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1212     See the License for the specific language governing permissions and
1213     limitations under the License.
1214 */
1215 
1216 
1217 
1218 
1219 
1220 /**
1221  * @title Decimal
1222  * @author dYdX
1223  *
1224  * Library that defines a fixed-point number with 18 decimal places.
1225  */
1226 library Decimal {
1227     using SafeMath for uint256;
1228 
1229     // ============ Constants ============
1230 
1231     uint256 constant BASE = 10**18;
1232 
1233     // ============ Structs ============
1234 
1235 
1236     struct D256 {
1237         uint256 value;
1238     }
1239 
1240     // ============ Static Functions ============
1241 
1242     function zero()
1243     internal
1244     pure
1245     returns (D256 memory)
1246     {
1247         return D256({ value: 0 });
1248     }
1249 
1250     function one()
1251     internal
1252     pure
1253     returns (D256 memory)
1254     {
1255         return D256({ value: BASE });
1256     }
1257 
1258     function from(
1259         uint256 a
1260     )
1261     internal
1262     pure
1263     returns (D256 memory)
1264     {
1265         return D256({ value: a.mul(BASE) });
1266     }
1267 
1268     function ratio(
1269         uint256 a,
1270         uint256 b
1271     )
1272     internal
1273     pure
1274     returns (D256 memory)
1275     {
1276         return D256({ value: getPartial(a, BASE, b) });
1277     }
1278 
1279     // ============ Self Functions ============
1280 
1281     function add(
1282         D256 memory self,
1283         uint256 b
1284     )
1285     internal
1286     pure
1287     returns (D256 memory)
1288     {
1289         return D256({ value: self.value.add(b.mul(BASE)) });
1290     }
1291 
1292     function sub(
1293         D256 memory self,
1294         uint256 b
1295     )
1296     internal
1297     pure
1298     returns (D256 memory)
1299     {
1300         return D256({ value: self.value.sub(b.mul(BASE)) });
1301     }
1302 
1303     function sub(
1304         D256 memory self,
1305         uint256 b,
1306         string memory reason
1307     )
1308     internal
1309     pure
1310     returns (D256 memory)
1311     {
1312         return D256({ value: self.value.sub(b.mul(BASE), reason) });
1313     }
1314 
1315     function mul(
1316         D256 memory self,
1317         uint256 b
1318     )
1319     internal
1320     pure
1321     returns (D256 memory)
1322     {
1323         return D256({ value: self.value.mul(b) });
1324     }
1325 
1326     function div(
1327         D256 memory self,
1328         uint256 b
1329     )
1330     internal
1331     pure
1332     returns (D256 memory)
1333     {
1334         return D256({ value: self.value.div(b) });
1335     }
1336 
1337     function pow(
1338         D256 memory self,
1339         uint256 b
1340     )
1341     internal
1342     pure
1343     returns (D256 memory)
1344     {
1345         if (b == 0) {
1346             return from(1);
1347         }
1348 
1349         D256 memory temp = D256({ value: self.value });
1350         for (uint256 i = 1; i < b; i++) {
1351             temp = mul(temp, self);
1352         }
1353 
1354         return temp;
1355     }
1356 
1357     function add(
1358         D256 memory self,
1359         D256 memory b
1360     )
1361     internal
1362     pure
1363     returns (D256 memory)
1364     {
1365         return D256({ value: self.value.add(b.value) });
1366     }
1367 
1368     function sub(
1369         D256 memory self,
1370         D256 memory b
1371     )
1372     internal
1373     pure
1374     returns (D256 memory)
1375     {
1376         return D256({ value: self.value.sub(b.value) });
1377     }
1378 
1379     function sub(
1380         D256 memory self,
1381         D256 memory b,
1382         string memory reason
1383     )
1384     internal
1385     pure
1386     returns (D256 memory)
1387     {
1388         return D256({ value: self.value.sub(b.value, reason) });
1389     }
1390 
1391     function mul(
1392         D256 memory self,
1393         D256 memory b
1394     )
1395     internal
1396     pure
1397     returns (D256 memory)
1398     {
1399         return D256({ value: getPartial(self.value, b.value, BASE) });
1400     }
1401 
1402     function div(
1403         D256 memory self,
1404         D256 memory b
1405     )
1406     internal
1407     pure
1408     returns (D256 memory)
1409     {
1410         return D256({ value: getPartial(self.value, BASE, b.value) });
1411     }
1412 
1413     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
1414         return self.value == b.value;
1415     }
1416 
1417     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1418         return compareTo(self, b) == 2;
1419     }
1420 
1421     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1422         return compareTo(self, b) == 0;
1423     }
1424 
1425     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1426         return compareTo(self, b) > 0;
1427     }
1428 
1429     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1430         return compareTo(self, b) < 2;
1431     }
1432 
1433     function isZero(D256 memory self) internal pure returns (bool) {
1434         return self.value == 0;
1435     }
1436 
1437     function asUint256(D256 memory self) internal pure returns (uint256) {
1438         return self.value.div(BASE);
1439     }
1440 
1441     // ============ Core Methods ============
1442 
1443     function getPartial(
1444         uint256 target,
1445         uint256 numerator,
1446         uint256 denominator
1447     )
1448     private
1449     pure
1450     returns (uint256)
1451     {
1452         return target.mul(numerator).div(denominator);
1453     }
1454 
1455     function compareTo(
1456         D256 memory a,
1457         D256 memory b
1458     )
1459     private
1460     pure
1461     returns (uint256)
1462     {
1463         if (a.value == b.value) {
1464             return 1;
1465         }
1466         return a.value > b.value ? 2 : 0;
1467     }
1468 }
1469 
1470 // File: contracts/Constants.sol
1471 
1472 /*
1473     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1474 
1475     Licensed under the Apache License, Version 2.0 (the "License");
1476     you may not use this file except in compliance with the License.
1477     You may obtain a copy of the License at
1478 
1479     http://www.apache.org/licenses/LICENSE-2.0
1480 
1481     Unless required by applicable law or agreed to in writing, software
1482     distributed under the License is distributed on an "AS IS" BASIS,
1483     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1484     See the License for the specific language governing permissions and
1485     limitations under the License.
1486 */
1487 
1488 
1489 
1490 
1491 
1492 library Constants {
1493     /* Chain */
1494     uint256 private constant CHAIN_ID = 1; // MAINNET 
1495 
1496     /* Bootstrapping */
1497     uint256 private constant BOOTSTRAPPING_PERIOD = 180; // 180 epochs
1498     uint256 private constant BOOTSTRAPPING_PRICE = 11e17; // 1.10 USDC
1499     uint256 private constant BOOTSTRAPPING_SUPPLY_CHANGE_LIMIT = 10e16; // 10%
1500 
1501     /* Oracle */
1502     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
1503     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e9; // 1000 USDC
1504 
1505     /* Bonding */
1506     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 SPAD -> 100M SPAD-S
1507 
1508     /* Epoch */
1509     struct EpochStrategy {
1510         uint256 offset;
1511         uint256 start;
1512         uint256 period;
1513     }
1514 
1515     uint256 private constant EPOCH_OFFSET = 0;
1516     uint256 private constant EPOCH_START = 1609405200;
1517     uint256 private constant EPOCH_PERIOD = 14400; // 4 hrs
1518 
1519     /* Governance */
1520     uint256 private constant GOVERNANCE_PERIOD = 18; // 18 epochs
1521     uint256 private constant GOVERNANCE_EXPIRATION = 4; // 4 + 1 epochs
1522     uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
1523     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 5e15; // 0.5%
1524     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 66e16; // 66%
1525     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 12; // 12 epochs
1526 
1527     /* DAO */
1528     uint256 private constant ADVANCE_INCENTIVE = 5e19; // 50 SPAD
1529     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 30; // 30 epochs
1530 
1531     /* Pool */
1532     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 10; // 10 epochs
1533 
1534     /* Market */
1535     uint256 private constant COUPON_EXPIRATION = 180;
1536     uint256 private constant DEBT_RATIO_CAP = 15e16; // 15%
1537 
1538     /* Regulator */
1539     uint256 private constant SUPPLY_CHANGE_LIMIT = 3e16; // 3%
1540     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 6e16; // 6%
1541     uint256 private constant ORACLE_POOL_RATIO = 20; // 20%
1542     uint256 private constant TREASURY_RATIO = 450; // 4.5%
1543 
1544     /* Address */
1545     address private constant TREASURY_ADDRESS = address(0xBe8F6aa69e85b7d21B3C2cFdC48E2376e68d1AFE);
1546 
1547     /**
1548      * Getters
1549      */
1550     function getUsdcAddress() internal pure returns (address) {
1551         return USDC;
1552     }
1553 
1554     function getOracleReserveMinimum() internal pure returns (uint256) {
1555         return ORACLE_RESERVE_MINIMUM;
1556     }
1557 
1558     function getEpochStrategy() internal pure returns (EpochStrategy memory) {
1559         return EpochStrategy({
1560             offset: EPOCH_OFFSET,
1561             start: EPOCH_START,
1562             period: EPOCH_PERIOD
1563         });
1564     }
1565 
1566     function getInitialStakeMultiple() internal pure returns (uint256) {
1567         return INITIAL_STAKE_MULTIPLE;
1568     }
1569 
1570     function getBootstrappingPeriod() internal pure returns (uint256) {
1571         return BOOTSTRAPPING_PERIOD;
1572     }
1573 
1574     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1575         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1576     }
1577     
1578     function getBootstrappingSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1579         return Decimal.D256({value: BOOTSTRAPPING_SUPPLY_CHANGE_LIMIT});
1580     }
1581 
1582     function getGovernancePeriod() internal pure returns (uint256) {
1583         return GOVERNANCE_PERIOD;
1584     }
1585 
1586     function getGovernanceExpiration() internal pure returns (uint256) {
1587         return GOVERNANCE_EXPIRATION;
1588     }
1589 
1590     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1591         return Decimal.D256({value: GOVERNANCE_QUORUM});
1592     }
1593 
1594     function getGovernanceProposalThreshold() internal pure returns (Decimal.D256 memory) {
1595         return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
1596     }
1597 
1598     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1599         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1600     }
1601 
1602     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1603         return GOVERNANCE_EMERGENCY_DELAY;
1604     }
1605 
1606     function getAdvanceIncentive() internal pure returns (uint256) {
1607         return ADVANCE_INCENTIVE;
1608     }
1609 
1610     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1611         return DAO_EXIT_LOCKUP_EPOCHS;
1612     }
1613 
1614     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1615         return POOL_EXIT_LOCKUP_EPOCHS;
1616     }
1617 
1618     function getCouponExpiration() internal pure returns (uint256) {
1619         return COUPON_EXPIRATION;
1620     }
1621 
1622     function getTreasuryRatio() internal pure returns (uint256) {
1623         return TREASURY_RATIO;
1624     }
1625 
1626     function getCouponSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1627         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
1628     }
1629 
1630     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1631         return Decimal.D256({value: DEBT_RATIO_CAP});
1632     }
1633 
1634     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1635         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1636     }
1637 
1638     function getOraclePoolRatio() internal pure returns (uint256) {
1639         return ORACLE_POOL_RATIO;
1640     }
1641 
1642     function getChainId() internal pure returns (uint256) {
1643         return CHAIN_ID;
1644     }
1645 
1646     function getTreasuryAddress() internal pure returns (address) {
1647         return TREASURY_ADDRESS;
1648     }
1649 }
1650 
1651 // File: contracts/token/Permittable.sol
1652 
1653 /*
1654     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1655 
1656     Licensed under the Apache License, Version 2.0 (the "License");
1657     you may not use this file except in compliance with the License.
1658     You may obtain a copy of the License at
1659 
1660     http://www.apache.org/licenses/LICENSE-2.0
1661 
1662     Unless required by applicable law or agreed to in writing, software
1663     distributed under the License is distributed on an "AS IS" BASIS,
1664     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1665     See the License for the specific language governing permissions and
1666     limitations under the License.
1667 */
1668 
1669 
1670 
1671 
1672 
1673 
1674 
1675 
1676 contract Permittable is ERC20Detailed, ERC20 {
1677     bytes32 constant FILE = "Permittable";
1678 
1679     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1680     bytes32 public constant EIP712_PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1681     string private constant EIP712_VERSION = "1";
1682 
1683     bytes32 public EIP712_DOMAIN_SEPARATOR;
1684 
1685     mapping(address => uint256) nonces;
1686 
1687     constructor() public {
1688         EIP712_DOMAIN_SEPARATOR = LibEIP712.hashEIP712Domain(name(), EIP712_VERSION, Constants.getChainId(), address(this));
1689     }
1690 
1691     function permit(
1692         address owner,
1693         address spender,
1694         uint256 value,
1695         uint256 deadline,
1696         uint8 v,
1697         bytes32 r,
1698         bytes32 s
1699     ) external {
1700         bytes32 digest = LibEIP712.hashEIP712Message(
1701             EIP712_DOMAIN_SEPARATOR,
1702             keccak256(abi.encode(
1703                 EIP712_PERMIT_TYPEHASH,
1704                 owner,
1705                 spender,
1706                 value,
1707                 nonces[owner]++,
1708                 deadline
1709             ))
1710         );
1711 
1712         address recovered = ecrecover(digest, v, r, s);
1713         Require.that(
1714             recovered == owner,
1715             FILE,
1716             "Invalid signature"
1717         );
1718 
1719         Require.that(
1720             recovered != address(0),
1721             FILE,
1722             "Zero address"
1723         );
1724 
1725         Require.that(
1726             now <= deadline,
1727             FILE,
1728             "Expired"
1729         );
1730 
1731         _approve(owner, spender, value);
1732     }
1733 }
1734 
1735 // File: contracts/token/IDollar.sol
1736 
1737 /*
1738     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1739 
1740     Licensed under the Apache License, Version 2.0 (the "License");
1741     you may not use this file except in compliance with the License.
1742     You may obtain a copy of the License at
1743 
1744     http://www.apache.org/licenses/LICENSE-2.0
1745 
1746     Unless required by applicable law or agreed to in writing, software
1747     distributed under the License is distributed on an "AS IS" BASIS,
1748     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1749     See the License for the specific language governing permissions and
1750     limitations under the License.
1751 */
1752 
1753 
1754 
1755 
1756 
1757 contract IDollar is IERC20 {
1758     function burn(uint256 amount) public;
1759     function burnFrom(address account, uint256 amount) public;
1760     function mint(address account, uint256 amount) public returns (bool);
1761 }
1762 
1763 // File: contracts/token/Dollar.sol
1764 
1765 /*
1766     Copyright 2020 Dynamic Dollar Devs, based on the works of the Empty Set Squad
1767 
1768     Licensed under the Apache License, Version 2.0 (the "License");
1769     you may not use this file except in compliance with the License.
1770     You may obtain a copy of the License at
1771 
1772     http://www.apache.org/licenses/LICENSE-2.0
1773 
1774     Unless required by applicable law or agreed to in writing, software
1775     distributed under the License is distributed on an "AS IS" BASIS,
1776     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1777     See the License for the specific language governing permissions and
1778     limitations under the License.
1779 */
1780 
1781 
1782 
1783 
1784 
1785 
1786 
1787 
1788 
1789 
1790 contract Dollar is IDollar, MinterRole, ERC20Detailed, Permittable, ERC20Burnable  {
1791 
1792     constructor()
1793     ERC20Detailed("Space Dollar", "SPAD", 18)
1794     Permittable()
1795     public
1796     { }
1797 
1798     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1799         _mint(account, amount);
1800         return true;
1801     }
1802 
1803     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1804         _transfer(sender, recipient, amount);
1805         if (allowance(sender, _msgSender()) != uint256(-1)) {
1806             _approve(
1807                 sender,
1808                 _msgSender(),
1809                 allowance(sender, _msgSender()).sub(amount, "Dollar: transfer amount exceeds allowance"));
1810         }
1811         return true;
1812     }
1813 }