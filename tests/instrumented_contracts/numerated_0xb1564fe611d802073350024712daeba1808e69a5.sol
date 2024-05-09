1 /*
2 
3 Telegram: https://t.me/BlackholeEntrance
4 Twitter: https://twitter.com/BlackholeEth
5 
6 */
7 
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity <=0.8.17;
11 pragma experimental ABIEncoderV2;
12 
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 
25 abstract contract Ownable is Context {
26     address private _owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30    
31     constructor() {
32         _transferOwnership(_msgSender());
33     }
34 
35     
36     function owner() public view virtual returns (address) {
37         return _owner;
38     }
39 
40     
41     modifier onlyOwner() {
42         require(owner() == _msgSender(), "Ownable: caller is not the owner");
43         _;
44     }
45 
46     
47     function renounceOwnership() public virtual onlyOwner {
48         _transferOwnership(address(0));
49     }
50 
51     
52     function transferOwnership(address newOwner) public virtual onlyOwner {
53         require(newOwner != address(0), "Ownable: new owner is the zero address");
54         _transferOwnership(newOwner);
55     }
56 
57     
58     function _transferOwnership(address newOwner) internal virtual {
59         address oldOwner = _owner;
60         _owner = newOwner;
61         emit OwnershipTransferred(oldOwner, newOwner);
62     }
63 }
64 
65 
66 interface IERC20 {
67   
68 
69     function totalSupply() external view returns (uint256);
70 
71    
72     function balanceOf(address account) external view returns (uint256);
73 
74     
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     
78     function allowance(address owner, address spender) external view returns (uint256);
79 
80     
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
89 
90     
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 interface IERC20Metadata is IERC20 {
99     
100     function name() external view returns (string memory);
101 
102     function symbol() external view returns (string memory);
103 
104     function decimals() external view returns (uint8);
105 }
106 
107 
108  
109 contract ERC20 is Context, IERC20, IERC20Metadata {
110     mapping(address => uint256) private _balances;
111 
112     mapping(address => mapping(address => uint256)) private _allowances;
113 
114     uint256 private _totalSupply;
115 
116     string private _name;
117     string private _symbol;
118 
119    
120     constructor(string memory name_, string memory symbol_) {
121         _name = name_;
122         _symbol = symbol_;
123     }
124 
125     
126     function name() public view virtual override returns (string memory) {
127         return _name;
128     }
129 
130     
131     function symbol() public view virtual override returns (string memory) {
132         return _symbol;
133     }
134 
135    
136     function decimals() public view virtual override returns (uint8) {
137         return 18;
138     }
139 
140     
141     function totalSupply() public view virtual override returns (uint256) {
142         return _totalSupply;
143     }
144 
145     
146     function balanceOf(address account) public view virtual override returns (uint256) {
147         return _balances[account];
148     }
149 
150     
151     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
152         _transfer(_msgSender(), recipient, amount);
153         return true;
154     }
155 
156     
157     function allowance(address owner, address spender) public view virtual override returns (uint256) {
158         return _allowances[owner][spender];
159     }
160 
161     
162     function approve(address spender, uint256 amount) public virtual override returns (bool) {
163         _approve(_msgSender(), spender, amount);
164         return true;
165     }
166 
167    
168     function transferFrom(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) public virtual override returns (bool) {
173         _transfer(sender, recipient, amount);
174 
175         uint256 currentAllowance = _allowances[sender][_msgSender()];
176         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
177         unchecked {
178             _approve(sender, _msgSender(), currentAllowance - amount);
179         }
180 
181         return true;
182     }
183 
184     
185     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
186         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
187         return true;
188     }
189 
190     
191     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
192         uint256 currentAllowance = _allowances[_msgSender()][spender];
193         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
194         unchecked {
195             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
196         }
197 
198         return true;
199     }
200 
201     
202     function _transfer(
203         address sender,
204         address recipient,
205         uint256 amount
206     ) internal virtual {
207         require(sender != address(0), "ERC20: transfer from the zero address");
208         require(recipient != address(0), "ERC20: transfer to the zero address");
209 
210         _beforeTokenTransfer(sender, recipient, amount);
211 
212         uint256 senderBalance = _balances[sender];
213         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
214         unchecked {
215             _balances[sender] = senderBalance - amount;
216         }
217         _balances[recipient] += amount;
218 
219         emit Transfer(sender, recipient, amount);
220 
221         _afterTokenTransfer(sender, recipient, amount);
222     }
223 
224     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
225      * the total supply.
226      *
227      * Emits a {Transfer} event with `from` set to the zero address.
228      *
229      * Requirements:
230      *
231      * - `account` cannot be the zero address.
232      */
233     function _mint(address account, uint256 amount) internal virtual {
234         require(account != address(0), "ERC20: mint to the zero address");
235 
236         _beforeTokenTransfer(address(0), account, amount);
237 
238         _totalSupply += amount;
239         _balances[account] += amount;
240         emit Transfer(address(0), account, amount);
241 
242         _afterTokenTransfer(address(0), account, amount);
243     }
244 
245     /**
246      * @dev Destroys `amount` tokens from `account`, reducing the
247      * total supply.
248      *
249      * Emits a {Transfer} event with `to` set to the zero address.
250      *
251      * Requirements:
252      *
253      * - `account` cannot be the zero address.
254      * - `account` must have at least `amount` tokens.
255      */
256     function _burn(address account, uint256 amount) internal virtual {
257         require(account != address(0), "ERC20: burn from the zero address");
258 
259         _beforeTokenTransfer(account, address(0), amount);
260 
261         uint256 accountBalance = _balances[account];
262         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
263         unchecked {
264             _balances[account] = accountBalance - amount;
265         }
266         _totalSupply -= amount;
267 
268         emit Transfer(account, address(0), amount);
269 
270         _afterTokenTransfer(account, address(0), amount);
271     }
272 
273     /**
274      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
275      *
276      * This internal function is equivalent to `approve`, and can be used to
277      * e.g. set automatic allowances for certain subsystems, etc.
278      *
279      * Emits an {Approval} event.
280      *
281      * Requirements:
282      *
283      * - `owner` cannot be the zero address.
284      * - `spender` cannot be the zero address.
285      */
286     function _approve(
287         address owner,
288         address spender,
289         uint256 amount
290     ) internal virtual {
291         require(owner != address(0), "ERC20: approve from the zero address");
292         require(spender != address(0), "ERC20: approve to the zero address");
293 
294         _allowances[owner][spender] = amount;
295         emit Approval(owner, spender, amount);
296     }
297 
298     /**
299      * @dev Hook that is called before any transfer of tokens. This includes
300      * minting and burning.
301      *
302      * Calling conditions:
303      *
304      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
305      * will be transferred to `to`.
306      * - when `from` is zero, `amount` tokens will be minted for `to`.
307      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
308      * - `from` and `to` are never both zero.
309      *
310      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
311      */
312     function _beforeTokenTransfer(
313         address from,
314         address to,
315         uint256 amount
316     ) internal virtual {}
317 
318     /**
319      * @dev Hook that is called after any transfer of tokens. This includes
320      * minting and burning.
321      *
322      * Calling conditions:
323      *
324      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
325      * has been transferred to `to`.
326      * - when `from` is zero, `amount` tokens have been minted for `to`.
327      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
328      * - `from` and `to` are never both zero.
329      *
330      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
331      */
332     function _afterTokenTransfer(
333         address from,
334         address to,
335         uint256 amount
336     ) internal virtual {}
337 }
338 
339 
340 library SafeMath {
341     /**
342      * @dev Returns the addition of two unsigned integers, with an overflow flag.
343      *
344      * _Available since v3.4._
345      */
346     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
347         unchecked {
348             uint256 c = a + b;
349             if (c < a) return (false, 0);
350             return (true, c);
351         }
352     }
353 
354     /**
355      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
356      *
357      * _Available since v3.4._
358      */
359     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
360         unchecked {
361             if (b > a) return (false, 0);
362             return (true, a - b);
363         }
364     }
365 
366     /**
367      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
368      *
369      * _Available since v3.4._
370      */
371     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
372         unchecked {
373             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
374             // benefit is lost if 'b' is also tested.
375             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
376             if (a == 0) return (true, 0);
377             uint256 c = a * b;
378             if (c / a != b) return (false, 0);
379             return (true, c);
380         }
381     }
382 
383     /**
384      * @dev Returns the division of two unsigned integers, with a division by zero flag.
385      *
386      * _Available since v3.4._
387      */
388     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
389         unchecked {
390             if (b == 0) return (false, 0);
391             return (true, a / b);
392         }
393     }
394 
395     /**
396      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
397      *
398      * _Available since v3.4._
399      */
400     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
401         unchecked {
402             if (b == 0) return (false, 0);
403             return (true, a % b);
404         }
405     }
406 
407     /**
408      * @dev Returns the addition of two unsigned integers, reverting on
409      * overflow.
410      *
411      * Counterpart to Solidity's `+` operator.
412      *
413      * Requirements:
414      *
415      * - Addition cannot overflow.
416      */
417     function add(uint256 a, uint256 b) internal pure returns (uint256) {
418         return a + b;
419     }
420 
421     /**
422      * @dev Returns the subtraction of two unsigned integers, reverting on
423      * overflow (when the result is negative).
424      *
425      * Counterpart to Solidity's `-` operator.
426      *
427      * Requirements:
428      *
429      * - Subtraction cannot overflow.
430      */
431     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
432         return a - b;
433     }
434 
435     /**
436      * @dev Returns the multiplication of two unsigned integers, reverting on
437      * overflow.
438      *
439      * Counterpart to Solidity's `*` operator.
440      *
441      * Requirements:
442      *
443      * - Multiplication cannot overflow.
444      */
445     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
446         return a * b;
447     }
448 
449     /**
450      * @dev Returns the integer division of two unsigned integers, reverting on
451      * division by zero. The result is rounded towards zero.
452      *
453      * Counterpart to Solidity's `/` operator.
454      *
455      * Requirements:
456      *
457      * - The divisor cannot be zero.
458      */
459     function div(uint256 a, uint256 b) internal pure returns (uint256) {
460         return a / b;
461     }
462 
463     /**
464      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
465      * reverting when dividing by zero.
466      *
467      * Counterpart to Solidity's `%` operator. This function uses a `revert`
468      * opcode (which leaves remaining gas untouched) while Solidity uses an
469      * invalid opcode to revert (consuming all remaining gas).
470      *
471      * Requirements:
472      *
473      * - The divisor cannot be zero.
474      */
475     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
476         return a % b;
477     }
478 
479     /**
480      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
481      * overflow (when the result is negative).
482      *
483      * CAUTION: This function is deprecated because it requires allocating memory for the error
484      * message unnecessarily. For custom revert reasons use {trySub}.
485      *
486      * Counterpart to Solidity's `-` operator.
487      *
488      * Requirements:
489      *
490      * - Subtraction cannot overflow.
491      */
492     function sub(
493         uint256 a,
494         uint256 b,
495         string memory errorMessage
496     ) internal pure returns (uint256) {
497         unchecked {
498             require(b <= a, errorMessage);
499             return a - b;
500         }
501     }
502 
503     /**
504      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
505      * division by zero. The result is rounded towards zero.
506      *
507      * Counterpart to Solidity's `/` operator. Note: this function uses a
508      * `revert` opcode (which leaves remaining gas untouched) while Solidity
509      * uses an invalid opcode to revert (consuming all remaining gas).
510      *
511      * Requirements:
512      *
513      * - The divisor cannot be zero.
514      */
515     function div(
516         uint256 a,
517         uint256 b,
518         string memory errorMessage
519     ) internal pure returns (uint256) {
520         unchecked {
521             require(b > 0, errorMessage);
522             return a / b;
523         }
524     }
525 
526     /**
527      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
528      * reverting with custom message when dividing by zero.
529      *
530      * CAUTION: This function is deprecated because it requires allocating memory for the error
531      * message unnecessarily. For custom revert reasons use {tryMod}.
532      *
533      * Counterpart to Solidity's `%` operator. This function uses a `revert`
534      * opcode (which leaves remaining gas untouched) while Solidity uses an
535      * invalid opcode to revert (consuming all remaining gas).
536      *
537      * Requirements:
538      *
539      * - The divisor cannot be zero.
540      */
541     function mod(
542         uint256 a,
543         uint256 b,
544         string memory errorMessage
545     ) internal pure returns (uint256) {
546         unchecked {
547             require(b > 0, errorMessage);
548             return a % b;
549         }
550     }
551 }
552 
553 ////// src/IUniswapV2Factory.sol
554 /* pragma solidity 0.8.10; */
555 /* pragma experimental ABIEncoderV2; */
556 
557 interface IUniswapV2Factory {
558     event PairCreated(
559         address indexed token0,
560         address indexed token1,
561         address pair,
562         uint256
563     );
564 
565     function feeTo() external view returns (address);
566 
567     function feeToSetter() external view returns (address);
568 
569     function getPair(address tokenA, address tokenB)
570         external
571         view
572         returns (address pair);
573 
574     function allPairs(uint256) external view returns (address pair);
575 
576     function allPairsLength() external view returns (uint256);
577 
578     function createPair(address tokenA, address tokenB)
579         external
580         returns (address pair);
581 
582     function setFeeTo(address) external;
583 
584     function setFeeToSetter(address) external;
585 }
586 
587 ////// src/IUniswapV2Pair.sol
588 /* pragma solidity 0.8.10; */
589 /* pragma experimental ABIEncoderV2; */
590 
591 interface IUniswapV2Pair {
592     event Approval(
593         address indexed owner,
594         address indexed spender,
595         uint256 value
596     );
597     event Transfer(address indexed from, address indexed to, uint256 value);
598 
599     function name() external pure returns (string memory);
600 
601     function symbol() external pure returns (string memory);
602 
603     function decimals() external pure returns (uint8);
604 
605     function totalSupply() external view returns (uint256);
606 
607     function balanceOf(address owner) external view returns (uint256);
608 
609     function allowance(address owner, address spender)
610         external
611         view
612         returns (uint256);
613 
614     function approve(address spender, uint256 value) external returns (bool);
615 
616     function transfer(address to, uint256 value) external returns (bool);
617 
618     function transferFrom(
619         address from,
620         address to,
621         uint256 value
622     ) external returns (bool);
623 
624     function DOMAIN_SEPARATOR() external view returns (bytes32);
625 
626     function PERMIT_TYPEHASH() external pure returns (bytes32);
627 
628     function nonces(address owner) external view returns (uint256);
629 
630     function permit(
631         address owner,
632         address spender,
633         uint256 value,
634         uint256 deadline,
635         uint8 v,
636         bytes32 r,
637         bytes32 s
638     ) external;
639 
640     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
641     event Burn(
642         address indexed sender,
643         uint256 amount0,
644         uint256 amount1,
645         address indexed to
646     );
647     event Swap(
648         address indexed sender,
649         uint256 amount0In,
650         uint256 amount1In,
651         uint256 amount0Out,
652         uint256 amount1Out,
653         address indexed to
654     );
655     event Sync(uint112 reserve0, uint112 reserve1);
656 
657     function MINIMUM_LIQUIDITY() external pure returns (uint256);
658 
659     function factory() external view returns (address);
660 
661     function token0() external view returns (address);
662 
663     function token1() external view returns (address);
664 
665     function getReserves()
666         external
667         view
668         returns (
669             uint112 reserve0,
670             uint112 reserve1,
671             uint32 blockTimestampLast
672         );
673 
674     function price0CumulativeLast() external view returns (uint256);
675 
676     function price1CumulativeLast() external view returns (uint256);
677 
678     function kLast() external view returns (uint256);
679 
680     function mint(address to) external returns (uint256 liquidity);
681 
682     function burn(address to)
683         external
684         returns (uint256 amount0, uint256 amount1);
685 
686     function swap(
687         uint256 amount0Out,
688         uint256 amount1Out,
689         address to,
690         bytes calldata data
691     ) external;
692 
693     function skim(address to) external;
694 
695     function sync() external;
696 
697     function initialize(address, address) external;
698 }
699 
700 
701 
702 interface IUniswapV2Router02 {
703     function factory() external pure returns (address);
704 
705     function WETH() external pure returns (address);
706 
707     function addLiquidity(
708         address tokenA,
709         address tokenB,
710         uint256 amountADesired,
711         uint256 amountBDesired,
712         uint256 amountAMin,
713         uint256 amountBMin,
714         address to,
715         uint256 deadline
716     )
717         external
718         returns (
719             uint256 amountA,
720             uint256 amountB,
721             uint256 liquidity
722         );
723 
724     function addLiquidityETH(
725         address token,
726         uint256 amountTokenDesired,
727         uint256 amountTokenMin,
728         uint256 amountETHMin,
729         address to,
730         uint256 deadline
731     )
732         external
733         payable
734         returns (
735             uint256 amountToken,
736             uint256 amountETH,
737             uint256 liquidity
738         );
739 
740     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
741         uint256 amountIn,
742         uint256 amountOutMin,
743         address[] calldata path,
744         address to,
745         uint256 deadline
746     ) external;
747 
748     function swapExactETHForTokensSupportingFeeOnTransferTokens(
749         uint256 amountOutMin,
750         address[] calldata path,
751         address to,
752         uint256 deadline
753     ) external payable;
754 
755     function swapExactTokensForETHSupportingFeeOnTransferTokens(
756         uint256 amountIn,
757         uint256 amountOutMin,
758         address[] calldata path,
759         address to,
760         uint256 deadline
761     ) external;
762 }
763 
764 
765 contract Blackhole is ERC20, Ownable {
766     using SafeMath for uint256;
767 
768     IUniswapV2Router02 public immutable uniswapV2Router;
769     address public immutable uniswapV2Pair;
770     address public constant deadAddress = address(0xdead);
771 
772     bool private swapping;
773 
774     address public marketingWallet;
775     address public developmentWallet;
776     address public deployerWallet;
777     address public lpLocker;
778 
779     uint256 public maxTransactionAmount;
780     uint256 public swapTokensAtAmount;
781     uint256 public maxWallet;
782 
783     uint256 public percentForLPBurn = 50; // 50 = .5%
784     bool public lpBurnEnabled = true;
785     uint256 public lpBurnFrequency = 600 seconds;
786     uint256 public lastLpBurnTime;
787 
788     uint256 public manualBurnFrequency = 30 minutes;
789     uint256 public lastManualLpBurnTime;
790 
791     bool public limitsInEffect = true;
792     bool public tradingActive = true;
793     bool public swapEnabled = true;
794 
795     // Anti-bot and anti-whale mappings and variables
796     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
797     bool public transferDelayEnabled = true;
798 
799     uint256 public buyTotalFees;
800     uint256 public buyMarketingFee;
801     uint256 public buyLiquidityFee;
802     uint256 public buyDevFee;
803 
804     uint256 public sellTotalFees;
805     uint256 public sellMarketingFee;
806     uint256 public sellLiquidityFee;
807     uint256 public sellDevFee;
808 
809     uint256 public tokensForMarketing;
810     uint256 public tokensForLiquidity;
811     uint256 public tokensForDev;
812 
813     /******************/
814 
815     // exlcude from fees and max transaction amount
816     mapping(address => bool) private _isExcludedFromFees;
817     mapping(address => bool) public _isExcludedMaxTransactionAmount;
818 
819     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
820     // could be subject to a maximum transfer amount
821     mapping(address => bool) public automatedMarketMakerPairs;
822 
823     event UpdateUniswapV2Router(
824         address indexed newAddress,
825         address indexed oldAddress
826     );
827 
828     event ExcludeFromFees(address indexed account, bool isExcluded);
829 
830     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
831 
832     event marketingWalletUpdated(
833         address indexed newWallet,
834         address indexed oldWallet
835     );
836 
837     event developmentWalletUpdated(
838         address indexed newWallet,
839         address indexed oldWallet
840     );
841 
842     event SwapAndLiquify(
843         uint256 tokensSwapped,
844         uint256 ethReceived,
845         uint256 tokensIntoLiquidity
846     );
847 
848     event AutoNukeLP();
849 
850     event ManualNukeLP();
851 
852     constructor() ERC20("Blackhole", "SAGA") {
853         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
854             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
855         );
856 
857         excludeFromMaxTransaction(address(_uniswapV2Router), true);
858         uniswapV2Router = _uniswapV2Router;
859 
860         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
861             .createPair(address(this), _uniswapV2Router.WETH());
862         excludeFromMaxTransaction(address(uniswapV2Pair), true);
863         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
864 
865         uint256 _buyMarketingFee = 5;
866         uint256 _buyLiquidityFee = 0;
867         uint256 _buyDevFee = 5;
868 
869         uint256 _sellMarketingFee = 20;
870         uint256 _sellLiquidityFee = 0;
871         uint256 _sellDevFee = 20;
872 
873         uint256 totalSupply = 1_000_000_000 * 1e18;
874 
875         maxTransactionAmount = 20_000_000 * 1e18; 
876         maxWallet = 20_000_000 * 1e18; 
877         swapTokensAtAmount = (totalSupply * 5) / 10000; 
878 
879         buyMarketingFee = _buyMarketingFee;
880         buyLiquidityFee = _buyLiquidityFee;
881         buyDevFee = _buyDevFee;
882         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
883 
884         sellMarketingFee = _sellMarketingFee;
885         sellLiquidityFee = _sellLiquidityFee;
886         sellDevFee = _sellDevFee;
887         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
888 
889         deployerWallet = address(0x707EF4302d2f4897A23b42C5f1E048DFF445459B);
890         marketingWallet = address(0x36F0abc2bC919F54Eda678EDFdE3F71BB5a7D815); // set as marketing wallet
891         developmentWallet = address(0xC1E691e4D83bEcAe5c8D1c7858676b4682133759); // set as development wallet
892         lpLocker = address(0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214); 
893 
894         // exclude from paying fees or having max transaction amount
895         excludeFromFees(owner(), true);
896         excludeFromFees(address(this), true);
897         excludeFromFees(address(0xdead), true);
898         excludeFromFees(marketingWallet, true);
899         excludeFromFees(lpLocker, true);
900 
901         excludeFromMaxTransaction(owner(), true);
902         excludeFromMaxTransaction(address(this), true);
903         excludeFromMaxTransaction(address(0xdead), true);
904         excludeFromMaxTransaction(deployerWallet, true);
905         excludeFromMaxTransaction(marketingWallet, true);
906         excludeFromMaxTransaction(lpLocker, true);
907 
908         /*
909             _mint is an internal function in ERC20.sol that is only called here,
910             and CANNOT be called ever again
911         */
912         _mint(msg.sender, totalSupply);
913     }
914 
915     receive() external payable {}
916 
917     // once enabled, can never be turned off
918     function enableTrading() external onlyOwner {
919         tradingActive = true;
920         swapEnabled = true;
921         lastLpBurnTime = block.timestamp;
922     }
923 
924     // remove limits after token is stable
925     function removeLimits() external onlyOwner returns (bool) {
926         limitsInEffect = false;
927         return true;
928     }
929 
930     // disable Transfer delay - cannot be reenabled
931     function disableTransferDelay() external onlyOwner returns (bool) {
932         transferDelayEnabled = false;
933         return true;
934     }
935 
936     // change the minimum amount of tokens to sell from fees
937     function updateSwapTokensAtAmount(uint256 newAmount)
938         external
939         onlyOwner
940         returns (bool)
941     {
942         require(
943             newAmount >= (totalSupply() * 1) / 100000,
944             "Swap amount cannot be lower than 0.001% total supply."
945         );
946         require(
947             newAmount <= (totalSupply() * 5) / 1000,
948             "Swap amount cannot be higher than 0.5% total supply."
949         );
950         swapTokensAtAmount = newAmount;
951         return true;
952     }
953 
954     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
955         require(
956             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
957             "Cannot set maxTransactionAmount lower than 0.1%"
958         );
959         maxTransactionAmount = newNum * (10**18);
960     }
961 
962     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
963         require(
964             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
965             "Cannot set maxWallet lower than 0.5%"
966         );
967         maxWallet = newNum * (10**18);
968     }
969 
970     function excludeFromMaxTransaction(address updAds, bool isEx)
971         public
972         onlyOwner
973     {
974         _isExcludedMaxTransactionAmount[updAds] = isEx;
975     }
976 
977     // only use to disable contract sales if absolutely necessary (emergency use only)
978     function updateSwapEnabled(bool enabled) external onlyOwner {
979         swapEnabled = enabled;
980     }
981 
982     function updateBuyFees(
983         uint256 _marketingFee,
984         uint256 _liquidityFee,
985         uint256 _devFee
986     ) external onlyOwner {
987         buyMarketingFee = _marketingFee;
988         buyLiquidityFee = _liquidityFee;
989         buyDevFee = _devFee;
990         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
991         require(buyTotalFees <= 20, "Must keep fees at 11% or less");
992     }
993 
994     function updateSellFees(
995         uint256 _marketingFee,
996         uint256 _liquidityFee,
997         uint256 _devFee
998     ) external onlyOwner {
999         sellMarketingFee = _marketingFee;
1000         sellLiquidityFee = _liquidityFee;
1001         sellDevFee = _devFee;
1002         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1003         require(sellTotalFees <= 50, "Must keep fees at 11% or less");
1004     }
1005 
1006     function excludeFromFees(address account, bool excluded) public onlyOwner {
1007         _isExcludedFromFees[account] = excluded;
1008         emit ExcludeFromFees(account, excluded);
1009     }
1010 
1011     function setAutomatedMarketMakerPair(address pair, bool value)
1012         public
1013         onlyOwner
1014     {
1015         require(
1016             pair != uniswapV2Pair,
1017             "The pair cannot be removed from automatedMarketMakerPairs"
1018         );
1019 
1020         _setAutomatedMarketMakerPair(pair, value);
1021     }
1022 
1023     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1024         automatedMarketMakerPairs[pair] = value;
1025 
1026         emit SetAutomatedMarketMakerPair(pair, value);
1027     }
1028 
1029     function updateMarketingWallet(address newMarketingWallet)
1030         external
1031         onlyOwner
1032     {
1033         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1034         marketingWallet = newMarketingWallet;
1035     }
1036 
1037     function updateDevelopmentWallet(address newWallet) external onlyOwner {
1038         emit developmentWalletUpdated(newWallet, developmentWallet);
1039         developmentWallet = newWallet;
1040     }
1041 
1042     function isExcludedFromFees(address account) public view returns (bool) {
1043         return _isExcludedFromFees[account];
1044     }
1045 
1046     event BoughtEarly(address indexed sniper);
1047 
1048     function _transfer(
1049         address from,
1050         address to,
1051         uint256 amount
1052     ) internal override {
1053         require(from != address(0), "ERC20: transfer from the zero address");
1054         require(to != address(0), "ERC20: transfer to the zero address");
1055 
1056         if (amount == 0) {
1057             super._transfer(from, to, 0);
1058             return;
1059         }
1060 
1061         if (limitsInEffect) {
1062             if (
1063                 from != owner() &&
1064                 to != owner() &&
1065                 to != address(0) &&
1066                 to != address(0xdead) &&
1067                 !swapping
1068             ) {
1069                 if (!tradingActive) {
1070                     require(
1071                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1072                         "Trading is not active."
1073                     );
1074                 }
1075 
1076                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1077                 if (transferDelayEnabled) {
1078                     if (
1079                         to != owner() &&
1080                         to != address(uniswapV2Router) &&
1081                         to != address(uniswapV2Pair)
1082                     ) {
1083                         require(
1084                             _holderLastTransferTimestamp[tx.origin] <
1085                                 block.number,
1086                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1087                         );
1088                         _holderLastTransferTimestamp[tx.origin] = block.number;
1089                     }
1090                 }
1091 
1092                 //when buy
1093                 if (
1094                     automatedMarketMakerPairs[from] &&
1095                     !_isExcludedMaxTransactionAmount[to]
1096                 ) {
1097                     require(
1098                         amount <= maxTransactionAmount,
1099                         "Buy transfer amount exceeds the maxTransactionAmount."
1100                     );
1101                     require(
1102                         amount + balanceOf(to) <= maxWallet,
1103                         "Max wallet exceeded"
1104                     );
1105                 }
1106                 //when sell
1107                 else if (
1108                     automatedMarketMakerPairs[to] &&
1109                     !_isExcludedMaxTransactionAmount[from]
1110                 ) {
1111                     require(
1112                         amount <= maxTransactionAmount,
1113                         "Sell transfer amount exceeds the maxTransactionAmount."
1114                     );
1115                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1116                     require(
1117                         amount + balanceOf(to) <= maxWallet,
1118                         "Max wallet exceeded"
1119                     );
1120                 }
1121             }
1122         }
1123 
1124         uint256 contractTokenBalance = balanceOf(address(this));
1125 
1126         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1127 
1128         if (
1129             canSwap &&
1130             swapEnabled &&
1131             !swapping &&
1132             !automatedMarketMakerPairs[from] &&
1133             !_isExcludedFromFees[from] &&
1134             !_isExcludedFromFees[to]
1135         ) {
1136             swapping = true;
1137 
1138             swapBack();
1139 
1140             swapping = false;
1141         }
1142 
1143         if (
1144             !swapping &&
1145             automatedMarketMakerPairs[to] &&
1146             lpBurnEnabled &&
1147             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1148             !_isExcludedFromFees[from]
1149         ) {
1150             autoBurnLiquidityPairTokens();
1151         }
1152 
1153         bool takeFee = !swapping;
1154 
1155         // if any account belongs to _isExcludedFromFee account then remove the fee
1156         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1157             takeFee = false;
1158         }
1159 
1160         uint256 fees = 0;
1161         // only take fees on buys/sells, do not take on wallet transfers
1162         if (takeFee) {
1163             // on sell
1164             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1165                 fees = amount.mul(sellTotalFees).div(100);
1166                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1167                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1168                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1169             }
1170             // on buy
1171             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1172                 fees = amount.mul(buyTotalFees).div(100);
1173                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1174                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1175                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1176             }
1177 
1178             if (fees > 0) {
1179                 super._transfer(from, address(this), fees);
1180             }
1181 
1182             amount -= fees;
1183         }
1184 
1185         super._transfer(from, to, amount);
1186     }
1187 
1188     function swapTokensForEth(uint256 tokenAmount) private {
1189         // generate the uniswap pair path of token -> weth
1190         address[] memory path = new address[](2);
1191         path[0] = address(this);
1192         path[1] = uniswapV2Router.WETH();
1193 
1194         _approve(address(this), address(uniswapV2Router), tokenAmount);
1195 
1196         // make the swap
1197         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1198             tokenAmount,
1199             0, // accept any amount of ETH
1200             path,
1201             address(this),
1202             block.timestamp
1203         );
1204     }
1205 
1206     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1207         // approve token transfer to cover all possible scenarios
1208         _approve(address(this), address(uniswapV2Router), tokenAmount);
1209 
1210         // add the liquidity
1211         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1212             address(this),
1213             tokenAmount,
1214             0, // slippage is unavoidable
1215             0, // slippage is unavoidable
1216             deadAddress,
1217             block.timestamp
1218         );
1219     }
1220 
1221     function swapBack() private {
1222         uint256 contractBalance = balanceOf(address(this));
1223         uint256 totalTokensToSwap = tokensForLiquidity +
1224             tokensForMarketing +
1225             tokensForDev;
1226         bool success;
1227 
1228         if (contractBalance == 0 || totalTokensToSwap == 0) {
1229             return;
1230         }
1231 
1232         if (contractBalance > swapTokensAtAmount * 20) {
1233             contractBalance = swapTokensAtAmount * 20;
1234         }
1235 
1236         // Halve the amount of liquidity tokens
1237         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1238             totalTokensToSwap /
1239             2;
1240         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1241 
1242         uint256 initialETHBalance = address(this).balance;
1243 
1244         swapTokensForEth(amountToSwapForETH);
1245 
1246         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1247 
1248         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1249             totalTokensToSwap
1250         );
1251         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1252 
1253         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1254 
1255         tokensForLiquidity = 0;
1256         tokensForMarketing = 0;
1257         tokensForDev = 0;
1258 
1259         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1260 
1261         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1262             addLiquidity(liquidityTokens, ethForLiquidity);
1263             emit SwapAndLiquify(
1264                 amountToSwapForETH,
1265                 ethForLiquidity,
1266                 tokensForLiquidity
1267             );
1268         }
1269 
1270         (success, ) = address(marketingWallet).call{
1271             value: address(this).balance
1272         }("");
1273     }
1274 
1275     function setAutoLPBurnSettings(
1276         uint256 _frequencyInSeconds,
1277         uint256 _percent,
1278         bool _Enabled
1279     ) external onlyOwner {
1280         require(
1281             _frequencyInSeconds >= 600,
1282             "cannot set buyback more often than every 10 minutes"
1283         );
1284         require(
1285             _percent <= 1000 && _percent >= 0,
1286             "Must set auto LP burn percent between 0% and 10%"
1287         );
1288         lpBurnFrequency = _frequencyInSeconds;
1289         percentForLPBurn = _percent;
1290         lpBurnEnabled = _Enabled;
1291     }
1292 
1293     function autoBurnLiquidityPairTokens() internal returns (bool) {
1294         lastLpBurnTime = block.timestamp;
1295 
1296         // get balance of liquidity pair
1297         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1298 
1299         // calculate amount to burn
1300         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1301             10000
1302         );
1303 
1304         // pull tokens from pancakePair liquidity and move to dead address permanently
1305         if (amountToBurn > 0) {
1306             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1307         }
1308 
1309         //sync price since this is not in a swap transaction!
1310         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1311         pair.sync();
1312         emit AutoNukeLP();
1313         return true;
1314     }
1315 
1316     function manualBurnLiquidityPairTokens(uint256 percent)
1317         external
1318         onlyOwner
1319         returns (bool)
1320     {
1321         require(
1322             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1323             "Must wait for cooldown to finish"
1324         );
1325         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1326         lastManualLpBurnTime = block.timestamp;
1327 
1328         // get balance of liquidity pair
1329         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1330 
1331         // calculate amount to burn
1332         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1333 
1334         // pull tokens from pancakePair liquidity and move to dead address permanently
1335         if (amountToBurn > 0) {
1336             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1337         }
1338 
1339         //sync price since this is not in a swap transaction!
1340         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1341         pair.sync();
1342         emit ManualNukeLP();
1343         return true;
1344     }
1345 }