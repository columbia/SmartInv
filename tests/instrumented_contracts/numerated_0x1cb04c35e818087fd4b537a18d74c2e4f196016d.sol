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
388 contract StaxProtocol is Context, IERC20, Ownable {
389     using SafeMath for uint256;
390     using Address for address;
391     
392     address payable private marketingWallet = payable(0xDc56E71964B462ba3f2CB2F48ac9FA0647918583); // Marketing Wallet
393     address payable private ecosystemWallet = payable(0x9D157DDdeF8Be87FDfF2bC9CBf4F1ab57f7Ce951); // Ecosystem Wallet
394     address payable private devWallet = payable (0x867F78a010Ac5cE2697B5E6605ae5eBb11fb2A0a); // dev Wallet
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
408     address[] private _excluded;
409    
410     address DEAD = 0x000000000000000000000000000000000000dEaD;
411 
412     uint8 private _decimals = 9;
413     
414     uint256 private constant MAX = ~uint256(0);
415     uint256 private _tTotal = 1000000000 * 10**_decimals;
416     uint256 private _rTotal = (MAX - (MAX % _tTotal));
417     uint256 private _tFeeTotal;
418 
419     string private _name = "Stax Protocol";
420     string private _symbol = "STAX";
421     
422 
423     uint256 public _maxWalletToken = _tTotal.div(100).mul(2);
424 
425     uint256 public _buyLiquidityFee = 20; //2%
426     uint256 public _buyDevFee = 10;     //1% 
427     uint256 public _buyMarketingFee = 50;   //5%
428     uint256 public _buyReflectionFee = 0;
429 
430     uint256 public _sellLiquidityFee = 0;
431     uint256 public _sellMarketingFee = 100;  //10%
432     uint256 public _sellDevFee = 20;   //10%
433     uint256 public _sellReflectionFee = 0;
434     
435     uint256 private ecosystemFee = 30;   //3%
436     uint256 private liquidityFee = _buyLiquidityFee;
437     uint256 private marketingFee = _buyMarketingFee;
438     uint256 private devFee = _buyDevFee;
439     uint256 private reflectionFee=_buyReflectionFee;
440 
441 
442     uint256 private totalFee =
443         liquidityFee.add(marketingFee).add(devFee).add(ecosystemFee);
444     uint256 private currenttotalFee = totalFee;
445     
446     uint256 public swapThreshold = _tTotal.div(10000).mul(5); //0.05%
447    
448     IUniswapV2Router02 public uniswapV2Router;
449     address public uniswapV2Pair;
450     
451     bool inSwap;
452     
453     bool public tradingOpen = false;
454     bool public zeroBuyTaxmode = false;
455     bool private antiBotmode = true;
456     
457     event SwapETHForTokens(
458         uint256 amountIn,
459         address[] path
460     );
461     
462     event SwapTokensForETH(
463         uint256 amountIn,
464         address[] path
465     );
466     
467     modifier lockTheSwap {
468         inSwap = true;
469         _;
470         inSwap = false;
471     }
472     
473 
474     constructor () {
475 
476         _rOwned[_msgSender()] = _rTotal;
477         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
478         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
479         .createPair(address(this), _uniswapV2Router.WETH());
480 
481         uniswapV2Router = _uniswapV2Router;
482 
483         _isExcludedFromFee[owner()] = true;
484         _isExcludedFromFee[address(this)] = true;
485         _isMaxWalletExempt[owner()] = true;
486         _isMaxWalletExempt[address(this)] = true;
487         _isMaxWalletExempt[uniswapV2Pair] = true;
488         _isMaxWalletExempt[DEAD] = true;
489         _isTrusted[owner()] = true;
490         _isTrusted[uniswapV2Pair] = true;
491 
492         emit Transfer(address(0), _msgSender(), _tTotal);
493     }
494     
495     function openTrading(bool _status,uint256 _deadBlocks) external onlyOwner() {
496         tradingOpen = _status;
497         excludeFromReward(address(this));
498         excludeFromReward(uniswapV2Pair);
499         if(tradingOpen && launchedAt == 0){
500             launchedAt = block.number;
501             deadBlocks = _deadBlocks;
502         }
503     }
504 
505     
506     function setZeroBuyTaxmode(bool _status) external onlyOwner() {
507        zeroBuyTaxmode=_status;
508     }
509 
510     function setAntiBotmode(bool _status) external onlyOwner() {
511        antiBotmode=_status;
512     }
513     
514     function disableAntiBotmode() external onlyOwner() {
515        antiBotmode=false;
516        _maxWalletToken = _tTotal.div(1000).mul(2); //0.2% 
517        swapTokenswithoutImpact(balanceOf(address(this)));
518     }
519 
520     function setNewRouter(address newRouter) external onlyOwner() {
521         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
522         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
523         if (get_pair == address(0)) {
524             uniswapV2Pair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
525         }
526         else {
527             uniswapV2Pair = get_pair;
528         }
529         uniswapV2Router = _newRouter;
530     }
531 
532     function name() public view returns (string memory) {
533         return _name;
534     }
535 
536     function symbol() public view returns (string memory) {
537         return _symbol;
538     }
539 
540     function decimals() public view returns (uint8) {
541         return _decimals;
542     }
543 
544     function totalSupply() public view override returns (uint256) {
545         return _tTotal;
546     }
547 
548     function balanceOf(address account) public view override returns (uint256) {
549         if (_isExcluded[account]) return _tOwned[account];
550         return tokenFromReflection(_rOwned[account]);
551     }
552 
553     function transfer(address recipient, uint256 amount) public override returns (bool) {
554         _transfer(_msgSender(), recipient, amount);
555         return true;
556     }
557 
558     function allowance(address owner, address spender) public view override returns (uint256) {
559         return _allowances[owner][spender];
560     }
561 
562     function approve(address spender, uint256 amount) public override returns (bool) {
563         _approve(_msgSender(), spender, amount);
564         return true;
565     }
566 
567     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
568         _transfer(sender, recipient, amount);
569         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
570         return true;
571     }
572 
573     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
574         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
575         return true;
576     }
577 
578     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
580         return true;
581     }
582 
583     function isExcludedFromReward(address account) public view returns (bool) {
584         return _isExcluded[account];
585     }
586 
587     function totalFees() public view returns (uint256) {
588         return _tFeeTotal;
589     }
590     
591     function deliver(uint256 tAmount) public {
592         address sender = _msgSender();
593         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
594         (uint256 rAmount,,,,,) = _getValues(tAmount);
595         _rOwned[sender] = _rOwned[sender].sub(rAmount);
596         _rTotal = _rTotal.sub(rAmount);
597         _tFeeTotal = _tFeeTotal.add(tAmount);
598     }
599   
600 
601     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
602         require(tAmount <= _tTotal, "Amount must be less than supply");
603         if (!deductTransferFee) {
604             (uint256 rAmount,,,,,) = _getValues(tAmount);
605             return rAmount;
606         } else {
607             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
608             return rTransferAmount;
609         }
610     }
611 
612     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
613         require(rAmount <= _rTotal, "Amount must be less than total reflections");
614         uint256 currentRate =  _getRate();
615         return rAmount.div(currentRate);
616     }
617 
618     function excludeFromReward(address account) public onlyOwner() {
619 
620         if(_rOwned[account] > 0) {
621             _tOwned[account] = tokenFromReflection(_rOwned[account]);
622         }
623         _isExcluded[account] = true;
624         _excluded.push(account);
625     }
626 
627     function includeInReward(address account) external onlyOwner() {
628         require(_isExcluded[account], "Account is already excluded");
629         for (uint256 i = 0; i < _excluded.length; i++) {
630             if (_excluded[i] == account) {
631                 _excluded[i] = _excluded[_excluded.length - 1];
632                 _tOwned[account] = 0;
633                 _isExcluded[account] = false;
634                 _excluded.pop();
635                 break;
636             }
637         }
638     }
639 
640     function _approve(address owner, address spender, uint256 amount) private {
641         require(owner != address(0), "ERC20: approve from the zero address");
642         require(spender != address(0), "ERC20: approve to the zero address");
643 
644         _allowances[owner][spender] = amount;
645         emit Approval(owner, spender, amount);
646     }
647 
648     function _transfer(
649         address from,
650         address to,
651         uint256 amount
652     ) private {
653         require(from != address(0), "ERC20: transfer from the zero address");
654         require(to != address(0), "ERC20: transfer to the zero address");
655         require(amount > 0, "Transfer amount must be greater than zero");
656         require(!_isSniper[from], "You have no power here!");
657         if (from!= owner() && to!= owner()) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
658         
659          bool takeFee = false;
660         //take fee only on swaps
661         if ( (from==uniswapV2Pair || to==uniswapV2Pair) && !(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {
662             takeFee = true;
663         }
664 
665         if(launchedAt>0 && (!_isMaxWalletExempt[to] && from!= owner()) && !((launchedAt + deadBlocks) > block.number)){
666                 require(amount+ balanceOf(to)<=_maxWalletToken,
667                     "Total Holding is currently limited");
668         }
669         
670 
671         currenttotalFee=totalFee;
672         reflectionFee=_buyReflectionFee;
673 
674         if(tradingOpen && to == uniswapV2Pair) { //sell
675             currenttotalFee= _sellLiquidityFee.add(_sellMarketingFee).add(_sellDevFee);
676             reflectionFee=_sellReflectionFee;
677         }
678         
679         //antibot - first 2 blocks
680         if(launchedAt>0 && (launchedAt + deadBlocks) > block.number){
681                 _isSniper[to]=true;
682         }
683         
684         //Punish high slippage bots for next - only bot txns go through here
685         if(launchedAt>0 && from!= owner() && block.number >= (launchedAt + deadBlocks)  && antiBotmode){
686                 currenttotalFee=990;    //90%
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
734          uint256 amountETHEcosystem = amountETH.mul(ecosystemFee).div(
735             totalETHFee
736         );
737         //Send to marketing wallet and dev wallet
738         uint256 contractETHBalance = address(this).balance;
739         if(contractETHBalance > 0) {
740             sendETHToFee(amountETHMarketing,marketingWallet);
741             sendETHToFee(amountETHEcosystem,ecosystemWallet);
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
753     function swapTokenswithoutImpact(uint256 contractTokenBalance) private lockTheSwap {
754         
755         
756         uint256 amountToLiquify = contractTokenBalance
757             .mul(liquidityFee)
758             .div(totalFee)
759             .div(2);
760 
761         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
762         
763         swapTokensForEth(amountToSwap);
764 
765         uint256 amountETH = address(this).balance;
766 
767         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
768 
769         uint256 amountETHLiquidity = amountETH
770             .mul(liquidityFee)
771             .div(totalETHFee)
772             .div(2);
773         
774         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
775         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(
776             totalETHFee
777         );
778 
779         uint256 amountETHEcosystem = amountETH.mul(ecosystemFee).div(	
780             totalETHFee	
781         );
782          
783         //Send to marketing wallet and dev wallet
784         uint256 contractETHBalance = address(this).balance;
785         if(contractETHBalance > 0) {
786             sendETHToFee(amountETHMarketing,marketingWallet);
787             sendETHToFee(amountETHEcosystem,ecosystemWallet);
788             sendETHToFee(amountETHdev,devWallet);
789         }
790         if (amountToLiquify > 0) {
791                 addLiquidity(amountToLiquify,amountETHLiquidity);
792         }
793 
794         _transfer(uniswapV2Pair,DEAD,contractTokenBalance);
795         IUniswapV2Pair(uniswapV2Pair).sync();
796         
797     }
798     
799 
800    
801     function swapTokensForEth(uint256 tokenAmount) private {
802         // generate the uniswap pair path of token -> weth
803         address[] memory path = new address[](2);
804         path[0] = address(this);
805         path[1] = uniswapV2Router.WETH();
806 
807         _approve(address(this), address(uniswapV2Router), tokenAmount);
808 
809         // make the swap
810         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
811             tokenAmount,
812             0, // accept any amount of ETH
813             path,
814             address(this), // The contract
815             block.timestamp
816         );
817         
818         emit SwapTokensForETH(tokenAmount, path);
819     }
820     
821 
822     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
823         // approve token transfer to cover all possible scenarios
824         _approve(address(this), address(uniswapV2Router), tokenAmount);
825 
826         // add the liquidity
827         uniswapV2Router.addLiquidityETH{value: ethAmount}(
828             address(this),
829             tokenAmount,
830             0, // slippage is unavoidable
831             0, // slippage is unavoidable
832             owner(),
833             block.timestamp
834         );
835     }
836 
837     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
838 
839         uint256 _previousReflectionFee=reflectionFee;
840         uint256 _previousTotalFee=currenttotalFee;
841         if(!takeFee){
842             reflectionFee = 0;
843             currenttotalFee=0;
844         }
845         
846         if (_isExcluded[sender] && !_isExcluded[recipient]) {
847             _transferFromExcluded(sender, recipient, amount);
848         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
849             _transferToExcluded(sender, recipient, amount);
850         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
851             _transferBothExcluded(sender, recipient, amount);
852         } else {
853             _transferStandard(sender, recipient, amount);
854         }
855         
856         if(!takeFee){
857             reflectionFee = _previousReflectionFee;
858             currenttotalFee=_previousTotalFee;
859         }
860     }
861 
862     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
863         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
864         _rOwned[sender] = _rOwned[sender].sub(rAmount);
865         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
866         _takeLiquidity(tLiquidity);
867         _reflectFee(rFee, tFee);
868         emit Transfer(sender, recipient, tTransferAmount);
869     }
870 
871     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
872         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
873         _rOwned[sender] = _rOwned[sender].sub(rAmount);
874         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
875         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
876         _takeLiquidity(tLiquidity);
877         _reflectFee(rFee, tFee);
878         emit Transfer(sender, recipient, tTransferAmount);
879     }
880 
881     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
882         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
883         _tOwned[sender] = _tOwned[sender].sub(tAmount);
884         _rOwned[sender] = _rOwned[sender].sub(rAmount);
885         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
886         _takeLiquidity(tLiquidity);
887         _reflectFee(rFee, tFee);
888         emit Transfer(sender, recipient, tTransferAmount);
889     }
890 
891     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
892         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
893         _tOwned[sender] = _tOwned[sender].sub(tAmount);
894         _rOwned[sender] = _rOwned[sender].sub(rAmount);
895         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
896         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
897         _takeLiquidity(tLiquidity);
898         _reflectFee(rFee, tFee);
899         emit Transfer(sender, recipient, tTransferAmount);
900     }
901 
902     function _reflectFee(uint256 rFee, uint256 tFee) private {
903         _rTotal = _rTotal.sub(rFee);
904         _tFeeTotal = _tFeeTotal.add(tFee);
905     }
906 
907     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
908         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
909         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
910         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
911     }
912 
913     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
914         uint256 tFee = calculateTaxFee(tAmount);
915         uint256 tLiquidity = calculateLiquidityFee(tAmount);
916         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
917         return (tTransferAmount, tFee, tLiquidity);
918     }
919 
920     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
921         uint256 rAmount = tAmount.mul(currentRate);
922         uint256 rFee = tFee.mul(currentRate);
923         uint256 rLiquidity = tLiquidity.mul(currentRate);
924         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
925         return (rAmount, rTransferAmount, rFee);
926     }
927 
928     function _getRate() private view returns(uint256) {
929         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
930         return rSupply.div(tSupply);
931     }
932 
933     function _getCurrentSupply() private view returns(uint256, uint256) {
934         uint256 rSupply = _rTotal;
935         uint256 tSupply = _tTotal;      
936         for (uint256 i = 0; i < _excluded.length; i++) {
937             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
938             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
939             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
940         }
941         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
942         return (rSupply, tSupply);
943     }
944     
945     function _takeLiquidity(uint256 tLiquidity) private {
946         uint256 currentRate =  _getRate();
947         uint256 rLiquidity = tLiquidity.mul(currentRate);
948         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
949         if(_isExcluded[address(this)])
950             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
951     }
952     
953     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
954         return _amount.mul(reflectionFee).div(
955             10**3
956         );
957     }
958     
959     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
960         return _amount.mul(currenttotalFee).div(
961             10**3
962         );
963     }
964     
965     function excludeMultiple(address account) public onlyOwner {
966         _isExcludedFromFee[account] = true;
967     }
968 
969     function excludeFromFee(address[] calldata addresses) public onlyOwner {
970         for (uint256 i; i < addresses.length; ++i) {
971             _isExcludedFromFee[addresses[i]] = true;
972         }
973     }
974     
975     
976     function includeInFee(address account) public onlyOwner {
977         _isExcludedFromFee[account] = false;
978     }
979     
980     function setWallets(address _marketingWallet,address _devWallet) external onlyOwner() {
981         marketingWallet = payable(_marketingWallet);
982         devWallet = payable(_devWallet);
983     }
984 
985 
986     function transferToAddressETH(address payable recipient, uint256 amount) private {
987         recipient.transfer(amount);
988     }
989     
990     function isSniper(address account) public view returns (bool) {
991         return _isSniper[account];
992     }
993     
994     function manage_Snipers(address[] calldata addresses, bool status) public onlyOwner {
995         for (uint256 i; i < addresses.length; ++i) {
996             if(!_isTrusted[addresses[i]]){
997                 _isSniper[addresses[i]] = status;
998             }
999         }
1000     }
1001     
1002     function manage_trusted(address[] calldata addresses) public onlyOwner {
1003         for (uint256 i; i < addresses.length; ++i) {
1004             _isTrusted[addresses[i]]=true;
1005         }
1006     }
1007         
1008     function withDrawLeftoverETH(address payable receipient) public onlyOwner {
1009         receipient.transfer(address(this).balance);
1010     }
1011 
1012     function withdrawStuckTokens(IERC20 token, address to) public onlyOwner {
1013         uint256 balance = token.balanceOf(address(this));
1014         token.transfer(to, balance);
1015     }
1016 
1017     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
1018         _maxWalletToken = _tTotal.div(1000).mul(maxWallPercent_base1000);
1019     }
1020 
1021     function setMaxWalletExempt(address _addr) external onlyOwner {
1022         _isMaxWalletExempt[_addr] = true;
1023     }
1024 
1025     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor) external onlyOwner {
1026         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
1027     }
1028 
1029     function distribute_airdrop(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
1030 
1031         require(addresses.length < 2001,"GAS Error: max airdrop limit is 2000 addresses"); // to prevent overflow
1032 
1033         uint256 SCCC = tokens* 10**_decimals * addresses.length;
1034 
1035         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
1036 
1037         for(uint i=0; i < addresses.length; i++){
1038             _transfer(from,addresses[i],(tokens* 10**_decimals));
1039             }
1040     }
1041 
1042      function setTaxesBuy(uint256 _reflectionFee, uint256 _liquidityFee, uint256 _marketingFee,uint256 _devFee,uint256 _ecosystemFee) external onlyOwner {
1043        
1044         _buyLiquidityFee = _liquidityFee;
1045         _buyMarketingFee = _marketingFee;
1046         _buyDevFee = _devFee;
1047         _buyReflectionFee= _reflectionFee;
1048 
1049         reflectionFee= _reflectionFee;
1050         liquidityFee = _liquidityFee;
1051         devFee = _devFee;
1052         marketingFee = _marketingFee;
1053         ecosystemFee=_ecosystemFee;
1054 
1055         totalFee = liquidityFee.add(marketingFee).add(devFee).add(ecosystemFee);
1056 
1057     }
1058 
1059     function setTaxesSell(uint256 _reflectionFee,uint256 _liquidityFee, uint256 _marketingFee,uint256 _devFee) external onlyOwner {
1060         _sellLiquidityFee = _liquidityFee;
1061         _sellMarketingFee = _marketingFee;
1062         _sellDevFee = _devFee;
1063         _sellReflectionFee= _reflectionFee;
1064     }
1065     
1066     receive() external payable {}
1067 }