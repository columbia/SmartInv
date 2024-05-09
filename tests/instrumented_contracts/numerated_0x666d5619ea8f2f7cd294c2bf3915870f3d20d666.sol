1 // SPDX-License-Identifier: MIT
2 /**
3      
4 And I saw the beast, the devil, the 666.
5 The meme destroyer emerged from the abyss.
6 The memecoin space was finally ready to receive his power,
7 Into infernal torment were sent all the fudders.
8 
9 The beast roamed the blockchain, seeking out its prey,
10 Targeting the memecoins that scammed all day.
11 No longer were the jeets safe from its wrath,
12 For $DIABLO sought to punish their path.
13 
14 TG: t.me/diabloerc
15 
16 Twitter: https://x.com/diablo_erc
17 
18 Website: https://diablocoin.io/
19  */
20 
21 pragma solidity 0.8.9;
22 
23 interface IUniswapV2Factory {
24     function createPair(address tokenA, address tokenB) external returns(address pair);
25 }
26 
27 
28 
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns(uint256);
34 
35     /**
36     * @dev Returns the amount of tokens owned by `account`.
37     */
38     function balanceOf(address account) external view returns(uint256);
39 
40    
41     function transfer(address recipient, uint256 amount) external returns(bool);
42 
43     
44     function allowance(address owner, address spender) external view returns(uint256);
45 
46     
47     function approve(address spender, uint256 amount) external returns(bool);
48 
49     
50     function transferFrom(
51         address sender,
52         address recipient,
53         uint256 amount
54     ) external returns(bool);
55 
56         event Transfer(address indexed from, address indexed to, uint256 value);
57 
58         
59         event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 interface IERC20Metadata is IERC20 {
63     /**
64      * @dev Returns the name of the token.
65      */
66     function name() external view returns(string memory);
67 
68     /**
69      * @dev Returns the symbol of the token.
70      */
71     function symbol() external view returns(string memory);
72 
73     /**
74      * @dev Returns the decimals places of the token.
75      */
76     function decimals() external view returns(uint8);
77 }
78 
79 abstract contract Context {
80     function _msgSender() internal view virtual returns(address) {
81         return msg.sender;
82     }
83 
84 }
85 
86 
87 contract ERC20 is Context, IERC20, IERC20Metadata {
88     using SafeMath for uint256;
89     mapping(address => uint256) private _balances;
90 
91     mapping(address => mapping(address => uint256)) private _allowances;
92 
93     uint256 private _totalSupply;
94 
95     string private _name;
96     string private _symbol;
97 
98     /**
99      * @dev Sets the values for {name} and {symbol}.
100      *
101      * All two of these values are immutable: they can only be set once during
102      * construction.
103      */
104     constructor(string memory name_, string memory symbol_) {
105         _name = name_;
106         _symbol = symbol_;
107     }
108 
109     /**
110      * @dev Returns the name of the token.
111      */
112     function name() public view virtual override returns (string memory) {
113         return _name;
114     }
115 
116     /**
117      * @dev Returns the symbol of the token, usually a shorter version of the
118      * name.
119      */
120     function symbol() public view virtual override returns (string memory) {
121         return _symbol;
122     }
123 
124     
125     function decimals() public view virtual override returns (uint8) {
126         return 18;
127     }
128 
129     
130     function totalSupply() public view virtual override returns (uint256) {
131         return _totalSupply;
132     }
133 
134     /**
135      * @dev See {IERC20-balanceOf}.
136      */
137     function balanceOf(address account) public view virtual override returns (uint256) {
138         return _balances[account];
139     }
140 
141     /**
142      * @dev See {IERC20-transfer}.
143      *
144      * Requirements:
145      *
146      * - `to` cannot be the zero address.
147      * - the caller must have a balance of at least `amount`.
148      */
149     function transfer(address to, uint256 amount) public virtual override returns (bool) {
150         address owner = _msgSender();
151         _transfer(owner, to, amount);
152         return true;
153     }
154 
155     /**
156      * @dev See {IERC20-allowance}.
157      */
158     function allowance(address owner, address spender) public view virtual override returns (uint256) {
159         return _allowances[owner][spender];
160     }
161 
162     /**
163      * @dev See {IERC20-approve}.
164      *
165      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
166      * `transferFrom`. This is semantically equivalent to an infinite approval.
167      *
168      * Requirements:
169      *
170      * - `spender` cannot be the zero address.
171      */
172     function approve(address spender, uint256 amount) public virtual override returns (bool) {
173         address owner = _msgSender();
174         _approve(owner, spender, amount);
175         return true;
176     }
177 
178     
179     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
180         address spender = _msgSender();
181         _spendAllowance(from, spender, amount);
182         _transfer(from, to, amount);
183         return true;
184     }
185 
186     
187     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
188         address owner = _msgSender();
189         _approve(owner, spender, allowance(owner, spender) + addedValue);
190         return true;
191     }
192 
193    
194     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
195         address owner = _msgSender();
196         uint256 currentAllowance = allowance(owner, spender);
197         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
198         unchecked {
199             _approve(owner, spender, currentAllowance - subtractedValue);
200         }
201 
202         return true;
203     }
204 
205     
206     function _transfer(address from, address to, uint256 amount) internal virtual {
207         require(from != address(0), "ERC20: transfer from the zero address");
208         require(to != address(0), "ERC20: transfer to the zero address");
209 
210         _beforeTokenTransfer(from, to, amount);
211 
212         uint256 fromBalance = _balances[from];
213         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
214         unchecked {
215             _balances[from] = fromBalance - amount;
216             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
217             // decrementing then incrementing.
218             _balances[to] += amount;
219         }
220 
221         emit Transfer(from, to, amount);
222 
223         _afterTokenTransfer(from, to, amount);
224     }
225 
226    
227     function _mint(address account, uint256 amount) internal virtual {
228         require(account != address(0), "ERC20: mint to the zero address");
229 
230         _beforeTokenTransfer(address(0), account, amount);
231 
232         _totalSupply += amount;
233         unchecked {
234             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
235             _balances[account] += amount;
236         }
237         emit Transfer(address(0), account, amount);
238 
239         _afterTokenTransfer(address(0), account, amount);
240     }
241 
242     
243     function _burn(address account, uint256 amount) internal virtual {
244         require(account != address(0), "ERC20: burn from the zero address");
245 
246         _beforeTokenTransfer(account, address(0), amount);
247 
248         uint256 accountBalance = _balances[account];
249         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
250         unchecked {
251             _balances[account] = accountBalance - amount;
252             // Overflow not possible: amount <= accountBalance <= totalSupply.
253             _totalSupply -= amount;
254         }
255 
256         emit Transfer(account, address(0), amount);
257 
258         _afterTokenTransfer(account, address(0), amount);
259     }
260 
261     function _approve(address owner, address spender, uint256 amount) internal virtual {
262         require(owner != address(0), "ERC20: approve from the zero address");
263         require(spender != address(0), "ERC20: approve to the zero address");
264 
265         _allowances[owner][spender] = amount;
266         emit Approval(owner, spender, amount);
267     }
268 
269     
270     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
271         uint256 currentAllowance = allowance(owner, spender);
272         if (currentAllowance != type(uint256).max) {
273             require(currentAllowance >= amount, "ERC20: insufficient allowance");
274             unchecked {
275                 _approve(owner, spender, currentAllowance - amount);
276             }
277         }
278     }
279 
280     
281     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
282 
283     
284     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
285 }
286 
287     
288 abstract contract ERC20Burnable is Context, ERC20 {
289     /**
290      * @dev Destroys `amount` tokens from the caller.
291      *
292      * See {ERC20-_burn}.
293      */
294     function burn(uint256 amount) public virtual {
295         _burn(_msgSender(), amount);
296     }
297 
298     /**
299      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
300      * allowance.
301      *
302      * See {ERC20-_burn} and {ERC20-allowance}.
303      *
304      * Requirements:
305      *
306      * - the caller must have allowance for ``accounts``'s tokens of at least
307      * `amount`.
308      */
309     function burnFrom(address account, uint256 amount) public virtual {
310         _spendAllowance(account, _msgSender(), amount);
311         _burn(account, amount);
312     }
313 }
314 
315  
316 library SafeMath {
317    
318     function add(uint256 a, uint256 b) internal pure returns(uint256) {
319         uint256 c = a + b;
320         require(c >= a, "SafeMath: addition overflow");
321 
322         return c;
323     }
324 
325    
326     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
327         return sub(a, b, "SafeMath: subtraction overflow");
328     }
329 
330    
331     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
332         require(b <= a, errorMessage);
333         uint256 c = a - b;
334 
335         return c;
336     }
337 
338     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
339     
340         if (a == 0) {
341             return 0;
342         }
343  
344         uint256 c = a * b;
345         require(c / a == b, "SafeMath: multiplication overflow");
346 
347         return c;
348     }
349 
350  
351     function div(uint256 a, uint256 b) internal pure returns(uint256) {
352         return div(a, b, "SafeMath: division by zero");
353     }
354 
355   
356     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
357         require(b > 0, errorMessage);
358         uint256 c = a / b;
359         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
360 
361         return c;
362     }
363 
364     
365 }
366  
367 contract Ownable is Context {
368     address private _owner;
369  
370     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
371 
372     /**
373      * @dev Initializes the contract setting the deployer as the initial owner.
374      */
375     constructor() {
376         address msgSender = _msgSender();
377         _owner = msgSender;
378         emit OwnershipTransferred(address(0), msgSender);
379     }
380 
381     /**
382      * @dev Returns the address of the current owner.
383      */
384     function owner() public view returns(address) {
385         return _owner;
386     }
387 
388     /**
389      * @dev Throws if called by any account other than the owner.
390      */
391     modifier onlyOwner() {
392         require(_owner == _msgSender(), "Ownable: caller is not the owner");
393         _;
394     }
395 
396     /**
397      * @dev Leaves the contract without owner. It will not be possible to call
398      * `onlyOwner` functions anymore. Can only be called by the current owner.
399      *
400      * NOTE: Renouncing ownership will leave the contract without an owner,
401      * thereby removing any functionality that is only available to the owner.
402      */
403     function renounceOwnership() public virtual onlyOwner {
404         emit OwnershipTransferred(_owner, address(0));
405         _owner = address(0);
406     }
407 
408     /**
409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
410      * Can only be called by the current owner.
411      */
412     function transferOwnership(address newOwner) public virtual onlyOwner {
413         require(newOwner != address(0), "Ownable: new owner is the zero address");
414         emit OwnershipTransferred(_owner, newOwner);
415         _owner = newOwner;
416     }
417 }
418  
419  
420  
421 library SafeMathInt {
422     int256 private constant MIN_INT256 = int256(1) << 255;
423     int256 private constant MAX_INT256 = ~(int256(1) << 255);
424 
425     /**
426      * @dev Multiplies two int256 variables and fails on overflow.
427      */
428     function mul(int256 a, int256 b) internal pure returns(int256) {
429         int256 c = a * b;
430 
431         // Detect overflow when multiplying MIN_INT256 with -1
432         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
433         require((b == 0) || (c / b == a));
434         return c;
435     }
436 
437     /**
438      * @dev Division of two int256 variables and fails on overflow.
439      */
440     function div(int256 a, int256 b) internal pure returns(int256) {
441         // Prevent overflow when dividing MIN_INT256 by -1
442         require(b != -1 || a != MIN_INT256);
443 
444         // Solidity already throws when dividing by 0.
445         return a / b;
446     }
447 
448     /**
449      * @dev Subtracts two int256 variables and fails on overflow.
450      */
451     function sub(int256 a, int256 b) internal pure returns(int256) {
452         int256 c = a - b;
453         require((b >= 0 && c <= a) || (b < 0 && c > a));
454         return c;
455     }
456 
457     /**
458      * @dev Adds two int256 variables and fails on overflow.
459      */
460     function add(int256 a, int256 b) internal pure returns(int256) {
461         int256 c = a + b;
462         require((b >= 0 && c >= a) || (b < 0 && c < a));
463         return c;
464     }
465 
466     /**
467      * @dev Converts to absolute value, and fails on overflow.
468      */
469     function abs(int256 a) internal pure returns(int256) {
470         require(a != MIN_INT256);
471         return a < 0 ? -a : a;
472     }
473 
474 
475     function toUint256Safe(int256 a) internal pure returns(uint256) {
476         require(a >= 0);
477         return uint256(a);
478     }
479 }
480  
481 library SafeMathUint {
482     function toInt256Safe(uint256 a) internal pure returns(int256) {
483     int256 b = int256(a);
484         require(b >= 0);
485         return b;
486     }
487 }
488 
489 
490 interface IUniswapV2Router01 {
491     function factory() external pure returns(address);
492     function WETH() external pure returns(address);
493 
494     function addLiquidity(
495         address tokenA,
496         address tokenB,
497         uint amountADesired,
498         uint amountBDesired,
499         uint amountAMin,
500         uint amountBMin,
501         address to,
502         uint deadline
503     ) external returns(uint amountA, uint amountB, uint liquidity);
504     function addLiquidityETH(
505         address token,
506         uint amountTokenDesired,
507         uint amountTokenMin,
508         uint amountETHMin,
509         address to,
510         uint deadline
511     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
512     function removeLiquidity(
513         address tokenA,
514         address tokenB,
515         uint liquidity,
516         uint amountAMin,
517         uint amountBMin,
518         address to,
519         uint deadline
520     ) external returns(uint amountA, uint amountB);
521     function removeLiquidityETH(
522         address token,
523         uint liquidity,
524         uint amountTokenMin,
525         uint amountETHMin,
526         address to,
527         uint deadline
528     ) external returns(uint amountToken, uint amountETH);
529     function removeLiquidityWithPermit(
530         address tokenA,
531         address tokenB,
532         uint liquidity,
533         uint amountAMin,
534         uint amountBMin,
535         address to,
536         uint deadline,
537         bool approveMax, uint8 v, bytes32 r, bytes32 s
538     ) external returns(uint amountA, uint amountB);
539     function removeLiquidityETHWithPermit(
540         address token,
541         uint liquidity,
542         uint amountTokenMin,
543         uint amountETHMin,
544         address to,
545         uint deadline,
546         bool approveMax, uint8 v, bytes32 r, bytes32 s
547     ) external returns(uint amountToken, uint amountETH);
548     function swapExactTokensForTokens(
549         uint amountIn,
550         uint amountOutMin,
551         address[] calldata path,
552         address to,
553         uint deadline
554     ) external returns(uint[] memory amounts);
555     function swapTokensForExactTokens(
556         uint amountOut,
557         uint amountInMax,
558         address[] calldata path,
559         address to,
560         uint deadline
561     ) external returns(uint[] memory amounts);
562     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
563     external
564     payable
565     returns(uint[] memory amounts);
566     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
567     external
568     returns(uint[] memory amounts);
569     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
570     external
571     returns(uint[] memory amounts);
572     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
573     external
574     payable
575     returns(uint[] memory amounts);
576 
577     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
578     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
579     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
580     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
581     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
582 }
583 
584 interface IUniswapV2Router02 is IUniswapV2Router01 {
585     function removeLiquidityETHSupportingFeeOnTransferTokens(
586         address token,
587         uint liquidity,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline
592     ) external returns(uint amountETH);
593     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
594         address token,
595         uint liquidity,
596         uint amountTokenMin,
597         uint amountETHMin,
598         address to,
599         uint deadline,
600         bool approveMax, uint8 v, bytes32 r, bytes32 s
601     ) external returns(uint amountETH);
602 
603     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
604         uint amountIn,
605         uint amountOutMin,
606         address[] calldata path,
607         address to,
608         uint deadline
609     ) external;
610     function swapExactETHForTokensSupportingFeeOnTransferTokens(
611         uint amountOutMin,
612         address[] calldata path,
613         address to,
614         uint deadline
615     ) external payable;
616     function swapExactTokensForETHSupportingFeeOnTransferTokens(
617         uint amountIn,
618         uint amountOutMin,
619         address[] calldata path,
620         address to,
621         uint deadline
622     ) external;
623 }
624  
625 
626 
627 contract Diablo is ERC20, Ownable {
628     using SafeMath for uint256;
629 
630     IUniswapV2Router02 public immutable router;
631     address public immutable uniswapV2Pair;
632 
633 
634     // addresses
635     address public  jeetsburnerWallet;
636     address private marketingWallet;
637 
638     // limits 
639     uint256 private maxBuyAmount;
640     uint256 private maxSellAmount;   
641     uint256 private maxWalletAmount;
642  
643     uint256 private thresholdSwapAmount;
644 
645     // status flags
646     bool private isTrading = false;
647     bool public swapEnabled = false;
648     bool public isSwapping;
649 
650 
651     struct Fees {
652         uint8 buyTotalFees;
653         uint8 buyMarketingFee;
654         uint8 buyJeetsburnerFee;
655         uint8 buyLiquidityFee;
656 
657         uint8 sellTotalFees;
658         uint8 sellMarketingFee;
659         uint8 sellJeetsburnerFee;
660         uint8 sellLiquidityFee;
661     }  
662 
663     Fees public _fees = Fees({
664         buyTotalFees: 0,
665         buyMarketingFee: 0,
666         buyJeetsburnerFee:0,
667         buyLiquidityFee: 0,
668 
669         sellTotalFees: 0,
670         sellMarketingFee: 0,
671         sellJeetsburnerFee:0,
672         sellLiquidityFee: 0
673     });
674     
675     
676 
677     uint256 public tokensForMarketing;
678     uint256 public tokensForLiquidity;
679     uint256 public tokensForJeetsburner;
680     uint256 private taxTill;
681     // exclude from fees and max transaction amount
682     mapping(address => bool) private _isExcludedFromFees;
683     mapping(address => bool) public _isExcludedMaxTransactionAmount;
684     mapping(address => bool) public _isExcludedMaxWalletAmount;
685      mapping(address => bool) private isearlybuyer;
686 
687 
688     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
689     // could be subject to a maximum transfer amount
690     mapping(address => bool) public marketPair;
691     
692     event SwapAndLiquify(
693         uint256 tokensSwapped,
694         uint256 ethReceived
695     );
696 
697 
698     constructor() ERC20("Diablo", "DIABLO") {
699  
700         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
701 
702 
703         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
704 
705         _isExcludedMaxTransactionAmount[address(router)] = true;
706         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
707         _isExcludedMaxTransactionAmount[owner()] = true;
708         _isExcludedMaxTransactionAmount[address(this)] = true;
709 
710         _isExcludedFromFees[owner()] = true;
711         _isExcludedFromFees[address(this)] = true;
712 
713         _isExcludedMaxWalletAmount[owner()] = true;
714         _isExcludedMaxWalletAmount[address(this)] = true;
715         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
716 
717 
718         marketPair[address(uniswapV2Pair)] = true;
719 
720         approve(address(router), type(uint256).max);
721         uint256 totalSupply = 666000000000 * 1e18;
722 
723         maxBuyAmount = totalSupply * 1 / 100; // 1% maxTransactionAmountTxn
724         maxSellAmount = totalSupply * 1 / 100; // 1% maxTransactionAmountTxn
725         maxWalletAmount = totalSupply * 1 / 100; // 1% maxWallet
726         thresholdSwapAmount = totalSupply * 85 / 10000; // 0.85% swap wallet
727 
728         _fees.buyMarketingFee = 14;
729         _fees.buyLiquidityFee = 1;
730         _fees.buyJeetsburnerFee = 5;
731         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyJeetsburnerFee;
732 
733         _fees.sellMarketingFee = 30;
734         _fees.sellLiquidityFee = 1;
735         _fees.sellJeetsburnerFee = 10;
736         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellJeetsburnerFee;
737 
738 
739         marketingWallet = address(0x83991b0999DC5972a87B38Cb8F8bE4F353197a6a);
740         jeetsburnerWallet = address(0x5f87f0C632BaF55FFeD0a4180beC62B27b0a018e);
741 
742         // exclude from paying fees or having max transaction amount
743 
744         /*
745             _mint is an internal function in ERC20.sol that is only called here,
746             and CANNOT be called ever again
747         */
748         _mint(msg.sender, totalSupply);
749     }
750 
751     receive() external payable {
752 
753     }
754 
755     // once enabled, can never be turned off
756     function swapTrading() external onlyOwner {
757         isTrading = true;
758         swapEnabled = true;
759         taxTill = block.number + 2;
760     }
761 
762 
763 
764     // change the minimum amount of tokens to sell from fees
765     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
766         thresholdSwapAmount = newAmount;
767         return true;
768     }
769 
770 
771     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) external onlyOwner {
772         require(((totalSupply() * newMaxBuy) / 1000) >= (totalSupply() / 100), "maxBuyAmount must be higher than 1%");
773         require(((totalSupply() * newMaxSell) / 1000) >= (totalSupply() / 100), "maxSellAmount must be higher than 1%");
774         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
775         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
776     }
777 
778 
779     function updateMaxWalletAmount(uint256 newPercentage) external onlyOwner {
780         require(((totalSupply() * newPercentage) / 1000) >= (totalSupply() / 100), "Cannot set maxWallet lower than 1%");
781         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
782     }
783 
784     function updateFees(uint8 _marketingFeeBuy, uint8 _liquidityFeeBuy,uint8 _jeetsburnerFeeBuy,uint8 _marketingFeeSell, uint8 _liquidityFeeSell,uint8 _jeetsburnerFeeSell) external onlyOwner{
785         _fees.buyMarketingFee = _marketingFeeBuy;
786         _fees.buyLiquidityFee = _liquidityFeeBuy;
787         _fees.buyJeetsburnerFee = _jeetsburnerFeeBuy;
788         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyJeetsburnerFee;
789 
790         _fees.sellMarketingFee = _marketingFeeSell;
791         _fees.sellLiquidityFee = _liquidityFeeSell;
792         _fees.sellJeetsburnerFee = _jeetsburnerFeeSell;
793         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellJeetsburnerFee;
794         require(_fees.buyTotalFees <= 50, "Must keep fees at 50% or less");   
795         require(_fees.sellTotalFees <= 50, "Must keep fees at 50% or less");
796      
797     }
798     
799     function excludeFromFees(address account, bool excluded) public onlyOwner {
800         _isExcludedFromFees[account] = excluded;
801     }
802     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
803         _isExcludedMaxWalletAmount[account] = excluded;
804     }
805     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
806         _isExcludedMaxTransactionAmount[updAds] = isEx;
807     }
808 
809      function updateIsEarlyBuyer(address account, bool state) external onlyOwner {
810         isearlybuyer[account] = state;
811     }
812 
813     function bulkIsEarlyBuyer(address[] memory accounts, bool state) external onlyOwner {
814         for (uint256 i = 0; i < accounts.length; i++) {
815             isearlybuyer[accounts[i]] = state;
816         }
817     }
818     function setMarketPair(address pair, bool value) public onlyOwner {
819         require(pair != uniswapV2Pair, "Must keep uniswapV2Pair");
820         marketPair[pair] = value;
821     }
822     function rescueETH(uint256 weiAmount) external onlyOwner {
823         payable(owner()).transfer(weiAmount);
824     }
825 
826     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
827         IERC20(tokenAdd).transfer(owner(), amount);
828     }
829 
830     function setWallets(address _marketingWallet,address _jeetsburnerWallet) external onlyOwner{
831         marketingWallet = _marketingWallet;
832         jeetsburnerWallet = _jeetsburnerWallet;
833     }
834 
835     function isExcludedFromFees(address account) public view returns(bool) {
836         return _isExcludedFromFees[account];
837     }
838 
839     function _transfer(
840         address sender,
841         address recipient,
842         uint256 amount
843         
844     ) internal override {
845         require(!isearlybuyer[sender] && !isearlybuyer[recipient],
846             "You can't transfer tokens"
847              );
848         
849         
850         if (amount == 0) {
851             super._transfer(sender, recipient, 0);
852             return;
853         }
854 
855         if (
856             sender != owner() &&
857             recipient != owner() &&
858             !isSwapping
859         ) {
860 
861             if (!isTrading) {
862                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
863             }
864             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
865                 require(amount <= maxBuyAmount, "buy transfer over max amount");
866             } 
867             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
868                 require(amount <= maxSellAmount, "Sell transfer over max amount");
869             }
870 
871             if (!_isExcludedMaxWalletAmount[recipient]) {
872                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
873             }
874            
875         }
876  
877         
878  
879         uint256 contractTokenBalance = balanceOf(address(this));
880  
881         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
882 
883         if (
884             canSwap &&
885             swapEnabled &&
886             !isSwapping &&
887             marketPair[recipient] &&
888             !_isExcludedFromFees[sender] &&
889             !_isExcludedFromFees[recipient]
890         ) {
891             isSwapping = true;
892             swapBack();
893             isSwapping = false;
894         }
895  
896         bool takeFee = !isSwapping;
897 
898         // if any account belongs to _isExcludedFromFee account then remove the fee
899         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
900             takeFee = false;
901         }
902  
903         
904         // only take fees on buys/sells, do not take on wallet transfers
905         if (takeFee) {
906             uint256 fees = 0;
907             if(block.number < taxTill) {
908                 fees = amount.mul(99).div(100);
909                 tokensForMarketing += (fees * 94) / 99;
910                 tokensForJeetsburner += (fees * 5) / 99;
911             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
912                 fees = amount.mul(_fees.sellTotalFees).div(100);
913                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
914                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
915                 tokensForJeetsburner += fees * _fees.sellJeetsburnerFee / _fees.sellTotalFees;
916             }
917             // on buy
918             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
919                 fees = amount.mul(_fees.buyTotalFees).div(100);
920                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
921                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
922                 tokensForJeetsburner += fees * _fees.buyJeetsburnerFee / _fees.buyTotalFees;
923             }
924 
925             if (fees > 0) {
926                 super._transfer(sender, address(this), fees);
927             }
928 
929             amount -= fees;
930 
931         }
932 
933         super._transfer(sender, recipient, amount);
934     }
935 
936     function swapTokensForEth(uint256 tAmount) private {
937 
938         // generate the uniswap pair path of token -> weth
939         address[] memory path = new address[](2);
940         path[0] = address(this);
941         path[1] = router.WETH();
942 
943         _approve(address(this), address(router), tAmount);
944 
945         // make the swap
946         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
947             tAmount,
948             0, // accept any amount of ETH
949             path,
950             address(this),
951             block.timestamp
952         );
953 
954     }
955 
956     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
957         // approve token transfer to cover all possible scenarios
958         _approve(address(this), address(router), tAmount);
959 
960         // add the liquidity
961         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
962     }
963 
964     function swapBack() private {
965         uint256 contractTokenBalance = balanceOf(address(this));
966         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForJeetsburner;
967         bool success;
968 
969         if (contractTokenBalance == 0 || toSwap == 0) { return; }
970 
971         if (contractTokenBalance > thresholdSwapAmount * 20) {
972             contractTokenBalance = thresholdSwapAmount * 20;
973         }
974 
975         // Halve the amount of liquidity tokens
976         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
977         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
978  
979         uint256 initialETHBalance = address(this).balance;
980 
981         swapTokensForEth(amountToSwapForETH); 
982  
983         uint256 newBalance = address(this).balance.sub(initialETHBalance);
984  
985         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
986         uint256 ethForJeetsburner = newBalance.mul(tokensForJeetsburner).div(toSwap);
987         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForJeetsburner);
988 
989 
990         tokensForLiquidity = 0;
991         tokensForMarketing = 0;
992         tokensForJeetsburner = 0;
993 
994 
995         if (liquidityTokens > 0 && ethForLiquidity > 0) {
996             addLiquidity(liquidityTokens, ethForLiquidity);
997             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
998         }
999 
1000         (success,) = address(jeetsburnerWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
1001         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
1002     }
1003 
1004 }