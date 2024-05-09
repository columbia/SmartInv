1 /*
2   _    _ _   _ ______ _______
3  | |  | | \ | |  ____|__   __|
4  | |  | |  \| | |__     | |
5  | |  | | . ` |  __|    | |
6  | |__| | |\  | |       | |
7   \____/|_| \_|_|       |_|
8 */
9 
10 // SPDX-License-Identifier: Unlicensed
11 //Prepared by Grant Fields
12 
13 
14 pragma solidity ^0.8.4;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return payable(msg.sender);
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 
28 interface IERC20 {
29 
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 
39 }
40 
41 library SafeMath {
42 
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46 
47         return c;
48     }
49 
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b <= a, errorMessage);
56         uint256 c = a - b;
57 
58         return c;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         return div(a, b, "SafeMath: division by zero");
75     }
76 
77     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b > 0, errorMessage);
79         uint256 c = a / b;
80         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81 
82         return c;
83     }
84 
85     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86         return mod(a, b, "SafeMath: modulo by zero");
87     }
88 
89     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         require(b != 0, errorMessage);
91         return a % b;
92     }
93 }
94 
95 library Address {
96 
97     function isContract(address account) internal view returns (bool) {
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
183 
184     function getUnlockTime() public view returns (uint256) {
185         return _lockTime;
186     }
187 
188     function getTime() public view returns (uint256) {
189         return block.timestamp;
190     }
191 
192     function lock(uint256 time) public virtual onlyOwner {
193         _previousOwner = _owner;
194         _owner = address(0);
195         _lockTime = block.timestamp + time;
196         emit OwnershipTransferred(_owner, address(0));
197     }
198 
199     function unlock() public virtual {
200         require(_previousOwner == msg.sender, "You don't have permission to unlock");
201         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
202         emit OwnershipTransferred(_owner, _previousOwner);
203         _owner = _previousOwner;
204     }
205 }
206 
207 // pragma solidity >=0.5.0;
208 
209 interface IUniswapV2Factory {
210     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
211 
212     function feeTo() external view returns (address);
213     function feeToSetter() external view returns (address);
214 
215     function getPair(address tokenA, address tokenB) external view returns (address pair);
216     function allPairs(uint) external view returns (address pair);
217     function allPairsLength() external view returns (uint);
218 
219     function createPair(address tokenA, address tokenB) external returns (address pair);
220 
221     function setFeeTo(address) external;
222     function setFeeToSetter(address) external;
223 }
224 
225 
226 // pragma solidity >=0.5.0;
227 
228 interface IUniswapV2Pair {
229     event Approval(address indexed owner, address indexed spender, uint value);
230     event Transfer(address indexed from, address indexed to, uint value);
231 
232     function name() external pure returns (string memory);
233     function symbol() external pure returns (string memory);
234     function decimals() external pure returns (uint8);
235     function totalSupply() external view returns (uint);
236     function balanceOf(address owner) external view returns (uint);
237     function allowance(address owner, address spender) external view returns (uint);
238 
239     function approve(address spender, uint value) external returns (bool);
240     function transfer(address to, uint value) external returns (bool);
241     function transferFrom(address from, address to, uint value) external returns (bool);
242 
243     function DOMAIN_SEPARATOR() external view returns (bytes32);
244     function PERMIT_TYPEHASH() external pure returns (bytes32);
245     function nonces(address owner) external view returns (uint);
246 
247     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
248 
249     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
250     event Swap(
251         address indexed sender,
252         uint amount0In,
253         uint amount1In,
254         uint amount0Out,
255         uint amount1Out,
256         address indexed to
257     );
258     event Sync(uint112 reserve0, uint112 reserve1);
259 
260     function MINIMUM_LIQUIDITY() external pure returns (uint);
261     function factory() external view returns (address);
262     function token0() external view returns (address);
263     function token1() external view returns (address);
264     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
265     function price0CumulativeLast() external view returns (uint);
266     function price1CumulativeLast() external view returns (uint);
267     function kLast() external view returns (uint);
268 
269     function burn(address to) external returns (uint amount0, uint amount1);
270     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
271     function skim(address to) external;
272     function sync() external;
273 
274     function initialize(address, address) external;
275 }
276 
277 // pragma solidity >=0.6.2;
278 
279 interface IUniswapV2Router01 {
280     function factory() external pure returns (address);
281     function WETH() external pure returns (address);
282 
283     function addLiquidity(
284         address tokenA,
285         address tokenB,
286         uint amountADesired,
287         uint amountBDesired,
288         uint amountAMin,
289         uint amountBMin,
290         address to,
291         uint deadline
292     ) external returns (uint amountA, uint amountB, uint liquidity);
293     function addLiquidityETH(
294         address token,
295         uint amountTokenDesired,
296         uint amountTokenMin,
297         uint amountETHMin,
298         address to,
299         uint deadline
300     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
301     function removeLiquidity(
302         address tokenA,
303         address tokenB,
304         uint liquidity,
305         uint amountAMin,
306         uint amountBMin,
307         address to,
308         uint deadline
309     ) external returns (uint amountA, uint amountB);
310     function removeLiquidityETH(
311         address token,
312         uint liquidity,
313         uint amountTokenMin,
314         uint amountETHMin,
315         address to,
316         uint deadline
317     ) external returns (uint amountToken, uint amountETH);
318     function removeLiquidityWithPermit(
319         address tokenA,
320         address tokenB,
321         uint liquidity,
322         uint amountAMin,
323         uint amountBMin,
324         address to,
325         uint deadline,
326         bool approveMax, uint8 v, bytes32 r, bytes32 s
327     ) external returns (uint amountA, uint amountB);
328     function removeLiquidityETHWithPermit(
329         address token,
330         uint liquidity,
331         uint amountTokenMin,
332         uint amountETHMin,
333         address to,
334         uint deadline,
335         bool approveMax, uint8 v, bytes32 r, bytes32 s
336     ) external returns (uint amountToken, uint amountETH);
337     function swapExactTokensForTokens(
338         uint amountIn,
339         uint amountOutMin,
340         address[] calldata path,
341         address to,
342         uint deadline
343     ) external returns (uint[] memory amounts);
344     function swapTokensForExactTokens(
345         uint amountOut,
346         uint amountInMax,
347         address[] calldata path,
348         address to,
349         uint deadline
350     ) external returns (uint[] memory amounts);
351     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
352         external
353         payable
354         returns (uint[] memory amounts);
355     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
356         external
357         returns (uint[] memory amounts);
358     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
359         external
360         returns (uint[] memory amounts);
361     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
362         external
363         payable
364         returns (uint[] memory amounts);
365 
366     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
367     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
368     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
369     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
370     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
371 }
372 
373 
374 
375 // pragma solidity >=0.6.2;
376 
377 interface IUniswapV2Router02 is IUniswapV2Router01 {
378     function removeLiquidityETHSupportingFeeOnTransferTokens(
379         address token,
380         uint liquidity,
381         uint amountTokenMin,
382         uint amountETHMin,
383         address to,
384         uint deadline
385     ) external returns (uint amountETH);
386     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
387         address token,
388         uint liquidity,
389         uint amountTokenMin,
390         uint amountETHMin,
391         address to,
392         uint deadline,
393         bool approveMax, uint8 v, bytes32 r, bytes32 s
394     ) external returns (uint amountETH);
395 
396     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
397         uint amountIn,
398         uint amountOutMin,
399         address[] calldata path,
400         address to,
401         uint deadline
402     ) external;
403     function swapExactETHForTokensSupportingFeeOnTransferTokens(
404         uint amountOutMin,
405         address[] calldata path,
406         address to,
407         uint deadline
408     ) external payable;
409     function swapExactTokensForETHSupportingFeeOnTransferTokens(
410         uint amountIn,
411         uint amountOutMin,
412         address[] calldata path,
413         address to,
414         uint deadline
415     ) external;
416 }
417 
418 contract UNFT is Context, IERC20, Ownable {
419     //Prepared by Grant Fields
420     using SafeMath for uint256;
421     using Address for address;
422 
423     address payable public marketingAddress = payable(0x379fEDF5DFfA2311a7E2F132FFDdBbA3c149229C); // Marketing Address
424     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
425     mapping (address => uint256) private _rOwned;
426     mapping (address => uint256) private _tOwned;
427     mapping (address => mapping (address => uint256)) private _allowances;
428     mapping (address => bool) private bots;
429 
430     mapping (address => bool) private _isExcludedFromFee;
431 
432     mapping (address => bool) private _isExcluded;
433     address[] private _excluded;
434 
435     uint256 private constant MAX = ~uint256(0);
436     uint256 private _tTotal = 1000 * 10**6 * 10**9;
437     uint256 private _rTotal = (MAX - (MAX % _tTotal));
438     uint256 private _tFeeTotal;
439 
440 
441 
442     string private _name = "Ultimate NFT";
443     string private _symbol = "UNFT";
444     uint8 private _decimals = 9;
445 
446 
447     uint256 private _taxFee;
448     uint256 private _previousTaxFee = _taxFee;
449 
450     uint256 public _liquidityFee = 5;
451     uint256 private _previousLiquidityFee = _liquidityFee;
452 
453     uint256 public marketingDivisor = 3;
454 
455     uint256 public _maxTxAmount = 1000 * 10**6 * 10**9;
456     uint256 private minimumTokensBeforeSwap = 2500000 * 10**9;
457 
458 
459 
460     IUniswapV2Router02 public immutable uniswapV2Router;
461     address public immutable uniswapV2Pair;
462 
463     bool inSwapAndLiquify;
464     bool public swapAndLiquifyEnabled = false;
465     bool public buyBackEnabled = true;
466 
467 
468     event RewardLiquidityProviders(uint256 tokenAmount);
469     event BuyBackEnabledUpdated(bool enabled);
470     event SwapAndLiquifyEnabledUpdated(bool enabled);
471     event SwapAndLiquify(
472         uint256 tokensSwapped,
473         uint256 ethReceived,
474         uint256 tokensIntoLiqudity
475     );
476 
477     event SwapETHForTokens(
478         uint256 amountIn,
479         address[] path
480     );
481 
482     event SwapTokensForETH(
483         uint256 amountIn,
484         address[] path
485     );
486 
487     modifier lockTheSwap {
488         inSwapAndLiquify = true;
489         _;
490         inSwapAndLiquify = false;
491     }
492 
493     constructor () {
494         _rOwned[_msgSender()] = _rTotal;
495 
496         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
497         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
498             .createPair(address(this), _uniswapV2Router.WETH());
499         _taxFee = 0;
500 
501         uniswapV2Router = _uniswapV2Router;
502 
503 
504         _isExcludedFromFee[owner()] = true;
505         _isExcludedFromFee[address(this)] = true;
506 
507         emit Transfer(address(0), _msgSender(), _tTotal);
508     }
509 
510 
511 
512     function name() public view returns (string memory) {
513         return _name;
514     }
515 
516 
517     function symbol() public view returns (string memory) {
518         return _symbol;
519     }
520 
521     function decimals() public view returns (uint8) {
522         return _decimals;
523     }
524 
525     function totalSupply() public view override returns (uint256) {
526         return _tTotal;
527     }
528 
529     function balanceOf(address account) public view override returns (uint256) {
530         if (_isExcluded[account]) return _tOwned[account];
531         return tokenFromReflection(_rOwned[account]);
532     }
533 
534     function transfer(address recipient, uint256 amount) public override returns (bool) {
535         _transfer(_msgSender(), recipient, amount);
536         return true;
537     }
538 
539     function allowance(address owner, address spender) public view override returns (uint256) {
540         return _allowances[owner][spender];
541     }
542 
543     function approve(address spender, uint256 amount) public override returns (bool) {
544         _approve(_msgSender(), spender, amount);
545         return true;
546     }
547 
548     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
549         _transfer(sender, recipient, amount);
550         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
551         return true;
552     }
553 
554     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
555         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
556         return true;
557     }
558 
559     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
560         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
561         return true;
562     }
563 
564     function isExcludedFromReward(address account) public view returns (bool) {
565         return _isExcluded[account];
566     }
567 
568     function totalFees() public view returns (uint256) {
569         return _tFeeTotal;
570     }
571 
572     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
573         return minimumTokensBeforeSwap;
574     }
575 
576 
577     function deliver(uint256 tAmount) public {
578         address sender = _msgSender();
579         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
580         (uint256 rAmount,,,,,) = _getValues(tAmount);
581         _rOwned[sender] = _rOwned[sender].sub(rAmount);
582         _rTotal = _rTotal.sub(rAmount);
583         _tFeeTotal = _tFeeTotal.add(tAmount);
584     }
585 
586 
587     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
588         require(tAmount <= _tTotal, "Amount must be less than supply");
589         if (!deductTransferFee) {
590             (uint256 rAmount,,,,,) = _getValues(tAmount);
591             return rAmount;
592         } else {
593             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
594             return rTransferAmount;
595         }
596     }
597 
598     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
599         require(rAmount <= _rTotal, "Amount must be less than total reflections");
600         uint256 currentRate =  _getRate();
601         return rAmount.div(currentRate);
602     }
603 
604     function excludeFromReward(address account) public onlyOwner() {
605 
606         require(!_isExcluded[account], "Account is already excluded");
607         if(_rOwned[account] > 0) {
608             _tOwned[account] = tokenFromReflection(_rOwned[account]);
609         }
610         _isExcluded[account] = true;
611         _excluded.push(account);
612     }
613 
614     function includeInReward(address account) external onlyOwner() {
615         require(_isExcluded[account], "Account is already excluded");
616         for (uint256 i = 0; i < _excluded.length; i++) {
617             if (_excluded[i] == account) {
618                 _excluded[i] = _excluded[_excluded.length - 1];
619                 _tOwned[account] = 0;
620                 _isExcluded[account] = false;
621                 _excluded.pop();
622                 break;
623             }
624         }
625     }
626 
627     function _approve(address owner, address spender, uint256 amount) private {
628         require(owner != address(0), "ERC20: approve from the zero address");
629         require(spender != address(0), "ERC20: approve to the zero address");
630 
631         _allowances[owner][spender] = amount;
632         emit Approval(owner, spender, amount);
633     }
634 
635     function _transfer(
636         address from,
637         address to,
638         uint256 amount
639     ) private {
640         require(from != address(0), "ERC20: transfer from the zero address");
641         require(to != address(0), "ERC20: transfer to the zero address");
642         require(amount > 0, "Transfer amount must be greater than zero");
643         if(from != owner() && to != owner()) {
644             require(!bots[from] && !bots[to]);
645             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
646         }
647 
648         uint256 contractTokenBalance = balanceOf(address(this));
649         uint256 leftover;
650         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
651 
652         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
653             if (overMinimumTokenBalance) {
654                 contractTokenBalance = minimumTokensBeforeSwap.mul(marketingDivisor).div(_liquidityFee);
655                 leftover = minimumTokensBeforeSwap - contractTokenBalance;
656                 swapTokens(contractTokenBalance);
657                 _transfer(address(this), deadAddress, leftover);
658             }
659 
660         }
661 
662         bool takeFee = true;
663 
664         //if any account belongs to _isExcludedFromFee account then remove the fee
665         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
666             takeFee = false;
667         }
668 
669         _tokenTransfer(from,to,amount,takeFee);
670     }
671 
672     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
673 
674         uint256 initialBalance = address(this).balance;
675         swapTokensForEth(contractTokenBalance);
676         uint256 transferredBalance = address(this).balance.sub(initialBalance);
677 
678         //Send to Marketing address
679         transferToAddressETH(marketingAddress, transferredBalance);
680 
681     }
682 
683 
684 
685 
686     function swapTokensForEth(uint256 tokenAmount) private {
687         // generate the uniswap pair path of token -> weth
688         address[] memory path = new address[](2);
689         path[0] = address(this);
690         path[1] = uniswapV2Router.WETH();
691 
692         _approve(address(this), address(uniswapV2Router), tokenAmount);
693 
694         // make the swap
695         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
696             tokenAmount,
697             0, // accept any amount of ETH
698             path,
699             address(this), // The contract
700             block.timestamp
701         );
702 
703         emit SwapTokensForETH(tokenAmount, path);
704     }
705 
706     function swapETHForTokens(uint256 amount) private {
707         // generate the uniswap pair path of token -> weth
708         address[] memory path = new address[](2);
709         path[0] = uniswapV2Router.WETH();
710         path[1] = address(this);
711 
712       // make the swap
713         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
714             0, // accept any amount of Tokens
715             path,
716             deadAddress, // Burn address
717             block.timestamp.add(300)
718         );
719 
720         emit SwapETHForTokens(amount, path);
721     }
722 
723     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
724         // approve token transfer to cover all possible scenarios
725         _approve(address(this), address(uniswapV2Router), tokenAmount);
726 
727         // add the liquidity
728         uniswapV2Router.addLiquidityETH{value: ethAmount}(
729             address(this),
730             tokenAmount,
731             0, // slippage is unavoidable
732             0, // slippage is unavoidable
733             owner(),
734             block.timestamp
735         );
736     }
737 
738 
739 
740     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
741         if(!takeFee)
742             removeAllFee();
743 
744         if (_isExcluded[sender] && !_isExcluded[recipient]) {
745             _transferFromExcluded(sender, recipient, amount);
746         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
747             _transferToExcluded(sender, recipient, amount);
748         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
749             _transferBothExcluded(sender, recipient, amount);
750         } else {
751             _transferStandard(sender, recipient, amount);
752         }
753 
754         if(!takeFee)
755             restoreAllFee();
756     }
757 
758     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
759         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
760         _rOwned[sender] = _rOwned[sender].sub(rAmount);
761         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
762         _takeLiquidity(tLiquidity);
763         _reflectFee(rFee, tFee);
764         emit Transfer(sender, recipient, tTransferAmount);
765     }
766 
767     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
768         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
769 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
770         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
771         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
772         _takeLiquidity(tLiquidity);
773         _reflectFee(rFee, tFee);
774         emit Transfer(sender, recipient, tTransferAmount);
775     }
776 
777     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
778         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
779     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
780         _rOwned[sender] = _rOwned[sender].sub(rAmount);
781         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
782         _takeLiquidity(tLiquidity);
783         _reflectFee(rFee, tFee);
784         emit Transfer(sender, recipient, tTransferAmount);
785     }
786 
787     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
788         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
789     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
790         _rOwned[sender] = _rOwned[sender].sub(rAmount);
791         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
792         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
793         _takeLiquidity(tLiquidity);
794         _reflectFee(rFee, tFee);
795         emit Transfer(sender, recipient, tTransferAmount);
796     }
797 
798     function _reflectFee(uint256 rFee, uint256 tFee) private {
799         _rTotal = _rTotal.sub(rFee);
800         _tFeeTotal = _tFeeTotal.add(tFee);
801     }
802 
803     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
804         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
805         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
806         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
807     }
808 
809     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
810         uint256 tFee = calculateTaxFee(tAmount);
811         uint256 tLiquidity = calculateLiquidityFee(tAmount);
812         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
813         return (tTransferAmount, tFee, tLiquidity);
814     }
815 
816     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
817         uint256 rAmount = tAmount.mul(currentRate);
818         uint256 rFee = tFee.mul(currentRate);
819         uint256 rLiquidity = tLiquidity.mul(currentRate);
820         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
821         return (rAmount, rTransferAmount, rFee);
822     }
823 
824     function _getRate() private view returns(uint256) {
825         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
826         return rSupply.div(tSupply);
827     }
828 
829     function _getCurrentSupply() private view returns(uint256, uint256) {
830         uint256 rSupply = _rTotal;
831         uint256 tSupply = _tTotal;
832         for (uint256 i = 0; i < _excluded.length; i++) {
833             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
834             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
835             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
836         }
837         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
838         return (rSupply, tSupply);
839     }
840 
841     function _takeLiquidity(uint256 tLiquidity) private {
842         uint256 currentRate =  _getRate();
843         uint256 rLiquidity = tLiquidity.mul(currentRate);
844         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
845         if(_isExcluded[address(this)])
846             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
847     }
848 
849     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
850         return _amount.mul(_taxFee).div(
851             10**2
852         );
853     }
854 
855     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
856         return _amount.mul(_liquidityFee).div(
857             10**2
858         );
859     }
860 
861     function removeAllFee() private {
862         if(_taxFee == 0 && _liquidityFee == 0) return;
863 
864         _previousTaxFee = _taxFee;
865         _previousLiquidityFee = _liquidityFee;
866 
867         _taxFee = 0;
868         _liquidityFee = 0;
869     }
870 
871     function restoreAllFee() private {
872         _taxFee = _previousTaxFee;
873         _liquidityFee = _previousLiquidityFee;
874     }
875 
876     function isExcludedFromFee(address account) public view returns(bool) {
877         return _isExcludedFromFee[account];
878     }
879 
880     function excludeFromFee(address account) public onlyOwner {
881         _isExcludedFromFee[account] = true;
882     }
883 
884     function includeInFee(address account) public onlyOwner {
885         _isExcludedFromFee[account] = false;
886     }
887 
888     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
889         _liquidityFee = liquidityFee;
890     }
891 
892     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
893         _maxTxAmount = maxTxAmount;
894     }
895 
896     function setMarketingDivisor(uint256 divisor) external onlyOwner() {
897         marketingDivisor = divisor;
898     }
899 
900     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
901         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
902     }
903 
904 
905     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
906         marketingAddress = payable(_marketingAddress);
907     }
908 
909     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
910         swapAndLiquifyEnabled = _enabled;
911         emit SwapAndLiquifyEnabledUpdated(_enabled);
912     }
913 
914     function feesOff() external onlyOwner {
915         setSwapAndLiquifyEnabled(false);
916         _liquidityFee = 0;
917     }
918 
919     function feesLive() external onlyOwner {
920         setSwapAndLiquifyEnabled(true);
921         _liquidityFee = 5;
922     }
923 
924     function transferToAddressETH(address payable recipient, uint256 amount) private {
925         recipient.transfer(amount);
926     }
927 
928 
929     receive() external payable {}
930 }