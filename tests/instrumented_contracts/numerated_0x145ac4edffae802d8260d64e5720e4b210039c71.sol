1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 //AE THER 
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**t
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
24      * @dev Moves `amount` tokens from the caller's account to `to`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address to, uint256 amount) external returns (bool);
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
58      * @dev Moves `amount` tokens from `from` to `to` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address from,
68         address to,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 /**
89  * @title SafeERC20
90  * @dev Wrappers around ERC20 operations that throw on failure (when the token
91  * contract returns false). Tokens that return no value (and instead revert or
92  * throw on failure) are also supported, non-reverting calls are assumed to be
93  * successful.
94  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
95  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
96  */
97 library SafeERC20 {
98     using Address for address;
99 
100     function safeTransfer(
101         IERC20 token,
102         address to,
103         uint256 value
104     ) internal {
105         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
106     }
107 
108     function safeTransferFrom(
109         IERC20 token,
110         address from,
111         address to,
112         uint256 value
113     ) internal {
114         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
115     }
116 
117     /**
118      * @dev Deprecated. This function has issues similar to the ones found in
119      * {IERC20-approve}, and its usage is discouraged.
120      *
121      * Whenever possible, use {safeIncreaseAllowance} and
122      * {safeDecreaseAllowance} instead.
123      */
124     function safeApprove(
125         IERC20 token,
126         address spender,
127         uint256 value
128     ) internal {
129         // safeApprove should only be called when setting an initial allowance,
130         // or when resetting it to zero. To increase and decrease it, use
131         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
132         require(
133             (value == 0) || (token.allowance(address(this), spender) == 0),
134             "SafeERC20: approve from non-zero to non-zero allowance"
135         );
136         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
137     }
138 
139     function safeIncreaseAllowance(
140         IERC20 token,
141         address spender,
142         uint256 value
143     ) internal {
144         uint256 newAllowance = token.allowance(address(this), spender) + value;
145         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
146     }
147 
148     function safeDecreaseAllowance(
149         IERC20 token,
150         address spender,
151         uint256 value
152     ) internal {
153         unchecked {
154             uint256 oldAllowance = token.allowance(address(this), spender);
155             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
156             uint256 newAllowance = oldAllowance - value;
157             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
158         }
159     }
160 
161     /**
162      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
163      * on the return value: the return value is optional (but if data is returned, it must not be false).
164      * @param token The token targeted by the call.
165      * @param data The call data (encoded using abi.encode or one of its variants).
166      */
167     function _callOptionalReturn(IERC20 token, bytes memory data) private {
168         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
169         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
170         // the target address contains contract code and also asserts for success in the low-level call.
171 
172         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
173         if (returndata.length > 0) {
174             // Return data is optional
175             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
176         }
177     }
178 }
179 
180     // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
181 
182 
183     // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
184 
185     pragma solidity ^0.8.0;
186 
187     /**
188     * @dev Contract module that helps prevent reentrant calls to a function.
189     *
190     * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
191     * available, which can be applied to functions to make sure there are no nested
192     * (reentrant) calls to them.
193     *
194     * Note that because there is a single `nonReentrant` guard, functions marked as
195     * `nonReentrant` may not call one another. This can be worked around by making
196     * those functions `private`, and then adding `external` `nonReentrant` entry
197     * points to them.
198     *
199     * TIP: If you would like to learn more about reentrancy and alternative ways
200     * to protect against it, check out our blog post
201     * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
202     */
203     abstract contract ReentrancyGuard {
204         // Booleans are more expensive than uint256 or any type that takes up a full
205         // word because each write operation emits an extra SLOAD to first read the
206         // slot's contents, replace the bits taken up by the boolean, and then write
207         // back. This is the compiler's defense against contract upgrades and
208         // pointer aliasing, and it cannot be disabled.
209 
210         // The values being non-zero value makes deployment a bit more expensive,
211         // but in exchange the refund on every call to nonReentrant will be lower in
212         // amount. Since refunds are capped to a percentage of the total
213         // transaction's gas, it is best to keep them low in cases like this one, to
214         // increase the likelihood of the full refund coming into effect.
215         uint256 private constant _NOT_ENTERED = 1;
216         uint256 private constant _ENTERED = 2;
217 
218         uint256 private _status;
219 
220         constructor() {
221             _status = _NOT_ENTERED;
222         }
223 
224         /**
225         * @dev Prevents a contract from calling itself, directly or indirectly.
226         * Calling a `nonReentrant` function from another `nonReentrant`
227         * function is not supported. It is possible to prevent this from happening
228         * by making the `nonReentrant` function external, and making it call a
229         * `private` function that does the actual work.
230         */
231         modifier nonReentrant() {
232             // On the first call to nonReentrant, _notEntered will be true
233             require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
234 
235             // Any calls to nonReentrant after this point will fail
236             _status = _ENTERED;
237 
238             _;
239 
240             // By storing the original value once again, a refund is triggered (see
241             // https://eips.ethereum.org/EIPS/eip-2200)
242             _status = _NOT_ENTERED;
243         }
244     }
245 
246     // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
247 
248 
249     // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
250 
251     pragma solidity ^0.8.0;
252 
253     /**
254     * @dev These functions deal with verification of Merkle Trees proofs.
255     *
256     * The proofs can be generated using the JavaScript library
257     * https://github.com/miguelmota/merkletreejs[merkletreejs].
258     * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
259     *
260     * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
261     */
262     library MerkleProof {
263         /**
264         * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
265         * defined by `root`. For this, a `proof` must be provided, containing
266         * sibling hashes on the branch from the leaf to the root of the tree. Each
267         * pair of leaves and each pair of pre-images are assumed to be sorted.
268         */
269         function verify(
270             bytes32[] memory proof,
271             bytes32 root,
272             bytes32 leaf
273         ) internal pure returns (bool) {
274             return processProof(proof, leaf) == root;
275         }
276 
277         /**
278         * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
279         * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
280         * hash matches the root of the tree. When processing the proof, the pairs
281         * of leafs & pre-images are assumed to be sorted.
282         *
283         * _Available since v4.4._
284         */
285         function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
286             bytes32 computedHash = leaf;
287             for (uint256 i = 0; i < proof.length; i++) {
288                 bytes32 proofElement = proof[i];
289                 if (computedHash <= proofElement) {
290                     // Hash(current computed hash + current element of the proof)
291                     computedHash = _efficientHash(computedHash, proofElement);
292                 } else {
293                     // Hash(current element of the proof + current computed hash)
294                     computedHash = _efficientHash(proofElement, computedHash);
295                 }
296             }
297             return computedHash;
298         }
299 
300         function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
301             assembly {
302                 mstore(0x00, a)
303                 mstore(0x20, b)
304                 value := keccak256(0x00, 0x40)
305             }
306         }
307     }
308 
309     // File: @openzeppelin/contracts/utils/Strings.sol
310 
311 
312     // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
313 
314     pragma solidity ^0.8.0;
315 
316     /**
317     * @dev String operations.
318     */
319     library Strings {
320         bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
321 
322         /**
323         * @dev Converts a `uint256` to its ASCII `string` decimal representation.
324         */
325         function toString(uint256 value) internal pure returns (string memory) {
326             // Inspired by OraclizeAPI's implementation - MIT licence
327             // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
328 
329             if (value == 0) {
330                 return "0";
331             }
332             uint256 temp = value;
333             uint256 digits;
334             while (temp != 0) {
335                 digits++;
336                 temp /= 10;
337             }
338             bytes memory buffer = new bytes(digits);
339             while (value != 0) {
340                 digits -= 1;
341                 buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
342                 value /= 10;
343             }
344             return string(buffer);
345         }
346 
347         /**
348         * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
349         */
350         function toHexString(uint256 value) internal pure returns (string memory) {
351             if (value == 0) {
352                 return "0x00";
353             }
354             uint256 temp = value;
355             uint256 length = 0;
356             while (temp != 0) {
357                 length++;
358                 temp >>= 8;
359             }
360             return toHexString(value, length);
361         }
362 
363         /**
364         * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
365         */
366         function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
367             bytes memory buffer = new bytes(2 * length + 2);
368             buffer[0] = "0";
369             buffer[1] = "x";
370             for (uint256 i = 2 * length + 1; i > 1; --i) {
371                 buffer[i] = _HEX_SYMBOLS[value & 0xf];
372                 value >>= 4;
373             }
374             require(value == 0, "Strings: hex length insufficient");
375             return string(buffer);
376         }
377     }
378 
379     // File: @openzeppelin/contracts/utils/Context.sol
380 
381 
382     // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
383 
384     pragma solidity ^0.8.0;
385 
386     /**
387     * @dev Provides information about the current execution context, including the
388     * sender of the transaction and its data. While these are generally available
389     * via msg.sender and msg.data, they should not be accessed in such a direct
390     * manner, since when dealing with meta-transactions the account sending and
391     * paying for execution may not be the actual sender (as far as an application
392     * is concerned).
393     *
394     * This contract is only required for intermediate, library-like contracts.
395     */
396     abstract contract Context {
397         function _msgSender() internal view virtual returns (address) {
398             return msg.sender;
399         }
400 
401         function _msgData() internal view virtual returns (bytes calldata) {
402             return msg.data;
403         }
404     }
405 
406     // File: @openzeppelin/contracts/access/Ownable.sol
407 
408 
409     // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
410 
411     pragma solidity ^0.8.0;
412 
413 
414     /**
415     * @dev Contract module which provides a basic access control mechanism, where
416     * there is an account (an owner) that can be granted exclusive access to
417     * specific functions.
418     *
419     * By default, the owner account will be the one that deploys the contract. This
420     * can later be changed with {transferOwnership}.
421     *
422     * This module is used through inheritance. It will make available the modifier
423     * `onlyOwner`, which can be applied to your functions to restrict their use to
424     * the owner.
425     */
426     abstract contract Ownable is Context {
427         address private _owner;
428 
429         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
430 
431         /**
432         * @dev Initializes the contract setting the deployer as the initial owner.
433         */
434         constructor() {
435             _transferOwnership(_msgSender());
436         }
437 
438         /**
439         * @dev Returns the address of the current owner.
440         */
441         function owner() public view virtual returns (address) {
442             return _owner;
443         }
444 
445         /**
446         * @dev Throws if called by any account other than the owner.
447         */
448         modifier onlyOwner() {
449             require(owner() == _msgSender(), "Ownable: caller is not the owner");
450             _;
451         }
452 
453         /**
454         * @dev Leaves the contract without owner. It will not be possible to call
455         * `onlyOwner` functions anymore. Can only be called by the current owner.
456         *
457         * NOTE: Renouncing ownership will leave the contract without an owner,
458         * thereby removing any functionality that is only available to the owner.
459         */
460         function renounceOwnership() public virtual onlyOwner {
461             _transferOwnership(address(0));
462         }
463 
464         /**
465         * @dev Transfers ownership of the contract to a new account (`newOwner`).
466         * Can only be called by the current owner.
467         */
468         function transferOwnership(address newOwner) public virtual onlyOwner {
469             require(newOwner != address(0), "Ownable: new owner is the zero address");
470             _transferOwnership(newOwner);
471         }
472 
473         /**
474         * @dev Transfers ownership of the contract to a new account (`newOwner`).
475         * Internal function without access restriction.
476         */
477         function _transferOwnership(address newOwner) internal virtual {
478             address oldOwner = _owner;
479             _owner = newOwner;
480             emit OwnershipTransferred(oldOwner, newOwner);
481         }
482     } 
483 
484     // File: @openzeppelin/contracts/utils/Address.sol
485 
486 
487     // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
488 
489     pragma solidity ^0.8.1;
490 
491     /**
492     * @dev Collection of functions related to the address type
493     */
494     library Address {
495         /**
496         * @dev Returns true if `account` is a contract.
497         *
498         * [IMPORTANT]
499         * ====
500         * It is unsafe to assume that an address for which this function returns
501         * false is an externally-owned account (EOA) and not a contract.
502         *
503         * Among others, `isContract` will return false for the following
504         * types of addresses:
505         *
506         *  - an externally-owned account
507         *  - a contract in construction
508         *  - an address where a contract will be created
509         *  - an address where a contract lived, but was destroyed
510         * ====
511         *
512         * [IMPORTANT]
513         * ====
514         * You shouldn't rely on `isContract` to protect against flash loan attacks!
515         *
516         * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
517         * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
518         * constructor.
519         * ====
520         */
521         function isContract(address account) internal view returns (bool) {
522             // This method relies on extcodesize/address.code.length, which returns 0
523             // for contracts in construction, since the code is only stored at the end
524             // of the constructor execution.
525 
526             return account.code.length > 0;
527         }
528 
529         /**
530         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
531         * `recipient`, forwarding all available gas and reverting on errors.
532         *
533         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
534         * of certain opcodes, possibly making contracts go over the 2300 gas limit
535         * imposed by `transfer`, making them unable to receive funds via
536         * `transfer`. {sendValue} removes this limitation.
537         *
538         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
539         *
540         * IMPORTANT: because control is transferred to `recipient`, care must be
541         * taken to not create reentrancy vulnerabilities. Consider using
542         * {ReentrancyGuard} or the
543         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
544         */
545         function sendValue(address payable recipient, uint256 amount) internal {
546             require(address(this).balance >= amount, "Address: insufficient balance");
547 
548             (bool success, ) = recipient.call{value: amount}("");
549             require(success, "Address: unable to send value, recipient may have reverted");
550         }
551 
552         /**
553         * @dev Performs a Solidity function call using a low level `call`. A
554         * plain `call` is an unsafe replacement for a function call: use this
555         * function instead.
556         *
557         * If `target` reverts with a revert reason, it is bubbled up by this
558         * function (like regular Solidity function calls).
559         *
560         * Returns the raw returned data. To convert to the expected return value,
561         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
562         *
563         * Requirements:
564         *
565         * - `target` must be a contract.
566         * - calling `target` with `data` must not revert.
567         *
568         * _Available since v3.1._
569         */
570         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
571             return functionCall(target, data, "Address: low-level call failed");
572         }
573 
574         /**
575         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
576         * `errorMessage` as a fallback revert reason when `target` reverts.
577         *
578         * _Available since v3.1._
579         */
580         function functionCall(
581             address target,
582             bytes memory data,
583             string memory errorMessage
584         ) internal returns (bytes memory) {
585             return functionCallWithValue(target, data, 0, errorMessage);
586         }
587 
588         /**
589         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
590         * but also transferring `value` wei to `target`.
591         *
592         * Requirements:
593         *
594         * - the calling contract must have an ETH balance of at least `value`.
595         * - the called Solidity function must be `payable`.
596         *
597         * _Available since v3.1._
598         */
599         function functionCallWithValue(
600             address target,
601             bytes memory data,
602             uint256 value
603         ) internal returns (bytes memory) {
604             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
605         }
606 
607         /**
608         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
609         * with `errorMessage` as a fallback revert reason when `target` reverts.
610         *
611         * _Available since v3.1._
612         */
613         function functionCallWithValue(
614             address target,
615             bytes memory data,
616             uint256 value,
617             string memory errorMessage
618         ) internal returns (bytes memory) {
619             require(address(this).balance >= value, "Address: insufficient balance for call");
620             require(isContract(target), "Address: call to non-contract");
621 
622             (bool success, bytes memory returndata) = target.call{value: value}(data);
623             return verifyCallResult(success, returndata, errorMessage);
624         }
625 
626         /**
627         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
628         * but performing a static call.
629         *
630         * _Available since v3.3._
631         */
632         function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
633             return functionStaticCall(target, data, "Address: low-level static call failed");
634         }
635 
636         /**
637         * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
638         * but performing a static call.
639         *
640         * _Available since v3.3._
641         */
642         function functionStaticCall(
643             address target,
644             bytes memory data,
645             string memory errorMessage
646         ) internal view returns (bytes memory) {
647             require(isContract(target), "Address: static call to non-contract");
648 
649             (bool success, bytes memory returndata) = target.staticcall(data);
650             return verifyCallResult(success, returndata, errorMessage);
651         }
652 
653         /**
654         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
655         * but performing a delegate call.
656         *
657         * _Available since v3.4._
658         */
659         function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
660             return functionDelegateCall(target, data, "Address: low-level delegate call failed");
661         }
662 
663         /**
664         * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
665         * but performing a delegate call.
666         *
667         * _Available since v3.4._
668         */
669         function functionDelegateCall(
670             address target,
671             bytes memory data,
672             string memory errorMessage
673         ) internal returns (bytes memory) {
674             require(isContract(target), "Address: delegate call to non-contract");
675 
676             (bool success, bytes memory returndata) = target.delegatecall(data);
677             return verifyCallResult(success, returndata, errorMessage);
678         }
679 
680         /**
681         * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
682         * revert reason using the provided one.
683         *
684         * _Available since v4.3._
685         */
686         function verifyCallResult(
687             bool success,
688             bytes memory returndata,
689             string memory errorMessage
690         ) internal pure returns (bytes memory) {
691             if (success) {
692                 return returndata;
693             } else {
694                 // Look for revert reason and bubble it up if present
695                 if (returndata.length > 0) {
696                     // The easiest way to bubble the revert reason is using memory via assembly
697 
698                     assembly {
699                         let returndata_size := mload(returndata)
700                         revert(add(32, returndata), returndata_size)
701                     }
702                 } else {
703                     revert(errorMessage);
704                 }
705             }
706         }
707     }
708 
709     // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
710 
711 
712     // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
713 
714     // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
715 
716 
717     // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
718 
719 
720     // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
721 
722 
723     // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
724 
725     pragma solidity ^0.8.0;
726 
727     /**
728     * @title ERC721 token receiver interface
729     * @dev Interface for any contract that wants to support safeTransfers
730     * from ERC721 asset contracts.
731     */
732     interface IERC721Receiver {
733         /**
734         * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
735         * by `operator` from `from`, this function is called.
736         *
737         * It must return its Solidity selector to confirm the token transfer.
738         * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
739         *
740         * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
741         */
742         function onERC721Received(
743             address operator,
744             address from,
745             uint256 tokenId,
746             bytes calldata data
747         ) external returns (bytes4);
748     }
749 
750     // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
751 
752 
753     // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
754 
755     pragma solidity ^0.8.0;
756 
757     /**
758     * @dev Interface of the ERC165 standard, as defined in the
759     * https://eips.ethereum.org/EIPS/eip-165[EIP].
760     *
761     * Implementers can declare support of contract interfaces, which can then be
762     * queried by others ({ERC165Checker}).
763     *
764     * For an implementation, see {ERC165}.
765     */
766     interface IERC165 {
767         /**
768         * @dev Returns true if this contract implements the interface defined by
769         * `interfaceId`. See the corresponding
770         * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
771         * to learn more about how these ids are created.
772         *
773         * This function call must use less than 30 000 gas.
774         */
775         function supportsInterface(bytes4 interfaceId) external view returns (bool);
776     }
777 
778     // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
779 
780 
781     // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
782 
783     pragma solidity ^0.8.0;
784 
785 
786     /**
787     * @dev Implementation of the {IERC165} interface.
788     *
789     * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
790     * for the additional interface id that will be supported. For example:
791     *
792     * ```solidity
793     * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
794     *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
795     * }
796     * ```
797     *
798     * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
799     */
800     abstract contract ERC165 is IERC165 {
801         /**
802         * @dev See {IERC165-supportsInterface}.
803         */
804         function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
805             return interfaceId == type(IERC165).interfaceId;
806         }
807     }
808 
809     // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
810 
811 
812     // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
813 
814     pragma solidity ^0.8.0;
815 
816 
817     /**
818     * @dev Required interface of an ERC721 compliant contract.
819     */
820     interface IERC721 is IERC165 {
821         /**
822         * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
823         */
824         event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
825 
826         /**
827         * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
828         */
829         event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
830 
831         /**
832         * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
833         */
834         event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
835 
836         /**
837         * @dev Returns the number of tokens in ``owner``'s account.
838         */
839         function balanceOf(address owner) external view returns (uint256 balance);
840 
841         /**
842         * @dev Returns the owner of the `tokenId` token.
843         *
844         * Requirements:
845         *
846         * - `tokenId` must exist.
847         */
848         function ownerOf(uint256 tokenId) external view returns (address owner);
849 
850         /**
851         * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
852         * are aware of the ERC721 protocol to prevent tokens from being forever locked.
853         *
854         * Requirements:
855         *
856         * - `from` cannot be the zero address.
857         * - `to` cannot be the zero address.
858         * - `tokenId` token must exist and be owned by `from`.
859         * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
860         * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
861         *
862         * Emits a {Transfer} event.
863         */
864         function safeTransferFrom(
865             address from,
866             address to,
867             uint256 tokenId
868         ) external;
869 
870         /**
871         * @dev Transfers `tokenId` token from `from` to `to`.
872         *
873         * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
874         *
875         * Requirements:
876         *
877         * - `from` cannot be the zero address.
878         * - `to` cannot be the zero address.
879         * - `tokenId` token must be owned by `from`.
880         * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
881         *
882         * Emits a {Transfer} event.
883         */
884         function transferFrom(
885             address from,
886             address to,
887             uint256 tokenId
888         ) external;
889 
890         /**
891         * @dev Gives permission to `to` to transfer `tokenId` token to another account.
892         * The approval is cleared when the token is transferred.
893         *
894         * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
895         *
896         * Requirements:
897         *
898         * - The caller must own the token or be an approved operator.
899         * - `tokenId` must exist.
900         *
901         * Emits an {Approval} event.
902         */
903         function approve(address to, uint256 tokenId) external;
904 
905         /**
906         * @dev Returns the account approved for `tokenId` token.
907         *
908         * Requirements:
909         *
910         * - `tokenId` must exist.
911         */
912         function getApproved(uint256 tokenId) external view returns (address operator);
913 
914         /**
915         * @dev Approve or remove `operator` as an operator for the caller.
916         * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
917         *
918         * Requirements:
919         *
920         * - The `operator` cannot be the caller.
921         *
922         * Emits an {ApprovalForAll} event.
923         */
924         function setApprovalForAll(address operator, bool _approved) external;
925 
926         /**
927         * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
928         *
929         * See {setApprovalForAll}
930         */
931         function isApprovedForAll(address owner, address operator) external view returns (bool);
932 
933         /**
934         * @dev Safely transfers `tokenId` token from `from` to `to`.
935         *
936         * Requirements:
937         *
938         * - `from` cannot be the zero address.
939         * - `to` cannot be the zero address.
940         * - `tokenId` token must exist and be owned by `from`.
941         * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
942         * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
943         *
944         * Emits a {Transfer} event.
945         */
946         function safeTransferFrom(
947             address from,
948             address to,
949             uint256 tokenId,
950             bytes calldata data
951         ) external;
952     }
953 
954     // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
955 
956 
957     // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
958 
959     pragma solidity ^0.8.0;
960 
961 
962     /**
963     * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
964     * @dev See https://eips.ethereum.org/EIPS/eip-721
965     */
966     interface IERC721Enumerable is IERC721 {
967         /**
968         * @dev Returns the total amount of tokens stored by the contract.
969         */
970         function totalSupply() external view returns (uint256);
971 
972         /**
973         * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
974         * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
975         */
976         function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
977 
978         /**
979         * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
980         * Use along with {totalSupply} to enumerate all tokens.
981         */
982         function tokenByIndex(uint256 index) external view returns (uint256);
983     }
984 
985     // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
986 
987 
988     // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
989 
990     pragma solidity ^0.8.0;
991 
992 
993     /**
994     * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
995     * @dev See https://eips.ethereum.org/EIPS/eip-721
996     */
997     interface IERC721Metadata is IERC721 {
998         /**
999         * @dev Returns the token collection name.
1000         */
1001         function name() external view returns (string memory);
1002 
1003         /**
1004         * @dev Returns the token collection symbol.
1005         */
1006         function symbol() external view returns (string memory);
1007 
1008         /**
1009         * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1010         */
1011         function tokenURI(uint256 tokenId) external view returns (string memory);
1012     }
1013 
1014     // File: erc721a/contracts/ERC721A.sol
1015 
1016 
1017     // Creator: Chiru Labs
1018 
1019     pragma solidity ^0.8.4;
1020 
1021 
1022 
1023 
1024 
1025 
1026 
1027 
1028 
1029     error ApprovalCallerNotOwnerNorApproved();
1030     error ApprovalQueryForNonexistentToken();
1031     error ApproveToCaller();
1032     error ApprovalToCurrentOwner();
1033     error BalanceQueryForZeroAddress();
1034     error MintedQueryForZeroAddress();
1035     error BurnedQueryForZeroAddress();
1036     error AuxQueryForZeroAddress();
1037     error MintToZeroAddress();
1038     error MintZeroQuantity();
1039     error OwnerIndexOutOfBounds();
1040     error OwnerQueryForNonexistentToken();
1041     error TokenIndexOutOfBounds();
1042     error TransferCallerNotOwnerNorApproved();
1043     error TransferFromIncorrectOwner();
1044     error TransferToNonERC721ReceiverImplementer();
1045     error TransferToZeroAddress();
1046     error URIQueryForNonexistentToken();
1047 
1048     /**
1049     * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1050     * the Metadata extension. Built to optimize for lower gas during batch mints.
1051     *
1052     * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1053     *
1054     * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1055     *
1056     * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1057     */
1058     contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1059         using Address for address;
1060         using Strings for uint256;
1061 
1062         // Compiler will pack this into a single 256bit word.
1063         struct TokenOwnership {
1064             // The address of the owner.
1065             address addr;
1066             // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1067             uint64 startTimestamp;
1068             // Whether the token has been burned.
1069             bool burned;
1070         }
1071 
1072         // Compiler will pack this into a single 256bit word.
1073         struct AddressData {
1074             // Realistically, 2**64-1 is more than enough.
1075             uint64 balance;
1076             // Keeps track of mint count with minimal overhead for tokenomics.
1077             uint64 numberMinted;
1078             // Keeps track of burn count with minimal overhead for tokenomics.
1079             uint64 numberBurned;
1080             // For miscellaneous variable(s) pertaining to the address
1081             // (e.g. number of whitelist mint slots used).
1082             // If there are multiple variables, please pack them into a uint64.
1083             uint64 mintedInWhitelist;
1084         }
1085 
1086         // The tokenId of the next token to be minted.
1087         uint256 internal _currentIndex;
1088 
1089         // The number of tokens burned.
1090         uint256 internal _burnCounter;
1091 
1092         // Token name
1093         string private _name;
1094 
1095         // Token symbol
1096         string private _symbol;
1097 
1098         // Mapping from token ID to ownership details
1099         // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1100         mapping(uint256 => TokenOwnership) internal _ownerships;
1101 
1102         // Mapping owner address to address data
1103         mapping(address => AddressData) private _addressData;
1104 
1105         // Mapping from token ID to approved address
1106         mapping(uint256 => address) private _tokenApprovals;
1107 
1108         // Mapping from owner to operator approvals
1109         mapping(address => mapping(address => bool)) private _operatorApprovals;
1110 
1111         constructor(string memory name_, string memory symbol_) {
1112             _name = name_;
1113             _symbol = symbol_;
1114             _currentIndex = _startTokenId();
1115         }
1116 
1117         /**
1118         * To change the starting tokenId, please override this function.
1119         */
1120         function _startTokenId() internal view virtual returns (uint256) {
1121             return 0;
1122         }
1123 
1124         /**
1125         * @dev See {IERC721Enumerable-totalSupply}.
1126         * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1127         */
1128         function totalSupply() public view returns (uint256) {
1129             // Counter underflow is impossible as _burnCounter cannot be incremented
1130             // more than _currentIndex - _startTokenId() times
1131             unchecked {
1132                 return _currentIndex - _burnCounter - _startTokenId();
1133             }
1134         }
1135 
1136         /**
1137         * Returns the total amount of tokens minted in the contract.
1138         */
1139         function _totalMinted() internal view returns (uint256) {
1140             // Counter underflow is impossible as _currentIndex does not decrement,
1141             // and it is initialized to _startTokenId()
1142             unchecked {
1143                 return _currentIndex - _startTokenId();
1144             }
1145         }
1146 
1147         /**
1148         * @dev See {IERC165-supportsInterface}.
1149         */
1150         function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1151             return
1152                 interfaceId == type(IERC721).interfaceId ||
1153                 interfaceId == type(IERC721Metadata).interfaceId ||
1154                 super.supportsInterface(interfaceId);
1155         }
1156 
1157         /**
1158         * @dev See {IERC721-balanceOf}.
1159         */
1160         function balanceOf(address owner) public view override returns (uint256) {
1161             if (owner == address(0)) revert BalanceQueryForZeroAddress();
1162             return uint256(_addressData[owner].balance);
1163         }
1164 
1165         /**
1166         * Returns the number of tokens minted by `owner`.
1167         */
1168 
1169         /**
1170         * Returns the number of tokens burned by or on behalf of `owner`.
1171         */
1172         function _numberBurned(address owner) internal view returns (uint256) {
1173             if (owner == address(0)) revert BurnedQueryForZeroAddress();
1174             return uint256(_addressData[owner].numberBurned);
1175         }
1176 
1177         /**
1178         * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1179         */
1180         function _getNumberMintedInWhitelist(address owner) public view returns (uint64) {
1181             if (owner == address(0)) revert AuxQueryForZeroAddress();
1182             return _addressData[owner].mintedInWhitelist;
1183         }
1184 
1185         /**
1186         * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1187         * If there are multiple variables, please pack them into a uint64.
1188         */
1189         function _increaseNumberMintedInWhitelist(address owner, uint64 aux) internal {
1190             if (owner == address(0)) revert AuxQueryForZeroAddress();
1191             _addressData[owner].mintedInWhitelist += aux;
1192         }
1193 
1194         /**
1195         * Gas spent here starts off proportional to the maximum mint batch size.
1196         * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1197         */
1198         function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1199             uint256 curr = tokenId;
1200 
1201             unchecked {
1202                 if (_startTokenId() <= curr && curr < _currentIndex) {
1203                     TokenOwnership memory ownership = _ownerships[curr];
1204                     if (!ownership.burned) {
1205                         if (ownership.addr != address(0)) {
1206                             return ownership;
1207                         }
1208                         // Invariant:
1209                         // There will always be an ownership that has an address and is not burned
1210                         // before an ownership that does not have an address and is not burned.
1211                         // Hence, curr will not underflow.
1212                         while (true) {
1213                             curr--;
1214                             ownership = _ownerships[curr];
1215                             if (ownership.addr != address(0)) {
1216                                 return ownership;
1217                             }
1218                         }
1219                     }
1220                 }
1221             }
1222             revert OwnerQueryForNonexistentToken();
1223         }
1224 
1225         /**
1226         * @dev See {IERC721-ownerOf}.
1227         */
1228         function ownerOf(uint256 tokenId) public view override returns (address) {
1229             return ownershipOf(tokenId).addr;
1230         }
1231 
1232         /**
1233         * @dev See {IERC721Metadata-name}.
1234         */
1235         function name() public view virtual override returns (string memory) {
1236             return _name;
1237         }
1238 
1239         /**
1240         * @dev See {IERC721Metadata-symbol}.
1241         */
1242         function symbol() public view virtual override returns (string memory) {
1243             return _symbol;
1244         }
1245 
1246         /**
1247         * @dev See {IERC721Metadata-tokenURI}.
1248         */
1249         function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1250             if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1251 
1252             string memory baseURI = _baseURI();
1253             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1254         }
1255 
1256         /**
1257         * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1258         * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1259         * by default, can be overriden in child contracts.
1260         */
1261         function _baseURI() internal view virtual returns (string memory) {
1262             return '';
1263         }
1264 
1265         /**
1266         * @dev See {IERC721-approve}.
1267         */
1268         function approve(address to, uint256 tokenId) public override {
1269             address owner = ERC721A.ownerOf(tokenId);
1270             if (to == owner) revert ApprovalToCurrentOwner();
1271 
1272             if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1273                 revert ApprovalCallerNotOwnerNorApproved();
1274             }
1275 
1276             _approve(to, tokenId, owner);
1277         }
1278 
1279         /**
1280         * @dev See {IERC721-getApproved}.
1281         */
1282         function getApproved(uint256 tokenId) public view override returns (address) {
1283             if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1284 
1285             return _tokenApprovals[tokenId];
1286         }
1287 
1288         /**
1289         * @dev See {IERC721-setApprovalForAll}.
1290         */
1291         function setApprovalForAll(address operator, bool approved) public override {
1292             if (operator == _msgSender()) revert ApproveToCaller();
1293 
1294             _operatorApprovals[_msgSender()][operator] = approved;
1295             emit ApprovalForAll(_msgSender(), operator, approved);
1296         }
1297 
1298         /**
1299         * @dev See {IERC721-isApprovedForAll}.
1300         */
1301         function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1302             return _operatorApprovals[owner][operator];
1303         }
1304 
1305         /**
1306         * @dev See {IERC721-transferFrom}.
1307         */
1308         function transferFrom(
1309             address from,
1310             address to,
1311             uint256 tokenId
1312         ) public virtual override {
1313             _transfer(from, to, tokenId);
1314         }
1315 
1316         /**
1317         * @dev See {IERC721-safeTransferFrom}.
1318         */
1319         function safeTransferFrom(
1320             address from,
1321             address to,
1322             uint256 tokenId
1323         ) public virtual override {
1324             safeTransferFrom(from, to, tokenId, '');
1325         }
1326         
1327         /**
1328         * @dev See {IERC721-safeTransferFrom}.
1329         */
1330         function safeTransferFrom(
1331             address from,
1332             address to,
1333             uint256 tokenId,
1334             bytes memory _data
1335         ) public virtual override {
1336             _transfer(from, to, tokenId);
1337             if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1338                 revert TransferToNonERC721ReceiverImplementer();
1339             }
1340         }
1341 
1342         /**
1343         * @dev Returns whether `tokenId` exists.
1344         *
1345         * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1346         *
1347         * Tokens start existing when they are minted (`_mint`),
1348         */
1349         function _exists(uint256 tokenId) internal view returns (bool) {
1350             return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1351                 !_ownerships[tokenId].burned;
1352         }
1353 
1354         function _safeMint(address to, uint256 quantity) internal {
1355             _safeMint(to, quantity, '');
1356         }
1357 
1358         /**
1359         * @dev Safely mints `quantity` tokens and transfers them to `to`.
1360         *
1361         * Requirements:
1362         *
1363         * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1364         * - `quantity` must be greater than 0.
1365         *
1366         * Emits a {Transfer} event.
1367         */
1368         function _safeMint(
1369             address to,
1370             uint256 quantity,
1371             bytes memory _data
1372         ) internal {
1373             _mint(to, quantity, _data, true);
1374         }
1375 
1376         /**
1377         * @dev Mints `quantity` tokens and transfers them to `to`.
1378         *
1379         * Requirements:
1380         *
1381         * - `to` cannot be the zero address.
1382         * - `quantity` must be greater than 0.
1383         *0
1384         * Emits a {Transfer} event.
1385         */
1386         function _mint(
1387             address to,
1388             uint256 quantity,
1389             bytes memory _data,
1390             bool safe
1391         ) internal {
1392             uint256 startTokenId = _currentIndex;
1393             if (to == address(0)) revert MintToZeroAddress();
1394             if (quantity == 0) revert MintZeroQuantity();
1395 
1396             _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1397 
1398             // Overflows are incredibly unrealistic.
1399             // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1400             // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1401             unchecked {
1402                 _addressData[to].balance += uint64(quantity);
1403                 _addressData[to].numberMinted += uint64(quantity);
1404 
1405                 _ownerships[startTokenId].addr = to;
1406                 _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1407 
1408                 uint256 updatedIndex = startTokenId;
1409                 uint256 end = updatedIndex + quantity;
1410 
1411                 if (safe && to.isContract()) {
1412                     do {
1413                         emit Transfer(address(0), to, updatedIndex);
1414                         if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1415                             revert TransferToNonERC721ReceiverImplementer();
1416                         }
1417                     } while (updatedIndex != end);
1418                     // Reentrancy protection
1419                     if (_currentIndex != startTokenId) revert();
1420                 } else {
1421                     do {
1422                         emit Transfer(address(0), to, updatedIndex++);
1423                     } while (updatedIndex != end);
1424                 }
1425                 _currentIndex = updatedIndex;
1426             }
1427             _afterTokenTransfers(address(0), to, startTokenId, quantity);
1428         }
1429     
1430         /**
1431         * @dev Transfers `tokenId` from `from` to `to`.
1432         *
1433         * Requirements:
1434         *
1435         * - `to` cannot be the zero address.
1436         * - `tokenId` token must be owned by `from`.
1437         *
1438         * Emits a {Transfer} event.
1439         */
1440         function _transfer(
1441             address from,
1442             address to,
1443             uint256 tokenId
1444         ) private {
1445             TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1446 
1447             bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1448                 isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1449                 getApproved(tokenId) == _msgSender());
1450 
1451             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1452             if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1453             if (to == address(0)) revert TransferToZeroAddress();
1454 
1455             _beforeTokenTransfers(from, to, tokenId, 1);
1456 
1457             // Clear approvals from the previous owner
1458             _approve(address(0), tokenId, prevOwnership.addr);
1459 
1460             // Underflow of the sender's balance is impossible because we check for
1461             // ownership above and the recipient's balance can't realistically overflow.
1462             // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1463             unchecked {
1464                 _addressData[from].balance -= 1;
1465                 _addressData[to].balance += 1;
1466 
1467                 _ownerships[tokenId].addr = to;
1468                 _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1469 
1470                 // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1471                 // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1472                 uint256 nextTokenId = tokenId + 1;
1473                 if (_ownerships[nextTokenId].addr == address(0)) {
1474                     // This will suffice for checking _exists(nextTokenId),
1475                     // as a burned slot cannot contain the zero address.
1476                     if (nextTokenId < _currentIndex) {
1477                         _ownerships[nextTokenId].addr = prevOwnership.addr;
1478                         _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1479                     }
1480                 }
1481             }
1482 
1483             emit Transfer(from, to, tokenId);
1484             _afterTokenTransfers(from, to, tokenId, 1);
1485         }
1486 
1487         /**
1488         * @dev Destroys `tokenId`.
1489         * The approval is cleared when the token is burned.
1490         *
1491         * Requirements:
1492         *
1493         * - `tokenId` must exist.
1494         *
1495         * Emits a {Transfer} event.
1496         */
1497         function _burn(uint256 tokenId) internal virtual {
1498             TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1499 
1500             _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1501 
1502             // Clear approvals from the previous owner
1503             _approve(address(0), tokenId, prevOwnership.addr);
1504 
1505             // Underflow of the sender's balance is impossible because we check for
1506             // ownership above and the recipient's balance can't realistically overflow.
1507             // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1508             unchecked {
1509                 _addressData[prevOwnership.addr].balance -= 1;
1510                 _addressData[prevOwnership.addr].numberBurned += 1;
1511 
1512                 // Keep track of who burned the token, and the timestamp of burning.
1513                 _ownerships[tokenId].addr = prevOwnership.addr;
1514                 _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1515                 _ownerships[tokenId].burned = true;
1516 
1517                 // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1518                 // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1519                 uint256 nextTokenId = tokenId + 1;
1520                 if (_ownerships[nextTokenId].addr == address(0)) {
1521                     // This will suffice for checking _exists(nextTokenId),
1522                     // as a burned slot cannot contain the zero address.
1523                     if (nextTokenId < _currentIndex) {
1524                         _ownerships[nextTokenId].addr = prevOwnership.addr;
1525                         _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1526                     }
1527                 }
1528             }
1529 
1530             emit Transfer(prevOwnership.addr, address(0), tokenId);
1531             _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1532 
1533             // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1534             unchecked {
1535                 _burnCounter++;
1536             }
1537         }
1538 
1539         /**
1540         * @dev Approve `to` to operate on `tokenId`
1541         *
1542         * Emits a {Approval} event.
1543         */
1544         function _approve(
1545             address to,
1546             uint256 tokenId,
1547             address owner
1548         ) private {
1549             _tokenApprovals[tokenId] = to;
1550             emit Approval(owner, to, tokenId);
1551         }
1552 
1553         /**
1554         * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1555         *
1556         * @param from address representing the previous owner of the given token ID
1557         * @param to target address that will receive the tokens
1558         * @param tokenId uint256 ID of the token to be transferred
1559         * @param _data bytes optional data to send along with the call
1560         * @return bool whether the call correctly returned the expected magic value
1561         */
1562         function _checkContractOnERC721Received(
1563             address from,
1564             address to,
1565             uint256 tokenId,
1566             bytes memory _data
1567         ) private returns (bool) {
1568             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1569                 return retval == IERC721Receiver(to).onERC721Received.selector;
1570             } catch (bytes memory reason) {
1571                 if (reason.length == 0) {
1572                     revert TransferToNonERC721ReceiverImplementer();
1573                 } else {
1574                     assembly {
1575                         revert(add(32, reason), mload(reason))
1576                     }
1577                 }
1578             }
1579         }
1580 
1581         /**
1582         * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1583         * And also called before burning one token.
1584         *
1585         * startTokenId - the first token id to be transferred
1586         * quantity - the amount to be transferred
1587         *
1588         * Calling conditions:
1589         *
1590         * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1591         * transferred to `to`.
1592         * - When `from` is zero, `tokenId` will be minted for `to`.
1593         * - When `to` is zero, `tokenId` will be burned by `from`.
1594         * - `from` and `to` are never both zero.
1595         */
1596         function _beforeTokenTransfers(
1597             address from,
1598             address to,
1599             uint256 startTokenId,
1600             uint256 quantity
1601         ) internal virtual {}
1602 
1603         /**
1604         * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1605         * minting.
1606         * And also called after one token has been burned.
1607         *
1608         * startTokenId - the first token id to be transferred
1609         * quantity - the amount to be transferred
1610         *
1611         * Calling conditions:
1612         *
1613         * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1614         * transferred to `to`.
1615         * - When `from` is zero, `tokenId` has been minted for `to`.
1616         * - When `to` is zero, `tokenId` has been burned by `from`.
1617         * - `from` and `to` are never both zero.
1618         */
1619         function _afterTokenTransfers(
1620             address from,
1621             address to,
1622             uint256 startTokenId,
1623             uint256 quantity
1624         ) internal virtual {}
1625     }
1626 
1627     // File: erc721a/contracts/extensions/ERC721ABurnable.sol
1628 
1629 
1630     // Creator: Chiru Labs
1631 
1632     pragma solidity ^0.8.4;
1633 
1634 
1635 
1636     /**
1637     * @title ERC721A Burnable Token
1638     * @dev ERC721A Token that can be irreversibly burned (destroyed).
1639     */
1640     abstract contract ERC721ABurnable is Context, ERC721A {
1641 
1642         /**
1643         * @dev Burns `tokenId`. See {ERC721A-_burn}.
1644         *
1645         * Requirements:
1646         *
1647         * - The caller must own `tokenId` or be an approved operator.
1648         */
1649         function burn(uint256 tokenId) public virtual {
1650             TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1651 
1652             bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1653                 isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1654                 getApproved(tokenId) == _msgSender());
1655 
1656             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1657 
1658             _burn(tokenId);
1659         }
1660     }
1661     // File: contracts/MDMA.sol
1662 
1663 
1664     pragma solidity ^0.8.4;
1665 
1666 
1667 
1668 
1669     //AE THER   
1670 
1671     contract Akyllers is ERC721A, Ownable, ReentrancyGuard , ERC721ABurnable {
1672 
1673     using Strings for uint256;
1674     uint256 public constant  maxSupply = 4444; 
1675     bytes32 public merkleRoot;
1676     string public  baseUri; 
1677     string public  obscurumuri;
1678 
1679     string public extension;  
1680     uint256 public cost;  
1681 
1682     uint256 public maxperaddress; 
1683     uint256 public supplyLimit; 
1684     bool public paused = true;
1685     bool public whitelistMintEnabled = true;
1686     bool public revealed = false;
1687     string public constant provenance = "d05ad6c8d7fb2569b8fe8e4942e6d3591eb6cf5bc75bcbc691613b4143587526";
1688     uint256 public startingIndex;
1689     //mapping ID=>address => number of minted nfts  
1690     mapping(address => uint256) public addresstxs;
1691     uint256 phaseTag=0;
1692     
1693     constructor(
1694         string memory _Name,
1695         string memory _Symbol,
1696         uint256 _cost,
1697         uint256 _maxperaddress,
1698         uint256 _supplyLimit,
1699         bytes32 _merkleRoot,
1700         string memory _obscurumUri, 
1701         string memory _extension
1702     
1703     ) ERC721A(_Name, _Symbol) {
1704         // deploy the contract with the PWL parameters
1705         cost= _cost;
1706         maxperaddress = _maxperaddress;
1707         obscurumuri = _obscurumUri;
1708         extension = _extension;  
1709         merkleRoot = _merkleRoot;
1710         require(supplyLimit<=maxSupply);
1711         supplyLimit = _supplyLimit;
1712     }
1713 
1714     //resets the amount of nft bought from whitelisted suer if the phase changes
1715     function _startTokenId() internal pure override returns (uint256){
1716         return 1;
1717     }
1718 
1719     function validateGreaterThanZero(uint256 _value) public pure {
1720         require(_value>0, "amount cannot be zero");
1721     }
1722 
1723     function validateAmount(uint256 _mintAmount, uint256 maxAmount) public view{
1724         validateGreaterThanZero(_mintAmount);
1725         require(_totalMinted() + _mintAmount <= maxAmount, 'Max supply in this phase exceeded');  
1726     }
1727 
1728 
1729     function validatePrice(uint256 value, uint256 _mintAmount) public view{
1730         validateGreaterThanZero(_mintAmount); //va;idates mint amount 
1731         if(cost > 0) {require(value == cost * _mintAmount, 'Incorrect amount ');}
1732     }
1733     function validateNotPaused() public view{
1734         require(!paused, "Still In phase"); 
1735     }    
1736     function validateWhitelistState(bool state) public view {
1737         require(whitelistMintEnabled==state);
1738     }
1739 
1740     function validateMintPerAddress(address sender, uint256 _mintAmount, uint256 addressT, uint256 whitelistT) public {
1741         //Address tag is the the phase tag that address is in
1742         uint256 value = addressT;
1743         /*
1744             addresstxs[sender]  tracks both amount and phase tag 
1745             addresstxs[sender] =  1        0
1746                                 amount   phaseTag
1747             amount = addresstxs[sender]/10
1748             phaseTag = addresstxs[sender]%10
1749         */
1750         //checks if the address tag is the same as phase tag 
1751         if( (value%10) !=whitelistT ) {
1752             //checks if the amount entered is greater than max per address then updates 
1753             require(_mintAmount<=maxperaddress,"wallet limit exceeded");
1754             addresstxs[sender]=(_mintAmount*10)+whitelistT;
1755         } else {
1756             require((value/10) + _mintAmount <= maxperaddress, 'wallet limit exceeded ');
1757             addresstxs[sender] += (_mintAmount*10);
1758         }
1759     }
1760 
1761     function Presalemint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable nonReentrant {
1762         //verify that the supply is not exceeded by address in specifc whitelist phase
1763         validateAmount(_mintAmount, supplyLimit);
1764         validatePrice(msg.value, _mintAmount);
1765         // Verify whitelist requirements dont allow mints when public sale starts
1766         require(MerkleProof.verify(_merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), 'Invalid proof!');
1767         //verify that minting is not paused
1768         validateNotPaused();
1769         //verify that the smart contract in the whitelist phase
1770         validateWhitelistState(true);
1771         //change the phase 
1772         validateMintPerAddress(msg.sender,_mintAmount, addresstxs[msg.sender], phaseTag);
1773         //minting 
1774         _safeMint(msg.sender, _mintAmount);
1775         
1776     }
1777     //Normal minting allows minting on public sale satisfyign the necessary conditions
1778 
1779     
1780     
1781     function Airdrop(uint256[] memory  _mintAmount, address[] memory   _receivers) public nonReentrant  onlyOwner {
1782         require(_mintAmount.length == _receivers.length, "Arrays need to be equal and respective");
1783         for(uint i = 0; i < _mintAmount.length;) {
1784             validateAmount(_mintAmount[i], maxSupply);
1785             _safeMint(_receivers[i], _mintAmount[i]);
1786             unchecked{i++;}
1787         }
1788     }
1789 
1790     //Normal minting allows minting on public sale satisfyign the necessary conditions
1791     function mint(uint256 _mintAmount) public payable  nonReentrant {
1792         //verifies that the amount minted is within address limits and within max supply
1793         validateAmount(_mintAmount, maxSupply);
1794         //verifies price compliance
1795         validatePrice(msg.value,_mintAmount);
1796         //verifies that smart contract is in Public state
1797         validateWhitelistState(false);
1798         //verifiesthat Public Minting is not paused
1799         validateNotPaused();
1800         //validate amount minted per address in public sale
1801         validateMintPerAddress(msg.sender,_mintAmount, addresstxs[msg.sender], phaseTag);
1802         //minting
1803         _safeMint(msg.sender, _mintAmount);
1804     } 
1805 
1806     // get multiple ids that a owner owns  excluding burned tokens  this function is for future off or on chain data gathering 
1807     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1808         uint256 ownerTokenCount = balanceOf(_owner);
1809         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1810         uint256 currentTokenId = _startTokenId();
1811         uint256 ownedTokenIndex = 0;
1812         address latestOwnerAddress;
1813         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= _totalMinted() ) {
1814         TokenOwnership memory ownership = _ownerships[currentTokenId]; 
1815         if (!ownership.burned && ownership.addr != address(0)) {
1816             latestOwnerAddress = ownership.addr; 
1817         }
1818         if (latestOwnerAddress == _owner &&  !ownership.burned )  {
1819             ownedTokenIds[ownedTokenIndex] = currentTokenId;
1820             ownedTokenIndex++;
1821         }
1822         currentTokenId++;
1823         }
1824         return ownedTokenIds;
1825     }
1826 
1827     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1828         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1829         if (revealed == false) {return obscurumuri;}
1830         return bytes(baseUri).length > 0 ? string(abi.encodePacked(baseUri, _tokenId.toString(), extension)) : '';
1831     }
1832 
1833     // SETTERS DONE BY OWNER ONLY
1834 
1835     function setWhitelistPhase(bytes32 _merkleRoot, uint256 _maxperaddress, uint256 _supplyLimit, uint256 _price) external onlyOwner {
1836         require(_supplyLimit<=maxSupply);
1837         setMerkleRoot(_merkleRoot);           
1838         setMaxPerAddress(_maxperaddress);
1839         setPaused(true);
1840         setCost(_price);
1841         phaseTag +=1; // set a new phase on every call
1842         supplyLimit +=_supplyLimit; // set the total supply limit on the whitelist phase
1843     }
1844 
1845     
1846     function setPublicSalePhase(uint256 _maxperaddress, uint256 _price) external onlyOwner {
1847         setMaxPerAddress(_maxperaddress);
1848         setPaused(true);
1849         setCost(_price);
1850         phaseTag+=1;
1851         whitelistMintEnabled= false; 
1852     }
1853     function setSupplyLimit(uint256 _supplyLimit) public onlyOwner nonReentrant{
1854         supplyLimit = _supplyLimit;
1855     }
1856     function setCost(uint256 _cost) public onlyOwner nonReentrant {
1857         cost = _cost;
1858     } 
1859 
1860     function setMaxPerAddress(uint256 _maxperaddress) public onlyOwner nonReentrant {
1861         maxperaddress = _maxperaddress;
1862     }
1863     
1864     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner nonReentrant {
1865         obscurumuri = _hiddenMetadataUri;
1866     }
1867 
1868     function setUri(string memory _uri) public onlyOwner nonReentrant {
1869         baseUri = _uri;
1870     }
1871 
1872     // should be set before any minting starts 
1873     function setPaused(bool choice) public onlyOwner nonReentrant { 
1874         paused = choice;
1875     }
1876     
1877     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner nonReentrant {
1878         merkleRoot = _merkleRoot;
1879     }
1880 
1881     function reveal(bool state ) public onlyOwner nonReentrant{
1882         revealed=state;
1883     }
1884 
1885     function setStartingIndex() public  nonReentrant onlyOwner {
1886             require(startingIndex == 0, "Starting index is already set");
1887             startingIndex = uint256(keccak256(abi.encodePacked(
1888                 block.timestamp + block.difficulty + block.gaslimit + block.number +
1889                 uint256(keccak256(abi.encodePacked(block.coinbase))) / block.timestamp
1890             ))) % maxSupply;
1891     }
1892         // release address based on shares.
1893     function withdrawEth() external onlyOwner nonReentrant {
1894         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1895         require(success, "Transfer failed.");
1896     }
1897 }