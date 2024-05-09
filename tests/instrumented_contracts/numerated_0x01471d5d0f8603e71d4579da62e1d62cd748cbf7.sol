1 // Sources flattened with hardhat v2.9.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol@v4.5.2
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165Upgradeable {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File @openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol@v4.5.2
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721Upgradeable is IERC165Upgradeable {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
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
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
178 
179 
180 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
181 
182 pragma solidity ^0.8.0;
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
207 
208 // File @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol@v4.5.2
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721MetadataUpgradeable is IERC721Upgradeable {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 
237 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
238 
239 
240 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
241 
242 pragma solidity ^0.8.1;
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      *
265      * [IMPORTANT]
266      * ====
267      * You shouldn't rely on `isContract` to protect against flash loan attacks!
268      *
269      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
270      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
271      * constructor.
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // This method relies on extcodesize/address.code.length, which returns 0
276         // for contracts in construction, since the code is only stored at the end
277         // of the constructor execution.
278 
279         return account.code.length > 0;
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         (bool success, ) = recipient.call{value: amount}("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain `call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324         return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(
367         address target,
368         bytes memory data,
369         uint256 value,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         require(isContract(target), "Address: call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.call{value: value}(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
386         return functionStaticCall(target, data, "Address: low-level static call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a static call.
392      *
393      * _Available since v3.3._
394      */
395     function functionStaticCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal view returns (bytes memory) {
400         require(isContract(target), "Address: static call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.staticcall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         require(isContract(target), "Address: delegate call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.delegatecall(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
435      * revert reason using the provided one.
436      *
437      * _Available since v4.3._
438      */
439     function verifyCallResult(
440         bool success,
441         bytes memory returndata,
442         string memory errorMessage
443     ) internal pure returns (bytes memory) {
444         if (success) {
445             return returndata;
446         } else {
447             // Look for revert reason and bubble it up if present
448             if (returndata.length > 0) {
449                 // The easiest way to bubble the revert reason is using memory via assembly
450 
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 
463 // File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v4.5.2
464 
465 
466 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
467 
468 pragma solidity ^0.8.1;
469 
470 /**
471  * @dev Collection of functions related to the address type
472  */
473 library AddressUpgradeable {
474     /**
475      * @dev Returns true if `account` is a contract.
476      *
477      * [IMPORTANT]
478      * ====
479      * It is unsafe to assume that an address for which this function returns
480      * false is an externally-owned account (EOA) and not a contract.
481      *
482      * Among others, `isContract` will return false for the following
483      * types of addresses:
484      *
485      *  - an externally-owned account
486      *  - a contract in construction
487      *  - an address where a contract will be created
488      *  - an address where a contract lived, but was destroyed
489      * ====
490      *
491      * [IMPORTANT]
492      * ====
493      * You shouldn't rely on `isContract` to protect against flash loan attacks!
494      *
495      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
496      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
497      * constructor.
498      * ====
499      */
500     function isContract(address account) internal view returns (bool) {
501         // This method relies on extcodesize/address.code.length, which returns 0
502         // for contracts in construction, since the code is only stored at the end
503         // of the constructor execution.
504 
505         return account.code.length > 0;
506     }
507 
508     /**
509      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
510      * `recipient`, forwarding all available gas and reverting on errors.
511      *
512      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
513      * of certain opcodes, possibly making contracts go over the 2300 gas limit
514      * imposed by `transfer`, making them unable to receive funds via
515      * `transfer`. {sendValue} removes this limitation.
516      *
517      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
518      *
519      * IMPORTANT: because control is transferred to `recipient`, care must be
520      * taken to not create reentrancy vulnerabilities. Consider using
521      * {ReentrancyGuard} or the
522      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
523      */
524     function sendValue(address payable recipient, uint256 amount) internal {
525         require(address(this).balance >= amount, "Address: insufficient balance");
526 
527         (bool success, ) = recipient.call{value: amount}("");
528         require(success, "Address: unable to send value, recipient may have reverted");
529     }
530 
531     /**
532      * @dev Performs a Solidity function call using a low level `call`. A
533      * plain `call` is an unsafe replacement for a function call: use this
534      * function instead.
535      *
536      * If `target` reverts with a revert reason, it is bubbled up by this
537      * function (like regular Solidity function calls).
538      *
539      * Returns the raw returned data. To convert to the expected return value,
540      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
541      *
542      * Requirements:
543      *
544      * - `target` must be a contract.
545      * - calling `target` with `data` must not revert.
546      *
547      * _Available since v3.1._
548      */
549     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
550         return functionCall(target, data, "Address: low-level call failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
555      * `errorMessage` as a fallback revert reason when `target` reverts.
556      *
557      * _Available since v3.1._
558      */
559     function functionCall(
560         address target,
561         bytes memory data,
562         string memory errorMessage
563     ) internal returns (bytes memory) {
564         return functionCallWithValue(target, data, 0, errorMessage);
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
569      * but also transferring `value` wei to `target`.
570      *
571      * Requirements:
572      *
573      * - the calling contract must have an ETH balance of at least `value`.
574      * - the called Solidity function must be `payable`.
575      *
576      * _Available since v3.1._
577      */
578     function functionCallWithValue(
579         address target,
580         bytes memory data,
581         uint256 value
582     ) internal returns (bytes memory) {
583         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
588      * with `errorMessage` as a fallback revert reason when `target` reverts.
589      *
590      * _Available since v3.1._
591      */
592     function functionCallWithValue(
593         address target,
594         bytes memory data,
595         uint256 value,
596         string memory errorMessage
597     ) internal returns (bytes memory) {
598         require(address(this).balance >= value, "Address: insufficient balance for call");
599         require(isContract(target), "Address: call to non-contract");
600 
601         (bool success, bytes memory returndata) = target.call{value: value}(data);
602         return verifyCallResult(success, returndata, errorMessage);
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
607      * but performing a static call.
608      *
609      * _Available since v3.3._
610      */
611     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
612         return functionStaticCall(target, data, "Address: low-level static call failed");
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
617      * but performing a static call.
618      *
619      * _Available since v3.3._
620      */
621     function functionStaticCall(
622         address target,
623         bytes memory data,
624         string memory errorMessage
625     ) internal view returns (bytes memory) {
626         require(isContract(target), "Address: static call to non-contract");
627 
628         (bool success, bytes memory returndata) = target.staticcall(data);
629         return verifyCallResult(success, returndata, errorMessage);
630     }
631 
632     /**
633      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
634      * revert reason using the provided one.
635      *
636      * _Available since v4.3._
637      */
638     function verifyCallResult(
639         bool success,
640         bytes memory returndata,
641         string memory errorMessage
642     ) internal pure returns (bytes memory) {
643         if (success) {
644             return returndata;
645         } else {
646             // Look for revert reason and bubble it up if present
647             if (returndata.length > 0) {
648                 // The easiest way to bubble the revert reason is using memory via assembly
649 
650                 assembly {
651                     let returndata_size := mload(returndata)
652                     revert(add(32, returndata), returndata_size)
653                 }
654             } else {
655                 revert(errorMessage);
656             }
657         }
658     }
659 }
660 
661 
662 // File @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol@v4.5.2
663 
664 
665 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/utils/Initializable.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 /**
670  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
671  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
672  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
673  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
674  *
675  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
676  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
677  *
678  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
679  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
680  *
681  * [CAUTION]
682  * ====
683  * Avoid leaving a contract uninitialized.
684  *
685  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
686  * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
687  * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
688  *
689  * [.hljs-theme-light.nopadding]
690  * ```
691  * /// @custom:oz-upgrades-unsafe-allow constructor
692  * constructor() initializer {}
693  * ```
694  * ====
695  */
696 abstract contract Initializable {
697     /**
698      * @dev Indicates that the contract has been initialized.
699      */
700     bool private _initialized;
701 
702     /**
703      * @dev Indicates that the contract is in the process of being initialized.
704      */
705     bool private _initializing;
706 
707     /**
708      * @dev Modifier to protect an initializer function from being invoked twice.
709      */
710     modifier initializer() {
711         // If the contract is initializing we ignore whether _initialized is set in order to support multiple
712         // inheritance patterns, but we only do this in the context of a constructor, because in other contexts the
713         // contract may have been reentered.
714         require(_initializing ? _isConstructor() : !_initialized, "Initializable: contract is already initialized");
715 
716         bool isTopLevelCall = !_initializing;
717         if (isTopLevelCall) {
718             _initializing = true;
719             _initialized = true;
720         }
721 
722         _;
723 
724         if (isTopLevelCall) {
725             _initializing = false;
726         }
727     }
728 
729     /**
730      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
731      * {initializer} modifier, directly or indirectly.
732      */
733     modifier onlyInitializing() {
734         require(_initializing, "Initializable: contract is not initializing");
735         _;
736     }
737 
738     function _isConstructor() private view returns (bool) {
739         return !AddressUpgradeable.isContract(address(this));
740     }
741 }
742 
743 
744 // File @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol@v4.5.2
745 
746 
747 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 /**
752  * @dev Provides information about the current execution context, including the
753  * sender of the transaction and its data. While these are generally available
754  * via msg.sender and msg.data, they should not be accessed in such a direct
755  * manner, since when dealing with meta-transactions the account sending and
756  * paying for execution may not be the actual sender (as far as an application
757  * is concerned).
758  *
759  * This contract is only required for intermediate, library-like contracts.
760  */
761 abstract contract ContextUpgradeable is Initializable {
762     function __Context_init() internal onlyInitializing {
763     }
764 
765     function __Context_init_unchained() internal onlyInitializing {
766     }
767     function _msgSender() internal view virtual returns (address) {
768         return msg.sender;
769     }
770 
771     function _msgData() internal view virtual returns (bytes calldata) {
772         return msg.data;
773     }
774 
775     /**
776      * @dev This empty reserved space is put in place to allow future versions to add new
777      * variables without shifting down storage in the inheritance chain.
778      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
779      */
780     uint256[50] private __gap;
781 }
782 
783 
784 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
785 
786 
787 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
788 
789 pragma solidity ^0.8.0;
790 
791 /**
792  * @dev String operations.
793  */
794 library Strings {
795     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
796 
797     /**
798      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
799      */
800     function toString(uint256 value) internal pure returns (string memory) {
801         // Inspired by OraclizeAPI's implementation - MIT licence
802         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
803 
804         if (value == 0) {
805             return "0";
806         }
807         uint256 temp = value;
808         uint256 digits;
809         while (temp != 0) {
810             digits++;
811             temp /= 10;
812         }
813         bytes memory buffer = new bytes(digits);
814         while (value != 0) {
815             digits -= 1;
816             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
817             value /= 10;
818         }
819         return string(buffer);
820     }
821 
822     /**
823      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
824      */
825     function toHexString(uint256 value) internal pure returns (string memory) {
826         if (value == 0) {
827             return "0x00";
828         }
829         uint256 temp = value;
830         uint256 length = 0;
831         while (temp != 0) {
832             length++;
833             temp >>= 8;
834         }
835         return toHexString(value, length);
836     }
837 
838     /**
839      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
840      */
841     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
842         bytes memory buffer = new bytes(2 * length + 2);
843         buffer[0] = "0";
844         buffer[1] = "x";
845         for (uint256 i = 2 * length + 1; i > 1; --i) {
846             buffer[i] = _HEX_SYMBOLS[value & 0xf];
847             value >>= 4;
848         }
849         require(value == 0, "Strings: hex length insufficient");
850         return string(buffer);
851     }
852 }
853 
854 
855 // File @openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol@v4.5.2
856 
857 
858 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
859 
860 pragma solidity ^0.8.0;
861 
862 
863 /**
864  * @dev Implementation of the {IERC165} interface.
865  *
866  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
867  * for the additional interface id that will be supported. For example:
868  *
869  * ```solidity
870  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
871  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
872  * }
873  * ```
874  *
875  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
876  */
877 abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
878     function __ERC165_init() internal onlyInitializing {
879     }
880 
881     function __ERC165_init_unchained() internal onlyInitializing {
882     }
883     /**
884      * @dev See {IERC165-supportsInterface}.
885      */
886     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
887         return interfaceId == type(IERC165Upgradeable).interfaceId;
888     }
889 
890     /**
891      * @dev This empty reserved space is put in place to allow future versions to add new
892      * variables without shifting down storage in the inheritance chain.
893      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
894      */
895     uint256[50] private __gap;
896 }
897 
898 
899 // File contracts/ERC721ASBUpgradable.sol
900 
901 
902 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
903 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
904 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
905 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
906 
907 
908 // ERC721A Creator: Chiru Labs
909 // GJ mate. interesting design :)
910 
911 pragma solidity 0.8.13;
912 
913 
914 
915 
916 
917 
918 
919 
920 error ApprovalCallerNotOwnerNorApproved();
921 error ApprovalQueryForNonexistentToken();
922 error ApproveToCaller();
923 error ApprovalToCurrentOwner();
924 error BalanceQueryForZeroAddress();
925 error MintToZeroAddress();
926 error MintZeroQuantity();
927 error OwnerQueryForNonexistentToken();
928 error TransferCallerNotOwnerNorApproved();
929 error TransferFromIncorrectOwner();
930 error TransferToNonERC721ReceiverImplementer();
931 error TransferToZeroAddress();
932 error URIQueryForNonexistentToken();
933 error AllOwnershipsHaveBeenSet();
934 error QuantityMustBeNonZero();
935 error NoTokensMintedYet();
936 error InvalidQueryRange();
937 
938 /**
939  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
940  * the Metadata extension. Built to optimize for lower gas during batch mints.
941  *
942  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
943  *
944  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
945  *
946  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
947  *
948  * Speedboat team modified version of ERC721A - upgradable
949  */
950 contract ERC721ASBUpgradable is
951     Initializable,
952     ContextUpgradeable,
953     ERC165Upgradeable,
954     IERC721Upgradeable,
955     IERC721MetadataUpgradeable
956 {
957     using Address for address;
958     using Strings for uint256;
959 
960     // Compiler will pack this into a single 256bit word.
961     struct TokenOwnership {
962         // The address of the owner.
963         address addr;
964         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
965         uint64 startTimestamp;
966         // Whether the token has been burned.
967         bool burned;
968     }
969 
970     // Compiler will pack this into a single 256bit word.
971     struct AddressData {
972         // Realistically, 2**64-1 is more than enough.
973         uint64 balance;
974         // Keeps track of mint count with minimal overhead for tokenomics.
975         uint64 numberMinted;
976         // Keeps track of burn count with minimal overhead for tokenomics.
977         uint64 numberBurned;
978         // For miscellaneous variable(s) pertaining to the address
979         // (e.g. number of whitelist mint slots used).
980         // If there are multiple variables, please pack them into a uint64.
981         uint64 aux;
982     }
983 
984     // The tokenId of the next token to be minted.
985     uint256 internal _currentIndex;
986 
987     // The number of tokens burned.
988     uint256 internal _burnCounter;
989 
990     // Token name
991     string private _name;
992 
993     // Token symbol
994     string private _symbol;
995 
996     // Mapping from token ID to ownership details
997     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
998     mapping(uint256 => TokenOwnership) internal _ownerships;
999 
1000     // Mapping owner address to address data
1001     mapping(address => AddressData) private _addressData;
1002 
1003     // Mapping from token ID to approved address
1004     mapping(uint256 => address) private _tokenApprovals;
1005 
1006     // Mapping from owner to operator approvals
1007     mapping(address => mapping(address => bool)) private _operatorApprovals;
1008 
1009     uint256 public nextOwnerToExplicitlySet;
1010 
1011     /**
1012      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1013      * SB: change to public. anyone are free to pay the gas lol :P
1014      */
1015     function setOwnersExplicit(uint256 quantity) public {
1016         if (quantity == 0) revert QuantityMustBeNonZero();
1017         if (_currentIndex == _startTokenId()) revert NoTokensMintedYet();
1018         uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1019         if (_nextOwnerToExplicitlySet == 0) {
1020             _nextOwnerToExplicitlySet = _startTokenId();
1021         }
1022         if (_nextOwnerToExplicitlySet >= _currentIndex)
1023             revert AllOwnershipsHaveBeenSet();
1024 
1025         // Index underflow is impossible.
1026         // Counter or index overflow is incredibly unrealistic.
1027         unchecked {
1028             uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1029 
1030             // Set the end index to be the last token index
1031             if (endIndex + 1 > _currentIndex) {
1032                 endIndex = _currentIndex - 1;
1033             }
1034 
1035             for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1036                 if (
1037                     _ownerships[i].addr == address(0) && !_ownerships[i].burned
1038                 ) {
1039                     TokenOwnership memory ownership = _ownershipOf(i);
1040                     _ownerships[i].addr = ownership.addr;
1041                     _ownerships[i].startTimestamp = ownership.startTimestamp;
1042                 }
1043             }
1044 
1045             nextOwnerToExplicitlySet = endIndex + 1;
1046         }
1047     }
1048 
1049     /**
1050      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1051      *
1052      * If the `tokenId` is out of bounds:
1053      *   - `addr` = `address(0)`
1054      *   - `startTimestamp` = `0`
1055      *   - `burned` = `false`
1056      *
1057      * If the `tokenId` is burned:
1058      *   - `addr` = `<Address of owner before token was burned>`
1059      *   - `startTimestamp` = `<Timestamp when token was burned>`
1060      *   - `burned = `true`
1061      *
1062      * Otherwise:
1063      *   - `addr` = `<Address of owner>`
1064      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1065      *   - `burned = `false`
1066      */
1067     function explicitOwnershipOf(uint256 tokenId)
1068         public
1069         view
1070         returns (TokenOwnership memory)
1071     {
1072         TokenOwnership memory ownership;
1073         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1074             return ownership;
1075         }
1076         ownership = _ownerships[tokenId];
1077         if (ownership.burned) {
1078             return ownership;
1079         }
1080         return _ownershipOf(tokenId);
1081     }
1082 
1083     /**
1084      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1085      * See {ERC721AQueryable-explicitOwnershipOf}
1086      */
1087     function explicitOwnershipsOf(uint256[] memory tokenIds)
1088         external
1089         view
1090         returns (TokenOwnership[] memory)
1091     {
1092         unchecked {
1093             uint256 tokenIdsLength = tokenIds.length;
1094             TokenOwnership[] memory ownerships = new TokenOwnership[](
1095                 tokenIdsLength
1096             );
1097             for (uint256 i; i != tokenIdsLength; ++i) {
1098                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1099             }
1100             return ownerships;
1101         }
1102     }
1103 
1104     /**
1105      * @dev Returns an array of token IDs owned by `owner`,
1106      * in the range [`start`, `stop`)
1107      * (i.e. `start <= tokenId < stop`).
1108      *
1109      * This function allows for tokens to be queried if the collection
1110      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1111      *
1112      * Requirements:
1113      *
1114      * - `start` < `stop`
1115      */
1116     function tokensOfOwnerIn(
1117         address owner,
1118         uint256 start,
1119         uint256 stop
1120     ) external view returns (uint256[] memory) {
1121         unchecked {
1122             if (start >= stop) revert InvalidQueryRange();
1123             uint256 tokenIdsIdx;
1124             uint256 stopLimit = _currentIndex;
1125             // Set `start = max(start, _startTokenId())`.
1126             if (start < _startTokenId()) {
1127                 start = _startTokenId();
1128             }
1129             // Set `stop = min(stop, _currentIndex)`.
1130             if (stop > stopLimit) {
1131                 stop = stopLimit;
1132             }
1133             uint256 tokenIdsMaxLength = balanceOf(owner);
1134             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1135             // to cater for cases where `balanceOf(owner)` is too big.
1136             if (start < stop) {
1137                 uint256 rangeLength = stop - start;
1138                 if (rangeLength < tokenIdsMaxLength) {
1139                     tokenIdsMaxLength = rangeLength;
1140                 }
1141             } else {
1142                 tokenIdsMaxLength = 0;
1143             }
1144             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1145             if (tokenIdsMaxLength == 0) {
1146                 return tokenIds;
1147             }
1148             // We need to call `explicitOwnershipOf(start)`,
1149             // because the slot at `start` may not be initialized.
1150             TokenOwnership memory ownership = explicitOwnershipOf(start);
1151             address currOwnershipAddr;
1152             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1153             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1154             if (!ownership.burned) {
1155                 currOwnershipAddr = ownership.addr;
1156             }
1157             for (
1158                 uint256 i = start;
1159                 i != stop && tokenIdsIdx != tokenIdsMaxLength;
1160                 ++i
1161             ) {
1162                 ownership = _ownerships[i];
1163                 if (ownership.burned) {
1164                     continue;
1165                 }
1166                 if (ownership.addr != address(0)) {
1167                     currOwnershipAddr = ownership.addr;
1168                 }
1169                 if (currOwnershipAddr == owner) {
1170                     tokenIds[tokenIdsIdx++] = i;
1171                 }
1172             }
1173             // Downsize the array to fit.
1174             assembly {
1175                 mstore(tokenIds, tokenIdsIdx)
1176             }
1177             return tokenIds;
1178         }
1179     }
1180 
1181     /**
1182      * @dev Returns an array of token IDs owned by `owner`.
1183      *
1184      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1185      * It is meant to be called off-chain.
1186      *
1187      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1188      * multiple smaller scans if the collection is large enough to cause
1189      * an out-of-gas error (10K pfp collections should be fine).
1190      */
1191     function tokensOfOwner(address owner)
1192         public
1193         view
1194         returns (uint256[] memory)
1195     {
1196         unchecked {
1197             uint256 tokenIdsIdx;
1198             address currOwnershipAddr;
1199             uint256 tokenIdsLength = balanceOf(owner);
1200             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1201             TokenOwnership memory ownership;
1202             for (
1203                 uint256 i = _startTokenId();
1204                 tokenIdsIdx != tokenIdsLength;
1205                 ++i
1206             ) {
1207                 ownership = _ownerships[i];
1208                 if (ownership.burned) {
1209                     continue;
1210                 }
1211                 if (ownership.addr != address(0)) {
1212                     currOwnershipAddr = ownership.addr;
1213                 }
1214                 if (currOwnershipAddr == owner) {
1215                     tokenIds[tokenIdsIdx++] = i;
1216                 }
1217             }
1218             return tokenIds;
1219         }
1220     }
1221 
1222     function __ERC721A_init(string memory name_, string memory symbol_)
1223         public
1224     {
1225         __Context_init_unchained();
1226         __ERC165_init_unchained();
1227         _name = name_;
1228         _symbol = symbol_;
1229         _currentIndex = _startTokenId();
1230     }
1231 
1232     /**
1233      * To change the starting tokenId, please override this function.
1234      */
1235     function _startTokenId() internal view virtual returns (uint256) {
1236         return 1; // SB: change to start from 1 - modified from original 0. since others SB's code reserve 0 for a random stuff
1237     }
1238 
1239     /**
1240      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1241      */
1242     function totalSupply() public view returns (uint256) {
1243         // Counter underflow is impossible as _burnCounter cannot be incremented
1244         // more than _currentIndex - _startTokenId() times
1245         unchecked {
1246             return _currentIndex - _burnCounter - _startTokenId();
1247         }
1248     }
1249 
1250     /**
1251      * Returns the total amount of tokens minted in the contract.
1252      */
1253     function _totalMinted() internal view returns (uint256) {
1254         // Counter underflow is impossible as _currentIndex does not decrement,
1255         // and it is initialized to _startTokenId()
1256         unchecked {
1257             return _currentIndex - _startTokenId();
1258         }
1259     }
1260 
1261     /**
1262      * @dev See {IERC165-supportsInterface}.
1263      */
1264     function supportsInterface(bytes4 interfaceId)
1265         public
1266         view
1267         virtual
1268         override(ERC165Upgradeable, IERC165Upgradeable)
1269         returns (bool)
1270     {
1271         return
1272             interfaceId == type(IERC721Upgradeable).interfaceId ||
1273             interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
1274             super.supportsInterface(interfaceId);
1275     }
1276 
1277     /**
1278      * @dev See {IERC721-balanceOf}.
1279      */
1280     function balanceOf(address owner) public view override returns (uint256) {
1281         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1282         return uint256(_addressData[owner].balance);
1283     }
1284 
1285     /**
1286      * Returns the number of tokens minted by `owner`.
1287      */
1288     function _numberMinted(address owner) internal view returns (uint256) {
1289         return uint256(_addressData[owner].numberMinted);
1290     }
1291 
1292     /**
1293      * Returns the number of tokens burned by or on behalf of `owner`.
1294      */
1295     function _numberBurned(address owner) internal view returns (uint256) {
1296         return uint256(_addressData[owner].numberBurned);
1297     }
1298 
1299     /**
1300      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1301      */
1302     function _getAux(address owner) internal view returns (uint64) {
1303         return _addressData[owner].aux;
1304     }
1305 
1306     /**
1307      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1308      * If there are multiple variables, please pack them into a uint64.
1309      */
1310     function _setAux(address owner, uint64 aux) internal {
1311         _addressData[owner].aux = aux;
1312     }
1313 
1314     /**
1315      * Gas spent here starts off proportional to the maximum mint batch size.
1316      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1317      */
1318     function _ownershipOf(uint256 tokenId)
1319         internal
1320         view
1321         returns (TokenOwnership memory)
1322     {
1323         uint256 curr = tokenId;
1324 
1325         unchecked {
1326             if (_startTokenId() <= curr && curr < _currentIndex) {
1327                 TokenOwnership memory ownership = _ownerships[curr];
1328                 if (!ownership.burned) {
1329                     if (ownership.addr != address(0)) {
1330                         return ownership;
1331                     }
1332                     // Invariant:
1333                     // There will always be an ownership that has an address and is not burned
1334                     // before an ownership that does not have an address and is not burned.
1335                     // Hence, curr will not underflow.
1336                     while (true) {
1337                         curr--;
1338                         ownership = _ownerships[curr];
1339                         if (ownership.addr != address(0)) {
1340                             return ownership;
1341                         }
1342                     }
1343                 }
1344             }
1345         }
1346         revert OwnerQueryForNonexistentToken();
1347     }
1348 
1349     /**
1350      * @dev See {IERC721-ownerOf}.
1351      */
1352     function ownerOf(uint256 tokenId) public view override returns (address) {
1353         return _ownershipOf(tokenId).addr;
1354     }
1355 
1356     /**
1357      * @dev See {IERC721Metadata-name}.
1358      */
1359     function name() public view virtual override returns (string memory) {
1360         return _name;
1361     }
1362 
1363     /**
1364      * @dev See {IERC721Metadata-symbol}.
1365      */
1366     function symbol() public view virtual override returns (string memory) {
1367         return _symbol;
1368     }
1369 
1370     /**
1371      * @dev See {IERC721Metadata-tokenURI}.
1372      */
1373     function tokenURI(uint256 tokenId)
1374         public
1375         view
1376         virtual
1377         override
1378         returns (string memory)
1379     {
1380         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1381 
1382         string memory baseURI = _baseURI();
1383         return
1384             bytes(baseURI).length != 0
1385                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1386                 : "";
1387     }
1388 
1389     /**
1390      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1391      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1392      * by default, can be overriden in child contracts.
1393      */
1394     function _baseURI() internal view virtual returns (string memory) {
1395         return "";
1396     }
1397 
1398     /**
1399      * @dev See {IERC721-approve}.
1400      */
1401     function approve(address to, uint256 tokenId) public override {
1402         address owner = ownerOf(tokenId);
1403         if (to == owner) revert ApprovalToCurrentOwner();
1404 
1405         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1406             revert ApprovalCallerNotOwnerNorApproved();
1407         }
1408 
1409         _approve(to, tokenId, owner);
1410     }
1411 
1412     /**
1413      * @dev See {IERC721-getApproved}.
1414      */
1415     function getApproved(uint256 tokenId)
1416         public
1417         view
1418         override
1419         returns (address)
1420     {
1421         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1422 
1423         return _tokenApprovals[tokenId];
1424     }
1425 
1426     /**
1427      * @dev See {IERC721-setApprovalForAll}.
1428      */
1429     function setApprovalForAll(address operator, bool approved)
1430         public
1431         virtual
1432         override
1433     {
1434         if (operator == _msgSender()) revert ApproveToCaller();
1435 
1436         _operatorApprovals[_msgSender()][operator] = approved;
1437         emit ApprovalForAll(_msgSender(), operator, approved);
1438     }
1439 
1440     /**
1441      * @dev See {IERC721-isApprovedForAll}.
1442      */
1443     function isApprovedForAll(address owner, address operator)
1444         public
1445         view
1446         virtual
1447         override
1448         returns (bool)
1449     {
1450         return _operatorApprovals[owner][operator];
1451     }
1452 
1453     /**
1454      * @dev See {IERC721-transferFrom}.
1455      */
1456     function transferFrom(
1457         address from,
1458         address to,
1459         uint256 tokenId
1460     ) public virtual override {
1461         _transfer(from, to, tokenId);
1462     }
1463 
1464     /**
1465      * @dev See {IERC721-safeTransferFrom}.
1466      */
1467     function safeTransferFrom(
1468         address from,
1469         address to,
1470         uint256 tokenId
1471     ) public virtual override {
1472         safeTransferFrom(from, to, tokenId, "");
1473     }
1474 
1475     /**
1476      * @dev See {IERC721-safeTransferFrom}.
1477      */
1478     function safeTransferFrom(
1479         address from,
1480         address to,
1481         uint256 tokenId,
1482         bytes memory _data
1483     ) public virtual override {
1484         _transfer(from, to, tokenId);
1485         if (
1486             to.isContract() &&
1487             !_checkContractOnERC721Received(from, to, tokenId, _data)
1488         ) {
1489             revert TransferToNonERC721ReceiverImplementer();
1490         }
1491     }
1492 
1493     /**
1494      * @dev Returns whether `tokenId` exists.
1495      *
1496      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1497      *
1498      * Tokens start existing when they are minted (`_mint`),
1499      */
1500     function _exists(uint256 tokenId) internal view returns (bool) {
1501         return
1502             _startTokenId() <= tokenId &&
1503             tokenId < _currentIndex &&
1504             !_ownerships[tokenId].burned;
1505     }
1506 
1507     /**
1508      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1509      */
1510     function _safeMint(address to, uint256 quantity) internal {
1511         _safeMint(to, quantity, "");
1512     }
1513 
1514     /**
1515      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1516      *
1517      * Requirements:
1518      *
1519      * - If `to` refers to a smart contract, it must implement
1520      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1521      * - `quantity` must be greater than 0.
1522      *
1523      * Emits a {Transfer} event.
1524      */
1525     function _safeMint(
1526         address to,
1527         uint256 quantity,
1528         bytes memory _data
1529     ) internal {
1530         uint256 startTokenId = _currentIndex;
1531         if (to == address(0)) revert MintToZeroAddress();
1532         if (quantity == 0) revert MintZeroQuantity();
1533 
1534         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1535 
1536         // Overflows are incredibly unrealistic.
1537         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1538         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1539         unchecked {
1540             _addressData[to].balance += uint64(quantity);
1541             _addressData[to].numberMinted += uint64(quantity);
1542 
1543             _ownerships[startTokenId].addr = to;
1544             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1545 
1546             uint256 updatedIndex = startTokenId;
1547             uint256 end = updatedIndex + quantity;
1548 
1549             if (to.isContract()) {
1550                 do {
1551                     emit Transfer(address(0), to, updatedIndex);
1552                     if (
1553                         !_checkContractOnERC721Received(
1554                             address(0),
1555                             to,
1556                             updatedIndex++,
1557                             _data
1558                         )
1559                     ) {
1560                         revert TransferToNonERC721ReceiverImplementer();
1561                     }
1562                 } while (updatedIndex != end);
1563                 // Reentrancy protection
1564                 if (_currentIndex != startTokenId) revert();
1565             } else {
1566                 do {
1567                     emit Transfer(address(0), to, updatedIndex++);
1568                 } while (updatedIndex != end);
1569             }
1570             _currentIndex = updatedIndex;
1571         }
1572         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1573     }
1574 
1575     /**
1576      * @dev Mints `quantity` tokens and transfers them to `to`.
1577      *
1578      * Requirements:
1579      *
1580      * - `to` cannot be the zero address.
1581      * - `quantity` must be greater than 0.
1582      *
1583      * Emits a {Transfer} event.
1584      */
1585     function _mint(address to, uint256 quantity) internal {
1586         uint256 startTokenId = _currentIndex;
1587         if (to == address(0)) revert MintToZeroAddress();
1588         if (quantity == 0) revert MintZeroQuantity();
1589 
1590         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1591 
1592         // Overflows are incredibly unrealistic.
1593         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1594         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1595         unchecked {
1596             _addressData[to].balance += uint64(quantity);
1597             _addressData[to].numberMinted += uint64(quantity);
1598 
1599             _ownerships[startTokenId].addr = to;
1600             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1601 
1602             uint256 updatedIndex = startTokenId;
1603             uint256 end = updatedIndex + quantity;
1604 
1605             do {
1606                 emit Transfer(address(0), to, updatedIndex++);
1607             } while (updatedIndex != end);
1608 
1609             _currentIndex = updatedIndex;
1610         }
1611         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1612     }
1613 
1614     /**
1615      * @dev Transfers `tokenId` from `from` to `to`.
1616      *
1617      * Requirements:
1618      *
1619      * - `to` cannot be the zero address.
1620      * - `tokenId` token must be owned by `from`.
1621      *
1622      * Emits a {Transfer} event.
1623      */
1624     function _transfer(
1625         address from,
1626         address to,
1627         uint256 tokenId
1628     ) private {
1629         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1630 
1631         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1632 
1633         bool isApprovedOrOwner = (_msgSender() == from ||
1634             isApprovedForAll(from, _msgSender()) ||
1635             getApproved(tokenId) == _msgSender());
1636 
1637         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1638         if (to == address(0)) revert TransferToZeroAddress();
1639 
1640         _beforeTokenTransfers(from, to, tokenId, 1);
1641 
1642         // Clear approvals from the previous owner
1643         _approve(address(0), tokenId, from);
1644 
1645         // Underflow of the sender's balance is impossible because we check for
1646         // ownership above and the recipient's balance can't realistically overflow.
1647         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1648         unchecked {
1649             _addressData[from].balance -= 1;
1650             _addressData[to].balance += 1;
1651 
1652             TokenOwnership storage currSlot = _ownerships[tokenId];
1653             currSlot.addr = to;
1654             currSlot.startTimestamp = uint64(block.timestamp);
1655 
1656             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1657             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1658             uint256 nextTokenId = tokenId + 1;
1659             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1660             if (nextSlot.addr == address(0)) {
1661                 // This will suffice for checking _exists(nextTokenId),
1662                 // as a burned slot cannot contain the zero address.
1663                 if (nextTokenId != _currentIndex) {
1664                     nextSlot.addr = from;
1665                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1666                 }
1667             }
1668         }
1669 
1670         emit Transfer(from, to, tokenId);
1671         _afterTokenTransfers(from, to, tokenId, 1);
1672     }
1673 
1674     /**
1675      * @dev Equivalent to `_burn(tokenId, false)`.
1676      */
1677     function _burn(uint256 tokenId) internal virtual {
1678         _burn(tokenId, false);
1679     }
1680 
1681     /**
1682      * @dev Destroys `tokenId`.
1683      * The approval is cleared when the token is burned.
1684      *
1685      * Requirements:
1686      *
1687      * - `tokenId` must exist.
1688      *
1689      * Emits a {Transfer} event.
1690      */
1691     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1692         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1693 
1694         address from = prevOwnership.addr;
1695 
1696         if (approvalCheck) {
1697             bool isApprovedOrOwner = (_msgSender() == from ||
1698                 isApprovedForAll(from, _msgSender()) ||
1699                 getApproved(tokenId) == _msgSender());
1700 
1701             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1702         }
1703 
1704         _beforeTokenTransfers(from, address(0), tokenId, 1);
1705 
1706         // Clear approvals from the previous owner
1707         _approve(address(0), tokenId, from);
1708 
1709         // Underflow of the sender's balance is impossible because we check for
1710         // ownership above and the recipient's balance can't realistically overflow.
1711         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1712         unchecked {
1713             AddressData storage addressData = _addressData[from];
1714             addressData.balance -= 1;
1715             addressData.numberBurned += 1;
1716 
1717             // Keep track of who burned the token, and the timestamp of burning.
1718             TokenOwnership storage currSlot = _ownerships[tokenId];
1719             currSlot.addr = from;
1720             currSlot.startTimestamp = uint64(block.timestamp);
1721             currSlot.burned = true;
1722 
1723             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1724             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1725             uint256 nextTokenId = tokenId + 1;
1726             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1727             if (nextSlot.addr == address(0)) {
1728                 // This will suffice for checking _exists(nextTokenId),
1729                 // as a burned slot cannot contain the zero address.
1730                 if (nextTokenId != _currentIndex) {
1731                     nextSlot.addr = from;
1732                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1733                 }
1734             }
1735         }
1736 
1737         emit Transfer(from, address(0), tokenId);
1738         _afterTokenTransfers(from, address(0), tokenId, 1);
1739 
1740         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1741         unchecked {
1742             _burnCounter++;
1743         }
1744     }
1745 
1746     /**
1747      * @dev Approve `to` to operate on `tokenId`
1748      *
1749      * Emits a {Approval} event.
1750      */
1751     function _approve(
1752         address to,
1753         uint256 tokenId,
1754         address owner
1755     ) private {
1756         _tokenApprovals[tokenId] = to;
1757         emit Approval(owner, to, tokenId);
1758     }
1759 
1760     /**
1761      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1762      *
1763      * @param from address representing the previous owner of the given token ID
1764      * @param to target address that will receive the tokens
1765      * @param tokenId uint256 ID of the token to be transferred
1766      * @param _data bytes optional data to send along with the call
1767      * @return bool whether the call correctly returned the expected magic value
1768      */
1769     function _checkContractOnERC721Received(
1770         address from,
1771         address to,
1772         uint256 tokenId,
1773         bytes memory _data
1774     ) private returns (bool) {
1775         try
1776             IERC721Receiver(to).onERC721Received(
1777                 _msgSender(),
1778                 from,
1779                 tokenId,
1780                 _data
1781             )
1782         returns (bytes4 retval) {
1783             return retval == IERC721Receiver(to).onERC721Received.selector;
1784         } catch (bytes memory reason) {
1785             if (reason.length == 0) {
1786                 revert TransferToNonERC721ReceiverImplementer();
1787             } else {
1788                 assembly {
1789                     revert(add(32, reason), mload(reason))
1790                 }
1791             }
1792         }
1793     }
1794 
1795     /**
1796      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1797      * And also called before burning one token.
1798      *
1799      * startTokenId - the first token id to be transferred
1800      * quantity - the amount to be transferred
1801      *
1802      * Calling conditions:
1803      *
1804      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1805      * transferred to `to`.
1806      * - When `from` is zero, `tokenId` will be minted for `to`.
1807      * - When `to` is zero, `tokenId` will be burned by `from`.
1808      * - `from` and `to` are never both zero.
1809      */
1810     function _beforeTokenTransfers(
1811         address from,
1812         address to,
1813         uint256 startTokenId,
1814         uint256 quantity
1815     ) internal virtual {}
1816 
1817     /**
1818      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1819      * minting.
1820      * And also called after one token has been burned.
1821      *
1822      * startTokenId - the first token id to be transferred
1823      * quantity - the amount to be transferred
1824      *
1825      * Calling conditions:
1826      *
1827      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1828      * transferred to `to`.
1829      * - When `from` is zero, `tokenId` has been minted for `to`.
1830      * - When `to` is zero, `tokenId` has been burned by `from`.
1831      * - `from` and `to` are never both zero.
1832      */
1833     function _afterTokenTransfers(
1834         address from,
1835         address to,
1836         uint256 startTokenId,
1837         uint256 quantity
1838     ) internal virtual {}
1839 }
1840 
1841 
1842 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.6.0
1843 
1844 
1845 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1846 
1847 pragma solidity ^0.8.0;
1848 
1849 /**
1850  * @dev External interface of AccessControl declared to support ERC165 detection.
1851  */
1852 interface IAccessControl {
1853     /**
1854      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1855      *
1856      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1857      * {RoleAdminChanged} not being emitted signaling this.
1858      *
1859      * _Available since v3.1._
1860      */
1861     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1862 
1863     /**
1864      * @dev Emitted when `account` is granted `role`.
1865      *
1866      * `sender` is the account that originated the contract call, an admin role
1867      * bearer except when using {AccessControl-_setupRole}.
1868      */
1869     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1870 
1871     /**
1872      * @dev Emitted when `account` is revoked `role`.
1873      *
1874      * `sender` is the account that originated the contract call:
1875      *   - if using `revokeRole`, it is the admin role bearer
1876      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1877      */
1878     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1879 
1880     /**
1881      * @dev Returns `true` if `account` has been granted `role`.
1882      */
1883     function hasRole(bytes32 role, address account) external view returns (bool);
1884 
1885     /**
1886      * @dev Returns the admin role that controls `role`. See {grantRole} and
1887      * {revokeRole}.
1888      *
1889      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1890      */
1891     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1892 
1893     /**
1894      * @dev Grants `role` to `account`.
1895      *
1896      * If `account` had not been already granted `role`, emits a {RoleGranted}
1897      * event.
1898      *
1899      * Requirements:
1900      *
1901      * - the caller must have ``role``'s admin role.
1902      */
1903     function grantRole(bytes32 role, address account) external;
1904 
1905     /**
1906      * @dev Revokes `role` from `account`.
1907      *
1908      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1909      *
1910      * Requirements:
1911      *
1912      * - the caller must have ``role``'s admin role.
1913      */
1914     function revokeRole(bytes32 role, address account) external;
1915 
1916     /**
1917      * @dev Revokes `role` from the calling account.
1918      *
1919      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1920      * purpose is to provide a mechanism for accounts to lose their privileges
1921      * if they are compromised (such as when a trusted device is misplaced).
1922      *
1923      * If the calling account had been granted `role`, emits a {RoleRevoked}
1924      * event.
1925      *
1926      * Requirements:
1927      *
1928      * - the caller must be `account`.
1929      */
1930     function renounceRole(bytes32 role, address account) external;
1931 }
1932 
1933 
1934 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
1935 
1936 
1937 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1938 
1939 pragma solidity ^0.8.0;
1940 
1941 /**
1942  * @dev Provides information about the current execution context, including the
1943  * sender of the transaction and its data. While these are generally available
1944  * via msg.sender and msg.data, they should not be accessed in such a direct
1945  * manner, since when dealing with meta-transactions the account sending and
1946  * paying for execution may not be the actual sender (as far as an application
1947  * is concerned).
1948  *
1949  * This contract is only required for intermediate, library-like contracts.
1950  */
1951 abstract contract Context {
1952     function _msgSender() internal view virtual returns (address) {
1953         return msg.sender;
1954     }
1955 
1956     function _msgData() internal view virtual returns (bytes calldata) {
1957         return msg.data;
1958     }
1959 }
1960 
1961 
1962 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
1963 
1964 
1965 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1966 
1967 pragma solidity ^0.8.0;
1968 
1969 /**
1970  * @dev Interface of the ERC165 standard, as defined in the
1971  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1972  *
1973  * Implementers can declare support of contract interfaces, which can then be
1974  * queried by others ({ERC165Checker}).
1975  *
1976  * For an implementation, see {ERC165}.
1977  */
1978 interface IERC165 {
1979     /**
1980      * @dev Returns true if this contract implements the interface defined by
1981      * `interfaceId`. See the corresponding
1982      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1983      * to learn more about how these ids are created.
1984      *
1985      * This function call must use less than 30 000 gas.
1986      */
1987     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1988 }
1989 
1990 
1991 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
1992 
1993 
1994 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1995 
1996 pragma solidity ^0.8.0;
1997 
1998 /**
1999  * @dev Implementation of the {IERC165} interface.
2000  *
2001  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2002  * for the additional interface id that will be supported. For example:
2003  *
2004  * ```solidity
2005  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2006  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2007  * }
2008  * ```
2009  *
2010  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2011  */
2012 abstract contract ERC165 is IERC165 {
2013     /**
2014      * @dev See {IERC165-supportsInterface}.
2015      */
2016     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2017         return interfaceId == type(IERC165).interfaceId;
2018     }
2019 }
2020 
2021 
2022 // File @openzeppelin/contracts/access/AccessControl.sol@v4.6.0
2023 
2024 
2025 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
2026 
2027 pragma solidity ^0.8.0;
2028 
2029 
2030 
2031 
2032 /**
2033  * @dev Contract module that allows children to implement role-based access
2034  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
2035  * members except through off-chain means by accessing the contract event logs. Some
2036  * applications may benefit from on-chain enumerability, for those cases see
2037  * {AccessControlEnumerable}.
2038  *
2039  * Roles are referred to by their `bytes32` identifier. These should be exposed
2040  * in the external API and be unique. The best way to achieve this is by
2041  * using `public constant` hash digests:
2042  *
2043  * ```
2044  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2045  * ```
2046  *
2047  * Roles can be used to represent a set of permissions. To restrict access to a
2048  * function call, use {hasRole}:
2049  *
2050  * ```
2051  * function foo() public {
2052  *     require(hasRole(MY_ROLE, msg.sender));
2053  *     ...
2054  * }
2055  * ```
2056  *
2057  * Roles can be granted and revoked dynamically via the {grantRole} and
2058  * {revokeRole} functions. Each role has an associated admin role, and only
2059  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2060  *
2061  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2062  * that only accounts with this role will be able to grant or revoke other
2063  * roles. More complex role relationships can be created by using
2064  * {_setRoleAdmin}.
2065  *
2066  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2067  * grant and revoke this role. Extra precautions should be taken to secure
2068  * accounts that have been granted it.
2069  */
2070 abstract contract AccessControl is Context, IAccessControl, ERC165 {
2071     struct RoleData {
2072         mapping(address => bool) members;
2073         bytes32 adminRole;
2074     }
2075 
2076     mapping(bytes32 => RoleData) private _roles;
2077 
2078     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2079 
2080     /**
2081      * @dev Modifier that checks that an account has a specific role. Reverts
2082      * with a standardized message including the required role.
2083      *
2084      * The format of the revert reason is given by the following regular expression:
2085      *
2086      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2087      *
2088      * _Available since v4.1._
2089      */
2090     modifier onlyRole(bytes32 role) {
2091         _checkRole(role);
2092         _;
2093     }
2094 
2095     /**
2096      * @dev See {IERC165-supportsInterface}.
2097      */
2098     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2099         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2100     }
2101 
2102     /**
2103      * @dev Returns `true` if `account` has been granted `role`.
2104      */
2105     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
2106         return _roles[role].members[account];
2107     }
2108 
2109     /**
2110      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
2111      * Overriding this function changes the behavior of the {onlyRole} modifier.
2112      *
2113      * Format of the revert message is described in {_checkRole}.
2114      *
2115      * _Available since v4.6._
2116      */
2117     function _checkRole(bytes32 role) internal view virtual {
2118         _checkRole(role, _msgSender());
2119     }
2120 
2121     /**
2122      * @dev Revert with a standard message if `account` is missing `role`.
2123      *
2124      * The format of the revert reason is given by the following regular expression:
2125      *
2126      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2127      */
2128     function _checkRole(bytes32 role, address account) internal view virtual {
2129         if (!hasRole(role, account)) {
2130             revert(
2131                 string(
2132                     abi.encodePacked(
2133                         "AccessControl: account ",
2134                         Strings.toHexString(uint160(account), 20),
2135                         " is missing role ",
2136                         Strings.toHexString(uint256(role), 32)
2137                     )
2138                 )
2139             );
2140         }
2141     }
2142 
2143     /**
2144      * @dev Returns the admin role that controls `role`. See {grantRole} and
2145      * {revokeRole}.
2146      *
2147      * To change a role's admin, use {_setRoleAdmin}.
2148      */
2149     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
2150         return _roles[role].adminRole;
2151     }
2152 
2153     /**
2154      * @dev Grants `role` to `account`.
2155      *
2156      * If `account` had not been already granted `role`, emits a {RoleGranted}
2157      * event.
2158      *
2159      * Requirements:
2160      *
2161      * - the caller must have ``role``'s admin role.
2162      */
2163     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2164         _grantRole(role, account);
2165     }
2166 
2167     /**
2168      * @dev Revokes `role` from `account`.
2169      *
2170      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2171      *
2172      * Requirements:
2173      *
2174      * - the caller must have ``role``'s admin role.
2175      */
2176     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2177         _revokeRole(role, account);
2178     }
2179 
2180     /**
2181      * @dev Revokes `role` from the calling account.
2182      *
2183      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2184      * purpose is to provide a mechanism for accounts to lose their privileges
2185      * if they are compromised (such as when a trusted device is misplaced).
2186      *
2187      * If the calling account had been revoked `role`, emits a {RoleRevoked}
2188      * event.
2189      *
2190      * Requirements:
2191      *
2192      * - the caller must be `account`.
2193      */
2194     function renounceRole(bytes32 role, address account) public virtual override {
2195         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2196 
2197         _revokeRole(role, account);
2198     }
2199 
2200     /**
2201      * @dev Grants `role` to `account`.
2202      *
2203      * If `account` had not been already granted `role`, emits a {RoleGranted}
2204      * event. Note that unlike {grantRole}, this function doesn't perform any
2205      * checks on the calling account.
2206      *
2207      * [WARNING]
2208      * ====
2209      * This function should only be called from the constructor when setting
2210      * up the initial roles for the system.
2211      *
2212      * Using this function in any other way is effectively circumventing the admin
2213      * system imposed by {AccessControl}.
2214      * ====
2215      *
2216      * NOTE: This function is deprecated in favor of {_grantRole}.
2217      */
2218     function _setupRole(bytes32 role, address account) internal virtual {
2219         _grantRole(role, account);
2220     }
2221 
2222     /**
2223      * @dev Sets `adminRole` as ``role``'s admin role.
2224      *
2225      * Emits a {RoleAdminChanged} event.
2226      */
2227     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2228         bytes32 previousAdminRole = getRoleAdmin(role);
2229         _roles[role].adminRole = adminRole;
2230         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2231     }
2232 
2233     /**
2234      * @dev Grants `role` to `account`.
2235      *
2236      * Internal function without access restriction.
2237      */
2238     function _grantRole(bytes32 role, address account) internal virtual {
2239         if (!hasRole(role, account)) {
2240             _roles[role].members[account] = true;
2241             emit RoleGranted(role, account, _msgSender());
2242         }
2243     }
2244 
2245     /**
2246      * @dev Revokes `role` from `account`.
2247      *
2248      * Internal function without access restriction.
2249      */
2250     function _revokeRole(bytes32 role, address account) internal virtual {
2251         if (hasRole(role, account)) {
2252             _roles[role].members[account] = false;
2253             emit RoleRevoked(role, account, _msgSender());
2254         }
2255     }
2256 }
2257 
2258 
2259 // File contracts/lighthouse.sol
2260 
2261 
2262 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
2263 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
2264 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
2265 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
2266 
2267 pragma solidity 0.8.13;
2268 
2269 contract Lighthouse is AccessControl {
2270     bytes32 public constant DEPLOYER_ROLE = keccak256("DEPLOYER");
2271     string public constant MODEL = "SBII-Lighthouse-test";
2272 
2273     event newContract(address ad, string name, string contractType);
2274     mapping(string => mapping(string => address)) public projectAddress;
2275     mapping(string => address) public nameOwner;
2276     mapping(address => string[]) private registeredProject;
2277 
2278     constructor() {
2279         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2280     }
2281 
2282     function listRegistered(address wallet)
2283         public
2284         view
2285         returns (string[] memory)
2286     {
2287         return registeredProject[wallet];
2288     }
2289 
2290     function registerContract(
2291         string memory name,
2292         address target,
2293         string memory contractType,
2294         address requester
2295     ) public onlyRole(DEPLOYER_ROLE) {
2296         if (nameOwner[name] == address(0)) {
2297             nameOwner[name] = requester;
2298             registeredProject[requester].push(name);
2299         } else {
2300             require(nameOwner[name] == requester, "taken");
2301         }
2302         require(projectAddress[name][contractType] == address(0), "taken");
2303         projectAddress[name][contractType] = target;
2304         emit newContract(target, name, contractType);
2305     }
2306 
2307     function giveUpContract(string memory name, string memory contractType)
2308         public
2309     {
2310         require(nameOwner[name] == msg.sender, "not your name");
2311         projectAddress[name][contractType] = address(0);
2312     }
2313 
2314     function giveUpName(string memory name) public {
2315         require(nameOwner[name] == msg.sender, "not your name");
2316         nameOwner[name] = address(0);
2317     }
2318 
2319     function yeetContract(string memory name, string memory contractType)
2320         public
2321         onlyRole(DEFAULT_ADMIN_ROLE)
2322     {
2323         projectAddress[name][contractType] = address(0);
2324     }
2325 
2326     function yeetName(string memory name) public onlyRole(DEFAULT_ADMIN_ROLE) {
2327         nameOwner[name] = address(0);
2328     }
2329 }
2330 
2331 
2332 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.6.0
2333 
2334 
2335 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
2336 
2337 pragma solidity ^0.8.0;
2338 
2339 /**
2340  * @dev Interface of the ERC20 standard as defined in the EIP.
2341  */
2342 interface IERC20 {
2343     /**
2344      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2345      * another (`to`).
2346      *
2347      * Note that `value` may be zero.
2348      */
2349     event Transfer(address indexed from, address indexed to, uint256 value);
2350 
2351     /**
2352      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2353      * a call to {approve}. `value` is the new allowance.
2354      */
2355     event Approval(address indexed owner, address indexed spender, uint256 value);
2356 
2357     /**
2358      * @dev Returns the amount of tokens in existence.
2359      */
2360     function totalSupply() external view returns (uint256);
2361 
2362     /**
2363      * @dev Returns the amount of tokens owned by `account`.
2364      */
2365     function balanceOf(address account) external view returns (uint256);
2366 
2367     /**
2368      * @dev Moves `amount` tokens from the caller's account to `to`.
2369      *
2370      * Returns a boolean value indicating whether the operation succeeded.
2371      *
2372      * Emits a {Transfer} event.
2373      */
2374     function transfer(address to, uint256 amount) external returns (bool);
2375 
2376     /**
2377      * @dev Returns the remaining number of tokens that `spender` will be
2378      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2379      * zero by default.
2380      *
2381      * This value changes when {approve} or {transferFrom} are called.
2382      */
2383     function allowance(address owner, address spender) external view returns (uint256);
2384 
2385     /**
2386      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2387      *
2388      * Returns a boolean value indicating whether the operation succeeded.
2389      *
2390      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2391      * that someone may use both the old and the new allowance by unfortunate
2392      * transaction ordering. One possible solution to mitigate this race
2393      * condition is to first reduce the spender's allowance to 0 and set the
2394      * desired value afterwards:
2395      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2396      *
2397      * Emits an {Approval} event.
2398      */
2399     function approve(address spender, uint256 amount) external returns (bool);
2400 
2401     /**
2402      * @dev Moves `amount` tokens from `from` to `to` using the
2403      * allowance mechanism. `amount` is then deducted from the caller's
2404      * allowance.
2405      *
2406      * Returns a boolean value indicating whether the operation succeeded.
2407      *
2408      * Emits a {Transfer} event.
2409      */
2410     function transferFrom(
2411         address from,
2412         address to,
2413         uint256 amount
2414     ) external returns (bool);
2415 }
2416 
2417 
2418 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.6.0
2419 
2420 
2421 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
2422 
2423 pragma solidity ^0.8.0;
2424 
2425 
2426 /**
2427  * @title SafeERC20
2428  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2429  * contract returns false). Tokens that return no value (and instead revert or
2430  * throw on failure) are also supported, non-reverting calls are assumed to be
2431  * successful.
2432  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2433  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2434  */
2435 library SafeERC20 {
2436     using Address for address;
2437 
2438     function safeTransfer(
2439         IERC20 token,
2440         address to,
2441         uint256 value
2442     ) internal {
2443         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2444     }
2445 
2446     function safeTransferFrom(
2447         IERC20 token,
2448         address from,
2449         address to,
2450         uint256 value
2451     ) internal {
2452         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2453     }
2454 
2455     /**
2456      * @dev Deprecated. This function has issues similar to the ones found in
2457      * {IERC20-approve}, and its usage is discouraged.
2458      *
2459      * Whenever possible, use {safeIncreaseAllowance} and
2460      * {safeDecreaseAllowance} instead.
2461      */
2462     function safeApprove(
2463         IERC20 token,
2464         address spender,
2465         uint256 value
2466     ) internal {
2467         // safeApprove should only be called when setting an initial allowance,
2468         // or when resetting it to zero. To increase and decrease it, use
2469         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2470         require(
2471             (value == 0) || (token.allowance(address(this), spender) == 0),
2472             "SafeERC20: approve from non-zero to non-zero allowance"
2473         );
2474         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2475     }
2476 
2477     function safeIncreaseAllowance(
2478         IERC20 token,
2479         address spender,
2480         uint256 value
2481     ) internal {
2482         uint256 newAllowance = token.allowance(address(this), spender) + value;
2483         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2484     }
2485 
2486     function safeDecreaseAllowance(
2487         IERC20 token,
2488         address spender,
2489         uint256 value
2490     ) internal {
2491         unchecked {
2492             uint256 oldAllowance = token.allowance(address(this), spender);
2493             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2494             uint256 newAllowance = oldAllowance - value;
2495             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2496         }
2497     }
2498 
2499     /**
2500      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2501      * on the return value: the return value is optional (but if data is returned, it must not be false).
2502      * @param token The token targeted by the call.
2503      * @param data The call data (encoded using abi.encode or one of its variants).
2504      */
2505     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2506         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2507         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2508         // the target address contains contract code and also asserts for success in the low-level call.
2509 
2510         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2511         if (returndata.length > 0) {
2512             // Return data is optional
2513             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2514         }
2515     }
2516 }
2517 
2518 
2519 // File contracts/paymentUtil.sol
2520 
2521 
2522 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
2523 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
2524 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
2525 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
2526 
2527 pragma solidity 0.8.13;
2528 
2529 
2530 library paymentUtil {
2531     using SafeERC20 for IERC20;
2532 
2533     function processPayment(address token, uint256 amount) public {
2534         if (token == address(0)) {
2535             require(msg.value >= amount, "invalid payment");
2536         } else {
2537             IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
2538         }
2539     }
2540 }
2541 
2542 
2543 // File contracts/quartermaster.sol
2544 
2545 
2546 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
2547 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
2548 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
2549 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
2550 
2551 pragma solidity 0.8.13;
2552 
2553 contract Quartermaster is AccessControl {
2554     bytes32 public constant QUATERMASTER_ROLE = keccak256("QUATERMASTER");
2555     string public constant MODEL = "SBII-Quartermaster-test";
2556 
2557     struct Fees {
2558         uint128 onetime;
2559         uint128 bip;
2560         address token;
2561     }
2562     event updateFees(uint128 onetime, uint128 bip, address token);
2563     mapping(bytes32 => Fees) serviceFees;
2564 
2565     constructor() {
2566         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2567         _setupRole(QUATERMASTER_ROLE, msg.sender);
2568     }
2569 
2570     function setFees(
2571         string memory key,
2572         uint128 _onetime,
2573         uint128 _bip,
2574         address _token
2575     ) public onlyRole(QUATERMASTER_ROLE) {
2576         serviceFees[keccak256(abi.encode(key))] = Fees({
2577             onetime: _onetime,
2578             bip: _bip,
2579             token: _token
2580         });
2581         emit updateFees(_onetime, _bip, _token);
2582     }
2583 
2584     function getFees(string memory key) public view returns (Fees memory) {
2585         return serviceFees[keccak256(abi.encode(key))];
2586     }
2587 }
2588 
2589 
2590 // File @openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol@v4.5.2
2591 
2592 
2593 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
2594 
2595 pragma solidity ^0.8.0;
2596 
2597 /**
2598  * @title ERC721 token receiver interface
2599  * @dev Interface for any contract that wants to support safeTransfers
2600  * from ERC721 asset contracts.
2601  */
2602 interface IERC721ReceiverUpgradeable {
2603     /**
2604      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2605      * by `operator` from `from`, this function is called.
2606      *
2607      * It must return its Solidity selector to confirm the token transfer.
2608      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2609      *
2610      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
2611      */
2612     function onERC721Received(
2613         address operator,
2614         address from,
2615         uint256 tokenId,
2616         bytes calldata data
2617     ) external returns (bytes4);
2618 }
2619 
2620 
2621 // File @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol@v4.5.2
2622 
2623 
2624 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
2625 
2626 pragma solidity ^0.8.0;
2627 
2628 /**
2629  * @dev String operations.
2630  */
2631 library StringsUpgradeable {
2632     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2633 
2634     /**
2635      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2636      */
2637     function toString(uint256 value) internal pure returns (string memory) {
2638         // Inspired by OraclizeAPI's implementation - MIT licence
2639         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2640 
2641         if (value == 0) {
2642             return "0";
2643         }
2644         uint256 temp = value;
2645         uint256 digits;
2646         while (temp != 0) {
2647             digits++;
2648             temp /= 10;
2649         }
2650         bytes memory buffer = new bytes(digits);
2651         while (value != 0) {
2652             digits -= 1;
2653             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2654             value /= 10;
2655         }
2656         return string(buffer);
2657     }
2658 
2659     /**
2660      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2661      */
2662     function toHexString(uint256 value) internal pure returns (string memory) {
2663         if (value == 0) {
2664             return "0x00";
2665         }
2666         uint256 temp = value;
2667         uint256 length = 0;
2668         while (temp != 0) {
2669             length++;
2670             temp >>= 8;
2671         }
2672         return toHexString(value, length);
2673     }
2674 
2675     /**
2676      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2677      */
2678     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2679         bytes memory buffer = new bytes(2 * length + 2);
2680         buffer[0] = "0";
2681         buffer[1] = "x";
2682         for (uint256 i = 2 * length + 1; i > 1; --i) {
2683             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2684             value >>= 4;
2685         }
2686         require(value == 0, "Strings: hex length insufficient");
2687         return string(buffer);
2688     }
2689 }
2690 
2691 
2692 // File @openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol@v4.5.2
2693 
2694 
2695 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
2696 
2697 pragma solidity ^0.8.0;
2698 
2699 
2700 
2701 
2702 
2703 
2704 
2705 
2706 /**
2707  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2708  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2709  * {ERC721Enumerable}.
2710  */
2711 contract ERC721Upgradeable is Initializable, ContextUpgradeable, ERC165Upgradeable, IERC721Upgradeable, IERC721MetadataUpgradeable {
2712     using AddressUpgradeable for address;
2713     using StringsUpgradeable for uint256;
2714 
2715     // Token name
2716     string private _name;
2717 
2718     // Token symbol
2719     string private _symbol;
2720 
2721     // Mapping from token ID to owner address
2722     mapping(uint256 => address) private _owners;
2723 
2724     // Mapping owner address to token count
2725     mapping(address => uint256) private _balances;
2726 
2727     // Mapping from token ID to approved address
2728     mapping(uint256 => address) private _tokenApprovals;
2729 
2730     // Mapping from owner to operator approvals
2731     mapping(address => mapping(address => bool)) private _operatorApprovals;
2732 
2733     /**
2734      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2735      */
2736     function __ERC721_init(string memory name_, string memory symbol_) internal onlyInitializing {
2737         __ERC721_init_unchained(name_, symbol_);
2738     }
2739 
2740     function __ERC721_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
2741         _name = name_;
2742         _symbol = symbol_;
2743     }
2744 
2745     /**
2746      * @dev See {IERC165-supportsInterface}.
2747      */
2748     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
2749         return
2750             interfaceId == type(IERC721Upgradeable).interfaceId ||
2751             interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
2752             super.supportsInterface(interfaceId);
2753     }
2754 
2755     /**
2756      * @dev See {IERC721-balanceOf}.
2757      */
2758     function balanceOf(address owner) public view virtual override returns (uint256) {
2759         require(owner != address(0), "ERC721: balance query for the zero address");
2760         return _balances[owner];
2761     }
2762 
2763     /**
2764      * @dev See {IERC721-ownerOf}.
2765      */
2766     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2767         address owner = _owners[tokenId];
2768         require(owner != address(0), "ERC721: owner query for nonexistent token");
2769         return owner;
2770     }
2771 
2772     /**
2773      * @dev See {IERC721Metadata-name}.
2774      */
2775     function name() public view virtual override returns (string memory) {
2776         return _name;
2777     }
2778 
2779     /**
2780      * @dev See {IERC721Metadata-symbol}.
2781      */
2782     function symbol() public view virtual override returns (string memory) {
2783         return _symbol;
2784     }
2785 
2786     /**
2787      * @dev See {IERC721Metadata-tokenURI}.
2788      */
2789     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2790         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2791 
2792         string memory baseURI = _baseURI();
2793         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2794     }
2795 
2796     /**
2797      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2798      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2799      * by default, can be overriden in child contracts.
2800      */
2801     function _baseURI() internal view virtual returns (string memory) {
2802         return "";
2803     }
2804 
2805     /**
2806      * @dev See {IERC721-approve}.
2807      */
2808     function approve(address to, uint256 tokenId) public virtual override {
2809         address owner = ERC721Upgradeable.ownerOf(tokenId);
2810         require(to != owner, "ERC721: approval to current owner");
2811 
2812         require(
2813             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2814             "ERC721: approve caller is not owner nor approved for all"
2815         );
2816 
2817         _approve(to, tokenId);
2818     }
2819 
2820     /**
2821      * @dev See {IERC721-getApproved}.
2822      */
2823     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2824         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2825 
2826         return _tokenApprovals[tokenId];
2827     }
2828 
2829     /**
2830      * @dev See {IERC721-setApprovalForAll}.
2831      */
2832     function setApprovalForAll(address operator, bool approved) public virtual override {
2833         _setApprovalForAll(_msgSender(), operator, approved);
2834     }
2835 
2836     /**
2837      * @dev See {IERC721-isApprovedForAll}.
2838      */
2839     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2840         return _operatorApprovals[owner][operator];
2841     }
2842 
2843     /**
2844      * @dev See {IERC721-transferFrom}.
2845      */
2846     function transferFrom(
2847         address from,
2848         address to,
2849         uint256 tokenId
2850     ) public virtual override {
2851         //solhint-disable-next-line max-line-length
2852         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2853 
2854         _transfer(from, to, tokenId);
2855     }
2856 
2857     /**
2858      * @dev See {IERC721-safeTransferFrom}.
2859      */
2860     function safeTransferFrom(
2861         address from,
2862         address to,
2863         uint256 tokenId
2864     ) public virtual override {
2865         safeTransferFrom(from, to, tokenId, "");
2866     }
2867 
2868     /**
2869      * @dev See {IERC721-safeTransferFrom}.
2870      */
2871     function safeTransferFrom(
2872         address from,
2873         address to,
2874         uint256 tokenId,
2875         bytes memory _data
2876     ) public virtual override {
2877         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2878         _safeTransfer(from, to, tokenId, _data);
2879     }
2880 
2881     /**
2882      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2883      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2884      *
2885      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2886      *
2887      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2888      * implement alternative mechanisms to perform token transfer, such as signature-based.
2889      *
2890      * Requirements:
2891      *
2892      * - `from` cannot be the zero address.
2893      * - `to` cannot be the zero address.
2894      * - `tokenId` token must exist and be owned by `from`.
2895      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2896      *
2897      * Emits a {Transfer} event.
2898      */
2899     function _safeTransfer(
2900         address from,
2901         address to,
2902         uint256 tokenId,
2903         bytes memory _data
2904     ) internal virtual {
2905         _transfer(from, to, tokenId);
2906         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2907     }
2908 
2909     /**
2910      * @dev Returns whether `tokenId` exists.
2911      *
2912      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2913      *
2914      * Tokens start existing when they are minted (`_mint`),
2915      * and stop existing when they are burned (`_burn`).
2916      */
2917     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2918         return _owners[tokenId] != address(0);
2919     }
2920 
2921     /**
2922      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2923      *
2924      * Requirements:
2925      *
2926      * - `tokenId` must exist.
2927      */
2928     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2929         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2930         address owner = ERC721Upgradeable.ownerOf(tokenId);
2931         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2932     }
2933 
2934     /**
2935      * @dev Safely mints `tokenId` and transfers it to `to`.
2936      *
2937      * Requirements:
2938      *
2939      * - `tokenId` must not exist.
2940      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2941      *
2942      * Emits a {Transfer} event.
2943      */
2944     function _safeMint(address to, uint256 tokenId) internal virtual {
2945         _safeMint(to, tokenId, "");
2946     }
2947 
2948     /**
2949      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2950      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2951      */
2952     function _safeMint(
2953         address to,
2954         uint256 tokenId,
2955         bytes memory _data
2956     ) internal virtual {
2957         _mint(to, tokenId);
2958         require(
2959             _checkOnERC721Received(address(0), to, tokenId, _data),
2960             "ERC721: transfer to non ERC721Receiver implementer"
2961         );
2962     }
2963 
2964     /**
2965      * @dev Mints `tokenId` and transfers it to `to`.
2966      *
2967      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2968      *
2969      * Requirements:
2970      *
2971      * - `tokenId` must not exist.
2972      * - `to` cannot be the zero address.
2973      *
2974      * Emits a {Transfer} event.
2975      */
2976     function _mint(address to, uint256 tokenId) internal virtual {
2977         require(to != address(0), "ERC721: mint to the zero address");
2978         require(!_exists(tokenId), "ERC721: token already minted");
2979 
2980         _beforeTokenTransfer(address(0), to, tokenId);
2981 
2982         _balances[to] += 1;
2983         _owners[tokenId] = to;
2984 
2985         emit Transfer(address(0), to, tokenId);
2986 
2987         _afterTokenTransfer(address(0), to, tokenId);
2988     }
2989 
2990     /**
2991      * @dev Destroys `tokenId`.
2992      * The approval is cleared when the token is burned.
2993      *
2994      * Requirements:
2995      *
2996      * - `tokenId` must exist.
2997      *
2998      * Emits a {Transfer} event.
2999      */
3000     function _burn(uint256 tokenId) internal virtual {
3001         address owner = ERC721Upgradeable.ownerOf(tokenId);
3002 
3003         _beforeTokenTransfer(owner, address(0), tokenId);
3004 
3005         // Clear approvals
3006         _approve(address(0), tokenId);
3007 
3008         _balances[owner] -= 1;
3009         delete _owners[tokenId];
3010 
3011         emit Transfer(owner, address(0), tokenId);
3012 
3013         _afterTokenTransfer(owner, address(0), tokenId);
3014     }
3015 
3016     /**
3017      * @dev Transfers `tokenId` from `from` to `to`.
3018      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
3019      *
3020      * Requirements:
3021      *
3022      * - `to` cannot be the zero address.
3023      * - `tokenId` token must be owned by `from`.
3024      *
3025      * Emits a {Transfer} event.
3026      */
3027     function _transfer(
3028         address from,
3029         address to,
3030         uint256 tokenId
3031     ) internal virtual {
3032         require(ERC721Upgradeable.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3033         require(to != address(0), "ERC721: transfer to the zero address");
3034 
3035         _beforeTokenTransfer(from, to, tokenId);
3036 
3037         // Clear approvals from the previous owner
3038         _approve(address(0), tokenId);
3039 
3040         _balances[from] -= 1;
3041         _balances[to] += 1;
3042         _owners[tokenId] = to;
3043 
3044         emit Transfer(from, to, tokenId);
3045 
3046         _afterTokenTransfer(from, to, tokenId);
3047     }
3048 
3049     /**
3050      * @dev Approve `to` to operate on `tokenId`
3051      *
3052      * Emits a {Approval} event.
3053      */
3054     function _approve(address to, uint256 tokenId) internal virtual {
3055         _tokenApprovals[tokenId] = to;
3056         emit Approval(ERC721Upgradeable.ownerOf(tokenId), to, tokenId);
3057     }
3058 
3059     /**
3060      * @dev Approve `operator` to operate on all of `owner` tokens
3061      *
3062      * Emits a {ApprovalForAll} event.
3063      */
3064     function _setApprovalForAll(
3065         address owner,
3066         address operator,
3067         bool approved
3068     ) internal virtual {
3069         require(owner != operator, "ERC721: approve to caller");
3070         _operatorApprovals[owner][operator] = approved;
3071         emit ApprovalForAll(owner, operator, approved);
3072     }
3073 
3074     /**
3075      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3076      * The call is not executed if the target address is not a contract.
3077      *
3078      * @param from address representing the previous owner of the given token ID
3079      * @param to target address that will receive the tokens
3080      * @param tokenId uint256 ID of the token to be transferred
3081      * @param _data bytes optional data to send along with the call
3082      * @return bool whether the call correctly returned the expected magic value
3083      */
3084     function _checkOnERC721Received(
3085         address from,
3086         address to,
3087         uint256 tokenId,
3088         bytes memory _data
3089     ) private returns (bool) {
3090         if (to.isContract()) {
3091             try IERC721ReceiverUpgradeable(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
3092                 return retval == IERC721ReceiverUpgradeable.onERC721Received.selector;
3093             } catch (bytes memory reason) {
3094                 if (reason.length == 0) {
3095                     revert("ERC721: transfer to non ERC721Receiver implementer");
3096                 } else {
3097                     assembly {
3098                         revert(add(32, reason), mload(reason))
3099                     }
3100                 }
3101             }
3102         } else {
3103             return true;
3104         }
3105     }
3106 
3107     /**
3108      * @dev Hook that is called before any token transfer. This includes minting
3109      * and burning.
3110      *
3111      * Calling conditions:
3112      *
3113      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3114      * transferred to `to`.
3115      * - When `from` is zero, `tokenId` will be minted for `to`.
3116      * - When `to` is zero, ``from``'s `tokenId` will be burned.
3117      * - `from` and `to` are never both zero.
3118      *
3119      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3120      */
3121     function _beforeTokenTransfer(
3122         address from,
3123         address to,
3124         uint256 tokenId
3125     ) internal virtual {}
3126 
3127     /**
3128      * @dev Hook that is called after any transfer of tokens. This includes
3129      * minting and burning.
3130      *
3131      * Calling conditions:
3132      *
3133      * - when `from` and `to` are both non-zero.
3134      * - `from` and `to` are never both zero.
3135      *
3136      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3137      */
3138     function _afterTokenTransfer(
3139         address from,
3140         address to,
3141         uint256 tokenId
3142     ) internal virtual {}
3143 
3144     /**
3145      * @dev This empty reserved space is put in place to allow future versions to add new
3146      * variables without shifting down storage in the inheritance chain.
3147      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3148      */
3149     uint256[44] private __gap;
3150 }
3151 
3152 
3153 // File @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol@v4.5.2
3154 
3155 
3156 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
3157 
3158 pragma solidity ^0.8.0;
3159 
3160 /**
3161  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
3162  * @dev See https://eips.ethereum.org/EIPS/eip-721
3163  */
3164 interface IERC721EnumerableUpgradeable is IERC721Upgradeable {
3165     /**
3166      * @dev Returns the total amount of tokens stored by the contract.
3167      */
3168     function totalSupply() external view returns (uint256);
3169 
3170     /**
3171      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
3172      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
3173      */
3174     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
3175 
3176     /**
3177      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
3178      * Use along with {totalSupply} to enumerate all tokens.
3179      */
3180     function tokenByIndex(uint256 index) external view returns (uint256);
3181 }
3182 
3183 
3184 // File @openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol@v4.5.2
3185 
3186 
3187 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
3188 
3189 pragma solidity ^0.8.0;
3190 
3191 
3192 
3193 /**
3194  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
3195  * enumerability of all the token ids in the contract as well as all token ids owned by each
3196  * account.
3197  */
3198 abstract contract ERC721EnumerableUpgradeable is Initializable, ERC721Upgradeable, IERC721EnumerableUpgradeable {
3199     function __ERC721Enumerable_init() internal onlyInitializing {
3200     }
3201 
3202     function __ERC721Enumerable_init_unchained() internal onlyInitializing {
3203     }
3204     // Mapping from owner to list of owned token IDs
3205     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
3206 
3207     // Mapping from token ID to index of the owner tokens list
3208     mapping(uint256 => uint256) private _ownedTokensIndex;
3209 
3210     // Array with all token ids, used for enumeration
3211     uint256[] private _allTokens;
3212 
3213     // Mapping from token id to position in the allTokens array
3214     mapping(uint256 => uint256) private _allTokensIndex;
3215 
3216     /**
3217      * @dev See {IERC165-supportsInterface}.
3218      */
3219     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165Upgradeable, ERC721Upgradeable) returns (bool) {
3220         return interfaceId == type(IERC721EnumerableUpgradeable).interfaceId || super.supportsInterface(interfaceId);
3221     }
3222 
3223     /**
3224      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
3225      */
3226     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
3227         require(index < ERC721Upgradeable.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
3228         return _ownedTokens[owner][index];
3229     }
3230 
3231     /**
3232      * @dev See {IERC721Enumerable-totalSupply}.
3233      */
3234     function totalSupply() public view virtual override returns (uint256) {
3235         return _allTokens.length;
3236     }
3237 
3238     /**
3239      * @dev See {IERC721Enumerable-tokenByIndex}.
3240      */
3241     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
3242         require(index < ERC721EnumerableUpgradeable.totalSupply(), "ERC721Enumerable: global index out of bounds");
3243         return _allTokens[index];
3244     }
3245 
3246     /**
3247      * @dev Hook that is called before any token transfer. This includes minting
3248      * and burning.
3249      *
3250      * Calling conditions:
3251      *
3252      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3253      * transferred to `to`.
3254      * - When `from` is zero, `tokenId` will be minted for `to`.
3255      * - When `to` is zero, ``from``'s `tokenId` will be burned.
3256      * - `from` cannot be the zero address.
3257      * - `to` cannot be the zero address.
3258      *
3259      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3260      */
3261     function _beforeTokenTransfer(
3262         address from,
3263         address to,
3264         uint256 tokenId
3265     ) internal virtual override {
3266         super._beforeTokenTransfer(from, to, tokenId);
3267 
3268         if (from == address(0)) {
3269             _addTokenToAllTokensEnumeration(tokenId);
3270         } else if (from != to) {
3271             _removeTokenFromOwnerEnumeration(from, tokenId);
3272         }
3273         if (to == address(0)) {
3274             _removeTokenFromAllTokensEnumeration(tokenId);
3275         } else if (to != from) {
3276             _addTokenToOwnerEnumeration(to, tokenId);
3277         }
3278     }
3279 
3280     /**
3281      * @dev Private function to add a token to this extension's ownership-tracking data structures.
3282      * @param to address representing the new owner of the given token ID
3283      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
3284      */
3285     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
3286         uint256 length = ERC721Upgradeable.balanceOf(to);
3287         _ownedTokens[to][length] = tokenId;
3288         _ownedTokensIndex[tokenId] = length;
3289     }
3290 
3291     /**
3292      * @dev Private function to add a token to this extension's token tracking data structures.
3293      * @param tokenId uint256 ID of the token to be added to the tokens list
3294      */
3295     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
3296         _allTokensIndex[tokenId] = _allTokens.length;
3297         _allTokens.push(tokenId);
3298     }
3299 
3300     /**
3301      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
3302      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
3303      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
3304      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
3305      * @param from address representing the previous owner of the given token ID
3306      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
3307      */
3308     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
3309         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
3310         // then delete the last slot (swap and pop).
3311 
3312         uint256 lastTokenIndex = ERC721Upgradeable.balanceOf(from) - 1;
3313         uint256 tokenIndex = _ownedTokensIndex[tokenId];
3314 
3315         // When the token to delete is the last token, the swap operation is unnecessary
3316         if (tokenIndex != lastTokenIndex) {
3317             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
3318 
3319             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3320             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3321         }
3322 
3323         // This also deletes the contents at the last position of the array
3324         delete _ownedTokensIndex[tokenId];
3325         delete _ownedTokens[from][lastTokenIndex];
3326     }
3327 
3328     /**
3329      * @dev Private function to remove a token from this extension's token tracking data structures.
3330      * This has O(1) time complexity, but alters the order of the _allTokens array.
3331      * @param tokenId uint256 ID of the token to be removed from the tokens list
3332      */
3333     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
3334         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
3335         // then delete the last slot (swap and pop).
3336 
3337         uint256 lastTokenIndex = _allTokens.length - 1;
3338         uint256 tokenIndex = _allTokensIndex[tokenId];
3339 
3340         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
3341         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
3342         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
3343         uint256 lastTokenId = _allTokens[lastTokenIndex];
3344 
3345         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3346         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3347 
3348         // This also deletes the contents at the last position of the array
3349         delete _allTokensIndex[tokenId];
3350         _allTokens.pop();
3351     }
3352 
3353     /**
3354      * @dev This empty reserved space is put in place to allow future versions to add new
3355      * variables without shifting down storage in the inheritance chain.
3356      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3357      */
3358     uint256[46] private __gap;
3359 }
3360 
3361 
3362 // File @openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol@v4.5.2
3363 
3364 
3365 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
3366 
3367 pragma solidity ^0.8.0;
3368 
3369 /**
3370  * @dev Contract module that helps prevent reentrant calls to a function.
3371  *
3372  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
3373  * available, which can be applied to functions to make sure there are no nested
3374  * (reentrant) calls to them.
3375  *
3376  * Note that because there is a single `nonReentrant` guard, functions marked as
3377  * `nonReentrant` may not call one another. This can be worked around by making
3378  * those functions `private`, and then adding `external` `nonReentrant` entry
3379  * points to them.
3380  *
3381  * TIP: If you would like to learn more about reentrancy and alternative ways
3382  * to protect against it, check out our blog post
3383  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
3384  */
3385 abstract contract ReentrancyGuardUpgradeable is Initializable {
3386     // Booleans are more expensive than uint256 or any type that takes up a full
3387     // word because each write operation emits an extra SLOAD to first read the
3388     // slot's contents, replace the bits taken up by the boolean, and then write
3389     // back. This is the compiler's defense against contract upgrades and
3390     // pointer aliasing, and it cannot be disabled.
3391 
3392     // The values being non-zero value makes deployment a bit more expensive,
3393     // but in exchange the refund on every call to nonReentrant will be lower in
3394     // amount. Since refunds are capped to a percentage of the total
3395     // transaction's gas, it is best to keep them low in cases like this one, to
3396     // increase the likelihood of the full refund coming into effect.
3397     uint256 private constant _NOT_ENTERED = 1;
3398     uint256 private constant _ENTERED = 2;
3399 
3400     uint256 private _status;
3401 
3402     function __ReentrancyGuard_init() internal onlyInitializing {
3403         __ReentrancyGuard_init_unchained();
3404     }
3405 
3406     function __ReentrancyGuard_init_unchained() internal onlyInitializing {
3407         _status = _NOT_ENTERED;
3408     }
3409 
3410     /**
3411      * @dev Prevents a contract from calling itself, directly or indirectly.
3412      * Calling a `nonReentrant` function from another `nonReentrant`
3413      * function is not supported. It is possible to prevent this from happening
3414      * by making the `nonReentrant` function external, and making it call a
3415      * `private` function that does the actual work.
3416      */
3417     modifier nonReentrant() {
3418         // On the first call to nonReentrant, _notEntered will be true
3419         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
3420 
3421         // Any calls to nonReentrant after this point will fail
3422         _status = _ENTERED;
3423 
3424         _;
3425 
3426         // By storing the original value once again, a refund is triggered (see
3427         // https://eips.ethereum.org/EIPS/eip-2200)
3428         _status = _NOT_ENTERED;
3429     }
3430 
3431     /**
3432      * @dev This empty reserved space is put in place to allow future versions to add new
3433      * variables without shifting down storage in the inheritance chain.
3434      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3435      */
3436     uint256[49] private __gap;
3437 }
3438 
3439 
3440 // File @openzeppelin/contracts-upgradeable/access/IAccessControlUpgradeable.sol@v4.5.2
3441 
3442 
3443 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
3444 
3445 pragma solidity ^0.8.0;
3446 
3447 /**
3448  * @dev External interface of AccessControl declared to support ERC165 detection.
3449  */
3450 interface IAccessControlUpgradeable {
3451     /**
3452      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
3453      *
3454      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
3455      * {RoleAdminChanged} not being emitted signaling this.
3456      *
3457      * _Available since v3.1._
3458      */
3459     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
3460 
3461     /**
3462      * @dev Emitted when `account` is granted `role`.
3463      *
3464      * `sender` is the account that originated the contract call, an admin role
3465      * bearer except when using {AccessControl-_setupRole}.
3466      */
3467     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
3468 
3469     /**
3470      * @dev Emitted when `account` is revoked `role`.
3471      *
3472      * `sender` is the account that originated the contract call:
3473      *   - if using `revokeRole`, it is the admin role bearer
3474      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
3475      */
3476     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
3477 
3478     /**
3479      * @dev Returns `true` if `account` has been granted `role`.
3480      */
3481     function hasRole(bytes32 role, address account) external view returns (bool);
3482 
3483     /**
3484      * @dev Returns the admin role that controls `role`. See {grantRole} and
3485      * {revokeRole}.
3486      *
3487      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
3488      */
3489     function getRoleAdmin(bytes32 role) external view returns (bytes32);
3490 
3491     /**
3492      * @dev Grants `role` to `account`.
3493      *
3494      * If `account` had not been already granted `role`, emits a {RoleGranted}
3495      * event.
3496      *
3497      * Requirements:
3498      *
3499      * - the caller must have ``role``'s admin role.
3500      */
3501     function grantRole(bytes32 role, address account) external;
3502 
3503     /**
3504      * @dev Revokes `role` from `account`.
3505      *
3506      * If `account` had been granted `role`, emits a {RoleRevoked} event.
3507      *
3508      * Requirements:
3509      *
3510      * - the caller must have ``role``'s admin role.
3511      */
3512     function revokeRole(bytes32 role, address account) external;
3513 
3514     /**
3515      * @dev Revokes `role` from the calling account.
3516      *
3517      * Roles are often managed via {grantRole} and {revokeRole}: this function's
3518      * purpose is to provide a mechanism for accounts to lose their privileges
3519      * if they are compromised (such as when a trusted device is misplaced).
3520      *
3521      * If the calling account had been granted `role`, emits a {RoleRevoked}
3522      * event.
3523      *
3524      * Requirements:
3525      *
3526      * - the caller must be `account`.
3527      */
3528     function renounceRole(bytes32 role, address account) external;
3529 }
3530 
3531 
3532 // File @openzeppelin/contracts-upgradeable/access/IAccessControlEnumerableUpgradeable.sol@v4.5.2
3533 
3534 
3535 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
3536 
3537 pragma solidity ^0.8.0;
3538 
3539 /**
3540  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
3541  */
3542 interface IAccessControlEnumerableUpgradeable is IAccessControlUpgradeable {
3543     /**
3544      * @dev Returns one of the accounts that have `role`. `index` must be a
3545      * value between 0 and {getRoleMemberCount}, non-inclusive.
3546      *
3547      * Role bearers are not sorted in any particular way, and their ordering may
3548      * change at any point.
3549      *
3550      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
3551      * you perform all queries on the same block. See the following
3552      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
3553      * for more information.
3554      */
3555     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
3556 
3557     /**
3558      * @dev Returns the number of accounts that have `role`. Can be used
3559      * together with {getRoleMember} to enumerate all bearers of a role.
3560      */
3561     function getRoleMemberCount(bytes32 role) external view returns (uint256);
3562 }
3563 
3564 
3565 // File @openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol@v4.5.2
3566 
3567 
3568 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
3569 
3570 pragma solidity ^0.8.0;
3571 
3572 
3573 
3574 
3575 
3576 /**
3577  * @dev Contract module that allows children to implement role-based access
3578  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
3579  * members except through off-chain means by accessing the contract event logs. Some
3580  * applications may benefit from on-chain enumerability, for those cases see
3581  * {AccessControlEnumerable}.
3582  *
3583  * Roles are referred to by their `bytes32` identifier. These should be exposed
3584  * in the external API and be unique. The best way to achieve this is by
3585  * using `public constant` hash digests:
3586  *
3587  * ```
3588  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
3589  * ```
3590  *
3591  * Roles can be used to represent a set of permissions. To restrict access to a
3592  * function call, use {hasRole}:
3593  *
3594  * ```
3595  * function foo() public {
3596  *     require(hasRole(MY_ROLE, msg.sender));
3597  *     ...
3598  * }
3599  * ```
3600  *
3601  * Roles can be granted and revoked dynamically via the {grantRole} and
3602  * {revokeRole} functions. Each role has an associated admin role, and only
3603  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
3604  *
3605  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
3606  * that only accounts with this role will be able to grant or revoke other
3607  * roles. More complex role relationships can be created by using
3608  * {_setRoleAdmin}.
3609  *
3610  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
3611  * grant and revoke this role. Extra precautions should be taken to secure
3612  * accounts that have been granted it.
3613  */
3614 abstract contract AccessControlUpgradeable is Initializable, ContextUpgradeable, IAccessControlUpgradeable, ERC165Upgradeable {
3615     function __AccessControl_init() internal onlyInitializing {
3616     }
3617 
3618     function __AccessControl_init_unchained() internal onlyInitializing {
3619     }
3620     struct RoleData {
3621         mapping(address => bool) members;
3622         bytes32 adminRole;
3623     }
3624 
3625     mapping(bytes32 => RoleData) private _roles;
3626 
3627     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
3628 
3629     /**
3630      * @dev Modifier that checks that an account has a specific role. Reverts
3631      * with a standardized message including the required role.
3632      *
3633      * The format of the revert reason is given by the following regular expression:
3634      *
3635      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
3636      *
3637      * _Available since v4.1._
3638      */
3639     modifier onlyRole(bytes32 role) {
3640         _checkRole(role, _msgSender());
3641         _;
3642     }
3643 
3644     /**
3645      * @dev See {IERC165-supportsInterface}.
3646      */
3647     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
3648         return interfaceId == type(IAccessControlUpgradeable).interfaceId || super.supportsInterface(interfaceId);
3649     }
3650 
3651     /**
3652      * @dev Returns `true` if `account` has been granted `role`.
3653      */
3654     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
3655         return _roles[role].members[account];
3656     }
3657 
3658     /**
3659      * @dev Revert with a standard message if `account` is missing `role`.
3660      *
3661      * The format of the revert reason is given by the following regular expression:
3662      *
3663      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
3664      */
3665     function _checkRole(bytes32 role, address account) internal view virtual {
3666         if (!hasRole(role, account)) {
3667             revert(
3668                 string(
3669                     abi.encodePacked(
3670                         "AccessControl: account ",
3671                         StringsUpgradeable.toHexString(uint160(account), 20),
3672                         " is missing role ",
3673                         StringsUpgradeable.toHexString(uint256(role), 32)
3674                     )
3675                 )
3676             );
3677         }
3678     }
3679 
3680     /**
3681      * @dev Returns the admin role that controls `role`. See {grantRole} and
3682      * {revokeRole}.
3683      *
3684      * To change a role's admin, use {_setRoleAdmin}.
3685      */
3686     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
3687         return _roles[role].adminRole;
3688     }
3689 
3690     /**
3691      * @dev Grants `role` to `account`.
3692      *
3693      * If `account` had not been already granted `role`, emits a {RoleGranted}
3694      * event.
3695      *
3696      * Requirements:
3697      *
3698      * - the caller must have ``role``'s admin role.
3699      */
3700     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
3701         _grantRole(role, account);
3702     }
3703 
3704     /**
3705      * @dev Revokes `role` from `account`.
3706      *
3707      * If `account` had been granted `role`, emits a {RoleRevoked} event.
3708      *
3709      * Requirements:
3710      *
3711      * - the caller must have ``role``'s admin role.
3712      */
3713     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
3714         _revokeRole(role, account);
3715     }
3716 
3717     /**
3718      * @dev Revokes `role` from the calling account.
3719      *
3720      * Roles are often managed via {grantRole} and {revokeRole}: this function's
3721      * purpose is to provide a mechanism for accounts to lose their privileges
3722      * if they are compromised (such as when a trusted device is misplaced).
3723      *
3724      * If the calling account had been revoked `role`, emits a {RoleRevoked}
3725      * event.
3726      *
3727      * Requirements:
3728      *
3729      * - the caller must be `account`.
3730      */
3731     function renounceRole(bytes32 role, address account) public virtual override {
3732         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
3733 
3734         _revokeRole(role, account);
3735     }
3736 
3737     /**
3738      * @dev Grants `role` to `account`.
3739      *
3740      * If `account` had not been already granted `role`, emits a {RoleGranted}
3741      * event. Note that unlike {grantRole}, this function doesn't perform any
3742      * checks on the calling account.
3743      *
3744      * [WARNING]
3745      * ====
3746      * This function should only be called from the constructor when setting
3747      * up the initial roles for the system.
3748      *
3749      * Using this function in any other way is effectively circumventing the admin
3750      * system imposed by {AccessControl}.
3751      * ====
3752      *
3753      * NOTE: This function is deprecated in favor of {_grantRole}.
3754      */
3755     function _setupRole(bytes32 role, address account) internal virtual {
3756         _grantRole(role, account);
3757     }
3758 
3759     /**
3760      * @dev Sets `adminRole` as ``role``'s admin role.
3761      *
3762      * Emits a {RoleAdminChanged} event.
3763      */
3764     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
3765         bytes32 previousAdminRole = getRoleAdmin(role);
3766         _roles[role].adminRole = adminRole;
3767         emit RoleAdminChanged(role, previousAdminRole, adminRole);
3768     }
3769 
3770     /**
3771      * @dev Grants `role` to `account`.
3772      *
3773      * Internal function without access restriction.
3774      */
3775     function _grantRole(bytes32 role, address account) internal virtual {
3776         if (!hasRole(role, account)) {
3777             _roles[role].members[account] = true;
3778             emit RoleGranted(role, account, _msgSender());
3779         }
3780     }
3781 
3782     /**
3783      * @dev Revokes `role` from `account`.
3784      *
3785      * Internal function without access restriction.
3786      */
3787     function _revokeRole(bytes32 role, address account) internal virtual {
3788         if (hasRole(role, account)) {
3789             _roles[role].members[account] = false;
3790             emit RoleRevoked(role, account, _msgSender());
3791         }
3792     }
3793 
3794     /**
3795      * @dev This empty reserved space is put in place to allow future versions to add new
3796      * variables without shifting down storage in the inheritance chain.
3797      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3798      */
3799     uint256[49] private __gap;
3800 }
3801 
3802 
3803 // File @openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol@v4.5.2
3804 
3805 
3806 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
3807 
3808 pragma solidity ^0.8.0;
3809 
3810 /**
3811  * @dev Library for managing
3812  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
3813  * types.
3814  *
3815  * Sets have the following properties:
3816  *
3817  * - Elements are added, removed, and checked for existence in constant time
3818  * (O(1)).
3819  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
3820  *
3821  * ```
3822  * contract Example {
3823  *     // Add the library methods
3824  *     using EnumerableSet for EnumerableSet.AddressSet;
3825  *
3826  *     // Declare a set state variable
3827  *     EnumerableSet.AddressSet private mySet;
3828  * }
3829  * ```
3830  *
3831  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
3832  * and `uint256` (`UintSet`) are supported.
3833  */
3834 library EnumerableSetUpgradeable {
3835     // To implement this library for multiple types with as little code
3836     // repetition as possible, we write it in terms of a generic Set type with
3837     // bytes32 values.
3838     // The Set implementation uses private functions, and user-facing
3839     // implementations (such as AddressSet) are just wrappers around the
3840     // underlying Set.
3841     // This means that we can only create new EnumerableSets for types that fit
3842     // in bytes32.
3843 
3844     struct Set {
3845         // Storage of set values
3846         bytes32[] _values;
3847         // Position of the value in the `values` array, plus 1 because index 0
3848         // means a value is not in the set.
3849         mapping(bytes32 => uint256) _indexes;
3850     }
3851 
3852     /**
3853      * @dev Add a value to a set. O(1).
3854      *
3855      * Returns true if the value was added to the set, that is if it was not
3856      * already present.
3857      */
3858     function _add(Set storage set, bytes32 value) private returns (bool) {
3859         if (!_contains(set, value)) {
3860             set._values.push(value);
3861             // The value is stored at length-1, but we add 1 to all indexes
3862             // and use 0 as a sentinel value
3863             set._indexes[value] = set._values.length;
3864             return true;
3865         } else {
3866             return false;
3867         }
3868     }
3869 
3870     /**
3871      * @dev Removes a value from a set. O(1).
3872      *
3873      * Returns true if the value was removed from the set, that is if it was
3874      * present.
3875      */
3876     function _remove(Set storage set, bytes32 value) private returns (bool) {
3877         // We read and store the value's index to prevent multiple reads from the same storage slot
3878         uint256 valueIndex = set._indexes[value];
3879 
3880         if (valueIndex != 0) {
3881             // Equivalent to contains(set, value)
3882             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
3883             // the array, and then remove the last element (sometimes called as 'swap and pop').
3884             // This modifies the order of the array, as noted in {at}.
3885 
3886             uint256 toDeleteIndex = valueIndex - 1;
3887             uint256 lastIndex = set._values.length - 1;
3888 
3889             if (lastIndex != toDeleteIndex) {
3890                 bytes32 lastvalue = set._values[lastIndex];
3891 
3892                 // Move the last value to the index where the value to delete is
3893                 set._values[toDeleteIndex] = lastvalue;
3894                 // Update the index for the moved value
3895                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
3896             }
3897 
3898             // Delete the slot where the moved value was stored
3899             set._values.pop();
3900 
3901             // Delete the index for the deleted slot
3902             delete set._indexes[value];
3903 
3904             return true;
3905         } else {
3906             return false;
3907         }
3908     }
3909 
3910     /**
3911      * @dev Returns true if the value is in the set. O(1).
3912      */
3913     function _contains(Set storage set, bytes32 value) private view returns (bool) {
3914         return set._indexes[value] != 0;
3915     }
3916 
3917     /**
3918      * @dev Returns the number of values on the set. O(1).
3919      */
3920     function _length(Set storage set) private view returns (uint256) {
3921         return set._values.length;
3922     }
3923 
3924     /**
3925      * @dev Returns the value stored at position `index` in the set. O(1).
3926      *
3927      * Note that there are no guarantees on the ordering of values inside the
3928      * array, and it may change when more values are added or removed.
3929      *
3930      * Requirements:
3931      *
3932      * - `index` must be strictly less than {length}.
3933      */
3934     function _at(Set storage set, uint256 index) private view returns (bytes32) {
3935         return set._values[index];
3936     }
3937 
3938     /**
3939      * @dev Return the entire set in an array
3940      *
3941      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
3942      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
3943      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
3944      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
3945      */
3946     function _values(Set storage set) private view returns (bytes32[] memory) {
3947         return set._values;
3948     }
3949 
3950     // Bytes32Set
3951 
3952     struct Bytes32Set {
3953         Set _inner;
3954     }
3955 
3956     /**
3957      * @dev Add a value to a set. O(1).
3958      *
3959      * Returns true if the value was added to the set, that is if it was not
3960      * already present.
3961      */
3962     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
3963         return _add(set._inner, value);
3964     }
3965 
3966     /**
3967      * @dev Removes a value from a set. O(1).
3968      *
3969      * Returns true if the value was removed from the set, that is if it was
3970      * present.
3971      */
3972     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
3973         return _remove(set._inner, value);
3974     }
3975 
3976     /**
3977      * @dev Returns true if the value is in the set. O(1).
3978      */
3979     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
3980         return _contains(set._inner, value);
3981     }
3982 
3983     /**
3984      * @dev Returns the number of values in the set. O(1).
3985      */
3986     function length(Bytes32Set storage set) internal view returns (uint256) {
3987         return _length(set._inner);
3988     }
3989 
3990     /**
3991      * @dev Returns the value stored at position `index` in the set. O(1).
3992      *
3993      * Note that there are no guarantees on the ordering of values inside the
3994      * array, and it may change when more values are added or removed.
3995      *
3996      * Requirements:
3997      *
3998      * - `index` must be strictly less than {length}.
3999      */
4000     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
4001         return _at(set._inner, index);
4002     }
4003 
4004     /**
4005      * @dev Return the entire set in an array
4006      *
4007      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
4008      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
4009      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
4010      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
4011      */
4012     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
4013         return _values(set._inner);
4014     }
4015 
4016     // AddressSet
4017 
4018     struct AddressSet {
4019         Set _inner;
4020     }
4021 
4022     /**
4023      * @dev Add a value to a set. O(1).
4024      *
4025      * Returns true if the value was added to the set, that is if it was not
4026      * already present.
4027      */
4028     function add(AddressSet storage set, address value) internal returns (bool) {
4029         return _add(set._inner, bytes32(uint256(uint160(value))));
4030     }
4031 
4032     /**
4033      * @dev Removes a value from a set. O(1).
4034      *
4035      * Returns true if the value was removed from the set, that is if it was
4036      * present.
4037      */
4038     function remove(AddressSet storage set, address value) internal returns (bool) {
4039         return _remove(set._inner, bytes32(uint256(uint160(value))));
4040     }
4041 
4042     /**
4043      * @dev Returns true if the value is in the set. O(1).
4044      */
4045     function contains(AddressSet storage set, address value) internal view returns (bool) {
4046         return _contains(set._inner, bytes32(uint256(uint160(value))));
4047     }
4048 
4049     /**
4050      * @dev Returns the number of values in the set. O(1).
4051      */
4052     function length(AddressSet storage set) internal view returns (uint256) {
4053         return _length(set._inner);
4054     }
4055 
4056     /**
4057      * @dev Returns the value stored at position `index` in the set. O(1).
4058      *
4059      * Note that there are no guarantees on the ordering of values inside the
4060      * array, and it may change when more values are added or removed.
4061      *
4062      * Requirements:
4063      *
4064      * - `index` must be strictly less than {length}.
4065      */
4066     function at(AddressSet storage set, uint256 index) internal view returns (address) {
4067         return address(uint160(uint256(_at(set._inner, index))));
4068     }
4069 
4070     /**
4071      * @dev Return the entire set in an array
4072      *
4073      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
4074      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
4075      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
4076      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
4077      */
4078     function values(AddressSet storage set) internal view returns (address[] memory) {
4079         bytes32[] memory store = _values(set._inner);
4080         address[] memory result;
4081 
4082         assembly {
4083             result := store
4084         }
4085 
4086         return result;
4087     }
4088 
4089     // UintSet
4090 
4091     struct UintSet {
4092         Set _inner;
4093     }
4094 
4095     /**
4096      * @dev Add a value to a set. O(1).
4097      *
4098      * Returns true if the value was added to the set, that is if it was not
4099      * already present.
4100      */
4101     function add(UintSet storage set, uint256 value) internal returns (bool) {
4102         return _add(set._inner, bytes32(value));
4103     }
4104 
4105     /**
4106      * @dev Removes a value from a set. O(1).
4107      *
4108      * Returns true if the value was removed from the set, that is if it was
4109      * present.
4110      */
4111     function remove(UintSet storage set, uint256 value) internal returns (bool) {
4112         return _remove(set._inner, bytes32(value));
4113     }
4114 
4115     /**
4116      * @dev Returns true if the value is in the set. O(1).
4117      */
4118     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
4119         return _contains(set._inner, bytes32(value));
4120     }
4121 
4122     /**
4123      * @dev Returns the number of values on the set. O(1).
4124      */
4125     function length(UintSet storage set) internal view returns (uint256) {
4126         return _length(set._inner);
4127     }
4128 
4129     /**
4130      * @dev Returns the value stored at position `index` in the set. O(1).
4131      *
4132      * Note that there are no guarantees on the ordering of values inside the
4133      * array, and it may change when more values are added or removed.
4134      *
4135      * Requirements:
4136      *
4137      * - `index` must be strictly less than {length}.
4138      */
4139     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
4140         return uint256(_at(set._inner, index));
4141     }
4142 
4143     /**
4144      * @dev Return the entire set in an array
4145      *
4146      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
4147      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
4148      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
4149      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
4150      */
4151     function values(UintSet storage set) internal view returns (uint256[] memory) {
4152         bytes32[] memory store = _values(set._inner);
4153         uint256[] memory result;
4154 
4155         assembly {
4156             result := store
4157         }
4158 
4159         return result;
4160     }
4161 }
4162 
4163 
4164 // File @openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol@v4.5.2
4165 
4166 
4167 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
4168 
4169 pragma solidity ^0.8.0;
4170 
4171 
4172 
4173 
4174 /**
4175  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
4176  */
4177 abstract contract AccessControlEnumerableUpgradeable is Initializable, IAccessControlEnumerableUpgradeable, AccessControlUpgradeable {
4178     function __AccessControlEnumerable_init() internal onlyInitializing {
4179     }
4180 
4181     function __AccessControlEnumerable_init_unchained() internal onlyInitializing {
4182     }
4183     using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
4184 
4185     mapping(bytes32 => EnumerableSetUpgradeable.AddressSet) private _roleMembers;
4186 
4187     /**
4188      * @dev See {IERC165-supportsInterface}.
4189      */
4190     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
4191         return interfaceId == type(IAccessControlEnumerableUpgradeable).interfaceId || super.supportsInterface(interfaceId);
4192     }
4193 
4194     /**
4195      * @dev Returns one of the accounts that have `role`. `index` must be a
4196      * value between 0 and {getRoleMemberCount}, non-inclusive.
4197      *
4198      * Role bearers are not sorted in any particular way, and their ordering may
4199      * change at any point.
4200      *
4201      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
4202      * you perform all queries on the same block. See the following
4203      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
4204      * for more information.
4205      */
4206     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
4207         return _roleMembers[role].at(index);
4208     }
4209 
4210     /**
4211      * @dev Returns the number of accounts that have `role`. Can be used
4212      * together with {getRoleMember} to enumerate all bearers of a role.
4213      */
4214     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
4215         return _roleMembers[role].length();
4216     }
4217 
4218     /**
4219      * @dev Overload {_grantRole} to track enumerable memberships
4220      */
4221     function _grantRole(bytes32 role, address account) internal virtual override {
4222         super._grantRole(role, account);
4223         _roleMembers[role].add(account);
4224     }
4225 
4226     /**
4227      * @dev Overload {_revokeRole} to track enumerable memberships
4228      */
4229     function _revokeRole(bytes32 role, address account) internal virtual override {
4230         super._revokeRole(role, account);
4231         _roleMembers[role].remove(account);
4232     }
4233 
4234     /**
4235      * @dev This empty reserved space is put in place to allow future versions to add new
4236      * variables without shifting down storage in the inheritance chain.
4237      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
4238      */
4239     uint256[49] private __gap;
4240 }
4241 
4242 
4243 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.6.0
4244 
4245 
4246 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
4247 
4248 pragma solidity ^0.8.0;
4249 
4250 /**
4251  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
4252  *
4253  * These functions can be used to verify that a message was signed by the holder
4254  * of the private keys of a given address.
4255  */
4256 library ECDSA {
4257     enum RecoverError {
4258         NoError,
4259         InvalidSignature,
4260         InvalidSignatureLength,
4261         InvalidSignatureS,
4262         InvalidSignatureV
4263     }
4264 
4265     function _throwError(RecoverError error) private pure {
4266         if (error == RecoverError.NoError) {
4267             return; // no error: do nothing
4268         } else if (error == RecoverError.InvalidSignature) {
4269             revert("ECDSA: invalid signature");
4270         } else if (error == RecoverError.InvalidSignatureLength) {
4271             revert("ECDSA: invalid signature length");
4272         } else if (error == RecoverError.InvalidSignatureS) {
4273             revert("ECDSA: invalid signature 's' value");
4274         } else if (error == RecoverError.InvalidSignatureV) {
4275             revert("ECDSA: invalid signature 'v' value");
4276         }
4277     }
4278 
4279     /**
4280      * @dev Returns the address that signed a hashed message (`hash`) with
4281      * `signature` or error string. This address can then be used for verification purposes.
4282      *
4283      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
4284      * this function rejects them by requiring the `s` value to be in the lower
4285      * half order, and the `v` value to be either 27 or 28.
4286      *
4287      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
4288      * verification to be secure: it is possible to craft signatures that
4289      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
4290      * this is by receiving a hash of the original message (which may otherwise
4291      * be too long), and then calling {toEthSignedMessageHash} on it.
4292      *
4293      * Documentation for signature generation:
4294      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
4295      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
4296      *
4297      * _Available since v4.3._
4298      */
4299     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
4300         // Check the signature length
4301         // - case 65: r,s,v signature (standard)
4302         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
4303         if (signature.length == 65) {
4304             bytes32 r;
4305             bytes32 s;
4306             uint8 v;
4307             // ecrecover takes the signature parameters, and the only way to get them
4308             // currently is to use assembly.
4309             assembly {
4310                 r := mload(add(signature, 0x20))
4311                 s := mload(add(signature, 0x40))
4312                 v := byte(0, mload(add(signature, 0x60)))
4313             }
4314             return tryRecover(hash, v, r, s);
4315         } else if (signature.length == 64) {
4316             bytes32 r;
4317             bytes32 vs;
4318             // ecrecover takes the signature parameters, and the only way to get them
4319             // currently is to use assembly.
4320             assembly {
4321                 r := mload(add(signature, 0x20))
4322                 vs := mload(add(signature, 0x40))
4323             }
4324             return tryRecover(hash, r, vs);
4325         } else {
4326             return (address(0), RecoverError.InvalidSignatureLength);
4327         }
4328     }
4329 
4330     /**
4331      * @dev Returns the address that signed a hashed message (`hash`) with
4332      * `signature`. This address can then be used for verification purposes.
4333      *
4334      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
4335      * this function rejects them by requiring the `s` value to be in the lower
4336      * half order, and the `v` value to be either 27 or 28.
4337      *
4338      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
4339      * verification to be secure: it is possible to craft signatures that
4340      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
4341      * this is by receiving a hash of the original message (which may otherwise
4342      * be too long), and then calling {toEthSignedMessageHash} on it.
4343      */
4344     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
4345         (address recovered, RecoverError error) = tryRecover(hash, signature);
4346         _throwError(error);
4347         return recovered;
4348     }
4349 
4350     /**
4351      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
4352      *
4353      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
4354      *
4355      * _Available since v4.3._
4356      */
4357     function tryRecover(
4358         bytes32 hash,
4359         bytes32 r,
4360         bytes32 vs
4361     ) internal pure returns (address, RecoverError) {
4362         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
4363         uint8 v = uint8((uint256(vs) >> 255) + 27);
4364         return tryRecover(hash, v, r, s);
4365     }
4366 
4367     /**
4368      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
4369      *
4370      * _Available since v4.2._
4371      */
4372     function recover(
4373         bytes32 hash,
4374         bytes32 r,
4375         bytes32 vs
4376     ) internal pure returns (address) {
4377         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
4378         _throwError(error);
4379         return recovered;
4380     }
4381 
4382     /**
4383      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
4384      * `r` and `s` signature fields separately.
4385      *
4386      * _Available since v4.3._
4387      */
4388     function tryRecover(
4389         bytes32 hash,
4390         uint8 v,
4391         bytes32 r,
4392         bytes32 s
4393     ) internal pure returns (address, RecoverError) {
4394         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
4395         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
4396         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
4397         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
4398         //
4399         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
4400         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
4401         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
4402         // these malleable signatures as well.
4403         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
4404             return (address(0), RecoverError.InvalidSignatureS);
4405         }
4406         if (v != 27 && v != 28) {
4407             return (address(0), RecoverError.InvalidSignatureV);
4408         }
4409 
4410         // If the signature is valid (and not malleable), return the signer address
4411         address signer = ecrecover(hash, v, r, s);
4412         if (signer == address(0)) {
4413             return (address(0), RecoverError.InvalidSignature);
4414         }
4415 
4416         return (signer, RecoverError.NoError);
4417     }
4418 
4419     /**
4420      * @dev Overload of {ECDSA-recover} that receives the `v`,
4421      * `r` and `s` signature fields separately.
4422      */
4423     function recover(
4424         bytes32 hash,
4425         uint8 v,
4426         bytes32 r,
4427         bytes32 s
4428     ) internal pure returns (address) {
4429         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
4430         _throwError(error);
4431         return recovered;
4432     }
4433 
4434     /**
4435      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
4436      * produces hash corresponding to the one signed with the
4437      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
4438      * JSON-RPC method as part of EIP-191.
4439      *
4440      * See {recover}.
4441      */
4442     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
4443         // 32 is the length in bytes of hash,
4444         // enforced by the type signature above
4445         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
4446     }
4447 
4448     /**
4449      * @dev Returns an Ethereum Signed Message, created from `s`. This
4450      * produces hash corresponding to the one signed with the
4451      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
4452      * JSON-RPC method as part of EIP-191.
4453      *
4454      * See {recover}.
4455      */
4456     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
4457         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
4458     }
4459 
4460     /**
4461      * @dev Returns an Ethereum Signed Typed Data, created from a
4462      * `domainSeparator` and a `structHash`. This produces hash corresponding
4463      * to the one signed with the
4464      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
4465      * JSON-RPC method as part of EIP-712.
4466      *
4467      * See {recover}.
4468      */
4469     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
4470         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
4471     }
4472 }
4473 
4474 
4475 // File @openzeppelin/contracts/interfaces/IERC1271.sol@v4.6.0
4476 
4477 
4478 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC1271.sol)
4479 
4480 pragma solidity ^0.8.0;
4481 
4482 /**
4483  * @dev Interface of the ERC1271 standard signature validation method for
4484  * contracts as defined in https://eips.ethereum.org/EIPS/eip-1271[ERC-1271].
4485  *
4486  * _Available since v4.1._
4487  */
4488 interface IERC1271 {
4489     /**
4490      * @dev Should return whether the signature provided is valid for the provided data
4491      * @param hash      Hash of the data to be signed
4492      * @param signature Signature byte array associated with _data
4493      */
4494     function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
4495 }
4496 
4497 
4498 // File @openzeppelin/contracts/utils/cryptography/SignatureChecker.sol@v4.6.0
4499 
4500 
4501 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/SignatureChecker.sol)
4502 
4503 pragma solidity ^0.8.0;
4504 
4505 
4506 
4507 /**
4508  * @dev Signature verification helper that can be used instead of `ECDSA.recover` to seamlessly support both ECDSA
4509  * signatures from externally owned accounts (EOAs) as well as ERC1271 signatures from smart contract wallets like
4510  * Argent and Gnosis Safe.
4511  *
4512  * _Available since v4.1._
4513  */
4514 library SignatureChecker {
4515     /**
4516      * @dev Checks if a signature is valid for a given signer and data hash. If the signer is a smart contract, the
4517      * signature is validated against that smart contract using ERC1271, otherwise it's validated using `ECDSA.recover`.
4518      *
4519      * NOTE: Unlike ECDSA signatures, contract signatures are revocable, and the outcome of this function can thus
4520      * change through time. It could return true at block N and false at block N+1 (or the opposite).
4521      */
4522     function isValidSignatureNow(
4523         address signer,
4524         bytes32 hash,
4525         bytes memory signature
4526     ) internal view returns (bool) {
4527         (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(hash, signature);
4528         if (error == ECDSA.RecoverError.NoError && recovered == signer) {
4529             return true;
4530         }
4531 
4532         (bool success, bytes memory result) = signer.staticcall(
4533             abi.encodeWithSelector(IERC1271.isValidSignature.selector, hash, signature)
4534         );
4535         return (success && result.length == 32 && abi.decode(result, (bytes4)) == IERC1271.isValidSignature.selector);
4536     }
4537 }
4538 
4539 
4540 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.6.0
4541 
4542 
4543 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
4544 
4545 pragma solidity ^0.8.0;
4546 
4547 /**
4548  * @dev These functions deal with verification of Merkle Trees proofs.
4549  *
4550  * The proofs can be generated using the JavaScript library
4551  * https://github.com/miguelmota/merkletreejs[merkletreejs].
4552  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
4553  *
4554  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
4555  *
4556  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
4557  * hashing, or use a hash function other than keccak256 for hashing leaves.
4558  * This is because the concatenation of a sorted pair of internal nodes in
4559  * the merkle tree could be reinterpreted as a leaf value.
4560  */
4561 library MerkleProof {
4562     /**
4563      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
4564      * defined by `root`. For this, a `proof` must be provided, containing
4565      * sibling hashes on the branch from the leaf to the root of the tree. Each
4566      * pair of leaves and each pair of pre-images are assumed to be sorted.
4567      */
4568     function verify(
4569         bytes32[] memory proof,
4570         bytes32 root,
4571         bytes32 leaf
4572     ) internal pure returns (bool) {
4573         return processProof(proof, leaf) == root;
4574     }
4575 
4576     /**
4577      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
4578      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
4579      * hash matches the root of the tree. When processing the proof, the pairs
4580      * of leafs & pre-images are assumed to be sorted.
4581      *
4582      * _Available since v4.4._
4583      */
4584     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
4585         bytes32 computedHash = leaf;
4586         for (uint256 i = 0; i < proof.length; i++) {
4587             bytes32 proofElement = proof[i];
4588             if (computedHash <= proofElement) {
4589                 // Hash(current computed hash + current element of the proof)
4590                 computedHash = _efficientHash(computedHash, proofElement);
4591             } else {
4592                 // Hash(current element of the proof + current computed hash)
4593                 computedHash = _efficientHash(proofElement, computedHash);
4594             }
4595         }
4596         return computedHash;
4597     }
4598 
4599     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
4600         assembly {
4601             mstore(0x00, a)
4602             mstore(0x20, b)
4603             value := keccak256(0x00, 0x40)
4604         }
4605     }
4606 }
4607 
4608 
4609 // File contracts/ISBMintable.sol
4610 
4611 
4612 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
4613 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
4614 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
4615 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
4616 
4617 pragma solidity 0.8.13;
4618 
4619 interface ISBMintable {
4620     function mintNext(address reciever, uint256 amount) external;
4621 
4622     function mintTarget(address reciever, uint256 target) external;
4623 }
4624 
4625 
4626 // File contracts/ISBRandomness.sol
4627 
4628 
4629 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
4630 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
4631 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
4632 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
4633 
4634 pragma solidity 0.8.13;
4635 
4636 interface ISBRandomness {
4637     function getRand(bytes32 seed) external returns (bytes32);
4638 }
4639 
4640 
4641 // File contracts/ISBShipable.sol
4642 
4643 
4644 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
4645 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
4646 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
4647 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
4648 
4649 pragma solidity 0.8.13;
4650 
4651 interface ISBShipable {
4652     function initialize(
4653         bytes calldata initArg,
4654         uint128 bip,
4655         address feeReceiver
4656     ) external;
4657 }
4658 
4659 
4660 // File contracts/SBII721.sol
4661 
4662 
4663 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
4664 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
4665 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
4666 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
4667 
4668 pragma solidity 0.8.13;
4669 
4670 
4671 
4672 
4673 
4674 
4675 
4676 
4677 
4678 
4679 
4680 // @dev speedboat v2 erc721 = SBII721
4681 contract SBII721 is
4682     Initializable,
4683     ContextUpgradeable,
4684     ERC721Upgradeable,
4685     ERC721EnumerableUpgradeable,
4686     ReentrancyGuardUpgradeable,
4687     AccessControlEnumerableUpgradeable,
4688     ISBMintable,
4689     ISBShipable
4690 {
4691     using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
4692     using StringsUpgradeable for uint256;
4693     using SafeERC20 for IERC20;
4694 
4695     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
4696     string public constant MODEL = "SBII-721-test";
4697     uint256 private lastID;
4698 
4699     struct Round {
4700         uint128 price;
4701         uint32 quota;
4702         uint16 amountPerUser;
4703         bool isActive;
4704         bool isPublic;
4705         bool isMerkleMode; // merkleMode will override price, amountPerUser, and TokenID if specify
4706         bool exist;
4707         address tokenAddress; // 0 for base asset
4708     }
4709 
4710     struct Conf {
4711         bool allowNFTUpdate;
4712         bool allowConfUpdate;
4713         bool allowContract;
4714         bool allowPrivilege;
4715         bool randomAccessMode;
4716         bool allowTarget;
4717         bool allowLazySell;
4718         uint64 maxSupply;
4719     }
4720 
4721     Conf public config;
4722     string[] roundNames;
4723 
4724     mapping(bytes32 => EnumerableSetUpgradeable.AddressSet) private walletList;
4725     mapping(bytes32 => bytes32) private merkleRoot;
4726     mapping(bytes32 => Round) private roundData;
4727     mapping(uint256 => bool) private nonceUsed;
4728 
4729     mapping(bytes32 => mapping(address => uint256)) mintedInRound;
4730 
4731     string private _baseTokenURI;
4732     address private feeReceiver;
4733     uint256 private bip;
4734     address public beneficiary;
4735 
4736     ISBRandomness public randomness;
4737 
4738     function listRole()
4739         external
4740         pure
4741         returns (string[] memory names, bytes32[] memory code)
4742     {
4743         names = new string[](2);
4744         code = new bytes32[](2);
4745 
4746         names[0] = "MINTER";
4747         names[1] = "ADMIN";
4748 
4749         code[0] = MINTER_ROLE;
4750         code[1] = DEFAULT_ADMIN_ROLE;
4751     }
4752 
4753     function grantRoles(bytes32 role, address[] calldata accounts) public {
4754         for (uint256 i = 0; i < accounts.length; i++) {
4755             super.grantRole(role, accounts[i]);
4756         }
4757     }
4758 
4759     function revokeRoles(bytes32 role, address[] calldata accounts) public {
4760         for (uint256 i = 0; i < accounts.length; i++) {
4761             super.revokeRole(role, accounts[i]);
4762         }
4763     }
4764 
4765     function setBeneficiary(address _beneficiary)
4766         public
4767         onlyRole(DEFAULT_ADMIN_ROLE)
4768     {
4769         require(beneficiary == address(0), "already set");
4770         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
4771         beneficiary = _beneficiary;
4772     }
4773 
4774     function setMaxSupply(uint64 _maxSupply)
4775         public
4776         onlyRole(DEFAULT_ADMIN_ROLE)
4777     {
4778         require(config.maxSupply == 0, "already set");
4779         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
4780         config.maxSupply = _maxSupply;
4781     }
4782 
4783     function listRoleWallet(bytes32 role)
4784         public
4785         view
4786         returns (address[] memory roleMembers)
4787     {
4788         uint256 count = getRoleMemberCount(role);
4789         roleMembers = new address[](count);
4790         for (uint256 i = 0; i < count; i++) {
4791             roleMembers[i] = getRoleMember(role, i);
4792         }
4793     }
4794 
4795     function listToken(address wallet)
4796         public
4797         view
4798         returns (uint256[] memory tokenList)
4799     {
4800         tokenList = new uint256[](balanceOf(wallet));
4801         for (uint256 i = 0; i < balanceOf(wallet); i++) {
4802             tokenList[i] = tokenOfOwnerByIndex(wallet, i);
4803         }
4804     }
4805 
4806     function listRounds() public view returns (string[] memory) {
4807         return roundNames;
4808     }
4809 
4810     function roundInfo(string memory roundName)
4811         public
4812         view
4813         returns (Round memory)
4814     {
4815         return roundData[keccak256(abi.encodePacked(roundName))];
4816     }
4817 
4818     function massMint(address[] calldata wallets, uint256[] calldata amount)
4819         public
4820     {
4821         require(config.allowPrivilege, "df");
4822         require(hasRole(MINTER_ROLE, msg.sender), "require permission");
4823         for (uint256 i = 0; i < wallets.length; i++) {
4824             _mintNext(wallets[i], amount[i]);
4825         }
4826     }
4827 
4828     function mintNext(address reciever, uint256 amount) public override {
4829         require(config.allowPrivilege, "df");
4830         require(hasRole(MINTER_ROLE, msg.sender), "require permission");
4831         _mintNext(reciever, amount);
4832     }
4833 
4834     function _mintNext(address reciever, uint256 amount) internal {
4835         if (config.maxSupply != 0) {
4836             require(totalSupply() + amount <= config.maxSupply);
4837         }
4838         if (!config.randomAccessMode) {
4839             for (uint256 i = 0; i < amount; i++) {
4840                 _mint(reciever, lastID + 1 +i);
4841             }
4842             lastID += amount;
4843 
4844         } else {
4845             for (uint256 i = 0; i < amount; i++) {
4846                 _mint(reciever, _random(msg.sender, i));
4847             }
4848         }
4849     }
4850 
4851     function _random(address ad, uint256 num) internal returns (uint256) {
4852         return
4853             uint256(randomness.getRand(keccak256(abi.encodePacked(ad, num))));
4854     }
4855 
4856     function updateURI(string memory newURI)
4857         public
4858         onlyRole(DEFAULT_ADMIN_ROLE)
4859     {
4860         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
4861         require(config.allowNFTUpdate, "not available");
4862         _baseTokenURI = newURI;
4863     }
4864 
4865     function mintTarget(address reciever, uint256 target) public override {
4866         require(config.allowPrivilege, "df");
4867         require(hasRole(MINTER_ROLE, msg.sender), "require permission");
4868         _mintTarget(reciever, target);
4869     }
4870 
4871     function _mintTarget(address reciever, uint256 target) internal {
4872         require(config.allowTarget, "df");
4873         require(config.randomAccessMode, "df");
4874         if (config.maxSupply != 0) {
4875             require(totalSupply() + 1 <= config.maxSupply);
4876         }
4877         _mint(reciever, target);
4878     }
4879 
4880     function requestMint(Round storage thisRound, uint256 amount) internal {
4881         require(thisRound.isActive, "not active");
4882         require(thisRound.quota >= amount, "out of stock");
4883         if (!config.allowContract) {
4884             require(tx.origin == msg.sender, "not allow contract");
4885         }
4886         thisRound.quota -= uint32(amount);
4887     }
4888 
4889     /// magic overload
4890 
4891     function mint(string memory roundName, uint256 amount)
4892         public
4893         payable
4894         nonReentrant
4895     {
4896         bytes32 key = keccak256(abi.encodePacked(roundName));
4897         Round storage thisRound = roundData[key];
4898 
4899         requestMint(thisRound, amount);
4900 
4901         // require(thisRound.isActive, "not active");
4902         // require(thisRound.quota >= amount, "out of stock");
4903         // if (!config.allowContract) {
4904         //     require(tx.origin == msg.sender, "not allow contract");
4905         // }
4906         // thisRound.quota -= uint32(amount);
4907 
4908         require(!thisRound.isMerkleMode, "wrong data");
4909 
4910         if (!thisRound.isPublic) {
4911             require(walletList[key].contains(msg.sender));
4912             require(
4913                 mintedInRound[key][msg.sender] + amount <=
4914                     thisRound.amountPerUser,
4915                 "out of quota"
4916             );
4917             mintedInRound[key][msg.sender] += amount;
4918         } else {
4919             require(amount <= thisRound.amountPerUser, "nope"); // public round can mint multiple time
4920         }
4921 
4922         paymentUtil.processPayment(
4923             thisRound.tokenAddress,
4924             thisRound.price * amount
4925         );
4926 
4927         _mintNext(msg.sender, amount);
4928     }
4929 
4930     function mint(
4931         string memory roundName,
4932         address wallet,
4933         uint256 amount,
4934         uint256 tokenID,
4935         uint256 nonce,
4936         uint256 pricePerUnit,
4937         address denominatedAsset,
4938         bytes32[] memory proof
4939     ) public payable {
4940         bytes32 key = keccak256(abi.encodePacked(roundName));
4941 
4942         Round storage thisRound = roundData[key];
4943 
4944         requestMint(thisRound, amount);
4945 
4946         // require(thisRound.isActive, "not active");
4947         // require(thisRound.quota >= amount, "out of quota");
4948         // thisRound.quota -= uint32(amount);
4949 
4950         require(thisRound.isMerkleMode, "invalid");
4951 
4952         bytes32 data = hash(
4953             wallet,
4954             amount,
4955             tokenID,
4956             nonce,
4957             pricePerUnit,
4958             denominatedAsset,
4959             address(this),
4960             block.chainid
4961         );
4962         require(_merkleCheck(data, merkleRoot[key], proof), "fail merkle");
4963 
4964         _useNonce(nonce);
4965         if (wallet != address(0)) {
4966             require(wallet == msg.sender, "nope");
4967         }
4968 
4969         require(amount * tokenID == 0, "pick one"); // such a lazy check lol
4970 
4971         if (amount > 0) {
4972             paymentUtil.processPayment(denominatedAsset, pricePerUnit * amount);
4973             _mintNext(wallet, amount);
4974         } else {
4975             paymentUtil.processPayment(denominatedAsset, pricePerUnit);
4976             _mintTarget(wallet, tokenID);
4977         }
4978     }
4979 
4980     function mint(
4981         address wallet,
4982         uint256 amount,
4983         uint256 tokenID,
4984         uint256 nonce,
4985         uint256 pricePerUnit,
4986         address denominatedAsset,
4987         bytes memory signature
4988     ) public payable {
4989         bytes32 data = hash(
4990             wallet,
4991             amount,
4992             tokenID,
4993             nonce,
4994             pricePerUnit,
4995             denominatedAsset,
4996             address(this),
4997             block.chainid
4998         );
4999 
5000         require(config.allowLazySell, "not available");
5001         require(config.allowPrivilege, "not available");
5002 
5003         require(_verifySig(data, signature));
5004 
5005         _useNonce(nonce);
5006         if (wallet != address(0)) {
5007             require(wallet == msg.sender, "nope");
5008         }
5009 
5010         require(amount * tokenID == 0, "pick one"); // such a lazy check lol
5011 
5012         if (amount > 0) {
5013             paymentUtil.processPayment(denominatedAsset, pricePerUnit * amount);
5014             _mintNext(wallet, amount);
5015         } else {
5016             paymentUtil.processPayment(denominatedAsset, pricePerUnit);
5017             _mintTarget(wallet, tokenID);
5018         }
5019     }
5020 
5021     /// magic overload end
5022 
5023     // this is 721 version. in 20 or 1155 will use the same format but different interpretation
5024     // wallet = 0 mean any
5025     // tokenID = 0 mean next
5026     // amount will overide tokenID
5027     // denominatedAsset = 0 mean chain token (e.g. eth)
5028     // chainID is to prevent replay attack
5029 
5030     function hash(
5031         address wallet,
5032         uint256 amount,
5033         uint256 tokenID,
5034         uint256 nonce,
5035         uint256 pricePerUnit,
5036         address denominatedAsset,
5037         address refPorject,
5038         uint256 chainID
5039     ) public pure returns (bytes32) {
5040         return
5041             keccak256(
5042                 abi.encodePacked(
5043                     wallet,
5044                     amount,
5045                     tokenID,
5046                     nonce,
5047                     pricePerUnit,
5048                     denominatedAsset,
5049                     refPorject,
5050                     chainID
5051                 )
5052             );
5053     }
5054 
5055     function _toSignedHash(bytes32 data) internal pure returns (bytes32) {
5056         return ECDSA.toEthSignedMessageHash(data);
5057     }
5058 
5059     function _verifySig(bytes32 data, bytes memory signature)
5060         public
5061         view
5062         returns (bool)
5063     {
5064         return
5065             hasRole(MINTER_ROLE, ECDSA.recover(_toSignedHash(data), signature));
5066     }
5067 
5068     function _merkleCheck(
5069         bytes32 data,
5070         bytes32 root,
5071         bytes32[] memory merkleProof
5072     ) internal pure returns (bool) {
5073         return MerkleProof.verify(merkleProof, root, data);
5074     }
5075 
5076     /// ROUND
5077 
5078     function newRound(
5079         string memory roundName,
5080         uint128 _price,
5081         uint32 _quota,
5082         uint16 _amountPerUser,
5083         bool _isActive,
5084         bool _isPublic,
5085         bool _isMerkle,
5086         address _tokenAddress
5087     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
5088         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5089         bytes32 key = keccak256(abi.encodePacked(roundName));
5090 
5091         require(!roundData[key].exist, "already exist");
5092         roundNames.push(roundName);
5093         roundData[key] = Round({
5094             price: _price,
5095             quota: _quota,
5096             amountPerUser: _amountPerUser,
5097             isActive: _isActive,
5098             isPublic: _isPublic,
5099             isMerkleMode: _isMerkle,
5100             tokenAddress: _tokenAddress,
5101             exist: true
5102         });
5103     }
5104 
5105     function triggerRound(string memory roundName, bool _isActive)
5106         public
5107         onlyRole(DEFAULT_ADMIN_ROLE)
5108     {
5109         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5110         bytes32 key = keccak256(abi.encodePacked(roundName));
5111         roundData[key].isActive = _isActive;
5112     }
5113 
5114     function setMerkleRoot(string memory roundName, bytes32 root)
5115         public
5116         onlyRole(DEFAULT_ADMIN_ROLE)
5117     {
5118         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5119         bytes32 key = keccak256(abi.encodePacked(roundName));
5120         merkleRoot[key] = root;
5121     }
5122 
5123     function updateRound(
5124         string memory roundName,
5125         uint128 _price,
5126         uint32 _quota,
5127         uint16 _amountPerUser,
5128         bool _isPublic
5129     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
5130         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5131         bytes32 key = keccak256(abi.encodePacked(roundName));
5132         roundData[key].price = _price;
5133         roundData[key].quota = _quota;
5134         roundData[key].amountPerUser = _amountPerUser;
5135         roundData[key].isPublic = _isPublic;
5136     }
5137 
5138     function addRoundWallet(string memory roundName, address[] memory wallets)
5139         public
5140         onlyRole(DEFAULT_ADMIN_ROLE)
5141     {
5142         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5143         bytes32 key = keccak256(abi.encodePacked(roundName));
5144         for (uint256 i = 0; i < wallets.length; i++) {
5145             walletList[key].add(wallets[i]);
5146         }
5147     }
5148 
5149     function removeRoundWallet(
5150         string memory roundName,
5151         address[] memory wallets
5152     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
5153         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5154         bytes32 key = keccak256(abi.encodePacked(roundName));
5155         for (uint256 i = 0; i < wallets.length; i++) {
5156             walletList[key].remove(wallets[i]);
5157         }
5158     }
5159 
5160     function getRoundWallet(string memory roundName)
5161         public
5162         view
5163         returns (address[] memory)
5164     {
5165         return walletList[keccak256(abi.encodePacked(roundName))].values();
5166     }
5167 
5168     function isQualify(address wallet, string memory roundName)
5169         public
5170         view
5171         returns (bool)
5172     {
5173         Round memory x = roundInfo(roundName);
5174         if (!x.isActive) {
5175             return false;
5176         }
5177         if (x.quota == 0) {
5178             return false;
5179         }
5180         bytes32 key = keccak256(abi.encodePacked(roundName));
5181         if (!x.isPublic && !walletList[key].contains(wallet)) {
5182             return false;
5183         }
5184         if (mintedInRound[key][wallet] >= x.amountPerUser) {
5185             return false;
5186         }
5187         return true;
5188     }
5189 
5190     function listQualifiedRound(address wallet)
5191         public
5192         view
5193         returns (string[] memory)
5194     {
5195         string[] memory valid = new string[](roundNames.length);
5196         for (uint256 i = 0; i < roundNames.length; i++) {
5197             if (isQualify(wallet, roundNames[i])) {
5198                 valid[i] = roundNames[i];
5199             }
5200         }
5201         return valid;
5202     }
5203 
5204     function burnNonce(uint256[] calldata nonces)
5205         external
5206         onlyRole(DEFAULT_ADMIN_ROLE)
5207     {
5208         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5209         require(config.allowPrivilege, "df");
5210 
5211         for (uint256 i = 0; i < nonces.length; i++) {
5212             nonceUsed[nonces[i]] = true;
5213         }
5214     }
5215 
5216     function resetNonce(uint256[] calldata nonces)
5217         external
5218         onlyRole(DEFAULT_ADMIN_ROLE)
5219     {
5220         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5221         require(config.allowPrivilege, "df");
5222 
5223         for (uint256 i = 0; i < nonces.length; i++) {
5224             nonceUsed[nonces[i]] = false;
5225         }
5226     }
5227 
5228     function _useNonce(uint256 nonce) internal {
5229         require(!nonceUsed[nonce], "used");
5230         nonceUsed[nonce] = true;
5231     }
5232 
5233     /// ROUND end ///
5234 
5235     function initialize(
5236         bytes calldata initArg,
5237         uint128 _bip,
5238         address _feeReceiver
5239     ) public initializer {
5240         feeReceiver = _feeReceiver;
5241         bip = _bip;
5242 
5243         (
5244             string memory name,
5245             string memory symbol,
5246             string memory baseTokenURI,
5247             address owner,
5248             bool _allowNFTUpdate,
5249             bool _allowConfUpdate,
5250             bool _allowContract,
5251             bool _allowPrivilege,
5252             bool _randomAccessMode,
5253             bool _allowTarget,
5254             bool _allowLazySell
5255         ) = abi.decode(
5256                 initArg,
5257                 (
5258                     string,
5259                     string,
5260                     string,
5261                     address,
5262                     bool,
5263                     bool,
5264                     bool,
5265                     bool,
5266                     bool,
5267                     bool,
5268                     bool
5269                 )
5270             );
5271 
5272         __721Init(name, symbol);
5273         _setupRole(DEFAULT_ADMIN_ROLE, owner);
5274         _setupRole(MINTER_ROLE, owner);
5275 
5276         _baseTokenURI = baseTokenURI;
5277         config = Conf({
5278             allowNFTUpdate: _allowNFTUpdate,
5279             allowConfUpdate: _allowConfUpdate,
5280             allowContract: _allowContract,
5281             allowPrivilege: _allowPrivilege,
5282             randomAccessMode: _randomAccessMode,
5283             allowTarget: _allowTarget,
5284             allowLazySell: _allowLazySell,
5285             maxSupply: 0
5286         });
5287     }
5288 
5289     function updateConfig(
5290         bool _allowNFTUpdate,
5291         bool _allowConfUpdate,
5292         bool _allowContract,
5293         bool _allowPrivilege,
5294         bool _allowTarget,
5295         bool _allowLazySell
5296     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
5297         require(config.allowConfUpdate);
5298         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5299         config.allowNFTUpdate = _allowNFTUpdate;
5300         config.allowConfUpdate = _allowConfUpdate;
5301         config.allowContract = _allowContract;
5302         config.allowPrivilege = _allowPrivilege;
5303         config.allowTarget = _allowTarget;
5304         config.allowLazySell = _allowLazySell;
5305     }
5306 
5307     function withdraw(address tokenAddress) public nonReentrant {
5308         address reviver = beneficiary;
5309         if (beneficiary == address(0)) {
5310             require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5311             reviver = msg.sender;
5312         }
5313         if (tokenAddress == address(0)) {
5314             payable(feeReceiver).transfer(
5315                 (address(this).balance * bip) / 10000
5316             );
5317             payable(reviver).transfer(address(this).balance);
5318         } else {
5319             IERC20 token = IERC20(tokenAddress);
5320             token.safeTransfer(
5321                 feeReceiver,
5322                 (token.balanceOf(address(this)) * bip) / 10000
5323             );
5324             token.safeTransfer(reviver, token.balanceOf(address(this)));
5325         }
5326     }
5327 
5328     function setRandomness(address _randomness)
5329         public
5330         onlyRole(DEFAULT_ADMIN_ROLE)
5331     {
5332         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5333         randomness = ISBRandomness(_randomness);
5334     }
5335 
5336     function contractURI() external view returns (string memory) {
5337         string memory baseURI = _baseURI();
5338         return string(abi.encodePacked(baseURI, "contract_uri"));
5339     }
5340 
5341     function tokenURI(uint256 tokenId)
5342         public
5343         view
5344         virtual
5345         override
5346         returns (string memory)
5347     {
5348         require(_exists(tokenId), "nonexistent token");
5349 
5350         string memory baseURI = _baseURI();
5351         return string(abi.encodePacked(baseURI, "uri/", tokenId.toString()));
5352     }
5353 
5354     // @dev boring section -------------------
5355 
5356     function __721Init(string memory name, string memory symbol) internal {
5357         __Context_init_unchained();
5358         __ERC165_init_unchained();
5359         __ReentrancyGuard_init_unchained();
5360         __ERC721_init_unchained(name, symbol);
5361         __ERC721Enumerable_init_unchained();
5362         __AccessControlEnumerable_init_unchained();
5363     }
5364 
5365     function _baseURI() internal view virtual override returns (string memory) {
5366         return _baseTokenURI;
5367     }
5368 
5369     function _beforeTokenTransfer(
5370         address from,
5371         address to,
5372         uint256 tokenId
5373     )
5374         internal
5375         virtual
5376         override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
5377     {
5378         super._beforeTokenTransfer(from, to, tokenId);
5379     }
5380 
5381     function supportsInterface(bytes4 interfaceId)
5382         public
5383         view
5384         virtual
5385         override(
5386             ERC721Upgradeable,
5387             ERC721EnumerableUpgradeable,
5388             AccessControlEnumerableUpgradeable
5389         )
5390         returns (bool)
5391     {
5392         return super.supportsInterface(interfaceId);
5393     }
5394 }
5395 
5396 
5397 // File contracts/SBII721A.sol
5398 
5399 
5400 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
5401 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
5402 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
5403 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
5404 
5405 pragma solidity 0.8.13;
5406 
5407 
5408 
5409 
5410 
5411 
5412 
5413 
5414 
5415 // @dev speedboat v2 erc721A = modified SBII721A
5416 // @dev should treat this code as experimental.
5417 contract SBII721A is
5418     Initializable,
5419     ERC721ASBUpgradable,
5420     ReentrancyGuardUpgradeable,
5421     AccessControlEnumerableUpgradeable,
5422     ISBMintable,
5423     ISBShipable
5424 {
5425     using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
5426     using StringsUpgradeable for uint256;
5427     using SafeERC20 for IERC20;
5428 
5429     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
5430     string public constant MODEL = "SBII-721A-EARLYACCESS";
5431 
5432     struct Round {
5433         uint128 price;
5434         uint32 quota;
5435         uint16 amountPerUser;
5436         bool isActive;
5437         bool isPublic;
5438         bool isMerkleMode; // merkleMode will override price, amountPerUser, and TokenID if specify
5439         bool exist;
5440         address tokenAddress; // 0 for base asset
5441     }
5442 
5443     struct Conf {
5444         bool allowNFTUpdate;
5445         bool allowConfUpdate;
5446         bool allowContract;
5447         bool allowPrivilege;
5448         bool randomAccessMode;
5449         bool allowTarget;
5450         bool allowLazySell;
5451         uint64 maxSupply;
5452     }
5453 
5454     Conf public config;
5455     string[] public roundNames;
5456 
5457     mapping(bytes32 => EnumerableSetUpgradeable.AddressSet) private walletList;
5458     mapping(bytes32 => bytes32) private merkleRoot;
5459     mapping(bytes32 => Round) private roundData;
5460     mapping(uint256 => bool) private nonceUsed;
5461 
5462     mapping(bytes32 => mapping(address => uint256)) mintedInRound;
5463 
5464     string private _baseTokenURI;
5465     address private feeReceiver;
5466     uint256 private bip;
5467     address public beneficiary;
5468 
5469     function listRole()
5470         public
5471         pure
5472         returns (string[] memory names, bytes32[] memory code)
5473     {
5474         names = new string[](2);
5475         code = new bytes32[](2);
5476 
5477         names[0] = "MINTER";
5478         names[1] = "ADMIN";
5479 
5480         code[0] = MINTER_ROLE;
5481         code[1] = DEFAULT_ADMIN_ROLE;
5482     }
5483 
5484     function grantRoles(bytes32 role, address[] calldata accounts) public {
5485         for (uint256 i = 0; i < accounts.length; i++) {
5486             super.grantRole(role, accounts[i]);
5487         }
5488     }
5489 
5490     function revokeRoles(bytes32 role, address[] calldata accounts) public {
5491         for (uint256 i = 0; i < accounts.length; i++) {
5492             super.revokeRole(role, accounts[i]);
5493         }
5494     }
5495 
5496     function setBeneficiary(address _beneficiary)
5497         public
5498         onlyRole(DEFAULT_ADMIN_ROLE)
5499     {
5500         require(beneficiary == address(0), "already set");
5501         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5502         beneficiary = _beneficiary;
5503     }
5504 
5505     // 0 = unlimited, can only set once.
5506     function setMaxSupply(uint64 _maxSupply)
5507         public
5508         onlyRole(DEFAULT_ADMIN_ROLE)
5509     {
5510         require(config.maxSupply == 0, "already set");
5511         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5512         config.maxSupply = _maxSupply;
5513     }
5514 
5515     function listRoleWallet(bytes32 role)
5516         public
5517         view
5518         returns (address[] memory roleMembers)
5519     {
5520         uint256 count = getRoleMemberCount(role);
5521         roleMembers = new address[](count);
5522         for (uint256 i = 0; i < count; i++) {
5523             roleMembers[i] = getRoleMember(role, i);
5524         }
5525     }
5526 
5527     function listToken(address wallet)
5528         public
5529         view
5530         returns (uint256[] memory tokenList)
5531     {
5532         return tokensOfOwner(wallet);
5533     }
5534 
5535     function listRounds() public view returns (string[] memory) {
5536         return roundNames;
5537     }
5538 
5539     function roundInfo(string memory roundName)
5540         public
5541         view
5542         returns (Round memory)
5543     {
5544         return roundData[keccak256(abi.encodePacked(roundName))];
5545     }
5546 
5547     function massMint(address[] calldata wallets, uint256[] calldata amount)
5548         public
5549     {
5550         require(config.allowPrivilege, "disabled feature");
5551         require(hasRole(MINTER_ROLE, msg.sender), "require permission");
5552         for (uint256 i = 0; i < wallets.length; i++) {
5553             mintNext(wallets[i], amount[i]);
5554         }
5555     }
5556 
5557     function mintNext(address reciever, uint256 amount) public override {
5558         require(config.allowPrivilege, "disabled feature");
5559         require(hasRole(MINTER_ROLE, msg.sender), "require permission");
5560         _mintNext(reciever, amount);
5561     }
5562 
5563     function _mintNext(address reciever, uint256 amount) internal {
5564         if (config.maxSupply != 0) {
5565             require(totalSupply() + amount <= config.maxSupply);
5566         }
5567         _safeMint(reciever, amount); // 721A mint
5568     }
5569 
5570     function _random(address ad, uint256 num) internal returns (uint256) {
5571         revert("not supported by 721a la");
5572     }
5573 
5574     function updateURI(string memory newURI)
5575         public
5576         onlyRole(DEFAULT_ADMIN_ROLE)
5577     {
5578         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5579         require(config.allowNFTUpdate, "not available");
5580         _baseTokenURI = newURI;
5581     }
5582 
5583     function mintTarget(address reciever, uint256 target) public override {
5584         revert("not supported by 721a la");
5585     }
5586 
5587     function requestMint(Round storage thisRound, uint256 amount) internal {
5588         require(thisRound.isActive, "not active");
5589         require(thisRound.quota >= amount, "out of stock");
5590         if (!config.allowContract) {
5591             require(tx.origin == msg.sender, "not allow contract");
5592         }
5593         thisRound.quota -= uint32(amount);
5594     }
5595 
5596     /// magic overload
5597 
5598     function mint(string memory roundName, uint256 amount)
5599         public
5600         payable
5601         nonReentrant
5602     {
5603         bytes32 key = keccak256(abi.encodePacked(roundName));
5604         Round storage thisRound = roundData[key];
5605 
5606         requestMint(thisRound, amount);
5607 
5608         // require(thisRound.isActive, "not active");
5609         // require(thisRound.quota >= amount, "out of stock");
5610         // if (!config.allowContract) {
5611         //     require(tx.origin == msg.sender, "not allow contract");
5612         // }
5613         // thisRound.quota -= uint32(amount);
5614 
5615         require(!thisRound.isMerkleMode, "wrong data");
5616 
5617         if (!thisRound.isPublic) {
5618             require(walletList[key].contains(msg.sender));
5619             require(
5620                 mintedInRound[key][msg.sender] + amount <=
5621                     thisRound.amountPerUser,
5622                 "out of quota"
5623             );
5624             mintedInRound[key][msg.sender] += amount;
5625         } else {
5626             require(amount <= thisRound.amountPerUser, "nope"); // public round can mint multiple time
5627         }
5628 
5629         paymentUtil.processPayment(
5630             thisRound.tokenAddress,
5631             thisRound.price * amount
5632         );
5633 
5634         _mintNext(msg.sender, amount);
5635     }
5636 
5637     function mint(
5638         string memory roundName,
5639         address wallet,
5640         uint256 amount,
5641         uint256 tokenID,
5642         uint256 nonce,
5643         uint256 pricePerUnit,
5644         address denominatedAsset,
5645         bytes32[] memory proof
5646     ) public payable {
5647         bytes32 key = keccak256(abi.encodePacked(roundName));
5648         Round storage thisRound = roundData[key];
5649 
5650         requestMint(thisRound, amount);
5651 
5652         // require(thisRound.isActive, "not active");
5653         // require(thisRound.quota >= amount, "out of quota");
5654         // thisRound.quota -= uint32(amount);
5655 
5656         require(thisRound.isMerkleMode, "invalid");
5657 
5658         bytes32 data = hash(
5659             wallet,
5660             amount,
5661             tokenID,
5662             nonce,
5663             pricePerUnit,
5664             denominatedAsset,
5665             address(this),
5666             block.chainid
5667         );
5668         require(_merkleCheck(data, merkleRoot[key], proof), "fail merkle");
5669 
5670         _useNonce(nonce);
5671         if (wallet != address(0)) {
5672             require(wallet == msg.sender, "nope");
5673         }
5674 
5675         require(amount > 0, "pick one"); // such a lazy check lol
5676         require(tokenID == 0, "nope"); // such a lazy check lol
5677 
5678         paymentUtil.processPayment(denominatedAsset, pricePerUnit * amount);
5679         _mintNext(wallet, amount);
5680     }
5681 
5682     function mint(
5683         address wallet,
5684         uint256 amount,
5685         uint256 tokenID,
5686         uint256 nonce,
5687         uint256 pricePerUnit,
5688         address denominatedAsset,
5689         bytes memory signature
5690     ) public payable {
5691         bytes32 data = hash(
5692             wallet,
5693             amount,
5694             tokenID,
5695             nonce,
5696             pricePerUnit,
5697             denominatedAsset,
5698             address(this),
5699             block.chainid
5700         );
5701         require(config.allowLazySell, "not available");
5702         require(config.allowPrivilege, "not available");
5703 
5704         require(_verifySig(data, signature));
5705 
5706         _useNonce(nonce);
5707         if (wallet != address(0)) {
5708             require(wallet == msg.sender, "nope");
5709         }
5710 
5711         require(amount > 0, "pick one"); // such a lazy check lol
5712         require(tokenID == 0, "nope"); // such a lazy check lol
5713 
5714         paymentUtil.processPayment(denominatedAsset, pricePerUnit * amount);
5715         _mintNext(wallet, amount);
5716     }
5717 
5718     /// magic overload end
5719 
5720     // this is 721 version. in 20 or 1155 will use the same format but different interpretation
5721     // wallet = 0 mean any
5722     // tokenID = 0 mean next
5723     // amount will overide tokenID
5724     // denominatedAsset = 0 mean chain token (e.g. eth)
5725     // chainID is to prevent replay attack
5726 
5727     function hash(
5728         address wallet,
5729         uint256 amount,
5730         uint256 tokenID,
5731         uint256 nonce,
5732         uint256 pricePerUnit,
5733         address denominatedAsset,
5734         address refPorject,
5735         uint256 chainID
5736     ) public pure returns (bytes32) {
5737         return
5738             keccak256(
5739                 abi.encodePacked(
5740                     wallet,
5741                     amount,
5742                     tokenID,
5743                     nonce,
5744                     pricePerUnit,
5745                     denominatedAsset,
5746                     refPorject,
5747                     chainID
5748                 )
5749             );
5750     }
5751 
5752     function _toSignedHash(bytes32 data) internal pure returns (bytes32) {
5753         return ECDSA.toEthSignedMessageHash(data);
5754     }
5755 
5756     function _verifySig(bytes32 data, bytes memory signature)
5757         public
5758         view
5759         returns (bool)
5760     {
5761         return
5762             hasRole(MINTER_ROLE, ECDSA.recover(_toSignedHash(data), signature));
5763     }
5764 
5765     function _merkleCheck(
5766         bytes32 data,
5767         bytes32 root,
5768         bytes32[] memory merkleProof
5769     ) internal pure returns (bool) {
5770         return MerkleProof.verify(merkleProof, root, data);
5771     }
5772 
5773     /// ROUND
5774 
5775     function newRound(
5776         string memory roundName,
5777         uint128 _price,
5778         uint32 _quota,
5779         uint16 _amountPerUser,
5780         bool _isActive,
5781         bool _isPublic,
5782         bool _isMerkle,
5783         address _tokenAddress
5784     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
5785         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5786         bytes32 key = keccak256(abi.encodePacked(roundName));
5787 
5788         require(!roundData[key].exist, "already exist");
5789         roundNames.push(roundName);
5790         roundData[key] = Round({
5791             price: _price,
5792             quota: _quota,
5793             amountPerUser: _amountPerUser,
5794             isActive: _isActive,
5795             isPublic: _isPublic,
5796             isMerkleMode: _isMerkle,
5797             tokenAddress: _tokenAddress,
5798             exist: true
5799         });
5800     }
5801 
5802     function triggerRound(string memory roundName, bool _isActive)
5803         public
5804         onlyRole(DEFAULT_ADMIN_ROLE)
5805     {
5806         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5807         bytes32 key = keccak256(abi.encodePacked(roundName));
5808         roundData[key].isActive = _isActive;
5809     }
5810 
5811     function setMerkleRoot(string memory roundName, bytes32 root)
5812         public
5813         onlyRole(DEFAULT_ADMIN_ROLE)
5814     {
5815         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5816         bytes32 key = keccak256(abi.encodePacked(roundName));
5817         merkleRoot[key] = root;
5818     }
5819 
5820     function updateRound(
5821         string memory roundName,
5822         uint128 _price,
5823         uint32 _quota,
5824         uint16 _amountPerUser,
5825         bool _isPublic
5826     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
5827         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5828         bytes32 key = keccak256(abi.encodePacked(roundName));
5829         roundData[key].price = _price;
5830         roundData[key].quota = _quota;
5831         roundData[key].amountPerUser = _amountPerUser;
5832         roundData[key].isPublic = _isPublic;
5833     }
5834 
5835     function addRoundWallet(string memory roundName, address[] memory wallets)
5836         public
5837         onlyRole(DEFAULT_ADMIN_ROLE)
5838     {
5839         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5840         bytes32 key = keccak256(abi.encodePacked(roundName));
5841         for (uint256 i = 0; i < wallets.length; i++) {
5842             walletList[key].add(wallets[i]);
5843         }
5844     }
5845 
5846     function removeRoundWallet(
5847         string memory roundName,
5848         address[] memory wallets
5849     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
5850         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5851         bytes32 key = keccak256(abi.encodePacked(roundName));
5852         for (uint256 i = 0; i < wallets.length; i++) {
5853             walletList[key].remove(wallets[i]);
5854         }
5855     }
5856 
5857     function getRoundWallet(string memory roundName)
5858         public
5859         view
5860         returns (address[] memory)
5861     {
5862         return walletList[keccak256(abi.encodePacked(roundName))].values();
5863     }
5864 
5865     function isQualify(address wallet, string memory roundName)
5866         public
5867         view
5868         returns (bool)
5869     {
5870         Round memory x = roundInfo(roundName);
5871         if (!x.isActive) {
5872             return false;
5873         }
5874         if (x.quota == 0) {
5875             return false;
5876         }
5877         bytes32 key = keccak256(abi.encodePacked(roundName));
5878         if (!x.isPublic && !walletList[key].contains(wallet)) {
5879             return false;
5880         }
5881         if (mintedInRound[key][wallet] >= x.amountPerUser) {
5882             return false;
5883         }
5884         return true;
5885     }
5886 
5887     function listQualifiedRound(address wallet)
5888         public
5889         view
5890         returns (string[] memory)
5891     {
5892         string[] memory valid = new string[](roundNames.length);
5893         for (uint256 i = 0; i < roundNames.length; i++) {
5894             if (isQualify(wallet, roundNames[i])) {
5895                 valid[i] = roundNames[i];
5896             }
5897         }
5898         return valid;
5899     }
5900 
5901     function burnNonce(uint256[] calldata nonces)
5902         external
5903         onlyRole(DEFAULT_ADMIN_ROLE)
5904     {
5905         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5906         require(config.allowPrivilege, "disabled feature");
5907 
5908         for (uint256 i = 0; i < nonces.length; i++) {
5909             nonceUsed[nonces[i]] = true;
5910         }
5911     }
5912 
5913     function resetNonce(uint256[] calldata nonces)
5914         external
5915         onlyRole(DEFAULT_ADMIN_ROLE)
5916     {
5917         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5918         require(config.allowPrivilege, "disabled feature");
5919 
5920         for (uint256 i = 0; i < nonces.length; i++) {
5921             nonceUsed[nonces[i]] = false;
5922         }
5923     }
5924 
5925     function _useNonce(uint256 nonce) internal {
5926         require(!nonceUsed[nonce], "used");
5927         nonceUsed[nonce] = true;
5928     }
5929 
5930     /// ROUND end ///
5931 
5932     function initialize(
5933         bytes calldata initArg,
5934         uint128 _bip,
5935         address _feeReceiver
5936     ) public initializer {
5937         feeReceiver = _feeReceiver;
5938         bip = _bip;
5939 
5940         (
5941             string memory name,
5942             string memory symbol,
5943             string memory baseTokenURI,
5944             address owner,
5945             bool _allowNFTUpdate,
5946             bool _allowConfUpdate,
5947             bool _allowContract,
5948             bool _allowPrivilege,
5949             bool _randomAccessMode,
5950             bool _allowTarget,
5951             bool _allowLazySell
5952         ) = abi.decode(
5953                 initArg,
5954                 (
5955                     string,
5956                     string,
5957                     string,
5958                     address,
5959                     bool,
5960                     bool,
5961                     bool,
5962                     bool,
5963                     bool,
5964                     bool,
5965                     bool
5966                 )
5967             );
5968 
5969         __721AInit(name, symbol);
5970         _setupRole(DEFAULT_ADMIN_ROLE, owner);
5971         _setupRole(MINTER_ROLE, owner);
5972 
5973         _baseTokenURI = baseTokenURI;
5974         config = Conf({
5975             allowNFTUpdate: _allowNFTUpdate,
5976             allowConfUpdate: _allowConfUpdate,
5977             allowContract: _allowContract,
5978             allowPrivilege: _allowPrivilege,
5979             randomAccessMode: _randomAccessMode,
5980             allowTarget: _allowTarget,
5981             allowLazySell: _allowLazySell,
5982             maxSupply: 0
5983         });
5984     }
5985 
5986     function updateConfig(
5987         bool _allowNFTUpdate,
5988         bool _allowConfUpdate,
5989         bool _allowContract,
5990         bool _allowPrivilege,
5991         bool _allowTarget,
5992         bool _allowLazySell
5993     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
5994         require(config.allowConfUpdate);
5995         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
5996         config.allowNFTUpdate = _allowNFTUpdate;
5997         config.allowConfUpdate = _allowConfUpdate;
5998         config.allowContract = _allowContract;
5999         config.allowPrivilege = _allowPrivilege;
6000         config.allowTarget = _allowTarget;
6001         config.allowLazySell = _allowLazySell;
6002     }
6003 
6004     function withdraw(address tokenAddress) public nonReentrant {
6005         address reviver = beneficiary;
6006         if (beneficiary == address(0)) {
6007             require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
6008             reviver = msg.sender;
6009         }
6010         if (tokenAddress == address(0)) {
6011             payable(feeReceiver).transfer(
6012                 (address(this).balance * bip) / 10000
6013             );
6014             payable(reviver).transfer(address(this).balance);
6015         } else {
6016             IERC20 token = IERC20(tokenAddress);
6017             token.safeTransfer(
6018                 feeReceiver,
6019                 (token.balanceOf(address(this)) * bip) / 10000
6020             );
6021             token.safeTransfer(reviver, token.balanceOf(address(this)));
6022         }
6023     }
6024 
6025     function contractURI() external view returns (string memory) {
6026         string memory baseURI = _baseURI();
6027         return string(abi.encodePacked(baseURI, "contract_uri"));
6028     }
6029 
6030     function tokenURI(uint256 tokenId)
6031         public
6032         view
6033         virtual
6034         override
6035         returns (string memory)
6036     {
6037         require(_exists(tokenId), "nonexistent token");
6038 
6039         string memory baseURI = _baseURI();
6040         return string(abi.encodePacked(baseURI, "uri/", tokenId.toString()));
6041     }
6042 
6043     // @dev boring section -------------------
6044 
6045     function __721AInit(string memory name, string memory symbol) internal {
6046         __ReentrancyGuard_init_unchained();
6047         __ERC721A_init(name, symbol);
6048         __AccessControlEnumerable_init_unchained();
6049     }
6050 
6051     function _baseURI() internal view virtual override returns (string memory) {
6052         return _baseTokenURI;
6053     }
6054 
6055     function supportsInterface(bytes4 interfaceId)
6056         public
6057         view
6058         virtual
6059         override(AccessControlEnumerableUpgradeable, ERC721ASBUpgradable)
6060         returns (bool)
6061     {
6062         return
6063             interfaceId == type(IERC721Upgradeable).interfaceId ||
6064             interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
6065             super.supportsInterface(interfaceId);
6066     }
6067 }
6068 
6069 
6070 // File @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol@v4.5.2
6071 
6072 
6073 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
6074 
6075 pragma solidity ^0.8.0;
6076 
6077 /**
6078  * @dev Interface of the ERC20 standard as defined in the EIP.
6079  */
6080 interface IERC20Upgradeable {
6081     /**
6082      * @dev Returns the amount of tokens in existence.
6083      */
6084     function totalSupply() external view returns (uint256);
6085 
6086     /**
6087      * @dev Returns the amount of tokens owned by `account`.
6088      */
6089     function balanceOf(address account) external view returns (uint256);
6090 
6091     /**
6092      * @dev Moves `amount` tokens from the caller's account to `to`.
6093      *
6094      * Returns a boolean value indicating whether the operation succeeded.
6095      *
6096      * Emits a {Transfer} event.
6097      */
6098     function transfer(address to, uint256 amount) external returns (bool);
6099 
6100     /**
6101      * @dev Returns the remaining number of tokens that `spender` will be
6102      * allowed to spend on behalf of `owner` through {transferFrom}. This is
6103      * zero by default.
6104      *
6105      * This value changes when {approve} or {transferFrom} are called.
6106      */
6107     function allowance(address owner, address spender) external view returns (uint256);
6108 
6109     /**
6110      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
6111      *
6112      * Returns a boolean value indicating whether the operation succeeded.
6113      *
6114      * IMPORTANT: Beware that changing an allowance with this method brings the risk
6115      * that someone may use both the old and the new allowance by unfortunate
6116      * transaction ordering. One possible solution to mitigate this race
6117      * condition is to first reduce the spender's allowance to 0 and set the
6118      * desired value afterwards:
6119      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
6120      *
6121      * Emits an {Approval} event.
6122      */
6123     function approve(address spender, uint256 amount) external returns (bool);
6124 
6125     /**
6126      * @dev Moves `amount` tokens from `from` to `to` using the
6127      * allowance mechanism. `amount` is then deducted from the caller's
6128      * allowance.
6129      *
6130      * Returns a boolean value indicating whether the operation succeeded.
6131      *
6132      * Emits a {Transfer} event.
6133      */
6134     function transferFrom(
6135         address from,
6136         address to,
6137         uint256 amount
6138     ) external returns (bool);
6139 
6140     /**
6141      * @dev Emitted when `value` tokens are moved from one account (`from`) to
6142      * another (`to`).
6143      *
6144      * Note that `value` may be zero.
6145      */
6146     event Transfer(address indexed from, address indexed to, uint256 value);
6147 
6148     /**
6149      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
6150      * a call to {approve}. `value` is the new allowance.
6151      */
6152     event Approval(address indexed owner, address indexed spender, uint256 value);
6153 }
6154 
6155 
6156 // File @openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol@v4.5.2
6157 
6158 
6159 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
6160 
6161 pragma solidity ^0.8.0;
6162 
6163 
6164 /**
6165  * @title SafeERC20
6166  * @dev Wrappers around ERC20 operations that throw on failure (when the token
6167  * contract returns false). Tokens that return no value (and instead revert or
6168  * throw on failure) are also supported, non-reverting calls are assumed to be
6169  * successful.
6170  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
6171  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
6172  */
6173 library SafeERC20Upgradeable {
6174     using AddressUpgradeable for address;
6175 
6176     function safeTransfer(
6177         IERC20Upgradeable token,
6178         address to,
6179         uint256 value
6180     ) internal {
6181         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
6182     }
6183 
6184     function safeTransferFrom(
6185         IERC20Upgradeable token,
6186         address from,
6187         address to,
6188         uint256 value
6189     ) internal {
6190         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
6191     }
6192 
6193     /**
6194      * @dev Deprecated. This function has issues similar to the ones found in
6195      * {IERC20-approve}, and its usage is discouraged.
6196      *
6197      * Whenever possible, use {safeIncreaseAllowance} and
6198      * {safeDecreaseAllowance} instead.
6199      */
6200     function safeApprove(
6201         IERC20Upgradeable token,
6202         address spender,
6203         uint256 value
6204     ) internal {
6205         // safeApprove should only be called when setting an initial allowance,
6206         // or when resetting it to zero. To increase and decrease it, use
6207         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
6208         require(
6209             (value == 0) || (token.allowance(address(this), spender) == 0),
6210             "SafeERC20: approve from non-zero to non-zero allowance"
6211         );
6212         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
6213     }
6214 
6215     function safeIncreaseAllowance(
6216         IERC20Upgradeable token,
6217         address spender,
6218         uint256 value
6219     ) internal {
6220         uint256 newAllowance = token.allowance(address(this), spender) + value;
6221         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
6222     }
6223 
6224     function safeDecreaseAllowance(
6225         IERC20Upgradeable token,
6226         address spender,
6227         uint256 value
6228     ) internal {
6229         unchecked {
6230             uint256 oldAllowance = token.allowance(address(this), spender);
6231             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
6232             uint256 newAllowance = oldAllowance - value;
6233             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
6234         }
6235     }
6236 
6237     /**
6238      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
6239      * on the return value: the return value is optional (but if data is returned, it must not be false).
6240      * @param token The token targeted by the call.
6241      * @param data The call data (encoded using abi.encode or one of its variants).
6242      */
6243     function _callOptionalReturn(IERC20Upgradeable token, bytes memory data) private {
6244         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
6245         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
6246         // the target address contains contract code and also asserts for success in the low-level call.
6247 
6248         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
6249         if (returndata.length > 0) {
6250             // Return data is optional
6251             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
6252         }
6253     }
6254 }
6255 
6256 
6257 // File @openzeppelin/contracts-upgradeable/finance/PaymentSplitterUpgradeable.sol@v4.5.2
6258 
6259 
6260 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
6261 
6262 pragma solidity ^0.8.0;
6263 
6264 
6265 
6266 
6267 /**
6268  * @title PaymentSplitter
6269  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
6270  * that the Ether will be split in this way, since it is handled transparently by the contract.
6271  *
6272  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
6273  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
6274  * an amount proportional to the percentage of total shares they were assigned.
6275  *
6276  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
6277  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
6278  * function.
6279  *
6280  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
6281  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
6282  * to run tests before sending real value to this contract.
6283  */
6284 contract PaymentSplitterUpgradeable is Initializable, ContextUpgradeable {
6285     event PayeeAdded(address account, uint256 shares);
6286     event PaymentReleased(address to, uint256 amount);
6287     event ERC20PaymentReleased(IERC20Upgradeable indexed token, address to, uint256 amount);
6288     event PaymentReceived(address from, uint256 amount);
6289 
6290     uint256 private _totalShares;
6291     uint256 private _totalReleased;
6292 
6293     mapping(address => uint256) private _shares;
6294     mapping(address => uint256) private _released;
6295     address[] private _payees;
6296 
6297     mapping(IERC20Upgradeable => uint256) private _erc20TotalReleased;
6298     mapping(IERC20Upgradeable => mapping(address => uint256)) private _erc20Released;
6299 
6300     /**
6301      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
6302      * the matching position in the `shares` array.
6303      *
6304      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
6305      * duplicates in `payees`.
6306      */
6307     function __PaymentSplitter_init(address[] memory payees, uint256[] memory shares_) internal onlyInitializing {
6308         __PaymentSplitter_init_unchained(payees, shares_);
6309     }
6310 
6311     function __PaymentSplitter_init_unchained(address[] memory payees, uint256[] memory shares_) internal onlyInitializing {
6312         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
6313         require(payees.length > 0, "PaymentSplitter: no payees");
6314 
6315         for (uint256 i = 0; i < payees.length; i++) {
6316             _addPayee(payees[i], shares_[i]);
6317         }
6318     }
6319 
6320     /**
6321      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
6322      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
6323      * reliability of the events, and not the actual splitting of Ether.
6324      *
6325      * To learn more about this see the Solidity documentation for
6326      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
6327      * functions].
6328      */
6329     receive() external payable virtual {
6330         emit PaymentReceived(_msgSender(), msg.value);
6331     }
6332 
6333     /**
6334      * @dev Getter for the total shares held by payees.
6335      */
6336     function totalShares() public view returns (uint256) {
6337         return _totalShares;
6338     }
6339 
6340     /**
6341      * @dev Getter for the total amount of Ether already released.
6342      */
6343     function totalReleased() public view returns (uint256) {
6344         return _totalReleased;
6345     }
6346 
6347     /**
6348      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
6349      * contract.
6350      */
6351     function totalReleased(IERC20Upgradeable token) public view returns (uint256) {
6352         return _erc20TotalReleased[token];
6353     }
6354 
6355     /**
6356      * @dev Getter for the amount of shares held by an account.
6357      */
6358     function shares(address account) public view returns (uint256) {
6359         return _shares[account];
6360     }
6361 
6362     /**
6363      * @dev Getter for the amount of Ether already released to a payee.
6364      */
6365     function released(address account) public view returns (uint256) {
6366         return _released[account];
6367     }
6368 
6369     /**
6370      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
6371      * IERC20 contract.
6372      */
6373     function released(IERC20Upgradeable token, address account) public view returns (uint256) {
6374         return _erc20Released[token][account];
6375     }
6376 
6377     /**
6378      * @dev Getter for the address of the payee number `index`.
6379      */
6380     function payee(uint256 index) public view returns (address) {
6381         return _payees[index];
6382     }
6383 
6384     /**
6385      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
6386      * total shares and their previous withdrawals.
6387      */
6388     function release(address payable account) public virtual {
6389         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
6390 
6391         uint256 totalReceived = address(this).balance + totalReleased();
6392         uint256 payment = _pendingPayment(account, totalReceived, released(account));
6393 
6394         require(payment != 0, "PaymentSplitter: account is not due payment");
6395 
6396         _released[account] += payment;
6397         _totalReleased += payment;
6398 
6399         AddressUpgradeable.sendValue(account, payment);
6400         emit PaymentReleased(account, payment);
6401     }
6402 
6403     /**
6404      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
6405      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
6406      * contract.
6407      */
6408     function release(IERC20Upgradeable token, address account) public virtual {
6409         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
6410 
6411         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
6412         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
6413 
6414         require(payment != 0, "PaymentSplitter: account is not due payment");
6415 
6416         _erc20Released[token][account] += payment;
6417         _erc20TotalReleased[token] += payment;
6418 
6419         SafeERC20Upgradeable.safeTransfer(token, account, payment);
6420         emit ERC20PaymentReleased(token, account, payment);
6421     }
6422 
6423     /**
6424      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
6425      * already released amounts.
6426      */
6427     function _pendingPayment(
6428         address account,
6429         uint256 totalReceived,
6430         uint256 alreadyReleased
6431     ) private view returns (uint256) {
6432         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
6433     }
6434 
6435     /**
6436      * @dev Add a new payee to the contract.
6437      * @param account The address of the payee to add.
6438      * @param shares_ The number of shares owned by the payee.
6439      */
6440     function _addPayee(address account, uint256 shares_) private {
6441         require(account != address(0), "PaymentSplitter: account is the zero address");
6442         require(shares_ > 0, "PaymentSplitter: shares are 0");
6443         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
6444 
6445         _payees.push(account);
6446         _shares[account] = shares_;
6447         _totalShares = _totalShares + shares_;
6448         emit PayeeAdded(account, shares_);
6449     }
6450 
6451     /**
6452      * @dev This empty reserved space is put in place to allow future versions to add new
6453      * variables without shifting down storage in the inheritance chain.
6454      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
6455      */
6456     uint256[43] private __gap;
6457 }
6458 
6459 
6460 // File contracts/SBIIPayment.sol
6461 
6462 
6463 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
6464 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
6465 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
6466 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
6467 
6468 pragma solidity 0.8.13;
6469 
6470 
6471 
6472 // @dev
6473 contract SBIIPayment is Initializable, PaymentSplitterUpgradeable, ISBShipable {
6474     string public constant MODEL = "SBII-paymentSplitterU-test";
6475     bool public allowUpdate;
6476 
6477     function initialize(
6478         bytes memory initArg,
6479         uint128 bip,
6480         address feeReceiver
6481     ) public override initializer {
6482         (address[] memory payee, uint256[] memory share) = abi.decode(
6483             initArg,
6484             (address[], uint256[])
6485         );
6486         __PaymentSplitter_init(payee, share);
6487         // no fee no fee feeReceiver
6488     }
6489 }
6490 
6491 
6492 // File @openzeppelin/contracts-upgradeable/proxy/ClonesUpgradeable.sol@v4.5.2
6493 
6494 
6495 // OpenZeppelin Contracts v4.4.1 (proxy/Clones.sol)
6496 
6497 pragma solidity ^0.8.0;
6498 
6499 /**
6500  * @dev https://eips.ethereum.org/EIPS/eip-1167[EIP 1167] is a standard for
6501  * deploying minimal proxy contracts, also known as "clones".
6502  *
6503  * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
6504  * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
6505  *
6506  * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
6507  * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
6508  * deterministic method.
6509  *
6510  * _Available since v3.4._
6511  */
6512 library ClonesUpgradeable {
6513     /**
6514      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
6515      *
6516      * This function uses the create opcode, which should never revert.
6517      */
6518     function clone(address implementation) internal returns (address instance) {
6519         assembly {
6520             let ptr := mload(0x40)
6521             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
6522             mstore(add(ptr, 0x14), shl(0x60, implementation))
6523             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
6524             instance := create(0, ptr, 0x37)
6525         }
6526         require(instance != address(0), "ERC1167: create failed");
6527     }
6528 
6529     /**
6530      * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
6531      *
6532      * This function uses the create2 opcode and a `salt` to deterministically deploy
6533      * the clone. Using the same `implementation` and `salt` multiple time will revert, since
6534      * the clones cannot be deployed twice at the same address.
6535      */
6536     function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
6537         assembly {
6538             let ptr := mload(0x40)
6539             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
6540             mstore(add(ptr, 0x14), shl(0x60, implementation))
6541             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
6542             instance := create2(0, ptr, 0x37, salt)
6543         }
6544         require(instance != address(0), "ERC1167: create2 failed");
6545     }
6546 
6547     /**
6548      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
6549      */
6550     function predictDeterministicAddress(
6551         address implementation,
6552         bytes32 salt,
6553         address deployer
6554     ) internal pure returns (address predicted) {
6555         assembly {
6556             let ptr := mload(0x40)
6557             mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
6558             mstore(add(ptr, 0x14), shl(0x60, implementation))
6559             mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
6560             mstore(add(ptr, 0x38), shl(0x60, deployer))
6561             mstore(add(ptr, 0x4c), salt)
6562             mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
6563             predicted := keccak256(add(ptr, 0x37), 0x55)
6564         }
6565     }
6566 
6567     /**
6568      * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
6569      */
6570     function predictDeterministicAddress(address implementation, bytes32 salt)
6571         internal
6572         view
6573         returns (address predicted)
6574     {
6575         return predictDeterministicAddress(implementation, salt, address(this));
6576     }
6577 }
6578 
6579 
6580 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
6581 
6582 
6583 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
6584 
6585 pragma solidity ^0.8.0;
6586 
6587 /**
6588  * @dev Contract module which provides a basic access control mechanism, where
6589  * there is an account (an owner) that can be granted exclusive access to
6590  * specific functions.
6591  *
6592  * By default, the owner account will be the one that deploys the contract. This
6593  * can later be changed with {transferOwnership}.
6594  *
6595  * This module is used through inheritance. It will make available the modifier
6596  * `onlyOwner`, which can be applied to your functions to restrict their use to
6597  * the owner.
6598  */
6599 abstract contract Ownable is Context {
6600     address private _owner;
6601 
6602     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6603 
6604     /**
6605      * @dev Initializes the contract setting the deployer as the initial owner.
6606      */
6607     constructor() {
6608         _transferOwnership(_msgSender());
6609     }
6610 
6611     /**
6612      * @dev Returns the address of the current owner.
6613      */
6614     function owner() public view virtual returns (address) {
6615         return _owner;
6616     }
6617 
6618     /**
6619      * @dev Throws if called by any account other than the owner.
6620      */
6621     modifier onlyOwner() {
6622         require(owner() == _msgSender(), "Ownable: caller is not the owner");
6623         _;
6624     }
6625 
6626     /**
6627      * @dev Leaves the contract without owner. It will not be possible to call
6628      * `onlyOwner` functions anymore. Can only be called by the current owner.
6629      *
6630      * NOTE: Renouncing ownership will leave the contract without an owner,
6631      * thereby removing any functionality that is only available to the owner.
6632      */
6633     function renounceOwnership() public virtual onlyOwner {
6634         _transferOwnership(address(0));
6635     }
6636 
6637     /**
6638      * @dev Transfers ownership of the contract to a new account (`newOwner`).
6639      * Can only be called by the current owner.
6640      */
6641     function transferOwnership(address newOwner) public virtual onlyOwner {
6642         require(newOwner != address(0), "Ownable: new owner is the zero address");
6643         _transferOwnership(newOwner);
6644     }
6645 
6646     /**
6647      * @dev Transfers ownership of the contract to a new account (`newOwner`).
6648      * Internal function without access restriction.
6649      */
6650     function _transferOwnership(address newOwner) internal virtual {
6651         address oldOwner = _owner;
6652         _owner = newOwner;
6653         emit OwnershipTransferred(oldOwner, newOwner);
6654     }
6655 }
6656 
6657 
6658 // File contracts/ShipyardII.sol
6659 
6660 
6661 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
6662 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
6663 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
6664 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
6665 
6666 pragma solidity 0.8.13;
6667 
6668 
6669 
6670 
6671 
6672 
6673 contract Shipyard is Ownable {
6674     event NewShip(string reserveName, address newShip, string shipType);
6675 
6676     mapping(bytes32 => address) public shipImplementation;
6677     mapping(bytes32 => string) public shipTypes;
6678 
6679     Quartermaster public quarterMaster;
6680     Lighthouse public lighthouse;
6681 
6682     string public constant MODEL = "SBII-shipyard-test";
6683 
6684     constructor() {}
6685 
6686     function setSail(
6687         string calldata shipType,
6688         string calldata reserveName,
6689         bytes calldata initArg
6690     ) external payable returns (address) {
6691         bytes32 key = keccak256(abi.encodePacked(shipType));
6692         require(shipImplementation[key] != address(0), "not exist");
6693         Quartermaster.Fees memory fees = quarterMaster.getFees(shipType);
6694 
6695         paymentUtil.processPayment(fees.token, fees.onetime);
6696 
6697         address clone = ClonesUpgradeable.clone(shipImplementation[key]);
6698         ISBShipable(clone).initialize(initArg, fees.bip, address(this));
6699         lighthouse.registerContract(
6700             reserveName,
6701             clone,
6702             shipTypes[key],
6703             msg.sender
6704         );
6705         emit NewShip(reserveName, clone, shipTypes[key]);
6706         return clone;
6707     }
6708 
6709     function getPrice(string calldata shipType)
6710         public
6711         view
6712         returns (Quartermaster.Fees memory)
6713     {
6714         return quarterMaster.getFees(shipType);
6715     }
6716 
6717     function addBlueprint(
6718         string memory shipName,
6719         string memory shipType,
6720         address implementation
6721     ) public onlyOwner {
6722         bytes32 key = keccak256(abi.encodePacked(shipName));
6723         shipImplementation[key] = implementation;
6724         shipTypes[key] = shipType;
6725     }
6726 
6727     function removeBlueprint(string memory shipName) public onlyOwner {
6728         shipImplementation[keccak256(abi.encodePacked(shipName))] = address(0);
6729     }
6730 
6731     function withdraw(address tokenAddress) public onlyOwner {
6732         if (tokenAddress == address(0)) {
6733             payable(msg.sender).transfer(address(this).balance);
6734         } else {
6735             IERC20 token = IERC20(tokenAddress);
6736             token.transfer(msg.sender, token.balanceOf(address(this)));
6737         }
6738     }
6739 
6740     function setQM(address qm) public onlyOwner {
6741         quarterMaster = Quartermaster(qm);
6742     }
6743 
6744     function setLH(address lh) public onlyOwner {
6745         lighthouse = Lighthouse(lh);
6746     }
6747 
6748     receive() external payable {}
6749 
6750     fallback() external payable {}
6751 }