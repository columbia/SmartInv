1 // SPDX-License-Identifier: MIT
2 // File: contracts/ERC721Community.sol
3 
4 
5 
6 // Sources flattened with hardhat v2.9.3 https://hardhat.org
7 
8 // File @openzeppelin/contracts/proxy/Proxy.sol@v4.7.0
9 
10 // License-Identifier: MIT
11 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
17  * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
18  * be specified by overriding the virtual {_implementation} function.
19  *
20  * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
21  * different contract through the {_delegate} function.
22  *
23  * The success and return data of the delegated call will be returned back to the caller of the proxy.
24  */
25 abstract contract Proxy {
26     /**
27      * @dev Delegates the current call to `implementation`.
28      *
29      * This function does not return to its internal call site, it will return directly to the external caller.
30      */
31     function _delegate(address implementation) internal virtual {
32         assembly {
33             // Copy msg.data. We take full control of memory in this inline assembly
34             // block because it will not return to Solidity code. We overwrite the
35             // Solidity scratch pad at memory position 0.
36             calldatacopy(0, 0, calldatasize())
37 
38             // Call the implementation.
39             // out and outsize are 0 because we don't know the size yet.
40             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
41 
42             // Copy the returned data.
43             returndatacopy(0, 0, returndatasize())
44 
45             switch result
46             // delegatecall returns 0 on error.
47             case 0 {
48                 revert(0, returndatasize())
49             }
50             default {
51                 return(0, returndatasize())
52             }
53         }
54     }
55 
56     /**
57      * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
58      * and {_fallback} should delegate.
59      */
60     function _implementation() internal view virtual returns (address);
61 
62     /**
63      * @dev Delegates the current call to the address returned by `_implementation()`.
64      *
65      * This function does not return to its internal call site, it will return directly to the external caller.
66      */
67     function _fallback() internal virtual {
68         _beforeFallback();
69         _delegate(_implementation());
70     }
71 
72     /**
73      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
74      * function in the contract matches the call data.
75      */
76     fallback() external payable virtual {
77         _fallback();
78     }
79 
80     /**
81      * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
82      * is empty.
83      */
84     receive() external payable virtual {
85         _fallback();
86     }
87 
88     /**
89      * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
90      * call, or as part of the Solidity `fallback` or `receive` functions.
91      *
92      * If overridden should call `super._beforeFallback()`.
93      */
94     function _beforeFallback() internal virtual {}
95 }
96 
97 
98 // File @openzeppelin/contracts/utils/Address.sol@v4.7.0
99 
100 // License-Identifier: MIT
101 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
102 
103 pragma solidity ^0.8.1;
104 
105 /**
106  * @dev Collection of functions related to the address type
107  */
108 library Address {
109     /**
110      * @dev Returns true if `account` is a contract.
111      *
112      * [IMPORTANT]
113      * ====
114      * It is unsafe to assume that an address for which this function returns
115      * false is an externally-owned account (EOA) and not a contract.
116      *
117      * Among others, `isContract` will return false for the following
118      * types of addresses:
119      *
120      *  - an externally-owned account
121      *  - a contract in construction
122      *  - an address where a contract will be created
123      *  - an address where a contract lived, but was destroyed
124      * ====
125      *
126      * [IMPORTANT]
127      * ====
128      * You shouldn't rely on `isContract` to protect against flash loan attacks!
129      *
130      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
131      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
132      * constructor.
133      * ====
134      */
135     function isContract(address account) internal view returns (bool) {
136         // This method relies on extcodesize/address.code.length, which returns 0
137         // for contracts in construction, since the code is only stored at the end
138         // of the constructor execution.
139 
140         return account.code.length > 0;
141     }
142 
143     /**
144      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
145      * `recipient`, forwarding all available gas and reverting on errors.
146      *
147      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
148      * of certain opcodes, possibly making contracts go over the 2300 gas limit
149      * imposed by `transfer`, making them unable to receive funds via
150      * `transfer`. {sendValue} removes this limitation.
151      *
152      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
153      *
154      * IMPORTANT: because control is transferred to `recipient`, care must be
155      * taken to not create reentrancy vulnerabilities. Consider using
156      * {ReentrancyGuard} or the
157      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
158      */
159     function sendValue(address payable recipient, uint256 amount) internal {
160         require(address(this).balance >= amount, "Address: insufficient balance");
161 
162         (bool success, ) = recipient.call{value: amount}("");
163         require(success, "Address: unable to send value, recipient may have reverted");
164     }
165 
166     /**
167      * @dev Performs a Solidity function call using a low level `call`. A
168      * plain `call` is an unsafe replacement for a function call: use this
169      * function instead.
170      *
171      * If `target` reverts with a revert reason, it is bubbled up by this
172      * function (like regular Solidity function calls).
173      *
174      * Returns the raw returned data. To convert to the expected return value,
175      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
176      *
177      * Requirements:
178      *
179      * - `target` must be a contract.
180      * - calling `target` with `data` must not revert.
181      *
182      * _Available since v3.1._
183      */
184     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
185         return functionCall(target, data, "Address: low-level call failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
190      * `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, 0, errorMessage);
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
204      * but also transferring `value` wei to `target`.
205      *
206      * Requirements:
207      *
208      * - the calling contract must have an ETH balance of at least `value`.
209      * - the called Solidity function must be `payable`.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(
214         address target,
215         bytes memory data,
216         uint256 value
217     ) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
223      * with `errorMessage` as a fallback revert reason when `target` reverts.
224      *
225      * _Available since v3.1._
226      */
227     function functionCallWithValue(
228         address target,
229         bytes memory data,
230         uint256 value,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         require(address(this).balance >= value, "Address: insufficient balance for call");
234         require(isContract(target), "Address: call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.call{value: value}(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a static call.
243      *
244      * _Available since v3.3._
245      */
246     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
247         return functionStaticCall(target, data, "Address: low-level static call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a static call.
253      *
254      * _Available since v3.3._
255      */
256     function functionStaticCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal view returns (bytes memory) {
261         require(isContract(target), "Address: static call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.staticcall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
274         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
279      * but performing a delegate call.
280      *
281      * _Available since v3.4._
282      */
283     function functionDelegateCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         require(isContract(target), "Address: delegate call to non-contract");
289 
290         (bool success, bytes memory returndata) = target.delegatecall(data);
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
296      * revert reason using the provided one.
297      *
298      * _Available since v4.3._
299      */
300     function verifyCallResult(
301         bool success,
302         bytes memory returndata,
303         string memory errorMessage
304     ) internal pure returns (bytes memory) {
305         if (success) {
306             return returndata;
307         } else {
308             // Look for revert reason and bubble it up if present
309             if (returndata.length > 0) {
310                 // The easiest way to bubble the revert reason is using memory via assembly
311                 /// @solidity memory-safe-assembly
312                 assembly {
313                     let returndata_size := mload(returndata)
314                     revert(add(32, returndata), returndata_size)
315                 }
316             } else {
317                 revert(errorMessage);
318             }
319         }
320     }
321 }
322 
323 
324 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.0
325 
326 // License-Identifier: MIT
327 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Interface of the ERC165 standard, as defined in the
333  * https://eips.ethereum.org/EIPS/eip-165[EIP].
334  *
335  * Implementers can declare support of contract interfaces, which can then be
336  * queried by others ({ERC165Checker}).
337  *
338  * For an implementation, see {ERC165}.
339  */
340 interface IERC165 {
341     /**
342      * @dev Returns true if this contract implements the interface defined by
343      * `interfaceId`. See the corresponding
344      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
345      * to learn more about how these ids are created.
346      *
347      * This function call must use less than 30 000 gas.
348      */
349     function supportsInterface(bytes4 interfaceId) external view returns (bool);
350 }
351 
352 
353 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.0
354 
355 // License-Identifier: MIT
356 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Required interface of an ERC721 compliant contract.
362  */
363 interface IERC721 is IERC165 {
364     /**
365      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
366      */
367     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
368 
369     /**
370      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
371      */
372     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
373 
374     /**
375      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
376      */
377     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
378 
379     /**
380      * @dev Returns the number of tokens in ``owner``'s account.
381      */
382     function balanceOf(address owner) external view returns (uint256 balance);
383 
384     /**
385      * @dev Returns the owner of the `tokenId` token.
386      *
387      * Requirements:
388      *
389      * - `tokenId` must exist.
390      */
391     function ownerOf(uint256 tokenId) external view returns (address owner);
392 
393     /**
394      * @dev Safely transfers `tokenId` token from `from` to `to`.
395      *
396      * Requirements:
397      *
398      * - `from` cannot be the zero address.
399      * - `to` cannot be the zero address.
400      * - `tokenId` token must exist and be owned by `from`.
401      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
402      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
403      *
404      * Emits a {Transfer} event.
405      */
406     function safeTransferFrom(
407         address from,
408         address to,
409         uint256 tokenId,
410         bytes calldata data
411     ) external;
412 
413     /**
414      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
415      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
416      *
417      * Requirements:
418      *
419      * - `from` cannot be the zero address.
420      * - `to` cannot be the zero address.
421      * - `tokenId` token must exist and be owned by `from`.
422      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
423      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
424      *
425      * Emits a {Transfer} event.
426      */
427     function safeTransferFrom(
428         address from,
429         address to,
430         uint256 tokenId
431     ) external;
432 
433     /**
434      * @dev Transfers `tokenId` token from `from` to `to`.
435      *
436      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
437      *
438      * Requirements:
439      *
440      * - `from` cannot be the zero address.
441      * - `to` cannot be the zero address.
442      * - `tokenId` token must be owned by `from`.
443      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
444      *
445      * Emits a {Transfer} event.
446      */
447     function transferFrom(
448         address from,
449         address to,
450         uint256 tokenId
451     ) external;
452 
453     /**
454      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
455      * The approval is cleared when the token is transferred.
456      *
457      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
458      *
459      * Requirements:
460      *
461      * - The caller must own the token or be an approved operator.
462      * - `tokenId` must exist.
463      *
464      * Emits an {Approval} event.
465      */
466     function approve(address to, uint256 tokenId) external;
467 
468     /**
469      * @dev Approve or remove `operator` as an operator for the caller.
470      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
471      *
472      * Requirements:
473      *
474      * - The `operator` cannot be the caller.
475      *
476      * Emits an {ApprovalForAll} event.
477      */
478     function setApprovalForAll(address operator, bool _approved) external;
479 
480     /**
481      * @dev Returns the account approved for `tokenId` token.
482      *
483      * Requirements:
484      *
485      * - `tokenId` must exist.
486      */
487     function getApproved(uint256 tokenId) external view returns (address operator);
488 
489     /**
490      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
491      *
492      * See {setApprovalForAll}
493      */
494     function isApprovedForAll(address owner, address operator) external view returns (bool);
495 }
496 
497 
498 // File contracts/interfaces/IERC721Community.sol
499 
500 // License-Identifier: MIT
501 pragma solidity ^0.8.9;
502 
503 /** @dev config includes values have setters and can be changed later */
504 struct MintConfig {
505     uint256 publicPrice;
506     uint256 maxTokensPerMint;
507     uint256 maxTokensPerWallet;
508     uint256 royaltyFee;
509     address payoutReceiver;
510     bool shouldLockPayoutReceiver;
511     bool shouldStartSale;
512     bool shouldUseJsonExtension;
513 }
514 
515 interface IERC721Community {
516     function DEVELOPER() external pure returns (string memory _url);
517 
518     function DEVELOPER_ADDRESS() external pure returns (address payable _dev);
519 
520     // ------ View functions ------
521     function saleStarted() external view returns (bool);
522 
523     function isExtensionAdded(address extension) external view returns (bool);
524 
525     /**
526         Extra information stored for each tokenId. Optional, provided on mint
527      */
528     function data(uint256 tokenId) external view returns (bytes32);
529 
530     // ------ Mint functions ------
531     /**
532         Mint from NFTExtension contract. Optionally provide data parameter.
533      */
534     function mintExternal(
535         uint256 amount,
536         address to,
537         bytes32 data
538     ) external payable;
539 
540     // ------ Admin functions ------
541     function addExtension(address extension) external;
542 
543     function revokeExtension(address extension) external;
544 
545     function withdraw() external;
546 
547     // ------ View functions ------
548     /**
549         Recommended royalty for tokenId sale.
550      */
551     function royaltyInfo(uint256 tokenId, uint256 salePrice)
552         external
553         view
554         returns (address receiver, uint256 royaltyAmount);
555 
556     // ------ Admin functions ------
557     function setRoyaltyReceiver(address receiver) external;
558 
559     function setRoyaltyFee(uint256 fee) external;
560 }
561 
562 interface IERC721CommunityImplementation {
563     function initialize(
564         string memory _name,
565         string memory _symbol,
566         uint256 _maxSupply,
567         uint256 _nReserved,
568         bool _startAtOne,
569         string memory uri,
570         MintConfig memory config
571     ) external;
572 }
573 
574 
575 // File contracts/ERC721Community.sol
576 
577 // License-Identifier: MIT
578 pragma solidity ^0.8.0;
579 
580 
581 /**
582  * @title made by buildship.xyz
583  * @dev ERC721Community is extendable implementation of ERC721 based on ERC721A and ERC721CommunityImplementation.
584  */
585 
586 //      Want to launch your own collection?
587 //        Check out https://buildship.xyz
588 
589 //                                    ,:loxO0KXXc
590 //                               ,cdOKKKOxol:lKWl
591 //                            ;oOXKko:,      ;KNc
592 //                         ox0X0d:           cNK,
593 //                      ;xXX0x:              dWk
594 //            ,cdO0KKKKKXKo,                ,0Nl
595 //         ;oOXKko:,;kWMNl                  dWO'
596 //      ,o0XKd:'    oNMMK:                 cXX:
597 //   'ckNNk:       ;KMN0c                 cXXl
598 //  'OWMMWKOdl;     cl;                  oXXc
599 //   ;cclldxOKXKkl,                    ;kNO;
600 //            ;cdk0kl'             ;clxXXo
601 //                ':oxo'         c0WMMMMK;
602 //                    :l:       lNMWXxOWWo
603 //                      ';      :xdc' :XWd
604 //             ,                      cXK;
605 //           ':,                      xXl
606 //           ;:      '               o0c
607 //           ;c;,,,,'               lx;
608 //            '''                  cc
609 //                                ,'
610 
611 type StartFromTokenIdOne is bool;
612 
613 contract ERC721Community is Proxy {
614     address internal constant proxyImplementation =
615         0xf3E07A5cBDFE6a257A7caa4Fcb3187A1C2Ec6a2E;
616 
617     StartFromTokenIdOne internal constant START_FROM_ONE = StartFromTokenIdOne.wrap(true);
618     StartFromTokenIdOne internal constant START_FROM_ZERO = StartFromTokenIdOne.wrap(false);
619 
620     constructor(
621         string memory name,
622         string memory symbol,
623         uint256 maxSupply,
624         uint256 nReserved,
625         StartFromTokenIdOne startAtOne,
626         string memory uri,
627         MintConfig memory configValues
628     ) {
629         Address.functionDelegateCall(
630             proxyImplementation,
631             abi.encodeWithSelector(
632                 IERC721CommunityImplementation.initialize.selector,
633                 name,
634                 symbol,
635                 maxSupply,
636                 nReserved,
637                 startAtOne,
638                 uri,
639                 configValues
640             )
641         );
642     }
643 
644     function implementation() public pure returns (address) {
645         return _implementation();
646     }
647 
648     function _implementation() internal pure override returns (address) {
649         return address(proxyImplementation);
650     }
651 }
652 // File: contracts/dotdecode.sol
653 
654 
655 
656 pragma solidity ^0.8.9;
657 
658 // name: Dot Decode
659 // contract by: buildship.xyz
660 
661 
662 
663 
664 contract DotDecode is ERC721Community {
665     constructor() ERC721Community("Dot Decode", "DD", 36000, 360, START_FROM_ONE, "ipfs://bafybeiegh3mkxom6ylm5c7ndre565eopc7dctkkg5ohahuenptjqkxghuy/",
666                                   MintConfig(0.0001 ether, 10, 50, 0, 0x8003B00e7849182A85fFE1c16737964913c79083, false, false, true)) {}
667 }