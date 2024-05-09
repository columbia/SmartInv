1 // SETH by Spacebar (@mrspcbr) | https://t.me/soyboyseth | https://twitter.com/soyboyseth
2 // SPDX-License-Identifier: MIT
3 pragma solidity 0.8.17;
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
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18     constructor() {
19         _transferOwnership(_msgSender());
20     }
21     modifier onlyOwner() {
22         _checkOwner();
23         _;
24     }
25     function owner() public view virtual returns (address) {
26         return _owner;
27     }
28     function _checkOwner() internal view virtual {
29         require(owner() == _msgSender(), "Ownable: caller is not the owner");
30     }
31     function renounceOwnership() public virtual onlyOwner {
32         _transferOwnership(address(0));
33     }
34     function transferOwnership(address newOwner) public virtual onlyOwner {
35         require(newOwner != address(0), "Ownable: new owner is the zero address");
36         _transferOwnership(newOwner);
37     }
38     function _transferOwnership(address newOwner) internal virtual {
39         address oldOwner = _owner;
40         _owner = newOwner;
41         emit OwnershipTransferred(oldOwner, newOwner);
42     }
43 }
44 
45 interface IERC20 {
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48     function totalSupply() external view returns (uint256);
49     function balanceOf(address account) external view returns (uint256);
50     function transfer(address to, uint256 amount) external returns (bool);
51     function allowance(address owner, address spender) external view returns (uint256);
52     function approve(address spender, uint256 amount) external returns (bool);
53     function transferFrom(
54         address from,
55         address to,
56         uint256 amount
57     ) external returns (bool);
58 }
59 
60 interface IERC20Metadata is IERC20 {
61     function name() external view returns (string memory);
62     function symbol() external view returns (string memory);
63     function decimals() external view returns (uint8);
64 }
65 
66 contract ERC20 is Context, IERC20, IERC20Metadata {
67     mapping(address => uint256) private _balances;
68     mapping(address => mapping(address => uint256)) private _allowances;
69     uint256 private _totalSupply;
70     string private _name;
71     string private _symbol;
72     constructor(string memory name_, string memory symbol_) {
73         _name = name_;
74         _symbol = symbol_;
75     }
76     function name() public view virtual override returns (string memory) {
77         return _name;
78     }
79     function symbol() public view virtual override returns (string memory) {
80         return _symbol;
81     }
82     function decimals() public view virtual override returns (uint8) {
83         return 18;
84     }
85     function totalSupply() public view virtual override returns (uint256) {
86         return _totalSupply;
87     }
88     function balanceOf(address account) public view virtual override returns (uint256) {
89         return _balances[account];
90     }
91     function transfer(address to, uint256 amount) public virtual override returns (bool) {
92         address owner = _msgSender();
93         _transfer(owner, to, amount);
94         return true;
95     }
96     function allowance(address owner, address spender) public view virtual override returns (uint256) {
97         return _allowances[owner][spender];
98     }
99     function approve(address spender, uint256 amount) public virtual override returns (bool) {
100         address owner = _msgSender();
101         _approve(owner, spender, amount);
102         return true;
103     }
104     function transferFrom(
105         address from,
106         address to,
107         uint256 amount
108     ) public virtual override returns (bool) {
109         address spender = _msgSender();
110         _spendAllowance(from, spender, amount);
111         _transfer(from, to, amount);
112         return true;
113     }
114     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
115         address owner = _msgSender();
116         _approve(owner, spender, allowance(owner, spender) + addedValue);
117         return true;
118     }
119     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
120         address owner = _msgSender();
121         uint256 currentAllowance = allowance(owner, spender);
122         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
123         unchecked {
124             _approve(owner, spender, currentAllowance - subtractedValue);
125         }
126         return true;
127     }
128     function _transfer(
129         address from,
130         address to,
131         uint256 amount
132     ) internal virtual {
133         require(from != address(0), "ERC20: transfer from the zero address");
134         require(to != address(0), "ERC20: transfer to the zero address");
135         _beforeTokenTransfer(from, to, amount);
136         uint256 fromBalance = _balances[from];
137         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
138         unchecked {
139             _balances[from] = fromBalance - amount;
140         }
141         _balances[to] += amount;
142         emit Transfer(from, to, amount);
143         _afterTokenTransfer(from, to, amount);
144     }
145     function _mint(address account, uint256 amount) internal virtual {
146         require(account != address(0), "ERC20: mint to the zero address");
147         _beforeTokenTransfer(address(0), account, amount);
148         _totalSupply += amount;
149         _balances[account] += amount;
150         emit Transfer(address(0), account, amount);
151         _afterTokenTransfer(address(0), account, amount);
152     }
153     function _burn(address account, uint256 amount) internal virtual {
154         require(account != address(0), "ERC20: burn from the zero address");
155         _beforeTokenTransfer(account, address(0), amount);
156         uint256 accountBalance = _balances[account];
157         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
158         unchecked {
159             _balances[account] = accountBalance - amount;
160         }
161         _totalSupply -= amount;
162         emit Transfer(account, address(0), amount);
163         _afterTokenTransfer(account, address(0), amount);
164     }
165     function _approve(
166         address owner,
167         address spender,
168         uint256 amount
169     ) internal virtual {
170         require(owner != address(0), "ERC20: approve from the zero address");
171         require(spender != address(0), "ERC20: approve to the zero address");
172         _allowances[owner][spender] = amount;
173         emit Approval(owner, spender, amount);
174     }
175     function _spendAllowance(
176         address owner,
177         address spender,
178         uint256 amount
179     ) internal virtual {
180         uint256 currentAllowance = allowance(owner, spender);
181         if (currentAllowance != type(uint256).max) {
182             require(currentAllowance >= amount, "ERC20: insufficient allowance");
183             unchecked {
184                 _approve(owner, spender, currentAllowance - amount);
185             }
186         }
187     }
188     function _beforeTokenTransfer(
189         address from,
190         address to,
191         uint256 amount
192     ) internal virtual {}
193     function _afterTokenTransfer(
194         address from,
195         address to,
196         uint256 amount
197     ) internal virtual {}
198 }
199 
200 library SafeMath {
201     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
202         unchecked {
203             uint256 c = a + b;
204             if (c < a) return (false, 0);
205             return (true, c);
206         }
207     }
208     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
209         unchecked {
210             if (b > a) return (false, 0);
211             return (true, a - b);
212         }
213     }
214     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
215         unchecked {
216             if (a == 0) return (true, 0);
217             uint256 c = a * b;
218             if (c / a != b) return (false, 0);
219             return (true, c);
220         }
221     }
222     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
223         unchecked {
224             if (b == 0) return (false, 0);
225             return (true, a / b);
226         }
227     }
228     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
229         unchecked {
230             if (b == 0) return (false, 0);
231             return (true, a % b);
232         }
233     }
234     function add(uint256 a, uint256 b) internal pure returns (uint256) {
235         return a + b;
236     }
237     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
238         return a - b;
239     }
240     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
241         return a * b;
242     }
243     function div(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a / b;
245     }
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return a % b;
248     }
249     function sub(
250         uint256 a,
251         uint256 b,
252         string memory errorMessage
253     ) internal pure returns (uint256) {
254         unchecked {
255             require(b <= a, errorMessage);
256             return a - b;
257         }
258     }
259     function div(
260         uint256 a,
261         uint256 b,
262         string memory errorMessage
263     ) internal pure returns (uint256) {
264         unchecked {
265             require(b > 0, errorMessage);
266             return a / b;
267         }
268     }
269     function mod(
270         uint256 a,
271         uint256 b,
272         string memory errorMessage
273     ) internal pure returns (uint256) {
274         unchecked {
275             require(b > 0, errorMessage);
276             return a % b;
277         }
278     }
279 }
280 
281 interface IUniswapV2Pair {
282     event Approval(address indexed owner, address indexed spender, uint256 value);
283     event Transfer(address indexed from, address indexed to, uint256 value);
284     function name() external pure returns (string memory);
285     function symbol() external pure returns (string memory);
286     function decimals() external pure returns (uint8);
287     function totalSupply() external view returns (uint256);
288     function balanceOf(address owner) external view returns (uint256);
289     function allowance(address owner, address spender) external view returns (uint256);
290     function approve(address spender, uint256 value) external returns (bool);
291     function transfer(address to, uint256 value) external returns (bool);
292     function transferFrom(address from, address to, uint256 value) external returns (bool);
293     function DOMAIN_SEPARATOR() external view returns (bytes32);
294     function PERMIT_TYPEHASH() external pure returns (bytes32);
295     function nonces(address owner) external view returns (uint256);
296     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
297     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
298     event Sync(uint112 reserve0, uint112 reserve1);
299     function MINIMUM_LIQUIDITY() external pure returns (uint256);
300     function factory() external view returns (address);
301     function token0() external view returns (address);
302     function token1() external view returns (address);
303     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
304     function price0CumulativeLast() external view returns (uint256);
305     function price1CumulativeLast() external view returns (uint256);
306     function kLast() external view returns (uint256);
307     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
308     function skim(address to) external;
309     function sync() external;
310     function initialize(address, address) external;
311 }
312 
313 interface IUniswapV2Factory {
314     function createPair(address tokenA, address tokenB) external returns (address pair);
315 }
316 
317 interface IUniswapV2Router01 {
318     function factory() external pure returns (address);
319     function WETH() external pure returns (address);
320     function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired,
321                           uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline)
322                           external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
323     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin,
324                              uint256 amountETHMin, address to, uint256 deadline)
325                              external payable returns (uint256 amountToken, uint256 amountETH,
326                              uint256 liquidity);
327     function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin,
328                              uint256 amountBMin, address to, uint256 deadline) 
329                              external returns (uint256 amountA, uint256 amountB);
330     function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin,
331                                 uint256 amountETHMin, address to, uint256 deadline) 
332                                 external returns (uint256 amountToken, uint256 amountETH);
333     function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity,
334                                        uint256 amountAMin, uint256 amountBMin, address to,
335                                        uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) 
336                                        external returns (uint256 amountA, uint256 amountB);
337     function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin,
338                                           uint256 amountETHMin, address to, uint256 deadline,
339                                           bool approveMax, uint8 v, bytes32 r, bytes32 s) 
340                                           external returns (uint256 amountToken, uint256 amountETH);
341     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
342                                       address to, uint256 deadline) 
343                                       external returns (uint256[] memory amounts);
344     function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path,
345                                       address to, uint256 deadline) 
346                                       external returns (uint256[] memory amounts);
347     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to,
348                                    uint256 deadline) 
349                                    external payable returns (uint256[] memory amounts);
350     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path,
351                                    address to, uint256 deadline) 
352                                    external returns (uint256[] memory amounts);
353     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
354                                    address to, uint256 deadline) 
355                                    external returns (uint256[] memory amounts);
356     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to,
357                                    uint256 deadline) 
358                                    external payable returns (uint256[] memory amounts);
359     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) 
360                    external pure returns (uint256 amountB);
361     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) 
362                           external pure returns (uint256 amountOut);
363     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) 
364                          external pure returns (uint256 amountIn);
365     function getAmountsOut(uint256 amountIn, address[] calldata path)
366                            external view returns (uint256[] memory amounts);
367     function getAmountsIn(uint256 amountOut, address[] calldata path)
368                           external view returns (uint256[] memory amounts);
369 }
370 
371 interface IUniswapV2Router02 is IUniswapV2Router01 {
372     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity,
373         uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) 
374         external returns (uint256 amountETH);
375     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity,
376         uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax,
377         uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH);
378     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin,
379         address[] calldata path, address to, uint256 deadline) external;
380     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin,
381         address[] calldata path, address to, uint256 deadline) external payable;
382     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin,
383         address[] calldata path, address to, uint256 deadline) external;
384 }
385 
386 contract SETH is ERC20, Ownable { 
387     using SafeMath for uint256;
388     IUniswapV2Router02 public uniswapV2Router;
389 
390     address public uniswapV2Pair;
391     address public DEAD = 0x000000000000000000000000000000000000dEaD;
392     bool private swapping;
393     bool public tradingEnabled = false;
394 
395     uint256 internal sellAmount = 1;
396     uint256 internal buyAmount = 1;
397 
398     uint256 private totalSellFees;
399     uint256 private totalBuyFees;
400 
401     address payable public marketingWallet; 
402 
403     uint256 public maxWallet;
404     bool public maxWalletEnabled = true;    
405     uint256 public swapTokensAtAmount;
406     uint256 public sellMarketingFees;
407     uint256 public buyMarketingFees;
408     bool public swapAndLiquifyEnabled = true;
409 
410     mapping(address => bool) private _isExcludedFromFees;
411     mapping(address => bool) public automatedMarketMakerPairs;
412     mapping(address => bool) private canTransferBeforeTradingIsEnabled;
413 
414     bool public limitsInEffect = true; 
415     mapping(address => uint256) private _holderLastTransferBlock; // FOR 1TX PER BLOCK
416     mapping(address => uint256) private _holderLastTransferTimestamp; // FOR COOLDOWN
417     uint256 public launchblock; // FOR DEADBLOCKS
418     uint256 private deadblocks;
419     uint256 public launchtimestamp; 
420     uint256 public cooldowntimer = 60; //COOLDOWN TIMER
421 
422     event EnableSwapAndLiquify(bool enabled);
423     event updateMarketingWallet(address wallet);
424     event updateDevWallet(address wallet);
425     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
426     event TradingEnabled();
427 
428     event UpdateFees(uint256 sellMarketingFees, uint256 buyMarketingFees);
429 
430     event ExcludeFromFees(address indexed account, bool isExcluded);
431     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
432     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived);
433     event SendDividends(uint256 opAmount, bool success);
434 
435     constructor() ERC20("SETH", "SETH") { 
436         marketingWallet = payable(0xf430eb562f9EC9dceBAfffc7c66fAa6bd2000000); 
437         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; 
438         
439         buyMarketingFees = 0;
440         sellMarketingFees = 4;
441 
442         totalBuyFees = buyMarketingFees;
443         totalSellFees = sellMarketingFees;
444 
445         uniswapV2Router = IUniswapV2Router02(router);
446         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
447                 address(this), uniswapV2Router.WETH());
448 
449         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
450 
451         _isExcludedFromFees[address(this)] = true;
452         _isExcludedFromFees[msg.sender] = true;
453         _isExcludedFromFees[marketingWallet] = true;
454 
455         // TOTAL SUPPLY IS SET HERE
456         uint _totalSupply = 100_000_000_000_000 ether;
457         _mint(owner(), _totalSupply); // only time internal mint function is ever called is to create supply
458         maxWallet = 1_000_000_000_000 * (10**18); // 1%
459         swapTokensAtAmount = _totalSupply / 1000;
460         canTransferBeforeTradingIsEnabled[owner()] = true;
461         canTransferBeforeTradingIsEnabled[address(this)] = true;
462     }
463 
464     receive() external payable {}
465 
466     function enableTrading(uint256 setdeadblocks) external onlyOwner {
467         require(!tradingEnabled);
468         tradingEnabled = true;
469         launchblock = block.number;
470         launchtimestamp = block.timestamp;
471         deadblocks = setdeadblocks;
472         emit TradingEnabled();
473     }
474     
475     function setMarketingWallet(address wallet) external onlyOwner {
476         _isExcludedFromFees[wallet] = true;
477         marketingWallet = payable(wallet);
478         emit updateMarketingWallet(wallet);
479     }
480 
481     function setMaxWalletEnabled(bool value) external onlyOwner {
482         maxWalletEnabled = value;
483     }    
484     
485     function setExcludeFees(address account, bool excluded) public onlyOwner {
486         _isExcludedFromFees[account] = excluded;
487         emit ExcludeFromFees(account, excluded);
488     }
489 
490     function setCanTransferBeforeTradingIsEnabled(address account, bool excluded) public onlyOwner {
491         canTransferBeforeTradingIsEnabled[account] = excluded;
492     }
493 
494     function setLimitsInEffect(bool value) external onlyOwner {
495         limitsInEffect = value;
496     }  
497     
498     function sweep() external onlyOwner {
499         uint256 amountETH = address(this).balance;
500         payable(msg.sender).transfer(amountETH);
501     }
502 
503     function setSwapTriggerAmount(uint256 amount) public onlyOwner {
504         swapTokensAtAmount = amount * (10**18);
505     }
506 
507     function enableSwapAndLiquify(bool enabled) public onlyOwner {
508         require(swapAndLiquifyEnabled != enabled);
509         swapAndLiquifyEnabled = enabled;
510         emit EnableSwapAndLiquify(enabled);
511     }
512 
513     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
514         _setAutomatedMarketMakerPair(pair, value);
515     }
516 
517     function _setAutomatedMarketMakerPair(address pair, bool value) private {
518         automatedMarketMakerPairs[pair] = value;
519 
520         emit SetAutomatedMarketMakerPair(pair, value);
521     }
522 
523     function updateFees(uint256 marketingBuy, uint256 marketingSell) public onlyOwner {
524 
525         buyMarketingFees = marketingBuy;
526         sellMarketingFees = marketingSell;
527 
528         totalSellFees = sellMarketingFees;
529         totalBuyFees = buyMarketingFees;
530 
531         require(totalSellFees <= 10 && totalBuyFees <= 5, "total fees cannot be higher than 5% buys 10% sells");
532 
533         emit UpdateFees(sellMarketingFees, buyMarketingFees);
534     }
535 
536     function isExcludedFromFees(address account) public view returns (bool) {
537         return _isExcludedFromFees[account];
538     }
539 
540     function _transfer(address from, address to, uint256 amount) internal override {
541 
542         require(from != address(0), "IERC20: transfer from the zero address");
543         require(to != address(0), "IERC20: transfer to the zero address");
544         require(amount > 0, "Transfer amount must be greater than zero");
545 
546         uint256 marketingFees;
547 
548         if (!canTransferBeforeTradingIsEnabled[from]) {
549             require(tradingEnabled, "Trading has not yet been enabled");          
550         }
551 
552         if (to == DEAD) {
553             _burn(from, amount);
554             return;
555         }
556         
557         else if (
558             !swapping && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
559             bool isSelling = automatedMarketMakerPairs[to];
560             bool isBuying = automatedMarketMakerPairs[from];            
561             
562             if (!isBuying && !isSelling) {
563                 super._transfer(from, to, amount);
564                 return;
565             }            
566             
567             else if (isSelling) {
568                 marketingFees = sellMarketingFees;
569 
570                 if (limitsInEffect) {
571                 require(block.timestamp >= _holderLastTransferTimestamp[tx.origin] + cooldowntimer,
572                         "One Sell Per 60 Seconds");
573                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
574                 }
575             } 
576             
577             else if (isBuying) {
578                 marketingFees = buyMarketingFees;
579 
580                 if (limitsInEffect) {
581                 require(block.number > launchblock + deadblocks,"Bought Too Fast");
582                 require(_holderLastTransferBlock[tx.origin] != block.number,"One Buy per block");
583                 _holderLastTransferBlock[tx.origin] = block.number;
584             }
585 
586             if (maxWalletEnabled) {
587             uint256 contractBalanceRecipient = balanceOf(to);
588             require(contractBalanceRecipient + amount <= maxWallet,
589                     "Exceeds maximum wallet" );
590             }
591             }
592 
593             uint256 totalFees = marketingFees;
594 
595             uint256 contractTokenBalance = balanceOf(address(this));
596 
597             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
598 
599             if (canSwap && isSelling) {
600                 swapping = true;
601              
602                 if (swapAndLiquifyEnabled && marketingFees > 0 && totalBuyFees > 0) {
603                     uint256 totalBuySell = buyAmount.add(sellAmount);
604                     uint256 swapAmountBought = contractTokenBalance
605                         .mul(buyAmount)
606                         .div(totalBuySell);
607                     uint256 swapAmountSold = contractTokenBalance
608                         .mul(sellAmount)
609                         .div(totalBuySell);
610 
611                     uint256 swapBuyTokens = swapAmountBought
612                         .mul(marketingFees)
613                         .div(totalBuyFees);
614 
615                     uint256 swapSellTokens = swapAmountSold
616                         .mul(marketingFees)
617                         .div(totalSellFees);
618 
619                     uint256 swapTokens = swapSellTokens.add(swapBuyTokens);
620 
621                     swapAndLiquify(swapTokens);
622                 }                
623                 
624                 
625                 uint256 swapBalance = balanceOf(address(this));
626                 swapAndSendDividends(swapBalance);
627                 buyAmount = 0;
628                 sellAmount = 0;
629                 swapping = false;
630             }
631 
632             uint256 fees = amount.mul(totalFees).div(100);
633 
634             amount = amount.sub(fees);
635 
636             if (isSelling) {
637                 sellAmount = sellAmount.add(fees);
638             } else {
639                 buyAmount = buyAmount.add(fees);
640             }
641 
642             super._transfer(from, address(this), fees);
643             
644         }
645 
646         super._transfer(from, to, amount);
647     }
648 
649     function swapAndLiquify(uint256 tokens) private {
650         uint256 half = tokens;
651         uint256 initialBalance = address(this).balance;
652         swapTokensForEth(half); // <- this breaks the ETH -> when swap+liquify is triggered
653         uint256 newBalance = address(this).balance.sub(initialBalance);
654         emit SwapAndLiquify(half, newBalance);
655     }
656 
657     function swapTokensForEth(uint256 tokenAmount) private {
658         address[] memory path = new address[](2);
659         path[0] = address(this);
660         path[1] = uniswapV2Router.WETH();
661         _approve(address(this), address(uniswapV2Router), tokenAmount);
662         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
663             tokenAmount,
664             0, // accept any amount of ETH
665             path,
666             address(this),
667             block.timestamp
668         );
669     }
670 
671     function forceSwapAndSendDividends(uint256 tokens) public onlyOwner {
672         tokens = tokens * (10**18);
673         uint256 totalAmount = buyAmount.add(sellAmount);
674         uint256 fromBuy = tokens.mul(buyAmount).div(totalAmount);
675         uint256 fromSell = tokens.mul(sellAmount).div(totalAmount);
676 
677         swapAndSendDividends(tokens);
678 
679         buyAmount = buyAmount.sub(fromBuy);
680         sellAmount = sellAmount.sub(fromSell);
681     }
682 
683     // TAX PAYOUT CODE 
684     function swapAndSendDividends(uint256 tokens) private {
685         if (tokens == 0) {
686             return;
687         }
688         swapTokensForEth(tokens);
689 
690         bool success = true;
691         bool successOp1 = true;
692         
693         uint256 _completeFees = sellMarketingFees + buyMarketingFees;
694 
695         uint256 feePortions;
696         if (_completeFees > 0) {
697             feePortions = address(this).balance.div(_completeFees);
698         }
699         uint256 marketingPayout = buyMarketingFees.add(sellMarketingFees) * feePortions;
700         
701         if (marketingPayout > 0) {
702             (success, ) = address(marketingWallet).call{value: marketingPayout}("");
703         }
704 
705         emit SendDividends(
706             marketingPayout,
707             success && successOp1
708         );
709     }
710 }