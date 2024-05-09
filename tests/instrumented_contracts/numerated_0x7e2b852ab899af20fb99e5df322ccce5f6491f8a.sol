1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.3;
3 
4 /**
5  * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.
6  * `CREATE2` can be used to compute in advance the address where a smart
7  * contract will be deployed, which allows for interesting new mechanisms known
8  * as 'counterfactual interactions'.
9  *
10  * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more
11  * information.
12  */
13 library Create2 {
14     /**
15      * @dev Deploys a contract using `CREATE2`. The address where the contract
16      * will be deployed can be known in advance via {computeAddress}.
17      *
18      * The bytecode for a contract can be obtained from Solidity with
19      * `type(contractName).creationCode`.
20      *
21      * Requirements:
22      *
23      * - `bytecode` must not be empty.
24      * - `salt` must have not been used for `bytecode` already.
25      * - the factory must have a balance of at least `amount`.
26      * - if `amount` is non-zero, `bytecode` must have a `payable` constructor.
27      */
28     function deploy(uint256 amount, bytes32 salt, bytes memory bytecode) internal returns (address) {
29         address addr;
30         require(address(this).balance >= amount, "Create2: insufficient balance");
31         require(bytecode.length != 0, "Create2: bytecode length is zero");
32         // solhint-disable-next-line no-inline-assembly
33         assembly {
34             addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)
35         }
36         require(addr != address(0), "Create2: Failed on deploy");
37         return addr;
38     }
39 
40     /**
41      * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the
42      * `bytecodeHash` or `salt` will result in a new destination address.
43      */
44     function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {
45         return computeAddress(salt, bytecodeHash, address(this));
46     }
47 
48     /**
49      * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
50      * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
51      */
52     function computeAddress(bytes32 salt, bytes32 bytecodeHash, address deployer) internal pure returns (address) {
53         bytes32 _data = keccak256(
54             abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHash)
55         );
56         return address(uint160(uint256(_data)));
57     }
58 }
59 
60 /**
61  * @dev Collection of functions related to the address type
62  */
63 library Address {
64     /**
65      * @dev Returns true if `account` is a contract.
66      *
67      * [IMPORTANT]
68      * ====
69      * It is unsafe to assume that an address for which this function returns
70      * false is an externally-owned account (EOA) and not a contract.
71      *
72      * Among others, `isContract` will return false for the following
73      * types of addresses:
74      *
75      *  - an externally-owned account
76      *  - a contract in construction
77      *  - an address where a contract will be created
78      *  - an address where a contract lived, but was destroyed
79      * ====
80      */
81     function isContract(address account) internal view returns (bool) {
82         // This method relies on extcodesize, which returns 0 for contracts in
83         // construction, since the code is only stored at the end of the
84         // constructor execution.
85 
86         uint256 size;
87         // solhint-disable-next-line no-inline-assembly
88         assembly { size := extcodesize(account) }
89         return size > 0;
90     }
91 
92     /**
93      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
94      * `recipient`, forwarding all available gas and reverting on errors.
95      *
96      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
97      * of certain opcodes, possibly making contracts go over the 2300 gas limit
98      * imposed by `transfer`, making them unable to receive funds via
99      * `transfer`. {sendValue} removes this limitation.
100      *
101      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
102      *
103      * IMPORTANT: because control is transferred to `recipient`, care must be
104      * taken to not create reentrancy vulnerabilities. Consider using
105      * {ReentrancyGuard} or the
106      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
107      */
108     function sendValue(address payable recipient, uint256 amount) internal {
109         require(address(this).balance >= amount, "Address: insufficient balance");
110 
111         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
112         (bool success, ) = recipient.call{ value: amount }("");
113         require(success, "Address: unable to send value, recipient may have reverted");
114     }
115 
116     /**
117      * @dev Performs a Solidity function call using a low level `call`. A
118      * plain`call` is an unsafe replacement for a function call: use this
119      * function instead.
120      *
121      * If `target` reverts with a revert reason, it is bubbled up by this
122      * function (like regular Solidity function calls).
123      *
124      * Returns the raw returned data. To convert to the expected return value,
125      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
126      *
127      * Requirements:
128      *
129      * - `target` must be a contract.
130      * - calling `target` with `data` must not revert.
131      *
132      * _Available since v3.1._
133      */
134     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
135       return functionCall(target, data, "Address: low-level call failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
140      * `errorMessage` as a fallback revert reason when `target` reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
145         return functionCallWithValue(target, data, 0, errorMessage);
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
150      * but also transferring `value` wei to `target`.
151      *
152      * Requirements:
153      *
154      * - the calling contract must have an ETH balance of at least `value`.
155      * - the called Solidity function must be `payable`.
156      *
157      * _Available since v3.1._
158      */
159     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
160         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
165      * with `errorMessage` as a fallback revert reason when `target` reverts.
166      *
167      * _Available since v3.1._
168      */
169     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
170         require(address(this).balance >= value, "Address: insufficient balance for call");
171         require(isContract(target), "Address: call to non-contract");
172 
173         // solhint-disable-next-line avoid-low-level-calls
174         (bool success, bytes memory returndata) = target.call{ value: value }(data);
175         return _verifyCallResult(success, returndata, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but performing a static call.
181      *
182      * _Available since v3.3._
183      */
184     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
185         return functionStaticCall(target, data, "Address: low-level static call failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
190      * but performing a static call.
191      *
192      * _Available since v3.3._
193      */
194     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
195         require(isContract(target), "Address: static call to non-contract");
196 
197         // solhint-disable-next-line avoid-low-level-calls
198         (bool success, bytes memory returndata) = target.staticcall(data);
199         return _verifyCallResult(success, returndata, errorMessage);
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
204      * but performing a delegate call.
205      *
206      * _Available since v3.4._
207      */
208     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
209         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
214      * but performing a delegate call.
215      *
216      * _Available since v3.4._
217      */
218     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
219         require(isContract(target), "Address: delegate call to non-contract");
220 
221         // solhint-disable-next-line avoid-low-level-calls
222         (bool success, bytes memory returndata) = target.delegatecall(data);
223         return _verifyCallResult(success, returndata, errorMessage);
224     }
225 
226     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
227         if (success) {
228             return returndata;
229         } else {
230             // Look for revert reason and bubble it up if present
231             if (returndata.length > 0) {
232                 // The easiest way to bubble the revert reason is using memory via assembly
233 
234                 // solhint-disable-next-line no-inline-assembly
235                 assembly {
236                     let returndata_size := mload(returndata)
237                     revert(add(32, returndata), returndata_size)
238                 }
239             } else {
240                 revert(errorMessage);
241             }
242         }
243     }
244 }
245 
246 /**
247  * @dev Interface of the ERC20 standard as defined in the EIP.
248  */
249 interface IERC20 {
250     /**
251      * @dev Returns the amount of tokens in existence.
252      */
253     function totalSupply() external view returns (uint256);
254 
255     /**
256      * @dev Returns the amount of tokens owned by `account`.
257      */
258     function balanceOf(address account) external view returns (uint256);
259 
260     /**
261      * @dev Moves `amount` tokens from the caller's account to `recipient`.
262      *
263      * Returns a boolean value indicating whether the operation succeeded.
264      *
265      * Emits a {Transfer} event.
266      */
267     function transfer(address recipient, uint256 amount) external returns (bool);
268 
269     /**
270      * @dev Returns the remaining number of tokens that `spender` will be
271      * allowed to spend on behalf of `owner` through {transferFrom}. This is
272      * zero by default.
273      *
274      * This value changes when {approve} or {transferFrom} are called.
275      */
276     function allowance(address owner, address spender) external view returns (uint256);
277 
278     /**
279      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * IMPORTANT: Beware that changing an allowance with this method brings the risk
284      * that someone may use both the old and the new allowance by unfortunate
285      * transaction ordering. One possible solution to mitigate this race
286      * condition is to first reduce the spender's allowance to 0 and set the
287      * desired value afterwards:
288      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
289      *
290      * Emits an {Approval} event.
291      */
292     function approve(address spender, uint256 amount) external returns (bool);
293 
294     /**
295      * @dev Moves `amount` tokens from `sender` to `recipient` using the
296      * allowance mechanism. `amount` is then deducted from the caller's
297      * allowance.
298      *
299      * Returns a boolean value indicating whether the operation succeeded.
300      *
301      * Emits a {Transfer} event.
302      */
303     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
304 
305     /**
306      * @dev Emitted when `value` tokens are moved from one account (`from`) to
307      * another (`to`).
308      *
309      * Note that `value` may be zero.
310      */
311     event Transfer(address indexed from, address indexed to, uint256 value);
312 
313     /**
314      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
315      * a call to {approve}. `value` is the new allowance.
316      */
317     event Approval(address indexed owner, address indexed spender, uint256 value);
318 }
319 
320 /**
321  * @title SafeERC20
322  * @dev Wrappers around ERC20 operations that throw on failure (when the token
323  * contract returns false). Tokens that return no value (and instead revert or
324  * throw on failure) are also supported, non-reverting calls are assumed to be
325  * successful.
326  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
327  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
328  */
329 library SafeERC20 {
330     using Address for address;
331 
332     function safeTransfer(IERC20 token, address to, uint256 value) internal {
333         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
334     }
335 
336     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
337         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
338     }
339 
340     /**
341      * @dev Deprecated. This function has issues similar to the ones found in
342      * {IERC20-approve}, and its usage is discouraged.
343      *
344      * Whenever possible, use {safeIncreaseAllowance} and
345      * {safeDecreaseAllowance} instead.
346      */
347     function safeApprove(IERC20 token, address spender, uint256 value) internal {
348         // safeApprove should only be called when setting an initial allowance,
349         // or when resetting it to zero. To increase and decrease it, use
350         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
351         // solhint-disable-next-line max-line-length
352         require((value == 0) || (token.allowance(address(this), spender) == 0),
353             "SafeERC20: approve from non-zero to non-zero allowance"
354         );
355         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
356     }
357 
358     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
359         uint256 newAllowance = token.allowance(address(this), spender) + value;
360         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
361     }
362 
363     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
364         unchecked {
365             uint256 oldAllowance = token.allowance(address(this), spender);
366             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
367             uint256 newAllowance = oldAllowance - value;
368             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
369         }
370     }
371 
372     /**
373      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
374      * on the return value: the return value is optional (but if data is returned, it must not be false).
375      * @param token The token targeted by the call.
376      * @param data The call data (encoded using abi.encode or one of its variants).
377      */
378     function _callOptionalReturn(IERC20 token, bytes memory data) private {
379         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
380         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
381         // the target address contains contract code and also asserts for success in the low-level call.
382 
383         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
384         if (returndata.length > 0) { // Return data is optional
385             // solhint-disable-next-line max-line-length
386             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
387         }
388     }
389 }
390 
391 /**
392  * @dev These functions deal with verification of Merkle Trees proofs.
393  *
394  * The proofs can be generated using the JavaScript library
395  * https://github.com/miguelmota/merkletreejs[merkletreejs].
396  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
397  *
398  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
399  */
400 library MerkleProof {
401     /**
402      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
403      * defined by `root`. For this, a `proof` must be provided, containing
404      * sibling hashes on the branch from the leaf to the root of the tree. Each
405      * pair of leaves and each pair of pre-images are assumed to be sorted.
406      */
407     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
408         bytes32 computedHash = leaf;
409 
410         for (uint256 i = 0; i < proof.length; i++) {
411             bytes32 proofElement = proof[i];
412 
413             if (computedHash <= proofElement) {
414                 // Hash(current computed hash + current element of the proof)
415                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
416             } else {
417                 // Hash(current element of the proof + current computed hash)
418                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
419             }
420         }
421 
422         // Check if the computed hash (root) is equal to the provided root
423         return computedHash == root;
424     }
425 }
426 
427 contract Drop {
428     using MerkleProof for bytes;
429     using SafeERC20 for IERC20;
430 
431     struct DropData {
432         uint256 startDate;
433         uint256 endDate;
434         uint256 tokenAmount;
435         address owner;
436         bool isActive;
437     }
438 
439     address public factory;
440     address public token;
441 
442     mapping(bytes32 => DropData) public dropData;
443     mapping(bytes32 => mapping(uint256 => uint256)) private claimedBitMap;
444 
445     constructor() {
446         factory = msg.sender;
447     }
448 
449     modifier onlyFactory {
450         require(msg.sender == factory, "DROP_ONLY_FACTORY");
451         _;
452     }
453 
454     function initialize(address tokenAddress) external onlyFactory {
455         token = tokenAddress;
456     }
457 
458     function addDropData(
459         address owner,
460         bytes32 merkleRoot,
461         uint256 startDate,
462         uint256 endDate,
463         uint256 tokenAmount
464     ) external onlyFactory {
465         require(dropData[merkleRoot].startDate == 0, "DROP_EXISTS");
466         require(endDate > block.timestamp, "DROP_INVALID_END_DATE");
467         require(endDate > startDate, "DROP_INVALID_START_DATE");
468         dropData[merkleRoot] = DropData(startDate, endDate, tokenAmount, owner, true);
469     }
470 
471     function claim(
472         uint256 index,
473         address account,
474         uint256 amount,
475         uint256 fee,
476         address feeReceiver,
477         bytes32 merkleRoot,
478         bytes32[] calldata merkleProof
479     ) external onlyFactory {
480         DropData memory dd = dropData[merkleRoot];
481 
482         require(dd.startDate < block.timestamp, "DROP_NOT_STARTED");
483         require(dd.endDate > block.timestamp, "DROP_ENDED");
484         require(dd.isActive, "DROP_NOT_ACTIVE");
485         require(!isClaimed(index, merkleRoot), "DROP_ALREADY_CLAIMED");
486 
487         // Verify the merkle proof.
488         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
489         require(MerkleProof.verify(merkleProof, merkleRoot, node), "DROP_INVALID_PROOF");
490 
491         // Calculate fees
492         uint256 feeAmount = (amount * fee) / 10000;
493         uint256 userReceivedAmount = amount - feeAmount;
494 
495         // Subtract from the drop amount
496         dropData[merkleRoot].tokenAmount -= amount;
497 
498         // Mark it claimed and send the tokens.
499         _setClaimed(index, merkleRoot);
500         IERC20(token).safeTransfer(account, userReceivedAmount);
501         
502         if(feeAmount > 0) {
503             IERC20(token).safeTransfer(feeReceiver, feeAmount);
504         }
505     }
506 
507     function withdraw(address account, bytes32 merkleRoot) external onlyFactory returns (uint256) {
508         DropData memory dd = dropData[merkleRoot];
509         require(dd.owner == account, "DROP_ONLY_OWNER");
510 
511         delete dropData[merkleRoot];
512 
513         IERC20(token).safeTransfer(account, dd.tokenAmount);
514         return dd.tokenAmount;
515     }
516 
517     function isClaimed(uint256 index, bytes32 merkleRoot) public view returns (bool) {
518         uint256 claimedWordIndex = index / 256;
519         uint256 claimedBitIndex = index % 256;
520         uint256 claimedWord = claimedBitMap[merkleRoot][claimedWordIndex];
521         uint256 mask = (1 << claimedBitIndex);
522         return claimedWord & mask == mask;
523     }
524 
525     function pause(address account, bytes32 merkleRoot) external onlyFactory {
526         DropData memory dd = dropData[merkleRoot];
527         require(dd.owner == account, "NOT_OWNER");
528         dropData[merkleRoot].isActive = false;
529     }
530 
531     function unpause(address account, bytes32 merkleRoot) external onlyFactory {
532         DropData memory dd = dropData[merkleRoot];
533         require(dd.owner == account, "NOT_OWNER");
534         dropData[merkleRoot].isActive = true;
535     }
536 
537     function _setClaimed(uint256 index, bytes32 merkleRoot) private {
538         uint256 claimedWordIndex = index / 256;
539         uint256 claimedBitIndex = index % 256;
540         claimedBitMap[merkleRoot][claimedWordIndex] = claimedBitMap[merkleRoot][claimedWordIndex] | (1 << claimedBitIndex);
541     }
542 }
543 
544 interface IDropFactory {
545     function createDrop(address tokenAddress) external;
546 
547     function addDropData(
548         uint256 tokenAmount,
549         uint256 startDate,
550         uint256 endDate,
551         bytes32 merkleRoot,
552         address tokenAddress
553     ) external;
554 
555     function claimFromDrop(
556         address tokenAddress,
557         uint256 index,
558         uint256 amount,
559         bytes32 merkleRoot,
560         bytes32[] calldata merkleProof
561     ) external;
562 
563     function multipleClaimsFromDrop(
564         address tokenAddress,
565         uint256[] calldata indexes,
566         uint256[] calldata amounts,
567         bytes32[] calldata merkleRoots,
568         bytes32[][] calldata merkleProofs
569     ) external;
570 
571     function withdraw(address tokenAddress, bytes32 merkleRoot) external;
572 
573     function pause(address tokenAddress, bytes32 merkleRoot) external;
574 
575     function unpause(address tokenAddress, bytes32 merkleRoot) external;
576 
577     function updateFeeReceiver(address newFeeReceiver) external;
578 
579     function updateFee(uint256 newFee) external;
580 
581     function isDropClaimed(
582         address tokenAddress,
583         uint256 index,
584         bytes32 merkleRoot
585     ) external view returns (bool);
586 
587     function getDropDetails(address tokenAddress, bytes32 merkleRoot)
588         external
589         view
590         returns (
591             uint256,
592             uint256,
593             uint256,
594             address,
595             bool
596         );
597 
598     event DropCreated(address indexed dropAddress, address indexed tokenAddress);
599     event DropDataAdded(address indexed tokenAddress, bytes32 merkleRoot, uint256 tokenAmount, uint256 startDate, uint256 endDate);
600     event DropClaimed(address indexed tokenAddress, uint256 index, address indexed account, uint256 amount, bytes32 indexed merkleRoot);
601     event DropWithdrawn(address indexed tokenAddress, address indexed account, bytes32 indexed merkleRoot, uint256 amount);
602     event DropPaused(bytes32 merkleRoot);
603     event DropUnpaused(bytes32 merkleRoot);
604 }
605 
606 
607 
608 contract DropFactory is IDropFactory {
609     using SafeERC20 for IERC20;
610 
611     uint256 public fee;
612     address public feeReceiver;
613     address public timelock;
614     mapping(address => address) public drops;
615 
616     constructor(
617         uint256 _fee,
618         address _feeReceiver,
619         address _timelock
620     ) {
621         fee = _fee;
622         feeReceiver = _feeReceiver;
623         timelock = _timelock;
624     }
625 
626     modifier dropExists(address tokenAddress) {
627         require(drops[tokenAddress] != address(0), "FACTORY_DROP_DOES_NOT_EXIST");
628         _;
629     }
630 
631     modifier onlyTimelock() {
632         require(msg.sender == timelock, "FACTORY_ONLY_TIMELOCK");
633         _;
634     }
635 
636     function createDrop(address tokenAddress) external override {
637         require(drops[tokenAddress] == address(0), "FACTORY_DROP_EXISTS");
638         bytes memory bytecode = type(Drop).creationCode;
639         bytes32 salt = keccak256(abi.encodePacked(tokenAddress));
640         address dropAddress = Create2.deploy(0, salt, bytecode);
641         Drop(dropAddress).initialize(tokenAddress);
642         drops[tokenAddress] = dropAddress;
643         emit DropCreated(dropAddress, tokenAddress);
644     }
645 
646     function addDropData(
647         uint256 tokenAmount,
648         uint256 startDate,
649         uint256 endDate,
650         bytes32 merkleRoot,
651         address tokenAddress
652     ) external override dropExists(tokenAddress) {
653         address dropAddress = drops[tokenAddress];
654         IERC20(tokenAddress).safeTransferFrom(msg.sender, dropAddress, tokenAmount);
655         Drop(dropAddress).addDropData(msg.sender, merkleRoot, startDate, endDate, tokenAmount);
656         emit DropDataAdded(tokenAddress, merkleRoot, tokenAmount, startDate, endDate);
657     }
658 
659     function claimFromDrop(
660         address tokenAddress,
661         uint256 index,
662         uint256 amount,
663         bytes32 merkleRoot,
664         bytes32[] calldata merkleProof
665     ) external override dropExists(tokenAddress) {
666         Drop(drops[tokenAddress]).claim(index, msg.sender, amount, fee, feeReceiver, merkleRoot, merkleProof);
667         emit DropClaimed(tokenAddress, index, msg.sender, amount, merkleRoot);
668     }
669 
670     function multipleClaimsFromDrop(
671         address tokenAddress,
672         uint256[] calldata indexes,
673         uint256[] calldata amounts,
674         bytes32[] calldata merkleRoots,
675         bytes32[][] calldata merkleProofs
676     ) external override dropExists(tokenAddress) {
677         uint256 tempFee = fee;
678         address tempFeeReceiver = feeReceiver;
679         for (uint256 i = 0; i < indexes.length; i++) {
680             Drop(drops[tokenAddress]).claim(indexes[i], msg.sender, amounts[i], tempFee, tempFeeReceiver, merkleRoots[i], merkleProofs[i]);
681             emit DropClaimed(tokenAddress, indexes[i], msg.sender, amounts[i], merkleRoots[i]);
682         }
683     }
684 
685     function withdraw(address tokenAddress, bytes32 merkleRoot) external override dropExists(tokenAddress) {
686         uint256 withdrawAmount = Drop(drops[tokenAddress]).withdraw(msg.sender, merkleRoot);
687         emit DropWithdrawn(tokenAddress, msg.sender, merkleRoot, withdrawAmount);
688     }
689 
690     function updateFee(uint256 newFee) external override onlyTimelock {
691         // max fee 20%
692         require(newFee < 2000, "FACTORY_MAX_FEE_EXCEED");
693         fee = newFee;
694     }
695 
696     function updateFeeReceiver(address newFeeReceiver) external override onlyTimelock {
697         feeReceiver = newFeeReceiver;
698     }
699 
700     function pause(address tokenAddress, bytes32 merkleRoot) external override {
701         Drop(drops[tokenAddress]).pause(msg.sender, merkleRoot);
702         emit DropPaused(merkleRoot);
703     }
704 
705     function unpause(address tokenAddress, bytes32 merkleRoot) external override {
706         Drop(drops[tokenAddress]).unpause(msg.sender, merkleRoot);
707         DropUnpaused(merkleRoot);
708     }
709 
710     function getDropDetails(address tokenAddress, bytes32 merkleRoot)
711         external
712         view
713         override
714         returns (
715             uint256,
716             uint256,
717             uint256,
718             address,
719             bool
720         )
721     {
722         return Drop(drops[tokenAddress]).dropData(merkleRoot);
723     }
724 
725     function isDropClaimed(
726         address tokenAddress,
727         uint256 index,
728         bytes32 merkleRoot
729     ) external view override dropExists(tokenAddress) returns (bool) {
730         return Drop(drops[tokenAddress]).isClaimed(index, merkleRoot);
731     }
732 }