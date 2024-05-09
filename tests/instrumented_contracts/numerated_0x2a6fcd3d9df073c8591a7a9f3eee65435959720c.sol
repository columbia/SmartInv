1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
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
394 
395         (bool success, bytes memory returndata) = target.call{value: weiValue}(
396             data
397         );
398         if (success) {
399             return returndata;
400         } else {
401             if (returndata.length > 0) {
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 interface IUniswapV2Pair {
413     event Approval(address indexed owner, address indexed spender, uint256 value);
414     event Transfer(address indexed from, address indexed to, uint256 value);
415     function name() external pure returns (string memory);
416     function symbol() external pure returns (string memory);
417     function decimals() external pure returns (uint8);
418     function totalSupply() external view returns (uint256);
419     function balanceOf(address owner) external view returns (uint256);
420     function allowance(address owner, address spender) external view returns (uint256);
421     function approve(address spender, uint256 value) external returns (bool);
422     function transfer(address to, uint256 value) external returns (bool);
423     function transferFrom(address from, address to, uint256 value) external returns (bool);
424     function DOMAIN_SEPARATOR() external view returns (bytes32);
425     function PERMIT_TYPEHASH() external pure returns (bytes32);
426     function nonces(address owner) external view returns (uint256);
427     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
428     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
429     event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
430     event Sync(uint112 reserve0, uint112 reserve1);
431     function MINIMUM_LIQUIDITY() external pure returns (uint256);
432     function factory() external view returns (address);
433     function token0() external view returns (address);
434     function token1() external view returns (address);
435     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
436     function price0CumulativeLast() external view returns (uint256);
437     function price1CumulativeLast() external view returns (uint256);
438     function kLast() external view returns (uint256);
439     function burn(address to) external returns (uint256 amount0, uint256 amount1);
440     function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
441     function skim(address to) external;
442     function sync() external;
443     function initialize(address, address) external;
444 }
445 
446 contract SLICESWAP is Context, IERC20, ERC20Ownable {
447     using SafeMath for uint256;
448     using Address for address;
449 
450     string private constant tokenName = "SLICESWAP";
451     string private constant tokenSymbol = "SLICESWAP";
452     uint8 private constant tokenDecimal = 18;
453     uint256 private constant tokenSupply = 100e12 * 10**tokenDecimal;
454 
455     mapping(address => mapping(address => uint256)) private tokenAllowances;
456     mapping(address => uint256) private tokenBalance;
457     mapping(address => bool) private isContractsExcluded;
458     mapping(address => bool) private isMaxWalletExcluded;
459     mapping(address => bool) private isTaxExcluded;
460     mapping(address => bool) public isSniper;
461     mapping(address => bool) public isBot;
462 
463     address payable liquidityAddress;
464     address payable marketingAddress;
465     address payable devAddress;
466     address dead = address(0xdead);
467     address public uniV2Pair;
468     IUniswapV2Router02 public uniV2Router;
469     address public uniV3Router;
470     
471     uint256 private maxWallet;
472     uint256 private minTaxSwap;
473     uint256 private marketingTokens;
474     uint256 private liquidityTokens;
475 	uint256 private totalBurnedTokens;
476 
477     uint256 private marketingTax;
478     uint256 private liquidityTax;
479     uint256 private divForSplitTax;
480     uint256 private taxBuyMarketing;
481     uint256 private taxBuyLiquidity;
482     uint256 private taxSellMarketing;
483     uint256 private taxSellTreasury;
484     uint256 private taxSellLiquidity;
485 
486     uint256 public activeTradingBlock;
487     uint256 public sniperPenaltyEnd;
488 
489     bool public limitsOn = false;
490     bool public maxWalletOn = false;
491     bool public live = false;
492     bool public contractBlocker = false;
493     bool inSwapAndLiquify;
494     bool private swapAndLiquifyStatus = false;
495     modifier lockTheSwap() {
496         inSwapAndLiquify = true;
497         _;
498         inSwapAndLiquify = false;
499     }
500     constructor() payable {
501         tokenBalance[address(this)] = tokenSupply;
502         maxWallet = tokenSupply.mul(2).div(100);
503         minTaxSwap = tokenSupply.mul(5).div(10000);
504 
505         marketingAddress = payable(0x83a595ce073DFE4A814964C30f21C9574de1F63A);
506         devAddress = payable(0x83a595ce073DFE4A814964C30f21C9574de1F63A);
507 
508         liquidityAddress = payable(owner()); //LEAVE AS OWNER
509 
510         taxBuyMarketing = 25;
511         taxBuyLiquidity = 0;
512         taxSellMarketing = 25;
513         taxSellLiquidity = 0;
514 
515         isContractsExcluded[address(this)] = true;
516         isTaxExcluded[owner()] = true;
517         isTaxExcluded[dead] = true;
518         isTaxExcluded[address(this)] = true;
519         isTaxExcluded[marketingAddress] = true;
520         isTaxExcluded[liquidityAddress] = true;
521         isMaxWalletExcluded[address(this)] = true;
522         isMaxWalletExcluded[owner()] = true;
523         isMaxWalletExcluded[marketingAddress] = true;
524         isMaxWalletExcluded[liquidityAddress] = true;
525         isMaxWalletExcluded[dead] = true;
526         
527         emit Transfer(address(0), address(this), tokenSupply);
528     }
529     receive() external payable {}
530     function name() external pure override returns (string memory) {
531         return tokenName;
532     }
533     function symbol() external pure override returns (string memory) {
534         return tokenSymbol;
535     }
536     function decimals() external pure override returns (uint8) {
537         return tokenDecimal;
538     }
539     function totalSupply() external pure override returns (uint256) {
540         return tokenSupply;
541     }
542     function balanceOf(address account) public view override returns (uint256) {
543         return tokenBalance[account];
544     }
545     function allowance(address owner, address spender) external view override returns (uint256) {
546         return tokenAllowances[owner][spender];
547     }
548     function approve(address spender, uint256 amount) public override returns (bool) {
549         require(_msgSender() != address(0), "ERC20: Can not approve from zero address");
550         require(spender != address(0), "ERC20: Can not approve to zero address");
551         tokenAllowances[_msgSender()][spender] = amount;
552         emit Approval(_msgSender(), spender, amount);
553         return true;
554     }
555     function internalApprove(address owner,address spender,uint256 amount) internal {
556         require(owner != address(0), "ERC20: Can not approve from zero address");
557         require(spender != address(0), "ERC20: Can not approve to zero address");
558         tokenAllowances[owner][spender] = amount;
559         emit Approval(owner, spender, amount);
560     }
561     function transfer(address recipient, uint256 amount) external override returns (bool) {
562         internalTransfer(_msgSender(), recipient, amount);
563         return true;
564     }
565     function transferFrom(address sender,address recipient,uint256 amount) external override returns (bool) {
566         internalTransfer(sender, recipient, amount);
567         internalApprove(sender,_msgSender(),
568         tokenAllowances[sender][_msgSender()].sub(amount, "ERC20: Can not transfer. Amount exceeds allowance"));
569         return true;
570     }
571     function AirDrop(address[] memory wallets, uint256[] memory percent) external onlyOwner{
572         require(wallets.length < 100, "Can only airdrop 100 wallets per txn due to gas limits");
573         for(uint256 i = 0; i < wallets.length; i++){
574             address wallet = wallets[i];
575             uint256 amount = tokenSupply.mul(percent[i]).div(100);
576             internalTransfer(_msgSender(), wallet, amount);
577         }
578     }
579     function GoLive() external onlyOwner returns (bool){
580         require(!live, "ERC20: Trades already Live!");
581         activeTradingBlock = block.number;
582         sniperPenaltyEnd = block.timestamp.add(2 days);
583         IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
584         uniV2Router = _uniV2Router;
585         uniV3Router = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;
586         isContractsExcluded[address(uniV2Router)] = true;
587         isContractsExcluded[address(uniV3Router)] = true;
588         isMaxWalletExcluded[address(uniV2Router)] = true;
589         internalApprove(address(this), address(uniV2Router), tokenSupply);
590         uniV2Pair = IUniswapV2Factory(_uniV2Router.factory()).createPair(address(this), _uniV2Router.WETH());
591         isContractsExcluded[address(uniV2Pair)] = true;
592         isMaxWalletExcluded[address(uniV2Pair)] = true;
593         require(address(this).balance > 0, "ERC20: Must have ETH on contract to Go Live!");
594         addLiquidity(balanceOf(address(this)), address(this).balance);
595         launchSetLiquidityAddress(dead);
596         maxWalletOn = true;
597         swapAndLiquifyStatus = true;
598         limitsOn = true;
599         live = true;
600         return true;
601     }
602     function internalTransfer(address from, address to, uint256 amount) internal {
603         require(from != address(0), "ERC20: transfer from the zero address");
604         require(to != address(0), "ERC20: transfer to the zero address");
605         require(amount > 0, "ERC20: Transfer amount must be greater than zero");
606         require(!isBot[from], "ERC20: Can not transfer from BOT");
607         if(!live){
608             require(isTaxExcluded[from] || isTaxExcluded[to], "ERC20: Trading Is Not Live!");
609         }
610         if (maxWalletOn == true && ! isMaxWalletExcluded[to]) {
611             require(balanceOf(to).add(amount) <= maxWallet, "ERC20: Max amount of tokens for wallet reached");
612         }
613         if(limitsOn){
614             if (from != owner() && to != owner() && to != address(0) && to != dead && to != uniV2Pair) {
615                 for (uint x = 0; x < 3; x++) {
616                     if(block.number == activeTradingBlock.add(x)) {
617                         isSniper[to] = true;
618                     }
619                 }
620             }
621         }
622         if(contractBlocker) {
623             require(
624                 !isContract(to) && isContractsExcluded[from] ||
625                 !isContract(from) && isContractsExcluded[to] || 
626                 isContract(from) && isContractsExcluded[to] || 
627                 isContract(to) && isContractsExcluded[from]
628                 );
629         }
630         uint256 totalTokensToSwap = liquidityTokens.add(marketingTokens);
631         uint256 contractTokenBalance = balanceOf(address(this));
632         bool overMinimumTokenBalance = contractTokenBalance >= minTaxSwap;
633         if (!inSwapAndLiquify && swapAndLiquifyStatus && balanceOf(uniV2Pair) > 0 && totalTokensToSwap > 0 && !isTaxExcluded[to] && !isTaxExcluded[from] && to == uniV2Pair && overMinimumTokenBalance) {
634             taxTokenSwap();
635             }
636         if (isTaxExcluded[from] || isTaxExcluded[to]) {
637             marketingTax = 0;
638             liquidityTax = 0;
639             divForSplitTax = marketingTax.add(liquidityTax);
640         } else {
641             if (from == uniV2Pair) {
642                 marketingTax = taxBuyMarketing;
643                 liquidityTax = taxBuyLiquidity;
644                 divForSplitTax = taxBuyMarketing.add(taxBuyLiquidity);
645             }else if (to == uniV2Pair) {
646                 marketingTax = taxSellMarketing;
647                 liquidityTax = taxSellLiquidity;
648                 divForSplitTax = taxSellMarketing.add(taxSellLiquidity);
649                 if(isSniper[from] && sniperPenaltyEnd >= block.timestamp){
650                     marketingTax = 85;
651                     liquidityTax = 10;
652                     divForSplitTax = marketingTax.add(liquidityTax);
653                 }
654             }else {
655                 require(!isSniper[from] || sniperPenaltyEnd <= block.timestamp, "ERC20: Snipers can not transfer till penalty time is over");
656                 marketingTax = 0;
657                 liquidityTax = 0;
658             }
659         }
660         tokenTransfer(from, to, amount);
661     }
662     function taxTokenSwap() internal lockTheSwap {
663         uint256 contractBalance = balanceOf(address(this));
664         uint256 totalTokensToSwap = marketingTokens.add(liquidityTokens);
665         uint256 swapLiquidityTokens = liquidityTokens.div(2);
666         uint256 amountToSwapForETH = contractBalance.sub(swapLiquidityTokens);
667         uint256 initialETHBalance = address(this).balance;
668         swapTokensForETH(amountToSwapForETH); 
669         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
670         uint256 ethForMarketing = ethBalance.mul(marketingTokens).div(totalTokensToSwap);
671         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing);
672         marketingTokens = 0;
673         liquidityTokens = 0;
674         (bool success,) = address(marketingAddress).call{value: ethForMarketing}("");
675         if(ethForLiquidity != 0 && swapLiquidityTokens != 0) {
676             addLiquidity(swapLiquidityTokens, ethForLiquidity);
677         }
678         if(address(this).balance > 5 * 1e17){
679             (success,) = address(devAddress).call{value: address(this).balance}("");
680         }
681     }
682     function swapTokensForETH(uint256 tokenAmount) internal {
683         address[] memory path = new address[](2);
684         path[0] = address(this);
685         path[1] = uniV2Router.WETH();
686         internalApprove(address(this), address(uniV2Router), tokenAmount);
687         uniV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
688             tokenAmount,
689             0,
690             path,
691             address(this),
692             block.timestamp
693         );
694     }
695     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
696         internalApprove(address(this), address(uniV2Router), tokenAmount);
697         uniV2Router.addLiquidityETH{value: ethAmount}(
698             address(this),
699             tokenAmount,
700             0,
701             0,
702             liquidityAddress,
703             block.timestamp
704         );
705     }
706     function calculateTax(uint256 amount) internal view returns (uint256) {
707         return amount.mul(marketingTax.add(liquidityTax)).div(100);
708     }
709     function splitTaxTokens(uint256 taxTokens) internal {
710         marketingTokens += taxTokens.mul(marketingTax).div(divForSplitTax);
711         liquidityTokens += taxTokens.mul(liquidityTax).div(divForSplitTax);
712     }
713     function tokenTransfer(address sender,address recipient,uint256 amount) internal {
714         if(divForSplitTax != 0){
715             uint256 taxTokens = calculateTax(amount);
716             uint256 transferTokens = amount.sub(taxTokens);
717             splitTaxTokens(taxTokens);
718             tokenBalance[sender] -= amount;
719             tokenBalance[recipient] += transferTokens;
720             tokenBalance[address(this)] += taxTokens;
721             emit Transfer(sender, recipient, transferTokens);
722         }else{
723             tokenBalance[sender] -= amount;
724             tokenBalance[recipient] += amount;
725             emit Transfer(sender, recipient, amount);
726         }
727     }
728     function launchSetLiquidityAddress(address LPAddress) internal {
729         liquidityAddress = payable(LPAddress);
730         isTaxExcluded[liquidityAddress] = true;
731     }
732     function isContract(address account) public view returns (bool) {
733         bytes32 codehash;
734         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
735         assembly {
736             codehash := extcodehash(account)
737         }
738         return (codehash != accountHash && codehash != 0x0);
739     }
740     function addRemoveContract(address account, bool trueORfalse) external onlyOwner {
741         isContractsExcluded[account] = trueORfalse;
742     }
743     function isExcludedContract(address account) public view returns (bool) {
744         return isContractsExcluded[account];
745     }
746     function withdrawStuckETH() external onlyOwner {
747         bool success;
748         (success,) = address(owner()).call{value: address(this).balance}("");
749     }
750     function withdrawStuckTokens(uint256 percent) external onlyOwner {
751         internalTransfer(address(this), owner(), tokenSupply*percent/100);
752     }
753     function manualBurnTokensFromLP(uint256 percent) external onlyOwner returns (bool){
754         require(percent <= 10, "ERC20: May not nuke more than 10% of tokens in LP");
755         uint256 liquidityPairBalance = this.balanceOf(uniV2Pair);
756         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10**2);
757         if (amountToBurn > 0){
758             internalTransfer(uniV2Pair, dead, amountToBurn);
759         }
760         totalBurnedTokens = balanceOf(dead);
761         require(totalBurnedTokens <= tokenSupply * 50 / 10**2, "ERC20: Can not burn more then 50% of supply");
762         IUniswapV2Pair pair = IUniswapV2Pair(uniV2Pair);
763         pair.sync();
764         return true;
765     }
766     function manualSwapTax() external onlyOwner {
767         uint256 contractBalance = balanceOf(address(this));
768         require(contractBalance >= tokenSupply.mul(5).div(10000), "ERC20: Can only swap back if more than 0.05% of tokens stuck on contract");
769         taxTokenSwap();
770     }
771     function addBot(address account) external onlyOwner {
772         require(!isBot[account], "ERC20: Account already added");
773         isBot[account] = true;
774     }
775 	function removeBot(address account) external onlyOwner {
776         require(isBot[account], "ERC20: Account is not bot");
777         isBot[account] = false;
778     }
779 	function removeSniper(address account) external onlyOwner {
780         require(isSniper[account], "ERC20: Account is not sniper");
781         isSniper[account] = false;
782     }
783     function setExcludedContractAccount(address account, bool trueORfalse) external onlyOwner {
784         isContractsExcluded[address(account)] = trueORfalse;
785     }
786     function setExcludedFromTax(address account, bool trueORfalse) external onlyOwner {
787         isTaxExcluded[address(account)] = trueORfalse;
788     }
789     function setExcludedFromMaxWallet(address account, bool trueORfalse) external onlyOwner {
790         isMaxWalletExcluded[address(account)] = trueORfalse;
791     }
792     function setMaxWalletAmount(uint256 percent, uint256 divider) external onlyOwner {
793         maxWallet = tokenSupply.mul(percent).div(divider);
794         require(maxWallet <=tokenSupply.mul(4).div(100), "ERC20: Can not set max wallet more than 4%");
795     }
796     function setStatusLimits(bool trueORfalse) external onlyOwner {
797         limitsOn = trueORfalse;
798     }
799     function setStatusMaxWallet(bool trueORfalse) external onlyOwner {
800        maxWalletOn = trueORfalse;
801     }
802     function setStatusContractBlocker(bool trueORfalse) external onlyOwner {
803         contractBlocker = trueORfalse;
804     }
805     function setSwapAndLiquifyStatus(bool trueORfalse) external onlyOwner {
806         swapAndLiquifyStatus = trueORfalse;
807     }
808     function setTaxes(uint256 buyMarketingTax, uint256 buyLiquidityTax, uint256 sellMarketingTax, uint256 sellLiquidityTax) external onlyOwner {
809         taxBuyMarketing = buyMarketingTax;
810         taxBuyLiquidity = buyLiquidityTax;
811         taxSellMarketing = sellMarketingTax;
812         taxSellLiquidity = sellLiquidityTax;
813     }
814     function viewTaxes() public view returns(uint256 marketingBuy, uint256 liquidityBuy, uint256 marketingSell, uint256 liquiditySell) {
815         return(taxBuyMarketing,taxBuyLiquidity,taxSellMarketing,taxSellLiquidity);
816     }
817 }