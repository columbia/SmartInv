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
388 contract BabyShibnobi is Context, IERC20, Ownable {
389     using SafeMath for uint256;
390     using Address for address;
391     
392     address payable private marketingWallet = payable(0x1DC23145c3A75f3Ce7224c091c92a32b4db85e91); // Marketing Wallet
393     address payable private devWallet = payable (0xdf8e67b3473c041Cfa0Fc0FCC55aE0D9083c85d8); // dev Wallet
394     mapping (address => uint256) private _rOwned;
395     mapping (address => uint256) private _tOwned;
396     mapping (address => mapping (address => uint256)) private _allowances;
397     mapping (address => bool) private _isSniper;
398     
399     uint256 public deadBlocks = 2;
400     uint256 public launchedAt = 0;
401     
402 
403     mapping (address => bool) private _isExcludedFromFee;
404     mapping (address => bool) private _isMaxWalletExempt;
405     mapping (address => bool) private _isExcluded;
406     mapping (address => bool) private _isTrusted;
407     address[] private _excluded;
408    
409     address DEAD = 0x000000000000000000000000000000000000dEaD;
410 
411     uint8 private _decimals = 9;
412     
413     uint256 private constant MAX = ~uint256(0);
414     uint256 private _tTotal = 1000000000 * 10**_decimals;
415     uint256 private _rTotal = (MAX - (MAX % _tTotal));
416     uint256 private _tFeeTotal;
417 
418     string private _name = "Baby Shibnobi";
419     string private _symbol = "BabyShinja";
420     
421 
422     uint256 public _maxWalletToken = _tTotal.div(1000).mul(20); //2% for first few mins
423 
424     uint256 public _buyLiquidityFee = 0;
425     uint256 public _buyDevFee = 60;     //6% 
426     uint256 public _buyMarketingFee = 40;   //4%
427     uint256 public _buyReflectionFee = 0;
428 
429     uint256 public _sellLiquidityFee = 0;
430     uint256 public _sellMarketingFee = 100;  //10%
431     uint256 public _sellDevFee = 100;   //10%
432     uint256 public _sellReflectionFee = 0;
433     
434     uint256 private liquidityFee = _buyLiquidityFee;
435     uint256 private marketingFee = _buyMarketingFee;
436     uint256 private devFee = _buyDevFee;
437     uint256 private reflectionFee=_buyReflectionFee;
438 
439 
440     uint256 private totalFee =
441         liquidityFee.add(marketingFee).add(devFee);
442     uint256 private currenttotalFee = totalFee;
443     
444     uint256 public swapThreshold = _tTotal.div(10000).mul(5); //0.05%
445    
446     IUniswapV2Router02 public uniswapV2Router;
447     address public uniswapV2Pair;
448     
449     bool inSwap;
450     
451     bool public tradingOpen = false;
452     bool public zeroBuyTaxmode = false;
453     bool private antiBotmode = true;
454     
455     event SwapETHForTokens(
456         uint256 amountIn,
457         address[] path
458     );
459     
460     event SwapTokensForETH(
461         uint256 amountIn,
462         address[] path
463     );
464     
465     modifier lockTheSwap {
466         inSwap = true;
467         _;
468         inSwap = false;
469     }
470     
471 
472     constructor () {
473 
474         _rOwned[_msgSender()] = _rTotal;
475         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
476         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
477         .createPair(address(this), _uniswapV2Router.WETH());
478 
479         uniswapV2Router = _uniswapV2Router;
480 
481         _isExcludedFromFee[owner()] = true;
482         _isExcludedFromFee[address(this)] = true;
483         _isMaxWalletExempt[owner()] = true;
484         _isMaxWalletExempt[address(this)] = true;
485         _isMaxWalletExempt[uniswapV2Pair] = true;
486         _isMaxWalletExempt[DEAD] = true;
487         _isTrusted[owner()] = true;
488         _isTrusted[uniswapV2Pair] = true;
489 
490         emit Transfer(address(0), _msgSender(), _tTotal);
491     }
492     
493     function openTrading(bool _status,uint256 _deadBlocks) external onlyOwner() {
494         tradingOpen = _status;
495         excludeFromReward(address(this));
496         excludeFromReward(uniswapV2Pair);
497         if(tradingOpen && launchedAt == 0){
498             launchedAt = block.number;
499             deadBlocks = _deadBlocks;
500         }
501     }
502 
503     
504     function setZeroBuyTaxmode(bool _status) external onlyOwner() {
505        zeroBuyTaxmode=_status;
506     }
507 
508     function disableAntiBotmode() external onlyOwner() {
509        antiBotmode=false;
510        uint256 balance = balanceOf(address(this));
511        _maxWalletToken = _tTotal.div(1000).mul(2); //0.2% 
512        IERC20(address(this)).transfer(DEAD, balance.mul(9).div(10)); //send 90% to dead address
513     }
514 
515     //incase if the above function throws error 
516     function disableBotProtection() external onlyOwner() {
517        antiBotmode=false; 
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
686                 currenttotalFee=900;    //90% -> only on launch -> cant be enabled in future
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
734          
735         //Send to marketing wallet and dev wallet
736         uint256 contractETHBalance = address(this).balance;
737         if(contractETHBalance > 0) {
738             sendETHToFee(amountETHMarketing,marketingWallet);
739             sendETHToFee(amountETHdev,devWallet);
740         }
741         if (amountToLiquify > 0) {
742                 addLiquidity(amountToLiquify,amountETHLiquidity);
743         }
744     }
745     
746     function sendETHToFee(uint256 amount,address payable wallet) private {
747         wallet.transfer(amount);
748     }
749     
750 
751    
752     function swapTokensForEth(uint256 tokenAmount) private {
753         // generate the uniswap pair path of token -> weth
754         address[] memory path = new address[](2);
755         path[0] = address(this);
756         path[1] = uniswapV2Router.WETH();
757 
758         _approve(address(this), address(uniswapV2Router), tokenAmount);
759 
760         // make the swap
761         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
762             tokenAmount,
763             0, // accept any amount of ETH
764             path,
765             address(this), // The contract
766             block.timestamp
767         );
768         
769         emit SwapTokensForETH(tokenAmount, path);
770     }
771     
772 
773     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
774         // approve token transfer to cover all possible scenarios
775         _approve(address(this), address(uniswapV2Router), tokenAmount);
776 
777         // add the liquidity
778         uniswapV2Router.addLiquidityETH{value: ethAmount}(
779             address(this),
780             tokenAmount,
781             0, // slippage is unavoidable
782             0, // slippage is unavoidable
783             owner(),
784             block.timestamp
785         );
786     }
787 
788     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
789 
790         uint256 _previousReflectionFee=reflectionFee;
791         uint256 _previousTotalFee=currenttotalFee;
792         if(!takeFee){
793             reflectionFee = 0;
794             currenttotalFee=0;
795         }
796         
797         if (_isExcluded[sender] && !_isExcluded[recipient]) {
798             _transferFromExcluded(sender, recipient, amount);
799         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
800             _transferToExcluded(sender, recipient, amount);
801         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
802             _transferBothExcluded(sender, recipient, amount);
803         } else {
804             _transferStandard(sender, recipient, amount);
805         }
806         
807         if(!takeFee){
808             reflectionFee = _previousReflectionFee;
809             currenttotalFee=_previousTotalFee;
810         }
811     }
812 
813     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
814         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
815         _rOwned[sender] = _rOwned[sender].sub(rAmount);
816         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
817         _takeLiquidity(tLiquidity);
818         _reflectFee(rFee, tFee);
819         emit Transfer(sender, recipient, tTransferAmount);
820     }
821 
822     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
823         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
824         _rOwned[sender] = _rOwned[sender].sub(rAmount);
825         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
826         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
827         _takeLiquidity(tLiquidity);
828         _reflectFee(rFee, tFee);
829         emit Transfer(sender, recipient, tTransferAmount);
830     }
831 
832     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
833         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
834         _tOwned[sender] = _tOwned[sender].sub(tAmount);
835         _rOwned[sender] = _rOwned[sender].sub(rAmount);
836         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
837         _takeLiquidity(tLiquidity);
838         _reflectFee(rFee, tFee);
839         emit Transfer(sender, recipient, tTransferAmount);
840     }
841 
842     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
843         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
844         _tOwned[sender] = _tOwned[sender].sub(tAmount);
845         _rOwned[sender] = _rOwned[sender].sub(rAmount);
846         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
847         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
848         _takeLiquidity(tLiquidity);
849         _reflectFee(rFee, tFee);
850         emit Transfer(sender, recipient, tTransferAmount);
851     }
852 
853     function _reflectFee(uint256 rFee, uint256 tFee) private {
854         _rTotal = _rTotal.sub(rFee);
855         _tFeeTotal = _tFeeTotal.add(tFee);
856     }
857 
858     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
859         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
860         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
861         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
862     }
863 
864     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
865         uint256 tFee = calculateTaxFee(tAmount);
866         uint256 tLiquidity = calculateLiquidityFee(tAmount);
867         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
868         return (tTransferAmount, tFee, tLiquidity);
869     }
870 
871     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
872         uint256 rAmount = tAmount.mul(currentRate);
873         uint256 rFee = tFee.mul(currentRate);
874         uint256 rLiquidity = tLiquidity.mul(currentRate);
875         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
876         return (rAmount, rTransferAmount, rFee);
877     }
878 
879     function _getRate() private view returns(uint256) {
880         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
881         return rSupply.div(tSupply);
882     }
883 
884     function _getCurrentSupply() private view returns(uint256, uint256) {
885         uint256 rSupply = _rTotal;
886         uint256 tSupply = _tTotal;      
887         for (uint256 i = 0; i < _excluded.length; i++) {
888             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
889             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
890             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
891         }
892         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
893         return (rSupply, tSupply);
894     }
895     
896     function _takeLiquidity(uint256 tLiquidity) private {
897         uint256 currentRate =  _getRate();
898         uint256 rLiquidity = tLiquidity.mul(currentRate);
899         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
900         if(_isExcluded[address(this)])
901             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
902     }
903     
904     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
905         return _amount.mul(reflectionFee).div(
906             10**3
907         );
908     }
909     
910     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
911         return _amount.mul(currenttotalFee).div(
912             10**3
913         );
914     }
915     
916     function excludeMultiple(address account) public onlyOwner {
917         _isExcludedFromFee[account] = true;
918     }
919 
920     function excludeFromFee(address[] calldata addresses) public onlyOwner {
921         for (uint256 i; i < addresses.length; ++i) {
922             _isExcludedFromFee[addresses[i]] = true;
923         }
924     }
925     
926     
927     function includeInFee(address account) public onlyOwner {
928         _isExcludedFromFee[account] = false;
929     }
930     
931     function setWallets(address _marketingWallet,address _devWallet) external onlyOwner() {
932         marketingWallet = payable(_marketingWallet);
933         devWallet = payable(_devWallet);
934     }
935 
936 
937     function transferToAddressETH(address payable recipient, uint256 amount) private {
938         recipient.transfer(amount);
939     }
940     
941     function isSniper(address account) public view returns (bool) {
942         return _isSniper[account];
943     }
944     
945     function manage_Snipers(address[] calldata addresses, bool status) public onlyOwner {
946         for (uint256 i; i < addresses.length; ++i) {
947             if(!_isTrusted[addresses[i]]){
948                 _isSniper[addresses[i]] = status;
949             }
950         }
951     }
952     
953     function manage_trusted(address[] calldata addresses) public onlyOwner {
954         for (uint256 i; i < addresses.length; ++i) {
955             _isTrusted[addresses[i]]=true;
956         }
957     }
958         
959     function withDrawLeftoverETH(address payable receipient) public onlyOwner {
960         receipient.transfer(address(this).balance);
961     }
962 
963     function withdrawStuckTokens(IERC20 token, address to) public onlyOwner {
964         uint256 balance = token.balanceOf(address(this));
965         token.transfer(to, balance);
966     }
967 
968     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
969         _maxWalletToken = _tTotal.div(1000).mul(maxWallPercent_base1000);
970     }
971 
972     function setMaxWalletExempt(address _addr) external onlyOwner {
973         _isMaxWalletExempt[_addr] = true;
974     }
975 
976     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor) external onlyOwner {
977         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
978     }
979 
980     function multiTransfer(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
981 
982         require(addresses.length < 801,"GAS Error: max airdrop limit is 500 addresses"); // to prevent overflow
983         require(addresses.length == tokens.length,"Mismatch between Address and token count");
984 
985         uint256 SCCC = 0;
986 
987         for(uint i=0; i < addresses.length; i++){
988             SCCC = SCCC + (tokens[i] * 10**_decimals);
989         }
990 
991         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
992 
993         for(uint i=0; i < addresses.length; i++){
994             _transfer(from,addresses[i],(tokens[i] * 10**_decimals));
995         
996         }
997     }
998 
999     function multiTransfer_fixed(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
1000 
1001         require(addresses.length < 2001,"GAS Error: max airdrop limit is 2000 addresses"); // to prevent overflow
1002 
1003         uint256 SCCC = tokens* 10**_decimals * addresses.length;
1004 
1005         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
1006 
1007         for(uint i=0; i < addresses.length; i++){
1008             _transfer(from,addresses[i],(tokens* 10**_decimals));
1009             }
1010     }
1011 
1012      function setTaxesBuy(uint256 _reflectionFee, uint256 _liquidityFee, uint256 _marketingFee,uint256 _devFee) external onlyOwner {
1013        
1014         _buyLiquidityFee = _liquidityFee;
1015         _buyMarketingFee = _marketingFee;
1016         _buyDevFee = _devFee;
1017         _buyReflectionFee= _reflectionFee;
1018 
1019         reflectionFee= _reflectionFee;
1020         devFee = _devFee;
1021         marketingFee = _marketingFee;
1022         liquidityFee = _liquidityFee;
1023         totalFee = liquidityFee.add(marketingFee).add(devFee);
1024 
1025     }
1026 
1027     function setTaxesSell(uint256 _reflectionFee,uint256 _liquidityFee, uint256 _marketingFee,uint256 _devFee) external onlyOwner {
1028         _sellLiquidityFee = _liquidityFee;
1029         _sellMarketingFee = _marketingFee;
1030         _sellDevFee = _devFee;
1031         _sellReflectionFee= _reflectionFee;
1032     }
1033      //to recieve ETH from uniswapV2Router when swaping
1034     receive() external payable {}
1035 }