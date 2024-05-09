1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-20
3 */
4 
5 // $EverSpace | EverSpace
6 // Telegram: https://t.me/EverSpaceOfficial
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
21 *
22 *     ______                _____                     
23 *    / ____/   _____  _____/ ___/____  ____ _________ 
24 *   / __/ | | / / _ \/ ___/\__ \/ __ \/ __ `/ ___/ _ \
25 *  / /___ | |/ /  __/ /   ___/ / /_/ / /_/ / /__/  __/
26 * /_____/ |___/\___/_/   /____/ .___/\__,_/\___/\___/ 
27 *                           /_/                      
28 *                                                                              
29 */
30 
31 
32 // SPDX-License-Identifier: Unlicensed
33 
34 pragma solidity ^0.8.4;
35 
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address payable) {
38         return payable(msg.sender);
39     }
40 
41     function _msgData() internal view virtual returns (bytes memory) {
42         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
43         return msg.data;
44     }
45 }
46 
47 
48 interface IERC20 {
49 
50     function totalSupply() external view returns (uint256);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 
59 
60 }
61 
62 library SafeMath {
63 
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a, "SafeMath: addition overflow");
67 
68         return c;
69     }
70 
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93 
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97 
98     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         require(b > 0, errorMessage);
100         uint256 c = a / b;
101         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102 
103         return c;
104     }
105 
106     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
107         return mod(a, b, "SafeMath: modulo by zero");
108     }
109 
110     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
111         require(b != 0, errorMessage);
112         return a % b;
113     }
114 }
115 
116 library Address {
117 
118     function isContract(address account) internal view returns (bool) {
119         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
120         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
121         // for accounts without code, i.e. `keccak256('')`
122         bytes32 codehash;
123         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
124         // solhint-disable-next-line no-inline-assembly
125         assembly { codehash := extcodehash(account) }
126         return (codehash != accountHash && codehash != 0x0);
127     }
128 
129     function sendValue(address payable recipient, uint256 amount) internal {
130         require(address(this).balance >= amount, "Address: insufficient balance");
131 
132         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
133         (bool success, ) = recipient.call{ value: amount }("");
134         require(success, "Address: unable to send value, recipient may have reverted");
135     }
136 
137 
138     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
139         return functionCall(target, data, "Address: low-level call failed");
140     }
141 
142     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
143         return _functionCallWithValue(target, data, 0, errorMessage);
144     }
145 
146     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
147         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
148     }
149 
150     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
151         require(address(this).balance >= value, "Address: insufficient balance for call");
152         return _functionCallWithValue(target, data, value, errorMessage);
153     }
154 
155     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
156         require(isContract(target), "Address: call to non-contract");
157 
158         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
159         if (success) {
160             return returndata;
161         } else {
162 
163             if (returndata.length > 0) {
164                 assembly {
165                     let returndata_size := mload(returndata)
166                     revert(add(32, returndata), returndata_size)
167                 }
168             } else {
169                 revert(errorMessage);
170             }
171         }
172     }
173 }
174 
175 contract Ownable is Context {
176     address private _owner;
177     address private _previousOwner;
178     uint256 private _lockTime;
179 
180     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
181 
182     constructor () {
183         address msgSender = _msgSender();
184         _owner = msgSender;
185         emit OwnershipTransferred(address(0), msgSender);
186     }
187 
188     function owner() public view returns (address) {
189         return _owner;
190     }
191 
192     modifier onlyOwner() {
193         require(_owner == _msgSender(), "Ownable: caller is not the owner");
194         _;
195     }
196 
197     function renounceOwnership() public virtual onlyOwner {
198         emit OwnershipTransferred(_owner, address(0));
199         _owner = address(0);
200     }
201 
202     function transferOwnership(address newOwner) public virtual onlyOwner {
203         require(newOwner != address(0), "Ownable: new owner is the zero address");
204         emit OwnershipTransferred(_owner, newOwner);
205         _owner = newOwner;
206     }
207 
208     function getUnlockTime() public view returns (uint256) {
209         return _lockTime;
210     }
211 
212     function getTime() public view returns (uint256) {
213         return block.timestamp;
214     }
215 
216     function lock(uint256 time) public virtual onlyOwner {
217         _previousOwner = _owner;
218         _owner = address(0);
219         _lockTime = block.timestamp + time;
220         emit OwnershipTransferred(_owner, address(0));
221     }
222 
223     function unlock() public virtual {
224         require(_previousOwner == msg.sender, "You don't have permission to unlock");
225         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
226         emit OwnershipTransferred(_owner, _previousOwner);
227         _owner = _previousOwner;
228     }
229 }
230 
231 // pragma solidity >=0.5.0;
232 
233 interface IUniswapV2Factory {
234     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
235 
236     function feeTo() external view returns (address);
237     function feeToSetter() external view returns (address);
238 
239     function getPair(address tokenA, address tokenB) external view returns (address pair);
240     function allPairs(uint) external view returns (address pair);
241     function allPairsLength() external view returns (uint);
242 
243     function createPair(address tokenA, address tokenB) external returns (address pair);
244 
245     function setFeeTo(address) external;
246     function setFeeToSetter(address) external;
247 }
248 
249 
250 // pragma solidity >=0.5.0;
251 
252 interface IUniswapV2Pair {
253     event Approval(address indexed owner, address indexed spender, uint value);
254     event Transfer(address indexed from, address indexed to, uint value);
255 
256     function name() external pure returns (string memory);
257     function symbol() external pure returns (string memory);
258     function decimals() external pure returns (uint8);
259     function totalSupply() external view returns (uint);
260     function balanceOf(address owner) external view returns (uint);
261     function allowance(address owner, address spender) external view returns (uint);
262 
263     function approve(address spender, uint value) external returns (bool);
264     function transfer(address to, uint value) external returns (bool);
265     function transferFrom(address from, address to, uint value) external returns (bool);
266 
267     function DOMAIN_SEPARATOR() external view returns (bytes32);
268     function PERMIT_TYPEHASH() external pure returns (bytes32);
269     function nonces(address owner) external view returns (uint);
270 
271     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
272 
273     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
274     event Swap(
275         address indexed sender,
276         uint amount0In,
277         uint amount1In,
278         uint amount0Out,
279         uint amount1Out,
280         address indexed to
281     );
282     event Sync(uint112 reserve0, uint112 reserve1);
283 
284     function MINIMUM_LIQUIDITY() external pure returns (uint);
285     function factory() external view returns (address);
286     function token0() external view returns (address);
287     function token1() external view returns (address);
288     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
289     function price0CumulativeLast() external view returns (uint);
290     function price1CumulativeLast() external view returns (uint);
291     function kLast() external view returns (uint);
292 
293     function burn(address to) external returns (uint amount0, uint amount1);
294     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
295     function skim(address to) external;
296     function sync() external;
297 
298     function initialize(address, address) external;
299 }
300 
301 // pragma solidity >=0.6.2;
302 
303 interface IUniswapV2Router01 {
304     function factory() external pure returns (address);
305     function WETH() external pure returns (address);
306 
307     function addLiquidity(
308         address tokenA,
309         address tokenB,
310         uint amountADesired,
311         uint amountBDesired,
312         uint amountAMin,
313         uint amountBMin,
314         address to,
315         uint deadline
316     ) external returns (uint amountA, uint amountB, uint liquidity);
317     function addLiquidityETH(
318         address token,
319         uint amountTokenDesired,
320         uint amountTokenMin,
321         uint amountETHMin,
322         address to,
323         uint deadline
324     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
325     function removeLiquidity(
326         address tokenA,
327         address tokenB,
328         uint liquidity,
329         uint amountAMin,
330         uint amountBMin,
331         address to,
332         uint deadline
333     ) external returns (uint amountA, uint amountB);
334     function removeLiquidityETH(
335         address token,
336         uint liquidity,
337         uint amountTokenMin,
338         uint amountETHMin,
339         address to,
340         uint deadline
341     ) external returns (uint amountToken, uint amountETH);
342     function removeLiquidityWithPermit(
343         address tokenA,
344         address tokenB,
345         uint liquidity,
346         uint amountAMin,
347         uint amountBMin,
348         address to,
349         uint deadline,
350         bool approveMax, uint8 v, bytes32 r, bytes32 s
351     ) external returns (uint amountA, uint amountB);
352     function removeLiquidityETHWithPermit(
353         address token,
354         uint liquidity,
355         uint amountTokenMin,
356         uint amountETHMin,
357         address to,
358         uint deadline,
359         bool approveMax, uint8 v, bytes32 r, bytes32 s
360     ) external returns (uint amountToken, uint amountETH);
361     function swapExactTokensForTokens(
362         uint amountIn,
363         uint amountOutMin,
364         address[] calldata path,
365         address to,
366         uint deadline
367     ) external returns (uint[] memory amounts);
368     function swapTokensForExactTokens(
369         uint amountOut,
370         uint amountInMax,
371         address[] calldata path,
372         address to,
373         uint deadline
374     ) external returns (uint[] memory amounts);
375     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
376     external
377     payable
378     returns (uint[] memory amounts);
379     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
380     external
381     returns (uint[] memory amounts);
382     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
383     external
384     returns (uint[] memory amounts);
385     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
386     external
387     payable
388     returns (uint[] memory amounts);
389 
390     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
391     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
392     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
393     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
394     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
395 }
396 
397 
398 
399 // pragma solidity >=0.6.2;
400 
401 interface IUniswapV2Router02 is IUniswapV2Router01 {
402     function removeLiquidityETHSupportingFeeOnTransferTokens(
403         address token,
404         uint liquidity,
405         uint amountTokenMin,
406         uint amountETHMin,
407         address to,
408         uint deadline
409     ) external returns (uint amountETH);
410     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
411         address token,
412         uint liquidity,
413         uint amountTokenMin,
414         uint amountETHMin,
415         address to,
416         uint deadline,
417         bool approveMax, uint8 v, bytes32 r, bytes32 s
418     ) external returns (uint amountETH);
419 
420     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
421         uint amountIn,
422         uint amountOutMin,
423         address[] calldata path,
424         address to,
425         uint deadline
426     ) external;
427     function swapExactETHForTokensSupportingFeeOnTransferTokens(
428         uint amountOutMin,
429         address[] calldata path,
430         address to,
431         uint deadline
432     ) external payable;
433     function swapExactTokensForETHSupportingFeeOnTransferTokens(
434         uint amountIn,
435         uint amountOutMin,
436         address[] calldata path,
437         address to,
438         uint deadline
439     ) external;
440 }
441 
442 contract EverSpace is Context, IERC20, Ownable {
443     using SafeMath for uint256;
444     using Address for address;
445 
446     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
447     mapping (address => uint256) private _rOwned;
448     mapping (address => uint256) private _tOwned;
449     mapping (address => mapping (address => uint256)) private _allowances;
450 
451     mapping (address => bool) private _isSniper;
452     address[] private _confirmedSnipers;
453 
454     mapping (address => bool) private _isExcludedFromFee;
455     mapping (address => bool) private _isExcluded;
456     address[] private _excluded;
457 
458     uint256 private constant MAX = ~uint256(0);
459     uint256 private _tTotal = 1000000000000000000000000;
460     uint256 private _rTotal = (MAX - (MAX % _tTotal));
461     uint256 private _tFeeTotal;
462 
463     string private _name = "EverSpace | t.me/EverSpaceOfficial";
464     string private _symbol = "EverSpace \xF0\x9F\x9A\x80"; 
465     uint8 private _decimals = 9;
466 
467     uint256 public launchTime;
468     uint256 public _taxFee = 1;
469     uint256 private _previousTaxFee = _taxFee;
470     address payable private teamDevAddress;
471 
472     uint256 public _liquidityFee = 12;
473     uint256 private _previousLiquidityFee = _liquidityFee;
474 
475     uint256 public splitDivisor = 10;
476 
477     uint256 public _maxTxAmount = 30000000000000000000000;
478     uint256 private minimumTokensBeforeSwap = 5000000000000000000;
479     uint256 private buyBackUpperLimit = 1 * 10**21;
480 
481     bool public tradingOpen = false; //once switched on, can never be switched off.
482 
483 
484     IUniswapV2Router02 public uniswapV2Router;
485     address public uniswapV2Pair;
486 
487     bool inSwapAndLiquify;
488     bool public swapAndLiquifyEnabled = false;
489     bool public buyBackEnabled = true;
490 
491 
492     event RewardLiquidityProviders(uint256 tokenAmount);
493     event BuyBackEnabledUpdated(bool enabled);
494     event SwapAndLiquifyEnabledUpdated(bool enabled);
495     event SwapAndLiquify(
496         uint256 tokensSwapped,
497         uint256 ethReceived,
498         uint256 tokensIntoLiqudity
499     );
500 
501     event SwapETHForTokens(
502         uint256 amountIn,
503         address[] path
504     );
505 
506     event SwapTokensForETH(
507         uint256 amountIn,
508         address[] path
509     );
510 
511     modifier lockTheSwap {
512         inSwapAndLiquify = true;
513         _;
514         inSwapAndLiquify = false;
515     }
516 
517     constructor () {
518         _rOwned[_msgSender()] = _rTotal;
519 
520         emit Transfer(address(0), _msgSender(), _tTotal);
521     }
522 
523     function openTrading() external onlyOwner() {
524         swapAndLiquifyEnabled = true;
525         tradingOpen = true;
526         launchTime = block.timestamp;
527         //setSwapAndLiquifyEnabled(true);
528     }
529 
530     function initContract() external onlyOwner() {
531         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
532         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
533         .createPair(address(this), _uniswapV2Router.WETH());
534 
535         uniswapV2Router = _uniswapV2Router;
536 
537         _isExcludedFromFee[owner()] = true;
538         _isExcludedFromFee[address(this)] = true;
539 
540         // List of front-runner & sniper bots from t.me/FairLaunchCalls
541         _isSniper[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
542         _confirmedSnipers.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
543 
544         _isSniper[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
545         _confirmedSnipers.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
546 
547         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
548         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
549 
550         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
551         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
552 
553         _isSniper[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
554         _confirmedSnipers.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
555 
556         _isSniper[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
557         _confirmedSnipers.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
558 
559         _isSniper[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
560         _confirmedSnipers.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
561 
562         _isSniper[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
563         _confirmedSnipers.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
564 
565         _isSniper[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
566         _confirmedSnipers.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
567 
568         _isSniper[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
569         _confirmedSnipers.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
570 
571         _isSniper[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
572         _confirmedSnipers.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
573 
574         _isSniper[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
575         _confirmedSnipers.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
576 
577         _isSniper[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
578         _confirmedSnipers.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
579 
580         _isSniper[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
581         _confirmedSnipers.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
582 
583         _isSniper[address(0x000000000000084e91743124a982076C59f10084)] = true;
584         _confirmedSnipers.push(address(0x000000000000084e91743124a982076C59f10084));
585 
586         _isSniper[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
587         _confirmedSnipers.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
588 
589         _isSniper[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
590         _confirmedSnipers.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
591 
592         _isSniper[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
593         _confirmedSnipers.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
594 
595         _isSniper[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
596         _confirmedSnipers.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
597 
598         _isSniper[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
599         _confirmedSnipers.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
600 
601         _isSniper[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
602         _confirmedSnipers.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
603 
604         _isSniper[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
605         _confirmedSnipers.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
606 
607         _isSniper[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
608         _confirmedSnipers.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
609 
610         _isSniper[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
611         _confirmedSnipers.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
612 
613         _isSniper[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
614         _confirmedSnipers.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
615 
616         _isSniper[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
617         _confirmedSnipers.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
618 
619         _isSniper[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
620         _confirmedSnipers.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
621 
622         _isSniper[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
623         _confirmedSnipers.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
624 
625         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
626         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
627 
628         _isSniper[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
629         _confirmedSnipers.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
630 
631         _isSniper[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
632         _confirmedSnipers.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
633 
634         _isSniper[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
635         _confirmedSnipers.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
636 
637         _isSniper[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
638         _confirmedSnipers.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
639 
640         _isSniper[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
641         _confirmedSnipers.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
642 
643         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
644         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
645 
646         _isSniper[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
647         _confirmedSnipers.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
648 
649         _isSniper[address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02)] = true;
650         _confirmedSnipers.push(address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02));
651 
652         _isSniper[address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850)] = true;
653         _confirmedSnipers.push(address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850));
654 
655         _isSniper[address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37)] = true;
656         _confirmedSnipers.push(address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37));
657 
658         _isSniper[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
659         _confirmedSnipers.push(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
660 
661         _isSniper[address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A)] = true;
662         _confirmedSnipers.push(address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A));
663 
664         _isSniper[address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65)] = true;
665         _confirmedSnipers.push(address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65));
666 
667         _isSniper[address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3)] = true;
668         _confirmedSnipers.push(address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3));
669 
670         _isSniper[address(0xD334C5392eD4863C81576422B968C6FB90EE9f79)] = true;
671         _confirmedSnipers.push(address(0xD334C5392eD4863C81576422B968C6FB90EE9f79));
672 
673         _isSniper[address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7)] = true;
674         _confirmedSnipers.push(address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7));
675 
676         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
677         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
678 
679         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
680         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
681 
682         teamDevAddress = payable(0xa8FB832AfdB227B33359Fd625f09Ef5681e2608F);
683     }
684 
685     function name() public view returns (string memory) {
686         return _name;
687     }
688 
689     function symbol() public view returns (string memory) {
690         return _symbol;
691     }
692 
693     function decimals() public view returns (uint8) {
694         return _decimals;
695     }
696 
697     function totalSupply() public view override returns (uint256) {
698         return _tTotal;
699     }
700 
701     function balanceOf(address account) public view override returns (uint256) {
702         if (_isExcluded[account]) return _tOwned[account];
703         return tokenFromReflection(_rOwned[account]);
704     }
705 
706     function transfer(address recipient, uint256 amount) public override returns (bool) {
707         _transfer(_msgSender(), recipient, amount);
708         return true;
709     }
710 
711     function allowance(address owner, address spender) public view override returns (uint256) {
712         return _allowances[owner][spender];
713     }
714 
715     function approve(address spender, uint256 amount) public override returns (bool) {
716         _approve(_msgSender(), spender, amount);
717         return true;
718     }
719 
720     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
721         _transfer(sender, recipient, amount);
722         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
723         return true;
724     }
725 
726     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
727         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
728         return true;
729     }
730 
731     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
732         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
733         return true;
734     }
735 
736     function isExcludedFromReward(address account) public view returns (bool) {
737         return _isExcluded[account];
738     }
739 
740     function totalFees() public view returns (uint256) {
741         return _tFeeTotal;
742     }
743 
744     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
745         return minimumTokensBeforeSwap;
746     }
747 
748     function buyBackUpperLimitAmount() public view returns (uint256) {
749         return buyBackUpperLimit;
750     }
751 
752     function deliver(uint256 tAmount) public {
753         address sender = _msgSender();
754         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
755         (uint256 rAmount,,,,,) = _getValues(tAmount);
756         _rOwned[sender] = _rOwned[sender].sub(rAmount);
757         _rTotal = _rTotal.sub(rAmount);
758         _tFeeTotal = _tFeeTotal.add(tAmount);
759     }
760 
761 
762     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
763         require(tAmount <= _tTotal, "Amount must be less than supply");
764         if (!deductTransferFee) {
765             (uint256 rAmount,,,,,) = _getValues(tAmount);
766             return rAmount;
767         } else {
768             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
769             return rTransferAmount;
770         }
771     }
772 
773     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
774         require(rAmount <= _rTotal, "Amount must be less than total reflections");
775         uint256 currentRate =  _getRate();
776         return rAmount.div(currentRate);
777     }
778 
779     function excludeFromReward(address account) public onlyOwner() {
780 
781         require(!_isExcluded[account], "Account is already excluded");
782         if(_rOwned[account] > 0) {
783             _tOwned[account] = tokenFromReflection(_rOwned[account]);
784         }
785         _isExcluded[account] = true;
786         _excluded.push(account);
787     }
788 
789     function isRemovedSniper(address account) public view returns (bool) {
790         return _isSniper[account];
791     }
792 
793     function includeInReward(address account) external onlyOwner() {
794         require(_isExcluded[account], "Account is already excluded");
795         for (uint256 i = 0; i < _excluded.length; i++) {
796             if (_excluded[i] == account) {
797                 _excluded[i] = _excluded[_excluded.length - 1];
798                 _tOwned[account] = 0;
799                 _isExcluded[account] = false;
800                 _excluded.pop();
801                 break;
802             }
803         }
804     }
805 
806     function _approve(address owner, address spender, uint256 amount) private {
807         require(owner != address(0), "ERC20: approve from the zero address");
808         require(spender != address(0), "ERC20: approve to the zero address");
809 
810         _allowances[owner][spender] = amount;
811         emit Approval(owner, spender, amount);
812     }
813 
814     function _transfer(
815         address sender,
816         address recipient,
817         uint256 amount
818     ) private {
819         require(sender != address(0), "ERC20: transfer from the zero address");
820         require(recipient != address(0), "ERC20: transfer to the zero address");
821         require(amount > 0, "Transfer amount must be greater than zero");
822         require(!_isSniper[recipient], "You have no power here!");
823         require(!_isSniper[msg.sender], "You have no power here!");
824 
825 
826         if(sender != owner() && recipient != owner()) {
827             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
828             if (!tradingOpen) {
829                 if (!(sender == address(this) || recipient == address(this)
830                 || sender == address(owner()) || recipient == address(owner()))) {
831                     require(tradingOpen, "Trading is not enabled");
832                 }
833             }
834 
835             if (block.timestamp < launchTime + 15 seconds) {
836                 if (sender != uniswapV2Pair
837                 && sender != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
838                     && sender != address(uniswapV2Router)) {
839                     _isSniper[sender] = true;
840                     _confirmedSnipers.push(sender);
841                 }
842             }
843         }
844 
845         uint256 contractTokenBalance = balanceOf(address(this));
846         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
847 
848         if (!inSwapAndLiquify && swapAndLiquifyEnabled && recipient == uniswapV2Pair) {
849             if (overMinimumTokenBalance) {
850                 contractTokenBalance = minimumTokensBeforeSwap;
851                 swapTokens(contractTokenBalance);
852             }
853             uint256 balance = address(this).balance;
854             if (buyBackEnabled && balance > uint256(1 * 10**18)) {
855 
856                 if (balance > buyBackUpperLimit)
857                     balance = buyBackUpperLimit;
858 
859                 buyBackTokens(balance.div(100));
860             }
861         }
862 
863         bool takeFee = true;
864 
865         //if any account belongs to _isExcludedFromFee account then remove the fee
866         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
867             takeFee = false;
868         }
869 
870         _tokenTransfer(sender, recipient,amount,takeFee);
871     }
872 
873     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
874 
875         uint256 initialBalance = address(this).balance;
876         swapTokensForEth(contractTokenBalance);
877         uint256 transferredBalance = address(this).balance.sub(initialBalance);
878 
879         transferToAddressETH(teamDevAddress, transferredBalance.div(_liquidityFee).mul(splitDivisor));
880 
881     }
882 
883 
884     function buyBackTokens(uint256 amount) private lockTheSwap {
885         if (amount > 0) {
886             swapETHForTokens(amount);
887         }
888     }
889 
890     function swapTokensForEth(uint256 tokenAmount) private {
891         // generate the uniswap pair path of token -> weth
892         address[] memory path = new address[](2);
893         path[0] = address(this);
894         path[1] = uniswapV2Router.WETH();
895 
896         _approve(address(this), address(uniswapV2Router), tokenAmount);
897 
898         // make the swap
899         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
900             tokenAmount,
901             0, // accept any amount of ETH
902             path,
903             address(this), // The contract
904             block.timestamp
905         );
906 
907         emit SwapTokensForETH(tokenAmount, path);
908     }
909 
910     function swapETHForTokens(uint256 amount) private {
911         // generate the uniswap pair path of token -> weth
912         address[] memory path = new address[](2);
913         path[0] = uniswapV2Router.WETH();
914         path[1] = address(this);
915 
916         // make the swap
917         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
918             0, // accept any amount of Tokens
919             path,
920             deadAddress, // Burn address
921             block.timestamp.add(300)
922         );
923 
924         emit SwapETHForTokens(amount, path);
925     }
926 
927     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
928         // approve token transfer to cover all possible scenarios
929         _approve(address(this), address(uniswapV2Router), tokenAmount);
930 
931         // add the liquidity
932         uniswapV2Router.addLiquidityETH{value: ethAmount}(
933             address(this),
934             tokenAmount,
935             0, // slippage is unavoidable
936             0, // slippage is unavoidable
937             owner(),
938             block.timestamp
939         );
940     }
941 
942     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
943         if(!takeFee)
944             removeAllFee();
945 
946         if (_isExcluded[sender] && !_isExcluded[recipient]) {
947             _transferFromExcluded(sender, recipient, amount);
948         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
949             _transferToExcluded(sender, recipient, amount);
950         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
951             _transferBothExcluded(sender, recipient, amount);
952         } else {
953             _transferStandard(sender, recipient, amount);
954         }
955 
956         if(!takeFee)
957             restoreAllFee();
958     }
959 
960     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
961         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
962         _rOwned[sender] = _rOwned[sender].sub(rAmount);
963         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
964         _takeLiquidity(tLiquidity);
965         _reflectFee(rFee, tFee);
966         emit Transfer(sender, recipient, tTransferAmount);
967     }
968 
969     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
970         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
971         _rOwned[sender] = _rOwned[sender].sub(rAmount);
972         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
973         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
974         _takeLiquidity(tLiquidity);
975         _reflectFee(rFee, tFee);
976         emit Transfer(sender, recipient, tTransferAmount);
977     }
978 
979     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
980         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
981         _tOwned[sender] = _tOwned[sender].sub(tAmount);
982         _rOwned[sender] = _rOwned[sender].sub(rAmount);
983         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
984         _takeLiquidity(tLiquidity);
985         _reflectFee(rFee, tFee);
986         emit Transfer(sender, recipient, tTransferAmount);
987     }
988 
989     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
990         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
991         _tOwned[sender] = _tOwned[sender].sub(tAmount);
992         _rOwned[sender] = _rOwned[sender].sub(rAmount);
993         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
994         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
995         _takeLiquidity(tLiquidity);
996         _reflectFee(rFee, tFee);
997         emit Transfer(sender, recipient, tTransferAmount);
998     }
999 
1000     function _reflectFee(uint256 rFee, uint256 tFee) private {
1001         _rTotal = _rTotal.sub(rFee);
1002         _tFeeTotal = _tFeeTotal.add(tFee);
1003     }
1004 
1005     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1006         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1007         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1008         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1009     }
1010 
1011     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1012         uint256 tFee = calculateTaxFee(tAmount);
1013         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1014         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1015         return (tTransferAmount, tFee, tLiquidity);
1016     }
1017 
1018     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1019         uint256 rAmount = tAmount.mul(currentRate);
1020         uint256 rFee = tFee.mul(currentRate);
1021         uint256 rLiquidity = tLiquidity.mul(currentRate);
1022         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1023         return (rAmount, rTransferAmount, rFee);
1024     }
1025 
1026     function _getRate() private view returns(uint256) {
1027         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1028         return rSupply.div(tSupply);
1029     }
1030 
1031     function _getCurrentSupply() private view returns(uint256, uint256) {
1032         uint256 rSupply = _rTotal;
1033         uint256 tSupply = _tTotal;
1034         for (uint256 i = 0; i < _excluded.length; i++) {
1035             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1036             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1037             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1038         }
1039         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1040         return (rSupply, tSupply);
1041     }
1042 
1043     function _takeLiquidity(uint256 tLiquidity) private {
1044         uint256 currentRate =  _getRate();
1045         uint256 rLiquidity = tLiquidity.mul(currentRate);
1046         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1047         if(_isExcluded[address(this)])
1048             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1049     }
1050 
1051     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1052         return _amount.mul(_taxFee).div(
1053             10**2
1054         );
1055     }
1056 
1057     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1058         return _amount.mul(_liquidityFee).div(
1059             10**2
1060         );
1061     }
1062 
1063     function removeAllFee() private {
1064         if(_taxFee == 0 && _liquidityFee == 0) return;
1065 
1066         _previousTaxFee = _taxFee;
1067         _previousLiquidityFee = _liquidityFee;
1068 
1069         _taxFee = 0;
1070         _liquidityFee = 0;
1071     }
1072 
1073     function restoreAllFee() private {
1074         _taxFee = _previousTaxFee;
1075         _liquidityFee = _previousLiquidityFee;
1076     }
1077 
1078     function isExcludedFromFee(address account) public view returns(bool) {
1079         return _isExcludedFromFee[account];
1080     }
1081 
1082     function excludeFromFee(address account) public onlyOwner {
1083         _isExcludedFromFee[account] = true;
1084     }
1085 
1086     function includeInFee(address account) public onlyOwner {
1087         _isExcludedFromFee[account] = false;
1088     }
1089 
1090     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1091         _taxFee = taxFee;
1092     }
1093 
1094     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1095         _liquidityFee = liquidityFee;
1096     }
1097 
1098     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1099         _maxTxAmount = maxTxAmount;
1100     }
1101 
1102     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
1103         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
1104     }
1105 
1106     function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
1107         buyBackUpperLimit = buyBackLimit * 10**18;
1108     }
1109 
1110     function setTeamDevAddress(address _teamDevAddress) external onlyOwner() {
1111         teamDevAddress = payable(_teamDevAddress);
1112     }
1113 
1114     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1115         swapAndLiquifyEnabled = _enabled;
1116         emit SwapAndLiquifyEnabledUpdated(_enabled);
1117     }
1118 
1119     function setBuyBackEnabled(bool _enabled) public onlyOwner {
1120         buyBackEnabled = _enabled;
1121         emit BuyBackEnabledUpdated(_enabled);
1122     }
1123 
1124     function transferToAddressETH(address payable recipient, uint256 amount) private {
1125         recipient.transfer(amount);
1126     }
1127 
1128     function _removeSniper(address account) external onlyOwner() {
1129         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap');
1130         require(!_isSniper[account], "Account is already blacklisted");
1131         _isSniper[account] = true;
1132         _confirmedSnipers.push(account);
1133     }
1134 
1135     function _amnestySniper(address account) external onlyOwner() {
1136         require(_isSniper[account], "Account is not blacklisted");
1137         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1138             if (_confirmedSnipers[i] == account) {
1139                 _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
1140                 _isSniper[account] = false;
1141                 _confirmedSnipers.pop();
1142                 break;
1143             }
1144         }
1145     }
1146 
1147     function _removeTxLimit() external onlyOwner() {
1148         _maxTxAmount = 1000000000000000000000000;
1149     }
1150 
1151     //to recieve ETH from uniswapV2Router when swapping
1152     receive() external payable {}
1153 }