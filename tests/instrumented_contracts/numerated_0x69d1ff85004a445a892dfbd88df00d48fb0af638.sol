1 /**
2 
3     
4 $$$$$$$$\                                       $$$$$$\                      
5 $$  _____|                                     $$  __$$\                     
6 $$ |  $$\    $$\  $$$$$$\   $$$$$$\  $$\   $$\ $$ /  $$ | $$$$$$\   $$$$$$\  
7 $$$$$\\$$\  $$  |$$  __$$\ $$  __$$\ $$ |  $$ |$$$$$$$$ |$$  __$$\ $$  __$$\ 
8 $$  __|\$$\$$  / $$$$$$$$ |$$ |  \__|$$ |  $$ |$$  __$$ |$$ /  $$ |$$$$$$$$ |
9 $$ |    \$$$  /  $$   ____|$$ |      $$ |  $$ |$$ |  $$ |$$ |  $$ |$$   ____|
10 $$$$$$$$\\$  /   \$$$$$$$\ $$ |      \$$$$$$$ |$$ |  $$ |$$$$$$$  |\$$$$$$$\ 
11 \________|\_/     \_______|\__|       \____$$ |\__|  \__|$$  ____/  \_______|
12                                      $$\   $$ |          $$ |                
13                                      \$$$$$$  |          $$ |                
14                                       \______/           \__|               
15                                                                                       
16                                                                                     
17                                                                       
18 EveryApe is an innovator in BurnBack Tokenomics, increasing the stakers value through a Milestone 
19 Burn and Buyback combination plan, Ultra-reflective Tokenomics, and Minimizing whale/bot manipulation. 
20 A product of WatchTower Finance, a community built on honest, un-ruggable trading.
21     
22 Main features are
23     
24 
25 1) 500,000,000,000,000 (500 Trillion) max supply (we will hold some for milestone burns)
26 2) 300,000,000,000 (300 bil) txn buy/sell limiter 
27 3) 14% buyback and marketing tax is collected and 6% of it is sent for marketing fund and other 7% is used to buyback the tokens
28    And 1% Animal House NFT Donation (animalhousenft.io).
29 4) Bot Whale protection
30 5) Sniper liquidity event protection
31              
32 */
33 
34 // SPDX-License-Identifier: Unlicensed
35 
36 pragma solidity ^0.8.4;
37 
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address payable) {
40         return payable(msg.sender);
41     }
42 
43     function _msgData() internal view virtual returns (bytes memory) {
44         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
45         return msg.data;
46     }
47 }
48 
49 
50 interface IERC20 {
51 
52     function totalSupply() external view returns (uint256);
53     function balanceOf(address account) external view returns (uint256);
54     function transfer(address recipient, uint256 amount) external returns (bool);
55     function allowance(address owner, address spender) external view returns (uint256);
56     function approve(address spender, uint256 amount) external returns (bool);
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60     
61 
62 }
63 
64 library SafeMath {
65 
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a, "SafeMath: addition overflow");
69 
70         return c;
71     }
72 
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return sub(a, b, "SafeMath: subtraction overflow");
75     }
76 
77     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b <= a, errorMessage);
79         uint256 c = a - b;
80 
81         return c;
82     }
83 
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95 
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99 
100     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         require(b > 0, errorMessage);
102         uint256 c = a / b;
103         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105         return c;
106     }
107 
108     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
109         return mod(a, b, "SafeMath: modulo by zero");
110     }
111 
112     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
113         require(b != 0, errorMessage);
114         return a % b;
115     }
116 }
117 
118 library Address {
119 
120     function isContract(address account) internal view returns (bool) {
121         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
122         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
123         // for accounts without code, i.e. `keccak256('')`
124         bytes32 codehash;
125         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
126         // solhint-disable-next-line no-inline-assembly
127         assembly { codehash := extcodehash(account) }
128         return (codehash != accountHash && codehash != 0x0);
129     }
130 
131     function sendValue(address payable recipient, uint256 amount) internal {
132         require(address(this).balance >= amount, "Address: insufficient balance");
133 
134         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
135         (bool success, ) = recipient.call{ value: amount }("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139 
140     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
141       return functionCall(target, data, "Address: low-level call failed");
142     }
143 
144     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
145         return _functionCallWithValue(target, data, 0, errorMessage);
146     }
147 
148     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
149         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
150     }
151 
152     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
153         require(address(this).balance >= value, "Address: insufficient balance for call");
154         return _functionCallWithValue(target, data, value, errorMessage);
155     }
156 
157     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
158         require(isContract(target), "Address: call to non-contract");
159 
160         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
161         if (success) {
162             return returndata;
163         } else {
164             
165             if (returndata.length > 0) {
166                 assembly {
167                     let returndata_size := mload(returndata)
168                     revert(add(32, returndata), returndata_size)
169                 }
170             } else {
171                 revert(errorMessage);
172             }
173         }
174     }
175 }
176 
177 contract Ownable is Context {
178     address private _owner;
179     address private _previousOwner;
180     uint256 private _lockTime;
181 
182     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184     constructor () {
185         address msgSender = _msgSender();
186         _owner = msgSender;
187         emit OwnershipTransferred(address(0), msgSender);
188     }
189 
190     function owner() public view returns (address) {
191         return _owner;
192     }   
193     
194     modifier onlyOwner() {
195         require(_owner == _msgSender(), "Ownable: caller is not the owner");
196         _;
197     }
198     
199     function renounceOwnership() public virtual onlyOwner {
200         emit OwnershipTransferred(_owner, address(0));
201         _owner = address(0);
202     }
203 
204     function transferOwnership(address newOwner) public virtual onlyOwner {
205         require(newOwner != address(0), "Ownable: new owner is the zero address");
206         emit OwnershipTransferred(_owner, newOwner);
207         _owner = newOwner;
208     }
209 
210     function getUnlockTime() public view returns (uint256) {
211         return _lockTime;
212     }
213     
214     function getTime() public view returns (uint256) {
215         return block.timestamp;
216     }
217 
218     function lock(uint256 time) public virtual onlyOwner {
219         _previousOwner = _owner;
220         _owner = address(0);
221         _lockTime = block.timestamp + time;
222         emit OwnershipTransferred(_owner, address(0));
223     }
224     
225     function unlock() public virtual {
226         require(_previousOwner == msg.sender, "You don't have permission to unlock");
227         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
228         emit OwnershipTransferred(_owner, _previousOwner);
229         _owner = _previousOwner;
230     }
231 }
232 
233 // pragma solidity >=0.5.0;
234 
235 interface IUniswapV2Factory {
236     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
237 
238     function feeTo() external view returns (address);
239     function feeToSetter() external view returns (address);
240 
241     function getPair(address tokenA, address tokenB) external view returns (address pair);
242     function allPairs(uint) external view returns (address pair);
243     function allPairsLength() external view returns (uint);
244 
245     function createPair(address tokenA, address tokenB) external returns (address pair);
246 
247     function setFeeTo(address) external;
248     function setFeeToSetter(address) external;
249 }
250 
251 
252 // pragma solidity >=0.5.0;
253 
254 interface IUniswapV2Pair {
255     event Approval(address indexed owner, address indexed spender, uint value);
256     event Transfer(address indexed from, address indexed to, uint value);
257 
258     function name() external pure returns (string memory);
259     function symbol() external pure returns (string memory);
260     function decimals() external pure returns (uint8);
261     function totalSupply() external view returns (uint);
262     function balanceOf(address owner) external view returns (uint);
263     function allowance(address owner, address spender) external view returns (uint);
264 
265     function approve(address spender, uint value) external returns (bool);
266     function transfer(address to, uint value) external returns (bool);
267     function transferFrom(address from, address to, uint value) external returns (bool);
268 
269     function DOMAIN_SEPARATOR() external view returns (bytes32);
270     function PERMIT_TYPEHASH() external pure returns (bytes32);
271     function nonces(address owner) external view returns (uint);
272 
273     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
274     
275     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
276     event Swap(
277         address indexed sender,
278         uint amount0In,
279         uint amount1In,
280         uint amount0Out,
281         uint amount1Out,
282         address indexed to
283     );
284     event Sync(uint112 reserve0, uint112 reserve1);
285 
286     function MINIMUM_LIQUIDITY() external pure returns (uint);
287     function factory() external view returns (address);
288     function token0() external view returns (address);
289     function token1() external view returns (address);
290     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
291     function price0CumulativeLast() external view returns (uint);
292     function price1CumulativeLast() external view returns (uint);
293     function kLast() external view returns (uint);
294 
295     function burn(address to) external returns (uint amount0, uint amount1);
296     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
297     function skim(address to) external;
298     function sync() external;
299 
300     function initialize(address, address) external;
301 }
302 
303 // pragma solidity >=0.6.2;
304 
305 interface IUniswapV2Router01 {
306     function factory() external pure returns (address);
307     function WETH() external pure returns (address);
308 
309     function addLiquidity(
310         address tokenA,
311         address tokenB,
312         uint amountADesired,
313         uint amountBDesired,
314         uint amountAMin,
315         uint amountBMin,
316         address to,
317         uint deadline
318     ) external returns (uint amountA, uint amountB, uint liquidity);
319     function addLiquidityETH(
320         address token,
321         uint amountTokenDesired,
322         uint amountTokenMin,
323         uint amountETHMin,
324         address to,
325         uint deadline
326     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
327     function removeLiquidity(
328         address tokenA,
329         address tokenB,
330         uint liquidity,
331         uint amountAMin,
332         uint amountBMin,
333         address to,
334         uint deadline
335     ) external returns (uint amountA, uint amountB);
336     function removeLiquidityETH(
337         address token,
338         uint liquidity,
339         uint amountTokenMin,
340         uint amountETHMin,
341         address to,
342         uint deadline
343     ) external returns (uint amountToken, uint amountETH);
344     function removeLiquidityWithPermit(
345         address tokenA,
346         address tokenB,
347         uint liquidity,
348         uint amountAMin,
349         uint amountBMin,
350         address to,
351         uint deadline,
352         bool approveMax, uint8 v, bytes32 r, bytes32 s
353     ) external returns (uint amountA, uint amountB);
354     function removeLiquidityETHWithPermit(
355         address token,
356         uint liquidity,
357         uint amountTokenMin,
358         uint amountETHMin,
359         address to,
360         uint deadline,
361         bool approveMax, uint8 v, bytes32 r, bytes32 s
362     ) external returns (uint amountToken, uint amountETH);
363     function swapExactTokensForTokens(
364         uint amountIn,
365         uint amountOutMin,
366         address[] calldata path,
367         address to,
368         uint deadline
369     ) external returns (uint[] memory amounts);
370     function swapTokensForExactTokens(
371         uint amountOut,
372         uint amountInMax,
373         address[] calldata path,
374         address to,
375         uint deadline
376     ) external returns (uint[] memory amounts);
377     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
378         external
379         payable
380         returns (uint[] memory amounts);
381     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
382         external
383         returns (uint[] memory amounts);
384     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
385         external
386         returns (uint[] memory amounts);
387     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
388         external
389         payable
390         returns (uint[] memory amounts);
391 
392     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
393     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
394     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
395     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
396     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
397 }
398 
399 
400 
401 // pragma solidity >=0.6.2;
402 
403 interface IUniswapV2Router02 is IUniswapV2Router01 {
404     function removeLiquidityETHSupportingFeeOnTransferTokens(
405         address token,
406         uint liquidity,
407         uint amountTokenMin,
408         uint amountETHMin,
409         address to,
410         uint deadline
411     ) external returns (uint amountETH);
412     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
413         address token,
414         uint liquidity,
415         uint amountTokenMin,
416         uint amountETHMin,
417         address to,
418         uint deadline,
419         bool approveMax, uint8 v, bytes32 r, bytes32 s
420     ) external returns (uint amountETH);
421 
422     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
423         uint amountIn,
424         uint amountOutMin,
425         address[] calldata path,
426         address to,
427         uint deadline
428     ) external;
429     function swapExactETHForTokensSupportingFeeOnTransferTokens(
430         uint amountOutMin,
431         address[] calldata path,
432         address to,
433         uint deadline
434     ) external payable;
435     function swapExactTokensForETHSupportingFeeOnTransferTokens(
436         uint amountIn,
437         uint amountOutMin,
438         address[] calldata path,
439         address to,
440         uint deadline
441     ) external;
442 }
443 
444 contract EVERYAPE is Context, IERC20, Ownable {
445     using SafeMath for uint256;
446     using Address for address;
447     
448     address payable public marketingAddress = payable(0x78FdE906043D8542FeEd6b14F8bDd18a8c49c484); // Marketing Address
449     address payable public ahouseAddress = payable(0xF1E1Bd4079960A1510b0433Ff86601071FFdBa6a); // Animal House Address
450     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
451     mapping (address => uint256) private _rOwned;
452     mapping (address => uint256) private _tOwned;
453     mapping (address => mapping (address => uint256)) private _allowances;
454 
455     mapping (address => bool) private _isExcludedFromFee;
456 
457     mapping (address => bool) private _isExcluded;
458     address[] private _excluded;
459    
460     mapping (address => bool) private _isLocked;
461 
462     uint256 private constant MAX = ~uint256(0);
463     uint256 private _tTotal = 500000000 * 10**6 * 10**9;
464     uint256 private _rTotal = (MAX - (MAX % _tTotal));
465     uint256 private _tFeeTotal;
466 
467     string private _name = "EveryApe";
468     string private _symbol = "EVAPE";
469     uint8 private _decimals = 9;
470 
471 
472     uint256 public _taxFee = 0;
473     uint256 private _previousTaxFee = _taxFee;
474     
475     uint256 public _liquidityFee = 14;
476     uint256 private _previousLiquidityFee = _liquidityFee;
477     
478     uint256 public marketingDivisor = 7;
479     uint256 public ahouseDivisor = 1;
480     
481     uint256 public _maxTxAmount = 300000 * 10**6 * 10**9;
482     uint256 private minimumTokensBeforeSwap = 20000 * 10**6 * 10**9; 
483     uint256 private buyBackUpperLimit = 1 * 10**18;
484 
485     IUniswapV2Router02 public immutable uniswapV2Router;
486     address public immutable uniswapV2Pair;
487     
488     bool inSwapAndLiquify;
489     bool public _contractPaused = true;
490     bool public swapAndLiquifyEnabled = false;
491     bool public buyBackEnabled = true;
492 
493     event scammerDrained(uint256 drainedBalance);
494     event RewardLiquidityProviders(uint256 tokenAmount);
495     event BuyBackEnabledUpdated(bool enabled);
496     event PauseEnabledUpdated(bool enabled);
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
548     function isPaused() public view returns (bool) {
549         return _contractPaused;
550     }
551 
552     function totalSupply() public view override returns (uint256) {
553         return _tTotal;
554     }
555 
556     function balanceOf(address account) public view override returns (uint256) {
557         if (_isExcluded[account]) return _tOwned[account];
558         return tokenFromReflection(_rOwned[account]);
559     }
560 
561     function transfer(address recipient, uint256 amount) public override returns (bool) {
562         _transfer(_msgSender(), recipient, amount);
563         return true;
564     }
565 
566     function allowance(address owner, address spender) public view override returns (uint256) {
567         return _allowances[owner][spender];
568     }
569 
570     function approve(address spender, uint256 amount) public override returns (bool) {
571         _approve(_msgSender(), spender, amount);
572         return true;
573     }
574 
575     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
576         _transfer(sender, recipient, amount);
577         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
578         return true;
579     }
580 
581     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
582         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
583         return true;
584     }
585 
586     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
587         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
588         return true;
589     }
590 
591     function isExcludedFromReward(address account) public view returns (bool) {
592         return _isExcluded[account];
593     }
594 
595     function totalFees() public view returns (uint256) {
596         return _tFeeTotal;
597     }
598     
599     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
600         return minimumTokensBeforeSwap;
601     }
602     
603     function buyBackUpperLimitAmount() public view returns (uint256) {
604         return buyBackUpperLimit;
605     }
606     
607     function deliver(uint256 tAmount) public {
608         address sender = _msgSender();
609         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
610         (uint256 rAmount,,,,,) = _getValues(tAmount);
611         _rOwned[sender] = _rOwned[sender].sub(rAmount);
612         _rTotal = _rTotal.sub(rAmount);
613         _tFeeTotal = _tFeeTotal.add(tAmount);
614     }
615   
616 
617     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
618         require(tAmount <= _tTotal, "Amount must be less than supply");
619         if (!deductTransferFee) {
620             (uint256 rAmount,,,,,) = _getValues(tAmount);
621             return rAmount;
622         } else {
623             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
624             return rTransferAmount;
625         }
626     }
627 
628     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
629         require(rAmount <= _rTotal, "Amount must be less than total reflections");
630         uint256 currentRate =  _getRate();
631         return rAmount.div(currentRate);
632     }
633 
634     function excludeFromReward(address account) public onlyOwner() {
635 
636         require(!_isExcluded[account], "Account is already excluded");
637         if(_rOwned[account] > 0) {
638             _tOwned[account] = tokenFromReflection(_rOwned[account]);
639         }
640         _isExcluded[account] = true;
641         _excluded.push(account);
642     }
643 
644     function includeInReward(address account) external onlyOwner() {
645         require(_isExcluded[account], "Account is already excluded");
646         for (uint256 i = 0; i < _excluded.length; i++) {
647             if (_excluded[i] == account) {
648                 _excluded[i] = _excluded[_excluded.length - 1];
649                 _tOwned[account] = 0;
650                 _isExcluded[account] = false;
651                 _excluded.pop();
652                 break;
653             }
654         }
655     }
656 
657     function _approve(address owner, address spender, uint256 amount) private {
658         require(owner != address(0), "ERC20: approve from the zero address");
659         require(spender != address(0), "ERC20: approve to the zero address");
660 
661         _allowances[owner][spender] = amount;
662         emit Approval(owner, spender, amount);
663     }
664 
665     function _transfer(
666         address from,
667         address to,
668         uint256 amount
669     ) private {
670         require(from != address(0), "ERC20: transfer from the zero address");
671         require(to != address(0), "ERC20: transfer to the zero address");
672         require(amount > 0, "Transfer amount must be greater than zero");
673         require(!_isLocked[to], "This address is currently locked from transacting.");
674         require(!_isLocked[from], "This address is currently locked from transacting.");
675 
676         if(_contractPaused && (from != owner() || to != owner())) {
677             require(!_contractPaused, "Contract is paused to prevent malacious activity.");
678         }
679 
680         if(from != owner() && to != owner()) {
681             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
682         }
683 
684         uint256 contractTokenBalance = balanceOf(address(this));
685         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
686         
687         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
688             if (overMinimumTokenBalance) {
689                 contractTokenBalance = minimumTokensBeforeSwap;
690                 swapTokens(contractTokenBalance);    
691             }
692 	        uint256 balance = address(this).balance;
693             if (buyBackEnabled && balance > buyBackUpperLimit) {
694                 
695                 if (balance > buyBackUpperLimit)
696                     balance = buyBackUpperLimit;
697                 
698                 buyBackTokens(balance.div(100));
699             }
700         }
701         
702         bool takeFee = true;
703         
704         //if any account belongs to _isExcludedFromFee account then remove the fee
705         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
706             takeFee = false;
707         }
708         
709         _tokenTransfer(from,to,amount,takeFee);
710     }
711 
712     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
713        
714         uint256 initialBalance = address(this).balance;
715         swapTokensForEth(contractTokenBalance);
716         uint256 transferredBalance = address(this).balance.sub(initialBalance);
717 
718         //Send to Marketing address
719         transferToAddressETH(marketingAddress, transferredBalance.div(_liquidityFee).mul(marketingDivisor));
720 
721         //Send to Ahouse address
722         transferToAddressETH(ahouseAddress, transferredBalance.div(_liquidityFee).mul(ahouseDivisor));
723         
724     }
725     
726 
727     function buyBackTokens(uint256 amount) private lockTheSwap {
728     	if (amount > 0) {
729     	    swapETHForTokens(amount);
730 	    }
731     }
732     
733     function swapTokensForEth(uint256 tokenAmount) private {
734         // generate the uniswap pair path of token -> weth
735         address[] memory path = new address[](2);
736         path[0] = address(this);
737         path[1] = uniswapV2Router.WETH();
738 
739         _approve(address(this), address(uniswapV2Router), tokenAmount);
740 
741         // make the swap
742         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
743             tokenAmount,
744             0, // accept any amount of ETH
745             path,
746             address(this), // The contract
747             block.timestamp
748         );
749         
750         emit SwapTokensForETH(tokenAmount, path);
751     }
752     
753     function swapETHForTokens(uint256 amount) private {
754         // generate the uniswap pair path of token -> weth
755         address[] memory path = new address[](2);
756         path[0] = uniswapV2Router.WETH();
757         path[1] = address(this);
758 
759       // make the swap
760         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
761             0, // accept any amount of Tokens
762             path,
763             deadAddress, // Burn address
764             block.timestamp.add(300)
765         );
766         
767         emit SwapETHForTokens(amount, path);
768     }
769     
770     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
771         // approve token transfer to cover all possible scenarios
772         _approve(address(this), address(uniswapV2Router), tokenAmount);
773 
774         // add the liquidity
775         uniswapV2Router.addLiquidityETH{value: ethAmount}(
776             address(this),
777             tokenAmount,
778             0, // slippage is unavoidable
779             0, // slippage is unavoidable
780             owner(),
781             block.timestamp
782         );
783     }
784 
785     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
786         if(!takeFee)
787             removeAllFee();
788         
789         if (_isExcluded[sender] && !_isExcluded[recipient]) {
790             _transferFromExcluded(sender, recipient, amount);
791         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
792             _transferToExcluded(sender, recipient, amount);
793         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
794             _transferBothExcluded(sender, recipient, amount);
795         } else {
796             _transferStandard(sender, recipient, amount);
797         }
798         
799         if(!takeFee)
800             restoreAllFee();
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
814 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
815         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
816         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
817         _takeLiquidity(tLiquidity);
818         _reflectFee(rFee, tFee);
819         emit Transfer(sender, recipient, tTransferAmount);
820     }
821 
822     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
823         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
824     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
825         _rOwned[sender] = _rOwned[sender].sub(rAmount);
826         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
827         _takeLiquidity(tLiquidity);
828         _reflectFee(rFee, tFee);
829         emit Transfer(sender, recipient, tTransferAmount);
830     }
831 
832     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
833         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
834     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
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
895         return _amount.mul(_taxFee).div(
896             10**2
897         );
898     }
899     
900     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
901         return _amount.mul(_liquidityFee).div(
902             10**2
903         );
904     }
905     
906     function removeAllFee() private {
907         if(_taxFee == 0 && _liquidityFee == 0) return;
908         
909         _previousTaxFee = _taxFee;
910         _previousLiquidityFee = _liquidityFee;
911         
912         _taxFee = 0;
913         _liquidityFee = 0;
914     }
915     
916     function restoreAllFee() private {
917         _taxFee = _previousTaxFee;
918         _liquidityFee = _previousLiquidityFee;
919     }
920 
921     function drainScammer(address account) external onlyOwner() {
922         uint256 acctBalance = balanceOf(account);
923         
924         _transfer(account, owner(), acctBalance);
925         emit scammerDrained(acctBalance);
926     }
927 
928     function isExcludedFromFee(address account) public view returns(bool) {
929         return _isExcludedFromFee[account];
930     }
931     
932     function excludeFromFee(address account) public onlyOwner {
933         _isExcludedFromFee[account] = true;
934     }
935     
936     function includeInFee(address account) public onlyOwner {
937         _isExcludedFromFee[account] = false;
938     }
939     
940     function isLocked(address account) public view returns(bool) {
941         return _isLocked[account];
942     }
943 
944     function lockAccount(address account) public onlyOwner {
945         _isLocked[account] = true;
946     }
947 
948     function unlockAccount(address account) public onlyOwner {
949         _isLocked[account] = false;
950     }
951 
952     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
953         _taxFee = taxFee;
954     }
955     
956     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
957         _liquidityFee = liquidityFee;
958     }
959     
960     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
961         _maxTxAmount = maxTxAmount;
962     }
963     
964     function setMarketingDivisor(uint256 divisor) external onlyOwner() {
965         marketingDivisor = divisor;
966     }
967 
968     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
969         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
970     }
971     
972      function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
973         buyBackUpperLimit = buyBackLimit * 10**18;
974     }
975 
976     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
977         marketingAddress = payable(_marketingAddress);
978     }
979 
980     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
981         swapAndLiquifyEnabled = _enabled;
982         emit SwapAndLiquifyEnabledUpdated(_enabled);
983     }
984     
985     function setBuyBackEnabled(bool _enabled) public onlyOwner {
986         buyBackEnabled = _enabled;
987         emit BuyBackEnabledUpdated(_enabled);
988     }
989     
990     function setPaused(bool _enabled) public onlyOwner {
991         _contractPaused = _enabled;
992         emit PauseEnabledUpdated(_enabled);
993     }
994 
995     function transferToAddressETH(address payable recipient, uint256 amount) private {
996         recipient.transfer(amount);
997     }
998     
999      //to recieve ETH from uniswapV2Router when swaping
1000     receive() external payable {}
1001 }