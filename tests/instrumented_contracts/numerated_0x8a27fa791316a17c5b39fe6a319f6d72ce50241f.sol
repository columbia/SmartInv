1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.1.0
4 
5 // SPDX-License-Identifier: MIT AND UNLICENSED
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Collection of functions related to the address type
90  */
91 library Address {
92     /**
93      * @dev Returns true if `account` is a contract.
94      *
95      * [IMPORTANT]
96      * ====
97      * It is unsafe to assume that an address for which this function returns
98      * false is an externally-owned account (EOA) and not a contract.
99      *
100      * Among others, `isContract` will return false for the following
101      * types of addresses:
102      *
103      *  - an externally-owned account
104      *  - a contract in construction
105      *  - an address where a contract will be created
106      *  - an address where a contract lived, but was destroyed
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // This method relies on extcodesize, which returns 0 for contracts in
111         // construction, since the code is only stored at the end of the
112         // constructor execution.
113 
114         uint256 size;
115         // solhint-disable-next-line no-inline-assembly
116         assembly { size := extcodesize(account) }
117         return size > 0;
118     }
119 
120     /**
121      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
122      * `recipient`, forwarding all available gas and reverting on errors.
123      *
124      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
125      * of certain opcodes, possibly making contracts go over the 2300 gas limit
126      * imposed by `transfer`, making them unable to receive funds via
127      * `transfer`. {sendValue} removes this limitation.
128      *
129      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
130      *
131      * IMPORTANT: because control is transferred to `recipient`, care must be
132      * taken to not create reentrancy vulnerabilities. Consider using
133      * {ReentrancyGuard} or the
134      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
135      */
136     function sendValue(address payable recipient, uint256 amount) internal {
137         require(address(this).balance >= amount, "Address: insufficient balance");
138 
139         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
140         (bool success, ) = recipient.call{ value: amount }("");
141         require(success, "Address: unable to send value, recipient may have reverted");
142     }
143 
144     /**
145      * @dev Performs a Solidity function call using a low level `call`. A
146      * plain`call` is an unsafe replacement for a function call: use this
147      * function instead.
148      *
149      * If `target` reverts with a revert reason, it is bubbled up by this
150      * function (like regular Solidity function calls).
151      *
152      * Returns the raw returned data. To convert to the expected return value,
153      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
154      *
155      * Requirements:
156      *
157      * - `target` must be a contract.
158      * - calling `target` with `data` must not revert.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
163       return functionCall(target, data, "Address: low-level call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
168      * `errorMessage` as a fallback revert reason when `target` reverts.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
173         return functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but also transferring `value` wei to `target`.
179      *
180      * Requirements:
181      *
182      * - the calling contract must have an ETH balance of at least `value`.
183      * - the called Solidity function must be `payable`.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
193      * with `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
198         require(address(this).balance >= value, "Address: insufficient balance for call");
199         require(isContract(target), "Address: call to non-contract");
200 
201         // solhint-disable-next-line avoid-low-level-calls
202         (bool success, bytes memory returndata) = target.call{ value: value }(data);
203         return _verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
208      * but performing a static call.
209      *
210      * _Available since v3.3._
211      */
212     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
213         return functionStaticCall(target, data, "Address: low-level static call failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
218      * but performing a static call.
219      *
220      * _Available since v3.3._
221      */
222     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
223         require(isContract(target), "Address: static call to non-contract");
224 
225         // solhint-disable-next-line avoid-low-level-calls
226         (bool success, bytes memory returndata) = target.staticcall(data);
227         return _verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
232      * but performing a delegate call.
233      *
234      * _Available since v3.4._
235      */
236     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
237         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
247         require(isContract(target), "Address: delegate call to non-contract");
248 
249         // solhint-disable-next-line avoid-low-level-calls
250         (bool success, bytes memory returndata) = target.delegatecall(data);
251         return _verifyCallResult(success, returndata, errorMessage);
252     }
253 
254     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
255         if (success) {
256             return returndata;
257         } else {
258             // Look for revert reason and bubble it up if present
259             if (returndata.length > 0) {
260                 // The easiest way to bubble the revert reason is using memory via assembly
261 
262                 // solhint-disable-next-line no-inline-assembly
263                 assembly {
264                     let returndata_size := mload(returndata)
265                     revert(add(32, returndata), returndata_size)
266                 }
267             } else {
268                 revert(errorMessage);
269             }
270         }
271     }
272 }
273 
274 
275 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.1.0
276 
277 pragma solidity ^0.8.0;
278 
279 
280 /**
281  * @title SafeERC20
282  * @dev Wrappers around ERC20 operations that throw on failure (when the token
283  * contract returns false). Tokens that return no value (and instead revert or
284  * throw on failure) are also supported, non-reverting calls are assumed to be
285  * successful.
286  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
287  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
288  */
289 library SafeERC20 {
290     using Address for address;
291 
292     function safeTransfer(IERC20 token, address to, uint256 value) internal {
293         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
294     }
295 
296     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
297         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
298     }
299 
300     /**
301      * @dev Deprecated. This function has issues similar to the ones found in
302      * {IERC20-approve}, and its usage is discouraged.
303      *
304      * Whenever possible, use {safeIncreaseAllowance} and
305      * {safeDecreaseAllowance} instead.
306      */
307     function safeApprove(IERC20 token, address spender, uint256 value) internal {
308         // safeApprove should only be called when setting an initial allowance,
309         // or when resetting it to zero. To increase and decrease it, use
310         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
311         // solhint-disable-next-line max-line-length
312         require((value == 0) || (token.allowance(address(this), spender) == 0),
313             "SafeERC20: approve from non-zero to non-zero allowance"
314         );
315         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
316     }
317 
318     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
319         uint256 newAllowance = token.allowance(address(this), spender) + value;
320         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
321     }
322 
323     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
324         unchecked {
325             uint256 oldAllowance = token.allowance(address(this), spender);
326             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
327             uint256 newAllowance = oldAllowance - value;
328             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
329         }
330     }
331 
332     /**
333      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
334      * on the return value: the return value is optional (but if data is returned, it must not be false).
335      * @param token The token targeted by the call.
336      * @param data The call data (encoded using abi.encode or one of its variants).
337      */
338     function _callOptionalReturn(IERC20 token, bytes memory data) private {
339         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
340         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
341         // the target address contains contract code and also asserts for success in the low-level call.
342 
343         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
344         if (returndata.length > 0) { // Return data is optional
345             // solhint-disable-next-line max-line-length
346             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
347         }
348     }
349 }
350 
351 
352 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.1.0
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev These functions deal with verification of Merkle Trees proofs.
358  *
359  * The proofs can be generated using the JavaScript library
360  * https://github.com/miguelmota/merkletreejs[merkletreejs].
361  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
362  *
363  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
364  */
365 library MerkleProof {
366     /**
367      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
368      * defined by `root`. For this, a `proof` must be provided, containing
369      * sibling hashes on the branch from the leaf to the root of the tree. Each
370      * pair of leaves and each pair of pre-images are assumed to be sorted.
371      */
372     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
373         bytes32 computedHash = leaf;
374 
375         for (uint256 i = 0; i < proof.length; i++) {
376             bytes32 proofElement = proof[i];
377 
378             if (computedHash <= proofElement) {
379                 // Hash(current computed hash + current element of the proof)
380                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
381             } else {
382                 // Hash(current element of the proof + current computed hash)
383                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
384             }
385         }
386 
387         // Check if the computed hash (root) is equal to the provided root
388         return computedHash == root;
389     }
390 }
391 
392 
393 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
394 
395 pragma solidity ^0.8.0;
396 
397 /*
398  * @dev Provides information about the current execution context, including the
399  * sender of the transaction and its data. While these are generally available
400  * via msg.sender and msg.data, they should not be accessed in such a direct
401  * manner, since when dealing with meta-transactions the account sending and
402  * paying for execution may not be the actual sender (as far as an application
403  * is concerned).
404  *
405  * This contract is only required for intermediate, library-like contracts.
406  */
407 abstract contract Context {
408     function _msgSender() internal view virtual returns (address) {
409         return msg.sender;
410     }
411 
412     function _msgData() internal view virtual returns (bytes calldata) {
413         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
414         return msg.data;
415     }
416 }
417 
418 
419 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @dev Contract module which provides a basic access control mechanism, where
425  * there is an account (an owner) that can be granted exclusive access to
426  * specific functions.
427  *
428  * By default, the owner account will be the one that deploys the contract. This
429  * can later be changed with {transferOwnership}.
430  *
431  * This module is used through inheritance. It will make available the modifier
432  * `onlyOwner`, which can be applied to your functions to restrict their use to
433  * the owner.
434  */
435 abstract contract Ownable is Context {
436     address private _owner;
437 
438     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
439 
440     /**
441      * @dev Initializes the contract setting the deployer as the initial owner.
442      */
443     constructor () {
444         address msgSender = _msgSender();
445         _owner = msgSender;
446         emit OwnershipTransferred(address(0), msgSender);
447     }
448 
449     /**
450      * @dev Returns the address of the current owner.
451      */
452     function owner() public view virtual returns (address) {
453         return _owner;
454     }
455 
456     /**
457      * @dev Throws if called by any account other than the owner.
458      */
459     modifier onlyOwner() {
460         require(owner() == _msgSender(), "Ownable: caller is not the owner");
461         _;
462     }
463 
464     /**
465      * @dev Leaves the contract without owner. It will not be possible to call
466      * `onlyOwner` functions anymore. Can only be called by the current owner.
467      *
468      * NOTE: Renouncing ownership will leave the contract without an owner,
469      * thereby removing any functionality that is only available to the owner.
470      */
471     function renounceOwnership() public virtual onlyOwner {
472         emit OwnershipTransferred(_owner, address(0));
473         _owner = address(0);
474     }
475 
476     /**
477      * @dev Transfers ownership of the contract to a new account (`newOwner`).
478      * Can only be called by the current owner.
479      */
480     function transferOwnership(address newOwner) public virtual onlyOwner {
481         require(newOwner != address(0), "Ownable: new owner is the zero address");
482         emit OwnershipTransferred(_owner, newOwner);
483         _owner = newOwner;
484     }
485 }
486 
487 
488 // File contracts/ValidatorOwner.sol
489 
490 pragma solidity ^0.8.4;
491 abstract contract ValidatorOwner is Ownable {
492     event RootUpdated(bytes32 claimRoot, uint256 blockNumber);
493     event AddedToWhitelist(address addr);
494     event RemovedFromWhitelist(address addr);
495     event InflationRateBaseUpdated(uint16 inflationRateBase);
496     event InflationRateTargetUpdated(uint16 inflationRateTarget);
497     event SlotsMaxUpdated(uint256 slotsMax);
498 
499     uint256 public slotsMax = 500;
500     uint16 public inflationRateBase = 200; //2%
501     uint16 public inflationRateTarget = 250; //2.5%
502 
503     mapping(address => bool) public whitelist;
504 
505     uint256 public lastRootBlock;
506     mapping(uint256 => bytes32) public claimRoots;
507 
508     modifier validAddress(address addr) {
509         require(addr != address(0), "Zero address");
510         _;
511     }
512 
513     function whitelistAdd(address addr) external onlyOwner validAddress(addr) {
514         require(!whitelist[addr], "Already whitelisted");
515 
516         whitelist[addr] = true;
517 
518         emit AddedToWhitelist(addr);
519     }
520 
521     function whitelistRemove(address addr) external onlyOwner validAddress(addr) {
522         require(whitelist[addr], "Already removed from whitelist");
523 
524         whitelist[addr] = false;
525 
526         emit RemovedFromWhitelist(addr);
527     }
528 
529     function setInflationRateBase(uint16 value) external onlyOwner {
530         inflationRateBase = value;
531         emit InflationRateBaseUpdated(value);
532     }
533 
534     function setInflationRateTarget(uint16 value) external onlyOwner {
535         inflationRateTarget = value;
536         emit InflationRateTargetUpdated(value);
537     }
538 
539     function setSlotsMax(uint256 value) external onlyOwner {
540         slotsMax = value;
541         emit SlotsMaxUpdated(value);
542     }
543 
544     function updateRoot(bytes32 claimRoot, uint256 blockNumber) external onlyOwner {
545         require(lastRootBlock < blockNumber && blockNumber < block.number, "Invalid block number");
546         lastRootBlock = blockNumber;
547         claimRoots[blockNumber] = claimRoot;
548         emit RootUpdated(claimRoot, blockNumber);
549     }
550 }
551 
552 
553 // File contracts/Custodian.sol
554 
555 pragma solidity ^0.8.4;
556 contract Custodian is Ownable {
557     using SafeERC20 for IERC20;
558 
559     event Withdraw(address indexed account, uint256 amount);
560 
561     mapping(address => bool) private _authorized;
562 
563     modifier validAddress(address addr){
564         require(addr != address(0), "Zero address");
565         _;
566     }
567 
568     function withdrawTo(address token, address recipient, uint256 amount) public validAddress(token) validAddress(recipient) {
569         require(_authorized[msg.sender], "Not authorized");
570         IERC20(token).safeTransfer(recipient, amount);
571         emit Withdraw(recipient, amount);
572     }
573 
574     function withdraw(address token, uint256 amount) external {
575         withdrawTo(token, msg.sender, amount);
576     }
577 
578     function addAuthorized(address addr) external onlyOwner validAddress(addr) {
579         require(!_authorized[addr], "Already authorized");
580         _authorized[addr] = true;
581     }
582 
583     function removeAuthorized(address addr) external onlyOwner validAddress(addr) {
584         require(_authorized[addr], "Already de-authorized");
585         _authorized[addr] = false;
586     }
587 
588     function isAuthorized(address addr) external view validAddress(addr) returns (bool) {
589         return _authorized[addr];
590     }
591 }
592 
593 
594 // File contracts/Validator.sol
595 
596 pragma solidity ^0.8.4;
597 contract Validator is ValidatorOwner {
598     using SafeERC20 for IERC20;
599     using MerkleProof for bytes32[];
600 
601     event Withdrawn(address indexed addr, uint256 amount);
602     event RewardWithdrawn(address indexed addr);
603 
604     uint256 public constant stakeMin = 20_000e18;
605     uint256 public constant stakeMax = 200_000e18;
606     uint16 public constant decayRate = 500; //5%
607     uint32 public constant rewardPeriod = 365 days;
608 
609     address private immutable token;
610     address private immutable custodian;
611 
612     mapping(address => uint256) public balances;
613 
614     mapping(address => uint256) public totalPayoutsFor;
615 
616     constructor(address _token, address _custodian) {
617         token = _token;
618         custodian = _custodian;
619     }
620 
621     function deposit(uint256 amount) external {
622         balances[msg.sender] += amount;
623 
624         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
625     }
626 
627     function withdraw(uint256 amount) external {
628         require(amount > 0 && amount <= balances[msg.sender], "Invalid amount");
629 
630         balances[msg.sender] -= amount;
631 
632         IERC20(token).safeTransfer(msg.sender, amount);
633 
634         emit Withdrawn(msg.sender, amount);
635     }
636 
637     function stakeOf(address addr) external view validAddress(addr) returns (uint256) {
638         uint256 balance = balances[addr];
639 
640         if (!whitelist[addr]) return 0;
641         if (balance < stakeMin) return 0;
642         if (balance > stakeMax) return stakeMax;
643 
644         return balance;
645     }
646 
647     function isValidProof(
648         address recipient,
649         uint256 totalEarned,
650         uint256 blockNumber,
651         bytes32[] calldata proof
652     ) public view returns (bool) {
653         bytes32 leaf = keccak256(abi.encodePacked(recipient, totalEarned, block.chainid, address(this)));
654         bytes32 root = claimRoots[blockNumber];
655         return proof.verify(root, leaf);
656     }
657 
658     function withdrawReward(
659         address recipient,
660         uint256 totalEarned,
661         uint256 blockNumber,
662         bytes32[] calldata proof
663     ) external {
664         require(isValidProof(recipient, totalEarned, blockNumber, proof), "Invalid proof");
665         uint256 totalReceived = totalPayoutsFor[recipient];
666         require(totalEarned >= totalReceived, "Already paid");
667         uint256 amount = totalEarned - totalReceived;
668         if (amount == 0) return;
669         totalPayoutsFor[recipient] = totalEarned;
670 
671         Custodian(custodian).withdrawTo(token, recipient, amount);
672 
673         emit RewardWithdrawn(recipient);
674     }
675 }