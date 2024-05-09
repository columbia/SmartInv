1 //  Tasuku TG : https://t.me/Tasuku_portal
2 
3 //  Website: https://tasuku.tech/
4 
5 //  Twitter: Twitter.com/TAsukucoin1
6 
7 //  Medium: https://link.medium.com/hpDUH8dH3tb
8 
9 //  Max wallet will be 1%  9 999 999 999
10 //  max transaction of 0.33%   3 299 999 999
11 
12 //  Total supply: 999 999 999 999
13 
14 //  Buy tax : 1%
15 
16 //  Sell tax. : 2%
17 
18 
19 // SPDX-License-Identifier: Unlicensed
20 
21 pragma solidity 0.8.9;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 interface IUniswapV2Pair {
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     function name() external pure returns (string memory);
39 
40     function symbol() external pure returns (string memory);
41 
42     function decimals() external pure returns (uint8);
43 
44     function totalSupply() external view returns (uint256);
45 
46     function balanceOf(address owner) external view returns (uint256);
47 
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     function approve(address spender, uint256 value) external returns (bool);
51 
52     function transfer(address to, uint256 value) external returns (bool);
53 
54     function transferFrom(
55         address from,
56         address to,
57         uint256 value
58     ) external returns (bool);
59 
60     function DOMAIN_SEPARATOR() external view returns (bytes32);
61 
62     function PERMIT_TYPEHASH() external pure returns (bytes32);
63 
64     function nonces(address owner) external view returns (uint256);
65 
66     function permit(
67         address owner,
68         address spender,
69         uint256 value,
70         uint256 deadline,
71         uint8 v,
72         bytes32 r,
73         bytes32 s
74     ) external;
75 
76     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
77     event Swap(
78         address indexed sender,
79         uint256 amount0In,
80         uint256 amount1In,
81         uint256 amount0Out,
82         uint256 amount1Out,
83         address indexed to
84     );
85     event Sync(uint112 reserve0, uint112 reserve1);
86 
87     function MINIMUM_LIQUIDITY() external pure returns (uint256);
88 
89     function factory() external view returns (address);
90 
91     function token0() external view returns (address);
92 
93     function token1() external view returns (address);
94 
95     function getReserves()
96         external
97         view
98         returns (
99             uint112 reserve0,
100             uint112 reserve1,
101             uint32 blockTimestampLast
102         );
103 
104     function price0CumulativeLast() external view returns (uint256);
105 
106     function price1CumulativeLast() external view returns (uint256);
107 
108     function kLast() external view returns (uint256);
109 
110     function mint(address to) external returns (uint256 liquidity);
111 
112     function burn(address to) external returns (uint256 amount0, uint256 amount1);
113 
114     function swap(
115         uint256 amount0Out,
116         uint256 amount1Out,
117         address to,
118         bytes calldata data
119     ) external;
120 
121     function skim(address to) external;
122 
123     function sync() external;
124 
125     function initialize(address, address) external;
126 }
127 
128 interface IUniswapV2Factory {
129     event PairCreated(
130         address indexed token0,
131         address indexed token1,
132         address pair,
133         uint256
134     );
135 
136     function feeTo() external view returns (address);
137 
138     function feeToSetter() external view returns (address);
139 
140     function getPair(address tokenA, address tokenB) external view returns (address pair);
141 
142     function allPairs(uint256) external view returns (address pair);
143 
144     function allPairsLength() external view returns (uint256);
145 
146     function createPair(address tokenA, address tokenB) external returns (address pair);
147 
148     function setFeeTo(address) external;
149 
150     function setFeeToSetter(address) external;
151 }
152 
153 interface IERC20 {
154     function totalSupply() external view returns (uint256);
155 
156     function balanceOf(address account) external view returns (uint256);
157 
158     function transfer(address recipient, uint256 amount) external returns (bool);
159 
160     function allowance(address owner, address spender) external view returns (uint256);
161 
162     function approve(address spender, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Moves `amount` tokens from `sender` to `recipient` using the
166      * allowance mechanism. `amount` is then deducted from the caller's
167      * allowance.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a {Transfer} event.
172      */
173     function transferFrom(
174         address sender,
175         address recipient,
176         uint256 amount
177     ) external returns (bool);
178 
179     /**
180      * @dev Emitted when `value` tokens are moved from one account (`from`) to
181      * another (`to`).
182      *
183      * Note that `value` may be zero.
184      */
185     event Transfer(address indexed from, address indexed to, uint256 value);
186 
187     /**
188      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
189      * a call to {approve}. `value` is the new allowance.
190      */
191     event Approval(address indexed owner, address indexed spender, uint256 value);
192 }
193 
194 interface IERC20Metadata is IERC20 {
195     /**
196      * @dev Returns the name of the token.
197      */
198     function name() external view returns (string memory);
199 
200     /**
201      * @dev Returns the symbol of the token.
202      */
203     function symbol() external view returns (string memory);
204 
205     /**
206      * @dev Returns the decimals places of the token.
207      */
208     function decimals() external view returns (uint8);
209 }
210 
211 contract ERC20 is Context, IERC20, IERC20Metadata {
212     using SafeMath for uint256;
213 
214     mapping(address => uint256) private _balances;
215 
216     mapping(address => mapping(address => uint256)) private _allowances;
217 
218     uint256 private _totalSupply;
219 
220     string private _name;
221     string private _symbol;
222 
223     constructor(string memory name_, string memory symbol_) {
224         _name = name_;
225         _symbol = symbol_;
226     }
227 
228     function name() public view virtual override returns (string memory) {
229         return _name;
230     }
231 
232     function symbol() public view virtual override returns (string memory) {
233         return _symbol;
234     }
235 
236     function decimals() public view virtual override returns (uint8) {
237         return 9;
238     }
239 
240     function totalSupply() public view virtual override returns (uint256) {
241         return _totalSupply;
242     }
243 
244     function balanceOf(address account) public view virtual override returns (uint256) {
245         return _balances[account];
246     }
247 
248     function transfer(address recipient, uint256 amount)
249         public
250         virtual
251         override
252         returns (bool)
253     {
254         _transfer(_msgSender(), recipient, amount);
255         return true;
256     }
257 
258     function allowance(address owner, address spender)
259         public
260         view
261         virtual
262         override
263         returns (uint256)
264     {
265         return _allowances[owner][spender];
266     }
267 
268     function approve(address spender, uint256 amount)
269         public
270         virtual
271         override
272         returns (bool)
273     {
274         _approve(_msgSender(), spender, amount);
275         return true;
276     }
277 
278     function transferFrom(
279         address sender,
280         address recipient,
281         uint256 amount
282     ) public virtual override returns (bool) {
283         _approve(
284             sender,
285             _msgSender(),
286             _allowances[sender][_msgSender()].sub(
287                 amount,
288                 'ERC20: transfer amount exceeds allowance'
289             )
290         );
291         _transfer(sender, recipient, amount);
292 
293         return true;
294     }
295 
296     function increaseAllowance(address spender, uint256 addedValue)
297         public
298         virtual
299         returns (bool)
300     {
301         _approve(
302             _msgSender(),
303             spender,
304             _allowances[_msgSender()][spender].add(addedValue)
305         );
306         return true;
307     }
308 
309     function decreaseAllowance(address spender, uint256 subtractedValue)
310         public
311         virtual
312         returns (bool)
313     {
314         _approve(
315             _msgSender(),
316             spender,
317             _allowances[_msgSender()][spender].sub(
318                 subtractedValue,
319                 'ERC20: decreased allowance below zero'
320             )
321         );
322         return true;
323     }
324 
325     /**
326      * @dev Moves tokens `amount` from `sender` to `recipient`.
327      *
328      * This is internal function is equivalent to {transfer}, and can be used to
329      * e.g. implement automatic token fees, slashing mechanisms, etc.
330      *
331      * Emits a {Transfer} event.
332      *
333      * Requirements:
334      *
335      * - `sender` cannot be the zero address.
336      * - `recipient` cannot be the zero address.
337      * - `sender` must have a balance of at least `amount`.
338      */
339     function _transfer(
340         address sender,
341         address recipient,
342         uint256 amount
343     ) internal virtual {
344         require(sender != address(0), 'ERC20: transfer from the zero address');
345         require(recipient != address(0), 'ERC20: transfer to the zero address');
346 
347         _beforeTokenTransfer(sender, recipient, amount);
348 
349         _balances[sender] = _balances[sender].sub(
350             amount,
351             'ERC20: transfer amount exceeds balance'
352         );
353         _balances[recipient] = _balances[recipient].add(amount);
354         emit Transfer(sender, recipient, amount);
355     }
356 
357     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
358      * the total supply.
359      *
360      * Emits a {Transfer} event with `from` set to the zero address.
361      *
362      * Requirements:
363      *
364      * - `account` cannot be the zero address.
365      */
366     function _mint(address account, uint256 amount) internal virtual {
367         require(account != address(0), 'ERC20: mint to the zero address');
368 
369         _beforeTokenTransfer(address(0), account, amount);
370 
371         _totalSupply = _totalSupply.add(amount);
372         _balances[account] = _balances[account].add(amount);
373         emit Transfer(address(0), account, amount);
374     }
375 
376     /**
377      * @dev Destroys `amount` tokens from `account`, reducing the
378      * total supply.
379      *
380      * Emits a {Transfer} event with `to` set to the zero address.
381      *
382      * Requirements:
383      *
384      * - `account` cannot be the zero address.
385      * - `account` must have at least `amount` tokens.
386      */
387     function _burn(address account, uint256 amount) internal virtual {
388         require(account != address(0), 'ERC20: burn from the zero address');
389 
390         _beforeTokenTransfer(account, address(0), amount);
391 
392         _balances[account] = _balances[account].sub(
393             amount,
394             'ERC20: burn amount exceeds balance'
395         );
396         _totalSupply = _totalSupply.sub(amount);
397         emit Transfer(account, address(0), amount);
398     }
399 
400     /**
401      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
402      *
403      * This internal function is equivalent to `approve`, and can be used to
404      * e.g. set automatic allowances for certain subsystems, etc.
405      *
406      * Emits an {Approval} event.
407      *
408      * Requirements:
409      *
410      * - `owner` cannot be the zero address.
411      * - `spender` cannot be the zero address.
412      */
413     function _approve(
414         address owner,
415         address spender,
416         uint256 amount
417     ) internal virtual {
418         require(owner != address(0), 'ERC20: approve from the zero address');
419         require(spender != address(0), 'ERC20: approve to the zero address');
420 
421         _allowances[owner][spender] = amount;
422         emit Approval(owner, spender, amount);
423     }
424 
425     function _beforeTokenTransfer(
426         address from,
427         address to,
428         uint256 amount
429     ) internal virtual {}
430 }
431 
432 library SafeMath {
433     /**
434      * @dev Returns the addition of two unsigned integers, reverting on
435      * overflow.
436      *
437      * Counterpart to Solidity's `+` operator.
438      *
439      * Requirements:
440      *
441      * - Addition cannot overflow.
442      */
443     function add(uint256 a, uint256 b) internal pure returns (uint256) {
444         uint256 c = a + b;
445         require(c >= a, 'SafeMath: addition overflow');
446 
447         return c;
448     }
449 
450     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
451         return sub(a, b, 'SafeMath: subtraction overflow');
452     }
453 
454     /**
455      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
456      * overflow (when the result is negative).
457      *
458      * Counterpart to Solidity's `-` operator.
459      *
460      * Requirements:
461      *
462      * - Subtraction cannot overflow.
463      */
464     function sub(
465         uint256 a,
466         uint256 b,
467         string memory errorMessage
468     ) internal pure returns (uint256) {
469         require(b <= a, errorMessage);
470         uint256 c = a - b;
471 
472         return c;
473     }
474 
475     /**
476      * @dev Returns the multiplication of two unsigned integers, reverting on
477      * overflow.
478      *
479      * Counterpart to Solidity's `*` operator.
480      *
481      * Requirements:
482      *
483      * - Multiplication cannot overflow.
484      */
485     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
486         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
487         // benefit is lost if 'b' is also tested.
488         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
489         if (a == 0) {
490             return 0;
491         }
492 
493         uint256 c = a * b;
494         require(c / a == b, 'SafeMath: multiplication overflow');
495 
496         return c;
497     }
498 
499     /**
500      * @dev Returns the integer division of two unsigned integers. Reverts on
501      * division by zero. The result is rounded towards zero.
502      *
503      * Counterpart to Solidity's `/` operator. Note: this function uses a
504      * `revert` opcode (which leaves remaining gas untouched) while Solidity
505      * uses an invalid opcode to revert (consuming all remaining gas).
506      *
507      * Requirements:
508      *
509      * - The divisor cannot be zero.
510      */
511     function div(uint256 a, uint256 b) internal pure returns (uint256) {
512         return div(a, b, 'SafeMath: division by zero');
513     }
514 
515     /**
516      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
517      * division by zero. The result is rounded towards zero.
518      *
519      * Counterpart to Solidity's `/` operator. Note: this function uses a
520      * `revert` opcode (which leaves remaining gas untouched) while Solidity
521      * uses an invalid opcode to revert (consuming all remaining gas).
522      *
523      * Requirements:
524      *
525      * - The divisor cannot be zero.
526      */
527     function div(
528         uint256 a,
529         uint256 b,
530         string memory errorMessage
531     ) internal pure returns (uint256) {
532         require(b > 0, errorMessage);
533         uint256 c = a / b;
534         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
535 
536         return c;
537     }
538 
539     /**
540      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
541      * Reverts when dividing by zero.
542      *
543      * Counterpart to Solidity's `%` operator. This function uses a `revert`
544      * opcode (which leaves remaining gas untouched) while Solidity uses an
545      * invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      *
549      * - The divisor cannot be zero.
550      */
551     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
552         return mod(a, b, 'SafeMath: modulo by zero');
553     }
554 
555     /**
556      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
557      * Reverts with custom message when dividing by zero.
558      *
559      * Counterpart to Solidity's `%` operator. This function uses a `revert`
560      * opcode (which leaves remaining gas untouched) while Solidity uses an
561      * invalid opcode to revert (consuming all remaining gas).
562      *
563      * Requirements:
564      *
565      * - The divisor cannot be zero.
566      */
567     function mod(
568         uint256 a,
569         uint256 b,
570         string memory errorMessage
571     ) internal pure returns (uint256) {
572         require(b != 0, errorMessage);
573         return a % b;
574     }
575 }
576 
577 contract Ownable is Context {
578     address private _owner;
579 
580     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
581 
582     /**
583      * @dev Initializes the contract setting the deployer as the initial owner.
584      */
585     constructor() {
586         address msgSender = _msgSender();
587         _owner = msgSender;
588         emit OwnershipTransferred(address(0), msgSender);
589     }
590 
591     /**
592      * @dev Returns the address of the current owner.
593      */
594     function owner() public view returns (address) {
595         return _owner;
596     }
597 
598     /**
599      * @dev Throws if called by any account other than the owner.
600      */
601     modifier onlyOwner() {
602         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
603         _;
604     }
605 
606     /**
607      * @dev Leaves the contract without owner. It will not be possible to call
608      * `onlyOwner` functions anymore. Can only be called by the current owner.
609      *
610      * NOTE: Renouncing ownership will leave the contract without an owner,
611      * thereby removing any functionality that is only available to the owner.
612      */
613     function renounceOwnership() public virtual onlyOwner {
614         emit OwnershipTransferred(_owner, address(0));
615         _owner = address(0);
616     }
617 
618     /**
619      * @dev Transfers ownership of the contract to a new account (`newOwner`).
620      * Can only be called by the current owner.
621      */
622     function transferOwnership(address newOwner) public virtual onlyOwner {
623         require(newOwner != address(0), 'Ownable: new owner is the zero address');
624         emit OwnershipTransferred(_owner, newOwner);
625         _owner = newOwner;
626     }
627 }
628 
629 library SafeMathInt {
630     int256 private constant MIN_INT256 = int256(1) << 255;
631     int256 private constant MAX_INT256 = ~(int256(1) << 255);
632 
633     /**
634      * @dev Multiplies two int256 variables and fails on overflow.
635      */
636     function mul(int256 a, int256 b) internal pure returns (int256) {
637         int256 c = a * b;
638 
639         // Detect overflow when multiplying MIN_INT256 with -1
640         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
641         require((b == 0) || (c / b == a));
642         return c;
643     }
644 
645     /**
646      * @dev Division of two int256 variables and fails on overflow.
647      */
648     function div(int256 a, int256 b) internal pure returns (int256) {
649         // Prevent overflow when dividing MIN_INT256 by -1
650         require(b != -1 || a != MIN_INT256);
651 
652         // Solidity already throws when dividing by 0.
653         return a / b;
654     }
655 
656     /**
657      * @dev Subtracts two int256 variables and fails on overflow.
658      */
659     function sub(int256 a, int256 b) internal pure returns (int256) {
660         int256 c = a - b;
661         require((b >= 0 && c <= a) || (b < 0 && c > a));
662         return c;
663     }
664 
665     /**
666      * @dev Adds two int256 variables and fails on overflow.
667      */
668     function add(int256 a, int256 b) internal pure returns (int256) {
669         int256 c = a + b;
670         require((b >= 0 && c >= a) || (b < 0 && c < a));
671         return c;
672     }
673 
674     /**
675      * @dev Converts to absolute value, and fails on overflow.
676      */
677     function abs(int256 a) internal pure returns (int256) {
678         require(a != MIN_INT256);
679         return a < 0 ? -a : a;
680     }
681 
682     function toUint256Safe(int256 a) internal pure returns (uint256) {
683         require(a >= 0);
684         return uint256(a);
685     }
686 }
687 
688 library SafeMathUint {
689     function toInt256Safe(uint256 a) internal pure returns (int256) {
690         int256 b = int256(a);
691         require(b >= 0);
692         return b;
693     }
694 }
695 
696 interface IUniswapV2Router01 {
697     function factory() external pure returns (address);
698 
699     function WETH() external pure returns (address);
700 
701     function addLiquidity(
702         address tokenA,
703         address tokenB,
704         uint256 amountADesired,
705         uint256 amountBDesired,
706         uint256 amountAMin,
707         uint256 amountBMin,
708         address to,
709         uint256 deadline
710     )
711         external
712         returns (
713             uint256 amountA,
714             uint256 amountB,
715             uint256 liquidity
716         );
717 
718     function addLiquidityETH(
719         address token,
720         uint256 amountTokenDesired,
721         uint256 amountTokenMin,
722         uint256 amountETHMin,
723         address to,
724         uint256 deadline
725     )
726         external
727         payable
728         returns (
729             uint256 amountToken,
730             uint256 amountETH,
731             uint256 liquidity
732         );
733 
734     function removeLiquidity(
735         address tokenA,
736         address tokenB,
737         uint256 liquidity,
738         uint256 amountAMin,
739         uint256 amountBMin,
740         address to,
741         uint256 deadline
742     ) external returns (uint256 amountA, uint256 amountB);
743 
744     function removeLiquidityETH(
745         address token,
746         uint256 liquidity,
747         uint256 amountTokenMin,
748         uint256 amountETHMin,
749         address to,
750         uint256 deadline
751     ) external returns (uint256 amountToken, uint256 amountETH);
752 
753     function removeLiquidityWithPermit(
754         address tokenA,
755         address tokenB,
756         uint256 liquidity,
757         uint256 amountAMin,
758         uint256 amountBMin,
759         address to,
760         uint256 deadline,
761         bool approveMax,
762         uint8 v,
763         bytes32 r,
764         bytes32 s
765     ) external returns (uint256 amountA, uint256 amountB);
766 
767     function removeLiquidityETHWithPermit(
768         address token,
769         uint256 liquidity,
770         uint256 amountTokenMin,
771         uint256 amountETHMin,
772         address to,
773         uint256 deadline,
774         bool approveMax,
775         uint8 v,
776         bytes32 r,
777         bytes32 s
778     ) external returns (uint256 amountToken, uint256 amountETH);
779 
780     function swapExactTokensForTokens(
781         uint256 amountIn,
782         uint256 amountOutMin,
783         address[] calldata path,
784         address to,
785         uint256 deadline
786     ) external returns (uint256[] memory amounts);
787 
788     function swapTokensForExactTokens(
789         uint256 amountOut,
790         uint256 amountInMax,
791         address[] calldata path,
792         address to,
793         uint256 deadline
794     ) external returns (uint256[] memory amounts);
795 
796     function swapExactETHForTokens(
797         uint256 amountOutMin,
798         address[] calldata path,
799         address to,
800         uint256 deadline
801     ) external payable returns (uint256[] memory amounts);
802 
803     function swapTokensForExactETH(
804         uint256 amountOut,
805         uint256 amountInMax,
806         address[] calldata path,
807         address to,
808         uint256 deadline
809     ) external returns (uint256[] memory amounts);
810 
811     function swapExactTokensForETH(
812         uint256 amountIn,
813         uint256 amountOutMin,
814         address[] calldata path,
815         address to,
816         uint256 deadline
817     ) external returns (uint256[] memory amounts);
818 
819     function swapETHForExactTokens(
820         uint256 amountOut,
821         address[] calldata path,
822         address to,
823         uint256 deadline
824     ) external payable returns (uint256[] memory amounts);
825 
826     function quote(
827         uint256 amountA,
828         uint256 reserveA,
829         uint256 reserveB
830     ) external pure returns (uint256 amountB);
831 
832     function getAmountOut(
833         uint256 amountIn,
834         uint256 reserveIn,
835         uint256 reserveOut
836     ) external pure returns (uint256 amountOut);
837 
838     function getAmountIn(
839         uint256 amountOut,
840         uint256 reserveIn,
841         uint256 reserveOut
842     ) external pure returns (uint256 amountIn);
843 
844     function getAmountsOut(uint256 amountIn, address[] calldata path)
845         external
846         view
847         returns (uint256[] memory amounts);
848 
849     function getAmountsIn(uint256 amountOut, address[] calldata path)
850         external
851         view
852         returns (uint256[] memory amounts);
853 }
854 
855 interface IUniswapV2Router02 is IUniswapV2Router01 {
856     function removeLiquidityETHSupportingFeeOnTransferTokens(
857         address token,
858         uint256 liquidity,
859         uint256 amountTokenMin,
860         uint256 amountETHMin,
861         address to,
862         uint256 deadline
863     ) external returns (uint256 amountETH);
864 
865     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
866         address token,
867         uint256 liquidity,
868         uint256 amountTokenMin,
869         uint256 amountETHMin,
870         address to,
871         uint256 deadline,
872         bool approveMax,
873         uint8 v,
874         bytes32 r,
875         bytes32 s
876     ) external returns (uint256 amountETH);
877 
878     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
879         uint256 amountIn,
880         uint256 amountOutMin,
881         address[] calldata path,
882         address to,
883         uint256 deadline
884     ) external;
885 
886     function swapExactETHForTokensSupportingFeeOnTransferTokens(
887         uint256 amountOutMin,
888         address[] calldata path,
889         address to,
890         uint256 deadline
891     ) external payable;
892 
893     function swapExactTokensForETHSupportingFeeOnTransferTokens(
894         uint256 amountIn,
895         uint256 amountOutMin,
896         address[] calldata path,
897         address to,
898         uint256 deadline
899     ) external;
900 }
901 
902 interface IAntisnipe {
903     function assureCanTransfer(
904         address sender,
905         address from,
906         address to,
907         uint256 amount
908     ) external;
909 }
910 
911 contract TASUKU is ERC20, Ownable {
912     using SafeMath for uint256;
913 
914     IUniswapV2Router02 public immutable uniswapV2Router;
915     address public immutable uniswapV2Pair;
916 
917     bool private swapping;
918 
919     address private marketingWallet;
920     address private buybackWallet;
921 
922     uint256 private maxTransactionAmount;
923     uint256 private swapTokensAtAmount;
924     uint256 private maxWallet;
925 
926     bool private limitsInEffect = true;
927     bool private tradingActive = true;
928     bool public swapEnabled = false;
929 
930     // Anti-bot and anti-whale mappings and variables
931     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
932 
933     // Seller Map
934     mapping(address => uint256) private _holderFirstBuyTimestamp;
935 
936     // Blacklist Map
937     mapping(address => bool) private _blacklist;
938     bool public transferDelayEnabled = true;
939 
940     uint256 private buyTotalFees;
941     uint256 private buyMarketingFee;
942     uint256 private buyLiquidityFee;
943     uint256 private buyBuybackFee;
944 
945     uint256 private sellTotalFees;
946     uint256 private sellMarketingFee;
947     uint256 private sellLiquidityFee;
948     uint256 private sellBuybackFee;
949 
950     uint256 private tokensForMarketing;
951     uint256 private tokensForLiquidity;
952     uint256 private tokensForBuyback;
953 
954     // block number of opened trading
955     uint256 launchedAt;
956 
957     /******************/
958 
959     // exclude from fees and max transaction amount
960     mapping(address => bool) private _isExcludedFromFees;
961     mapping(address => bool) public _isExcludedMaxTransactionAmount;
962 
963     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
964     // could be subject to a maximum transfer amount
965     mapping(address => bool) public automatedMarketMakerPairs;
966 
967     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
968 
969     event ExcludeFromFees(address indexed account, bool isExcluded);
970 
971     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
972 
973     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
974 
975     event buybackWalletUpdated(address indexed newWallet, address indexed oldWallet);
976 
977     event SwapAndLiquify(
978         uint256 tokensSwapped,
979         uint256 ethReceived,
980         uint256 tokensIntoLiquidity
981     );
982 
983     constructor() ERC20('TASUKU', 'TASUKU') {
984         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
985             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
986         );
987 
988         excludeFromMaxTransaction(address(_uniswapV2Router), true);
989         uniswapV2Router = _uniswapV2Router;
990 
991         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
992             address(this),
993             _uniswapV2Router.WETH()
994         );
995         excludeFromMaxTransaction(address(uniswapV2Pair), true);
996         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
997 
998         uint256 _buyMarketingFee = 1; 
999         uint256 _buyLiquidityFee = 0;   
1000         uint256 _buyBuybackFee = 0;  
1001 
1002         uint256 _sellMarketingFee = 1; 
1003         uint256 _sellLiquidityFee = 0; 
1004         uint256 _sellBuybackFee = 1; 
1005 
1006         uint256 totalSupply = 999999999999 * 10**9;
1007 
1008         maxTransactionAmount = (totalSupply * 33) / 10000; // 0.33% maxTransactionAmountTxn
1009         maxWallet = (totalSupply * 99) / 10000; // 0.99% maxWallet
1010         swapTokensAtAmount = (totalSupply * 15) / 10000; // 0.15% swap wallet
1011 
1012         buyMarketingFee = _buyMarketingFee;
1013         buyLiquidityFee = _buyLiquidityFee;
1014         buyBuybackFee = _buyBuybackFee;
1015         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuybackFee;
1016 
1017         sellMarketingFee = _sellMarketingFee;
1018         sellLiquidityFee = _sellLiquidityFee;
1019         sellBuybackFee = _sellBuybackFee;
1020         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuybackFee;
1021 
1022         marketingWallet = address(owner()); // set as marketing wallet
1023         buybackWallet = address(owner()); // set as buyback wallet
1024 
1025         // exclude from paying fees or having max transaction amount
1026         excludeFromFees(owner(), true);
1027         excludeFromFees(address(this), true);
1028         excludeFromFees(address(0xdead), true);
1029 
1030         excludeFromMaxTransaction(owner(), true);
1031         excludeFromMaxTransaction(address(this), true);
1032         excludeFromMaxTransaction(address(0xdead), true);
1033 
1034         /*
1035             _mint is an internal function in ERC20.sol that is only called here,
1036             and CANNOT be called ever again
1037         */
1038         _mint(msg.sender, totalSupply);
1039     }
1040 
1041     IAntisnipe public antisnipe;
1042     bool public antisnipeDisable;
1043 
1044     function _beforeTokenTransfer(
1045         address from,
1046         address to,
1047         uint256 amount
1048     ) internal override {
1049         if (from == address(0) || to == address(0)) return;
1050         if (!antisnipeDisable && address(antisnipe) != address(0))
1051             antisnipe.assureCanTransfer(msg.sender, from, to, amount);
1052     }
1053 
1054     function setAntisnipeDisable() external onlyOwner {
1055         require(!antisnipeDisable);
1056         antisnipeDisable = true;
1057     }
1058 
1059     function setAntisnipeAddress(address addr) external onlyOwner {
1060         antisnipe = IAntisnipe(addr);
1061     }
1062 
1063     receive() external payable {}
1064 
1065     // once enabled, can never be turned off
1066     function enableTrading() external onlyOwner {
1067         tradingActive = true;
1068         swapEnabled = true;
1069         launchedAt = block.number;
1070     }
1071 
1072     // remove limits after token is stable
1073     function removeLimits() external onlyOwner returns (bool) {
1074         limitsInEffect = false;
1075         return true;
1076     }
1077 
1078     // disable Transfer delay - cannot be reenabled
1079     function disableTransferDelay() external onlyOwner returns (bool) {
1080         transferDelayEnabled = false;
1081         return true;
1082     }
1083 
1084     // change the minimum amount of tokens to sell from fees
1085     function updateSwapTokensAtAmount(uint256 newAmount)
1086         external
1087         onlyOwner
1088         returns (bool)
1089     {
1090         require(
1091             newAmount >= (totalSupply() * 1) / 100000,
1092             'Swap amount cannot be lower than 0.001% total supply.'
1093         );
1094         require(
1095             newAmount <= (totalSupply() * 99) / 1000,
1096             'Swap amount cannot be higher than 0.99% total supply.'
1097         );
1098         swapTokensAtAmount = newAmount;
1099         return true;
1100     }
1101 
1102     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1103         require(
1104             newNum >= ((totalSupply() * 1) / 1000),
1105             'Cannot set maxTransactionAmount lower than 0.1%'
1106         );
1107         maxTransactionAmount = newNum;
1108     }
1109 
1110     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1111         require(
1112             newNum >= ((totalSupply() * 99) / 1000),
1113             'Cannot set maxWallet lower than 0.99%'
1114         );
1115         maxWallet = newNum;
1116     }
1117 
1118     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1119         _isExcludedMaxTransactionAmount[updAds] = isEx;
1120     }
1121 
1122     // only use to disable contract sales if absolutely necessary (emergency use only)
1123     function updateSwapEnabled(bool enabled) external onlyOwner {
1124         swapEnabled = enabled;
1125     }
1126 
1127     function updateBuyFees(
1128         uint256 _marketingFee,
1129         uint256 _liquidityFee,
1130         uint256 _buybackFee
1131     ) external onlyOwner {
1132         buyMarketingFee = _marketingFee;
1133         buyLiquidityFee = _liquidityFee;
1134         buyBuybackFee = _buybackFee;
1135         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuybackFee;
1136         require(buyTotalFees <= 2, 'Must keep fees at 2% or less');
1137     }
1138 
1139     function updateSellFees(
1140         uint256 _marketingFee,
1141         uint256 _liquidityFee,
1142         uint256 _buybackFee
1143     ) external onlyOwner {
1144         sellMarketingFee = _marketingFee;
1145         sellLiquidityFee = _liquidityFee;
1146         sellBuybackFee = _buybackFee;
1147         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuybackFee;
1148         require(sellTotalFees <= 3, 'Must keep fees at 3% or less');
1149     }
1150 
1151     function excludeFromFees(address account, bool excluded) public onlyOwner {
1152         _isExcludedFromFees[account] = excluded;
1153         emit ExcludeFromFees(account, excluded);
1154     }
1155 
1156     function ManageBot(address account, bool isBlacklisted) public onlyOwner {
1157         _blacklist[account] = isBlacklisted;
1158     }
1159 
1160     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1161         require(
1162             pair != uniswapV2Pair,
1163             'The pair cannot be removed from automatedMarketMakerPairs'
1164         );
1165 
1166         _setAutomatedMarketMakerPair(pair, value);
1167     }
1168 
1169     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1170         automatedMarketMakerPairs[pair] = value;
1171 
1172         emit SetAutomatedMarketMakerPair(pair, value);
1173     }
1174 
1175     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1176         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1177         marketingWallet = newMarketingWallet;
1178     }
1179 
1180     function updateBuybackWallet(address newWallet) external onlyOwner {
1181         emit buybackWalletUpdated(newWallet, buybackWallet);
1182         buybackWallet = newWallet;
1183     }
1184 
1185     function isExcludedFromFees(address account) public view returns (bool) {
1186         return _isExcludedFromFees[account];
1187     }
1188 
1189     event BoughtEarly(address indexed sniper);
1190 
1191     function _transfer(
1192         address from,
1193         address to,
1194         uint256 amount
1195     ) internal override {
1196         require(from != address(0), 'ERC20: transfer from the zero address');
1197         require(to != address(0), 'ERC20: transfer to the zero address');
1198         require(
1199             !_blacklist[to] && !_blacklist[from],
1200             'You have been blacklisted from transfering tokens'
1201         );
1202         if (amount == 0) {
1203             super._transfer(from, to, 0);
1204             return;
1205         }
1206 
1207         if (limitsInEffect) {
1208             if (
1209                 from != owner() &&
1210                 to != owner() &&
1211                 to != address(0) &&
1212                 to != address(0xdead) &&
1213                 !swapping
1214             ) {
1215                 if (!tradingActive) {
1216                     require(
1217                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1218                         'Trading is not active.'
1219                     );
1220                 }
1221 
1222                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1223                 if (transferDelayEnabled) {
1224                     if (
1225                         to != owner() &&
1226                         to != address(uniswapV2Router) &&
1227                         to != address(uniswapV2Pair)
1228                     ) {
1229                         require(
1230                             _holderLastTransferTimestamp[tx.origin] < block.number,
1231                             '_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.'
1232                         );
1233                         _holderLastTransferTimestamp[tx.origin] = block.number;
1234                     }
1235                 }
1236 
1237                 //when buy
1238                 if (
1239                     automatedMarketMakerPairs[from] &&
1240                     !_isExcludedMaxTransactionAmount[to]
1241                 ) {
1242                     require(
1243                         amount <= maxTransactionAmount,
1244                         'Buy transfer amount exceeds the maxTransactionAmount.'
1245                     );
1246                     require(amount + balanceOf(to) <= maxWallet, 'Max wallet exceeded');
1247                 }
1248                 //when sell
1249                 else if (
1250                     automatedMarketMakerPairs[to] &&
1251                     !_isExcludedMaxTransactionAmount[from]
1252                 ) {
1253                     require(
1254                         amount <= maxTransactionAmount,
1255                         'Sell transfer amount exceeds the maxTransactionAmount.'
1256                     );
1257                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1258                     require(amount + balanceOf(to) <= maxWallet, 'Max wallet exceeded');
1259                 }
1260             }
1261         }
1262 
1263         // anti bot logic
1264         if (
1265             block.number <= (launchedAt + 1) &&
1266             to != uniswapV2Pair &&
1267             to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1268         ) {
1269             _blacklist[to] = true;
1270         }
1271 
1272         uint256 contractTokenBalance = balanceOf(address(this));
1273 
1274         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1275 
1276         if (
1277             canSwap &&
1278             swapEnabled &&
1279             !swapping &&
1280             !automatedMarketMakerPairs[from] &&
1281             !_isExcludedFromFees[from] &&
1282             !_isExcludedFromFees[to]
1283         ) {
1284             swapping = true;
1285 
1286             swapBack();
1287 
1288             swapping = false;
1289         }
1290 
1291         bool takeFee = !swapping;
1292 
1293         // if any account belongs to _isExcludedFromFee account then remove the fee
1294         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1295             takeFee = false;
1296         }
1297 
1298         uint256 fees = 0;
1299         // only take fees on buys/sells, do not take on wallet transfers
1300         if (takeFee) {
1301             // on sell
1302             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1303                 fees = amount.mul(sellTotalFees).div(100);
1304                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1305                 tokensForBuyback += (fees * sellBuybackFee) / sellTotalFees;
1306                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1307             }
1308             // on buy
1309             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1310                 fees = amount.mul(buyTotalFees).div(100);
1311                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1312                 tokensForBuyback += (fees * buyBuybackFee) / buyTotalFees;
1313                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1314             }
1315 
1316             if (fees > 0) {
1317                 super._transfer(from, address(this), fees);
1318             }
1319 
1320             amount -= fees;
1321         }
1322 
1323         super._transfer(from, to, amount);
1324     }
1325 
1326     function swapTokensForEth(uint256 tokenAmount) private {
1327         // generate the uniswap pair path of token -> weth
1328         address[] memory path = new address[](2);
1329         path[0] = address(this);
1330         path[1] = uniswapV2Router.WETH();
1331 
1332         _approve(address(this), address(uniswapV2Router), tokenAmount);
1333 
1334         // make the swap
1335         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1336             tokenAmount,
1337             0, // accept any amount of ETH
1338             path,
1339             address(this),
1340             block.timestamp
1341         );
1342     }
1343 
1344     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1345         // approve token transfer to cover all possible scenarios
1346         _approve(address(this), address(uniswapV2Router), tokenAmount);
1347 
1348         // add the liquidity
1349         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1350             address(this),
1351             tokenAmount,
1352             0, // slippage is unavoidable
1353             0, // slippage is unavoidable
1354             address(buybackWallet),
1355             block.timestamp
1356         );
1357     }
1358 
1359     function swapBack() private {
1360         uint256 contractBalance = balanceOf(address(this));
1361         uint256 totalTokensToSwap = tokensForLiquidity +
1362             tokensForMarketing +
1363             tokensForBuyback;
1364         bool success;
1365 
1366         if (contractBalance == 0 || totalTokensToSwap == 0) {
1367             return;
1368         }
1369 
1370         if (contractBalance > swapTokensAtAmount * 20) {
1371             contractBalance = swapTokensAtAmount * 20;
1372         }
1373 
1374         // Halve the amount of liquidity tokens
1375         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1376             totalTokensToSwap /
1377             2;
1378         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1379 
1380         uint256 initialETHBalance = address(this).balance;
1381 
1382         swapTokensForEth(amountToSwapForETH);
1383 
1384         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1385 
1386         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1387             totalTokensToSwap
1388         );
1389         uint256 ethForBuyback = ethBalance.mul(tokensForBuyback).div(totalTokensToSwap);
1390         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyback;
1391 
1392         tokensForLiquidity = 0;
1393         tokensForMarketing = 0;
1394         tokensForBuyback = 0;
1395 
1396         (success, ) = address(buybackWallet).call{value: ethForBuyback}('');
1397 
1398         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1399             addLiquidity(liquidityTokens, ethForLiquidity);
1400             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1401         }
1402 
1403         (success, ) = address(marketingWallet).call{value: address(this).balance}('');
1404     }
1405 }