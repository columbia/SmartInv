1 // SPDX-License-Identifier: BUSL-1.1
2 
3 pragma solidity 0.8.6;
4 
5 
6 
7 // Part: BetaRunnerWithCallback
8 
9 contract BetaRunnerWithCallback {
10   address private constant NO_CALLER = address(42); // nonzero so we don't repeatedly clear storage
11   address private caller = NO_CALLER;
12 
13   modifier withCallback() {
14     require(caller == NO_CALLER);
15     caller = msg.sender;
16     _;
17     caller = NO_CALLER;
18   }
19 
20   modifier isCallback() {
21     require(caller == tx.origin);
22     _;
23   }
24 }
25 
26 // Part: IBetaBank
27 
28 interface IBetaBank {
29   /// @dev Returns the address of BToken of the given underlying token, or 0 if not exists.
30   function bTokens(address _underlying) external view returns (address);
31 
32   /// @dev Returns the address of the underlying of the given BToken, or 0 if not exists.
33   function underlyings(address _bToken) external view returns (address);
34 
35   /// @dev Returns the address of the oracle contract.
36   function oracle() external view returns (address);
37 
38   /// @dev Returns the address of the config contract.
39   function config() external view returns (address);
40 
41   /// @dev Returns the interest rate model smart contract.
42   function interestModel() external view returns (address);
43 
44   /// @dev Returns the position's collateral token and AmToken.
45   function getPositionTokens(address _owner, uint _pid)
46     external
47     view
48     returns (address _collateral, address _bToken);
49 
50   /// @dev Returns the debt of the given position. Can't be view as it needs to call accrue.
51   function fetchPositionDebt(address _owner, uint _pid) external returns (uint);
52 
53   /// @dev Returns the LTV of the given position. Can't be view as it needs to call accrue.
54   function fetchPositionLTV(address _owner, uint _pid) external returns (uint);
55 
56   /// @dev Opens a new position in the Beta smart contract.
57   function open(
58     address _owner,
59     address _underlying,
60     address _collateral
61   ) external returns (uint pid);
62 
63   /// @dev Borrows tokens on the given position.
64   function borrow(
65     address _owner,
66     uint _pid,
67     uint _amount
68   ) external;
69 
70   /// @dev Repays tokens on the given position.
71   function repay(
72     address _owner,
73     uint _pid,
74     uint _amount
75   ) external;
76 
77   /// @dev Puts more collateral to the given position.
78   function put(
79     address _owner,
80     uint _pid,
81     uint _amount
82   ) external;
83 
84   /// @dev Takes some collateral out of the position.
85   function take(
86     address _owner,
87     uint _pid,
88     uint _amount
89   ) external;
90 
91   /// @dev Liquidates the given position.
92   function liquidate(
93     address _owner,
94     uint _pid,
95     uint _amount
96   ) external;
97 }
98 
99 // Part: IPancakeCallee
100 
101 interface IPancakeCallee {
102   function pancakeCall(
103     address sender,
104     uint amount0,
105     uint amount1,
106     bytes calldata data
107   ) external;
108 }
109 
110 // Part: IUniswapV2Callee
111 
112 interface IUniswapV2Callee {
113   function uniswapV2Call(
114     address sender,
115     uint amount0,
116     uint amount1,
117     bytes calldata data
118   ) external;
119 }
120 
121 // Part: IUniswapV2Pair
122 
123 interface IUniswapV2Pair {
124   function getReserves()
125     external
126     view
127     returns (
128       uint112 reserve0,
129       uint112 reserve1,
130       uint32 blockTimestampLast
131     );
132 
133   function price0CumulativeLast() external view returns (uint);
134 
135   function price1CumulativeLast() external view returns (uint);
136 
137   function swap(
138     uint amount0Out,
139     uint amount1Out,
140     address to,
141     bytes calldata data
142   ) external;
143 }
144 
145 // Part: IWETH
146 
147 interface IWETH {
148   function deposit() external payable;
149 
150   function withdraw(uint wad) external;
151 
152   function approve(address guy, uint wad) external returns (bool);
153 }
154 
155 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Address
156 
157 /**
158  * @dev Collection of functions related to the address type
159  */
160 library Address {
161     /**
162      * @dev Returns true if `account` is a contract.
163      *
164      * [IMPORTANT]
165      * ====
166      * It is unsafe to assume that an address for which this function returns
167      * false is an externally-owned account (EOA) and not a contract.
168      *
169      * Among others, `isContract` will return false for the following
170      * types of addresses:
171      *
172      *  - an externally-owned account
173      *  - a contract in construction
174      *  - an address where a contract will be created
175      *  - an address where a contract lived, but was destroyed
176      * ====
177      */
178     function isContract(address account) internal view returns (bool) {
179         // This method relies on extcodesize, which returns 0 for contracts in
180         // construction, since the code is only stored at the end of the
181         // constructor execution.
182 
183         uint256 size;
184         assembly {
185             size := extcodesize(account)
186         }
187         return size > 0;
188     }
189 
190     /**
191      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
192      * `recipient`, forwarding all available gas and reverting on errors.
193      *
194      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
195      * of certain opcodes, possibly making contracts go over the 2300 gas limit
196      * imposed by `transfer`, making them unable to receive funds via
197      * `transfer`. {sendValue} removes this limitation.
198      *
199      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
200      *
201      * IMPORTANT: because control is transferred to `recipient`, care must be
202      * taken to not create reentrancy vulnerabilities. Consider using
203      * {ReentrancyGuard} or the
204      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
205      */
206     function sendValue(address payable recipient, uint256 amount) internal {
207         require(address(this).balance >= amount, "Address: insufficient balance");
208 
209         (bool success, ) = recipient.call{value: amount}("");
210         require(success, "Address: unable to send value, recipient may have reverted");
211     }
212 
213     /**
214      * @dev Performs a Solidity function call using a low level `call`. A
215      * plain `call` is an unsafe replacement for a function call: use this
216      * function instead.
217      *
218      * If `target` reverts with a revert reason, it is bubbled up by this
219      * function (like regular Solidity function calls).
220      *
221      * Returns the raw returned data. To convert to the expected return value,
222      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
223      *
224      * Requirements:
225      *
226      * - `target` must be a contract.
227      * - calling `target` with `data` must not revert.
228      *
229      * _Available since v3.1._
230      */
231     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
232         return functionCall(target, data, "Address: low-level call failed");
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
237      * `errorMessage` as a fallback revert reason when `target` reverts.
238      *
239      * _Available since v3.1._
240      */
241     function functionCall(
242         address target,
243         bytes memory data,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         return functionCallWithValue(target, data, 0, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but also transferring `value` wei to `target`.
252      *
253      * Requirements:
254      *
255      * - the calling contract must have an ETH balance of at least `value`.
256      * - the called Solidity function must be `payable`.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(
261         address target,
262         bytes memory data,
263         uint256 value
264     ) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
270      * with `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCallWithValue(
275         address target,
276         bytes memory data,
277         uint256 value,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         require(address(this).balance >= value, "Address: insufficient balance for call");
281         require(isContract(target), "Address: call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.call{value: value}(data);
284         return _verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but performing a static call.
290      *
291      * _Available since v3.3._
292      */
293     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
294         return functionStaticCall(target, data, "Address: low-level static call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
299      * but performing a static call.
300      *
301      * _Available since v3.3._
302      */
303     function functionStaticCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal view returns (bytes memory) {
308         require(isContract(target), "Address: static call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.staticcall(data);
311         return _verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a delegate call.
317      *
318      * _Available since v3.4._
319      */
320     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a delegate call.
327      *
328      * _Available since v3.4._
329      */
330     function functionDelegateCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         require(isContract(target), "Address: delegate call to non-contract");
336 
337         (bool success, bytes memory returndata) = target.delegatecall(data);
338         return _verifyCallResult(success, returndata, errorMessage);
339     }
340 
341     function _verifyCallResult(
342         bool success,
343         bytes memory returndata,
344         string memory errorMessage
345     ) private pure returns (bytes memory) {
346         if (success) {
347             return returndata;
348         } else {
349             // Look for revert reason and bubble it up if present
350             if (returndata.length > 0) {
351                 // The easiest way to bubble the revert reason is using memory via assembly
352 
353                 assembly {
354                     let returndata_size := mload(returndata)
355                     revert(add(32, returndata), returndata_size)
356                 }
357             } else {
358                 revert(errorMessage);
359             }
360         }
361     }
362 }
363 
364 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Context
365 
366 /*
367  * @dev Provides information about the current execution context, including the
368  * sender of the transaction and its data. While these are generally available
369  * via msg.sender and msg.data, they should not be accessed in such a direct
370  * manner, since when dealing with meta-transactions the account sending and
371  * paying for execution may not be the actual sender (as far as an application
372  * is concerned).
373  *
374  * This contract is only required for intermediate, library-like contracts.
375  */
376 abstract contract Context {
377     function _msgSender() internal view virtual returns (address) {
378         return msg.sender;
379     }
380 
381     function _msgData() internal view virtual returns (bytes calldata) {
382         return msg.data;
383     }
384 }
385 
386 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/IERC20
387 
388 /**
389  * @dev Interface of the ERC20 standard as defined in the EIP.
390  */
391 interface IERC20 {
392     /**
393      * @dev Returns the amount of tokens in existence.
394      */
395     function totalSupply() external view returns (uint256);
396 
397     /**
398      * @dev Returns the amount of tokens owned by `account`.
399      */
400     function balanceOf(address account) external view returns (uint256);
401 
402     /**
403      * @dev Moves `amount` tokens from the caller's account to `recipient`.
404      *
405      * Returns a boolean value indicating whether the operation succeeded.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transfer(address recipient, uint256 amount) external returns (bool);
410 
411     /**
412      * @dev Returns the remaining number of tokens that `spender` will be
413      * allowed to spend on behalf of `owner` through {transferFrom}. This is
414      * zero by default.
415      *
416      * This value changes when {approve} or {transferFrom} are called.
417      */
418     function allowance(address owner, address spender) external view returns (uint256);
419 
420     /**
421      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
422      *
423      * Returns a boolean value indicating whether the operation succeeded.
424      *
425      * IMPORTANT: Beware that changing an allowance with this method brings the risk
426      * that someone may use both the old and the new allowance by unfortunate
427      * transaction ordering. One possible solution to mitigate this race
428      * condition is to first reduce the spender's allowance to 0 and set the
429      * desired value afterwards:
430      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
431      *
432      * Emits an {Approval} event.
433      */
434     function approve(address spender, uint256 amount) external returns (bool);
435 
436     /**
437      * @dev Moves `amount` tokens from `sender` to `recipient` using the
438      * allowance mechanism. `amount` is then deducted from the caller's
439      * allowance.
440      *
441      * Returns a boolean value indicating whether the operation succeeded.
442      *
443      * Emits a {Transfer} event.
444      */
445     function transferFrom(
446         address sender,
447         address recipient,
448         uint256 amount
449     ) external returns (bool);
450 
451     /**
452      * @dev Emitted when `value` tokens are moved from one account (`from`) to
453      * another (`to`).
454      *
455      * Note that `value` may be zero.
456      */
457     event Transfer(address indexed from, address indexed to, uint256 value);
458 
459     /**
460      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
461      * a call to {approve}. `value` is the new allowance.
462      */
463     event Approval(address indexed owner, address indexed spender, uint256 value);
464 }
465 
466 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Math
467 
468 /**
469  * @dev Standard math utilities missing in the Solidity language.
470  */
471 library Math {
472     /**
473      * @dev Returns the largest of two numbers.
474      */
475     function max(uint256 a, uint256 b) internal pure returns (uint256) {
476         return a >= b ? a : b;
477     }
478 
479     /**
480      * @dev Returns the smallest of two numbers.
481      */
482     function min(uint256 a, uint256 b) internal pure returns (uint256) {
483         return a < b ? a : b;
484     }
485 
486     /**
487      * @dev Returns the average of two numbers. The result is rounded towards
488      * zero.
489      */
490     function average(uint256 a, uint256 b) internal pure returns (uint256) {
491         // (a + b) / 2 can overflow, so we distribute.
492         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
493     }
494 
495     /**
496      * @dev Returns the ceiling of the division of two numbers.
497      *
498      * This differs from standard division with `/` in that it rounds up instead
499      * of rounding down.
500      */
501     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
502         // (a + b - 1) / b can overflow on addition, so we distribute.
503         return a / b + (a % b == 0 ? 0 : 1);
504     }
505 }
506 
507 // Part: SafeCast
508 
509 /// @title Safe casting methods
510 /// @notice Contains methods for safely casting between types
511 library SafeCast {
512   /// @notice Cast a uint256 to a uint160, revert on overflow
513   /// @param y The uint256 to be downcasted
514   /// @return z The downcasted integer, now type uint160
515   function toUint160(uint y) internal pure returns (uint160 z) {
516     require((z = uint160(y)) == y);
517   }
518 
519   /// @notice Cast a int256 to a int128, revert on overflow or underflow
520   /// @param y The int256 to be downcasted
521   /// @return z The downcasted integer, now type int128
522   function toInt128(int y) internal pure returns (int128 z) {
523     require((z = int128(y)) == y);
524   }
525 
526   /// @notice Cast a uint256 to a int256, revert on overflow
527   /// @param y The uint256 to be casted
528   /// @return z The casted integer, now type int256
529   function toInt256(uint y) internal pure returns (int z) {
530     require(y < 2**255);
531     z = int(y);
532   }
533 }
534 
535 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/Ownable
536 
537 /**
538  * @dev Contract module which provides a basic access control mechanism, where
539  * there is an account (an owner) that can be granted exclusive access to
540  * specific functions.
541  *
542  * By default, the owner account will be the one that deploys the contract. This
543  * can later be changed with {transferOwnership}.
544  *
545  * This module is used through inheritance. It will make available the modifier
546  * `onlyOwner`, which can be applied to your functions to restrict their use to
547  * the owner.
548  */
549 abstract contract Ownable is Context {
550     address private _owner;
551 
552     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
553 
554     /**
555      * @dev Initializes the contract setting the deployer as the initial owner.
556      */
557     constructor() {
558         _setOwner(_msgSender());
559     }
560 
561     /**
562      * @dev Returns the address of the current owner.
563      */
564     function owner() public view virtual returns (address) {
565         return _owner;
566     }
567 
568     /**
569      * @dev Throws if called by any account other than the owner.
570      */
571     modifier onlyOwner() {
572         require(owner() == _msgSender(), "Ownable: caller is not the owner");
573         _;
574     }
575 
576     /**
577      * @dev Leaves the contract without owner. It will not be possible to call
578      * `onlyOwner` functions anymore. Can only be called by the current owner.
579      *
580      * NOTE: Renouncing ownership will leave the contract without an owner,
581      * thereby removing any functionality that is only available to the owner.
582      */
583     function renounceOwnership() public virtual onlyOwner {
584         _setOwner(address(0));
585     }
586 
587     /**
588      * @dev Transfers ownership of the contract to a new account (`newOwner`).
589      * Can only be called by the current owner.
590      */
591     function transferOwnership(address newOwner) public virtual onlyOwner {
592         require(newOwner != address(0), "Ownable: new owner is the zero address");
593         _setOwner(newOwner);
594     }
595 
596     function _setOwner(address newOwner) private {
597         address oldOwner = _owner;
598         _owner = newOwner;
599         emit OwnershipTransferred(oldOwner, newOwner);
600     }
601 }
602 
603 // Part: OpenZeppelin/openzeppelin-contracts@4.2.0/SafeERC20
604 
605 /**
606  * @title SafeERC20
607  * @dev Wrappers around ERC20 operations that throw on failure (when the token
608  * contract returns false). Tokens that return no value (and instead revert or
609  * throw on failure) are also supported, non-reverting calls are assumed to be
610  * successful.
611  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
612  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
613  */
614 library SafeERC20 {
615     using Address for address;
616 
617     function safeTransfer(
618         IERC20 token,
619         address to,
620         uint256 value
621     ) internal {
622         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
623     }
624 
625     function safeTransferFrom(
626         IERC20 token,
627         address from,
628         address to,
629         uint256 value
630     ) internal {
631         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
632     }
633 
634     /**
635      * @dev Deprecated. This function has issues similar to the ones found in
636      * {IERC20-approve}, and its usage is discouraged.
637      *
638      * Whenever possible, use {safeIncreaseAllowance} and
639      * {safeDecreaseAllowance} instead.
640      */
641     function safeApprove(
642         IERC20 token,
643         address spender,
644         uint256 value
645     ) internal {
646         // safeApprove should only be called when setting an initial allowance,
647         // or when resetting it to zero. To increase and decrease it, use
648         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
649         require(
650             (value == 0) || (token.allowance(address(this), spender) == 0),
651             "SafeERC20: approve from non-zero to non-zero allowance"
652         );
653         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
654     }
655 
656     function safeIncreaseAllowance(
657         IERC20 token,
658         address spender,
659         uint256 value
660     ) internal {
661         uint256 newAllowance = token.allowance(address(this), spender) + value;
662         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
663     }
664 
665     function safeDecreaseAllowance(
666         IERC20 token,
667         address spender,
668         uint256 value
669     ) internal {
670         unchecked {
671             uint256 oldAllowance = token.allowance(address(this), spender);
672             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
673             uint256 newAllowance = oldAllowance - value;
674             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
675         }
676     }
677 
678     /**
679      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
680      * on the return value: the return value is optional (but if data is returned, it must not be false).
681      * @param token The token targeted by the call.
682      * @param data The call data (encoded using abi.encode or one of its variants).
683      */
684     function _callOptionalReturn(IERC20 token, bytes memory data) private {
685         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
686         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
687         // the target address contains contract code and also asserts for success in the low-level call.
688 
689         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
690         if (returndata.length > 0) {
691             // Return data is optional
692             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
693         }
694     }
695 }
696 
697 // Part: BetaRunnerBase
698 
699 contract BetaRunnerBase is Ownable {
700   using SafeERC20 for IERC20;
701 
702   address public immutable betaBank;
703   address public immutable weth;
704 
705   modifier onlyEOA() {
706     require(msg.sender == tx.origin, 'BetaRunnerBase/not-eoa');
707     _;
708   }
709 
710   constructor(address _betaBank, address _weth) {
711     address bweth = IBetaBank(_betaBank).bTokens(_weth);
712     require(bweth != address(0), 'BetaRunnerBase/no-bweth');
713     IERC20(_weth).safeApprove(_betaBank, type(uint).max);
714     IERC20(_weth).safeApprove(bweth, type(uint).max);
715     betaBank = _betaBank;
716     weth = _weth;
717   }
718 
719   function _borrow(
720     address _owner,
721     uint _pid,
722     address _underlying,
723     address _collateral,
724     uint _amountBorrow,
725     uint _amountCollateral
726   ) internal {
727     if (_pid == type(uint).max) {
728       _pid = IBetaBank(betaBank).open(_owner, _underlying, _collateral);
729     } else {
730       (address collateral, address bToken) = IBetaBank(betaBank).getPositionTokens(_owner, _pid);
731       require(_collateral == collateral, '_borrow/collateral-not-_collateral');
732       require(_underlying == IBetaBank(betaBank).underlyings(bToken), '_borrow/bad-underlying');
733     }
734     _approve(_collateral, betaBank, _amountCollateral);
735     IBetaBank(betaBank).put(_owner, _pid, _amountCollateral);
736     IBetaBank(betaBank).borrow(_owner, _pid, _amountBorrow);
737   }
738 
739   function _repay(
740     address _owner,
741     uint _pid,
742     address _underlying,
743     address _collateral,
744     uint _amountRepay,
745     uint _amountCollateral
746   ) internal {
747     (address collateral, address bToken) = IBetaBank(betaBank).getPositionTokens(_owner, _pid);
748     require(_collateral == collateral, '_repay/collateral-not-_collateral');
749     require(_underlying == IBetaBank(betaBank).underlyings(bToken), '_repay/bad-underlying');
750     _approve(_underlying, bToken, _amountRepay);
751     IBetaBank(betaBank).repay(_owner, _pid, _amountRepay);
752     IBetaBank(betaBank).take(_owner, _pid, _amountCollateral);
753   }
754 
755   function _transferIn(
756     address _token,
757     address _from,
758     uint _amount
759   ) internal {
760     if (_token == weth) {
761       require(_from == msg.sender, '_transferIn/not-from-sender');
762       require(_amount <= msg.value, '_transferIn/insufficient-eth-amount');
763       IWETH(weth).deposit{value: _amount}();
764       if (msg.value > _amount) {
765         (bool success, ) = _from.call{value: msg.value - _amount}(new bytes(0));
766         require(success, '_transferIn/eth-transfer-failed');
767       }
768     } else {
769       IERC20(_token).safeTransferFrom(_from, address(this), _amount);
770     }
771   }
772 
773   function _transferOut(
774     address _token,
775     address _to,
776     uint _amount
777   ) internal {
778     if (_token == weth) {
779       IWETH(weth).withdraw(_amount);
780       (bool success, ) = _to.call{value: _amount}(new bytes(0));
781       require(success, '_transferOut/eth-transfer-failed');
782     } else {
783       IERC20(_token).safeTransfer(_to, _amount);
784     }
785   }
786 
787   /// @dev Approves infinite on the given token for the given spender if current approval is insufficient.
788   function _approve(
789     address _token,
790     address _spender,
791     uint _minAmount
792   ) internal {
793     uint current = IERC20(_token).allowance(address(this), _spender);
794     if (current < _minAmount) {
795       if (current != 0) {
796         IERC20(_token).safeApprove(_spender, 0);
797       }
798       IERC20(_token).safeApprove(_spender, type(uint).max);
799     }
800   }
801 
802   /// @dev Caps repay amount by current position's debt.
803   function _capRepay(
804     address _owner,
805     uint _pid,
806     uint _amountRepay
807   ) internal returns (uint) {
808     return Math.min(_amountRepay, IBetaBank(betaBank).fetchPositionDebt(_owner, _pid));
809   }
810 
811   /// @dev Recovers lost tokens for whatever reason by the owner.
812   function recover(address _token, uint _amount) external onlyOwner {
813     if (_amount == type(uint).max) {
814       _amount = IERC20(_token).balanceOf(address(this));
815     }
816     IERC20(_token).safeTransfer(msg.sender, _amount);
817   }
818 
819   /// @dev Recovers lost ETH for whatever reason by the owner.
820   function recoverETH(uint _amount) external onlyOwner {
821     if (_amount == type(uint).max) {
822       _amount = address(this).balance;
823     }
824     (bool success, ) = msg.sender.call{value: _amount}(new bytes(0));
825     require(success, 'recoverETH/eth-transfer-failed');
826   }
827 
828   /// @dev Override Ownable.sol renounceOwnership to prevent accidental call
829   function renounceOwnership() public override onlyOwner {
830     revert('renounceOwnership/disabled');
831   }
832 
833   receive() external payable {
834     require(msg.sender == weth, 'receive/not-weth');
835   }
836 }
837 
838 // File: BetaRunnerUniswapV2.sol
839 
840 contract BetaRunnerUniswapV2 is
841   BetaRunnerBase,
842   BetaRunnerWithCallback,
843   IUniswapV2Callee,
844   IPancakeCallee
845 {
846   using SafeCast for uint;
847   using SafeERC20 for IERC20;
848 
849   address public immutable factory;
850   bytes32 public immutable codeHash;
851 
852   constructor(
853     address _betaBank,
854     address _weth,
855     address _factory,
856     bytes32 _codeHash
857   ) BetaRunnerBase(_betaBank, _weth) {
858     factory = _factory;
859     codeHash = _codeHash;
860   }
861 
862   struct CallbackData {
863     uint pid;
864     int memo; // positive if short (extra collateral) | negative if close (amount to take)
865     address[] path;
866     uint[] amounts;
867   }
868 
869   function short(
870     uint _pid,
871     uint _amountBorrow,
872     uint _amountPutExtra,
873     address[] memory _path,
874     uint _amountOutMin
875   ) external payable onlyEOA withCallback {
876     _transferIn(_path[_path.length - 1], msg.sender, _amountPutExtra);
877     uint[] memory amounts = _getAmountsOut(_amountBorrow, _path);
878     require(amounts[amounts.length - 1] >= _amountOutMin, 'short/not-enough-out');
879     IUniswapV2Pair(_pairFor(_path[0], _path[1])).swap(
880       _path[0] < _path[1] ? 0 : amounts[1],
881       _path[0] < _path[1] ? amounts[1] : 0,
882       address(this),
883       abi.encode(
884         CallbackData({pid: _pid, memo: _amountPutExtra.toInt256(), path: _path, amounts: amounts})
885       )
886     );
887   }
888 
889   function close(
890     uint _pid,
891     uint _amountRepay,
892     uint _amountTake,
893     address[] memory _path,
894     uint _amountInMax
895   ) external payable onlyEOA withCallback {
896     _amountRepay = _capRepay(msg.sender, _pid, _amountRepay);
897     uint[] memory amounts = _getAmountsIn(_amountRepay, _path);
898     require(amounts[0] <= _amountInMax, 'close/too-much-in');
899     IUniswapV2Pair(_pairFor(_path[0], _path[1])).swap(
900       _path[0] < _path[1] ? 0 : amounts[1],
901       _path[0] < _path[1] ? amounts[1] : 0,
902       address(this),
903       abi.encode(
904         CallbackData({pid: _pid, memo: -_amountTake.toInt256(), path: _path, amounts: amounts})
905       )
906     );
907   }
908 
909   /// @dev Continues the action (uniswap / sushiswap)
910   function uniswapV2Call(
911     address sender,
912     uint,
913     uint,
914     bytes calldata data
915   ) external override isCallback {
916     require(sender == address(this), 'uniswapV2Call/bad-sender');
917     _pairCallback(data);
918   }
919 
920   /// @dev Continues the action (pancakeswap)
921   function pancakeCall(
922     address sender,
923     uint,
924     uint,
925     bytes calldata data
926   ) external override isCallback {
927     require(sender == address(this), 'pancakeCall/bad-sender');
928     _pairCallback(data);
929   }
930 
931   /// @dev Continues the action (uniswap / sushiswap / pancakeswap)
932   function _pairCallback(bytes calldata data) internal {
933     CallbackData memory cb = abi.decode(data, (CallbackData));
934     require(msg.sender == _pairFor(cb.path[0], cb.path[1]), '_pairCallback/bad-caller');
935     uint len = cb.path.length;
936     if (len > 2) {
937       address pair = _pairFor(cb.path[1], cb.path[2]);
938       IERC20(cb.path[1]).safeTransfer(pair, cb.amounts[1]);
939       for (uint idx = 1; idx < len - 1; idx++) {
940         (address input, address output) = (cb.path[idx], cb.path[idx + 1]);
941         address to = idx < len - 2 ? _pairFor(output, cb.path[idx + 2]) : address(this);
942         uint amount0Out = input < output ? 0 : cb.amounts[idx + 1];
943         uint amount1Out = input < output ? cb.amounts[idx + 1] : 0;
944         IUniswapV2Pair(pair).swap(amount0Out, amount1Out, to, new bytes(0));
945         pair = to;
946       }
947     }
948     if (cb.memo > 0) {
949       uint amountCollateral = uint(cb.memo);
950       (address und, address col) = (cb.path[0], cb.path[len - 1]);
951       _borrow(tx.origin, cb.pid, und, col, cb.amounts[0], cb.amounts[len - 1] + amountCollateral);
952       IERC20(und).safeTransfer(msg.sender, cb.amounts[0]);
953     } else {
954       uint amountTake = uint(-cb.memo);
955       (address und, address col) = (cb.path[len - 1], cb.path[0]);
956       _repay(tx.origin, cb.pid, und, col, cb.amounts[len - 1], amountTake);
957       IERC20(col).safeTransfer(msg.sender, cb.amounts[0]);
958       _transferOut(col, tx.origin, IERC20(col).balanceOf(address(this)));
959     }
960   }
961 
962   /// Internal UniswapV2 library functions
963   /// See https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/libraries/UniswapV2Library.sol
964   function _sortTokens(address tokenA, address tokenB)
965     internal
966     pure
967     returns (address token0, address token1)
968   {
969     require(tokenA != tokenB, 'IDENTICAL_ADDRESSES');
970     (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
971     require(token0 != address(0), 'ZERO_ADDRESS');
972   }
973 
974   function _pairFor(address tokenA, address tokenB) internal view returns (address) {
975     (address token0, address token1) = _sortTokens(tokenA, tokenB);
976     bytes32 salt = keccak256(abi.encodePacked(token0, token1));
977     return address(uint160(uint(keccak256(abi.encodePacked(hex'ff', factory, salt, codeHash)))));
978   }
979 
980   function _getReserves(address tokenA, address tokenB)
981     internal
982     view
983     returns (uint reserveA, uint reserveB)
984   {
985     (address token0, ) = _sortTokens(tokenA, tokenB);
986     (uint reserve0, uint reserve1, ) = IUniswapV2Pair(_pairFor(tokenA, tokenB)).getReserves();
987     (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
988   }
989 
990   function _getAmountOut(
991     uint amountIn,
992     uint reserveIn,
993     uint reserveOut
994   ) internal pure returns (uint amountOut) {
995     require(amountIn > 0, 'INSUFFICIENT_INPUT_AMOUNT');
996     require(reserveIn > 0 && reserveOut > 0, 'INSUFFICIENT_LIQUIDITY');
997     uint amountInWithFee = amountIn * 997;
998     uint numerator = amountInWithFee * reserveOut;
999     uint denominator = (reserveIn * 1000) + amountInWithFee;
1000     amountOut = numerator / denominator;
1001   }
1002 
1003   function _getAmountIn(
1004     uint amountOut,
1005     uint reserveIn,
1006     uint reserveOut
1007   ) internal pure returns (uint amountIn) {
1008     require(amountOut > 0, 'INSUFFICIENT_OUTPUT_AMOUNT');
1009     require(reserveIn > 0 && reserveOut > 0, 'INSUFFICIENT_LIQUIDITY');
1010     uint numerator = reserveIn * amountOut * 1000;
1011     uint denominator = (reserveOut - amountOut) * 997;
1012     amountIn = (numerator / denominator) + 1;
1013   }
1014 
1015   function _getAmountsOut(uint amountIn, address[] memory path)
1016     internal
1017     view
1018     returns (uint[] memory amounts)
1019   {
1020     require(path.length >= 2, 'INVALID_PATH');
1021     amounts = new uint[](path.length);
1022     amounts[0] = amountIn;
1023     for (uint i; i < path.length - 1; i++) {
1024       (uint reserveIn, uint reserveOut) = _getReserves(path[i], path[i + 1]);
1025       amounts[i + 1] = _getAmountOut(amounts[i], reserveIn, reserveOut);
1026     }
1027   }
1028 
1029   function _getAmountsIn(uint amountOut, address[] memory path)
1030     internal
1031     view
1032     returns (uint[] memory amounts)
1033   {
1034     require(path.length >= 2, 'INVALID_PATH');
1035     amounts = new uint[](path.length);
1036     amounts[amounts.length - 1] = amountOut;
1037     for (uint i = path.length - 1; i > 0; i--) {
1038       (uint reserveIn, uint reserveOut) = _getReserves(path[i - 1], path[i]);
1039       amounts[i - 1] = _getAmountIn(amounts[i], reserveIn, reserveOut);
1040     }
1041   }
1042 }