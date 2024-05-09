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
388 contract Emerald is Context, IERC20, Ownable {
389     using SafeMath for uint256;
390     using Address for address;
391     
392     address payable private marketingWallet = payable(0xb7B1B539Fcf6Ba2Be0cCd48f12aCb76e152B899b); // Marketing Wallet
393     address payable private devWallet = payable (0xb7B1B539Fcf6Ba2Be0cCd48f12aCb76e152B899b); // dev Wallet
394     mapping (address => uint256) private _rOwned;
395     mapping (address => uint256) private _tOwned;
396     mapping (address => mapping (address => uint256)) private _allowances;
397     mapping (address => bool) private _isSniper;
398     
399     uint256 public deadBlocks = 3;
400     uint256 public launchedAt = 0;
401     
402 
403     mapping (address => bool) private _isExcludedFromFee;
404     mapping (address => bool) private _isMaxWalletExempt;
405     mapping (address => bool) private _isExcluded;
406     address[] private _excluded;
407    
408     address DEAD = 0x000000000000000000000000000000000000dEaD;
409 
410     uint8 private _decimals = 9;
411     
412     uint256 private constant MAX = ~uint256(0);
413     uint256 private _tTotal = 300000000  * 10**_decimals;
414     uint256 private _rTotal = (MAX - (MAX % _tTotal));
415     uint256 private _tFeeTotal;
416 
417     string private _name = "Emerald";
418     string private _symbol = "EMD";
419     
420 
421     uint256 public _maxWalletToken = _tTotal.div(1000).mul(20); //2% for first few mins
422 
423     uint256 public _buyLiquidityFee = 10;
424     uint256 public _buyDevFee = 0;     //6% 
425     uint256 public _buyMarketingFee = 20;   //4%
426     uint256 public _buyReflectionFee = 0;
427 
428     uint256 public _sellLiquidityFee = 10;
429     uint256 public _sellMarketingFee = 40;  //10%
430     uint256 public _sellDevFee = 0;   //10%
431     uint256 public _sellReflectionFee = 0;
432     
433     uint256 private liquidityFee = _buyLiquidityFee;
434     uint256 private marketingFee = _buyMarketingFee;
435     uint256 private devFee = _buyDevFee;
436     uint256 private reflectionFee=_buyReflectionFee;
437 
438 
439     uint256 private totalFee =
440         liquidityFee.add(marketingFee).add(devFee);
441     uint256 private currenttotalFee = totalFee;
442     
443     uint256 public swapThreshold = _tTotal.div(1000).mul(3); //0.3%
444    
445     IUniswapV2Router02 public uniswapV2Router;
446     address public uniswapV2Pair;
447     
448     bool inSwap;
449     
450     bool public tradingOpen = false;
451     bool public zeroBuyTaxmode = false;
452     bool private antiBotmode = true;
453     
454     event SwapETHForTokens(
455         uint256 amountIn,
456         address[] path
457     );
458     
459     event SwapTokensForETH(
460         uint256 amountIn,
461         address[] path
462     );
463     
464     modifier lockTheSwap {
465         inSwap = true;
466         _;
467         inSwap = false;
468     }
469     
470 
471     constructor () {
472 
473         _rOwned[_msgSender()] = _rTotal;
474         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
475         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
476         .createPair(address(this), _uniswapV2Router.WETH());
477 
478         uniswapV2Router = _uniswapV2Router;
479 
480         _isExcludedFromFee[owner()] = true;
481         _isExcludedFromFee[address(this)] = true;
482         _isMaxWalletExempt[owner()] = true;
483         _isMaxWalletExempt[address(this)] = true;
484         _isMaxWalletExempt[uniswapV2Pair] = true;
485         _isMaxWalletExempt[DEAD] = true;
486 
487         emit Transfer(address(0), _msgSender(), _tTotal);
488     }
489     
490     function openTrading(bool _status,uint256 _deadBlocks) external onlyOwner() {
491         tradingOpen = _status;
492         excludeFromReward(address(this));
493         excludeFromReward(uniswapV2Pair);
494         if(tradingOpen && launchedAt == 0){
495             launchedAt = block.number;
496             deadBlocks = _deadBlocks;
497         }
498     }
499 
500     
501     function setZeroBuyTaxmode(bool _status) external onlyOwner() {
502        zeroBuyTaxmode=_status;
503     }
504 
505 
506     function disableBotProtection() external onlyOwner() {
507        antiBotmode=false; 
508     }
509     
510     function setNewRouter(address newRouter) external onlyOwner() {
511         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
512         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
513         if (get_pair == address(0)) {
514             uniswapV2Pair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
515         }
516         else {
517             uniswapV2Pair = get_pair;
518         }
519         uniswapV2Router = _newRouter;
520     }
521 
522     function name() public view returns (string memory) {
523         return _name;
524     }
525 
526     function symbol() public view returns (string memory) {
527         return _symbol;
528     }
529 
530     function decimals() public view returns (uint8) {
531         return _decimals;
532     }
533 
534     function totalSupply() public view override returns (uint256) {
535         return _tTotal;
536     }
537 
538     function balanceOf(address account) public view override returns (uint256) {
539         if (_isExcluded[account]) return _tOwned[account];
540         return tokenFromReflection(_rOwned[account]);
541     }
542 
543     function transfer(address recipient, uint256 amount) public override returns (bool) {
544         _transfer(_msgSender(), recipient, amount);
545         return true;
546     }
547 
548     function allowance(address owner, address spender) public view override returns (uint256) {
549         return _allowances[owner][spender];
550     }
551 
552     function approve(address spender, uint256 amount) public override returns (bool) {
553         _approve(_msgSender(), spender, amount);
554         return true;
555     }
556 
557     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
558         _transfer(sender, recipient, amount);
559         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
560         return true;
561     }
562 
563     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
564         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
565         return true;
566     }
567 
568     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
569         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
570         return true;
571     }
572 
573     function isExcludedFromReward(address account) public view returns (bool) {
574         return _isExcluded[account];
575     }
576 
577     function totalFees() public view returns (uint256) {
578         return _tFeeTotal;
579     }
580     
581     function deliver(uint256 tAmount) public {
582         address sender = _msgSender();
583         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
584         (uint256 rAmount,,,,,) = _getValues(tAmount);
585         _rOwned[sender] = _rOwned[sender].sub(rAmount);
586         _rTotal = _rTotal.sub(rAmount);
587         _tFeeTotal = _tFeeTotal.add(tAmount);
588     }
589   
590 
591     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
592         require(tAmount <= _tTotal, "Amount must be less than supply");
593         if (!deductTransferFee) {
594             (uint256 rAmount,,,,,) = _getValues(tAmount);
595             return rAmount;
596         } else {
597             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
598             return rTransferAmount;
599         }
600     }
601 
602     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
603         require(rAmount <= _rTotal, "Amount must be less than total reflections");
604         uint256 currentRate =  _getRate();
605         return rAmount.div(currentRate);
606     }
607 
608     function excludeFromReward(address account) public onlyOwner() {
609 
610         if(_rOwned[account] > 0) {
611             _tOwned[account] = tokenFromReflection(_rOwned[account]);
612         }
613         _isExcluded[account] = true;
614         _excluded.push(account);
615     }
616 
617     function includeInReward(address account) external onlyOwner() {
618         require(_isExcluded[account], "Account is already excluded");
619         for (uint256 i = 0; i < _excluded.length; i++) {
620             if (_excluded[i] == account) {
621                 _excluded[i] = _excluded[_excluded.length - 1];
622                 _tOwned[account] = 0;
623                 _isExcluded[account] = false;
624                 _excluded.pop();
625                 break;
626             }
627         }
628     }
629 
630     function _approve(address owner, address spender, uint256 amount) private {
631         require(owner != address(0), "ERC20: approve from the zero address");
632         require(spender != address(0), "ERC20: approve to the zero address");
633 
634         _allowances[owner][spender] = amount;
635         emit Approval(owner, spender, amount);
636     }
637 
638     function _transfer(
639         address from,
640         address to,
641         uint256 amount
642     ) private {
643         require(from != address(0), "ERC20: transfer from the zero address");
644         require(to != address(0), "ERC20: transfer to the zero address");
645         require(amount > 0, "Transfer amount must be greater than zero");
646         require(!_isSniper[from], "You have no power here!");
647         if (from!= owner() && to!= owner()) require(tradingOpen, "Trading not yet enabled."); //transfers disabled before openTrading
648         
649          bool takeFee = false;
650         //take fee only on swaps
651         if ( (from==uniswapV2Pair || to==uniswapV2Pair) && !(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {
652             takeFee = true;
653         }
654 
655         if(launchedAt>0 && (!_isMaxWalletExempt[to] && from!= owner()) && !((launchedAt + deadBlocks) > block.number)){
656                 require(amount+ balanceOf(to)<=_maxWalletToken,
657                     "Total Holding is currently limited");
658         }
659         
660 
661         currenttotalFee=totalFee;
662         reflectionFee=_buyReflectionFee;
663 
664         if(tradingOpen && to == uniswapV2Pair) { //sell
665             currenttotalFee= _sellLiquidityFee.add(_sellMarketingFee).add(_sellDevFee);
666             reflectionFee=_sellReflectionFee;
667         }
668         
669         //antibot - first 2 blocks
670         if(launchedAt>0 && (launchedAt + deadBlocks) > block.number){
671                 _isSniper[to]=true;
672         }
673         
674         //Punish high slippage bots for next - only bot txns go through here
675         if(launchedAt>0 && from!= owner() && block.number >= (launchedAt + deadBlocks)  && antiBotmode){
676                 currenttotalFee=900;    //90% -> only on launch -> cant be enabled in future
677         }
678 
679         if(zeroBuyTaxmode){
680              if(tradingOpen && from == uniswapV2Pair) { //buys
681                     currenttotalFee=0;
682              }
683         }
684 
685         //sell
686         if (!inSwap && tradingOpen && to == uniswapV2Pair) {
687       
688             uint256 contractTokenBalance = balanceOf(address(this));
689             
690             if(contractTokenBalance>=swapThreshold){
691                     contractTokenBalance = swapThreshold;
692                     swapTokens(contractTokenBalance);
693             }
694           
695         }
696         _tokenTransfer(from,to,amount,takeFee);
697     }
698 
699     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
700         
701         
702         uint256 amountToLiquify = contractTokenBalance
703             .mul(liquidityFee)
704             .div(totalFee)
705             .div(2);
706 
707         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
708         
709         swapTokensForEth(amountToSwap);
710 
711         uint256 amountETH = address(this).balance;
712 
713         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
714 
715         uint256 amountETHLiquidity = amountETH
716             .mul(liquidityFee)
717             .div(totalETHFee)
718             .div(2);
719         
720         uint256 amountETHdev = amountETH.mul(devFee).div(totalETHFee);
721         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(
722             totalETHFee
723         );
724          
725         //Send to marketing wallet and dev wallet
726         uint256 contractETHBalance = address(this).balance;
727         if(contractETHBalance > 0) {
728             sendETHToFee(amountETHMarketing,marketingWallet);
729             sendETHToFee(amountETHdev,devWallet);
730         }
731         if (amountToLiquify > 0) {
732                 addLiquidity(amountToLiquify,amountETHLiquidity);
733         }
734     }
735     
736     function sendETHToFee(uint256 amount,address payable wallet) private {
737         wallet.transfer(amount);
738     }
739     
740 
741    
742     function swapTokensForEth(uint256 tokenAmount) private {
743         // generate the uniswap pair path of token -> weth
744         address[] memory path = new address[](2);
745         path[0] = address(this);
746         path[1] = uniswapV2Router.WETH();
747 
748         _approve(address(this), address(uniswapV2Router), tokenAmount);
749 
750         // make the swap
751         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
752             tokenAmount,
753             0, // accept any amount of ETH
754             path,
755             address(this), // The contract
756             block.timestamp
757         );
758         
759         emit SwapTokensForETH(tokenAmount, path);
760     }
761     
762 
763     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
764         // approve token transfer to cover all possible scenarios
765         _approve(address(this), address(uniswapV2Router), tokenAmount);
766 
767         // add the liquidity
768         uniswapV2Router.addLiquidityETH{value: ethAmount}(
769             address(this),
770             tokenAmount,
771             0, // slippage is unavoidable
772             0, // slippage is unavoidable
773             owner(),
774             block.timestamp
775         );
776     }
777 
778     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
779 
780         uint256 _previousReflectionFee=reflectionFee;
781         uint256 _previousTotalFee=currenttotalFee;
782         if(!takeFee){
783             reflectionFee = 0;
784             currenttotalFee=0;
785         }
786         
787         if (_isExcluded[sender] && !_isExcluded[recipient]) {
788             _transferFromExcluded(sender, recipient, amount);
789         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
790             _transferToExcluded(sender, recipient, amount);
791         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
792             _transferBothExcluded(sender, recipient, amount);
793         } else {
794             _transferStandard(sender, recipient, amount);
795         }
796         
797         if(!takeFee){
798             reflectionFee = _previousReflectionFee;
799             currenttotalFee=_previousTotalFee;
800         }
801     }
802 
803     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
804         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
805         _rOwned[sender] = _rOwned[sender].sub(rAmount);
806         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
807         _takeLiquidity(tLiquidity);
808         _reflectFee(rFee, tFee);
809         emit Transfer(sender, recipient, tTransferAmount);
810     }
811 
812     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
813         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
814         _rOwned[sender] = _rOwned[sender].sub(rAmount);
815         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
816         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
817         _takeLiquidity(tLiquidity);
818         _reflectFee(rFee, tFee);
819         emit Transfer(sender, recipient, tTransferAmount);
820     }
821 
822     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
823         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
824         _tOwned[sender] = _tOwned[sender].sub(tAmount);
825         _rOwned[sender] = _rOwned[sender].sub(rAmount);
826         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
827         _takeLiquidity(tLiquidity);
828         _reflectFee(rFee, tFee);
829         emit Transfer(sender, recipient, tTransferAmount);
830     }
831 
832     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
833         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
834         _tOwned[sender] = _tOwned[sender].sub(tAmount);
835         _rOwned[sender] = _rOwned[sender].sub(rAmount);
836         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
837         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
838         _takeLiquidity(tLiquidity);
839         _reflectFee(rFee, tFee);
840         emit Transfer(sender, recipient, tTransferAmount);
841     }
842 
843     function _reflectFee(uint256 rFee, uint256 tFee) private {
844         _rTotal = _rTotal.sub(rFee);
845         _tFeeTotal = _tFeeTotal.add(tFee);
846     }
847 
848     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
849         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
850         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
851         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
852     }
853 
854     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
855         uint256 tFee = calculateTaxFee(tAmount);
856         uint256 tLiquidity = calculateLiquidityFee(tAmount);
857         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
858         return (tTransferAmount, tFee, tLiquidity);
859     }
860 
861     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
862         uint256 rAmount = tAmount.mul(currentRate);
863         uint256 rFee = tFee.mul(currentRate);
864         uint256 rLiquidity = tLiquidity.mul(currentRate);
865         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
866         return (rAmount, rTransferAmount, rFee);
867     }
868 
869     function _getRate() private view returns(uint256) {
870         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
871         return rSupply.div(tSupply);
872     }
873 
874     function _getCurrentSupply() private view returns(uint256, uint256) {
875         uint256 rSupply = _rTotal;
876         uint256 tSupply = _tTotal;      
877         for (uint256 i = 0; i < _excluded.length; i++) {
878             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
879             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
880             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
881         }
882         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
883         return (rSupply, tSupply);
884     }
885     
886     function _takeLiquidity(uint256 tLiquidity) private {
887         uint256 currentRate =  _getRate();
888         uint256 rLiquidity = tLiquidity.mul(currentRate);
889         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
890         if(_isExcluded[address(this)])
891             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
892     }
893     
894     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
895         return _amount.mul(reflectionFee).div(
896             10**3
897         );
898     }
899     
900     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
901         return _amount.mul(currenttotalFee).div(
902             10**3
903         );
904     }
905     
906     function excludeMultiple(address account) public onlyOwner {
907         _isExcludedFromFee[account] = true;
908     }
909 
910     function excludeFromFee(address[] calldata addresses) public onlyOwner {
911         for (uint256 i; i < addresses.length; ++i) {
912             _isExcludedFromFee[addresses[i]] = true;
913         }
914     }
915     
916     
917     function includeInFee(address account) public onlyOwner {
918         _isExcludedFromFee[account] = false;
919     }
920     
921     function setWallets(address _marketingWallet,address _devWallet) external onlyOwner() {
922         marketingWallet = payable(_marketingWallet);
923         devWallet = payable(_devWallet);
924     }
925 
926 
927     function transferToAddressETH(address payable recipient, uint256 amount) private {
928         recipient.transfer(amount);
929     }
930     
931     function isSniper(address account) public view returns (bool) {
932         return _isSniper[account];
933     }
934     
935     function manage_Snipers(address[] calldata addresses, bool status) public onlyOwner {
936         for (uint256 i; i < addresses.length; ++i) {
937                 _isSniper[addresses[i]] = status;
938         }
939     }
940     
941     function withDrawLeftoverETH(address payable receipient) public onlyOwner {
942         receipient.transfer(address(this).balance);
943     }
944 
945     function withdrawStuckTokens(IERC20 token, address to) public onlyOwner {
946         uint256 balance = token.balanceOf(address(this));
947         token.transfer(to, balance);
948     }
949 
950     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner() {
951         _maxWalletToken = _tTotal.div(1000).mul(maxWallPercent_base1000);
952     }
953 
954     function setMaxWalletExempt(address _addr) external onlyOwner {
955         _isMaxWalletExempt[_addr] = true;
956     }
957 
958     function setSwapSettings(uint256 thresholdPercent, uint256 thresholdDivisor) external onlyOwner {
959         swapThreshold = (_tTotal * thresholdPercent) / thresholdDivisor;
960     }
961 
962     function airdrop(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
963 
964         require(addresses.length < 2001,"GAS Error: max airdrop limit is 2000 addresses"); // to prevent overflow
965 
966         uint256 SCCC = tokens* 10**_decimals * addresses.length;
967 
968         require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
969 
970         for(uint i=0; i < addresses.length; i++){
971             _transfer(from,addresses[i],(tokens* 10**_decimals));
972             }
973     }
974 
975      function setTaxesBuy(uint256 _reflectionFee, uint256 _liquidityFee, uint256 _marketingFee,uint256 _devFee) external onlyOwner {
976        
977         _buyLiquidityFee = _liquidityFee;
978         _buyMarketingFee = _marketingFee;
979         _buyDevFee = _devFee;
980         _buyReflectionFee= _reflectionFee;
981 
982         reflectionFee= _reflectionFee;
983         devFee = _devFee;
984         marketingFee = _marketingFee;
985         liquidityFee = _liquidityFee;
986         totalFee = liquidityFee.add(marketingFee).add(devFee);
987 
988     }
989 
990     function setTaxesSell(uint256 _reflectionFee,uint256 _liquidityFee, uint256 _marketingFee,uint256 _devFee) external onlyOwner {
991         _sellLiquidityFee = _liquidityFee;
992         _sellMarketingFee = _marketingFee;
993         _sellDevFee = _devFee;
994         _sellReflectionFee= _reflectionFee;
995     }
996      //to recieve ETH from uniswapV2Router when swaping
997     receive() external payable {}
998 }