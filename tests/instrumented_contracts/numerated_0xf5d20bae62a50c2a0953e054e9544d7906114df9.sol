1 /**********
2 🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩
3 
4 POP | Proof of Poodle
5 
6 
7 The first and only contract that yields actual stablecoin LP and constantly burns token supply to pump your investment to the next dimension. And the first LP locker with lowest FEES.
8 Tokenomics
9 Supply: 100 Million
10 Max Buy: 1%
11 Max Wallet: 2%
12 Tax: 4/4
13 
14 Telegram: https://t.me/Poodlejoin
15 Twitter: https://twitter.com/poodleeth
16 Medium: https://poodlefinance.medium.com
17 Website: https://poodle.finance/
18 
19 🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩🐩
20 **/
21 // SPDX-License-Identifier: MIT
22 
23 pragma solidity ^0.8.9;
24 
25 library SafeMath {
26     /**
27      * @dev Returns the addition of two unsigned integers, reverting on
28      * overflow.
29      *
30      * Counterpart to Solidity's `+` operator.
31      *
32      * Requirements:
33      *
34      * - Addition cannot overflow.
35      */
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39 
40         return c;
41     }
42 
43     /**
44      * @dev Returns the subtraction of two unsigned integers, reverting on
45      * overflow (when the result is negative).
46      *
47      * Counterpart to Solidity's `-` operator.
48      *
49      * Requirements:
50      *
51      * - Subtraction cannot overflow.
52      */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      *
65      * - Subtraction cannot overflow.
66      */
67     function sub(
68         uint256 a,
69         uint256 b,
70         string memory errorMessage
71     ) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `*` operator.
83      *
84      * Requirements:
85      *
86      * - Multiplication cannot overflow.
87      */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      *
112      * - The divisor cannot be zero.
113      */
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117 
118     /**
119      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
120      * division by zero. The result is rounded towards zero.
121      *
122      * Counterpart to Solidity's `/` operator. Note: this function uses a
123      * `revert` opcode (which leaves remaining gas untouched) while Solidity
124      * uses an invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      *
128      * - The divisor cannot be zero.
129      */
130     function div(
131         uint256 a,
132         uint256 b,
133         string memory errorMessage
134     ) internal pure returns (uint256) {
135         require(b > 0, errorMessage);
136         uint256 c = a / b;
137         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return mod(a, b, "SafeMath: modulo by zero");
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts with custom message when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function mod(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         require(b != 0, errorMessage);
176         return a % b;
177     }
178 }
179 
180 abstract contract Context {
181     function _msgSender() internal view virtual returns (address) {
182         return msg.sender;
183     }
184 
185     function _msgData() internal view virtual returns (bytes calldata) {
186         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
187         return msg.data;
188     }
189 }
190 
191 contract Ownable is Context {
192     address private _owner;
193 
194     event OwnershipTransferred(
195         address indexed previousOwner,
196         address indexed newOwner
197     );
198 
199     /**
200      * @dev Initializes the contract setting the deployer as the initial owner.
201      */
202     constructor() {
203         address msgSender = _msgSender();
204         _owner = msgSender;
205         emit OwnershipTransferred(address(0), msgSender);
206     }
207 
208     /**
209      * @dev Returns the address of the current owner.
210      */
211     function owner() public view returns (address) {
212         return _owner;
213     }
214 
215     /**
216      * @dev Throws if called by any account other than the owner.
217      */
218     modifier onlyOwner() {
219         require(_owner == _msgSender(), "Ownable: caller is not the owner");
220         _;
221     }
222 
223     /**
224      * @dev Leaves the contract without owner. It will not be possible to call
225      * `onlyOwner` functions anymore. Can only be called by the current owner.
226      *
227      * NOTE: Renouncing ownership will leave the contract without an owner,
228      * thereby removing any functionality that is only available to the owner.
229      */
230     function renounceOwnership() public virtual onlyOwner {
231         emit OwnershipTransferred(_owner, address(0));
232         _owner = address(0);
233     }
234 
235     /**
236      * @dev Transfers ownership of the contract to a new account (`newOwner`).
237      * Can only be called by the current owner.
238      */
239     function transferOwnership(address newOwner) public virtual onlyOwner {
240         require(
241             newOwner != address(0),
242             "Ownable: new owner is the zero address"
243         );
244         emit OwnershipTransferred(_owner, newOwner);
245         _owner = newOwner;
246     }
247 }
248 
249 interface IUniswapV2Pair {
250     event Approval(address indexed owner, address indexed spender, uint value);
251     event Transfer(address indexed from, address indexed to, uint value);
252 
253     function name() external pure returns (string memory);
254 
255     function symbol() external pure returns (string memory);
256 
257     function decimals() external pure returns (uint8);
258 
259     function totalSupply() external view returns (uint);
260 
261     function balanceOf(address owner) external view returns (uint);
262 
263     function allowance(address owner, address spender)
264         external
265         view
266         returns (uint);
267 
268     function approve(address spender, uint value) external returns (bool);
269 
270     function transfer(address to, uint value) external returns (bool);
271 
272     function transferFrom(
273         address from,
274         address to,
275         uint value
276     ) external returns (bool);
277 
278     function DOMAIN_SEPARATOR() external view returns (bytes32);
279 
280     function PERMIT_TYPEHASH() external pure returns (bytes32);
281 
282     function nonces(address owner) external view returns (uint);
283 
284     function permit(
285         address owner,
286         address spender,
287         uint value,
288         uint deadline,
289         uint8 v,
290         bytes32 r,
291         bytes32 s
292     ) external;
293 
294     event Mint(address indexed sender, uint amount0, uint amount1);
295     event Burn(
296         address indexed sender,
297         uint amount0,
298         uint amount1,
299         address indexed to
300     );
301     event Swap(
302         address indexed sender,
303         uint amount0In,
304         uint amount1In,
305         uint amount0Out,
306         uint amount1Out,
307         address indexed to
308     );
309     event Sync(uint112 reserve0, uint112 reserve1);
310 
311     function MINIMUM_LIQUIDITY() external pure returns (uint);
312 
313     function factory() external view returns (address);
314 
315     function token0() external view returns (address);
316 
317     function token1() external view returns (address);
318 
319     function getReserves()
320         external
321         view
322         returns (
323             uint112 reserve0,
324             uint112 reserve1,
325             uint32 blockTimestampLast
326         );
327 
328     function price0CumulativeLast() external view returns (uint);
329 
330     function price1CumulativeLast() external view returns (uint);
331 
332     function kLast() external view returns (uint);
333 
334     function mint(address to) external returns (uint liquidity);
335 
336     function burn(address to) external returns (uint amount0, uint amount1);
337 
338     function swap(
339         uint amount0Out,
340         uint amount1Out,
341         address to,
342         bytes calldata data
343     ) external;
344 
345     function skim(address to) external;
346 
347     function sync() external;
348 
349     function initialize(address, address) external;
350 }
351 
352 interface IUniswapV2Factory {
353     event PairCreated(
354         address indexed token0,
355         address indexed token1,
356         address pair,
357         uint
358     );
359 
360     function feeTo() external view returns (address);
361 
362     function feeToSetter() external view returns (address);
363 
364     function getPair(address tokenA, address tokenB)
365         external
366         view
367         returns (address pair);
368 
369     function allPairs(uint) external view returns (address pair);
370 
371     function allPairsLength() external view returns (uint);
372 
373     function createPair(address tokenA, address tokenB)
374         external
375         returns (address pair);
376 
377     function setFeeTo(address) external;
378 
379     function setFeeToSetter(address) external;
380 }
381 
382 interface IUniswapV2Router01 {
383     function factory() external pure returns (address);
384 
385     function WETH() external pure returns (address);
386 
387     function addLiquidity(
388         address tokenA,
389         address tokenB,
390         uint amountADesired,
391         uint amountBDesired,
392         uint amountAMin,
393         uint amountBMin,
394         address to,
395         uint deadline
396     )
397         external
398         returns (
399             uint amountA,
400             uint amountB,
401             uint liquidity
402         );
403 
404     function addLiquidityETH(
405         address token,
406         uint amountTokenDesired,
407         uint amountTokenMin,
408         uint amountETHMin,
409         address to,
410         uint deadline
411     )
412         external
413         payable
414         returns (
415             uint amountToken,
416             uint amountETH,
417             uint liquidity
418         );
419 
420     function removeLiquidity(
421         address tokenA,
422         address tokenB,
423         uint liquidity,
424         uint amountAMin,
425         uint amountBMin,
426         address to,
427         uint deadline
428     ) external returns (uint amountA, uint amountB);
429 
430     function removeLiquidityETH(
431         address token,
432         uint liquidity,
433         uint amountTokenMin,
434         uint amountETHMin,
435         address to,
436         uint deadline
437     ) external returns (uint amountToken, uint amountETH);
438 
439     function removeLiquidityWithPermit(
440         address tokenA,
441         address tokenB,
442         uint liquidity,
443         uint amountAMin,
444         uint amountBMin,
445         address to,
446         uint deadline,
447         bool approveMax,
448         uint8 v,
449         bytes32 r,
450         bytes32 s
451     ) external returns (uint amountA, uint amountB);
452 
453     function removeLiquidityETHWithPermit(
454         address token,
455         uint liquidity,
456         uint amountTokenMin,
457         uint amountETHMin,
458         address to,
459         uint deadline,
460         bool approveMax,
461         uint8 v,
462         bytes32 r,
463         bytes32 s
464     ) external returns (uint amountToken, uint amountETH);
465 
466     function swapExactTokensForTokens(
467         uint amountIn,
468         uint amountOutMin,
469         address[] calldata path,
470         address to,
471         uint deadline
472     ) external returns (uint[] memory amounts);
473 
474     function swapTokensForExactTokens(
475         uint amountOut,
476         uint amountInMax,
477         address[] calldata path,
478         address to,
479         uint deadline
480     ) external returns (uint[] memory amounts);
481 
482     function swapExactETHForTokens(
483         uint amountOutMin,
484         address[] calldata path,
485         address to,
486         uint deadline
487     ) external payable returns (uint[] memory amounts);
488 
489     function swapTokensForExactETH(
490         uint amountOut,
491         uint amountInMax,
492         address[] calldata path,
493         address to,
494         uint deadline
495     ) external returns (uint[] memory amounts);
496 
497     function swapExactTokensForETH(
498         uint amountIn,
499         uint amountOutMin,
500         address[] calldata path,
501         address to,
502         uint deadline
503     ) external returns (uint[] memory amounts);
504 
505     function swapETHForExactTokens(
506         uint amountOut,
507         address[] calldata path,
508         address to,
509         uint deadline
510     ) external payable returns (uint[] memory amounts);
511 
512     function quote(
513         uint amountA,
514         uint reserveA,
515         uint reserveB
516     ) external pure returns (uint amountB);
517 
518     function getAmountOut(
519         uint amountIn,
520         uint reserveIn,
521         uint reserveOut
522     ) external pure returns (uint amountOut);
523 
524     function getAmountIn(
525         uint amountOut,
526         uint reserveIn,
527         uint reserveOut
528     ) external pure returns (uint amountIn);
529 
530     function getAmountsOut(uint amountIn, address[] calldata path)
531         external
532         view
533         returns (uint[] memory amounts);
534 
535     function getAmountsIn(uint amountOut, address[] calldata path)
536         external
537         view
538         returns (uint[] memory amounts);
539 }
540 
541 // pragma solidity >=0.6.2;
542 
543 interface IUniswapV2Router02 is IUniswapV2Router01 {
544     function removeLiquidityETHSupportingFeeOnTransferTokens(
545         address token,
546         uint liquidity,
547         uint amountTokenMin,
548         uint amountETHMin,
549         address to,
550         uint deadline
551     ) external returns (uint amountETH);
552 
553     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
554         address token,
555         uint liquidity,
556         uint amountTokenMin,
557         uint amountETHMin,
558         address to,
559         uint deadline,
560         bool approveMax,
561         uint8 v,
562         bytes32 r,
563         bytes32 s
564     ) external returns (uint amountETH);
565 
566     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
567         uint amountIn,
568         uint amountOutMin,
569         address[] calldata path,
570         address to,
571         uint deadline
572     ) external;
573 
574     function swapExactETHForTokensSupportingFeeOnTransferTokens(
575         uint amountOutMin,
576         address[] calldata path,
577         address to,
578         uint deadline
579     ) external payable;
580 
581     function swapExactTokensForETHSupportingFeeOnTransferTokens(
582         uint amountIn,
583         uint amountOutMin,
584         address[] calldata path,
585         address to,
586         uint deadline
587     ) external;
588 }
589 
590 interface IERC20 {
591     /**
592      * @dev Returns the amount of tokens in existence.
593      */
594     function totalSupply() external view returns (uint256);
595 
596     /**
597      * @dev Returns the amount of tokens owned by `account`.
598      */
599     function balanceOf(address account) external view returns (uint256);
600 
601     /**
602      * @dev Moves `amount` tokens from the caller's account to `recipient`.
603      *
604      * Returns a boolean value indicating whether the operation succeeded.
605      *
606      * Emits a {Transfer} event.
607      */
608     function transfer(address recipient, uint256 amount)
609         external
610         returns (bool);
611 
612     /**
613      * @dev Returns the remaining number of tokens that `spender` will be
614      * allowed to spend on behalf of `owner` through {transferFrom}. This is
615      * zero by default.
616      *
617      * This value changes when {approve} or {transferFrom} are called.
618      */
619     function allowance(address owner, address spender)
620         external
621         view
622         returns (uint256);
623 
624     /**
625      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
626      *
627      * Returns a boolean value indicating whether the operation succeeded.
628      *
629      * IMPORTANT: Beware that changing an allowance with this method brings the risk
630      * that someone may use both the old and the new allowance by unfortunate
631      * transaction ordering. One possible solution to mitigate this race
632      * condition is to first reduce the spender's allowance to 0 and set the
633      * desired value afterwards:
634      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
635      *
636      * Emits an {Approval} event.
637      */
638     function approve(address spender, uint256 amount) external returns (bool);
639 
640     /**
641      * @dev Moves `amount` tokens from `sender` to `recipient` using the
642      * allowance mechanism. `amount` is then deducted from the caller's
643      * allowance.
644      *
645      * Returns a boolean value indicating whether the operation succeeded.
646      *
647      * Emits a {Transfer} event.
648      */
649     function transferFrom(
650         address sender,
651         address recipient,
652         uint256 amount
653     ) external returns (bool);
654 
655     /**
656      * @dev Emitted when `value` tokens are moved from one account (`from`) to
657      * another (`to`).
658      *
659      * Note that `value` may be zero.
660      */
661     event Transfer(address indexed from, address indexed to, uint256 value);
662 
663     /**
664      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
665      * a call to {approve}. `value` is the new allowance.
666      */
667     event Approval(
668         address indexed owner,
669         address indexed spender,
670         uint256 value
671     );
672 }
673 
674 interface IERC20Metadata is IERC20 {
675     /**
676      * @dev Returns the name of the token.
677      */
678     function name() external view returns (string memory);
679 
680     /**
681      * @dev Returns the symbol of the token.
682      */
683     function symbol() external view returns (string memory);
684 
685     /**
686      * @dev Returns the decimals places of the token.
687      */
688     function decimals() external view returns (uint8);
689 }
690 
691 contract ERC20 is Context, IERC20, IERC20Metadata {
692     using SafeMath for uint256;
693 
694     mapping(address => uint256) private _balances;
695 
696     mapping(address => mapping(address => uint256)) private _allowances;
697 
698     uint256 private _totalSupply;
699 
700     string private _name;
701     string private _symbol;
702 
703     /**
704      * @dev Sets the values for {name} and {symbol}.
705      *
706      * The default value of {decimals} is 18. To select a different value for
707      * {decimals} you should overload it.
708      *
709      * All two of these values are immutable: they can only be set once during
710      * construction.
711      */
712     constructor(string memory name_, string memory symbol_) {
713         _name = name_;
714         _symbol = symbol_;
715     }
716 
717     /**
718      * @dev Returns the name of the token.
719      */
720     function name() public view virtual override returns (string memory) {
721         return _name;
722     }
723 
724     /**
725      * @dev Returns the symbol of the token, usually a shorter version of the
726      * name.
727      */
728     function symbol() public view virtual override returns (string memory) {
729         return _symbol;
730     }
731 
732     /**
733      * @dev Returns the number of decimals used to get its user representation.
734      * For example, if `decimals` equals `2`, a balance of `505` tokens should
735      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
736      *
737      * Tokens usually opt for a value of 18, imitating the relationship between
738      * Ether and Wei. This is the value {ERC20} uses, unless this function is
739      * overridden;
740      *
741      * NOTE: This information is only used for _display_ purposes: it in
742      * no way affects any of the arithmetic of the contract, including
743      * {IERC20-balanceOf} and {IERC20-transfer}.
744      */
745     function decimals() public view virtual override returns (uint8) {
746         return 18;
747     }
748 
749     /**
750      * @dev See {IERC20-totalSupply}.
751      */
752     function totalSupply() public view virtual override returns (uint256) {
753         return _totalSupply;
754     }
755 
756     /**
757      * @dev See {IERC20-balanceOf}.
758      */
759     function balanceOf(address account)
760         public
761         view
762         virtual
763         override
764         returns (uint256)
765     {
766         return _balances[account];
767     }
768 
769     /**
770      * @dev See {IERC20-transfer}.
771      *
772      * Requirements:
773      *
774      * - `recipient` cannot be the zero address.
775      * - the caller must have a balance of at least `amount`.
776      */
777     function transfer(address recipient, uint256 amount)
778         public
779         virtual
780         override
781         returns (bool)
782     {
783         _transfer(_msgSender(), recipient, amount);
784         return true;
785     }
786 
787     /**
788      * @dev See {IERC20-allowance}.
789      */
790     function allowance(address owner, address spender)
791         public
792         view
793         virtual
794         override
795         returns (uint256)
796     {
797         return _allowances[owner][spender];
798     }
799 
800     /**
801      * @dev See {IERC20-approve}.
802      *
803      * Requirements:
804      *
805      * - `spender` cannot be the zero address.
806      */
807     function approve(address spender, uint256 amount)
808         public
809         virtual
810         override
811         returns (bool)
812     {
813         _approve(_msgSender(), spender, amount);
814         return true;
815     }
816 
817     /**
818      * @dev See {IERC20-transferFrom}.
819      *
820      * Emits an {Approval} event indicating the updated allowance. This is not
821      * required by the EIP. See the note at the beginning of {ERC20}.
822      *
823      * Requirements:
824      *
825      * - `sender` and `recipient` cannot be the zero address.
826      * - `sender` must have a balance of at least `amount`.
827      * - the caller must have allowance for ``sender``'s tokens of at least
828      * `amount`.
829      */
830     function transferFrom(
831         address sender,
832         address recipient,
833         uint256 amount
834     ) public virtual override returns (bool) {
835         _transfer(sender, recipient, amount);
836         _approve(
837             sender,
838             _msgSender(),
839             _allowances[sender][_msgSender()].sub(
840                 amount,
841                 "ERC20: transfer amount exceeds allowance"
842             )
843         );
844         return true;
845     }
846 
847     /**
848      * @dev Atomically increases the allowance granted to `spender` by the caller.
849      *
850      * This is an alternative to {approve} that can be used as a mitigation for
851      * problems described in {IERC20-approve}.
852      *
853      * Emits an {Approval} event indicating the updated allowance.
854      *
855      * Requirements:
856      *
857      * - `spender` cannot be the zero address.
858      */
859     function increaseAllowance(address spender, uint256 addedValue)
860         public
861         virtual
862         returns (bool)
863     {
864         _approve(
865             _msgSender(),
866             spender,
867             _allowances[_msgSender()][spender].add(addedValue)
868         );
869         return true;
870     }
871 
872     /**
873      * @dev Atomically decreases the allowance granted to `spender` by the caller.
874      *
875      * This is an alternative to {approve} that can be used as a mitigation for
876      * problems described in {IERC20-approve}.
877      *
878      * Emits an {Approval} event indicating the updated allowance.
879      *
880      * Requirements:
881      *
882      * - `spender` cannot be the zero address.
883      * - `spender` must have allowance for the caller of at least
884      * `subtractedValue`.
885      */
886     function decreaseAllowance(address spender, uint256 subtractedValue)
887         public
888         virtual
889         returns (bool)
890     {
891         _approve(
892             _msgSender(),
893             spender,
894             _allowances[_msgSender()][spender].sub(
895                 subtractedValue,
896                 "ERC20: decreased allowance below zero"
897             )
898         );
899         return true;
900     }
901 
902     /**
903      * @dev Moves tokens `amount` from `sender` to `recipient`.
904      *
905      * This is internal function is equivalent to {transfer}, and can be used to
906      * e.g. implement automatic token fees, slashing mechanisms, etc.
907      *
908      * Emits a {Transfer} event.
909      *
910      * Requirements:
911      *
912      * - `sender` cannot be the zero address.
913      * - `recipient` cannot be the zero address.
914      * - `sender` must have a balance of at least `amount`.
915      */
916     function _transfer(
917         address sender,
918         address recipient,
919         uint256 amount
920     ) internal virtual {
921         require(sender != address(0), "ERC20: transfer from the zero address");
922         require(recipient != address(0), "ERC20: transfer to the zero address");
923 
924         _beforeTokenTransfer(sender, recipient, amount);
925 
926         _balances[sender] = _balances[sender].sub(
927             amount,
928             "ERC20: transfer amount exceeds balance"
929         );
930         _balances[recipient] = _balances[recipient].add(amount);
931         emit Transfer(sender, recipient, amount);
932     }
933 
934     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
935      * the total supply.
936      *
937      * Emits a {Transfer} event with `from` set to the zero address.
938      *
939      * Requirements:
940      *
941      * - `account` cannot be the zero address.
942      */
943     function _mint(address account, uint256 amount) internal virtual {
944         require(account != address(0), "ERC20: mint to the zero address");
945 
946         _beforeTokenTransfer(address(0), account, amount);
947 
948         _totalSupply = _totalSupply.add(amount);
949         _balances[account] = _balances[account].add(amount);
950         emit Transfer(address(0), account, amount);
951     }
952 
953     /**
954      * @dev Destroys `amount` tokens from `account`, reducing the
955      * total supply.
956      *
957      * Emits a {Transfer} event with `to` set to the zero address.
958      *
959      * Requirements:
960      *
961      * - `account` cannot be the zero address.
962      * - `account` must have at least `amount` tokens.
963      */
964 
965     /**
966      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
967      *
968      * This internal function is equivalent to `approve`, and can be used to
969      * e.g. set automatic allowances for certain subsystems, etc.
970      *
971      * Emits an {Approval} event.
972      *
973      * Requirements:
974      *
975      * - `owner` cannot be the zero address.
976      * - `spender` cannot be the zero address.
977      */
978     function _approve(
979         address owner,
980         address spender,
981         uint256 amount
982     ) internal virtual {
983         require(owner != address(0), "ERC20: approve from the zero address");
984         require(spender != address(0), "ERC20: approve to the zero address");
985 
986         _allowances[owner][spender] = amount;
987         emit Approval(owner, spender, amount);
988     }
989 
990     /**
991      * @dev Hook that is called before any transfer of tokens. This includes
992      * minting and burning.
993      *
994      * Calling conditions:
995      *
996      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
997      * will be to transferred to `to`.
998      * - when `from` is zero, `amount` tokens will be minted for `to`.
999      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1000      * - `from` and `to` are never both zero.
1001      *
1002      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1003      */
1004     function _beforeTokenTransfer(
1005         address from,
1006         address to,
1007         uint256 amount
1008     ) internal virtual {}
1009 }
1010 
1011 contract USDCManager is Ownable {
1012     address public immutable USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
1013 
1014     function transferUSDC(address _to) external onlyOwner {
1015         IERC20 usdcContract = IERC20(USDC);
1016         uint256 _balance = usdcContract.balanceOf(address(this));
1017         require(usdcContract.transfer(_to, _balance) == true);
1018     }
1019 }
1020 
1021 contract ProofOfPoodle is ERC20, Ownable {
1022     using SafeMath for uint256;
1023 
1024     IUniswapV2Router02 public uniswapV2Router;
1025     address public immutable uniswapV2Pair;
1026 
1027     bool private swapping;
1028 
1029     address public liquidityWallet;
1030     address public immutable deadAddress =
1031         0x000000000000000000000000000000000000dEaD;
1032     address public immutable USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
1033     USDCManager public usdcManager;
1034 
1035     uint256 public maxSellTransactionAmount = 100000000 * (10**18);
1036     uint256 public swapTokensAtAmount = 20000;
1037 
1038     uint256 public burnFees;
1039     uint256 public devFees;
1040     uint256 public marketingFees;
1041 
1042     address payable marketingWallet =
1043         payable(0xF32C99F672da4FA1d48B5e9abc3FB9f26f55Dfa0);
1044 
1045     address payable devWallet =
1046         payable(0xF32C99F672da4FA1d48B5e9abc3FB9f26f55Dfa0);
1047 
1048     uint256 public liquidityFee;
1049     uint256 public totalFees;
1050 
1051     bool public swapAndLiquifyEnabled = false;
1052 
1053     bool public limitsInEffect = true;
1054     bool public transferDelayEnabled = true;
1055     // mapping(address => uint256) private _holderLastTransferTimestamp;
1056     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1057     uint256 public maxWallet;
1058     uint256 public maxTransactionAmount;
1059 
1060     // exlcude from fees and max transaction amount
1061     mapping(address => bool) private _isExcludedFromFees;
1062 
1063     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1064     // could be subject to a maximum transfer amount
1065     mapping(address => bool) public automatedMarketMakerPairs;
1066 
1067     event UpdateUniswapV2Router(
1068         address indexed newAddress,
1069         address indexed oldAddress
1070     );
1071 
1072     event ExcludeFromFees(address indexed account, bool isExcluded);
1073     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1074 
1075     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1076 
1077     event LiquidityWalletUpdated(
1078         address indexed newLiquidityWallet,
1079         address indexed oldLiquidityWallet
1080     );
1081 
1082     event LiquidityFeeChanged(uint256 oldFee, uint256 newFee);
1083     event BurnFeeChanged(uint256 oldFee, uint256 newFee);
1084     event devFeeChanged(uint256 oldFee, uint256 newFee);
1085     event marketingFeeChanged(uint256 oldFee, uint256 newFee);
1086 
1087     event SwapAndLiquify(
1088         uint256 tokensSwapped,
1089         uint256 ethReceived,
1090         uint256 tokensIntoLiqudity
1091     );
1092 
1093     event SwapAndLiquifyEnabledUpdated(bool enabled);
1094 
1095     event SwapETHForTokens(uint256 amountIn, address[] path);
1096 
1097     constructor() ERC20("ProofOfPoodle", "POP") {
1098         uint256 _liquidityFee = 0;
1099         uint256 _burnFees = 0;
1100         uint256 _marketingFees = 0;
1101         uint256 _devFees = 7;
1102         usdcManager = new USDCManager();
1103         liquidityFee = _liquidityFee;
1104         burnFees = _burnFees;
1105         marketingFees = _marketingFees;
1106         devFees = _devFees;
1107 
1108         totalFees = _liquidityFee + _burnFees + _marketingFees + _devFees;
1109 
1110         liquidityWallet = owner();
1111 
1112         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1113             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1114         );
1115         // Create a uniswap pair for this new token
1116         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1117             .createPair(address(this), USDC);
1118 
1119         uniswapV2Router = _uniswapV2Router;
1120         uniswapV2Pair = _uniswapV2Pair;
1121 
1122         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1123         _setAutomatedMarketMakerPair(address(this), true);
1124 
1125         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1126         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1127 
1128         excludeFromMaxTransaction(owner(), true);
1129         excludeFromMaxTransaction(address(this), true);
1130         excludeFromMaxTransaction(address(0xdead), true);
1131         // exclude from paying fees or having max transaction amount
1132         excludeFromFees(liquidityWallet, true);
1133 
1134         excludeFromFees(address(this), true);
1135         _isExcludedFromFees[owner()] = true;
1136 
1137         maxWallet = (100000000 * (10**18) * 2) / 100; // 2% Max wallet
1138         maxTransactionAmount = (100000000 * (10**18) * 1) / 100; // 1% maxTransactionAmountTxn
1139 
1140         // enable owner and fixed-sale wallet to send tokens before presales are over
1141 
1142         /*
1143             _mint is an internal function in ERC20.sol that is only called here,
1144             and CANNOT be called ever again
1145         */
1146         _mint(owner(), 100000000 * (10**18));
1147     }
1148 
1149     receive() external payable {}
1150 
1151     function updateUniswapV2Router(address newAddress) public onlyOwner {
1152         address _uniswapV2Router = address(uniswapV2Router);
1153         require(newAddress != _uniswapV2Router);
1154         emit UpdateUniswapV2Router(newAddress, _uniswapV2Router);
1155         uniswapV2Router = IUniswapV2Router02(newAddress);
1156     }
1157 
1158     function changeLiquidityFee(uint256 _liquidityFee) public onlyOwner {
1159         require(_liquidityFee <= 10, "Must keep fees at 10% or less");
1160         emit LiquidityFeeChanged(liquidityFee, _liquidityFee);
1161         liquidityFee = _liquidityFee;
1162         totalFees = _liquidityFee + burnFees + marketingFees + devFees;
1163     }
1164 
1165     function changeBurnFee(uint256 _burnFee) public onlyOwner {
1166         require(_burnFee <= 10, "Must keep fees at 10% or less");
1167         emit BurnFeeChanged(burnFees, _burnFee);
1168         burnFees = _burnFee;
1169         totalFees = liquidityFee + _burnFee + marketingFees + devFees;
1170     }
1171 
1172     function changeDevFees(uint256 _devFees) public onlyOwner  {
1173         require(_devFees <= 10, "Must keep fees at 10% or less");
1174         emit devFeeChanged(devFees, _devFees);
1175         devFees = _devFees;
1176         totalFees = liquidityFee + burnFees + marketingFees + _devFees;
1177     }
1178 
1179     function changeMarketingFees(uint256 _marketingFees) public onlyOwner  {
1180         require(_marketingFees <= 10, "Must keep fees at 10% or less");
1181         emit marketingFeeChanged(marketingFees, _marketingFees);
1182         marketingFees = _marketingFees;
1183         totalFees = liquidityFee + burnFees + _marketingFees + devFees;
1184     }
1185 
1186     function excludeFromFees(address account, bool excluded) public onlyOwner {
1187         require(_isExcludedFromFees[account] != excluded);
1188         _isExcludedFromFees[account] = excluded;
1189 
1190         emit ExcludeFromFees(account, excluded);
1191     }
1192 
1193     function excludeMultipleAccountsFromFees(
1194         address[] calldata accounts,
1195         bool excluded
1196     ) public onlyOwner {
1197         for (uint256 i = 0; i < accounts.length; i++) {
1198             _isExcludedFromFees[accounts[i]] = excluded;
1199         }
1200 
1201         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1202     }
1203 
1204     function setAutomatedMarketMakerPair(address pair, bool value)
1205         public
1206         onlyOwner
1207     {
1208         require(pair != uniswapV2Pair);
1209 
1210         _setAutomatedMarketMakerPair(pair, value);
1211     }
1212 
1213     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1214         require(automatedMarketMakerPairs[pair] != value);
1215         automatedMarketMakerPairs[pair] = value;
1216 
1217         emit SetAutomatedMarketMakerPair(pair, value);
1218     }
1219 
1220     function updateLiquidityWallet(address newLiquidityWallet)
1221         public
1222         onlyOwner
1223     {
1224         require(newLiquidityWallet != liquidityWallet);
1225         excludeFromFees(newLiquidityWallet, true);
1226         emit LiquidityWalletUpdated(newLiquidityWallet, liquidityWallet);
1227         liquidityWallet = newLiquidityWallet;
1228     }
1229 
1230     function isExcludedFromFees(address account) public view returns (bool) {
1231         return _isExcludedFromFees[account];
1232     }
1233 
1234     function removeLimits() external onlyOwner returns (bool) {
1235         limitsInEffect = false;
1236         transferDelayEnabled = false;
1237         return true;
1238     }
1239 
1240     function excludeFromMaxTransaction(address updAds, bool isEx)
1241         public
1242         onlyOwner
1243     {
1244         _isExcludedMaxTransactionAmount[updAds] = isEx;
1245     }
1246 
1247     function _transfer(
1248         address from,
1249         address to,
1250         uint256 amount
1251     ) internal override {
1252         require(from != address(0));
1253         require(to != address(0));
1254 
1255         if (amount == 0) {
1256             super._transfer(from, to, 0);
1257             return;
1258         }
1259 
1260         if (limitsInEffect) {
1261             if (
1262                 from != owner() &&
1263                 to != owner() &&
1264                 to != address(0) &&
1265                 to != address(0xdead) &&
1266                 !swapping
1267             ) {
1268                 //when buy
1269                 if (
1270                     automatedMarketMakerPairs[from] &&
1271                     !_isExcludedMaxTransactionAmount[to]
1272                 ) {
1273                     require(
1274                         amount + balanceOf(to) <= maxWallet,
1275                         "Unable to exceed Max Wallet"
1276                     );
1277                 }
1278                 //when sell
1279                 else if (
1280                     automatedMarketMakerPairs[to] &&
1281                     !_isExcludedMaxTransactionAmount[from]
1282                 ) {
1283                     require(
1284                         amount <= maxTransactionAmount,
1285                         "Sell transfer amount exceeds the maxTransactionAmount."
1286                     );
1287                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1288                     require(
1289                         amount + balanceOf(to) <= maxWallet,
1290                         "Unable to exceed Max Wallet"
1291                     );
1292                 }
1293             }
1294         }
1295 
1296         if (
1297             !swapping &&
1298             automatedMarketMakerPairs[to] && // sells only by detecting transfer to automated market maker pair
1299             from != address(uniswapV2Router) && //router -> pair is removing liquidity which shouldn't have max
1300             !_isExcludedFromFees[to] //no max for those excluded from fees
1301         ) {
1302             require(amount <= maxSellTransactionAmount);
1303         }
1304 
1305         uint256 contractTokenBalance = balanceOf(address(this));
1306 
1307         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1308 
1309         if (
1310             canSwap &&
1311             !swapping &&
1312             !automatedMarketMakerPairs[from] &&
1313             from != liquidityWallet &&
1314             to != liquidityWallet
1315         ) {
1316             swapping = true;
1317 
1318             uint256 swapTokens = contractTokenBalance.mul(liquidityFee).div(
1319                 totalFees
1320             );
1321             if(swapTokens>0){
1322             swapAndLiquify(swapTokens);
1323             }
1324 
1325             uint256 sellTokens = balanceOf(address(this));
1326             swapAndDistribute(sellTokens);
1327 
1328             swapping = false;
1329         }
1330 
1331         bool takeFee = !swapping;
1332 
1333         // if any account belongs to _isExcludedFromFee account then remove the fee
1334         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1335             takeFee = false;
1336         }
1337 
1338         if (takeFee) {
1339             uint256 fees = amount.mul(totalFees).div(100);
1340 
1341             amount = amount.sub(fees);
1342 
1343             super._transfer(from, address(this), fees);
1344         }
1345 
1346         super._transfer(from, to, amount);
1347     }
1348 
1349     function swapUSDCForTokens(uint256 amount) public {
1350         // generate the uniswap pair path of token -> weth
1351         address[] memory path = new address[](2);
1352         path[0] = USDC;
1353         path[1] = address(this);
1354         IERC20 USDCcontract = IERC20(USDC);
1355         USDCcontract.approve(address(uniswapV2Router), amount);
1356         // make the swap
1357         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1358             amount,
1359             0, // accept any amount of Tokens
1360             path,
1361             deadAddress, // Burn address
1362             block.timestamp.add(300)
1363         );
1364 
1365         emit SwapETHForTokens(amount, path);
1366     }
1367 
1368     function swapAndLiquify(uint256 tokens) private {
1369         // split the contract balance into halves
1370         uint256 half = tokens.div(2);
1371         uint256 otherHalf = tokens.sub(half);
1372         IERC20 USDCcontract = IERC20(USDC);
1373         // capture the contract's current ETH balance.
1374         // this is so that we can capture exactly the amount of ETH that the
1375         // swap creates, and not make the liquidity event include any ETH that
1376         // has been manually sent to the contract
1377         uint256 initialBalance = USDCcontract.balanceOf(address(this));
1378 
1379         // swap tokens for ETH
1380         swapTokensForUSDC(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1381         usdcManager.transferUSDC(address(this));
1382         // how much ETH did we just swap into?
1383         uint256 newBalance = USDCcontract.balanceOf(address(this)).sub(
1384             initialBalance
1385         );
1386 
1387         // add liquidity to uniswap
1388         addLiquidity(otherHalf, newBalance);
1389 
1390         emit SwapAndLiquify(half, newBalance, otherHalf);
1391     }
1392 
1393     function swapTokensForUSDC(uint256 tokenAmount) private {
1394         // generate the uniswap pair path of token -> weth
1395         address[] memory path = new address[](2);
1396         path[0] = address(this);
1397         path[1] = USDC;
1398 
1399         _approve(address(this), address(uniswapV2Router), tokenAmount * 10);
1400 
1401         // make the swap
1402         uniswapV2Router.swapExactTokensForTokens(
1403             tokenAmount,
1404             0, // accept any amount of ETH
1405             path,
1406             address(usdcManager),
1407             block.timestamp.add(3000)
1408         );
1409     }
1410 
1411     function addLiquidity(uint256 tokenAmount, uint256 usdcAmount) private {
1412         // approve token transfer to cover all possible scenarios
1413         IERC20 USDCcontract = IERC20(USDC);
1414         USDCcontract.approve(address(uniswapV2Router), usdcAmount);
1415 
1416         _approve(address(this), address(uniswapV2Router), tokenAmount);
1417 
1418         // add the liquidity
1419         uniswapV2Router.addLiquidity(
1420             address(this),
1421             USDC,
1422             tokenAmount,
1423             usdcAmount,
1424             0, // slippage is unavoidable
1425             0, // slippage is unavoidable
1426             liquidityWallet,
1427             block.timestamp.add(300)
1428         );
1429     }
1430 
1431     event FundsDistributed(uint256 dev, uint256 marketing, uint256 burn);
1432 
1433    function swapAndDistribute(uint256 tokens) private {
1434         swapTokensForUSDC(tokens);
1435         usdcManager.transferUSDC(address(this));
1436         IERC20 USDCcontract = IERC20(USDC);
1437         address _thisContract = address(this);
1438         uint256 _balance = USDCcontract.balanceOf(_thisContract);
1439         
1440         uint256 burn = (_balance).mul(burnFees).div(
1441             totalFees.sub(liquidityFee)
1442         );
1443         uint256 dev = (_balance).mul(devFees).div(totalFees.sub(liquidityFee));
1444         uint256 marketing = (_balance).sub(burn).sub(dev);
1445         if(marketing>0){
1446         USDCcontract.transfer(marketingWallet, marketing);
1447         }
1448         if(dev>0){
1449       USDCcontract.transfer(devWallet, dev);
1450         }
1451        
1452         if(burn>0){
1453             swapUSDCForTokens(burn);
1454         }
1455         
1456         emit FundsDistributed(dev, marketing, burn);
1457     }
1458 
1459     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1460         swapAndLiquifyEnabled = _enabled;
1461         emit SwapAndLiquifyEnabledUpdated(_enabled);
1462     }
1463 }