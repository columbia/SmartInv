1 /*
2    ___            _        _  _    ___    _         _              ___                   
3   | _ )   __ _   | |__    | || |  / __|  | |_      (_)    __ _    |_ _|   _ _     _  _   
4   | _ \  / _` |  | '_ \    \_, |  \__ \  | ' \     | |   / _` |    | |   | ' \   | +| |  
5   |___/  \__,_|  |_.__/   _|__/   |___/  |_||_|   _|_|_  \__,_|   |___|  |_||_|   \_,_|  
6 _|"""""|_|"""""|_|"""""|_| """"|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| 
7 "`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-' 
8 
9                                                                                 
10                                                        ###                      
11                                                    ## @@@ #                     
12                         ##   ##    (#############  @@ @@@ /                     
13                         # @@ @  ################ *###@@@@(                      
14                          #@& ###############&@@@@####/##(                       
15                            ##@@@#############   #####(###                       
16                           ####     #########  @#  ########                      
17                         ######      ########  #   ###@@@@@@@                    
18                        #######   .  #@@@@@@@@&. *@@@@###@@@@%                   
19                       /@@@####@@@@@@@     @@@@@@@@@#####@@@@@                   
20                        @@@%###@@@@@@&@@@     %@@@@@@@@@@@@@@                    
21                          @@@@@@@@@@@@@@  #(# @@@@@@@@@@@@@@                     
22                             @@@@@@@@@@@@@@@@@@@@@@@@@@@@@   &@@                 
23                  @@@@  %##%%%%,  &@@@@@@@@@@@@@@@@@.   (((( @ @@@@@             
24                 @ @@ #%%%%%%% ((((( @,         /(((((((((  &@ @@@@@             
25                    #%%%%%%%  ((((((@ (((((,@((((((( ((((( @ @@@@@@              
26                 %%#%#%%%#% ((((((( @(((((((@/((((((( /((((  @                   
27                %%#%%%##%% *(((((((@@ (((((@@.(((((((((                          
28                (%#%%##%#. ((((((((((((((((((((((((((((((                        
29         %%%%%%# %%#%#%%%# /((((((( @&,        ((((((((((                        
30                  %%#%%###  ((((( @ @@@@@@@@@@ /*((((((((.                       
31                    %%##%%%#  ((.#@@@@@@@@@@@@@@@.(((((((                        
32                       %%%%### (/(((*            (((((((                         
33                              #   /((((((((/,..,/(((((((                         
34                              ########.                (                         
35                              ###########      #########                         
36                             ###########(       ########                         
37                             ###########        #########                        
38                             @@@@@@@@@@@         ##@@@@@@@@%                     
39                           @@ @@@ @@@@@@          @@@@  @@@ @                    
40                               &  @@@              @@@@& *                       
41 
42 Telegram: http://t.me/babyshiainu
43 Web: https://babyshiainu.com
44 Twitter: https://twitter.com/babyshiainu
45 
46 */
47 
48 // SPDX-License-Identifier: UNLICENSED
49 
50 pragma solidity ^0.8.21;
51 
52 abstract contract Context {
53     function _msgSender() internal view virtual returns (address) {
54         return msg.sender;
55     }
56 
57     function _msgData() internal view virtual returns (bytes calldata) {
58         return msg.data;
59     }
60 }
61 
62 
63 abstract contract Ownable is Context {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68 
69     constructor() {
70         _transferOwnership(_msgSender());
71     }
72 
73 
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78 
79     modifier onlyOwner() {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88 
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     function _transferOwnership(address newOwner) internal virtual {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 interface IERC20 {
102 
103     function totalSupply() external view returns (uint256);
104 
105     function balanceOf(address account) external view returns (uint256);
106 
107     function transfer(address recipient, uint256 amount) external returns (bool);
108 
109     function allowance(address owner, address spender) external view returns (uint256);
110 
111     function approve(address spender, uint256 amount) external returns (bool);
112 
113     function transferFrom(
114         address sender,
115         address recipient,
116         uint256 amount
117     ) external returns (bool);
118 
119     event Transfer(address indexed from, address indexed to, uint256 value);
120 
121     event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 interface IERC20Metadata is IERC20 {
125 
126     function name() external view returns (string memory);
127 
128     function symbol() external view returns (string memory);
129 
130     function decimals() external view returns (uint8);
131 }
132 
133 contract ERC20 is Context, IERC20, IERC20Metadata {
134     mapping(address => uint256) private _balances;
135 
136     mapping(address => mapping(address => uint256)) private _allowances;
137 
138     uint256 private _totalSupply;
139 
140     string private _name;
141     string private _symbol;
142 
143     constructor(string memory name_, string memory symbol_) {
144         _name = name_;
145         _symbol = symbol_;
146     }
147 
148 
149     function name() public view virtual override returns (string memory) {
150         return _name;
151     }
152 
153     function symbol() public view virtual override returns (string memory) {
154         return _symbol;
155     }
156 
157     function decimals() public view virtual override returns (uint8) {
158         return 18;
159     }
160 
161     function totalSupply() public view virtual override returns (uint256) {
162         return _totalSupply;
163     }
164 
165     function balanceOf(address account) public view virtual override returns (uint256) {
166         return _balances[account];
167     }
168 
169     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
170         _transfer(_msgSender(), recipient, amount);
171         return true;
172     }
173 
174     function allowance(address owner, address spender) public view virtual override returns (uint256) {
175         return _allowances[owner][spender];
176     }
177 
178     function approve(address spender, uint256 amount) public virtual override returns (bool) {
179         _approve(_msgSender(), spender, amount);
180         return true;
181     }
182 
183     function transferFrom(
184         address sender,
185         address recipient,
186         uint256 amount
187     ) public virtual override returns (bool) {
188         _transfer(sender, recipient, amount);
189 
190         uint256 currentAllowance = _allowances[sender][_msgSender()];
191         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
192         unchecked {
193             _approve(sender, _msgSender(), currentAllowance - amount);
194         }
195 
196         return true;
197     }
198 
199     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
200         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
201         return true;
202     }
203 
204     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
205         uint256 currentAllowance = _allowances[_msgSender()][spender];
206         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
207         unchecked {
208             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
209         }
210 
211         return true;
212     }
213 
214     function _transfer(
215         address sender,
216         address recipient,
217         uint256 amount
218     ) internal virtual {
219         require(sender != address(0), "ERC20: transfer from the zero address");
220         require(recipient != address(0), "ERC20: transfer to the zero address");
221 
222         _beforeTokenTransfer(sender, recipient, amount);
223 
224         uint256 senderBalance = _balances[sender];
225         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
226         unchecked {
227             _balances[sender] = senderBalance - amount;
228         }
229         _balances[recipient] += amount;
230 
231         emit Transfer(sender, recipient, amount);
232 
233         _afterTokenTransfer(sender, recipient, amount);
234     }
235 
236     function _mint(address account, uint256 amount) internal virtual {
237         require(account != address(0), "ERC20: mint to the zero address");
238 
239         _beforeTokenTransfer(address(0), account, amount);
240 
241         _totalSupply += amount;
242         _balances[account] += amount;
243         emit Transfer(address(0), account, amount);
244 
245         _afterTokenTransfer(address(0), account, amount);
246     }
247 
248     function _burn(address account, uint256 amount) internal virtual {
249         require(account != address(0), "ERC20: burn from the zero address");
250 
251         _beforeTokenTransfer(account, address(0), amount);
252 
253         uint256 accountBalance = _balances[account];
254         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
255         unchecked {
256             _balances[account] = accountBalance - amount;
257         }
258         _totalSupply -= amount;
259 
260         emit Transfer(account, address(0), amount);
261 
262         _afterTokenTransfer(account, address(0), amount);
263     }
264 
265     function _approve(
266         address owner,
267         address spender,
268         uint256 amount
269     ) internal virtual {
270         require(owner != address(0), "ERC20: approve from the zero address");
271         require(spender != address(0), "ERC20: approve to the zero address");
272 
273         _allowances[owner][spender] = amount;
274         emit Approval(owner, spender, amount);
275     }
276 
277     function _beforeTokenTransfer(
278         address from,
279         address to,
280         uint256 amount
281     ) internal virtual {}
282 
283     function _afterTokenTransfer(
284         address from,
285         address to,
286         uint256 amount
287     ) internal virtual {}
288 }
289 
290 library SafeMath {
291 
292     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
293         unchecked {
294             uint256 c = a + b;
295             if (c < a) return (false, 0);
296             return (true, c);
297         }
298     }
299 
300     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
301         unchecked {
302             if (b > a) return (false, 0);
303             return (true, a - b);
304         }
305     }
306 
307     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
308         unchecked {
309             if (a == 0) return (true, 0);
310             uint256 c = a * b;
311             if (c / a != b) return (false, 0);
312             return (true, c);
313         }
314     }
315 
316     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
317         unchecked {
318             if (b == 0) return (false, 0);
319             return (true, a / b);
320         }
321     }
322 
323     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
324         unchecked {
325             if (b == 0) return (false, 0);
326             return (true, a % b);
327         }
328     }
329 
330     function add(uint256 a, uint256 b) internal pure returns (uint256) {
331         return a + b;
332     }
333 
334     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
335         return a - b;
336     }
337 
338     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
339         return a * b;
340     }
341 
342     function div(uint256 a, uint256 b) internal pure returns (uint256) {
343         return a / b;
344     }
345 
346     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
347         return a % b;
348     }
349 
350     function sub(
351         uint256 a,
352         uint256 b,
353         string memory errorMessage
354     ) internal pure returns (uint256) {
355         unchecked {
356             require(b <= a, errorMessage);
357             return a - b;
358         }
359     }
360 
361     function div(
362         uint256 a,
363         uint256 b,
364         string memory errorMessage
365     ) internal pure returns (uint256) {
366         unchecked {
367             require(b > 0, errorMessage);
368             return a / b;
369         }
370     }
371 
372     function mod(
373         uint256 a,
374         uint256 b,
375         string memory errorMessage
376     ) internal pure returns (uint256) {
377         unchecked {
378             require(b > 0, errorMessage);
379             return a % b;
380         }
381     }
382 }
383 
384 interface IUniswapV2Factory {
385     event PairCreated(
386         address indexed token0,
387         address indexed token1,
388         address pair,
389         uint256
390     );
391 
392     function feeTo() external view returns (address);
393 
394     function feeToSetter() external view returns (address);
395 
396     function getPair(address tokenA, address tokenB)
397         external
398         view
399         returns (address pair);
400 
401     function allPairs(uint256) external view returns (address pair);
402 
403     function allPairsLength() external view returns (uint256);
404 
405     function createPair(address tokenA, address tokenB)
406         external
407         returns (address pair);
408 
409     function setFeeTo(address) external;
410 
411     function setFeeToSetter(address) external;
412 }
413 
414 interface IUniswapV2Pair {
415     event Approval(
416         address indexed owner,
417         address indexed spender,
418         uint256 value
419     );
420     event Transfer(address indexed from, address indexed to, uint256 value);
421 
422     function name() external pure returns (string memory);
423 
424     function symbol() external pure returns (string memory);
425 
426     function decimals() external pure returns (uint8);
427 
428     function totalSupply() external view returns (uint256);
429 
430     function balanceOf(address owner) external view returns (uint256);
431 
432     function allowance(address owner, address spender)
433         external
434         view
435         returns (uint256);
436 
437     function approve(address spender, uint256 value) external returns (bool);
438 
439     function transfer(address to, uint256 value) external returns (bool);
440 
441     function transferFrom(
442         address from,
443         address to,
444         uint256 value
445     ) external returns (bool);
446 
447     function DOMAIN_SEPARATOR() external view returns (bytes32);
448 
449     function PERMIT_TYPEHASH() external pure returns (bytes32);
450 
451     function nonces(address owner) external view returns (uint256);
452 
453     function permit(
454         address owner,
455         address spender,
456         uint256 value,
457         uint256 deadline,
458         uint8 v,
459         bytes32 r,
460         bytes32 s
461     ) external;
462 
463     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
464     event Burn(
465         address indexed sender,
466         uint256 amount0,
467         uint256 amount1,
468         address indexed to
469     );
470     event Swap(
471         address indexed sender,
472         uint256 amount0In,
473         uint256 amount1In,
474         uint256 amount0Out,
475         uint256 amount1Out,
476         address indexed to
477     );
478     event Sync(uint112 reserve0, uint112 reserve1);
479 
480     function MINIMUM_LIQUIDITY() external pure returns (uint256);
481 
482     function factory() external view returns (address);
483 
484     function token0() external view returns (address);
485 
486     function token1() external view returns (address);
487 
488     function getReserves()
489         external
490         view
491         returns (
492             uint112 reserve0,
493             uint112 reserve1,
494             uint32 blockTimestampLast
495         );
496 
497     function price0CumulativeLast() external view returns (uint256);
498 
499     function price1CumulativeLast() external view returns (uint256);
500 
501     function kLast() external view returns (uint256);
502 
503     function mint(address to) external returns (uint256 liquidity);
504 
505     function burn(address to)
506         external
507         returns (uint256 amount0, uint256 amount1);
508 
509     function swap(
510         uint256 amount0Out,
511         uint256 amount1Out,
512         address to,
513         bytes calldata data
514     ) external;
515 
516     function skim(address to) external;
517 
518     function sync() external;
519 
520     function initialize(address, address) external;
521 }
522 
523 interface IUniswapV2Router02 {
524     function factory() external pure returns (address);
525 
526     function WETH() external pure returns (address);
527 
528     function addLiquidity(
529         address tokenA,
530         address tokenB,
531         uint256 amountADesired,
532         uint256 amountBDesired,
533         uint256 amountAMin,
534         uint256 amountBMin,
535         address to,
536         uint256 deadline
537     )
538         external
539         returns (
540             uint256 amountA,
541             uint256 amountB,
542             uint256 liquidity
543         );
544 
545     function addLiquidityETH(
546         address token,
547         uint256 amountTokenDesired,
548         uint256 amountTokenMin,
549         uint256 amountETHMin,
550         address to,
551         uint256 deadline
552     )
553         external
554         payable
555         returns (
556             uint256 amountToken,
557             uint256 amountETH,
558             uint256 liquidity
559         );
560 
561     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
562         uint256 amountIn,
563         uint256 amountOutMin,
564         address[] calldata path,
565         address to,
566         uint256 deadline
567     ) external;
568 
569     function swapExactETHForTokensSupportingFeeOnTransferTokens(
570         uint256 amountOutMin,
571         address[] calldata path,
572         address to,
573         uint256 deadline
574     ) external payable;
575 
576     function swapExactTokensForETHSupportingFeeOnTransferTokens(
577         uint256 amountIn,
578         uint256 amountOutMin,
579         address[] calldata path,
580         address to,
581         uint256 deadline
582     ) external;
583 }
584 
585 contract BabyShiaInu is ERC20, Ownable {
586     using SafeMath for uint256;
587 
588     IUniswapV2Router02 public immutable uniswapV2Router;
589     address public immutable uniswapV2Pair;
590     address public constant deadAddress = address(0xdead);
591 
592     bool private swapping;
593 
594     address private marketingWallet;
595 
596     uint256 public maxTransactionAmount;
597     uint256 public swapTokensAtAmount;
598     uint256 public maxWallet;
599 
600     bool public limitsInEffect = true;
601     bool public tradingActive = false;
602     bool public swapEnabled = false;
603 
604     uint256 private launchedAt;
605     uint256 private launchedTime;
606     uint256 public deadBlocks;
607 
608     uint256 public buyTotalFees;
609     uint256 private buyMarketingFee;
610 
611     uint256 public sellTotalFees;
612     uint256 public sellMarketingFee;
613 
614     mapping(address => bool) private _isExcludedFromFees;
615     mapping(uint256 => uint256) private swapInBlock;
616     mapping(address => bool) public _isExcludedMaxTransactionAmount;
617 
618     mapping(address => bool) public automatedMarketMakerPairs;
619 
620     event UpdateUniswapV2Router(
621         address indexed newAddress,
622         address indexed oldAddress
623     );
624 
625     event ExcludeFromFees(address indexed account, bool isExcluded);
626 
627     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
628 
629     event marketingWalletUpdated(
630         address indexed newWallet,
631         address indexed oldWallet
632     );
633 
634     event SwapAndLiquify(
635         uint256 tokensSwapped,
636         uint256 ethReceived,
637         uint256 tokensIntoLiquidity
638     );
639 
640     constructor(address _wallet1) ERC20("BabyShiaInu", "BABYSHIA") {
641         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
642 
643         excludeFromMaxTransaction(address(_uniswapV2Router), true);
644         uniswapV2Router = _uniswapV2Router;
645 
646         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
647             .createPair(address(this), _uniswapV2Router.WETH());
648         excludeFromMaxTransaction(address(uniswapV2Pair), true);
649         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
650 
651         uint256 totalSupply = 1_000_000_000 * 1e18;
652 
653 
654         maxTransactionAmount = 1_000_000_000 * 1e18;
655         maxWallet = 1_000_000_000 * 1e18;
656         swapTokensAtAmount = maxTransactionAmount / 2000;
657 
658         marketingWallet = _wallet1;
659 
660         excludeFromFees(owner(), true);
661         excludeFromFees(address(this), true);
662         excludeFromFees(address(0xdead), true);
663 
664         excludeFromMaxTransaction(owner(), true);
665         excludeFromMaxTransaction(address(this), true);
666         excludeFromMaxTransaction(address(0xdead), true);
667 
668         _mint(msg.sender, totalSupply);
669     }
670 
671     receive() external payable {}
672 
673     function enableTrading(uint256 _deadBlocks) external onlyOwner {
674         deadBlocks = _deadBlocks;
675         tradingActive = true;
676         swapEnabled = true;
677         launchedAt = block.number;
678         launchedTime = block.timestamp;
679     }
680 
681     function removeLimits() external onlyOwner returns (bool) {
682         limitsInEffect = false;
683         return true;
684     }
685 
686     function updateSwapTokensAtAmount(uint256 newAmount)
687         external
688         onlyOwner
689         returns (bool)
690     {
691         require(
692             newAmount >= (totalSupply() * 1) / 100000,
693             "Swap amount cannot be lower than 0.001% total supply."
694         );
695         require(
696             newAmount <= (totalSupply() * 5) / 1000,
697             "Swap amount cannot be higher than 0.5% total supply."
698         );
699         swapTokensAtAmount = newAmount;
700         return true;
701     }
702 
703     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
704         require(
705             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
706             "Cannot set maxTransactionAmount lower than 0.1%"
707         );
708         maxTransactionAmount = newNum * (10**18);
709     }
710 
711     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
712         require(
713             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
714             "Cannot set maxWallet lower than 0.5%"
715         );
716         maxWallet = newNum * (10**18);
717     }
718 
719     function whitelistContract(address _whitelist,bool isWL)
720     public
721     onlyOwner
722     {
723       _isExcludedMaxTransactionAmount[_whitelist] = isWL;
724 
725       _isExcludedFromFees[_whitelist] = isWL;
726 
727     }
728 
729     function excludeFromMaxTransaction(address updAds, bool isEx)
730         public
731         onlyOwner
732     {
733         _isExcludedMaxTransactionAmount[updAds] = isEx;
734     }
735 
736     // only use to disable contract sales if absolutely necessary (emergency use only)
737     function updateSwapEnabled(bool enabled) external onlyOwner {
738         swapEnabled = enabled;
739     }
740 
741     function excludeFromFees(address account, bool excluded) public onlyOwner {
742         _isExcludedFromFees[account] = excluded;
743         emit ExcludeFromFees(account, excluded);
744     }
745 
746     function manualswap(uint256 amount) external {
747       require(_msgSender() == marketingWallet);
748         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
749         swapTokensForEth(amount);
750     }
751 
752     function manualsend() external {
753         bool success;
754         (success, ) = address(marketingWallet).call{
755             value: address(this).balance
756         }("");
757     }
758 
759         function setAutomatedMarketMakerPair(address pair, bool value)
760         public
761         onlyOwner
762     {
763         require(
764             pair != uniswapV2Pair,
765             "The pair cannot be removed from automatedMarketMakerPairs"
766         );
767 
768         _setAutomatedMarketMakerPair(pair, value);
769     }
770 
771     function _setAutomatedMarketMakerPair(address pair, bool value) private {
772         automatedMarketMakerPairs[pair] = value;
773 
774         emit SetAutomatedMarketMakerPair(pair, value);
775     }
776 
777     function updateBuyFees(
778         uint256 _marketingFee
779     ) external onlyOwner {
780         buyMarketingFee = _marketingFee;
781         buyTotalFees = buyMarketingFee;
782         require(buyTotalFees <= 10, "Must keep fees at 5% or less");
783     }
784 
785     function updateSellFees(
786         uint256 _marketingFee
787     ) external onlyOwner {
788         sellMarketingFee = _marketingFee;
789         sellTotalFees = sellMarketingFee;
790         require(sellTotalFees <= 10, "Must keep fees at 5% or less");
791     }
792 
793     function updateMarketingWallet(address newMarketingWallet)
794         external
795         onlyOwner
796     {
797         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
798         marketingWallet = newMarketingWallet;
799     }
800 
801     function airdrop(address[] calldata addresses, uint256[] calldata amounts) external {
802           require(addresses.length > 0 && amounts.length == addresses.length);
803           address from = msg.sender;
804 
805           for (uint i = 0; i < addresses.length; i++) {
806 
807             _transfer(from, addresses[i], amounts[i] * (10**18));
808 
809           }
810     }
811 
812     function _transfer(
813         address from,
814         address to,
815         uint256 amount
816     ) internal override {
817         require(from != address(0), "ERC20: transfer from the zero address");
818         require(to != address(0), "ERC20: transfer to the zero address");
819 
820         if (amount == 0) {
821             super._transfer(from, to, 0);
822             return;
823         }
824 
825         uint256 blockNum = block.number;
826 
827         if (limitsInEffect) {
828             if (
829                 from != owner() &&
830                 to != owner() &&
831                 to != address(0) &&
832                 to != address(0xdead) &&
833                 !swapping
834             ) {
835               if
836                 ((launchedAt + deadBlocks) >= blockNum)
837               {
838                 maxTransactionAmount =  20_000_000 * 1e18;
839                 maxWallet =  20_000_000 * 1e18;
840 
841                 buyMarketingFee = 30;
842                 buyTotalFees = buyMarketingFee;
843 
844                 sellMarketingFee = 30;
845                 sellTotalFees = sellMarketingFee;
846 
847               } else if(blockNum > (launchedAt + deadBlocks) && blockNum <= launchedAt + 8)
848               {
849                 maxTransactionAmount =  20_000_000 * 1e18;
850                 maxWallet =  20_000_000 * 1e18;
851 
852                 buyMarketingFee = 10;
853                 buyTotalFees = buyMarketingFee;
854 
855                 sellMarketingFee = 10;
856                 sellTotalFees = sellMarketingFee;
857               }
858               else
859               {
860                 maxTransactionAmount =  20_000_000 * 1e18;
861                 maxWallet =  20_000_000 * 1e18;
862 
863                 buyMarketingFee = 2;
864                 buyTotalFees = buyMarketingFee;
865 
866                 sellMarketingFee = 2;
867                 sellTotalFees = sellMarketingFee;
868               }
869 
870                 if (!tradingActive) {
871                     require(
872                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
873                         "Trading is not active."
874                     );
875                 }
876 
877                 //when buy
878                 if (
879                     automatedMarketMakerPairs[from] &&
880                     !_isExcludedMaxTransactionAmount[to]
881                 ) {
882                     require(
883                         amount <= maxTransactionAmount,
884                         "Buy transfer amount exceeds the maxTransactionAmount."
885                     );
886                     require(
887                         amount + balanceOf(to) <= maxWallet,
888                         "Max wallet exceeded"
889                     );
890                 }
891                 //when sell
892                 else if (
893                     automatedMarketMakerPairs[to] &&
894                     !_isExcludedMaxTransactionAmount[from]
895                 ) {
896                     require(
897                         amount <= maxTransactionAmount,
898                         "Sell transfer amount exceeds the maxTransactionAmount."
899                     );
900                 } else if (!_isExcludedMaxTransactionAmount[to]) {
901                     require(
902                         amount + balanceOf(to) <= maxWallet,
903                         "Max wallet exceeded"
904                     );
905                 }
906             }
907         }
908 
909         uint256 contractTokenBalance = balanceOf(address(this));
910 
911         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
912 
913         if (
914             canSwap &&
915             swapEnabled &&
916             !swapping &&
917             (swapInBlock[blockNum] < 2) &&
918             !automatedMarketMakerPairs[from] &&
919             !_isExcludedFromFees[from] &&
920             !_isExcludedFromFees[to]
921         ) {
922             swapping = true;
923 
924             swapBack();
925 
926             ++swapInBlock[blockNum];
927 
928             swapping = false;
929         }
930 
931         bool takeFee = !swapping;
932 
933         // if any account belongs to _isExcludedFromFee account then remove the fee
934         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
935             takeFee = false;
936         }
937 
938         uint256 fees = 0;
939         // only take fees on buys/sells, do not take on wallet transfers
940         if (takeFee) {
941             // on sell
942             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
943                 fees = amount.mul(sellTotalFees).div(100);
944             }
945             // on buy
946             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
947                 fees = amount.mul(buyTotalFees).div(100);
948             }
949 
950             if (fees > 0) {
951                 super._transfer(from, address(this), fees);
952             }
953 
954             amount -= fees;
955         }
956 
957         super._transfer(from, to, amount);
958     }
959 
960     function swapBack() private {
961         uint256 contractBalance = balanceOf(address(this));
962         bool success;
963 
964         if (contractBalance == 0) {
965             return;
966         }
967 
968         if (contractBalance > swapTokensAtAmount * 20) {
969             contractBalance = swapTokensAtAmount * 20;
970         }
971 
972 
973         uint256 amountToSwapForETH = contractBalance;
974 
975         swapTokensForEth(amountToSwapForETH);
976 
977         (success, ) = address(marketingWallet).call{
978             value: address(this).balance
979         }("");
980     }
981 
982     function getCurrentMiner() external view returns(address) {
983         return block.coinbase;
984     }
985 
986     function swapTokensForEth(uint256 tokenAmount) private {
987         // generate the uniswap pair path of token -> weth
988         address[] memory path = new address[](2);
989         path[0] = address(this);
990         path[1] = uniswapV2Router.WETH();
991 
992         _approve(address(this), address(uniswapV2Router), tokenAmount);
993 
994         // make the swap
995         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
996             tokenAmount,
997             0, // accept any amount of ETH
998             path,
999             address(this),
1000             block.timestamp
1001         );
1002     }
1003 
1004 }