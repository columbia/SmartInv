1 /**
2 
3 Orso Token 
4 
5 https://t.me/OrsoEntryOfficial
6 
7 
8 */
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity ^0.8.13;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 library SafeMath {
25     
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61 
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         return mod(a, b, "SafeMath: modulo by zero");
64     }
65 
66     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b != 0, errorMessage);
68         return a % b;
69     }
70 }
71 
72 interface IERC20 {
73     function totalSupply() external view returns (uint256);
74     function balanceOf(address account) external view returns (uint256);
75     function transfer(address recipient, uint256 amount) external returns (bool); 
76     function allowance(address owner, address spender) external view returns (uint256);
77     function approve(address spender, uint256 amount) external returns (bool);
78     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79     event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 interface IERC20Metadata is IERC20 {
84     function name() external view returns (string memory);
85     function symbol() external view returns (string memory);
86     function decimals() external view returns (uint8);
87 }
88 
89 contract ERC20 is Context, IERC20, IERC20Metadata {
90     using SafeMath for uint256;
91     mapping(address => uint256) private _balances;
92     mapping(address => mapping(address => uint256)) private _allowances;
93     uint256 internal _totalSupply;
94     string private _name;
95     string private _symbol;
96 
97     constructor(string memory name_, string memory symbol_) {
98         _name = name_;
99         _symbol = symbol_;
100     }
101 
102     function name() public view virtual override returns (string memory) {
103         return _name;
104     }
105 
106     function symbol() public view virtual override returns (string memory) {
107         return _symbol;
108     }
109 
110     function decimals() public view virtual override returns (uint8) {
111         return 18;
112     }
113 
114     function totalSupply() public view virtual override returns (uint256) {
115         return _totalSupply;
116     }
117 
118     function balanceOf(address account) public view virtual override returns (uint256) {
119         return _balances[account];
120     }
121 
122     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
123         _transfer(_msgSender(), recipient, amount);
124         return true;
125     }
126 
127     function allowance(address owner, address spender) public view virtual override returns (uint256) {
128         return _allowances[owner][spender];
129     }
130 
131     function approve(address spender, uint256 amount) public virtual override returns (bool) {
132         _approve(_msgSender(), spender, amount);
133         return true;
134     }
135 
136     function transferFrom(address sender, address recipient, uint256 amount 
137     ) public virtual override returns (bool) {
138         _transfer(sender, recipient, amount);
139         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,
140                 "ERC20: transfer amount exceeds allowance"));
141         return true;
142     }
143 
144     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
145         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
146         return true;
147     }
148 
149     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
150         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue,
151                 "ERC20: decreased allowance below zero"));
152         return true;
153     }
154 
155     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
156         require(sender != address(0), "ERC20: transfer from the zero address");
157         require(recipient != address(0), "ERC20: transfer to the zero address");
158 
159         _beforeTokenTransfer(sender, recipient, amount);
160 
161         _balances[sender] = _balances[sender].sub(amount,"ERC20: transfer amount exceeds balance");
162         _balances[recipient] = _balances[recipient].add(amount);
163         emit Transfer(sender, recipient, amount);
164     }
165 
166     function _mint(address account, uint256 amount) internal virtual {
167         require(account != address(0), "ERC20: mint to the zero address");
168 
169         _beforeTokenTransfer(address(0), account, amount);
170 
171         _totalSupply = _totalSupply.add(amount);
172         _balances[account] = _balances[account].add(amount);
173         emit Transfer(address(0), account, amount);
174     }
175 
176     function _approve(address owner, address spender, uint256 amount) internal virtual {
177         require(owner != address(0), "ERC20: approve from the zero address");
178         require(spender != address(0), "ERC20: approve to the zero address");
179 
180         _allowances[owner][spender] = amount;
181         emit Approval(owner, spender, amount);
182     }
183 
184     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
185 }
186 
187 abstract contract Ownable is Context {
188 
189     address private _owner;
190 
191     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192 
193     constructor() {
194         address msgSender = _msgSender();
195         _owner = msgSender;
196         emit OwnershipTransferred(address(0), msgSender);
197     }
198 
199     function owner() public view returns (address) {
200         return _owner;
201     }
202 
203     modifier onlyOwner() {
204         require(_owner == _msgSender(), "Ownable: caller is not the owner");
205         _;
206     }
207 
208     function renounceOwnership() public virtual onlyOwner {
209         emit OwnershipTransferred(_owner, address(0));
210         _owner = address(0);
211     }
212 
213     function transferOwnership(address newOwner) public virtual onlyOwner {
214         require(newOwner != address(0), "Ownable: new owner is the zero address");
215         emit OwnershipTransferred(_owner, newOwner);
216         _owner = newOwner;
217     }
218 }
219 
220 interface IUniswapV2Pair {
221     event Approval(address indexed owner, address indexed spender, uint256 value);
222     event Transfer(address indexed from, address indexed to, uint256 value);
223     function name() external pure returns (string memory);
224     function symbol() external pure returns (string memory);
225     function decimals() external pure returns (uint8);
226     function totalSupply() external view returns (uint256);
227     function balanceOf(address owner) external view returns (uint256);
228     function allowance(address owner, address spender) external view returns (uint256);
229     function approve(address spender, uint256 value) external returns (bool);
230     function transfer(address to, uint256 value) external returns (bool);
231     function transferFrom(address from, address to, uint256 value) external returns (bool);
232     function DOMAIN_SEPARATOR() external view returns (bytes32);
233     function PERMIT_TYPEHASH() external pure returns (bytes32);
234     function nonces(address owner) external view returns (uint256);
235 
236     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r,
237                     bytes32 s) external;
238 
239     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out,
240                uint256 amount1Out, address indexed to);
241     event Sync(uint112 reserve0, uint112 reserve1);
242 
243     function MINIMUM_LIQUIDITY() external pure returns (uint256);
244     function factory() external view returns (address);
245     function token0() external view returns (address);
246     function token1() external view returns (address);
247     function getReserves() external view returns (uint112 reserve0, uint112 reserve1,
248                                                   uint32 blockTimestampLast);
249 
250     function price0CumulativeLast() external view returns (uint256);
251     function price1CumulativeLast() external view returns (uint256);
252     function kLast() external view returns (uint256);
253 
254     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
255 
256     function skim(address to) external;
257     function sync() external;
258     function initialize(address, address) external;
259 }
260 
261 interface IUniswapV2Factory {
262     function createPair(address tokenA, address tokenB) external returns (address pair);
263 }
264 
265 interface IUniswapV2Router01 {
266     function factory() external pure returns (address);
267     function WETH() external pure returns (address);
268 
269     function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired,
270                           uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline)
271                           external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
272 
273     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin,
274                              uint256 amountETHMin, address to, uint256 deadline)
275                              external payable returns (uint256 amountToken, uint256 amountETH,
276                              uint256 liquidity);
277 
278     function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin,
279                              uint256 amountBMin, address to, uint256 deadline) 
280                              external returns (uint256 amountA, uint256 amountB);
281 
282     function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin,
283                                 uint256 amountETHMin, address to, uint256 deadline) 
284                                 external returns (uint256 amountToken, uint256 amountETH);
285 
286     function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity,
287                                        uint256 amountAMin, uint256 amountBMin, address to,
288                                        uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) 
289                                        external returns (uint256 amountA, uint256 amountB);
290 
291     function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin,
292                                           uint256 amountETHMin, address to, uint256 deadline,
293                                           bool approveMax, uint8 v, bytes32 r, bytes32 s) 
294                                           external returns (uint256 amountToken, uint256 amountETH);
295 
296     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
297                                       address to, uint256 deadline) 
298                                       external returns (uint256[] memory amounts);
299 
300     function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path,
301                                       address to, uint256 deadline) 
302                                       external returns (uint256[] memory amounts);
303 
304     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to,
305                                    uint256 deadline) 
306                                    external payable returns (uint256[] memory amounts);
307 
308     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path,
309                                    address to, uint256 deadline) 
310                                    external returns (uint256[] memory amounts);
311 
312     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
313                                    address to, uint256 deadline) 
314                                    external returns (uint256[] memory amounts);
315 
316     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to,
317                                    uint256 deadline) 
318                                    external payable returns (uint256[] memory amounts);
319 
320     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) 
321                    external pure returns (uint256 amountB);
322 
323     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) 
324                           external pure returns (uint256 amountOut);
325 
326     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) 
327                          external pure returns (uint256 amountIn);
328 
329     function getAmountsOut(uint256 amountIn, address[] calldata path)
330                            external view returns (uint256[] memory amounts);
331 
332     function getAmountsIn(uint256 amountOut, address[] calldata path)
333                           external view returns (uint256[] memory amounts);
334 }
335 
336 interface IUniswapV2Router02 is IUniswapV2Router01 {
337     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity,
338         uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) 
339         external returns (uint256 amountETH);
340 
341     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity,
342         uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax,
343         uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH);
344 
345     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin,
346         address[] calldata path, address to, uint256 deadline) external;
347 
348     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin,
349         address[] calldata path, address to, uint256 deadline) external payable;
350 
351     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin,
352         address[] calldata path, address to, uint256 deadline) external;
353 }
354 
355 contract ORSO is ERC20, Ownable { // 
356     using SafeMath for uint256;
357 
358     IUniswapV2Router02 public uniswapV2Router;
359 
360     address public uniswapV2Pair;
361     bool private swapping;
362     bool public tradingEnabled = false;
363 
364     uint256 public sellAmount = 0;
365     uint256 public buyAmount = 0;
366 
367     uint256 private totalSellFees;
368     uint256 private totalBuyFees;
369 
370     address payable public marketingWallet;
371     address payable public devWallet;
372 
373     uint256 public maxWallet;
374     bool public maxWalletEnabled = true;
375     uint256 public swapTokensAtAmount;
376     uint256 public sellMarketingFees;
377     uint256 public sellLiquidityFee;
378     uint256 public buyMarketingFees;
379     uint256 public buyLiquidityFee;
380     uint256 public buyDevFee;
381     uint256 public sellDevFee;
382 
383     bool public swapAndLiquifyEnabled = true;
384 
385     mapping(address => bool) private _isExcludedFromFees;
386     mapping(address => bool) public automatedMarketMakerPairs;
387     mapping(address => bool) private canTransferBeforeTradingIsEnabled;
388 
389     bool public limitsInEffect = false; 
390     uint256 private gasPriceLimit = 7 * 1 gwei; // MAX GWEI
391     mapping(address => uint256) private _holderLastTransferBlock; // FOR 1TX PER BLOCK
392     mapping(address => uint256) private _holderLastTransferTimestamp; // FOR COOLDOWN
393     uint256 public launchblock; // FOR DEADBLOCKS
394     uint256 public launchtimestamp; // FOR LAUNCH TIMESTAMP 
395     uint256 public cooldowntimer = 0; // DEFAULT COOLDOWN TIMER
396 
397     event EnableSwapAndLiquify(bool enabled);
398     event SetPreSaleWallet(address wallet);
399     event updateMarketingWallet(address wallet);
400     event updateDevWallet(address wallet);
401     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
402     event TradingEnabled();
403 
404     event UpdateFees(uint256 sellMarketingFees, uint256 sellLiquidityFee, uint256 buyMarketingFees,
405                      uint256 buyLiquidityFee, uint256 buyDevFee, uint256 sellDevFee);
406 
407     event Airdrop(address holder, uint256 amount);
408     event ExcludeFromFees(address indexed account, bool isExcluded);
409     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
410     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
411     event SendDividends(uint256 opAmount, bool success);
412 
413     constructor() ERC20("Orso Token", "ORSO") { // 
414         marketingWallet = payable(0x12f50A3668cCAd674A2c7Ee27Ef2E7FdBE65aA4E); // 
415         devWallet = payable(0x12f50A3668cCAd674A2c7Ee27Ef2E7FdBE65aA4E); // 
416         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
417 
418         //INITIAL FEE VALUES HERE
419         buyMarketingFees = 2;
420         sellMarketingFees = 2;
421         buyLiquidityFee = 1;
422         sellLiquidityFee = 1;
423         buyDevFee = 2;
424         sellDevFee = 2;
425 
426         // TOTAL BUY AND TOTAL SELL FEE CALCS
427         totalBuyFees = buyMarketingFees.add(buyLiquidityFee).add(buyDevFee);
428         totalSellFees = sellMarketingFees.add(sellLiquidityFee).add(sellDevFee);
429 
430         uniswapV2Router = IUniswapV2Router02(router);
431         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
432                 address(this), uniswapV2Router.WETH());
433 
434         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
435 
436         _isExcludedFromFees[address(this)] = true;
437         _isExcludedFromFees[msg.sender] = true;
438         _isExcludedFromFees[marketingWallet] = true;
439 
440         uint256 _totalSupply = (10_000_000_000) * (10**18); // TOTAL SUPPLY IS SET HERE
441         _mint(owner(), _totalSupply); // only time internal mint function is ever called is to create supply
442         maxWallet = _totalSupply / 50; // 2%
443         swapTokensAtAmount = _totalSupply / 100; // 1%;
444         canTransferBeforeTradingIsEnabled[owner()] = true;
445         canTransferBeforeTradingIsEnabled[address(this)] = true;
446     }
447 
448     function decimals() public view virtual override returns (uint8) {
449         return 18;
450     }
451 
452     receive() external payable {}
453 
454     function enableTrading() external onlyOwner {
455         require(!tradingEnabled);
456         tradingEnabled = true;
457         launchblock = block.number;
458         launchtimestamp = block.timestamp;
459         emit TradingEnabled();
460     }
461     
462     function setMarketingWallet(address wallet) external onlyOwner {
463         _isExcludedFromFees[wallet] = true;
464         marketingWallet = payable(wallet);
465         emit updateMarketingWallet(wallet);
466     }
467 
468     function setDevWallet(address wallet) external onlyOwner {
469         _isExcludedFromFees[wallet] = true;
470         devWallet = payable(wallet);
471         emit updateDevWallet(wallet);
472     }
473     
474     function setExcludeFees(address account, bool excluded) public onlyOwner {
475         _isExcludedFromFees[account] = excluded;
476         emit ExcludeFromFees(account, excluded);
477     }
478 
479     function setCanTransferBefore(address wallet, bool enable) external onlyOwner {
480         canTransferBeforeTradingIsEnabled[wallet] = enable;
481     }
482 
483     function setLimitsInEffect(bool value) external onlyOwner {
484         limitsInEffect = value;
485     }
486 
487     function setMaxWalletEnabled(bool value) external onlyOwner {
488         maxWalletEnabled = value;
489     }
490 
491     function setcooldowntimer(uint256 value) external onlyOwner {
492         require(value <= 300, "cooldown timer cannot exceed 5 minutes");
493         cooldowntimer = value;
494     }
495 
496     
497     function setmaxWallet(uint256 value) external onlyOwner {
498         value = value * (10**18);
499         require(value >= _totalSupply / 50, "max wallet cannot be set to less than 2%");
500         maxWallet = value;
501     }
502 
503     //
504     function Sweep() external onlyOwner {
505         uint256 amountETH = address(this).balance;
506         payable(msg.sender).transfer(amountETH);
507     }
508 
509     function setSwapTriggerAmount(uint256 amount) public onlyOwner {
510         swapTokensAtAmount = amount * (10**18);
511     }
512 
513     function enableSwapAndLiquify(bool enabled) public onlyOwner {
514         require(swapAndLiquifyEnabled != enabled);
515         swapAndLiquifyEnabled = enabled;
516         emit EnableSwapAndLiquify(enabled);
517     }
518 
519     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
520         _setAutomatedMarketMakerPair(pair, value);
521     }
522 
523     function _setAutomatedMarketMakerPair(address pair, bool value) private {
524         automatedMarketMakerPairs[pair] = value;
525 
526         emit SetAutomatedMarketMakerPair(pair, value);
527     }
528 
529     // THIS IS THE ONE YOU USE TO TRASNFER OWNER IF U EVER DO
530     function transferAdmin(address newOwner) public onlyOwner {
531         _isExcludedFromFees[newOwner] = true;
532         canTransferBeforeTradingIsEnabled[newOwner] = true;
533         transferOwnership(newOwner);
534     }
535 
536     function updateFees(uint256 marketingBuy, uint256 marketingSell, uint256 liquidityBuy,
537                         uint256 liquiditySell, uint256 devBuy, uint256 devSell) public onlyOwner {
538 
539         buyMarketingFees = marketingBuy;
540         buyLiquidityFee = liquidityBuy;
541         sellMarketingFees = marketingSell;
542         sellLiquidityFee = liquiditySell;
543         buyDevFee = devBuy;
544         sellDevFee = devSell;
545 
546         totalSellFees = sellMarketingFees.add(sellLiquidityFee).add(sellDevFee);
547         totalBuyFees = buyMarketingFees.add(buyLiquidityFee).add(buyDevFee);
548 
549         // ABSOLUTE TAX LIMITS GO HERE
550         require(totalSellFees <= 99 && totalBuyFees <= 99, "total fees cannot be higher than 15%");
551 
552         emit UpdateFees(sellMarketingFees, sellLiquidityFee, sellDevFee, buyMarketingFees,
553                         buyLiquidityFee, buyDevFee);
554     }
555 
556     function isExcludedFromFees(address account) public view returns (bool) {
557         return _isExcludedFromFees[account];
558     }
559 
560     function _transfer(address from, address to, uint256 amount) internal override {
561 
562         require(from != address(0), "IERC20: transfer from the zero address");
563         require(to != address(0), "IERC20: transfer to the zero address");
564 
565         uint256 marketingFees;
566         uint256 liquidityFee;
567         uint256 devFee;
568 
569         if (!canTransferBeforeTradingIsEnabled[from]) {
570             require(tradingEnabled, "Trading has not yet been enabled");          
571         }
572 
573         if (amount == 0) {
574             super._transfer(from, to, 0);
575             return;
576         } 
577         
578         else if (
579             !swapping && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]
580         ) {
581             bool isSelling = automatedMarketMakerPairs[to];
582             if (isSelling) {
583                 marketingFees = sellMarketingFees;
584                 liquidityFee = sellLiquidityFee;
585                 devFee = sellDevFee;
586 
587                 if (limitsInEffect) {
588                 require(block.timestamp >= _holderLastTransferTimestamp[tx.origin] + cooldowntimer,
589                         "cooldown period active");
590                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
591                 }
592             } 
593             
594             else {
595                 marketingFees = buyMarketingFees;
596                 liquidityFee = buyLiquidityFee;
597                 devFee = buyDevFee;
598 
599                 if (limitsInEffect) {
600                 require(block.number > launchblock + 2,"you shall not pass");
601                 require(tx.gasprice <= gasPriceLimit,"Gas price exceeds limit.");
602                 require(_holderLastTransferBlock[tx.origin] != block.number,"Too many TX in block");
603                 require(block.timestamp >= _holderLastTransferTimestamp[tx.origin] + cooldowntimer,
604                         "cooldown period active");
605                 _holderLastTransferBlock[tx.origin] = block.number;
606                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
607             }
608 
609             if (maxWalletEnabled) {
610             uint256 contractBalanceRecipient = balanceOf(to);
611             require(contractBalanceRecipient + amount <= maxWallet,
612                     "Exceeds maximum wallet token amount." );
613             }
614             }
615 
616             uint256 totalFees = marketingFees.add(liquidityFee).add(devFee);
617 
618             uint256 contractTokenBalance = balanceOf(address(this));
619 
620             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
621 
622             if (canSwap && !automatedMarketMakerPairs[from]) {
623                 swapping = true;
624 
625                 uint256 swapTokens;
626 
627                 if (swapAndLiquifyEnabled && liquidityFee > 0) {
628                     uint256 totalBuySell = buyAmount.add(sellAmount);
629                     uint256 swapAmountBought = contractTokenBalance
630                         .mul(buyAmount)
631                         .div(totalBuySell);
632                     uint256 swapAmountSold = contractTokenBalance
633                         .mul(sellAmount)
634                         .div(totalBuySell);
635 
636                     uint256 swapBuyTokens = swapAmountBought
637                         .mul(liquidityFee)
638                         .div(totalBuyFees);
639 
640                     uint256 swapSellTokens = swapAmountSold
641                         .mul(liquidityFee)
642                         .div(totalSellFees);
643 
644                     swapTokens = swapSellTokens.add(swapBuyTokens);
645 
646                     swapAndLiquify(swapTokens);
647                 }
648 
649                 uint256 remainingBalance = swapTokensAtAmount.sub(swapTokens);
650                 swapAndSendDividends(remainingBalance);
651                 buyAmount = 0;
652                 sellAmount = 0;
653                 swapping = false;
654             }
655 
656             uint256 fees = amount.mul(totalFees).div(100);
657 
658             amount = amount.sub(fees);
659 
660             if (isSelling) {
661                 sellAmount = sellAmount.add(fees);
662             } else {
663                 buyAmount = buyAmount.add(fees);
664             }
665 
666             super._transfer(from, address(this), fees);
667            
668         }
669 
670         super._transfer(from, to, amount);
671         
672     }
673 
674 
675     function swapAndLiquify(uint256 tokens) private {
676         uint256 half = tokens.div(2);
677         uint256 otherHalf = tokens.sub(half);
678         uint256 initialBalance = address(this).balance;
679         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
680         uint256 newBalance = address(this).balance.sub(initialBalance);
681         addLiquidity(otherHalf, newBalance);
682         emit SwapAndLiquify(half, newBalance, otherHalf);
683     }
684 
685     function swapTokensForEth(uint256 tokenAmount) private {
686         address[] memory path = new address[](2);
687         path[0] = address(this);
688         path[1] = uniswapV2Router.WETH();
689         _approve(address(this), address(uniswapV2Router), tokenAmount);
690         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
691             tokenAmount,
692             0, // accept any amount of ETH
693             path,
694             address(this),
695             block.timestamp
696         );
697     }
698 
699     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
700         // approve token transfer to cover all possible scenarios
701         _approve(address(this), address(uniswapV2Router), tokenAmount);
702 
703         // add the liquidity
704         uniswapV2Router.addLiquidityETH{value: ethAmount}(
705             address(this),
706             tokenAmount,
707             0, // slippage is unavoidable
708             0, // slippage is unavoidable
709             owner(),
710             block.timestamp
711         );
712     }
713 
714     function forceSwapAndSendDividends(uint256 tokens) public onlyOwner {
715         tokens = tokens * (10**18);
716         uint256 totalAmount = buyAmount.add(sellAmount);
717         uint256 fromBuy = tokens.mul(buyAmount).div(totalAmount);
718         uint256 fromSell = tokens.mul(sellAmount).div(totalAmount);
719 
720         swapAndSendDividends(tokens);
721 
722         buyAmount = buyAmount.sub(fromBuy);
723         sellAmount = sellAmount.sub(fromSell);
724     }
725 
726     // TAX PAYOUT CODE 
727     function swapAndSendDividends(uint256 tokens) private {
728         if (tokens == 0) {
729             return;
730         }
731         swapTokensForEth(tokens);
732 
733         bool success = true;
734         bool successOp1 = true;
735         
736         uint256 _marketDevTotal = sellMarketingFees.add(sellDevFee) + buyMarketingFees.add(buyDevFee);
737 
738         uint256 feePortions;
739         if (_marketDevTotal > 0) {
740             feePortions = address(this).balance.div(_marketDevTotal);
741         }
742         uint256 marketingPayout = buyMarketingFees.add(sellMarketingFees) * feePortions;
743         uint256 devPayout = buyDevFee.add(sellDevFee) * feePortions;
744         
745         if (marketingPayout > 0) {
746             (success, ) = address(marketingWallet).call{value: marketingPayout}("");
747         }
748         
749         if (devPayout > 0) {
750             (successOp1, ) = address(devWallet).call{value: devPayout}("");
751         }
752 
753         emit SendDividends(
754             marketingPayout,
755             success && successOp1
756         );
757     }
758 
759     function airdropToWallets(
760         address[] memory airdropWallets,
761         uint256[] memory amount
762     ) external onlyOwner {
763         require(airdropWallets.length == amount.length, "Arrays must be the same length");
764         require(airdropWallets.length <= 200, "Wallets list length must be <= 200");
765         for (uint256 i = 0; i < airdropWallets.length; i++) {
766             address wallet = airdropWallets[i];
767             uint256 airdropAmount = amount[i] * (10**18);
768             super._transfer(msg.sender, wallet, airdropAmount);
769         }
770     }
771 }