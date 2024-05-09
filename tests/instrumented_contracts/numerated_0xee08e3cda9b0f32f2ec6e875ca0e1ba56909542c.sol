1 // Welcome to Platinum! You escaped elo hell.
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity 0.8.18;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address payable) {
8         return payable(msg.sender);
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 interface IERC20
18 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53 
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56 
57         return c;
58     }
59 
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64 
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69 
70         return c;
71     }
72 
73     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74         return mod(a, b, "SafeMath: modulo by zero");
75     }
76 
77     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b != 0, errorMessage);
79         return a % b;
80     }
81 }
82 
83 
84 
85 contract Ownable is Context {
86     address private _owner;
87     address private _previousOwner;
88     uint256 private _lockTime;
89 
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     constructor () {
93         address msgSender = _msgSender();
94         _owner = msgSender;
95         emit OwnershipTransferred(address(0), msgSender);
96     }
97 
98     function owner() public view returns (address) {
99         return _owner;
100     }
101 
102     modifier onlyOwner() {
103         require(_owner == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     function renounceOwnership() public virtual onlyOwner {
108         emit OwnershipTransferred(_owner, address(0));
109         _owner = address(0);
110     }
111 
112     function transferOwnership(address newOwner) public virtual onlyOwner {
113         require(newOwner != address(0), "Ownable: new owner is the zero address");
114         emit OwnershipTransferred(_owner, newOwner);
115         _owner = newOwner;
116     }
117 
118 }
119 
120 interface IUniswapV2Factory {
121     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
122     function createPair(address tokenA, address tokenB) external returns (address pair);}
123 
124 
125 // pragma solidity >=0.5.0;
126 
127 interface IUniswapV2Pair {
128     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
129         function factory() external view returns (address);
130 
131 }
132 
133 // pragma solidity >=0.6.2;
134 
135 interface IUniswapV2Router01 {
136     function factory() external pure returns (address);
137     function WETH() external pure returns (address);
138 
139     function addLiquidityETH(
140         address token,
141         uint amountTokenDesired,
142         uint amountTokenMin,
143         uint amountETHMin,
144         address to,
145         uint deadline
146     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
147 
148 }
149 
150 
151 
152 // pragma solidity >=0.6.2;
153 
154 interface IUniswapV2Router02 is IUniswapV2Router01 {
155 
156     function swapExactETHForTokensSupportingFeeOnTransferTokens(
157         uint amountOutMin,
158         address[] calldata path,
159         address to,
160         uint deadline
161     ) external payable;
162 
163     function swapExactTokensForETHSupportingFeeOnTransferTokens(
164         uint amountIn,
165         uint amountOutMin,
166         address[] calldata path,
167         address to,
168         uint deadline
169     ) external;
170 }
171 
172 
173 contract LockToken is Ownable {
174     bool public isOpen = false;
175     mapping(address => bool) private _whiteList;
176     modifier open(address from, address to) {
177         require(isOpen || _whiteList[from] || _whiteList[to], "Not Open");
178         _;
179     }
180 
181     constructor() {
182         _whiteList[msg.sender] = true;
183         _whiteList[address(this)] = true;
184     }
185 
186     function openTrade() external onlyOwner
187     {
188         isOpen = true;
189     }
190 
191     function includeToWhiteList(address _address) public onlyOwner {
192         _whiteList[_address] = true;
193     }
194 
195 }
196 
197 contract PLATINUM is Context, IERC20, LockToken 
198 {
199     using SafeMath for uint256;
200     address payable public marketingAddress = payable(0xA95B36Ad5135F9ac5877c6fd8b61b6EF8AB8E2Ed);
201     address payable public devAddress = payable(0x2904C3bF4E1E273E2DdEed9F80bd1C92067268fB);
202     address public newOwner = 0x2904C3bF4E1E273E2DdEed9F80bd1C92067268fB;
203     address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
204     mapping (address => uint256) private _rOwned;
205     mapping (address => uint256) private _tOwned;
206     mapping (address => mapping (address => uint256)) private _allowances;
207     mapping (address => bool) private _isExcludedFromFee;
208     mapping (address => bool) private _isExcludedFromWhale;
209     mapping (address => bool) private _isExcluded;
210     address[] private _excluded;
211     string private _name = "Platinum";
212     string private _symbol = "PLAT";
213     uint8 private _decimals = 18;
214     uint256 private constant MAX = ~uint256(0);
215     uint256 private _tTotal = 21000000 * 10**18;
216     uint256 private _rTotal = (MAX - (MAX % _tTotal));
217     uint256 private _tFeeTotal;
218     uint256 public _buyLiquidityFee = 1;
219     uint256 public _buyMarketingFee = 189;
220     uint256 public _buyDevFee = 10;
221     uint256 public buyTotalFee = _buyLiquidityFee+_buyMarketingFee+_buyDevFee;
222     uint256[] buyFeesBackup = [_buyLiquidityFee, _buyMarketingFee, _buyDevFee];          
223     uint256 public _sellLiquidityFee = 1;
224     uint256 public _sellMarketingFee = 189;
225     uint256 public  _sellDevFee = 10;
226     uint256 public sellTotalFee = _sellLiquidityFee+_sellMarketingFee+_sellDevFee;
227 
228     uint256 public _tfrLiquidityFee = 0;
229     uint256 public _tfrMarketingFee = 0;
230     uint256 public  _tfrDevFee = 0;
231     uint256 public transferTotalFee = _tfrLiquidityFee+_tfrMarketingFee+_tfrDevFee;
232 
233     uint256 public _maxTxAmount = _tTotal.div(100).mul(1); //x% of total supply
234     uint256 public _walletHoldingMaxLimit =  _tTotal.div(100).mul(2); //x% of total supply
235     uint256 private minimumTokensBeforeSwap = 105000 * 10**18;
236         
237     IUniswapV2Router02 public immutable uniswapV2Router;
238     address public immutable uniswapV2Pair;
239     
240     bool inSwapAndLiquify;
241     bool public swapAndLiquifyEnabled = true;
242 
243     event SwapAndLiquifyEnabledUpdated(bool enabled);
244     event SwapAndLiquify(
245         uint256 tokensSwapped,
246         uint256 ethReceived,
247         uint256 tokensIntoLiqudity
248     );
249         
250     event SwapTokensForETH(
251         uint256 amountIn,
252         address[] path
253     );
254     
255     modifier lockTheSwap {
256         inSwapAndLiquify = true;
257         _;
258         inSwapAndLiquify = false;
259     }
260     
261     constructor() {
262         _rOwned[newOwner] = _rTotal;
263         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
264         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
265             .createPair(address(this), _uniswapV2Router.WETH());
266         uniswapV2Router = _uniswapV2Router;
267         _isExcludedFromFee[newOwner] = true;
268         _isExcludedFromFee[address(this)] = true;
269         includeToWhiteList(newOwner);
270         _isExcludedFromWhale[newOwner] = true;
271         emit Transfer(address(0), newOwner, _tTotal);
272         excludeWalletsFromWhales();
273 
274         transferOwnership(newOwner);
275     }
276 
277     function name() public view returns (string memory) {
278         return _name;
279     }
280 
281     function symbol() public view returns (string memory) {
282         return _symbol;
283     }
284 
285     function decimals() public view returns (uint8) {
286         return _decimals;
287     }
288 
289     function totalSupply() public view override returns (uint256) {
290         return _tTotal;
291     }
292 
293     function balanceOf(address account) public view override returns (uint256) {
294         if (_isExcluded[account]) return _tOwned[account];
295         return tokenFromReflection(_rOwned[account]);
296     }
297 
298     function transfer(address recipient, uint256 amount) public override returns (bool) {
299         _transfer(_msgSender(), recipient, amount);
300         return true;
301     }
302 
303     function allowance(address owner, address spender) public view override returns (uint256) {
304         return _allowances[owner][spender];
305     }
306 
307     function approve(address spender, uint256 amount) public override returns (bool) {
308         _approve(_msgSender(), spender, amount);
309         return true;
310     }
311 
312     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
313         _transfer(sender, recipient, amount);
314         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
315         return true;
316     }
317 
318     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
319         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
320         return true;
321     }
322 
323     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
324         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
325         return true;
326     }
327 
328 
329     function totalFees() public view returns (uint256) {
330         return _tFeeTotal;
331     }
332 
333     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
334         return minimumTokensBeforeSwap;
335     }
336 
337     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
338         require(rAmount <= _rTotal, "Amount must be less than total reflections");
339         uint256 currentRate =  _getRate();
340         return rAmount.div(currentRate);
341     }
342 
343     function _approve(address owner, address spender, uint256 amount) private
344     {
345         require(owner != address(0), "ERC20: approve from the zero address");
346         require(spender != address(0), "ERC20: approve to the zero address");
347         _allowances[owner][spender] = amount;
348         emit Approval(owner, spender, amount);
349     }
350 
351     function _transfer(address from, address to, uint256 amount) private open(from, to)
352     {
353         require(from != address(0), "ERC20: transfer from the zero address");
354         require(to != address(0), "ERC20: transfer to the zero address");
355         require(amount > 0, "Transfer amount must be greater than zero");
356         if(from != owner() && to != owner()) {
357             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
358         }
359 
360         uint256 contractTokenBalance = balanceOf(address(this));
361         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
362 
363         checkForWhale(from, to, amount);
364 
365         if (!inSwapAndLiquify && swapAndLiquifyEnabled && from != uniswapV2Pair)
366         {
367             if (overMinimumTokenBalance)
368             {
369                 contractTokenBalance = minimumTokensBeforeSwap;
370                 swapTokens(contractTokenBalance);
371             }
372         }
373 
374         bool takeFee = true;
375 
376         //if any account belongs to _isExcludedFromFee account then remove the fee
377         if(_isExcludedFromFee[from] || _isExcludedFromFee[to])
378         {
379             takeFee = false;
380         }
381         _tokenTransfer(from, to, amount, takeFee);
382     }
383 
384 
385     function swapTokens(uint256 contractTokenBalance) private lockTheSwap
386     {
387         uint256 __buyTotalFee  = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDevFee);    
388         uint256 __sellTotalFee = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDevFee);
389         uint256 totalSwapableFees = __buyTotalFee.add(__sellTotalFee);
390 
391         uint256 halfLiquidityTokens = contractTokenBalance.mul(_buyLiquidityFee+_sellLiquidityFee).div(totalSwapableFees).div(2);
392         uint256 swapableTokens = contractTokenBalance.sub(halfLiquidityTokens);
393         swapTokensForEth(swapableTokens);
394 
395         uint256 newBalance = address(this).balance;
396         uint256 ethForLiquidity = newBalance.mul(_buyLiquidityFee+_sellLiquidityFee).div(totalSwapableFees).div(2);
397 
398         if(halfLiquidityTokens>0 && ethForLiquidity>0)
399         {
400             addLiquidity(halfLiquidityTokens, ethForLiquidity);
401         }
402 
403         uint256 ethForMarketing = newBalance.mul(_buyMarketingFee+_sellMarketingFee).div(totalSwapableFees);
404         if(ethForMarketing>0)
405         {
406            marketingAddress.transfer(ethForMarketing);
407         }
408 
409         uint256 ethForDev = newBalance.sub(ethForLiquidity).sub(ethForMarketing);
410         if(ethForDev>0)
411         {
412             devAddress.transfer(ethForDev);
413         }
414     }
415 
416     function swapTokensForEth(uint256 tokenAmount) private
417     {
418         address[] memory path = new address[](2);
419         path[0] = address(this);
420         path[1] = uniswapV2Router.WETH();
421         _approve(address(this), address(uniswapV2Router), tokenAmount);
422         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
423             tokenAmount,
424             0,
425             path,
426             address(this),
427             block.timestamp
428         );
429         emit SwapTokensForETH(tokenAmount, path);
430     }
431 
432 
433 
434     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
435         // approve token transfer to cover all possible scenarios
436         _approve(address(this), address(uniswapV2Router), tokenAmount);
437 
438         // add the liquidity
439         uniswapV2Router.addLiquidityETH{value: ethAmount}(
440             address(this),
441             tokenAmount,
442             0, // slippage is unavoidable
443             0, // slippage is unavoidable
444             owner(),
445             block.timestamp
446         );
447     }
448 
449 
450     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private
451     {
452         if(!takeFee) 
453         {
454             removeAllFee();
455         }
456         else
457         {
458             if(recipient==uniswapV2Pair)
459             {
460                 setSellFee();
461             }
462 
463             if(sender != uniswapV2Pair && recipient != uniswapV2Pair)
464             {
465                 setWalletToWalletTransferFee();
466             }
467         }
468 
469 
470         if (_isExcluded[sender] && !_isExcluded[recipient]) {
471             _transferFromExcluded(sender, recipient, amount);
472         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
473             _transferToExcluded(sender, recipient, amount);
474         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
475             _transferBothExcluded(sender, recipient, amount);
476         } else {
477             _transferStandard(sender, recipient, amount);
478         }
479 
480         restoreAllFee();
481 
482     }
483 
484     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
485         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount,  uint256 tLiquidity) = _getValues(tAmount);
486         _rOwned[sender] = _rOwned[sender].sub(rAmount);
487         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
488         _takeLiquidity(tLiquidity);
489         emit Transfer(sender, recipient, tTransferAmount);
490         if(tLiquidity>0)  { emit Transfer(sender, address(this), tLiquidity); }
491     }
492 
493     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
494         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity) = _getValues(tAmount);
495 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
496         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
497         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
498         _takeLiquidity(tLiquidity);
499         emit Transfer(sender, recipient, tTransferAmount);
500         if(tLiquidity>0)  { emit Transfer(sender, address(this), tLiquidity); }
501     }
502 
503     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
504         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity) = _getValues(tAmount);
505     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
506         _rOwned[sender] = _rOwned[sender].sub(rAmount);
507         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
508         _takeLiquidity(tLiquidity);
509         emit Transfer(sender, recipient, tTransferAmount);
510         if(tLiquidity>0)  { emit Transfer(sender, address(this), tLiquidity); }
511     }
512 
513     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
514         (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tLiquidity) = _getValues(tAmount);
515     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
516         _rOwned[sender] = _rOwned[sender].sub(rAmount);
517         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
518         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
519         _takeLiquidity(tLiquidity);
520         emit Transfer(sender, recipient, tTransferAmount);
521         if(tLiquidity>0)  { emit Transfer(sender, address(this), tLiquidity); }
522     }
523 
524 
525     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
526         (uint256 tTransferAmount, uint256 tLiquidity) = _getTValues(tAmount);
527         (uint256 rAmount, uint256 rTransferAmount) = _getRValues(tAmount, tLiquidity, _getRate());
528         return (rAmount, rTransferAmount, tTransferAmount, tLiquidity);
529     }
530 
531     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
532         uint256 tLiquidity = calculateLiquidityFee(tAmount);
533         uint256 tTransferAmount = tAmount.sub(tLiquidity);
534         return (tTransferAmount, tLiquidity);
535     }
536 
537     function _getRValues(uint256 tAmount, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256) {
538         uint256 rAmount = tAmount.mul(currentRate);
539         uint256 rLiquidity = tLiquidity.mul(currentRate);
540         uint256 rTransferAmount = rAmount.sub(rLiquidity);
541         return (rAmount, rTransferAmount);
542     }
543 
544     function _getRate() private view returns(uint256) {
545         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
546         return rSupply.div(tSupply);
547     }
548 
549     function _getCurrentSupply() private view returns(uint256, uint256) {
550         uint256 rSupply = _rTotal;
551         uint256 tSupply = _tTotal;
552         for (uint256 i = 0; i < _excluded.length; i++) {
553             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
554             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
555             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
556         }
557         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
558         return (rSupply, tSupply);
559     }
560 
561     function _takeLiquidity(uint256 tLiquidity) private {
562         uint256 currentRate =  _getRate();
563         uint256 rLiquidity = tLiquidity.mul(currentRate);
564         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
565         if(_isExcluded[address(this)]) {
566             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
567         }
568     }
569 
570 
571     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
572         uint256 fees = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDevFee);
573         return _amount.mul(fees).div(1000);
574     }
575 
576 
577     function isExcludedFromFee(address account) public view onlyOwner returns(bool)  {
578         return _isExcludedFromFee[account];
579     }
580 
581     function excludeFromFee(address account) public onlyOwner {
582         _isExcludedFromFee[account] = true;
583     }
584 
585     function includeInFee(address account) public onlyOwner {
586         _isExcludedFromFee[account] = false;
587     }
588 
589     function removeAllFee() private {
590         _buyLiquidityFee = 0;
591         _buyMarketingFee = 0;
592         _buyDevFee = 0;
593     }
594 
595     function restoreAllFee() private
596     {
597         _buyLiquidityFee = buyFeesBackup[0];
598         _buyMarketingFee = buyFeesBackup[1];
599         _buyDevFee = buyFeesBackup[2];
600     }
601 
602     function setSellFee() private
603     {
604         _buyLiquidityFee = _sellLiquidityFee;
605         _buyMarketingFee = _sellMarketingFee;
606         _buyDevFee = _sellDevFee;
607     }
608 
609 
610     function setWalletToWalletTransferFee() private 
611     {
612         _buyLiquidityFee = _tfrLiquidityFee;
613         _buyMarketingFee = _tfrMarketingFee;
614         _buyDevFee = _tfrDevFee;        
615     }
616 
617 
618     function setBuyFeePercentages(uint256 _liquidityFee, uint256  _marketingFee, uint256 _devFee)
619     external onlyOwner()
620     {
621         _buyLiquidityFee = _liquidityFee;
622         _buyMarketingFee = _marketingFee;
623         _buyDevFee = _devFee;
624         buyFeesBackup = [_buyLiquidityFee, _buyMarketingFee, _buyDevFee];
625         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
626         buyTotalFee = _buyLiquidityFee+_buyMarketingFee+_buyDevFee;
627         require(totalFee<=500, "Too High Fee");
628     }
629 
630     function setSellFeePercentages(uint256 _liquidityFee, uint256  _marketingFee, uint256 _devFee)
631     external onlyOwner()
632     {
633         _sellLiquidityFee = _liquidityFee;
634         _sellMarketingFee = _marketingFee;
635         _sellDevFee = _devFee;
636         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
637         sellTotalFee = _sellLiquidityFee+_sellMarketingFee+_sellDevFee;
638         require(totalFee<=500, "Too High Fee");
639     }
640 
641     function setTransferFeePercentages(uint256 _liquidityFee, uint256  _marketingFee, uint256 _devFee)
642     external onlyOwner()
643     {
644         _tfrLiquidityFee = _liquidityFee;
645         _tfrMarketingFee = _marketingFee;
646         _tfrDevFee = _devFee;
647         transferTotalFee = _tfrLiquidityFee+_tfrMarketingFee+_tfrDevFee;
648         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
649         require(totalFee<=100, "Too High Fee");
650     }
651 
652     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner()
653     {
654         _maxTxAmount = maxTxAmount;
655         require(_maxTxAmount>=_tTotal.div(5), "Too low limit");
656     }
657 
658     function setMinimumTokensBeforeSwap(uint256 _minimumTokensBeforeSwap) external onlyOwner()
659     {
660         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
661     }
662 
663     function setMarketingAddress(address _marketingAddress) external onlyOwner()
664     {
665         marketingAddress = payable(_marketingAddress);
666     }
667 
668     function setDevAddress(address _devAddress) external onlyOwner()
669     {
670         devAddress = payable(_devAddress);
671     }
672 
673     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner
674     {
675         swapAndLiquifyEnabled = _enabled;
676         emit SwapAndLiquifyEnabledUpdated(_enabled);
677     }
678 
679     function excludeWalletsFromWhales() private
680     {
681         _isExcludedFromWhale[owner()]=true;
682         _isExcludedFromWhale[address(this)]=true;
683         _isExcludedFromWhale[uniswapV2Pair]=true;
684         _isExcludedFromWhale[devAddress]=true;
685         _isExcludedFromWhale[marketingAddress]=true;
686     }
687 
688     function checkForWhale(address from, address to, uint256 amount)  private view
689     {
690         uint256 newBalance = balanceOf(to).add(amount);
691         if(!_isExcludedFromWhale[from] && !_isExcludedFromWhale[to])
692         {
693             require(newBalance <= _walletHoldingMaxLimit, "Exceeding max tokens limit in the wallet");
694         }
695         if(from==uniswapV2Pair && !_isExcludedFromWhale[to])
696         {
697             require(newBalance <= _walletHoldingMaxLimit, "Exceeding max tokens limit in the wallet");
698         }
699     }
700 
701     function setExcludedFromWhale(address account, bool _enabled) public onlyOwner
702     {
703         _isExcludedFromWhale[account] = _enabled;
704     }
705 
706     function  setWalletMaxHoldingLimit(uint256 _amount) public onlyOwner
707     {
708         _walletHoldingMaxLimit = _amount;
709         require(_walletHoldingMaxLimit > _tTotal.div(100).mul(1), "Too less limit"); //min 1%
710 
711     }
712 
713     function rescueStuckBalance () public onlyOwner {
714         (bool success, ) = msg.sender.call{value: address(this).balance}("");
715         require(success, "Transfer failed.");
716     }
717 
718     receive() external payable {}
719 }