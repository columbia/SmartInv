1 // X2.0 https://t.me/X20_portal
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.18;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address payable) {
9         return payable(msg.sender);
10     }
11 
12     function _msgData() internal view virtual returns (bytes memory) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 
19 interface IERC20
20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55 
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58 
59         return c;
60     }
61 
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72         return c;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return mod(a, b, "SafeMath: modulo by zero");
77     }
78 
79     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b != 0, errorMessage);
81         return a % b;
82     }
83 }
84 
85 
86 
87 contract Ownable is Context {
88     address private _owner;
89     address private _previousOwner;
90     uint256 private _lockTime;
91 
92     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94     constructor () {
95         address msgSender = _msgSender();
96         _owner = msgSender;
97         emit OwnershipTransferred(address(0), msgSender);
98     }
99 
100     function owner() public view returns (address) {
101         return _owner;
102     }
103 
104     modifier onlyOwner() {
105         require(_owner == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     function renounceOwnership() public virtual onlyOwner {
110         emit OwnershipTransferred(_owner, address(0));
111         _owner = address(0);
112     }
113 
114     function transferOwnership(address newOwner) public virtual onlyOwner {
115         require(newOwner != address(0), "Ownable: new owner is the zero address");
116         emit OwnershipTransferred(_owner, newOwner);
117         _owner = newOwner;
118     }
119 
120 }
121 
122 interface IUniswapV2Factory {
123     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
124     function createPair(address tokenA, address tokenB) external returns (address pair);}
125 
126 
127 // pragma solidity >=0.5.0;
128 
129 interface IUniswapV2Pair {
130     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
131         function factory() external view returns (address);
132 
133 }
134 
135 // pragma solidity >=0.6.2;
136 
137 interface IUniswapV2Router01 {
138     function factory() external pure returns (address);
139     function WETH() external pure returns (address);
140 
141     function addLiquidityETH(
142         address token,
143         uint amountTokenDesired,
144         uint amountTokenMin,
145         uint amountETHMin,
146         address to,
147         uint deadline
148     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
149 
150 }
151 
152 
153 
154 // pragma solidity >=0.6.2;
155 
156 interface IUniswapV2Router02 is IUniswapV2Router01 {
157 
158     function swapExactETHForTokensSupportingFeeOnTransferTokens(
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external payable;
164 
165     function swapExactTokensForETHSupportingFeeOnTransferTokens(
166         uint amountIn,
167         uint amountOutMin,
168         address[] calldata path,
169         address to,
170         uint deadline
171     ) external;
172 }
173 
174 
175 contract LockToken is Ownable {
176     bool public isOpen = false;
177     mapping(address => bool) private _whiteList;
178     modifier open(address from, address to) {
179         require(isOpen || _whiteList[from] || _whiteList[to], "Not Open");
180         _;
181     }
182 
183     constructor() {
184         _whiteList[msg.sender] = true;
185         _whiteList[address(this)] = true;
186     }
187 
188     function openTrade() external onlyOwner
189     {
190         isOpen = true;
191     }
192 
193     function includeToWhiteList(address _address) public onlyOwner {
194         _whiteList[_address] = true;
195     }
196 
197 }
198 
199 contract X20 is Context, IERC20, LockToken 
200 {
201 
202     using SafeMath for uint256;
203     address payable public marketingAddress = payable(0x39Ac3dA82Bb563b8B449b2Dd2254e1A210EE3e61);
204     address payable public devAddress = payable(0x39Ac3dA82Bb563b8B449b2Dd2254e1A210EE3e61);
205     address public newOwner = 0xA041D8a630EE149c4d3C889C00a5591F43e1E5b2;
206     address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
207     mapping (address => uint256) private _rOwned;
208     mapping (address => uint256) private _tOwned;
209     mapping (address => mapping (address => uint256)) private _allowances;
210 
211     mapping (address => bool) private _isExcludedFromFee;
212     mapping (address => bool) private _isExcludedFromWhale;
213     mapping (address => bool) private _isExcluded;
214 
215     address[] private _excluded;
216    
217     string private _name = "X 2.0";
218     string private _symbol = "X2.0";
219     uint8 private _decimals = 18;
220 
221     uint256 private constant MAX = ~uint256(0);
222     uint256 private _tTotal = 1000000000000 * 10**18;
223     uint256 private _rTotal = (MAX - (MAX % _tTotal));
224     uint256 private _tFeeTotal;
225 
226     uint256 public _buyLiquidityFee = 0;
227     uint256 public _buyMarketingFee = 500;
228     uint256 public _buyDevFee = 0;
229 
230     uint256 public buyTotalFee = _buyLiquidityFee+_buyMarketingFee+_buyDevFee;
231     uint256[] buyFeesBackup = [_buyLiquidityFee, _buyMarketingFee, _buyDevFee];
232               
233     uint256 public _sellLiquidityFee = 0;
234     uint256 public _sellMarketingFee = 800;
235     uint256 public  _sellDevFee = 0;
236 
237     uint256 public sellTotalFee = _sellLiquidityFee+_sellMarketingFee+_sellDevFee;
238 
239     uint256 public _tfrLiquidityFee = 0;
240     uint256 public _tfrMarketingFee = 10;
241     uint256 public  _tfrDevFee = 10;
242     uint256 public transferTotalFee = _tfrLiquidityFee+_tfrMarketingFee+_tfrDevFee;
243 
244     uint256 public _maxTxAmount = _tTotal.div(100).mul(1); //x% of total supply
245     uint256 public _walletHoldingMaxLimit =  _tTotal.div(200).mul(2); //x% of total supply
246     uint256 private minimumTokensBeforeSwap = 2000000000 * 10**18;
247 
248         
249     IUniswapV2Router02 public immutable uniswapV2Router;
250     address public immutable uniswapV2Pair;
251     
252     bool inSwapAndLiquify;
253     bool public swapAndLiquifyEnabled = true;
254 
255     event SwapAndLiquifyEnabledUpdated(bool enabled);
256     event SwapAndLiquify(
257         uint256 tokensSwapped,
258         uint256 ethReceived,
259         uint256 tokensIntoLiqudity
260     );
261         
262     event SwapTokensForETH(
263         uint256 amountIn,
264         address[] path
265     );
266     
267     modifier lockTheSwap {
268         inSwapAndLiquify = true;
269         _;
270         inSwapAndLiquify = false;
271     }
272     
273     constructor() {
274         _rOwned[newOwner] = _rTotal;
275         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
276         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
277             .createPair(address(this), _uniswapV2Router.WETH());
278         uniswapV2Router = _uniswapV2Router;
279         _isExcludedFromFee[newOwner] = true;
280         _isExcludedFromFee[address(this)] = true;
281         includeToWhiteList(newOwner);
282         _isExcludedFromWhale[newOwner] = true;
283         emit Transfer(address(0), newOwner, _tTotal);
284         excludeWalletsFromWhales();
285 
286         transferOwnership(newOwner);
287     }
288 
289     function name() public view returns (string memory) {
290         return _name;
291     }
292 
293     function symbol() public view returns (string memory) {
294         return _symbol;
295     }
296 
297     function decimals() public view returns (uint8) {
298         return _decimals;
299     }
300 
301     function totalSupply() public view override returns (uint256) {
302         return _tTotal;
303     }
304 
305     function balanceOf(address account) public view override returns (uint256) {
306         if (_isExcluded[account]) return _tOwned[account];
307         return tokenFromReflection(_rOwned[account]);
308     }
309 
310     function transfer(address recipient, uint256 amount) public override returns (bool) {
311         _transfer(_msgSender(), recipient, amount);
312         return true;
313     }
314 
315     function allowance(address owner, address spender) public view override returns (uint256) {
316         return _allowances[owner][spender];
317     }
318 
319     function approve(address spender, uint256 amount) public override returns (bool) {
320         _approve(_msgSender(), spender, amount);
321         return true;
322     }
323 
324     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
325         _transfer(sender, recipient, amount);
326         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
327         return true;
328     }
329 
330     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
331         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
332         return true;
333     }
334 
335     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
336         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
337         return true;
338     }
339 
340 
341     function totalFees() public view returns (uint256) {
342         return _tFeeTotal;
343     }
344 
345     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
346         return minimumTokensBeforeSwap;
347     }
348 
349     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
350         require(rAmount <= _rTotal, "Amount must be less than total reflections");
351         uint256 currentRate =  _getRate();
352         return rAmount.div(currentRate);
353     }
354 
355     function _approve(address owner, address spender, uint256 amount) private
356     {
357         require(owner != address(0), "ERC20: approve from the zero address");
358         require(spender != address(0), "ERC20: approve to the zero address");
359         _allowances[owner][spender] = amount;
360         emit Approval(owner, spender, amount);
361     }
362 
363     function _transfer(address from, address to, uint256 amount) private open(from, to)
364     {
365         require(from != address(0), "ERC20: transfer from the zero address");
366         require(to != address(0), "ERC20: transfer to the zero address");
367         require(amount > 0, "Transfer amount must be greater than zero");
368         if(from != owner() && to != owner()) {
369             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
370         }
371 
372         uint256 contractTokenBalance = balanceOf(address(this));
373         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
374 
375         checkForWhale(from, to, amount);
376 
377         if (!inSwapAndLiquify && swapAndLiquifyEnabled && from != uniswapV2Pair)
378         {
379             if (overMinimumTokenBalance)
380             {
381                 contractTokenBalance = minimumTokensBeforeSwap;
382                 swapTokens(contractTokenBalance);
383             }
384         }
385 
386         bool takeFee = true;
387 
388         //if any account belongs to _isExcludedFromFee account then remove the fee
389         if(_isExcludedFromFee[from] || _isExcludedFromFee[to])
390         {
391             takeFee = false;
392         }
393         _tokenTransfer(from, to, amount, takeFee);
394     }
395 
396 
397     function swapTokens(uint256 contractTokenBalance) private lockTheSwap
398     {
399         uint256 __buyTotalFee  = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDevFee);    
400         uint256 __sellTotalFee = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDevFee);
401         uint256 totalSwapableFees = __buyTotalFee.add(__sellTotalFee);
402 
403         uint256 halfLiquidityTokens = contractTokenBalance.mul(_buyLiquidityFee+_sellLiquidityFee).div(totalSwapableFees).div(2);
404         uint256 swapableTokens = contractTokenBalance.sub(halfLiquidityTokens);
405         swapTokensForEth(swapableTokens);
406 
407         uint256 newBalance = address(this).balance;
408         uint256 ethForLiquidity = newBalance.mul(_buyLiquidityFee+_sellLiquidityFee).div(totalSwapableFees).div(2);
409 
410         if(halfLiquidityTokens>0 && ethForLiquidity>0)
411         {
412             addLiquidity(halfLiquidityTokens, ethForLiquidity);
413         }
414 
415         uint256 ethForMarketing = newBalance.mul(_buyMarketingFee+_sellMarketingFee).div(totalSwapableFees);
416         if(ethForMarketing>0)
417         {
418            marketingAddress.transfer(ethForMarketing);
419         }
420 
421         uint256 ethForDev = newBalance.sub(ethForLiquidity).sub(ethForMarketing);
422         if(ethForDev>0)
423         {
424             devAddress.transfer(ethForDev);
425         }
426     }
427 
428     function swapTokensForEth(uint256 tokenAmount) private
429     {
430         address[] memory path = new address[](2);
431         path[0] = address(this);
432         path[1] = uniswapV2Router.WETH();
433         _approve(address(this), address(uniswapV2Router), tokenAmount);
434         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
435             tokenAmount,
436             0,
437             path,
438             address(this),
439             block.timestamp
440         );
441         emit SwapTokensForETH(tokenAmount, path);
442     }
443 
444 
445 
446     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
447         // approve token transfer to cover all possible scenarios
448         _approve(address(this), address(uniswapV2Router), tokenAmount);
449 
450         // add the liquidity
451         uniswapV2Router.addLiquidityETH{value: ethAmount}(
452             address(this),
453             tokenAmount,
454             0, // slippage is unavoidable
455             0, // slippage is unavoidable
456             owner(),
457             block.timestamp
458         );
459     }
460 
461 
462     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private
463     {
464         if(!takeFee) 
465         {
466             removeAllFee();
467         }
468         else
469         {
470             if(recipient==uniswapV2Pair)
471             {
472                 setSellFee();
473             }
474 
475             if(sender != uniswapV2Pair && recipient != uniswapV2Pair)
476             {
477                 setWalletToWalletTransferFee();
478             }
479         }
480 
481 
482         if (_isExcluded[sender] && !_isExcluded[recipient]) {
483             _transferFromExcluded(sender, recipient, amount);
484         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
485             _transferToExcluded(sender, recipient, amount);
486         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
487             _transferBothExcluded(sender, recipient, amount);
488         } else {
489             _transferStandard(sender, recipient, amount);
490         }
491 
492         restoreAllFee();
493 
494     }
495 
496     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
497         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount,  uint256 tLiquidity) = _getValues(tAmount);
498         _rOwned[sender] = _rOwned[sender].sub(rAmount);
499         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
500         _takeLiquidity(tLiquidity);
501         emit Transfer(sender, recipient, tTransferAmount);
502         if(tLiquidity>0)  { emit Transfer(sender, address(this), tLiquidity); }
503     }
504 
505     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
506         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity) = _getValues(tAmount);
507 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
508         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
509         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
510         _takeLiquidity(tLiquidity);
511         emit Transfer(sender, recipient, tTransferAmount);
512         if(tLiquidity>0)  { emit Transfer(sender, address(this), tLiquidity); }
513     }
514 
515     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
516         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity) = _getValues(tAmount);
517     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
518         _rOwned[sender] = _rOwned[sender].sub(rAmount);
519         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
520         _takeLiquidity(tLiquidity);
521         emit Transfer(sender, recipient, tTransferAmount);
522         if(tLiquidity>0)  { emit Transfer(sender, address(this), tLiquidity); }
523     }
524 
525     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
526         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity) = _getValues(tAmount);
527     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
528         _rOwned[sender] = _rOwned[sender].sub(rAmount);
529         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
530         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
531         _takeLiquidity(tLiquidity);
532         emit Transfer(sender, recipient, tTransferAmount);
533         if(tLiquidity>0)  { emit Transfer(sender, address(this), tLiquidity); }
534     }
535 
536 
537     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
538         (uint256 tTransferAmount, uint256 tLiquidity) = _getTValues(tAmount);
539         (uint256 rAmount, uint256 rTransferAmount) = _getRValues(tAmount, tLiquidity, _getRate());
540         return (rAmount, rTransferAmount, tTransferAmount, tLiquidity);
541     }
542 
543     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
544         uint256 tLiquidity = calculateLiquidityFee(tAmount);
545         uint256 tTransferAmount = tAmount.sub(tLiquidity);
546         return (tTransferAmount, tLiquidity);
547     }
548 
549     function _getRValues(uint256 tAmount, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256) {
550         uint256 rAmount = tAmount.mul(currentRate);
551         uint256 rLiquidity = tLiquidity.mul(currentRate);
552         uint256 rTransferAmount = rAmount.sub(rLiquidity);
553         return (rAmount, rTransferAmount);
554     }
555 
556     function _getRate() private view returns(uint256) {
557         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
558         return rSupply.div(tSupply);
559     }
560 
561     function _getCurrentSupply() private view returns(uint256, uint256) {
562         uint256 rSupply = _rTotal;
563         uint256 tSupply = _tTotal;
564         for (uint256 i = 0; i < _excluded.length; i++) {
565             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
566             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
567             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
568         }
569         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
570         return (rSupply, tSupply);
571     }
572 
573     function _takeLiquidity(uint256 tLiquidity) private {
574         uint256 currentRate =  _getRate();
575         uint256 rLiquidity = tLiquidity.mul(currentRate);
576         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
577         if(_isExcluded[address(this)]) {
578             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
579         }
580     }
581 
582 
583     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
584         uint256 fees = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDevFee);
585         return _amount.mul(fees).div(1000);
586     }
587 
588 
589     function isExcludedFromFee(address account) public view onlyOwner returns(bool)  {
590         return _isExcludedFromFee[account];
591     }
592 
593     function excludeFromFee(address account) public onlyOwner {
594         _isExcludedFromFee[account] = true;
595     }
596 
597     function includeInFee(address account) public onlyOwner {
598         _isExcludedFromFee[account] = false;
599     }
600 
601     function removeAllFee() private {
602         _buyLiquidityFee = 0;
603         _buyMarketingFee = 0;
604         _buyDevFee = 0;
605     }
606 
607     function restoreAllFee() private
608     {
609         _buyLiquidityFee = buyFeesBackup[0];
610         _buyMarketingFee = buyFeesBackup[1];
611         _buyDevFee = buyFeesBackup[2];
612     }
613 
614     function setSellFee() private
615     {
616         _buyLiquidityFee = _sellLiquidityFee;
617         _buyMarketingFee = _sellMarketingFee;
618         _buyDevFee = _sellDevFee;
619     }
620 
621 
622     function setWalletToWalletTransferFee() private 
623     {
624         _buyLiquidityFee = _tfrLiquidityFee;
625         _buyMarketingFee = _tfrMarketingFee;
626         _buyDevFee = _tfrDevFee;        
627     }
628 
629 
630     function setBuyFeePercentages(uint256 _liquidityFee, uint256  _marketingFee, uint256 _devFee)
631     external onlyOwner()
632     {
633         _buyLiquidityFee = _liquidityFee;
634         _buyMarketingFee = _marketingFee;
635         _buyDevFee = _devFee;
636         buyFeesBackup = [_buyLiquidityFee, _buyMarketingFee, _buyDevFee];
637         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
638         buyTotalFee = _buyLiquidityFee+_buyMarketingFee+_buyDevFee;
639         require(totalFee<=500, "Too High Fee");
640     }
641 
642     function setSellFeePercentages(uint256 _liquidityFee, uint256  _marketingFee, uint256 _devFee)
643     external onlyOwner()
644     {
645         _sellLiquidityFee = _liquidityFee;
646         _sellMarketingFee = _marketingFee;
647         _sellDevFee = _devFee;
648         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
649         sellTotalFee = _sellLiquidityFee+_sellMarketingFee+_sellDevFee;
650         require(totalFee<=500, "Too High Fee");
651     }
652 
653 
654     function setTransferFeePercentages(uint256 _liquidityFee, uint256  _marketingFee, uint256 _devFee)
655     external onlyOwner()
656     {
657         _tfrLiquidityFee = _liquidityFee;
658         _tfrMarketingFee = _marketingFee;
659         _tfrDevFee = _devFee;
660         transferTotalFee = _tfrLiquidityFee+_tfrMarketingFee+_tfrDevFee;
661         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
662         require(totalFee<=500, "Too High Fee");
663     }
664 
665 
666     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner()
667     {
668         _maxTxAmount = maxTxAmount;
669         require(_maxTxAmount>=_tTotal.div(5), "Too low limit");
670     }
671 
672     function setMinimumTokensBeforeSwap(uint256 _minimumTokensBeforeSwap) external onlyOwner()
673     {
674         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
675     }
676 
677     function setMarketingAddress(address _marketingAddress) external onlyOwner()
678     {
679         marketingAddress = payable(_marketingAddress);
680     }
681 
682     function setDevAddress(address _devAddress) external onlyOwner()
683     {
684         devAddress = payable(_devAddress);
685     }
686 
687     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner
688     {
689         swapAndLiquifyEnabled = _enabled;
690         emit SwapAndLiquifyEnabledUpdated(_enabled);
691     }
692 
693     function excludeWalletsFromWhales() private
694     {
695         _isExcludedFromWhale[owner()]=true;
696         _isExcludedFromWhale[address(this)]=true;
697         _isExcludedFromWhale[uniswapV2Pair]=true;
698         _isExcludedFromWhale[devAddress]=true;
699         _isExcludedFromWhale[marketingAddress]=true;
700     }
701 
702 
703     function checkForWhale(address from, address to, uint256 amount)  private view
704     {
705         uint256 newBalance = balanceOf(to).add(amount);
706         if(!_isExcludedFromWhale[from] && !_isExcludedFromWhale[to])
707         {
708             require(newBalance <= _walletHoldingMaxLimit, "Exceeding max tokens limit in the wallet");
709         }
710         if(from==uniswapV2Pair && !_isExcludedFromWhale[to])
711         {
712             require(newBalance <= _walletHoldingMaxLimit, "Exceeding max tokens limit in the wallet");
713         }
714     }
715 
716     function setExcludedFromWhale(address account, bool _enabled) public onlyOwner
717     {
718         _isExcludedFromWhale[account] = _enabled;
719     }
720 
721     function  setWalletMaxHoldingLimit(uint256 _amount) public onlyOwner
722     {
723         _walletHoldingMaxLimit = _amount;
724         require(_walletHoldingMaxLimit > _tTotal.div(100).mul(1), "Too less limit"); //min 1%
725 
726     }
727 
728     function rescueStuckBalance () public onlyOwner {
729         (bool success, ) = msg.sender.call{value: address(this).balance}("");
730         require(success, "Transfer failed.");
731     }
732 
733     receive() external payable {}
734 
735 }