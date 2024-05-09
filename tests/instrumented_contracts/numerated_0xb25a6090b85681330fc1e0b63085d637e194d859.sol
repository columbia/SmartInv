1 /*
2 
3  TG: https://t.me/grumpydogeeth
4  Web: https://grumpydogepunks.com
5  
6  We will burn 319,271,509,705 tokens after listing make this coin deflationary.
7  2% Reflection to all Holders after 2 days, 0% on the first 2 days.
8  The liquidity fee will be 10%
9  The sell fee is dynamically scaled to the sell's price impact, with a minimum fee of 10% and a maximum fee of 40%.
10 
11 */
12 
13 
14 // SPDX-License-Identifier: MIT
15 pragma solidity ^0.8.4;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return payable(msg.sender);
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 
29 interface IERC20 {
30 
31     function totalSupply() external view returns (uint256);
32     function balanceOf(address account) external view returns (uint256);
33     function transfer(address recipient, uint256 amount) external returns (bool);
34     function allowance(address owner, address spender) external view returns (uint256);
35     function approve(address spender, uint256 amount) external returns (bool);
36     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 
40 
41 }
42 
43 library SafeMath {
44 
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48 
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55 
56     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74 
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         return div(a, b, "SafeMath: division by zero");
77     }
78 
79     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b > 0, errorMessage);
81         uint256 c = a / b;
82         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
83 
84         return c;
85     }
86 
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         return mod(a, b, "SafeMath: modulo by zero");
89     }
90 
91     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b != 0, errorMessage);
93         return a % b;
94     }
95 }
96 
97 library Address {
98 
99     function isContract(address account) internal view returns (bool) {
100         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
101         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
102         // for accounts without code, i.e. `keccak256('')`
103         bytes32 codehash;
104         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
105         // solhint-disable-next-line no-inline-assembly
106         assembly { codehash := extcodehash(account) }
107         return (codehash != accountHash && codehash != 0x0);
108     }
109 
110     function sendValue(address payable recipient, uint256 amount) internal {
111         require(address(this).balance >= amount, "Address: insufficient balance");
112 
113         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
114         (bool success, ) = recipient.call{ value: amount }("");
115         require(success, "Address: unable to send value, recipient may have reverted");
116     }
117 
118 
119     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
120         return functionCall(target, data, "Address: low-level call failed");
121     }
122 
123     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
124         return _functionCallWithValue(target, data, 0, errorMessage);
125     }
126 
127     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
128         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
129     }
130 
131     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         return _functionCallWithValue(target, data, value, errorMessage);
134     }
135 
136     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
140         if (success) {
141             return returndata;
142         } else {
143 
144             if (returndata.length > 0) {
145                 assembly {
146                     let returndata_size := mload(returndata)
147                     revert(add(32, returndata), returndata_size)
148                 }
149             } else {
150                 revert(errorMessage);
151             }
152         }
153     }
154 }
155 
156 contract Ownable is Context {
157     address private _owner;
158     address private _previousOwner;
159     uint256 private _lockTime;
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162 
163     constructor () {
164         address msgSender = _msgSender();
165         _owner = msgSender;
166         emit OwnershipTransferred(address(0), msgSender);
167     }
168 
169     function owner() public view returns (address) {
170         return _owner;
171     }
172 
173     modifier onlyOwner() {
174         require(_owner == _msgSender(), "Ownable: caller is not the owner");
175         _;
176     }
177 
178     
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         emit OwnershipTransferred(_owner, newOwner);
182         _owner = newOwner;
183     }
184 
185     function getUnlockTime() public view returns (uint256) {
186         return _lockTime;
187     }
188 
189     function getTime() public view returns (uint256) {
190         return block.timestamp;
191     }
192 
193     function lock(uint256 time) public virtual onlyOwner {
194         _previousOwner = _owner;
195         _owner = address(0);
196         _lockTime = block.timestamp + time;
197         emit OwnershipTransferred(_owner, address(0));
198     }
199 
200     function unlock() public virtual {
201         require(_previousOwner == msg.sender, "You don't have permission to unlock");
202         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
203         emit OwnershipTransferred(_owner, _previousOwner);
204         _owner = _previousOwner;
205     }
206 }
207 
208 interface IUniswapV2Factory {
209     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
210 
211     function feeTo() external view returns (address);
212     function feeToSetter() external view returns (address);
213 
214     function getPair(address tokenA, address tokenB) external view returns (address pair);
215     function allPairs(uint) external view returns (address pair);
216     function allPairsLength() external view returns (uint);
217 
218     function createPair(address tokenA, address tokenB) external returns (address pair);
219 
220     function setFeeTo(address) external;
221     function setFeeToSetter(address) external;
222 }
223 
224 
225 // pragma solidity >=0.5.0;
226 
227 interface IUniswapV2Pair {
228     event Approval(address indexed owner, address indexed spender, uint value);
229     event Transfer(address indexed from, address indexed to, uint value);
230 
231     function name() external pure returns (string memory);
232     function symbol() external pure returns (string memory);
233     function decimals() external pure returns (uint8);
234     function totalSupply() external view returns (uint);
235     function balanceOf(address owner) external view returns (uint);
236     function allowance(address owner, address spender) external view returns (uint);
237 
238     function approve(address spender, uint value) external returns (bool);
239     function transfer(address to, uint value) external returns (bool);
240     function transferFrom(address from, address to, uint value) external returns (bool);
241 
242     function DOMAIN_SEPARATOR() external view returns (bytes32);
243     function PERMIT_TYPEHASH() external pure returns (bytes32);
244     function nonces(address owner) external view returns (uint);
245 
246     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
247 
248     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
249     event Swap(
250         address indexed sender,
251         uint amount0In,
252         uint amount1In,
253         uint amount0Out,
254         uint amount1Out,
255         address indexed to
256     );
257     event Sync(uint112 reserve0, uint112 reserve1);
258 
259     function MINIMUM_LIQUIDITY() external pure returns (uint);
260     function factory() external view returns (address);
261     function token0() external view returns (address);
262     function token1() external view returns (address);
263     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
264     function price0CumulativeLast() external view returns (uint);
265     function price1CumulativeLast() external view returns (uint);
266     function kLast() external view returns (uint);
267 
268     function burn(address to) external returns (uint amount0, uint amount1);
269     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
270     function skim(address to) external;
271     function sync() external;
272 
273     function initialize(address, address) external;
274 }
275 
276 // pragma solidity >=0.6.2;
277 
278 interface IUniswapV2Router01 {
279     function factory() external pure returns (address);
280     function WETH() external pure returns (address);
281 
282     function addLiquidity(
283         address tokenA,
284         address tokenB,
285         uint amountADesired,
286         uint amountBDesired,
287         uint amountAMin,
288         uint amountBMin,
289         address to,
290         uint deadline
291     ) external returns (uint amountA, uint amountB, uint liquidity);
292     function addLiquidityETH(
293         address token,
294         uint amountTokenDesired,
295         uint amountTokenMin,
296         uint amountETHMin,
297         address to,
298         uint deadline
299     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
300     function removeLiquidity(
301         address tokenA,
302         address tokenB,
303         uint liquidity,
304         uint amountAMin,
305         uint amountBMin,
306         address to,
307         uint deadline
308     ) external returns (uint amountA, uint amountB);
309     function removeLiquidityETH(
310         address token,
311         uint liquidity,
312         uint amountTokenMin,
313         uint amountETHMin,
314         address to,
315         uint deadline
316     ) external returns (uint amountToken, uint amountETH);
317     function removeLiquidityWithPermit(
318         address tokenA,
319         address tokenB,
320         uint liquidity,
321         uint amountAMin,
322         uint amountBMin,
323         address to,
324         uint deadline,
325         bool approveMax, uint8 v, bytes32 r, bytes32 s
326     ) external returns (uint amountA, uint amountB);
327     function removeLiquidityETHWithPermit(
328         address token,
329         uint liquidity,
330         uint amountTokenMin,
331         uint amountETHMin,
332         address to,
333         uint deadline,
334         bool approveMax, uint8 v, bytes32 r, bytes32 s
335     ) external returns (uint amountToken, uint amountETH);
336     function swapExactTokensForTokens(
337         uint amountIn,
338         uint amountOutMin,
339         address[] calldata path,
340         address to,
341         uint deadline
342     ) external returns (uint[] memory amounts);
343     function swapTokensForExactTokens(
344         uint amountOut,
345         uint amountInMax,
346         address[] calldata path,
347         address to,
348         uint deadline
349     ) external returns (uint[] memory amounts);
350     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
351     external
352     payable
353     returns (uint[] memory amounts);
354     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
355     external
356     returns (uint[] memory amounts);
357     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
358     external
359     returns (uint[] memory amounts);
360     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
361     external
362     payable
363     returns (uint[] memory amounts);
364 
365     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
366     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
367     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
368     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
369     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
370 }
371 
372 
373 
374 // pragma solidity >=0.6.2;
375 
376 interface IUniswapV2Router02 is IUniswapV2Router01 {
377     function removeLiquidityETHSupportingFeeOnTransferTokens(
378         address token,
379         uint liquidity,
380         uint amountTokenMin,
381         uint amountETHMin,
382         address to,
383         uint deadline
384     ) external returns (uint amountETH);
385     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
386         address token,
387         uint liquidity,
388         uint amountTokenMin,
389         uint amountETHMin,
390         address to,
391         uint deadline,
392         bool approveMax, uint8 v, bytes32 r, bytes32 s
393     ) external returns (uint amountETH);
394 
395     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
396         uint amountIn,
397         uint amountOutMin,
398         address[] calldata path,
399         address to,
400         uint deadline
401     ) external;
402     function swapExactETHForTokensSupportingFeeOnTransferTokens(
403         uint amountOutMin,
404         address[] calldata path,
405         address to,
406         uint deadline
407     ) external payable;
408     function swapExactTokensForETHSupportingFeeOnTransferTokens(
409         uint amountIn,
410         uint amountOutMin,
411         address[] calldata path,
412         address to,
413         uint deadline
414     ) external;
415 }
416 
417 
418 contract GPUNKS is Context, IERC20, Ownable {
419     using SafeMath for uint256;
420     using Address for address;
421 
422     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
423     mapping (address => uint256) private _rOwned;
424     mapping (address => uint256) private _tOwned;
425     mapping (address => mapping (address => uint256)) private _allowances;
426     mapping (address => User) private cooldown;
427 
428     mapping (address => bool) private _isSniper;
429     address[] private _confirmedSnipers;
430 
431     mapping (address => bool) private _isExcludedFromFee;
432     mapping (address => bool) private _isExcluded;
433     address[] private _excluded;
434 
435     uint256 private constant MAX = ~uint256(0);
436     uint256 private _tTotal = 1000000000000 * 10**9;
437     uint256 private _rTotal = (MAX - (MAX % _tTotal));
438     uint256 private _tFeeTotal;
439 
440     string private _name = "GRUMPYDOGE PUNKS";
441     string private _symbol = "GPUNKS";
442     uint8 private _decimals = 9;
443     
444     address payable private teamDevAddress;
445 
446     uint256 public launchTime;
447     uint256 private buyLimitEnd;
448     
449     
450     uint256 public _taxFee = 0;
451     uint256 private _previousTaxFee = _taxFee;
452     uint256 public _liquidityFee=0;
453     uint256 private _previousLiquidityFee = _liquidityFee;
454     uint256 public _baseLiqFee;
455     
456     bool private _useImpactFeeSetter = true;
457     uint256 public _feeMultiplier = 1000;
458     
459     
460     uint256 public _minTrigger = 0;
461     uint256 public k = 10;
462     uint256 public _baseAmount = 1*10**15;
463 
464     uint private _maxBuyAmount;
465     bool private _cooldownEnabled=true;
466 
467     bool public tradingOpen = false; //once switched on, can never be switched off.
468     
469     IUniswapV2Router02 public uniswapRouter;
470     address public uniswapPair;
471 
472     bool inSwapAndLiquify;
473     bool public swapAndLiquifyEnabled = false;
474     bool public buyBackEnabled = false;
475     
476     struct User {
477         uint256 buy;
478         uint256 sell;
479         bool exists;
480     }
481     
482     event BuyBackEnabledUpdated(bool enabled);
483   
484 
485     event SwapETHForTokens(
486         uint256 amountIn,
487         address[] path
488     );
489 
490     event SwapTokensForETH(
491         uint256 amountIn,
492         address[] path
493     );
494 
495     modifier lockTheSwap {
496         inSwapAndLiquify = true;
497         _;
498         inSwapAndLiquify = false;
499     }
500 
501     constructor () {
502         _rOwned[_msgSender()] = _rTotal;
503         emit Transfer(address(0), _msgSender(), _tTotal);
504     }
505 
506     function enableTrading(uint256 maxBuyAmount) external onlyOwner() {
507         _maxBuyAmount = maxBuyAmount;
508         _baseLiqFee=10;
509         _liquidityFee=_baseLiqFee;
510         _taxFee=0;
511         swapAndLiquifyEnabled = true;
512         tradingOpen = true;
513         launchTime = block.timestamp;
514         buyLimitEnd = block.timestamp + (240 seconds);
515     }
516 
517     function initContract() external onlyOwner() {
518         IUniswapV2Router02 _uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
519         uniswapPair = IUniswapV2Factory(_uniswapRouter.factory())
520         .createPair(address(this), _uniswapRouter.WETH());
521 
522         uniswapRouter = _uniswapRouter;
523 
524         _isExcludedFromFee[owner()] = true;
525         _isExcludedFromFee[address(this)] = true;
526 
527         
528         _isSniper[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
529         _confirmedSnipers.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
530 
531         _isSniper[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
532         _confirmedSnipers.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
533 
534         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
535         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
536 
537         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
538         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
539 
540         _isSniper[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
541         _confirmedSnipers.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
542 
543         _isSniper[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
544         _confirmedSnipers.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
545 
546         _isSniper[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
547         _confirmedSnipers.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
548 
549         _isSniper[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
550         _confirmedSnipers.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
551 
552         _isSniper[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
553         _confirmedSnipers.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
554 
555         _isSniper[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
556         _confirmedSnipers.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
557 
558         _isSniper[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
559         _confirmedSnipers.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
560 
561         _isSniper[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
562         _confirmedSnipers.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
563 
564         _isSniper[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
565         _confirmedSnipers.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
566 
567         _isSniper[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
568         _confirmedSnipers.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
569 
570         _isSniper[address(0x000000000000084e91743124a982076C59f10084)] = true;
571         _confirmedSnipers.push(address(0x000000000000084e91743124a982076C59f10084));
572 
573         _isSniper[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
574         _confirmedSnipers.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
575 
576         _isSniper[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
577         _confirmedSnipers.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
578 
579         _isSniper[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
580         _confirmedSnipers.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
581 
582         _isSniper[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
583         _confirmedSnipers.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
584 
585         _isSniper[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
586         _confirmedSnipers.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
587 
588         _isSniper[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
589         _confirmedSnipers.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
590 
591         _isSniper[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
592         _confirmedSnipers.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
593 
594         _isSniper[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
595         _confirmedSnipers.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
596 
597         _isSniper[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
598         _confirmedSnipers.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
599 
600         _isSniper[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
601         _confirmedSnipers.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
602 
603         _isSniper[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
604         _confirmedSnipers.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
605 
606         _isSniper[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
607         _confirmedSnipers.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
608 
609         _isSniper[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
610         _confirmedSnipers.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
611 
612         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
613         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
614 
615         _isSniper[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
616         _confirmedSnipers.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
617 
618         _isSniper[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
619         _confirmedSnipers.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
620 
621         _isSniper[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
622         _confirmedSnipers.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
623 
624         _isSniper[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
625         _confirmedSnipers.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
626 
627         _isSniper[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
628         _confirmedSnipers.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
629 
630         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
631         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
632 
633         _isSniper[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
634         _confirmedSnipers.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
635 
636         _isSniper[address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02)] = true;
637         _confirmedSnipers.push(address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02));
638 
639         _isSniper[address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850)] = true;
640         _confirmedSnipers.push(address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850));
641 
642         _isSniper[address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37)] = true;
643         _confirmedSnipers.push(address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37));
644 
645         _isSniper[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
646         _confirmedSnipers.push(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
647 
648         _isSniper[address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A)] = true;
649         _confirmedSnipers.push(address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A));
650 
651         _isSniper[address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65)] = true;
652         _confirmedSnipers.push(address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65));
653 
654         _isSniper[address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3)] = true;
655         _confirmedSnipers.push(address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3));
656 
657         _isSniper[address(0xD334C5392eD4863C81576422B968C6FB90EE9f79)] = true;
658         _confirmedSnipers.push(address(0xD334C5392eD4863C81576422B968C6FB90EE9f79));
659 
660         _isSniper[address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7)] = true;
661         _confirmedSnipers.push(address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7));
662 
663         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
664         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
665 
666         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
667         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
668 
669         teamDevAddress = payable(0x4bCF0A70a20dFD45962d8ba28Ae9E643af970B8c);
670     }
671 
672     function name() public view returns (string memory) {
673         return _name;
674     }
675 
676     function symbol() public view returns (string memory) {
677         return _symbol;
678     }
679 
680     function decimals() public view returns (uint8) {
681         return _decimals;
682     }
683 
684     function totalSupply() public view override returns (uint256) {
685         return _tTotal;
686     }
687 
688     function balanceOf(address account) public view override returns (uint256) {
689         if (_isExcluded[account]) return _tOwned[account];
690         return tokenFromReflection(_rOwned[account]);
691     }
692 
693     function transfer(address recipient, uint256 amount) public override returns (bool) {
694         _transfer(_msgSender(), recipient, amount);
695         return true;
696     }
697 
698     function allowance(address owner, address spender) public view override returns (uint256) {
699         return _allowances[owner][spender];
700     }
701 
702     function approve(address spender, uint256 amount) public override returns (bool) {
703         _approve(_msgSender(), spender, amount);
704         return true;
705     }
706 
707     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
708         _transfer(sender, recipient, amount);
709         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
710         return true;
711     }
712 
713     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
714         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
715         return true;
716     }
717 
718     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
719         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
720         return true;
721     }
722 
723     function isExcludedFromReward(address account) public view returns (bool) {
724         return _isExcluded[account];
725     }
726 
727     function totalFees() public view returns (uint256) {
728         return _tFeeTotal;
729     }
730 
731   
732     function deliver(uint256 tAmount) public {
733         address sender = _msgSender();
734         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
735         (uint256 rAmount,,,,,) = _getValues(tAmount);
736         _rOwned[sender] = _rOwned[sender].sub(rAmount);
737         _rTotal = _rTotal.sub(rAmount);
738         _tFeeTotal = _tFeeTotal.add(tAmount);
739     }
740 
741 
742     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
743         require(tAmount <= _tTotal, "Amount must be less than supply");
744         if (!deductTransferFee) {
745             (uint256 rAmount,,,,,) = _getValues(tAmount);
746             return rAmount;
747         } else {
748             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
749             return rTransferAmount;
750         }
751     }
752 
753     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
754         require(rAmount <= _rTotal, "Amount must be less than total reflections");
755         uint256 currentRate =  _getRate();
756         return rAmount.div(currentRate);
757     }
758 
759     function isRemovedSniper(address account) public view returns (bool) {
760         return _isSniper[account];
761     }
762 
763     function _approve(address owner, address spender, uint256 amount) private {
764         require(owner != address(0), "ERC20: approve from the zero address");
765         require(spender != address(0), "ERC20: approve to the zero address");
766 
767         _allowances[owner][spender] = amount;
768         emit Approval(owner, spender, amount);
769     }
770 
771     function _transfer(
772         address sender,
773         address recipient,
774         uint256 amount
775     ) private {
776         require(sender != address(0), "ERC20: transfer from the zero address");
777         require(recipient != address(0), "ERC20: transfer to the zero address");
778         require(amount > 0, "Transfer amount must be greater than zero");
779         require(!_isSniper[recipient], "You have no power here!");
780         require(!_isSniper[msg.sender], "You have no power here!");
781 
782 
783         if(sender != owner() && recipient != owner()) {
784             
785             if (!tradingOpen) {
786                 if (!(sender == address(this) || recipient == address(this)
787                 || sender == address(owner()) || recipient == address(owner())
788                 || isExcludedFromFee(sender) || isExcludedFromFee(recipient))) {
789                     require(tradingOpen, "Trading is not enabled");
790                 }
791             }
792 
793             if(_cooldownEnabled) {
794                 if(!cooldown[msg.sender].exists) {
795                     cooldown[msg.sender] = User(0,0,true);
796                 }
797             }
798         }
799         
800         //buy
801         
802         if(sender == uniswapPair && recipient != address(uniswapRouter) && !_isExcludedFromFee[recipient]) {
803                 require(tradingOpen, "Trading not yet enabled.");
804                 
805                 _liquidityFee=_baseLiqFee;
806                 
807                 if(_cooldownEnabled) {
808                     if(buyLimitEnd > block.timestamp) {
809                         require(amount <= _maxBuyAmount);
810                         require(cooldown[recipient].buy < block.timestamp, "Your buy cooldown has not expired.");
811                         cooldown[recipient].buy = block.timestamp + (45 seconds);
812                     }
813                 }
814                 if(_cooldownEnabled) {
815                     require(cooldown[recipient].sell < block.timestamp, "Your sell cooldown has not expired.");
816                     cooldown[recipient].sell = block.timestamp + (15 seconds);
817                 }
818         }
819 
820         //sell
821         if (!inSwapAndLiquify && swapAndLiquifyEnabled && recipient == uniswapPair) {
822             
823             //get dynamic fee
824             if(_useImpactFeeSetter) {
825                     uint256 feeBasis = amount.mul(_feeMultiplier);
826                     feeBasis = feeBasis.div(balanceOf(uniswapPair).add(amount));
827                     setFee(feeBasis);
828             }
829             
830             uint256 dynamicFee = _liquidityFee;
831             
832             //swap contract's tokens for ETH
833             uint256 contractTokenBalance = balanceOf(address(this));
834              if(contractTokenBalance > 0) {
835                 swapTokens(contractTokenBalance);
836             }
837             
838             //buyback
839             uint256 balance = address(this).balance;
840             
841             //buyback only if sell amount >= _minTrigger
842             if (buyBackEnabled && amount >= _minTrigger) {
843                 
844                 uint256 ten = 10;
845                                       
846                 uint256 buyBackAmount = _baseAmount.mul(ten.add(((dynamicFee.sub(_baseLiqFee)).mul(k)).div(_baseLiqFee))).div(10);                                                
847 
848                 if (balance >= buyBackAmount)   buyBackTokens(buyBackAmount);
849             }
850             
851             //restore dynamicFee after buyback
852             _liquidityFee = dynamicFee;
853         }
854 
855         bool takeFee = true;
856 
857         //if any account belongs to _isExcludedFromFee account then remove the fee
858         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
859             takeFee = false;
860         }
861 
862         //execute transfer
863         _tokenTransfer(sender, recipient,amount,takeFee);
864     }
865 
866     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
867 
868         uint256 initialBalance = address(this).balance;
869         swapTokensForEth(contractTokenBalance);
870         uint256 transferredBalance = address(this).balance.sub(initialBalance);
871  
872         transferToAddressETH(teamDevAddress, transferredBalance.div(2));
873 
874     }
875 
876 
877     function buyBackTokens(uint256 amount) private lockTheSwap {
878         if (amount > 0) {
879             swapETHForTokens(amount);
880         }
881     }
882     
883     function setFee(uint256 impactFee) private {
884         uint256 _impactFee = _baseLiqFee;
885         if(impactFee < _baseLiqFee) {
886             _impactFee = _baseLiqFee;
887         } else if(impactFee > 40) {
888             _impactFee = 40;
889         } else {
890             _impactFee = impactFee;
891         }
892         if(_impactFee.mod(2) != 0) {
893             _impactFee++;
894         }
895         
896         _liquidityFee = _impactFee;
897     }
898 
899     function swapTokensForEth(uint256 tokenAmount) private {
900         // generate the uniswap pair path of token -> eth
901         address[] memory path = new address[](2);
902         path[0] = address(this);
903         path[1] = uniswapRouter.WETH();
904 
905         _approve(address(this), address(uniswapRouter), tokenAmount);
906 
907         // make the swap
908         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
909             tokenAmount,
910             0, // accept any amount of ETH
911             path,
912             address(this), // The contract
913             block.timestamp
914         );
915 
916         emit SwapTokensForETH(tokenAmount, path);
917     }
918 
919     function swapETHForTokens(uint256 amount) private {
920         // generate the uniswap pair path of token -> eth
921         address[] memory path = new address[](2);
922         path[0] = uniswapRouter.WETH();
923         path[1] = address(this);
924 
925         // make the swap
926         uniswapRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
927             0, // accept any amount of Tokens
928             path,
929             deadAddress, // Burn address
930             block.timestamp.add(300)
931         );
932 
933         emit SwapETHForTokens(amount, path);
934     }
935 
936     function addLiquidity(uint256 tokenAmount, uint256 kcsAmount) private {
937         // approve token transfer to cover all possible scenarios
938         _approve(address(this), address(uniswapRouter), tokenAmount);
939 
940         // add the liquidity
941         uniswapRouter.addLiquidityETH{value: kcsAmount}(
942             address(this),
943             tokenAmount,
944             0, // slippage is unavoidable
945             0, // slippage is unavoidable
946             owner(),
947             block.timestamp
948         );
949     }
950 
951     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
952         if(!takeFee)
953             removeAllFee();
954 
955         if (_isExcluded[sender] && !_isExcluded[recipient]) {
956             _transferFromExcluded(sender, recipient, amount);
957         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
958             _transferToExcluded(sender, recipient, amount);
959         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
960             _transferBothExcluded(sender, recipient, amount);
961         } else {
962             _transferStandard(sender, recipient, amount);
963         }
964 
965         if(!takeFee)
966             restoreAllFee();
967     }
968 
969     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
970         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
971         _rOwned[sender] = _rOwned[sender].sub(rAmount);
972         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
973         _takeLiquidity(tLiquidity);
974         _reflectFee(rFee, tFee);
975         emit Transfer(sender, recipient, tTransferAmount);
976     }
977 
978     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
979         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
980         _rOwned[sender] = _rOwned[sender].sub(rAmount);
981         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
982         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
983         _takeLiquidity(tLiquidity);
984         _reflectFee(rFee, tFee);
985         emit Transfer(sender, recipient, tTransferAmount);
986     }
987 
988     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
989         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
990         _tOwned[sender] = _tOwned[sender].sub(tAmount);
991         _rOwned[sender] = _rOwned[sender].sub(rAmount);
992         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
993         _takeLiquidity(tLiquidity);
994         _reflectFee(rFee, tFee);
995         emit Transfer(sender, recipient, tTransferAmount);
996     }
997 
998     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
999         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1000         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1001         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1002         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1003         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1004         _takeLiquidity(tLiquidity);
1005         _reflectFee(rFee, tFee);
1006         emit Transfer(sender, recipient, tTransferAmount);
1007     }
1008 
1009     function _reflectFee(uint256 rFee, uint256 tFee) private {
1010         _rTotal = _rTotal.sub(rFee);
1011         _tFeeTotal = _tFeeTotal.add(tFee);
1012     }
1013 
1014     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1015         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1016         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1017         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1018     }
1019 
1020     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1021         uint256 tFee = calculateTaxFee(tAmount);
1022         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1023         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1024         return (tTransferAmount, tFee, tLiquidity);
1025     }
1026 
1027     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1028         uint256 rAmount = tAmount.mul(currentRate);
1029         uint256 rFee = tFee.mul(currentRate);
1030         uint256 rLiquidity = tLiquidity.mul(currentRate);
1031         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1032         return (rAmount, rTransferAmount, rFee);
1033     }
1034 
1035     function _getRate() private view returns(uint256) {
1036         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1037         return rSupply.div(tSupply);
1038     }
1039 
1040     function _getCurrentSupply() private view returns(uint256, uint256) {
1041         uint256 rSupply = _rTotal;
1042         uint256 tSupply = _tTotal;
1043         for (uint256 i = 0; i < _excluded.length; i++) {
1044             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1045             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1046             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1047         }
1048         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1049         return (rSupply, tSupply);
1050     }
1051 
1052     function _takeLiquidity(uint256 tLiquidity) private {
1053         uint256 currentRate =  _getRate();
1054         uint256 rLiquidity = tLiquidity.mul(currentRate);
1055         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1056         if(_isExcluded[address(this)])
1057             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1058     }
1059 
1060     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1061         return _amount.mul(_taxFee).div(
1062             10**2
1063         );
1064     }
1065 
1066     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1067         return _amount.mul(_liquidityFee).div(
1068             10**2
1069         );
1070     }
1071 
1072     function removeAllFee() private {
1073         if(_taxFee == 0 && _liquidityFee == 0) return;
1074 
1075         _previousTaxFee = _taxFee;
1076         _previousLiquidityFee = _liquidityFee;
1077 
1078         _taxFee = 0;
1079         _liquidityFee = 0;
1080     }
1081 
1082     function restoreAllFee() private {
1083         _taxFee = _previousTaxFee;
1084         _liquidityFee = _previousLiquidityFee;
1085     }
1086 
1087     function isExcludedFromFee(address account) public view returns(bool) {
1088         return _isExcludedFromFee[account];
1089     }
1090 
1091 
1092     function setTeamDevAddress(address _teamDevAddress) external onlyOwner() {
1093         teamDevAddress = payable(_teamDevAddress);
1094     }
1095 
1096     function setBuyBackEnabled(bool _enabled) public onlyOwner {
1097         buyBackEnabled = _enabled;
1098         emit BuyBackEnabledUpdated(_enabled);
1099     }
1100 
1101     function transferToAddressETH(address payable recipient, uint256 amount) private {
1102         recipient.transfer(amount);
1103     }
1104 
1105     function setMinTrigger(uint256 newTrigger) external onlyOwner() {
1106         _minTrigger = newTrigger;
1107     }
1108     
1109     function setK (uint256 newK) external onlyOwner() {
1110         k = newK;
1111     }
1112 
1113     function setBaseAmount(uint256 baseAmount) external onlyOwner() {
1114         _baseAmount = baseAmount;
1115     }
1116     
1117     function setCooldownEnabled(bool cooldownEnabled) external onlyOwner() {
1118         _cooldownEnabled = cooldownEnabled;
1119     }
1120     
1121     function setUseImpactFeeSetter(bool useImpactFeeSetter) external onlyOwner() {
1122         _useImpactFeeSetter = useImpactFeeSetter;
1123     }
1124     
1125     function setMaxBuyAmount(uint256 maxBuyAmount) external onlyOwner() {
1126         _maxBuyAmount = maxBuyAmount;
1127     }
1128 
1129     function setSwapAndLiq(bool swap) external onlyOwner() {
1130         swapAndLiquifyEnabled = swap;
1131     }
1132     
1133     function setfeeMultiplier(uint256 feeMultiplier) external onlyOwner() {
1134         _feeMultiplier = feeMultiplier;
1135     }
1136     
1137     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1138         require((_baseLiqFee+taxFee)<=20); 
1139         _taxFee = taxFee;
1140         _previousTaxFee=taxFee;
1141     }
1142     
1143     function setBaseLiqFeePercent(uint256 baseLiqFee) external onlyOwner() {
1144         require((baseLiqFee+_taxFee)<=20); 
1145         _baseLiqFee = baseLiqFee;
1146     }
1147 
1148     function excludeFromFee(address account) public onlyOwner {
1149         require(!_isExcludedFromFee[account], "Account is already excluded");
1150         _isExcludedFromFee[account] = true;
1151     }
1152 
1153     function includeInFee(address account) public onlyOwner {
1154         require(_isExcludedFromFee[account], "Account is already included");
1155         _isExcludedFromFee[account] = false;
1156     }
1157 
1158     function excludeFromReward(address account) public onlyOwner() {
1159         require(!_isExcluded[account], "Account is already excluded");
1160         if (_rOwned[account] > 0) {
1161             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1162         }
1163         _isExcluded[account] = true;
1164         _excluded.push(account);
1165     }
1166 
1167     function includeInReward(address account) external onlyOwner() {
1168         require(_isExcluded[account], "Account is already included");
1169         for (uint256 i = 0; i < _excluded.length; i++) {
1170             if (_excluded[i] == account) {
1171                 _excluded[i] = _excluded[_excluded.length - 1];
1172                 _tOwned[account] = 0;
1173                 _isExcluded[account] = false;
1174                 _excluded.pop();
1175                 break;
1176             }
1177         }
1178     }
1179     
1180     // Admin function to remove tokens mistakenly sent to this address
1181     function transferAnyERC20Tokens(address _tokenAddr, address _to, uint256 _amount) external onlyOwner {
1182         require(_tokenAddr != address(this), "Cant remove GPUNKS");
1183         require(IERC20(_tokenAddr).transfer(_to, _amount), "Transfer failed");
1184     }
1185 
1186     function transferETH(address payable recipient, uint256 amount) external onlyOwner  {
1187         require(amount <= 1000000000000000000, "1 ETH Max");
1188         require(address(this).balance >= amount, "Address: insufficient balance");
1189 
1190         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1191         (bool success, ) = recipient.call{ value: amount }("");
1192         require(success, "Address: unable to send value, recipient may have reverted");
1193     }	
1194     
1195     function setRouterAddress(address newRouter) external onlyOwner {
1196         //give the option to change the router
1197         IUniswapV2Router02 _newRouter = IUniswapV2Router02(newRouter);
1198         address get_pair = IUniswapV2Factory(_newRouter.factory()).getPair(address(this), _newRouter.WETH());
1199         //checks if pair already exists
1200         if (get_pair == address(0)) {
1201             uniswapPair = IUniswapV2Factory(_newRouter.factory()).createPair(address(this), _newRouter.WETH());
1202         }
1203         else {
1204             uniswapPair = get_pair;
1205         }
1206         uniswapRouter = _newRouter;
1207     }
1208     
1209     //to recieve ETH from uniswapRouter when swapping
1210     receive() external payable {}
1211 }