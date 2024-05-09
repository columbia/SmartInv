1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4 
5 
6 
7 // Part: ICurveV2Pool
8 
9 interface ICurveV2Pool {
10     function get_dy(
11         uint256 i,
12         uint256 j,
13         uint256 dx
14     ) external view returns (uint256);
15 
16     function calc_token_amount(uint256[2] calldata amounts)
17         external
18         view
19         returns (uint256);
20 
21     function exchange_underlying(
22         uint256 i,
23         uint256 j,
24         uint256 dx,
25         uint256 min_dy
26     ) external payable returns (uint256);
27 
28     function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount)
29         external
30         returns (uint256);
31 
32     function lp_price() external view returns (uint256);
33 
34     function price_oracle() external view returns (uint256);
35 
36     function remove_liquidity_one_coin(
37         uint256 token_amount,
38         uint256 i,
39         uint256 min_amount,
40         bool use_eth,
41         address receiver
42     ) external returns (uint256);
43 }
44 
45 // Part: IGenericVault
46 
47 interface IGenericVault {
48     function withdraw(address _to, uint256 _shares)
49         external
50         returns (uint256 withdrawn);
51 
52     function withdrawAll(address _to) external returns (uint256 withdrawn);
53 
54     function depositAll(address _to) external returns (uint256 _shares);
55 
56     function deposit(address _to, uint256 _amount)
57         external
58         returns (uint256 _shares);
59 
60     function harvest() external;
61 
62     function balanceOfUnderlying(address user)
63         external
64         view
65         returns (uint256 amount);
66 
67     function totalUnderlying() external view returns (uint256 total);
68 
69     function totalSupply() external view returns (uint256 total);
70 
71     function underlying() external view returns (address);
72 
73     function strategy() external view returns (address);
74 
75     function platform() external view returns (address);
76 
77     function setPlatform(address _platform) external;
78 
79     function setPlatformFee(uint256 _fee) external;
80 
81     function setCallIncentive(uint256 _incentive) external;
82 
83     function setWithdrawalPenalty(uint256 _penalty) external;
84 
85     function setApprovals() external;
86 
87     function callIncentive() external view returns (uint256);
88 
89     function platformFee() external view returns (uint256);
90 }
91 
92 // Part: IVaultZaps
93 
94 interface IVaultZaps {
95     function depositFromUnderlyingAssets(
96         uint256[2] calldata amounts,
97         uint256 minAmountOut,
98         address to
99     ) external;
100 }
101 
102 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Address
103 
104 /**
105  * @dev Collection of functions related to the address type
106  */
107 library Address {
108     /**
109      * @dev Returns true if `account` is a contract.
110      *
111      * [IMPORTANT]
112      * ====
113      * It is unsafe to assume that an address for which this function returns
114      * false is an externally-owned account (EOA) and not a contract.
115      *
116      * Among others, `isContract` will return false for the following
117      * types of addresses:
118      *
119      *  - an externally-owned account
120      *  - a contract in construction
121      *  - an address where a contract will be created
122      *  - an address where a contract lived, but was destroyed
123      * ====
124      */
125     function isContract(address account) internal view returns (bool) {
126         // This method relies on extcodesize, which returns 0 for contracts in
127         // construction, since the code is only stored at the end of the
128         // constructor execution.
129 
130         uint256 size;
131         // solhint-disable-next-line no-inline-assembly
132         assembly { size := extcodesize(account) }
133         return size > 0;
134     }
135 
136     /**
137      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
138      * `recipient`, forwarding all available gas and reverting on errors.
139      *
140      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
141      * of certain opcodes, possibly making contracts go over the 2300 gas limit
142      * imposed by `transfer`, making them unable to receive funds via
143      * `transfer`. {sendValue} removes this limitation.
144      *
145      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
146      *
147      * IMPORTANT: because control is transferred to `recipient`, care must be
148      * taken to not create reentrancy vulnerabilities. Consider using
149      * {ReentrancyGuard} or the
150      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
151      */
152     function sendValue(address payable recipient, uint256 amount) internal {
153         require(address(this).balance >= amount, "Address: insufficient balance");
154 
155         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
156         (bool success, ) = recipient.call{ value: amount }("");
157         require(success, "Address: unable to send value, recipient may have reverted");
158     }
159 
160     /**
161      * @dev Performs a Solidity function call using a low level `call`. A
162      * plain`call` is an unsafe replacement for a function call: use this
163      * function instead.
164      *
165      * If `target` reverts with a revert reason, it is bubbled up by this
166      * function (like regular Solidity function calls).
167      *
168      * Returns the raw returned data. To convert to the expected return value,
169      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
170      *
171      * Requirements:
172      *
173      * - `target` must be a contract.
174      * - calling `target` with `data` must not revert.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
179       return functionCall(target, data, "Address: low-level call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
184      * `errorMessage` as a fallback revert reason when `target` reverts.
185      *
186      * _Available since v3.1._
187      */
188     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, 0, errorMessage);
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
194      * but also transferring `value` wei to `target`.
195      *
196      * Requirements:
197      *
198      * - the calling contract must have an ETH balance of at least `value`.
199      * - the called Solidity function must be `payable`.
200      *
201      * _Available since v3.1._
202      */
203     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
204         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
209      * with `errorMessage` as a fallback revert reason when `target` reverts.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         // solhint-disable-next-line avoid-low-level-calls
218         (bool success, bytes memory returndata) = target.call{ value: value }(data);
219         return _verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but performing a static call.
225      *
226      * _Available since v3.3._
227      */
228     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
229         return functionStaticCall(target, data, "Address: low-level static call failed");
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
239         require(isContract(target), "Address: static call to non-contract");
240 
241         // solhint-disable-next-line avoid-low-level-calls
242         (bool success, bytes memory returndata) = target.staticcall(data);
243         return _verifyCallResult(success, returndata, errorMessage);
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
248      * but performing a delegate call.
249      *
250      * _Available since v3.4._
251      */
252     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
253         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
263         require(isContract(target), "Address: delegate call to non-contract");
264 
265         // solhint-disable-next-line avoid-low-level-calls
266         (bool success, bytes memory returndata) = target.delegatecall(data);
267         return _verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
271         if (success) {
272             return returndata;
273         } else {
274             // Look for revert reason and bubble it up if present
275             if (returndata.length > 0) {
276                 // The easiest way to bubble the revert reason is using memory via assembly
277 
278                 // solhint-disable-next-line no-inline-assembly
279                 assembly {
280                     let returndata_size := mload(returndata)
281                     revert(add(32, returndata), returndata_size)
282                 }
283             } else {
284                 revert(errorMessage);
285             }
286         }
287     }
288 }
289 
290 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/IERC20
291 
292 /**
293  * @dev Interface of the ERC20 standard as defined in the EIP.
294  */
295 interface IERC20 {
296     /**
297      * @dev Returns the amount of tokens in existence.
298      */
299     function totalSupply() external view returns (uint256);
300 
301     /**
302      * @dev Returns the amount of tokens owned by `account`.
303      */
304     function balanceOf(address account) external view returns (uint256);
305 
306     /**
307      * @dev Moves `amount` tokens from the caller's account to `recipient`.
308      *
309      * Returns a boolean value indicating whether the operation succeeded.
310      *
311      * Emits a {Transfer} event.
312      */
313     function transfer(address recipient, uint256 amount) external returns (bool);
314 
315     /**
316      * @dev Returns the remaining number of tokens that `spender` will be
317      * allowed to spend on behalf of `owner` through {transferFrom}. This is
318      * zero by default.
319      *
320      * This value changes when {approve} or {transferFrom} are called.
321      */
322     function allowance(address owner, address spender) external view returns (uint256);
323 
324     /**
325      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * IMPORTANT: Beware that changing an allowance with this method brings the risk
330      * that someone may use both the old and the new allowance by unfortunate
331      * transaction ordering. One possible solution to mitigate this race
332      * condition is to first reduce the spender's allowance to 0 and set the
333      * desired value afterwards:
334      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
335      *
336      * Emits an {Approval} event.
337      */
338     function approve(address spender, uint256 amount) external returns (bool);
339 
340     /**
341      * @dev Moves `amount` tokens from `sender` to `recipient` using the
342      * allowance mechanism. `amount` is then deducted from the caller's
343      * allowance.
344      *
345      * Returns a boolean value indicating whether the operation succeeded.
346      *
347      * Emits a {Transfer} event.
348      */
349     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
350 
351     /**
352      * @dev Emitted when `value` tokens are moved from one account (`from`) to
353      * another (`to`).
354      *
355      * Note that `value` may be zero.
356      */
357     event Transfer(address indexed from, address indexed to, uint256 value);
358 
359     /**
360      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
361      * a call to {approve}. `value` is the new allowance.
362      */
363     event Approval(address indexed owner, address indexed spender, uint256 value);
364 }
365 
366 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/MerkleProof
367 
368 /**
369  * @dev These functions deal with verification of Merkle Trees proofs.
370  *
371  * The proofs can be generated using the JavaScript library
372  * https://github.com/miguelmota/merkletreejs[merkletreejs].
373  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
374  *
375  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
376  */
377 library MerkleProof {
378     /**
379      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
380      * defined by `root`. For this, a `proof` must be provided, containing
381      * sibling hashes on the branch from the leaf to the root of the tree. Each
382      * pair of leaves and each pair of pre-images are assumed to be sorted.
383      */
384     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
385         bytes32 computedHash = leaf;
386 
387         for (uint256 i = 0; i < proof.length; i++) {
388             bytes32 proofElement = proof[i];
389 
390             if (computedHash <= proofElement) {
391                 // Hash(current computed hash + current element of the proof)
392                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
393             } else {
394                 // Hash(current element of the proof + current computed hash)
395                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
396             }
397         }
398 
399         // Check if the computed hash (root) is equal to the provided root
400         return computedHash == root;
401     }
402 }
403 
404 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/SafeERC20
405 
406 /**
407  * @title SafeERC20
408  * @dev Wrappers around ERC20 operations that throw on failure (when the token
409  * contract returns false). Tokens that return no value (and instead revert or
410  * throw on failure) are also supported, non-reverting calls are assumed to be
411  * successful.
412  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
413  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
414  */
415 library SafeERC20 {
416     using Address for address;
417 
418     function safeTransfer(IERC20 token, address to, uint256 value) internal {
419         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
420     }
421 
422     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
423         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
424     }
425 
426     /**
427      * @dev Deprecated. This function has issues similar to the ones found in
428      * {IERC20-approve}, and its usage is discouraged.
429      *
430      * Whenever possible, use {safeIncreaseAllowance} and
431      * {safeDecreaseAllowance} instead.
432      */
433     function safeApprove(IERC20 token, address spender, uint256 value) internal {
434         // safeApprove should only be called when setting an initial allowance,
435         // or when resetting it to zero. To increase and decrease it, use
436         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
437         // solhint-disable-next-line max-line-length
438         require((value == 0) || (token.allowance(address(this), spender) == 0),
439             "SafeERC20: approve from non-zero to non-zero allowance"
440         );
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
442     }
443 
444     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
445         uint256 newAllowance = token.allowance(address(this), spender) + value;
446         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
447     }
448 
449     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
450         unchecked {
451             uint256 oldAllowance = token.allowance(address(this), spender);
452             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
453             uint256 newAllowance = oldAllowance - value;
454             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
455         }
456     }
457 
458     /**
459      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
460      * on the return value: the return value is optional (but if data is returned, it must not be false).
461      * @param token The token targeted by the call.
462      * @param data The call data (encoded using abi.encode or one of its variants).
463      */
464     function _callOptionalReturn(IERC20 token, bytes memory data) private {
465         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
466         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
467         // the target address contains contract code and also asserts for success in the low-level call.
468 
469         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
470         if (returndata.length > 0) { // Return data is optional
471             // solhint-disable-next-line max-line-length
472             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
473         }
474     }
475 }
476 
477 // Part: GenericDistributor
478 
479 // Allows anyone to claim a token if they exist in a merkle root.
480 contract GenericDistributor {
481     using SafeERC20 for IERC20;
482 
483     address public vault;
484     address public token;
485     bytes32 public merkleRoot;
486     uint32 public week;
487     bool public frozen;
488 
489     address public admin;
490     address public depositor;
491 
492     // This is a packed array of booleans.
493     mapping(uint256 => mapping(uint256 => uint256)) private claimedBitMap;
494 
495     // This event is triggered whenever a call to #claim succeeds.
496     event Claimed(
497         uint256 index,
498         uint256 indexed amount,
499         address indexed account,
500         uint256 week
501     );
502     // This event is triggered whenever the merkle root gets updated.
503     event MerkleRootUpdated(bytes32 indexed merkleRoot, uint32 indexed week);
504     // This event is triggered whenever the admin is updated.
505     event AdminUpdated(address indexed oldAdmin, address indexed newAdmin);
506     // This event is triggered whenever the depositor contract is updated.
507     event DepositorUpdated(
508         address indexed oldDepositor,
509         address indexed newDepositor
510     );
511     // This event is triggered whenever the vault contract is updated.
512     event VaultUpdated(address indexed oldVault, address indexed newVault);
513     // When recovering stuck ERC20s
514     event Recovered(address token, uint256 amount);
515 
516     constructor(
517         address _vault,
518         address _depositor,
519         address _token
520     ) {
521         require(_vault != address(0));
522         vault = _vault;
523         admin = msg.sender;
524         depositor = _depositor;
525         token = _token;
526         week = 0;
527         frozen = true;
528     }
529 
530     /// @notice Set approvals for the tokens used when swapping
531     function setApprovals() external virtual onlyAdmin {
532         IERC20(token).safeApprove(vault, 0);
533         IERC20(token).safeApprove(vault, type(uint256).max);
534     }
535 
536     /// @notice Check if the index has been marked as claimed.
537     /// @param index - the index to check
538     /// @return true if index has been marked as claimed.
539     function isClaimed(uint256 index) public view returns (bool) {
540         uint256 claimedWordIndex = index / 256;
541         uint256 claimedBitIndex = index % 256;
542         uint256 claimedWord = claimedBitMap[week][claimedWordIndex];
543         uint256 mask = (1 << claimedBitIndex);
544         return claimedWord & mask == mask;
545     }
546 
547     function _setClaimed(uint256 index) private {
548         uint256 claimedWordIndex = index / 256;
549         uint256 claimedBitIndex = index % 256;
550         claimedBitMap[week][claimedWordIndex] =
551             claimedBitMap[week][claimedWordIndex] |
552             (1 << claimedBitIndex);
553     }
554 
555     /// @notice Transfers ownership of the contract
556     /// @param newAdmin - address of the new admin of the contract
557     function updateAdmin(address newAdmin)
558         external
559         onlyAdmin
560         notToZeroAddress(newAdmin)
561     {
562         address oldAdmin = admin;
563         admin = newAdmin;
564         emit AdminUpdated(oldAdmin, newAdmin);
565     }
566 
567     /// @notice Changes the contract allowed to freeze before depositing
568     /// @param newDepositor - address of the new depositor contract
569     function updateDepositor(address newDepositor)
570         external
571         onlyAdmin
572         notToZeroAddress(newDepositor)
573     {
574         address oldDepositor = depositor;
575         depositor = newDepositor;
576         emit DepositorUpdated(oldDepositor, newDepositor);
577     }
578 
579     /// @notice Changes the Vault where funds are staked
580     /// @param newVault - address of the new vault contract
581     function updateVault(address newVault)
582         external
583         onlyAdmin
584         notToZeroAddress(newVault)
585     {
586         address oldVault = vault;
587         vault = newVault;
588         emit VaultUpdated(oldVault, newVault);
589     }
590 
591     /// @notice Internal function to handle users' claims
592     /// @param index - claimer index
593     /// @param account - claimer account
594     /// @param amount - claim amount
595     /// @param merkleProof - merkle proof for the claim
596     function _claim(
597         uint256 index,
598         address account,
599         uint256 amount,
600         bytes32[] calldata merkleProof
601     ) internal {
602         require(!frozen, "Claiming is frozen.");
603         require(!isClaimed(index), "Drop already claimed.");
604 
605         // Verify the merkle proof.
606         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
607         require(
608             MerkleProof.verify(merkleProof, merkleRoot, node),
609             "Invalid proof."
610         );
611 
612         // Mark it claimed and send the token.
613         _setClaimed(index);
614     }
615 
616     /// @notice Claim the given amount of uCRV to the given address.
617     /// @param index - claimer index
618     /// @param account - claimer account
619     /// @param amount - claim amount
620     /// @param merkleProof - merkle proof for the claim
621     function claim(
622         uint256 index,
623         address account,
624         uint256 amount,
625         bytes32[] calldata merkleProof
626     ) external {
627         // Claim
628         _claim(index, account, amount, merkleProof);
629 
630         // Send shares to account
631         IERC20(vault).safeTransfer(account, amount);
632 
633         emit Claimed(index, amount, account, week);
634     }
635 
636     /// @notice Stakes the contract's entire balance in the Vault
637     function stake() external virtual onlyAdminOrDistributor {
638         IGenericVault(vault).depositAll(address(this));
639     }
640 
641     /// @notice Freezes the claim function to allow the merkleRoot to be changed
642     /// @dev Can be called by the owner or the depositor zap contract
643     function freeze() external onlyAdminOrDistributor {
644         frozen = true;
645     }
646 
647     /// @notice Unfreezes the claim function.
648     function unfreeze() public onlyAdmin {
649         frozen = false;
650     }
651 
652     /// @notice Update the merkle root and increment the week.
653     /// @param _merkleRoot - the new root to push
654     /// @param _unfreeze - whether to unfreeze the contract after unlock
655     function updateMerkleRoot(bytes32 _merkleRoot, bool _unfreeze)
656         external
657         onlyAdmin
658     {
659         require(frozen, "Contract not frozen.");
660 
661         // Increment the week (simulates the clearing of the claimedBitMap)
662         week = week + 1;
663         // Set the new merkle root
664         merkleRoot = _merkleRoot;
665 
666         emit MerkleRootUpdated(merkleRoot, week);
667 
668         if (_unfreeze) {
669             unfreeze();
670         }
671     }
672 
673     /// @notice Recover ERC20s mistakenly sent to the contract
674     /// @param tokenAddress - address of the token to retrieve
675     /// @param tokenAmount - amount to retrieve
676     /// @dev Will revert if token is same as token being distributed
677     function recoverERC20(address tokenAddress, uint256 tokenAmount)
678         external
679         onlyAdmin
680     {
681         require(
682             tokenAddress != address(token),
683             "Cannot withdraw the distributed token"
684         );
685         IERC20(tokenAddress).safeTransfer(msg.sender, tokenAmount);
686         emit Recovered(tokenAddress, tokenAmount);
687     }
688 
689     receive() external payable {}
690 
691     modifier onlyAdmin() {
692         require(msg.sender == admin, "Admin only");
693         _;
694     }
695 
696     modifier onlyAdminOrDistributor() {
697         require(
698             (msg.sender == admin) || (msg.sender == depositor),
699             "Admin or depositor only"
700         );
701         _;
702     }
703 
704     modifier notToZeroAddress(address _to) {
705         require(_to != address(0), "Invalid address!");
706         _;
707     }
708 }
709 
710 // File: FXSDistributor.sol
711 
712 contract FXSMerkleDistributor is GenericDistributor {
713     using SafeERC20 for IERC20;
714 
715     address public vaultZap;
716 
717     address private constant FXS_TOKEN =
718         0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0;
719 
720     address private constant CURVE_CVXFXS_FXS_POOL =
721         0xd658A338613198204DCa1143Ac3F01A722b5d94A;
722     address private constant CURVE_FXS_ETH_POOL =
723         0x941Eb6F616114e4Ecaa85377945EA306002612FE;
724 
725     // 2.5% slippage tolerance by default
726     uint256 public slippage = 9750;
727     uint256 private constant DECIMALS = 10000;
728 
729     ICurveV2Pool private cvxFxsPool = ICurveV2Pool(CURVE_CVXFXS_FXS_POOL);
730     ICurveV2Pool private ethFxsPool = ICurveV2Pool(CURVE_FXS_ETH_POOL);
731 
732     // This event is triggered whenever the zap contract is updated.
733     event ZapUpdated(address indexed oldZap, address indexed newZap);
734 
735     constructor(
736         address _vault,
737         address _depositor,
738         address _zap
739     ) GenericDistributor(_vault, _depositor, FXS_TOKEN) {
740         require(_zap != address(0));
741         vaultZap = _zap;
742     }
743 
744     /// @notice Changes the Zap for deposits
745     /// @param newZap - address of the new zap
746     function updateZap(address newZap)
747         external
748         onlyAdmin
749         notToZeroAddress(newZap)
750     {
751         address oldZap = vaultZap;
752         vaultZap = newZap;
753         emit ZapUpdated(oldZap, vaultZap);
754     }
755 
756     /// @notice Set approvals for the tokens used when swapping
757     function setApprovals() external override onlyAdmin {
758         IERC20(token).safeApprove(vaultZap, 0);
759         IERC20(token).safeApprove(vaultZap, type(uint256).max);
760     }
761 
762     /// @notice Set the acceptable level of slippage for LP deposits
763     /// @dev As percentage of the ETH value of original amount in BIPS
764     /// @param _slippage - the acceptable slippage threshold
765     function setSlippage(uint256 _slippage) external onlyAdmin {
766         slippage = _slippage;
767     }
768 
769     /// @notice Calculates the minimum amount of LP tokens we want to receive
770     /// @dev Uses Curve's estimation of received LP tokens & price oracles
771     /// @param _amount - the amount of FXS tokens to deposit
772     /// @return a min amount we can use to guarantee < x% slippage
773     function _calcLPMinAmountOut(uint256 _amount) internal returns (uint256) {
774         uint256 _receivedLPTokens = (cvxFxsPool.calc_token_amount(
775             [_amount, 0]
776         ) * 9900) / DECIMALS;
777         uint256 _lpTokenFxsPrice = (_receivedLPTokens * cvxFxsPool.lp_price()) /
778             1e18;
779         uint256 _fxsEthPrice = ethFxsPool.price_oracle();
780         uint256 _lpTokenEthPrice = (_lpTokenFxsPrice * _fxsEthPrice) / 1e18;
781         uint256 _amountEthPrice = (_amount * _fxsEthPrice) / 1e18;
782         // ensure we're not getting more than x% slippage on ETH value
783         require(
784             _lpTokenEthPrice > ((_amountEthPrice * slippage) / DECIMALS),
785             "slippage"
786         );
787         return _receivedLPTokens;
788     }
789 
790     /// @notice Stakes the contract's entire cvxCRV balance in the Vault
791     function stake() external override onlyAdminOrDistributor {
792         uint256 _balance = IERC20(FXS_TOKEN).balanceOf(address(this));
793         IVaultZaps(vaultZap).depositFromUnderlyingAssets(
794             [_balance, 0],
795             _calcLPMinAmountOut(_balance),
796             address(this)
797         );
798     }
799 }
