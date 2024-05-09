1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.7;
3 contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 }
8 contract ERC20Ownable is Context {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     constructor() {
14         address msgSender = _msgSender();
15         _owner = msgSender;
16         emit OwnershipTransferred(address(0), msgSender);
17     }
18 
19     function owner() public view virtual returns (address) {
20         return _owner;
21     }
22 
23     modifier onlyOwner() {
24         require(owner() == _msgSender(), "ERC20Ownable: caller is not the owner");
25         _;
26     }
27 
28     function renounceOwnership() public virtual onlyOwner {
29         emit OwnershipTransferred(_owner, address(0));
30         _owner = address(0);
31     }
32 
33     function transferOwnership(address newOwner) public virtual onlyOwner {
34         require(newOwner != address(0), "ERC20Ownable: new owner is the zero address");
35         emit OwnershipTransferred(_owner, newOwner);
36         _owner = newOwner;
37     }
38 }
39 // CAUTION
40 // This version of SafeMath should only be used with Solidity 0.8 or later,
41 // because it relies on the compiler's built in overflow checks.
42 library SafeMath {
43     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {
45             uint256 c = a + b;
46             if (c < a) return (false, 0);
47             return (true, c);
48         }
49     }
50     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             if (b > a) return (false, 0);
53             return (true, a - b);
54         }
55     }
56     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
57         unchecked {
58             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
59             // benefit is lost if 'b' is also tested.
60             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
61             if (a == 0) return (true, 0);
62             uint256 c = a * b;
63             if (c / a != b) return (false, 0);
64             return (true, c);
65         }
66     }
67     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b == 0) return (false, 0);
70             return (true, a / b);
71         }
72     }
73     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         unchecked {
75             if (b == 0) return (false, 0);
76             return (true, a % b);
77         }
78     }
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         return a + b;
81     }
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return a - b;
84     }
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         return a * b;
87     }
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return a / b;
90     }
91     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92         return a % b;
93     }
94     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         unchecked {
96             require(b <= a, errorMessage);
97             return a - b;
98         }
99     }
100     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         unchecked {
102             require(b > 0, errorMessage);
103             return a / b;
104         }
105     }
106     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         unchecked {
108             require(b > 0, errorMessage);
109             return a % b;
110         }
111     }
112 }
113 
114 interface IERC20 {
115     event Approval(address indexed owner, address indexed spender, uint value);
116     event Transfer(address indexed from, address indexed to, uint value);
117 
118     function name() external view returns (string memory);
119     function symbol() external view returns (string memory);
120     function decimals() external view returns (uint8);
121     function totalSupply() external view returns (uint);
122     function balanceOf(address owner) external view returns (uint);
123     function allowance(address owner, address spender) external view returns (uint);
124 
125     function approve(address spender, uint value) external returns (bool);
126     function transfer(address to, uint value) external returns (bool);
127     function transferFrom(address from, address to, uint value) external returns (bool);
128 }
129 
130 interface IUniswapV2Router01 {
131     function factory() external pure returns (address);
132     function WETH() external pure returns (address);
133 
134     function addLiquidity(
135         address tokenA,
136         address tokenB,
137         uint amountADesired,
138         uint amountBDesired,
139         uint amountAMin,
140         uint amountBMin,
141         address to,
142         uint deadline
143     ) external returns (uint amountA, uint amountB, uint liquidity);
144     function addLiquidityETH(
145         address token,
146         uint amountTokenDesired,
147         uint amountTokenMin,
148         uint amountETHMin,
149         address to,
150         uint deadline
151     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
152     function removeLiquidity(
153         address tokenA,
154         address tokenB,
155         uint liquidity,
156         uint amountAMin,
157         uint amountBMin,
158         address to,
159         uint deadline
160     ) external returns (uint amountA, uint amountB);
161     function removeLiquidityETH(
162         address token,
163         uint liquidity,
164         uint amountTokenMin,
165         uint amountETHMin,
166         address to,
167         uint deadline
168     ) external returns (uint amountToken, uint amountETH);
169     function removeLiquidityWithPermit(
170         address tokenA,
171         address tokenB,
172         uint liquidity,
173         uint amountAMin,
174         uint amountBMin,
175         address to,
176         uint deadline,
177         bool approveMax, uint8 v, bytes32 r, bytes32 s
178     ) external returns (uint amountA, uint amountB);
179     function removeLiquidityETHWithPermit(
180         address token,
181         uint liquidity,
182         uint amountTokenMin,
183         uint amountETHMin,
184         address to,
185         uint deadline,
186         bool approveMax, uint8 v, bytes32 r, bytes32 s
187     ) external returns (uint amountToken, uint amountETH);
188     function swapExactTokensForTokens(
189         uint amountIn,
190         uint amountOutMin,
191         address[] calldata path,
192         address to,
193         uint deadline
194     ) external returns (uint[] memory amounts);
195     function swapTokensForExactTokens(
196         uint amountOut,
197         uint amountInMax,
198         address[] calldata path,
199         address to,
200         uint deadline
201     ) external returns (uint[] memory amounts);
202     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
203         external
204         payable
205         returns (uint[] memory amounts);
206     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
207         external
208         returns (uint[] memory amounts);
209     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
210         external
211         returns (uint[] memory amounts);
212     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
213         external
214         payable
215         returns (uint[] memory amounts);
216 
217     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
218     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
219     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
220     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
221     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
222 }
223 
224 interface IUniswapV2Router02 {
225     function factory() external pure returns (address);
226     function WETH() external pure returns (address);
227     function swapExactTokensForETHSupportingFeeOnTransferTokens(
228         uint amountIn,
229         uint amountOutMin,
230         address[] calldata path,
231         address to,
232         uint deadline
233     ) external;
234     function addLiquidity(
235         address tokenA,
236         address tokenB,
237         uint amountADesired,
238         uint amountBDesired,
239         uint amountAMin,
240         uint amountBMin,
241         address to,
242         uint deadline
243     ) external returns (uint amountA, uint amountB, uint liquidity);
244     function addLiquidityETH(
245         address token,
246         uint amountTokenDesired,
247         uint amountTokenMin,
248         uint amountETHMin,
249         address to,
250         uint deadline
251     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
252     function removeLiquidity(
253         address tokenA,
254         address tokenB,
255         uint liquidity,
256         uint amountAMin,
257         uint amountBMin,
258         address to,
259         uint deadline
260     ) external returns (uint amountA, uint amountB);
261     function removeLiquidityETH(
262         address token,
263         uint liquidity,
264         uint amountTokenMin,
265         uint amountETHMin,
266         address to,
267         uint deadline
268     ) external returns (uint amountToken, uint amountETH);
269     function removeLiquidityWithPermit(
270         address tokenA,
271         address tokenB,
272         uint liquidity,
273         uint amountAMin,
274         uint amountBMin,
275         address to,
276         uint deadline,
277         bool approveMax, uint8 v, bytes32 r, bytes32 s
278     ) external returns (uint amountA, uint amountB);
279     function removeLiquidityETHWithPermit(
280         address token,
281         uint liquidity,
282         uint amountTokenMin,
283         uint amountETHMin,
284         address to,
285         uint deadline,
286         bool approveMax, uint8 v, bytes32 r, bytes32 s
287     ) external returns (uint amountToken, uint amountETH);
288     function swapExactTokensForTokens(
289         uint amountIn,
290         uint amountOutMin,
291         address[] calldata path,
292         address to,
293         uint deadline
294     ) external returns (uint[] memory amounts);
295     function swapTokensForExactTokens(
296         uint amountOut,
297         uint amountInMax,
298         address[] calldata path,
299         address to,
300         uint deadline
301     ) external returns (uint[] memory amounts);
302     function swapExactETHForTokensSupportingFeeOnTransferTokens(
303         uint amountOutMin,
304         address[] calldata path,
305         address to,
306         uint deadline
307     ) external payable;
308     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
309         external
310         payable
311         returns (uint[] memory amounts);
312     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
313         external
314         returns (uint[] memory amounts);
315     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
316         external
317         returns (uint[] memory amounts);
318     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
319         external
320         payable
321         returns (uint[] memory amounts);
322 
323     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
324     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
325     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
326     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
327     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
328 }
329 
330 interface IUniswapV2Factory {
331     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
332 
333     function feeTo() external view returns (address);
334     function feeToSetter() external view returns (address);
335 
336     function getPair(address tokenA, address tokenB) external view returns (address pair);
337     function allPairs(uint) external view returns (address pair);
338     function allPairsLength() external view returns (uint);
339 
340     function createPair(address tokenA, address tokenB) external returns (address pair);
341 
342     function setFeeTo(address) external;
343     function setFeeToSetter(address) external;
344 }
345 
346 contract KeikoToken is Context, IERC20, ERC20Ownable {
347     using SafeMath for uint256;
348 
349     string private constant _nomenclature = "KEIKO";
350     string private constant _symbol = "KEIKO";
351     uint8 private constant _decimal = 18;
352 
353     mapping(address => uint256) private _rOwned;
354     mapping(address => uint256) private _tOwned;
355     mapping(address => mapping(address => uint256)) private _allowances;
356     mapping(address => bool) private _isExcludedFromFee;
357     mapping(address => bool) private _isExcluded;
358     mapping(address => bool) private _isMaxWalletExclude;
359     mapping (address => bool) private _isBot;
360 	mapping(address => bool) public boughtEarly;
361 
362     address dead = 0x000000000000000000000000000000000000dEaD;
363     address[] private _excluded;
364     address payable public marketingAddress;
365     address payable public charityAddress;
366     IUniswapV2Router02 private uniV2Router;
367     address private uniV2Pair;
368 
369     bool inSwapAndLiquify;
370     bool private swapAndLiquifyEnabled = true;
371     bool private _initateLiqTrans = true;
372     bool private _buyLimits = false;
373     bool private _maxWalletOn = false;
374 
375     uint256 public tradingActiveBlock = 0;
376     uint256 public earlyBuyPenaltyEnd;
377     uint256 private constant MAX = ~uint256(0);
378     uint256 private constant _tTotal = 1e13 * 10**18;
379     uint256 private _rTotal = (MAX - (MAX % _tTotal));
380     uint256 private _tFeeTotal;
381     uint256 private _maxWalletSize = 150000000001 * 10**18;
382     uint256 private minTokensBeforeSwap;
383     uint256 private tokensForLiquidityToSwap;
384     uint256 private tokensForMarketingToSwap;
385     uint256 private tokensForCharityToSwap;
386 
387     uint8 private _marTax = 6; // tax for marketing
388     uint8 private _previousMarTax = _marTax;
389     uint8 private _charTax = 2; // tax for charity
390     uint8 private _previousCharTax = _charTax;
391     uint8 private _liqTax = 2; // tax for liquidity
392     uint8 private _previousLiqTax = _liqTax;
393     uint8 private _refTax = 0; //tax for reflections
394     uint8 private _previousRefTax = _refTax;
395     uint8 private _liqDiv = _marTax + _charTax + _liqTax;
396 
397     event SwapAndLiquifyEnabledUpdated(bool enabled);
398     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
399     event UpdatedMarketingAddress(address marketing);
400     event UpdatedCharityAddress(address charity);
401     event BoughtEarly(address indexed sniper);
402     event RemovedSniper(address indexed notsnipersupposedly);
403     modifier lockTheSwap() {
404         inSwapAndLiquify = true;
405         _;
406         inSwapAndLiquify = false;
407     }
408 
409     constructor() {
410         _rOwned[_msgSender()] = _rTotal;
411         charityAddress = payable(0xF4863107D9F816b4fc29126ad2Ba6EDa33452533);
412         marketingAddress = payable(0x8A10e27771E7E99A776Dd9491ef38165Ef95B70F);
413         minTokensBeforeSwap = _tTotal.mul(5).div(10000);
414         _isExcludedFromFee[_msgSender()] = true;
415         _isExcludedFromFee[address(this)] = true;
416         _isMaxWalletExclude[address(this)] = true;
417         _isMaxWalletExclude[_msgSender()] = true;
418         _isMaxWalletExclude[address(dead)] = true;
419 
420         emit Transfer(address(0), _msgSender(), _tTotal);
421     }
422     receive() external payable {}
423     function name() public pure override returns (string memory) {
424         return _nomenclature;
425     }
426     function symbol() public pure override returns (string memory) {
427         return _symbol;
428     }
429     function decimals() public pure override returns (uint8) {
430         return _decimal;
431     }
432     function totalSupply() public pure override returns (uint256) {
433         return _tTotal;
434     }
435     function balanceOf(address account) public view override returns (uint256) {
436         if (_isExcluded[account]) return _tOwned[account];
437         return tokenFromReflection(_rOwned[account]);
438     }
439     function taxTokensBeforeSwap() external view returns (uint256) {
440         return minTokensBeforeSwap;
441     }
442     function taxTokensForLiquidity() external view returns (uint256) {
443         return tokensForLiquidityToSwap;
444     }
445     function taxTokensForCharity() external view returns (uint256) {
446         return tokensForCharityToSwap;
447     }
448     function taxTokensForMarketing() external view returns (uint256) {
449         return tokensForMarketingToSwap;
450     }
451     function transfer(address recipient, uint256 amount) public override returns (bool) {
452         _transfer(_msgSender(), recipient, amount);
453         return true;
454     }
455     function allowance(address owner, address spender) public view override returns (uint256) {
456         return _allowances[owner][spender];
457     }
458     function approve(address spender, uint256 amount) public override returns (bool) {
459         _approve(_msgSender(), spender, amount);
460         return true;
461     }
462     function transferFrom(address sender,address recipient,uint256 amount) public override returns (bool) {
463         _transfer(sender, recipient, amount);
464         _approve(sender,_msgSender(),
465         _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
466         );
467         return true;
468     }
469     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
470         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
471         return true;
472     }
473     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
474         _approve(
475             _msgSender(),
476             spender,
477             _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero")
478         );
479         return true;
480     }
481     function isExcludedFromReward(address account) public view returns (bool) {
482         return _isExcluded[account];
483     }
484     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
485         require(tAmount <= _tTotal, "Amt must be less than supply");
486         if (!deductTransferFee) {
487             (uint256 rAmount, , , , , ) = _getValues(tAmount);
488             return rAmount;
489         } else {
490             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
491             return rTransferAmount;
492         }
493     }
494     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
495         require(rAmount <= _rTotal, "Amt must be less than tot refl");
496         uint256 currentRate = _getRate();
497         return rAmount.div(currentRate);
498     }
499     function _reflectFee(uint256 rFee, uint256 tFee) private {
500         _rTotal = _rTotal.sub(rFee);
501         _tFeeTotal = _tFeeTotal.add(tFee);
502     }
503     function _getValues(uint256 tAmount) private view returns (uint256,uint256,uint256,uint256,uint256,uint256) {
504         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
505         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
506         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
507     }
508     function _getTValues(uint256 tAmount)private view returns (uint256,uint256,uint256) {
509         uint256 tFee = calculateTaxFee(tAmount);
510         uint256 tLiquidity = calculateLiquidityFee(tAmount);
511         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
512         return (tTransferAmount, tFee, tLiquidity);
513     }
514     function _getRValues(uint256 tAmount,uint256 tFee,uint256 tLiquidity,uint256 currentRate) private pure returns (uint256,uint256,uint256) {
515         uint256 rAmount = tAmount.mul(currentRate);
516         uint256 rFee = tFee.mul(currentRate);
517         uint256 rLiquidity = tLiquidity.mul(currentRate);
518         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
519         return (rAmount, rTransferAmount, rFee);
520     }
521     function _getRate() private view returns (uint256) {
522         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
523         return rSupply.div(tSupply);
524     }
525     function _getCurrentSupply() private view returns (uint256, uint256) {
526         uint256 rSupply = _rTotal;
527         uint256 tSupply = _tTotal;
528         for (uint256 i = 0; i < _excluded.length; i++) {
529             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
530             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
531             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
532         }
533         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
534         return (rSupply, tSupply);
535     }
536     function _takeLiquidity(uint256 tLiquidity) private {
537         tokensForMarketingToSwap += tLiquidity * _marTax / _liqDiv;
538 		tokensForLiquidityToSwap += tLiquidity * _liqTax / _liqDiv;
539         tokensForCharityToSwap += tLiquidity * _charTax / _liqDiv;
540         uint256 currentRate = _getRate();
541         uint256 rLiquidity = tLiquidity.mul(currentRate);
542         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
543         if (_isExcluded[address(this)]) _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
544     }
545     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
546         return _amount.mul(_refTax).div(10**2);
547     }
548     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
549         return _amount.mul(_marTax + _charTax + _liqTax).div(10**2);
550     }
551     function removeAllFee() private {
552         if (_refTax == 0 && _liqTax == 0 && _marTax == 0 && _charTax == 0) return;
553 
554         _previousRefTax = _refTax;
555         _previousLiqTax = _liqTax;
556         _previousMarTax = _marTax;
557         _previousCharTax = _charTax;
558 
559         _refTax = 0;
560         _liqTax = 0;
561         _marTax = 0;
562         _charTax = 0;
563     }
564     function restoreAllFee() private {
565         _refTax = _previousRefTax;
566         _liqTax = _previousLiqTax;
567         _marTax = _previousMarTax;
568         _charTax = _previousCharTax;
569     }
570     function excludeFromFee(address account) public onlyOwner {
571         _isExcludedFromFee[account] = true;
572     }
573     function isExcludedFromFee(address account) public view returns (bool) {
574         return _isExcludedFromFee[account];
575     }
576     function _approve(address owner,address spender,uint256 amount) private {
577         require(owner != address(0), "ERC20: approve from zero address");
578         require(spender != address(0), "ERC20: approve to zero address");
579         _allowances[owner][spender] = amount;
580         emit Approval(owner, spender, amount);
581     }
582     function _transfer(address from,address to,uint256 amount) private {
583         require(from != address(0), "ERC20: transfer from zero address");
584         require(to != address(0), "ERC20: transfer to zero address");
585         require(amount > 0, "Transfer amount must be greater than zero");
586 		require(!_isBot[from]);
587 		require(!boughtEarly[from] || earlyBuyPenaltyEnd <= block.timestamp, "Snipers can't transfer tokens to sell cheaper DM a Mod.");
588 		if (_maxWalletOn == true && ! _isMaxWalletExclude[to]) {
589             require(balanceOf(to) + amount <= _maxWalletSize, "Max amount of tokens for wallet reached");
590         }
591         if (_buyLimits == true && from == uniV2Pair) {
592 			require(amount <= 40000000001 * 10**18, "Limits are in place, please lower buying amount");
593 		}
594         if(_initateLiqTrans == true) {
595             IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
596             uniV2Router = _uniV2Router;
597             uniV2Pair = IUniswapV2Factory(_uniV2Router.factory()).getPair(address(this), _uniV2Router.WETH());
598             tradingActiveBlock = block.number;
599             earlyBuyPenaltyEnd = block.timestamp + 72 hours;
600             _isMaxWalletExclude[address(uniV2Pair)] = true;
601             _isMaxWalletExclude[address(uniV2Router)] = true;
602             _buyLimits = true;
603             _maxWalletOn = true;
604             _initateLiqTrans = false;
605         }
606 		if(from != owner() && to != uniV2Pair && block.number == tradingActiveBlock){
607 			boughtEarly[to] = true;
608             emit BoughtEarly(to);
609 		}
610         uint256 contractTokenBalance = balanceOf(address(this));
611         if (!inSwapAndLiquify && to == uniV2Pair && swapAndLiquifyEnabled) {
612             if (contractTokenBalance >= minTokensBeforeSwap) {
613 				swapTokens();
614             }
615         }
616         bool takeFee = true;
617         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
618             takeFee = false;
619         }
620 		if(boughtEarly[from] && earlyBuyPenaltyEnd > block.timestamp){
621                     _liqTax = _liqTax * 5;
622                     _marTax = _marTax * 5;
623                     _charTax = _charTax * 5;
624                 }
625         _tokenTransfer(from, to, amount, takeFee);
626     }
627     function swapETHForTokens(uint256 amount) private {
628         // generate the uniswap pair path of token -> weth
629         address[] memory path = new address[](2);
630         path[0] = uniV2Router.WETH();
631         path[1] = address(this);
632 
633         // make the swap
634         uniV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
635             0, // accept any amount of Tokens
636             path,
637             dead, // Burn address
638             block.timestamp.add(300)
639         );
640     }
641 	function addBot(address _user) public onlyOwner {
642         require(_user != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
643         require(!_isBot[_user], "user already add as bot");
644         _isBot[_user] = true;
645     }
646 	function removeBot(address _user) public onlyOwner {
647         require(_isBot[_user], "user already removed");
648         _isBot[_user] = false;
649     }
650 	function removeBoughtEarly(address account) external onlyOwner {
651         boughtEarly[account] = false;
652         emit RemovedSniper(account);
653     }
654 	function swapTokens() private lockTheSwap {
655         uint256 contractBalance = balanceOf(address(this));
656         uint256 totalTokensToSwap = tokensForLiquidityToSwap + tokensForMarketingToSwap + tokensForCharityToSwap;
657         uint256 tokensForLiquidity = tokensForLiquidityToSwap.div(2); //Halve the amount of liquidity tokens
658         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
659         uint256 initialETHBalance = address(this).balance;
660         swapTokensForETH(amountToSwapForETH); 
661         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
662         uint256 ethForMarketing = ethBalance.mul(tokensForMarketingToSwap).div(totalTokensToSwap);
663         uint256 ethForCharity = ethBalance.mul(tokensForCharityToSwap).div(totalTokensToSwap);
664         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing).sub(ethForCharity);
665         tokensForLiquidityToSwap = 0;
666         tokensForMarketingToSwap = 0;
667         tokensForCharityToSwap = 0;
668         (bool success,) = address(marketingAddress).call{value: ethForMarketing}("");
669         (success,) = address(charityAddress).call{value: ethForCharity}("");
670         addLiquidity(tokensForLiquidity, ethForLiquidity);
671         emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
672         //If any eth left over transfer out of contract as to not get stuck
673         if(address(this).balance > 0 * 10**18){
674             (success,) = address(marketingAddress).call{value: address(this).balance}("");
675         }
676     }
677 
678     function swapTokensForETH(uint256 tokenAmount) private {
679         address[] memory path = new address[](2);
680         path[0] = address(this);
681         path[1] = uniV2Router.WETH();
682         _approve(address(this), address(uniV2Router), tokenAmount);
683         uniV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
684             tokenAmount,
685             0, // accept any amount of ETH
686             path,
687             address(this),
688             block.timestamp.add(300)
689         );
690     }
691     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
692         _approve(address(this), address(uniV2Router), tokenAmount);
693         uniV2Router.addLiquidityETH{value: ethAmount}(
694             address(this),
695             tokenAmount,
696             0, // slippage is unavoidable
697             0, // slippage is unavoidable
698             dead,
699             block.timestamp.add(300)
700         );
701     }
702     function setMarketingAddress(address _marketingAddress) external onlyOwner {
703         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
704         _isExcludedFromFee[marketingAddress] = false;
705         marketingAddress = payable(_marketingAddress);
706         _isExcludedFromFee[marketingAddress] = true;
707         emit UpdatedMarketingAddress(_marketingAddress);
708     }
709     function setCharityAddress(address _charityAddress) public onlyOwner {
710         require(_charityAddress != address(0), "_liquidityAddress address cannot be 0");
711         charityAddress = payable(_charityAddress);
712         emit UpdatedCharityAddress(_charityAddress);
713     }
714     function InitiateLiqAdd() external onlyOwner {
715         _initateLiqTrans = true; //already delcared true above. Only call if declared false and are ready to add liquidity
716     }
717     function TaxSwapEnable() external onlyOwner {
718         swapAndLiquifyEnabled = true;
719     }
720     function TaxSwapDisable() external onlyOwner {
721         swapAndLiquifyEnabled = false;
722     }
723     function ResumeLimits() external onlyOwner {
724         _buyLimits = true;
725     }
726     function RemoveLimits() external onlyOwner {
727         _buyLimits = false;
728     }
729     function turnMaxWalletOn() external onlyOwner {
730         _maxWalletOn = true;
731     }
732     function turnMaxWalletOff() external onlyOwner {
733         _maxWalletOn = false;
734     }
735     function _tokenTransfer(address sender,address recipient,uint256 amount,bool takeFee) private {
736         if (!takeFee) removeAllFee();
737         if (_isExcluded[sender] && !_isExcluded[recipient]) {
738             _transferFromExcluded(sender, recipient, amount);
739         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
740             _transferToExcluded(sender, recipient, amount);
741         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
742             _transferStandard(sender, recipient, amount);
743         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
744             _transferBothExcluded(sender, recipient, amount);
745         } else {
746             _transferStandard(sender, recipient, amount);
747         }
748         if (!takeFee) restoreAllFee();
749     }
750     function _transferStandard(address sender,address recipient,uint256 tAmount) private {
751         (
752             uint256 rAmount,
753             uint256 rTransferAmount,
754             uint256 rFee,
755             uint256 tTransferAmount,
756             uint256 tFee,
757             uint256 tLiquidity
758         ) = _getValues(tAmount);
759         _rOwned[sender] = _rOwned[sender].sub(rAmount);
760         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
761         _takeLiquidity(tLiquidity);
762         _reflectFee(rFee, tFee);
763         emit Transfer(sender, recipient, tTransferAmount);
764     }
765     function _transferToExcluded(address sender,address recipient,uint256 tAmount) private {
766         (
767             uint256 rAmount,
768             uint256 rTransferAmount,
769             uint256 rFee,
770             uint256 tTransferAmount,
771             uint256 tFee,
772             uint256 tLiquidity
773         ) = _getValues(tAmount);
774         _rOwned[sender] = _rOwned[sender].sub(rAmount);
775         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
776         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
777         _takeLiquidity(tLiquidity);
778         _reflectFee(rFee, tFee);
779         emit Transfer(sender, recipient, tTransferAmount);
780     }
781     function _transferFromExcluded(address sender,address recipient,uint256 tAmount) private {
782         (
783             uint256 rAmount,
784             uint256 rTransferAmount,
785             uint256 rFee,
786             uint256 tTransferAmount,
787             uint256 tFee,
788             uint256 tLiquidity
789         ) = _getValues(tAmount);
790         _tOwned[sender] = _tOwned[sender].sub(tAmount);
791         _rOwned[sender] = _rOwned[sender].sub(rAmount);
792         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
793         _takeLiquidity(tLiquidity);
794         _reflectFee(rFee, tFee);
795         emit Transfer(sender, recipient, tTransferAmount);
796     }
797     function _transferBothExcluded(address sender,address recipient,uint256 tAmount) private {
798         (
799             uint256 rAmount,
800             uint256 rTransferAmount,
801             uint256 rFee,
802             uint256 tTransferAmount,
803             uint256 tFee,
804             uint256 tLiquidity
805         ) = _getValues(tAmount);
806         _tOwned[sender] = _tOwned[sender].sub(tAmount);
807         _rOwned[sender] = _rOwned[sender].sub(rAmount);
808         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
809         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
810         _takeLiquidity(tLiquidity);
811         _reflectFee(rFee, tFee);
812         emit Transfer(sender, recipient, tTransferAmount);
813     }
814     function _tokenTransferNoFee(address sender,address recipient,uint256 amount) private {
815         _rOwned[sender] = _rOwned[sender].sub(amount);
816         _rOwned[recipient] = _rOwned[recipient].add(amount);
817 
818         if (_isExcluded[sender]) {
819             _tOwned[sender] = _tOwned[sender].sub(amount);
820         }
821         if (_isExcluded[recipient]) {
822             _tOwned[recipient] = _tOwned[recipient].add(amount);
823         }
824         emit Transfer(sender, recipient, amount);
825     }
826 
827 }