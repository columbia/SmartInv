1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.21;
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
17     event OwnershipTransferred(
18         address indexed previousOwner,
19         address indexed newOwner
20     );
21 
22     /**
23      * @dev Initializes the contract setting the deployer as the initial owner.
24      */
25     constructor() {
26         _transferOwnership(_msgSender());
27     }
28 
29     /**
30      * @dev Returns the address of the current owner.
31      */
32     function owner() public view virtual returns (address) {
33         return _owner;
34     }
35 
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     /**
45      * @dev Leaves the contract without owner. It will not be possible to call
46      * `onlyOwner` functions anymore. Can only be called by the current owner.
47      *
48      * NOTE: Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public virtual onlyOwner {
52         _transferOwnership(address(0));
53     }
54 
55     /**
56      * @dev Transfers ownership of the contract to a new account (`newOwner`).
57      * Can only be called by the current owner.
58      */
59     function transferOwnership(address newOwner) public virtual onlyOwner {
60         require(
61             newOwner != address(0),
62             "Ownable: new owner is the zero address"
63         );
64         _transferOwnership(newOwner);
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      * Internal function without access restriction.
70      */
71     function _transferOwnership(address newOwner) internal virtual {
72         address oldOwner = _owner;
73         _owner = newOwner;
74         emit OwnershipTransferred(oldOwner, newOwner);
75     }
76 }
77 
78 interface IERC20 {
79     /**
80      * @dev Returns the amount of tokens in existence.
81      */
82     function totalSupply() external view returns (uint256);
83 
84     /**
85      * @dev Returns the amount of tokens owned by `account`.
86      */
87     function balanceOf(address account) external view returns (uint256);
88 
89     /**
90      * @dev Moves `amount` tokens from the caller's account to `recipient`.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transfer(
97         address recipient,
98         uint256 amount
99     ) external returns (bool);
100 
101     function allowance(
102         address owner,
103         address spender
104     ) external view returns (uint256);
105 
106     function approve(address spender, uint256 amount) external returns (bool);
107 
108     function transferFrom(
109         address sender,
110         address recipient,
111         uint256 amount
112     ) external returns (bool);
113 
114     /**
115      * @dev Emitted when `value` tokens are moved from one account (`from`) to
116      * another (`to`).
117      *
118      * Note that `value` may be zero.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 
122     /**
123      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
124      * a call to {approve}. `value` is the new allowance.
125      */
126     event Approval(
127         address indexed owner,
128         address indexed spender,
129         uint256 value
130     );
131 }
132 
133 interface IERC20Metadata is IERC20 {
134     /**
135      * @dev Returns the name of the token.
136      */
137     function name() external view returns (string memory);
138 
139     /**
140      * @dev Returns the symbol of the token.
141      */
142     function symbol() external view returns (string memory);
143 
144     /**
145      * @dev Returns the decimals places of the token.
146      */
147     function decimals() external view returns (uint8);
148 }
149 
150 contract ERC20 is Context, IERC20, IERC20Metadata {
151     mapping(address => uint256) private _balances;
152     mapping(address => mapping(address => uint256)) private _allowances;
153 
154     uint256 private _totalSupply;
155     string private _name;
156     string private _symbol;
157 
158     constructor(string memory name_, string memory symbol_) {
159         _name = name_;
160         _symbol = symbol_;
161     }
162 
163     /**
164      * @dev Returns the name of the token.
165      */
166     function name() public view virtual override returns (string memory) {
167         return _name;
168     }
169 
170     /**
171      * @dev Returns the symbol of the token, usually a shorter version of the
172      * name.
173      */
174     function symbol() public view virtual override returns (string memory) {
175         return _symbol;
176     }
177 
178     function decimals() public view virtual override returns (uint8) {
179         return 18;
180     }
181 
182     /**
183      * @dev See {IERC20-totalSupply}.
184      */
185     function totalSupply() public view virtual override returns (uint256) {
186         return _totalSupply;
187     }
188 
189     /**
190      * @dev See {IERC20-balanceOf}.
191      */
192     function balanceOf(
193         address account
194     ) public view virtual override returns (uint256) {
195         return _balances[account];
196     }
197 
198     /**
199      * @dev See {IERC20-transfer}.
200      *
201      * Requirements:
202      *
203      * - `recipient` cannot be the zero address.
204      * - the caller must have a balance of at least `amount`.
205      */
206     function transfer(
207         address recipient,
208         uint256 amount
209     ) public virtual override returns (bool) {
210         _transfer(_msgSender(), recipient, amount);
211         return true;
212     }
213 
214     /**
215      * @dev See {IERC20-allowance}.
216      */
217     function allowance(
218         address owner,
219         address spender
220     ) public view virtual override returns (uint256) {
221         return _allowances[owner][spender];
222     }
223 
224     /**
225      * @dev See {IERC20-approve}.
226      *
227      * Requirements:
228      *
229      * - `spender` cannot be the zero address.
230      */
231     function approve(
232         address spender,
233         uint256 amount
234     ) public virtual override returns (bool) {
235         _approve(_msgSender(), spender, amount);
236         return true;
237     }
238 
239     function transferFrom(
240         address sender,
241         address recipient,
242         uint256 amount
243     ) public virtual override returns (bool) {
244         _transfer(sender, recipient, amount);
245 
246         uint256 currentAllowance = _allowances[sender][_msgSender()];
247         require(
248             currentAllowance >= amount,
249             "ERC20: transfer amount exceeds allowance"
250         );
251         unchecked {
252             _approve(sender, _msgSender(), currentAllowance - amount);
253         }
254 
255         return true;
256     }
257 
258     function increaseAllowance(
259         address spender,
260         uint256 addedValue
261     ) public virtual returns (bool) {
262         _approve(
263             _msgSender(),
264             spender,
265             _allowances[_msgSender()][spender] + addedValue
266         );
267         return true;
268     }
269 
270     function decreaseAllowance(
271         address spender,
272         uint256 subtractedValue
273     ) public virtual returns (bool) {
274         uint256 currentAllowance = _allowances[_msgSender()][spender];
275         require(
276             currentAllowance >= subtractedValue,
277             "ERC20: decreased allowance below zero"
278         );
279         unchecked {
280             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
281         }
282 
283         return true;
284     }
285 
286     function _transfer(
287         address sender,
288         address recipient,
289         uint256 amount
290     ) internal virtual {
291         require(sender != address(0), "ERC20: transfer from the zero address");
292         require(recipient != address(0), "ERC20: transfer to the zero address");
293 
294         _beforeTokenTransfer(sender, recipient, amount);
295 
296         uint256 senderBalance = _balances[sender];
297         require(
298             senderBalance >= amount,
299             "ERC20: transfer amount exceeds balance"
300         );
301         unchecked {
302             _balances[sender] = senderBalance - amount;
303         }
304         _balances[recipient] += amount;
305 
306         emit Transfer(sender, recipient, amount);
307 
308         _afterTokenTransfer(sender, recipient, amount);
309     }
310 
311     function _mint(address account, uint256 amount) internal virtual {
312         require(account != address(0), "ERC20: mint to the zero address");
313 
314         _beforeTokenTransfer(address(0), account, amount);
315 
316         _totalSupply += amount;
317         _balances[account] += amount;
318         emit Transfer(address(0), account, amount);
319 
320         _afterTokenTransfer(address(0), account, amount);
321     }
322 
323     function _burn(address account, uint256 amount) internal virtual {
324         require(account != address(0), "ERC20: burn from the zero address");
325 
326         _beforeTokenTransfer(account, address(0), amount);
327 
328         uint256 accountBalance = _balances[account];
329         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
330         unchecked {
331             _balances[account] = accountBalance - amount;
332         }
333         _totalSupply -= amount;
334 
335         emit Transfer(account, address(0), amount);
336 
337         _afterTokenTransfer(account, address(0), amount);
338     }
339 
340     function _approve(
341         address owner,
342         address spender,
343         uint256 amount
344     ) internal virtual {
345         require(owner != address(0), "ERC20: approve from the zero address");
346         require(spender != address(0), "ERC20: approve to the zero address");
347 
348         _allowances[owner][spender] = amount;
349         emit Approval(owner, spender, amount);
350     }
351 
352     function _beforeTokenTransfer(
353         address from,
354         address to,
355         uint256 amount
356     ) internal virtual {}
357 
358     function _afterTokenTransfer(
359         address from,
360         address to,
361         uint256 amount
362     ) internal virtual {}
363 }
364 
365 interface IUniswapV2Factory {
366     event PairCreated(
367         address indexed token0,
368         address indexed token1,
369         address pair,
370         uint256
371     );
372 
373     function feeTo() external view returns (address);
374 
375     function feeToSetter() external view returns (address);
376 
377     function getPair(
378         address tokenA,
379         address tokenB
380     ) external view returns (address pair);
381 
382     function allPairs(uint256) external view returns (address pair);
383 
384     function allPairsLength() external view returns (uint256);
385 
386     function createPair(
387         address tokenA,
388         address tokenB
389     ) external returns (address pair);
390 
391     function setFeeTo(address) external;
392 
393     function setFeeToSetter(address) external;
394 }
395 
396 
397 
398 interface IUniswapV2Pair {
399     event Approval(
400         address indexed owner,
401         address indexed spender,
402         uint256 value
403     );
404     event Transfer(address indexed from, address indexed to, uint256 value);
405 
406     function name() external pure returns (string memory);
407 
408     function symbol() external pure returns (string memory);
409 
410     function decimals() external pure returns (uint8);
411 
412     function totalSupply() external view returns (uint256);
413 
414     function balanceOf(address owner) external view returns (uint256);
415 
416     function allowance(
417         address owner,
418         address spender
419     ) external view returns (uint256);
420 
421     function approve(address spender, uint256 value) external returns (bool);
422 
423     function transfer(address to, uint256 value) external returns (bool);
424 
425     function transferFrom(
426         address from,
427         address to,
428         uint256 value
429     ) external returns (bool);
430 
431     function DOMAIN_SEPARATOR() external view returns (bytes32);
432 
433     function PERMIT_TYPEHASH() external pure returns (bytes32);
434 
435     function nonces(address owner) external view returns (uint256);
436 
437     function permit(
438         address owner,
439         address spender,
440         uint256 value,
441         uint256 deadline,
442         uint8 v,
443         bytes32 r,
444         bytes32 s
445     ) external;
446 
447     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
448     event Burn(
449         address indexed sender,
450         uint256 amount0,
451         uint256 amount1,
452         address indexed to
453     );
454     event Swap(
455         address indexed sender,
456         uint256 amount0In,
457         uint256 amount1In,
458         uint256 amount0Out,
459         uint256 amount1Out,
460         address indexed to
461     );
462     event Sync(uint112 reserve0, uint112 reserve1);
463 
464     function MINIMUM_LIQUIDITY() external pure returns (uint256);
465 
466     function factory() external view returns (address);
467 
468     function token0() external view returns (address);
469 
470     function token1() external view returns (address);
471 
472     function getReserves()
473         external
474         view
475         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
476 
477     function price0CumulativeLast() external view returns (uint256);
478 
479     function price1CumulativeLast() external view returns (uint256);
480 
481     function kLast() external view returns (uint256);
482 
483     function mint(address to) external returns (uint256 liquidity);
484 
485     function burn(
486         address to
487     ) external returns (uint256 amount0, uint256 amount1);
488 
489     function swap(
490         uint256 amount0Out,
491         uint256 amount1Out,
492         address to,
493         bytes calldata data
494     ) external;
495 
496     function skim(address to) external;
497 
498     function sync() external;
499 
500     function initialize(address, address) external;
501 }
502 
503 interface IUniswapV2Router02 {
504     function factory() external pure returns (address);
505 
506     function WETH() external pure returns (address);
507 
508     function addLiquidity(
509         address tokenA,
510         address tokenB,
511         uint256 amountADesired,
512         uint256 amountBDesired,
513         uint256 amountAMin,
514         uint256 amountBMin,
515         address to,
516         uint256 deadline
517     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
518 
519     function addLiquidityETH(
520         address token,
521         uint256 amountTokenDesired,
522         uint256 amountTokenMin,
523         uint256 amountETHMin,
524         address to,
525         uint256 deadline
526     )
527         external
528         payable
529         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
530 
531     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
532         uint256 amountIn,
533         uint256 amountOutMin,
534         address[] calldata path,
535         address to,
536         uint256 deadline
537     ) external;
538 
539     function swapExactETHForTokensSupportingFeeOnTransferTokens(
540         uint256 amountOutMin,
541         address[] calldata path,
542         address to,
543         uint256 deadline
544     ) external payable;
545 
546     function swapExactTokensForETHSupportingFeeOnTransferTokens(
547         uint256 amountIn,
548         uint256 amountOutMin,
549         address[] calldata path,
550         address to,
551         uint256 deadline
552     ) external;
553 }
554 
555 contract RatRacer is ERC20, Ownable {
556    
557     event SwapBackSuccess(
558         uint256 tokenAmount,
559         uint256 ethAmountReceived,
560         bool success
561     );
562     bool private swapping;
563     address public marketingWallet = address(0x10b06cd2897B16Aa2F767aAced3d5A0B696c37c7); //your marketing wallet here
564 
565     address public devWallet = address(0xdBCF9A0776e59D9b65534266138181331e244977); // your dev wallet here
566 
567     uint256 _totalSupply = 1_000_000 * 1e18;
568     uint256 public maxTransactionAmount = (_totalSupply * 20) / 1000; // 2% from total supply maxTransactionAmountTxn;
569     uint256 public swapTokensAtAmount = (_totalSupply * 10) / 10000; // 0.1% of the supply (swap tokens at this amount). 
570     uint256 public maxWallet = (_totalSupply * 20) / 1000; // 2% from total supply maxWallet (valid for first hour of trade start)
571 
572     bool public limitsInEffect = true;
573     bool public tradingActive = false;
574     bool public swapEnabled = false;
575 
576 
577     uint256 public buyFees = 5;
578     uint256 public sellFees = 5;
579 
580     uint256 public marketingShare = 50; //marketing share
581     uint256 public devShare = 50; //dev share
582 
583     uint256 public tradeStartTimestamp;
584 
585     IUniswapV2Router02 public uniswapV2Router;
586     address public uniswapV2Pair;
587     address public constant deadAddress = address(0xdead);
588 
589     // exlcude from fees and max transaction amount
590     mapping(address => bool) private _isExcludedFromFees;
591     mapping(address => bool) public _isExcludedMaxTransactionAmount;
592     mapping(address => bool) public automatedMarketMakerPairs;
593 
594     constructor() ERC20("RatRacer", "RATS") {
595         // exclude from paying fees or having max transaction amount
596         excludeFromFees(owner(), true);
597         excludeFromFees(marketingWallet, true);
598         excludeFromFees(devWallet, true);
599         excludeFromFees(address(this), true);
600         excludeFromFees(address(0xdead), true);
601         excludeFromMaxTransaction(owner(), true);
602         excludeFromMaxTransaction(marketingWallet, true);
603         excludeFromMaxTransaction(devWallet, true);
604         excludeFromMaxTransaction(address(this), true);
605         excludeFromMaxTransaction(address(0xdead), true);
606         _mint(address(this), (_totalSupply * 90)/100); 
607         _mint(owner(), (_totalSupply *10)/100);
608     }
609 
610     receive() external payable {}
611 
612     // once enabled, can never be turned off
613     function enableTrading() external onlyOwner {
614         require (!tradingActive, "Trading is already live");
615         tradingActive = true;
616         swapEnabled = true;
617         tradeStartTimestamp = block.timestamp;
618     }
619 
620     // remove limits manually (if owner want to remove limits before 1 hour of trading launch)
621     function removeLimits() external onlyOwner returns (bool) {
622         require(!limitsInEffect, "limits already removed");
623         limitsInEffect = false;
624         return true;
625     }
626 
627     function excludeFromMaxTransaction(
628         address addressToExclude,
629         bool isExcluded
630     ) public onlyOwner {
631         _isExcludedMaxTransactionAmount[addressToExclude] = isExcluded;
632     }
633 
634     // only use to disable contract sales if absolutely necessary (emergency use only)
635     function updateSwapEnabled(bool enabled) external onlyOwner {
636         swapEnabled = enabled;
637     }
638 
639     function excludeFromFees(address account, bool excluded) public onlyOwner {
640         _isExcludedFromFees[account] = excluded;
641     }
642 
643     function setAutomatedMarketMakerPair(
644         address pair,
645         bool value
646     ) public onlyOwner {
647         require(
648             pair != uniswapV2Pair,
649             "The pair cannot be removed from automatedMarketMakerPairs"
650         );
651         _setAutomatedMarketMakerPair(pair, value);
652     }
653 
654     function addLiquidity() external payable onlyOwner {
655         // approve token transfer to cover all possible scenarios
656         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
657             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
658         );
659 
660         uniswapV2Router = _uniswapV2Router;
661         excludeFromMaxTransaction(address(_uniswapV2Router), true);
662         _approve(address(this), address(uniswapV2Router), totalSupply());
663         // add the liquidity
664         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
665             .createPair(address(this), _uniswapV2Router.WETH());
666         excludeFromMaxTransaction(address(uniswapV2Pair), true);
667         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
668 
669         uniswapV2Router.addLiquidityETH{value: msg.value}(
670             address(this), //token address
671             balanceOf(address(this)), // liquidity amount
672             0, // slippage is unavoidable
673             0, // slippage is unavoidable
674             owner(), // LP tokens are sent to the owner
675             block.timestamp
676         );
677     }
678 
679     function _setAutomatedMarketMakerPair(address pair, bool value) private {
680         automatedMarketMakerPairs[pair] = value;
681     }
682 
683     function updateFeeWallet(
684         address marketingWallet_,
685         address devWallet_
686     ) public onlyOwner {
687         devWallet = devWallet_;
688         marketingWallet = marketingWallet_;
689     }
690 
691     function isExcludedFromFees(address account) public view returns (bool) {
692         return _isExcludedFromFees[account];
693     }
694 
695     function _transfer(
696         address from,
697         address to,
698         uint256 amount
699     ) internal override {
700         require(from != address(0), "ERC20: transfer from the zero address");
701         require(to != address(0), "ERC20: transfer to the zero address");
702         require(amount > 0, "Transfer amount must be greater than zero");
703         if (limitsInEffect) {
704             if (
705                 from != owner() &&
706                 to != owner() &&
707                 to != address(0) &&
708                 to != address(0xdead) &&
709                 !swapping
710             ) {
711                 if (!tradingActive) {
712                     require(
713                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
714                         "Trading is not enabled yet."
715                     );
716                 }
717                uint256 tradeStartTime = tradeStartTimestamp;
718                if(!tradingActive){
719                 tradeStartTime = block.timestamp;
720                } 
721                ///checks limits only if it's under 1 hour of launch 
722                if (block.timestamp - tradeStartTime <= 1 hours){
723                 //when buy
724                 if (
725                     automatedMarketMakerPairs[from] &&
726                     !_isExcludedMaxTransactionAmount[to]
727                 ) {
728                     require(
729                         amount <= maxTransactionAmount,
730                         "Buy transfer amount exceeds the maxTransactionAmount."
731                     );
732                     require(
733                         amount + balanceOf(to) <= maxWallet,
734                         "Max wallet exceeded"
735                     );
736                 }
737                 //when sell
738                 else if (
739                     automatedMarketMakerPairs[to] &&
740                     !_isExcludedMaxTransactionAmount[from]
741                 ) {
742                     require(
743                         amount <= maxTransactionAmount,
744                         "Sell transfer amount exceeds the maxTransactionAmount."
745                     );
746                 } else if (!_isExcludedMaxTransactionAmount[to]) {
747                     require(
748                         amount + balanceOf(to) <= maxWallet,
749                         "Max wallet exceeded"
750                     );
751                  }
752               }
753             }
754         }
755 
756         if (
757             swapEnabled && //if this is true
758             !swapping && //if this is false
759             !automatedMarketMakerPairs[from] && //if this is false
760             !_isExcludedFromFees[from] && //if this is false
761             !_isExcludedFromFees[to] //if this is false
762         ) {
763             swapping = true;
764             swapBack();
765             swapping = false;
766         }
767 
768         bool takeFee = !swapping;
769 
770         // if any account belongs to _isExcludedFromFee account then remove the fee
771         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
772             takeFee = false;
773         }
774 
775         uint256 fees = 0;
776         // only take fees on buys/sells, do not take on wallet transfers
777         if (takeFee) {
778             // on sell
779             if (automatedMarketMakerPairs[to] && sellFees > 0) {
780                 fees = (amount * sellFees) / 100;
781             }
782             // on buy
783             else if (automatedMarketMakerPairs[from] && buyFees > 0) {
784                 fees = (amount * buyFees) / 100;
785             }
786 
787             if (fees > 0) {
788                 super._transfer(from, address(this), fees);
789             }
790             amount -= fees;
791         }
792         super._transfer(from, to, amount);
793     }
794 
795     function swapTokensForEth(uint256 tokenAmount) private {
796         // generate the uniswap pair path of token -> weth
797         address[] memory path = new address[](2);
798         path[0] = address(this);
799         path[1] = uniswapV2Router.WETH();
800         _approve(address(this), address(uniswapV2Router), tokenAmount);
801         // make the swap
802         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
803             tokenAmount,
804             0, // accept any amount of ETH
805             path,
806             address(this),
807             block.timestamp
808         );
809     }
810 
811     function swapBack() private {
812         uint256 contractBalance = balanceOf(address(this));
813         bool success;
814         if (contractBalance == 0) {
815             return;
816         }
817         if (contractBalance >= swapTokensAtAmount) {
818             uint256 amountToSwapForETH = swapTokensAtAmount;
819             swapTokensForEth(amountToSwapForETH);
820             uint256 amountEthToSend = address(this).balance;
821             uint256 amountToMarketing = (amountEthToSend * marketingShare) / 100;
822             uint256 amountToDev = amountEthToSend - amountToMarketing;
823             (success, ) = address(marketingWallet).call{value: amountToMarketing}("");
824             (success, ) = address(devWallet).call{value: amountToDev}("");
825             emit SwapBackSuccess(amountToSwapForETH, amountEthToSend, success);
826         }
827     }
828 }