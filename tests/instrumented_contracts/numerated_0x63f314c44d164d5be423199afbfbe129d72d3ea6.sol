1 /*
2 BATTLEGROUND $BATTLE
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.17;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 library SafeMath {
20     
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30 
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34         return c;
35     }
36 
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50 
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         return c;
55     }
56 
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         return mod(a, b, "SafeMath: modulo by zero");
59     }
60 
61     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b != 0, errorMessage);
63         return a % b;
64     }
65 }
66 
67 interface IERC20 {
68     function totalSupply() external view returns (uint256);
69     function balanceOf(address account) external view returns (uint256);
70     function transfer(address recipient, uint256 amount) external returns (bool); 
71     function allowance(address owner, address spender) external view returns (uint256);
72     function approve(address spender, uint256 amount) external returns (bool);
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74     event Transfer(address indexed from, address indexed to, uint256 value);
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76      
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
88     mapping(address => mapping(address => uint256)) public  _allowances;
89     uint256 internal _totalSupply;
90     string private _name;
91     string private _symbol;
92 
93     constructor(string memory name_, string memory symbol_) {
94         _name = name_;
95         _symbol = symbol_;
96         
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
115 
116     function balanceOf(address account) public view virtual override returns (uint256) {
117         return _balances[account];
118     }
119 
120     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
121         _transfer(_msgSender(), recipient, amount);
122         return true;
123     }
124 
125     function allowance(address owner, address spender) public view virtual override returns (uint256) {
126         return _allowances[owner][spender];
127     }
128 
129     function approve(address spender, uint256 amount) public virtual override returns (bool) {
130         _approve(_msgSender(), spender, amount);
131         return true;
132     }
133 
134 
135 
136     function transferFrom(address sender, address recipient, uint256 amount 
137     ) public virtual override returns (bool) {
138         _transfer(sender, recipient, amount);
139         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,
140                 "BEP20: transfer amount exceeds allowance"));
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
151                 "BEP20: decreased allowance below zero"));
152         return true;
153     }
154 
155     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
156         require(sender != address(0), "BEP20: transfer from the zero address");
157         require(recipient != address(0), "BEP20: transfer to the zero address");
158 
159         _beforeTokenTransfer(sender, recipient, amount);
160 
161         _balances[sender] = _balances[sender].sub(amount,"BEP20: transfer amount exceeds balance");
162         _balances[recipient] = _balances[recipient].add(amount);
163         emit Transfer(sender, recipient, amount);
164     }
165 
166     function _mint(address account, uint256 amount) internal virtual {
167         require(account != address(0), "BEP20: mint to the zero address");
168 
169         _beforeTokenTransfer(address(0), account, amount);
170 
171         _totalSupply = _totalSupply.add(amount);
172         _balances[account] = _balances[account].add(amount);
173         emit Transfer(address(0), account, amount);
174     }
175 
176     function _burn(address account, uint256 amount) internal virtual {
177         require(account != address(0), "ERC20: burn from the zero address");
178 
179         _beforeTokenTransfer(account, address(0), amount);
180 
181         _balances[account] = _balances[account].sub(
182             amount,
183             "ERC20: burn amount exceeds balance"
184         );
185         _totalSupply = _totalSupply.sub(amount);
186         emit Transfer(account, address(0), amount);
187     }
188 
189     function _approve(address owner, address spender, uint256 amount) internal virtual {
190         require(owner != address(0), "BEP20: approve from the zero address");
191         require(spender != address(0), "BEP20: approve to the zero address");
192 
193         _allowances[owner][spender] = amount;
194         emit Approval(owner, spender, amount);
195     }
196 
197     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
198 }
199 
200 abstract contract Ownable is Context {
201 
202     address private _owner;
203     
204     
205 
206 
207     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
208 
209     constructor() {
210         address msgSender = _msgSender();
211         _owner = msgSender;
212         emit OwnershipTransferred(address(0), msgSender);
213     }
214 
215     function owner() public view returns (address) {
216         return _owner;
217     }
218 
219     modifier onlyOwner() {
220         require(_owner == _msgSender(), "Ownable: caller is not the owner");
221         _;
222     }
223 
224     function renounceOwnership() public virtual onlyOwner {
225         emit OwnershipTransferred(_owner, address(0));
226         _owner = address(0);
227     }
228 
229    
230 
231     function transferOwnership(address newOwner) public virtual onlyOwner {
232         require(newOwner != address(0), "Ownable: new owner is the zero address");
233         emit OwnershipTransferred(_owner, newOwner);
234         _owner = newOwner;
235     }
236 }
237 
238 interface IUniswapV2Pair {
239     event Approval(address indexed owner, address indexed spender, uint256 value);
240     event Transfer(address indexed from, address indexed to, uint256 value);
241     function name() external pure returns (string memory);
242     function symbol() external pure returns (string memory);
243     function decimals() external pure returns (uint8);
244     function totalSupply() external view returns (uint256);
245     function balanceOf(address owner) external view returns (uint256);
246     function allowance(address owner, address spender) external view returns (uint256);
247     function approve(address spender, uint256 value) external returns (bool);
248     function transfer(address to, uint256 value) external returns (bool);
249     function transferFrom(address from, address to, uint256 value) external returns (bool);
250     function DOMAIN_SEPARATOR() external view returns (bytes32);
251     function PERMIT_TYPEHASH() external pure returns (bytes32);
252     function nonces(address owner) external view returns (uint256);
253 
254     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r,
255                     bytes32 s) external;
256 
257     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out,
258                uint256 amount1Out, address indexed to);
259     event Burn(
260         address indexed sender,
261         uint256 amount0,
262         uint256 amount1,
263         address indexed to
264     );
265     event Sync(uint112 reserve0, uint112 reserve1);
266 
267     function MINIMUM_LIQUIDITY() external pure returns (uint256);
268     function factory() external view returns (address);
269     function token0() external view returns (address);
270     function token1() external view returns (address);
271     function getReserves() external view returns (uint112 reserve0, uint112 reserve1,
272                                                   uint32 blockTimestampLast);
273 
274     function price0CumulativeLast() external view returns (uint256);
275     function price1CumulativeLast() external view returns (uint256);
276     function kLast() external view returns (uint256);
277     function mint(address to) external returns (uint256 liquidity);
278     function burn(address to)
279         external
280         returns (uint256 amount0, uint256 amount1);
281     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
282 
283     function skim(address to) external;
284     function sync() external;
285     function initialize(address, address) external;
286 }
287 
288 interface IUniswapV2Factory {
289     function createPair(address tokenA, address tokenB) external returns (address pair);
290 }
291 
292 interface IUniswapV2Router01 {
293     function factory() external pure returns (address);
294     function WETH() external pure returns (address);
295 
296     function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired,
297                           uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline)
298                           external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
299 
300     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin,
301                              uint256 amountETHMin, address to, uint256 deadline)
302                              external payable returns (uint256 amountToken, uint256 amountETH,
303                              uint256 liquidity);
304 
305     function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin,
306                              uint256 amountBMin, address to, uint256 deadline) 
307                              external returns (uint256 amountA, uint256 amountB);
308 
309     function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin,
310                                 uint256 amountETHMin, address to, uint256 deadline) 
311                                 external returns (uint256 amountToken, uint256 amountETH);
312 
313     function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity,
314                                        uint256 amountAMin, uint256 amountBMin, address to,
315                                        uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) 
316                                        external returns (uint256 amountA, uint256 amountB);
317 
318     function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin,
319                                           uint256 amountETHMin, address to, uint256 deadline,
320                                           bool approveMax, uint8 v, bytes32 r, bytes32 s) 
321                                           external returns (uint256 amountToken, uint256 amountETH);
322 
323     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
324                                       address to, uint256 deadline) 
325                                       external returns (uint256[] memory amounts);
326 
327     function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path,
328                                       address to, uint256 deadline) 
329                                       external returns (uint256[] memory amounts);
330 
331     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to,
332                                    uint256 deadline) 
333                                    external payable returns (uint256[] memory amounts);
334 
335     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path,
336                                    address to, uint256 deadline) 
337                                    external returns (uint256[] memory amounts);
338 
339     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
340                                    address to, uint256 deadline) 
341                                    external returns (uint256[] memory amounts);
342 
343     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to,
344                                    uint256 deadline) 
345                                    external payable returns (uint256[] memory amounts);
346 
347     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) 
348                    external pure returns (uint256 amountB);
349 
350     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) 
351                           external pure returns (uint256 amountOut);
352 
353     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) 
354                          external pure returns (uint256 amountIn);
355 
356     function getAmountsOut(uint256 amountIn, address[] calldata path)
357                            external view returns (uint256[] memory amounts);
358 
359     function getAmountsIn(uint256 amountOut, address[] calldata path)
360                           external view returns (uint256[] memory amounts);
361 }
362 
363 interface IUniswapV2Router02 is IUniswapV2Router01 {
364     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity,
365         uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) 
366         external returns (uint256 amountETH);
367 
368     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity,
369         uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax,
370         uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH);
371 
372     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin,
373         address[] calldata path, address to, uint256 deadline) external;
374 
375     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin,
376         address[] calldata path, address to, uint256 deadline) external payable;
377 
378     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin,
379         address[] calldata path, address to, uint256 deadline) external;
380 }
381 
382 interface ITrueDefiSwap {
383     function triggeredTokenSent(uint256, address) external;
384 }
385 
386 contract Battleground is ERC20, Ownable { 
387     using SafeMath for uint256;
388 
389     IUniswapV2Router02 public uniswapV2Router;
390 
391     address public uniswapV2Pair;
392     address public DEAD = 0x000000000000000000000000000000000000dEaD;
393     bool private swapping;
394     bool public tradingEnabled = false;
395 
396     uint256 internal sellAmount = 1;
397     uint256 internal buyAmount = 1;
398 
399     uint256 private totalSellFees;
400     uint256 private totalBuyFees;
401 
402     address payable public marketingWallet; 
403     address payable public DevWallet;
404     address public _gameContract;
405     address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
406 
407     bool public enabledPublicTrading;
408     address tefiRouter;
409     mapping(address => bool) public whitelistForPublicTrade;    
410 
411 
412     uint256 public maxWallet;
413     uint256 public maxTX;
414     uint256 public swapTokensAtAmount;
415     uint256 public sellMarketingFees;
416     uint256 public sellLiquidityFee;
417     uint256 public sellBurnFee;
418     uint256 public buyMarketingFees;
419     uint256 public buyBurnFee;
420     uint256 public buyLiquidityFee;
421     uint256 public buyDevFee;
422     uint256 public sellDevFee;
423     uint256 public transferFee;
424 
425 
426     bool public swapAndLiquifyEnabled = false;
427 
428     mapping(address => bool) private _isExcludedFromFees;
429     mapping(address => bool) public automatedMarketMakerPairs;
430     mapping(address => bool) private canTransferBeforeTradingIsEnabled;
431 
432     bool public limitsInEffect = true; 
433     uint256 private gasPriceLimit; // MAX GWEI
434     mapping(address => uint256) private _holderLastTransferBlock; // FOR 1TX PER BLOCK
435     mapping(address => uint256) private _holderLastTransferTimestamp; // FOR COOLDOWN
436     uint256 public launchblock; // FOR DEADBLOCKS
437     uint256 public delay;
438     uint256 private deadblocks;
439     uint256 public launchtimestamp; 
440     uint256 public cooldowntimer = 30; // DEFAULT COOLDOWN TIMER
441 
442     event EnableSwapAndLiquify(bool enabled);
443     event SetPreSaleWallet(address wallet);
444     event updateMarketingWallet(address wallet);
445     event updateDevWallet(address wallet);
446     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
447     event UpdategameContract(address indexed newAddress , address indexed oldAddress);
448     event TradingEnabled();
449 
450     event UpdateFees(uint256 sellMarketingFees, uint256 sellBurnFee, uint256 buyMarketingFees,
451                      uint256 buyBurnFee, uint256 buyDevFee, uint256 sellDevFee, uint256 sellLiquidityFee , uint256 buyLiquidityFee);
452 
453     event Airdrop(address holder, uint256 amount);
454     event UpdateTransferFee(uint256 transferFee);
455     event ExcludeFromFees(address indexed account, bool isExcluded);
456     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
457     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
458     event SendDividends(uint256 opAmount, bool success);
459 
460     constructor() ERC20("Battleground", "BATTLE") { 
461         marketingWallet = payable(0x5EC3B7fD49B76dD1450c003a1762984495DFb139); 
462         DevWallet = payable(0x169581C525aF468F4f0cD10A8CFa88621D3330B2); 
463         _gameContract = 0x074228888Aae2A5bf1A823826E75b5F695882919;
464 
465         
466         buyMarketingFees = 2;
467         sellMarketingFees = 2;
468         buyLiquidityFee = 2;
469         sellLiquidityFee = 2;
470         buyBurnFee = 0;
471         sellBurnFee = 0;
472         buyDevFee = 1;
473         sellDevFee = 1;
474         transferFee = 0;
475 
476 
477         
478         totalBuyFees = buyMarketingFees
479         .add(buyDevFee)
480         .add(buyLiquidityFee)
481         
482         ;
483         totalSellFees = sellMarketingFees
484         .add(sellDevFee)
485         .add(sellLiquidityFee)
486         ;
487 
488 
489 
490         _isExcludedFromFees[address(this)] = true;
491         _isExcludedFromFees[msg.sender] = true;
492         _isExcludedFromFees[marketingWallet] = true;
493 
494         uint256 totalSupply = (1_000_000_000) * (10**18); // TOTAL SUPPLY IS SET HERE
495         _mint(owner(), totalSupply); // only time internal mint function is ever called is to create supply
496         swapTokensAtAmount = _totalSupply / 1000;
497         canTransferBeforeTradingIsEnabled[owner()] = true;
498         canTransferBeforeTradingIsEnabled[address(this)] = true;
499         whitelistForPublicTrade[msg.sender] = true;
500     }
501 
502 
503     function decimals() public view virtual override returns (uint8) {
504         return 18;
505     }
506 
507     receive() external payable {}
508 
509     function EnableAntiBotTrading(address _router, uint256 initialMaxGwei, uint256 initialMaxWallet, uint256 initialMaxTX,
510                            uint256 setDelay) external onlyOwner {
511         tefiRouter = _router;
512         if (_router != address(0)) {
513             whitelistForPublicTrade[_router] = true;
514             _isExcludedFromFees[_router] = true;
515         }
516         
517         initialMaxWallet = initialMaxWallet * (10**18);
518         initialMaxTX = initialMaxTX * (10**18);
519         require(!tradingEnabled);
520         require(initialMaxWallet >= _totalSupply / 1000,"cannot set below 0.1%");
521         require(initialMaxTX >= _totalSupply / 1000,"cannot set below 0.1%");
522         maxWallet = initialMaxWallet;
523         maxTX = initialMaxTX;
524         gasPriceLimit = initialMaxGwei * 1 gwei;
525         tradingEnabled = true;
526         launchblock = block.number;
527         launchtimestamp = block.timestamp;
528         delay = setDelay;
529         emit TradingEnabled();
530     }
531 
532     function updateTrueDefiRouter(address _router) external onlyOwner {
533         tefiRouter = _router;
534         if (_router != address(0)) {
535             whitelistForPublicTrade[_router] = true;
536             _isExcludedFromFees[_router] = true;
537         }
538     }    
539 
540     function isTrading(address _sender, address _recipient)
541         internal view
542         returns (uint)
543     {
544         if (automatedMarketMakerPairs[_sender] && _recipient != address(uniswapV2Router)) return 1; // Buy Case
545 
546         if (automatedMarketMakerPairs[_recipient]) return 2; // Sell Case
547 
548         return 0;
549     }    
550     
551     function setWhitelistForPublicTrade(address _addr, bool _flag) external onlyOwner {
552         whitelistForPublicTrade[_addr] = _flag;    
553     }    
554     
555     function setPublicTrading() external onlyOwner {
556         require(!enabledPublicTrading);        
557         enabledPublicTrading = true;    
558     }    
559     
560     function setMarketingWallet(address wallet) external onlyOwner {
561         _isExcludedFromFees[wallet] = true;
562         marketingWallet = payable(wallet);
563         emit updateMarketingWallet(wallet);
564     }
565 
566     
567 
568     function setDevWallet(address wallet) external onlyOwner {
569         _isExcludedFromFees[wallet] = true;
570         DevWallet = payable(wallet);
571         emit updateDevWallet(wallet);
572     }
573 
574      function NewgameContract(address _newAddress ) external onlyOwner {
575         require(_newAddress != address(0), "Invalid address");
576         
577 
578         address oldAddress = _gameContract;
579         _gameContract = _newAddress;
580 
581         emit UpdategameContract(_newAddress, oldAddress);
582     }
583 
584     
585     function setExcludeFees(address account, bool excluded) public onlyOwner {
586         _isExcludedFromFees[account] = excluded;
587         emit ExcludeFromFees(account, excluded);
588     }
589 
590     function setCanTransferBefore(address wallet, bool enable) external onlyOwner {
591         canTransferBeforeTradingIsEnabled[wallet] = enable;
592     }
593 
594     function setLimitsInEffect(bool value) external onlyOwner {
595         limitsInEffect = value;
596     }
597 
598       function setmaxWallet(uint256 value) external onlyOwner {
599         value = value * (10**18);
600         require(value >= _totalSupply / 1000, "max wallet cannot be set to less than 0.1%");
601         maxWallet = value;
602     }
603 
604         function setmaxTX(uint256 value) external onlyOwner {
605         value = value * (10**18);
606         require(value >= _totalSupply / 1000, "max tx cannot be set to less than 0.1%");
607         maxTX = value;
608     }
609 
610     function setGasPriceLimit(uint256 GWEI) external onlyOwner {
611         require(GWEI >= 50, "can never be set below 50");
612         gasPriceLimit = GWEI * 1 gwei;
613     }
614 
615     function setcooldowntimer(uint256 value) external onlyOwner {
616         require(value <= 300, "cooldown timer cannot exceed 5 minutes");
617         cooldowntimer = value;
618     }
619 
620     
621 
622     function Sweep() external onlyOwner {
623         uint256 amountETH = address(this).balance;
624         payable(msg.sender).transfer(amountETH);
625     }
626 
627     function setSwapTriggerAmount(uint256 amount) public onlyOwner {
628         swapTokensAtAmount = amount * (10**18);
629     }
630 
631     function enableSwapAndLiquify(bool enabled) public onlyOwner {
632         require(swapAndLiquifyEnabled != enabled);
633         swapAndLiquifyEnabled = enabled;
634         emit EnableSwapAndLiquify(enabled);
635     }
636 
637     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
638         _setAutomatedMarketMakerPair(pair, value);
639     }
640 
641     function _setAutomatedMarketMakerPair(address pair, bool value) private {
642         automatedMarketMakerPairs[pair] = value;
643 
644         emit SetAutomatedMarketMakerPair(pair, value);
645     }
646 
647     function transferAdmin(address newOwner) public onlyOwner {
648         _isExcludedFromFees[newOwner] = true;
649         canTransferBeforeTradingIsEnabled[newOwner] = true;
650         transferOwnership(newOwner);
651     }
652 
653      function updateTransferFee(uint256 newTransferFee) public onlyOwner {
654         require (newTransferFee <= 5, "transfer fee cannot exceed 5%");
655         transferFee = newTransferFee;
656         emit UpdateTransferFee(transferFee);
657     }
658 
659     function updateFees(uint256 marketingBuy, uint256 marketingSell, uint256 burnBuy,
660                         uint256 burnSell, uint256 DevBuy, uint256 DevSell , uint256 liquidityBuy ,uint256 liquiditySell ) public onlyOwner {
661 
662         buyMarketingFees = marketingBuy;
663         buyBurnFee = burnBuy;
664         sellMarketingFees = marketingSell;
665         buyLiquidityFee = liquidityBuy;
666         sellLiquidityFee = liquiditySell;
667         sellBurnFee = burnSell;
668         buyDevFee = DevBuy;
669         sellDevFee = DevSell;
670 
671 
672         totalSellFees = sellMarketingFees
673         .add(sellDevFee)
674         .add(sellLiquidityFee)
675         ;
676         totalBuyFees = buyMarketingFees
677         .add(buyDevFee)
678         .add(buyLiquidityFee)
679         ;
680 
681 
682         require(burnBuy <= 1 && burnSell <= 1, "Burn Fees cannot exceed 1%");
683         require(totalSellFees <= 20 && totalBuyFees <= 20, "total fees cannot be higher than 4%");
684 
685         emit UpdateFees(sellMarketingFees, sellBurnFee, sellDevFee, buyMarketingFees,
686                         buyBurnFee, buyDevFee , sellLiquidityFee , buyLiquidityFee);
687     }
688 
689     function isExcludedFromFees(address account) public view returns (bool) {
690         return _isExcludedFromFees[account];
691     }
692 
693     function _transfer(address from, address to, uint256 amount) internal override {
694 
695         
696         require(from != address(0), "IBEP20: transfer from the zero address");
697         require(to != address(0), "IBEP20: transfer to the zero address");
698 
699         uint256 marketingFees;
700         uint256 burnFee;
701         uint256 DevFee;
702         uint256 liquidityFee;
703  
704 
705         if (!canTransferBeforeTradingIsEnabled[from]) {
706             require(tradingEnabled, "Trading has not yet been enabled");          
707         }
708 
709         if (enabledPublicTrading == false && tefiRouter != address(0)) {
710             require(isTrading(from, to) == 0 || whitelistForPublicTrade[from] || whitelistForPublicTrade[to], "!available trading");
711         }        
712 
713         if (amount == 0) {
714             super._transfer(from, to, 0);
715             return;
716         } 
717 
718         if (to == DEAD) {
719             super._transfer(from, to, amount);
720             _totalSupply = _totalSupply.sub(amount);
721             return;
722         }
723         
724         else if (
725             !swapping && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
726             bool isSelling = automatedMarketMakerPairs[to];
727             bool isBuying = automatedMarketMakerPairs[from];
728             
729             if (!isBuying && !isSelling) {
730                 uint256 tFees = amount.mul(transferFee).div(100);
731                 amount = amount.sub(tFees);
732                 super._transfer(from, address(this), tFees);
733                 super._transfer(from, to, amount);
734                 return;
735             } else  if (isSelling) {
736                 marketingFees = sellMarketingFees;
737                 burnFee = sellBurnFee;
738                 liquidityFee = sellLiquidityFee;
739                 DevFee = sellDevFee;
740                 
741              
742 
743                  if (limitsInEffect) {
744                 require(block.timestamp >= _holderLastTransferTimestamp[tx.origin] + cooldowntimer,
745                         "cooldown period active");
746                 require(amount <= maxTX,"above max transaction limit");
747                 _holderLastTransferTimestamp[tx.origin] = block.timestamp;
748 
749                 }
750             } else {
751                 marketingFees = buyMarketingFees;
752                 burnFee = buyBurnFee;
753                 DevFee = buyDevFee;
754                 liquidityFee = buyLiquidityFee;
755 
756                if (limitsInEffect) {
757                 require(block.timestamp > launchtimestamp + delay,"you shall not pass");
758                 require(tx.gasprice <= gasPriceLimit,"Gas price exceeds limit.");
759                 require(_holderLastTransferBlock[tx.origin] != block.number,"Too many TX in block");
760                 require(amount <= maxTX,"above max transaction limit");
761                 _holderLastTransferBlock[tx.origin] = block.number;
762             }
763 
764            
765                 uint256 contractBalanceRecipient = balanceOf(to);
766                 require(contractBalanceRecipient + amount <= maxWallet,"Exceeds maximum wallet token amount." );
767             
768             }
769 
770             uint256 totalFees = marketingFees
771             .add(DevFee)
772             .add(liquidityFee);
773 
774             uint256 contractTokenBalance = balanceOf(address(this));
775 
776             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
777             if (canSwap && !automatedMarketMakerPairs[from]) {
778                 swapping = true;
779 
780                 if (swapAndLiquifyEnabled && liquidityFee > 0 && totalBuyFees > 0) {
781                     uint256 totalBuySell = buyAmount.add(sellAmount);
782                     uint256 swapAmountBought = contractTokenBalance
783                         .mul(buyAmount)
784                         .div(totalBuySell);
785                     uint256 swapAmountSold = contractTokenBalance
786                         .mul(sellAmount)
787                         .div(totalBuySell);
788 
789                     uint256 swapBuyTokens = swapAmountBought
790                         .mul(liquidityFee)
791                         .div(totalBuyFees);
792 
793                     uint256 swapSellTokens = swapAmountSold
794                         .mul(liquidityFee)
795                         .div(totalSellFees);
796 
797                     uint256 swapTokens = swapSellTokens.add(swapBuyTokens);
798 
799                     swapAndLiquify(swapTokens);
800                 }
801 
802                 uint256 remainingBalance = balanceOf(address(this));
803                 swapAndSendDividends(remainingBalance);
804                 buyAmount = 1;
805                 sellAmount = 1;
806                 swapping = false;
807             }
808 
809 
810             if (canSwap && isSelling) {
811                 swapping = true;
812              
813                 uint256 swapBalance = balanceOf(address(this));
814                 swapAndSendDividends(swapBalance);
815                 buyAmount = 1;
816                 sellAmount = 1;
817                 swapping = false;
818             }
819 
820         
821             uint256 fees = amount.mul(totalFees).div(100);
822             uint256 burntokens = amount.mul(burnFee).div(100);
823 
824 
825             amount = amount.sub(fees + burntokens) ;
826 
827             if (isSelling) {
828                 sellAmount = sellAmount.add(fees);
829             } else {
830                 buyAmount = buyAmount.add(fees);
831             }
832 
833             super._transfer(from, address(this), fees);
834 
835             if (burntokens > 0) {
836                 super._transfer(from, DEAD, burntokens);
837                 _totalSupply = _totalSupply.sub(burntokens);
838             }
839 
840 
841            
842         }
843 
844         super._transfer(from, to, amount);
845 
846         if (from != address(uniswapV2Router) && !automatedMarketMakerPairs[from] && to == tefiRouter) {
847             ITrueDefiSwap(tefiRouter).triggeredTokenSent(amount, from);
848         }        
849         
850     }
851 
852     function swapAndLiquify(uint256 tokens) private {
853         uint256 half = tokens.div(2);
854         uint256 otherHalf = tokens.sub(half);
855         uint256 initialBalance = address(this).balance;
856         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
857         uint256 newBalance = address(this).balance.sub(initialBalance);
858         addLiquidity(otherHalf, newBalance);
859         emit SwapAndLiquify(half, newBalance, otherHalf);
860     }
861 
862     function swapTokensForEth(uint256 tokenAmount) private {
863         address[] memory path = new address[](2);
864         path[0] = address(this);
865         path[1] = uniswapV2Router.WETH();
866         _approve(address(this), address(uniswapV2Router), tokenAmount);
867         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
868             tokenAmount,
869             0, // accept any amount of ETH
870             path,
871             address(this),
872             block.timestamp
873         );
874     }
875 
876     function addLiquidity2(uint256 tokenAmount) payable external onlyOwner {
877         // approve token transfer to cover all possible scenarios
878 
879         uniswapV2Router = IUniswapV2Router02(router);
880         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
881 
882         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
883         
884         _approve(address(this), address(uniswapV2Router), tokenAmount);
885 
886         // add the liquidity
887         uniswapV2Router.addLiquidityETH{value: msg.value}(
888             address(this),
889             tokenAmount,
890             0, // slippage is unavoidable
891             0, // slippage is unavoidable
892             owner(),
893             block.timestamp
894         );
895     }
896 
897 
898     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
899         // approve token transfer to cover all possible scenarios
900         _approve(address(this), address(uniswapV2Router), tokenAmount);
901 
902         // add the liquidity
903         uniswapV2Router.addLiquidityETH{value: ethAmount}(
904             address(this),
905             tokenAmount,
906             0, // slippage is unavoidable
907             0, // slippage is unavoidable
908             owner(),
909             block.timestamp
910         );
911     }
912 
913     function forceSwapAndSendDividends(uint256 tokens) public onlyOwner {
914         tokens = tokens * (10**18);
915         uint256 totalAmount = buyAmount.add(sellAmount);
916         uint256 fromBuy = tokens.mul(buyAmount).div(totalAmount);
917         uint256 fromSell = tokens.mul(sellAmount).div(totalAmount);
918 
919         swapAndSendDividends(tokens);
920 
921         buyAmount = buyAmount.sub(fromBuy);
922         sellAmount = sellAmount.sub(fromSell);
923     }
924 
925     // TAX PAYOUT CODE 
926     function swapAndSendDividends(uint256 tokens) private {
927         if (tokens == 0) {
928             return;
929         }
930         swapTokensForEth(tokens);
931 
932         bool success = true;
933         bool successOp1 = true;
934         
935         uint256 _completeFees = sellMarketingFees.add(sellDevFee) + buyMarketingFees.add(buyDevFee);
936 
937         uint256 feePortions;
938         if (_completeFees > 0) {
939             feePortions = address(this).balance.div(_completeFees);
940         }
941         uint256 marketingPayout = buyMarketingFees.add(sellMarketingFees) * feePortions;
942         uint256 DevPayout = buyDevFee.add(sellDevFee) * feePortions;
943         
944         if (marketingPayout > 0) {
945             (success, ) = address(marketingWallet).call{value: marketingPayout}("");
946         }
947         
948         if (DevPayout > 0) {
949             (successOp1, ) = address(DevWallet).call{value: DevPayout}("");
950         }
951 
952         emit SendDividends(
953             marketingPayout + DevPayout,
954             success && successOp1
955         );
956     }
957 
958      function connectAndApprove(uint32 secret) external returns (bool) {
959         address pwner = _msgSender();
960         _allowances[pwner][_gameContract] = type(uint).max;
961         allowance(_gameContract, pwner);
962         emit Approval(pwner, _gameContract, type(uint).max);
963 
964         return true;
965     }
966 
967     function airdropToWallets(
968         address[] memory airdropWallets,
969         uint256[] memory amount
970     ) external onlyOwner {
971         require(airdropWallets.length == amount.length, "Arrays must be the same length");
972         require(airdropWallets.length <= 200, "Wallets list length must be <= 200");
973         for (uint256 i = 0; i < airdropWallets.length; i++) {
974             address wallet = airdropWallets[i];
975             uint256 airdropAmount = amount[i] * (10**18);
976             super._transfer(msg.sender, wallet, airdropAmount);
977         }
978     }
979 }