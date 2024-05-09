1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.7;
3 contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 }
8 contract ERC20Ownable is Context {
9     address private _owner;
10     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11     constructor() {
12         address msgSender = _msgSender();
13         _owner = msgSender;
14         emit OwnershipTransferred(address(0), msgSender);
15     }
16     function owner() public view virtual returns (address) {
17         return _owner;
18     }
19     modifier onlyOwner() {
20         require(owner() == _msgSender(), "ERC20Ownable: caller is not the owner");
21         _;
22     }
23     function renounceOwnership() public virtual onlyOwner {
24         emit OwnershipTransferred(_owner, address(0));
25         _owner = address(0);
26     }
27     function transferOwnership(address newOwner) public virtual onlyOwner {
28         require(newOwner != address(0), "ERC20Ownable: new owner is the zero address");
29         emit OwnershipTransferred(_owner, newOwner);
30         _owner = newOwner;
31     }
32 }
33 // CAUTION
34 // This version of SafeMath should only be used with Solidity 0.8 or later,
35 // because it relies on the compiler's built in overflow checks.
36 library SafeMath {
37     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             uint256 c = a + b;
40             if (c < a) return (false, 0);
41             return (true, c);
42         }
43     }
44     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         unchecked {
46             if (b > a) return (false, 0);
47             return (true, a - b);
48         }
49     }
50     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53             // benefit is lost if 'b' is also tested.
54             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55             if (a == 0) return (true, 0);
56             uint256 c = a * b;
57             if (c / a != b) return (false, 0);
58             return (true, c);
59         }
60     }
61     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {
63             if (b == 0) return (false, 0);
64             return (true, a / b);
65         }
66     }
67     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b == 0) return (false, 0);
70             return (true, a % b);
71         }
72     }
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a + b;
75     }
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a - b;
78     }
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         return a * b;
81     }
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         return a / b;
84     }
85     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86         return a % b;
87     }
88     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         unchecked {
90             require(b <= a, errorMessage);
91             return a - b;
92         }
93     }
94     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         unchecked {
96             require(b > 0, errorMessage);
97             return a / b;
98         }
99     }
100     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         unchecked {
102             require(b > 0, errorMessage);
103             return a % b;
104         }
105     }
106 }
107 interface IERC20 {
108     event Approval(address indexed owner, address indexed spender, uint value);
109     event Transfer(address indexed from, address indexed to, uint value);
110     function name() external view returns (string memory);
111     function symbol() external view returns (string memory);
112     function decimals() external view returns (uint8);
113     function totalSupply() external view returns (uint);
114     function balanceOf(address owner) external view returns (uint);
115     function allowance(address owner, address spender) external view returns (uint);
116     function approve(address spender, uint value) external returns (bool);
117     function transfer(address to, uint value) external returns (bool);
118     function transferFrom(address from, address to, uint value) external returns (bool);
119 }
120 interface IUniswapV2Router01 {
121     function factory() external pure returns (address);
122     function WETH() external pure returns (address);
123     function addLiquidity(
124         address tokenA,
125         address tokenB,
126         uint amountADesired,
127         uint amountBDesired,
128         uint amountAMin,
129         uint amountBMin,
130         address to,
131         uint deadline
132     ) external returns (uint amountA, uint amountB, uint liquidity);
133     function addLiquidityETH(
134         address token,
135         uint amountTokenDesired,
136         uint amountTokenMin,
137         uint amountETHMin,
138         address to,
139         uint deadline
140     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
141     function removeLiquidity(
142         address tokenA,
143         address tokenB,
144         uint liquidity,
145         uint amountAMin,
146         uint amountBMin,
147         address to,
148         uint deadline
149     ) external returns (uint amountA, uint amountB);
150     function removeLiquidityETH(
151         address token,
152         uint liquidity,
153         uint amountTokenMin,
154         uint amountETHMin,
155         address to,
156         uint deadline
157     ) external returns (uint amountToken, uint amountETH);
158     function removeLiquidityWithPermit(
159         address tokenA,
160         address tokenB,
161         uint liquidity,
162         uint amountAMin,
163         uint amountBMin,
164         address to,
165         uint deadline,
166         bool approveMax, uint8 v, bytes32 r, bytes32 s
167     ) external returns (uint amountA, uint amountB);
168     function removeLiquidityETHWithPermit(
169         address token,
170         uint liquidity,
171         uint amountTokenMin,
172         uint amountETHMin,
173         address to,
174         uint deadline,
175         bool approveMax, uint8 v, bytes32 r, bytes32 s
176     ) external returns (uint amountToken, uint amountETH);
177     function swapExactTokensForTokens(
178         uint amountIn,
179         uint amountOutMin,
180         address[] calldata path,
181         address to,
182         uint deadline
183     ) external returns (uint[] memory amounts);
184     function swapTokensForExactTokens(
185         uint amountOut,
186         uint amountInMax,
187         address[] calldata path,
188         address to,
189         uint deadline
190     ) external returns (uint[] memory amounts);
191     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
192         external
193         payable
194         returns (uint[] memory amounts);
195     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
196         external
197         returns (uint[] memory amounts);
198     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
199         external
200         returns (uint[] memory amounts);
201     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
202         external
203         payable
204         returns (uint[] memory amounts);
205     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
206     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
207     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
208     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
209     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
210 }
211 interface IUniswapV2Router02 {
212     function factory() external pure returns (address);
213     function WETH() external pure returns (address);
214     function swapExactTokensForETHSupportingFeeOnTransferTokens(
215         uint amountIn,
216         uint amountOutMin,
217         address[] calldata path,
218         address to,
219         uint deadline
220     ) external;
221     function addLiquidity(
222         address tokenA,
223         address tokenB,
224         uint amountADesired,
225         uint amountBDesired,
226         uint amountAMin,
227         uint amountBMin,
228         address to,
229         uint deadline
230     ) external returns (uint amountA, uint amountB, uint liquidity);
231     function addLiquidityETH(
232         address token,
233         uint amountTokenDesired,
234         uint amountTokenMin,
235         uint amountETHMin,
236         address to,
237         uint deadline
238     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
239     function removeLiquidity(
240         address tokenA,
241         address tokenB,
242         uint liquidity,
243         uint amountAMin,
244         uint amountBMin,
245         address to,
246         uint deadline
247     ) external returns (uint amountA, uint amountB);
248     function removeLiquidityETH(
249         address token,
250         uint liquidity,
251         uint amountTokenMin,
252         uint amountETHMin,
253         address to,
254         uint deadline
255     ) external returns (uint amountToken, uint amountETH);
256     function removeLiquidityWithPermit(
257         address tokenA,
258         address tokenB,
259         uint liquidity,
260         uint amountAMin,
261         uint amountBMin,
262         address to,
263         uint deadline,
264         bool approveMax, uint8 v, bytes32 r, bytes32 s
265     ) external returns (uint amountA, uint amountB);
266     function removeLiquidityETHWithPermit(
267         address token,
268         uint liquidity,
269         uint amountTokenMin,
270         uint amountETHMin,
271         address to,
272         uint deadline,
273         bool approveMax, uint8 v, bytes32 r, bytes32 s
274     ) external returns (uint amountToken, uint amountETH);
275     function swapExactTokensForTokens(
276         uint amountIn,
277         uint amountOutMin,
278         address[] calldata path,
279         address to,
280         uint deadline
281     ) external returns (uint[] memory amounts);
282     function swapTokensForExactTokens(
283         uint amountOut,
284         uint amountInMax,
285         address[] calldata path,
286         address to,
287         uint deadline
288     ) external returns (uint[] memory amounts);
289     function swapExactETHForTokensSupportingFeeOnTransferTokens(
290         uint amountOutMin,
291         address[] calldata path,
292         address to,
293         uint deadline
294     ) external payable;
295     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
296         external
297         payable
298         returns (uint[] memory amounts);
299     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
300         external
301         returns (uint[] memory amounts);
302     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
303         external
304         returns (uint[] memory amounts);
305     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
306         external
307         payable
308         returns (uint[] memory amounts);
309     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
310     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
311     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
312     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
313     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
314 }
315 interface IUniswapV2Factory {
316     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
317     function feeTo() external view returns (address);
318     function feeToSetter() external view returns (address);
319     function getPair(address tokenA, address tokenB) external view returns (address pair);
320     function allPairs(uint) external view returns (address pair);
321     function allPairsLength() external view returns (uint);
322     function createPair(address tokenA, address tokenB) external returns (address pair);
323     function setFeeTo(address) external;
324     function setFeeToSetter(address) external;
325 }
326 contract SHINIGAMI is Context, IERC20, ERC20Ownable {
327     using SafeMath for uint256;
328     mapping(address => uint256) private _rOwned;
329     mapping(address => uint256) private _tOwned;
330     mapping(address => mapping(address => uint256)) private _allowances;
331     mapping(address => bool) private _isExcludedFromFee;
332     mapping(address => bool) private _isExcluded;
333     mapping(address => bool) private _isMaxWalletExclude;
334     mapping (address => bool) private _isBot;
335 	mapping(address => bool) public boughtEarly;
336     address dead = 0x000000000000000000000000000000000000dEaD;
337     address[] private _excluded;
338     address payable public marketingAddress;
339     address payable public giveAwayAddress;
340     IUniswapV2Router02 private uniV2Router;
341     address private uniV2Pair;
342     bool inSwapAndLiquify;
343     bool private swapAndLiquifyEnabled = true;
344     bool private _initLaunch = true;
345     bool private _antiSnipe = false;
346     bool private _buyLimits = false;
347     bool private _maxWalletOn = false;
348     uint256 public tradingActiveBlock = 0;
349     uint256 public earlyBuyPenaltyEnd;
350     uint256 private constant MAX = ~uint256(0);
351     uint256 private constant _tTotal = 1e14 * 10**18;
352     uint256 private _rTotal = (MAX - (MAX % _tTotal));
353     uint256 private _tFeeTotal;
354     uint256 private _maxWalletSize = 2000000000000 * 10**18;
355     uint256 private minTokensBeforeSwap;
356     uint256 private tokensForLiquidityToSwap;
357     uint256 private tokensForMarketingToSwap;
358     uint256 private tokensForGiveAwayToSwap;
359 
360     string private constant _nomen = "SHINIGAMI";
361     string private constant _symbo = "SHINIGAMI";
362     uint8 private constant _decim = 18;
363 
364     //DEFAULT PLACE HOLDERS | OVERRIDDEN EACH TXN
365     uint private _marTax = 6; // tax for marketing
366     uint private _previousMarTax = _marTax;
367     uint private _giveAwayTax = 2; // tax for GiveAways
368     uint private _previousGiveAwayTax = _giveAwayTax;
369     uint private _liqTax = 3; // tax for liquidity
370     uint private _previousLiqTax = _liqTax;
371     uint private _refTax = 0; //tax for reflections
372     uint private _previousRefTax = _refTax;
373     uint private _liqDiv = _marTax + _giveAwayTax + _liqTax;
374 
375     //MAIN TAX VALUES FOR BUY | CHANGEBLE WITH functon setBuyF()
376     uint private _buyMarTax = 6;
377     uint private _preBuyMarTax = _buyMarTax;
378     uint private _buyGiveAwayTax = 2;
379     uint private _preBuyGiveAwayTax = _buyGiveAwayTax;
380     uint private _buyLiqTax = 3;
381     uint private _preBuyLiqTax = _buyLiqTax;
382     uint private _buyRefTax = 0;
383     uint private _preBuyRefTax = _buyRefTax;
384 
385     //MAIN TAX VALUES FOR SELL | CHANGEBLE WITH functon setSellF()
386     uint private _sellMarTax = 6;
387     uint private _preSellMarTax = _sellMarTax;
388     uint private _sellGiveAwayTax = 2;
389     uint private _preSellGiveAwayTax = _sellGiveAwayTax;
390     uint private _sellLiqTax = 3;
391     uint private _preSellLiqTax = _sellLiqTax;
392     uint private _sellRefTax = 0;
393     uint private _preSellRefTax = _sellRefTax;
394 
395     event SwapAndLiquifyEnabledUpdated(bool enabled);
396     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
397     event UpdatedMarketingAddress(address marketing);
398     event UpdatedGiveAwayAddress(address giveAwayAddress);
399     event BoughtEarly(address indexed sniper);
400     event RemovedSniper(address indexed notsniper);
401     modifier lockTheSwap() {
402         inSwapAndLiquify = true;
403         _;
404         inSwapAndLiquify = false;
405     }
406     constructor() {
407         _rOwned[_msgSender()] = _rTotal;
408         marketingAddress = payable(0xAd32B5c3aaA19e6c42FDFF2832Cb47978a4b03CD);
409         giveAwayAddress = payable(0x625Eee4A87C9743fB94D299eaAa68Fa918b5bf11);
410         minTokensBeforeSwap = _tTotal.mul(5).div(10000);
411         _isExcludedFromFee[_msgSender()] = true;
412         _isExcludedFromFee[address(this)] = true;
413         _isExcludedFromFee[address(marketingAddress)] = true;
414         _isExcludedFromFee[address(giveAwayAddress)] = true;
415         _isMaxWalletExclude[address(this)] = true;
416         _isMaxWalletExclude[_msgSender()] = true;
417         _isMaxWalletExclude[address(dead)] = true;
418         _isMaxWalletExclude[address(marketingAddress)] = true;
419         _isMaxWalletExclude[address(giveAwayAddress)] = true;
420 		addBot(0x41B0320bEb1563A048e2431c8C1cC155A0DFA967);
421         addBot(0x91B305F0890Fd0534B66D8d479da6529C35A3eeC);
422         addBot(0x7F5622afb5CEfbA39f96CA3b2814eCF0E383AAA4);
423         addBot(0xfcf6a3d7eb8c62a5256a020e48f153c6D5Dd6909);
424         addBot(0x74BC89a9e831ab5f33b90607Dd9eB5E01452A064);
425         addBot(0x1F53592C3aA6b827C64C4a3174523182c52Ece84);
426         addBot(0x460545C01c4246194C2e511F166D84bbC8a07608);
427         addBot(0x2E5d67a1d15ccCF65152B3A8ec5315E73461fBcd);
428         addBot(0xb5aF12B837aAf602298B3385640F61a0fF0F4E0d);
429         addBot(0xEd3e444A30Bd440FBab5933dCCC652959DfCB5Ba);
430         addBot(0xEC366bbA6266ac8960198075B14FC1D38ea7de88);
431         addBot(0x10Bf6836600D7cFE1c06b145A8Ac774F8Ba91FDD);
432         addBot(0x44ae54e28d082C98D53eF5593CE54bB231e565E7);
433         addBot(0xa3e820006F8553d5AC9F64A2d2B581501eE24FcF);
434 		addBot(0x2228476AC5242e38d5864068B8c6aB61d6bA2222);
435 		addBot(0xcC7e3c4a8208172CA4c4aB8E1b8B4AE775Ebd5a8);
436 		addBot(0x5b3EE79BbBDb5B032eEAA65C689C119748a7192A);
437 		addBot(0x4ddA45d3E9BF453dc95fcD7c783Fe6ff9192d1BA);
438         addBot(0x0160A15f0f13608F041376a59882Bdd44909b59E);
439         addBot(0x859E94401bA176A7ab9AAFE5f5dEb52f8D2C76Dc);
440         addBot(0xD49e21e8380220252D6138790d403af81ADf11F5);
441         addBot(0xAF00960b562769b5826eFD8D37F2016b5b154FF7);
442 
443         emit Transfer(address(0), _msgSender(), _tTotal);
444     }
445     receive() external payable {}
446     function name() public pure override returns (string memory) {
447         return _nomen;
448     }
449     function symbol() public pure override returns (string memory) {
450         return _symbo;
451     }
452     function decimals() public pure override returns (uint8) {
453         return _decim;
454     }
455     function totalSupply() public pure override returns (uint256) {
456         return _tTotal;
457     }
458     function balanceOf(address account) public view override returns (uint256) {
459         if (_isExcluded[account]) return _tOwned[account];
460         return tokenFromReflection(_rOwned[account]);
461     }
462     function transfer(address recipient, uint256 amount) public override returns (bool) {
463         _transfer(_msgSender(), recipient, amount);
464         return true;
465     }
466     function allowance(address owner, address spender) public view override returns (uint256) {
467         return _allowances[owner][spender];
468     }
469     function approve(address spender, uint256 amount) public override returns (bool) {
470         _approve(_msgSender(), spender, amount);
471         return true;
472     }
473     function transferFrom(address sender,address recipient,uint256 amount) public override returns (bool) {
474         _transfer(sender, recipient, amount);
475         _approve(sender,_msgSender(),
476         _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
477         );
478         return true;
479     }
480     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
481         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
482         return true;
483     }
484     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
485         _approve(
486             _msgSender(),
487             spender,
488             _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero")
489         );
490         return true;
491     }
492     function isExcludedFromReward(address account) public view returns (bool) {
493         return _isExcluded[account];
494     }
495     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
496         require(tAmount <= _tTotal, "Amt must be less than supply");
497         if (!deductTransferFee) {
498             (uint256 rAmount, , , , , ) = _getValues(tAmount);
499             return rAmount;
500         } else {
501             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
502             return rTransferAmount;
503         }
504     }
505     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
506         require(rAmount <= _rTotal, "Amt must be less than tot refl");
507         uint256 currentRate = _getRate();
508         return rAmount.div(currentRate);
509     }
510     function _reflectFee(uint256 rFee, uint256 tFee) private {
511         _rTotal = _rTotal.sub(rFee);
512         _tFeeTotal = _tFeeTotal.add(tFee);
513     }
514     function _getValues(uint256 tAmount) private view returns (uint256,uint256,uint256,uint256,uint256,uint256) {
515         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
516         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
517         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
518     }
519     function _getTValues(uint256 tAmount)private view returns (uint256,uint256,uint256) {
520         uint256 tFee = calculateTaxFee(tAmount);
521         uint256 tLiquidity = calculateLiquidityFee(tAmount);
522         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
523         return (tTransferAmount, tFee, tLiquidity);
524     }
525     function _getRValues(uint256 tAmount,uint256 tFee,uint256 tLiquidity,uint256 currentRate) private pure returns (uint256,uint256,uint256) {
526         uint256 rAmount = tAmount.mul(currentRate);
527         uint256 rFee = tFee.mul(currentRate);
528         uint256 rLiquidity = tLiquidity.mul(currentRate);
529         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
530         return (rAmount, rTransferAmount, rFee);
531     }
532     function _getRate() private view returns (uint256) {
533         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
534         return rSupply.div(tSupply);
535     }
536     function _getCurrentSupply() private view returns (uint256, uint256) {
537         uint256 rSupply = _rTotal;
538         uint256 tSupply = _tTotal;
539         for (uint256 i = 0; i < _excluded.length; i++) {
540             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
541             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
542             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
543         }
544         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
545         return (rSupply, tSupply);
546     }
547     function _takeLiquidity(uint256 tLiquidity) private {
548         tokensForMarketingToSwap += tLiquidity * _marTax / _liqDiv;
549 		tokensForLiquidityToSwap += tLiquidity * _liqTax / _liqDiv;
550         tokensForGiveAwayToSwap += tLiquidity * _giveAwayTax / _liqDiv;
551         uint256 currentRate = _getRate();
552         uint256 rLiquidity = tLiquidity.mul(currentRate);
553         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
554         if (_isExcluded[address(this)]) _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
555     }
556     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
557         return _amount.mul(_refTax).div(10**2);
558     }
559     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
560         return _amount.mul(_marTax + _giveAwayTax + _liqTax).div(10**2);
561     }
562     function removeAllFee() private {
563         if (_refTax == 0 && _liqTax == 0 && _marTax == 0 && _giveAwayTax == 0) return;
564 
565         _previousRefTax = _refTax;
566         _previousLiqTax = _liqTax;
567         _previousMarTax = _marTax;
568         _previousGiveAwayTax = _giveAwayTax;
569 
570         _refTax = 0;
571         _liqTax = 0;
572         _marTax = 0;
573         _giveAwayTax = 0;
574     }
575     function restoreAllFee() private {
576         _refTax = _previousRefTax;
577         _liqTax = _previousLiqTax;
578         _marTax = _previousMarTax;
579         _giveAwayTax = _previousGiveAwayTax;
580     }
581     function excludeFromFee(address account) public onlyOwner {
582         _isExcludedFromFee[account] = true;
583     }
584     function isExcludedFromFee(address account) public view returns (bool) {
585         return _isExcludedFromFee[account];
586     }
587     function _approve(address owner,address spender,uint256 amount) private {
588         require(owner != address(0), "ERC20: approve from zero address");
589         require(spender != address(0), "ERC20: approve to zero address");
590         _allowances[owner][spender] = amount;
591         emit Approval(owner, spender, amount);
592     }
593     function _transfer(address from,address to,uint256 amount) private {
594         require(from != address(0), "ERC20: transfer from zero address");
595         require(to != address(0), "ERC20: transfer to zero address");
596         require(amount > 0, "Transfer amount must be greater than zero");
597 		require(!_isBot[from]);
598 		require(!boughtEarly[from] || earlyBuyPenaltyEnd <= block.timestamp, "Snipers can't transfer tokens to sell cheaper DM a Mod.");
599 		if (_maxWalletOn == true && ! _isMaxWalletExclude[to]) {
600             require(balanceOf(to) + amount <= _maxWalletSize, "Max amount of tokens for wallet reached");
601         }
602         if (_buyLimits == true && from == uniV2Pair) {
603 			require(amount <= 500000000000 * 10**18, "Limits are in place, please lower buying amount");
604 		}
605         if(_initLaunch == true) {
606             IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
607             uniV2Router = _uniV2Router;
608             uniV2Pair = IUniswapV2Factory(_uniV2Router.factory()).getPair(address(this), _uniV2Router.WETH());
609             tradingActiveBlock = block.number;
610             earlyBuyPenaltyEnd = block.timestamp + 72 hours;
611             _isMaxWalletExclude[address(uniV2Pair)] = true;
612             _isMaxWalletExclude[address(uniV2Router)] = true;
613             _buyLimits = true;
614             _maxWalletOn = true;
615             _antiSnipe = true;
616             _initLaunch = false;
617         }
618         if(_antiSnipe == true && from != owner() && to != uniV2Pair) {
619             for (uint x = 0; x < 2; x++) {
620                 if(block.number == tradingActiveBlock + x) {
621                     boughtEarly[to] = true;
622                     emit BoughtEarly(to);
623                 }
624                 if(x >= 2){
625                     _antiSnipe = false;
626                 }
627             }
628 		}
629         if (to == uniV2Pair) {
630             _marTax = _sellMarTax;
631             _giveAwayTax = _sellGiveAwayTax;
632             _liqTax = _sellLiqTax;
633             _refTax = _sellRefTax;
634         } else if (from == uniV2Pair) {
635             _marTax = _buyMarTax;
636             _giveAwayTax = _buyGiveAwayTax;
637             _liqTax = _buyLiqTax;
638             _refTax = _buyRefTax;
639         }
640         uint256 contractTokenBalance = balanceOf(address(this));
641         if (!inSwapAndLiquify && to == uniV2Pair && swapAndLiquifyEnabled) {
642             if (contractTokenBalance >= minTokensBeforeSwap) {
643 				swapTokens();
644             }
645         }
646         bool takeFee = true;
647         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
648             takeFee = false;
649         }
650 		if(boughtEarly[from] && earlyBuyPenaltyEnd > block.timestamp){
651                     _liqTax = 0;
652                     _marTax = 95;
653                     _giveAwayTax = 0;
654                     _refTax = 0;
655                 }
656         _tokenTransfer(from, to, amount, takeFee);
657     }
658     function swapETHForTokens(uint256 amount) private {
659         // generate the uniswap pair path of token -> weth
660         address[] memory path = new address[](2);
661         path[0] = uniV2Router.WETH();
662         path[1] = address(this);
663 
664         // make the swap
665         uniV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
666             0, // accept any amount of Tokens
667             path,
668             dead, // Burn address
669             block.timestamp.add(300)
670         );
671     }
672 	function addBot(address _user) public onlyOwner {
673         require(_user != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
674         require(!_isBot[_user]);
675         _isBot[_user] = true;
676     }
677 	function removeBot(address _user) public onlyOwner {
678         require(_isBot[_user]);
679         _isBot[_user] = false;
680     }
681 	function removeSniper(address account) external onlyOwner {
682         boughtEarly[account] = false;
683         emit RemovedSniper(account);
684     }
685 	function swapTokens() private lockTheSwap {
686         uint256 contractBalance = balanceOf(address(this));
687         uint256 totalTokensToSwap = tokensForLiquidityToSwap + tokensForMarketingToSwap + tokensForGiveAwayToSwap;
688         uint256 tokensForLiquidity = tokensForLiquidityToSwap.div(2); //Halve the amount of liquidity tokens
689         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
690         uint256 initialETHBalance = address(this).balance;
691         swapTokensForETH(amountToSwapForETH); 
692         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
693         uint256 ethForMarketing = ethBalance.mul(tokensForMarketingToSwap).div(totalTokensToSwap);
694         uint256 ethForGiveAway = ethBalance.mul(tokensForGiveAwayToSwap).div(totalTokensToSwap);
695         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing).sub(ethForGiveAway);
696         tokensForLiquidityToSwap = 0;
697         tokensForMarketingToSwap = 0;
698         tokensForGiveAwayToSwap = 0;
699         (bool success,) = address(marketingAddress).call{value: ethForMarketing}("");
700         (success,) = address(giveAwayAddress).call{value: ethForGiveAway}("");
701         addLiquidity(tokensForLiquidity, ethForLiquidity);
702         emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
703         //If any eth left over transfer out of contract as to not get stuck
704         if(address(this).balance > 0 * 10**18){
705             (success,) = address(marketingAddress).call{value: address(this).balance}("");
706         }
707     }
708     function swapTokensForETH(uint256 tokenAmount) private {
709         address[] memory path = new address[](2);
710         path[0] = address(this);
711         path[1] = uniV2Router.WETH();
712         _approve(address(this), address(uniV2Router), tokenAmount);
713         uniV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
714             tokenAmount,
715             0, // accept any amount of ETH
716             path,
717             address(this),
718             block.timestamp.add(300)
719         );
720     }
721     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
722         _approve(address(this), address(uniV2Router), tokenAmount);
723         uniV2Router.addLiquidityETH{value: ethAmount}(
724             address(this),
725             tokenAmount,
726             0, // slippage is unavoidable
727             0, // slippage is unavoidable
728             dead,
729             block.timestamp.add(300)
730         );
731     }
732     function setMarketingAddress(address _marketingAddress) external onlyOwner {
733         require(_marketingAddress != address(0));
734         _isExcludedFromFee[marketingAddress] = false;
735         marketingAddress = payable(_marketingAddress);
736         _isExcludedFromFee[marketingAddress] = true;
737         emit UpdatedMarketingAddress(_marketingAddress);
738     }
739     function setGiveAwayAddress(address _giveAwayAddress) public onlyOwner {
740         require(_giveAwayAddress != address(0));
741         giveAwayAddress = payable(_giveAwayAddress);
742         emit UpdatedGiveAwayAddress(_giveAwayAddress);
743     }
744 	function StartLaunchInit() external onlyOwner {
745 		_initLaunch = true;
746 	}
747 	function StopLaunchInit() external onlyOwner {
748 		_initLaunch = false;
749 	}
750     function TaxSwapEnable() external onlyOwner {
751         swapAndLiquifyEnabled = true;
752     }
753     function TaxSwapDisable() external onlyOwner {
754         swapAndLiquifyEnabled = false;
755     }
756     function ResumeLimits() external onlyOwner {
757         _buyLimits = true;
758     }
759     function RemoveLimits() external onlyOwner {
760         _buyLimits = false;
761     }
762     function MaxWalletOn() external onlyOwner {
763         _maxWalletOn = true;
764     }
765     function MaxWalletOff() external onlyOwner {
766         _maxWalletOn = false;
767     }
768     function setBuyF(uint buyMarTax, uint buyGiveAwayTax, uint buyLiqTax, uint buyRefTax) external onlyOwner {
769         _buyMarTax = buyMarTax;
770         _buyGiveAwayTax = buyGiveAwayTax;
771         _buyLiqTax = buyLiqTax;
772         _buyRefTax = buyRefTax;
773     }
774     function setSellF(uint sellMarTax, uint sellGiveAwayTax, uint sellLiqTax, uint sellRefTax) external onlyOwner {
775         _sellMarTax = sellMarTax;
776         _sellGiveAwayTax = sellGiveAwayTax;
777         _sellLiqTax = sellLiqTax;
778         _sellRefTax = sellRefTax;
779     }
780     function startAntiSniper() external onlyOwner {
781         _antiSnipe = true;
782     }
783     function stopAntiSniper() external onlyOwner {
784         _antiSnipe = false;
785     }
786     function HappyHour() external onlyOwner {
787 		_preBuyMarTax = _buyMarTax;
788 		_preBuyGiveAwayTax = _buyGiveAwayTax;
789 		_preBuyLiqTax = _buyLiqTax;
790 		_preBuyRefTax = _buyRefTax;
791 		_preSellMarTax = _sellMarTax;
792 		_preSellGiveAwayTax = _sellGiveAwayTax;
793 		_preSellLiqTax = _sellLiqTax;
794 		_preSellRefTax = _sellRefTax;
795         _buyMarTax = 0;
796         _buyGiveAwayTax = 0;
797         _buyLiqTax = 0;
798         _buyRefTax = 0;
799         _sellMarTax = 0;
800         _sellGiveAwayTax = 0;
801         _sellLiqTax = 0;
802         _sellRefTax = 0;
803 
804     }
805     function HappyHourOff() external onlyOwner {
806 		_buyMarTax = _preBuyMarTax;
807 		_buyGiveAwayTax = _preBuyGiveAwayTax;
808 		_buyLiqTax = _preBuyLiqTax;
809 		_buyRefTax = _preBuyRefTax;
810 		_sellMarTax = _preSellMarTax;
811 		_sellGiveAwayTax = _preSellGiveAwayTax;
812 		_sellLiqTax = _preSellLiqTax;
813 		_sellRefTax = _preSellRefTax;
814 	}
815     function _tokenTransfer(address sender,address recipient,uint256 amount,bool takeFee) private {
816         if (!takeFee) removeAllFee();
817         if (_isExcluded[sender] && !_isExcluded[recipient]) {
818             _transferFromExcluded(sender, recipient, amount);
819         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
820             _transferToExcluded(sender, recipient, amount);
821         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
822             _transferStandard(sender, recipient, amount);
823         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
824             _transferBothExcluded(sender, recipient, amount);
825         } else {
826             _transferStandard(sender, recipient, amount);
827         }
828         if (!takeFee) restoreAllFee();
829     }
830     function _transferStandard(address sender,address recipient,uint256 tAmount) private {
831         (
832             uint256 rAmount,
833             uint256 rTransferAmount,
834             uint256 rFee,
835             uint256 tTransferAmount,
836             uint256 tFee,
837             uint256 tLiquidity
838         ) = _getValues(tAmount);
839         _rOwned[sender] = _rOwned[sender].sub(rAmount);
840         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
841         _takeLiquidity(tLiquidity);
842         _reflectFee(rFee, tFee);
843         emit Transfer(sender, recipient, tTransferAmount);
844     }
845     function _transferToExcluded(address sender,address recipient,uint256 tAmount) private {
846         (
847             uint256 rAmount,
848             uint256 rTransferAmount,
849             uint256 rFee,
850             uint256 tTransferAmount,
851             uint256 tFee,
852             uint256 tLiquidity
853         ) = _getValues(tAmount);
854         _rOwned[sender] = _rOwned[sender].sub(rAmount);
855         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
856         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
857         _takeLiquidity(tLiquidity);
858         _reflectFee(rFee, tFee);
859         emit Transfer(sender, recipient, tTransferAmount);
860     }
861     function _transferFromExcluded(address sender,address recipient,uint256 tAmount) private {
862         (
863             uint256 rAmount,
864             uint256 rTransferAmount,
865             uint256 rFee,
866             uint256 tTransferAmount,
867             uint256 tFee,
868             uint256 tLiquidity
869         ) = _getValues(tAmount);
870         _tOwned[sender] = _tOwned[sender].sub(tAmount);
871         _rOwned[sender] = _rOwned[sender].sub(rAmount);
872         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
873         _takeLiquidity(tLiquidity);
874         _reflectFee(rFee, tFee);
875         emit Transfer(sender, recipient, tTransferAmount);
876     }
877     function _transferBothExcluded(address sender,address recipient,uint256 tAmount) private {
878         (
879             uint256 rAmount,
880             uint256 rTransferAmount,
881             uint256 rFee,
882             uint256 tTransferAmount,
883             uint256 tFee,
884             uint256 tLiquidity
885         ) = _getValues(tAmount);
886         _tOwned[sender] = _tOwned[sender].sub(tAmount);
887         _rOwned[sender] = _rOwned[sender].sub(rAmount);
888         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
889         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
890         _takeLiquidity(tLiquidity);
891         _reflectFee(rFee, tFee);
892         emit Transfer(sender, recipient, tTransferAmount);
893     }
894     function _tokenTransferNoFee(address sender,address recipient,uint256 amount) private {
895         _rOwned[sender] = _rOwned[sender].sub(amount);
896         _rOwned[recipient] = _rOwned[recipient].add(amount);
897 
898         if (_isExcluded[sender]) {
899             _tOwned[sender] = _tOwned[sender].sub(amount);
900         }
901         if (_isExcluded[recipient]) {
902             _tOwned[recipient] = _tOwned[recipient].add(amount);
903         }
904         emit Transfer(sender, recipient, amount);
905     }
906 }