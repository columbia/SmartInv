1 /* 
2 https://t.me/pedobear
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
20 interface IERC20
21 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         return sub(a, b, "SafeMath: subtraction overflow");
43     }
44 
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56 
57         uint256 c = a * b;
58         require(c / a == b, "SafeMath: multiplication overflow");
59 
60         return c;
61     }
62 
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return div(a, b, "SafeMath: division by zero");
66     }
67 
68     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b > 0, errorMessage);
70         uint256 c = a / b;
71         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72 
73         return c;
74     }
75 
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
77         return mod(a, b, "SafeMath: modulo by zero");
78     }
79 
80     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b != 0, errorMessage);
82         return a % b;
83     }
84 }
85 
86 contract Ownable is Context {
87     address private _owner;
88     address private _previousOwner;
89     uint256 private _lockTime;
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     constructor () {
94         address msgSender = _msgSender();
95         _owner = msgSender;
96         emit OwnershipTransferred(address(0), msgSender);
97     }
98 
99     function owner() public view returns (address) {
100         return _owner;
101     }
102 
103     modifier onlyOwner() {
104         require(_owner == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     function renounceOwnership() public virtual onlyOwner {
109         emit OwnershipTransferred(_owner, address(0));
110         _owner = address(0);
111     }
112 
113     function transferOwnership(address newOwner) public virtual onlyOwner {
114         require(newOwner != address(0), "Ownable: new owner is the zero address");
115         emit OwnershipTransferred(_owner, newOwner);
116         _owner = newOwner;
117     }
118 
119 }
120 
121 interface IUniswapV2Factory {
122     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
123     function createPair(address tokenA, address tokenB) external returns (address pair);}
124 
125 
126 // pragma solidity >=0.5.0;
127 
128 interface IUniswapV2Pair {
129     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
130         function factory() external view returns (address);
131 
132 }
133 
134 // pragma solidity >=0.6.2;
135 
136 interface IUniswapV2Router01 {
137     function factory() external pure returns (address);
138     function WETH() external pure returns (address);
139 
140     function addLiquidityETH(
141         address token,
142         uint amountTokenDesired,
143         uint amountTokenMin,
144         uint amountETHMin,
145         address to,
146         uint deadline
147     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
148 
149 }
150 
151 
152 
153 // pragma solidity >=0.6.2;
154 
155 interface IUniswapV2Router02 is IUniswapV2Router01 {
156 
157     function swapExactETHForTokensSupportingFeeOnTransferTokens(
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external payable;
163 
164     function swapExactTokensForETHSupportingFeeOnTransferTokens(
165         uint amountIn,
166         uint amountOutMin,
167         address[] calldata path,
168         address to,
169         uint deadline
170     ) external;
171 }
172 
173 
174 contract LockToken is Ownable {
175     bool public isOpen = false;
176     mapping(address => bool) private _whiteList;
177     modifier open(address from, address to) {
178         require(isOpen || _whiteList[from] || _whiteList[to], "Not Open");
179         _;
180     }
181 
182     constructor() {
183         _whiteList[msg.sender] = true;
184         _whiteList[address(this)] = true;
185     }
186 
187     function openTrade() external onlyOwner
188     {
189         isOpen = true;
190     }
191 
192     function includeToWhiteList(address _address) public onlyOwner {
193         _whiteList[_address] = true;
194     }
195 
196 }
197 
198 contract PEDOBEAR is Context, IERC20, LockToken 
199 {
200     using SafeMath for uint256;
201     address payable public marketingAddress = payable(0x5445aa66a52a41873737e8c7c036751881aFCc41);
202     address payable public devAddress = payable(0x4Cde68BAfFA72caa10f4310C9f069801424B6973);
203     address public newOwner = 0x4Cde68BAfFA72caa10f4310C9f069801424B6973;
204     address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
205     mapping (address => uint256) private _rOwned;
206     mapping (address => uint256) private _tOwned;
207     mapping (address => mapping (address => uint256)) private _allowances;
208     mapping (address => bool) private _isExcludedFromFee;
209     mapping (address => bool) private _isExcludedFromWhale;
210     mapping (address => bool) private _isExcluded;
211     address[] private _excluded;
212     string private _name = "Pedobear";
213     string private _symbol = "PEDO";
214     uint8 private _decimals = 18;
215     uint256 private constant MAX = ~uint256(0);
216     uint256 private _tTotal = 690000000 * 10**18; //total supply
217     uint256 private _rTotal = (MAX - (MAX % _tTotal));
218     uint256 private _tFeeTotal;
219 
220     uint256 public _buyLiquidityFee = 0;
221     uint256 public _buyMarketingFee = 300;
222     uint256 public _buyDevFee = 0;
223     uint256 public buyTotalFee = _buyLiquidityFee+_buyMarketingFee+_buyDevFee; // buy taxes
224     uint256[] buyFeesBackup = [_buyLiquidityFee, _buyMarketingFee, _buyDevFee];   
225 
226     uint256 public _sellLiquidityFee = 0;
227     uint256 public _sellMarketingFee = 500;
228     uint256 public  _sellDevFee = 0;
229     uint256 public sellTotalFee = _sellLiquidityFee+_sellMarketingFee+_sellDevFee; // sell taxes
230 
231     uint256 public _tfrLiquidityFee = 0;
232     uint256 public _tfrMarketingFee = 0;
233     uint256 public  _tfrDevFee = 0;
234     uint256 public transferTotalFee = _tfrLiquidityFee+_tfrMarketingFee+_tfrDevFee; // transfer taxes
235 
236     uint256 public _maxTxAmount = _tTotal.div(100).mul(1); //x% of total supply
237     uint256 public _walletHoldingMaxLimit =  _tTotal.div(100).mul(2); //x% of total supply
238     uint256 private minimumTokensBeforeSwap = 2070000 * 10**18;
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
574     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
575         uint256 fees = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDevFee);
576         return _amount.mul(fees).div(1000);
577     }
578 
579 
580     function isExcludedFromFee(address account) public view onlyOwner returns(bool)  {
581         return _isExcludedFromFee[account];
582     }
583 
584     function excludeFromFee(address account) public onlyOwner {
585         _isExcludedFromFee[account] = true;
586     }
587 
588     function includeInFee(address account) public onlyOwner {
589         _isExcludedFromFee[account] = false;
590     }
591 
592     function removeAllFee() private {
593         _buyLiquidityFee = 0;
594         _buyMarketingFee = 0;
595         _buyDevFee = 0;
596     }
597 
598     function restoreAllFee() private
599     {
600         _buyLiquidityFee = buyFeesBackup[0];
601         _buyMarketingFee = buyFeesBackup[1];
602         _buyDevFee = buyFeesBackup[2];
603     }
604 
605     function setSellFee() private
606     {
607         _buyLiquidityFee = _sellLiquidityFee;
608         _buyMarketingFee = _sellMarketingFee;
609         _buyDevFee = _sellDevFee;
610     }
611 
612     function setWalletToWalletTransferFee() private 
613     {
614         _buyLiquidityFee = _tfrLiquidityFee;
615         _buyMarketingFee = _tfrMarketingFee;
616         _buyDevFee = _tfrDevFee;        
617     }
618 
619     function setBuyFeePercentages(uint256 _liquidityFee, uint256  _marketingFee, uint256 _devFee)
620     external onlyOwner()
621     {
622         _buyLiquidityFee = _liquidityFee;
623         _buyMarketingFee = _marketingFee;
624         _buyDevFee = _devFee;
625         buyFeesBackup = [_buyLiquidityFee, _buyMarketingFee, _buyDevFee];
626         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
627         buyTotalFee = _buyLiquidityFee+_buyMarketingFee+_buyDevFee;
628         require(totalFee<=800, "Too High Fee");
629     }
630 
631     function setSellFeePercentages(uint256 _liquidityFee, uint256  _marketingFee, uint256 _devFee)
632     external onlyOwner()
633     {
634         _sellLiquidityFee = _liquidityFee;
635         _sellMarketingFee = _marketingFee;
636         _sellDevFee = _devFee;
637         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
638         sellTotalFee = _sellLiquidityFee+_sellMarketingFee+_sellDevFee;
639         require(totalFee<=800, "Too High Fee");
640     }
641 
642 
643     function setTransferFeePercentages(uint256 _liquidityFee, uint256  _marketingFee, uint256 _devFee)
644     external onlyOwner()
645     {
646         _tfrLiquidityFee = _liquidityFee;
647         _tfrMarketingFee = _marketingFee;
648         _tfrDevFee = _devFee;
649         transferTotalFee = _tfrLiquidityFee+_tfrMarketingFee+_tfrDevFee;
650         uint256 totalFee = _liquidityFee.add(_marketingFee).add(_devFee);
651         require(totalFee<=100, "Too High Fee");
652     }
653 
654 
655     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner()
656     {
657         _maxTxAmount = maxTxAmount;
658         require(_maxTxAmount>=_tTotal.div(5), "Too low limit");
659     }
660 
661     function setMinimumTokensBeforeSwap(uint256 _minimumTokensBeforeSwap) external onlyOwner()
662     {
663         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
664     }
665 
666     function setMarketingAddress(address _marketingAddress) external onlyOwner()
667     {
668         marketingAddress = payable(_marketingAddress);
669     }
670 
671     function setDevAddress(address _devAddress) external onlyOwner()
672     {
673         devAddress = payable(_devAddress);
674     }
675 
676     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner
677     {
678         swapAndLiquifyEnabled = _enabled;
679         emit SwapAndLiquifyEnabledUpdated(_enabled);
680     }
681 
682     function excludeWalletsFromWhales() private
683     {
684         _isExcludedFromWhale[owner()]=true;
685         _isExcludedFromWhale[address(this)]=true;
686         _isExcludedFromWhale[uniswapV2Pair]=true;
687         _isExcludedFromWhale[devAddress]=true;
688         _isExcludedFromWhale[marketingAddress]=true;
689     }
690 
691 
692     function checkForWhale(address from, address to, uint256 amount)  private view
693     {
694         uint256 newBalance = balanceOf(to).add(amount);
695         if(!_isExcludedFromWhale[from] && !_isExcludedFromWhale[to])
696         {
697             require(newBalance <= _walletHoldingMaxLimit, "Exceeding max tokens limit in the wallet");
698         }
699         if(from==uniswapV2Pair && !_isExcludedFromWhale[to])
700         {
701             require(newBalance <= _walletHoldingMaxLimit, "Exceeding max tokens limit in the wallet");
702         }
703     }
704 
705     function setExcludedFromWhale(address account, bool _enabled) public onlyOwner
706     {
707         _isExcludedFromWhale[account] = _enabled;
708     }
709 
710     function  setWalletMaxHoldingLimit(uint256 _amount) public onlyOwner
711     {
712         _walletHoldingMaxLimit = _amount;
713         require(_walletHoldingMaxLimit > _tTotal.div(100).mul(1), "Too less limit"); //min 1%
714     }
715 
716     function rescueStuckBalance () public onlyOwner {
717         (bool success, ) = msg.sender.call{value: address(this).balance}("");
718         require(success, "Transfer failed.");
719     }
720 
721     receive() external payable {}
722 }