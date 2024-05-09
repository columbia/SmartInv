1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4 
5 
6 
7 // Part: IBasicRewards
8 
9 interface IBasicRewards {
10     function stakeFor(address, uint256) external returns (bool);
11 
12     function balanceOf(address) external view returns (uint256);
13 
14     function earned(address) external view returns (uint256);
15 
16     function withdrawAll(bool) external returns (bool);
17 
18     function withdraw(uint256, bool) external returns (bool);
19 
20     function getReward() external returns (bool);
21 
22     function stake(uint256) external returns (bool);
23 }
24 
25 // Part: ICurveFactoryPool
26 
27 interface ICurveFactoryPool {
28     function get_dy(
29         int128 i,
30         int128 j,
31         uint256 dx
32     ) external view returns (uint256);
33 
34     function get_balances() external view returns (uint256[2] memory);
35 
36     function add_liquidity(
37         uint256[2] memory _amounts,
38         uint256 _min_mint_amount,
39         address _receiver
40     ) external returns (uint256);
41 
42     function exchange(
43         int128 i,
44         int128 j,
45         uint256 _dx,
46         uint256 _min_dy,
47         address _receiver
48     ) external returns (uint256);
49 }
50 
51 // Part: ICurvePool
52 
53 interface ICurvePool {
54     function remove_liquidity_one_coin(
55         uint256 token_amount,
56         int128 i,
57         uint256 min_amount
58     ) external;
59 
60     function calc_withdraw_one_coin(uint256 _token_amount, int128 i)
61         external
62         view
63         returns (uint256);
64 }
65 
66 // Part: ICurveTriCrypto
67 
68 interface ICurveTriCrypto {
69     function exchange(
70         uint256 i,
71         uint256 j,
72         uint256 dx,
73         uint256 min_dy,
74         bool use_eth
75     ) external;
76 
77     function get_dy(
78         uint256 i,
79         uint256 j,
80         uint256 dx
81     ) external view returns (uint256);
82 }
83 
84 // Part: ICurveV2Pool
85 
86 interface ICurveV2Pool {
87     function get_dy(
88         uint256 i,
89         uint256 j,
90         uint256 dx
91     ) external view returns (uint256);
92 
93     function exchange_underlying(
94         uint256 i,
95         uint256 j,
96         uint256 dx,
97         uint256 min_dy
98     ) external payable returns (uint256);
99 }
100 
101 // Part: ICvxCrvDeposit
102 
103 interface ICvxCrvDeposit {
104     function deposit(uint256, bool) external;
105 }
106 
107 // Part: ICvxMining
108 
109 interface ICvxMining {
110     function ConvertCrvToCvx(uint256 _amount) external view returns (uint256);
111 }
112 
113 // Part: IVirtualBalanceRewardPool
114 
115 interface IVirtualBalanceRewardPool {
116     function earned(address account) external view returns (uint256);
117 }
118 
119 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Address
120 
121 /**
122  * @dev Collection of functions related to the address type
123  */
124 library Address {
125     /**
126      * @dev Returns true if `account` is a contract.
127      *
128      * [IMPORTANT]
129      * ====
130      * It is unsafe to assume that an address for which this function returns
131      * false is an externally-owned account (EOA) and not a contract.
132      *
133      * Among others, `isContract` will return false for the following
134      * types of addresses:
135      *
136      *  - an externally-owned account
137      *  - a contract in construction
138      *  - an address where a contract will be created
139      *  - an address where a contract lived, but was destroyed
140      * ====
141      */
142     function isContract(address account) internal view returns (bool) {
143         // This method relies on extcodesize, which returns 0 for contracts in
144         // construction, since the code is only stored at the end of the
145         // constructor execution.
146 
147         uint256 size;
148         // solhint-disable-next-line no-inline-assembly
149         assembly { size := extcodesize(account) }
150         return size > 0;
151     }
152 
153     /**
154      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
155      * `recipient`, forwarding all available gas and reverting on errors.
156      *
157      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
158      * of certain opcodes, possibly making contracts go over the 2300 gas limit
159      * imposed by `transfer`, making them unable to receive funds via
160      * `transfer`. {sendValue} removes this limitation.
161      *
162      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
163      *
164      * IMPORTANT: because control is transferred to `recipient`, care must be
165      * taken to not create reentrancy vulnerabilities. Consider using
166      * {ReentrancyGuard} or the
167      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
168      */
169     function sendValue(address payable recipient, uint256 amount) internal {
170         require(address(this).balance >= amount, "Address: insufficient balance");
171 
172         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
173         (bool success, ) = recipient.call{ value: amount }("");
174         require(success, "Address: unable to send value, recipient may have reverted");
175     }
176 
177     /**
178      * @dev Performs a Solidity function call using a low level `call`. A
179      * plain`call` is an unsafe replacement for a function call: use this
180      * function instead.
181      *
182      * If `target` reverts with a revert reason, it is bubbled up by this
183      * function (like regular Solidity function calls).
184      *
185      * Returns the raw returned data. To convert to the expected return value,
186      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
187      *
188      * Requirements:
189      *
190      * - `target` must be a contract.
191      * - calling `target` with `data` must not revert.
192      *
193      * _Available since v3.1._
194      */
195     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
196       return functionCall(target, data, "Address: low-level call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
201      * `errorMessage` as a fallback revert reason when `target` reverts.
202      *
203      * _Available since v3.1._
204      */
205     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, 0, errorMessage);
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
211      * but also transferring `value` wei to `target`.
212      *
213      * Requirements:
214      *
215      * - the calling contract must have an ETH balance of at least `value`.
216      * - the called Solidity function must be `payable`.
217      *
218      * _Available since v3.1._
219      */
220     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
221         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
226      * with `errorMessage` as a fallback revert reason when `target` reverts.
227      *
228      * _Available since v3.1._
229      */
230     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
231         require(address(this).balance >= value, "Address: insufficient balance for call");
232         require(isContract(target), "Address: call to non-contract");
233 
234         // solhint-disable-next-line avoid-low-level-calls
235         (bool success, bytes memory returndata) = target.call{ value: value }(data);
236         return _verifyCallResult(success, returndata, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but performing a static call.
242      *
243      * _Available since v3.3._
244      */
245     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
246         return functionStaticCall(target, data, "Address: low-level static call failed");
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
251      * but performing a static call.
252      *
253      * _Available since v3.3._
254      */
255     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
256         require(isContract(target), "Address: static call to non-contract");
257 
258         // solhint-disable-next-line avoid-low-level-calls
259         (bool success, bytes memory returndata) = target.staticcall(data);
260         return _verifyCallResult(success, returndata, errorMessage);
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
265      * but performing a delegate call.
266      *
267      * _Available since v3.4._
268      */
269     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
270         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
275      * but performing a delegate call.
276      *
277      * _Available since v3.4._
278      */
279     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
280         require(isContract(target), "Address: delegate call to non-contract");
281 
282         // solhint-disable-next-line avoid-low-level-calls
283         (bool success, bytes memory returndata) = target.delegatecall(data);
284         return _verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
288         if (success) {
289             return returndata;
290         } else {
291             // Look for revert reason and bubble it up if present
292             if (returndata.length > 0) {
293                 // The easiest way to bubble the revert reason is using memory via assembly
294 
295                 // solhint-disable-next-line no-inline-assembly
296                 assembly {
297                     let returndata_size := mload(returndata)
298                     revert(add(32, returndata), returndata_size)
299                 }
300             } else {
301                 revert(errorMessage);
302             }
303         }
304     }
305 }
306 
307 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Context
308 
309 /*
310  * @dev Provides information about the current execution context, including the
311  * sender of the transaction and its data. While these are generally available
312  * via msg.sender and msg.data, they should not be accessed in such a direct
313  * manner, since when dealing with meta-transactions the account sending and
314  * paying for execution may not be the actual sender (as far as an application
315  * is concerned).
316  *
317  * This contract is only required for intermediate, library-like contracts.
318  */
319 abstract contract Context {
320     function _msgSender() internal view virtual returns (address) {
321         return msg.sender;
322     }
323 
324     function _msgData() internal view virtual returns (bytes calldata) {
325         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
326         return msg.data;
327     }
328 }
329 
330 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/IERC20
331 
332 /**
333  * @dev Interface of the ERC20 standard as defined in the EIP.
334  */
335 interface IERC20 {
336     /**
337      * @dev Returns the amount of tokens in existence.
338      */
339     function totalSupply() external view returns (uint256);
340 
341     /**
342      * @dev Returns the amount of tokens owned by `account`.
343      */
344     function balanceOf(address account) external view returns (uint256);
345 
346     /**
347      * @dev Moves `amount` tokens from the caller's account to `recipient`.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * Emits a {Transfer} event.
352      */
353     function transfer(address recipient, uint256 amount) external returns (bool);
354 
355     /**
356      * @dev Returns the remaining number of tokens that `spender` will be
357      * allowed to spend on behalf of `owner` through {transferFrom}. This is
358      * zero by default.
359      *
360      * This value changes when {approve} or {transferFrom} are called.
361      */
362     function allowance(address owner, address spender) external view returns (uint256);
363 
364     /**
365      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * IMPORTANT: Beware that changing an allowance with this method brings the risk
370      * that someone may use both the old and the new allowance by unfortunate
371      * transaction ordering. One possible solution to mitigate this race
372      * condition is to first reduce the spender's allowance to 0 and set the
373      * desired value afterwards:
374      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
375      *
376      * Emits an {Approval} event.
377      */
378     function approve(address spender, uint256 amount) external returns (bool);
379 
380     /**
381      * @dev Moves `amount` tokens from `sender` to `recipient` using the
382      * allowance mechanism. `amount` is then deducted from the caller's
383      * allowance.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * Emits a {Transfer} event.
388      */
389     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
390 
391     /**
392      * @dev Emitted when `value` tokens are moved from one account (`from`) to
393      * another (`to`).
394      *
395      * Note that `value` may be zero.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 value);
398 
399     /**
400      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
401      * a call to {approve}. `value` is the new allowance.
402      */
403     event Approval(address indexed owner, address indexed spender, uint256 value);
404 }
405 
406 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/ReentrancyGuard
407 
408 /**
409  * @dev Contract module that helps prevent reentrant calls to a function.
410  *
411  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
412  * available, which can be applied to functions to make sure there are no nested
413  * (reentrant) calls to them.
414  *
415  * Note that because there is a single `nonReentrant` guard, functions marked as
416  * `nonReentrant` may not call one another. This can be worked around by making
417  * those functions `private`, and then adding `external` `nonReentrant` entry
418  * points to them.
419  *
420  * TIP: If you would like to learn more about reentrancy and alternative ways
421  * to protect against it, check out our blog post
422  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
423  */
424 abstract contract ReentrancyGuard {
425     // Booleans are more expensive than uint256 or any type that takes up a full
426     // word because each write operation emits an extra SLOAD to first read the
427     // slot's contents, replace the bits taken up by the boolean, and then write
428     // back. This is the compiler's defense against contract upgrades and
429     // pointer aliasing, and it cannot be disabled.
430 
431     // The values being non-zero value makes deployment a bit more expensive,
432     // but in exchange the refund on every call to nonReentrant will be lower in
433     // amount. Since refunds are capped to a percentage of the total
434     // transaction's gas, it is best to keep them low in cases like this one, to
435     // increase the likelihood of the full refund coming into effect.
436     uint256 private constant _NOT_ENTERED = 1;
437     uint256 private constant _ENTERED = 2;
438 
439     uint256 private _status;
440 
441     constructor () {
442         _status = _NOT_ENTERED;
443     }
444 
445     /**
446      * @dev Prevents a contract from calling itself, directly or indirectly.
447      * Calling a `nonReentrant` function from another `nonReentrant`
448      * function is not supported. It is possible to prevent this from happening
449      * by making the `nonReentrant` function external, and make it call a
450      * `private` function that does the actual work.
451      */
452     modifier nonReentrant() {
453         // On the first call to nonReentrant, _notEntered will be true
454         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
455 
456         // Any calls to nonReentrant after this point will fail
457         _status = _ENTERED;
458 
459         _;
460 
461         // By storing the original value once again, a refund is triggered (see
462         // https://eips.ethereum.org/EIPS/eip-2200)
463         _status = _NOT_ENTERED;
464     }
465 }
466 
467 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/IERC20Metadata
468 
469 /**
470  * @dev Interface for the optional metadata functions from the ERC20 standard.
471  *
472  * _Available since v4.1._
473  */
474 interface IERC20Metadata is IERC20 {
475     /**
476      * @dev Returns the name of the token.
477      */
478     function name() external view returns (string memory);
479 
480     /**
481      * @dev Returns the symbol of the token.
482      */
483     function symbol() external view returns (string memory);
484 
485     /**
486      * @dev Returns the decimals places of the token.
487      */
488     function decimals() external view returns (uint8);
489 }
490 
491 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Ownable
492 
493 /**
494  * @dev Contract module which provides a basic access control mechanism, where
495  * there is an account (an owner) that can be granted exclusive access to
496  * specific functions.
497  *
498  * By default, the owner account will be the one that deploys the contract. This
499  * can later be changed with {transferOwnership}.
500  *
501  * This module is used through inheritance. It will make available the modifier
502  * `onlyOwner`, which can be applied to your functions to restrict their use to
503  * the owner.
504  */
505 abstract contract Ownable is Context {
506     address private _owner;
507 
508     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
509 
510     /**
511      * @dev Initializes the contract setting the deployer as the initial owner.
512      */
513     constructor () {
514         address msgSender = _msgSender();
515         _owner = msgSender;
516         emit OwnershipTransferred(address(0), msgSender);
517     }
518 
519     /**
520      * @dev Returns the address of the current owner.
521      */
522     function owner() public view virtual returns (address) {
523         return _owner;
524     }
525 
526     /**
527      * @dev Throws if called by any account other than the owner.
528      */
529     modifier onlyOwner() {
530         require(owner() == _msgSender(), "Ownable: caller is not the owner");
531         _;
532     }
533 
534     /**
535      * @dev Leaves the contract without owner. It will not be possible to call
536      * `onlyOwner` functions anymore. Can only be called by the current owner.
537      *
538      * NOTE: Renouncing ownership will leave the contract without an owner,
539      * thereby removing any functionality that is only available to the owner.
540      */
541     function renounceOwnership() public virtual onlyOwner {
542         emit OwnershipTransferred(_owner, address(0));
543         _owner = address(0);
544     }
545 
546     /**
547      * @dev Transfers ownership of the contract to a new account (`newOwner`).
548      * Can only be called by the current owner.
549      */
550     function transferOwnership(address newOwner) public virtual onlyOwner {
551         require(newOwner != address(0), "Ownable: new owner is the zero address");
552         emit OwnershipTransferred(_owner, newOwner);
553         _owner = newOwner;
554     }
555 }
556 
557 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/SafeERC20
558 
559 /**
560  * @title SafeERC20
561  * @dev Wrappers around ERC20 operations that throw on failure (when the token
562  * contract returns false). Tokens that return no value (and instead revert or
563  * throw on failure) are also supported, non-reverting calls are assumed to be
564  * successful.
565  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
566  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
567  */
568 library SafeERC20 {
569     using Address for address;
570 
571     function safeTransfer(IERC20 token, address to, uint256 value) internal {
572         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
573     }
574 
575     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
576         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
577     }
578 
579     /**
580      * @dev Deprecated. This function has issues similar to the ones found in
581      * {IERC20-approve}, and its usage is discouraged.
582      *
583      * Whenever possible, use {safeIncreaseAllowance} and
584      * {safeDecreaseAllowance} instead.
585      */
586     function safeApprove(IERC20 token, address spender, uint256 value) internal {
587         // safeApprove should only be called when setting an initial allowance,
588         // or when resetting it to zero. To increase and decrease it, use
589         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
590         // solhint-disable-next-line max-line-length
591         require((value == 0) || (token.allowance(address(this), spender) == 0),
592             "SafeERC20: approve from non-zero to non-zero allowance"
593         );
594         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
595     }
596 
597     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
598         uint256 newAllowance = token.allowance(address(this), spender) + value;
599         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
600     }
601 
602     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
603         unchecked {
604             uint256 oldAllowance = token.allowance(address(this), spender);
605             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
606             uint256 newAllowance = oldAllowance - value;
607             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
608         }
609     }
610 
611     /**
612      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
613      * on the return value: the return value is optional (but if data is returned, it must not be false).
614      * @param token The token targeted by the call.
615      * @param data The call data (encoded using abi.encode or one of its variants).
616      */
617     function _callOptionalReturn(IERC20 token, bytes memory data) private {
618         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
619         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
620         // the target address contains contract code and also asserts for success in the low-level call.
621 
622         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
623         if (returndata.length > 0) { // Return data is optional
624             // solhint-disable-next-line max-line-length
625             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
626         }
627     }
628 }
629 
630 // Part: UnionBase
631 
632 // Common variables and functions
633 contract UnionBase {
634     address public constant CVXCRV_STAKING_CONTRACT =
635         0x3Fe65692bfCD0e6CF84cB1E7d24108E434A7587e;
636     address public constant CURVE_CRV_ETH_POOL =
637         0x8301AE4fc9c624d1D396cbDAa1ed877821D7C511;
638     address public constant CURVE_CVX_ETH_POOL =
639         0xB576491F1E6e5E62f1d8F26062Ee822B40B0E0d4;
640     address public constant CURVE_CVXCRV_CRV_POOL =
641         0x9D0464996170c6B9e75eED71c68B99dDEDf279e8;
642 
643     address public constant CRV_TOKEN =
644         0xD533a949740bb3306d119CC777fa900bA034cd52;
645     address public constant CVXCRV_TOKEN =
646         0x62B9c7356A2Dc64a1969e19C23e4f579F9810Aa7;
647     address public constant CVX_TOKEN =
648         0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B;
649 
650     uint256 public constant CRVETH_ETH_INDEX = 0;
651     uint256 public constant CRVETH_CRV_INDEX = 1;
652     int128 public constant CVXCRV_CRV_INDEX = 0;
653     int128 public constant CVXCRV_CVXCRV_INDEX = 1;
654     uint256 public constant CVXETH_ETH_INDEX = 0;
655     uint256 public constant CVXETH_CVX_INDEX = 1;
656 
657     IBasicRewards cvxCrvStaking = IBasicRewards(CVXCRV_STAKING_CONTRACT);
658     ICurveV2Pool cvxEthSwap = ICurveV2Pool(CURVE_CVX_ETH_POOL);
659     ICurveV2Pool crvEthSwap = ICurveV2Pool(CURVE_CRV_ETH_POOL);
660     ICurveFactoryPool crvCvxCrvSwap = ICurveFactoryPool(CURVE_CVXCRV_CRV_POOL);
661 
662     /// @notice Swap CRV for cvxCRV on Curve
663     /// @param amount - amount to swap
664     /// @param recipient - where swapped tokens will be sent to
665     /// @return amount of CRV obtained after the swap
666     function _swapCrvToCvxCrv(uint256 amount, address recipient)
667         internal
668         returns (uint256)
669     {
670         return _crvToCvxCrv(amount, recipient, 0);
671     }
672 
673     /// @notice Swap CRV for cvxCRV on Curve
674     /// @param amount - amount to swap
675     /// @param recipient - where swapped tokens will be sent to
676     /// @param minAmountOut - minimum expected amount of output tokens
677     /// @return amount of CRV obtained after the swap
678     function _swapCrvToCvxCrv(
679         uint256 amount,
680         address recipient,
681         uint256 minAmountOut
682     ) internal returns (uint256) {
683         return _crvToCvxCrv(amount, recipient, minAmountOut);
684     }
685 
686     /// @notice Swap CRV for cvxCRV on Curve
687     /// @param amount - amount to swap
688     /// @param recipient - where swapped tokens will be sent to
689     /// @param minAmountOut - minimum expected amount of output tokens
690     /// @return amount of CRV obtained after the swap
691     function _crvToCvxCrv(
692         uint256 amount,
693         address recipient,
694         uint256 minAmountOut
695     ) internal returns (uint256) {
696         return
697             crvCvxCrvSwap.exchange(
698                 CVXCRV_CRV_INDEX,
699                 CVXCRV_CVXCRV_INDEX,
700                 amount,
701                 minAmountOut,
702                 recipient
703             );
704     }
705 
706     /// @notice Swap cvxCRV for CRV on Curve
707     /// @param amount - amount to swap
708     /// @param recipient - where swapped tokens will be sent to
709     /// @return amount of CRV obtained after the swap
710     function _swapCvxCrvToCrv(uint256 amount, address recipient)
711         internal
712         returns (uint256)
713     {
714         return _cvxCrvToCrv(amount, recipient, 0);
715     }
716 
717     /// @notice Swap cvxCRV for CRV on Curve
718     /// @param amount - amount to swap
719     /// @param recipient - where swapped tokens will be sent to
720     /// @param minAmountOut - minimum expected amount of output tokens
721     /// @return amount of CRV obtained after the swap
722     function _swapCvxCrvToCrv(
723         uint256 amount,
724         address recipient,
725         uint256 minAmountOut
726     ) internal returns (uint256) {
727         return _cvxCrvToCrv(amount, recipient, minAmountOut);
728     }
729 
730     /// @notice Swap cvxCRV for CRV on Curve
731     /// @param amount - amount to swap
732     /// @param recipient - where swapped tokens will be sent to
733     /// @param minAmountOut - minimum expected amount of output tokens
734     /// @return amount of CRV obtained after the swap
735     function _cvxCrvToCrv(
736         uint256 amount,
737         address recipient,
738         uint256 minAmountOut
739     ) internal returns (uint256) {
740         return
741             crvCvxCrvSwap.exchange(
742                 CVXCRV_CVXCRV_INDEX,
743                 CVXCRV_CRV_INDEX,
744                 amount,
745                 minAmountOut,
746                 recipient
747             );
748     }
749 
750     /// @notice Swap CRV for native ETH on Curve
751     /// @param amount - amount to swap
752     /// @return amount of ETH obtained after the swap
753     function _swapCrvToEth(uint256 amount) internal returns (uint256) {
754         return _crvToEth(amount, 0);
755     }
756 
757     /// @notice Swap CRV for native ETH on Curve
758     /// @param amount - amount to swap
759     /// @param minAmountOut - minimum expected amount of output tokens
760     /// @return amount of ETH obtained after the swap
761     function _swapCrvToEth(uint256 amount, uint256 minAmountOut)
762         internal
763         returns (uint256)
764     {
765         return _crvToEth(amount, minAmountOut);
766     }
767 
768     /// @notice Swap CRV for native ETH on Curve
769     /// @param amount - amount to swap
770     /// @param minAmountOut - minimum expected amount of output tokens
771     /// @return amount of ETH obtained after the swap
772     function _crvToEth(uint256 amount, uint256 minAmountOut)
773         internal
774         returns (uint256)
775     {
776         return
777             crvEthSwap.exchange_underlying{value: 0}(
778                 CRVETH_CRV_INDEX,
779                 CRVETH_ETH_INDEX,
780                 amount,
781                 minAmountOut
782             );
783     }
784 
785     /// @notice Swap native ETH for CRV on Curve
786     /// @param amount - amount to swap
787     /// @return amount of CRV obtained after the swap
788     function _swapEthToCrv(uint256 amount) internal returns (uint256) {
789         return _ethToCrv(amount, 0);
790     }
791 
792     /// @notice Swap native ETH for CRV on Curve
793     /// @param amount - amount to swap
794     /// @param minAmountOut - minimum expected amount of output tokens
795     /// @return amount of CRV obtained after the swap
796     function _swapEthToCrv(uint256 amount, uint256 minAmountOut)
797         internal
798         returns (uint256)
799     {
800         return _ethToCrv(amount, minAmountOut);
801     }
802 
803     /// @notice Swap native ETH for CRV on Curve
804     /// @param amount - amount to swap
805     /// @param minAmountOut - minimum expected amount of output tokens
806     /// @return amount of CRV obtained after the swap
807     function _ethToCrv(uint256 amount, uint256 minAmountOut)
808         internal
809         returns (uint256)
810     {
811         return
812             crvEthSwap.exchange_underlying{value: amount}(
813                 CRVETH_ETH_INDEX,
814                 CRVETH_CRV_INDEX,
815                 amount,
816                 minAmountOut
817             );
818     }
819 
820     /// @notice Swap native ETH for CVX on Curve
821     /// @param amount - amount to swap
822     /// @return amount of CRV obtained after the swap
823     function _swapEthToCvx(uint256 amount) internal returns (uint256) {
824         return _ethToCvx(amount, 0);
825     }
826 
827     /// @notice Swap native ETH for CVX on Curve
828     /// @param amount - amount to swap
829     /// @param minAmountOut - minimum expected amount of output tokens
830     /// @return amount of CRV obtained after the swap
831     function _swapEthToCvx(uint256 amount, uint256 minAmountOut)
832         internal
833         returns (uint256)
834     {
835         return _ethToCvx(amount, minAmountOut);
836     }
837 
838     /// @notice Swap native ETH for CVX on Curve
839     /// @param amount - amount to swap
840     /// @param minAmountOut - minimum expected amount of output tokens
841     /// @return amount of CRV obtained after the swap
842     function _ethToCvx(uint256 amount, uint256 minAmountOut)
843         internal
844         returns (uint256)
845     {
846         return
847             cvxEthSwap.exchange_underlying{value: amount}(
848                 CVXETH_ETH_INDEX,
849                 CVXETH_CVX_INDEX,
850                 amount,
851                 minAmountOut
852             );
853     }
854 
855     modifier notToZeroAddress(address _to) {
856         require(_to != address(0), "Invalid address!");
857         _;
858     }
859 }
860 
861 // Part: ClaimZaps
862 
863 contract ClaimZaps is ReentrancyGuard, UnionBase {
864     using SafeERC20 for IERC20;
865 
866     // Possible options when claiming
867     enum Option {
868         Claim,
869         ClaimAsETH,
870         ClaimAsCRV,
871         ClaimAsCVX,
872         ClaimAndStake
873     }
874 
875     /// @notice Set approvals for the tokens used when swapping
876     function _setApprovals() internal {
877         IERC20(CRV_TOKEN).safeApprove(CURVE_CRV_ETH_POOL, 0);
878         IERC20(CRV_TOKEN).safeApprove(CURVE_CRV_ETH_POOL, type(uint256).max);
879 
880         IERC20(CVXCRV_TOKEN).safeApprove(CVXCRV_STAKING_CONTRACT, 0);
881         IERC20(CVXCRV_TOKEN).safeApprove(
882             CVXCRV_STAKING_CONTRACT,
883             type(uint256).max
884         );
885 
886         IERC20(CVXCRV_TOKEN).safeApprove(CURVE_CVXCRV_CRV_POOL, 0);
887         IERC20(CVXCRV_TOKEN).safeApprove(
888             CURVE_CVXCRV_CRV_POOL,
889             type(uint256).max
890         );
891     }
892 
893     function _claimAs(
894         address account,
895         uint256 amount,
896         Option option
897     ) internal {
898         _claim(account, amount, option, 0);
899     }
900 
901     function _claimAs(
902         address account,
903         uint256 amount,
904         Option option,
905         uint256 minAmountOut
906     ) internal {
907         _claim(account, amount, option, minAmountOut);
908     }
909 
910     /// @notice Zap function to claim token balance as another token
911     /// @param account - recipient of the swapped token
912     /// @param amount - amount to swap
913     /// @param option - what to swap to
914     /// @param minAmountOut - minimum desired amount of output token
915     function _claim(
916         address account,
917         uint256 amount,
918         Option option,
919         uint256 minAmountOut
920     ) internal nonReentrant {
921         if (option == Option.ClaimAsCRV) {
922             _swapCvxCrvToCrv(amount, account, minAmountOut);
923         } else if (option == Option.ClaimAsETH) {
924             uint256 _crvBalance = _swapCvxCrvToCrv(amount, address(this));
925             uint256 _ethAmount = _swapCrvToEth(_crvBalance, minAmountOut);
926             (bool success, ) = account.call{value: _ethAmount}("");
927             require(success, "ETH transfer failed");
928         } else if (option == Option.ClaimAsCVX) {
929             uint256 _crvBalance = _swapCvxCrvToCrv(amount, address(this));
930             uint256 _ethAmount = _swapCrvToEth(_crvBalance);
931             uint256 _cvxAmount = _swapEthToCvx(_ethAmount, minAmountOut);
932             IERC20(CVX_TOKEN).safeTransfer(account, _cvxAmount);
933         } else if (option == Option.ClaimAndStake) {
934             require(cvxCrvStaking.stakeFor(account, amount), "Staking failed");
935         } else {
936             IERC20(CVXCRV_TOKEN).safeTransfer(account, amount);
937         }
938     }
939 }
940 
941 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/ERC20
942 
943 /**
944  * @dev Implementation of the {IERC20} interface.
945  *
946  * This implementation is agnostic to the way tokens are created. This means
947  * that a supply mechanism has to be added in a derived contract using {_mint}.
948  * For a generic mechanism see {ERC20PresetMinterPauser}.
949  *
950  * TIP: For a detailed writeup see our guide
951  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
952  * to implement supply mechanisms].
953  *
954  * We have followed general OpenZeppelin guidelines: functions revert instead
955  * of returning `false` on failure. This behavior is nonetheless conventional
956  * and does not conflict with the expectations of ERC20 applications.
957  *
958  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
959  * This allows applications to reconstruct the allowance for all accounts just
960  * by listening to said events. Other implementations of the EIP may not emit
961  * these events, as it isn't required by the specification.
962  *
963  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
964  * functions have been added to mitigate the well-known issues around setting
965  * allowances. See {IERC20-approve}.
966  */
967 contract ERC20 is Context, IERC20, IERC20Metadata {
968     mapping (address => uint256) private _balances;
969 
970     mapping (address => mapping (address => uint256)) private _allowances;
971 
972     uint256 private _totalSupply;
973 
974     string private _name;
975     string private _symbol;
976 
977     /**
978      * @dev Sets the values for {name} and {symbol}.
979      *
980      * The defaut value of {decimals} is 18. To select a different value for
981      * {decimals} you should overload it.
982      *
983      * All two of these values are immutable: they can only be set once during
984      * construction.
985      */
986     constructor (string memory name_, string memory symbol_) {
987         _name = name_;
988         _symbol = symbol_;
989     }
990 
991     /**
992      * @dev Returns the name of the token.
993      */
994     function name() public view virtual override returns (string memory) {
995         return _name;
996     }
997 
998     /**
999      * @dev Returns the symbol of the token, usually a shorter version of the
1000      * name.
1001      */
1002     function symbol() public view virtual override returns (string memory) {
1003         return _symbol;
1004     }
1005 
1006     /**
1007      * @dev Returns the number of decimals used to get its user representation.
1008      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1009      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1010      *
1011      * Tokens usually opt for a value of 18, imitating the relationship between
1012      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1013      * overridden;
1014      *
1015      * NOTE: This information is only used for _display_ purposes: it in
1016      * no way affects any of the arithmetic of the contract, including
1017      * {IERC20-balanceOf} and {IERC20-transfer}.
1018      */
1019     function decimals() public view virtual override returns (uint8) {
1020         return 18;
1021     }
1022 
1023     /**
1024      * @dev See {IERC20-totalSupply}.
1025      */
1026     function totalSupply() public view virtual override returns (uint256) {
1027         return _totalSupply;
1028     }
1029 
1030     /**
1031      * @dev See {IERC20-balanceOf}.
1032      */
1033     function balanceOf(address account) public view virtual override returns (uint256) {
1034         return _balances[account];
1035     }
1036 
1037     /**
1038      * @dev See {IERC20-transfer}.
1039      *
1040      * Requirements:
1041      *
1042      * - `recipient` cannot be the zero address.
1043      * - the caller must have a balance of at least `amount`.
1044      */
1045     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1046         _transfer(_msgSender(), recipient, amount);
1047         return true;
1048     }
1049 
1050     /**
1051      * @dev See {IERC20-allowance}.
1052      */
1053     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1054         return _allowances[owner][spender];
1055     }
1056 
1057     /**
1058      * @dev See {IERC20-approve}.
1059      *
1060      * Requirements:
1061      *
1062      * - `spender` cannot be the zero address.
1063      */
1064     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1065         _approve(_msgSender(), spender, amount);
1066         return true;
1067     }
1068 
1069     /**
1070      * @dev See {IERC20-transferFrom}.
1071      *
1072      * Emits an {Approval} event indicating the updated allowance. This is not
1073      * required by the EIP. See the note at the beginning of {ERC20}.
1074      *
1075      * Requirements:
1076      *
1077      * - `sender` and `recipient` cannot be the zero address.
1078      * - `sender` must have a balance of at least `amount`.
1079      * - the caller must have allowance for ``sender``'s tokens of at least
1080      * `amount`.
1081      */
1082     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1083         _transfer(sender, recipient, amount);
1084 
1085         uint256 currentAllowance = _allowances[sender][_msgSender()];
1086         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1087         _approve(sender, _msgSender(), currentAllowance - amount);
1088 
1089         return true;
1090     }
1091 
1092     /**
1093      * @dev Atomically increases the allowance granted to `spender` by the caller.
1094      *
1095      * This is an alternative to {approve} that can be used as a mitigation for
1096      * problems described in {IERC20-approve}.
1097      *
1098      * Emits an {Approval} event indicating the updated allowance.
1099      *
1100      * Requirements:
1101      *
1102      * - `spender` cannot be the zero address.
1103      */
1104     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1105         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1106         return true;
1107     }
1108 
1109     /**
1110      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1111      *
1112      * This is an alternative to {approve} that can be used as a mitigation for
1113      * problems described in {IERC20-approve}.
1114      *
1115      * Emits an {Approval} event indicating the updated allowance.
1116      *
1117      * Requirements:
1118      *
1119      * - `spender` cannot be the zero address.
1120      * - `spender` must have allowance for the caller of at least
1121      * `subtractedValue`.
1122      */
1123     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1124         uint256 currentAllowance = _allowances[_msgSender()][spender];
1125         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1126         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1127 
1128         return true;
1129     }
1130 
1131     /**
1132      * @dev Moves tokens `amount` from `sender` to `recipient`.
1133      *
1134      * This is internal function is equivalent to {transfer}, and can be used to
1135      * e.g. implement automatic token fees, slashing mechanisms, etc.
1136      *
1137      * Emits a {Transfer} event.
1138      *
1139      * Requirements:
1140      *
1141      * - `sender` cannot be the zero address.
1142      * - `recipient` cannot be the zero address.
1143      * - `sender` must have a balance of at least `amount`.
1144      */
1145     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1146         require(sender != address(0), "ERC20: transfer from the zero address");
1147         require(recipient != address(0), "ERC20: transfer to the zero address");
1148 
1149         _beforeTokenTransfer(sender, recipient, amount);
1150 
1151         uint256 senderBalance = _balances[sender];
1152         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1153         _balances[sender] = senderBalance - amount;
1154         _balances[recipient] += amount;
1155 
1156         emit Transfer(sender, recipient, amount);
1157     }
1158 
1159     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1160      * the total supply.
1161      *
1162      * Emits a {Transfer} event with `from` set to the zero address.
1163      *
1164      * Requirements:
1165      *
1166      * - `to` cannot be the zero address.
1167      */
1168     function _mint(address account, uint256 amount) internal virtual {
1169         require(account != address(0), "ERC20: mint to the zero address");
1170 
1171         _beforeTokenTransfer(address(0), account, amount);
1172 
1173         _totalSupply += amount;
1174         _balances[account] += amount;
1175         emit Transfer(address(0), account, amount);
1176     }
1177 
1178     /**
1179      * @dev Destroys `amount` tokens from `account`, reducing the
1180      * total supply.
1181      *
1182      * Emits a {Transfer} event with `to` set to the zero address.
1183      *
1184      * Requirements:
1185      *
1186      * - `account` cannot be the zero address.
1187      * - `account` must have at least `amount` tokens.
1188      */
1189     function _burn(address account, uint256 amount) internal virtual {
1190         require(account != address(0), "ERC20: burn from the zero address");
1191 
1192         _beforeTokenTransfer(account, address(0), amount);
1193 
1194         uint256 accountBalance = _balances[account];
1195         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1196         _balances[account] = accountBalance - amount;
1197         _totalSupply -= amount;
1198 
1199         emit Transfer(account, address(0), amount);
1200     }
1201 
1202     /**
1203      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1204      *
1205      * This internal function is equivalent to `approve`, and can be used to
1206      * e.g. set automatic allowances for certain subsystems, etc.
1207      *
1208      * Emits an {Approval} event.
1209      *
1210      * Requirements:
1211      *
1212      * - `owner` cannot be the zero address.
1213      * - `spender` cannot be the zero address.
1214      */
1215     function _approve(address owner, address spender, uint256 amount) internal virtual {
1216         require(owner != address(0), "ERC20: approve from the zero address");
1217         require(spender != address(0), "ERC20: approve to the zero address");
1218 
1219         _allowances[owner][spender] = amount;
1220         emit Approval(owner, spender, amount);
1221     }
1222 
1223     /**
1224      * @dev Hook that is called before any transfer of tokens. This includes
1225      * minting and burning.
1226      *
1227      * Calling conditions:
1228      *
1229      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1230      * will be to transferred to `to`.
1231      * - when `from` is zero, `amount` tokens will be minted for `to`.
1232      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1233      * - `from` and `to` are never both zero.
1234      *
1235      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1236      */
1237     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1238 }
1239 
1240 // File: UnionVault.sol
1241 
1242 contract UnionVault is ClaimZaps, ERC20, Ownable {
1243     using SafeERC20 for IERC20;
1244 
1245     address private constant TRIPOOL =
1246         0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
1247     address private constant THREECRV_TOKEN =
1248         0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490;
1249     address private constant USDT_TOKEN =
1250         0xdAC17F958D2ee523a2206206994597C13D831ec7;
1251     address private constant TRICRYPTO =
1252         0xD51a44d3FaE010294C616388b506AcdA1bfAAE46;
1253     address private constant CVX_MINING_LIB =
1254         0x3c75BFe6FbfDa3A94E7E7E8c2216AFc684dE5343;
1255     address private constant THREE_CRV_REWARDS =
1256         0x7091dbb7fcbA54569eF1387Ac89Eb2a5C9F6d2EA;
1257     address private constant CVXCRV_DEPOSIT =
1258         0x8014595F2AB54cD7c604B00E9fb932176fDc86Ae;
1259     address public platform = 0x9Bc7c6ad7E7Cf3A6fCB58fb21e27752AC1e53f99;
1260 
1261     uint256 public withdrawalPenalty = 100;
1262     uint256 public constant MAX_WITHDRAWAL_PENALTY = 150;
1263     uint256 public platformFee = 500;
1264     uint256 public constant MAX_PLATFORM_FEE = 2000;
1265     uint256 public callIncentive = 500;
1266     uint256 public constant MAX_CALL_INCENTIVE = 500;
1267     uint256 public constant FEE_DENOMINATOR = 10000;
1268 
1269     ICurvePool private tripool = ICurvePool(TRIPOOL);
1270     ICurveTriCrypto private tricrypto = ICurveTriCrypto(TRICRYPTO);
1271 
1272     event Harvest(address indexed _caller, uint256 _value);
1273     event Deposit(address indexed _from, address indexed _to, uint256 _value);
1274     event Withdraw(address indexed _from, address indexed _to, uint256 _value);
1275 
1276     event WithdrawalPenaltyUpdated(uint256 _penalty);
1277     event CallerIncentiveUpdated(uint256 _incentive);
1278     event PlatformFeeUpdated(uint256 _fee);
1279     event PlatformUpdated(address indexed _platform);
1280 
1281     constructor()
1282         ERC20(
1283             string(abi.encodePacked("Unionized cvxCRV")),
1284             string(abi.encodePacked("uCRV"))
1285         )
1286     {}
1287 
1288     /// @notice Set approvals for the contracts used when swapping & staking
1289     function setApprovals() external onlyOwner {
1290         IERC20(THREECRV_TOKEN).safeApprove(TRIPOOL, 0);
1291         IERC20(THREECRV_TOKEN).safeApprove(TRIPOOL, type(uint256).max);
1292 
1293         IERC20(CVX_TOKEN).safeApprove(CURVE_CVX_ETH_POOL, 0);
1294         IERC20(CVX_TOKEN).safeApprove(CURVE_CVX_ETH_POOL, type(uint256).max);
1295 
1296         IERC20(USDT_TOKEN).safeApprove(TRICRYPTO, 0);
1297         IERC20(USDT_TOKEN).safeApprove(TRICRYPTO, type(uint256).max);
1298 
1299         IERC20(CRV_TOKEN).safeApprove(CVXCRV_DEPOSIT, 0);
1300         IERC20(CRV_TOKEN).safeApprove(CVXCRV_DEPOSIT, type(uint256).max);
1301 
1302         IERC20(CRV_TOKEN).safeApprove(CURVE_CVXCRV_CRV_POOL, 0);
1303         IERC20(CRV_TOKEN).safeApprove(CURVE_CVXCRV_CRV_POOL, type(uint256).max);
1304 
1305         _setApprovals();
1306     }
1307 
1308     /// @notice Updates the withdrawal penalty
1309     /// @param _penalty - the amount of the new penalty (in BIPS)
1310     function setWithdrawalPenalty(uint256 _penalty) external onlyOwner {
1311         require(_penalty <= MAX_WITHDRAWAL_PENALTY);
1312         withdrawalPenalty = _penalty;
1313         emit WithdrawalPenaltyUpdated(_penalty);
1314     }
1315 
1316     /// @notice Updates the caller incentive for harvests
1317     /// @param _incentive - the amount of the new incentive (in BIPS)
1318     function setCallIncentive(uint256 _incentive) external onlyOwner {
1319         require(_incentive <= MAX_CALL_INCENTIVE);
1320         callIncentive = _incentive;
1321         emit CallerIncentiveUpdated(_incentive);
1322     }
1323 
1324     /// @notice Updates the part of yield redirected to the platform
1325     /// @param _fee - the amount of the new platform fee (in BIPS)
1326     function setPlatformFee(uint256 _fee) external onlyOwner {
1327         require(_fee <= MAX_PLATFORM_FEE);
1328         platformFee = _fee;
1329         emit PlatformFeeUpdated(_fee);
1330     }
1331 
1332     /// @notice Updates the address to which platform fees are paid out
1333     /// @param _platform - the new platform wallet address
1334     function setPlatform(address _platform)
1335         external
1336         onlyOwner
1337         notToZeroAddress(_platform)
1338     {
1339         platform = _platform;
1340         emit PlatformUpdated(_platform);
1341     }
1342 
1343     /// @notice Query the amount currently staked
1344     /// @return total - the total amount of tokens staked
1345     function totalUnderlying() public view returns (uint256 total) {
1346         return cvxCrvStaking.balanceOf(address(this));
1347     }
1348 
1349     /// @notice Query the total amount of currently claimable CRV
1350     /// @return total - the total amount of CRV claimable
1351     function outstandingCrvRewards() public view returns (uint256 total) {
1352         return cvxCrvStaking.earned(address(this));
1353     }
1354 
1355     /// @notice Query the total amount of currently claimable CVX
1356     /// @return total - the total amount of CVX claimable
1357     function outstandingCvxRewards() external view returns (uint256 total) {
1358         return
1359             ICvxMining(CVX_MINING_LIB).ConvertCrvToCvx(outstandingCrvRewards());
1360     }
1361 
1362     /// @notice Query the total amount of currently claimable 3CRV
1363     /// @return total - the total amount of 3CRV claimable
1364     function outstanding3CrvRewards() external view returns (uint256 total) {
1365         return
1366             IVirtualBalanceRewardPool(THREE_CRV_REWARDS).earned(address(this));
1367     }
1368 
1369     /// @notice Returns the amount of cvxCRV a user can claim
1370     /// @param user - address whose claimable amount to query
1371     /// @return amount - claimable amount
1372     /// @dev Does not account for penalties and fees
1373     function balanceOfUnderlying(address user)
1374         external
1375         view
1376         returns (uint256 amount)
1377     {
1378         require(totalSupply() > 0, "No users");
1379         return ((balanceOf(user) * totalUnderlying()) / totalSupply());
1380     }
1381 
1382     /// @notice Returns the address of the underlying token
1383     function underlying() external view returns (address) {
1384         return CVXCRV_TOKEN;
1385     }
1386 
1387     /// @notice Claim rewards and swaps them to cvxCrv for restaking
1388     /// @dev Can be called by anyone against an incentive in cvxCrv
1389     function harvest() public {
1390         // claim rewards
1391         cvxCrvStaking.getReward();
1392 
1393         // sell CVX rewards for ETH
1394         uint256 _cvxAmount = IERC20(CVX_TOKEN).balanceOf(address(this));
1395         if (_cvxAmount > 0) {
1396             cvxEthSwap.exchange_underlying{value: 0}(
1397                 CVXETH_CVX_INDEX,
1398                 CVXETH_ETH_INDEX,
1399                 _cvxAmount,
1400                 0
1401             );
1402         }
1403 
1404         // pull 3crv out as USDT, swap for ETH
1405         uint256 _threeCrvBalance = IERC20(THREECRV_TOKEN).balanceOf(
1406             address(this)
1407         );
1408         if (_threeCrvBalance > 0) {
1409             tripool.remove_liquidity_one_coin(_threeCrvBalance, 2, 0);
1410 
1411             uint256 _usdtBalance = IERC20(USDT_TOKEN).balanceOf(address(this));
1412             if (_usdtBalance > 0) {
1413                 tricrypto.exchange(0, 2, _usdtBalance, 0, true);
1414             }
1415         }
1416         // swap everything to CRV
1417         uint256 _crvBalance = IERC20(CRV_TOKEN).balanceOf(address(this));
1418         uint256 _ethBalance = address(this).balance;
1419         if (_ethBalance > 0) {
1420             _crvBalance += _swapEthToCrv(address(this).balance);
1421         }
1422         if (_crvBalance > 0) {
1423             uint256 _quote = crvCvxCrvSwap.get_dy(
1424                 CVXCRV_CRV_INDEX,
1425                 CVXCRV_CVXCRV_INDEX,
1426                 _crvBalance
1427             );
1428             // swap on Curve if there is a premium for doing so
1429             if (_quote > _crvBalance) {
1430                 _swapCrvToCvxCrv(_crvBalance, address(this));
1431             }
1432             // otherwise deposit & lock
1433             else {
1434                 ICvxCrvDeposit(CVXCRV_DEPOSIT).deposit(_crvBalance, true);
1435             }
1436         }
1437         uint256 _cvxCrvBalance = IERC20(CVXCRV_TOKEN).balanceOf(address(this));
1438 
1439         emit Harvest(msg.sender, _cvxCrvBalance);
1440 
1441         // if this is the last call, no restake & no fees
1442         if (totalSupply() == 0) {
1443             return;
1444         }
1445 
1446         if (_cvxCrvBalance > 0) {
1447             uint256 _stakingAmount = _cvxCrvBalance;
1448             // Deduce and pay out incentive to caller (not needed for final exit)
1449             if (callIncentive > 0) {
1450                 uint256 incentiveAmount = (_cvxCrvBalance * callIncentive) /
1451                     FEE_DENOMINATOR;
1452                 IERC20(CVXCRV_TOKEN).safeTransfer(msg.sender, incentiveAmount);
1453                 _stakingAmount = _stakingAmount - incentiveAmount;
1454             }
1455             // Deduce and pay platform fee
1456             if (platformFee > 0) {
1457                 uint256 feeAmount = (_cvxCrvBalance * platformFee) /
1458                     FEE_DENOMINATOR;
1459                 IERC20(CVXCRV_TOKEN).safeTransfer(platform, feeAmount);
1460                 _stakingAmount = _stakingAmount - feeAmount;
1461             }
1462             cvxCrvStaking.stake(_stakingAmount);
1463         }
1464     }
1465 
1466     /// @notice Deposit user funds in the autocompounder and mints tokens
1467     /// representing user's share of the pool in exchange
1468     /// @param _to - the address that will receive the shares
1469     /// @param _amount - the amount of cvxCrv to deposit
1470     /// @return _shares - the amount of shares issued
1471     function deposit(address _to, uint256 _amount)
1472         public
1473         notToZeroAddress(_to)
1474         returns (uint256 _shares)
1475     {
1476         require(_amount > 0, "Deposit too small");
1477 
1478         uint256 _before = totalUnderlying();
1479         IERC20(CVXCRV_TOKEN).safeTransferFrom(
1480             msg.sender,
1481             address(this),
1482             _amount
1483         );
1484         cvxCrvStaking.stake(_amount);
1485 
1486         // Issues shares in proportion of deposit to pool amount
1487         uint256 shares = 0;
1488         if (totalSupply() == 0) {
1489             shares = _amount;
1490         } else {
1491             shares = (_amount * totalSupply()) / _before;
1492         }
1493         _mint(_to, shares);
1494         emit Deposit(msg.sender, _to, _amount);
1495         return shares;
1496     }
1497 
1498     /// @notice Deposit all of user's cvxCRV balance
1499     /// @param _to - the address that will receive the shares
1500     /// @return _shares - the amount of shares issued
1501     function depositAll(address _to) external returns (uint256 _shares) {
1502         return deposit(_to, IERC20(CVXCRV_TOKEN).balanceOf(msg.sender));
1503     }
1504 
1505     /// @notice Unstake cvxCrv in proportion to the amount of shares sent
1506     /// @param _shares - the number of shares sent
1507     /// @return _withdrawable - the withdrawable cvxCrv amount
1508     function _withdraw(uint256 _shares)
1509         internal
1510         returns (uint256 _withdrawable)
1511     {
1512         require(totalSupply() > 0);
1513         // Computes the amount withdrawable based on the number of shares sent
1514         uint256 amount = (_shares * totalUnderlying()) / totalSupply();
1515         // Burn the shares before retrieving tokens
1516         _burn(msg.sender, _shares);
1517         // If user is last to withdraw, harvest before exit
1518         if (totalSupply() == 0) {
1519             harvest();
1520             cvxCrvStaking.withdraw(totalUnderlying(), false);
1521             _withdrawable = IERC20(CVXCRV_TOKEN).balanceOf(address(this));
1522         }
1523         // Otherwise compute share and unstake
1524         else {
1525             _withdrawable = amount;
1526             // Substract a small withdrawal fee to prevent users "timing"
1527             // the harvests. The fee stays staked and is therefore
1528             // redistributed to all remaining participants.
1529             uint256 _penalty = (_withdrawable * withdrawalPenalty) /
1530                 FEE_DENOMINATOR;
1531             _withdrawable = _withdrawable - _penalty;
1532             cvxCrvStaking.withdraw(_withdrawable, false);
1533         }
1534         return _withdrawable;
1535     }
1536 
1537     /// @notice Unstake cvxCrv in proportion to the amount of shares sent
1538     /// @param _to - address to send cvxCrv to
1539     /// @param _shares - the number of shares sent
1540     /// @return withdrawn - the amount of cvxCRV returned to the user
1541     function withdraw(address _to, uint256 _shares)
1542         public
1543         notToZeroAddress(_to)
1544         returns (uint256 withdrawn)
1545     {
1546         // Withdraw requested amount of cvxCrv
1547         uint256 _withdrawable = _withdraw(_shares);
1548         // And sends back cvxCrv to user
1549         IERC20(CVXCRV_TOKEN).safeTransfer(_to, _withdrawable);
1550         emit Withdraw(msg.sender, _to, _withdrawable);
1551         return _withdrawable;
1552     }
1553 
1554     /// @notice Withdraw all of a users' position as cvxCRV
1555     /// @param _to - address to send cvxCrv to
1556     /// @return withdrawn - the amount of cvxCRV returned to the user
1557     function withdrawAll(address _to)
1558         external
1559         notToZeroAddress(_to)
1560         returns (uint256 withdrawn)
1561     {
1562         return withdraw(_to, balanceOf(msg.sender));
1563     }
1564 
1565     /// @notice Zap function to withdraw as another token
1566     /// @param _to - address to send cvxCrv to
1567     /// @param _shares - the number of shares sent
1568     /// @param option - what to swap to
1569     function withdrawAs(
1570         address _to,
1571         uint256 _shares,
1572         Option option
1573     ) external notToZeroAddress(_to) {
1574         uint256 _withdrawn = _withdraw(_shares);
1575         _claimAs(_to, _withdrawn, option);
1576     }
1577 
1578     /// @notice Zap function to withdraw all shares to another token
1579     /// @param _to - address to send cvxCrv to
1580     /// @param option - what to swap to
1581     function withdrawAllAs(address _to, Option option)
1582         external
1583         notToZeroAddress(_to)
1584     {
1585         uint256 _withdrawn = _withdraw(balanceOf(msg.sender));
1586         _claimAs(_to, _withdrawn, option);
1587     }
1588 
1589     /// @notice Zap function to withdraw as another token
1590     /// @param _to - address to send cvxCrv to
1591     /// @param _shares - the number of shares sent
1592     /// @param option - what to swap to
1593     /// @param minAmountOut - minimum desired amount of output token
1594     function withdrawAs(
1595         address _to,
1596         uint256 _shares,
1597         Option option,
1598         uint256 minAmountOut
1599     ) external notToZeroAddress(_to) {
1600         uint256 _withdrawn = _withdraw(_shares);
1601         _claimAs(_to, _withdrawn, option, minAmountOut);
1602     }
1603 
1604     /// @notice Zap function to withdraw all shares to another token
1605     /// @param _to - address to send cvxCrv to
1606     /// @param option - what to swap to
1607     /// @param minAmountOut - minimum desired amount of output token
1608     function withdrawAllAs(
1609         address _to,
1610         Option option,
1611         uint256 minAmountOut
1612     ) external notToZeroAddress(_to) {
1613         uint256 _withdrawn = _withdraw(balanceOf(msg.sender));
1614         _claimAs(_to, _withdrawn, option, minAmountOut);
1615     }
1616 
1617     receive() external payable {}
1618 }
