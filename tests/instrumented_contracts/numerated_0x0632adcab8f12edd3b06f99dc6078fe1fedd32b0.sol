1 // File: contracts/src/IERC2981Royalties.sol
2 
3 
4 pragma solidity ^0.8.1;
5 
6 /// @title IERC2981Royalties
7 /// @dev Interface for the ERC2981 - Token Royalty standard
8 interface IERC2981Royalties {
9     /// @notice Called with the sale price to determine how much royalty
10     //          is owed and to whom.
11     /// @param _tokenId - the NFT asset queried for royalty information
12     /// @param _value - the sale price of the NFT asset specified by _tokenId
13     /// @return _receiver - address of who should be sent the royalty payment
14     /// @return _royaltyAmount - the royalty payment amount for value sale price
15     function royaltyInfo(uint256 _tokenId, uint256 _value)
16         external
17         view
18         returns (address _receiver, uint256 _royaltyAmount);
19 }
20 
21 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
22 
23 
24 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `to`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address to, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `from` to `to` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address from,
87         address to,
88         uint256 amount
89     ) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev These functions deal with verification of Merkle Trees proofs.
115  *
116  * The proofs can be generated using the JavaScript library
117  * https://github.com/miguelmota/merkletreejs[merkletreejs].
118  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
119  *
120  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
121  */
122 library MerkleProof {
123     /**
124      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
125      * defined by `root`. For this, a `proof` must be provided, containing
126      * sibling hashes on the branch from the leaf to the root of the tree. Each
127      * pair of leaves and each pair of pre-images are assumed to be sorted.
128      */
129     function verify(
130         bytes32[] memory proof,
131         bytes32 root,
132         bytes32 leaf
133     ) internal pure returns (bool) {
134         return processProof(proof, leaf) == root;
135     }
136 
137     /**
138      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
139      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
140      * hash matches the root of the tree. When processing the proof, the pairs
141      * of leafs & pre-images are assumed to be sorted.
142      *
143      * _Available since v4.4._
144      */
145     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
146         bytes32 computedHash = leaf;
147         for (uint256 i = 0; i < proof.length; i++) {
148             bytes32 proofElement = proof[i];
149             if (computedHash <= proofElement) {
150                 // Hash(current computed hash + current element of the proof)
151                 computedHash = _efficientHash(computedHash, proofElement);
152             } else {
153                 // Hash(current element of the proof + current computed hash)
154                 computedHash = _efficientHash(proofElement, computedHash);
155             }
156         }
157         return computedHash;
158     }
159 
160     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
161         assembly {
162             mstore(0x00, a)
163             mstore(0x20, b)
164             value := keccak256(0x00, 0x40)
165         }
166     }
167 }
168 
169 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
170 
171 
172 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @dev Contract module that helps prevent reentrant calls to a function.
178  *
179  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
180  * available, which can be applied to functions to make sure there are no nested
181  * (reentrant) calls to them.
182  *
183  * Note that because there is a single `nonReentrant` guard, functions marked as
184  * `nonReentrant` may not call one another. This can be worked around by making
185  * those functions `private`, and then adding `external` `nonReentrant` entry
186  * points to them.
187  *
188  * TIP: If you would like to learn more about reentrancy and alternative ways
189  * to protect against it, check out our blog post
190  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
191  */
192 abstract contract ReentrancyGuard {
193     // Booleans are more expensive than uint256 or any type that takes up a full
194     // word because each write operation emits an extra SLOAD to first read the
195     // slot's contents, replace the bits taken up by the boolean, and then write
196     // back. This is the compiler's defense against contract upgrades and
197     // pointer aliasing, and it cannot be disabled.
198 
199     // The values being non-zero value makes deployment a bit more expensive,
200     // but in exchange the refund on every call to nonReentrant will be lower in
201     // amount. Since refunds are capped to a percentage of the total
202     // transaction's gas, it is best to keep them low in cases like this one, to
203     // increase the likelihood of the full refund coming into effect.
204     uint256 private constant _NOT_ENTERED = 1;
205     uint256 private constant _ENTERED = 2;
206 
207     uint256 private _status;
208 
209     constructor() {
210         _status = _NOT_ENTERED;
211     }
212 
213     /**
214      * @dev Prevents a contract from calling itself, directly or indirectly.
215      * Calling a `nonReentrant` function from another `nonReentrant`
216      * function is not supported. It is possible to prevent this from happening
217      * by making the `nonReentrant` function external, and making it call a
218      * `private` function that does the actual work.
219      */
220     modifier nonReentrant() {
221         // On the first call to nonReentrant, _notEntered will be true
222         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
223 
224         // Any calls to nonReentrant after this point will fail
225         _status = _ENTERED;
226 
227         _;
228 
229         // By storing the original value once again, a refund is triggered (see
230         // https://eips.ethereum.org/EIPS/eip-2200)
231         _status = _NOT_ENTERED;
232     }
233 }
234 
235 // File: @openzeppelin/contracts/utils/Strings.sol
236 
237 
238 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @dev String operations.
244  */
245 library Strings {
246     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
247 
248     /**
249      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
250      */
251     function toString(uint256 value) internal pure returns (string memory) {
252         // Inspired by OraclizeAPI's implementation - MIT licence
253         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
254 
255         if (value == 0) {
256             return "0";
257         }
258         uint256 temp = value;
259         uint256 digits;
260         while (temp != 0) {
261             digits++;
262             temp /= 10;
263         }
264         bytes memory buffer = new bytes(digits);
265         while (value != 0) {
266             digits -= 1;
267             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
268             value /= 10;
269         }
270         return string(buffer);
271     }
272 
273     /**
274      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
275      */
276     function toHexString(uint256 value) internal pure returns (string memory) {
277         if (value == 0) {
278             return "0x00";
279         }
280         uint256 temp = value;
281         uint256 length = 0;
282         while (temp != 0) {
283             length++;
284             temp >>= 8;
285         }
286         return toHexString(value, length);
287     }
288 
289     /**
290      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
291      */
292     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
293         bytes memory buffer = new bytes(2 * length + 2);
294         buffer[0] = "0";
295         buffer[1] = "x";
296         for (uint256 i = 2 * length + 1; i > 1; --i) {
297             buffer[i] = _HEX_SYMBOLS[value & 0xf];
298             value >>= 4;
299         }
300         require(value == 0, "Strings: hex length insufficient");
301         return string(buffer);
302     }
303 }
304 
305 // File: @openzeppelin/contracts/utils/Context.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @dev Provides information about the current execution context, including the
314  * sender of the transaction and its data. While these are generally available
315  * via msg.sender and msg.data, they should not be accessed in such a direct
316  * manner, since when dealing with meta-transactions the account sending and
317  * paying for execution may not be the actual sender (as far as an application
318  * is concerned).
319  *
320  * This contract is only required for intermediate, library-like contracts.
321  */
322 abstract contract Context {
323     function _msgSender() internal view virtual returns (address) {
324         return msg.sender;
325     }
326 
327     function _msgData() internal view virtual returns (bytes calldata) {
328         return msg.data;
329     }
330 }
331 
332 // File: @openzeppelin/contracts/access/Ownable.sol
333 
334 
335 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 
340 /**
341  * @dev Contract module which provides a basic access control mechanism, where
342  * there is an account (an owner) that can be granted exclusive access to
343  * specific functions.
344  *
345  * By default, the owner account will be the one that deploys the contract. This
346  * can later be changed with {transferOwnership}.
347  *
348  * This module is used through inheritance. It will make available the modifier
349  * `onlyOwner`, which can be applied to your functions to restrict their use to
350  * the owner.
351  */
352 abstract contract Ownable is Context {
353     address private _owner;
354 
355     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
356 
357     /**
358      * @dev Initializes the contract setting the deployer as the initial owner.
359      */
360     constructor() {
361         _transferOwnership(_msgSender());
362     }
363 
364     /**
365      * @dev Returns the address of the current owner.
366      */
367     function owner() public view virtual returns (address) {
368         return _owner;
369     }
370 
371     /**
372      * @dev Throws if called by any account other than the owner.
373      */
374     modifier onlyOwner() {
375         require(owner() == _msgSender(), "Ownable: caller is not the owner");
376         _;
377     }
378 
379     /**
380      * @dev Leaves the contract without owner. It will not be possible to call
381      * `onlyOwner` functions anymore. Can only be called by the current owner.
382      *
383      * NOTE: Renouncing ownership will leave the contract without an owner,
384      * thereby removing any functionality that is only available to the owner.
385      */
386     function renounceOwnership() public virtual onlyOwner {
387         _transferOwnership(address(0));
388     }
389 
390     /**
391      * @dev Transfers ownership of the contract to a new account (`newOwner`).
392      * Can only be called by the current owner.
393      */
394     function transferOwnership(address newOwner) public virtual onlyOwner {
395         require(newOwner != address(0), "Ownable: new owner is the zero address");
396         _transferOwnership(newOwner);
397     }
398 
399     /**
400      * @dev Transfers ownership of the contract to a new account (`newOwner`).
401      * Internal function without access restriction.
402      */
403     function _transferOwnership(address newOwner) internal virtual {
404         address oldOwner = _owner;
405         _owner = newOwner;
406         emit OwnershipTransferred(oldOwner, newOwner);
407     }
408 }
409 
410 // File: @openzeppelin/contracts/utils/Address.sol
411 
412 
413 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
414 
415 pragma solidity ^0.8.1;
416 
417 /**
418  * @dev Collection of functions related to the address type
419  */
420 library Address {
421     /**
422      * @dev Returns true if `account` is a contract.
423      *
424      * [IMPORTANT]
425      * ====
426      * It is unsafe to assume that an address for which this function returns
427      * false is an externally-owned account (EOA) and not a contract.
428      *
429      * Among others, `isContract` will return false for the following
430      * types of addresses:
431      *
432      *  - an externally-owned account
433      *  - a contract in construction
434      *  - an address where a contract will be created
435      *  - an address where a contract lived, but was destroyed
436      * ====
437      *
438      * [IMPORTANT]
439      * ====
440      * You shouldn't rely on `isContract` to protect against flash loan attacks!
441      *
442      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
443      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
444      * constructor.
445      * ====
446      */
447     function isContract(address account) internal view returns (bool) {
448         // This method relies on extcodesize/address.code.length, which returns 0
449         // for contracts in construction, since the code is only stored at the end
450         // of the constructor execution.
451 
452         return account.code.length > 0;
453     }
454 
455     /**
456      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
457      * `recipient`, forwarding all available gas and reverting on errors.
458      *
459      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
460      * of certain opcodes, possibly making contracts go over the 2300 gas limit
461      * imposed by `transfer`, making them unable to receive funds via
462      * `transfer`. {sendValue} removes this limitation.
463      *
464      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
465      *
466      * IMPORTANT: because control is transferred to `recipient`, care must be
467      * taken to not create reentrancy vulnerabilities. Consider using
468      * {ReentrancyGuard} or the
469      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
470      */
471     function sendValue(address payable recipient, uint256 amount) internal {
472         require(address(this).balance >= amount, "Address: insufficient balance");
473 
474         (bool success, ) = recipient.call{value: amount}("");
475         require(success, "Address: unable to send value, recipient may have reverted");
476     }
477 
478     /**
479      * @dev Performs a Solidity function call using a low level `call`. A
480      * plain `call` is an unsafe replacement for a function call: use this
481      * function instead.
482      *
483      * If `target` reverts with a revert reason, it is bubbled up by this
484      * function (like regular Solidity function calls).
485      *
486      * Returns the raw returned data. To convert to the expected return value,
487      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
488      *
489      * Requirements:
490      *
491      * - `target` must be a contract.
492      * - calling `target` with `data` must not revert.
493      *
494      * _Available since v3.1._
495      */
496     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
497         return functionCall(target, data, "Address: low-level call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
502      * `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         return functionCallWithValue(target, data, 0, errorMessage);
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
516      * but also transferring `value` wei to `target`.
517      *
518      * Requirements:
519      *
520      * - the calling contract must have an ETH balance of at least `value`.
521      * - the called Solidity function must be `payable`.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(
526         address target,
527         bytes memory data,
528         uint256 value
529     ) internal returns (bytes memory) {
530         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
535      * with `errorMessage` as a fallback revert reason when `target` reverts.
536      *
537      * _Available since v3.1._
538      */
539     function functionCallWithValue(
540         address target,
541         bytes memory data,
542         uint256 value,
543         string memory errorMessage
544     ) internal returns (bytes memory) {
545         require(address(this).balance >= value, "Address: insufficient balance for call");
546         require(isContract(target), "Address: call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.call{value: value}(data);
549         return verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but performing a static call.
555      *
556      * _Available since v3.3._
557      */
558     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
559         return functionStaticCall(target, data, "Address: low-level static call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
564      * but performing a static call.
565      *
566      * _Available since v3.3._
567      */
568     function functionStaticCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal view returns (bytes memory) {
573         require(isContract(target), "Address: static call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.staticcall(data);
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
581      * but performing a delegate call.
582      *
583      * _Available since v3.4._
584      */
585     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
586         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
591      * but performing a delegate call.
592      *
593      * _Available since v3.4._
594      */
595     function functionDelegateCall(
596         address target,
597         bytes memory data,
598         string memory errorMessage
599     ) internal returns (bytes memory) {
600         require(isContract(target), "Address: delegate call to non-contract");
601 
602         (bool success, bytes memory returndata) = target.delegatecall(data);
603         return verifyCallResult(success, returndata, errorMessage);
604     }
605 
606     /**
607      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
608      * revert reason using the provided one.
609      *
610      * _Available since v4.3._
611      */
612     function verifyCallResult(
613         bool success,
614         bytes memory returndata,
615         string memory errorMessage
616     ) internal pure returns (bytes memory) {
617         if (success) {
618             return returndata;
619         } else {
620             // Look for revert reason and bubble it up if present
621             if (returndata.length > 0) {
622                 // The easiest way to bubble the revert reason is using memory via assembly
623 
624                 assembly {
625                     let returndata_size := mload(returndata)
626                     revert(add(32, returndata), returndata_size)
627                 }
628             } else {
629                 revert(errorMessage);
630             }
631         }
632     }
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 
644 /**
645  * @title SafeERC20
646  * @dev Wrappers around ERC20 operations that throw on failure (when the token
647  * contract returns false). Tokens that return no value (and instead revert or
648  * throw on failure) are also supported, non-reverting calls are assumed to be
649  * successful.
650  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
651  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
652  */
653 library SafeERC20 {
654     using Address for address;
655 
656     function safeTransfer(
657         IERC20 token,
658         address to,
659         uint256 value
660     ) internal {
661         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
662     }
663 
664     function safeTransferFrom(
665         IERC20 token,
666         address from,
667         address to,
668         uint256 value
669     ) internal {
670         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
671     }
672 
673     /**
674      * @dev Deprecated. This function has issues similar to the ones found in
675      * {IERC20-approve}, and its usage is discouraged.
676      *
677      * Whenever possible, use {safeIncreaseAllowance} and
678      * {safeDecreaseAllowance} instead.
679      */
680     function safeApprove(
681         IERC20 token,
682         address spender,
683         uint256 value
684     ) internal {
685         // safeApprove should only be called when setting an initial allowance,
686         // or when resetting it to zero. To increase and decrease it, use
687         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
688         require(
689             (value == 0) || (token.allowance(address(this), spender) == 0),
690             "SafeERC20: approve from non-zero to non-zero allowance"
691         );
692         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
693     }
694 
695     function safeIncreaseAllowance(
696         IERC20 token,
697         address spender,
698         uint256 value
699     ) internal {
700         uint256 newAllowance = token.allowance(address(this), spender) + value;
701         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
702     }
703 
704     function safeDecreaseAllowance(
705         IERC20 token,
706         address spender,
707         uint256 value
708     ) internal {
709         unchecked {
710             uint256 oldAllowance = token.allowance(address(this), spender);
711             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
712             uint256 newAllowance = oldAllowance - value;
713             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
714         }
715     }
716 
717     /**
718      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
719      * on the return value: the return value is optional (but if data is returned, it must not be false).
720      * @param token The token targeted by the call.
721      * @param data The call data (encoded using abi.encode or one of its variants).
722      */
723     function _callOptionalReturn(IERC20 token, bytes memory data) private {
724         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
725         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
726         // the target address contains contract code and also asserts for success in the low-level call.
727 
728         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
729         if (returndata.length > 0) {
730             // Return data is optional
731             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
732         }
733     }
734 }
735 
736 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
737 
738 
739 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 /**
744  * @title ERC721 token receiver interface
745  * @dev Interface for any contract that wants to support safeTransfers
746  * from ERC721 asset contracts.
747  */
748 interface IERC721Receiver {
749     /**
750      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
751      * by `operator` from `from`, this function is called.
752      *
753      * It must return its Solidity selector to confirm the token transfer.
754      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
755      *
756      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
757      */
758     function onERC721Received(
759         address operator,
760         address from,
761         uint256 tokenId,
762         bytes calldata data
763     ) external returns (bytes4);
764 }
765 
766 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
767 
768 
769 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 /**
774  * @dev Interface of the ERC165 standard, as defined in the
775  * https://eips.ethereum.org/EIPS/eip-165[EIP].
776  *
777  * Implementers can declare support of contract interfaces, which can then be
778  * queried by others ({ERC165Checker}).
779  *
780  * For an implementation, see {ERC165}.
781  */
782 interface IERC165 {
783     /**
784      * @dev Returns true if this contract implements the interface defined by
785      * `interfaceId`. See the corresponding
786      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
787      * to learn more about how these ids are created.
788      *
789      * This function call must use less than 30 000 gas.
790      */
791     function supportsInterface(bytes4 interfaceId) external view returns (bool);
792 }
793 
794 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
795 
796 
797 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
798 
799 pragma solidity ^0.8.0;
800 
801 
802 /**
803  * @dev Implementation of the {IERC165} interface.
804  *
805  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
806  * for the additional interface id that will be supported. For example:
807  *
808  * ```solidity
809  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
810  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
811  * }
812  * ```
813  *
814  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
815  */
816 abstract contract ERC165 is IERC165 {
817     /**
818      * @dev See {IERC165-supportsInterface}.
819      */
820     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
821         return interfaceId == type(IERC165).interfaceId;
822     }
823 }
824 
825 // File: contracts/src/ERC2981Base.sol
826 
827 
828 pragma solidity ^0.8.1;
829 
830 
831 
832 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
833 abstract contract ERC2981Base is ERC165, IERC2981Royalties {
834     struct RoyaltyInfo {
835         address recipient;
836         uint24 amount;
837     }
838 
839     /// @inheritdoc	ERC165
840     function supportsInterface(bytes4 interfaceId)
841         public
842         view
843         virtual
844         override
845         returns (bool)
846     {
847         return
848             interfaceId == type(IERC2981Royalties).interfaceId ||
849             super.supportsInterface(interfaceId);
850     }
851 }
852 
853 // File: contracts/src/ERC2981ContractWideRoyalties.sol
854 
855 
856 pragma solidity ^0.8.1;
857 
858 
859 
860 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
861 /// @dev This implementation has the same royalties for each and every tokens
862 abstract contract ERC2981ContractWideRoyalties is ERC2981Base {
863     RoyaltyInfo private _royalties;
864 
865     /// @dev Sets token royalties
866     /// @param recipient recipient of the royalties
867     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
868     function _setRoyalties(address recipient, uint256 value) internal {
869         require(value <= 10000, "ERC2981Royalties: Too high");
870         _royalties = RoyaltyInfo(recipient, uint24(value));
871     }
872 
873     /// @inheritdoc	IERC2981Royalties
874     function royaltyInfo(uint256, uint256 value)
875         external
876         view
877         override
878         returns (address receiver, uint256 royaltyAmount)
879     {
880         RoyaltyInfo memory royalties = _royalties;
881         receiver = royalties.recipient;
882         royaltyAmount = (value * royalties.amount) / 10000;
883     }
884 }
885 
886 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
887 
888 
889 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
890 
891 pragma solidity ^0.8.0;
892 
893 
894 /**
895  * @dev Required interface of an ERC721 compliant contract.
896  */
897 interface IERC721 is IERC165 {
898     /**
899      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
900      */
901     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
902 
903     /**
904      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
905      */
906     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
907 
908     /**
909      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
910      */
911     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
912 
913     /**
914      * @dev Returns the number of tokens in ``owner``'s account.
915      */
916     function balanceOf(address owner) external view returns (uint256 balance);
917 
918     /**
919      * @dev Returns the owner of the `tokenId` token.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must exist.
924      */
925     function ownerOf(uint256 tokenId) external view returns (address owner);
926 
927     /**
928      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
929      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
930      *
931      * Requirements:
932      *
933      * - `from` cannot be the zero address.
934      * - `to` cannot be the zero address.
935      * - `tokenId` token must exist and be owned by `from`.
936      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
937      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
938      *
939      * Emits a {Transfer} event.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) external;
946 
947     /**
948      * @dev Transfers `tokenId` token from `from` to `to`.
949      *
950      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
951      *
952      * Requirements:
953      *
954      * - `from` cannot be the zero address.
955      * - `to` cannot be the zero address.
956      * - `tokenId` token must be owned by `from`.
957      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
958      *
959      * Emits a {Transfer} event.
960      */
961     function transferFrom(
962         address from,
963         address to,
964         uint256 tokenId
965     ) external;
966 
967     /**
968      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
969      * The approval is cleared when the token is transferred.
970      *
971      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
972      *
973      * Requirements:
974      *
975      * - The caller must own the token or be an approved operator.
976      * - `tokenId` must exist.
977      *
978      * Emits an {Approval} event.
979      */
980     function approve(address to, uint256 tokenId) external;
981 
982     /**
983      * @dev Returns the account approved for `tokenId` token.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      */
989     function getApproved(uint256 tokenId) external view returns (address operator);
990 
991     /**
992      * @dev Approve or remove `operator` as an operator for the caller.
993      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
994      *
995      * Requirements:
996      *
997      * - The `operator` cannot be the caller.
998      *
999      * Emits an {ApprovalForAll} event.
1000      */
1001     function setApprovalForAll(address operator, bool _approved) external;
1002 
1003     /**
1004      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1005      *
1006      * See {setApprovalForAll}
1007      */
1008     function isApprovedForAll(address owner, address operator) external view returns (bool);
1009 
1010     /**
1011      * @dev Safely transfers `tokenId` token from `from` to `to`.
1012      *
1013      * Requirements:
1014      *
1015      * - `from` cannot be the zero address.
1016      * - `to` cannot be the zero address.
1017      * - `tokenId` token must exist and be owned by `from`.
1018      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1019      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId,
1027         bytes calldata data
1028     ) external;
1029 }
1030 
1031 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1032 
1033 
1034 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1035 
1036 pragma solidity ^0.8.0;
1037 
1038 
1039 /**
1040  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1041  * @dev See https://eips.ethereum.org/EIPS/eip-721
1042  */
1043 interface IERC721Metadata is IERC721 {
1044     /**
1045      * @dev Returns the token collection name.
1046      */
1047     function name() external view returns (string memory);
1048 
1049     /**
1050      * @dev Returns the token collection symbol.
1051      */
1052     function symbol() external view returns (string memory);
1053 
1054     /**
1055      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1056      */
1057     function tokenURI(uint256 tokenId) external view returns (string memory);
1058 }
1059 
1060 // File: erc721a/contracts/ERC721A.sol
1061 
1062 
1063 // Creator: Chiru Labs
1064 
1065 pragma solidity ^0.8.4;
1066 
1067 
1068 
1069 
1070 
1071 
1072 
1073 
1074 error ApprovalCallerNotOwnerNorApproved();
1075 error ApprovalQueryForNonexistentToken();
1076 error ApproveToCaller();
1077 error ApprovalToCurrentOwner();
1078 error BalanceQueryForZeroAddress();
1079 error MintToZeroAddress();
1080 error MintZeroQuantity();
1081 error OwnerQueryForNonexistentToken();
1082 error TransferCallerNotOwnerNorApproved();
1083 error TransferFromIncorrectOwner();
1084 error TransferToNonERC721ReceiverImplementer();
1085 error TransferToZeroAddress();
1086 error URIQueryForNonexistentToken();
1087 
1088 /**
1089  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1090  * the Metadata extension. Built to optimize for lower gas during batch mints.
1091  *
1092  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1093  *
1094  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1095  *
1096  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1097  */
1098 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1099     using Address for address;
1100     using Strings for uint256;
1101 
1102     // Compiler will pack this into a single 256bit word.
1103     struct TokenOwnership {
1104         // The address of the owner.
1105         address addr;
1106         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1107         uint64 startTimestamp;
1108         // Whether the token has been burned.
1109         bool burned;
1110     }
1111 
1112     // Compiler will pack this into a single 256bit word.
1113     struct AddressData {
1114         // Realistically, 2**64-1 is more than enough.
1115         uint64 balance;
1116         // Keeps track of mint count with minimal overhead for tokenomics.
1117         uint64 numberMinted;
1118         // Keeps track of burn count with minimal overhead for tokenomics.
1119         uint64 numberBurned;
1120         // For miscellaneous variable(s) pertaining to the address
1121         // (e.g. number of whitelist mint slots used).
1122         // If there are multiple variables, please pack them into a uint64.
1123         uint64 aux;
1124     }
1125 
1126     // The tokenId of the next token to be minted.
1127     uint256 internal _currentIndex;
1128 
1129     // The number of tokens burned.
1130     uint256 internal _burnCounter;
1131 
1132     // Token name
1133     string private _name;
1134 
1135     // Token symbol
1136     string private _symbol;
1137 
1138     // Mapping from token ID to ownership details
1139     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1140     mapping(uint256 => TokenOwnership) internal _ownerships;
1141 
1142     // Mapping owner address to address data
1143     mapping(address => AddressData) private _addressData;
1144 
1145     // Mapping from token ID to approved address
1146     mapping(uint256 => address) private _tokenApprovals;
1147 
1148     // Mapping from owner to operator approvals
1149     mapping(address => mapping(address => bool)) private _operatorApprovals;
1150 
1151     constructor(string memory name_, string memory symbol_) {
1152         _name = name_;
1153         _symbol = symbol_;
1154         _currentIndex = _startTokenId();
1155     }
1156 
1157     /**
1158      * To change the starting tokenId, please override this function.
1159      */
1160     function _startTokenId() internal view virtual returns (uint256) {
1161         return 0;
1162     }
1163 
1164     /**
1165      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1166      */
1167     function totalSupply() public view returns (uint256) {
1168         // Counter underflow is impossible as _burnCounter cannot be incremented
1169         // more than _currentIndex - _startTokenId() times
1170         unchecked {
1171             return _currentIndex - _burnCounter - _startTokenId();
1172         }
1173     }
1174 
1175     /**
1176      * Returns the total amount of tokens minted in the contract.
1177      */
1178     function _totalMinted() internal view returns (uint256) {
1179         // Counter underflow is impossible as _currentIndex does not decrement,
1180         // and it is initialized to _startTokenId()
1181         unchecked {
1182             return _currentIndex - _startTokenId();
1183         }
1184     }
1185 
1186     /**
1187      * @dev See {IERC165-supportsInterface}.
1188      */
1189     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1190         return
1191             interfaceId == type(IERC721).interfaceId ||
1192             interfaceId == type(IERC721Metadata).interfaceId ||
1193             super.supportsInterface(interfaceId);
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-balanceOf}.
1198      */
1199     function balanceOf(address owner) public view override returns (uint256) {
1200         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1201         return uint256(_addressData[owner].balance);
1202     }
1203 
1204     /**
1205      * Returns the number of tokens minted by `owner`.
1206      */
1207     function _numberMinted(address owner) internal view returns (uint256) {
1208         return uint256(_addressData[owner].numberMinted);
1209     }
1210 
1211     /**
1212      * Returns the number of tokens burned by or on behalf of `owner`.
1213      */
1214     function _numberBurned(address owner) internal view returns (uint256) {
1215         return uint256(_addressData[owner].numberBurned);
1216     }
1217 
1218     /**
1219      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1220      */
1221     function _getAux(address owner) internal view returns (uint64) {
1222         return _addressData[owner].aux;
1223     }
1224 
1225     /**
1226      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1227      * If there are multiple variables, please pack them into a uint64.
1228      */
1229     function _setAux(address owner, uint64 aux) internal {
1230         _addressData[owner].aux = aux;
1231     }
1232 
1233     /**
1234      * Gas spent here starts off proportional to the maximum mint batch size.
1235      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1236      */
1237     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1238         uint256 curr = tokenId;
1239 
1240         unchecked {
1241             if (_startTokenId() <= curr && curr < _currentIndex) {
1242                 TokenOwnership memory ownership = _ownerships[curr];
1243                 if (!ownership.burned) {
1244                     if (ownership.addr != address(0)) {
1245                         return ownership;
1246                     }
1247                     // Invariant:
1248                     // There will always be an ownership that has an address and is not burned
1249                     // before an ownership that does not have an address and is not burned.
1250                     // Hence, curr will not underflow.
1251                     while (true) {
1252                         curr--;
1253                         ownership = _ownerships[curr];
1254                         if (ownership.addr != address(0)) {
1255                             return ownership;
1256                         }
1257                     }
1258                 }
1259             }
1260         }
1261         revert OwnerQueryForNonexistentToken();
1262     }
1263 
1264     /**
1265      * @dev See {IERC721-ownerOf}.
1266      */
1267     function ownerOf(uint256 tokenId) public view override returns (address) {
1268         return _ownershipOf(tokenId).addr;
1269     }
1270 
1271     /**
1272      * @dev See {IERC721Metadata-name}.
1273      */
1274     function name() public view virtual override returns (string memory) {
1275         return _name;
1276     }
1277 
1278     /**
1279      * @dev See {IERC721Metadata-symbol}.
1280      */
1281     function symbol() public view virtual override returns (string memory) {
1282         return _symbol;
1283     }
1284 
1285     /**
1286      * @dev See {IERC721Metadata-tokenURI}.
1287      */
1288     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1289         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1290 
1291         string memory baseURI = _baseURI();
1292         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1293     }
1294 
1295     /**
1296      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1297      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1298      * by default, can be overriden in child contracts.
1299      */
1300     function _baseURI() internal view virtual returns (string memory) {
1301         return '';
1302     }
1303 
1304     /**
1305      * @dev See {IERC721-approve}.
1306      */
1307     function approve(address to, uint256 tokenId) public override {
1308         address owner = ERC721A.ownerOf(tokenId);
1309         if (to == owner) revert ApprovalToCurrentOwner();
1310 
1311         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1312             revert ApprovalCallerNotOwnerNorApproved();
1313         }
1314 
1315         _approve(to, tokenId, owner);
1316     }
1317 
1318     /**
1319      * @dev See {IERC721-getApproved}.
1320      */
1321     function getApproved(uint256 tokenId) public view override returns (address) {
1322         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1323 
1324         return _tokenApprovals[tokenId];
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-setApprovalForAll}.
1329      */
1330     function setApprovalForAll(address operator, bool approved) public virtual override {
1331         if (operator == _msgSender()) revert ApproveToCaller();
1332 
1333         _operatorApprovals[_msgSender()][operator] = approved;
1334         emit ApprovalForAll(_msgSender(), operator, approved);
1335     }
1336 
1337     /**
1338      * @dev See {IERC721-isApprovedForAll}.
1339      */
1340     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1341         return _operatorApprovals[owner][operator];
1342     }
1343 
1344     /**
1345      * @dev See {IERC721-transferFrom}.
1346      */
1347     function transferFrom(
1348         address from,
1349         address to,
1350         uint256 tokenId
1351     ) public virtual override {
1352         _transfer(from, to, tokenId);
1353     }
1354 
1355     /**
1356      * @dev See {IERC721-safeTransferFrom}.
1357      */
1358     function safeTransferFrom(
1359         address from,
1360         address to,
1361         uint256 tokenId
1362     ) public virtual override {
1363         safeTransferFrom(from, to, tokenId, '');
1364     }
1365 
1366     /**
1367      * @dev See {IERC721-safeTransferFrom}.
1368      */
1369     function safeTransferFrom(
1370         address from,
1371         address to,
1372         uint256 tokenId,
1373         bytes memory _data
1374     ) public virtual override {
1375         _transfer(from, to, tokenId);
1376         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1377             revert TransferToNonERC721ReceiverImplementer();
1378         }
1379     }
1380 
1381     /**
1382      * @dev Returns whether `tokenId` exists.
1383      *
1384      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1385      *
1386      * Tokens start existing when they are minted (`_mint`),
1387      */
1388     function _exists(uint256 tokenId) internal view returns (bool) {
1389         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1390     }
1391 
1392     function _safeMint(address to, uint256 quantity) internal {
1393         _safeMint(to, quantity, '');
1394     }
1395 
1396     /**
1397      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1398      *
1399      * Requirements:
1400      *
1401      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1402      * - `quantity` must be greater than 0.
1403      *
1404      * Emits a {Transfer} event.
1405      */
1406     function _safeMint(
1407         address to,
1408         uint256 quantity,
1409         bytes memory _data
1410     ) internal {
1411         _mint(to, quantity, _data, true);
1412     }
1413 
1414     /**
1415      * @dev Mints `quantity` tokens and transfers them to `to`.
1416      *
1417      * Requirements:
1418      *
1419      * - `to` cannot be the zero address.
1420      * - `quantity` must be greater than 0.
1421      *
1422      * Emits a {Transfer} event.
1423      */
1424     function _mint(
1425         address to,
1426         uint256 quantity,
1427         bytes memory _data,
1428         bool safe
1429     ) internal {
1430         uint256 startTokenId = _currentIndex;
1431         if (to == address(0)) revert MintToZeroAddress();
1432         if (quantity == 0) revert MintZeroQuantity();
1433 
1434         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1435 
1436         // Overflows are incredibly unrealistic.
1437         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1438         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1439         unchecked {
1440             _addressData[to].balance += uint64(quantity);
1441             _addressData[to].numberMinted += uint64(quantity);
1442 
1443             _ownerships[startTokenId].addr = to;
1444             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1445 
1446             uint256 updatedIndex = startTokenId;
1447             uint256 end = updatedIndex + quantity;
1448 
1449             if (safe && to.isContract()) {
1450                 do {
1451                     emit Transfer(address(0), to, updatedIndex);
1452                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1453                         revert TransferToNonERC721ReceiverImplementer();
1454                     }
1455                 } while (updatedIndex != end);
1456                 // Reentrancy protection
1457                 if (_currentIndex != startTokenId) revert();
1458             } else {
1459                 do {
1460                     emit Transfer(address(0), to, updatedIndex++);
1461                 } while (updatedIndex != end);
1462             }
1463             _currentIndex = updatedIndex;
1464         }
1465         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1466     }
1467 
1468     /**
1469      * @dev Transfers `tokenId` from `from` to `to`.
1470      *
1471      * Requirements:
1472      *
1473      * - `to` cannot be the zero address.
1474      * - `tokenId` token must be owned by `from`.
1475      *
1476      * Emits a {Transfer} event.
1477      */
1478     function _transfer(
1479         address from,
1480         address to,
1481         uint256 tokenId
1482     ) private {
1483         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1484 
1485         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1486 
1487         bool isApprovedOrOwner = (_msgSender() == from ||
1488             isApprovedForAll(from, _msgSender()) ||
1489             getApproved(tokenId) == _msgSender());
1490 
1491         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1492         if (to == address(0)) revert TransferToZeroAddress();
1493 
1494         _beforeTokenTransfers(from, to, tokenId, 1);
1495 
1496         // Clear approvals from the previous owner
1497         _approve(address(0), tokenId, from);
1498 
1499         // Underflow of the sender's balance is impossible because we check for
1500         // ownership above and the recipient's balance can't realistically overflow.
1501         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1502         unchecked {
1503             _addressData[from].balance -= 1;
1504             _addressData[to].balance += 1;
1505 
1506             TokenOwnership storage currSlot = _ownerships[tokenId];
1507             currSlot.addr = to;
1508             currSlot.startTimestamp = uint64(block.timestamp);
1509 
1510             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1511             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1512             uint256 nextTokenId = tokenId + 1;
1513             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1514             if (nextSlot.addr == address(0)) {
1515                 // This will suffice for checking _exists(nextTokenId),
1516                 // as a burned slot cannot contain the zero address.
1517                 if (nextTokenId != _currentIndex) {
1518                     nextSlot.addr = from;
1519                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1520                 }
1521             }
1522         }
1523 
1524         emit Transfer(from, to, tokenId);
1525         _afterTokenTransfers(from, to, tokenId, 1);
1526     }
1527 
1528     /**
1529      * @dev This is equivalent to _burn(tokenId, false)
1530      */
1531     function _burn(uint256 tokenId) internal virtual {
1532         _burn(tokenId, false);
1533     }
1534 
1535     /**
1536      * @dev Destroys `tokenId`.
1537      * The approval is cleared when the token is burned.
1538      *
1539      * Requirements:
1540      *
1541      * - `tokenId` must exist.
1542      *
1543      * Emits a {Transfer} event.
1544      */
1545     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1546         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1547 
1548         address from = prevOwnership.addr;
1549 
1550         if (approvalCheck) {
1551             bool isApprovedOrOwner = (_msgSender() == from ||
1552                 isApprovedForAll(from, _msgSender()) ||
1553                 getApproved(tokenId) == _msgSender());
1554 
1555             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1556         }
1557 
1558         _beforeTokenTransfers(from, address(0), tokenId, 1);
1559 
1560         // Clear approvals from the previous owner
1561         _approve(address(0), tokenId, from);
1562 
1563         // Underflow of the sender's balance is impossible because we check for
1564         // ownership above and the recipient's balance can't realistically overflow.
1565         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1566         unchecked {
1567             AddressData storage addressData = _addressData[from];
1568             addressData.balance -= 1;
1569             addressData.numberBurned += 1;
1570 
1571             // Keep track of who burned the token, and the timestamp of burning.
1572             TokenOwnership storage currSlot = _ownerships[tokenId];
1573             currSlot.addr = from;
1574             currSlot.startTimestamp = uint64(block.timestamp);
1575             currSlot.burned = true;
1576 
1577             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1578             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1579             uint256 nextTokenId = tokenId + 1;
1580             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1581             if (nextSlot.addr == address(0)) {
1582                 // This will suffice for checking _exists(nextTokenId),
1583                 // as a burned slot cannot contain the zero address.
1584                 if (nextTokenId != _currentIndex) {
1585                     nextSlot.addr = from;
1586                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1587                 }
1588             }
1589         }
1590 
1591         emit Transfer(from, address(0), tokenId);
1592         _afterTokenTransfers(from, address(0), tokenId, 1);
1593 
1594         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1595         unchecked {
1596             _burnCounter++;
1597         }
1598     }
1599 
1600     /**
1601      * @dev Approve `to` to operate on `tokenId`
1602      *
1603      * Emits a {Approval} event.
1604      */
1605     function _approve(
1606         address to,
1607         uint256 tokenId,
1608         address owner
1609     ) private {
1610         _tokenApprovals[tokenId] = to;
1611         emit Approval(owner, to, tokenId);
1612     }
1613 
1614     /**
1615      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1616      *
1617      * @param from address representing the previous owner of the given token ID
1618      * @param to target address that will receive the tokens
1619      * @param tokenId uint256 ID of the token to be transferred
1620      * @param _data bytes optional data to send along with the call
1621      * @return bool whether the call correctly returned the expected magic value
1622      */
1623     function _checkContractOnERC721Received(
1624         address from,
1625         address to,
1626         uint256 tokenId,
1627         bytes memory _data
1628     ) private returns (bool) {
1629         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1630             return retval == IERC721Receiver(to).onERC721Received.selector;
1631         } catch (bytes memory reason) {
1632             if (reason.length == 0) {
1633                 revert TransferToNonERC721ReceiverImplementer();
1634             } else {
1635                 assembly {
1636                     revert(add(32, reason), mload(reason))
1637                 }
1638             }
1639         }
1640     }
1641 
1642     /**
1643      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1644      * And also called before burning one token.
1645      *
1646      * startTokenId - the first token id to be transferred
1647      * quantity - the amount to be transferred
1648      *
1649      * Calling conditions:
1650      *
1651      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1652      * transferred to `to`.
1653      * - When `from` is zero, `tokenId` will be minted for `to`.
1654      * - When `to` is zero, `tokenId` will be burned by `from`.
1655      * - `from` and `to` are never both zero.
1656      */
1657     function _beforeTokenTransfers(
1658         address from,
1659         address to,
1660         uint256 startTokenId,
1661         uint256 quantity
1662     ) internal virtual {}
1663 
1664     /**
1665      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1666      * minting.
1667      * And also called after one token has been burned.
1668      *
1669      * startTokenId - the first token id to be transferred
1670      * quantity - the amount to be transferred
1671      *
1672      * Calling conditions:
1673      *
1674      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1675      * transferred to `to`.
1676      * - When `from` is zero, `tokenId` has been minted for `to`.
1677      * - When `to` is zero, `tokenId` has been burned by `from`.
1678      * - `from` and `to` are never both zero.
1679      */
1680     function _afterTokenTransfers(
1681         address from,
1682         address to,
1683         uint256 startTokenId,
1684         uint256 quantity
1685     ) internal virtual {}
1686 }
1687 
1688 // File: contracts/src/Surge.sol
1689 
1690 
1691 pragma solidity ^0.8.1;
1692 
1693 // @title: Surge Women NFT Collection
1694 // @website: https://www.surgewomen.io/
1695 
1696 // █▀ █░█ █▀█ █▀▀ █▀▀   █░█░█ █▀█ █▀▄▀█ █▀▀ █▄░█
1697 // ▄█ █▄█ █▀▄ █▄█ ██▄   ▀▄▀▄▀ █▄█ █░▀░█ ██▄ █░▀█
1698 
1699 
1700 
1701 
1702 
1703 
1704 
1705 contract Surge is ERC721A, ReentrancyGuard, Ownable, ERC2981ContractWideRoyalties {
1706     using Strings for uint256;
1707 
1708     // Status of the token sale
1709     enum SaleStatus {
1710         Paused,
1711         Presale,
1712         PublicSale,
1713         SoldOut
1714     }
1715 
1716     event StatusUpdate(SaleStatus _status);
1717 
1718     SaleStatus public status = SaleStatus.Paused;
1719     bytes32 public merkleRoot;
1720     string public baseTokenURI;
1721 
1722     uint64 public constant MAX_SUPPLY = 5000;
1723     uint64 public constant MAX_PER_USER = 5;
1724     uint128 public price;
1725 
1726     /**
1727      * @dev Sale is paused by default upon deploy
1728      */
1729     constructor(
1730         string memory _name,
1731         string memory _symbol,
1732         string memory _baseTokenURI,
1733         uint128 _price,
1734         address _receiver,
1735         uint256 _royalties
1736     ) payable ERC721A(_name, _symbol) {
1737         setBaseURI(_baseTokenURI);
1738         setPrice(_price);
1739         setRoyalties(_receiver, _royalties);
1740     }
1741 
1742     mapping(address => uint) private _mintedAmount;
1743 
1744     /*----------------------------------------------*/
1745     /*                  MODIFIERS                  */
1746     /*--------------------------------------------*/
1747 
1748     /// @notice Verifies the amount of tokens the address has minted does not exceed MAX_PER_USER
1749     /// @param to Address to check the amount of tokens minted
1750     /// @param _amountOfTokens Amount of tokens to be minted
1751     modifier verifyMaxPerUser(address to, uint256 _amountOfTokens) {
1752         require(_mintedAmount[to] + _amountOfTokens <= MAX_PER_USER, "Max amount minted");
1753         _;
1754     }
1755 
1756     /// @notice Verifies total amount of minted tokens does not exceed MAX_SUPPLY
1757     /// @param _amountOfTokens Amount of tokens to be minted
1758     modifier verifyMaxSupply(uint256 _amountOfTokens) {
1759         require(_amountOfTokens + _totalMinted() <= MAX_SUPPLY, "Collection sold out");
1760         _;
1761     }
1762 
1763     /// @notice Verifies the address minting has enough ETH in their wallet to mint
1764     /// @param _amountOfTokens Amount of tokens to be minted
1765     modifier isEnoughEth(uint256 _amountOfTokens) {
1766         require(msg.value == _amountOfTokens * price, "Not enough ETH");
1767         _;
1768     }
1769 
1770     /*----------------------------------------------*/
1771     /*               MINT FUNCTIONS                */
1772     /*--------------------------------------------*/
1773 
1774     /// @notice Public sale minting
1775     /// @param to Address that will recieve minted token
1776     /// @param _amountOfTokens Amount of tokens to mint
1777     function mint(address to, uint256 _amountOfTokens)
1778         external
1779         payable
1780         verifyMaxPerUser(to, _amountOfTokens)
1781         verifyMaxSupply(_amountOfTokens)
1782         isEnoughEth(_amountOfTokens)
1783     {
1784         require(status == SaleStatus.PublicSale, "Sale not active");
1785 
1786         _mintedAmount[to] += _amountOfTokens;
1787         _safeMint(to, _amountOfTokens);
1788     }
1789 
1790     /// @notice Presale minting verifies callers address is in Merkle Root
1791     /// @param _amountOfTokens Amount of tokens to mint
1792     /// @param _merkleProof Hash of the callers address used to verify the location of that address in the Merkle Root
1793     function presaleMint(uint256 _amountOfTokens, bytes32[] calldata _merkleProof)
1794         external
1795         payable
1796         verifyMaxPerUser(msg.sender, _amountOfTokens)
1797         verifyMaxSupply(_amountOfTokens)
1798         isEnoughEth(_amountOfTokens)
1799     {
1800         require(status == SaleStatus.Presale, "Presale not active");
1801 
1802         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1803         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not in presale list");
1804 
1805         _mintedAmount[msg.sender] += _amountOfTokens;
1806         _safeMint(msg.sender, _amountOfTokens);
1807     }
1808 
1809     /// @notice Allows the owner to mint for the organizations treasury
1810     /// @param _amountOfTokens Amount of tokens to mint
1811     function batchMinting(uint256 _amountOfTokens)
1812         external
1813         payable
1814         nonReentrant
1815         onlyOwner
1816         verifyMaxSupply(_amountOfTokens)
1817         isEnoughEth(_amountOfTokens)
1818     {
1819         _safeMint(msg.sender, _amountOfTokens);
1820     }
1821 
1822     /*----------------------------------------------*/
1823     /*             ROYALTIES FUNCTION              */
1824     /*--------------------------------------------*/
1825 
1826     /// @notice Allows to set the royalties on the contract
1827     /// @param value Updated royalties (between 0 and 10000)
1828     function setRoyalties(address recipient, uint256 value) public onlyOwner {
1829         _setRoyalties(recipient, value);
1830     }
1831 
1832     /*----------------------------------------------*/
1833     /*           ADMIN BASE FUNCTIONS              */
1834     /*--------------------------------------------*/
1835 
1836     /// @inheritdoc	ERC165
1837     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981Base) returns (bool) {
1838         return super.supportsInterface(interfaceId);
1839     }
1840 
1841     /// @notice Get the baseURI
1842     function _baseURI() internal view virtual override returns (string memory) {
1843         return baseTokenURI;
1844     }
1845 
1846     /// @notice Set metadata base URI
1847     /// @param _baseTokenURI New base URI
1848     function setBaseURI(string memory _baseTokenURI) public onlyOwner {
1849         baseTokenURI = _baseTokenURI;
1850     }
1851 
1852     /// @notice Set the current status of the sale
1853     /// @param _status Enum value of SaleStatus
1854     function setStatus(SaleStatus _status) public onlyOwner {
1855         status = _status;
1856         emit StatusUpdate(_status);
1857     }
1858     /// @notice Set mint price
1859     /// @param _price Mint price in Wei
1860     function setPrice(uint128 _price) public onlyOwner {
1861         price = _price;
1862     }
1863 
1864     /// @notice Set Presale Merkle Root
1865     /// @param _merkleRoot Merkle Root hash
1866     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1867         merkleRoot = _merkleRoot;
1868     }
1869 
1870     /// @notice Release contract funds to contract owner
1871     function withdrawAll() public payable onlyOwner nonReentrant {
1872         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1873         require(success, "Unsuccessful withdraw");
1874     }
1875 
1876     /// @notice Release any ERC20 tokens to the contract
1877     /// @param token ERC20 token sent to contract
1878     function withdrawTokens(IERC20 token) public onlyOwner {
1879         uint256 balance = token.balanceOf(address(this));
1880         SafeERC20.safeTransfer(token, msg.sender, balance);
1881     }
1882 }