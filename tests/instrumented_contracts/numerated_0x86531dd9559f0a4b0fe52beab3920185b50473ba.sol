1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.7;
3 library SafeMath {
4     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
5         unchecked {
6             uint256 c = a + b;
7             if (c < a) return (false, 0);
8             return (true, c);
9         }
10     }
11     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
12         unchecked {
13             if (b > a) return (false, 0);
14             return (true, a - b);
15         }
16     }
17     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {
19             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
20             // benefit is lost if 'b' is also tested.
21             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
22             if (a == 0) return (true, 0);
23             uint256 c = a * b;
24             if (c / a != b) return (false, 0);
25             return (true, c);
26         }
27     }
28     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         unchecked {
30             if (b == 0) return (false, 0);
31             return (true, a / b);
32         }
33     }
34     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             if (b == 0) return (false, 0);
37             return (true, a % b);
38         }
39     }
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         return a + b;
42     }
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return a - b;
45     }
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         return a * b;
48     }
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return a / b;
51     }
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         return a % b;
54     }
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         unchecked {
57             require(b <= a, errorMessage);
58             return a - b;
59         }
60     }
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         unchecked {
63             require(b > 0, errorMessage);
64             return a / b;
65         }
66     }
67     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         unchecked {
69             require(b > 0, errorMessage);
70             return a % b;
71         }
72     }
73 }
74 interface IUniswapV2Router01 {
75     function factory() external pure returns (address);
76     function WETH() external pure returns (address);
77     function addLiquidity(
78         address tokenA,
79         address tokenB,
80         uint amountADesired,
81         uint amountBDesired,
82         uint amountAMin,
83         uint amountBMin,
84         address to,
85         uint deadline
86     ) external returns (uint amountA, uint amountB, uint liquidity);
87     function addLiquidityETH(
88         address token,
89         uint amountTokenDesired,
90         uint amountTokenMin,
91         uint amountETHMin,
92         address to,
93         uint deadline
94     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
95     function removeLiquidity(
96         address tokenA,
97         address tokenB,
98         uint liquidity,
99         uint amountAMin,
100         uint amountBMin,
101         address to,
102         uint deadline
103     ) external returns (uint amountA, uint amountB);
104     function removeLiquidityETH(
105         address token,
106         uint liquidity,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external returns (uint amountToken, uint amountETH);
112     function removeLiquidityWithPermit(
113         address tokenA,
114         address tokenB,
115         uint liquidity,
116         uint amountAMin,
117         uint amountBMin,
118         address to,
119         uint deadline,
120         bool approveMax, uint8 v, bytes32 r, bytes32 s
121     ) external returns (uint amountA, uint amountB);
122     function removeLiquidityETHWithPermit(
123         address token,
124         uint liquidity,
125         uint amountTokenMin,
126         uint amountETHMin,
127         address to,
128         uint deadline,
129         bool approveMax, uint8 v, bytes32 r, bytes32 s
130     ) external returns (uint amountToken, uint amountETH);
131     function swapExactTokensForTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external returns (uint[] memory amounts);
138     function swapTokensForExactTokens(
139         uint amountOut,
140         uint amountInMax,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external returns (uint[] memory amounts);
145     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
146         external
147         payable
148         returns (uint[] memory amounts);
149     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
150         external
151         returns (uint[] memory amounts);
152     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
153         external
154         returns (uint[] memory amounts);
155     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
156         external
157         payable
158         returns (uint[] memory amounts);
159     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
160     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
161     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
162     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
163     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
164 }
165 interface IUniswapV2Router02 {
166     function factory() external pure returns (address);
167     function WETH() external pure returns (address);
168     function swapExactTokensForETHSupportingFeeOnTransferTokens(
169         uint amountIn,
170         uint amountOutMin,
171         address[] calldata path,
172         address to,
173         uint deadline
174     ) external;
175     function addLiquidity(
176         address tokenA,
177         address tokenB,
178         uint amountADesired,
179         uint amountBDesired,
180         uint amountAMin,
181         uint amountBMin,
182         address to,
183         uint deadline
184     ) external returns (uint amountA, uint amountB, uint liquidity);
185     function addLiquidityETH(
186         address token,
187         uint amountTokenDesired,
188         uint amountTokenMin,
189         uint amountETHMin,
190         address to,
191         uint deadline
192     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
193     function removeLiquidity(
194         address tokenA,
195         address tokenB,
196         uint liquidity,
197         uint amountAMin,
198         uint amountBMin,
199         address to,
200         uint deadline
201     ) external returns (uint amountA, uint amountB);
202     function removeLiquidityETH(
203         address token,
204         uint liquidity,
205         uint amountTokenMin,
206         uint amountETHMin,
207         address to,
208         uint deadline
209     ) external returns (uint amountToken, uint amountETH);
210     function removeLiquidityWithPermit(
211         address tokenA,
212         address tokenB,
213         uint liquidity,
214         uint amountAMin,
215         uint amountBMin,
216         address to,
217         uint deadline,
218         bool approveMax, uint8 v, bytes32 r, bytes32 s
219     ) external returns (uint amountA, uint amountB);
220     function removeLiquidityETHWithPermit(
221         address token,
222         uint liquidity,
223         uint amountTokenMin,
224         uint amountETHMin,
225         address to,
226         uint deadline,
227         bool approveMax, uint8 v, bytes32 r, bytes32 s
228     ) external returns (uint amountToken, uint amountETH);
229     function swapExactTokensForTokens(
230         uint amountIn,
231         uint amountOutMin,
232         address[] calldata path,
233         address to,
234         uint deadline
235     ) external returns (uint[] memory amounts);
236     function swapTokensForExactTokens(
237         uint amountOut,
238         uint amountInMax,
239         address[] calldata path,
240         address to,
241         uint deadline
242     ) external returns (uint[] memory amounts);
243     function swapExactETHForTokensSupportingFeeOnTransferTokens(
244         uint amountOutMin,
245         address[] calldata path,
246         address to,
247         uint deadline
248     ) external payable;
249     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
250         external
251         payable
252         returns (uint[] memory amounts);
253     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
254         external
255         returns (uint[] memory amounts);
256     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
257         external
258         returns (uint[] memory amounts);
259     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
260         external
261         payable
262         returns (uint[] memory amounts);
263     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
264     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
265     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
266     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
267     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
268 }
269 
270 interface IUniswapV2Factory {
271     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
272     function feeTo() external view returns (address);
273     function feeToSetter() external view returns (address);
274     function getPair(address tokenA, address tokenB) external view returns (address pair);
275     function allPairs(uint) external view returns (address pair);
276     function allPairsLength() external view returns (uint);
277     function createPair(address tokenA, address tokenB) external returns (address pair);
278     function setFeeTo(address) external;
279     function setFeeToSetter(address) external;
280 }
281 interface IUniswapV2Pair {
282     event Approval(address indexed owner, address indexed spender, uint256 value);
283     event Transfer(address indexed from, address indexed to, uint256 value);
284     function name() external pure returns (string memory);
285     function symbol() external pure returns (string memory);
286     function decimals() external pure returns (uint8);
287     function totalSupply() external view returns (uint256);
288     function balanceOf(address owner) external view returns (uint256);
289     function allowance(address owner, address spender) external view returns (uint256);
290     function approve(address spender, uint256 value) external returns (bool);
291     function transfer(address to, uint256 value) external returns (bool);
292     function transferFrom(address from, address to, uint256 value) external returns (bool);
293     function DOMAIN_SEPARATOR() external view returns (bytes32);
294     function PERMIT_TYPEHASH() external pure returns (bytes32);
295     function nonces(address owner) external view returns (uint256);
296     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
297     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
298     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
299     event Sync(uint112 reserve0, uint112 reserve1);
300     function MINIMUM_LIQUIDITY() external pure returns (uint256);
301     function factory() external view returns (address);
302     function token0() external view returns (address);
303     function token1() external view returns (address);
304     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
305     function price0CumulativeLast() external view returns (uint256);
306     function price1CumulativeLast() external view returns (uint256);
307     function kLast() external view returns (uint256);
308     function burn(address to) external returns (uint256 amount0, uint256 amount1);
309     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
310     function skim(address to) external;
311     function sync() external;
312     function initialize(address, address) external;
313 }
314 contract Context {
315     function _msgSender() internal view virtual returns (address) {
316         return msg.sender;
317     }
318 }
319 contract ERC20Ownable is Context {
320     address private _owner;
321     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
322     constructor() {
323         address msgSender = _msgSender();
324         _owner = msgSender;
325         emit OwnershipTransferred(address(0), msgSender);
326     }
327     function owner() public view virtual returns (address) {
328         return _owner;
329     }
330     modifier onlyOwner() {
331         require(owner() == _msgSender(), "ERC20Ownable: caller is not the owner");
332         _;
333     }
334     function renounceOwnership() public virtual onlyOwner {
335         emit OwnershipTransferred(_owner, address(0));
336         _owner = address(0);
337     }
338     function transferOwnership(address newOwner) public virtual onlyOwner {
339         require(newOwner != address(0), "ERC20Ownable: new owner is the zero address");
340         emit OwnershipTransferred(_owner, newOwner);
341         _owner = newOwner;
342     }
343 }
344 interface IERC20 {
345     event Approval(address indexed owner, address indexed spender, uint value);
346     event Transfer(address indexed from, address indexed to, uint value);
347     function name() external view returns (string memory);
348     function symbol() external view returns (string memory);
349     function decimals() external view returns (uint8);
350     function totalSupply() external view returns (uint);
351     function balanceOf(address owner) external view returns (uint);
352     function allowance(address owner, address spender) external view returns (uint);
353     function approve(address spender, uint value) external returns (bool);
354     function transfer(address to, uint value) external returns (bool);
355     function transferFrom(address from, address to, uint value) external returns (bool);
356 }
357 contract GAWK is Context, IERC20, ERC20Ownable {
358     using SafeMath for uint256;
359 
360     string private constant _tokenName = "GAWK";
361     string private constant _tokenSymbol = "GAWK";
362     uint8 private constant _tokenDecimal = 18;
363 
364     uint256 private constant tMAX = ~uint256(0);
365     uint256 private constant _tTotal = 1e11 * 10**18;
366     uint256 private _rTotal = (tMAX - (tMAX % _tTotal));
367     uint256 private _tFeeTotal;
368     uint256 public maxTokens;
369 	uint256 private minTokensForTaxSwap;
370     address payable private MarketingAddress; //Marketing Wallet Address
371     address payable private AppDevelopAddress; //Other Misc Wallet Address
372     address payable private DevAddress; //Dev Wallet Address
373     address payable public LiquidityAddress; //Liquidity Pool Token Owner. Gets set to BURN after inital LP is created.
374     address dead = address(0xdead);
375     IUniswapV2Router02 public uniswapV2Router;
376     address public uniswapV2Pair;
377     address[] private _excluded;
378     mapping(address => uint256) private _rOwned;
379     mapping(address => uint256) private _tOwned;
380     mapping(address => mapping(address => uint256)) private _allowances;
381     mapping(address => bool) private Excluded;
382 	mapping(address => bool) private ExcludedFromTax;
383     mapping(address => bool) private MaxWalletExclude;
384     mapping (address => bool) public isBotAddress;
385     mapping(address => bool) public isSniperAddress;
386 	uint256 private MarketingTokens;
387 	uint256 private LiquidityTokens;
388     uint256 private AppDevelopmentTokens;
389     uint256 private totalBurnedTokens;
390     uint256 private MarketingTax = 6;
391     uint256 private prevMarketingTax = MarketingTax;
392     uint256 private AppDevelopmentTax = 2;
393     uint256 private prevAppDevelopmentTax = AppDevelopmentTax;
394     uint256 private LiquidityTax = 2; 
395     uint256 private prevLiquidityTax = LiquidityTax;
396     uint256 private ReflectionsTax = 0; 
397     uint256 private prevReflectionsTax = ReflectionsTax;
398     uint256 private taxDivision = MarketingTax + AppDevelopmentTax + LiquidityTax;
399     uint256 private buyMarketingTax = 6;
400     uint256 private buyAppDevelopmentTax = 2; 
401     uint256 private buyLiquidityTax = 2;
402     uint256 private buyReflectionsTax = 0; 
403     uint256 private sellMarketingTax = 6; 
404     uint256 private sellAppDevelopmentTax = 2; 
405     uint256 private sellLiquidityTax = 2;
406     uint256 private sellReflectionsTax = 0; 
407     uint256 private maxTokenPercent = 1;
408     uint256 public ActiveTradeBlock = 0;
409     uint256 public SniperPenaltyEndTime;
410     bool public maxWallet = false;
411     bool public limitsInEffect = false;
412     bool inSwapAndLiquify;
413     bool public swapAndLiquifyEnabled = false;
414     bool public live = false;
415     modifier lockTheSwap() {
416         inSwapAndLiquify = true;
417         _;
418         inSwapAndLiquify = false;
419     }
420     constructor() payable {
421         _rOwned[_msgSender()] = _rTotal / 100 * 5;
422         _rOwned[address(this)] = _rTotal / 100 * 95;
423         maxTokens = _tTotal * maxTokenPercent / 100;
424         minTokensForTaxSwap = _tTotal * 5 / 10000; 
425         MarketingAddress = payable(0xf4Fe4C3cF688Ae1eC71609Ea60dD1b4b0Cc4EBd0); 
426         AppDevelopAddress = payable(0x83cD2e03378B59A0dc9707a5b1cfC379114f2eA2); 
427         DevAddress = payable(0xeF01d68bEc0BC57575c525f15cE9707A75e2296f); 
428         // LEAVE AS OWNER
429         LiquidityAddress = payable(owner()); //Liquidity Pool Token Owner. Gets set to BURN after inital LP is created.
430         Excluded[dead] = true;
431         ExcludedFromTax[_msgSender()] = true;
432         ExcludedFromTax[dead] = true;
433         ExcludedFromTax[address(this)] = true;
434         ExcludedFromTax[MarketingAddress] = true;
435         ExcludedFromTax[AppDevelopAddress] = true;
436         ExcludedFromTax[DevAddress] = true;
437         MaxWalletExclude[address(this)] = true;
438         MaxWalletExclude[_msgSender()] = true;
439         MaxWalletExclude[dead] = true;
440         MaxWalletExclude[MarketingAddress] = true;
441         MaxWalletExclude[AppDevelopAddress] = true;
442         MaxWalletExclude[DevAddress] = true;
443         AddBot(0x41B0320bEb1563A048e2431c8C1cC155A0DFA967);
444         AddBot(0x91B305F0890Fd0534B66D8d479da6529C35A3eeC);
445         AddBot(0x7F5622afb5CEfbA39f96CA3b2814eCF0E383AAA4);
446         AddBot(0xfcf6a3d7eb8c62a5256a020e48f153c6D5Dd6909);
447         AddBot(0x74BC89a9e831ab5f33b90607Dd9eB5E01452A064);
448         AddBot(0x1F53592C3aA6b827C64C4a3174523182c52Ece84);
449         AddBot(0x460545C01c4246194C2e511F166D84bbC8a07608);
450         AddBot(0x2E5d67a1d15ccCF65152B3A8ec5315E73461fBcd);
451         AddBot(0xb5aF12B837aAf602298B3385640F61a0fF0F4E0d);
452         AddBot(0xEd3e444A30Bd440FBab5933dCCC652959DfCB5Ba);
453         AddBot(0xEC366bbA6266ac8960198075B14FC1D38ea7de88);
454         AddBot(0x10Bf6836600D7cFE1c06b145A8Ac774F8Ba91FDD);
455         AddBot(0x44ae54e28d082C98D53eF5593CE54bB231e565E7);
456         AddBot(0xa3e820006F8553d5AC9F64A2d2B581501eE24FcF);
457 		AddBot(0x2228476AC5242e38d5864068B8c6aB61d6bA2222);
458 		AddBot(0xcC7e3c4a8208172CA4c4aB8E1b8B4AE775Ebd5a8);
459 		AddBot(0x5b3EE79BbBDb5B032eEAA65C689C119748a7192A);
460 		AddBot(0x4ddA45d3E9BF453dc95fcD7c783Fe6ff9192d1BA);
461 
462         emit Transfer(address(0), _msgSender(), _tTotal * 5 / 100);
463         emit Transfer(address(0), address(this), _tTotal * 95 / 100);
464     }
465     receive() external payable {}
466     function name() public pure override returns (string memory) {
467         return _tokenName;
468     }
469     function symbol() public pure override returns (string memory) {
470         return _tokenSymbol;
471     }
472     function decimals() public pure override returns (uint8) {
473         return _tokenDecimal;
474     }
475     function totalSupply() public pure override returns (uint256) {
476         return _tTotal;
477     }
478     function balanceOf(address account) public view override returns (uint256) {
479         if (Excluded[account]) return _tOwned[account];
480         return tokenFromReflection(_rOwned[account]);
481     }
482     function transfer(address recipient, uint256 amount) public override returns (bool) {
483         _transfer(_msgSender(), recipient, amount);
484         return true;
485     }
486     function allowance(address owner, address spender) public view override returns (uint256) {
487         return _allowances[owner][spender];
488     }
489     function approve(address spender, uint256 amount) public override returns (bool) {
490         _approve(_msgSender(), spender, amount);
491         return true;
492     }
493     function transferFrom(address sender,address recipient,uint256 amount) public override returns (bool) {
494         _transfer(sender, recipient, amount);
495         _approve(sender,_msgSender(),
496         _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
497         );
498         return true;
499     }
500     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
501         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
502         return true;
503     }
504     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
505         _approve(
506             _msgSender(),
507             spender,
508             _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero")
509         );
510         return true;
511     }
512     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
513         require(tAmount <= _tTotal, "Amt must be less than supply");
514         if (!deductTransferFee) {
515             (uint256 rAmount, , , , , ) = _getValues(tAmount);
516             return rAmount;
517         } else {
518             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
519             return rTransferAmount;
520         }
521     }
522     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
523         require(rAmount <= _rTotal, "Amt must be less than tot refl");
524         uint256 currentRate = _getRate();
525         return rAmount.div(currentRate);
526     }
527     function _reflectFee(uint256 rFee, uint256 tFee) private {
528         _rTotal = _rTotal.sub(rFee);
529         _tFeeTotal = _tFeeTotal.add(tFee);
530     }
531     function _getValues(uint256 tAmount) private view returns (uint256,uint256,uint256,uint256,uint256,uint256) {
532         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
533         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
534         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
535     }
536     function _getTValues(uint256 tAmount)private view returns (uint256,uint256,uint256) {
537         uint256 tFee = calculateTaxFee(tAmount);
538         uint256 tLiquidity = calculateLiquidityFee(tAmount);
539         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
540         return (tTransferAmount, tFee, tLiquidity);
541     }
542     function _getRValues(uint256 tAmount,uint256 tFee,uint256 tLiquidity,uint256 currentRate) private pure returns (uint256,uint256,uint256) {
543         uint256 rAmount = tAmount.mul(currentRate);
544         uint256 rFee = tFee.mul(currentRate);
545         uint256 rLiquidity = tLiquidity.mul(currentRate);
546         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
547         return (rAmount, rTransferAmount, rFee);
548     }
549     function _getRate() private view returns (uint256) {
550         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
551         return rSupply.div(tSupply);
552     }
553     function _getCurrentSupply() private view returns (uint256, uint256) {
554         uint256 rSupply = _rTotal;
555         uint256 tSupply = _tTotal;
556         for (uint256 i = 0; i < _excluded.length; i++) {
557             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
558             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
559             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
560         }
561         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
562         return (rSupply, tSupply);
563     }
564     function _takeLiquidity(uint256 tLiquidity) private {
565         MarketingTokens += tLiquidity * MarketingTax / taxDivision;
566         AppDevelopmentTokens += tLiquidity * AppDevelopmentTax / taxDivision;
567         LiquidityTokens += tLiquidity * LiquidityTax / taxDivision;
568         uint256 currentRate = _getRate();
569         uint256 rLiquidity = tLiquidity.mul(currentRate);
570         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
571         if (Excluded[address(this)])
572             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
573     }
574     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
575         return _amount.mul(ReflectionsTax).div(10**2);
576     }
577     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
578         return _amount.mul(MarketingTax + AppDevelopmentTax + LiquidityTax).div(10**2);
579     }
580     function GoLive() external onlyOwner returns (bool){
581         require(!live, "Trades already Live!");
582         maxWallet = true;
583         swapAndLiquifyEnabled = true;
584         limitsInEffect = true;
585         live = true;
586         ActiveTradeBlock = block.number;
587         SniperPenaltyEndTime = block.timestamp + 96 hours;
588         IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
589         uniswapV2Router = _uniV2Router;
590         MaxWalletExclude[address(uniswapV2Router)] = true;
591         _approve(address(this), address(uniswapV2Router), _tTotal);
592         uniswapV2Pair = IUniswapV2Factory(_uniV2Router.factory()).createPair(address(this), _uniV2Router.WETH());
593         MaxWalletExclude[address(uniswapV2Pair)] = true;
594         require(address(this).balance > 0, "Must have ETH on contract to Open Market!");
595         addLiquidity(balanceOf(address(this)), address(this).balance);
596         setLiquidityAddress(dead);
597         return true;
598     }
599     function _approve(address owner,address spender,uint256 amount) private {
600         require(owner != address(0), "ERC20: approve from zero address");
601         require(spender != address(0), "ERC20: approve to zero address");
602         _allowances[owner][spender] = amount;
603         emit Approval(owner, spender, amount);
604     }
605     function _transfer(address from, address to, uint256 amount) private {
606         require(from != address(0), "ERC20: transfer from the zero address");
607         require(to != address(0), "ERC20: transfer to the zero address");
608         require(amount > 0, "Transfer amount must be greater than zero");
609         require(!isBotAddress[from]);
610         if(!live){
611             require(ExcludedFromTax[from] || ExcludedFromTax[to], "Trading Is Not Live!");
612         }
613         if (maxWallet && !MaxWalletExclude[to]) {
614             require(balanceOf(to) + amount <= maxTokens, "Max amount of tokens for wallet reached!");
615         }
616         if(limitsInEffect){
617             if (from != owner() && to != owner() && to != address(0) && to != dead && !inSwapAndLiquify) {
618                 if(from != owner() && to != uniswapV2Pair) {
619                     for (uint x = 0; x < 3; x++) {
620                     if(block.number == ActiveTradeBlock + x) {
621                         isSniperAddress[to] = true;
622                         }
623                     }
624                 }
625             }
626         }
627         uint256 totalTokensToSwap = LiquidityTokens.add(MarketingTokens).add(AppDevelopmentTokens);
628         uint256 contractTokenBalance = balanceOf(address(this));
629         bool overMinimumTokenBalance = contractTokenBalance >= minTokensForTaxSwap;
630         if (!inSwapAndLiquify && swapAndLiquifyEnabled && balanceOf(uniswapV2Pair) > 0 && totalTokensToSwap > 0 && !ExcludedFromTax[to] && !ExcludedFromTax[from] && to == uniswapV2Pair && overMinimumTokenBalance) {
631             swapTaxTokens();
632             }
633         bool takeFee = true;
634         if (ExcludedFromTax[from] || ExcludedFromTax[to]) {
635             takeFee = false;
636         } else {
637             if (from == uniswapV2Pair) {
638                 removeAllFee();
639                 MarketingTax = buyMarketingTax;
640                 AppDevelopmentTax = buyAppDevelopmentTax;
641                 ReflectionsTax = buyReflectionsTax;
642                 LiquidityTax = buyLiquidityTax;
643             } 
644             else if (to == uniswapV2Pair) {
645                 removeAllFee();
646                 MarketingTax = sellMarketingTax;
647                 AppDevelopmentTax = sellAppDevelopmentTax;
648                 ReflectionsTax = sellReflectionsTax;
649                 LiquidityTax = sellLiquidityTax;
650                 if(isSniperAddress[from] && SniperPenaltyEndTime > block.timestamp) {
651                     MarketingTax = 95;
652                 }
653             } else {
654                 require(!isSniperAddress[from] || SniperPenaltyEndTime <= block.timestamp);
655                 removeAllFee();
656             }
657         }
658         _tokenTransfer(from, to, amount, takeFee);
659     }
660     function swapTaxTokens() private lockTheSwap {
661         uint256 contractBalance = balanceOf(address(this));
662         uint256 totalTokensToSwap = MarketingTokens + AppDevelopmentTokens + LiquidityTokens;
663         uint256 swapLiquidityTokens = LiquidityTokens.div(2);
664         uint256 amountToSwapForETH = contractBalance.sub(swapLiquidityTokens);
665         uint256 initialETHBalance = address(this).balance;
666         swapTokensForETH(amountToSwapForETH); 
667         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
668         uint256 ethForMarketing = ethBalance.mul(MarketingTokens).div(totalTokensToSwap);
669         uint256 ethForAppDev = ethBalance.mul(AppDevelopmentTokens).div(totalTokensToSwap);
670         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing).sub(ethForAppDev);
671         MarketingTokens = 0;
672         AppDevelopmentTokens = 0;
673         LiquidityTokens = 0;
674         (bool success,) = address(MarketingAddress).call{value: ethForMarketing}("");
675         (success,) = address(AppDevelopAddress).call{value: ethForAppDev}("");
676         addLiquidity(swapLiquidityTokens, ethForLiquidity);
677         if(address(this).balance > 5 * 10**17){
678             (success,) = address(DevAddress).call{value: address(this).balance}("");
679         }
680     }
681     function swapTokensForETH(uint256 tokenAmount) private {
682         address[] memory path = new address[](2);
683         path[0] = address(this);
684         path[1] = uniswapV2Router.WETH();
685         _approve(address(this), address(uniswapV2Router), tokenAmount);
686         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
687             tokenAmount,
688             0, // accept any amount of ETH
689             path,
690             address(this),
691             block.timestamp
692         );
693     }
694     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
695         _approve(address(this), address(uniswapV2Router), tokenAmount);
696         uniswapV2Router.addLiquidityETH{value: ethAmount}(
697             address(this),
698             tokenAmount,
699             0, // slippage is unavoidable
700             0, // slippage is unavoidable
701             LiquidityAddress,
702             block.timestamp
703         );
704     }
705     function removeAllFee() private {
706         if (LiquidityTax == 0 && MarketingTax == 0 && AppDevelopmentTax == 0 && ReflectionsTax == 0) return;
707         prevLiquidityTax = LiquidityTax;
708         prevMarketingTax = MarketingTax;
709         prevAppDevelopmentTax = AppDevelopmentTax;
710         prevReflectionsTax = ReflectionsTax;
711 
712         LiquidityTax = 0;
713         MarketingTax = 0;
714         AppDevelopmentTax = 0;
715         ReflectionsTax = 0;
716     }
717     function restoreAllFee() private {
718         MarketingTax = prevMarketingTax;
719         AppDevelopmentTax = prevAppDevelopmentTax;
720         ReflectionsTax = prevReflectionsTax;
721         LiquidityTax = prevLiquidityTax;
722     }
723     function _tokenTransfer(address sender,address recipient,uint256 amount,bool takeFee) private {
724         if (!takeFee) removeAllFee();
725         if (Excluded[sender] && !Excluded[recipient]) {
726             _transferFromExcluded(sender, recipient, amount);
727         } else if (!Excluded[sender] && Excluded[recipient]) {
728             _transferToExcluded(sender, recipient, amount);
729         } else if (!Excluded[sender] && !Excluded[recipient]) {
730             _transferStandard(sender, recipient, amount);
731         } else if (Excluded[sender] && Excluded[recipient]) {
732             _transferBothExcluded(sender, recipient, amount);
733         } else {
734             _transferStandard(sender, recipient, amount);
735         }
736         if (!takeFee) restoreAllFee();
737     }
738     function _transferStandard(address sender,address recipient,uint256 tAmount) private {
739         (
740             uint256 rAmount,
741             uint256 rTransferAmount,
742             uint256 rFee,
743             uint256 tTransferAmount,
744             uint256 tFee,
745             uint256 tLiquidity
746         ) = _getValues(tAmount);
747         _rOwned[sender] = _rOwned[sender].sub(rAmount);
748         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
749         _takeLiquidity(tLiquidity);
750         _reflectFee(rFee, tFee);
751         emit Transfer(sender, recipient, tTransferAmount);
752     }
753     function _transferToExcluded(address sender,address recipient,uint256 tAmount) private {
754         (
755             uint256 rAmount,
756             uint256 rTransferAmount,
757             uint256 rFee,
758             uint256 tTransferAmount,
759             uint256 tFee,
760             uint256 tLiquidity
761         ) = _getValues(tAmount);
762         _rOwned[sender] = _rOwned[sender].sub(rAmount);
763         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
764         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
765         _takeLiquidity(tLiquidity);
766         _reflectFee(rFee, tFee);
767         emit Transfer(sender, recipient, tTransferAmount);
768     }
769     function _transferFromExcluded(address sender,address recipient,uint256 tAmount) private {
770         (
771             uint256 rAmount,
772             uint256 rTransferAmount,
773             uint256 rFee,
774             uint256 tTransferAmount,
775             uint256 tFee,
776             uint256 tLiquidity
777         ) = _getValues(tAmount);
778         _tOwned[sender] = _tOwned[sender].sub(tAmount);
779         _rOwned[sender] = _rOwned[sender].sub(rAmount);
780         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
781         _takeLiquidity(tLiquidity);
782         _reflectFee(rFee, tFee);
783         emit Transfer(sender, recipient, tTransferAmount);
784     }
785     function _transferBothExcluded(address sender,address recipient,uint256 tAmount) private {
786         (
787             uint256 rAmount,
788             uint256 rTransferAmount,
789             uint256 rFee,
790             uint256 tTransferAmount,
791             uint256 tFee,
792             uint256 tLiquidity
793         ) = _getValues(tAmount);
794         _tOwned[sender] = _tOwned[sender].sub(tAmount);
795         _rOwned[sender] = _rOwned[sender].sub(rAmount);
796         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
797         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
798         _takeLiquidity(tLiquidity);
799         _reflectFee(rFee, tFee);
800         emit Transfer(sender, recipient, tTransferAmount);
801     }
802     function _tokenTransferNoFee(address sender,address recipient,uint256 amount) private {
803         _rOwned[sender] = _rOwned[sender].sub(amount);
804         _rOwned[recipient] = _rOwned[recipient].add(amount);
805 
806         if (Excluded[sender]) {
807             _tOwned[sender] = _tOwned[sender].sub(amount);
808         }
809         if (Excluded[recipient]) {
810             _tOwned[recipient] = _tOwned[recipient].add(amount);
811         }
812         emit Transfer(sender, recipient, amount);
813     }
814     function setLiquidityAddress(address _LPAddress) internal {
815         LiquidityAddress = payable(_LPAddress);
816         ExcludedFromTax[LiquidityAddress] = true;
817     }
818     function ownerSetLiquidityAddress(address _LPAddress) external onlyOwner {
819         LiquidityAddress = payable(_LPAddress);
820         ExcludedFromTax[LiquidityAddress] = true;
821     }
822     function excludeFromTax(address account) external onlyOwner {
823         ExcludedFromTax[account] = true;
824     }
825     function includeInTax(address account) external onlyOwner {
826         ExcludedFromTax[account] = false;
827     }
828     function excludeFromMaxTokens(address account) external onlyOwner {
829         MaxWalletExclude[account] = true;
830     }
831     function includeInMaxTokens(address account) external onlyOwner {
832         MaxWalletExclude[account] = false;
833     }
834     function AddBot(address _user) public onlyOwner {
835         require(!isBotAddress[_user]);
836         isBotAddress[_user] = true;
837     }
838 	function RemoveBot(address _user) public onlyOwner {
839         require(isBotAddress[_user]);
840         isBotAddress[_user] = false;
841     }
842     function removeSniper(address account) external onlyOwner {
843         require(isSniperAddress[account]);
844         isSniperAddress[account] = false;
845     }
846     function removeLimits() external onlyOwner {
847         limitsInEffect = true;
848     }
849     function resumeLimits() external onlyOwner {
850         limitsInEffect = false;
851     }
852     function TaxSwapEnable() external onlyOwner {
853         swapAndLiquifyEnabled = true;
854     }
855     function TaxSwapDisable() external onlyOwner {
856         swapAndLiquifyEnabled = false;
857     }
858     function enableMaxWallet() external onlyOwner {
859         maxWallet = true;
860     }
861     function disableMaxWallet() external onlyOwner {
862         maxWallet = false;
863     }
864     function setMaxWallet(uint256 _percent) external onlyOwner {
865         maxTokens = _tTotal * _percent / 100;
866         require(maxTokens <= _tTotal * 3 / 100, "Cannot set max wallet to more then 3% of total supply");
867     }
868     function ManualTaxSwap() external onlyOwner {
869         uint256 contractBalance = balanceOf(address(this));
870         require(contractBalance >= _tTotal * 1 / 10000, "Can only swap back if more than 0.01% of tokens stuck on contract");
871         swapTaxTokens();
872     }
873     function withdrawETH() public onlyOwner {
874         bool success;
875         (success,) = address(DevAddress).call{value: address(this).balance}("");
876     }
877     function withdrawTokens(uint256 _percent, address _address) public onlyOwner {
878         MarketingTokens = 0;
879         AppDevelopmentTokens = 0;
880         LiquidityTokens = 0;
881         uint256 amount = balanceOf(address(this)) * _percent / 10**2;
882         require(amount > 0, "Must have Tokens on CA");
883         _transfer(address(this), _address, amount);
884     }
885     function setBuyTaxes(uint256 _buyMarketingTax, uint256 _buyAppDevelopmentTax, uint256 _buyLiquidityTax, uint256 _buyReflectionsTax) external onlyOwner {
886         buyMarketingTax = _buyMarketingTax;
887         buyAppDevelopmentTax = _buyAppDevelopmentTax;
888         buyLiquidityTax = _buyLiquidityTax;
889         buyReflectionsTax = _buyReflectionsTax;
890     }
891     function setSellTaxes(uint256 _sellMarketingTax, uint256 _sellAppDevelopmentTax, uint256 _sellLiquidityTax, uint256 _sellReflectionsTax) external onlyOwner {
892         sellMarketingTax = _sellMarketingTax;
893         sellAppDevelopmentTax = _sellAppDevelopmentTax;
894         sellLiquidityTax = _sellLiquidityTax;
895         sellReflectionsTax = _sellReflectionsTax;
896     }
897     function viewBuyTaxes() public view returns(uint256 BuyMarketing, uint256 buyAppDevelopment, uint256 buyLiquidity, uint256 buyReflections) {
898         return(buyMarketingTax,buyAppDevelopmentTax,buyLiquidityTax,buyReflections);
899     }
900     function viewSellTaxes() public view returns(uint256 sellMarketing, uint256 sellAppDevelopment, uint256 sellLiquidity, uint256 sellReflections) {
901         return (sellMarketingTax,sellAppDevelopmentTax,sellLiquidityTax,sellReflections);
902     }
903     function manualBurnTokens(uint256 percent) external onlyOwner returns (bool){
904         require(percent <= 10, "May not nuke more than 10% of tokens in LP");
905         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
906         uint256 amountToBurn = liquidityPairBalance * percent / 10**2;
907         if (amountToBurn > 0){
908             _transfer(uniswapV2Pair, dead, amountToBurn);
909         }
910         totalBurnedTokens = balanceOf(dead);
911         require(totalBurnedTokens <= _tTotal * 50 / 10**2, "Can not burn more then 50% of supply");
912         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
913         pair.sync();
914         return true;
915     }
916     function AirDrop(address[] memory wallets, uint256[] memory percent) external onlyOwner{
917         require(wallets.length < 10, "Can only airdrop 100 wallets per txn due to gas limits");
918         for(uint256 i = 0; i < wallets.length; i++){
919             address wallet = wallets[i];
920             uint256 amount = _tTotal * percent[i] / 100;
921             _transfer(msg.sender, wallet, amount);
922         }
923     }
924 }