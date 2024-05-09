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
33 library SafeMath {
34     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             uint256 c = a + b;
37             if (c < a) return (false, 0);
38             return (true, c);
39         }
40     }
41     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {
43             if (b > a) return (false, 0);
44             return (true, a - b);
45         }
46     }
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50             // benefit is lost if 'b' is also tested.
51             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
52             if (a == 0) return (true, 0);
53             uint256 c = a * b;
54             if (c / a != b) return (false, 0);
55             return (true, c);
56         }
57     }
58     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             if (b == 0) return (false, 0);
61             return (true, a / b);
62         }
63     }
64     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         unchecked {
66             if (b == 0) return (false, 0);
67             return (true, a % b);
68         }
69     }
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a + b;
72     }
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a - b;
75     }
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a * b;
78     }
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return a / b;
81     }
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         return a % b;
84     }
85     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         unchecked {
87             require(b <= a, errorMessage);
88             return a - b;
89         }
90     }
91     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         unchecked {
93             require(b > 0, errorMessage);
94             return a / b;
95         }
96     }
97     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
98         unchecked {
99             require(b > 0, errorMessage);
100             return a % b;
101         }
102     }
103 }
104 interface IERC20 {
105     event Approval(address indexed owner, address indexed spender, uint value);
106     event Transfer(address indexed from, address indexed to, uint value);
107     function name() external view returns (string memory);
108     function symbol() external view returns (string memory);
109     function decimals() external view returns (uint8);
110     function totalSupply() external view returns (uint);
111     function balanceOf(address owner) external view returns (uint);
112     function allowance(address owner, address spender) external view returns (uint);
113     function approve(address spender, uint value) external returns (bool);
114     function transfer(address to, uint value) external returns (bool);
115     function transferFrom(address from, address to, uint value) external returns (bool);
116 }
117 interface IUniswapV2Router01 {
118     function factory() external pure returns (address);
119     function WETH() external pure returns (address);
120     function addLiquidity(
121         address tokenA,
122         address tokenB,
123         uint amountADesired,
124         uint amountBDesired,
125         uint amountAMin,
126         uint amountBMin,
127         address to,
128         uint deadline
129     ) external returns (uint amountA, uint amountB, uint liquidity);
130     function addLiquidityETH(
131         address token,
132         uint amountTokenDesired,
133         uint amountTokenMin,
134         uint amountETHMin,
135         address to,
136         uint deadline
137     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
138     function removeLiquidity(
139         address tokenA,
140         address tokenB,
141         uint liquidity,
142         uint amountAMin,
143         uint amountBMin,
144         address to,
145         uint deadline
146     ) external returns (uint amountA, uint amountB);
147     function removeLiquidityETH(
148         address token,
149         uint liquidity,
150         uint amountTokenMin,
151         uint amountETHMin,
152         address to,
153         uint deadline
154     ) external returns (uint amountToken, uint amountETH);
155     function removeLiquidityWithPermit(
156         address tokenA,
157         address tokenB,
158         uint liquidity,
159         uint amountAMin,
160         uint amountBMin,
161         address to,
162         uint deadline,
163         bool approveMax, uint8 v, bytes32 r, bytes32 s
164     ) external returns (uint amountA, uint amountB);
165     function removeLiquidityETHWithPermit(
166         address token,
167         uint liquidity,
168         uint amountTokenMin,
169         uint amountETHMin,
170         address to,
171         uint deadline,
172         bool approveMax, uint8 v, bytes32 r, bytes32 s
173     ) external returns (uint amountToken, uint amountETH);
174     function swapExactTokensForTokens(
175         uint amountIn,
176         uint amountOutMin,
177         address[] calldata path,
178         address to,
179         uint deadline
180     ) external returns (uint[] memory amounts);
181     function swapTokensForExactTokens(
182         uint amountOut,
183         uint amountInMax,
184         address[] calldata path,
185         address to,
186         uint deadline
187     ) external returns (uint[] memory amounts);
188     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
189         external
190         payable
191         returns (uint[] memory amounts);
192     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
193         external
194         returns (uint[] memory amounts);
195     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
196         external
197         returns (uint[] memory amounts);
198     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
199         external
200         payable
201         returns (uint[] memory amounts);
202     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
203     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
204     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
205     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
206     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
207 }
208 interface IUniswapV2Router02 {
209     function factory() external pure returns (address);
210     function WETH() external pure returns (address);
211     function swapExactTokensForETHSupportingFeeOnTransferTokens(
212         uint amountIn,
213         uint amountOutMin,
214         address[] calldata path,
215         address to,
216         uint deadline
217     ) external;
218     function addLiquidity(
219         address tokenA,
220         address tokenB,
221         uint amountADesired,
222         uint amountBDesired,
223         uint amountAMin,
224         uint amountBMin,
225         address to,
226         uint deadline
227     ) external returns (uint amountA, uint amountB, uint liquidity);
228     function addLiquidityETH(
229         address token,
230         uint amountTokenDesired,
231         uint amountTokenMin,
232         uint amountETHMin,
233         address to,
234         uint deadline
235     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
236     function removeLiquidity(
237         address tokenA,
238         address tokenB,
239         uint liquidity,
240         uint amountAMin,
241         uint amountBMin,
242         address to,
243         uint deadline
244     ) external returns (uint amountA, uint amountB);
245     function removeLiquidityETH(
246         address token,
247         uint liquidity,
248         uint amountTokenMin,
249         uint amountETHMin,
250         address to,
251         uint deadline
252     ) external returns (uint amountToken, uint amountETH);
253     function removeLiquidityWithPermit(
254         address tokenA,
255         address tokenB,
256         uint liquidity,
257         uint amountAMin,
258         uint amountBMin,
259         address to,
260         uint deadline,
261         bool approveMax, uint8 v, bytes32 r, bytes32 s
262     ) external returns (uint amountA, uint amountB);
263     function removeLiquidityETHWithPermit(
264         address token,
265         uint liquidity,
266         uint amountTokenMin,
267         uint amountETHMin,
268         address to,
269         uint deadline,
270         bool approveMax, uint8 v, bytes32 r, bytes32 s
271     ) external returns (uint amountToken, uint amountETH);
272     function swapExactTokensForTokens(
273         uint amountIn,
274         uint amountOutMin,
275         address[] calldata path,
276         address to,
277         uint deadline
278     ) external returns (uint[] memory amounts);
279     function swapTokensForExactTokens(
280         uint amountOut,
281         uint amountInMax,
282         address[] calldata path,
283         address to,
284         uint deadline
285     ) external returns (uint[] memory amounts);
286     function swapExactETHForTokensSupportingFeeOnTransferTokens(
287         uint amountOutMin,
288         address[] calldata path,
289         address to,
290         uint deadline
291     ) external payable;
292     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
293         external
294         payable
295         returns (uint[] memory amounts);
296     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
297         external
298         returns (uint[] memory amounts);
299     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
300         external
301         returns (uint[] memory amounts);
302     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
303         external
304         payable
305         returns (uint[] memory amounts);
306     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
307     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
308     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
309     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
310     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
311 }
312 interface IUniswapV2Factory {
313     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
314     function feeTo() external view returns (address);
315     function feeToSetter() external view returns (address);
316     function getPair(address tokenA, address tokenB) external view returns (address pair);
317     function allPairs(uint) external view returns (address pair);
318     function allPairsLength() external view returns (uint);
319     function createPair(address tokenA, address tokenB) external returns (address pair);
320     function setFeeTo(address) external;
321     function setFeeToSetter(address) external;
322 }
323 library Address {
324     function isContract(address account) internal view returns (bool) {
325         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
326         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
327         // for accounts without code, i.e. `keccak256('')`
328         bytes32 codehash;
329         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
330         // solhint-disable-next-line no-inline-assembly
331         assembly {
332             codehash := extcodehash(account)
333         }
334         return (codehash != accountHash && codehash != 0x0);
335     }
336     function sendValue(address payable recipient, uint256 amount) internal {
337         require(
338             address(this).balance >= amount,
339             "Address: insufficient balance"
340         );
341 
342         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
343         (bool success, ) = recipient.call{value: amount}("");
344         require(
345             success,
346             "Address: unable to send value, recipient may have reverted"
347         );
348     }
349     function functionCall(address target, bytes memory data)
350         internal
351         returns (bytes memory)
352     {
353         return functionCall(target, data, "Address: low-level call failed");
354     }
355     function functionCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         return _functionCallWithValue(target, data, 0, errorMessage);
361     }
362     function functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 value
366     ) internal returns (bytes memory) {
367         return
368             functionCallWithValue(
369                 target,
370                 data,
371                 value,
372                 "Address: low-level call with value failed"
373             );
374     }
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(
382             address(this).balance >= value,
383             "Address: insufficient balance for call"
384         );
385         return _functionCallWithValue(target, data, value, errorMessage);
386     }
387     function _functionCallWithValue(
388         address target,
389         bytes memory data,
390         uint256 weiValue,
391         string memory errorMessage
392     ) private returns (bytes memory) {
393         require(isContract(target), "Address: call to non-contract");
394         (bool success, bytes memory returndata) = target.call{value: weiValue}(
395             data
396         );
397         if (success) {
398             return returndata;
399         } else {
400             if (returndata.length > 0) {
401                 assembly {
402                     let returndata_size := mload(returndata)
403                     revert(add(32, returndata), returndata_size)
404                 }
405             } else {
406                 revert(errorMessage);
407             }
408         }
409     }
410 }
411 contract DAIKOKU is Context, ERC20Ownable, IERC20 {
412     using SafeMath for uint256;
413     using Address for address;
414     string private constant _name = "DAIKOKU";
415     string private constant _symbol = "DAIKOKU";
416     uint8 private constant _decimal = 18;
417     mapping(address => uint256) private _rOwned;
418     mapping(address => uint256) private _tOwned;
419     mapping(address => mapping(address => uint256)) private _allowances;
420     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily
421     mapping(address => bool) private _isExcludedFromFee;
422     mapping(address => bool) private _isExcluded;
423     mapping(address => bool) private _isMaxWalletExclude;
424     mapping (address => bool) private _isExcludedMaxTransactionAmount;
425     mapping (address => bool) public isBot;
426 	mapping(address => bool) public isBoughtEarly;
427     address payable private MWaddress;
428     address payable private LWaddress;
429     address payable private DWaddress;
430     address dead = address(0xdead);
431     IUniswapV2Router02 public uniV2Router;
432     address public uniV2Pair;
433     address[] private _excluded;
434     uint256 private constant MAX = ~uint256(0);
435     uint256 private constant _tTotal = 1e14 * 10**18;
436     uint256 private _rTotal = (MAX - (MAX % _tTotal));
437     uint256 private _tFeeTotal;
438     uint256 private _maxWallet;
439     uint256 private taxTokensMin;
440     uint256 private LiqTokens;
441     uint256 private MwTokens;
442     uint256 private LbTokens;
443     uint256 private constant BUY = 1;
444     uint256 private constant SELL = 2;
445     uint256 private constant TRANSFER = 3;
446     uint256 private buyOrSellSwitch;
447     uint256 private gasPriceLimit = 498 * 1 gwei;
448     uint256 private _reflectionsTax;
449     uint256 private _previousReflectionsTax = _reflectionsTax;
450     uint256 private _liquidityTax;
451     uint256 private _previousLiquidityTax = _liquidityTax;
452 
453     uint256 public buyReflectionsTax = 0;
454     uint256 public buyMarketingTax = 5;
455     uint256 public buyLandTax = 5;
456     uint256 public buyLiquidityTax = 3;
457 
458     uint256 public sellReflectionsTax = 0;
459     uint256 public sellMarketingTax = 5;
460     uint256 public sellLandTax = 5;
461     uint256 public sellLiquidityTax = 3;
462 
463     uint256 public tradingActiveBlock = 0;
464     uint256 public earlyBuyPenaltyStart;
465     uint256 public earlyBuyPenaltyEnd;
466     uint256 public maxTransactionAmount;
467     bool public transferDelayEnabled = false;
468     bool public limitsInEffect = false;
469     bool public gasLimitActive = false;
470     bool private _addLiq = true;
471     bool public maxWalletOn = false;
472     bool inSwapAndLiquify;
473     bool public swapAndLiquifyEnabled = false;
474     event SwapAndLiquifyEnabledUpdated(bool enabled);
475     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
476     event SwapETHForTokens(uint256 amountIn, address[] path);
477     event SwapTokensForETH(uint256 amountIn, address[] path);
478     event ExcludeFromFee(address excludedAddress);
479     event IncludeInFee(address includedAddress);
480     event OwnerForcedSwapBack(uint256 timestamp);
481     event BoughtEarly(address indexed sniper);
482     event RemovedSniper(address indexed notsnipersupposedly);
483     modifier lockTheSwap() {
484         inSwapAndLiquify = true;
485         _;
486         inSwapAndLiquify = false;
487         
488     }
489     constructor() payable {
490         _rOwned[_msgSender()] = _rTotal;
491         maxTransactionAmount = _tTotal / 100; 
492         _maxWallet = _tTotal * 3 / 100;
493         taxTokensMin = _tTotal * 5 / 10000;
494         MWaddress = payable(0xb97cD9cAdB2398f47b505E6C0F123eadb6B624ea); 
495         LWaddress = payable(0x0b41b33048AeF20D978cd1Fb587157fcdD4Df1a1);
496         DWaddress = payable(0x9Fa9a8d943eA6F0db1D8d84610FBB4956224f3B0);
497         _isExcluded[dead] = true;
498         _isExcludedFromFee[_msgSender()] = true;
499         _isExcludedFromFee[address(this)] = true;
500         _isExcludedFromFee[MWaddress] = true;
501         _isExcludedFromFee[LWaddress] = true;
502         _isExcludedFromFee[DWaddress] = true;
503         _isMaxWalletExclude[address(this)] = true;
504         _isMaxWalletExclude[_msgSender()] = true;
505         _isMaxWalletExclude[dead] = true;
506         _isMaxWalletExclude[MWaddress] = true;
507         _isMaxWalletExclude[LWaddress] = true;
508         _isMaxWalletExclude[DWaddress] = true;
509         _isExcludedMaxTransactionAmount[_msgSender()] = true;
510         _isExcludedMaxTransactionAmount[address(this)] = true;
511         _isExcludedMaxTransactionAmount[dead] = true;
512         _isExcludedMaxTransactionAmount[MWaddress] = true;
513         _isExcludedMaxTransactionAmount[LWaddress] = true;
514         _isExcludedMaxTransactionAmount[DWaddress] = true;
515         addBot(0x41B0320bEb1563A048e2431c8C1cC155A0DFA967);
516         addBot(0x91B305F0890Fd0534B66D8d479da6529C35A3eeC);
517         addBot(0x7F5622afb5CEfbA39f96CA3b2814eCF0E383AAA4);
518         addBot(0xfcf6a3d7eb8c62a5256a020e48f153c6D5Dd6909);
519         addBot(0x74BC89a9e831ab5f33b90607Dd9eB5E01452A064);
520         addBot(0x1F53592C3aA6b827C64C4a3174523182c52Ece84);
521         addBot(0x460545C01c4246194C2e511F166D84bbC8a07608);
522         addBot(0x2E5d67a1d15ccCF65152B3A8ec5315E73461fBcd);
523         addBot(0xb5aF12B837aAf602298B3385640F61a0fF0F4E0d);
524         addBot(0xEd3e444A30Bd440FBab5933dCCC652959DfCB5Ba);
525         addBot(0xEC366bbA6266ac8960198075B14FC1D38ea7de88);
526         addBot(0x10Bf6836600D7cFE1c06b145A8Ac774F8Ba91FDD);
527         addBot(0x44ae54e28d082C98D53eF5593CE54bB231e565E7);
528         addBot(0xa3e820006F8553d5AC9F64A2d2B581501eE24FcF);
529 		addBot(0x2228476AC5242e38d5864068B8c6aB61d6bA2222);
530 		addBot(0xcC7e3c4a8208172CA4c4aB8E1b8B4AE775Ebd5a8);
531 		addBot(0x5b3EE79BbBDb5B032eEAA65C689C119748a7192A);
532 		addBot(0x4ddA45d3E9BF453dc95fcD7c783Fe6ff9192d1BA);
533 
534         emit Transfer(address(0), _msgSender(), _tTotal);
535     }
536     receive() external payable {}
537     function name() public pure override returns (string memory) {
538         return _name;
539     }
540     function symbol() public pure override returns (string memory) {
541         return _symbol;
542     }
543     function decimals() public pure override returns (uint8) {
544         return _decimal;
545     }
546     function totalSupply() public pure override returns (uint256) {
547         return _tTotal;
548     }
549     function balanceOf(address account) public view override returns (uint256) {
550         if (_isExcluded[account]) return _tOwned[account];
551         return tokenFromReflection(_rOwned[account]);
552     }
553     function transfer(address recipient, uint256 amount) public override returns (bool) {
554         _transfer(_msgSender(), recipient, amount);
555         return true;
556     }
557     function allowance(address owner, address spender) public view override returns (uint256) {
558         return _allowances[owner][spender];
559     }
560     function approve(address spender, uint256 amount) public override returns (bool) {
561         _approve(_msgSender(), spender, amount);
562         return true;
563     }
564     function transferFrom(address sender,address recipient,uint256 amount) public override returns (bool) {
565         _transfer(sender, recipient, amount);
566         _approve(sender,_msgSender(),
567         _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
568         );
569         return true;
570     }
571     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
572         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
573         return true;
574     }
575     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
576         _approve(
577             _msgSender(),
578             spender,
579             _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero")
580         );
581         return true;
582     }
583     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
584         require(tAmount <= _tTotal, "Amt must be less than supply");
585         if (!deductTransferFee) {
586             (uint256 rAmount, , , , , ) = _getValues(tAmount);
587             return rAmount;
588         } else {
589             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
590             return rTransferAmount;
591         }
592     }
593     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
594         require(rAmount <= _rTotal, "Amt must be less than tot refl");
595         uint256 currentRate = _getRate();
596         return rAmount.div(currentRate);
597     }
598     function _reflectFee(uint256 rFee, uint256 tFee) private {
599         _rTotal = _rTotal.sub(rFee);
600         _tFeeTotal = _tFeeTotal.add(tFee);
601     }
602     function _getValues(uint256 tAmount) private view returns (uint256,uint256,uint256,uint256,uint256,uint256) {
603         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
604         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
605         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
606     }
607     function _getTValues(uint256 tAmount)private view returns (uint256,uint256,uint256) {
608         uint256 tFee = calculateTaxFee(tAmount);
609         uint256 tLiquidity = calculateLiquidityFee(tAmount);
610         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
611         return (tTransferAmount, tFee, tLiquidity);
612     }
613     function _getRValues(uint256 tAmount,uint256 tFee,uint256 tLiquidity,uint256 currentRate) private pure returns (uint256,uint256,uint256) {
614         uint256 rAmount = tAmount.mul(currentRate);
615         uint256 rFee = tFee.mul(currentRate);
616         uint256 rLiquidity = tLiquidity.mul(currentRate);
617         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
618         return (rAmount, rTransferAmount, rFee);
619     }
620     function _getRate() private view returns (uint256) {
621         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
622         return rSupply.div(tSupply);
623     }
624     function _getCurrentSupply() private view returns (uint256, uint256) {
625         uint256 rSupply = _rTotal;
626         uint256 tSupply = _tTotal;
627         for (uint256 i = 0; i < _excluded.length; i++) {
628             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
629             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
630             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
631         }
632         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
633         return (rSupply, tSupply);
634     }
635     function _takeLiquidity(uint256 tLiquidity) private {
636         if(buyOrSellSwitch == BUY){
637             MwTokens += tLiquidity * buyMarketingTax / _liquidityTax;
638             LbTokens += tLiquidity * buyLandTax / _liquidityTax;
639             LiqTokens += tLiquidity * buyLiquidityTax / _liquidityTax;
640         } else if(buyOrSellSwitch == SELL){
641             MwTokens += tLiquidity * sellMarketingTax / _liquidityTax;
642             LbTokens += tLiquidity * sellLandTax / _liquidityTax;
643             LiqTokens += tLiquidity * sellLiquidityTax / _liquidityTax;
644         }
645         uint256 currentRate = _getRate();
646         uint256 rLiquidity = tLiquidity.mul(currentRate);
647         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
648         if (_isExcluded[address(this)])
649             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
650     }
651     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
652         return _amount.mul(_reflectionsTax).div(10**2);
653     }
654     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
655         return _amount.mul(_liquidityTax).div(10**2);
656     }
657     function _approve(address owner,address spender,uint256 amount) private {
658         require(owner != address(0), "ERC20: approve from zero address");
659         require(spender != address(0), "ERC20: approve to zero address");
660         _allowances[owner][spender] = amount;
661         emit Approval(owner, spender, amount);
662     }
663     function _transfer(address from, address to, uint256 amount) private {
664         require(from != address(0), "ERC20: transfer from the zero address");
665         require(to != address(0), "ERC20: transfer to the zero address");
666         require(amount > 0, "Transfer amount must be greater than zero");
667         require(!isBot[from]);
668         if (maxWalletOn == true && ! _isMaxWalletExclude[to]) {
669             require(balanceOf(to) + amount <= _maxWallet, "Max amount of tokens for wallet reached");
670         }
671         if(_addLiq == true) {
672             IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
673             uniV2Router = _uniV2Router;
674             uniV2Pair = IUniswapV2Factory(_uniV2Router.factory()).getPair(address(this), _uniV2Router.WETH());
675             tradingActiveBlock = block.number;
676             earlyBuyPenaltyStart = block.timestamp;
677             earlyBuyPenaltyEnd = block.timestamp + 72 hours;
678             _isMaxWalletExclude[address(uniV2Pair)] = true;
679             _isMaxWalletExclude[address(uniV2Router)] = true;
680             _isExcludedMaxTransactionAmount[address(uniV2Router)] = true;
681             _isExcludedMaxTransactionAmount[address(uniV2Pair)] = true;
682             limitsInEffect = true;
683             maxWalletOn = true;
684             swapAndLiquifyEnabled = true;
685             transferDelayEnabled = true;
686             _addLiq = false;
687         }
688         if(limitsInEffect){
689             if (from != owner() && to != owner() && to != address(0) && to != dead && !inSwapAndLiquify) {
690                 if(from != owner() && to != uniV2Pair) {
691                     for (uint x = 0; x < 2; x++) {
692                     if(block.number == tradingActiveBlock + x) {
693                         isBoughtEarly[to] = true;
694                         emit BoughtEarly(to);
695                         }
696                     }
697                 }
698                 if (gasLimitActive && from == uniV2Pair) {
699                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
700                 }
701                 if (transferDelayEnabled){
702                     if (to != owner() && to != address(uniV2Router) && to != address(uniV2Pair)){
703                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
704                         _holderLastTransferTimestamp[tx.origin] = block.number;
705                     }
706                 }
707                 if (from == uniV2Pair && !_isExcludedMaxTransactionAmount[to]) {
708                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
709                 }
710             }
711         }
712         uint256 totalTokensToSwap = LiqTokens.add(MwTokens).add(LbTokens);
713         uint256 contractTokenBalance = balanceOf(address(this));
714         bool overMinimumTokenBalance = contractTokenBalance >= taxTokensMin;
715         if (!inSwapAndLiquify && swapAndLiquifyEnabled && balanceOf(uniV2Pair) > 0 && totalTokensToSwap > 0 && !_isExcludedFromFee[to] && !_isExcludedFromFee[from] && to == uniV2Pair && overMinimumTokenBalance) {
716             swapTokens();
717             }
718         bool takeFee = true;
719         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
720             takeFee = false;
721             buyOrSellSwitch = TRANSFER;
722         } else {
723             if (from == uniV2Pair) {
724                 removeAllFee();
725                 _reflectionsTax = buyReflectionsTax;
726                 _liquidityTax = buyMarketingTax + buyLandTax + buyLiquidityTax;
727                 buyOrSellSwitch = BUY;
728             } 
729             else if (to == uniV2Pair) {
730                 removeAllFee();
731                 _reflectionsTax = sellReflectionsTax;
732                 _liquidityTax = sellMarketingTax + sellLandTax + sellLiquidityTax;
733                 buyOrSellSwitch = SELL;
734                 if(isBoughtEarly[from] && earlyBuyPenaltyEnd > block.timestamp){
735                     _liquidityTax = _liquidityTax * 2;
736                 }
737             } else {
738                 require(!isBoughtEarly[from], "Snipers can't transfer tokens to sell cheaper.  DM a Mod.");
739                 removeAllFee();
740                 buyOrSellSwitch = TRANSFER;
741             }
742         }
743         _tokenTransfer(from, to, amount, takeFee);
744     }
745     function swapTokens() private lockTheSwap {
746         uint256 contractBalance = balanceOf(address(this));
747         uint256 totalTokensToSwap = MwTokens + LbTokens + LiqTokens;
748         uint256 tokensForLiquidity = LiqTokens.div(2);
749         uint256 amountToSwapForETH = contractBalance.sub(tokensForLiquidity);
750         uint256 initialETHBalance = address(this).balance;
751         swapTokensForETH(amountToSwapForETH); 
752         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
753         uint256 ethForMarketing = ethBalance.mul(MwTokens).div(totalTokensToSwap);
754         uint256 ethForMetaLand = ethBalance.mul(LbTokens).div(totalTokensToSwap);
755         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing).sub(ethForMetaLand);
756         MwTokens = 0;
757         LbTokens = 0;
758         LiqTokens = 0;
759         (bool success,) = address(MWaddress).call{value: ethForMarketing}("");
760         (success,) = address(LWaddress).call{value: ethForMetaLand}("");
761         addLiquidity(tokensForLiquidity, ethForLiquidity);
762         if(address(this).balance > 5 * 10**17){
763             (success,) = address(DWaddress).call{value: address(this).balance}("");
764         }
765     }
766     function swapTokensForETH(uint256 tokenAmount) private {
767         address[] memory path = new address[](2);
768         path[0] = address(this);
769         path[1] = uniV2Router.WETH();
770         _approve(address(this), address(uniV2Router), tokenAmount);
771         uniV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
772             tokenAmount,
773             0, // accept any amount of ETH
774             path,
775             address(this),
776             block.timestamp
777         );
778     }
779     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
780         _approve(address(this), address(uniV2Router), tokenAmount);
781         uniV2Router.addLiquidityETH{value: ethAmount}(
782             address(this),
783             tokenAmount,
784             0, // slippage is unavoidable
785             0, // slippage is unavoidable
786             dead,
787             block.timestamp
788         );
789     }
790     function removeAllFee() private {
791         if (_reflectionsTax == 0 && _liquidityTax == 0) return;
792 
793         _previousReflectionsTax = _reflectionsTax;
794         _previousLiquidityTax = _liquidityTax;
795 
796         _reflectionsTax = 0;
797         _liquidityTax = 0;
798     }
799     function restoreAllFee() private {
800         _reflectionsTax = _previousReflectionsTax;
801         _liquidityTax = _previousLiquidityTax;
802     }
803     function excludeFromFee(address account) external onlyOwner {
804         _isExcludedFromFee[account] = true;
805     }
806     function includeInFee(address account) external onlyOwner {
807         _isExcludedFromFee[account] = false;
808     }
809     function isExcludedFromFee(address account) public view returns (bool) {
810         return _isExcludedFromFee[account];
811     }
812     function excludeFromMaxWallet(address account) external onlyOwner {
813         _isMaxWalletExclude[account] = true;
814     }
815     function includeInMaxWallet(address account) external onlyOwner {
816         _isMaxWalletExclude[account] = false;
817     }
818     function isExcludedFromMaxWallet(address account) public view returns (bool) {
819         return _isMaxWalletExclude[account];
820     }
821     function excludeFromMaxTransaction(address account) external onlyOwner {
822         _isExcludedMaxTransactionAmount[account] = true;
823     }
824     function includeInMaxTransaction(address account) external onlyOwner {
825         _isExcludedMaxTransactionAmount[account] = false;
826     }
827     function isExcludedFromMaxTransaction(address account) public view returns (bool) {
828         return _isExcludedMaxTransactionAmount[account];
829     }
830     function excludeFromReward(address account) external onlyOwner {
831         _isExcluded[account] = true;
832     }
833     function includeInReward(address account) external onlyOwner {
834         _isExcluded[account] = false;
835     }
836     function isExcludedFromReward(address account) public view returns (bool) {
837         return _isExcluded[account];
838     }
839     function addBot(address _user) public onlyOwner {
840         require(_user != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
841         require(!isBot[_user]);
842         isBot[_user] = true;
843     }
844 	function removeBot(address _user) public onlyOwner {
845         require(isBot[_user]);
846         isBot[_user] = false;
847     }
848 	function removeSniper(address account) external onlyOwner {
849         isBoughtEarly[account] = false;
850     }
851     function setGasPriceLimit(uint256 gas) external onlyOwner {
852         require(gas >= 200);
853         gasPriceLimit = gas * 1 gwei;
854     }
855     function enableLimits() external onlyOwner {
856         limitsInEffect = true;
857         transferDelayEnabled = true;
858     }
859     function disableLimits() external onlyOwner {
860         limitsInEffect = false;
861         transferDelayEnabled = false;
862     }
863     function StartLiqAdd() external onlyOwner {
864 		_addLiq = true;
865 	}
866 	function StopLiqAdd() external onlyOwner {
867 		_addLiq = false;
868 	}
869     function TaxSwapEnable() external onlyOwner {
870         swapAndLiquifyEnabled = true;
871     }
872     function TaxSwapDisable() external onlyOwner {
873         swapAndLiquifyEnabled = false;
874     }
875     function enableTransferDelay() external onlyOwner {
876         transferDelayEnabled = true;
877     }
878     function disableTransferDelay() external onlyOwner {
879         transferDelayEnabled = false;
880     }
881     function enableGasLimit() external onlyOwner {
882         gasLimitActive = true;
883     }
884     function disableGasLimit() external onlyOwner {
885         gasLimitActive = false;
886     }
887     function enableMaxWallet() external onlyOwner {
888         maxWalletOn = true;
889     }
890     function disableMaxWallet() external onlyOwner {
891         maxWalletOn = false;
892     }
893     function setBuyTax(uint256 _buyLiquidityTax, uint256 _buyReflectionsTax, uint256 _buyMarketingTax, uint256 _buyLandTax) external onlyOwner {
894         buyReflectionsTax = _buyReflectionsTax;
895         buyMarketingTax = _buyMarketingTax;
896         buyLandTax = _buyLandTax;
897         buyLiquidityTax = _buyLiquidityTax;
898         require(buyLiquidityTax + buyReflectionsTax + buyMarketingTax + buyLandTax <= 20, "Must keep buy taxes below 20%");
899     }
900     function setSellTax(uint256 _sellLiquidityTax, uint256 _sellReflectionsTax, uint256 _sellMarketingTax, uint256 _sellLandTax) external onlyOwner {
901         sellReflectionsTax = _sellReflectionsTax;
902         sellMarketingTax = _sellMarketingTax;
903         sellLandTax = _sellLandTax;
904         sellLiquidityTax = _sellLiquidityTax;
905         require(sellLiquidityTax + sellReflectionsTax + sellMarketingTax + sellLandTax <= 20, "Must keep sell taxes below 20%");
906     }
907     function setMarketingAddress(address _marketingAddress) external onlyOwner {
908         require(_marketingAddress != address(0), "address cannot be 0");
909         _isExcludedFromFee[MWaddress] = false;
910         MWaddress = payable(_marketingAddress);
911         _isExcludedFromFee[MWaddress] = true;
912     }
913     function setMetaLandAddress(address _metalandAddress) public onlyOwner {
914         require(_metalandAddress != address(0), "address cannot be 0");
915         LWaddress = payable(_metalandAddress);
916     }
917     function forceSwapBack() external onlyOwner {
918         uint256 contractBalance = balanceOf(address(this));
919         require(contractBalance >= _tTotal * 5 / 10000, "Can only swap back if more than 1% of tokens stuck on contract");
920         swapTokens();
921         emit OwnerForcedSwapBack(block.timestamp);
922     }
923     function withdrawStuckETH() external onlyOwner {
924         bool success;
925         (success,) = address(DWaddress).call{value: address(this).balance}("");
926     }
927     function _tokenTransfer(address sender,address recipient,uint256 amount,bool takeFee) private {
928         if (!takeFee) removeAllFee();
929         if (_isExcluded[sender] && !_isExcluded[recipient]) {
930             _transferFromExcluded(sender, recipient, amount);
931         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
932             _transferToExcluded(sender, recipient, amount);
933         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
934             _transferStandard(sender, recipient, amount);
935         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
936             _transferBothExcluded(sender, recipient, amount);
937         } else {
938             _transferStandard(sender, recipient, amount);
939         }
940         if (!takeFee) restoreAllFee();
941     }
942     function _transferStandard(address sender,address recipient,uint256 tAmount) private {
943         (
944             uint256 rAmount,
945             uint256 rTransferAmount,
946             uint256 rFee,
947             uint256 tTransferAmount,
948             uint256 tFee,
949             uint256 tLiquidity
950         ) = _getValues(tAmount);
951         _rOwned[sender] = _rOwned[sender].sub(rAmount);
952         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
953         _takeLiquidity(tLiquidity);
954         _reflectFee(rFee, tFee);
955         emit Transfer(sender, recipient, tTransferAmount);
956     }
957     function _transferToExcluded(address sender,address recipient,uint256 tAmount) private {
958         (
959             uint256 rAmount,
960             uint256 rTransferAmount,
961             uint256 rFee,
962             uint256 tTransferAmount,
963             uint256 tFee,
964             uint256 tLiquidity
965         ) = _getValues(tAmount);
966         _rOwned[sender] = _rOwned[sender].sub(rAmount);
967         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
968         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
969         _takeLiquidity(tLiquidity);
970         _reflectFee(rFee, tFee);
971         emit Transfer(sender, recipient, tTransferAmount);
972     }
973     function _transferFromExcluded(address sender,address recipient,uint256 tAmount) private {
974         (
975             uint256 rAmount,
976             uint256 rTransferAmount,
977             uint256 rFee,
978             uint256 tTransferAmount,
979             uint256 tFee,
980             uint256 tLiquidity
981         ) = _getValues(tAmount);
982         _tOwned[sender] = _tOwned[sender].sub(tAmount);
983         _rOwned[sender] = _rOwned[sender].sub(rAmount);
984         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
985         _takeLiquidity(tLiquidity);
986         _reflectFee(rFee, tFee);
987         emit Transfer(sender, recipient, tTransferAmount);
988     }
989     function _transferBothExcluded(address sender,address recipient,uint256 tAmount) private {
990         (
991             uint256 rAmount,
992             uint256 rTransferAmount,
993             uint256 rFee,
994             uint256 tTransferAmount,
995             uint256 tFee,
996             uint256 tLiquidity
997         ) = _getValues(tAmount);
998         _tOwned[sender] = _tOwned[sender].sub(tAmount);
999         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1000         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1001         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1002         _takeLiquidity(tLiquidity);
1003         _reflectFee(rFee, tFee);
1004         emit Transfer(sender, recipient, tTransferAmount);
1005     }
1006     function _tokenTransferNoFee(address sender,address recipient,uint256 amount) private {
1007         _rOwned[sender] = _rOwned[sender].sub(amount);
1008         _rOwned[recipient] = _rOwned[recipient].add(amount);
1009 
1010         if (_isExcluded[sender]) {
1011             _tOwned[sender] = _tOwned[sender].sub(amount);
1012         }
1013         if (_isExcluded[recipient]) {
1014             _tOwned[recipient] = _tOwned[recipient].add(amount);
1015         }
1016         emit Transfer(sender, recipient, amount);
1017     }
1018 }