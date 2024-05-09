1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-31
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.1;
8 
9 abstract contract ReentrancyGuard {
10  
11     uint256 private constant _NOT_ENTERED = 1;
12     uint256 private constant _ENTERED = 2;
13 
14     uint256 private _status;
15 
16     constructor() {
17         _status = _NOT_ENTERED;
18     }
19 
20     modifier nonReentrant() {
21         // On the first call to nonReentrant, _notEntered will be true
22         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
23 
24         // Any calls to nonReentrant after this point will fail
25         _status = _ENTERED;
26 
27         _;
28 
29         _status = _NOT_ENTERED;
30     }
31 }
32 
33 
34 interface IERC20 {
35 
36     function totalSupply() external view returns (uint256);
37 
38 
39     function balanceOf(address account) external view returns (uint256);
40 
41     
42     function mintOf(address account) external view returns (uint256);
43 
44 
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47 
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50 
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53   
54     function transferFrom(
55         address sender,
56         address recipient,
57         uint256 amount
58     ) external returns (bool);
59 
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62 
63 
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 
68 
69 
70 library Strings {
71     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
72 
73     function toString(uint256 value) internal pure returns (string memory) {
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
93     
94     function toHexString(uint256 value) internal pure returns (string memory) {
95         if (value == 0) {
96             return "0x00";
97         }
98         uint256 temp = value;
99         uint256 length = 0;
100         while (temp != 0) {
101             length++;
102             temp >>= 8;
103         }
104         return toHexString(value, length);
105     }
106 
107  
108     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
109         bytes memory buffer = new bytes(2 * length + 2);
110         buffer[0] = "0";
111         buffer[1] = "x";
112         for (uint256 i = 2 * length + 1; i > 1; --i) {
113             buffer[i] = _HEX_SYMBOLS[value & 0xf];
114             value >>= 4;
115         }
116         require(value == 0, "Strings: hex length insufficient");
117         return string(buffer);
118     }
119 }
120 
121 
122 
123 
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         return msg.data;
131     }
132 }
133 
134 
135 
136 abstract contract Ownable is Context {
137     address private _owner;
138 
139     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
140 
141     constructor() {
142         _transferOwnership(_msgSender());
143     }
144 
145 
146     function owner() public view virtual returns (address) {
147         return _owner;
148     }
149 
150 
151     modifier onlyOwner() {
152         require(owner() == _msgSender(), "Ownable: caller is not the owner");
153         _;
154     }
155 
156     function renounceOwnership() public virtual onlyOwner {
157         _transferOwnership(address(0));
158     }
159 
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165 
166     function _transferOwnership(address newOwner) internal virtual {
167         address oldOwner = _owner;
168         _owner = newOwner;
169         emit OwnershipTransferred(oldOwner, newOwner);
170     }
171 }
172 
173 
174 library Address {
175 
176     function isContract(address account) internal view returns (bool) {
177 
178         uint256 size;
179         assembly {
180             size := extcodesize(account)
181         }
182         return size > 0;
183     }
184 
185     function sendValue(address payable recipient, uint256 amount) internal {
186         require(address(this).balance >= amount, "Address: insufficient balance");
187 
188         (bool success, ) = recipient.call{value: amount}("");
189         require(success, "Address: unable to send value, recipient may have reverted");
190     }
191 
192     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
193         return functionCall(target, data, "Address: low-level call failed");
194     }
195 
196 
197     function functionCall(
198         address target,
199         bytes memory data,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, 0, errorMessage);
203     }
204 
205     function functionCallWithValue(
206         address target,
207         bytes memory data,
208         uint256 value
209     ) internal returns (bytes memory) {
210         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
211     }
212 
213  
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value,
218         string memory errorMessage
219     ) internal returns (bytes memory) {
220         require(address(this).balance >= value, "Address: insufficient balance for call");
221         require(isContract(target), "Address: call to non-contract");
222 
223         (bool success, bytes memory returndata) = target.call{value: value}(data);
224         return verifyCallResult(success, returndata, errorMessage);
225     }
226 
227  
228     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
229         return functionStaticCall(target, data, "Address: low-level static call failed");
230     }
231 
232 
233     function functionStaticCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal view returns (bytes memory) {
238         require(isContract(target), "Address: static call to non-contract");
239 
240         (bool success, bytes memory returndata) = target.staticcall(data);
241         return verifyCallResult(success, returndata, errorMessage);
242     }
243 
244 
245     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
246         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
247     }
248 
249 
250     function functionDelegateCall(
251         address target,
252         bytes memory data,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         require(isContract(target), "Address: delegate call to non-contract");
256 
257         (bool success, bytes memory returndata) = target.delegatecall(data);
258         return verifyCallResult(success, returndata, errorMessage);
259     }
260 
261   
262     function verifyCallResult(
263         bool success,
264         bytes memory returndata,
265         string memory errorMessage
266     ) internal pure returns (bytes memory) {
267         if (success) {
268             return returndata;
269         } else {
270             if (returndata.length > 0) {
271                 assembly {
272                     let returndata_size := mload(returndata)
273                     revert(add(32, returndata), returndata_size)
274                 }
275             } else {
276                 revert(errorMessage);
277             }
278         }
279     }
280 }
281 
282 
283 library SafeERC20 {
284     using Address for address;
285 
286     function safeTransfer(
287         IERC20 token,
288         address to,
289         uint256 value
290     ) internal {
291         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
292     }
293 
294     function safeTransferFrom(
295         IERC20 token,
296         address from,
297         address to,
298         uint256 value
299     ) internal {
300         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
301     }
302 
303  
304     function safeApprove(
305         IERC20 token,
306         address spender,
307         uint256 value
308     ) internal {
309 
310         require(
311             (value == 0) || (token.allowance(address(this), spender) == 0),
312             "SafeERC20: approve from non-zero to non-zero allowance"
313         );
314         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
315     }
316 
317     function safeIncreaseAllowance(
318         IERC20 token,
319         address spender,
320         uint256 value
321     ) internal {
322         uint256 newAllowance = token.allowance(address(this), spender) + value;
323         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
324     }
325 
326     function safeDecreaseAllowance(
327         IERC20 token,
328         address spender,
329         uint256 value
330     ) internal {
331         unchecked {
332             uint256 oldAllowance = token.allowance(address(this), spender);
333             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
334             uint256 newAllowance = oldAllowance - value;
335             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
336         }
337     }
338 
339     function _callOptionalReturn(IERC20 token, bytes memory data) private {
340 
341         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
342         if (returndata.length > 0) {
343             // Return data is optional
344             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
345         }
346     }
347 }
348 
349 
350 
351 
352 
353 
354 
355 contract PaymentSplitter is Context {
356     event PayeeAdded(address account, uint256 shares);
357     event PaymentReleased(address to, uint256 amount);
358     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
359     event PaymentReceived(address from, uint256 amount);
360 
361     uint256 private _totalShares;
362     uint256 private _totalReleased;
363 
364     mapping(address => uint256) private _shares;
365     mapping(address => uint256) private _released;
366     address[] private _payees;
367 
368     mapping(IERC20 => uint256) private _erc20TotalReleased;
369     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
370 
371     constructor(address[] memory payees, uint256[] memory shares_) payable {
372         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
373         require(payees.length > 0, "PaymentSplitter: no payees");
374 
375         for (uint256 i = 0; i < payees.length; i++) {
376             _addPayee(payees[i], shares_[i]);
377         }
378     }
379 
380 
381     receive() external payable virtual {
382         emit PaymentReceived(_msgSender(), msg.value);
383     }
384 
385     function totalShares() public view returns (uint256) {
386         return _totalShares;
387     }
388 
389 
390     function totalReleased() public view returns (uint256) {
391         return _totalReleased;
392     }
393 
394 
395     function totalReleased(IERC20 token) public view returns (uint256) {
396         return _erc20TotalReleased[token];
397     }
398 
399     function shares(address account) public view returns (uint256) {
400         return _shares[account];
401     }
402 
403 
404     function released(address account) public view returns (uint256) {
405         return _released[account];
406     }
407 
408 
409     function released(IERC20 token, address account) public view returns (uint256) {
410         return _erc20Released[token][account];
411     }
412 
413     function payee(uint256 index) public view returns (address) {
414         return _payees[index];
415     }
416 
417 
418 
419   
420     function release(address payable account) public virtual {
421         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
422 
423         uint256 totalReceived = address(this).balance + totalReleased();
424         uint256 payment = _pendingPayment(account, totalReceived, released(account));
425 
426         require(payment != 0, "PaymentSplitter: account is not due payment");
427 
428         _released[account] += payment;
429         _totalReleased += payment;
430 
431         Address.sendValue(account, payment);
432         emit PaymentReleased(account, payment);
433     }
434 
435  
436     function release(IERC20 token, address account) public virtual {
437         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
438 
439         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
440         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
441 
442         require(payment != 0, "PaymentSplitter: account is not due payment");
443 
444         _erc20Released[token][account] += payment;
445         _erc20TotalReleased[token] += payment;
446 
447         SafeERC20.safeTransfer(token, account, payment);
448         emit ERC20PaymentReleased(token, account, payment);
449     }
450 
451 
452     function _pendingPayment(
453         address account,
454         uint256 totalReceived,
455         uint256 alreadyReleased
456     ) private view returns (uint256) {
457         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
458     }
459 
460 
461     function _addPayee(address account, uint256 shares_) private {
462         require(account != address(0), "PaymentSplitter: account is the zero address");
463         require(shares_ > 0, "PaymentSplitter: shares are 0");
464         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
465 
466         _payees.push(account);
467         _shares[account] = shares_;
468         _totalShares = _totalShares + shares_;
469         emit PayeeAdded(account, shares_);
470     }
471 }
472 
473 
474 
475 interface IERC721Receiver {
476 
477     function onERC721Received(
478         address operator,
479         address from,
480         uint256 tokenId,
481         bytes calldata data
482     ) external returns (bytes4);
483 }
484 
485 
486 
487 interface IERC165 {
488 
489     function supportsInterface(bytes4 interfaceId) external view returns (bool);
490 }
491 
492 
493 
494 abstract contract ERC165 is IERC165 {
495     /**
496      * @dev See {IERC165-supportsInterface}.
497      */
498     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
499         return interfaceId == type(IERC165).interfaceId;
500     }
501 }
502 
503 
504 
505 
506 
507 interface IERC721 is IERC165 {
508     /**
509      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
510      */
511     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
512 
513     /**
514      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
515      */
516     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
517 
518     /**
519      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
520      */
521     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
522 
523     /**
524      * @dev Returns the number of tokens in ``owner``'s account.
525      */
526     function balanceOf(address owner) external view returns (uint256 balance);
527     function mintOf(address owner) external view returns (uint256 balance);
528     /**
529      * @dev Returns the owner of the `tokenId` token.
530      *
531      * Requirements:
532      *
533      * - `tokenId` must exist.
534      */
535     function ownerOf(uint256 tokenId) external view returns (address owner);
536 
537     function safeTransferFrom(
538         address from,
539         address to,
540         uint256 tokenId
541     ) external;
542 
543     function transferFrom(
544         address from,
545         address to,
546         uint256 tokenId
547     ) external;
548 
549   
550     function approve(address to, uint256 tokenId) external;
551 
552 
553     function getApproved(uint256 tokenId) external view returns (address operator);
554 
555   
556     function setApprovalForAll(address operator, bool _approved) external;
557 
558     function isApprovedForAll(address owner, address operator) external view returns (bool);
559 
560     function safeTransferFrom(
561         address from,
562         address to,
563         uint256 tokenId,
564         bytes calldata data
565     ) external;
566 }
567 
568 
569 
570 
571 interface IERC721Enumerable is IERC721 {
572  
573     function totalSupply() external view returns (uint256);
574 
575  
576     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
577 
578 
579     function tokenByIndex(uint256 index) external view returns (uint256);
580 }
581 
582 
583 
584 
585 
586 
587 interface IERC721Metadata is IERC721 {
588 
589     function name() external view returns (string memory);
590 
591 
592     function symbol() external view returns (string memory);
593 
594 
595     function tokenURI(uint256 tokenId) external view returns (string memory);
596 }
597 
598 
599 
600 
601 
602 abstract contract ERC721P is Context, ERC165, IERC721, IERC721Metadata {
603     using Address for address;
604     string private _name;
605     string private _symbol;
606     address[] internal _owners;
607     address[] internal _minters;
608     mapping(uint256 => address) private _tokenApprovals;
609     mapping(address => mapping(address => bool)) private _operatorApprovals;     
610     constructor(string memory name_, string memory symbol_) {
611         _name = name_;
612         _symbol = symbol_;
613     }     
614     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
615         return
616             interfaceId == type(IERC721).interfaceId ||
617             interfaceId == type(IERC721Metadata).interfaceId ||
618             super.supportsInterface(interfaceId);
619     }
620     
621     function balanceOf(address owner) public view virtual override returns (uint256) {
622         require(owner != address(0), "ERC721: balance query for the zero address");
623         uint count = 0;
624         uint length = _owners.length;
625         for( uint i = 0; i < length; ++i ){
626           if( owner == _owners[i] ){
627             ++count;
628           }
629         }
630         delete length;
631         return count;
632     }
633 
634     function mintOf(address owner) public view virtual override returns (uint256) {
635         require(owner != address(0), "ERC721: balance query for the zero address");
636         uint count = 0;
637         uint length = _minters.length;
638         for( uint i = 0; i < length; ++i ){
639           if( owner == _minters[i] ){
640             ++count;
641           }
642         }
643         delete length;
644         return count;
645     }
646 
647     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
648         address owner = _owners[tokenId];
649         require(owner != address(0), "ERC721: owner query for nonexistent token");
650         return owner;
651     }
652     function name() public view virtual override returns (string memory) {
653         return _name;
654     }
655     function symbol() public view virtual override returns (string memory) {
656         return _symbol;
657     }
658     function approve(address to, uint256 tokenId) public virtual override {
659         address owner = ERC721P.ownerOf(tokenId);
660         require(to != owner, "ERC721: approval to current owner");
661 
662         require(
663             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
664             "ERC721: approve caller is not owner nor approved for all"
665         );
666 
667         _approve(to, tokenId);
668     }
669     function getApproved(uint256 tokenId) public view virtual override returns (address) {
670         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
671 
672         return _tokenApprovals[tokenId];
673     }
674     function setApprovalForAll(address operator, bool approved) public virtual override {
675         require(operator != _msgSender(), "ERC721: approve to caller");
676 
677         _operatorApprovals[_msgSender()][operator] = approved;
678         emit ApprovalForAll(_msgSender(), operator, approved);
679     }
680     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
681         return _operatorApprovals[owner][operator];
682     }
683     function transferFrom(
684         address from,
685         address to,
686         uint256 tokenId
687     ) public virtual override {
688         //solhint-disable-next-line max-line-length
689         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
690 
691         _transfer(from, to, tokenId);
692     }
693     function safeTransferFrom(
694         address from,
695         address to,
696         uint256 tokenId
697     ) public virtual override {
698         safeTransferFrom(from, to, tokenId, "");
699     }
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 tokenId,
704         bytes memory _data
705     ) public virtual override {
706         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
707         _safeTransfer(from, to, tokenId, _data);
708     }     
709     function _safeTransfer(
710         address from,
711         address to,
712         uint256 tokenId,
713         bytes memory _data
714     ) internal virtual {
715         _transfer(from, to, tokenId);
716         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
717     }
718 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
719         return tokenId < _owners.length && _owners[tokenId] != address(0);
720     }
721 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
722         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
723         address owner = ERC721P.ownerOf(tokenId);
724         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
725     }
726 	function _safeMint(address to, uint256 tokenId) internal virtual {
727         _safeMint(to, tokenId, "");
728     }
729 	function _safeMint(
730         address to,
731         uint256 tokenId,
732         bytes memory _data
733     ) internal virtual {
734         _mint(to, tokenId);
735         require(
736             _checkOnERC721Received(address(0), to, tokenId, _data),
737             "ERC721: transfer to non ERC721Receiver implementer"
738         );
739     }
740 	function _mint(address to, uint256 tokenId) internal virtual {
741         require(to != address(0), "ERC721: mint to the zero address");
742         require(!_exists(tokenId), "ERC721: token already minted");
743 
744         _beforeTokenTransfer(address(0), to, tokenId);
745         _owners.push(to);
746         _minters.push(to);
747 
748         emit Transfer(address(0), to, tokenId);
749     }
750 	function _burn(uint256 tokenId) internal virtual {
751         address owner = ERC721P.ownerOf(tokenId);
752 
753         _beforeTokenTransfer(owner, address(0), tokenId);
754 
755         // Clear approvals
756         _approve(address(0), tokenId);
757         _owners[tokenId] = address(0);
758 
759         emit Transfer(owner, address(0), tokenId);
760     }
761 	function _transfer(
762         address from,
763         address to,
764         uint256 tokenId
765     ) internal virtual {
766         require(ERC721P.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
767         require(to != address(0), "ERC721: transfer to the zero address");
768 
769         _beforeTokenTransfer(from, to, tokenId);
770 
771         // Clear approvals from the previous owner
772         _approve(address(0), tokenId);
773         _owners[tokenId] = to;
774 
775         emit Transfer(from, to, tokenId);
776     }
777 	function _approve(address to, uint256 tokenId) internal virtual {
778         _tokenApprovals[tokenId] = to;
779         emit Approval(ERC721P.ownerOf(tokenId), to, tokenId);
780     }
781 	function _checkOnERC721Received(
782         address from,
783         address to,
784         uint256 tokenId,
785         bytes memory _data
786     ) private returns (bool) {
787         if (to.isContract()) {
788             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
789                 return retval == IERC721Receiver.onERC721Received.selector;
790             } catch (bytes memory reason) {
791                 if (reason.length == 0) {
792                     revert("ERC721: transfer to non ERC721Receiver implementer");
793                 } else {
794                     assembly {
795                         revert(add(32, reason), mload(reason))
796                     }
797                 }
798             }
799         } else {
800             return true;
801         }
802     }
803 	function _beforeTokenTransfer(
804         address from,
805         address to,
806         uint256 tokenId
807     ) internal virtual {}
808 }
809 // File: pagzi/ERC721Enum.sol
810 
811 
812 
813 
814 abstract contract ERC721Enum is ERC721P, IERC721Enumerable {
815     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721P) returns (bool) {
816         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
817     }
818     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
819         require(index < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
820         uint count;
821         for( uint i; i < _owners.length; ++i ){
822             if( owner == _owners[i] ){
823                 if( count == index )
824                     return i;
825                 else
826                     ++count;
827             }
828         }
829         require(false, "ERC721Enum: owner ioob");
830     }
831     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
832         require(0 < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
833         uint256 tokenCount = balanceOf(owner);
834         uint256[] memory tokenIds = new uint256[](tokenCount);
835         for (uint256 i = 0; i < tokenCount; i++) {
836             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
837         }
838         return tokenIds;
839     }
840     function totalSupply() public view virtual override returns (uint256) {
841         return _owners.length;
842     }
843     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
844         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
845         return index;
846     }
847 }
848 // File: beepos.sol
849 
850 
851 // Author: Beepos;
852 
853 
854 
855 
856 
857 
858 contract Beepos is ERC721Enum, Ownable, PaymentSplitter, ReentrancyGuard {
859 	using Strings for uint256;
860 	string public baseURI;
861 	//sale settings
862 	uint256 public cost = 0.055 ether;
863 	uint256 public maxSupply = 10000;
864 	uint256 public maxMint = 3;
865 	uint256 public MaxMintPerWallet = 3;
866 	struct User {
867 		uint256 minted;
868     }
869 	mapping (address => User) public users;
870 
871 	bool public status = false;
872 	//presale settings
873 	uint256 public presaleDate = 1637132400;
874 	mapping(address => uint256) public presaleWhitelist;
875 	//share settings
876 	address[] private addressList = [
877 	0xB80DA8531034854c01BF61Ee6CC2A191f3569FE4,
878 	0xCfEfF78B5e8bc1cf6C495a61720e05e373e40C57,
879 	0xa68C9b9558F4706331DC410706FB6Dde90788286,
880 	0xE2d7AAb994eeC70A6e0B172D306b75A870f3b7b7
881 	];
882 	uint[] private shareList = [25,25,25,25];
883 	constructor(
884 	string memory _name,
885 	string memory _symbol,
886 	string memory _initBaseURI
887 	) ERC721P(_name, _symbol)
888 	PaymentSplitter( addressList, shareList ){
889 	setBaseURI(_initBaseURI);
890 	}
891 	// internal
892 	function _baseURI() internal view virtual returns (string memory) {
893 	return baseURI;
894 	}
895 	// public minting
896 	function mint(uint256 _mintAmount) public payable nonReentrant{
897 	require(users[msg.sender].minted + _mintAmount <= MaxMintPerWallet || msg.sender==owner(), "Exceeds max mint limit per wallet");
898 	uint256 s = totalSupply();
899 	require(status, "Off" );
900 	require(_mintAmount > 0, "Duh" );
901 	require(_mintAmount <= maxMint, "Too many" );
902 	require(s + _mintAmount <= maxSupply, "Sorry" );
903 	require(msg.value >= cost * _mintAmount);
904 	for (uint256 i = 0; i < _mintAmount; ++i) {
905 	  _safeMint(msg.sender, s + i, "");
906 	}
907 	users[msg.sender].minted = users[msg.sender].minted + _mintAmount;
908 	delete s;
909 	}
910     
911 	function mintPresale(uint256 _mintAmount) public payable {
912 	require(presaleDate <= block.timestamp, "Not yet");
913 	require(users[msg.sender].minted + _mintAmount <= MaxMintPerWallet || msg.sender==owner(), "Exceeds max mint limit per wallet");
914 	uint256 s = totalSupply();
915 	uint256 reserve = presaleWhitelist[msg.sender];
916 	require(!status, "Off");
917 	require(reserve > 0, "Low reserve");
918 	require(_mintAmount <= reserve, "Try less");
919 	require(s + _mintAmount <= maxSupply, "More than max");
920 	require(cost * _mintAmount == msg.value, "Wrong amount");
921 	presaleWhitelist[msg.sender] = reserve - _mintAmount;
922 	delete reserve;
923 	for(uint256 i; i < _mintAmount; i++){
924 	_safeMint(msg.sender, s + i, "");
925 	}
926 	users[msg.sender].minted = users[msg.sender].minted + _mintAmount;
927 	delete s;
928 	}
929 	// admin minting
930 	function gift(uint[] calldata quantity, address[] calldata recipient) external onlyOwner{
931 	require(quantity.length == recipient.length, "Provide quantities and recipients" );
932 	uint totalQuantity = 0;
933 	uint256 s = totalSupply();
934 	for(uint i = 0; i < quantity.length; ++i){
935 	totalQuantity += quantity[i];
936 	}
937 	require( s + totalQuantity <= maxSupply, "Too many" );
938 	delete totalQuantity;
939 	for(uint i = 0; i < recipient.length; ++i){
940 	for(uint j = 0; j < quantity[i]; ++j){
941 	_safeMint( recipient[i], s++, "" );
942 	}
943 	}
944 	delete s;	
945 	}
946 	// admin functionality
947 	function presaleSet(address[] calldata _addresses, uint256[] calldata _amounts) public onlyOwner {
948 	for(uint256 i; i < _addresses.length; i++){
949 	presaleWhitelist[_addresses[i]] = _amounts[i];
950 	}
951 	}
952 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
953 	require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
954 	string memory currentBaseURI = _baseURI();
955 	return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : "";
956 	}
957 	function setCost(uint256 _newCost) public onlyOwner {
958 	cost = _newCost;
959 	}
960 	function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
961 	maxMint = _newMaxMintAmount;
962 	}
963 	function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
964 	maxSupply = _newMaxSupply;
965 	}
966 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
967 	baseURI = _newBaseURI;
968 	}
969 	function setSaleStatus(bool _status) public onlyOwner {
970 	status = _status;
971 	}
972 	function withdraw() public payable onlyOwner {
973 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
974 	require(success);
975 	} 
976 	function updateMintPerWalletLimit(uint256 newLimit) external onlyOwner {
977        MaxMintPerWallet = newLimit;
978     }
979 }