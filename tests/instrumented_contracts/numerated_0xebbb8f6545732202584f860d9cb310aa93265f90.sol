1 /*                                                                                                             
2   _______  ___________  __    __    ________  ______        __         _______    _______  
3  /"     "|("     _   ")/" |  | "\  /"       )/" _  "\      /""\       |   __ "\  /"     "| 
4 (: ______) )__/  \\__/(:  (__)  :)(:   \___/(: ( \___)    /    \      (. |__) :)(: ______) 
5  \/    |      \\_ /    \/      \/  \___  \   \/ \        /' /\  \     |:  ____/  \/    |   
6  // ___)_     |.  |    //  __  \\   __/  \\  //  \ _    //  __'  \    (|  /      // ___)_  
7 (:      "|    \:  |   (:  (  )  :) /" \   :)(:   _) \  /   /  \\  \  /|__/ \    (:      "| 
8  \_______)     \__|    \__|  |__/ (_______/  \_______)(___/    \___)(_______)    \_______) 
9                                                                                           
10 Twitter  - http://twitter.com/ScapeEth
11 Telegram - http://t.me/EthScape
12 
13 */                                                                           
14 
15 
16 
17 pragma solidity >=0.7.0 <0.8.0;
18 // SPDX-License-Identifier: Unlicensed
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         return c;
71     }
72 }
73 
74 contract Ownable is Context {
75     address private _owner;
76     address private _previousOwner;
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     constructor() {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 }
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint256 amountIn,
107         uint256 amountOutMin,
108         address[] calldata path,
109         address to,
110         uint256 deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint256 amountTokenDesired,
117         uint256 amountTokenMin,
118         uint256 amountETHMin,
119         address to,
120         uint256 deadline
121     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
122 }
123 
124 
125 interface MEVRepel {
126     function isMEV(address from, address to, address orig) external returns(bool);
127     function setPairAddress(address _pairAddress) external;
128 }
129 
130 contract ETHSCAPE is Context, IERC20, Ownable {
131     using SafeMath for uint256;
132 
133     mapping (address => uint256) private _balance;
134     mapping (address => uint256) private _lastTX;
135     mapping (address => mapping (address => uint256)) private _allowances;
136 
137     mapping (address => bool) private _isExcludedFromFee;
138     mapping (address => bool) private _isExcluded;
139     mapping (address => bool) private _isBlacklisted;
140 
141     address[] private _excluded;  
142     bool public tradingLive = false;
143 
144     uint256 private _totalSupply = 1300000000 * 10**9;
145     uint256 public _totalBurned;
146 
147     string private _name = "Ethscape";
148     string private _symbol = "ETHSCAPE";
149     uint8 private _decimals = 9;
150     
151     address payable private _devWallet; // LA 2% of total dev fees
152     address payable private _gameWallet; // GameDev .5% of total of total dev fees
153     address payable private _serviceWallet; // ContractDev 1.5% of total dev fees
154 
155     address payable private _marketingWallet;
156     address payable private _rewardsWallet;
157 
158     uint256 public firstLiveBlock;
159     uint256 public _gems = 2;
160     uint256 public _liquidityMarketingFee = 8;
161     uint256 public _rewardsPool = 2;
162 
163     uint256 private _previousGems = _gems;
164     uint256 private _previousLiquidityMarketingFee = _liquidityMarketingFee;
165     uint256 private _previousRewardsPool = _rewardsPool;
166 
167     IUniswapV2Router02 public immutable uniswapV2Router;
168     address public immutable uniswapV2Pair;
169     
170     bool inSwapAndLiquify;
171     bool public swapAndLiquifyEnabled = true;
172     bool public antiBotLaunch = true;
173     bool public zeroTaxMode = false;
174     bool public mevRepelActive = true;
175     
176     uint256 public _maxTxAmount = 2600000 * 10**9;
177     uint256 public _maxHoldings = 26000000 * 10**9;
178     bool public maxHoldingsEnabled = true;
179     bool public maxTXEnabled = true;
180     bool public antiSnipe = true;
181     bool public cooldown = true;
182     uint256 public numTokensSellToAddToLiquidity = 1300000 * 10**9;
183     
184 
185     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
186     event SwapAndLiquifyEnabledUpdated(bool enabled);
187     event SwapAndLiquify(
188         uint256 tokensSwapped,
189         uint256 ethReceived,
190         uint256 tokensIntoLiqudity
191     );
192     
193     modifier lockTheSwap {
194         inSwapAndLiquify = true;
195         _;
196         inSwapAndLiquify = false;
197     }
198     
199     MEVRepel mevrepel;
200 
201     constructor (address payable marketingWallet, address payable gameWallet, address payable serviceWallet, address payable devWallet, address payable rewardsWallet) {
202         _balance[_msgSender()] = _totalSupply;
203 
204         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Uni V2
205          // Create a uniswap pair for this new token
206         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
207 
208         // set the rest of the contract variables
209         uniswapV2Router = _uniswapV2Router;
210         
211         //exclude owner and this contract from fee
212         _isExcludedFromFee[owner()] = true;
213         _isExcludedFromFee[address(this)] = true;
214 
215         _marketingWallet = marketingWallet;
216         _devWallet = devWallet;
217         _rewardsWallet = rewardsWallet;
218         _gameWallet = gameWallet;
219         _serviceWallet = serviceWallet;
220 
221         emit Transfer(address(0), _msgSender(), _totalSupply);
222     }
223 
224     function name() public view returns (string memory) {
225         return _name;
226     }
227 
228     function symbol() public view returns (string memory) {
229         return _symbol;
230     }
231 
232     function decimals() public view returns (uint8) {
233         return _decimals;
234     }
235 
236     function totalSupply() public view override returns (uint256) {
237         return _totalSupply;
238     }
239 
240     function balanceOf(address account) public view override returns (uint256) {
241         return _balance[account];
242     }
243 
244     function transfer(address recipient, uint256 amount) public override returns (bool) {
245         _transfer(_msgSender(), recipient, amount);
246         return true;
247     }
248 
249     function allowance(address owner, address spender) public view override returns (uint256) {
250         return _allowances[owner][spender];
251     }
252 
253     function approve(address spender, uint256 amount) public override returns (bool) {
254         _approve(_msgSender(), spender, amount);
255         return true;
256     }
257 
258     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
259         _transfer(sender, recipient, amount);
260         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
261         return true;
262     }
263 
264     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
265         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
266         return true;
267     }
268 
269     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
270         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
271         return true;
272     }
273 
274 
275     function totalBurned() public view returns (uint256) {
276         return _totalBurned;
277     }
278     
279     
280     function excludeFromFee(address account) external onlyOwner {
281         _isExcludedFromFee[account] = true;
282     }
283     
284     function includeInFee(address account) external onlyOwner {
285         _isExcludedFromFee[account] = false;
286     }
287 
288     function setDevWallet(address payable _address) external onlyOwner {
289         _devWallet = _address;
290     }
291 
292    function setWallets(address payable marketing, address payable rewards, address payable dev, address payable game) external onlyOwner {
293         _marketingWallet = marketing;
294         _rewardsWallet = rewards;
295         _devWallet = dev;
296         _gameWallet = game;
297     }
298 
299     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
300         _maxTxAmount = maxTxAmount * 10**9;
301     }
302 
303     function setMaxHoldings(uint256 maxHoldings) external onlyOwner() {
304         _maxHoldings = maxHoldings * 10**9;
305     }
306    
307     function setMaxTXEnabled(bool enabled) external onlyOwner() {
308         maxTXEnabled = enabled;
309     }
310     
311     function setZeroTaxMode(bool enabled) external onlyOwner() {
312         zeroTaxMode = enabled;
313     }
314     
315     function setMaxHoldingsEnabled(bool enabled) external onlyOwner() {
316         maxHoldingsEnabled = enabled;
317     }
318     
319     function setAntiSnipe(bool enabled) external onlyOwner() {
320         antiSnipe = enabled;
321     }
322     function setCooldown(bool enabled) external onlyOwner() {
323         cooldown = enabled;
324     }
325 
326     function useMevRepel(bool _mevRepelActive) external onlyOwner {
327         mevRepelActive = _mevRepelActive;
328     }
329 
330     function setFees (uint256 devAndMarketingFee, uint256 gemsFee, uint256 rewardsPool) external onlyOwner() {
331         uint256 totalTaxes = devAndMarketingFee + gemsFee + rewardsPool;
332         require(totalTaxes <= 20, "Must keep fees at 20% or less");
333         _liquidityMarketingFee = devAndMarketingFee;
334         _gems = gemsFee;
335         _rewardsPool = rewardsPool;
336     }
337     
338     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
339         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
340     }
341     
342     function claimETH (address walletaddress) external onlyOwner {
343         // make sure we capture all ETH that may or may not be sent to this contract
344         payable(walletaddress).transfer(address(this).balance);
345     }
346     
347     function claimAltTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
348         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
349     }
350     
351     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
352         walletaddress.transfer(address(this).balance);
353     }
354     
355     function blacklist(address _address) external onlyOwner() {
356         _isBlacklisted[_address] = true;
357     }
358     
359     function removeFromBlacklist(address _address) external onlyOwner() {
360         _isBlacklisted[_address] = false;
361     }
362     
363     function getIsBlacklistedStatus(address _address) external view returns (bool) {
364         return _isBlacklisted[_address];
365     }
366     
367     function allowtrading(address _mevrepel) external onlyOwner() {
368         mevrepel = MEVRepel(_mevrepel);
369         mevrepel.setPairAddress(uniswapV2Pair);
370         tradingLive = true;
371         firstLiveBlock = block.number;        
372     }
373 
374     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
375         swapAndLiquifyEnabled = _enabled;
376         emit SwapAndLiquifyEnabledUpdated(_enabled);
377     }
378     
379      //to recieve ETH from uniswapV2Router when swaping
380     receive() external payable {}
381 
382     
383     
384     function isExcludedFromFee(address account) public view returns(bool) {
385         return _isExcludedFromFee[account];
386     }
387 
388     function _approve(address owner, address spender, uint256 amount) private {
389         require(owner != address(0), "ERC20: approve from the zero address");
390         require(spender != address(0), "ERC20: approve to the zero address");
391         _allowances[owner][spender] = amount;
392         emit Approval(owner, spender, amount);
393     }
394 
395     function _collectGems(address _account, uint _amount) private {  
396         require( _amount <= balanceOf(_account));
397         _balance[_account] = _balance[_account].sub(_amount);
398         _totalSupply = _totalSupply.sub(_amount);
399         _totalBurned = _totalBurned.add(_amount);
400         emit Transfer(_account, address(0), _amount);
401     }
402 
403     function _ethscapePowerUp(uint _amount) private {
404         _balance[address(this)] = _balance[address(this)].add(_amount);
405     }
406 
407     function airDrop(address[] calldata newholders, uint256[] calldata amounts) external {
408         uint256 iterator = 0;
409         require(_isExcludedFromFee[_msgSender()], "Airdrop can only be done by excluded from fee");
410         require(newholders.length == amounts.length, "Holders and amount length must be the same");
411         while(iterator < newholders.length){
412             _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false);
413             iterator += 1;
414         }
415     }
416 
417     function removeAllFee() private {
418         if(_gems == 0 && _liquidityMarketingFee == 0 && _rewardsPool == 0) return;
419         
420         _previousGems = _gems;
421         _previousLiquidityMarketingFee = _liquidityMarketingFee;
422         _previousRewardsPool = _rewardsPool;
423         
424         _gems = 0;
425         _liquidityMarketingFee = 0;
426         _rewardsPool = 0;
427     }
428     
429     function restoreAllFee() private {
430         _gems = _previousGems;
431         _liquidityMarketingFee = _previousLiquidityMarketingFee;
432         _rewardsPool = _previousRewardsPool;
433     }
434 
435     function _transfer(address from, address to, uint256 amount) private {
436         require(from != address(0), "ERC20: transfer from the zero address");
437         require(to != address(0), "ERC20: transfer to the zero address");
438         require(amount > 0, "Transfer amount must be greater than zero");
439         require(!_isBlacklisted[from] && !_isBlacklisted[to]);
440         if(!tradingLive){
441             require(from == owner()); // only owner allowed to trade or add liquidity
442         }       
443 
444         if(maxTXEnabled){
445             if(from != owner() && to != owner()){
446                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
447             }
448         }
449         if(cooldown){
450             if( to != owner() && to != address(this) && to != address(uniswapV2Router) && to != uniswapV2Pair) {
451                 require(_lastTX[tx.origin] <= (block.timestamp + 30 seconds), "Cooldown in effect");
452                 _lastTX[tx.origin] = block.timestamp;
453             }
454         }
455 
456         if(antiSnipe){
457             if(from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){
458             require( tx.origin == to);
459             }
460         }
461 
462         if(maxHoldingsEnabled){
463             if(from == uniswapV2Pair && from != owner() && to != owner() && to != address(uniswapV2Router) && to != address(this)) {
464                 uint balance = balanceOf(to);
465                 require(balance.add(amount) <= _maxHoldings);
466                 
467             }
468         }
469 
470         uint256 contractTokenBalance = balanceOf(address(this));        
471         if(contractTokenBalance >= _maxTxAmount){
472             contractTokenBalance = _maxTxAmount;
473         }
474         
475         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
476         if ( overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {
477             contractTokenBalance = numTokensSellToAddToLiquidity;
478             swapAndLiquify(contractTokenBalance);
479         }
480 
481         bool takeFee = true;        
482         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
483             takeFee = false;
484         }
485 
486 
487         if (zeroTaxMode) { takeFee = false;}
488         
489         // Please view our announcement channel to verify that this token is MEVRepellent Certified
490         // https://t.me/mevrepellent
491 
492         if (tradingLive && mevRepelActive) {
493             bool notmev;
494             address orig = tx.origin;
495             try mevrepel.isMEV(from,to,orig) returns (bool mev) {
496                 notmev = mev;
497             } catch { revert(); }
498             require(notmev, "MEV Bot Detected");
499         }
500 
501         _tokenTransfer(from,to,amount,takeFee);
502     }
503 
504     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {        
505         if(antiBotLaunch){
506             if(block.number <= firstLiveBlock && sender == uniswapV2Pair && recipient != address(uniswapV2Router) && recipient != address(this)){
507                 _isBlacklisted[recipient] = true;
508             }
509         }
510 
511         if(!takeFee) removeAllFee();
512         uint256 amountTransferred = 0;
513 
514         if(sender == uniswapV2Pair && recipient != address(this) && recipient != address(uniswapV2Router)){    
515             //buys  we pull the gems to collect and rip those gems from total supply, no rewards pool add on buys
516             uint256 gemsToCollect = amount.mul(_gems).div(100);
517             uint256 ethscapePowerUp = amount.mul(_liquidityMarketingFee).div(100);
518             uint256 amountWithNoGems = amount.sub(gemsToCollect);
519             amountTransferred = amount.sub(ethscapePowerUp).sub(gemsToCollect);
520 
521             _collectGems(sender, gemsToCollect);
522             _ethscapePowerUp(ethscapePowerUp);        
523             _balance[sender] = _balance[sender].sub(amountWithNoGems);
524             _balance[recipient] = _balance[recipient].add(amountTransferred);
525         }
526         else{
527             //sells, we don't collect gems on sells
528             _liquidityMarketingFee = _liquidityMarketingFee + _rewardsPool;
529             uint256 ethscapePowerUp = amount.mul(_liquidityMarketingFee).div(100);
530             uint256 amountWithNoGems = amount;
531             amountTransferred = amount.sub(ethscapePowerUp);
532 
533             _ethscapePowerUp(ethscapePowerUp);        
534             _balance[sender] = _balance[sender].sub(amountWithNoGems);
535             _balance[recipient] = _balance[recipient].add(amountTransferred);
536         }
537         
538         emit Transfer(sender, recipient, amountTransferred);
539     
540         if(!takeFee) restoreAllFee();
541     }
542 
543     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
544         uint256 tokensForLiq = (contractTokenBalance.div(10));
545         uint256 half = tokensForLiq.div(2);
546         uint256 toSwap = contractTokenBalance.sub(half);
547         uint256 initialBalance = address(this).balance;
548         swapTokensForEth(toSwap);
549         uint256 newBalance = address(this).balance.sub(initialBalance);
550         addLiquidity(half, newBalance);
551 
552         uint256 balanceRemaining = address(this).balance;
553         uint256 ethForRewards = balanceRemaining.div(10);
554         if (ethForRewards > 0){
555             payable(_rewardsWallet).transfer(ethForRewards);   
556         }
557         
558         uint256 ethForDev = balanceRemaining.div(10).mul(2);
559         if (ethForRewards > 0){
560             uint256 ethForProjectLead = ethForDev.div(2);
561             uint256 ethForGameDev = ethForDev.div(10);
562             uint256 ethForSolDev = ethForDev.sub(ethForGameDev).sub(ethForProjectLead);
563             payable(_devWallet).transfer(ethForProjectLead);
564             payable(_gameWallet).transfer(ethForGameDev);
565             payable(_serviceWallet).transfer(ethForSolDev);   
566         }
567         
568         payable(_marketingWallet).transfer(address(this).balance);   
569         
570         emit SwapAndLiquify(half, newBalance, half);
571     }
572 
573     function swapTokensForEth(uint256 tokenAmount) private {
574         // generate the uniswap pair path of token -> weth
575         address[] memory path = new address[](2);
576         path[0] = address(this);
577         path[1] = uniswapV2Router.WETH();
578 
579         _approve(address(this), address(uniswapV2Router), tokenAmount);
580 
581         // make the swap
582         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
583             tokenAmount,
584             0, // accept any amount of ETH
585             path,
586             address(this),
587             block.timestamp
588         );
589     }
590 
591     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
592         // approve token transfer to cover all possible scenarios
593         _approve(address(this), address(uniswapV2Router), tokenAmount);
594 
595         // add the liquidity
596         uniswapV2Router.addLiquidityETH{value: ethAmount}(
597             address(this),
598             tokenAmount,
599             0, // slippage is unavoidable
600             0, // slippage is unavoidable
601             owner(),
602             block.timestamp
603         );
604     }
605 }