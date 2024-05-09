1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
26 
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(
35         address indexed from,
36         address indexed to,
37         uint256 indexed tokenId
38     );
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(
44         address indexed owner,
45         address indexed approved,
46         uint256 indexed tokenId
47     );
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(
53         address indexed owner,
54         address indexed operator,
55         bool approved
56     );
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 
92     /**
93      * @dev Transfers `tokenId` token from `from` to `to`.
94      *
95      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must be owned by `from`.
102      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId)
135         external
136         view
137         returns (address operator);
138 
139     /**
140      * @dev Approve or remove `operator` as an operator for the caller.
141      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
142      *
143      * Requirements:
144      *
145      * - The `operator` cannot be the caller.
146      *
147      * Emits an {ApprovalForAll} event.
148      */
149     function setApprovalForAll(address operator, bool _approved) external;
150 
151     /**
152      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
153      *
154      * See {setApprovalForAll}
155      */
156     function isApprovedForAll(address owner, address operator)
157         external
158         view
159         returns (bool);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId,
178         bytes calldata data
179     ) external;
180 }
181 
182 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
208 
209 /**
210  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
211  * @dev See https://eips.ethereum.org/EIPS/eip-721
212  */
213 interface IERC721Metadata is IERC721 {
214     /**
215      * @dev Returns the token collection name.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the token collection symbol.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
226      */
227     function tokenURI(uint256 tokenId) external view returns (string memory);
228 }
229 
230 contract Initializable {
231     bool inited = false;
232 
233     modifier initializer() {
234         require(!inited, "already inited");
235         _;
236         inited = true;
237     }
238 }
239 
240 contract EIP712Base is Initializable {
241     struct EIP712Domain {
242         string name;
243         string version;
244         address verifyingContract;
245         bytes32 salt;
246     }
247 
248     string public constant ERC712_VERSION = "1";
249 
250     bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
251         keccak256(
252             bytes(
253                 "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
254             )
255         );
256     bytes32 internal domainSeperator;
257 
258     function _initializeEIP712(string memory name) internal initializer {
259         _setDomainSeperator(name);
260     }
261 
262     function _setDomainSeperator(string memory name) internal {
263         domainSeperator = keccak256(
264             abi.encode(
265                 EIP712_DOMAIN_TYPEHASH,
266                 keccak256(bytes(name)),
267                 keccak256(bytes(ERC712_VERSION)),
268                 address(this),
269                 bytes32(getChainId())
270             )
271         );
272     }
273 
274     function getDomainSeperator() public view returns (bytes32) {
275         return domainSeperator;
276     }
277 
278     function getChainId() public view returns (uint256) {
279         uint256 id;
280         assembly {
281             id := chainid()
282         }
283         return id;
284     }
285 
286     function toTypedMessageHash(bytes32 messageHash)
287         internal
288         view
289         returns (bytes32)
290     {
291         return keccak256(abi.encode(getDomainSeperator(), messageHash));
292     }
293 }
294 
295 contract NativeMetaTransaction is EIP712Base {
296     bytes32 private constant META_TRANSACTION_TYPEHASH =
297         keccak256(
298             bytes(
299                 "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
300             )
301         );
302     event MetaTransactionExecuted(
303         address userAddress,
304         address payable relayerAddress,
305         bytes functionSignature
306     );
307     mapping(address => uint256) nonces;
308 
309     struct MetaTransaction {
310         uint256 nonce;
311         address from;
312         bytes functionSignature;
313     }
314 
315     function executeMetaTransaction(
316         address userAddress,
317         bytes memory functionSignature,
318         bytes32 sigR,
319         bytes32 sigS,
320         uint8 sigV
321     ) external payable returns (bytes memory) {
322         MetaTransaction memory metaTx = MetaTransaction({
323             nonce: nonces[userAddress],
324             from: userAddress,
325             functionSignature: functionSignature
326         });
327 
328         require(
329             verify(userAddress, metaTx, sigR, sigS, sigV),
330             "Signer and signature do not match"
331         );
332 
333         nonces[userAddress] += 1;
334 
335         emit MetaTransactionExecuted(
336             userAddress,
337             payable(msg.sender),
338             functionSignature
339         );
340 
341         (bool success, bytes memory returnData) = address(this).call(
342             abi.encodePacked(functionSignature, userAddress)
343         );
344         require(success, "Function call not successful");
345 
346         return returnData;
347     }
348 
349     function hashMetaTransaction(MetaTransaction memory metaTx)
350         internal
351         pure
352         returns (bytes32)
353     {
354         return
355             keccak256(
356                 abi.encode(
357                     META_TRANSACTION_TYPEHASH,
358                     metaTx.nonce,
359                     metaTx.from,
360                     keccak256(metaTx.functionSignature)
361                 )
362             );
363     }
364 
365     function getNonce(address user) public view returns (uint256 nonce) {
366         nonce = nonces[user];
367     }
368 
369     function verify(
370         address signer,
371         MetaTransaction memory metaTx,
372         bytes32 sigR,
373         bytes32 sigS,
374         uint8 sigV
375     ) internal view returns (bool) {
376         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
377         return
378             signer ==
379             ecrecover(
380                 toTypedMessageHash(hashMetaTransaction(metaTx)),
381                 sigV,
382                 sigR,
383                 sigS
384             );
385     }
386 }
387 
388 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
389 
390 /**
391  * @dev Collection of functions related to the address type
392  */
393 library Address {
394     /**
395      * @dev Returns true if `account` is a contract.
396      *
397      * [IMPORTANT]
398      * ====
399      * It is unsafe to assume that an address for which this function returns
400      * false is an externally-owned account (EOA) and not a contract.
401      *
402      * Among others, `isContract` will return false for the following
403      * types of addresses:
404      *
405      *  - an externally-owned account
406      *  - a contract in construction
407      *  - an address where a contract will be created
408      *  - an address where a contract lived, but was destroyed
409      * ====
410      *
411      * [IMPORTANT]
412      * ====
413      * You shouldn't rely on `isContract` to protect against flash loan attacks!
414      *
415      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
416      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
417      * constructor.
418      * ====
419      */
420     function isContract(address account) internal view returns (bool) {
421         // This method relies on extcodesize/address.code.length, which returns 0
422         // for contracts in construction, since the code is only stored at the end
423         // of the constructor execution.
424 
425         return account.code.length > 0;
426     }
427 
428     /**
429      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
430      * `recipient`, forwarding all available gas and reverting on errors.
431      *
432      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
433      * of certain opcodes, possibly making contracts go over the 2300 gas limit
434      * imposed by `transfer`, making them unable to receive funds via
435      * `transfer`. {sendValue} removes this limitation.
436      *
437      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
438      *
439      * IMPORTANT: because control is transferred to `recipient`, care must be
440      * taken to not create reentrancy vulnerabilities. Consider using
441      * {ReentrancyGuard} or the
442      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
443      */
444     function sendValue(address payable recipient, uint256 amount) internal {
445         require(
446             address(this).balance >= amount,
447             "Address: insufficient balance"
448         );
449 
450         (bool success, ) = recipient.call{value: amount}("");
451         require(
452             success,
453             "Address: unable to send value, recipient may have reverted"
454         );
455     }
456 
457     /**
458      * @dev Performs a Solidity function call using a low level `call`. A
459      * plain `call` is an unsafe replacement for a function call: use this
460      * function instead.
461      *
462      * If `target` reverts with a revert reason, it is bubbled up by this
463      * function (like regular Solidity function calls).
464      *
465      * Returns the raw returned data. To convert to the expected return value,
466      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
467      *
468      * Requirements:
469      *
470      * - `target` must be a contract.
471      * - calling `target` with `data` must not revert.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(address target, bytes memory data)
476         internal
477         returns (bytes memory)
478     {
479         return functionCall(target, data, "Address: low-level call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
484      * `errorMessage` as a fallback revert reason when `target` reverts.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         return functionCallWithValue(target, data, 0, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but also transferring `value` wei to `target`.
499      *
500      * Requirements:
501      *
502      * - the calling contract must have an ETH balance of at least `value`.
503      * - the called Solidity function must be `payable`.
504      *
505      * _Available since v3.1._
506      */
507     function functionCallWithValue(
508         address target,
509         bytes memory data,
510         uint256 value
511     ) internal returns (bytes memory) {
512         return
513             functionCallWithValue(
514                 target,
515                 data,
516                 value,
517                 "Address: low-level call with value failed"
518             );
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
523      * with `errorMessage` as a fallback revert reason when `target` reverts.
524      *
525      * _Available since v3.1._
526      */
527     function functionCallWithValue(
528         address target,
529         bytes memory data,
530         uint256 value,
531         string memory errorMessage
532     ) internal returns (bytes memory) {
533         require(
534             address(this).balance >= value,
535             "Address: insufficient balance for call"
536         );
537         require(isContract(target), "Address: call to non-contract");
538 
539         (bool success, bytes memory returndata) = target.call{value: value}(
540             data
541         );
542         return verifyCallResult(success, returndata, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but performing a static call.
548      *
549      * _Available since v3.3._
550      */
551     function functionStaticCall(address target, bytes memory data)
552         internal
553         view
554         returns (bytes memory)
555     {
556         return
557             functionStaticCall(
558                 target,
559                 data,
560                 "Address: low-level static call failed"
561             );
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a static call.
567      *
568      * _Available since v3.3._
569      */
570     function functionStaticCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal view returns (bytes memory) {
575         require(isContract(target), "Address: static call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.staticcall(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a delegate call.
584      *
585      * _Available since v3.4._
586      */
587     function functionDelegateCall(address target, bytes memory data)
588         internal
589         returns (bytes memory)
590     {
591         return
592             functionDelegateCall(
593                 target,
594                 data,
595                 "Address: low-level delegate call failed"
596             );
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
601      * but performing a delegate call.
602      *
603      * _Available since v3.4._
604      */
605     function functionDelegateCall(
606         address target,
607         bytes memory data,
608         string memory errorMessage
609     ) internal returns (bytes memory) {
610         require(isContract(target), "Address: delegate call to non-contract");
611 
612         (bool success, bytes memory returndata) = target.delegatecall(data);
613         return verifyCallResult(success, returndata, errorMessage);
614     }
615 
616     /**
617      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
618      * revert reason using the provided one.
619      *
620      * _Available since v4.3._
621      */
622     function verifyCallResult(
623         bool success,
624         bytes memory returndata,
625         string memory errorMessage
626     ) internal pure returns (bytes memory) {
627         if (success) {
628             return returndata;
629         } else {
630             // Look for revert reason and bubble it up if present
631             if (returndata.length > 0) {
632                 // The easiest way to bubble the revert reason is using memory via assembly
633 
634                 assembly {
635                     let returndata_size := mload(returndata)
636                     revert(add(32, returndata), returndata_size)
637                 }
638             } else {
639                 revert(errorMessage);
640             }
641         }
642     }
643 }
644 
645 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
646 
647 /**
648  * @dev String operations.
649  */
650 library Strings {
651     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
652 
653     /**
654      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
655      */
656     function toString(uint256 value) internal pure returns (string memory) {
657         // Inspired by OraclizeAPI's implementation - MIT licence
658         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
659 
660         if (value == 0) {
661             return "0";
662         }
663         uint256 temp = value;
664         uint256 digits;
665         while (temp != 0) {
666             digits++;
667             temp /= 10;
668         }
669         bytes memory buffer = new bytes(digits);
670         while (value != 0) {
671             digits -= 1;
672             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
673             value /= 10;
674         }
675         return string(buffer);
676     }
677 
678     /**
679      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
680      */
681     function toHexString(uint256 value) internal pure returns (string memory) {
682         if (value == 0) {
683             return "0x00";
684         }
685         uint256 temp = value;
686         uint256 length = 0;
687         while (temp != 0) {
688             length++;
689             temp >>= 8;
690         }
691         return toHexString(value, length);
692     }
693 
694     /**
695      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
696      */
697     function toHexString(uint256 value, uint256 length)
698         internal
699         pure
700         returns (string memory)
701     {
702         bytes memory buffer = new bytes(2 * length + 2);
703         buffer[0] = "0";
704         buffer[1] = "x";
705         for (uint256 i = 2 * length + 1; i > 1; --i) {
706             buffer[i] = _HEX_SYMBOLS[value & 0xf];
707             value >>= 4;
708         }
709         require(value == 0, "Strings: hex length insufficient");
710         return string(buffer);
711     }
712 }
713 
714 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
715 
716 /**
717  * @title Counters
718  * @author Matt Condon (@shrugs)
719  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
720  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
721  *
722  * Include with `using Counters for Counters.Counter;`
723  */
724 library Counters {
725     struct Counter {
726         // This variable should never be directly accessed by users of the library: interactions must be restricted to
727         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
728         // this feature: see https://github.com/ethereum/solidity/issues/4637
729         uint256 _value; // default: 0
730     }
731 
732     function current(Counter storage counter) internal view returns (uint256) {
733         return counter._value;
734     }
735 
736     function increment(Counter storage counter) internal {
737         unchecked {
738             counter._value += 1;
739         }
740     }
741 
742     function decrement(Counter storage counter) internal {
743         uint256 value = counter._value;
744         require(value > 0, "Counter: decrement overflow");
745         unchecked {
746             counter._value = value - 1;
747         }
748     }
749 
750     function reset(Counter storage counter) internal {
751         counter._value = 0;
752     }
753 }
754 
755 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
756 
757 /**
758  * @dev Implementation of the {IERC165} interface.
759  *
760  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
761  * for the additional interface id that will be supported. For example:
762  *
763  * ```solidity
764  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
765  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
766  * }
767  * ```
768  *
769  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
770  */
771 abstract contract ERC165 is IERC165 {
772     /**
773      * @dev See {IERC165-supportsInterface}.
774      */
775     function supportsInterface(bytes4 interfaceId)
776         public
777         view
778         virtual
779         override
780         returns (bool)
781     {
782         return interfaceId == type(IERC165).interfaceId;
783     }
784 }
785 
786 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
787 
788 /**
789  * @dev Provides information about the current execution context, including the
790  * sender of the transaction and its data. While these are generally available
791  * via msg.sender and msg.data, they should not be accessed in such a direct
792  * manner, since when dealing with meta-transactions the account sending and
793  * paying for execution may not be the actual sender (as far as an application
794  * is concerned).
795  *
796  * This contract is only required for intermediate, library-like contracts.
797  */
798 abstract contract Context {
799     function _msgSender() internal view virtual returns (address) {
800         return msg.sender;
801     }
802 
803     function _msgData() internal view virtual returns (bytes calldata) {
804         return msg.data;
805     }
806 }
807 
808 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
809 
810 /**
811  * @dev Contract module which provides a basic access control mechanism, where
812  * there is an account (an owner) that can be granted exclusive access to
813  * specific functions.
814  *
815  * By default, the owner account will be the one that deploys the contract. This
816  * can later be changed with {transferOwnership}.
817  *
818  * This module is used through inheritance. It will make available the modifier
819  * `onlyOwner`, which can be applied to your functions to restrict their use to
820  * the owner.
821  */
822 abstract contract Ownable is Context {
823     address private _owner;
824 
825     event OwnershipTransferred(
826         address indexed previousOwner,
827         address indexed newOwner
828     );
829 
830     /**
831      * @dev Initializes the contract setting the deployer as the initial owner.
832      */
833     constructor() {
834         _transferOwnership(_msgSender());
835     }
836 
837     /**
838      * @dev Returns the address of the current owner.
839      */
840     function owner() public view virtual returns (address) {
841         return _owner;
842     }
843 
844     /**
845      * @dev Throws if called by any account other than the owner.
846      */
847     modifier onlyOwner() {
848         require(owner() == _msgSender(), "Ownable: caller is not the owner");
849         _;
850     }
851 
852     /**
853      * @dev Leaves the contract without owner. It will not be possible to call
854      * `onlyOwner` functions anymore. Can only be called by the current owner.
855      *
856      * NOTE: Renouncing ownership will leave the contract without an owner,
857      * thereby removing any functionality that is only available to the owner.
858      */
859     function renounceOwnership() public virtual onlyOwner {
860         _transferOwnership(address(0));
861     }
862 
863     /**
864      * @dev Transfers ownership of the contract to a new account (`newOwner`).
865      * Can only be called by the current owner.
866      */
867     function transferOwnership(address newOwner) public virtual onlyOwner {
868         require(
869             newOwner != address(0),
870             "Ownable: new owner is the zero address"
871         );
872         _transferOwnership(newOwner);
873     }
874 
875     /**
876      * @dev Transfers ownership of the contract to a new account (`newOwner`).
877      * Internal function without access restriction.
878      */
879     function _transferOwnership(address newOwner) internal virtual {
880         address oldOwner = _owner;
881         _owner = newOwner;
882         emit OwnershipTransferred(oldOwner, newOwner);
883     }
884 }
885 
886 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
887 
888 /**
889  * @dev Contract module which allows children to implement an emergency stop
890  * mechanism that can be triggered by an authorized account.
891  *
892  * This module is used through inheritance. It will make available the
893  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
894  * the functions of your contract. Note that they will not be pausable by
895  * simply including this module, only once the modifiers are put in place.
896  */
897 abstract contract Pausable is Context {
898     /**
899      * @dev Emitted when the pause is triggered by `account`.
900      */
901     event Paused(address account);
902 
903     /**
904      * @dev Emitted when the pause is lifted by `account`.
905      */
906     event Unpaused(address account);
907 
908     bool private _paused;
909 
910     /**
911      * @dev Initializes the contract in unpaused state.
912      */
913     constructor() {
914         _paused = false;
915     }
916 
917     /**
918      * @dev Returns true if the contract is paused, and false otherwise.
919      */
920     function paused() public view virtual returns (bool) {
921         return _paused;
922     }
923 
924     /**
925      * @dev Modifier to make a function callable only when the contract is not paused.
926      *
927      * Requirements:
928      *
929      * - The contract must not be paused.
930      */
931     modifier whenNotPaused() {
932         require(!paused(), "Pausable: paused");
933         _;
934     }
935 
936     /**
937      * @dev Modifier to make a function callable only when the contract is paused.
938      *
939      * Requirements:
940      *
941      * - The contract must be paused.
942      */
943     modifier whenPaused() {
944         require(paused(), "Pausable: not paused");
945         _;
946     }
947 
948     /**
949      * @dev Triggers stopped state.
950      *
951      * Requirements:
952      *
953      * - The contract must not be paused.
954      */
955     function _pause() internal virtual whenNotPaused {
956         _paused = true;
957         emit Paused(_msgSender());
958     }
959 
960     /**
961      * @dev Returns to normal state.
962      *
963      * Requirements:
964      *
965      * - The contract must be paused.
966      */
967     function _unpause() internal virtual whenPaused {
968         _paused = false;
969         emit Unpaused(_msgSender());
970     }
971 }
972 
973 abstract contract ContextMixin {
974     function msgSender() internal view returns (address payable sender) {
975         if (msg.sender == address(this)) {
976             bytes memory array = msg.data;
977             uint256 index = msg.data.length;
978             assembly {
979                 sender := and(
980                     mload(add(array, index)),
981                     0xffffffffffffffffffffffffffffffffffffffff
982                 )
983             }
984         } else {
985             sender = payable(msg.sender);
986         }
987         return sender;
988     }
989 }
990 
991 abstract contract ProxyRegistry {
992     mapping(address => address) public proxies;
993 }
994 
995 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
996 
997 // CAUTION
998 // This version of SafeMath should only be used with Solidity 0.8 or later,
999 // because it relies on the compiler's built in overflow checks.
1000 
1001 /**
1002  * @dev Wrappers over Solidity's arithmetic operations.
1003  *
1004  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1005  * now has built in overflow checking.
1006  */
1007 library SafeMath {
1008     /**
1009      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1010      *
1011      * _Available since v3.4._
1012      */
1013     function tryAdd(uint256 a, uint256 b)
1014         internal
1015         pure
1016         returns (bool, uint256)
1017     {
1018         unchecked {
1019             uint256 c = a + b;
1020             if (c < a) return (false, 0);
1021             return (true, c);
1022         }
1023     }
1024 
1025     /**
1026      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1027      *
1028      * _Available since v3.4._
1029      */
1030     function trySub(uint256 a, uint256 b)
1031         internal
1032         pure
1033         returns (bool, uint256)
1034     {
1035         unchecked {
1036             if (b > a) return (false, 0);
1037             return (true, a - b);
1038         }
1039     }
1040 
1041     /**
1042      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1043      *
1044      * _Available since v3.4._
1045      */
1046     function tryMul(uint256 a, uint256 b)
1047         internal
1048         pure
1049         returns (bool, uint256)
1050     {
1051         unchecked {
1052             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1053             // benefit is lost if 'b' is also tested.
1054             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1055             if (a == 0) return (true, 0);
1056             uint256 c = a * b;
1057             if (c / a != b) return (false, 0);
1058             return (true, c);
1059         }
1060     }
1061 
1062     /**
1063      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1064      *
1065      * _Available since v3.4._
1066      */
1067     function tryDiv(uint256 a, uint256 b)
1068         internal
1069         pure
1070         returns (bool, uint256)
1071     {
1072         unchecked {
1073             if (b == 0) return (false, 0);
1074             return (true, a / b);
1075         }
1076     }
1077 
1078     /**
1079      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1080      *
1081      * _Available since v3.4._
1082      */
1083     function tryMod(uint256 a, uint256 b)
1084         internal
1085         pure
1086         returns (bool, uint256)
1087     {
1088         unchecked {
1089             if (b == 0) return (false, 0);
1090             return (true, a % b);
1091         }
1092     }
1093 
1094     /**
1095      * @dev Returns the addition of two unsigned integers, reverting on
1096      * overflow.
1097      *
1098      * Counterpart to Solidity's `+` operator.
1099      *
1100      * Requirements:
1101      *
1102      * - Addition cannot overflow.
1103      */
1104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1105         return a + b;
1106     }
1107 
1108     /**
1109      * @dev Returns the subtraction of two unsigned integers, reverting on
1110      * overflow (when the result is negative).
1111      *
1112      * Counterpart to Solidity's `-` operator.
1113      *
1114      * Requirements:
1115      *
1116      * - Subtraction cannot overflow.
1117      */
1118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1119         return a - b;
1120     }
1121 
1122     /**
1123      * @dev Returns the multiplication of two unsigned integers, reverting on
1124      * overflow.
1125      *
1126      * Counterpart to Solidity's `*` operator.
1127      *
1128      * Requirements:
1129      *
1130      * - Multiplication cannot overflow.
1131      */
1132     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1133         return a * b;
1134     }
1135 
1136     /**
1137      * @dev Returns the integer division of two unsigned integers, reverting on
1138      * division by zero. The result is rounded towards zero.
1139      *
1140      * Counterpart to Solidity's `/` operator.
1141      *
1142      * Requirements:
1143      *
1144      * - The divisor cannot be zero.
1145      */
1146     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1147         return a / b;
1148     }
1149 
1150     /**
1151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1152      * reverting when dividing by zero.
1153      *
1154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1155      * opcode (which leaves remaining gas untouched) while Solidity uses an
1156      * invalid opcode to revert (consuming all remaining gas).
1157      *
1158      * Requirements:
1159      *
1160      * - The divisor cannot be zero.
1161      */
1162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1163         return a % b;
1164     }
1165 
1166     /**
1167      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1168      * overflow (when the result is negative).
1169      *
1170      * CAUTION: This function is deprecated because it requires allocating memory for the error
1171      * message unnecessarily. For custom revert reasons use {trySub}.
1172      *
1173      * Counterpart to Solidity's `-` operator.
1174      *
1175      * Requirements:
1176      *
1177      * - Subtraction cannot overflow.
1178      */
1179     function sub(
1180         uint256 a,
1181         uint256 b,
1182         string memory errorMessage
1183     ) internal pure returns (uint256) {
1184         unchecked {
1185             require(b <= a, errorMessage);
1186             return a - b;
1187         }
1188     }
1189 
1190     /**
1191      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1192      * division by zero. The result is rounded towards zero.
1193      *
1194      * Counterpart to Solidity's `/` operator. Note: this function uses a
1195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1196      * uses an invalid opcode to revert (consuming all remaining gas).
1197      *
1198      * Requirements:
1199      *
1200      * - The divisor cannot be zero.
1201      */
1202     function div(
1203         uint256 a,
1204         uint256 b,
1205         string memory errorMessage
1206     ) internal pure returns (uint256) {
1207         unchecked {
1208             require(b > 0, errorMessage);
1209             return a / b;
1210         }
1211     }
1212 
1213     /**
1214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1215      * reverting with custom message when dividing by zero.
1216      *
1217      * CAUTION: This function is deprecated because it requires allocating memory for the error
1218      * message unnecessarily. For custom revert reasons use {tryMod}.
1219      *
1220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1221      * opcode (which leaves remaining gas untouched) while Solidity uses an
1222      * invalid opcode to revert (consuming all remaining gas).
1223      *
1224      * Requirements:
1225      *
1226      * - The divisor cannot be zero.
1227      */
1228     function mod(
1229         uint256 a,
1230         uint256 b,
1231         string memory errorMessage
1232     ) internal pure returns (uint256) {
1233         unchecked {
1234             require(b > 0, errorMessage);
1235             return a % b;
1236         }
1237     }
1238 }
1239 
1240 /**
1241  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1242  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1243  * {ERC721Enumerable}.
1244  */
1245 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1246     using Address for address;
1247     using Strings for uint256;
1248 
1249     // Token name
1250     string private _name;
1251 
1252     // Token symbol
1253     string private _symbol;
1254 
1255     // Mapping from token ID to owner address
1256     mapping(uint256 => address) private _owners;
1257 
1258     // Mapping owner address to token count
1259     mapping(address => uint256) private _balances;
1260 
1261     // Mapping from token ID to approved address
1262     mapping(uint256 => address) private _tokenApprovals;
1263 
1264     // Mapping from owner to operator approvals
1265     mapping(address => mapping(address => bool)) private _operatorApprovals;
1266 
1267     constructor(string memory name_, string memory symbol_) {
1268         _name = name_;
1269         _symbol = symbol_;
1270     }
1271 
1272     function supportsInterface(bytes4 interfaceId)
1273         public
1274         view
1275         virtual
1276         override(ERC165, IERC165)
1277         returns (bool)
1278     {
1279         return
1280             interfaceId == type(IERC721).interfaceId ||
1281             interfaceId == type(IERC721Metadata).interfaceId ||
1282             super.supportsInterface(interfaceId);
1283     }
1284 
1285     function balanceOf(address owner)
1286         public
1287         view
1288         virtual
1289         override
1290         returns (uint256)
1291     {
1292         require(
1293             owner != address(0),
1294             "ERC721: balance query for the zero address"
1295         );
1296         return _balances[owner];
1297     }
1298 
1299     function ownerOf(uint256 tokenId)
1300         public
1301         view
1302         virtual
1303         override
1304         returns (address)
1305     {
1306         address owner = _owners[tokenId];
1307         require(
1308             owner != address(0),
1309             "ERC721: owner query for nonexistent token"
1310         );
1311         return owner;
1312     }
1313 
1314     function name() public view virtual override returns (string memory) {
1315         return _name;
1316     }
1317 
1318     function symbol() public view virtual override returns (string memory) {
1319         return _symbol;
1320     }
1321 
1322     function tokenURI(uint256 tokenId)
1323         public
1324         view
1325         virtual
1326         override
1327         returns (string memory)
1328     {
1329         require(
1330             _exists(tokenId),
1331             "ERC721Metadata: URI query for nonexistent token"
1332         );
1333 
1334         string memory baseURI = _baseURI();
1335         return
1336             bytes(baseURI).length > 0
1337                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1338                 : "";
1339     }
1340 
1341     function _baseURI() internal view virtual returns (string memory) {
1342         return "";
1343     }
1344 
1345     function approve(address to, uint256 tokenId) public virtual override {
1346         address owner = ERC721.ownerOf(tokenId);
1347         require(to != owner, "ERC721: approval to current owner");
1348 
1349         require(
1350             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1351             "ERC721: approve caller is not owner nor approved for all"
1352         );
1353 
1354         _approve(to, tokenId);
1355     }
1356 
1357     function getApproved(uint256 tokenId)
1358         public
1359         view
1360         virtual
1361         override
1362         returns (address)
1363     {
1364         require(
1365             _exists(tokenId),
1366             "ERC721: approved query for nonexistent token"
1367         );
1368 
1369         return _tokenApprovals[tokenId];
1370     }
1371 
1372     function setApprovalForAll(address operator, bool approved)
1373         public
1374         virtual
1375         override
1376     {
1377         require(operator != _msgSender(), "ERC721: approve to caller");
1378 
1379         _operatorApprovals[_msgSender()][operator] = approved;
1380         emit ApprovalForAll(_msgSender(), operator, approved);
1381     }
1382 
1383     function isApprovedForAll(address owner, address operator)
1384         public
1385         view
1386         virtual
1387         override
1388         returns (bool)
1389     {
1390         return _operatorApprovals[owner][operator];
1391     }
1392 
1393     function transferFrom(
1394         address from,
1395         address to,
1396         uint256 tokenId
1397     ) public virtual override {}
1398 
1399     function safeTransferFrom(
1400         address from,
1401         address to,
1402         uint256 tokenId
1403     ) public virtual override {}
1404 
1405     function safeTransferFrom(
1406         address from,
1407         address to,
1408         uint256 tokenId,
1409         bytes memory _data
1410     ) public virtual override {}
1411 
1412     /**
1413      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1414      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1415      *
1416      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1417      *
1418      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1419      * implement alternative mechanisms to perform token transfer, such as signature-based.
1420      *
1421      * Requirements:
1422      *
1423      * - `from` cannot be the zero address.
1424      * - `to` cannot be the zero address.
1425      * - `tokenId` token must exist and be owned by `from`.
1426      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1427      *
1428      * Emits a {Transfer} event.
1429      */
1430     function _safeTransfer(
1431         address from,
1432         address to,
1433         uint256 tokenId,
1434         bytes memory _data
1435     ) internal virtual {
1436         _transfer(from, to, tokenId);
1437         require(
1438             _checkOnERC721Received(from, to, tokenId, _data),
1439             "ERC721: transfer to non ERC721Receiver implementer"
1440         );
1441     }
1442 
1443     /**
1444      * @dev Returns whether `tokenId` exists.
1445      *
1446      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1447      *
1448      * Tokens start existing when they are minted (`_mint`),
1449      * and stop existing when they are burned (`_burn`).
1450      */
1451     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1452         return _owners[tokenId] != address(0);
1453     }
1454 
1455     /**
1456      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1457      *
1458      * Requirements:
1459      *
1460      * - `tokenId` must exist.
1461      */
1462     function _isApprovedOrOwner(address spender, uint256 tokenId)
1463         internal
1464         view
1465         virtual
1466         returns (bool)
1467     {
1468         require(
1469             _exists(tokenId),
1470             "ERC721: operator query for nonexistent token"
1471         );
1472         address owner = ERC721.ownerOf(tokenId);
1473         return (spender == owner ||
1474             getApproved(tokenId) == spender ||
1475             isApprovedForAll(owner, spender));
1476     }
1477 
1478     /**
1479      * @dev Safely mints `tokenId` and transfers it to `to`.
1480      *
1481      * Requirements:
1482      *
1483      * - `tokenId` must not exist.
1484      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1485      *
1486      * Emits a {Transfer} event.
1487      */
1488     function _safeMint(address to, uint256 tokenId) internal virtual {
1489         _safeMint(to, tokenId, "");
1490     }
1491 
1492     /**
1493      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1494      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1495      */
1496     function _safeMint(
1497         address to,
1498         uint256 tokenId,
1499         bytes memory _data
1500     ) internal virtual {
1501         _mint(to, tokenId);
1502         require(
1503             _checkOnERC721Received(address(0), to, tokenId, _data),
1504             "ERC721: transfer to non ERC721Receiver implementer"
1505         );
1506     }
1507 
1508     /**
1509      * @dev Mints `tokenId` and transfers it to `to`.
1510      *
1511      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1512      *
1513      * Requirements:
1514      *
1515      * - `tokenId` must not exist.
1516      * - `to` cannot be the zero address.
1517      *
1518      * Emits a {Transfer} event.
1519      */
1520     function _mint(address to, uint256 tokenId) internal virtual {
1521         require(to != address(0), "ERC721: mint to the zero address");
1522         require(!_exists(tokenId), "ERC721: token already minted");
1523 
1524         _beforeTokenTransfer(address(0), to, tokenId);
1525 
1526         _balances[to] += 1;
1527         _owners[tokenId] = to;
1528 
1529         emit Transfer(address(0), to, tokenId);
1530     }
1531 
1532     /**
1533      * @dev Destroys `tokenId`.
1534      * The approval is cleared when the token is burned.
1535      *
1536      * Requirements:
1537      *
1538      * - `tokenId` must exist.
1539      *
1540      * Emits a {Transfer} event.
1541      */
1542     function _burn(uint256 tokenId) internal virtual {
1543         address owner = ERC721.ownerOf(tokenId);
1544 
1545         _beforeTokenTransfer(owner, address(0), tokenId);
1546 
1547         // Clear approvals
1548         _approve(address(0), tokenId);
1549 
1550         _balances[owner] -= 1;
1551         delete _owners[tokenId];
1552 
1553         emit Transfer(owner, address(0), tokenId);
1554     }
1555 
1556     /**
1557      * @dev Transfers `tokenId` from `from` to `to`.
1558      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1559      *
1560      * Requirements:
1561      *
1562      * - `to` cannot be the zero address.
1563      * - `tokenId` token must be owned by `from`.
1564      *
1565      * Emits a {Transfer} event.
1566      */
1567     function _transfer(
1568         address from,
1569         address to,
1570         uint256 tokenId
1571     ) internal virtual {
1572         require(
1573             ERC721.ownerOf(tokenId) == from,
1574             "ERC721: transfer of token that is not own"
1575         );
1576         require(to != address(0), "ERC721: transfer to the zero address");
1577 
1578         _beforeTokenTransfer(from, to, tokenId);
1579 
1580         // Clear approvals from the previous owner
1581         _approve(address(0), tokenId);
1582 
1583         _balances[from] -= 1;
1584         _balances[to] += 1;
1585         _owners[tokenId] = to;
1586 
1587         emit Transfer(from, to, tokenId);
1588     }
1589 
1590     /**
1591      * @dev Approve `to` to operate on `tokenId`
1592      *
1593      * Emits a {Approval} event.
1594      */
1595     function _approve(address to, uint256 tokenId) internal virtual {
1596         _tokenApprovals[tokenId] = to;
1597         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1598     }
1599 
1600     /**
1601      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1602      * The call is not executed if the target address is not a contract.
1603      *
1604      * @param from address representing the previous owner of the given token ID
1605      * @param to target address that will receive the tokens
1606      * @param tokenId uint256 ID of the token to be transferred
1607      * @param _data bytes optional data to send along with the call
1608      * @return bool whether the call correctly returned the expected magic value
1609      */
1610     function _checkOnERC721Received(
1611         address from,
1612         address to,
1613         uint256 tokenId,
1614         bytes memory _data
1615     ) private returns (bool) {
1616         if (to.isContract()) {
1617             try
1618                 IERC721Receiver(to).onERC721Received(
1619                     _msgSender(),
1620                     from,
1621                     tokenId,
1622                     _data
1623                 )
1624             returns (bytes4 retval) {
1625                 return retval == IERC721Receiver.onERC721Received.selector;
1626             } catch (bytes memory reason) {
1627                 if (reason.length == 0) {
1628                     revert(
1629                         "ERC721: transfer to non ERC721Receiver implementer"
1630                     );
1631                 } else {
1632                     assembly {
1633                         revert(add(32, reason), mload(reason))
1634                     }
1635                 }
1636             }
1637         } else {
1638             return true;
1639         }
1640     }
1641 
1642     /**
1643      * @dev Hook that is called before any token transfer. This includes minting
1644      * and burning.
1645      *
1646      * Calling conditions:
1647      *
1648      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1649      * transferred to `to`.
1650      * - When `from` is zero, `tokenId` will be minted for `to`.
1651      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1652      * - `from` and `to` are never both zero.
1653      *
1654      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1655      */
1656     function _beforeTokenTransfer(
1657         address from,
1658         address to,
1659         uint256 tokenId
1660     ) internal virtual {}
1661 }
1662 
1663 pragma solidity ^0.8.0;
1664 
1665 /**
1666  * @dev Contract module that helps prevent reentrant calls to a function.
1667  *
1668  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1669  * available, which can be applied to functions to make sure there are no nested
1670  * (reentrant) calls to them.
1671  *
1672  * Note that because there is a single `nonReentrant` guard, functions marked as
1673  * `nonReentrant` may not call one another. This can be worked around by making
1674  * those functions `private`, and then adding `external` `nonReentrant` entry
1675  * points to them.
1676  *
1677  * TIP: If you would like to learn more about reentrancy and alternative ways
1678  * to protect against it, check out our blog post
1679  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1680  */
1681 abstract contract ReentrancyGuard {
1682     // Booleans are more expensive than uint256 or any type that takes up a full
1683     // word because each write operation emits an extra SLOAD to first read the
1684     // slot's contents, replace the bits taken up by the boolean, and then write
1685     // back. This is the compiler's defense against contract upgrades and
1686     // pointer aliasing, and it cannot be disabled.
1687 
1688     // The values being non-zero value makes deployment a bit more expensive,
1689     // but in exchange the refund on every call to nonReentrant will be lower in
1690     // amount. Since refunds are capped to a percentage of the total
1691     // transaction's gas, it is best to keep them low in cases like this one, to
1692     // increase the likelihood of the full refund coming into effect.
1693     uint256 private constant _NOT_ENTERED = 1;
1694     uint256 private constant _ENTERED = 2;
1695 
1696     uint256 private _status;
1697 
1698     constructor() {
1699         _status = _NOT_ENTERED;
1700     }
1701 
1702     /**
1703      * @dev Prevents a contract from calling itself, directly or indirectly.
1704      * Calling a `nonReentrant` function from another `nonReentrant`
1705      * function is not supported. It is possible to prevent this from happening
1706      * by making the `nonReentrant` function external, and making it call a
1707      * `private` function that does the actual work.
1708      */
1709     modifier nonReentrant() {
1710         // On the first call to nonReentrant, _notEntered will be true
1711         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1712 
1713         // Any calls to nonReentrant after this point will fail
1714         _status = _ENTERED;
1715 
1716         _;
1717 
1718         // By storing the original value once again, a refund is triggered (see
1719         // https://eips.ethereum.org/EIPS/eip-2200)
1720         _status = _NOT_ENTERED;
1721     }
1722 }
1723 
1724 /**
1725  * @title ERC721Tradable
1726  * ERC721Tradable - ERC721 contract that whitelists a trading address, and has minting functionality.
1727  */
1728 abstract contract ERC721Tradable is
1729     ERC721,
1730     ContextMixin,
1731     Pausable,
1732     NativeMetaTransaction,
1733     Ownable
1734 {
1735     using Address for address;
1736     using SafeMath for uint256;
1737     using Counters for Counters.Counter;
1738 
1739     // tokendcount
1740     Counters.Counter private _nextTokenId;
1741 
1742     address public proxyRegistryAddress;
1743 
1744     mapping(address => uint256) private _balances;
1745 
1746     mapping(uint256 => address) private _owners;
1747     mapping(uint256 => address) private _tokenApprovals;
1748 
1749     constructor(string memory _name, string memory _symbol)
1750         ERC721(_name, _symbol)
1751     {
1752         proxyRegistryAddress = _msgSender();
1753         _nextTokenId.increment();
1754         _initializeEIP712(_name);
1755     }
1756 
1757     modifier onlyOwnerOrProxy() {
1758         require(
1759             _isOwnerOrProxy(_msgSender()),
1760             "ERC721Tradable#onlyOwner: CALLER_IS_NOT_OWNER"
1761         );
1762         _;
1763     }
1764 
1765     modifier onlyApproved(address _from) {
1766         require(
1767             _from == _msgSender() || isApprovedForAll(_from, _msgSender()),
1768             "ERC721Tradable#onlyApproved: CALLER_NOT_ALLOWED"
1769         );
1770         _;
1771     }
1772 
1773     /**
1774      * @dev See {IERC721-approve}.
1775      */
1776     function approve(address to, uint256 tokenId) public virtual override {
1777         address owner = ownerOf(tokenId);
1778         require(to != owner, "ERC721: approval to current owner");
1779 
1780         require(
1781             _msgSender() == owner,
1782             "ERC721: approve caller is not owner nor approved for all"
1783         );
1784         _tokenApprovals[tokenId] = to;
1785         emit Approval(owner, to, tokenId);
1786     }
1787 
1788     function getApproved(uint256 tokenId)
1789         public
1790         view
1791         virtual
1792         override
1793         returns (address)
1794     {
1795         require(
1796             _exists(tokenId),
1797             "ERC721: approved query for nonexistent token"
1798         );
1799 
1800         return _tokenApprovals[tokenId];
1801     }
1802 
1803     function pause() external onlyOwnerOrProxy {
1804         _pause();
1805     }
1806 
1807     function unpause() external onlyOwnerOrProxy {
1808         _unpause();
1809     }
1810 
1811     function balanceOf(address owner)
1812         public
1813         view
1814         virtual
1815         override
1816         returns (uint256)
1817     {
1818         require(
1819             owner != address(0),
1820             "ERC721: balance query for the zero address"
1821         );
1822         return _balances[owner];
1823     }
1824 
1825     function ownerOf(uint256 tokenId)
1826         public
1827         view
1828         virtual
1829         override
1830         returns (address)
1831     {
1832         address owner = _owners[tokenId];
1833         require(
1834             owner != address(0),
1835             "ERC721: owner query for nonexistent token"
1836         );
1837         return owner;
1838     }
1839 
1840     function exists(uint256 tokenId) public view returns (bool) {
1841         return _owners[tokenId] != address(0);
1842     }
1843 
1844     function totalSupply() public view returns (uint256) {
1845         return _nextTokenId.current() - 1;
1846     }
1847 
1848     function safeTransferFrom(
1849         address from,
1850         address to,
1851         uint256 tokenId,
1852         bytes memory _data
1853     ) public virtual override whenNotPaused {
1854         require(
1855             _isOwnerOrProxy(_msgSender()) ||
1856                 ownerOf(tokenId) == from ||
1857                 isApprovedForAll(ownerOf(tokenId), _msgSender()),
1858             "ERC721: transfer of token that is not own or Proxy"
1859         );
1860         require(to != address(0), "ERC721: transfer to the zero address");
1861         if (from != ownerOf(tokenId)) {
1862             from = ownerOf(tokenId);
1863         }
1864         _beforeTokenTransfer(from, to, tokenId);
1865 
1866         _tokenApprovals[tokenId] = address(0);
1867         _balances[from] -= 1;
1868         _balances[to] += 1;
1869         _owners[tokenId] = to;
1870         require(
1871             checkOnERC721Received(from, to, tokenId, _data),
1872             "ERC721: transfer to non ERC721Receiver implementer"
1873         );
1874 
1875         emit Transfer(from, to, tokenId);
1876     }
1877 
1878     function mintTo(address _to, bytes memory _data) internal whenNotPaused {
1879         uint256 currentTokenId = _nextTokenId.current();
1880         _nextTokenId.increment();
1881 
1882         require(!_exists(currentTokenId), "ERC721: token already minted");
1883 
1884         _beforeTokenTransfer(address(0), _to, currentTokenId);
1885 
1886         _balances[_to] += 1;
1887         _owners[currentTokenId] = _to;
1888         require(
1889             checkOnERC721Received(address(0), _to, currentTokenId, _data),
1890             "ERC721: transfer to non ERC721Receiver implementer"
1891         );
1892         emit Transfer(address(0), _to, currentTokenId);
1893     }
1894 
1895     function burn(uint256 tokenId) internal whenNotPaused {
1896         address owner = ownerOf(tokenId);
1897         _beforeTokenTransfer(owner, address(0), tokenId);
1898         _balances[owner] -= 1;
1899         delete _owners[tokenId];
1900         emit Transfer(owner, address(0), tokenId);
1901     }
1902 
1903     function checkOnERC721Received(
1904         address from,
1905         address to,
1906         uint256 tokenId,
1907         bytes memory _data
1908     ) internal returns (bool) {
1909         if (to.isContract()) {
1910             try
1911                 IERC721Receiver(to).onERC721Received(
1912                     _msgSender(),
1913                     from,
1914                     tokenId,
1915                     _data
1916                 )
1917             returns (bytes4 retval) {
1918                 return retval == IERC721Receiver.onERC721Received.selector;
1919             } catch (bytes memory reason) {
1920                 if (reason.length == 0) {
1921                     revert(
1922                         "ERC721: transfer to non ERC721Receiver implementer"
1923                     );
1924                 } else {
1925                     assembly {
1926                         revert(add(32, reason), mload(reason))
1927                     }
1928                 }
1929             }
1930         } else {
1931             return true;
1932         }
1933     }
1934 
1935     function _isOwnerOrProxy(address operator) internal view returns (bool) {
1936         return owner() == operator || _isProxyForUser(owner(), operator);
1937     }
1938 
1939     function _isProxyForUser(address owner, address operator)
1940         internal
1941         view
1942         returns (bool)
1943     {
1944         if (!proxyRegistryAddress.isContract()) {
1945             return false;
1946         }
1947         return
1948             address(ProxyRegistry(proxyRegistryAddress).proxies(owner)) ==
1949             operator;
1950     }
1951 
1952     function baseTokenURI() public view virtual returns (string memory);
1953 
1954     function tokenURI(uint256 _tokenId)
1955         public
1956         view
1957         virtual
1958         override
1959         returns (string memory)
1960     {
1961         return
1962             string(
1963                 abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId))
1964             );
1965     }
1966 
1967     function _msgSender() internal view override returns (address sender) {
1968         return ContextMixin.msgSender();
1969     }
1970 
1971     function _exists(uint256 tokenId)
1972         internal
1973         view
1974         virtual
1975         override
1976         returns (bool)
1977     {
1978         return _owners[tokenId] != address(0);
1979     }
1980 }
1981 
1982 contract AssetContract is ERC721Tradable, ReentrancyGuard {
1983     using SafeMath for uint256;
1984     using Strings for uint256;
1985     event PermanentURI(string _value, uint256 indexed _id);
1986 
1987     string public templateURI;
1988 
1989     uint256 public PRODUCE_TOKEN_MAX = 1;
1990 
1991     address public mineAcceptAddr;
1992 
1993     address public mintAddr;
1994 
1995     mapping(string => uint256[]) private _tokenSell;
1996 
1997     mapping(string => uint256) private tokenPrice;
1998 
1999     mapping(uint256 => string) private _idTokenType;
2000 
2001     mapping(string => uint256) private _tokenTypeProduce;
2002 
2003     mapping(uint256 => string) private _tokenURI;
2004 
2005     mapping(uint256 => bool) private _isPermanentURI;
2006 
2007     constructor(
2008         string memory _name,
2009         string memory _symbol,
2010         uint256 _tokenPrice,
2011         string memory _tokentype,
2012         string memory _templateURI,
2013         address _mintAddr
2014     ) ERC721Tradable(_name, _symbol) {
2015         if (bytes(_templateURI).length > 0) {
2016             setTemplateURI(_templateURI);
2017         }
2018         mintAddr = _mintAddr;
2019         mineAcceptAddr = _msgSender();
2020         putSell(_tokentype, PRODUCE_TOKEN_MAX, _tokenPrice);
2021     }
2022 
2023     modifier onlyOwnerOrThis() {
2024         require(
2025             owner() == _msgSender() || address(this) == _msgSender(),
2026             "Ownable: caller is not the owner"
2027         );
2028         _;
2029     }
2030 
2031     function functionCall(
2032         address target,
2033         bytes memory data,
2034         uint256 value
2035     ) public payable onlyOwnerOrProxy returns (bytes memory) {
2036         return Address.functionCallWithValue(target, data, value);
2037     }
2038 
2039     function changeAcceptAddr(address acceptAddr) public onlyOwnerOrProxy {
2040         mineAcceptAddr = acceptAddr;
2041     }
2042 
2043     function setTemplateURI(string memory _uri) public onlyOwnerOrProxy {
2044         templateURI = _uri;
2045     }
2046 
2047     function tokenPriceOf(string memory _tokenType)
2048         public
2049         view
2050         returns (uint256)
2051     {
2052         return tokenPrice[_tokenType];
2053     }
2054 
2055     function balanceOf(address _owner) public view override returns (uint256) {
2056         return
2057             _isOwnerOrProxy(_owner)
2058                 ? super.totalSupply()
2059                 : super.balanceOf(_owner);
2060     }
2061 
2062     function ownerOf(uint256 tokenId) public view override returns (address) {
2063         return super.ownerOf(tokenId);
2064     }
2065 
2066     modifier onlyTokenAmountOwned(address _from, uint256 _id) {
2067         require(
2068             _ownsTokenAmount(_from, _id),
2069             "AssetContract#onlyTokenAmountOwned: ONLY_TOKEN_AMOUNT_OWNED_ALLOWED"
2070         );
2071         _;
2072     }
2073 
2074     function transferFrom(
2075         address from,
2076         address to,
2077         uint256 tokenId
2078     ) public virtual override {
2079         safeTransferFrom(from, to, tokenId, "");
2080     }
2081 
2082     function safeTransferFrom(
2083         address _from,
2084         address _to,
2085         uint256 _id
2086     ) public virtual override {
2087         safeTransferFrom(_from, _to, _id, "");
2088     }
2089 
2090     function safeTransferFrom(
2091         address _from,
2092         address _to,
2093         uint256 _id,
2094         bytes memory _data
2095     ) public virtual override {
2096         require(
2097             _ownsTokenAmount(_msgSender(), _id),
2098             "AssetContract#onlyTokenAmountOwned: ONLY_TOKEN_AMOUNT_OWNED_ALLOWED"
2099         );
2100         if (_isOwnerOrProxy(_msgSender())) {
2101             _from = ownerOf(_id);
2102         }
2103         require(_from != _to, "AssetContract#ownerOfToken: from equal to addr");
2104         super.safeTransferFrom(_from, _to, _id, _data);
2105     }
2106 
2107     function tokenSell(string memory _tokenType, uint256 index)
2108         public
2109         view
2110         returns (uint256)
2111     {
2112         return _tokenSell[_tokenType][index];
2113     }
2114 
2115     function tokenTypeOf(string memory tokenType)
2116         public
2117         view
2118         returns (uint256)
2119     {
2120         return _tokenTypeProduce[tokenType];
2121     }
2122 
2123     function mintTo(
2124         string memory _tokenType,
2125         uint256 numberOfTokens,
2126         bytes memory _data
2127     ) public payable nonReentrant {
2128         require(
2129             tokenPrice[_tokenType].mul(numberOfTokens) == msg.value,
2130             "Ether value is not correct"
2131         );
2132         _mint(_tokenType, numberOfTokens, _data);
2133         payable(mineAcceptAddr).transfer(msg.value);
2134     }
2135 
2136     function tokenMake(string memory _tokenType, uint256 numberOfTokens)
2137         public
2138         payable
2139         nonReentrant
2140     {
2141         require(
2142             tokenPrice[_tokenType].mul(numberOfTokens) == msg.value,
2143             "Ether value is not correct"
2144         );
2145         uint256 count = tokenTypeOf(_tokenType);
2146         require(count >= numberOfTokens, " token number surplus not enough");
2147         uint256 index = 1;
2148         for (uint256 i = numberOfTokens; i > 0; i--) {
2149             require(i >= 0, " token number i not enough");
2150             uint256 tokenId = _tokenSell[_tokenType][count - index];
2151             super.safeTransferFrom(owner(), _msgSender(), tokenId, "");
2152             index++;
2153         }
2154         _tokenTypeProduce[_tokenType] = count - numberOfTokens;
2155         payable(mineAcceptAddr).transfer(msg.value);
2156     }
2157 
2158     function setTokenPriceOf(string memory _tokenType, uint256 _tokenPrice)
2159         public
2160         onlyOwnerOrProxy
2161         returns (uint256)
2162     {
2163         return tokenPrice[_tokenType] = _tokenPrice;
2164     }
2165 
2166     function putSell(
2167         string memory _tokenType,
2168         uint256 numberOfTokens,
2169         uint256 _tokenPrice
2170     ) public onlyOwnerOrProxy {
2171         tokenPrice[_tokenType] = _tokenPrice;
2172         _tokenTypeProduce[_tokenType] = numberOfTokens;
2173         _mint(_tokenType, numberOfTokens, bytes(baseTokenURI()));
2174     }
2175 
2176     function _mint(
2177         string memory _tokenType,
2178         uint256 numberOfTokens,
2179         bytes memory _data
2180     ) private {
2181         uint256[] memory array = new uint256[](numberOfTokens);
2182         for (uint256 i = 0; i < numberOfTokens; i++) {
2183             _idTokenType[totalSupply() + 1] = _tokenType;
2184             array[i] = totalSupply() + 1;
2185             mintTo(mintAddr, _data);
2186         }
2187         _tokenSell[_tokenType] = array;
2188     }
2189 
2190     function burn(address _from, uint256 _id)
2191         public
2192         onlyTokenAmountOwned(_from, _id)
2193     {
2194         super.burn(_id);
2195     }
2196 
2197     function _ownsTokenAmount(address _from, uint256 _id)
2198         internal
2199         view
2200         returns (bool)
2201     {
2202         return
2203             _isOwnerOrProxy(_from)
2204                 ? true
2205                 : (ownerOf(_id) == _from ||
2206                     isApprovedForAll(ownerOf(_id), _msgSender()));
2207     }
2208 
2209     modifier onlyImpermanentURI(uint256 id) {
2210         require(
2211             !isPermanentURI(id),
2212             "AssetContract#onlyImpermanentURI: URI_CANNOT_BE_CHANGED"
2213         );
2214         _;
2215     }
2216 
2217     function setPermanentURI(uint256 _id, string memory _uri)
2218         public
2219         onlyOwnerOrProxy
2220         onlyImpermanentURI(_id)
2221     {
2222         _setPermanentURI(_id, _uri);
2223     }
2224 
2225     function isPermanentURI(uint256 _id) public view returns (bool) {
2226         return _isPermanentURI[_id];
2227     }
2228 
2229     function tokenURI(uint256 tokenId)
2230         public
2231         view
2232         override
2233         returns (string memory)
2234     {
2235         require(
2236             _exists(tokenId),
2237             "ERC721Metadata: URI query for nonexistent token"
2238         );
2239         string memory tokenUri = _tokenURI[tokenId];
2240         if (bytes(baseTokenURI()).length == 0) {
2241             return tokenUri;
2242         }
2243         if (bytes(tokenUri).length > 0) {
2244             return string(tokenUri);
2245         }
2246 
2247         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
2248         return
2249             string(
2250                 abi.encodePacked(
2251                     baseTokenURI(),
2252                     (_idTokenType[tokenId]),
2253                     "/",
2254                     (tokenId.toString())
2255                 )
2256             );
2257     }
2258 
2259     function setURI(uint256 _id, string memory _uri)
2260         public
2261         onlyOwnerOrProxy
2262         onlyImpermanentURI(_id)
2263     {
2264         _tokenURI[_id] = _uri;
2265     }
2266 
2267     function _setPermanentURI(uint256 _id, string memory _uri) internal {
2268         require(
2269             bytes(_uri).length > 0,
2270             "AssetContract#setPermanentURI: ONLY_VALID_URI"
2271         );
2272         _isPermanentURI[_id] = true;
2273         _setURI(_id, _uri);
2274         emit PermanentURI(_uri, _id);
2275     }
2276 
2277     function _setURI(uint256 _id, string memory _uri) internal {
2278         _tokenURI[_id] = _uri;
2279     }
2280 
2281     function baseTokenURI() public view override returns (string memory) {
2282         return templateURI;
2283     }
2284 }
2285 
2286 contract Commodity is AssetContract {
2287     constructor()
2288         AssetContract(
2289             "THING",
2290             "THING",
2291             10 * 10**18,
2292             "hotsales",
2293             "http://164.155.49.105/api/thing/info/",
2294             0x85FE87E86024B24dBc64DbaE43882bA56f302726
2295         )
2296     {}
2297 }