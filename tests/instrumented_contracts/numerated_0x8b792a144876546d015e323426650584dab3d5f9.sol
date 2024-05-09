1 /**
2  
3  //telegram: https://t.me/frienddaoportal
4  //website:Https://frienddaotoken.com
5  //twitter: https://twitter.com/frienddaotoken
6  
7  * SPDX-License-Identifier: MIT
8  */
9 pragma solidity 0.8.21;
10 
11 library SafeMath {
12     /**
13      * @dev Returns the addition of two unsigned integers, with an overflow flag.
14      *
15      * _Available since v3.4._
16      */
17     function tryAdd(
18         uint256 a,
19         uint256 b
20     ) internal pure returns (bool, uint256) {
21         unchecked {
22             uint256 c = a + b;
23             if (c < a) return (false, 0);
24             return (true, c);
25         }
26     }
27 
28     /**
29      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
30      *
31      * _Available since v3.4._
32      */
33     function trySub(
34         uint256 a,
35         uint256 b
36     ) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(
49         uint256 a,
50         uint256 b
51     ) internal pure returns (bool, uint256) {
52         unchecked {
53             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54             // benefit is lost if 'b' is also tested.
55             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
56             if (a == 0) return (true, 0);
57             uint256 c = a * b;
58             if (c / a != b) return (false, 0);
59             return (true, c);
60         }
61     }
62 
63     /**
64      * @dev Returns the division of two unsigned integers, with a division by zero flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryDiv(
69         uint256 a,
70         uint256 b
71     ) internal pure returns (bool, uint256) {
72         unchecked {
73             if (b == 0) return (false, 0);
74             return (true, a / b);
75         }
76     }
77 
78     /**
79      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
80      *
81      * _Available since v3.4._
82      */
83     function tryMod(
84         uint256 a,
85         uint256 b
86     ) internal pure returns (bool, uint256) {
87         unchecked {
88             if (b == 0) return (false, 0);
89             return (true, a % b);
90         }
91     }
92 
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         return a + b;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      *
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return a - b;
119     }
120 
121     /**
122      * @dev Returns the multiplication of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `*` operator.
126      *
127      * Requirements:
128      *
129      * - Multiplication cannot overflow.
130      */
131     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132         return a * b;
133     }
134 
135     /**
136      * @dev Returns the integer division of two unsigned integers, reverting on
137      * division by zero. The result is rounded towards zero.
138      *
139      * Counterpart to Solidity's `/` operator.
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function div(uint256 a, uint256 b) internal pure returns (uint256) {
146         return a / b;
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * reverting when dividing by zero.
152      *
153      * Counterpart to Solidity's `%` operator. This function uses a `revert`
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a % b;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
167      * overflow (when the result is negative).
168      *
169      * CAUTION: This function is deprecated because it requires allocating memory for the error
170      * message unnecessarily. For custom revert reasons use {trySub}.
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(
179         uint256 a,
180         uint256 b,
181         string memory errorMessage
182     ) internal pure returns (uint256) {
183         unchecked {
184             require(b <= a, errorMessage);
185             return a - b;
186         }
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(
202         uint256 a,
203         uint256 b,
204         string memory errorMessage
205     ) internal pure returns (uint256) {
206         unchecked {
207             require(b > 0, errorMessage);
208             return a / b;
209         }
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * reverting with custom message when dividing by zero.
215      *
216      * CAUTION: This function is deprecated because it requires allocating memory for the error
217      * message unnecessarily. For custom revert reasons use {tryMod}.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(
228         uint256 a,
229         uint256 b,
230         string memory errorMessage
231     ) internal pure returns (uint256) {
232         unchecked {
233             require(b > 0, errorMessage);
234             return a % b;
235         }
236     }
237 }
238 
239 interface IERC20 {
240     /**
241      * @dev Emitted when `value` tokens are moved from one account (`from`) to
242      * another (`to`).
243      *
244      * Note that `value` may be zero.
245      */
246     event Transfer(address indexed from, address indexed to, uint256 value);
247 
248     /**
249      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
250      * a call to {approve}. `value` is the new allowance.
251      */
252     event Approval(address indexed owner, address indexed spender, uint256 value);
253 
254     /**
255      * @dev Returns the value of tokens in existence.
256      */
257     function totalSupply() external view returns (uint256);
258 
259     /**
260      * @dev Returns the value of tokens owned by `account`.
261      */
262     function balanceOf(address account) external view returns (uint256);
263 
264     /**
265      * @dev Moves a `value` amount of tokens from the caller's account to `to`.
266      *
267      * Returns a boolean value indicating whether the operation succeeded.
268      *
269      * Emits a {Transfer} event.
270      */
271     function transfer(address to, uint256 value) external returns (bool);
272 
273     /**
274      * @dev Returns the remaining number of tokens that `spender` will be
275      * allowed to spend on behalf of `owner` through {transferFrom}. This is
276      * zero by default.
277      *
278      * This value changes when {approve} or {transferFrom} are called.
279      */
280     function allowance(address owner, address spender) external view returns (uint256);
281 
282     /**
283      * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
284      * caller's tokens.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * IMPORTANT: Beware that changing an allowance with this method brings the risk
289      * that someone may use both the old and the new allowance by unfortunate
290      * transaction ordering. One possible solution to mitigate this race
291      * condition is to first reduce the spender's allowance to 0 and set the
292      * desired value afterwards:
293      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
294      *
295      * Emits an {Approval} event.
296      */
297     function approve(address spender, uint256 value) external returns (bool);
298 
299     /**
300      * @dev Moves a `value` amount of tokens from `from` to `to` using the
301      * allowance mechanism. `value` is then deducted from the caller's
302      * allowance.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transferFrom(address from, address to, uint256 value) external returns (bool);
309 }
310 
311 interface IERC20Metadata is IERC20 {
312     /**
313      * @dev Returns the name of the token.
314      */
315     function name() external view returns (string memory);
316 
317     /**
318      * @dev Returns the symbol of the token.
319      */
320     function symbol() external view returns (string memory);
321 
322     /**
323      * @dev Returns the decimals places of the token.
324      */
325     function decimals() external view returns (uint8);
326 }
327 
328 abstract contract Context {
329     function _msgSender() internal view virtual returns (address) {
330         return msg.sender;
331     }
332 
333     function _msgData() internal view virtual returns (bytes calldata) {
334         return msg.data;
335     }
336 }
337 
338 interface IERC20Errors {
339     /**
340      * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
341      * @param sender Address whose tokens are being transferred.
342      * @param balance Current balance for the interacting account.
343      * @param needed Minimum amount required to perform a transfer.
344      */
345     error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
346 
347     /**
348      * @dev Indicates a failure with the token `sender`. Used in transfers.
349      * @param sender Address whose tokens are being transferred.
350      */
351     error ERC20InvalidSender(address sender);
352 
353     /**
354      * @dev Indicates a failure with the token `receiver`. Used in transfers.
355      * @param receiver Address to which tokens are being transferred.
356      */
357     error ERC20InvalidReceiver(address receiver);
358 
359     /**
360      * @dev Indicates a failure with the `spender`’s `allowance`. Used in transfers.
361      * @param spender Address that may be allowed to operate on tokens without being their owner.
362      * @param allowance Amount of tokens a `spender` is allowed to operate with.
363      * @param needed Minimum amount required to perform a transfer.
364      */
365     error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
366 
367     /**
368      * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
369      * @param approver Address initiating an approval operation.
370      */
371     error ERC20InvalidApprover(address approver);
372 
373     /**
374      * @dev Indicates a failure with the `spender` to be approved. Used in approvals.
375      * @param spender Address that may be allowed to operate on tokens without being their owner.
376      */
377     error ERC20InvalidSpender(address spender);
378 }
379 
380 abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
381     mapping(address account => uint256) private _balances;
382 
383     mapping(address account => mapping(address spender => uint256)) private _allowances;
384 
385     uint256 private _totalSupply;
386 
387     string private _name;
388     string private _symbol;
389 
390     /**
391      * @dev Indicates a failed `decreaseAllowance` request.
392      */
393     error ERC20FailedDecreaseAllowance(address spender, uint256 currentAllowance, uint256 requestedDecrease);
394 
395     /**
396      * @dev Sets the values for {name} and {symbol}.
397      *
398      * All two of these values are immutable: they can only be set once during
399      * construction.
400      */
401     constructor(string memory name_, string memory symbol_) {
402         _name = name_;
403         _symbol = symbol_;
404     }
405 
406     /**
407      * @dev Returns the name of the token.
408      */
409     function name() public view virtual returns (string memory) {
410         return _name;
411     }
412 
413     /**
414      * @dev Returns the symbol of the token, usually a shorter version of the
415      * name.
416      */
417     function symbol() public view virtual returns (string memory) {
418         return _symbol;
419     }
420 
421     /**
422      * @dev Returns the number of decimals used to get its user representation.
423      * For example, if `decimals` equals `2`, a balance of `505` tokens should
424      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
425      *
426      * Tokens usually opt for a value of 18, imitating the relationship between
427      * Ether and Wei. This is the default value returned by this function, unless
428      * it's overridden.
429      *
430      * NOTE: This information is only used for _display_ purposes: it in
431      * no way affects any of the arithmetic of the contract, including
432      * {IERC20-balanceOf} and {IERC20-transfer}.
433      */
434     function decimals() public view virtual returns (uint8) {
435         return 18;
436     }
437 
438     /**
439      * @dev See {IERC20-totalSupply}.
440      */
441     function totalSupply() public view virtual returns (uint256) {
442         return _totalSupply;
443     }
444 
445     /**
446      * @dev See {IERC20-balanceOf}.
447      */
448     function balanceOf(address account) public view virtual returns (uint256) {
449         return _balances[account];
450     }
451 
452     /**
453      * @dev See {IERC20-transfer}.
454      *
455      * Requirements:
456      *
457      * - `to` cannot be the zero address.
458      * - the caller must have a balance of at least `value`.
459      */
460     function transfer(address to, uint256 value) public virtual returns (bool) {
461         address owner = _msgSender();
462         _transfer(owner, to, value);
463         return true;
464     }
465 
466     /**
467      * @dev See {IERC20-allowance}.
468      */
469     function allowance(address owner, address spender) public view virtual returns (uint256) {
470         return _allowances[owner][spender];
471     }
472 
473     /**
474      * @dev See {IERC20-approve}.
475      *
476      * NOTE: If `value` is the maximum `uint256`, the allowance is not updated on
477      * `transferFrom`. This is semantically equivalent to an infinite approval.
478      *
479      * Requirements:
480      *
481      * - `spender` cannot be the zero address.
482      */
483     function approve(address spender, uint256 value) public virtual returns (bool) {
484         address owner = _msgSender();
485         _approve(owner, spender, value);
486         return true;
487     }
488 
489     /**
490      * @dev See {IERC20-transferFrom}.
491      *
492      * Emits an {Approval} event indicating the updated allowance. This is not
493      * required by the EIP. See the note at the beginning of {ERC20}.
494      *
495      * NOTE: Does not update the allowance if the current allowance
496      * is the maximum `uint256`.
497      *
498      * Requirements:
499      *
500      * - `from` and `to` cannot be the zero address.
501      * - `from` must have a balance of at least `value`.
502      * - the caller must have allowance for ``from``'s tokens of at least
503      * `value`.
504      */
505     function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
506         address spender = _msgSender();
507         _spendAllowance(from, spender, value);
508         _transfer(from, to, value);
509         return true;
510     }
511 
512     /**
513      * @dev Atomically increases the allowance granted to `spender` by the caller.
514      *
515      * This is an alternative to {approve} that can be used as a mitigation for
516      * problems described in {IERC20-approve}.
517      *
518      * Emits an {Approval} event indicating the updated allowance.
519      *
520      * Requirements:
521      *
522      * - `spender` cannot be the zero address.
523      */
524     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
525         address owner = _msgSender();
526         _approve(owner, spender, allowance(owner, spender) + addedValue);
527         return true;
528     }
529 
530     /**
531      * @dev Atomically decreases the allowance granted to `spender` by the caller.
532      *
533      * This is an alternative to {approve} that can be used as a mitigation for
534      * problems described in {IERC20-approve}.
535      *
536      * Emits an {Approval} event indicating the updated allowance.
537      *
538      * Requirements:
539      *
540      * - `spender` cannot be the zero address.
541      * - `spender` must have allowance for the caller of at least
542      * `requestedDecrease`.
543      *
544      * NOTE: Although this function is designed to avoid double spending with {approval},
545      * it can still be frontrunned, preventing any attempt of allowance reduction.
546      */
547     function decreaseAllowance(address spender, uint256 requestedDecrease) public virtual returns (bool) {
548         address owner = _msgSender();
549         uint256 currentAllowance = allowance(owner, spender);
550         if (currentAllowance < requestedDecrease) {
551             revert ERC20FailedDecreaseAllowance(spender, currentAllowance, requestedDecrease);
552         }
553         unchecked {
554             _approve(owner, spender, currentAllowance - requestedDecrease);
555         }
556 
557         return true;
558     }
559 
560     /**
561      * @dev Moves a `value` amount of tokens from `from` to `to`.
562      *
563      * This internal function is equivalent to {transfer}, and can be used to
564      * e.g. implement automatic token fees, slashing mechanisms, etc.
565      *
566      * Emits a {Transfer} event.
567      *
568      * NOTE: This function is not virtual, {_update} should be overridden instead.
569      */
570     function _transfer(address from, address to, uint256 value) internal {
571         if (from == address(0)) {
572             revert ERC20InvalidSender(address(0));
573         }
574         if (to == address(0)) {
575             revert ERC20InvalidReceiver(address(0));
576         }
577         _update(from, to, value);
578     }
579 
580     /**
581      * @dev Transfers a `value` amount of tokens from `from` to `to`, or alternatively mints (or burns) if `from` (or `to`) is
582      * the zero address. All customizations to transfers, mints, and burns should be done by overriding this function.
583      *
584      * Emits a {Transfer} event.
585      */
586     function _update(address from, address to, uint256 value) internal virtual {
587         if (from == address(0)) {
588             // Overflow check required: The rest of the code assumes that totalSupply never overflows
589             _totalSupply += value;
590         } else {
591             uint256 fromBalance = _balances[from];
592             if (fromBalance < value) {
593                 revert ERC20InsufficientBalance(from, fromBalance, value);
594             }
595             unchecked {
596                 // Overflow not possible: value <= fromBalance <= totalSupply.
597                 _balances[from] = fromBalance - value;
598             }
599         }
600 
601         if (to == address(0)) {
602             unchecked {
603                 // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
604                 _totalSupply -= value;
605             }
606         } else {
607             unchecked {
608                 // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
609                 _balances[to] += value;
610             }
611         }
612 
613         emit Transfer(from, to, value);
614     }
615 
616     /**
617      * @dev Creates a `value` amount of tokens and assigns them to `account`, by transferring it from address(0).
618      * Relies on the `_update` mechanism
619      *
620      * Emits a {Transfer} event with `from` set to the zero address.
621      *
622      * NOTE: This function is not virtual, {_update} should be overridden instead.
623      */
624     function _mint(address account, uint256 value) internal {
625         if (account == address(0)) {
626             revert ERC20InvalidReceiver(address(0));
627         }
628         _update(address(0), account, value);
629     }
630 
631     /**
632      * @dev Destroys a `value` amount of tokens from `account`, by transferring it to address(0).
633      * Relies on the `_update` mechanism.
634      *
635      * Emits a {Transfer} event with `to` set to the zero address.
636      *
637      * NOTE: This function is not virtual, {_update} should be overridden instead
638      */
639     function _burn(address account, uint256 value) internal {
640         if (account == address(0)) {
641             revert ERC20InvalidSender(address(0));
642         }
643         _update(account, address(0), value);
644     }
645 
646     /**
647      * @dev Sets `value` as the allowance of `spender` over the `owner` s tokens.
648      *
649      * This internal function is equivalent to `approve`, and can be used to
650      * e.g. set automatic allowances for certain subsystems, etc.
651      *
652      * Emits an {Approval} event.
653      *
654      * Requirements:
655      *
656      * - `owner` cannot be the zero address.
657      * - `spender` cannot be the zero address.
658      */
659     function _approve(address owner, address spender, uint256 value) internal virtual {
660         _approve(owner, spender, value, true);
661     }
662 
663     /**
664      * @dev Alternative version of {_approve} with an optional flag that can enable or disable the Approval event.
665      *
666      * By default (when calling {_approve}) the flag is set to true. On the other hand, approval changes made by
667      * `_spendAllowance` during the `transferFrom` operation set the flag to false. This saves gas by not emitting any
668      * `Approval` event during `transferFrom` operations.
669      *
670      * Anyone who wishes to continue emitting `Approval` events on the`transferFrom` operation can force the flag to true
671      * using the following override:
672      * ```
673      * function _approve(address owner, address spender, uint256 value, bool) internal virtual override {
674      *     super._approve(owner, spender, value, true);
675      * }
676      * ```
677      *
678      * Requirements are the same as {_approve}.
679      */
680     function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
681         if (owner == address(0)) {
682             revert ERC20InvalidApprover(address(0));
683         }
684         if (spender == address(0)) {
685             revert ERC20InvalidSpender(address(0));
686         }
687         _allowances[owner][spender] = value;
688         if (emitEvent) {
689             emit Approval(owner, spender, value);
690         }
691     }
692 
693     /**
694      * @dev Updates `owner` s allowance for `spender` based on spent `value`.
695      *
696      * Does not update the allowance value in case of infinite allowance.
697      * Revert if not enough allowance is available.
698      *
699      * Might emit an {Approval} event.
700      */
701     function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
702         uint256 currentAllowance = allowance(owner, spender);
703         if (currentAllowance != type(uint256).max) {
704             if (currentAllowance < value) {
705                 revert ERC20InsufficientAllowance(spender, currentAllowance, value);
706             }
707             unchecked {
708                 _approve(owner, spender, currentAllowance - value, false);
709             }
710         }
711     }
712 }
713 
714 abstract contract Ownable is Context {
715     address private _owner;
716 
717     event OwnershipTransferred(
718         address indexed previousOwner,
719         address indexed newOwner
720     );
721 
722     /**
723      * @dev Initializes the contract setting the deployer as the initial owner.
724      */
725     constructor() {
726         _transferOwnership(_msgSender());
727     }
728 
729     /**
730      * @dev Returns the address of the current owner.
731      */
732     function owner() public view virtual returns (address) {
733         return _owner;
734     }
735 
736     /**
737      * @dev Throws if called by any account other than the owner.
738      */
739     modifier onlyOwner() {
740         require(owner() == _msgSender(), "Ownable: caller is not the owner");
741         _;
742     }
743 
744     /**
745      * @dev Leaves the contract without owner. It will not be possible to call
746      * `onlyOwner` functions anymore. Can only be called by the current owner.
747      *
748      * NOTE: Renouncing ownership will leave the contract without an owner,
749      * thereby removing any functionality that is only available to the owner.
750      */
751     function renounceOwnership() public virtual onlyOwner {
752         _transferOwnership(address(0));
753     }
754 
755     /**
756      * @dev Transfers ownership of the contract to a new account (`newOwner`).
757      * Can only be called by the current owner.
758      */
759     function transferOwnership(address newOwner) public virtual onlyOwner {
760         require(
761             newOwner != address(0),
762             "Ownable: new owner is the zero address"
763         );
764         _transferOwnership(newOwner);
765     }
766 
767     /**
768      * @dev Transfers ownership of the contract to a new account (`newOwner`).
769      * Internal function without access restriction.
770      */
771     function _transferOwnership(address newOwner) internal virtual {
772         address oldOwner = _owner;
773         _owner = newOwner;
774         emit OwnershipTransferred(oldOwner, newOwner);
775     }
776 }
777 
778 interface IDexFactory {
779     function createPair(
780         address tokenA,
781         address tokenB
782     ) external returns (address pair);
783 }
784 
785 interface IDexRouter {
786     function factory() external pure returns (address);
787 
788     function WETH() external pure returns (address);
789 
790     function swapExactTokensForETHSupportingFeeOnTransferTokens(
791         uint256 amountIn,
792         uint256 amountOutMin,
793         address[] calldata path,
794         address to,
795         uint256 deadline
796     ) external;
797 }
798 
799 contract FriendDAO is ERC20, Ownable {
800     using SafeMath for uint256;
801 
802     IDexRouter public immutable dexRouter;
803     address public immutable dexPair;
804 
805     // Swapback
806     bool private duringContractSell;
807     bool public contractSellEnabled = false;
808     uint256 public minBalanceForContractSell;
809     uint256 public maxAmountTokensForContractSell;
810 
811     //Anti-whale
812     bool public tradingLimitsOn = true;
813     bool public limitTxsPerBlock = true;
814     uint256 public maxHold;
815     uint256 public maxTx;
816     mapping(address => uint256) private _addressLastTransfer; // to hold last Transfers temporarily during launch
817 
818     // Blacklist
819     mapping(address => bool) public blacklisted;
820     bool public canSetBlacklist = true;
821 
822     // Fee receivers
823     address public treasuryWallet;
824     address public projectWallet;
825 
826     bool public tokenLaunched = false;
827 
828     uint256 public buyFeesTotal;
829     uint256 public treasuryFeeBuy;
830     uint256 public projectFeeBuy;
831 
832     uint256 public sellFeesTotal;
833     uint256 public treasuryFeeSell;
834     uint256 public projectFeeSell;
835 
836     uint256 public tokensToSwapTreasury;
837     uint256 public tokensToSwapProject;
838 
839     /******************/
840 
841     // exclude from fees and max transaction amount
842     mapping(address => bool) private exemptFromFees;
843     mapping(address => bool) public exemptFromMaxLimits;
844 
845     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
846     // could be subject to a maximum transfer amount
847     mapping(address => bool) public isAMMPair;
848 
849     event FeeWhitelist(address indexed account, bool isExcluded);
850 
851     event SetAMMPair(address indexed pair, bool indexed value);
852 
853     event treasuryWalletUpdated(
854         address indexed newWallet,
855         address indexed oldWallet
856     );
857 
858     event projectWalletUpdated(
859         address indexed newWallet,
860         address indexed oldWallet
861     );
862 
863     constructor() ERC20("FriendDAO", "FDAO") {
864         IDexRouter _dexRouter = IDexRouter(
865             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
866         );
867 
868         txLimitsWhitelist(address(_dexRouter), true);
869         dexRouter = _dexRouter;
870 
871         dexPair = IDexFactory(_dexRouter.factory())
872             .createPair(address(this), _dexRouter.WETH());
873         txLimitsWhitelist(address(dexPair), true);
874         _setAutomatedMarketMakerPair(address(dexPair), true);
875 
876         uint256 _treasuryFeeBuy = 2;
877         uint256 _projectFeeBuy = 15;
878 
879         uint256 _treasuryFeeSell = 2;
880         uint256 _projectFeeSell = 20;
881 
882         uint256 tokenSupply = 100000000000 * 1e18;
883 
884         maxTx = (tokenSupply * 20) / 1000; // 2% of total supply
885         maxHold = (tokenSupply * 20) / 1000; // 2% of total supply
886 
887         minBalanceForContractSell = (tokenSupply * 5) / 10000; // 0.05% swapback trigger
888         maxAmountTokensForContractSell = (tokenSupply * 1) / 100; // 1% max swapback
889 
890         treasuryFeeBuy = _treasuryFeeBuy;
891         projectFeeBuy = _projectFeeBuy;
892         buyFeesTotal = treasuryFeeBuy + projectFeeBuy;
893 
894         treasuryFeeSell = _treasuryFeeSell;
895         projectFeeSell = _projectFeeSell;
896         sellFeesTotal = treasuryFeeSell + projectFeeSell;
897 
898         treasuryWallet = address(msg.sender);
899         projectWallet = address(msg.sender);
900 
901         // exclude from paying fees or having max transaction amount
902         excludeFromFees(owner(), true);
903         excludeFromFees(address(this), true);
904         excludeFromFees(address(0xdead), true);
905         excludeFromFees(treasuryWallet, true);
906 
907         txLimitsWhitelist(owner(), true);
908         txLimitsWhitelist(address(this), true);
909         txLimitsWhitelist(address(0xdead), true);
910         txLimitsWhitelist(treasuryWallet, true);
911 
912         /*
913             _mint is an internal function in ERC20.sol that is only called here,
914             and CANNOT be called ever again
915         */
916         _mint(msg.sender, tokenSupply);
917     }
918 
919     receive() external payable {}
920 
921     /// @notice Launches the token and enables trading. Irriversable.
922     function startLaunch() external onlyOwner {
923         tokenLaunched = true;
924         contractSellEnabled = true;
925     }
926 
927     /// @notice Removes the max wallet and max transaction limits
928     function finishLaunchPeriod() external onlyOwner returns (bool) {
929         tradingLimitsOn = false;
930         return true;
931     }
932 
933     /// @notice Disables the Same wallet block transfer delay
934     function disableBlockTxLimit() external onlyOwner returns (bool) {
935         limitTxsPerBlock = false;
936         return true;
937     }
938 
939     /// @notice Changes the minimum balance of tokens the contract must have before duringContractSell tokens for ETH. Base 100000, so 0.5% = 500.
940     function updateContractSellMin(
941         uint256 newAmount
942     ) external onlyOwner returns (bool) {
943         require(
944             newAmount >= totalSupply() / 100000,
945             "Swap amount cannot be lower than 0.001% total supply."
946         );
947         require(
948             newAmount <= (500 * totalSupply()) / 100000,
949             "Swap amount cannot be higher than 0.5% total supply."
950         );
951         require(
952             newAmount <= maxAmountTokensForContractSell,
953             "Swap amount cannot be higher than maxAmountTokensForContractSell"
954         );
955         minBalanceForContractSell = newAmount;
956         return true;
957     }
958 
959     /// @notice Changes the maximum amount of tokens the contract can swap for ETH. Base 10000, so 0.5% = 50.
960     function updateMaxContractSellAmount(
961         uint256 newAmount
962     ) external onlyOwner returns (bool) {
963         require(
964             newAmount >= minBalanceForContractSell,
965             "Swap amount cannot be lower than minBalanceForContractSell"
966         );
967         maxAmountTokensForContractSell = newAmount;
968         return true;
969     }
970 
971     /// @notice Changes the maximum amount of tokens that can be bought or sold in a single transaction
972     /// @param newNum Base 1000, so 1% = 10
973     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
974         require(newNum >= 2, "Cannot set maxTx lower than 0.2%");
975         maxTx = (newNum * totalSupply()) / 1000;
976     }
977 
978     /// @notice Changes the maximum amount of tokens a wallet can hold
979     /// @param newNum Base 1000, so 1% = 10
980     function updateMaxHoldAmount(uint256 newNum) external onlyOwner {
981         require(newNum >= 5, "Cannot set maxHold lower than 0.5%");
982         maxHold = (newNum * totalSupply()) / 1000;
983     }
984 
985     /// @notice Sets if a wallet is excluded from the max wallet and tx limits
986     /// @param updAds The wallet to update
987     /// @param isEx If the wallet is excluded or not
988     function txLimitsWhitelist(
989         address updAds,
990         bool isEx
991     ) public onlyOwner {
992         exemptFromMaxLimits[updAds] = isEx;
993     }
994 
995     /// @notice Sets if the contract can sell tokens
996     /// @param enabled set to false to disable selling
997     function setContractSellEnabled(bool enabled) external onlyOwner {
998         contractSellEnabled = enabled;
999     }
1000 
1001     /// @notice Sets the fees for buys
1002     /// @param _treasuryFee The fee for the treasury wallet
1003     /// @param _projectFee The fee for the dev wallet
1004     function setBuyFees(
1005         uint256 _treasuryFee,
1006         uint256 _projectFee
1007     ) external onlyOwner {
1008         treasuryFeeBuy = _treasuryFee;
1009         projectFeeBuy = _projectFee;
1010         buyFeesTotal = treasuryFeeBuy + projectFeeBuy;
1011         require(buyFeesTotal <= 12, "Must keep fees at 12% or less");
1012     }
1013 
1014     /// @notice Sets the fees for sells
1015     /// @param _treasuryFee The fee for the treasury wallet
1016     /// @param _projectFee The fee for the dev wallet
1017     function setSellFees(
1018         uint256 _treasuryFee,
1019         uint256 _projectFee
1020     ) external onlyOwner {
1021         treasuryFeeSell = _treasuryFee;
1022         projectFeeSell = _projectFee;
1023         sellFeesTotal = treasuryFeeSell + projectFeeSell;
1024         require(sellFeesTotal <= 12, "Must keep fees at 12% or less");
1025     }
1026 
1027     /// @notice Sets if a wallet is excluded from fees
1028     /// @param account The wallet to update
1029     /// @param excluded If the wallet is excluded or not
1030     function excludeFromFees(address account, bool excluded) public onlyOwner {
1031         exemptFromFees[account] = excluded;
1032         emit FeeWhitelist(account, excluded);
1033     }
1034 
1035     /// @notice Sets an address as a new liquidity pair. You probably dont want to do this.
1036     /// @param pair The new pair
1037     function setAutomatedMarketMakerPair(
1038         address pair,
1039         bool value
1040     ) public onlyOwner {
1041         require(
1042             pair != dexPair,
1043             "The pair cannot be removed from isAMMPair"
1044         );
1045 
1046         _setAutomatedMarketMakerPair(pair, value);
1047     }
1048 
1049     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1050         isAMMPair[pair] = value;
1051 
1052         emit SetAMMPair(pair, value);
1053     }
1054 
1055     /// @notice Sets a wallet as the new treasury wallet
1056     /// @param newTreasuryWallet The new treasury wallet
1057     function updateTreasuryWallet(
1058         address newTreasuryWallet
1059     ) external onlyOwner {
1060         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
1061         treasuryWallet = newTreasuryWallet;
1062     }
1063 
1064     /// @notice Sets a wallet as the new dev wallet
1065     /// @param newWallet The new dev wallet
1066     function updateProjectWallet(address newWallet) external onlyOwner {
1067         emit projectWalletUpdated(newWallet, projectWallet);
1068         projectWallet = newWallet;
1069     }
1070 
1071     /// @notice Sets the blacklist status of multiple addresses
1072     /// @param addresses The addresses to update
1073     /// @param isBlacklisted If the addresses are blacklisted or not
1074     function updateBlacklistMultiple(
1075         address[] calldata addresses,
1076         bool isBlacklisted
1077     ) external onlyOwner {
1078         require(canSetBlacklist, "Blacklist is locked");
1079         for (uint256 i = 0; i < addresses.length; i++) {
1080             blacklisted[addresses[i]] = isBlacklisted;
1081         }
1082     }
1083 
1084     /// @notice Removes the owner ability to change the blacklist
1085     function lockBlacklist() external onlyOwner {
1086         canSetBlacklist = false;
1087     }
1088 
1089     function isExcludedFromFees(address account) public view returns (bool) {
1090         return exemptFromFees[account];
1091     }
1092 
1093     function _update(
1094         address from,
1095         address to,
1096         uint256 amount
1097     ) internal override {
1098         if (amount == 0) {
1099             super._update(from, to, 0);
1100             return;
1101         }
1102 
1103         if (tradingLimitsOn) {
1104             if (
1105                 from != owner() &&
1106                 to != owner() &&
1107                 to != address(0) &&
1108                 to != address(0xdead) &&
1109                 !duringContractSell
1110             ) {
1111                 if (!tokenLaunched) {
1112                     require(
1113                         exemptFromFees[from] || exemptFromFees[to],
1114                         "Trading is not active."
1115                     );
1116                 }
1117 
1118                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1119                 if (limitTxsPerBlock) {
1120                     if (
1121                         to != owner() &&
1122                         to != address(dexRouter) &&
1123                         to != address(dexPair)
1124                     ) {
1125                         require(
1126                             _addressLastTransfer[tx.origin] <
1127                                 block.number,
1128                             "_update:: Transfer Delay enabled.  Only one purchase per block allowed."
1129                         );
1130                         _addressLastTransfer[tx.origin] = block.number;
1131                     }
1132                 }
1133 
1134                 //when buy
1135                 if (isAMMPair[from] && !exemptFromMaxLimits[to]) {
1136                     require(
1137                         amount <= maxTx,
1138                         "Buy transfer amount exceeds the maxTx."
1139                     );
1140                     require(
1141                         amount + balanceOf(to) <= maxHold,
1142                         "Max wallet exceeded"
1143                     );
1144                 }
1145                 //when sell
1146                 else if (
1147                     isAMMPair[to] && !exemptFromMaxLimits[from]
1148                 ) {
1149                     require(
1150                         amount <= maxTx,
1151                         "Sell transfer amount exceeds the maxTx."
1152                     );
1153                 } else if (!exemptFromMaxLimits[to]) {
1154                     require(
1155                         amount + balanceOf(to) <= maxHold,
1156                         "Max wallet exceeded"
1157                     );
1158                 }
1159             }
1160         }
1161 
1162         uint256 contractTokenBalance = balanceOf(address(this));
1163 
1164         bool canSwap = contractTokenBalance >= minBalanceForContractSell;
1165 
1166         if (
1167             canSwap &&
1168             contractSellEnabled &&
1169             !duringContractSell &&
1170             !isAMMPair[from] &&
1171             !exemptFromFees[from] &&
1172             !exemptFromFees[to]
1173         ) {
1174             duringContractSell = true;
1175 
1176             swapBack();
1177 
1178             duringContractSell = false;
1179         }
1180 
1181         bool takeFee = !duringContractSell;
1182 
1183         // if any account belongs to _isExcludedFromFee account then remove the fee
1184         if (exemptFromFees[from] || exemptFromFees[to]) {
1185             takeFee = false;
1186         }
1187 
1188         if (!exemptFromFees[from] || !exemptFromFees[to]) {
1189             require(!blacklisted[from], "Address is blacklisted");
1190         }
1191 
1192         uint256 fees = 0;
1193         // only take fees on buys/sells, do not take on wallet transfers
1194         if (takeFee) {
1195             // on sell
1196             if (isAMMPair[to] && sellFeesTotal > 0) {
1197                 fees = amount.mul(sellFeesTotal).div(100);
1198                 tokensToSwapProject += (fees * projectFeeSell) / sellFeesTotal;
1199                 tokensToSwapTreasury += (fees * treasuryFeeSell) / sellFeesTotal;
1200             }
1201             // on buy
1202             else if (isAMMPair[from] && buyFeesTotal > 0) {
1203                 fees = amount.mul(buyFeesTotal).div(100);
1204                 tokensToSwapProject += (fees * projectFeeBuy) / buyFeesTotal;
1205                 tokensToSwapTreasury += (fees * treasuryFeeBuy) / buyFeesTotal;
1206             }
1207 
1208             if (fees > 0) {
1209                 super._update(from, address(this), fees);
1210             }
1211 
1212             amount -= fees;
1213         }
1214 
1215         super._update(from, to, amount);
1216     }
1217 
1218     function swapTokensForEth(uint256 tokenAmount) private {
1219         // generate the uniswap pair path of token -> weth
1220         address[] memory path = new address[](2);
1221         path[0] = address(this);
1222         path[1] = dexRouter.WETH();
1223 
1224         _approve(address(this), address(dexRouter), tokenAmount);
1225 
1226         // make the swap
1227         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1228             tokenAmount,
1229             0, // accept any amount of ETH
1230             path,
1231             address(this),
1232             block.timestamp
1233         );
1234     }
1235 
1236     function swapBack() private {
1237         uint256 contractBalance = balanceOf(address(this));
1238         uint256 totalTokensToSwap = tokensToSwapTreasury + tokensToSwapProject;
1239         bool success;
1240 
1241         if (contractBalance == 0 || totalTokensToSwap == 0) {
1242             return;
1243         }
1244 
1245         if (contractBalance > maxAmountTokensForContractSell) {
1246             contractBalance = maxAmountTokensForContractSell;
1247         }
1248 
1249         uint256 initialETHBalance = address(this).balance;
1250 
1251         swapTokensForEth(contractBalance);
1252 
1253         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1254 
1255         uint256 ethForProject = ethBalance.mul(tokensToSwapProject).div(totalTokensToSwap);
1256 
1257         tokensToSwapTreasury = 0;
1258         tokensToSwapProject = 0;
1259 
1260         (success, ) = address(projectWallet).call{value: ethForProject}("");
1261 
1262         (success, ) = address(treasuryWallet).call{
1263             value: address(this).balance
1264         }("");
1265     }
1266 }