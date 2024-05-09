1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
5 
6 
7 // Part: IRegistry
8 
9 //              @@@@@@@@@@@@@@@@        ,@@@@@@@@@@@@@@@@
10 //              @@@,,,,,,,,,,@@@        ,@@&,,,,,,,,,,@@@
11 //         @@@@@@@@,,,,,,,,,,@@@@@@@@&  ,@@&,,,,,,,,,,@@@@@@@@
12 //         @@@**********@@@@@@@@@@@@@&  ,@@@@@@@@**********@@@
13 //         @@@**********@@@@@@@@@@@@@&  ,@@@@@@@@**********@@@@@@@@
14 //         @@@**********@@@@@@@@@@@@@&       .@@@**********@@@@@@@@
15 //    @@@@@@@@**********@@@@@@@@@@@@@&       .@@@**********@@@@@@@@
16 //    @@@**********@@@@@@@@@@@@@&            .@@@@@@@@**********@@@
17 //    @@@**********@@@@@@@@@@@@@&            .@@@@@@@@**********@@@@@@@@
18 //    @@@@@@@@**********@@@@@@@@&            .@@@**********@@@@@@@@@@@@@
19 //    @@@@@@@@//////////@@@@@@@@&            .@@@//////////@@@@@@@@@@@@@
20 //         @@@//////////@@@@@@@@&            .@@@//////////@@@@@@@@@@@@@
21 //         @@@//////////@@@@@@@@&       ,@@@@@@@@//////////@@@@@@@@@@@@@
22 //         @@@%%%%%/////(((((@@@&       ,@@@(((((/////%%%%%@@@@@@@@
23 //         @@@@@@@@//////////@@@@@@@@&  ,@@@//////////@@@@@@@@@@@@@
24 //              @@@%%%%%%%%%%@@@@@@@@&  ,@@@%%%%%%%%%%@@@@@@@@@@@@@
25 //              @@@@@@@@@@@@@@@@@@@@@&  ,@@@@@@@@@@@@@@@@@@@@@@@@@@
26 //                   @@@@@@@@@@@@@@@@&        @@@@@@@@@@@@@@@@
27 //                   @@@@@@@@@@@@@@@@&        @@@@@@@@@@@@@@@@
28 
29 interface IRegistry {
30     event Lend(
31         bool is721,
32         address indexed lenderAddress,
33         address indexed nftAddress,
34         uint256 indexed tokenID,
35         uint256 lendingID,
36         uint8 maxRentDuration,
37         bytes4 dailyRentPrice,
38         uint16 lendAmount,
39         IResolver.PaymentToken paymentToken
40     );
41 
42     event Rent(
43         address indexed renterAddress,
44         uint256 indexed lendingID,
45         uint256 indexed rentingID,
46         uint16 rentAmount,
47         uint8 rentDuration,
48         uint32 rentedAt
49     );
50 
51     event StopLend(uint256 indexed lendingID, uint32 stoppedAt);
52 
53     event StopRent(uint256 indexed rentingID, uint32 stoppedAt);
54 
55     event RentClaimed(uint256 indexed rentingID, uint32 collectedAt);
56 
57     enum NFTStandard {
58         E721,
59         E1155
60     }
61 
62     struct CallData {
63         uint256 left;
64         uint256 right;
65         IRegistry.NFTStandard[] nftStandard;
66         address[] nftAddress;
67         uint256[] tokenID;
68         uint256[] lendAmount;
69         uint8[] maxRentDuration;
70         bytes4[] dailyRentPrice;
71         uint256[] lendingID;
72         uint256[] rentingID;
73         uint8[] rentDuration;
74         uint256[] rentAmount;
75         IResolver.PaymentToken[] paymentToken;
76     }
77 
78     // 2, 162, 170, 202, 218, 234, 242
79     struct Lending {
80         NFTStandard nftStandard;
81         address payable lenderAddress;
82         uint8 maxRentDuration;
83         bytes4 dailyRentPrice;
84         uint16 lendAmount;
85         uint16 availableAmount;
86         IResolver.PaymentToken paymentToken;
87     }
88 
89     // 180, 212
90     struct Renting {
91         address payable renterAddress;
92         uint8 rentDuration;
93         uint32 rentedAt;
94         uint16 rentAmount;
95     }
96 
97     // creates the lending structs and adds them to the enumerable set
98     function lend(
99         IRegistry.NFTStandard[] memory nftStandard,
100         address[] memory nftAddress,
101         uint256[] memory tokenID,
102         uint256[] memory lendAmount,
103         uint8[] memory maxRentDuration,
104         bytes4[] memory dailyRentPrice,
105         IResolver.PaymentToken[] memory paymentToken
106     ) external;
107 
108     function stopLend(
109         IRegistry.NFTStandard[] memory nftStandard,
110         address[] memory nftAddress,
111         uint256[] memory tokenID,
112         uint256[] memory lendingID
113     ) external;
114 
115     // // creates the renting structs and adds them to the enumerable set
116     function rent(
117         IRegistry.NFTStandard[] memory nftStandard,
118         address[] memory nftAddress,
119         uint256[] memory tokenID,
120         uint256[] memory lendingID,
121         uint8[] memory rentDuration,
122         uint256[] memory rentAmount
123     ) external payable;
124 
125     function stopRent(
126         IRegistry.NFTStandard[] memory nftStandard,
127         address[] memory nftAddress,
128         uint256[] memory tokenID,
129         uint256[] memory lendingID,
130         uint256[] memory rentingID
131     ) external;
132 
133     function claimRent(
134         IRegistry.NFTStandard[] memory nftStandard,
135         address[] memory nftAddress,
136         uint256[] memory tokenID,
137         uint256[] memory lendingID,
138         uint256[] memory rentingID
139     ) external;
140 }
141 
142 // Part: IResolver
143 
144 //              @@@@@@@@@@@@@@@@        ,@@@@@@@@@@@@@@@@
145 //              @@@,,,,,,,,,,@@@        ,@@&,,,,,,,,,,@@@
146 //         @@@@@@@@,,,,,,,,,,@@@@@@@@&  ,@@&,,,,,,,,,,@@@@@@@@
147 //         @@@**********@@@@@@@@@@@@@&  ,@@@@@@@@**********@@@
148 //         @@@**********@@@@@@@@@@@@@&  ,@@@@@@@@**********@@@@@@@@
149 //         @@@**********@@@@@@@@@@@@@&       .@@@**********@@@@@@@@
150 //    @@@@@@@@**********@@@@@@@@@@@@@&       .@@@**********@@@@@@@@
151 //    @@@**********@@@@@@@@@@@@@&            .@@@@@@@@**********@@@
152 //    @@@**********@@@@@@@@@@@@@&            .@@@@@@@@**********@@@@@@@@
153 //    @@@@@@@@**********@@@@@@@@&            .@@@**********@@@@@@@@@@@@@
154 //    @@@@@@@@//////////@@@@@@@@&            .@@@//////////@@@@@@@@@@@@@
155 //         @@@//////////@@@@@@@@&            .@@@//////////@@@@@@@@@@@@@
156 //         @@@//////////@@@@@@@@&       ,@@@@@@@@//////////@@@@@@@@@@@@@
157 //         @@@%%%%%/////(((((@@@&       ,@@@(((((/////%%%%%@@@@@@@@
158 //         @@@@@@@@//////////@@@@@@@@&  ,@@@//////////@@@@@@@@@@@@@
159 //              @@@%%%%%%%%%%@@@@@@@@&  ,@@@%%%%%%%%%%@@@@@@@@@@@@@
160 //              @@@@@@@@@@@@@@@@@@@@@&  ,@@@@@@@@@@@@@@@@@@@@@@@@@@
161 //                   @@@@@@@@@@@@@@@@&        @@@@@@@@@@@@@@@@
162 //                   @@@@@@@@@@@@@@@@&        @@@@@@@@@@@@@@@@
163 
164 interface IResolver {
165     enum PaymentToken {
166         SENTINEL,
167         DAI,
168         USDC,
169         TUSD
170     }
171 
172     function getPaymentToken(uint8 _pt) external view returns (address);
173 
174     function setPaymentToken(uint8 _pt, address _v) external;
175 }
176 
177 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/Address
178 
179 /**
180  * @dev Collection of functions related to the address type
181  */
182 library Address {
183     /**
184      * @dev Returns true if `account` is a contract.
185      *
186      * [IMPORTANT]
187      * ====
188      * It is unsafe to assume that an address for which this function returns
189      * false is an externally-owned account (EOA) and not a contract.
190      *
191      * Among others, `isContract` will return false for the following
192      * types of addresses:
193      *
194      *  - an externally-owned account
195      *  - a contract in construction
196      *  - an address where a contract will be created
197      *  - an address where a contract lived, but was destroyed
198      * ====
199      */
200     function isContract(address account) internal view returns (bool) {
201         // This method relies on extcodesize, which returns 0 for contracts in
202         // construction, since the code is only stored at the end of the
203         // constructor execution.
204 
205         uint256 size;
206         assembly {
207             size := extcodesize(account)
208         }
209         return size > 0;
210     }
211 
212     /**
213      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
214      * `recipient`, forwarding all available gas and reverting on errors.
215      *
216      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
217      * of certain opcodes, possibly making contracts go over the 2300 gas limit
218      * imposed by `transfer`, making them unable to receive funds via
219      * `transfer`. {sendValue} removes this limitation.
220      *
221      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
222      *
223      * IMPORTANT: because control is transferred to `recipient`, care must be
224      * taken to not create reentrancy vulnerabilities. Consider using
225      * {ReentrancyGuard} or the
226      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
227      */
228     function sendValue(address payable recipient, uint256 amount) internal {
229         require(address(this).balance >= amount, "Address: insufficient balance");
230 
231         (bool success, ) = recipient.call{value: amount}("");
232         require(success, "Address: unable to send value, recipient may have reverted");
233     }
234 
235     /**
236      * @dev Performs a Solidity function call using a low level `call`. A
237      * plain `call` is an unsafe replacement for a function call: use this
238      * function instead.
239      *
240      * If `target` reverts with a revert reason, it is bubbled up by this
241      * function (like regular Solidity function calls).
242      *
243      * Returns the raw returned data. To convert to the expected return value,
244      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
245      *
246      * Requirements:
247      *
248      * - `target` must be a contract.
249      * - calling `target` with `data` must not revert.
250      *
251      * _Available since v3.1._
252      */
253     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionCall(target, data, "Address: low-level call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
259      * `errorMessage` as a fallback revert reason when `target` reverts.
260      *
261      * _Available since v3.1._
262      */
263     function functionCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         return functionCallWithValue(target, data, 0, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but also transferring `value` wei to `target`.
274      *
275      * Requirements:
276      *
277      * - the calling contract must have an ETH balance of at least `value`.
278      * - the called Solidity function must be `payable`.
279      *
280      * _Available since v3.1._
281      */
282     function functionCallWithValue(
283         address target,
284         bytes memory data,
285         uint256 value
286     ) internal returns (bytes memory) {
287         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
292      * with `errorMessage` as a fallback revert reason when `target` reverts.
293      *
294      * _Available since v3.1._
295      */
296     function functionCallWithValue(
297         address target,
298         bytes memory data,
299         uint256 value,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         require(address(this).balance >= value, "Address: insufficient balance for call");
303         require(isContract(target), "Address: call to non-contract");
304 
305         (bool success, bytes memory returndata) = target.call{value: value}(data);
306         return verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but performing a static call.
312      *
313      * _Available since v3.3._
314      */
315     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
316         return functionStaticCall(target, data, "Address: low-level static call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
321      * but performing a static call.
322      *
323      * _Available since v3.3._
324      */
325     function functionStaticCall(
326         address target,
327         bytes memory data,
328         string memory errorMessage
329     ) internal view returns (bytes memory) {
330         require(isContract(target), "Address: static call to non-contract");
331 
332         (bool success, bytes memory returndata) = target.staticcall(data);
333         return verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a delegate call.
339      *
340      * _Available since v3.4._
341      */
342     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
343         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a delegate call.
349      *
350      * _Available since v3.4._
351      */
352     function functionDelegateCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         require(isContract(target), "Address: delegate call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.delegatecall(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
365      * revert reason using the provided one.
366      *
367      * _Available since v4.3._
368      */
369     function verifyCallResult(
370         bool success,
371         bytes memory returndata,
372         string memory errorMessage
373     ) internal pure returns (bytes memory) {
374         if (success) {
375             return returndata;
376         } else {
377             // Look for revert reason and bubble it up if present
378             if (returndata.length > 0) {
379                 // The easiest way to bubble the revert reason is using memory via assembly
380 
381                 assembly {
382                     let returndata_size := mload(returndata)
383                     revert(add(32, returndata), returndata_size)
384                 }
385             } else {
386                 revert(errorMessage);
387             }
388         }
389     }
390 }
391 
392 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/Context
393 
394 /**
395  * @dev Provides information about the current execution context, including the
396  * sender of the transaction and its data. While these are generally available
397  * via msg.sender and msg.data, they should not be accessed in such a direct
398  * manner, since when dealing with meta-transactions the account sending and
399  * paying for execution may not be the actual sender (as far as an application
400  * is concerned).
401  *
402  * This contract is only required for intermediate, library-like contracts.
403  */
404 abstract contract Context {
405     function _msgSender() internal view virtual returns (address) {
406         return msg.sender;
407     }
408 
409     function _msgData() internal view virtual returns (bytes calldata) {
410         return msg.data;
411     }
412 }
413 
414 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC165
415 
416 /**
417  * @dev Interface of the ERC165 standard, as defined in the
418  * https://eips.ethereum.org/EIPS/eip-165[EIP].
419  *
420  * Implementers can declare support of contract interfaces, which can then be
421  * queried by others ({ERC165Checker}).
422  *
423  * For an implementation, see {ERC165}.
424  */
425 interface IERC165 {
426     /**
427      * @dev Returns true if this contract implements the interface defined by
428      * `interfaceId`. See the corresponding
429      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
430      * to learn more about how these ids are created.
431      *
432      * This function call must use less than 30 000 gas.
433      */
434     function supportsInterface(bytes4 interfaceId) external view returns (bool);
435 }
436 
437 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC20
438 
439 /**
440  * @dev Interface of the ERC20 standard as defined in the EIP.
441  */
442 interface IERC20 {
443     /**
444      * @dev Returns the amount of tokens in existence.
445      */
446     function totalSupply() external view returns (uint256);
447 
448     /**
449      * @dev Returns the amount of tokens owned by `account`.
450      */
451     function balanceOf(address account) external view returns (uint256);
452 
453     /**
454      * @dev Moves `amount` tokens from the caller's account to `recipient`.
455      *
456      * Returns a boolean value indicating whether the operation succeeded.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transfer(address recipient, uint256 amount) external returns (bool);
461 
462     /**
463      * @dev Returns the remaining number of tokens that `spender` will be
464      * allowed to spend on behalf of `owner` through {transferFrom}. This is
465      * zero by default.
466      *
467      * This value changes when {approve} or {transferFrom} are called.
468      */
469     function allowance(address owner, address spender) external view returns (uint256);
470 
471     /**
472      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
473      *
474      * Returns a boolean value indicating whether the operation succeeded.
475      *
476      * IMPORTANT: Beware that changing an allowance with this method brings the risk
477      * that someone may use both the old and the new allowance by unfortunate
478      * transaction ordering. One possible solution to mitigate this race
479      * condition is to first reduce the spender's allowance to 0 and set the
480      * desired value afterwards:
481      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
482      *
483      * Emits an {Approval} event.
484      */
485     function approve(address spender, uint256 amount) external returns (bool);
486 
487     /**
488      * @dev Moves `amount` tokens from `sender` to `recipient` using the
489      * allowance mechanism. `amount` is then deducted from the caller's
490      * allowance.
491      *
492      * Returns a boolean value indicating whether the operation succeeded.
493      *
494      * Emits a {Transfer} event.
495      */
496     function transferFrom(
497         address sender,
498         address recipient,
499         uint256 amount
500     ) external returns (bool);
501 
502     /**
503      * @dev Emitted when `value` tokens are moved from one account (`from`) to
504      * another (`to`).
505      *
506      * Note that `value` may be zero.
507      */
508     event Transfer(address indexed from, address indexed to, uint256 value);
509 
510     /**
511      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
512      * a call to {approve}. `value` is the new allowance.
513      */
514     event Approval(address indexed owner, address indexed spender, uint256 value);
515 }
516 
517 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC721Receiver
518 
519 /**
520  * @title ERC721 token receiver interface
521  * @dev Interface for any contract that wants to support safeTransfers
522  * from ERC721 asset contracts.
523  */
524 interface IERC721Receiver {
525     /**
526      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
527      * by `operator` from `from`, this function is called.
528      *
529      * It must return its Solidity selector to confirm the token transfer.
530      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
531      *
532      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
533      */
534     function onERC721Received(
535         address operator,
536         address from,
537         uint256 tokenId,
538         bytes calldata data
539     ) external returns (bytes4);
540 }
541 
542 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ERC165
543 
544 /**
545  * @dev Implementation of the {IERC165} interface.
546  *
547  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
548  * for the additional interface id that will be supported. For example:
549  *
550  * ```solidity
551  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
553  * }
554  * ```
555  *
556  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
557  */
558 abstract contract ERC165 is IERC165 {
559     /**
560      * @dev See {IERC165-supportsInterface}.
561      */
562     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563         return interfaceId == type(IERC165).interfaceId;
564     }
565 }
566 
567 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ERC721Holder
568 
569 /**
570  * @dev Implementation of the {IERC721Receiver} interface.
571  *
572  * Accepts all token transfers.
573  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
574  */
575 contract ERC721Holder is IERC721Receiver {
576     /**
577      * @dev See {IERC721Receiver-onERC721Received}.
578      *
579      * Always returns `IERC721Receiver.onERC721Received.selector`.
580      */
581     function onERC721Received(
582         address,
583         address,
584         uint256,
585         bytes memory
586     ) public virtual override returns (bytes4) {
587         return this.onERC721Received.selector;
588     }
589 }
590 
591 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC1155
592 
593 /**
594  * @dev Required interface of an ERC1155 compliant contract, as defined in the
595  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
596  *
597  * _Available since v3.1._
598  */
599 interface IERC1155 is IERC165 {
600     /**
601      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
602      */
603     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
604 
605     /**
606      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
607      * transfers.
608      */
609     event TransferBatch(
610         address indexed operator,
611         address indexed from,
612         address indexed to,
613         uint256[] ids,
614         uint256[] values
615     );
616 
617     /**
618      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
619      * `approved`.
620      */
621     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
622 
623     /**
624      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
625      *
626      * If an {URI} event was emitted for `id`, the standard
627      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
628      * returned by {IERC1155MetadataURI-uri}.
629      */
630     event URI(string value, uint256 indexed id);
631 
632     /**
633      * @dev Returns the amount of tokens of token type `id` owned by `account`.
634      *
635      * Requirements:
636      *
637      * - `account` cannot be the zero address.
638      */
639     function balanceOf(address account, uint256 id) external view returns (uint256);
640 
641     /**
642      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
643      *
644      * Requirements:
645      *
646      * - `accounts` and `ids` must have the same length.
647      */
648     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
649         external
650         view
651         returns (uint256[] memory);
652 
653     /**
654      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
655      *
656      * Emits an {ApprovalForAll} event.
657      *
658      * Requirements:
659      *
660      * - `operator` cannot be the caller.
661      */
662     function setApprovalForAll(address operator, bool approved) external;
663 
664     /**
665      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
666      *
667      * See {setApprovalForAll}.
668      */
669     function isApprovedForAll(address account, address operator) external view returns (bool);
670 
671     /**
672      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
673      *
674      * Emits a {TransferSingle} event.
675      *
676      * Requirements:
677      *
678      * - `to` cannot be the zero address.
679      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
680      * - `from` must have a balance of tokens of type `id` of at least `amount`.
681      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
682      * acceptance magic value.
683      */
684     function safeTransferFrom(
685         address from,
686         address to,
687         uint256 id,
688         uint256 amount,
689         bytes calldata data
690     ) external;
691 
692     /**
693      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
694      *
695      * Emits a {TransferBatch} event.
696      *
697      * Requirements:
698      *
699      * - `ids` and `amounts` must have the same length.
700      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
701      * acceptance magic value.
702      */
703     function safeBatchTransferFrom(
704         address from,
705         address to,
706         uint256[] calldata ids,
707         uint256[] calldata amounts,
708         bytes calldata data
709     ) external;
710 }
711 
712 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC1155Receiver
713 
714 /**
715  * @dev _Available since v3.1._
716  */
717 interface IERC1155Receiver is IERC165 {
718     /**
719         @dev Handles the receipt of a single ERC1155 token type. This function is
720         called at the end of a `safeTransferFrom` after the balance has been updated.
721         To accept the transfer, this must return
722         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
723         (i.e. 0xf23a6e61, or its own function selector).
724         @param operator The address which initiated the transfer (i.e. msg.sender)
725         @param from The address which previously owned the token
726         @param id The ID of the token being transferred
727         @param value The amount of tokens being transferred
728         @param data Additional data with no specified format
729         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
730     */
731     function onERC1155Received(
732         address operator,
733         address from,
734         uint256 id,
735         uint256 value,
736         bytes calldata data
737     ) external returns (bytes4);
738 
739     /**
740         @dev Handles the receipt of a multiple ERC1155 token types. This function
741         is called at the end of a `safeBatchTransferFrom` after the balances have
742         been updated. To accept the transfer(s), this must return
743         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
744         (i.e. 0xbc197c81, or its own function selector).
745         @param operator The address which initiated the batch transfer (i.e. msg.sender)
746         @param from The address which previously owned the token
747         @param ids An array containing ids of each token being transferred (order and length must match values array)
748         @param values An array containing amounts of each token being transferred (order and length must match ids array)
749         @param data Additional data with no specified format
750         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
751     */
752     function onERC1155BatchReceived(
753         address operator,
754         address from,
755         uint256[] calldata ids,
756         uint256[] calldata values,
757         bytes calldata data
758     ) external returns (bytes4);
759 }
760 
761 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC20Metadata
762 
763 /**
764  * @dev Interface for the optional metadata functions from the ERC20 standard.
765  *
766  * _Available since v4.1._
767  */
768 interface IERC20Metadata is IERC20 {
769     /**
770      * @dev Returns the name of the token.
771      */
772     function name() external view returns (string memory);
773 
774     /**
775      * @dev Returns the symbol of the token.
776      */
777     function symbol() external view returns (string memory);
778 
779     /**
780      * @dev Returns the decimals places of the token.
781      */
782     function decimals() external view returns (uint8);
783 }
784 
785 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/IERC721
786 
787 /**
788  * @dev Required interface of an ERC721 compliant contract.
789  */
790 interface IERC721 is IERC165 {
791     /**
792      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
793      */
794     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
795 
796     /**
797      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
798      */
799     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
800 
801     /**
802      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
803      */
804     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
805 
806     /**
807      * @dev Returns the number of tokens in ``owner``'s account.
808      */
809     function balanceOf(address owner) external view returns (uint256 balance);
810 
811     /**
812      * @dev Returns the owner of the `tokenId` token.
813      *
814      * Requirements:
815      *
816      * - `tokenId` must exist.
817      */
818     function ownerOf(uint256 tokenId) external view returns (address owner);
819 
820     /**
821      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
822      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
823      *
824      * Requirements:
825      *
826      * - `from` cannot be the zero address.
827      * - `to` cannot be the zero address.
828      * - `tokenId` token must exist and be owned by `from`.
829      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
830      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
831      *
832      * Emits a {Transfer} event.
833      */
834     function safeTransferFrom(
835         address from,
836         address to,
837         uint256 tokenId
838     ) external;
839 
840     /**
841      * @dev Transfers `tokenId` token from `from` to `to`.
842      *
843      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
844      *
845      * Requirements:
846      *
847      * - `from` cannot be the zero address.
848      * - `to` cannot be the zero address.
849      * - `tokenId` token must be owned by `from`.
850      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
851      *
852      * Emits a {Transfer} event.
853      */
854     function transferFrom(
855         address from,
856         address to,
857         uint256 tokenId
858     ) external;
859 
860     /**
861      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
862      * The approval is cleared when the token is transferred.
863      *
864      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
865      *
866      * Requirements:
867      *
868      * - The caller must own the token or be an approved operator.
869      * - `tokenId` must exist.
870      *
871      * Emits an {Approval} event.
872      */
873     function approve(address to, uint256 tokenId) external;
874 
875     /**
876      * @dev Returns the account approved for `tokenId` token.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must exist.
881      */
882     function getApproved(uint256 tokenId) external view returns (address operator);
883 
884     /**
885      * @dev Approve or remove `operator` as an operator for the caller.
886      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
887      *
888      * Requirements:
889      *
890      * - The `operator` cannot be the caller.
891      *
892      * Emits an {ApprovalForAll} event.
893      */
894     function setApprovalForAll(address operator, bool _approved) external;
895 
896     /**
897      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
898      *
899      * See {setApprovalForAll}
900      */
901     function isApprovedForAll(address owner, address operator) external view returns (bool);
902 
903     /**
904      * @dev Safely transfers `tokenId` token from `from` to `to`.
905      *
906      * Requirements:
907      *
908      * - `from` cannot be the zero address.
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must exist and be owned by `from`.
911      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
912      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
913      *
914      * Emits a {Transfer} event.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId,
920         bytes calldata data
921     ) external;
922 }
923 
924 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/SafeERC20
925 
926 /**
927  * @title SafeERC20
928  * @dev Wrappers around ERC20 operations that throw on failure (when the token
929  * contract returns false). Tokens that return no value (and instead revert or
930  * throw on failure) are also supported, non-reverting calls are assumed to be
931  * successful.
932  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
933  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
934  */
935 library SafeERC20 {
936     using Address for address;
937 
938     function safeTransfer(
939         IERC20 token,
940         address to,
941         uint256 value
942     ) internal {
943         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
944     }
945 
946     function safeTransferFrom(
947         IERC20 token,
948         address from,
949         address to,
950         uint256 value
951     ) internal {
952         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
953     }
954 
955     /**
956      * @dev Deprecated. This function has issues similar to the ones found in
957      * {IERC20-approve}, and its usage is discouraged.
958      *
959      * Whenever possible, use {safeIncreaseAllowance} and
960      * {safeDecreaseAllowance} instead.
961      */
962     function safeApprove(
963         IERC20 token,
964         address spender,
965         uint256 value
966     ) internal {
967         // safeApprove should only be called when setting an initial allowance,
968         // or when resetting it to zero. To increase and decrease it, use
969         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
970         require(
971             (value == 0) || (token.allowance(address(this), spender) == 0),
972             "SafeERC20: approve from non-zero to non-zero allowance"
973         );
974         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
975     }
976 
977     function safeIncreaseAllowance(
978         IERC20 token,
979         address spender,
980         uint256 value
981     ) internal {
982         uint256 newAllowance = token.allowance(address(this), spender) + value;
983         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
984     }
985 
986     function safeDecreaseAllowance(
987         IERC20 token,
988         address spender,
989         uint256 value
990     ) internal {
991         unchecked {
992             uint256 oldAllowance = token.allowance(address(this), spender);
993             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
994             uint256 newAllowance = oldAllowance - value;
995             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
996         }
997     }
998 
999     /**
1000      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1001      * on the return value: the return value is optional (but if data is returned, it must not be false).
1002      * @param token The token targeted by the call.
1003      * @param data The call data (encoded using abi.encode or one of its variants).
1004      */
1005     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1006         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1007         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1008         // the target address contains contract code and also asserts for success in the low-level call.
1009 
1010         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1011         if (returndata.length > 0) {
1012             // Return data is optional
1013             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1014         }
1015     }
1016 }
1017 
1018 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ERC1155Receiver
1019 
1020 /**
1021  * @dev _Available since v3.1._
1022  */
1023 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
1024     /**
1025      * @dev See {IERC165-supportsInterface}.
1026      */
1027     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1028         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
1029     }
1030 }
1031 
1032 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ERC20
1033 
1034 /**
1035  * @dev Implementation of the {IERC20} interface.
1036  *
1037  * This implementation is agnostic to the way tokens are created. This means
1038  * that a supply mechanism has to be added in a derived contract using {_mint}.
1039  * For a generic mechanism see {ERC20PresetMinterPauser}.
1040  *
1041  * TIP: For a detailed writeup see our guide
1042  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1043  * to implement supply mechanisms].
1044  *
1045  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1046  * instead returning `false` on failure. This behavior is nonetheless
1047  * conventional and does not conflict with the expectations of ERC20
1048  * applications.
1049  *
1050  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1051  * This allows applications to reconstruct the allowance for all accounts just
1052  * by listening to said events. Other implementations of the EIP may not emit
1053  * these events, as it isn't required by the specification.
1054  *
1055  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1056  * functions have been added to mitigate the well-known issues around setting
1057  * allowances. See {IERC20-approve}.
1058  */
1059 contract ERC20 is Context, IERC20, IERC20Metadata {
1060     mapping(address => uint256) private _balances;
1061 
1062     mapping(address => mapping(address => uint256)) private _allowances;
1063 
1064     uint256 private _totalSupply;
1065 
1066     string private _name;
1067     string private _symbol;
1068 
1069     /**
1070      * @dev Sets the values for {name} and {symbol}.
1071      *
1072      * The default value of {decimals} is 18. To select a different value for
1073      * {decimals} you should overload it.
1074      *
1075      * All two of these values are immutable: they can only be set once during
1076      * construction.
1077      */
1078     constructor(string memory name_, string memory symbol_) {
1079         _name = name_;
1080         _symbol = symbol_;
1081     }
1082 
1083     /**
1084      * @dev Returns the name of the token.
1085      */
1086     function name() public view virtual override returns (string memory) {
1087         return _name;
1088     }
1089 
1090     /**
1091      * @dev Returns the symbol of the token, usually a shorter version of the
1092      * name.
1093      */
1094     function symbol() public view virtual override returns (string memory) {
1095         return _symbol;
1096     }
1097 
1098     /**
1099      * @dev Returns the number of decimals used to get its user representation.
1100      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1101      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1102      *
1103      * Tokens usually opt for a value of 18, imitating the relationship between
1104      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1105      * overridden;
1106      *
1107      * NOTE: This information is only used for _display_ purposes: it in
1108      * no way affects any of the arithmetic of the contract, including
1109      * {IERC20-balanceOf} and {IERC20-transfer}.
1110      */
1111     function decimals() public view virtual override returns (uint8) {
1112         return 18;
1113     }
1114 
1115     /**
1116      * @dev See {IERC20-totalSupply}.
1117      */
1118     function totalSupply() public view virtual override returns (uint256) {
1119         return _totalSupply;
1120     }
1121 
1122     /**
1123      * @dev See {IERC20-balanceOf}.
1124      */
1125     function balanceOf(address account) public view virtual override returns (uint256) {
1126         return _balances[account];
1127     }
1128 
1129     /**
1130      * @dev See {IERC20-transfer}.
1131      *
1132      * Requirements:
1133      *
1134      * - `recipient` cannot be the zero address.
1135      * - the caller must have a balance of at least `amount`.
1136      */
1137     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1138         _transfer(_msgSender(), recipient, amount);
1139         return true;
1140     }
1141 
1142     /**
1143      * @dev See {IERC20-allowance}.
1144      */
1145     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1146         return _allowances[owner][spender];
1147     }
1148 
1149     /**
1150      * @dev See {IERC20-approve}.
1151      *
1152      * Requirements:
1153      *
1154      * - `spender` cannot be the zero address.
1155      */
1156     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1157         _approve(_msgSender(), spender, amount);
1158         return true;
1159     }
1160 
1161     /**
1162      * @dev See {IERC20-transferFrom}.
1163      *
1164      * Emits an {Approval} event indicating the updated allowance. This is not
1165      * required by the EIP. See the note at the beginning of {ERC20}.
1166      *
1167      * Requirements:
1168      *
1169      * - `sender` and `recipient` cannot be the zero address.
1170      * - `sender` must have a balance of at least `amount`.
1171      * - the caller must have allowance for ``sender``'s tokens of at least
1172      * `amount`.
1173      */
1174     function transferFrom(
1175         address sender,
1176         address recipient,
1177         uint256 amount
1178     ) public virtual override returns (bool) {
1179         _transfer(sender, recipient, amount);
1180 
1181         uint256 currentAllowance = _allowances[sender][_msgSender()];
1182         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1183         unchecked {
1184             _approve(sender, _msgSender(), currentAllowance - amount);
1185         }
1186 
1187         return true;
1188     }
1189 
1190     /**
1191      * @dev Atomically increases the allowance granted to `spender` by the caller.
1192      *
1193      * This is an alternative to {approve} that can be used as a mitigation for
1194      * problems described in {IERC20-approve}.
1195      *
1196      * Emits an {Approval} event indicating the updated allowance.
1197      *
1198      * Requirements:
1199      *
1200      * - `spender` cannot be the zero address.
1201      */
1202     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1203         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1204         return true;
1205     }
1206 
1207     /**
1208      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1209      *
1210      * This is an alternative to {approve} that can be used as a mitigation for
1211      * problems described in {IERC20-approve}.
1212      *
1213      * Emits an {Approval} event indicating the updated allowance.
1214      *
1215      * Requirements:
1216      *
1217      * - `spender` cannot be the zero address.
1218      * - `spender` must have allowance for the caller of at least
1219      * `subtractedValue`.
1220      */
1221     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1222         uint256 currentAllowance = _allowances[_msgSender()][spender];
1223         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1224         unchecked {
1225             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1226         }
1227 
1228         return true;
1229     }
1230 
1231     /**
1232      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1233      *
1234      * This internal function is equivalent to {transfer}, and can be used to
1235      * e.g. implement automatic token fees, slashing mechanisms, etc.
1236      *
1237      * Emits a {Transfer} event.
1238      *
1239      * Requirements:
1240      *
1241      * - `sender` cannot be the zero address.
1242      * - `recipient` cannot be the zero address.
1243      * - `sender` must have a balance of at least `amount`.
1244      */
1245     function _transfer(
1246         address sender,
1247         address recipient,
1248         uint256 amount
1249     ) internal virtual {
1250         require(sender != address(0), "ERC20: transfer from the zero address");
1251         require(recipient != address(0), "ERC20: transfer to the zero address");
1252 
1253         _beforeTokenTransfer(sender, recipient, amount);
1254 
1255         uint256 senderBalance = _balances[sender];
1256         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1257         unchecked {
1258             _balances[sender] = senderBalance - amount;
1259         }
1260         _balances[recipient] += amount;
1261 
1262         emit Transfer(sender, recipient, amount);
1263 
1264         _afterTokenTransfer(sender, recipient, amount);
1265     }
1266 
1267     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1268      * the total supply.
1269      *
1270      * Emits a {Transfer} event with `from` set to the zero address.
1271      *
1272      * Requirements:
1273      *
1274      * - `account` cannot be the zero address.
1275      */
1276     function _mint(address account, uint256 amount) internal virtual {
1277         require(account != address(0), "ERC20: mint to the zero address");
1278 
1279         _beforeTokenTransfer(address(0), account, amount);
1280 
1281         _totalSupply += amount;
1282         _balances[account] += amount;
1283         emit Transfer(address(0), account, amount);
1284 
1285         _afterTokenTransfer(address(0), account, amount);
1286     }
1287 
1288     /**
1289      * @dev Destroys `amount` tokens from `account`, reducing the
1290      * total supply.
1291      *
1292      * Emits a {Transfer} event with `to` set to the zero address.
1293      *
1294      * Requirements:
1295      *
1296      * - `account` cannot be the zero address.
1297      * - `account` must have at least `amount` tokens.
1298      */
1299     function _burn(address account, uint256 amount) internal virtual {
1300         require(account != address(0), "ERC20: burn from the zero address");
1301 
1302         _beforeTokenTransfer(account, address(0), amount);
1303 
1304         uint256 accountBalance = _balances[account];
1305         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1306         unchecked {
1307             _balances[account] = accountBalance - amount;
1308         }
1309         _totalSupply -= amount;
1310 
1311         emit Transfer(account, address(0), amount);
1312 
1313         _afterTokenTransfer(account, address(0), amount);
1314     }
1315 
1316     /**
1317      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1318      *
1319      * This internal function is equivalent to `approve`, and can be used to
1320      * e.g. set automatic allowances for certain subsystems, etc.
1321      *
1322      * Emits an {Approval} event.
1323      *
1324      * Requirements:
1325      *
1326      * - `owner` cannot be the zero address.
1327      * - `spender` cannot be the zero address.
1328      */
1329     function _approve(
1330         address owner,
1331         address spender,
1332         uint256 amount
1333     ) internal virtual {
1334         require(owner != address(0), "ERC20: approve from the zero address");
1335         require(spender != address(0), "ERC20: approve to the zero address");
1336 
1337         _allowances[owner][spender] = amount;
1338         emit Approval(owner, spender, amount);
1339     }
1340 
1341     /**
1342      * @dev Hook that is called before any transfer of tokens. This includes
1343      * minting and burning.
1344      *
1345      * Calling conditions:
1346      *
1347      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1348      * will be transferred to `to`.
1349      * - when `from` is zero, `amount` tokens will be minted for `to`.
1350      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1351      * - `from` and `to` are never both zero.
1352      *
1353      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1354      */
1355     function _beforeTokenTransfer(
1356         address from,
1357         address to,
1358         uint256 amount
1359     ) internal virtual {}
1360 
1361     /**
1362      * @dev Hook that is called after any transfer of tokens. This includes
1363      * minting and burning.
1364      *
1365      * Calling conditions:
1366      *
1367      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1368      * has been transferred to `to`.
1369      * - when `from` is zero, `amount` tokens have been minted for `to`.
1370      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1371      * - `from` and `to` are never both zero.
1372      *
1373      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1374      */
1375     function _afterTokenTransfer(
1376         address from,
1377         address to,
1378         uint256 amount
1379     ) internal virtual {}
1380 }
1381 
1382 // Part: OpenZeppelin/openzeppelin-contracts@4.3.0/ERC1155Holder
1383 
1384 /**
1385  * @dev _Available since v3.1._
1386  */
1387 contract ERC1155Holder is ERC1155Receiver {
1388     function onERC1155Received(
1389         address,
1390         address,
1391         uint256,
1392         uint256,
1393         bytes memory
1394     ) public virtual override returns (bytes4) {
1395         return this.onERC1155Received.selector;
1396     }
1397 
1398     function onERC1155BatchReceived(
1399         address,
1400         address,
1401         uint256[] memory,
1402         uint256[] memory,
1403         bytes memory
1404     ) public virtual override returns (bytes4) {
1405         return this.onERC1155BatchReceived.selector;
1406     }
1407 }
1408 
1409 // File: Registry.sol
1410 
1411 //              @@@@@@@@@@@@@@@@        ,@@@@@@@@@@@@@@@@
1412 //              @@@,,,,,,,,,,@@@        ,@@&,,,,,,,,,,@@@
1413 //         @@@@@@@@,,,,,,,,,,@@@@@@@@&  ,@@&,,,,,,,,,,@@@@@@@@
1414 //         @@@**********@@@@@@@@@@@@@&  ,@@@@@@@@**********@@@
1415 //         @@@**********@@@@@@@@@@@@@&  ,@@@@@@@@**********@@@@@@@@
1416 //         @@@**********@@@@@@@@@@@@@&       .@@@**********@@@@@@@@
1417 //    @@@@@@@@**********@@@@@@@@@@@@@&       .@@@**********@@@@@@@@
1418 //    @@@**********@@@@@@@@@@@@@&            .@@@@@@@@**********@@@
1419 //    @@@**********@@@@@@@@@@@@@&            .@@@@@@@@**********@@@@@@@@
1420 //    @@@@@@@@**********@@@@@@@@&            .@@@**********@@@@@@@@@@@@@
1421 //    @@@@@@@@//////////@@@@@@@@&            .@@@//////////@@@@@@@@@@@@@
1422 //         @@@//////////@@@@@@@@&            .@@@//////////@@@@@@@@@@@@@
1423 //         @@@//////////@@@@@@@@&       ,@@@@@@@@//////////@@@@@@@@@@@@@
1424 //         @@@%%%%%/////(((((@@@&       ,@@@(((((/////%%%%%@@@@@@@@
1425 //         @@@@@@@@//////////@@@@@@@@&  ,@@@//////////@@@@@@@@@@@@@
1426 //              @@@%%%%%%%%%%@@@@@@@@&  ,@@@%%%%%%%%%%@@@@@@@@@@@@@
1427 //              @@@@@@@@@@@@@@@@@@@@@&  ,@@@@@@@@@@@@@@@@@@@@@@@@@@
1428 //                   @@@@@@@@@@@@@@@@&        @@@@@@@@@@@@@@@@
1429 //                   @@@@@@@@@@@@@@@@&        @@@@@@@@@@@@@@@@
1430 
1431 contract Registry is IRegistry, ERC721Holder, ERC1155Receiver, ERC1155Holder {
1432     using SafeERC20 for ERC20;
1433 
1434     IResolver private resolver;
1435     address private admin;
1436     address payable private beneficiary;
1437     uint256 private lendingID = 1;
1438     uint256 private rentingID = 1;
1439     bool public paused = false;
1440     uint256 public rentFee = 0;
1441     uint256 private constant SECONDS_IN_DAY = 86400;
1442     mapping(bytes32 => Lending) private lendings;
1443     mapping(bytes32 => Renting) private rentings;
1444 
1445     modifier onlyAdmin() {
1446         require(msg.sender == admin, "ReNFT::not admin");
1447         _;
1448     }
1449 
1450     modifier notPaused() {
1451         require(!paused, "ReNFT::paused");
1452         _;
1453     }
1454 
1455     constructor(
1456         address newResolver,
1457         address payable newBeneficiary,
1458         address newAdmin
1459     ) {
1460         ensureIsNotZeroAddr(newResolver);
1461         ensureIsNotZeroAddr(newBeneficiary);
1462         ensureIsNotZeroAddr(newAdmin);
1463         resolver = IResolver(newResolver);
1464         beneficiary = newBeneficiary;
1465         admin = newAdmin;
1466     }
1467 
1468     function lend(
1469         IRegistry.NFTStandard[] memory nftStandard,
1470         address[] memory nftAddress,
1471         uint256[] memory tokenID,
1472         uint256[] memory lendAmount,
1473         uint8[] memory maxRentDuration,
1474         bytes4[] memory dailyRentPrice,
1475         IResolver.PaymentToken[] memory paymentToken
1476     ) external override notPaused {
1477         bundleCall(
1478             handleLend,
1479             createLendCallData(
1480                 nftStandard,
1481                 nftAddress,
1482                 tokenID,
1483                 lendAmount,
1484                 maxRentDuration,
1485                 dailyRentPrice,
1486                 paymentToken
1487             )
1488         );
1489     }
1490 
1491     function stopLend(
1492         IRegistry.NFTStandard[] memory nftStandard,
1493         address[] memory nftAddress,
1494         uint256[] memory tokenID,
1495         uint256[] memory _lendingID
1496     ) external override notPaused {
1497         bundleCall(
1498             handleStopLend,
1499             createActionCallData(
1500                 nftStandard,
1501                 nftAddress,
1502                 tokenID,
1503                 _lendingID,
1504                 new uint256[](0)
1505             )
1506         );
1507     }
1508 
1509     function rent(
1510         IRegistry.NFTStandard[] memory nftStandard,
1511         address[] memory nftAddress,
1512         uint256[] memory tokenID,
1513         uint256[] memory _lendingID,
1514         uint8[] memory rentDuration,
1515         uint256[] memory rentAmount
1516     ) external payable override notPaused {
1517         bundleCall(
1518             handleRent,
1519             createRentCallData(
1520                 nftStandard,
1521                 nftAddress,
1522                 tokenID,
1523                 _lendingID,
1524                 rentDuration,
1525                 rentAmount
1526             )
1527         );
1528     }
1529 
1530     function stopRent(
1531         IRegistry.NFTStandard[] memory nftStandard,
1532         address[] memory nftAddress,
1533         uint256[] memory tokenID,
1534         uint256[] memory _lendingID,
1535         uint256[] memory _rentingID
1536     ) external override notPaused {
1537         bundleCall(
1538             handleStopRent,
1539             createActionCallData(
1540                 nftStandard,
1541                 nftAddress,
1542                 tokenID,
1543                 _lendingID,
1544                 _rentingID
1545             )
1546         );
1547     }
1548 
1549     function claimRent(
1550         IRegistry.NFTStandard[] memory nftStandard,
1551         address[] memory nftAddress,
1552         uint256[] memory tokenID,
1553         uint256[] memory _lendingID,
1554         uint256[] memory _rentingID
1555     ) external override notPaused {
1556         bundleCall(
1557             handleClaimRent,
1558             createActionCallData(
1559                 nftStandard,
1560                 nftAddress,
1561                 tokenID,
1562                 _lendingID,
1563                 _rentingID
1564             )
1565         );
1566     }
1567 
1568     //      .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.
1569     // `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'
1570 
1571     function handleLend(IRegistry.CallData memory cd) private {
1572         for (uint256 i = cd.left; i < cd.right; i++) {
1573             ensureIsLendable(cd, i);
1574             bytes32 identifier = keccak256(
1575                 abi.encodePacked(
1576                     cd.nftAddress[cd.left],
1577                     cd.tokenID[i],
1578                     lendingID
1579                 )
1580             );
1581             IRegistry.Lending storage lending = lendings[identifier];
1582             ensureIsNull(lending);
1583             ensureTokenNotSentinel(uint8(cd.paymentToken[i]));
1584             bool is721 = cd.nftStandard[i] == IRegistry.NFTStandard.E721;
1585             lendings[identifier] = IRegistry.Lending({
1586                 nftStandard: cd.nftStandard[i],
1587                 lenderAddress: payable(msg.sender),
1588                 maxRentDuration: cd.maxRentDuration[i],
1589                 dailyRentPrice: cd.dailyRentPrice[i],
1590                 lendAmount: is721 ? 1 : uint16(cd.lendAmount[i]),
1591                 availableAmount: is721 ? 1 : uint16(cd.lendAmount[i]),
1592                 paymentToken: cd.paymentToken[i]
1593             });
1594             emit IRegistry.Lend(
1595                 is721,
1596                 msg.sender,
1597                 cd.nftAddress[cd.left],
1598                 cd.tokenID[i],
1599                 lendingID,
1600                 cd.maxRentDuration[i],
1601                 cd.dailyRentPrice[i],
1602                 is721 ? 1 : uint16(cd.lendAmount[i]),
1603                 cd.paymentToken[i]
1604             );
1605             lendingID++;
1606         }
1607         safeTransfer(
1608             cd,
1609             msg.sender,
1610             address(this),
1611             sliceArr(cd.tokenID, cd.left, cd.right, 0),
1612             sliceArr(cd.lendAmount, cd.left, cd.right, 0)
1613         );
1614     }
1615 
1616     function handleStopLend(IRegistry.CallData memory cd) private {
1617         uint256[] memory lentAmounts = new uint256[](cd.right - cd.left);
1618         for (uint256 i = cd.left; i < cd.right; i++) {
1619             bytes32 lendingIdentifier = keccak256(
1620                 abi.encodePacked(
1621                     cd.nftAddress[cd.left],
1622                     cd.tokenID[i],
1623                     cd.lendingID[i]
1624                 )
1625             );
1626             Lending storage lending = lendings[lendingIdentifier];
1627             ensureIsNotNull(lending);
1628             ensureIsStoppable(lending, msg.sender);
1629             require(
1630                 cd.nftStandard[i] == lending.nftStandard,
1631                 "ReNFT::invalid nft standard"
1632             );
1633             require(
1634                 lending.lendAmount == lending.availableAmount,
1635                 "ReNFT::actively rented"
1636             );
1637             lentAmounts[i - cd.left] = lending.lendAmount;
1638             emit IRegistry.StopLend(cd.lendingID[i], uint32(block.timestamp));
1639             delete lendings[lendingIdentifier];
1640         }
1641         safeTransfer(
1642             cd,
1643             address(this),
1644             msg.sender,
1645             sliceArr(cd.tokenID, cd.left, cd.right, 0),
1646             sliceArr(lentAmounts, cd.left, cd.right, cd.left)
1647         );
1648     }
1649 
1650     function handleRent(IRegistry.CallData memory cd) private {
1651         for (uint256 i = cd.left; i < cd.right; i++) {
1652             bytes32 lendingIdentifier = keccak256(
1653                 abi.encodePacked(
1654                     cd.nftAddress[cd.left],
1655                     cd.tokenID[i],
1656                     cd.lendingID[i]
1657                 )
1658             );
1659             bytes32 rentingIdentifier = keccak256(
1660                 abi.encodePacked(
1661                     cd.nftAddress[cd.left],
1662                     cd.tokenID[i],
1663                     rentingID
1664                 )
1665             );
1666             IRegistry.Lending storage lending = lendings[lendingIdentifier];
1667             IRegistry.Renting storage renting = rentings[rentingIdentifier];
1668             ensureIsNotNull(lending);
1669             ensureIsNull(renting);
1670             ensureIsRentable(lending, cd, i, msg.sender);
1671             require(
1672                 cd.nftStandard[i] == lending.nftStandard,
1673                 "ReNFT::invalid nft standard"
1674             );
1675             require(
1676                 cd.rentAmount[i] <= lending.availableAmount,
1677                 "ReNFT::invalid rent amount"
1678             );
1679             uint8 paymentTokenIx = uint8(lending.paymentToken);
1680             address paymentToken = resolver.getPaymentToken(paymentTokenIx);
1681             uint256 decimals = ERC20(paymentToken).decimals();
1682             {
1683                 uint256 scale = 10**decimals;
1684                 uint256 rentPrice = cd.rentAmount[i] *
1685                     cd.rentDuration[i] *
1686                     unpackPrice(lending.dailyRentPrice, scale);
1687                 require(rentPrice > 0, "ReNFT::rent price is zero");
1688                 ERC20(paymentToken).safeTransferFrom(
1689                     msg.sender,
1690                     address(this),
1691                     rentPrice
1692                 );
1693             }
1694             rentings[rentingIdentifier] = IRegistry.Renting({
1695                 renterAddress: payable(msg.sender),
1696                 rentAmount: uint16(cd.rentAmount[i]),
1697                 rentDuration: cd.rentDuration[i],
1698                 rentedAt: uint32(block.timestamp)
1699             });
1700             lendings[lendingIdentifier].availableAmount -= uint16(
1701                 cd.rentAmount[i]
1702             );
1703             emit IRegistry.Rent(
1704                 msg.sender,
1705                 cd.lendingID[i],
1706                 rentingID,
1707                 uint16(cd.rentAmount[i]),
1708                 cd.rentDuration[i],
1709                 renting.rentedAt
1710             );
1711             rentingID++;
1712         }
1713     }
1714 
1715     function handleStopRent(IRegistry.CallData memory cd) private {
1716         for (uint256 i = cd.left; i < cd.right; i++) {
1717             bytes32 lendingIdentifier = keccak256(
1718                 abi.encodePacked(
1719                     cd.nftAddress[cd.left],
1720                     cd.tokenID[i],
1721                     cd.lendingID[i]
1722                 )
1723             );
1724             bytes32 rentingIdentifier = keccak256(
1725                 abi.encodePacked(
1726                     cd.nftAddress[cd.left],
1727                     cd.tokenID[i],
1728                     cd.rentingID[i]
1729                 )
1730             );
1731             IRegistry.Lending storage lending = lendings[lendingIdentifier];
1732             IRegistry.Renting storage renting = rentings[rentingIdentifier];
1733             ensureIsNotNull(lending);
1734             ensureIsNotNull(renting);
1735             ensureIsReturnable(renting, msg.sender, block.timestamp);
1736             require(
1737                 cd.nftStandard[i] == lending.nftStandard,
1738                 "ReNFT::invalid nft standard"
1739             );
1740             require(
1741                 renting.rentAmount <= lending.lendAmount,
1742                 "ReNFT::critical error"
1743             );
1744             uint256 secondsSinceRentStart = block.timestamp - renting.rentedAt;
1745             distributePayments(lending, renting, secondsSinceRentStart);
1746             lendings[lendingIdentifier].availableAmount += renting.rentAmount;
1747             emit IRegistry.StopRent(cd.rentingID[i], uint32(block.timestamp));
1748             delete rentings[rentingIdentifier];
1749         }
1750     }
1751 
1752     function handleClaimRent(CallData memory cd) private {
1753         for (uint256 i = cd.left; i < cd.right; i++) {
1754             bytes32 lendingIdentifier = keccak256(
1755                 abi.encodePacked(
1756                     cd.nftAddress[cd.left],
1757                     cd.tokenID[i],
1758                     cd.lendingID[i]
1759                 )
1760             );
1761             bytes32 rentingIdentifier = keccak256(
1762                 abi.encodePacked(
1763                     cd.nftAddress[cd.left],
1764                     cd.tokenID[i],
1765                     cd.rentingID[i]
1766                 )
1767             );
1768             IRegistry.Lending storage lending = lendings[lendingIdentifier];
1769             IRegistry.Renting storage renting = rentings[rentingIdentifier];
1770             ensureIsNotNull(lending);
1771             ensureIsNotNull(renting);
1772             ensureIsClaimable(renting, block.timestamp);
1773             distributeClaimPayment(lending, renting);
1774             lending.availableAmount += renting.rentAmount;
1775             emit IRegistry.RentClaimed(
1776                 cd.rentingID[i],
1777                 uint32(block.timestamp)
1778             );
1779             delete rentings[rentingIdentifier];
1780         }
1781     }
1782 
1783     //      .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.
1784     // `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'
1785 
1786     function bundleCall(
1787         function(IRegistry.CallData memory) handler,
1788         IRegistry.CallData memory cd
1789     ) private {
1790         require(cd.nftAddress.length > 0, "ReNFT::no nfts");
1791         while (cd.right != cd.nftAddress.length) {
1792             if (
1793                 (cd.nftAddress[cd.left] == cd.nftAddress[cd.right]) &&
1794                 (cd.nftStandard[cd.right] == IRegistry.NFTStandard.E1155)
1795             ) {
1796                 cd.right++;
1797             } else {
1798                 handler(cd);
1799                 cd.left = cd.right;
1800                 cd.right++;
1801             }
1802         }
1803         handler(cd);
1804     }
1805 
1806     function takeFee(uint256 rentAmt, IResolver.PaymentToken paymentToken)
1807         private
1808         returns (uint256 fee)
1809     {
1810         fee = rentAmt * rentFee;
1811         fee /= 10000;
1812         uint8 paymentTokenIx = uint8(paymentToken);
1813         ERC20 pmtToken = ERC20(resolver.getPaymentToken(paymentTokenIx));
1814         pmtToken.safeTransfer(beneficiary, fee);
1815     }
1816 
1817     function distributePayments(
1818         IRegistry.Lending memory lending,
1819         IRegistry.Renting memory renting,
1820         uint256 secondsSinceRentStart
1821     ) private {
1822         uint8 paymentTokenIx = uint8(lending.paymentToken);
1823         address pmtToken = resolver.getPaymentToken(paymentTokenIx);
1824         uint256 decimals = ERC20(pmtToken).decimals();
1825         uint256 scale = 10**decimals;
1826         uint256 rentPrice = renting.rentAmount *
1827             unpackPrice(lending.dailyRentPrice, scale);
1828         uint256 totalRenterPmt = rentPrice * renting.rentDuration;
1829         uint256 sendLenderAmt = (secondsSinceRentStart * rentPrice) /
1830             SECONDS_IN_DAY;
1831         require(totalRenterPmt > 0, "ReNFT::total renter payment is zero");
1832         require(sendLenderAmt > 0, "ReNFT::lender payment is zero");
1833         uint256 sendRenterAmt = totalRenterPmt - sendLenderAmt;
1834         if (rentFee != 0) {
1835             uint256 takenFee = takeFee(sendLenderAmt, lending.paymentToken);
1836             sendLenderAmt -= takenFee;
1837         }
1838         ERC20(pmtToken).safeTransfer(lending.lenderAddress, sendLenderAmt);
1839         if (sendRenterAmt > 0) {
1840             ERC20(pmtToken).safeTransfer(renting.renterAddress, sendRenterAmt);
1841         }
1842     }
1843 
1844     function distributeClaimPayment(
1845         IRegistry.Lending memory lending,
1846         IRegistry.Renting memory renting
1847     ) private {
1848         uint8 paymentTokenIx = uint8(lending.paymentToken);
1849         ERC20 paymentToken = ERC20(resolver.getPaymentToken(paymentTokenIx));
1850         uint256 decimals = ERC20(paymentToken).decimals();
1851         uint256 scale = 10**decimals;
1852         uint256 rentPrice = renting.rentAmount *
1853             unpackPrice(lending.dailyRentPrice, scale);
1854         uint256 finalAmt = rentPrice * renting.rentDuration;
1855         uint256 takenFee = 0;
1856         if (rentFee != 0) {
1857             takenFee = takeFee(
1858                 finalAmt,
1859                 IResolver.PaymentToken(paymentTokenIx)
1860             );
1861         }
1862         paymentToken.safeTransfer(lending.lenderAddress, finalAmt - takenFee);
1863     }
1864 
1865     function safeTransfer(
1866         CallData memory cd,
1867         address from,
1868         address to,
1869         uint256[] memory tokenID,
1870         uint256[] memory lendAmount
1871     ) private {
1872         if (cd.nftStandard[cd.left] == IRegistry.NFTStandard.E721) {
1873             IERC721(cd.nftAddress[cd.left]).transferFrom(
1874                 from,
1875                 to,
1876                 cd.tokenID[cd.left]
1877             );
1878         } else {
1879             IERC1155(cd.nftAddress[cd.left]).safeBatchTransferFrom(
1880                 from,
1881                 to,
1882                 tokenID,
1883                 lendAmount,
1884                 ""
1885             );
1886         }
1887     }
1888 
1889     //      .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.
1890     // `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'
1891 
1892     function getLending(
1893         address nftAddress,
1894         uint256 tokenID,
1895         uint256 _lendingID
1896     )
1897         external
1898         view
1899         returns (
1900             uint8,
1901             address,
1902             uint8,
1903             bytes4,
1904             uint16,
1905             uint16,
1906             uint8
1907         )
1908     {
1909         bytes32 identifier = keccak256(
1910             abi.encodePacked(nftAddress, tokenID, _lendingID)
1911         );
1912         IRegistry.Lending storage lending = lendings[identifier];
1913         return (
1914             uint8(lending.nftStandard),
1915             lending.lenderAddress,
1916             lending.maxRentDuration,
1917             lending.dailyRentPrice,
1918             lending.lendAmount,
1919             lending.availableAmount,
1920             uint8(lending.paymentToken)
1921         );
1922     }
1923 
1924     function getRenting(
1925         address nftAddress,
1926         uint256 tokenID,
1927         uint256 _rentingID
1928     )
1929         external
1930         view
1931         returns (
1932             address,
1933             uint16,
1934             uint8,
1935             uint32
1936         )
1937     {
1938         bytes32 identifier = keccak256(
1939             abi.encodePacked(nftAddress, tokenID, _rentingID)
1940         );
1941         IRegistry.Renting storage renting = rentings[identifier];
1942         return (
1943             renting.renterAddress,
1944             renting.rentAmount,
1945             renting.rentDuration,
1946             renting.rentedAt
1947         );
1948     }
1949 
1950     //      .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.
1951     // `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'
1952 
1953     function createLendCallData(
1954         IRegistry.NFTStandard[] memory nftStandard,
1955         address[] memory nftAddress,
1956         uint256[] memory tokenID,
1957         uint256[] memory lendAmount,
1958         uint8[] memory maxRentDuration,
1959         bytes4[] memory dailyRentPrice,
1960         IResolver.PaymentToken[] memory paymentToken
1961     ) private pure returns (CallData memory cd) {
1962         cd = CallData({
1963             left: 0,
1964             right: 1,
1965             nftStandard: nftStandard,
1966             nftAddress: nftAddress,
1967             tokenID: tokenID,
1968             lendAmount: lendAmount,
1969             lendingID: new uint256[](0),
1970             rentingID: new uint256[](0),
1971             rentDuration: new uint8[](0),
1972             rentAmount: new uint256[](0),
1973             maxRentDuration: maxRentDuration,
1974             dailyRentPrice: dailyRentPrice,
1975             paymentToken: paymentToken
1976         });
1977     }
1978 
1979     function createRentCallData(
1980         IRegistry.NFTStandard[] memory nftStandard,
1981         address[] memory nftAddress,
1982         uint256[] memory tokenID,
1983         uint256[] memory _lendingID,
1984         uint8[] memory rentDuration,
1985         uint256[] memory rentAmount
1986     ) private pure returns (CallData memory cd) {
1987         cd = CallData({
1988             left: 0,
1989             right: 1,
1990             nftStandard: nftStandard,
1991             nftAddress: nftAddress,
1992             tokenID: tokenID,
1993             lendAmount: new uint256[](0),
1994             lendingID: _lendingID,
1995             rentingID: new uint256[](0),
1996             rentDuration: rentDuration,
1997             rentAmount: rentAmount,
1998             maxRentDuration: new uint8[](0),
1999             dailyRentPrice: new bytes4[](0),
2000             paymentToken: new IResolver.PaymentToken[](0)
2001         });
2002     }
2003 
2004     function createActionCallData(
2005         IRegistry.NFTStandard[] memory nftStandard,
2006         address[] memory nftAddress,
2007         uint256[] memory tokenID,
2008         uint256[] memory _lendingID,
2009         uint256[] memory _rentingID
2010     ) private pure returns (CallData memory cd) {
2011         cd = CallData({
2012             left: 0,
2013             right: 1,
2014             nftStandard: nftStandard,
2015             nftAddress: nftAddress,
2016             tokenID: tokenID,
2017             lendAmount: new uint256[](0),
2018             lendingID: _lendingID,
2019             rentingID: _rentingID,
2020             rentDuration: new uint8[](0),
2021             rentAmount: new uint256[](0),
2022             maxRentDuration: new uint8[](0),
2023             dailyRentPrice: new bytes4[](0),
2024             paymentToken: new IResolver.PaymentToken[](0)
2025         });
2026     }
2027 
2028     function unpackPrice(bytes4 price, uint256 scale)
2029         private
2030         pure
2031         returns (uint256)
2032     {
2033         ensureIsUnpackablePrice(price, scale);
2034         uint16 whole = uint16(bytes2(price));
2035         uint16 decimal = uint16(bytes2(price << 16));
2036         uint256 decimalScale = scale / 10000;
2037         if (whole > 9999) {
2038             whole = 9999;
2039         }
2040         if (decimal > 9999) {
2041             decimal = 9999;
2042         }
2043         uint256 w = whole * scale;
2044         uint256 d = decimal * decimalScale;
2045         uint256 fullPrice = w + d;
2046         return fullPrice;
2047     }
2048 
2049     function sliceArr(
2050         uint256[] memory arr,
2051         uint256 fromIx,
2052         uint256 toIx,
2053         uint256 arrOffset
2054     ) private pure returns (uint256[] memory r) {
2055         r = new uint256[](toIx - fromIx);
2056         for (uint256 i = fromIx; i < toIx; i++) {
2057             r[i - fromIx] = arr[i - arrOffset];
2058         }
2059     }
2060 
2061     //      .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.
2062     // `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'
2063 
2064     function ensureIsNotZeroAddr(address addr) private pure {
2065         require(addr != address(0), "ReNFT::zero address");
2066     }
2067 
2068     function ensureIsZeroAddr(address addr) private pure {
2069         require(addr == address(0), "ReNFT::not a zero address");
2070     }
2071 
2072     function ensureIsNull(Lending memory lending) private pure {
2073         ensureIsZeroAddr(lending.lenderAddress);
2074         require(lending.maxRentDuration == 0, "ReNFT::duration not zero");
2075         require(lending.dailyRentPrice == 0, "ReNFT::rent price not zero");
2076     }
2077 
2078     function ensureIsNotNull(Lending memory lending) private pure {
2079         ensureIsNotZeroAddr(lending.lenderAddress);
2080         require(lending.maxRentDuration != 0, "ReNFT::duration zero");
2081         require(lending.dailyRentPrice != 0, "ReNFT::rent price is zero");
2082     }
2083 
2084     function ensureIsNull(Renting memory renting) private pure {
2085         ensureIsZeroAddr(renting.renterAddress);
2086         require(renting.rentDuration == 0, "ReNFT::duration not zero");
2087         require(renting.rentedAt == 0, "ReNFT::rented at not zero");
2088     }
2089 
2090     function ensureIsNotNull(Renting memory renting) private pure {
2091         ensureIsNotZeroAddr(renting.renterAddress);
2092         require(renting.rentDuration != 0, "ReNFT::duration is zero");
2093         require(renting.rentedAt != 0, "ReNFT::rented at is zero");
2094     }
2095 
2096     function ensureIsLendable(CallData memory cd, uint256 i) private pure {
2097         require(cd.lendAmount[i] > 0, "ReNFT::lend amount is zero");
2098         require(cd.lendAmount[i] <= type(uint16).max, "ReNFT::not uint16");
2099         require(cd.maxRentDuration[i] > 0, "ReNFT::duration is zero");
2100         require(cd.maxRentDuration[i] <= type(uint8).max, "ReNFT::not uint8");
2101         require(uint32(cd.dailyRentPrice[i]) > 0, "ReNFT::rent price is zero");
2102     }
2103 
2104     function ensureIsRentable(
2105         Lending memory lending,
2106         CallData memory cd,
2107         uint256 i,
2108         address msgSender
2109     ) private pure {
2110         require(msgSender != lending.lenderAddress, "ReNFT::cant rent own nft");
2111         require(cd.rentDuration[i] <= type(uint8).max, "ReNFT::not uint8");
2112         require(cd.rentDuration[i] > 0, "ReNFT::duration is zero");
2113         require(cd.rentAmount[i] <= type(uint16).max, "ReNFT::not uint16");
2114         require(cd.rentAmount[i] > 0, "ReNFT::rentAmount is zero");
2115         require(
2116             cd.rentDuration[i] <= lending.maxRentDuration,
2117             "ReNFT::rent duration exceeds allowed max"
2118         );
2119     }
2120 
2121     function ensureIsReturnable(
2122         Renting memory renting,
2123         address msgSender,
2124         uint256 blockTimestamp
2125     ) private pure {
2126         require(renting.renterAddress == msgSender, "ReNFT::not renter");
2127         require(
2128             !isPastReturnDate(renting, blockTimestamp),
2129             "ReNFT::past return date"
2130         );
2131     }
2132 
2133     function ensureIsStoppable(Lending memory lending, address msgSender)
2134         private
2135         pure
2136     {
2137         require(lending.lenderAddress == msgSender, "ReNFT::not lender");
2138     }
2139 
2140     function ensureIsUnpackablePrice(bytes4 price, uint256 scale) private pure {
2141         require(uint32(price) > 0, "ReNFT::invalid price");
2142         require(scale >= 10000, "ReNFT::invalid scale");
2143     }
2144 
2145     function ensureTokenNotSentinel(uint8 paymentIx) private pure {
2146         require(paymentIx > 0, "ReNFT::token is sentinel");
2147     }
2148 
2149     function ensureIsClaimable(
2150         IRegistry.Renting memory renting,
2151         uint256 blockTimestamp
2152     ) private pure {
2153         require(
2154             isPastReturnDate(renting, blockTimestamp),
2155             "ReNFT::return date not passed"
2156         );
2157     }
2158 
2159     function isPastReturnDate(Renting memory renting, uint256 nowTime)
2160         private
2161         pure
2162         returns (bool)
2163     {
2164         require(nowTime > renting.rentedAt, "ReNFT::now before rented");
2165         return
2166             nowTime - renting.rentedAt > renting.rentDuration * SECONDS_IN_DAY;
2167     }
2168 
2169     //      .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.
2170     // `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'
2171 
2172     function setRentFee(uint256 newRentFee) external onlyAdmin {
2173         require(newRentFee < 10000, "ReNFT::fee exceeds 100pct");
2174         rentFee = newRentFee;
2175     }
2176 
2177     function setBeneficiary(address payable newBeneficiary) external onlyAdmin {
2178         beneficiary = newBeneficiary;
2179     }
2180 
2181     function setPaused(bool newPaused) external onlyAdmin {
2182         paused = newPaused;
2183     }
2184 }
