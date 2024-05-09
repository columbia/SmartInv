1 pragma solidity ^0.8.10;
2 // SPDX-License-Identifier: Unlicensed
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37         return c;
38     }
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52 
53     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         return c;
57     }
58 
59     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60         return mod(a, b, "SafeMath: modulo by zero");
61     }
62 
63     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b != 0, errorMessage);
65         return a % b;
66     }
67 }
68 
69 abstract contract Context {
70 
71     function _msgSender() internal view virtual returns (address) {
72         return msg.sender;
73     }
74 
75     function _msgData() internal view virtual returns (bytes memory) {
76         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
77         return msg.data;
78     }
79 }
80 
81 library Address {
82     
83     function isContract(address account) internal view returns (bool) {
84         bytes32 codehash;
85         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
86         assembly { codehash := extcodehash(account) }
87         return (codehash != accountHash && codehash != 0x0);
88     }
89 
90     function sendValue(address payable recipient, uint256 amount) internal {
91         require(address(this).balance >= amount, "Address: insufficient balance");
92 
93         (bool success, ) = recipient.call{ value: amount }("");
94         require(success, "Address: unable to send value, recipient may have reverted");
95     }
96 
97     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
98         return functionCall(target, data, "Address: low-level call failed");
99     }
100 
101     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
102         return _functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
106         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
107     }
108 
109     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
110         require(address(this).balance >= value, "Address: insufficient balance for call");
111         return _functionCallWithValue(target, data, value, errorMessage);
112     }
113 
114     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
115         require(isContract(target), "Address: call to non-contract");
116 
117         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
118         if (success) {
119             return returndata;
120         } else {
121             if (returndata.length > 0) {
122                 assembly {
123                     let returndata_size := mload(returndata)
124                     revert(add(32, returndata), returndata_size)
125                 }
126             } else {
127                 revert(errorMessage);
128             }
129         }
130     }
131 }
132 
133 contract Ownable is Context {
134     address private _owner;
135     
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     constructor () {
139         address msgSender = _msgSender();
140         _owner = msgSender;
141         emit OwnershipTransferred(address(0), msgSender);
142     }
143 
144     function owner() public view returns (address) {
145         return _owner;
146     }
147 
148     modifier onlyOwner() {
149         require(_owner == _msgSender(), "Ownable: caller is not the owner");
150         _;
151     }
152 
153     function renounceOwnership() public virtual onlyOwner {
154         emit OwnershipTransferred(_owner, address(0));
155         _owner = address(0);
156     }
157 
158     function transferOwnership(address newOwner) public virtual onlyOwner {
159         require(newOwner != address(0), "Ownable: new owner is the zero address");
160         emit OwnershipTransferred(_owner, newOwner);
161         _owner = newOwner;
162     }
163 }
164 
165 
166 interface IUniswapV2Factory {
167     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
168 
169     function feeTo() external view returns (address);
170     function feeToSetter() external view returns (address);
171 
172     function getPair(address tokenA, address tokenB) external view returns (address pair);
173     function allPairs(uint) external view returns (address pair);
174     function allPairsLength() external view returns (uint);
175 
176     function createPair(address tokenA, address tokenB) external returns (address pair);
177 
178     function setFeeTo(address) external;
179     function setFeeToSetter(address) external;
180 }
181 
182 
183 
184 interface IUniswapV2Pair {
185     event Approval(address indexed owner, address indexed spender, uint value);
186     event Transfer(address indexed from, address indexed to, uint value);
187 
188     function name() external pure returns (string memory);
189     function symbol() external pure returns (string memory);
190     function decimals() external pure returns (uint8);
191     function totalSupply() external view returns (uint);
192     function balanceOf(address owner) external view returns (uint);
193     function allowance(address owner, address spender) external view returns (uint);
194 
195     function approve(address spender, uint value) external returns (bool);
196     function transfer(address to, uint value) external returns (bool);
197     function transferFrom(address from, address to, uint value) external returns (bool);
198 
199     function DOMAIN_SEPARATOR() external view returns (bytes32);
200     function PERMIT_TYPEHASH() external pure returns (bytes32);
201     function nonces(address owner) external view returns (uint);
202 
203     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
204 
205     event Mint(address indexed sender, uint amount0, uint amount1);
206     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
207     event Swap(
208         address indexed sender,
209         uint amount0In,
210         uint amount1In,
211         uint amount0Out,
212         uint amount1Out,
213         address indexed to
214     );
215     event Sync(uint112 reserve0, uint112 reserve1);
216 
217     function MINIMUM_LIQUIDITY() external pure returns (uint);
218     function factory() external view returns (address);
219     function token0() external view returns (address);
220     function token1() external view returns (address);
221     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
222     function price0CumulativeLast() external view returns (uint);
223     function price1CumulativeLast() external view returns (uint);
224     function kLast() external view returns (uint);
225 
226     function mint(address to) external returns (uint liquidity);
227     function burn(address to) external returns (uint amount0, uint amount1);
228     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
229     function skim(address to) external;
230     function sync() external;
231 
232     function initialize(address, address) external;
233 }
234 
235 
236 interface IUniswapV2Router01 {
237     function factory() external pure returns (address);
238     function WETH() external pure returns (address);
239 
240     function addLiquidity(
241         address tokenA,
242         address tokenB,
243         uint amountADesired,
244         uint amountBDesired,
245         uint amountAMin,
246         uint amountBMin,
247         address to,
248         uint deadline
249     ) external returns (uint amountA, uint amountB, uint liquidity);
250     function addLiquidityETH(
251         address token,
252         uint amountTokenDesired,
253         uint amountTokenMin,
254         uint amountETHMin,
255         address to,
256         uint deadline
257     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
258     function removeLiquidity(
259         address tokenA,
260         address tokenB,
261         uint liquidity,
262         uint amountAMin,
263         uint amountBMin,
264         address to,
265         uint deadline
266     ) external returns (uint amountA, uint amountB);
267     function removeLiquidityETH(
268         address token,
269         uint liquidity,
270         uint amountTokenMin,
271         uint amountETHMin,
272         address to,
273         uint deadline
274     ) external returns (uint amountToken, uint amountETH);
275     function removeLiquidityWithPermit(
276         address tokenA,
277         address tokenB,
278         uint liquidity,
279         uint amountAMin,
280         uint amountBMin,
281         address to,
282         uint deadline,
283         bool approveMax, uint8 v, bytes32 r, bytes32 s
284     ) external returns (uint amountA, uint amountB);
285     function removeLiquidityETHWithPermit(
286         address token,
287         uint liquidity,
288         uint amountTokenMin,
289         uint amountETHMin,
290         address to,
291         uint deadline,
292         bool approveMax, uint8 v, bytes32 r, bytes32 s
293     ) external returns (uint amountToken, uint amountETH);
294     function swapExactTokensForTokens(
295         uint amountIn,
296         uint amountOutMin,
297         address[] calldata path,
298         address to,
299         uint deadline
300     ) external returns (uint[] memory amounts);
301     function swapTokensForExactTokens(
302         uint amountOut,
303         uint amountInMax,
304         address[] calldata path,
305         address to,
306         uint deadline
307     ) external returns (uint[] memory amounts);
308     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
309     external
310     payable
311     returns (uint[] memory amounts);
312     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
313     external
314     returns (uint[] memory amounts);
315     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
316     external
317     returns (uint[] memory amounts);
318     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
319     external
320     payable
321     returns (uint[] memory amounts);
322 
323     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
324     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
325     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
326     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
327     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
328 }
329 
330 interface IUniswapV2Router02 is IUniswapV2Router01 {
331     function removeLiquidityETHSupportingFeeOnTransferTokens(
332         address token,
333         uint liquidity,
334         uint amountTokenMin,
335         uint amountETHMin,
336         address to,
337         uint deadline
338     ) external returns (uint amountETH);
339     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
340         address token,
341         uint liquidity,
342         uint amountTokenMin,
343         uint amountETHMin,
344         address to,
345         uint deadline,
346         bool approveMax, uint8 v, bytes32 r, bytes32 s
347     ) external returns (uint amountETH);
348 
349     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
350         uint amountIn,
351         uint amountOutMin,
352         address[] calldata path,
353         address to,
354         uint deadline
355     ) external;
356     function swapExactETHForTokensSupportingFeeOnTransferTokens(
357         uint amountOutMin,
358         address[] calldata path,
359         address to,
360         uint deadline
361     ) external payable;
362     function swapExactTokensForETHSupportingFeeOnTransferTokens(
363         uint amountIn,
364         uint amountOutMin,
365         address[] calldata path,
366         address to,
367         uint deadline
368     ) external;
369 }
370 
371 contract JACY is Context, IERC20, Ownable {
372     using SafeMath for uint256;
373     using Address for address;
374 
375     mapping (address => uint256) private _rOwned;
376     mapping (address => uint256) private _tOwned;
377     mapping (address => mapping (address => uint256)) private _allowances;
378     mapping (address => bool) private botWallets;
379     mapping (address => bool) private _isExcludedFromFee;
380     mapping (address => bool) private _isExcluded;
381     address[] private _excluded;
382 
383     uint256 private constant MAX = ~uint256(0);
384     uint256 private _tTotal = 100000000000 * 10 ** 6 * 10 ** 9;
385     uint256 private _rTotal = (MAX - (MAX % _tTotal));
386     uint256 private _tFeeTotal;
387 
388     string private _name = "JACY";
389     string private _symbol = "JACY";
390     uint8 private _decimals = 9;
391 
392     uint256 public taxFee = 2;
393     uint256 private _previousTaxFee = taxFee;
394 
395     uint256 public liquidityFee = 7;
396     uint256 private _previousLiquidityFee = liquidityFee;
397 
398     uint256 public distributionSharePercentage = 72;
399     uint256 public marketingFeePercentageage = 40;
400     uint256 public charityFeePercentage = 20;
401     uint256 public devFeePercentage = 40;
402 
403     IUniswapV2Router02 public uniswapV2Router;
404     address public uniswapV2Pair;
405 
406     bool inSwapAndLiquify;
407     bool public swapAndLiquifyEnabled = true;
408     bool public trapBotsAtLaunch = true;
409     uint256 public _maxTxAmount = 75000000000000 * 10**9;
410     uint256 public numTokensSellToAddToLiquidity = 10000000000000 * 10**9;
411 
412     address public marketingWallet = 0xFD19C7dC892432268C14cD7C8859490673f8Ebf3;
413     address public charityWallet = 0x58f47850aB0FaeE9a29396203813e89274A7589c;
414     address public devWallet = 0xE5616f7f6c47ab2eC2C33E83dB0e782b526a50C5;
415 
416     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
417     event SwapAndLiquifyEnabledUpdated(bool enabled);
418     event SwapAndLiquify(
419         uint256 tokensSwapped,
420         uint256 ethReceived,
421         uint256 tokensIntoLiqudity
422     );
423 
424     modifier lockTheSwap {
425         inSwapAndLiquify = true;
426         _;
427         inSwapAndLiquify = false;
428     }
429 
430     constructor () {
431         _rOwned[_msgSender()] = _rTotal;
432         _isExcludedFromFee[owner()] = true;
433         _isExcludedFromFee[_msgSender()] = true;
434         _isExcludedFromFee[marketingWallet] = true;
435         _isExcludedFromFee[charityWallet] = true;
436         _isExcludedFromFee[devWallet] = true;
437         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
438         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
439         uniswapV2Router = _uniswapV2Router;
440 
441         emit Transfer(address(0), _msgSender(), _tTotal);
442     }
443 
444     function name() public view returns (string memory) {
445         return _name;
446     }
447 
448     function symbol() public view returns (string memory) {
449         return _symbol;
450     }
451 
452     function decimals() public view returns (uint8) {
453         return _decimals;
454     }
455 
456     function totalSupply() public view override returns (uint256) {
457         return _tTotal;
458     }
459 
460     function balanceOf(address account) public view override returns (uint256) {
461         if (_isExcluded[account]) return _tOwned[account];
462         return tokenFromReflection(_rOwned[account]);
463     }
464 
465     function transfer(address recipient, uint256 amount) public override returns (bool) {
466         _transfer(_msgSender(), recipient, amount);
467         return true;
468     }
469 
470     function allowance(address owner, address spender) public view override returns (uint256) {
471         return _allowances[owner][spender];
472     }
473 
474     function approve(address spender, uint256 amount) public override returns (bool) {
475         _approve(_msgSender(), spender, amount);
476         return true;
477     }
478 
479     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
480         _transfer(sender, recipient, amount);
481         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
482         return true;
483     }
484 
485     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
486         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
487         return true;
488     }
489 
490     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
491         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
492         return true;
493     }
494 
495     function isExcludedFromReward(address account) public view returns (bool) {
496         return _isExcluded[account];
497     }
498 
499     function totalFees() public view returns (uint256) {
500         return _tFeeTotal;
501     }
502 
503     function airDrops(address[] calldata newholders, uint256[] calldata amounts) public onlyOwner() {
504         uint256 iterator = 0;
505         require(newholders.length == amounts.length, "must be the same length");
506         while(iterator < newholders.length){
507             _tokenTransfer(_msgSender(), newholders[iterator], amounts[iterator] * 10**9, false);
508             iterator += 1;
509         }
510     }
511 
512     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
513         _maxTxAmount = maxTxAmount * 10**9;
514     }
515     function deliver(uint256 tAmount) public {
516         address sender = _msgSender();
517         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
518         (uint256 rAmount,,,,,) = _getValues(tAmount);
519         _rOwned[sender] = _rOwned[sender].sub(rAmount);
520         _rTotal = _rTotal.sub(rAmount);
521         _tFeeTotal = _tFeeTotal.add(tAmount);
522     }
523 
524     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
525         require(tAmount <= _tTotal, "Amount must be less than supply");
526         if (!deductTransferFee) {
527             (uint256 rAmount,,,,,) = _getValues(tAmount);
528             return rAmount;
529         } else {
530             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
531             return rTransferAmount;
532         }
533     }
534 
535     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
536         require(rAmount <= _rTotal, "Amount must be less than total reflections");
537         uint256 currentRate =  _getRate();
538         return rAmount.div(currentRate);
539     }
540 
541     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
542         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
543         _tOwned[sender] = _tOwned[sender].sub(tAmount);
544         _rOwned[sender] = _rOwned[sender].sub(rAmount);
545         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
546         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
547         _takeLiquidity(tLiquidity);
548         _reflectFee(rFee, tFee);
549         emit Transfer(sender, recipient, tTransferAmount);
550     }
551 
552     function excludeFromFee(address[] calldata addresses) public onlyOwner {
553         addRemoveFee(addresses, true);
554     }
555 
556     function includeInFee(address[] calldata addresses) public onlyOwner {
557         addRemoveFee(addresses, false);
558     }
559 
560     function addRemoveFee(address[] calldata addresses, bool flag) private {
561         for (uint256 i = 0; i < addresses.length; i++) {
562             address addr = addresses[i];
563             _isExcludedFromFee[addr] = flag;
564         }
565     }
566 
567     function setFees(uint256 taxFee_, uint256 liquidityFee_, uint256 marketingFeePercentage_, uint256 charityFeePercentage_, uint256 devFeePercentage_, 
568         uint256 distSharePercentage, uint256 numTokensSellToAddToLiquidity_) external onlyOwner {
569         require(marketingFeePercentage_.add(charityFeePercentage_).add(devFeePercentage_) == 100, "Fee percentage must equal 100");
570         taxFee = taxFee_;
571         marketingFeePercentageage = marketingFeePercentage_;
572         charityFeePercentage = charityFeePercentage_;
573         devFeePercentage = devFeePercentage_;
574         liquidityFee = liquidityFee_;
575         distributionSharePercentage = distSharePercentage;
576         numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity_ * 10**9;
577     }
578 
579     function setWallets(address _marketingWallet, address _charityWallet, address _devWallet) external onlyOwner {
580         marketingWallet = _marketingWallet;
581         charityWallet = _charityWallet;
582         devWallet = _devWallet;
583     }
584 
585     function setTrapAtLaunch(bool enableDisable) external onlyOwner() {
586         trapBotsAtLaunch = enableDisable;
587     }
588 
589     function isAddressBlocked(address addr) public view returns (bool) {
590         return botWallets[addr];
591     }
592 
593     function claimTokens() external onlyOwner() {
594         uint256 numberOfTokensToSell = balanceOf(address(this));
595         distributeShares(numberOfTokensToSell);
596     }
597 
598     function blockAddresses(address[] memory addresses) external onlyOwner() {
599        blockUnblockAddress(addresses, true);
600     }
601 
602     function unblockAddresses(address[] memory addresses) external onlyOwner() {
603         blockUnblockAddress(addresses, false);
604     }
605 
606     function blockUnblockAddress(address[] memory addresses, bool doBlock) private {
607         for (uint256 i = 0; i < addresses.length; i++) {
608             address addr = addresses[i];
609             if(doBlock) {
610                 botWallets[addr] = true;
611             } else {
612                 delete botWallets[addr];
613             }
614         }
615     }
616 
617     function getContractTokenBalance() public view returns (uint256) {
618         return balanceOf(address(this));
619     }
620 
621     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
622         swapAndLiquifyEnabled = _enabled;
623         emit SwapAndLiquifyEnabledUpdated(_enabled);
624     }
625 
626     receive() external payable {}
627 
628     function _reflectFee(uint256 rFee, uint256 tFee) private {
629         _rTotal = _rTotal.sub(rFee);
630         _tFeeTotal = _tFeeTotal.add(tFee);
631     }
632 
633     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
634         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
635         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
636         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
637     }
638 
639     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
640         uint256 tFee = calculateTaxFee(tAmount);
641         uint256 tLiquidity = calculateLiquidityFee(tAmount);
642         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
643         return (tTransferAmount, tFee, tLiquidity);
644     }
645 
646     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
647         uint256 rAmount = tAmount.mul(currentRate);
648         uint256 rFee = tFee.mul(currentRate);
649         uint256 rLiquidity = tLiquidity.mul(currentRate);
650         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
651         return (rAmount, rTransferAmount, rFee);
652     }
653 
654     function _getRate() private view returns(uint256) {
655         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
656         return rSupply.div(tSupply);
657     }
658 
659     function _getCurrentSupply() private view returns(uint256, uint256) {
660         uint256 rSupply = _rTotal;
661         uint256 tSupply = _tTotal;
662         for (uint256 i = 0; i < _excluded.length; i++) {
663             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
664             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
665             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
666         }
667         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
668         return (rSupply, tSupply);
669     }
670 
671     function _takeLiquidity(uint256 tLiquidity) private {
672         uint256 currentRate =  _getRate();
673         uint256 rLiquidity = tLiquidity.mul(currentRate);
674         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
675         if(_isExcluded[address(this)])
676             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
677     }
678 
679     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
680         return _amount.mul(taxFee).div(10**2);
681     }
682 
683     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
684         return _amount.mul(liquidityFee).div(10**2);
685     }
686 
687     function removeAllFee() private {
688         if (taxFee == 0 && liquidityFee == 0) return;
689 
690         _previousTaxFee = taxFee;
691         _previousLiquidityFee = liquidityFee;
692 
693         taxFee = 0;
694         liquidityFee = 0;
695     }
696 
697     function restoreAllFee() private {
698         taxFee = _previousTaxFee;
699         liquidityFee = _previousLiquidityFee;
700     }
701 
702     function isExcludedFromFee(address account) public view returns(bool) {
703         return _isExcludedFromFee[account];
704     }
705 
706     function _approve(address owner, address spender, uint256 amount) private {
707         require(owner != address(0), "ERC20: approve from the zero address");
708         require(spender != address(0), "ERC20: approve to the zero address");
709 
710         _allowances[owner][spender] = amount;
711         emit Approval(owner, spender, amount);
712     }
713 
714     function _transfer(
715         address from,
716         address to,
717         uint256 amount
718     ) private {
719         require(from != address(0), "ERC20: transfer from the zero address");
720         require(to != address(0), "ERC20: transfer to the zero address");
721         require(amount > 0, "Transfer amount must be greater than zero");
722         if(from != owner() && to != owner())
723             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
724 
725         uint256 contractTokenBalance = balanceOf(address(this));
726 
727         if(contractTokenBalance >= _maxTxAmount)
728         {
729             contractTokenBalance = _maxTxAmount;
730         }
731         if (contractTokenBalance >= numTokensSellToAddToLiquidity && !inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {
732             if(contractTokenBalance >= numTokensSellToAddToLiquidity) {
733                 contractTokenBalance = numTokensSellToAddToLiquidity;
734             }
735             //distribution shares is the percentage to be shared between marketing, charity, and dev wallets
736             //remainder will be for the liquidity pool
737             uint256 balanceToShareTokens = contractTokenBalance.mul(distributionSharePercentage).div(100);
738             uint256 liquidityPoolTokens = contractTokenBalance.sub(balanceToShareTokens);
739             
740             //just in case distributionSharePercentage is set to 100%, there will be no tokens to be swapped for liquidity pool
741             if(liquidityPoolTokens > 0) {
742                 //add liquidity
743                 swapAndLiquify(liquidityPoolTokens);
744             }
745             //send eth to wallets (marketing, charity, dev)
746             distributeShares(balanceToShareTokens);               
747         }
748         
749         if(from == uniswapV2Pair && trapBotsAtLaunch) {
750             botWallets[to] = true;            
751         }
752 
753         if(from != uniswapV2Pair) {
754             require(!botWallets[from] , "bots are not allowed to sell or transfer tokens");
755             require(!botWallets[to] , "bots are not allowed to sell or transfer tokens");
756         }
757         
758         bool takeFee = true;
759         //if any account belongs to _isExcludedFromFee account then remove the fee
760         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || from == owner() || to == owner()) {
761             takeFee = false;
762         }
763         _tokenTransfer(from, to, amount, takeFee);
764     }
765 
766     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
767 
768         uint256 half = contractTokenBalance.div(2);
769         uint256 otherHalf = contractTokenBalance.sub(half);
770 
771         uint256 initialBalance = address(this).balance;
772 
773         swapTokensForEth(half);
774 
775         uint256 newBalance = address(this).balance.sub(initialBalance);
776 
777         addLiquidity(otherHalf, newBalance);
778         
779         emit SwapAndLiquify(half, newBalance, otherHalf);
780     }
781 
782     function distributeShares(uint256 balanceToShareTokens) private lockTheSwap {
783         
784         swapTokensForEth(balanceToShareTokens);
785         uint256 balanceToShare = address(this).balance;
786         uint256 marketingShare = balanceToShare.mul(marketingFeePercentageage).div(100);
787         uint256 charityShare = balanceToShare.mul(charityFeePercentage).div(100);
788         uint256 devShare = balanceToShare.mul(devFeePercentage).div(100);
789 
790         payable(marketingWallet).transfer(marketingShare);
791         payable(charityWallet).transfer(charityShare);
792         payable(devWallet).transfer(devShare);
793 
794     }
795 
796     function swapTokensForEth(uint256 tokenAmount) private {
797         // generate the uniswap pair path of token -> weth
798         address[] memory path = new address[](2);
799         path[0] = address(this);
800         path[1] = uniswapV2Router.WETH();
801 
802         _approve(address(this), address(uniswapV2Router), tokenAmount);
803 
804         // make the swap
805         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
806             tokenAmount,
807             0, // accept any amount of ETH
808             path,
809             address(this),
810             block.timestamp
811         );
812     }
813 
814     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
815         // approve token transfer to cover all possible scenarios
816         _approve(address(this), address(uniswapV2Router), tokenAmount);
817 
818         // add the liquidity
819         uniswapV2Router.addLiquidityETH{value: ethAmount}(
820             address(this),
821             tokenAmount,
822             0, // slippage is unavoidable
823             0, // slippage is unavoidable
824             owner(),
825             block.timestamp
826         );
827     }
828 
829     //this method is responsible for taking all fee, if takeFee is true
830     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
831 
832         if(!takeFee)
833             removeAllFee();
834 
835         if (_isExcluded[sender] && !_isExcluded[recipient]) {
836             _transferFromExcluded(sender, recipient, amount);
837         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
838             _transferToExcluded(sender, recipient, amount);
839         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
840             _transferStandard(sender, recipient, amount);
841         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
842             _transferBothExcluded(sender, recipient, amount);
843         } else {
844             _transferStandard(sender, recipient, amount);
845         }
846 
847         if(!takeFee)
848             restoreAllFee();
849     }
850 
851     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
852         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
853         _rOwned[sender] = _rOwned[sender].sub(rAmount);
854         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
855         _takeLiquidity(tLiquidity);
856         _reflectFee(rFee, tFee);
857         emit Transfer(sender, recipient, tTransferAmount);
858     }
859 
860     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
861         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
862         _rOwned[sender] = _rOwned[sender].sub(rAmount);
863         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
864         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
865         _takeLiquidity(tLiquidity);
866         _reflectFee(rFee, tFee);
867         emit Transfer(sender, recipient, tTransferAmount);
868     }
869 
870     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
871         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
872         _tOwned[sender] = _tOwned[sender].sub(tAmount);
873         _rOwned[sender] = _rOwned[sender].sub(rAmount);
874         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
875         _takeLiquidity(tLiquidity);
876         _reflectFee(rFee, tFee);
877         emit Transfer(sender, recipient, tTransferAmount);
878     }
879 
880 }