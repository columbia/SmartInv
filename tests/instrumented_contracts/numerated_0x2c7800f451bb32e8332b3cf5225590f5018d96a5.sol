1 /**
2 
3 degenerate.tools is a Telegram bot with advance tools to aid
4 ERC-20 Defi trading. Features are unlocked through a tier system
5 determined by token holdings.
6 
7 Smart Contract contains our own built-in MEV frontrun protection,
8 preventing MEV bots from frontrunning buys/sells.
9 
10 Block 0-n snipers will have their tokens locked with 25% max supply
11 unlocking ~40 minutes after launch and 25% max supply each following hour.
12 
13 - degenerate.tools team
14 
15 
16 Website:
17 https://degenerate.tools
18 
19 Telegram:
20 https://t.me/degeneratetools
21 
22 */
23 
24 // SPDX-License-Identifier: MIT
25 
26 pragma solidity 0.8.13;
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38 
39 interface IUniswapV2Factory {
40     function createPair(address tokenA, address tokenB)
41         external
42         returns (address pair);
43 }
44 
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount)
64         external
65         returns (bool);
66 
67     /**
68      * @dev Returns the remaining number of tokens that `spender` will be
69      * allowed to spend on behalf of `owner` through {transferFrom}. This is
70      * zero by default.
71      *
72      * This value changes when {approve} or {transferFrom} are called.
73      */
74     function allowance(address owner, address spender)
75         external
76         view
77         returns (uint256);
78 
79     /**
80      * @dev Sets `amount` as the allowance of `spender` over the cal ler's tokens.
81      *
82      * Returns a boolean value indicating whether the op eration succeeded.
83      *
84      * IMPORTANT: Beware that changing an allowan ce with this method brings the risk
85      * that someone may  use both the old and the new allowance by unfortunate
86      * transaction ordering. One  possible solution to mitigate this race
87      * condition is to first reduce the spe nder's allowance to 0 and set the
88      * desired valu  afterwards:
89      * https://github.co m/ethereum/EIPs/issues/20#issuecomment-263524729
90      *
91      * Emits an {Approval} event.
92      */
93     function approve(address spender, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Moves `amount` toke ns from `sender` to `recipient` using the
97      * allowance mechanism. `am ount` is then deducted from the caller's
98      * allowance.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address sender,
106         address recipient,
107         uint256 amount
108     ) external returns (bool);
109 
110     /**
111      * @dev Emitted when `v alue` tokens are moved from one account (`from`) to
112      * anot her (`to`).
113      *
114      * Note that `value` may be zero.
115      */
116     event Transfer(address indexed from, address indexed to, uint256 value);
117 
118     /**
119      * @dev Emitted when the all owance of a `spender` for an `owner` is set by
120      * a call to {approve}. `va lue` is the new allowance.
121      */
122     event Approval(
123         address indexed owner,
124         address indexed spender,
125         uint256 value
126     );
127 }
128 
129 interface IERC20Metadata is IERC20 {
130     /**
131      * @dev Returns the name of the token.
132      */
133     function name() external view returns (string memory);
134 
135     /**
136      * @dev Returns the symbol of the token.
137      */
138     function symbol() external view returns (string memory);
139 
140     /**
141      * @dev Returns the decimals places of the token.
142      */
143     function decimals() external view returns (uint8);
144 }
145 
146 contract ERC20 is Context, IERC20, IERC20Metadata {
147     mapping(address => uint256) private _balances;
148 
149     mapping(address => mapping(address => uint256)) private _allowances;
150 
151     uint256 private _totalSupply;
152 
153     string private _name;
154     string private _symbol;
155 
156     constructor(string memory name_, string memory symbol_) {
157         _name = name_;
158         _symbol = symbol_;
159     }
160 
161     function name() public view virtual override returns (string memory) {
162         return _name;
163     }
164 
165     function symbol() public view virtual override returns (string memory) {
166         return _symbol;
167     }
168 
169     function decimals() public view virtual override returns (uint8) {
170         return 18;
171     }
172 
173     function totalSupply() public view virtual override returns (uint256) {
174         return _totalSupply;
175     }
176 
177     function balanceOf(address account)
178         public
179         view
180         virtual
181         override
182         returns (uint256)
183     {
184         return _balances[account];
185     }
186 
187     function transfer(address recipient, uint256 amount)
188         public
189         virtual
190         override
191         returns (bool)
192     {
193         _transfer(_msgSender(), recipient, amount);
194         return true;
195     }
196 
197     function allowance(address owner, address spender)
198         public
199         view
200         virtual
201         override
202         returns (uint256)
203     {
204         return _allowances[owner][spender];
205     }
206 
207     function approve(address spender, uint256 amount)
208         public
209         virtual
210         override
211         returns (bool)
212     {
213         _approve(_msgSender(), spender, amount);
214         return true;
215     }
216 
217     function transferFrom(
218         address sender,
219         address recipient,
220         uint256 amount
221     ) public virtual override returns (bool) {
222         _transfer(sender, recipient, amount);
223 
224         uint256 currentAllowance = _allowances[sender][_msgSender()];
225         require(
226             currentAllowance >= amount,
227             "ERC20: transfer amount exceeds allowance"
228         );
229         unchecked {
230             _approve(sender, _msgSender(), currentAllowance - amount);
231         }
232 
233         return true;
234     }
235 
236     function increaseAllowance(address spender, uint256 addedValue)
237         public
238         virtual
239         returns (bool)
240     {
241         _approve(
242             _msgSender(),
243             spender,
244             _allowances[_msgSender()][spender] + addedValue
245         );
246         return true;
247     }
248 
249     function decreaseAllowance(address spender, uint256 subtractedValue)
250         public
251         virtual
252         returns (bool)
253     {
254         uint256 currentAllowance = _allowances[_msgSender()][spender];
255         require(
256             currentAllowance >= subtractedValue,
257             "ERC20: decreased allowance below zero"
258         );
259         unchecked {
260             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
261         }
262 
263         return true;
264     }
265 
266     function _transfer(
267         address sender,
268         address recipient,
269         uint256 amount
270     ) internal virtual {
271         require(sender != address(0), "ERC20: transfer from the zero address");
272         require(recipient != address(0), "ERC20: transfer to the zero address");
273 
274         uint256 senderBalance = _balances[sender];
275         require(
276             senderBalance >= amount,
277             "ERC20: transfer amount exceeds balance"
278         );
279         unchecked {
280             _balances[sender] = senderBalance - amount;
281         }
282         _balances[recipient] += amount;
283 
284         emit Transfer(sender, recipient, amount);
285     }
286 
287     function _createInitialSupply(address account, uint256 amount)
288         internal
289         virtual
290     {
291         require(account != address(0), "ERC20: mint to the zero address");
292         _totalSupply += amount;
293         _balances[account] += amount;
294         emit Transfer(address(0), account, amount);
295     }
296 
297     function _approve(
298         address owner,
299         address spender,
300         uint256 amount
301     ) internal virtual {
302         require(owner != address(0), "ERC20: approve from the zero address");
303         require(spender != address(0), "ERC20: approve to the zero address");
304 
305         _allowances[owner][spender] = amount;
306         emit Approval(owner, spender, amount);
307     }
308 }
309 
310 library SafeMath {
311     /**
312      * @dev Returns the addition of two unsigned integers, reverting on
313      * overflow.
314      *
315      * Counterpart to Solidity's `+` operator.
316      *
317      * Requirements:
318      *
319      * - Addition cannot overflow.
320      */
321     function add(uint256 a, uint256 b) internal pure returns (uint256) {
322         uint256 c = a + b;
323         require(c >= a, "SafeMath: addition overflow");
324 
325         return c;
326     }
327 
328     /**
329      * @dev Returns the subtraction of two unsigned integers, reverting on
330      * overflow (when the result is negative).
331      *
332      * Counterpart to Solidity's `-` operator.
333      *
334      * Requirements:
335      *
336      * - Subtraction cannot overflow.
337      */
338     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
339         return sub(a, b, "SafeMath: subtraction overflow");
340     }
341 
342     /**
343      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
344      * overflow (when the result is negative).
345      *
346      * Counterpart to Solidity's `-` operator.
347      *
348      * Requirements:
349      *
350      * - Subtraction cannot overflow.
351      */
352     function sub(
353         uint256 a,
354         uint256 b,
355         string memory errorMessage
356     ) internal pure returns (uint256) {
357         require(b <= a, errorMessage);
358         uint256 c = a - b;
359 
360         return c;
361     }
362 
363     /**
364      * @dev Returns the multiplication of two unsigned integers, reverting on
365      * overflow.
366      *
367      * Counterpart to Solidity's `*` operator.
368      *
369      * Requirements:
370      *
371      * - Multiplication cannot overflow.
372      */
373     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
374         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
375         // benefit is lost if 'b' is also tested.
376         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
377         if (a == 0) {
378             return 0;
379         }
380 
381         uint256 c = a * b;
382         require(c / a == b, "SafeMath: multiplication overflow");
383 
384         return c;
385     }
386 
387     /**
388      * @dev Returns the integer division of two unsigned integers. Reverts on
389      * division by zero. The result is rounded towards zero.
390      *
391      * Counterpart to Solidity's `/` operator. Note: this function uses a
392      * `revert` opcode (which leaves remaining gas untouched) while Solidity
393      * uses an invalid opcode to revert (consuming all remaining gas).
394      *
395      * Requirements:
396      *
397      * - The divisor cannot be zero.
398      */
399     function div(uint256 a, uint256 b) internal pure returns (uint256) {
400         return div(a, b, "SafeMath: division by zero");
401     }
402 
403     /**
404      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
405      * division by zero. The result is rounded towards zero.
406      *
407      * Counterpart to Solidity's `/` operator. Note: this function uses a
408      * `revert` opcode (which leaves remaining gas untouched) while Solidity
409      * uses an invalid opcode to revert (consuming all remaining gas).
410      *
411      * Requirements:
412      *
413      * - The divisor cannot be zero.
414      */
415     function div(
416         uint256 a,
417         uint256 b,
418         string memory errorMessage
419     ) internal pure returns (uint256) {
420         require(b > 0, errorMessage);
421         uint256 c = a / b;
422         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
423 
424         return c;
425     }
426 
427     /**
428      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
429      * Reverts when dividing by zero.
430      *
431      * Counterpart to Solidity's `%` operator. This function uses a `revert`
432      * opcode (which leaves remaining gas untouched) while Solidity uses an
433      * invalid opcode to revert (consuming all remaining gas).
434      *
435      * Requirements:
436      *
437      * - The divisor cannot be zero.
438      */
439     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
440         return mod(a, b, "SafeMath: modulo by zero");
441     }
442 
443     /**
444      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
445      * Reverts with custom message when dividing by zero.
446      *
447      * Counterpart to Solidity's `%` operator. This function uses a `revert`
448      * opcode (which leaves remaining gas untouched) while Solidity uses an
449      * invalid opcode to revert (consuming all remaining gas).
450      *
451      * Requirements:
452      *
453      * - The divisor cannot be zero.
454      */
455     function mod(
456         uint256 a,
457         uint256 b,
458         string memory errorMessage
459     ) internal pure returns (uint256) {
460         require(b != 0, errorMessage);
461         return a % b;
462     }
463 }
464 
465 contract Ownable is Context {
466     address private _owner;
467 
468     event OwnershipTransferred(
469         address indexed previousOwner,
470         address indexed newOwner
471     );
472 
473     /**
474      * @dev Initializes the contract setting the deployer as the initial owner.
475      */
476     constructor() {
477         address msgSender = _msgSender();
478         _owner = msgSender;
479         emit OwnershipTransferred(address(0), msgSender);
480     }
481 
482     /**
483      * @dev Returns the address of the current owner.
484      */
485     function owner() public view returns (address) {
486         return _owner;
487     }
488 
489     /**
490      * @dev Throws if called by any account other than the owner.
491      */
492     modifier onlyOwner() {
493         require(_owner == _msgSender(), "Ownable: caller is not the owner");
494         _;
495     }
496 
497     /**
498      * @dev Leaves the contract without owner. It will not be possible to call
499      * `onlyOwner` functions anymore. Can only be called by the current owner.
500      *
501      * NOTE: Renouncing ownership will leave the contract without an owner,
502      * thereby removing any functionality that is only available to the owner.
503      */
504     function renounceOwnership() public virtual onlyOwner {
505         emit OwnershipTransferred(_owner, address(0));
506         _owner = address(0);
507     }
508 
509     /**
510      * @dev Transfers ownership of the contract to a new account (`newOwner`).
511      * Can only be called by the current owner.
512      */
513     function transferOwnership(address newOwner) public virtual onlyOwner {
514         require(
515             newOwner != address(0),
516             "Ownable: new owner is the zero address"
517         );
518         emit OwnershipTransferred(_owner, newOwner);
519         _owner = newOwner;
520     }
521 }
522 
523 library SafeMathInt {
524     int256 private constant MIN_INT256 = int256(1) << 255;
525     int256 private constant MAX_INT256 = ~(int256(1) << 255);
526 
527     /**
528      * @dev Multiplies two int256 variables and fails on overflow.
529      */
530     function mul(int256 a, int256 b) internal pure returns (int256) {
531         int256 c = a * b;
532 
533         // Detect overflow when multiplying MIN_INT256 with -1
534         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
535         require((b == 0) || (c / b == a));
536         return c;
537     }
538 
539     /**
540      * @dev Division of two int256 variables and fails on overflow.
541      */
542     function div(int256 a, int256 b) internal pure returns (int256) {
543         // Prevent overflow when dividing MIN_INT256 by -1
544         require(b != -1 || a != MIN_INT256);
545 
546         // Solidity already throws when dividing by 0.
547         return a / b;
548     }
549 
550     /**
551      * @dev Subtracts two int256 variables and fails on overflow.
552      */
553     function sub(int256 a, int256 b) internal pure returns (int256) {
554         int256 c = a - b;
555         require((b >= 0 && c <= a) || (b < 0 && c > a));
556         return c;
557     }
558 
559     /**
560      * @dev Adds two int256 variables and fails on overflow.
561      */
562     function add(int256 a, int256 b) internal pure returns (int256) {
563         int256 c = a + b;
564         require((b >= 0 && c >= a) || (b < 0 && c < a));
565         return c;
566     }
567 
568     /**
569      * @dev Converts to absolute value, and fails on overflow.
570      */
571     function abs(int256 a) internal pure returns (int256) {
572         require(a != MIN_INT256);
573         return a < 0 ? -a : a;
574     }
575 
576     function toUint256Safe(int256 a) internal pure returns (uint256) {
577         require(a >= 0);
578         return uint256(a);
579     }
580 }
581 
582 library SafeMathUint {
583     function toInt256Safe(uint256 a) internal pure returns (int256) {
584         int256 b = int256(a);
585         require(b >= 0);
586         return b;
587     }
588 }
589 
590 interface IUniswapV2Router01 {
591     function factory() external pure returns (address);
592 
593     function WETH() external pure returns (address);
594 
595     function addLiquidity(
596         address tokenA,
597         address tokenB,
598         uint256 amountADesired,
599         uint256 amountBDesired,
600         uint256 amountAMin,
601         uint256 amountBMin,
602         address to,
603         uint256 deadline
604     )
605         external
606         returns (
607             uint256 amountA,
608             uint256 amountB,
609             uint256 liquidity
610         );
611 
612     function addLiquidityETH(
613         address token,
614         uint256 amountTokenDesired,
615         uint256 amountTokenMin,
616         uint256 amountETHMin,
617         address to,
618         uint256 deadline
619     )
620         external
621         payable
622         returns (
623             uint256 amountToken,
624             uint256 amountETH,
625             uint256 liquidity
626         );
627 
628     function removeLiquidity(
629         address tokenA,
630         address tokenB,
631         uint256 liquidity,
632         uint256 amountAMin,
633         uint256 amountBMin,
634         address to,
635         uint256 deadline
636     ) external returns (uint256 amountA, uint256 amountB);
637 
638     function removeLiquidityETH(
639         address token,
640         uint256 liquidity,
641         uint256 amountTokenMin,
642         uint256 amountETHMin,
643         address to,
644         uint256 deadline
645     ) external returns (uint256 amountToken, uint256 amountETH);
646 
647     function removeLiquidityWithPermit(
648         address tokenA,
649         address tokenB,
650         uint256 liquidity,
651         uint256 amountAMin,
652         uint256 amountBMin,
653         address to,
654         uint256 deadline,
655         bool approveMax,
656         uint8 v,
657         bytes32 r,
658         bytes32 s
659     ) external returns (uint256 amountA, uint256 amountB);
660 
661     function removeLiquidityETHWithPermit(
662         address token,
663         uint256 liquidity,
664         uint256 amountTokenMin,
665         uint256 amountETHMin,
666         address to,
667         uint256 deadline,
668         bool approveMax,
669         uint8 v,
670         bytes32 r,
671         bytes32 s
672     ) external returns (uint256 amountToken, uint256 amountETH);
673 
674     function swapExactTokensForTokens(
675         uint256 amountIn,
676         uint256 amountOutMin,
677         address[] calldata path,
678         address to,
679         uint256 deadline
680     ) external returns (uint256[] memory amounts);
681 
682     function swapTokensForExactTokens(
683         uint256 amountOut,
684         uint256 amountInMax,
685         address[] calldata path,
686         address to,
687         uint256 deadline
688     ) external returns (uint256[] memory amounts);
689 
690     function swapExactETHForTokens(
691         uint256 amountOutMin,
692         address[] calldata path,
693         address to,
694         uint256 deadline
695     ) external payable returns (uint256[] memory amounts);
696 
697     function swapTokensForExactETH(
698         uint256 amountOut,
699         uint256 amountInMax,
700         address[] calldata path,
701         address to,
702         uint256 deadline
703     ) external returns (uint256[] memory amounts);
704 
705     function swapExactTokensForETH(
706         uint256 amountIn,
707         uint256 amountOutMin,
708         address[] calldata path,
709         address to,
710         uint256 deadline
711     ) external returns (uint256[] memory amounts);
712 
713     function swapETHForExactTokens(
714         uint256 amountOut,
715         address[] calldata path,
716         address to,
717         uint256 deadline
718     ) external payable returns (uint256[] memory amounts);
719 
720     function quote(
721         uint256 amountA,
722         uint256 reserveA,
723         uint256 reserveB
724     ) external pure returns (uint256 amountB);
725 
726     function getAmountOut(
727         uint256 amountIn,
728         uint256 reserveIn,
729         uint256 reserveOut
730     ) external pure returns (uint256 amountOut);
731 
732     function getAmountIn(
733         uint256 amountOut,
734         uint256 reserveIn,
735         uint256 reserveOut
736     ) external pure returns (uint256 amountIn);
737 
738     function getAmountsOut(uint256 amountIn, address[] calldata path)
739         external
740         view
741         returns (uint256[] memory amounts);
742 
743     function getAmountsIn(uint256 amountOut, address[] calldata path)
744         external
745         view
746         returns (uint256[] memory amounts);
747 }
748 
749 interface IUniswapV2Router02 is IUniswapV2Router01 {
750     function removeLiquidityETHSupportingFeeOnTransferTokens(
751         address token,
752         uint256 liquidity,
753         uint256 amountTokenMin,
754         uint256 amountETHMin,
755         address to,
756         uint256 deadline
757     ) external returns (uint256 amountETH);
758 
759     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
760         address token,
761         uint256 liquidity,
762         uint256 amountTokenMin,
763         uint256 amountETHMin,
764         address to,
765         uint256 deadline,
766         bool approveMax,
767         uint8 v,
768         bytes32 r,
769         bytes32 s
770     ) external returns (uint256 amountETH);
771 
772     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
773         uint256 amountIn,
774         uint256 amountOutMin,
775         address[] calldata path,
776         address to,
777         uint256 deadline
778     ) external;
779 
780     function swapExactETHForTokensSupportingFeeOnTransferTokens(
781         uint256 amountOutMin,
782         address[] calldata path,
783         address to,
784         uint256 deadline
785     ) external payable;
786 
787     function swapExactTokensForETHSupportingFeeOnTransferTokens(
788         uint256 amountIn,
789         uint256 amountOutMin,
790         address[] calldata path,
791         address to,
792         uint256 deadline
793     ) external;
794 }
795 
796 contract DEGENERATETOOLS is ERC20, Ownable {
797     using SafeMath for uint256;
798 
799     IUniswapV2Router02 public immutable uniswapV2Router;
800     address public immutable uniswapV2Pair;
801 
802     bool private swapping;
803 
804     uint256 public swapTokensAtAmount;
805     uint256 public maxTransactionAmount;
806 
807     uint256 public liquidityActiveBlock = 0; // 0 means liquidity is not active yet
808     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
809 
810     bool public tradingActive = false;
811     bool public limitsInEffect = true;
812     bool public swapEnabled = false;
813 
814     mapping(address => uint256) public _mevBlock;
815 
816     address public constant burnWallet =
817         0x000000000000000000000000000000000000dEaD;
818     address public marketingWallet = 0xfECB4bF10C522FEB0B17AF2742bcc8789a812ED8;
819 
820     uint256 public constant feeDivisor = 1000;
821 
822     uint256 public marketingBuyFee;
823     uint256 public totalBuyFees;
824 
825     uint256 public marketingSellFee;
826     uint256 public totalSellFees;
827 
828     uint256 public tokensForFees;
829     uint256 public tokensForMarketing;
830 
831     uint256 public tokenLockBlockNum;
832 
833     bool public transferDelayEnabled = true;
834     uint256 public maxWallet;
835 
836     mapping(address => bool) private _blacklist;
837 
838     mapping(address => bool) private _isExcludedFromFees;
839     mapping(address => bool) public _isExcludedMaxTransactionAmount;
840 
841     mapping(address => bool) public automatedMarketMakerPairs;
842 
843     mapping(address => uint256) public _earlyBuyer;
844 
845     event ExcludeFromFees(address indexed account, bool isExcluded);
846     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
847 
848     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
849 
850     event SwapAndLiquify(
851         uint256 tokensSwapped,
852         uint256 ethReceived,
853         uint256 tokensIntoLiqudity
854     );
855 
856     constructor() ERC20("degenerate.tools", "DTOOLS") {
857         uint256 totalSupply = 1 * 1e9 * 1e18;
858 
859         swapTokensAtAmount = (totalSupply * 1) / 10000; // 0.01% swap tokens amount
860         maxTransactionAmount = (totalSupply * 10) / 1000; // 1% maxTransactionAmountTxn
861         maxWallet = (totalSupply * 30) / 1000; // 3% maxWallet
862 
863         marketingBuyFee = 20; // 2%
864         totalBuyFees = marketingBuyFee; // 2%
865 
866         marketingSellFee = 30; // 3%
867         totalSellFees = marketingSellFee;
868 
869         tokenLockBlockNum = 1;
870 
871         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
872             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
873         );
874 
875         // Create a uniswap pair for this new token
876         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
877             .createPair(address(this), _uniswapV2Router.WETH());
878 
879         uniswapV2Router = _uniswapV2Router;
880         uniswapV2Pair = _uniswapV2Pair;
881 
882         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
883 
884         // exclude from paying fees or having max transaction amount
885         excludeFromFees(owner(), true);
886         excludeFromFees(address(this), true);
887         excludeFromFees(address(0xdead), true);
888         excludeFromFees(address(_uniswapV2Router), true);
889         excludeFromFees(address(marketingWallet), true);
890 
891         excludeFromMaxTransaction(owner(), true);
892         excludeFromMaxTransaction(address(this), true);
893         excludeFromMaxTransaction(address(0xdead), true);
894         excludeFromMaxTransaction(address(marketingWallet), true);
895 
896         _createInitialSupply(address(owner()), totalSupply);
897     }
898 
899     receive() external payable {}
900 
901     function enableTrading() external onlyOwner {
902         require(!tradingActive, "Cannot re-enable trading");
903         tradingActive = true;
904         swapEnabled = true;
905         tradingActiveBlock = block.number;
906     }
907 
908     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
909         require(
910             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
911             "Cannot set maxTransactionAmount lower than 0.1%"
912         );
913         maxTransactionAmount = newNum * (10**18);
914     }
915 
916     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
917         require(
918             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
919             "Cannot set maxWallet lower than 0.5%"
920         );
921         maxWallet = newNum * (10**18);
922     }
923 
924     function excludeFromMaxTransaction(address updAds, bool isEx)
925         public
926         onlyOwner
927     {
928         _isExcludedMaxTransactionAmount[updAds] = isEx;
929     }
930 
931     // only use to disable contract sales if absolutely necessary (emergency use only)
932     function updateSwapEnabled(bool enabled) external onlyOwner {
933         swapEnabled = enabled;
934     }
935 
936     function updateSellFees(uint256 _marketingSellFee) external onlyOwner {
937         marketingSellFee = _marketingSellFee;
938         totalSellFees = marketingSellFee;
939         require(totalSellFees <= 150, "Must keep fees at 15% or less");
940     }
941 
942     function updateBuyFees(uint256 _marketingBuyFee) external onlyOwner {
943         marketingBuyFee = _marketingBuyFee;
944         totalBuyFees = marketingBuyFee;
945         require(totalSellFees <= 150, "Must keep fees at 15% or less");
946     }
947 
948     function updateEarlyBuyBlockNum(uint256 extrablocks) external onlyOwner {
949         tokenLockBlockNum = extrablocks;
950         require(extrablocks <= 2, "Must keep early block number <= 2");
951     }
952 
953     function excludeFromFees(address account, bool excluded) public onlyOwner {
954         _isExcludedFromFees[account] = excluded;
955 
956         emit ExcludeFromFees(account, excluded);
957     }
958 
959     function excludeMultipleAccountsFromFees(
960         address[] calldata accounts,
961         bool excluded
962     ) external onlyOwner {
963         for (uint256 i = 0; i < accounts.length; i++) {
964             _isExcludedFromFees[accounts[i]] = excluded;
965         }
966 
967         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
968     }
969 
970     function setAutomatedMarketMakerPair(address pair, bool value)
971         external
972         onlyOwner
973     {
974         require(
975             pair != uniswapV2Pair,
976             "The Uniswap pair cannot be removed from automatedMarketMakerPairs"
977         );
978 
979         _setAutomatedMarketMakerPair(pair, value);
980     }
981 
982     function _setAutomatedMarketMakerPair(address pair, bool value) private {
983         automatedMarketMakerPairs[pair] = value;
984         emit SetAutomatedMarketMakerPair(pair, value);
985     }
986 
987     function isExcludedFromFees(address account) external view returns (bool) {
988         return _isExcludedFromFees[account];
989     }
990 
991     function _transfer(
992         address from,
993         address to,
994         uint256 amount
995     ) internal override {
996         require(from != address(0), "ERC20: transfer from the zero address");
997         require(to != address(0), "ERC20: transfer to the zero address");
998         require(
999             !_blacklist[to] && !_blacklist[from],
1000             "You have been blacklisted from transfering tokens"
1001         );
1002 
1003         if (amount == 0) {
1004             super._transfer(from, to, 0);
1005             return;
1006         }
1007 
1008         if (!tradingActive) {
1009             require(
1010                 _isExcludedFromFees[from] || _isExcludedFromFees[to],
1011                 "Trading is not active yet."
1012             );
1013         }
1014 
1015         if (limitsInEffect) {
1016             if (
1017                 from != owner() &&
1018                 to != owner() &&
1019                 to != address(0) &&
1020                 to != address(0xdead) &&
1021                 !swapping
1022             ) {
1023                 if (!tradingActive) {
1024                     require(
1025                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1026                         "Trading is not active."
1027                     );
1028                 }
1029 
1030                 //when buy
1031                 if (
1032                     automatedMarketMakerPairs[from] &&
1033                     !_isExcludedMaxTransactionAmount[to]
1034                 ) {
1035                     require(
1036                         amount <= maxTransactionAmount + 1 * 1e18,
1037                         "Buy transfer amount exceeds the maxTransactionAmount."
1038                     );
1039                     require(
1040                         amount + balanceOf(to) <= maxWallet,
1041                         "Max wallet exceeded"
1042                     );
1043                 }
1044                 //when sell
1045                 else if (
1046                     automatedMarketMakerPairs[to] &&
1047                     !_isExcludedMaxTransactionAmount[from]
1048                 ) {
1049                     require(
1050                         amount <= maxTransactionAmount + 1 * 1e18,
1051                         "Sell transfer amount exceeds the maxTransactionAmount."
1052                     );
1053                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1054                     require(
1055                         amount + balanceOf(to) <= maxWallet,
1056                         "Max wallet exceeded"
1057                     );
1058                 }
1059             }
1060         }
1061 
1062         uint256 contractTokenBalance = balanceOf(address(this));
1063         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1064 
1065         if (
1066             canSwap &&
1067             swapEnabled &&
1068             !swapping &&
1069             !automatedMarketMakerPairs[from] &&
1070             !_isExcludedFromFees[from] &&
1071             !_isExcludedFromFees[to]
1072         ) {
1073             swapping = true;
1074             swapBack();
1075             swapping = false;
1076         }
1077 
1078         bool takeFee = !swapping;
1079 
1080         // if any account belongs to _isExcludedFromFee account then remove the fee
1081         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1082             takeFee = false;
1083         }
1084 
1085         uint256 fees = 0;
1086 
1087         // no taxes on transfers (non buys/sells)
1088         if (takeFee) {
1089             // on sell take fees, purchase token and burn it
1090             if (automatedMarketMakerPairs[to] && totalSellFees > 0) {
1091                 fees = amount.mul(totalSellFees).div(feeDivisor);
1092                 tokensForFees += fees;
1093                 tokensForMarketing += (fees * marketingSellFee) / totalSellFees;
1094             }
1095             // on buy
1096             else if (automatedMarketMakerPairs[from]) {
1097                 fees = amount.mul(totalBuyFees).div(feeDivisor);
1098                 tokensForFees += fees;
1099                 tokensForMarketing += (fees * marketingBuyFee) / totalBuyFees;
1100             }
1101 
1102             if (fees > 0) {
1103                 super._transfer(from, address(this), fees);
1104             }
1105 
1106             amount -= fees;
1107         }
1108 
1109         // MEV Blocker / Anti-Snipe
1110         if (to != owner() && from != owner()) {
1111             if (to == tx.origin) {
1112                 //~// on buy
1113 
1114                 // -- Sniper Early Block Token Lock: buy handler
1115                 uint256 snipeLockBlock = tradingActiveBlock + tokenLockBlockNum;
1116                 if (block.number <= snipeLockBlock) {
1117                     // on block 0-tokenLockBlockNum buy
1118                     _earlyBuyer[tx.origin] = block.number + 90;
1119                 }
1120 
1121                 // -- MEV Blocker: buy handler
1122                 if (_mevBlock[tx.origin] != 0) {
1123                     require(
1124                         _mevBlock[tx.origin] < block.number,
1125                         "MEV Blocker: Only one swap per block allowed."
1126                     );
1127                 }
1128                 _mevBlock[tx.origin] = block.number;
1129             } else if (from == tx.origin) {
1130                 //~// on sell
1131                 // -- Sniper Early Block Token Lock: sell handler
1132                 if (_earlyBuyer[tx.origin] != 0) {
1133                     require(
1134                         amount <= (maxTransactionAmount / 4),
1135                         "Early block buyers can only sell 25% max tx per hour."
1136                     );
1137                     require(
1138                         _earlyBuyer[tx.origin] < block.number,
1139                         "Early block buyers can only sell 25% max tx per hour."
1140                     );
1141                     _earlyBuyer[tx.origin] = block.number + 180;
1142                 }
1143 
1144                 // -- MEV Blocker: sell handler
1145                 if (_mevBlock[tx.origin] != 0) {
1146                     require(
1147                         _mevBlock[tx.origin] < block.number,
1148                         "MEV Blocker: Only one swap per block allowed."
1149                     );
1150                 }
1151                 _mevBlock[tx.origin] = block.number;
1152             }
1153         }
1154 
1155         super._transfer(from, to, amount);
1156     }
1157 
1158     function swapTokensForEth(uint256 tokenAmount) private {
1159         // generate the uniswap pair path of token -> weth
1160         address[] memory path = new address[](2);
1161         path[0] = address(this);
1162         path[1] = uniswapV2Router.WETH();
1163 
1164         _approve(address(this), address(uniswapV2Router), tokenAmount);
1165 
1166         // make the swap
1167         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1168             tokenAmount,
1169             0, // accept any amount of ETH
1170             path,
1171             address(this),
1172             block.timestamp
1173         );
1174     }
1175 
1176     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1177         // approve token transfer to cover all possible scenarios
1178         _approve(address(this), address(uniswapV2Router), tokenAmount);
1179 
1180         // add the liquidity
1181         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1182             address(this),
1183             tokenAmount,
1184             0, // slippage is unavoidable
1185             0, // slippage is unavoidable
1186             address(0xdead),
1187             block.timestamp
1188         );
1189     }
1190 
1191     function manualSwap() external onlyOwner {
1192         uint256 contractBalance = balanceOf(address(this));
1193         swapTokensForEth(contractBalance);
1194     }
1195 
1196     // remove limits after token is stable
1197     function removeLimits() external onlyOwner returns (bool) {
1198         limitsInEffect = false;
1199         return true;
1200     }
1201 
1202     function swapBack() private {
1203         uint256 contractBalance = balanceOf(address(this));
1204         uint256 totalTokensToSwap = tokensForMarketing;
1205         bool success;
1206 
1207         if (contractBalance == 0 || totalTokensToSwap == 0) {
1208             return;
1209         }
1210 
1211         uint256 amountToSwapForETH = contractBalance;
1212         swapTokensForEth(amountToSwapForETH);
1213 
1214         (success, ) = address(marketingWallet).call{
1215             value: address(this).balance
1216         }("");
1217 
1218         tokensForMarketing = 0;
1219         tokensForFees = 0;
1220     }
1221 
1222     function changeAccountStatus(address[] memory bots_, bool status)
1223         public
1224         onlyOwner
1225     {
1226         for (uint256 i = 0; i < bots_.length; i++) {
1227             _blacklist[bots_[i]] = status;
1228         }
1229     }
1230 
1231     function withdrawStuckEth() external onlyOwner {
1232         (bool success, ) = address(msg.sender).call{
1233             value: address(this).balance
1234         }("");
1235         require(success, "failed to withdraw");
1236     }
1237 }