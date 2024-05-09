1 // ░██████╗░█████╗░███████╗██╗░░░██╗  ██████╗░██╗░░░██╗
2 // ██╔════╝██╔══██╗██╔════╝██║░░░██║  ██╔══██╗╚██╗░██╔╝
3 // ╚█████╗░███████║█████╗░░██║░░░██║  ██████╦╝░╚████╔╝░
4 // ░╚═══██╗██╔══██║██╔══╝░░██║░░░██║  ██╔══██╗░░╚██╔╝░░
5 // ██████╔╝██║░░██║██║░░░░░╚██████╔╝  ██████╦╝░░░██║░░░
6 // ╚═════╝░╚═╝░░╚═╝╚═╝░░░░░░╚═════╝░  ╚═════╝░░░░╚═╝░░░
7 
8 // ░█████╗░░█████╗░██╗███╗░░██╗░██████╗██╗░░░██╗██╗░░░░░████████╗░░░███╗░░██╗███████╗████████╗
9 // ██╔══██╗██╔══██╗██║████╗░██║██╔════╝██║░░░██║██║░░░░░╚══██╔══╝░░░████╗░██║██╔════╝╚══██╔══╝
10 // ██║░░╚═╝██║░░██║██║██╔██╗██║╚█████╗░██║░░░██║██║░░░░░░░░██║░░░░░░██╔██╗██║█████╗░░░░░██║░░░
11 // ██║░░██╗██║░░██║██║██║╚████║░╚═══██╗██║░░░██║██║░░░░░░░░██║░░░░░░██║╚████║██╔══╝░░░░░██║░░░
12 // ╚█████╔╝╚█████╔╝██║██║░╚███║██████╔╝╚██████╔╝███████╗░░░██║░░░██╗██║░╚███║███████╗░░░██║░░░
13 // ░╚════╝░░╚════╝░╚═╝╚═╝░░╚══╝╚═════╝░░╚═════╝░╚══════╝░░░╚═╝░░░╚═╝╚═╝░░╚══╝╚══════╝░░░╚═╝░░░
14 
15 // SAFU By Coinsult
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity 0.8.17;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return payable(msg.sender);
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 abstract contract Ownable is Context {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     constructor () {
38         address msgSender = _msgSender();
39         _owner = msgSender;
40         emit OwnershipTransferred(address(0), msgSender);
41     }
42 
43     function owner() public view returns (address) {
44         return _owner;
45     }
46 
47     modifier onlyOwner() {
48         require(_owner == _msgSender(), "Ownable: caller is not the owner");
49         _;
50     }
51 
52     function renounceOwnership() public virtual onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         emit OwnershipTransferred(_owner, newOwner);
60         _owner = newOwner;
61     }
62 }
63 
64 interface IERC20 {
65     function totalSupply() external view returns (uint256);
66     function balanceOf(address account) external view returns (uint256);
67     function transfer(address recipient, uint256 amount) external returns (bool);
68     function allowance(address owner, address spender) external view returns (uint256);
69     function approve(address spender, uint256 amount) external returns (bool);
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75    
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 library Address {
81     function isContract(address account) internal view returns (bool) {
82         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
83         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
84         // for accounts without code, i.e. `keccak256('')`
85         bytes32 codehash;
86         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
87         // solhint-disable-next-line no-inline-assembly
88         assembly { codehash := extcodehash(account) }
89         return (codehash != accountHash && codehash != 0x0);
90     }
91 
92     function sendValue(address payable recipient, uint256 amount) internal returns(bool){
93         require(address(this).balance >= amount, "Address: insufficient balance");
94 
95         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
96         (bool success, ) = recipient.call{ value: amount }("");
97         return success;
98     }
99 
100     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
101       return functionCall(target, data, "Address: low-level call failed");
102     }
103 
104     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
105         return _functionCallWithValue(target, data, 0, errorMessage);
106     }
107 
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
113         require(address(this).balance >= value, "Address: insufficient balance for call");
114         return _functionCallWithValue(target, data, value, errorMessage);
115     }
116 
117     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
118         require(isContract(target), "Address: call to non-contract");
119 
120         // solhint-disable-next-line avoid-low-level-calls
121         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
122         if (success) {
123             return returndata;
124         } else {
125             // Look for revert reason and bubble it up if present
126             if (returndata.length > 0) {
127                 // The easiest way to bubble the revert reason is using memory via assembly
128 
129                 // solhint-disable-next-line no-inline-assembly
130                 assembly {
131                     let returndata_size := mload(returndata)
132                     revert(add(32, returndata), returndata_size)
133                 }
134             } else {
135                 revert(errorMessage);
136             }
137         }
138     }
139 }
140 
141 interface IUniswapV2Factory {
142     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
143 
144     function feeTo() external view returns (address);
145     function feeToSetter() external view returns (address);
146 
147     function getPair(address tokenA, address tokenB) external view returns (address pair);
148     function allPairs(uint) external view returns (address pair);
149     function allPairsLength() external view returns (uint);
150 
151     function createPair(address tokenA, address tokenB) external returns (address pair);
152 
153     function setFeeTo(address) external;
154     function setFeeToSetter(address) external;
155 }
156 
157 interface IUniswapV2Pair {
158     event Approval(address indexed owner, address indexed spender, uint value);
159     event Transfer(address indexed from, address indexed to, uint value);
160 
161     function name() external pure returns (string memory);
162     function symbol() external pure returns (string memory);
163     function decimals() external pure returns (uint8);
164     function totalSupply() external view returns (uint);
165     function balanceOf(address owner) external view returns (uint);
166     function allowance(address owner, address spender) external view returns (uint);
167 
168     function approve(address spender, uint value) external returns (bool);
169     function transfer(address to, uint value) external returns (bool);
170     function transferFrom(address from, address to, uint value) external returns (bool);
171 
172     function DOMAIN_SEPARATOR() external view returns (bytes32);
173     function PERMIT_TYPEHASH() external pure returns (bytes32);
174     function nonces(address owner) external view returns (uint);
175 
176     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
177 
178     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
179     event Swap(
180         address indexed sender,
181         uint amount0In,
182         uint amount1In,
183         uint amount0Out,
184         uint amount1Out,
185         address indexed to
186     );
187     event Sync(uint112 reserve0, uint112 reserve1);
188 
189     function MINIMUM_LIQUIDITY() external pure returns (uint);
190     function factory() external view returns (address);
191     function token0() external view returns (address);
192     function token1() external view returns (address);
193     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
194     function price0CumulativeLast() external view returns (uint);
195     function price1CumulativeLast() external view returns (uint);
196     function kLast() external view returns (uint);
197 
198     function burn(address to) external returns (uint amount0, uint amount1);
199     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
200     function skim(address to) external;
201     function sync() external;
202 
203     function initialize(address, address) external;
204 }
205 
206 interface IUniswapV2Router01 {
207     function factory() external pure returns (address);
208     function WETH() external pure returns (address);
209 
210     function addLiquidity(
211         address tokenA,
212         address tokenB,
213         uint amountADesired,
214         uint amountBDesired,
215         uint amountAMin,
216         uint amountBMin,
217         address to,
218         uint deadline
219     ) external returns (uint amountA, uint amountB, uint liquidity);
220     function addLiquidityETH(
221         address token,
222         uint amountTokenDesired,
223         uint amountTokenMin,
224         uint amountETHMin,
225         address to,
226         uint deadline
227     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
228     function removeLiquidity(
229         address tokenA,
230         address tokenB,
231         uint liquidity,
232         uint amountAMin,
233         uint amountBMin,
234         address to,
235         uint deadline
236     ) external returns (uint amountA, uint amountB);
237     function removeLiquidityETH(
238         address token,
239         uint liquidity,
240         uint amountTokenMin,
241         uint amountETHMin,
242         address to,
243         uint deadline
244     ) external returns (uint amountToken, uint amountETH);
245     function removeLiquidityWithPermit(
246         address tokenA,
247         address tokenB,
248         uint liquidity,
249         uint amountAMin,
250         uint amountBMin,
251         address to,
252         uint deadline,
253         bool approveMax, uint8 v, bytes32 r, bytes32 s
254     ) external returns (uint amountA, uint amountB);
255     function removeLiquidityETHWithPermit(
256         address token,
257         uint liquidity,
258         uint amountTokenMin,
259         uint amountETHMin,
260         address to,
261         uint deadline,
262         bool approveMax, uint8 v, bytes32 r, bytes32 s
263     ) external returns (uint amountToken, uint amountETH);
264     function swapExactTokensForTokens(
265         uint amountIn,
266         uint amountOutMin,
267         address[] calldata path,
268         address to,
269         uint deadline
270     ) external returns (uint[] memory amounts);
271     function swapTokensForExactTokens(
272         uint amountOut,
273         uint amountInMax,
274         address[] calldata path,
275         address to,
276         uint deadline
277     ) external returns (uint[] memory amounts);
278     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
279         external
280         payable
281         returns (uint[] memory amounts);
282     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
283         external
284         returns (uint[] memory amounts);
285     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
286         external
287         returns (uint[] memory amounts);
288     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
289         external
290         payable
291         returns (uint[] memory amounts);
292 
293     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
294     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
295     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
296     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
297     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
298 }
299 
300 interface IUniswapV2Router02 is IUniswapV2Router01 {
301     function removeLiquidityETHSupportingFeeOnTransferTokens(
302         address token,
303         uint liquidity,
304         uint amountTokenMin,
305         uint amountETHMin,
306         address to,
307         uint deadline
308     ) external returns (uint amountETH);
309     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
310         address token,
311         uint liquidity,
312         uint amountTokenMin,
313         uint amountETHMin,
314         address to,
315         uint deadline,
316         bool approveMax, uint8 v, bytes32 r, bytes32 s
317     ) external returns (uint amountETH);
318 
319     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
320         uint amountIn,
321         uint amountOutMin,
322         address[] calldata path,
323         address to,
324         uint deadline
325     ) external;
326     function swapExactETHForTokensSupportingFeeOnTransferTokens(
327         uint amountOutMin,
328         address[] calldata path,
329         address to,
330         uint deadline
331     ) external payable;
332     function swapExactTokensForETHSupportingFeeOnTransferTokens(
333         uint amountIn,
334         uint amountOutMin,
335         address[] calldata path,
336         address to,
337         uint deadline
338     ) external;
339 }
340 
341 contract AIDOGE2 is Context, IERC20, Ownable {
342     using Address for address;
343     using Address for address payable;
344 
345     mapping (address => uint256) private _rOwned;
346     mapping (address => uint256) private _tOwned;
347     mapping (address => mapping (address => uint256)) private _allowances;
348 
349     mapping (address => bool) private _isExcludedFromFees;
350     mapping (address => bool) private _isExcluded;
351     address[] private _excluded;
352 
353     string private _name     = "AIDOGE 2.0";
354     string private _symbol   = "AIDOGE2.0";
355     uint8  private _decimals = 9;
356    
357     uint256 private constant MAX = type(uint256).max;
358     uint256 private _tTotal = 420_690e9 * (10 ** _decimals);
359     uint256 private _rTotal = (MAX - (MAX % _tTotal));
360     uint256 private _tFeeTotal;
361 
362     uint256 public taxFeeonBuy;
363     uint256 public taxFeeonSell;
364 
365     uint256 public buybackBurnFeeOnBuy;
366     uint256 public buybackBurnFeeOnSell;
367 
368     uint256 public marketingFeeonBuy;
369     uint256 public marketingFeeonSell;
370 
371     uint256 private _taxFee;
372     uint256 private _buybackBurnFee;
373     uint256 private _marketingFee;
374 
375     uint256 public totalBuyFees;
376     uint256 public totalSellFees;
377 
378     address public marketingWallet;
379 
380     bool public walletToWalletTransferWithoutFee;
381     
382     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
383 
384     IUniswapV2Router02 public  uniswapV2Router;
385     address public  uniswapV2Pair;
386 
387     bool private inSwapAndLiquify;
388     bool public swapEnabled;
389     bool public tradingEnabled;
390     uint256 public swapTokensAtAmount;
391     
392     event ExcludeFromFees(address indexed account, bool isExcluded);
393     event MarketingWalletChanged(address marketingWallet);
394     event SwapEnabledUpdated(bool enabled);
395     event SwapAndLiquify(uint256 tokensSwapped, uint256 bnbReceived, uint256 tokensIntoLiqudity);
396     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);
397     event SwapTokensAtAmountUpdated(uint256 amount);
398     event BuyFeesChanged(uint256 taxFee, uint256 buybackBurnFee, uint256 marketingFee);
399     event SellFeesChanged(uint256 taxFee, uint256 buybackBurnFee, uint256 marketingFee);
400     event WalletToWalletTransferWithoutFeeEnabled(bool enabled);
401     
402     constructor() 
403     {        
404         address router;
405         if (block.chainid == 56) {
406             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; 
407         } else if (block.chainid == 97) {
408             router =  0xD99D1c33F9fC3444f8101754aBC46c52416550D1; 
409         } else if (block.chainid == 1 || block.chainid == 5) {
410             router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; 
411         } else {
412             revert();
413         }
414 
415         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
416         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
417             .createPair(address(this), _uniswapV2Router.WETH());
418         uniswapV2Router = _uniswapV2Router;
419 
420         _approve(address(this), address(uniswapV2Router), MAX);
421 
422         taxFeeonBuy = 1;
423         taxFeeonSell = 1;
424 
425         buybackBurnFeeOnBuy = 1;
426         buybackBurnFeeOnSell = 1;
427 
428         marketingFeeonBuy = 1;
429         marketingFeeonSell = 1;
430 
431         totalBuyFees = taxFeeonBuy + buybackBurnFeeOnBuy + marketingFeeonBuy;
432         totalSellFees = taxFeeonSell + buybackBurnFeeOnSell + marketingFeeonSell;
433 
434         marketingWallet = 0xA012aB5B35Ee9ebB1f73025EaCa09d8b44963600;
435         
436         swapEnabled = true;
437         swapTokensAtAmount = _tTotal / 5000;
438     
439         walletToWalletTransferWithoutFee = false;
440         
441         _isExcludedFromFees[owner()] = true;
442         _isExcludedFromFees[address(0xdead)] = true;
443         _isExcludedFromFees[address(this)] = true;
444 
445         _isExcluded[address(this)] = true;
446         _isExcluded[address(0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE)] = true; //pinklock
447         _isExcluded[address(0xdead)] = true;
448         _isExcluded[address(uniswapV2Pair)] = true;
449 
450         _rOwned[owner()] = _rTotal;
451         _tOwned[owner()] = _tTotal;
452 
453         emit Transfer(address(0), owner(), _tTotal);
454     }
455 
456     function name() public view returns (string memory) {
457         return _name;
458     }
459 
460     function symbol() public view returns (string memory) {
461         return _symbol;
462     }
463 
464     function decimals() public view returns (uint8) {
465         return _decimals;
466     }
467 
468     function totalSupply() public view override returns (uint256) {
469         return _tTotal;
470     }
471 
472     function balanceOf(address account) public view override returns (uint256) {
473         if (_isExcluded[account]) return _tOwned[account];
474         return tokenFromReflection(_rOwned[account]);
475     }
476 
477     function transfer(address recipient, uint256 amount) public override returns (bool) {
478         _transfer(_msgSender(), recipient, amount);
479         return true;
480     }
481 
482     function allowance(address owner, address spender) public view override returns (uint256) {
483         return _allowances[owner][spender];
484     }
485 
486     function approve(address spender, uint256 amount) public override returns (bool) {
487         _approve(_msgSender(), spender, amount);
488         return true;
489     }
490 
491     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
492         _transfer(sender, recipient, amount);
493         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
494         return true;
495     }
496 
497     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
498         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
499         return true;
500     }
501 
502     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
503         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
504         return true;
505     }
506 
507     function isExcludedFromReward(address account) public view returns (bool) {
508         return _isExcluded[account];
509     }
510 
511     function totalReflectionDistributed() public view returns (uint256) {
512         return _tFeeTotal;
513     }
514 
515     function deliver(uint256 tAmount) public {
516         address sender = _msgSender();
517         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
518         (uint256 rAmount,,,,,,) = _getValues(tAmount);
519         _rOwned[sender] = _rOwned[sender] - rAmount;
520         _rTotal = _rTotal - rAmount;
521         _tFeeTotal = _tFeeTotal + tAmount;
522     }
523 
524     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
525         require(tAmount <= _tTotal, "Amount must be less than supply");
526         if (!deductTransferFee) {
527             (uint256 rAmount,,,,,,) = _getValues(tAmount);
528             return rAmount;
529         } else {
530             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
531             return rTransferAmount;
532         }
533     }
534 
535     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
536         require(rAmount <= _rTotal, "Amount must be less than total reflections");
537         uint256 currentRate =  _getRate();
538         return rAmount / currentRate;
539     }
540 
541     function excludeFromReward(address account) public onlyOwner() {
542         require(!_isExcluded[account], "Account is already excluded");
543         if(_rOwned[account] > 0) {
544             _tOwned[account] = tokenFromReflection(_rOwned[account]);
545         }
546         _isExcluded[account] = true;
547         _excluded.push(account);
548     }
549 
550     function includeInReward(address account) external onlyOwner() {
551         require(_isExcluded[account], "Account is already included");
552         for (uint256 i = 0; i < _excluded.length; i++) {
553             if (_excluded[i] == account) {
554                 _excluded[i] = _excluded[_excluded.length - 1];
555                 _tOwned[account] = 0;
556                 _isExcluded[account] = false;
557                 _excluded.pop();
558                 break;
559             }
560         }
561     }
562 
563     receive() external payable {}
564 
565     function claimStuckTokens(address token) external onlyOwner {
566         require(token != address(this), "Owner cannot claim native tokens");
567         if (token == address(0x0)) {
568             payable(msg.sender).sendValue(address(this).balance);
569             return;
570         }
571         IERC20 ERC20token = IERC20(token);
572         uint256 balance = ERC20token.balanceOf(address(this));
573         ERC20token.transfer(msg.sender, balance);
574     }
575 
576     function _reflectFee(uint256 rFee, uint256 tFee) private {
577         _rTotal = _rTotal - rFee;
578         _tFeeTotal = _tFeeTotal + tFee;
579     }
580 
581     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
582         (uint256 tTransferAmount, uint256 tFee, uint256 tBuybackBurn, uint256 tMarketing) = _getTValues(tAmount);
583         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBuybackBurn, tMarketing, _getRate());
584         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBuybackBurn, tMarketing);
585     }
586 
587     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
588         uint256 tFee = calculateTaxFee(tAmount);
589         uint256 tBuybackBurn = calculateBuybackFee(tAmount);
590         uint256 tMarketing = calculateMarketingFee(tAmount);
591         uint256 tTransferAmount = tAmount - tFee - tBuybackBurn - tMarketing;
592         return (tTransferAmount, tFee, tBuybackBurn, tMarketing);
593     }
594 
595     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBuybackBurn, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
596         uint256 rAmount = tAmount * currentRate;
597         uint256 rFee = tFee * currentRate;
598         uint256 rBuybackBurn = tBuybackBurn * currentRate;
599         uint256 rMarketing = tMarketing * currentRate;
600         uint256 rTransferAmount = rAmount - rFee - rBuybackBurn - rMarketing;
601         return (rAmount, rTransferAmount, rFee);
602     }
603 
604     function _getRate() private view returns(uint256) {
605         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
606         return rSupply / tSupply;
607     }
608 
609     function _getCurrentSupply() private view returns(uint256, uint256) {
610         uint256 rSupply = _rTotal;
611         uint256 tSupply = _tTotal;      
612         for (uint256 i = 0; i < _excluded.length; i++) {
613             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
614             rSupply = rSupply - _rOwned[_excluded[i]];
615             tSupply = tSupply - _tOwned[_excluded[i]];
616         }
617         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
618         return (rSupply, tSupply);
619     }
620     
621     function _takeBuyback(uint256 tBuybackBurn) private {
622         if (tBuybackBurn > 0) {
623             uint256 currentRate =  _getRate();
624             uint256 rBuybackBurn = tBuybackBurn * currentRate;
625             _rOwned[address(this)] = _rOwned[address(this)] + rBuybackBurn;
626             if(_isExcluded[address(this)])
627                 _tOwned[address(this)] = _tOwned[address(this)] + tBuybackBurn;
628         }
629     }
630 
631     function _takeMarketing(uint256 tMarketing) private {
632         if (tMarketing > 0) {
633             uint256 currentRate =  _getRate();
634             uint256 rMarketing = tMarketing * currentRate;
635             _rOwned[address(this)] = _rOwned[address(this)] + rMarketing;
636             if(_isExcluded[address(this)])
637                 _tOwned[address(this)] = _tOwned[address(this)] + tMarketing;
638         }
639     }
640     
641     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
642         return _amount * _taxFee / 100;
643     }
644 
645     function calculateBuybackFee(uint256 _amount) private view returns (uint256) {
646         return _amount * _buybackBurnFee / 100;
647     }
648     
649     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
650         return _amount * _marketingFee / 100;
651     }
652     
653     function removeAllFee() private {
654         if(_taxFee == 0 && _buybackBurnFee == 0 && _marketingFee == 0) return;
655         
656         _taxFee = 0;
657         _marketingFee = 0;
658         _buybackBurnFee = 0;
659     }
660     
661     function setBuyFee() private{
662         if(_taxFee == taxFeeonBuy && _buybackBurnFee == buybackBurnFeeOnBuy && _marketingFee == marketingFeeonBuy) return;
663 
664         _taxFee = taxFeeonBuy;
665         _marketingFee = marketingFeeonBuy;
666         _buybackBurnFee = buybackBurnFeeOnBuy;
667     }
668 
669     function setSellFee() private{
670         if(_taxFee == taxFeeonSell && _buybackBurnFee == buybackBurnFeeOnSell && _marketingFee == marketingFeeonSell) return;
671 
672         _taxFee = taxFeeonSell;
673         _marketingFee = marketingFeeonSell;
674         _buybackBurnFee = buybackBurnFeeOnSell;
675     }
676     
677     function isExcludedFromFee(address account) public view returns(bool) {
678         return _isExcludedFromFees[account];
679     }
680 
681     function _approve(address owner, address spender, uint256 amount) private {
682         require(owner != address(0), "ERC20: approve from the zero address");
683         require(spender != address(0), "ERC20: approve to the zero address");
684 
685         _allowances[owner][spender] = amount;
686         emit Approval(owner, spender, amount);
687     }
688 
689     function enableTrading() external onlyOwner{
690         require(tradingEnabled == false, "Trading is already enabled");
691         tradingEnabled = true;
692     }
693     
694     function _transfer(
695         address from,
696         address to,
697         uint256 amount
698     ) private {
699         require(from != address(0), "ERC20: transfer from the zero address");
700         require(amount > 0, "Transfer amount must be greater than zero");
701 
702         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
703             require(tradingEnabled, "Trading is not enabled yet");
704         }
705 
706         uint256 contractTokenBalance = balanceOf(address(this));        
707         bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;
708         if (
709             overMinTokenBalance &&
710             !inSwapAndLiquify &&
711             to == uniswapV2Pair &&
712             swapEnabled
713         ) {
714             inSwapAndLiquify = true;
715 
716             uint256 initialBalance = address(this).balance;
717 
718             address[] memory path = new address[](2);
719             path[0] = address(this);
720             path[1] = uniswapV2Router.WETH();
721 
722             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
723                 contractTokenBalance,
724                 0, // accept any amount of ETH
725                 path,
726                 address(this),
727                 block.timestamp);
728 
729             uint256 newBalance = address(this).balance - initialBalance;
730             
731             uint256 marketingShare = marketingFeeonBuy + marketingFeeonSell;
732             uint256 buybackShare = buybackBurnFeeOnBuy + buybackBurnFeeOnSell;
733             uint256 totalShare = marketingShare + buybackShare;
734 
735             if(totalShare > 0) {
736                 if(buybackShare > 0) {
737                     uint256 buybackBNB = (newBalance * buybackShare) / totalShare;
738                     buybackAndBurn(buybackBNB);
739                 }
740                 
741                 if(marketingShare > 0) {
742                     uint256 marketingAmount = address(this).balance - initialBalance;
743                     payable(marketingWallet).sendValue(marketingAmount);
744                 } 
745             }
746 
747             inSwapAndLiquify = false;
748         }
749         
750         //transfer amount, it will take tax, burn, buyback fee
751         _tokenTransfer(from,to,amount);
752     }
753 
754     function buybackAndBurn(uint256 buybackBNB) private {
755         address[] memory path = new address[](2);
756         path[0] = uniswapV2Router.WETH();
757         path[1] = address(this);
758 
759         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: buybackBNB }(
760             0,
761             path,
762             address(0xdead),
763             block.timestamp + 300
764         );
765     }
766 
767     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner() {
768         require(newAmount > totalSupply() / 1e5, "SwapTokensAtAmount must be greater than 0.001% of total supply");
769         swapTokensAtAmount = newAmount;
770         emit SwapTokensAtAmountUpdated(newAmount);
771     }
772     
773     function setSwapEnabled(bool _enabled) external onlyOwner {
774         swapEnabled = _enabled;
775         emit SwapEnabledUpdated(_enabled);
776     }
777 
778     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
779          if (_isExcludedFromFees[sender] || 
780             _isExcludedFromFees[recipient] 
781             ) {
782             removeAllFee();
783         }else if(recipient == uniswapV2Pair){
784             setSellFee();
785         }else if(sender == uniswapV2Pair){
786             setBuyFee();
787         }else if(walletToWalletTransferWithoutFee){
788             removeAllFee();
789         }else{
790             setSellFee();
791         }
792 
793         if (_isExcluded[sender] && !_isExcluded[recipient]) {
794             _transferFromExcluded(sender, recipient, amount);
795         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
796             _transferToExcluded(sender, recipient, amount);
797         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
798             _transferStandard(sender, recipient, amount);
799         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
800             _transferBothExcluded(sender, recipient, amount);
801         } else {
802             _transferStandard(sender, recipient, amount);
803         }
804 
805     }
806 
807     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
808         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBuybackBurn, uint256 tMarketing) = _getValues(tAmount);
809         _rOwned[sender] = _rOwned[sender] - rAmount;
810         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
811         _takeMarketing(tMarketing);
812         _takeBuyback(tBuybackBurn);
813         _reflectFee(rFee, tFee);
814         emit Transfer(sender, recipient, tTransferAmount);
815     }
816 
817     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
818         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBuybackBurn, uint256 tMarketing) = _getValues(tAmount);
819         _rOwned[sender] = _rOwned[sender] - rAmount;
820         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
821         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
822         _takeMarketing(tMarketing);           
823         _takeBuyback(tBuybackBurn);
824         _reflectFee(rFee, tFee);
825         emit Transfer(sender, recipient, tTransferAmount);
826     }
827 
828     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
829         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBuybackBurn, uint256 tMarketing) = _getValues(tAmount);
830         _tOwned[sender] = _tOwned[sender] - tAmount;
831         _rOwned[sender] = _rOwned[sender] - rAmount;
832         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount; 
833         _takeMarketing(tMarketing);  
834         _takeBuyback(tBuybackBurn);
835         _reflectFee(rFee, tFee);
836         emit Transfer(sender, recipient, tTransferAmount);
837     }
838 
839     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
840         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBuybackBurn, uint256 tMarketing) = _getValues(tAmount);
841         _tOwned[sender] = _tOwned[sender] - tAmount;
842         _rOwned[sender] = _rOwned[sender] - rAmount;
843         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
844         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
845         _takeMarketing(tMarketing);        
846         _takeBuyback(tBuybackBurn);
847         _reflectFee(rFee, tFee);
848         emit Transfer(sender, recipient, tTransferAmount);
849     }
850 
851     function excludeFromFees(address account, bool excluded) external onlyOwner {
852         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
853         _isExcludedFromFees[account] = excluded;
854 
855         emit ExcludeFromFees(account, excluded);
856     }
857     
858     function changeMarketingWallet(address _marketingWallet) external onlyOwner {
859         require(_marketingWallet != marketingWallet, "Marketing wallet is already that address");
860         require(_marketingWallet!=address(0), "Marketing wallet is the zero address");
861         marketingWallet = _marketingWallet;
862         emit MarketingWalletChanged(marketingWallet);
863     }
864 
865     function setBuyFeePercentages(uint256 _taxFeeonBuy, uint256 _buybackBurnFeeOnBuy, uint256 _marketingFeeonBuy) external onlyOwner {
866         taxFeeonBuy = _taxFeeonBuy;
867         buybackBurnFeeOnBuy = _buybackBurnFeeOnBuy;
868         marketingFeeonBuy = _marketingFeeonBuy;
869         totalBuyFees = _taxFeeonBuy + _buybackBurnFeeOnBuy + _marketingFeeonBuy;
870         require(totalBuyFees <= 10, "Buy fees cannot be greater than 10%");
871         emit BuyFeesChanged(taxFeeonBuy, buybackBurnFeeOnBuy, marketingFeeonBuy);
872     }
873 
874     function setSellFeePercentages(uint256 _taxFeeonSell, uint256 _buybackBurnFeeOnSell, uint256 _marketingFeeonSell) external onlyOwner {
875         taxFeeonSell = _taxFeeonSell;
876         buybackBurnFeeOnSell = _buybackBurnFeeOnSell;
877         marketingFeeonSell = _marketingFeeonSell;
878         totalSellFees = _taxFeeonSell + _buybackBurnFeeOnSell + _marketingFeeonSell;
879         require(totalSellFees <= 10, "Sell fees cannot be greater than 10%");
880         emit SellFeesChanged(taxFeeonSell, buybackBurnFeeOnSell, marketingFeeonSell);
881     }
882 
883     function enableWalletToWalletTransferWithoutFee(bool enable) external onlyOwner {
884         require(walletToWalletTransferWithoutFee != enable, "Wallet to wallet transfer without fee is already set to that value");
885         walletToWalletTransferWithoutFee = enable;
886         emit WalletToWalletTransferWithoutFeeEnabled(enable);
887     }
888 }