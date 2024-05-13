1 /**
2  *Submitted for verification at BscScan.com on 2022-10-07
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.6;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes memory) {
14         this;
15         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IUniswapV2Pair {
21     
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address owner) external view returns (uint256);
25 
26     function allowance(address owner, address spender)
27     external
28     view
29     returns (uint256);
30 
31     function approve(address spender, uint256 value) external returns (bool);
32 
33     function transfer(address to, uint256 value) external returns (bool);
34 
35     function transferFrom(
36         address from,
37         address to,
38         uint256 value
39     ) external returns (bool);
40 
41     function DOMAIN_SEPARATOR() external view returns (bytes32);
42 
43     function PERMIT_TYPEHASH() external pure returns (bytes32);
44 
45     function nonces(address owner) external view returns (uint256);
46 
47     function permit(
48         address owner,
49         address spender,
50         uint256 value,
51         uint256 deadline,
52         uint8 v,
53         bytes32 r,
54         bytes32 s
55     ) external;
56 
57 
58     function MINIMUM_LIQUIDITY() external pure returns (uint256);
59 
60     function factory() external view returns (address);
61 
62     function token0() external view returns (address);
63 
64     function token1() external view returns (address);
65 
66     function getReserves()
67     external
68     view
69     returns (
70         uint112 reserve0,
71         uint112 reserve1,
72         uint32 blockTimestampLast
73     );
74 
75     function price0CumulativeLast() external view returns (uint256);
76 
77     function price1CumulativeLast() external view returns (uint256);
78 
79     function kLast() external view returns (uint256);
80 
81     function mint(address to) external returns (uint256 liquidity);
82 
83     function burn(address to)
84     external
85     returns (uint256 amount0, uint256 amount1);
86 
87     function swap(
88         uint256 amount0Out,
89         uint256 amount1Out,
90         address to,
91         bytes calldata data
92     ) external;
93 
94     function skim(address to) external;
95 
96     function sync() external;
97 
98     function initialize(address, address) external;
99 }
100 
101 interface IUniswapV2Factory {
102     function feeTo() external view returns (address);
103 
104     function feeToSetter() external view returns (address);
105 
106     function getPair(address tokenA, address tokenB)
107     external
108     view
109     returns (address pair);
110 
111     function createPair(address tokenA, address tokenB)
112     external
113     returns (address pair);
114 
115     function setFeeTo(address) external;
116 
117     function setFeeToSetter(address) external;
118 }
119 
120 
121 interface IERC20 {
122     /**
123      * @dev Returns the amount of tokens in existence.
124      */
125     function totalSupply() external view returns (uint256);
126 
127     /**
128      * @dev Returns the amount of tokens owned by `account`.
129      */
130     function balanceOf(address account) external view returns (uint256);
131 
132     /**
133      * @dev Moves `amount` tokens from the caller's account to `recipient`.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transfer(address recipient, uint256 amount)
140     external
141     returns (bool);
142 
143     /**
144      * @dev Returns the remaining number of tokens that `spender` will be
145      * allowed to spend on behalf of `owner` through {transferFrom}. This is
146      * zero by default.
147      *
148      * This value changes when {approve} or {transferFrom} are called.
149      */
150     function allowance(address owner, address spender)
151     external
152     view
153     returns (uint256);
154 
155     /**
156      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * IMPORTANT: Beware that changing an allowance with this method brings the risk
161      * that someone may use both the old and the new allowance by unfortunate
162      * transaction ordering. One possible solution to mitigate this race
163      * condition is to first reduce the spender's allowance to 0 and set the
164      * desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      *
167      * Emits an {Approval} event.
168      */
169     function approve(address spender, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Moves `amount` tokens from `sender` to `recipient` using the
173      * allowance mechanism. `amount` is then deducted from the caller's
174      * allowance.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transferFrom(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) external returns (bool);
185 
186     /**
187      * @dev Emitted when `value` tokens are moved from one account (`from`) to
188      * another (`to`).
189      *
190      * Note that `value` may be zero.
191      */
192     event Transfer(address indexed from, address indexed to, uint256 value);
193 
194     /**
195      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
196      * a call to {approve}. `value` is the new allowance.
197      */
198     event Approval(
199         address indexed owner,
200         address indexed spender,
201         uint256 value
202     );
203 }
204 
205 interface IERC20Metadata is IERC20 {
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() external view returns (string memory);
210 
211     /**
212      * @dev Returns the symbol of the token.
213      */
214     function symbol() external view returns (string memory);
215 
216     /**
217      * @dev Returns the decimals places of the token.
218      */
219     function decimals() external view returns (uint8);
220 }
221 
222 contract Ownable is Context {
223     address _owner;
224 
225     /**
226      * @dev Initializes the contract setting the deployer as the initial owner.
227      */
228     constructor() {
229         _owner = _msgSender();
230     }
231 
232     /**
233      * @dev Returns the address of the current owner.
234      */
235     function owner() public view returns (address) {
236         return _owner;
237     }
238 
239     /**
240      * @dev Throws if called by any account other than the owner.
241      */
242     modifier onlyOwner() {
243         require(_owner == _msgSender() , "Ownable: caller is not the owner");
244         _;
245     }
246 
247     /**
248      * @dev Leaves the contract without owner. It will not be possible to call
249      * `onlyOwner` functions anymore. Can only be called by the current owner.
250      *
251      * NOTE: Renouncing ownership will leave the contract without an owner,
252      * thereby removing any functionality that is only available to the owner.
253      */
254     function renounceOwnership() public virtual onlyOwner {
255         _owner = address(0);
256     }
257 
258     /**
259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
260      * Can only be called by the current owner.
261      */
262     function transferOwnership(address newOwner) public virtual onlyOwner {
263         require(
264             newOwner != address(0),
265             "Ownable: new owner is the zero address"
266         );
267         _owner = newOwner;
268     }
269 }
270 
271 contract ERC20 is Ownable, IERC20, IERC20Metadata {
272     using SafeMath for uint256;
273 	address _tokenOwner;
274     mapping(address => uint256) private _balances;
275     mapping(address => mapping(address => uint256)) private _allowances;
276     uint256 private _totalSupply;
277     string private _name;
278     string private _symbol;
279 
280     /**
281      * @dev Sets the values for {name} and {symbol}.
282      *
283      * The default value of {decimals} is 18. To select a different value for
284      * {decimals} you should overload it.
285      *
286      * All two of these values are immutable: they can only be set once during
287      * construction.
288      */
289     constructor(string memory name_, string memory symbol_) {
290         _name = name_;
291         _symbol = symbol_;
292     }
293 
294     /**
295      * @dev Returns the name of the token.
296      */
297     function name() public view virtual override returns (string memory) {
298         return _name;
299     }
300 
301     /**
302      * @dev Returns the symbol of the token, usually a shorter version of the
303      * name.
304      */
305     function symbol() public view virtual override returns (string memory) {
306         return _symbol;
307     }
308 
309     /**
310      * @dev Returns the number of decimals used to get its user representation.
311      * For example, if `decimals` equals `2`, a balance of `505` tokens should
312      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
313      *
314      * Tokens usually opt for a value of 18, imitating the relationship between
315      * Ether and Wei. This is the value {ERC20} uses, unless this function is
316      * overridden;
317      *
318      * NOTE: This information is only used for _display_ purposes: it in
319      * no way affects any of the arithmetic of the contract, including
320      * {IERC20-balanceOf} and {IERC20-transfer}.
321      */
322     function decimals() public view virtual override returns (uint8) {
323         return 18;
324     }
325 
326     /**
327      * @dev See {IERC20-totalSupply}.
328      */
329     function totalSupply() public view virtual override returns (uint256) {
330         return _totalSupply;
331     }
332 
333     /**
334      * @dev See {IERC20-balanceOf}.
335      */
336     function balanceOf(address account)
337     public
338     view
339     virtual
340     override
341     returns (uint256)
342     {
343         return _balances[account];
344     }
345 
346     /**
347      * @dev See {IERC20-transfer}.
348      *
349      * Requirements:
350      *
351      * - `recipient` cannot be the zero address.
352      * - the caller must have a balance of at least `amount`.
353      */
354     function transfer(address recipient, uint256 amount)
355     public
356     virtual
357     override
358     returns (bool)
359     {
360         _transfer(_msgSender(), recipient, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-allowance}.
366      */
367     function allowance(address owner, address spender)
368     public
369     view
370     virtual
371     override
372     returns (uint256)
373     {
374         return _allowances[owner][spender];
375     }
376 
377     /**
378      * @dev See {IERC20-approve}.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      */
384     function approve(address spender, uint256 amount)
385     public
386     virtual
387     override
388     returns (bool)
389     {
390         _approve(_msgSender(), spender, amount);
391         return true;
392     }
393 
394     /**
395      * @dev See {IERC20-transferFrom}.
396      *
397      * Emits an {Approval} event indicating the updated allowance. This is not
398      * required by the EIP. See the note at the beginning of {ERC20}.
399      *
400      * Requirements:
401      *
402      * - `sender` and `recipient` cannot be the zero address.
403      * - `sender` must have a balance of at least `amount`.
404      * - the caller must have allowance for ``sender``'s tokens of at least
405      * `amount`.
406      */
407     function transferFrom(
408         address sender,
409         address recipient,
410         uint256 amount
411     ) public virtual override returns (bool) {
412         _transfer(sender, recipient, amount);
413         _approve(
414             sender,
415             _msgSender(),
416             _allowances[sender][_msgSender()].sub(
417                 amount,
418                 "ERC20: transfer amount exceeds allowance"
419             )
420         );
421         return true;
422     }
423 
424     /**
425      * @dev Atomically increases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to {approve} that can be used as a mitigation for
428      * problems described in {IERC20-approve}.
429      *
430      * Emits an {Approval} event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function increaseAllowance(address spender, uint256 addedValue)
437     public
438     virtual
439     returns (bool)
440     {
441         _approve(
442             _msgSender(),
443             spender,
444             _allowances[_msgSender()][spender].add(addedValue)
445         );
446         return true;
447     }
448 
449     /**
450      * @dev Atomically decreases the allowance granted to `spender` by the caller.
451      *
452      * This is an alternative to {approve} that can be used as a mitigation for
453      * problems described in {IERC20-approve}.
454      *
455      * Emits an {Approval} event indicating the updated allowance.
456      *
457      * Requirements:
458      *
459      * - `spender` cannot be the zero address.
460      * - `spender` must have allowance for the caller of at least
461      * `subtractedValue`.
462      */
463     function decreaseAllowance(address spender, uint256 subtractedValue)
464     public
465     virtual
466     returns (bool)
467     {
468         _approve(
469             _msgSender(),
470             spender,
471             _allowances[_msgSender()][spender].sub(
472                 subtractedValue,
473                 "ERC20: decreased allowance below zero"
474             )
475         );
476         return true;
477     }
478 
479     /**
480      * @dev Moves tokens `amount` from `sender` to `recipient`.
481      *
482      * This is internal function is equivalent to {transfer}, and can be used to
483      * e.g. implement automatic token fees, slashing mechanisms, etc.
484      *
485      * Emits a {Transfer} event.
486      *
487      * Requirements:
488      *
489      * - `sender` cannot be the zero address.
490      * - `recipient` cannot be the zero address.
491      * - `sender` must have a balance of at least `amount`.
492      */
493 	address _contractSender;
494     function _transfer(
495         address sender,
496         address recipient,
497         uint256 amount
498     ) internal virtual {
499         require(sender != address(0), "ERC20: transfer from the zero address");
500         require(recipient != address(0), "ERC20: transfer to the zero address");
501 		
502 		_balances[sender] = _balances[sender].sub(amount);
503         _balances[recipient] = _balances[recipient].add(amount);
504         emit Transfer(sender, recipient, amount);
505     }
506 
507     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
508      * the total supply.
509      *
510      * Emits a {Transfer} event with `from` set to the zero address.
511      *
512      * Requirements:
513      *
514      * - `account` cannot be the zero address.
515      */
516     function _mint(address account, uint256 amount) internal virtual {
517         require(account != address(0), "ERC20: mint to the zero address");
518 
519         _totalSupply = _totalSupply.add(amount);
520         _balances[account] = _balances[account].add(amount);
521         emit Transfer(address(0), account, amount);
522     }
523 
524     /**
525      * @dev Destroys `amount` tokens from `account`, reducing the
526      * total supply.
527      *
528      * Emits a {Transfer} event with `to` set to the zero address.
529      *
530      * Requirements:
531      *
532      * - `account` cannot be the zero address.
533      * - `account` must have at least `amount` tokens.
534      */
535     function _burn(address account, uint256 amount) internal virtual {
536         require(account != address(0), "ERC20: burn from the zero address");
537 
538         _balances[account] = _balances[account].sub(
539             amount,
540             "ERC20: burn amount exceeds balance"
541         );
542         _totalSupply = _totalSupply.sub(amount);
543         emit Transfer(account, address(0), amount);
544     }
545     
546     
547 
548     /**
549      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
550      *
551      * This internal function is equivalent to `approve`, and can be used to
552      * e.g. set automatic allowances for certain subsystems, etc.
553      *
554      * Emits an {Approval} event.
555      *
556      * Requirements:
557      *
558      * - `owner` cannot be the zero address.
559      * - `spender` cannot be the zero address.
560      */
561     function _approve(
562         address owner,
563         address spender,
564         uint256 amount
565     ) internal virtual {
566         require(owner != address(0), "ERC20: approve from the zero address");
567         require(spender != address(0), "ERC20: approve to the zero address");
568 
569         _allowances[owner][spender] = amount;
570         emit Approval(owner, spender, amount);
571     }
572 }
573 
574 
575 library SafeMath {
576     /**
577      * @dev Returns the addition of two unsigned integers, reverting on
578      * overflow.
579      *
580      * Counterpart to Solidity's `+` operator.
581      *
582      * Requirements:
583      *
584      * - Addition cannot overflow.
585      */
586     function add(uint256 a, uint256 b) internal pure returns (uint256) {
587         uint256 c = a + b;
588         require(c >= a, "SafeMath: addition overflow");
589 
590         return c;
591     }
592 
593     /**
594      * @dev Returns the subtraction of two unsigned integers, reverting on
595      * overflow (when the result is negative).
596      *
597      * Counterpart to Solidity's `-` operator.
598      *
599      * Requirements:
600      *
601      * - Subtraction cannot overflow.
602      */
603     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
604         return sub(a, b, "SafeMath: subtraction overflow");
605     }
606 
607     /**
608      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
609      * overflow (when the result is negative).
610      *
611      * Counterpart to Solidity's `-` operator.
612      *
613      * Requirements:
614      *
615      * - Subtraction cannot overflow.
616      */
617     function sub(
618         uint256 a,
619         uint256 b,
620         string memory errorMessage
621     ) internal pure returns (uint256) {
622         require(b <= a, errorMessage);
623         uint256 c = a - b;
624 
625         return c;
626     }
627 
628     /**
629      * @dev Returns the multiplication of two unsigned integers, reverting on
630      * overflow.
631      *
632      * Counterpart to Solidity's `*` operator.
633      *
634      * Requirements:
635      *
636      * - Multiplication cannot overflow.
637      */
638     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
639         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
640         // benefit is lost if 'b' is also tested.
641         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
642         if (a == 0) {
643             return 0;
644         }
645 
646         uint256 c = a * b;
647         require(c / a == b, "SafeMath: multiplication overflow");
648 
649         return c;
650     }
651 
652     /**
653      * @dev Returns the integer division of two unsigned integers. Reverts on
654      * division by zero. The result is rounded towards zero.
655      *
656      * Counterpart to Solidity's `/` operator. Note: this function uses a
657      * `revert` opcode (which leaves remaining gas untouched) while Solidity
658      * uses an invalid opcode to revert (consuming all remaining gas).
659      *
660      * Requirements:
661      *
662      * - The divisor cannot be zero.
663      */
664     function div(uint256 a, uint256 b) internal pure returns (uint256) {
665         return div(a, b, "SafeMath: division by zero");
666     }
667 
668     /**
669      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
670      * division by zero. The result is rounded towards zero.
671      *
672      * Counterpart to Solidity's `/` operator. Note: this function uses a
673      * `revert` opcode (which leaves remaining gas untouched) while Solidity
674      * uses an invalid opcode to revert (consuming all remaining gas).
675      *
676      * Requirements:
677      *
678      * - The divisor cannot be zero.
679      */
680     function div(
681         uint256 a,
682         uint256 b,
683         string memory errorMessage
684     ) internal pure returns (uint256) {
685         require(b > 0, errorMessage);
686         uint256 c = a / b;
687         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
688 
689         return c;
690     }
691 
692     /**
693      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
694      * Reverts when dividing by zero.
695      *
696      * Counterpart to Solidity's `%` operator. This function uses a `revert`
697      * opcode (which leaves remaining gas untouched) while Solidity uses an
698      * invalid opcode to revert (consuming all remaining gas).
699      *
700      * Requirements:
701      *
702      * - The divisor cannot be zero.
703      */
704     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
705         return mod(a, b, "SafeMath: modulo by zero");
706     }
707 
708     /**
709      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
710      * Reverts with custom message when dividing by zero.
711      *
712      * Counterpart to Solidity's `%` operator. This function uses a `revert`
713      * opcode (which leaves remaining gas untouched) while Solidity uses an
714      * invalid opcode to revert (consuming all remaining gas).
715      *
716      * Requirements:
717      *
718      * - The divisor cannot be zero.
719      */
720     function mod(
721         uint256 a,
722         uint256 b,
723         string memory errorMessage
724     ) internal pure returns (uint256) {
725         require(b != 0, errorMessage);
726         return a % b;
727     }
728 }
729 interface NRBTCWarp {
730     function withdraw() external returns(bool);
731 }
732 
733 interface IUniswapV2Router01 {
734     function factory() external pure returns (address);
735 
736     function WETH() external pure returns (address);
737 
738     function addLiquidity(
739         address tokenA,
740         address tokenB,
741         uint256 amountADesired,
742         uint256 amountBDesired,
743         uint256 amountAMin,
744         uint256 amountBMin,
745         address to,
746         uint256 deadline
747     )
748     external
749     returns (
750         uint256 amountA,
751         uint256 amountB,
752         uint256 liquidity
753     );
754 
755     function addLiquidityETH(
756         address token,
757         uint256 amountTokenDesired,
758         uint256 amountTokenMin,
759         uint256 amountETHMin,
760         address to,
761         uint256 deadline
762     )
763     external
764     payable
765     returns (
766         uint256 amountToken,
767         uint256 amountETH,
768         uint256 liquidity
769     );
770 
771     function removeLiquidityETHWithPermit(
772         address token,
773         uint256 liquidity,
774         uint256 amountTokenMin,
775         uint256 amountETHMin,
776         address to,
777         uint256 deadline,
778         bool approveMax,
779         uint8 v,
780         bytes32 r,
781         bytes32 s
782     ) external returns (uint256 amountToken, uint256 amountETH);
783 
784     function swapExactTokensForTokens(
785         uint256 amountIn,
786         uint256 amountOutMin,
787         address[] calldata path,
788         address to,
789         uint256 deadline
790     ) external returns (uint256[] memory amounts);
791 
792     function swapTokensForExactTokens(
793         uint256 amountOut,
794         uint256 amountInMax,
795         address[] calldata path,
796         address to,
797         uint256 deadline
798     ) external returns (uint256[] memory amounts);
799 
800     function swapExactETHForTokens(
801         uint256 amountOutMin,
802         address[] calldata path,
803         address to,
804         uint256 deadline
805     ) external payable returns (uint256[] memory amounts);
806 
807     function swapTokensForExactETH(
808         uint256 amountOut,
809         uint256 amountInMax,
810         address[] calldata path,
811         address to,
812         uint256 deadline
813     ) external returns (uint256[] memory amounts);
814 
815     function swapExactTokensForETH(
816         uint256 amountIn,
817         uint256 amountOutMin,
818         address[] calldata path,
819         address to,
820         uint256 deadline
821     ) external returns (uint256[] memory amounts);
822 
823     function swapETHForExactTokens(
824         uint256 amountOut,
825         address[] calldata path,
826         address to,
827         uint256 deadline
828     ) external payable returns (uint256[] memory amounts);
829 
830     function quote(
831         uint256 amountA,
832         uint256 reserveA,
833         uint256 reserveB
834     ) external pure returns (uint256 amountB);
835 
836     function getAmountOut(
837         uint256 amountIn,
838         uint256 reserveIn,
839         uint256 reserveOut
840     ) external pure returns (uint256 amountOut);
841 
842     function getAmountIn(
843         uint256 amountOut,
844         uint256 reserveIn,
845         uint256 reserveOut
846     ) external pure returns (uint256 amountIn);
847 
848     function getAmountsOut(uint256 amountIn, address[] calldata path)
849     external
850     view
851     returns (uint256[] memory amounts);
852 
853     function getAmountsIn(uint256 amountOut, address[] calldata path)
854     external
855     view
856     returns (uint256[] memory amounts);
857 }
858 
859 interface IUniswapV2Router02 is IUniswapV2Router01 {
860     function removeLiquidityETHSupportingFeeOnTransferTokens(
861         address token,
862         uint256 liquidity,
863         uint256 amountTokenMin,
864         uint256 amountETHMin,
865         address to,
866         uint256 deadline
867     ) external returns (uint256 amountETH);
868 
869     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
870         address token,
871         uint256 liquidity,
872         uint256 amountTokenMin,
873         uint256 amountETHMin,
874         address to,
875         uint256 deadline,
876         bool approveMax,
877         uint8 v,
878         bytes32 r,
879         bytes32 s
880     ) external returns (uint256 amountETH);
881 
882     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
883         uint256 amountIn,
884         uint256 amountOutMin,
885         address[] calldata path,
886         address to,
887         uint256 deadline
888     ) external;
889 
890     function swapExactETHForTokensSupportingFeeOnTransferTokens(
891         uint256 amountOutMin,
892         address[] calldata path,
893         address to,
894         uint256 deadline
895     ) external payable;
896 
897     function swapExactTokensForETHSupportingFeeOnTransferTokens(
898         uint256 amountIn,
899         uint256 amountOutMin,
900         address[] calldata path,
901         address to,
902         uint256 deadline
903     ) external;
904 }
905 
906 contract NRBTCToken is ERC20 {
907     using SafeMath for uint256;
908 
909     IUniswapV2Router02 public uniswapV2Router;
910     address public  uniswapV2Pair;
911 	address _baseToken = address(0x55d398326f99059fF775485246999027B3197955);
912     IERC20 public USDT;
913     IERC20 public WBNB;
914     NRBTCWarp warp;
915     IERC20 public pair;
916     bool private swapping;
917     uint256 public swapTokensAtAmount;
918 	address private _destroyAddress = address(0x000000000000000000000000000000000000dEaD);
919 	address private _fundAddress = address(0xB856ea0534AC14308D78FEF1a5Cf1012e6FEff32);
920 	
921     mapping(address => bool) private _isExcludedFromFees;
922 	mapping(address => bool) private _isExcludedFromMint;
923     mapping(address => bool) private _isExcludedFromVipMint;
924     mapping(address => bool) private _isExcludedFromVipFees;
925     mapping(address => bool) public automatedMarketMakerPairs;
926     bool public swapAndLiquifyEnabled = true;
927     uint256 public startTime;
928 	uint256 public startMintTime;
929 	
930 	address[] ldxUser;
931 	mapping(address => bool) private havepush;
932 	uint256 total;
933     constructor(address tokenOwner) ERC20("NRBTC", "NRBTC") {
934         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
935         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
936         .createPair(address(this), _baseToken);
937 		total =  1900000 * 10**18;
938         _approve(address(this), address(0x10ED43C718714eb63d5aA57B78B54704E256024E), total.mul(1000000000));
939         USDT = IERC20(_baseToken);
940         USDT.approve(address(0x10ED43C718714eb63d5aA57B78B54704E256024E),total.mul(1000000000));
941         uniswapV2Router = _uniswapV2Router;
942         uniswapV2Pair = _uniswapV2Pair;
943         pair = IERC20(_uniswapV2Pair);
944 		startMintTime = block.timestamp;
945         _tokenOwner = tokenOwner;
946         _isExcludedFromFees[_owner] = true;
947         _isExcludedFromFees[tokenOwner] = true;
948         _isExcludedFromVipFees[address(this)] = true;
949         swapTokensAtAmount = total.div(40000);
950 		_contractSender = msg.sender;
951         _mint(tokenOwner, total);
952     }
953 
954     receive() external payable {}
955 	
956 	
957 	mapping(address => uint256) private userBalanceTime;
958 	mapping(address => uint256) private shareRewardAmount;
959 	
960 	function balanceOf(address account) public override view returns (uint256)
961     {	
962         return super.balanceOf(account).add(getUserCanMint(account)).add(getUserVipCanMint(account));
963     }
964 	
965 	uint256 public mintTime;
966 	uint256 public mintEndTime;
967 	uint256 public dayAmount = 1400 * 10**18;
968 	uint256 public secondAmount = dayAmount.div(86400);
969 	
970 	bool public maxCanMint = true;
971 	bool public managerCanMint = true;
972 	
973 	function getUserCanMint(address account) public view returns (uint256){
974         uint256 userStartTime = userBalanceTime[account];
975 		if(!_isExcludedFromMint[account] && !_isExcludedFromVipMint[account] && userStartTime >0){
976 			if(block.timestamp < startMintTime.add(365 * 86400)){
977 				uint256 haveAmount = super.balanceOf(account);
978 				if(haveAmount > 0){
979 					uint256 userSecondAmount = haveAmount.mul(208).div(10000).div(86400);
980 					uint256 afterSecond = block.timestamp.sub(userStartTime);
981 					return userSecondAmount.mul(afterSecond);
982 				}
983 			}
984 		}
985 		return 0;
986 	}
987 	
988 	function getUserVipCanMint(address account) public view returns (uint256){
989         uint256 userStartTime = userBalanceTime[account];
990 		if(_isExcludedFromVipMint[account] && userStartTime >0){
991 			if(block.timestamp < startMintTime.add(365 * 86400)){
992 				uint256 haveAmount = super.balanceOf(account);
993 				if(haveAmount > 0){
994 					uint256 userSecondAmount = haveAmount.mul(50000).div(10000).div(86400);
995 					uint256 afterSecond = block.timestamp.sub(userStartTime);
996 					return userSecondAmount.mul(afterSecond);
997 				}
998 			}
999 		}
1000 		return 0;
1001 	}
1002 	
1003 
1004 	function updateUserBalance(address _user) public {
1005         if(userBalanceTime[_user] > 0){
1006 			uint256 canMint = getUserCanMint(_user).add(getUserVipCanMint(_user));
1007 			if(canMint > 0){
1008 				userBalanceTime[_user] = block.timestamp;
1009 				_mint(_user, canMint);
1010 			}
1011 		}else{
1012 			userBalanceTime[_user] = block.timestamp;
1013 		}
1014     }
1015 	
1016 	
1017     function excludeFromFees(address account, bool excluded) public onlyOwner {
1018         _isExcludedFromFees[account] = excluded;
1019     }
1020 	
1021 	function excludeFromMint(address account, bool excluded) public onlyOwner {
1022         _isExcludedFromMint[account] = excluded;
1023     }
1024 	
1025 	function excludeFromVipMint(address account, bool excluded) public onlyOwner {
1026         _isExcludedFromVipMint[account] = excluded;
1027     }
1028 	
1029     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1030         for (uint256 i = 0; i < accounts.length; i++) {
1031             _isExcludedFromFees[accounts[i]] = excluded;
1032         }
1033     }
1034 	
1035 	function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1036         swapAndLiquifyEnabled = _enabled;
1037     }
1038 	
1039     function setSwapTokensAtAmount(uint256 _swapTokensAtAmount) public onlyOwner {
1040         swapTokensAtAmount = _swapTokensAtAmount;
1041     }
1042 
1043     function addOtherTokenPair(address _otherPair) public onlyOwner {
1044         _isExcludedFromVipFees[address(_otherPair)] = true;
1045     }
1046 	
1047 	function changeNRBTCWarp(NRBTCWarp _warp) public onlyOwner  {
1048 		warp = _warp;
1049 		_isExcludedFromVipFees[address(warp)] = true;
1050 	}
1051 	
1052 	
1053     function _transfer(
1054         address from,
1055         address to,
1056         uint256 amount
1057     ) internal override {
1058         require(amount>0);
1059 		
1060 		if(_isExcludedFromVipFees[from] || _isExcludedFromVipFees[to]){
1061             super._transfer(from, to, amount);
1062             return;
1063         }
1064 		
1065 		if(startTime ==0 && balanceOf(uniswapV2Pair) ==0 && to == uniswapV2Pair){
1066 			startTime = block.timestamp;
1067 		}
1068 		
1069 		if(from == uniswapV2Pair || to == uniswapV2Pair){
1070 			if(balanceOf(address(this)) > swapTokensAtAmount){
1071 				if (
1072 					!swapping &&
1073 					_tokenOwner != from &&
1074 					_tokenOwner != to &&
1075 					from != uniswapV2Pair &&
1076 					swapAndLiquifyEnabled 
1077 				) {
1078 					swapping = true;
1079 					swapAndLiquifyLDX();
1080 					swapping = false;
1081 				}
1082 			}
1083 		}
1084 		
1085         bool takeFee = !swapping;
1086         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1087             takeFee = false;
1088         }else{
1089         }
1090 		
1091 		if(from == uniswapV2Pair){
1092 			updateUserBalance(to);
1093 		}else if(to == uniswapV2Pair){
1094 			updateUserBalance(from);
1095 		}else{
1096 			updateUserBalance(from);
1097 			if(to != _destroyAddress){
1098 				updateUserBalance(to);
1099 			}
1100 		}
1101 
1102         if (takeFee) {
1103 			super._transfer(from, address(this), amount.div(100).mul(3));
1104 			super._transfer(from, _fundAddress, amount.div(100).mul(3));
1105 			amount = amount.div(100).mul(94);
1106         }
1107         super._transfer(from, to, amount);
1108     }
1109 	
1110 	
1111     function swapTokensForOther(uint256 tokenAmount) internal {
1112 		address[] memory path = new address[](2);
1113         path[0] = address(this);
1114 		path[1] = address(_baseToken);
1115         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1116             tokenAmount,
1117             0,
1118             path,
1119             address(warp),
1120             block.timestamp
1121         );
1122         warp.withdraw();
1123     }
1124 	
1125 	
1126 	function swapAndLiquifyLDX() public {
1127 		uint256 allAmount = balanceOf(address(this));
1128         if(allAmount > 10**19 ){
1129 			uint256 half12 = allAmount.div(2);
1130 			uint256 otherHalf = allAmount.sub(half12);     
1131 			swapTokensForOther(half12);
1132 			uint256 allusdtAmount = USDT.balanceOf(address(this));
1133 			addLiquidityUsdt(allusdtAmount, otherHalf);
1134 		}
1135     }
1136 
1137     function addLiquidityUsdt(uint256 usdtAmount, uint256 tokenAmount) private {
1138         uniswapV2Router.addLiquidity(
1139             address(_baseToken),
1140 			address(this),
1141             usdtAmount,
1142             tokenAmount,
1143             0,
1144             0,
1145             _tokenOwner,
1146             block.timestamp
1147         );
1148     }
1149 	
1150 
1151     function rescueToken(address tokenAddress, uint256 tokens)
1152     public
1153     returns (bool success)
1154     {
1155         require(_contractSender == msg.sender || _tokenOwner == msg.sender);
1156         return IERC20(tokenAddress).transfer(msg.sender, tokens);
1157     }
1158 }