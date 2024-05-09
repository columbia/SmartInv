1 // SPDX-License-Identifier: MIT
2 // Website: https://blazex.org
3 // Telegram: https://t.me/BlazeXCoin
4 // Deployer Bot: t.me/BlazeXDeployerBot
5 
6 pragma solidity 0.8.17;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address payable) {
10         return payable(msg.sender);
11     }
12 
13     function _msgData() internal view virtual returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 abstract contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     constructor () {
25         address msgSender = _msgSender();
26         _owner = msgSender;
27         emit OwnershipTransferred(address(0), msgSender);
28     }
29 
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     modifier onlyOwner() {
35         require(_owner == _msgSender(), "Ownable: caller is not the owner");
36         _;
37     }
38 
39     function renounceOwnership() public virtual onlyOwner {
40         emit OwnershipTransferred(_owner, address(0));
41         _owner = address(0);
42     }
43 
44     function transferOwnership(address newOwner) public virtual onlyOwner {
45         require(newOwner != address(0), "Ownable: new owner is the zero address");
46         emit OwnershipTransferred(_owner, newOwner);
47         _owner = newOwner;
48     }
49 }
50 
51 interface IERC20 {
52     function totalSupply() external view returns (uint256);
53     function balanceOf(address account) external view returns (uint256);
54     function transfer(address recipient, uint256 amount) external returns (bool);
55     function allowance(address owner, address spender) external view returns (uint256);
56     function approve(address spender, uint256 amount) external returns (bool);
57     function transferFrom(
58         address sender,
59         address recipient,
60         uint256 amount
61     ) external returns (bool);
62    
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 library Address {
68     function isContract(address account) internal view returns (bool) {
69         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
70         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
71         // for accounts without code, i.e. `keccak256('')`
72         bytes32 codehash;
73         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
74         // solhint-disable-next-line no-inline-assembly
75         assembly { codehash := extcodehash(account) }
76         return (codehash != accountHash && codehash != 0x0);
77     }
78 
79     function sendValue(address payable recipient, uint256 amount) internal returns(bool){
80         require(address(this).balance >= amount, "Address: insufficient balance");
81 
82         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
83         (bool success, ) = recipient.call{ value: amount }("");
84         return success;
85     }
86 
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88       return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         return _functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
96         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
97     }
98 
99     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
100         require(address(this).balance >= value, "Address: insufficient balance for call");
101         return _functionCallWithValue(target, data, value, errorMessage);
102     }
103 
104     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
105         require(isContract(target), "Address: call to non-contract");
106 
107         // solhint-disable-next-line avoid-low-level-calls
108         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
109         if (success) {
110             return returndata;
111         } else {
112             // Look for revert reason and bubble it up if present
113             if (returndata.length > 0) {
114                 // The easiest way to bubble the revert reason is using memory via assembly
115 
116                 // solhint-disable-next-line no-inline-assembly
117                 assembly {
118                     let returndata_size := mload(returndata)
119                     revert(add(32, returndata), returndata_size)
120                 }
121             } else {
122                 revert(errorMessage);
123             }
124         }
125     }
126 }
127 
128 interface IUniswapV2Factory {
129     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
130 
131     function feeTo() external view returns (address);
132     function feeToSetter() external view returns (address);
133 
134     function getPair(address tokenA, address tokenB) external view returns (address pair);
135     function allPairs(uint) external view returns (address pair);
136     function allPairsLength() external view returns (uint);
137 
138     function createPair(address tokenA, address tokenB) external returns (address pair);
139 
140     function setFeeTo(address) external;
141     function setFeeToSetter(address) external;
142 }
143 
144 interface IUniswapV2Pair {
145     event Approval(address indexed owner, address indexed spender, uint value);
146     event Transfer(address indexed from, address indexed to, uint value);
147 
148     function name() external pure returns (string memory);
149     function symbol() external pure returns (string memory);
150     function decimals() external pure returns (uint8);
151     function totalSupply() external view returns (uint);
152     function balanceOf(address owner) external view returns (uint);
153     function allowance(address owner, address spender) external view returns (uint);
154 
155     function approve(address spender, uint value) external returns (bool);
156     function transfer(address to, uint value) external returns (bool);
157     function transferFrom(address from, address to, uint value) external returns (bool);
158 
159     function DOMAIN_SEPARATOR() external view returns (bytes32);
160     function PERMIT_TYPEHASH() external pure returns (bytes32);
161     function nonces(address owner) external view returns (uint);
162 
163     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
164 
165     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
166     event Swap(
167         address indexed sender,
168         uint amount0In,
169         uint amount1In,
170         uint amount0Out,
171         uint amount1Out,
172         address indexed to
173     );
174     event Sync(uint112 reserve0, uint112 reserve1);
175 
176     function MINIMUM_LIQUIDITY() external pure returns (uint);
177     function factory() external view returns (address);
178     function token0() external view returns (address);
179     function token1() external view returns (address);
180     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
181     function price0CumulativeLast() external view returns (uint);
182     function price1CumulativeLast() external view returns (uint);
183     function kLast() external view returns (uint);
184 
185     function burn(address to) external returns (uint amount0, uint amount1);
186     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
187     function skim(address to) external;
188     function sync() external;
189 
190     function initialize(address, address) external;
191 }
192 
193 interface IUniswapV2Router01 {
194     function factory() external pure returns (address);
195     function WETH() external pure returns (address);
196 
197     function addLiquidity(
198         address tokenA,
199         address tokenB,
200         uint amountADesired,
201         uint amountBDesired,
202         uint amountAMin,
203         uint amountBMin,
204         address to,
205         uint deadline
206     ) external returns (uint amountA, uint amountB, uint liquidity);
207     function addLiquidityETH(
208         address token,
209         uint amountTokenDesired,
210         uint amountTokenMin,
211         uint amountETHMin,
212         address to,
213         uint deadline
214     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
215     function removeLiquidity(
216         address tokenA,
217         address tokenB,
218         uint liquidity,
219         uint amountAMin,
220         uint amountBMin,
221         address to,
222         uint deadline
223     ) external returns (uint amountA, uint amountB);
224     function removeLiquidityETH(
225         address token,
226         uint liquidity,
227         uint amountTokenMin,
228         uint amountETHMin,
229         address to,
230         uint deadline
231     ) external returns (uint amountToken, uint amountETH);
232     function removeLiquidityWithPermit(
233         address tokenA,
234         address tokenB,
235         uint liquidity,
236         uint amountAMin,
237         uint amountBMin,
238         address to,
239         uint deadline,
240         bool approveMax, uint8 v, bytes32 r, bytes32 s
241     ) external returns (uint amountA, uint amountB);
242     function removeLiquidityETHWithPermit(
243         address token,
244         uint liquidity,
245         uint amountTokenMin,
246         uint amountETHMin,
247         address to,
248         uint deadline,
249         bool approveMax, uint8 v, bytes32 r, bytes32 s
250     ) external returns (uint amountToken, uint amountETH);
251     function swapExactTokensForTokens(
252         uint amountIn,
253         uint amountOutMin,
254         address[] calldata path,
255         address to,
256         uint deadline
257     ) external returns (uint[] memory amounts);
258     function swapTokensForExactTokens(
259         uint amountOut,
260         uint amountInMax,
261         address[] calldata path,
262         address to,
263         uint deadline
264     ) external returns (uint[] memory amounts);
265     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
266         external
267         payable
268         returns (uint[] memory amounts);
269     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
270         external
271         returns (uint[] memory amounts);
272     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
273         external
274         returns (uint[] memory amounts);
275     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
276         external
277         payable
278         returns (uint[] memory amounts);
279 
280     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
281     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
282     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
283     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
284     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
285 }
286 
287 interface IUniswapV2Router02 is IUniswapV2Router01 {
288     function removeLiquidityETHSupportingFeeOnTransferTokens(
289         address token,
290         uint liquidity,
291         uint amountTokenMin,
292         uint amountETHMin,
293         address to,
294         uint deadline
295     ) external returns (uint amountETH);
296     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
297         address token,
298         uint liquidity,
299         uint amountTokenMin,
300         uint amountETHMin,
301         address to,
302         uint deadline,
303         bool approveMax, uint8 v, bytes32 r, bytes32 s
304     ) external returns (uint amountETH);
305 
306     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
307         uint amountIn,
308         uint amountOutMin,
309         address[] calldata path,
310         address to,
311         uint deadline
312     ) external;
313     function swapExactETHForTokensSupportingFeeOnTransferTokens(
314         uint amountOutMin,
315         address[] calldata path,
316         address to,
317         uint deadline
318     ) external payable;
319     function swapExactTokensForETHSupportingFeeOnTransferTokens(
320         uint amountIn,
321         uint amountOutMin,
322         address[] calldata path,
323         address to,
324         uint deadline
325     ) external;
326 }
327 
328 contract BlazeX is Context, IERC20, Ownable {
329     using Address for address;
330     using Address for address payable;
331 
332     mapping (address => uint256) private _rOwned;
333     mapping (address => uint256) private _tOwned;
334     mapping (address => mapping (address => uint256)) private _allowances;
335 
336     mapping (address => bool) private _isExcludedFromFees;
337     mapping (address => bool) private _isExcluded;
338     address[] private _excluded;
339 
340     string private _name     = "BlazeX";
341     string private _symbol   = "BlazeX";
342     uint8  private _decimals = 9;
343    
344     uint256 private constant MAX = type(uint256).max;
345     uint256 private _tTotal = 973.5e6 * (10 ** _decimals);
346     uint256 private _tTotalSupply = 973.5e6 * (10 ** _decimals);
347     uint256 private _rTotal = (MAX - (MAX % _tTotal));
348     uint256 private _tFeeTotal;
349 
350     uint256 public taxFeeonBuy;
351     uint256 public taxFeeonSell;
352 
353     uint256 public liquidityFeeonBuy;
354     uint256 public liquidityFeeonSell;
355 
356     uint256 public marketingFeeonBuy;
357     uint256 public marketingFeeonSell;
358 
359     uint256 public burnFeeOnBuy;
360     uint256 public burnFeeOnSell;
361 
362     uint256 private _taxFee;
363     uint256 private _liquidityFee;
364     uint256 private _marketingFee;
365 
366     uint256 private totalBuyFees;
367     uint256 private totalSellFees;
368 
369     address public marketingWallet;
370 
371     bool public walletToWalletTransferWithoutFee;
372     
373     address private DEAD = 0x000000000000000000000000000000000000dEaD;
374 
375     IUniswapV2Router02 public  uniswapV2Router;
376     address public  uniswapV2Pair;
377 
378     bool private inSwapAndLiquify;
379     bool public swapEnabled;
380     bool public tradingEnabled;
381     uint256 public swapTokensAtAmount;
382 
383     event ExcludeFromFees(address indexed account, bool isExcluded);
384     event MarketingWalletChanged(address marketingWallet);
385     event SwapEnabledUpdated(bool enabled);
386     event SwapAndLiquify(uint256 tokensSwapped, uint256 bnbReceived, uint256 tokensIntoLiqudity);
387     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);
388     event SwapTokensAtAmountUpdated(uint256 amount);
389     event BuyFeesChanged(uint256 taxFee, uint256 liquidityFee, uint256 marketingFee);
390     event SellFeesChanged(uint256 taxFee, uint256 liquidityFee, uint256 marketingFee);
391     event WalletToWalletTransferWithoutFeeEnabled(bool enabled);
392     
393     constructor() 
394     {        
395         address router;
396         if (block.chainid == 56) {
397             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; 
398         } else if (block.chainid == 97) {
399             router =  0xD99D1c33F9fC3444f8101754aBC46c52416550D1; 
400         } else if (block.chainid == 1 || block.chainid == 5) {
401             router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; 
402         } else {
403             revert();
404         }
405 
406         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
407         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
408             .createPair(address(this), _uniswapV2Router.WETH());
409         uniswapV2Router = _uniswapV2Router;
410 
411         _approve(address(this), address(uniswapV2Router), MAX);
412 
413         taxFeeonBuy = 10;
414         taxFeeonSell = 10;
415 
416         liquidityFeeonBuy = 0;
417         liquidityFeeonSell = 0;
418 
419         marketingFeeonBuy = 30;
420         marketingFeeonSell = 30;
421 
422         burnFeeOnBuy = 10;
423         burnFeeOnSell = 10;
424 
425         totalBuyFees = taxFeeonBuy + liquidityFeeonBuy + marketingFeeonBuy + burnFeeOnBuy;
426         totalSellFees = taxFeeonSell + liquidityFeeonSell + marketingFeeonSell + burnFeeOnSell;
427 
428         marketingWallet = 0x8883dc32cB23BcE47F7bb7CAaE2456093553C0cE;
429         
430         swapEnabled = true;
431         swapTokensAtAmount = _tTotal / 5000;
432 
433         maxTransactionLimitEnabled  = true;
434 
435         maxTransactionAmountBuy     = _tTotal * 15 / 1000;
436         maxTransactionAmountSell    = _tTotal * 15 / 1000;
437 
438         _isExcludedFromMaxTxLimit[owner()] = true;
439         _isExcludedFromMaxTxLimit[address(0)] = true;
440         _isExcludedFromMaxTxLimit[address(this)] = true;
441         _isExcludedFromMaxTxLimit[marketingWallet] = true;
442         _isExcludedFromMaxTxLimit[DEAD] = true;
443 
444         maxWalletLimitEnabled = true;
445 
446         _isExcludedFromMaxWalletLimit[owner()] = true;
447         _isExcludedFromMaxWalletLimit[address(this)] = true;
448         _isExcludedFromMaxWalletLimit[address(0xdead)] = true;
449         _isExcludedFromMaxWalletLimit[marketingWallet] = true;
450         _isExcludedFromMaxWalletLimit[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; //pinklock
451     
452         walletToWalletTransferWithoutFee = true;
453         
454         _isExcludedFromFees[owner()] = true;
455         _isExcludedFromFees[address(0xdead)] = true;
456         _isExcludedFromFees[address(this)] = true;
457 
458         _isExcluded[address(this)] = true;
459         _isExcluded[address(0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE)] = true; //pinklock
460         _isExcluded[address(0xdead)] = true;
461         _isExcluded[address(uniswapV2Pair)] = true;
462 
463         _rOwned[owner()] = _rTotal;
464         _tOwned[owner()] = _tTotal;
465 
466         maxWalletAmount             = _tTotal * 10 / 1000;
467 
468         emit Transfer(address(0), owner(), _tTotal);
469     }
470 
471     function name() public view returns (string memory) {
472         return _name;
473     }
474 
475     function symbol() public view returns (string memory) {
476         return _symbol;
477     }
478 
479     function decimals() public view returns (uint8) {
480         return _decimals;
481     }
482 
483     function totalSupply() public view override returns (uint256) {
484         return _tTotalSupply;
485     }
486 
487     function balanceOf(address account) public view override returns (uint256) {
488         if (_isExcluded[account]) return _tOwned[account];
489         return tokenFromReflection(_rOwned[account]);
490     }
491 
492     function transfer(address recipient, uint256 amount) public override returns (bool) {
493         _transfer(_msgSender(), recipient, amount);
494         return true;
495     }
496 
497     function allowance(address owner, address spender) public view override returns (uint256) {
498         return _allowances[owner][spender];
499     }
500 
501     function approve(address spender, uint256 amount) public override returns (bool) {
502         _approve(_msgSender(), spender, amount);
503         return true;
504     }
505 
506     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
507         _transfer(sender, recipient, amount);
508         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
509         return true;
510     }
511 
512     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
513         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
514         return true;
515     }
516 
517     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
518         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
519         return true;
520     }
521 
522     function isExcludedFromReward(address account) public view returns (bool) {
523         return _isExcluded[account];
524     }
525 
526     function totalReflectionDistributed() public view returns (uint256) {
527         return _tFeeTotal;
528     }
529 
530     function deliver(uint256 tAmount) public {
531         address sender = _msgSender();
532         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
533         (uint256 rAmount,,,,,,) = _getValues(tAmount);
534         _rOwned[sender] = _rOwned[sender] - rAmount;
535         _rTotal = _rTotal - rAmount;
536         _tFeeTotal = _tFeeTotal + tAmount;
537     }
538 
539     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
540         require(tAmount <= _tTotal, "Amount must be less than supply");
541         if (!deductTransferFee) {
542             (uint256 rAmount,,,,,,) = _getValues(tAmount);
543             return rAmount;
544         } else {
545             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
546             return rTransferAmount;
547         }
548     }
549 
550     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
551         require(rAmount <= _rTotal, "Amount must be less than total reflections");
552         uint256 currentRate =  _getRate();
553         return rAmount / currentRate;
554     }
555 
556     function excludeFromReward(address account) public onlyOwner() {
557         require(!_isExcluded[account], "Account is already excluded");
558         if(_rOwned[account] > 0) {
559             _tOwned[account] = tokenFromReflection(_rOwned[account]);
560         }
561         _isExcluded[account] = true;
562         _excluded.push(account);
563     }
564 
565     function includeInReward(address account) external onlyOwner() {
566         require(_isExcluded[account], "Account is already included");
567         for (uint256 i = 0; i < _excluded.length; i++) {
568             if (_excluded[i] == account) {
569                 _excluded[i] = _excluded[_excluded.length - 1];
570                 _tOwned[account] = 0;
571                 _isExcluded[account] = false;
572                 _excluded.pop();
573                 break;
574             }
575         }
576     }
577 
578     receive() external payable {}
579 
580     function claimStuckTokens(address token) external onlyOwner {
581         require(token != address(this), "Owner cannot claim native tokens");
582         if (token == address(0x0)) {
583             payable(msg.sender).sendValue(address(this).balance);
584             return;
585         }
586         IERC20 ERC20token = IERC20(token);
587         uint256 balance = ERC20token.balanceOf(address(this));
588         ERC20token.transfer(msg.sender, balance);
589     }
590 
591     function _reflectFee(uint256 rFee, uint256 tFee) private {
592         _rTotal = _rTotal - rFee;
593         _tFeeTotal = _tFeeTotal + tFee;
594     }
595 
596     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
597         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getTValues(tAmount);
598         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, _getRate());
599         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tMarketing);
600     }
601 
602     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
603         uint256 tFee = calculateTaxFee(tAmount);
604         uint256 tLiquidity = calculateLiquidityFee(tAmount);
605         uint256 tMarketing = calculateMarketingFee(tAmount);
606         uint256 tTransferAmount = tAmount - tFee - tLiquidity - tMarketing;
607         return (tTransferAmount, tFee, tLiquidity, tMarketing);
608     }
609 
610     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
611         uint256 rAmount = tAmount * currentRate;
612         uint256 rFee = tFee * currentRate;
613         uint256 rLiquidity = tLiquidity * currentRate;
614         uint256 rMarketing = tMarketing * currentRate;
615         uint256 rTransferAmount = rAmount - rFee - rLiquidity - rMarketing;
616         return (rAmount, rTransferAmount, rFee);
617     }
618 
619     function _getRate() private view returns(uint256) {
620         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
621         return rSupply / tSupply;
622     }
623 
624     function _getCurrentSupply() private view returns(uint256, uint256) {
625         uint256 rSupply = _rTotal;
626         uint256 tSupply = _tTotal;      
627         for (uint256 i = 0; i < _excluded.length; i++) {
628             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
629             rSupply = rSupply - _rOwned[_excluded[i]];
630             tSupply = tSupply - _tOwned[_excluded[i]];
631         }
632         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
633         return (rSupply, tSupply);
634     }
635     
636     function _takeLiquidity(uint256 tLiquidity) private {
637         uint256 liquidityAmount;
638         uint256 burnAmount;
639 
640         if (liquidityFeeonBuy + liquidityFeeonSell + burnFeeOnBuy + burnFeeOnSell > 0){
641             liquidityAmount = tLiquidity * (liquidityFeeonBuy + liquidityFeeonSell) / (liquidityFeeonBuy + liquidityFeeonSell + burnFeeOnBuy + burnFeeOnSell);
642             burnAmount = tLiquidity - liquidityAmount;
643         }
644 
645         if(liquidityAmount > 0){
646             uint256 currentRate =  _getRate();
647             uint256 rLiquidity = liquidityAmount * currentRate;
648             _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
649             if(_isExcluded[address(this)])
650                 _tOwned[address(this)] = _tOwned[address(this)] + liquidityAmount;
651         }
652 
653         if(burnAmount > 0){
654             uint256 currentRate =  _getRate();
655             uint256 rBurn = burnAmount * currentRate;
656             _rOwned[address(0xdead)] = _rOwned[address(0xdead)] + rBurn;
657             if(_isExcluded[address(0xdead)])
658                 _tOwned[address(0xdead)] = _tOwned[address(0xdead)] + burnAmount;
659 
660             _tTotalSupply -= burnAmount;
661         }
662     }
663 
664     function _takeMarketing(uint256 tMarketing) private {
665         if (tMarketing > 0) {
666             uint256 currentRate =  _getRate();
667             uint256 rMarketing = tMarketing * currentRate;
668             _rOwned[address(this)] = _rOwned[address(this)] + rMarketing;
669             if(_isExcluded[address(this)])
670                 _tOwned[address(this)] = _tOwned[address(this)] + tMarketing;
671         }
672     }
673     
674     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
675         return _amount * _taxFee / 1000;
676     }
677 
678     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
679         return _amount * _liquidityFee / 1000;
680     }
681     
682     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
683         return _amount * _marketingFee / 1000;
684     }
685     
686     function removeAllFee() private {
687         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0) return;
688         
689         _taxFee = 0;
690         _marketingFee = 0;
691         _liquidityFee = 0;
692     }
693     
694     function setBuyFee() private{
695         if(_taxFee == taxFeeonBuy && _liquidityFee == (liquidityFeeonBuy + burnFeeOnBuy) && _marketingFee == marketingFeeonBuy ) return;
696 
697         _taxFee = taxFeeonBuy;
698         _marketingFee = marketingFeeonBuy;
699         _liquidityFee = liquidityFeeonBuy + burnFeeOnBuy;
700     }
701 
702     function setSellFee() private{
703         if(_taxFee == taxFeeonSell && _liquidityFee == (liquidityFeeonSell + burnFeeOnSell) && _marketingFee == marketingFeeonSell ) return;
704 
705         _taxFee = taxFeeonSell;
706         _marketingFee = marketingFeeonSell;
707         _liquidityFee = liquidityFeeonSell + burnFeeOnSell;
708     }
709     
710     function isExcludedFromFee(address account) public view returns(bool) {
711         return _isExcludedFromFees[account];
712     }
713 
714     function _approve(address owner, address spender, uint256 amount) private {
715         require(owner != address(0), "ERC20: approve from the zero address");
716         require(spender != address(0), "ERC20: approve to the zero address");
717 
718         _allowances[owner][spender] = amount;
719         emit Approval(owner, spender, amount);
720     }
721 
722     function enableTrading() external onlyOwner{
723         require(tradingEnabled == false, "Trading is already enabled");
724         tradingEnabled = true;
725     }
726     
727     function _transfer(
728         address from,
729         address to,
730         uint256 amount
731     ) private {
732         require(from != address(0), "ERC20: transfer from the zero address");
733         require(amount > 0, "Transfer amount must be greater than zero");
734 
735         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
736             require(tradingEnabled, "Trading is not enabled yet");
737         }
738 
739         if (maxTransactionLimitEnabled) 
740         {
741             if ((from == uniswapV2Pair || to == uniswapV2Pair) &&
742                 _isExcludedFromMaxTxLimit[from] == false && 
743                 _isExcludedFromMaxTxLimit[to]   == false) 
744             {
745                 if (from == uniswapV2Pair) {
746                     require(
747                         amount <= maxTransactionAmountBuy,  
748                         "AntiWhale: Transfer amount exceeds the maxTransactionAmount"
749                     );
750                 } else {
751                     require(
752                         amount <= maxTransactionAmountSell, 
753                         "AntiWhale: Transfer amount exceeds the maxTransactionAmount"
754                     );
755                 }
756             }
757         }
758 
759         uint256 contractTokenBalance = balanceOf(address(this));        
760         bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;
761         if (
762             overMinTokenBalance &&
763             !inSwapAndLiquify &&
764             to == uniswapV2Pair &&
765             swapEnabled
766         ) {
767             inSwapAndLiquify = true;
768             
769             uint256 marketingShare = marketingFeeonBuy + marketingFeeonSell;
770             uint256 liquidityShare = liquidityFeeonBuy + liquidityFeeonSell;
771 
772             uint256 totalShare = marketingShare + liquidityShare;
773 
774             if(totalShare > 0) {
775                 if(liquidityShare > 0) {
776                     uint256 liquidityTokens = (contractTokenBalance * liquidityShare) / totalShare;
777                     swapAndLiquify(liquidityTokens);
778                 }
779                 
780                 if(marketingShare > 0) {
781                     uint256 marketingTokens = (contractTokenBalance * marketingShare) / totalShare;
782                     swapAndSendMarketing(marketingTokens);
783                 } 
784             }
785 
786             inSwapAndLiquify = false;
787         }
788         
789         //transfer amount, it will take tax, burn, liquidity fee
790         _tokenTransfer(from,to,amount);
791 
792         if (maxWalletLimitEnabled) 
793         {
794             if (!_isExcludedFromMaxWalletLimit[from] && 
795                 !_isExcludedFromMaxWalletLimit[to] &&
796                 to != uniswapV2Pair
797             ) {
798                 uint256 balance  = balanceOf(to);
799                 require(
800                     balance + amount <= maxWalletAmount, 
801                     "MaxWallet: Recipient exceeds the maxWalletAmount"
802                 );
803             }
804         }
805     }
806 
807     function swapAndLiquify(uint256 tokens) private {
808         uint256 half = tokens / 2;
809         uint256 otherHalf = tokens - half;
810 
811         uint256 initialBalance = address(this).balance;
812 
813         address[] memory path = new address[](2);
814         path[0] = address(this);
815         path[1] = uniswapV2Router.WETH();
816 
817         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
818             half,
819             0, // accept any amount of ETH
820             path,
821             address(this),
822             block.timestamp);
823         
824         uint256 newBalance = address(this).balance - initialBalance;
825 
826         uniswapV2Router.addLiquidityETH{value: newBalance}(
827             address(this),
828             otherHalf,
829             0, // slippage is unavoidable
830             0, // slippage is unavoidable
831             DEAD,
832             block.timestamp
833         );
834 
835         emit SwapAndLiquify(half, newBalance, otherHalf);
836     }
837 
838     function swapAndSendMarketing(uint256 tokenAmount) private {
839         uint256 initialBalance = address(this).balance;
840 
841         address[] memory path = new address[](2);
842         path[0] = address(this);
843         path[1] = uniswapV2Router.WETH();
844 
845         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
846             tokenAmount,
847             0, // accept any amount of ETH
848             path,
849             address(this),
850             block.timestamp);
851 
852         uint256 newBalance = address(this).balance - initialBalance;
853 
854         payable(marketingWallet).sendValue(newBalance);
855 
856         emit SwapAndSendMarketing(tokenAmount, newBalance);
857     }
858 
859     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner() {
860         require(newAmount > totalSupply() / 1e5, "SwapTokensAtAmount must be greater than 0.001% of total supply");
861         swapTokensAtAmount = newAmount;
862         emit SwapTokensAtAmountUpdated(newAmount);
863     }
864     
865     function setSwapEnabled(bool _enabled) external onlyOwner {
866         swapEnabled = _enabled;
867         emit SwapEnabledUpdated(_enabled);
868     }
869 
870     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
871          if (_isExcludedFromFees[sender] || 
872             _isExcludedFromFees[recipient] 
873             ) {
874             removeAllFee();
875         }else if(recipient == uniswapV2Pair){
876             setSellFee();
877         }else if(sender == uniswapV2Pair){
878             setBuyFee();
879         }else if(walletToWalletTransferWithoutFee){
880             removeAllFee();
881         }else{
882             setSellFee();
883         }
884 
885         if (_isExcluded[sender] && !_isExcluded[recipient]) {
886             _transferFromExcluded(sender, recipient, amount);
887         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
888             _transferToExcluded(sender, recipient, amount);
889         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
890             _transferStandard(sender, recipient, amount);
891         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
892             _transferBothExcluded(sender, recipient, amount);
893         } else {
894             _transferStandard(sender, recipient, amount);
895         }
896     }
897 
898     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
899         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
900         _rOwned[sender] = _rOwned[sender] - rAmount;
901         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
902         _takeMarketing(tMarketing);
903         _takeLiquidity(tLiquidity);
904         _reflectFee(rFee, tFee);
905         emit Transfer(sender, recipient, tTransferAmount);
906     }
907 
908     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
909         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
910         _rOwned[sender] = _rOwned[sender] - rAmount;
911         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
912         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
913         _takeMarketing(tMarketing);           
914         _takeLiquidity(tLiquidity);
915         _reflectFee(rFee, tFee);
916         emit Transfer(sender, recipient, tTransferAmount);
917     }
918 
919     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
920         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
921         _tOwned[sender] = _tOwned[sender] - tAmount;
922         _rOwned[sender] = _rOwned[sender] - rAmount;
923         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount; 
924         _takeMarketing(tMarketing);  
925         _takeLiquidity(tLiquidity);
926         _reflectFee(rFee, tFee);
927         emit Transfer(sender, recipient, tTransferAmount);
928     }
929 
930     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
931         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
932         _tOwned[sender] = _tOwned[sender] - tAmount;
933         _rOwned[sender] = _rOwned[sender] - rAmount;
934         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
935         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
936         _takeMarketing(tMarketing);        
937         _takeLiquidity(tLiquidity);
938         _reflectFee(rFee, tFee);
939         emit Transfer(sender, recipient, tTransferAmount);
940     }
941 
942     function excludeFromFees(address account, bool excluded) external onlyOwner {
943         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
944         _isExcludedFromFees[account] = excluded;
945 
946         emit ExcludeFromFees(account, excluded);
947     }
948     
949     function changeMarketingWallet(address _marketingWallet) external onlyOwner {
950         require(_marketingWallet != marketingWallet, "Marketing wallet is already that address");
951         require(_marketingWallet!=address(0), "Marketing wallet is the zero address");
952         marketingWallet = _marketingWallet;
953         emit MarketingWalletChanged(marketingWallet);
954     }
955 
956     function setBuyFeePercentages(uint256 _taxFeeonBuy, uint256 _liquidityFeeonBuy, uint256 _marketingFeeonBuy, uint256 _burnFeeOnBuy) external onlyOwner {
957         taxFeeonBuy = _taxFeeonBuy;
958         liquidityFeeonBuy = _liquidityFeeonBuy;
959         marketingFeeonBuy = _marketingFeeonBuy;
960         burnFeeOnBuy = _burnFeeOnBuy;
961 
962         totalBuyFees = taxFeeonBuy + liquidityFeeonBuy + marketingFeeonBuy + burnFeeOnBuy;
963 
964         require(totalBuyFees <= 100, "Buy fees cannot be greater than 10%");
965 
966         emit BuyFeesChanged(taxFeeonBuy, liquidityFeeonBuy, marketingFeeonBuy);
967     }
968 
969     function setSellFeePercentages(uint256 _taxFeeonSell, uint256 _liquidityFeeonSell, uint256 _marketingFeeonSell, uint256 _burnFeeOnSell) external onlyOwner {
970         taxFeeonSell = _taxFeeonSell;
971         liquidityFeeonSell = _liquidityFeeonSell;
972         marketingFeeonSell = _marketingFeeonSell;
973         burnFeeOnSell = _burnFeeOnSell;
974 
975         totalSellFees = taxFeeonSell + liquidityFeeonSell + marketingFeeonSell + burnFeeOnSell;
976 
977         require(totalSellFees <= 100, "Sell fees cannot be greater than 10%");
978 
979         emit SellFeesChanged(taxFeeonSell, liquidityFeeonSell, marketingFeeonSell);
980     }
981 
982     function enableWalletToWalletTransferWithoutFee(bool enable) external onlyOwner {
983         require(walletToWalletTransferWithoutFee != enable, "Wallet to wallet transfer without fee is already set to that value");
984         walletToWalletTransferWithoutFee = enable;
985         emit WalletToWalletTransferWithoutFeeEnabled(enable);
986     }
987 
988     mapping(address => bool) private _isExcludedFromMaxTxLimit;
989     bool    public  maxTransactionLimitEnabled;
990     uint256 public  maxTransactionAmountBuy;
991     uint256 public  maxTransactionAmountSell;
992 
993     event ExcludedFromMaxTransactionLimit(address indexed account, bool isExcluded);
994     event MaxTransactionLimitStateChanged(bool maxTransactionLimit);
995     event MaxTransactionLimitAmountChanged(uint256 maxTransactionAmountBuy, uint256 maxTransactionAmountSell);
996 
997     function setEnableMaxTransactionLimit(bool enable) external onlyOwner {
998         require(
999             enable != maxTransactionLimitEnabled, 
1000             "Max transaction limit is already set to that state"
1001         );
1002         maxTransactionLimitEnabled = enable;
1003         emit MaxTransactionLimitStateChanged(maxTransactionLimitEnabled);
1004     }
1005 
1006     function setMaxTransactionAmounts(uint256 _maxTransactionAmountBuy, uint256 _maxTransactionAmountSell) external onlyOwner {
1007         require(
1008             _maxTransactionAmountBuy  >= totalSupply() / (10 ** decimals()) / 1000 && 
1009             _maxTransactionAmountSell >= totalSupply() / (10 ** decimals()) / 1000, 
1010             "Max Transaction limis cannot be lower than 0.1% of total supply"
1011         ); 
1012         maxTransactionAmountBuy  = _maxTransactionAmountBuy  * (10 ** decimals());
1013         maxTransactionAmountSell = _maxTransactionAmountSell * (10 ** decimals());
1014         emit MaxTransactionLimitAmountChanged(maxTransactionAmountBuy, maxTransactionAmountSell);
1015     }
1016 
1017     function setExcludeFromMaxTransactionLimit(address account, bool exclude) external onlyOwner {
1018         require(
1019             _isExcludedFromMaxTxLimit[account] != exclude, 
1020             "Account is already set to that state"
1021         );
1022         _isExcludedFromMaxTxLimit[account] = exclude;
1023         emit ExcludedFromMaxTransactionLimit(account, exclude);
1024     }
1025 
1026     function isExcludedFromMaxTransaction(address account) public view returns(bool) {
1027         return _isExcludedFromMaxTxLimit[account];
1028     }
1029 
1030     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
1031     bool    public maxWalletLimitEnabled;
1032     uint256 public maxWalletAmount;
1033 
1034     event ExcludedFromMaxWalletLimit(address indexed account, bool isExcluded);
1035     event MaxWalletLimitStateChanged(bool maxWalletLimit);
1036     event MaxWalletLimitAmountChanged(uint256 maxWalletAmount);
1037 
1038     function setEnableMaxWalletLimit(bool enable) external onlyOwner {
1039         require(enable != maxWalletLimitEnabled,"Max wallet limit is already set to that state");
1040         maxWalletLimitEnabled = enable;
1041 
1042         emit MaxWalletLimitStateChanged(maxWalletLimitEnabled);
1043     }
1044 
1045     function setMaxWalletAmount(uint256 _maxWalletAmount) external onlyOwner {
1046         require(_maxWalletAmount >= (totalSupply() / (10 ** decimals())) / 100, "Max wallet percentage cannot be lower than 1%");
1047         maxWalletAmount = _maxWalletAmount * (10 ** decimals());
1048 
1049         emit MaxWalletLimitAmountChanged(maxWalletAmount);
1050     }
1051 
1052     function excludeFromMaxWallet(address account, bool exclude) external onlyOwner {
1053         require( _isExcludedFromMaxWalletLimit[account] != exclude,"Account is already set to that state");
1054         require(account != address(this), "Can't set this address.");
1055 
1056         _isExcludedFromMaxWalletLimit[account] = exclude;
1057 
1058         emit ExcludedFromMaxWalletLimit(account, exclude);
1059     }
1060 
1061     function isExcludedFromMaxWalletLimit(address account) public view returns(bool) {
1062         return _isExcludedFromMaxWalletLimit[account];
1063     }
1064 }