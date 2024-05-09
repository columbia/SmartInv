1 /**
2 
3 Official Coin of Matrix Inu
4 
5 Website: http://ethmatrixinu.com/
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.4;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address payable) {
14         return payable(msg.sender);
15     }
16 
17     function _msgData() internal view virtual returns (bytes memory) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 
24 interface IERC20 {
25 
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34     
35 
36 }
37 
38 library SafeMath {
39 
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43 
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
54 
55         return c;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         if (a == 0) {
60             return 0;
61         }
62 
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65 
66         return c;
67     }
68 
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         return div(a, b, "SafeMath: division by zero");
72     }
73 
74     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b > 0, errorMessage);
76         uint256 c = a / b;
77         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78 
79         return c;
80     }
81 
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         return mod(a, b, "SafeMath: modulo by zero");
84     }
85 
86     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b != 0, errorMessage);
88         return a % b;
89     }
90 }
91 
92 library Address {
93 
94     function isContract(address account) internal view returns (bool) {
95         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
96         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
97         // for accounts without code, i.e. `keccak256('')`
98         bytes32 codehash;
99         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
100         // solhint-disable-next-line no-inline-assembly
101         assembly { codehash := extcodehash(account) }
102         return (codehash != accountHash && codehash != 0x0);
103     }
104 
105     function sendValue(address payable recipient, uint256 amount) internal {
106         require(address(this).balance >= amount, "Address: insufficient balance");
107 
108         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
109         (bool success, ) = recipient.call{ value: amount }("");
110         require(success, "Address: unable to send value, recipient may have reverted");
111     }
112 
113 
114     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
115       return functionCall(target, data, "Address: low-level call failed");
116     }
117 
118     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
119         return _functionCallWithValue(target, data, 0, errorMessage);
120     }
121 
122     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
127         require(address(this).balance >= value, "Address: insufficient balance for call");
128         return _functionCallWithValue(target, data, value, errorMessage);
129     }
130 
131     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
132         require(isContract(target), "Address: call to non-contract");
133 
134         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
135         if (success) {
136             return returndata;
137         } else {
138             
139             if (returndata.length > 0) {
140                 assembly {
141                     let returndata_size := mload(returndata)
142                     revert(add(32, returndata), returndata_size)
143                 }
144             } else {
145                 revert(errorMessage);
146             }
147         }
148     }
149 }
150 
151 contract Ownable is Context {
152     address private _owner;
153     address private _previousOwner;
154     uint256 private _lockTime;
155 
156     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
157 
158     constructor () {
159         address msgSender = _msgSender();
160         _owner = msgSender;
161         emit OwnershipTransferred(address(0), msgSender);
162     }
163 
164     function owner() public view returns (address) {
165         return _owner;
166     }   
167     
168     modifier onlyOwner() {
169         require(_owner == _msgSender(), "Ownable: caller is not the owner");
170         _;
171     }
172     
173     function renounceOwnership() public virtual onlyOwner {
174         emit OwnershipTransferred(_owner, address(0));
175         _owner = address(0);
176     }
177 
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(newOwner != address(0), "Ownable: new owner is the zero address");
180         emit OwnershipTransferred(_owner, newOwner);
181         _owner = newOwner;
182     }
183 }
184 
185 // pragma solidity >=0.5.0;
186 
187 interface IUniswapV2Factory {
188     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
189 
190     function feeTo() external view returns (address);
191     function feeToSetter() external view returns (address);
192 
193     function getPair(address tokenA, address tokenB) external view returns (address pair);
194     function allPairs(uint) external view returns (address pair);
195     function allPairsLength() external view returns (uint);
196 
197     function createPair(address tokenA, address tokenB) external returns (address pair);
198 
199     function setFeeTo(address) external;
200     function setFeeToSetter(address) external;
201 }
202 
203 
204 // pragma solidity >=0.5.0;
205 
206 interface IUniswapV2Pair {
207     event Approval(address indexed owner, address indexed spender, uint value);
208     event Transfer(address indexed from, address indexed to, uint value);
209 
210     function name() external pure returns (string memory);
211     function symbol() external pure returns (string memory);
212     function decimals() external pure returns (uint8);
213     function totalSupply() external view returns (uint);
214     function balanceOf(address owner) external view returns (uint);
215     function allowance(address owner, address spender) external view returns (uint);
216 
217     function approve(address spender, uint value) external returns (bool);
218     function transfer(address to, uint value) external returns (bool);
219     function transferFrom(address from, address to, uint value) external returns (bool);
220 
221     function DOMAIN_SEPARATOR() external view returns (bytes32);
222     function PERMIT_TYPEHASH() external pure returns (bytes32);
223     function nonces(address owner) external view returns (uint);
224 
225     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
226     
227     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
228     event Swap(
229         address indexed sender,
230         uint amount0In,
231         uint amount1In,
232         uint amount0Out,
233         uint amount1Out,
234         address indexed to
235     );
236     event Sync(uint112 reserve0, uint112 reserve1);
237 
238     function MINIMUM_LIQUIDITY() external pure returns (uint);
239     function factory() external view returns (address);
240     function token0() external view returns (address);
241     function token1() external view returns (address);
242     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
243     function price0CumulativeLast() external view returns (uint);
244     function price1CumulativeLast() external view returns (uint);
245     function kLast() external view returns (uint);
246 
247     function burn(address to) external returns (uint amount0, uint amount1);
248     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
249     function skim(address to) external;
250     function sync() external;
251 
252     function initialize(address, address) external;
253 }
254 
255 // pragma solidity >=0.6.2;
256 
257 interface IUniswapV2Router01 {
258     function factory() external pure returns (address);
259     function WETH() external pure returns (address);
260 
261     function addLiquidity(
262         address tokenA,
263         address tokenB,
264         uint amountADesired,
265         uint amountBDesired,
266         uint amountAMin,
267         uint amountBMin,
268         address to,
269         uint deadline
270     ) external returns (uint amountA, uint amountB, uint liquidity);
271     function addLiquidityETH(
272         address token,
273         uint amountTokenDesired,
274         uint amountTokenMin,
275         uint amountETHMin,
276         address to,
277         uint deadline
278     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
279     function removeLiquidity(
280         address tokenA,
281         address tokenB,
282         uint liquidity,
283         uint amountAMin,
284         uint amountBMin,
285         address to,
286         uint deadline
287     ) external returns (uint amountA, uint amountB);
288     function removeLiquidityETH(
289         address token,
290         uint liquidity,
291         uint amountTokenMin,
292         uint amountETHMin,
293         address to,
294         uint deadline
295     ) external returns (uint amountToken, uint amountETH);
296     function removeLiquidityWithPermit(
297         address tokenA,
298         address tokenB,
299         uint liquidity,
300         uint amountAMin,
301         uint amountBMin,
302         address to,
303         uint deadline,
304         bool approveMax, uint8 v, bytes32 r, bytes32 s
305     ) external returns (uint amountA, uint amountB);
306     function removeLiquidityETHWithPermit(
307         address token,
308         uint liquidity,
309         uint amountTokenMin,
310         uint amountETHMin,
311         address to,
312         uint deadline,
313         bool approveMax, uint8 v, bytes32 r, bytes32 s
314     ) external returns (uint amountToken, uint amountETH);
315     function swapExactTokensForTokens(
316         uint amountIn,
317         uint amountOutMin,
318         address[] calldata path,
319         address to,
320         uint deadline
321     ) external returns (uint[] memory amounts);
322     function swapTokensForExactTokens(
323         uint amountOut,
324         uint amountInMax,
325         address[] calldata path,
326         address to,
327         uint deadline
328     ) external returns (uint[] memory amounts);
329     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
330         external
331         payable
332         returns (uint[] memory amounts);
333     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
334         external
335         returns (uint[] memory amounts);
336     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
337         external
338         returns (uint[] memory amounts);
339     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
340         external
341         payable
342         returns (uint[] memory amounts);
343 
344     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
345     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
346     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
347     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
348     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
349 }
350 
351 
352 
353 // pragma solidity >=0.6.2;
354 
355 interface IUniswapV2Router02 is IUniswapV2Router01 {
356     function removeLiquidityETHSupportingFeeOnTransferTokens(
357         address token,
358         uint liquidity,
359         uint amountTokenMin,
360         uint amountETHMin,
361         address to,
362         uint deadline
363     ) external returns (uint amountETH);
364     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
365         address token,
366         uint liquidity,
367         uint amountTokenMin,
368         uint amountETHMin,
369         address to,
370         uint deadline,
371         bool approveMax, uint8 v, bytes32 r, bytes32 s
372     ) external returns (uint amountETH);
373 
374     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
375         uint amountIn,
376         uint amountOutMin,
377         address[] calldata path,
378         address to,
379         uint deadline
380     ) external;
381     function swapExactETHForTokensSupportingFeeOnTransferTokens(
382         uint amountOutMin,
383         address[] calldata path,
384         address to,
385         uint deadline
386     ) external payable;
387     function swapExactTokensForETHSupportingFeeOnTransferTokens(
388         uint amountIn,
389         uint amountOutMin,
390         address[] calldata path,
391         address to,
392         uint deadline
393     ) external;
394 }
395 
396 contract MatrixInu is Context, IERC20, Ownable {
397     using SafeMath for uint256;
398     using Address for address;
399     
400     address payable private marketingWallet = payable(0x176dA1F1d5aE25C22A9e077210A087b6f01E3F6a); // Marketing Wallet
401     address payable private crowdfundWallet = payable(0x176dA1F1d5aE25C22A9e077210A087b6f01E3F6a); // Crowd Fund Wallet
402     address payable private devWallet = payable (0x176dA1F1d5aE25C22A9e077210A087b6f01E3F6a); // Dev Wallet
403     mapping (address => uint256) private _rOwned;
404     mapping (address => uint256) private _tOwned;
405     mapping (address => mapping (address => uint256)) private _allowances;
406     mapping (address => bool) private _isSniper;
407     
408     uint256 public deadBlocks = 2;
409     uint256 public launchedAt = 0;
410     
411 
412     mapping (address => bool) private _isExcludedFromFee;
413     mapping (address => bool) private _isMaxWalletExempt;
414     mapping (address => bool) private _isExcluded;
415     mapping (address => bool) private _isTrusted;
416     address[] private _excluded;
417     mapping (address => bool) internal authorizations;
418    
419     address DEAD = 0x000000000000000000000000000000000000dEaD;
420 
421     uint8 private _decimals = 8;
422     
423     uint256 private constant MAX = ~uint256(0);
424     uint256 private _tTotal = 150000000000 * 10**_decimals;
425     uint256 private _rTotal = (MAX - (MAX % _tTotal));
426     uint256 private _tFeeTotal;
427 
428     string private _name = "Matrix Inu";
429     string private _symbol = "MatrixInu";
430 
431     //Below was originally _tTotal.div(1000).mul(5); //0.5%
432 
433     uint256 public _maxWalletToken = _tTotal.div(100).mul(3); //3%
434 
435     uint256 public _buyLiquidityFee = 80; //8%
436     uint256 public _buyDevFee = 0;    //0%
437     uint256 public _buyMarketingFee = 0;   //0%
438     uint256 public _buyReflectionFee = 0;   //0%
439 
440     uint256 public _sellLiquidityFee = 80; //8%
441     uint256 public _sellMarketingFee = 0;  //0%
442     uint256 public _sellDevFee = 0;   //0%
443     uint256 public _sellReflectionFee = 0;   //0%
444     
445     uint256 private crowdfundfee = 10;   //0% same for buys and sells
446     uint256 private liquidityFee = _buyLiquidityFee;
447     uint256 private marketingFee = _buyMarketingFee;
448     uint256 private devFee = _buyDevFee;
449     uint256 private reflectionFee=_buyReflectionFee;
450 
451 
452     uint256 private totalFee =
453         liquidityFee.add(marketingFee).add(devFee).add(crowdfundfee);
454     uint256 private currenttotalFee = totalFee;
455     
456     //Below was originally _tTotal.div(10000).mul(5); //0.05%
457 
458     uint256 public swapThreshold = _tTotal.div(10000).mul(3); //0.03%
459    
460     IUniswapV2Router02 public uniswapV2Router;
461     address public uniswapV2Pair;
462     
463     bool inSwap;
464     
465     bool public tradingOpen = false;
466     bool public zeroBuyTaxmode = false;
467     
468     event SwapETHForTokens(
469         uint256 amountIn,
470         address[] path
471     );
472     
473     event SwapTokensForETH(
474         uint256 amountIn,
475         address[] path
476     );
477     
478     modifier lockTheSwap {
479         inSwap = true;
480         _;
481         inSwap = false;
482     }
483     
484 
485     constructor () {
486 
487         _rOwned[_msgSender()] = _rTotal;
488         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
489         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
490         .createPair(address(this), _uniswapV2Router.WETH());
491 
492         uniswapV2Router = _uniswapV2Router;
493 
494         _isExcludedFromFee[owner()] = true;
495         _isExcludedFromFee[address(this)] = true;
496         _isMaxWalletExempt[owner()] = true;
497         _isMaxWalletExempt[address(this)] = true;
498         _isMaxWalletExempt[uniswapV2Pair] = true;
499         _isMaxWalletExempt[DEAD] = true;
500         _isTrusted[owner()] = true;
501         _isTrusted[uniswapV2Pair] = true;
502         authorizations[msg.sender] = true;
503 
504         emit Transfer(address(0), _msgSender(), _tTotal);
505     }
506     
507     function openTrading(bool _status,uint256 _deadBlocks) external onlyOwner() {
508         tradingOpen = _status;
509         excludeFromReward(address(this));
510         excludeFromReward(uniswapV2Pair);
511         if(tradingOpen && launchedAt == 0){
512             launchedAt = block.number;
513             deadBlocks = _deadBlocks;
514         }
515     }
516 
517     
518     function setZeroBuyTaxmode(bool _status) external onlyOwner() {
519        zeroBuyTaxmode=_status;
520     }
521     
522     function setNewRouter(address newRouter) external onlyOwner() {
523         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
524         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
525         if (get_pair == address(0)) {
526             uniswapV2Pair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
527         }
528         else {
529             uniswapV2Pair = get_pair;
530         }
531         uniswapV2Router = _newRouter;
532     }
533 
534     function name() public view returns (string memory) {
535         return _name;
536     }
537 
538     function symbol() public view returns (string memory) {
539         return _symbol;
540     }
541 
542     function decimals() public view returns (uint8) {
543         return _decimals;
544     }
545 
546     function totalSupply() public view override returns (uint256) {
547         return _tTotal;
548     }
549 
550     function balanceOf(address account) public view override returns (uint256) {
551         if (_isExcluded[account]) return _tOwned[account];
552         return tokenFromReflection(_rOwned[account]);
553     }
554 
555     function transfer(address recipient, uint256 amount) public override returns (bool) {
556         _transfer(_msgSender(), recipient, amount);
557         return true;
558     }
559 
560     function allowance(address owner, address spender) public view override returns (uint256) {
561         return _allowances[owner][spender];
562     }
563 
564     function approve(address spender, uint256 amount) public override returns (bool) {
565         _approve(_msgSender(), spender, amount);
566         return true;
567     }
568 
569     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
570         _transfer(sender, recipient, amount);
571         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
572         return true;
573     }
574 
575     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
576         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
577         return true;
578     }
579 
580     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
582         return true;
583     }
584 
585     function isExcludedFromReward(address account) public view returns (bool) {
586         return _isExcluded[account];
587     }
588 
589     function totalFees() public view returns (uint256) {
590         return _tFeeTotal;
591     }
592     
593     function deliver(uint256 tAmount) public {
594         address sender = _msgSender();
595         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
596         (uint256 rAmount,,,,,) = _getValues(tAmount);
597         _rOwned[sender] = _rOwned[sender].sub(rAmount);
598         _rTotal = _rTotal.sub(rAmount);
599         _tFeeTotal = _tFeeTotal.add(tAmount);
600     }
601   
602 
603     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
604         require(tAmount <= _tTotal, "Amount must be less than supply");
605         if (!deductTransferFee) {
606             (uint256 rAmount,,,,,) = _getValues(tAmount);
607             return rAmount;
608         } else {
609             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
610             return rTransferAmount;
611         }
612     }
613 
614     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
615         require(rAmount <= _rTotal, "Amount must be less than total reflections");
616         uint256 currentRate =  _getRate();
617         return rAmount.div(currentRate);
618     }
619 
620     function excludeFromReward(address account) public onlyOwner() {
621 
622         if(_rOwned[account] > 0) {
623             _tOwned[account] = tokenFromReflection(_rOwned[account]);
624         }
625         _isExcluded[account] = true;
626         _excluded.push(account);
627     }
628 
629     function includeInReward(address account) external onlyOwner() {
630         require(_isExcluded[account], "Account is already excluded");
631         for (uint256 i = 0; i < _excluded.length; i++) {
632             if (_excluded[i] == account) {
633                 _excluded[i] = _excluded[_excluded.length - 1];
634                 _tOwned[account] = 0;
635                 _isExcluded[account] = false;
636                 _excluded.pop();
637                 break;
638             }
639         }
640     }
641 
642     function _approve(address owner, address spender, uint256 amount) private {
643         require(owner != address(0), "ERC20: approve from the zero address");
644         require(spender != address(0), "ERC20: approve to the zero address");
645 
646         _allowances[owner][spender] = amount;
647         emit Approval(owner, spender, amount);
648     }
649 
650     function _transfer(
651         address from,
652         address to,
653         uint256 amount
654     ) private {
655         require(from != address(0), "ERC20: transfer from the zero address");
656         require(to != address(0), "ERC20: transfer to the zero address");
657         require(amount > 0, "Transfer amount must be greater than zero");
658         require(!_isSniper[to], "Sorry Buddy, Get Rekt");
659         require(!_isSniper[from], "Sorry Buddy, Get Rekt");
660         
661         if(!authorizations[from]){
662             require(tradingOpen,"Trading not open yet");
663         }
664 
665          bool takeFee = false;
666         //take fee only on swaps
667         if ( (from==uniswapV2Pair || to==uniswapV2Pair) && !(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {
668             takeFee = true;
669         }
670 
671         if(launchedAt>0 && (!_isMaxWalletExempt[to] && !authorizations[from])){
672                 require(amount+ balanceOf(to)<=_maxWalletToken,
673                     "Total Holding is currently limited");
674         }
675 
676         currenttotalFee=totalFee;
677         reflectionFee=_buyReflectionFee;
678 
679         if(tradingOpen && to == uniswapV2Pair) { //sell
680             currenttotalFee= _sellLiquidityFee.add(_sellMarketingFee).add(_sellDevFee);
681             reflectionFee=_sellReflectionFee;
682         }
683         
684         //antibot - first 2 blocks
685         if(launchedAt>0 && (launchedAt + deadBlocks) > block.number){
686                 _isSniper[to]=true;
687         }
688 
689         if(zeroBuyTaxmode){
690              if(tradingOpen && from == uniswapV2Pair) { //buys
691                     currenttotalFee=0;
692              }
693         }
694 
695         //sell
696         if (!inSwap && tradingOpen && to == uniswapV2Pair) {
697       
698             uint256 contractTokenBalance = balanceOf(address(this));
699             
700             if(contractTokenBalance>=swapThreshold){
701                     contractTokenBalance = swapThreshold;
702                     swapTokens(contractTokenBalance);
703             }
704           
705         }
706         _tokenTransfer(from,to,amount,takeFee);
707     }
708 
709     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
710         
711         
712         uint256 amountToLiquify = contractTokenBalance
713             .mul(liquidityFee)
714             .div(totalFee)
715             .div(2);
716 
717         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
718         
719         swapTokensForEth(amountToSwap);
720 
721         uint256 amountETH = address(this).balance;
722 
723         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
724 
725         uint256 amountETHLiquidity = amountETH
726             .mul(liquidityFee)
727             .div(totalETHFee)
728             .div(2);
729         
730         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
731         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(
732             totalETHFee
733         );
734          uint256 amountETHcrowdfund = amountETH.mul(crowdfundfee).div(
735             totalETHFee
736         );
737         //Send to marketing wallet and dev wallet
738         uint256 contractETHBalance = address(this).balance;
739         if(contractETHBalance > 0) {
740             sendETHToFee(amountETHMarketing,marketingWallet);
741             sendETHToFee(amountETHcrowdfund,crowdfundWallet);
742             sendETHToFee(amountETHdev,devWallet);
743         }
744         if (amountToLiquify > 0) {
745                 addLiquidity(amountToLiquify,amountETHLiquidity);
746         }
747     }
748     
749     function sendETHToFee(uint256 amount,address payable wallet) private {
750         wallet.transfer(amount);
751     }
752     
753 
754    
755     function swapTokensForEth(uint256 tokenAmount) private {
756         // generate the uniswap pair path of token -> weth
757         address[] memory path = new address[](2);
758         path[0] = address(this);
759         path[1] = uniswapV2Router.WETH();
760 
761         _approve(address(this), address(uniswapV2Router), tokenAmount);
762 
763         // make the swap
764         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
765             tokenAmount,
766             0, // accept any amount of ETH
767             path,
768             address(this), // The contract
769             block.timestamp
770         );
771         
772         emit SwapTokensForETH(tokenAmount, path);
773     }
774     
775 
776     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
777         // approve token transfer to cover all possible scenarios
778         _approve(address(this), address(uniswapV2Router), tokenAmount);
779 
780         // add the liquidity
781         uniswapV2Router.addLiquidityETH{value: ethAmount}(
782             address(this),
783             tokenAmount,
784             0, // slippage is unavoidable
785             0, // slippage is unavoidable
786             owner(),
787             block.timestamp
788         );
789     }
790 
791     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
792 
793         uint256 _previousReflectionFee=reflectionFee;
794         uint256 _previousTotalFee=currenttotalFee;
795         if(!takeFee){
796             reflectionFee = 0;
797             currenttotalFee=0;
798         }
799         
800         if (_isExcluded[sender] && !_isExcluded[recipient]) {
801             _transferFromExcluded(sender, recipient, amount);
802         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
803             _transferToExcluded(sender, recipient, amount);
804         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
805             _transferBothExcluded(sender, recipient, amount);
806         } else {
807             _transferStandard(sender, recipient, amount);
808         }
809         
810         if(!takeFee){
811             reflectionFee = _previousReflectionFee;
812             currenttotalFee=_previousTotalFee;
813         }
814     }
815 
816     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
817         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
818         _rOwned[sender] = _rOwned[sender].sub(rAmount);
819         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
820         _takeLiquidity(tLiquidity);
821         _reflectFee(rFee, tFee);
822         emit Transfer(sender, recipient, tTransferAmount);
823     }
824 
825     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
826         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
827         _rOwned[sender] = _rOwned[sender].sub(rAmount);
828         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
829         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
830         _takeLiquidity(tLiquidity);
831         _reflectFee(rFee, tFee);
832         emit Transfer(sender, recipient, tTransferAmount);
833     }
834 
835     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
836         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
837         _tOwned[sender] = _tOwned[sender].sub(tAmount);
838         _rOwned[sender] = _rOwned[sender].sub(rAmount);
839         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
840         _takeLiquidity(tLiquidity);
841         _reflectFee(rFee, tFee);
842         emit Transfer(sender, recipient, tTransferAmount);
843     }
844 
845     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
846         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
847         _tOwned[sender] = _tOwned[sender].sub(tAmount);
848         _rOwned[sender] = _rOwned[sender].sub(rAmount);
849         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
850         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
851         _takeLiquidity(tLiquidity);
852         _reflectFee(rFee, tFee);
853         emit Transfer(sender, recipient, tTransferAmount);
854     }
855 
856     function _reflectFee(uint256 rFee, uint256 tFee) private {
857         _rTotal = _rTotal.sub(rFee);
858         _tFeeTotal = _tFeeTotal.add(tFee);
859     }
860 
861     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
862         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
863         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
864         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
865     }
866 
867     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
868         uint256 tFee = calculateTaxFee(tAmount);
869         uint256 tLiquidity = calculateLiquidityFee(tAmount);
870         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
871         return (tTransferAmount, tFee, tLiquidity);
872     }
873 
874     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
875         uint256 rAmount = tAmount.mul(currentRate);
876         uint256 rFee = tFee.mul(currentRate);
877         uint256 rLiquidity = tLiquidity.mul(currentRate);
878         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
879         return (rAmount, rTransferAmount, rFee);
880     }
881 
882     function _getRate() private view returns(uint256) {
883         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
884         return rSupply.div(tSupply);
885     }
886 
887     function _getCurrentSupply() private view returns(uint256, uint256) {
888         uint256 rSupply = _rTotal;
889         uint256 tSupply = _tTotal;      
890         for (uint256 i = 0; i < _excluded.length; i++) {
891             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
892             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
893             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
894         }
895         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
896         return (rSupply, tSupply);
897     }
898     
899     function _takeLiquidity(uint256 tLiquidity) private {
900         uint256 currentRate =  _getRate();
901         uint256 rLiquidity = tLiquidity.mul(currentRate);
902         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
903         if(_isExcluded[address(this)])
904             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
905     }
906     
907     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
908         return _amount.mul(reflectionFee).div(
909             10**3
910         );
911     }
912     
913     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
914         return _amount.mul(currenttotalFee).div(
915             10**3
916         );
917     }
918     
919     function excludeMultiple(address account) public onlyOwner {
920         _isExcludedFromFee[account] = true;
921     }
922 
923     function excludeFromFee(address[] calldata addresses) public onlyOwner {
924         for (uint256 i; i < addresses.length; ++i) {
925             _isExcludedFromFee[addresses[i]] = true;
926         }
927     }
928     
929     
930     function includeInFee(address account) public onlyOwner {
931         _isExcludedFromFee[account] = false;
932     }
933     
934     function setWallets(address _marketingWallet,address _devWallet) external onlyOwner() {
935         marketingWallet = payable(_marketingWallet);
936         devWallet = payable(_devWallet);
937     }
938 
939 
940     function transferToAddressETH(address payable recipient, uint256 amount) private {
941         recipient.transfer(amount);
942     }
943     
944     function isSniper(address account) public view returns (bool) {
945         return _isSniper[account];
946     }
947     
948     function manage_Snipers(address[] calldata addresses, bool status) public onlyOwner {
949         for (uint256 i; i < addresses.length; ++i) {
950             if(!_isTrusted[addresses[i]]){
951                 _isSniper[addresses[i]] = status;
952             }
953         }
954     }
955     
956     function manage_trusted(address[] calldata addresses) public onlyOwner {
957         for (uint256 i; i < addresses.length; ++i) {
958             _isTrusted[addresses[i]]=true;
959         }
960     }
961         
962     function withDrawLeftoverETH(address payable receipient) public onlyOwner {
963         receipient.transfer(address(this).balance);
964     }
965 
966     function withdrawStuckTokens(IERC20 token, address to) public onlyOwner {
967         uint256 balance = token.balanceOf(address(this));
968         token.transfer(to, balance);
969     }
970 
971     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
972         _maxWalletToken = _tTotal.div(1000).mul(maxWallPercent_base1000);
973     }
974 
975     function setMaxWalletExempt(address _addr) external onlyOwner {
976         _isMaxWalletExempt[_addr] = true;
977     }
978 
979     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor) external onlyOwner {
980         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
981     }
982 
983     function airdrop(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
984 
985         require(addresses.length < 2001,"GAS Error: max airdrop limit is 2000 addresses"); // to prevent overflow
986 
987         uint256 SCCC = tokens* 10**_decimals * addresses.length;
988 
989         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
990 
991         for(uint i=0; i < addresses.length; i++){
992             _transfer(from,addresses[i],(tokens* 10**_decimals));
993         }
994     }
995 
996     function setTaxesBuy(uint256 _reflectionFee, uint256 _liquidityFee, uint256 _marketingFee,uint256 _devFee,uint256 _crowdfundfee) external onlyOwner {
997        
998         _buyLiquidityFee = _liquidityFee;
999         _buyMarketingFee = _marketingFee;
1000         _buyDevFee = _devFee;
1001         _buyReflectionFee= _reflectionFee;
1002 
1003         reflectionFee= _reflectionFee;
1004         liquidityFee = _liquidityFee;
1005         devFee = _devFee;
1006         marketingFee = _marketingFee;
1007         crowdfundfee = _crowdfundfee;
1008         totalFee = liquidityFee.add(marketingFee).add(devFee).add(crowdfundfee);
1009         require(totalFee.add(_buyReflectionFee) <= 500, "Must keep taxes below 50%");
1010     }
1011 
1012      function authorize(address adr) public onlyOwner {
1013         authorizations[adr] = true;
1014     }
1015 
1016     function unauthorize(address adr) public onlyOwner {
1017         authorizations[adr] = false;
1018     }
1019 
1020     function setTaxesSell(uint256 _reflectionFee,uint256 _liquidityFee, uint256 _marketingFee,uint256 _devFee) external onlyOwner {
1021         _sellLiquidityFee = _liquidityFee;
1022         _sellMarketingFee = _marketingFee;
1023         _sellDevFee = _devFee;
1024         _sellReflectionFee= _reflectionFee;
1025         require(_sellLiquidityFee.add(_sellMarketingFee).add(_sellDevFee).add(_sellReflectionFee).add(crowdfundfee) <= 500, "Must keep taxes below 50%");
1026     }
1027      //to recieve ETH from uniswapV2Router when swaping
1028     receive() external payable {}
1029 }