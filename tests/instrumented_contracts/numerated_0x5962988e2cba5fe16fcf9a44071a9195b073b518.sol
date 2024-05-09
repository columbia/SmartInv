1 // SPDX-License-Identifier: MIT
2 /*
3 ______/\\\\\\\\\\\__/\\\\\\\\\\\_____/\\\\\\\\\\\\_____/\\\\\\\\\\\\__/\\\________/\\\_        
4  _____\/////\\\///__\/////\\\///____/\\\//////////____/\\\//////////__\///\\\____/\\\/__       
5   _________\/\\\_________\/\\\______/\\\______________/\\\_______________\///\\\/\\\/____      
6    _________\/\\\_________\/\\\_____\/\\\____/\\\\\\\_\/\\\____/\\\\\\\_____\///\\\/______     
7     _________\/\\\_________\/\\\_____\/\\\___\/////\\\_\/\\\___\/////\\\_______\/\\\_______    
8      _________\/\\\_________\/\\\_____\/\\\_______\/\\\_\/\\\_______\/\\\_______\/\\\_______   
9       __/\\\___\/\\\_________\/\\\_____\/\\\_______\/\\\_\/\\\_______\/\\\_______\/\\\_______  
10        _\//\\\\\\\\\_______/\\\\\\\\\\\_\//\\\\\\\\\\\\/__\//\\\\\\\\\\\\/________\/\\\_______ 
11         __\/////////_______\///////////___\////////////_____\////////////__________\///________
12 */
13 
14 
15 pragma solidity ^0.8.0;
16 
17 library Address {
18     /**
19      * @dev Returns true if `account` is a contract.
20      *
21      * [IMPORTANT]
22      * ====
23      * It is unsafe to assume that an address for which this function returns
24      * false is an externally-owned account (EOA) and not a contract.
25      *
26      * Among others, `isContract` will return false for the following
27      * types of addresses:
28      *
29      *  - an externally-owned account
30      *  - a contract in construction
31      *  - an address where a contract will be created
32      *  - an address where a contract lived, but was destroyed
33      * ====
34      */
35     function isContract(address account) internal view returns (bool) {
36         // This method relies on extcodesize, which returns 0 for contracts in
37         // construction, since the code is only stored at the end of the
38         // constructor execution.
39 
40         uint256 size;
41         assembly {
42             size := extcodesize(account)
43         }
44         return size > 0;
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     /**
71      * @dev Performs a Solidity function call using a low level `call`. A
72      * plain `call` is an unsafe replacement for a function call: use this
73      * function instead.
74      *
75      * If `target` reverts with a revert reason, it is bubbled up by this
76      * function (like regular Solidity function calls).
77      *
78      * Returns the raw returned data. To convert to the expected return value,
79      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
80      *
81      * Requirements:
82      *
83      * - `target` must be a contract.
84      * - calling `target` with `data` must not revert.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
108      * but also transferring `value` wei to `target`.
109      *
110      * Requirements:
111      *
112      * - the calling contract must have an ETH balance of at least `value`.
113      * - the called Solidity function must be `payable`.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
127      * with `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         require(isContract(target), "Address: call to non-contract");
139 
140         (bool success, bytes memory returndata) = target.call{value: value}(data);
141         return verifyCallResult(success, returndata, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151         return functionStaticCall(target, data, "Address: low-level static call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal view returns (bytes memory) {
165         require(isContract(target), "Address: static call to non-contract");
166 
167         (bool success, bytes memory returndata) = target.staticcall(data);
168         return verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but performing a delegate call.
174      *
175      * _Available since v3.4._
176      */
177     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
183      * but performing a delegate call.
184      *
185      * _Available since v3.4._
186      */
187     function functionDelegateCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         require(isContract(target), "Address: delegate call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.delegatecall(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
200      * revert reason using the provided one.
201      *
202      * _Available since v4.3._
203      */
204     function verifyCallResult(
205         bool success,
206         bytes memory returndata,
207         string memory errorMessage
208     ) internal pure returns (bytes memory) {
209         if (success) {
210             return returndata;
211         } else {
212             // Look for revert reason and bubble it up if present
213             if (returndata.length > 0) {
214                 // The easiest way to bubble the revert reason is using memory via assembly
215 
216                 assembly {
217                     let returndata_size := mload(returndata)
218                     revert(add(32, returndata), returndata_size)
219                 }
220             } else {
221                 revert(errorMessage);
222             }
223         }
224     }
225 }
226 
227 library Strings {
228     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
229 
230     /**
231      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
232      */
233     function toString(uint256 value) internal pure returns (string memory) {
234         // Inspired by OraclizeAPI's implementation - MIT licence
235         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
236 
237         if (value == 0) {
238             return "0";
239         }
240         uint256 temp = value;
241         uint256 digits;
242         while (temp != 0) {
243             digits++;
244             temp /= 10;
245         }
246         bytes memory buffer = new bytes(digits);
247         while (value != 0) {
248             digits -= 1;
249             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
250             value /= 10;
251         }
252         return string(buffer);
253     }
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
257      */
258     function toHexString(uint256 value) internal pure returns (string memory) {
259         if (value == 0) {
260             return "0x00";
261         }
262         uint256 temp = value;
263         uint256 length = 0;
264         while (temp != 0) {
265             length++;
266             temp >>= 8;
267         }
268         return toHexString(value, length);
269     }
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
273      */
274     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
275         bytes memory buffer = new bytes(2 * length + 2);
276         buffer[0] = "0";
277         buffer[1] = "x";
278         for (uint256 i = 2 * length + 1; i > 1; --i) {
279             buffer[i] = _HEX_SYMBOLS[value & 0xf];
280             value >>= 4;
281         }
282         require(value == 0, "Strings: hex length insufficient");
283         return string(buffer);
284     }
285 }
286 
287 abstract contract Context {
288   function _msgSender() internal view virtual returns (address) {
289       return msg.sender;
290   }
291 
292   function _msgData() internal view virtual returns (bytes calldata) {
293       return msg.data;
294   }
295 }
296 
297 abstract contract Ownable is Context {
298   address private _owner;
299 
300   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
301 
302   /**
303    * @dev Initializes the contract setting the deployer as the initial owner.
304    */
305   constructor() {
306       _setOwner(_msgSender());
307   }
308 
309   /**
310    * @dev Returns the address of the current owner.
311    */
312   function owner() public view virtual returns (address) {
313       return _owner;
314   }
315 
316   /**
317    * @dev Throws if called by any account other than the owner.
318    */
319   modifier onlyOwner() {
320       require(owner() == _msgSender(), "Ownable: caller is not the owner");
321       _;
322   }
323 
324   /**
325    * @dev Leaves the contract without owner. It will not be possible to call
326    * `onlyOwner` functions anymore. Can only be called by the current owner.
327    *
328    * NOTE: Renouncing ownership will leave the contract without an owner,
329    * thereby removing any functionality that is only available to the owner.
330    */
331   function renounceOwnership() public virtual onlyOwner {
332       _setOwner(address(0));
333   }
334 
335   /**
336    * @dev Transfers ownership of the contract to a new account (`newOwner`).
337    * Can only be called by the current owner.
338    */
339   function transferOwnership(address newOwner) public virtual onlyOwner {
340       require(newOwner != address(0), "Ownable: new owner is the zero address");
341       _setOwner(newOwner);
342   }
343 
344   function _setOwner(address newOwner) private {
345       address oldOwner = _owner;
346       _owner = newOwner;
347       emit OwnershipTransferred(oldOwner, newOwner);
348   }
349 }
350 
351 interface IERC165 {
352   /**
353    * @dev Returns true if this contract implements the interface defined by
354    * `interfaceId`. See the corresponding
355    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
356    * to learn more about how these ids are created.
357    *
358    * This function call must use less than 30 000 gas.
359    */
360   function supportsInterface(bytes4 interfaceId) external view returns (bool);
361 }
362 
363 interface IERC721 is IERC165 {
364   /**
365    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
366    */
367   event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
368 
369   /**
370    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
371    */
372   event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
373 
374   /**
375    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
376    */
377   event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
378 
379   /**
380    * @dev Returns the number of tokens in ``owner``'s account.
381    */
382   function balanceOf(address owner) external view returns (uint256 balance);
383 
384   /**
385    * @dev Returns the owner of the `tokenId` token.
386    *
387    * Requirements:
388    *
389    * - `tokenId` must exist.
390    */
391   function ownerOf(uint256 tokenId) external view returns (address owner);
392 
393   /**
394    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
395    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
396    *
397    * Requirements:
398    *
399    * - `from` cannot be the zero address.
400    * - `to` cannot be the zero address.
401    * - `tokenId` token must exist and be owned by `from`.
402    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
403    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
404    *
405    * Emits a {Transfer} event.
406    */
407   function safeTransferFrom(
408       address from,
409       address to,
410       uint256 tokenId
411   ) external;
412 
413   /**
414    * @dev Transfers `tokenId` token from `from` to `to`.
415    *
416    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
417    *
418    * Requirements:
419    *
420    * - `from` cannot be the zero address.
421    * - `to` cannot be the zero address.
422    * - `tokenId` token must be owned by `from`.
423    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
424    *
425    * Emits a {Transfer} event.
426    */
427   function transferFrom(
428       address from,
429       address to,
430       uint256 tokenId
431   ) external;
432 
433   /**
434    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
435    * The approval is cleared when the token is transferred.
436    *
437    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
438    *
439    * Requirements:
440    *
441    * - The caller must own the token or be an approved operator.
442    * - `tokenId` must exist.
443    *
444    * Emits an {Approval} event.
445    */
446   function approve(address to, uint256 tokenId) external;
447 
448   /**
449    * @dev Returns the account approved for `tokenId` token.
450    *
451    * Requirements:
452    *
453    * - `tokenId` must exist.
454    */
455   function getApproved(uint256 tokenId) external view returns (address operator);
456 
457   /**
458    * @dev Approve or remove `operator` as an operator for the caller.
459    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
460    *
461    * Requirements:
462    *
463    * - The `operator` cannot be the caller.
464    *
465    * Emits an {ApprovalForAll} event.
466    */
467   function setApprovalForAll(address operator, bool _approved) external;
468 
469   /**
470    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
471    *
472    * See {setApprovalForAll}
473    */
474   function isApprovedForAll(address owner, address operator) external view returns (bool);
475 
476   /**
477    * @dev Safely transfers `tokenId` token from `from` to `to`.
478    *
479    * Requirements:
480    *
481    * - `from` cannot be the zero address.
482    * - `to` cannot be the zero address.
483    * - `tokenId` token must exist and be owned by `from`.
484    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
485    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
486    *
487    * Emits a {Transfer} event.
488    */
489   function safeTransferFrom(
490       address from,
491       address to,
492       uint256 tokenId,
493       bytes calldata data
494   ) external;
495 }
496 
497 interface IERC721Receiver {
498     /**
499      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
500      * by `operator` from `from`, this function is called.
501      *
502      * It must return its Solidity selector to confirm the token transfer.
503      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
504      *
505      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
506      */
507     function onERC721Received(
508         address operator,
509         address from,
510         uint256 tokenId,
511         bytes calldata data
512     ) external returns (bytes4);
513 }
514 
515 interface IERC721Metadata is IERC721 {
516     /**
517      * @dev Returns the token collection name.
518      */
519     function name() external view returns (string memory);
520 
521     /**
522      * @dev Returns the token collection symbol.
523      */
524     function symbol() external view returns (string memory);
525 
526     /**
527      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
528      */
529     function tokenURI(uint256 tokenId) external view returns (string memory);
530 }
531 
532 abstract contract ERC165 is IERC165 {
533   /**
534    * @dev See {IERC165-supportsInterface}.
535    */
536   function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537       return interfaceId == type(IERC165).interfaceId;
538   }
539 }
540 
541 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
542     using Address for address;
543     using Strings for uint256;
544 
545     // Token name
546     string private _name;
547 
548     // Token symbol
549     string private _symbol;
550 
551     // Mapping from token ID to owner address
552     mapping(uint256 => address) private _owners;
553 
554     // Mapping owner address to token count
555     mapping(address => uint256) private _balances;
556 
557     // Mapping from token ID to approved address
558     mapping(uint256 => address) private _tokenApprovals;
559 
560     // Mapping from owner to operator approvals
561     mapping(address => mapping(address => bool)) private _operatorApprovals;
562 
563     /**
564      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
565      */
566     constructor(string memory name_, string memory symbol_) {
567         _name = name_;
568         _symbol = symbol_;
569     }
570 
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
575         return
576             interfaceId == type(IERC721).interfaceId ||
577             interfaceId == type(IERC721Metadata).interfaceId ||
578             super.supportsInterface(interfaceId);
579     }
580 
581     /**
582      * @dev See {IERC721-balanceOf}.
583      */
584     function balanceOf(address owner) public view virtual override returns (uint256) {
585         require(owner != address(0), "ERC721: balance query for the zero address");
586         return _balances[owner];
587     }
588 
589     /**
590      * @dev See {IERC721-ownerOf}.
591      */
592     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
593         address owner = _owners[tokenId];
594         require(owner != address(0), "ERC721: owner query for nonexistent token");
595         return owner;
596     }
597 
598     /**
599      * @dev See {IERC721Metadata-name}.
600      */
601     function name() public view virtual override returns (string memory) {
602         return _name;
603     }
604 
605     /**
606      * @dev See {IERC721Metadata-symbol}.
607      */
608     function symbol() public view virtual override returns (string memory) {
609         return _symbol;
610     }
611 
612     /**
613      * @dev See {IERC721Metadata-tokenURI}.
614      */
615     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
616         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
617 
618         string memory baseURI = _baseURI();
619         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
620     }
621 
622     /**
623      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
624      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
625      * by default, can be overriden in child contracts.
626      */
627     function _baseURI() internal view virtual returns (string memory) {
628         return "";
629     }
630 
631     /**
632      * @dev See {IERC721-approve}.
633      */
634     function approve(address to, uint256 tokenId) public virtual override {
635         address owner = ERC721.ownerOf(tokenId);
636         require(to != owner, "ERC721: approval to current owner");
637 
638         require(
639             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
640             "ERC721: approve caller is not owner nor approved for all"
641         );
642 
643         _approve(to, tokenId);
644     }
645 
646     /**
647      * @dev See {IERC721-getApproved}.
648      */
649     function getApproved(uint256 tokenId) public view virtual override returns (address) {
650         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
651 
652         return _tokenApprovals[tokenId];
653     }
654 
655     /**
656      * @dev See {IERC721-setApprovalForAll}.
657      */
658     function setApprovalForAll(address operator, bool approved) public virtual override {
659         require(operator != _msgSender(), "ERC721: approve to caller");
660 
661         _operatorApprovals[_msgSender()][operator] = approved;
662         emit ApprovalForAll(_msgSender(), operator, approved);
663     }
664 
665     /**
666      * @dev See {IERC721-isApprovedForAll}.
667      */
668     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
669         return _operatorApprovals[owner][operator];
670     }
671 
672     /**
673      * @dev See {IERC721-transferFrom}.
674      */
675     function transferFrom(
676         address from,
677         address to,
678         uint256 tokenId
679     ) public virtual override {
680         //solhint-disable-next-line max-line-length
681         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
682 
683         _transfer(from, to, tokenId);
684     }
685 
686     /**
687      * @dev See {IERC721-safeTransferFrom}.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId
693     ) public virtual override {
694         safeTransferFrom(from, to, tokenId, "");
695     }
696 
697     /**
698      * @dev See {IERC721-safeTransferFrom}.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 tokenId,
704         bytes memory _data
705     ) public virtual override {
706         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
707         _safeTransfer(from, to, tokenId, _data);
708     }
709 
710     /**
711      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
712      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
713      *
714      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
715      *
716      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
717      * implement alternative mechanisms to perform token transfer, such as signature-based.
718      *
719      * Requirements:
720      *
721      * - `from` cannot be the zero address.
722      * - `to` cannot be the zero address.
723      * - `tokenId` token must exist and be owned by `from`.
724      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
725      *
726      * Emits a {Transfer} event.
727      */
728     function _safeTransfer(
729         address from,
730         address to,
731         uint256 tokenId,
732         bytes memory _data
733     ) internal virtual {
734         _transfer(from, to, tokenId);
735         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
736     }
737 
738     /**
739      * @dev Returns whether `tokenId` exists.
740      *
741      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
742      *
743      * Tokens start existing when they are minted (`_mint`),
744      * and stop existing when they are burned (`_burn`).
745      */
746     function _exists(uint256 tokenId) internal view virtual returns (bool) {
747         return _owners[tokenId] != address(0);
748     }
749 
750     /**
751      * @dev Returns whether `spender` is allowed to manage `tokenId`.
752      *
753      * Requirements:
754      *
755      * - `tokenId` must exist.
756      */
757     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
758         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
759         address owner = ERC721.ownerOf(tokenId);
760         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
761     }
762 
763     /**
764      * @dev Safely mints `tokenId` and transfers it to `to`.
765      *
766      * Requirements:
767      *
768      * - `tokenId` must not exist.
769      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
770      *
771      * Emits a {Transfer} event.
772      */
773     function _safeMint(address to, uint256 tokenId) internal virtual {
774         _safeMint(to, tokenId, "");
775     }
776 
777     /**
778      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
779      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
780      */
781     function _safeMint(
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) internal virtual {
786         _mint(to, tokenId);
787         require(
788             _checkOnERC721Received(address(0), to, tokenId, _data),
789             "ERC721: transfer to non ERC721Receiver implementer"
790         );
791     }
792 
793     /**
794      * @dev Mints `tokenId` and transfers it to `to`.
795      *
796      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
797      *
798      * Requirements:
799      *
800      * - `tokenId` must not exist.
801      * - `to` cannot be the zero address.
802      *
803      * Emits a {Transfer} event.
804      */
805     function _mint(address to, uint256 tokenId) internal virtual {
806         require(to != address(0), "ERC721: mint to the zero address");
807         require(!_exists(tokenId), "ERC721: token already minted");
808 
809         _beforeTokenTransfer(address(0), to, tokenId);
810 
811         _balances[to] += 1;
812         _owners[tokenId] = to;
813 
814         emit Transfer(address(0), to, tokenId);
815     }
816 
817     /**
818      * @dev Destroys `tokenId`.
819      * The approval is cleared when the token is burned.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _burn(uint256 tokenId) internal virtual {
828         address owner = ERC721.ownerOf(tokenId);
829 
830         _beforeTokenTransfer(owner, address(0), tokenId);
831 
832         // Clear approvals
833         _approve(address(0), tokenId);
834 
835         _balances[owner] -= 1;
836         delete _owners[tokenId];
837 
838         emit Transfer(owner, address(0), tokenId);
839     }
840 
841     /**
842      * @dev Transfers `tokenId` from `from` to `to`.
843      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
844      *
845      * Requirements:
846      *
847      * - `to` cannot be the zero address.
848      * - `tokenId` token must be owned by `from`.
849      *
850      * Emits a {Transfer} event.
851      */
852     function _transfer(
853         address from,
854         address to,
855         uint256 tokenId
856     ) internal virtual {
857         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
858         require(to != address(0), "ERC721: transfer to the zero address");
859 
860         _beforeTokenTransfer(from, to, tokenId);
861 
862         // Clear approvals from the previous owner
863         _approve(address(0), tokenId);
864 
865         _balances[from] -= 1;
866         _balances[to] += 1;
867         _owners[tokenId] = to;
868 
869         emit Transfer(from, to, tokenId);
870     }
871 
872     /**
873      * @dev Approve `to` to operate on `tokenId`
874      *
875      * Emits a {Approval} event.
876      */
877     function _approve(address to, uint256 tokenId) internal virtual {
878         _tokenApprovals[tokenId] = to;
879         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
880     }
881 
882     /**
883      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
884      * The call is not executed if the target address is not a contract.
885      *
886      * @param from address representing the previous owner of the given token ID
887      * @param to target address that will receive the tokens
888      * @param tokenId uint256 ID of the token to be transferred
889      * @param _data bytes optional data to send along with the call
890      * @return bool whether the call correctly returned the expected magic value
891      */
892     function _checkOnERC721Received(
893         address from,
894         address to,
895         uint256 tokenId,
896         bytes memory _data
897     ) private returns (bool) {
898         if (to.isContract()) {
899             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
900                 return retval == IERC721Receiver.onERC721Received.selector;
901             } catch (bytes memory reason) {
902                 if (reason.length == 0) {
903                     revert("ERC721: transfer to non ERC721Receiver implementer");
904                 } else {
905                     assembly {
906                         revert(add(32, reason), mload(reason))
907                     }
908                 }
909             }
910         } else {
911             return true;
912         }
913     }
914 
915     /**
916      * @dev Hook that is called before any token transfer. This includes minting
917      * and burning.
918      *
919      * Calling conditions:
920      *
921      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
922      * transferred to `to`.
923      * - When `from` is zero, `tokenId` will be minted for `to`.
924      * - When `to` is zero, ``from``'s `tokenId` will be burned.
925      * - `from` and `to` are never both zero.
926      *
927      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
928      */
929     function _beforeTokenTransfer(
930         address from,
931         address to,
932         uint256 tokenId
933     ) internal virtual {}
934 }
935 
936 contract DateTime {
937     /*
938      *  Date and Time utilities for ethereum contracts
939      *
940      */
941     struct _DateTime {
942         uint16 year;
943         uint8 month;
944         uint8 day;
945         uint8 hour;
946         uint8 minute;
947         uint8 second;
948         uint8 weekday;
949     }
950 
951     uint constant DAY_IN_SECONDS = 86400;
952     uint constant YEAR_IN_SECONDS = 31536000;
953     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
954 
955     uint constant HOUR_IN_SECONDS = 3600;
956     uint constant MINUTE_IN_SECONDS = 60;
957 
958     uint16 constant ORIGIN_YEAR = 1970;
959 
960     function isLeapYear(uint16 year) public pure returns (bool) {
961         if (year % 4 != 0) {
962             return false;
963         }
964         if (year % 100 != 0) {
965             return true;
966         }
967         if (year % 400 != 0) {
968             return false;
969         }
970         return true;
971     }
972 
973     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
974         uint16 i;
975 
976         // Year
977         for (i = ORIGIN_YEAR; i < year; i++) {
978             if (isLeapYear(i)) {
979                 timestamp += LEAP_YEAR_IN_SECONDS;
980             }
981             else {
982                 timestamp += YEAR_IN_SECONDS;
983             }
984         }
985 
986         // Month
987         uint8[12] memory monthDayCounts;
988         monthDayCounts[0] = 31;
989         if (isLeapYear(year)) {
990             monthDayCounts[1] = 29;
991         }
992         else {
993             monthDayCounts[1] = 28;
994         }
995         monthDayCounts[2] = 31;
996         monthDayCounts[3] = 30;
997         monthDayCounts[4] = 31;
998         monthDayCounts[5] = 30;
999         monthDayCounts[6] = 31;
1000         monthDayCounts[7] = 31;
1001         monthDayCounts[8] = 30;
1002         monthDayCounts[9] = 31;
1003         monthDayCounts[10] = 30;
1004         monthDayCounts[11] = 31;
1005 
1006         for (i = 1; i < month; i++) {
1007                 timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
1008         }
1009 
1010         // Day
1011         timestamp += DAY_IN_SECONDS * (day - 1);
1012 
1013         // Hour
1014         timestamp += HOUR_IN_SECONDS * (hour);
1015 
1016         // Minute
1017         timestamp += MINUTE_IN_SECONDS * (minute);
1018 
1019         // Second
1020         timestamp += second;
1021 
1022         return timestamp;
1023     }
1024 }
1025 
1026 
1027 /**
1028  * @dev These functions deal with verification of Merkle Trees proofs.
1029  *
1030  * The proofs can be generated using the JavaScript library
1031  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1032  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1033  *
1034  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1035  */
1036 library MerkleProof {
1037     /**
1038      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1039      * defined by `root`. For this, a `proof` must be provided, containing
1040      * sibling hashes on the branch from the leaf to the root of the tree. Each
1041      * pair of leaves and each pair of pre-images are assumed to be sorted.
1042      */
1043     function verify(
1044         bytes32[] memory proof,
1045         bytes32 root,
1046         bytes32 leaf
1047     ) internal pure returns (bool) {
1048         bytes32 computedHash = leaf;
1049 
1050         for (uint256 i = 0; i < proof.length; i++) {
1051             bytes32 proofElement = proof[i];
1052 
1053             if (computedHash <= proofElement) {
1054                 // Hash(current computed hash + current element of the proof)
1055                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1056             } else {
1057                 // Hash(current element of the proof + current computed hash)
1058                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1059             }
1060         }
1061 
1062         // Check if the computed hash (root) is equal to the provided root
1063         return computedHash == root;
1064     }
1065 }
1066 
1067 contract JiggyContract is ERC721, Ownable, DateTime {
1068   using Strings for uint256;
1069 
1070   bool public paused = false;
1071   string public baseURI;
1072   string public baseExtension = ".json";
1073   string public provenance = "5b148e4acb30bb01835052b6c9728318d5e808fd";
1074   uint256 public cost = 0.077 ether;
1075   uint256 public maxSupply = 9444;
1076   uint256 public maxMintAmount = 2;
1077   uint256 public tokenId = 0;
1078   uint256 public initialTokenId = 0;
1079   bytes32 private _allowListRoot;
1080   mapping(address => uint256) public _mintbalances;
1081 
1082   _DateTime public mintDate;
1083   _DateTime public wMintDate;
1084 
1085   constructor(
1086     string memory _initBaseURI
1087   ) ERC721("JiggyVerse", "JIGGY") {
1088     setBaseURI(_initBaseURI);
1089     setWMintDate(2022, 1, 28, 22, 0);
1090     setMintDate(2022, 1, 29, 19, 0);
1091   }
1092 
1093   //public dates 
1094   function mintable() public view returns (bool) {
1095       return !paused && block.timestamp >= toTimestamp(mintDate.year, mintDate.month, mintDate.day, mintDate.hour, mintDate.minute, mintDate.second);
1096   }
1097   
1098   function wMintable() public view returns (bool) {
1099       return !paused && block.timestamp >= toTimestamp(wMintDate.year, wMintDate.month, wMintDate.day, wMintDate.hour, wMintDate.minute, wMintDate.second);
1100   }
1101 
1102   // internal
1103   function _baseURI() internal view virtual override returns (string memory) {
1104     return baseURI;
1105   }
1106 
1107   function mintInternal(address _to, uint256 _mintAmount) internal {
1108     require(!paused, "Jiggy: Jiggy contract is paused");
1109     require(tokenId + _mintAmount <= maxSupply, "Jiggy: Remain jiggys is not enough");
1110     for (uint256 i = 1; i <= _mintAmount; i++) {
1111       _safeMint(_to, tokenId + i);
1112     }
1113     tokenId += _mintAmount;
1114   }
1115 
1116   function _leaf(address account) internal pure returns (bytes32) {
1117     return keccak256(abi.encodePacked(account));
1118   }
1119 
1120   function _verify(bytes32 _leafNode, bytes32[] memory proof) internal view returns (bool) {
1121     return MerkleProof.verify(proof, _allowListRoot, _leafNode);
1122   }
1123 
1124   // public
1125   function mint(uint16 _mintAmount) public payable {
1126     require(msg.value >= cost * _mintAmount, "Jiggy: Not enough ETH to mint");
1127     require(_mintAmount <= maxMintAmount, string(abi.encodePacked("Jiggy: Can not mint more than ", maxMintAmount.toString(), " Jiggys")));
1128     require(mintable(), "Jiggy: Public mint is not active yet");
1129     mintInternal(msg.sender, _mintAmount);
1130     _mintbalances[msg.sender] += _mintAmount;
1131     require(_mintbalances[msg.sender] < 5, "Jiggy: User can only mint a maximum of 4 NFT");
1132   }
1133 
1134   function mintByAllowList(uint16 _mintAmount, bytes32[] calldata proof) public payable {
1135     require(_verify(_leaf(msg.sender), proof), "Jiggy: Address is not on whitelist");
1136     require(msg.value >= cost * _mintAmount, "Jiggy: Not enough ETH to mint");
1137     require(_mintAmount <= maxMintAmount, string(abi.encodePacked("Jiggy: Can not mint more than ", maxMintAmount.toString(), " Jiggys"))); //you change in one minute
1138     require(wMintable(), "Jiggy: Presale mint is not active yet");
1139     mintInternal(msg.sender, _mintAmount);
1140     _mintbalances[msg.sender] += _mintAmount;
1141     require(_mintbalances[msg.sender] < 3, "Jiggy: User can only mint a maximum of 2 NFT in whitelist");
1142   } 
1143 
1144   function tokenURI(uint256 _tokenId)
1145     public
1146     view
1147     virtual
1148     override
1149     returns (string memory)
1150   {
1151     require(
1152       _exists(_tokenId),
1153       "ERC721Metadata: URI query for nonexistent token"
1154     );
1155 
1156     string memory currentBaseURI = _baseURI();
1157     
1158     uint256 finalTotenId = _tokenId;
1159     if (initialTokenId > 0) {
1160       finalTotenId = (_tokenId + initialTokenId - 1) % maxSupply + 1;
1161     }
1162     return
1163       bytes(currentBaseURI).length > 0
1164         ? string(
1165           abi.encodePacked(currentBaseURI, finalTotenId.toString(), baseExtension)
1166         )
1167         : "";
1168   }
1169 
1170   function balance() public view returns (uint256) {
1171     return address(this).balance;
1172   }
1173 
1174   function burn(uint256 _tokenId) public {
1175     require(ownerOf(_tokenId) == msg.sender, "### Jiggy: You are not the owner of this nft.");
1176     _burn(_tokenId);
1177   }
1178 
1179   function totalSupply() public view returns (uint256) {
1180     return tokenId;
1181   }
1182 
1183   //only owner
1184   function setCost(uint256 _newCost) public onlyOwner {
1185     cost = _newCost;
1186   }
1187 
1188   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1189     maxMintAmount = _newmaxMintAmount;
1190   }
1191 
1192   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1193     baseURI = _newBaseURI;
1194   }
1195 
1196   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1197     baseExtension = _newBaseExtension;
1198   }
1199 
1200   function setMaxSupply(uint256 _newMaxSupply) public onlyOwner {
1201     maxSupply = _newMaxSupply;
1202   }
1203 
1204   function pause(bool _state) public onlyOwner {
1205     paused = _state;
1206   }
1207 
1208   function withdraw() public payable onlyOwner {
1209     require(payable(msg.sender).send(address(this).balance));
1210   }
1211 
1212   function mintOwner(uint256 _mintAmount) public onlyOwner {
1213     mintInternal(msg.sender, _mintAmount);
1214   }
1215 
1216   function setInitialTokenId() public onlyOwner {
1217     require(initialTokenId <= 0, "Starting index is already set");
1218     initialTokenId = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp, msg.sender))) % maxSupply + 1;
1219   }
1220 
1221   function setMintDate(uint16 _year, uint8 _month, uint8 _day, uint8 _hour, uint8 _minute) public onlyOwner {
1222     mintDate.year = _year;
1223     mintDate.month = _month;
1224     mintDate.day = _day;
1225     mintDate.hour = _hour;
1226     mintDate.minute = _minute;
1227     mintDate.second = 0;
1228   }
1229 
1230   function setWMintDate(uint16 _year, uint8 _month, uint8 _day, uint8 _hour, uint8 _minute) public onlyOwner {
1231     wMintDate.year = _year;
1232     wMintDate.month = _month;
1233     wMintDate.day = _day;
1234     wMintDate.hour = _hour;
1235     wMintDate.minute = _minute;
1236     wMintDate.second = 0;
1237   }
1238   
1239   function setAllowListRoot(bytes32 _root) public onlyOwner {
1240     _allowListRoot = _root;
1241   }
1242 }