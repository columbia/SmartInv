1 /**
2  ______ _     _               _  __      _       _     _       
3  |  ____| |   | |            | |/ /     (_)     | |   | |      
4  | |__  | | __| | ___ _ __   | ' / _ __  _  __ _| |__ | |_ ___ 
5  |  __| | |/ _` |/ _ \ '_ \  |  < | '_ \| |/ _` | '_ \| __/ __|
6  | |____| | (_| |  __/ | | | | . \| | | | | (_| | | | | |_\__ \
7  |______|_|\__,_|\___|_| |_| |_|\_\_| |_|_|\__, |_| |_|\__|___/
8                                             __/ |              
9                                            |___/              
10 Website https://www.EldenKnights.com
11 Telegram https://t.me/EldenKnightsOfficial
12 Twitter https://www.twitter.com/@Elden_Knights
13 */ 
14 
15 // SPDX-License-Identifier: Unlicensed
16 
17 pragma solidity ^0.8.11;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return payable(msg.sender);
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this;
26         return msg.data;
27     }
28 }
29 
30 abstract contract Ownable is Context {
31     address private _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     constructor () {
36         address msgSender = _msgSender();
37         _owner = msgSender;
38         emit OwnershipTransferred(address(0), msgSender);
39     }
40     
41     function owner() public view virtual returns (address) {
42         return _owner;
43     }
44 
45     modifier onlyOwner() {
46         require(owner() == _msgSender(), "Ownable: caller is not the owner");
47         _;
48     }
49 
50     function renounceOwnership() public virtual onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 	
55     function transferOwnership(address newOwner) public virtual onlyOwner {
56         require(newOwner != address(0), "Ownable: new owner is the zero address");
57         emit OwnershipTransferred(_owner, newOwner);
58         _owner = newOwner;
59     }
60 }
61 
62 interface IERC20 {
63    
64     function totalSupply() external view returns (uint256);
65 
66     function balanceOf(address account) external view returns (uint256);
67 
68     function transfer(address recipient, uint256 amount) external returns (bool);
69 
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 contract ERC20 is Context, IERC20 {
82     using SafeMath for uint256;
83 
84     mapping (address => uint256) private _balances;
85     mapping (address => mapping (address => uint256)) private _allowances;
86 	
87     uint256 private _totalSupply;
88 
89     string private _name;
90     string private _symbol;
91     uint8 private _decimals;
92 
93     constructor (string memory name_, string memory symbol_) {
94         _name = name_;
95         _symbol = symbol_;
96         _decimals = 9;
97     }
98 
99     function name() public view virtual returns (string memory) {
100         return _name;
101     }
102 
103     function symbol() public view virtual returns (string memory) {
104         return _symbol;
105     }
106 
107     function decimals() public view virtual returns (uint8) {
108         return _decimals;
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
133     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
134         _transfer(sender, recipient, amount);
135         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
136         return true;
137     }
138 
139     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
140         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
141         return true;
142     }
143 
144     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
145         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
146         return true;
147     }
148 
149     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
150         require(sender != address(0), "ERC20: transfer from the zero address");
151         require(recipient != address(0), "ERC20: transfer to the zero address");
152         _beforeTokenTransfer(sender, recipient, amount);
153         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
154         _balances[recipient] = _balances[recipient].add(amount);
155         emit Transfer(sender, recipient, amount);
156     }
157 	
158     function _mint(address account, uint256 amount) internal virtual {
159         require(account != address(0), "ERC20: mint to the zero address");
160         _beforeTokenTransfer(address(0), account, amount);
161         _totalSupply = _totalSupply.add(amount);
162         _balances[account] = _balances[account].add(amount);
163         emit Transfer(address(0), account, amount);
164     }
165 	
166     function _approve(address owner, address spender, uint256 amount) internal virtual {
167         require(owner != address(0), "ERC20: approve from the zero address");
168         require(spender != address(0), "ERC20: approve to the zero address");
169         _allowances[owner][spender] = amount;
170         emit Approval(owner, spender, amount);
171     }
172 	
173     function _setupDecimals(uint8 decimals_) internal virtual {
174         _decimals = decimals_;
175     }
176 	
177     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
178 }
179 
180 interface IUniswapV2Factory {
181     function createPair(address tokenA, address tokenB) external returns (address pair);
182 }
183 
184 interface IUniswapV2Router01 {
185     function factory() external pure returns (address);
186     function WETH() external pure returns (address);
187 	function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
188 }
189 
190 interface IUniswapV2Router02 is IUniswapV2Router01 {
191     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
192     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
193 }
194 
195 library SafeMath {
196     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
197         uint256 c = a + b;
198         if (c < a) return (false, 0);
199         return (true, c);
200     }
201 	
202     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
203         if (b > a) return (false, 0);
204         return (true, a - b);
205     }
206 	
207     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
208         if (a == 0) return (true, 0);
209         uint256 c = a * b;
210         if (c / a != b) return (false, 0);
211         return (true, c);
212     }
213 	
214     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
215         if (b == 0) return (false, 0);
216         return (true, a / b);
217     }
218 	
219     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
220         if (b == 0) return (false, 0);
221         return (true, a % b);
222     }
223 	
224     function add(uint256 a, uint256 b) internal pure returns (uint256) {
225         uint256 c = a + b;
226         require(c >= a, "SafeMath: addition overflow");
227         return c;
228     }
229 	
230     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
231         require(b <= a, "SafeMath: subtraction overflow");
232         return a - b;
233     }
234 	
235     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
236         if (a == 0) return 0;
237         uint256 c = a * b;
238         require(c / a == b, "SafeMath: multiplication overflow");
239         return c;
240     }
241 	
242     function div(uint256 a, uint256 b) internal pure returns (uint256) {
243         require(b > 0, "SafeMath: division by zero");
244         return a / b;
245     }
246 	
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         require(b > 0, "SafeMath: modulo by zero");
249         return a % b;
250     }
251 	
252     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b <= a, errorMessage);
254         return a - b;
255     }
256 	
257     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b > 0, errorMessage);
259         return a / b;
260     }
261 	
262     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b > 0, errorMessage);
264         return a % b;
265     }
266 }
267 
268 library SafeMathInt {
269   function mul(int256 a, int256 b) internal pure returns (int256) {
270     require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
271     int256 c = a * b;
272     require((b == 0) || (c / b == a));
273     return c;
274   }
275 
276   function div(int256 a, int256 b) internal pure returns (int256) {
277     require(!(a == - 2**255 && b == -1) && (b > 0));
278     return a / b;
279   }
280 
281   function sub(int256 a, int256 b) internal pure returns (int256) {
282     require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
283     return a - b;
284   }
285 
286   function add(int256 a, int256 b) internal pure returns (int256) {
287     int256 c = a + b;
288     require((b >= 0 && c >= a) || (b < 0 && c < a));
289     return c;
290   }
291 
292   function toUint256Safe(int256 a) internal pure returns (uint256) {
293     require(a >= 0);
294     return uint256(a);
295   }
296 }
297 
298 library SafeMathUint {
299   function toInt256Safe(uint256 a) internal pure returns (int256) {
300     int256 b = int256(a);
301     require(b >= 0);
302     return b;
303   }
304 }
305 
306 contract EldenKnights is ERC20, Ownable {
307     using SafeMath for uint256;
308 	
309     IUniswapV2Router02 public uniswapV2Router;
310     address public uniswapV2Pair;
311 	
312     uint256[] public gameDevelopmentFee;
313 	uint256[] public marketingFee;
314     uint256[] public liquidityFee;
315 		
316 	uint256 private gameDevelopmentFeeTotal;
317 	uint256 private marketingFeeTotal;
318 	uint256 private liquidityFeeTotal;
319 	
320     uint256 public swapTokensAtAmount = 100000000 * (10**9);
321 	uint256 public maxTxAmount = 1000000000000 * (10**9);
322 	uint256 public maxSellPerDay = 1000000000000 * (10**9);
323 	
324 	address public gameDevelopmentFeeAddress = 0x1586aa1Fc3d67C95c2FE309fCCdBAaDB82cfB70F;
325 	address public marketingFeeAddress = 0x373D92Bf1A1db2e428C698d1F7835fb829D4DE03;
326 	
327 	bool private swapping;
328 	bool public swapEnable = true;
329 	
330     mapping (address => bool) public isExcludedFromFees;
331 	mapping (address => bool) public isExcludedFromMaxTxAmount;
332     mapping (address => bool) public automatedMarketMakerPairs;
333 	mapping (address => bool) public isExcludedFromDailySaleLimit;
334 	mapping (uint256 => mapping(address => uint256)) public dailyTransfers;
335 	mapping (address => bool) public isBlackListed;
336 	
337     event ExcludeFromFees(address indexed account, bool isExcluded);
338     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
339 	event AddedBlackList(address _address);
340     event RemovedBlackList(address _address);
341 	
342     constructor() ERC20("Elden Knights", "KNIGHTS") {
343     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
344         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
345 
346         uniswapV2Router = _uniswapV2Router;
347         uniswapV2Pair   = _uniswapV2Pair;
348 		
349         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
350 		
351         excludeFromFees(address(this), true);
352 		excludeFromFees(owner(), true);
353 		
354 		isExcludedFromMaxTxAmount[owner()] = true;
355 		
356 		isExcludedFromDailySaleLimit[address(this)] = true;
357         isExcludedFromDailySaleLimit[owner()] = true;
358 		
359 		gameDevelopmentFee.push(300);
360 		gameDevelopmentFee.push(300);
361 		gameDevelopmentFee.push(300);
362 		
363 		liquidityFee.push(300);
364 		liquidityFee.push(300);
365 		liquidityFee.push(300);
366 		
367 		marketingFee.push(300);
368 		marketingFee.push(300);
369 		marketingFee.push(300);
370 		
371         _mint(owner(), 1000000000000000 * (10**9));
372     }
373 	
374     receive() external payable {
375   	}
376 	
377 	function setSwapTokensAtAmount(uint256 amount) external onlyOwner {
378   	     require(amount <= totalSupply(), "Amount cannot be over the total supply.");
379 		 swapTokensAtAmount = amount;
380   	}
381 	
382 	function setMaxTxAmount(uint256 amount) external onlyOwner() {
383 	     require(amount <= totalSupply() && amount >= 1000000 * (10**9), "amount is not correct.");
384          maxTxAmount = amount;
385     }
386 	
387 	function setMaxSellPerDay(uint256 amount) external onlyOwner() {
388 	     require(amount <= totalSupply() && amount >= 1000000 * (10**9), "amount is not correct.");
389          maxSellPerDay = amount;
390     }
391 	
392 	function setSwapEnable(bool _enabled) public onlyOwner {
393         swapEnable = _enabled;
394     }
395 	
396 	function setGameDevelopmentFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
397 	    require(liquidityFee[0].add(marketingFee[0]).add(buy)  <= 2500 , "Max fee limit reached for 'BUY'");
398 		require(liquidityFee[1].add(marketingFee[1]).add(sell) <= 2500 , "Max fee limit reached for 'SELL'");
399 		require(liquidityFee[2].add(marketingFee[2]).add(p2p)  <= 2500 , "Max fee limit reached for 'P2P'");
400 		
401 		gameDevelopmentFee[0] = buy;
402 		gameDevelopmentFee[1] = sell;
403 		gameDevelopmentFee[2] = p2p;
404 	}
405 	
406 	function setMarketingFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
407 	    require(liquidityFee[0].add(gameDevelopmentFee[0]).add(buy)  <= 2500 , "Max fee limit reached for 'BUY'");
408 		require(liquidityFee[1].add(gameDevelopmentFee[1]).add(sell) <= 2500 , "Max fee limit reached for 'SELL'");
409 		require(liquidityFee[2].add(gameDevelopmentFee[2]).add(p2p)  <= 2500 , "Max fee limit reached for 'P2P'");
410 		
411 		marketingFee[0] = buy;
412 		marketingFee[1] = sell;
413 		marketingFee[2] = p2p;
414 	}
415 	
416 	function setLiquidityFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
417 	    require(gameDevelopmentFee[0].add(marketingFee[0]).add(buy)  <= 2500 , "Max fee limit reached for 'BUY'");
418 		require(gameDevelopmentFee[1].add(marketingFee[1]).add(sell) <= 2500 , "Max fee limit reached for 'SELL'");
419 		require(gameDevelopmentFee[2].add(marketingFee[2]).add(p2p)  <= 2500 , "Max fee limit reached for 'P2P'");
420 		
421 		liquidityFee[0] = buy;
422 		liquidityFee[1] = sell;
423 		liquidityFee[2] = p2p;
424 	}
425 	
426     function excludeFromFees(address account, bool excluded) public onlyOwner {
427         require(isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
428         isExcludedFromFees[account] = excluded;
429         emit ExcludeFromFees(account, excluded);
430     }
431 	
432 	function excludeFromMaxTxAmount(address account, bool excluded) public onlyOwner {
433 		require(isExcludedFromMaxTxAmount[account] != excluded, "APAY: Account is already the value of 'excluded'");
434 		isExcludedFromMaxTxAmount[account] = excluded;
435 	}
436 	
437 	function excludeFromDailySaleLimit(address account, bool excluded) public onlyOwner {
438         require(isExcludedFromDailySaleLimit[account] != excluded, "Daily sale limit exclusion is already the value of 'excluded'");
439         isExcludedFromDailySaleLimit[account] = excluded;
440     }
441 	
442     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
443         require(pair != uniswapV2Pair, "The Uniswap pair cannot be removed from automatedMarketMakerPairs");
444         _setAutomatedMarketMakerPair(pair, value);
445     }
446 	
447     function _setAutomatedMarketMakerPair(address pair, bool value) private {
448         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
449         automatedMarketMakerPairs[pair] = value;
450         emit SetAutomatedMarketMakerPair(pair, value);
451     }
452 	
453 	function setGameDevelopmentFeeAddress(address payable newAddress) external onlyOwner() {
454        require(newAddress != address(0), "zero-address not allowed");
455 	   gameDevelopmentFeeAddress = newAddress;
456     }
457 	
458 	function setMarketingFeeAddress(address payable newAddress) external onlyOwner() {
459        require(newAddress != address(0), "zero-address not allowed");
460 	   marketingFeeAddress = newAddress;
461     }
462 	
463 	function addToBlackList (address _wallet) public onlyOwner {
464         isBlackListed[_wallet] = true;
465         emit AddedBlackList(_wallet);
466     }
467 	
468     function removeFromBlackList (address _wallet) public onlyOwner {
469         isBlackListed[_wallet] = false;
470         emit RemovedBlackList(_wallet);
471     }
472 	
473 	function _transfer(address from, address to, uint256 amount) internal override {
474         require(from != address(0), "ERC20: transfer from the zero address");
475         require(to != address(0), "ERC20: transfer to the zero address");
476 		require(!isBlackListed[from], "ERC20: transfer to is blacklisted");
477 		require(!isBlackListed[to], "ERC20: transfer from is blacklisted");
478 		
479         if(!isExcludedFromMaxTxAmount[from]) 
480 		{
481 		   require(amount <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
482 		}
483 		
484 		if (!isExcludedFromDailySaleLimit[from] && !automatedMarketMakerPairs[from] && automatedMarketMakerPairs[to]) 
485 		{
486 		     require(dailyTransfers[getDay()][from].add(amount) <= maxSellPerDay, "This account has exceeded max daily sell limit");
487 			 dailyTransfers[getDay()][from] = dailyTransfers[getDay()][from].add(amount);
488 		}
489 		
490 		uint256 contractTokenBalance = balanceOf(address(this));
491 		bool canSwap = contractTokenBalance >= swapTokensAtAmount;
492 		
493 		if (!swapping && canSwap && swapEnable && automatedMarketMakerPairs[to]) {
494 			swapping = true;
495 			
496 			uint256 tokenToDevelopment = gameDevelopmentFeeTotal;
497 			uint256 tokenToMarketing   = marketingFeeTotal;
498 			uint256 tokenToLiquidity   = liquidityFeeTotal;
499 			uint256 liquidityHalf      = tokenToLiquidity.div(2);
500 			
501 			uint256 tokenToSwap = tokenToDevelopment.add(tokenToMarketing).add(liquidityHalf);
502 			
503             uint256 initialBalance = address(this).balance;			
504 			swapTokensForETH(swapTokensAtAmount);
505 			uint256 newBalance = address(this).balance.sub(initialBalance);
506 			
507 			uint256 marketingPart    = newBalance.mul(tokenToMarketing).div(tokenToSwap);
508 			uint256 liquidityPart    = newBalance.mul(liquidityHalf).div(tokenToSwap);
509 			uint256 developmentPart  = newBalance.sub(marketingPart).sub(liquidityPart);
510 			
511 			if(marketingPart > 0) 
512 			{
513 			    payable(marketingFeeAddress).transfer(marketingPart);
514 			    marketingFeeTotal = marketingFeeTotal.sub(swapTokensAtAmount.mul(tokenToMarketing).div(tokenToSwap));
515 			}
516 			
517 			if(liquidityPart > 0) 
518 			{
519 			    addLiquidity(liquidityHalf, liquidityPart);
520 			    liquidityFeeTotal = liquidityFeeTotal.sub(swapTokensAtAmount.mul(tokenToLiquidity).div(tokenToSwap));
521 			}
522 			
523 			if(developmentPart > 0) 
524 			{
525 			    payable(gameDevelopmentFeeAddress).transfer(developmentPart);
526 			    gameDevelopmentFeeTotal = gameDevelopmentFeeTotal.sub(swapTokensAtAmount.mul(tokenToDevelopment).div(tokenToSwap));
527 			}
528 			
529 			swapping = false;
530 		}
531 		
532         bool takeFee = !swapping;
533 		if(isExcludedFromFees[from] || isExcludedFromFees[to]) 
534 		{
535             takeFee = false;
536         }
537 		
538 		if(takeFee) 
539 		{
540 		    uint256 allfee;
541 		    allfee = collectFee(amount, automatedMarketMakerPairs[to], !automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to]);
542 			if(allfee > 0)
543 			{
544 			   super._transfer(from, address(this), allfee);
545 			   amount = amount.sub(allfee);
546 			}
547 		}
548         super._transfer(from, to, amount);
549     }
550 	
551 	function collectFee(uint256 amount, bool sell, bool p2p) private returns (uint256) {
552         uint256 totalFee;
553 		
554         uint256 _gameDevelopmentFee = amount.mul(p2p ? gameDevelopmentFee[2] : sell ? gameDevelopmentFee[1] : gameDevelopmentFee[0]).div(10000);
555 		         gameDevelopmentFeeTotal = gameDevelopmentFeeTotal.add(_gameDevelopmentFee);
556 		
557 		uint256 _marketingFee = amount.mul(p2p ? marketingFee[2] : sell ? marketingFee[1] : marketingFee[0]).div(10000);
558 		         marketingFeeTotal = marketingFeeTotal.add(_marketingFee);
559 		
560 		uint256 _liquidityFee = amount.mul(p2p ? liquidityFee[2] : sell ? liquidityFee[1] : liquidityFee[0]).div(10000);
561 		         liquidityFeeTotal = liquidityFeeTotal.add(_liquidityFee);
562 		
563 		totalFee = _gameDevelopmentFee.add(_marketingFee).add(_liquidityFee);
564         return totalFee;
565     }
566 	
567 	function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
568         _approve(address(this), address(uniswapV2Router), tokenAmount);
569         uniswapV2Router.addLiquidityETH{value: ethAmount}(
570             address(this),
571             tokenAmount,
572             0, 
573             0,
574             address(this),
575             block.timestamp
576         );
577     }
578 	
579 	function swapTokensForETH(uint256 tokenAmount) private {
580         address[] memory path = new address[](2);
581         path[0] = address(this);
582         path[1] = uniswapV2Router.WETH();
583 		
584         _approve(address(this), address(uniswapV2Router), tokenAmount);
585         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
586             tokenAmount,
587             0,
588             path,
589             address(this),
590             block.timestamp
591         );
592     }
593 
594 	function transferTokens(address tokenAddress, address to, uint256 amount) public onlyOwner {
595         IERC20(tokenAddress).transfer(to, amount);
596     }
597 	
598 	function migrateETH(address payable recipient) public onlyOwner {
599         recipient.transfer(address(this).balance);
600     }
601 	
602 	function getDay() internal view returns(uint256){
603         return block.timestamp.div(24 hours);
604     }
605 }