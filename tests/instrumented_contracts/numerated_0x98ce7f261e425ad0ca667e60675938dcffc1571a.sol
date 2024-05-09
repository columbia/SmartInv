1 /* *******************************************************************************************************************************************************************************
2 *
3 * Powered By t.me/BlazeXDeployerBot - This Contract is safe has no hidden malfunctions - Create your own Contract via telegram with blazex.org 
4 *
5 * Disclaimer: The @BlazeXDeployerBot tool assists users in contract deployment. Tokens or contracts initiated through this bot are solely under the user's responsibility and are * not linked to, endorsed by, or associated with the BlazeX Team. Users are urged to approach with caution and comprehend the outcomes of their deployments. The contract has been * reviewed and audited.
6 * TG BOT: t.me/BlazeXdeployerBot
7 *********************************************************************************************************************************************************************************
8 */
9 
10 
11   /*
12  * 
13   *
14   *——————————————————
15   *
16   * Description: M.A.N.E ($MANE)
17   * Website: www.themanetoken.com
18   * Twitter: https://x.com/TheManeToken?t=U_tUysM15S0NhXK93Cer6A&s=09
19   * Telegram: https://t.me/TheManeLionsDen
20   *
21   *—————
22   */
23   
24 
25 
26 // SPDX-License-Identifier: MIT
27 pragma solidity 0.8.17;
28 
29 
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address payable) {
32         return payable(msg.sender);
33     }
34 
35     function _msgData() internal view virtual returns (bytes memory) {
36         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
37         return msg.data;
38     }
39 }
40 
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     constructor () {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     function owner() public view returns (address) {
53         return _owner;
54     }
55 
56     modifier onlyOwner() {
57         require(_owner == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     function renounceOwnership() public virtual onlyOwner {
62         emit OwnershipTransferred(_owner, address(0));
63         _owner = address(0);
64     }
65 
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 }
72 
73 interface IERC20 {
74     function totalSupply() external view returns (uint256);
75     function balanceOf(address account) external view returns (uint256);
76     function transfer(address recipient, uint256 amount) external returns (bool);
77     function allowance(address owner, address spender) external view returns (uint256);
78     function approve(address spender, uint256 amount) external returns (bool);
79     function transferFrom(
80         address sender,
81         address recipient,
82         uint256 amount
83     ) external returns (bool);
84    
85     event Transfer(address indexed from, address indexed to, uint256 value);
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 library Address {
90     function isContract(address account) internal view returns (bool) {
91         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
92         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
93         // for accounts without code, i.e. `keccak256('')`
94         bytes32 codehash;
95         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
96         // solhint-disable-next-line no-inline-assembly
97         assembly { codehash := extcodehash(account) }
98         return (codehash != accountHash && codehash != 0x0);
99     }
100 
101     function sendValue(address payable recipient, uint256 amount) internal returns(bool){
102         require(address(this).balance >= amount, "Address: insufficient balance");
103 
104         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
105         (bool success, ) = recipient.call{ value: amount }("");
106         return success;
107     }
108 
109     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
110       return functionCall(target, data, "Address: low-level call failed");
111     }
112 
113     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
114         return _functionCallWithValue(target, data, 0, errorMessage);
115     }
116 
117     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
119     }
120 
121     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
122         require(address(this).balance >= value, "Address: insufficient balance for call");
123         return _functionCallWithValue(target, data, value, errorMessage);
124     }
125 
126     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
127         require(isContract(target), "Address: call to non-contract");
128 
129         // solhint-disable-next-line avoid-low-level-calls
130         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
131         if (success) {
132             return returndata;
133         } else {
134             // Look for revert reason and bubble it up if present
135             if (returndata.length > 0) {
136                 // The easiest way to bubble the revert reason is using memory via assembly
137 
138                 // solhint-disable-next-line no-inline-assembly
139                 assembly {
140                     let returndata_size := mload(returndata)
141                     revert(add(32, returndata), returndata_size)
142                 }
143             } else {
144                 revert(errorMessage);
145             }
146         }
147     }
148 }
149 
150 interface IUniswapV2Factory {
151     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
152 
153     function feeTo() external view returns (address);
154     function feeToSetter() external view returns (address);
155 
156     function getPair(address tokenA, address tokenB) external view returns (address pair);
157     function allPairs(uint) external view returns (address pair);
158     function allPairsLength() external view returns (uint);
159 
160     function createPair(address tokenA, address tokenB) external returns (address pair);
161 
162     function setFeeTo(address) external;
163     function setFeeToSetter(address) external;
164 }
165 
166 interface IUniswapV2Pair {
167     event Approval(address indexed owner, address indexed spender, uint value);
168     event Transfer(address indexed from, address indexed to, uint value);
169 
170     function name() external pure returns (string memory);
171     function symbol() external pure returns (string memory);
172     function decimals() external pure returns (uint8);
173     function totalSupply() external view returns (uint);
174     function balanceOf(address owner) external view returns (uint);
175     function allowance(address owner, address spender) external view returns (uint);
176 
177     function approve(address spender, uint value) external returns (bool);
178     function transfer(address to, uint value) external returns (bool);
179     function transferFrom(address from, address to, uint value) external returns (bool);
180 
181     function DOMAIN_SEPARATOR() external view returns (bytes32);
182     function PERMIT_TYPEHASH() external pure returns (bytes32);
183     function nonces(address owner) external view returns (uint);
184 
185     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
186 
187     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
188     event Swap(
189         address indexed sender,
190         uint amount0In,
191         uint amount1In,
192         uint amount0Out,
193         uint amount1Out,
194         address indexed to
195     );
196     event Sync(uint112 reserve0, uint112 reserve1);
197 
198     function MINIMUM_LIQUIDITY() external pure returns (uint);
199     function factory() external view returns (address);
200     function token0() external view returns (address);
201     function token1() external view returns (address);
202     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
203     function price0CumulativeLast() external view returns (uint);
204     function price1CumulativeLast() external view returns (uint);
205     function kLast() external view returns (uint);
206 
207     function burn(address to) external returns (uint amount0, uint amount1);
208     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
209     function skim(address to) external;
210     function sync() external;
211 
212     function initialize(address, address) external;
213 }
214 
215 interface IUniswapV2Router01 {
216     function factory() external pure returns (address);
217     function WETH() external pure returns (address);
218 
219     function addLiquidity(
220         address tokenA,
221         address tokenB,
222         uint amountADesired,
223         uint amountBDesired,
224         uint amountAMin,
225         uint amountBMin,
226         address to,
227         uint deadline
228     ) external returns (uint amountA, uint amountB, uint liquidity);
229     function addLiquidityETH(
230         address token,
231         uint amountTokenDesired,
232         uint amountTokenMin,
233         uint amountETHMin,
234         address to,
235         uint deadline
236     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
237     function removeLiquidity(
238         address tokenA,
239         address tokenB,
240         uint liquidity,
241         uint amountAMin,
242         uint amountBMin,
243         address to,
244         uint deadline
245     ) external returns (uint amountA, uint amountB);
246     function removeLiquidityETH(
247         address token,
248         uint liquidity,
249         uint amountTokenMin,
250         uint amountETHMin,
251         address to,
252         uint deadline
253     ) external returns (uint amountToken, uint amountETH);
254     function removeLiquidityWithPermit(
255         address tokenA,
256         address tokenB,
257         uint liquidity,
258         uint amountAMin,
259         uint amountBMin,
260         address to,
261         uint deadline,
262         bool approveMax, uint8 v, bytes32 r, bytes32 s
263     ) external returns (uint amountA, uint amountB);
264     function removeLiquidityETHWithPermit(
265         address token,
266         uint liquidity,
267         uint amountTokenMin,
268         uint amountETHMin,
269         address to,
270         uint deadline,
271         bool approveMax, uint8 v, bytes32 r, bytes32 s
272     ) external returns (uint amountToken, uint amountETH);
273     function swapExactTokensForTokens(
274         uint amountIn,
275         uint amountOutMin,
276         address[] calldata path,
277         address to,
278         uint deadline
279     ) external returns (uint[] memory amounts);
280     function swapTokensForExactTokens(
281         uint amountOut,
282         uint amountInMax,
283         address[] calldata path,
284         address to,
285         uint deadline
286     ) external returns (uint[] memory amounts);
287     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
288         external
289         payable
290         returns (uint[] memory amounts);
291     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
292         external
293         returns (uint[] memory amounts);
294     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
295         external
296         returns (uint[] memory amounts);
297     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
298         external
299         payable
300         returns (uint[] memory amounts);
301 
302     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
303     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
304     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
305     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
306     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
307 }
308 
309 interface IUniswapV2Router02 is IUniswapV2Router01 {
310     function removeLiquidityETHSupportingFeeOnTransferTokens(
311         address token,
312         uint liquidity,
313         uint amountTokenMin,
314         uint amountETHMin,
315         address to,
316         uint deadline
317     ) external returns (uint amountETH);
318     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
319         address token,
320         uint liquidity,
321         uint amountTokenMin,
322         uint amountETHMin,
323         address to,
324         uint deadline,
325         bool approveMax, uint8 v, bytes32 r, bytes32 s
326     ) external returns (uint amountETH);
327 
328     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
329         uint amountIn,
330         uint amountOutMin,
331         address[] calldata path,
332         address to,
333         uint deadline
334     ) external;
335     function swapExactETHForTokensSupportingFeeOnTransferTokens(
336         uint amountOutMin,
337         address[] calldata path,
338         address to,
339         uint deadline
340     ) external payable;
341     function swapExactTokensForETHSupportingFeeOnTransferTokens(
342         uint amountIn,
343         uint amountOutMin,
344         address[] calldata path,
345         address to,
346         uint deadline
347     ) external;
348 }
349 
350 contract CustomToken is Context, IERC20, Ownable {
351     using Address for address;
352     using Address for address payable;
353 
354     mapping (address => uint256) private _rOwned;
355     mapping (address => uint256) private _tOwned;
356     mapping (address => mapping (address => uint256)) private _allowances;
357 
358     mapping (address => bool) private _isExcludedFromFees;
359     mapping (address => bool) private _isExcluded;
360     address[] private _excluded;
361 
362     string private _name="MANE";
363     string private _symbol="MANE";
364     uint8  private _decimals=18;
365    
366     uint256 private constant MAX = type(uint256).max;
367     uint256 private _tTotal = 100000000000000000000000000;
368     uint256 private _tTotalSupply = 100000000000000000000000000;
369     uint256 private _rTotal = (MAX - (MAX % _tTotal));
370     uint256 private _tFeeTotal;
371 
372     uint public ReflectionFeeonBuy=0;
373     uint public ReflectionFeeonSell=0;
374 
375     uint public liquidityFeeonBuy=0;
376     uint public liquidityFeeonSell=0;
377 
378     uint public marketingFeeonBuy=30;
379     uint public marketingFeeonSell=30;
380 
381     uint public burnFeeOnBuy=10;
382     uint public burnFeeOnSell=10;
383 
384     uint private _ReflectionFee;
385     uint private _liquidityFee;
386     uint private _marketingFee;
387 
388     uint256 private totalBuyFees;
389     uint256 private totalSellFees;
390 
391     address public marketingWallet=0xE3feB50cFefd2F2901987fbE1d5a000654cab62b;
392     
393     address public referralWallet;
394     uint256 public serviceFee;
395     uint256 public referralCommission;
396 
397     uint256 public maxTransactionAmountBuy=500000000000000000000000;
398     uint256 public maxTransactionAmountSell=500000000000000000000000;
399 
400     
401     uint256 public maxWalletAmount=1000000000000000000000000;
402 
403     bool public walletToWalletTransferWithoutFee;
404     
405     address private DEAD = 0x000000000000000000000000000000000000dEaD;
406 
407     IUniswapV2Router02 public  uniswapV2Router;
408     address public  uniswapV2Pair;
409 
410     bool private inSwapAndLiquify;
411     bool public swapEnabled;
412     bool public tradingEnabled;
413     uint256 public swapTokensAtAmount=10000000000000000000000;
414 
415     address public lpPair;
416 
417     event ExcludeFromFees(address indexed account, bool isExcluded);
418     event MarketingWalletChanged(address marketingWallet);
419     event SwapEnabledUpdated(bool enabled);
420     event SwapAndLiquify(uint256 tokensSwapped, uint256 bnbReceived, uint256 tokensIntoLiqudity);
421     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);
422     event SwapTokensAtAmountUpdated(uint256 amount);
423     event BuyFeesChanged(uint256 ReflectionFee, uint256 liquidityFee, uint256 marketingFee);
424     event SellFeesChanged(uint256 ReflectionFee, uint256 liquidityFee, uint256 marketingFee);
425     event WalletToWalletTransferWithoutFeeEnabled(bool enabled);
426     
427     constructor() 
428         payable
429     {        
430         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
431     require(msg.value >= 0.05 ether, "Insufficient value for fee receiver");
432     
433         referralCommission = 0.02500000000000000 ether;
434         referralWallet = 0xdD02F7Cd47Ef1b70B386d948152b13Fc09640895;
435         payable(referralWallet).transfer(referralCommission);
436       
437     
438     serviceFee = 0.02500000000000000 ether;
439     payable(0x72460072CCC5DB06559dd6e970dFD2Cb06ee7876).transfer(serviceFee);
440     
441 
442         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
443         
444         uniswapV2Router = _uniswapV2Router;
445 
446         _approve(msg.sender, address(uniswapV2Router), MAX);
447         _approve(msg.sender, address(this), MAX);
448 
449         totalBuyFees = ReflectionFeeonBuy + liquidityFeeonBuy + marketingFeeonBuy + burnFeeOnBuy;
450         totalSellFees = ReflectionFeeonSell + liquidityFeeonSell + marketingFeeonSell + burnFeeOnSell;
451         
452         swapTokensAtAmount = _tTotal / 5000;
453 
454         maxTransactionLimitEnabled  = true;
455 
456 
457 
458         _isExcludedFromMaxTxLimit[owner()] = true;
459         _isExcludedFromMaxTxLimit[address(0)] = true;
460         _isExcludedFromMaxTxLimit[address(this)] = true;
461         _isExcludedFromMaxTxLimit[marketingWallet] = true;
462         _isExcludedFromMaxTxLimit[DEAD] = true;
463 
464         maxWalletLimitEnabled = true;
465 
466         _isExcludedFromMaxWalletLimit[owner()] = true;
467         _isExcludedFromMaxWalletLimit[address(this)] = true;
468         _isExcludedFromMaxWalletLimit[address(0xdead)] = true;
469         _isExcludedFromMaxWalletLimit[marketingWallet] = true;        
470     
471         walletToWalletTransferWithoutFee = true;
472         
473         _isExcludedFromFees[owner()] = true;
474         _isExcludedFromFees[address(0xdead)] = true;
475         _isExcludedFromFees[address(this)] = true;
476 
477         _isExcluded[address(this)] = true;        
478         _isExcluded[address(0xdead)] = true;
479         _isExcluded[address(uniswapV2Pair)] = true;
480 
481         _rOwned[owner()] = _rTotal;
482         _tOwned[owner()] = _tTotal;
483 
484 
485         emit Transfer(address(0), owner(), _tTotal);
486     }
487 
488     function createLPPairIfRequired() private {
489         IUniswapV2Factory factory = IUniswapV2Factory(uniswapV2Router.factory());
490         address pair = factory.getPair(address(this), uniswapV2Router.WETH());
491 		if(pair == address(0)) {
492 			uniswapV2Pair = factory.createPair(address(this), uniswapV2Router.WETH());
493 			lpPair = uniswapV2Pair;
494 			_isExcluded[address(uniswapV2Pair)] = true;
495 		}
496         else {
497             if(uniswapV2Pair != pair){
498                 uniswapV2Pair = pair;
499                 lpPair = uniswapV2Pair;
500                 _isExcluded[address(uniswapV2Pair)] = true;
501             }
502         }
503 	}
504 
505     function addLiquidityETH(uint256 _tokenAmount) public payable returns(bool) {
506 		swapEnabled = false;
507 		createLPPairIfRequired();
508         _transfer(msg.sender, address(this), _tokenAmount);
509         _approve(address(this), address(uniswapV2Router), MAX);
510         uniswapV2Router.addLiquidityETH{value: msg.value}(address(this), _tokenAmount, 0, 0, address(msg.sender), block.timestamp + 50);
511         swapEnabled = true;
512         return true;
513 	}
514 
515     function name() public view returns (string memory) {
516         return _name;
517     }
518 
519     function symbol() public view returns (string memory) {
520         return _symbol;
521     }
522 
523     function decimals() public view returns (uint8) {
524         return _decimals;
525     }
526 
527     function totalSupply() public view override returns (uint256) {
528         return _tTotalSupply;
529     }
530 
531     function balanceOf(address account) public view override returns (uint256) {
532         if (_isExcluded[account]) return _tOwned[account];
533         return tokenFromReflection(_rOwned[account]);
534     }
535 
536     function transfer(address recipient, uint256 amount) public override returns (bool) {
537         _transfer(_msgSender(), recipient, amount);
538         return true;
539     }
540 
541     function allowance(address owner, address spender) public view override returns (uint256) {
542         return _allowances[owner][spender];
543     }
544 
545     function approve(address spender, uint256 amount) public override returns (bool) {
546         _approve(_msgSender(), spender, amount);
547         return true;
548     }
549 
550     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
551         _transfer(sender, recipient, amount);
552         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
553         return true;
554     }
555 
556     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
557         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
558         return true;
559     }
560 
561     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
562         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
563         return true;
564     }
565 
566     function isExcludedFromReward(address account) public view returns (bool) {
567         return _isExcluded[account];
568     }
569 
570     function totalReflectionDistributed() public view returns (uint256) {
571         return _tFeeTotal;
572     }
573 
574     function deliver(uint256 tAmount) public {
575         address sender = _msgSender();
576         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
577         (uint256 rAmount,,,,,,) = _getValues(tAmount);
578         _rOwned[sender] = _rOwned[sender] - rAmount;
579         _rTotal = _rTotal - rAmount;
580         _tFeeTotal = _tFeeTotal + tAmount;
581     }
582 
583     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
584         require(tAmount <= _tTotal, "Amount must be less than supply");
585         if (!deductTransferFee) {
586             (uint256 rAmount,,,,,,) = _getValues(tAmount);
587             return rAmount;
588         } else {
589             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
590             return rTransferAmount;
591         }
592     }
593 
594     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
595         require(rAmount <= _rTotal, "Amount must be less than total reflections");
596         uint256 currentRate =  _getRate();
597         return rAmount / currentRate;
598     }
599 
600     function excludeFromReward(address account) public onlyOwner() {
601         require(!_isExcluded[account], "Account is already excluded");
602         if(_rOwned[account] > 0) {
603             _tOwned[account] = tokenFromReflection(_rOwned[account]);
604         }
605         _isExcluded[account] = true;
606         _excluded.push(account);
607     }
608 
609     function includeInReward(address account) external onlyOwner() {
610         require(_isExcluded[account], "Account is already included");
611         for (uint256 i = 0; i < _excluded.length; i++) {
612             if (_excluded[i] == account) {
613                 _excluded[i] = _excluded[_excluded.length - 1];
614                 _tOwned[account] = 0;
615                 _isExcluded[account] = false;
616                 _excluded.pop();
617                 break;
618             }
619         }
620     }
621 
622     receive() external payable {}
623 
624     function claimStuckTokens(address token) external onlyOwner {
625         require(token != address(this), "Owner cannot claim native tokens");
626         if (token == address(0x0)) {
627             payable(msg.sender).sendValue(address(this).balance);
628             return;
629         }
630         IERC20 ERC20token = IERC20(token);
631         uint256 balance = ERC20token.balanceOf(address(this));
632         ERC20token.transfer(msg.sender, balance);
633     }
634 
635     function _reflectFee(uint256 rFee, uint256 tFee) private {
636         _rTotal = _rTotal - rFee;
637         _tFeeTotal = _tFeeTotal + tFee;
638     }
639 
640     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
641         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getTValues(tAmount);
642         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, _getRate());
643         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tMarketing);
644     }
645 
646     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
647         uint256 tFee = calculateReflectionFee(tAmount);
648         uint256 tLiquidity = calculateLiquidityFee(tAmount);
649         uint256 tMarketing = calculateMarketingFee(tAmount);
650         uint256 tTransferAmount = tAmount - tFee - tLiquidity - tMarketing;
651         return (tTransferAmount, tFee, tLiquidity, tMarketing);
652     }
653 
654     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
655         uint256 rAmount = tAmount * currentRate;
656         uint256 rFee = tFee * currentRate;
657         uint256 rLiquidity = tLiquidity * currentRate;
658         uint256 rMarketing = tMarketing * currentRate;
659         uint256 rTransferAmount = rAmount - rFee - rLiquidity - rMarketing;
660         return (rAmount, rTransferAmount, rFee);
661     }
662 
663     function _getRate() private view returns(uint256) {
664         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
665         return rSupply / tSupply;
666     }
667 
668     function _getCurrentSupply() private view returns(uint256, uint256) {
669         uint256 rSupply = _rTotal;
670         uint256 tSupply = _tTotal;      
671         for (uint256 i = 0; i < _excluded.length; i++) {
672             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
673             rSupply = rSupply - _rOwned[_excluded[i]];
674             tSupply = tSupply - _tOwned[_excluded[i]];
675         }
676         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
677         return (rSupply, tSupply);
678     }
679     
680     function _takeLiquidity(uint256 tLiquidity) private {
681         uint256 liquidityAmount;
682         if(liquidityFeeonBuy > 0 || liquidityFeeonSell > 0 || burnFeeOnBuy > 0 || burnFeeOnSell > 0){
683             liquidityAmount = tLiquidity * (liquidityFeeonBuy + liquidityFeeonSell) / (liquidityFeeonBuy + liquidityFeeonSell + burnFeeOnBuy + burnFeeOnSell);
684         }
685         uint256 burnAmount = tLiquidity - liquidityAmount;
686 
687         if(liquidityAmount > 0){
688             uint256 currentRate =  _getRate();
689             uint256 rLiquidity = liquidityAmount * currentRate;
690             _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
691             if(_isExcluded[address(this)])
692                 _tOwned[address(this)] = _tOwned[address(this)] + liquidityAmount;
693         }
694 
695         if(burnAmount > 0){
696             uint256 currentRate =  _getRate();
697             uint256 rBurn = burnAmount * currentRate;
698             _rOwned[address(0xdead)] = _rOwned[address(0xdead)] + rBurn;
699             if(_isExcluded[address(0xdead)])
700                 _tOwned[address(0xdead)] = _tOwned[address(0xdead)] + burnAmount;
701 
702             _tTotalSupply -= burnAmount;
703         }
704     }
705 
706     function _takeMarketing(uint256 tMarketing) private {
707         if (tMarketing > 0) {
708             uint256 currentRate =  _getRate();
709             uint256 rMarketing = tMarketing * currentRate;
710             _rOwned[address(this)] = _rOwned[address(this)] + rMarketing;
711             if(_isExcluded[address(this)])
712                 _tOwned[address(this)] = _tOwned[address(this)] + tMarketing;
713         }
714     }
715     
716     function calculateReflectionFee(uint256 _amount) private view returns (uint256) {
717         return _amount * _ReflectionFee / 1000;
718     }
719 
720     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
721         return _amount * _liquidityFee / 1000;
722     }
723     
724     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
725         return _amount * _marketingFee / 1000;
726     }
727     
728     function removeAllFee() private {
729         if(_ReflectionFee == 0 && _liquidityFee == 0 && _marketingFee == 0) return;
730         
731         _ReflectionFee = 0;
732         _marketingFee = 0;
733         _liquidityFee = 0;
734     }
735     
736     function setBuyFee() private{
737         if(_ReflectionFee == ReflectionFeeonBuy && _liquidityFee == (liquidityFeeonBuy + burnFeeOnBuy) && _marketingFee == marketingFeeonBuy ) return;
738 
739         _ReflectionFee = ReflectionFeeonBuy;
740         _marketingFee = marketingFeeonBuy;
741         _liquidityFee = liquidityFeeonBuy + burnFeeOnBuy;
742     }
743 
744     function setSellFee() private{
745         if(_ReflectionFee == ReflectionFeeonSell && _liquidityFee == (liquidityFeeonSell + burnFeeOnSell) && _marketingFee == marketingFeeonSell ) return;
746 
747         _ReflectionFee = ReflectionFeeonSell;
748         _marketingFee = marketingFeeonSell;
749         _liquidityFee = liquidityFeeonSell + burnFeeOnSell;
750     }
751     
752     function isExcludedFromFee(address account) public view returns(bool) {
753         return _isExcludedFromFees[account];
754     }
755 
756     function _approve(address owner, address spender, uint256 amount) private {
757         require(owner != address(0), "ERC20: approve from the zero address");
758         require(spender != address(0), "ERC20: approve to the zero address");
759 
760         _allowances[owner][spender] = amount;
761         emit Approval(owner, spender, amount);
762     }
763 
764     function enableTrading() external onlyOwner{
765         require(tradingEnabled == false, "Trading is already enabled");
766         tradingEnabled = true;
767     }
768     
769     function _transfer(
770         address from,
771         address to,
772         uint256 amount
773     ) private {
774         require(from != address(0), "ERC20: transfer from the zero address");
775         require(amount > 0, "Transfer amount must be greater than zero");
776 
777         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
778             require(tradingEnabled, "Trading is not enabled yet");
779         }
780 
781         if (maxTransactionLimitEnabled) 
782         {
783             if ((from == uniswapV2Pair || to == uniswapV2Pair) &&
784                 _isExcludedFromMaxTxLimit[from] == false && 
785                 _isExcludedFromMaxTxLimit[to]   == false) 
786             {
787                 if (from == uniswapV2Pair) {
788                     require(
789                         amount <= maxTransactionAmountBuy,  
790                         "AntiWhale: Transfer amount exceeds the maxTransactionAmount"
791                     );
792                 } else {
793                     require(
794                         amount <= maxTransactionAmountSell, 
795                         "AntiWhale: Transfer amount exceeds the maxTransactionAmount"
796                     );
797                 }
798             }
799         }
800 
801         uint256 contractTokenBalance = balanceOf(address(this));        
802         bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;
803         if (
804             overMinTokenBalance &&
805             !inSwapAndLiquify &&
806             to == uniswapV2Pair &&
807             swapEnabled
808         ) {
809             inSwapAndLiquify = true;
810             
811             uint256 marketingShare = marketingFeeonBuy + marketingFeeonSell;
812             uint256 liquidityShare = liquidityFeeonBuy + liquidityFeeonSell;
813 
814             uint256 totalShare = marketingShare + liquidityShare;
815 
816             if(totalShare > 0) {
817                 if(liquidityShare > 0) {
818                     uint256 liquidityTokens = (contractTokenBalance * liquidityShare) / totalShare;
819                     swapAndLiquify(liquidityTokens);
820                 }
821                 
822                 if(marketingShare > 0) {
823                     uint256 marketingTokens = (contractTokenBalance * marketingShare) / totalShare;
824                     swapAndSendMarketing(marketingTokens);
825                 } 
826             }
827 
828             inSwapAndLiquify = false;
829         }
830         
831         //transfer amount, it will take tax, burn, liquidity fee
832         _tokenTransfer(from,to,amount);
833 
834         if (maxWalletLimitEnabled) 
835         {
836             if (!_isExcludedFromMaxWalletLimit[from] && 
837                 !_isExcludedFromMaxWalletLimit[to] &&
838                 to != uniswapV2Pair
839             ) {
840                 uint256 balance  = balanceOf(to);
841                 require(
842                     balance + amount <= maxWalletAmount, 
843                     "MaxWallet: Recipient exceeds the maxWalletAmount"
844                 );
845             }
846         }
847     }
848 
849     function swapAndLiquify(uint256 tokens) private {
850         uint256 half = tokens / 2;
851         uint256 otherHalf = tokens - half;
852 
853         uint256 initialBalance = address(this).balance;
854 
855         address[] memory path = new address[](2);
856         path[0] = address(this);
857         path[1] = uniswapV2Router.WETH();
858 
859         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
860             half,
861             0, // accept any amount of ETH
862             path,
863             address(this),
864             block.timestamp);
865         
866         uint256 newBalance = address(this).balance - initialBalance;
867 
868         uniswapV2Router.addLiquidityETH{value: newBalance}(
869             address(this),
870             otherHalf,
871             0, // slippage is unavoidable
872             0, // slippage is unavoidable
873             DEAD,
874             block.timestamp
875         );
876 
877         emit SwapAndLiquify(half, newBalance, otherHalf);
878     }
879 
880     function swapAndSendMarketing(uint256 tokenAmount) private {
881         uint256 initialBalance = address(this).balance;
882 
883         address[] memory path = new address[](2);
884         path[0] = address(this);
885         path[1] = uniswapV2Router.WETH();
886 
887         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
888             tokenAmount,
889             0, // accept any amount of ETH
890             path,
891             address(this),
892             block.timestamp);
893 
894         uint256 newBalance = address(this).balance - initialBalance;
895 
896         payable(marketingWallet).sendValue(newBalance);
897 
898         emit SwapAndSendMarketing(tokenAmount, newBalance);
899     }
900 
901     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner() {
902         require(newAmount > totalSupply() / 1e5, "SwapTokensAtAmount must be greater than 0.001% of total supply");
903         swapTokensAtAmount = newAmount;
904         emit SwapTokensAtAmountUpdated(newAmount);
905     }
906     
907     function setSwapEnabled(bool _enabled) external onlyOwner {
908         swapEnabled = _enabled;
909         emit SwapEnabledUpdated(_enabled);
910     }
911 
912     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
913          if (_isExcludedFromFees[sender] || 
914             _isExcludedFromFees[recipient] 
915             ) {
916             removeAllFee();
917         }else if(recipient == uniswapV2Pair){
918             setSellFee();
919         }else if(sender == uniswapV2Pair){
920             setBuyFee();
921         }else if(walletToWalletTransferWithoutFee){
922             removeAllFee();
923         }else{
924             setSellFee();
925         }
926 
927         if (_isExcluded[sender] && !_isExcluded[recipient]) {
928             _transferFromExcluded(sender, recipient, amount);
929         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
930             _transferToExcluded(sender, recipient, amount);
931         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
932             _transferStandard(sender, recipient, amount);
933         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
934             _transferBothExcluded(sender, recipient, amount);
935         } else {
936             _transferStandard(sender, recipient, amount);
937         }
938     }
939 
940     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
941         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
942         _rOwned[sender] = _rOwned[sender] - rAmount;
943         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
944         _takeMarketing(tMarketing);
945         _takeLiquidity(tLiquidity);
946         _reflectFee(rFee, tFee);
947         emit Transfer(sender, recipient, tTransferAmount);
948     }
949 
950     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
951         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
952         _rOwned[sender] = _rOwned[sender] - rAmount;
953         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
954         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
955         _takeMarketing(tMarketing);           
956         _takeLiquidity(tLiquidity);
957         _reflectFee(rFee, tFee);
958         emit Transfer(sender, recipient, tTransferAmount);
959     }
960 
961     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
962         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
963         _tOwned[sender] = _tOwned[sender] - tAmount;
964         _rOwned[sender] = _rOwned[sender] - rAmount;
965         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount; 
966         _takeMarketing(tMarketing);  
967         _takeLiquidity(tLiquidity);
968         _reflectFee(rFee, tFee);
969         emit Transfer(sender, recipient, tTransferAmount);
970     }
971 
972     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
973         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
974         _tOwned[sender] = _tOwned[sender] - tAmount;
975         _rOwned[sender] = _rOwned[sender] - rAmount;
976         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
977         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
978         _takeMarketing(tMarketing);        
979         _takeLiquidity(tLiquidity);
980         _reflectFee(rFee, tFee);
981         emit Transfer(sender, recipient, tTransferAmount);
982     }
983 
984     function excludeFromFees(address account, bool excluded) external onlyOwner {
985         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
986         _isExcludedFromFees[account] = excluded;
987 
988         emit ExcludeFromFees(account, excluded);
989     }
990     
991     function changeMarketingWallet(address _marketingWallet) external onlyOwner {
992         require(_marketingWallet != marketingWallet, "Marketing wallet is already that address");
993         require(_marketingWallet!=address(0), "Marketing wallet is the zero address");
994         marketingWallet = _marketingWallet;
995         emit MarketingWalletChanged(marketingWallet);
996     }
997 
998     function setBuyFeePercentages(uint _ReflectionFeeonBuy, uint _liquidityFeeonBuy, uint _marketingFeeonBuy, uint _burnFeeOnBuy) external onlyOwner {
999         ReflectionFeeonBuy = _ReflectionFeeonBuy;
1000         liquidityFeeonBuy = _liquidityFeeonBuy;
1001         marketingFeeonBuy = _marketingFeeonBuy;
1002         burnFeeOnBuy = _burnFeeOnBuy;
1003 
1004         totalBuyFees = ReflectionFeeonBuy + liquidityFeeonBuy + marketingFeeonBuy + burnFeeOnBuy;
1005 
1006         require(totalBuyFees <= 300, "Buy fees cannot be greater than 30%");
1007 
1008         emit BuyFeesChanged(ReflectionFeeonBuy, liquidityFeeonBuy, marketingFeeonBuy);
1009     }
1010 
1011     function setSellFeePercentages(uint _ReflectionFeeonSell, uint _liquidityFeeonSell, uint _marketingFeeonSell, uint _burnFeeOnSell) external onlyOwner {
1012         ReflectionFeeonSell = _ReflectionFeeonSell;
1013         liquidityFeeonSell = _liquidityFeeonSell;
1014         marketingFeeonSell = _marketingFeeonSell;
1015         burnFeeOnSell = _burnFeeOnSell;
1016 
1017         totalSellFees = ReflectionFeeonSell + liquidityFeeonSell + marketingFeeonSell + burnFeeOnSell;
1018 
1019         require(totalSellFees <= 300, "Sell fees cannot be greater than 30%");
1020 
1021         emit SellFeesChanged(ReflectionFeeonSell, liquidityFeeonSell, marketingFeeonSell);
1022     }
1023 
1024     function enableWalletToWalletTransferWithoutFee(bool enable) external onlyOwner {
1025         require(walletToWalletTransferWithoutFee != enable, "Wallet to wallet transfer without fee is already set to that value");
1026         walletToWalletTransferWithoutFee = enable;
1027         emit WalletToWalletTransferWithoutFeeEnabled(enable);
1028     }
1029 
1030     mapping(address => bool) private _isExcludedFromMaxTxLimit;
1031     bool    public  maxTransactionLimitEnabled;
1032 
1033     event ExcludedFromMaxTransactionLimit(address indexed account, bool isExcluded);
1034     event MaxTransactionLimitStateChanged(bool maxTransactionLimit);
1035     event MaxTransactionLimitAmountChanged(uint256 maxTransactionAmountBuy, uint256 maxTransactionAmountSell);
1036 
1037     function setEnableMaxTransactionLimit(bool enable) external onlyOwner {
1038         require(
1039             enable != maxTransactionLimitEnabled, 
1040             "Max transaction limit is already set to that state"
1041         );
1042         maxTransactionLimitEnabled = enable;
1043         emit MaxTransactionLimitStateChanged(maxTransactionLimitEnabled);
1044     }
1045 
1046     function setMaxTransactionAmounts(uint256 _maxTransactionAmountBuy, uint256 _maxTransactionAmountSell) external onlyOwner {
1047         require(
1048             _maxTransactionAmountBuy  >= totalSupply() / (10 ** decimals()) / 1000 && 
1049             _maxTransactionAmountSell >= totalSupply() / (10 ** decimals()) / 1000, 
1050             "Max Transaction limis cannot be lower than 0.1% of total supply"
1051         ); 
1052         maxTransactionAmountBuy  = _maxTransactionAmountBuy  * (10 ** decimals());
1053         maxTransactionAmountSell = _maxTransactionAmountSell * (10 ** decimals());
1054         emit MaxTransactionLimitAmountChanged(maxTransactionAmountBuy, maxTransactionAmountSell);
1055     }
1056 
1057     function setExcludeFromMaxTransactionLimit(address account, bool exclude) external onlyOwner {
1058         require(
1059             _isExcludedFromMaxTxLimit[account] != exclude, 
1060             "Account is already set to that state"
1061         );
1062         _isExcludedFromMaxTxLimit[account] = exclude;
1063         emit ExcludedFromMaxTransactionLimit(account, exclude);
1064     }
1065 
1066     function isExcludedFromMaxTransaction(address account) public view returns(bool) {
1067         return _isExcludedFromMaxTxLimit[account];
1068     }
1069 
1070     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
1071     bool public maxWalletLimitEnabled;
1072 
1073     event ExcludedFromMaxWalletLimit(address indexed account, bool isExcluded);
1074     event MaxWalletLimitStateChanged(bool maxWalletLimit);
1075     event MaxWalletLimitAmountChanged(uint256 maxWalletAmount);
1076 
1077     function setEnableMaxWalletLimit(bool enable) external onlyOwner {
1078         require(enable != maxWalletLimitEnabled,"Max wallet limit is already set to that state");
1079         maxWalletLimitEnabled = enable;
1080 
1081         emit MaxWalletLimitStateChanged(maxWalletLimitEnabled);
1082     }
1083 
1084     function setMaxWalletAmount(uint256 _maxWalletAmount) external onlyOwner {
1085         require(_maxWalletAmount >= (totalSupply() / (10 ** decimals())) / 100, "Max wallet percentage cannot be lower than 1%");
1086         maxWalletAmount = _maxWalletAmount * (10 ** decimals());
1087 
1088         emit MaxWalletLimitAmountChanged(maxWalletAmount);
1089     }
1090 
1091     function excludeFromMaxWallet(address account, bool exclude) external onlyOwner {
1092         require( _isExcludedFromMaxWalletLimit[account] != exclude,"Account is already set to that state");
1093         require(account != address(this), "Can't set this address.");
1094 
1095         _isExcludedFromMaxWalletLimit[account] = exclude;
1096 
1097         emit ExcludedFromMaxWalletLimit(account, exclude);
1098     }
1099 
1100     function isExcludedFromMaxWalletLimit(address account) public view returns(bool) {
1101         return _isExcludedFromMaxWalletLimit[account];
1102     }
1103 
1104     function contractTypeBlazex() external pure returns(uint){
1105         return 2;
1106     }
1107 }
