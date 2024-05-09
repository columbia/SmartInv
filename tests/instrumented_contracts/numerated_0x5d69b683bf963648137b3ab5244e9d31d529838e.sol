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
25 // Part: IBooster
26 
27 interface IBooster {
28     function depositAll(uint256 _pid, bool _stake) external returns (bool);
29 }
30 
31 // Part: ICVXLocker
32 
33 interface ICVXLocker {
34     function lock(
35         address _account,
36         uint256 _amount,
37         uint256 _spendRatio
38     ) external;
39 
40     function balances(address _user)
41         external
42         view
43         returns (
44             uint112 locked,
45             uint112 boosted,
46             uint32 nextUnlockIndex
47         );
48 }
49 
50 // Part: ICurveFactoryPool
51 
52 interface ICurveFactoryPool {
53     function get_dy(
54         int128 i,
55         int128 j,
56         uint256 dx
57     ) external view returns (uint256);
58 
59     function get_balances() external view returns (uint256[2] memory);
60 
61     function add_liquidity(
62         uint256[2] memory _amounts,
63         uint256 _min_mint_amount,
64         address _receiver
65     ) external returns (uint256);
66 
67     function exchange(
68         int128 i,
69         int128 j,
70         uint256 _dx,
71         uint256 _min_dy,
72         address _receiver
73     ) external returns (uint256);
74 }
75 
76 // Part: ICurveTriCrypto
77 
78 interface ICurveTriCrypto {
79     function exchange(
80         uint256 i,
81         uint256 j,
82         uint256 dx,
83         uint256 min_dy,
84         bool use_eth
85     ) external payable;
86 
87     function get_dy(
88         uint256 i,
89         uint256 j,
90         uint256 dx
91     ) external view returns (uint256);
92 }
93 
94 // Part: ICurveV2Pool
95 
96 interface ICurveV2Pool {
97     function get_dy(
98         uint256 i,
99         uint256 j,
100         uint256 dx
101     ) external view returns (uint256);
102 
103     function exchange_underlying(
104         uint256 i,
105         uint256 j,
106         uint256 dx,
107         uint256 min_dy
108     ) external payable returns (uint256);
109 }
110 
111 // Part: IMerkleDistributorV2
112 
113 interface IMerkleDistributorV2 {
114     enum Option {
115         Claim,
116         ClaimAsETH,
117         ClaimAsCRV,
118         ClaimAsCVX,
119         ClaimAndStake
120     }
121 
122     function vault() external view returns (address);
123 
124     function merkleRoot() external view returns (bytes32);
125 
126     function week() external view returns (uint32);
127 
128     function frozen() external view returns (bool);
129 
130     function isClaimed(uint256 index) external view returns (bool);
131 
132     function setApprovals() external;
133 
134     function claim(
135         uint256 index,
136         address account,
137         uint256 amount,
138         bytes32[] calldata merkleProof
139     ) external;
140 
141     function claimAs(
142         uint256 index,
143         address account,
144         uint256 amount,
145         bytes32[] calldata merkleProof,
146         Option option
147     ) external;
148 
149     function claimAs(
150         uint256 index,
151         address account,
152         uint256 amount,
153         bytes32[] calldata merkleProof,
154         Option option,
155         uint256 minAmountOut
156     ) external;
157 
158     function freeze() external;
159 
160     function unfreeze() external;
161 
162     function stake() external;
163 
164     function updateMerkleRoot(bytes32 newMerkleRoot, bool unfreeze) external;
165 
166     function updateDepositor(address newDepositor) external;
167 
168     function updateAdmin(address newAdmin) external;
169 
170     function updateVault(address newVault) external;
171 
172     event Claimed(
173         uint256 index,
174         uint256 amount,
175         address indexed account,
176         uint256 indexed week,
177         Option option
178     );
179 
180     event DepositorUpdated(
181         address indexed oldDepositor,
182         address indexed newDepositor
183     );
184 
185     event AdminUpdated(address indexed oldAdmin, address indexed newAdmin);
186 
187     event VaultUpdated(address indexed oldVault, address indexed newVault);
188 
189     event MerkleRootUpdated(bytes32 indexed merkleRoot, uint32 indexed week);
190 }
191 
192 // Part: IRewards
193 
194 interface IRewards {
195     function balanceOf(address) external view returns (uint256);
196 
197     function stake(address, uint256) external;
198 
199     function stakeFor(address, uint256) external;
200 
201     function withdraw(address, uint256) external;
202 
203     function exit(address) external;
204 
205     function getReward(address) external;
206 
207     function queueNewRewards(uint256) external;
208 
209     function notifyRewardAmount(uint256) external;
210 
211     function addExtraReward(address) external;
212 
213     function stakingToken() external view returns (address);
214 
215     function rewardToken() external view returns (address);
216 
217     function earned(address account) external view returns (uint256);
218 }
219 
220 // Part: ITriPool
221 
222 interface ITriPool {
223     function add_liquidity(uint256[3] calldata amounts, uint256 min_mint_amount)
224         external;
225 
226     function get_virtual_price() external view returns (uint256);
227 }
228 
229 // Part: IUniV2Router
230 
231 interface IUniV2Router {
232     function swapExactTokensForETH(
233         uint256 amountIn,
234         uint256 amountOutMin,
235         address[] calldata path,
236         address to,
237         uint256 deadline
238     ) external payable returns (uint256[] memory amounts);
239 
240     function swapExactETHForTokens(
241         uint256 amountOutMin,
242         address[] calldata path,
243         address to,
244         uint256 deadline
245     ) external payable returns (uint256[] memory amounts);
246 
247     function getAmountsOut(uint256 amountIn, address[] memory path)
248         external
249         view
250         returns (uint256[] memory amounts);
251 }
252 
253 // Part: IUnionVault
254 
255 interface IUnionVault {
256     enum Option {
257         Claim,
258         ClaimAsETH,
259         ClaimAsCRV,
260         ClaimAsCVX,
261         ClaimAndStake
262     }
263 
264     function withdraw(address _to, uint256 _shares)
265         external
266         returns (uint256 withdrawn);
267 
268     function withdrawAll(address _to) external returns (uint256 withdrawn);
269 
270     function withdrawAs(
271         address _to,
272         uint256 _shares,
273         Option option
274     ) external;
275 
276     function withdrawAs(
277         address _to,
278         uint256 _shares,
279         Option option,
280         uint256 minAmountOut
281     ) external;
282 
283     function withdrawAllAs(address _to, Option option) external;
284 
285     function withdrawAllAs(
286         address _to,
287         Option option,
288         uint256 minAmountOut
289     ) external;
290 
291     function depositAll(address _to) external returns (uint256 _shares);
292 
293     function deposit(address _to, uint256 _amount)
294         external
295         returns (uint256 _shares);
296 
297     function harvest() external;
298 
299     function balanceOfUnderlying(address user)
300         external
301         view
302         returns (uint256 amount);
303 
304     function outstanding3CrvRewards() external view returns (uint256 total);
305 
306     function outstandingCvxRewards() external view returns (uint256 total);
307 
308     function outstandingCrvRewards() external view returns (uint256 total);
309 
310     function totalUnderlying() external view returns (uint256 total);
311 
312     function underlying() external view returns (address);
313 
314     function setPlatform(address _platform) external;
315 
316     function setPlatformFee(uint256 _fee) external;
317 
318     function setCallIncentive(uint256 _incentive) external;
319 
320     function setWithdrawalPenalty(uint256 _penalty) external;
321 
322     function setApprovals() external;
323 }
324 
325 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Address
326 
327 /**
328  * @dev Collection of functions related to the address type
329  */
330 library Address {
331     /**
332      * @dev Returns true if `account` is a contract.
333      *
334      * [IMPORTANT]
335      * ====
336      * It is unsafe to assume that an address for which this function returns
337      * false is an externally-owned account (EOA) and not a contract.
338      *
339      * Among others, `isContract` will return false for the following
340      * types of addresses:
341      *
342      *  - an externally-owned account
343      *  - a contract in construction
344      *  - an address where a contract will be created
345      *  - an address where a contract lived, but was destroyed
346      * ====
347      */
348     function isContract(address account) internal view returns (bool) {
349         // This method relies on extcodesize, which returns 0 for contracts in
350         // construction, since the code is only stored at the end of the
351         // constructor execution.
352 
353         uint256 size;
354         // solhint-disable-next-line no-inline-assembly
355         assembly { size := extcodesize(account) }
356         return size > 0;
357     }
358 
359     /**
360      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
361      * `recipient`, forwarding all available gas and reverting on errors.
362      *
363      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
364      * of certain opcodes, possibly making contracts go over the 2300 gas limit
365      * imposed by `transfer`, making them unable to receive funds via
366      * `transfer`. {sendValue} removes this limitation.
367      *
368      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
369      *
370      * IMPORTANT: because control is transferred to `recipient`, care must be
371      * taken to not create reentrancy vulnerabilities. Consider using
372      * {ReentrancyGuard} or the
373      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
374      */
375     function sendValue(address payable recipient, uint256 amount) internal {
376         require(address(this).balance >= amount, "Address: insufficient balance");
377 
378         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
379         (bool success, ) = recipient.call{ value: amount }("");
380         require(success, "Address: unable to send value, recipient may have reverted");
381     }
382 
383     /**
384      * @dev Performs a Solidity function call using a low level `call`. A
385      * plain`call` is an unsafe replacement for a function call: use this
386      * function instead.
387      *
388      * If `target` reverts with a revert reason, it is bubbled up by this
389      * function (like regular Solidity function calls).
390      *
391      * Returns the raw returned data. To convert to the expected return value,
392      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
393      *
394      * Requirements:
395      *
396      * - `target` must be a contract.
397      * - calling `target` with `data` must not revert.
398      *
399      * _Available since v3.1._
400      */
401     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
402       return functionCall(target, data, "Address: low-level call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
407      * `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
412         return functionCallWithValue(target, data, 0, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but also transferring `value` wei to `target`.
418      *
419      * Requirements:
420      *
421      * - the calling contract must have an ETH balance of at least `value`.
422      * - the called Solidity function must be `payable`.
423      *
424      * _Available since v3.1._
425      */
426     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
427         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
432      * with `errorMessage` as a fallback revert reason when `target` reverts.
433      *
434      * _Available since v3.1._
435      */
436     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
437         require(address(this).balance >= value, "Address: insufficient balance for call");
438         require(isContract(target), "Address: call to non-contract");
439 
440         // solhint-disable-next-line avoid-low-level-calls
441         (bool success, bytes memory returndata) = target.call{ value: value }(data);
442         return _verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
452         return functionStaticCall(target, data, "Address: low-level static call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
462         require(isContract(target), "Address: static call to non-contract");
463 
464         // solhint-disable-next-line avoid-low-level-calls
465         (bool success, bytes memory returndata) = target.staticcall(data);
466         return _verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a delegate call.
472      *
473      * _Available since v3.4._
474      */
475     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
476         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a delegate call.
482      *
483      * _Available since v3.4._
484      */
485     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
486         require(isContract(target), "Address: delegate call to non-contract");
487 
488         // solhint-disable-next-line avoid-low-level-calls
489         (bool success, bytes memory returndata) = target.delegatecall(data);
490         return _verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
494         if (success) {
495             return returndata;
496         } else {
497             // Look for revert reason and bubble it up if present
498             if (returndata.length > 0) {
499                 // The easiest way to bubble the revert reason is using memory via assembly
500 
501                 // solhint-disable-next-line no-inline-assembly
502                 assembly {
503                     let returndata_size := mload(returndata)
504                     revert(add(32, returndata), returndata_size)
505                 }
506             } else {
507                 revert(errorMessage);
508             }
509         }
510     }
511 }
512 
513 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Context
514 
515 /*
516  * @dev Provides information about the current execution context, including the
517  * sender of the transaction and its data. While these are generally available
518  * via msg.sender and msg.data, they should not be accessed in such a direct
519  * manner, since when dealing with meta-transactions the account sending and
520  * paying for execution may not be the actual sender (as far as an application
521  * is concerned).
522  *
523  * This contract is only required for intermediate, library-like contracts.
524  */
525 abstract contract Context {
526     function _msgSender() internal view virtual returns (address) {
527         return msg.sender;
528     }
529 
530     function _msgData() internal view virtual returns (bytes calldata) {
531         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
532         return msg.data;
533     }
534 }
535 
536 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/IERC20
537 
538 /**
539  * @dev Interface of the ERC20 standard as defined in the EIP.
540  */
541 interface IERC20 {
542     /**
543      * @dev Returns the amount of tokens in existence.
544      */
545     function totalSupply() external view returns (uint256);
546 
547     /**
548      * @dev Returns the amount of tokens owned by `account`.
549      */
550     function balanceOf(address account) external view returns (uint256);
551 
552     /**
553      * @dev Moves `amount` tokens from the caller's account to `recipient`.
554      *
555      * Returns a boolean value indicating whether the operation succeeded.
556      *
557      * Emits a {Transfer} event.
558      */
559     function transfer(address recipient, uint256 amount) external returns (bool);
560 
561     /**
562      * @dev Returns the remaining number of tokens that `spender` will be
563      * allowed to spend on behalf of `owner` through {transferFrom}. This is
564      * zero by default.
565      *
566      * This value changes when {approve} or {transferFrom} are called.
567      */
568     function allowance(address owner, address spender) external view returns (uint256);
569 
570     /**
571      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
572      *
573      * Returns a boolean value indicating whether the operation succeeded.
574      *
575      * IMPORTANT: Beware that changing an allowance with this method brings the risk
576      * that someone may use both the old and the new allowance by unfortunate
577      * transaction ordering. One possible solution to mitigate this race
578      * condition is to first reduce the spender's allowance to 0 and set the
579      * desired value afterwards:
580      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
581      *
582      * Emits an {Approval} event.
583      */
584     function approve(address spender, uint256 amount) external returns (bool);
585 
586     /**
587      * @dev Moves `amount` tokens from `sender` to `recipient` using the
588      * allowance mechanism. `amount` is then deducted from the caller's
589      * allowance.
590      *
591      * Returns a boolean value indicating whether the operation succeeded.
592      *
593      * Emits a {Transfer} event.
594      */
595     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
596 
597     /**
598      * @dev Emitted when `value` tokens are moved from one account (`from`) to
599      * another (`to`).
600      *
601      * Note that `value` may be zero.
602      */
603     event Transfer(address indexed from, address indexed to, uint256 value);
604 
605     /**
606      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
607      * a call to {approve}. `value` is the new allowance.
608      */
609     event Approval(address indexed owner, address indexed spender, uint256 value);
610 }
611 
612 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Ownable
613 
614 /**
615  * @dev Contract module which provides a basic access control mechanism, where
616  * there is an account (an owner) that can be granted exclusive access to
617  * specific functions.
618  *
619  * By default, the owner account will be the one that deploys the contract. This
620  * can later be changed with {transferOwnership}.
621  *
622  * This module is used through inheritance. It will make available the modifier
623  * `onlyOwner`, which can be applied to your functions to restrict their use to
624  * the owner.
625  */
626 abstract contract Ownable is Context {
627     address private _owner;
628 
629     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
630 
631     /**
632      * @dev Initializes the contract setting the deployer as the initial owner.
633      */
634     constructor () {
635         address msgSender = _msgSender();
636         _owner = msgSender;
637         emit OwnershipTransferred(address(0), msgSender);
638     }
639 
640     /**
641      * @dev Returns the address of the current owner.
642      */
643     function owner() public view virtual returns (address) {
644         return _owner;
645     }
646 
647     /**
648      * @dev Throws if called by any account other than the owner.
649      */
650     modifier onlyOwner() {
651         require(owner() == _msgSender(), "Ownable: caller is not the owner");
652         _;
653     }
654 
655     /**
656      * @dev Leaves the contract without owner. It will not be possible to call
657      * `onlyOwner` functions anymore. Can only be called by the current owner.
658      *
659      * NOTE: Renouncing ownership will leave the contract without an owner,
660      * thereby removing any functionality that is only available to the owner.
661      */
662     function renounceOwnership() public virtual onlyOwner {
663         emit OwnershipTransferred(_owner, address(0));
664         _owner = address(0);
665     }
666 
667     /**
668      * @dev Transfers ownership of the contract to a new account (`newOwner`).
669      * Can only be called by the current owner.
670      */
671     function transferOwnership(address newOwner) public virtual onlyOwner {
672         require(newOwner != address(0), "Ownable: new owner is the zero address");
673         emit OwnershipTransferred(_owner, newOwner);
674         _owner = newOwner;
675     }
676 }
677 
678 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/SafeERC20
679 
680 /**
681  * @title SafeERC20
682  * @dev Wrappers around ERC20 operations that throw on failure (when the token
683  * contract returns false). Tokens that return no value (and instead revert or
684  * throw on failure) are also supported, non-reverting calls are assumed to be
685  * successful.
686  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
687  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
688  */
689 library SafeERC20 {
690     using Address for address;
691 
692     function safeTransfer(IERC20 token, address to, uint256 value) internal {
693         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
694     }
695 
696     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
697         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
698     }
699 
700     /**
701      * @dev Deprecated. This function has issues similar to the ones found in
702      * {IERC20-approve}, and its usage is discouraged.
703      *
704      * Whenever possible, use {safeIncreaseAllowance} and
705      * {safeDecreaseAllowance} instead.
706      */
707     function safeApprove(IERC20 token, address spender, uint256 value) internal {
708         // safeApprove should only be called when setting an initial allowance,
709         // or when resetting it to zero. To increase and decrease it, use
710         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
711         // solhint-disable-next-line max-line-length
712         require((value == 0) || (token.allowance(address(this), spender) == 0),
713             "SafeERC20: approve from non-zero to non-zero allowance"
714         );
715         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
716     }
717 
718     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
719         uint256 newAllowance = token.allowance(address(this), spender) + value;
720         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
721     }
722 
723     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
724         unchecked {
725             uint256 oldAllowance = token.allowance(address(this), spender);
726             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
727             uint256 newAllowance = oldAllowance - value;
728             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
729         }
730     }
731 
732     /**
733      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
734      * on the return value: the return value is optional (but if data is returned, it must not be false).
735      * @param token The token targeted by the call.
736      * @param data The call data (encoded using abi.encode or one of its variants).
737      */
738     function _callOptionalReturn(IERC20 token, bytes memory data) private {
739         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
740         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
741         // the target address contains contract code and also asserts for success in the low-level call.
742 
743         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
744         if (returndata.length > 0) { // Return data is optional
745             // solhint-disable-next-line max-line-length
746             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
747         }
748     }
749 }
750 
751 // Part: UnionBase
752 
753 // Common variables and functions
754 contract UnionBase {
755     address public constant CVXCRV_STAKING_CONTRACT =
756         0x3Fe65692bfCD0e6CF84cB1E7d24108E434A7587e;
757     address public constant CURVE_CRV_ETH_POOL =
758         0x8301AE4fc9c624d1D396cbDAa1ed877821D7C511;
759     address public constant CURVE_CVX_ETH_POOL =
760         0xB576491F1E6e5E62f1d8F26062Ee822B40B0E0d4;
761     address public constant CURVE_CVXCRV_CRV_POOL =
762         0x9D0464996170c6B9e75eED71c68B99dDEDf279e8;
763 
764     address public constant CRV_TOKEN =
765         0xD533a949740bb3306d119CC777fa900bA034cd52;
766     address public constant CVXCRV_TOKEN =
767         0x62B9c7356A2Dc64a1969e19C23e4f579F9810Aa7;
768     address public constant CVX_TOKEN =
769         0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B;
770 
771     uint256 public constant CRVETH_ETH_INDEX = 0;
772     uint256 public constant CRVETH_CRV_INDEX = 1;
773     int128 public constant CVXCRV_CRV_INDEX = 0;
774     int128 public constant CVXCRV_CVXCRV_INDEX = 1;
775     uint256 public constant CVXETH_ETH_INDEX = 0;
776     uint256 public constant CVXETH_CVX_INDEX = 1;
777 
778     IBasicRewards cvxCrvStaking = IBasicRewards(CVXCRV_STAKING_CONTRACT);
779     ICurveV2Pool cvxEthSwap = ICurveV2Pool(CURVE_CVX_ETH_POOL);
780     ICurveV2Pool crvEthSwap = ICurveV2Pool(CURVE_CRV_ETH_POOL);
781     ICurveFactoryPool crvCvxCrvSwap = ICurveFactoryPool(CURVE_CVXCRV_CRV_POOL);
782 
783     /// @notice Swap CRV for cvxCRV on Curve
784     /// @param amount - amount to swap
785     /// @param recipient - where swapped tokens will be sent to
786     /// @return amount of CRV obtained after the swap
787     function _swapCrvToCvxCrv(uint256 amount, address recipient)
788         internal
789         returns (uint256)
790     {
791         return _crvToCvxCrv(amount, recipient, 0);
792     }
793 
794     /// @notice Swap CRV for cvxCRV on Curve
795     /// @param amount - amount to swap
796     /// @param recipient - where swapped tokens will be sent to
797     /// @param minAmountOut - minimum expected amount of output tokens
798     /// @return amount of CRV obtained after the swap
799     function _swapCrvToCvxCrv(
800         uint256 amount,
801         address recipient,
802         uint256 minAmountOut
803     ) internal returns (uint256) {
804         return _crvToCvxCrv(amount, recipient, minAmountOut);
805     }
806 
807     /// @notice Swap CRV for cvxCRV on Curve
808     /// @param amount - amount to swap
809     /// @param recipient - where swapped tokens will be sent to
810     /// @param minAmountOut - minimum expected amount of output tokens
811     /// @return amount of CRV obtained after the swap
812     function _crvToCvxCrv(
813         uint256 amount,
814         address recipient,
815         uint256 minAmountOut
816     ) internal returns (uint256) {
817         return
818             crvCvxCrvSwap.exchange(
819                 CVXCRV_CRV_INDEX,
820                 CVXCRV_CVXCRV_INDEX,
821                 amount,
822                 minAmountOut,
823                 recipient
824             );
825     }
826 
827     /// @notice Swap cvxCRV for CRV on Curve
828     /// @param amount - amount to swap
829     /// @param recipient - where swapped tokens will be sent to
830     /// @return amount of CRV obtained after the swap
831     function _swapCvxCrvToCrv(uint256 amount, address recipient)
832         internal
833         returns (uint256)
834     {
835         return _cvxCrvToCrv(amount, recipient, 0);
836     }
837 
838     /// @notice Swap cvxCRV for CRV on Curve
839     /// @param amount - amount to swap
840     /// @param recipient - where swapped tokens will be sent to
841     /// @param minAmountOut - minimum expected amount of output tokens
842     /// @return amount of CRV obtained after the swap
843     function _swapCvxCrvToCrv(
844         uint256 amount,
845         address recipient,
846         uint256 minAmountOut
847     ) internal returns (uint256) {
848         return _cvxCrvToCrv(amount, recipient, minAmountOut);
849     }
850 
851     /// @notice Swap cvxCRV for CRV on Curve
852     /// @param amount - amount to swap
853     /// @param recipient - where swapped tokens will be sent to
854     /// @param minAmountOut - minimum expected amount of output tokens
855     /// @return amount of CRV obtained after the swap
856     function _cvxCrvToCrv(
857         uint256 amount,
858         address recipient,
859         uint256 minAmountOut
860     ) internal returns (uint256) {
861         return
862             crvCvxCrvSwap.exchange(
863                 CVXCRV_CVXCRV_INDEX,
864                 CVXCRV_CRV_INDEX,
865                 amount,
866                 minAmountOut,
867                 recipient
868             );
869     }
870 
871     /// @notice Swap CRV for native ETH on Curve
872     /// @param amount - amount to swap
873     /// @return amount of ETH obtained after the swap
874     function _swapCrvToEth(uint256 amount) internal returns (uint256) {
875         return _crvToEth(amount, 0);
876     }
877 
878     /// @notice Swap CRV for native ETH on Curve
879     /// @param amount - amount to swap
880     /// @param minAmountOut - minimum expected amount of output tokens
881     /// @return amount of ETH obtained after the swap
882     function _swapCrvToEth(uint256 amount, uint256 minAmountOut)
883         internal
884         returns (uint256)
885     {
886         return _crvToEth(amount, minAmountOut);
887     }
888 
889     /// @notice Swap CRV for native ETH on Curve
890     /// @param amount - amount to swap
891     /// @param minAmountOut - minimum expected amount of output tokens
892     /// @return amount of ETH obtained after the swap
893     function _crvToEth(uint256 amount, uint256 minAmountOut)
894         internal
895         returns (uint256)
896     {
897         return
898             crvEthSwap.exchange_underlying{value: 0}(
899                 CRVETH_CRV_INDEX,
900                 CRVETH_ETH_INDEX,
901                 amount,
902                 minAmountOut
903             );
904     }
905 
906     /// @notice Swap native ETH for CRV on Curve
907     /// @param amount - amount to swap
908     /// @return amount of CRV obtained after the swap
909     function _swapEthToCrv(uint256 amount) internal returns (uint256) {
910         return _ethToCrv(amount, 0);
911     }
912 
913     /// @notice Swap native ETH for CRV on Curve
914     /// @param amount - amount to swap
915     /// @param minAmountOut - minimum expected amount of output tokens
916     /// @return amount of CRV obtained after the swap
917     function _swapEthToCrv(uint256 amount, uint256 minAmountOut)
918         internal
919         returns (uint256)
920     {
921         return _ethToCrv(amount, minAmountOut);
922     }
923 
924     /// @notice Swap native ETH for CRV on Curve
925     /// @param amount - amount to swap
926     /// @param minAmountOut - minimum expected amount of output tokens
927     /// @return amount of CRV obtained after the swap
928     function _ethToCrv(uint256 amount, uint256 minAmountOut)
929         internal
930         returns (uint256)
931     {
932         return
933             crvEthSwap.exchange_underlying{value: amount}(
934                 CRVETH_ETH_INDEX,
935                 CRVETH_CRV_INDEX,
936                 amount,
937                 minAmountOut
938             );
939     }
940 
941     /// @notice Swap native ETH for CVX on Curve
942     /// @param amount - amount to swap
943     /// @return amount of CRV obtained after the swap
944     function _swapEthToCvx(uint256 amount) internal returns (uint256) {
945         return _ethToCvx(amount, 0);
946     }
947 
948     /// @notice Swap native ETH for CVX on Curve
949     /// @param amount - amount to swap
950     /// @param minAmountOut - minimum expected amount of output tokens
951     /// @return amount of CRV obtained after the swap
952     function _swapEthToCvx(uint256 amount, uint256 minAmountOut)
953         internal
954         returns (uint256)
955     {
956         return _ethToCvx(amount, minAmountOut);
957     }
958 
959     /// @notice Swap native ETH for CVX on Curve
960     /// @param amount - amount to swap
961     /// @param minAmountOut - minimum expected amount of output tokens
962     /// @return amount of CRV obtained after the swap
963     function _ethToCvx(uint256 amount, uint256 minAmountOut)
964         internal
965         returns (uint256)
966     {
967         return
968             cvxEthSwap.exchange_underlying{value: amount}(
969                 CVXETH_ETH_INDEX,
970                 CVXETH_CVX_INDEX,
971                 amount,
972                 minAmountOut
973             );
974     }
975 
976     modifier notToZeroAddress(address _to) {
977         require(_to != address(0), "Invalid address!");
978         _;
979     }
980 }
981 
982 // File: ExtraZaps.sol
983 
984 contract ExtraZaps is Ownable, UnionBase {
985     using SafeERC20 for IERC20;
986 
987     address public immutable vault;
988     address private constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
989     address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
990     address private constant CVX = 0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B;
991 
992     address private constant TRICRYPTO =
993         0xD51a44d3FaE010294C616388b506AcdA1bfAAE46;
994     address private constant TRIPOOL =
995         0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
996     address private constant TRICRV =
997         0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490;
998     address private constant BOOSTER =
999         0xF403C135812408BFbE8713b5A23a04b3D48AAE31;
1000     address private constant CONVEX_TRIPOOL_TOKEN =
1001         0x30D9410ED1D5DA1F6C8391af5338C93ab8d4035C;
1002     address private constant CONVEX_TRIPOOL_REWARDS =
1003         0x689440f2Ff927E1f24c72F1087E1FAF471eCe1c8;
1004     address private constant CONVEX_LOCKER =
1005         0xD18140b4B819b895A3dba5442F959fA44994AF50;
1006 
1007     ICurveTriCrypto triCryptoSwap = ICurveTriCrypto(TRICRYPTO);
1008     ITriPool triPool = ITriPool(TRIPOOL);
1009     IBooster booster = IBooster(BOOSTER);
1010     IRewards triPoolRewards = IRewards(CONVEX_TRIPOOL_REWARDS);
1011     ICVXLocker locker = ICVXLocker(CONVEX_LOCKER);
1012     IMerkleDistributorV2 distributor;
1013 
1014     constructor(address _vault, address _distributor) {
1015         vault = _vault;
1016         distributor = IMerkleDistributorV2(_distributor);
1017     }
1018 
1019     function setApprovals() external {
1020         IERC20(TRICRV).safeApprove(BOOSTER, 0);
1021         IERC20(TRICRV).safeApprove(BOOSTER, type(uint256).max);
1022 
1023         IERC20(USDT).safeApprove(TRIPOOL, 0);
1024         IERC20(USDT).safeApprove(TRIPOOL, type(uint256).max);
1025 
1026         IERC20(CONVEX_TRIPOOL_TOKEN).safeApprove(CONVEX_TRIPOOL_REWARDS, 0);
1027         IERC20(CONVEX_TRIPOOL_TOKEN).safeApprove(
1028             CONVEX_TRIPOOL_REWARDS,
1029             type(uint256).max
1030         );
1031 
1032         IERC20(CRV_TOKEN).safeApprove(CURVE_CVXCRV_CRV_POOL, 0);
1033         IERC20(CRV_TOKEN).safeApprove(CURVE_CVXCRV_CRV_POOL, type(uint256).max);
1034 
1035         IERC20(CVXCRV_TOKEN).safeApprove(vault, 0);
1036         IERC20(CVXCRV_TOKEN).safeApprove(vault, type(uint256).max);
1037 
1038         IERC20(CVX).safeApprove(CONVEX_LOCKER, 0);
1039         IERC20(CVX).safeApprove(CONVEX_LOCKER, type(uint256).max);
1040     }
1041 
1042     /// @notice Retrieves user's uCRV and unstake to ETH
1043     /// @param amount - the amount of uCRV to unstake
1044     function _withdrawFromVaultAsEth(uint256 amount) internal {
1045         IERC20(vault).safeTransferFrom(msg.sender, address(this), amount);
1046         IUnionVault(vault).withdrawAllAs(
1047             address(this),
1048             IUnionVault.Option.ClaimAsETH
1049         );
1050     }
1051 
1052     /// @notice swap ETH to USDT via Curve's tricrypto
1053     /// @param amount - the amount of ETH to swap
1054     /// @param minAmountOut - the minimum amount expected
1055     function _swapEthToUsdt(
1056         uint256 amount,
1057         uint256 minAmountOut,
1058         address to
1059     ) internal {
1060         triCryptoSwap.exchange{value: amount}(
1061             2, // ETH
1062             0, // USDT
1063             amount,
1064             minAmountOut,
1065             true
1066         );
1067     }
1068 
1069     /// @notice Unstake from the Pounder to USDT
1070     /// @param amount - the amount of uCRV to unstake
1071     /// @param minAmountOut - the min expected amount of USDT to receive
1072     /// @param to - the adress that will receive the USDT
1073     /// @return amount of USDT obtained
1074     function claimFromVaultAsUsdt(
1075         uint256 amount,
1076         uint256 minAmountOut,
1077         address to
1078     ) public notToZeroAddress(to) returns (uint256) {
1079         _withdrawFromVaultAsEth(amount);
1080         _swapEthToUsdt(address(this).balance, minAmountOut, to);
1081         uint256 _usdtAmount = IERC20(USDT).balanceOf(address(this));
1082         if (to != address(this)) {
1083             IERC20(USDT).safeTransfer(to, _usdtAmount);
1084         }
1085         return _usdtAmount;
1086     }
1087 
1088     /// @notice Claim from the distributor, unstake and returns USDT.
1089     /// @param index - claimer index
1090     /// @param account - claimer account
1091     /// @param amount - claim amount
1092     /// @param merkleProof - merkle proof for the claim
1093     /// @param minAmountOut - the min expected amount of USDT to receive
1094     /// @param to - the adress that will receive the USDT
1095     /// @return amount of USDT obtained
1096     function claimFromDistributorAsUsdt(
1097         uint256 index,
1098         address account,
1099         uint256 amount,
1100         bytes32[] calldata merkleProof,
1101         uint256 minAmountOut,
1102         address to
1103     ) external notToZeroAddress(to) returns (uint256) {
1104         distributor.claim(index, account, amount, merkleProof);
1105         return claimFromVaultAsUsdt(amount, minAmountOut, to);
1106     }
1107 
1108     /// @notice Unstake from the Pounder to stables and stake on 3pool convex for yield
1109     /// @param amount - amount of uCRV to unstake
1110     /// @param minAmountOut - minimum amount of 3CRV (NOT USDT!)
1111     /// @param to - address on behalf of which to stake
1112     function claimFromVaultAndStakeIn3PoolConvex(
1113         uint256 amount,
1114         uint256 minAmountOut,
1115         address to
1116     ) public notToZeroAddress(to) {
1117         // claim as USDT
1118         uint256 _usdtAmount = claimFromVaultAsUsdt(amount, 0, address(this));
1119         // add USDT to Tripool
1120         triPool.add_liquidity([0, 0, _usdtAmount], minAmountOut);
1121         // deposit on Convex
1122         booster.depositAll(9, false);
1123         // stake on behalf of user
1124         triPoolRewards.stakeFor(
1125             to,
1126             IERC20(CONVEX_TRIPOOL_TOKEN).balanceOf(address(this))
1127         );
1128     }
1129 
1130     /// @notice Claim from the distributor, unstake and deposits in 3pool.
1131     /// @param index - claimer index
1132     /// @param account - claimer account
1133     /// @param amount - claim amount
1134     /// @param merkleProof - merkle proof for the claim
1135     /// @param minAmountOut - minimum amount of 3CRV (NOT USDT!)
1136     /// @param to - address on behalf of which to stake
1137     function claimFromDistributorAndStakeIn3PoolConvex(
1138         uint256 index,
1139         address account,
1140         uint256 amount,
1141         bytes32[] calldata merkleProof,
1142         uint256 minAmountOut,
1143         address to
1144     ) external notToZeroAddress(to) {
1145         distributor.claim(index, account, amount, merkleProof);
1146         claimFromVaultAndStakeIn3PoolConvex(amount, minAmountOut, to);
1147     }
1148 
1149     /// @notice Claim to any token via a univ2 router
1150     /// @notice Use at your own risk
1151     /// @param amount - amount of uCRV to unstake
1152     /// @param minAmountOut - min amount of output token expected
1153     /// @param router - address of the router to use. e.g. 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F for Sushi
1154     /// @param outputToken - address of the token to swap to
1155     /// @param to - address of the final recipient of the swapped tokens
1156     function claimFromVaultViaUniV2EthPair(
1157         uint256 amount,
1158         uint256 minAmountOut,
1159         address router,
1160         address outputToken,
1161         address to
1162     ) public notToZeroAddress(to) {
1163         require(router != address(0));
1164         _withdrawFromVaultAsEth(amount);
1165         address[] memory _path = new address[](2);
1166         _path[0] = WETH;
1167         _path[1] = outputToken;
1168         IUniV2Router(router).swapExactETHForTokens{
1169             value: address(this).balance
1170         }(minAmountOut, _path, to, block.timestamp + 60);
1171     }
1172 
1173     /// @notice Claim to any token via a univ2 router
1174     /// @notice Use at your own risk
1175     /// @param amount - amount of uCRV to unstake
1176     /// @param minAmountOut - min amount of output token expected
1177     /// @param router - address of the router to use. e.g. 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F for Sushi
1178     /// @param outputToken - address of the token to swap to
1179     /// @param to - address of the final recipient of the swapped tokens
1180     function claimFromDistributorViaUniV2EthPair(
1181         uint256 index,
1182         address account,
1183         uint256 amount,
1184         bytes32[] calldata merkleProof,
1185         uint256 minAmountOut,
1186         address router,
1187         address outputToken,
1188         address to
1189     ) external notToZeroAddress(to) {
1190         distributor.claim(index, account, amount, merkleProof);
1191         claimFromVaultViaUniV2EthPair(
1192             amount,
1193             minAmountOut,
1194             router,
1195             outputToken,
1196             to
1197         );
1198     }
1199 
1200     /// @notice Unstake from the Pounder as CVX and locks it
1201     /// @param amount - amount of uCRV to unstake
1202     /// @param minAmountOut - min amount of CVX expected
1203     /// @param to - address to lock on behalf of
1204     function claimFromVaultAsCvxAndLock(
1205         uint256 amount,
1206         uint256 minAmountOut,
1207         address to
1208     ) public notToZeroAddress(to) {
1209         IERC20(vault).safeTransferFrom(msg.sender, address(this), amount);
1210         IUnionVault(vault).withdrawAllAs(
1211             address(this),
1212             IUnionVault.Option.ClaimAsCVX,
1213             minAmountOut
1214         );
1215         locker.lock(to, IERC20(CVX).balanceOf(address(this)), 0);
1216     }
1217 
1218     /// @notice Claim from the distributor, unstake to CVX and lock.
1219     /// @param index - claimer index
1220     /// @param account - claimer account
1221     /// @param amount - claim amount
1222     /// @param merkleProof - merkle proof for the claim
1223     /// @param minAmountOut - min amount of CVX expected
1224     /// @param to - address to lock on behalf of
1225     function claimFromDistributorAsCvxAndLock(
1226         uint256 index,
1227         address account,
1228         uint256 amount,
1229         bytes32[] calldata merkleProof,
1230         uint256 minAmountOut,
1231         address to
1232     ) external notToZeroAddress(to) {
1233         distributor.claim(index, account, amount, merkleProof);
1234         claimFromVaultAsCvxAndLock(amount, minAmountOut, to);
1235     }
1236 
1237     /// @notice Deposit into the pounder from ETH
1238     /// @param minAmountOut - min amount of cvxCRV expected
1239     /// @param to - address to stake on behalf of
1240     function depositFromEth(uint256 minAmountOut, address to)
1241         external
1242         payable
1243         notToZeroAddress(to)
1244     {
1245         require(msg.value > 0, "cheap");
1246         _depositFromEth(msg.value, minAmountOut, to);
1247     }
1248 
1249     /// @notice Internal function to deposit ETH to the pounder
1250     /// @param amount - amount of ETH
1251     /// @param minAmountOut - min amount of cvxCRV expected
1252     /// @param to - address to stake on behalf of
1253     function _depositFromEth(
1254         uint256 amount,
1255         uint256 minAmountOut,
1256         address to
1257     ) internal {
1258         uint256 _crvAmount = _swapEthToCrv(amount);
1259         uint256 _cvxCrvAmount = _swapCrvToCvxCrv(
1260             _crvAmount,
1261             address(this),
1262             minAmountOut
1263         );
1264         IUnionVault(vault).deposit(to, _cvxCrvAmount);
1265     }
1266 
1267     /// @notice Deposit into the pounder from CRV
1268     /// @param minAmountOut - min amount of cvxCRV expected
1269     /// @param to - address to stake on behalf of
1270     function depositFromCrv(
1271         uint256 amount,
1272         uint256 minAmountOut,
1273         address to
1274     ) external notToZeroAddress(to) {
1275         IERC20(CRV_TOKEN).safeTransferFrom(msg.sender, address(this), amount);
1276         uint256 _cvxCrvAmount = _swapCrvToCvxCrv(
1277             amount,
1278             address(this),
1279             minAmountOut
1280         );
1281         IUnionVault(vault).deposit(to, _cvxCrvAmount);
1282     }
1283 
1284     /// @notice Deposit into the pounder from any token via Uni interface
1285     /// @notice Use at your own risk
1286     /// @dev Zap contract needs approval for spending of inputToken
1287     /// @param amount - min amount of input token
1288     /// @param minAmountOut - min amount of cvxCRV expected
1289     /// @param router - address of the router to use. e.g. 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F for Sushi
1290     /// @param inputToken - address of the token to swap from, needs to have an ETH pair on router used
1291     /// @param to - address to stake on behalf of
1292     function depositViaUniV2EthPair(
1293         uint256 amount,
1294         uint256 minAmountOut,
1295         address router,
1296         address inputToken,
1297         address to
1298     ) external notToZeroAddress(to) {
1299         require(router != address(0));
1300 
1301         IERC20(inputToken).safeTransferFrom(msg.sender, address(this), amount);
1302         address[] memory _path = new address[](2);
1303         _path[0] = inputToken;
1304         _path[1] = WETH;
1305 
1306         IERC20(inputToken).safeApprove(router, 0);
1307         IERC20(inputToken).safeApprove(router, amount);
1308 
1309         IUniV2Router(router).swapExactTokensForETH(
1310             amount,
1311             1,
1312             _path,
1313             address(this),
1314             block.timestamp + 1
1315         );
1316         _depositFromEth(address(this).balance, minAmountOut, to);
1317     }
1318 
1319     /// @notice Execute calls on behalf of contract
1320     /// (for instance to retrieve locked tokens)
1321     function execute(
1322         address _to,
1323         uint256 _value,
1324         bytes calldata _data
1325     ) external onlyOwner returns (bool, bytes memory) {
1326         (bool success, bytes memory result) = _to.call{value: _value}(_data);
1327         return (success, result);
1328     }
1329 
1330     receive() external payable {}
1331 }
