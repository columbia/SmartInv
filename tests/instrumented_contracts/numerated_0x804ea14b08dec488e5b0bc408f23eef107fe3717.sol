1 /**
2 Venom SmartContract 
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.17;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IUniswapV2Pair {
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     function name() external pure returns (string memory);
24     function symbol() external pure returns (string memory);
25     function decimals() external pure returns (uint8);
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address owner) external view returns (uint256);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 value) external returns (bool);
30     function transfer(address to, uint256 value) external returns (bool);
31     function transferFrom(address from, address to, uint256 value) external returns (bool);
32     function DOMAIN_SEPARATOR() external view returns (bytes32);
33     function PERMIT_TYPEHASH() external pure returns (bytes32);
34     function nonces(address owner) external view returns (uint256);
35 
36     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v,
37                     bytes32 r, bytes32 s) external;
38 
39     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
40     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
41     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out,
42                uint256 amount1Out, address indexed to);
43     event Sync(uint112 reserve0, uint112 reserve1);
44 
45     function MINIMUM_LIQUIDITY() external pure returns (uint256);
46     function factory() external view returns (address);
47     function token0() external view returns (address);
48     function token1() external view returns (address);
49     function getReserves() external view returns (uint112 reserve0, uint112 reserve1,
50                                                   uint32 blockTimestampLast);
51 
52     function price0CumulativeLast() external view returns (uint256);
53     function price1CumulativeLast() external view returns (uint256);
54     function kLast() external view returns (uint256);
55     function mint(address to) external returns (uint256 liquidity);
56     function burn(address to) external returns (uint256 amount0, uint256 amount1);
57 
58     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
59     function skim(address to) external;
60     function sync() external;
61     function initialize(address, address) external;
62 }
63 
64 interface IUniswapV2Factory {
65     event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
66 
67     function feeTo() external view returns (address);
68     function feeToSetter() external view returns (address);
69     function getPair(address tokenA, address tokenB) external view returns (address pair);
70     function allPairs(uint256) external view returns (address pair);
71     function allPairsLength() external view returns (uint256);
72     function createPair(address tokenA, address tokenB) external returns (address pair);
73     function setFeeTo(address) external;
74     function setFeeToSetter(address) external;
75 }
76 
77 interface IERC20 {
78     function totalSupply() external view returns (uint256);
79     function balanceOf(address account) external view returns (uint256);
80     function transfer(address recipient, uint256 amount) external returns (bool);
81     function allowance(address owner, address spender) external view returns (uint256);
82     function approve(address spender, uint256 amount) external returns (bool);
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 interface IERC20Metadata is IERC20 {
90     function name() external view returns (string memory);
91     function symbol() external view returns (string memory);
92     function decimals() external view returns (uint8);
93 }
94 
95 contract ERC20 is Context, IERC20, IERC20Metadata {
96     using SafeMath for uint256;
97 
98     mapping(address => uint256) private _balances;
99     mapping(address => mapping(address => uint256)) private _allowances;
100 
101     uint256 internal _totalSupply;
102 
103     string private _name;
104     string private _symbol;
105 
106     constructor(string memory name_, string memory symbol_) {
107         _name = name_;
108         _symbol = symbol_;
109     }
110 
111     function name() public view virtual override returns (string memory) {
112         return _name;
113     }
114 
115     function symbol() public view virtual override returns (string memory) {
116         return _symbol;
117     }
118 
119     function decimals() public view virtual override returns (uint8) {
120         return 18;
121     }
122 
123     function totalSupply() public view virtual override returns (uint256) {
124         return _totalSupply;
125     }
126 
127     function balanceOf(address account) public view virtual override returns (uint256) {
128         return _balances[account];
129     }
130 
131     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
132         _transfer(_msgSender(), recipient, amount);
133         return true;
134     }
135 
136     function allowance(address owner, address spender) public view virtual override returns (uint256) {
137         return _allowances[owner][spender];
138     }
139 
140     function approve(address spender, uint256 amount) public virtual override returns (bool) {
141         _approve(_msgSender(), spender, amount);
142         return true;
143     }
144 
145     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
146         _transfer(sender, recipient, amount);
147         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,
148                 "ERC20: transfer amount exceeds allowance"));
149         return true;
150     }
151 
152     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
153         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
154         return true;
155     }
156 
157     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
158         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue,
159                 "ERC20: decreased allowance below zero"));
160         return true;
161     }
162 
163     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
164         require(sender != address(0), "ERC20: transfer from the zero address");
165         require(recipient != address(0), "ERC20: transfer to the zero address");
166 
167         _beforeTokenTransfer(sender, recipient, amount);
168 
169         _balances[sender] = _balances[sender].sub(amount,"ERC20: transfer amount exceeds balance");
170         _balances[recipient] = _balances[recipient].add(amount);
171         emit Transfer(sender, recipient, amount);
172     }
173 
174     function _mint(address account, uint256 amount) internal virtual {
175         require(account != address(0), "ERC20: mint to the zero address");
176 
177         _beforeTokenTransfer(address(0), account, amount);
178 
179         _totalSupply = _totalSupply.add(amount);
180         _balances[account] = _balances[account].add(amount);
181         emit Transfer(address(0), account, amount);
182     }
183 
184     function _burn(address account, uint256 amount) internal virtual {
185         require(account != address(0), "ERC20: burn from the zero address");
186 
187         _beforeTokenTransfer(account, address(0), amount);
188 
189         _balances[account] = _balances[account].sub(amount,"ERC20: burn amount exceeds balance");
190         _totalSupply = _totalSupply.sub(amount);
191         emit Transfer(account, address(0), amount);
192     }
193 
194     function _approve(address owner, address spender, uint256 amount) internal virtual {
195         require(owner != address(0), "ERC20: approve from the zero address");
196         require(spender != address(0), "ERC20: approve to the zero address");
197 
198         _allowances[owner][spender] = amount;
199         emit Approval(owner, spender, amount);
200     }
201 
202     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
203 }
204 
205 interface DividendPayingTokenOptionalInterface {
206     function withdrawableDividendOf(address _owner) external view returns (uint256);
207     function withdrawnDividendOf(address _owner) external view returns (uint256);
208     function accumulativeDividendOf(address _owner) external view returns (uint256);
209 }
210 
211 interface DividendPayingTokenInterface {
212     function dividendOf(address _owner) external view returns (uint256);
213     function distributeDividends() external payable;
214     function withdrawDividend() external;
215 
216     event DividendsDistributed(address indexed from, uint256 weiAmount);
217     event DividendWithdrawn(address indexed to, uint256 weiAmount);
218 }
219 
220 library SafeMath {
221     function add(uint256 a, uint256 b) internal pure returns (uint256) {
222         uint256 c = a + b;
223         require(c >= a, "SafeMath: addition overflow");
224         return c;
225     }
226 
227     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
228         return sub(a, b, "SafeMath: subtraction overflow");
229     }
230 
231     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b <= a, errorMessage);
233         uint256 c = a - b;
234         return c;
235     }
236 
237     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
238         if (a == 0) {
239             return 0;
240         }
241 
242         uint256 c = a * b;
243         require(c / a == b, "SafeMath: multiplication overflow");
244         return c;
245     }
246 
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         return div(a, b, "SafeMath: division by zero");
249     }
250 
251     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b > 0, errorMessage);
253         uint256 c = a / b;
254         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
255         return c;
256     }
257 
258     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259         return mod(a, b, "SafeMath: modulo by zero");
260     }
261 
262     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b != 0, errorMessage);
264         return a % b;
265     }
266 }
267 
268 contract Ownable is Context {
269     address private _owner;
270 
271     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
272 
273     constructor() {
274         address msgSender = _msgSender();
275         _owner = msgSender;
276         emit OwnershipTransferred(address(0), msgSender);
277     }
278 
279     function owner() public view returns (address) {
280         return _owner;
281     }
282 
283     modifier onlyOwner() {
284         require(_owner == _msgSender(), "Ownable: caller is not the owner");
285         _;
286     }
287 
288     function renounceOwnership() public virtual onlyOwner {
289         emit OwnershipTransferred(_owner, address(0));
290         _owner = address(0);
291     }
292 
293     function transferOwnership(address newOwner) public virtual onlyOwner {
294         require(newOwner != address(0),"Ownable: new owner is the zero address");
295         emit OwnershipTransferred(_owner, newOwner);
296         _owner = newOwner;
297     }
298 }
299 
300 library SafeMathInt {
301     int256 private constant MIN_INT256 = int256(1) << 255;
302     int256 private constant MAX_INT256 = ~(int256(1) << 255);
303 
304     function mul(int256 a, int256 b) internal pure returns (int256) {
305         int256 c = a * b;
306 
307         // Detect overflow when multiplying MIN_INT256 with -1
308         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
309         require((b == 0) || (c / b == a));
310         return c;
311     }
312 
313     function div(int256 a, int256 b) internal pure returns (int256) {
314         // Prevent overflow when dividing MIN_INT256 by -1
315         require(b != -1 || a != MIN_INT256);
316 
317         // Solidity already throws when dividing by 0.
318         return a / b;
319     }
320 
321     function sub(int256 a, int256 b) internal pure returns (int256) {
322         int256 c = a - b;
323         require((b >= 0 && c <= a) || (b < 0 && c > a));
324         return c;
325     }
326 
327     function add(int256 a, int256 b) internal pure returns (int256) {
328         int256 c = a + b;
329         require((b >= 0 && c >= a) || (b < 0 && c < a));
330         return c;
331     }
332 
333     function abs(int256 a) internal pure returns (int256) {
334         require(a != MIN_INT256);
335         return a < 0 ? -a : a;
336     }
337 
338     function toUint256Safe(int256 a) internal pure returns (uint256) {
339         require(a >= 0);
340         return uint256(a);
341     }
342 }
343 
344 library SafeMathUint {
345     function toInt256Safe(uint256 a) internal pure returns (int256) {
346         int256 b = int256(a);
347         require(b >= 0);
348         return b;
349     }
350 }
351 
352 interface IUniswapV2Router01 {
353     function factory() external pure returns (address);
354 
355     function WETH() external pure returns (address);
356 
357     function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired,
358                           uint256 amountAMin, uint256 amountBMin, address to, 
359                           uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
360 
361     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin,
362                              uint256 amountETHMin, address to, uint256 deadline) external payable
363                              returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
364 
365     function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin,
366                              uint256 amountBMin, address to, uint256 deadline) external 
367                              returns (uint256 amountA, uint256 amountB);
368 
369     function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin,
370                                 uint256 amountETHMin, address to, uint256 deadline) external 
371                                 returns (uint256 amountToken, uint256 amountETH);
372 
373     function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin,
374                                        uint256 amountBMin, address to, uint256 deadline, bool approveMax,
375                                        uint8 v, bytes32 r, bytes32 s) external 
376                                        returns (uint256 amountA, uint256 amountB);
377 
378     function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin,
379                                           uint256 amountETHMin, address to, uint256 deadline, bool approveMax,
380                                           uint8 v, bytes32 r, bytes32 s) external 
381                                           returns (uint256 amountToken, uint256 amountETH);
382 
383     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
384                                       address to, uint256 deadline) external 
385                                       returns (uint256[] memory amounts);
386 
387     function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] calldata path,
388                                       address to, uint256 deadline) external 
389                                       returns (uint256[] memory amounts);
390 
391     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, 
392                                    uint256 deadline) external payable returns (uint256[] memory amounts);
393 
394     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path,
395                                    address to, uint256 deadline) external returns (uint256[] memory amounts);
396 
397     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
398                                    address to, uint256 deadline) external returns (uint256[] memory amounts);
399 
400     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to,
401                                    uint256 deadline) external payable returns (uint256[] memory amounts);
402 
403     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);
404     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut);
405     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn);
406     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
407     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
408 }
409 
410 interface IUniswapV2Router02 is IUniswapV2Router01 {
411     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin,
412                                                              uint256 amountETHMin, address to, uint256 deadline) 
413                                                              external returns (uint256 amountETH);
414 
415     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin,
416                                                                        uint256 amountETHMin, address to, uint256 deadline,
417                                                                        bool approveMax, uint8 v, bytes32 r, bytes32 s) 
418                                                                        external returns (uint256 amountETH);
419 
420     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin,
421                                                                    address[] calldata path, address to, uint256 deadline) 
422                                                                    external;
423 
424     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path,
425                                                                 address to, uint256 deadline) external payable;
426 
427     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path,
428                                                                 address to, uint256 deadline) external;
429 }
430 
431 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface
432 {
433     using SafeMath for uint256;
434     using SafeMathUint for uint256;
435     using SafeMathInt for int256;
436 
437     uint256 internal constant magnitude = 2**128;
438 
439     uint256 internal magnifiedDividendPerShare;
440 
441     mapping(address => int256) internal magnifiedDividendCorrections;
442     mapping(address => uint256) internal withdrawnDividends;
443 
444     uint256 public totalDividendsDistributed;
445 
446     constructor(string memory _name, string memory _symbol)
447         ERC20(_name, _symbol)
448     {}
449 
450     receive() external payable {
451         distributeDividends();
452     }
453 
454     function distributeDividends() public payable override {
455         require(totalSupply() > 0);
456 
457         if (msg.value > 0) {
458             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
459                 (msg.value).mul(magnitude) / totalSupply()
460             );
461             emit DividendsDistributed(msg.sender, msg.value);
462 
463             totalDividendsDistributed = totalDividendsDistributed.add(
464                 msg.value
465             );
466         }
467     }
468 
469     function withdrawDividend() public virtual override {
470         _withdrawDividendOfUser(payable(msg.sender));
471     }
472 
473     function _withdrawDividendOfUser(address payable user) internal virtual returns (uint256) {
474         uint256 _withdrawableDividend = withdrawableDividendOf(user);
475         if (_withdrawableDividend > 0) {
476             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
477             emit DividendWithdrawn(user, _withdrawableDividend);
478             (bool success, ) = user.call{value: _withdrawableDividend, gas: 3000}("");
479 
480             if (!success) {
481                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
482                 return 0;
483             }
484 
485             return _withdrawableDividend;
486         }
487 
488         return 0;
489     }
490 
491     function dividendOf(address _owner) public view override returns (uint256) {
492         return withdrawableDividendOf(_owner);
493     }
494 
495     function withdrawableDividendOf(address _owner) public view override returns (uint256) {
496         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
497     }
498 
499     function withdrawnDividendOf(address _owner) public view override returns (uint256) {
500         return withdrawnDividends[_owner];
501     }
502 
503     function accumulativeDividendOf(address _owner) public view override returns (uint256) {
504         return
505             magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
506             .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
507     }
508 
509     function _transfer(address from, address to, uint256 value) internal virtual override {
510         require(false);
511 
512         int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
513         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
514         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
515     }
516 
517     function _mint(address account, uint256 value) internal override {
518         super._mint(account, value);
519 
520         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
521         .sub((magnifiedDividendPerShare.mul(value)).toInt256Safe());
522     }
523 
524     function _burn(address account, uint256 value) internal override {
525         super._burn(account, value);
526 
527         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
528         .add((magnifiedDividendPerShare.mul(value)).toInt256Safe());
529     }
530 
531     function _setBalance(address account, uint256 newBalance) internal {
532         uint256 currentBalance = balanceOf(account);
533 
534         if (newBalance > currentBalance) {
535             uint256 mintAmount = newBalance.sub(currentBalance);
536             _mint(account, mintAmount);
537         } 
538         else if (newBalance < currentBalance) {
539             uint256 burnAmount = currentBalance.sub(newBalance);
540             _burn(account, burnAmount);
541         }
542     }
543 }
544 
545 contract Venom is ERC20, Ownable {
546     using SafeMath for uint256;
547 
548     IUniswapV2Router02 public uniswapV2Router;
549 
550     address public uniswapV2Pair;
551     address public DEAD = 0x000000000000000000000000000000000000dEaD;
552     bool private swapping;
553     bool public tradingEnabled = false;
554 
555     uint256 public sellAmount = 1;
556     uint256 public buyAmount = 1;
557 
558     uint256 private totalSellFees;
559     uint256 private totalBuyFees;
560 
561     VenomDividendTracker public dividendTracker;
562 
563     address payable public marketingWallet;
564 
565     // Max tx, dividend threshold and tax variables
566     uint256 public maxWallet;
567     uint256 public maxTX;
568     uint256 public swapTokensAtAmount;
569     uint256 public sellRewardsFee;
570     uint256 public sellDeadFees;
571     uint256 public sellMarketingFees;
572     uint256 public sellLiquidityFee;
573     uint256 public buyDeadFees;
574     uint256 public buyMarketingFees;
575     uint256 public buyLiquidityFee;
576     uint256 public buyRewardsFee;
577     uint256 public transferFee;
578 
579     bool public swapAndLiquifyEnabled = true;
580 
581     uint256 public gasForProcessing = 500000;
582 
583     mapping(address => bool) private _isExcludedFromFees;
584     mapping(address => bool) public automatedMarketMakerPairs;
585     mapping(address => bool) private canTransferBeforeTradingIsEnabled;
586     mapping(address => uint256) private tokensVesting;
587     mapping(address => bool) private _isVesting;
588     mapping(address => uint256) private _vestingTimestamp;
589     mapping(address => bool) private _diamondHands;
590     mapping(address => bool) private _multiplier;
591     mapping(address => uint256) private _holderBuy1Timestamp;
592     mapping(address => uint256) private _holderBuy2Timestamp;
593     uint256 private minimumForDiamondHands;
594 
595     // Limit variables for bot protection
596     bool public limitsInEffect = true; //boolean used to turn limits on and off
597     uint256 private gasPriceLimit; 
598     mapping(address => uint256) private _holderLastTransferBlock; // for 1 tx per block
599     mapping(address => uint256) private _holderLastTransferTimestamp; // for sell cooldown timer
600     mapping(address => uint256) private _holderFirstBuyTimestamp;
601     
602    
603     
604     uint256 public launchblock;
605     uint256 public launchtimestamp;
606     
607     uint256 public delay;
608     uint256 public cooldowntimer = 60; //default cooldown 60s
609 
610     event EnableSwapAndLiquify(bool enabled);
611     event SetPreSaleWallet(address wallet);
612     event UpdateDividendTracker(address indexed newAddress, address indexed oldAddress);
613     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
614     event TradingEnabled();
615     event UpdateFees(uint256 sellDeadFees, uint256 sellMarketingFees, uint256 sellLiquidityFee, uint256 sellRewardsFee,
616                      uint256 buyDeadFees, uint256 buyMarketingFees, uint256 buyLiquidityFee, uint256 buyRewardsFee);
617 
618     event UpdateTransferFee(uint256 transferFee);
619     event Airdrop(address holder, uint256 amount);
620     event ExcludeFromFees(address indexed account, bool isExcluded);
621     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
622     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
623     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
624     event SendDividends(uint256 amount, uint256 opAmount, bool success);
625     event ProcessedDividendTracker(uint256 iterations, uint256 claims, uint256 lastProcessedIndex,
626                                    bool indexed automatic, uint256 gas);
627 
628     event UpdatePayoutToken(address token);
629 
630     constructor() ERC20("Venom", "VNM") {
631         marketingWallet = payable(0xB4ba72b728248Ba8caC7f1A8f560324340a6c239);
632         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
633 
634         buyDeadFees = 2;
635         sellDeadFees = 2;
636         buyMarketingFees = 2;
637         sellMarketingFees = 2;
638         buyLiquidityFee = 0;
639         sellLiquidityFee = 0;
640         buyRewardsFee = 2;
641         sellRewardsFee = 2;
642         transferFee = 1;
643 
644         totalBuyFees = buyRewardsFee.add(buyLiquidityFee).add(buyMarketingFees);
645         totalSellFees = sellRewardsFee.add(sellLiquidityFee).add(sellMarketingFees);
646 
647         dividendTracker = new VenomDividendTracker(payable(this), router, address(this),
648                                                    "VenomTRACKER", "VNMTRACKER");
649 
650         uniswapV2Router = IUniswapV2Router02(router);
651         // Create a uniswap pair for this new token
652         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
653                 address(this),
654                 uniswapV2Router.WETH()
655             );
656 
657         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
658 
659         // exclude from receiving dividends
660         dividendTracker.excludeFromDividends(address(dividendTracker));
661         dividendTracker.excludeFromDividends(address(this));
662         dividendTracker.excludeFromDividends(DEAD);
663         dividendTracker.excludedFromDividends(address(0));
664         dividendTracker.excludeFromDividends(router);
665         dividendTracker.excludeFromDividends(marketingWallet);
666         dividendTracker.excludeFromDividends(owner());
667 
668         // exclude from paying fees or having max transaction amount
669         _isExcludedFromFees[address(this)] = true;
670         _isExcludedFromFees[address(dividendTracker)] = true;
671         _isExcludedFromFees[address(marketingWallet)] = true;
672         _isExcludedFromFees[msg.sender] = true;
673 
674         uint256 totalTokenSupply = (100_000_000_000) * (10**18);
675         _mint(owner(), totalTokenSupply); // only time internal mint function is ever called is to create supply
676         swapTokensAtAmount = totalTokenSupply / 2000; // 0.05%
677         minimumForDiamondHands = totalTokenSupply / 2000; // 0.05%
678         canTransferBeforeTradingIsEnabled[owner()] = true;
679         canTransferBeforeTradingIsEnabled[address(this)] = true;
680     }
681 
682     function decimals() public view virtual override returns (uint8) {
683         return 18;
684     }
685 
686     receive() external payable {}
687 
688     // writeable function to enable trading, can only enable, trading can never be disabled
689     function enableTrading(uint256 initialMaxGwei, uint256 initialMaxWallet, uint256 initialMaxTX,
690                            uint256 setDelay) external onlyOwner {
691         initialMaxWallet = initialMaxWallet * (10**18);
692         initialMaxTX = initialMaxTX * (10**18);
693         require(!tradingEnabled);
694         require(initialMaxWallet >= _totalSupply / 1000,"cannot set below 0.1%");
695         require(initialMaxTX >= _totalSupply / 1000,"cannot set below 0.1%");
696         maxWallet = initialMaxWallet;
697         maxTX = initialMaxTX;
698         gasPriceLimit = initialMaxGwei * 1 gwei;
699         tradingEnabled = true;
700         launchblock = block.number;
701         launchtimestamp = block.timestamp;
702         delay = setDelay;
703         emit TradingEnabled();
704     }
705     // use for pre sale wallet, adds all exclusions to it
706     function setPresaleWallet(address wallet) external onlyOwner {
707         canTransferBeforeTradingIsEnabled[wallet] = true;
708         _isExcludedFromFees[wallet] = true;
709         dividendTracker.excludeFromDividends(wallet);
710         emit SetPreSaleWallet(wallet);
711     }
712     
713     // exclude a wallet from fees 
714     function setExcludeFees(address account, bool excluded) public onlyOwner {
715         _isExcludedFromFees[account] = excluded;
716         emit ExcludeFromFees(account, excluded);
717     }
718 
719     // exclude from dividends (rewards)
720     function setExcludeDividends(address account) public onlyOwner {
721         dividendTracker.excludeFromDividends(account);
722     }
723 
724     // include in dividends 
725     function setIncludeDividends(address account) public onlyOwner {
726         dividendTracker.includeFromDividends(account);
727         dividendTracker.setBalance(account, getMultiplier(account));
728     }
729 
730     //allow a wallet to trade before trading enabled
731     function setCanTransferBefore(address wallet, bool enable) external onlyOwner {
732         canTransferBeforeTradingIsEnabled[wallet] = enable;
733     }
734 
735     // turn limits on and off
736     function setLimitsInEffect(bool value) external onlyOwner {
737         limitsInEffect = value;
738     }
739 
740     // set max GWEI
741     function setGasPriceLimit(uint256 GWEI) external onlyOwner {
742         require(GWEI >= 50, "can never be set lower than 50");
743         gasPriceLimit = GWEI * 1 gwei;
744     }
745 
746     // set cooldown timer, can only be between 0 and 300 seconds (5 mins max)
747     function setcooldowntimer(uint256 value) external onlyOwner {
748         require(value <= 300, "cooldown timer cannot exceed 5 minutes");
749         cooldowntimer = value;
750     }
751 
752     // set max wallet, can not be lower than 0.1% of supply
753     function setmaxWallet(uint256 value) external onlyOwner {
754         value = value * (10**18);
755         require(value >= _totalSupply / 1000, "max wallet cannot be set to less than 0.1%");
756         maxWallet = value;
757     }
758 
759     // in case any ETH gets stuck in the contract
760     function Sweep() external onlyOwner {
761         uint256 amountETH = address(this).balance;
762         payable(msg.sender).transfer(amountETH);
763     }
764 
765     // set max tx, can not be lower than 0.1% of supply
766     function setmaxTX(uint256 value) external onlyOwner {
767         value = value * (10**18);
768         require(value >= _totalSupply / 1000, "max tx cannot be set to less than 0.1%");
769         maxTX = value;
770     }
771 
772     function setMinimumForDiamondHands (uint256 value) external onlyOwner {
773         value = value * (10**18);
774         require(value <= _totalSupply / 2000, "cannot be set to more than 0.05%");
775         minimumForDiamondHands = value;
776     }
777 
778     // rewards threshold
779     function setSwapTriggerAmount(uint256 amount) public onlyOwner {
780         swapTokensAtAmount = amount * (10**18);
781     }
782 
783     function enableSwapAndLiquify(bool enabled) public onlyOwner {
784         require(swapAndLiquifyEnabled != enabled);
785         swapAndLiquifyEnabled = enabled;
786         emit EnableSwapAndLiquify(enabled);
787     }
788 
789     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
790         _setAutomatedMarketMakerPair(pair, value);
791     }
792 
793     function setAllowCustomTokens(bool allow) public onlyOwner {
794         dividendTracker.setAllowCustomTokens(allow);
795     }
796 
797     function setAllowAutoReinvest(bool allow) public onlyOwner {
798         dividendTracker.setAllowAutoReinvest(allow);
799     }
800 
801     function _setAutomatedMarketMakerPair(address pair, bool value) private {
802         automatedMarketMakerPairs[pair] = value;
803 
804         if (value) {
805             dividendTracker.excludeFromDividends(pair);
806         }
807 
808         emit SetAutomatedMarketMakerPair(pair, value);
809     }
810 
811     function updateGasForProcessing(uint256 newValue) public onlyOwner {
812         require(newValue >= 200000 && newValue <= 5000000);
813         emit GasForProcessingUpdated(newValue, gasForProcessing);
814         gasForProcessing = newValue;
815     }
816 
817     function transferAdmin(address newOwner) public onlyOwner {
818         dividendTracker.excludeFromDividends(newOwner);
819         _isExcludedFromFees[newOwner] = true;
820         transferOwnership(newOwner);
821     }
822 
823     function updateTransferFee(uint256 newTransferFee) public onlyOwner {
824         require (newTransferFee <= 5, "transfer fee cannot exceed 5%");
825         transferFee = newTransferFee;
826         emit UpdateTransferFee(transferFee);
827     }
828 
829     function updateRewardsMultiplier() external {
830         if (!_multiplier[msg.sender]) {
831                     _multiplier[msg.sender] = true;
832                 }
833         dividendTracker.setBalance(msg.sender, getMultiplier(msg.sender));
834     }
835 
836     function updateFees(uint256 deadBuy, uint256 deadSell, uint256 marketingBuy, uint256 marketingSell,
837                         uint256 liquidityBuy, uint256 liquiditySell, uint256 RewardsBuy,
838                         uint256 RewardsSell) public onlyOwner {
839         
840         buyDeadFees = deadBuy;
841         buyMarketingFees = marketingBuy;
842         buyLiquidityFee = liquidityBuy;
843         buyRewardsFee = RewardsBuy;
844         sellDeadFees = deadSell;
845         sellMarketingFees = marketingSell;
846         sellLiquidityFee = liquiditySell;
847         sellRewardsFee = RewardsSell;
848 
849         totalSellFees = sellRewardsFee.add(sellLiquidityFee).add(sellMarketingFees);
850 
851         totalBuyFees = buyRewardsFee.add(buyLiquidityFee).add(buyMarketingFees);
852         require(deadBuy <= 3 && deadSell <= 3, "burn fees cannot exceed 3%");
853         require(totalSellFees <= 10 && totalBuyFees <= 10, "total fees cannot exceed 10%");
854 
855         emit UpdateFees(sellDeadFees, sellMarketingFees, sellLiquidityFee, sellRewardsFee, buyDeadFees,
856                         buyMarketingFees, buyLiquidityFee, buyRewardsFee);
857     }
858 
859     function getTotalDividendsDistributed() external view returns (uint256) {
860         return dividendTracker.totalDividendsDistributed();
861     }
862 
863     function isExcludedFromFees(address account) public view returns (bool) {
864         return _isExcludedFromFees[account];
865     }
866 
867     function withdrawableDividendOf(address account) public view returns (uint256) {
868         return dividendTracker.withdrawableDividendOf(account);
869     }
870 
871     function dividendTokenBalanceOf(address account) public view returns (uint256) {
872         return dividendTracker.balanceOf(account);
873     }
874 
875     function getAccountDividendsInfo(address account) external view returns (address, int256, int256, uint256,
876                                                                              uint256, uint256) {
877         return dividendTracker.getAccount(account);
878     }
879 
880     function getAccountDividendsInfoAtIndex(uint256 index) external view returns (address, int256, int256,
881                                                                                   uint256, uint256, uint256) {
882         return dividendTracker.getAccountAtIndex(index);
883     }
884 
885     function processDividendTracker(uint256 gas) external {
886         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
887         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas);
888     }
889 
890     function claim() external {
891         dividendTracker.processAccount(payable(msg.sender), false);
892     }
893 
894     function getLastProcessedIndex() external view returns (uint256) {
895         return dividendTracker.getLastProcessedIndex();
896     }
897 
898     function getNumberOfDividendTokenHolders() external view returns (uint256) {
899         return dividendTracker.getNumberOfTokenHolders();
900     }
901 
902     function setAutoClaim(bool value) external {
903         dividendTracker.setAutoClaim(msg.sender, value);
904     }
905 
906     function setReinvest(bool value) external {
907         dividendTracker.setReinvest(msg.sender, value);
908     }
909 
910     function setDividendsPaused(bool value) external onlyOwner {
911         dividendTracker.setDividendsPaused(value);
912     }
913 
914     function isExcludedFromAutoClaim(address account) external view returns (bool) {
915         return dividendTracker.isExcludedFromAutoClaim(account);
916     }
917 
918     function isReinvest(address account) external view returns (bool) {
919         return dividendTracker.isReinvest(account);
920     }
921 
922     function _transfer(address from, address to, uint256 amount) internal override {
923         require(from != address(0), "ERC20: transfer from the zero address");
924         require(to != address(0), "ERC20: transfer to the zero address");
925         uint256 RewardsFee;
926         uint256 deadFees;
927         uint256 marketingFees;
928         uint256 liquidityFee;
929 
930         if (!canTransferBeforeTradingIsEnabled[from]) {
931             require(tradingEnabled, "Trading has not yet been enabled");
932         }
933         if (amount == 0) {
934             super._transfer(from, to, 0);
935             return;
936         } 
937 
938         if (_isVesting[from]) {
939             if (block.timestamp < _vestingTimestamp[from] + 5 minutes) {
940                 require(balanceOf(from) - amount >= tokensVesting[from], "cant sell vested tokens");
941             }
942             else {
943                 tokensVesting[from] = 0;
944                 _isVesting[from] = false;
945             }
946         }
947 
948         
949         else if (!swapping && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
950             bool isSelling = automatedMarketMakerPairs[to];
951             bool isBuying = automatedMarketMakerPairs[from];
952 
953             if (!isBuying && !isSelling) {
954                 if (!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
955                     uint256 tFees = amount.mul(transferFee).div(100);
956                     amount = amount.sub(tFees);
957                     super._transfer(from, address(this), tFees);
958                     super._transfer(from, to, amount);
959                     dividendTracker.setBalance(from, getMultiplier(from));
960                     dividendTracker.setBalance(to, getMultiplier(to));
961                     _diamondHands[from] = false;
962                     _multiplier[from] = false;
963                     _holderFirstBuyTimestamp[from] = block.timestamp;
964                     return;
965                 }
966                 else {
967                     super._transfer(from, to, amount);
968                     dividendTracker.setBalance(from, getMultiplier(from));
969                     dividendTracker.setBalance(to, getMultiplier(to));
970                     _diamondHands[from] = false;
971                     _multiplier[from] = false;
972                     _holderFirstBuyTimestamp[from] = block.timestamp;
973                     return;
974                 }
975             }
976 
977             else if (isSelling) {
978                 if (amount >= minimumForDiamondHands) {
979                     RewardsFee = 8;
980                 }
981                 else {
982                     RewardsFee = sellRewardsFee;
983                 }
984                 deadFees = sellDeadFees;
985                 marketingFees = sellMarketingFees;
986                 liquidityFee = sellLiquidityFee;
987 
988                 if (limitsInEffect) {
989                 require(block.timestamp >= _holderLastTransferTimestamp[from] + cooldowntimer,
990                         "cooldown period active");
991                 require(amount <= maxTX,"above max transaction limit");
992                 _holderLastTransferTimestamp[from] = block.timestamp;
993 
994                 }
995                 _diamondHands[from] = false;
996                 _multiplier[from] = false;
997                 _holderFirstBuyTimestamp[from] = block.timestamp;
998 
999 
1000             } else if (isBuying) {
1001 
1002                 if (_diamondHands[to]) {
1003                     if (block.timestamp >= _holderBuy1Timestamp[to] + 1 days && balanceOf(to) >= minimumForDiamondHands) {
1004                         super._transfer(from, to, amount);
1005                         dividendTracker.setBalance(from, getMultiplier(from));
1006                         dividendTracker.setBalance(to, getMultiplier(to));
1007                         return;
1008                     }
1009                 }
1010 
1011                 if (!_multiplier[to]) {
1012                     _multiplier[to] = true;
1013                     _holderFirstBuyTimestamp[to] = block.timestamp;
1014                 }
1015 
1016                 if (!_diamondHands[to]) {
1017                     _diamondHands[to] = true;
1018                     _holderBuy1Timestamp[to] = block.timestamp;
1019                 }
1020 
1021                 RewardsFee = buyRewardsFee;
1022                 deadFees = buyDeadFees;
1023                 marketingFees = buyMarketingFees;
1024                 liquidityFee = buyLiquidityFee;
1025 
1026                 if (limitsInEffect) {
1027                 require(block.timestamp > launchtimestamp + delay,"you shall not pass");
1028                 require(tx.gasprice <= gasPriceLimit,"Gas price exceeds limit.");
1029                 require(_holderLastTransferBlock[to] != block.number,"Too many TX in block");
1030                 require(amount <= maxTX,"above max transaction limit");
1031                 _holderLastTransferBlock[to] = block.number;
1032                 }
1033 
1034                 uint256 contractBalanceRecipient = balanceOf(to);
1035                 require(contractBalanceRecipient + amount <= maxWallet,"Exceeds maximum wallet token amount." );
1036             }
1037 
1038             uint256 totalFees = RewardsFee.add(liquidityFee + marketingFees);
1039 
1040             uint256 contractTokenBalance = balanceOf(address(this));
1041 
1042             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1043 
1044             if (canSwap && isSelling) {
1045                 swapping = true;
1046 
1047                 if (swapAndLiquifyEnabled && liquidityFee > 0 && totalBuyFees > 0) {
1048                     uint256 totalBuySell = buyAmount.add(sellAmount);
1049                     uint256 swapAmountBought = contractTokenBalance.mul(buyAmount).div(totalBuySell);
1050                     uint256 swapAmountSold = contractTokenBalance.mul(sellAmount).div(totalBuySell);
1051                     uint256 swapBuyTokens = swapAmountBought.mul(liquidityFee).div(totalBuyFees);
1052                     uint256 swapSellTokens = swapAmountSold.mul(liquidityFee).div(totalSellFees);
1053                     uint256 swapTokens = swapSellTokens.add(swapBuyTokens);
1054 
1055                     swapAndLiquify(swapTokens);
1056                 }
1057 
1058                 uint256 remainingBalance = balanceOf(address(this));
1059                 swapAndSendDividends(remainingBalance);
1060                 buyAmount = 1;
1061                 sellAmount = 1;
1062                 swapping = false;
1063             }
1064 
1065             uint256 fees = amount.mul(totalFees).div(100);
1066             uint256 burntokens;
1067 
1068             if (deadFees > 0) {
1069             burntokens = amount.mul(deadFees) / 100;
1070             super._transfer(from, DEAD, burntokens);
1071             _totalSupply = _totalSupply.sub(burntokens);
1072 
1073             }
1074 
1075             amount = amount.sub(fees + burntokens);
1076 
1077             if (isSelling) {
1078                 sellAmount = sellAmount.add(fees);
1079             } 
1080             else {
1081                 buyAmount = buyAmount.add(fees);
1082             }
1083 
1084             super._transfer(from, address(this), fees);
1085 
1086             uint256 gas = gasForProcessing;
1087 
1088             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1089                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas);
1090             } catch {}
1091         }
1092 
1093         super._transfer(from, to, amount);
1094         dividendTracker.setBalance(from, getMultiplier(from));
1095         dividendTracker.setBalance(to, getMultiplier(to));
1096     }
1097 
1098     function getMultiplier(address account) private view returns (uint256) {
1099         uint256 multiplier;
1100         if (_multiplier[account] && block.timestamp > _holderFirstBuyTimestamp[account] + 1 weeks && 
1101             block.timestamp < _holderFirstBuyTimestamp[account] + 2 weeks) {
1102             multiplier = balanceOf(account).mul(3);
1103         }
1104         else if (_multiplier[account] && block.timestamp > _holderFirstBuyTimestamp[account] + 2 weeks && 
1105                  block.timestamp < _holderFirstBuyTimestamp[account] + 3 weeks) {
1106                      multiplier = balanceOf(account).mul(5);
1107         }
1108         else if (_multiplier[account] && block.timestamp > _holderFirstBuyTimestamp[account] + 3 weeks) {
1109                      multiplier = balanceOf(account).mul(7);
1110         }
1111         else {
1112             multiplier = balanceOf(account);
1113         }
1114         
1115         return
1116                 multiplier;
1117     }
1118 
1119     function swapAndLiquify(uint256 tokens) private {
1120         uint256 half = tokens.div(2);
1121         uint256 otherHalf = tokens.sub(half);
1122         uint256 initialBalance = address(this).balance;
1123         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1124         uint256 newBalance = address(this).balance.sub(initialBalance);
1125         addLiquidity(otherHalf, newBalance);
1126         emit SwapAndLiquify(half, newBalance, otherHalf);
1127     }
1128 
1129     function swapTokensForEth(uint256 tokenAmount) private {
1130         address[] memory path = new address[](2);
1131         path[0] = address(this);
1132         path[1] = uniswapV2Router.WETH();
1133         _approve(address(this), address(uniswapV2Router), tokenAmount);
1134         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1135             tokenAmount,
1136             0, // accept any amount of ETH
1137             path,
1138             address(this),
1139             block.timestamp
1140         );
1141     }
1142 
1143     function updatePayoutToken(address token) public onlyOwner {
1144         dividendTracker.updatePayoutToken(token);
1145         emit UpdatePayoutToken(token);
1146     }
1147 
1148     function getPayoutToken() public view returns (address) {
1149         return dividendTracker.getPayoutToken();
1150     }
1151 
1152     function setMinimumTokenBalanceForAutoDividends(uint256 value) public onlyOwner {
1153         dividendTracker.setMinimumTokenBalanceForAutoDividends(value);
1154     }
1155 
1156     function setMinimumTokenBalanceForDividends(uint256 value) public onlyOwner {
1157         dividendTracker.setMinimumTokenBalanceForDividends(value);
1158     }
1159 
1160     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1161         // approve token transfer to cover all possible scenarios
1162         _approve(address(this), address(uniswapV2Router), tokenAmount);
1163 
1164         // add the liquidity
1165         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1166             address(this),
1167             tokenAmount,
1168             0, // slippage is unavoidable
1169             0, // slippage is unavoidable
1170             address(0),
1171             block.timestamp
1172         );
1173     }
1174 
1175     function forceSwapAndSendDividends(uint256 tokens) public onlyOwner {
1176         tokens = tokens * (10**18);
1177         uint256 totalAmount = buyAmount.add(sellAmount);
1178         uint256 fromBuy = tokens.mul(buyAmount).div(totalAmount);
1179         uint256 fromSell = tokens.mul(sellAmount).div(totalAmount);
1180 
1181         swapAndSendDividends(tokens);
1182 
1183         buyAmount = buyAmount.sub(fromBuy);
1184         sellAmount = sellAmount.sub(fromSell);
1185     }
1186 
1187     function swapAndSendDividends(uint256 tokens) private {
1188         if (tokens == 0) {
1189             return;
1190         }
1191         swapTokensForEth(tokens);
1192         uint256 totalAmount = buyAmount.add(sellAmount);
1193 
1194         bool success = true;
1195         bool successOp1 = true;
1196 
1197         uint256 dividends;
1198         uint256 dividendsFromBuy;
1199         uint256 dividendsFromSell;
1200 
1201         if (buyRewardsFee > 0) {
1202             dividendsFromBuy = address(this).balance.mul(buyAmount).div(totalAmount)
1203             .mul(buyRewardsFee).div(buyRewardsFee + buyMarketingFees);
1204         }
1205         if (sellRewardsFee > 0) {
1206             dividendsFromSell = address(this).balance.mul(sellAmount).div(totalAmount)
1207             .mul(sellRewardsFee).div(sellRewardsFee + sellMarketingFees);
1208         }
1209         dividends = dividendsFromBuy.add(dividendsFromSell);
1210 
1211         if (dividends > 0) {
1212             (success, ) = address(dividendTracker).call{value: dividends}("");
1213         }
1214         
1215         uint256 _completeFees = sellMarketingFees + buyMarketingFees;
1216 
1217         uint256 feePortions;
1218         if (_completeFees > 0) {
1219             feePortions = address(this).balance.div(_completeFees);
1220         }
1221         uint256 marketingPayout = buyMarketingFees.add(sellMarketingFees).mul(feePortions);
1222 
1223         if (marketingPayout > 0) {
1224             (successOp1, ) = address(marketingWallet).call{value: marketingPayout}("");
1225         }
1226 
1227         emit SendDividends(dividends, marketingPayout, success && successOp1);
1228     }
1229 
1230     function airdropToWallets(
1231         address[] memory airdropWallets,
1232         uint256[] memory amount
1233     ) external onlyOwner {
1234         require(airdropWallets.length == amount.length,"Arrays must be the same length");
1235         require(airdropWallets.length <= 200, "Wallets list length must be <= 200");
1236         for (uint256 i = 0; i < airdropWallets.length; i++) {
1237             address wallet = airdropWallets[i];
1238             uint256 airdropAmount = amount[i] * (10**18);
1239             super._transfer(msg.sender, wallet, airdropAmount);
1240             dividendTracker.setBalance(payable(wallet), getMultiplier(wallet));
1241         }
1242     }
1243 
1244     function airdropToWalletsAndVest(
1245         address[] memory airdropWallets,
1246         uint256[] memory amount
1247     ) external onlyOwner {
1248         require(airdropWallets.length == amount.length, "Arrays must be the same length");
1249         require(airdropWallets.length <= 200, "Wallets list length must be <= 200");
1250         for (uint256 i = 0; i < airdropWallets.length; i++) {
1251             address wallet = airdropWallets[i];
1252             uint256 airdropAmount = amount[i] * (10**18);
1253             super._transfer(msg.sender, wallet, airdropAmount);
1254             dividendTracker.setBalance(payable(wallet), getMultiplier(wallet));
1255             tokensVesting[wallet] = airdropAmount;
1256             _isVesting[wallet] = true;
1257             _vestingTimestamp[wallet] = block.timestamp;
1258         }
1259     }
1260 }
1261 
1262 contract VenomDividendTracker is DividendPayingToken, Ownable {
1263     using SafeMath for uint256;
1264     using SafeMathInt for int256;
1265     using IterableMapping for IterableMapping.Map;
1266 
1267     IterableMapping.Map private tokenHoldersMap;
1268     uint256 public lastProcessedIndex;
1269 
1270     mapping(address => bool) public excludedFromDividends;
1271     mapping(address => bool) public excludedFromAutoClaim;
1272     mapping(address => bool) public autoReinvest;
1273     address public defaultToken;
1274     bool public allowCustomTokens;
1275     bool public allowAutoReinvest;
1276     bool public dividendsPaused = false;
1277 
1278     string private trackerName;
1279     string private trackerTicker;
1280 
1281     IUniswapV2Router02 public uniswapV2Router;
1282 
1283     Venom public VenomContract;
1284 
1285     mapping(address => uint256) public lastClaimTimes;
1286 
1287     uint256 private minimumTokenBalanceForAutoDividends;
1288     uint256 private minimumTokenBalanceForDividends;
1289 
1290     event ExcludeFromDividends(address indexed account);
1291     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1292     event DividendReinvested(address indexed acount, uint256 value, bool indexed automatic);
1293     event Claim(address indexed account, uint256 amount, bool indexed automatic);
1294     event DividendsPaused(bool paused);
1295     event SetAllowCustomTokens(bool allow);
1296     event SetAllowAutoReinvest(bool allow);
1297 
1298     constructor(address payable mainContract, address router, address token, string memory _name,
1299                 string memory _ticker) DividendPayingToken(_name, _ticker) {
1300         
1301         trackerName = _name;
1302         trackerTicker = _ticker;
1303         defaultToken = token;
1304         VenomContract = Venom(mainContract);
1305         minimumTokenBalanceForAutoDividends = 1_000000000000000000; // 1 token
1306         minimumTokenBalanceForDividends = minimumTokenBalanceForAutoDividends;
1307 
1308         uniswapV2Router = IUniswapV2Router02(router);
1309         allowCustomTokens = true;
1310         allowAutoReinvest = false;
1311     }
1312 
1313     function decimals() public view virtual override returns (uint8) {
1314         return 18;
1315     }
1316 
1317     function name() public view virtual override returns (string memory) {
1318         return trackerName;
1319     }
1320 
1321     function symbol() public view virtual override returns (string memory) {
1322         return trackerTicker;
1323     }
1324 
1325     function _transfer(address, address, uint256) internal pure override {
1326         require(false, "No transfers allowed");
1327     }
1328 
1329     function withdrawDividend() public pure override {
1330         require(false, "withdrawDividend disabled. Use the 'claim' function on the main Venom contract.");
1331     }
1332 
1333     function isExcludedFromAutoClaim(address account) external view onlyOwner returns (bool) {
1334         return excludedFromAutoClaim[account];
1335     }
1336 
1337     function isReinvest(address account) external view onlyOwner returns (bool) {
1338         return autoReinvest[account];
1339     }
1340 
1341     function setAllowCustomTokens(bool allow) external onlyOwner {
1342         require(allowCustomTokens != allow);
1343         allowCustomTokens = allow;
1344         emit SetAllowCustomTokens(allow);
1345     }
1346 
1347     function setAllowAutoReinvest(bool allow) external onlyOwner {
1348         require(allowAutoReinvest != allow);
1349         allowAutoReinvest = allow;
1350         emit SetAllowAutoReinvest(allow);
1351     }
1352 
1353     function excludeFromDividends(address account) external onlyOwner {
1354         //require(!excludedFromDividends[account]);
1355         excludedFromDividends[account] = true;
1356 
1357         _setBalance(account, 0);
1358         tokenHoldersMap.remove(account);
1359 
1360         emit ExcludeFromDividends(account);
1361     }
1362 
1363     function includeFromDividends(address account) external onlyOwner {
1364         excludedFromDividends[account] = false;
1365     }
1366 
1367     function setAutoClaim(address account, bool value) external onlyOwner {
1368         excludedFromAutoClaim[account] = value;
1369     }
1370 
1371     function setReinvest(address account, bool value) external onlyOwner {
1372         autoReinvest[account] = value;
1373     }
1374 
1375     function setMinimumTokenBalanceForAutoDividends(uint256 value) external onlyOwner {
1376         minimumTokenBalanceForAutoDividends = value * (10**18);
1377     }
1378 
1379     function setMinimumTokenBalanceForDividends(uint256 value) external onlyOwner {
1380         minimumTokenBalanceForDividends = value * (10**18);
1381     }
1382 
1383     function setDividendsPaused(bool value) external onlyOwner {
1384         require(dividendsPaused != value);
1385         dividendsPaused = value;
1386         emit DividendsPaused(value);
1387     }
1388 
1389     function getLastProcessedIndex() external view returns (uint256) {
1390         return lastProcessedIndex;
1391     }
1392 
1393     function getNumberOfTokenHolders() external view returns (uint256) {
1394         return tokenHoldersMap.keys.length;
1395     }
1396 
1397     function getAccount(address _account) public view returns (address account, int256 index, int256 iterationsUntilProcessed,
1398                                                                uint256 withdrawableDividends, uint256 totalDividends,
1399                                                                uint256 lastClaimTime) {
1400         account = _account;
1401         index = tokenHoldersMap.getIndexOfKey(account);
1402         iterationsUntilProcessed = -1;
1403 
1404         if (index >= 0) {
1405             if (uint256(index) > lastProcessedIndex) {
1406                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1407             } 
1408             else {
1409                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length >
1410                     lastProcessedIndex
1411                     ? tokenHoldersMap.keys.length.sub(lastProcessedIndex)
1412                     : 0;
1413 
1414                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1415             }
1416         }
1417 
1418         withdrawableDividends = withdrawableDividendOf(account);
1419         totalDividends = accumulativeDividendOf(account);
1420 
1421         lastClaimTime = lastClaimTimes[account];
1422     }
1423 
1424     function getAccountAtIndex(uint256 index) public view returns (address, int256, int256, uint256,
1425                                                                    uint256, uint256) {
1426         if (index >= tokenHoldersMap.size()) {
1427             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0);
1428         }
1429 
1430         address account = tokenHoldersMap.getKeyAtIndex(index);
1431 
1432         return getAccount(account);
1433     }
1434 
1435     function setBalance(address account, uint256 newBalance) external onlyOwner
1436     {
1437         if (excludedFromDividends[account]) {
1438             return;
1439         }
1440 
1441         if (newBalance < minimumTokenBalanceForDividends) {
1442             tokenHoldersMap.remove(account);
1443             _setBalance(account, 0);
1444 
1445             return;
1446         }
1447 
1448         _setBalance(account, newBalance);
1449 
1450         if (newBalance >= minimumTokenBalanceForAutoDividends) {
1451             tokenHoldersMap.set(account, newBalance);
1452         } 
1453         else {
1454             tokenHoldersMap.remove(account);
1455         }
1456     }
1457 
1458     function process(uint256 gas) public returns (uint256, uint256, uint256)
1459     {
1460         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1461 
1462         if (numberOfTokenHolders == 0 || dividendsPaused) {
1463             return (0, 0, lastProcessedIndex);
1464         }
1465 
1466         uint256 _lastProcessedIndex = lastProcessedIndex;
1467 
1468         uint256 gasUsed = 0;
1469 
1470         uint256 gasLeft = gasleft();
1471 
1472         uint256 iterations = 0;
1473         uint256 claims = 0;
1474 
1475         while (gasUsed < gas && iterations < numberOfTokenHolders) {
1476             _lastProcessedIndex++;
1477 
1478             if (_lastProcessedIndex >= numberOfTokenHolders) {
1479                 _lastProcessedIndex = 0;
1480             }
1481 
1482             address account = tokenHoldersMap.keys[_lastProcessedIndex];
1483 
1484             if (!excludedFromAutoClaim[account]) {
1485                 if (processAccount(payable(account), true)) {
1486                     claims++;
1487                 }
1488             }
1489 
1490             iterations++;
1491 
1492             uint256 newGasLeft = gasleft();
1493 
1494             if (gasLeft > newGasLeft) {
1495                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1496             }
1497 
1498             gasLeft = newGasLeft;
1499         }
1500 
1501         lastProcessedIndex = _lastProcessedIndex;
1502 
1503         return (iterations, claims, lastProcessedIndex);
1504     }
1505 
1506     function processAccount(address payable account, bool automatic) public onlyOwner
1507         returns (bool)
1508     {
1509         if (dividendsPaused) {
1510             return false;
1511         }
1512 
1513         bool reinvest = autoReinvest[account];
1514 
1515         if (automatic && reinvest && !allowAutoReinvest) {
1516             return false;
1517         }
1518 
1519         uint256 amount = reinvest
1520             ? _reinvestDividendOfUser(account)
1521             : _withdrawDividendOfUser(account);
1522 
1523         if (amount > 0) {
1524             lastClaimTimes[account] = block.timestamp;
1525             if (reinvest) {
1526                 emit DividendReinvested(account, amount, automatic);
1527             } 
1528             else {
1529                 emit Claim(account, amount, automatic);
1530             }
1531             return true;
1532         }
1533 
1534         return false;
1535     }
1536 
1537     function updateUniswapV2Router(address newAddress) public onlyOwner {
1538         uniswapV2Router = IUniswapV2Router02(newAddress);
1539     }
1540 
1541     function updatePayoutToken(address token) public onlyOwner {
1542         defaultToken = token;
1543     }
1544 
1545     function getPayoutToken() public view returns (address) {
1546         return defaultToken;
1547     }
1548 
1549     function _reinvestDividendOfUser(address account) private returns (uint256) {
1550         uint256 _withdrawableDividend = withdrawableDividendOf(account);
1551         if (_withdrawableDividend > 0) {
1552             bool success;
1553 
1554             withdrawnDividends[account] = withdrawnDividends[account].add(_withdrawableDividend);
1555 
1556             address[] memory path = new address[](2);
1557             path[0] = uniswapV2Router.WETH();
1558             path[1] = address(VenomContract);
1559 
1560             uint256 prevBalance = VenomContract.balanceOf(address(this));
1561 
1562             // make the swap
1563             try
1564                 uniswapV2Router
1565                     .swapExactETHForTokensSupportingFeeOnTransferTokens{value: _withdrawableDividend}
1566                     (0, path, address(this), block.timestamp)
1567             {
1568                 uint256 received = VenomContract.balanceOf(address(this)).sub(prevBalance);
1569                 if (received > 0) {
1570                     success = true;
1571                     VenomContract.transfer(account, received);
1572                 } 
1573                 else {
1574                     success = false;
1575                 }
1576             } catch {
1577                 success = false;
1578             }
1579 
1580             if (!success) {
1581                 withdrawnDividends[account] = withdrawnDividends[account].sub(_withdrawableDividend);
1582                 return 0;
1583             }
1584 
1585             return _withdrawableDividend;
1586         }
1587 
1588         return 0;
1589     }
1590 
1591     function _withdrawDividendOfUser(address payable user) internal override returns (uint256)
1592     {
1593         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1594         if (_withdrawableDividend > 0) {
1595             withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1596 
1597             address tokenAddress = defaultToken;
1598             bool success;
1599 
1600             if (tokenAddress == address(0)) {
1601                 (success, ) = user.call{value: _withdrawableDividend, gas: 3000}("");
1602             } 
1603             else {
1604                 address[] memory path = new address[](2);
1605                 path[0] = uniswapV2Router.WETH();
1606                 path[1] = tokenAddress;
1607                 try
1608                     uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1609                     value: _withdrawableDividend}(0, path, user, block.timestamp)
1610                 {
1611                     success = true;
1612                 } catch {
1613                     success = false;
1614                 }
1615             }
1616 
1617             if (!success) {
1618                 withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1619                 return 0;
1620             } 
1621             else {
1622                 emit DividendWithdrawn(user, _withdrawableDividend);
1623             }
1624             return _withdrawableDividend;
1625         }
1626         return 0;
1627     }
1628 }
1629 
1630 library IterableMapping {
1631     // Iterable mapping from address to uint;
1632     struct Map {
1633         address[] keys;
1634         mapping(address => uint256) values;
1635         mapping(address => uint256) indexOf;
1636         mapping(address => bool) inserted;
1637     }
1638 
1639     function get(Map storage map, address key) internal view returns (uint256) {
1640         return map.values[key];
1641     }
1642 
1643     function getIndexOfKey(Map storage map, address key) internal view returns (int256) {
1644         if (!map.inserted[key]) {
1645             return -1;
1646         }
1647         return int256(map.indexOf[key]);
1648     }
1649 
1650     function getKeyAtIndex(Map storage map, uint256 index) internal view returns (address) {
1651         return map.keys[index];
1652     }
1653 
1654     function size(Map storage map) internal view returns (uint256) {
1655         return map.keys.length;
1656     }
1657 
1658     function set(Map storage map, address key, uint256 val) internal {
1659         if (map.inserted[key]) {
1660             map.values[key] = val;
1661         } else {
1662             map.inserted[key] = true;
1663             map.values[key] = val;
1664             map.indexOf[key] = map.keys.length;
1665             map.keys.push(key);
1666         }
1667     }
1668 
1669     function remove(Map storage map, address key) internal {
1670         if (!map.inserted[key]) {
1671             return;
1672         }
1673 
1674         delete map.inserted[key];
1675         delete map.values[key];
1676 
1677         uint256 index = map.indexOf[key];
1678         uint256 lastIndex = map.keys.length - 1;
1679         address lastKey = map.keys[lastIndex];
1680 
1681         map.indexOf[lastKey] = index;
1682         delete map.indexOf[key];
1683 
1684         map.keys[index] = lastKey;
1685         map.keys.pop();
1686     }
1687 }