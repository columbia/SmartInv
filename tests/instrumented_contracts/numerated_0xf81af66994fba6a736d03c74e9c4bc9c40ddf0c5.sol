1 /*
2        
3 https://t.me/CaishenTokenERC
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
352 contract caishenf is BEP20, Ownable { //
353     using SafeMath for uint256;
354 
355     IUniswapV2Router02 public uniswapV2Router;
356 
357     address public uniswapV2Pair;
358     address public DEAD = 0x000000000000000000000000000000000000dEaD;
359     address public USD = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; //
360     bool public tradingEnabled = false;
361 
362     //uint256 internal sellAmount = 0;
363     //uint256 internal buyAmount = 0;
364 
365     uint256 private totalSellFees;
366     uint256 private totalBuyFees;
367 
368     address payable public marketingWallet; //
369     address payable public devWallet; //
370 
371     uint256 public maxWallet;
372     bool public maxWalletEnabled = true;
373     uint256 public swapTokensAtAmount;
374     uint256 public sellMarketingFees;
375     uint256 public sellBurnFee;
376     uint256 public buyMarketingFees;
377     uint256 public buyBurnFee;
378     uint256 public buyDevFee;
379     uint256 public sellDevFee;
380 
381     mapping(address => bool) private _isExcludedFromFees;
382     mapping(address => bool) private _isBot;
383     mapping(address => bool) public automatedMarketMakerPairs;
384     mapping(address => bool) private canTransferBeforeTradingIsEnabled;
385 
386     bool public limitsInEffect = false; 
387     uint256 private gasPriceLimit = 50 * 1 gwei; // MAX GWEI
388     mapping(address => uint256) private _holderLastTransferBlock; // FOR 1TX PER BLOCK
389     mapping(address => uint256) private _holderLastTransferTimestamp; // FOR COOLDOWN
390     uint256 public launchblock; // FOR DEADBLOCKS
391     uint256 public launchtimestamp; // FOR LAUNCH TIMESTAMP 
392     uint256 public cooldowntimer = 0; // DEFAULT COOLDOWN TIMER
393 
394     event SetPreSaleWallet(address wallet);
395     event updateMarketingWallet(address wallet);
396     event updateDevWallet(address wallet);
397     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
398     event TradingEnabled();
399 
400     event UpdateFees(uint256 sellMarketingFees, uint256 sellBurnFee, uint256 buyMarketingFees,
401                      uint256 buyBurnFee, uint256 buyDevFee, uint256 sellDevFee);
402 
403     event Airdrop(address holder, uint256 amount);
404     event ExcludeFromFees(address indexed account, bool isExcluded);
405     event blackList(address);
406     event unblackList(address);
407     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
408     event SendDividends(uint256 opAmount, bool success);
409     event transferUSD(uint256 amountUSD);
410 
411     constructor() BEP20("Caishen", "Caish") { // 
412         marketingWallet = payable(0x60fd5A50733fee4D30A2833b0f34f32967232cBF); // 
413         devWallet = payable(0x60fd5A50733fee4D30A2833b0f34f32967232cBF); // 
414         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; /// 
415 
416         //INITIAL FEE VALUES HERE
417         buyMarketingFees = 4;
418         sellMarketingFees = 4;
419         buyBurnFee = 0;
420         sellBurnFee = 0;
421         buyDevFee = 0;
422         sellDevFee = 0;
423 
424         // TOTAL BUY AND TOTAL SELL FEE CALCS
425         totalBuyFees = buyMarketingFees.add(buyDevFee);
426         totalSellFees = sellMarketingFees.add(sellDevFee);
427 
428         uniswapV2Router = IUniswapV2Router02(router);
429         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
430                 address(this), USD);
431 
432         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
433 
434         _isExcludedFromFees[address(this)] = true;
435         _isExcludedFromFees[msg.sender] = true;
436         _isExcludedFromFees[marketingWallet] = true;
437 
438         uint256 totalSupply = (6_666) * (10**18); // 
439         _mint(owner(), totalSupply); // 
440         maxWallet = _totalSupply / 50; // 2%
441         swapTokensAtAmount = _totalSupply / 1000; // 1%;
442         canTransferBeforeTradingIsEnabled[owner()] = true;
443         canTransferBeforeTradingIsEnabled[address(this)] = true;
444     }
445 
446     function decimals() public view virtual override returns (uint8) {
447         return 18;
448     }
449 
450     receive() external payable {}
451 
452     function enableTrading() external onlyOwner {
453         require(!tradingEnabled);
454         tradingEnabled = true;
455         launchblock = block.number;
456         launchtimestamp = block.timestamp;
457         emit TradingEnabled();
458     }
459     
460     function setMarketingWallet(address wallet) external onlyOwner {
461         _isExcludedFromFees[wallet] = true;
462         marketingWallet = payable(wallet);
463         emit updateMarketingWallet(wallet);
464     }
465 
466     function setDevWallet(address wallet) external onlyOwner {
467         _isExcludedFromFees[wallet] = true;
468         devWallet = payable(wallet);
469         emit updateDevWallet(wallet);
470     }
471     
472     function setExcludeFees(address account, bool excluded) public onlyOwner {
473         _isExcludedFromFees[account] = excluded;
474         emit ExcludeFromFees(account, excluded);
475     }
476 
477     function addBot(address account) public onlyOwner {
478         _isBot[account] = true;
479         emit blackList(account);
480     }
481 
482     function removeBot(address account) public onlyOwner {
483         _isBot[account] = false;
484         emit unblackList(account);
485     }
486 
487     function setCanTransferBefore(address wallet, bool enable) external onlyOwner {
488         canTransferBeforeTradingIsEnabled[wallet] = enable;
489     }
490 
491     function setLimitsInEffect(bool value) external onlyOwner {
492         limitsInEffect = value;
493     }
494 
495     function setMaxWalletEnabled(bool value) external onlyOwner {
496         maxWalletEnabled = value;
497     }
498 
499     function setcooldowntimer(uint256 value) external onlyOwner {
500         require(value <= 300, "cooldown timer cannot exceed 5 minutes");
501         cooldowntimer = value;
502     }
503     
504     function setmaxWallet(uint256 value) external onlyOwner {
505         value = value * (10**18);
506         require(value >= _totalSupply / 100, "max wallet cannot be set to less than 1%");
507         maxWallet = value;
508     }
509 
510     // TAKES ALL BNB/ETH FROM THE CONTRACT ADDRESS AND SENDS IT TO OWNERS WALLET
511     function Sweep() external onlyOwner {
512         uint256 amountBNB = address(this).balance;
513         payable(msg.sender).transfer(amountBNB);
514     }
515 
516     function SendUSD() external onlyOwner {
517         uint256 amountUSD = IBEP20(USD).balanceOf(address(this));
518         IBEP20(USD).approve(address(this), amountUSD.mul(10));
519         IBEP20(USD).transferFrom(address(this),msg.sender,amountUSD);
520         emit transferUSD(amountUSD);
521     }
522 
523     function setSwapTriggerAmount(uint256 amount) public onlyOwner {
524         swapTokensAtAmount = amount * (10**18);
525     }
526 
527     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
528         _setAutomatedMarketMakerPair(pair, value);
529     }
530 
531     function _setAutomatedMarketMakerPair(address pair, bool value) private {
532         automatedMarketMakerPairs[pair] = value;
533 
534         emit SetAutomatedMarketMakerPair(pair, value);
535     }
536 
537     // THIS IS THE ONE YOU USE TO TRASNFER OWNER IF U EVER DO
538     function transferAdmin(address newOwner) public onlyOwner {
539         _isExcludedFromFees[newOwner] = true;
540         canTransferBeforeTradingIsEnabled[newOwner] = true;
541         transferOwnership(newOwner);
542     }
543 
544     function updateFees(uint256 marketingBuy, uint256 marketingSell, uint256 burnBuy,
545                         uint256 burnSell, uint256 devBuy, uint256 devSell) public onlyOwner {
546 
547         buyMarketingFees = marketingBuy;
548         buyBurnFee = burnBuy;
549         sellMarketingFees = marketingSell;
550         sellBurnFee = burnSell;
551         buyDevFee = devBuy;
552         sellDevFee = devSell;
553 
554         totalSellFees = sellMarketingFees.add(sellDevFee);
555         totalBuyFees = buyMarketingFees.add(buyDevFee);
556 
557         // ABSOLUTE TAX LIMITS GO HERE
558         require(totalSellFees <= 99 && totalBuyFees <= 99, "%");
559 
560         emit UpdateFees(sellMarketingFees, sellBurnFee, sellDevFee, buyMarketingFees,
561                         buyBurnFee, buyDevFee);
562     }
563 
564     function isExcludedFromFees(address account) public view returns (bool) {
565         return _isExcludedFromFees[account];
566     }
567 
568     function isBot(address account) public view returns (bool) {
569         return _isBot[account];
570     }
571 
572     function _transfer(address from, address to, uint256 amount) internal override {
573 
574         require(from != address(0), "IBEP20: transfer from the zero address");
575         require(to != address(0), "IBEP20: transfer to the zero address");
576         require(!_isBot[from] && !_isBot[to]);
577 
578         uint256 marketingFees;
579         uint256 burnFee;
580         uint256 devFee;
581 
582         if (!canTransferBeforeTradingIsEnabled[from]) {
583             require(tradingEnabled, "Trading has not yet been enabled");          
584         }
585 
586         if (amount == 0) {
587             super._transfer(from, to, 0);
588             return;
589         } 
590         
591         else if (
592             !_isExcludedFromFees[from] && !_isExcludedFromFees[to]
593         ) {
594             bool isSelling = automatedMarketMakerPairs[to];
595             if (isSelling) {
596                 marketingFees = sellMarketingFees;
597                 burnFee = sellBurnFee;
598                 devFee = sellDevFee;
599 
600                 if (limitsInEffect) {
601                 require(block.timestamp >= _holderLastTransferTimestamp[tx.origin] + cooldowntimer,
602                         "cooldown period active");
603                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
604                 }
605             } 
606             
607             else {
608                 marketingFees = buyMarketingFees;
609                 burnFee = buyBurnFee;
610                 devFee = buyDevFee;
611 
612                 if (limitsInEffect) {
613                 require(block.number > launchblock + 2,"you shall not pass");
614                 require(tx.gasprice <= gasPriceLimit,"Gas price exceeds limit.");
615                 require(_holderLastTransferBlock[tx.origin] != block.number,"Too many TX in block");
616                 require(block.timestamp >= _holderLastTransferTimestamp[tx.origin] + cooldowntimer,
617                         "cooldown period active");
618                 _holderLastTransferBlock[tx.origin] = block.number;
619                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
620             }
621 
622             if (maxWalletEnabled) {
623             uint256 contractBalanceRecipient = balanceOf(to);
624             require(contractBalanceRecipient + amount <= maxWallet,
625                     "Exceeds maximum wallet token amount." );
626             }
627             }
628 
629             uint256 totalFees = marketingFees.add(devFee);
630 
631             uint256 contractTokenBalance = balanceOf(address(this));
632 
633             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
634 
635             if (canSwap && !automatedMarketMakerPairs[from]) {
636                 uint256 tokensFromFees=contractTokenBalance;
637                 uint256 totalMarketingFees = sellMarketingFees+buyMarketingFees;
638                 uint256 totalDevFees = sellDevFee + buyDevFee;
639                 uint256 totalFee = totalMarketingFees+totalDevFees;
640                 uint256 partMarketing = (totalMarketingFees*100).div(totalFee); //*100 because uint256
641                 uint256 partDev = (totalDevFees*100).div(totalFee); //*100 because uint256
642 
643                 uint256 marketingPayout = (tokensFromFees * partMarketing).div(100);
644                 uint256 devPayout = (tokensFromFees * partDev).div(100);
645 
646                 if (marketingPayout > 0) {
647                     swapTokensForUSD(marketingPayout, marketingWallet);
648                 }
649                 
650                 if (devPayout > 0) {
651                     swapTokensForUSD(devPayout, devWallet);
652 
653                 }
654              
655             }
656 
657             uint256 fees = amount.mul(totalFees).div(100);
658             uint256 burntokens = amount.mul(burnFee).div(100);
659 
660             amount = amount.sub(fees + burntokens);
661 
662             super._transfer(from, address(this), fees);
663 
664             if (burntokens > 0) {
665                 super._transfer(from, DEAD, burntokens);
666                 _totalSupply = _totalSupply.sub(burntokens);
667             }
668            
669         }
670         super._transfer(from, to, amount); 
671     }
672 
673 
674     function swapTokensForUSD(uint256 tokenAmount, address destAddr) private {
675         address[] memory path = new address[](2);
676         path[0] = address(this);
677         path[1] = USD;
678         _approve(address(this), address(uniswapV2Router), tokenAmount);
679         uniswapV2Router.swapExactTokensForTokens(
680             tokenAmount,
681             0, // accept any amount of USD
682             path,
683             destAddr,
684             block.timestamp
685         );
686     }
687 
688     function forceSwapAndSendDividends(uint256 tokens) public onlyOwner {
689         payWallets(tokens);
690     }
691 
692     // in this function, the contract sells his tokens and send USD to marketing and dev wallets
693     function payWallets(uint256 tokensFromFees) private {
694 
695         uint256 totalMarketingFees = sellMarketingFees+buyMarketingFees;
696         uint256 totalDevFees = sellDevFee + buyDevFee;
697         uint256 totalFees = totalMarketingFees+totalDevFees;
698         uint256 partMarketing = (totalMarketingFees*100).div(totalFees); //*100 because uint256
699         uint256 partDev = (totalDevFees*100).div(totalFees); //*100 because uint256
700 
701         uint256 marketingPayout = (tokensFromFees * partMarketing).div(100);
702         uint256 devPayout = (tokensFromFees * partDev).div(100);
703 
704         if (marketingPayout > 0) {
705             swapTokensForUSD(marketingPayout, marketingWallet);
706         }
707         
708         if (devPayout > 0) {
709             swapTokensForUSD(devPayout, devWallet);
710         }
711 
712     }
713 
714     function airdropToWallets(
715         address[] memory airdropWallets,
716         uint256[] memory amount
717     ) external onlyOwner {
718         require(airdropWallets.length == amount.length, "Arrays must be the same length");
719         require(airdropWallets.length <= 200, "Wallets list length must be <= 200");
720         for (uint256 i = 0; i < airdropWallets.length; i++) {
721             address wallet = airdropWallets[i];
722             uint256 airdropAmount = amount[i] * (10**18);
723             super._transfer(msg.sender, wallet, airdropAmount);
724         }
725     }
726 }