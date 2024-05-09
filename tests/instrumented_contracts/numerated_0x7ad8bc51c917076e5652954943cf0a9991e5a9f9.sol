1 //SPDX-License-Identifier: MIT
2 /*
3 
4       ::::::::  :::    :::  ::::::::  :::       :::       ::::::::::: ::::    ::: :::    ::: 
5     :+:    :+: :+:    :+: :+:    :+: :+:       :+:           :+:     :+:+:   :+: :+:    :+:  
6    +:+        +:+    +:+ +:+    +:+ +:+       +:+           +:+     :+:+:+  +:+ +:+    +:+   
7   +#+        +#++:++#++ +#+    +:+ +#+  +:+  +#+           +#+     +#+ +:+ +#+ +#+    +:+    
8  +#+        +#+    +#+ +#+    +#+ +#+ +#+#+ +#+           +#+     +#+  +#+#+# +#+    +#+     
9 #+#    #+# #+#    #+# #+#    #+#  #+#+# #+#+#            #+#     #+#   #+#+# #+#    #+#      
10 ########  ###    ###  ########    ###   ###         ########### ###    ####  ########        
11 
12 
13 2% Reflection
14 2% LP
15 9% Marketing & Charity and Development
16 Website: https://chowinu.io/
17 Telegram: https://t.me/chowinu_eth
18 Twitter: https://twitter.com/chowinu_
19 Instagram: https://www.instagram.com/chow_inu/
20 
21 */
22 
23 
24 pragma solidity ^0.8.0;
25 
26 
27 
28 /*
29  * @dev Provides information about the current execution context, including the
30  * sender of the transaction and its data. While these are generally available
31  * via msg.sender and msg.data, they should not be accessed in such a direct
32  * manner, since when dealing with meta-transactions the account sending and
33  * paying for execution may not be the actual sender (as far as an application
34  * is concerned).
35  *
36  * This contract is only required for intermediate, library-like contracts.
37  */
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view virtual returns (bytes calldata) {
44         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
45         return msg.data;
46     }
47 }
48 
49 
50 // File: @openzeppelin/contracts/access/Ownable.sol
51 /**
52  * @dev Contract module which provides a basic access control mechanism, where
53  * there is an account (an owner) that can be granted exclusive access to
54  * specific functions.
55  *
56  * By default, the owner account will be the one that deploys the contract. This
57  * can later be changed with {transferOwnership}.
58  *
59  * This module is used through inheritance. It will make available the modifier
60  * `onlyOwner`, which can be applied to your functions to restrict their use to
61  * the owner.
62  */
63 abstract contract Ownable is Context {
64     address public _owner;
65     address private _authorizedNewOwner;
66 
67     event OwnershipTransferAuthorization(address indexed authorizedAddress);
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     /**
71      * @dev Initializes the contract setting the deployer as the initial owner.
72      */
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     /**
80      * @dev Returns the address of the current owner.
81      */
82     function owner() public view virtual returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(owner() == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     /**
95      * @dev Returns the address of the current authorized new owner.
96      */
97     function authorizedNewOwner() public view virtual returns (address) {
98         return _authorizedNewOwner;
99     }
100 
101     /**
102      * @notice Authorizes the transfer of ownership from _owner to the provided address.
103      * NOTE: No transfer will occur unless authorizedAddress calls assumeOwnership( ).
104      * This authorization may be removed by another call to this function authorizing
105      * the null address.
106      *
107      * @param authorizedAddress The address authorized to become the new owner.
108      */
109     function authorizeOwnershipTransfer(address authorizedAddress) external onlyOwner {
110         _authorizedNewOwner = authorizedAddress;
111         emit OwnershipTransferAuthorization(_authorizedNewOwner);
112     }
113 
114     /**
115      * @notice Transfers ownership of this contract to the _authorizedNewOwner.
116      */
117     function assumeOwnership() external {
118         require(_msgSender() == _authorizedNewOwner, "Ownable: only the authorized new owner can accept ownership");
119         emit OwnershipTransferred(_owner, _authorizedNewOwner);
120         _owner = _authorizedNewOwner;
121         _authorizedNewOwner = address(0);
122     }
123 
124     /**
125      * @dev Leaves the contract without owner. It will not be possible to call
126      * `onlyOwner` functions anymore. Can only be called by the current owner.
127      *
128      * NOTE: Renouncing ownership will leave the contract without an owner,
129      * thereby removing any functionality that is only available to the owner.
130      *
131      * @param confirmAddress The address wants to give up ownership.
132      */
133     function renounceOwnership(address confirmAddress) public virtual onlyOwner {
134         require(confirmAddress == _owner, "Ownable: confirm address is wrong");
135         emit OwnershipTransferred(_owner, address(0));
136         _authorizedNewOwner = address(0);
137         _owner = address(0);
138     }
139     
140 }
141 
142 
143 // CAUTION
144 // This version of SafeMath should only be used with Solidity 0.8 or later,
145 // because it relies on the compiler's built in overflow checks.
146 /**
147  * @dev Wrappers over Solidity's arithmetic operations.
148  *
149  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
150  * now has built in overflow checking.
151  */
152 library SafeMath {
153     /**
154      * @dev Returns the addition of two unsigned integers, with an overflow flag.
155      *
156      * _Available since v3.4._
157      */
158     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
159         unchecked {
160             uint256 c = a + b;
161             if (c < a) return (false, 0);
162             return (true, c);
163         }
164     }
165 
166     /**
167      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
168      *
169      * _Available since v3.4._
170      */
171     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
172         unchecked {
173             if (b > a) return (false, 0);
174             return (true, a - b);
175         }
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
180      *
181      * _Available since v3.4._
182      */
183     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
184         unchecked {
185             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186             // benefit is lost if 'b' is also tested.
187             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188             if (a == 0) return (true, 0);
189             uint256 c = a * b;
190             if (c / a != b) return (false, 0);
191             return (true, c);
192         }
193     }
194 
195     /**
196      * @dev Returns the division of two unsigned integers, with a division by zero flag.
197      *
198      * _Available since v3.4._
199      */
200     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
201         unchecked {
202             if (b == 0) return (false, 0);
203             return (true, a / b);
204         }
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
209      *
210      * _Available since v3.4._
211      */
212     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
213         unchecked {
214             if (b == 0) return (false, 0);
215             return (true, a % b);
216         }
217     }
218 
219     /**
220      * @dev Returns the addition of two unsigned integers, reverting on
221      * overflow.
222      *
223      * Counterpart to Solidity's `+` operator.
224      *
225      * Requirements:
226      *
227      * - Addition cannot overflow.
228      */
229     function add(uint256 a, uint256 b) internal pure returns (uint256) {
230         return a + b;
231     }
232 
233     /**
234      * @dev Returns the subtraction of two unsigned integers, reverting on
235      * overflow (when the result is negative).
236      *
237      * Counterpart to Solidity's `-` operator.
238      *
239      * Requirements:
240      *
241      * - Subtraction cannot overflow.
242      */
243     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
244         return a - b;
245     }
246 
247     /**
248      * @dev Returns the multiplication of two unsigned integers, reverting on
249      * overflow.
250      *
251      * Counterpart to Solidity's `*` operator.
252      *
253      * Requirements:
254      *
255      * - Multiplication cannot overflow.
256      */
257     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
258         return a * b;
259     }
260 
261     /**
262      * @dev Returns the integer division of two unsigned integers, reverting on
263      * division by zero. The result is rounded towards zero.
264      *
265      * Counterpart to Solidity's `/` operator.
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         return a / b;
273     }
274 
275     /**
276      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
277      * reverting when dividing by zero.
278      *
279      * Counterpart to Solidity's `%` operator. This function uses a `revert`
280      * opcode (which leaves remaining gas untouched) while Solidity uses an
281      * invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a % b;
289     }
290 
291     /**
292      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
293      * overflow (when the result is negative).
294      *
295      * CAUTION: This function is deprecated because it requires allocating memory for the error
296      * message unnecessarily. For custom revert reasons use {trySub}.
297      *
298      * Counterpart to Solidity's `-` operator.
299      *
300      * Requirements:
301      *
302      * - Subtraction cannot overflow.
303      */
304     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
305         unchecked {
306             require(b <= a, errorMessage);
307             return a - b;
308         }
309     }
310 
311     /**
312      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
313      * division by zero. The result is rounded towards zero.
314      *
315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
316      * opcode (which leaves remaining gas untouched) while Solidity uses an
317      * invalid opcode to revert (consuming all remaining gas).
318      *
319      * Counterpart to Solidity's `/` operator. Note: this function uses a
320      * `revert` opcode (which leaves remaining gas untouched) while Solidity
321      * uses an invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         unchecked {
329             require(b > 0, errorMessage);
330             return a / b;
331         }
332     }
333 
334     /**
335      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
336      * reverting with custom message when dividing by zero.
337      *
338      * CAUTION: This function is deprecated because it requires allocating memory for the error
339      * message unnecessarily. For custom revert reasons use {tryMod}.
340      *
341      * Counterpart to Solidity's `%` operator. This function uses a `revert`
342      * opcode (which leaves remaining gas untouched) while Solidity uses an
343      * invalid opcode to revert (consuming all remaining gas).
344      *
345      * Requirements:
346      *
347      * - The divisor cannot be zero.
348      */
349     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
350         unchecked {
351             require(b > 0, errorMessage);
352             return a % b;
353         }
354     }
355 }
356 
357 
358 /**
359  * @dev Collection of functions related to the address type
360  */
361 library Address {
362     /**
363      * @dev Returns true if `account` is a contract.
364      *
365      * [IMPORTANT]
366      * ====
367      * It is unsafe to assume that an address for which this function returns
368      * false is an externally-owned account (EOA) and not a contract.
369      *
370      * Among others, `isContract` will return false for the following
371      * types of addresses:
372      *
373      *  - an externally-owned account
374      *  - a contract in construction
375      *  - an address where a contract will be created
376      *  - an address where a contract lived, but was destroyed
377      * ====
378      */
379     function isContract(address account) internal view returns (bool) {
380         // This method relies on extcodesize, which returns 0 for contracts in
381         // construction, since the code is only stored at the end of the
382         // constructor execution.
383 
384         uint256 size;
385         // solhint-disable-next-line no-inline-assembly
386         assembly { size := extcodesize(account) }
387         return size > 0;
388     }
389 
390     /**
391      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
392      * `recipient`, forwarding all available gas and reverting on errors.
393      *
394      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
395      * of certain opcodes, possibly making contracts go over the 2300 gas limit
396      * imposed by `transfer`, making them unable to receive funds via
397      * `transfer`. {sendValue} removes this limitation.
398      *
399      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
400      *
401      * IMPORTANT: because control is transferred to `recipient`, care must be
402      * taken to not create reentrancy vulnerabilities. Consider using
403      * {ReentrancyGuard} or the
404      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
405      */
406     function sendValue(address payable recipient, uint256 amount) internal {
407         require(address(this).balance >= amount, "Address: insufficient balance");
408 
409         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
410         (bool success, ) = recipient.call{ value: amount }("");
411         require(success, "Address: unable to send value, recipient may have reverted");
412     }
413 
414     /**
415      * @dev Performs a Solidity function call using a low level `call`. A
416      * plain`call` is an unsafe replacement for a function call: use this
417      * function instead.
418      *
419      * If `target` reverts with a revert reason, it is bubbled up by this
420      * function (like regular Solidity function calls).
421      *
422      * Returns the raw returned data. To convert to the expected return value,
423      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
424      *
425      * Requirements:
426      *
427      * - `target` must be a contract.
428      * - calling `target` with `data` must not revert.
429      *
430      * _Available since v3.1._
431      */
432     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
433       return functionCall(target, data, "Address: low-level call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
438      * `errorMessage` as a fallback revert reason when `target` reverts.
439      *
440      * _Available since v3.1._
441      */
442     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, 0, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but also transferring `value` wei to `target`.
449      *
450      * Requirements:
451      *
452      * - the calling contract must have an ETH balance of at least `value`.
453      * - the called Solidity function must be `payable`.
454      *
455      * _Available since v3.1._
456      */
457     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
458         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
463      * with `errorMessage` as a fallback revert reason when `target` reverts.
464      *
465      * _Available since v3.1._
466      */
467     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
468         require(address(this).balance >= value, "Address: insufficient balance for call");
469         require(isContract(target), "Address: call to non-contract");
470 
471         // solhint-disable-next-line avoid-low-level-calls
472         (bool success, bytes memory returndata) = target.call{ value: value }(data);
473         return _verifyCallResult(success, returndata, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but performing a static call.
479      *
480      * _Available since v3.3._
481      */
482     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
483         return functionStaticCall(target, data, "Address: low-level static call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
488      * but performing a static call.
489      *
490      * _Available since v3.3._
491      */
492     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
493         require(isContract(target), "Address: static call to non-contract");
494 
495         // solhint-disable-next-line avoid-low-level-calls
496         (bool success, bytes memory returndata) = target.staticcall(data);
497         return _verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
502      * but performing a delegate call.
503      *
504      * _Available since v3.4._
505      */
506     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
507         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
512      * but performing a delegate call.
513      *
514      * _Available since v3.4._
515      */
516     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
517         require(isContract(target), "Address: delegate call to non-contract");
518 
519         // solhint-disable-next-line avoid-low-level-calls
520         (bool success, bytes memory returndata) = target.delegatecall(data);
521         return _verifyCallResult(success, returndata, errorMessage);
522     }
523 
524     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
525         if (success) {
526             return returndata;
527         } else {
528             // Look for revert reason and bubble it up if present
529             if (returndata.length > 0) {
530                 // The easiest way to bubble the revert reason is using memory via assembly
531 
532                 // solhint-disable-next-line no-inline-assembly
533                 assembly {
534                     let returndata_size := mload(returndata)
535                     revert(add(32, returndata), returndata_size)
536                 }
537             } else {
538                 revert(errorMessage);
539             }
540         }
541     }
542 }
543 
544 interface IFTPAntiBot {
545     // Here we create the interface to interact with AntiBot
546     function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);
547     function registerBlock(address _recipient, address _sender) external;
548 }
549 
550 // import "hardhat/console.sol";
551 interface IERC20 {
552 
553     function totalSupply() external view returns (uint256);
554 
555     /**
556      * @dev Returns the amount of tokens owned by `account`.
557      */
558     function balanceOf(address account) external view returns (uint256);
559 
560     /**
561      * @dev Moves `amount` tokens from the caller's account to `recipient`.
562      *
563      * Returns a boolean value indicating whether the operation succeeded.
564      *
565      * Emits a {Transfer} event.
566      */
567     function transfer(address recipient, uint256 amount) external returns (bool);
568 
569     /**
570      * @dev Returns the remaining number of tokens that `spender` will be
571      * allowed to spend on behalf of `owner` through {transferFrom}. This is
572      * zero by default.
573      *
574      * This value changes when {approve} or {transferFrom} are called.
575      */
576     function allowance(address owner, address spender) external view returns (uint256);
577 
578     /**
579      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
580      *
581      * Returns a boolean value indicating whether the operation succeeded.
582      *
583      * IMPORTANT: Beware that changing an allowance with this method brings the risk
584      * that someone may use both the old and the new allowance by unfortunate
585      * transaction ordering. One possible solution to mitigate this race
586      * condition is to first reduce the spender's allowance to 0 and set the
587      * desired value afterwards:
588      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
589      *
590      * Emits an {Approval} event.
591      */
592     function approve(address spender, uint256 amount) external returns (bool);
593 
594     /**
595      * @dev Moves `amount` tokens from `sender` to `recipient` using the
596      * allowance mechanism. `amount` is then deducted from the caller's
597      * allowance.
598      *
599      * Returns a boolean value indicating whether the operation succeeded.
600      *
601      * Emits a {Transfer} event.
602      */
603     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
604 
605     /**
606      * @dev Emitted when `value` tokens are moved from one account (`from`) to
607      * another (`to`).
608      *
609      * Note that `value` may be zero.
610      */
611     event Transfer(address indexed from, address indexed to, uint256 value);
612 
613     /**
614      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
615      * a call to {approve}. `value` is the new allowance.
616      */
617     event Approval(address indexed owner, address indexed spender, uint256 value);
618 }
619 
620 interface IUniswapV2Factory {
621     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
622     function feeTo() external view returns (address);
623     function feeToSetter() external view returns (address);
624     function getPair(address tokenA, address tokenB) external view returns (address pair);
625     function allPairs(uint) external view returns (address pair);
626     function allPairsLength() external view returns (uint);
627     function createPair(address tokenA, address tokenB) external returns (address pair);
628     function setFeeTo(address) external;
629     function setFeeToSetter(address) external;
630 }
631 
632 interface IUniswapV2Pair {
633     event Approval(address indexed owner, address indexed spender, uint value);
634     event Transfer(address indexed from, address indexed to, uint value);
635     function name() external pure returns (string memory);
636     function symbol() external pure returns (string memory);
637     function decimals() external pure returns (uint8);
638     function totalSupply() external view returns (uint);
639     function balanceOf(address owner) external view returns (uint);
640     function allowance(address owner, address spender) external view returns (uint);
641     function approve(address spender, uint value) external returns (bool);
642     function transfer(address to, uint value) external returns (bool);
643     function transferFrom(address from, address to, uint value) external returns (bool);
644     function DOMAIN_SEPARATOR() external view returns (bytes32);
645     function PERMIT_TYPEHASH() external pure returns (bytes32);
646     function nonces(address owner) external view returns (uint);
647     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
648     event Mint(address indexed sender, uint amount0, uint amount1);
649     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
650     event Swap(
651         address indexed sender,
652         uint amount0In,
653         uint amount1In,
654         uint amount0Out,
655         uint amount1Out,
656         address indexed to
657     );
658     event Sync(uint112 reserve0, uint112 reserve1);
659     function MINIMUM_LIQUIDITY() external pure returns (uint);
660     function factory() external view returns (address);
661     function token0() external view returns (address);
662     function token1() external view returns (address);
663     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
664     function price0CumulativeLast() external view returns (uint);
665     function price1CumulativeLast() external view returns (uint);
666     function kLast() external view returns (uint);
667     function mint(address to) external returns (uint liquidity);
668     function burn(address to) external returns (uint amount0, uint amount1);
669     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
670     function skim(address to) external;
671     function sync() external;
672     function initialize(address, address) external;
673 }
674 
675 interface IUniswapV2Router01 {
676     function factory() external pure returns (address);
677     function WETH() external pure returns (address);
678     function addLiquidity(
679         address tokenA,
680         address tokenB,
681         uint amountADesired,
682         uint amountBDesired,
683         uint amountAMin,
684         uint amountBMin,
685         address to,
686         uint deadline
687     ) external returns (uint amountA, uint amountB, uint liquidity);
688     function addLiquidityETH(
689         address token,
690         uint amountTokenDesired,
691         uint amountTokenMin,
692         uint amountETHMin,
693         address to,
694         uint deadline
695     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
696     function removeLiquidity(
697         address tokenA,
698         address tokenB,
699         uint liquidity,
700         uint amountAMin,
701         uint amountBMin,
702         address to,
703         uint deadline
704     ) external returns (uint amountA, uint amountB);
705     function removeLiquidityETH(
706         address token,
707         uint liquidity,
708         uint amountTokenMin,
709         uint amountETHMin,
710         address to,
711         uint deadline
712     ) external returns (uint amountToken, uint amountETH);
713     function removeLiquidityWithPermit(
714         address tokenA,
715         address tokenB,
716         uint liquidity,
717         uint amountAMin,
718         uint amountBMin,
719         address to,
720         uint deadline,
721         bool approveMax, uint8 v, bytes32 r, bytes32 s
722     ) external returns (uint amountA, uint amountB);
723     function removeLiquidityETHWithPermit(
724         address token,
725         uint liquidity,
726         uint amountTokenMin,
727         uint amountETHMin,
728         address to,
729         uint deadline,
730         bool approveMax, uint8 v, bytes32 r, bytes32 s
731     ) external returns (uint amountToken, uint amountETH);
732     function swapExactTokensForTokens(
733         uint amountIn,
734         uint amountOutMin,
735         address[] calldata path,
736         address to,
737         uint deadline
738     ) external returns (uint[] memory amounts);
739     function swapTokensForExactTokens(
740         uint amountOut,
741         uint amountInMax,
742         address[] calldata path,
743         address to,
744         uint deadline
745     ) external returns (uint[] memory amounts);
746     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
747         external
748         payable
749         returns (uint[] memory amounts);
750     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
751         external
752         returns (uint[] memory amounts);
753     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
754         external
755         returns (uint[] memory amounts);
756     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
757         external
758         payable
759         returns (uint[] memory amounts);
760     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
761     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
762     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
763     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
764     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
765 }
766 
767 interface IUniswapV2Router02 is IUniswapV2Router01 {
768     function removeLiquidityETHSupportingFeeOnTransferTokens(
769         address token,
770         uint liquidity,
771         uint amountTokenMin,
772         uint amountETHMin,
773         address to,
774         uint deadline
775     ) external returns (uint amountETH);
776     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
777         address token,
778         uint liquidity,
779         uint amountTokenMin,
780         uint amountETHMin,
781         address to,
782         uint deadline,
783         bool approveMax, uint8 v, bytes32 r, bytes32 s
784     ) external returns (uint amountETH);
785     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
786         uint amountIn,
787         uint amountOutMin,
788         address[] calldata path,
789         address to,
790         uint deadline
791     ) external;
792     function swapExactETHForTokensSupportingFeeOnTransferTokens(
793         uint amountOutMin,
794         address[] calldata path,
795         address to,
796         uint deadline
797     ) external payable;
798     function swapExactTokensForETHSupportingFeeOnTransferTokens(
799         uint amountIn,
800         uint amountOutMin,
801         address[] calldata path,
802         address to,
803         uint deadline
804     ) external;
805 }
806 
807 contract ChowInu is Context, IERC20, Ownable {
808     using SafeMath for uint256;
809     using Address for address;
810 
811     IFTPAntiBot private antiBot;
812     bool public antibotEnabled = false;
813     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
814     // could be subject to a maximum transfer amount
815     mapping (address => bool) public automatedMarketMakerPairs;
816 
817     mapping (address => uint256) private _rOwned;
818     mapping (address => uint256) private _tOwned;
819     mapping (address => mapping (address => uint256)) private _allowances;
820 
821     mapping (address => bool) private _isExcludedFromFee;
822 
823     mapping (address => bool) private _isExcluded;
824     address[] private _excluded;
825     mapping (address => bool) private _isBlackListedBot;
826     address[] private _blackListedBots;
827 
828     uint256 private constant MAX = ~uint256(0);
829     uint256 private _tTotal = 1000000000000 * 10**18;
830     uint256 private _rTotal = (MAX - (MAX % _tTotal));
831     uint256 private _tFeeTotal;
832 
833     string private _name = "Chow Inu";
834     string private _symbol = "CHOW";
835     uint256 private _decimals = 18;
836 
837     uint256 public _taxFee = 2;
838     uint256 private _previousTaxFee = _taxFee;
839     
840     uint256 public _liquidityFee = 11;
841     uint256 private _previousLiquidityFee = _liquidityFee;
842 
843     uint256 public _marketingFee = 9;
844     uint256 private _previousMarketingFee = _marketingFee;
845 
846     address payable public _marketingWalletAddress1;
847     address payable public _marketingWalletAddress2;
848     address payable public _marketingWalletAddress3;
849     address payable public _marketingWalletAddress4;
850 
851     IUniswapV2Router02 public immutable uniswapV2Router;
852     address public immutable uniswapV2Pair;
853 
854     bool inSwapAndLiquify = false;
855     bool public swapAndLiquifyEnabled = true;
856     
857     uint256 public _maxTxAmount = 5000000000 * 10**18;
858     uint256 public numTokensSellToAddToLiquidity = 5000000 * 10**18;
859     uint256 public _maxWalletSize = 9500000000 * 10**18;
860 
861     event botAddedToBlacklist(address account);
862     event botRemovedFromBlacklist(address account);
863 
864     event SwapAndLiquifyEnabledUpdated(bool enabled);
865     event SwapAndLiquify(
866         uint256 tokensSwapped,
867         uint256 ethReceived,
868         uint256 tokensIntoLiqudity
869     );
870     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
871 
872     modifier lockTheSwap {
873         inSwapAndLiquify = true;
874         _;
875         inSwapAndLiquify = false;
876     }
877 
878     constructor(address routerAddress, address tokenOwner, address payable marketingWalletAddress1, address payable marketingWalletAddress2, address payable marketingWalletAddress3, address payable marketingWalletAddress4) {
879         IFTPAntiBot _antiBot = IFTPAntiBot(0x590C2B20f7920A2D21eD32A21B616906b4209A43);
880         antiBot = _antiBot;
881 
882         _marketingWalletAddress1 = marketingWalletAddress1;
883         _marketingWalletAddress2 = marketingWalletAddress2;
884         _marketingWalletAddress3 = marketingWalletAddress3;
885         _marketingWalletAddress4 = marketingWalletAddress4;
886 
887         _rOwned[tokenOwner] = _rTotal;
888 
889         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerAddress);
890          // Create a uniswap pair for this new token
891         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
892             .createPair(address(this), _uniswapV2Router.WETH());
893         uniswapV2Pair = _uniswapV2Pair;
894         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
895 
896         // set the rest of the contract variables
897         uniswapV2Router = _uniswapV2Router;
898 
899         // exclude owner and this contract from fee
900         _isExcludedFromFee[tokenOwner] = true;
901         _isExcludedFromFee[address(this)] = true;
902 
903         _owner = tokenOwner;
904         emit Transfer(address(0), tokenOwner, _tTotal);
905     }
906 
907     function name() public view returns (string memory) {
908         return _name;
909     }
910 
911     function symbol() public view returns (string memory) {
912         return _symbol;
913     }
914 
915     function decimals() public view returns (uint256) {
916         return _decimals;
917     }
918 
919     function totalSupply() public view override returns (uint256) {
920         return _tTotal;
921     }
922 
923     function balanceOf(address account) public view override returns (uint256) {
924         if (_isExcluded[account]) return _tOwned[account];
925         return tokenFromReflection(_rOwned[account]);
926     }
927 
928     function transfer(address recipient, uint256 amount) public override returns (bool) {
929         _transfer(_msgSender(), recipient, amount);
930         return true;
931     }
932 
933     function allowance(address owner, address spender) public view override returns (uint256) {
934         return _allowances[owner][spender];
935     }
936 
937     function approve(address spender, uint256 amount) public override returns (bool) {
938         _approve(_msgSender(), spender, amount);
939         return true;
940     }
941 
942     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
943         _transfer(sender, recipient, amount);
944         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
945         return true;
946     }
947 
948     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
949         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
950         return true;
951     }
952 
953     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
954         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
955         return true;
956     }
957 
958     function isExcludedFromReward(address account) public view returns (bool) {
959         return _isExcluded[account];
960     }
961 
962     function totalFees() public view returns (uint256) {
963         return _tFeeTotal;
964     }
965 
966     function deliver(uint256 tAmount) public {
967         address sender = _msgSender();
968         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
969         (uint256 rAmount,,,,,) = _getValues(tAmount);
970         _rOwned[sender] = _rOwned[sender].sub(rAmount);
971         _rTotal = _rTotal.sub(rAmount);
972         _tFeeTotal = _tFeeTotal.add(tAmount);
973     }
974 
975     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
976         require(tAmount <= _tTotal, "Amount must be less than supply");
977         if (!deductTransferFee) {
978             (uint256 rAmount,,,,,) = _getValues(tAmount);
979             return rAmount;
980         } else {
981             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
982             return rTransferAmount;
983         }
984     }
985 
986     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
987         require(rAmount <= _rTotal, "Amount must be less than total reflections");
988         uint256 currentRate =  _getRate();
989         return rAmount.div(currentRate);
990     }
991 
992     function addBotToBlacklist (address account) external onlyOwner() {
993         require(account != address(uniswapV2Router), 'We cannot blacklist UniSwap router');
994         require (!_isBlackListedBot[account], 'Account is already blacklisted');
995         _isBlackListedBot[account] = true;
996         _blackListedBots.push(account);
997         emit botAddedToBlacklist(account);
998     }
999 
1000     function removeBotFromBlacklist(address account) external onlyOwner() {
1001         require (_isBlackListedBot[account], 'Account is not blacklisted');
1002         for (uint256 i = 0; i < _blackListedBots.length; i++) {
1003             if (_blackListedBots[i] == account) {
1004                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
1005                 _isBlackListedBot[account] = false;
1006                 _blackListedBots.pop();
1007                 emit botRemovedFromBlacklist(account);
1008                 break;
1009             }
1010         }
1011     }
1012 
1013     function excludeFromReward(address account) public onlyOwner() {
1014         // require(account != address(uniswapV2Router), 'We can not exclude Uniswap router.');
1015         require(!_isExcluded[account], "Account is already excluded");
1016         if(_rOwned[account] > 0) {
1017             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1018         }
1019         _isExcluded[account] = true;
1020         _excluded.push(account);
1021     }
1022 
1023     function includeInReward(address account) external onlyOwner() {
1024         require(_isExcluded[account], "Account is not excluded");
1025         for (uint256 i = 0; i < _excluded.length; i++) {
1026             if (_excluded[i] == account) {
1027                 _excluded[i] = _excluded[_excluded.length - 1];
1028                 _tOwned[account] = 0;
1029                 _isExcluded[account] = false;
1030                 _excluded.pop();
1031                 break;
1032             }
1033         }
1034     }
1035 
1036     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1037         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1038         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1039         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1040         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1041         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1042         _takeLiquidity(tLiquidity);
1043         _reflectFee(rFee, tFee);
1044         emit Transfer(sender, recipient, tTransferAmount);
1045     }
1046     
1047     function excludeFromFee(address account) public onlyOwner {
1048         _isExcludedFromFee[account] = true;
1049     }
1050     
1051     function includeInFee(address account) public onlyOwner {
1052         _isExcludedFromFee[account] = false;
1053     }
1054     
1055     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1056         _taxFee = taxFee;
1057     }
1058 
1059     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1060         _liquidityFee = liquidityFee;
1061     }
1062 
1063     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner() {
1064         require(marketingFee <= _liquidityFee, 'marketingFee should be less than liquidityFee');
1065         _marketingFee = marketingFee;
1066     }
1067 
1068     function setMarketingWalletAddresses(address payable marketing1, address payable marketing2, address payable marketing3)
1069     external onlyOwner() {
1070         _marketingWalletAddress1 = marketing1;
1071         _marketingWalletAddress2 = marketing2;
1072         _marketingWalletAddress3 = marketing3;
1073     }
1074 
1075     function setNumTokensSellToAddToLiquidity(uint256 swapNumber) public onlyOwner {
1076         numTokensSellToAddToLiquidity = swapNumber * 10 ** _decimals;
1077     }
1078 
1079     function setMaxTxPercent(uint256 maxTxPercent) public onlyOwner {
1080         _maxTxAmount = maxTxPercent  * 10 ** _decimals;
1081     }
1082 
1083     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1084         swapAndLiquifyEnabled = _enabled;
1085         emit SwapAndLiquifyEnabledUpdated(_enabled);
1086     }
1087 
1088     function _setMaxWalletSize (uint256 maxWalletSize) external onlyOwner() {
1089         _maxWalletSize = maxWalletSize;
1090     }
1091 
1092     function assignAntiBot(address _address) external onlyOwner() {
1093         IFTPAntiBot _antiBot = IFTPAntiBot(_address);
1094         antiBot = _antiBot;
1095     }
1096 
1097     function toggleAntiBot() external onlyOwner() {
1098         if(antibotEnabled){
1099             antibotEnabled = false;
1100         }
1101         else{
1102             antibotEnabled = true;
1103         }
1104     }
1105 
1106     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1107         require(pair != uniswapV2Pair, "The UniSwap pair cannot be removed from automatedMarketMakerPairs");
1108 
1109         _setAutomatedMarketMakerPair(pair, value);
1110     }
1111 
1112     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1113         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
1114         automatedMarketMakerPairs[pair] = value;
1115 
1116         emit SetAutomatedMarketMakerPair(pair, value);
1117     }
1118 
1119     function distribute(address[] calldata recipients, uint256[] calldata amounts) public onlyOwner {
1120         require(recipients.length == amounts.length, "Incorrect parameter");
1121 
1122         for (uint256 index = 0; index < recipients.length; index++) {
1123             uint256 amount = amounts[index];
1124             _transfer(owner(), recipients[index], amount);
1125             _approve(owner(), address(this), _allowances[owner()][address(this)].sub(amount, "ERC20: transfer amount exceeds allowance"));
1126         }
1127     }
1128 
1129     //to recieve ETH from uniswapV2Router when swaping
1130     receive() external payable {}
1131 
1132     function _reflectFee(uint256 rFee, uint256 tFee) private {
1133         _rTotal = _rTotal.sub(rFee);
1134         _tFeeTotal = _tFeeTotal.add(tFee);
1135     }
1136 
1137     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1138         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1139         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1140         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1141     }
1142 
1143     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1144         uint256 tFee = calculateTaxFee(tAmount);
1145         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1146         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1147         return (tTransferAmount, tFee, tLiquidity);
1148     }
1149 
1150     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1151         uint256 rAmount = tAmount.mul(currentRate);
1152         uint256 rFee = tFee.mul(currentRate);
1153         uint256 rLiquidity = tLiquidity.mul(currentRate);
1154         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1155         return (rAmount, rTransferAmount, rFee);
1156     }
1157 
1158     function _getRate() private view returns(uint256) {
1159         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1160         return rSupply.div(tSupply);
1161     }
1162 
1163     function _getCurrentSupply() private view returns(uint256, uint256) {
1164         uint256 rSupply = _rTotal;
1165         uint256 tSupply = _tTotal;      
1166         for (uint256 i = 0; i < _excluded.length; i++) {
1167             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1168             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1169             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1170         }
1171         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1172         return (rSupply, tSupply);
1173     }
1174 
1175     function _getETHBalance() public view returns(uint256 balance) {
1176         return address(this).balance;
1177     }
1178 
1179     function _takeLiquidity(uint256 tLiquidity) private {
1180         uint256 currentRate =  _getRate();
1181         uint256 rLiquidity = tLiquidity.mul(currentRate);
1182         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1183         if(_isExcluded[address(this)])
1184             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1185     }
1186 
1187     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1188         return _amount.mul(_taxFee).div(
1189             10**2
1190         );
1191     }
1192 
1193     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1194         return _amount.mul(_liquidityFee).div(
1195             10**2
1196         );
1197     }
1198 
1199     function removeAllFee() private {
1200         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0) return;
1201         
1202         _previousTaxFee = _taxFee;
1203         _previousLiquidityFee = _liquidityFee;
1204         _previousMarketingFee = _marketingFee;
1205         
1206         _taxFee = 0;
1207         _liquidityFee = 0;
1208         _marketingFee = 0;
1209     }
1210 
1211     function restoreAllFee() private {
1212         _taxFee = _previousTaxFee;
1213         _liquidityFee = _previousLiquidityFee;
1214         _marketingFee = _previousMarketingFee;
1215     }
1216     
1217     function isExcludedFromFee(address account) public view returns(bool) {
1218         return _isExcludedFromFee[account];
1219     }
1220 
1221     function _approve(address owner, address spender, uint256 amount) private {
1222         require(owner != address(0), "ERC20: approve from the zero address");
1223         require(spender != address(0), "ERC20: approve to the zero address");
1224 
1225         _allowances[owner][spender] = amount;
1226         emit Approval(owner, spender, amount);
1227     }
1228 
1229     function _transfer(
1230         address from,
1231         address to,
1232         uint256 amount
1233     ) private {
1234         require(from != address(0), "ERC20: transfer from the zero address");
1235         require(to != address(0), "ERC20: transfer to the zero address");
1236         require(amount > 0, "Transfer amount must be greater than zero");
1237         require(!_isBlackListedBot[from], "You are blacklisted");
1238         require(!_isBlackListedBot[msg.sender], "You are blacklisted");
1239         require(!_isBlackListedBot[tx.origin], "You are blacklisted");
1240         if(antibotEnabled) {
1241             if(automatedMarketMakerPairs[from]){
1242                 require(!antiBot.scanAddress(to, from, tx.origin), "Beep Beep Boop, You're a piece of poop");
1243             }
1244             if(automatedMarketMakerPairs[to]){
1245                 require(!antiBot.scanAddress(from, to, tx.origin), "Beep Beep Boop, You're a piece of poop");
1246             }
1247         }
1248 
1249         if(from != owner() && to != owner())
1250             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1251         if(from != owner() && to != owner() && to != uniswapV2Pair && to != address(0xdead)) {
1252             uint256 tokenBalanceRecipient = balanceOf(to);
1253             require(tokenBalanceRecipient + amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
1254         }
1255 
1256         // is the token balance of this contract address over the min number of
1257         // tokens that we need to initiate a swap + liquidity lock?
1258         // also, don't get caught in a circular liquidity event.
1259         // also, don't swap & liquify if sender is uniswap pair.
1260         uint256 contractTokenBalance = balanceOf(address(this));
1261 
1262         if(contractTokenBalance >= _maxTxAmount)
1263         {
1264             contractTokenBalance = _maxTxAmount;
1265         }
1266         
1267         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1268         if (
1269             overMinTokenBalance &&
1270             !inSwapAndLiquify &&
1271             swapAndLiquifyEnabled &&
1272             !automatedMarketMakerPairs[from] &&
1273             !_isExcludedFromFee[from] &&
1274             !_isExcludedFromFee[to]
1275         ) {
1276             contractTokenBalance = numTokensSellToAddToLiquidity;
1277             // add liquidity
1278             swapAndLiquify(contractTokenBalance);
1279         }
1280 
1281         //indicates if fee should be deducted from transfer
1282         bool takeFee = true;
1283 
1284         //if any account belongs to _isExcludedFromFee account then remove the fee
1285         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1286             takeFee = false;
1287         }
1288 
1289         //transfer amount, it will take tax, burn, liquidity fee
1290         _tokenTransfer(from,to,amount,takeFee);
1291 
1292         if(antibotEnabled) {
1293             try antiBot.registerBlock(from, to) {} catch {}
1294         }
1295     }
1296 
1297     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1298         // split the contract balance into halves
1299         uint256 swapHalf = contractTokenBalance.mul(_marketingFee).div(_liquidityFee);
1300         uint256 liquifyHalf = contractTokenBalance.sub(swapHalf);
1301 
1302         // capture the contract's current ETH balance.
1303         // this is so that we can capture exactly the amount of ETH that the
1304         // swap creates, and not make the liquidity event include any ETH that
1305         // has been manually sent to the contract
1306         uint256 initialBalance = address(this).balance;
1307 
1308         // swap tokens for ETH
1309         swapTokensForEth(swapHalf); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1310 
1311         // how much ETH did we just swap into?
1312         uint256 newBalance = address(this).balance.sub(initialBalance);
1313         uint256 marketingBalance = newBalance.mul(_marketingFee).div(_liquidityFee);
1314         uint256 liquidityBalance = newBalance.sub(marketingBalance);
1315 
1316         // add liquidity to uniswap
1317         addLiquidity(liquifyHalf, liquidityBalance);
1318         sendETHToTreasury(marketingBalance);
1319 
1320         emit SwapAndLiquify(contractTokenBalance, newBalance, liquifyHalf);
1321     }
1322 
1323     function manualSwapAndLiquify() external onlyOwner() lockTheSwap {
1324         uint256 contractBalance = balanceOf(address(this));
1325         uint256 swapHalf = contractBalance.mul(_marketingFee).div(_liquidityFee);
1326         uint256 liquifyHalf = contractBalance.sub(swapHalf);
1327 
1328         uint256 initialBalance = address(this).balance;
1329 
1330         // swap tokens for ETH
1331         swapTokensForEth(swapHalf); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1332 
1333         // how much ETH did we just swap into?
1334         uint256 newBalance = address(this).balance.sub(initialBalance);
1335         uint256 marketingBalance = newBalance.mul(_marketingFee).div(_liquidityFee);
1336         uint256 liquidityBalance = newBalance.sub(marketingBalance);
1337 
1338         // add liquidity to uniswap
1339         addLiquidity(liquifyHalf, liquidityBalance);
1340         sendETHToTreasury(marketingBalance);
1341 
1342         emit SwapAndLiquify(contractBalance, newBalance, liquifyHalf);
1343     }
1344 
1345     function manualClaim() external onlyOwner() lockTheSwap {
1346         sendETHToTreasury(address(this).balance);
1347     }
1348 
1349     function sendETHToTreasury(uint256 amount) private {
1350         _marketingWalletAddress1.transfer(amount.mul(5).div(9));
1351         _marketingWalletAddress2.transfer(amount.mul(3).div(18));
1352         _marketingWalletAddress3.transfer(amount.mul(3).div(18));
1353         _marketingWalletAddress4.transfer(amount.div(9));
1354     }
1355 
1356     function swapTokensForEth(uint256 tokenAmount) private {
1357         // generate the uniswap pair path of token -> weth
1358         address[] memory path = new address[](2);
1359         path[0] = address(this);
1360         path[1] = uniswapV2Router.WETH();
1361 
1362         _approve(address(this), address(uniswapV2Router), tokenAmount);
1363 
1364         // make the swap
1365         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1366             tokenAmount,
1367             0, // accept any amount of ETH
1368             path,
1369             address(this),
1370             block.timestamp
1371         );
1372     }
1373 
1374     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1375         // approve token transfer to cover all possible scenarios
1376         _approve(address(this), address(uniswapV2Router), tokenAmount);
1377 
1378         // add the liquidity
1379         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1380             address(this),
1381             tokenAmount,
1382             0, // slippage is unavoidable
1383             0, // slippage is unavoidable
1384             owner(),
1385             block.timestamp
1386         );
1387     }
1388 
1389     //this method is responsible for taking all fee, if takeFee is true
1390     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1391         if(!takeFee)
1392             removeAllFee();
1393         
1394         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1395             _transferFromExcluded(sender, recipient, amount);
1396         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1397             _transferToExcluded(sender, recipient, amount);
1398         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1399             _transferStandard(sender, recipient, amount);
1400         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1401             _transferBothExcluded(sender, recipient, amount);
1402         } else {
1403             _transferStandard(sender, recipient, amount);
1404         }
1405 
1406         if(!takeFee)
1407             restoreAllFee();
1408     }
1409 
1410     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1411         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1412         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1413         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1414         _takeLiquidity(tLiquidity);
1415         _reflectFee(rFee, tFee);
1416         emit Transfer(sender, recipient, tTransferAmount);
1417     }
1418 
1419     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1420         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1421         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1422         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1423         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1424         _takeLiquidity(tLiquidity);
1425         _reflectFee(rFee, tFee);
1426         emit Transfer(sender, recipient, tTransferAmount);
1427     }
1428 
1429     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1430         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1431         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1432         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1433         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1434         _takeLiquidity(tLiquidity);
1435         _reflectFee(rFee, tFee);
1436         emit Transfer(sender, recipient, tTransferAmount);
1437     }
1438 }