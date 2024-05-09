1 // SPDX-License-Identifier: MIT
2 
3 /**
4  * @title Angry Bears contract
5  */
6 
7 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
8 
9 
10 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 interface IERC20 {
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address to, uint256 amount) external returns (bool);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26  
27     function transferFrom(
28         address from,
29         address to,
30         uint256 amount
31     ) external returns (bool);
32 
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
40 
41 
42 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 abstract contract ReentrancyGuard {
47 
48     uint256 private constant _NOT_ENTERED = 1;
49     uint256 private constant _ENTERED = 2;
50 
51     uint256 private _status;
52 
53     constructor() {
54         _status = _NOT_ENTERED;
55     }
56 
57  
58     modifier nonReentrant() {
59  
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         _status = _ENTERED;
63 
64         _;
65 
66         _status = _NOT_ENTERED;
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Strings.sol
71 
72 
73 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     function toString(uint256 value) internal pure returns (string memory) {
81 
82         if (value == 0) {
83             return "0";
84         }
85         uint256 temp = value;
86         uint256 digits;
87         while (temp != 0) {
88             digits++;
89             temp /= 10;
90         }
91         bytes memory buffer = new bytes(digits);
92         while (value != 0) {
93             digits -= 1;
94             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
95             value /= 10;
96         }
97         return string(buffer);
98     }
99 
100 
101     function toHexString(uint256 value) internal pure returns (string memory) {
102         if (value == 0) {
103             return "0x00";
104         }
105         uint256 temp = value;
106         uint256 length = 0;
107         while (temp != 0) {
108             length++;
109             temp >>= 8;
110         }
111         return toHexString(value, length);
112     }
113 
114   
115     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
116         bytes memory buffer = new bytes(2 * length + 2);
117         buffer[0] = "0";
118         buffer[1] = "x";
119         for (uint256 i = 2 * length + 1; i > 1; --i) {
120             buffer[i] = _HEX_SYMBOLS[value & 0xf];
121             value >>= 4;
122         }
123         require(value == 0, "Strings: hex length insufficient");
124         return string(buffer);
125     }
126 }
127 
128 // File: @openzeppelin/contracts/utils/Context.sol
129 
130 
131 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
132 
133 pragma solidity ^0.8.0;
134 
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/access/Ownable.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 
153 
154 abstract contract Ownable is Context {
155     address private _owner;
156 
157     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
158 
159     constructor() {
160         _transferOwnership(_msgSender());
161     }
162 
163 
164     function owner() public view virtual returns (address) {
165         return _owner;
166     }
167 
168     modifier onlyOwner() {
169         require(owner() == _msgSender(), "Ownable: caller is not the owner");
170         _;
171     }
172 
173  
174     function renounceOwnership() public virtual onlyOwner {
175         _transferOwnership(address(0));
176     }
177 
178     function transferOwnership(address newOwner) public virtual onlyOwner {
179         require(newOwner != address(0), "Ownable: new owner is the zero address");
180         _transferOwnership(newOwner);
181     }
182 
183    
184     function _transferOwnership(address newOwner) internal virtual {
185         address oldOwner = _owner;
186         _owner = newOwner;
187         emit OwnershipTransferred(oldOwner, newOwner);
188     }
189 }
190 
191 // File: @openzeppelin/contracts/utils/Address.sol
192 
193 
194 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
195 
196 pragma solidity ^0.8.1;
197 
198 /**
199  * @dev Collection of functions related to the address type
200  */
201 library Address {
202 
203     function isContract(address account) internal view returns (bool) {
204 
205         return account.code.length > 0;
206     }
207 
208     function sendValue(address payable recipient, uint256 amount) internal {
209         require(address(this).balance >= amount, "Address: insufficient balance");
210 
211         (bool success, ) = recipient.call{value: amount}("");
212         require(success, "Address: unable to send value, recipient may have reverted");
213     }
214 
215 
216     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
217         return functionCall(target, data, "Address: low-level call failed");
218     }
219 
220  
221     function functionCall(
222         address target,
223         bytes memory data,
224         string memory errorMessage
225     ) internal returns (bytes memory) {
226         return functionCallWithValue(target, data, 0, errorMessage);
227     }
228 
229    
230     function functionCallWithValue(
231         address target,
232         bytes memory data,
233         uint256 value
234     ) internal returns (bytes memory) {
235         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
236     }
237 
238  
239     function functionCallWithValue(
240         address target,
241         bytes memory data,
242         uint256 value,
243         string memory errorMessage
244     ) internal returns (bytes memory) {
245         require(address(this).balance >= value, "Address: insufficient balance for call");
246         require(isContract(target), "Address: call to non-contract");
247 
248         (bool success, bytes memory returndata) = target.call{value: value}(data);
249         return verifyCallResult(success, returndata, errorMessage);
250     }
251 
252  
253     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
254         return functionStaticCall(target, data, "Address: low-level static call failed");
255     }
256 
257  
258     function functionStaticCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal view returns (bytes memory) {
263         require(isContract(target), "Address: static call to non-contract");
264 
265         (bool success, bytes memory returndata) = target.staticcall(data);
266         return verifyCallResult(success, returndata, errorMessage);
267     }
268 
269 
270     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
271         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
272     }
273 
274     function functionDelegateCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         require(isContract(target), "Address: delegate call to non-contract");
280 
281         (bool success, bytes memory returndata) = target.delegatecall(data);
282         return verifyCallResult(success, returndata, errorMessage);
283     }
284 
285   
286     function verifyCallResult(
287         bool success,
288         bytes memory returndata,
289         string memory errorMessage
290     ) internal pure returns (bytes memory) {
291         if (success) {
292             return returndata;
293         } else {
294             // Look for revert reason and bubble it up if present
295             if (returndata.length > 0) {
296                 // The easiest way to bubble the revert reason is using memory via assembly
297 
298                 assembly {
299                     let returndata_size := mload(returndata)
300                     revert(add(32, returndata), returndata_size)
301                 }
302             } else {
303                 revert(errorMessage);
304             }
305         }
306     }
307 }
308 
309 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
310 
311 
312 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 
317 
318 
319 library SafeERC20 {
320     using Address for address;
321 
322     function safeTransfer(
323         IERC20 token,
324         address to,
325         uint256 value
326     ) internal {
327         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
328     }
329 
330     function safeTransferFrom(
331         IERC20 token,
332         address from,
333         address to,
334         uint256 value
335     ) internal {
336         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
337     }
338 
339     function safeApprove(
340         IERC20 token,
341         address spender,
342         uint256 value
343     ) internal {
344 
345         require(
346             (value == 0) || (token.allowance(address(this), spender) == 0),
347             "SafeERC20: approve from non-zero to non-zero allowance"
348         );
349         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
350     }
351 
352     function safeIncreaseAllowance(
353         IERC20 token,
354         address spender,
355         uint256 value
356     ) internal {
357         uint256 newAllowance = token.allowance(address(this), spender) + value;
358         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
359     }
360 
361     function safeDecreaseAllowance(
362         IERC20 token,
363         address spender,
364         uint256 value
365     ) internal {
366         unchecked {
367             uint256 oldAllowance = token.allowance(address(this), spender);
368             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
369             uint256 newAllowance = oldAllowance - value;
370             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
371         }
372     }
373 
374  
375     function _callOptionalReturn(IERC20 token, bytes memory data) private {
376 
377         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
378         if (returndata.length > 0) {
379             // Return data is optional
380             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
381         }
382     }
383 }
384 
385 
386 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
387 
388 
389 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
390 
391 pragma solidity ^0.8.0;
392 
393  
394 interface IERC721Receiver {
395 
396     function onERC721Received(
397         address operator,
398         address from,
399         uint256 tokenId,
400         bytes calldata data
401     ) external returns (bytes4);
402 }
403 
404 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
405 
406 
407 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
408 
409 pragma solidity ^0.8.0;
410 
411 interface IERC165 {
412  
413     function supportsInterface(bytes4 interfaceId) external view returns (bool);
414 }
415 
416 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
417 
418 
419 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 
424 
425 abstract contract ERC165 is IERC165 {
426   
427     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
428         return interfaceId == type(IERC165).interfaceId;
429     }
430 }
431 
432 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 
440 
441 interface IERC721 is IERC165 {
442  
443     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
444 
445 
446     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
447 
448     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
449 
450     function balanceOf(address owner) external view returns (uint256 balance);
451 
452  
453     function ownerOf(uint256 tokenId) external view returns (address owner);
454 
455     function safeTransferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461 
462     function transferFrom(
463         address from,
464         address to,
465         uint256 tokenId
466     ) external;
467 
468 
469     function approve(address to, uint256 tokenId) external;
470 
471     function getApproved(uint256 tokenId) external view returns (address operator);
472 
473 
474     function setApprovalForAll(address operator, bool _approved) external;
475 
476     function isApprovedForAll(address owner, address operator) external view returns (bool);
477 
478  
479     function safeTransferFrom(
480         address from,
481         address to,
482         uint256 tokenId,
483         bytes calldata data
484     ) external;
485 }
486 
487 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
488 
489 
490 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 
495 
496 interface IERC721Enumerable is IERC721 {
497 
498     function totalSupply() external view returns (uint256);
499 
500  
501     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
502 
503  
504     function tokenByIndex(uint256 index) external view returns (uint256);
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
508 
509 
510 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 
515 
516 interface IERC721Metadata is IERC721 {
517 
518     function name() external view returns (string memory);
519 
520    
521     function symbol() external view returns (string memory);
522 
523   
524     function tokenURI(uint256 tokenId) external view returns (string memory);
525 }
526 
527 // File: contracts/TwistedToonz.sol
528 
529 
530 // Creator: Chiru Labs
531 
532 pragma solidity ^0.8.0;
533 
534 
535 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
536     using Address for address;
537     using Strings for uint256;
538 
539     struct TokenOwnership {
540         address addr;
541         uint64 startTimestamp;
542     }
543 
544     struct AddressData {
545         uint128 balance;
546         uint128 numberMinted;
547     }
548 
549     uint256 internal currentIndex;
550 
551     // Token name
552     string private _name;
553 
554     // Token symbol
555     string private _symbol;
556 
557     mapping(uint256 => TokenOwnership) internal _ownerships;
558 
559     // Mapping owner address to address data
560     mapping(address => AddressData) private _addressData;
561 
562     // Mapping from token ID to approved address
563     mapping(uint256 => address) private _tokenApprovals;
564 
565     // Mapping from owner to operator approvals
566     mapping(address => mapping(address => bool)) private _operatorApprovals;
567 
568     constructor(string memory name_, string memory symbol_) {
569         _name = name_;
570         _symbol = symbol_;
571     }
572 
573    
574     function totalSupply() public view override returns (uint256) {
575         return currentIndex;
576     }
577 
578     function tokenByIndex(uint256 index) public view override returns (uint256) {
579         require(index < totalSupply(), "ERC721A: global index out of bounds");
580         return index;
581     }
582 
583     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
584         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
585         uint256 numMintedSoFar = totalSupply();
586         uint256 tokenIdsIdx;
587         address currOwnershipAddr;
588 
589         unchecked {
590             for (uint256 i; i < numMintedSoFar; i++) {
591                 TokenOwnership memory ownership = _ownerships[i];
592                 if (ownership.addr != address(0)) {
593                     currOwnershipAddr = ownership.addr;
594                 }
595                 if (currOwnershipAddr == owner) {
596                     if (tokenIdsIdx == index) {
597                         return i;
598                     }
599                     tokenIdsIdx++;
600                 }
601             }
602         }
603 
604         revert("ERC721A: unable to get token of owner by index");
605     }
606 
607 
608     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
609         return
610             interfaceId == type(IERC721).interfaceId ||
611             interfaceId == type(IERC721Metadata).interfaceId ||
612             interfaceId == type(IERC721Enumerable).interfaceId ||
613             super.supportsInterface(interfaceId);
614     }
615 
616     function balanceOf(address owner) public view override returns (uint256) {
617         require(owner != address(0), "ERC721A: balance query for the zero address");
618         return uint256(_addressData[owner].balance);
619     }
620 
621     function _numberMinted(address owner) internal view returns (uint256) {
622         require(owner != address(0), "ERC721A: number minted query for the zero address");
623         return uint256(_addressData[owner].numberMinted);
624     }
625 
626 
627     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
628         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
629 
630         unchecked {
631             for (uint256 curr = tokenId; curr >= 0; curr--) {
632                 TokenOwnership memory ownership = _ownerships[curr];
633                 if (ownership.addr != address(0)) {
634                     return ownership;
635                 }
636             }
637         }
638 
639         revert("ERC721A: unable to determine the owner of token");
640     }
641 
642     function ownerOf(uint256 tokenId) public view override returns (address) {
643         return ownershipOf(tokenId).addr;
644     }
645 
646 
647     function name() public view virtual override returns (string memory) {
648         return _name;
649     }
650 
651 
652     function symbol() public view virtual override returns (string memory) {
653         return _symbol;
654     }
655 
656   
657     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
658         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
659 
660         string memory baseURI = _baseURI();
661         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
662     }
663 
664  
665     function _baseURI() internal view virtual returns (string memory) {
666         return "";
667     }
668 
669 
670     function approve(address to, uint256 tokenId) public override {
671         address owner = ERC721A.ownerOf(tokenId);
672         require(to != owner, "ERC721A: approval to current owner");
673 
674         require(
675             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
676             "ERC721A: approve caller is not owner nor approved for all"
677         );
678 
679         _approve(to, tokenId, owner);
680     }
681 
682 
683     function getApproved(uint256 tokenId) public view override returns (address) {
684         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
685 
686         return _tokenApprovals[tokenId];
687     }
688 
689 
690     function setApprovalForAll(address operator, bool approved) public override {
691         require(operator != _msgSender(), "ERC721A: approve to caller");
692 
693         _operatorApprovals[_msgSender()][operator] = approved;
694         emit ApprovalForAll(_msgSender(), operator, approved);
695     }
696 
697  
698     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
699         return _operatorApprovals[owner][operator];
700     }
701 
702   
703     function transferFrom(
704         address from,
705         address to,
706         uint256 tokenId
707     ) public virtual override {
708         _transfer(from, to, tokenId);
709     }
710 
711   
712     function safeTransferFrom(
713         address from,
714         address to,
715         uint256 tokenId
716     ) public virtual override {
717         safeTransferFrom(from, to, tokenId, "");
718     }
719 
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 tokenId,
724         bytes memory _data
725     ) public override {
726         _transfer(from, to, tokenId);
727         require(
728             _checkOnERC721Received(from, to, tokenId, _data),
729             "ERC721A: transfer to non ERC721Receiver implementer"
730         );
731     }
732 
733 
734     function _exists(uint256 tokenId) internal view returns (bool) {
735         return tokenId < currentIndex;
736     }
737 
738     function _safeMint(address to, uint256 quantity) internal {
739         _safeMint(to, quantity, "");
740     }
741 
742 
743     function _safeMint(
744         address to,
745         uint256 quantity,
746         bytes memory _data
747     ) internal {
748         _mint(to, quantity, _data, true);
749     }
750 
751 
752     function _mint(
753         address to,
754         uint256 quantity,
755         bytes memory _data,
756         bool safe
757     ) internal {
758         uint256 startTokenId = currentIndex;
759         require(to != address(0), "ERC721A: mint to the zero address");
760         require(quantity != 0, "ERC721A: quantity must be greater than 0");
761 
762         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
763 
764 
765         unchecked {
766             _addressData[to].balance += uint128(quantity);
767             _addressData[to].numberMinted += uint128(quantity);
768 
769             _ownerships[startTokenId].addr = to;
770             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
771 
772             uint256 updatedIndex = startTokenId;
773 
774             for (uint256 i; i < quantity; i++) {
775                 emit Transfer(address(0), to, updatedIndex);
776                 if (safe) {
777                     require(
778                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
779                         "ERC721A: transfer to non ERC721Receiver implementer"
780                     );
781                 }
782 
783                 updatedIndex++;
784             }
785 
786             currentIndex = updatedIndex;
787         }
788 
789         _afterTokenTransfers(address(0), to, startTokenId, quantity);
790     }
791 
792 
793     function _transfer(
794         address from,
795         address to,
796         uint256 tokenId
797     ) private {
798         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
799 
800         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
801             getApproved(tokenId) == _msgSender() ||
802             isApprovedForAll(prevOwnership.addr, _msgSender()));
803 
804         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
805 
806         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
807         require(to != address(0), "ERC721A: transfer to the zero address");
808 
809         _beforeTokenTransfers(from, to, tokenId, 1);
810 
811  
812         _approve(address(0), tokenId, prevOwnership.addr);
813 
814 
815         unchecked {
816             _addressData[from].balance -= 1;
817             _addressData[to].balance += 1;
818 
819             _ownerships[tokenId].addr = to;
820             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
821 
822 
823             uint256 nextTokenId = tokenId + 1;
824             if (_ownerships[nextTokenId].addr == address(0)) {
825                 if (_exists(nextTokenId)) {
826                     _ownerships[nextTokenId].addr = prevOwnership.addr;
827                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
828                 }
829             }
830         }
831 
832         emit Transfer(from, to, tokenId);
833         _afterTokenTransfers(from, to, tokenId, 1);
834     }
835 
836 
837     function _approve(
838         address to,
839         uint256 tokenId,
840         address owner
841     ) private {
842         _tokenApprovals[tokenId] = to;
843         emit Approval(owner, to, tokenId);
844     }
845 
846 
847     function _checkOnERC721Received(
848         address from,
849         address to,
850         uint256 tokenId,
851         bytes memory _data
852     ) private returns (bool) {
853         if (to.isContract()) {
854             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
855                 return retval == IERC721Receiver(to).onERC721Received.selector;
856             } catch (bytes memory reason) {
857                 if (reason.length == 0) {
858                     revert("ERC721A: transfer to non ERC721Receiver implementer");
859                 } else {
860                     assembly {
861                         revert(add(32, reason), mload(reason))
862                     }
863                 }
864             }
865         } else {
866             return true;
867         }
868     }
869 
870   
871     function _beforeTokenTransfers(
872         address from,
873         address to,
874         uint256 startTokenId,
875         uint256 quantity
876     ) internal virtual {}
877 
878  
879     function _afterTokenTransfers(
880         address from,
881         address to,
882         uint256 startTokenId,
883         uint256 quantity
884     ) internal virtual {}
885 }
886 
887 contract AngryBears is ERC721A, Ownable, ReentrancyGuard {
888 
889   string public        baseURI;
890   uint public          price             = 0.002 ether;
891   uint public          maxPerTx          = 10;
892   uint public          maxFreePerWallet  = 1;
893   uint public          totalFree         = 200;
894   uint public          maxSupply         = 414;
895   uint public          nextOwnerToExplicitlySet;
896   bool public          mintEnabled;
897 
898   constructor() ERC721A("Angry Bears", "AGB"){}
899 
900     modifier callerIsUser() {
901         require(tx.origin == msg.sender, "The caller is another contract");
902         _;
903     }
904 
905   function freeMint(uint256 amt) external callerIsUser {
906     require(mintEnabled, "Public sale has not begun yet");
907     require(totalSupply() + amt <= totalFree, "Reached max free supply");
908     require(amt <= 10, "can not mint this many free at a time");
909     require(numberMinted(msg.sender) + amt <= maxFreePerWallet,"Too many free per wallet!");
910     _safeMint(msg.sender, amt);
911     }
912 
913   function mint(uint256 amt) external payable
914   {
915     uint cost = price;
916     require(msg.sender == tx.origin,"The caller is another contract");
917     require(msg.value >= amt * cost,"Please send the exact amount.");
918     require(totalSupply() + amt < maxSupply + 1,"Reached max supply");
919     require(mintEnabled, "Public sale has not begun yet");
920     require( amt < maxPerTx + 1, "Max per TX reached.");
921 
922     _safeMint(msg.sender, amt);
923   }
924 
925   function ownerMint(uint256 amt) external onlyOwner
926   {
927     require(totalSupply() + amt < maxSupply + 1,"too many!");
928 
929     _safeMint(msg.sender, amt);
930   }
931 
932   function toggleMinting() external onlyOwner {
933       mintEnabled = !mintEnabled;
934   }
935 
936   function numberMinted(address owner) public view returns (uint256) {
937     return _numberMinted(owner);
938   }
939 
940   function setBaseURI(string calldata baseURI_) external onlyOwner {
941     baseURI = baseURI_;
942   }
943 
944   function setPrice(uint256 price_) external onlyOwner {
945       price = price_;
946   }
947 
948   function setTotalFree(uint256 totalFree_) external onlyOwner {
949       totalFree = totalFree_;
950   }
951 
952   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
953       maxPerTx = maxPerTx_;
954   }
955 
956   function setMaxPerWallet(uint256 maxFreePerWallet_) external onlyOwner {
957       maxFreePerWallet = maxFreePerWallet_;
958   }
959 
960   function setmaxSupply(uint256 maxSupply_) external onlyOwner {
961       maxSupply = maxSupply_;
962   }
963 
964   function _baseURI() internal view virtual override returns (string memory) {
965     return baseURI;
966   }
967 
968   function withdraw() external onlyOwner nonReentrant {
969     (bool success, ) = msg.sender.call{value: address(this).balance}("");
970     require(success, "Transfer failed.");
971   }
972 
973   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
974     _setOwnersExplicit(quantity);
975   }
976 
977   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory)
978   {
979     return ownershipOf(tokenId);
980   }
981 
982 
983   function _setOwnersExplicit(uint256 quantity) internal {
984       require(quantity != 0, "quantity must be nonzero");
985       require(currentIndex != 0, "no tokens minted yet");
986       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
987       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
988 
989 
990       unchecked {
991           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
992 
993           if (endIndex + 1 > currentIndex) {
994               endIndex = currentIndex - 1;
995           }
996 
997           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
998               if (_ownerships[i].addr == address(0)) {
999                   TokenOwnership memory ownership = ownershipOf(i);
1000                   _ownerships[i].addr = ownership.addr;
1001                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1002               }
1003           }
1004 
1005           nextOwnerToExplicitlySet = endIndex + 1;
1006       }
1007   }
1008 }