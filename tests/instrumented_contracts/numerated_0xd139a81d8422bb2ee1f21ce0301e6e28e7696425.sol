1 /* Welcome to XSale, the only launchpad inspired by Twitter X where you can claim your Xs on XS!
2 https://t.me/Xsalepad 
3 */ 
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.18;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return payable(msg.sender);
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 
21 interface IERC20
22 {
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 library SafeMath {
34 
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38 
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
49 
50         return c;
51     }
52 
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57 
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60 
61         return c;
62     }
63 
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73 
74         return c;
75     }
76 
77     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
78         return mod(a, b, "SafeMath: modulo by zero");
79     }
80 
81     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b != 0, errorMessage);
83         return a % b;
84     }
85 }
86 
87 
88 
89 contract Ownable is Context {
90     address private _owner;
91     address private _previousOwner;
92     uint256 private _lockTime;
93 
94     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95 
96     constructor () {
97         address msgSender = _msgSender();
98         _owner = msgSender;
99         emit OwnershipTransferred(address(0), msgSender);
100     }
101 
102     function owner() public view returns (address) {
103         return _owner;
104     }
105 
106     modifier onlyOwner() {
107         require(_owner == _msgSender(), "Ownable: caller is not the owner");
108         _;
109     }
110 
111     function renounceOwnership() public virtual onlyOwner {
112         emit OwnershipTransferred(_owner, address(0));
113         _owner = address(0);
114     }
115 
116     function transferOwnership(address newOwner) public virtual onlyOwner {
117         require(newOwner != address(0), "Ownable: new owner is the zero address");
118         emit OwnershipTransferred(_owner, newOwner);
119         _owner = newOwner;
120     }
121 
122 }
123 
124 interface IUniswapV2Factory {
125     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
126     function createPair(address tokenA, address tokenB) external returns (address pair);}
127 
128 
129 // pragma solidity >=0.5.0;
130 
131 interface IUniswapV2Pair {
132     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
133         function factory() external view returns (address);
134 
135 }
136 
137 // pragma solidity >=0.6.2;
138 
139 interface IUniswapV2Router01 {
140     function factory() external pure returns (address);
141     function WETH() external pure returns (address);
142 
143     function addLiquidityETH(
144         address token,
145         uint amountTokenDesired,
146         uint amountTokenMin,
147         uint amountETHMin,
148         address to,
149         uint deadline
150     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
151 
152 }
153 
154 
155 
156 // pragma solidity >=0.6.2;
157 
158 interface IUniswapV2Router02 is IUniswapV2Router01 {
159 
160     function swapExactETHForTokensSupportingFeeOnTransferTokens(
161         uint amountOutMin,
162         address[] calldata path,
163         address to,
164         uint deadline
165     ) external payable;
166 
167     function swapExactTokensForETHSupportingFeeOnTransferTokens(
168         uint amountIn,
169         uint amountOutMin,
170         address[] calldata path,
171         address to,
172         uint deadline
173     ) external;
174 }
175 
176 
177 contract LockToken is Ownable {
178     bool public isOpen = false;
179     mapping(address => bool) private _whiteList;
180     modifier open(address from, address to) {
181         require(isOpen || _whiteList[from] || _whiteList[to], "Not Open");
182         _;
183     }
184 
185     constructor() {
186         _whiteList[msg.sender] = true;
187         _whiteList[address(this)] = true;
188     }
189 
190     function openTrade() external onlyOwner
191     {
192         isOpen = true;
193     }
194 
195     function includeToWhiteList(address _address) public onlyOwner {
196         _whiteList[_address] = true;
197     }
198 
199 }
200 
201 contract XSALE is Context, IERC20, LockToken 
202 {
203 
204     using SafeMath for uint256;
205     address payable public marketingAddress = payable(0x883626EC1672f8b12Aec23327caC3317806bB048);
206     address payable public devAddress = payable(0x29A28A2c0478fb375CFE84490B12457B56Fe907B);
207     address public newOwner = 0x29A28A2c0478fb375CFE84490B12457B56Fe907B;
208     address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
209     mapping (address => uint256) private _rOwned;
210     mapping (address => uint256) private _tOwned;
211     mapping (address => mapping (address => uint256)) private _allowances;
212     mapping (address => bool) private _isExcludedFromFee;
213     mapping (address => bool) private _isExcludedFromWhale;
214     mapping (address => bool) private _isExcluded;
215     address[] private _excluded;
216     string private _name = "XSale";
217     string private _symbol = "XS";
218     uint8 private _decimals = 18;
219     uint256 private constant MAX = ~uint256(0);
220     uint256 private _tTotal = 1000000 * 10**18;
221     uint256 private _rTotal = (MAX - (MAX % _tTotal));
222     uint256 private _tFeeTotal;
223     uint256 public _buyLiquidityFee = 0;
224     uint256 public _buyMarketingFee = 600;
225     uint256 public _buyDevFee = 0;
226     uint256 public buyTotalFee = _buyLiquidityFee+_buyMarketingFee+_buyDevFee;
227     uint256[] buyFeesBackup = [_buyLiquidityFee, _buyMarketingFee, _buyDevFee];          
228     uint256 public _sellLiquidityFee = 0;
229     uint256 public _sellMarketingFee = 800;
230     uint256 public  _sellDevFee = 0;
231     uint256 public sellTotalFee = _sellLiquidityFee+_sellMarketingFee+_sellDevFee;
232     uint256 public _tfrLiquidityFee = 0;
233     uint256 public _tfrMarketingFee = 10;
234     uint256 public  _tfrDevFee = 10;
235     uint256 public transferTotalFee = _tfrLiquidityFee+_tfrMarketingFee+_tfrDevFee;
236     uint256 public _maxTxAmount = _tTotal.div(100).mul(1); //x% of total supply
237     uint256 public _walletHoldingMaxLimit =  _tTotal.div(100).mul(2); //x% of total supply
238     uint256 private minimumTokensBeforeSwap = 2000 * 10**18;
239 
240         
241     IUniswapV2Router02 public immutable uniswapV2Router;
242     address public immutable uniswapV2Pair;
243     
244     bool inSwapAndLiquify;
245     bool public swapAndLiquifyEnabled = true;
246 
247     event SwapAndLiquifyEnabledUpdated(bool enabled);
248     event SwapAndLiquify(
249         uint256 tokensSwapped,
250         uint256 ethReceived,
251         uint256 tokensIntoLiqudity
252     );
253         
254     event SwapTokensForETH(
255         uint256 amountIn,
256         address[] path
257     );
258     
259     modifier lockTheSwap {
260         inSwapAndLiquify = true;
261         _;
262         inSwapAndLiquify = false;
263     }
264     
265     constructor() {
266         _rOwned[newOwner] = _rTotal;
267         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
268         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
269             .createPair(address(this), _uniswapV2Router.WETH());
270         uniswapV2Router = _uniswapV2Router;
271         _isExcludedFromFee[newOwner] = true;
272         _isExcludedFromFee[address(this)] = true;
273         includeToWhiteList(newOwner);
274         _isExcludedFromWhale[newOwner] = true;
275         emit Transfer(address(0), newOwner, _tTotal);
276         excludeWalletsFromWhales();
277 
278         transferOwnership(newOwner);
279     }
280 
281     function name() public view returns (string memory) {
282         return _name;
283     }
284 
285     function symbol() public view returns (string memory) {
286         return _symbol;
287     }
288 
289     function decimals() public view returns (uint8) {
290         return _decimals;
291     }
292 
293     function totalSupply() public view override returns (uint256) {
294         return _tTotal;
295     }
296 
297     function balanceOf(address account) public view override returns (uint256) {
298         if (_isExcluded[account]) return _tOwned[account];
299         return tokenFromReflection(_rOwned[account]);
300     }
301 
302     function transfer(address recipient, uint256 amount) public override returns (bool) {
303         _transfer(_msgSender(), recipient, amount);
304         return true;
305     }
306 
307     function allowance(address owner, address spender) public view override returns (uint256) {
308         return _allowances[owner][spender];
309     }
310 
311     function approve(address spender, uint256 amount) public override returns (bool) {
312         _approve(_msgSender(), spender, amount);
313         return true;
314     }
315 
316     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
317         _transfer(sender, recipient, amount);
318         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
319         return true;
320     }
321 
322     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
323         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
324         return true;
325     }
326 
327     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
328         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
329         return true;
330     }
331 
332 
333     function totalFees() public view returns (uint256) {
334         return _tFeeTotal;
335     }
336 
337     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
338         return minimumTokensBeforeSwap;
339     }
340 
341     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
342         require(rAmount <= _rTotal, "Amount must be less than total reflections");
343         uint256 currentRate =  _getRate();
344         return rAmount.div(currentRate);
345     }
346 
347     function _approve(address owner, address spender, uint256 amount) private
348     {
349         require(owner != address(0), "ERC20: approve from the zero address");
350         require(spender != address(0), "ERC20: approve to the zero address");
351         _allowances[owner][spender] = amount;
352         emit Approval(owner, spender, amount);
353     }
354 
355     function _transfer(address from, address to, uint256 amount) private open(from, to)
356     {
357         require(from != address(0), "ERC20: transfer from the zero address");
358         require(to != address(0), "ERC20: transfer to the zero address");
359         require(amount > 0, "Transfer amount must be greater than zero");
360         if(from != owner() && to != owner()) {
361             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
362         }
363 
364         uint256 contractTokenBalance = balanceOf(address(this));
365         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
366 
367         checkForWhale(from, to, amount);
368 
369         if (!inSwapAndLiquify && swapAndLiquifyEnabled && from != uniswapV2Pair)
370         {
371             if (overMinimumTokenBalance)
372             {
373                 contractTokenBalance = minimumTokensBeforeSwap;
374                 swapTokens(contractTokenBalance);
375             }
376         }
377 
378         bool takeFee = true;
379 
380         //if any account belongs to _isExcludedFromFee account then remove the fee
381         if(_isExcludedFromFee[from] || _isExcludedFromFee[to])
382         {
383             takeFee = false;
384         }
385         _tokenTransfer(from, to, amount, takeFee);
386     }
387 
388 
389     function swapTokens(uint256 contractTokenBalance) private lockTheSwap
390     {
391         uint256 __buyTotalFee  = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDevFee);    
392         uint256 __sellTotalFee = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDevFee);
393         uint256 totalSwapableFees = __buyTotalFee.add(__sellTotalFee);
394 
395         uint256 halfLiquidityTokens = contractTokenBalance.mul(_buyLiquidityFee+_sellLiquidityFee).div(totalSwapableFees).div(2);
396         uint256 swapableTokens = contractTokenBalance.sub(halfLiquidityTokens);
397         swapTokensForEth(swapableTokens);
398 
399         uint256 newBalance = address(this).balance;
400         uint256 ethForLiquidity = newBalance.mul(_buyLiquidityFee+_sellLiquidityFee).div(totalSwapableFees).div(2);
401 
402         if(halfLiquidityTokens>0 && ethForLiquidity>0)
403         {
404             addLiquidity(halfLiquidityTokens, ethForLiquidity);
405         }
406 
407         uint256 ethForMarketing = newBalance.mul(_buyMarketingFee+_sellMarketingFee).div(totalSwapableFees);
408         if(ethForMarketing>0)
409         {
410            marketingAddress.transfer(ethForMarketing);
411         }
412 
413         uint256 ethForDev = newBalance.sub(ethForLiquidity).sub(ethForMarketing);
414         if(ethForDev>0)
415         {
416             devAddress.transfer(ethForDev);
417         }
418     }
419 
420     function swapTokensForEth(uint256 tokenAmount) private
421     {
422         address[] memory path = new address[](2);
423         path[0] = address(this);
424         path[1] = uniswapV2Router.WETH();
425         _approve(address(this), address(uniswapV2Router), tokenAmount);
426         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
427             tokenAmount,
428             0,
429             path,
430             address(this),
431             block.timestamp
432         );
433         emit SwapTokensForETH(tokenAmount, path);
434     }
435 
436 
437 
438     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
439         // approve token transfer to cover all possible scenarios
440         _approve(address(this), address(uniswapV2Router), tokenAmount);
441 
442         // add the liquidity
443         uniswapV2Router.addLiquidityETH{value: ethAmount}(
444             address(this),
445             tokenAmount,
446             0, // slippage is unavoidable
447             0, // slippage is unavoidable
448             owner(),
449             block.timestamp
450         );
451     }
452 
453 
454     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private
455     {
456         if(!takeFee) 
457         {
458             removeAllFee();
459         }
460         else
461         {
462             if(recipient==uniswapV2Pair)
463             {
464                 setSellFee();
465             }
466 
467             if(sender != uniswapV2Pair && recipient != uniswapV2Pair)
468             {
469                 setWalletToWalletTransferFee();
470             }
471         }
472 
473 
474         if (_isExcluded[sender] && !_isExcluded[recipient]) {
475             _transferFromExcluded(sender, recipient, amount);
476         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
477             _transferToExcluded(sender, recipient, amount);
478         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
479             _transferBothExcluded(sender, recipient, amount);
480         } else {
481             _transferStandard(sender, recipient, amount);
482         }
483 
484         restoreAllFee();
485 
486     }
487 
488     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
489         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount,  uint256 tLiquidity) = _getValues(tAmount);
490         _rOwned[sender] = _rOwned[sender].sub(rAmount);
491         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
492         _takeLiquidity(tLiquidity);
493         emit Transfer(sender, recipient, tTransferAmount);
494         if(tLiquidity>0)  { emit Transfer(sender, address(this), tLiquidity); }
495     }
496 
497     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
498         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity) = _getValues(tAmount);
499 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
500         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
501         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
502         _takeLiquidity(tLiquidity);
503         emit Transfer(sender, recipient, tTransferAmount);
504         if(tLiquidity>0)  { emit Transfer(sender, address(this), tLiquidity); }
505     }
506 
507     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
508         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity) = _getValues(tAmount);
509     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
510         _rOwned[sender] = _rOwned[sender].sub(rAmount);
511         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
512         _takeLiquidity(tLiquidity);
513         emit Transfer(sender, recipient, tTransferAmount);
514         if(tLiquidity>0)  { emit Transfer(sender, address(this), tLiquidity); }
515     }
516 
517     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
518         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity) = _getValues(tAmount);
519     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
520         _rOwned[sender] = _rOwned[sender].sub(rAmount);
521         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
522         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
523         _takeLiquidity(tLiquidity);
524         emit Transfer(sender, recipient, tTransferAmount);
525         if(tLiquidity>0)  { emit Transfer(sender, address(this), tLiquidity); }
526     }
527 
528 
529     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
530         (uint256 tTransferAmount, uint256 tLiquidity) = _getTValues(tAmount);
531         (uint256 rAmount, uint256 rTransferAmount) = _getRValues(tAmount, tLiquidity, _getRate());
532         return (rAmount, rTransferAmount, tTransferAmount, tLiquidity);
533     }
534 
535     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
536         uint256 tLiquidity = calculateLiquidityFee(tAmount);
537         uint256 tTransferAmount = tAmount.sub(tLiquidity);
538         return (tTransferAmount, tLiquidity);
539     }
540 
541     function _getRValues(uint256 tAmount, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256) {
542         uint256 rAmount = tAmount.mul(currentRate);
543         uint256 rLiquidity = tLiquidity.mul(currentRate);
544         uint256 rTransferAmount = rAmount.sub(rLiquidity);
545         return (rAmount, rTransferAmount);
546     }
547 
548     function _getRate() private view returns(uint256) {
549         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
550         return rSupply.div(tSupply);
551     }
552 
553     function _getCurrentSupply() private view returns(uint256, uint256) {
554         uint256 rSupply = _rTotal;
555         uint256 tSupply = _tTotal;
556         for (uint256 i = 0; i < _excluded.length; i++) {
557             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
558             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
559             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
560         }
561         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
562         return (rSupply, tSupply);
563     }
564 
565     function _takeLiquidity(uint256 tLiquidity) private {
566         uint256 currentRate =  _getRate();
567         uint256 rLiquidity = tLiquidity.mul(currentRate);
568         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
569         if(_isExcluded[address(this)]) {
570             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
571         }
572     }
573 
574 
575     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
576         uint256 fees = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDevFee);
577         return _amount.mul(fees).div(1000);
578     }
579 
580 
581     function isExcludedFromFee(address account) public view onlyOwner returns(bool)  {
582         return _isExcludedFromFee[account];
583     }
584 
585     function excludeFromFee(address account) public onlyOwner {
586         _isExcludedFromFee[account] = true;
587     }
588 
589     function includeInFee(address account) public onlyOwner {
590         _isExcludedFromFee[account] = false;
591     }
592 
593     function removeAllFee() private {
594         _buyLiquidityFee = 0;
595         _buyMarketingFee = 0;
596         _buyDevFee = 0;
597     }
598 
599     function restoreAllFee() private
600     {
601         _buyLiquidityFee = buyFeesBackup[0];
602         _buyMarketingFee = buyFeesBackup[1];
603         _buyDevFee = buyFeesBackup[2];
604     }
605 
606     function setSellFee() private
607     {
608         _buyLiquidityFee = _sellLiquidityFee;
609         _buyMarketingFee = _sellMarketingFee;
610         _buyDevFee = _sellDevFee;
611     }
612 
613 
614     function setWalletToWalletTransferFee() private 
615     {
616         _buyLiquidityFee = _tfrLiquidityFee;
617         _buyMarketingFee = _tfrMarketingFee;
618         _buyDevFee = _tfrDevFee;        
619     }
620 
621 
622     function setBuyFeePercentages(uint256 _liquidityFee, uint256  _marketingFee, uint256 _devFee)
623     external onlyOwner()
624     {
625         _buyLiquidityFee = _liquidityFee;
626         _buyMarketingFee = _marketingFee;
627         _buyDevFee = _devFee;
628         buyFeesBackup = [_buyLiquidityFee, _buyMarketingFee, _buyDevFee];
629         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
630         buyTotalFee = _buyLiquidityFee+_buyMarketingFee+_buyDevFee;
631         require(totalFee<=800, "Too High Fee");
632     }
633 
634     function setSellFeePercentages(uint256 _liquidityFee, uint256  _marketingFee, uint256 _devFee)
635     external onlyOwner()
636     {
637         _sellLiquidityFee = _liquidityFee;
638         _sellMarketingFee = _marketingFee;
639         _sellDevFee = _devFee;
640         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
641         sellTotalFee = _sellLiquidityFee+_sellMarketingFee+_sellDevFee;
642         require(totalFee<=800, "Too High Fee");
643     }
644 
645 
646     function setTransferFeePercentages(uint256 _liquidityFee, uint256  _marketingFee, uint256 _devFee)
647     external onlyOwner()
648     {
649         _tfrLiquidityFee = _liquidityFee;
650         _tfrMarketingFee = _marketingFee;
651         _tfrDevFee = _devFee;
652         transferTotalFee = _tfrLiquidityFee+_tfrMarketingFee+_tfrDevFee;
653         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
654         require(totalFee<=100, "Too High Fee");
655     }
656 
657 
658     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner()
659     {
660         _maxTxAmount = maxTxAmount;
661         require(_maxTxAmount>=_tTotal.div(5), "Too low limit");
662     }
663 
664     function setMinimumTokensBeforeSwap(uint256 _minimumTokensBeforeSwap) external onlyOwner()
665     {
666         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
667     }
668 
669     function setMarketingAddress(address _marketingAddress) external onlyOwner()
670     {
671         marketingAddress = payable(_marketingAddress);
672     }
673 
674     function setDevAddress(address _devAddress) external onlyOwner()
675     {
676         devAddress = payable(_devAddress);
677     }
678 
679     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner
680     {
681         swapAndLiquifyEnabled = _enabled;
682         emit SwapAndLiquifyEnabledUpdated(_enabled);
683     }
684 
685     function excludeWalletsFromWhales() private
686     {
687         _isExcludedFromWhale[owner()]=true;
688         _isExcludedFromWhale[address(this)]=true;
689         _isExcludedFromWhale[uniswapV2Pair]=true;
690         _isExcludedFromWhale[devAddress]=true;
691         _isExcludedFromWhale[marketingAddress]=true;
692     }
693 
694 
695     function checkForWhale(address from, address to, uint256 amount)  private view
696     {
697         uint256 newBalance = balanceOf(to).add(amount);
698         if(!_isExcludedFromWhale[from] && !_isExcludedFromWhale[to])
699         {
700             require(newBalance <= _walletHoldingMaxLimit, "Exceeding max tokens limit in the wallet");
701         }
702         if(from==uniswapV2Pair && !_isExcludedFromWhale[to])
703         {
704             require(newBalance <= _walletHoldingMaxLimit, "Exceeding max tokens limit in the wallet");
705         }
706     }
707 
708     function setExcludedFromWhale(address account, bool _enabled) public onlyOwner
709     {
710         _isExcludedFromWhale[account] = _enabled;
711     }
712 
713     function  setWalletMaxHoldingLimit(uint256 _amount) public onlyOwner
714     {
715         _walletHoldingMaxLimit = _amount;
716         require(_walletHoldingMaxLimit > _tTotal.div(100).mul(1), "Too less limit"); //min 1%
717 
718     }
719 
720     function rescueStuckBalance () public onlyOwner {
721         (bool success, ) = msg.sender.call{value: address(this).balance}("");
722         require(success, "Transfer failed.");
723     }
724 
725     receive() external payable {}
726 
727 }