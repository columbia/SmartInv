1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.0;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 interface IERC20 {
161     function name() external view returns (string memory);
162     function symbol() external view returns (string memory);
163     function decimals() external view returns (uint8);
164     function totalSupply() external view returns (uint);
165     function balanceOf(address owner) external view returns (uint);
166     function allowance(address owner, address spender) external view returns (uint);
167 
168     function approve(address spender, uint value) external returns (bool);
169     function transfer(address to, uint value) external returns (bool);
170     function transferFrom(address from, address to, uint value) external returns (bool);
171 	
172 	event Approval(address indexed owner, address indexed spender, uint value);
173     event Transfer(address indexed from, address indexed to, uint value);
174 }
175 
176 /**
177  * @dev Collection of functions related to the address type
178  */
179 library Address {
180     /**
181      * @dev Returns true if `account` is a contract.
182      *
183      * [IMPORTANT]
184      * ====
185      * It is unsafe to assume that an address for which this function returns
186      * false is an externally-owned account (EOA) and not a contract.
187      *
188      * Among others, `isContract` will return false for the following
189      * types of addresses:
190      *
191      *  - an externally-owned account
192      *  - a contract in construction
193      *  - an address where a contract will be created
194      *  - an address where a contract lived, but was destroyed
195      * ====
196      */
197     function isContract(address account) internal view returns (bool) {
198         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
199         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
200         // for accounts without code, i.e. `keccak256('')`
201         bytes32 codehash;
202         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
203         // solhint-disable-next-line no-inline-assembly
204         assembly { codehash := extcodehash(account) }
205         return (codehash != accountHash && codehash != 0x0);
206     }
207 
208     /**
209      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
210      * `recipient`, forwarding all available gas and reverting on errors.
211      *
212      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
213      * of certain opcodes, possibly making contracts go over the 2300 gas limit
214      * imposed by `transfer`, making them unable to receive funds via
215      * `transfer`. {sendValue} removes this limitation.
216      *
217      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
218      *
219      * IMPORTANT: because control is transferred to `recipient`, care must be
220      * taken to not create reentrancy vulnerabilities. Consider using
221      * {ReentrancyGuard} or the
222      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
223      */
224     function sendValue(address payable recipient, uint256 amount) internal {
225         require(address(this).balance >= amount, "Address: insufficient balance");
226 
227         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
228         (bool success, ) = recipient.call{ value: amount }("");
229         require(success, "Address: unable to send value, recipient may have reverted");
230     }
231 
232     /**
233      * @dev Performs a Solidity function call using a low level `call`. A
234      * plain`call` is an unsafe replacement for a function call: use this
235      * function instead.
236      *
237      * If `target` reverts with a revert reason, it is bubbled up by this
238      * function (like regular Solidity function calls).
239      *
240      * Returns the raw returned data. To convert to the expected return value,
241      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
242      *
243      * Requirements:
244      *
245      * - `target` must be a contract.
246      * - calling `target` with `data` must not revert.
247      *
248      * _Available since v3.1._
249      */
250     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
251       return functionCall(target, data, "Address: low-level call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
256      * `errorMessage` as a fallback revert reason when `target` reverts.
257      *
258      * _Available since v3.1._
259      */
260     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
261         return _functionCallWithValue(target, data, 0, errorMessage);
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
266      * but also transferring `value` wei to `target`.
267      *
268      * Requirements:
269      *
270      * - the calling contract must have an ETH balance of at least `value`.
271      * - the called Solidity function must be `payable`.
272      *
273      * _Available since v3.1._
274      */
275     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
276         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
281      * with `errorMessage` as a fallback revert reason when `target` reverts.
282      *
283      * _Available since v3.1._
284      */
285     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
286         require(address(this).balance >= value, "Address: insufficient balance for call");
287         return _functionCallWithValue(target, data, value, errorMessage);
288     }
289 
290     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
291         require(isContract(target), "Address: call to non-contract");
292 
293         // solhint-disable-next-line avoid-low-level-calls
294         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
295         if (success) {
296             return returndata;
297         } else {
298             // Look for revert reason and bubble it up if present
299             if (returndata.length > 0) {
300                 // The easiest way to bubble the revert reason is using memory via assembly
301 
302                 // solhint-disable-next-line no-inline-assembly
303                 assembly {
304                     let returndata_size := mload(returndata)
305                     revert(add(32, returndata), returndata_size)
306                 }
307             } else {
308                 revert(errorMessage);
309             }
310         }
311     }
312 }
313 
314 
315 /**
316  * @title SafeERC20
317  * @dev Wrappers around ERC20 operations that throw on failure (when the token
318  * contract returns false). Tokens that return no value (and instead revert or
319  * throw on failure) are also supported, non-reverting calls are assumed to be
320  * successful.
321  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
322  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
323  */
324 
325 library SafeERC20 {
326     using SafeMath for uint256;
327     using Address for address;
328 
329     function safeTransfer(IERC20 token, address to, uint256 value) internal {
330         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
331     }
332 
333     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
334         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
335     }
336 
337     function safeApprove(IERC20 token, address spender, uint256 value) internal {
338         // safeApprove should only be called when setting an initial allowance,
339         // or when resetting it to zero. To increase and decrease it, use
340         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
341         // solhint-disable-next-line max-line-length
342         require((value == 0) || (token.allowance(address(this), spender) == 0),
343             "SafeERC20: approve from non-zero to non-zero allowance"
344         );
345         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
346     }
347 
348     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
349         uint256 newAllowance = token.allowance(address(this), spender).add(value);
350         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
351     }
352 
353     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
354         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
355         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
356     }
357 
358     /**
359      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
360      * on the return value: the return value is optional (but if data is returned, it must not be false).
361      * @param token The token targeted by the call.
362      * @param data The call data (encoded using abi.encode or one of its variants).
363      */
364     function callOptionalReturn(IERC20 token, bytes memory data) private {
365         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
366         // we're implementing it ourselves.
367 
368         // A Solidity high level call has three parts:
369         //  1. The target address is checked to verify it contains contract code
370         //  2. The call itself is made, and success asserted
371         //  3. The return value is decoded, which in turn checks the size of the returned data.
372         // solhint-disable-next-line max-line-length
373         require(address(token).isContract(), "SafeERC20: call to non-contract");
374 
375         // solhint-disable-next-line avoid-low-level-calls
376         (bool success, bytes memory returndata) = address(token).call(data);
377         require(success, "SafeERC20: low-level call failed");
378 
379         if (returndata.length > 0) { // Return data is optional
380             // solhint-disable-next-line max-line-length
381             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
382         }
383     }
384 }
385 
386 interface IUniswapFactory {
387     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
388 
389     function feeTo() external view returns (address);
390     function feeToSetter() external view returns (address);
391 
392     function getPair(address tokenA, address tokenB) external view returns (address pair);
393     function allPairs(uint) external view returns (address pair);
394     function allPairsLength() external view returns (uint);
395 
396     function createPair(address tokenA, address tokenB) external returns (address pair);
397 
398     function setFeeTo(address) external;
399     function setFeeToSetter(address) external;
400 }
401 
402 interface IUniswapRouter01 {
403     function factory() external pure returns (address);
404     function WETH() external pure returns (address);
405 
406     function addLiquidity(
407         address tokenA,
408         address tokenB,
409         uint amountADesired,
410         uint amountBDesired,
411         uint amountAMin,
412         uint amountBMin,
413         address to,
414         uint deadline
415     ) external returns (uint amountA, uint amountB, uint liquidity);
416     function addLiquidityETH(
417         address token,
418         uint amountTokenDesired,
419         uint amountTokenMin,
420         uint amountETHMin,
421         address to,
422         uint deadline
423     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
424     function removeLiquidity(
425         address tokenA,
426         address tokenB,
427         uint liquidity,
428         uint amountAMin,
429         uint amountBMin,
430         address to,
431         uint deadline
432     ) external returns (uint amountA, uint amountB);
433     function removeLiquidityETH(
434         address token,
435         uint liquidity,
436         uint amountTokenMin,
437         uint amountETHMin,
438         address to,
439         uint deadline
440     ) external returns (uint amountToken, uint amountETH);
441     function removeLiquidityWithPermit(
442         address tokenA,
443         address tokenB,
444         uint liquidity,
445         uint amountAMin,
446         uint amountBMin,
447         address to,
448         uint deadline,
449         bool approveMax, uint8 v, bytes32 r, bytes32 s
450     ) external returns (uint amountA, uint amountB);
451     function removeLiquidityETHWithPermit(
452         address token,
453         uint liquidity,
454         uint amountTokenMin,
455         uint amountETHMin,
456         address to,
457         uint deadline,
458         bool approveMax, uint8 v, bytes32 r, bytes32 s
459     ) external returns (uint amountToken, uint amountETH);
460     function swapExactTokensForTokens(
461         uint amountIn,
462         uint amountOutMin,
463         address[] calldata path,
464         address to,
465         uint deadline
466     ) external returns (uint[] memory amounts);
467     function swapTokensForExactTokens(
468         uint amountOut,
469         uint amountInMax,
470         address[] calldata path,
471         address to,
472         uint deadline
473     ) external returns (uint[] memory amounts);
474     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
475         external
476         payable
477         returns (uint[] memory amounts);
478     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
479         external
480         returns (uint[] memory amounts);
481     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
482         external
483         returns (uint[] memory amounts);
484     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
485         external
486         payable
487         returns (uint[] memory amounts);
488 
489     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
490     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
491     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
492     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
493     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
494 }
495 
496 interface IUniswapRouter02 is IUniswapRouter01 {
497     function removeLiquidityETHSupportingFeeOnTransferTokens(
498         address token,
499         uint liquidity,
500         uint amountTokenMin,
501         uint amountETHMin,
502         address to,
503         uint deadline
504     ) external returns (uint amountETH);
505     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
506         address token,
507         uint liquidity,
508         uint amountTokenMin,
509         uint amountETHMin,
510         address to,
511         uint deadline,
512         bool approveMax, uint8 v, bytes32 r, bytes32 s
513     ) external returns (uint amountETH);
514 
515     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
516         uint amountIn,
517         uint amountOutMin,
518         address[] calldata path,
519         address to,
520         uint deadline
521     ) external;
522     function swapExactETHForTokensSupportingFeeOnTransferTokens(
523         uint amountOutMin,
524         address[] calldata path,
525         address to,
526         uint deadline
527     ) external payable;
528     function swapExactTokensForETHSupportingFeeOnTransferTokens(
529         uint amountIn,
530         uint amountOutMin,
531         address[] calldata path,
532         address to,
533         uint deadline
534     ) external;
535 }
536 
537 interface IUniswapPair {
538     event Approval(address indexed owner, address indexed spender, uint value);
539     event Transfer(address indexed from, address indexed to, uint value);
540 
541     function name() external pure returns (string memory);
542     function symbol() external pure returns (string memory);
543     function decimals() external pure returns (uint8);
544     function totalSupply() external view returns (uint);
545     function balanceOf(address owner) external view returns (uint);
546     function allowance(address owner, address spender) external view returns (uint);
547 
548     function approve(address spender, uint value) external returns (bool);
549     function transfer(address to, uint value) external returns (bool);
550     function transferFrom(address from, address to, uint value) external returns (bool);
551 
552     function DOMAIN_SEPARATOR() external view returns (bytes32);
553     function PERMIT_TYPEHASH() external pure returns (bytes32);
554     function nonces(address owner) external view returns (uint);
555 
556     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
557 
558     event Mint(address indexed sender, uint amount0, uint amount1);
559     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
560     event Swap(
561         address indexed sender,
562         uint amount0In,
563         uint amount1In,
564         uint amount0Out,
565         uint amount1Out,
566         address indexed to
567     );
568     event Sync(uint112 reserve0, uint112 reserve1);
569 
570     function MINIMUM_LIQUIDITY() external pure returns (uint);
571     function factory() external view returns (address);
572     function token0() external view returns (address);
573     function token1() external view returns (address);
574     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
575     function price0CumulativeLast() external view returns (uint);
576     function price1CumulativeLast() external view returns (uint);
577     function kLast() external view returns (uint);
578 
579     function mint(address to) external returns (uint liquidity);
580     function burn(address to) external returns (uint amount0, uint amount1);
581     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
582     function skim(address to) external;
583     function sync() external;
584 
585     function initialize(address, address) external;
586 }
587 
588 contract Ownable {
589    address payable public _owner;
590 	   
591     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
592 
593     /**
594      * @dev Initializes the contract setting the deployer as the initial owner.
595      */
596     constructor () public {
597         _owner = msg.sender;
598     }
599 
600     /**
601      * @dev Throws if called by any account other than the owner.
602      */
603     modifier onlyOwner() {
604         require(isOwner(), "Ownable: caller is not the owner");
605         _;
606     }
607 
608     /**
609      * @dev Returns true if the caller is the current owner.
610      */
611     function isOwner() public view returns (bool) {
612         return msg.sender == _owner;
613     }
614 
615 }
616 
617 contract POMMigration is Ownable {
618     using SafeMath for uint256;
619     using SafeERC20 for IERC20;
620 	
621 	uint256 public _deadline;
622 	bool swapEnable = true;
623     
624 	address public _weth;
625 	address public _pom;
626 	address public _liquidReceiverAddress;
627 	IUniswapRouter02 public _uniswapRouter;
628 	
629 	mapping (address => uint256) public claimableAmount;
630 	
631 	receive() external payable {}
632 	
633     constructor (
634 		address pom
635 		,address liquidReceiverAddress
636 		,address uniswapRouter
637 		,uint256 deadline
638 	) public Ownable() {
639 		_uniswapRouter = IUniswapRouter02(uniswapRouter);
640 		_weth = _uniswapRouter.WETH();
641 		_deadline = deadline;
642 		_pom = pom;
643 		_liquidReceiverAddress = liquidReceiverAddress;
644 	}	
645 	
646 	event Swapped(address indexed sender, uint256 amount);
647 	
648 	function swap() external {		
649 		require(block.timestamp <= _deadline, "Swap times up");
650 		require(tx.origin == msg.sender , 'call from unauthorized contract');
651 		
652 		uint256 balance = IERC20(address(_pom)).balanceOf(msg.sender);
653 		
654 		if(balance > 0){
655 			uint256 beforeSendBalance = IERC20(address(_pom)).balanceOf(address(this));
656 			IERC20(address(_pom)).safeTransferFrom(msg.sender, address(this), balance);
657 			uint256 afterSendBalance = IERC20(address(_pom)).balanceOf(address(this));
658 			
659 			balance = afterSendBalance - beforeSendBalance;
660 			
661             if(swapEnable){
662                 _swapToken(balance);
663             }
664             
665 			
666 			claimableAmount[msg.sender] += balance;
667 			emit Swapped(msg.sender,  balance);
668 		}
669 	}
670 
671 	function _swapToken(uint256 tokensToSwap) internal {
672 		uint256 deadline = block.timestamp + 5 minutes;
673 		
674 		IERC20(address(_pom)).safeApprove(address(_uniswapRouter), 0);
675 		IERC20(address(_pom)).safeApprove(address(_uniswapRouter), tokensToSwap);
676 		
677 		address[] memory path = new address[](2);
678 		path[0] = address(address(_pom));
679 		path[1] = address(_weth);
680 		_uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokensToSwap, 0, path, address(this), deadline);
681 		
682 		uint256 amountETH = address(this).balance;
683         payable(_liquidReceiverAddress).transfer(amountETH);
684 	}
685 	
686     function swapToken(uint256 tokensToSwap) external onlyOwner{
687         _swapToken(tokensToSwap);
688     }
689     
690     function setSwap(bool _swapEnable) external onlyOwner{
691         swapEnable = _swapEnable;
692     }
693 
694 	function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
695         uint256 amountETH = address(this).balance;
696         payable(msg.sender).transfer((amountETH * amountPercentage) / 100);
697     }
698 	
699 	function clearStuckToken(address TokenAddress, uint256 amountPercentage) external onlyOwner {
700         uint256 amountToken = IERC20(TokenAddress).balanceOf(address(this));
701 		IERC20(TokenAddress).safeTransfer(msg.sender, (amountToken * amountPercentage) / 100);
702     }
703 }