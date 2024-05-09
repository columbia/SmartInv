1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.2;
3 
4 library Strings {
5     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
6 
7     /**
8      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
9      */
10     function toString(uint256 value) internal pure returns (string memory) {
11         // Inspired by OraclizeAPI's implementation - MIT licence
12         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
13 
14         if (value == 0) {
15             return "0";
16         }
17         uint256 temp = value;
18         uint256 digits;
19         while (temp != 0) {
20             digits++;
21             temp /= 10;
22         }
23         bytes memory buffer = new bytes(digits);
24         while (value != 0) {
25             digits -= 1;
26             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
27             value /= 10;
28         }
29         return string(buffer);
30     }
31 
32     /**
33      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
34      */
35     function toHexString(uint256 value) internal pure returns (string memory) {
36         if (value == 0) {
37             return "0x00";
38         }
39         uint256 temp = value;
40         uint256 length = 0;
41         while (temp != 0) {
42             length++;
43             temp >>= 8;
44         }
45         return toHexString(value, length);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
50      */
51     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
52         bytes memory buffer = new bytes(2 * length + 2);
53         buffer[0] = "0";
54         buffer[1] = "x";
55         for (uint256 i = 2 * length + 1; i > 1; --i) {
56             buffer[i] = _HEX_SYMBOLS[value & 0xf];
57             value >>= 4;
58         }
59         require(value == 0, "Strings: hex length insufficient");
60         return string(buffer);
61     }
62 }
63 
64 
65 library Address {
66     /**
67      * @dev Returns true if `account` is a contract.
68      *
69      * [IMPORTANT]
70      * ====
71      * It is unsafe to assume that an address for which this function returns
72      * false is an externally-owned account (EOA) and not a contract.
73      *
74      * Among others, `isContract` will return false for the following
75      * types of addresses:
76      *
77      *  - an externally-owned account
78      *  - a contract in construction
79      *  - an address where a contract will be created
80      *  - an address where a contract lived, but was destroyed
81      * ====
82      *
83      * [IMPORTANT]
84      * ====
85      * You shouldn't rely on `isContract` to protect against flash loan attacks!
86      *
87      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
88      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
89      * constructor.
90      * ====
91      */
92     function isContract(address account) internal view returns (bool) {
93         // This method relies on extcodesize/address.code.length, which returns 0
94         // for contracts in construction, since the code is only stored at the end
95         // of the constructor execution.
96 
97         return account.code.length > 0;
98     }
99 
100     /**
101      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
102      * `recipient`, forwarding all available gas and reverting on errors.
103      *
104      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
105      * of certain opcodes, possibly making contracts go over the 2300 gas limit
106      * imposed by `transfer`, making them unable to receive funds via
107      * `transfer`. {sendValue} removes this limitation.
108      *
109      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
110      *
111      * IMPORTANT: because control is transferred to `recipient`, care must be
112      * taken to not create reentrancy vulnerabilities. Consider using
113      * {ReentrancyGuard} or the
114      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
115      */
116     function sendValue(address payable recipient, uint256 amount) internal {
117         require(address(this).balance >= amount, "Address: insufficient balance");
118 
119         (bool success, ) = recipient.call{value: amount}("");
120         require(success, "Address: unable to send value, recipient may have reverted");
121     }
122 
123     /**
124      * @dev Performs a Solidity function call using a low level `call`. A
125      * plain `call` is an unsafe replacement for a function call: use this
126      * function instead.
127      *
128      * If `target` reverts with a revert reason, it is bubbled up by this
129      * function (like regular Solidity function calls).
130      *
131      * Returns the raw returned data. To convert to the expected return value,
132      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
133      *
134      * Requirements:
135      *
136      * - `target` must be a contract.
137      * - calling `target` with `data` must not revert.
138      *
139      * _Available since v3.1._
140      */
141     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
142         return functionCall(target, data, "Address: low-level call failed");
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
147      * `errorMessage` as a fallback revert reason when `target` reverts.
148      *
149      * _Available since v3.1._
150      */
151     function functionCall(
152         address target,
153         bytes memory data,
154         string memory errorMessage
155     ) internal returns (bytes memory) {
156         return functionCallWithValue(target, data, 0, errorMessage);
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
161      * but also transferring `value` wei to `target`.
162      *
163      * Requirements:
164      *
165      * - the calling contract must have an ETH balance of at least `value`.
166      * - the called Solidity function must be `payable`.
167      *
168      * _Available since v3.1._
169      */
170     function functionCallWithValue(
171         address target,
172         bytes memory data,
173         uint256 value
174     ) internal returns (bytes memory) {
175         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
180      * with `errorMessage` as a fallback revert reason when `target` reverts.
181      *
182      * _Available since v3.1._
183      */
184     function functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 value,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         require(address(this).balance >= value, "Address: insufficient balance for call");
191         require(isContract(target), "Address: call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.call{value: value}(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but performing a static call.
200      *
201      * _Available since v3.3._
202      */
203     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
204         return functionStaticCall(target, data, "Address: low-level static call failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
209      * but performing a static call.
210      *
211      * _Available since v3.3._
212      */
213     function functionStaticCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal view returns (bytes memory) {
218         require(isContract(target), "Address: static call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.staticcall(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a delegate call.
227      *
228      * _Available since v3.4._
229      */
230     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
231         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a delegate call.
237      *
238      * _Available since v3.4._
239      */
240     function functionDelegateCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal returns (bytes memory) {
245         require(isContract(target), "Address: delegate call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.delegatecall(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
253      * revert reason using the provided one.
254      *
255      * _Available since v4.3._
256      */
257     function verifyCallResult(
258         bool success,
259         bytes memory returndata,
260         string memory errorMessage
261     ) internal pure returns (bytes memory) {
262         if (success) {
263             return returndata;
264         } else {
265             // Look for revert reason and bubble it up if present
266             if (returndata.length > 0) {
267                 // The easiest way to bubble the revert reason is using memory via assembly
268 
269                 assembly {
270                     let returndata_size := mload(returndata)
271                     revert(add(32, returndata), returndata_size)
272                 }
273             } else {
274                 revert(errorMessage);
275             }
276         }
277     }
278 }
279 
280 
281 abstract contract Context {
282     function _msgSender() internal view virtual returns (address) {
283         return msg.sender;
284     }
285 
286     function _msgData() internal view virtual returns (bytes calldata) {
287         return msg.data;
288     }
289 }
290 
291 abstract contract Ownable is Context {
292     address private _owner;
293 
294     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
295 
296     /**
297      * @dev Initializes the contract setting the deployer as the initial owner.
298      */
299     constructor() {
300         _transferOwnership(_msgSender());
301     }
302 
303     /**
304      * @dev Returns the address of the current owner.
305      */
306     function owner() public view virtual returns (address) {
307         return _owner;
308     }
309 
310     /**
311      * @dev Throws if called by any account other than the owner.
312      */
313     modifier onlyOwner() {
314         require(owner() == _msgSender(), "Ownable: caller is not the owner");
315         _;
316     }
317 
318     /**
319      * @dev Leaves the contract without owner. It will not be possible to call
320      * `onlyOwner` functions anymore. Can only be called by the current owner.
321      *
322      * NOTE: Renouncing ownership will leave the contract without an owner,
323      * thereby removing any functionality that is only available to the owner.
324      */
325     function renounceOwnership() public virtual onlyOwner {
326         _transferOwnership(address(0));
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Can only be called by the current owner.
332      */
333     function transferOwnership(address newOwner) public virtual onlyOwner {
334         require(newOwner != address(0), "Ownable: new owner is the zero address");
335         _transferOwnership(newOwner);
336     }
337 
338     /**
339      * @dev Transfers ownership of the contract to a new account (`newOwner`).
340      * Internal function without access restriction.
341      */
342     function _transferOwnership(address newOwner) internal virtual {
343         address oldOwner = _owner;
344         _owner = newOwner;
345         emit OwnershipTransferred(oldOwner, newOwner);
346     }
347 }
348 
349 
350 interface IERC165 {
351     /**
352      * @dev Returns true if this contract implements the interface defined by
353      * `interfaceId`. See the corresponding
354      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
355      * to learn more about how these ids are created.
356      *
357      * This function call must use less than 30 000 gas.
358      */
359     function supportsInterface(bytes4 interfaceId) external view returns (bool);
360 }
361 
362 abstract contract ERC165 is IERC165 {
363     /**
364      * @dev See {IERC165-supportsInterface}.
365      */
366     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
367         return interfaceId == type(IERC165).interfaceId;
368     }
369 }
370 
371 interface IERC721 is IERC165 {
372     /**
373      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
376 
377     /**
378      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
379      */
380     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
381 
382     /**
383      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
384      */
385     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
386 
387     /**
388      * @dev Returns the number of tokens in ``owner``'s account.
389      */
390     function balanceOf(address owner) external view returns (uint256 balance);
391 
392     /**
393      * @dev Returns the owner of the `tokenId` token.
394      *
395      * Requirements:
396      *
397      * - `tokenId` must exist.
398      */
399     function ownerOf(uint256 tokenId) external view returns (address owner);
400 
401     /**
402      * @dev Safely transfers `tokenId` token from `from` to `to`.
403      *
404      * Requirements:
405      *
406      * - `from` cannot be the zero address.
407      * - `to` cannot be the zero address.
408      * - `tokenId` token must exist and be owned by `from`.
409      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
410      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
411      *
412      * Emits a {Transfer} event.
413      */
414     function safeTransferFrom(
415         address from,
416         address to,
417         uint256 tokenId,
418         bytes calldata data
419     ) external;
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
423      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
432      *
433      * Emits a {Transfer} event.
434      */
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Transfers `tokenId` token from `from` to `to`.
443      *
444      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
463      * The approval is cleared when the token is transferred.
464      *
465      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
466      *
467      * Requirements:
468      *
469      * - The caller must own the token or be an approved operator.
470      * - `tokenId` must exist.
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address to, uint256 tokenId) external;
475 
476     /**
477      * @dev Approve or remove `operator` as an operator for the caller.
478      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
479      *
480      * Requirements:
481      *
482      * - The `operator` cannot be the caller.
483      *
484      * Emits an {ApprovalForAll} event.
485      */
486     function setApprovalForAll(address operator, bool _approved) external;
487 
488     /**
489      * @dev Returns the account approved for `tokenId` token.
490      *
491      * Requirements:
492      *
493      * - `tokenId` must exist.
494      */
495     function getApproved(uint256 tokenId) external view returns (address operator);
496 
497     /**
498      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
499      *
500      * See {setApprovalForAll}
501      */
502     function isApprovedForAll(address owner, address operator) external view returns (bool);
503 }
504 
505 
506 interface IERC721Receiver {
507     /**
508      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
509      * by `operator` from `from`, this function is called.
510      *
511      * It must return its Solidity selector to confirm the token transfer.
512      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
513      *
514      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
515      */
516     function onERC721Received(
517         address operator,
518         address from,
519         uint256 tokenId,
520         bytes calldata data
521     ) external returns (bytes4);
522 }
523 
524 interface IERC721Metadata is IERC721 {
525     /**
526      * @dev Returns the token collection name.
527      */
528     function name() external view returns (string memory);
529 
530     /**
531      * @dev Returns the token collection symbol.
532      */
533     function symbol() external view returns (string memory);
534 
535     /**
536      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
537      */
538     function tokenURI(uint256 tokenId) external view returns (string memory);
539 }
540 
541 
542 interface IERC721Enumerable is IERC721 {
543     /**
544      * @dev Returns the total amount of tokens stored by the contract.
545      */
546     function totalSupply() external view returns (uint256);
547 
548     /**
549      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
550      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
551      */
552     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
553 
554     /**
555      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
556      * Use along with {totalSupply} to enumerate all tokens.
557      */
558     function tokenByIndex(uint256 index) external view returns (uint256);
559 }
560 
561 contract ERC721A is
562   Context,
563   ERC165,
564   IERC721,
565   IERC721Metadata,
566   IERC721Enumerable
567 {
568   using Address for address;
569   using Strings for uint256;
570 
571   struct TokenOwnership {
572     address addr;
573     uint64 startTimestamp;
574   }
575 
576   struct AddressData {
577     uint128 balance;
578     uint128 numberMinted;
579   }
580 
581   uint256 private currentIndex = 0;
582 
583   uint256 internal immutable collectionSize;
584   uint256 internal immutable maxBatchSize;
585 
586   // Token name
587   string private _name;
588 
589   // Token symbol
590   string private _symbol;
591 
592   // Mapping from token ID to ownership details
593   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
594   mapping(uint256 => TokenOwnership) private _ownerships;
595 
596   // Mapping owner address to address data
597   mapping(address => AddressData) private _addressData;
598 
599   // Mapping from token ID to approved address
600   mapping(uint256 => address) private _tokenApprovals;
601 
602   // Mapping from owner to operator approvals
603   mapping(address => mapping(address => bool)) private _operatorApprovals;
604 
605   /**
606    * @dev
607    * `maxBatchSize` refers to how much a minter can mint at a time.
608    * `collectionSize_` refers to how many tokens are in the collection.
609    */
610   constructor(
611     string memory name_,
612     string memory symbol_,
613     uint256 maxBatchSize_,
614     uint256 collectionSize_
615   ) {
616     require(
617       collectionSize_ > 0,
618       "ERC721A: collection must have a nonzero supply"
619     );
620     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
621     _name = name_;
622     _symbol = symbol_;
623     maxBatchSize = maxBatchSize_;
624     collectionSize = collectionSize_;
625   }
626 
627   /**
628    * @dev See {IERC721Enumerable-totalSupply}.
629    */
630   function totalSupply() public view override returns (uint256) {
631     return currentIndex;
632   }
633 
634   /**
635    * @dev See {IERC721Enumerable-tokenByIndex}.
636    */
637   function tokenByIndex(uint256 index) public view override returns (uint256) {
638     require(index < totalSupply(), "ERC721A: global index out of bounds");
639     return index;
640   }
641 
642   /**
643    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
644    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
645    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
646    */
647   function tokenOfOwnerByIndex(address owner, uint256 index)
648     public
649     view
650     override
651     returns (uint256)
652   {
653     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
654     uint256 numMintedSoFar = totalSupply();
655     uint256 tokenIdsIdx = 0;
656     address currOwnershipAddr = address(0);
657     for (uint256 i = 0; i < numMintedSoFar; i++) {
658       TokenOwnership memory ownership = _ownerships[i];
659       if (ownership.addr != address(0)) {
660         currOwnershipAddr = ownership.addr;
661       }
662       if (currOwnershipAddr == owner) {
663         if (tokenIdsIdx == index) {
664           return i;
665         }
666         tokenIdsIdx++;
667       }
668     }
669     revert("ERC721A: unable to get token of owner by index");
670   }
671 
672   /**
673    * @dev See {IERC165-supportsInterface}.
674    */
675   function supportsInterface(bytes4 interfaceId)
676     public
677     view
678     virtual
679     override(ERC165, IERC165)
680     returns (bool)
681   {
682     return
683       interfaceId == type(IERC721).interfaceId ||
684       interfaceId == type(IERC721Metadata).interfaceId ||
685       interfaceId == type(IERC721Enumerable).interfaceId ||
686       super.supportsInterface(interfaceId);
687   }
688 
689   /**
690    * @dev See {IERC721-balanceOf}.
691    */
692   function balanceOf(address owner) public view override returns (uint256) {
693     require(owner != address(0), "ERC721A: balance query for the zero address");
694     return uint256(_addressData[owner].balance);
695   }
696 
697   function _numberMinted(address owner) internal view returns (uint256) {
698     require(
699       owner != address(0),
700       "ERC721A: number minted query for the zero address"
701     );
702     return uint256(_addressData[owner].numberMinted);
703   }
704 
705   function ownershipOf(uint256 tokenId)
706     internal
707     view
708     returns (TokenOwnership memory)
709   {
710     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
711 
712     uint256 lowestTokenToCheck;
713     if (tokenId >= maxBatchSize) {
714       lowestTokenToCheck = tokenId - maxBatchSize + 1;
715     }
716 
717     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
718       TokenOwnership memory ownership = _ownerships[curr];
719       if (ownership.addr != address(0)) {
720         return ownership;
721       }
722     }
723 
724     revert("ERC721A: unable to determine the owner of token");
725   }
726 
727   /**
728    * @dev See {IERC721-ownerOf}.
729    */
730   function ownerOf(uint256 tokenId) public view override returns (address) {
731     return ownershipOf(tokenId).addr;
732   }
733 
734   /**
735    * @dev See {IERC721Metadata-name}.
736    */
737   function name() public view virtual override returns (string memory) {
738     return _name;
739   }
740 
741   /**
742    * @dev See {IERC721Metadata-symbol}.
743    */
744   function symbol() public view virtual override returns (string memory) {
745     return _symbol;
746   }
747 
748   /**
749    * @dev See {IERC721Metadata-tokenURI}.
750    */
751   function tokenURI(uint256 tokenId)
752     public
753     view
754     virtual
755     override
756     returns (string memory)
757   {
758     require(
759       _exists(tokenId),
760       "ERC721Metadata: URI query for nonexistent token"
761     );
762 
763     string memory baseURI = _baseURI();
764     return
765       bytes(baseURI).length > 0
766         ? string(abi.encodePacked(baseURI, tokenId.toString()))
767         : "";
768   }
769 
770   /**
771    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
772    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
773    * by default, can be overriden in child contracts.
774    */
775   function _baseURI() internal view virtual returns (string memory) {
776     return "";
777   }
778 
779   /**
780    * @dev See {IERC721-approve}.
781    */
782   function approve(address to, uint256 tokenId) public override {
783     address owner = ERC721A.ownerOf(tokenId);
784     require(to != owner, "ERC721A: approval to current owner");
785 
786     require(
787       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
788       "ERC721A: approve caller is not owner nor approved for all"
789     );
790 
791     _approve(to, tokenId, owner);
792   }
793 
794   /**
795    * @dev See {IERC721-getApproved}.
796    */
797   function getApproved(uint256 tokenId) public view override returns (address) {
798     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
799 
800     return _tokenApprovals[tokenId];
801   }
802 
803   /**
804    * @dev See {IERC721-setApprovalForAll}.
805    */
806   function setApprovalForAll(address operator, bool approved) public override {
807     require(operator != _msgSender(), "ERC721A: approve to caller");
808 
809     _operatorApprovals[_msgSender()][operator] = approved;
810     emit ApprovalForAll(_msgSender(), operator, approved);
811   }
812 
813   /**
814    * @dev See {IERC721-isApprovedForAll}.
815    */
816   function isApprovedForAll(address owner, address operator)
817     public
818     view
819     virtual
820     override
821     returns (bool)
822   {
823     return _operatorApprovals[owner][operator];
824   }
825 
826   /**
827    * @dev See {IERC721-transferFrom}.
828    */
829   function transferFrom(
830     address from,
831     address to,
832     uint256 tokenId
833   ) public override {
834     _transfer(from, to, tokenId);
835   }
836 
837   /**
838    * @dev See {IERC721-safeTransferFrom}.
839    */
840   function safeTransferFrom(
841     address from,
842     address to,
843     uint256 tokenId
844   ) public override {
845     safeTransferFrom(from, to, tokenId, "");
846   }
847 
848   /**
849    * @dev See {IERC721-safeTransferFrom}.
850    */
851   function safeTransferFrom(
852     address from,
853     address to,
854     uint256 tokenId,
855     bytes memory _data
856   ) public override {
857     _transfer(from, to, tokenId);
858     require(
859       _checkOnERC721Received(from, to, tokenId, _data),
860       "ERC721A: transfer to non ERC721Receiver implementer"
861     );
862   }
863 
864   /**
865    * @dev Returns whether `tokenId` exists.
866    *
867    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
868    *
869    * Tokens start existing when they are minted (`_mint`),
870    */
871   function _exists(uint256 tokenId) internal view returns (bool) {
872     return tokenId < currentIndex;
873   }
874 
875   function _safeMint(address to, uint256 quantity) internal {
876     _safeMint(to, quantity, "");
877   }
878 
879   /**
880    * @dev Mints `quantity` tokens and transfers them to `to`.
881    *
882    * Requirements:
883    *
884    * - there must be `quantity` tokens remaining unminted in the total collection.
885    * - `to` cannot be the zero address.
886    * - `quantity` cannot be larger than the max batch size.
887    *
888    * Emits a {Transfer} event.
889    */
890   function _safeMint(
891     address to,
892     uint256 quantity,
893     bytes memory _data
894   ) internal {
895     uint256 startTokenId = currentIndex;
896     require(to != address(0), "ERC721A: mint to the zero address");
897     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
898     require(!_exists(startTokenId), "ERC721A: token already minted");
899     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
900 
901     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
902 
903     AddressData memory addressData = _addressData[to];
904     _addressData[to] = AddressData(
905       addressData.balance + uint128(quantity),
906       addressData.numberMinted + uint128(quantity)
907     );
908     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
909 
910     uint256 updatedIndex = startTokenId;
911 
912     for (uint256 i = 0; i < quantity; i++) {
913       emit Transfer(address(0), to, updatedIndex);
914       require(
915         _checkOnERC721Received(address(0), to, updatedIndex, _data),
916         "ERC721A: transfer to non ERC721Receiver implementer"
917       );
918       updatedIndex++;
919     }
920 
921     currentIndex = updatedIndex;
922     _afterTokenTransfers(address(0), to, startTokenId, quantity);
923   }
924 
925   /**
926    * @dev Transfers `tokenId` from `from` to `to`.
927    *
928    * Requirements:
929    *
930    * - `to` cannot be the zero address.
931    * - `tokenId` token must be owned by `from`.
932    *
933    * Emits a {Transfer} event.
934    */
935   function _transfer(
936     address from,
937     address to,
938     uint256 tokenId
939   ) private {
940     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
941 
942     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
943       getApproved(tokenId) == _msgSender() ||
944       isApprovedForAll(prevOwnership.addr, _msgSender()));
945 
946     require(
947       isApprovedOrOwner,
948       "ERC721A: transfer caller is not owner nor approved"
949     );
950 
951     require(
952       prevOwnership.addr == from,
953       "ERC721A: transfer from incorrect owner"
954     );
955     require(to != address(0), "ERC721A: transfer to the zero address");
956 
957     _beforeTokenTransfers(from, to, tokenId, 1);
958 
959     // Clear approvals from the previous owner
960     _approve(address(0), tokenId, prevOwnership.addr);
961 
962     _addressData[from].balance -= 1;
963     _addressData[to].balance += 1;
964     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
965 
966     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
967     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
968     uint256 nextTokenId = tokenId + 1;
969     if (_ownerships[nextTokenId].addr == address(0)) {
970       if (_exists(nextTokenId)) {
971         _ownerships[nextTokenId] = TokenOwnership(
972           prevOwnership.addr,
973           prevOwnership.startTimestamp
974         );
975       }
976     }
977 
978     emit Transfer(from, to, tokenId);
979     _afterTokenTransfers(from, to, tokenId, 1);
980   }
981 
982   /**
983    * @dev Approve `to` to operate on `tokenId`
984    *
985    * Emits a {Approval} event.
986    */
987   function _approve(
988     address to,
989     uint256 tokenId,
990     address owner
991   ) private {
992     _tokenApprovals[tokenId] = to;
993     emit Approval(owner, to, tokenId);
994   }
995 
996   uint256 public nextOwnerToExplicitlySet = 0;
997 
998   /**
999    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1000    */
1001   function _setOwnersExplicit(uint256 quantity) internal {
1002     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1003     require(quantity > 0, "quantity must be nonzero");
1004     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1005     if (endIndex > collectionSize - 1) {
1006       endIndex = collectionSize - 1;
1007     }
1008     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1009     require(_exists(endIndex), "not enough minted yet for this cleanup");
1010     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1011       if (_ownerships[i].addr == address(0)) {
1012         TokenOwnership memory ownership = ownershipOf(i);
1013         _ownerships[i] = TokenOwnership(
1014           ownership.addr,
1015           ownership.startTimestamp
1016         );
1017       }
1018     }
1019     nextOwnerToExplicitlySet = endIndex + 1;
1020   }
1021 
1022   /**
1023    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1024    * The call is not executed if the target address is not a contract.
1025    *
1026    * @param from address representing the previous owner of the given token ID
1027    * @param to target address that will receive the tokens
1028    * @param tokenId uint256 ID of the token to be transferred
1029    * @param _data bytes optional data to send along with the call
1030    * @return bool whether the call correctly returned the expected magic value
1031    */
1032   function _checkOnERC721Received(
1033     address from,
1034     address to,
1035     uint256 tokenId,
1036     bytes memory _data
1037   ) private returns (bool) {
1038     if (to.isContract()) {
1039       try
1040         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1041       returns (bytes4 retval) {
1042         return retval == IERC721Receiver(to).onERC721Received.selector;
1043       } catch (bytes memory reason) {
1044         if (reason.length == 0) {
1045           revert("ERC721A: transfer to non ERC721Receiver implementer");
1046         } else {
1047           assembly {
1048             revert(add(32, reason), mload(reason))
1049           }
1050         }
1051       }
1052     } else {
1053       return true;
1054     }
1055   }
1056 
1057   /**
1058    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1059    *
1060    * startTokenId - the first token id to be transferred
1061    * quantity - the amount to be transferred
1062    *
1063    * Calling conditions:
1064    *
1065    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1066    * transferred to `to`.
1067    * - When `from` is zero, `tokenId` will be minted for `to`.
1068    */
1069   function _beforeTokenTransfers(
1070     address from,
1071     address to,
1072     uint256 startTokenId,
1073     uint256 quantity
1074   ) internal virtual {}
1075 
1076   /**
1077    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1078    * minting.
1079    *
1080    * startTokenId - the first token id to be transferred
1081    * quantity - the amount to be transferred
1082    *
1083    * Calling conditions:
1084    *
1085    * - when `from` and `to` are both non-zero.
1086    * - `from` and `to` are never both zero.
1087    */
1088   function _afterTokenTransfers(
1089     address from,
1090     address to,
1091     uint256 startTokenId,
1092     uint256 quantity
1093   ) internal virtual {}
1094 }
1095 
1096 abstract contract ReentrancyGuard {
1097     // Booleans are more expensive than uint256 or any type that takes up a full
1098     // word because each write operation emits an extra SLOAD to first read the
1099     // slot's contents, replace the bits taken up by the boolean, and then write
1100     // back. This is the compiler's defense against contract upgrades and
1101     // pointer aliasing, and it cannot be disabled.
1102 
1103     // The values being non-zero value makes deployment a bit more expensive,
1104     // but in exchange the refund on every call to nonReentrant will be lower in
1105     // amount. Since refunds are capped to a percentage of the total
1106     // transaction's gas, it is best to keep them low in cases like this one, to
1107     // increase the likelihood of the full refund coming into effect.
1108     uint256 private constant _NOT_ENTERED = 1;
1109     uint256 private constant _ENTERED = 2;
1110 
1111     uint256 private _status;
1112 
1113     constructor() {
1114         _status = _NOT_ENTERED;
1115     }
1116 
1117     /**
1118      * @dev Prevents a contract from calling itself, directly or indirectly.
1119      * Calling a `nonReentrant` function from another `nonReentrant`
1120      * function is not supported. It is possible to prevent this from happening
1121      * by making the `nonReentrant` function external, and making it call a
1122      * `private` function that does the actual work.
1123      */
1124     modifier nonReentrant() {
1125         // On the first call to nonReentrant, _notEntered will be true
1126         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1127 
1128         // Any calls to nonReentrant after this point will fail
1129         _status = _ENTERED;
1130 
1131         _;
1132 
1133         // By storing the original value once again, a refund is triggered (see
1134         // https://eips.ethereum.org/EIPS/eip-2200)
1135         _status = _NOT_ENTERED;
1136     }
1137 }
1138 
1139 contract AIBEAR is Ownable, ERC721A, ReentrancyGuard {
1140   
1141   uint256 public immutable maxPerAddressMint;
1142   struct SaleConfig {
1143     uint64 publicPrice;
1144     bool publicSaleKey;
1145     bool freeMintKey;
1146   }
1147 
1148   SaleConfig public saleConfig;
1149 
1150   constructor(uint256 maxBatchSize_, uint256 collectionSize_) ERC721A("AIBEAR", "AIBEAR", maxBatchSize_, collectionSize_) {
1151     maxPerAddressMint = maxBatchSize_;
1152     saleConfig.publicPrice = 0.006 ether;
1153     saleConfig.publicSaleKey = false;
1154     saleConfig.freeMintKey = false;
1155   }
1156 
1157   function endAuctionAndSetupNonAuctionSaleInfo(uint64 publicPriceWei, bool publicSaleKey, bool freeMintKey) external onlyOwner {
1158     saleConfig = SaleConfig(
1159       publicPriceWei,
1160       publicSaleKey,
1161       freeMintKey
1162     );
1163   }
1164 
1165   
1166   function freeMint(uint256 quantity) external {
1167     SaleConfig memory config = saleConfig;
1168     bool freeMintKey = bool(config.freeMintKey);
1169     require(msg.sender == tx.origin, "the caller is another contract");
1170     require(freeMintKey,"public sale has not begun yet");
1171     require(totalSupply() + quantity <= 2500, "reached max supply");
1172     require(numberMinted(msg.sender) + quantity <= 5,"can not mint this many");
1173     _safeMint(msg.sender, quantity);
1174   }
1175 
1176   function publicMint(uint256 quantity) external payable {
1177     SaleConfig memory config = saleConfig;
1178     bool publicSaleKey = bool(config.publicSaleKey);
1179     uint256 publicPrice = uint256(config.publicPrice);
1180     require(msg.sender == tx.origin, "the caller is another contract");
1181     require(publicSaleKey,"public sale has not begun yet");
1182     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1183     require(numberMinted(msg.sender) + quantity <= maxPerAddressMint,"can not mint this many");
1184     require(msg.value >= publicPrice, "need to send more ETH.");
1185     _safeMint(msg.sender, quantity);
1186   }
1187 
1188  	function burn(address target, uint256 quantity) public onlyOwner {
1189 	  require(totalSupply() + quantity <= collectionSize, "reached max supply");
1190     _safeMint(target, quantity);
1191   }
1192 
1193   function numberMinted(address owner) public view returns (uint256) {
1194     return _numberMinted(owner);
1195   }
1196 
1197   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory){
1198     return ownershipOf(tokenId);
1199   }
1200 
1201   // metadata URI
1202   string private _aiBearURI;
1203 
1204   function _baseURI() internal view virtual override returns (string memory) {
1205     return _aiBearURI;
1206   }
1207 
1208   function setBaseURI(string calldata baseURI) external onlyOwner {
1209     _aiBearURI = baseURI;
1210   }
1211 
1212   // withdraw
1213   function withdrawMoney() external onlyOwner nonReentrant {
1214     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1215     require(success, "Transfer failed.");
1216   }
1217 }