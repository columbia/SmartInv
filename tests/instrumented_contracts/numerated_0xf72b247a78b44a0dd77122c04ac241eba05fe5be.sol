1 /*
2        
3 ANYTHING U WANT TO TYPE ABOUT PROJECT GOES HERE
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity ^0.8.13;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes memory) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 library SafeMath {
22     
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52 
53     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         return c;
57     }
58 
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         return mod(a, b, "SafeMath: modulo by zero");
61     }
62 
63     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b != 0, errorMessage);
65         return a % b;
66     }
67 }
68 
69 interface IBEP20 {
70     function totalSupply() external view returns (uint256);
71     function balanceOf(address account) external view returns (uint256);
72     function transfer(address recipient, uint256 amount) external returns (bool); 
73     function allowance(address owner, address spender) external view returns (uint256);
74     function approve(address spender, uint256 amount) external returns (bool);
75     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 interface IBEP20Metadata is IBEP20 {
81     function name() external view returns (string memory);
82     function symbol() external view returns (string memory);
83     function decimals() external view returns (uint8);
84 }
85 
86 contract BEP20 is Context, IBEP20, IBEP20Metadata {
87     using SafeMath for uint256;
88     mapping(address => uint256) private _balances;
89     mapping(address => mapping(address => uint256)) private _allowances;
90     uint256 internal _totalSupply;
91     string private _name;
92     string private _symbol;
93 
94     constructor(string memory name_, string memory symbol_) {
95         _name = name_;
96         _symbol = symbol_;
97     }
98 
99     function name() public view virtual override returns (string memory) {
100         return _name;
101     }
102 
103     function symbol() public view virtual override returns (string memory) {
104         return _symbol;
105     }
106 
107     function decimals() public view virtual override returns (uint8) {
108         return 18;
109     }
110 
111     function totalSupply() public view virtual override returns (uint256) {
112         return _totalSupply;
113     }
114 
115     function balanceOf(address account) public view virtual override returns (uint256) {
116         return _balances[account];
117     }
118 
119     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
120         _transfer(_msgSender(), recipient, amount);
121         return true;
122     }
123 
124     function allowance(address owner, address spender) public view virtual override returns (uint256) {
125         return _allowances[owner][spender];
126     }
127 
128     function approve(address spender, uint256 amount) public virtual override returns (bool) {
129         _approve(_msgSender(), spender, amount);
130         return true;
131     }
132 
133     function transferFrom(address sender, address recipient, uint256 amount 
134     ) public virtual override returns (bool) {
135         _transfer(sender, recipient, amount);
136         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,
137                 "BEP20: transfer amount exceeds allowance"));
138         return true;
139     }
140 
141     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
142         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
143         return true;
144     }
145 
146     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
147         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue,
148                 "BEP20: decreased allowance below zero"));
149         return true;
150     }
151 
152     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
153         require(sender != address(0), "BEP20: transfer from the zero address");
154         require(recipient != address(0), "BEP20: transfer to the zero address");
155 
156         _beforeTokenTransfer(sender, recipient, amount);
157 
158         _balances[sender] = _balances[sender].sub(amount,"BEP20: transfer amount exceeds balance");
159         _balances[recipient] = _balances[recipient].add(amount);
160         emit Transfer(sender, recipient, amount);
161     }
162 
163     function _mint(address account, uint256 amount) internal virtual {
164         require(account != address(0), "BEP20: mint to the zero address");
165 
166         _beforeTokenTransfer(address(0), account, amount);
167 
168         _totalSupply = _totalSupply.add(amount);
169         _balances[account] = _balances[account].add(amount);
170         emit Transfer(address(0), account, amount);
171     }
172 
173     function _approve(address owner, address spender, uint256 amount) internal virtual {
174         require(owner != address(0), "BEP20: approve from the zero address");
175         require(spender != address(0), "BEP20: approve to the zero address");
176 
177         _allowances[owner][spender] = amount;
178         emit Approval(owner, spender, amount);
179     }
180 
181     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
182 }
183 
184 abstract contract Ownable is Context {
185 
186     address private _owner;
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190     constructor() {
191         address msgSender = _msgSender();
192         _owner = msgSender;
193         emit OwnershipTransferred(address(0), msgSender);
194     }
195 
196     function owner() public view returns (address) {
197         return _owner;
198     }
199 
200     modifier onlyOwner() {
201         require(_owner == _msgSender(), "Ownable: caller is not the owner");
202         _;
203     }
204 
205     function renounceOwnership() public virtual onlyOwner {
206         emit OwnershipTransferred(_owner, address(0));
207         _owner = address(0);
208     }
209 
210     function transferOwnership(address newOwner) public virtual onlyOwner {
211         require(newOwner != address(0), "Ownable: new owner is the zero address");
212         emit OwnershipTransferred(_owner, newOwner);
213         _owner = newOwner;
214     }
215 }
216 
217 interface IUniswapV2Pair {
218     event Approval(address indexed owner, address indexed spender, uint256 value);
219     event Transfer(address indexed from, address indexed to, uint256 value);
220     function name() external pure returns (string memory);
221     function symbol() external pure returns (string memory);
222     function decimals() external pure returns (uint8);
223     function totalSupply() external view returns (uint256);
224     function balanceOf(address owner) external view returns (uint256);
225     function allowance(address owner, address spender) external view returns (uint256);
226     function approve(address spender, uint256 value) external returns (bool);
227     function transfer(address to, uint256 value) external returns (bool);
228     function transferFrom(address from, address to, uint256 value) external returns (bool);
229     function DOMAIN_SEPARATOR() external view returns (bytes32);
230     function PERMIT_TYPEHASH() external pure returns (bytes32);
231     function nonces(address owner) external view returns (uint256);
232 
233     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r,
234                     bytes32 s) external;
235 
236     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out,
237                uint256 amount1Out, address indexed to);
238     event Sync(uint112 reserve0, uint112 reserve1);
239 
240     function MINIMUM_LIQUIDITY() external pure returns (uint256);
241     function factory() external view returns (address);
242     function token0() external view returns (address);
243     function token1() external view returns (address);
244     function getReserves() external view returns (uint112 reserve0, uint112 reserve1,
245                                                   uint32 blockTimestampLast);
246 
247     function price0CumulativeLast() external view returns (uint256);
248     function price1CumulativeLast() external view returns (uint256);
249     function kLast() external view returns (uint256);
250 
251     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
252 
253     function skim(address to) external;
254     function sync() external;
255     function initialize(address, address) external;
256 }
257 
258 interface IUniswapV2Factory {
259     function createPair(address tokenA, address tokenB) external returns (address pair);
260 }
261 
262 interface IUniswapV2Router01 {
263     function factory() external pure returns (address);
264     function WETH() external pure returns (address);
265 
266     function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired,
267                           uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline)
268                           external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
269 
270     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin,
271                              uint256 amountETHMin, address to, uint256 deadline)
272                              external payable returns (uint256 amountToken, uint256 amountETH,
273                              uint256 liquidity);
274 
275     function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin,
276                              uint256 amountBMin, address to, uint256 deadline) 
277                              external returns (uint256 amountA, uint256 amountB);
278 
279     function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin,
280                                 uint256 amountETHMin, address to, uint256 deadline) 
281                                 external returns (uint256 amountToken, uint256 amountETH);
282 
283     function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity,
284                                        uint256 amountAMin, uint256 amountBMin, address to,
285                                        uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) 
286                                        external returns (uint256 amountA, uint256 amountB);
287 
288     function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin,
289                                           uint256 amountETHMin, address to, uint256 deadline,
290                                           bool approveMax, uint8 v, bytes32 r, bytes32 s) 
291                                           external returns (uint256 amountToken, uint256 amountETH);
292 
293     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
294                                       address to, uint256 deadline) 
295                                       external returns (uint256[] memory amounts);
296 
297     function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path,
298                                       address to, uint256 deadline) 
299                                       external returns (uint256[] memory amounts);
300 
301     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to,
302                                    uint256 deadline) 
303                                    external payable returns (uint256[] memory amounts);
304 
305     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path,
306                                    address to, uint256 deadline) 
307                                    external returns (uint256[] memory amounts);
308 
309     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
310                                    address to, uint256 deadline) 
311                                    external returns (uint256[] memory amounts);
312 
313     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to,
314                                    uint256 deadline) 
315                                    external payable returns (uint256[] memory amounts);
316 
317     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) 
318                    external pure returns (uint256 amountB);
319 
320     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) 
321                           external pure returns (uint256 amountOut);
322 
323     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) 
324                          external pure returns (uint256 amountIn);
325 
326     function getAmountsOut(uint256 amountIn, address[] calldata path)
327                            external view returns (uint256[] memory amounts);
328 
329     function getAmountsIn(uint256 amountOut, address[] calldata path)
330                           external view returns (uint256[] memory amounts);
331 }
332 
333 interface IUniswapV2Router02 is IUniswapV2Router01 {
334     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity,
335         uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) 
336         external returns (uint256 amountETH);
337 
338     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity,
339         uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax,
340         uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH);
341 
342     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin,
343         address[] calldata path, address to, uint256 deadline) external;
344 
345     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin,
346         address[] calldata path, address to, uint256 deadline) external payable;
347 
348     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin,
349         address[] calldata path, address to, uint256 deadline) external;
350 }
351 
352 contract GMfinal is BEP20, Ownable { // CONTRACT NAME FOR YOUR CUSTOM CONTRACT
353     using SafeMath for uint256;
354 
355     IUniswapV2Router02 public uniswapV2Router;
356 
357     address public uniswapV2Pair;
358     bool private swapping;
359     bool public tradingEnabled = false;
360 
361     uint256 public sellAmount = 0;
362     uint256 public buyAmount = 0;
363 
364     uint256 private totalSellFees;
365     uint256 private totalBuyFees;
366 
367     address payable public marketingWallet;
368     address payable public devWallet;
369 
370     uint256 public maxWallet;
371     bool public maxWalletEnabled = true;
372     uint256 public swapTokensAtAmount;
373     uint256 public sellMarketingFees;
374     uint256 public sellLiquidityFee;
375     uint256 public buyMarketingFees;
376     uint256 public buyLiquidityFee;
377     uint256 public buyDevFee;
378     uint256 public sellDevFee;
379 
380     bool public swapAndLiquifyEnabled = true;
381 
382     mapping(address => bool) private _isExcludedFromFees;
383     mapping(address => bool) public automatedMarketMakerPairs;
384     mapping(address => bool) private canTransferBeforeTradingIsEnabled;
385 
386     bool public limitsInEffect = false; 
387     uint256 private gasPriceLimit = 7 * 1 gwei; // MAX GWEI
388     mapping(address => uint256) private _holderLastTransferBlock; // FOR 1TX PER BLOCK
389     mapping(address => uint256) private _holderLastTransferTimestamp; // FOR COOLDOWN
390     uint256 public launchblock; // FOR DEADBLOCKS
391     uint256 public launchtimestamp; // FOR LAUNCH TIMESTAMP 
392     uint256 public cooldowntimer = 0; // DEFAULT COOLDOWN TIMER
393 
394     event EnableSwapAndLiquify(bool enabled);
395     event SetPreSaleWallet(address wallet);
396     event updateMarketingWallet(address wallet);
397     event updateDevWallet(address wallet);
398     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
399     event TradingEnabled();
400 
401     event UpdateFees(uint256 sellMarketingFees, uint256 sellLiquidityFee, uint256 buyMarketingFees,
402                      uint256 buyLiquidityFee, uint256 buyDevFee, uint256 sellDevFee);
403 
404     event Airdrop(address holder, uint256 amount);
405     event ExcludeFromFees(address indexed account, bool isExcluded);
406     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
407     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
408     event SendDividends(uint256 opAmount, bool success);
409 
410     constructor() BEP20("GemInu", "GMI") { // PROJECTNAME AND TICKER GO HERE
411         marketingWallet = payable(0xbF670880A16990B8aCa7CF3191Fe4479b918d3B0); // CHANGE THIS TO YOURS
412         devWallet = payable(0x816ACFF9ad6ccAfCD3B90C977edaA105ECae806C); // CHANGE THIS TO YOURS
413         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
414 
415         //INITIAL FEE VALUES HERE
416         buyMarketingFees = 4;
417         sellMarketingFees = 4;
418         buyLiquidityFee = 0;
419         sellLiquidityFee = 0;
420         buyDevFee = 1;
421         sellDevFee = 1;
422 
423         // TOTAL BUY AND TOTAL SELL FEE CALCS
424         totalBuyFees = buyMarketingFees.add(buyLiquidityFee).add(buyDevFee);
425         totalSellFees = sellMarketingFees.add(sellLiquidityFee).add(sellDevFee);
426 
427         uniswapV2Router = IUniswapV2Router02(router);
428         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
429                 address(this), uniswapV2Router.WETH());
430 
431         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
432 
433         _isExcludedFromFees[address(this)] = true;
434         _isExcludedFromFees[msg.sender] = true;
435         _isExcludedFromFees[marketingWallet] = true;
436 
437         uint256 _totalSupply = (1_000_000_000) * (10**18); // TOTAL SUPPLY IS SET HERE
438         _mint(owner(), _totalSupply); // only time internal mint function is ever called is to create supply
439         maxWallet = _totalSupply / 50; // 2%
440         swapTokensAtAmount = _totalSupply / 100; // 1%;
441         canTransferBeforeTradingIsEnabled[owner()] = true;
442         canTransferBeforeTradingIsEnabled[address(this)] = true;
443     }
444 
445     function decimals() public view virtual override returns (uint8) {
446         return 18;
447     }
448 
449     receive() external payable {}
450 
451     function enableTrading() external onlyOwner {
452         require(!tradingEnabled);
453         tradingEnabled = true;
454         launchblock = block.number;
455         launchtimestamp = block.timestamp;
456         emit TradingEnabled();
457     }
458     
459     function setMarketingWallet(address wallet) external onlyOwner {
460         _isExcludedFromFees[wallet] = true;
461         marketingWallet = payable(wallet);
462         emit updateMarketingWallet(wallet);
463     }
464 
465     function setDevWallet(address wallet) external onlyOwner {
466         _isExcludedFromFees[wallet] = true;
467         devWallet = payable(wallet);
468         emit updateDevWallet(wallet);
469     }
470     
471     function setExcludeFees(address account, bool excluded) public onlyOwner {
472         _isExcludedFromFees[account] = excluded;
473         emit ExcludeFromFees(account, excluded);
474     }
475 
476     function setCanTransferBefore(address wallet, bool enable) external onlyOwner {
477         canTransferBeforeTradingIsEnabled[wallet] = enable;
478     }
479 
480     function setLimitsInEffect(bool value) external onlyOwner {
481         limitsInEffect = value;
482     }
483 
484     function setMaxWalletEnabled(bool value) external onlyOwner {
485         maxWalletEnabled = value;
486     }
487 
488     function setcooldowntimer(uint256 value) external onlyOwner {
489         require(value <= 300, "cooldown timer cannot exceed 5 minutes");
490         cooldowntimer = value;
491     }
492 
493     
494     function setmaxWallet(uint256 value) external onlyOwner {
495         value = value * (10**18);
496         require(value >= _totalSupply / 100, "max wallet cannot be set to less than 1%");
497         maxWallet = value;
498     }
499 
500     // TAKES ALL BNB FROM THE CONTRACT ADDRESS AND SENDS IT TO OWNERS WALLET
501     function Sweep() external onlyOwner {
502         uint256 amountBNB = address(this).balance;
503         payable(msg.sender).transfer(amountBNB);
504     }
505 
506     function setSwapTriggerAmount(uint256 amount) public onlyOwner {
507         swapTokensAtAmount = amount * (10**18);
508     }
509 
510     function enableSwapAndLiquify(bool enabled) public onlyOwner {
511         require(swapAndLiquifyEnabled != enabled);
512         swapAndLiquifyEnabled = enabled;
513         emit EnableSwapAndLiquify(enabled);
514     }
515 
516     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
517         _setAutomatedMarketMakerPair(pair, value);
518     }
519 
520     function _setAutomatedMarketMakerPair(address pair, bool value) private {
521         automatedMarketMakerPairs[pair] = value;
522 
523         emit SetAutomatedMarketMakerPair(pair, value);
524     }
525 
526     // THIS IS THE ONE YOU USE TO TRASNFER OWNER IF U EVER DO
527     function transferAdmin(address newOwner) public onlyOwner {
528         _isExcludedFromFees[newOwner] = true;
529         canTransferBeforeTradingIsEnabled[newOwner] = true;
530         transferOwnership(newOwner);
531     }
532 
533     function updateFees(uint256 marketingBuy, uint256 marketingSell, uint256 liquidityBuy,
534                         uint256 liquiditySell, uint256 devBuy, uint256 devSell) public onlyOwner {
535 
536         buyMarketingFees = marketingBuy;
537         buyLiquidityFee = liquidityBuy;
538         sellMarketingFees = marketingSell;
539         sellLiquidityFee = liquiditySell;
540         buyDevFee = devBuy;
541         sellDevFee = devSell;
542 
543         totalSellFees = sellMarketingFees.add(sellLiquidityFee).add(sellDevFee);
544         totalBuyFees = buyMarketingFees.add(buyLiquidityFee).add(buyDevFee);
545 
546         // ABSOLUTE TAX LIMITS GO HERE
547         require(totalSellFees <= 99 && totalBuyFees <= 99, "total fees cannot be higher than 15%");
548 
549         emit UpdateFees(sellMarketingFees, sellLiquidityFee, sellDevFee, buyMarketingFees,
550                         buyLiquidityFee, buyDevFee);
551     }
552 
553     function isExcludedFromFees(address account) public view returns (bool) {
554         return _isExcludedFromFees[account];
555     }
556 
557     function _transfer(address from, address to, uint256 amount) internal override {
558 
559         require(from != address(0), "IBEP20: transfer from the zero address");
560         require(to != address(0), "IBEP20: transfer to the zero address");
561 
562         uint256 marketingFees;
563         uint256 liquidityFee;
564         uint256 devFee;
565 
566         if (!canTransferBeforeTradingIsEnabled[from]) {
567             require(tradingEnabled, "Trading has not yet been enabled");          
568         }
569 
570         if (amount == 0) {
571             super._transfer(from, to, 0);
572             return;
573         } 
574         
575         else if (
576             !swapping && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]
577         ) {
578             bool isSelling = automatedMarketMakerPairs[to];
579             if (isSelling) {
580                 marketingFees = sellMarketingFees;
581                 liquidityFee = sellLiquidityFee;
582                 devFee = sellDevFee;
583 
584                 if (limitsInEffect) {
585                 require(block.timestamp >= _holderLastTransferTimestamp[tx.origin] + cooldowntimer,
586                         "cooldown period active");
587                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
588                 }
589             } 
590             
591             else {
592                 marketingFees = buyMarketingFees;
593                 liquidityFee = buyLiquidityFee;
594                 devFee = buyDevFee;
595 
596                 if (limitsInEffect) {
597                 require(block.number > launchblock + 2,"you shall not pass");
598                 require(tx.gasprice <= gasPriceLimit,"Gas price exceeds limit.");
599                 require(_holderLastTransferBlock[tx.origin] != block.number,"Too many TX in block");
600                 require(block.timestamp >= _holderLastTransferTimestamp[tx.origin] + cooldowntimer,
601                         "cooldown period active");
602                 _holderLastTransferBlock[tx.origin] = block.number;
603                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
604             }
605 
606             if (maxWalletEnabled) {
607             uint256 contractBalanceRecipient = balanceOf(to);
608             require(contractBalanceRecipient + amount <= maxWallet,
609                     "Exceeds maximum wallet token amount." );
610             }
611             }
612 
613             uint256 totalFees = marketingFees.add(liquidityFee).add(devFee);
614 
615             uint256 contractTokenBalance = balanceOf(address(this));
616 
617             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
618 
619             if (canSwap && !automatedMarketMakerPairs[from]) {
620                 swapping = true;
621 
622                 uint256 swapTokens;
623 
624                 if (swapAndLiquifyEnabled && liquidityFee > 0) {
625                     uint256 totalBuySell = buyAmount.add(sellAmount);
626                     uint256 swapAmountBought = contractTokenBalance
627                         .mul(buyAmount)
628                         .div(totalBuySell);
629                     uint256 swapAmountSold = contractTokenBalance
630                         .mul(sellAmount)
631                         .div(totalBuySell);
632 
633                     uint256 swapBuyTokens = swapAmountBought
634                         .mul(liquidityFee)
635                         .div(totalBuyFees);
636 
637                     uint256 swapSellTokens = swapAmountSold
638                         .mul(liquidityFee)
639                         .div(totalSellFees);
640 
641                     swapTokens = swapSellTokens.add(swapBuyTokens);
642 
643                     swapAndLiquify(swapTokens);
644                 }
645 
646                 uint256 remainingBalance = swapTokensAtAmount.sub(swapTokens);
647                 swapAndSendDividends(remainingBalance);
648                 buyAmount = 0;
649                 sellAmount = 0;
650                 swapping = false;
651             }
652 
653             uint256 fees = amount.mul(totalFees).div(100);
654 
655             amount = amount.sub(fees);
656 
657             if (isSelling) {
658                 sellAmount = sellAmount.add(fees);
659             } else {
660                 buyAmount = buyAmount.add(fees);
661             }
662 
663             super._transfer(from, address(this), fees);
664            
665         }
666 
667         super._transfer(from, to, amount);
668         
669     }
670 
671 
672     function swapAndLiquify(uint256 tokens) private {
673         uint256 half = tokens.div(2);
674         uint256 otherHalf = tokens.sub(half);
675         uint256 initialBalance = address(this).balance;
676         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
677         uint256 newBalance = address(this).balance.sub(initialBalance);
678         addLiquidity(otherHalf, newBalance);
679         emit SwapAndLiquify(half, newBalance, otherHalf);
680     }
681 
682     function swapTokensForEth(uint256 tokenAmount) private {
683         address[] memory path = new address[](2);
684         path[0] = address(this);
685         path[1] = uniswapV2Router.WETH();
686         _approve(address(this), address(uniswapV2Router), tokenAmount);
687         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
688             tokenAmount,
689             0, // accept any amount of ETH
690             path,
691             address(this),
692             block.timestamp
693         );
694     }
695 
696     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
697         // approve token transfer to cover all possible scenarios
698         _approve(address(this), address(uniswapV2Router), tokenAmount);
699 
700         // add the liquidity
701         uniswapV2Router.addLiquidityETH{value: ethAmount}(
702             address(this),
703             tokenAmount,
704             0, // slippage is unavoidable
705             0, // slippage is unavoidable
706             owner(),
707             block.timestamp
708         );
709     }
710 
711     function forceSwapAndSendDividends(uint256 tokens) public onlyOwner {
712         tokens = tokens * (10**18);
713         uint256 totalAmount = buyAmount.add(sellAmount);
714         uint256 fromBuy = tokens.mul(buyAmount).div(totalAmount);
715         uint256 fromSell = tokens.mul(sellAmount).div(totalAmount);
716 
717         swapAndSendDividends(tokens);
718 
719         buyAmount = buyAmount.sub(fromBuy);
720         sellAmount = sellAmount.sub(fromSell);
721     }
722 
723     // TAX PAYOUT CODE 
724     function swapAndSendDividends(uint256 tokens) private {
725         if (tokens == 0) {
726             return;
727         }
728         swapTokensForEth(tokens);
729 
730         bool success = true;
731         bool successOp1 = true;
732         
733         uint256 _marketDevTotal = sellMarketingFees.add(sellDevFee) + buyMarketingFees.add(buyDevFee);
734 
735         uint256 feePortions;
736         if (_marketDevTotal > 0) {
737             feePortions = address(this).balance.div(_marketDevTotal);
738         }
739         uint256 marketingPayout = buyMarketingFees.add(sellMarketingFees) * feePortions;
740         uint256 devPayout = buyDevFee.add(sellDevFee) * feePortions;
741         
742         if (marketingPayout > 0) {
743             (success, ) = address(marketingWallet).call{value: marketingPayout}("");
744         }
745         
746         if (devPayout > 0) {
747             (successOp1, ) = address(devWallet).call{value: devPayout}("");
748         }
749 
750         emit SendDividends(
751             marketingPayout,
752             success && successOp1
753         );
754     }
755 
756     function airdropToWallets(
757         address[] memory airdropWallets,
758         uint256[] memory amount
759     ) external onlyOwner {
760         require(airdropWallets.length == amount.length, "Arrays must be the same length");
761         require(airdropWallets.length <= 200, "Wallets list length must be <= 200");
762         for (uint256 i = 0; i < airdropWallets.length; i++) {
763             address wallet = airdropWallets[i];
764             uint256 airdropAmount = amount[i] * (10**18);
765             super._transfer(msg.sender, wallet, airdropAmount);
766         }
767     }
768 }