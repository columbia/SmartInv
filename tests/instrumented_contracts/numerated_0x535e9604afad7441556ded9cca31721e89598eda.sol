1 /*
2        
3 John Briggs inu presents vader x
4 cryptonites a scumbag dev and This token was made in honour of cryptonite who rugged alot of based chads
5 so now i launch this in his memory as he never did i hope he burns in hell
6 A safe launch of vader x  join us in the tg for a safe eth launch
7 https://t.me/+VVmRRjYJSzRmYTc9
8 
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 pragma solidity ^0.8.13;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 library SafeMath {
27     
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         return mod(a, b, "SafeMath: modulo by zero");
66     }
67 
68     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b != 0, errorMessage);
70         return a % b;
71     }
72 }
73 
74 interface IBEP20 {
75     function totalSupply() external view returns (uint256);
76     function balanceOf(address account) external view returns (uint256);
77     function transfer(address recipient, uint256 amount) external returns (bool); 
78     function allowance(address owner, address spender) external view returns (uint256);
79     function approve(address spender, uint256 amount) external returns (bool);
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81     event Transfer(address indexed from, address indexed to, uint256 value);
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 interface IBEP20Metadata is IBEP20 {
86     function name() external view returns (string memory);
87     function symbol() external view returns (string memory);
88     function decimals() external view returns (uint8);
89 }
90 
91 contract BEP20 is Context, IBEP20, IBEP20Metadata {
92     using SafeMath for uint256;
93     mapping(address => uint256) private _balances;
94     mapping(address => mapping(address => uint256)) private _allowances;
95     uint256 internal _totalSupply;
96     string private _name;
97     string private _symbol;
98 
99     constructor(string memory name_, string memory symbol_) {
100         _name = name_;
101         _symbol = symbol_;
102     }
103 
104     function name() public view virtual override returns (string memory) {
105         return _name;
106     }
107 
108     function symbol() public view virtual override returns (string memory) {
109         return _symbol;
110     }
111 
112     function decimals() public view virtual override returns (uint8) {
113         return 18;
114     }
115 
116     function totalSupply() public view virtual override returns (uint256) {
117         return _totalSupply;
118     }
119 
120     function balanceOf(address account) public view virtual override returns (uint256) {
121         return _balances[account];
122     }
123 
124     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
125         _transfer(_msgSender(), recipient, amount);
126         return true;
127     }
128 
129     function allowance(address owner, address spender) public view virtual override returns (uint256) {
130         return _allowances[owner][spender];
131     }
132 
133     function approve(address spender, uint256 amount) public virtual override returns (bool) {
134         _approve(_msgSender(), spender, amount);
135         return true;
136     }
137 
138     function transferFrom(address sender, address recipient, uint256 amount 
139     ) public virtual override returns (bool) {
140         _transfer(sender, recipient, amount);
141         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,
142                 "BEP20: transfer amount exceeds allowance"));
143         return true;
144     }
145 
146     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
147         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
148         return true;
149     }
150 
151     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
152         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue,
153                 "BEP20: decreased allowance below zero"));
154         return true;
155     }
156 
157     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
158         require(sender != address(0), "BEP20: transfer from the zero address");
159         require(recipient != address(0), "BEP20: transfer to the zero address");
160 
161         _beforeTokenTransfer(sender, recipient, amount);
162 
163         _balances[sender] = _balances[sender].sub(amount,"BEP20: transfer amount exceeds balance");
164         _balances[recipient] = _balances[recipient].add(amount);
165         emit Transfer(sender, recipient, amount);
166     }
167 
168     function _mint(address account, uint256 amount) internal virtual {
169         require(account != address(0), "BEP20: mint to the zero address");
170 
171         _beforeTokenTransfer(address(0), account, amount);
172 
173         _totalSupply = _totalSupply.add(amount);
174         _balances[account] = _balances[account].add(amount);
175         emit Transfer(address(0), account, amount);
176     }
177 
178     function _approve(address owner, address spender, uint256 amount) internal virtual {
179         require(owner != address(0), "BEP20: approve from the zero address");
180         require(spender != address(0), "BEP20: approve to the zero address");
181 
182         _allowances[owner][spender] = amount;
183         emit Approval(owner, spender, amount);
184     }
185 
186     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
187 }
188 
189 abstract contract Ownable is Context {
190 
191     address private _owner;
192 
193     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
194 
195     constructor() {
196         address msgSender = _msgSender();
197         _owner = msgSender;
198         emit OwnershipTransferred(address(0), msgSender);
199     }
200 
201     function owner() public view returns (address) {
202         return _owner;
203     }
204 
205     modifier onlyOwner() {
206         require(_owner == _msgSender(), "Ownable: caller is not the owner");
207         _;
208     }
209 
210     function renounceOwnership() public virtual onlyOwner {
211         emit OwnershipTransferred(_owner, address(0));
212         _owner = address(0);
213     }
214 
215     function transferOwnership(address newOwner) public virtual onlyOwner {
216         require(newOwner != address(0), "Ownable: new owner is the zero address");
217         emit OwnershipTransferred(_owner, newOwner);
218         _owner = newOwner;
219     }
220 }
221 
222 interface IUniswapV2Pair {
223     event Approval(address indexed owner, address indexed spender, uint256 value);
224     event Transfer(address indexed from, address indexed to, uint256 value);
225     function name() external pure returns (string memory);
226     function symbol() external pure returns (string memory);
227     function decimals() external pure returns (uint8);
228     function totalSupply() external view returns (uint256);
229     function balanceOf(address owner) external view returns (uint256);
230     function allowance(address owner, address spender) external view returns (uint256);
231     function approve(address spender, uint256 value) external returns (bool);
232     function transfer(address to, uint256 value) external returns (bool);
233     function transferFrom(address from, address to, uint256 value) external returns (bool);
234     function DOMAIN_SEPARATOR() external view returns (bytes32);
235     function PERMIT_TYPEHASH() external pure returns (bytes32);
236     function nonces(address owner) external view returns (uint256);
237 
238     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r,
239                     bytes32 s) external;
240 
241     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out,
242                uint256 amount1Out, address indexed to);
243     event Sync(uint112 reserve0, uint112 reserve1);
244 
245     function MINIMUM_LIQUIDITY() external pure returns (uint256);
246     function factory() external view returns (address);
247     function token0() external view returns (address);
248     function token1() external view returns (address);
249     function getReserves() external view returns (uint112 reserve0, uint112 reserve1,
250                                                   uint32 blockTimestampLast);
251 
252     function price0CumulativeLast() external view returns (uint256);
253     function price1CumulativeLast() external view returns (uint256);
254     function kLast() external view returns (uint256);
255 
256     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
257 
258     function skim(address to) external;
259     function sync() external;
260     function initialize(address, address) external;
261 }
262 
263 interface IUniswapV2Factory {
264     function createPair(address tokenA, address tokenB) external returns (address pair);
265 }
266 
267 interface IUniswapV2Router01 {
268     function factory() external pure returns (address);
269     function WETH() external pure returns (address);
270 
271     function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired,
272                           uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline)
273                           external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
274 
275     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin,
276                              uint256 amountETHMin, address to, uint256 deadline)
277                              external payable returns (uint256 amountToken, uint256 amountETH,
278                              uint256 liquidity);
279 
280     function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin,
281                              uint256 amountBMin, address to, uint256 deadline) 
282                              external returns (uint256 amountA, uint256 amountB);
283 
284     function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin,
285                                 uint256 amountETHMin, address to, uint256 deadline) 
286                                 external returns (uint256 amountToken, uint256 amountETH);
287 
288     function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity,
289                                        uint256 amountAMin, uint256 amountBMin, address to,
290                                        uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) 
291                                        external returns (uint256 amountA, uint256 amountB);
292 
293     function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin,
294                                           uint256 amountETHMin, address to, uint256 deadline,
295                                           bool approveMax, uint8 v, bytes32 r, bytes32 s) 
296                                           external returns (uint256 amountToken, uint256 amountETH);
297 
298     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
299                                       address to, uint256 deadline) 
300                                       external returns (uint256[] memory amounts);
301 
302     function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path,
303                                       address to, uint256 deadline) 
304                                       external returns (uint256[] memory amounts);
305 
306     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to,
307                                    uint256 deadline) 
308                                    external payable returns (uint256[] memory amounts);
309 
310     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path,
311                                    address to, uint256 deadline) 
312                                    external returns (uint256[] memory amounts);
313 
314     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
315                                    address to, uint256 deadline) 
316                                    external returns (uint256[] memory amounts);
317 
318     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to,
319                                    uint256 deadline) 
320                                    external payable returns (uint256[] memory amounts);
321 
322     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) 
323                    external pure returns (uint256 amountB);
324 
325     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) 
326                           external pure returns (uint256 amountOut);
327 
328     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) 
329                          external pure returns (uint256 amountIn);
330 
331     function getAmountsOut(uint256 amountIn, address[] calldata path)
332                            external view returns (uint256[] memory amounts);
333 
334     function getAmountsIn(uint256 amountOut, address[] calldata path)
335                           external view returns (uint256[] memory amounts);
336 }
337 
338 interface IUniswapV2Router02 is IUniswapV2Router01 {
339     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity,
340         uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) 
341         external returns (uint256 amountETH);
342 
343     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity,
344         uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax,
345         uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH);
346 
347     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin,
348         address[] calldata path, address to, uint256 deadline) external;
349 
350     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin,
351         address[] calldata path, address to, uint256 deadline) external payable;
352 
353     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin,
354         address[] calldata path, address to, uint256 deadline) external;
355 }
356 
357 contract VADERX is BEP20, Ownable { // CONTRACT NAME FOR YOUR CUSTOM CONTRACT
358     using SafeMath for uint256;
359 
360     IUniswapV2Router02 public uniswapV2Router;
361 
362     address public uniswapV2Pair;
363     bool private swapping;
364     bool public tradingEnabled = false;
365 
366     uint256 public sellAmount = 8;
367     uint256 public buyAmount = 8;
368 
369     uint256 private totalSellFees;
370     uint256 private totalBuyFees;
371 
372     address payable public marketingWallet;
373     address payable public devWallet;
374 
375     uint256 public maxWallet;
376     bool public maxWalletEnabled = true;
377     uint256 public swapTokensAtAmount;
378     uint256 public sellMarketingFees;
379     uint256 public sellLiquidityFee;
380     uint256 public buyMarketingFees;
381     uint256 public buyLiquidityFee;
382     uint256 public buyDevFee;
383     uint256 public sellDevFee;
384 
385     bool public swapAndLiquifyEnabled = true;
386 
387     mapping(address => bool) private _isExcludedFromFees;
388     mapping(address => bool) public automatedMarketMakerPairs;
389     mapping(address => bool) private canTransferBeforeTradingIsEnabled;
390 
391     bool public limitsInEffect = true; 
392     uint256 private gasPriceLimit = 7 * 1 gwei; // MAX GWEI
393     mapping(address => uint256) private _holderLastTransferBlock; // FOR 1TX PER BLOCK
394     mapping(address => uint256) private _holderLastTransferTimestamp; // FOR COOLDOWN
395     uint256 public launchblock; // FOR DEADBLOCKS
396     uint256 public launchtimestamp; // FOR LAUNCH TIMESTAMP 
397     uint256 public cooldowntimer = 30; // DEFAULT COOLDOWN TIMER
398 
399     event EnableSwapAndLiquify(bool enabled);
400     event SetPreSaleWallet(address wallet);
401     event updateMarketingWallet(address wallet);
402     event updateDevWallet(address wallet);
403     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
404     event TradingEnabled();
405 
406     event UpdateFees(uint256 sellMarketingFees, uint256 sellLiquidityFee, uint256 buyMarketingFees,
407                      uint256 buyLiquidityFee, uint256 buyDevFee, uint256 sellDevFee);
408 
409     event Airdrop(address holder, uint256 amount);
410     event ExcludeFromFees(address indexed account, bool isExcluded);
411     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
412     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
413     event SendDividends(uint256 opAmount, bool success);
414 
415     constructor() BEP20("VADERX", "VDX") { // PROJECTNAME AND TICKER GO HERE
416         marketingWallet = payable(0xa3700C35F95fF434E168b404402A29Ac99480ca0); // CHANGE THIS TO YOURS
417         devWallet = payable(0x97EdF114726DeB6eBB509219116335F49EC572ae); // CHANGE THIS TO YOURS
418         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
419 
420         //INITIAL FEE VALUES HERE
421         buyMarketingFees = 3;
422         sellMarketingFees = 3;
423         buyLiquidityFee = 3;
424         sellLiquidityFee = 3;
425         buyDevFee = 2;
426         sellDevFee = 2;
427 
428         // TOTAL BUY AND TOTAL SELL FEE CALCS
429         totalBuyFees = buyMarketingFees.add(buyLiquidityFee).add(buyDevFee);
430         totalSellFees = sellMarketingFees.add(sellLiquidityFee).add(sellDevFee);
431 
432         uniswapV2Router = IUniswapV2Router02(router);
433         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
434                 address(this), uniswapV2Router.WETH());
435 
436         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
437 
438         _isExcludedFromFees[address(this)] = true;
439         _isExcludedFromFees[msg.sender] = true;
440         _isExcludedFromFees[marketingWallet] = true;
441 
442         uint256 _totalSupply = (1_000_000_000_000) * (10**18); // TOTAL SUPPLY IS SET HERE
443         _mint(owner(), _totalSupply); // only time internal mint function is ever called is to create supply
444         maxWallet = _totalSupply / 25; // 4%
445         swapTokensAtAmount = _totalSupply / 25; // 4%;
446         canTransferBeforeTradingIsEnabled[owner()] = true;
447         canTransferBeforeTradingIsEnabled[address(this)] = true;
448     }
449 
450     function decimals() public view virtual override returns (uint8) {
451         return 18;
452     }
453 
454     receive() external payable {}
455 
456     function enableTrading() external onlyOwner {
457         require(!tradingEnabled);
458         tradingEnabled = true;
459         launchblock = block.number;
460         launchtimestamp = block.timestamp;
461         emit TradingEnabled();
462     }
463     
464     function setMarketingWallet(address wallet) external onlyOwner {
465         _isExcludedFromFees[wallet] = true;
466         marketingWallet = payable(wallet);
467         emit updateMarketingWallet(wallet);
468     }
469 
470     function setDevWallet(address wallet) external onlyOwner {
471         _isExcludedFromFees[wallet] = true;
472         devWallet = payable(wallet);
473         emit updateDevWallet(wallet);
474     }
475     
476     function setExcludeFees(address account, bool excluded) public onlyOwner {
477         _isExcludedFromFees[account] = excluded;
478         emit ExcludeFromFees(account, excluded);
479     }
480 
481     function setCanTransferBefore(address wallet, bool enable) external onlyOwner {
482         canTransferBeforeTradingIsEnabled[wallet] = enable;
483     }
484 
485     function setLimitsInEffect(bool value) external onlyOwner {
486         limitsInEffect = value;
487     }
488 
489     function setMaxWalletEnabled(bool value) external onlyOwner {
490         maxWalletEnabled = value;
491     }
492 
493     function setcooldowntimer(uint256 value) external onlyOwner {
494         require(value <= 300, "cooldown timer cannot exceed 5 minutes");
495         cooldowntimer = value;
496     }
497 
498     
499     function setmaxWallet(uint256 value) external onlyOwner {
500         value = value * (10**18);
501         require(value >= _totalSupply / 100, "max wallet cannot be set to less than 1%");
502         maxWallet = value;
503     }
504 
505     // TAKES ALL BNB FROM THE CONTRACT ADDRESS AND SENDS IT TO OWNERS WALLET
506     function Sweep() external onlyOwner {
507         uint256 amountBNB = address(this).balance;
508         payable(msg.sender).transfer(amountBNB);
509     }
510 
511     function setSwapTriggerAmount(uint256 amount) public onlyOwner {
512         swapTokensAtAmount = amount * (10**18);
513     }
514 
515     function enableSwapAndLiquify(bool enabled) public onlyOwner {
516         require(swapAndLiquifyEnabled != enabled);
517         swapAndLiquifyEnabled = enabled;
518         emit EnableSwapAndLiquify(enabled);
519     }
520 
521     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
522         _setAutomatedMarketMakerPair(pair, value);
523     }
524 
525     function _setAutomatedMarketMakerPair(address pair, bool value) private {
526         automatedMarketMakerPairs[pair] = value;
527 
528         emit SetAutomatedMarketMakerPair(pair, value);
529     }
530 
531     // THIS IS THE ONE YOU USE TO TRASNFER OWNER IF U EVER DO
532     function transferAdmin(address newOwner) public onlyOwner {
533         _isExcludedFromFees[newOwner] = true;
534         canTransferBeforeTradingIsEnabled[newOwner] = true;
535         transferOwnership(newOwner);
536     }
537 
538     function updateFees(uint256 marketingBuy, uint256 marketingSell, uint256 liquidityBuy,
539                         uint256 liquiditySell, uint256 devBuy, uint256 devSell) public onlyOwner {
540 
541         buyMarketingFees = marketingBuy;
542         buyLiquidityFee = liquidityBuy;
543         sellMarketingFees = marketingSell;
544         sellLiquidityFee = liquiditySell;
545         buyDevFee = devBuy;
546         sellDevFee = devSell;
547 
548         totalSellFees = sellMarketingFees.add(sellLiquidityFee).add(sellDevFee);
549         totalBuyFees = buyMarketingFees.add(buyLiquidityFee).add(buyDevFee);
550 
551         // ABSOLUTE TAX LIMITS GO HERE
552         require(totalSellFees <= 15 && totalBuyFees <= 15, "total fees cannot be higher than 15%");
553 
554         emit UpdateFees(sellMarketingFees, sellLiquidityFee, sellDevFee, buyMarketingFees,
555                         buyLiquidityFee, buyDevFee);
556     }
557 
558     function isExcludedFromFees(address account) public view returns (bool) {
559         return _isExcludedFromFees[account];
560     }
561 
562     function _transfer(address from, address to, uint256 amount) internal override {
563 
564         require(from != address(0), "IBEP20: transfer from the zero address");
565         require(to != address(0), "IBEP20: transfer to the zero address");
566 
567         uint256 marketingFees;
568         uint256 liquidityFee;
569         uint256 devFee;
570 
571         if (!canTransferBeforeTradingIsEnabled[from]) {
572             require(tradingEnabled, "Trading has not yet been enabled");          
573         }
574 
575         if (amount == 0) {
576             super._transfer(from, to, 0);
577             return;
578         } 
579         
580         else if (
581             !swapping && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]
582         ) {
583             bool isSelling = automatedMarketMakerPairs[to];
584             if (isSelling) {
585                 marketingFees = sellMarketingFees;
586                 liquidityFee = sellLiquidityFee;
587                 devFee = sellDevFee;
588 
589                 if (limitsInEffect) {
590                 require(block.timestamp >= _holderLastTransferTimestamp[tx.origin] + cooldowntimer,
591                         "cooldown period active");
592                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
593                 }
594             } 
595             
596             else {
597                 marketingFees = buyMarketingFees;
598                 liquidityFee = buyLiquidityFee;
599                 devFee = buyDevFee;
600 
601                 if (limitsInEffect) {
602                 require(block.number > launchblock + 2,"you shall not pass");
603                 require(tx.gasprice <= gasPriceLimit,"Gas price exceeds limit.");
604                 require(_holderLastTransferBlock[tx.origin] != block.number,"Too many TX in block");
605                 require(block.timestamp >= _holderLastTransferTimestamp[tx.origin] + cooldowntimer,
606                         "cooldown period active");
607                 _holderLastTransferBlock[tx.origin] = block.number;
608                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
609             }
610 
611             if (maxWalletEnabled) {
612             uint256 contractBalanceRecipient = balanceOf(to);
613             require(contractBalanceRecipient + amount <= maxWallet,
614                     "Exceeds maximum wallet token amount." );
615             }
616             }
617 
618             uint256 totalFees = marketingFees.add(liquidityFee).add(devFee);
619 
620             uint256 contractTokenBalance = balanceOf(address(this));
621 
622             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
623 
624             if (canSwap && !automatedMarketMakerPairs[from]) {
625                 swapping = true;
626 
627                 uint256 swapTokens;
628 
629                 if (swapAndLiquifyEnabled && liquidityFee > 0) {
630                     uint256 totalBuySell = buyAmount.add(sellAmount);
631                     uint256 swapAmountBought = contractTokenBalance
632                         .mul(buyAmount)
633                         .div(totalBuySell);
634                     uint256 swapAmountSold = contractTokenBalance
635                         .mul(sellAmount)
636                         .div(totalBuySell);
637 
638                     uint256 swapBuyTokens = swapAmountBought
639                         .mul(liquidityFee)
640                         .div(totalBuyFees);
641 
642                     uint256 swapSellTokens = swapAmountSold
643                         .mul(liquidityFee)
644                         .div(totalSellFees);
645 
646                     swapTokens = swapSellTokens.add(swapBuyTokens);
647 
648                     swapAndLiquify(swapTokens);
649                 }
650 
651                 uint256 remainingBalance = swapTokensAtAmount.sub(swapTokens);
652                 swapAndSendDividends(remainingBalance);
653                 buyAmount = 0;
654                 sellAmount = 0;
655                 swapping = false;
656             }
657 
658             uint256 fees = amount.mul(totalFees).div(100);
659 
660             amount = amount.sub(fees);
661 
662             if (isSelling) {
663                 sellAmount = sellAmount.add(fees);
664             } else {
665                 buyAmount = buyAmount.add(fees);
666             }
667 
668             super._transfer(from, address(this), fees);
669            
670         }
671 
672         super._transfer(from, to, amount);
673         
674     }
675 
676 
677     function swapAndLiquify(uint256 tokens) private {
678         uint256 half = tokens.div(2);
679         uint256 otherHalf = tokens.sub(half);
680         uint256 initialBalance = address(this).balance;
681         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
682         uint256 newBalance = address(this).balance.sub(initialBalance);
683         addLiquidity(otherHalf, newBalance);
684         emit SwapAndLiquify(half, newBalance, otherHalf);
685     }
686 
687     function swapTokensForEth(uint256 tokenAmount) private {
688         address[] memory path = new address[](2);
689         path[0] = address(this);
690         path[1] = uniswapV2Router.WETH();
691         _approve(address(this), address(uniswapV2Router), tokenAmount);
692         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
693             tokenAmount,
694             0, // accept any amount of ETH
695             path,
696             address(this),
697             block.timestamp
698         );
699     }
700 
701     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
702         // approve token transfer to cover all possible scenarios
703         _approve(address(this), address(uniswapV2Router), tokenAmount);
704 
705         // add the liquidity
706         uniswapV2Router.addLiquidityETH{value: ethAmount}(
707             address(this),
708             tokenAmount,
709             0, // slippage is unavoidable
710             0, // slippage is unavoidable
711             owner(),
712             block.timestamp
713         );
714     }
715 
716     function forceSwapAndSendDividends(uint256 tokens) public onlyOwner {
717         tokens = tokens * (10**18);
718         uint256 totalAmount = buyAmount.add(sellAmount);
719         uint256 fromBuy = tokens.mul(buyAmount).div(totalAmount);
720         uint256 fromSell = tokens.mul(sellAmount).div(totalAmount);
721 
722         swapAndSendDividends(tokens);
723 
724         buyAmount = buyAmount.sub(fromBuy);
725         sellAmount = sellAmount.sub(fromSell);
726     }
727 
728     // TAX PAYOUT CODE 
729     function swapAndSendDividends(uint256 tokens) private {
730         if (tokens == 0) {
731             return;
732         }
733         swapTokensForEth(tokens);
734 
735         bool success = true;
736         bool successOp1 = true;
737         
738         uint256 _marketDevTotal = sellMarketingFees.add(sellDevFee) + buyMarketingFees.add(buyDevFee);
739 
740         uint256 feePortions;
741         if (_marketDevTotal > 0) {
742             feePortions = address(this).balance.div(_marketDevTotal);
743         }
744         uint256 marketingPayout = buyMarketingFees.add(sellMarketingFees) * feePortions;
745         uint256 devPayout = buyDevFee.add(sellDevFee) * feePortions;
746         
747         if (marketingPayout > 0) {
748             (success, ) = address(marketingWallet).call{value: marketingPayout}("");
749         }
750         
751         if (devPayout > 0) {
752             (successOp1, ) = address(devWallet).call{value: devPayout}("");
753         }
754 
755         emit SendDividends(
756             marketingPayout,
757             success && successOp1
758         );
759     }
760 
761     function airdropToWallets(
762         address[] memory airdropWallets,
763         uint256[] memory amount
764     ) external onlyOwner {
765         require(airdropWallets.length == amount.length, "Arrays must be the same length");
766         require(airdropWallets.length <= 200, "Wallets list length must be <= 200");
767         for (uint256 i = 0; i < airdropWallets.length; i++) {
768             address wallet = airdropWallets[i];
769             uint256 airdropAmount = amount[i] * (10**18);
770             super._transfer(msg.sender, wallet, airdropAmount);
771         }
772     }
773 }