1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9   bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10   /**
11    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12    */
13   function toString(uint256 value) internal pure returns (string memory) {
14     // Inspired by OraclizeAPI's implementation - MIT licence
15     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16     if (value == 0) {
17       return "0";
18     }
19     uint256 temp = value;
20     uint256 digits;
21     while (temp != 0) {
22       digits++;
23       temp /= 10;
24     }
25     bytes memory buffer = new bytes(digits);
26     while (value != 0) {
27       digits -= 1;
28       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
29       value /= 10;
30     }
31     return string(buffer);
32   }
33   /**
34    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
35    */
36   function toHexString(uint256 value) internal pure returns (string memory) {
37     if (value == 0) {
38       return "0x00";
39     }
40     uint256 temp = value;
41     uint256 length = 0;
42     while (temp != 0) {
43       length++;
44       temp >>= 8;
45     }
46     return toHexString(value, length);
47   }
48   /**
49    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
50    */
51   function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
52     bytes memory buffer = new bytes(2 * length + 2);
53     buffer[0] = "0";
54     buffer[1] = "x";
55     for (uint256 i = 2 * length + 1; i > 1; --i) {
56       buffer[i] = _HEX_SYMBOLS[value & 0xf];
57       value >>= 4;
58     }
59     require(value == 0, "Strings: hex length insufficient");
60     return string(buffer);
61   }
62 }
63 // File: @openzeppelin/contracts/utils/Address.sol
64 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
65 /**
66  * @dev Collection of functions related to the address type
67  */
68 library Address {
69   /**
70    * @dev Returns true if `account` is a contract.
71    *
72    * [IMPORTANT]
73    * ====
74    * It is unsafe to assume that an address for which this function returns
75    * false is an externally-owned account (EOA) and not a contract.
76    *
77    * Among others, `isContract` will return false for the following
78    * types of addresses:
79    *
80    *  - an externally-owned account
81    *  - a contract in construction
82    *  - an address where a contract will be created
83    *  - an address where a contract lived, but was destroyed
84    * ====
85    *
86    * [IMPORTANT]
87    * ====
88    * You shouldn't rely on `isContract` to protect against flash loan attacks!
89    *
90    * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
91    * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
92    * constructor.
93    * ====
94    */
95   function isContract(address account) internal view returns (bool) {
96     // This method relies on extcodesize/address.code.length, which returns 0
97     // for contracts in construction, since the code is only stored at the end
98     // of the constructor execution.
99     return account.code.length > 0;
100   }
101   /**
102    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
103    * `recipient`, forwarding all available gas and reverting on errors.
104    *
105    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
106    * of certain opcodes, possibly making contracts go over the 2300 gas limit
107    * imposed by `transfer`, making them unable to receive funds via
108    * `transfer`. {sendValue} removes this limitation.
109    *
110    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
111    *
112    * IMPORTANT: because control is transferred to `recipient`, care must be
113    * taken to not create reentrancy vulnerabilities. Consider using
114    * {ReentrancyGuard} or the
115    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
116    */
117   function sendValue(address payable recipient, uint256 amount) internal {
118     require(address(this).balance >= amount, "Address: insufficient balance");
119     (bool success, ) = recipient.call{value: amount}("");
120     require(success, "Address: unable to send value, recipient may have reverted");
121   }
122   /**
123    * @dev Performs a Solidity function call using a low level `call`. A
124    * plain `call` is an unsafe replacement for a function call: use this
125    * function instead.
126    *
127    * If `target` reverts with a revert reason, it is bubbled up by this
128    * function (like regular Solidity function calls).
129    *
130    * Returns the raw returned data. To convert to the expected return value,
131    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
132    *
133    * Requirements:
134    *
135    * - `target` must be a contract.
136    * - calling `target` with `data` must not revert.
137    *
138    * _Available since v3.1._
139    */
140   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
141     return functionCall(target, data, "Address: low-level call failed");
142   }
143   /**
144    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
145    * `errorMessage` as a fallback revert reason when `target` reverts.
146    *
147    * _Available since v3.1._
148    */
149   function functionCall(
150     address target,
151     bytes memory data,
152     string memory errorMessage
153   ) internal returns (bytes memory) {
154     return functionCallWithValue(target, data, 0, errorMessage);
155   }
156   /**
157    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
158    * but also transferring `value` wei to `target`.
159    *
160    * Requirements:
161    *
162    * - the calling contract must have an ETH balance of at least `value`.
163    * - the called Solidity function must be `payable`.
164    *
165    * _Available since v3.1._
166    */
167   function functionCallWithValue(
168     address target,
169     bytes memory data,
170     uint256 value
171   ) internal returns (bytes memory) {
172     return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
173   }
174   /**
175    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
176    * with `errorMessage` as a fallback revert reason when `target` reverts.
177    *
178    * _Available since v3.1._
179    */
180   function functionCallWithValue(
181     address target,
182     bytes memory data,
183     uint256 value,
184     string memory errorMessage
185   ) internal returns (bytes memory) {
186     require(address(this).balance >= value, "Address: insufficient balance for call");
187     require(isContract(target), "Address: call to non-contract");
188     (bool success, bytes memory returndata) = target.call{value: value}(data);
189     return verifyCallResult(success, returndata, errorMessage);
190   }
191   /**
192    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193    * but performing a static call.
194    *
195    * _Available since v3.3._
196    */
197   function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
198     return functionStaticCall(target, data, "Address: low-level static call failed");
199   }
200   /**
201    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
202    * but performing a static call.
203    *
204    * _Available since v3.3._
205    */
206   function functionStaticCall(
207     address target,
208     bytes memory data,
209     string memory errorMessage
210   ) internal view returns (bytes memory) {
211     require(isContract(target), "Address: static call to non-contract");
212     (bool success, bytes memory returndata) = target.staticcall(data);
213     return verifyCallResult(success, returndata, errorMessage);
214   }
215   /**
216    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
217    * but performing a delegate call.
218    *
219    * _Available since v3.4._
220    */
221   function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
222     return functionDelegateCall(target, data, "Address: low-level delegate call failed");
223   }
224   /**
225    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
226    * but performing a delegate call.
227    *
228    * _Available since v3.4._
229    */
230   function functionDelegateCall(
231     address target,
232     bytes memory data,
233     string memory errorMessage
234   ) internal returns (bytes memory) {
235     require(isContract(target), "Address: delegate call to non-contract");
236     (bool success, bytes memory returndata) = target.delegatecall(data);
237     return verifyCallResult(success, returndata, errorMessage);
238   }
239   /**
240    * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
241    * revert reason using the provided one.
242    *
243    * _Available since v4.3._
244    */
245   function verifyCallResult(
246     bool success,
247     bytes memory returndata,
248     string memory errorMessage
249   ) internal pure returns (bytes memory) {
250     if (success) {
251       return returndata;
252     } else {
253       // Look for revert reason and bubble it up if present
254       if (returndata.length > 0) {
255         // The easiest way to bubble the revert reason is using memory via assembly
256         assembly {
257           let returndata_size := mload(returndata)
258           revert(add(32, returndata), returndata_size)
259         }
260       } else {
261         revert(errorMessage);
262       }
263     }
264   }
265 }
266 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
267 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
268 /**
269  * @title ERC721 token receiver interface
270  * @dev Interface for any contract that wants to support safeTransfers
271  * from ERC721 asset contracts.
272  */
273 interface IERC721Receiver {
274   /**
275    * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
276    * by `operator` from `from`, this function is called.
277    *
278    * It must return its Solidity selector to confirm the token transfer.
279    * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
280    *
281    * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
282    */
283   function onERC721Received(
284     address operator,
285     address from,
286     uint256 tokenId,
287     bytes calldata data
288   ) external returns (bytes4);
289 }
290 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
291 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
292 /**
293  * @dev Interface of the ERC165 standard, as defined in the
294  * https://eips.ethereum.org/EIPS/eip-165[EIP].
295  *
296  * Implementers can declare support of contract interfaces, which can then be
297  * queried by others ({ERC165Checker}).
298  *
299  * For an implementation, see {ERC165}.
300  */
301 interface IERC165 {
302   /**
303    * @dev Returns true if this contract implements the interface defined by
304    * `interfaceId`. See the corresponding
305    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
306    * to learn more about how these ids are created.
307    *
308    * This function call must use less than 30 000 gas.
309    */
310   function supportsInterface(bytes4 interfaceId) external view returns (bool);
311 }
312 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
313 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
314 
315 /**
316  * @dev Implementation of the {IERC165} interface.
317  *
318  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
319  * for the additional interface id that will be supported. For example:
320  *
321  * ```solidity
322  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
323  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
324  * }
325  * ```
326  *
327  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
328  */
329 abstract contract ERC165 is IERC165 {
330   /**
331    * @dev See {IERC165-supportsInterface}.
332    */
333   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
334     return interfaceId == type(IERC165).interfaceId;
335   }
336 }
337 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
338 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
339 
340 /**
341  * @dev Required interface of an ERC721 compliant contract.
342  */
343 interface IERC721 is IERC165 {
344   /**
345    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
346    */
347   event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
348   /**
349    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
350    */
351   event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
352   /**
353    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
354    */
355   event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
356   /**
357    * @dev Returns the number of tokens in ``owner``'s account.
358    */
359   function balanceOf(address owner) external view returns (uint256 balance);
360   /**
361    * @dev Returns the owner of the `tokenId` token.
362    *
363    * Requirements:
364    *
365    * - `tokenId` must exist.
366    */
367   function ownerOf(uint256 tokenId) external view returns (address owner);
368   /**
369    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
370    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
371    *
372    * Requirements:
373    *
374    * - `from` cannot be the zero address.
375    * - `to` cannot be the zero address.
376    * - `tokenId` token must exist and be owned by `from`.
377    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
378    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
379    *
380    * Emits a {Transfer} event.
381    */
382   function safeTransferFrom(
383     address from,
384     address to,
385     uint256 tokenId
386   ) external;
387   /**
388    * @dev Transfers `tokenId` token from `from` to `to`.
389    *
390    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
391    *
392    * Requirements:
393    *
394    * - `from` cannot be the zero address.
395    * - `to` cannot be the zero address.
396    * - `tokenId` token must be owned by `from`.
397    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
398    *
399    * Emits a {Transfer} event.
400    */
401   function transferFrom(
402     address from,
403     address to,
404     uint256 tokenId
405   ) external;
406   /**
407    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
408    * The approval is cleared when the token is transferred.
409    *
410    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
411    *
412    * Requirements:
413    *
414    * - The caller must own the token or be an approved operator.
415    * - `tokenId` must exist.
416    *
417    * Emits an {Approval} event.
418    */
419   function approve(address to, uint256 tokenId) external;
420   /**
421    * @dev Returns the account approved for `tokenId` token.
422    *
423    * Requirements:
424    *
425    * - `tokenId` must exist.
426    */
427   function getApproved(uint256 tokenId) external view returns (address operator);
428   /**
429    * @dev Approve or remove `operator` as an operator for the caller.
430    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
431    *
432    * Requirements:
433    *
434    * - The `operator` cannot be the caller.
435    *
436    * Emits an {ApprovalForAll} event.
437    */
438   function setApprovalForAll(address operator, bool _approved) external;
439   /**
440    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
441    *
442    * See {setApprovalForAll}
443    */
444   function isApprovedForAll(address owner, address operator) external view returns (bool);
445   /**
446    * @dev Safely transfers `tokenId` token from `from` to `to`.
447    *
448    * Requirements:
449    *
450    * - `from` cannot be the zero address.
451    * - `to` cannot be the zero address.
452    * - `tokenId` token must exist and be owned by `from`.
453    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
454    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
455    *
456    * Emits a {Transfer} event.
457    */
458   function safeTransferFrom(
459     address from,
460     address to,
461     uint256 tokenId,
462     bytes calldata data
463   ) external;
464 }
465 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
466 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Enumerable is IERC721 {
473   /**
474    * @dev Returns the total amount of tokens stored by the contract.
475    */
476   function totalSupply() external view returns (uint256);
477   /**
478    * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
479    * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
480    */
481   function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
482   /**
483    * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
484    * Use along with {totalSupply} to enumerate all tokens.
485    */
486   function tokenByIndex(uint256 index) external view returns (uint256);
487 }
488 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
489 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
490 
491 /**
492  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
493  * @dev See https://eips.ethereum.org/EIPS/eip-721
494  */
495 interface IERC721Metadata is IERC721 {
496   /**
497    * @dev Returns the token collection name.
498    */
499   function name() external view returns (string memory);
500   /**
501    * @dev Returns the token collection symbol.
502    */
503   function symbol() external view returns (string memory);
504   /**
505    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
506    */
507   function tokenURI(uint256 tokenId) external view returns (string memory);
508 }
509 // File: @openzeppelin/contracts/utils/Context.sol
510 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
511 /**
512  * @dev Provides information about the current execution context, including the
513  * sender of the transaction and its data. While these are generally available
514  * via msg.sender and msg.data, they should not be accessed in such a direct
515  * manner, since when dealing with meta-transactions the account sending and
516  * paying for execution may not be the actual sender (as far as an application
517  * is concerned).
518  *
519  * This contract is only required for intermediate, library-like contracts.
520  */
521 abstract contract Context {
522   function _msgSender() internal view virtual returns (address) {
523     return msg.sender;
524   }
525   function _msgData() internal view virtual returns (bytes calldata) {
526     return msg.data;
527   }
528 }
529 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
530 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
531 
532 
533 /**
534  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
535  * the Metadata extension, but not including the Enumerable extension, which is available separately as
536  * {ERC721Enumerable}.
537  */
538 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
539   using Address for address;
540   using Strings for uint256;
541   // Token name
542   string private _name;
543   // Token symbol
544   string private _symbol;
545   // Mapping from token ID to owner address
546   mapping(uint256 => address) private _owners;
547   // Mapping owner address to token count
548   mapping(address => uint256) private _balances;
549   // Mapping from token ID to approved address
550   mapping(uint256 => address) private _tokenApprovals;
551   // Mapping from owner to operator approvals
552   mapping(address => mapping(address => bool)) private _operatorApprovals;
553   /**
554    * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
555    */
556   constructor(string memory name_, string memory symbol_) {
557     _name = name_;
558     _symbol = symbol_;
559   }
560   /**
561    * @dev See {IERC165-supportsInterface}.
562    */
563   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
564     return
565       interfaceId == type(IERC721).interfaceId ||
566       interfaceId == type(IERC721Metadata).interfaceId ||
567       super.supportsInterface(interfaceId);
568   }
569   /**
570    * @dev See {IERC721-balanceOf}.
571    */
572   function balanceOf(address owner) public view virtual override returns (uint256) {
573     require(owner != address(0), "ERC721: balance query for the zero address");
574     return _balances[owner];
575   }
576   /**
577    * @dev See {IERC721-ownerOf}.
578    */
579   function ownerOf(uint256 tokenId) public view virtual override returns (address) {
580     address owner = _owners[tokenId];
581     require(owner != address(0), "ERC721: owner query for nonexistent token");
582     return owner;
583   }
584   /**
585    * @dev See {IERC721Metadata-name}.
586    */
587   function name() public view virtual override returns (string memory) {
588     return _name;
589   }
590   /**
591    * @dev See {IERC721Metadata-symbol}.
592    */
593   function symbol() public view virtual override returns (string memory) {
594     return _symbol;
595   }
596   /**
597    * @dev See {IERC721Metadata-tokenURI}.
598    */
599   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
600     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
601     string memory baseURI = _baseURI();
602     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
603   }
604   /**
605    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
606    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
607    * by default, can be overriden in child contracts.
608    */
609   function _baseURI() internal view virtual returns (string memory) {
610     return "";
611   }
612   /**
613    * @dev See {IERC721-approve}.
614    */
615   function approve(address to, uint256 tokenId) public virtual override {
616     address owner = ERC721.ownerOf(tokenId);
617     require(to != owner, "ERC721: approval to current owner");
618     require(
619       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
620       "ERC721: approve caller is not owner nor approved for all"
621     );
622     _approve(to, tokenId);
623   }
624   /**
625    * @dev See {IERC721-getApproved}.
626    */
627   function getApproved(uint256 tokenId) public view virtual override returns (address) {
628     require(_exists(tokenId), "ERC721: approved query for nonexistent token");
629     return _tokenApprovals[tokenId];
630   }
631   /**
632    * @dev See {IERC721-setApprovalForAll}.
633    */
634   function setApprovalForAll(address operator, bool approved) public virtual override {
635     _setApprovalForAll(_msgSender(), operator, approved);
636   }
637   /**
638    * @dev See {IERC721-isApprovedForAll}.
639    */
640   function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
641     return _operatorApprovals[owner][operator];
642   }
643   /**
644    * @dev See {IERC721-transferFrom}.
645    */
646   function transferFrom(
647     address from,
648     address to,
649     uint256 tokenId
650   ) public virtual override {
651     //solhint-disable-next-line max-line-length
652     require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
653     _transfer(from, to, tokenId);
654   }
655   /**
656    * @dev See {IERC721-safeTransferFrom}.
657    */
658   function safeTransferFrom(
659     address from,
660     address to,
661     uint256 tokenId
662   ) public virtual override {
663     safeTransferFrom(from, to, tokenId, "");
664   }
665   /**
666    * @dev See {IERC721-safeTransferFrom}.
667    */
668   function safeTransferFrom(
669     address from,
670     address to,
671     uint256 tokenId,
672     bytes memory _data
673   ) public virtual override {
674     require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
675     _safeTransfer(from, to, tokenId, _data);
676   }
677   /**
678    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
679    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
680    *
681    * `_data` is additional data, it has no specified format and it is sent in call to `to`.
682    *
683    * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
684    * implement alternative mechanisms to perform token transfer, such as signature-based.
685    *
686    * Requirements:
687    *
688    * - `from` cannot be the zero address.
689    * - `to` cannot be the zero address.
690    * - `tokenId` token must exist and be owned by `from`.
691    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
692    *
693    * Emits a {Transfer} event.
694    */
695   function _safeTransfer(
696     address from,
697     address to,
698     uint256 tokenId,
699     bytes memory _data
700   ) internal virtual {
701     _transfer(from, to, tokenId);
702     require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
703   }
704   /**
705    * @dev Returns whether `tokenId` exists.
706    *
707    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
708    *
709    * Tokens start existing when they are minted (`_mint`),
710    * and stop existing when they are burned (`_burn`).
711    */
712   function _exists(uint256 tokenId) internal view virtual returns (bool) {
713     return _owners[tokenId] != address(0);
714   }
715   /**
716    * @dev Returns whether `spender` is allowed to manage `tokenId`.
717    *
718    * Requirements:
719    *
720    * - `tokenId` must exist.
721    */
722   function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
723     require(_exists(tokenId), "ERC721: operator query for nonexistent token");
724     address owner = ERC721.ownerOf(tokenId);
725     return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
726   }
727   /**
728    * @dev Safely mints `tokenId` and transfers it to `to`.
729    *
730    * Requirements:
731    *
732    * - `tokenId` must not exist.
733    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
734    *
735    * Emits a {Transfer} event.
736    */
737   function _safeMint(address to, uint256 tokenId) internal virtual {
738     _safeMint(to, tokenId, "");
739   }
740   /**
741    * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
742    * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
743    */
744   function _safeMint(
745     address to,
746     uint256 tokenId,
747     bytes memory _data
748   ) internal virtual {
749     _mint(to, tokenId);
750     require(
751       _checkOnERC721Received(address(0), to, tokenId, _data),
752       "ERC721: transfer to non ERC721Receiver implementer"
753     );
754   }
755   /**
756    * @dev Mints `tokenId` and transfers it to `to`.
757    *
758    * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
759    *
760    * Requirements:
761    *
762    * - `tokenId` must not exist.
763    * - `to` cannot be the zero address.
764    *
765    * Emits a {Transfer} event.
766    */
767   function _mint(address to, uint256 tokenId) internal virtual {
768     require(to != address(0), "ERC721: mint to the zero address");
769     require(!_exists(tokenId), "ERC721: token already minted");
770     _beforeTokenTransfer(address(0), to, tokenId);
771     _balances[to] += 1;
772     _owners[tokenId] = to;
773     emit Transfer(address(0), to, tokenId);
774     _afterTokenTransfer(address(0), to, tokenId);
775   }
776   /**
777    * @dev Destroys `tokenId`.
778    * The approval is cleared when the token is burned.
779    *
780    * Requirements:
781    *
782    * - `tokenId` must exist.
783    *
784    * Emits a {Transfer} event.
785    */
786   function _burn(uint256 tokenId) internal virtual {
787     address owner = ERC721.ownerOf(tokenId);
788     _beforeTokenTransfer(owner, address(0), tokenId);
789     // Clear approvals
790     _approve(address(0), tokenId);
791     _balances[owner] -= 1;
792     delete _owners[tokenId];
793     emit Transfer(owner, address(0), tokenId);
794     _afterTokenTransfer(owner, address(0), tokenId);
795   }
796   /**
797    * @dev Transfers `tokenId` from `from` to `to`.
798    *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
799    *
800    * Requirements:
801    *
802    * - `to` cannot be the zero address.
803    * - `tokenId` token must be owned by `from`.
804    *
805    * Emits a {Transfer} event.
806    */
807   function _transfer(
808     address from,
809     address to,
810     uint256 tokenId
811   ) internal virtual {
812     require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
813     require(to != address(0), "ERC721: transfer to the zero address");
814     _beforeTokenTransfer(from, to, tokenId);
815     // Clear approvals from the previous owner
816     _approve(address(0), tokenId);
817     _balances[from] -= 1;
818     _balances[to] += 1;
819     _owners[tokenId] = to;
820     emit Transfer(from, to, tokenId);
821     _afterTokenTransfer(from, to, tokenId);
822   }
823   /**
824    * @dev Approve `to` to operate on `tokenId`
825    *
826    * Emits a {Approval} event.
827    */
828   function _approve(address to, uint256 tokenId) internal virtual {
829     _tokenApprovals[tokenId] = to;
830     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
831   }
832   /**
833    * @dev Approve `operator` to operate on all of `owner` tokens
834    *
835    * Emits a {ApprovalForAll} event.
836    */
837   function _setApprovalForAll(
838     address owner,
839     address operator,
840     bool approved
841   ) internal virtual {
842     require(owner != operator, "ERC721: approve to caller");
843     _operatorApprovals[owner][operator] = approved;
844     emit ApprovalForAll(owner, operator, approved);
845   }
846   /**
847    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
848    * The call is not executed if the target address is not a contract.
849    *
850    * @param from address representing the previous owner of the given token ID
851    * @param to target address that will receive the tokens
852    * @param tokenId uint256 ID of the token to be transferred
853    * @param _data bytes optional data to send along with the call
854    * @return bool whether the call correctly returned the expected magic value
855    */
856   function _checkOnERC721Received(
857     address from,
858     address to,
859     uint256 tokenId,
860     bytes memory _data
861   ) private returns (bool) {
862     if (to.isContract()) {
863       try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
864         return retval == IERC721Receiver.onERC721Received.selector;
865       } catch (bytes memory reason) {
866         if (reason.length == 0) {
867           revert("ERC721: transfer to non ERC721Receiver implementer");
868         } else {
869           assembly {
870             revert(add(32, reason), mload(reason))
871           }
872         }
873       }
874     } else {
875       return true;
876     }
877   }
878   /**
879    * @dev Hook that is called before any token transfer. This includes minting
880    * and burning.
881    *
882    * Calling conditions:
883    *
884    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
885    * transferred to `to`.
886    * - When `from` is zero, `tokenId` will be minted for `to`.
887    * - When `to` is zero, ``from``'s `tokenId` will be burned.
888    * - `from` and `to` are never both zero.
889    *
890    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
891    */
892   function _beforeTokenTransfer(
893     address from,
894     address to,
895     uint256 tokenId
896   ) internal virtual {}
897   /**
898    * @dev Hook that is called after any transfer of tokens. This includes
899    * minting and burning.
900    *
901    * Calling conditions:
902    *
903    * - when `from` and `to` are both non-zero.
904    * - `from` and `to` are never both zero.
905    *
906    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
907    */
908   function _afterTokenTransfer(
909     address from,
910     address to,
911     uint256 tokenId
912   ) internal virtual {}
913 }
914 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
915 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
916 
917 /**
918  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
919  * enumerability of all the token ids in the contract as well as all token ids owned by each
920  * account.
921  */
922 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
923   // Mapping from owner to list of owned token IDs
924   mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
925   // Mapping from token ID to index of the owner tokens list
926   mapping(uint256 => uint256) private _ownedTokensIndex;
927   // Array with all token ids, used for enumeration
928   uint256[] private _allTokens;
929   // Mapping from token id to position in the allTokens array
930   mapping(uint256 => uint256) private _allTokensIndex;
931   /**
932    * @dev See {IERC165-supportsInterface}.
933    */
934   function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
935     return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
936   }
937   /**
938    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
939    */
940   function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
941     require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
942     return _ownedTokens[owner][index];
943   }
944   /**
945    * @dev See {IERC721Enumerable-totalSupply}.
946    */
947   function totalSupply() public view virtual override returns (uint256) {
948     return _allTokens.length;
949   }
950   /**
951    * @dev See {IERC721Enumerable-tokenByIndex}.
952    */
953   function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
954     require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
955     return _allTokens[index];
956   }
957   /**
958    * @dev Hook that is called before any token transfer. This includes minting
959    * and burning.
960    *
961    * Calling conditions:
962    *
963    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
964    * transferred to `to`.
965    * - When `from` is zero, `tokenId` will be minted for `to`.
966    * - When `to` is zero, ``from``'s `tokenId` will be burned.
967    * - `from` cannot be the zero address.
968    * - `to` cannot be the zero address.
969    *
970    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
971    */
972   function _beforeTokenTransfer(
973     address from,
974     address to,
975     uint256 tokenId
976   ) internal virtual override {
977     super._beforeTokenTransfer(from, to, tokenId);
978     if (from == address(0)) {
979       _addTokenToAllTokensEnumeration(tokenId);
980     } else if (from != to) {
981       _removeTokenFromOwnerEnumeration(from, tokenId);
982     }
983     if (to == address(0)) {
984       _removeTokenFromAllTokensEnumeration(tokenId);
985     } else if (to != from) {
986       _addTokenToOwnerEnumeration(to, tokenId);
987     }
988   }
989   /**
990    * @dev Private function to add a token to this extension's ownership-tracking data structures.
991    * @param to address representing the new owner of the given token ID
992    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
993    */
994   function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
995     uint256 length = ERC721.balanceOf(to);
996     _ownedTokens[to][length] = tokenId;
997     _ownedTokensIndex[tokenId] = length;
998   }
999   /**
1000    * @dev Private function to add a token to this extension's token tracking data structures.
1001    * @param tokenId uint256 ID of the token to be added to the tokens list
1002    */
1003   function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1004     _allTokensIndex[tokenId] = _allTokens.length;
1005     _allTokens.push(tokenId);
1006   }
1007   /**
1008    * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1009    * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1010    * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1011    * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1012    * @param from address representing the previous owner of the given token ID
1013    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1014    */
1015   function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1016     // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1017     // then delete the last slot (swap and pop).
1018     uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1019     uint256 tokenIndex = _ownedTokensIndex[tokenId];
1020     // When the token to delete is the last token, the swap operation is unnecessary
1021     if (tokenIndex != lastTokenIndex) {
1022       uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1023       _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1024       _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1025     }
1026     // This also deletes the contents at the last position of the array
1027     delete _ownedTokensIndex[tokenId];
1028     delete _ownedTokens[from][lastTokenIndex];
1029   }
1030   /**
1031    * @dev Private function to remove a token from this extension's token tracking data structures.
1032    * This has O(1) time complexity, but alters the order of the _allTokens array.
1033    * @param tokenId uint256 ID of the token to be removed from the tokens list
1034    */
1035   function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1036     // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1037     // then delete the last slot (swap and pop).
1038     uint256 lastTokenIndex = _allTokens.length - 1;
1039     uint256 tokenIndex = _allTokensIndex[tokenId];
1040     // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1041     // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1042     // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1043     uint256 lastTokenId = _allTokens[lastTokenIndex];
1044     _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1045     _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1046     // This also deletes the contents at the last position of the array
1047     delete _allTokensIndex[tokenId];
1048     _allTokens.pop();
1049   }
1050 }
1051 // File: @openzeppelin/contracts/access/Ownable.sol
1052 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1053 
1054 /**
1055  * @dev Contract module which provides a basic access control mechanism, where
1056  * there is an account (an owner) that can be granted exclusive access to
1057  * specific functions.
1058  *
1059  * By default, the owner account will be the one that deploys the contract. This
1060  * can later be changed with {transferOwnership}.
1061  *
1062  * This module is used through inheritance. It will make available the modifier
1063  * `onlyOwner`, which can be applied to your functions to restrict their use to
1064  * the owner.
1065  */
1066 abstract contract Ownable is Context {
1067   address private _owner;
1068   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1069   /**
1070    * @dev Initializes the contract setting the deployer as the initial owner.
1071    */
1072   constructor() {
1073     _transferOwnership(_msgSender());
1074   }
1075   /**
1076    * @dev Returns the address of the current owner.
1077    */
1078   function owner() public view virtual returns (address) {
1079     return _owner;
1080   }
1081   /**
1082    * @dev Throws if called by any account other than the owner.
1083    */
1084   modifier onlyOwner() {
1085     require(owner() == _msgSender(), "Ownable: caller is not the owner");
1086     _;
1087   }
1088   /**
1089    * @dev Leaves the contract without owner. It will not be possible to call
1090    * `onlyOwner` functions anymore. Can only be called by the current owner.
1091    *
1092    * NOTE: Renouncing ownership will leave the contract without an owner,
1093    * thereby removing any functionality that is only available to the owner.
1094    */
1095   function renounceOwnership() public virtual onlyOwner {
1096     _transferOwnership(address(0));
1097   }
1098   /**
1099    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1100    * Can only be called by the current owner.
1101    */
1102   function transferOwnership(address newOwner) public virtual onlyOwner {
1103     require(newOwner != address(0), "Ownable: new owner is the zero address");
1104     _transferOwnership(newOwner);
1105   }
1106   /**
1107    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1108    * Internal function without access restriction.
1109    */
1110   function _transferOwnership(address newOwner) internal virtual {
1111     address oldOwner = _owner;
1112     _owner = newOwner;
1113     emit OwnershipTransferred(oldOwner, newOwner);
1114   }
1115 }
1116 // MetaSneaker.sol
1117 contract MetaSneaker is ERC721Enumerable, Ownable {
1118   uint256 public maxSupply = 4000;
1119   bool public whiteListSaleStatus = false;
1120   bool public publicSaleStatus = false;
1121   bool public revealStatus = false;
1122   uint256 public whiteListPrice = 0.22 ether;
1123   uint256 public publicPrice = 0.25 ether;
1124   uint256 public mintTxLimit = 5;
1125   string public baseUri = "";
1126   string public contractURI = "https://gateway.pinata.cloud/ipfs/QmcCuXWqPyFtsPUy5zP5cxHLzJHZd9HPXQtQvXVWkc27oc";
1127   string public beforeRevealURI;
1128   mapping (address => bool) private _whiteList;
1129   uint256 private _airdropCount; // default 0;
1130   mapping (uint256 => address) private _airdropList; // airdrop_id => address, airdrop_id's min value is 1
1131   mapping (address => uint256) private _airdropAmount;
1132   event TokensMinted(address receiver, uint256 numOfToken);
1133   modifier onlyWhiteListed {
1134     require(_whiteList[msg.sender], "not_whitelisted");
1135     _;
1136   }
1137   modifier onlyAirdropped {
1138     require(getAirdroppedTokens(msg.sender) > 0, "not_airdropped");
1139     _;
1140   }
1141   constructor() ERC721("Meta Sneakers", "SNEAKERS") {}
1142   function _baseURI() internal view override returns (string memory) {
1143     return baseUri;
1144   }
1145   function _mintToken(address to, uint256 numOfToken) internal {
1146     require(numOfToken > 0, "zero_amount");
1147     require(numOfToken <= mintTxLimit, "exceed_tx_limit");
1148     require((totalSupply() + numOfToken) <= maxSupply, "exceed_max_supply");
1149     require(to != address(0), "invalid_to_address");
1150     for (uint256 i=0; i<numOfToken; i++) {
1151       _safeMint(to, totalSupply() + 1);
1152     }
1153     emit TokensMinted(to, numOfToken);
1154   }
1155   function airdrop() external onlyAirdropped {
1156     _mintToken(msg.sender, getAirdroppedTokens(msg.sender));
1157   }
1158   function whiteListSale(uint256 numOfToken) external payable onlyWhiteListed {
1159     require(whiteListPrice * numOfToken <= msg.value, "insuf_price");
1160     require(whiteListSaleStatus, "not_sale");
1161     _mintToken(msg.sender, numOfToken);
1162   }
1163   function publicSale(uint256 numOfToken) external payable {
1164     require(publicPrice * numOfToken <= msg.value, "insuf_price");
1165     require(publicSaleStatus, "not_sale");
1166     _mintToken(msg.sender, numOfToken);
1167   }
1168   function tokenURI(uint256 tokenId) public  view override returns (string memory) {
1169     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1170     if (revealStatus){
1171       return super.tokenURI(tokenId);
1172     } else {
1173       return beforeRevealURI;
1174     }
1175   }
1176   function walletOfOwner(address walletAddress) public view returns (uint256[] memory) {
1177     uint256 tokenCount = balanceOf(walletAddress);
1178     uint256[] memory tokenIds = new uint256[](tokenCount);
1179     for (uint256 i=0; i < tokenCount; i++) {
1180       tokenIds[i] = tokenOfOwnerByIndex(walletAddress, i);
1181     }
1182     return tokenIds;
1183   }
1184   function isWhitelisted(address addr) public view returns(bool){
1185     return _whiteList[addr];
1186   }
1187   function totalAirdrops() public view returns(uint256) {
1188     return _airdropCount;
1189   }
1190   function getAirdroppedTokens(address addr) public view returns(uint256) {
1191     uint256 airdrop_id;
1192     uint256 airdrop_amount = 0;
1193     for (uint256 i=0; i < _airdropCount; i++) {
1194       airdrop_id = i + 1;
1195       if (_airdropList[airdrop_id] == addr) {
1196         airdrop_amount = _airdropAmount[addr];
1197         break;
1198       }
1199     }
1200     return airdrop_amount;
1201   }
1202   /**
1203    * Owner methods
1204   **/
1205   function adminSetMaxSupply(uint256 newSupply) external onlyOwner {
1206     maxSupply = newSupply;
1207   }
1208   function adminSetBaseURI(string memory newUri) external onlyOwner {
1209     baseUri = newUri;
1210   }
1211   function adminSetMintTxLimit(uint256 newLimit) external onlyOwner {
1212     mintTxLimit = newLimit;
1213   }
1214   function adminSetWhitelistSaleState(bool newStatus) external onlyOwner {
1215     whiteListSaleStatus = newStatus;
1216   }
1217   function adminSetPublicSaleState(bool newStatus) external onlyOwner {
1218     publicSaleStatus = newStatus;
1219   }
1220   function adminSetWhitelistPrice(uint256 newPrice) external onlyOwner {
1221     whiteListPrice = newPrice;
1222   }
1223   function adminSetPublicPrice(uint256 newPrice) external onlyOwner {
1224     publicPrice = newPrice;
1225   }
1226   function adminSetRevealStatus(bool newStatus) external onlyOwner {
1227     revealStatus = newStatus;
1228   }
1229   function adminSetBeforeRevealURI(string memory newUri) external onlyOwner {
1230     beforeRevealURI = newUri;
1231   }
1232   function adminAddToWhitelistBulk(address[] calldata addrs) external onlyOwner {
1233     for (uint256 i=0; i < addrs.length; i++) {
1234       _whiteList[addrs[i]] = true;
1235     }
1236   }
1237   function adminRemoveFromWhitelist(address addr) external onlyOwner {
1238     _whiteList[addr] = false;
1239   }
1240   function adminAirdrop(uint256 startRange, uint256 endRange) external onlyOwner {
1241     require(startRange >= 0 && endRange <= _airdropCount,"out_of_airdrop_count");
1242     require(startRange <= endRange);
1243     for (uint256 i=startRange; i<endRange; i++) {
1244       uint256 airdrop_id = i + 1;
1245       address holder_addr = _airdropList[airdrop_id];
1246       uint256 num_of_token = _airdropAmount[holder_addr];
1247       if (holder_addr != address(0) && num_of_token > 0) {
1248         for (uint256 j=0; j<num_of_token; j++) {
1249           _safeMint(holder_addr, totalSupply() + 1);
1250         }
1251         _airdropAmount[holder_addr] = 0;
1252       }
1253     }
1254   }
1255   function adminAddAirdropBulk(address[] calldata addrs, uint256[] calldata numOfTokens) external onlyOwner {
1256     require (addrs.length == numOfTokens.length, 'invalid_params');
1257     uint256 airdrop_id;
1258     for (uint256 i=0; i < addrs.length; i++) {
1259       airdrop_id = totalAirdrops() + 1;
1260       _airdropList[airdrop_id] = addrs[i];
1261       _airdropAmount[addrs[i]] = numOfTokens[i];
1262       _airdropCount = airdrop_id;
1263     }
1264   }
1265   function adminRemoveAirdrop(address addr) external onlyOwner {
1266     uint256 airdrop_id;
1267     for (uint256 i=0; i < _airdropCount; i++) {
1268       airdrop_id = i + 1;
1269       if (_airdropList[airdrop_id] == addr) {
1270         _airdropAmount[addr] = 0;
1271         break;
1272       }
1273     }
1274   }
1275   function withdraw() external onlyOwner {
1276     require(address(this).balance > 0, "no_balance");
1277     bool success = false;
1278     (success, ) = (payable(msg.sender)).call{value: address(this).balance}("");
1279     require(success, "withdraw_failed");
1280   }
1281 }