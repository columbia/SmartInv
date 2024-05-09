1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-28
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity ^0.8.4;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return payable(msg.sender);
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 
21 interface IERC20 {
22 
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 
32 
33 }
34 
35 library SafeMath {
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51 
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62 
63         return c;
64     }
65 
66 
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         return div(a, b, "SafeMath: division by zero");
69     }
70 
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b > 0, errorMessage);
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76         return c;
77     }
78 
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         return mod(a, b, "SafeMath: modulo by zero");
81     }
82 
83     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b != 0, errorMessage);
85         return a % b;
86     }
87 }
88 
89 library Address {
90 
91     function isContract(address account) internal view returns (bool) {
92         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
93         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
94         // for accounts without code, i.e. `keccak256('')`
95         bytes32 codehash;
96         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
97         // solhint-disable-next-line no-inline-assembly
98         assembly { codehash := extcodehash(account) }
99         return (codehash != accountHash && codehash != 0x0);
100     }
101 
102     function sendValue(address payable recipient, uint256 amount) internal {
103         require(address(this).balance >= amount, "Address: insufficient balance");
104 
105         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
106         (bool success, ) = recipient.call{ value: amount }("");
107         require(success, "Address: unable to send value, recipient may have reverted");
108     }
109 
110 
111     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
112         return functionCall(target, data, "Address: low-level call failed");
113     }
114 
115     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
116         return _functionCallWithValue(target, data, 0, errorMessage);
117     }
118 
119     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
121     }
122 
123     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
124         require(address(this).balance >= value, "Address: insufficient balance for call");
125         return _functionCallWithValue(target, data, value, errorMessage);
126     }
127 
128     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
129         require(isContract(target), "Address: call to non-contract");
130 
131         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
132         if (success) {
133             return returndata;
134         } else {
135 
136             if (returndata.length > 0) {
137                 assembly {
138                     let returndata_size := mload(returndata)
139                     revert(add(32, returndata), returndata_size)
140                 }
141             } else {
142                 revert(errorMessage);
143             }
144         }
145     }
146 }
147 
148 contract Ownable is Context {
149     address private _owner;
150     address private _previousOwner;
151     uint256 private _lockTime;
152 
153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155     constructor () {
156         address msgSender = _msgSender();
157         _owner = msgSender;
158         emit OwnershipTransferred(address(0), msgSender);
159     }
160 
161     function owner() public view returns (address) {
162         return _owner;
163     }
164 
165     modifier onlyOwner() {
166         require(_owner == _msgSender(), "Ownable: caller is not the owner");
167         _;
168     }
169 
170     
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 
177     function getUnlockTime() public view returns (uint256) {
178         return _lockTime;
179     }
180 
181     function getTime() public view returns (uint256) {
182         return block.timestamp;
183     }
184 
185     function lock(uint256 time) public virtual onlyOwner {
186         _previousOwner = _owner;
187         _owner = address(0);
188         _lockTime = block.timestamp + time;
189         emit OwnershipTransferred(_owner, address(0));
190     }
191 
192     function unlock() public virtual {
193         require(_previousOwner == msg.sender, "You don't have permission to unlock");
194         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
195         emit OwnershipTransferred(_owner, _previousOwner);
196         _owner = _previousOwner;
197     }
198 }
199 
200 // pragma solidity >=0.5.0;
201 
202 interface IUniswapV2Factory {
203     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
204 
205     function feeTo() external view returns (address);
206     function feeToSetter() external view returns (address);
207 
208     function getPair(address tokenA, address tokenB) external view returns (address pair);
209     function allPairs(uint) external view returns (address pair);
210     function allPairsLength() external view returns (uint);
211 
212     function createPair(address tokenA, address tokenB) external returns (address pair);
213 
214     function setFeeTo(address) external;
215     function setFeeToSetter(address) external;
216 }
217 
218 
219 // pragma solidity >=0.5.0;
220 
221 interface IUniswapV2Pair {
222     event Approval(address indexed owner, address indexed spender, uint value);
223     event Transfer(address indexed from, address indexed to, uint value);
224 
225     function name() external pure returns (string memory);
226     function symbol() external pure returns (string memory);
227     function decimals() external pure returns (uint8);
228     function totalSupply() external view returns (uint);
229     function balanceOf(address owner) external view returns (uint);
230     function allowance(address owner, address spender) external view returns (uint);
231 
232     function approve(address spender, uint value) external returns (bool);
233     function transfer(address to, uint value) external returns (bool);
234     function transferFrom(address from, address to, uint value) external returns (bool);
235 
236     function DOMAIN_SEPARATOR() external view returns (bytes32);
237     function PERMIT_TYPEHASH() external pure returns (bytes32);
238     function nonces(address owner) external view returns (uint);
239 
240     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
241 
242     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
243     event Swap(
244         address indexed sender,
245         uint amount0In,
246         uint amount1In,
247         uint amount0Out,
248         uint amount1Out,
249         address indexed to
250     );
251     event Sync(uint112 reserve0, uint112 reserve1);
252 
253     function MINIMUM_LIQUIDITY() external pure returns (uint);
254     function factory() external view returns (address);
255     function token0() external view returns (address);
256     function token1() external view returns (address);
257     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
258     function price0CumulativeLast() external view returns (uint);
259     function price1CumulativeLast() external view returns (uint);
260     function kLast() external view returns (uint);
261 
262     function burn(address to) external returns (uint amount0, uint amount1);
263     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
264     function skim(address to) external;
265     function sync() external;
266 
267     function initialize(address, address) external;
268 }
269 
270 // pragma solidity >=0.6.2;
271 
272 interface IUniswapV2Router01 {
273     function factory() external pure returns (address);
274     function WETH() external pure returns (address);
275 
276     function addLiquidity(
277         address tokenA,
278         address tokenB,
279         uint amountADesired,
280         uint amountBDesired,
281         uint amountAMin,
282         uint amountBMin,
283         address to,
284         uint deadline
285     ) external returns (uint amountA, uint amountB, uint liquidity);
286     function addLiquidityETH(
287         address token,
288         uint amountTokenDesired,
289         uint amountTokenMin,
290         uint amountETHMin,
291         address to,
292         uint deadline
293     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
294     function removeLiquidity(
295         address tokenA,
296         address tokenB,
297         uint liquidity,
298         uint amountAMin,
299         uint amountBMin,
300         address to,
301         uint deadline
302     ) external returns (uint amountA, uint amountB);
303     function removeLiquidityETH(
304         address token,
305         uint liquidity,
306         uint amountTokenMin,
307         uint amountETHMin,
308         address to,
309         uint deadline
310     ) external returns (uint amountToken, uint amountETH);
311     function removeLiquidityWithPermit(
312         address tokenA,
313         address tokenB,
314         uint liquidity,
315         uint amountAMin,
316         uint amountBMin,
317         address to,
318         uint deadline,
319         bool approveMax, uint8 v, bytes32 r, bytes32 s
320     ) external returns (uint amountA, uint amountB);
321     function removeLiquidityETHWithPermit(
322         address token,
323         uint liquidity,
324         uint amountTokenMin,
325         uint amountETHMin,
326         address to,
327         uint deadline,
328         bool approveMax, uint8 v, bytes32 r, bytes32 s
329     ) external returns (uint amountToken, uint amountETH);
330     function swapExactTokensForTokens(
331         uint amountIn,
332         uint amountOutMin,
333         address[] calldata path,
334         address to,
335         uint deadline
336     ) external returns (uint[] memory amounts);
337     function swapTokensForExactTokens(
338         uint amountOut,
339         uint amountInMax,
340         address[] calldata path,
341         address to,
342         uint deadline
343     ) external returns (uint[] memory amounts);
344     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
345     external
346     payable
347     returns (uint[] memory amounts);
348     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
349     external
350     returns (uint[] memory amounts);
351     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
352     external
353     returns (uint[] memory amounts);
354     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
355     external
356     payable
357     returns (uint[] memory amounts);
358 
359     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
360     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
361     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
362     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
363     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
364 }
365 
366 
367 
368 // pragma solidity >=0.6.2;
369 
370 interface IUniswapV2Router02 is IUniswapV2Router01 {
371     function removeLiquidityETHSupportingFeeOnTransferTokens(
372         address token,
373         uint liquidity,
374         uint amountTokenMin,
375         uint amountETHMin,
376         address to,
377         uint deadline
378     ) external returns (uint amountETH);
379     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
380         address token,
381         uint liquidity,
382         uint amountTokenMin,
383         uint amountETHMin,
384         address to,
385         uint deadline,
386         bool approveMax, uint8 v, bytes32 r, bytes32 s
387     ) external returns (uint amountETH);
388 
389     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
390         uint amountIn,
391         uint amountOutMin,
392         address[] calldata path,
393         address to,
394         uint deadline
395     ) external;
396     function swapExactETHForTokensSupportingFeeOnTransferTokens(
397         uint amountOutMin,
398         address[] calldata path,
399         address to,
400         uint deadline
401     ) external payable;
402     function swapExactTokensForETHSupportingFeeOnTransferTokens(
403         uint amountIn,
404         uint amountOutMin,
405         address[] calldata path,
406         address to,
407         uint deadline
408     ) external;
409 }
410 
411 contract EtherRise is Context, IERC20, Ownable {
412     using SafeMath for uint256;
413     using Address for address;
414 
415     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
416     mapping (address => uint256) private _rOwned;
417     mapping (address => uint256) private _tOwned;
418     mapping (address => mapping (address => uint256)) private _allowances;
419     mapping (address => User) private cooldown;
420 
421     mapping (address => bool) private _isSniper;
422     address[] private _confirmedSnipers;
423 
424     mapping (address => bool) private _isExcludedFromFee;
425     mapping (address => bool) private _isExcluded;
426     address[] private _excluded;
427 
428     uint256 private constant MAX = ~uint256(0);
429     uint256 private _tTotal = 1000000000000 * 10**9;
430     uint256 private _rTotal = (MAX - (MAX % _tTotal));
431     uint256 private _tFeeTotal;
432 
433     string private _name = "EtherRise";
434     string private _symbol = "eRise";
435     uint8 private _decimals = 9;
436     
437     address payable private operationsAddress;
438 
439     uint256 public launchTime;
440     uint256 private buyLimitEnd;
441     
442     
443     uint256 public _taxFee = 0;
444     uint256 private _previousTaxFee = _taxFee;
445     uint256 public _liquidityFee=0;
446     uint256 private _previousLiquidityFee = _liquidityFee;
447     uint256 public _baseLiqFee;
448     
449     bool private _useImpactFeeSetter = true;
450     uint256 private _feeMultiplier = 1000;
451     
452     
453     uint256 public _minTrigger = 0;
454     uint256 public k = 10;
455     uint256 public _baseAmount = 1*10**15;
456 
457     uint private _maxBuyAmount;
458     bool private _cooldownEnabled=true; // Prevents TX spamming and bot abuse
459 
460     bool public tradingOpen = false; //once switched on, can never be switched off.
461     
462 
463 
464     IUniswapV2Router02 public uniswapV2Router;
465     address public uniswapV2Pair;
466 
467     bool inSwapAndLiquify;
468     bool public swapAndLiquifyEnabled = false;
469     bool public buyBackEnabled = false;
470     
471     struct User {
472         uint256 buy;
473         uint256 sell;
474         bool exists;
475     }
476     
477     event BuyBackEnabledUpdated(bool enabled);
478   
479 
480     event SwapETHForTokens(
481         uint256 amountIn,
482         address[] path
483     );
484 
485     event SwapTokensForETH(
486         uint256 amountIn,
487         address[] path
488     );
489 
490     modifier lockTheSwap {
491         inSwapAndLiquify = true;
492         _;
493         inSwapAndLiquify = false;
494     }
495 
496     constructor () {
497         _rOwned[_msgSender()] = _rTotal;
498         emit Transfer(address(0), _msgSender(), _tTotal);
499     }
500 
501     function enableTrading() external onlyOwner() {
502         _maxBuyAmount = 2000000000 * 10**9;
503         _baseLiqFee=20;
504         _liquidityFee=_baseLiqFee;
505         _taxFee=0;
506         swapAndLiquifyEnabled = true;
507         tradingOpen = true;
508         launchTime = block.timestamp;
509         buyLimitEnd = block.timestamp + (60 seconds);
510     }
511 
512     function initContract() external onlyOwner() {
513         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
514         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
515         .createPair(address(this), _uniswapV2Router.WETH());
516 
517         uniswapV2Router = _uniswapV2Router;
518 
519         _isExcludedFromFee[owner()] = true;
520         _isExcludedFromFee[address(this)] = true;
521 
522         
523         _isSniper[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
524         _confirmedSnipers.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
525 
526         _isSniper[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
527         _confirmedSnipers.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
528 
529         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
530         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
531 
532         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
533         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
534 
535         _isSniper[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
536         _confirmedSnipers.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
537 
538         _isSniper[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
539         _confirmedSnipers.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
540 
541         _isSniper[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
542         _confirmedSnipers.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
543 
544         _isSniper[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
545         _confirmedSnipers.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
546 
547         _isSniper[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
548         _confirmedSnipers.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
549 
550         _isSniper[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
551         _confirmedSnipers.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
552 
553         _isSniper[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
554         _confirmedSnipers.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
555 
556         _isSniper[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
557         _confirmedSnipers.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
558 
559         _isSniper[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
560         _confirmedSnipers.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
561 
562         _isSniper[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
563         _confirmedSnipers.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
564 
565         _isSniper[address(0x000000000000084e91743124a982076C59f10084)] = true;
566         _confirmedSnipers.push(address(0x000000000000084e91743124a982076C59f10084));
567 
568         _isSniper[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
569         _confirmedSnipers.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
570 
571         _isSniper[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
572         _confirmedSnipers.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
573 
574         _isSniper[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
575         _confirmedSnipers.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
576 
577         _isSniper[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
578         _confirmedSnipers.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
579 
580         _isSniper[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
581         _confirmedSnipers.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
582 
583         _isSniper[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
584         _confirmedSnipers.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
585 
586         _isSniper[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
587         _confirmedSnipers.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
588 
589         _isSniper[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
590         _confirmedSnipers.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
591 
592         _isSniper[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
593         _confirmedSnipers.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
594 
595         _isSniper[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
596         _confirmedSnipers.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
597 
598         _isSniper[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
599         _confirmedSnipers.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
600 
601         _isSniper[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
602         _confirmedSnipers.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
603 
604         _isSniper[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
605         _confirmedSnipers.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
606 
607         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
608         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
609 
610         _isSniper[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
611         _confirmedSnipers.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
612 
613         _isSniper[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
614         _confirmedSnipers.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
615 
616         _isSniper[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
617         _confirmedSnipers.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
618 
619         _isSniper[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
620         _confirmedSnipers.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
621 
622         _isSniper[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
623         _confirmedSnipers.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
624 
625         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
626         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
627 
628         _isSniper[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
629         _confirmedSnipers.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
630 
631         _isSniper[address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02)] = true;
632         _confirmedSnipers.push(address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02));
633 
634         _isSniper[address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850)] = true;
635         _confirmedSnipers.push(address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850));
636 
637         _isSniper[address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37)] = true;
638         _confirmedSnipers.push(address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37));
639 
640         _isSniper[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
641         _confirmedSnipers.push(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
642 
643         _isSniper[address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A)] = true;
644         _confirmedSnipers.push(address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A));
645 
646         _isSniper[address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65)] = true;
647         _confirmedSnipers.push(address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65));
648 
649         _isSniper[address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3)] = true;
650         _confirmedSnipers.push(address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3));
651 
652         _isSniper[address(0xD334C5392eD4863C81576422B968C6FB90EE9f79)] = true;
653         _confirmedSnipers.push(address(0xD334C5392eD4863C81576422B968C6FB90EE9f79));
654 
655         _isSniper[address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7)] = true;
656         _confirmedSnipers.push(address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7));
657 
658         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
659         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
660 
661         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
662         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
663 
664         operationsAddress = payable(0x2509D7F1BF4eAf5c052F3bD7af3BA374Fc4958e7);
665     }
666 
667     function name() public view returns (string memory) {
668         return _name;
669     }
670 
671     function symbol() public view returns (string memory) {
672         return _symbol;
673     }
674 
675     function decimals() public view returns (uint8) {
676         return _decimals;
677     }
678 
679     function totalSupply() public view override returns (uint256) {
680         return _tTotal;
681     }
682 
683     function balanceOf(address account) public view override returns (uint256) {
684         if (_isExcluded[account]) return _tOwned[account];
685         return tokenFromReflection(_rOwned[account]);
686     }
687 
688     function transfer(address recipient, uint256 amount) public override returns (bool) {
689         _transfer(_msgSender(), recipient, amount);
690         return true;
691     }
692 
693     function allowance(address owner, address spender) public view override returns (uint256) {
694         return _allowances[owner][spender];
695     }
696 
697     function approve(address spender, uint256 amount) public override returns (bool) {
698         _approve(_msgSender(), spender, amount);
699         return true;
700     }
701 
702     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
703         _transfer(sender, recipient, amount);
704         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
705         return true;
706     }
707 
708     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
709         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
710         return true;
711     }
712 
713     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
714         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
715         return true;
716     }
717 
718     function isExcludedFromReward(address account) public view returns (bool) {
719         return _isExcluded[account];
720     }
721 
722     function totalFees() public view returns (uint256) {
723         return _tFeeTotal;
724     }
725 
726   
727     function deliver(uint256 tAmount) public {
728         address sender = _msgSender();
729         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
730         (uint256 rAmount,,,,,) = _getValues(tAmount);
731         _rOwned[sender] = _rOwned[sender].sub(rAmount);
732         _rTotal = _rTotal.sub(rAmount);
733         _tFeeTotal = _tFeeTotal.add(tAmount);
734     }
735 
736 
737     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
738         require(tAmount <= _tTotal, "Amount must be less than supply");
739         if (!deductTransferFee) {
740             (uint256 rAmount,,,,,) = _getValues(tAmount);
741             return rAmount;
742         } else {
743             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
744             return rTransferAmount;
745         }
746     }
747 
748     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
749         require(rAmount <= _rTotal, "Amount must be less than total reflections");
750         uint256 currentRate =  _getRate();
751         return rAmount.div(currentRate);
752     }
753 
754     function isRemovedSniper(address account) public view returns (bool) {
755         return _isSniper[account];
756     }
757 
758     function _approve(address owner, address spender, uint256 amount) private {
759         require(owner != address(0), "ERC20: approve from the zero address");
760         require(spender != address(0), "ERC20: approve to the zero address");
761 
762         _allowances[owner][spender] = amount;
763         emit Approval(owner, spender, amount);
764     }
765 
766     function _transfer(
767         address sender,
768         address recipient,
769         uint256 amount
770     ) private {
771         require(sender != address(0), "ERC20: transfer from the zero address");
772         require(recipient != address(0), "ERC20: transfer to the zero address");
773         require(amount > 0, "Transfer amount must be greater than zero");
774         require(!_isSniper[recipient], "You have no power here!");
775         require(!_isSniper[msg.sender], "You have no power here!");
776 
777 
778         if(sender != owner() && recipient != owner()) {
779             
780             if (!tradingOpen) {
781                 if (!(sender == address(this) || recipient == address(this)
782                 || sender == address(owner()) || recipient == address(owner()))) {
783                     require(tradingOpen, "Trading is not enabled");
784                 }
785             }
786 
787             if(_cooldownEnabled) {
788                 if(!cooldown[msg.sender].exists) {
789                     cooldown[msg.sender] = User(0,0,true);
790                 }
791             }
792         }
793         
794         //buy
795         
796         if(sender == uniswapV2Pair && recipient != address(uniswapV2Router) && !_isExcludedFromFee[recipient]) {
797                 require(tradingOpen, "Trading not yet enabled.");
798                 
799                 _liquidityFee=_baseLiqFee;
800                 
801                 if(_cooldownEnabled) {
802                     if(buyLimitEnd > block.timestamp) {
803                         require(amount <= _maxBuyAmount);
804                         require(cooldown[recipient].buy < block.timestamp, "Your buy cooldown has not expired.");
805                         cooldown[recipient].buy = block.timestamp + (45 seconds);
806                     }
807                 }
808                 if(_cooldownEnabled) {
809                     cooldown[recipient].sell = block.timestamp + (45 seconds);
810                 }
811         }
812 
813         //sell
814         if (!inSwapAndLiquify && swapAndLiquifyEnabled && recipient == uniswapV2Pair) {
815             
816             //get dynamic fee
817             if(_useImpactFeeSetter) {
818                     uint256 feeBasis = amount.mul(_feeMultiplier);
819                     feeBasis = feeBasis.div(balanceOf(uniswapV2Pair).add(amount));
820                     setFee(feeBasis);
821             }
822             
823             uint256 dynamicFee = _liquidityFee;
824             
825             //swap contract's tokens for ETH
826             uint256 contractTokenBalance = balanceOf(address(this));
827              if(contractTokenBalance > 0) {
828                 swapTokens(contractTokenBalance);
829             }
830             
831             //buyback
832             uint256 balance = address(this).balance;
833             
834             //buyback only if sell amount >= _minTrigger
835             if (buyBackEnabled && amount >= _minTrigger) {
836                 
837                 uint256 ten = 10;
838                 
839                 uint256 buyBackAmount = _baseAmount.mul(ten.add(((dynamicFee.sub(_baseLiqFee)).mul(k)).div(_baseLiqFee))).div(10);                                                
840 
841                 if (balance >= buyBackAmount)   buyBackTokens(buyBackAmount);
842             }
843             
844             //restore dynamicFee after buyback
845             _liquidityFee = dynamicFee;
846         }
847 
848         bool takeFee = true;
849 
850         //if any account belongs to _isExcludedFromFee account then remove the fee
851         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
852             takeFee = false;
853         }
854 
855         //execute transfer
856         _tokenTransfer(sender, recipient,amount,takeFee);
857     }
858 
859     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
860 
861         uint256 initialBalance = address(this).balance;
862         swapTokensForEth(contractTokenBalance);
863         uint256 transferredBalance = address(this).balance.sub(initialBalance);
864  
865         transferToAddressETH(operationsAddress, transferredBalance.div(2));
866 
867     }
868 
869 
870     function buyBackTokens(uint256 amount) private lockTheSwap {
871         if (amount > 0) {
872             swapETHForTokens(amount);
873         }
874     }
875     
876     function setFee(uint256 impactFee) private {
877         uint256 _impactFee = _baseLiqFee;
878         if(impactFee < _baseLiqFee) {
879             _impactFee = _baseLiqFee;
880             // Fee can never be higher than 40%
881         } else if(impactFee > 40) {
882             _impactFee = 40;
883         } else {
884             _impactFee = impactFee;
885         }
886         if(_impactFee.mod(2) != 0) {
887             _impactFee++;
888         }
889         
890         _liquidityFee = _impactFee;
891     }
892 
893     function swapTokensForEth(uint256 tokenAmount) private {
894         // generate the uniswap pair path of token -> weth
895         address[] memory path = new address[](2);
896         path[0] = address(this);
897         path[1] = uniswapV2Router.WETH();
898 
899         _approve(address(this), address(uniswapV2Router), tokenAmount);
900 
901         // make the swap
902         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
903             tokenAmount,
904             0, // accept any amount of ETH
905             path,
906             address(this), // The contract
907             block.timestamp
908         );
909 
910         emit SwapTokensForETH(tokenAmount, path);
911     }
912 
913     function swapETHForTokens(uint256 amount) private {
914         // generate the uniswap pair path of token -> weth
915         address[] memory path = new address[](2);
916         path[0] = uniswapV2Router.WETH();
917         path[1] = address(this);
918 
919         // make the swap
920         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
921             0, // accept any amount of Tokens
922             path,
923             deadAddress, // Burn address
924             block.timestamp.add(300)
925         );
926 
927         emit SwapETHForTokens(amount, path);
928     }
929 
930     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
931         // approve token transfer to cover all possible scenarios
932         _approve(address(this), address(uniswapV2Router), tokenAmount);
933 
934         // add the liquidity
935         uniswapV2Router.addLiquidityETH{value: ethAmount}(
936             address(this),
937             tokenAmount,
938             0, // slippage is unavoidable
939             0, // slippage is unavoidable
940             owner(),
941             block.timestamp
942         );
943     }
944 
945     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
946         if(!takeFee)
947             removeAllFee();
948 
949         if (_isExcluded[sender] && !_isExcluded[recipient]) {
950             _transferFromExcluded(sender, recipient, amount);
951         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
952             _transferToExcluded(sender, recipient, amount);
953         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
954             _transferBothExcluded(sender, recipient, amount);
955         } else {
956             _transferStandard(sender, recipient, amount);
957         }
958 
959         if(!takeFee)
960             restoreAllFee();
961     }
962 
963     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
964         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
965         _rOwned[sender] = _rOwned[sender].sub(rAmount);
966         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
967         _takeLiquidity(tLiquidity);
968         _reflectFee(rFee, tFee);
969         emit Transfer(sender, recipient, tTransferAmount);
970     }
971 
972     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
973         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
974         _rOwned[sender] = _rOwned[sender].sub(rAmount);
975         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
976         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
977         _takeLiquidity(tLiquidity);
978         _reflectFee(rFee, tFee);
979         emit Transfer(sender, recipient, tTransferAmount);
980     }
981 
982     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
983         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
984         _tOwned[sender] = _tOwned[sender].sub(tAmount);
985         _rOwned[sender] = _rOwned[sender].sub(rAmount);
986         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
987         _takeLiquidity(tLiquidity);
988         _reflectFee(rFee, tFee);
989         emit Transfer(sender, recipient, tTransferAmount);
990     }
991 
992     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
993         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
994         _tOwned[sender] = _tOwned[sender].sub(tAmount);
995         _rOwned[sender] = _rOwned[sender].sub(rAmount);
996         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
997         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
998         _takeLiquidity(tLiquidity);
999         _reflectFee(rFee, tFee);
1000         emit Transfer(sender, recipient, tTransferAmount);
1001     }
1002 
1003     function _reflectFee(uint256 rFee, uint256 tFee) private {
1004         _rTotal = _rTotal.sub(rFee);
1005         _tFeeTotal = _tFeeTotal.add(tFee);
1006     }
1007 
1008     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1009         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1010         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1011         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1012     }
1013 
1014     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1015         uint256 tFee = calculateTaxFee(tAmount);
1016         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1017         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1018         return (tTransferAmount, tFee, tLiquidity);
1019     }
1020 
1021     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1022         uint256 rAmount = tAmount.mul(currentRate);
1023         uint256 rFee = tFee.mul(currentRate);
1024         uint256 rLiquidity = tLiquidity.mul(currentRate);
1025         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1026         return (rAmount, rTransferAmount, rFee);
1027     }
1028 
1029     function _getRate() private view returns(uint256) {
1030         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1031         return rSupply.div(tSupply);
1032     }
1033 
1034     function _getCurrentSupply() private view returns(uint256, uint256) {
1035         uint256 rSupply = _rTotal;
1036         uint256 tSupply = _tTotal;
1037         for (uint256 i = 0; i < _excluded.length; i++) {
1038             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1039             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1040             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1041         }
1042         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1043         return (rSupply, tSupply);
1044     }
1045 
1046     function _takeLiquidity(uint256 tLiquidity) private {
1047         uint256 currentRate =  _getRate();
1048         uint256 rLiquidity = tLiquidity.mul(currentRate);
1049         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1050         if(_isExcluded[address(this)])
1051             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1052     }
1053 
1054     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1055         return _amount.mul(_taxFee).div(
1056             10**2
1057         );
1058     }
1059 
1060     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1061         return _amount.mul(_liquidityFee).div(
1062             10**2
1063         );
1064     }
1065 
1066     function removeAllFee() private {
1067         if(_taxFee == 0 && _liquidityFee == 0) return;
1068 
1069         _previousTaxFee = _taxFee;
1070         _previousLiquidityFee = _liquidityFee;
1071 
1072         _taxFee = 0;
1073         _liquidityFee = 0;
1074     }
1075 
1076     function restoreAllFee() private {
1077         _taxFee = _previousTaxFee;
1078         _liquidityFee = _previousLiquidityFee;
1079     }
1080 
1081     function isExcludedFromFee(address account) public view returns(bool) {
1082         return _isExcludedFromFee[account];
1083     }
1084 
1085 
1086     function setOperationsAddress(address _operationsAddress) external onlyOwner() {
1087         operationsAddress = payable(_operationsAddress);
1088     }
1089 
1090     
1091 
1092     function setBuyBackEnabled(bool _enabled) public onlyOwner {
1093         buyBackEnabled = _enabled;
1094         emit BuyBackEnabledUpdated(_enabled);
1095     }
1096 
1097     function transferToAddressETH(address payable recipient, uint256 amount) private {
1098         recipient.transfer(amount);
1099     }
1100 
1101     
1102     function setMinTrigger(uint256 newTrigger) external onlyOwner() {
1103         _minTrigger= newTrigger;
1104     }
1105     
1106     function setK (uint256 newK) external onlyOwner() {
1107         k = newK;
1108     }
1109 
1110     function setBaseAmount(uint256 baseAmount) external onlyOwner() {
1111             _baseAmount=baseAmount;
1112     }
1113     
1114     
1115      function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1116         require((_baseLiqFee+taxFee)<=20); 
1117         _taxFee = taxFee;
1118         _previousTaxFee=taxFee;
1119     }
1120     
1121     function setBaseLiqFeePercent(uint256 baseLiqFee) external onlyOwner() {
1122         require((baseLiqFee+_taxFee)<=20); 
1123         _baseLiqFee = baseLiqFee;
1124     }
1125 
1126     //to recieve ETH from uniswapV2Router when swapping
1127     receive() external payable {}
1128 }