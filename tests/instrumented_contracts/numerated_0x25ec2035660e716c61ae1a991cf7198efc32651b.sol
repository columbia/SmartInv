1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.7;
3 contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 }
8 library SafeMath {
9     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
10         unchecked {
11             uint256 c = a + b;
12             if (c < a) return (false, 0);
13             return (true, c);
14         }
15     }
16     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
17         unchecked {
18             if (b > a) return (false, 0);
19             return (true, a - b);
20         }
21     }
22     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {
24             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
25             // benefit is lost if 'b' is also tested.
26             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
27             if (a == 0) return (true, 0);
28             uint256 c = a * b;
29             if (c / a != b) return (false, 0);
30             return (true, c);
31         }
32     }
33     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {
35             if (b == 0) return (false, 0);
36             return (true, a / b);
37         }
38     }
39     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b == 0) return (false, 0);
42             return (true, a % b);
43         }
44     }
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         return a + b;
47     }
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return a - b;
50     }
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a * b;
53     }
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a / b;
56     }
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         return a % b;
59     }
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         unchecked {
62             require(b <= a, errorMessage);
63             return a - b;
64         }
65     }
66     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         unchecked {
68             require(b > 0, errorMessage);
69             return a / b;
70         }
71     }
72     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         unchecked {
74             require(b > 0, errorMessage);
75             return a % b;
76         }
77     }
78 }
79 contract ERC20Ownable is Context {
80     address private _owner;
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82     constructor() {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87     function owner() public view virtual returns (address) {
88         return _owner;
89     }
90     modifier onlyOwner() {
91         require(owner() == _msgSender(), "ERC20Ownable: caller is not the owner");
92         _;
93     }
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "ERC20Ownable: new owner is the zero address");
100         _owner = newOwner;
101     }
102 }
103 interface IERC20 {
104     event Approval(address indexed owner, address indexed spender, uint value);
105     event Transfer(address indexed from, address indexed to, uint value);
106     function name() external view returns (string memory);
107     function symbol() external view returns (string memory);
108     function decimals() external view returns (uint8);
109     function totalSupply() external view returns (uint);
110     function balanceOf(address owner) external view returns (uint);
111     function allowance(address owner, address spender) external view returns (uint);
112     function approve(address spender, uint value) external returns (bool);
113     function transfer(address to, uint value) external returns (bool);
114     function transferFrom(address from, address to, uint value) external returns (bool);
115 }
116 interface IUniswapV2Router01 {
117     function factory() external pure returns (address);
118     function WETH() external pure returns (address);
119     function addLiquidity(
120         address tokenA,
121         address tokenB,
122         uint amountADesired,
123         uint amountBDesired,
124         uint amountAMin,
125         uint amountBMin,
126         address to,
127         uint deadline
128     ) external returns (uint amountA, uint amountB, uint liquidity);
129     function addLiquidityETH(
130         address token,
131         uint amountTokenDesired,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline
136     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
137     function removeLiquidity(
138         address tokenA,
139         address tokenB,
140         uint liquidity,
141         uint amountAMin,
142         uint amountBMin,
143         address to,
144         uint deadline
145     ) external returns (uint amountA, uint amountB);
146     function removeLiquidityETH(
147         address token,
148         uint liquidity,
149         uint amountTokenMin,
150         uint amountETHMin,
151         address to,
152         uint deadline
153     ) external returns (uint amountToken, uint amountETH);
154     function removeLiquidityWithPermit(
155         address tokenA,
156         address tokenB,
157         uint liquidity,
158         uint amountAMin,
159         uint amountBMin,
160         address to,
161         uint deadline,
162         bool approveMax, uint8 v, bytes32 r, bytes32 s
163     ) external returns (uint amountA, uint amountB);
164     function removeLiquidityETHWithPermit(
165         address token,
166         uint liquidity,
167         uint amountTokenMin,
168         uint amountETHMin,
169         address to,
170         uint deadline,
171         bool approveMax, uint8 v, bytes32 r, bytes32 s
172     ) external returns (uint amountToken, uint amountETH);
173     function swapExactTokensForTokens(
174         uint amountIn,
175         uint amountOutMin,
176         address[] calldata path,
177         address to,
178         uint deadline
179     ) external returns (uint[] memory amounts);
180     function swapTokensForExactTokens(
181         uint amountOut,
182         uint amountInMax,
183         address[] calldata path,
184         address to,
185         uint deadline
186     ) external returns (uint[] memory amounts);
187     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
188         external
189         payable
190         returns (uint[] memory amounts);
191     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
192         external
193         returns (uint[] memory amounts);
194     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
195         external
196         returns (uint[] memory amounts);
197     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
198         external
199         payable
200         returns (uint[] memory amounts);
201     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
202     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
203     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
204     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
205     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
206 }
207 interface IUniswapV2Router02 {
208     function factory() external pure returns (address);
209     function WETH() external pure returns (address);
210     function swapExactTokensForETHSupportingFeeOnTransferTokens(
211         uint amountIn,
212         uint amountOutMin,
213         address[] calldata path,
214         address to,
215         uint deadline
216     ) external;
217     function addLiquidity(
218         address tokenA,
219         address tokenB,
220         uint amountADesired,
221         uint amountBDesired,
222         uint amountAMin,
223         uint amountBMin,
224         address to,
225         uint deadline
226     ) external returns (uint amountA, uint amountB, uint liquidity);
227     function addLiquidityETH(
228         address token,
229         uint amountTokenDesired,
230         uint amountTokenMin,
231         uint amountETHMin,
232         address to,
233         uint deadline
234     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
235     function removeLiquidity(
236         address tokenA,
237         address tokenB,
238         uint liquidity,
239         uint amountAMin,
240         uint amountBMin,
241         address to,
242         uint deadline
243     ) external returns (uint amountA, uint amountB);
244     function removeLiquidityETH(
245         address token,
246         uint liquidity,
247         uint amountTokenMin,
248         uint amountETHMin,
249         address to,
250         uint deadline
251     ) external returns (uint amountToken, uint amountETH);
252     function removeLiquidityWithPermit(
253         address tokenA,
254         address tokenB,
255         uint liquidity,
256         uint amountAMin,
257         uint amountBMin,
258         address to,
259         uint deadline,
260         bool approveMax, uint8 v, bytes32 r, bytes32 s
261     ) external returns (uint amountA, uint amountB);
262     function removeLiquidityETHWithPermit(
263         address token,
264         uint liquidity,
265         uint amountTokenMin,
266         uint amountETHMin,
267         address to,
268         uint deadline,
269         bool approveMax, uint8 v, bytes32 r, bytes32 s
270     ) external returns (uint amountToken, uint amountETH);
271     function swapExactTokensForTokens(
272         uint amountIn,
273         uint amountOutMin,
274         address[] calldata path,
275         address to,
276         uint deadline
277     ) external returns (uint[] memory amounts);
278     function swapTokensForExactTokens(
279         uint amountOut,
280         uint amountInMax,
281         address[] calldata path,
282         address to,
283         uint deadline
284     ) external returns (uint[] memory amounts);
285     function swapExactETHForTokensSupportingFeeOnTransferTokens(
286         uint amountOutMin,
287         address[] calldata path,
288         address to,
289         uint deadline
290     ) external payable;
291     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
292         external
293         payable
294         returns (uint[] memory amounts);
295     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
296         external
297         returns (uint[] memory amounts);
298     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
299         external
300         returns (uint[] memory amounts);
301     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
302         external
303         payable
304         returns (uint[] memory amounts);
305     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
306     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
307     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
308     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
309     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
310 }
311 interface IUniswapV2Factory {
312     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
313     function feeTo() external view returns (address);
314     function feeToSetter() external view returns (address);
315     function getPair(address tokenA, address tokenB) external view returns (address pair);
316     function allPairs(uint) external view returns (address pair);
317     function allPairsLength() external view returns (uint);
318     function createPair(address tokenA, address tokenB) external returns (address pair);
319     function setFeeTo(address) external;
320     function setFeeToSetter(address) external;
321 }
322 interface IUniswapV2Pair {
323     event Approval(address indexed owner, address indexed spender, uint256 value);
324     event Transfer(address indexed from, address indexed to, uint256 value);
325     function name() external pure returns (string memory);
326     function symbol() external pure returns (string memory);
327     function decimals() external pure returns (uint8);
328     function totalSupply() external view returns (uint256);
329     function balanceOf(address owner) external view returns (uint256);
330     function allowance(address owner, address spender) external view returns (uint256);
331     function approve(address spender, uint256 value) external returns (bool);
332     function transfer(address to, uint256 value) external returns (bool);
333     function transferFrom(address from, address to, uint256 value) external returns (bool);
334     function DOMAIN_SEPARATOR() external view returns (bytes32);
335     function PERMIT_TYPEHASH() external pure returns (bytes32);
336     function nonces(address owner) external view returns (uint256);
337     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
338     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
339     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
340     event Sync(uint112 reserve0, uint112 reserve1);
341     function MINIMUM_LIQUIDITY() external pure returns (uint256);
342     function factory() external view returns (address);
343     function token0() external view returns (address);
344     function token1() external view returns (address);
345     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
346     function price0CumulativeLast() external view returns (uint256);
347     function price1CumulativeLast() external view returns (uint256);
348     function kLast() external view returns (uint256);
349     function burn(address to) external returns (uint256 amount0, uint256 amount1);
350     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
351     function skim(address to) external;
352     function sync() external;
353     function initialize(address, address) external;
354 }
355 
356 contract APETAMA is Context, IERC20, ERC20Ownable {
357     using SafeMath for uint256;
358 
359     string private constant _name = "APETAMA";
360     string private constant _symbol = "APETAMA";
361     uint8 private constant _decimal = 18;
362 
363 	mapping(address => uint256) private _rOwned;
364     mapping(address => uint256) private _tOwned;
365     mapping(address => mapping(address => uint256)) private _allowances;
366     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily
367     mapping(address => bool) private _isExcluded;
368 	mapping(address => bool) private _isExcludedFromFee;
369     mapping(address => bool) private _isMaxWalletExclude;
370     mapping (address => bool) private _isExcludedMaxTxnAmount;
371     mapping (address => bool) public isBot;
372 	mapping(address => bool) public isSniper;
373 	address payable private MarketingWallet;
374     address payable private DevWallet;
375     address dead = address(0xdead);
376     IUniswapV2Router02 public uniV2Router;
377     address public uniV2Pair;
378     address[] private _excluded;
379 	uint256 private constant MAX = ~uint256(0);
380     uint256 private constant _tTotal = 1e14 * 10**18;
381     uint256 private _rTotal = (MAX - (MAX % _tTotal));
382     uint256 private _tFeeTotal;
383     uint256 private _maxWallet;
384 	uint256 private _minTaxSwap;
385 	uint256 private tokensForMarketing;
386 	uint256 private tokensForLiquidity;
387 	uint256 private totalBurnedTokens;
388 	uint256 private constant BUY = 1;
389     uint256 private constant SELL = 2;
390     uint256 private constant TRANSFER = 3;
391     uint256 private buyOrSellSwitch;
392     uint256 private _marketingTax = 4;
393     uint256 private _previousMarketingTax = _marketingTax;
394     uint256 private _reflectionsTax = 2;
395     uint256 private _previousReflectionsTax = _reflectionsTax;
396     uint256 private _liquidityTax = 2;
397     uint256 private _previousLiquidityTax = _liquidityTax;
398     uint256 private _divForLiq = _marketingTax + _liquidityTax;
399     uint256 public taxBuyMarketing = 4;
400     uint256 public taxBuyReflections = 2;
401     uint256 public taxBuyLiquidity = 2;
402     uint256 public taxSellMarketing = 4;
403     uint256 public taxSellReflections = 2;
404     uint256 public taxSellLiquidity = 2;
405     uint256 public activeTradingBlock = 0;
406     uint256 public earlyBuyPenaltyEnd;
407     uint256 public maxTxnAmount;
408     bool public antiSnipe = false;
409     bool private _initiateTrades = true;
410     bool public maxWalletOn = false;
411     bool inSwapAndLiquify;
412     bool public swapAndLiquifyEnabled = false;
413     event SwapAndLiquifyEnabledUpdated(bool enabled);
414     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
415     event SwapETHForTokens(uint256 amountIn, address[] path);
416     event SwapTokensForETH(uint256 amountIn, address[] path);
417     event ExcludeFromFee(address excludedAddress);
418     event IncludeInFee(address includedAddress);
419     event OwnerForcedSwapBack(uint256 timestamp);
420     modifier lockTheSwap() {
421         inSwapAndLiquify = true;
422         _;
423         inSwapAndLiquify = false;
424         
425     }
426     constructor() payable {
427         _rOwned[_msgSender()] = _rTotal;
428         maxTxnAmount = _tTotal / 100; 
429         _maxWallet = _tTotal * 2 / 100;
430         _minTaxSwap = _tTotal * 5 / 10000;
431         MarketingWallet = payable(0x1F3f2f83bd12c2b35F2721D07aABB9a4d4bd5370);
432         DevWallet = payable(0xCC2E0bC87845D42cd88ce82F6a34E86f9563c140);
433         _isExcluded[dead] = true;
434         _isExcludedFromFee[_msgSender()] = true;
435         _isExcludedFromFee[dead] = true;
436         _isExcludedFromFee[address(this)] = true;
437         _isExcludedFromFee[MarketingWallet] = true;
438         _isExcludedFromFee[DevWallet] = true;
439         _isMaxWalletExclude[address(this)] = true;
440         _isMaxWalletExclude[_msgSender()] = true;
441         _isMaxWalletExclude[dead] = true;
442         _isMaxWalletExclude[MarketingWallet] = true;
443         _isMaxWalletExclude[DevWallet] = true;
444         _isExcludedMaxTxnAmount[_msgSender()] = true;
445         _isExcludedMaxTxnAmount[address(this)] = true;
446         _isExcludedMaxTxnAmount[dead] = true;
447         _isExcludedMaxTxnAmount[MarketingWallet] = true;
448         _isExcludedMaxTxnAmount[DevWallet] = true;
449         BotAddToList(0x41B0320bEb1563A048e2431c8C1cC155A0DFA967);
450         BotAddToList(0x91B305F0890Fd0534B66D8d479da6529C35A3eeC);
451         BotAddToList(0x7F5622afb5CEfbA39f96CA3b2814eCF0E383AAA4);
452         BotAddToList(0xfcf6a3d7eb8c62a5256a020e48f153c6D5Dd6909);
453         BotAddToList(0x74BC89a9e831ab5f33b90607Dd9eB5E01452A064);
454         BotAddToList(0x1F53592C3aA6b827C64C4a3174523182c52Ece84);
455         BotAddToList(0x460545C01c4246194C2e511F166D84bbC8a07608);
456         BotAddToList(0x2E5d67a1d15ccCF65152B3A8ec5315E73461fBcd);
457         BotAddToList(0xb5aF12B837aAf602298B3385640F61a0fF0F4E0d);
458         BotAddToList(0xEd3e444A30Bd440FBab5933dCCC652959DfCB5Ba);
459         BotAddToList(0xEC366bbA6266ac8960198075B14FC1D38ea7de88);
460         BotAddToList(0x10Bf6836600D7cFE1c06b145A8Ac774F8Ba91FDD);
461         BotAddToList(0x44ae54e28d082C98D53eF5593CE54bB231e565E7);
462         BotAddToList(0xa3e820006F8553d5AC9F64A2d2B581501eE24FcF);
463 		BotAddToList(0x2228476AC5242e38d5864068B8c6aB61d6bA2222);
464 		BotAddToList(0xcC7e3c4a8208172CA4c4aB8E1b8B4AE775Ebd5a8);
465 		BotAddToList(0x5b3EE79BbBDb5B032eEAA65C689C119748a7192A);
466 		BotAddToList(0x4ddA45d3E9BF453dc95fcD7c783Fe6ff9192d1BA);
467 
468         emit Transfer(address(0), _msgSender(), _tTotal);
469     }
470     receive() external payable {}
471     function name() public pure override returns (string memory) {
472         return _name;
473     }
474     function symbol() public pure override returns (string memory) {
475         return _symbol;
476     }
477     function decimals() public pure override returns (uint8) {
478         return _decimal;
479     }
480     function totalSupply() public pure override returns (uint256) {
481         return _tTotal;
482     }
483     function balanceOf(address account) public view override returns (uint256) {
484         if (_isExcluded[account]) return _tOwned[account];
485         return tokenFromReflection(_rOwned[account]);
486     }
487     function transfer(address recipient, uint256 amount) public override returns (bool) {
488         _transfer(_msgSender(), recipient, amount);
489         return true;
490     }
491     function allowance(address owner, address spender) public view override returns (uint256) {
492         return _allowances[owner][spender];
493     }
494     function approve(address spender, uint256 amount) public override returns (bool) {
495         _approve(_msgSender(), spender, amount);
496         return true;
497     }
498     function transferFrom(address sender,address recipient,uint256 amount) public override returns (bool) {
499         _transfer(sender, recipient, amount);
500         _approve(sender,_msgSender(),
501         _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
502         );
503         return true;
504     }
505     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
506         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
507         return true;
508     }
509     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
510         _approve(
511             _msgSender(),
512             spender,
513             _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero")
514         );
515         return true;
516     }
517     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
518         require(tAmount <= _tTotal, "Amt must be less than supply");
519         if (!deductTransferFee) {
520             (uint256 rAmount, , , , , ) = _getValues(tAmount);
521             return rAmount;
522         } else {
523             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
524             return rTransferAmount;
525         }
526     }
527     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
528         require(rAmount <= _rTotal, "Amt must be less than tot refl");
529         uint256 currentRate = _getRate();
530         return rAmount.div(currentRate);
531     }
532     function _reflectFee(uint256 rFee, uint256 tFee) private {
533         _rTotal = _rTotal.sub(rFee);
534         _tFeeTotal = _tFeeTotal.add(tFee);
535     }
536     function _getValues(uint256 tAmount) private view returns (uint256,uint256,uint256,uint256,uint256,uint256) {
537         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
538         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
539         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
540     }
541     function _getTValues(uint256 tAmount)private view returns (uint256,uint256,uint256) {
542         uint256 tFee = calculateTaxFee(tAmount);
543         uint256 tLiquidity = calculateLiquidityFee(tAmount);
544         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
545         return (tTransferAmount, tFee, tLiquidity);
546     }
547     function _getRValues(uint256 tAmount,uint256 tFee,uint256 tLiquidity,uint256 currentRate) private pure returns (uint256,uint256,uint256) {
548         uint256 rAmount = tAmount.mul(currentRate);
549         uint256 rFee = tFee.mul(currentRate);
550         uint256 rLiquidity = tLiquidity.mul(currentRate);
551         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
552         return (rAmount, rTransferAmount, rFee);
553     }
554     function _getRate() private view returns (uint256) {
555         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
556         return rSupply.div(tSupply);
557     }
558     function _getCurrentSupply() private view returns (uint256, uint256) {
559         uint256 rSupply = _rTotal;
560         uint256 tSupply = _tTotal;
561         for (uint256 i = 0; i < _excluded.length; i++) {
562             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
563             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
564             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
565         }
566         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
567         return (rSupply, tSupply);
568     }
569     function _takeLiquidity(uint256 tLiquidity) private {
570         if(buyOrSellSwitch == BUY){
571             tokensForMarketing += tLiquidity * taxBuyMarketing / _divForLiq;
572             tokensForLiquidity += tLiquidity * taxBuyLiquidity / _divForLiq;
573         } else if(buyOrSellSwitch == SELL){
574             tokensForMarketing += tLiquidity * taxSellMarketing / _divForLiq;
575             tokensForLiquidity += tLiquidity * taxSellLiquidity / _divForLiq;
576         }
577         uint256 currentRate = _getRate();
578         uint256 rLiquidity = tLiquidity.mul(currentRate);
579         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
580         if (_isExcluded[address(this)])
581             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
582     }
583     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
584         return _amount.mul(_reflectionsTax).div(10**2);
585     }
586     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
587         return _amount.mul(_liquidityTax + _marketingTax).div(10**2);
588     }
589     function _approve(address owner,address spender,uint256 amount) private {
590         require(owner != address(0), "ERC20: approve from zero address");
591         require(spender != address(0), "ERC20: approve to zero address");
592         _allowances[owner][spender] = amount;
593         emit Approval(owner, spender, amount);
594     }
595     function _transfer(address from, address to, uint256 amount) private {
596         require(from != address(0), "ERC20: transfer from the zero address");
597         require(to != address(0), "ERC20: transfer to the zero address");
598         require(amount > 0, "Transfer amount must be greater than zero");
599         require(!isBot[from]);
600         if (maxWalletOn == true && ! _isMaxWalletExclude[to]) {
601             require(balanceOf(to) + amount <= _maxWallet, "Max amount of tokens for wallet reached");
602         }
603         if(_initiateTrades == true) {
604             IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
605             uniV2Router = _uniV2Router;
606             uniV2Pair = IUniswapV2Factory(_uniV2Router.factory()).getPair(address(this), _uniV2Router.WETH());
607             activeTradingBlock = block.number;
608             earlyBuyPenaltyEnd = block.timestamp + 127 hours;
609             _isMaxWalletExclude[address(uniV2Pair)] = true;
610             _isMaxWalletExclude[address(uniV2Router)] = true;
611             _isExcludedMaxTxnAmount[address(uniV2Router)] = true;
612             _isExcludedMaxTxnAmount[address(uniV2Pair)] = true;
613             antiSnipe = true;
614             maxWalletOn = true;
615             swapAndLiquifyEnabled = true;
616             _initiateTrades = false;
617         }
618         if(antiSnipe == true) {
619             if (from != owner() && to != owner() && to != address(0) && to != dead && !inSwapAndLiquify) {
620                 if(from != owner() && to != uniV2Pair) {
621                     for (uint x = 0; x < 3; x++) {
622                     if(block.number == activeTradingBlock + x) {
623                         isSniper[to] = true;
624                         }
625                     }
626                 }
627             }
628         }
629         uint256 totalTokensToSwap = tokensForLiquidity.add(tokensForMarketing);
630         uint256 contractTokenBalance = balanceOf(address(this));
631         bool overMinimumTokenBalance = contractTokenBalance >= _minTaxSwap;
632         if (!inSwapAndLiquify && swapAndLiquifyEnabled && balanceOf(uniV2Pair) > 0 && totalTokensToSwap > 0 && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && to == uniV2Pair && overMinimumTokenBalance) {
633             swapTokens();
634             }
635         bool takeFee = true;
636         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
637             takeFee = false;
638             buyOrSellSwitch = TRANSFER;
639         } else {
640             if (from == uniV2Pair) {
641                 removeAllFee();
642                 _marketingTax = taxBuyMarketing;
643                 _reflectionsTax = taxBuyReflections;
644                 _liquidityTax = taxBuyLiquidity;
645                 buyOrSellSwitch = BUY;
646             } 
647             else if (to == uniV2Pair) {
648                 removeAllFee();
649                 _marketingTax = taxSellMarketing;
650                 _reflectionsTax = taxSellReflections;
651                 _liquidityTax = taxSellLiquidity;
652                 buyOrSellSwitch = SELL;
653                 if(isSniper[from] && earlyBuyPenaltyEnd >= block.timestamp){
654                     _marketingTax = _marketingTax * 10;
655                     _liquidityTax = _liquidityTax * 10;
656                 }
657             } else {
658                 require(!isSniper[from]);
659                 removeAllFee();
660                 buyOrSellSwitch = TRANSFER;
661             }
662         }
663         _tokenTransfer(from, to, amount, takeFee);
664     }
665     function swapTokens() private lockTheSwap {
666         uint256 contractBalance = balanceOf(address(this));
667         uint256 totalTokensToSwap = tokensForMarketing + tokensForLiquidity;
668         uint256 swapLiquidityTokens = tokensForLiquidity.div(2);
669         uint256 amountToSwapForETH = contractBalance.sub(swapLiquidityTokens);
670         uint256 initialETHBalance = address(this).balance;
671         swapTokensForETH(amountToSwapForETH); 
672         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
673         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
674         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing);
675         tokensForMarketing = 0;
676         tokensForLiquidity = 0;
677         (bool success,) = address(MarketingWallet).call{value: ethForMarketing}("");
678         addLiquidity(swapLiquidityTokens, ethForLiquidity);
679         if(address(this).balance > 5 * 10**17){
680             (success,) = address(DevWallet).call{value: address(this).balance}("");
681         }
682     }
683     function swapTokensForETH(uint256 tokenAmount) private {
684         address[] memory path = new address[](2);
685         path[0] = address(this);
686         path[1] = uniV2Router.WETH();
687         _approve(address(this), address(uniV2Router), tokenAmount);
688         uniV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
689             tokenAmount,
690             0, // accept any amount of ETH
691             path,
692             address(this),
693             block.timestamp
694         );
695     }
696     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
697         _approve(address(this), address(uniV2Router), tokenAmount);
698         uniV2Router.addLiquidityETH{value: ethAmount}(
699             address(this),
700             tokenAmount,
701             0, // slippage is unavoidable
702             0, // slippage is unavoidable
703             dead,
704             block.timestamp
705         );
706     }
707     function removeAllFee() private {
708         if (_reflectionsTax == 0 && _liquidityTax == 0 && _marketingTax == 0) return;
709         _previousMarketingTax = _marketingTax;
710         _previousLiquidityTax = _liquidityTax;
711         _previousReflectionsTax = _reflectionsTax;
712 
713         _marketingTax = 0;
714         _reflectionsTax = 0;
715         _liquidityTax = 0;
716     }
717     function restoreAllFee() private {
718         _marketingTax = _previousMarketingTax;
719         _reflectionsTax = _previousReflectionsTax;
720         _liquidityTax = _previousLiquidityTax;
721     }
722     function _tokenTransfer(address sender,address recipient,uint256 amount,bool takeFee) private {
723         if (!takeFee) removeAllFee();
724         if (_isExcluded[sender] && !_isExcluded[recipient]) {
725             _transferFromExcluded(sender, recipient, amount);
726         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
727             _transferToExcluded(sender, recipient, amount);
728         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
729             _transferStandard(sender, recipient, amount);
730         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
731             _transferBothExcluded(sender, recipient, amount);
732         } else {
733             _transferStandard(sender, recipient, amount);
734         }
735         if (!takeFee) restoreAllFee();
736     }
737     function _transferStandard(address sender,address recipient,uint256 tAmount) private {
738         (
739             uint256 rAmount,
740             uint256 rTransferAmount,
741             uint256 rFee,
742             uint256 tTransferAmount,
743             uint256 tFee,
744             uint256 tLiquidity
745         ) = _getValues(tAmount);
746         _rOwned[sender] = _rOwned[sender].sub(rAmount);
747         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
748         _takeLiquidity(tLiquidity);
749         _reflectFee(rFee, tFee);
750         emit Transfer(sender, recipient, tTransferAmount);
751     }
752     function _transferToExcluded(address sender,address recipient,uint256 tAmount) private {
753         (
754             uint256 rAmount,
755             uint256 rTransferAmount,
756             uint256 rFee,
757             uint256 tTransferAmount,
758             uint256 tFee,
759             uint256 tLiquidity
760         ) = _getValues(tAmount);
761         _rOwned[sender] = _rOwned[sender].sub(rAmount);
762         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
763         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
764         _takeLiquidity(tLiquidity);
765         _reflectFee(rFee, tFee);
766         emit Transfer(sender, recipient, tTransferAmount);
767     }
768     function _transferFromExcluded(address sender,address recipient,uint256 tAmount) private {
769         (
770             uint256 rAmount,
771             uint256 rTransferAmount,
772             uint256 rFee,
773             uint256 tTransferAmount,
774             uint256 tFee,
775             uint256 tLiquidity
776         ) = _getValues(tAmount);
777         _tOwned[sender] = _tOwned[sender].sub(tAmount);
778         _rOwned[sender] = _rOwned[sender].sub(rAmount);
779         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
780         _takeLiquidity(tLiquidity);
781         _reflectFee(rFee, tFee);
782         emit Transfer(sender, recipient, tTransferAmount);
783     }
784     function _transferBothExcluded(address sender,address recipient,uint256 tAmount) private {
785         (
786             uint256 rAmount,
787             uint256 rTransferAmount,
788             uint256 rFee,
789             uint256 tTransferAmount,
790             uint256 tFee,
791             uint256 tLiquidity
792         ) = _getValues(tAmount);
793         _tOwned[sender] = _tOwned[sender].sub(tAmount);
794         _rOwned[sender] = _rOwned[sender].sub(rAmount);
795         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
796         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
797         _takeLiquidity(tLiquidity);
798         _reflectFee(rFee, tFee);
799         emit Transfer(sender, recipient, tTransferAmount);
800     }
801     function _tokenTransferNoFee(address sender,address recipient,uint256 amount) private {
802         _rOwned[sender] = _rOwned[sender].sub(amount);
803         _rOwned[recipient] = _rOwned[recipient].add(amount);
804 
805         if (_isExcluded[sender]) {
806             _tOwned[sender] = _tOwned[sender].sub(amount);
807         }
808         if (_isExcluded[recipient]) {
809             _tOwned[recipient] = _tOwned[recipient].add(amount);
810         }
811         emit Transfer(sender, recipient, amount);
812     }
813     
814     function excludeFromFee(address account) external onlyOwner {
815         _isExcludedFromFee[account] = true;
816     }
817     function includeInFee(address account) external onlyOwner {
818         _isExcludedFromFee[account] = false;
819     }
820     function isExcludedFromFee(address account) public view returns (bool) {
821         return _isExcludedFromFee[account];
822     }
823     function excludeFromMaxWallet(address account) external onlyOwner {
824         _isMaxWalletExclude[account] = true;
825     }
826     function includeInMaxWallet(address account) external onlyOwner {
827         _isMaxWalletExclude[account] = false;
828     }
829     function isExcludedFromMaxWallet(address account) public view returns (bool) {
830         return _isMaxWalletExclude[account];
831     }
832     function excludeFromMaxTransaction(address account) external onlyOwner {
833         _isExcludedMaxTxnAmount[account] = true;
834     }
835     function includeInMaxTransaction(address account) external onlyOwner {
836         _isExcludedMaxTxnAmount[account] = false;
837     }
838     function isExcludedFromMaxTransaction(address account) public view returns (bool) {
839         return _isExcludedMaxTxnAmount[account];
840     }
841     function BotAddToList(address _user) public onlyOwner {
842         require(!isBot[_user]);
843         isBot[_user] = true;
844     }
845 	function BotRemoveFromList(address _user) public onlyOwner {
846         require(isBot[_user]);
847         isBot[_user] = false;
848     }
849 	function removeSniper(address account) external onlyOwner {
850         isSniper[account] = false;
851     }
852     function startAntiSnipe() external onlyOwner {
853         antiSnipe = true;
854     }
855     function removeAntiSnipe() external onlyOwner {
856         antiSnipe = false;
857     }
858     function INITIATE() external onlyOwner {
859 		_initiateTrades = true;
860 	}
861 	function STOPINITIATE() external onlyOwner {
862 		_initiateTrades = false;
863 	}
864     function TaxSwapEnable() external onlyOwner {
865         swapAndLiquifyEnabled = true;
866     }
867     function TaxSwapDisable() external onlyOwner {
868         swapAndLiquifyEnabled = false;
869     }
870     function enableMaxWallet() external onlyOwner {
871         maxWalletOn = true;
872     }
873     function disableMaxWallet() external onlyOwner {
874         maxWalletOn = false;
875     }
876     function setBuyTax(uint256 _buyLiquidityTax, uint256 _buyReflectionsTax, uint256 _buyMarketingTax) external onlyOwner {
877         taxBuyReflections = _buyReflectionsTax;
878         taxBuyMarketing = _buyMarketingTax;
879         taxBuyLiquidity = _buyLiquidityTax;
880     }
881     function setSellTax(uint256 _sellLiquidityTax, uint256 _sellReflectionsTax, uint256 _sellMarketingTax) external onlyOwner {
882         taxSellReflections = _sellReflectionsTax;
883         taxSellMarketing = _sellMarketingTax;
884         taxSellLiquidity = _sellLiquidityTax;
885     }
886     function setMarketingAddress(address _marketingAddress) external onlyOwner {
887         require(_marketingAddress != address(0), "address cannot be 0");
888         _isExcludedFromFee[MarketingWallet] = false;
889         MarketingWallet = payable(_marketingAddress);
890         _isExcludedFromFee[MarketingWallet] = true;
891     }
892     function forceSwapBack() external onlyOwner {
893         uint256 contractBalance = balanceOf(address(this));
894         require(contractBalance >= _tTotal * 5 / 10000, "Can only swap back if more than 0.05% of tokens stuck on contract");
895         swapTokens();
896         emit OwnerForcedSwapBack(block.timestamp);
897     }
898     function withdrawDevETH() public onlyOwner {
899         bool success;
900         (success,) = address(DevWallet).call{value: address(this).balance}("");
901     }
902     function manualBurnTokens(uint256 percent) external onlyOwner returns (bool){
903         require(percent <= 10, "May not nuke more than 10% of tokens in LP");
904         uint256 liquidityPairBalance = this.balanceOf(uniV2Pair);
905         uint256 amountToBurn = liquidityPairBalance * percent / 10**2;
906         if (amountToBurn > 0){
907             _transfer(uniV2Pair, dead, amountToBurn);
908         }
909         totalBurnedTokens = balanceOf(dead);
910         require(totalBurnedTokens <= _tTotal * 50 / 10**2, "Can not burn more then 50% of supply");
911         IUniswapV2Pair pair = IUniswapV2Pair(uniV2Pair);
912         pair.sync();
913         return true;
914     }
915 }