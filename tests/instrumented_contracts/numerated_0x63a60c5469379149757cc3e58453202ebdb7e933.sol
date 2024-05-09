1 /**
2  * SPDX-License-Identifier: MIT
3  */
4 pragma solidity 0.8.21;
5 
6 library SafeMath {
7     /**
8      * @dev Returns the addition of two unsigned integers, with an overflow flag.
9      *
10      * _Available since v3.4._
11      */
12     function tryAdd(
13         uint256 a,
14         uint256 b
15     ) internal pure returns (bool, uint256) {
16         unchecked {
17             uint256 c = a + b;
18             if (c < a) return (false, 0);
19             return (true, c);
20         }
21     }
22 
23     /**
24      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
25      *
26      * _Available since v3.4._
27      */
28     function trySub(
29         uint256 a,
30         uint256 b
31     ) internal pure returns (bool, uint256) {
32         unchecked {
33             if (b > a) return (false, 0);
34             return (true, a - b);
35         }
36     }
37 
38     /**
39      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
40      *
41      * _Available since v3.4._
42      */
43     function tryMul(
44         uint256 a,
45         uint256 b
46     ) internal pure returns (bool, uint256) {
47         unchecked {
48             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49             // benefit is lost if 'b' is also tested.
50             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51             if (a == 0) return (true, 0);
52             uint256 c = a * b;
53             if (c / a != b) return (false, 0);
54             return (true, c);
55         }
56     }
57 
58     /**
59      * @dev Returns the division of two unsigned integers, with a division by zero flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryDiv(
64         uint256 a,
65         uint256 b
66     ) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(
79         uint256 a,
80         uint256 b
81     ) internal pure returns (bool, uint256) {
82         unchecked {
83             if (b == 0) return (false, 0);
84             return (true, a % b);
85         }
86     }
87 
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      *
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         return a + b;
100     }
101 
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      *
110      * - Subtraction cannot overflow.
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a - b;
114     }
115 
116     /**
117      * @dev Returns the multiplication of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `*` operator.
121      *
122      * Requirements:
123      *
124      * - Multiplication cannot overflow.
125      */
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a * b;
128     }
129 
130     /**
131      * @dev Returns the integer division of two unsigned integers, reverting on
132      * division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator.
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a / b;
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         return a % b;
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * CAUTION: This function is deprecated because it requires allocating memory for the error
165      * message unnecessarily. For custom revert reasons use {trySub}.
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(
174         uint256 a,
175         uint256 b,
176         string memory errorMessage
177     ) internal pure returns (uint256) {
178         unchecked {
179             require(b <= a, errorMessage);
180             return a - b;
181         }
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(
197         uint256 a,
198         uint256 b,
199         string memory errorMessage
200     ) internal pure returns (uint256) {
201         unchecked {
202             require(b > 0, errorMessage);
203             return a / b;
204         }
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * reverting with custom message when dividing by zero.
210      *
211      * CAUTION: This function is deprecated because it requires allocating memory for the error
212      * message unnecessarily. For custom revert reasons use {tryMod}.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         unchecked {
228             require(b > 0, errorMessage);
229             return a % b;
230         }
231     }
232 }
233 
234 interface IERC20 {
235     /**
236      * @dev Emitted when `value` tokens are moved from one account (`from`) to
237      * another (`to`).
238      *
239      * Note that `value` may be zero.
240      */
241     event Transfer(address indexed from, address indexed to, uint256 value);
242 
243     /**
244      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
245      * a call to {approve}. `value` is the new allowance.
246      */
247     event Approval(address indexed owner, address indexed spender, uint256 value);
248 
249     /**
250      * @dev Returns the value of tokens in existence.
251      */
252     function totalSupply() external view returns (uint256);
253 
254     /**
255      * @dev Returns the value of tokens owned by `account`.
256      */
257     function balanceOf(address account) external view returns (uint256);
258 
259     /**
260      * @dev Moves a `value` amount of tokens from the caller's account to `to`.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * Emits a {Transfer} event.
265      */
266     function transfer(address to, uint256 value) external returns (bool);
267 
268     /**
269      * @dev Returns the remaining number of tokens that `spender` will be
270      * allowed to spend on behalf of `owner` through {transferFrom}. This is
271      * zero by default.
272      *
273      * This value changes when {approve} or {transferFrom} are called.
274      */
275     function allowance(address owner, address spender) external view returns (uint256);
276 
277     /**
278      * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
279      * caller's tokens.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * IMPORTANT: Beware that changing an allowance with this method brings the risk
284      * that someone may use both the old and the new allowance by unfortunate
285      * transaction ordering. One possible solution to mitigate this race
286      * condition is to first reduce the spender's allowance to 0 and set the
287      * desired value afterwards:
288      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
289      *
290      * Emits an {Approval} event.
291      */
292     function approve(address spender, uint256 value) external returns (bool);
293 
294     /**
295      * @dev Moves a `value` amount of tokens from `from` to `to` using the
296      * allowance mechanism. `value` is then deducted from the caller's
297      * allowance.
298      *
299      * Returns a boolean value indicating whether the operation succeeded.
300      *
301      * Emits a {Transfer} event.
302      */
303     function transferFrom(address from, address to, uint256 value) external returns (bool);
304 }
305 
306 interface IERC20Metadata is IERC20 {
307     /**
308      * @dev Returns the name of the token.
309      */
310     function name() external view returns (string memory);
311 
312     /**
313      * @dev Returns the symbol of the token.
314      */
315     function symbol() external view returns (string memory);
316 
317     /**
318      * @dev Returns the decimals places of the token.
319      */
320     function decimals() external view returns (uint8);
321 }
322 
323 abstract contract Context {
324     function _msgSender() internal view virtual returns (address) {
325         return msg.sender;
326     }
327 
328     function _msgData() internal view virtual returns (bytes calldata) {
329         return msg.data;
330     }
331 }
332 
333 interface IERC20Errors {
334     /**
335      * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
336      * @param sender Address whose tokens are being transferred.
337      * @param balance Current balance for the interacting account.
338      * @param needed Minimum amount required to perform a transfer.
339      */
340     error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
341 
342     /**
343      * @dev Indicates a failure with the token `sender`. Used in transfers.
344      * @param sender Address whose tokens are being transferred.
345      */
346     error ERC20InvalidSender(address sender);
347 
348     /**
349      * @dev Indicates a failure with the token `receiver`. Used in transfers.
350      * @param receiver Address to which tokens are being transferred.
351      */
352     error ERC20InvalidReceiver(address receiver);
353 
354     /**
355      * @dev Indicates a failure with the `spender`’s `allowance`. Used in transfers.
356      * @param spender Address that may be allowed to operate on tokens without being their owner.
357      * @param allowance Amount of tokens a `spender` is allowed to operate with.
358      * @param needed Minimum amount required to perform a transfer.
359      */
360     error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
361 
362     /**
363      * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
364      * @param approver Address initiating an approval operation.
365      */
366     error ERC20InvalidApprover(address approver);
367 
368     /**
369      * @dev Indicates a failure with the `spender` to be approved. Used in approvals.
370      * @param spender Address that may be allowed to operate on tokens without being their owner.
371      */
372     error ERC20InvalidSpender(address spender);
373 }
374 
375 abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
376     mapping(address account => uint256) private _balances;
377 
378     mapping(address account => mapping(address spender => uint256)) private _allowances;
379 
380     uint256 private _totalSupply;
381 
382     string private _name;
383     string private _symbol;
384 
385     /**
386      * @dev Indicates a failed `decreaseAllowance` request.
387      */
388     error ERC20FailedDecreaseAllowance(address spender, uint256 currentAllowance, uint256 requestedDecrease);
389 
390     /**
391      * @dev Sets the values for {name} and {symbol}.
392      *
393      * All two of these values are immutable: they can only be set once during
394      * construction.
395      */
396     constructor(string memory name_, string memory symbol_) {
397         _name = name_;
398         _symbol = symbol_;
399     }
400 
401     /**
402      * @dev Returns the name of the token.
403      */
404     function name() public view virtual returns (string memory) {
405         return _name;
406     }
407 
408     /**
409      * @dev Returns the symbol of the token, usually a shorter version of the
410      * name.
411      */
412     function symbol() public view virtual returns (string memory) {
413         return _symbol;
414     }
415 
416     /**
417      * @dev Returns the number of decimals used to get its user representation.
418      * For example, if `decimals` equals `2`, a balance of `505` tokens should
419      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
420      *
421      * Tokens usually opt for a value of 18, imitating the relationship between
422      * Ether and Wei. This is the default value returned by this function, unless
423      * it's overridden.
424      *
425      * NOTE: This information is only used for _display_ purposes: it in
426      * no way affects any of the arithmetic of the contract, including
427      * {IERC20-balanceOf} and {IERC20-transfer}.
428      */
429     function decimals() public view virtual returns (uint8) {
430         return 18;
431     }
432 
433     /**
434      * @dev See {IERC20-totalSupply}.
435      */
436     function totalSupply() public view virtual returns (uint256) {
437         return _totalSupply;
438     }
439 
440     /**
441      * @dev See {IERC20-balanceOf}.
442      */
443     function balanceOf(address account) public view virtual returns (uint256) {
444         return _balances[account];
445     }
446 
447     /**
448      * @dev See {IERC20-transfer}.
449      *
450      * Requirements:
451      *
452      * - `to` cannot be the zero address.
453      * - the caller must have a balance of at least `value`.
454      */
455     function transfer(address to, uint256 value) public virtual returns (bool) {
456         address owner = _msgSender();
457         _transfer(owner, to, value);
458         return true;
459     }
460 
461     /**
462      * @dev See {IERC20-allowance}.
463      */
464     function allowance(address owner, address spender) public view virtual returns (uint256) {
465         return _allowances[owner][spender];
466     }
467 
468     /**
469      * @dev See {IERC20-approve}.
470      *
471      * NOTE: If `value` is the maximum `uint256`, the allowance is not updated on
472      * `transferFrom`. This is semantically equivalent to an infinite approval.
473      *
474      * Requirements:
475      *
476      * - `spender` cannot be the zero address.
477      */
478     function approve(address spender, uint256 value) public virtual returns (bool) {
479         address owner = _msgSender();
480         _approve(owner, spender, value);
481         return true;
482     }
483 
484     /**
485      * @dev See {IERC20-transferFrom}.
486      *
487      * Emits an {Approval} event indicating the updated allowance. This is not
488      * required by the EIP. See the note at the beginning of {ERC20}.
489      *
490      * NOTE: Does not update the allowance if the current allowance
491      * is the maximum `uint256`.
492      *
493      * Requirements:
494      *
495      * - `from` and `to` cannot be the zero address.
496      * - `from` must have a balance of at least `value`.
497      * - the caller must have allowance for ``from``'s tokens of at least
498      * `value`.
499      */
500     function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
501         address spender = _msgSender();
502         _spendAllowance(from, spender, value);
503         _transfer(from, to, value);
504         return true;
505     }
506 
507     /**
508      * @dev Atomically increases the allowance granted to `spender` by the caller.
509      *
510      * This is an alternative to {approve} that can be used as a mitigation for
511      * problems described in {IERC20-approve}.
512      *
513      * Emits an {Approval} event indicating the updated allowance.
514      *
515      * Requirements:
516      *
517      * - `spender` cannot be the zero address.
518      */
519     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
520         address owner = _msgSender();
521         _approve(owner, spender, allowance(owner, spender) + addedValue);
522         return true;
523     }
524 
525     /**
526      * @dev Atomically decreases the allowance granted to `spender` by the caller.
527      *
528      * This is an alternative to {approve} that can be used as a mitigation for
529      * problems described in {IERC20-approve}.
530      *
531      * Emits an {Approval} event indicating the updated allowance.
532      *
533      * Requirements:
534      *
535      * - `spender` cannot be the zero address.
536      * - `spender` must have allowance for the caller of at least
537      * `requestedDecrease`.
538      *
539      * NOTE: Although this function is designed to avoid double spending with {approval},
540      * it can still be frontrunned, preventing any attempt of allowance reduction.
541      */
542     function decreaseAllowance(address spender, uint256 requestedDecrease) public virtual returns (bool) {
543         address owner = _msgSender();
544         uint256 currentAllowance = allowance(owner, spender);
545         if (currentAllowance < requestedDecrease) {
546             revert ERC20FailedDecreaseAllowance(spender, currentAllowance, requestedDecrease);
547         }
548         unchecked {
549             _approve(owner, spender, currentAllowance - requestedDecrease);
550         }
551 
552         return true;
553     }
554 
555     /**
556      * @dev Moves a `value` amount of tokens from `from` to `to`.
557      *
558      * This internal function is equivalent to {transfer}, and can be used to
559      * e.g. implement automatic token fees, slashing mechanisms, etc.
560      *
561      * Emits a {Transfer} event.
562      *
563      * NOTE: This function is not virtual, {_update} should be overridden instead.
564      */
565     function _transfer(address from, address to, uint256 value) internal {
566         if (from == address(0)) {
567             revert ERC20InvalidSender(address(0));
568         }
569         if (to == address(0)) {
570             revert ERC20InvalidReceiver(address(0));
571         }
572         _update(from, to, value);
573     }
574 
575     /**
576      * @dev Transfers a `value` amount of tokens from `from` to `to`, or alternatively mints (or burns) if `from` (or `to`) is
577      * the zero address. All customizations to transfers, mints, and burns should be done by overriding this function.
578      *
579      * Emits a {Transfer} event.
580      */
581     function _update(address from, address to, uint256 value) internal virtual {
582         if (from == address(0)) {
583             // Overflow check required: The rest of the code assumes that totalSupply never overflows
584             _totalSupply += value;
585         } else {
586             uint256 fromBalance = _balances[from];
587             if (fromBalance < value) {
588                 revert ERC20InsufficientBalance(from, fromBalance, value);
589             }
590             unchecked {
591                 // Overflow not possible: value <= fromBalance <= totalSupply.
592                 _balances[from] = fromBalance - value;
593             }
594         }
595 
596         if (to == address(0)) {
597             unchecked {
598                 // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
599                 _totalSupply -= value;
600             }
601         } else {
602             unchecked {
603                 // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
604                 _balances[to] += value;
605             }
606         }
607 
608         emit Transfer(from, to, value);
609     }
610 
611     /**
612      * @dev Creates a `value` amount of tokens and assigns them to `account`, by transferring it from address(0).
613      * Relies on the `_update` mechanism
614      *
615      * Emits a {Transfer} event with `from` set to the zero address.
616      *
617      * NOTE: This function is not virtual, {_update} should be overridden instead.
618      */
619     function _mint(address account, uint256 value) internal {
620         if (account == address(0)) {
621             revert ERC20InvalidReceiver(address(0));
622         }
623         _update(address(0), account, value);
624     }
625 
626     /**
627      * @dev Destroys a `value` amount of tokens from `account`, by transferring it to address(0).
628      * Relies on the `_update` mechanism.
629      *
630      * Emits a {Transfer} event with `to` set to the zero address.
631      *
632      * NOTE: This function is not virtual, {_update} should be overridden instead
633      */
634     function _burn(address account, uint256 value) internal {
635         if (account == address(0)) {
636             revert ERC20InvalidSender(address(0));
637         }
638         _update(account, address(0), value);
639     }
640 
641     /**
642      * @dev Sets `value` as the allowance of `spender` over the `owner` s tokens.
643      *
644      * This internal function is equivalent to `approve`, and can be used to
645      * e.g. set automatic allowances for certain subsystems, etc.
646      *
647      * Emits an {Approval} event.
648      *
649      * Requirements:
650      *
651      * - `owner` cannot be the zero address.
652      * - `spender` cannot be the zero address.
653      */
654     function _approve(address owner, address spender, uint256 value) internal virtual {
655         _approve(owner, spender, value, true);
656     }
657 
658     /**
659      * @dev Alternative version of {_approve} with an optional flag that can enable or disable the Approval event.
660      *
661      * By default (when calling {_approve}) the flag is set to true. On the other hand, approval changes made by
662      * `_spendAllowance` during the `transferFrom` operation set the flag to false. This saves gas by not emitting any
663      * `Approval` event during `transferFrom` operations.
664      *
665      * Anyone who wishes to continue emitting `Approval` events on the`transferFrom` operation can force the flag to true
666      * using the following override:
667      * ```
668      * function _approve(address owner, address spender, uint256 value, bool) internal virtual override {
669      *     super._approve(owner, spender, value, true);
670      * }
671      * ```
672      *
673      * Requirements are the same as {_approve}.
674      */
675     function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
676         if (owner == address(0)) {
677             revert ERC20InvalidApprover(address(0));
678         }
679         if (spender == address(0)) {
680             revert ERC20InvalidSpender(address(0));
681         }
682         _allowances[owner][spender] = value;
683         if (emitEvent) {
684             emit Approval(owner, spender, value);
685         }
686     }
687 
688     /**
689      * @dev Updates `owner` s allowance for `spender` based on spent `value`.
690      *
691      * Does not update the allowance value in case of infinite allowance.
692      * Revert if not enough allowance is available.
693      *
694      * Might emit an {Approval} event.
695      */
696     function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
697         uint256 currentAllowance = allowance(owner, spender);
698         if (currentAllowance != type(uint256).max) {
699             if (currentAllowance < value) {
700                 revert ERC20InsufficientAllowance(spender, currentAllowance, value);
701             }
702             unchecked {
703                 _approve(owner, spender, currentAllowance - value, false);
704             }
705         }
706     }
707 }
708 
709 abstract contract Ownable is Context {
710     address private _owner;
711 
712     event OwnershipTransferred(
713         address indexed previousOwner,
714         address indexed newOwner
715     );
716 
717     /**
718      * @dev Initializes the contract setting the deployer as the initial owner.
719      */
720     constructor() {
721         _transferOwnership(_msgSender());
722     }
723 
724     /**
725      * @dev Returns the address of the current owner.
726      */
727     function owner() public view virtual returns (address) {
728         return _owner;
729     }
730 
731     /**
732      * @dev Throws if called by any account other than the owner.
733      */
734     modifier onlyOwner() {
735         require(owner() == _msgSender(), "Ownable: caller is not the owner");
736         _;
737     }
738 
739     /**
740      * @dev Leaves the contract without owner. It will not be possible to call
741      * `onlyOwner` functions anymore. Can only be called by the current owner.
742      *
743      * NOTE: Renouncing ownership will leave the contract without an owner,
744      * thereby removing any functionality that is only available to the owner.
745      */
746     function renounceOwnership() public virtual onlyOwner {
747         _transferOwnership(address(0));
748     }
749 
750     /**
751      * @dev Transfers ownership of the contract to a new account (`newOwner`).
752      * Can only be called by the current owner.
753      */
754     function transferOwnership(address newOwner) public virtual onlyOwner {
755         require(
756             newOwner != address(0),
757             "Ownable: new owner is the zero address"
758         );
759         _transferOwnership(newOwner);
760     }
761 
762     /**
763      * @dev Transfers ownership of the contract to a new account (`newOwner`).
764      * Internal function without access restriction.
765      */
766     function _transferOwnership(address newOwner) internal virtual {
767         address oldOwner = _owner;
768         _owner = newOwner;
769         emit OwnershipTransferred(oldOwner, newOwner);
770     }
771 }
772 
773 interface IDexFactory {
774     function createPair(
775         address tokenA,
776         address tokenB
777     ) external returns (address pair);
778 }
779 
780 interface IDexRouter {
781     function factory() external pure returns (address);
782 
783     function WETH() external pure returns (address);
784 
785     function swapExactTokensForETHSupportingFeeOnTransferTokens(
786         uint256 amountIn,
787         uint256 amountOutMin,
788         address[] calldata path,
789         address to,
790         uint256 deadline
791     ) external;
792 }
793 
794 contract Wager is ERC20, Ownable {
795     using SafeMath for uint256;
796 
797     IDexRouter public immutable dexRouter;
798     address public immutable dexPair;
799 
800     // Swapback
801     bool private duringContractSell;
802     bool public contractSellEnabled = false;
803     uint256 public minBalanceForContractSell;
804     uint256 public maxAmountTokensForContractSell;
805 
806     //Anti-whale
807     bool public tradingLimitsOn = true;
808     bool public limitTxsPerBlock = true;
809     uint256 public maxHold;
810     uint256 public maxTx;
811     mapping(address => uint256) private _addressLastTransfer; // to hold last Transfers temporarily during launch
812 
813     // Blacklist
814     mapping(address => bool) public blacklisted;
815     bool public canSetBlacklist = true;
816 
817     // Fee receivers
818     address public treasuryWallet;
819     address public projectWallet;
820 
821     bool public tokenLaunched = false;
822 
823     uint256 public buyFeesTotal;
824     uint256 public treasuryFeeBuy;
825     uint256 public projectFeeBuy;
826 
827     uint256 public sellFeesTotal;
828     uint256 public treasuryFeeSell;
829     uint256 public projectFeeSell;
830 
831     uint256 public tokensToSwapTreasury;
832     uint256 public tokensToSwapProject;
833 
834     /******************/
835 
836     // exclude from fees and max transaction amount
837     mapping(address => bool) private exemptFromFees;
838     mapping(address => bool) public exemptFromMaxLimits;
839 
840     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
841     // could be subject to a maximum transfer amount
842     mapping(address => bool) public isAMMPair;
843 
844     event FeeWhitelist(address indexed account, bool isExcluded);
845 
846     event SetAMMPair(address indexed pair, bool indexed value);
847 
848     event treasuryWalletUpdated(
849         address indexed newWallet,
850         address indexed oldWallet
851     );
852 
853     event projectWalletUpdated(
854         address indexed newWallet,
855         address indexed oldWallet
856     );
857 
858     constructor() ERC20("Wager", "VS") {
859         IDexRouter _dexRouter = IDexRouter(
860             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
861         );
862 
863         txLimitsWhitelist(address(_dexRouter), true);
864         dexRouter = _dexRouter;
865 
866         dexPair = IDexFactory(_dexRouter.factory())
867             .createPair(address(this), _dexRouter.WETH());
868         txLimitsWhitelist(address(dexPair), true);
869         _setAutomatedMarketMakerPair(address(dexPair), true);
870 
871         uint256 _treasuryFeeBuy = 1;
872         uint256 _projectFeeBuy = 15;
873 
874         uint256 _treasuryFeeSell = 1;
875         uint256 _projectFeeSell = 20;
876 
877         uint256 tokenSupply = 100000000000 * 1e18;
878 
879         maxTx = (tokenSupply * 10) / 1000; // 1% of total supply
880         maxHold = (tokenSupply * 20) / 1000; // 2% of total supply
881 
882         minBalanceForContractSell = (tokenSupply * 5) / 10000; // 0.05% swapback trigger
883         maxAmountTokensForContractSell = (tokenSupply * 1) / 100; // 1% max swapback
884 
885         treasuryFeeBuy = _treasuryFeeBuy;
886         projectFeeBuy = _projectFeeBuy;
887         buyFeesTotal = treasuryFeeBuy + projectFeeBuy;
888 
889         treasuryFeeSell = _treasuryFeeSell;
890         projectFeeSell = _projectFeeSell;
891         sellFeesTotal = treasuryFeeSell + projectFeeSell;
892 
893         treasuryWallet = address(msg.sender);
894         projectWallet = address(msg.sender);
895 
896         // exclude from paying fees or having max transaction amount
897         excludeFromFees(owner(), true);
898         excludeFromFees(address(this), true);
899         excludeFromFees(address(0xdead), true);
900         excludeFromFees(treasuryWallet, true);
901 
902         txLimitsWhitelist(owner(), true);
903         txLimitsWhitelist(address(this), true);
904         txLimitsWhitelist(address(0xdead), true);
905         txLimitsWhitelist(treasuryWallet, true);
906 
907         /*
908             _mint is an internal function in ERC20.sol that is only called here,
909             and CANNOT be called ever again
910         */
911         _mint(msg.sender, tokenSupply);
912     }
913 
914     receive() external payable {}
915 
916     /// @notice Launches the token and enables trading. Irriversable.
917     function startLaunch() external onlyOwner {
918         tokenLaunched = true;
919         contractSellEnabled = true;
920     }
921 
922     /// @notice Removes the max wallet and max transaction limits
923     function finishLaunchPeriod() external onlyOwner returns (bool) {
924         tradingLimitsOn = false;
925         return true;
926     }
927 
928     /// @notice Disables the Same wallet block transfer delay
929     function disableBlockTxLimit() external onlyOwner returns (bool) {
930         limitTxsPerBlock = false;
931         return true;
932     }
933 
934     /// @notice Changes the minimum balance of tokens the contract must have before duringContractSell tokens for ETH. Base 100000, so 0.5% = 500.
935     function updateContractSellMin(
936         uint256 newAmount
937     ) external onlyOwner returns (bool) {
938         require(
939             newAmount >= totalSupply() / 100000,
940             "Swap amount cannot be lower than 0.001% total supply."
941         );
942         require(
943             newAmount <= (500 * totalSupply()) / 100000,
944             "Swap amount cannot be higher than 0.5% total supply."
945         );
946         require(
947             newAmount <= maxAmountTokensForContractSell,
948             "Swap amount cannot be higher than maxAmountTokensForContractSell"
949         );
950         minBalanceForContractSell = newAmount;
951         return true;
952     }
953 
954     /// @notice Changes the maximum amount of tokens the contract can swap for ETH. Base 10000, so 0.5% = 50.
955     function updateMaxContractSellAmount(
956         uint256 newAmount
957     ) external onlyOwner returns (bool) {
958         require(
959             newAmount >= minBalanceForContractSell,
960             "Swap amount cannot be lower than minBalanceForContractSell"
961         );
962         maxAmountTokensForContractSell = newAmount;
963         return true;
964     }
965 
966     /// @notice Changes the maximum amount of tokens that can be bought or sold in a single transaction
967     /// @param newNum Base 1000, so 1% = 10
968     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
969         require(newNum >= 2, "Cannot set maxTx lower than 0.2%");
970         maxTx = (newNum * totalSupply()) / 1000;
971     }
972 
973     /// @notice Changes the maximum amount of tokens a wallet can hold
974     /// @param newNum Base 1000, so 1% = 10
975     function updateMaxHoldAmount(uint256 newNum) external onlyOwner {
976         require(newNum >= 5, "Cannot set maxHold lower than 0.5%");
977         maxHold = (newNum * totalSupply()) / 1000;
978     }
979 
980     /// @notice Sets if a wallet is excluded from the max wallet and tx limits
981     /// @param updAds The wallet to update
982     /// @param isEx If the wallet is excluded or not
983     function txLimitsWhitelist(
984         address updAds,
985         bool isEx
986     ) public onlyOwner {
987         exemptFromMaxLimits[updAds] = isEx;
988     }
989 
990     /// @notice Sets if the contract can sell tokens
991     /// @param enabled set to false to disable selling
992     function setContractSellEnabled(bool enabled) external onlyOwner {
993         contractSellEnabled = enabled;
994     }
995 
996     /// @notice Sets the fees for buys
997     /// @param _treasuryFee The fee for the treasury wallet
998     /// @param _projectFee The fee for the dev wallet
999     function setBuyFees(
1000         uint256 _treasuryFee,
1001         uint256 _projectFee
1002     ) external onlyOwner {
1003         treasuryFeeBuy = _treasuryFee;
1004         projectFeeBuy = _projectFee;
1005         buyFeesTotal = treasuryFeeBuy + projectFeeBuy;
1006         require(buyFeesTotal <= 12, "Must keep fees at 12% or less");
1007     }
1008 
1009     /// @notice Sets the fees for sells
1010     /// @param _treasuryFee The fee for the treasury wallet
1011     /// @param _projectFee The fee for the dev wallet
1012     function setSellFees(
1013         uint256 _treasuryFee,
1014         uint256 _projectFee
1015     ) external onlyOwner {
1016         treasuryFeeSell = _treasuryFee;
1017         projectFeeSell = _projectFee;
1018         sellFeesTotal = treasuryFeeSell + projectFeeSell;
1019         require(sellFeesTotal <= 12, "Must keep fees at 12% or less");
1020     }
1021 
1022     /// @notice Sets if a wallet is excluded from fees
1023     /// @param account The wallet to update
1024     /// @param excluded If the wallet is excluded or not
1025     function excludeFromFees(address account, bool excluded) public onlyOwner {
1026         exemptFromFees[account] = excluded;
1027         emit FeeWhitelist(account, excluded);
1028     }
1029 
1030     /// @notice Sets an address as a new liquidity pair. You probably dont want to do this.
1031     /// @param pair The new pair
1032     function setAutomatedMarketMakerPair(
1033         address pair,
1034         bool value
1035     ) public onlyOwner {
1036         require(
1037             pair != dexPair,
1038             "The pair cannot be removed from isAMMPair"
1039         );
1040 
1041         _setAutomatedMarketMakerPair(pair, value);
1042     }
1043 
1044     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1045         isAMMPair[pair] = value;
1046 
1047         emit SetAMMPair(pair, value);
1048     }
1049 
1050     /// @notice Sets a wallet as the new treasury wallet
1051     /// @param newTreasuryWallet The new treasury wallet
1052     function updateTreasuryWallet(
1053         address newTreasuryWallet
1054     ) external onlyOwner {
1055         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
1056         treasuryWallet = newTreasuryWallet;
1057     }
1058 
1059     /// @notice Sets a wallet as the new dev wallet
1060     /// @param newWallet The new dev wallet
1061     function updateProjectWallet(address newWallet) external onlyOwner {
1062         emit projectWalletUpdated(newWallet, projectWallet);
1063         projectWallet = newWallet;
1064     }
1065 
1066     /// @notice Sets the blacklist status of multiple addresses
1067     /// @param addresses The addresses to update
1068     /// @param isBlacklisted If the addresses are blacklisted or not
1069     function updateBlacklistMultiple(
1070         address[] calldata addresses,
1071         bool isBlacklisted
1072     ) external onlyOwner {
1073         require(canSetBlacklist, "Blacklist is locked");
1074         for (uint256 i = 0; i < addresses.length; i++) {
1075             blacklisted[addresses[i]] = isBlacklisted;
1076         }
1077     }
1078 
1079     /// @notice Removes the owner ability to change the blacklist
1080     function lockBlacklist() external onlyOwner {
1081         canSetBlacklist = false;
1082     }
1083 
1084     function isExcludedFromFees(address account) public view returns (bool) {
1085         return exemptFromFees[account];
1086     }
1087 
1088     function _update(
1089         address from,
1090         address to,
1091         uint256 amount
1092     ) internal override {
1093         if (amount == 0) {
1094             super._update(from, to, 0);
1095             return;
1096         }
1097 
1098         if (tradingLimitsOn) {
1099             if (
1100                 from != owner() &&
1101                 to != owner() &&
1102                 to != address(0) &&
1103                 to != address(0xdead) &&
1104                 !duringContractSell
1105             ) {
1106                 if (!tokenLaunched) {
1107                     require(
1108                         exemptFromFees[from] || exemptFromFees[to],
1109                         "Trading is not active."
1110                     );
1111                 }
1112 
1113                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1114                 if (limitTxsPerBlock) {
1115                     if (
1116                         to != owner() &&
1117                         to != address(dexRouter) &&
1118                         to != address(dexPair)
1119                     ) {
1120                         require(
1121                             _addressLastTransfer[tx.origin] <
1122                                 block.number,
1123                             "_update:: Transfer Delay enabled.  Only one purchase per block allowed."
1124                         );
1125                         _addressLastTransfer[tx.origin] = block.number;
1126                     }
1127                 }
1128 
1129                 //when buy
1130                 if (isAMMPair[from] && !exemptFromMaxLimits[to]) {
1131                     require(
1132                         amount <= maxTx,
1133                         "Buy transfer amount exceeds the maxTx."
1134                     );
1135                     require(
1136                         amount + balanceOf(to) <= maxHold,
1137                         "Max wallet exceeded"
1138                     );
1139                 }
1140                 //when sell
1141                 else if (
1142                     isAMMPair[to] && !exemptFromMaxLimits[from]
1143                 ) {
1144                     require(
1145                         amount <= maxTx,
1146                         "Sell transfer amount exceeds the maxTx."
1147                     );
1148                 } else if (!exemptFromMaxLimits[to]) {
1149                     require(
1150                         amount + balanceOf(to) <= maxHold,
1151                         "Max wallet exceeded"
1152                     );
1153                 }
1154             }
1155         }
1156 
1157         uint256 contractTokenBalance = balanceOf(address(this));
1158 
1159         bool canSwap = contractTokenBalance >= minBalanceForContractSell;
1160 
1161         if (
1162             canSwap &&
1163             contractSellEnabled &&
1164             !duringContractSell &&
1165             !isAMMPair[from] &&
1166             !exemptFromFees[from] &&
1167             !exemptFromFees[to]
1168         ) {
1169             duringContractSell = true;
1170 
1171             swapBack();
1172 
1173             duringContractSell = false;
1174         }
1175 
1176         bool takeFee = !duringContractSell;
1177 
1178         // if any account belongs to _isExcludedFromFee account then remove the fee
1179         if (exemptFromFees[from] || exemptFromFees[to]) {
1180             takeFee = false;
1181         }
1182 
1183         if (!exemptFromFees[from] || !exemptFromFees[to]) {
1184             require(!blacklisted[from], "Address is blacklisted");
1185         }
1186 
1187         uint256 fees = 0;
1188         // only take fees on buys/sells, do not take on wallet transfers
1189         if (takeFee) {
1190             // on sell
1191             if (isAMMPair[to] && sellFeesTotal > 0) {
1192                 fees = amount.mul(sellFeesTotal).div(100);
1193                 tokensToSwapProject += (fees * projectFeeSell) / sellFeesTotal;
1194                 tokensToSwapTreasury += (fees * treasuryFeeSell) / sellFeesTotal;
1195             }
1196             // on buy
1197             else if (isAMMPair[from] && buyFeesTotal > 0) {
1198                 fees = amount.mul(buyFeesTotal).div(100);
1199                 tokensToSwapProject += (fees * projectFeeBuy) / buyFeesTotal;
1200                 tokensToSwapTreasury += (fees * treasuryFeeBuy) / buyFeesTotal;
1201             }
1202 
1203             if (fees > 0) {
1204                 super._update(from, address(this), fees);
1205             }
1206 
1207             amount -= fees;
1208         }
1209 
1210         super._update(from, to, amount);
1211     }
1212 
1213     function swapTokensForEth(uint256 tokenAmount) private {
1214         // generate the uniswap pair path of token -> weth
1215         address[] memory path = new address[](2);
1216         path[0] = address(this);
1217         path[1] = dexRouter.WETH();
1218 
1219         _approve(address(this), address(dexRouter), tokenAmount);
1220 
1221         // make the swap
1222         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1223             tokenAmount,
1224             0, // accept any amount of ETH
1225             path,
1226             address(this),
1227             block.timestamp
1228         );
1229     }
1230 
1231     function swapBack() private {
1232         uint256 contractBalance = balanceOf(address(this));
1233         uint256 totalTokensToSwap = tokensToSwapTreasury + tokensToSwapProject;
1234         bool success;
1235 
1236         if (contractBalance == 0 || totalTokensToSwap == 0) {
1237             return;
1238         }
1239 
1240         if (contractBalance > maxAmountTokensForContractSell) {
1241             contractBalance = maxAmountTokensForContractSell;
1242         }
1243 
1244         uint256 initialETHBalance = address(this).balance;
1245 
1246         swapTokensForEth(contractBalance);
1247 
1248         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1249 
1250         uint256 ethForProject = ethBalance.mul(tokensToSwapProject).div(totalTokensToSwap);
1251 
1252         tokensToSwapTreasury = 0;
1253         tokensToSwapProject = 0;
1254 
1255         (success, ) = address(projectWallet).call{value: ethForProject}("");
1256 
1257         (success, ) = address(treasuryWallet).call{
1258             value: address(this).balance
1259         }("");
1260     }
1261 }