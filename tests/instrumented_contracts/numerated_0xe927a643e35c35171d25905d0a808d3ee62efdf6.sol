1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 /* 
5 ⠀⠀⢀⣴⣶⣿⣿⣷⡶⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⢶⣿⣿⣿⣿⣶⣄⠀⠀
6 ⠀⢠⡿⠿⠿⠿⢿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⡿⠿⠿⠿⠿⣦⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣿⡿⠆⠀⠀⠀⠀⠰⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⣀⣤⡤⠄⢤⣀⡈⢿⡄⠀⠀⠀⠀⢠⡟⢁⣠⡤⠠⠤⢤⣀⠀⠀⠀⠀
9 ⠐⢄⣀⣼⢿⣾⣿⣿⣿⣷⣿⣆⠁⡆⠀⠀⢰⠈⢸⣿⣾⣿⣿⣿⣷⡮⣧⣀⡠⠀
10 ⠰⠛⠉⠙⠛⠶⠶⠏⠷⠛⠋⠁⢠⡇⠀⠀⢸⡄⠈⠛⠛⠿⠹⠿⠶⠚⠋⠉⠛⠆
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⡇⠀⠀⢸⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⢻⠇⠀⠀⠘⡟⠳⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠰⣄⡀⠀⠀⣀⣠⡤⠞⠠⠁⠀⢸⠀⠀⠀⠀⡇⠀⠘⠄⠳⢤⣀⣀⠀⠀⣀⣠⠀
14 ⠀⢻⣏⢻⣯⡉⠀⠀⠀⠀⠀⠒⢎⣓⠶⠶⣞⡱⠒⠀⠀⠀⠀⠀⢉⣽⡟⣹⡟⠀
15 ⠀⠀⢻⣆⠹⣿⣆⣀⣀⣀⣀⣴⣿⣿⠟⠻⣿⣿⣦⣀⣀⣀⣀⣰⣿⠟⣰⡟⠀⠀
16 ⠀⠀⠀⠻⣧⡘⠻⠿⠿⠿⠿⣿⣿⣃⣀⣀⣙⣿⣿⠿⠿⠿⠿⠟⢃⣴⠟⠀⠀⠀
17 ⠀⠀⠀⠀⠙⣮⠐⠤⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠤⠊⡵⠋⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠈⠳⡀⠀⠀⠀⠀⠀⠲⣶⣶⠖⠀⠀⠀⠀⠀⢀⠜⠁⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⢀⣿⣿⡀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
23 
24  */
25 
26 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
27 
28 pragma solidity >=0.7.0 <0.9.0;
29 
30 library Counters {
31     struct Counter {
32 
33         uint256 _value; // default: 0
34     }
35 
36     function current(Counter storage counter) internal view returns (uint256) {
37         return counter._value;
38     }
39 
40     function increment(Counter storage counter) internal {
41         unchecked {
42             counter._value += 1;
43         }
44     }
45 
46     function decrement(Counter storage counter) internal {
47         uint256 value = counter._value;
48         require(value > 0, "Counter: decrement overflow");
49         unchecked {
50             counter._value = value - 1;
51         }
52     }
53 
54     function reset(Counter storage counter) internal {
55         counter._value = 0;
56     }
57 }
58 
59 
60 
61 pragma solidity >=0.7.0 <0.9.0;
62 
63 /**
64  * @dev String operations.
65  */
66 library Strings {
67     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
71      */
72     function toString(uint256 value) internal pure returns (string memory) {
73 
74 
75         if (value == 0) {
76             return "0";
77         }
78         uint256 temp = value;
79         uint256 digits;
80         while (temp != 0) {
81             digits++;
82             temp /= 10;
83         }
84         bytes memory buffer = new bytes(digits);
85         while (value != 0) {
86             digits -= 1;
87             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
88             value /= 10;
89         }
90         return string(buffer);
91     }
92 
93     /**
94      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
95      */
96     function toHexString(uint256 value) internal pure returns (string memory) {
97         if (value == 0) {
98             return "0x00";
99         }
100         uint256 temp = value;
101         uint256 length = 0;
102         while (temp != 0) {
103             length++;
104             temp >>= 8;
105         }
106         return toHexString(value, length);
107     }
108 
109     /**
110      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
111      */
112     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
113         bytes memory buffer = new bytes(2 * length + 2);
114         buffer[0] = "0";
115         buffer[1] = "x";
116         for (uint256 i = 2 * length + 1; i > 1; --i) {
117             buffer[i] = _HEX_SYMBOLS[value & 0xf];
118             value >>= 4;
119         }
120         require(value == 0, "Strings: hex length insufficient");
121         return string(buffer);
122     }
123 }
124 
125 // File: @openzeppelin/contracts/utils/Context.sol
126 
127 
128 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
129 
130 pragma solidity >=0.7.0 <0.9.0;
131 
132 abstract contract Context {
133     function _msgSender() internal view virtual returns (address) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view virtual returns (bytes calldata) {
138         return msg.data;
139     }
140 }
141 
142 // File: @openzeppelin/contracts/access/Ownable.sol
143 
144 
145 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
146 
147 pragma solidity >=0.7.0 <0.9.0;
148 
149 
150 abstract contract Ownable is Context {
151     address private _owner;
152 
153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155     /**
156      * @dev Initializes the contract setting the deployer as the initial owner.
157      */
158     constructor() {
159         _transferOwnership(_msgSender());
160     }
161 
162     /**
163      * @dev Returns the address of the current owner.
164      */
165     function owner() public view virtual returns (address) {
166         return _owner;
167     }
168 
169     /**
170      * @dev Throws if called by any account other than the owner.
171      */
172     modifier onlyOwner() {
173         require(owner() == _msgSender(), "Ownable: caller is not the owner");
174         _;
175     }
176 
177     function renounceOwnership() public virtual onlyOwner {
178         _transferOwnership(address(0));
179     }
180 
181     /**
182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
183      * Can only be called by the current owner.
184      */
185     function transferOwnership(address newOwner) public virtual onlyOwner {
186         require(newOwner != address(0), "Ownable: new owner is the zero address");
187         _transferOwnership(newOwner);
188     }
189 
190     function _transferOwnership(address newOwner) internal virtual {
191         address oldOwner = _owner;
192         _owner = newOwner;
193         emit OwnershipTransferred(oldOwner, newOwner);
194     }
195 }
196 
197 // File: @openzeppelin/contracts/utils/Address.sol
198 
199 
200 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
201 
202 pragma solidity >=0.7.0 <0.9.0;
203 
204 /**
205  * @dev Collection of functions related to the address type
206  */
207 library Address {
208 
209     function isContract(address account) internal view returns (bool) {
210 
211 
212         uint256 size;
213         assembly {
214             size := extcodesize(account)
215         }
216         return size > 0;
217     }
218 
219     function sendValue(address payable recipient, uint256 amount) internal {
220         require(address(this).balance >= amount, "Address: insufficient balance");
221 
222         (bool success, ) = recipient.call{value: amount}("");
223         require(success, "Address: unable to send value, recipient may have reverted");
224     }
225 
226 
227     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
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
245 
246     function functionCallWithValue(
247         address target,
248         bytes memory data,
249         uint256 value
250     ) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
252     }
253 
254     function functionCallWithValue(
255         address target,
256         bytes memory data,
257         uint256 value,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         require(address(this).balance >= value, "Address: insufficient balance for call");
261         require(isContract(target), "Address: call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.call{value: value}(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267 
268     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
269         return functionStaticCall(target, data, "Address: low-level static call failed");
270     }
271 
272  
273     function functionStaticCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal view returns (bytes memory) {
278         require(isContract(target), "Address: static call to non-contract");
279 
280         (bool success, bytes memory returndata) = target.staticcall(data);
281         return verifyCallResult(success, returndata, errorMessage);
282     }
283 
284 
285     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
286         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
287     }
288 
289   
290     function functionDelegateCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         require(isContract(target), "Address: delegate call to non-contract");
296 
297         (bool success, bytes memory returndata) = target.delegatecall(data);
298         return verifyCallResult(success, returndata, errorMessage);
299     }
300 
301  
302     function verifyCallResult(
303         bool success,
304         bytes memory returndata,
305         string memory errorMessage
306     ) internal pure returns (bytes memory) {
307         if (success) {
308             return returndata;
309         } else {
310             // Look for revert reason and bubble it up if present
311             if (returndata.length > 0) {
312                 // The easiest way to bubble the revert reason is using memory via assembly
313 
314                 assembly {
315                     let returndata_size := mload(returndata)
316                     revert(add(32, returndata), returndata_size)
317                 }
318             } else {
319                 revert(errorMessage);
320             }
321         }
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
329 
330 pragma solidity >=0.7.0 <0.9.0;
331 
332 interface IERC721Receiver {
333 
334     function onERC721Received(
335         address operator,
336         address from,
337         uint256 tokenId,
338         bytes calldata data
339     ) external returns (bytes4);
340 }
341 
342 
343 
344 pragma solidity >=0.7.0 <0.9.0;
345 
346 
347 interface IERC165 {
348 
349     function supportsInterface(bytes4 interfaceId) external view returns (bool);
350 }
351 
352 
353 pragma solidity >=0.7.0 <0.9.0;
354 
355 
356 abstract contract ERC165 is IERC165 {
357     /**
358      * @dev See {IERC165-supportsInterface}.
359      */
360     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
361         return interfaceId == type(IERC165).interfaceId;
362     }
363 }
364 
365 
366 
367 pragma solidity >=0.7.0 <0.9.0;
368 
369 
370 /**
371  * @dev Required interface of an ERC721 compliant contract.
372  */
373 interface IERC721 is IERC165 {
374     /**
375      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
376      */
377     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
378 
379     /**
380      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
381      */
382     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
383 
384     /**
385      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
386      */
387     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
388 
389     /**
390      * @dev Returns the number of tokens in ``owner``'s account.
391      */
392     function balanceOf(address owner) external view returns (uint256 balance);
393 
394     function ownerOf(uint256 tokenId) external view returns (address owner);
395 
396     function safeTransferFrom(
397         address from,
398         address to,
399         uint256 tokenId
400     ) external;
401 
402 
403     function transferFrom(
404         address from,
405         address to,
406         uint256 tokenId
407     ) external;
408 
409 
410     function approve(address to, uint256 tokenId) external;
411 
412 
413     function getApproved(uint256 tokenId) external view returns (address operator);
414 
415     function setApprovalForAll(address operator, bool _approved) external;
416 
417     function isApprovedForAll(address owner, address operator) external view returns (bool);
418 
419     
420     function safeTransferFrom(
421         address from,
422         address to,
423         uint256 tokenId,
424         bytes calldata data
425     ) external;
426 }
427 
428 
429 
430 pragma solidity >=0.7.0 <0.9.0;
431 
432 
433 
434 interface IERC721Metadata is IERC721 {
435     /**
436      * @dev Returns the token collection name.
437      */
438     function name() external view returns (string memory);
439 
440     /**
441      * @dev Returns the token collection symbol.
442      */
443     function symbol() external view returns (string memory);
444 
445     /**
446      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
447      */
448     function tokenURI(uint256 tokenId) external view returns (string memory);
449 }
450 
451 
452 pragma solidity >=0.7.0 <0.9.0;
453 
454 
455 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
456     using Address for address;
457     using Strings for uint256;
458 
459     // Token name
460     string private _name;
461 
462     // Token symbol
463     string private _symbol;
464 
465     // Mapping from token ID to owner address
466     mapping(uint256 => address) private _owners;
467 
468     // Mapping owner address to token count
469     mapping(address => uint256) private _balances;
470 
471     // Mapping from token ID to approved address
472     mapping(uint256 => address) private _tokenApprovals;
473 
474     // Mapping from owner to operator approvals
475     mapping(address => mapping(address => bool)) private _operatorApprovals;
476 
477     /**
478      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
479      */
480     constructor(string memory name_, string memory symbol_) {
481         _name = name_;
482         _symbol = symbol_;
483     }
484 
485     /**
486      * @dev See {IERC165-supportsInterface}.
487      */
488     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
489         return
490             interfaceId == type(IERC721).interfaceId ||
491             interfaceId == type(IERC721Metadata).interfaceId ||
492             super.supportsInterface(interfaceId);
493     }
494 
495     /**
496      * @dev See {IERC721-balanceOf}.
497      */
498     function balanceOf(address owner) public view virtual override returns (uint256) {
499         require(owner != address(0), "ERC721: balance query for the zero address");
500         return _balances[owner];
501     }
502 
503     /**
504      * @dev See {IERC721-ownerOf}.
505      */
506     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
507         address owner = _owners[tokenId];
508         require(owner != address(0), "ERC721: owner query for nonexistent token");
509         return owner;
510     }
511 
512     /**
513      * @dev See {IERC721Metadata-name}.
514      */
515     function name() public view virtual override returns (string memory) {
516         return _name;
517     }
518 
519     /**
520      * @dev See {IERC721Metadata-symbol}.
521      */
522     function symbol() public view virtual override returns (string memory) {
523         return _symbol;
524     }
525 
526     /**
527      * @dev See {IERC721Metadata-tokenURI}.
528      */
529     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
530         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
531 
532         string memory baseURI = _baseURI();
533         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
534     }
535 
536 
537     function _baseURI() internal view virtual returns (string memory) {
538         return "";
539     }
540 
541     /**
542      * @dev See {IERC721-approve}.
543      */
544     function approve(address to, uint256 tokenId) public virtual override {
545         address owner = ERC721.ownerOf(tokenId);
546         require(to != owner, "ERC721: approval to current owner");
547 
548         require(
549             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
550             "ERC721: approve caller is not owner nor approved for all"
551         );
552 
553         _approve(to, tokenId);
554     }
555 
556     /**
557      * @dev See {IERC721-getApproved}.
558      */
559     function getApproved(uint256 tokenId) public view virtual override returns (address) {
560         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
561 
562         return _tokenApprovals[tokenId];
563     }
564 
565     /**
566      * @dev See {IERC721-setApprovalForAll}.
567      */
568     function setApprovalForAll(address operator, bool approved) public virtual override {
569         _setApprovalForAll(_msgSender(), operator, approved);
570     }
571 
572     /**
573      * @dev See {IERC721-isApprovedForAll}.
574      */
575     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
576         return _operatorApprovals[owner][operator];
577     }
578 
579     /**
580      * @dev See {IERC721-transferFrom}.
581      */
582     function transferFrom(
583         address from,
584         address to,
585         uint256 tokenId
586     ) public virtual override {
587         //solhint-disable-next-line max-line-length
588         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
589 
590         _transfer(from, to, tokenId);
591     }
592 
593     /**
594      * @dev See {IERC721-safeTransferFrom}.
595      */
596     function safeTransferFrom(
597         address from,
598         address to,
599         uint256 tokenId
600     ) public virtual override {
601         safeTransferFrom(from, to, tokenId, "");
602     }
603 
604     /**
605      * @dev See {IERC721-safeTransferFrom}.
606      */
607     function safeTransferFrom(
608         address from,
609         address to,
610         uint256 tokenId,
611         bytes memory _data
612     ) public virtual override {
613         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
614         _safeTransfer(from, to, tokenId, _data);
615     }
616 
617 
618     function _safeTransfer(
619         address from,
620         address to,
621         uint256 tokenId,
622         bytes memory _data
623     ) internal virtual {
624         _transfer(from, to, tokenId);
625         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
626     }
627 
628 
629     function _exists(uint256 tokenId) internal view virtual returns (bool) {
630         return _owners[tokenId] != address(0);
631     }
632 
633 
634     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
635         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
636         address owner = ERC721.ownerOf(tokenId);
637         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
638     }
639 
640 
641     function _safeMint(address to, uint256 tokenId) internal virtual {
642         _safeMint(to, tokenId, "");
643     }
644 
645   
646     function _safeMint(
647         address to,
648         uint256 tokenId,
649         bytes memory _data
650     ) internal virtual {
651         _mint(to, tokenId);
652         require(
653             _checkOnERC721Received(address(0), to, tokenId, _data),
654             "ERC721: transfer to non ERC721Receiver implementer"
655         );
656     }
657 
658 
659     function _mint(address to, uint256 tokenId) internal virtual {
660         require(to != address(0), "ERC721: mint to the zero address");
661         require(!_exists(tokenId), "ERC721: token already minted");
662 
663         _beforeTokenTransfer(address(0), to, tokenId);
664 
665         _balances[to] += 1;
666         _owners[tokenId] = to;
667 
668         emit Transfer(address(0), to, tokenId);
669     }
670 
671     function _burn(uint256 tokenId) internal virtual {
672         address owner = ERC721.ownerOf(tokenId);
673 
674         _beforeTokenTransfer(owner, address(0), tokenId);
675 
676         // Clear approvals
677         _approve(address(0), tokenId);
678 
679         _balances[owner] -= 1;
680         delete _owners[tokenId];
681 
682         emit Transfer(owner, address(0), tokenId);
683     }
684 
685 
686     function _transfer(
687         address from,
688         address to,
689         uint256 tokenId
690     ) internal virtual {
691         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
692         require(to != address(0), "ERC721: transfer to the zero address");
693 
694         _beforeTokenTransfer(from, to, tokenId);
695 
696         // Clear approvals from the previous owner
697         _approve(address(0), tokenId);
698 
699         _balances[from] -= 1;
700         _balances[to] += 1;
701         _owners[tokenId] = to;
702 
703         emit Transfer(from, to, tokenId);
704     }
705 
706 
707     function _approve(address to, uint256 tokenId) internal virtual {
708         _tokenApprovals[tokenId] = to;
709         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
710     }
711 
712 
713     function _setApprovalForAll(
714         address owner,
715         address operator,
716         bool approved
717     ) internal virtual {
718         require(owner != operator, "ERC721: approve to caller");
719         _operatorApprovals[owner][operator] = approved;
720         emit ApprovalForAll(owner, operator, approved);
721     }
722 
723 
724     function _checkOnERC721Received(
725         address from,
726         address to,
727         uint256 tokenId,
728         bytes memory _data
729     ) private returns (bool) {
730         if (to.isContract()) {
731             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
732                 return retval == IERC721Receiver.onERC721Received.selector;
733             } catch (bytes memory reason) {
734                 if (reason.length == 0) {
735                     revert("ERC721: transfer to non ERC721Receiver implementer");
736                 } else {
737                     assembly {
738                         revert(add(32, reason), mload(reason))
739                     }
740                 }
741             }
742         } else {
743             return true;
744         }
745     }
746 
747 
748     function _beforeTokenTransfer(
749         address from,
750         address to,
751         uint256 tokenId
752     ) internal virtual {}
753 }
754 
755 
756 // File: contracts/The_AnonymousNFT.sol
757 
758 
759 
760 pragma solidity >=0.7.0 <0.9.0;
761 
762 contract The_AnonymousNFT is ERC721, Ownable {
763   using Strings for uint256;
764   using Counters for Counters.Counter;
765 
766   Counters.Counter private supply;
767 
768   string public uriPrefix = "";
769   string public uriSuffix = ".json";
770   string public hiddenMetadataUri;
771   
772   uint256 public cost = 0.01 ether;
773   uint256 public maxSupply = 4444;
774   uint256 public maxMintAmountPerTx = 10;
775 
776 
777   bool public paused = true;
778   bool public revealed = false;
779 
780   mapping(address => uint256) public addressMintedBalance;
781 
782   constructor() ERC721("The Anonymous NFT", "The Anonymous") {
783     setHiddenMetadataUri("ipfs://bafybeid45g7is7jb757xja6pk37ew2frekwkggndpyg6hk7pijyksu6gkm/hidden.json");
784   }
785 
786   modifier mintCompliance(uint256 _mintAmount) {
787     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
788     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
789     _;
790   }
791 
792   function totalSupply() public view returns (uint256) {
793     return supply.current();
794   }
795 
796   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
797     require(!paused, "The contract is paused!");
798     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
799 
800     _mintLoop(msg.sender, _mintAmount);
801   }
802   
803   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
804     _mintLoop2(_receiver, _mintAmount);
805   }
806 
807   function walletOfOwner(address _owner)
808     public
809     view
810     returns (uint256[] memory)
811   {
812     uint256 ownerTokenCount = balanceOf(_owner);
813     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
814     uint256 currentTokenId = 1;
815     uint256 ownedTokenIndex = 0;
816 
817     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
818       address currentTokenOwner = ownerOf(currentTokenId);
819 
820       if (currentTokenOwner == _owner) {
821         ownedTokenIds[ownedTokenIndex] = currentTokenId;
822 
823         ownedTokenIndex++;
824       }
825 
826       currentTokenId++;
827     }
828 
829     return ownedTokenIds;
830   }
831 
832   function tokenURI(uint256 _tokenId)
833     public
834     view
835     virtual
836     override
837     returns (string memory)
838   {
839     require(
840       _exists(_tokenId),
841       "ERC721Metadata: URI query for nonexistent token"
842     );
843 
844     if (revealed == false) {
845       return hiddenMetadataUri;
846     }
847 
848     string memory currentBaseURI = _baseURI();
849     return bytes(currentBaseURI).length > 0
850         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
851         : "";
852   }
853 
854   function setRevealed(bool _state) public onlyOwner {
855     revealed = _state;
856   }
857 
858   function setCost(uint256 _cost) public onlyOwner {
859     cost = _cost;
860   }
861 
862   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
863     maxMintAmountPerTx = _maxMintAmountPerTx;
864   }
865 
866 
867 
868   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
869     maxSupply = _maxSupply;
870   }
871 
872   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
873     hiddenMetadataUri = _hiddenMetadataUri;
874   }
875 
876   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
877     uriPrefix = _uriPrefix;
878   }
879 
880   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
881     uriSuffix = _uriSuffix;
882   }
883 
884   function setPaused(bool _state) public onlyOwner {
885     paused = _state;
886   }
887 
888   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
889     
890     for (uint256 i = 0; i < _mintAmount; i++) {
891       supply.increment();
892       addressMintedBalance[msg.sender]++;
893       _safeMint(_receiver, supply.current());
894     }
895   }
896 
897   function _mintLoop2(address _receiver, uint256 _mintAmount) internal {
898     for (uint256 i = 0; i < _mintAmount; i++) {
899       supply.increment();
900       _safeMint(_receiver, supply.current());
901     }
902   }
903 
904   function _baseURI() internal view virtual override returns (string memory) {
905     return uriPrefix;
906   }
907 
908   function withdraw() public onlyOwner {
909     // =============================================================================
910     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
911     require(os);
912     // =============================================================================
913   }
914   
915 }