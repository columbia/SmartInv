1 /**
2 Web: https://metaproject.live/
3 
4 Twitter: https://twitter.com/metab_nft
5 
6 Telegram: t.me/themetaproject
7 
8 Discord: https://discord.gg/QSWSc4b5
9 
10 https://metabillionaire.com/
11 
12 **/
13 // SPDX-License-Identifier: MIT
14 pragma solidity 0.8.10;
15 pragma experimental ABIEncoderV2;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 contract Ownable is Context {
28     address private _owner;
29 
30     event OwnershipTransferred(
31         address indexed previousOwner,
32         address indexed newOwner
33     );
34 
35     /**
36      * @dev Initializes the contract setting the deployer as the initial owner.
37      */
38     constructor() {
39         _transferOwnership(_msgSender());
40     }
41 
42     /**
43      * @dev Returns the address of the current owner.
44      */
45     function owner() public view virtual returns (address) {
46         return _owner;
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(owner() == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57     function renounceOwnership() public virtual onlyOwner {
58         _transferOwnership(address(0));
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(
67             newOwner != address(0),
68             "Ownable: new owner is the zero address"
69         );
70         _transferOwnership(newOwner);
71     }
72 
73     /**
74      * @dev Transfers ownership of the contract to a new account (`newOwner`).
75      * Internal function without access restriction.
76      */
77     function _transferOwnership(address newOwner) internal virtual {
78         address oldOwner = _owner;
79         _owner = newOwner;
80         emit OwnershipTransferred(oldOwner, newOwner);
81     }
82 }
83 
84 interface IERC20 {
85     /**
86      * @dev Returns the amount of tokens in existence.
87      */
88     function totalSupply() external view returns (uint256);
89 
90     /**
91      * @dev Returns the amount of tokens owned by `account`.
92      */
93     function balanceOf(address account) external view returns (uint256);
94 
95     /**
96      * @dev Moves `amount` tokens from the caller's account to `recipient`.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transfer(
103         address recipient,
104         uint256 amount
105     ) external returns (bool);
106 
107     function allowance(
108         address owner,
109         address spender
110     ) external view returns (uint256);
111 
112     function approve(address spender, uint256 amount) external returns (bool);
113 
114     function transferFrom(
115         address sender,
116         address recipient,
117         uint256 amount
118     ) external returns (bool);
119 
120     /**
121      * @dev Emitted when `value` tokens are moved from one account (`from`) to
122      * another (`to`).
123      *
124      * Note that `value` may be zero.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 
128     /**
129      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
130      * a call to {approve}. `value` is the new allowance.
131      */
132     event Approval(
133         address indexed owner,
134         address indexed spender,
135         uint256 value
136     );
137 }
138 
139 interface IERC20Metadata is IERC20 {
140     /**
141      * @dev Returns the name of the token.
142      */
143     function name() external view returns (string memory);
144 
145     /**
146      * @dev Returns the symbol of the token.
147      */
148     function symbol() external view returns (string memory);
149 
150     /**
151      * @dev Returns the decimals places of the token.
152      */
153     function decimals() external view returns (uint8);
154 }
155 
156 contract ERC20 is Context, IERC20, IERC20Metadata {
157     mapping(address => uint256) private _balances;
158 
159     mapping(address => mapping(address => uint256)) private _allowances;
160 
161     uint256 private _totalSupply;
162 
163     string private _name;
164     string private _symbol;
165 
166     /**
167      * @dev Sets the values for {name} and {symbol}.
168      *
169      * The default value of {decimals} is 18. To select a different value for
170      * {decimals} you should overload it.
171      *
172      * All two of these values are immutable: they can only be set once during
173      * construction.
174      */
175     constructor(string memory name_, string memory symbol_) {
176         _name = name_;
177         _symbol = symbol_;
178     }
179 
180     /**
181      * @dev Returns the name of the token.
182      */
183     function name() public view virtual override returns (string memory) {
184         return _name;
185     }
186 
187     /**
188      * @dev Returns the symbol of the token, usually a shorter version of the
189      * name.
190      */
191     function symbol() public view virtual override returns (string memory) {
192         return _symbol;
193     }
194 
195     function decimals() public view virtual override returns (uint8) {
196         return 18;
197     }
198 
199     /**
200      * @dev See {IERC20-totalSupply}.
201      */
202     function totalSupply() public view virtual override returns (uint256) {
203         return _totalSupply;
204     }
205 
206     /**
207      * @dev See {IERC20-balanceOf}.
208      */
209     function balanceOf(
210         address account
211     ) public view virtual override returns (uint256) {
212         return _balances[account];
213     }
214 
215     function transfer(
216         address recipient,
217         uint256 amount
218     ) public virtual override returns (bool) {
219         _transfer(_msgSender(), recipient, amount);
220         return true;
221     }
222 
223     /**
224      * @dev See {IERC20-allowance}.
225      */
226     function allowance(
227         address owner,
228         address spender
229     ) public view virtual override returns (uint256) {
230         return _allowances[owner][spender];
231     }
232 
233     /**
234      * @dev See {IERC20-approve}.
235      *
236      * Requirements:
237      *
238      * - `spender` cannot be the zero address.
239      */
240     function approve(
241         address spender,
242         uint256 amount
243     ) public virtual override returns (bool) {
244         _approve(_msgSender(), spender, amount);
245         return true;
246     }
247 
248     function transferFrom(
249         address sender,
250         address recipient,
251         uint256 amount
252     ) public virtual override returns (bool) {
253         _transfer(sender, recipient, amount);
254 
255         uint256 currentAllowance = _allowances[sender][_msgSender()];
256         require(
257             currentAllowance >= amount,
258             "ERC20: transfer amount exceeds allowance"
259         );
260         unchecked {
261             _approve(sender, _msgSender(), currentAllowance - amount);
262         }
263 
264         return true;
265     }
266 
267     function increaseAllowance(
268         address spender,
269         uint256 addedValue
270     ) public virtual returns (bool) {
271         _approve(
272             _msgSender(),
273             spender,
274             _allowances[_msgSender()][spender] + addedValue
275         );
276         return true;
277     }
278 
279     function decreaseAllowance(
280         address spender,
281         uint256 subtractedValue
282     ) public virtual returns (bool) {
283         uint256 currentAllowance = _allowances[_msgSender()][spender];
284         require(
285             currentAllowance >= subtractedValue,
286             "ERC20: decreased allowance below zero"
287         );
288         unchecked {
289             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
290         }
291 
292         return true;
293     }
294 
295     function _transfer(
296         address sender,
297         address recipient,
298         uint256 amount
299     ) internal virtual {
300         require(sender != address(0), "ERC20: transfer from the zero address");
301         require(recipient != address(0), "ERC20: transfer to the zero address");
302 
303         _beforeTokenTransfer(sender, recipient, amount);
304 
305         uint256 senderBalance = _balances[sender];
306         require(
307             senderBalance >= amount,
308             "ERC20: transfer amount exceeds balance"
309         );
310         unchecked {
311             _balances[sender] = senderBalance - amount;
312         }
313         _balances[recipient] += amount;
314 
315         emit Transfer(sender, recipient, amount);
316 
317         _afterTokenTransfer(sender, recipient, amount);
318     }
319 
320     function _mint(address account, uint256 amount) internal virtual {
321         require(account != address(0), "ERC20: mint to the zero address");
322 
323         _beforeTokenTransfer(address(0), account, amount);
324 
325         _totalSupply += amount;
326         _balances[account] += amount;
327         emit Transfer(address(0), account, amount);
328 
329         _afterTokenTransfer(address(0), account, amount);
330     }
331 
332     function _burn(address account, uint256 amount) internal virtual {
333         require(account != address(0), "ERC20: burn from the zero address");
334 
335         _beforeTokenTransfer(account, address(0), amount);
336 
337         uint256 accountBalance = _balances[account];
338         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
339         unchecked {
340             _balances[account] = accountBalance - amount;
341         }
342         _totalSupply -= amount;
343 
344         emit Transfer(account, address(0), amount);
345 
346         _afterTokenTransfer(account, address(0), amount);
347     }
348 
349     function _approve(
350         address owner,
351         address spender,
352         uint256 amount
353     ) internal virtual {
354         require(owner != address(0), "ERC20: approve from the zero address");
355         require(spender != address(0), "ERC20: approve to the zero address");
356 
357         _allowances[owner][spender] = amount;
358         emit Approval(owner, spender, amount);
359     }
360 
361     function _beforeTokenTransfer(
362         address from,
363         address to,
364         uint256 amount
365     ) internal virtual {}
366 
367     function _afterTokenTransfer(
368         address from,
369         address to,
370         uint256 amount
371     ) internal virtual {}
372 }
373 
374 library SafeMath {
375     /**
376      * @dev Returns the addition of two unsigned integers, with an overflow flag.
377      *
378      * _Available since v3.4._
379      */
380     function tryAdd(
381         uint256 a,
382         uint256 b
383     ) internal pure returns (bool, uint256) {
384         unchecked {
385             uint256 c = a + b;
386             if (c < a) return (false, 0);
387             return (true, c);
388         }
389     }
390 
391     /**
392      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
393      *
394      * _Available since v3.4._
395      */
396     function trySub(
397         uint256 a,
398         uint256 b
399     ) internal pure returns (bool, uint256) {
400         unchecked {
401             if (b > a) return (false, 0);
402             return (true, a - b);
403         }
404     }
405 
406     /**
407      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
408      *
409      * _Available since v3.4._
410      */
411     function tryMul(
412         uint256 a,
413         uint256 b
414     ) internal pure returns (bool, uint256) {
415         unchecked {
416             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
417             // benefit is lost if 'b' is also tested.
418             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
419             if (a == 0) return (true, 0);
420             uint256 c = a * b;
421             if (c / a != b) return (false, 0);
422             return (true, c);
423         }
424     }
425 
426     /**
427      * @dev Returns the division of two unsigned integers, with a division by zero flag.
428      *
429      * _Available since v3.4._
430      */
431     function tryDiv(
432         uint256 a,
433         uint256 b
434     ) internal pure returns (bool, uint256) {
435         unchecked {
436             if (b == 0) return (false, 0);
437             return (true, a / b);
438         }
439     }
440 
441     /**
442      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
443      *
444      * _Available since v3.4._
445      */
446     function tryMod(
447         uint256 a,
448         uint256 b
449     ) internal pure returns (bool, uint256) {
450         unchecked {
451             if (b == 0) return (false, 0);
452             return (true, a % b);
453         }
454     }
455 
456     function add(uint256 a, uint256 b) internal pure returns (uint256) {
457         return a + b;
458     }
459 
460     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
461         return a - b;
462     }
463 
464     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
465         return a * b;
466     }
467 
468     function div(uint256 a, uint256 b) internal pure returns (uint256) {
469         return a / b;
470     }
471 
472     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
473         return a % b;
474     }
475 
476     function sub(
477         uint256 a,
478         uint256 b,
479         string memory errorMessage
480     ) internal pure returns (uint256) {
481         unchecked {
482             require(b <= a, errorMessage);
483             return a - b;
484         }
485     }
486 
487     function div(
488         uint256 a,
489         uint256 b,
490         string memory errorMessage
491     ) internal pure returns (uint256) {
492         unchecked {
493             require(b > 0, errorMessage);
494             return a / b;
495         }
496     }
497 
498     function mod(
499         uint256 a,
500         uint256 b,
501         string memory errorMessage
502     ) internal pure returns (uint256) {
503         unchecked {
504             require(b > 0, errorMessage);
505             return a % b;
506         }
507     }
508 }
509 
510 interface IUniswapV2Factory {
511     event PairCreated(
512         address indexed token0,
513         address indexed token1,
514         address pair,
515         uint256
516     );
517 
518     function feeTo() external view returns (address);
519 
520     function feeToSetter() external view returns (address);
521 
522     function getPair(
523         address tokenA,
524         address tokenB
525     ) external view returns (address pair);
526 
527     function allPairs(uint256) external view returns (address pair);
528 
529     function allPairsLength() external view returns (uint256);
530 
531     function createPair(
532         address tokenA,
533         address tokenB
534     ) external returns (address pair);
535 
536     function setFeeTo(address) external;
537 
538     function setFeeToSetter(address) external;
539 }
540 
541 interface IUniswapV2Pair {
542     event Approval(
543         address indexed owner,
544         address indexed spender,
545         uint256 value
546     );
547     event Transfer(address indexed from, address indexed to, uint256 value);
548 
549     function name() external pure returns (string memory);
550 
551     function symbol() external pure returns (string memory);
552 
553     function decimals() external pure returns (uint8);
554 
555     function totalSupply() external view returns (uint256);
556 
557     function balanceOf(address owner) external view returns (uint256);
558 
559     function allowance(
560         address owner,
561         address spender
562     ) external view returns (uint256);
563 
564     function approve(address spender, uint256 value) external returns (bool);
565 
566     function transfer(address to, uint256 value) external returns (bool);
567 
568     function transferFrom(
569         address from,
570         address to,
571         uint256 value
572     ) external returns (bool);
573 
574     function DOMAIN_SEPARATOR() external view returns (bytes32);
575 
576     function PERMIT_TYPEHASH() external pure returns (bytes32);
577 
578     function nonces(address owner) external view returns (uint256);
579 
580     function permit(
581         address owner,
582         address spender,
583         uint256 value,
584         uint256 deadline,
585         uint8 v,
586         bytes32 r,
587         bytes32 s
588     ) external;
589 
590     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
591     event Burn(
592         address indexed sender,
593         uint256 amount0,
594         uint256 amount1,
595         address indexed to
596     );
597     event Swap(
598         address indexed sender,
599         uint256 amount0In,
600         uint256 amount1In,
601         uint256 amount0Out,
602         uint256 amount1Out,
603         address indexed to
604     );
605     event Sync(uint112 reserve0, uint112 reserve1);
606 
607     function MINIMUM_LIQUIDITY() external pure returns (uint256);
608 
609     function factory() external view returns (address);
610 
611     function token0() external view returns (address);
612 
613     function token1() external view returns (address);
614 
615     function getReserves()
616         external
617         view
618         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
619 
620     function price0CumulativeLast() external view returns (uint256);
621 
622     function price1CumulativeLast() external view returns (uint256);
623 
624     function kLast() external view returns (uint256);
625 
626     function mint(address to) external returns (uint256 liquidity);
627 
628     function burn(
629         address to
630     ) external returns (uint256 amount0, uint256 amount1);
631 
632     function swap(
633         uint256 amount0Out,
634         uint256 amount1Out,
635         address to,
636         bytes calldata data
637     ) external;
638 
639     function skim(address to) external;
640 
641     function sync() external;
642 
643     function initialize(address, address) external;
644 }
645 
646 interface IUniswapV2Router02 {
647     function factory() external pure returns (address);
648 
649     function WETH() external pure returns (address);
650 
651     function addLiquidity(
652         address tokenA,
653         address tokenB,
654         uint256 amountADesired,
655         uint256 amountBDesired,
656         uint256 amountAMin,
657         uint256 amountBMin,
658         address to,
659         uint256 deadline
660     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
661 
662     function addLiquidityETH(
663         address token,
664         uint256 amountTokenDesired,
665         uint256 amountTokenMin,
666         uint256 amountETHMin,
667         address to,
668         uint256 deadline
669     )
670         external
671         payable
672         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
673 
674     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
675         uint256 amountIn,
676         uint256 amountOutMin,
677         address[] calldata path,
678         address to,
679         uint256 deadline
680     ) external;
681 
682     function swapExactETHForTokensSupportingFeeOnTransferTokens(
683         uint256 amountOutMin,
684         address[] calldata path,
685         address to,
686         uint256 deadline
687     ) external payable;
688 
689     function swapExactTokensForETHSupportingFeeOnTransferTokens(
690         uint256 amountIn,
691         uint256 amountOutMin,
692         address[] calldata path,
693         address to,
694         uint256 deadline
695     ) external;
696 }
697 
698 contract META is ERC20, Ownable {
699     using SafeMath for uint256;
700 
701     IUniswapV2Router02 public immutable uniswapV2Router;
702     address public immutable uniswapV2Pair;
703     address public constant deadAddress = address(0xdead);
704 
705     bool private swapping;
706 
707     address public marketingWallet;
708     address public devWallet;
709 
710     uint256 public maxTransactionAmount;
711     uint256 public swapTokensAtAmount;
712     uint256 public maxWallet;
713 
714     bool public limitsInEffect = true;
715     bool public tradingActive = false;
716     bool public swapEnabled = false;
717 
718     uint256 public launchedAt;
719     uint256 public launchedAtTimestamp;
720 
721     uint256 public buyTotalFees = 20;
722     uint256 public buyMarketingFee = 10;
723     uint256 public buyDevFee = 10;
724 
725     uint256 public sellTotalFees = 90;
726     uint256 public sellMarketingFee = 45;
727     uint256 public sellDevFee = 45;
728 
729     uint256 public tokensForMarketing;
730     uint256 public tokensForDev;
731 
732     /******************/
733 
734     // exlcude from fees and max transaction amount
735     mapping(address => bool) private _isExcludedFromFees;
736     mapping(address => bool) public _isExcludedMaxTransactionAmount;
737 
738     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
739     // could be subject to a maximum transfer amount
740     mapping(address => bool) public automatedMarketMakerPairs;
741 
742     event UpdateUniswapV2Router(
743         address indexed newAddress,
744         address indexed oldAddress
745     );
746 
747     event ExcludeFromFees(address indexed account, bool isExcluded);
748 
749     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
750 
751     event marketingWalletUpdated(
752         address indexed newWallet,
753         address indexed oldWallet
754     );
755 
756     event devWalletUpdated(
757         address indexed newWallet,
758         address indexed oldWallet
759     );
760     event SwapAndLiquify(
761         uint256 tokensSwapped,
762         uint256 ethReceived,
763         uint256 tokensIntoLiquidity
764     );
765 
766     constructor() ERC20("META", "META") {
767         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
768             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
769         );
770 
771         excludeFromMaxTransaction(address(_uniswapV2Router), true);
772         uniswapV2Router = _uniswapV2Router;
773 
774         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
775             .createPair(address(this), _uniswapV2Router.WETH());
776         excludeFromMaxTransaction(address(uniswapV2Pair), true);
777         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
778 
779         uint256 totalSupply = 10_000_000 * 1e18;
780 
781         maxTransactionAmount = totalSupply.mul(2) / 100; // 2% from total supply maxTransactionAmountTxn
782         maxWallet = totalSupply.mul(2) / 100; // 2% from total supply maxWallet
783         swapTokensAtAmount = totalSupply.mul(5) / 10000;
784 
785         marketingWallet = address(0x873dd29068123D679eEB5FD7b076D83c9dA4283C); // set as marketing wallet
786         devWallet = address(0xcFc783ce0ab32e0F43a30cc146FC091dc1e08e97); // set as Dev wallet
787 
788         // exclude from paying fees or having max transaction amount
789         excludeFromFees(owner(), true);
790         excludeFromFees(address(this), true);
791         excludeFromFees(address(0xdead), true);
792 
793         excludeFromMaxTransaction(owner(), true);
794         excludeFromMaxTransaction(address(this), true);
795         excludeFromMaxTransaction(address(0xdead), true);
796         /*
797             _mint is an internal function in ERC20.sol that is only called here,
798             and CANNOT be called ever again
799         */
800         _mint(owner(), totalSupply);
801     }
802 
803     receive() external payable {}
804 
805     function launched() internal view returns (bool) {
806         return launchedAt != 0;
807     }
808 
809     function launch() public onlyOwner {
810         require(launchedAt == 0, "Already launched boi");
811         launchedAt = block.number;
812         launchedAtTimestamp = block.timestamp;
813         tradingActive = true;
814         swapEnabled = true;
815     }
816 
817     // remove limits after token is stable
818     function removeLimits() external onlyOwner returns (bool) {
819         limitsInEffect = false;
820         return true;
821     }
822 
823     // change the minimum amount of tokens to sell from fees
824     function updateSwapTokensAtAmount(
825         uint256 newAmount
826     ) external onlyOwner returns (bool) {
827         swapTokensAtAmount = newAmount * (10 ** 18);
828         return true;
829     }
830 
831     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
832         maxTransactionAmount = newNum * (10 ** 18);
833     }
834 
835     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
836         maxWallet = newNum * (10 ** 18);
837     }
838 
839     function excludeFromMaxTransaction(
840         address updAds,
841         bool isEx
842     ) public onlyOwner {
843         _isExcludedMaxTransactionAmount[updAds] = isEx;
844     }
845 
846     // only use to disable contract sales if absolutely necessary (emergency use only)
847     function updateSwapEnabled(bool enabled) external onlyOwner {
848         swapEnabled = enabled;
849     }
850 
851     function updateBuyFees(
852         uint256 _marketingFee,
853         uint256 _devFee
854     ) external onlyOwner {
855         buyMarketingFee = _marketingFee;
856         buyDevFee = _devFee;
857         buyTotalFees = buyMarketingFee + buyDevFee;
858     }
859 
860     function updateSellFees(
861         uint256 _marketingFee,
862         uint256 _devFee
863     ) external onlyOwner {
864         sellMarketingFee = _marketingFee;
865         sellDevFee = _devFee;
866         sellTotalFees = sellMarketingFee + sellDevFee;
867     }
868 
869     function excludeFromFees(address account, bool excluded) public onlyOwner {
870         _isExcludedFromFees[account] = excluded;
871         emit ExcludeFromFees(account, excluded);
872     }
873 
874     function setAutomatedMarketMakerPair(
875         address pair,
876         bool value
877     ) public onlyOwner {
878         require(
879             pair != uniswapV2Pair,
880             "The pair cannot be removed from automatedMarketMakerPairs"
881         );
882 
883         _setAutomatedMarketMakerPair(pair, value);
884     }
885 
886     function _setAutomatedMarketMakerPair(address pair, bool value) private {
887         automatedMarketMakerPairs[pair] = value;
888 
889         emit SetAutomatedMarketMakerPair(pair, value);
890     }
891 
892     function updateMarketingWallet(
893         address newMarketingWallet
894     ) external onlyOwner {
895         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
896         marketingWallet = newMarketingWallet;
897     }
898 
899     function updateDevWallet(address newWallet) external onlyOwner {
900         emit devWalletUpdated(newWallet, devWallet);
901         devWallet = newWallet;
902     }
903 
904     function isExcludedFromFees(address account) public view returns (bool) {
905         return _isExcludedFromFees[account];
906     }
907 
908     function _transfer(
909         address from,
910         address to,
911         uint256 amount
912     ) internal override {
913         require(from != address(0), "ERC20: transfer from the zero address");
914         require(to != address(0), "ERC20: transfer to the zero address");
915 
916         if (amount == 0) {
917             super._transfer(from, to, 0);
918             return;
919         }
920 
921         if (limitsInEffect) {
922             if (
923                 from != owner() &&
924                 to != owner() &&
925                 to != address(0) &&
926                 to != address(0xdead) &&
927                 !swapping
928             ) {
929                 if (!tradingActive) {
930                     require(
931                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
932                         "Trading is not active."
933                     );
934                 }
935                 //when buy
936                 if (
937                     automatedMarketMakerPairs[from] &&
938                     !_isExcludedMaxTransactionAmount[to]
939                 ) {
940                     require(
941                         amount <= maxTransactionAmount,
942                         "Buy transfer amount exceeds the maxTransactionAmount."
943                     );
944                     require(
945                         amount + balanceOf(to) <= maxWallet,
946                         "Max wallet exceeded"
947                     );
948                 }
949                 //when sell
950                 else if (
951                     automatedMarketMakerPairs[to] &&
952                     !_isExcludedMaxTransactionAmount[from]
953                 ) {
954                     require(
955                         amount <= maxTransactionAmount,
956                         "Sell transfer amount exceeds the maxTransactionAmount."
957                     );
958                 } else if (!_isExcludedMaxTransactionAmount[to]) {
959                     require(
960                         amount + balanceOf(to) <= maxWallet,
961                         "Max wallet exceeded"
962                     );
963                 }
964             }
965         }
966 
967         uint256 contractTokenBalance = balanceOf(address(this));
968 
969         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
970 
971         if (
972             canSwap &&
973             swapEnabled &&
974             !swapping &&
975             !automatedMarketMakerPairs[from] &&
976             !_isExcludedFromFees[from] &&
977             !_isExcludedFromFees[to]
978         ) {
979             swapping = true;
980 
981             swapBack();
982 
983             swapping = false;
984         }
985 
986         bool takeFee = !swapping;
987 
988         // if any account belongs to _isExcludedFromFee account then remove the fee
989         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
990             takeFee = false;
991         }
992 
993         uint256 fees = 0;
994         // only take fees on buys/sells, do not take on wallet transfers
995         if (takeFee) {
996             // on sell
997             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
998                 fees = amount.mul(sellTotalFees).div(100);
999                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1000                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1001             }
1002             // on buy
1003             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1004                 fees = amount.mul(buyTotalFees).div(100);
1005                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1006                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1007             }
1008 
1009             if (fees > 0) {
1010                 super._transfer(from, address(this), fees);
1011             }
1012 
1013             amount -= fees;
1014         }
1015 
1016         super._transfer(from, to, amount);
1017     }
1018 
1019     function swapTokensForEth(uint256 tokenAmount) private {
1020         // generate the uniswap pair path of token -> weth
1021         address[] memory path = new address[](2);
1022         path[0] = address(this);
1023         path[1] = uniswapV2Router.WETH();
1024 
1025         _approve(address(this), address(uniswapV2Router), tokenAmount);
1026 
1027         // make the swap
1028         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1029             tokenAmount,
1030             0, // accept any amount of ETH
1031             path,
1032             address(this),
1033             block.timestamp
1034         );
1035     }
1036 
1037     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1038         // approve token transfer to cover all possible scenarios
1039         _approve(address(this), address(uniswapV2Router), tokenAmount);
1040 
1041         // add the liquidity
1042         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1043             address(this),
1044             tokenAmount,
1045             0, // slippage is unavoidable
1046             0, // slippage is unavoidable
1047             deadAddress,
1048             block.timestamp
1049         );
1050     }
1051 
1052     function swapBack() private {
1053         uint256 contractBalance = balanceOf(address(this));
1054         uint256 totalTokensToSwap = tokensForMarketing + tokensForDev;
1055         bool success;
1056 
1057         if (contractBalance == 0 || totalTokensToSwap == 0) {
1058             return;
1059         }
1060 
1061         if (contractBalance > swapTokensAtAmount) {
1062             contractBalance = swapTokensAtAmount;
1063         }
1064 
1065         uint256 amountToSwapForETH = contractBalance;
1066 
1067         swapTokensForEth(amountToSwapForETH);
1068 
1069         uint256 ethBalance = address(this).balance;
1070 
1071         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1072             totalTokensToSwap
1073         );
1074 
1075         tokensForMarketing = 0;
1076         tokensForDev = 0;
1077 
1078         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1079         (success, ) = address(devWallet).call{value: address(this).balance}("");
1080     }
1081 
1082     // TO transfer tokens to multi users through single transaction
1083     function airdrop(
1084         address[] calldata addresses,
1085         uint256[] calldata amounts
1086     ) external onlyOwner {
1087         require(
1088             addresses.length == amounts.length,
1089             "Array sizes must be equal"
1090         );
1091         uint256 i = 0;
1092         while (i < addresses.length) {
1093             uint256 _amount = amounts[i].mul(1e18);
1094             _transfer(msg.sender, addresses[i], _amount);
1095             i += 1;
1096         }
1097     }
1098 
1099     // to withdarw ETH from contract
1100     function withdrawETH(uint256 _amount) external onlyOwner {
1101         require(address(this).balance >= _amount, "Invalid Amount");
1102         payable(msg.sender).transfer(_amount);
1103     }
1104 
1105     // to withdraw ERC20 tokens from contract
1106     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
1107         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
1108         _token.transfer(msg.sender, _amount);
1109     }
1110 }