1 /*
2        
3 print 
4 */
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity 0.8.17;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 library SafeMath {
21     
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31 
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35         return c;
36     }
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
59         return mod(a, b, "SafeMath: modulo by zero");
60     }
61 
62     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b != 0, errorMessage);
64         return a % b;
65     }
66 }
67 
68 interface IERC20 {
69     function totalSupply() external view returns (uint256);
70     function balanceOf(address account) external view returns (uint256);
71     function transfer(address recipient, uint256 amount) external returns (bool); 
72     function allowance(address owner, address spender) external view returns (uint256);
73     function approve(address spender, uint256 amount) external returns (bool);
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 interface IERC20Metadata is IERC20 {
80     function name() external view returns (string memory);
81     function symbol() external view returns (string memory);
82     function decimals() external view returns (uint8);
83 }
84 
85 contract ERC20 is Context, IERC20, IERC20Metadata{
86     using SafeMath for uint256;
87     mapping(address => uint256) private _balances;
88     mapping(address => mapping(address => uint256)) private _allowances;
89     uint256 internal _totalSupply;
90     string private _name;
91     string private _symbol;
92 
93     constructor(string memory name_, string memory symbol_) {
94         _name = name_;
95         _symbol = symbol_;
96     }
97 
98     function name() public view virtual override returns (string memory) {
99         return _name;
100     }
101 
102     function symbol() public view virtual override returns (string memory) {
103         return _symbol;
104     }
105 
106     function decimals() public view virtual override returns (uint8) {
107         return 18;
108     }
109 
110     function totalSupply() public view virtual override returns (uint256) {
111         return _totalSupply;
112     }
113 
114     function balanceOf(address account) public view virtual override returns (uint256) {
115         return _balances[account];
116     }
117 
118     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
119         _transfer(_msgSender(), recipient, amount);
120         return true;
121     }
122 
123     function allowance(address owner, address spender) public view virtual override returns (uint256) {
124         return _allowances[owner][spender];
125     }
126 
127     function approve(address spender, uint256 amount) public virtual override returns (bool) {
128         _approve(_msgSender(), spender, amount);
129         return true;
130     }
131 
132     function transferFrom(address sender, address recipient, uint256 amount 
133     ) public virtual override returns (bool) {
134         _transfer(sender, recipient, amount);
135         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,
136                 "BEP20: transfer amount exceeds allowance"));
137         return true;
138     }
139 
140     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
141         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
142         return true;
143     }
144 
145     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
146         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue,
147                 "BEP20: decreased allowance below zero"));
148         return true;
149     }
150 
151     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
152         require(sender != address(0), "BEP20: transfer from the zero address");
153         require(recipient != address(0), "BEP20: transfer to the zero address");
154 
155         _beforeTokenTransfer(sender, recipient, amount);
156 
157         _balances[sender] = _balances[sender].sub(amount,"BEP20: transfer amount exceeds balance");
158         _balances[recipient] = _balances[recipient].add(amount);
159         emit Transfer(sender, recipient, amount);
160     }
161 
162     function _mint(address account, uint256 amount) internal virtual {
163         require(account != address(0), "BEP20: mint to the zero address");
164 
165         _beforeTokenTransfer(address(0), account, amount);
166 
167         _totalSupply = _totalSupply.add(amount);
168         _balances[account] = _balances[account].add(amount);
169         emit Transfer(address(0), account, amount);
170     }
171 
172     function _approve(address owner, address spender, uint256 amount) internal virtual {
173         require(owner != address(0), "BEP20: approve from the zero address");
174         require(spender != address(0), "BEP20: approve to the zero address");
175 
176         _allowances[owner][spender] = amount;
177         emit Approval(owner, spender, amount);
178     }
179 
180     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
181 }
182 
183 abstract contract Ownable is Context {
184 
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     constructor() {
190         address msgSender = _msgSender();
191         _owner = msgSender;
192         emit OwnershipTransferred(address(0), msgSender);
193     }
194 
195     function owner() public view returns (address) {
196         return _owner;
197     }
198 
199     modifier onlyOwner() {
200         require(_owner == _msgSender(), "Ownable: caller is not the owner");
201         _;
202     }
203 
204     function renounceOwnership() public virtual onlyOwner {
205         emit OwnershipTransferred(_owner, address(0));
206         _owner = address(0);
207     }
208 
209     function transferOwnership(address newOwner) public virtual onlyOwner {
210         require(newOwner != address(0), "Ownable: new owner is the zero address");
211         emit OwnershipTransferred(_owner, newOwner);
212         _owner = newOwner;
213     }
214 }
215 
216 interface IUniswapV2Pair {
217     event Approval(address indexed owner, address indexed spender, uint256 value);
218     event Transfer(address indexed from, address indexed to, uint256 value);
219     function name() external pure returns (string memory);
220     function symbol() external pure returns (string memory);
221     function decimals() external pure returns (uint8);
222     function totalSupply() external view returns (uint256);
223     function balanceOf(address owner) external view returns (uint256);
224     function allowance(address owner, address spender) external view returns (uint256);
225     function approve(address spender, uint256 value) external returns (bool);
226     function transfer(address to, uint256 value) external returns (bool);
227     function transferFrom(address from, address to, uint256 value) external returns (bool);
228     function DOMAIN_SEPARATOR() external view returns (bytes32);
229     function PERMIT_TYPEHASH() external pure returns (bytes32);
230     function nonces(address owner) external view returns (uint256);
231 
232     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r,
233                     bytes32 s) external;
234 
235     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out,
236                uint256 amount1Out, address indexed to);
237     event Sync(uint112 reserve0, uint112 reserve1);
238 
239     function MINIMUM_LIQUIDITY() external pure returns (uint256);
240     function factory() external view returns (address);
241     function token0() external view returns (address);
242     function token1() external view returns (address);
243     function getReserves() external view returns (uint112 reserve0, uint112 reserve1,
244                                                   uint32 blockTimestampLast);
245 
246     function price0CumulativeLast() external view returns (uint256);
247     function price1CumulativeLast() external view returns (uint256);
248     function kLast() external view returns (uint256);
249 
250     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
251 
252     function skim(address to) external;
253     function sync() external;
254     function initialize(address, address) external;
255 }
256 
257 interface IUniswapV2Factory {
258     function createPair(address tokenA, address tokenB) external returns (address pair);
259 }
260 
261 interface IUniswapV2Router01 {
262     function factory() external pure returns (address);
263     function WETH() external pure returns (address);
264 
265     function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired,
266                           uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline)
267                           external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
268 
269     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin,
270                              uint256 amountETHMin, address to, uint256 deadline)
271                              external payable returns (uint256 amountToken, uint256 amountETH,
272                              uint256 liquidity);
273 
274     function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin,
275                              uint256 amountBMin, address to, uint256 deadline) 
276                              external returns (uint256 amountA, uint256 amountB);
277 
278     function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin,
279                                 uint256 amountETHMin, address to, uint256 deadline) 
280                                 external returns (uint256 amountToken, uint256 amountETH);
281 
282     function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity,
283                                        uint256 amountAMin, uint256 amountBMin, address to,
284                                        uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) 
285                                        external returns (uint256 amountA, uint256 amountB);
286 
287     function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin,
288                                           uint256 amountETHMin, address to, uint256 deadline,
289                                           bool approveMax, uint8 v, bytes32 r, bytes32 s) 
290                                           external returns (uint256 amountToken, uint256 amountETH);
291 
292     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
293                                       address to, uint256 deadline) 
294                                       external returns (uint256[] memory amounts);
295 
296     function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path,
297                                       address to, uint256 deadline) 
298                                       external returns (uint256[] memory amounts);
299 
300     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to,
301                                    uint256 deadline) 
302                                    external payable returns (uint256[] memory amounts);
303 
304     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path,
305                                    address to, uint256 deadline) 
306                                    external returns (uint256[] memory amounts);
307 
308     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
309                                    address to, uint256 deadline) 
310                                    external returns (uint256[] memory amounts);
311 
312     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to,
313                                    uint256 deadline) 
314                                    external payable returns (uint256[] memory amounts);
315 
316     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) 
317                    external pure returns (uint256 amountB);
318 
319     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) 
320                           external pure returns (uint256 amountOut);
321 
322     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) 
323                          external pure returns (uint256 amountIn);
324 
325     function getAmountsOut(uint256 amountIn, address[] calldata path)
326                            external view returns (uint256[] memory amounts);
327 
328     function getAmountsIn(uint256 amountOut, address[] calldata path)
329                           external view returns (uint256[] memory amounts);
330 }
331 
332 interface IUniswapV2Router02 is IUniswapV2Router01 {
333     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity,
334         uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) 
335         external returns (uint256 amountETH);
336 
337     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity,
338         uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax,
339         uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH);
340 
341     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin,
342         address[] calldata path, address to, uint256 deadline) external;
343 
344     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin,
345         address[] calldata path, address to, uint256 deadline) external payable;
346 
347     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin,
348         address[] calldata path, address to, uint256 deadline) external;
349 }
350 
351 contract FreeRoss is ERC20, Ownable { 
352     using SafeMath for uint256;
353 
354     IUniswapV2Router02 public uniswapV2Router;
355 
356     address public uniswapV2Pair;
357     address public DEAD = 0x000000000000000000000000000000000000dEaD;
358     bool private swapping;
359     bool public tradingEnabled = false;
360 
361     uint256 internal sellAmount = 1;
362     uint256 internal buyAmount = 1;
363 
364     uint256 private totalSellFees;
365     uint256 private totalBuyFees;
366 
367     address payable public marketingWallet; 
368     address payable public DonationWallet;
369 
370 
371     uint256 public maxWallet;
372     uint256 public maxTX;
373     uint256 public swapTokensAtAmount;
374     uint256 public sellMarketingFees;
375     uint256 public sellBurnFee;
376     uint256 public buyMarketingFees;
377     uint256 public buyBurnFee;
378     uint256 public buyDonationFee;
379     uint256 public sellDonationFee;
380 
381 
382     bool public swapAndLiquifyEnabled = false;
383 
384     mapping(address => bool) private _isExcludedFromFees;
385     mapping(address => bool) public automatedMarketMakerPairs;
386     mapping(address => bool) private canTransferBeforeTradingIsEnabled;
387 
388     bool public limitsInEffect = true; 
389     uint256 private gasPriceLimit; // MAX GWEI
390     mapping(address => uint256) private _holderLastTransferBlock; // FOR 1TX PER BLOCK
391     mapping(address => uint256) private _holderLastTransferTimestamp; // FOR COOLDOWN
392     uint256 public launchblock; // FOR DEADBLOCKS
393     uint256 public delay;
394     uint256 private deadblocks;
395     uint256 public launchtimestamp; 
396     uint256 public cooldowntimer = 30; // DEFAULT COOLDOWN TIMER
397 
398     event EnableSwapAndLiquify(bool enabled);
399     event SetPreSaleWallet(address wallet);
400     event updateMarketingWallet(address wallet);
401     event updateDonationWallet(address wallet);
402     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
403     event TradingEnabled();
404 
405     event UpdateFees(uint256 sellMarketingFees, uint256 sellBurnFee, uint256 buyMarketingFees,
406                      uint256 buyBurnFee, uint256 buyDonationFee, uint256 sellDonationFee);
407 
408     event Airdrop(address holder, uint256 amount);
409     event ExcludeFromFees(address indexed account, bool isExcluded);
410     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
411     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
412     event SendDividends(uint256 opAmount, bool success);
413 
414     constructor() ERC20("FreeRoss", "ROSS") { 
415         marketingWallet = payable(0x4e660b34c1174F6F70efc063e83A97838ee37FfF); 
416         DonationWallet = payable(0x823743E15E780e7c78d2da526cF26420daF33e0e); 
417         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
418 
419         
420         buyMarketingFees = 1;
421         sellMarketingFees = 1;
422         buyBurnFee = 0;
423         sellBurnFee = 0;
424         buyDonationFee = 2;
425         sellDonationFee = 2;
426 
427 
428         
429         totalBuyFees = buyMarketingFees.add(buyDonationFee);
430         totalSellFees = sellMarketingFees.add(sellDonationFee);
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
442         uint256 totalSupply = (420_690_000) * (10**18); // TOTAL SUPPLY IS SET HERE
443         _mint(owner(), totalSupply); // only time internal mint function is ever called is to create supply
444         swapTokensAtAmount = _totalSupply / 1000;
445         canTransferBeforeTradingIsEnabled[owner()] = true;
446         canTransferBeforeTradingIsEnabled[address(this)] = true;
447     }
448 
449     function decimals() public view virtual override returns (uint8) {
450         return 18;
451     }
452 
453     receive() external payable {}
454 
455     function enableTrading(uint256 initialMaxGwei, uint256 initialMaxWallet, uint256 initialMaxTX,
456                            uint256 setDelay) external onlyOwner {
457         initialMaxWallet = initialMaxWallet * (10**18);
458         initialMaxTX = initialMaxTX * (10**18);
459         require(!tradingEnabled);
460         require(initialMaxWallet >= _totalSupply / 1000,"cannot set below 0.1%");
461         require(initialMaxTX >= _totalSupply / 1000,"cannot set below 0.1%");
462         maxWallet = initialMaxWallet;
463         maxTX = initialMaxTX;
464         gasPriceLimit = initialMaxGwei * 1 gwei;
465         tradingEnabled = true;
466         launchblock = block.number;
467         launchtimestamp = block.timestamp;
468         delay = setDelay;
469         emit TradingEnabled();
470     }
471     
472     function setMarketingWallet(address wallet) external onlyOwner {
473         _isExcludedFromFees[wallet] = true;
474         marketingWallet = payable(wallet);
475         emit updateMarketingWallet(wallet);
476     }
477 
478     function setDonationWallet(address wallet) external onlyOwner {
479         _isExcludedFromFees[wallet] = true;
480         DonationWallet = payable(wallet);
481         emit updateDonationWallet(wallet);
482     }
483 
484 
485     
486     function setExcludeFees(address account, bool excluded) public onlyOwner {
487         _isExcludedFromFees[account] = excluded;
488         emit ExcludeFromFees(account, excluded);
489     }
490 
491     function setCanTransferBefore(address wallet, bool enable) external onlyOwner {
492         canTransferBeforeTradingIsEnabled[wallet] = enable;
493     }
494 
495     function setLimitsInEffect(bool value) external onlyOwner {
496         limitsInEffect = value;
497     }
498 
499       function setmaxWallet(uint256 value) external onlyOwner {
500         value = value * (10**18);
501         require(value >= _totalSupply / 1000, "max wallet cannot be set to less than 0.1%");
502         maxWallet = value;
503     }
504 
505         function setmaxTX(uint256 value) external onlyOwner {
506         value = value * (10**18);
507         require(value >= _totalSupply / 1000, "max tx cannot be set to less than 0.1%");
508         maxTX = value;
509     }
510 
511     function setGasPriceLimit(uint256 GWEI) external onlyOwner {
512         require(GWEI >= 50, "can never be set below 50");
513         gasPriceLimit = GWEI * 1 gwei;
514     }
515 
516     function setcooldowntimer(uint256 value) external onlyOwner {
517         require(value <= 300, "cooldown timer cannot exceed 5 minutes");
518         cooldowntimer = value;
519     }
520 
521     
522 
523     function Sweep() external onlyOwner {
524         uint256 amountETH = address(this).balance;
525         payable(msg.sender).transfer(amountETH);
526     }
527 
528     function setSwapTriggerAmount(uint256 amount) public onlyOwner {
529         swapTokensAtAmount = amount * (10**18);
530     }
531 
532     function enableSwapAndLiquify(bool enabled) public onlyOwner {
533         require(swapAndLiquifyEnabled != enabled);
534         swapAndLiquifyEnabled = enabled;
535         emit EnableSwapAndLiquify(enabled);
536     }
537 
538     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
539         _setAutomatedMarketMakerPair(pair, value);
540     }
541 
542     function _setAutomatedMarketMakerPair(address pair, bool value) private {
543         automatedMarketMakerPairs[pair] = value;
544 
545         emit SetAutomatedMarketMakerPair(pair, value);
546     }
547 
548     function transferAdmin(address newOwner) public onlyOwner {
549         _isExcludedFromFees[newOwner] = true;
550         canTransferBeforeTradingIsEnabled[newOwner] = true;
551         transferOwnership(newOwner);
552     }
553 
554     function updateFees(uint256 marketingBuy, uint256 marketingSell, uint256 burnBuy,
555                         uint256 burnSell, uint256 DonationBuy, uint256 DonationSell) public onlyOwner {
556 
557         buyMarketingFees = marketingBuy;
558         buyBurnFee = burnBuy;
559         sellMarketingFees = marketingSell;
560         sellBurnFee = burnSell;
561         buyDonationFee = DonationBuy;
562         sellDonationFee = DonationSell;
563 
564 
565         totalSellFees = sellMarketingFees.add(sellDonationFee);
566         totalBuyFees = buyMarketingFees.add(buyDonationFee);
567 
568 
569         require(burnBuy <= 1 && burnSell <= 1, "Burn Fees cannot exceed 1%");
570         require(totalSellFees <= 4 && totalBuyFees <= 4, "total fees cannot be higher than 4%");
571 
572         emit UpdateFees(sellMarketingFees, sellBurnFee, sellDonationFee, buyMarketingFees,
573                         buyBurnFee, buyDonationFee);
574     }
575 
576     function isExcludedFromFees(address account) public view returns (bool) {
577         return _isExcludedFromFees[account];
578     }
579 
580     function _transfer(address from, address to, uint256 amount) internal override {
581 
582         
583         require(from != address(0), "IBEP20: transfer from the zero address");
584         require(to != address(0), "IBEP20: transfer to the zero address");
585 
586         uint256 marketingFees;
587         uint256 burnFee;
588         uint256 DonationFee;
589  
590 
591         if (!canTransferBeforeTradingIsEnabled[from]) {
592             require(tradingEnabled, "Trading has not yet been enabled");          
593         }
594 
595         if (amount == 0) {
596             super._transfer(from, to, 0);
597             return;
598         } 
599 
600         if (to == DEAD) {
601             super._transfer(from, to, amount);
602             _totalSupply = _totalSupply.sub(amount);
603             return;
604         }
605         
606         else if (
607             !swapping && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
608             bool isSelling = automatedMarketMakerPairs[to];
609             if (isSelling) {
610                 marketingFees = sellMarketingFees;
611                 burnFee = sellBurnFee;
612                 DonationFee = sellDonationFee;
613  
614 
615                  if (limitsInEffect) {
616                 require(block.timestamp >= _holderLastTransferTimestamp[tx.origin] + cooldowntimer,
617                         "cooldown period active");
618                 require(amount <= maxTX,"above max transaction limit");
619                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
620 
621                 }
622             } 
623             
624             else {
625                 marketingFees = buyMarketingFees;
626                 burnFee = buyBurnFee;
627                 DonationFee = buyDonationFee;
628  
629 
630                if (limitsInEffect) {
631                 require(block.timestamp > launchtimestamp + delay,"you shall not pass");
632                 require(tx.gasprice <= gasPriceLimit,"Gas price exceeds limit.");
633                 require(_holderLastTransferBlock[tx.origin] != block.number,"Too many TX in block");
634                 require(amount <= maxTX,"above max transaction limit");
635                 _holderLastTransferBlock[tx.origin] = block.number;
636             }
637 
638            
639                 uint256 contractBalanceRecipient = balanceOf(to);
640                 require(contractBalanceRecipient + amount <= maxWallet,"Exceeds maximum wallet token amount." );
641             
642             }
643 
644             uint256 totalFees = marketingFees.add(DonationFee);
645 
646             uint256 contractTokenBalance = balanceOf(address(this));
647 
648             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
649 
650             if (canSwap && isSelling) {
651                 swapping = true;
652              
653                 uint256 swapBalance = balanceOf(address(this));
654                 swapAndSendDividends(swapBalance);
655                 buyAmount = 1;
656                 sellAmount = 1;
657                 swapping = false;
658             }
659 
660             uint256 fees = amount.mul(totalFees).div(100);
661             uint256 burntokens = amount.mul(burnFee).div(100);
662 
663 
664             amount = amount.sub(fees + burntokens) ;
665 
666             if (isSelling) {
667                 sellAmount = sellAmount.add(fees);
668             } else {
669                 buyAmount = buyAmount.add(fees);
670             }
671 
672             super._transfer(from, address(this), fees);
673 
674             if (burntokens > 0) {
675                 super._transfer(from, DEAD, burntokens);
676                 _totalSupply = _totalSupply.sub(burntokens);
677             }
678 
679 
680            
681         }
682 
683         super._transfer(from, to, amount);
684         
685     }
686 
687     function swapAndLiquify(uint256 tokens) private {
688         uint256 half = tokens.div(2);
689         uint256 otherHalf = tokens.sub(half);
690         uint256 initialBalance = address(this).balance;
691         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
692         uint256 newBalance = address(this).balance.sub(initialBalance);
693         addLiquidity(otherHalf, newBalance);
694         emit SwapAndLiquify(half, newBalance, otherHalf);
695     }
696 
697     function swapTokensForEth(uint256 tokenAmount) private {
698         address[] memory path = new address[](2);
699         path[0] = address(this);
700         path[1] = uniswapV2Router.WETH();
701         _approve(address(this), address(uniswapV2Router), tokenAmount);
702         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
703             tokenAmount,
704             0, // accept any amount of ETH
705             path,
706             address(this),
707             block.timestamp
708         );
709     }
710 
711     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
712         // approve token transfer to cover all possible scenarios
713         _approve(address(this), address(uniswapV2Router), tokenAmount);
714 
715         // add the liquidity
716         uniswapV2Router.addLiquidityETH{value: ethAmount}(
717             address(this),
718             tokenAmount,
719             0, // slippage is unavoidable
720             0, // slippage is unavoidable
721             owner(),
722             block.timestamp
723         );
724     }
725 
726     function forceSwapAndSendDividends(uint256 tokens) public onlyOwner {
727         tokens = tokens * (10**18);
728         uint256 totalAmount = buyAmount.add(sellAmount);
729         uint256 fromBuy = tokens.mul(buyAmount).div(totalAmount);
730         uint256 fromSell = tokens.mul(sellAmount).div(totalAmount);
731 
732         swapAndSendDividends(tokens);
733 
734         buyAmount = buyAmount.sub(fromBuy);
735         sellAmount = sellAmount.sub(fromSell);
736     }
737 
738     // TAX PAYOUT CODE 
739     function swapAndSendDividends(uint256 tokens) private {
740         if (tokens == 0) {
741             return;
742         }
743         swapTokensForEth(tokens);
744 
745         bool success = true;
746         bool successOp1 = true;
747         
748         uint256 _completeFees = sellMarketingFees.add(sellDonationFee) + buyMarketingFees.add(buyDonationFee);
749 
750         uint256 feePortions;
751         if (_completeFees > 0) {
752             feePortions = address(this).balance.div(_completeFees);
753         }
754         uint256 marketingPayout = buyMarketingFees.add(sellMarketingFees) * feePortions;
755         uint256 DonationPayout = buyDonationFee.add(sellDonationFee) * feePortions;
756         
757         if (marketingPayout > 0) {
758             (success, ) = address(marketingWallet).call{value: marketingPayout}("");
759         }
760         
761         if (DonationPayout > 0) {
762             (successOp1, ) = address(DonationWallet).call{value: DonationPayout}("");
763         }
764 
765         emit SendDividends(
766             marketingPayout + DonationPayout,
767             success && successOp1
768         );
769     }
770 
771     function airdropToWallets(
772         address[] memory airdropWallets,
773         uint256[] memory amount
774     ) external onlyOwner {
775         require(airdropWallets.length == amount.length, "Arrays must be the same length");
776         require(airdropWallets.length <= 200, "Wallets list length must be <= 200");
777         for (uint256 i = 0; i < airdropWallets.length; i++) {
778             address wallet = airdropWallets[i];
779             uint256 airdropAmount = amount[i] * (10**18);
780             super._transfer(msg.sender, wallet, airdropAmount);
781         }
782     }
783 }