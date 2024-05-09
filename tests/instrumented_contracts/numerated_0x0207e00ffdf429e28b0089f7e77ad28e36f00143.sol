1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return payable(msg.sender);
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 
16 interface IERC20 {
17 
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26     
27 
28 }
29 
30 library SafeMath {
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54 
55         uint256 c = a * b;
56         require(c / a == b, "SafeMath: multiplication overflow");
57 
58         return c;
59     }
60 
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return div(a, b, "SafeMath: division by zero");
64     }
65 
66     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b > 0, errorMessage);
68         uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71         return c;
72     }
73 
74     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
75         return mod(a, b, "SafeMath: modulo by zero");
76     }
77 
78     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         require(b != 0, errorMessage);
80         return a % b;
81     }
82 }
83 
84 library Address {
85 
86     function isContract(address account) internal view returns (bool) {
87         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
88         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
89         // for accounts without code, i.e. `keccak256('')`
90         bytes32 codehash;
91         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
92         // solhint-disable-next-line no-inline-assembly
93         assembly { codehash := extcodehash(account) }
94         return (codehash != accountHash && codehash != 0x0);
95     }
96 
97     function sendValue(address payable recipient, uint256 amount) internal {
98         require(address(this).balance >= amount, "Address: insufficient balance");
99 
100         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
101         (bool success, ) = recipient.call{ value: amount }("");
102         require(success, "Address: unable to send value, recipient may have reverted");
103     }
104 
105 
106     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
107       return functionCall(target, data, "Address: low-level call failed");
108     }
109 
110     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
111         return _functionCallWithValue(target, data, 0, errorMessage);
112     }
113 
114     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
116     }
117 
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), "Address: call to non-contract");
125 
126         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
127         if (success) {
128             return returndata;
129         } else {
130             
131             if (returndata.length > 0) {
132                 assembly {
133                     let returndata_size := mload(returndata)
134                     revert(add(32, returndata), returndata_size)
135                 }
136             } else {
137                 revert(errorMessage);
138             }
139         }
140     }
141 }
142 
143 contract Ownable is Context {
144     address private _owner;
145     address private _previousOwner;
146     uint256 private _lockTime;
147 
148     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
149 
150     constructor () {
151         address msgSender = _msgSender();
152         _owner = msgSender;
153         emit OwnershipTransferred(address(0), msgSender);
154     }
155 
156     function owner() public view returns (address) {
157         return _owner;
158     }   
159     
160     modifier onlyOwner() {
161         require(_owner == _msgSender(), "Ownable: caller is not the owner");
162         _;
163     }
164     
165     function renounceOwnership() public virtual onlyOwner {
166         emit OwnershipTransferred(_owner, address(0));
167         _owner = address(0);
168     }
169 
170     function transferOwnership(address newOwner) public virtual onlyOwner {
171         require(newOwner != address(0), "Ownable: new owner is the zero address");
172         emit OwnershipTransferred(_owner, newOwner);
173         _owner = newOwner;
174     }
175 }
176 
177 // pragma solidity >=0.5.0;
178 
179 interface IUniswapV2Factory {
180     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
181 
182     function feeTo() external view returns (address);
183     function feeToSetter() external view returns (address);
184 
185     function getPair(address tokenA, address tokenB) external view returns (address pair);
186     function allPairs(uint) external view returns (address pair);
187     function allPairsLength() external view returns (uint);
188 
189     function createPair(address tokenA, address tokenB) external returns (address pair);
190 
191     function setFeeTo(address) external;
192     function setFeeToSetter(address) external;
193 }
194 
195 
196 // pragma solidity >=0.5.0;
197 
198 interface IUniswapV2Pair {
199     event Approval(address indexed owner, address indexed spender, uint value);
200     event Transfer(address indexed from, address indexed to, uint value);
201 
202     function name() external pure returns (string memory);
203     function symbol() external pure returns (string memory);
204     function decimals() external pure returns (uint8);
205     function totalSupply() external view returns (uint);
206     function balanceOf(address owner) external view returns (uint);
207     function allowance(address owner, address spender) external view returns (uint);
208 
209     function approve(address spender, uint value) external returns (bool);
210     function transfer(address to, uint value) external returns (bool);
211     function transferFrom(address from, address to, uint value) external returns (bool);
212 
213     function DOMAIN_SEPARATOR() external view returns (bytes32);
214     function PERMIT_TYPEHASH() external pure returns (bytes32);
215     function nonces(address owner) external view returns (uint);
216 
217     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
218     
219     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
220     event Swap(
221         address indexed sender,
222         uint amount0In,
223         uint amount1In,
224         uint amount0Out,
225         uint amount1Out,
226         address indexed to
227     );
228     event Sync(uint112 reserve0, uint112 reserve1);
229 
230     function MINIMUM_LIQUIDITY() external pure returns (uint);
231     function factory() external view returns (address);
232     function token0() external view returns (address);
233     function token1() external view returns (address);
234     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
235     function price0CumulativeLast() external view returns (uint);
236     function price1CumulativeLast() external view returns (uint);
237     function kLast() external view returns (uint);
238 
239     function burn(address to) external returns (uint amount0, uint amount1);
240     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
241     function skim(address to) external;
242     function sync() external;
243 
244     function initialize(address, address) external;
245 }
246 
247 // pragma solidity >=0.6.2;
248 
249 interface IUniswapV2Router01 {
250     function factory() external pure returns (address);
251     function WETH() external pure returns (address);
252 
253     function addLiquidity(
254         address tokenA,
255         address tokenB,
256         uint amountADesired,
257         uint amountBDesired,
258         uint amountAMin,
259         uint amountBMin,
260         address to,
261         uint deadline
262     ) external returns (uint amountA, uint amountB, uint liquidity);
263     function addLiquidityETH(
264         address token,
265         uint amountTokenDesired,
266         uint amountTokenMin,
267         uint amountETHMin,
268         address to,
269         uint deadline
270     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
271     function removeLiquidity(
272         address tokenA,
273         address tokenB,
274         uint liquidity,
275         uint amountAMin,
276         uint amountBMin,
277         address to,
278         uint deadline
279     ) external returns (uint amountA, uint amountB);
280     function removeLiquidityETH(
281         address token,
282         uint liquidity,
283         uint amountTokenMin,
284         uint amountETHMin,
285         address to,
286         uint deadline
287     ) external returns (uint amountToken, uint amountETH);
288     function removeLiquidityWithPermit(
289         address tokenA,
290         address tokenB,
291         uint liquidity,
292         uint amountAMin,
293         uint amountBMin,
294         address to,
295         uint deadline,
296         bool approveMax, uint8 v, bytes32 r, bytes32 s
297     ) external returns (uint amountA, uint amountB);
298     function removeLiquidityETHWithPermit(
299         address token,
300         uint liquidity,
301         uint amountTokenMin,
302         uint amountETHMin,
303         address to,
304         uint deadline,
305         bool approveMax, uint8 v, bytes32 r, bytes32 s
306     ) external returns (uint amountToken, uint amountETH);
307     function swapExactTokensForTokens(
308         uint amountIn,
309         uint amountOutMin,
310         address[] calldata path,
311         address to,
312         uint deadline
313     ) external returns (uint[] memory amounts);
314     function swapTokensForExactTokens(
315         uint amountOut,
316         uint amountInMax,
317         address[] calldata path,
318         address to,
319         uint deadline
320     ) external returns (uint[] memory amounts);
321     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
322         external
323         payable
324         returns (uint[] memory amounts);
325     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
326         external
327         returns (uint[] memory amounts);
328     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
329         external
330         returns (uint[] memory amounts);
331     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
332         external
333         payable
334         returns (uint[] memory amounts);
335 
336     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
337     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
338     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
339     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
340     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
341 }
342 
343 
344 
345 // pragma solidity >=0.6.2;
346 
347 interface IUniswapV2Router02 is IUniswapV2Router01 {
348     function removeLiquidityETHSupportingFeeOnTransferTokens(
349         address token,
350         uint liquidity,
351         uint amountTokenMin,
352         uint amountETHMin,
353         address to,
354         uint deadline
355     ) external returns (uint amountETH);
356     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
357         address token,
358         uint liquidity,
359         uint amountTokenMin,
360         uint amountETHMin,
361         address to,
362         uint deadline,
363         bool approveMax, uint8 v, bytes32 r, bytes32 s
364     ) external returns (uint amountETH);
365 
366     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
367         uint amountIn,
368         uint amountOutMin,
369         address[] calldata path,
370         address to,
371         uint deadline
372     ) external;
373     function swapExactETHForTokensSupportingFeeOnTransferTokens(
374         uint amountOutMin,
375         address[] calldata path,
376         address to,
377         uint deadline
378     ) external payable;
379     function swapExactTokensForETHSupportingFeeOnTransferTokens(
380         uint amountIn,
381         uint amountOutMin,
382         address[] calldata path,
383         address to,
384         uint deadline
385     ) external;
386 }
387 
388 contract Shibushi is Context, IERC20, Ownable {
389     using SafeMath for uint256;
390     using Address for address;
391     
392     address payable private marketingWallet = payable(0x38C870004640AEbfC53E1686453eF16264618A8B); // Marketing Wallet
393     address payable private devWallet = payable (0x91A74eb42687a5d4e933a7b1CF2030E4236760b6); // dev Wallet
394     mapping (address => uint256) private _rOwned;
395     mapping (address => uint256) private _tOwned;
396     mapping (address => mapping (address => uint256)) private _allowances;
397    
398     uint256 public launchedAt = 0;
399     
400 
401     mapping (address => bool) private _isExcludedFromFee;
402     mapping (address => bool) private _isMaxWalletExempt;
403     mapping (address => bool) private _isExcluded;
404     mapping (address => bool) private _isTrusted;
405     mapping (address => bool) public isTimelockExempt;
406     
407     address[] private _excluded;
408    
409     address DEAD = 0x000000000000000000000000000000000000dEaD;
410 
411     uint8 private _decimals = 9;
412     
413     uint256 private constant MAX = ~uint256(0);
414     uint256 private _tTotal = 1000000000000000 * 10**_decimals;
415     uint256 private _rTotal = (MAX - (MAX % _tTotal));
416     uint256 private _tFeeTotal;
417 
418     string private _name = "Shibushi Inu";
419     string private _symbol = "SHIBUSHI";
420     
421 
422     uint256 public _maxWalletToken = _tTotal.div(1000).mul(2); //0.2%
423     uint256 public _maxSellLimit = _tTotal.div(1000).mul(3); //0.3%
424 
425     uint256 public _buyLiquidityFee = 3; //2%
426     uint256 public _buyDevFee = 2;    
427     uint256 public _buyMarketingFee = 5;   
428     uint256 public _buyReflectionFee = 2;
429 
430     uint256 public _sellLiquidityFee = 3;
431     uint256 public _sellMarketingFee = 5;  
432     uint256 public _sellDevFee = 2;  
433     uint256 public _sellReflectionFee = 2;
434     
435     mapping (address => bool) lpPairs;
436 
437     uint256 private liquidityFee = _buyLiquidityFee;
438     uint256 private marketingFee = _buyMarketingFee;
439     uint256 private devFee = _buyDevFee;
440     uint256 private reflectionFee=_buyReflectionFee;
441 
442     bool public cooldownEnabled = false;
443     uint256 public cooldownTimerInterval = 1 hours;
444     mapping (address => uint) private cooldownTimer;
445 
446     uint256 private totalFee =
447         liquidityFee.add(marketingFee).add(devFee);
448     uint256 private calculatedTotalFee = totalFee;
449     
450     uint256 public swapThreshold = _tTotal.div(1000).mul(2); //0.2%
451    
452     IUniswapV2Router02 public uniswapV2Router;
453     address public uniswapV2Pair;
454     
455     bool inSwap;
456     
457     bool public tradingOpen = false;
458     bool public zeroBuyTaxmode = false;
459 
460     mapping (address => bool) privateSaleHolders;
461     mapping (address => uint256) privateSaleSold;
462     mapping (address => uint256) privateSaleSellTime;
463     uint256 public privateSaleMaxDailySell = 5*10**17; //0.5eth
464     uint256 public privateSaleDelay = 24 hours;
465     bool public privateSaleLimitsEnabled = true;
466 
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
493         lpPairs[uniswapV2Pair] = true;
494 
495         _isExcludedFromFee[owner()] = true;
496         _isExcludedFromFee[address(this)] = true;
497         _isMaxWalletExempt[owner()] = true;
498         _isMaxWalletExempt[address(this)] = true;
499         _isMaxWalletExempt[uniswapV2Pair] = true;
500         _isMaxWalletExempt[DEAD] = true;
501         _isTrusted[owner()] = true;
502         _isTrusted[uniswapV2Pair] = true;
503         isTimelockExempt[owner()] = true;
504         isTimelockExempt[address(this)] = true;
505         excludeFromReward(DEAD);
506         isTimelockExempt[0x000000000000000000000000000000000000dEaD] = true;
507 
508         emit Transfer(address(0), _msgSender(), _tTotal);
509     }
510     
511     function openTrading(bool _status) external onlyOwner() {
512         tradingOpen = _status;
513         excludeFromReward(address(this));
514         excludeFromReward(uniswapV2Pair);
515         if(tradingOpen && launchedAt == 0){
516             launchedAt = block.number;
517         }
518     }
519 
520     
521     function setZeroBuyTaxmode(bool _status) external onlyOwner() {
522        zeroBuyTaxmode=_status;
523     }
524 
525     function setNewRouter(address newRouter) external onlyOwner() {
526         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
527         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
528         if (get_pair == address(0)) {
529             uniswapV2Pair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
530         }
531         else {
532             uniswapV2Pair = get_pair;
533         }
534         lpPairs[uniswapV2Pair] = true;
535         uniswapV2Router = _newRouter;
536     }
537 
538     function name() public view returns (string memory) {
539         return _name;
540     }
541 
542     function symbol() public view returns (string memory) {
543         return _symbol;
544     }
545 
546     function decimals() public view returns (uint8) {
547         return _decimals;
548     }
549 
550     function totalSupply() public view override returns (uint256) {
551         return _tTotal;
552     }
553 
554     function balanceOf(address account) public view override returns (uint256) {
555         if (_isExcluded[account]) return _tOwned[account];
556         return tokenFromReflection(_rOwned[account]);
557     }
558 
559     function transfer(address recipient, uint256 amount) public override returns (bool) {
560         _transfer(_msgSender(), recipient, amount);
561         return true;
562     }
563 
564     function allowance(address owner, address spender) public view override returns (uint256) {
565         return _allowances[owner][spender];
566     }
567 
568     function approve(address spender, uint256 amount) public override returns (bool) {
569         _approve(_msgSender(), spender, amount);
570         return true;
571     }
572 
573     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
574         _transfer(sender, recipient, amount);
575         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
576         return true;
577     }
578 
579     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
580         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
581         return true;
582     }
583 
584     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
585         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
586         return true;
587     }
588 
589     function isExcludedFromReward(address account) public view returns (bool) {
590         return _isExcluded[account];
591     }
592 
593     function totalFees() public view returns (uint256) {
594         return _tFeeTotal;
595     }
596     
597     function deliver(uint256 tAmount) public {
598         address sender = _msgSender();
599         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
600         (uint256 rAmount,,,,,) = _getValues(tAmount);
601         _rOwned[sender] = _rOwned[sender].sub(rAmount);
602         _rTotal = _rTotal.sub(rAmount);
603         _tFeeTotal = _tFeeTotal.add(tAmount);
604     }
605   
606 
607     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
608         require(tAmount <= _tTotal, "Amount must be less than supply");
609         if (!deductTransferFee) {
610             (uint256 rAmount,,,,,) = _getValues(tAmount);
611             return rAmount;
612         } else {
613             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
614             return rTransferAmount;
615         }
616     }
617 
618     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
619         require(rAmount <= _rTotal, "Amount must be less than total reflections");
620         uint256 currentRate =  _getRate();
621         return rAmount.div(currentRate);
622     }
623 
624     function excludeFromReward(address account) public onlyOwner() {
625 
626         if(_rOwned[account] > 0) {
627             _tOwned[account] = tokenFromReflection(_rOwned[account]);
628         }
629         _isExcluded[account] = true;
630         _excluded.push(account);
631     }
632 
633     function includeInReward(address account) external onlyOwner() {
634         require(_isExcluded[account], "Account is already excluded");
635         for (uint256 i = 0; i < _excluded.length; i++) {
636             if (_excluded[i] == account) {
637                 _excluded[i] = _excluded[_excluded.length - 1];
638                 _tOwned[account] = 0;
639                 _isExcluded[account] = false;
640                 _excluded.pop();
641                 break;
642             }
643         }
644     }
645 
646     function _approve(address owner, address spender, uint256 amount) private {
647         require(owner != address(0), "ERC20: approve from the zero address");
648         require(spender != address(0), "ERC20: approve to the zero address");
649 
650         _allowances[owner][spender] = amount;
651         emit Approval(owner, spender, amount);
652     }
653 
654     function _transfer(
655         address from,
656         address to,
657         uint256 amount
658     ) private {
659         require(from != address(0), "ERC20: transfer from the zero address");
660         require(to != address(0), "ERC20: transfer to the zero address");
661         require(amount > 0, "Transfer amount must be greater than zero");
662         if (from!= owner() && to!= owner()) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
663         
664          bool takeFee = false;
665         //take fee only on swaps
666         if ( (from==uniswapV2Pair || to==uniswapV2Pair) && !(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {
667             takeFee = true;
668         }
669 
670         if(launchedAt>0 && (!_isMaxWalletExempt[to] && from!= owner()) && !((launchedAt + 2) > block.number)){
671                 require(amount+ balanceOf(to)<=_maxWalletToken,
672                     "Total Holding is currently limited");
673         }
674 
675         calculatedTotalFee=totalFee;
676         reflectionFee=_buyReflectionFee;
677         
678 
679         if(privateSaleLimitsEnabled) {
680                 if(privateSaleHolders[from]) {
681                     require(lpPairs[to] || lpPairs[from]);
682                 }
683                 address[] memory path = new address[](2);
684                 path[0] = address(this);
685                 path[1] = uniswapV2Router.WETH();
686 
687                 if(lpPairs[to] && privateSaleHolders[from] && !inSwap) {
688                     uint256 ethBalance = uniswapV2Router.getAmountsOut(amount, path)[1];
689                     if(privateSaleSellTime[from] + privateSaleDelay < block.timestamp) {
690                         require(ethBalance <= privateSaleMaxDailySell);
691                         privateSaleSellTime[from] = block.timestamp;
692                         privateSaleSold[from] = ethBalance;
693                     } else if (privateSaleSellTime[from] + privateSaleDelay > block.timestamp) {
694                         require(privateSaleSold[from] + ethBalance <= privateSaleMaxDailySell);
695                         privateSaleSold[from] += ethBalance;
696                     }
697                 }
698         }
699 
700         if(cooldownEnabled && to == uniswapV2Pair && !isTimelockExempt[from]){
701             require(cooldownTimer[from] < block.timestamp, "Please wait for cooldown between sells");
702             cooldownTimer[from] = block.timestamp + cooldownTimerInterval;
703         }
704 
705         if(tradingOpen && to == uniswapV2Pair) { //sell
706             require(amount<=_maxSellLimit,"Amount Greater than max sell limit");
707             calculatedTotalFee= _sellLiquidityFee.add(_sellMarketingFee).add(_sellDevFee);
708             reflectionFee=_sellReflectionFee;
709         }
710         
711         //antibot - first 2 blocks
712         if(launchedAt>0 && (launchedAt + 2) > block.number){
713                 calculatedTotalFee=99;    //99%
714         }
715 
716         if(zeroBuyTaxmode){
717              if(tradingOpen && from == uniswapV2Pair) { //buys
718                     calculatedTotalFee=0;
719              }
720         }
721 
722         //sell
723         if (!inSwap && tradingOpen && to == uniswapV2Pair) {
724       
725             uint256 contractTokenBalance = balanceOf(address(this));
726             
727             if(contractTokenBalance>=swapThreshold){
728                     contractTokenBalance = swapThreshold;
729                     swapTokens(contractTokenBalance);
730             }
731           
732         }
733         _tokenTransfer(from,to,amount,takeFee);
734     }
735 
736     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
737         
738         
739         uint256 amountToLiquify = contractTokenBalance
740             .mul(liquidityFee)
741             .div(totalFee)
742             .div(2);
743 
744         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
745         
746         swapTokensForEth(amountToSwap);
747 
748         uint256 amountETH = address(this).balance;
749 
750         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
751 
752         uint256 amountETHLiquidity = amountETH
753             .mul(liquidityFee)
754             .div(totalETHFee)
755             .div(2);
756         
757         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
758         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(
759             totalETHFee
760         );
761         
762         //Send to marketing wallet and dev wallet
763         uint256 contractETHBalance = address(this).balance;
764         if(contractETHBalance > 0) {
765             sendETHToFee(amountETHMarketing,marketingWallet);
766             sendETHToFee(amountETHdev,devWallet);
767         }
768         if (amountToLiquify > 0) {
769                 addLiquidity(amountToLiquify,amountETHLiquidity);
770         }
771     }
772     
773     function sendETHToFee(uint256 amount,address payable wallet) private {
774         wallet.transfer(amount);
775     }
776     
777     function swapTokenswithoutImpact(uint256 contractTokenBalance) private lockTheSwap {
778         
779         
780         uint256 amountToLiquify = contractTokenBalance
781             .mul(liquidityFee)
782             .div(totalFee)
783             .div(2);
784 
785         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
786         
787         swapTokensForEth(amountToSwap);
788 
789         uint256 amountETH = address(this).balance;
790 
791         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
792 
793         uint256 amountETHLiquidity = amountETH
794             .mul(liquidityFee)
795             .div(totalETHFee)
796             .div(2);
797         
798         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
799         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(
800             totalETHFee
801         );
802 
803        
804          
805         //Send to marketing wallet and dev wallet
806         uint256 contractETHBalance = address(this).balance;
807         if(contractETHBalance > 0) {
808             sendETHToFee(amountETHMarketing,marketingWallet);
809             sendETHToFee(amountETHdev,devWallet);
810         }
811         if (amountToLiquify > 0) {
812                 addLiquidity(amountToLiquify,amountETHLiquidity);
813         }
814 
815         _transfer(uniswapV2Pair,DEAD,contractTokenBalance);
816         IUniswapV2Pair(uniswapV2Pair).sync();
817         
818     }
819     
820 
821    
822     function swapTokensForEth(uint256 tokenAmount) private {
823         // generate the uniswap pair path of token -> weth
824         address[] memory path = new address[](2);
825         path[0] = address(this);
826         path[1] = uniswapV2Router.WETH();
827 
828         _approve(address(this), address(uniswapV2Router), tokenAmount);
829 
830         // make the swap
831         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
832             tokenAmount,
833             0, // accept any amount of ETH
834             path,
835             address(this), // The contract
836             block.timestamp
837         );
838         
839         emit SwapTokensForETH(tokenAmount, path);
840     }
841     
842 
843     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
844         // approve token transfer to cover all possible scenarios
845         _approve(address(this), address(uniswapV2Router), tokenAmount);
846         // add the liquidity
847         uniswapV2Router.addLiquidityETH{value: ethAmount}(
848             address(this),
849             tokenAmount,
850             0, // slippage is unavoidable
851             0, // slippage is unavoidable
852             owner(),
853             block.timestamp
854         );
855     }
856 
857     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
858 
859         uint256 _previousReflectionFee=reflectionFee;
860         uint256 _previousTotalFee=calculatedTotalFee;
861         if(!takeFee){
862             reflectionFee = 0;
863             calculatedTotalFee=0;
864         }
865         
866         if (_isExcluded[sender] && !_isExcluded[recipient]) {
867             _transferFromExcluded(sender, recipient, amount);
868         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
869             _transferToExcluded(sender, recipient, amount);
870         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
871             _transferBothExcluded(sender, recipient, amount);
872         } else {
873             _transferStandard(sender, recipient, amount);
874         }
875         
876         if(!takeFee){
877             reflectionFee = _previousReflectionFee;
878             calculatedTotalFee=_previousTotalFee;
879         }
880     }
881 
882     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
883         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
884         _rOwned[sender] = _rOwned[sender].sub(rAmount);
885         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
886         _takeLiquidity(tLiquidity);
887         _reflectFee(rFee, tFee);
888         emit Transfer(sender, recipient, tTransferAmount);
889     }
890 
891     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
892         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
893         _rOwned[sender] = _rOwned[sender].sub(rAmount);
894         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
895         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
896         _takeLiquidity(tLiquidity);
897         _reflectFee(rFee, tFee);
898         emit Transfer(sender, recipient, tTransferAmount);
899     }
900 
901     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
902         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
903         _tOwned[sender] = _tOwned[sender].sub(tAmount);
904         _rOwned[sender] = _rOwned[sender].sub(rAmount);
905         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
906         _takeLiquidity(tLiquidity);
907         _reflectFee(rFee, tFee);
908         emit Transfer(sender, recipient, tTransferAmount);
909     }
910 
911     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
912         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
913         _tOwned[sender] = _tOwned[sender].sub(tAmount);
914         _rOwned[sender] = _rOwned[sender].sub(rAmount);
915         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
916         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
917         _takeLiquidity(tLiquidity);
918         _reflectFee(rFee, tFee);
919         emit Transfer(sender, recipient, tTransferAmount);
920     }
921 
922     function _reflectFee(uint256 rFee, uint256 tFee) private {
923         _rTotal = _rTotal.sub(rFee);
924         _tFeeTotal = _tFeeTotal.add(tFee);
925     }
926 
927     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
928         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
929         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
930         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
931     }
932 
933     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
934         uint256 tFee = calculateTaxFee(tAmount);
935         uint256 tLiquidity = calculateLiquidityFee(tAmount);
936         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
937         return (tTransferAmount, tFee, tLiquidity);
938     }
939 
940     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
941         uint256 rAmount = tAmount.mul(currentRate);
942         uint256 rFee = tFee.mul(currentRate);
943         uint256 rLiquidity = tLiquidity.mul(currentRate);
944         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
945         return (rAmount, rTransferAmount, rFee);
946     }
947 
948     function _getRate() private view returns(uint256) {
949         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
950         return rSupply.div(tSupply);
951     }
952 
953      // enable cooldown between sells
954     function changeCooldownSettings(bool newStatus, uint256 newInterval) external onlyOwner {
955         require(newInterval <= 24 hours, "Exceeds the limit");
956         cooldownEnabled = newStatus;
957         cooldownTimerInterval = newInterval;
958     }
959 
960      // enable cooldown between sells
961     function enableCooldown(bool newStatus) external onlyOwner {
962         cooldownEnabled = newStatus;
963     }
964 
965     function _getCurrentSupply() private view returns(uint256, uint256) {
966         uint256 rSupply = _rTotal;
967         uint256 tSupply = _tTotal;      
968         for (uint256 i = 0; i < _excluded.length; i++) {
969             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
970             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
971             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
972         }
973         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
974         return (rSupply, tSupply);
975     }
976     
977     function _takeLiquidity(uint256 tLiquidity) private {
978         uint256 currentRate =  _getRate();
979         uint256 rLiquidity = tLiquidity.mul(currentRate);
980         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
981         if(_isExcluded[address(this)])
982             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
983     }
984     
985     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
986         return _amount.mul(reflectionFee).div(
987             10**2
988         );
989     }
990     
991     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
992         return _amount.mul(calculatedTotalFee).div(
993             10**2
994         );
995     }
996     
997     function excludeMultiple(address account) public onlyOwner {
998         _isExcludedFromFee[account] = true;
999     }
1000 
1001     function excludeFromFee(address[] calldata addresses) public onlyOwner {
1002         for (uint256 i; i < addresses.length; ++i) {
1003             _isExcludedFromFee[addresses[i]] = true;
1004         }
1005     }
1006     
1007     
1008     function includeInFee(address account) public onlyOwner {
1009         _isExcludedFromFee[account] = false;
1010     }
1011     
1012     function setWallets(address _marketingWallet, address _devWallet) external onlyOwner() {
1013         marketingWallet = payable(_marketingWallet);
1014         devWallet = payable(_devWallet);
1015     }
1016 
1017 
1018     function transferToAddressETH(address payable recipient, uint256 amount) private {
1019         recipient.transfer(amount);
1020     }
1021     
1022     function setIsTimelockExempt(address holder, bool exempt) external onlyOwner {
1023         isTimelockExempt[holder] = exempt;
1024     }
1025 
1026     
1027     function manage_trusted(address[] calldata addresses) public onlyOwner {
1028         for (uint256 i; i < addresses.length; ++i) {
1029             _isTrusted[addresses[i]]=true;
1030         }
1031     }
1032         
1033     function withDrawLeftoverETH(address payable receipient) public onlyOwner {
1034         receipient.transfer(address(this).balance);
1035     }
1036 
1037     function withdrawStuckTokens(IERC20 token, address to) public onlyOwner {
1038         uint256 balance = token.balanceOf(address(this));
1039         token.transfer(to, balance);
1040     }
1041 
1042     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
1043         _maxWalletToken = _tTotal.div(1000).mul(maxWallPercent_base1000);
1044     }
1045 
1046     function setMaxSellPercent_base1000(uint256 maxSellPercent_base1000) external onlyOwner() {
1047         require(maxSellPercent_base1000>0,"Max sell % should be higher than 0.1%"); 
1048         _maxSellLimit = _tTotal.div(1000).mul(maxSellPercent_base1000);
1049     }
1050 
1051     function setMaxWalletExempt(address _addr) external onlyOwner {
1052         _isMaxWalletExempt[_addr] = true;
1053     }
1054 
1055     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor) external onlyOwner {
1056         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
1057     }
1058 
1059     function send_airdrops(address[] calldata addresses, uint256 tokens) external onlyOwner {
1060 
1061         require(addresses.length < 2001,"GAS Error: max airdrop limit is 2000 addresses"); // to prevent overflow
1062 
1063         uint256 SCCC = tokens* 10**_decimals * addresses.length;
1064 
1065         require(balanceOf(_msgSender()) >= SCCC, "Not enough tokens in wallet");
1066 
1067         for(uint i=0; i < addresses.length; i++){
1068             _transfer(_msgSender(),addresses[i],(tokens* 10**_decimals));
1069             }
1070     }
1071 
1072      function setTaxesBuy(uint256 _reflectionFee, uint256 _liquidityFee, uint256 _marketingFee,uint256 _devFee) external onlyOwner {
1073        
1074         _buyLiquidityFee = _liquidityFee;
1075         _buyMarketingFee = _marketingFee;
1076         _buyDevFee = _devFee;
1077         _buyReflectionFee= _reflectionFee;
1078 
1079         reflectionFee= _reflectionFee;
1080         liquidityFee = _liquidityFee;
1081         devFee = _devFee;
1082         marketingFee = _marketingFee;
1083 
1084         totalFee = liquidityFee.add(marketingFee).add(devFee);
1085 
1086         require(totalFee<50, "Total Buy Fee  should be  less than 50%");
1087 
1088     }
1089 
1090     function setTaxesSell(uint256 _reflectionFee,uint256 _liquidityFee, uint256 _marketingFee,uint256 _devFee) external onlyOwner {
1091         _sellLiquidityFee = _liquidityFee;
1092         _sellMarketingFee = _marketingFee;
1093         _sellDevFee = _devFee;
1094         _sellReflectionFee= _reflectionFee;
1095 
1096          require(_sellLiquidityFee.add(_sellMarketingFee).add(_sellDevFee).add(_sellReflectionFee)<50, "Total Sell Fee should be less than 50%");
1097     }
1098 
1099     function setPrivateSaleLimitsEnabled(bool enabled) external onlyOwner {
1100         privateSaleLimitsEnabled = enabled;
1101     }
1102 
1103     function setPrivateSalersEnabled(address[] memory accounts, bool enabled) external onlyOwner {
1104         for (uint256 i = 0; i < accounts.length; i++) {
1105             privateSaleHolders[accounts[i]] = enabled;
1106         }
1107     }
1108 
1109     function setPrivateSaleSettings(uint256 value, uint256 multiplier, uint256 time) external onlyOwner {
1110         require(value * 10**multiplier >= 5 * 10**17);
1111         require(time <= 48 hours);
1112         privateSaleMaxDailySell = value * 10**multiplier;
1113         privateSaleDelay = time;
1114     }
1115 
1116     function setPrivateSaleLimits(uint256 value, uint256 multiplier) external onlyOwner {
1117         require(value * 10**multiplier >= 5 * 10**17);
1118         privateSaleMaxDailySell = value * 10**multiplier;
1119     }
1120     
1121     receive() external payable {}
1122 }