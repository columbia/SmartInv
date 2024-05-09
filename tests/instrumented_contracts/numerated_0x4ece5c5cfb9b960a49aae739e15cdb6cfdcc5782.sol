1 pragma solidity 0.7.6;
2 
3 // SPDX-License-Identifier: MIT
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two numbers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b > 0); // Solidity only automatically asserts when dividing by 0
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two numbers, reverts on overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 /**
69  * @title Initializable
70  *
71  * @dev Helper contract to support initializer functions. To use it, replace
72  * the constructor with a function that has the `initializer` modifier.
73  * WARNING: Unlike constructors, initializer functions must be manually
74  * invoked. This applies both to deploying an Initializable contract, as well
75  * as extending an Initializable contract via inheritance.
76  * WARNING: When used with inheritance, manual care must be taken to not invoke
77  * a parent initializer twice, or ensure that all initializers are idempotent,
78  * because this is not dealt with automatically as with constructors.
79  */
80 contract Initializable {
81     /**
82      * @dev Indicates that the contract has been initialized.
83      */
84     bool private initialized;
85 
86     /**
87      * @dev Indicates that the contract is in the process of being initialized.
88      */
89     bool private initializing;
90 
91     /**
92      * @dev Modifier to use in the initializer function of a contract.
93      */
94     modifier initializer() {
95         require(
96             initializing || isConstructor() || !initialized,
97             "Contract instance has already been initialized"
98         );
99 
100         bool wasInitializing = initializing;
101         initializing = true;
102         initialized = true;
103 
104         _;
105 
106         initializing = wasInitializing;
107     }
108 
109     /// @dev Returns true if and only if the function is running in the constructor
110     function isConstructor() private view returns (bool) {
111         // extcodesize checks the size of the code stored in an address, and
112         // address returns the current address. Since the code is still not
113         // deployed when running a constructor, any checks on its code size will
114         // yield zero, making it an effective way to detect if a contract is
115         // under construction or not.
116 
117         // MINOR CHANGE HERE:
118 
119         // previous code
120         // uint256 cs;
121         // assembly { cs := extcodesize(address) }
122         // return cs == 0;
123 
124         // current code
125         address _self = address(this);
126         uint256 cs;
127         assembly {
128             cs := extcodesize(_self)
129         }
130         return cs == 0;
131     }
132 
133     // Reserved storage space to allow for layout changes in the future.
134     uint256[50] private ______gap;
135 }
136 
137 /**
138  * @title Ownable
139  * @dev The Ownable contract has an owner address, and provides basic authorization control
140  * functions, this simplifies the implementation of "user permissions".
141  */
142 contract Ownable is Initializable {
143     address private _owner;
144 
145     event OwnershipRenounced(address indexed previousOwner);
146     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
147 
148     /**
149      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
150      * account.
151      */
152     function initialize(address sender) public virtual initializer {
153         _owner = sender;
154     }
155 
156     /**
157      * @return the address of the owner.
158      */
159     function owner() public view returns (address) {
160         return _owner;
161     }
162 
163     /**
164      * @dev Throws if called by any account other than the owner.
165      */
166     modifier onlyOwner() {
167         require(isOwner());
168         _;
169     }
170 
171     /**
172      * @return true if `msg.sender` is the owner of the contract.
173      */
174     function isOwner() public view returns (bool) {
175         return msg.sender == _owner;
176     }
177 
178     /**
179      * @dev Allows the current owner to relinquish control of the contract.
180      * @notice Renouncing to ownership will leave the contract without an owner.
181      * It will not be possible to call the functions with the `onlyOwner`
182      * modifier anymore.
183      */
184     function renounceOwnership() public onlyOwner {
185         emit OwnershipRenounced(_owner);
186         _owner = address(0);
187     }
188 
189     /**
190      * @dev Allows the current owner to transfer control of the contract to a newOwner.
191      * @param newOwner The address to transfer ownership to.
192      */
193     function transferOwnership(address newOwner) public onlyOwner {
194         _transferOwnership(newOwner);
195     }
196 
197     /**
198      * @dev Transfers control of the contract to a newOwner.
199      * @param newOwner The address to transfer ownership to.
200      */
201     function _transferOwnership(address newOwner) internal {
202         require(newOwner != address(0));
203         emit OwnershipTransferred(_owner, newOwner);
204         _owner = newOwner;
205     }
206 
207     uint256[50] private ______gap;
208 }
209 
210 /**
211  * @title ERC20 interface
212  * @dev see https://github.com/ethereum/EIPs/issues/20
213  */
214 interface IERC20 {
215     function totalSupply() external view returns (uint256);
216 
217     function balanceOf(address who) external view returns (uint256);
218 
219     function allowance(address owner, address spender) external view returns (uint256);
220 
221     function transfer(address to, uint256 value) external returns (bool);
222 
223     function approve(address spender, uint256 value) external returns (bool);
224 
225     function transferFrom(
226         address from,
227         address to,
228         uint256 value
229     ) external returns (bool);
230 
231     event Transfer(address indexed from, address indexed to, uint256 value);
232 
233     event Approval(address indexed owner, address indexed spender, uint256 value);
234 }
235 
236 /**
237  * @title ERC20Detailed token
238  * @dev The decimals are only for visualization purposes.
239  * All the operations are done using the smallest and indivisible token unit,
240  * just as on Ethereum all the operations are done in wei.
241  */
242 abstract contract ERC20Detailed is Initializable, IERC20 {
243     string private _name;
244     string private _symbol;
245     uint8 private _decimals;
246 
247     function initialize(
248         string memory name,
249         string memory symbol,
250         uint8 decimals
251     ) public virtual initializer {
252         _name = name;
253         _symbol = symbol;
254         _decimals = decimals;
255     }
256 
257     /**
258      * @return the name of the token.
259      */
260     function name() public view returns (string memory) {
261         return _name;
262     }
263 
264     /**
265      * @return the symbol of the token.
266      */
267     function symbol() public view returns (string memory) {
268         return _symbol;
269     }
270 
271     /**
272      * @return the number of decimals of the token.
273      */
274     function decimals() public view returns (uint8) {
275         return _decimals;
276     }
277 
278     uint256[50] private ______gap;
279 }
280 
281 /*
282 MIT License
283 
284 Copyright (c) 2018 requestnetwork
285 Copyright (c) 2018 Fragments, Inc.
286 
287 Permission is hereby granted, free of charge, to any person obtaining a copy
288 of this software and associated documentation files (the "Software"), to deal
289 in the Software without restriction, including without limitation the rights
290 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
291 copies of the Software, and to permit persons to whom the Software is
292 furnished to do so, subject to the following conditions:
293 
294 The above copyright notice and this permission notice shall be included in all
295 copies or substantial portions of the Software.
296 
297 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
298 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
299 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
300 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
301 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
302 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
303 SOFTWARE.
304 */
305 /**
306  * @title SafeMathInt
307  * @dev Math operations for int256 with overflow safety checks.
308  */
309 library SafeMathInt {
310     int256 private constant MIN_INT256 = int256(1) << 255;
311     int256 private constant MAX_INT256 = ~(int256(1) << 255);
312 
313     /**
314      * @dev Multiplies two int256 variables and fails on overflow.
315      */
316     function mul(int256 a, int256 b) internal pure returns (int256) {
317         int256 c = a * b;
318 
319         // Detect overflow when multiplying MIN_INT256 with -1
320         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
321         require((b == 0) || (c / b == a));
322         return c;
323     }
324 
325     /**
326      * @dev Division of two int256 variables and fails on overflow.
327      */
328     function div(int256 a, int256 b) internal pure returns (int256) {
329         // Prevent overflow when dividing MIN_INT256 by -1
330         require(b != -1 || a != MIN_INT256);
331 
332         // Solidity already throws when dividing by 0.
333         return a / b;
334     }
335 
336     /**
337      * @dev Subtracts two int256 variables and fails on overflow.
338      */
339     function sub(int256 a, int256 b) internal pure returns (int256) {
340         int256 c = a - b;
341         require((b >= 0 && c <= a) || (b < 0 && c > a));
342         return c;
343     }
344 
345     /**
346      * @dev Adds two int256 variables and fails on overflow.
347      */
348     function add(int256 a, int256 b) internal pure returns (int256) {
349         int256 c = a + b;
350         require((b >= 0 && c >= a) || (b < 0 && c < a));
351         return c;
352     }
353 
354     /**
355      * @dev Converts to absolute value, and fails on overflow.
356      */
357     function abs(int256 a) internal pure returns (int256) {
358         require(a != MIN_INT256);
359         return a < 0 ? -a : a;
360     }
361 }
362 
363 interface IUniswapV2Factory {
364     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
365 
366     function feeTo() external view returns (address);
367     function feeToSetter() external view returns (address);
368 
369     function getPair(address tokenA, address tokenB) external view returns (address pair);
370     function allPairs(uint) external view returns (address pair);
371     function allPairsLength() external view returns (uint);
372 
373     function createPair(address tokenA, address tokenB) external returns (address pair);
374 
375     function setFeeTo(address) external;
376     function setFeeToSetter(address) external;
377 }
378 
379 interface IUniswapV2Pair {
380     event Approval(address indexed owner, address indexed spender, uint value);
381     event Transfer(address indexed from, address indexed to, uint value);
382 
383     function name() external pure returns (string memory);
384     function symbol() external pure returns (string memory);
385     function decimals() external pure returns (uint8);
386     function totalSupply() external view returns (uint);
387     function balanceOf(address owner) external view returns (uint);
388     function allowance(address owner, address spender) external view returns (uint);
389 
390     function approve(address spender, uint value) external returns (bool);
391     function transfer(address to, uint value) external returns (bool);
392     function transferFrom(address from, address to, uint value) external returns (bool);
393 
394     function DOMAIN_SEPARATOR() external view returns (bytes32);
395     function PERMIT_TYPEHASH() external pure returns (bytes32);
396     function nonces(address owner) external view returns (uint);
397 
398     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
399 
400     event Mint(address indexed sender, uint amount0, uint amount1);
401     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
402     event Swap(
403         address indexed sender,
404         uint amount0In,
405         uint amount1In,
406         uint amount0Out,
407         uint amount1Out,
408         address indexed to
409     );
410     event Sync(uint112 reserve0, uint112 reserve1);
411 
412     function MINIMUM_LIQUIDITY() external pure returns (uint);
413     function factory() external view returns (address);
414     function token0() external view returns (address);
415     function token1() external view returns (address);
416     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
417     function price0CumulativeLast() external view returns (uint);
418     function price1CumulativeLast() external view returns (uint);
419     function kLast() external view returns (uint);
420 
421     function mint(address to) external returns (uint liquidity);
422     function burn(address to) external returns (uint amount0, uint amount1);
423     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
424     function skim(address to) external;
425     function sync() external;
426 
427     function initialize(address, address) external;
428 }
429 
430 interface IUniswapV2Router01 {
431     function factory() external pure returns (address);
432     function WETH() external pure returns (address);
433 
434     function addLiquidity(
435         address tokenA,
436         address tokenB,
437         uint amountADesired,
438         uint amountBDesired,
439         uint amountAMin,
440         uint amountBMin,
441         address to,
442         uint deadline
443     ) external returns (uint amountA, uint amountB, uint liquidity);
444     function addLiquidityETH(
445         address token,
446         uint amountTokenDesired,
447         uint amountTokenMin,
448         uint amountETHMin,
449         address to,
450         uint deadline
451     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
452     function removeLiquidity(
453         address tokenA,
454         address tokenB,
455         uint liquidity,
456         uint amountAMin,
457         uint amountBMin,
458         address to,
459         uint deadline
460     ) external returns (uint amountA, uint amountB);
461     function removeLiquidityETH(
462         address token,
463         uint liquidity,
464         uint amountTokenMin,
465         uint amountETHMin,
466         address to,
467         uint deadline
468     ) external returns (uint amountToken, uint amountETH);
469     function removeLiquidityWithPermit(
470         address tokenA,
471         address tokenB,
472         uint liquidity,
473         uint amountAMin,
474         uint amountBMin,
475         address to,
476         uint deadline,
477         bool approveMax, uint8 v, bytes32 r, bytes32 s
478     ) external returns (uint amountA, uint amountB);
479     function removeLiquidityETHWithPermit(
480         address token,
481         uint liquidity,
482         uint amountTokenMin,
483         uint amountETHMin,
484         address to,
485         uint deadline,
486         bool approveMax, uint8 v, bytes32 r, bytes32 s
487     ) external returns (uint amountToken, uint amountETH);
488     function swapExactTokensForTokens(
489         uint amountIn,
490         uint amountOutMin,
491         address[] calldata path,
492         address to,
493         uint deadline
494     ) external returns (uint[] memory amounts);
495     function swapTokensForExactTokens(
496         uint amountOut,
497         uint amountInMax,
498         address[] calldata path,
499         address to,
500         uint deadline
501     ) external returns (uint[] memory amounts);
502     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
503         external
504         payable
505         returns (uint[] memory amounts);
506     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
507         external
508         returns (uint[] memory amounts);
509     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
510         external
511         returns (uint[] memory amounts);
512     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
513         external
514         payable
515         returns (uint[] memory amounts);
516 
517     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
518     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
519     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
520     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
521     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
522 }
523 
524 interface IUniswapV2Router02 is IUniswapV2Router01 {
525     function removeLiquidityETHSupportingFeeOnTransferTokens(
526         address token,
527         uint liquidity,
528         uint amountTokenMin,
529         uint amountETHMin,
530         address to,
531         uint deadline
532     ) external returns (uint amountETH);
533     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
534         address token,
535         uint liquidity,
536         uint amountTokenMin,
537         uint amountETHMin,
538         address to,
539         uint deadline,
540         bool approveMax, uint8 v, bytes32 r, bytes32 s
541     ) external returns (uint amountETH);
542 
543     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
544         uint amountIn,
545         uint amountOutMin,
546         address[] calldata path,
547         address to,
548         uint deadline
549     ) external;
550     function swapExactETHForTokensSupportingFeeOnTransferTokens(
551         uint amountOutMin,
552         address[] calldata path,
553         address to,
554         uint deadline
555     ) external payable;
556     function swapExactTokensForETHSupportingFeeOnTransferTokens(
557         uint amountIn,
558         uint amountOutMin,
559         address[] calldata path,
560         address to,
561         uint deadline
562     ) external;
563 }
564 
565 contract UFragments is ERC20Detailed, Ownable {
566     // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
567     // Anytime there is division, there is a risk of numerical instability from rounding errors. In
568     // order to minimize this risk, we adhere to the following guidelines:
569     // 1) The conversion rate adopted is the number of gons that equals 1 fragment.
570     //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
571     //    always the denominator. (i.e. If you want to convert gons to fragments instead of
572     //    multiplying by the inverse rate, you should divide by the normal rate)
573     // 2) Gon balances converted into Fragments are always rounded down (truncated).
574     //
575     // We make the following guarantees:
576     // - If address 'A' transfers x Fragments to address 'B'. A's resulting external balance will
577     //   be decreased by precisely x Fragments, and B's external balance will be precisely
578     //   increased by x Fragments.
579     //
580     // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
581     // This is because, for any conversion function 'f()' that has non-zero rounding error,
582     // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
583     using SafeMath for uint256;
584     using SafeMathInt for int256;
585 
586     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
587     event LogMonetaryPolicyUpdated(address monetaryPolicy);
588 
589     // Used for authentication
590     address public monetaryPolicy;
591 
592     modifier onlyMonetaryPolicy() {
593         require(msg.sender == monetaryPolicy);
594         _;
595     }
596 
597     modifier validRecipient(address to) {
598         require(to != address(0x0));
599         _;
600     }
601 
602     uint256 private constant DECIMALS = 9;
603     uint256 private constant MAX_UINT256 = type(uint256).max;
604     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 10**9 * 10**DECIMALS;
605 
606     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
607     // Use the highest value that fits in a uint256 for max granularity.
608     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
609 
610     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
611     uint256 private constant MAX_SUPPLY = type(uint128).max; // (2^128) - 1
612 
613     uint256 private _totalSupply;
614     uint256 private _gonsPerFragment;
615     mapping(address => uint256) private _gonBalances;
616 
617     // This is denominated in Fragments, because the gons-fragments conversion might change before
618     // it's fully paid.
619     mapping(address => mapping(address => uint256)) private _allowedFragments;
620 
621     // EIP-2612: permit – 712-signed approvals
622     // https://eips.ethereum.org/EIPS/eip-2612
623     string public constant EIP712_REVISION = "1";
624     bytes32 public constant EIP712_DOMAIN =
625         keccak256(
626             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
627         );
628     bytes32 public constant PERMIT_TYPEHASH =
629         keccak256(
630             "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
631         );
632 
633     // EIP-2612: keeps track of number of permits per address
634     mapping(address => uint256) private _nonces;
635 
636     bool private inSwap = false;
637     
638     modifier lockSwap {
639         inSwap = true;
640         _;
641         inSwap = false;
642     }
643 
644     IUniswapV2Router02 public uniswapV2Router;
645     address public uniswapV2Pair;
646     address payable public devAddress;
647 
648     // Tax for early investors
649     uint256 private _maxTxGon = 10**6 * 10**DECIMALS;
650     uint256 private _taxFee = 10;
651     uint256 private _taxEndTimestamp = 1631205752;
652 
653     mapping (address => bool) private _isIncludedInTax;
654 
655     /**
656      * @param monetaryPolicy_ The address of the monetary policy contract to use for authentication.
657      */
658     function setMonetaryPolicy(address monetaryPolicy_) external onlyOwner {
659         monetaryPolicy = monetaryPolicy_;
660         emit LogMonetaryPolicyUpdated(monetaryPolicy_);
661     }
662 
663     /**
664      * @param account_ The address to be included
665      */
666     function includeAccount(address account_) external onlyOwner() {
667         require(!_isIncludedInTax[account_], "Already Included");
668         _isIncludedInTax[account_] = true;
669     }
670 
671     /**
672      * @param account_ The address to be excluded
673      */
674     function excludeAccount(address account_) external onlyOwner() {
675         require(_isIncludedInTax[account_], "Already Excluded");
676         _isIncludedInTax[account_] = false;
677     }
678 
679     /**
680      */
681     function setMaxTxGon(uint256 maxTxGon_) external onlyOwner() {
682         _maxTxGon = maxTxGon_;
683     }
684 
685     /**
686      * @dev Notifies Fragments contract about a new rebase cycle.
687      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
688      * @return The total number of fragments after the supply adjustment.
689      */
690     function rebase(uint256 epoch, int256 supplyDelta)
691         external
692         onlyMonetaryPolicy
693         returns (uint256)
694     {
695         if (supplyDelta == 0) {
696             emit LogRebase(epoch, _totalSupply);
697             return _totalSupply;
698         }
699 
700         if (supplyDelta < 0) {
701             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
702         } else {
703             _totalSupply = _totalSupply.add(uint256(supplyDelta));
704         }
705 
706         if (_totalSupply > MAX_SUPPLY) {
707             _totalSupply = MAX_SUPPLY;
708         }
709 
710         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
711 
712         // From this point forward, _gonsPerFragment is taken as the source of truth.
713         // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
714         // conversion rate.
715         // This means our applied supplyDelta can deviate from the requested supplyDelta,
716         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
717         //
718         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
719         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
720         // ever increased, it must be re-included.
721         // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
722 
723         emit LogRebase(epoch, _totalSupply);
724         return _totalSupply;
725     }
726 
727     function initialize(address owner_) public override initializer {
728         ERC20Detailed.initialize("Doont Buy", "DBUY", uint8(DECIMALS));
729         Ownable.initialize(owner_);
730 
731         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
732         _gonBalances[owner_] = TOTAL_GONS;
733         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
734 
735         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
736         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
737             .createPair(address(this), _uniswapV2Router.WETH());
738 
739         uniswapV2Router = _uniswapV2Router;
740 
741         devAddress = payable(owner_);
742 
743         emit Transfer(address(0x0), owner_, _totalSupply);
744     }
745 
746     /**
747      * @return The total number of fragments.
748      */
749     function totalSupply() external view override returns (uint256) {
750         return _totalSupply;
751     }
752 
753     /**
754      * @param who The address to query.
755      * @return The balance of the specified address.
756      */
757     function balanceOf(address who) external view override returns (uint256) {
758         return _gonBalances[who].div(_gonsPerFragment);
759     }
760 
761     /**
762      * @param who The address to query.
763      * @return The gon balance of the specified address.
764      */
765     function scaledBalanceOf(address who) external view returns (uint256) {
766         return _gonBalances[who];
767     }
768 
769     /**
770      * @return the total number of gons.
771      */
772     function scaledTotalSupply() external pure returns (uint256) {
773         return TOTAL_GONS;
774     }
775 
776     /**
777      * @return The number of successful permits by the specified address.
778      */
779     function nonces(address who) public view returns (uint256) {
780         return _nonces[who];
781     }
782 
783     /**
784      * @return The computed DOMAIN_SEPARATOR to be used off-chain services
785      *         which implement EIP-712.
786      *         https://eips.ethereum.org/EIPS/eip-2612
787      */
788     function DOMAIN_SEPARATOR() public view returns (bytes32) {
789         uint256 chainId;
790         assembly {
791             chainId := chainid()
792         }
793         return
794             keccak256(
795                 abi.encode(
796                     EIP712_DOMAIN,
797                     keccak256(bytes(name())),
798                     keccak256(bytes(EIP712_REVISION)),
799                     chainId,
800                     address(this)
801                 )
802             );
803     }
804 
805     /**
806      * @dev Transfer tokens from one address to another.
807      * @param from The address you want to send tokens from.
808      * @param to The address you want to transfer to.
809      * @param value The amount of tokens to be transferred.
810      */
811     function _transfer(address from, address to, uint256 value) private {
812         require(from != address(0x0), "Transfer from the zero address");
813         uint256 gonValue = value.mul(_gonsPerFragment);
814 
815         if (from != owner() && to != owner()) {
816             require(value <= _maxTxGon, "Exceeds the max gon");
817         }
818 
819         uint256 gonToSwap = _gonBalances[address(this)].div(_gonsPerFragment);
820         if (gonToSwap >= _maxTxGon) gonToSwap = _maxTxGon;
821         if (!inSwap && to == uniswapV2Pair && gonToSwap > 0) {
822             swapGons(gonToSwap);
823         }
824 
825         if ((_isIncludedInTax[from] || _isIncludedInTax[to]) && block.timestamp <= _taxEndTimestamp && from != address(this)) {
826             uint256 taxGonValue = gonValue.div(100).mul(_taxFee);
827             _gonBalances[from] = _gonBalances[from].sub(gonValue);
828             _gonBalances[to] = _gonBalances[to].add(gonValue.sub(taxGonValue));
829             _gonBalances[address(this)] = _gonBalances[address(this)].add(taxGonValue);
830 
831             emit Transfer(from, to, gonValue.sub(taxGonValue).div(_gonsPerFragment));
832         }
833         else {
834             _gonBalances[from] = _gonBalances[from].sub(gonValue);
835             _gonBalances[to] = _gonBalances[to].add(gonValue);
836 
837             emit Transfer(from, to, value);
838         }
839     }
840 
841     /**
842      * @dev Transfer tokens to a specified address.
843      * @param to The address to transfer to.
844      * @param value The amount to be transferred.
845      * @return True on success, false otherwise.
846      */
847     function transfer(address to, uint256 value)
848         external
849         override
850         validRecipient(to)
851         returns (bool)
852     {
853         _transfer(msg.sender, to, value);
854         return true;
855     }
856 
857     /**
858      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
859      * @param owner_ The address which owns the funds.
860      * @param spender The address which will spend the funds.
861      * @return The number of tokens still available for the spender.
862      */
863     function allowance(address owner_, address spender) external view override returns (uint256) {
864         return _allowedFragments[owner_][spender];
865     }
866 
867     /**
868      * @dev Transfer tokens from one address to another.
869      * @param from The address you want to send tokens from.
870      * @param to The address you want to transfer to.
871      * @param value The amount of tokens to be transferred.
872      */
873     function transferFrom(
874         address from,
875         address to,
876         uint256 value
877     ) external override validRecipient(to) returns (bool) {
878         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
879 
880         _transfer(from, to, value);
881         return true;
882     }
883 
884     /**
885      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
886      * msg.sender. This method is included for ERC20 compatibility.
887      * increaseAllowance and decreaseAllowance should be used instead.
888      * Changing an allowance with this method brings the risk that someone may transfer both
889      * the old and the new allowance - if they are both greater than zero - if a transfer
890      * transaction is mined before the later approve() call is mined.
891      *
892      * @param spender The address which will spend the funds.
893      * @param value The amount of tokens to be spent.
894      */
895     function approve(address spender, uint256 value) external override returns (bool) {
896         _allowedFragments[msg.sender][spender] = value;
897 
898         emit Approval(msg.sender, spender, value);
899         return true;
900     }
901 
902     /**
903      * @dev Increase the amount of tokens that an owner has allowed to a spender.
904      * This method should be used instead of approve() to avoid the double approval vulnerability
905      * described above.
906      * @param spender The address which will spend the funds.
907      * @param addedValue The amount of tokens to increase the allowance by.
908      */
909     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
910         _allowedFragments[msg.sender][spender] = _allowedFragments[msg.sender][spender].add(
911             addedValue
912         );
913 
914         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
915         return true;
916     }
917 
918     /**
919      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
920      *
921      * @param spender The address which will spend the funds.
922      * @param subtractedValue The amount of tokens to decrease the allowance by.
923      */
924     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
925         uint256 oldValue = _allowedFragments[msg.sender][spender];
926         _allowedFragments[msg.sender][spender] = (subtractedValue >= oldValue)
927             ? 0
928             : oldValue.sub(subtractedValue);
929 
930         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
931         return true;
932     }
933 
934     /**
935      * @dev Allows for approvals to be made via secp256k1 signatures.
936      * @param owner The owner of the funds
937      * @param spender The spender
938      * @param value The amount
939      * @param deadline The deadline timestamp, type(uint256).max for max deadline
940      * @param v Signature param
941      * @param s Signature param
942      * @param r Signature param
943      */
944     function permit(
945         address owner,
946         address spender,
947         uint256 value,
948         uint256 deadline,
949         uint8 v,
950         bytes32 r,
951         bytes32 s
952     ) public {
953         require(block.timestamp <= deadline);
954 
955         uint256 ownerNonce = _nonces[owner];
956         bytes32 permitDataDigest =
957             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, ownerNonce, deadline));
958         bytes32 digest =
959             keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR(), permitDataDigest));
960 
961         require(owner == ecrecover(digest, v, r, s));
962 
963         _nonces[owner] = ownerNonce.add(1);
964 
965         _allowedFragments[owner][spender] = value;
966         emit Approval(owner, spender, value);
967     }
968 
969     receive() external payable {}
970 
971     function swapGons(uint256 value) private lockSwap {
972         address[] memory path = new address[](2);
973         path[0] = address(this);
974         path[1] = uniswapV2Router.WETH();
975         
976         _allowedFragments[address(this)][address(uniswapV2Router)] = value;
977         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
978             value,
979             0,
980             path,
981             address(this),
982             block.timestamp
983         );
984     }
985 
986     function withdrawETH(uint256 amount) external {
987         devAddress.transfer(amount);
988     }
989 }