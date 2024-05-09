1 /*
2  *
3 _____/\\\\\\\\\\\____/\\\________/\\\__/\\\\\\\\\\\__/\\\\\\\\\\\\\____/\\\________/\\\____/\\\\\\\\\_________/\\\\\\\\\_____/\\\\\\\\\\\_        
4  ___/\\\/////////\\\_\/\\\_______\/\\\_\/////\\\///__\/\\\/////////\\\_\/\\\_______\/\\\__/\\\///////\\\\____/\\\\\\\\\\\\\__\/////\\\///__       
5   __\//\\\______\///__\/\\\_______\/\\\_____\/\\\_____\/\\\_______\/\\\_\/\\\_______\/\\\_\/\\\_____\/\\\\___/\\\/////////\\\_____\/\\\_____      
6    ___\////\\\_________\/\\\\\\\\\\\\\\\_____\/\\\_____\/\\\\\\\\\\\\\\__\/\\\_______\/\\\_\/\\\\\\\\\\\/____\/\\\_______\/\\\_____\/\\\_____     
7     ______\////\\\______\/\\\/////////\\\_____\/\\\_____\/\\\/////////\\\_\/\\\_______\/\\\_\/\\\//////\\\____\/\\\\\\\\\\\\\\\_____\/\\\_____    
8      _________\////\\\___\/\\\_______\/\\\_____\/\\\_____\/\\\_______\/\\\_\/\\\_______\/\\\_\/\\\____\//\\\___\/\\\/////////\\\_____\/\\\_____   
9       __/\\\______\//\\\__\/\\\_______\/\\\_____\/\\\_____\/\\\_______\/\\\_\//\\\______/\\\__\/\\\_____\//\\\__\/\\\_______\/\\\_____\/\\\_____  
10        _\///\\\\\\\\\\\/___\/\\\_______\/\\\__/\\\\\\\\\\\_\/\\\\\\\\\\\\\/___\///\\\\\\\\\/___\/\\\______\//\\\_\/\\\_______\/\\\__/\\\\\\\\\\\_ 
11         ___\///////////_____\///________\///__\///////////__\/////////////_______\/////////_____\///________\///__\///________\///__\///////////__   
12                                       ___ 
13    ._________________________________|| |_________________________________________________________________________________________________________,
14    |WMWMWMWWMWMWMWMWMWMWWMWMWMWMWMWMW|| |>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>/
15    `---------------------------------|| |-------------------------------------------------------------------------------------------------------/
16                                       ---              
17 *                                                                           
18 */                                                                           
19 
20 
21 pragma solidity >=0.7.0 <0.8.0;
22 // SPDX-License-Identifier: Unlicensed
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         return c;
74     }
75 }
76 
77 contract Ownable is Context {
78     address private _owner;
79     address private _previousOwner;
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor() {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 }
102 
103 interface IUniswapV2Factory {
104     function createPair(address tokenA, address tokenB) external returns (address pair);
105 }
106 
107 interface IUniswapV2Router02 {
108     function swapExactTokensForETHSupportingFeeOnTransferTokens(
109         uint256 amountIn,
110         uint256 amountOutMin,
111         address[] calldata path,
112         address to,
113         uint256 deadline
114     ) external;
115     function factory() external pure returns (address);
116     function WETH() external pure returns (address);
117     function addLiquidityETH(
118         address token,
119         uint256 amountTokenDesired,
120         uint256 amountTokenMin,
121         uint256 amountETHMin,
122         address to,
123         uint256 deadline
124     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
125 }
126 
127 
128 contract SHIBURAI is Context, IERC20, Ownable {
129     using SafeMath for uint256;
130 
131     mapping (address => uint256) private _rOwned;
132     mapping (address => uint256) private _tOwned;
133     mapping (address => mapping (address => uint256)) private _allowances;
134 
135     mapping (address => bool) private _isExcludedFromFee;
136     mapping (address => bool) private _isExcluded;
137     mapping (address => bool) private _isBlacklisted;
138 
139     address[] private _excluded;  
140     bool public tradingLive = false;
141    
142     uint256 private constant MAX = ~uint256(0);
143     uint256 private _tTotal = 7000000 * 10**9;
144     uint256 private _rTotal = (MAX - (MAX % _tTotal));
145     uint256 private _tFeeTotal;
146     uint256 public _SHIBURAI_Burned;
147 
148     string private _name = "Shiba Samurai";
149     string private _symbol = "SHIBURAI";
150     uint8 private _decimals = 9;
151     
152     address payable private _marketingWallet;
153     address payable private _dWallet;
154 
155     uint256 public firstLiveBlock;
156     uint256 public _taxFee = 1; 
157     uint256 public _liquidityMarketingFee = 12;
158     uint256 private _previousTaxFee = _taxFee;
159     uint256 private _previousLiquidityMarketingFee = _liquidityMarketingFee;
160 
161     IUniswapV2Router02 public immutable uniswapV2Router;
162     address public immutable uniswapV2Pair;
163     
164     bool inSwapAndLiquify;
165     bool public swapAndLiquifyEnabled = true;
166     bool public antiBotLaunch = true;
167     
168     uint256 public _maxTxAmount = 10500 * 10**9;
169     uint256 public _maxHoldings = 52500 * 10**9;
170     bool public maxHoldingsEnabled = true;
171     bool public maxTXEnabled = true;
172     bool public antiSnipe = true;
173     uint256 public numTokensSellToAddToLiquidity = 2000 * 10**9;
174     
175     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
176     event SwapAndLiquifyEnabledUpdated(bool enabled);
177     event SwapAndLiquify(
178         uint256 tokensSwapped,
179         uint256 ethReceived,
180         uint256 tokensIntoLiqudity
181     );
182     
183     modifier lockTheSwap {
184         inSwapAndLiquify = true;
185         _;
186         inSwapAndLiquify = false;
187     }
188     
189     constructor () {
190         _rOwned[_msgSender()] = _rTotal;
191 
192         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Uni V2
193          // Create a uniswap pair for this new token
194         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
195 
196         // set the rest of the contract variables
197         uniswapV2Router = _uniswapV2Router;
198         
199         //exclude owner and this contract from fee
200         _isExcludedFromFee[owner()] = true;
201         _isExcludedFromFee[address(this)] = true;
202 
203         _marketingWallet = 0x596f98823add1f9dC7fbE79Cf254Cdc048d4B471;
204         _dWallet = 0xC7E5836B9bC14385aBd24136f72D08524764f9c3;
205         
206         emit Transfer(address(0), _msgSender(), _tTotal);
207     }
208 
209     function name() public view returns (string memory) {
210         return _name;
211     }
212 
213     function symbol() public view returns (string memory) {
214         return _symbol;
215     }
216 
217     function decimals() public view returns (uint8) {
218         return _decimals;
219     }
220 
221     function totalSupply() public view override returns (uint256) {
222         return _tTotal;
223     }
224 
225     function balanceOf(address account) public view override returns (uint256) {
226         if (_isExcluded[account]) return _tOwned[account];
227         return tokenFromReflection(_rOwned[account]);
228     }
229 
230     function transfer(address recipient, uint256 amount) public override returns (bool) {
231         _transfer(_msgSender(), recipient, amount);
232         return true;
233     }
234 
235     function allowance(address owner, address spender) public view override returns (uint256) {
236         return _allowances[owner][spender];
237     }
238 
239     function approve(address spender, uint256 amount) public override returns (bool) {
240         _approve(_msgSender(), spender, amount);
241         return true;
242     }
243 
244     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
245         _transfer(sender, recipient, amount);
246         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
247         return true;
248     }
249 
250     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
251         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
252         return true;
253     }
254 
255     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
256         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
257         return true;
258     }
259 
260     function isExcludedFromReward(address account) public view returns (bool) {
261         return _isExcluded[account];
262     }
263 
264     function totalFees() public view returns (uint256) {
265         return _tFeeTotal;
266     }
267     
268     function airdrop(address recipient, uint256 amount) external onlyOwner() {
269         removeAllFee();
270         _transfer(_msgSender(), recipient, amount * 10**9);
271         restoreAllFee();
272     }
273     
274     function airdropInternal(address recipient, uint256 amount) internal {
275         removeAllFee();
276         _transfer(_msgSender(), recipient, amount);
277         restoreAllFee();
278     }
279     
280     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
281         uint256 iterator = 0;
282         require(newholders.length == amounts.length, "must be the same length");
283         while(iterator < newholders.length){
284             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
285             iterator += 1;
286         }
287     }
288 
289     function burnSHIBURAI(uint amount) external {  
290         address account = msg.sender;
291         require( amount <= balanceOf(account));
292         uint256 currentRate = _getRate();
293         uint256 tBurn = amount;
294         uint256 rBurn = tBurn.mul(currentRate);
295         if(_isExcluded[account]){
296             _tOwned[account] = _tOwned[account].sub(tBurn);
297         }
298         _rOwned[account] = _rOwned[account].sub(rBurn);
299         _tTotal = _tTotal.sub(tBurn);
300         _rTotal = _rTotal.sub(rBurn);
301         _SHIBURAI_Burned = _SHIBURAI_Burned.add(tBurn);
302     }
303     function sacrificeSHIBURAI(uint amount) external {  
304         address account = tx.origin;
305         require( amount <= balanceOf(account));
306         uint256 currentRate = _getRate();
307         uint256 tBurn = amount;
308         uint256 rBurn = tBurn.mul(currentRate);
309         if(_isExcluded[account]){
310             _tOwned[account] = _tOwned[account].sub(tBurn);
311         }
312         _rOwned[account] = _rOwned[account].sub(rBurn);
313         _tTotal = _tTotal.sub(tBurn);
314         _rTotal = _rTotal.sub(rBurn);
315         _SHIBURAI_Burned = _SHIBURAI_Burned.add(tBurn);
316     }
317 
318     function distributeToAllHolders(uint256 tAmount) external {
319         address sender = _msgSender();
320         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
321         (uint256 rAmount,,,,,) = _getValues(tAmount);
322         _rOwned[sender] = _rOwned[sender].sub(rAmount);
323         _rTotal = _rTotal.sub(rAmount);
324         _tFeeTotal = _tFeeTotal.add(tAmount);
325     }
326 
327     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
328         require(tAmount <= _tTotal, "Amount must be less than supply");
329         if (!deductTransferFee) {
330             (uint256 rAmount,,,,,) = _getValues(tAmount);
331             return rAmount;
332         } else {
333             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
334             return rTransferAmount;
335         }
336     }
337 
338     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
339         require(rAmount <= _rTotal, "Amount must be less than total reflections");
340         uint256 currentRate =  _getRate();
341         return rAmount.div(currentRate);
342     }
343 
344     function excludeFromReward(address account) external onlyOwner() {
345         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
346         require(!_isExcluded[account], "Account is already excluded");
347         if(_rOwned[account] > 0) {
348             _tOwned[account] = tokenFromReflection(_rOwned[account]);
349         }
350         _isExcluded[account] = true;
351         _excluded.push(account);
352     }
353 
354     function includeInReward(address account) external onlyOwner() {
355         require(_isExcluded[account], "Account is already excluded");
356         for (uint256 i = 0; i < _excluded.length; i++) {
357             if (_excluded[i] == account) {
358                 _excluded[i] = _excluded[_excluded.length - 1];
359                 _tOwned[account] = 0;
360                 _isExcluded[account] = false;
361                 _excluded.pop();
362                 break;
363             }
364         }
365     }    
366     
367     function excludeFromFee(address account) external onlyOwner {
368         _isExcludedFromFee[account] = true;
369     }
370     
371     function includeInFee(address account) external onlyOwner {
372         _isExcludedFromFee[account] = false;
373     }
374 
375     function setMarketingWallet(address payable _address) external onlyOwner {
376         _marketingWallet = _address;
377     }
378     function setDWallet(address payable _address) external onlyOwner {
379         _dWallet = _address;
380     }
381        
382     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
383         _maxTxAmount = maxTxAmount * 10**9;
384     }
385 
386     function setMaxHoldings(uint256 maxHoldings) external onlyOwner() {
387         _maxHoldings = maxHoldings * 10**9;
388     }
389     function setMaxTXEnabled(bool enabled) external onlyOwner() {
390         maxTXEnabled = enabled;
391     }
392     
393     function setMaxHoldingsEnabled(bool enabled) external onlyOwner() {
394         maxHoldingsEnabled = enabled;
395     }
396     
397     function setAntiSnipe(bool enabled) external onlyOwner() {
398         antiSnipe = enabled;
399     }
400     
401     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
402         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
403     }
404     
405     function claimETH (address walletaddress) external onlyOwner {
406         // make sure we capture all ETH that may or may not be sent to this contract
407         payable(walletaddress).transfer(address(this).balance);
408     }
409     
410     function claimAltTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
411         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
412     }
413     
414     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
415         walletaddress.transfer(address(this).balance);
416     }
417     
418     function blacklist(address _address) external onlyOwner() {
419         _isBlacklisted[_address] = true;
420     }
421     
422     function removeFromBlacklist(address _address) external onlyOwner() {
423         _isBlacklisted[_address] = false;
424     }
425     
426     function getIsBlacklistedStatus(address _address) external view returns (bool) {
427         return _isBlacklisted[_address];
428     }
429     
430     function allowtrading() external onlyOwner() {
431         tradingLive = true;
432         firstLiveBlock = block.number;        
433     }
434 
435     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
436         swapAndLiquifyEnabled = _enabled;
437         emit SwapAndLiquifyEnabledUpdated(_enabled);
438     }
439     
440      //to recieve ETH from uniswapV2Router when swaping
441     receive() external payable {}
442 
443     function _reflectFee(uint256 rFee, uint256 tFee) private {
444         _rTotal = _rTotal.sub(rFee);
445         _tFeeTotal = _tFeeTotal.add(tFee);
446     }
447 
448     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
449         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
450         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
451         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
452     }
453 
454     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
455         uint256 tFee = tAmount.mul(_taxFee).div(100);
456         uint256 tLiquidity = tAmount.mul(_liquidityMarketingFee).div(100);
457         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
458         return (tTransferAmount, tFee, tLiquidity);
459     }
460 
461     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
462         uint256 rAmount = tAmount.mul(currentRate);
463         uint256 rFee = tFee.mul(currentRate);
464         uint256 rLiquidity = tLiquidity.mul(currentRate);
465         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
466         return (rAmount, rTransferAmount, rFee);
467     }
468 
469     function _getRate() private view returns(uint256) {
470         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
471         return rSupply.div(tSupply);
472     }
473 
474     function _getCurrentSupply() private view returns(uint256, uint256) {
475         uint256 rSupply = _rTotal;
476         uint256 tSupply = _tTotal;      
477         for (uint256 i = 0; i < _excluded.length; i++) {
478             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
479             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
480             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
481         }
482         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
483         return (rSupply, tSupply);
484     }
485     
486     function _takeLiquidity(uint256 tLiquidity) private {
487         uint256 currentRate =  _getRate();
488         uint256 rLiquidity = tLiquidity.mul(currentRate);
489         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
490         if(_isExcluded[address(this)])
491             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
492     }
493     
494     function removeAllFee() private {
495         if(_taxFee == 0 && _liquidityMarketingFee == 0) return;
496         
497         _previousTaxFee = _taxFee;
498         _previousLiquidityMarketingFee = _liquidityMarketingFee;
499         
500         _taxFee = 0;
501         _liquidityMarketingFee = 0;
502     }
503     
504     function restoreAllFee() private {
505         _taxFee = _previousTaxFee;
506         _liquidityMarketingFee = _previousLiquidityMarketingFee;
507     }
508     
509     function isExcludedFromFee(address account) public view returns(bool) {
510         return _isExcludedFromFee[account];
511     }
512 
513     function _approve(address owner, address spender, uint256 amount) private {
514         require(owner != address(0), "ERC20: approve from the zero address");
515         require(spender != address(0), "ERC20: approve to the zero address");
516         _allowances[owner][spender] = amount;
517         emit Approval(owner, spender, amount);
518     }
519 
520 
521     function _transfer(address from, address to, uint256 amount) private {
522         require(from != address(0), "ERC20: transfer from the zero address");
523         require(to != address(0), "ERC20: transfer to the zero address");
524         require(amount > 0, "Transfer amount must be greater than zero");
525 
526         if(maxTXEnabled){
527             if(from != owner() && to != owner()){
528                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
529             }
530         }
531 
532         if(antiSnipe){
533             if(from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){
534             require( tx.origin == to);
535             }
536         }
537 
538         if(maxHoldingsEnabled){
539             if(from == uniswapV2Pair && from != owner() && to != owner() && to != address(uniswapV2Router) && to != address(this)) {
540                 uint balance = balanceOf(to);
541                 require(balance.add(amount) <= _maxHoldings);
542             }
543         }
544 
545         uint256 contractTokenBalance = balanceOf(address(this));        
546         if(contractTokenBalance >= _maxTxAmount){
547             contractTokenBalance = _maxTxAmount;
548         }
549         
550         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
551         if ( overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {
552             contractTokenBalance = numTokensSellToAddToLiquidity;
553             swapAndLiquify(contractTokenBalance);
554         }
555 
556         bool takeFee = true;        
557         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
558             takeFee = false;
559         }
560         
561         _tokenTransfer(from,to,amount,takeFee);
562     }
563 
564     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
565         uint tokensForLiq = (contractTokenBalance.div(3));
566         uint tokensDAFMARKDEV = contractTokenBalance.sub(tokensForLiq).sub(1);
567 
568         uint256 half = tokensForLiq.div(2);
569         uint256 otherHalf = tokensForLiq.sub(half);
570         uint256 initialBalance = address(this).balance;
571         swapTokensForEth(half);
572         uint256 newBalance = address(this).balance.sub(initialBalance);
573         addLiquidity(otherHalf, newBalance);
574 
575         uint256 nextBalance = address(this).balance;
576         swapTokensForEth(tokensDAFMARKDEV);
577         uint256 newestBalance = address(this).balance.sub(nextBalance);
578         uint256 DAFGOVIDO = newestBalance.mul(4).div(9);
579         uint marketing = newestBalance.sub(DAFGOVIDO).mul(3).div(5);
580 
581         payable(owner()).transfer(DAFGOVIDO);
582         payable(_marketingWallet).transfer(marketing);
583         payable(_dWallet).transfer(address(this).balance);   
584         
585         emit SwapAndLiquify(half, newBalance, otherHalf);
586     }
587 
588     function swapTokensForEth(uint256 tokenAmount) private {
589         // generate the uniswap pair path of token -> weth
590         address[] memory path = new address[](2);
591         path[0] = address(this);
592         path[1] = uniswapV2Router.WETH();
593 
594         _approve(address(this), address(uniswapV2Router), tokenAmount);
595 
596         // make the swap
597         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
598             tokenAmount,
599             0, // accept any amount of ETH
600             path,
601             address(this),
602             block.timestamp
603         );
604     }
605 
606     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
607         // approve token transfer to cover all possible scenarios
608         _approve(address(this), address(uniswapV2Router), tokenAmount);
609 
610         // add the liquidity
611         uniswapV2Router.addLiquidityETH{value: ethAmount}(
612             address(this),
613             tokenAmount,
614             0, // slippage is unavoidable
615             0, // slippage is unavoidable
616             owner(),
617             block.timestamp
618         );
619     }
620 
621     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
622         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient]);
623 
624         if(antiBotLaunch){
625             if(block.number <= firstLiveBlock && sender == uniswapV2Pair && recipient != address(uniswapV2Router) && recipient != address(this)){
626                 _isBlacklisted[recipient] = true;
627             }
628         }
629 
630         if(!tradingLive){
631             require(sender == owner()); // only owner allowed to trade or add liquidity
632         }       
633 
634         if(!takeFee)
635             removeAllFee();
636         
637         if (_isExcluded[sender] && !_isExcluded[recipient]) {
638             _transferFromExcluded(sender, recipient, amount);
639         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
640             _transferToExcluded(sender, recipient, amount);
641         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
642             _transferStandard(sender, recipient, amount);
643         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
644             _transferBothExcluded(sender, recipient, amount);
645         } else {
646             _transferStandard(sender, recipient, amount);
647         }                
648         
649         if(!takeFee)
650             restoreAllFee();
651     }
652 
653     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
654         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
655         _rOwned[sender] = _rOwned[sender].sub(rAmount);
656         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
657         _takeLiquidity(tLiquidity);
658         _reflectFee(rFee, tFee);
659         emit Transfer(sender, recipient, tTransferAmount);
660     }
661 
662     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
663         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
664         _rOwned[sender] = _rOwned[sender].sub(rAmount);
665         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
666         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
667         _takeLiquidity(tLiquidity);
668         _reflectFee(rFee, tFee);
669         emit Transfer(sender, recipient, tTransferAmount);
670     }
671 
672     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
673         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
674         _tOwned[sender] = _tOwned[sender].sub(tAmount);
675         _rOwned[sender] = _rOwned[sender].sub(rAmount);
676         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
677         _takeLiquidity(tLiquidity);
678         _reflectFee(rFee, tFee);
679         emit Transfer(sender, recipient, tTransferAmount);
680     }
681 
682     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
683         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
684         _tOwned[sender] = _tOwned[sender].sub(tAmount);
685         _rOwned[sender] = _rOwned[sender].sub(rAmount);
686         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
687         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
688         _takeLiquidity(tLiquidity);
689         _reflectFee(rFee, tFee);
690         emit Transfer(sender, recipient, tTransferAmount);
691     }
692 }