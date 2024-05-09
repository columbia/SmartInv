1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-22
3  */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 /**
31  * @dev Implementation of the {IERC165} interface.
32  *
33  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
34  * for the additional interface id that will be supported. For example:
35  *
36  * ```solidity
37  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
38  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
39  * }
40  * ```
41  *
42  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
43  */
44 abstract contract ERC165 is IERC165 {
45     /**
46      * @dev See {IERC165-supportsInterface}.
47      */
48     function supportsInterface(
49         bytes4 interfaceId
50     ) public view virtual override returns (bool) {
51         return interfaceId == type(IERC165).interfaceId;
52     }
53 }
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant alphabet = "0123456789abcdef";
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(
106         uint256 value,
107         uint256 length
108     ) internal pure returns (string memory) {
109         bytes memory buffer = new bytes(2 * length + 2);
110         buffer[0] = "0";
111         buffer[1] = "x";
112         for (uint256 i = 2 * length + 1; i > 1; --i) {
113             buffer[i] = alphabet[value & 0xf];
114             value >>= 4;
115         }
116         require(value == 0, "Strings: hex length insufficient");
117         return string(buffer);
118     }
119 }
120 
121 /*
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
138         return msg.data;
139     }
140 }
141 
142 /**
143  * @dev Collection of functions related to the address type
144  */
145 library Address {
146     /**
147      * @dev Returns true if `account` is a contract.
148      *
149      * [IMPORTANT]
150      * ====
151      * It is unsafe to assume that an address for which this function returns
152      * false is an externally-owned account (EOA) and not a contract.
153      *
154      * Among others, `isContract` will return false for the following
155      * types of addresses:
156      *
157      *  - an externally-owned account
158      *  - a contract in construction
159      *  - an address where a contract will be created
160      *  - an address where a contract lived, but was destroyed
161      * ====
162      */
163     function isContract(address account) internal view returns (bool) {
164         // This method relies on extcodesize, which returns 0 for contracts in
165         // construction, since the code is only stored at the end of the
166         // constructor execution.
167 
168         uint256 size;
169         // solhint-disable-next-line no-inline-assembly
170         assembly {
171             size := extcodesize(account)
172         }
173         return size > 0;
174     }
175 
176     /**
177      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
178      * `recipient`, forwarding all available gas and reverting on errors.
179      *
180      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
181      * of certain opcodes, possibly making contracts go over the 2300 gas limit
182      * imposed by `transfer`, making them unable to receive funds via
183      * `transfer`. {sendValue} removes this limitation.
184      *
185      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
186      *
187      * IMPORTANT: because control is transferred to `recipient`, care must be
188      * taken to not create reentrancy vulnerabilities. Consider using
189      * {ReentrancyGuard} or the
190      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
191      */
192     function sendValue(address payable recipient, uint256 amount) internal {
193         require(
194             address(this).balance >= amount,
195             "Address: insufficient balance"
196         );
197 
198         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
199         (bool success, ) = recipient.call{value: amount}("");
200         require(
201             success,
202             "Address: unable to send value, recipient may have reverted"
203         );
204     }
205 
206     /**
207      * @dev Performs a Solidity function call using a low level `call`. A
208      * plain`call` is an unsafe replacement for a function call: use this
209      * function instead.
210      *
211      * If `target` reverts with a revert reason, it is bubbled up by this
212      * function (like regular Solidity function calls).
213      *
214      * Returns the raw returned data. To convert to the expected return value,
215      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
216      *
217      * Requirements:
218      *
219      * - `target` must be a contract.
220      * - calling `target` with `data` must not revert.
221      *
222      * _Available since v3.1._
223      */
224     function functionCall(
225         address target,
226         bytes memory data
227     ) internal returns (bytes memory) {
228         return functionCall(target, data, "Address: low-level call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
233      * `errorMessage` as a fallback revert reason when `target` reverts.
234      *
235      * _Available since v3.1._
236      */
237     function functionCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal returns (bytes memory) {
242         return functionCallWithValue(target, data, 0, errorMessage);
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
247      * but also transferring `value` wei to `target`.
248      *
249      * Requirements:
250      *
251      * - the calling contract must have an ETH balance of at least `value`.
252      * - the called Solidity function must be `payable`.
253      *
254      * _Available since v3.1._
255      */
256     function functionCallWithValue(
257         address target,
258         bytes memory data,
259         uint256 value
260     ) internal returns (bytes memory) {
261         return
262             functionCallWithValue(
263                 target,
264                 data,
265                 value,
266                 "Address: low-level call with value failed"
267             );
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
272      * with `errorMessage` as a fallback revert reason when `target` reverts.
273      *
274      * _Available since v3.1._
275      */
276     function functionCallWithValue(
277         address target,
278         bytes memory data,
279         uint256 value,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         require(
283             address(this).balance >= value,
284             "Address: insufficient balance for call"
285         );
286         require(isContract(target), "Address: call to non-contract");
287 
288         // solhint-disable-next-line avoid-low-level-calls
289         (bool success, bytes memory returndata) = target.call{value: value}(
290             data
291         );
292         return _verifyCallResult(success, returndata, errorMessage);
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
297      * but performing a static call.
298      *
299      * _Available since v3.3._
300      */
301     function functionStaticCall(
302         address target,
303         bytes memory data
304     ) internal view returns (bytes memory) {
305         return
306             functionStaticCall(
307                 target,
308                 data,
309                 "Address: low-level static call failed"
310             );
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
315      * but performing a static call.
316      *
317      * _Available since v3.3._
318      */
319     function functionStaticCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal view returns (bytes memory) {
324         require(isContract(target), "Address: static call to non-contract");
325 
326         // solhint-disable-next-line avoid-low-level-calls
327         (bool success, bytes memory returndata) = target.staticcall(data);
328         return _verifyCallResult(success, returndata, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but performing a delegate call.
334      *
335      * _Available since v3.4._
336      */
337     function functionDelegateCall(
338         address target,
339         bytes memory data
340     ) internal returns (bytes memory) {
341         return
342             functionDelegateCall(
343                 target,
344                 data,
345                 "Address: low-level delegate call failed"
346             );
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a delegate call.
352      *
353      * _Available since v3.4._
354      */
355     function functionDelegateCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         require(isContract(target), "Address: delegate call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.delegatecall(data);
364         return _verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     function _verifyCallResult(
368         bool success,
369         bytes memory returndata,
370         string memory errorMessage
371     ) private pure returns (bytes memory) {
372         if (success) {
373             return returndata;
374         } else {
375             // Look for revert reason and bubble it up if present
376             if (returndata.length > 0) {
377                 // The easiest way to bubble the revert reason is using memory via assembly
378 
379                 // solhint-disable-next-line no-inline-assembly
380                 assembly {
381                     let returndata_size := mload(returndata)
382                     revert(add(32, returndata), returndata_size)
383                 }
384             } else {
385                 revert(errorMessage);
386             }
387         }
388     }
389 }
390 
391 interface IERC2981 is IERC165 {
392     /**
393      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
394      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
395      */
396     function royaltyInfo(
397         uint256 tokenId,
398         uint256 salePrice
399     ) external view returns (address receiver, uint256 royaltyAmount);
400 }
401 
402 /**
403  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
404  *
405  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
406  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
407  *
408  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
409  * fee is specified in basis points by default.
410  *
411  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
412  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
413  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
414  *
415  * _Available since v4.5._
416  */
417 abstract contract ERC2981 is IERC2981, ERC165 {
418     struct RoyaltyInfo {
419         address receiver;
420         uint96 royaltyFraction;
421     }
422 
423     RoyaltyInfo private _defaultRoyaltyInfo;
424     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
425 
426     /**
427      * @dev See {IERC165-supportsInterface}.
428      */
429     function supportsInterface(
430         bytes4 interfaceId
431     ) public view virtual override(IERC165, ERC165) returns (bool) {
432         return
433             interfaceId == type(IERC2981).interfaceId ||
434             super.supportsInterface(interfaceId);
435     }
436 
437     /**
438      * @inheritdoc IERC2981
439      */
440     function royaltyInfo(
441         uint256 _tokenId,
442         uint256 _salePrice
443     ) public view virtual override returns (address, uint256) {
444         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
445 
446         if (royalty.receiver == address(0)) {
447             royalty = _defaultRoyaltyInfo;
448         }
449 
450         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) /
451             _feeDenominator();
452 
453         return (royalty.receiver, royaltyAmount);
454     }
455 
456     /**
457      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
458      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
459      * override.
460      */
461     function _feeDenominator() internal pure virtual returns (uint96) {
462         return 10000;
463     }
464 
465     /**
466      * @dev Sets the royalty information that all ids in this contract will default to.
467      *
468      * Requirements:
469      *
470      * - `receiver` cannot be the zero address.
471      * - `feeNumerator` cannot be greater than the fee denominator.
472      */
473     function _setDefaultRoyalty(
474         address receiver,
475         uint96 feeNumerator
476     ) internal virtual {
477         require(
478             feeNumerator <= _feeDenominator(),
479             "ERC2981: royalty fee will exceed salePrice"
480         );
481         require(receiver != address(0), "ERC2981: invalid receiver");
482 
483         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
484     }
485 
486     /**
487      * @dev Removes default royalty information.
488      */
489     function _deleteDefaultRoyalty() internal virtual {
490         delete _defaultRoyaltyInfo;
491     }
492 
493     /**
494      * @dev Sets the royalty information for a specific token id, overriding the global default.
495      *
496      * Requirements:
497      *
498      * - `receiver` cannot be the zero address.
499      * - `feeNumerator` cannot be greater than the fee denominator.
500      */
501     function _setTokenRoyalty(
502         uint256 tokenId,
503         address receiver,
504         uint96 feeNumerator
505     ) internal virtual {
506         require(
507             feeNumerator <= _feeDenominator(),
508             "ERC2981: royalty fee will exceed salePrice"
509         );
510         require(receiver != address(0), "ERC2981: Invalid parameters");
511 
512         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
513     }
514 
515     /**
516      * @dev Resets royalty information for the token id back to the global default.
517      */
518     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
519         delete _tokenRoyaltyInfo[tokenId];
520     }
521 }
522 
523 /**
524  * @dev Required interface of an ERC721 compliant contract.
525  */
526 interface IERC721 is IERC165 {
527     /**
528      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
529      */
530     event Transfer(
531         address indexed from,
532         address indexed to,
533         uint256 indexed tokenId
534     );
535 
536     /**
537      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
538      */
539     event Approval(
540         address indexed owner,
541         address indexed approved,
542         uint256 indexed tokenId
543     );
544 
545     /**
546      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
547      */
548     event ApprovalForAll(
549         address indexed owner,
550         address indexed operator,
551         bool approved
552     );
553 
554     /**
555      * @dev Returns the number of tokens in ``owner``'s account.
556      */
557     function balanceOf(address owner) external view returns (uint256 balance);
558 
559     /**
560      * @dev Returns the owner of the `tokenId` token.
561      *
562      * Requirements:
563      *
564      * - `tokenId` must exist.
565      */
566     function ownerOf(uint256 tokenId) external view returns (address owner);
567 
568     /**
569      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
570      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
571      *
572      * Requirements:
573      *
574      * - `from` cannot be the zero address.
575      * - `to` cannot be the zero address.
576      * - `tokenId` token must exist and be owned by `from`.
577      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
578      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
579      *
580      * Emits a {Transfer} event.
581      */
582     function safeTransferFrom(
583         address from,
584         address to,
585         uint256 tokenId
586     ) external;
587 
588     /**
589      * @dev Transfers `tokenId` token from `from` to `to`.
590      *
591      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
592      *
593      * Requirements:
594      *
595      * - `from` cannot be the zero address.
596      * - `to` cannot be the zero address.
597      * - `tokenId` token must be owned by `from`.
598      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
599      *
600      * Emits a {Transfer} event.
601      */
602     function transferFrom(address from, address to, uint256 tokenId) external;
603 
604     /**
605      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
606      * The approval is cleared when the token is transferred.
607      *
608      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
609      *
610      * Requirements:
611      *
612      * - The caller must own the token or be an approved operator.
613      * - `tokenId` must exist.
614      *
615      * Emits an {Approval} event.
616      */
617     function approve(address to, uint256 tokenId) external;
618 
619     /**
620      * @dev Returns the account approved for `tokenId` token.
621      *
622      * Requirements:
623      *
624      * - `tokenId` must exist.
625      */
626     function getApproved(
627         uint256 tokenId
628     ) external view returns (address operator);
629 
630     /**
631      * @dev Approve or remove `operator` as an operator for the caller.
632      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
633      *
634      * Requirements:
635      *
636      * - The `operator` cannot be the caller.
637      *
638      * Emits an {ApprovalForAll} event.
639      */
640     function setApprovalForAll(address operator, bool _approved) external;
641 
642     /**
643      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
644      *
645      * See {setApprovalForAll}
646      */
647     function isApprovedForAll(
648         address owner,
649         address operator
650     ) external view returns (bool);
651 
652     /**
653      * @dev Safely transfers `tokenId` token from `from` to `to`.
654      *
655      * Requirements:
656      *
657      * - `from` cannot be the zero address.
658      * - `to` cannot be the zero address.
659      * - `tokenId` token must exist and be owned by `from`.
660      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
661      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
662      *
663      * Emits a {Transfer} event.
664      */
665     function safeTransferFrom(
666         address from,
667         address to,
668         uint256 tokenId,
669         bytes calldata data
670     ) external;
671 }
672 
673 /**
674  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
675  * @dev See https://eips.ethereum.org/EIPS/eip-721
676  */
677 interface IERC721Metadata is IERC721 {
678     /**
679      * @dev Returns the token collection name.
680      */
681     function name() external view returns (string memory);
682 
683     /**
684      * @dev Returns the token collection symbol.
685      */
686     function symbol() external view returns (string memory);
687 
688     /**
689      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
690      */
691     function tokenURI(uint256 tokenId) external view returns (string memory);
692 }
693 
694 /**
695  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
696  * @dev See https://eips.ethereum.org/EIPS/eip-721
697  */
698 interface IERC721Enumerable is IERC721 {
699     /**
700      * @dev Returns the total amount of tokens stored by the contract.
701      */
702     function totalSupply() external view returns (uint256);
703 
704     /**
705      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
706      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
707      */
708     function tokenOfOwnerByIndex(
709         address owner,
710         uint256 index
711     ) external view returns (uint256 tokenId);
712 
713     /**
714      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
715      * Use along with {totalSupply} to enumerate all tokens.
716      */
717     function tokenByIndex(uint256 index) external view returns (uint256);
718 }
719 
720 /**
721  * @title ERC721 token receiver interface
722  * @dev Interface for any contract that wants to support safeTransfers
723  * from ERC721 asset contracts.
724  */
725 interface IERC721Receiver {
726     /**
727      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
728      * by `operator` from `from`, this function is called.
729      *
730      * It must return its Solidity selector to confirm the token transfer.
731      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
732      *
733      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
734      */
735     function onERC721Received(
736         address operator,
737         address from,
738         uint256 tokenId,
739         bytes calldata data
740     ) external returns (bytes4);
741 }
742 
743 /**
744  * @dev Contract module which provides a basic access control mechanism, where
745  * there is an account (an owner) that can be granted exclusive access to
746  * specific functions.
747  *
748  * By default, the owner account will be the one that deploys the contract. This
749  * can later be changed with {transferOwnership}.
750  *
751  * This module is used through inheritance. It will make available the modifier
752  * `onlyOwner`, which can be applied to your functions to restrict their use to
753  * the owner.
754  */
755 abstract contract Ownable is Context {
756     address private _owner;
757 
758     event OwnershipTransferred(
759         address indexed previousOwner,
760         address indexed newOwner
761     );
762 
763     /**
764      * @dev Initializes the contract setting the deployer as the initial owner.
765      */
766     constructor() {
767         address msgSender = _msgSender();
768         _owner = msgSender;
769         emit OwnershipTransferred(address(0), msgSender);
770     }
771 
772     /**
773      * @dev Returns the address of the current owner.
774      */
775     function owner() public view virtual returns (address) {
776         return _owner;
777     }
778 
779     /**
780      * @dev Throws if called by any account other than the owner.
781      */
782     modifier onlyOwner() {
783         require(owner() == _msgSender(), "Ownable: caller is not the owner");
784         _;
785     }
786 
787     /**
788      * @dev Leaves the contract without owner. It will not be possible to call
789      * `onlyOwner` functions anymore. Can only be called by the current owner.
790      *
791      * NOTE: Renouncing ownership will leave the contract without an owner,
792      * thereby removing any functionality that is only available to the owner.
793      */
794     function renounceOwnership() public virtual onlyOwner {
795         emit OwnershipTransferred(_owner, address(0));
796         _owner = address(0);
797     }
798 
799     /**
800      * @dev Transfers ownership of the contract to a new account (`newOwner`).
801      * Can only be called by the current owner.
802      */
803     function transferOwnership(address newOwner) public virtual onlyOwner {
804         require(
805             newOwner != address(0),
806             "Ownable: new owner is the zero address"
807         );
808         emit OwnershipTransferred(_owner, newOwner);
809         _owner = newOwner;
810     }
811 }
812 
813 /**
814  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
815  * the Metadata extension, but not including the Enumerable extension, which is available separately as
816  * {ERC721Enumerable}.
817  */
818 abstract contract ERC721 is
819     Context,
820     ERC2981,
821     IERC721,
822     IERC721Metadata,
823     Ownable
824 {
825     using Address for address;
826     using Strings for uint256;
827 
828     // Token name
829     string private _name;
830 
831     // Token symbol
832     string private _symbol;
833 
834     // Mapping from token ID to owner address
835     mapping(uint256 => address) internal _owners;
836 
837     // Mapping owner address to token count
838     mapping(address => uint256) internal _balances;
839 
840     // Mapping from token ID to approved address
841     mapping(uint256 => address) private _tokenApprovals;
842 
843     // Mapping from owner to operator approvals
844     mapping(address => mapping(address => bool)) private _operatorApprovals;
845 
846     /**
847      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
848      */
849     constructor(string memory name_, string memory symbol_) {
850         _name = name_;
851         _symbol = symbol_;
852     }
853 
854     /**
855      * @dev See {IERC165-supportsInterface}.
856      */
857     function supportsInterface(
858         bytes4 interfaceId
859     ) public view virtual override(ERC2981, IERC165) returns (bool) {
860         return
861             interfaceId == type(IERC721).interfaceId ||
862             interfaceId == type(IERC721Metadata).interfaceId ||
863             interfaceId == type(IERC2981).interfaceId ||
864             super.supportsInterface(interfaceId);
865     }
866 
867     /**
868      * @dev See {IERC721-balanceOf}.
869      */
870     function balanceOf(
871         address owner
872     ) public view virtual override returns (uint256) {
873         require(
874             owner != address(0),
875             "ERC721: balance query for the zero address"
876         );
877         return _balances[owner];
878     }
879 
880     /**
881      * @dev See {IERC721-ownerOf}.
882      */
883     function ownerOf(
884         uint256 tokenId
885     ) public view virtual override returns (address) {
886         address owner = _owners[tokenId];
887         require(
888             owner != address(0),
889             "ERC721: owner query for nonexistent token"
890         );
891         return owner;
892     }
893 
894     /**
895      * @dev See {IERC721Metadata-name}.
896      */
897     function name() public view virtual override returns (string memory) {
898         return _name;
899     }
900 
901     /**
902      * @dev See {IERC721Metadata-symbol}.
903      */
904     function symbol() public view virtual override returns (string memory) {
905         return _symbol;
906     }
907 
908     /**
909      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
910      * in child contracts.
911      */
912     function _baseURI() internal view virtual returns (string memory) {
913         return "";
914     }
915 
916     /**
917      * @dev See {IERC721-approve}.
918      */
919     function approve(address to, uint256 tokenId) public virtual override {
920         address owner = ERC721.ownerOf(tokenId);
921         require(to != owner, "ERC721: approval to current owner");
922 
923         require(
924             _msgSender() == owner ||
925                 ERC721.isApprovedForAll(owner, _msgSender()),
926             "ERC721: approve caller is not owner nor approved for all"
927         );
928 
929         _approve(to, tokenId);
930     }
931 
932     /**
933      * @dev See {IERC721-getApproved}.
934      */
935     function getApproved(
936         uint256 tokenId
937     ) public view virtual override returns (address) {
938         require(
939             _exists(tokenId),
940             "ERC721: approved query for nonexistent token"
941         );
942 
943         return _tokenApprovals[tokenId];
944     }
945 
946     /**
947      * @dev See {IERC721-setApprovalForAll}.
948      */
949     function setApprovalForAll(
950         address operator,
951         bool approved
952     ) public virtual override {
953         require(operator != _msgSender(), "ERC721: approve to caller");
954 
955         _operatorApprovals[_msgSender()][operator] = approved;
956         emit ApprovalForAll(_msgSender(), operator, approved);
957     }
958 
959     /**
960      * @dev See {IERC721-isApprovedForAll}.
961      */
962     function isApprovedForAll(
963         address owner,
964         address operator
965     ) public view virtual override returns (bool) {
966         return _operatorApprovals[owner][operator];
967     }
968 
969     /**
970      * @dev See {IERC721-transferFrom}.
971      */
972     function transferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) public virtual override {
977         //solhint-disable-next-line max-line-length
978         require(
979             _isApprovedOrOwner(_msgSender(), tokenId),
980             "ERC721: transfer caller is not owner nor approved"
981         );
982 
983         _transfer(from, to, tokenId);
984     }
985 
986     /**
987      * @dev See {IERC721-safeTransferFrom}.
988      */
989     function safeTransferFrom(
990         address from,
991         address to,
992         uint256 tokenId
993     ) public virtual override {
994         safeTransferFrom(from, to, tokenId, "");
995     }
996 
997     /**
998      * @dev See {IERC721-safeTransferFrom}.
999      */
1000     function safeTransferFrom(
1001         address from,
1002         address to,
1003         uint256 tokenId,
1004         bytes memory _data
1005     ) public virtual override {
1006         require(
1007             _isApprovedOrOwner(_msgSender(), tokenId),
1008             "ERC721: transfer caller is not owner nor approved"
1009         );
1010         _safeTransfer(from, to, tokenId, _data);
1011     }
1012 
1013     /**
1014      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1015      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1016      *
1017      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1018      *
1019      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1020      * implement alternative mechanisms to perform token transfer, such as signature-based.
1021      *
1022      * Requirements:
1023      *
1024      * - `from` cannot be the zero address.
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must exist and be owned by `from`.
1027      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _safeTransfer(
1032         address from,
1033         address to,
1034         uint256 tokenId,
1035         bytes memory _data
1036     ) internal virtual {
1037         _transfer(from, to, tokenId);
1038         require(
1039             _checkOnERC721Received(from, to, tokenId, _data),
1040             "ERC721: transfer to non ERC721Receiver implementer"
1041         );
1042     }
1043 
1044     /**
1045      * @dev Returns whether `tokenId` exists.
1046      *
1047      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1048      *
1049      * Tokens start existing when they are minted (`_mint`),
1050      * and stop existing when they are burned (`_burn`).
1051      */
1052     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1053         return _owners[tokenId] != address(0);
1054     }
1055 
1056     /**
1057      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1058      *
1059      * Requirements:
1060      *
1061      * - `tokenId` must exist.
1062      */
1063     function _isApprovedOrOwner(
1064         address spender,
1065         uint256 tokenId
1066     ) internal view virtual returns (bool) {
1067         require(
1068             _exists(tokenId),
1069             "ERC721: operator query for nonexistent token"
1070         );
1071         address owner = ERC721.ownerOf(tokenId);
1072         return (spender == owner ||
1073             getApproved(tokenId) == spender ||
1074             ERC721.isApprovedForAll(owner, spender));
1075     }
1076 
1077     /**
1078      * @dev Safely mints `tokenId` and transfers it to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - `tokenId` must not exist.
1083      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _safeMint(address to, uint256 tokenId) internal virtual {
1088         _safeMint(to, tokenId, "");
1089     }
1090 
1091     /**
1092      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1093      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1094      */
1095     function _safeMint(
1096         address to,
1097         uint256 tokenId,
1098         bytes memory _data
1099     ) internal virtual {
1100         _mint(to, tokenId);
1101         require(
1102             _checkOnERC721Received(address(0), to, tokenId, _data),
1103             "ERC721: transfer to non ERC721Receiver implementer"
1104         );
1105     }
1106 
1107     /**
1108      * @dev Mints `tokenId` and transfers it to `to`.
1109      *
1110      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1111      *
1112      * Requirements:
1113      *
1114      * - `tokenId` must not exist.
1115      * - `to` cannot be the zero address.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _mint(address to, uint256 tokenId) internal virtual {
1120         require(to != address(0), "ERC721: mint to the zero address");
1121         require(!_exists(tokenId), "ERC721: token already minted");
1122 
1123         _beforeTokenTransfer(address(0), to, tokenId);
1124 
1125         _balances[to] += 1;
1126         _owners[tokenId] = to;
1127 
1128         emit Transfer(address(0), to, tokenId);
1129     }
1130 
1131     function _batchMint(
1132         address to,
1133         uint256[] memory tokenIds
1134     ) internal virtual {
1135         require(to != address(0), "ERC721: mint to the zero address");
1136         _balances[to] += tokenIds.length;
1137 
1138         for (uint256 i; i < tokenIds.length; i++) {
1139             require(!_exists(tokenIds[i]), "ERC721: token already minted");
1140 
1141             _beforeTokenTransfer(address(0), to, tokenIds[i]);
1142 
1143             _owners[tokenIds[i]] = to;
1144 
1145             emit Transfer(address(0), to, tokenIds[i]);
1146         }
1147     }
1148 
1149     /**
1150      * @dev Destroys `tokenId`.
1151      * The approval is cleared when the token is burned.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must exist.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _burn(uint256 tokenId) internal virtual {
1160         address owner = ERC721.ownerOf(tokenId);
1161 
1162         _beforeTokenTransfer(owner, address(0), tokenId);
1163 
1164         // Clear approvals
1165         _approve(address(0), tokenId);
1166 
1167         _balances[owner] -= 1;
1168         delete _owners[tokenId];
1169 
1170         emit Transfer(owner, address(0), tokenId);
1171     }
1172 
1173     /**
1174      * @dev Transfers `tokenId` from `from` to `to`.
1175      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1176      *
1177      * Requirements:
1178      *
1179      * - `to` cannot be the zero address.
1180      * - `tokenId` token must be owned by `from`.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function _transfer(
1185         address from,
1186         address to,
1187         uint256 tokenId
1188     ) internal virtual {
1189         require(
1190             ERC721.ownerOf(tokenId) == from,
1191             "ERC721: transfer of token that is not own"
1192         );
1193         require(to != address(0), "ERC721: transfer to the zero address");
1194 
1195         _beforeTokenTransfer(from, to, tokenId);
1196 
1197         // Clear approvals from the previous owner
1198         _approve(address(0), tokenId);
1199 
1200         _balances[from] -= 1;
1201         _balances[to] += 1;
1202         _owners[tokenId] = to;
1203 
1204         emit Transfer(from, to, tokenId);
1205     }
1206 
1207     /**
1208      * @dev Approve `to` to operate on `tokenId`
1209      *
1210      * Emits a {Approval} event.
1211      */
1212     function _approve(address to, uint256 tokenId) internal virtual {
1213         _tokenApprovals[tokenId] = to;
1214         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1215     }
1216 
1217     /**
1218      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1219      * The call is not executed if the target address is not a contract.
1220      *
1221      * @param from address representing the previous owner of the given token ID
1222      * @param to target address that will receive the tokens
1223      * @param tokenId uint256 ID of the token to be transferred
1224      * @param _data bytes optional data to send along with the call
1225      * @return bool whether the call correctly returned the expected magic value
1226      */
1227     function _checkOnERC721Received(
1228         address from,
1229         address to,
1230         uint256 tokenId,
1231         bytes memory _data
1232     ) private returns (bool) {
1233         if (to.isContract()) {
1234             try
1235                 IERC721Receiver(to).onERC721Received(
1236                     _msgSender(),
1237                     from,
1238                     tokenId,
1239                     _data
1240                 )
1241             returns (bytes4 retval) {
1242                 return retval == IERC721Receiver(to).onERC721Received.selector;
1243             } catch (bytes memory reason) {
1244                 if (reason.length == 0) {
1245                     revert(
1246                         "ERC721: transfer to non ERC721Receiver implementer"
1247                     );
1248                 } else {
1249                     // solhint-disable-next-line no-inline-assembly
1250                     assembly {
1251                         revert(add(32, reason), mload(reason))
1252                     }
1253                 }
1254             }
1255         } else {
1256             return true;
1257         }
1258     }
1259 
1260     /**
1261      * @dev Hook that is called before any token transfer. This includes minting
1262      * and burning.
1263      *
1264      * Calling conditions:
1265      *
1266      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1267      * transferred to `to`.
1268      * - When `from` is zero, `tokenId` will be minted for `to`.
1269      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1270      * - `from` cannot be the zero address.
1271      * - `to` cannot be the zero address.
1272      *
1273      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1274      */
1275     function _beforeTokenTransfer(
1276         address from,
1277         address to,
1278         uint256 tokenId
1279     ) internal virtual {}
1280 }
1281 
1282 /**
1283  * @dev These functions deal with verification of Merkle Trees proofs.
1284  *
1285  * The proofs can be generated using the JavaScript library
1286  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1287  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1288  *
1289  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1290  *
1291  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1292  * hashing, or use a hash function other than keccak256 for hashing leaves.
1293  * This is because the concatenation of a sorted pair of internal nodes in
1294  * the merkle tree could be reinterpreted as a leaf value.
1295  */
1296 library MerkleProof {
1297     /**
1298      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1299      * defined by `root`. For this, a `proof` must be provided, containing
1300      * sibling hashes on the branch from the leaf to the root of the tree. Each
1301      * pair of leaves and each pair of pre-images are assumed to be sorted.
1302      */
1303     function verify(
1304         bytes32[] memory proof,
1305         bytes32 root,
1306         bytes32 leaf
1307     ) internal pure returns (bool) {
1308         return processProof(proof, leaf) == root;
1309     }
1310 
1311     /**
1312      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1313      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1314      * hash matches the root of the tree. When processing the proof, the pairs
1315      * of leafs & pre-images are assumed to be sorted.
1316      *
1317      * _Available since v4.4._
1318      */
1319     function processProof(
1320         bytes32[] memory proof,
1321         bytes32 leaf
1322     ) internal pure returns (bytes32) {
1323         bytes32 computedHash = leaf;
1324         for (uint256 i = 0; i < proof.length; i++) {
1325             bytes32 proofElement = proof[i];
1326             if (computedHash <= proofElement) {
1327                 // Hash(current computed hash + current element of the proof)
1328                 computedHash = _efficientHash(computedHash, proofElement);
1329             } else {
1330                 // Hash(current element of the proof + current computed hash)
1331                 computedHash = _efficientHash(proofElement, computedHash);
1332             }
1333         }
1334         return computedHash;
1335     }
1336 
1337     function _efficientHash(
1338         bytes32 a,
1339         bytes32 b
1340     ) private pure returns (bytes32 value) {
1341         assembly {
1342             mstore(0x00, a)
1343             mstore(0x20, b)
1344             value := keccak256(0x00, 0x40)
1345         }
1346     }
1347 }
1348 
1349 interface VRFCoordinatorV2Interface {
1350     function getRequestConfig()
1351         external
1352         view
1353         returns (uint16, uint32, bytes32[] memory);
1354 
1355     function requestRandomWords(
1356         bytes32 keyHash,
1357         uint64 subId,
1358         uint16 minimumRequestConfirmations,
1359         uint32 callbackGasLimit,
1360         uint32 numWords
1361     ) external returns (uint256 requestId);
1362 
1363     function createSubscription() external returns (uint64 subId);
1364 
1365     function getSubscription(
1366         uint64 subId
1367     )
1368         external
1369         view
1370         returns (
1371             uint96 balance,
1372             uint64 reqCount,
1373             address owner,
1374             address[] memory consumers
1375         );
1376 
1377     function requestSubscriptionOwnerTransfer(
1378         uint64 subId,
1379         address newOwner
1380     ) external;
1381 
1382     function acceptSubscriptionOwnerTransfer(uint64 subId) external;
1383 
1384     function addConsumer(uint64 subId, address consumer) external;
1385 
1386     function removeConsumer(uint64 subId, address consumer) external;
1387 
1388     function cancelSubscription(uint64 subId, address to) external;
1389 
1390     function pendingRequestExists(uint64 subId) external view returns (bool);
1391 }
1392 
1393 abstract contract VRFConsumerBaseV2 {
1394     error OnlyCoordinatorCanFulfill(address have, address want);
1395     address private immutable vrfCoordinator;
1396 
1397     constructor(address _vrfCoordinator) {
1398         vrfCoordinator = _vrfCoordinator;
1399     }
1400 
1401     function fulfillRandomWords(
1402         uint256 requestId,
1403         uint256[] memory randomWords
1404     ) internal virtual;
1405 
1406     function rawFulfillRandomWords(
1407         uint256 requestId,
1408         uint256[] memory randomWords
1409     ) external {
1410         if (msg.sender != vrfCoordinator) {
1411             revert OnlyCoordinatorCanFulfill(msg.sender, vrfCoordinator);
1412         }
1413         fulfillRandomWords(requestId, randomWords);
1414     }
1415 }
1416 
1417 contract CosmeComics is ERC721, VRFConsumerBaseV2 {
1418     VRFCoordinatorV2Interface private COORDINATOR;
1419     using Strings for uint256;
1420     uint64 private s_subscriptionId = 564;
1421     bytes32 private s_keyHash =
1422         0x8af398995b04c28e9951adb9721ef74c74f93e6a478f39e7e0777be13527e7ef;
1423     uint32 private CALLBACK_GAS_LIMIT = 100000;
1424     uint16 constant REQUEST_CONFIRMATIONS = 3;
1425     mapping(uint256 => uint256) public requestMap;
1426     mapping(uint256 => bool) public blockedToken;
1427 
1428     /**
1429      * @notice Allow owner to change VRF config
1430      */
1431     function setVRFConfig(
1432         uint64 sID,
1433         bytes32 keyHash,
1434         uint32 gasLimit
1435     ) external onlyOwner {
1436         s_subscriptionId = sID;
1437         s_keyHash = keyHash;
1438         CALLBACK_GAS_LIMIT = gasLimit;
1439     }
1440 
1441     modifier callerIsUser() {
1442         require(tx.origin == msg.sender, "The caller is another contract");
1443         _;
1444     }
1445 
1446     modifier claimStarted() {
1447         require(startClaim, "You are too early");
1448         _;
1449     }
1450 
1451     bool public startClaim = false;
1452     bool public startPreSale = false;
1453     uint256 private claimPrice = 0.068 ether;
1454     uint256 private totalTokens = 1500;
1455     uint256 private totalMintedTokens = 0;
1456     uint128 private resNfts = 100;
1457     uint256 private totalReserved = 0;
1458     uint16 public currentStage = 0;
1459 
1460     mapping(address => uint256) private claimedTokensPreSale;
1461     mapping(address => uint256) private claimedTokensPublicSale;
1462     mapping(uint256 => uint16) public tokenStage;
1463     mapping(uint256 => uint256) internal tokenMap;
1464     mapping(uint16 => string) private baseURI;
1465 
1466     bytes32 public merkleRoot =
1467         0xbcc7b3368728ef5149db9e16de1d44fc7576cb22cdf60a5f0586b38c4e39edff;
1468 
1469     mapping(uint16 => uint16[]) private availableTokens;
1470 
1471     constructor() ERC721("Cosme", "COSME") VRFConsumerBaseV2(0x271682DEB8C4E0901D1a1550aD2e64D568E69909) {
1472         COORDINATOR = VRFCoordinatorV2Interface(0x271682DEB8C4E0901D1a1550aD2e64D568E69909);
1473         _setDefaultRoyalty(0xE0b632314A09561c3c4E35f247B6390dB9204De6, 500);
1474         baseURI[0] = "ipfs://QmcuRCBU1FFgniaYVdVZs4FPYS665C419suujvU6e6BeeH/?";
1475     }
1476 
1477     /**
1478      * @notice Allow owner to update the royalty fee
1479      */
1480     function setRoyaltyFee(address addr, uint96 fee) external onlyOwner {
1481         _setDefaultRoyalty(addr, fee);
1482     }
1483 
1484     /**
1485      * @dev Sets the claim price for each token
1486      */
1487     function setClaimPrice(uint256 _claimPrice) external onlyOwner {
1488         claimPrice = _claimPrice;
1489     }
1490 
1491     /**
1492      * @dev Set markle root
1493      */
1494     function setMarkleRoot(bytes32 _root) external onlyOwner {
1495         merkleRoot = _root;
1496     }
1497 
1498     /**
1499      * @dev toggle the claim start
1500      */
1501     function toggleClaimStart() external onlyOwner {
1502         startClaim = !startClaim;
1503     }
1504 
1505     /**
1506      * @dev toggle the claim start
1507      */
1508     function togglePreSale() external onlyOwner {
1509         startPreSale = !startPreSale;
1510     }
1511 
1512     /**
1513      * @dev Sets the current active stage
1514      */
1515     function setCurrentStage(uint16 _stage) external onlyOwner {
1516         currentStage = _stage;
1517     }
1518 
1519     /**
1520      * @dev Populates the available tokens
1521      */
1522     function addAvailableTokens(uint16 _stage) external onlyOwner {
1523         if (availableTokens[_stage].length == 0) {
1524             for (uint16 i = 1; i <= 1500; i++) {
1525                 availableTokens[_stage].push(i);
1526             }
1527         }
1528     }
1529 
1530     function withdraw() external onlyOwner {
1531         uint256 totalBalance = address(this).balance;
1532 
1533         (bool devOk, ) = payable(0x974a394ea3d1EAbDAbb53aa0B102b8894f16c60b)
1534             .call{value: (totalBalance * 650) / 10000}("");
1535         require(devOk);
1536 
1537         (bool ownerOk, ) = payable(msg.sender).call{
1538             value: (totalBalance * 9350) / 10000
1539         }("");
1540         require(ownerOk);
1541     }
1542 
1543     /**
1544      * @dev See {ERC721}.
1545      */
1546     function _baseURI() internal view virtual override returns (string memory) {
1547         return baseURI[0];
1548     }
1549 
1550     /**
1551      * @dev Sets the base URI for the API that provides the NFT data.
1552      */
1553     function setBaseTokenURI(
1554         uint16 _stage,
1555         string memory _uri
1556     ) external onlyOwner {
1557         baseURI[_stage] = _uri;
1558     }
1559 
1560     function tokenURI(
1561         uint256 tokenId
1562     ) public view virtual override returns (string memory) {
1563         require(
1564             _exists(tokenId),
1565             "ERC721Metadata: URI query for nonexistent token"
1566         );
1567         return
1568             string(
1569                 abi.encodePacked(
1570                     baseURI[tokenStage[tokenId]],
1571                     tokenMap[tokenId].toString()
1572                 )
1573             );
1574     }
1575 
1576     /**
1577      * @dev Returns the claim price
1578      */
1579     function getClaimPrice() external view returns (uint256) {
1580         return claimPrice;
1581     }
1582 
1583     /**
1584      * @dev Returns the total supply
1585      */
1586     function totalSupply() external view virtual returns (uint256) {
1587         return totalMintedTokens;
1588     }
1589 
1590     // Private and Internal functions
1591 
1592     /**
1593      * @dev Returns a random available token to be claimed
1594      */
1595     function getTokenToBeClaimed(
1596         uint16 _stage,
1597         uint256 randomWord
1598     ) private returns (uint256) {
1599         uint256 random = randomWord % availableTokens[_stage].length;
1600         uint256 tokenId = uint256(availableTokens[_stage][random]);
1601 
1602         availableTokens[_stage][random] = availableTokens[_stage][
1603             availableTokens[_stage].length - 1
1604         ];
1605         availableTokens[_stage].pop();
1606         return tokenId;
1607     }
1608 
1609     /**
1610      * @dev Returns how many tokens are still available to be claimed in current Stage
1611      */
1612     function getAvailableTokens() external view returns (uint256) {
1613         return availableTokens[currentStage].length;
1614     }
1615 
1616     function walletOfOwner(
1617         address _owner
1618     ) public view returns (uint256[] memory) {
1619         uint256 ownerTokenCount = balanceOf(_owner);
1620         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1621         uint256 currentTokenId = 1;
1622         uint256 ownedTokenIndex = 0;
1623 
1624         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= 1500) {
1625             if (_exists(currentTokenId)) {
1626                 address currentTokenOwner = ownerOf(currentTokenId);
1627 
1628                 if (currentTokenOwner == _owner) {
1629                     ownedTokenIds[ownedTokenIndex] = currentTokenId;
1630 
1631                     ownedTokenIndex++;
1632                 }
1633             }
1634             currentTokenId++;
1635         }
1636 
1637         return ownedTokenIds;
1638     }
1639 
1640     /**
1641      * @dev Claim up to 2 tokens at once
1642      */
1643     function claimTokenWhitelist(
1644         bytes32[] calldata _merkleProof,
1645         uint256 amount
1646     ) external payable callerIsUser {
1647         require(startPreSale, "Presale not started yet ");
1648         require(
1649             claimedTokensPreSale[msg.sender] + amount <= 2,
1650             "You cannot claim more tokens"
1651         );
1652         require(
1653             totalMintedTokens + amount <= totalTokens,
1654             "No tokens left to be claimed"
1655         );
1656         require(
1657             msg.value >= claimPrice * amount,
1658             "Not enough Ether to claim a token"
1659         );
1660 
1661         claimedTokensPreSale[msg.sender] += amount;
1662         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1663         require(
1664             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1665             "Invalid Proof."
1666         );
1667         uint256[] memory tokenIds = new uint256[](amount);
1668         for (uint256 i; i < amount; i++) {
1669             tokenIds[i] = ++totalMintedTokens;
1670             tokenStage[tokenIds[i]] = 0;
1671             tokenMap[tokenIds[i]] = tokenIds[i];
1672         }
1673 
1674         _batchMint(msg.sender, tokenIds);
1675     }
1676 
1677     /**
1678      * @dev Claim up to 4 tokens at once
1679      */
1680     function claimTokens(
1681         uint256 amount
1682     ) external payable callerIsUser claimStarted {
1683         require(
1684             msg.value >= claimPrice * amount,
1685             "Not enough Ether to claim the tokens"
1686         );
1687         require(
1688             claimedTokensPublicSale[msg.sender] + amount <= 4,
1689             "You cannot claim more tokens"
1690         );
1691         require(
1692             totalMintedTokens + amount <= totalTokens,
1693             "No tokens left to be claimed"
1694         );
1695 
1696         uint256[] memory tokenIds = new uint256[](amount);
1697 
1698         claimedTokensPublicSale[msg.sender] += amount;
1699 
1700         for (uint256 i; i < amount; i++) {
1701             tokenIds[i] = ++totalMintedTokens;
1702             tokenStage[tokenIds[i]] = 0;
1703             tokenMap[tokenIds[i]] = tokenIds[i];
1704         }
1705 
1706         _batchMint(msg.sender, tokenIds);
1707     }
1708 
1709     function swapToken(uint256 _id) external payable callerIsUser claimStarted {
1710         require(
1711             ownerOf(_id) == msg.sender,
1712             "You are not the owner of this token"
1713         );
1714         require(
1715             tokenStage[_id] < currentStage,
1716             "You are not eligible for current stage"
1717         );
1718         require(blockedToken[_id] == false, "You have requested already");
1719         require(
1720             availableTokens[currentStage].length >= 1,
1721             "swaping pfp not available"
1722         );
1723         if (tokenStage[_id] > 0) {
1724             require(
1725                 msg.value >= claimPrice,
1726                 "Not enough Ether to swap the PFP"
1727             );
1728         }
1729         uint256 s_requestId = COORDINATOR.requestRandomWords(
1730             s_keyHash,
1731             s_subscriptionId,
1732             REQUEST_CONFIRMATIONS,
1733             CALLBACK_GAS_LIMIT,
1734             1
1735         );
1736         requestMap[s_requestId] = _id;
1737         blockedToken[_id] = true;
1738     }
1739 
1740     function fulfillRandomWords(
1741         uint256 requestId,
1742         uint256[] memory randomWords
1743     ) internal override {
1744         uint256 _id = requestMap[requestId];
1745         tokenMap[_id] = getTokenToBeClaimed(currentStage, randomWords[0]);
1746         tokenStage[_id] = currentStage;
1747         blockedToken[_id] = false;
1748     }
1749 
1750     /**
1751      * Set 100 random Nfts aside for rewards and wages
1752      */
1753     function reserveNfts() external onlyOwner {
1754         require(
1755             totalMintedTokens + 20 <= totalTokens,
1756             "No tokens left to reserve"
1757         );
1758         require(
1759             totalReserved < resNfts,
1760             "100 Nfts have been already reserved, you can not reserve more"
1761         );
1762         uint256[] memory tokenIds = new uint256[](20);
1763         totalReserved += 20;
1764 
1765         for (uint256 i; i < 20; i++) {
1766             tokenIds[i] = ++totalMintedTokens;
1767             tokenStage[tokenIds[i]] = 0;
1768             tokenMap[tokenIds[i]] = tokenIds[i];
1769         }
1770         _batchMint(msg.sender, tokenIds);
1771     }
1772 }