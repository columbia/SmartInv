1 pragma solidity ^0.8.0;
2 
3 // SPDX-License-Identifier: MIT
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _setOwner(_msgSender());
47     }
48 
49     /**
50      * @dev Returns the address of the current owner.
51      */
52     function owner() public view virtual returns (address) {
53         return _owner;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     /**
65      * @dev Leaves the contract without owner. It will not be possible to call
66      * `onlyOwner` functions anymore. Can only be called by the current owner.
67      *
68      * NOTE: Renouncing ownership will leave the contract without an owner,
69      * thereby removing any functionality that is only available to the owner.
70      */
71     function renounceOwnership() public virtual onlyOwner {
72         _setOwner(address(0));
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Can only be called by the current owner.
78      */
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         _setOwner(newOwner);
82     }
83 
84     function _setOwner(address newOwner) private {
85         address oldOwner = _owner;
86         _owner = newOwner;
87         emit OwnershipTransferred(oldOwner, newOwner);
88     }
89 }
90 
91 /**
92  * @dev Contract module that helps prevent reentrant calls to a function.
93  *
94  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
95  * available, which can be applied to functions to make sure there are no nested
96  * (reentrant) calls to them.
97  *
98  * Note that because there is a single `nonReentrant` guard, functions marked as
99  * `nonReentrant` may not call one another. This can be worked around by making
100  * those functions `private`, and then adding `external` `nonReentrant` entry
101  * points to them.
102  *
103  * TIP: If you would like to learn more about reentrancy and alternative ways
104  * to protect against it, check out our blog post
105  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
106  */
107 abstract contract ReentrancyGuard {
108     // Booleans are more expensive than uint256 or any type that takes up a full
109     // word because each write operation emits an extra SLOAD to first read the
110     // slot's contents, replace the bits taken up by the boolean, and then write
111     // back. This is the compiler's defense against contract upgrades and
112     // pointer aliasing, and it cannot be disabled.
113 
114     // The values being non-zero value makes deployment a bit more expensive,
115     // but in exchange the refund on every call to nonReentrant will be lower in
116     // amount. Since refunds are capped to a percentage of the total
117     // transaction's gas, it is best to keep them low in cases like this one, to
118     // increase the likelihood of the full refund coming into effect.
119     uint256 private constant _NOT_ENTERED = 1;
120     uint256 private constant _ENTERED = 2;
121 
122     uint256 private _status;
123 
124     constructor() {
125         _status = _NOT_ENTERED;
126     }
127 
128     /**
129      * @dev Prevents a contract from calling itself, directly or indirectly.
130      * Calling a `nonReentrant` function from another `nonReentrant`
131      * function is not supported. It is possible to prevent this from happening
132      * by making the `nonReentrant` function external, and make it call a
133      * `private` function that does the actual work.
134      */
135     modifier nonReentrant() {
136         // On the first call to nonReentrant, _notEntered will be true
137         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
138 
139         // Any calls to nonReentrant after this point will fail
140         _status = _ENTERED;
141 
142         _;
143 
144         // By storing the original value once again, a refund is triggered (see
145         // https://eips.ethereum.org/EIPS/eip-2200)
146         _status = _NOT_ENTERED;
147     }
148 }
149 
150 /**
151  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
152  *
153  * These functions can be used to verify that a message was signed by the holder
154  * of the private keys of a given address.
155  */
156 library ECDSA {
157     /**
158      * @dev Returns the address that signed a hashed message (`hash`) with
159      * `signature`. This address can then be used for verification purposes.
160      *
161      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
162      * this function rejects them by requiring the `s` value to be in the lower
163      * half order, and the `v` value to be either 27 or 28.
164      *
165      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
166      * verification to be secure: it is possible to craft signatures that
167      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
168      * this is by receiving a hash of the original message (which may otherwise
169      * be too long), and then calling {toEthSignedMessageHash} on it.
170      *
171      * Documentation for signature generation:
172      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
173      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
174      */
175     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
176         // Check the signature length
177         // - case 65: r,s,v signature (standard)
178         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
179         if (signature.length == 65) {
180             bytes32 r;
181             bytes32 s;
182             uint8 v;
183             // ecrecover takes the signature parameters, and the only way to get them
184             // currently is to use assembly.
185             assembly {
186                 r := mload(add(signature, 0x20))
187                 s := mload(add(signature, 0x40))
188                 v := byte(0, mload(add(signature, 0x60)))
189             }
190             return recover(hash, v, r, s);
191         } else if (signature.length == 64) {
192             bytes32 r;
193             bytes32 vs;
194             // ecrecover takes the signature parameters, and the only way to get them
195             // currently is to use assembly.
196             assembly {
197                 r := mload(add(signature, 0x20))
198                 vs := mload(add(signature, 0x40))
199             }
200             return recover(hash, r, vs);
201         } else {
202             revert("ECDSA: invalid signature length");
203         }
204     }
205 
206     /**
207      * @dev Overload of {ECDSA-recover} that receives the `r` and `vs` short-signature fields separately.
208      *
209      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
210      *
211      * _Available since v4.2._
212      */
213     function recover(
214         bytes32 hash,
215         bytes32 r,
216         bytes32 vs
217     ) internal pure returns (address) {
218         bytes32 s;
219         uint8 v;
220         assembly {
221             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
222             v := add(shr(255, vs), 27)
223         }
224         return recover(hash, v, r, s);
225     }
226 
227     /**
228      * @dev Overload of {ECDSA-recover} that receives the `v`, `r` and `s` signature fields separately.
229      */
230     function recover(
231         bytes32 hash,
232         uint8 v,
233         bytes32 r,
234         bytes32 s
235     ) internal pure returns (address) {
236         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
237         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
238         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
239         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
240         //
241         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
242         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
243         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
244         // these malleable signatures as well.
245         require(
246             uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
247             "ECDSA: invalid signature 's' value"
248         );
249         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
250 
251         // If the signature is valid (and not malleable), return the signer address
252         address signer = ecrecover(hash, v, r, s);
253         require(signer != address(0), "ECDSA: invalid signature");
254 
255         return signer;
256     }
257 
258     /**
259      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
260      * produces hash corresponding to the one signed with the
261      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
262      * JSON-RPC method as part of EIP-191.
263      *
264      * See {recover}.
265      */
266     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
267         // 32 is the length in bytes of hash,
268         // enforced by the type signature above
269         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
270     }
271 
272     /**
273      * @dev Returns an Ethereum Signed Typed Data, created from a
274      * `domainSeparator` and a `structHash`. This produces hash corresponding
275      * to the one signed with the
276      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
277      * JSON-RPC method as part of EIP-712.
278      *
279      * See {recover}.
280      */
281     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
282         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
283     }
284 }
285 
286 /**
287  * @dev Interface of the ERC165 standard, as defined in the
288  * https://eips.ethereum.org/EIPS/eip-165[EIP].
289  *
290  * Implementers can declare support of contract interfaces, which can then be
291  * queried by others ({ERC165Checker}).
292  *
293  * For an implementation, see {ERC165}.
294  */
295 interface IERC165 {
296     /**
297      * @dev Returns true if this contract implements the interface defined by
298      * `interfaceId`. See the corresponding
299      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
300      * to learn more about how these ids are created.
301      *
302      * This function call must use less than 30 000 gas.
303      */
304     function supportsInterface(bytes4 interfaceId) external view returns (bool);
305 }
306 
307 /**
308  * @dev Required interface of an ERC721 compliant contract.
309  */
310 interface IERC721 is IERC165 {
311     /**
312      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
313      */
314     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
315 
316     /**
317      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
318      */
319     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
320 
321     /**
322      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
323      */
324     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
325 
326     /**
327      * @dev Returns the number of tokens in ``owner``'s account.
328      */
329     function balanceOf(address owner) external view returns (uint256 balance);
330 
331     /**
332      * @dev Returns the owner of the `tokenId` token.
333      *
334      * Requirements:
335      *
336      * - `tokenId` must exist.
337      */
338     function ownerOf(uint256 tokenId) external view returns (address owner);
339 
340     /**
341      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
342      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
343      *
344      * Requirements:
345      *
346      * - `from` cannot be the zero address.
347      * - `to` cannot be the zero address.
348      * - `tokenId` token must exist and be owned by `from`.
349      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
350      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
351      *
352      * Emits a {Transfer} event.
353      */
354     function safeTransferFrom(
355         address from,
356         address to,
357         uint256 tokenId
358     ) external;
359 
360     /**
361      * @dev Transfers `tokenId` token from `from` to `to`.
362      *
363      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
364      *
365      * Requirements:
366      *
367      * - `from` cannot be the zero address.
368      * - `to` cannot be the zero address.
369      * - `tokenId` token must be owned by `from`.
370      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
371      *
372      * Emits a {Transfer} event.
373      */
374     function transferFrom(
375         address from,
376         address to,
377         uint256 tokenId
378     ) external;
379 
380     /**
381      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
382      * The approval is cleared when the token is transferred.
383      *
384      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
385      *
386      * Requirements:
387      *
388      * - The caller must own the token or be an approved operator.
389      * - `tokenId` must exist.
390      *
391      * Emits an {Approval} event.
392      */
393     function approve(address to, uint256 tokenId) external;
394 
395     /**
396      * @dev Returns the account approved for `tokenId` token.
397      *
398      * Requirements:
399      *
400      * - `tokenId` must exist.
401      */
402     function getApproved(uint256 tokenId) external view returns (address operator);
403 
404     /**
405      * @dev Approve or remove `operator` as an operator for the caller.
406      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
407      *
408      * Requirements:
409      *
410      * - The `operator` cannot be the caller.
411      *
412      * Emits an {ApprovalForAll} event.
413      */
414     function setApprovalForAll(address operator, bool _approved) external;
415 
416     /**
417      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
418      *
419      * See {setApprovalForAll}
420      */
421     function isApprovedForAll(address owner, address operator) external view returns (bool);
422 
423     /**
424      * @dev Safely transfers `tokenId` token from `from` to `to`.
425      *
426      * Requirements:
427      *
428      * - `from` cannot be the zero address.
429      * - `to` cannot be the zero address.
430      * - `tokenId` token must exist and be owned by `from`.
431      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
432      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
433      *
434      * Emits a {Transfer} event.
435      */
436     function safeTransferFrom(
437         address from,
438         address to,
439         uint256 tokenId,
440         bytes calldata data
441     ) external;
442 }
443 
444 /**
445  * @title ERC721 token receiver interface
446  * @dev Interface for any contract that wants to support safeTransfers
447  * from ERC721 asset contracts.
448  */
449 interface IERC721Receiver {
450     /**
451      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
452      * by `operator` from `from`, this function is called.
453      *
454      * It must return its Solidity selector to confirm the token transfer.
455      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
456      *
457      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
458      */
459     function onERC721Received(
460         address operator,
461         address from,
462         uint256 tokenId,
463         bytes calldata data
464     ) external returns (bytes4);
465 }
466 
467 /**
468  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
469  * @dev See https://eips.ethereum.org/EIPS/eip-721
470  */
471 interface IERC721Metadata is IERC721 {
472     /**
473      * @dev Returns the token collection name.
474      */
475     function name() external view returns (string memory);
476 
477     /**
478      * @dev Returns the token collection symbol.
479      */
480     function symbol() external view returns (string memory);
481 
482     /**
483      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
484      */
485     function tokenURI(uint256 tokenId) external view returns (string memory);
486 }
487 
488 /**
489  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
490  * @dev See https://eips.ethereum.org/EIPS/eip-721
491  */
492 interface IERC721Enumerable is IERC721 {
493     /**
494      * @dev Returns the total amount of tokens stored by the contract.
495      */
496     function totalSupply() external view returns (uint256);
497 
498     /**
499      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
500      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
501      */
502     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
503 
504     /**
505      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
506      * Use along with {totalSupply} to enumerate all tokens.
507      */
508     function tokenByIndex(uint256 index) external view returns (uint256);
509 }
510 
511 /**
512  * @dev Collection of functions related to the address type
513  */
514 library Address {
515     /**
516      * @dev Returns true if `account` is a contract.
517      *
518      * [IMPORTANT]
519      * ====
520      * It is unsafe to assume that an address for which this function returns
521      * false is an externally-owned account (EOA) and not a contract.
522      *
523      * Among others, `isContract` will return false for the following
524      * types of addresses:
525      *
526      *  - an externally-owned account
527      *  - a contract in construction
528      *  - an address where a contract will be created
529      *  - an address where a contract lived, but was destroyed
530      * ====
531      */
532     function isContract(address account) internal view returns (bool) {
533         // This method relies on extcodesize, which returns 0 for contracts in
534         // construction, since the code is only stored at the end of the
535         // constructor execution.
536 
537         uint256 size;
538         assembly {
539             size := extcodesize(account)
540         }
541         return size > 0;
542     }
543 
544     /**
545      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
546      * `recipient`, forwarding all available gas and reverting on errors.
547      *
548      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
549      * of certain opcodes, possibly making contracts go over the 2300 gas limit
550      * imposed by `transfer`, making them unable to receive funds via
551      * `transfer`. {sendValue} removes this limitation.
552      *
553      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
554      *
555      * IMPORTANT: because control is transferred to `recipient`, care must be
556      * taken to not create reentrancy vulnerabilities. Consider using
557      * {ReentrancyGuard} or the
558      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
559      */
560     function sendValue(address payable recipient, uint256 amount) internal {
561         require(address(this).balance >= amount, "Address: insufficient balance");
562 
563         (bool success, ) = recipient.call{value: amount}("");
564         require(success, "Address: unable to send value, recipient may have reverted");
565     }
566 
567     /**
568      * @dev Performs a Solidity function call using a low level `call`. A
569      * plain `call` is an unsafe replacement for a function call: use this
570      * function instead.
571      *
572      * If `target` reverts with a revert reason, it is bubbled up by this
573      * function (like regular Solidity function calls).
574      *
575      * Returns the raw returned data. To convert to the expected return value,
576      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
577      *
578      * Requirements:
579      *
580      * - `target` must be a contract.
581      * - calling `target` with `data` must not revert.
582      *
583      * _Available since v3.1._
584      */
585     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
586         return functionCall(target, data, "Address: low-level call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
591      * `errorMessage` as a fallback revert reason when `target` reverts.
592      *
593      * _Available since v3.1._
594      */
595     function functionCall(
596         address target,
597         bytes memory data,
598         string memory errorMessage
599     ) internal returns (bytes memory) {
600         return functionCallWithValue(target, data, 0, errorMessage);
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
605      * but also transferring `value` wei to `target`.
606      *
607      * Requirements:
608      *
609      * - the calling contract must have an ETH balance of at least `value`.
610      * - the called Solidity function must be `payable`.
611      *
612      * _Available since v3.1._
613      */
614     function functionCallWithValue(
615         address target,
616         bytes memory data,
617         uint256 value
618     ) internal returns (bytes memory) {
619         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
624      * with `errorMessage` as a fallback revert reason when `target` reverts.
625      *
626      * _Available since v3.1._
627      */
628     function functionCallWithValue(
629         address target,
630         bytes memory data,
631         uint256 value,
632         string memory errorMessage
633     ) internal returns (bytes memory) {
634         require(address(this).balance >= value, "Address: insufficient balance for call");
635         require(isContract(target), "Address: call to non-contract");
636 
637         (bool success, bytes memory returndata) = target.call{value: value}(data);
638         return _verifyCallResult(success, returndata, errorMessage);
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
643      * but performing a static call.
644      *
645      * _Available since v3.3._
646      */
647     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
648         return functionStaticCall(target, data, "Address: low-level static call failed");
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
653      * but performing a static call.
654      *
655      * _Available since v3.3._
656      */
657     function functionStaticCall(
658         address target,
659         bytes memory data,
660         string memory errorMessage
661     ) internal view returns (bytes memory) {
662         require(isContract(target), "Address: static call to non-contract");
663 
664         (bool success, bytes memory returndata) = target.staticcall(data);
665         return _verifyCallResult(success, returndata, errorMessage);
666     }
667 
668     /**
669      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
670      * but performing a delegate call.
671      *
672      * _Available since v3.4._
673      */
674     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
675         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
680      * but performing a delegate call.
681      *
682      * _Available since v3.4._
683      */
684     function functionDelegateCall(
685         address target,
686         bytes memory data,
687         string memory errorMessage
688     ) internal returns (bytes memory) {
689         require(isContract(target), "Address: delegate call to non-contract");
690 
691         (bool success, bytes memory returndata) = target.delegatecall(data);
692         return _verifyCallResult(success, returndata, errorMessage);
693     }
694 
695     function _verifyCallResult(
696         bool success,
697         bytes memory returndata,
698         string memory errorMessage
699     ) private pure returns (bytes memory) {
700         if (success) {
701             return returndata;
702         } else {
703             // Look for revert reason and bubble it up if present
704             if (returndata.length > 0) {
705                 // The easiest way to bubble the revert reason is using memory via assembly
706 
707                 assembly {
708                     let returndata_size := mload(returndata)
709                     revert(add(32, returndata), returndata_size)
710                 }
711             } else {
712                 revert(errorMessage);
713             }
714         }
715     }
716 }
717 
718 /**
719  * @dev String operations.
720  */
721 library Strings {
722     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
723 
724     /**
725      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
726      */
727     function toString(uint256 value) internal pure returns (string memory) {
728         // Inspired by OraclizeAPI's implementation - MIT licence
729         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
730 
731         if (value == 0) {
732             return "0";
733         }
734         uint256 temp = value;
735         uint256 digits;
736         while (temp != 0) {
737             digits++;
738             temp /= 10;
739         }
740         bytes memory buffer = new bytes(digits);
741         while (value != 0) {
742             digits -= 1;
743             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
744             value /= 10;
745         }
746         return string(buffer);
747     }
748 
749     /**
750      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
751      */
752     function toHexString(uint256 value) internal pure returns (string memory) {
753         if (value == 0) {
754             return "0x00";
755         }
756         uint256 temp = value;
757         uint256 length = 0;
758         while (temp != 0) {
759             length++;
760             temp >>= 8;
761         }
762         return toHexString(value, length);
763     }
764 
765     /**
766      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
767      */
768     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
769         bytes memory buffer = new bytes(2 * length + 2);
770         buffer[0] = "0";
771         buffer[1] = "x";
772         for (uint256 i = 2 * length + 1; i > 1; --i) {
773             buffer[i] = _HEX_SYMBOLS[value & 0xf];
774             value >>= 4;
775         }
776         require(value == 0, "Strings: hex length insufficient");
777         return string(buffer);
778     }
779 }
780 
781 /**
782  * @dev Implementation of the {IERC165} interface.
783  *
784  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
785  * for the additional interface id that will be supported. For example:
786  *
787  * ```solidity
788  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
789  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
790  * }
791  * ```
792  *
793  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
794  */
795 abstract contract ERC165 is IERC165 {
796     /**
797      * @dev See {IERC165-supportsInterface}.
798      */
799     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
800         return interfaceId == type(IERC165).interfaceId;
801     }
802 }
803 
804 /**
805  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
806  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
807  *
808  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
809  *
810  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
811  *
812  * Does not support burning tokens to address(0).
813  */
814 contract ERC721A is
815 Context,
816 ERC165,
817 IERC721,
818 IERC721Metadata,
819 IERC721Enumerable
820 {
821     using Address for address;
822     using Strings for uint256;
823 
824     struct TokenOwnership {
825         address addr;
826         uint64 startTimestamp;
827     }
828 
829     struct AddressData {
830         uint128 balance;
831         uint128 numberMinted;
832     }
833 
834     uint256 private currentIndex = 0;
835 
836     uint256 internal immutable collectionSize;
837     uint256 internal immutable maxBatchSize;
838 
839     // Token name
840     string private _name;
841 
842     // Token symbol
843     string private _symbol;
844 
845     // Mapping from token ID to ownership details
846     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
847     mapping(uint256 => TokenOwnership) private _ownerships;
848 
849     // Mapping owner address to address data
850     mapping(address => AddressData) private _addressData;
851 
852     // Mapping from token ID to approved address
853     mapping(uint256 => address) private _tokenApprovals;
854 
855     // Mapping from owner to operator approvals
856     mapping(address => mapping(address => bool)) private _operatorApprovals;
857 
858     /**
859      * @dev
860      * `maxBatchSize` refers to how much a minter can mint at a time.
861      * `collectionSize_` refers to how many tokens are in the collection.
862      */
863     constructor(
864         string memory name_,
865         string memory symbol_,
866         uint256 maxBatchSize_,
867         uint256 collectionSize_
868     ) {
869         require(
870             collectionSize_ > 0,
871             "ERC721A: collection must have a nonzero supply"
872         );
873         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
874         _name = name_;
875         _symbol = symbol_;
876         maxBatchSize = maxBatchSize_;
877         collectionSize = collectionSize_;
878     }
879 
880     /**
881      * @dev See {IERC721Enumerable-totalSupply}.
882      */
883     function totalSupply() public view override returns (uint256) {
884         return currentIndex;
885     }
886 
887     /**
888      * @dev See {IERC721Enumerable-tokenByIndex}.
889      */
890     function tokenByIndex(uint256 index)
891     public
892     view
893     override
894     returns (uint256)
895     {
896         require(index < totalSupply(), "ERC721A: global index out of bounds");
897         return index;
898     }
899 
900     /**
901      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
902      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
903      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
904      */
905     function tokenOfOwnerByIndex(address owner, uint256 index)
906     public
907     view
908     override
909     returns (uint256)
910     {
911         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
912         uint256 numMintedSoFar = totalSupply();
913         uint256 tokenIdsIdx = 0;
914         address currOwnershipAddr = address(0);
915         for (uint256 i = 0; i < numMintedSoFar; i++) {
916             TokenOwnership memory ownership = _ownerships[i];
917             if (ownership.addr != address(0)) {
918                 currOwnershipAddr = ownership.addr;
919             }
920             if (currOwnershipAddr == owner) {
921                 if (tokenIdsIdx == index) {
922                     return i;
923                 }
924                 tokenIdsIdx++;
925             }
926         }
927         revert("ERC721A: unable to get token of owner by index");
928     }
929 
930     /**
931      * @dev See {IERC165-supportsInterface}.
932      */
933     function supportsInterface(bytes4 interfaceId)
934     public
935     view
936     virtual
937     override(ERC165, IERC165)
938     returns (bool)
939     {
940         return
941         interfaceId == type(IERC721).interfaceId ||
942         interfaceId == type(IERC721Metadata).interfaceId ||
943         interfaceId == type(IERC721Enumerable).interfaceId ||
944         super.supportsInterface(interfaceId);
945     }
946 
947     /**
948      * @dev See {IERC721-balanceOf}.
949      */
950     function balanceOf(address owner) public view override returns (uint256) {
951         require(
952             owner != address(0),
953             "ERC721A: balance query for the zero address"
954         );
955         return uint256(_addressData[owner].balance);
956     }
957 
958     function _numberMinted(address owner) internal view returns (uint256) {
959         require(
960             owner != address(0),
961             "ERC721A: number minted query for the zero address"
962         );
963         return uint256(_addressData[owner].numberMinted);
964     }
965 
966     function ownershipOf(uint256 tokenId)
967     internal
968     view
969     returns (TokenOwnership memory)
970     {
971         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
972 
973         uint256 lowestTokenToCheck;
974         if (tokenId >= maxBatchSize) {
975             lowestTokenToCheck = tokenId - maxBatchSize + 1;
976         }
977 
978         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
979             TokenOwnership memory ownership = _ownerships[curr];
980             if (ownership.addr != address(0)) {
981                 return ownership;
982             }
983         }
984 
985         revert("ERC721A: unable to determine the owner of token");
986     }
987 
988     /**
989      * @dev See {IERC721-ownerOf}.
990      */
991     function ownerOf(uint256 tokenId) public view override returns (address) {
992         return ownershipOf(tokenId).addr;
993     }
994 
995     /**
996      * @dev See {IERC721Metadata-name}.
997      */
998     function name() public view virtual override returns (string memory) {
999         return _name;
1000     }
1001 
1002     /**
1003      * @dev See {IERC721Metadata-symbol}.
1004      */
1005     function symbol() public view virtual override returns (string memory) {
1006         return _symbol;
1007     }
1008 
1009     /**
1010      * @dev See {IERC721Metadata-tokenURI}.
1011      */
1012     function tokenURI(uint256 tokenId)
1013     public
1014     view
1015     virtual
1016     override
1017     returns (string memory)
1018     {
1019         require(
1020             _exists(tokenId),
1021             "ERC721Metadata: URI query for nonexistent token"
1022         );
1023 
1024         string memory baseURI = _baseURI();
1025         return
1026         bytes(baseURI).length > 0
1027         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1028         : "";
1029     }
1030 
1031     /**
1032      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1033      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1034      * by default, can be overriden in child contracts.
1035      */
1036     function _baseURI() internal view virtual returns (string memory) {
1037         return "";
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-approve}.
1042      */
1043     function approve(address to, uint256 tokenId) public override {
1044         address owner = ERC721A.ownerOf(tokenId);
1045         require(to != owner, "ERC721A: approval to current owner");
1046 
1047         require(
1048             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1049             "ERC721A: approve caller is not owner nor approved for all"
1050         );
1051 
1052         _approve(to, tokenId, owner);
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-getApproved}.
1057      */
1058     function getApproved(uint256 tokenId)
1059     public
1060     view
1061     override
1062     returns (address)
1063     {
1064         require(
1065             _exists(tokenId),
1066             "ERC721A: approved query for nonexistent token"
1067         );
1068 
1069         return _tokenApprovals[tokenId];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-setApprovalForAll}.
1074      */
1075     function setApprovalForAll(address operator, bool approved)
1076     public
1077     override
1078     {
1079         require(operator != _msgSender(), "ERC721A: approve to caller");
1080 
1081         _operatorApprovals[_msgSender()][operator] = approved;
1082         emit ApprovalForAll(_msgSender(), operator, approved);
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-isApprovedForAll}.
1087      */
1088     function isApprovedForAll(address owner, address operator)
1089     public
1090     view
1091     virtual
1092     override
1093     returns (bool)
1094     {
1095         return _operatorApprovals[owner][operator];
1096     }
1097 
1098     /**
1099      * @dev See {IERC721-transferFrom}.
1100      */
1101     function transferFrom(
1102         address from,
1103         address to,
1104         uint256 tokenId
1105     ) public override {
1106         _transfer(from, to, tokenId);
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-safeTransferFrom}.
1111      */
1112     function safeTransferFrom(
1113         address from,
1114         address to,
1115         uint256 tokenId
1116     ) public override {
1117         safeTransferFrom(from, to, tokenId, "");
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-safeTransferFrom}.
1122      */
1123     function safeTransferFrom(
1124         address from,
1125         address to,
1126         uint256 tokenId,
1127         bytes memory _data
1128     ) public override {
1129         _transfer(from, to, tokenId);
1130         require(
1131             _checkOnERC721Received(from, to, tokenId, _data),
1132             "ERC721A: transfer to non ERC721Receiver implementer"
1133         );
1134     }
1135 
1136     /**
1137      * @dev Returns whether `tokenId` exists.
1138      *
1139      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1140      *
1141      * Tokens start existing when they are minted (`_mint`),
1142      */
1143     function _exists(uint256 tokenId) internal view returns (bool) {
1144         return tokenId < currentIndex;
1145     }
1146 
1147     function _safeMint(address to, uint256 quantity) internal {
1148         _safeMint(to, quantity, "");
1149     }
1150 
1151     /**
1152      * @dev Mints `quantity` tokens and transfers them to `to`.
1153      *
1154      * Requirements:
1155      *
1156      * - there must be `quantity` tokens remaining unminted in the total collection.
1157      * - `to` cannot be the zero address.
1158      * - `quantity` cannot be larger than the max batch size.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function _safeMint(
1163         address to,
1164         uint256 quantity,
1165         bytes memory _data
1166     ) internal {
1167         uint256 startTokenId = currentIndex;
1168         require(to != address(0), "ERC721A: mint to the zero address");
1169         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1170         require(!_exists(startTokenId), "ERC721A: token already minted");
1171         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1172 
1173         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1174 
1175         AddressData memory addressData = _addressData[to];
1176         _addressData[to] = AddressData(
1177             addressData.balance + uint128(quantity),
1178             addressData.numberMinted + uint128(quantity)
1179         );
1180         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1181 
1182         uint256 updatedIndex = startTokenId;
1183 
1184         for (uint256 i = 0; i < quantity; i++) {
1185             emit Transfer(address(0), to, updatedIndex);
1186             require(
1187                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1188                 "ERC721A: transfer to non ERC721Receiver implementer"
1189             );
1190             updatedIndex++;
1191         }
1192 
1193         currentIndex = updatedIndex;
1194         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1195     }
1196 
1197     /**
1198      * @dev Transfers `tokenId` from `from` to `to`.
1199      *
1200      * Requirements:
1201      *
1202      * - `to` cannot be the zero address.
1203      * - `tokenId` token must be owned by `from`.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function _transfer(
1208         address from,
1209         address to,
1210         uint256 tokenId
1211     ) private {
1212         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1213 
1214         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1215         getApproved(tokenId) == _msgSender() ||
1216         isApprovedForAll(prevOwnership.addr, _msgSender()));
1217 
1218         require(
1219             isApprovedOrOwner,
1220             "ERC721A: transfer caller is not owner nor approved"
1221         );
1222 
1223         require(
1224             prevOwnership.addr == from,
1225             "ERC721A: transfer from incorrect owner"
1226         );
1227         require(to != address(0), "ERC721A: transfer to the zero address");
1228 
1229         _beforeTokenTransfers(from, to, tokenId, 1);
1230 
1231         // Clear approvals from the previous owner
1232         _approve(address(0), tokenId, prevOwnership.addr);
1233 
1234         _addressData[from].balance -= 1;
1235         _addressData[to].balance += 1;
1236         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1237 
1238         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1239         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1240         uint256 nextTokenId = tokenId + 1;
1241         if (_ownerships[nextTokenId].addr == address(0)) {
1242             if (_exists(nextTokenId)) {
1243                 _ownerships[nextTokenId] = TokenOwnership(
1244                     prevOwnership.addr,
1245                     prevOwnership.startTimestamp
1246                 );
1247             }
1248         }
1249 
1250         emit Transfer(from, to, tokenId);
1251         _afterTokenTransfers(from, to, tokenId, 1);
1252     }
1253 
1254     /**
1255      * @dev Approve `to` to operate on `tokenId`
1256      *
1257      * Emits a {Approval} event.
1258      */
1259     function _approve(
1260         address to,
1261         uint256 tokenId,
1262         address owner
1263     ) private {
1264         _tokenApprovals[tokenId] = to;
1265         emit Approval(owner, to, tokenId);
1266     }
1267 
1268     uint256 public nextOwnerToExplicitlySet = 0;
1269 
1270     /**
1271      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1272      */
1273     function _setOwnersExplicit(uint256 quantity) internal {
1274         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1275         require(quantity > 0, "quantity must be nonzero");
1276         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1277         if (endIndex > collectionSize - 1) {
1278             endIndex = collectionSize - 1;
1279         }
1280         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1281         require(_exists(endIndex), "not enough minted yet for this cleanup");
1282         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1283             if (_ownerships[i].addr == address(0)) {
1284                 TokenOwnership memory ownership = ownershipOf(i);
1285                 _ownerships[i] = TokenOwnership(
1286                     ownership.addr,
1287                     ownership.startTimestamp
1288                 );
1289             }
1290         }
1291         nextOwnerToExplicitlySet = endIndex + 1;
1292     }
1293 
1294     /**
1295      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1296      * The call is not executed if the target address is not a contract.
1297      *
1298      * @param from address representing the previous owner of the given token ID
1299      * @param to target address that will receive the tokens
1300      * @param tokenId uint256 ID of the token to be transferred
1301      * @param _data bytes optional data to send along with the call
1302      * @return bool whether the call correctly returned the expected magic value
1303      */
1304     function _checkOnERC721Received(
1305         address from,
1306         address to,
1307         uint256 tokenId,
1308         bytes memory _data
1309     ) private returns (bool) {
1310         if (to.isContract()) {
1311             try
1312             IERC721Receiver(to).onERC721Received(
1313                 _msgSender(),
1314                 from,
1315                 tokenId,
1316                 _data
1317             )
1318             returns (bytes4 retval) {
1319                 return retval == IERC721Receiver(to).onERC721Received.selector;
1320             } catch (bytes memory reason) {
1321                 if (reason.length == 0) {
1322                     revert(
1323                         "ERC721A: transfer to non ERC721Receiver implementer"
1324                     );
1325                 } else {
1326                     assembly {
1327                         revert(add(32, reason), mload(reason))
1328                     }
1329                 }
1330             }
1331         } else {
1332             return true;
1333         }
1334     }
1335 
1336     /**
1337      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1338      *
1339      * startTokenId - the first token id to be transferred
1340      * quantity - the amount to be transferred
1341      *
1342      * Calling conditions:
1343      *
1344      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1345      * transferred to `to`.
1346      * - When `from` is zero, `tokenId` will be minted for `to`.
1347      */
1348     function _beforeTokenTransfers(
1349         address from,
1350         address to,
1351         uint256 startTokenId,
1352         uint256 quantity
1353     ) internal virtual {}
1354 
1355     /**
1356      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1357      * minting.
1358      *
1359      * startTokenId - the first token id to be transferred
1360      * quantity - the amount to be transferred
1361      *
1362      * Calling conditions:
1363      *
1364      * - when `from` and `to` are both non-zero.
1365      * - `from` and `to` are never both zero.
1366      */
1367     function _afterTokenTransfers(
1368         address from,
1369         address to,
1370         uint256 startTokenId,
1371         uint256 quantity
1372     ) internal virtual {}
1373 }
1374 
1375 contract RBP is ERC721A, Ownable, ReentrancyGuard {
1376     using ECDSA for bytes32;
1377 
1378 
1379     string public baseURI;
1380     uint256 public tokensReserved;
1381     uint256 public immutable maxMint;
1382     uint256 public immutable maxSupply;
1383     uint256 public immutable reserveAmount;
1384     uint256 public constant PRICE = 0.0999 * 10**18; // 0.0999 ETH
1385 
1386 
1387     event Minted(address minter, uint256 amount);
1388     event ReservedToken(address minter, address recipient, uint256 amount);
1389     event BaseURIChanged(string newBaseURI);
1390 
1391     constructor(
1392         string memory initBaseURI,
1393         uint256 _maxBatchSize,
1394         uint256 _collectionSize,
1395         uint256 _reserveAmount
1396     ) ERC721A("ROBBi Planet", "RBP", _maxBatchSize, _collectionSize) {
1397         baseURI = initBaseURI;
1398         maxMint = _maxBatchSize;
1399         maxSupply = _collectionSize;
1400         reserveAmount = _reserveAmount;
1401     }
1402 
1403 
1404     function _baseURI() internal view override returns (string memory) {
1405         return baseURI;
1406     }
1407 
1408     function reserve(address recipient, uint256 amount) external onlyOwner {
1409         require(recipient != address(0), "ROBBiSS: zero address");
1410         require(amount > 0, "ROBBiSS: invalid amount");
1411         require(
1412             totalSupply() + amount <= collectionSize,
1413             "ROBBiSS: max supply exceeded"
1414         );
1415         require(
1416             tokensReserved + amount <= reserveAmount,
1417             "ROBBiSS: max reserve amount exceeded"
1418         );
1419         require(
1420             amount <= maxBatchSize ,
1421             "ROBBiSS: can only mint <= maxBatchSize"
1422         );
1423 
1424         _safeMint(recipient, amount);
1425 
1426         tokensReserved += amount;
1427         emit ReservedToken(msg.sender, recipient, amount);
1428     }
1429 
1430     function mint() external payable {
1431         require(
1432             tx.origin == msg.sender,
1433             "ROBBiSS: contract is not allowed to mint."
1434         );
1435 
1436         require(
1437             totalSupply() + 1 + reserveAmount - tokensReserved <=
1438             collectionSize,
1439             "ROBBiSS: Max supply exceeded."
1440         );
1441 
1442         _safeMint(msg.sender, 1);
1443         refundIfOver(PRICE);
1444 
1445         emit Minted(msg.sender, 1);
1446     }
1447 
1448     function mintBatch(uint256 amount) external payable {
1449 
1450         require(
1451             tx.origin == msg.sender,
1452             "ROBBiSS: contract is not allowed to mint."
1453         );
1454 
1455         require(
1456             amount <= maxBatchSize ,
1457             "ROBBiSS: can only mint <= maxBatchSize"
1458         );
1459 
1460         require(
1461             totalSupply() + amount + reserveAmount - tokensReserved <=
1462             collectionSize,
1463             "ROBBiSS: Max supply exceeded."
1464         );
1465 
1466         _safeMint(msg.sender, amount);
1467         refundIfOver(PRICE * amount);
1468 
1469         emit Minted(msg.sender, amount);
1470     }
1471 
1472 
1473 
1474     function refundIfOver(uint256 price) private {
1475         require(msg.value >= price, "ROBBiSS: Need to send more ETH.");
1476         if (msg.value > price) {
1477             payable(msg.sender).transfer(msg.value - price);
1478         }
1479     }
1480 
1481     function withdraw() external nonReentrant onlyOwner {
1482 
1483         uint256 balance = address(this).balance;
1484 
1485         (bool success, ) = payable(0x0CCe9063088BAD07a7e4A934646F357608f4867b)
1486         .call{value: balance}("");
1487 
1488         require(success, "Transfer failed.");
1489     }
1490 
1491     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1492         baseURI = newBaseURI;
1493         emit BaseURIChanged(newBaseURI);
1494     }
1495 
1496     function setOwnersExplicit(uint256 quantity)
1497     external
1498     onlyOwner
1499     nonReentrant
1500     {
1501         _setOwnersExplicit(quantity);
1502     }
1503 
1504     function numberMinted(address owner) public view returns (uint256) {
1505         return _numberMinted(owner);
1506     }
1507 
1508     function getOwnershipData(uint256 tokenId)
1509     external
1510     view
1511     returns (TokenOwnership memory)
1512     {
1513         return ownershipOf(tokenId);
1514     }
1515 }