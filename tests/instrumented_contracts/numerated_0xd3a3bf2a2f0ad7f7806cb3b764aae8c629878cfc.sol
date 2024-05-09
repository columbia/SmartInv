1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-20
3 */
4 
5 // $EverMax | EverMax
6 // Telegram: https://t.me/EverMaxToken
7 // With thanks and major props to the EverRise team!
8 // Check them out at everrisecoin.com!
9 
10 // Fair Launch, no Dev Tokens. 100% LP.
11 // Snipers will be nuked.
12 
13 // LP Lock immediately on launch.
14 // Ownership will be renounced 30 minutes after launch.
15 
16 // Slippage Recommended: 14%+
17 // 3% Supply limit per TX for the first 5 minutes.
18 
19 /**
20 *    
21 * ___________    ____  _______ .______      .___  ___.      ___      ___   ___ 
22 *|   ____\   \  /   / |   ____||   _  \     |   \/   |     /   \     \  \ /  / 
23 *|  |__   \   \/   /  |  |__   |  |_)  |    |  \  /  |    /  ^  \     \  V  /  
24 *|   __|   \      /   |   __|  |      /     |  |\/|  |   /  /_\  \     >   <   
25 *|  |____   \    /    |  |____ |  |\  \----.|  |  |  |  /  _____  \   /  .  \  
26 *|_______|   \__/     |_______|| _| `._____||__|  |__| /__/     \__\ /__/ \__\ 
27 *                                                                              
28 */
29 
30 
31 // SPDX-License-Identifier: Unlicensed
32 
33 pragma solidity ^0.8.4;
34 
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address payable) {
37         return payable(msg.sender);
38     }
39 
40     function _msgData() internal view virtual returns (bytes memory) {
41         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
42         return msg.data;
43     }
44 }
45 
46 
47 interface IERC20 {
48 
49     function totalSupply() external view returns (uint256);
50     function balanceOf(address account) external view returns (uint256);
51     function transfer(address recipient, uint256 amount) external returns (bool);
52     function allowance(address owner, address spender) external view returns (uint256);
53     function approve(address spender, uint256 amount) external returns (bool);
54     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 
58 
59 }
60 
61 library SafeMath {
62 
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a, "SafeMath: addition overflow");
66 
67         return c;
68     }
69 
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         return sub(a, b, "SafeMath: subtraction overflow");
72     }
73 
74     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b <= a, errorMessage);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92 
93     function div(uint256 a, uint256 b) internal pure returns (uint256) {
94         return div(a, b, "SafeMath: division by zero");
95     }
96 
97     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
98         require(b > 0, errorMessage);
99         uint256 c = a / b;
100         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101 
102         return c;
103     }
104 
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         return mod(a, b, "SafeMath: modulo by zero");
107     }
108 
109     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
110         require(b != 0, errorMessage);
111         return a % b;
112     }
113 }
114 
115 library Address {
116 
117     function isContract(address account) internal view returns (bool) {
118         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
119         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
120         // for accounts without code, i.e. `keccak256('')`
121         bytes32 codehash;
122         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
123         // solhint-disable-next-line no-inline-assembly
124         assembly { codehash := extcodehash(account) }
125         return (codehash != accountHash && codehash != 0x0);
126     }
127 
128     function sendValue(address payable recipient, uint256 amount) internal {
129         require(address(this).balance >= amount, "Address: insufficient balance");
130 
131         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
132         (bool success, ) = recipient.call{ value: amount }("");
133         require(success, "Address: unable to send value, recipient may have reverted");
134     }
135 
136 
137     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
138         return functionCall(target, data, "Address: low-level call failed");
139     }
140 
141     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
142         return _functionCallWithValue(target, data, 0, errorMessage);
143     }
144 
145     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
146         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
147     }
148 
149     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
150         require(address(this).balance >= value, "Address: insufficient balance for call");
151         return _functionCallWithValue(target, data, value, errorMessage);
152     }
153 
154     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
155         require(isContract(target), "Address: call to non-contract");
156 
157         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
158         if (success) {
159             return returndata;
160         } else {
161 
162             if (returndata.length > 0) {
163                 assembly {
164                     let returndata_size := mload(returndata)
165                     revert(add(32, returndata), returndata_size)
166                 }
167             } else {
168                 revert(errorMessage);
169             }
170         }
171     }
172 }
173 
174 contract Ownable is Context {
175     address private _owner;
176     address private _previousOwner;
177     uint256 private _lockTime;
178 
179     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
180 
181     constructor () {
182         address msgSender = _msgSender();
183         _owner = msgSender;
184         emit OwnershipTransferred(address(0), msgSender);
185     }
186 
187     function owner() public view returns (address) {
188         return _owner;
189     }
190 
191     modifier onlyOwner() {
192         require(_owner == _msgSender(), "Ownable: caller is not the owner");
193         _;
194     }
195 
196     function renounceOwnership() public virtual onlyOwner {
197         emit OwnershipTransferred(_owner, address(0));
198         _owner = address(0);
199     }
200 
201     function transferOwnership(address newOwner) public virtual onlyOwner {
202         require(newOwner != address(0), "Ownable: new owner is the zero address");
203         emit OwnershipTransferred(_owner, newOwner);
204         _owner = newOwner;
205     }
206 
207     function getUnlockTime() public view returns (uint256) {
208         return _lockTime;
209     }
210 
211     function getTime() public view returns (uint256) {
212         return block.timestamp;
213     }
214 
215     function lock(uint256 time) public virtual onlyOwner {
216         _previousOwner = _owner;
217         _owner = address(0);
218         _lockTime = block.timestamp + time;
219         emit OwnershipTransferred(_owner, address(0));
220     }
221 
222     function unlock() public virtual {
223         require(_previousOwner == msg.sender, "You don't have permission to unlock");
224         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
225         emit OwnershipTransferred(_owner, _previousOwner);
226         _owner = _previousOwner;
227     }
228 }
229 
230 // pragma solidity >=0.5.0;
231 
232 interface IUniswapV2Factory {
233     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
234 
235     function feeTo() external view returns (address);
236     function feeToSetter() external view returns (address);
237 
238     function getPair(address tokenA, address tokenB) external view returns (address pair);
239     function allPairs(uint) external view returns (address pair);
240     function allPairsLength() external view returns (uint);
241 
242     function createPair(address tokenA, address tokenB) external returns (address pair);
243 
244     function setFeeTo(address) external;
245     function setFeeToSetter(address) external;
246 }
247 
248 
249 // pragma solidity >=0.5.0;
250 
251 interface IUniswapV2Pair {
252     event Approval(address indexed owner, address indexed spender, uint value);
253     event Transfer(address indexed from, address indexed to, uint value);
254 
255     function name() external pure returns (string memory);
256     function symbol() external pure returns (string memory);
257     function decimals() external pure returns (uint8);
258     function totalSupply() external view returns (uint);
259     function balanceOf(address owner) external view returns (uint);
260     function allowance(address owner, address spender) external view returns (uint);
261 
262     function approve(address spender, uint value) external returns (bool);
263     function transfer(address to, uint value) external returns (bool);
264     function transferFrom(address from, address to, uint value) external returns (bool);
265 
266     function DOMAIN_SEPARATOR() external view returns (bytes32);
267     function PERMIT_TYPEHASH() external pure returns (bytes32);
268     function nonces(address owner) external view returns (uint);
269 
270     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
271 
272     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
273     event Swap(
274         address indexed sender,
275         uint amount0In,
276         uint amount1In,
277         uint amount0Out,
278         uint amount1Out,
279         address indexed to
280     );
281     event Sync(uint112 reserve0, uint112 reserve1);
282 
283     function MINIMUM_LIQUIDITY() external pure returns (uint);
284     function factory() external view returns (address);
285     function token0() external view returns (address);
286     function token1() external view returns (address);
287     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
288     function price0CumulativeLast() external view returns (uint);
289     function price1CumulativeLast() external view returns (uint);
290     function kLast() external view returns (uint);
291 
292     function burn(address to) external returns (uint amount0, uint amount1);
293     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
294     function skim(address to) external;
295     function sync() external;
296 
297     function initialize(address, address) external;
298 }
299 
300 // pragma solidity >=0.6.2;
301 
302 interface IUniswapV2Router01 {
303     function factory() external pure returns (address);
304     function WETH() external pure returns (address);
305 
306     function addLiquidity(
307         address tokenA,
308         address tokenB,
309         uint amountADesired,
310         uint amountBDesired,
311         uint amountAMin,
312         uint amountBMin,
313         address to,
314         uint deadline
315     ) external returns (uint amountA, uint amountB, uint liquidity);
316     function addLiquidityETH(
317         address token,
318         uint amountTokenDesired,
319         uint amountTokenMin,
320         uint amountETHMin,
321         address to,
322         uint deadline
323     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
324     function removeLiquidity(
325         address tokenA,
326         address tokenB,
327         uint liquidity,
328         uint amountAMin,
329         uint amountBMin,
330         address to,
331         uint deadline
332     ) external returns (uint amountA, uint amountB);
333     function removeLiquidityETH(
334         address token,
335         uint liquidity,
336         uint amountTokenMin,
337         uint amountETHMin,
338         address to,
339         uint deadline
340     ) external returns (uint amountToken, uint amountETH);
341     function removeLiquidityWithPermit(
342         address tokenA,
343         address tokenB,
344         uint liquidity,
345         uint amountAMin,
346         uint amountBMin,
347         address to,
348         uint deadline,
349         bool approveMax, uint8 v, bytes32 r, bytes32 s
350     ) external returns (uint amountA, uint amountB);
351     function removeLiquidityETHWithPermit(
352         address token,
353         uint liquidity,
354         uint amountTokenMin,
355         uint amountETHMin,
356         address to,
357         uint deadline,
358         bool approveMax, uint8 v, bytes32 r, bytes32 s
359     ) external returns (uint amountToken, uint amountETH);
360     function swapExactTokensForTokens(
361         uint amountIn,
362         uint amountOutMin,
363         address[] calldata path,
364         address to,
365         uint deadline
366     ) external returns (uint[] memory amounts);
367     function swapTokensForExactTokens(
368         uint amountOut,
369         uint amountInMax,
370         address[] calldata path,
371         address to,
372         uint deadline
373     ) external returns (uint[] memory amounts);
374     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
375     external
376     payable
377     returns (uint[] memory amounts);
378     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
379     external
380     returns (uint[] memory amounts);
381     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
382     external
383     returns (uint[] memory amounts);
384     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
385     external
386     payable
387     returns (uint[] memory amounts);
388 
389     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
390     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
391     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
392     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
393     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
394 }
395 
396 
397 
398 // pragma solidity >=0.6.2;
399 
400 interface IUniswapV2Router02 is IUniswapV2Router01 {
401     function removeLiquidityETHSupportingFeeOnTransferTokens(
402         address token,
403         uint liquidity,
404         uint amountTokenMin,
405         uint amountETHMin,
406         address to,
407         uint deadline
408     ) external returns (uint amountETH);
409     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
410         address token,
411         uint liquidity,
412         uint amountTokenMin,
413         uint amountETHMin,
414         address to,
415         uint deadline,
416         bool approveMax, uint8 v, bytes32 r, bytes32 s
417     ) external returns (uint amountETH);
418 
419     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
420         uint amountIn,
421         uint amountOutMin,
422         address[] calldata path,
423         address to,
424         uint deadline
425     ) external;
426     function swapExactETHForTokensSupportingFeeOnTransferTokens(
427         uint amountOutMin,
428         address[] calldata path,
429         address to,
430         uint deadline
431     ) external payable;
432     function swapExactTokensForETHSupportingFeeOnTransferTokens(
433         uint amountIn,
434         uint amountOutMin,
435         address[] calldata path,
436         address to,
437         uint deadline
438     ) external;
439 }
440 
441 contract EverMax is Context, IERC20, Ownable {
442     using SafeMath for uint256;
443     using Address for address;
444 
445     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
446     mapping (address => uint256) private _rOwned;
447     mapping (address => uint256) private _tOwned;
448     mapping (address => mapping (address => uint256)) private _allowances;
449 
450     mapping (address => bool) private _isSniper;
451     address[] private _confirmedSnipers;
452 
453     mapping (address => bool) private _isExcludedFromFee;
454     mapping (address => bool) private _isExcluded;
455     address[] private _excluded;
456 
457     uint256 private constant MAX = ~uint256(0);
458     uint256 private _tTotal = 1000000000000000000000000;
459     uint256 private _rTotal = (MAX - (MAX % _tTotal));
460     uint256 private _tFeeTotal;
461 
462     string private _name = "EverMax | t.me/EverMaxToken";
463     string private _symbol = "EverMax \xf0\x9f\x92\xb9"; 
464     uint8 private _decimals = 9;
465 
466     uint256 public launchTime;
467     uint256 public _taxFee = 1;
468     uint256 private _previousTaxFee = _taxFee;
469     address payable private teamDevAddress;
470 
471     uint256 public _liquidityFee = 12;
472     uint256 private _previousLiquidityFee = _liquidityFee;
473 
474     uint256 public splitDivisor = 10;
475 
476     uint256 public _maxTxAmount = 30000000000000000000000;
477     uint256 private minimumTokensBeforeSwap = 5000000000000000000;
478     uint256 private buyBackUpperLimit = 1 * 10**21;
479 
480     bool public tradingOpen = false; //once switched on, can never be switched off.
481 
482 
483     IUniswapV2Router02 public uniswapV2Router;
484     address public uniswapV2Pair;
485 
486     bool inSwapAndLiquify;
487     bool public swapAndLiquifyEnabled = false;
488     bool public buyBackEnabled = true;
489 
490 
491     event RewardLiquidityProviders(uint256 tokenAmount);
492     event BuyBackEnabledUpdated(bool enabled);
493     event SwapAndLiquifyEnabledUpdated(bool enabled);
494     event SwapAndLiquify(
495         uint256 tokensSwapped,
496         uint256 ethReceived,
497         uint256 tokensIntoLiqudity
498     );
499 
500     event SwapETHForTokens(
501         uint256 amountIn,
502         address[] path
503     );
504 
505     event SwapTokensForETH(
506         uint256 amountIn,
507         address[] path
508     );
509 
510     modifier lockTheSwap {
511         inSwapAndLiquify = true;
512         _;
513         inSwapAndLiquify = false;
514     }
515 
516     constructor () {
517         _rOwned[_msgSender()] = _rTotal;
518 
519         emit Transfer(address(0), _msgSender(), _tTotal);
520     }
521 
522     function openTrading() external onlyOwner() {
523         swapAndLiquifyEnabled = true;
524         tradingOpen = true;
525         launchTime = block.timestamp;
526         //setSwapAndLiquifyEnabled(true);
527     }
528 
529     function initContract() external onlyOwner() {
530         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
531         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
532         .createPair(address(this), _uniswapV2Router.WETH());
533 
534         uniswapV2Router = _uniswapV2Router;
535 
536         _isExcludedFromFee[owner()] = true;
537         _isExcludedFromFee[address(this)] = true;
538 
539         // List of front-runner & sniper bots from t.me/FairLaunchCalls
540         _isSniper[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
541         _confirmedSnipers.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
542 
543         _isSniper[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
544         _confirmedSnipers.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
545 
546         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
547         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
548 
549         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
550         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
551 
552         _isSniper[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
553         _confirmedSnipers.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
554 
555         _isSniper[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
556         _confirmedSnipers.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
557 
558         _isSniper[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
559         _confirmedSnipers.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
560 
561         _isSniper[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
562         _confirmedSnipers.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
563 
564         _isSniper[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
565         _confirmedSnipers.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
566 
567         _isSniper[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
568         _confirmedSnipers.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
569 
570         _isSniper[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
571         _confirmedSnipers.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
572 
573         _isSniper[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
574         _confirmedSnipers.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
575 
576         _isSniper[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
577         _confirmedSnipers.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
578 
579         _isSniper[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
580         _confirmedSnipers.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
581 
582         _isSniper[address(0x000000000000084e91743124a982076C59f10084)] = true;
583         _confirmedSnipers.push(address(0x000000000000084e91743124a982076C59f10084));
584 
585         _isSniper[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
586         _confirmedSnipers.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
587 
588         _isSniper[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
589         _confirmedSnipers.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
590 
591         _isSniper[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
592         _confirmedSnipers.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
593 
594         _isSniper[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
595         _confirmedSnipers.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
596 
597         _isSniper[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
598         _confirmedSnipers.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
599 
600         _isSniper[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
601         _confirmedSnipers.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
602 
603         _isSniper[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
604         _confirmedSnipers.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
605 
606         _isSniper[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
607         _confirmedSnipers.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
608 
609         _isSniper[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
610         _confirmedSnipers.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
611 
612         _isSniper[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
613         _confirmedSnipers.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
614 
615         _isSniper[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
616         _confirmedSnipers.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
617 
618         _isSniper[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
619         _confirmedSnipers.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
620 
621         _isSniper[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
622         _confirmedSnipers.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
623 
624         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
625         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
626 
627         _isSniper[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
628         _confirmedSnipers.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
629 
630         _isSniper[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
631         _confirmedSnipers.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
632 
633         _isSniper[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
634         _confirmedSnipers.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
635 
636         _isSniper[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
637         _confirmedSnipers.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
638 
639         _isSniper[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
640         _confirmedSnipers.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
641 
642         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
643         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
644 
645         _isSniper[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
646         _confirmedSnipers.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
647 
648         _isSniper[address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02)] = true;
649         _confirmedSnipers.push(address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02));
650 
651         _isSniper[address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850)] = true;
652         _confirmedSnipers.push(address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850));
653 
654         _isSniper[address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37)] = true;
655         _confirmedSnipers.push(address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37));
656 
657         _isSniper[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
658         _confirmedSnipers.push(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
659 
660         _isSniper[address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A)] = true;
661         _confirmedSnipers.push(address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A));
662 
663         _isSniper[address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65)] = true;
664         _confirmedSnipers.push(address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65));
665 
666         _isSniper[address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3)] = true;
667         _confirmedSnipers.push(address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3));
668 
669         _isSniper[address(0xD334C5392eD4863C81576422B968C6FB90EE9f79)] = true;
670         _confirmedSnipers.push(address(0xD334C5392eD4863C81576422B968C6FB90EE9f79));
671 
672         _isSniper[address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7)] = true;
673         _confirmedSnipers.push(address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7));
674 
675         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
676         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
677 
678         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
679         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
680 
681         teamDevAddress = payable(0xa8FB832AfdB227B33359Fd625f09Ef5681e2608F);
682     }
683 
684     function name() public view returns (string memory) {
685         return _name;
686     }
687 
688     function symbol() public view returns (string memory) {
689         return _symbol;
690     }
691 
692     function decimals() public view returns (uint8) {
693         return _decimals;
694     }
695 
696     function totalSupply() public view override returns (uint256) {
697         return _tTotal;
698     }
699 
700     function balanceOf(address account) public view override returns (uint256) {
701         if (_isExcluded[account]) return _tOwned[account];
702         return tokenFromReflection(_rOwned[account]);
703     }
704 
705     function transfer(address recipient, uint256 amount) public override returns (bool) {
706         _transfer(_msgSender(), recipient, amount);
707         return true;
708     }
709 
710     function allowance(address owner, address spender) public view override returns (uint256) {
711         return _allowances[owner][spender];
712     }
713 
714     function approve(address spender, uint256 amount) public override returns (bool) {
715         _approve(_msgSender(), spender, amount);
716         return true;
717     }
718 
719     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
720         _transfer(sender, recipient, amount);
721         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
722         return true;
723     }
724 
725     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
726         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
727         return true;
728     }
729 
730     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
731         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
732         return true;
733     }
734 
735     function isExcludedFromReward(address account) public view returns (bool) {
736         return _isExcluded[account];
737     }
738 
739     function totalFees() public view returns (uint256) {
740         return _tFeeTotal;
741     }
742 
743     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
744         return minimumTokensBeforeSwap;
745     }
746 
747     function buyBackUpperLimitAmount() public view returns (uint256) {
748         return buyBackUpperLimit;
749     }
750 
751     function deliver(uint256 tAmount) public {
752         address sender = _msgSender();
753         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
754         (uint256 rAmount,,,,,) = _getValues(tAmount);
755         _rOwned[sender] = _rOwned[sender].sub(rAmount);
756         _rTotal = _rTotal.sub(rAmount);
757         _tFeeTotal = _tFeeTotal.add(tAmount);
758     }
759 
760 
761     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
762         require(tAmount <= _tTotal, "Amount must be less than supply");
763         if (!deductTransferFee) {
764             (uint256 rAmount,,,,,) = _getValues(tAmount);
765             return rAmount;
766         } else {
767             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
768             return rTransferAmount;
769         }
770     }
771 
772     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
773         require(rAmount <= _rTotal, "Amount must be less than total reflections");
774         uint256 currentRate =  _getRate();
775         return rAmount.div(currentRate);
776     }
777 
778     function excludeFromReward(address account) public onlyOwner() {
779 
780         require(!_isExcluded[account], "Account is already excluded");
781         if(_rOwned[account] > 0) {
782             _tOwned[account] = tokenFromReflection(_rOwned[account]);
783         }
784         _isExcluded[account] = true;
785         _excluded.push(account);
786     }
787 
788     function isRemovedSniper(address account) public view returns (bool) {
789         return _isSniper[account];
790     }
791 
792     function includeInReward(address account) external onlyOwner() {
793         require(_isExcluded[account], "Account is already excluded");
794         for (uint256 i = 0; i < _excluded.length; i++) {
795             if (_excluded[i] == account) {
796                 _excluded[i] = _excluded[_excluded.length - 1];
797                 _tOwned[account] = 0;
798                 _isExcluded[account] = false;
799                 _excluded.pop();
800                 break;
801             }
802         }
803     }
804 
805     function _approve(address owner, address spender, uint256 amount) private {
806         require(owner != address(0), "ERC20: approve from the zero address");
807         require(spender != address(0), "ERC20: approve to the zero address");
808 
809         _allowances[owner][spender] = amount;
810         emit Approval(owner, spender, amount);
811     }
812 
813     function _transfer(
814         address sender,
815         address recipient,
816         uint256 amount
817     ) private {
818         require(sender != address(0), "ERC20: transfer from the zero address");
819         require(recipient != address(0), "ERC20: transfer to the zero address");
820         require(amount > 0, "Transfer amount must be greater than zero");
821         require(!_isSniper[recipient], "You have no power here!");
822         require(!_isSniper[msg.sender], "You have no power here!");
823 
824 
825         if(sender != owner() && recipient != owner()) {
826             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
827             if (!tradingOpen) {
828                 if (!(sender == address(this) || recipient == address(this)
829                 || sender == address(owner()) || recipient == address(owner()))) {
830                     require(tradingOpen, "Trading is not enabled");
831                 }
832             }
833 
834             if (block.timestamp < launchTime + 15 seconds) {
835                 if (sender != uniswapV2Pair
836                 && sender != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
837                     && sender != address(uniswapV2Router)) {
838                     _isSniper[sender] = true;
839                     _confirmedSnipers.push(sender);
840                 }
841             }
842         }
843 
844         uint256 contractTokenBalance = balanceOf(address(this));
845         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
846 
847         if (!inSwapAndLiquify && swapAndLiquifyEnabled && recipient == uniswapV2Pair) {
848             if (overMinimumTokenBalance) {
849                 contractTokenBalance = minimumTokensBeforeSwap;
850                 swapTokens(contractTokenBalance);
851             }
852             uint256 balance = address(this).balance;
853             if (buyBackEnabled && balance > uint256(1 * 10**18)) {
854 
855                 if (balance > buyBackUpperLimit)
856                     balance = buyBackUpperLimit;
857 
858                 buyBackTokens(balance.div(100));
859             }
860         }
861 
862         bool takeFee = true;
863 
864         //if any account belongs to _isExcludedFromFee account then remove the fee
865         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
866             takeFee = false;
867         }
868 
869         _tokenTransfer(sender, recipient,amount,takeFee);
870     }
871 
872     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
873 
874         uint256 initialBalance = address(this).balance;
875         swapTokensForEth(contractTokenBalance);
876         uint256 transferredBalance = address(this).balance.sub(initialBalance);
877 
878         transferToAddressETH(teamDevAddress, transferredBalance.div(_liquidityFee).mul(splitDivisor));
879 
880     }
881 
882 
883     function buyBackTokens(uint256 amount) private lockTheSwap {
884         if (amount > 0) {
885             swapETHForTokens(amount);
886         }
887     }
888 
889     function swapTokensForEth(uint256 tokenAmount) private {
890         // generate the uniswap pair path of token -> weth
891         address[] memory path = new address[](2);
892         path[0] = address(this);
893         path[1] = uniswapV2Router.WETH();
894 
895         _approve(address(this), address(uniswapV2Router), tokenAmount);
896 
897         // make the swap
898         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
899             tokenAmount,
900             0, // accept any amount of ETH
901             path,
902             address(this), // The contract
903             block.timestamp
904         );
905 
906         emit SwapTokensForETH(tokenAmount, path);
907     }
908 
909     function swapETHForTokens(uint256 amount) private {
910         // generate the uniswap pair path of token -> weth
911         address[] memory path = new address[](2);
912         path[0] = uniswapV2Router.WETH();
913         path[1] = address(this);
914 
915         // make the swap
916         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
917             0, // accept any amount of Tokens
918             path,
919             deadAddress, // Burn address
920             block.timestamp.add(300)
921         );
922 
923         emit SwapETHForTokens(amount, path);
924     }
925 
926     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
927         // approve token transfer to cover all possible scenarios
928         _approve(address(this), address(uniswapV2Router), tokenAmount);
929 
930         // add the liquidity
931         uniswapV2Router.addLiquidityETH{value: ethAmount}(
932             address(this),
933             tokenAmount,
934             0, // slippage is unavoidable
935             0, // slippage is unavoidable
936             owner(),
937             block.timestamp
938         );
939     }
940 
941     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
942         if(!takeFee)
943             removeAllFee();
944 
945         if (_isExcluded[sender] && !_isExcluded[recipient]) {
946             _transferFromExcluded(sender, recipient, amount);
947         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
948             _transferToExcluded(sender, recipient, amount);
949         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
950             _transferBothExcluded(sender, recipient, amount);
951         } else {
952             _transferStandard(sender, recipient, amount);
953         }
954 
955         if(!takeFee)
956             restoreAllFee();
957     }
958 
959     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
960         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
961         _rOwned[sender] = _rOwned[sender].sub(rAmount);
962         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
963         _takeLiquidity(tLiquidity);
964         _reflectFee(rFee, tFee);
965         emit Transfer(sender, recipient, tTransferAmount);
966     }
967 
968     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
969         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
970         _rOwned[sender] = _rOwned[sender].sub(rAmount);
971         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
972         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
973         _takeLiquidity(tLiquidity);
974         _reflectFee(rFee, tFee);
975         emit Transfer(sender, recipient, tTransferAmount);
976     }
977 
978     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
979         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
980         _tOwned[sender] = _tOwned[sender].sub(tAmount);
981         _rOwned[sender] = _rOwned[sender].sub(rAmount);
982         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
983         _takeLiquidity(tLiquidity);
984         _reflectFee(rFee, tFee);
985         emit Transfer(sender, recipient, tTransferAmount);
986     }
987 
988     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
989         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
990         _tOwned[sender] = _tOwned[sender].sub(tAmount);
991         _rOwned[sender] = _rOwned[sender].sub(rAmount);
992         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
993         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
994         _takeLiquidity(tLiquidity);
995         _reflectFee(rFee, tFee);
996         emit Transfer(sender, recipient, tTransferAmount);
997     }
998 
999     function _reflectFee(uint256 rFee, uint256 tFee) private {
1000         _rTotal = _rTotal.sub(rFee);
1001         _tFeeTotal = _tFeeTotal.add(tFee);
1002     }
1003 
1004     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1005         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1006         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1007         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1008     }
1009 
1010     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1011         uint256 tFee = calculateTaxFee(tAmount);
1012         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1013         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1014         return (tTransferAmount, tFee, tLiquidity);
1015     }
1016 
1017     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1018         uint256 rAmount = tAmount.mul(currentRate);
1019         uint256 rFee = tFee.mul(currentRate);
1020         uint256 rLiquidity = tLiquidity.mul(currentRate);
1021         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1022         return (rAmount, rTransferAmount, rFee);
1023     }
1024 
1025     function _getRate() private view returns(uint256) {
1026         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1027         return rSupply.div(tSupply);
1028     }
1029 
1030     function _getCurrentSupply() private view returns(uint256, uint256) {
1031         uint256 rSupply = _rTotal;
1032         uint256 tSupply = _tTotal;
1033         for (uint256 i = 0; i < _excluded.length; i++) {
1034             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1035             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1036             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1037         }
1038         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1039         return (rSupply, tSupply);
1040     }
1041 
1042     function _takeLiquidity(uint256 tLiquidity) private {
1043         uint256 currentRate =  _getRate();
1044         uint256 rLiquidity = tLiquidity.mul(currentRate);
1045         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1046         if(_isExcluded[address(this)])
1047             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1048     }
1049 
1050     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1051         return _amount.mul(_taxFee).div(
1052             10**2
1053         );
1054     }
1055 
1056     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1057         return _amount.mul(_liquidityFee).div(
1058             10**2
1059         );
1060     }
1061 
1062     function removeAllFee() private {
1063         if(_taxFee == 0 && _liquidityFee == 0) return;
1064 
1065         _previousTaxFee = _taxFee;
1066         _previousLiquidityFee = _liquidityFee;
1067 
1068         _taxFee = 0;
1069         _liquidityFee = 0;
1070     }
1071 
1072     function restoreAllFee() private {
1073         _taxFee = _previousTaxFee;
1074         _liquidityFee = _previousLiquidityFee;
1075     }
1076 
1077     function isExcludedFromFee(address account) public view returns(bool) {
1078         return _isExcludedFromFee[account];
1079     }
1080 
1081     function excludeFromFee(address account) public onlyOwner {
1082         _isExcludedFromFee[account] = true;
1083     }
1084 
1085     function includeInFee(address account) public onlyOwner {
1086         _isExcludedFromFee[account] = false;
1087     }
1088 
1089     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1090         _taxFee = taxFee;
1091     }
1092 
1093     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1094         _liquidityFee = liquidityFee;
1095     }
1096 
1097     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1098         _maxTxAmount = maxTxAmount;
1099     }
1100 
1101     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
1102         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
1103     }
1104 
1105     function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
1106         buyBackUpperLimit = buyBackLimit * 10**18;
1107     }
1108 
1109     function setTeamDevAddress(address _teamDevAddress) external onlyOwner() {
1110         teamDevAddress = payable(_teamDevAddress);
1111     }
1112 
1113     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1114         swapAndLiquifyEnabled = _enabled;
1115         emit SwapAndLiquifyEnabledUpdated(_enabled);
1116     }
1117 
1118     function setBuyBackEnabled(bool _enabled) public onlyOwner {
1119         buyBackEnabled = _enabled;
1120         emit BuyBackEnabledUpdated(_enabled);
1121     }
1122 
1123     function transferToAddressETH(address payable recipient, uint256 amount) private {
1124         recipient.transfer(amount);
1125     }
1126 
1127     function _removeSniper(address account) external onlyOwner() {
1128         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap');
1129         require(!_isSniper[account], "Account is already blacklisted");
1130         _isSniper[account] = true;
1131         _confirmedSnipers.push(account);
1132     }
1133 
1134     function _amnestySniper(address account) external onlyOwner() {
1135         require(_isSniper[account], "Account is not blacklisted");
1136         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1137             if (_confirmedSnipers[i] == account) {
1138                 _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
1139                 _isSniper[account] = false;
1140                 _confirmedSnipers.pop();
1141                 break;
1142             }
1143         }
1144     }
1145 
1146     function _removeTxLimit() external onlyOwner() {
1147         _maxTxAmount = 1000000000000000000000000;
1148     }
1149 
1150     //to recieve ETH from uniswapV2Router when swapping
1151     receive() external payable {}
1152 }