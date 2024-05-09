1 // File: contracts/api/BuilderMasterAPI.sol
2 
3 abstract contract BuilderMasterAPI {
4    function getContractId(uint tokenId) public view virtual returns (uint);
5    function getNiftyTypeId(uint tokenId) public view virtual returns (uint);
6    function getSpecificNiftyNum(uint tokenId) public view virtual returns (uint);
7    function encodeTokenId(uint contractId, uint niftyType, uint specificNiftyNum) public view virtual returns (uint);
8    function strConcat(string memory _a, string memory _b) public view virtual returns (string memory);
9    function uint2str(uint _i) public view virtual returns (string memory _uintAsString);
10 }
11 
12 // File: contracts/interface/IERC165.sol
13 
14 /**
15  * @title IERC165
16  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
17  */
18 interface IERC165 {
19 
20   /**
21    * @notice Query if a contract implements an interface
22    * @param interfaceId The interface identifier, as specified in ERC-165
23    * @dev Interface identification is specified in ERC-165. This function
24    * uses less than 30,000 gas.
25    */
26   function supportsInterface(bytes4 interfaceId)
27     external
28     view
29     returns (bool);
30 }
31 
32 // File: contracts/interface/IERC721.sol
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52 
53     /**
54      * @dev Returns the number of tokens in ``owner``'s account.
55      */
56     function balanceOf(address owner) external view returns (uint256 balance);
57 
58     /**
59      * @dev Returns the owner of the `tokenId` token.
60      *
61      * Requirements:
62      *
63      * - `tokenId` must exist.
64      */
65     function ownerOf(uint256 tokenId) external view returns (address owner);
66 
67     /**
68      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
69      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(address from, address to, uint256 tokenId) external;
82 
83     /**
84      * @dev Transfers `tokenId` token from `from` to `to`.
85      *
86      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must be owned by `from`.
93      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address from, address to, uint256 tokenId) external;
98 
99     /**
100      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
101      * The approval is cleared when the token is transferred.
102      *
103      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
104      *
105      * Requirements:
106      *
107      * - The caller must own the token or be an approved operator.
108      * - `tokenId` must exist.
109      *
110      * Emits an {Approval} event.
111      */
112     function approve(address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Returns the account approved for `tokenId` token.
116      *
117      * Requirements:
118      *
119      * - `tokenId` must exist.
120      */
121     function getApproved(uint256 tokenId) external view returns (address operator);
122 
123     /**
124      * @dev Approve or remove `operator` as an operator for the caller.
125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
126      *
127      * Requirements:
128      *
129      * - The `operator` cannot be the caller.
130      *
131      * Emits an {ApprovalForAll} event.
132      */
133     function setApprovalForAll(address operator, bool _approved) external;
134 
135     /**
136      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
137      *
138      * See {setApprovalForAll}
139      */
140     function isApprovedForAll(address owner, address operator) external view returns (bool);
141 
142     /**
143       * @dev Safely transfers `tokenId` token from `from` to `to`.
144       *
145       * Requirements:
146       *
147       * - `from` cannot be the zero address.
148       * - `to` cannot be the zero address.
149       * - `tokenId` token must exist and be owned by `from`.
150       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152       *
153       * Emits a {Transfer} event.
154       */
155     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
156 }
157 
158 // File: contracts/interface/IERC721Receiver.sol
159 
160 /**
161  * @title ERC721 token receiver interface
162  * @dev Interface for any contract that wants to support safeTransfers
163  * from ERC721 asset contracts.
164  */
165 interface IERC721Receiver {
166     /**
167      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
168      * by `operator` from `from`, this function is called.
169      *
170      * It must return its Solidity selector to confirm the token transfer.
171      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
172      *
173      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
174      */
175     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
176 }
177 
178 // File: contracts/interface/IERC721Metadata.sol
179 
180 /**
181  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
182  * @dev See https://eips.ethereum.org/EIPS/eip-721
183  */
184 interface IERC721Metadata is IERC721 {
185 
186     /**
187      * @dev Returns the token collection name.
188      */
189     function name() external view returns (string memory);
190 
191     /**
192      * @dev Returns the token collection symbol.
193      */
194     function symbol() external view returns (string memory);
195 
196     /**
197      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
198      */
199     function tokenURI(uint256 tokenId) external view returns (string memory);
200 }
201 
202 // File: contracts/util/Address.sol
203 
204 /**
205  * @dev Collection of functions related to the address type
206  */
207 library Address {
208     /**
209      * @dev Returns true if `account` is a contract.
210      *
211      * [IMPORTANT]
212      * ====
213      * It is unsafe to assume that an address for which this function returns
214      * false is an externally-owned account (EOA) and not a contract.
215      *
216      * Among others, `isContract` will return false for the following
217      * types of addresses:
218      *
219      *  - an externally-owned account
220      *  - a contract in construction
221      *  - an address where a contract will be created
222      *  - an address where a contract lived, but was destroyed
223      * ====
224      */
225     function isContract(address account) internal view returns (bool) {
226         // This method relies on extcodesize, which returns 0 for contracts in
227         // construction, since the code is only stored at the end of the
228         // constructor execution.
229 
230         uint256 size;
231         // solhint-disable-next-line no-inline-assembly
232         assembly { size := extcodesize(account) }
233         return size > 0;
234     }
235 
236     /**
237      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
238      * `recipient`, forwarding all available gas and reverting on errors.
239      *
240      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
241      * of certain opcodes, possibly making contracts go over the 2300 gas limit
242      * imposed by `transfer`, making them unable to receive funds via
243      * `transfer`. {sendValue} removes this limitation.
244      *
245      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
246      *
247      * IMPORTANT: because control is transferred to `recipient`, care must be
248      * taken to not create reentrancy vulnerabilities. Consider using
249      * {ReentrancyGuard} or the
250      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
251      */
252     function sendValue(address payable recipient, uint256 amount) internal {
253         require(address(this).balance >= amount, "Address: insufficient balance");
254 
255         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
256         (bool success, ) = recipient.call{ value: amount }("");
257         require(success, "Address: unable to send value, recipient may have reverted");
258     }
259 
260     /**
261      * @dev Performs a Solidity function call using a low level `call`. A
262      * plain`call` is an unsafe replacement for a function call: use this
263      * function instead.
264      *
265      * If `target` reverts with a revert reason, it is bubbled up by this
266      * function (like regular Solidity function calls).
267      *
268      * Returns the raw returned data. To convert to the expected return value,
269      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
270      *
271      * Requirements:
272      *
273      * - `target` must be a contract.
274      * - calling `target` with `data` must not revert.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
279       return functionCall(target, data, "Address: low-level call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
284      * `errorMessage` as a fallback revert reason when `target` reverts.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
289         return functionCallWithValue(target, data, 0, errorMessage);
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
294      * but also transferring `value` wei to `target`.
295      *
296      * Requirements:
297      *
298      * - the calling contract must have an ETH balance of at least `value`.
299      * - the called Solidity function must be `payable`.
300      *
301      * _Available since v3.1._
302      */
303     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
304         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
309      * with `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
314         require(address(this).balance >= value, "Address: insufficient balance for call");
315         require(isContract(target), "Address: call to non-contract");
316 
317         // solhint-disable-next-line avoid-low-level-calls
318         (bool success, bytes memory returndata) = target.call{ value: value }(data);
319         return _verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
329         return functionStaticCall(target, data, "Address: low-level static call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
339         require(isContract(target), "Address: static call to non-contract");
340 
341         // solhint-disable-next-line avoid-low-level-calls
342         (bool success, bytes memory returndata) = target.staticcall(data);
343         return _verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but performing a delegate call.
349      *
350      * _Available since v3.4._
351      */
352     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
363         require(isContract(target), "Address: delegate call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.delegatecall(data);
367         return _verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 // solhint-disable-next-line no-inline-assembly
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 // File: contracts/util/Context.sol
391 
392 /*
393  * @dev Provides information about the current execution context, including the
394  * sender of the transaction and its data. While these are generally available
395  * via msg.sender and msg.data, they should not be accessed in such a direct
396  * manner, since when dealing with meta-transactions the account sending and
397  * paying for execution may not be the actual sender (as far as an application
398  * is concerned).
399  *
400  * This contract is only required for intermediate, library-like contracts.
401  */
402 abstract contract Context {
403     function _msgSender() internal view virtual returns (address) {
404         return msg.sender;
405     }
406 
407     function _msgData() internal view virtual returns (bytes calldata) {
408         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
409         return msg.data;
410     }
411 }
412 
413 // File: contracts/util/Strings.sol
414 
415 /**
416  * @dev String operations.
417  */
418 library Strings {
419     bytes16 private constant alphabet = "0123456789abcdef";
420 
421     /**
422      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
423      */
424     function toString(uint256 value) internal pure returns (string memory) {
425         // Inspired by OraclizeAPI's implementation - MIT licence
426         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
427 
428         if (value == 0) {
429             return "0";
430         }
431         uint256 temp = value;
432         uint256 digits;
433         while (temp != 0) {
434             digits++;
435             temp /= 10;
436         }
437         bytes memory buffer = new bytes(digits);
438         while (value != 0) {
439             digits -= 1;
440             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
441             value /= 10;
442         }
443         return string(buffer);
444     }
445 
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
448      */
449     function toHexString(uint256 value) internal pure returns (string memory) {
450         if (value == 0) {
451             return "0x00";
452         }
453         uint256 temp = value;
454         uint256 length = 0;
455         while (temp != 0) {
456             length++;
457             temp >>= 8;
458         }
459         return toHexString(value, length);
460     }
461 
462     /**
463      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
464      */
465     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
466         bytes memory buffer = new bytes(2 * length + 2);
467         buffer[0] = "0";
468         buffer[1] = "x";
469         for (uint256 i = 2 * length + 1; i > 1; --i) {
470             buffer[i] = alphabet[value & 0xf];
471             value >>= 4;
472         }
473         require(value == 0, "Strings: hex length insufficient");
474         return string(buffer);
475     }
476 
477 }
478 
479 // File: contracts/ERC165.sol
480 
481 /**
482  * @dev Implementation of the {IERC165} interface.
483  *
484  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
485  * for the additional interface id that will be supported. For example:
486  *
487  * ```solidity
488  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
490  * }
491  * ```
492  *
493  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
494  */
495 abstract contract ERC165 is IERC165 {
496     /**
497      * @dev See {IERC165-supportsInterface}.
498      */
499     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
500         return interfaceId == type(IERC165).interfaceId;
501     }
502 }
503 
504 // File: contracts/api/NiftyRegistryAPI.sol
505 
506 abstract contract NiftyRegistryAPI {
507    function isValidNiftySender(address sending_key) public view virtual returns (bool);
508    function isOwner(address owner_key) public view virtual returns (bool);
509 }
510 
511 // File: contracts/NiftyEntity.sol
512 
513 contract NiftyEntity {
514    
515     // 0xCA9fC51835DBB525BB6E6ebfcc67b8bE1b08BDfA
516     address public immutable masterBuilderContract;
517    
518     // 0x33F8cb717384A96C2a5de7964d0c7c1a10777660
519     address immutable niftyRegistryContract;
520    
521     modifier onlyValidSender() {
522         NiftyRegistryAPI nftg_registry = NiftyRegistryAPI(niftyRegistryContract);
523         bool is_valid = nftg_registry.isValidNiftySender(msg.sender);
524         require(is_valid, "NiftyEntity: Invalid msg.sender");
525         _;
526     }
527 
528     constructor(address _masterBuilderContract, address _niftyRegistryContract) {
529         masterBuilderContract = _masterBuilderContract;
530         niftyRegistryContract = _niftyRegistryContract;
531     }
532 }
533 
534 // File: contracts/ERC721.sol
535 
536 /**
537  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
538  * the Metadata extension, but not including the Enumerable extension, which is available separately as
539  * {ERC721Enumerable}.
540  */
541 contract ERC721 is NiftyEntity, Context, ERC165, IERC721, IERC721Metadata {
542     using Address for address;
543     using Strings for uint256;
544 
545     // Token name
546     string private _name;
547 
548     // Token symbol
549     string private _symbol;
550 
551     // Optional mapping for token URIs
552     mapping(uint256 => string) private _tokenURIs;
553 
554     //Optional mapping for IPFS link to canonical image file
555     mapping(uint256 => string) private _tokenIPFSHashes;
556 
557     mapping(uint256 => string) private _niftyTypeName;
558 
559     // Optional mapping for IPFS link to canonical image file by  Nifty type 
560     mapping(uint256 => string) private _niftyTypeIPFSHashes;
561 
562     mapping(uint256 => string) private _tokenName;
563 
564     // Mapping from token ID to owner address
565     mapping (uint256 => address) private _owners;
566 
567     // Mapping owner address to token count
568     mapping (address => uint256) private _balances;
569 
570     // Mapping from token ID to approved address
571     mapping (uint256 => address) private _tokenApprovals;
572 
573     // Mapping from owner to operator approvals
574     mapping (address => mapping (address => bool)) private _operatorApprovals;
575 
576     /**
577      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
578      */
579     constructor (string memory name_, 
580                  string memory symbol_, 
581                  address masterBuilderContract_, 
582                  address niftyRegistryContract_) NiftyEntity(masterBuilderContract_, niftyRegistryContract_) {
583         _name = name_;
584         _symbol = symbol_;
585     }
586 
587     /**
588      * @dev See {IERC165-supportsInterface}.
589      */
590     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
591         return interfaceId == type(IERC721).interfaceId
592             || interfaceId == type(IERC721Metadata).interfaceId
593             || super.supportsInterface(interfaceId);
594     }
595 
596     /**
597      * @dev See {IERC721-balanceOf}.
598      */
599     function balanceOf(address owner) public view virtual override returns (uint256) {
600         require(owner != address(0), "ERC721: balance query for the zero address");
601         return _balances[owner];
602     }
603 
604     /**
605      * @dev See {IERC721-ownerOf}.
606      */
607     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
608         address owner = _owners[tokenId];
609         require(owner != address(0), "ERC721: owner query for nonexistent token");
610         return owner;
611     }
612 
613     /**
614      * @dev See {IERC721Metadata-name}.
615      */
616     function name() public view virtual override returns (string memory) {
617         return _name;
618     }
619 
620     /**
621      * @dev See {IERC721Metadata-symbol}.
622      */
623     function symbol() public view virtual override returns (string memory) {
624         return _symbol;
625     }
626 
627     /**
628      * @dev Returns an URI for a given token ID.
629      * Throws if the token ID does not exist. May return an empty string.
630      * @param tokenId uint256 ID of the token to query
631      */
632     function tokenURI(uint256 tokenId) external view override returns (string memory) {
633         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
634         BuilderMasterAPI bm = BuilderMasterAPI(masterBuilderContract);
635         string memory tokenIdStr = Strings.toString(tokenId);
636         string memory tokenURIStr = bm.strConcat(_baseURI(), tokenIdStr);
637         return tokenURIStr;
638     }
639 
640     /**
641      * @dev Returns an IPFS hash for a given token ID.
642      * Throws if the token ID does not exist. May return an empty string.
643      * @param tokenId uint256 ID of the token to query
644      */
645     function tokenIPFSHash(uint256 tokenId) external view virtual returns (string memory) {}
646 
647     /**
648      * @dev Returns the Name for a given token ID.
649      * Throws if the token ID does not exist. May return an empty string.
650      * @param tokenId uint256 ID of the token to query
651      */
652     function tokenName(uint256 tokenId) external view returns (string memory) {
653         require(_exists(tokenId), "ERC721Metadata: Name query for nonexistent token");
654         BuilderMasterAPI bm = BuilderMasterAPI(masterBuilderContract);
655         uint nifty_type = bm.getNiftyTypeId(tokenId);
656         return _niftyTypeName[nifty_type];
657     }
658 
659     /**
660      * @dev Internal function to set the token URI for a given token.
661      * Reverts if the token ID does not exist.
662      * @param tokenId uint256 ID of the token to set its URI
663      * @param uri string URI to assign
664      */
665     function _setTokenURI(uint256 tokenId, string memory uri) internal {
666         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
667         _tokenURIs[tokenId] = uri;
668     }
669    
670     /**
671      * @dev Internal function to set the token IPFS hash for a nifty type.
672      * @param nifty_type uint256 ID component of the token to set its IPFS hash
673      * @param ipfs_hash string IPFS link to assign
674      */
675     function _setTokenIPFSHashNiftyType(uint256 nifty_type, string memory ipfs_hash) internal {
676         require(bytes(_niftyTypeIPFSHashes[nifty_type]).length == 0, "ERC721Metadata: IPFS hash already set");
677         _niftyTypeIPFSHashes[nifty_type] = ipfs_hash;
678     }
679 
680     /**
681      * @dev Internal function to set the name for a nifty type.
682      * @param nifty_type uint256 of nifty type name to be set
683      * @param nifty_type_name name of nifty type
684      */
685     function _setNiftyTypeName(uint256 nifty_type, string memory nifty_type_name) internal {
686         _niftyTypeName[nifty_type] = nifty_type_name;
687     }
688 
689     /**
690      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
691      * in child contracts.
692      */
693     function _baseURI() internal view virtual returns (string memory) {}
694 
695     /**
696      * @dev See {IERC721-approve}.
697      */
698     function approve(address to, uint256 tokenId) public virtual override {
699         address owner = ERC721.ownerOf(tokenId);
700         require(to != owner, "ERC721: approval to current owner");
701 
702         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
703             "ERC721: approve caller is not owner nor approved for all"
704         );
705 
706         _approve(to, tokenId);
707     }
708 
709     /**
710      * @dev See {IERC721-getApproved}.
711      */
712     function getApproved(uint256 tokenId) public view virtual override returns (address) {
713         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
714 
715         return _tokenApprovals[tokenId];
716     }
717 
718     /**
719      * @dev See {IERC721-setApprovalForAll}.
720      */
721     function setApprovalForAll(address operator, bool approved) public virtual override {
722         require(operator != _msgSender(), "ERC721: approve to caller");
723 
724         _operatorApprovals[_msgSender()][operator] = approved;
725         emit ApprovalForAll(_msgSender(), operator, approved);
726     }
727 
728     /**
729      * @dev See {IERC721-isApprovedForAll}.
730      */
731     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
732         return _operatorApprovals[owner][operator];
733     }
734 
735     /**
736      * @dev See {IERC721-transferFrom}.
737      */
738     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
739         //solhint-disable-next-line max-line-length
740         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
741 
742         _transfer(from, to, tokenId);
743     }
744 
745     /**
746      * @dev See {IERC721-safeTransferFrom}.
747      */
748     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
749         safeTransferFrom(from, to, tokenId, "");
750     }
751 
752     /**
753      * @dev See {IERC721-safeTransferFrom}.
754      */
755     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
756         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
757         _safeTransfer(from, to, tokenId, _data);
758     }
759 
760     /**
761      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
762      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
763      *
764      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
765      *
766      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
767      * implement alternative mechanisms to perform token transfer, such as signature-based.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
779         _transfer(from, to, tokenId);
780         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
781     }
782 
783     /**
784      * @dev Returns whether `tokenId` exists.
785      *
786      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
787      *
788      * Tokens start existing when they are minted (`_mint`),
789      * and stop existing when they are burned (`_burn`).
790      */
791     function _exists(uint256 tokenId) internal view virtual returns (bool) {
792         return _owners[tokenId] != address(0);
793     }
794 
795     /**
796      * @dev Returns whether `spender` is allowed to manage `tokenId`.
797      *
798      * Requirements:
799      *
800      * - `tokenId` must exist.
801      */
802     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
803         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
804         address owner = ERC721.ownerOf(tokenId);
805         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
806     }
807 
808     /**
809      * @dev Safely mints `tokenId` and transfers it to `to`.
810      *
811      * Requirements:
812      *
813      * - `tokenId` must not exist.
814      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _safeMint(address to, uint256 tokenId) internal virtual {
819         _safeMint(to, tokenId, "");
820     }
821 
822     /**
823      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
824      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
825      */
826     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
827         _mint(to, tokenId);
828         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
829     }
830 
831     /**
832      * @dev Mints `tokenId` and transfers it to `to`.
833      *
834      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
835      *
836      * Requirements:
837      *
838      * - `tokenId` must not exist.
839      * - `to` cannot be the zero address.
840      *
841      * Emits a {Transfer} event.
842      */
843     function _mint(address to, uint256 tokenId) internal virtual {
844         require(to != address(0), "ERC721: mint to the zero address");
845         require(!_exists(tokenId), "ERC721: token already minted");
846 
847         _beforeTokenTransfer(address(0), to, tokenId);
848 
849         _balances[to] += 1;
850         _owners[tokenId] = to;
851 
852         emit Transfer(address(0), to, tokenId);
853     }
854 
855     /**
856      * @dev Destroys `tokenId`.
857      * The approval is cleared when the token is burned.
858      *
859      * Requirements:
860      *
861      * - `tokenId` must exist.
862      *
863      * Emits a {Transfer} event.
864      */
865     function _burn(uint256 tokenId) internal virtual {
866         address owner = ERC721.ownerOf(tokenId);
867 
868         _beforeTokenTransfer(owner, address(0), tokenId);
869 
870         // Clear approvals
871         _approve(address(0), tokenId);
872 
873         _balances[owner] -= 1;
874         delete _owners[tokenId];
875 
876         emit Transfer(owner, address(0), tokenId);
877     }
878 
879     /**
880      * @dev Transfers `tokenId` from `from` to `to`.
881      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
882      *
883      * Requirements:
884      *
885      * - `to` cannot be the zero address.
886      * - `tokenId` token must be owned by `from`.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _transfer(address from, address to, uint256 tokenId) internal virtual {
891         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
892         require(to != address(0), "ERC721: transfer to the zero address");
893 
894         _beforeTokenTransfer(from, to, tokenId);
895 
896         // Clear approvals from the previous owner
897         _approve(address(0), tokenId);
898 
899         _balances[from] -= 1;
900         _balances[to] += 1;
901         _owners[tokenId] = to;
902 
903         emit Transfer(from, to, tokenId);
904     }
905 
906     /**
907      * @dev Approve `to` to operate on `tokenId`
908      *
909      * Emits a {Approval} event.
910      */
911     function _approve(address to, uint256 tokenId) internal virtual {
912         _tokenApprovals[tokenId] = to;
913         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
914     }
915 
916     /**
917      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
918      * The call is not executed if the target address is not a contract.
919      *
920      * @param from address representing the previous owner of the given token ID
921      * @param to target address that will receive the tokens
922      * @param tokenId uint256 ID of the token to be transferred
923      * @param _data bytes optional data to send along with the call
924      * @return bool whether the call correctly returned the expected magic value
925      */
926     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
927         private returns (bool)
928     {
929         if (to.isContract()) {
930             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
931                 return retval == IERC721Receiver(to).onERC721Received.selector;
932             } catch (bytes memory reason) {
933                 if (reason.length == 0) {
934                     revert("ERC721: transfer to non ERC721Receiver implementer");
935                 } else {
936                     // solhint-disable-next-line no-inline-assembly
937                     assembly {
938                         revert(add(32, reason), mload(reason))
939                     }
940                 }
941             }
942         } else {
943             return true;
944         }
945     }
946 
947     /**
948      * @dev Hook that is called before any token transfer. This includes minting
949      * and burning.
950      *
951      * Calling conditions:
952      *
953      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
954      * transferred to `to`.
955      * - When `from` is zero, `tokenId` will be minted for `to`.
956      * - When `to` is zero, ``from``'s `tokenId` will be burned.
957      * - `from` and `to` are never both zero.
958      *
959      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
960      */
961     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
962 }
963 
964 // File: contracts/util/Counters.sol
965 
966 /**
967  * @title Counters
968  * @author Matt Condon (@shrugs)
969  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
970  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
971  *
972  * Include with `using Counters for Counters.Counter;`
973  */
974 library Counters {
975     struct Counter {
976         // This variable should never be directly accessed by users of the library: interactions must be restricted to
977         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
978         // this feature: see https://github.com/ethereum/solidity/issues/4637
979         uint256 _value; // default: 0
980     }
981 
982     function current(Counter storage counter) internal view returns (uint256) {
983         return counter._value;
984     }
985 
986     function increment(Counter storage counter) internal {
987         unchecked {
988             counter._value += 1;
989         }
990     }
991 
992     function decrement(Counter storage counter) internal {
993         uint256 value = counter._value;
994         require(value > 0, "Counter: decrement overflow");
995         unchecked {
996             counter._value = value - 1;
997         }
998     }
999 }
1000 
1001 // File: contracts/ERC721Burnable.sol
1002 
1003 /**
1004  * @title ERC721 Burnable Token
1005  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1006  */
1007 abstract contract ERC721Burnable is Context, ERC721 {
1008     /**
1009      * @dev Burns `tokenId`. See {ERC721-_burn}.
1010      *
1011      * Requirements:
1012      *
1013      * - The caller must own `tokenId` or be an approved operator.
1014      */
1015     function burn(uint256 tokenId) public virtual {
1016         //solhint-disable-next-line max-line-length
1017         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1018         _burn(tokenId);
1019     }
1020 }
1021 
1022 // File: contracts/interface/IERC721Enumerable.sol
1023 
1024 /**
1025  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1026  * @dev See https://eips.ethereum.org/EIPS/eip-721
1027  */
1028 interface IERC721Enumerable is IERC721 {
1029 
1030     /**
1031      * @dev Returns the total amount of tokens stored by the contract.
1032      */
1033     function totalSupply() external view returns (uint256);
1034 
1035     /**
1036      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1037      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1038      */
1039     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1040 
1041     /**
1042      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1043      * Use along with {totalSupply} to enumerate all tokens.
1044      */
1045     function tokenByIndex(uint256 index) external view returns (uint256);
1046 }
1047 
1048 // File: contracts/ERC721Enumerable.sol
1049 
1050 /**
1051  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1052  * enumerability of all the token ids in the contract as well as all token ids owned by each
1053  * account.
1054  */
1055 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1056     // Mapping from owner to list of owned token IDs
1057     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1058 
1059     // Mapping from token ID to index of the owner tokens list
1060     mapping(uint256 => uint256) private _ownedTokensIndex;
1061 
1062     // Array with all token ids, used for enumeration
1063     uint256[] private _allTokens;
1064 
1065     // Mapping from token id to position in the allTokens array
1066     mapping(uint256 => uint256) private _allTokensIndex;
1067 
1068     /**
1069      * @dev See {IERC165-supportsInterface}.
1070      */
1071     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1072         return interfaceId == type(IERC721Enumerable).interfaceId
1073             || super.supportsInterface(interfaceId);
1074     }
1075 
1076     /**
1077      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1078      */
1079     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1080         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1081         return _ownedTokens[owner][index];
1082     }
1083 
1084     /**
1085      * @dev See {IERC721Enumerable-totalSupply}.
1086      */
1087     function totalSupply() public view virtual override returns (uint256) {
1088         return _allTokens.length;
1089     }
1090 
1091     /**
1092      * @dev See {IERC721Enumerable-tokenByIndex}.
1093      */
1094     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1095         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1096         return _allTokens[index];
1097     }
1098 
1099     /**
1100      * @dev Hook that is called before any token transfer. This includes minting
1101      * and burning.
1102      *
1103      * Calling conditions:
1104      *
1105      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1106      * transferred to `to`.
1107      * - When `from` is zero, `tokenId` will be minted for `to`.
1108      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1109      * - `from` cannot be the zero address.
1110      * - `to` cannot be the zero address.
1111      *
1112      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1113      */
1114     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1115         super._beforeTokenTransfer(from, to, tokenId);
1116 
1117         if (from == address(0)) {
1118             _addTokenToAllTokensEnumeration(tokenId);
1119         } else if (from != to) {
1120             _removeTokenFromOwnerEnumeration(from, tokenId);
1121         }
1122         if (to == address(0)) {
1123             _removeTokenFromAllTokensEnumeration(tokenId);
1124         } else if (to != from) {
1125             _addTokenToOwnerEnumeration(to, tokenId);
1126         }
1127     }
1128 
1129     /**
1130      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1131      * @param to address representing the new owner of the given token ID
1132      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1133      */
1134     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1135         uint256 length = ERC721.balanceOf(to);
1136         _ownedTokens[to][length] = tokenId;
1137         _ownedTokensIndex[tokenId] = length;
1138     }
1139 
1140     /**
1141      * @dev Private function to add a token to this extension's token tracking data structures.
1142      * @param tokenId uint256 ID of the token to be added to the tokens list
1143      */
1144     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1145         _allTokensIndex[tokenId] = _allTokens.length;
1146         _allTokens.push(tokenId);
1147     }
1148 
1149     /**
1150      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1151      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1152      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1153      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1154      * @param from address representing the previous owner of the given token ID
1155      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1156      */
1157     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1158         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1159         // then delete the last slot (swap and pop).
1160 
1161         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1162         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1163 
1164         // When the token to delete is the last token, the swap operation is unnecessary
1165         if (tokenIndex != lastTokenIndex) {
1166             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1167 
1168             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1169             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1170         }
1171 
1172         // This also deletes the contents at the last position of the array
1173         delete _ownedTokensIndex[tokenId];
1174         delete _ownedTokens[from][lastTokenIndex];
1175     }
1176 
1177     /**
1178      * @dev Private function to remove a token from this extension's token tracking data structures.
1179      * This has O(1) time complexity, but alters the order of the _allTokens array.
1180      * @param tokenId uint256 ID of the token to be removed from the tokens list
1181      */
1182     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1183         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1184         // then delete the last slot (swap and pop).
1185 
1186         uint256 lastTokenIndex = _allTokens.length - 1;
1187         uint256 tokenIndex = _allTokensIndex[tokenId];
1188 
1189         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1190         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1191         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1192         uint256 lastTokenId = _allTokens[lastTokenIndex];
1193 
1194         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1195         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1196 
1197         // This also deletes the contents at the last position of the array
1198         delete _allTokensIndex[tokenId];
1199         _allTokens.pop();
1200     }
1201 }
1202 
1203 // File: contracts/api/DateTimeAPI.sol
1204 
1205 /**
1206  *  Abstract contract for interfacing with the DateTime contract.
1207  */
1208 abstract contract DateTimeAPI {
1209     function isLeapYear(uint16 year) public view virtual returns (bool);
1210     function getYear(uint timestamp) public view virtual returns (uint16);
1211     function getMonth(uint timestamp) public view virtual returns (uint8);
1212     function getDay(uint timestamp) public view virtual returns (uint8);
1213     function getHour(uint timestamp) public view virtual returns (uint8);
1214     function getMinute(uint timestamp) public view virtual returns (uint8);
1215     function getSecond(uint timestamp) public view virtual returns (uint8);
1216     function getWeekday(uint timestamp) public view virtual returns (uint8);
1217     function toTimestamp(uint16 year, uint8 month, uint8 day) public view virtual returns (uint timestamp);
1218     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public view virtual returns (uint timestamp);
1219     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public view virtual returns (uint timestamp);
1220     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public view virtual returns (uint timestamp);
1221 }
1222 
1223 // File: contracts/NiftyBuilderInstance.sol
1224 
1225 // SPDX-License-Identifier: MIT
1226 pragma solidity ^0.8.4;
1227 
1228 
1229 
1230 
1231 
1232 
1233 
1234 
1235 contract NiftyBuilderInstance is ERC721, ERC721Burnable, ERC721Enumerable {
1236     using Counters for Counters.Counter;
1237 
1238     string private _baseTokenURI;
1239     string public creator;
1240 
1241     string[12] artifact = ["QmQdb77jfHZSwk8dGpN3mqx8q4N7EUNytiAgEkXrMPbMVw", //State 1
1242                            "QmS3kaQnxb28vcXQg35PrGarJKkSysttZdNLdZp3JquttQ", //State 2
1243                            "QmX8beRtZAsed6naFWqddKejV33NoXotqZoGTuDaV5SHqN", //State 3
1244                            "QmQvsAMYzJm8kGQ7YNF5ziWUb6hr7vqdmkrn1qEPDykYi4", //State 4
1245                            "QmZwHt9ZhCgVMqpcFDhwKSA3higVYQXzyaPqh2BPjjXJXU", //State 5
1246                            "Qmd2MNfgzPYXGMS1ZgdsiWuAkriRRx15pfRXU7ZVK22jce", //State 6
1247                            "QmWcYzNdUYbMzrM7bGgTZXVE4GBm7v4dQneKb9fxgjMdAX", //State 7
1248                            "QmaXX7VuBY1dCeK78TTGEvYLTF76sf6fnzK7TJSni4PHxj", //State 8
1249                            "QmaqeJnzF2cAdfDrYRAw6VwzNn9dY9bKTyUuTHg1gUSQY7", //State 9
1250                            "QmSZquD6yGy5QvsJnygXUnWKrsKJvk942L8nzs6YZFKbxY", //State 10
1251                            "QmYtdrfPd3jAWWpjkd24NzLGqH5TDsHNvB8Qtqu6xnBcJF", //State 11
1252                            "QmesagGNeyjDvJ2N5oc8ykBiwsiE7gdk9vnfjjAe3ipjx4"];//State 12
1253 
1254     address private dateTimeContract; 
1255 
1256     uint immutable public id;
1257     uint immutable public countType;
1258     uint immutable private niftyType;
1259 
1260     mapping (uint => uint) public _numNiftyPermitted;
1261     mapping (uint => Counters.Counter) public _numNiftyMinted;
1262   
1263     event NiftyCreated(address new_owner, uint _niftyType, uint _tokenId);
1264     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);
1265 
1266     constructor(address _dateTimeContract,
1267                 address _masterBuilderContract, 
1268                 address _niftyRegistryContract) ERC721("Eroding and Reforming Bust of Rome (One Year) by Daniel Arsham", 
1269                                                        "ROME", 
1270                                                        _masterBuilderContract, 
1271                                                        _niftyRegistryContract) {
1272         id = 1;
1273         niftyType = 1;
1274         countType = 1;
1275         creator = "Daniel Arsham";
1276         dateTimeContract = _dateTimeContract;
1277         _setNiftyTypeName(1, "Eroding and Reforming Bust of Rome (One Year) by Daniel Arsham");
1278         _setBaseURIParent("https://api.niftygateway.com/danielarsham/");
1279     }
1280 
1281     /**
1282      * Configurable address for DateTime.
1283      */ 
1284     function setDateTimeContract(address _dateTimeContract) onlyValidSender public {
1285         dateTimeContract = _dateTimeContract;
1286     }
1287 
1288     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
1289         super._beforeTokenTransfer(from, to, tokenId);
1290     }
1291 
1292     /**
1293      * @dev See {IERC165-supportsInterface}.
1294      */
1295     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1296         return super.supportsInterface(interfaceId);
1297     }
1298 
1299     function _setBaseURIParent(string memory newBaseURI) internal {
1300         _baseTokenURI = newBaseURI;
1301     }
1302 
1303     function _baseURI() internal view virtual override returns (string memory) {
1304         return _baseTokenURI;
1305     }
1306 
1307     /**
1308      * This functions as the inverse of closeContract().
1309      */
1310     function setNumNiftyPermitted(uint256 num_nifty_permitted) onlyValidSender public {
1311         require(_numNiftyPermitted[niftyType] == 0, "NiftyBuilderInstance: Permitted number already set for this NFT");
1312         require(num_nifty_permitted < 9999 && num_nifty_permitted != 0, "NiftyBuilderInstance: Illegal argument");
1313         _numNiftyPermitted[niftyType] = num_nifty_permitted;
1314     }
1315 
1316     /**
1317      * Allow owner to change nifty name.
1318      */
1319     function setNiftyName(string memory nifty_name) onlyValidSender public {
1320         _setNiftyTypeName(niftyType, nifty_name);
1321     }
1322     
1323     function isGiftNiftyPermitted() internal view returns (bool) {
1324         if (_numNiftyMinted[niftyType].current() >= _numNiftyPermitted[niftyType]) {
1325             return false;
1326         }
1327         return true;
1328     }
1329 
1330     function giftNifty(address collector_address) onlyValidSender public {
1331         require(isGiftNiftyPermitted() == true, "NiftyBuilderInstance: Nifty sold out!");
1332 
1333         BuilderMasterAPI bm = BuilderMasterAPI(masterBuilderContract);
1334         _numNiftyMinted[niftyType].increment();
1335        
1336         uint specificTokenId = _numNiftyMinted[niftyType].current();
1337         uint tokenId = bm.encodeTokenId(id, niftyType, specificTokenId);
1338     
1339         _mint(collector_address, tokenId);
1340 
1341         emit NiftyCreated(collector_address, niftyType, tokenId);
1342     }
1343 
1344     /**
1345      * Loop through array and create nifties.
1346      */
1347     function massMintNFTs(address collector_address, uint num_to_mint) onlyValidSender public {
1348         BuilderMasterAPI bm = BuilderMasterAPI(masterBuilderContract);
1349 
1350         uint specificTokenId00 = _numNiftyMinted[niftyType].current() + 1;
1351         uint tokenId00 = bm.encodeTokenId(id, niftyType, specificTokenId00);
1352 
1353         for (uint i = 0; i < num_to_mint; i++) {
1354             giftNifty(collector_address);
1355         }
1356 
1357         uint specificTokenId01 = _numNiftyMinted[niftyType].current();
1358         uint tokenId01 = bm.encodeTokenId(id, niftyType, specificTokenId01);
1359     
1360         emit ConsecutiveTransfer(tokenId00, tokenId01, address(0), collector_address); 
1361     }
1362 
1363     function tokenIPFSHash(uint256 tokenId) external view override returns (string memory) {
1364         require(_exists(tokenId), "ERC721Metadata: IPFS hash query for nonexistent token");
1365 
1366         DateTimeAPI dateTime = DateTimeAPI(dateTimeContract);
1367     
1368         uint value = dateTime.getMonth(block.timestamp);
1369 
1370         if (value == 1) {
1371             return artifact[0];
1372         }
1373         if (value == 2) {
1374             return artifact[1];
1375         }
1376         if (value == 3) {
1377             return artifact[2];
1378         }
1379         if (value == 4) {
1380             return artifact[3];
1381         }
1382         if (value == 5) {
1383             return artifact[4];
1384         }
1385         if (value == 6) {
1386             return artifact[5];
1387         }
1388         if (value == 7) {
1389             return artifact[6];
1390         }
1391         if (value == 8) {
1392             return artifact[7];
1393         }
1394         if (value == 9) {
1395             return artifact[8];
1396         }
1397         if (value == 10) {
1398             return artifact[9];
1399         }
1400         if (value == 11) {
1401             return artifact[10];
1402         }
1403         return artifact[11];
1404     }
1405 
1406 }