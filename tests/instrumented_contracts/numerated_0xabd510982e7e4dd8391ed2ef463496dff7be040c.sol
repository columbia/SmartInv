1 // SPDX-License-Identifier: MIT
2 
3 
4                                                                                 
5 //                                                       &&&&&&&&&&&&             
6 //                                                  &&&&&&&&&&&&&&&&&&&&&         
7 //                                               &&&&&&&&&&&&&&&&&&&&&&&&&&       
8 //                                             &&&&&&&&&&&&&&&                    
9 //                                          &&&&&&&&&&&&&&&                       
10 //                                      &&&&&&&&&&&&&&&&&                         
11 //                                &&&&&&&&&&&&&&&&&&&&&&                          
12 //                             &&&&&&&&&&&&&&&&&&&&&&&&&                          
13 //                          &&&&&&&&&&&&&&&&&&&&&&&&&&&&                          
14 //                         &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                         
15 //                       &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                         
16 //                 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                         
17 //            &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                          
18 //         &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                     
19 //        &&         &&&&&&&&&&&/&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&             
20 //                    &&&       &&&&&&&&&&&&&&&&&&&&             &&&&&&&&&        
21 //                &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                             
22 //             &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                           
23 //           &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&     &&&&&                        
24 //                   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                               
25 //                    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                          
26 //                   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&    &&&&&&&&&                   
27 //                 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                              
28 //                &&&&&&&&&&&&     &&&&&&&&&&&&&&&&&                              
29 //                &&&&&&&&            &&&&&&&&&&&&&&&                             
30 //                                       &&&&&&&&&&&&&&&&&&&&                     
31 //                                            &&&&&&&&                            
32                                                                                 
33                                                                                 
34 
35 
36 
37 // File: @openzeppelin/contracts/utils/Counters.sol
38 
39 
40 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
41 
42 pragma solidity >=0.7.0 <0.9.0;
43 
44 library Counters {
45     struct Counter {
46 
47         uint256 _value; // default: 0
48     }
49 
50     function current(Counter storage counter) internal view returns (uint256) {
51         return counter._value;
52     }
53 
54     function increment(Counter storage counter) internal {
55         unchecked {
56             counter._value += 1;
57         }
58     }
59 
60     function decrement(Counter storage counter) internal {
61         uint256 value = counter._value;
62         require(value > 0, "Counter: decrement overflow");
63         unchecked {
64             counter._value = value - 1;
65         }
66     }
67 
68     function reset(Counter storage counter) internal {
69         counter._value = 0;
70     }
71 }
72 
73 
74 
75 pragma solidity >=0.7.0 <0.9.0;
76 
77 /**
78  * @dev String operations.
79  */
80 library Strings {
81     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
85      */
86     function toString(uint256 value) internal pure returns (string memory) {
87 
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
109      */
110     function toHexString(uint256 value) internal pure returns (string memory) {
111         if (value == 0) {
112             return "0x00";
113         }
114         uint256 temp = value;
115         uint256 length = 0;
116         while (temp != 0) {
117             length++;
118             temp >>= 8;
119         }
120         return toHexString(value, length);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
125      */
126     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 }
138 
139 // File: @openzeppelin/contracts/utils/Context.sol
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
143 
144 pragma solidity >=0.7.0 <0.9.0;
145 
146 abstract contract Context {
147     function _msgSender() internal view virtual returns (address) {
148         return msg.sender;
149     }
150 
151     function _msgData() internal view virtual returns (bytes calldata) {
152         return msg.data;
153     }
154 }
155 
156 // File: @openzeppelin/contracts/access/Ownable.sol
157 
158 
159 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
160 
161 pragma solidity >=0.7.0 <0.9.0;
162 
163 
164 abstract contract Ownable is Context {
165     address private _owner;
166 
167     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
168 
169     /**
170      * @dev Initializes the contract setting the deployer as the initial owner.
171      */
172     constructor() {
173         _transferOwnership(_msgSender());
174     }
175 
176     /**
177      * @dev Returns the address of the current owner.
178      */
179     function owner() public view virtual returns (address) {
180         return _owner;
181     }
182 
183     /**
184      * @dev Throws if called by any account other than the owner.
185      */
186     modifier onlyOwner() {
187         require(owner() == _msgSender(), "Ownable: caller is not the owner");
188         _;
189     }
190 
191     function renounceOwnership() public virtual onlyOwner {
192         _transferOwnership(address(0));
193     }
194 
195     /**
196      * @dev Transfers ownership of the contract to a new account (`newOwner`).
197      * Can only be called by the current owner.
198      */
199     function transferOwnership(address newOwner) public virtual onlyOwner {
200         require(newOwner != address(0), "Ownable: new owner is the zero address");
201         _transferOwnership(newOwner);
202     }
203 
204     function _transferOwnership(address newOwner) internal virtual {
205         address oldOwner = _owner;
206         _owner = newOwner;
207         emit OwnershipTransferred(oldOwner, newOwner);
208     }
209 }
210 
211 // File: @openzeppelin/contracts/utils/Address.sol
212 
213 
214 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
215 
216 pragma solidity >=0.7.0 <0.9.0;
217 
218 /**
219  * @dev Collection of functions related to the address type
220  */
221 library Address {
222 
223     function isContract(address account) internal view returns (bool) {
224 
225 
226         uint256 size;
227         assembly {
228             size := extcodesize(account)
229         }
230         return size > 0;
231     }
232 
233     function sendValue(address payable recipient, uint256 amount) internal {
234         require(address(this).balance >= amount, "Address: insufficient balance");
235 
236         (bool success, ) = recipient.call{value: amount}("");
237         require(success, "Address: unable to send value, recipient may have reverted");
238     }
239 
240 
241     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionCall(target, data, "Address: low-level call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
247      * `errorMessage` as a fallback revert reason when `target` reverts.
248      *
249      * _Available since v3.1._
250      */
251     function functionCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         return functionCallWithValue(target, data, 0, errorMessage);
257     }
258 
259 
260     function functionCallWithValue(
261         address target,
262         bytes memory data,
263         uint256 value
264     ) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
266     }
267 
268     function functionCallWithValue(
269         address target,
270         bytes memory data,
271         uint256 value,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         require(address(this).balance >= value, "Address: insufficient balance for call");
275         require(isContract(target), "Address: call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.call{value: value}(data);
278         return verifyCallResult(success, returndata, errorMessage);
279     }
280 
281 
282     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
283         return functionStaticCall(target, data, "Address: low-level static call failed");
284     }
285 
286  
287     function functionStaticCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal view returns (bytes memory) {
292         require(isContract(target), "Address: static call to non-contract");
293 
294         (bool success, bytes memory returndata) = target.staticcall(data);
295         return verifyCallResult(success, returndata, errorMessage);
296     }
297 
298 
299     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
300         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
301     }
302 
303   
304     function functionDelegateCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         require(isContract(target), "Address: delegate call to non-contract");
310 
311         (bool success, bytes memory returndata) = target.delegatecall(data);
312         return verifyCallResult(success, returndata, errorMessage);
313     }
314 
315  
316     function verifyCallResult(
317         bool success,
318         bytes memory returndata,
319         string memory errorMessage
320     ) internal pure returns (bytes memory) {
321         if (success) {
322             return returndata;
323         } else {
324             // Look for revert reason and bubble it up if present
325             if (returndata.length > 0) {
326                 // The easiest way to bubble the revert reason is using memory via assembly
327 
328                 assembly {
329                     let returndata_size := mload(returndata)
330                     revert(add(32, returndata), returndata_size)
331                 }
332             } else {
333                 revert(errorMessage);
334             }
335         }
336     }
337 }
338 
339 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
340 
341 
342 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
343 
344 pragma solidity >=0.7.0 <0.9.0;
345 
346 interface IERC721Receiver {
347 
348     function onERC721Received(
349         address operator,
350         address from,
351         uint256 tokenId,
352         bytes calldata data
353     ) external returns (bytes4);
354 }
355 
356 
357 
358 pragma solidity >=0.7.0 <0.9.0;
359 
360 
361 interface IERC165 {
362 
363     function supportsInterface(bytes4 interfaceId) external view returns (bool);
364 }
365 
366 
367 pragma solidity >=0.7.0 <0.9.0;
368 
369 
370 abstract contract ERC165 is IERC165 {
371     /**
372      * @dev See {IERC165-supportsInterface}.
373      */
374     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
375         return interfaceId == type(IERC165).interfaceId;
376     }
377 }
378 
379 
380 
381 pragma solidity >=0.7.0 <0.9.0;
382 
383 
384 /**
385  * @dev Required interface of an ERC721 compliant contract.
386  */
387 interface IERC721 is IERC165 {
388     /**
389      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
390      */
391     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
392 
393     /**
394      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
395      */
396     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
397 
398     /**
399      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
400      */
401     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
402 
403     /**
404      * @dev Returns the number of tokens in ``owner``'s account.
405      */
406     function balanceOf(address owner) external view returns (uint256 balance);
407 
408     function ownerOf(uint256 tokenId) external view returns (address owner);
409 
410     function safeTransferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416 
417     function transferFrom(
418         address from,
419         address to,
420         uint256 tokenId
421     ) external;
422 
423 
424     function approve(address to, uint256 tokenId) external;
425 
426 
427     function getApproved(uint256 tokenId) external view returns (address operator);
428 
429     function setApprovalForAll(address operator, bool _approved) external;
430 
431     function isApprovedForAll(address owner, address operator) external view returns (bool);
432 
433     
434     function safeTransferFrom(
435         address from,
436         address to,
437         uint256 tokenId,
438         bytes calldata data
439     ) external;
440 }
441 
442 
443 
444 pragma solidity >=0.7.0 <0.9.0;
445 
446 
447 
448 interface IERC721Metadata is IERC721 {
449     /**
450      * @dev Returns the token collection name.
451      */
452     function name() external view returns (string memory);
453 
454     /**
455      * @dev Returns the token collection symbol.
456      */
457     function symbol() external view returns (string memory);
458 
459     /**
460      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
461      */
462     function tokenURI(uint256 tokenId) external view returns (string memory);
463 }
464 
465 
466 pragma solidity >=0.7.0 <0.9.0;
467 
468 
469 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
470     using Address for address;
471     using Strings for uint256;
472 
473     // Token name
474     string private _name;
475 
476     // Token symbol
477     string private _symbol;
478 
479     // Mapping from token ID to owner address
480     mapping(uint256 => address) private _owners;
481 
482     // Mapping owner address to token count
483     mapping(address => uint256) private _balances;
484 
485     // Mapping from token ID to approved address
486     mapping(uint256 => address) private _tokenApprovals;
487 
488     // Mapping from owner to operator approvals
489     mapping(address => mapping(address => bool)) private _operatorApprovals;
490 
491     /**
492      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
493      */
494     constructor(string memory name_, string memory symbol_) {
495         _name = name_;
496         _symbol = symbol_;
497     }
498 
499     /**
500      * @dev See {IERC165-supportsInterface}.
501      */
502     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
503         return
504             interfaceId == type(IERC721).interfaceId ||
505             interfaceId == type(IERC721Metadata).interfaceId ||
506             super.supportsInterface(interfaceId);
507     }
508 
509     /**
510      * @dev See {IERC721-balanceOf}.
511      */
512     function balanceOf(address owner) public view virtual override returns (uint256) {
513         require(owner != address(0), "ERC721: balance query for the zero address");
514         return _balances[owner];
515     }
516 
517     /**
518      * @dev See {IERC721-ownerOf}.
519      */
520     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
521         address owner = _owners[tokenId];
522         require(owner != address(0), "ERC721: owner query for nonexistent token");
523         return owner;
524     }
525 
526     /**
527      * @dev See {IERC721Metadata-name}.
528      */
529     function name() public view virtual override returns (string memory) {
530         return _name;
531     }
532 
533     /**
534      * @dev See {IERC721Metadata-symbol}.
535      */
536     function symbol() public view virtual override returns (string memory) {
537         return _symbol;
538     }
539 
540     /**
541      * @dev See {IERC721Metadata-tokenURI}.
542      */
543     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
544         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
545 
546         string memory baseURI = _baseURI();
547         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
548     }
549 
550 
551     function _baseURI() internal view virtual returns (string memory) {
552         return "";
553     }
554 
555     /**
556      * @dev See {IERC721-approve}.
557      */
558     function approve(address to, uint256 tokenId) public virtual override {
559         address owner = ERC721.ownerOf(tokenId);
560         require(to != owner, "ERC721: approval to current owner");
561 
562         require(
563             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
564             "ERC721: approve caller is not owner nor approved for all"
565         );
566 
567         _approve(to, tokenId);
568     }
569 
570     /**
571      * @dev See {IERC721-getApproved}.
572      */
573     function getApproved(uint256 tokenId) public view virtual override returns (address) {
574         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
575 
576         return _tokenApprovals[tokenId];
577     }
578 
579     /**
580      * @dev See {IERC721-setApprovalForAll}.
581      */
582     function setApprovalForAll(address operator, bool approved) public virtual override {
583         _setApprovalForAll(_msgSender(), operator, approved);
584     }
585 
586     /**
587      * @dev See {IERC721-isApprovedForAll}.
588      */
589     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
590         return _operatorApprovals[owner][operator];
591     }
592 
593     /**
594      * @dev See {IERC721-transferFrom}.
595      */
596     function transferFrom(
597         address from,
598         address to,
599         uint256 tokenId
600     ) public virtual override {
601         //solhint-disable-next-line max-line-length
602         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
603 
604         _transfer(from, to, tokenId);
605     }
606 
607     /**
608      * @dev See {IERC721-safeTransferFrom}.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) public virtual override {
615         safeTransferFrom(from, to, tokenId, "");
616     }
617 
618     /**
619      * @dev See {IERC721-safeTransferFrom}.
620      */
621     function safeTransferFrom(
622         address from,
623         address to,
624         uint256 tokenId,
625         bytes memory _data
626     ) public virtual override {
627         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
628         _safeTransfer(from, to, tokenId, _data);
629     }
630 
631 
632     function _safeTransfer(
633         address from,
634         address to,
635         uint256 tokenId,
636         bytes memory _data
637     ) internal virtual {
638         _transfer(from, to, tokenId);
639         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
640     }
641 
642 
643     function _exists(uint256 tokenId) internal view virtual returns (bool) {
644         return _owners[tokenId] != address(0);
645     }
646 
647 
648     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
649         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
650         address owner = ERC721.ownerOf(tokenId);
651         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
652     }
653 
654 
655     function _safeMint(address to, uint256 tokenId) internal virtual {
656         _safeMint(to, tokenId, "");
657     }
658 
659   
660     function _safeMint(
661         address to,
662         uint256 tokenId,
663         bytes memory _data
664     ) internal virtual {
665         _mint(to, tokenId);
666         require(
667             _checkOnERC721Received(address(0), to, tokenId, _data),
668             "ERC721: transfer to non ERC721Receiver implementer"
669         );
670     }
671 
672 
673     function _mint(address to, uint256 tokenId) internal virtual {
674         require(to != address(0), "ERC721: mint to the zero address");
675         require(!_exists(tokenId), "ERC721: token already minted");
676 
677         _beforeTokenTransfer(address(0), to, tokenId);
678 
679         _balances[to] += 1;
680         _owners[tokenId] = to;
681 
682         emit Transfer(address(0), to, tokenId);
683     }
684 
685     function _burn(uint256 tokenId) internal virtual {
686         address owner = ERC721.ownerOf(tokenId);
687 
688         _beforeTokenTransfer(owner, address(0), tokenId);
689 
690         // Clear approvals
691         _approve(address(0), tokenId);
692 
693         _balances[owner] -= 1;
694         delete _owners[tokenId];
695 
696         emit Transfer(owner, address(0), tokenId);
697     }
698 
699 
700     function _transfer(
701         address from,
702         address to,
703         uint256 tokenId
704     ) internal virtual {
705         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
706         require(to != address(0), "ERC721: transfer to the zero address");
707 
708         _beforeTokenTransfer(from, to, tokenId);
709 
710         // Clear approvals from the previous owner
711         _approve(address(0), tokenId);
712 
713         _balances[from] -= 1;
714         _balances[to] += 1;
715         _owners[tokenId] = to;
716 
717         emit Transfer(from, to, tokenId);
718     }
719 
720 
721     function _approve(address to, uint256 tokenId) internal virtual {
722         _tokenApprovals[tokenId] = to;
723         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
724     }
725 
726 
727     function _setApprovalForAll(
728         address owner,
729         address operator,
730         bool approved
731     ) internal virtual {
732         require(owner != operator, "ERC721: approve to caller");
733         _operatorApprovals[owner][operator] = approved;
734         emit ApprovalForAll(owner, operator, approved);
735     }
736 
737 
738     function _checkOnERC721Received(
739         address from,
740         address to,
741         uint256 tokenId,
742         bytes memory _data
743     ) private returns (bool) {
744         if (to.isContract()) {
745             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
746                 return retval == IERC721Receiver.onERC721Received.selector;
747             } catch (bytes memory reason) {
748                 if (reason.length == 0) {
749                     revert("ERC721: transfer to non ERC721Receiver implementer");
750                 } else {
751                     assembly {
752                         revert(add(32, reason), mload(reason))
753                     }
754                 }
755             }
756         } else {
757             return true;
758         }
759     }
760 
761 
762     function _beforeTokenTransfer(
763         address from,
764         address to,
765         uint256 tokenId
766     ) internal virtual {}
767 }
768 
769 
770                                                                                 
771                                                                                 
772                                                                                 
773 //                                                       &&&&&&&&&&&&             
774 //                                                  &&&&&&&&&&&&&&&&&&&&&         
775 //                                               &&&&&&&&&&&&&&&&&&&&&&&&&&       
776 //                                             &&&&&&&&&&&&&&&                    
777 //                                          &&&&&&&&&&&&&&&                       
778 //                                      &&&&&&&&&&&&&&&&&                         
779 //                                &&&&&&&&&&&&&&&&&&&&&&                          
780 //                             &&&&&&&&&&&&&&&&&&&&&&&&&                          
781 //                          &&&&&&&&&&&&&&&&&&&&&&&&&&&&                          
782 //                         &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                         
783 //                       &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                         
784 //                 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                         
785 //            &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                          
786 //         &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                     
787 //        &&         &&&&&&&&&&&/&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&             
788 //                    &&&       &&&&&&&&&&&&&&&&&&&&             &&&&&&&&&        
789 //                &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                             
790 //             &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                           
791 //           &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&     &&&&&                        
792 //                   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                               
793 //                    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                          
794 //                   &&&&&&&&&&&&&&&&&&&&&&&&&&&&&    &&&&&&&&&                   
795 //                 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                              
796 //                &&&&&&&&&&&&     &&&&&&&&&&&&&&&&&                              
797 //                &&&&&&&&            &&&&&&&&&&&&&&&                             
798 //                                       &&&&&&&&&&&&&&&&&&&&                     
799 //                                            &&&&&&&&                            
800                                                                                 
801                                                                                 
802 
803 
804 
805 // File: contracts/Goblin_Lucky_Charm.sol
806 
807 
808 
809 pragma solidity >=0.7.0 <0.9.0;
810 
811 contract Goblin_Lucky_Charm is ERC721, Ownable {
812   using Strings for uint256;
813   using Counters for Counters.Counter;
814 
815   Counters.Counter private supply;
816 
817   string public uriPrefix = "ipfs://QmRz7gdRwvREKp7DsYS1LFeGcJaVvVbzMTTiAtPNydPUdo/";
818   string public uriSuffix = ".json";
819   string public hiddenMetadataUri;
820   
821   uint256 public cost = 0 ether;
822   uint256 public maxSupply = 5825;
823   uint256 public maxMintAmountPerTx = 2;
824   uint256 public nftPerAddressLimit = 2;
825 
826 
827   bool public paused = false;
828   bool public revealed = true;
829 
830   mapping(address => uint256) public addressMintedBalance;
831 
832   constructor() ERC721("Goblin Lucky Charm", "GLC") {
833     setHiddenMetadataUri("");
834   }
835 
836   modifier mintCompliance(uint256 _mintAmount) {
837     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
838     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
839     _;
840   }
841 
842   function totalSupply() public view returns (uint256) {
843     return supply.current();
844   }
845 
846   function CastCharm(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
847     require(!paused, "The contract is paused!");
848     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
849 
850     _mintLoop(msg.sender, _mintAmount);
851   }
852   
853   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
854     _mintLoop2(_receiver, _mintAmount);
855   }
856 
857   function walletOfOwner(address _owner)
858     public
859     view
860     returns (uint256[] memory)
861   {
862     uint256 ownerTokenCount = balanceOf(_owner);
863     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
864     uint256 currentTokenId = 1;
865     uint256 ownedTokenIndex = 0;
866 
867     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
868       address currentTokenOwner = ownerOf(currentTokenId);
869 
870       if (currentTokenOwner == _owner) {
871         ownedTokenIds[ownedTokenIndex] = currentTokenId;
872 
873         ownedTokenIndex++;
874       }
875 
876       currentTokenId++;
877     }
878 
879     return ownedTokenIds;
880   }
881 
882   function tokenURI(uint256 _tokenId)
883     public
884     view
885     virtual
886     override
887     returns (string memory)
888   {
889     require(
890       _exists(_tokenId),
891       "ERC721Metadata: URI query for nonexistent token"
892     );
893 
894     if (revealed == false) {
895       return hiddenMetadataUri;
896     }
897 
898     string memory currentBaseURI = _baseURI();
899     return bytes(currentBaseURI).length > 0
900         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
901         : "";
902   }
903 
904   function setRevealed(bool _state) public onlyOwner {
905     revealed = _state;
906   }
907 
908   function setCost(uint256 _cost) public onlyOwner {
909     cost = _cost;
910   }
911 
912   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
913     maxMintAmountPerTx = _maxMintAmountPerTx;
914   }
915 
916   function setnftPerAddressLimit(uint256 _nftPerAddressLimit) public onlyOwner {
917     nftPerAddressLimit = _nftPerAddressLimit;
918   }
919 
920   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
921     maxSupply = _maxSupply;
922   }
923 
924   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
925     hiddenMetadataUri = _hiddenMetadataUri;
926   }
927 
928   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
929     uriPrefix = _uriPrefix;
930   }
931 
932   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
933     uriSuffix = _uriSuffix;
934   }
935 
936   function setPaused(bool _state) public onlyOwner {
937     paused = _state;
938   }
939 
940   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
941 
942     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
943     require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
944     
945     for (uint256 i = 0; i < _mintAmount; i++) {
946       supply.increment();
947       addressMintedBalance[msg.sender]++;
948       _safeMint(_receiver, supply.current());
949     }
950   }
951 
952   function _mintLoop2(address _receiver, uint256 _mintAmount) internal {
953     for (uint256 i = 0; i < _mintAmount; i++) {
954       supply.increment();
955       _safeMint(_receiver, supply.current());
956     }
957   }
958 
959   function _baseURI() internal view virtual override returns (string memory) {
960     return uriPrefix;
961   }
962 
963   function withdraw() public onlyOwner {
964     // =============================================================================
965     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
966     require(os);
967     // =============================================================================
968   }
969   
970 }