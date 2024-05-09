1 /*
2 
3 https://www.odung.com/
4 
5 https://twitter.com/odungETH
6 
7 https://t.me/odungportal
8 
9 */
10 
11 
12 pragma solidity ^0.8.17;
13 //SPDX-License-Identifier: Unlicensed
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; 
22         return msg.data;
23     }
24 }
25 
26 interface IUniswapV2Pair {
27     event Approval(address indexed owner, address indexed spender, uint value);
28     event Transfer(address indexed from, address indexed to, uint value);
29 
30     function name() external pure returns (string memory);
31 
32     function symbol() external pure returns (string memory);
33     function decimals() external pure returns (uint8);
34     function totalSupply() external view returns (uint);
35     function balanceOf(address owner) external view returns (uint);
36     function allowance(address owner, address spender) external view returns (uint);
37 
38     function approve(address spender, uint value) external returns (bool);
39     function transfer(address to, uint value) external returns (bool);
40     function transferFrom(address from, address to, uint value) external returns (bool);
41 
42     function DOMAIN_SEPARATOR() external view returns (bytes32);
43     function PERMIT_TYPEHASH() external pure returns (bytes32);
44     function nonces(address owner) external view returns (uint);
45 
46     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
47 
48     event Mint(address indexed sender, uint amount0, uint amount1);
49     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
50     event Swap(
51         address indexed sender,
52         uint amount0In,
53         uint amount1In,
54         uint amount0Out,
55         uint amount1Out,
56         address indexed to
57     );
58     event Sync(uint112 reserve0, uint112 reserve1);
59 
60     function MINIMUM_LIQUIDITY() external pure returns (uint);
61 
62     function factory() external view returns (address);
63     function token0() external view returns (address);
64     function token1() external view returns (address);
65     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
66     function price0CumulativeLast() external view returns (uint);
67     function price1CumulativeLast() external view returns (uint);
68 
69     function kLast() external view returns (uint);
70 
71     function mint(address to) external returns (uint liquidity);
72     function burn(address to) external returns (uint amount0, uint amount1);
73     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
74     function skim(address to) external;
75     function sync() external;
76 
77     function initialize(address, address) external;
78 }
79 
80 interface IUniswapV2Factory {
81     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
82 
83     function feeTo() external view returns (address);
84     function feeToSetter() external view returns (address);
85 
86     function getPair(address tokenA, address tokenB) external view returns (address pair);
87     function allPairs(uint) external view returns (address pair);
88     function allPairsLength() external view returns (uint);
89 
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 
92     function setFeeTo(address) external;
93     function setFeeToSetter(address) external;
94 }
95 interface IERC20 {
96     
97     function totalSupply() external view returns (uint256);
98 
99     
100     function balanceOf(address account) external view returns (uint256);
101 
102     
103     function transfer(address recipient, uint256 amount) external returns (bool);
104 
105     
106     function allowance(address owner, address spender) external view returns (uint256);
107 
108     
109       function approve(address spender, uint256 amount) external returns (bool);
110 
111   
112     function transferFrom(
113         address sender,
114         address recipient,
115         uint256 amount
116 
117     ) external returns (bool);
118 
119     
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 
122     
123     event Approval(address indexed owner, address indexed spender, uint256 value);
124 
125 }
126 
127 interface IERC20Metadata is IERC20 {
128     
129      function name() external view returns (string memory);
130 
131     
132     function symbol() external view returns (string memory);
133 
134    
135     function decimals() external view returns (uint8);
136 }
137 
138 
139 contract ERC20 is Context, IERC20, IERC20Metadata {
140     using SafeMath for uint256;
141 
142     mapping(address => uint256) private _balances;
143 
144     mapping(address => mapping(address => uint256)) private _allowances;
145 
146     uint256 private _totalSupply;
147 
148     string private _name;
149     string private _symbol;
150 
151     
152     constructor(string memory name_, string memory symbol_) {
153         _name = name_;
154         _symbol = symbol_;
155     }
156 
157     
158     function name() public view virtual override returns (string memory) {
159         return _name;
160     }
161 
162     
163     function symbol() public view virtual override returns (string memory) {
164         return _symbol;
165 
166     }
167     
168     function decimals() public view virtual override returns (uint8) {
169         return 9;
170     }
171 
172 
173     
174     function totalSupply() public view virtual override returns (uint256) {
175         return _totalSupply;
176     }
177 
178    
179     function balanceOf(address account) public view virtual override returns (uint256) {
180         return _balances[account];
181     }
182 
183     
184     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     
190     function allowance(address owner, address spender) public view virtual override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     
195     function approve(address spender, uint256 amount) public virtual override returns (bool) {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function transferFrom(
201         address sender,
202         address recipient,
203         uint256 amount
204     ) public virtual override returns (bool) {
205         _transfer(sender, recipient, amount);
206         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
207         return true;
208     }
209    
210     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
211         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
212         return true;
213 
214     }
215 
216     
217     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
218         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
219         return true;
220 
221     }
222 
223     
224     function _transfer(
225         address sender,
226         address recipient,
227         uint256 amount
228         ) internal virtual {
229         require(sender != address(0), "ERC20: transfer from the zero address");
230         require(recipient != address(0), "ERC20: transfer to the zero address");
231 
232         _beforeTokenTransfer(sender, recipient, amount);
233 
234         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
235         _balances[recipient] = _balances[recipient].add(amount);
236         emit Transfer(sender, recipient, amount);
237     }
238 
239 
240    
241     function _mint(address account, uint256 amount) internal virtual {
242         require(account != address(0), "ERC20: mint to the zero address");
243 
244         _beforeTokenTransfer(address(0), account, amount);
245 
246         _totalSupply = _totalSupply.add(amount);
247         _balances[account] = _balances[account].add(amount);
248         emit Transfer(address(0), account, amount);
249     }
250 
251     
252     function _burn(address account, uint256 amount) internal virtual {
253         require(account != address(0), "ERC20: burn from the zero address");
254  _beforeTokenTransfer(account, address(0), amount);
255 
256         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
257         _totalSupply = _totalSupply.sub(amount);
258         emit Transfer(account, address(0), amount);
259     }
260 
261 
262     
263     function _approve(
264         address owner,
265         address spender,
266         uint256 amount
267     ) internal virtual {
268         require(owner != address(0), "ERC20: approve from the zero address");
269         require(spender != address(0), "ERC20: approve to the zero address");
270 
271 
272         _allowances[owner][spender] = amount;
273         emit Approval(owner, spender, amount);
274     }
275 
276     
277     function _beforeTokenTransfer(
278         address from,
279         address to,
280         uint256 amount
281     ) internal virtual {}
282 
283 }
284 
285 library SafeMath {
286     
287     function add(uint256 a, uint256 b) internal pure returns (uint256) {
288         uint256 c = a + b;
289         require(c >= a, "SafeMath: addition overflow");
290 
291         return c;
292     }
293 
294     
295     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
296         return sub(a, b, "SafeMath: subtraction overflow");
297     }
298 
299 
300     
301     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b <= a, errorMessage);
303         uint256 c = a - b;
304 
305         return c;
306     }
307 
308    
309     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
310         
311         if (a == 0) {
312             return 0;
313         }
314          uint256 c = a * b;
315         require(c / a == b, "SafeMath: multiplication overflow");
316 
317         return c;
318     }
319 
320     
321     function div(uint256 a, uint256 b) internal pure returns (uint256) {
322         return div(a, b, "SafeMath: division by zero");
323     }
324 
325     
326     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
327         require(b > 0, errorMessage);
328         uint256 c = a / b;
329        
330         return c;
331     }
332 
333 
334     
335     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
336         return mod(a, b, "SafeMath: modulo by zero");
337     }
338      
339     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
340         require(b != 0, errorMessage);
341 
342         return a % b;
343     }
344 }
345 
346 contract Ownable is Context {
347     address private _owner;
348 
349     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
350     
351     
352     constructor () {
353         address msgSender = _msgSender();
354         _owner = msgSender;
355         emit OwnershipTransferred(address(0), msgSender);
356     }
357 
358     
359     function owner() public view returns (address) {
360         return _owner;
361     }
362 
363     
364     
365     modifier onlyOwner() {
366         require(_owner == _msgSender(), "Ownable: caller is not the owner");
367         _;
368     }
369 
370     
371     function renounceOwnership() public virtual onlyOwner {
372         emit OwnershipTransferred(_owner, address(0));
373         _owner = address(0);
374     }
375    
376 
377     function transferOwnership(address newOwner) public virtual onlyOwner {
378         require(newOwner != address(0), "Ownable: new owner is the zero address");
379         emit OwnershipTransferred(_owner, newOwner);
380 
381         _owner = newOwner;
382     }
383 }
384 
385 
386 
387 library SafeMathInt {
388     int256 private constant MIN_INT256 = int256(1) << 255;
389     int256 private constant MAX_INT256 = ~(int256(1) << 255);
390 
391    
392     function mul(int256 a, int256 b) internal pure returns (int256) {
393         int256 c = a * b;
394 
395         
396         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
397         require((b == 0) || (c / b == a));
398         return c;
399     }
400 
401     
402     function div(int256 a, int256 b) internal pure returns (int256) {
403         
404         require(b != -1 || a != MIN_INT256);
405 
406 
407         return a / b;
408     }
409 
410     
411     function sub(int256 a, int256 b) internal pure returns (int256) {
412         int256 c = a - b;
413         require((b >= 0 && c <= a) || (b < 0 && c > a));
414         return c;
415     }
416 
417     
418     function add(int256 a, int256 b) internal pure returns (int256) {
419         int256 c = a + b;
420         require((b >= 0 && c >= a) || (b < 0 && c < a));
421         return c;
422     }
423    
424     function abs(int256 a) internal pure returns (int256) {
425         require(a != MIN_INT256);
426 
427         return a < 0 ? -a : a;
428     }
429 
430 
431     function toUint256Safe(int256 a) internal pure returns (uint256) {
432         require(a >= 0);
433         return uint256(a);
434     }
435 }
436 
437 library SafeMathUint {
438   function toInt256Safe(uint256 a) internal pure returns (int256) {
439     int256 b = int256(a);
440     require(b >= 0);
441     return b;
442   }
443 }
444 
445 
446 interface IUniswapV2Router01 {
447     function factory() external pure returns (address);
448     function WETH() external pure returns (address);
449 
450     function addLiquidity(
451         address tokenA,
452         address tokenB,
453         uint amountADesired,
454         uint amountBDesired,
455         uint amountAMin,
456 
457         uint amountBMin,
458         address to,
459         uint deadline
460     ) external returns (uint amountA, uint amountB, uint liquidity);
461     function addLiquidityETH(
462         address token,
463         uint amountTokenDesired,
464         uint amountTokenMin,
465         uint amountETHMin,
466         address to,
467         uint deadline
468     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
469     function removeLiquidity(
470         address tokenA,
471         address tokenB,
472         uint liquidity,
473         uint amountAMin,
474         uint amountBMin,
475         address to,
476         uint deadline
477     ) external returns (uint amountA, uint amountB);
478      function removeLiquidityETH(
479         address token,
480         uint liquidity,
481         uint amountTokenMin,
482         uint amountETHMin,
483         address to,
484         uint deadline
485     ) external returns (uint amountToken, uint amountETH);
486     function removeLiquidityWithPermit(
487         address tokenA,
488         address tokenB,
489         uint liquidity,
490         uint amountAMin,
491         uint amountBMin,
492         address to,
493         uint deadline,
494         bool approveMax, uint8 v, bytes32 r, bytes32 s
495     ) external returns (uint amountA, uint amountB);
496     function removeLiquidityETHWithPermit(
497         address token,
498         uint liquidity,
499         uint amountTokenMin,
500         uint amountETHMin,
501         address to,
502         uint deadline,
503         bool approveMax, uint8 v, bytes32 r, bytes32 s
504     ) external returns (uint amountToken, uint amountETH);
505     function swapExactTokensForTokens(
506         uint amountIn,
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510 
511         uint deadline
512     ) external returns (uint[] memory amounts);
513     function swapTokensForExactTokens(
514         uint amountOut,
515         uint amountInMax,
516         address[] calldata path,
517 
518         address to,
519         uint deadline
520     ) external returns (uint[] memory amounts);
521     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
522         external
523         payable
524         returns (uint[] memory amounts);
525     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
526         external
527         returns (uint[] memory amounts);
528     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
529         external
530         returns (uint[] memory amounts);
531          function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
532         external
533         payable
534         returns (uint[] memory amounts);
535 
536     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
537     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
538     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
539     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
540     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
541 }
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
552     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
553         address token,
554         uint liquidity,
555         uint amountTokenMin,
556         uint amountETHMin,
557         address to,
558         uint deadline,
559         bool approveMax, uint8 v, bytes32 r, bytes32 s
560     ) external returns (uint amountETH);
561 
562     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
563         uint amountIn,
564         uint amountOutMin,
565         address[] calldata path,
566         address to,
567         uint deadline
568     ) external;
569     function swapExactETHForTokensSupportingFeeOnTransferTokens(
570         uint amountOutMin,
571         address[] calldata path,
572         address to,
573         uint deadline
574     ) external payable;
575     function swapExactTokensForETHSupportingFeeOnTransferTokens(
576         uint amountIn,
577 
578         uint amountOutMin,
579         address[] calldata path,
580         address to,
581 
582         uint deadline
583     ) external;
584 }
585 contract ODung is ERC20, Ownable {
586     using SafeMath for uint256;
587 
588     IUniswapV2Router02 public immutable uniswapV2Router;
589     address public immutable uniswapV2Pair;
590     address public constant deadAddress = address(0xdead);
591 
592     bool private swapping;
593 
594     address public deployerAddress;
595     address public marketingWallet;
596     address public lpLocker;
597     
598     uint256 public maxTransactionAmount;
599     uint256 public swapTokensAtAmount;
600     uint256 public maxWallet;
601 
602     bool public swapEnabled = true;
603 
604     uint256 public buyTotalFees;
605     uint256 public buyMarketingFee;
606     uint256 public buyLiquidityFee;
607     uint256 public buyBurnFee;
608     
609     uint256 public sellTotalFees;
610     uint256 public sellMarketingFee;
611     uint256 public sellLiquidityFee;
612     uint256 public sellBurnFee;
613     
614     uint256 public tokensForMarketing;
615     uint256 public tokensForLiquidity;
616     uint256 public tokensForBurn;
617     
618     /******************/
619 
620    
621     mapping (address => bool) private _isExcludedFromFees;
622     mapping (address => bool) public _isExcludedMaxTransactionAmount;
623 
624   
625     mapping (address => bool) public automatedMarketMakerPairs;
626 
627     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
628 
629     event ExcludeFromFees(address indexed account, bool isExcluded);
630 
631 
632     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
633 
634     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
635     event SwapAndLiquify(
636         uint256 tokensSwapped,
637         uint256 ethReceived,
638         uint256 tokensIntoLiquidity
639     );
640 
641     event BuyBackTriggered(uint256 amount);
642 
643     constructor() ERC20("ODung", "ODUNG") {
644 
645         address newOwner = address(owner());
646         
647         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
648         
649         excludeFromMaxTransaction(address(_uniswapV2Router), true);
650         uniswapV2Router = _uniswapV2Router;
651         
652         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
653         excludeFromMaxTransaction(address(uniswapV2Pair), true);
654         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
655         
656         uint256 _buyMarketingFee = 30;
657         uint256 _buyLiquidityFee = 0;
658         uint256  _buyBurnFee = 0;
659 
660     
661         uint256 _sellMarketingFee = 60;
662         uint256 _sellLiquidityFee = 0;
663         uint256 _sellBurnFee = 0;
664         
665         uint256 totalSupply = 1 * 1e9 * 1e9;
666         
667         maxTransactionAmount = totalSupply * 1 / 100; 
668         swapTokensAtAmount = totalSupply * 5 / 10000; 
669         maxWallet = totalSupply * 2 / 100; 
670 
671         buyMarketingFee = _buyMarketingFee;
672         buyLiquidityFee = _buyLiquidityFee;
673         buyBurnFee = _buyBurnFee;
674         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
675         
676         sellMarketingFee = _sellMarketingFee;
677         sellLiquidityFee = _sellLiquidityFee;
678         sellBurnFee = _sellBurnFee;
679         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
680         
681         deployerAddress = address(0x0218712dD1Eb73516a8A10F7D1111559a20e86b7); 
682     	marketingWallet = address(0x3059385244F53D9229d3a6e7710c7B46438C4fb6); 
683         lpLocker = address(0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214); 
684 
685         
686         excludeFromFees(newOwner, true); 
687         excludeFromFees(address(this), true);
688         excludeFromFees(address(0xdead), true); 
689         excludeFromFees(marketingWallet, true); 
690         excludeFromFees(lpLocker, true); 
691         excludeFromFees(deployerAddress, true); 
692         
693         excludeFromMaxTransaction(newOwner, true); 
694         excludeFromMaxTransaction(address(this), true); 
695         excludeFromMaxTransaction(address(0xdead), true);
696         excludeFromMaxTransaction(marketingWallet, true); 
697         excludeFromMaxTransaction(lpLocker, true);
698         excludeFromMaxTransaction(deployerAddress, true); 
699 
700         
701         /*
702             _mint is an internal function in ERC20.sol that is only called here,
703             and CANNOT be called ever again
704         */
705         _mint(newOwner, totalSupply);
706 
707         transferOwnership(newOwner);
708     }
709 
710     receive() external payable {
711 
712   	}
713 
714      
715     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
716   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
717   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
718   	    swapTokensAtAmount = newAmount;
719   	    return true;
720   	}
721     
722     function updateMaxAmount(uint256 newNum) external onlyOwner {
723         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxTransactionAmount lower than 0.5%");
724         maxTransactionAmount = newNum * (10**18);
725     }
726     
727     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
728         _isExcludedMaxTransactionAmount[updAds] = isEx;
729     }
730     
731     
732     function updateSwapEnabled(bool enabled) external onlyOwner(){
733 
734         swapEnabled = enabled;
735     }
736 
737     
738     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
739         buyMarketingFee = _marketingFee;
740         buyLiquidityFee = _liquidityFee;
741         buyBurnFee = _burnFee;
742         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
743         require(buyTotalFees <= 40, "Must keep fees at 40% or less");
744     }
745      function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
746         sellMarketingFee = _marketingFee;
747         sellLiquidityFee = _liquidityFee;
748         sellBurnFee = _burnFee;
749         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
750         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
751     
752     }
753 
754      function removeLimits() external onlyOwner {
755             maxTransactionAmount = totalSupply();
756             maxWallet = totalSupply();
757         }
758 
759     function excludeFromFees(address account, bool excluded) public onlyOwner {
760         _isExcludedFromFees[account] = excluded;
761         emit ExcludeFromFees(account, excluded);
762     }
763 
764     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
765         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
766 
767         _setAutomatedMarketMakerPair(pair, value);
768     }
769 
770     function _setAutomatedMarketMakerPair(address pair, bool value) private {
771         automatedMarketMakerPairs[pair] = value;
772 
773         emit SetAutomatedMarketMakerPair(pair, value);
774     }
775 
776     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
777         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
778         marketingWallet = newMarketingWallet;
779     }
780 
781     function isExcludedFromFees(address account) public view returns(bool) {
782         return _isExcludedFromFees[account];
783 
784     }
785 
786     function _transfer(
787         address from,
788         address to,
789         uint256 amount
790     ) internal override {
791         require(from != address(0), "ERC20: transfer from the zero address");
792         require(to != address(0), "ERC20: transfer to the zero address");
793         
794          if(amount == 0) {
795             super._transfer(from, to, 0);
796             return;
797         }
798         
799 
800             if (
801                 from != owner() &&
802                 to != owner() &&
803                 to != address(0) &&
804                 to != address(0xdead) &&
805                 !swapping
806             ){
807                  
808                 //when buy
809                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
810                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
811                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
812 
813                 }
814                 
815                 //when sell
816                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
817                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
818                 }
819                 else if (!_isExcludedMaxTransactionAmount[to]){
820                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
821                 }
822 
823             }
824         
825         
826         
827         
828 		uint256 contractTokenBalance = balanceOf(address(this));
829         
830         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
831 
832         if( 
833             canSwap &&
834             swapEnabled &&
835             !swapping &&
836             !automatedMarketMakerPairs[from] &&
837             !_isExcludedFromFees[from] &&
838             !_isExcludedFromFees[to]
839         ) {
840             swapping = true;
841             
842             swapBack();
843 
844             swapping = false;
845         }
846         
847         bool takeFee = !swapping;
848 
849         
850         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
851 
852             takeFee = false;
853         }
854         
855         uint256 fees = 0;
856         // only take fees on buys/sells, do not take on wallet transfers
857         if(takeFee){
858             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
859                 fees = amount.mul(sellTotalFees).div(100);
860                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
861                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
862                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
863             }
864               // on buy
865             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
866         	    fees = amount.mul(buyTotalFees).div(100);
867         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
868                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
869                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
870             }
871             
872             if(fees > 0){    
873 
874                 super._transfer(from, address(this), (fees - tokensForBurn));
875             }
876 
877             if(tokensForBurn > 0){
878                 super._transfer(from, deadAddress, tokensForBurn);
879                 tokensForBurn = 0;
880             }
881         	
882         	amount -= fees;
883         }
884 
885         super._transfer(from, to, amount);
886     }
887 
888     function swapTokensForEth(uint256 tokenAmount) private {
889 
890         // generate the uniswap pair path of token -> weth
891         address[] memory path = new address[](2);
892         path[0] = address(this);
893         path[1] = uniswapV2Router.WETH();
894 
895         _approve(address(this), address(uniswapV2Router), tokenAmount);
896 
897         // make the swap
898         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
899             tokenAmount,
900             0, 
901             path,
902             address(this),
903             block.timestamp
904         );
905         
906     }
907     
908     
909     
910     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
911         
912 
913         _approve(address(this), address(uniswapV2Router), tokenAmount);
914 
915         
916         uniswapV2Router.addLiquidityETH{value: ethAmount}(
917             address(this),
918             tokenAmount,
919             0, 
920             0, 
921             deadAddress,
922             block.timestamp
923         );
924 
925     }
926 
927     function swapBack() private {
928         uint256 contractBalance = balanceOf(address(this));
929         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
930         
931         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
932         
933         
934         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
935         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
936         
937         uint256 initialETHBalance = address(this).balance;
938 
939         swapTokensForEth(amountToSwapForETH); 
940         
941         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
942         
943         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
944         
945         
946         uint256 ethForLiquidity = ethBalance - ethForMarketing;
947         tokensForLiquidity = 0;
948         tokensForMarketing = 0;
949         
950         (bool success,) = address(marketingWallet).call{value: ethForMarketing}("");
951         if(liquidityTokens > 0 && ethForLiquidity > 0){
952 
953             addLiquidity(liquidityTokens, ethForLiquidity);
954             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
955         }
956         
957         
958         (success,) = address(marketingWallet).call{value: address(this).balance}("");
959     }
960     
961 }