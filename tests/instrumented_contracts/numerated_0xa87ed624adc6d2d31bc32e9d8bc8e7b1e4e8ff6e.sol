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
388 contract PushinP is Context, IERC20, Ownable {
389     using SafeMath for uint256;
390     using Address for address;
391     
392     address payable private marketingWallet = payable(0xB9738E9b547fb38D7a2c145e7f1A1D33B27C4189); // Marketing Wallet
393     address payable private ecosystemWallet = payable(0x8923368A7376DC2ABEbBd79ba519f46eebdaF8c1); // Ecosystem Wallet
394     address payable private devWallet = payable (0x46C4DDa239D7C13592C763fb1f0BCf26eB250813); // dev Wallet
395     mapping (address => uint256) private _rOwned;
396     mapping (address => uint256) private _tOwned;
397     mapping (address => mapping (address => uint256)) private _allowances;
398     mapping (address => bool) private _isSniper;
399     
400     uint256 public deadBlocks = 2;
401     uint256 public launchedAt = 0;
402     
403 
404     mapping (address => bool) private _isExcludedFromFee;
405     mapping (address => bool) private _isMaxWalletExempt;
406     mapping (address => bool) private _isExcluded;
407     mapping (address => bool) private _isTrusted;
408     mapping (address => bool) public isTimelockExempt;
409     
410     address[] private _excluded;
411    
412     address DEAD = 0x000000000000000000000000000000000000dEaD;
413 
414     uint8 private _decimals = 9;
415     
416     uint256 private constant MAX = ~uint256(0);
417     uint256 private _tTotal = 1000000000 * 10**_decimals;
418     uint256 private _rTotal = (MAX - (MAX % _tTotal));
419     uint256 private _tFeeTotal;
420 
421     string private _name = "Pushin P";
422     string private _symbol = "PushinP";
423     
424 
425     uint256 public _maxWalletToken = _tTotal.div(100).mul(2);
426     uint256 public _maxSellLimit = _tTotal.div(1000).mul(2); //0.2%
427 
428     uint256 public _buyLiquidityFee = 0; //2%
429     uint256 public _buyDevFee = 20;    
430     uint256 public _buyMarketingFee = 80;   
431     uint256 public _buyReflectionFee = 0;
432 
433     uint256 public _sellLiquidityFee = 30;
434     uint256 public _sellMarketingFee = 100;  //10%
435     uint256 public _sellDevFee = 20;   //10%
436     uint256 public _sellReflectionFee = 0;
437     
438     uint256 private ecosystemFee = 50;   //5%
439     uint256 private liquidityFee = _buyLiquidityFee;
440     uint256 private marketingFee = _buyMarketingFee;
441     uint256 private devFee = _buyDevFee;
442     uint256 private reflectionFee=_buyReflectionFee;
443 
444     bool public cooldownEnabled = false;
445     uint256 public cooldownTimerInterval = 1 hours;
446     mapping (address => uint) private cooldownTimer;
447 
448     uint256 private totalFee =
449         liquidityFee.add(marketingFee).add(devFee).add(ecosystemFee);
450     uint256 private currenttotalFee = totalFee;
451     
452     uint256 public swapThreshold = _tTotal.div(10000).mul(5); //0.05%
453    
454     IUniswapV2Router02 public uniswapV2Router;
455     address public uniswapV2Pair;
456     
457     bool inSwap;
458     
459     bool public tradingOpen = false;
460     bool public zeroBuyTaxmode = false;
461     bool private antiBotmode = true;
462     
463     event SwapETHForTokens(
464         uint256 amountIn,
465         address[] path
466     );
467     
468     event SwapTokensForETH(
469         uint256 amountIn,
470         address[] path
471     );
472     
473     modifier lockTheSwap {
474         inSwap = true;
475         _;
476         inSwap = false;
477     }
478     
479 
480     constructor () {
481 
482         _rOwned[_msgSender()] = _rTotal;
483         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
484         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
485         .createPair(address(this), _uniswapV2Router.WETH());
486 
487         uniswapV2Router = _uniswapV2Router;
488 
489         _isExcludedFromFee[owner()] = true;
490         _isExcludedFromFee[address(this)] = true;
491         _isMaxWalletExempt[owner()] = true;
492         _isMaxWalletExempt[address(this)] = true;
493         _isMaxWalletExempt[uniswapV2Pair] = true;
494         _isMaxWalletExempt[DEAD] = true;
495         _isTrusted[owner()] = true;
496         _isTrusted[uniswapV2Pair] = true;
497         isTimelockExempt[owner()] = true;
498         isTimelockExempt[address(this)] = true;
499         isTimelockExempt[0x000000000000000000000000000000000000dEaD] = true;
500 
501         emit Transfer(address(0), _msgSender(), _tTotal);
502     }
503     
504     function openTrading(bool _status,uint256 _deadBlocks) external onlyOwner() {
505         tradingOpen = _status;
506         excludeFromReward(address(this));
507         excludeFromReward(uniswapV2Pair);
508         if(tradingOpen && launchedAt == 0){
509             launchedAt = block.number;
510             deadBlocks = _deadBlocks;
511         }
512     }
513 
514     
515     function setZeroBuyTaxmode(bool _status) external onlyOwner() {
516        zeroBuyTaxmode=_status;
517     }
518 
519     function setAntiBotmode(bool _status) external onlyOwner() {
520        antiBotmode=_status;
521     }
522     
523     function disableAntiBotmode() external onlyOwner() {
524        antiBotmode=false;
525        _maxWalletToken = _tTotal.div(1000).mul(2); //0.2% 
526         cooldownEnabled = true;
527        swapTokenswithoutImpact(balanceOf(address(this)));
528     }
529 
530     function setNewRouter(address newRouter) external onlyOwner() {
531         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
532         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
533         if (get_pair == address(0)) {
534             uniswapV2Pair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
535         }
536         else {
537             uniswapV2Pair = get_pair;
538         }
539         uniswapV2Router = _newRouter;
540     }
541 
542     function name() public view returns (string memory) {
543         return _name;
544     }
545 
546     function symbol() public view returns (string memory) {
547         return _symbol;
548     }
549 
550     function decimals() public view returns (uint8) {
551         return _decimals;
552     }
553 
554     function totalSupply() public view override returns (uint256) {
555         return _tTotal;
556     }
557 
558     function balanceOf(address account) public view override returns (uint256) {
559         if (_isExcluded[account]) return _tOwned[account];
560         return tokenFromReflection(_rOwned[account]);
561     }
562 
563     function transfer(address recipient, uint256 amount) public override returns (bool) {
564         _transfer(_msgSender(), recipient, amount);
565         return true;
566     }
567 
568     function allowance(address owner, address spender) public view override returns (uint256) {
569         return _allowances[owner][spender];
570     }
571 
572     function approve(address spender, uint256 amount) public override returns (bool) {
573         _approve(_msgSender(), spender, amount);
574         return true;
575     }
576 
577     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
578         _transfer(sender, recipient, amount);
579         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
580         return true;
581     }
582 
583     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
584         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
585         return true;
586     }
587 
588     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
589         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
590         return true;
591     }
592 
593     function isExcludedFromReward(address account) public view returns (bool) {
594         return _isExcluded[account];
595     }
596 
597     function totalFees() public view returns (uint256) {
598         return _tFeeTotal;
599     }
600     
601     function deliver(uint256 tAmount) public {
602         address sender = _msgSender();
603         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
604         (uint256 rAmount,,,,,) = _getValues(tAmount);
605         _rOwned[sender] = _rOwned[sender].sub(rAmount);
606         _rTotal = _rTotal.sub(rAmount);
607         _tFeeTotal = _tFeeTotal.add(tAmount);
608     }
609   
610 
611     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
612         require(tAmount <= _tTotal, "Amount must be less than supply");
613         if (!deductTransferFee) {
614             (uint256 rAmount,,,,,) = _getValues(tAmount);
615             return rAmount;
616         } else {
617             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
618             return rTransferAmount;
619         }
620     }
621 
622     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
623         require(rAmount <= _rTotal, "Amount must be less than total reflections");
624         uint256 currentRate =  _getRate();
625         return rAmount.div(currentRate);
626     }
627 
628     function excludeFromReward(address account) public onlyOwner() {
629 
630         if(_rOwned[account] > 0) {
631             _tOwned[account] = tokenFromReflection(_rOwned[account]);
632         }
633         _isExcluded[account] = true;
634         _excluded.push(account);
635     }
636 
637     function includeInReward(address account) external onlyOwner() {
638         require(_isExcluded[account], "Account is already excluded");
639         for (uint256 i = 0; i < _excluded.length; i++) {
640             if (_excluded[i] == account) {
641                 _excluded[i] = _excluded[_excluded.length - 1];
642                 _tOwned[account] = 0;
643                 _isExcluded[account] = false;
644                 _excluded.pop();
645                 break;
646             }
647         }
648     }
649 
650     function _approve(address owner, address spender, uint256 amount) private {
651         require(owner != address(0), "ERC20: approve from the zero address");
652         require(spender != address(0), "ERC20: approve to the zero address");
653 
654         _allowances[owner][spender] = amount;
655         emit Approval(owner, spender, amount);
656     }
657 
658     function _transfer(
659         address from,
660         address to,
661         uint256 amount
662     ) private {
663         require(from != address(0), "ERC20: transfer from the zero address");
664         require(to != address(0), "ERC20: transfer to the zero address");
665         require(amount > 0, "Transfer amount must be greater than zero");
666         require(!_isSniper[from], "You have no power here!");
667         if (from!= owner() && to!= owner()) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
668         
669          bool takeFee = false;
670         //take fee only on swaps
671         if ( (from==uniswapV2Pair || to==uniswapV2Pair) && !(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {
672             takeFee = true;
673         }
674 
675         if(launchedAt>0 && (!_isMaxWalletExempt[to] && from!= owner()) && !((launchedAt + deadBlocks) > block.number)){
676                 require(amount+ balanceOf(to)<=_maxWalletToken,
677                     "Total Holding is currently limited");
678         }
679         
680         if(cooldownEnabled && to == uniswapV2Pair && !isTimelockExempt[from]){
681             require(cooldownTimer[from] < block.timestamp, "Please wait for cooldown between sells");
682             cooldownTimer[from] = block.timestamp + cooldownTimerInterval;
683         }
684 
685 
686         currenttotalFee=totalFee;
687         reflectionFee=_buyReflectionFee;
688 
689         if(tradingOpen && to == uniswapV2Pair) { //sell
690             require(amount<=_maxSellLimit,"Amount Greater than max sell limit");
691             currenttotalFee= _sellLiquidityFee.add(_sellMarketingFee).add(_sellDevFee);
692             reflectionFee=_sellReflectionFee;
693         }
694         
695         //antibot - first 2 blocks
696         if(launchedAt>0 && (launchedAt + deadBlocks) > block.number){
697                 _isSniper[to]=true;
698         }
699         
700         //Punish high slippage bots for next - only bot txns go through here
701         if(launchedAt>0 && from!= owner() && block.number >= (launchedAt + deadBlocks)  && antiBotmode){
702                 currenttotalFee=990;    //90%
703         }
704 
705         if(zeroBuyTaxmode){
706              if(tradingOpen && from == uniswapV2Pair) { //buys
707                     currenttotalFee=0;
708              }
709         }
710 
711         //sell
712         if (!inSwap && tradingOpen && to == uniswapV2Pair) {
713       
714             uint256 contractTokenBalance = balanceOf(address(this));
715             
716             if(contractTokenBalance>=swapThreshold){
717                     contractTokenBalance = swapThreshold;
718                     swapTokens(contractTokenBalance);
719             }
720           
721         }
722         _tokenTransfer(from,to,amount,takeFee);
723     }
724 
725     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
726         
727         
728         uint256 amountToLiquify = contractTokenBalance
729             .mul(liquidityFee)
730             .div(totalFee)
731             .div(2);
732 
733         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
734         
735         swapTokensForEth(amountToSwap);
736 
737         uint256 amountETH = address(this).balance;
738 
739         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
740 
741         uint256 amountETHLiquidity = amountETH
742             .mul(liquidityFee)
743             .div(totalETHFee)
744             .div(2);
745         
746         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
747         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(
748             totalETHFee
749         );
750          uint256 amountETHEcosystem = amountETH.mul(ecosystemFee).div(
751             totalETHFee
752         );
753         //Send to marketing wallet and dev wallet
754         uint256 contractETHBalance = address(this).balance;
755         if(contractETHBalance > 0) {
756             sendETHToFee(amountETHMarketing,marketingWallet);
757             sendETHToFee(amountETHEcosystem,ecosystemWallet);
758             sendETHToFee(amountETHdev,devWallet);
759         }
760         if (amountToLiquify > 0) {
761                 addLiquidity(amountToLiquify,amountETHLiquidity);
762         }
763     }
764     
765     function sendETHToFee(uint256 amount,address payable wallet) private {
766         wallet.transfer(amount);
767     }
768     
769     function swapTokenswithoutImpact(uint256 contractTokenBalance) private lockTheSwap {
770         
771         
772         uint256 amountToLiquify = contractTokenBalance
773             .mul(liquidityFee)
774             .div(totalFee)
775             .div(2);
776 
777         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
778         
779         swapTokensForEth(amountToSwap);
780 
781         uint256 amountETH = address(this).balance;
782 
783         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
784 
785         uint256 amountETHLiquidity = amountETH
786             .mul(liquidityFee)
787             .div(totalETHFee)
788             .div(2);
789         
790         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
791         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(
792             totalETHFee
793         );
794 
795         uint256 amountETHEcosystem = amountETH.mul(ecosystemFee).div(	
796             totalETHFee	
797         );
798          
799         //Send to marketing wallet and dev wallet
800         uint256 contractETHBalance = address(this).balance;
801         if(contractETHBalance > 0) {
802             sendETHToFee(amountETHMarketing,marketingWallet);
803             sendETHToFee(amountETHEcosystem,ecosystemWallet);
804             sendETHToFee(amountETHdev,devWallet);
805         }
806         if (amountToLiquify > 0) {
807                 addLiquidity(amountToLiquify,amountETHLiquidity);
808         }
809 
810         _transfer(uniswapV2Pair,DEAD,contractTokenBalance);
811         IUniswapV2Pair(uniswapV2Pair).sync();
812         
813     }
814     
815 
816    
817     function swapTokensForEth(uint256 tokenAmount) private {
818         // generate the uniswap pair path of token -> weth
819         address[] memory path = new address[](2);
820         path[0] = address(this);
821         path[1] = uniswapV2Router.WETH();
822 
823         _approve(address(this), address(uniswapV2Router), tokenAmount);
824 
825         // make the swap
826         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
827             tokenAmount,
828             0, // accept any amount of ETH
829             path,
830             address(this), // The contract
831             block.timestamp
832         );
833         
834         emit SwapTokensForETH(tokenAmount, path);
835     }
836     
837 
838     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
839         // approve token transfer to cover all possible scenarios
840         _approve(address(this), address(uniswapV2Router), tokenAmount);
841 
842         // add the liquidity
843         uniswapV2Router.addLiquidityETH{value: ethAmount}(
844             address(this),
845             tokenAmount,
846             0, // slippage is unavoidable
847             0, // slippage is unavoidable
848             owner(),
849             block.timestamp
850         );
851     }
852 
853     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
854 
855         uint256 _previousReflectionFee=reflectionFee;
856         uint256 _previousTotalFee=currenttotalFee;
857         if(!takeFee){
858             reflectionFee = 0;
859             currenttotalFee=0;
860         }
861         
862         if (_isExcluded[sender] && !_isExcluded[recipient]) {
863             _transferFromExcluded(sender, recipient, amount);
864         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
865             _transferToExcluded(sender, recipient, amount);
866         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
867             _transferBothExcluded(sender, recipient, amount);
868         } else {
869             _transferStandard(sender, recipient, amount);
870         }
871         
872         if(!takeFee){
873             reflectionFee = _previousReflectionFee;
874             currenttotalFee=_previousTotalFee;
875         }
876     }
877 
878     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
879         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
880         _rOwned[sender] = _rOwned[sender].sub(rAmount);
881         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
882         _takeLiquidity(tLiquidity);
883         _reflectFee(rFee, tFee);
884         emit Transfer(sender, recipient, tTransferAmount);
885     }
886 
887     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
888         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
889         _rOwned[sender] = _rOwned[sender].sub(rAmount);
890         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
891         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
892         _takeLiquidity(tLiquidity);
893         _reflectFee(rFee, tFee);
894         emit Transfer(sender, recipient, tTransferAmount);
895     }
896 
897     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
898         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
899         _tOwned[sender] = _tOwned[sender].sub(tAmount);
900         _rOwned[sender] = _rOwned[sender].sub(rAmount);
901         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
902         _takeLiquidity(tLiquidity);
903         _reflectFee(rFee, tFee);
904         emit Transfer(sender, recipient, tTransferAmount);
905     }
906 
907     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
908         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
909         _tOwned[sender] = _tOwned[sender].sub(tAmount);
910         _rOwned[sender] = _rOwned[sender].sub(rAmount);
911         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
912         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
913         _takeLiquidity(tLiquidity);
914         _reflectFee(rFee, tFee);
915         emit Transfer(sender, recipient, tTransferAmount);
916     }
917 
918     function _reflectFee(uint256 rFee, uint256 tFee) private {
919         _rTotal = _rTotal.sub(rFee);
920         _tFeeTotal = _tFeeTotal.add(tFee);
921     }
922 
923     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
924         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
925         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
926         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
927     }
928 
929     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
930         uint256 tFee = calculateTaxFee(tAmount);
931         uint256 tLiquidity = calculateLiquidityFee(tAmount);
932         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
933         return (tTransferAmount, tFee, tLiquidity);
934     }
935 
936     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
937         uint256 rAmount = tAmount.mul(currentRate);
938         uint256 rFee = tFee.mul(currentRate);
939         uint256 rLiquidity = tLiquidity.mul(currentRate);
940         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
941         return (rAmount, rTransferAmount, rFee);
942     }
943 
944     function _getRate() private view returns(uint256) {
945         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
946         return rSupply.div(tSupply);
947     }
948 
949      // enable cooldown between sells
950     function changeCooldownSettings(bool newStatus, uint256 newInterval) external onlyOwner {
951         require(newInterval <= 24 hours, "Exceeds the limit");
952         cooldownEnabled = newStatus;
953         cooldownTimerInterval = newInterval;
954     }
955 
956 
957     function _getCurrentSupply() private view returns(uint256, uint256) {
958         uint256 rSupply = _rTotal;
959         uint256 tSupply = _tTotal;      
960         for (uint256 i = 0; i < _excluded.length; i++) {
961             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
962             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
963             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
964         }
965         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
966         return (rSupply, tSupply);
967     }
968     
969     function _takeLiquidity(uint256 tLiquidity) private {
970         uint256 currentRate =  _getRate();
971         uint256 rLiquidity = tLiquidity.mul(currentRate);
972         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
973         if(_isExcluded[address(this)])
974             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
975     }
976     
977     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
978         return _amount.mul(reflectionFee).div(
979             10**3
980         );
981     }
982     
983     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
984         return _amount.mul(currenttotalFee).div(
985             10**3
986         );
987     }
988     
989     function excludeMultiple(address account) public onlyOwner {
990         _isExcludedFromFee[account] = true;
991     }
992 
993     function excludeFromFee(address[] calldata addresses) public onlyOwner {
994         for (uint256 i; i < addresses.length; ++i) {
995             _isExcludedFromFee[addresses[i]] = true;
996         }
997     }
998     
999     
1000     function includeInFee(address account) public onlyOwner {
1001         _isExcludedFromFee[account] = false;
1002     }
1003     
1004     function setWallets(address _marketingWallet,address _ecosystemWallet, address _devWallet) external onlyOwner() {
1005         marketingWallet = payable(_marketingWallet);
1006         devWallet = payable(_devWallet);
1007         ecosystemWallet = payable(_ecosystemWallet);
1008     }
1009 
1010 
1011     function transferToAddressETH(address payable recipient, uint256 amount) private {
1012         recipient.transfer(amount);
1013     }
1014     
1015     function isLocked(address account) public view returns (bool) {
1016         return _isSniper[account];
1017     }
1018     
1019     function manage_locked(address[] calldata addresses, bool status) public onlyOwner {
1020         for (uint256 i; i < addresses.length; ++i) {
1021             if(!_isTrusted[addresses[i]]){
1022                 _isSniper[addresses[i]] = status;
1023             }
1024         }
1025     }
1026 
1027     function setIsTimelockExempt(address holder, bool exempt) external onlyOwner {
1028         isTimelockExempt[holder] = exempt;
1029     }
1030 
1031     
1032     function manage_trusted(address[] calldata addresses) public onlyOwner {
1033         for (uint256 i; i < addresses.length; ++i) {
1034             _isTrusted[addresses[i]]=true;
1035         }
1036     }
1037         
1038     function withDrawLeftoverETH(address payable receipient) public onlyOwner {
1039         receipient.transfer(address(this).balance);
1040     }
1041 
1042     function withdrawStuckTokens(IERC20 token, address to) public onlyOwner {
1043         uint256 balance = token.balanceOf(address(this));
1044         token.transfer(to, balance);
1045     }
1046 
1047     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
1048         _maxWalletToken = _tTotal.div(1000).mul(maxWallPercent_base1000);
1049     }
1050 
1051     function setMaxSellPercent_base1000(uint256 maxSellPercent_base1000) external onlyOwner() {
1052         _maxSellLimit = _tTotal.div(1000).mul(maxSellPercent_base1000);
1053     }
1054 
1055     function setMaxWalletExempt(address _addr) external onlyOwner {
1056         _isMaxWalletExempt[_addr] = true;
1057     }
1058 
1059     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor) external onlyOwner {
1060         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
1061     }
1062 
1063     function distribute_airdrop(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
1064 
1065         require(addresses.length < 2001,"GAS Error: max airdrop limit is 2000 addresses"); // to prevent overflow
1066 
1067         uint256 SCCC = tokens* 10**_decimals * addresses.length;
1068 
1069         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
1070 
1071         for(uint i=0; i < addresses.length; i++){
1072             _transfer(from,addresses[i],(tokens* 10**_decimals));
1073             }
1074     }
1075 
1076      function setTaxesBuy(uint256 _reflectionFee, uint256 _liquidityFee, uint256 _marketingFee,uint256 _devFee,uint256 _ecosystemFee) external onlyOwner {
1077        
1078         _buyLiquidityFee = _liquidityFee;
1079         _buyMarketingFee = _marketingFee;
1080         _buyDevFee = _devFee;
1081         _buyReflectionFee= _reflectionFee;
1082 
1083         reflectionFee= _reflectionFee;
1084         liquidityFee = _liquidityFee;
1085         devFee = _devFee;
1086         marketingFee = _marketingFee;
1087         ecosystemFee=_ecosystemFee;
1088 
1089         totalFee = liquidityFee.add(marketingFee).add(devFee).add(ecosystemFee);
1090 
1091     }
1092 
1093     function setTaxesSell(uint256 _reflectionFee,uint256 _liquidityFee, uint256 _marketingFee,uint256 _devFee) external onlyOwner {
1094         _sellLiquidityFee = _liquidityFee;
1095         _sellMarketingFee = _marketingFee;
1096         _sellDevFee = _devFee;
1097         _sellReflectionFee= _reflectionFee;
1098     }
1099     
1100     receive() external payable {}
1101 }