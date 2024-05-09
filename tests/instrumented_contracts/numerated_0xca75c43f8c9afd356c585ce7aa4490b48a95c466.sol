1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 
17 interface IERC20 {
18 
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28 
29 }
30 
31 library SafeMath {
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55 
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58 
59         return c;
60     }
61 
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72         return c;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return mod(a, b, "SafeMath: modulo by zero");
77     }
78 
79     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b != 0, errorMessage);
81         return a % b;
82     }
83 }
84 
85 library Address {
86 
87     function isContract(address account) internal view returns (bool) {
88         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
89         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
90         // for accounts without code, i.e. `keccak256('')`
91         bytes32 codehash;
92         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
93         // solhint-disable-next-line no-inline-assembly
94         assembly { codehash := extcodehash(account) }
95         return (codehash != accountHash && codehash != 0x0);
96     }
97 
98     function sendValue(address payable recipient, uint256 amount) internal {
99         require(address(this).balance >= amount, "Address: insufficient balance");
100 
101         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
102         (bool success, ) = recipient.call{ value: amount }("");
103         require(success, "Address: unable to send value, recipient may have reverted");
104     }
105 
106 
107     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
108         return functionCall(target, data, "Address: low-level call failed");
109     }
110 
111     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
112         return _functionCallWithValue(target, data, 0, errorMessage);
113     }
114 
115     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
120         require(address(this).balance >= value, "Address: insufficient balance for call");
121         return _functionCallWithValue(target, data, value, errorMessage);
122     }
123 
124     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
125         require(isContract(target), "Address: call to non-contract");
126 
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130         } else {
131 
132             if (returndata.length > 0) {
133                 assembly {
134                     let returndata_size := mload(returndata)
135                     revert(add(32, returndata), returndata_size)
136                 }
137             } else {
138                 revert(errorMessage);
139             }
140         }
141     }
142 }
143 
144 contract Ownable is Context {
145     address private _owner;
146     address private _previousOwner;
147     uint256 private _lockTime;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151     constructor () {
152         address msgSender = _msgSender();
153         _owner = msgSender;
154         emit OwnershipTransferred(address(0), msgSender);
155     }
156 
157     function owner() public view returns (address) {
158         return _owner;
159     }
160 
161     modifier onlyOwner() {
162         require(_owner == _msgSender(), "Ownable: caller is not the owner");
163         _;
164     }
165 
166     
167     function transferOwnership(address newOwner) public virtual onlyOwner {
168         require(newOwner != address(0), "Ownable: new owner is the zero address");
169         emit OwnershipTransferred(_owner, newOwner);
170         _owner = newOwner;
171     }
172 
173     function getUnlockTime() public view returns (uint256) {
174         return _lockTime;
175     }
176 
177     function getTime() public view returns (uint256) {
178         return block.timestamp;
179     }
180 
181     function lock(uint256 time) public virtual onlyOwner {
182         _previousOwner = _owner;
183         _owner = address(0);
184         _lockTime = block.timestamp + time;
185         emit OwnershipTransferred(_owner, address(0));
186     }
187 
188     function unlock() public virtual {
189         require(_previousOwner == msg.sender, "You don't have permission to unlock");
190         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
191         emit OwnershipTransferred(_owner, _previousOwner);
192         _owner = _previousOwner;
193     }
194 }
195 
196 // pragma solidity >=0.5.0;
197 
198 interface IUniswapV2Factory {
199     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
200 
201     function feeTo() external view returns (address);
202     function feeToSetter() external view returns (address);
203 
204     function getPair(address tokenA, address tokenB) external view returns (address pair);
205     function allPairs(uint) external view returns (address pair);
206     function allPairsLength() external view returns (uint);
207 
208     function createPair(address tokenA, address tokenB) external returns (address pair);
209 
210     function setFeeTo(address) external;
211     function setFeeToSetter(address) external;
212 }
213 
214 
215 // pragma solidity >=0.5.0;
216 
217 interface IUniswapV2Pair {
218     event Approval(address indexed owner, address indexed spender, uint value);
219     event Transfer(address indexed from, address indexed to, uint value);
220 
221     function name() external pure returns (string memory);
222     function symbol() external pure returns (string memory);
223     function decimals() external pure returns (uint8);
224     function totalSupply() external view returns (uint);
225     function balanceOf(address owner) external view returns (uint);
226     function allowance(address owner, address spender) external view returns (uint);
227 
228     function approve(address spender, uint value) external returns (bool);
229     function transfer(address to, uint value) external returns (bool);
230     function transferFrom(address from, address to, uint value) external returns (bool);
231 
232     function DOMAIN_SEPARATOR() external view returns (bytes32);
233     function PERMIT_TYPEHASH() external pure returns (bytes32);
234     function nonces(address owner) external view returns (uint);
235 
236     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
237 
238     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
239     event Swap(
240         address indexed sender,
241         uint amount0In,
242         uint amount1In,
243         uint amount0Out,
244         uint amount1Out,
245         address indexed to
246     );
247     event Sync(uint112 reserve0, uint112 reserve1);
248 
249     function MINIMUM_LIQUIDITY() external pure returns (uint);
250     function factory() external view returns (address);
251     function token0() external view returns (address);
252     function token1() external view returns (address);
253     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
254     function price0CumulativeLast() external view returns (uint);
255     function price1CumulativeLast() external view returns (uint);
256     function kLast() external view returns (uint);
257 
258     function burn(address to) external returns (uint amount0, uint amount1);
259     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
260     function skim(address to) external;
261     function sync() external;
262 
263     function initialize(address, address) external;
264 }
265 
266 // pragma solidity >=0.6.2;
267 
268 interface IUniswapV2Router01 {
269     function factory() external pure returns (address);
270     function WETH() external pure returns (address);
271 
272     function addLiquidity(
273         address tokenA,
274         address tokenB,
275         uint amountADesired,
276         uint amountBDesired,
277         uint amountAMin,
278         uint amountBMin,
279         address to,
280         uint deadline
281     ) external returns (uint amountA, uint amountB, uint liquidity);
282     function addLiquidityETH(
283         address token,
284         uint amountTokenDesired,
285         uint amountTokenMin,
286         uint amountETHMin,
287         address to,
288         uint deadline
289     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
290     function removeLiquidity(
291         address tokenA,
292         address tokenB,
293         uint liquidity,
294         uint amountAMin,
295         uint amountBMin,
296         address to,
297         uint deadline
298     ) external returns (uint amountA, uint amountB);
299     function removeLiquidityETH(
300         address token,
301         uint liquidity,
302         uint amountTokenMin,
303         uint amountETHMin,
304         address to,
305         uint deadline
306     ) external returns (uint amountToken, uint amountETH);
307     function removeLiquidityWithPermit(
308         address tokenA,
309         address tokenB,
310         uint liquidity,
311         uint amountAMin,
312         uint amountBMin,
313         address to,
314         uint deadline,
315         bool approveMax, uint8 v, bytes32 r, bytes32 s
316     ) external returns (uint amountA, uint amountB);
317     function removeLiquidityETHWithPermit(
318         address token,
319         uint liquidity,
320         uint amountTokenMin,
321         uint amountETHMin,
322         address to,
323         uint deadline,
324         bool approveMax, uint8 v, bytes32 r, bytes32 s
325     ) external returns (uint amountToken, uint amountETH);
326     function swapExactTokensForTokens(
327         uint amountIn,
328         uint amountOutMin,
329         address[] calldata path,
330         address to,
331         uint deadline
332     ) external returns (uint[] memory amounts);
333     function swapTokensForExactTokens(
334         uint amountOut,
335         uint amountInMax,
336         address[] calldata path,
337         address to,
338         uint deadline
339     ) external returns (uint[] memory amounts);
340     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
341     external
342     payable
343     returns (uint[] memory amounts);
344     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
345     external
346     returns (uint[] memory amounts);
347     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
348     external
349     returns (uint[] memory amounts);
350     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
351     external
352     payable
353     returns (uint[] memory amounts);
354 
355     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
356     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
357     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
358     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
359     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
360 }
361 
362 
363 
364 // pragma solidity >=0.6.2;
365 
366 interface IUniswapV2Router02 is IUniswapV2Router01 {
367     function removeLiquidityETHSupportingFeeOnTransferTokens(
368         address token,
369         uint liquidity,
370         uint amountTokenMin,
371         uint amountETHMin,
372         address to,
373         uint deadline
374     ) external returns (uint amountETH);
375     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
376         address token,
377         uint liquidity,
378         uint amountTokenMin,
379         uint amountETHMin,
380         address to,
381         uint deadline,
382         bool approveMax, uint8 v, bytes32 r, bytes32 s
383     ) external returns (uint amountETH);
384 
385     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
386         uint amountIn,
387         uint amountOutMin,
388         address[] calldata path,
389         address to,
390         uint deadline
391     ) external;
392     function swapExactETHForTokensSupportingFeeOnTransferTokens(
393         uint amountOutMin,
394         address[] calldata path,
395         address to,
396         uint deadline
397     ) external payable;
398     function swapExactTokensForETHSupportingFeeOnTransferTokens(
399         uint amountIn,
400         uint amountOutMin,
401         address[] calldata path,
402         address to,
403         uint deadline
404     ) external;
405 }
406 
407 contract Inari is Context, IERC20, Ownable {
408     using SafeMath for uint256;
409     using Address for address;
410 
411     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
412     mapping (address => uint256) private _rOwned;
413     mapping (address => uint256) private _tOwned;
414     mapping (address => mapping (address => uint256)) private _allowances;
415     mapping (address => User) private cooldown;
416 
417     mapping (address => bool) private _isSniper;
418     address[] private _confirmedSnipers;
419 
420     mapping (address => bool) private _isExcludedFromFee;
421     mapping (address => bool) private _isExcluded;
422     address[] private _excluded;
423 
424     uint256 private constant MAX = ~uint256(0);
425     uint256 private _tTotal = 1000000000000 * 10**9;
426     uint256 private _rTotal = (MAX - (MAX % _tTotal));
427     uint256 private _tFeeTotal;
428 
429     string private _name = "Inari";
430     string private _symbol = "Inari";
431     uint8 private _decimals = 9;
432     
433     address payable private teamDevAddress;
434 
435     uint256 public launchTime;
436     uint256 private buyLimitEnd;
437     
438     
439     uint256 public _taxFee = 0;
440     uint256 private _previousTaxFee = _taxFee;
441     uint256 public _liquidityFee=0;
442     uint256 private _previousLiquidityFee = _liquidityFee;
443     uint256 public _baseLiqFee;
444     
445     bool private _useImpactFeeSetter = true;
446     uint256 private _feeMultiplier = 1000;
447     
448     
449     uint256 public _minTrigger = 0;
450     uint256 public k = 10;
451     uint256 public _baseAmount = 1*10**15;
452 
453     uint private _maxBuyAmount;
454     bool private _cooldownEnabled=true;
455 
456     bool public tradingOpen = false; //once switched on, can never be switched off.
457     
458 
459 
460     IUniswapV2Router02 public uniswapV2Router;
461     address public uniswapV2Pair;
462 
463     bool inSwapAndLiquify;
464     bool public swapAndLiquifyEnabled = false;
465     bool public buyBackEnabled = false;
466     
467     struct User {
468         uint256 buy;
469         uint256 sell;
470         bool exists;
471     }
472     
473     event BuyBackEnabledUpdated(bool enabled);
474   
475 
476     event SwapETHForTokens(
477         uint256 amountIn,
478         address[] path
479     );
480 
481     event SwapTokensForETH(
482         uint256 amountIn,
483         address[] path
484     );
485 
486     modifier lockTheSwap {
487         inSwapAndLiquify = true;
488         _;
489         inSwapAndLiquify = false;
490     }
491 
492     constructor () {
493         _rOwned[_msgSender()] = _rTotal;
494         emit Transfer(address(0), _msgSender(), _tTotal);
495     }
496 
497     function enableTrading() external onlyOwner() {
498         _maxBuyAmount = 2000000000 * 10**9;
499         _baseLiqFee=20;
500         _liquidityFee=_baseLiqFee;
501         _taxFee=0;
502         swapAndLiquifyEnabled = true;
503         tradingOpen = true;
504         launchTime = block.timestamp;
505         buyLimitEnd = block.timestamp + (240 seconds);
506     }
507 
508     function initContract() external onlyOwner() {
509         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
510         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
511         .createPair(address(this), _uniswapV2Router.WETH());
512 
513         uniswapV2Router = _uniswapV2Router;
514 
515         _isExcludedFromFee[owner()] = true;
516         _isExcludedFromFee[address(this)] = true;
517 
518         
519         _isSniper[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
520         _confirmedSnipers.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
521 
522         _isSniper[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
523         _confirmedSnipers.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
524 
525         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
526         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
527 
528         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
529         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
530 
531         _isSniper[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
532         _confirmedSnipers.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
533 
534         _isSniper[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
535         _confirmedSnipers.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
536 
537         _isSniper[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
538         _confirmedSnipers.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
539 
540         _isSniper[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
541         _confirmedSnipers.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
542 
543         _isSniper[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
544         _confirmedSnipers.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
545 
546         _isSniper[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
547         _confirmedSnipers.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
548 
549         _isSniper[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
550         _confirmedSnipers.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
551 
552         _isSniper[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
553         _confirmedSnipers.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
554 
555         _isSniper[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
556         _confirmedSnipers.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
557 
558         _isSniper[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
559         _confirmedSnipers.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
560 
561         _isSniper[address(0x000000000000084e91743124a982076C59f10084)] = true;
562         _confirmedSnipers.push(address(0x000000000000084e91743124a982076C59f10084));
563 
564         _isSniper[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
565         _confirmedSnipers.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
566 
567         _isSniper[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
568         _confirmedSnipers.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
569 
570         _isSniper[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
571         _confirmedSnipers.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
572 
573         _isSniper[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
574         _confirmedSnipers.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
575 
576         _isSniper[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
577         _confirmedSnipers.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
578 
579         _isSniper[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
580         _confirmedSnipers.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
581 
582         _isSniper[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
583         _confirmedSnipers.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
584 
585         _isSniper[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
586         _confirmedSnipers.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
587 
588         _isSniper[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
589         _confirmedSnipers.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
590 
591         _isSniper[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
592         _confirmedSnipers.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
593 
594         _isSniper[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
595         _confirmedSnipers.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
596 
597         _isSniper[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
598         _confirmedSnipers.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
599 
600         _isSniper[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
601         _confirmedSnipers.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
602 
603         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
604         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
605 
606         _isSniper[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
607         _confirmedSnipers.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
608 
609         _isSniper[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
610         _confirmedSnipers.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
611 
612         _isSniper[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
613         _confirmedSnipers.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
614 
615         _isSniper[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
616         _confirmedSnipers.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
617 
618         _isSniper[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
619         _confirmedSnipers.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
620 
621         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
622         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
623 
624         _isSniper[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
625         _confirmedSnipers.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
626 
627         _isSniper[address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02)] = true;
628         _confirmedSnipers.push(address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02));
629 
630         _isSniper[address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850)] = true;
631         _confirmedSnipers.push(address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850));
632 
633         _isSniper[address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37)] = true;
634         _confirmedSnipers.push(address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37));
635 
636         _isSniper[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
637         _confirmedSnipers.push(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
638 
639         _isSniper[address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A)] = true;
640         _confirmedSnipers.push(address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A));
641 
642         _isSniper[address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65)] = true;
643         _confirmedSnipers.push(address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65));
644 
645         _isSniper[address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3)] = true;
646         _confirmedSnipers.push(address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3));
647 
648         _isSniper[address(0xD334C5392eD4863C81576422B968C6FB90EE9f79)] = true;
649         _confirmedSnipers.push(address(0xD334C5392eD4863C81576422B968C6FB90EE9f79));
650 
651         _isSniper[address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7)] = true;
652         _confirmedSnipers.push(address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7));
653 
654         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
655         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
656 
657         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
658         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
659 
660         teamDevAddress = payable(0x1896BDf0327A5E20de16aD817DC70312Edd7C63a);
661     }
662 
663     function name() public view returns (string memory) {
664         return _name;
665     }
666 
667     function symbol() public view returns (string memory) {
668         return _symbol;
669     }
670 
671     function decimals() public view returns (uint8) {
672         return _decimals;
673     }
674 
675     function totalSupply() public view override returns (uint256) {
676         return _tTotal;
677     }
678 
679     function balanceOf(address account) public view override returns (uint256) {
680         if (_isExcluded[account]) return _tOwned[account];
681         return tokenFromReflection(_rOwned[account]);
682     }
683 
684     function transfer(address recipient, uint256 amount) public override returns (bool) {
685         _transfer(_msgSender(), recipient, amount);
686         return true;
687     }
688 
689     function allowance(address owner, address spender) public view override returns (uint256) {
690         return _allowances[owner][spender];
691     }
692 
693     function approve(address spender, uint256 amount) public override returns (bool) {
694         _approve(_msgSender(), spender, amount);
695         return true;
696     }
697 
698     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
699         _transfer(sender, recipient, amount);
700         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
701         return true;
702     }
703 
704     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
705         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
706         return true;
707     }
708 
709     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
710         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
711         return true;
712     }
713 
714     function isExcludedFromReward(address account) public view returns (bool) {
715         return _isExcluded[account];
716     }
717 
718     function totalFees() public view returns (uint256) {
719         return _tFeeTotal;
720     }
721 
722   
723     function deliver(uint256 tAmount) public {
724         address sender = _msgSender();
725         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
726         (uint256 rAmount,,,,,) = _getValues(tAmount);
727         _rOwned[sender] = _rOwned[sender].sub(rAmount);
728         _rTotal = _rTotal.sub(rAmount);
729         _tFeeTotal = _tFeeTotal.add(tAmount);
730     }
731 
732 
733     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
734         require(tAmount <= _tTotal, "Amount must be less than supply");
735         if (!deductTransferFee) {
736             (uint256 rAmount,,,,,) = _getValues(tAmount);
737             return rAmount;
738         } else {
739             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
740             return rTransferAmount;
741         }
742     }
743 
744     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
745         require(rAmount <= _rTotal, "Amount must be less than total reflections");
746         uint256 currentRate =  _getRate();
747         return rAmount.div(currentRate);
748     }
749 
750     function isRemovedSniper(address account) public view returns (bool) {
751         return _isSniper[account];
752     }
753 
754     function _approve(address owner, address spender, uint256 amount) private {
755         require(owner != address(0), "ERC20: approve from the zero address");
756         require(spender != address(0), "ERC20: approve to the zero address");
757 
758         _allowances[owner][spender] = amount;
759         emit Approval(owner, spender, amount);
760     }
761 
762     function _transfer(
763         address sender,
764         address recipient,
765         uint256 amount
766     ) private {
767         require(sender != address(0), "ERC20: transfer from the zero address");
768         require(recipient != address(0), "ERC20: transfer to the zero address");
769         require(amount > 0, "Transfer amount must be greater than zero");
770         require(!_isSniper[recipient], "You have no power here!");
771         require(!_isSniper[msg.sender], "You have no power here!");
772 
773 
774         if(sender != owner() && recipient != owner()) {
775             
776             if (!tradingOpen) {
777                 if (!(sender == address(this) || recipient == address(this)
778                 || sender == address(owner()) || recipient == address(owner()))) {
779                     require(tradingOpen, "Trading is not enabled");
780                 }
781             }
782 
783             if(_cooldownEnabled) {
784                 if(!cooldown[msg.sender].exists) {
785                     cooldown[msg.sender] = User(0,0,true);
786                 }
787             }
788         }
789         
790         //buy
791         
792         if(sender == uniswapV2Pair && recipient != address(uniswapV2Router) && !_isExcludedFromFee[recipient]) {
793                 require(tradingOpen, "Trading not yet enabled.");
794                 
795                 _liquidityFee=_baseLiqFee;
796                 
797                 if(_cooldownEnabled) {
798                     if(buyLimitEnd > block.timestamp) {
799                         require(amount <= _maxBuyAmount);
800                         require(cooldown[recipient].buy < block.timestamp, "Your buy cooldown has not expired.");
801                         cooldown[recipient].buy = block.timestamp + (45 seconds);
802                     }
803                 }
804                 if(_cooldownEnabled) {
805                     cooldown[recipient].sell = block.timestamp + (15 seconds);
806                 }
807         }
808 
809         //sell
810         if (!inSwapAndLiquify && swapAndLiquifyEnabled && recipient == uniswapV2Pair) {
811             
812             //get dynamic fee
813             if(_useImpactFeeSetter) {
814                     uint256 feeBasis = amount.mul(_feeMultiplier);
815                     feeBasis = feeBasis.div(balanceOf(uniswapV2Pair).add(amount));
816                     setFee(feeBasis);
817             }
818             
819             uint256 dynamicFee = _liquidityFee;
820             
821             //swap contract's tokens for ETH
822             uint256 contractTokenBalance = balanceOf(address(this));
823              if(contractTokenBalance > 0) {
824                 swapTokens(contractTokenBalance);
825             }
826             
827             //buyback
828             uint256 balance = address(this).balance;
829             
830             //buyback only if sell amount >= _minTrigger
831             if (buyBackEnabled && amount >= _minTrigger) {
832                 
833                 uint256 ten = 10;
834                 
835                 uint256 buyBackAmount = _baseAmount.mul(ten.add(((dynamicFee.sub(_baseLiqFee)).mul(k)).div(_baseLiqFee))).div(10);                                                
836 
837                 if (balance >= buyBackAmount)   buyBackTokens(buyBackAmount);
838             }
839             
840             //restore dynamicFee after buyback
841             _liquidityFee = dynamicFee;
842         }
843 
844         bool takeFee = true;
845 
846         //if any account belongs to _isExcludedFromFee account then remove the fee
847         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
848             takeFee = false;
849         }
850 
851         //execute transfer
852         _tokenTransfer(sender, recipient,amount,takeFee);
853     }
854 
855     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
856 
857         uint256 initialBalance = address(this).balance;
858         swapTokensForEth(contractTokenBalance);
859         uint256 transferredBalance = address(this).balance.sub(initialBalance);
860  
861         transferToAddressETH(teamDevAddress, transferredBalance.div(2));
862 
863     }
864 
865 
866     function buyBackTokens(uint256 amount) private lockTheSwap {
867         if (amount > 0) {
868             swapETHForTokens(amount);
869         }
870     }
871     
872     function setFee(uint256 impactFee) private {
873         uint256 _impactFee = _baseLiqFee;
874         if(impactFee < _baseLiqFee) {
875             _impactFee = _baseLiqFee;
876         } else if(impactFee > 40) {
877             _impactFee = 40;
878         } else {
879             _impactFee = impactFee;
880         }
881         if(_impactFee.mod(2) != 0) {
882             _impactFee++;
883         }
884         
885         _liquidityFee = _impactFee;
886     }
887 
888     function swapTokensForEth(uint256 tokenAmount) private {
889         // generate the uniswap pair path of token -> weth
890         address[] memory path = new address[](2);
891         path[0] = address(this);
892         path[1] = uniswapV2Router.WETH();
893 
894         _approve(address(this), address(uniswapV2Router), tokenAmount);
895 
896         // make the swap
897         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
898             tokenAmount,
899             0, // accept any amount of ETH
900             path,
901             address(this), // The contract
902             block.timestamp
903         );
904 
905         emit SwapTokensForETH(tokenAmount, path);
906     }
907 
908     function swapETHForTokens(uint256 amount) private {
909         // generate the uniswap pair path of token -> weth
910         address[] memory path = new address[](2);
911         path[0] = uniswapV2Router.WETH();
912         path[1] = address(this);
913 
914         // make the swap
915         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
916             0, // accept any amount of Tokens
917             path,
918             deadAddress, // Burn address
919             block.timestamp.add(300)
920         );
921 
922         emit SwapETHForTokens(amount, path);
923     }
924 
925     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
926         // approve token transfer to cover all possible scenarios
927         _approve(address(this), address(uniswapV2Router), tokenAmount);
928 
929         // add the liquidity
930         uniswapV2Router.addLiquidityETH{value: ethAmount}(
931             address(this),
932             tokenAmount,
933             0, // slippage is unavoidable
934             0, // slippage is unavoidable
935             owner(),
936             block.timestamp
937         );
938     }
939 
940     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
941         if(!takeFee)
942             removeAllFee();
943 
944         if (_isExcluded[sender] && !_isExcluded[recipient]) {
945             _transferFromExcluded(sender, recipient, amount);
946         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
947             _transferToExcluded(sender, recipient, amount);
948         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
949             _transferBothExcluded(sender, recipient, amount);
950         } else {
951             _transferStandard(sender, recipient, amount);
952         }
953 
954         if(!takeFee)
955             restoreAllFee();
956     }
957 
958     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
959         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
960         _rOwned[sender] = _rOwned[sender].sub(rAmount);
961         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
962         _takeLiquidity(tLiquidity);
963         _reflectFee(rFee, tFee);
964         emit Transfer(sender, recipient, tTransferAmount);
965     }
966 
967     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
968         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
969         _rOwned[sender] = _rOwned[sender].sub(rAmount);
970         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
971         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
972         _takeLiquidity(tLiquidity);
973         _reflectFee(rFee, tFee);
974         emit Transfer(sender, recipient, tTransferAmount);
975     }
976 
977     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
978         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
979         _tOwned[sender] = _tOwned[sender].sub(tAmount);
980         _rOwned[sender] = _rOwned[sender].sub(rAmount);
981         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
982         _takeLiquidity(tLiquidity);
983         _reflectFee(rFee, tFee);
984         emit Transfer(sender, recipient, tTransferAmount);
985     }
986 
987     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
988         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
989         _tOwned[sender] = _tOwned[sender].sub(tAmount);
990         _rOwned[sender] = _rOwned[sender].sub(rAmount);
991         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
992         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
993         _takeLiquidity(tLiquidity);
994         _reflectFee(rFee, tFee);
995         emit Transfer(sender, recipient, tTransferAmount);
996     }
997 
998     function _reflectFee(uint256 rFee, uint256 tFee) private {
999         _rTotal = _rTotal.sub(rFee);
1000         _tFeeTotal = _tFeeTotal.add(tFee);
1001     }
1002 
1003     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1004         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1005         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1006         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1007     }
1008 
1009     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1010         uint256 tFee = calculateTaxFee(tAmount);
1011         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1012         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1013         return (tTransferAmount, tFee, tLiquidity);
1014     }
1015 
1016     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1017         uint256 rAmount = tAmount.mul(currentRate);
1018         uint256 rFee = tFee.mul(currentRate);
1019         uint256 rLiquidity = tLiquidity.mul(currentRate);
1020         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1021         return (rAmount, rTransferAmount, rFee);
1022     }
1023 
1024     function _getRate() private view returns(uint256) {
1025         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1026         return rSupply.div(tSupply);
1027     }
1028 
1029     function _getCurrentSupply() private view returns(uint256, uint256) {
1030         uint256 rSupply = _rTotal;
1031         uint256 tSupply = _tTotal;
1032         for (uint256 i = 0; i < _excluded.length; i++) {
1033             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1034             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1035             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1036         }
1037         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1038         return (rSupply, tSupply);
1039     }
1040 
1041     function _takeLiquidity(uint256 tLiquidity) private {
1042         uint256 currentRate =  _getRate();
1043         uint256 rLiquidity = tLiquidity.mul(currentRate);
1044         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1045         if(_isExcluded[address(this)])
1046             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1047     }
1048 
1049     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1050         return _amount.mul(_taxFee).div(
1051             10**2
1052         );
1053     }
1054 
1055     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1056         return _amount.mul(_liquidityFee).div(
1057             10**2
1058         );
1059     }
1060 
1061     function removeAllFee() private {
1062         if(_taxFee == 0 && _liquidityFee == 0) return;
1063 
1064         _previousTaxFee = _taxFee;
1065         _previousLiquidityFee = _liquidityFee;
1066 
1067         _taxFee = 0;
1068         _liquidityFee = 0;
1069     }
1070 
1071     function restoreAllFee() private {
1072         _taxFee = _previousTaxFee;
1073         _liquidityFee = _previousLiquidityFee;
1074     }
1075 
1076     function isExcludedFromFee(address account) public view returns(bool) {
1077         return _isExcludedFromFee[account];
1078     }
1079 
1080 
1081     function setTeamDevAddress(address _teamDevAddress) external onlyOwner() {
1082         teamDevAddress = payable(_teamDevAddress);
1083     }
1084 
1085     
1086 
1087     function setBuyBackEnabled(bool _enabled) public onlyOwner {
1088         buyBackEnabled = _enabled;
1089         emit BuyBackEnabledUpdated(_enabled);
1090     }
1091 
1092     function transferToAddressETH(address payable recipient, uint256 amount) private {
1093         recipient.transfer(amount);
1094     }
1095 
1096     
1097     function setMinTrigger(uint256 newTrigger) external onlyOwner() {
1098         _minTrigger= newTrigger;
1099     }
1100     
1101     function setK (uint256 newK) external onlyOwner() {
1102         k = newK;
1103     }
1104 
1105     function setBaseAmount(uint256 baseAmount) external onlyOwner() {
1106             _baseAmount=baseAmount;
1107     }
1108     
1109     
1110      function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1111         require((_baseLiqFee+taxFee)<=20); 
1112         _taxFee = taxFee;
1113         _previousTaxFee=taxFee;
1114     }
1115     
1116     function setBaseLiqFeePercent(uint256 baseLiqFee) external onlyOwner() {
1117         require((baseLiqFee+_taxFee)<=20); 
1118         _baseLiqFee = baseLiqFee;
1119     }
1120 
1121     //to recieve ETH from uniswapV2Router when swapping
1122     receive() external payable {}
1123 }