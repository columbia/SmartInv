1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Standard math utilities missing in the Solidity language.
9  */
10 library Math {
11     /**
12      * @dev Returns the largest of two numbers.
13      */
14     function max(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a >= b ? a : b;
16     }
17 
18     /**
19      * @dev Returns the smallest of two numbers.
20      */
21     function min(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a < b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the average of two numbers. The result is rounded towards
27      * zero.
28      */
29     function average(uint256 a, uint256 b) internal pure returns (uint256) {
30         // (a + b) / 2 can overflow, so we distribute
31         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
32     }
33 }
34 
35 // File: @openzeppelin/contracts/math/SafeMath.sol
36 
37 // SPDX-License-Identifier: MIT
38 
39 pragma solidity ^0.6.0;
40 
41 /**
42  * @dev Wrappers over Solidity's arithmetic operations with added overflow
43  * checks.
44  *
45  * Arithmetic operations in Solidity wrap on overflow. This can easily result
46  * in bugs, because programmers usually assume that an overflow raises an
47  * error, which is the standard behavior in high level programming languages.
48  * `SafeMath` restores this intuition by reverting the transaction when an
49  * operation overflows.
50  *
51  * Using this library instead of the unchecked operations eliminates an entire
52  * class of bugs, so it's recommended to use it always.
53  */
54 library SafeMath {
55     /**
56      * @dev Returns the addition of two unsigned integers, reverting on
57      * overflow.
58      *
59      * Counterpart to Solidity's `+` operator.
60      *
61      * Requirements:
62      * - Addition cannot overflow.
63      */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a, "SafeMath: addition overflow");
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting on
73      * overflow (when the result is negative).
74      *
75      * Counterpart to Solidity's `-` operator.
76      *
77      * Requirements:
78      * - Subtraction cannot overflow.
79      */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         return sub(a, b, "SafeMath: subtraction overflow");
82     }
83 
84     /**
85      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
86      * overflow (when the result is negative).
87      *
88      * Counterpart to Solidity's `-` operator.
89      *
90      * Requirements:
91      * - Subtraction cannot overflow.
92      */
93     function sub(
94         uint256 a,
95         uint256 b,
96         string memory errorMessage
97     ) internal pure returns (uint256) {
98         require(b <= a, errorMessage);
99         uint256 c = a - b;
100 
101         return c;
102     }
103 
104     /**
105      * @dev Returns the multiplication of two unsigned integers, reverting on
106      * overflow.
107      *
108      * Counterpart to Solidity's `*` operator.
109      *
110      * Requirements:
111      * - Multiplication cannot overflow.
112      */
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115         // benefit is lost if 'b' is also tested.
116         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
117         if (a == 0) {
118             return 0;
119         }
120 
121         uint256 c = a * b;
122         require(c / a == b, "SafeMath: multiplication overflow");
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers. Reverts on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return div(a, b, "SafeMath: division by zero");
140     }
141 
142     /**
143      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
144      * division by zero. The result is rounded towards zero.
145      *
146      * Counterpart to Solidity's `/` operator. Note: this function uses a
147      * `revert` opcode (which leaves remaining gas untouched) while Solidity
148      * uses an invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      * - The divisor cannot be zero.
152      */
153     function div(
154         uint256 a,
155         uint256 b,
156         string memory errorMessage
157     ) internal pure returns (uint256) {
158         // Solidity only automatically asserts when dividing by 0
159         require(b > 0, errorMessage);
160         uint256 c = a / b;
161         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * Reverts when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
178         return mod(a, b, "SafeMath: modulo by zero");
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
183      * Reverts with custom message when dividing by zero.
184      *
185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
186      * opcode (which leaves remaining gas untouched) while Solidity uses an
187      * invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      * - The divisor cannot be zero.
191      */
192     function mod(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         require(b != 0, errorMessage);
198         return a % b;
199     }
200 }
201 
202 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
203 
204 // SPDX-License-Identifier: MIT
205 
206 pragma solidity ^0.6.0;
207 
208 /**
209  * @dev Interface of the ERC20 standard as defined in the EIP.
210  */
211 interface IERC20 {
212     /**
213      * @dev Returns the amount of tokens in existence.
214      */
215     function totalSupply() external view returns (uint256);
216 
217     /**
218      * @dev Returns the amount of tokens owned by `account`.
219      */
220     function balanceOf(address account) external view returns (uint256);
221 
222     /**
223      * @dev Moves `amount` tokens from the caller's account to `recipient`.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * Emits a {Transfer} event.
228      */
229     function transfer(address recipient, uint256 amount)
230         external
231         returns (bool);
232 
233     /**
234      * @dev Returns the remaining number of tokens that `spender` will be
235      * allowed to spend on behalf of `owner` through {transferFrom}. This is
236      * zero by default.
237      *
238      * This value changes when {approve} or {transferFrom} are called.
239      */
240     function allowance(address owner, address spender)
241         external
242         view
243         returns (uint256);
244 
245     /**
246      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * IMPORTANT: Beware that changing an allowance with this method brings the risk
251      * that someone may use both the old and the new allowance by unfortunate
252      * transaction ordering. One possible solution to mitigate this race
253      * condition is to first reduce the spender's allowance to 0 and set the
254      * desired value afterwards:
255      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256      *
257      * Emits an {Approval} event.
258      */
259     function approve(address spender, uint256 amount) external returns (bool);
260 
261     /**
262      * @dev Moves `amount` tokens from `sender` to `recipient` using the
263      * allowance mechanism. `amount` is then deducted from the caller's
264      * allowance.
265      *
266      * Returns a boolean value indicating whether the operation succeeded.
267      *
268      * Emits a {Transfer} event.
269      */
270     function transferFrom(
271         address sender,
272         address recipient,
273         uint256 amount
274     ) external returns (bool);
275 
276     /**
277      * @dev Emitted when `value` tokens are moved from one account (`from`) to
278      * another (`to`).
279      *
280      * Note that `value` may be zero.
281      */
282     event Transfer(address indexed from, address indexed to, uint256 value);
283 
284     /**
285      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
286      * a call to {approve}. `value` is the new allowance.
287      */
288     event Approval(
289         address indexed owner,
290         address indexed spender,
291         uint256 value
292     );
293 }
294 
295 // File: @openzeppelin/contracts/utils/Address.sol
296 
297 // SPDX-License-Identifier: MIT
298 
299 pragma solidity ^0.6.2;
300 
301 /**
302  * @dev Collection of functions related to the address type
303  */
304 library Address {
305     /**
306      * @dev Returns true if `account` is a contract.
307      *
308      * [IMPORTANT]
309      * ====
310      * It is unsafe to assume that an address for which this function returns
311      * false is an externally-owned account (EOA) and not a contract.
312      *
313      * Among others, `isContract` will return false for the following
314      * types of addresses:
315      *
316      *  - an externally-owned account
317      *  - a contract in construction
318      *  - an address where a contract will be created
319      *  - an address where a contract lived, but was destroyed
320      * ====
321      */
322     function isContract(address account) internal view returns (bool) {
323         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
324         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
325         // for accounts without code, i.e. `keccak256('')`
326         bytes32 codehash;
327 
328             bytes32 accountHash
329          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
330         // solhint-disable-next-line no-inline-assembly
331         assembly {
332             codehash := extcodehash(account)
333         }
334         return (codehash != accountHash && codehash != 0x0);
335     }
336 
337     /**
338      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
339      * `recipient`, forwarding all available gas and reverting on errors.
340      *
341      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
342      * of certain opcodes, possibly making contracts go over the 2300 gas limit
343      * imposed by `transfer`, making them unable to receive funds via
344      * `transfer`. {sendValue} removes this limitation.
345      *
346      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
347      *
348      * IMPORTANT: because control is transferred to `recipient`, care must be
349      * taken to not create reentrancy vulnerabilities. Consider using
350      * {ReentrancyGuard} or the
351      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
352      */
353     function sendValue(address payable recipient, uint256 amount) internal {
354         require(
355             address(this).balance >= amount,
356             "Address: insufficient balance"
357         );
358 
359         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
360         (bool success, ) = recipient.call{value: amount}("");
361         require(
362             success,
363             "Address: unable to send value, recipient may have reverted"
364         );
365     }
366 }
367 
368 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
369 
370 // SPDX-License-Identifier: MIT
371 
372 pragma solidity ^0.6.0;
373 
374 /**
375  * @title SafeERC20
376  * @dev Wrappers around ERC20 operations that throw on failure (when the token
377  * contract returns false). Tokens that return no value (and instead revert or
378  * throw on failure) are also supported, non-reverting calls are assumed to be
379  * successful.
380  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
381  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
382  */
383 library SafeERC20 {
384     using SafeMath for uint256;
385     using Address for address;
386 
387     function safeTransfer(
388         IERC20 token,
389         address to,
390         uint256 value
391     ) internal {
392         _callOptionalReturn(
393             token,
394             abi.encodeWithSelector(token.transfer.selector, to, value)
395         );
396     }
397 
398     function safeTransferFrom(
399         IERC20 token,
400         address from,
401         address to,
402         uint256 value
403     ) internal {
404         _callOptionalReturn(
405             token,
406             abi.encodeWithSelector(
407                 token.transferFrom.selector,
408                 from,
409                 to,
410                 value
411             )
412         );
413     }
414 
415     function safeApprove(
416         IERC20 token,
417         address spender,
418         uint256 value
419     ) internal {
420         // safeApprove should only be called when setting an initial allowance,
421         // or when resetting it to zero. To increase and decrease it, use
422         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
423         // solhint-disable-next-line max-line-length
424         require(
425             (value == 0) || (token.allowance(address(this), spender) == 0),
426             "SafeERC20: approve from non-zero to non-zero allowance"
427         );
428         _callOptionalReturn(
429             token,
430             abi.encodeWithSelector(token.approve.selector, spender, value)
431         );
432     }
433 
434     function safeIncreaseAllowance(
435         IERC20 token,
436         address spender,
437         uint256 value
438     ) internal {
439         uint256 newAllowance = token.allowance(address(this), spender).add(
440             value
441         );
442         _callOptionalReturn(
443             token,
444             abi.encodeWithSelector(
445                 token.approve.selector,
446                 spender,
447                 newAllowance
448             )
449         );
450     }
451 
452     function safeDecreaseAllowance(
453         IERC20 token,
454         address spender,
455         uint256 value
456     ) internal {
457         uint256 newAllowance = token.allowance(address(this), spender).sub(
458             value,
459             "SafeERC20: decreased allowance below zero"
460         );
461         _callOptionalReturn(
462             token,
463             abi.encodeWithSelector(
464                 token.approve.selector,
465                 spender,
466                 newAllowance
467             )
468         );
469     }
470 
471     /**
472      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
473      * on the return value: the return value is optional (but if data is returned, it must not be false).
474      * @param token The token targeted by the call.
475      * @param data The call data (encoded using abi.encode or one of its variants).
476      */
477     function _callOptionalReturn(IERC20 token, bytes memory data) private {
478         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
479         // we're implementing it ourselves.
480 
481         // A Solidity high level call has three parts:
482         //  1. The target address is checked to verify it contains contract code
483         //  2. The call itself is made, and success asserted
484         //  3. The return value is decoded, which in turn checks the size of the returned data.
485         // solhint-disable-next-line max-line-length
486         require(
487             address(token).isContract(),
488             "SafeERC20: call to non-contract"
489         );
490 
491         // solhint-disable-next-line avoid-low-level-calls
492         (bool success, bytes memory returndata) = address(token).call(data);
493         require(success, "SafeERC20: low-level call failed");
494 
495         if (returndata.length > 0) {
496             // Return data is optional
497             // solhint-disable-next-line max-line-length
498             require(
499                 abi.decode(returndata, (bool)),
500                 "SafeERC20: ERC20 operation did not succeed"
501             );
502         }
503     }
504 }
505 
506 // File: @openzeppelin/contracts/GSN/Context.sol
507 
508 // SPDX-License-Identifier: MIT
509 
510 pragma solidity ^0.6.0;
511 
512 /*
513  * @dev Provides information about the current execution context, including the
514  * sender of the transaction and its data. While these are generally available
515  * via msg.sender and msg.data, they should not be accessed in such a direct
516  * manner, since when dealing with GSN meta-transactions the account sending and
517  * paying for execution may not be the actual sender (as far as an application
518  * is concerned).
519  *
520  * This contract is only required for intermediate, library-like contracts.
521  */
522 contract Context {
523     // Empty internal constructor, to prevent people from mistakenly deploying
524     // an instance of this contract, which should be used via inheritance.
525     constructor() internal {}
526 
527     function _msgSender() internal virtual view returns (address payable) {
528         return msg.sender;
529     }
530 
531     function _msgData() internal virtual view returns (bytes memory) {
532         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
533         return msg.data;
534     }
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
538 
539 // SPDX-License-Identifier: MIT
540 
541 pragma solidity ^0.6.0;
542 
543 /**
544  * @dev Implementation of the {IERC20} interface.
545  *
546  * This implementation is agnostic to the way tokens are created. This means
547  * that a supply mechanism has to be added in a derived contract using {_mint}.
548  * For a generic mechanism see {ERC20MinterPauser}.
549  *
550  * TIP: For a detailed writeup see our guide
551  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
552  * to implement supply mechanisms].
553  *
554  * We have followed general OpenZeppelin guidelines: functions revert instead
555  * of returning `false` on failure. This behavior is nonetheless conventional
556  * and does not conflict with the expectations of ERC20 applications.
557  *
558  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
559  * This allows applications to reconstruct the allowance for all accounts just
560  * by listening to said events. Other implementations of the EIP may not emit
561  * these events, as it isn't required by the specification.
562  *
563  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
564  * functions have been added to mitigate the well-known issues around setting
565  * allowances. See {IERC20-approve}.
566  */
567 contract ERC20 is Context, IERC20 {
568     using SafeMath for uint256;
569     using Address for address;
570 
571     mapping(address => uint256) private _balances;
572 
573     mapping(address => mapping(address => uint256)) private _allowances;
574 
575     uint256 private _totalSupply;
576 
577     string private _name;
578     string private _symbol;
579     uint8 private _decimals;
580 
581     /**
582      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
583      * a default value of 18.
584      *
585      * To select a different value for {decimals}, use {_setupDecimals}.
586      *
587      * All three of these values are immutable: they can only be set once during
588      * construction.
589      */
590     constructor(string memory name, string memory symbol) public {
591         _name = name;
592         _symbol = symbol;
593         _decimals = 18;
594     }
595 
596     /**
597      * @dev Returns the name of the token.
598      */
599     function name() public view returns (string memory) {
600         return _name;
601     }
602 
603     /**
604      * @dev Returns the symbol of the token, usually a shorter version of the
605      * name.
606      */
607     function symbol() public view returns (string memory) {
608         return _symbol;
609     }
610 
611     /**
612      * @dev Returns the number of decimals used to get its user representation.
613      * For example, if `decimals` equals `2`, a balance of `505` tokens should
614      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
615      *
616      * Tokens usually opt for a value of 18, imitating the relationship between
617      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
618      * called.
619      *
620      * NOTE: This information is only used for _display_ purposes: it in
621      * no way affects any of the arithmetic of the contract, including
622      * {IERC20-balanceOf} and {IERC20-transfer}.
623      */
624     function decimals() public view returns (uint8) {
625         return _decimals;
626     }
627 
628     /**
629      * @dev See {IERC20-totalSupply}.
630      */
631     function totalSupply() public override view returns (uint256) {
632         return _totalSupply;
633     }
634 
635     /**
636      * @dev See {IERC20-balanceOf}.
637      */
638     function balanceOf(address account)
639         public
640         override
641         view
642         returns (uint256)
643     {
644         return _balances[account];
645     }
646 
647     /**
648      * @dev See {IERC20-transfer}.
649      *
650      * Requirements:
651      *
652      * - `recipient` cannot be the zero address.
653      * - the caller must have a balance of at least `amount`.
654      */
655     function transfer(address recipient, uint256 amount)
656         public
657         virtual
658         override
659         returns (bool)
660     {
661         _transfer(_msgSender(), recipient, amount);
662         return true;
663     }
664 
665     /**
666      * @dev See {IERC20-allowance}.
667      */
668     function allowance(address owner, address spender)
669         public
670         virtual
671         override
672         view
673         returns (uint256)
674     {
675         return _allowances[owner][spender];
676     }
677 
678     /**
679      * @dev See {IERC20-approve}.
680      *
681      * Requirements:
682      *
683      * - `spender` cannot be the zero address.
684      */
685     function approve(address spender, uint256 amount)
686         public
687         virtual
688         override
689         returns (bool)
690     {
691         _approve(_msgSender(), spender, amount);
692         return true;
693     }
694 
695     /**
696      * @dev See {IERC20-transferFrom}.
697      *
698      * Emits an {Approval} event indicating the updated allowance. This is not
699      * required by the EIP. See the note at the beginning of {ERC20};
700      *
701      * Requirements:
702      * - `sender` and `recipient` cannot be the zero address.
703      * - `sender` must have a balance of at least `amount`.
704      * - the caller must have allowance for ``sender``'s tokens of at least
705      * `amount`.
706      */
707     function transferFrom(
708         address sender,
709         address recipient,
710         uint256 amount
711     ) public virtual override returns (bool) {
712         _transfer(sender, recipient, amount);
713         _approve(
714             sender,
715             _msgSender(),
716             _allowances[sender][_msgSender()].sub(
717                 amount,
718                 "ERC20: transfer amount exceeds allowance"
719             )
720         );
721         return true;
722     }
723 
724     /**
725      * @dev Atomically increases the allowance granted to `spender` by the caller.
726      *
727      * This is an alternative to {approve} that can be used as a mitigation for
728      * problems described in {IERC20-approve}.
729      *
730      * Emits an {Approval} event indicating the updated allowance.
731      *
732      * Requirements:
733      *
734      * - `spender` cannot be the zero address.
735      */
736     function increaseAllowance(address spender, uint256 addedValue)
737         public
738         virtual
739         returns (bool)
740     {
741         _approve(
742             _msgSender(),
743             spender,
744             _allowances[_msgSender()][spender].add(addedValue)
745         );
746         return true;
747     }
748 
749     /**
750      * @dev Atomically decreases the allowance granted to `spender` by the caller.
751      *
752      * This is an alternative to {approve} that can be used as a mitigation for
753      * problems described in {IERC20-approve}.
754      *
755      * Emits an {Approval} event indicating the updated allowance.
756      *
757      * Requirements:
758      *
759      * - `spender` cannot be the zero address.
760      * - `spender` must have allowance for the caller of at least
761      * `subtractedValue`.
762      */
763     function decreaseAllowance(address spender, uint256 subtractedValue)
764         public
765         virtual
766         returns (bool)
767     {
768         _approve(
769             _msgSender(),
770             spender,
771             _allowances[_msgSender()][spender].sub(
772                 subtractedValue,
773                 "ERC20: decreased allowance below zero"
774             )
775         );
776         return true;
777     }
778 
779     /**
780      * @dev Moves tokens `amount` from `sender` to `recipient`.
781      *
782      * This is internal function is equivalent to {transfer}, and can be used to
783      * e.g. implement automatic token fees, slashing mechanisms, etc.
784      *
785      * Emits a {Transfer} event.
786      *
787      * Requirements:
788      *
789      * - `sender` cannot be the zero address.
790      * - `recipient` cannot be the zero address.
791      * - `sender` must have a balance of at least `amount`.
792      */
793     function _transfer(
794         address sender,
795         address recipient,
796         uint256 amount
797     ) internal virtual {
798         require(sender != address(0), "ERC20: transfer from the zero address");
799         require(
800             recipient != address(0),
801             "ERC20: transfer to the zero address"
802         );
803 
804         _beforeTokenTransfer(sender, recipient, amount);
805 
806         _balances[sender] = _balances[sender].sub(
807             amount,
808             "ERC20: transfer amount exceeds balance"
809         );
810         _balances[recipient] = _balances[recipient].add(amount);
811         emit Transfer(sender, recipient, amount);
812     }
813 
814     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
815      * the total supply.
816      *
817      * Emits a {Transfer} event with `from` set to the zero address.
818      *
819      * Requirements
820      *
821      * - `to` cannot be the zero address.
822      */
823     function _mint(address account, uint256 amount) internal virtual {
824         require(account != address(0), "ERC20: mint to the zero address");
825 
826         _beforeTokenTransfer(address(0), account, amount);
827 
828         _totalSupply = _totalSupply.add(amount);
829         _balances[account] = _balances[account].add(amount);
830         emit Transfer(address(0), account, amount);
831     }
832 
833     /**
834      * @dev Destroys `amount` tokens from `account`, reducing the
835      * total supply.
836      *
837      * Emits a {Transfer} event with `to` set to the zero address.
838      *
839      * Requirements
840      *
841      * - `account` cannot be the zero address.
842      * - `account` must have at least `amount` tokens.
843      */
844     function _burn(address account, uint256 amount) internal virtual {
845         require(account != address(0), "ERC20: burn from the zero address");
846 
847         _beforeTokenTransfer(account, address(0), amount);
848 
849         _balances[account] = _balances[account].sub(
850             amount,
851             "ERC20: burn amount exceeds balance"
852         );
853         _totalSupply = _totalSupply.sub(amount);
854         emit Transfer(account, address(0), amount);
855     }
856 
857     /**
858      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
859      *
860      * This is internal function is equivalent to `approve`, and can be used to
861      * e.g. set automatic allowances for certain subsystems, etc.
862      *
863      * Emits an {Approval} event.
864      *
865      * Requirements:
866      *
867      * - `owner` cannot be the zero address.
868      * - `spender` cannot be the zero address.
869      */
870     function _approve(
871         address owner,
872         address spender,
873         uint256 amount
874     ) internal virtual {
875         require(owner != address(0), "ERC20: approve from the zero address");
876         require(spender != address(0), "ERC20: approve to the zero address");
877 
878         _allowances[owner][spender] = amount;
879         emit Approval(owner, spender, amount);
880     }
881 
882     /**
883      * @dev Sets {decimals} to a value other than the default one of 18.
884      *
885      * WARNING: This function should only be called from the constructor. Most
886      * applications that interact with token contracts will not expect
887      * {decimals} to ever change, and may work incorrectly if it does.
888      */
889     function _setupDecimals(uint8 decimals_) internal {
890         _decimals = decimals_;
891     }
892 
893     /**
894      * @dev Hook that is called before any transfer of tokens. This includes
895      * minting and burning.
896      *
897      * Calling conditions:
898      *
899      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
900      * will be to transferred to `to`.
901      * - when `from` is zero, `amount` tokens will be minted for `to`.
902      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
903      * - `from` and `to` are never both zero.
904      *
905      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
906      */
907     function _beforeTokenTransfer(
908         address from,
909         address to,
910         uint256 amount
911     ) internal virtual {}
912 }
913 
914 // File: contracts/ERC20Vestable.sol
915 
916 pragma solidity 0.6.5;
917 
918 /**
919  * @notice Vestable ERC20 Token.
920  * One beneficiary can have multiple grants.
921  * Grants for one beneficiary are identified by unique ids from 1.
922  * When some tokens are deposited to a grant, the tokens are transferred from the depositor to the beneficiary.
923  * Tokens deposited to a grant become gradually spendable along with the elapsed time.
924  * One grant has its unique start time and end time.
925  * The vesting of the grant is directly proportionally to the elapsed time since the start time.
926  * At the end time, all the tokens of the grant is finally vested.
927  * When the beneficiary claims the vested tokens, the tokens become spendable.
928  * You can additionally deposit tokens to the already started grants to increase the amount vested.
929  * In such a case, some part of the tokens immediately become vested proportionally to the elapsed time since the start time.
930  */
931 abstract contract ERC20Vestable is ERC20 {
932     using SafeMath for uint256;
933 
934     struct Grant {
935         uint256 amount; // total of deposited tokens to the grant
936         uint256 claimed; // total of claimed vesting of the grant
937         uint128 startTime; // the time when the grant starts
938         uint128 endTime; // the time when the grant ends
939     }
940 
941     // account => Grant[]
942     mapping(address => Grant[]) private grants;
943 
944     // account => amount
945     mapping(address => uint256) private remainingGrants;
946 
947     /**
948      * @notice Sum of not yet claimed grants.
949      * It includes already vested but not claimed grants.
950      */
951     uint256 public totalRemainingGrants;
952 
953     event CreateGrant(
954         address indexed beneficiary,
955         uint256 indexed id,
956         address indexed creator,
957         uint256 endTime
958     );
959     event DepositToGrant(
960         address indexed beneficiary,
961         uint256 indexed id,
962         address indexed depositor,
963         uint256 amount
964     );
965     event ClaimVestedTokens(address beneficiary, uint256 id, uint256 amount);
966 
967     modifier spendable(address account, uint256 amount) {
968         require(
969             balanceOf(account).sub(remainingGrants[account]) >= amount,
970             "transfer amount exceeds spendable balance"
971         );
972         _;
973     }
974 
975     /**
976      * @notice Creates new grant and starts it.
977      * @param beneficiary recipient of vested tokens of the grant.
978      * @param endTime Time at which all the tokens of the grant will be vested.
979      * @return id of the grant.
980      */
981     function createGrant(address beneficiary, uint256 endTime)
982         public
983         returns (uint256)
984     {
985         require(endTime > now, "endTime is before now");
986         Grant memory g = Grant(0, 0, uint128(now), uint128(endTime));
987         address creator = msg.sender;
988         grants[beneficiary].push(g);
989         uint256 id = grants[beneficiary].length;
990         emit CreateGrant(beneficiary, id, creator, endTime);
991         return id;
992     }
993 
994     /**
995      * @notice Deposits tokens to grant.
996      * @param beneficiary recipient of vested tokens of the grant.
997      * @param id id of the grant.
998      * @param amount amount of tokens.
999      */
1000     function depositToGrant(
1001         address beneficiary,
1002         uint256 id,
1003         uint256 amount
1004     ) public {
1005         Grant storage g = _getGrant(beneficiary, id);
1006         address depositor = msg.sender;
1007         _transfer(depositor, beneficiary, amount);
1008         g.amount = g.amount.add(amount);
1009         remainingGrants[beneficiary] = remainingGrants[beneficiary].add(
1010             amount
1011         );
1012         totalRemainingGrants = totalRemainingGrants.add(amount);
1013         emit DepositToGrant(beneficiary, id, depositor, amount);
1014     }
1015 
1016     /**
1017      * @notice Claims spendable vested tokens of the grant which are vested after the last claiming.
1018      * @param beneficiary recipient of vested tokens of the grant.
1019      * @param id id of the grant.
1020      */
1021     function claimVestedTokens(address beneficiary, uint256 id) public {
1022         Grant storage g = _getGrant(beneficiary, id);
1023         uint256 amount = _vestedAmount(g);
1024         require(amount != 0, "vested amount is zero");
1025         uint256 newClaimed = g.claimed.add(amount);
1026         g.claimed = newClaimed;
1027         remainingGrants[beneficiary] = remainingGrants[beneficiary].sub(
1028             amount
1029         );
1030         totalRemainingGrants = totalRemainingGrants.sub(amount);
1031         if (newClaimed == g.amount) {
1032             _deleteGrant(beneficiary, id);
1033         }
1034         emit ClaimVestedTokens(beneficiary, id, amount);
1035     }
1036 
1037     /**
1038      * @notice Returns the last id of grant of `beneficiary`.
1039      * If `beneficiary` does not have any grant, returns `0`.
1040      */
1041     function getLastGrantID(address beneficiary)
1042         public
1043         view
1044         returns (uint256)
1045     {
1046         return grants[beneficiary].length;
1047     }
1048 
1049     /**
1050      * @notice Returns information of grant
1051      * @param beneficiary recipient of vested tokens of the grant.
1052      * @param id id of the grant.
1053      * @return amount is the total of deposited tokens
1054      * @return claimed is the total of already claimed spendable tokens.
1055      * @return  vested is the amount of vested and not claimed tokens.
1056      * @return startTime is the start time of grant.
1057      * @return  endTime is the end time time of grant.
1058      */
1059     function getGrant(address beneficiary, uint256 id)
1060         public
1061         view
1062         returns (
1063             uint256 amount,
1064             uint256 claimed,
1065             uint256 vested,
1066             uint256 startTime,
1067             uint256 endTime
1068         )
1069     {
1070         Grant memory g = _getGrant(beneficiary, id);
1071         amount = g.amount;
1072         claimed = g.claimed;
1073         vested = _vestedAmount(g);
1074         startTime = g.startTime;
1075         endTime = g.endTime;
1076     }
1077 
1078     /**
1079      * @notice Returns sum of not yet claimed tokens of `account`
1080      * It includes already vested but not claimed grants.
1081      */
1082     function remainingGrantOf(address account) public view returns (uint256) {
1083         return remainingGrants[account];
1084     }
1085 
1086     /**
1087      * @dev When `amount` exceeds spendable balance, it reverts.
1088      */
1089     function _transfer(
1090         address from,
1091         address to,
1092         uint256 amount
1093     ) internal virtual override spendable(from, amount) {
1094         super._transfer(from, to, amount);
1095     }
1096 
1097     function _deleteGrant(address beneficiary, uint256 id) private {
1098         delete grants[beneficiary][id - 1];
1099     }
1100 
1101     function _getGrant(address beneficiary, uint256 id)
1102         private
1103         view
1104         returns (Grant storage)
1105     {
1106         require(id != 0, "0 is invalid as id");
1107         id = id - 1;
1108         require(id < grants[beneficiary].length, "grant does not exist");
1109         Grant storage g = grants[beneficiary][id];
1110         // check if the grant is deleted
1111         require(
1112             g.endTime != 0,
1113             "cannot get grant which is already claimed entirely"
1114         );
1115         return g;
1116     }
1117 
1118     /**
1119      * @dev Returns tokens that were vested after the last claiming.
1120      */
1121     function _vestedAmount(Grant memory g) private view returns (uint256) {
1122         uint256 n = now;
1123         if (g.endTime > n) {
1124             uint256 elapsed = n - g.startTime;
1125             uint256 duration = g.endTime - g.startTime;
1126             return g.amount.mul(elapsed).div(duration).sub(g.claimed);
1127         }
1128         return g.amount.sub(g.claimed);
1129     }
1130 }
1131 
1132 // File: @openzeppelin/contracts/utils/Arrays.sol
1133 
1134 // SPDX-License-Identifier: MIT
1135 
1136 pragma solidity ^0.6.0;
1137 
1138 /**
1139  * @dev Collection of functions related to array types.
1140  */
1141 library Arrays {
1142     /**
1143      * @dev Searches a sorted `array` and returns the first index that contains
1144      * a value greater or equal to `element`. If no such index exists (i.e. all
1145      * values in the array are strictly less than `element`), the array length is
1146      * returned. Time complexity O(log n).
1147      *
1148      * `array` is expected to be sorted in ascending order, and to contain no
1149      * repeated elements.
1150      */
1151     function findUpperBound(uint256[] storage array, uint256 element)
1152         internal
1153         view
1154         returns (uint256)
1155     {
1156         if (array.length == 0) {
1157             return 0;
1158         }
1159 
1160         uint256 low = 0;
1161         uint256 high = array.length;
1162 
1163         while (low < high) {
1164             uint256 mid = Math.average(low, high);
1165 
1166             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
1167             // because Math.average rounds down (it does integer division with truncation).
1168             if (array[mid] > element) {
1169                 high = mid;
1170             } else {
1171                 low = mid + 1;
1172             }
1173         }
1174 
1175         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
1176         if (low > 0 && array[low - 1] == element) {
1177             return low - 1;
1178         } else {
1179             return low;
1180         }
1181     }
1182 }
1183 
1184 // File: @openzeppelin/contracts/utils/Counters.sol
1185 
1186 // SPDX-License-Identifier: MIT
1187 
1188 pragma solidity ^0.6.0;
1189 
1190 /**
1191  * @title Counters
1192  * @author Matt Condon (@shrugs)
1193  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1194  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1195  *
1196  * Include with `using Counters for Counters.Counter;`
1197  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1198  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1199  * directly accessed.
1200  */
1201 library Counters {
1202     using SafeMath for uint256;
1203 
1204     struct Counter {
1205         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1206         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1207         // this feature: see https://github.com/ethereum/solidity/issues/4637
1208         uint256 _value; // default: 0
1209     }
1210 
1211     function current(Counter storage counter) internal view returns (uint256) {
1212         return counter._value;
1213     }
1214 
1215     function increment(Counter storage counter) internal {
1216         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1217         counter._value += 1;
1218     }
1219 
1220     function decrement(Counter storage counter) internal {
1221         counter._value = counter._value.sub(1);
1222     }
1223 }
1224 
1225 // File: @openzeppelin/contracts/token/ERC20/ERC20Snapshot.sol
1226 
1227 // SPDX-License-Identifier: MIT
1228 
1229 pragma solidity ^0.6.0;
1230 
1231 /**
1232  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1233  * total supply at the time are recorded for later access.
1234  *
1235  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1236  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1237  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1238  * used to create an efficient ERC20 forking mechanism.
1239  *
1240  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1241  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1242  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1243  * and the account address.
1244  *
1245  * ==== Gas Costs
1246  *
1247  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1248  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1249  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1250  *
1251  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1252  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1253  * transfers will have normal cost until the next snapshot, and so on.
1254  */
1255 abstract contract ERC20Snapshot is ERC20 {
1256     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1257     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1258 
1259     using SafeMath for uint256;
1260     using Arrays for uint256[];
1261     using Counters for Counters.Counter;
1262 
1263     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1264     // Snapshot struct, but that would impede usage of functions that work on an array.
1265     struct Snapshots {
1266         uint256[] ids;
1267         uint256[] values;
1268     }
1269 
1270     mapping(address => Snapshots) private _accountBalanceSnapshots;
1271     Snapshots private _totalSupplySnapshots;
1272 
1273     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1274     Counters.Counter private _currentSnapshotId;
1275 
1276     /**
1277      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1278      */
1279     event Snapshot(uint256 id);
1280 
1281     /**
1282      * @dev Creates a new snapshot and returns its snapshot id.
1283      *
1284      * Emits a {Snapshot} event that contains the same id.
1285      *
1286      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1287      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1288      *
1289      * [WARNING]
1290      * ====
1291      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1292      * you must consider that it can potentially be used by attackers in two ways.
1293      *
1294      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1295      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1296      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1297      * section above.
1298      *
1299      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1300      * ====
1301      */
1302     function _snapshot() internal virtual returns (uint256) {
1303         _currentSnapshotId.increment();
1304 
1305         uint256 currentId = _currentSnapshotId.current();
1306         emit Snapshot(currentId);
1307         return currentId;
1308     }
1309 
1310     /**
1311      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1312      */
1313     function balanceOfAt(address account, uint256 snapshotId)
1314         public
1315         view
1316         returns (uint256)
1317     {
1318         (bool snapshotted, uint256 value) = _valueAt(
1319             snapshotId,
1320             _accountBalanceSnapshots[account]
1321         );
1322 
1323         return snapshotted ? value : balanceOf(account);
1324     }
1325 
1326     /**
1327      * @dev Retrieves the total supply at the time `snapshotId` was created.
1328      */
1329     function totalSupplyAt(uint256 snapshotId) public view returns (uint256) {
1330         (bool snapshotted, uint256 value) = _valueAt(
1331             snapshotId,
1332             _totalSupplySnapshots
1333         );
1334 
1335         return snapshotted ? value : totalSupply();
1336     }
1337 
1338     // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
1339     // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
1340     // The same is true for the total supply and _mint and _burn.
1341     function _transfer(
1342         address from,
1343         address to,
1344         uint256 value
1345     ) internal virtual override {
1346         _updateAccountSnapshot(from);
1347         _updateAccountSnapshot(to);
1348 
1349         super._transfer(from, to, value);
1350     }
1351 
1352     function _mint(address account, uint256 value) internal virtual override {
1353         _updateAccountSnapshot(account);
1354         _updateTotalSupplySnapshot();
1355 
1356         super._mint(account, value);
1357     }
1358 
1359     function _burn(address account, uint256 value) internal virtual override {
1360         _updateAccountSnapshot(account);
1361         _updateTotalSupplySnapshot();
1362 
1363         super._burn(account, value);
1364     }
1365 
1366     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
1367         private
1368         view
1369         returns (bool, uint256)
1370     {
1371         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1372         // solhint-disable-next-line max-line-length
1373         require(
1374             snapshotId <= _currentSnapshotId.current(),
1375             "ERC20Snapshot: nonexistent id"
1376         );
1377 
1378         // When a valid snapshot is queried, there are three possibilities:
1379         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1380         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1381         //  to this id is the current one.
1382         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1383         //  requested id, and its value is the one to return.
1384         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1385         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1386         //  larger than the requested one.
1387         //
1388         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1389         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1390         // exactly this.
1391 
1392         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1393 
1394         if (index == snapshots.ids.length) {
1395             return (false, 0);
1396         } else {
1397             return (true, snapshots.values[index]);
1398         }
1399     }
1400 
1401     function _updateAccountSnapshot(address account) private {
1402         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1403     }
1404 
1405     function _updateTotalSupplySnapshot() private {
1406         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1407     }
1408 
1409     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue)
1410         private
1411     {
1412         uint256 currentId = _currentSnapshotId.current();
1413         if (_lastSnapshotId(snapshots.ids) < currentId) {
1414             snapshots.ids.push(currentId);
1415             snapshots.values.push(currentValue);
1416         }
1417     }
1418 
1419     function _lastSnapshotId(uint256[] storage ids)
1420         private
1421         view
1422         returns (uint256)
1423     {
1424         if (ids.length == 0) {
1425             return 0;
1426         } else {
1427             return ids[ids.length - 1];
1428         }
1429     }
1430 }
1431 
1432 // File: contracts/ERC20RegularlyRecord.sol
1433 
1434 pragma solidity 0.6.5;
1435 
1436 /**
1437  * @dev This contract extends an ERC20Snapshot token, which extends ERC20 and has a snapshot mechanism.
1438  * When a snapshot is created, the balances and the total supply (state) at the time are recorded for later accesses.
1439  *
1440  * This contract records states at regular intervals.
1441  * When the first transferring, minting, or burning on the term occurring, snapshot is taken to record the state at the end of the previous term.
1442  * If no action occurs on the next term of one term, state at the end of the term is not snapshotted, but the state is same as the one at the end of next term of it.
1443  * So, in that case, accessing to the state at the end of the term is internally solved by referencing to the snapshot taken after it has ended.
1444  * If no action occurs after one term, state at the end of the term is same as the current state and Accessing to the state is solved by referencing the current state.
1445  */
1446 abstract contract ERC20RegularlyRecord is ERC20Snapshot {
1447     using SafeMath for uint256;
1448 
1449     /**
1450      * @dev Interval of records in seconds.
1451      */
1452     uint256 public immutable interval;
1453 
1454     /**
1455      * @dev Starting Time of the first term.
1456      */
1457     uint256 public immutable initialTime;
1458 
1459     // term => snapshotId
1460     mapping(uint256 => uint256) private snapshotsOfTermEnd;
1461 
1462     modifier termValidation(uint256 _term) {
1463         require(_term != 0, "0 is invalid value as term");
1464         _;
1465     }
1466 
1467     /**
1468      * @param _interval Interval of records in seconds.
1469      * The first term starts when this contract is constructed.
1470      */
1471     constructor(uint256 _interval) public {
1472         interval = _interval;
1473         initialTime = now;
1474     }
1475 
1476     /**
1477      * @notice Returns term of `time`.
1478      * The first term is 1, After one interval, the term becomes 2.
1479      * Term of time T is calculated by the following formula
1480      * (T - initialTime)/interval + 1
1481      */
1482     function termOfTime(uint256 time) public view returns (uint256) {
1483         return time.sub(initialTime, "time is invalid").div(interval).add(1);
1484     }
1485 
1486     /**
1487      * @notice Returns the current term.
1488      */
1489     function currentTerm() public view returns (uint256) {
1490         return termOfTime(now);
1491     }
1492 
1493     /**
1494      * @notice Returns when `term` starts.
1495      * @param term > 0
1496      */
1497     function startOfTerm(uint256 term)
1498         public
1499         view
1500         termValidation(term)
1501         returns (uint256)
1502     {
1503         return initialTime.add(term.sub(1).mul(interval));
1504     }
1505 
1506     /**
1507      * @notice Returns when `term` ends.
1508      * @param term > 0
1509      */
1510     function endOfTerm(uint256 term)
1511         public
1512         view
1513         termValidation(term)
1514         returns (uint256)
1515     {
1516         return initialTime.add(term.mul(interval)).sub(1);
1517     }
1518 
1519     /**
1520      * @notice Retrieves the balance of `account` at the end of the `term`
1521      */
1522     function balanceOfAtTermEnd(address account, uint256 term)
1523         public
1524         view
1525         termValidation(term)
1526         returns (uint256)
1527     {
1528         uint256 _currentTerm = currentTerm();
1529         for (uint256 i = term; i < _currentTerm; i++) {
1530             if (_isSnapshottedOnTermEnd(i)) {
1531                 return balanceOfAt(account, snapshotsOfTermEnd[i]);
1532             }
1533         }
1534         return balanceOf(account);
1535     }
1536 
1537     /**
1538      * @notice Retrieves the total supply at the end of the `term`
1539      */
1540     function totalSupplyAtTermEnd(uint256 term)
1541         public
1542         view
1543         termValidation(term)
1544         returns (uint256)
1545     {
1546         uint256 _currentTerm = currentTerm();
1547         for (uint256 i = term; i < _currentTerm; i++) {
1548             if (_isSnapshottedOnTermEnd(i)) {
1549                 return totalSupplyAt(snapshotsOfTermEnd[i]);
1550             }
1551         }
1552         return totalSupply();
1553     }
1554 
1555     function _transfer(
1556         address from,
1557         address to,
1558         uint256 value
1559     ) internal virtual override {
1560         _snapshotOnTermEnd();
1561         super._transfer(from, to, value);
1562     }
1563 
1564     function _mint(address account, uint256 value) internal virtual override {
1565         _snapshotOnTermEnd();
1566         super._mint(account, value);
1567     }
1568 
1569     function _burn(address account, uint256 value) internal virtual override {
1570         _snapshotOnTermEnd();
1571         super._burn(account, value);
1572     }
1573 
1574     /**
1575      * @dev Takes a snapshot before the first transferring, minting or burning on the term.
1576      * If snapshot is not taken after the last term ended, take a snapshot to record states at the end of the last term.
1577      */
1578     function _snapshotOnTermEnd() private {
1579         uint256 _currentTerm = currentTerm();
1580         if (_currentTerm > 1 && !_isSnapshottedOnTermEnd(_currentTerm - 1)) {
1581             snapshotsOfTermEnd[_currentTerm - 1] = _snapshot();
1582         }
1583     }
1584 
1585     /**
1586      * @dev Returns `true` if snapshot was already taken to record states at the end of the `term`.
1587      * If it's not, snapshotOfTermEnd[`term`] is 0 as the default value.
1588      */
1589     function _isSnapshottedOnTermEnd(uint256 term)
1590         private
1591         view
1592         returns (bool)
1593     {
1594         return snapshotsOfTermEnd[term] != 0;
1595     }
1596 }
1597 
1598 // File: contracts/LienToken.sol
1599 
1600 pragma solidity 0.6.5;
1601 
1602 /**
1603  * @notice ERC20 Token with dividend mechanism.
1604  * It accepts ether and ERC20 tokens as assets for profit, and distributes them to the token holders pro rata to their shares.
1605  * Total profit and dividends of each holders are settled regularly at the pre specified interval.
1606  * Even after moving tokens, the holders keep the right to receive already settled dividends because this contract records states(the balances of accounts and the total supply of token) at the moment of settlement.
1607  * There is a pre specified length of period for right to receive dividends.
1608  * When the period expires, unreceived dividends are carried over to a new term and distributed to the holders on the new term.
1609  * It also have token vesting mechanism.
1610  * The beneficiary of the grant cannot transfer the granted token before vested, but can earn dividends for the granted tokens.
1611  */
1612 contract LienToken is ERC20RegularlyRecord, ERC20Vestable {
1613     using SafeERC20 for IERC20;
1614     using SafeMath for uint256;
1615 
1616     address public constant ETH_ADDRESS = address(0);
1617 
1618     // Profit and paid balances of a certain asset.
1619     struct Balances {
1620         uint256 profit;
1621         uint256 paid;
1622     }
1623 
1624     // Expiration term number for the right to receive dividends.
1625     uint256 public immutable expiration;
1626 
1627     // account address => token => term
1628     mapping(address => mapping(address => uint256)) public lastTokenReceived;
1629 
1630     // term => token => balances
1631     mapping(uint256 => mapping(address => Balances)) private balancesMap;
1632 
1633     event SettleProfit(
1634         address indexed token,
1635         uint256 indexed term,
1636         uint256 amount
1637     );
1638     event ReceiveDividend(
1639         address indexed token,
1640         address indexed recipient,
1641         uint256 amount
1642     );
1643 
1644     /**
1645      * @param _interval Length of a term in second
1646      * @param _expiration Number of term for expiration
1647      * @param totalSupply Total supply of this token
1648      **/
1649     constructor(
1650         uint256 _interval,
1651         uint256 _expiration,
1652         uint256 totalSupply
1653     ) public ERC20RegularlyRecord(_interval) ERC20("lien", "LIEN") {
1654         _setupDecimals(8);
1655         ERC20._mint(msg.sender, totalSupply);
1656         expiration = _expiration;
1657     }
1658 
1659     // solhint-disable-next-line no-empty-blocks
1660     receive() external payable {}
1661 
1662     /**
1663      * @notice Recognizes the unsettled profit in the form of token occurred in the current term.
1664      * Carried over dividends are also counted.
1665      */
1666     function settleProfit(address token) external {
1667         uint256 amount = unsettledProfit(token);
1668         uint256 currentTerm = currentTerm();
1669         Balances storage b = balancesMap[currentTerm][token];
1670         uint256 newProfit = b.profit.add(amount);
1671         b.profit = newProfit;
1672         emit SettleProfit(token, currentTerm, newProfit);
1673     }
1674 
1675     /**
1676      * @notice Receives all the valid dividends in the form of token.
1677      * @param recipient recipient of dividends.
1678      */
1679     function receiveDividend(address token, address recipient) external {
1680         uint256 i;
1681         uint256 total;
1682         uint256 divAt;
1683         uint256 currentTerm = currentTerm();
1684         for (
1685             i = Math.max(
1686                 _oldestValidTerm(),
1687                 lastTokenReceived[recipient][token]
1688             );
1689             i < currentTerm;
1690             i++
1691         ) {
1692             divAt = dividendAt(token, recipient, i);
1693             balancesMap[i][token].paid = balancesMap[i][token].paid.add(divAt);
1694             total = total.add(divAt);
1695         }
1696         lastTokenReceived[recipient][token] = i;
1697         emit ReceiveDividend(token, recipient, total);
1698         if (token == ETH_ADDRESS) {
1699             (bool success, ) = recipient.call{value: total}("");
1700             require(success, "transfer failed");
1701         } else {
1702             IERC20(token).safeTransfer(recipient, total);
1703         }
1704     }
1705 
1706     /**
1707      * @notice Returns settled profit in the form of `token` on `term`.
1708      */
1709     function profitAt(address token, uint256 term)
1710         public
1711         view
1712         returns (uint256)
1713     {
1714         return balancesMap[term][token].profit;
1715     }
1716 
1717     /**
1718      * @notice Returns the balance of already-paid dividends in `token` on `term`.
1719      */
1720     function paidAt(address token, uint256 term)
1721         public
1722         view
1723         returns (uint256)
1724     {
1725         return balancesMap[term][token].paid;
1726     }
1727 
1728     /**
1729      * @notice Returns the balance of dividends in `token` on `term` to `account`.
1730      */
1731     function dividendAt(
1732         address token,
1733         address account,
1734         uint256 term
1735     ) public view returns (uint256) {
1736         return
1737             _dividend(
1738                 profitAt(token, term),
1739                 balanceOfAtTermEnd(account, term),
1740                 totalSupply()
1741             );
1742     }
1743 
1744     /**
1745      * @notice Returns the balance of unrecognized profit in `token`.
1746      * It includes carried over dividends.
1747      */
1748     function unsettledProfit(address token) public view returns (uint256) {
1749         uint256 remain;
1750         uint256 tokenBalance;
1751         uint256 currentTerm = currentTerm();
1752         for (uint256 i = _oldestValidTerm(); i <= currentTerm; i++) {
1753             Balances memory b = balancesMap[i][token];
1754             uint256 remainAt = b.profit.sub(b.paid);
1755             remain = remain.add(remainAt);
1756         }
1757         if (token == ETH_ADDRESS) {
1758             tokenBalance = address(this).balance;
1759         } else {
1760             tokenBalance = IERC20(token).balanceOf(address(this));
1761         }
1762         return tokenBalance.sub(remain);
1763     }
1764 
1765     /**
1766      * @notice Returns the balance of valid dividends in `token`.
1767      * @param recipient recipient of dividend.
1768      */
1769     function unreceivedDividend(address token, address recipient)
1770         external
1771         view
1772         returns (uint256)
1773     {
1774         uint256 i;
1775         uint256 total;
1776         uint256 divAt;
1777         uint256 currentTerm = currentTerm();
1778         for (
1779             i = Math.max(
1780                 _oldestValidTerm(),
1781                 lastTokenReceived[recipient][token]
1782             );
1783             i < currentTerm;
1784             i++
1785         ) {
1786             divAt = dividendAt(token, recipient, i);
1787             total = total.add(divAt);
1788         }
1789         return total;
1790     }
1791 
1792     /**
1793      * @dev It Overrides ERCVestable and ERC20RegularlyRecord.
1794      * To record states regularly, it calls `transfer` of ERC20RegularlyRecord.
1795      * To restrict value to be less than max spendable balance, it uses `spendable` modifier of ERC20Vestable.
1796      */
1797     function _transfer(
1798         address from,
1799         address to,
1800         uint256 value
1801     )
1802         internal
1803         virtual
1804         override(ERC20Vestable, ERC20RegularlyRecord)
1805         spendable(from, value)
1806     {
1807         ERC20RegularlyRecord._transfer(from, to, value);
1808     }
1809 
1810     /**
1811      * @dev It overrides ERC20Vestable and ERC20RegularlyRecord.
1812      * Both of these base class define `_burn`, so this contract must override `_burn` expressly.
1813      */
1814     function _burn(address account, uint256 value)
1815         internal
1816         virtual
1817         override(ERC20, ERC20RegularlyRecord)
1818     {
1819         ERC20RegularlyRecord._burn(account, value);
1820     }
1821 
1822     /**
1823      * @dev It overrides ERC20Vestable and ERC20RegularlyRecord.
1824      * Both of these base class define `_mint`, so this contract must override `_mint` expressly.
1825      */
1826     function _mint(address account, uint256 value)
1827         internal
1828         virtual
1829         override(ERC20, ERC20RegularlyRecord)
1830     {
1831         ERC20RegularlyRecord._mint(account, value);
1832     }
1833 
1834     function _oldestValidTerm() private view returns (uint256) {
1835         uint256 currentTerm = currentTerm();
1836         if (currentTerm <= expiration) {
1837             return 1;
1838         }
1839         return currentTerm.sub(expiration);
1840     }
1841 
1842     /**
1843      * @dev Returns the value of dividend pro rata share of token.
1844      * dividend = profit * balance / totalSupply
1845      */
1846     function _dividend(
1847         uint256 profit,
1848         uint256 balance,
1849         uint256 totalSupply
1850     ) private pure returns (uint256) {
1851         return profit.mul(balance).div(totalSupply);
1852     }
1853 }