1 /*
2 
3 PayBolt - The future of crypto payments
4 
5 Pay expenses, earn $PAY rewards with your crypto tokens in near-instant time. Start spending your tokens at cafe, restaurant and everywhere.
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.11;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return payable(msg.sender);
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 abstract contract ReentrancyGuard {
25     uint256 private constant _NOT_ENTERED = 1;
26     uint256 private constant _ENTERED = 2;
27 
28     uint256 private _status;
29 
30     constructor() {
31         _status = _NOT_ENTERED;
32     }
33 
34     modifier nonReentrant() {
35         // On the first call to nonReentrant, _notEntered will be true
36         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
37 
38         // Any calls to nonReentrant after this point will fail
39         _status = _ENTERED;
40 
41         _;
42 
43         // By storing the original value once again, a refund is triggered (see
44         // https://eips.ethereum.org/EIPS/eip-2200)
45         _status = _NOT_ENTERED;
46     }
47 }
48 
49 interface IERC20 {
50     function totalSupply() external view returns (uint256);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 library SafeMath {
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         return sub(a, b, "SafeMath: subtraction overflow");
63     }
64 
65     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68 
69         return c;
70     }
71 }
72 
73 library Address {
74 
75     function isContract(address account) internal view returns (bool) {
76         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
77         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
78         // for accounts without code, i.e. `keccak256('')`
79         bytes32 codehash;
80         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
81         // solhint-disable-next-line no-inline-assembly
82         assembly { codehash := extcodehash(account) }
83         return (codehash != accountHash && codehash != 0x0);
84     }
85 
86     function sendValue(address payable recipient, uint256 amount) internal {
87         require(address(this).balance >= amount, "Address: insufficient balance");
88 
89         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
90         (bool success, ) = recipient.call{ value: amount }("");
91         require(success, "Address: unable to send value, recipient may have reverted");
92     }
93 
94     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
95       return functionCall(target, data, "Address: low-level call failed");
96     }
97 
98     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
99         return _functionCallWithValue(target, data, 0, errorMessage);
100     }
101 
102     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
104     }
105 
106     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
107         require(address(this).balance >= value, "Address: insufficient balance for call");
108         return _functionCallWithValue(target, data, value, errorMessage);
109     }
110 
111     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
112         require(isContract(target), "Address: call to non-contract");
113 
114         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
115         if (success) {
116             return returndata;
117         } else {
118             
119             if (returndata.length > 0) {
120                 assembly {
121                     let returndata_size := mload(returndata)
122                     revert(add(32, returndata), returndata_size)
123                 }
124             } else {
125                 revert(errorMessage);
126             }
127         }
128     }
129 }
130 
131 contract Ownable is Context {
132     address private _owner;
133 
134     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
135 
136     constructor () {
137         address msgSender = _msgSender();
138         _owner = msgSender;
139         emit OwnershipTransferred(address(0), msgSender);
140     }
141 
142     function owner() public view returns (address) {
143         return _owner;
144     }   
145     
146     modifier onlyOwner() {
147         require(_owner == _msgSender(), "Ownable: caller is not the owner");
148         _;
149     }
150     
151     function renounceOwnership() public virtual onlyOwner {
152         emit OwnershipTransferred(_owner, address(0));
153         _owner = address(0);
154     }
155 
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         emit OwnershipTransferred(_owner, newOwner);
159         _owner = newOwner;
160     }
161 }
162 
163 interface IUniswapV2Factory {
164     event PairCreated(address indexed token0, address indexed token1, address pair, uint256);
165 
166     function feeTo() external view returns (address);
167     function feeToSetter() external view returns (address);
168 
169     function getPair(address tokenA, address tokenB) external view returns (address pair);
170     function allPairs(uint256) external view returns (address pair);
171     function allPairsLength() external view returns (uint256);
172 
173     function createPair(address tokenA, address tokenB) external returns (address pair);
174 
175     function setFeeTo(address) external;
176     function setFeeToSetter(address) external;
177 }
178 
179 interface IUniswapV2Pair {
180     event Approval(address indexed owner, address indexed spender, uint256 value);
181     event Transfer(address indexed from, address indexed to, uint256 value);
182 
183     function name() external pure returns (string memory);
184     function symbol() external pure returns (string memory);
185     function decimals() external pure returns (uint8);
186     function totalSupply() external view returns (uint256);
187     function balanceOf(address owner) external view returns (uint256);
188     function allowance(address owner, address spender) external view returns (uint256);
189 
190     function approve(address spender, uint256 value) external returns (bool);
191     function transfer(address to, uint256 value) external returns (bool);
192     function transferFrom(address from, address to, uint256 value) external returns (bool);
193 
194     function DOMAIN_SEPARATOR() external view returns (bytes32);
195     function PERMIT_TYPEHASH() external pure returns (bytes32);
196     function nonces(address owner) external view returns (uint256);
197 
198     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
199 
200     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
201     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
202     event Swap(
203         address indexed sender,
204         uint256 amount0In,
205         uint256 amount1In,
206         uint256 amount0Out,
207         uint256 amount1Out,
208         address indexed to
209     );
210     event Sync(uint112 reserve0, uint112 reserve1);
211 
212     function MINIMUM_LIQUIDITY() external pure returns (uint256);
213     function factory() external view returns (address);
214     function token0() external view returns (address);
215     function token1() external view returns (address);
216     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
217     function price0CumulativeLast() external view returns (uint256);
218     function price1CumulativeLast() external view returns (uint256);
219     function kLast() external view returns (uint256);
220 
221     function mint(address to) external returns (uint256 liquidity);
222     function burn(address to) external returns (uint256 amount0, uint256 amount1);
223     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
224     function skim(address to) external;
225     function sync() external;
226 
227     function initialize(address, address) external;
228 }
229 
230 interface IUniswapV2Router01 {
231     function factory() external pure returns (address);
232     function WETH() external pure returns (address);
233 
234     function addLiquidity(
235         address tokenA,
236         address tokenB,
237         uint256 amountADesired,
238         uint256 amountBDesired,
239         uint256 amountAMin,
240         uint256 amountBMin,
241         address to,
242         uint256 deadline
243     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
244     function addLiquidityETH(
245         address token,
246         uint256 amountTokenDesired,
247         uint256 amountTokenMin,
248         uint256 amountETHMin,
249         address to,
250         uint256 deadline
251     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
252     function removeLiquidity(
253         address tokenA,
254         address tokenB,
255         uint256 liquidity,
256         uint256 amountAMin,
257         uint256 amountBMin,
258         address to,
259         uint256 deadline
260     ) external returns (uint256 amountA, uint256 amountB);
261     function removeLiquidityETH(
262         address token,
263         uint256 liquidity,
264         uint256 amountTokenMin,
265         uint256 amountETHMin,
266         address to,
267         uint256 deadline
268     ) external returns (uint256 amountToken, uint256 amountETH);
269     function removeLiquidityWithPermit(
270         address tokenA,
271         address tokenB,
272         uint256 liquidity,
273         uint256 amountAMin,
274         uint256 amountBMin,
275         address to,
276         uint256 deadline,
277         bool approveMax, uint8 v, bytes32 r, bytes32 s
278     ) external returns (uint256 amountA, uint256 amountB);
279     function removeLiquidityETHWithPermit(
280         address token,
281         uint256 liquidity,
282         uint256 amountTokenMin,
283         uint256 amountETHMin,
284         address to,
285         uint256 deadline,
286         bool approveMax, uint8 v, bytes32 r, bytes32 s
287     ) external returns (uint256 amountToken, uint256 amountETH);
288     function swapExactTokensForTokens(
289         uint256 amountIn,
290         uint256 amountOutMin,
291         address[] calldata path,
292         address to,
293         uint256 deadline
294     ) external returns (uint256[] memory amounts);
295     function swapTokensForExactTokens(
296         uint256 amountOut,
297         uint256 amountInMax,
298         address[] calldata path,
299         address to,
300         uint256 deadline
301     ) external returns (uint256[] memory amounts);
302     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline)
303         external
304         payable
305         returns (uint256[] memory amounts);
306     function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] calldata path, address to, uint256 deadline)
307         external
308         returns (uint256[] memory amounts);
309     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline)
310         external
311         returns (uint256[] memory amounts);
312     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to, uint256 deadline)
313         external
314         payable
315         returns (uint256[] memory amounts);
316 
317     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB);
318     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut);
319     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn);
320     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
321     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
322 }
323 
324 interface IUniswapV2Router02 is IUniswapV2Router01 {
325     function removeLiquidityETHSupportingFeeOnTransferTokens(
326         address token,
327         uint256 liquidity,
328         uint256 amountTokenMin,
329         uint256 amountETHMin,
330         address to,
331         uint256 deadline
332     ) external returns (uint256 amountETH);
333     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
334         address token,
335         uint256 liquidity,
336         uint256 amountTokenMin,
337         uint256 amountETHMin,
338         address to,
339         uint256 deadline,
340         bool approveMax, uint8 v, bytes32 r, bytes32 s
341     ) external returns (uint256 amountETH);
342 
343     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
344         uint256 amountIn,
345         uint256 amountOutMin,
346         address[] calldata path,
347         address to,
348         uint256 deadline
349     ) external;
350     function swapExactETHForTokensSupportingFeeOnTransferTokens(
351         uint256 amountOutMin,
352         address[] calldata path,
353         address to,
354         uint256 deadline
355     ) external payable;
356     function swapExactTokensForETHSupportingFeeOnTransferTokens(
357         uint256 amountIn,
358         uint256 amountOutMin,
359         address[] calldata path,
360         address to,
361         uint256 deadline
362     ) external;
363 }
364 
365 contract ERC20 is Context, IERC20, Ownable {
366     using SafeMath for uint256;
367     using Address for address;
368     
369     address payable public teamAddress = payable(0x7Ccb537E8A041977A9B32Cda7Ff987ea0920FdAF); // Team Address
370     address payable public treasuryAddress = payable(0x307942ea000c44F32a7f97a8b4f8ab12F1Bc98e6); // Treasury Address
371     mapping (address => uint256) private _rOwned;
372     mapping (address => uint256) private _tOwned;
373     mapping (address => mapping (address => uint256)) private _allowances;
374 
375     mapping (address => bool) internal isBlacklisted;
376     mapping (address => bool) internal isWhitelistedMerchant;
377 
378     mapping (address => bool) private _isExcludedFromFee;
379     mapping (address => bool) private _isOriginExcludedFromFee;
380     mapping (address => bool) private _isDestinationExcludedFromFee;
381     mapping (address => bool) private _isExcludedFromReward;
382     address[] private _excludedFromReward;
383    
384     string private _name;
385     string private _symbol;
386     uint8 private _decimals = 18;
387 
388     uint256 private constant _MAX = ~uint256(0);
389     uint256 private _tTotal = 10 * 10**9 * 10**_decimals;
390     uint256 private _rTotal = (_MAX - (_MAX % _tTotal));
391     uint256 private _tFeeTotal;
392 
393     // payment fee in percentage, 100% = 10000; 1% = 100; 0.1% = 10
394     uint256 public paymentFee = 0; 
395 
396     // rewards to holder in percentage, 100% = 10000; 1% = 100; 0.1% = 10
397     uint256 public taxFee = 300; 
398     uint256 private _previousTaxFee = taxFee;
399 
400     // in percentage, 100% = 10000; 1% = 100; 0.1% = 10
401     uint256 public taxTeamPercent = 400;
402     uint256 public taxTreasuryPercent = 100;
403     uint256 public taxLPPercent = 200;
404     uint256 public liquidityFee = 700;   // Team + Treasury + LP
405     uint256 private _previousLiquidityFee = liquidityFee;
406     
407     uint256 public maxTxAmount = 100 * 10**6 * 10**_decimals;
408     uint256 public minimumTokensBeforeSwap = 2 * 10**6 * 10**_decimals; 
409 
410     uint256 public holders = 0;
411 
412     IUniswapV2Router02 public uniswapV2Router;
413     address public uniswapV2Pair;
414     
415     bool inSwapAndLiquify;
416     bool public swapAndLiquifyEnabled = true;
417 
418     event RouterAddressUpdated(address prevAddress, address newAddress);
419     event RewardLiquidityProviders(uint256 tokenAmount);
420     event SwapAndLiquifyEnabledUpdated(bool enabled);
421     event ApplyTax(
422         uint256 tokensSwapped,
423         uint256 ethReceived,
424         uint256 tokensIntoLiqudity
425     );
426     event SwapTokensForETH(uint256 amountIn, address[] path);
427     event AddLiquidity(uint256 tokenAmount, uint256 ethAmount);
428     event ExcludeFromReward(address account);
429     event IncludeInReward(address account);
430     event ExcludeFromFee(address account);
431     event IncludeInFee(address account);
432     event ExcludeOriginFromFee(address account);
433     event IncludeOriginInFee(address account);
434     event ExcludeDestinationFromFee(address account);
435     event IncludeDestinationInFee(address account);
436     event BlackList(address account);
437     event RemoveFromBlacklist(address account);
438     event WhitelistMerchant(address account);
439     event RemoveFromWhitelistMerchant(address account);
440     event SetTaxFeePercent(uint256 taxFee);
441     event SetPaymentFeePercent(uint256 percent);
442     event SetMaxTxAmount(uint256 maxTxAmount);
443     event SetLiquidityFeePercent(uint256 _iquidityFee);
444     event SetTaxTeamPercent(uint256 percent);
445     event SetTaxTreasuryPercent(uint256 percent);
446     event SetTaxLPPercent(uint256 percent);
447     event SetNumTokensSellToAddToLiquidity(uint256 minimumTokensBeforeSwap);
448     event SetTeamAddress(address teamAddress);
449     event SetTreasuryAddress(address treasuryAddress);
450     
451     modifier lockTheSwap {
452         inSwapAndLiquify = true;
453         _;
454         inSwapAndLiquify = false;
455     }
456     
457     constructor (string memory name_, string memory symbol_, address routerAddress_) {
458         _name = name_;
459         _symbol = symbol_;
460         
461         _rOwned[_msgSender()] = _rTotal;
462 
463         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerAddress_);
464         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
465             .createPair(address(this), _uniswapV2Router.WETH());
466 
467         uniswapV2Router = _uniswapV2Router;
468 
469         _isExcludedFromFee[owner()] = true;
470         _isExcludedFromFee[address(this)] = true;
471         _isExcludedFromFee[teamAddress] = true;
472         _isExcludedFromFee[treasuryAddress] = true;
473 
474         holders = 1;
475         
476         emit Transfer(address(0), _msgSender(), _tTotal);
477     }
478 
479     function name() public view returns (string memory) {
480         return _name;
481     }
482 
483     function symbol() public view returns (string memory) {
484         return _symbol;
485     }
486 
487     function decimals() public view returns (uint8) {
488         return _decimals;
489     }
490 
491     function totalSupply() public view override returns (uint256) {
492         return _tTotal;
493     }
494 
495     function balanceOf(address account) public view override returns (uint256) {
496         if (_isExcludedFromReward[account]) return _tOwned[account];
497         return tokenFromReflection(_rOwned[account]);
498     }
499 
500     function transfer(address recipient, uint256 amount) public override returns (bool) {
501         _transfer(_msgSender(), recipient, amount);
502         return true;
503     }
504 
505     function allowance(address owner, address spender) public view override returns (uint256) {
506         return _allowances[owner][spender];
507     }
508 
509     function approve(address spender, uint256 amount) public override returns (bool) {
510         _approve(_msgSender(), spender, amount);
511         return true;
512     }
513 
514     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
515         _transfer(sender, recipient, amount);
516         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
517         return true;
518     }
519 
520     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
521         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
522         return true;
523     }
524 
525     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
526         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
527         return true;
528     }
529 
530     function totalFees() public view returns (uint256) {
531         return _tFeeTotal;
532     }
533     
534     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
535         require(tAmount <= _tTotal, "Amount must be less than supply");
536         if (!deductTransferFee) {
537             (uint256 rAmount,,,,,) = _getValues(tAmount);
538             return rAmount;
539         } else {
540             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
541             return rTransferAmount;
542         }
543     }
544 
545     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
546         require(rAmount <= _rTotal, "Amount must be less than total reflections");
547         uint256 currentRate =  _getRate();
548         return rAmount / currentRate;
549     }
550 
551     function _approve(address owner, address spender, uint256 amount) private {
552         require(owner != address(0), "ERC20: approve from the zero address");
553         require(spender != address(0), "ERC20: approve to the zero address");
554 
555         _allowances[owner][spender] = amount;
556         emit Approval(owner, spender, amount);
557     }
558 
559     function _transfer(
560         address from,
561         address to,
562         uint256 amount
563     ) private {
564         require(from != address(0), "ERC20: transfer from the zero address");
565         require(to != address(0), "ERC20: transfer to the zero address");
566         require(!isBlacklisted[from], "Address is backlisted");
567         require(!isBlacklisted[to], "Address is backlisted");
568         require(amount > 0, "Transfer amount must be greater than zero");
569         if(from != owner() && to != owner()) {
570             require(amount <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
571         }
572 
573         uint256 contractTokenBalance = balanceOf(address(this));
574         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
575 
576         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
577             if (overMinimumTokenBalance) {
578                 applyTax(minimumTokensBeforeSwap); 
579             }
580         }
581 
582         bool takeFee = true;
583         
584         //if any account belongs to _isExcludedFromFee account then remove the fee
585         //if origin account belongs to _isOriginExcludedFromFee account then remove the fee
586         //if destination account belongs to _isDestinationExcludedFromFee account then remove the fee
587         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || _isOriginExcludedFromFee[from] || _isDestinationExcludedFromFee[to]){
588             takeFee = false;
589         }
590         
591         _tokenTransfer(from, to, amount, takeFee);
592     }
593 
594     function applyTax(uint256 contractTokenBalance) private lockTheSwap {
595         // ethPortion = team + treasury + LP/2
596         uint256 halfLP = taxLPPercent / 2;
597         uint256 totalEthPortion = taxTeamPercent + taxTreasuryPercent + halfLP;
598         uint256 toSwapIntoEth = contractTokenBalance / liquidityFee * totalEthPortion;
599 
600         uint256 initialBalance = address(this).balance;
601         swapTokensForEth(address(this), address(this), toSwapIntoEth);
602         uint256 transferredBalance = address(this).balance - initialBalance;
603 
604         uint256 teamPortion = transferredBalance / totalEthPortion * taxTeamPercent;
605         uint256 treasuryPortion = transferredBalance / totalEthPortion * taxTreasuryPercent;
606 
607         // Send to Team address
608         transferToAddressETH(teamAddress, teamPortion);
609 
610         // Send to Treasury address
611         transferToAddressETH(treasuryAddress, treasuryPortion);
612 
613         // add liquidity to uniswap
614         uint256 leftOverToken = contractTokenBalance - toSwapIntoEth;
615         uint256 leftOverEth = transferredBalance - teamPortion - treasuryPortion;
616         addLiquidity(leftOverToken, leftOverEth);
617         
618         emit ApplyTax(toSwapIntoEth, transferredBalance, leftOverToken);
619     }
620 
621     function swapTokensForEth(
622         address tokenAddress,
623         address toAddress,
624         uint256 tokenAmount
625     ) private {
626         // generate the uniswap pair path of token -> weth
627         address[] memory path = new address[](2);
628         path[0] = tokenAddress;
629         path[1] = uniswapV2Router.WETH();
630 
631         IERC20(tokenAddress).approve(address(uniswapV2Router), tokenAmount);
632 
633         // make the swap
634         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
635             tokenAmount,
636             0, // accept any amount of ETH
637             path,
638             toAddress, // The contract
639             block.timestamp
640         );
641 
642         emit SwapTokensForETH(tokenAmount, path);
643     }
644     
645     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
646         // approve token transfer to cover all possible scenarios
647         _approve(address(this), address(uniswapV2Router), tokenAmount);
648 
649         // add the liquidity
650         uniswapV2Router.addLiquidityETH{value: ethAmount}(
651             address(this),
652             tokenAmount,
653             0, // slippage is unavoidable
654             0, // slippage is unavoidable
655             owner(),
656             block.timestamp
657         );
658 
659         emit AddLiquidity(tokenAmount, ethAmount);
660     }
661 
662     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
663         if(!takeFee)
664             removeAllFee();
665         
666         if (_isExcludedFromReward[sender] && !_isExcludedFromReward[recipient]) {
667             _transferFromExcluded(sender, recipient, amount);
668         } else if (!_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
669             _transferToExcluded(sender, recipient, amount);
670         } else if (_isExcludedFromReward[sender] && _isExcludedFromReward[recipient]) {
671             _transferBothExcluded(sender, recipient, amount);
672         } else {
673             _transferStandard(sender, recipient, amount);
674         }
675         
676         if(!takeFee)
677             restoreAllFee();
678     }
679 
680     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
681         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
682 
683         uint256 senderBefore = _rOwned[sender];
684         uint256 senderAfter = _rOwned[sender] - rAmount;
685         _rOwned[sender] = senderAfter;
686 
687         uint256 recipientBefore = _rOwned[recipient];
688         uint256 recipientAfter = _rOwned[recipient] + rTransferAmount;
689         _rOwned[recipient] = recipientAfter;
690 
691         _updateHolderCount(senderBefore, senderAfter, recipientBefore, recipientAfter);
692 
693         _takeLiquidity(tLiquidity);
694         _reflectFee(rFee, tFee);
695         emit Transfer(sender, recipient, tTransferAmount);
696     }
697 
698     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
699         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
700         
701         uint256 senderBefore = _rOwned[sender];
702         uint256 senderAfter = _rOwned[sender] - rAmount;
703         _rOwned[sender] = senderAfter;
704 
705         uint256 recipientBefore = _tOwned[recipient];
706         uint256 recipientAfter = _tOwned[recipient] + tTransferAmount;
707         _tOwned[recipient] = recipientAfter;
708         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount; 
709         
710         _updateHolderCount(senderBefore, senderAfter, recipientBefore, recipientAfter);
711      
712         _takeLiquidity(tLiquidity);
713         _reflectFee(rFee, tFee);
714         emit Transfer(sender, recipient, tTransferAmount);
715     }
716 
717     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
718         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
719         
720         uint256 senderBefore = _tOwned[sender];
721         uint256 senderAfter = _tOwned[sender] - tAmount;
722         _tOwned[sender] = senderAfter;
723         _rOwned[sender] = _rOwned[sender] - rAmount;
724 
725         uint256 recipientBefore = _rOwned[recipient];
726         uint256 recipientAfter = _rOwned[recipient] + rTransferAmount;
727         _rOwned[recipient] = recipientAfter;
728 
729         _updateHolderCount(senderBefore, senderAfter, recipientBefore, recipientAfter);
730 
731         _takeLiquidity(tLiquidity);
732         _reflectFee(rFee, tFee);
733         emit Transfer(sender, recipient, tTransferAmount);
734     }
735 
736     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
737         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
738         
739         uint256 senderBefore = _tOwned[sender];
740         uint256 senderAfter = _tOwned[sender] - tAmount;
741         _tOwned[sender] = senderAfter;
742         _rOwned[sender] = _rOwned[sender] - rAmount;
743 
744         uint256 recipientBefore = _tOwned[recipient];
745         uint256 recipientAfter = _tOwned[recipient] + tTransferAmount;
746         _tOwned[recipient] = recipientAfter;
747         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount; 
748 
749         _updateHolderCount(senderBefore, senderAfter, recipientBefore, recipientAfter);
750      
751         _takeLiquidity(tLiquidity);
752         _reflectFee(rFee, tFee);
753         emit Transfer(sender, recipient, tTransferAmount);
754     }
755 
756     function _reflectFee(uint256 rFee, uint256 tFee) private {
757         _rTotal = _rTotal - rFee;
758         _tFeeTotal = _tFeeTotal + tFee;
759     }
760 
761     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
762         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
763         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
764         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
765     }
766 
767     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
768         uint256 tFee = calculateTaxFee(tAmount);
769         uint256 tLiquidity = calculateLiquidityFee(tAmount);
770         uint256 tTransferAmount = tAmount - tFee - tLiquidity;
771         return (tTransferAmount, tFee, tLiquidity);
772     }
773 
774     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
775         uint256 rAmount = tAmount * currentRate;
776         uint256 rFee = tFee * currentRate;
777         uint256 rLiquidity = tLiquidity * currentRate;
778         uint256 rTransferAmount = rAmount - rFee - rLiquidity;
779         return (rAmount, rTransferAmount, rFee);
780     }
781 
782     function _getRate() private view returns(uint256) {
783         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
784         return rSupply / tSupply;
785     }
786 
787     function _getCurrentSupply() private view returns(uint256, uint256) {
788         uint256 rSupply = _rTotal;
789         uint256 tSupply = _tTotal;      
790         for (uint256 i = 0; i < _excludedFromReward.length; i++) {
791             if (_rOwned[_excludedFromReward[i]] > rSupply || _tOwned[_excludedFromReward[i]] > tSupply) return (_rTotal, _tTotal);
792             rSupply = rSupply - _rOwned[_excludedFromReward[i]];
793             tSupply = tSupply - _tOwned[_excludedFromReward[i]];
794         }
795         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
796         return (rSupply, tSupply);
797     }
798     
799     function _takeLiquidity(uint256 tLiquidity) private {
800         uint256 currentRate =  _getRate();
801         uint256 rLiquidity = tLiquidity * currentRate;
802         _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
803         if(_isExcludedFromReward[address(this)])
804             _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
805     }
806     
807     function _updateHolderCount(uint256 senderBefore, uint256 senderAfter, uint256 recipientBefore, uint256 recipientAfter) private {
808         if (recipientBefore == 0 && recipientAfter > 0) {
809             holders = holders + 1;
810         }
811 
812         if (senderBefore > 0 && senderAfter == 0) {
813             holders = holders - 1;
814         }
815     }
816 
817     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
818         return _amount * taxFee / 10000;
819     }
820     
821     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
822         return _amount * liquidityFee / 10000;
823     }
824 
825     function removeAllFee() private {
826         if(taxFee == 0 && liquidityFee == 0) return;
827         
828         _previousTaxFee = taxFee;
829         _previousLiquidityFee = liquidityFee;
830         
831         taxFee = 0;
832         liquidityFee = 0;
833     }
834     
835     function restoreAllFee() private {
836         taxFee = _previousTaxFee;
837         liquidityFee = _previousLiquidityFee;
838     }
839 
840     function isExcludedFromReward(address account) public view returns (bool) {
841         return _isExcludedFromReward[account];
842     }
843 
844     function excludeFromReward(address account) public onlyOwner {
845         require(!_isExcludedFromReward[account], "Account is already excluded");
846         if(_rOwned[account] > 0) {
847             _tOwned[account] = tokenFromReflection(_rOwned[account]);
848         }
849         _isExcludedFromReward[account] = true;
850         _excludedFromReward.push(account);
851 
852         emit ExcludeFromReward(account);
853     }
854 
855     function includeInReward(address account) external onlyOwner {
856         require(_isExcludedFromReward[account], "Account is already included");
857         for (uint256 i = 0; i < _excludedFromReward.length; i++) {
858             if (_excludedFromReward[i] == account) {
859                 _excludedFromReward[i] = _excludedFromReward[_excludedFromReward.length - 1];
860                 _tOwned[account] = 0;
861                 _isExcludedFromReward[account] = false;
862                 _excludedFromReward.pop();
863                 break;
864             }
865         }
866         emit IncludeInReward(account);
867     }
868 
869     function setRouterAddress(address routerAddress) external onlyOwner {
870         require(
871             routerAddress != address(0),
872             "routerAddress should not be the zero address"
873         );
874 
875         address prevAddress = address(uniswapV2Router);
876         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerAddress); 
877         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(
878             address(this),
879             _uniswapV2Router.WETH()
880         );
881 
882         uniswapV2Router = _uniswapV2Router;
883         emit RouterAddressUpdated(prevAddress, routerAddress);
884     }
885 
886     function isExcludedFromFee(address account) public view returns(bool) {
887         return _isExcludedFromFee[account];
888     }
889     
890     function excludeFromFee(address account) public onlyOwner {
891         require(!_isExcludedFromFee[account], "Account is already excluded");
892         _isExcludedFromFee[account] = true;
893         emit ExcludeFromFee(account);
894     }
895     
896     function includeInFee(address account) public onlyOwner {
897         require(_isExcludedFromFee[account], "Account is already included");
898         _isExcludedFromFee[account] = false;
899         emit IncludeInFee(account);
900     }
901     
902     function isOriginExcludedFromFee(address account) public view returns(bool) {
903         return _isOriginExcludedFromFee[account];
904     }
905     
906     function excludeOriginFromFee(address account) public onlyOwner {
907         require(!_isOriginExcludedFromFee[account], "Account is already excluded");
908         _isOriginExcludedFromFee[account] = true;
909         emit ExcludeOriginFromFee(account);
910     }
911     
912     function includeOriginInFee(address account) public onlyOwner {
913         require(_isOriginExcludedFromFee[account], "Account is already included");
914         _isOriginExcludedFromFee[account] = false;
915         emit IncludeOriginInFee(account);
916     }
917     
918     function isDestinationExcludedFromFee(address account) public view returns(bool) {
919         return _isDestinationExcludedFromFee[account];
920     }
921     
922     function excludeDestinationFromFee(address account) public onlyOwner {
923         require(!_isDestinationExcludedFromFee[account], "Account is already excluded");
924         _isDestinationExcludedFromFee[account] = true;
925         emit ExcludeDestinationFromFee(account);
926     }
927     
928     function includeDestinationInFee(address account) public onlyOwner {
929         require(_isDestinationExcludedFromFee[account], "Account is already included");
930         _isDestinationExcludedFromFee[account] = false;
931         emit IncludeDestinationInFee(account);
932     }
933 
934     function isAddressBlacklisted(address account) public view returns(bool) {
935         return isBlacklisted[account];
936     }
937     
938     function blackList(address account) public onlyOwner {
939         require(!isBlacklisted[account], "User already blacklisted");
940         isBlacklisted[account] = true;
941         emit BlackList(account);
942     }
943     
944     function removeFromBlacklist(address account) public onlyOwner {
945         require(isBlacklisted[account], "User is not blacklisted");
946         isBlacklisted[account] = false;
947         emit RemoveFromBlacklist(account);
948     }
949     
950     function isAddressWhitelistedMerchant(address account) public view returns(bool) {
951         return isWhitelistedMerchant[account];
952     }
953     
954     function whitelistMerchant(address account) public onlyOwner {
955         require(!isWhitelistedMerchant[account], "Account is already whitelisted");
956         isWhitelistedMerchant[account] = true;
957         emit WhitelistMerchant(account);
958     }
959     
960     function removeFromWhitelistMerchant(address account) public onlyOwner {
961         require(isWhitelistedMerchant[account], "Account is not whitelisted");
962         isWhitelistedMerchant[account] = false;
963         emit RemoveFromWhitelistMerchant(account);
964     }
965     
966     function setTaxFeePercent(uint256 _taxFee) external onlyOwner {
967         require(_taxFee <= 1000, "Input must be below or equal to 10% (1000 = 10%; 10000 = 100%)");
968         taxFee = _taxFee;
969         emit SetTaxFeePercent(_taxFee);
970     }
971     
972     function setPaymentFeePercent(uint256 _percent) external onlyOwner {
973         require(_percent <= 1000, "Input must be below or equal to 10% (1000 = 10%; 10000 = 100%)");
974         paymentFee = _percent;
975         emit SetPaymentFeePercent(_percent);
976     }
977     
978     function setMaxTxAmount(uint256 _maxTxAmount) external onlyOwner {
979         require(_maxTxAmount > 0, "Input must be greater than zero");
980         maxTxAmount = _maxTxAmount;
981         emit SetMaxTxAmount(_maxTxAmount);
982     }
983     
984     function setLiquidityFeePercent(uint256 _liquidityFee) external onlyOwner {
985         require(_liquidityFee <= 1000, "Input must be below or equal to 10% (1000 = 10%; 10000 = 100%)");
986         liquidityFee = _liquidityFee;
987         emit SetLiquidityFeePercent(_liquidityFee);
988     }
989     
990     function setTaxTeamPercent(uint256 _percent) external onlyOwner {
991         require(_percent <= 1000, "Input must be below or equal to 10% (1000 = 10%; 10000 = 100%)");
992         taxTeamPercent = _percent;
993         emit SetTaxTeamPercent(_percent);
994     }
995     
996     function setTaxTreasuryPercent(uint256 _percent) external onlyOwner {
997         require(_percent <= 1000, "Input must be below or equal to 10% (1000 = 10%; 10000 = 100%)");
998         taxTreasuryPercent = _percent;
999         emit SetTaxTreasuryPercent(_percent);
1000     }
1001     
1002     function setTaxLPPercent(uint256 _percent) external onlyOwner {
1003         require(_percent <= 1000, "Input must be below or equal to 10% (1000 = 10%; 10000 = 100%)");
1004         taxLPPercent = _percent;
1005         emit SetTaxLPPercent(_percent);
1006     }
1007     
1008     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
1009         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
1010         emit SetNumTokensSellToAddToLiquidity(_minimumTokensBeforeSwap);
1011     }
1012     
1013     function setTeamAddress(address _teamAddress) external onlyOwner {
1014         require(_teamAddress != address(0), "Address should not be the zero address");
1015         teamAddress = payable(_teamAddress);
1016         emit SetTeamAddress(_teamAddress);
1017     }
1018 
1019     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
1020         require(_treasuryAddress != address(0), "Address should not be the zero address");
1021         treasuryAddress = payable(_treasuryAddress);
1022         emit SetTreasuryAddress(_treasuryAddress);
1023     }
1024 
1025     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1026         swapAndLiquifyEnabled = _enabled;
1027         emit SwapAndLiquifyEnabledUpdated(_enabled);
1028     }
1029     
1030     function transferToAddressETH(address payable recipient, uint256 amount) private {
1031         recipient.transfer(amount);
1032     }
1033     
1034     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) public view returns (uint256 amountB) {
1035         return uniswapV2Router.quote(amountA, reserveA, reserveB);
1036     }
1037 
1038     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public view returns (uint256 amountOut) {
1039         return uniswapV2Router.getAmountOut(amountIn, reserveIn, reserveOut);
1040     }
1041 
1042     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) public view returns (uint256 amountIn) {
1043         return uniswapV2Router.getAmountIn(amountOut, reserveIn, reserveOut);
1044     }
1045 
1046     function getAmountsOut(uint256 amountIn, address[] calldata path) public view returns (uint256[] memory amounts) {
1047         return uniswapV2Router.getAmountsOut(amountIn, path);
1048     }
1049 
1050     function getAmountsIn(uint256 amountOut, address[] calldata path) public view returns (uint256[] memory amounts) {
1051         return uniswapV2Router.getAmountsIn(amountOut, path);
1052     }
1053 
1054     //to receive ETH from uniswapV2Router when swaping
1055     receive() external payable {}
1056 
1057     fallback() external payable {}
1058 }
1059 
1060 interface IERC165 {
1061     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1062 }
1063 
1064 interface IERC1363 is IERC20, IERC165 {
1065     function transferAndCall(address to, uint256 value) external returns (bool);
1066     function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
1067     function transferFromAndCall(address from, address to, uint256 value) external returns (bool);
1068     function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
1069     function approveAndCall(address spender, uint256 value) external returns (bool);
1070     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
1071     function transferOtherTokenAndCall(address tokenIn, address to, uint256 value, uint256 minValue) external returns (bool);
1072     function transferOtherTokenAndCall(address tokenIn, address to, uint256 value, uint256 minValue, bytes memory data) external returns (bool);
1073 }
1074 
1075 interface IERC1363Receiver {
1076     function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4); // solhint-disable-line  max-line-length
1077 }
1078 
1079 interface IERC1363Spender {
1080     function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
1081 }
1082 
1083 library ERC165Checker {
1084     // As per the EIP-165 spec, no interface should ever match 0xffffffff
1085     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
1086 
1087     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1088 
1089     function supportsERC165(address account) internal view returns (bool) {
1090         // Any contract that implements ERC165 must explicitly indicate support of
1091         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
1092         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
1093             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
1094     }
1095 
1096     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
1097         // query support of both ERC165 as per the spec and support of _interfaceId
1098         return supportsERC165(account) &&
1099             _supportsERC165Interface(account, interfaceId);
1100     }
1101 
1102     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1103         // query support of ERC165 itself
1104         if (!supportsERC165(account)) {
1105             return false;
1106         }
1107 
1108         // query support of each interface in _interfaceIds
1109         for (uint256 i = 0; i < interfaceIds.length; i++) {
1110             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1111                 return false;
1112             }
1113         }
1114 
1115         // all interfaces supported
1116         return true;
1117     }
1118 
1119     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1120         // success determines whether the staticcall succeeded and result determines
1121         // whether the contract at account indicates support of _interfaceId
1122         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
1123 
1124         return (success && result);
1125     }
1126 
1127     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1128         private
1129         view
1130         returns (bool, bool)
1131     {
1132         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
1133         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
1134         if (result.length < 32) return (false, false);
1135         return (success, abi.decode(result, (bool)));
1136     }
1137 }
1138 
1139 contract ERC165 is IERC165 {
1140     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1141 
1142     mapping(bytes4 => bool) private _supportedInterfaces;
1143 
1144     constructor () {
1145         // Derived contracts need only register support for their own interfaces,
1146         // we register support for ERC165 itself here
1147         _registerInterface(_INTERFACE_ID_ERC165);
1148     }
1149 
1150     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1151         return _supportedInterfaces[interfaceId];
1152     }
1153 
1154     function _registerInterface(bytes4 interfaceId) internal virtual {
1155         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1156         _supportedInterfaces[interfaceId] = true;
1157     }
1158 }
1159 
1160 contract ERC1363 is ReentrancyGuard, ERC20, IERC1363, ERC165 {
1161     using SafeMath for uint256;
1162 
1163     event TransferAndCall(address to, uint256 value, uint256 valueAfterFee, bytes data);
1164     event TransferFromAndCall(address from, address to, uint256 value, uint256 valueAfterFee, bytes data);
1165     event ApproveAndCall(address spender, uint256 value, bytes data);
1166     event TransferOtherTokenAndCall(address tokenIn, address to, uint256 value, uint256 valueAfterFee, uint256 minValue, bytes data);
1167 
1168     using Address for address;
1169 
1170     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
1171 
1172     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
1173 
1174     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
1175 
1176     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
1177 
1178     constructor (string memory name, string memory symbol, address routerAddress) ERC20(name, symbol, routerAddress) {
1179         // register the supported interfaces to conform to ERC1363 via ERC165
1180         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
1181         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
1182     }
1183 
1184     // ERC1363 transferAndCall
1185     function transferAndCall(address to, uint256 value) public override returns (bool) {
1186         return transferAndCall(to, value, "");
1187     }
1188 
1189     // ERC1363 transferAndCall
1190     function transferAndCall(address to, uint256 value, bytes memory data) public override returns (bool) {
1191         require(!isBlacklisted[to], "Address is backlisted");
1192         require(isWhitelistedMerchant[to], "Merchant is not whitelisted");  
1193 
1194         // in percentage, 100% = 10000; 1% = 100; 0.1% = 10
1195         uint256 txPaymentFee = value / 10000 * paymentFee;
1196         uint256 valueAfterFee = value - txPaymentFee;
1197 
1198         transfer(to, valueAfterFee);
1199         require(_checkAndCallTransfer(_msgSender(), to, valueAfterFee, data), "ERC1363: _checkAndCallTransfer reverts");
1200 
1201         if (paymentFee > 0) {
1202             transfer(teamAddress, txPaymentFee);
1203         }
1204 
1205         emit TransferAndCall(to, value, valueAfterFee, data);
1206         return true;
1207     }
1208 
1209     // ERC1363 transferFromAndCall
1210     function transferFromAndCall(address from, address to, uint256 value) public override returns (bool) {
1211         return transferFromAndCall(from, to, value, "");
1212     }
1213 
1214     // ERC1363 transferFromAndCall
1215     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public override returns (bool) {
1216         require(!isBlacklisted[from], "Address is backlisted");
1217         require(!isBlacklisted[to], "Address is backlisted");
1218         require(isWhitelistedMerchant[to], "Merchant is not whitelisted");
1219 
1220         // in percentage, 100% = 10000; 1% = 100; 0.1% = 10
1221         uint256 txPaymentFee = value / 10000 * paymentFee;
1222         uint256 valueAfterFee = value - txPaymentFee;
1223 
1224         transferFrom(from, to, valueAfterFee);
1225         require(_checkAndCallTransfer(from, to, valueAfterFee, data), "ERC1363: _checkAndCallTransfer reverts");
1226         
1227         if (paymentFee > 0) {
1228             transfer(teamAddress, txPaymentFee);
1229         }
1230 
1231         emit TransferFromAndCall(from, to, value, valueAfterFee, data);
1232         return true;
1233     }
1234 
1235     // ERC1363 approveAndCall
1236     function approveAndCall(address spender, uint256 value) public override returns (bool) {
1237         return approveAndCall(spender, value, "");
1238     }
1239 
1240     // ERC1363 approveAndCall
1241     function approveAndCall(address spender, uint256 value, bytes memory data) public override returns (bool) {
1242         require(!isBlacklisted[spender], "Address is backlisted");
1243         require(isWhitelistedMerchant[spender], "Merchant is not whitelisted");
1244 
1245         approve(spender, value);
1246         require(_checkAndCallApprove(spender, value, data), "ERC1363: _checkAndCallApprove reverts");
1247         emit ApproveAndCall(spender, value, data);
1248         return true;
1249     }
1250 
1251     function transferOtherTokenAndCall(address tokenIn, address to, uint256 value, uint256 minValue) public override returns (bool) {
1252         return transferOtherTokenAndCall(tokenIn, to, value, minValue, "");
1253     }
1254 
1255     function transferOtherTokenAndCall(address tokenIn, address to, uint256 value, uint256 minValue, bytes memory data) public override returns (bool) {
1256         require(!isBlacklisted[to], "Address is backlisted");
1257         require(isWhitelistedMerchant[to], "Merchant is not whitelisted");
1258 
1259         IERC20(tokenIn).transferFrom(msg.sender, address(this), value);
1260 
1261         IERC20(tokenIn).approve(address(uniswapV2Router), value);
1262 
1263         address[] memory path = new address[](3);
1264         path[0] = tokenIn;
1265         path[1] = uniswapV2Router.WETH(); //WETH
1266         path[2] = address(this);
1267         
1268         // if taking payment fee, swaps resulted amount to sender and distribute from sender address accordingly;
1269         // if not taking payment fee, swaps resulted amount to merchant address directly
1270         address targetAddress = to;
1271         if (paymentFee > 0) {
1272             targetAddress = msg.sender;
1273         }
1274 
1275         uint256 initialBalance = balanceOf(targetAddress);
1276         
1277         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1278             value,
1279             minValue,
1280             path,
1281             targetAddress,
1282             block.timestamp + 120
1283             );
1284 
1285         uint256 amountReceived = balanceOf(targetAddress) - initialBalance;
1286         
1287         // in percentage, 100% = 10000; 1% = 100; 0.1% = 10
1288         uint256 txPaymentFee = amountReceived / 10000 * paymentFee;
1289         uint256 valueAfterFee = amountReceived - txPaymentFee;
1290 
1291         if (paymentFee > 0) {
1292             // transfer to merchant
1293             transfer(to, valueAfterFee);
1294             // transfer to team
1295             transfer(teamAddress, txPaymentFee);
1296         }
1297 
1298         require(_checkAndCallTransfer(msg.sender, to, valueAfterFee, data), "ERC1363: _checkAndCallTransfer reverts");
1299 
1300         emit TransferOtherTokenAndCall(tokenIn, to, value, valueAfterFee, minValue, data);
1301 
1302         return true;
1303     }
1304 
1305     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal nonReentrant returns (bool) {
1306         if (!to.isContract()) {
1307             return false;
1308         }
1309         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
1310             _msgSender(), from, value, data
1311         );
1312         return (retval == _ERC1363_RECEIVED);
1313     }
1314 
1315     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal nonReentrant returns (bool) {
1316         if (!spender.isContract()) {
1317             return false;
1318         }
1319         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1320             _msgSender(), value, data
1321         );
1322         return (retval == _ERC1363_APPROVED);
1323     }
1324 }
1325 
1326 contract PayBolt is ERC1363 {
1327     constructor (address routerAddress)
1328         ERC1363("PayBolt", "PAY", routerAddress) {
1329     }
1330 
1331     function paySecurelyWithPaybolt(address to, uint256 value) public returns (bool) {
1332         return transferAndCall(to, value, "");
1333     }
1334 
1335     function paySecurelyWithPaybolt(address to, uint256 value, bytes memory data) public returns (bool) {
1336         return transferAndCall(to, value, data);
1337     }
1338 
1339     function authorizeSecurelyWithPaybolt(address spender, uint256 value) public returns (bool) {
1340         return approveAndCall(spender, value, "");
1341     }
1342 
1343     function authorizeSecurelyWithPaybolt(address spender, uint256 value, bytes memory data) public returns (bool) {
1344         return approveAndCall(spender, value, data);
1345     }
1346 
1347     function paySecurelyWithAnyToken(address tokenIn, address to, uint256 value, uint256 minValue) public returns (bool) {
1348         return transferOtherTokenAndCall(tokenIn, to, value, minValue, "");
1349     }
1350 
1351     function paySecurelyWithAnyToken(address tokenIn, address to, uint256 value, uint256 minValue, bytes memory data) public returns (bool) {
1352         return transferOtherTokenAndCall(tokenIn, to, value, minValue, data);
1353     }
1354 }