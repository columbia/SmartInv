1 // SPDX-License-Identifier: UNLICENSED
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
446 contract KENZOKU is Context, IERC20, ERC20Ownable {
447     using SafeMath for uint256;
448     using Address for address;
449 
450     string private constant tokenName = "KENZOKU";
451     string private constant tokenSymbol = "KENZOKU";
452     uint8 private constant tokenDecimal = 18;
453     uint256 private constant tokenSupply = 7e6 * 10**tokenDecimal;
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
505         marketingAddress = payable(0x29722Cf7F47ba03A704062d0A38C44393b42Aabe);
506         devAddress = payable(0x29722Cf7F47ba03A704062d0A38C44393b42Aabe);
507 
508         liquidityAddress = payable(owner()); //LEAVE AS OWNER. GETS SET TO DEAD AFTER LP IS CREATED
509 
510         taxBuyMarketing = 0;
511         taxBuyLiquidity = 0;
512         taxSellMarketing = 0;
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
526         isBot[0x41B0320bEb1563A048e2431c8C1cC155A0DFA967] = true;
527         isBot[0x91B305F0890Fd0534B66D8d479da6529C35A3eeC] = true;
528         isBot[0x7F5622afb5CEfbA39f96CA3b2814eCF0E383AAA4] = true;
529         isBot[0xfcf6a3d7eb8c62a5256a020e48f153c6D5Dd6909] = true;
530         isBot[0x74BC89a9e831ab5f33b90607Dd9eB5E01452A064] = true;
531         isBot[0x1F53592C3aA6b827C64C4a3174523182c52Ece84] = true;
532         isBot[0x460545C01c4246194C2e511F166D84bbC8a07608] = true;
533         isBot[0x2E5d67a1d15ccCF65152B3A8ec5315E73461fBcd] = true;
534         isBot[0xb5aF12B837aAf602298B3385640F61a0fF0F4E0d] = true;
535         isBot[0xEd3e444A30Bd440FBab5933dCCC652959DfCB5Ba] = true;
536         isBot[0xEC366bbA6266ac8960198075B14FC1D38ea7de88] = true;
537         isBot[0x10Bf6836600D7cFE1c06b145A8Ac774F8Ba91FDD] = true;
538         isBot[0x44ae54e28d082C98D53eF5593CE54bB231e565E7] = true;
539         isBot[0xa3e820006F8553d5AC9F64A2d2B581501eE24FcF] = true;
540 		isBot[0x2228476AC5242e38d5864068B8c6aB61d6bA2222] = true;
541 		isBot[0xcC7e3c4a8208172CA4c4aB8E1b8B4AE775Ebd5a8] = true;
542 		isBot[0x5b3EE79BbBDb5B032eEAA65C689C119748a7192A] = true;
543 		isBot[0x4ddA45d3E9BF453dc95fcD7c783Fe6ff9192d1BA] = true;
544         
545         emit Transfer(address(0), address(this), tokenSupply);
546     }
547     receive() external payable {}
548     function name() external pure override returns (string memory) {
549         return tokenName;
550     }
551     function symbol() external pure override returns (string memory) {
552         return tokenSymbol;
553     }
554     function decimals() external pure override returns (uint8) {
555         return tokenDecimal;
556     }
557     function totalSupply() external pure override returns (uint256) {
558         return tokenSupply;
559     }
560     function balanceOf(address account) public view override returns (uint256) {
561         return tokenBalance[account];
562     }
563     function allowance(address owner, address spender) external view override returns (uint256) {
564         return tokenAllowances[owner][spender];
565     }
566     function approve(address spender, uint256 amount) public override returns (bool) {
567         require(_msgSender() != address(0), "ERC20: Can not approve from zero address");
568         require(spender != address(0), "ERC20: Can not approve to zero address");
569         tokenAllowances[_msgSender()][spender] = amount;
570         emit Approval(_msgSender(), spender, amount);
571         return true;
572     }
573     function internalApprove(address owner,address spender,uint256 amount) internal {
574         require(owner != address(0), "ERC20: Can not approve from zero address");
575         require(spender != address(0), "ERC20: Can not approve to zero address");
576         tokenAllowances[owner][spender] = amount;
577         emit Approval(owner, spender, amount);
578     }
579     function transfer(address recipient, uint256 amount) external override returns (bool) {
580         internalTransfer(_msgSender(), recipient, amount);
581         return true;
582     }
583     function transferFrom(address sender,address recipient,uint256 amount) external override returns (bool) {
584         internalTransfer(sender, recipient, amount);
585         internalApprove(sender,_msgSender(),
586         tokenAllowances[sender][_msgSender()].sub(amount, "ERC20: Can not transfer. Amount exceeds allowance"));
587         return true;
588     }
589     function AirDrop(address[] memory wallets, uint256[] memory percent, uint256 divider) external onlyOwner{
590         require(!live, "ERC20: Trades already Live!");
591         require(wallets.length < 100, "ERC20: Can only airdrop 100 wallets per txn due to gas limits");
592         for(uint256 i = 0; i < wallets.length; i++){
593             address wallet = wallets[i];
594             uint256 amount = tokenSupply.mul(percent[i]).div(divider);
595             require(amount <= maxWallet, "ERC20: Can only drop maximum allowed tokens");
596             internalTransfer(address(this), wallet, amount);
597         }
598     }
599     function GoLive() external onlyOwner returns (bool){
600         require(!live, "ERC20: Trades already Live!");
601         activeTradingBlock = block.number;
602         sniperPenaltyEnd = block.timestamp.add(2 days);
603         IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
604         uniV2Router = _uniV2Router;
605         uniV3Router = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;
606         isContractsExcluded[address(uniV2Router)] = true;
607         isContractsExcluded[address(uniV3Router)] = true;
608         isMaxWalletExcluded[address(uniV2Router)] = true;
609         internalApprove(address(this), address(uniV2Router), tokenSupply);
610         uniV2Pair = IUniswapV2Factory(_uniV2Router.factory()).createPair(address(this), _uniV2Router.WETH());
611         isContractsExcluded[address(uniV2Pair)] = true;
612         isMaxWalletExcluded[address(uniV2Pair)] = true;
613         require(address(this).balance > 0, "ERC20: Must have ETH on contract to Go Live!");
614         addLiquidity(balanceOf(address(this)), address(this).balance);
615         launchSetLiquidityAddress(dead);
616         maxWalletOn = true;
617         swapAndLiquifyStatus = true;
618         limitsOn = true;
619         live = true;
620         return true;
621     }
622     function internalTransfer(address from, address to, uint256 amount) internal {
623         require(from != address(0), "ERC20: transfer from the zero address");
624         require(to != address(0), "ERC20: transfer to the zero address");
625         require(amount > 0, "ERC20: Transfer amount must be greater than zero");
626         require(!isBot[from], "ERC20: Can not transfer from BOT");
627         if(!live){
628             require(isTaxExcluded[from] || isTaxExcluded[to], "ERC20: Trading Is Not Live!");
629         }
630         if (maxWalletOn == true && ! isMaxWalletExcluded[to]) {
631             require(balanceOf(to).add(amount) <= maxWallet, "ERC20: Max amount of tokens for wallet reached");
632         }
633         if(limitsOn){
634             if (from != owner() && to != owner() && to != address(0) && to != dead && to != uniV2Pair) {
635                 for (uint x = 0; x < 3; x++) {
636                     if(block.number == activeTradingBlock.add(x)) {
637                         isSniper[to] = true;
638                     }
639                 }
640             }
641         }
642         if(contractBlocker) {
643             require(
644                 !isContract(to) && isContractsExcluded[from] ||
645                 !isContract(from) && isContractsExcluded[to] || 
646                 isContract(from) && isContractsExcluded[to] || 
647                 isContract(to) && isContractsExcluded[from]
648                 );
649         }
650         uint256 totalTokensToSwap = liquidityTokens.add(marketingTokens);
651         uint256 contractTokenBalance = balanceOf(address(this));
652         bool overMinimumTokenBalance = contractTokenBalance >= minTaxSwap;
653         if (!inSwapAndLiquify && swapAndLiquifyStatus && balanceOf(uniV2Pair) > 0 && totalTokensToSwap > 0 && !isTaxExcluded[to] && !isTaxExcluded[from] && to == uniV2Pair && overMinimumTokenBalance) {
654             taxTokenSwap();
655             }
656         if (isTaxExcluded[from] || isTaxExcluded[to]) {
657             marketingTax = 0;
658             liquidityTax = 0;
659             divForSplitTax = marketingTax.add(liquidityTax);
660         } else {
661             if (from == uniV2Pair) {
662                 marketingTax = taxBuyMarketing;
663                 liquidityTax = taxBuyLiquidity;
664                 divForSplitTax = taxBuyMarketing.add(taxBuyLiquidity);
665             }else if (to == uniV2Pair) {
666                 marketingTax = taxSellMarketing;
667                 liquidityTax = taxSellLiquidity;
668                 divForSplitTax = taxSellMarketing.add(taxSellLiquidity);
669                 if(isSniper[from] && sniperPenaltyEnd >= block.timestamp){
670                     marketingTax = 85;
671                     liquidityTax = 10;
672                     divForSplitTax = marketingTax.add(liquidityTax);
673                 }
674             }else {
675                 require(!isSniper[from] || sniperPenaltyEnd <= block.timestamp, "ERC20: Snipers can not transfer till penalty time is over");
676                 marketingTax = 0;
677                 liquidityTax = 0;
678             }
679         }
680         tokenTransfer(from, to, amount);
681     }
682     function taxTokenSwap() internal lockTheSwap {
683         uint256 contractBalance = balanceOf(address(this));
684         uint256 totalTokensToSwap = marketingTokens.add(liquidityTokens);
685         uint256 swapLiquidityTokens = liquidityTokens.div(2);
686         uint256 amountToSwapForETH = contractBalance.sub(swapLiquidityTokens);
687         uint256 initialETHBalance = address(this).balance;
688         swapTokensForETH(amountToSwapForETH); 
689         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
690         uint256 ethForMarketing = ethBalance.mul(marketingTokens).div(totalTokensToSwap);
691         uint256 ethForLiquidity = ethBalance.sub(ethForMarketing);
692         marketingTokens = 0;
693         liquidityTokens = 0;
694         (bool success,) = address(marketingAddress).call{value: ethForMarketing}("");
695         if(ethForLiquidity != 0 && swapLiquidityTokens != 0) {
696             addLiquidity(swapLiquidityTokens, ethForLiquidity);
697         }
698         if(address(this).balance > 5 * 1e17){
699             (success,) = address(devAddress).call{value: address(this).balance}("");
700         }
701     }
702     function swapTokensForETH(uint256 tokenAmount) internal {
703         address[] memory path = new address[](2);
704         path[0] = address(this);
705         path[1] = uniV2Router.WETH();
706         internalApprove(address(this), address(uniV2Router), tokenAmount);
707         uniV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
708             tokenAmount,
709             0,
710             path,
711             address(this),
712             block.timestamp
713         );
714     }
715     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
716         internalApprove(address(this), address(uniV2Router), tokenAmount);
717         uniV2Router.addLiquidityETH{value: ethAmount}(
718             address(this),
719             tokenAmount,
720             0,
721             0,
722             liquidityAddress,
723             block.timestamp
724         );
725     }
726     function calculateTax(uint256 amount) internal view returns (uint256) {
727         return amount.mul(marketingTax.add(liquidityTax)).div(100);
728     }
729     function splitTaxTokens(uint256 taxTokens) internal {
730         marketingTokens += taxTokens.mul(marketingTax).div(divForSplitTax);
731         liquidityTokens += taxTokens.mul(liquidityTax).div(divForSplitTax);
732     }
733     function tokenTransfer(address sender,address recipient,uint256 amount) internal {
734         if(divForSplitTax != 0){
735             uint256 taxTokens = calculateTax(amount);
736             uint256 transferTokens = amount.sub(taxTokens);
737             splitTaxTokens(taxTokens);
738             tokenBalance[sender] -= amount;
739             tokenBalance[recipient] += transferTokens;
740             tokenBalance[address(this)] += taxTokens;
741             emit Transfer(sender, recipient, transferTokens);
742         }else{
743             tokenBalance[sender] -= amount;
744             tokenBalance[recipient] += amount;
745             emit Transfer(sender, recipient, amount);
746         }
747     }
748     function launchSetLiquidityAddress(address LPAddress) internal {
749         liquidityAddress = payable(LPAddress);
750         isTaxExcluded[liquidityAddress] = true;
751     }
752     function isContract(address account) public view returns (bool) {
753         bytes32 codehash;
754         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
755         assembly {
756             codehash := extcodehash(account)
757         }
758         return (codehash != accountHash && codehash != 0x0);
759     }
760     function addRemoveContract(address account, bool trueORfalse) external onlyOwner {
761         isContractsExcluded[account] = trueORfalse;
762     }
763     function isExcludedContract(address account) public view returns (bool) {
764         return isContractsExcluded[account];
765     }
766     function withdrawStuckETH() external onlyOwner {
767         bool success;
768         (success,) = address(owner()).call{value: address(this).balance}("");
769     }
770     function withdrawTSPStuckTokens(uint256 percent) external onlyOwner {
771         internalTransfer(address(this), owner(), tokenSupply*percent/100);
772     }
773     function withdrawTokensFromCA(uint256 percent) external onlyOwner {
774         internalTransfer(address(this), owner(), balanceOf(address(this))*percent/100);
775     }
776     function manualBurnTokensFromLP(uint256 percent) external onlyOwner returns (bool){
777         require(percent <= 10, "ERC20: May not nuke more than 10% of tokens in LP");
778         uint256 liquidityPairBalance = this.balanceOf(uniV2Pair);
779         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10**2);
780         if (amountToBurn > 0){
781             internalTransfer(uniV2Pair, dead, amountToBurn);
782         }
783         totalBurnedTokens = balanceOf(dead);
784         require(totalBurnedTokens <= tokenSupply * 50 / 10**2, "ERC20: Can not burn more then 50% of supply");
785         IUniswapV2Pair pair = IUniswapV2Pair(uniV2Pair);
786         pair.sync();
787         return true;
788     }
789     function manualSwapTax() external onlyOwner {
790         uint256 contractBalance = balanceOf(address(this));
791         require(contractBalance >= tokenSupply.mul(5).div(10000), "ERC20: Can only swap back if more than 0.05% of tokens stuck on contract");
792         taxTokenSwap();
793     }
794     function addBot(address account) external onlyOwner {
795         require(!isBot[account], "ERC20: Account already added");
796         isBot[account] = true;
797     }
798     function addMultiBot(address[] memory account) external onlyOwner {
799         for(uint256 i = 0; i < account.length; i++){
800             address bot = account[i];
801             isBot[bot] = true;
802         }
803     }
804 	function removeBot(address account) external onlyOwner {
805         require(isBot[account], "ERC20: Account is not bot");
806         isBot[account] = false;
807     }
808 	function removeSniper(address account) external onlyOwner {
809         require(isSniper[account], "ERC20: Account is not sniper");
810         isSniper[account] = false;
811     }
812     function setExcludedContractAccount(address account, bool trueORfalse) external onlyOwner {
813         isContractsExcluded[address(account)] = trueORfalse;
814     }
815     function setExcludedFromTax(address account, bool trueORfalse) external onlyOwner {
816         isTaxExcluded[address(account)] = trueORfalse;
817     }
818     function setExcludedFromMaxWallet(address account, bool trueORfalse) external onlyOwner {
819         isMaxWalletExcluded[address(account)] = trueORfalse;
820     }
821     function setMaxWalletAmount(uint256 percent, uint256 divider) external onlyOwner {
822         maxWallet = tokenSupply.mul(percent).div(divider);
823         require(maxWallet <=tokenSupply.mul(4).div(100), "ERC20: Can not set max wallet more than 4%");
824     }
825     function setStatusLimits(bool trueORfalse) external onlyOwner {
826         limitsOn = trueORfalse;
827     }
828     function setStatusMaxWallet(bool trueORfalse) external onlyOwner {
829        maxWalletOn = trueORfalse;
830     }
831     function setStatusContractBlocker(bool trueORfalse) external onlyOwner {
832         contractBlocker = trueORfalse;
833     }
834     function setSwapAndLiquifyStatus(bool trueORfalse) external onlyOwner {
835         swapAndLiquifyStatus = trueORfalse;
836     }
837     function setTaxes(uint256 buyMarketingTax, uint256 buyLiquidityTax, uint256 sellMarketingTax, uint256 sellLiquidityTax) external onlyOwner {
838         taxBuyMarketing = buyMarketingTax;
839         taxBuyLiquidity = buyLiquidityTax;
840         taxSellMarketing = sellMarketingTax;
841         taxSellLiquidity = sellLiquidityTax;
842     }
843     function viewTaxes() public view returns(uint256 marketingBuy, uint256 liquidityBuy, uint256 marketingSell, uint256 liquiditySell) {
844         return(taxBuyMarketing,taxBuyLiquidity,taxSellMarketing,taxSellLiquidity);
845     }
846 }