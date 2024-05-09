1 /*
2 
3  __     __                                     _______  __                   
4 |  \   |  \                                   |       \|  \                  
5 | ▓▓   | ▓▓ ______   ______   ______   ______ | ▓▓▓▓▓▓▓\\▓▓ _______  ______  
6 | ▓▓   | ▓▓|      \ /      \ /      \ /      \| ▓▓__| ▓▓  \/       \/      \ 
7  \▓▓\ /  ▓▓ \▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\ ▓▓    ▓▓ ▓▓  ▓▓▓▓▓▓▓  ▓▓▓▓▓▓\
8   \▓▓\  ▓▓ /      ▓▓ ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓   \▓▓ ▓▓▓▓▓▓▓\ ▓▓\▓▓    \| ▓▓    ▓▓
9    \▓▓ ▓▓ |  ▓▓▓▓▓▓▓ ▓▓__/ ▓▓ ▓▓__/ ▓▓ ▓▓     | ▓▓  | ▓▓ ▓▓_\▓▓▓▓▓▓\ ▓▓▓▓▓▓▓▓
10     \▓▓▓   \▓▓    ▓▓ ▓▓    ▓▓\▓▓    ▓▓ ▓▓     | ▓▓  | ▓▓ ▓▓       ▓▓\▓▓     \
11      \▓     \▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓  \▓▓▓▓▓▓ \▓▓      \▓▓   \▓▓\▓▓\▓▓▓▓▓▓▓  \▓▓▓▓▓▓▓
12                    | ▓▓                                                      
13                    | ▓▓                                                      
14                     \▓▓                                                      
15                     
16            ╔╗ ╔╗          ╔╗                              ╔╗       ╔╗ 
17           ╔╝╚╗║║          ║║                              ║║      ╔╝╚╗
18           ╚╗╔╝║╚═╗╔══╗    ║╚═╗╔══╗╔══╗ ╔═╗    ╔╗╔╗╔══╗ ╔═╗║║╔╗╔══╗╚╗╔╝
19            ║║ ║╔╗║║╔╗║    ║╔╗║║╔╗║╚ ╗║ ║╔╝    ║╚╝║╚ ╗║ ║╔╝║╚╝╝║╔╗║ ║║ 
20            ║╚╗║║║║║║═╣    ║╚╝║║║═╣║╚╝╚╗║║     ║║║║║╚╝╚╗║║ ║╔╗╗║║═╣ ║╚╗
21            ╚═╝╚╝╚╝╚══╝    ╚══╝╚══╝╚═══╝╚╝     ╚╩╩╝╚═══╝╚╝ ╚╝╚╝╚══╝ ╚═╝    
22 
23 
24 ➥ VaporRise is an improved fork of the wildly-successful MoonRise token, with a suite of improved features and tokenomics.
25 
26 ➥ On top of never allowing more than two sells to be seen in a row, community members will benefit from "MoonShots" using the Whale Wallet's BNB.
27 ➥ MoonShots will be activated manually, at random.
28 ➥ Members will NOT be able to vote on when buybacks will be executed - this will be done in a manner that is unpredictable for maximum impact. Democracy is overrated ;p
29 
30 LIVE HOLDER MILESTONES & MOONSHOT INFO:
31 - Website: VaporRise.Me
32 - Telegram: https://t.me/VaporRISE
33 - (All other important links and information can be found in our Telegram!)
34 
35 ----------
36     
37 */
38 
39 
40 // SPDX-License-Identifier: Unlicensed
41 
42 pragma solidity ^0.8.4;
43 
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address payable) {
46         return payable(msg.sender);
47     }
48 
49     function _msgData() internal view virtual returns (bytes memory) {
50         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
51         return msg.data;
52     }
53 }
54 
55 
56 interface IERC20 {
57 
58     function totalSupply() external view returns (uint256);
59     function balanceOf(address account) external view returns (uint256);
60     function transfer(address recipient, uint256 amount) external returns (bool);
61     function allowance(address owner, address spender) external view returns (uint256);
62     function approve(address spender, uint256 amount) external returns (bool);
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66     
67 
68 }
69 
70 library SafeMath {
71 
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75 
76         return c;
77     }
78 
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82 
83     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b <= a, errorMessage);
85         uint256 c = a - b;
86 
87         return c;
88     }
89 
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101 
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
115         return mod(a, b, "SafeMath: modulo by zero");
116     }
117 
118     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b != 0, errorMessage);
120         return a % b;
121     }
122 }
123 
124 library Address {
125 
126     function isContract(address account) internal view returns (bool) {
127         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
128         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
129         // for accounts without code, i.e. `keccak256('')`
130         bytes32 codehash;
131         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
132         // solhint-disable-next-line no-inline-assembly
133         assembly { codehash := extcodehash(account) }
134         return (codehash != accountHash && codehash != 0x0);
135     }
136 
137     function sendValue(address payable recipient, uint256 amount) internal {
138         require(address(this).balance >= amount, "Address: insufficient balance");
139 
140         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
141         (bool success, ) = recipient.call{ value: amount }("");
142         require(success, "Address: unable to send value, recipient may have reverted");
143     }
144 
145 
146     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
147       return functionCall(target, data, "Address: low-level call failed");
148     }
149 
150     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
151         return _functionCallWithValue(target, data, 0, errorMessage);
152     }
153 
154     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
155         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
156     }
157 
158     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
159         require(address(this).balance >= value, "Address: insufficient balance for call");
160         return _functionCallWithValue(target, data, value, errorMessage);
161     }
162 
163     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
164         require(isContract(target), "Address: call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
167         if (success) {
168             return returndata;
169         } else {
170             
171             if (returndata.length > 0) {
172                 assembly {
173                     let returndata_size := mload(returndata)
174                     revert(add(32, returndata), returndata_size)
175                 }
176             } else {
177                 revert(errorMessage);
178             }
179         }
180     }
181 }
182 
183 contract Ownable is Context {
184     address private _owner;
185     address private _previousOwner;
186     uint256 private _lockTime;
187 
188     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190     constructor () {
191         address msgSender = _msgSender();
192         _owner = msgSender;
193         emit OwnershipTransferred(address(0), msgSender);
194     }
195 
196     function owner() public view returns (address) {
197         return _owner;
198     }   
199     
200     modifier onlyOwner() {
201         require(_owner == _msgSender(), "Ownable: caller is not the owner");
202         _;
203     }
204     
205     function renounceOwnership() public virtual onlyOwner {
206         emit OwnershipTransferred(_owner, address(0));
207         _owner = address(0);
208     }
209 
210     function transferOwnership(address newOwner) public virtual onlyOwner {
211         require(newOwner != address(0), "Ownable: new owner is the zero address");
212         emit OwnershipTransferred(_owner, newOwner);
213         _owner = newOwner;
214     }
215 
216     function getUnlockTime() public view returns (uint256) {
217         return _lockTime;
218     }
219     
220     function getTime() public view returns (uint256) {
221         return block.timestamp;
222     }
223 
224     function lock(uint256 time) public virtual onlyOwner {
225         _previousOwner = _owner;
226         _owner = address(0);
227         _lockTime = block.timestamp + time;
228         emit OwnershipTransferred(_owner, address(0));
229     }
230     
231     function unlock() public virtual {
232         require(_previousOwner == msg.sender, "You don't have permission to unlock");
233         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
234         emit OwnershipTransferred(_owner, _previousOwner);
235         _owner = _previousOwner;
236     }
237 }
238 
239 // pragma solidity >=0.5.0;
240 
241 interface IUniswapV2Factory {
242     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
243 
244     function feeTo() external view returns (address);
245     function feeToSetter() external view returns (address);
246 
247     function getPair(address tokenA, address tokenB) external view returns (address pair);
248     function allPairs(uint) external view returns (address pair);
249     function allPairsLength() external view returns (uint);
250 
251     function createPair(address tokenA, address tokenB) external returns (address pair);
252 
253     function setFeeTo(address) external;
254     function setFeeToSetter(address) external;
255 }
256 
257 
258 // pragma solidity >=0.5.0;
259 
260 interface IUniswapV2Pair {
261     event Approval(address indexed owner, address indexed spender, uint value);
262     event Transfer(address indexed from, address indexed to, uint value);
263 
264     function name() external pure returns (string memory);
265     function symbol() external pure returns (string memory);
266     function decimals() external pure returns (uint8);
267     function totalSupply() external view returns (uint);
268     function balanceOf(address owner) external view returns (uint);
269     function allowance(address owner, address spender) external view returns (uint);
270 
271     function approve(address spender, uint value) external returns (bool);
272     function transfer(address to, uint value) external returns (bool);
273     function transferFrom(address from, address to, uint value) external returns (bool);
274 
275     function DOMAIN_SEPARATOR() external view returns (bytes32);
276     function PERMIT_TYPEHASH() external pure returns (bytes32);
277     function nonces(address owner) external view returns (uint);
278 
279     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
280     
281     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
282     event Swap(
283         address indexed sender,
284         uint amount0In,
285         uint amount1In,
286         uint amount0Out,
287         uint amount1Out,
288         address indexed to
289     );
290     event Sync(uint112 reserve0, uint112 reserve1);
291 
292     function MINIMUM_LIQUIDITY() external pure returns (uint);
293     function factory() external view returns (address);
294     function token0() external view returns (address);
295     function token1() external view returns (address);
296     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
297     function price0CumulativeLast() external view returns (uint);
298     function price1CumulativeLast() external view returns (uint);
299     function kLast() external view returns (uint);
300 
301     function burn(address to) external returns (uint amount0, uint amount1);
302     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
303     function skim(address to) external;
304     function sync() external;
305 
306     function initialize(address, address) external;
307 }
308 
309 // pragma solidity >=0.6.2;
310 
311 interface IUniswapV2Router01 {
312     function factory() external pure returns (address);
313     function WETH() external pure returns (address);
314 
315     function addLiquidity(
316         address tokenA,
317         address tokenB,
318         uint amountADesired,
319         uint amountBDesired,
320         uint amountAMin,
321         uint amountBMin,
322         address to,
323         uint deadline
324     ) external returns (uint amountA, uint amountB, uint liquidity);
325     function addLiquidityETH(
326         address token,
327         uint amountTokenDesired,
328         uint amountTokenMin,
329         uint amountETHMin,
330         address to,
331         uint deadline
332     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
333     function removeLiquidity(
334         address tokenA,
335         address tokenB,
336         uint liquidity,
337         uint amountAMin,
338         uint amountBMin,
339         address to,
340         uint deadline
341     ) external returns (uint amountA, uint amountB);
342     function removeLiquidityETH(
343         address token,
344         uint liquidity,
345         uint amountTokenMin,
346         uint amountETHMin,
347         address to,
348         uint deadline
349     ) external returns (uint amountToken, uint amountETH);
350     function removeLiquidityWithPermit(
351         address tokenA,
352         address tokenB,
353         uint liquidity,
354         uint amountAMin,
355         uint amountBMin,
356         address to,
357         uint deadline,
358         bool approveMax, uint8 v, bytes32 r, bytes32 s
359     ) external returns (uint amountA, uint amountB);
360     function removeLiquidityETHWithPermit(
361         address token,
362         uint liquidity,
363         uint amountTokenMin,
364         uint amountETHMin,
365         address to,
366         uint deadline,
367         bool approveMax, uint8 v, bytes32 r, bytes32 s
368     ) external returns (uint amountToken, uint amountETH);
369     function swapExactTokensForTokens(
370         uint amountIn,
371         uint amountOutMin,
372         address[] calldata path,
373         address to,
374         uint deadline
375     ) external returns (uint[] memory amounts);
376     function swapTokensForExactTokens(
377         uint amountOut,
378         uint amountInMax,
379         address[] calldata path,
380         address to,
381         uint deadline
382     ) external returns (uint[] memory amounts);
383     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
384         external
385         payable
386         returns (uint[] memory amounts);
387     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
388         external
389         returns (uint[] memory amounts);
390     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
391         external
392         returns (uint[] memory amounts);
393     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
394         external
395         payable
396         returns (uint[] memory amounts);
397 
398     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
399     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
400     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
401     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
402     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
403 }
404 
405 
406 
407 // pragma solidity >=0.6.2;
408 
409 interface IUniswapV2Router02 is IUniswapV2Router01 {
410     function removeLiquidityETHSupportingFeeOnTransferTokens(
411         address token,
412         uint liquidity,
413         uint amountTokenMin,
414         uint amountETHMin,
415         address to,
416         uint deadline
417     ) external returns (uint amountETH);
418     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
419         address token,
420         uint liquidity,
421         uint amountTokenMin,
422         uint amountETHMin,
423         address to,
424         uint deadline,
425         bool approveMax, uint8 v, bytes32 r, bytes32 s
426     ) external returns (uint amountETH);
427 
428     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
429         uint amountIn,
430         uint amountOutMin,
431         address[] calldata path,
432         address to,
433         uint deadline
434     ) external;
435     function swapExactETHForTokensSupportingFeeOnTransferTokens(
436         uint amountOutMin,
437         address[] calldata path,
438         address to,
439         uint deadline
440     ) external payable;
441     function swapExactTokensForETHSupportingFeeOnTransferTokens(
442         uint amountIn,
443         uint amountOutMin,
444         address[] calldata path,
445         address to,
446         uint deadline
447     ) external;
448 }
449 
450 contract V4P0RR1SE is Context, IERC20, Ownable {
451     using SafeMath for uint256;
452     using Address for address;
453     
454     address payable public marketingAddress = payable(0x92Fb29f59C1742E7008Be501cA6A71Adf77A4C14); // Marketing Address
455     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
456     mapping (address => uint256) private _rOwned;
457     mapping (address => uint256) private _tOwned;
458     mapping (address => mapping (address => uint256)) private _allowances;
459 
460     mapping (address => bool) private _isExcludedFromFee;
461 
462     mapping (address => bool) private _isExcluded;
463     address[] private _excluded;
464    
465     uint256 private constant MAX = ~uint256(0);
466     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
467     uint256 private _rTotal = (MAX - (MAX % _tTotal));
468     uint256 private _tFeeTotal;
469 
470     string private _name = "V4P0RR15E";
471     string private _symbol = "vRISE";
472     uint8 private _decimals = 9;
473 
474 
475     uint256 public _taxFee = 2;
476     uint256 private _previousTaxFee = _taxFee;
477     
478     uint256 public _liquidityFee = 20;
479     uint256 private _previousLiquidityFee = _liquidityFee;
480     
481     uint256 public marketingDivisor = 2;
482     
483     uint256 public _maxTxAmount = 50000 * 10**6 * 10**9; // 50 Billion
484     uint256 private minimumTokensBeforeSwap = 50000 * 10**6 * 10**9; 
485     uint256 private buyBackUpperLimit = 1 * 10**18;
486 
487     IUniswapV2Router02 public immutable uniswapV2Router;
488     address public immutable uniswapV2Pair;
489     
490     bool inSwapAndLiquify;
491     bool public swapAndLiquifyEnabled = false;
492     bool public buyBackEnabled = true;
493 
494     
495     event RewardLiquidityProviders(uint256 tokenAmount);
496     event BuyBackEnabledUpdated(bool enabled);
497     event SwapAndLiquifyEnabledUpdated(bool enabled);
498     event SwapAndLiquify(
499         uint256 tokensSwapped,
500         uint256 ethReceived,
501         uint256 tokensIntoLiqudity
502     );
503     
504     event SwapETHForTokens(
505         uint256 amountIn,
506         address[] path
507     );
508     
509     event SwapTokensForETH(
510         uint256 amountIn,
511         address[] path
512     );
513     
514     modifier lockTheSwap {
515         inSwapAndLiquify = true;
516         _;
517         inSwapAndLiquify = false;
518     }
519     
520     constructor () {
521         _rOwned[_msgSender()] = _rTotal;
522         
523         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
524         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
525             .createPair(address(this), _uniswapV2Router.WETH());
526 
527         uniswapV2Router = _uniswapV2Router;
528 
529         
530         _isExcludedFromFee[owner()] = true;
531         _isExcludedFromFee[address(this)] = true;
532         
533         emit Transfer(address(0), _msgSender(), _tTotal);
534     }
535 
536     function name() public view returns (string memory) {
537         return _name;
538     }
539 
540     function symbol() public view returns (string memory) {
541         return _symbol;
542     }
543 
544     function decimals() public view returns (uint8) {
545         return _decimals;
546     }
547 
548     function totalSupply() public view override returns (uint256) {
549         return _tTotal;
550     }
551 
552     function balanceOf(address account) public view override returns (uint256) {
553         if (_isExcluded[account]) return _tOwned[account];
554         return tokenFromReflection(_rOwned[account]);
555     }
556 
557     function transfer(address recipient, uint256 amount) public override returns (bool) {
558         _transfer(_msgSender(), recipient, amount);
559         return true;
560     }
561 
562     function allowance(address owner, address spender) public view override returns (uint256) {
563         return _allowances[owner][spender];
564     }
565 
566     function approve(address spender, uint256 amount) public override returns (bool) {
567         _approve(_msgSender(), spender, amount);
568         return true;
569     }
570 
571     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
572         _transfer(sender, recipient, amount);
573         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
574         return true;
575     }
576 
577     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
578         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
579         return true;
580     }
581 
582     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
583         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
584         return true;
585     }
586 
587     function isExcludedFromReward(address account) public view returns (bool) {
588         return _isExcluded[account];
589     }
590 
591     function totalFees() public view returns (uint256) {
592         return _tFeeTotal;
593     }
594     
595     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
596         return minimumTokensBeforeSwap;
597     }
598     
599     function buyBackUpperLimitAmount() public view returns (uint256) {
600         return buyBackUpperLimit;
601     }
602     
603     function deliver(uint256 tAmount) public {
604         address sender = _msgSender();
605         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
606         (uint256 rAmount,,,,,) = _getValues(tAmount);
607         _rOwned[sender] = _rOwned[sender].sub(rAmount);
608         _rTotal = _rTotal.sub(rAmount);
609         _tFeeTotal = _tFeeTotal.add(tAmount);
610     }
611   
612 
613     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
614         require(tAmount <= _tTotal, "Amount must be less than supply");
615         if (!deductTransferFee) {
616             (uint256 rAmount,,,,,) = _getValues(tAmount);
617             return rAmount;
618         } else {
619             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
620             return rTransferAmount;
621         }
622     }
623 
624     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
625         require(rAmount <= _rTotal, "Amount must be less than total reflections");
626         uint256 currentRate =  _getRate();
627         return rAmount.div(currentRate);
628     }
629 
630     function excludeFromReward(address account) public onlyOwner() {
631 
632         require(!_isExcluded[account], "Account is already excluded");
633         if(_rOwned[account] > 0) {
634             _tOwned[account] = tokenFromReflection(_rOwned[account]);
635         }
636         _isExcluded[account] = true;
637         _excluded.push(account);
638     }
639 
640     function includeInReward(address account) external onlyOwner() {
641         require(_isExcluded[account], "Account is already excluded");
642         for (uint256 i = 0; i < _excluded.length; i++) {
643             if (_excluded[i] == account) {
644                 _excluded[i] = _excluded[_excluded.length - 1];
645                 _tOwned[account] = 0;
646                 _isExcluded[account] = false;
647                 _excluded.pop();
648                 break;
649             }
650         }
651     }
652 
653     function _approve(address owner, address spender, uint256 amount) private {
654         require(owner != address(0), "ERC20: approve from the zero address");
655         require(spender != address(0), "ERC20: approve to the zero address");
656 
657         _allowances[owner][spender] = amount;
658         emit Approval(owner, spender, amount);
659     }
660 
661     function _transfer(
662         address from,
663         address to,
664         uint256 amount
665     ) private {
666         require(from != address(0), "ERC20: transfer from the zero address");
667         require(to != address(0), "ERC20: transfer to the zero address");
668         require(amount > 0, "Transfer amount must be greater than zero");
669         if(from != owner() && to != owner()) {
670             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
671         }
672 
673         uint256 contractTokenBalance = balanceOf(address(this));
674         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
675         
676         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
677             if (overMinimumTokenBalance) {
678                 contractTokenBalance = minimumTokensBeforeSwap;
679                 swapTokens(contractTokenBalance);    
680             }
681 	        uint256 balance = address(this).balance;
682             if (buyBackEnabled /*&& balance > uint256(1 * 10**18)*/) {
683                 
684                 if (balance > buyBackUpperLimit)
685                     balance = buyBackUpperLimit;
686                 
687                 buyBackTokens(balance.div(100));
688             }
689         }
690         
691         bool takeFee = true;
692         
693         //if any account belongs to _isExcludedFromFee account then remove the fee
694         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
695             takeFee = false;
696         }
697         
698         _tokenTransfer(from,to,amount,takeFee);
699     }
700     
701     function callMoonShot(uint256 amount) external onlyOwner(){
702 
703         
704         buyBackTokens(amount * 10**15); // i.e. "1" would equal 0.001 BNB
705     }
706 
707     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
708        
709         uint256 initialBalance = address(this).balance;
710         swapTokensForEth(contractTokenBalance);
711         uint256 transferredBalance = address(this).balance.sub(initialBalance);
712 
713         //Send to Marketing address
714         transferToAddressETH(marketingAddress, transferredBalance.div(_liquidityFee).mul(marketingDivisor));
715         
716     }
717     
718 
719     function buyBackTokens(uint256 amount) private lockTheSwap {
720     	if (amount > 0) {
721     	    swapETHForTokens(amount);
722 	    }
723     }
724     
725     function swapTokensForEth(uint256 tokenAmount) private {
726         // generate the uniswap pair path of token -> weth
727         address[] memory path = new address[](2);
728         path[0] = address(this);
729         path[1] = uniswapV2Router.WETH();
730 
731         _approve(address(this), address(uniswapV2Router), tokenAmount);
732 
733         // make the swap
734         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
735             tokenAmount,
736             0, // accept any amount of ETH
737             path,
738             address(this), // The contract
739             block.timestamp
740         );
741         
742         emit SwapTokensForETH(tokenAmount, path);
743     }
744     
745     function swapETHForTokens(uint256 amount) private {
746         // generate the uniswap pair path of token -> weth
747         address[] memory path = new address[](2);
748         path[0] = uniswapV2Router.WETH();
749         path[1] = address(this);
750 
751       // make the swap
752         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
753             0, // accept any amount of Tokens
754             path,
755             deadAddress, // Burn address
756             block.timestamp.add(300)
757         );
758         
759         emit SwapETHForTokens(amount, path);
760     }
761     
762     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
763         // approve token transfer to cover all possible scenarios
764         _approve(address(this), address(uniswapV2Router), tokenAmount);
765 
766         // add the liquidity
767         uniswapV2Router.addLiquidityETH{value: ethAmount}(
768             address(this),
769             tokenAmount,
770             0, // slippage is unavoidable
771             0, // slippage is unavoidable
772             owner(),
773             block.timestamp
774         );
775     }
776 
777     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
778         if(!takeFee)
779             removeAllFee();
780         
781         if (_isExcluded[sender] && !_isExcluded[recipient]) {
782             _transferFromExcluded(sender, recipient, amount);
783         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
784             _transferToExcluded(sender, recipient, amount);
785         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
786             _transferBothExcluded(sender, recipient, amount);
787         } else {
788             _transferStandard(sender, recipient, amount);
789         }
790         
791         if(!takeFee)
792             restoreAllFee();
793     }
794 
795     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
796         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
797         _rOwned[sender] = _rOwned[sender].sub(rAmount);
798         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
799         _takeLiquidity(tLiquidity);
800         _reflectFee(rFee, tFee);
801         emit Transfer(sender, recipient, tTransferAmount);
802     }
803 
804     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
805         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
806 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
807         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
808         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
809         _takeLiquidity(tLiquidity);
810         _reflectFee(rFee, tFee);
811         emit Transfer(sender, recipient, tTransferAmount);
812     }
813 
814     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
815         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
816     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
817         _rOwned[sender] = _rOwned[sender].sub(rAmount);
818         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
819         _takeLiquidity(tLiquidity);
820         _reflectFee(rFee, tFee);
821         emit Transfer(sender, recipient, tTransferAmount);
822     }
823 
824     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
825         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
826     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
827         _rOwned[sender] = _rOwned[sender].sub(rAmount);
828         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
829         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
830         _takeLiquidity(tLiquidity);
831         _reflectFee(rFee, tFee);
832         emit Transfer(sender, recipient, tTransferAmount);
833     }
834 
835     function _reflectFee(uint256 rFee, uint256 tFee) private {
836         _rTotal = _rTotal.sub(rFee);
837         _tFeeTotal = _tFeeTotal.add(tFee);
838     }
839 
840     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
841         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
842         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
843         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
844     }
845 
846     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
847         uint256 tFee = calculateTaxFee(tAmount);
848         uint256 tLiquidity = calculateLiquidityFee(tAmount);
849         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
850         return (tTransferAmount, tFee, tLiquidity);
851     }
852 
853     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
854         uint256 rAmount = tAmount.mul(currentRate);
855         uint256 rFee = tFee.mul(currentRate);
856         uint256 rLiquidity = tLiquidity.mul(currentRate);
857         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
858         return (rAmount, rTransferAmount, rFee);
859     }
860 
861     function _getRate() private view returns(uint256) {
862         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
863         return rSupply.div(tSupply);
864     }
865 
866     function _getCurrentSupply() private view returns(uint256, uint256) {
867         uint256 rSupply = _rTotal;
868         uint256 tSupply = _tTotal;      
869         for (uint256 i = 0; i < _excluded.length; i++) {
870             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
871             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
872             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
873         }
874         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
875         return (rSupply, tSupply);
876     }
877     
878     function _takeLiquidity(uint256 tLiquidity) private {
879         uint256 currentRate =  _getRate();
880         uint256 rLiquidity = tLiquidity.mul(currentRate);
881         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
882         if(_isExcluded[address(this)])
883             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
884     }
885     
886     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
887         return _amount.mul(_taxFee).div(
888             10**2
889         );
890     }
891     
892     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
893         return _amount.mul(_liquidityFee).div(
894             10**2
895         );
896     }
897     
898     function removeAllFee() private {
899         if(_taxFee == 0 && _liquidityFee == 0) return;
900         
901         _previousTaxFee = _taxFee;
902         _previousLiquidityFee = _liquidityFee;
903         
904         _taxFee = 0;
905         _liquidityFee = 0;
906     }
907     
908     function restoreAllFee() private {
909         _taxFee = _previousTaxFee;
910         _liquidityFee = _previousLiquidityFee;
911     }
912 
913     function isExcludedFromFee(address account) public view returns(bool) {
914         return _isExcludedFromFee[account];
915     }
916     
917     function excludeFromFee(address account) public onlyOwner {
918         _isExcludedFromFee[account] = true;
919     }
920     
921     function includeInFee(address account) public onlyOwner {
922         _isExcludedFromFee[account] = false;
923     }
924     
925     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
926         _taxFee = taxFee;
927     }
928     
929     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
930         _liquidityFee = liquidityFee;
931     }
932     
933     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
934         _maxTxAmount = maxTxAmount;
935     }
936     
937     function setMarketingDivisor(uint256 divisor) external onlyOwner() {
938         marketingDivisor = divisor;
939     }
940 
941     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
942         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
943     }
944     
945      function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
946         buyBackUpperLimit = buyBackLimit * 10**18;
947     }
948 
949     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
950         marketingAddress = payable(_marketingAddress);
951     }
952 
953     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
954         swapAndLiquifyEnabled = _enabled;
955         emit SwapAndLiquifyEnabledUpdated(_enabled);
956     }
957     
958     function setBuyBackEnabled(bool _enabled) public onlyOwner {
959         buyBackEnabled = _enabled;
960         emit BuyBackEnabledUpdated(_enabled);
961     }
962     
963     function prepareForPreSale() external onlyOwner {
964         setSwapAndLiquifyEnabled(false);
965         _taxFee = 0;
966         _liquidityFee = 0;
967         _maxTxAmount = 1000000000 * 10**6 * 10**9;
968     }
969     
970     function afterPreSale() external onlyOwner {
971         setSwapAndLiquifyEnabled(true);
972         _taxFee = 2;
973         _liquidityFee = 20;
974         _maxTxAmount = 50000 * 10**6 * 10**9;
975     }
976     
977     function transferToAddressETH(address payable recipient, uint256 amount) private {
978         recipient.transfer(amount);
979     }
980     
981      //to recieve ETH from uniswapV2Router when swapping
982     receive() external payable {}
983 }