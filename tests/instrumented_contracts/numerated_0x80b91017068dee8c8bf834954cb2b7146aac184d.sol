1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-16
3 
4  ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄ ▄▄    ▄ ▄▄▄▄▄▄▄ ▄▄▄   ▄ ▄▄▄ 
5 █       █  █ █  █   █  █  █ █       █   █ █ █   █
6 █  ▄▄▄▄▄█  █▄█  █   █   █▄█ █   ▄   █   █▄█ █   █
7 █ █▄▄▄▄▄█       █   █       █  █ █  █      ▄█   █
8 █▄▄▄▄▄  █   ▄   █   █  ▄    █  █▄█  █     █▄█   █
9  ▄▄▄▄▄█ █  █ █  █   █ █ █   █       █    ▄  █   █
10 █▄▄▄▄▄▄▄█▄▄█ █▄▄█▄▄▄█▄█  █▄▄█▄▄▄▄▄▄▄█▄▄▄█ █▄█▄▄▄█
11 
12 */
13 
14 // SPDX-License-Identifier: Unlicensed
15 
16 pragma solidity ^0.8.4;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49         return c;
50     }
51 
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58         return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64 
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         return c;
69     }
70 
71 }
72 
73 contract Ownable is Context {
74     address private _owner;
75     address private _previousOwner;
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor () {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83 
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     modifier onlyOwner() {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     function renounceOwnership() public virtual onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98 }  
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint amountTokenDesired,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
122 }
123 
124 contract ShinokiInuETH is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _rOwned;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private bots;
130     mapping (address => uint) private cooldown;
131     uint256 private constant _tTotal = 1e10 * 10**9;
132     
133     uint256 private _buyProjectFee = 4;
134     uint256 private _previousBuyProjectFee = _buyProjectFee;
135     uint256 private _buyLiquidityFee = 5;
136     uint256 private _previousBuyLiquidityFee = _buyLiquidityFee;
137     uint256 private _buyRewardFee = 1;
138     uint256 private _previousBuyRewardFee = _buyRewardFee;
139     
140     uint256 private _sellProjectFee = 14;
141     uint256 private _previousSellProjectFee = _sellProjectFee;
142     uint256 private _sellLiquidityFee = 10;
143     uint256 private _previousSellLiquidityFee = _sellLiquidityFee;
144     uint256 private _sellRewardFee = 4;
145     uint256 private _previousSellRewardFee = _sellRewardFee;
146 
147     uint256 private tokensForReward;
148     uint256 private tokensForProject;
149     uint256 private tokensForLiquidity;
150 
151     address payable private _rewardWallet;
152     address payable private _projectWallet;
153     address payable private _liquidityWallet;
154     
155     string private constant _name = "Shinoki Inu";
156     string private constant _symbol = "SHINOKI";
157     uint8 private constant _decimals = 9;
158     
159     IUniswapV2Router02 private uniswapV2Router;
160     address private uniswapV2Pair;
161     bool private tradingOpen;
162     bool private swapping;
163     bool private inSwap = false;
164     bool private swapEnabled = false;
165     bool private cooldownEnabled = false;
166     uint256 private tradingActiveBlock = 0; // 0 means trading is not active
167     uint256 private blocksToBlacklist = 10;
168     uint256 private _maxBuyAmount = _tTotal;
169     uint256 private _maxSellAmount = _tTotal;
170     uint256 private _maxWalletAmount = _tTotal;
171     uint256 private swapTokensAtAmount = 0;
172     
173     event MaxBuyAmountUpdated(uint _maxBuyAmount);
174     event MaxSellAmountUpdated(uint _maxSellAmount);
175     event SwapAndLiquify(
176         uint256 tokensSwapped,
177         uint256 ethReceived,
178         uint256 tokensIntoLiquidity
179     );
180     modifier lockTheSwap {
181         inSwap = true;
182         _;
183         inSwap = false;
184     }
185     constructor () {
186         _projectWallet = payable(0x1B7De7daA79329CFCaC308379aF54B976621a8D5);
187         _liquidityWallet = payable(address(0xdead));
188         _rewardWallet = payable(0x1B7De7daA79329CFCaC308379aF54B976621a8D5);
189         _rOwned[_msgSender()] = _tTotal;
190         _isExcludedFromFee[owner()] = true;
191         _isExcludedFromFee[address(this)] = true;
192         _isExcludedFromFee[_projectWallet] = true;
193         _isExcludedFromFee[_liquidityWallet] = true;
194         _isExcludedFromFee[_rewardWallet] = true;
195         emit Transfer(address(0xbc4fD39F29D4aC708BB9EbBb19B2f938bf8a64D6), _msgSender(), _tTotal);
196     }
197 
198     function name() public pure returns (string memory) {
199         return _name;
200     }
201 
202     function symbol() public pure returns (string memory) {
203         return _symbol;
204     }
205 
206     function decimals() public pure returns (uint8) {
207         return _decimals;
208     }
209 
210     function totalSupply() public pure override returns (uint256) {
211         return _tTotal;
212     }
213 
214     function balanceOf(address account) public view override returns (uint256) {
215         return _rOwned[account];
216     }
217 
218     function transfer(address recipient, uint256 amount) public override returns (bool) {
219         _transfer(_msgSender(), recipient, amount);
220         return true;
221     }
222 
223     function allowance(address owner, address spender) public view override returns (uint256) {
224         return _allowances[owner][spender];
225     }
226 
227     function approve(address spender, uint256 amount) public override returns (bool) {
228         _approve(_msgSender(), spender, amount);
229         return true;
230     }
231 
232     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
233         _transfer(sender, recipient, amount);
234         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
235         return true;
236     }
237 
238     function setCooldownEnabled(bool onoff) external onlyOwner() {
239         cooldownEnabled = onoff;
240     }
241 
242     function setSwapEnabled(bool onoff) external onlyOwner(){
243         swapEnabled = onoff;
244     }
245 
246     function _approve(address owner, address spender, uint256 amount) private {
247         require(owner != address(0), "ERC20: approve from the zero address");
248         require(spender != address(0), "ERC20: approve to the zero address");
249         _allowances[owner][spender] = amount;
250         emit Approval(owner, spender, amount);
251     }
252 
253     function _transfer(address from, address to, uint256 amount) private {
254         require(from != address(0), "ERC20: transfer from the zero address");
255         require(to != address(0), "ERC20: transfer to the zero address");
256         require(amount > 0, "Transfer amount must be greater than zero");
257         bool takeFee = false;
258         bool shouldSwap = false;
259         if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !swapping) {
260             require(!bots[from] && !bots[to]);
261 
262             takeFee = true;
263             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
264                 require(amount <= _maxBuyAmount, "Transfer amount exceeds the maxBuyAmount.");
265                 require(balanceOf(to) + amount <= _maxWalletAmount, "Exceeds maximum wallet token amount.");
266                 require(cooldown[to] < block.timestamp);
267                 cooldown[to] = block.timestamp + (30 seconds);
268             }
269             
270             if (to == uniswapV2Pair && from != address(uniswapV2Router) && !_isExcludedFromFee[from] && cooldownEnabled) {
271                 require(amount <= _maxSellAmount, "Transfer amount exceeds the maxSellAmount.");
272                 shouldSwap = true;
273             }
274         }
275 
276         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
277             takeFee = false;
278         }
279 
280         uint256 contractTokenBalance = balanceOf(address(this));
281         bool canSwap = (contractTokenBalance > swapTokensAtAmount) && shouldSwap;
282 
283         if (canSwap && swapEnabled && !swapping && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
284             swapping = true;
285             swapBack();
286             swapping = false;
287         }
288 
289         _tokenTransfer(from,to,amount,takeFee, shouldSwap);
290     }
291 
292     function swapBack() private {
293         uint256 contractBalance = balanceOf(address(this));
294         uint256 totalTokensToSwap = tokensForLiquidity + tokensForReward + tokensForProject;
295         bool success;
296         
297         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
298 
299         if(contractBalance > swapTokensAtAmount * 10) {
300             contractBalance = swapTokensAtAmount * 10;
301         }
302         
303         // Halve the amount of liquidity tokens
304         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
305         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
306         
307         uint256 initialETHBalance = address(this).balance;
308 
309         swapTokensForEth(amountToSwapForETH); 
310         
311         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
312         
313         uint256 ethForReward = ethBalance.mul(tokensForReward).div(totalTokensToSwap);
314         uint256 ethForProject = ethBalance.mul(tokensForProject).div(totalTokensToSwap);
315         
316         
317         uint256 ethForLiquidity = ethBalance - ethForReward - ethForProject;
318         
319         
320         tokensForLiquidity = 0;
321         tokensForReward = 0;
322         tokensForProject = 0;
323         
324         (success,) = address(_rewardWallet).call{value: ethForReward}("");
325         
326         if(liquidityTokens > 0 && ethForLiquidity > 0){
327             addLiquidity(liquidityTokens, ethForLiquidity);
328             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
329         }
330         
331         
332         (success,) = address(_projectWallet).call{value: address(this).balance}("");
333     }
334 
335     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
336         address[] memory path = new address[](2);
337         path[0] = address(this);
338         path[1] = uniswapV2Router.WETH();
339         _approve(address(this), address(uniswapV2Router), tokenAmount);
340         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
341             tokenAmount,
342             0,
343             path,
344             address(this),
345             block.timestamp
346         );
347     }
348 
349     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
350         _approve(address(this), address(uniswapV2Router), tokenAmount);
351         uniswapV2Router.addLiquidityETH{value: ethAmount}(
352             address(this),
353             tokenAmount,
354             0, // slippage is unavoidable
355             0, // slippage is unavoidable
356             _liquidityWallet,
357             block.timestamp
358         );
359     }
360         
361     function sendETHToFee(uint256 amount) private {
362         _projectWallet.transfer(amount);
363     }
364     
365     function openTrading() external onlyOwner() {
366         require(!tradingOpen,"trading is already open");
367         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
368         uniswapV2Router = _uniswapV2Router;
369         _approve(address(this), address(uniswapV2Router), _tTotal);
370         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
371         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
372         swapEnabled = true;
373         cooldownEnabled = true;
374         _maxBuyAmount = 5e7 * 10**9;
375         _maxSellAmount = 5e7 * 10**9;
376         _maxWalletAmount = 1e8 * 10**9;
377         swapTokensAtAmount = 5e6 * 10**9;
378         tradingOpen = true;
379         tradingActiveBlock = block.number;
380         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
381     }
382     
383     function setBots(address[] memory bots_) public onlyOwner {
384         for (uint i = 0; i < bots_.length; i++) {
385             bots[bots_[i]] = true;
386         }
387     }
388 
389     function setMaxBuyAmount(uint256 maxBuy) public onlyOwner {
390         _maxBuyAmount = maxBuy;
391     }
392 
393     function setMaxSellAmount(uint256 maxSell) public onlyOwner {
394         _maxSellAmount = maxSell;
395     }
396     
397     function setMaxWalletAmount(uint256 maxToken) public onlyOwner {
398         _maxWalletAmount = maxToken;
399     }
400     
401     function setSwapTokensAtAmount(uint256 newAmount) public onlyOwner {
402         require(newAmount >= 1e3 * 10**9, "Swap amount cannot be lower than 0.001% total supply.");
403         require(newAmount <= 5e6 * 10**9, "Swap amount cannot be higher than 0.5% total supply.");
404         swapTokensAtAmount = newAmount;
405     }
406 
407     function setProjectWallet(address projectWallet) public onlyOwner() {
408         require(projectWallet != address(0), "projectWallet address cannot be 0");
409         _isExcludedFromFee[_projectWallet] = false;
410         _projectWallet = payable(projectWallet);
411         _isExcludedFromFee[_projectWallet] = true;
412     }
413 
414     function setRewardWallet(address rewardWallet) public onlyOwner() {
415         require(rewardWallet != address(0), "rewardWallet address cannot be 0");
416         _isExcludedFromFee[_rewardWallet] = false;
417         _rewardWallet = payable(rewardWallet);
418         _isExcludedFromFee[_rewardWallet] = true;
419     }
420 
421     function setLiquidityWallet(address liquidityWallet) public onlyOwner() {
422         require(liquidityWallet != address(0), "liquidityWallet address cannot be 0");
423         _isExcludedFromFee[_liquidityWallet] = false;
424         _liquidityWallet = payable(liquidityWallet);
425         _isExcludedFromFee[_liquidityWallet] = true;
426     }
427 
428     function excludeFromFee(address account) public onlyOwner {
429         _isExcludedFromFee[account] = true;
430     }
431     
432     function includeInFee(address account) public onlyOwner {
433         _isExcludedFromFee[account] = false;
434     }
435 
436     function setBuyFee(uint256 buyProjectFee, uint256 buyLiquidityFee, uint256 buyRewardFee) external onlyOwner {
437         require(buyProjectFee + buyLiquidityFee + buyRewardFee <= 30, "Must keep buy taxes below 30%");
438         _buyProjectFee = buyProjectFee;
439         _buyLiquidityFee = buyLiquidityFee;
440         _buyRewardFee = buyRewardFee;
441     }
442 
443     function setSellFee(uint256 sellProjectFee, uint256 sellLiquidityFee, uint256 sellRewardFee) external onlyOwner {
444         require(sellProjectFee + sellLiquidityFee + sellRewardFee <= 60, "Must keep sell taxes below 60%");
445         _sellProjectFee = sellProjectFee;
446         _sellLiquidityFee = sellLiquidityFee;
447         _sellRewardFee = sellRewardFee;
448     }
449 
450     function setBlocksToBlacklist(uint256 blocks) public onlyOwner {
451         blocksToBlacklist = blocks;
452     }
453 
454     function removeAllFee() private {
455         if(_buyProjectFee == 0 && _buyLiquidityFee == 0 && _buyRewardFee == 0 && _sellProjectFee == 0 && _sellLiquidityFee == 0 && _sellRewardFee == 0) return;
456         
457         _previousBuyProjectFee = _buyProjectFee;
458         _previousBuyLiquidityFee = _buyLiquidityFee;
459         _previousBuyRewardFee = _buyRewardFee;
460         _previousSellProjectFee = _sellProjectFee;
461         _previousSellLiquidityFee = _sellLiquidityFee;
462         _previousSellRewardFee = _sellRewardFee;
463         
464         _buyProjectFee = 0;
465         _buyLiquidityFee = 0;
466         _buyRewardFee = 0;
467         _sellProjectFee = 0;
468         _sellLiquidityFee = 0;
469         _sellRewardFee = 0;
470     }
471     
472     function restoreAllFee() private {
473         _buyProjectFee = _previousBuyProjectFee;
474         _buyLiquidityFee = _previousBuyLiquidityFee;
475         _buyRewardFee = _previousBuyRewardFee;
476         _sellProjectFee = _previousSellProjectFee;
477         _sellLiquidityFee = _previousSellLiquidityFee;
478         _sellRewardFee = _previousSellRewardFee;
479     }
480     
481     function delBot(address notbot) public onlyOwner {
482         bots[notbot] = false;
483     }
484         
485     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee, bool isSell) private {
486         if(!takeFee) {
487             removeAllFee();
488         } else {
489             amount = _takeFees(sender, amount, isSell);
490         }
491 
492         _transferStandard(sender, recipient, amount);
493         
494         if(!takeFee) {
495             restoreAllFee();
496         }
497     }
498 
499     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
500         _rOwned[sender] = _rOwned[sender].sub(tAmount);
501         _rOwned[recipient] = _rOwned[recipient].add(tAmount);
502         emit Transfer(sender, recipient, tAmount);
503     }
504 
505     function _takeFees(address sender, uint256 amount, bool isSell) private returns (uint256) {
506         uint256 _totalFees;
507         uint256 pjctFee;
508         uint256 liqFee;
509         uint256 rwrdFee;
510         if(tradingActiveBlock + blocksToBlacklist >= block.number){
511             _totalFees = 99;
512             liqFee = 92;
513         } else {
514             _totalFees = _getTotalFees(isSell);
515             if (isSell) {
516                 pjctFee = _sellProjectFee;
517                 liqFee = _sellLiquidityFee;
518                 rwrdFee = _sellRewardFee;
519             } else {
520                 pjctFee = _buyProjectFee;
521                 liqFee = _buyLiquidityFee;
522                 rwrdFee = _buyRewardFee;
523             }
524         }
525 
526         uint256 fees = amount.mul(_totalFees).div(100);
527         tokensForReward += fees * rwrdFee / _totalFees;
528         tokensForProject += fees * pjctFee / _totalFees;
529         tokensForLiquidity += fees * liqFee / _totalFees;
530             
531         if(fees > 0) {
532             _transferStandard(sender, address(this), fees);
533         }
534             
535         return amount -= fees;
536     }
537 
538     receive() external payable {}
539     
540     function manualswap() public onlyOwner() {
541         uint256 contractBalance = balanceOf(address(this));
542         swapTokensForEth(contractBalance);
543     }
544     
545     function manualsend() public onlyOwner() {
546         uint256 contractETHBalance = address(this).balance;
547         sendETHToFee(contractETHBalance);
548     }
549 
550     function withdrawStuckETH() external onlyOwner {
551         require(!tradingOpen, "Can only withdraw if trading hasn't started");
552         bool success;
553         (success,) = address(msg.sender).call{value: address(this).balance}("");
554     }
555 
556     function _getTotalFees(bool isSell) private view returns(uint256) {
557         if (isSell) {
558             return _sellProjectFee + _sellLiquidityFee + _sellRewardFee;
559         }
560         return _buyProjectFee + _buyLiquidityFee + _buyRewardFee;
561     }
562 }