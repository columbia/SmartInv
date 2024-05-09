1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
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
58 }
59 
60 contract Ownable is Context {
61     address private _owner;
62     address private _previousOwner;
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     constructor () {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85 }  
86 
87 interface IUniswapV2Factory {
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89 }
90 
91 interface IUniswapV2Router02 {
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external;
99     function factory() external pure returns (address);
100     function WETH() external pure returns (address);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109 }
110 
111 contract DREAM is Context, IERC20, Ownable {
112     using SafeMath for uint256;
113     mapping (address => uint256) private _rOwned;
114     mapping (address => uint256) private _tOwned;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private bots;
118     mapping (address => uint) private cooldown;
119     uint256 private constant _tTotal = 1e8 * 10**9;
120     
121     uint256 private _marketingFee = 3;
122     uint256 private _previousMarketingFee = _marketingFee;
123     uint256 private _developmentFee = 2;
124     uint256 private _previousDevelopmentFee = _developmentFee;
125     uint256 private _liquidityFee = 1;
126     uint256 private _previousLiquidityFee = _liquidityFee;
127     uint256 private _foundationFee = 1;
128     uint256 private _previousFoundationFee = _foundationFee;
129     uint256 private _rewardFee = 1;
130     uint256 private _previousRewardFee = _rewardFee;
131 
132     uint256 private tokensForProject;
133     uint256 private tokensForDev;
134     uint256 private tokensForLiquidity;
135 
136     address payable private _projectWallet;
137     address payable private _developmentWallet;
138     address payable private _liquidityWallet;
139     
140     string private constant _name = "DREAM";
141     string private constant _symbol = "DREAM";
142     uint8 private constant _decimals = 9;
143     
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen;
147     bool private swapping;
148     bool private inSwap = false;
149     bool private swapEnabled = false;
150     bool private cooldownEnabled = false;
151     bool private marketHoursEnabled = false;
152     bool private checkHolidays = false;
153     bool private isSpecialEvent = false;
154     uint256 private tradingActiveBlock = 0; // 0 means trading is not active
155     uint256 private blocksToBlacklist = 1;
156     uint256 private _maxBuyAmount = _tTotal;
157     uint256 private _maxSellAmount = _tTotal;
158     uint256 private _maxWalletAmount = _tTotal;
159     uint256 private swapTokensAtAmount = 0;
160     uint8 private _sunday = 0;
161     uint8 private _saturday = 6;
162     uint8 private _openingTimeHr = 14;
163     uint8 private _closingTimeHr = 20;
164     uint8 private _openingTimeMin = 30;
165 
166     struct _DateTime {
167                 uint16 year;
168                 uint8 month;
169                 uint8 day;
170                 uint8 hour;
171                 uint8 minute;
172                 uint8 second;
173                 uint8 weekday;
174             }
175 
176     uint constant DAY_IN_SECONDS = 86400;
177     uint constant YEAR_IN_SECONDS = 31536000;
178     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
179     uint constant HOUR_IN_SECONDS = 3600;
180     uint constant MINUTE_IN_SECONDS = 60;
181     uint16 constant ORIGIN_YEAR = 1970;
182     
183     event MaxBuyAmountUpdated(uint _maxBuyAmount);
184     event MaxSellAmountUpdated(uint _maxSellAmount);
185     event SwapAndLiquify(
186         uint256 tokensSwapped,
187         uint256 ethReceived,
188         uint256 tokensIntoLiquidity
189     );
190     modifier lockTheSwap {
191         inSwap = true;
192         _;
193         inSwap = false;
194     }
195     constructor () {
196         _projectWallet = payable(0x814f28C01cB2E281A5d9C7bEC1b988406EeED6e8);
197         _developmentWallet = payable(0xcD11d4f84E6dD5CF256e595557Ebd482399087ec);
198         _liquidityWallet = payable(address(0xdead));
199         _rOwned[_msgSender()] = _tTotal;
200         _isExcludedFromFee[owner()] = true;
201         _isExcludedFromFee[address(this)] = true;
202         _isExcludedFromFee[_projectWallet] = true;
203         _isExcludedFromFee[_developmentWallet] = true;
204         _isExcludedFromFee[_liquidityWallet] = true;
205         emit Transfer(address(0x81252E081f4335e3B766AD5C6C4038076A444994), _msgSender(), _tTotal);
206     }
207 
208     function name() public pure returns (string memory) {
209         return _name;
210     }
211 
212     function symbol() public pure returns (string memory) {
213         return _symbol;
214     }
215 
216     function decimals() public pure returns (uint8) {
217         return _decimals;
218     }
219 
220     function totalSupply() public pure override returns (uint256) {
221         return _tTotal;
222     }
223 
224     function balanceOf(address account) public view override returns (uint256) {
225         return _rOwned[account];
226     }
227 
228     function transfer(address recipient, uint256 amount) public override returns (bool) {
229         _transfer(_msgSender(), recipient, amount);
230         return true;
231     }
232 
233     function allowance(address owner, address spender) public view override returns (uint256) {
234         return _allowances[owner][spender];
235     }
236 
237     function approve(address spender, uint256 amount) public override returns (bool) {
238         _approve(_msgSender(), spender, amount);
239         return true;
240     }
241 
242     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
243         _transfer(sender, recipient, amount);
244         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
245         return true;
246     }
247 
248     function setCooldownEnabled(bool onoff) external onlyOwner() {
249         cooldownEnabled = onoff;
250     }
251 
252     function setMarketHoursEnabled(bool onoff) external onlyOwner() {
253         marketHoursEnabled = onoff;
254     }
255 
256     function setCheckHolidaysEnabled(bool onoff) external onlyOwner() {
257         checkHolidays = onoff;
258     }
259 
260     function setSpecialEvent(bool onoff) external onlyOwner() {
261         isSpecialEvent = onoff;
262     }
263 
264     function setSwapEnabled(bool onoff) external onlyOwner(){
265         swapEnabled = onoff;
266     }
267 
268     function _approve(address owner, address spender, uint256 amount) private {
269         require(owner != address(0), "ERC20: approve from the zero address");
270         require(spender != address(0), "ERC20: approve to the zero address");
271         _allowances[owner][spender] = amount;
272         emit Approval(owner, spender, amount);
273     }
274 
275     function _transfer(address from, address to, uint256 amount) private {
276         require(from != address(0), "ERC20: transfer from the zero address");
277         require(to != address(0), "ERC20: transfer to the zero address");
278         require(amount > 0, "Transfer amount must be greater than zero");
279         bool takeFee = false;
280         bool shouldSwap = false;
281         if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !swapping) {
282             require(!bots[from] && !bots[to]);
283 
284             if (marketHoursEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
285                 require(marketOpened(block.timestamp), "Market is closed.");
286             }
287 
288             takeFee = true;
289             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
290                 require(amount <= _maxBuyAmount, "Transfer amount exceeds the maxBuyAmount.");
291                 require(balanceOf(to) + amount <= _maxWalletAmount, "Exceeds maximum wallet token amount.");
292                 require(cooldown[to] < block.timestamp);
293                 cooldown[to] = block.timestamp + (30 seconds);
294             }
295             
296             if (to == uniswapV2Pair && from != address(uniswapV2Router) && !_isExcludedFromFee[from] && cooldownEnabled) {
297                 require(amount <= _maxSellAmount, "Transfer amount exceeds the maxSellAmount.");
298                 shouldSwap = true;
299             }
300         }
301 
302         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
303             takeFee = false;
304         }
305 
306         uint256 contractTokenBalance = balanceOf(address(this));
307         bool canSwap = (contractTokenBalance > swapTokensAtAmount) && shouldSwap;
308 
309         if (canSwap && swapEnabled && !swapping && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
310             swapping = true;
311             swapBack();
312             swapping = false;
313         }
314 
315         _tokenTransfer(from,to,amount,takeFee);
316     }
317 
318     function swapBack() private {
319         uint256 contractBalance = balanceOf(address(this));
320         uint256 totalTokensToSwap = tokensForLiquidity + tokensForProject + tokensForDev;
321         bool success;
322         
323         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
324 
325         if(contractBalance > swapTokensAtAmount * 10) {
326             contractBalance = swapTokensAtAmount * 10;
327         }
328         
329         // Halve the amount of liquidity tokens
330         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
331         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
332         
333         uint256 initialETHBalance = address(this).balance;
334 
335         swapTokensForEth(amountToSwapForETH); 
336         
337         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
338         
339         uint256 ethForMarketing = ethBalance.mul(tokensForProject).div(totalTokensToSwap);
340         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
341         
342         
343         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
344         
345         
346         tokensForLiquidity = 0;
347         tokensForProject = 0;
348         tokensForDev = 0;
349         
350         (success,) = address(_developmentWallet).call{value: ethForDev}("");
351         
352         if(liquidityTokens > 0 && ethForLiquidity > 0){
353             addLiquidity(liquidityTokens, ethForLiquidity);
354             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
355         }
356         
357         
358         (success,) = address(_projectWallet).call{value: address(this).balance}("");
359     }
360 
361     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
362         address[] memory path = new address[](2);
363         path[0] = address(this);
364         path[1] = uniswapV2Router.WETH();
365         _approve(address(this), address(uniswapV2Router), tokenAmount);
366         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
367             tokenAmount,
368             0,
369             path,
370             address(this),
371             block.timestamp
372         );
373     }
374 
375     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
376         _approve(address(this), address(uniswapV2Router), tokenAmount);
377         uniswapV2Router.addLiquidityETH{value: ethAmount}(
378             address(this),
379             tokenAmount,
380             0, // slippage is unavoidable
381             0, // slippage is unavoidable
382             _liquidityWallet,
383             block.timestamp
384         );
385     }
386         
387     function sendETHToFee(uint256 amount) private {
388         _projectWallet.transfer(amount.div(2));
389         _developmentWallet.transfer(amount.div(2));
390     }
391     
392     function openTrading() external onlyOwner() {
393         require(!tradingOpen,"trading is already open");
394         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
395         uniswapV2Router = _uniswapV2Router;
396         _approve(address(this), address(uniswapV2Router), _tTotal);
397         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
398         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
399         swapEnabled = true;
400         cooldownEnabled = true;
401         marketHoursEnabled = true;
402         checkHolidays = true;
403         _maxBuyAmount = 1e5 * 10**9;
404         _maxSellAmount = 1e5 * 10**9;
405         _maxWalletAmount = 3e5 * 10**9;
406         swapTokensAtAmount = 5e4 * 10**9;
407         tradingOpen = true;
408         tradingActiveBlock = block.number;
409         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
410     }
411     
412     function setBots(address[] memory bots_) public onlyOwner {
413         for (uint i = 0; i < bots_.length; i++) {
414             bots[bots_[i]] = true;
415         }
416     }
417 
418     function setMaxBuyAmount(uint256 maxBuy) public onlyOwner {
419         _maxBuyAmount = maxBuy;
420     }
421 
422     function setMaxSellAmount(uint256 maxSell) public onlyOwner {
423         _maxSellAmount = maxSell;
424     }
425     
426     function setMaxWalletAmount(uint256 maxToken) public onlyOwner {
427         _maxWalletAmount = maxToken;
428     }
429     
430     function setSwapTokensAtAmount(uint256 newAmount) public onlyOwner {
431   	    require(newAmount >= 1e3 * 10**9, "Swap amount cannot be lower than 0.001% total supply.");
432   	    require(newAmount <= 5e6 * 10**9, "Swap amount cannot be higher than 0.5% total supply.");
433   	    swapTokensAtAmount = newAmount;
434   	}
435 
436     function setProjectWallet(address projectWallet) public onlyOwner() {
437         require(projectWallet != address(0), "projectWallet address cannot be 0");
438         _isExcludedFromFee[_projectWallet] = false;
439         _projectWallet = payable(projectWallet);
440         _isExcludedFromFee[_projectWallet] = true;
441     }
442 
443     function setDevelopmentWallet(address developmentWallet) public onlyOwner() {
444         require(developmentWallet != address(0), "developmentWallet address cannot be 0");
445         _isExcludedFromFee[_developmentWallet] = false;
446         _developmentWallet = payable(developmentWallet);
447         _isExcludedFromFee[_developmentWallet] = true;
448     }
449 
450     function setLiquidityWallet(address liquidityWallet) public onlyOwner() {
451         require(liquidityWallet != address(0), "liquidityWallet address cannot be 0");
452         _isExcludedFromFee[_liquidityWallet] = false;
453         _liquidityWallet = payable(liquidityWallet);
454         _isExcludedFromFee[_liquidityWallet] = true;
455     }
456 
457     function excludeFromFee(address account) public onlyOwner {
458         _isExcludedFromFee[account] = true;
459     }
460     
461     function includeInFee(address account) public onlyOwner {
462         _isExcludedFromFee[account] = false;
463     }
464     
465     function setMarketingFee(uint256 marketingFee) external onlyOwner() {
466         require(marketingFee <= 10, "Marketing Fee must be less than 10%");
467         _marketingFee = marketingFee;
468     }
469     
470     function setDevelopmentFee(uint256 developmentFee) external onlyOwner() {
471         require(developmentFee <= 10, "Development Fee must be less than 10%");
472         _developmentFee = developmentFee;
473     }
474     
475     function setLiquidityFee(uint256 liquidityFee) external onlyOwner() {
476         require(liquidityFee <= 10, "Liquidity Fee must be less than 10%");
477         _liquidityFee = liquidityFee;
478     }
479     
480     function setFoundationFee(uint256 foundationFee) external onlyOwner() {
481         require(foundationFee <= 10, "Foundation Fee must be less than 10%");
482         _foundationFee = foundationFee;
483     }
484     
485     function setRewardFee(uint256 rewardFee) external onlyOwner() {
486         require(rewardFee <= 10, "Reward Fee must be less than 10%");
487         _rewardFee = rewardFee;
488     }
489 
490     function setBlocksToBlacklist(uint256 blocks) public onlyOwner {
491         blocksToBlacklist = blocks;
492     }
493 
494     function removeAllFee() private {
495         if(_marketingFee == 0 && _developmentFee == 0 && _liquidityFee == 0 && _foundationFee == 0 && _rewardFee == 0) return;
496         
497         _previousMarketingFee = _marketingFee;
498         _previousDevelopmentFee = _developmentFee;
499         _previousLiquidityFee = _liquidityFee;
500         _previousFoundationFee = _foundationFee;
501         _previousRewardFee = _rewardFee;
502         
503         _marketingFee = 0;
504         _developmentFee = 0;
505         _liquidityFee = 0;
506         _foundationFee = 0;
507         _rewardFee = 0;
508     }
509     
510     function restoreAllFee() private {
511         _marketingFee = _previousMarketingFee;
512         _developmentFee = _previousDevelopmentFee;
513         _liquidityFee = _previousLiquidityFee;
514         _foundationFee = _previousFoundationFee;
515         _rewardFee = _previousRewardFee;
516     }
517     
518     function delBot(address notbot) public onlyOwner {
519         bots[notbot] = false;
520     }
521         
522     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
523         if(!takeFee) {
524             removeAllFee();
525         } else {
526             amount = _takeFees(sender, amount);
527         }
528 
529         _transferStandard(sender, recipient, amount);
530         
531         if(!takeFee) {
532             restoreAllFee();
533         }
534     }
535 
536     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
537         _rOwned[sender] = _rOwned[sender].sub(tAmount);
538         _rOwned[recipient] = _rOwned[recipient].add(tAmount);
539         emit Transfer(sender, recipient, tAmount);
540     }
541 
542     function _takeFees(address sender, uint256 amount) private returns (uint256) {
543         uint256 _totalFees;
544         uint256 liqFee;
545         if(tradingActiveBlock + blocksToBlacklist >= block.number){
546             _totalFees = 99;
547             liqFee = 92;
548         } else {
549             _totalFees = _getTotalFees();
550             liqFee = _liquidityFee;
551         }
552 
553         uint256 fees = amount.mul(_totalFees).div(100);
554         tokensForProject += fees * (_marketingFee + _rewardFee + _foundationFee) / _totalFees;
555         tokensForDev += fees * _developmentFee / _totalFees;
556         tokensForLiquidity += fees * liqFee / _totalFees;
557             
558         if(fees > 0) {
559             _transferStandard(sender, address(this), fees);
560         }
561         	
562         return amount -= fees;
563     }
564 
565     receive() external payable {}
566     
567     function manualswap() external {
568         require(_msgSender() == _projectWallet);
569         uint256 contractBalance = balanceOf(address(this));
570         swapTokensForEth(contractBalance);
571     }
572     
573     function manualsend() external {
574         require(_msgSender() == _projectWallet);
575         uint256 contractETHBalance = address(this).balance;
576         sendETHToFee(contractETHBalance);
577     }
578 
579     function withdrawStuckETH() external onlyOwner {
580         require(!tradingOpen, "Can only withdraw if trading hasn't started");
581         bool success;
582         (success,) = address(msg.sender).call{value: address(this).balance}("");
583     }
584 
585     function _getTotalFees() private view returns(uint256) {
586         return _marketingFee + _developmentFee + _liquidityFee + _foundationFee + _rewardFee;
587     }
588 
589     function marketOpened(uint timestamp) public view returns (bool) {
590         _DateTime memory dt = parseTimestamp(timestamp);
591         if (dt.weekday == _sunday || dt.weekday == _saturday) {
592             return false;
593         }
594         if (dt.hour < _openingTimeHr || dt.hour > _closingTimeHr) {
595             return false;
596         }
597         if (dt.hour == _openingTimeHr && dt.minute < _openingTimeMin) {
598             return false;
599         }
600         if (checkHolidays) {
601             if (dt.month == 1 && (dt.day == 1 || dt.day == 18)) {
602                 return false;
603             }
604             if (dt.month == 2 && dt.day == 15) {
605                 return false;
606             }
607             if (dt.month == 4 && dt.day == 2) {
608                 return false;
609             }
610             if (dt.month == 5 && dt.day == 31) {
611                 return false;
612             }
613             if (dt.month == 7 && dt.day == 5) {
614                 return false;
615             }
616             if (dt.month == 9 && dt.day == 6) {
617                 return false;
618             }
619             if (dt.month == 11 && dt.day == 25) {
620                 return false;
621             }
622             if (dt.month == 12 && dt.day == 24) {
623                 return false;
624             }
625         }
626         if (isSpecialEvent) {
627             return false;
628         }
629         
630         return true;
631     }
632 
633         function isLeapYear(uint16 year) public pure returns (bool) {
634                 if (year % 4 != 0) {
635                         return false;
636                 }
637                 if (year % 100 != 0) {
638                         return true;
639                 }
640                 if (year % 400 != 0) {
641                         return false;
642                 }
643                 return true;
644         }
645 
646         function leapYearsBefore(uint year) public pure returns (uint) {
647                 year -= 1;
648                 return year / 4 - year / 100 + year / 400;
649         }
650 
651         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
652                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
653                         return 31;
654                 }
655                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
656                         return 30;
657                 }
658                 else if (isLeapYear(year)) {
659                         return 29;
660                 }
661                 else {
662                         return 28;
663                 }
664         }
665 
666         function parseTimestamp(uint timestamp) internal pure returns (_DateTime memory dt) {
667                 uint secondsAccountedFor = 0;
668                 uint buf;
669                 uint8 i;
670 
671                 // Year
672                 dt.year = getYear(timestamp);
673                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
674 
675                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
676                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
677 
678                 // Month
679                 uint secondsInMonth;
680                 for (i = 1; i <= 12; i++) {
681                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
682                         if (secondsInMonth + secondsAccountedFor > timestamp) {
683                                 dt.month = i;
684                                 break;
685                         }
686                         secondsAccountedFor += secondsInMonth;
687                 }
688 
689                 // Day
690                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
691                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
692                                 dt.day = i;
693                                 break;
694                         }
695                         secondsAccountedFor += DAY_IN_SECONDS;
696                 }
697 
698                 // Hour
699                 dt.hour = getHour(timestamp);
700 
701                 // Minute
702                 dt.minute = getMinute(timestamp);
703 
704                 // Second
705                 dt.second = getSecond(timestamp);
706 
707                 // Day of week.
708                 dt.weekday = getWeekday(timestamp);
709         }
710 
711         function getYear(uint timestamp) public pure returns (uint16) {
712                 uint secondsAccountedFor = 0;
713                 uint16 year;
714                 uint numLeapYears;
715 
716                 // Year
717                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
718                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
719 
720                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
721                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
722 
723                 while (secondsAccountedFor > timestamp) {
724                         if (isLeapYear(uint16(year - 1))) {
725                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
726                         }
727                         else {
728                                 secondsAccountedFor -= YEAR_IN_SECONDS;
729                         }
730                         year -= 1;
731                 }
732                 return year;
733         }
734 
735         function getHour(uint timestamp) public pure returns (uint8) {
736                 return uint8((timestamp / 60 / 60) % 24);
737         }
738 
739         function getMinute(uint timestamp) public pure returns (uint8) {
740                 return uint8((timestamp / 60) % 60);
741         }
742 
743         function getSecond(uint timestamp) public pure returns (uint8) {
744                 return uint8(timestamp % 60);
745         }
746 
747         function getWeekday(uint timestamp) public pure returns (uint8) {
748                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
749         }
750 
751     function setSunday(uint8 sunday) external onlyOwner() {
752         _sunday = sunday;
753     }
754 
755     function setSaturday(uint8 saturday) external onlyOwner() {
756         _saturday = saturday;
757     }
758 
759     function setMarketOpeningTimeHr(uint8 openingTimeHr) external onlyOwner() {
760         _openingTimeHr = openingTimeHr;
761     }
762 
763     function setMarketClosingTimeHr(uint8 closingTimeHr) external onlyOwner() {
764         _closingTimeHr = closingTimeHr;
765     }
766 
767     function setMarketOpeningTimeMin(uint8 openingTimeMin) external onlyOwner() {
768         _openingTimeMin = openingTimeMin;
769     }
770 }