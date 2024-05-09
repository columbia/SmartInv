1 // SPDX-License-Identifier: UNLICENSED
2 /*
3 
4 WICK FINANCE
5 
6 */
7 
8 
9 pragma solidity ^0.6.12;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address payable) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes memory) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 
23 interface IERC20 {
24 
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33     
34 
35 }
36 
37 library SafeMath {
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42 
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53 
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61 
62         uint256 c = a * b;
63         require(c / a == b, "SafeMath: multiplication overflow");
64 
65         return c;
66     }
67 
68 
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         return div(a, b, "SafeMath: division by zero");
71     }
72 
73     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b > 0, errorMessage);
75         uint256 c = a / b;
76         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77 
78         return c;
79     }
80 
81     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82         return mod(a, b, "SafeMath: modulo by zero");
83     }
84 
85     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         require(b != 0, errorMessage);
87         return a % b;
88     }
89 }
90 
91 library Address {
92 
93     function isContract(address account) internal view returns (bool) {
94         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
95         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
96         // for accounts without code, i.e. `keccak256('')`
97         bytes32 codehash;
98         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
99         // solhint-disable-next-line no-inline-assembly
100         assembly { codehash := extcodehash(account) }
101         return (codehash != accountHash && codehash != 0x0);
102     }
103 
104     function sendValue(address payable recipient, uint256 amount) internal {
105         require(address(this).balance >= amount, "Address: insufficient balance");
106 
107         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
108         (bool success, ) = recipient.call{ value: amount }("");
109         require(success, "Address: unable to send value, recipient may have reverted");
110     }
111 
112 
113     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
114       return functionCall(target, data, "Address: low-level call failed");
115     }
116 
117     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
118         return _functionCallWithValue(target, data, 0, errorMessage);
119     }
120 
121     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
126         require(address(this).balance >= value, "Address: insufficient balance for call");
127         return _functionCallWithValue(target, data, value, errorMessage);
128     }
129 
130     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
131         require(isContract(target), "Address: call to non-contract");
132 
133         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
134         if (success) {
135             return returndata;
136         } else {
137             
138             if (returndata.length > 0) {
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
150 contract Ownable is Context {
151     address private _owner;
152     address private _previousOwner;
153     uint256 private _lockTime;
154 
155     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157     constructor () internal {
158         address msgSender = _msgSender();
159         _owner = msgSender;
160         emit OwnershipTransferred(address(0), msgSender);
161     }
162 
163     function owner() public view returns (address) {
164         return _owner;
165     }
166 
167     modifier onlyOwner() {
168         require(_owner == _msgSender(), "Ownable: caller is not the owner");
169         _;
170     }
171 
172     function renounceOwnership() public virtual onlyOwner {
173         emit OwnershipTransferred(_owner, address(0));
174         _owner = address(0);
175     }
176 
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         emit OwnershipTransferred(_owner, newOwner);
180         _owner = newOwner;
181     }
182 
183     function getUnlockTime() public view returns (uint256) {
184         return _lockTime;
185     }
186     
187     //Added function
188     // 1 minute = 60
189     // 1h 3600
190     // 24h 86400
191     // 1w 604800
192     
193     function getTime() public view returns (uint256) {
194         return now;
195     }
196 
197     function lock(uint256 time) public virtual onlyOwner {
198         _previousOwner = _owner;
199         _owner = address(0);
200         _lockTime = now + time;
201         emit OwnershipTransferred(_owner, address(0));
202     }
203     
204     function unlock() public virtual {
205         require(_previousOwner == msg.sender, "You don't have permission to unlock");
206         require(now > _lockTime , "Contract is locked until 7 days");
207         emit OwnershipTransferred(_owner, _previousOwner);
208         _owner = _previousOwner;
209     }
210 }
211 
212 // pragma solidity >=0.5.0;
213 
214 interface IUniswapV2Factory {
215     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
216 
217     function feeTo() external view returns (address);
218     function feeToSetter() external view returns (address);
219 
220     function getPair(address tokenA, address tokenB) external view returns (address pair);
221     function allPairs(uint) external view returns (address pair);
222     function allPairsLength() external view returns (uint);
223 
224     function createPair(address tokenA, address tokenB) external returns (address pair);
225 
226     function setFeeTo(address) external;
227     function setFeeToSetter(address) external;
228 }
229 
230 
231 // pragma solidity >=0.5.0;
232 
233 interface IUniswapV2Pair {
234     event Approval(address indexed owner, address indexed spender, uint value);
235     event Transfer(address indexed from, address indexed to, uint value);
236 
237     function name() external pure returns (string memory);
238     function symbol() external pure returns (string memory);
239     function decimals() external pure returns (uint8);
240     function totalSupply() external view returns (uint);
241     function balanceOf(address owner) external view returns (uint);
242     function allowance(address owner, address spender) external view returns (uint);
243 
244     function approve(address spender, uint value) external returns (bool);
245     function transfer(address to, uint value) external returns (bool);
246     function transferFrom(address from, address to, uint value) external returns (bool);
247 
248     function DOMAIN_SEPARATOR() external view returns (bytes32);
249     function PERMIT_TYPEHASH() external pure returns (bytes32);
250     function nonces(address owner) external view returns (uint);
251 
252     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
253     
254     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
255     event Swap(
256         address indexed sender,
257         uint amount0In,
258         uint amount1In,
259         uint amount0Out,
260         uint amount1Out,
261         address indexed to
262     );
263     event Sync(uint112 reserve0, uint112 reserve1);
264 
265     function MINIMUM_LIQUIDITY() external pure returns (uint);
266     function factory() external view returns (address);
267     function token0() external view returns (address);
268     function token1() external view returns (address);
269     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
270     function price0CumulativeLast() external view returns (uint);
271     function price1CumulativeLast() external view returns (uint);
272     function kLast() external view returns (uint);
273 
274     function burn(address to) external returns (uint amount0, uint amount1);
275     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
276     function skim(address to) external;
277     function sync() external;
278 
279     function initialize(address, address) external;
280 }
281 
282 // pragma solidity >=0.6.2;
283 
284 interface IUniswapV2Router01 {
285     function factory() external pure returns (address);
286     function WETH() external pure returns (address);
287 
288     function addLiquidity(
289         address tokenA,
290         address tokenB,
291         uint amountADesired,
292         uint amountBDesired,
293         uint amountAMin,
294         uint amountBMin,
295         address to,
296         uint deadline
297     ) external returns (uint amountA, uint amountB, uint liquidity);
298     function addLiquidityETH(
299         address token,
300         uint amountTokenDesired,
301         uint amountTokenMin,
302         uint amountETHMin,
303         address to,
304         uint deadline
305     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
306     function removeLiquidity(
307         address tokenA,
308         address tokenB,
309         uint liquidity,
310         uint amountAMin,
311         uint amountBMin,
312         address to,
313         uint deadline
314     ) external returns (uint amountA, uint amountB);
315     function removeLiquidityETH(
316         address token,
317         uint liquidity,
318         uint amountTokenMin,
319         uint amountETHMin,
320         address to,
321         uint deadline
322     ) external returns (uint amountToken, uint amountETH);
323     function removeLiquidityWithPermit(
324         address tokenA,
325         address tokenB,
326         uint liquidity,
327         uint amountAMin,
328         uint amountBMin,
329         address to,
330         uint deadline,
331         bool approveMax, uint8 v, bytes32 r, bytes32 s
332     ) external returns (uint amountA, uint amountB);
333     function removeLiquidityETHWithPermit(
334         address token,
335         uint liquidity,
336         uint amountTokenMin,
337         uint amountETHMin,
338         address to,
339         uint deadline,
340         bool approveMax, uint8 v, bytes32 r, bytes32 s
341     ) external returns (uint amountToken, uint amountETH);
342     function swapExactTokensForTokens(
343         uint amountIn,
344         uint amountOutMin,
345         address[] calldata path,
346         address to,
347         uint deadline
348     ) external returns (uint[] memory amounts);
349     function swapTokensForExactTokens(
350         uint amountOut,
351         uint amountInMax,
352         address[] calldata path,
353         address to,
354         uint deadline
355     ) external returns (uint[] memory amounts);
356     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
357         external
358         payable
359         returns (uint[] memory amounts);
360     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
361         external
362         returns (uint[] memory amounts);
363     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
364         external
365         returns (uint[] memory amounts);
366     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
367         external
368         payable
369         returns (uint[] memory amounts);
370 
371     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
372     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
373     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
374     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
375     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
376 }
377 
378 
379 
380 // pragma solidity >=0.6.2;
381 
382 interface IUniswapV2Router02 is IUniswapV2Router01 {
383     function removeLiquidityETHSupportingFeeOnTransferTokens(
384         address token,
385         uint liquidity,
386         uint amountTokenMin,
387         uint amountETHMin,
388         address to,
389         uint deadline
390     ) external returns (uint amountETH);
391     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
392         address token,
393         uint liquidity,
394         uint amountTokenMin,
395         uint amountETHMin,
396         address to,
397         uint deadline,
398         bool approveMax, uint8 v, bytes32 r, bytes32 s
399     ) external returns (uint amountETH);
400 
401     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
402         uint amountIn,
403         uint amountOutMin,
404         address[] calldata path,
405         address to,
406         uint deadline
407     ) external;
408     function swapExactETHForTokensSupportingFeeOnTransferTokens(
409         uint amountOutMin,
410         address[] calldata path,
411         address to,
412         uint deadline
413     ) external payable;
414     function swapExactTokensForETHSupportingFeeOnTransferTokens(
415         uint amountIn,
416         uint amountOutMin,
417         address[] calldata path,
418         address to,
419         uint deadline
420     ) external;
421 }
422 
423 
424 contract WICKFINANCE is Context, IERC20, Ownable {
425     using SafeMath for uint256;
426     using Address for address;
427 
428     mapping (address => uint256) private _rOwned;
429     mapping (address => uint256) private _tOwned;
430     mapping (address => mapping (address => uint256)) private _allowances;
431 
432     mapping (address => bool) private _isExcludedFromFee;
433 
434     mapping (address => bool) private _isExcluded;
435     address[] private _excluded;
436    
437     uint256 private constant MAX = ~uint256(0);
438     uint256 private _tTotal = 1000000000000 * 10**18;
439     uint256 private _rTotal = (MAX - (MAX % _tTotal));
440     uint256 private _tFeeTotal;
441     uint256 private _tBurnTotal;
442     uint256 private _tInnovationTotal;
443 
444     string private _name = "WICK FINANCE";
445     string private _symbol = "WICK";
446     uint8 private _decimals = 18;
447 
448 
449     uint256 public _taxFee = 5;
450     uint256 private _previousTaxFee = _taxFee;
451     
452     uint256 public _burnFee = 5;
453     uint256 private _previousBurnFee = _burnFee;
454     
455     
456     uint256 public _innovationFee = 5;
457     uint256 private _previousInnovationFee = _innovationFee;
458     
459     uint256 public _maxTxAmount = 10000000000 * 10**18;
460     uint256 private minimumTokensBeforeSwap = 10000000000 * 10**18; 
461     
462     address payable public innovationAddress = 0xd6cE27BFd2b5981d379C6e86086c6D53cBd5B41E; // Innovation wallet
463     
464         
465     IUniswapV2Router02 public immutable uniswapV2Router;
466     address public immutable uniswapV2Pair;
467     
468     bool inSwapAndLiquify;
469     bool public swapAndLiquifyEnabled = true;
470     
471     event RewardLiquidityProviders(uint256 tokenAmount);
472     event SwapAndLiquifyEnabledUpdated(bool enabled);
473     event SwapAndLiquify(
474         uint256 tokensSwapped,
475         uint256 ethReceived,
476         uint256 tokensIntoLiqudity
477     );
478     
479     modifier lockTheSwap {
480         inSwapAndLiquify = true;
481         _;
482         inSwapAndLiquify = false;
483     }
484     
485     constructor () public {
486         _rOwned[_msgSender()] = _rTotal;
487         
488         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
489         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
490             .createPair(address(this), _uniswapV2Router.WETH());
491 
492         uniswapV2Router = _uniswapV2Router;
493         
494         _isExcludedFromFee[owner()] = true;
495         _isExcludedFromFee[address(this)] = true;
496         
497         emit Transfer(address(0), _msgSender(), _tTotal);
498     }
499 
500     function name() public view returns (string memory) {
501         return _name;
502     }
503 
504     function symbol() public view returns (string memory) {
505         return _symbol;
506     }
507 
508     function decimals() public view returns (uint8) {
509         return _decimals;
510     }
511 
512     function totalSupply() public view override returns (uint256) {
513         return _tTotal;
514     }
515 
516     function balanceOf(address account) public view override returns (uint256) {
517         if (_isExcluded[account]) return _tOwned[account];
518         return tokenFromReflection(_rOwned[account]);
519     }
520 
521     function transfer(address recipient, uint256 amount) public override returns (bool) {
522         _transfer(_msgSender(), recipient, amount);
523         return true;
524     }
525 
526     function allowance(address owner, address spender) public view override returns (uint256) {
527         return _allowances[owner][spender];
528     }
529 
530     function approve(address spender, uint256 amount) public override returns (bool) {
531         _approve(_msgSender(), spender, amount);
532         return true;
533     }
534 
535     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
536         _transfer(sender, recipient, amount);
537         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
538         return true;
539     }
540 
541     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
542         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
543         return true;
544     }
545 
546     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
547         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
548         return true;
549     }
550 
551     function isExcludedFromReward(address account) public view returns (bool) {
552         return _isExcluded[account];
553     }
554 
555     function totalFees() public view returns (uint256) {
556         return _tFeeTotal;
557     }
558     
559     function totalBurn() public view returns (uint256) {
560         return _tBurnTotal;
561     }
562     
563     function totalInnovationETH() public view returns (uint256) {
564         // ETH has  18 decimals!
565         return _tInnovationTotal;
566     }
567 
568     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
569         return minimumTokensBeforeSwap;
570     }
571 
572     function deliver(uint256 tAmount) public {
573         address sender = _msgSender();
574         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
575         (uint256 rAmount,,,,,,) = _getValues(tAmount);
576         _rOwned[sender] = _rOwned[sender].sub(rAmount);
577         _rTotal = _rTotal.sub(rAmount);
578         _tFeeTotal = _tFeeTotal.add(tAmount);
579     }
580   
581 
582     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
583         require(tAmount <= _tTotal, "Amount must be less than supply");
584         if (!deductTransferFee) {
585             (uint256 rAmount,,,,,,) = _getValues(tAmount);
586             return rAmount;
587         } else {
588             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
589             return rTransferAmount;
590         }
591     }
592 
593     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
594         require(rAmount <= _rTotal, "Amount must be less than total reflections");
595         uint256 currentRate =  _getRate();
596         return rAmount.div(currentRate);
597     }
598 
599     function excludeFromReward(address account) public onlyOwner() {
600         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
601         require(!_isExcluded[account], "Account is already excluded");
602         if(_rOwned[account] > 0) {
603             _tOwned[account] = tokenFromReflection(_rOwned[account]);
604         }
605         _isExcluded[account] = true;
606         _excluded.push(account);
607     }
608 
609     function includeInReward(address account) external onlyOwner() {
610         require(_isExcluded[account], "Account is already excluded");
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
622     function _approve(address owner, address spender, uint256 amount) private {
623         require(owner != address(0), "ERC20: approve from the zero address");
624         require(spender != address(0), "ERC20: approve to the zero address");
625 
626         _allowances[owner][spender] = amount;
627         emit Approval(owner, spender, amount);
628     }
629 
630     function _transfer(
631         address from,
632         address to,
633         uint256 amount
634     ) private {
635         require(from != address(0), "ERC20: transfer from the zero address");
636         require(to != address(0), "ERC20: transfer to the zero address");
637         require(amount > 0, "Transfer amount must be greater than zero");
638         if(from != owner() && to != owner())
639             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
640 
641 
642         uint256 contractTokenBalance = balanceOf(address(this));
643         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
644         if (
645             overMinimumTokenBalance &&
646             !inSwapAndLiquify &&
647             from != uniswapV2Pair &&
648             swapAndLiquifyEnabled
649         ) {
650             contractTokenBalance = minimumTokensBeforeSwap;
651             swapAndLiquify(contractTokenBalance);
652         }
653         
654 
655         bool takeFee = true;
656         
657         //if any account belongs to _isExcludedFromFee account then remove the fee
658         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
659             takeFee = false;
660         }
661         
662         _tokenTransfer(from,to,amount,takeFee);
663     }
664 
665     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
666         swapTokensForEth(contractTokenBalance); 
667         _tInnovationTotal = _tInnovationTotal.add(address(this).balance);
668         TransferInnovationETH(innovationAddress, address(this).balance);
669     }
670 
671     function swapTokensForEth(uint256 tokenAmount) private {
672         // generate the uniswap pair path of token -> weth
673         address[] memory path = new address[](2);
674         path[0] = address(this);
675         path[1] = uniswapV2Router.WETH();
676 
677         _approve(address(this), address(uniswapV2Router), tokenAmount);
678 
679         // make the swap
680         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
681             tokenAmount,
682             0, // accept any amount of ETH
683             path,
684             address(this), // The contract
685             block.timestamp
686         );
687     }
688 
689 
690     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
691         if(!takeFee)
692             removeAllFee();
693         
694         if (_isExcluded[sender] && !_isExcluded[recipient]) {
695             _transferFromExcluded(sender, recipient, amount);
696         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
697             _transferToExcluded(sender, recipient, amount);
698         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
699             _transferStandard(sender, recipient, amount);
700         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
701             _transferBothExcluded(sender, recipient, amount);
702         } else {
703             _transferStandard(sender, recipient, amount);
704         }
705         
706         if(!takeFee)
707             restoreAllFee();
708     }
709 
710     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
711         uint256 currentRate =  _getRate();
712         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
713         uint256 rBurn =  tBurn.mul(currentRate);
714         _rOwned[sender] = _rOwned[sender].sub(rAmount);
715         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
716         _takeLiquidity(tLiquidity);
717         _reflectFee(rFee, rBurn, tFee, tBurn);
718         emit Transfer(sender, recipient, tTransferAmount);
719     }
720 
721     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
722         uint256 currentRate =  _getRate();
723         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
724         uint256 rBurn =  tBurn.mul(currentRate);
725         _rOwned[sender] = _rOwned[sender].sub(rAmount);
726         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
727         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
728         _takeLiquidity(tLiquidity);
729         _reflectFee(rFee, rBurn, tFee, tBurn);
730         emit Transfer(sender, recipient, tTransferAmount);
731     }
732 
733     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
734         uint256 currentRate =  _getRate();
735         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
736         uint256 rBurn =  tBurn.mul(currentRate);
737         _tOwned[sender] = _tOwned[sender].sub(tAmount);
738         _rOwned[sender] = _rOwned[sender].sub(rAmount);
739         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
740         _takeLiquidity(tLiquidity);
741         _reflectFee(rFee, rBurn, tFee, tBurn);
742         emit Transfer(sender, recipient, tTransferAmount);
743     }
744 
745     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
746         uint256 currentRate =  _getRate();
747         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
748         uint256 rBurn =  tBurn.mul(currentRate);
749         _tOwned[sender] = _tOwned[sender].sub(tAmount);
750         _rOwned[sender] = _rOwned[sender].sub(rAmount);
751         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
752         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
753         _takeLiquidity(tLiquidity);
754         _reflectFee(rFee, rBurn, tFee, tBurn);
755         emit Transfer(sender, recipient, tTransferAmount);
756     }
757 
758     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
759         _rTotal = _rTotal.sub(rFee).sub(rBurn);
760         _tFeeTotal = _tFeeTotal.add(tFee);
761         _tBurnTotal = _tBurnTotal.add(tBurn);
762         _tTotal = _tTotal.sub(tBurn);
763     }
764 
765     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
766         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getTValues(tAmount);
767         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, tLiquidity, _getRate());
768         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tLiquidity);
769     }
770 
771     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
772         uint256 tFee = calculateTaxFee(tAmount);
773         uint256 tBurn = calculateBurnFee(tAmount);
774         uint256 tLiquidity = calculateLiquidityFee(tAmount);
775         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn).sub(tLiquidity);
776         return (tTransferAmount, tFee, tBurn, tLiquidity);
777     }
778 
779     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
780         uint256 rAmount = tAmount.mul(currentRate);
781         uint256 rFee = tFee.mul(currentRate);
782         uint256 rBurn = tBurn.mul(currentRate);
783         uint256 rLiquidity = tLiquidity.mul(currentRate);
784         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn).sub(rLiquidity);
785         return (rAmount, rTransferAmount, rFee);
786     }
787 
788     function _getRate() private view returns(uint256) {
789         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
790         return rSupply.div(tSupply);
791     }
792 
793     function _getCurrentSupply() private view returns(uint256, uint256) {
794         uint256 rSupply = _rTotal;
795         uint256 tSupply = _tTotal;      
796         for (uint256 i = 0; i < _excluded.length; i++) {
797             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
798             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
799             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
800         }
801         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
802         return (rSupply, tSupply);
803     }
804     
805     function _takeLiquidity(uint256 tLiquidity) private {
806         uint256 currentRate =  _getRate();
807         uint256 rLiquidity = tLiquidity.mul(currentRate);
808         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
809         if(_isExcluded[address(this)])
810             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
811     }
812     
813     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
814         return _amount.mul(_taxFee).div(
815             10**2
816         );
817     }
818     
819     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
820         return _amount.mul(_burnFee).div(
821             10**2
822         );
823     }
824     
825     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
826         return _amount.mul(_innovationFee).div(
827             10**2
828         );
829     }
830     
831     function removeAllFee() private {
832         if(_taxFee == 0 && _burnFee == 0 && _innovationFee == 0) return;
833         
834         _previousTaxFee = _taxFee;
835         _previousBurnFee = _burnFee;
836         _previousInnovationFee = _innovationFee;
837         
838         _taxFee = 0;
839         _burnFee = 0;
840         _innovationFee = 0;
841     }
842     
843     function restoreAllFee() private {
844         _taxFee = _previousTaxFee;
845         _burnFee = _previousBurnFee;
846         _innovationFee = _previousInnovationFee;
847     }
848 
849     function isExcludedFromFee(address account) public view returns(bool) {
850         return _isExcludedFromFee[account];
851     }
852     
853     function excludeFromFee(address account) public onlyOwner {
854         _isExcludedFromFee[account] = true;
855     }
856     
857     function includeInFee(address account) public onlyOwner {
858         _isExcludedFromFee[account] = false;
859     }
860     
861     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
862         _taxFee = taxFee;
863     }
864     
865     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
866         _burnFee = burnFee;
867     }
868     
869     function setInnovationFeePercent(uint256 InnovationFee) external onlyOwner() {
870         _innovationFee = InnovationFee;
871     }
872     
873     function setMaxTxPercent(uint256 maxTxPercent, uint256 maxTxDecimals) external onlyOwner() {
874         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
875             10**(uint256(maxTxDecimals) + 2)
876         );
877     }
878 
879     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
880         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
881     }
882 
883     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
884         swapAndLiquifyEnabled = _enabled;
885         emit SwapAndLiquifyEnabledUpdated(_enabled);
886     }
887     
888     
889     function TransferInnovationETH(address payable recipient, uint256 amount) private {
890         recipient.transfer(amount);
891     }
892     
893     
894      //to recieve ETH from uniswapV2Router when swaping
895     receive() external payable {}
896 }