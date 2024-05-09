1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Interface of the ERC20 standard as defined in the EIP.
56  */
57 interface IERC20 {
58     /**
59      * @dev Returns the amount of tokens in existence.
60      */
61     function totalSupply() external view returns (uint256);
62 
63     /**
64      * @dev Returns the amount of tokens owned by `account`.
65      */
66     function balanceOf(address account) external view returns (uint256);
67 
68     /**
69      * @dev Moves `amount` tokens from the caller's account to `recipient`.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Returns the remaining number of tokens that `spender` will be
79      * allowed to spend on behalf of `owner` through {transferFrom}. This is
80      * zero by default.
81      *
82      * This value changes when {approve} or {transferFrom} are called.
83      */
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     /**
87      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * IMPORTANT: Beware that changing an allowance with this method brings the risk
92      * that someone may use both the old and the new allowance by unfortunate
93      * transaction ordering. One possible solution to mitigate this race
94      * condition is to first reduce the spender's allowance to 0 and set the
95      * desired value afterwards:
96      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
97      *
98      * Emits an {Approval} event.
99      */
100     function approve(address spender, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Moves `amount` tokens from `sender` to `recipient` using the
104      * allowance mechanism. `amount` is then deducted from the caller's
105      * allowance.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(
112         address sender,
113         address recipient,
114         uint256 amount
115     ) external returns (bool);
116 
117     /**
118      * @dev Emitted when `value` tokens are moved from one account (`from`) to
119      * another (`to`).
120      *
121      * Note that `value` may be zero.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /**
126      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
127      * a call to {approve}. `value` is the new allowance.
128      */
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev These functions deal with verification of Merkle Trees proofs.
141  *
142  * The proofs can be generated using the JavaScript library
143  * https://github.com/miguelmota/merkletreejs[merkletreejs].
144  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
145  *
146  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
147  */
148 library MerkleProof {
149     /**
150      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
151      * defined by `root`. For this, a `proof` must be provided, containing
152      * sibling hashes on the branch from the leaf to the root of the tree. Each
153      * pair of leaves and each pair of pre-images are assumed to be sorted.
154      */
155     function verify(
156         bytes32[] memory proof,
157         bytes32 root,
158         bytes32 leaf
159     ) internal pure returns (bool) {
160         return processProof(proof, leaf) == root;
161     }
162 
163     /**
164      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
165      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
166      * hash matches the root of the tree. When processing the proof, the pairs
167      * of leafs & pre-images are assumed to be sorted.
168      *
169      * _Available since v4.4._
170      */
171     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
172         bytes32 computedHash = leaf;
173         for (uint256 i = 0; i < proof.length; i++) {
174             bytes32 proofElement = proof[i];
175             if (computedHash <= proofElement) {
176                 // Hash(current computed hash + current element of the proof)
177                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
178             } else {
179                 // Hash(current element of the proof + current computed hash)
180                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
181             }
182         }
183         return computedHash;
184     }
185 }
186 
187 // File: @openzeppelin/contracts/utils/Strings.sol
188 
189 
190 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @dev String operations.
196  */
197 library Strings {
198     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
199 
200     /**
201      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
202      */
203     function toString(uint256 value) internal pure returns (string memory) {
204         // Inspired by OraclizeAPI's implementation - MIT licence
205         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
206 
207         if (value == 0) {
208             return "0";
209         }
210         uint256 temp = value;
211         uint256 digits;
212         while (temp != 0) {
213             digits++;
214             temp /= 10;
215         }
216         bytes memory buffer = new bytes(digits);
217         while (value != 0) {
218             digits -= 1;
219             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
220             value /= 10;
221         }
222         return string(buffer);
223     }
224 
225     /**
226      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
227      */
228     function toHexString(uint256 value) internal pure returns (string memory) {
229         if (value == 0) {
230             return "0x00";
231         }
232         uint256 temp = value;
233         uint256 length = 0;
234         while (temp != 0) {
235             length++;
236             temp >>= 8;
237         }
238         return toHexString(value, length);
239     }
240 
241     /**
242      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
243      */
244     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
245         bytes memory buffer = new bytes(2 * length + 2);
246         buffer[0] = "0";
247         buffer[1] = "x";
248         for (uint256 i = 2 * length + 1; i > 1; --i) {
249             buffer[i] = _HEX_SYMBOLS[value & 0xf];
250             value >>= 4;
251         }
252         require(value == 0, "Strings: hex length insufficient");
253         return string(buffer);
254     }
255 }
256 
257 // File: @openzeppelin/contracts/utils/Context.sol
258 
259 
260 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev Provides information about the current execution context, including the
266  * sender of the transaction and its data. While these are generally available
267  * via msg.sender and msg.data, they should not be accessed in such a direct
268  * manner, since when dealing with meta-transactions the account sending and
269  * paying for execution may not be the actual sender (as far as an application
270  * is concerned).
271  *
272  * This contract is only required for intermediate, library-like contracts.
273  */
274 abstract contract Context {
275     function _msgSender() internal view virtual returns (address) {
276         return msg.sender;
277     }
278 
279     function _msgData() internal view virtual returns (bytes calldata) {
280         return msg.data;
281     }
282 }
283 
284 // File: @openzeppelin/contracts/access/Ownable.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Contract module which provides a basic access control mechanism, where
294  * there is an account (an owner) that can be granted exclusive access to
295  * specific functions.
296  *
297  * By default, the owner account will be the one that deploys the contract. This
298  * can later be changed with {transferOwnership}.
299  *
300  * This module is used through inheritance. It will make available the modifier
301  * `onlyOwner`, which can be applied to your functions to restrict their use to
302  * the owner.
303  */
304 abstract contract Ownable is Context {
305     address private _owner;
306 
307     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
308 
309     /**
310      * @dev Initializes the contract setting the deployer as the initial owner.
311      */
312     constructor() {
313         _transferOwnership(_msgSender());
314     }
315 
316     /**
317      * @dev Returns the address of the current owner.
318      */
319     function owner() public view virtual returns (address) {
320         return _owner;
321     }
322 
323     /**
324      * @dev Throws if called by any account other than the owner.
325      */
326     modifier onlyOwner() {
327         require(owner() == _msgSender(), "Ownable: caller is not the owner");
328         _;
329     }
330 
331     /**
332      * @dev Leaves the contract without owner. It will not be possible to call
333      * `onlyOwner` functions anymore. Can only be called by the current owner.
334      *
335      * NOTE: Renouncing ownership will leave the contract without an owner,
336      * thereby removing any functionality that is only available to the owner.
337      */
338     function renounceOwnership() public virtual onlyOwner {
339         _transferOwnership(address(0));
340     }
341 
342     /**
343      * @dev Transfers ownership of the contract to a new account (`newOwner`).
344      * Can only be called by the current owner.
345      */
346     function transferOwnership(address newOwner) public virtual onlyOwner {
347         require(newOwner != address(0), "Ownable: new owner is the zero address");
348         _transferOwnership(newOwner);
349     }
350 
351     /**
352      * @dev Transfers ownership of the contract to a new account (`newOwner`).
353      * Internal function without access restriction.
354      */
355     function _transferOwnership(address newOwner) internal virtual {
356         address oldOwner = _owner;
357         _owner = newOwner;
358         emit OwnershipTransferred(oldOwner, newOwner);
359     }
360 }
361 
362 // File: @openzeppelin/contracts/utils/Address.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Collection of functions related to the address type
371  */
372 library Address {
373     /**
374      * @dev Returns true if `account` is a contract.
375      *
376      * [IMPORTANT]
377      * ====
378      * It is unsafe to assume that an address for which this function returns
379      * false is an externally-owned account (EOA) and not a contract.
380      *
381      * Among others, `isContract` will return false for the following
382      * types of addresses:
383      *
384      *  - an externally-owned account
385      *  - a contract in construction
386      *  - an address where a contract will be created
387      *  - an address where a contract lived, but was destroyed
388      * ====
389      */
390     function isContract(address account) internal view returns (bool) {
391         // This method relies on extcodesize, which returns 0 for contracts in
392         // construction, since the code is only stored at the end of the
393         // constructor execution.
394 
395         uint256 size;
396         assembly {
397             size := extcodesize(account)
398         }
399         return size > 0;
400     }
401 
402     /**
403      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
404      * `recipient`, forwarding all available gas and reverting on errors.
405      *
406      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
407      * of certain opcodes, possibly making contracts go over the 2300 gas limit
408      * imposed by `transfer`, making them unable to receive funds via
409      * `transfer`. {sendValue} removes this limitation.
410      *
411      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
412      *
413      * IMPORTANT: because control is transferred to `recipient`, care must be
414      * taken to not create reentrancy vulnerabilities. Consider using
415      * {ReentrancyGuard} or the
416      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
417      */
418     function sendValue(address payable recipient, uint256 amount) internal {
419         require(address(this).balance >= amount, "Address: insufficient balance");
420 
421         (bool success, ) = recipient.call{value: amount}("");
422         require(success, "Address: unable to send value, recipient may have reverted");
423     }
424 
425     /**
426      * @dev Performs a Solidity function call using a low level `call`. A
427      * plain `call` is an unsafe replacement for a function call: use this
428      * function instead.
429      *
430      * If `target` reverts with a revert reason, it is bubbled up by this
431      * function (like regular Solidity function calls).
432      *
433      * Returns the raw returned data. To convert to the expected return value,
434      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
435      *
436      * Requirements:
437      *
438      * - `target` must be a contract.
439      * - calling `target` with `data` must not revert.
440      *
441      * _Available since v3.1._
442      */
443     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
444         return functionCall(target, data, "Address: low-level call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
449      * `errorMessage` as a fallback revert reason when `target` reverts.
450      *
451      * _Available since v3.1._
452      */
453     function functionCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         return functionCallWithValue(target, data, 0, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but also transferring `value` wei to `target`.
464      *
465      * Requirements:
466      *
467      * - the calling contract must have an ETH balance of at least `value`.
468      * - the called Solidity function must be `payable`.
469      *
470      * _Available since v3.1._
471      */
472     function functionCallWithValue(
473         address target,
474         bytes memory data,
475         uint256 value
476     ) internal returns (bytes memory) {
477         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
482      * with `errorMessage` as a fallback revert reason when `target` reverts.
483      *
484      * _Available since v3.1._
485      */
486     function functionCallWithValue(
487         address target,
488         bytes memory data,
489         uint256 value,
490         string memory errorMessage
491     ) internal returns (bytes memory) {
492         require(address(this).balance >= value, "Address: insufficient balance for call");
493         require(isContract(target), "Address: call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.call{value: value}(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
501      * but performing a static call.
502      *
503      * _Available since v3.3._
504      */
505     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
506         return functionStaticCall(target, data, "Address: low-level static call failed");
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
511      * but performing a static call.
512      *
513      * _Available since v3.3._
514      */
515     function functionStaticCall(
516         address target,
517         bytes memory data,
518         string memory errorMessage
519     ) internal view returns (bytes memory) {
520         require(isContract(target), "Address: static call to non-contract");
521 
522         (bool success, bytes memory returndata) = target.staticcall(data);
523         return verifyCallResult(success, returndata, errorMessage);
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
528      * but performing a delegate call.
529      *
530      * _Available since v3.4._
531      */
532     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
533         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
538      * but performing a delegate call.
539      *
540      * _Available since v3.4._
541      */
542     function functionDelegateCall(
543         address target,
544         bytes memory data,
545         string memory errorMessage
546     ) internal returns (bytes memory) {
547         require(isContract(target), "Address: delegate call to non-contract");
548 
549         (bool success, bytes memory returndata) = target.delegatecall(data);
550         return verifyCallResult(success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
555      * revert reason using the provided one.
556      *
557      * _Available since v4.3._
558      */
559     function verifyCallResult(
560         bool success,
561         bytes memory returndata,
562         string memory errorMessage
563     ) internal pure returns (bytes memory) {
564         if (success) {
565             return returndata;
566         } else {
567             // Look for revert reason and bubble it up if present
568             if (returndata.length > 0) {
569                 // The easiest way to bubble the revert reason is using memory via assembly
570 
571                 assembly {
572                     let returndata_size := mload(returndata)
573                     revert(add(32, returndata), returndata_size)
574                 }
575             } else {
576                 revert(errorMessage);
577             }
578         }
579     }
580 }
581 
582 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
583 
584 
585 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 
590 
591 /**
592  * @title SafeERC20
593  * @dev Wrappers around ERC20 operations that throw on failure (when the token
594  * contract returns false). Tokens that return no value (and instead revert or
595  * throw on failure) are also supported, non-reverting calls are assumed to be
596  * successful.
597  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
598  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
599  */
600 library SafeERC20 {
601     using Address for address;
602 
603     function safeTransfer(
604         IERC20 token,
605         address to,
606         uint256 value
607     ) internal {
608         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
609     }
610 
611     function safeTransferFrom(
612         IERC20 token,
613         address from,
614         address to,
615         uint256 value
616     ) internal {
617         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
618     }
619 
620     /**
621      * @dev Deprecated. This function has issues similar to the ones found in
622      * {IERC20-approve}, and its usage is discouraged.
623      *
624      * Whenever possible, use {safeIncreaseAllowance} and
625      * {safeDecreaseAllowance} instead.
626      */
627     function safeApprove(
628         IERC20 token,
629         address spender,
630         uint256 value
631     ) internal {
632         // safeApprove should only be called when setting an initial allowance,
633         // or when resetting it to zero. To increase and decrease it, use
634         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
635         require(
636             (value == 0) || (token.allowance(address(this), spender) == 0),
637             "SafeERC20: approve from non-zero to non-zero allowance"
638         );
639         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
640     }
641 
642     function safeIncreaseAllowance(
643         IERC20 token,
644         address spender,
645         uint256 value
646     ) internal {
647         uint256 newAllowance = token.allowance(address(this), spender) + value;
648         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
649     }
650 
651     function safeDecreaseAllowance(
652         IERC20 token,
653         address spender,
654         uint256 value
655     ) internal {
656         unchecked {
657             uint256 oldAllowance = token.allowance(address(this), spender);
658             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
659             uint256 newAllowance = oldAllowance - value;
660             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
661         }
662     }
663 
664     /**
665      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
666      * on the return value: the return value is optional (but if data is returned, it must not be false).
667      * @param token The token targeted by the call.
668      * @param data The call data (encoded using abi.encode or one of its variants).
669      */
670     function _callOptionalReturn(IERC20 token, bytes memory data) private {
671         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
672         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
673         // the target address contains contract code and also asserts for success in the low-level call.
674 
675         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
676         if (returndata.length > 0) {
677             // Return data is optional
678             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
679         }
680     }
681 }
682 
683 
684 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
685 
686 
687 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 /**
692  * @title ERC721 token receiver interface
693  * @dev Interface for any contract that wants to support safeTransfers
694  * from ERC721 asset contracts.
695  */
696 interface IERC721Receiver {
697     /**
698      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
699      * by `operator` from `from`, this function is called.
700      *
701      * It must return its Solidity selector to confirm the token transfer.
702      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
703      *
704      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
705      */
706     function onERC721Received(
707         address operator,
708         address from,
709         uint256 tokenId,
710         bytes calldata data
711     ) external returns (bytes4);
712 }
713 
714 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
715 
716 
717 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
718 
719 pragma solidity ^0.8.0;
720 
721 /**
722  * @dev Interface of the ERC165 standard, as defined in the
723  * https://eips.ethereum.org/EIPS/eip-165[EIP].
724  *
725  * Implementers can declare support of contract interfaces, which can then be
726  * queried by others ({ERC165Checker}).
727  *
728  * For an implementation, see {ERC165}.
729  */
730 interface IERC165 {
731     /**
732      * @dev Returns true if this contract implements the interface defined by
733      * `interfaceId`. See the corresponding
734      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
735      * to learn more about how these ids are created.
736      *
737      * This function call must use less than 30 000 gas.
738      */
739     function supportsInterface(bytes4 interfaceId) external view returns (bool);
740 }
741 
742 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
743 
744 
745 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 
750 /**
751  * @dev Implementation of the {IERC165} interface.
752  *
753  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
754  * for the additional interface id that will be supported. For example:
755  *
756  * ```solidity
757  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
758  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
759  * }
760  * ```
761  *
762  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
763  */
764 abstract contract ERC165 is IERC165 {
765     /**
766      * @dev See {IERC165-supportsInterface}.
767      */
768     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
769         return interfaceId == type(IERC165).interfaceId;
770     }
771 }
772 
773 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
774 
775 
776 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
777 
778 pragma solidity ^0.8.0;
779 
780 
781 /**
782  * @dev Required interface of an ERC721 compliant contract.
783  */
784 interface IERC721 is IERC165 {
785     /**
786      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
787      */
788     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
789 
790     /**
791      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
792      */
793     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
794 
795     /**
796      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
797      */
798     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
799 
800     /**
801      * @dev Returns the number of tokens in ``owner``'s account.
802      */
803     function balanceOf(address owner) external view returns (uint256 balance);
804 
805     /**
806      * @dev Returns the owner of the `tokenId` token.
807      *
808      * Requirements:
809      *
810      * - `tokenId` must exist.
811      */
812     function ownerOf(uint256 tokenId) external view returns (address owner);
813 
814     /**
815      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
816      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
817      *
818      * Requirements:
819      *
820      * - `from` cannot be the zero address.
821      * - `to` cannot be the zero address.
822      * - `tokenId` token must exist and be owned by `from`.
823      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
824      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
825      *
826      * Emits a {Transfer} event.
827      */
828     function safeTransferFrom(
829         address from,
830         address to,
831         uint256 tokenId
832     ) external;
833 
834     /**
835      * @dev Transfers `tokenId` token from `from` to `to`.
836      *
837      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
838      *
839      * Requirements:
840      *
841      * - `from` cannot be the zero address.
842      * - `to` cannot be the zero address.
843      * - `tokenId` token must be owned by `from`.
844      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
845      *
846      * Emits a {Transfer} event.
847      */
848     function transferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) external;
853 
854     /**
855      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
856      * The approval is cleared when the token is transferred.
857      *
858      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
859      *
860      * Requirements:
861      *
862      * - The caller must own the token or be an approved operator.
863      * - `tokenId` must exist.
864      *
865      * Emits an {Approval} event.
866      */
867     function approve(address to, uint256 tokenId) external;
868 
869     /**
870      * @dev Returns the account approved for `tokenId` token.
871      *
872      * Requirements:
873      *
874      * - `tokenId` must exist.
875      */
876     function getApproved(uint256 tokenId) external view returns (address operator);
877 
878     /**
879      * @dev Approve or remove `operator` as an operator for the caller.
880      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
881      *
882      * Requirements:
883      *
884      * - The `operator` cannot be the caller.
885      *
886      * Emits an {ApprovalForAll} event.
887      */
888     function setApprovalForAll(address operator, bool _approved) external;
889 
890     /**
891      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
892      *
893      * See {setApprovalForAll}
894      */
895     function isApprovedForAll(address owner, address operator) external view returns (bool);
896 
897     /**
898      * @dev Safely transfers `tokenId` token from `from` to `to`.
899      *
900      * Requirements:
901      *
902      * - `from` cannot be the zero address.
903      * - `to` cannot be the zero address.
904      * - `tokenId` token must exist and be owned by `from`.
905      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
906      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
907      *
908      * Emits a {Transfer} event.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId,
914         bytes calldata data
915     ) external;
916 }
917 
918 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
919 
920 
921 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
922 
923 pragma solidity ^0.8.0;
924 
925 
926 /**
927  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
928  * @dev See https://eips.ethereum.org/EIPS/eip-721
929  */
930 interface IERC721Enumerable is IERC721 {
931     /**
932      * @dev Returns the total amount of tokens stored by the contract.
933      */
934     function totalSupply() external view returns (uint256);
935 
936     /**
937      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
938      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
939      */
940     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
941 
942     /**
943      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
944      * Use along with {totalSupply} to enumerate all tokens.
945      */
946     function tokenByIndex(uint256 index) external view returns (uint256);
947 }
948 
949 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
950 
951 
952 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
953 
954 pragma solidity ^0.8.0;
955 
956 
957 /**
958  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
959  * @dev See https://eips.ethereum.org/EIPS/eip-721
960  */
961 interface IERC721Metadata is IERC721 {
962     /**
963      * @dev Returns the token collection name.
964      */
965     function name() external view returns (string memory);
966 
967     /**
968      * @dev Returns the token collection symbol.
969      */
970     function symbol() external view returns (string memory);
971 
972     /**
973      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
974      */
975     function tokenURI(uint256 tokenId) external view returns (string memory);
976 }
977 
978 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
979 
980 
981 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
982 
983 pragma solidity ^0.8.0;
984 
985 
986 
987 
988 
989 
990 
991 
992 /**
993  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
994  * the Metadata extension, but not including the Enumerable extension, which is available separately as
995  * {ERC721Enumerable}.
996  */
997 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
998     using Address for address;
999     using Strings for uint256;
1000 
1001     // Token name
1002     string private _name;
1003 
1004     // Token symbol
1005     string private _symbol;
1006 
1007     // Mapping from token ID to owner address
1008     mapping(uint256 => address) private _owners;
1009 
1010     // Mapping owner address to token count
1011     mapping(address => uint256) private _balances;
1012 
1013     // Mapping from token ID to approved address
1014     mapping(uint256 => address) private _tokenApprovals;
1015 
1016     // Mapping from owner to operator approvals
1017     mapping(address => mapping(address => bool)) private _operatorApprovals;
1018 
1019     /**
1020      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1021      */
1022     constructor(string memory name_, string memory symbol_) {
1023         _name = name_;
1024         _symbol = symbol_;
1025     }
1026 
1027     /**
1028      * @dev See {IERC165-supportsInterface}.
1029      */
1030     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1031         return
1032             interfaceId == type(IERC721).interfaceId ||
1033             interfaceId == type(IERC721Metadata).interfaceId ||
1034             super.supportsInterface(interfaceId);
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-balanceOf}.
1039      */
1040     function balanceOf(address owner) public view virtual override returns (uint256) {
1041         require(owner != address(0), "ERC721: balance query for the zero address");
1042         return _balances[owner];
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-ownerOf}.
1047      */
1048     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1049         address owner = _owners[tokenId];
1050         require(owner != address(0), "ERC721: owner query for nonexistent token");
1051         return owner;
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Metadata-name}.
1056      */
1057     function name() public view virtual override returns (string memory) {
1058         return _name;
1059     }
1060 
1061     /**
1062      * @dev See {IERC721Metadata-symbol}.
1063      */
1064     function symbol() public view virtual override returns (string memory) {
1065         return _symbol;
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Metadata-tokenURI}.
1070      */
1071     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1072         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1073 
1074         string memory baseURI = _baseURI();
1075         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1076     }
1077 
1078     /**
1079      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1080      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1081      * by default, can be overriden in child contracts.
1082      */
1083     function _baseURI() internal view virtual returns (string memory) {
1084         return "";
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-approve}.
1089      */
1090     function approve(address to, uint256 tokenId) public virtual override {
1091         address owner = ERC721.ownerOf(tokenId);
1092         require(to != owner, "ERC721: approval to current owner");
1093 
1094         require(
1095             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1096             "ERC721: approve caller is not owner nor approved for all"
1097         );
1098 
1099         _approve(to, tokenId);
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-getApproved}.
1104      */
1105     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1106         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1107 
1108         return _tokenApprovals[tokenId];
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-setApprovalForAll}.
1113      */
1114     function setApprovalForAll(address operator, bool approved) public virtual override {
1115         _setApprovalForAll(_msgSender(), operator, approved);
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-isApprovedForAll}.
1120      */
1121     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1122         return _operatorApprovals[owner][operator];
1123     }
1124 
1125     /**
1126      * @dev See {IERC721-transferFrom}.
1127      */
1128     function transferFrom(
1129         address from,
1130         address to,
1131         uint256 tokenId
1132     ) public virtual override {
1133         //solhint-disable-next-line max-line-length
1134         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1135 
1136         _transfer(from, to, tokenId);
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-safeTransferFrom}.
1141      */
1142     function safeTransferFrom(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) public virtual override {
1147         safeTransferFrom(from, to, tokenId, "");
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-safeTransferFrom}.
1152      */
1153     function safeTransferFrom(
1154         address from,
1155         address to,
1156         uint256 tokenId,
1157         bytes memory _data
1158     ) public virtual override {
1159         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1160         _safeTransfer(from, to, tokenId, _data);
1161     }
1162 
1163     /**
1164      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1165      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1166      *
1167      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1168      *
1169      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1170      * implement alternative mechanisms to perform token transfer, such as signature-based.
1171      *
1172      * Requirements:
1173      *
1174      * - `from` cannot be the zero address.
1175      * - `to` cannot be the zero address.
1176      * - `tokenId` token must exist and be owned by `from`.
1177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function _safeTransfer(
1182         address from,
1183         address to,
1184         uint256 tokenId,
1185         bytes memory _data
1186     ) internal virtual {
1187         _transfer(from, to, tokenId);
1188         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1189     }
1190 
1191     /**
1192      * @dev Returns whether `tokenId` exists.
1193      *
1194      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1195      *
1196      * Tokens start existing when they are minted (`_mint`),
1197      * and stop existing when they are burned (`_burn`).
1198      */
1199     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1200         return _owners[tokenId] != address(0);
1201     }
1202 
1203     /**
1204      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1205      *
1206      * Requirements:
1207      *
1208      * - `tokenId` must exist.
1209      */
1210     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1211         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1212         address owner = ERC721.ownerOf(tokenId);
1213         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1214     }
1215 
1216     /**
1217      * @dev Safely mints `tokenId` and transfers it to `to`.
1218      *
1219      * Requirements:
1220      *
1221      * - `tokenId` must not exist.
1222      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1223      *
1224      * Emits a {Transfer} event.
1225      */
1226     function _safeMint(address to, uint256 tokenId) internal virtual {
1227         _safeMint(to, tokenId, "");
1228     }
1229 
1230     /**
1231      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1232      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1233      */
1234     function _safeMint(
1235         address to,
1236         uint256 tokenId,
1237         bytes memory _data
1238     ) internal virtual {
1239         _mint(to, tokenId);
1240         require(
1241             _checkOnERC721Received(address(0), to, tokenId, _data),
1242             "ERC721: transfer to non ERC721Receiver implementer"
1243         );
1244     }
1245 
1246     /**
1247      * @dev Mints `tokenId` and transfers it to `to`.
1248      *
1249      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1250      *
1251      * Requirements:
1252      *
1253      * - `tokenId` must not exist.
1254      * - `to` cannot be the zero address.
1255      *
1256      * Emits a {Transfer} event.
1257      */
1258     function _mint(address to, uint256 tokenId) internal virtual {
1259         require(to != address(0), "ERC721: mint to the zero address");
1260         require(!_exists(tokenId), "ERC721: token already minted");
1261 
1262         _beforeTokenTransfer(address(0), to, tokenId);
1263 
1264         _balances[to] += 1;
1265         _owners[tokenId] = to;
1266 
1267         emit Transfer(address(0), to, tokenId);
1268     }
1269 
1270     /**
1271      * @dev Destroys `tokenId`.
1272      * The approval is cleared when the token is burned.
1273      *
1274      * Requirements:
1275      *
1276      * - `tokenId` must exist.
1277      *
1278      * Emits a {Transfer} event.
1279      */
1280     function _burn(uint256 tokenId) internal virtual {
1281         address owner = ERC721.ownerOf(tokenId);
1282 
1283         _beforeTokenTransfer(owner, address(0), tokenId);
1284 
1285         // Clear approvals
1286         _approve(address(0), tokenId);
1287 
1288         _balances[owner] -= 1;
1289         delete _owners[tokenId];
1290 
1291         emit Transfer(owner, address(0), tokenId);
1292     }
1293 
1294     /**
1295      * @dev Transfers `tokenId` from `from` to `to`.
1296      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1297      *
1298      * Requirements:
1299      *
1300      * - `to` cannot be the zero address.
1301      * - `tokenId` token must be owned by `from`.
1302      *
1303      * Emits a {Transfer} event.
1304      */
1305     function _transfer(
1306         address from,
1307         address to,
1308         uint256 tokenId
1309     ) internal virtual {
1310         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1311         require(to != address(0), "ERC721: transfer to the zero address");
1312 
1313         _beforeTokenTransfer(from, to, tokenId);
1314 
1315         // Clear approvals from the previous owner
1316         _approve(address(0), tokenId);
1317 
1318         _balances[from] -= 1;
1319         _balances[to] += 1;
1320         _owners[tokenId] = to;
1321 
1322         emit Transfer(from, to, tokenId);
1323     }
1324 
1325     /**
1326      * @dev Approve `to` to operate on `tokenId`
1327      *
1328      * Emits a {Approval} event.
1329      */
1330     function _approve(address to, uint256 tokenId) internal virtual {
1331         _tokenApprovals[tokenId] = to;
1332         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1333     }
1334 
1335     /**
1336      * @dev Approve `operator` to operate on all of `owner` tokens
1337      *
1338      * Emits a {ApprovalForAll} event.
1339      */
1340     function _setApprovalForAll(
1341         address owner,
1342         address operator,
1343         bool approved
1344     ) internal virtual {
1345         require(owner != operator, "ERC721: approve to caller");
1346         _operatorApprovals[owner][operator] = approved;
1347         emit ApprovalForAll(owner, operator, approved);
1348     }
1349 
1350     /**
1351      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1352      * The call is not executed if the target address is not a contract.
1353      *
1354      * @param from address representing the previous owner of the given token ID
1355      * @param to target address that will receive the tokens
1356      * @param tokenId uint256 ID of the token to be transferred
1357      * @param _data bytes optional data to send along with the call
1358      * @return bool whether the call correctly returned the expected magic value
1359      */
1360     function _checkOnERC721Received(
1361         address from,
1362         address to,
1363         uint256 tokenId,
1364         bytes memory _data
1365     ) private returns (bool) {
1366         if (to.isContract()) {
1367             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1368                 return retval == IERC721Receiver.onERC721Received.selector;
1369             } catch (bytes memory reason) {
1370                 if (reason.length == 0) {
1371                     revert("ERC721: transfer to non ERC721Receiver implementer");
1372                 } else {
1373                     assembly {
1374                         revert(add(32, reason), mload(reason))
1375                     }
1376                 }
1377             }
1378         } else {
1379             return true;
1380         }
1381     }
1382 
1383     /**
1384      * @dev Hook that is called before any token transfer. This includes minting
1385      * and burning.
1386      *
1387      * Calling conditions:
1388      *
1389      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1390      * transferred to `to`.
1391      * - When `from` is zero, `tokenId` will be minted for `to`.
1392      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1393      * - `from` and `to` are never both zero.
1394      *
1395      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1396      */
1397     function _beforeTokenTransfer(
1398         address from,
1399         address to,
1400         uint256 tokenId
1401     ) internal virtual {}
1402 }
1403 
1404 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1405 
1406 
1407 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1408 
1409 pragma solidity ^0.8.0;
1410 
1411 
1412 
1413 /**
1414  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1415  * enumerability of all the token ids in the contract as well as all token ids owned by each
1416  * account.
1417  */
1418 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1419     // Mapping from owner to list of owned token IDs
1420     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1421 
1422     // Mapping from token ID to index of the owner tokens list
1423     mapping(uint256 => uint256) private _ownedTokensIndex;
1424 
1425     // Array with all token ids, used for enumeration
1426     uint256[] private _allTokens;
1427 
1428     // Mapping from token id to position in the allTokens array
1429     mapping(uint256 => uint256) private _allTokensIndex;
1430 
1431     /**
1432      * @dev See {IERC165-supportsInterface}.
1433      */
1434     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1435         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1436     }
1437 
1438     /**
1439      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1440      */
1441     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1442         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1443         return _ownedTokens[owner][index];
1444     }
1445 
1446     /**
1447      * @dev See {IERC721Enumerable-totalSupply}.
1448      */
1449     function totalSupply() public view virtual override returns (uint256) {
1450         return _allTokens.length;
1451     }
1452 
1453     /**
1454      * @dev See {IERC721Enumerable-tokenByIndex}.
1455      */
1456     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1457         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1458         return _allTokens[index];
1459     }
1460 
1461     /**
1462      * @dev Hook that is called before any token transfer. This includes minting
1463      * and burning.
1464      *
1465      * Calling conditions:
1466      *
1467      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1468      * transferred to `to`.
1469      * - When `from` is zero, `tokenId` will be minted for `to`.
1470      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1471      * - `from` cannot be the zero address.
1472      * - `to` cannot be the zero address.
1473      *
1474      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1475      */
1476     function _beforeTokenTransfer(
1477         address from,
1478         address to,
1479         uint256 tokenId
1480     ) internal virtual override {
1481         super._beforeTokenTransfer(from, to, tokenId);
1482 
1483         if (from == address(0)) {
1484             _addTokenToAllTokensEnumeration(tokenId);
1485         } else if (from != to) {
1486             _removeTokenFromOwnerEnumeration(from, tokenId);
1487         }
1488         if (to == address(0)) {
1489             _removeTokenFromAllTokensEnumeration(tokenId);
1490         } else if (to != from) {
1491             _addTokenToOwnerEnumeration(to, tokenId);
1492         }
1493     }
1494 
1495     /**
1496      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1497      * @param to address representing the new owner of the given token ID
1498      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1499      */
1500     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1501         uint256 length = ERC721.balanceOf(to);
1502         _ownedTokens[to][length] = tokenId;
1503         _ownedTokensIndex[tokenId] = length;
1504     }
1505 
1506     /**
1507      * @dev Private function to add a token to this extension's token tracking data structures.
1508      * @param tokenId uint256 ID of the token to be added to the tokens list
1509      */
1510     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1511         _allTokensIndex[tokenId] = _allTokens.length;
1512         _allTokens.push(tokenId);
1513     }
1514 
1515     /**
1516      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1517      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1518      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1519      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1520      * @param from address representing the previous owner of the given token ID
1521      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1522      */
1523     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1524         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1525         // then delete the last slot (swap and pop).
1526 
1527         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1528         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1529 
1530         // When the token to delete is the last token, the swap operation is unnecessary
1531         if (tokenIndex != lastTokenIndex) {
1532             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1533 
1534             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1535             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1536         }
1537 
1538         // This also deletes the contents at the last position of the array
1539         delete _ownedTokensIndex[tokenId];
1540         delete _ownedTokens[from][lastTokenIndex];
1541     }
1542 
1543     /**
1544      * @dev Private function to remove a token from this extension's token tracking data structures.
1545      * This has O(1) time complexity, but alters the order of the _allTokens array.
1546      * @param tokenId uint256 ID of the token to be removed from the tokens list
1547      */
1548     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1549         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1550         // then delete the last slot (swap and pop).
1551 
1552         uint256 lastTokenIndex = _allTokens.length - 1;
1553         uint256 tokenIndex = _allTokensIndex[tokenId];
1554 
1555         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1556         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1557         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1558         uint256 lastTokenId = _allTokens[lastTokenIndex];
1559 
1560         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1561         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1562 
1563         // This also deletes the contents at the last position of the array
1564         delete _allTokensIndex[tokenId];
1565         _allTokens.pop();
1566     }
1567 }
1568 
1569 // File: contracts/HodleBoard.sol
1570 
1571 
1572 pragma solidity ^0.8.4;
1573 
1574 contract HodleBoard is ERC721Enumerable, Ownable {
1575     using Counters for Counters.Counter;
1576     using Strings for uint256;
1577 
1578     uint256 public boardTotal;
1579     uint256 public boardMinted;
1580     Counters.Counter private _boardIds;
1581 
1582     bytes32 public rootWordList;
1583     mapping(address => uint256) public _wordLists;
1584 
1585     bool public burnEnabled = false;
1586     bool public mintPaused = false;
1587     uint256 public totalBoardSupply = 8888;
1588     uint256 public wordListLimit = 10;
1589 
1590     bool public boardRevealed = false;
1591     string public baseHash;
1592     string public hiddenHash;
1593     string public baseExt = ".json";
1594 
1595     bool public wordListLive = false;
1596     uint256 _wordlistprice = 90000000000000000; //0.09 ether
1597 
1598     bool public publicLive = false;
1599     uint256 _publicprice = 110000000000000000; //0.11 ether
1600 
1601 
1602     constructor() ERC721("Hodle Board", "HODLE") {}
1603 
1604     function toggleMintPause() public onlyOwner {
1605         mintPaused = !mintPaused;
1606     }
1607 
1608     function toggleWordListMint() public onlyOwner {
1609         wordListLive = !wordListLive;
1610     }
1611 
1612     function togglePublicMint() public onlyOwner {
1613         publicLive = !publicLive;
1614     }
1615 
1616     function changeIPFSBase(string calldata _newBaseURI) external onlyOwner {
1617         baseHash = _newBaseURI;
1618     }
1619 
1620     function _baseURI() internal view override returns (string memory) {
1621         return baseHash;
1622     }
1623 
1624     function revealBoards() public onlyOwner {
1625         boardRevealed = true;
1626     }
1627 
1628     function toggleBurnStatus(bool _burnStatus) external onlyOwner {
1629         burnEnabled = _burnStatus;
1630     }
1631 
1632     function mintWordList(uint256 _mintqty, bytes32[] memory wordListProof) external payable {
1633         require(wordListLive, "The Hodle Board WordList mint is currently unavailable.");
1634         require(!mintPaused, "The Hodle Board WordList mint is currently paused.");
1635 
1636         require(_mintqty <= wordListLimit, "You can mint a maximum of 10 Hodle Boards on the WordList mint.");
1637         require(_wordLists[msg.sender] + _mintqty <= wordListLimit, "This address has already claimed 10 WordList mints.");
1638 
1639         require(checkWordList(msg.sender, wordListProof), "This address is not on the WordList.");
1640 
1641         require(boardMinted + _mintqty <= totalBoardSupply, "The Hodle Board collection is minted out.");
1642         require(_wordlistprice * _mintqty <= msg.value, "The transaction requires more ETH to WordList mint.");
1643 
1644         uint256 _freshBoardId;
1645         for (uint256 i = 0; i < _mintqty; i++) {
1646             _boardIds.increment();
1647             _freshBoardId = _boardIds.current();
1648             _safeMint(msg.sender, _freshBoardId);
1649             _wordLists[msg.sender] = _wordLists[msg.sender] + 1;
1650             boardTotal = boardTotal + 1;
1651             boardMinted = boardMinted + 1;
1652         }
1653     }
1654 
1655     function publicMint(uint256 _mintqty) external payable {
1656         require(publicLive, "The Hodle Board public mint is currently unavailable.");
1657         require(!mintPaused, "The Hodle Board public mint is currently paused.");
1658 
1659         require(_mintqty > 0, "You must mint more than 0 Hodle Boards.");
1660         require(boardMinted + _mintqty <= totalBoardSupply, "The Hodle Board collection is minted out.");
1661         require(_publicprice * _mintqty <= msg.value, "The transaction requires more ETH to WordList mint.");
1662 
1663         uint256 _freshBoardId;
1664         for (uint256 i = 0; i < _mintqty; i++) {
1665             _boardIds.increment();
1666             _freshBoardId = _boardIds.current();
1667             _safeMint(msg.sender, _freshBoardId);
1668             boardTotal = boardTotal + 1;
1669             boardMinted = boardMinted + 1;
1670         }
1671     }
1672 
1673     function mintTeamBoards(uint256 _mintqty) external onlyOwner {
1674       uint256 _freshBoardId;
1675       for (uint256 i = 1; i <= _mintqty; i++) {
1676         _boardIds.increment();
1677         _freshBoardId = _boardIds.current();
1678         _safeMint(msg.sender, _freshBoardId);
1679         boardTotal = boardTotal + 1;
1680         boardMinted = boardMinted + 1;
1681       }
1682     }
1683 
1684     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1685         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1686 
1687         if (boardRevealed == false) {
1688             return hiddenHash;
1689         }
1690 
1691         string memory crnt_URI = _baseURI();
1692         return bytes(crnt_URI).length > 0 ? string(abi.encodePacked(crnt_URI, "/", tokenId.toString(), baseExt)) : "";
1693     }
1694 
1695     function setHiddenHash(string memory _newHash) public onlyOwner {
1696         hiddenHash = _newHash;
1697     }
1698 
1699     function editSupply(uint256 _newSupply) public onlyOwner {
1700         totalBoardSupply = _newSupply;
1701     }
1702 
1703     function editRootWordList(bytes32 _newRoot) public onlyOwner {
1704         rootWordList = _newRoot;
1705     }
1706 
1707     function burn(uint256 tokenId) external {
1708         require(burnEnabled, "Hodle Board burning is currently disabled.");
1709         require(_isApprovedOrOwner(msg.sender, tokenId), "Burn caller is not approved nor the owner.");
1710         _burn(tokenId);
1711         boardTotal = boardTotal - 1;
1712     }
1713 
1714     function checkWordList(address walletAddress, bytes32[] memory wordListProof) internal view returns (bool) {
1715         bytes32 edgeNode = keccak256(abi.encodePacked(walletAddress));
1716         return MerkleProof.verify(wordListProof, rootWordList, edgeNode);
1717     }
1718 
1719     function wdrawDeployContract() public onlyOwner {
1720         uint256 contractAmount = address(this).balance;
1721         payable(owner()).transfer(contractAmount);
1722     }
1723 }