1 /**
2  * author: BlockCzech R&D Lab <info@blockczech.io>
3  * 
4  * 
5  *░░████████╗░█████╗░░██████╗░░░░█████╗░░█████╗░██╗███╗░░██╗░░██████╗░░░░░█████╗░░░
6  *░░╚══██╔══╝██╔══██╗██╔════╝░░░██╔══██╗██╔══██╗██║████╗░██║░░╚════██╗░░░██╔══██╗░░
7  *░░░░░██║░░░██║░░╚═╝██║░░██╗░░░██║░░╚═╝██║░░██║██║██╔██╗██║░░░░███╔═╝░░░██║░░██║░░
8  *░░░░░██║░░░██║░░██╗██║░░╚██╗░░██║░░██╗██║░░██║██║██║╚████║░░██╔══╝░░░░░██║░░██║░░
9  *░░░░░██║░░░╚█████╔╝╚██████╔╝░░╚█████╔╝╚█████╔╝██║██║░╚███║░░███████╗██╗╚█████╔╝░░
10  *░░░░░╚═╝░░░░╚════╝░░╚═════╝░░░░╚════╝░░╚════╝░╚═╝╚═╝░░╚══╝░░╚══════╝╚═╝░╚════╝░░░
11  *
12  * 
13  * The TCGCoin20 [ETH] is based on the Automatic Liquidity Pool & Custom Fees Architecture.
14  *
15  * 
16  * SPDX-License-Identifier: MIT
17  * 
18  */
19 
20 pragma solidity 0.8.11;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 interface IUniswapV2Factory {
33     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
34 
35     function feeTo() external view returns (address);
36     function feeToSetter() external view returns (address);
37 
38     function getPair(address tokenA, address tokenB) external view returns (address pair);
39     function allPairs(uint) external view returns (address pair);
40     function allPairsLength() external view returns (uint);
41 
42     function createPair(address tokenA, address tokenB) external returns (address pair);
43 
44     function setFeeTo(address) external;
45     function setFeeToSetter(address) external;
46 
47     function INIT_CODE_PAIR_HASH() external view returns (bytes32);
48 }
49 
50 interface IUniswapV2Router01 {
51     function factory() external pure returns (address);
52     function WETH() external pure returns (address);
53 
54     function addLiquidity(
55         address tokenA,
56         address tokenB,
57         uint amountADesired,
58         uint amountBDesired,
59         uint amountAMin,
60         uint amountBMin,
61         address to,
62         uint deadline
63     ) external returns (uint amountA, uint amountB, uint liquidity);
64 
65     function addLiquidityETH(
66         address token,
67         uint amountTokenDesired,
68         uint amountTokenMin,
69         uint amountETHMin,
70         address to,
71         uint deadline
72     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
73 
74     function removeLiquidity(
75         address tokenA,
76         address tokenB,
77         uint liquidity,
78         uint amountAMin,
79         uint amountBMin,
80         address to,
81         uint deadline
82     ) external returns (uint amountA, uint amountB);
83 
84     function removeLiquidityETH(
85         address token,
86         uint liquidity,
87         uint amountTokenMin,
88         uint amountETHMin,
89         address to,
90         uint deadline
91     ) external returns (uint amountToken, uint amountETH);
92 
93     function removeLiquidityWithPermit(
94         address tokenA,
95         address tokenB,
96         uint liquidity,
97         uint amountAMin,
98         uint amountBMin,
99         address to,
100         uint deadline,
101         bool approveMax, uint8 v, bytes32 r, bytes32 s
102     ) external returns (uint amountA, uint amountB);
103 
104     function removeLiquidityETHWithPermit(
105         address token,
106         uint liquidity,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline,
111         bool approveMax, uint8 v, bytes32 r, bytes32 s
112     ) external returns (uint amountToken, uint amountETH);
113 
114     function swapExactTokensForTokens(
115         uint amountIn,
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external returns (uint[] memory amounts);
121 
122     function swapTokensForExactTokens(
123         uint amountOut,
124         uint amountInMax,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external returns (uint[] memory amounts);
129 
130     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
131         external
132         payable
133         returns (uint[] memory amounts);
134 
135     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
136         external
137         returns (uint[] memory amounts);
138 
139     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
140         external
141         returns (uint[] memory amounts);
142 
143     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
144         external
145         payable
146         returns (uint[] memory amounts);
147 
148     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
149     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
150     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
151     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
152     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
153 }
154 
155 interface IUniswapV2Router02 is IUniswapV2Router01 {
156     function removeLiquidityETHSupportingFeeOnTransferTokens(
157         address token,
158         uint liquidity,
159         uint amountTokenMin,
160         uint amountETHMin,
161         address to,
162         uint deadline
163     ) external returns (uint amountETH);
164     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
165         address token,
166         uint liquidity,
167         uint amountTokenMin,
168         uint amountETHMin,
169         address to,
170         uint deadline,
171         bool approveMax, uint8 v, bytes32 r, bytes32 s
172     ) external returns (uint amountETH);
173     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
174         uint amountIn,
175         uint amountOutMin,
176         address[] calldata path,
177         address to,
178         uint deadline
179     ) external;
180     function swapExactETHForTokensSupportingFeeOnTransferTokens(
181         uint amountOutMin,
182         address[] calldata path,
183         address to,
184         uint deadline
185     ) external payable;
186     function swapExactTokensForETHSupportingFeeOnTransferTokens(
187         uint amountIn,
188         uint amountOutMin,
189         address[] calldata path,
190         address to,
191         uint deadline
192     ) external;
193 }
194 
195 interface IUniswapV2Pair {
196     event Approval(address indexed owner, address indexed spender, uint value);
197     event Transfer(address indexed from, address indexed to, uint value);
198 
199     function name() external pure returns (string memory);
200     function symbol() external pure returns (string memory);
201     function decimals() external pure returns (uint8);
202     function totalSupply() external view returns (uint);
203     function balanceOf(address owner) external view returns (uint);
204     function allowance(address owner, address spender) external view returns (uint);
205     function approve(address spender, uint value) external returns (bool);
206     function transfer(address to, uint value) external returns (bool);
207     function transferFrom(address from, address to, uint value) external returns (bool);
208 
209     function DOMAIN_SEPARATOR() external view returns (bytes32);
210     function PERMIT_TYPEHASH() external pure returns (bytes32);
211     function nonces(address owner) external view returns (uint);
212     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
213 
214     event Mint(address indexed sender, uint amount0, uint amount1);
215     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
216     event Swap(
217         address indexed sender,
218         uint amount0In,
219         uint amount1In,
220         uint amount0Out,
221         uint amount1Out,
222         address indexed to
223     );
224     event Sync(uint112 reserve0, uint112 reserve1);
225 
226     function MINIMUM_LIQUIDITY() external pure returns (uint);
227     function factory() external view returns (address);
228     function token0() external view returns (address);
229     function token1() external view returns (address);
230     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
231     function price0CumulativeLast() external view returns (uint);
232     function price1CumulativeLast() external view returns (uint);
233     function kLast() external view returns (uint);
234     function mint(address to) external returns (uint liquidity);
235     function burn(address to) external returns (uint amount0, uint amount1);
236     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
237     function skim(address to) external;
238     function sync() external;
239     function initialize(address, address) external;
240 }
241 
242 library SafeMath {
243 
244     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
245         unchecked {
246             uint256 c = a + b;
247             if (c < a) return (false, 0);
248             return (true, c);
249         }
250     }
251 
252     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
253         unchecked {
254             if (b > a) return (false, 0);
255             return (true, a - b);
256         }
257     }
258 
259     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
260         unchecked {
261             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
262             // benefit is lost if 'b' is also tested.
263             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
264             if (a == 0) return (true, 0);
265             uint256 c = a * b;
266             if (c / a != b) return (false, 0);
267             return (true, c);
268         }
269     }
270 
271     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
272         unchecked {
273             if (b == 0) return (false, 0);
274             return (true, a / b);
275         }
276     }
277 
278     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
279         unchecked {
280             if (b == 0) return (false, 0);
281             return (true, a % b);
282         }
283     }
284 
285     function add(uint256 a, uint256 b) internal pure returns (uint256) {
286         return a + b;
287     }
288 
289     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
290         return a - b;
291     }
292 
293     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
294         return a * b;
295     }
296 
297     function div(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a / b;
299     }
300 
301     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
302         return a % b;
303     }
304 
305     function sub(
306         uint256 a,
307         uint256 b,
308         string memory errorMessage
309     ) internal pure returns (uint256) {
310         unchecked {
311             require(b <= a, errorMessage);
312             return a - b;
313         }
314     }
315 
316     function div(
317         uint256 a,
318         uint256 b,
319         string memory errorMessage
320     ) internal pure returns (uint256) {
321         unchecked {
322             require(b > 0, errorMessage);
323             return a / b;
324         }
325     }
326 
327     function mod(
328         uint256 a,
329         uint256 b,
330         string memory errorMessage
331     ) internal pure returns (uint256) {
332         unchecked {
333             require(b > 0, errorMessage);
334             return a % b;
335         }
336     }
337 }
338 
339 contract Ownable is Context {
340     address private _owner;
341     address private _previousOwner;
342     uint256 private _lockTime;
343 
344     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
345 
346     constructor () {
347         address msgSender = _msgSender();
348         _owner = msgSender;
349         emit OwnershipTransferred(address(0), msgSender);
350     }
351 
352     function owner() public view returns (address) {
353         return _owner;
354     }
355 
356     modifier onlyOwner() {
357         require(_owner == _msgSender(), "Ownable: caller is not the owner");
358         _;
359     }
360 
361     function renounceOwnership() public virtual onlyOwner {
362         emit OwnershipTransferred(_owner, address(0));
363         _owner = address(0);
364     }
365 
366     function transferOwnership(address newOwner) public virtual onlyOwner {
367         require(newOwner != address(0), "Ownable: new owner is the zero address");
368         emit OwnershipTransferred(_owner, newOwner);
369         _owner = newOwner;
370     }
371 
372     function getUnlockTime() public view returns (uint256) {
373         return _lockTime;
374     }
375 
376     function lock(uint256 time) public virtual onlyOwner {
377         _previousOwner = _owner;
378         _owner = address(0);
379         _lockTime = block.timestamp + time;
380         emit OwnershipTransferred(_owner, address(0));
381     }
382 
383     function unlock() public virtual {
384         require(_previousOwner == msg.sender, "You don't have permission to unlock");
385         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
386         emit OwnershipTransferred(_owner, _previousOwner);
387         _owner = _previousOwner;
388     }
389 }
390 
391 library Address {
392 
393     function isContract(address account) internal view returns (bool) {
394         bytes32 codehash;
395         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
396         // solhint-disable-next-line no-inline-assembly
397         assembly { codehash := extcodehash(account) }
398         return (codehash != accountHash && codehash != 0x0);
399     }
400 
401     function sendValue(address payable recipient, uint256 amount) internal {
402         require(address(this).balance >= amount, "Address: insufficient balance");
403 
404         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
405         (bool success, ) = recipient.call{ value: amount }("");
406         require(success, "Address: unable to send value, recipient may have reverted");
407     }
408 
409         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
410       return functionCall(target, data, "Address: low-level call failed");
411     }
412 
413     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
414         return _functionCallWithValue(target, data, 0, errorMessage);
415     }
416 
417     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
418         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
419     }
420 
421     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
422         require(address(this).balance >= value, "Address: insufficient balance for call");
423         return _functionCallWithValue(target, data, value, errorMessage);
424     }
425 
426     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
427         require(isContract(target), "Address: call to non-contract");
428 
429         // solhint-disable-next-line avoid-low-level-calls
430         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
431         if (success) {
432             return returndata;
433         } else {
434             // Look for revert reason and bubble it up if present
435             if (returndata.length > 0) {
436                 // The easiest way to bubble the revert reason is using memory via assembly
437 
438                 // solhint-disable-next-line no-inline-assembly
439                 assembly {
440                     let returndata_size := mload(returndata)
441                     revert(add(32, returndata), returndata_size)
442                 }
443             } else {
444                 revert(errorMessage);
445             }
446         }
447     }
448 }
449 
450 interface IERC20 {
451     function totalSupply() external view returns (uint256);
452     function balanceOf(address account) external view returns (uint256);
453     function transfer(address recipient, uint256 amount) external returns (bool);
454     function allowance(address owner, address spender) external view returns (uint256);
455     function approve(address spender, uint256 amount) external returns (bool);
456     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
457     event Transfer(address indexed from, address indexed to, uint256 value);
458     event Approval(address indexed owner, address indexed spender, uint256 value);
459 }
460 
461 
462 contract ethTCGCoin20 is Context, IERC20, Ownable {
463     using Address for address;
464     using SafeMath for uint256;
465 
466     mapping (address => uint256) private _reflectOwned;
467     mapping (address => uint256) private _takeOwned;
468     mapping (address => mapping (address => uint256)) private _allowances;
469 
470     mapping (address => bool) private _isExcludedFromFee;
471     mapping (address => bool) private _isExcluded;
472     mapping (address => bool) private _isBot;
473     address[] private _excluded;
474 
475     mapping (address => bool) private _isDEXBuyFee;
476     mapping (address => bool) private _isDEXSellFee;
477 
478     uint256 private constant MAX = ~uint256(0);
479     uint256 private _takeTotal = 280 * 10**6 * 10**9;
480     uint256 private _reflectTotal = (MAX - (MAX % _takeTotal));
481     uint256 private _takeFeeTotal;
482 
483     string private constant _name = "TCG 2.0 ETH";
484     string private constant _symbol = "ethTCG2";
485     uint8 private constant _decimals = 9;
486 
487     bool public _taxFeeFlag = false;
488 
489     uint256 public _taxFee = 0;
490     uint256 private _previousTaxFee = _taxFee;
491 
492     uint256 public _liquidityFee = 10;
493     uint256 private _previousLiquidityFee = _liquidityFee;
494 
495     uint256 public _liquiditySellFee = 10;
496     uint256 private _previousLiquiditySellFee = _liquiditySellFee;
497 
498 
499     IUniswapV2Router02 public uniswapRouter;
500     address public uniswapPair;
501 
502     bool public isIntoLiquifySwap;
503     bool public swapAndLiquifyEnabled = true;
504 
505     uint256 private _maxLoopCount = 100;
506 
507 
508     uint256 public _maximumValueOfTransaction = 280 * 10**6 * 10**9 ;
509     uint256 public numTokensSellToAddToLiquidity = 10 * 10**9 ;
510 
511     event SwapAndLiquifyEvent(
512         uint256 coinsForSwapping,
513         uint256 bnbIsReceived,
514         uint256 coinsThatWasAddedIntoLiquidity
515     );
516 
517     event LiquifySwapUpdatedEnabled(bool enabled);
518     event SetTaxFeePercent(uint value);
519     event SetTaxFeeFlag(bool flag);
520     event SetMaxLoopCount(uint value);
521     event SetMaxTxPercent(uint value);
522     event SetLiquidityFeePercent(uint value);
523     event SetSellFeeLiquidity(uint value);
524     event ExcludedFromFee(address _address);
525     event IncludeInFee(address _address);
526     event ETHReceived(address _address);
527     event Delivery(address _address,  uint256 amount);
528     event AddLiquidity(uint256 coin_amount, uint256 bnb_amount);
529     event SwapAndLiquifyEnabled(bool flag);
530     event RouterSet(address indexed router);
531 
532 
533     modifier lockSwaping {
534         isIntoLiquifySwap = true;
535         _;
536         isIntoLiquifySwap = false;
537     }
538 
539     constructor () {
540         _reflectOwned[_msgSender()] = _reflectTotal;
541 	    _setRouterAddress(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);	
542         
543         _isExcludedFromFee[owner()] = true;
544         _isExcludedFromFee[address(this)] = true;
545         emit Transfer(address(0), _msgSender(), _takeTotal);
546     }
547     
548     function _setRouterAddressByOwner(address router, address factory) external onlyOwner() {
549         _setRouterAddress(router, factory);
550     }
551 
552     function _setRouterAddress(address router, address factory) private {
553 
554         IUniswapV2Router02 _uniswapRouter = IUniswapV2Router02(router);
555 
556         uniswapPair = IUniswapV2Factory(_uniswapRouter.factory())
557             .createPair(address(this), _uniswapRouter.WETH());
558 
559         uniswapRouter = _uniswapRouter;
560         
561         address payable _pancakeFactory = payable(factory);
562         _isExcludedFromFee[_pancakeFactory] = true;
563         
564         emit RouterSet(router);
565     }
566     
567     function _isV2Pair(address account) internal view returns(bool){
568         return (account == uniswapPair);
569     }
570 
571 
572 
573     // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ BEP20 functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
574 
575     function name() external pure returns (string memory) {
576         return _name;
577     }
578 
579     function symbol() external pure returns (string memory) {
580         return _symbol;
581     }
582 
583     function decimals() public pure returns (uint8) {
584         return _decimals;
585     }
586 
587     function totalSupply() external view override returns (uint256) {
588         return _takeTotal;
589     }
590 
591     function balanceOf(address account) public view override returns (uint256) {
592         if (_isExcluded[account]) return _takeOwned[account];
593         return tokenFromReflection(_reflectOwned[account]);
594     }
595 
596     function transfer(address recipient, uint256 amount) external override returns (bool) {
597         _transfer(_msgSender(), recipient, amount);
598         return true;
599     }
600 
601     function allowance(address owner, address spender) external view override returns (uint256) {
602         return _allowances[owner][spender];
603     }
604 
605     function approve(address spender, uint256 amount) external override returns (bool) {
606         _approve(_msgSender(), spender, amount);
607 
608         return true;
609     }
610 
611     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
612         _transfer(sender, recipient, amount);
613         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
614 
615         return true;
616     }
617 
618     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
619         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
620 
621         return true;
622     }
623 
624     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
625         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
626 
627         return true;
628     }
629 
630 
631     function _getCurrentSupply() private view returns(uint256, uint256) {
632         require(_excluded.length <= _maxLoopCount, "The number of loop iterations in _getCurrentSupply is greater than the allowed value.");
633 
634         uint256 rSupply = _reflectTotal;
635         uint256 tSupply = _takeTotal;
636         for (uint256 i = 0; i < _excluded.length; i++) {
637             if (_reflectOwned[_excluded[i]] > rSupply || _takeOwned[_excluded[i]] > tSupply) return (_reflectTotal, _takeTotal);
638             rSupply = rSupply.sub(_reflectOwned[_excluded[i]]);
639             tSupply = tSupply.sub(_takeOwned[_excluded[i]]);
640         }
641         if (rSupply < _reflectTotal.div(_takeTotal)) return (_reflectTotal, _takeTotal);
642 
643         return (rSupply, tSupply);
644     }
645 
646     function _approve(address owner, address spender, uint256 amount) private {
647         require(owner != address(0), "BEP20: approve from the zero address");
648         require(spender != address(0), "BEP20: approve to the zero address");
649 
650         _allowances[owner][spender] = amount;
651         emit Approval(owner, spender, amount);
652     }
653 
654     // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Setter functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
655 
656     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
657         emit SetTaxFeePercent(taxFee);
658         _taxFee = taxFee;
659     }
660 
661     function setTaxFeeFlag(bool flag) external onlyOwner() {
662         emit SetTaxFeeFlag(flag);
663         _taxFeeFlag = flag;
664     }
665 
666     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
667         emit SetLiquidityFeePercent(liquidityFee);
668         _liquidityFee = liquidityFee;
669     }
670 
671     function setMaxLoopCount(uint256 maxLoopCount) external onlyOwner() {
672         emit SetMaxLoopCount(maxLoopCount);
673         _maxLoopCount = maxLoopCount;
674     }
675 
676     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
677         emit SetMaxTxPercent(maxTxPercent);
678         _maximumValueOfTransaction = _takeTotal.mul(maxTxPercent).div(
679             10**2
680         );
681     }
682 
683     function setNumTokensSellToAddToLiquidity(uint256 amount) external onlyOwner() {
684         numTokensSellToAddToLiquidity = amount;
685     }
686 
687     function setLiquiditySellFeePercent(uint256 liquiditySellFee) external onlyOwner() {
688         emit SetTaxFeePercent(liquiditySellFee);
689         _liquiditySellFee = liquiditySellFee;
690     }
691 
692     // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Fees calculate functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
693 
694     function totalFees() external view returns (uint256) {
695         return _takeFeeTotal;
696     }
697 
698     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
699         return _amount.mul(_taxFee).div(
700             10**2
701         );
702     }
703 
704     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
705         return _amount.mul(_liquidityFee).div(
706             10**2
707         );
708     }
709 
710     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
711         (uint256 takeAmountToTransfer, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
712         (uint256 reflectAmount, uint256 reflectAmountToTransfer, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
713 
714         return (reflectAmount, reflectAmountToTransfer, rFee, takeAmountToTransfer, tFee, tLiquidity);
715     }
716 
717     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
718         uint256 tFee = calculateTaxFee(tAmount);
719         uint256 tLiquidity = calculateLiquidityFee(tAmount);
720         uint256 takeAmountToTransfer = tAmount.sub(tFee).sub(tLiquidity);
721 
722         return (takeAmountToTransfer, tFee, tLiquidity);
723     }
724 
725     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
726         uint256 reflectAmount = tAmount.mul(currentRate);
727         uint256 rFee = tFee.mul(currentRate);
728         uint256 rLiquidity = tLiquidity.mul(currentRate);
729         uint256 reflectAmountToTransfer = reflectAmount.sub(rFee).sub(rLiquidity);
730 
731         return (reflectAmount, reflectAmountToTransfer, rFee);
732     }
733 
734     function _getRate() private view returns(uint256) {
735         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
736 
737         return rSupply.div(tSupply);
738     }
739 
740     // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Withdraw function \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
741 
742     /// This will allow to rescue ETH sent by mistake directly to the contract
743     function rescueTokensFromContract(uint256 amount) external onlyOwner {
744         if(amount == 0 ){ // ETH
745             payable(owner()).transfer(address(this).balance);
746         }else{ // TCG2
747             _tokenTransfer(address(this), owner(), amount, false);
748         }
749     }
750 
751     // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Fees managing functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
752 
753     function removeAllFee() private {
754         if(_taxFee == 0 && _liquidityFee == 0) return;
755 
756         _previousTaxFee = _taxFee;
757         _previousLiquidityFee = _liquidityFee;
758 
759         _taxFee = 0;
760         _liquidityFee = 0;
761     }
762 
763     function restoreAllFee() private {
764         _taxFee = _previousTaxFee;
765         _liquidityFee = _previousLiquidityFee;
766     }
767 
768     // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Fees group mebership functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
769 
770     function setupBot(address account, bool value) external onlyOwner {
771         _isBot[account] = value;
772     }
773 
774     function excludeFromFee(address account) external onlyOwner {
775         emit ExcludedFromFee(account);
776         _isExcludedFromFee[account] = true;
777     }
778 
779     function includeInFee(address account) external onlyOwner {
780         emit IncludeInFee(account);
781         _isExcludedFromFee[account] = false;
782     }
783 
784     function isExcludedFromFee(address account) public view returns(bool) {
785         return _isExcludedFromFee[account];
786     }
787 
788     function setDexWithSellFee(address account, bool value) external onlyOwner {
789         _isDEXSellFee[account] = value;
790     }
791 
792 
793     function isDexWithSellFee(address account) public view returns(bool) {
794         return _isDEXSellFee[account];
795     }
796 
797     function setDexWithBuyFee(address account, bool value) external onlyOwner {
798         _isDEXBuyFee[account] = value;
799     }
800 
801     function isDexWithBuyFee(address account) public view returns(bool) {
802         return _isDEXBuyFee[account];
803     }
804 
805 
806     // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ LP functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
807 
808     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
809         emit SwapAndLiquifyEnabled(_enabled);
810         swapAndLiquifyEnabled = _enabled;
811 
812         emit LiquifySwapUpdatedEnabled(_enabled);
813     }
814 
815     //to receive ETH from uniswapRouter when swapping
816     receive() external payable {}
817 
818     function _takeLiquidity(uint256 tLiquidity) private {
819         uint256 currentRate =  _getRate();
820         uint256 rLiquidity = tLiquidity.mul(currentRate);
821         _reflectOwned[address(this)] = _reflectOwned[address(this)].add(rLiquidity);
822         if(_isExcluded[address(this)])
823             _takeOwned[address(this)] = _takeOwned[address(this)].add(tLiquidity);
824     }
825 
826     function swapAndLiquifyByOwner(uint256 amount) external onlyOwner {
827         swapAndLiquify(amount);
828     }
829 
830     function swapAndLiquify(uint256 contractTokenBalance) private lockSwaping {
831         // split the contract balance into halves
832         uint256 half = contractTokenBalance.div(2);
833         uint256 otherHalf = contractTokenBalance.sub(half);
834 
835         // capture the contract's current ETH balance.
836         // this is so that we can capture exactly the amount of ETH that the
837         // swap creates, and not make the liquidity event include any ETH that
838         // has been manually sent to the contract
839         uint256 initialBalance = address(this).balance;
840 
841         // swap tokens for ETH
842         swapTokensForETH(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
843 
844         // how much ETH did we just swap into?
845         uint256 newBalance = address(this).balance.sub(initialBalance);
846 
847         // add liquidity to pancakswap
848         addLiquidity(otherHalf, newBalance);
849 
850         emit SwapAndLiquifyEvent(half, newBalance, otherHalf);
851     }
852 
853     function swapTokensForETH(uint256 tokenAmount) private {
854         // generate the uniswap pair path of token -> weth
855         address[] memory path = new address[](2);
856         path[0] = address(this);
857         path[1] = uniswapRouter.WETH();
858 
859         _approve(address(this), address(uniswapRouter), tokenAmount);
860 
861         // make the swap
862         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
863             tokenAmount,
864             0, // accept any amount of ETH
865             path,
866             address(this),
867             block.timestamp
868         );
869     }
870 
871     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
872         emit AddLiquidity(tokenAmount, ethAmount);
873         // approve token transfer to cover all possible scenarios
874         _approve(address(this), address(uniswapRouter), tokenAmount);
875 
876         // add the liquidity
877         uniswapRouter.addLiquidityETH{value: ethAmount}(
878             address(this),
879             tokenAmount,
880             0, // slippage is unavoidable
881             0, // slippage is unavoidable
882             owner(),
883             block.timestamp
884         );
885     }
886 
887     // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Reflection functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
888 
889 
890     function tokenFromReflection(uint256 reflectAmount) public view returns(uint256) {
891         require(reflectAmount <= _reflectTotal, "Amount must be less than total reflections");
892         uint256 currentRate =  _getRate();
893 
894         return reflectAmount.div(currentRate);
895     }
896 
897     // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Custom transfer functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
898 
899     function _transfer(
900         address from,
901         address to,
902         uint256 amount
903     ) private {
904         require( !_isBot[to], "BEP20: transfer to the bot address");
905         require( !_isBot[from], "BEP20: transfer from the bot address");
906         require(from != address(0), "BEP20: transfer from the zero address");
907         require(to != address(0), "BEP20: transfer to the zero address");
908         require(amount > 0, "Transfer amount must be greater than zero");
909         if(from != owner() && to != owner())
910             require(amount <= _maximumValueOfTransaction, "Transfer amount exceeds the maxTxAmount.");
911 
912 
913         uint256 contractTokenBalance = balanceOf(address(this));
914 
915         if(contractTokenBalance >= _maximumValueOfTransaction){contractTokenBalance = _maximumValueOfTransaction;}
916 
917         bool overMinimumCoinBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
918         if (
919             overMinimumCoinBalance &&
920             !isIntoLiquifySwap &&
921             from != uniswapPair &&
922             swapAndLiquifyEnabled
923         ) {
924             contractTokenBalance = numTokensSellToAddToLiquidity;
925             //add liquidity
926             swapAndLiquify(contractTokenBalance);
927         }
928 
929         //indicates if fee should be deducted from transfer
930         bool takeFee = _taxFeeFlag;
931 
932         if(_isDEXSellFee[to] && !_isExcludedFromFee[from]){
933             takeFee = true;
934             _previousLiquidityFee = _liquidityFee;
935             _liquidityFee = _liquiditySellFee;
936         } else if(_isDEXBuyFee[from] && !_isExcludedFromFee[to]){
937             takeFee = true;
938         }
939 
940         //transfer amount, it will take liquidity fee
941         _tokenTransfer(from,to,amount,takeFee);
942 
943         if(takeFee = true){
944             _liquidityFee = _previousLiquidityFee;
945         }
946 
947     }
948 
949     //this method is responsible for taking all fee, if takeFee is true
950     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
951 
952         if(!takeFee){removeAllFee();}
953 
954         (uint256 reflectAmount, uint256 reflectAmountToTransfer, uint256 rFee, uint256 takeAmountToTransfer, uint256 tFee, uint256 tLiquidity) = _getValues(amount);
955 
956         _reflectOwned[sender] = _reflectOwned[sender].sub(reflectAmount);
957         _reflectOwned[recipient] = _reflectOwned[recipient].add(reflectAmountToTransfer);
958 
959 
960         _takeLiquidity(tLiquidity);
961         
962         emit Transfer(sender, recipient, takeAmountToTransfer);
963 
964         if(!takeFee){restoreAllFee();}
965     }
966 }