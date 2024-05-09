1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(
18         address indexed previousOwner,
19         address indexed newOwner
20     );
21 
22     constructor() {
23         _setOwner(_msgSender());
24     }
25 
26     function owner() public view virtual returns (address) {
27         return _owner;
28     }
29 
30     modifier onlyOwner() {
31         require(owner() == _msgSender(), "Ownable: caller is not the owner");
32         _;
33     }
34 
35     function renounceOwnership() public virtual onlyOwner {
36         _setOwner(address(0));
37     }
38 
39     function transferOwnership(address newOwner) public virtual onlyOwner {
40         require(
41             newOwner != address(0),
42             "Ownable: new owner is the zero address"
43         );
44         _setOwner(newOwner);
45     }
46 
47     function _setOwner(address newOwner) private {
48         address oldOwner = _owner;
49         _owner = newOwner;
50         emit OwnershipTransferred(oldOwner, newOwner);
51     }
52 }
53 
54 interface IERC165 {
55     function supportsInterface(bytes4 interfaceId) external view returns (bool);
56 }
57 
58 abstract contract ERC165 is IERC165 {
59     function supportsInterface(bytes4 interfaceId)
60         public
61         view
62         virtual
63         override
64         returns (bool)
65     {
66         return interfaceId == type(IERC165).interfaceId;
67     }
68 }
69 
70 interface IERC721 is IERC165 {
71     event Transfer(
72         address indexed from,
73         address indexed to,
74         uint256 indexed tokenId
75     );
76 
77     event Approval(
78         address indexed owner,
79         address indexed approved,
80         uint256 indexed tokenId
81     );
82 
83     event ApprovalForAll(
84         address indexed owner,
85         address indexed operator,
86         bool approved
87     );
88 
89     function balanceOf(address owner) external view returns (uint256 balance);
90 
91     function ownerOf(uint256 tokenId) external view returns (address owner);
92 
93     function safeTransferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     function approve(address to, uint256 tokenId) external;
106 
107     function getApproved(uint256 tokenId)
108         external
109         view
110         returns (address operator);
111 
112     function setApprovalForAll(address operator, bool _approved) external;
113 
114     function isApprovedForAll(address owner, address operator)
115         external
116         view
117         returns (bool);
118 
119     function safeTransferFrom(
120         address from,
121         address to,
122         uint256 tokenId,
123         bytes calldata data
124     ) external;
125 }
126 
127 interface IERC721Metadata is IERC721 {
128     function name() external view returns (string memory);
129 
130     function symbol() external view returns (string memory);
131 
132     function tokenURI(uint256 tokenId) external view returns (string memory);
133 }
134 
135 library Address {
136     function isContract(address account) internal view returns (bool) {
137         uint256 size;
138         assembly {
139             size := extcodesize(account)
140         }
141         return size > 0;
142     }
143 
144     function sendValue(address payable recipient, uint256 amount) internal {
145         require(
146             address(this).balance >= amount,
147             "Address: insufficient balance"
148         );
149 
150         (bool success, ) = recipient.call{value: amount}("");
151         require(
152             success,
153             "Address: unable to send value, recipient may have reverted"
154         );
155     }
156 
157     function functionCall(address target, bytes memory data)
158         internal
159         returns (bytes memory)
160     {
161         return functionCall(target, data, "Address: low-level call failed");
162     }
163 
164     function functionCall(
165         address target,
166         bytes memory data,
167         string memory errorMessage
168     ) internal returns (bytes memory) {
169         return functionCallWithValue(target, data, 0, errorMessage);
170     }
171 
172     function functionCallWithValue(
173         address target,
174         bytes memory data,
175         uint256 value
176     ) internal returns (bytes memory) {
177         return
178             functionCallWithValue(
179                 target,
180                 data,
181                 value,
182                 "Address: low-level call with value failed"
183             );
184     }
185 
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         require(
193             address(this).balance >= value,
194             "Address: insufficient balance for call"
195         );
196         require(isContract(target), "Address: call to non-contract");
197 
198         (bool success, bytes memory returndata) = target.call{value: value}(
199             data
200         );
201         return verifyCallResult(success, returndata, errorMessage);
202     }
203 
204     function functionStaticCall(address target, bytes memory data)
205         internal
206         view
207         returns (bytes memory)
208     {
209         return
210             functionStaticCall(
211                 target,
212                 data,
213                 "Address: low-level static call failed"
214             );
215     }
216 
217     function functionStaticCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal view returns (bytes memory) {
222         require(isContract(target), "Address: static call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.staticcall(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     function functionDelegateCall(address target, bytes memory data)
229         internal
230         returns (bytes memory)
231     {
232         return
233             functionDelegateCall(
234                 target,
235                 data,
236                 "Address: low-level delegate call failed"
237             );
238     }
239 
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
251     function verifyCallResult(
252         bool success,
253         bytes memory returndata,
254         string memory errorMessage
255     ) internal pure returns (bytes memory) {
256         if (success) {
257             return returndata;
258         } else {
259             if (returndata.length > 0) {
260                 assembly {
261                     let returndata_size := mload(returndata)
262                     revert(add(32, returndata), returndata_size)
263                 }
264             } else {
265                 revert(errorMessage);
266             }
267         }
268     }
269 }
270 
271 library Strings {
272     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
273 
274     function toString(uint256 value) internal pure returns (string memory) {
275         if (value == 0) {
276             return "0";
277         }
278         uint256 temp = value;
279         uint256 digits;
280         while (temp != 0) {
281             digits++;
282             temp /= 10;
283         }
284         bytes memory buffer = new bytes(digits);
285         while (value != 0) {
286             digits -= 1;
287             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
288             value /= 10;
289         }
290         return string(buffer);
291     }
292 
293     function toHexString(uint256 value) internal pure returns (string memory) {
294         if (value == 0) {
295             return "0x00";
296         }
297         uint256 temp = value;
298         uint256 length = 0;
299         while (temp != 0) {
300             length++;
301             temp >>= 8;
302         }
303         return toHexString(value, length);
304     }
305 
306     function toHexString(uint256 value, uint256 length)
307         internal
308         pure
309         returns (string memory)
310     {
311         bytes memory buffer = new bytes(2 * length + 2);
312         buffer[0] = "0";
313         buffer[1] = "x";
314         for (uint256 i = 2 * length + 1; i > 1; --i) {
315             buffer[i] = _HEX_SYMBOLS[value & 0xf];
316             value >>= 4;
317         }
318         require(value == 0, "Strings: hex length insufficient");
319         return string(buffer);
320     }
321 }
322 
323 interface IERC721Receiver {
324     function onERC721Received(
325         address operator,
326         address from,
327         uint256 tokenId,
328         bytes calldata data
329     ) external returns (bytes4);
330 }
331 
332 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
333     using Address for address;
334     using Strings for uint256;
335 
336     string private _name;
337 
338     string private _symbol;
339 
340     mapping(uint256 => address) private _owners;
341 
342     mapping(address => uint256) private _balances;
343 
344     mapping(uint256 => address) private _tokenApprovals;
345 
346     mapping(address => mapping(address => bool)) private _operatorApprovals;
347 
348     constructor(string memory name_, string memory symbol_) {
349         _name = name_;
350         _symbol = symbol_;
351     }
352 
353     function supportsInterface(bytes4 interfaceId)
354         public
355         view
356         virtual
357         override(ERC165, IERC165)
358         returns (bool)
359     {
360         return
361             interfaceId == type(IERC721).interfaceId ||
362             interfaceId == type(IERC721Metadata).interfaceId ||
363             super.supportsInterface(interfaceId);
364     }
365 
366     function balanceOf(address owner)
367         public
368         view
369         virtual
370         override
371         returns (uint256)
372     {
373         require(
374             owner != address(0),
375             "ERC721: balance query for the zero address"
376         );
377         return _balances[owner];
378     }
379 
380     function ownerOf(uint256 tokenId)
381         public
382         view
383         virtual
384         override
385         returns (address)
386     {
387         address owner = _owners[tokenId];
388         require(
389             owner != address(0),
390             "ERC721: owner query for nonexistent token"
391         );
392         return owner;
393     }
394 
395     function name() public view virtual override returns (string memory) {
396         return _name;
397     }
398 
399     function symbol() public view virtual override returns (string memory) {
400         return _symbol;
401     }
402 
403     function tokenURI(uint256 tokenId)
404         public
405         view
406         virtual
407         override
408         returns (string memory)
409     {
410         require(
411             _exists(tokenId),
412             "ERC721Metadata: URI query for nonexistent token"
413         );
414 
415         string memory baseURI = _baseURI();
416         return
417             bytes(baseURI).length > 0
418                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
419                 : "";
420     }
421 
422     function _baseURI() internal view virtual returns (string memory) {
423         return "";
424     }
425 
426     function approve(address to, uint256 tokenId) public virtual override {
427         address owner = ERC721.ownerOf(tokenId);
428         require(to != owner, "ERC721: approval to current owner");
429 
430         require(
431             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
432             "ERC721: approve caller is not owner nor approved for all"
433         );
434 
435         _approve(to, tokenId);
436     }
437 
438     function getApproved(uint256 tokenId)
439         public
440         view
441         virtual
442         override
443         returns (address)
444     {
445         require(
446             _exists(tokenId),
447             "ERC721: approved query for nonexistent token"
448         );
449 
450         return _tokenApprovals[tokenId];
451     }
452 
453     function setApprovalForAll(address operator, bool approved)
454         public
455         virtual
456         override
457     {
458         require(operator != _msgSender(), "ERC721: approve to caller");
459 
460         _operatorApprovals[_msgSender()][operator] = approved;
461         emit ApprovalForAll(_msgSender(), operator, approved);
462     }
463 
464     function isApprovedForAll(address owner, address operator)
465         public
466         view
467         virtual
468         override
469         returns (bool)
470     {
471         return _operatorApprovals[owner][operator];
472     }
473 
474     function transferFrom(
475         address from,
476         address to,
477         uint256 tokenId
478     ) public virtual override {
479         //solhint-disable-next-line max-line-length
480         require(
481             _isApprovedOrOwner(_msgSender(), tokenId),
482             "ERC721: transfer caller is not owner nor approved"
483         );
484 
485         _transfer(from, to, tokenId);
486     }
487 
488     function safeTransferFrom(
489         address from,
490         address to,
491         uint256 tokenId
492     ) public virtual override {
493         safeTransferFrom(from, to, tokenId, "");
494     }
495 
496     function safeTransferFrom(
497         address from,
498         address to,
499         uint256 tokenId,
500         bytes memory _data
501     ) public virtual override {
502         require(
503             _isApprovedOrOwner(_msgSender(), tokenId),
504             "ERC721: transfer caller is not owner nor approved"
505         );
506         _safeTransfer(from, to, tokenId, _data);
507     }
508 
509     function _safeTransfer(
510         address from,
511         address to,
512         uint256 tokenId,
513         bytes memory _data
514     ) internal virtual {
515         _transfer(from, to, tokenId);
516         require(
517             _checkOnERC721Received(from, to, tokenId, _data),
518             "ERC721: transfer to non ERC721Receiver implementer"
519         );
520     }
521 
522     function _exists(uint256 tokenId) internal view virtual returns (bool) {
523         return _owners[tokenId] != address(0);
524     }
525 
526     function _isApprovedOrOwner(address spender, uint256 tokenId)
527         internal
528         view
529         virtual
530         returns (bool)
531     {
532         require(
533             _exists(tokenId),
534             "ERC721: operator query for nonexistent token"
535         );
536         address owner = ERC721.ownerOf(tokenId);
537         return (spender == owner ||
538             getApproved(tokenId) == spender ||
539             isApprovedForAll(owner, spender));
540     }
541 
542     function _safeMint(address to, uint256 tokenId) internal virtual {
543         _safeMint(to, tokenId, "");
544     }
545 
546     function _safeMint(
547         address to,
548         uint256 tokenId,
549         bytes memory _data
550     ) internal virtual {
551         _mint(to, tokenId);
552         require(
553             _checkOnERC721Received(address(0), to, tokenId, _data),
554             "ERC721: transfer to non ERC721Receiver implementer"
555         );
556     }
557 
558     function _mint(address to, uint256 tokenId) internal virtual {
559         require(to != address(0), "ERC721: mint to the zero address");
560         require(!_exists(tokenId), "ERC721: token already minted");
561 
562         _beforeTokenTransfer(address(0), to, tokenId);
563 
564         _balances[to] += 1;
565         _owners[tokenId] = to;
566 
567         emit Transfer(address(0), to, tokenId);
568     }
569 
570     function _burn(uint256 tokenId) internal virtual {
571         address owner = ERC721.ownerOf(tokenId);
572 
573         _beforeTokenTransfer(owner, address(0), tokenId);
574 
575         // Clear approvals
576         _approve(address(0), tokenId);
577 
578         _balances[owner] -= 1;
579         delete _owners[tokenId];
580 
581         emit Transfer(owner, address(0), tokenId);
582     }
583 
584     function _transfer(
585         address from,
586         address to,
587         uint256 tokenId
588     ) internal virtual {
589         require(
590             ERC721.ownerOf(tokenId) == from,
591             "ERC721: transfer of token that is not own"
592         );
593         require(to != address(0), "ERC721: transfer to the zero address");
594 
595         _beforeTokenTransfer(from, to, tokenId);
596 
597         _approve(address(0), tokenId);
598 
599         _balances[from] -= 1;
600         _balances[to] += 1;
601         _owners[tokenId] = to;
602 
603         emit Transfer(from, to, tokenId);
604     }
605 
606     function _approve(address to, uint256 tokenId) internal virtual {
607         _tokenApprovals[tokenId] = to;
608         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
609     }
610 
611     function _checkOnERC721Received(
612         address from,
613         address to,
614         uint256 tokenId,
615         bytes memory _data
616     ) private returns (bool) {
617         if (to.isContract()) {
618             try
619                 IERC721Receiver(to).onERC721Received(
620                     _msgSender(),
621                     from,
622                     tokenId,
623                     _data
624                 )
625             returns (bytes4 retval) {
626                 return retval == IERC721Receiver.onERC721Received.selector;
627             } catch (bytes memory reason) {
628                 if (reason.length == 0) {
629                     revert(
630                         "ERC721: transfer to non ERC721Receiver implementer"
631                     );
632                 } else {
633                     assembly {
634                         revert(add(32, reason), mload(reason))
635                     }
636                 }
637             }
638         } else {
639             return true;
640         }
641     }
642 
643     function _beforeTokenTransfer(
644         address from,
645         address to,
646         uint256 tokenId
647     ) internal virtual {}
648 }
649 
650 abstract contract ERC721URIStorage is ERC721 {
651     using Strings for uint256;
652 
653     mapping(uint256 => string) private _tokenURIs;
654 
655     function tokenURI(uint256 tokenId)
656         public
657         view
658         virtual
659         override
660         returns (string memory)
661     {
662         require(
663             _exists(tokenId),
664             "ERC721URIStorage: URI query for nonexistent token"
665         );
666 
667         string memory _tokenURI = _tokenURIs[tokenId];
668         string memory base = _baseURI();
669 
670         if (bytes(base).length == 0) {
671             return _tokenURI;
672         }
673         if (bytes(_tokenURI).length > 0) {
674             return string(abi.encodePacked(base, _tokenURI));
675         }
676 
677         return super.tokenURI(tokenId);
678     }
679 
680     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
681         internal
682         virtual
683     {
684         require(
685             _exists(tokenId),
686             "ERC721URIStorage: URI set of nonexistent token"
687         );
688         _tokenURIs[tokenId] = _tokenURI;
689     }
690 
691     function _burn(uint256 tokenId) internal virtual override {
692         super._burn(tokenId);
693 
694         if (bytes(_tokenURIs[tokenId]).length != 0) {
695             delete _tokenURIs[tokenId];
696         }
697     }
698 }
699 
700 interface IAccessControl {
701     event RoleAdminChanged(
702         bytes32 indexed role,
703         bytes32 indexed previousAdminRole,
704         bytes32 indexed newAdminRole
705     );
706 
707     event RoleGranted(
708         bytes32 indexed role,
709         address indexed account,
710         address indexed sender
711     );
712 
713     event RoleRevoked(
714         bytes32 indexed role,
715         address indexed account,
716         address indexed sender
717     );
718 
719     function hasRole(bytes32 role, address account)
720         external
721         view
722         returns (bool);
723 
724     function getRoleAdmin(bytes32 role) external view returns (bytes32);
725 
726     function grantRole(bytes32 role, address account) external;
727 
728     function revokeRole(bytes32 role, address account) external;
729 
730     function renounceRole(bytes32 role, address account) external;
731 }
732 
733 abstract contract AccessControl is Context, IAccessControl, ERC165 {
734     struct RoleData {
735         mapping(address => bool) members;
736         bytes32 adminRole;
737     }
738 
739     mapping(bytes32 => RoleData) private _roles;
740 
741     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
742 
743     modifier onlyRole(bytes32 role) {
744         _checkRole(role, _msgSender());
745         _;
746     }
747 
748     function supportsInterface(bytes4 interfaceId)
749         public
750         view
751         virtual
752         override
753         returns (bool)
754     {
755         return
756             interfaceId == type(IAccessControl).interfaceId ||
757             super.supportsInterface(interfaceId);
758     }
759 
760     function hasRole(bytes32 role, address account)
761         public
762         view
763         override
764         returns (bool)
765     {
766         return _roles[role].members[account];
767     }
768 
769     function _checkRole(bytes32 role, address account) internal view {
770         if (!hasRole(role, account)) {
771             revert(
772                 string(
773                     abi.encodePacked(
774                         "AccessControl: account ",
775                         Strings.toHexString(uint160(account), 20),
776                         " is missing role ",
777                         Strings.toHexString(uint256(role), 32)
778                     )
779                 )
780             );
781         }
782     }
783 
784     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
785         return _roles[role].adminRole;
786     }
787 
788     function grantRole(bytes32 role, address account)
789         public
790         virtual
791         override
792         onlyRole(getRoleAdmin(role))
793     {
794         _grantRole(role, account);
795     }
796 
797     function revokeRole(bytes32 role, address account)
798         public
799         virtual
800         override
801         onlyRole(getRoleAdmin(role))
802     {
803         _revokeRole(role, account);
804     }
805 
806     function renounceRole(bytes32 role, address account)
807         public
808         virtual
809         override
810     {
811         require(
812             account == _msgSender(),
813             "AccessControl: can only renounce roles for self"
814         );
815 
816         _revokeRole(role, account);
817     }
818 
819     function _setupRole(bytes32 role, address account) internal virtual {
820         _grantRole(role, account);
821     }
822 
823     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
824         bytes32 previousAdminRole = getRoleAdmin(role);
825         _roles[role].adminRole = adminRole;
826         emit RoleAdminChanged(role, previousAdminRole, adminRole);
827     }
828 
829     function _grantRole(bytes32 role, address account) private {
830         if (!hasRole(role, account)) {
831             _roles[role].members[account] = true;
832             emit RoleGranted(role, account, _msgSender());
833         }
834     }
835 
836     function _revokeRole(bytes32 role, address account) private {
837         if (hasRole(role, account)) {
838             _roles[role].members[account] = false;
839             emit RoleRevoked(role, account, _msgSender());
840         }
841     }
842 }
843 
844 contract OwnableDelegateProxy {}
845 
846 contract ProxyRegistry {
847     mapping(address => OwnableDelegateProxy) public proxies;
848 }
849 
850 contract BlueWorld is ERC721URIStorage, Ownable, AccessControl {
851     bytes32 public constant PRE_SALE_ROLE = keccak256("PRE_SALE_ROLE");
852     string private contractUri;
853     string private baseUri;
854     uint8 private platformRoyalty;
855     address private proxyRegistryAddress;
856     mapping(uint256 => uint256) tokenSalePrices;
857     event TokenSold(
858         uint256 tokenId,
859         address from,
860         address to,
861         uint256 price,
862         uint256 royaltyPaid
863     );
864 
865     function supportsInterface(bytes4 interfaceId)
866         public
867         view
868         virtual
869         override(ERC721, AccessControl)
870         returns (bool)
871     {
872         return super.supportsInterface(interfaceId);
873     }
874 
875     // Rinkeby proxy for OpenSea: 0xf57b2c51ded3a29e6891aba85459d600256cf317
876     // Mainnet proxy for OpenSea: 0xa5409ec958c83c3f309868babaca7c86dcb077c1
877     constructor(address _proxyRegistryAddress, address _proxyMinterAddress)
878         ERC721("BlueWorld", "BWRLD")
879     {
880         contractUri = "https://api.blueworld.co/contract";
881         baseUri = "https://api.blueworld.co/ipfs/";
882         platformRoyalty = 5;
883         proxyRegistryAddress = _proxyRegistryAddress;
884         _setupRole(PRE_SALE_ROLE, _proxyMinterAddress);
885         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
886     }
887 
888     function contractURI() public view returns (string memory) {
889         return contractUri;
890     }
891 
892     function setContractUri(string memory newUri) public onlyOwner {
893         contractUri = newUri;
894     }
895 
896     function _baseURI() internal view override returns (string memory) {
897         return baseUri;
898     }
899 
900     function setBaseUri(string memory newUri) public onlyOwner {
901         baseUri = newUri;
902     }
903 
904     function platformFee() public view returns (uint8) {
905         return platformRoyalty;
906     }
907 
908     function setPlatformFee(uint8 newFee) public onlyOwner {
909         platformRoyalty = newFee;
910     }
911 
912     function mintCompany(address to, uint256 tokenId) public {
913         require(
914             hasRole(PRE_SALE_ROLE, msg.sender) ||
915                 hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
916             "Access forbidden"
917         );
918         require(!_exists(tokenId), "Company has already been minted");
919         _mint(to, tokenId);
920     }
921 
922     function batchMintCompanies(address owner, uint256[] memory tokenIds)
923         public
924         onlyOwner
925     {
926         for (uint256 i = 0; i < tokenIds.length; i++) {
927             require(!_exists(tokenIds[i]), "Company has already been minted");
928             _mint(owner, tokenIds[i]);
929         }
930     }
931 
932     function mergeTokens(
933         uint256 token1,
934         uint256 token2,
935         uint256 newToken
936     ) public {
937         require(
938             _exists(token1) && _exists(token2),
939             "One of the companies does not exist."
940         );
941         require(
942             ownerOf(token1) == _msgSender() && ownerOf(token2) == _msgSender(),
943             "You are not owner of one of the companies"
944         );
945         require(!_exists(newToken), "Company with new token ID already exists");
946         _burn(token1);
947         _burn(token2);
948         _mint(_msgSender(), newToken);
949     }
950 
951     function putTokenOnSale(uint256 tokenId, uint256 value) public {
952         require(
953             ownerOf(tokenId) == _msgSender(),
954             "You are not the owner of this company"
955         );
956         tokenSalePrices[tokenId] = value;
957     }
958 
959     function getCompanySalePrice(uint256 tokenId)
960         public
961         view
962         returns (uint256)
963     {
964         require(_exists(tokenId), "Token does not exist");
965         require(tokenSalePrices[tokenId] > 0, "Token is not on sale");
966         return tokenSalePrices[tokenId];
967     }
968 
969     function buyTokenFromSale(uint256 tokenId) public payable {
970         require(_exists(tokenId), "Token does not exist");
971         require(tokenSalePrices[tokenId] > 0, "Token is not on sale");
972         require(
973             msg.value == tokenSalePrices[tokenId],
974             "Please provide sufficient ETH to purchase this company"
975         );
976         uint256 royalty = ((msg.value * platformRoyalty) / 100);
977         payable(owner()).transfer(royalty);
978         payable(ownerOf(tokenId)).transfer(msg.value - royalty);
979         _transfer(ownerOf(tokenId), _msgSender(), tokenId);
980         emit TokenSold(
981             tokenId,
982             ownerOf(tokenId),
983             _msgSender(),
984             msg.value,
985             royalty
986         );
987     }
988 
989     function removeTokenFromSale(uint256 tokenId) public {
990         require(_exists(tokenId), "Token does not exist");
991         require(tokenSalePrices[tokenId] > 0, "Token is not on sale");
992         require(
993             ownerOf(tokenId) == _msgSender(),
994             "You are not the owner of this company"
995         );
996         tokenSalePrices[tokenId] = 0;
997     }
998 
999     function isApprovedForAll(address _owner, address _operator)
1000         public
1001         view
1002         override
1003         returns (bool isOperator)
1004     {
1005         // Whitelist OpenSea proxy contract for easy trading.
1006         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1007         if (address(proxyRegistry.proxies(_owner)) == _operator) {
1008             return true;
1009         }
1010         return isApprovedForAll(_owner, _operator);
1011     }
1012 
1013     function _beforeTokenTransfer(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) internal override {
1018         super._beforeTokenTransfer(from, to, tokenId);
1019         if (tokenSalePrices[tokenId] > 0) {
1020             tokenSalePrices[tokenId] = 0;
1021         }
1022     }
1023 }