1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58 }
59 
60 library Address {
61     /**
62      * @dev Returns true if `account` is a contract.
63      *
64      * [IMPORTANT]
65      * ====
66      * It is unsafe to assume that an address for which this function returns
67      * false is an externally-owned account (EOA) and not a contract.
68      *
69      * Among others, `isContract` will return false for the following
70      * types of addresses:
71      *
72      *  - an externally-owned account
73      *  - a contract in construction
74      *  - an address where a contract will be created
75      *  - an address where a contract lived, but was destroyed
76      * ====
77      */
78     function isContract(address account) internal view returns (bool) {
79         // This method relies on extcodesize, which returns 0 for contracts in
80         // construction, since the code is only stored at the end of the
81         // constructor execution.
82 
83         uint256 size;
84         assembly {
85             size := extcodesize(account)
86         }
87         return size > 0;
88     }
89 
90     /**
91      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
92      * `recipient`, forwarding all available gas and reverting on errors.
93      *
94      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
95      * of certain opcodes, possibly making contracts go over the 2300 gas limit
96      * imposed by `transfer`, making them unable to receive funds via
97      * `transfer`. {sendValue} removes this limitation.
98      *
99      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
100      *
101      * IMPORTANT: because control is transferred to `recipient`, care must be
102      * taken to not create reentrancy vulnerabilities. Consider using
103      * {ReentrancyGuard} or the
104      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
105      */
106     function sendValue(address payable recipient, uint256 amount) internal {
107         require(address(this).balance >= amount, "Address: insufficient balance");
108 
109         (bool success, ) = recipient.call{value: amount}("");
110         require(success, "Address: unable to send value, recipient may have reverted");
111     }
112 
113     /**
114      * @dev Performs a Solidity function call using a low level `call`. A
115      * plain `call` is an unsafe replacement for a function call: use this
116      * function instead.
117      *
118      * If `target` reverts with a revert reason, it is bubbled up by this
119      * function (like regular Solidity function calls).
120      *
121      * Returns the raw returned data. To convert to the expected return value,
122      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
123      *
124      * Requirements:
125      *
126      * - `target` must be a contract.
127      * - calling `target` with `data` must not revert.
128      *
129      * _Available since v3.1._
130      */
131     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
132         return functionCall(target, data, "Address: low-level call failed");
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
137      * `errorMessage` as a fallback revert reason when `target` reverts.
138      *
139      * _Available since v3.1._
140      */
141     function functionCall(
142         address target,
143         bytes memory data,
144         string memory errorMessage
145     ) internal returns (bytes memory) {
146         return functionCallWithValue(target, data, 0, errorMessage);
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
151      * but also transferring `value` wei to `target`.
152      *
153      * Requirements:
154      *
155      * - the calling contract must have an ETH balance of at least `value`.
156      * - the called Solidity function must be `payable`.
157      *
158      * _Available since v3.1._
159      */
160     function functionCallWithValue(
161         address target,
162         bytes memory data,
163         uint256 value
164     ) internal returns (bytes memory) {
165         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
170      * with `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCallWithValue(
175         address target,
176         bytes memory data,
177         uint256 value,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         require(address(this).balance >= value, "Address: insufficient balance for call");
181         require(isContract(target), "Address: call to non-contract");
182 
183         (bool success, bytes memory returndata) = target.call{value: value}(data);
184         return _verifyCallResult(success, returndata, errorMessage);
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
189      * but performing a static call.
190      *
191      * _Available since v3.3._
192      */
193     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
194         return functionStaticCall(target, data, "Address: low-level static call failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
199      * but performing a static call.
200      *
201      * _Available since v3.3._
202      */
203     function functionStaticCall(
204         address target,
205         bytes memory data,
206         string memory errorMessage
207     ) internal view returns (bytes memory) {
208         require(isContract(target), "Address: static call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.staticcall(data);
211         return _verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but performing a delegate call.
217      *
218      * _Available since v3.4._
219      */
220     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
221         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
226      * but performing a delegate call.
227      *
228      * _Available since v3.4._
229      */
230     function functionDelegateCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal returns (bytes memory) {
235         require(isContract(target), "Address: delegate call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.delegatecall(data);
238         return _verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     function _verifyCallResult(
242         bool success,
243         bytes memory returndata,
244         string memory errorMessage
245     ) private pure returns (bytes memory) {
246         if (success) {
247             return returndata;
248         } else {
249             // Look for revert reason and bubble it up if present
250             if (returndata.length > 0) {
251                 // The easiest way to bubble the revert reason is using memory via assembly
252 
253                 assembly {
254                     let returndata_size := mload(returndata)
255                     revert(add(32, returndata), returndata_size)
256                 }
257             } else {
258                 revert(errorMessage);
259             }
260         }
261     }
262 }
263 
264 contract Ownable is Context {
265   address private _owner;
266 
267     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
268 
269     /**
270      * @dev Initializes the contract setting the deployer as the initial owner.
271      */
272     constructor() {
273         _setOwner(_msgSender());
274     }
275 
276     /**
277      * @dev Returns the address of the current owner.
278      */
279     function owner() public view virtual returns (address) {
280         return _owner;
281     }
282 
283     /**
284      * @dev Throws if called by any account other than the owner.
285      */
286     modifier onlyOwner() {
287         require(owner() == _msgSender(), "Ownable: caller is not the owner");
288         _;
289     }
290 
291     /**
292      * @dev Leaves the contract without owner. It will not be possible to call
293      * `onlyOwner` functions anymore. Can only be called by the current owner.
294      *
295      * NOTE: Renouncing ownership will leave the contract without an owner,
296      * thereby removing any functionality that is only available to the owner.
297      */
298     function renounceOwnership() public virtual onlyOwner {
299         _setOwner(address(0));
300     }
301 
302     /**
303      * @dev Transfers ownership of the contract to a new account (`newOwner`).
304      * Can only be called by the current owner.
305      */
306     function transferOwnership(address newOwner) public virtual onlyOwner {
307         require(newOwner != address(0), "Ownable: new owner is the zero address");
308         _setOwner(newOwner);
309     }
310 
311     function _setOwner(address newOwner) private {
312         address oldOwner = _owner;
313         _owner = newOwner;
314         emit OwnershipTransferred(oldOwner, newOwner);
315     }
316 }
317 
318 interface IUniswapV2Factory {
319  event PairCreated(address indexed token0, address indexed token1, address pair, uint);
320 
321     function feeTo() external view returns (address);
322     function feeToSetter() external view returns (address);
323 
324     function getPair(address tokenA, address tokenB) external view returns (address pair);
325     function allPairs(uint) external view returns (address pair);
326     function allPairsLength() external view returns (uint);
327 
328     function createPair(address tokenA, address tokenB) external returns (address pair);
329 
330     function setFeeTo(address) external;
331     function setFeeToSetter(address) external;
332 }
333 
334 interface IUniswapV2Pair {
335     event Approval(address indexed owner, address indexed spender, uint value);
336     event Transfer(address indexed from, address indexed to, uint value);
337 
338     function name() external pure returns (string memory);
339     function symbol() external pure returns (string memory);
340     function decimals() external pure returns (uint8);
341     function totalSupply() external view returns (uint);
342     function balanceOf(address owner) external view returns (uint);
343     function allowance(address owner, address spender) external view returns (uint);
344 
345     function approve(address spender, uint value) external returns (bool);
346     function transfer(address to, uint value) external returns (bool);
347     function transferFrom(address from, address to, uint value) external returns (bool);
348 
349     function DOMAIN_SEPARATOR() external view returns (bytes32);
350     function PERMIT_TYPEHASH() external pure returns (bytes32);
351     function nonces(address owner) external view returns (uint);
352 
353     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
354 
355     event Mint(address indexed sender, uint amount0, uint amount1);
356     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
357     event Swap(
358         address indexed sender,
359         uint amount0In,
360         uint amount1In,
361         uint amount0Out,
362         uint amount1Out,
363         address indexed to
364     );
365     event Sync(uint112 reserve0, uint112 reserve1);
366 
367     function MINIMUM_LIQUIDITY() external pure returns (uint);
368     function factory() external view returns (address);
369     function token0() external view returns (address);
370     function token1() external view returns (address);
371     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
372     function price0CumulativeLast() external view returns (uint);
373     function price1CumulativeLast() external view returns (uint);
374     function kLast() external view returns (uint);
375 
376     function mint(address to) external returns (uint liquidity);
377     function burn(address to) external returns (uint amount0, uint amount1);
378     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
379     function skim(address to) external;
380     function sync() external;
381 
382     function initialize(address, address) external;
383 }
384 
385 
386 interface IUniswapV2Router01 {
387     function factory() external pure returns (address);
388     function WETH() external pure returns (address);
389 
390     function addLiquidity(
391         address tokenA,
392         address tokenB,
393         uint amountADesired,
394         uint amountBDesired,
395         uint amountAMin,
396         uint amountBMin,
397         address to,
398         uint deadline
399     ) external returns (uint amountA, uint amountB, uint liquidity);
400     function addLiquidityETH(
401         address token,
402         uint amountTokenDesired,
403         uint amountTokenMin,
404         uint amountETHMin,
405         address to,
406         uint deadline
407     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
408     function removeLiquidity(
409         address tokenA,
410         address tokenB,
411         uint liquidity,
412         uint amountAMin,
413         uint amountBMin,
414         address to,
415         uint deadline
416     ) external returns (uint amountA, uint amountB);
417     function removeLiquidityETH(
418         address token,
419         uint liquidity,
420         uint amountTokenMin,
421         uint amountETHMin,
422         address to,
423         uint deadline
424     ) external returns (uint amountToken, uint amountETH);
425     function removeLiquidityWithPermit(
426         address tokenA,
427         address tokenB,
428         uint liquidity,
429         uint amountAMin,
430         uint amountBMin,
431         address to,
432         uint deadline,
433         bool approveMax, uint8 v, bytes32 r, bytes32 s
434     ) external returns (uint amountA, uint amountB);
435     function removeLiquidityETHWithPermit(
436         address token,
437         uint liquidity,
438         uint amountTokenMin,
439         uint amountETHMin,
440         address to,
441         uint deadline,
442         bool approveMax, uint8 v, bytes32 r, bytes32 s
443     ) external returns (uint amountToken, uint amountETH);
444     function swapExactTokensForTokens(
445         uint amountIn,
446         uint amountOutMin,
447         address[] calldata path,
448         address to,
449         uint deadline
450     ) external returns (uint[] memory amounts);
451     function swapTokensForExactTokens(
452         uint amountOut,
453         uint amountInMax,
454         address[] calldata path,
455         address to,
456         uint deadline
457     ) external returns (uint[] memory amounts);
458     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
459         external
460         payable
461         returns (uint[] memory amounts);
462     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
463         external
464         returns (uint[] memory amounts);
465     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
466         external
467         returns (uint[] memory amounts);
468     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
469         external
470         payable
471         returns (uint[] memory amounts);
472 
473     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
474     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
475     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
476     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
477     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
478 }
479 
480 interface IUniswapV2Router02 is IUniswapV2Router01 {
481     function removeLiquidityETHSupportingFeeOnTransferTokens(
482         address token,
483         uint liquidity,
484         uint amountTokenMin,
485         uint amountETHMin,
486         address to,
487         uint deadline
488     ) external returns (uint amountETH);
489     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
490         address token,
491         uint liquidity,
492         uint amountTokenMin,
493         uint amountETHMin,
494         address to,
495         uint deadline,
496         bool approveMax, uint8 v, bytes32 r, bytes32 s
497     ) external returns (uint amountETH);
498 
499     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
500         uint amountIn,
501         uint amountOutMin,
502         address[] calldata path,
503         address to,
504         uint deadline
505     ) external;
506     function swapExactETHForTokensSupportingFeeOnTransferTokens(
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline
511     ) external payable;
512     function swapExactTokensForETHSupportingFeeOnTransferTokens(
513         uint amountIn,
514         uint amountOutMin,
515         address[] calldata path,
516         address to,
517         uint deadline
518     ) external;
519 }
520 
521 contract QUID is Context, IERC20, Ownable {
522     using SafeMath for uint256;
523     using Address for address;
524 
525     address payable public marketingAddress =
526     payable(0xba80b52b20EE1EdE755C0a71b8924CD093e95dC4); // Marketing Address
527     address public immutable deadAddress =
528     0x000000000000000000000000000000000000dEaD;
529     mapping(address => uint256) private _rOwned;
530     mapping(address => uint256) private _tOwned;
531     mapping(address => mapping(address => uint256)) private _allowances;
532     mapping(address => bool) private _isSniper;
533     address[] private _confirmedSnipers;
534 
535     mapping(address => bool) private _isExcludedFromFee;
536     mapping(address => bool) private _isExcluded;
537     address[] private _excluded;
538 
539     uint256 private constant MAX = ~uint256(0);
540     uint256 private _tTotal = 500000000 * 10**9;
541     uint256 private _rTotal = (MAX - (MAX % _tTotal));
542     uint256 private _tFeeTotal;
543 
544     string private _name = 'Quid Ika';
545     string private _symbol = 'QUID';
546     uint8 private _decimals = 9;
547 
548     uint256 public _taxFee;
549     uint256 private _previousTaxFee = _taxFee;
550 
551     uint256 public _liquidityFee = 2;
552     uint256 private _previousLiquidityFee = _liquidityFee;
553 
554     uint256 private _feeRate = 2;
555     uint256 launchTime;
556 
557     IUniswapV2Router02 public uniswapV2Router;
558     address public uniswapV2Pair;
559 
560     bool inSwapAndLiquify;
561 
562     bool tradingOpen = false;
563 
564     event SwapETHForTokens(uint256 amountIn, address[] path);
565 
566     event SwapTokensForETH(uint256 amountIn, address[] path);
567 
568     modifier lockTheSwap() {
569         inSwapAndLiquify = true;
570         _;
571         inSwapAndLiquify = false;
572     }
573 
574     constructor() {
575         _rOwned[_msgSender()] = _rTotal;
576         emit Transfer(address(0), _msgSender(), _tTotal);
577     }
578 
579     function initContract() external onlyOwner {
580         // PancakeSwap: 0x10ED43C718714eb63d5aA57B78B54704E256024E
581         // Uniswap V2: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
582         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
583             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
584         );
585         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
586             address(this),
587             _uniswapV2Router.WETH()
588         );
589 
590         uniswapV2Router = _uniswapV2Router;
591 
592         _isExcludedFromFee[owner()] = true;
593         _isExcludedFromFee[address(this)] = true;
594     }
595 
596     function openTrading() external onlyOwner {
597         _liquidityFee = _previousLiquidityFee;
598         _taxFee = _previousTaxFee;
599         tradingOpen = true;
600         launchTime = block.timestamp;
601     }
602 
603     function name() public view returns (string memory) {
604         return _name;
605     }
606 
607     function symbol() public view returns (string memory) {
608         return _symbol;
609     }
610 
611     function decimals() public view returns (uint8) {
612         return _decimals;
613     }
614 
615     function totalSupply() public view override returns (uint256) {
616         return _tTotal;
617     }
618 
619     function balanceOf(address account) public view override returns (uint256) {
620         if (_isExcluded[account]) return _tOwned[account];
621         return tokenFromReflection(_rOwned[account]);
622     }
623 
624     function transfer(address recipient, uint256 amount)
625         public
626         override
627         returns (bool)
628     {
629         _transfer(_msgSender(), recipient, amount);
630         return true;
631     }
632 
633     function allowance(
634         address owner,
635         address spender
636     )
637         public
638         view
639         override
640         returns (uint256)
641     {
642         return _allowances[owner][spender];
643     }
644 
645     function approve(
646         address spender,
647         uint256 amount
648     )
649         public
650         override
651         returns (bool)
652     {
653         _approve(_msgSender(), spender, amount);
654         return true;
655     }
656 
657     function transferFrom(
658         address sender,
659         address recipient,
660         uint256 amount
661     )
662         public
663         override
664         returns (bool)
665     {
666         _transfer(sender, recipient, amount);
667         _approve(
668             sender,
669             _msgSender(),
670             _allowances[sender][_msgSender()].sub(
671                 amount,
672                 'ERC20: transfer amount exceeds allowance'
673             )
674         );
675         return true;
676     }
677 
678     function increaseAllowance(
679         address spender,
680         uint256 addedValue
681     )
682         public
683         virtual
684         returns (bool)
685     {
686         _approve(
687             _msgSender(),
688             spender,
689             _allowances[_msgSender()][spender].add(addedValue)
690         );
691         return true;
692     }
693 
694     function decreaseAllowance(address spender, uint256 subtractedValue)
695     public
696     virtual
697     returns (bool)
698     {
699         _approve(
700             _msgSender(),
701             spender,
702             _allowances[_msgSender()][spender].sub(
703                 subtractedValue,
704                 'ERC20: decreased allowance below zero'
705             )
706         );
707         return true;
708     }
709 
710     function isExcludedFromReward(address account) public view returns (bool) {
711         return _isExcluded[account];
712     }
713 
714     function totalFees() public view returns (uint256) {
715         return _tFeeTotal;
716     }
717 
718     function deliver(uint256 tAmount) public {
719         address sender = _msgSender();
720         require(
721             !_isExcluded[sender],
722             'Excluded addresses cannot call this function'
723         );
724         (uint256 rAmount, , , , , ) = _getValues(tAmount);
725         _rOwned[sender] = _rOwned[sender].sub(rAmount);
726         _rTotal = _rTotal.sub(rAmount);
727         _tFeeTotal = _tFeeTotal.add(tAmount);
728     }
729 
730     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
731     public
732     view
733     returns (uint256)
734     {
735         require(tAmount <= _tTotal, 'Amount must be less than supply');
736         if (!deductTransferFee) {
737             (uint256 rAmount, , , , , ) = _getValues(tAmount);
738             return rAmount;
739         } else {
740             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
741             return rTransferAmount;
742         }
743     }
744 
745     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
746         require(rAmount <= _rTotal, 'Amount must be less than total reflections');
747         uint256 currentRate = _getRate();
748         return rAmount.div(currentRate);
749     }
750 
751     function excludeFromReward(address account) public onlyOwner {
752         require(!_isExcluded[account], 'Account is already excluded');
753         if (_rOwned[account] > 0) {
754             _tOwned[account] = tokenFromReflection(_rOwned[account]);
755         }
756         _isExcluded[account] = true;
757         _excluded.push(account);
758     }
759 
760     function includeInReward(address account) external onlyOwner {
761         require(_isExcluded[account], 'Account is already excluded');
762         for (uint256 i = 0; i < _excluded.length; i++) {
763             if (_excluded[i] == account) {
764                 _excluded[i] = _excluded[_excluded.length - 1];
765                 _tOwned[account] = 0;
766                 _isExcluded[account] = false;
767                 _excluded.pop();
768                 break;
769             }
770         }
771     }
772 
773     function _approve(
774         address owner,
775         address spender,
776         uint256 amount
777     ) private {
778         require(owner != address(0), 'ERC20: approve from the zero address');
779         require(spender != address(0), 'ERC20: approve to the zero address');
780 
781         _allowances[owner][spender] = amount;
782         emit Approval(owner, spender, amount);
783     }
784 
785     function _transfer(
786         address from,
787         address to,
788         uint256 amount
789     ) private {
790         require(from != address(0), 'ERC20: transfer from the zero address');
791         require(to != address(0), 'ERC20: transfer to the zero address');
792         require(amount > 0, 'Transfer amount must be greater than zero');
793         require(!_isSniper[to], 'You have no power here!');
794         require(!_isSniper[msg.sender], 'You have no power here!');
795 
796         // buy
797         if (
798             from == uniswapV2Pair &&
799             to != address(uniswapV2Router) &&
800             !_isExcludedFromFee[to]
801         ) {
802             require(tradingOpen, 'Trading not yet enabled.');
803 
804             //antibot
805             if (block.timestamp == launchTime) {
806                 _isSniper[to] = true;
807                 _confirmedSnipers.push(to);
808             }
809         }
810 
811         uint256 contractTokenBalance = balanceOf(address(this));
812 
813         //sell
814 
815         if (!inSwapAndLiquify && tradingOpen && to == uniswapV2Pair) {
816             if (contractTokenBalance > 0) {
817                 if (
818                     contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)
819                 ) {
820                     contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(
821                         100
822                     );
823                 }
824                 swapTokens(contractTokenBalance);
825             }
826         }
827 
828         bool takeFee = false;
829 
830         //take fee only on swaps
831         if (
832             (from == uniswapV2Pair || to == uniswapV2Pair) &&
833             !(_isExcludedFromFee[from] || _isExcludedFromFee[to])
834         ) {
835             takeFee = true;
836         }
837 
838         _tokenTransfer(from, to, amount, takeFee);
839     }
840 
841     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
842         swapTokensForEth(contractTokenBalance);
843 
844         //Send to Marketing address
845         uint256 contractETHBalance = address(this).balance;
846         if (contractETHBalance > 0) {
847             sendETHToMarketing(address(this).balance);
848         }
849     }
850 
851     function sendETHToMarketing(uint256 amount) private {
852         // Ignore the boolean return value. If it gets stuck, then retrieve via `emergencyWithdraw`.
853         marketingAddress.call{value: amount}("");
854     }
855 
856     function swapTokensForEth(uint256 tokenAmount) private {
857         // generate the uniswap pair path of token -> weth
858         address[] memory path = new address[](2);
859         path[0] = address(this);
860         path[1] = uniswapV2Router.WETH();
861 
862         _approve(address(this), address(uniswapV2Router), tokenAmount);
863 
864         // make the swap
865         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
866             tokenAmount,
867             0, // accept any amount of ETH
868             path,
869             address(this), // The contract
870             block.timestamp
871         );
872 
873         emit SwapTokensForETH(tokenAmount, path);
874     }
875 
876     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
877         // approve token transfer to cover all possible scenarios
878         _approve(address(this), address(uniswapV2Router), tokenAmount);
879 
880         // add the liquidity
881         uniswapV2Router.addLiquidityETH{ value: ethAmount }(
882             address(this),
883             tokenAmount,
884             0, // slippage is unavoidable
885             0, // slippage is unavoidable
886             owner(),
887             block.timestamp
888         );
889     }
890 
891     function _tokenTransfer(
892         address sender,
893         address recipient,
894         uint256 amount,
895         bool takeFee
896     ) private {
897         if (!takeFee) removeAllFee();
898 
899         if (_isExcluded[sender] && !_isExcluded[recipient]) {
900             _transferFromExcluded(sender, recipient, amount);
901         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
902             _transferToExcluded(sender, recipient, amount);
903         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
904             _transferBothExcluded(sender, recipient, amount);
905         } else {
906             _transferStandard(sender, recipient, amount);
907         }
908 
909         if (!takeFee) restoreAllFee();
910     }
911 
912     function _transferStandard(
913         address sender,
914         address recipient,
915         uint256 tAmount
916     ) private {
917         (
918         uint256 rAmount,
919         uint256 rTransferAmount,
920         uint256 rFee,
921         uint256 tTransferAmount,
922         uint256 tFee,
923         uint256 tLiquidity
924         ) = _getValues(tAmount);
925         _rOwned[sender] = _rOwned[sender].sub(rAmount);
926         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
927         _takeLiquidity(tLiquidity);
928         _reflectFee(rFee, tFee);
929         emit Transfer(sender, recipient, tTransferAmount);
930     }
931 
932     function _transferToExcluded(
933         address sender,
934         address recipient,
935         uint256 tAmount
936     ) private {
937         (
938         uint256 rAmount,
939         uint256 rTransferAmount,
940         uint256 rFee,
941         uint256 tTransferAmount,
942         uint256 tFee,
943         uint256 tLiquidity
944         ) = _getValues(tAmount);
945         _rOwned[sender] = _rOwned[sender].sub(rAmount);
946         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
947         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
948         _takeLiquidity(tLiquidity);
949         _reflectFee(rFee, tFee);
950         emit Transfer(sender, recipient, tTransferAmount);
951     }
952 
953     function _transferFromExcluded(
954         address sender,
955         address recipient,
956         uint256 tAmount
957     ) private {
958         (
959         uint256 rAmount,
960         uint256 rTransferAmount,
961         uint256 rFee,
962         uint256 tTransferAmount,
963         uint256 tFee,
964         uint256 tLiquidity
965         ) = _getValues(tAmount);
966         _tOwned[sender] = _tOwned[sender].sub(tAmount);
967         _rOwned[sender] = _rOwned[sender].sub(rAmount);
968         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
969         _takeLiquidity(tLiquidity);
970         _reflectFee(rFee, tFee);
971         emit Transfer(sender, recipient, tTransferAmount);
972     }
973 
974     function _transferBothExcluded(
975         address sender,
976         address recipient,
977         uint256 tAmount
978     ) private {
979         (
980         uint256 rAmount,
981         uint256 rTransferAmount,
982         uint256 rFee,
983         uint256 tTransferAmount,
984         uint256 tFee,
985         uint256 tLiquidity
986         ) = _getValues(tAmount);
987         _tOwned[sender] = _tOwned[sender].sub(tAmount);
988         _rOwned[sender] = _rOwned[sender].sub(rAmount);
989         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
990         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
991         _takeLiquidity(tLiquidity);
992         _reflectFee(rFee, tFee);
993         emit Transfer(sender, recipient, tTransferAmount);
994     }
995 
996     function _reflectFee(uint256 rFee, uint256 tFee) private {
997         _rTotal = _rTotal.sub(rFee);
998         _tFeeTotal = _tFeeTotal.add(tFee);
999     }
1000 
1001     function _getValues(uint256 tAmount)
1002     private
1003     view
1004     returns (
1005         uint256,
1006         uint256,
1007         uint256,
1008         uint256,
1009         uint256,
1010         uint256
1011     )
1012     {
1013         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(
1014             tAmount
1015         );
1016         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1017             tAmount,
1018             tFee,
1019             tLiquidity,
1020             _getRate()
1021         );
1022         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1023     }
1024 
1025     function _getTValues(uint256 tAmount)
1026     private
1027     view
1028     returns (
1029         uint256,
1030         uint256,
1031         uint256
1032     )
1033     {
1034         uint256 tFee = calculateTaxFee(tAmount);
1035         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1036         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1037         return (tTransferAmount, tFee, tLiquidity);
1038     }
1039 
1040     function _getRValues(
1041         uint256 tAmount,
1042         uint256 tFee,
1043         uint256 tLiquidity,
1044         uint256 currentRate
1045     )
1046     private
1047     pure
1048     returns (
1049         uint256,
1050         uint256,
1051         uint256
1052     )
1053     {
1054         uint256 rAmount = tAmount.mul(currentRate);
1055         uint256 rFee = tFee.mul(currentRate);
1056         uint256 rLiquidity = tLiquidity.mul(currentRate);
1057         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1058         return (rAmount, rTransferAmount, rFee);
1059     }
1060 
1061     function _getRate() private view returns (uint256) {
1062         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1063         return rSupply.div(tSupply);
1064     }
1065 
1066     function _getCurrentSupply() private view returns (uint256, uint256) {
1067         uint256 rSupply = _rTotal;
1068         uint256 tSupply = _tTotal;
1069         for (uint256 i = 0; i < _excluded.length; i++) {
1070             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
1071                 return (_rTotal, _tTotal);
1072             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1073             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1074         }
1075         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1076         return (rSupply, tSupply);
1077     }
1078 
1079     function _takeLiquidity(uint256 tLiquidity) private {
1080         uint256 currentRate = _getRate();
1081         uint256 rLiquidity = tLiquidity.mul(currentRate);
1082         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1083         if (_isExcluded[address(this)])
1084             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1085     }
1086 
1087     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1088         return _amount.mul(_taxFee).div(10**2);
1089     }
1090 
1091     function calculateLiquidityFee(uint256 _amount)
1092     private
1093     view
1094     returns (uint256)
1095     {
1096         return _amount.mul(_liquidityFee).div(10**2);
1097     }
1098 
1099     function removeAllFee() private {
1100         if (_taxFee == 0 && _liquidityFee == 0) return;
1101 
1102         _previousTaxFee = _taxFee;
1103         _previousLiquidityFee = _liquidityFee;
1104 
1105         _taxFee = 0;
1106         _liquidityFee = 0;
1107     }
1108 
1109     function restoreAllFee() private {
1110         _taxFee = _previousTaxFee;
1111         _liquidityFee = _previousLiquidityFee;
1112     }
1113 
1114     function isExcludedFromFee(address account) public view returns (bool) {
1115         return _isExcludedFromFee[account];
1116     }
1117 
1118     function excludeFromFee(address account) public onlyOwner {
1119         _isExcludedFromFee[account] = true;
1120     }
1121 
1122     function includeInFee(address account) public onlyOwner {
1123         _isExcludedFromFee[account] = false;
1124     }
1125 
1126     function setTaxFeePercent(uint256 taxFee) external onlyOwner {
1127         _taxFee = taxFee;
1128     }
1129 
1130     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner {
1131         _liquidityFee = liquidityFee;
1132     }
1133 
1134     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1135         marketingAddress = payable(_marketingAddress);
1136     }
1137 
1138     function transferToAddressETH(address payable recipient, uint256 amount)
1139     private
1140     {
1141         recipient.transfer(amount);
1142     }
1143 
1144     function isRemovedSniper(address account) public view returns (bool) {
1145         return _isSniper[account];
1146     }
1147 
1148     function _removeSniper(address account) external onlyOwner {
1149         require(
1150             account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1151             'We can not blacklist Uniswap'
1152         );
1153         require(!_isSniper[account], 'Account is already blacklisted');
1154         _isSniper[account] = true;
1155         _confirmedSnipers.push(account);
1156     }
1157 
1158     function _amnestySniper(address account) external onlyOwner {
1159         require(_isSniper[account], 'Account is not blacklisted');
1160         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1161             if (_confirmedSnipers[i] == account) {
1162                 _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
1163                 _isSniper[account] = false;
1164                 _confirmedSnipers.pop();
1165                 break;
1166             }
1167         }
1168     }
1169 
1170     function setFeeRate(uint256 rate) external onlyOwner {
1171         _feeRate = rate;
1172     }
1173 
1174     //to recieve ETH from uniswapV2Router when swaping
1175     receive() external payable {}
1176 
1177     // Withdraw ETH that gets stuck in contract by accident
1178     function emergencyWithdraw() external onlyOwner {
1179         payable(owner()).send(address(this).balance);
1180     }
1181 }