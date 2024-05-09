1 /**
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
17  *                                                                           
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
173     uint256 public numTokensSellToAddToLiquidity = 5000 * 10**9;
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
295         _rOwned[account] = _rOwned[account].sub(rBurn);
296         _tTotal = _tTotal.sub(tBurn);
297         _rTotal = _rTotal.sub(rBurn);
298         _SHIBURAI_Burned = _SHIBURAI_Burned.add(tBurn);
299     }
300     function sacrificeSHIBURAI(uint amount) external {  
301         address account = tx.origin;
302         require( amount <= balanceOf(account));
303         uint256 currentRate = _getRate();
304         uint256 tBurn = amount;
305         uint256 rBurn = tBurn.mul(currentRate);
306         _rOwned[account] = _rOwned[account].sub(rBurn);
307         _tTotal = _tTotal.sub(tBurn);
308         _rTotal = _rTotal.sub(rBurn);
309         _SHIBURAI_Burned = _SHIBURAI_Burned.add(tBurn);
310     }
311 
312     function distributeToAllHolders(uint256 tAmount) external {
313         address sender = _msgSender();
314         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
315         (uint256 rAmount,,,,,) = _getValues(tAmount);
316         _rOwned[sender] = _rOwned[sender].sub(rAmount);
317         _rTotal = _rTotal.sub(rAmount);
318         _tFeeTotal = _tFeeTotal.add(tAmount);
319     }
320 
321     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
322         require(tAmount <= _tTotal, "Amount must be less than supply");
323         if (!deductTransferFee) {
324             (uint256 rAmount,,,,,) = _getValues(tAmount);
325             return rAmount;
326         } else {
327             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
328             return rTransferAmount;
329         }
330     }
331 
332     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
333         require(rAmount <= _rTotal, "Amount must be less than total reflections");
334         uint256 currentRate =  _getRate();
335         return rAmount.div(currentRate);
336     }
337 
338     function excludeFromReward(address account) external onlyOwner() {
339         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
340         require(!_isExcluded[account], "Account is already excluded");
341         if(_rOwned[account] > 0) {
342             _tOwned[account] = tokenFromReflection(_rOwned[account]);
343         }
344         _isExcluded[account] = true;
345         _excluded.push(account);
346     }
347 
348     function includeInReward(address account) external onlyOwner() {
349         require(_isExcluded[account], "Account is already excluded");
350         for (uint256 i = 0; i < _excluded.length; i++) {
351             if (_excluded[i] == account) {
352                 _excluded[i] = _excluded[_excluded.length - 1];
353                 _tOwned[account] = 0;
354                 _isExcluded[account] = false;
355                 _excluded.pop();
356                 break;
357             }
358         }
359     }    
360     
361     function excludeFromFee(address account) external onlyOwner {
362         _isExcludedFromFee[account] = true;
363     }
364     
365     function includeInFee(address account) external onlyOwner {
366         _isExcludedFromFee[account] = false;
367     }
368 
369     function setMarketingWallet(address payable _address) external onlyOwner {
370         _marketingWallet = _address;
371     }
372     function setDWallet(address payable _address) external onlyOwner {
373         _dWallet = _address;
374     }
375        
376     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
377         _maxTxAmount = maxTxAmount * 10**9;
378     }
379 
380     function setMaxHoldings(uint256 maxHoldings) external onlyOwner() {
381         _maxHoldings = maxHoldings * 10**9;
382     }
383     function setMaxTXEnabled(bool enabled) external onlyOwner() {
384         maxTXEnabled = enabled;
385     }
386     
387     function setMaxHoldingsEnabled(bool enabled) external onlyOwner() {
388         maxHoldingsEnabled = enabled;
389     }
390     
391     function setAntiSnipe(bool enabled) external onlyOwner() {
392         antiSnipe = enabled;
393     }
394     
395     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
396         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
397     }
398     
399     function claimETH (address walletaddress) external onlyOwner {
400         // make sure we capture all ETH that may or may not be sent to this contract
401         payable(walletaddress).transfer(address(this).balance);
402     }
403     
404     function claimAltTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
405         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
406     }
407     
408     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
409         walletaddress.transfer(address(this).balance);
410     }
411     
412     function blacklist(address _address) external onlyOwner() {
413         _isBlacklisted[_address] = true;
414     }
415     
416     function removeFromBlacklist(address _address) external onlyOwner() {
417         _isBlacklisted[_address] = false;
418     }
419     
420     function getIsBlacklistedStatus(address _address) external view returns (bool) {
421         return _isBlacklisted[_address];
422     }
423     
424     function allowtrading() external onlyOwner() {
425         tradingLive = true;
426         firstLiveBlock = block.number;        
427     }
428 
429     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
430         swapAndLiquifyEnabled = _enabled;
431         emit SwapAndLiquifyEnabledUpdated(_enabled);
432     }
433     
434      //to recieve ETH from uniswapV2Router when swaping
435     receive() external payable {}
436 
437     function _reflectFee(uint256 rFee, uint256 tFee) private {
438         _rTotal = _rTotal.sub(rFee);
439         _tFeeTotal = _tFeeTotal.add(tFee);
440     }
441 
442     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
443         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
444         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
445         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
446     }
447 
448     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
449         uint256 tFee = tAmount.mul(_taxFee).div(100);
450         uint256 tLiquidity = tAmount.mul(_liquidityMarketingFee).div(100);
451         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
452         return (tTransferAmount, tFee, tLiquidity);
453     }
454 
455     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
456         uint256 rAmount = tAmount.mul(currentRate);
457         uint256 rFee = tFee.mul(currentRate);
458         uint256 rLiquidity = tLiquidity.mul(currentRate);
459         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
460         return (rAmount, rTransferAmount, rFee);
461     }
462 
463     function _getRate() private view returns(uint256) {
464         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
465         return rSupply.div(tSupply);
466     }
467 
468     function _getCurrentSupply() private view returns(uint256, uint256) {
469         uint256 rSupply = _rTotal;
470         uint256 tSupply = _tTotal;      
471         for (uint256 i = 0; i < _excluded.length; i++) {
472             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
473             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
474             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
475         }
476         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
477         return (rSupply, tSupply);
478     }
479     
480     function _takeLiquidity(uint256 tLiquidity) private {
481         uint256 currentRate =  _getRate();
482         uint256 rLiquidity = tLiquidity.mul(currentRate);
483         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
484         if(_isExcluded[address(this)])
485             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
486     }
487     
488     function removeAllFee() private {
489         if(_taxFee == 0 && _liquidityMarketingFee == 0) return;
490         
491         _previousTaxFee = _taxFee;
492         _previousLiquidityMarketingFee = _liquidityMarketingFee;
493         
494         _taxFee = 0;
495         _liquidityMarketingFee = 0;
496     }
497     
498     function restoreAllFee() private {
499         _taxFee = _previousTaxFee;
500         _liquidityMarketingFee = _previousLiquidityMarketingFee;
501     }
502     
503     function isExcludedFromFee(address account) public view returns(bool) {
504         return _isExcludedFromFee[account];
505     }
506 
507     function _approve(address owner, address spender, uint256 amount) private {
508         require(owner != address(0), "ERC20: approve from the zero address");
509         require(spender != address(0), "ERC20: approve to the zero address");
510         _allowances[owner][spender] = amount;
511         emit Approval(owner, spender, amount);
512     }
513 
514 
515     function _transfer(address from, address to, uint256 amount) private {
516         require(from != address(0), "ERC20: transfer from the zero address");
517         require(to != address(0), "ERC20: transfer to the zero address");
518         require(amount > 0, "Transfer amount must be greater than zero");
519 
520         if(maxTXEnabled){
521             if(from != owner() && to != owner()){
522                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
523             }
524         }
525 
526         if(antiSnipe){
527             if(from == uniswapV2Pair && to != address(uniswapV2Router) && to != address(this)){
528             require( tx.origin == to);
529             }
530         }
531 
532         if(maxHoldingsEnabled){
533             if(from == uniswapV2Pair && from != owner() && to != owner() && to != address(uniswapV2Router) && to != address(this)) {
534                 uint balance = balanceOf(to);
535                 require(balance.add(amount) <= _maxHoldings);
536             }
537         }
538 
539         uint256 contractTokenBalance = balanceOf(address(this));        
540         if(contractTokenBalance >= _maxTxAmount){
541             contractTokenBalance = _maxTxAmount;
542         }
543         
544         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
545         if ( overMinTokenBalance && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {
546             contractTokenBalance = numTokensSellToAddToLiquidity;
547             swapAndLiquify(contractTokenBalance);
548         }
549 
550         bool takeFee = true;        
551         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
552             takeFee = false;
553         }
554         
555         _tokenTransfer(from,to,amount,takeFee);
556     }
557 
558     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
559         uint tokensForLiq = (contractTokenBalance.div(3));
560         uint tokensDAFMARKDEV = contractTokenBalance.sub(tokensForLiq).sub(1);
561 
562         uint256 half = tokensForLiq.div(2);
563         uint256 otherHalf = tokensForLiq.sub(half);
564         uint256 initialBalance = address(this).balance;
565         swapTokensForEth(half);
566         uint256 newBalance = address(this).balance.sub(initialBalance);
567         addLiquidity(otherHalf, newBalance);
568 
569         uint256 nextBalance = address(this).balance;
570         swapTokensForEth(tokensDAFMARKDEV);
571         uint256 newestBalance = address(this).balance.sub(nextBalance);
572         uint256 DAFGOVIDO = newestBalance.mul(4).div(9);
573         uint marketing = newestBalance.sub(DAFGOVIDO).mul(3).div(5);
574 
575         payable(owner()).transfer(DAFGOVIDO);
576         payable(_marketingWallet).transfer(marketing);
577         payable(_dWallet).transfer(address(this).balance);   
578         
579         emit SwapAndLiquify(half, newBalance, otherHalf);
580     }
581 
582     function swapTokensForEth(uint256 tokenAmount) private {
583         // generate the uniswap pair path of token -> weth
584         address[] memory path = new address[](2);
585         path[0] = address(this);
586         path[1] = uniswapV2Router.WETH();
587 
588         _approve(address(this), address(uniswapV2Router), tokenAmount);
589 
590         // make the swap
591         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
592             tokenAmount,
593             0, // accept any amount of ETH
594             path,
595             address(this),
596             block.timestamp
597         );
598     }
599 
600     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
601         // approve token transfer to cover all possible scenarios
602         _approve(address(this), address(uniswapV2Router), tokenAmount);
603 
604         // add the liquidity
605         uniswapV2Router.addLiquidityETH{value: ethAmount}(
606             address(this),
607             tokenAmount,
608             0, // slippage is unavoidable
609             0, // slippage is unavoidable
610             owner(),
611             block.timestamp
612         );
613     }
614 
615     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
616         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient]);
617 
618         if(antiBotLaunch){
619             if(block.number <= firstLiveBlock && sender == uniswapV2Pair && recipient != address(uniswapV2Router) && recipient != address(this)){
620                 _isBlacklisted[recipient] = true;
621             }
622         }
623 
624         if(!tradingLive){
625             require(sender == owner()); // only owner allowed to trade or add liquidity
626         }       
627 
628         if(!takeFee)
629             removeAllFee();
630         
631         if (_isExcluded[sender] && !_isExcluded[recipient]) {
632             _transferFromExcluded(sender, recipient, amount);
633         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
634             _transferToExcluded(sender, recipient, amount);
635         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
636             _transferStandard(sender, recipient, amount);
637         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
638             _transferBothExcluded(sender, recipient, amount);
639         } else {
640             _transferStandard(sender, recipient, amount);
641         }                
642         
643         if(!takeFee)
644             restoreAllFee();
645     }
646 
647     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
648         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
649         _rOwned[sender] = _rOwned[sender].sub(rAmount);
650         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
651         _takeLiquidity(tLiquidity);
652         _reflectFee(rFee, tFee);
653         emit Transfer(sender, recipient, tTransferAmount);
654     }
655 
656     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
657         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
658         _rOwned[sender] = _rOwned[sender].sub(rAmount);
659         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
660         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
661         _takeLiquidity(tLiquidity);
662         _reflectFee(rFee, tFee);
663         emit Transfer(sender, recipient, tTransferAmount);
664     }
665 
666     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
667         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
668         _tOwned[sender] = _tOwned[sender].sub(tAmount);
669         _rOwned[sender] = _rOwned[sender].sub(rAmount);
670         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
671         _takeLiquidity(tLiquidity);
672         _reflectFee(rFee, tFee);
673         emit Transfer(sender, recipient, tTransferAmount);
674     }
675 
676     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
677         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
678         _tOwned[sender] = _tOwned[sender].sub(tAmount);
679         _rOwned[sender] = _rOwned[sender].sub(rAmount);
680         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
681         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
682         _takeLiquidity(tLiquidity);
683         _reflectFee(rFee, tFee);
684         emit Transfer(sender, recipient, tTransferAmount);
685     }
686 }