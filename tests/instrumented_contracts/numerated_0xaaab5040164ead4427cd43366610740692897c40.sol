1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.14;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 
69 /**
70  * @dev Collection of functions related to the address type
71  */
72 library Address {
73     /**
74      * @dev Returns true if `account` is a contract.
75      *
76      * [IMPORTANT]
77      * ====
78      * It is unsafe to assume that an address for which this function returns
79      * false is an externally-owned account (EOA) and not a contract.
80      *
81      * Among others, `isContract` will return false for the following
82      * types of addresses:
83      *
84      *  - an externally-owned account
85      *  - a contract in construction
86      *  - an address where a contract will be created
87      *  - an address where a contract lived, but was destroyed
88      * ====
89      *
90      * [IMPORTANT]
91      * ====
92      * You shouldn't rely on `isContract` to protect against flash loan attacks!
93      *
94      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
95      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
96      * constructor.
97      * ====
98      */
99     function isContract(address account) internal view returns (bool) {
100         // This method relies on extcodesize/address.code.length, which returns 0
101         // for contracts in construction, since the code is only stored at the end
102         // of the constructor execution.
103 
104         return account.code.length > 0;
105     }
106 
107     /**
108      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
109      * `recipient`, forwarding all available gas and reverting on errors.
110      *
111      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
112      * of certain opcodes, possibly making contracts go over the 2300 gas limit
113      * imposed by `transfer`, making them unable to receive funds via
114      * `transfer`. {sendValue} removes this limitation.
115      *
116      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
117      *
118      * IMPORTANT: because control is transferred to `recipient`, care must be
119      * taken to not create reentrancy vulnerabilities. Consider using
120      * {ReentrancyGuard} or the
121      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
122      */
123     function sendValue(address payable recipient, uint256 amount) internal {
124         require(address(this).balance >= amount, "Address: insufficient balance");
125 
126         (bool success, ) = recipient.call{value: amount}("");
127         require(success, "Address: unable to send value, recipient may have reverted");
128     }
129 
130     /**
131      * @dev Performs a Solidity function call using a low level `call`. A
132      * plain `call` is an unsafe replacement for a function call: use this
133      * function instead.
134      *
135      * If `target` reverts with a revert reason, it is bubbled up by this
136      * function (like regular Solidity function calls).
137      *
138      * Returns the raw returned data. To convert to the expected return value,
139      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
140      *
141      * Requirements:
142      *
143      * - `target` must be a contract.
144      * - calling `target` with `data` must not revert.
145      *
146      * _Available since v3.1._
147      */
148     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
149         return functionCall(target, data, "Address: low-level call failed");
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
154      * `errorMessage` as a fallback revert reason when `target` reverts.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(
159         address target,
160         bytes memory data,
161         string memory errorMessage
162     ) internal returns (bytes memory) {
163         return functionCallWithValue(target, data, 0, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but also transferring `value` wei to `target`.
169      *
170      * Requirements:
171      *
172      * - the calling contract must have an ETH balance of at least `value`.
173      * - the called Solidity function must be `payable`.
174      *
175      * _Available since v3.1._
176      */
177     function functionCallWithValue(
178         address target,
179         bytes memory data,
180         uint256 value
181     ) internal returns (bytes memory) {
182         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
187      * with `errorMessage` as a fallback revert reason when `target` reverts.
188      *
189      * _Available since v3.1._
190      */
191     function functionCallWithValue(
192         address target,
193         bytes memory data,
194         uint256 value,
195         string memory errorMessage
196     ) internal returns (bytes memory) {
197         require(address(this).balance >= value, "Address: insufficient balance for call");
198         require(isContract(target), "Address: call to non-contract");
199 
200         (bool success, bytes memory returndata) = target.call{value: value}(data);
201         return verifyCallResult(success, returndata, errorMessage);
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
206      * but performing a static call.
207      *
208      * _Available since v3.3._
209      */
210     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
211         return functionStaticCall(target, data, "Address: low-level static call failed");
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
216      * but performing a static call.
217      *
218      * _Available since v3.3._
219      */
220     function functionStaticCall(
221         address target,
222         bytes memory data,
223         string memory errorMessage
224     ) internal view returns (bytes memory) {
225         require(isContract(target), "Address: static call to non-contract");
226 
227         (bool success, bytes memory returndata) = target.staticcall(data);
228         return verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but performing a delegate call.
234      *
235      * _Available since v3.4._
236      */
237     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
238         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.4._
246      */
247     function functionDelegateCall(
248         address target,
249         bytes memory data,
250         string memory errorMessage
251     ) internal returns (bytes memory) {
252         require(isContract(target), "Address: delegate call to non-contract");
253 
254         (bool success, bytes memory returndata) = target.delegatecall(data);
255         return verifyCallResult(success, returndata, errorMessage);
256     }
257 
258     /**
259      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
260      * revert reason using the provided one.
261      *
262      * _Available since v4.3._
263      */
264     function verifyCallResult(
265         bool success,
266         bytes memory returndata,
267         string memory errorMessage
268     ) internal pure returns (bytes memory) {
269         if (success) {
270             return returndata;
271         } else {
272             // Look for revert reason and bubble it up if present
273             if (returndata.length > 0) {
274                 // The easiest way to bubble the revert reason is using memory via assembly
275 
276                 assembly {
277                     let returndata_size := mload(returndata)
278                     revert(add(32, returndata), returndata_size)
279                 }
280             } else {
281                 revert(errorMessage);
282             }
283         }
284     }
285 }
286 
287 interface ERC721TokenReceiver {
288     function onERC721Received(address operator,address from, uint256 id, bytes calldata data) external returns (bytes4);
289 }
290 
291 /**
292  * Built to optimize for lower gas during batch mints and transfers. 
293  * A new locking mechanism has been added to protect users from all attempted scams.
294  *
295  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
296  *
297  */
298 abstract contract ERC721slimBatch {
299     using Address for address;
300     using Strings for uint256;
301 
302     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
303     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
304     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
305     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
306 
307     struct collectionData {
308         string name;
309         string symbol;
310         uint256 index;
311         uint256 burned;
312     }
313 
314     address private _contractOwner;
315     collectionData internal _collectionData;
316     mapping(uint256 => address) internal _ownerships;
317     mapping(address => uint256) internal _addressData;
318     mapping(uint256 => address) internal _tokenApprovals;
319     mapping(address => mapping(address => bool)) private  _operatorApprovals;
320 
321     constructor(string memory _name, string memory _symbol) {
322         _collectionData.name = _name;
323         _collectionData.symbol = _symbol;
324         _transferOwnership(_msgSender());
325     }
326 
327     function _msgSender() internal view virtual returns (address) {
328         return msg.sender;
329     }
330 
331     /**
332      * @dev Returns whether `tokenId` exists.
333      *
334      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
335      *
336      * Tokens start existing when they are minted (`_mint` or `_safeMint`),
337      */
338     function _exists(uint256 tokenId) public view virtual returns (bool) {
339         return tokenId < _collectionData.index;
340     }
341 
342     /**
343      * @dev Returns the owner of the `tokenId` token.
344      *
345      * Requirements:
346      *
347      * - `tokenId` must exist.
348      */
349     function ownerOf(uint256 tokenId) public view virtual returns (address) {
350         unchecked {
351             if (tokenId < _collectionData.index) {
352                 address ownership = _ownerships[tokenId];
353                 if (ownership != address(0)) {
354                     return ownership;
355                 }
356                     while (true) {
357                         tokenId--;
358                         ownership = _ownerships[tokenId];
359 
360                         if (ownership != address(0)) {
361                             return ownership;
362                         }
363                          
364                     }
365                 }
366             }
367 
368         revert ();
369     }
370 
371     /**
372      * @dev Returns the number of tokens in `_owner`'s account.
373      */
374     function balanceOf(address _owner) public view returns (uint256) {
375         require(_owner != address(0), "Address 0");
376         return _addressData[_owner];
377     }
378 
379     /**
380      * @dev Mints `quantity` tokens and transfers them to `to`.
381      *
382      * Requirements:
383      *
384      * - `to` cannot be the zero address.
385      *
386      * Emits a {Transfer} event.
387      */
388     function _mint(address to, uint256 quantity) internal {
389         require(to != address(0), "Address 0");
390         require(quantity > 0, "Quantity 0");
391 
392         unchecked {
393             uint256 updatedIndex = _collectionData.index;
394             _addressData[to] += quantity;
395             _ownerships[updatedIndex] = to;
396             
397             for (uint256 i; i < quantity; i++) {
398                 emit Transfer(address(0), to, updatedIndex++);
399             }
400 
401             _collectionData.index = updatedIndex;
402         }
403     }
404 
405     /**
406      * @dev See Below {ERC721L-_safeMint}.
407      */
408     function _safeMint(address to, uint256 quantity) internal {
409         _safeMint(to, quantity, '');
410     }
411 
412     /**
413      * @dev Safely mints `quantity` tokens and transfers them to `to`.
414      *
415      * Requirements:
416      *
417      * - `to` cannot be the zero address.
418      * - If `to` refers to a smart contract, it must implement {onERC721Received}, which is called for each safe transfer.
419      *
420      * Emits a {Transfer} event.
421      */
422     function _safeMint(address to, uint256 quantity, bytes memory _data) internal {
423         require(to != address(0), "Address 0");
424         require(quantity > 0, "Quantity 0");
425 
426         unchecked {
427             uint256 updatedIndex = _collectionData.index;
428             _addressData[to] += quantity;
429             _ownerships[updatedIndex] = to;
430             
431             for (uint256 i; i < quantity; i++) {
432                 emit Transfer(address(0), to, updatedIndex);
433                 require(to.code.length == 0 ||
434                         ERC721TokenReceiver(to).onERC721Received(_msgSender(), address(0), updatedIndex, _data) ==
435                         ERC721TokenReceiver.onERC721Received.selector, "Unsafe Destination");
436                 updatedIndex++;
437             }
438 
439             _collectionData.index = updatedIndex;
440         }
441     }
442 
443     /**
444      * @dev Transfers `tokenId` from `from` to `to`.
445      *
446      * Requirements:
447      *
448      * - `to` cannot be the zero address.
449      * - `tokenId` token must be owned by `from`.
450      * - `from` must not have tokens locked.
451      *
452      * Emits a {Transfer} event.
453      */
454     function transferFrom(address from, address to, uint256 tokenId) public virtual {
455         address currentOwner = ownerOf(tokenId);
456         require((_msgSender() == currentOwner ||
457             getApproved(tokenId) == _msgSender() ||
458             isApprovedForAll(currentOwner,_msgSender())), "Not Approved");
459         require(currentOwner == from, "Not Owner");
460         require(to != address(0), "Address 0");
461 
462         delete _tokenApprovals[tokenId]; 
463         unchecked {
464             _addressData[from] -= 1;
465             _addressData[to] += 1;
466             _ownerships[tokenId] = to;
467             uint256 nextTokenId = tokenId + 1;
468             if (_ownerships[nextTokenId] == address(0) && nextTokenId < _collectionData.index) {
469                 _ownerships[nextTokenId] = currentOwner;
470             }
471         }
472 
473         emit Transfer(from, to, tokenId);
474     }
475 
476     /**
477      * @dev See Below {ERC721L-safeTransferFrom}.
478      */
479     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual {
480         safeTransferFrom(from, to, tokenId, '');
481     }
482 
483     /**
484      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
485      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
486      *
487      * Requirements:
488      *
489      * - `from` cannot be the zero address.
490      * - `to` cannot be the zero address.
491      * - `tokenId` token must exist and be owned by `from`.
492      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
493      * - If `to` refers to a smart contract, it must implement {ERC721TokenReceiver}, which is called upon a safe transfer.
494      * - `from` must not have tokens locked.
495      *
496      * Emits a {Transfer} event.
497      */
498     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual {
499         transferFrom(from, to, tokenId);
500         require(to.code.length == 0 ||
501                 ERC721TokenReceiver(to).onERC721Received(_msgSender(), address(0), tokenId, _data) ==
502                 ERC721TokenReceiver.onERC721Received.selector, "Unsafe Destination");
503     }
504     
505     /**
506      * @dev Returns the total amount of tokens stored by the contract.
507      */
508     function totalSupply() public view returns (uint256) {
509         unchecked {
510             return _collectionData.index - _collectionData.burned;
511         }
512     }
513 
514     /**
515      * @dev Returns the total amount of tokens created by the contract.
516      */
517     function totalCreated() public view returns (uint256) {
518         return _collectionData.index;
519     }
520 
521     /**
522      * @dev Returns the total amount of tokens burned by the contract.
523      */
524     function totalBurned() public view returns (uint256) {
525         return _collectionData.burned;
526     }
527 
528     /**
529      * @dev Approve or remove `operator` as an operator for the caller.
530      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
531      *
532      * Requirements:
533      *
534      * - The `operator` cannot be the caller.
535      * - Owner must not have tokens locked.
536      *
537      * Emits an {ApprovalForAll} event.
538      */
539     function setApprovalForAll(address operator, bool approved) public {
540         require(operator != _msgSender(), "Address is Owner");
541 
542         _operatorApprovals[_msgSender()][operator] = approved;
543         emit ApprovalForAll(_msgSender(), operator, approved);
544     }
545 
546     /**
547      * @dev Returns if the `operator` is allowed to manage all of the assets of `_owner` and tokens are unlocked for `_owner`.
548      *
549      * See {setApprovalForAll}
550      */
551     function isApprovedForAll(address _owner, address operator) public view returns (bool) {
552         return _operatorApprovals[_owner][operator];
553     }
554 
555     /**
556      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
557      * The approval is cleared when the token is transferred.
558      *
559      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
560      *
561      * Requirements:
562      *
563      * - The caller must own the token or be an approved operator.
564      * - `tokenId` must exist.
565      *
566      * Emits an {Approval} event.
567      */
568     function approve(address to, uint256 tokenId) public {
569         address tokenOwner = ownerOf(tokenId);
570         require(_msgSender() == tokenOwner || isApprovedForAll(tokenOwner, _msgSender()), "ERC721L: Not Approved");
571         _tokenApprovals[tokenId] = to;
572         emit Approval(tokenOwner, to, tokenId);
573     }
574 
575     /**
576      * @dev Returns the account approved for `tokenId` token.
577      *
578      * Requirements:
579      *
580      * - `tokenId` must exist.
581      */
582     function getApproved(uint256 tokenId) public view returns (address) {
583         require(_exists(tokenId), "ERC721L: Null ID");
584         return _tokenApprovals[tokenId];
585     }
586 
587     /**
588      * @dev Returns the token collection name.
589      */
590     function name() public view returns (string memory) {
591         return _collectionData.name;
592     }
593 
594     /**
595      * @dev Returns the token collection symbol.
596      */
597     function symbol() public view returns (string memory) {
598         return _collectionData.symbol;
599     }
600 
601     /**
602      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
603      */
604     function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
605         require(_exists(tokenId), "Non Existent");
606         string memory _baseURI = baseURI();
607         return bytes(_baseURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenId.toString())) : '';
608     }
609 
610     /**
611      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
612      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
613      * by default, can be overriden in child contracts.
614      */
615     function baseURI() public view virtual returns (string memory) {
616         return '';
617     }
618 
619     /**
620      * @dev Returns tokenIDs owned by `_owner`.
621      */
622     function tokensOfOwner(address _owner) public view returns (uint256[] memory) {
623         uint256 totalOwned = _addressData[_owner];
624         require(totalOwned > 0, "balance 0");
625         uint256 supply = _collectionData.index;
626         uint256[] memory tokenIDs = new uint256[](totalOwned);
627         uint256 ownedIndex;
628         address currentOwner;
629 
630         unchecked {
631             for (uint256 i; i < supply; i++) {
632                 address currentAddress = _ownerships[i];
633                 if (currentAddress != address(0)) {
634                     currentOwner = currentAddress;
635                 }
636                 if (currentOwner == _owner) {
637                     tokenIDs[ownedIndex++] = i;
638                     if (ownedIndex == totalOwned){
639                         return tokenIDs;
640                     }
641                 }
642             }
643         }
644 
645         revert();
646     }
647 
648     function owner() public view returns (address) {
649         return _contractOwner;
650     }
651 
652     modifier onlyOwner() {
653         require(owner() == _msgSender(), "Caller not owner");
654         _;
655     }
656 
657     function renounceOwnership() public virtual onlyOwner {
658         _transferOwnership(address(0));
659     }
660 
661     function transferOwnership(address newOwner) public onlyOwner {
662         require(newOwner != address(0), "Zero address");
663         _transferOwnership(newOwner);
664     }
665 
666     function _transferOwnership(address newOwner) internal {
667         address oldOwner = _contractOwner;
668         _contractOwner = newOwner;
669         emit OwnershipTransferred(oldOwner, newOwner);
670     }
671 
672     /**
673      * @dev Returns the token collection information.
674      */
675     function collectionInformation() public view returns (collectionData memory) {
676         return _collectionData;
677     }
678 
679     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
680         return
681             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
682             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
683             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
684     }
685 
686 }
687 
688 interface IRocketPass {
689     function balanceOf(address _address, uint256 id) external view returns (uint256);
690 }
691 
692 
693 contract HASHDroid is ERC721slimBatch {
694 
695     string private _baseURI = "ipfs://QmZov5NNjcx472daCYvD3unxgWXQ1UJwYsAPr6yMFiJT5a/";
696     uint256 public constant maxPublicMinted = 2063;
697 
698     uint256 public publicMaxMint = 7;
699     uint256 public priceDroid = .069 ether;
700     uint256 public publicMinted;
701 
702     bool public depreciatedMint;
703     bool public mintStatus;
704     IRocketPass public rocketPass;
705 
706     mapping(address => uint256) public mintedRP;
707 
708   constructor(address _rocketPass) ERC721slimBatch("BMC Hashdroid", "HD") {
709       rocketPass = IRocketPass(_rocketPass);
710   }
711 
712   modifier callerIsUser() {
713     require(tx.origin == _msgSender(), "Contract Caller");
714     _;
715   }
716 
717   function rpMint(uint256 _quantity) public callerIsUser() {
718     require(mintStatus, "Public sale not active");
719     require(rocketPass.balanceOf(_msgSender(), 1) - mintedRP[_msgSender()] >= _quantity, "Insufficient Rocket Passes remaining");
720 
721     mintedRP[_msgSender()] += _quantity;
722     _mint(_msgSender(), _quantity);
723   }
724 
725   function publicMint(uint256 _quantity) public payable callerIsUser() {
726     require(mintStatus, "Public sale not active");
727     require(_quantity <= publicMaxMint, "Invalid quantity");
728     unchecked {
729         require(publicMinted + _quantity <= maxPublicMinted, "Insufficient supply remaining");
730         require(msg.value >= priceDroid * _quantity, "Insufficient payment");
731     }
732     publicMinted += _quantity;
733     _mint(_msgSender(), _quantity);
734   }
735 
736   function baseURI() public view override returns (string memory) {
737     return _baseURI;
738   }
739 
740   function setBaseURI(string calldata newBaseURI) external onlyOwner {
741     _baseURI = newBaseURI;
742   }
743 
744   function setRocketPass(address _address) external onlyOwner {
745     require(!depreciatedMint, "Contract is depreciated.");
746     rocketPass = IRocketPass(_address);
747   }
748 
749   function setPublicState(bool _state) external onlyOwner {
750     require(!depreciatedMint, "Contract is depreciated.");
751     mintStatus = _state;
752   }
753 
754   function setPublicMaxMint(uint256 _newLimit) external onlyOwner {
755     require(!depreciatedMint, "Contract is already depreciated.");
756     publicMaxMint = _newLimit;
757   }
758 
759   function depreciateMint() external onlyOwner {
760     require(!depreciatedMint, "Contract is already depreciated.");
761     delete mintStatus;
762     depreciatedMint = true;
763     uint256 excess = 7777 - totalSupply();
764     if (excess > 0){
765         uint256 droidsToMint = excess > 60 ? 60 : excess; 
766         _mint(_msgSender(), droidsToMint);
767     }
768     
769   }
770 
771   function verifyRP(address _address) external view returns (bool){
772     return (rocketPass.balanceOf(_address, 1) - mintedRP[_address]) > 0;
773   }
774 
775   function withdrawFunding() external onlyOwner {
776     uint256 currentBalance = address(this).balance;
777     (bool sent, ) = address(msg.sender).call{value: currentBalance}('');
778     require(sent, "Transfer Error");    
779   }
780 
781 }