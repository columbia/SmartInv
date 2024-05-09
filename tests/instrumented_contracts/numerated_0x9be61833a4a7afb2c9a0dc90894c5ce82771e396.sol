1 // SPDX-License-Identifier: MIT
2 //	       						  &@@@@@@@@@@@@@@@@@@#                              
3 //                              @@@@@@@@@@@@@@@@@@@@@@@@@@@@                          
4 //                            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                        
5 //                          /@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                       
6 //                          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      
7 //                         #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      
8 //                        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                     
9 //                        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                     
10 //                       /@@@@.    *@@@@@@@@@@@@@@@@@@,    (@@@@                     
11 //                       &@@@*          .@@@@@@@@           @@@@*                    
12 //                       @@@@@/         ,@@@@@@@@          &@@@@@                    
13 //                       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                    
14 //                      &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,                   
15 //                      &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.                   
16 //                       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                    
17 //                       #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.                    
18 //                        &@@@@@@@@@@@@            @@@@@@@@@@@@/                     
19 //                         @@@@@@@@@@@@@@/      %@@@@@@@@@@@@@%                      
20 //                        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.                     
21 //                        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                     
22 //                     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%                  
23 //                     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  
24 //                     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  
25 //                      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                   
26 //                        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                     
27 //                          *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                        
28 //                               @@@@@@@@@@@@@@@@@@@@@@@%       
29 //         
30 //
31 //
32 //   /$$$$$$$   /$$$$$$  /$$       /$$   /$$     /$$        /$$$$$$   /$$$$$$  /$$   /$$  /$$$$$$ 
33 //  | $$__  $$ /$$__  $$| $$      | $$  |  $$   /$$/       /$$__  $$ /$$__  $$| $$$ | $$ /$$__  $$
34 //  | $$  \ $$| $$  \ $$| $$      | $$   \  $$ /$$/       | $$  \__/| $$  \ $$| $$$$| $$| $$  \__/
35 //  | $$$$$$$ | $$$$$$$$| $$      | $$    \  $$$$/        | $$ /$$$$| $$$$$$$$| $$ $$ $$| $$ /$$$$
36 //  | $$__  $$| $$__  $$| $$      | $$     \  $$/         | $$|_  $$| $$__  $$| $$  $$$$| $$|_  $$
37 //  | $$  \ $$| $$  | $$| $$      | $$      | $$          | $$  \ $$| $$  | $$| $$\  $$$| $$  \ $$
38 //  | $$$$$$$/| $$  | $$| $$$$$$$$| $$$$$$$$| $$          |  $$$$$$/| $$  | $$| $$ \  $$|  $$$$$$/
39 //  |_______/ |__/  |__/|________/|________/|__/           \______/ |__/  |__/|__/  \__/ \______/ 
40 //                                                                                                
41 //  Developer: Vedametric Australia  
42 //  Website: https://vedametric.com.au
43 //                                                                                                 
44 //  V2.7 | 15/03/2021
45 
46 
47 
48 pragma solidity ^0.8.0;
49 
50 library Counters {
51     struct Counter {
52         uint256 _value; // default: 0
53     }
54 
55     function current(Counter storage counter) internal view returns (uint256) {
56         return counter._value;
57     }
58 
59     function increment(Counter storage counter) internal {
60         unchecked {
61             counter._value += 1;
62         }
63     }
64 
65     function decrement(Counter storage counter) internal {
66         uint256 value = counter._value;
67         require(value > 0, "Counter: decrement overflow");
68         unchecked {
69             counter._value = value - 1;
70         }
71     }
72 
73     function reset(Counter storage counter) internal {
74         counter._value = 0;
75     }
76 }
77 
78 pragma solidity ^0.8.0;
79 
80 library Strings {
81     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
82 
83 
84     function toString(uint256 value) internal pure returns (string memory) {
85 
86         if (value == 0) {
87             return "0";
88         }
89         uint256 temp = value;
90         uint256 digits;
91         while (temp != 0) {
92             digits++;
93             temp /= 10;
94         }
95         bytes memory buffer = new bytes(digits);
96         while (value != 0) {
97             digits -= 1;
98             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
99             value /= 10;
100         }
101         return string(buffer);
102     }
103 
104     function toHexString(uint256 value) internal pure returns (string memory) {
105         if (value == 0) {
106             return "0x00";
107         }
108         uint256 temp = value;
109         uint256 length = 0;
110         while (temp != 0) {
111             length++;
112             temp >>= 8;
113         }
114         return toHexString(value, length);
115     }
116 
117 
118     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
119         bytes memory buffer = new bytes(2 * length + 2);
120         buffer[0] = "0";
121         buffer[1] = "x";
122         for (uint256 i = 2 * length + 1; i > 1; --i) {
123             buffer[i] = _HEX_SYMBOLS[value & 0xf];
124             value >>= 4;
125         }
126         require(value == 0, "Strings: hex length insufficient");
127         return string(buffer);
128     }
129 }
130 
131 
132 pragma solidity ^0.8.0;
133 
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 
145 pragma solidity ^0.8.0;
146 abstract contract Ownable is Context {
147     address private _owner;
148    address private _dev = _owner; //set initial dev to owner 
149 
150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152     /**
153      * @dev Initializes the contract setting the deployer as the initial owner.
154      */
155     constructor() {
156         _transferOwnership(_msgSender());
157     }
158 
159     /**
160      * @dev Returns the address of the current owner.
161      */
162     function owner() public view virtual returns (address) {
163         return _owner ;
164     }
165      /**
166      * @dev Sets the address of the current developer.
167      */  
168   
169     function setDeveloper(address dev) public onlyOwner {
170      _dev = dev;
171     }
172 
173     /**
174     * @dev Gets the address of the current developer.
175      */  
176 
177   function getDeveloper() public view returns (address) {
178     return _dev;
179   }
180 
181     modifier onlyOwner() {
182         require(owner() == _msgSender() || _dev == _msgSender(), "Ownable: caller is not the owner");
183         _;
184     }
185 
186 
187     function renounceOwnership() public virtual onlyOwner {
188         _transferOwnership(address(0));  
189     }
190 
191     function transferOwnership(address newOwner) public virtual onlyOwner {
192         require(newOwner != address(0), "Ownable: new owner is the zero address");
193         _transferOwnership(newOwner);
194     }
195 
196     /**
197      * @dev Transfers ownership of the contract to a new account (`newOwner`).
198      * Internal function without access restriction.
199      */
200     function _transferOwnership(address newOwner) internal virtual {
201         address oldOwner = _owner;
202         _owner = newOwner;
203         emit OwnershipTransferred(oldOwner, newOwner);
204     }
205 }
206 
207 
208 pragma solidity ^0.8.0;
209 
210 
211 library Address {
212 
213     function isContract(address account) internal view returns (bool) {
214  
215         uint256 size;
216         assembly {
217             size := extcodesize(account)
218         }
219         return size > 0;
220     }
221 
222     function sendValue(address payable recipient, uint256 amount) internal {
223         require(address(this).balance >= amount, "Address: insufficient balance");
224 
225         (bool success, ) = recipient.call{value: amount}("");
226         require(success, "Address: unable to send value, recipient may have reverted");
227     }
228 
229    
230     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
231         return functionCall(target, data, "Address: low-level call failed");
232     }
233 
234  
235     function functionCall(
236         address target,
237         bytes memory data,
238         string memory errorMessage
239     ) internal returns (bytes memory) {
240         return functionCallWithValue(target, data, 0, errorMessage);
241     }
242 
243 
244     function functionCallWithValue(
245         address target,
246         bytes memory data,
247         uint256 value
248     ) internal returns (bytes memory) {
249         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
250     }
251 
252     function functionCallWithValue(
253         address target,
254         bytes memory data,
255         uint256 value,
256         string memory errorMessage
257     ) internal returns (bytes memory) {
258         require(address(this).balance >= value, "Address: insufficient balance for call");
259         require(isContract(target), "Address: call to non-contract");
260 
261         (bool success, bytes memory returndata) = target.call{value: value}(data);
262         return verifyCallResult(success, returndata, errorMessage);
263     }
264 
265     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
266         return functionStaticCall(target, data, "Address: low-level static call failed");
267     }
268 
269 
270     function functionStaticCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal view returns (bytes memory) {
275         require(isContract(target), "Address: static call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.staticcall(data);
278         return verifyCallResult(success, returndata, errorMessage);
279     }
280 
281 
282     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
283         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
284     }
285 
286 
287     function functionDelegateCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         require(isContract(target), "Address: delegate call to non-contract");
293 
294         (bool success, bytes memory returndata) = target.delegatecall(data);
295         return verifyCallResult(success, returndata, errorMessage);
296     }
297 
298   
299     function verifyCallResult(
300         bool success,
301         bytes memory returndata,
302         string memory errorMessage
303     ) internal pure returns (bytes memory) {
304         if (success) {
305             return returndata;
306         } else {
307             // Look for revert reason and bubble it up if present
308             if (returndata.length > 0) {
309                 // The easiest way to bubble the revert reason is using memory via assembly
310 
311                 assembly {
312                     let returndata_size := mload(returndata)
313                     revert(add(32, returndata), returndata_size)
314                 }
315             } else {
316                 revert(errorMessage);
317             }
318         }
319     }
320 }
321 
322 
323 
324 pragma solidity ^0.8.0;
325 
326 
327 interface IERC721Receiver {
328 
329     function onERC721Received(
330         address operator,
331         address from,
332         uint256 tokenId,
333         bytes calldata data
334     ) external returns (bytes4);
335 }
336 
337 
338 pragma solidity ^0.8.0;
339 
340 
341 interface IERC165 {
342    
343     function supportsInterface(bytes4 interfaceId) external view returns (bool);
344 }
345 
346 pragma solidity ^0.8.0;
347 
348 abstract contract ERC165 is IERC165 {
349 
350     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
351         return interfaceId == type(IERC165).interfaceId;
352     }
353 }
354 
355 pragma solidity ^0.8.0;
356 
357 
358 interface IERC721 is IERC165 {
359   
360     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
361 
362     /**
363      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
364      */
365     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
366 
367     /**
368      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
369      */
370     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
371 
372     /**
373      * @dev Returns the number of tokens in ``owner``'s account.
374      */
375     function balanceOf(address owner) external view returns (uint256 balance);
376 
377     /**
378      * @dev Returns the owner of the `tokenId` token.
379      *
380      * Requirements:
381      *
382      * - `tokenId` must exist.
383      */
384     function ownerOf(uint256 tokenId) external view returns (address owner);
385 
386  
387     function safeTransferFrom(
388         address from,
389         address to,
390         uint256 tokenId
391     ) external;
392 
393     function transferFrom(
394         address from,
395         address to,
396         uint256 tokenId
397     ) external;
398 
399  
400     function approve(address to, uint256 tokenId) external;
401 
402     function getApproved(uint256 tokenId) external view returns (address operator);
403 
404     function setApprovalForAll(address operator, bool _approved) external;
405 
406     function isApprovedForAll(address owner, address operator) external view returns (bool);
407 
408     function safeTransferFrom(
409         address from,
410         address to,
411         uint256 tokenId,
412         bytes calldata data
413     ) external;
414 }
415 
416 pragma solidity ^0.8.0;
417 
418 interface IERC721Metadata is IERC721 {
419     /**
420      * @dev Returns the token collection name.
421      */
422     function name() external view returns (string memory);
423 
424     /**
425      * @dev Returns the token collection symbol.
426      */
427     function symbol() external view returns (string memory);
428 
429     /**
430      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
431      */
432     function tokenURI(uint256 tokenId) external view returns (string memory);
433 }
434 
435 
436 pragma solidity ^0.8.0;
437 
438 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
439     using Address for address;
440     using Strings for uint256;
441 
442     // Token name
443     string private _name;
444 
445     // Token symbol
446     string private _symbol;
447 
448     // Mapping from token ID to owner address
449     mapping(uint256 => address) private _owners;
450 
451     // Mapping owner address to token count
452     mapping(address => uint256) private _balances;
453 
454     // Mapping from token ID to approved address
455     mapping(uint256 => address) private _tokenApprovals;
456 
457     // Mapping from owner to operator approvals
458     mapping(address => mapping(address => bool)) private _operatorApprovals;
459 
460     /**
461      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
462      */
463     constructor(string memory name_, string memory symbol_) {
464         _name = name_;
465         _symbol = symbol_;
466     }
467 
468     /**
469      * @dev See {IERC165-supportsInterface}.
470      */
471     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
472         return
473             interfaceId == type(IERC721).interfaceId ||
474             interfaceId == type(IERC721Metadata).interfaceId ||
475             super.supportsInterface(interfaceId);
476     }
477 
478     /**
479      * @dev See {IERC721-balanceOf}.
480      */
481     function balanceOf(address owner) public view virtual override returns (uint256) {
482         require(owner != address(0), "ERC721: balance query for the zero address");
483         return _balances[owner];
484     }
485 
486     /**
487      * @dev See {IERC721-ownerOf}.
488      */
489     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
490         address owner = _owners[tokenId];
491         require(owner != address(0), "ERC721: owner query for nonexistent token");
492         return owner;
493     }
494 
495     /**
496      * @dev See {IERC721Metadata-name}.
497      */
498     function name() public view virtual override returns (string memory) {
499         return _name;
500     }
501 
502     /**
503      * @dev See {IERC721Metadata-symbol}.
504      */
505     function symbol() public view virtual override returns (string memory) {
506         return _symbol;
507     }
508 
509     /**
510      * @dev See {IERC721Metadata-tokenURI}.
511      */
512     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
513         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
514 
515         string memory baseURI = _baseURI();
516         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
517     }
518 
519     /**
520      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
521      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
522      * by default, can be overriden in child contracts.
523      */
524     function _baseURI() internal view virtual returns (string memory) {
525         return "";
526     }
527 
528     /**
529      * @dev See {IERC721-approve}.
530      */
531     function approve(address to, uint256 tokenId) public virtual override {
532         address owner = ERC721.ownerOf(tokenId);
533         require(to != owner, "ERC721: approval to current owner");
534 
535         require(
536             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
537             "ERC721: approve caller is not owner nor approved for all"
538         );
539 
540         _approve(to, tokenId);
541     }
542 
543     /**
544      * @dev See {IERC721-getApproved}.
545      */
546     function getApproved(uint256 tokenId) public view virtual override returns (address) {
547         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
548 
549         return _tokenApprovals[tokenId];
550     }
551 
552     /**
553      * @dev See {IERC721-setApprovalForAll}.
554      */
555     function setApprovalForAll(address operator, bool approved) public virtual override {
556         _setApprovalForAll(_msgSender(), operator, approved);
557     }
558 
559     /**
560      * @dev See {IERC721-isApprovedForAll}.
561      */
562     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
563         return _operatorApprovals[owner][operator];
564     }
565 
566     /**
567      * @dev See {IERC721-transferFrom}.
568      */
569     function transferFrom(
570         address from,
571         address to,
572         uint256 tokenId
573     ) public virtual override {
574         //solhint-disable-next-line max-line-length
575         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
576 
577         _transfer(from, to, tokenId);
578     }
579 
580     /**
581      * @dev See {IERC721-safeTransferFrom}.
582      */
583     function safeTransferFrom(
584         address from,
585         address to,
586         uint256 tokenId
587     ) public virtual override {
588         safeTransferFrom(from, to, tokenId, "");
589 
590     }
591 
592     /**
593      * @dev See {IERC721-safeTransferFrom}.
594      */
595     function safeTransferFrom(
596         address from,
597         address to,
598         uint256 tokenId,
599         bytes memory _data
600     ) public virtual override {
601         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
602         _safeTransfer(from, to, tokenId, _data);
603     }
604 
605     
606     function _safeTransfer(
607         address from,
608         address to,
609         uint256 tokenId,
610         bytes memory _data
611     ) internal virtual {
612         _transfer(from, to, tokenId);
613         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
614     }
615 
616  
617     function _exists(uint256 tokenId) internal view virtual returns (bool) {
618         return _owners[tokenId] != address(0);
619     }
620 
621     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
622         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
623         address owner = ERC721.ownerOf(tokenId);
624         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
625     }
626 
627 
628     function _safeMint(address to, uint256 tokenId) internal virtual {
629         _safeMint(to, tokenId, "");
630     }
631 
632  
633     function _safeMint(
634         address to,
635         uint256 tokenId,
636         bytes memory _data
637     ) internal virtual {
638         _mint(to, tokenId);
639         require(
640             _checkOnERC721Received(address(0), to, tokenId, _data),
641             "ERC721: transfer to non ERC721Receiver implementer"
642         );
643     }
644 
645 
646     function _mint(address to, uint256 tokenId) internal virtual {
647         require(to != address(0), "ERC721: mint to the zero address");
648         require(!_exists(tokenId), "ERC721: token already minted");
649 
650         _beforeTokenTransfer(address(0), to, tokenId);
651 
652         _balances[to] += 1;
653         _owners[tokenId] = to;
654 
655         emit Transfer(address(0), to, tokenId);
656     }
657 
658  
659     function _burn(uint256 tokenId) internal virtual {
660         address owner = ERC721.ownerOf(tokenId);
661 
662         _beforeTokenTransfer(owner, address(0), tokenId);
663 
664         // Clear approvals
665         _approve(address(0), tokenId);
666 
667         _balances[owner] -= 1;
668         delete _owners[tokenId];
669 
670         emit Transfer(owner, address(0), tokenId);
671     }
672 
673     /**
674      * @dev Transfers `tokenId` from `from` to `to`.
675      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
676      *
677      * Requirements:
678      *
679      * - `to` cannot be the zero address.
680      * - `tokenId` token must be owned by `from`.
681      *
682      * Emits a {Transfer} event.
683      */
684     function _transfer(
685         address from,
686         address to,
687         uint256 tokenId
688     ) internal virtual {
689         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
690         require(to != address(0), "ERC721: transfer to the zero address");
691 
692         _beforeTokenTransfer(from, to, tokenId);
693 
694         // Clear approvals from the previous owner
695         _approve(address(0), tokenId);
696 
697         _balances[from] -= 1;
698         _balances[to] += 1;
699         _owners[tokenId] = to;
700 
701         emit Transfer(from, to, tokenId);
702     }
703 
704     /**
705      * @dev Approve `to` to operate on `tokenId`
706      *
707      * Emits a {Approval} event.
708      */
709     function _approve(address to, uint256 tokenId) internal virtual {
710         _tokenApprovals[tokenId] = to;
711         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
712     }
713 
714     /**
715      * @dev Approve `operator` to operate on all of `owner` tokens
716      *
717      * Emits a {ApprovalForAll} event.
718      */
719     function _setApprovalForAll(
720         address owner,
721         address operator,
722         bool approved
723     ) internal virtual {
724         require(owner != operator, "ERC721: approve to caller");
725         _operatorApprovals[owner][operator] = approved;
726         emit ApprovalForAll(owner, operator, approved);
727     }
728 
729   
730     function _checkOnERC721Received(
731         address from,
732         address to,
733         uint256 tokenId,
734         bytes memory _data
735     ) private returns (bool) {
736         if (to.isContract()) {
737             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
738                 return retval == IERC721Receiver.onERC721Received.selector;
739             } catch (bytes memory reason) {
740                 if (reason.length == 0) {
741                     revert("ERC721: transfer to non ERC721Receiver implementer");
742                 } else {
743                     assembly {
744                         revert(add(32, reason), mload(reason))
745                     }
746                 }
747             }
748         } else {
749             return true;
750         }
751     }
752 
753  
754     function _beforeTokenTransfer(
755         address from,
756         address to,
757         uint256 tokenId
758     ) internal virtual {}
759 }
760 
761 
762 pragma solidity >=0.7.0 <0.9.0;
763 
764 
765 contract BallyGang is ERC721, Ownable {
766   using Strings for uint256;
767   using Counters for Counters.Counter;
768 
769   Counters.Counter private supply;
770 
771   string public uriPrefix = "";
772   string public uriSuffix = ".json";
773   string public hiddenMetadataUri;
774   
775   uint256 public cost = 0.2 ether;      //whitelist Price 0.2 || Public Mint 0.3
776   uint256 public maxSupply = 8888;
777   uint256 public maxMintAmountPerTx = 3;
778   uint256 public nftPerAddressLimit = 999;
779  
780 
781   bool public paused = true;
782   bool public revealed = false;
783   bool public onlyWhitelisted = true;
784 
785   address payable public payments;
786  
787   mapping(address=> bool) public allWhitelistedAddress;
788   mapping(address => uint256) public addressMintedBalance;
789 
790 
791 
792 // Create Constructor Data
793 // Initialise Contract
794   constructor() ERC721("Bally Gang", "BALLYG") {
795 
796     setHiddenMetadataUri("https://ipfs.ballygangnft.io/hidden/hidden.json");
797 
798     setPayable(address(0x779a516cC09E7Fb12daA2eA4fE961916A4B2e177));                   
799     
800     setDeveloper(msg.sender);                                                           
801 
802     //INITIALISE MINT LOGIC AT DEPLOYMENT
803     //MINT BALLYG[1-10] -> STATIC 1:1 TOKENS
804     _mintLoop(address(0x15023dFD0c33859B5Ace6665eEe7a3d524d65C42),10);                 
805 
806     //MINT BALLYG[11-388] -> GENERATIVE TOKENS
807     _mintLoop(address(0x15023dFD0c33859B5Ace6665eEe7a3d524d65C42),378);                
808 
809     //AIRDROPS FOR ARTISTS/INFLUENCERS/GIVEAWAYS/WINNERS
810     _mintLoop(address(0x962ca86f2B62a4Df5Bc52B5E694587841a60CCC1),1);
811     _mintLoop(address(0x51A7fc09428ef488DC175d7c9CAe0dA7903790a7),1);                  
812     _mintLoop(address(0xDFE5629Aa0e766F7214E9b970468a56a2bC5441c),8);  
813     //
814     _mintLoop(address(0xFF945ade5E911bC29063c88cB64a246D6069fF08),1);
815     _mintLoop(address(0xCe716c038597c859e3A5a909005C58E7290c2796),1);
816     _mintLoop(address(0xce50E9aB724a323d8E4753b364338D9056f367Ec),1);
817     _mintLoop(address(0x0536211ABEB7407B5812060501237C00c56250aC),1);
818     _mintLoop(address(0x03B8837B2cA7aA8B43Afb6fAb0E2210D729867F6),1);
819     _mintLoop(address(0xE3f96A5eED631303BC589d766cB5d031197744F7),1);
820     _mintLoop(address(0xD17348A4aE8Dea65A8B5B0B6CeBAc25DFf511e8f),1);
821     _mintLoop(address(0xBcf211ba118538E629344644754a51e160349df7),1);
822     _mintLoop(address(0xef6c1F143Be4259aE8242f4f8489a69Fc4C40786),1);
823     _mintLoop(address(0x1196Defb47071a0BDf1ba1037FD8ECD1E4b70C42),1);
824     _mintLoop(address(0xC37621839DF3DE7dFbe5EAED895e526445bE9A32),1);
825     _mintLoop(address(0x27fB2582BdE984552FAbEA7252b6b96153000DCf),1);
826     _mintLoop(address(0x31ecAC1A64e90241716E4Da32E988DaB8811a195),1);
827     _mintLoop(address(0xFF1525Ce1BD6Ec719834964d94Df5324607043c6),1);
828     _mintLoop(address(0x8B9af980A04c13b8E7F426a87E60f9E166FE36A3),1);
829     _mintLoop(address(0x875B77c4d368fFC8c634E65EaAE48315B763706F),1);
830     _mintLoop(address(0x6A70Ce0e14F4aCb32567AF098a66F23E753b2bb2),1);
831     _mintLoop(address(0x91BBd583B8C16F568B2E11C8C5bEcE75a48aB6d8),1);                  
832     _mintLoop(address(0x5073254dCAd429f02D752A649cF1c2041308cA63),1);
833     _mintLoop(address(0x274276f91BF42E5AE0D4b9C61677F72CE5DaE04a),1);
834     _mintLoop(address(0x8C9C02511dD1282607D0185bEdEbFa3b90b14B66),1);
835     _mintLoop(address(0x3cF83c1C8E638A637962B383271EA5ab762aBbEe),1);
836     _mintLoop(address(0x474958ECD11cE81ce0193228d2Fc7238A53d5FB5),1);
837     _mintLoop(address(0x85209b80C42f8cc092aaE66f2756B37D95C7ba06),1);
838     _mintLoop(address(0x7F93FD25a5a8d6d7C1cC5bdB1b03cf57B574ee5C),1);
839     _mintLoop(address(0x7C062F6377599B31C38D76e193C5F2974CEFC799),1);
840     _mintLoop(address(0x178473936884F33a11d70f28b6F71758D407A391),1);
841     _mintLoop(address(0x8a4f1d414b415bBAD8243f52982b1A3d6E736714),1);
842     _mintLoop(address(0xcc2aDF7D666f49d47a6Ac653E6bEd83447dEDf51),1);
843     _mintLoop(address(0x1c4ADD21644bf4C47950C22473b09aB0ac604232),1);
844     _mintLoop(address(0xd0aba2ebb570feF89FE0CB5Fb49c74E944F4D7F3),1);
845     _mintLoop(address(0xeF311E803235a5993C12341fAD2e8a5650Dc9c71),1);
846     _mintLoop(address(0xd7f59956E1A850404A4439a68c3c0FC9D376dfB6),1);
847     _mintLoop(address(0x79cCD5A462A884b479aEe0201ba6c97039cc5C90),1);
848     _mintLoop(address(0x6aA9393d3085AD378E537Eb29C253F82ba97Cdf4),1);
849     _mintLoop(address(0xC6d350771bDDA5927052976578C7084AD437A5c3),1);
850     _mintLoop(address(0xe4f675A59592118ad965c473587DeDcD6080118C),1);
851     _mintLoop(address(0x57B40a4e2C6CBC234a211D3788eE2338cB71dA4a),1);
852     _mintLoop(address(0x0c8d78A1a7C7D6eb24bA04e0aA01bAE7E10DeFc8),1);
853     _mintLoop(address(0x4171F6a8fCAB5787d084bBE648a6ACF2603E39B0),1);
854     _mintLoop(address(0x8b9f0aB97EF5933Cc1D42F5DBE6B7830D9324b7A),1);
855     _mintLoop(address(0xEd19EE630B13196650BB65C4b207338d7643b339),1);
856     _mintLoop(address(0x200b29036f18aA3F804AB523b242598a35E1702F),1);
857     _mintLoop(address(0x12a7aF59b8768e2692FA55892380D1cBD82F5949),1);
858     _mintLoop(address(0xB5821e51bd575DbaE78D3a2c52EdB5e00ADebc17),1);
859     _mintLoop(address(0x7334944be0bC94E09d2067E78Ca7525887695C90),1);
860     _mintLoop(address(0x58FC45633b8F2761f74d7D1Fc9a5cAE8F0f4ff7A),1);
861     _mintLoop(address(0xa91f6B4930c7203f8A394F8006035434352aBd44),1);
862     _mintLoop(address(0xb656db26072656A4d72f74f7242DfB754290f99C),1);
863     _mintLoop(address(0xadece1b5D0F36437E3CB3faFacc5b795799c924e),1);
864     _mintLoop(address(0x1be41a9e5c7B0E760009412e94062F63f963DB2f),1);
865     _mintLoop(address(0x9DBBaf0E936aA06c0318eD3e2DcA11ad996AAB3d),1);
866     _mintLoop(address(0x5Da13Ca9B468941381321517B9BD32d099e3485b),1);
867     _mintLoop(address(0x89f902B8068c428F0d11f9CD031BF11723DB88AA),1);
868     
869 
870 
871   }
872 
873 
874   modifier mintCompliance(uint256 _mintAmount) {
875     require(_mintAmount > 0, "Mint amount must be greater than 0");
876     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
877     _;
878   }
879   function setPayable(address _payable) public onlyOwner {
880     payments = payable(_payable);
881   }
882 
883 
884   function totalSupply() public view returns (uint256) {
885     return supply.current();
886   }
887 
888   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
889     if (msg.sender != owner()) {
890         require(!paused, "The contract is paused!");
891         require(_mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
892 
893         if (onlyWhitelisted == true) {
894             require(isWhitelisted(msg.sender), "User is not whitelisted");
895             uint256 ownerMintedCount = balanceOf(msg.sender);
896             require(
897                 ownerMintedCount + _mintAmount <= nftPerAddressLimit,
898                 "Max NFT per address exceeded"
899             );
900         }
901         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
902     }
903     _mintLoop(msg.sender, _mintAmount);
904   }
905 
906 
907   function walletOfOwner(address _owner)
908     public
909     view
910     returns (uint256[] memory)
911   {
912     uint256 ownerTokenCount = balanceOf(_owner);
913     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
914     uint256 currentTokenId = 1;
915     uint256 ownedTokenIndex = 0;
916 
917     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
918       address currentTokenOwner = ownerOf(currentTokenId);
919 
920       if (currentTokenOwner == _owner) {
921         ownedTokenIds[ownedTokenIndex] = currentTokenId;
922 
923         ownedTokenIndex++;
924       }
925 
926       currentTokenId++;
927     }
928 
929     return ownedTokenIds;
930   }
931 
932   function tokenURI(uint256 _tokenId)
933     public
934     view
935     virtual
936     override
937     returns (string memory)
938   {
939     require(
940       _exists(_tokenId),
941       "ERC721Metadata: URI query for nonexistent token"
942     );
943 
944     if (revealed == false) {
945       return hiddenMetadataUri;
946     }
947 
948     string memory currentBaseURI = _baseURI();
949     return bytes(currentBaseURI).length > 0
950         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
951         : "";
952   }
953 
954   function setRevealed(bool _state) public onlyOwner {
955     revealed = _state;
956   }
957 
958   function setCost(uint256 _cost) public onlyOwner {
959     cost = _cost;
960   }
961 
962   // Update Max NFTs Mintable Per Transaction
963   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
964     maxMintAmountPerTx = _maxMintAmountPerTx;
965   }
966 
967   // Update Max Whitelist Allowed Holding
968   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
969       nftPerAddressLimit = _limit;
970   }
971 
972   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
973     hiddenMetadataUri = _hiddenMetadataUri;
974   }
975 
976   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
977     uriPrefix = _uriPrefix;
978   }
979 
980   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
981     uriSuffix = _uriSuffix;
982   }
983 
984   function setPaused(bool _state) public onlyOwner {
985     paused = _state;
986   }
987 
988   function setOnlyWhitelisted(bool _state) public onlyOwner {
989       onlyWhitelisted = _state;
990   }
991 
992 
993  function addToWhitelist(address a) public onlyOwner {  //kunal
994      allWhitelistedAddress[a]=true;
995   }
996 
997   function removeFromWhitelist(address a) public onlyOwner {  
998      allWhitelistedAddress[a]=false;
999   }
1000 
1001  function isWhitelisted(address a) public view returns (bool){ 
1002     return allWhitelistedAddress[a];
1003 }
1004 
1005 
1006 function batchAddtoWhitelist(address[] memory whitelistusers) public onlyOwner{
1007    for(uint256 i=0; i < whitelistusers.length; i++){
1008         addToWhitelist(whitelistusers[i]);
1009     }
1010 }
1011 
1012 
1013   function withdraw() public onlyOwner {
1014 
1015     // This will transfer the  contract balance to the payable.
1016     // =============================================================================
1017     (bool os, ) = payable(payments).call{value: address(this).balance}("");
1018     require(os);
1019     // =============================================================================
1020   }
1021 
1022   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1023     for (uint256 i = 0; i < _mintAmount; i++) {
1024       supply.increment();
1025       _safeMint(_receiver, supply.current());
1026     }
1027   }
1028 
1029  function mintToAddress(address _receiver) public onlyOwner {
1030   _mintLoop(_receiver,1);
1031 }
1032 
1033  function mintMultipleToAddress(address _receiver, uint256 _mintAmount) public onlyOwner {
1034   _mintLoop(_receiver,_mintAmount);
1035 }
1036 
1037 
1038   function _baseURI() internal view virtual override returns (string memory) {
1039     return uriPrefix;
1040   }
1041 }