1 pragma solidity >=0.8.7 <0.9.0;
2 
3 
4 interface IERC165 {
5     
6     function supportsInterface(bytes4 interfaceId) external view returns (bool);
7 }
8 
9 interface IERC721 is IERC165 {
10     
11     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
12 
13     
14     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
15 
16     
17     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
18 
19     
20     function balanceOf(address owner) external view returns (uint256 balance);
21 
22     
23     function ownerOf(uint256 tokenId) external view returns (address owner);
24 
25     
26     function safeTransferFrom(
27         address from,
28         address to,
29         uint256 tokenId
30     ) external;
31 
32     
33     function transferFrom(
34         address from,
35         address to,
36         uint256 tokenId
37     ) external;
38 
39     
40     function approve(address to, uint256 tokenId) external;
41 
42     
43     function getApproved(uint256 tokenId) external view returns (address operator);
44 
45     
46     function setApprovalForAll(address operator, bool _approved) external;
47 
48     
49     function isApprovedForAll(address owner, address operator) external view returns (bool);
50 
51     
52     function safeTransferFrom(
53         address from,
54         address to,
55         uint256 tokenId,
56         bytes calldata data
57     ) external;
58 }
59 
60 interface IERC721Receiver {
61     
62     function onERC721Received(
63         address operator,
64         address from,
65         uint256 tokenId,
66         bytes calldata data
67     ) external returns (bytes4);
68 }
69 
70 interface IERC721Metadata is IERC721 {
71     
72     function name() external view returns (string memory);
73 
74     
75     function symbol() external view returns (string memory);
76 
77     
78     function tokenURI(uint256 tokenId) external view returns (string memory);
79 }
80 
81 library Address {
82     
83     function isContract(address account) internal view returns (bool) {
84         
85         
86         
87 
88         uint256 size;
89         assembly {
90             size := extcodesize(account)
91         }
92         return size > 0;
93     }
94 
95     
96     function sendValue(address payable recipient, uint256 amount) internal {
97         require(address(this).balance >= amount, "Address: insufficient balance");
98 
99         (bool success, ) = recipient.call{value: amount}("");
100         require(success, "Address: unable to send value, recipient may have reverted");
101     }
102 
103     
104     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
105         return functionCall(target, data, "Address: low-level call failed");
106     }
107 
108     
109     function functionCall(
110         address target,
111         bytes memory data,
112         string memory errorMessage
113     ) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, 0, errorMessage);
115     }
116 
117     
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     
127     function functionCallWithValue(
128         address target,
129         bytes memory data,
130         uint256 value,
131         string memory errorMessage
132     ) internal returns (bytes memory) {
133         require(address(this).balance >= value, "Address: insufficient balance for call");
134         require(isContract(target), "Address: call to non-contract");
135 
136         (bool success, bytes memory returndata) = target.call{value: value}(data);
137         return verifyCallResult(success, returndata, errorMessage);
138     }
139 
140     
141     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
142         return functionStaticCall(target, data, "Address: low-level static call failed");
143     }
144 
145     
146     function functionStaticCall(
147         address target,
148         bytes memory data,
149         string memory errorMessage
150     ) internal view returns (bytes memory) {
151         require(isContract(target), "Address: static call to non-contract");
152 
153         (bool success, bytes memory returndata) = target.staticcall(data);
154         return verifyCallResult(success, returndata, errorMessage);
155     }
156 
157     
158     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
160     }
161 
162     
163     function functionDelegateCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         (bool success, bytes memory returndata) = target.delegatecall(data);
171         return verifyCallResult(success, returndata, errorMessage);
172     }
173 
174     
175     function verifyCallResult(
176         bool success,
177         bytes memory returndata,
178         string memory errorMessage
179     ) internal pure returns (bytes memory) {
180         if (success) {
181             return returndata;
182         } else {
183             
184             if (returndata.length > 0) {
185                 
186 
187                 assembly {
188                     let returndata_size := mload(returndata)
189                     revert(add(32, returndata), returndata_size)
190                 }
191             } else {
192                 revert(errorMessage);
193             }
194         }
195     }
196 }
197 
198 abstract contract Context {
199     function _msgSender() internal view virtual returns (address) {
200         return msg.sender;
201     }
202 
203     function _msgData() internal view virtual returns (bytes calldata) {
204         return msg.data;
205     }
206 }
207 
208 library Strings {
209     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
210 
211     
212     function toString(uint256 value) internal pure returns (string memory) {
213         
214         
215 
216         if (value == 0) {
217             return "0";
218         }
219         uint256 temp = value;
220         uint256 digits;
221         while (temp != 0) {
222             digits++;
223             temp /= 10;
224         }
225         bytes memory buffer = new bytes(digits);
226         while (value != 0) {
227             digits -= 1;
228             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
229             value /= 10;
230         }
231         return string(buffer);
232     }
233 
234     
235     function toHexString(uint256 value) internal pure returns (string memory) {
236         if (value == 0) {
237             return "0x00";
238         }
239         uint256 temp = value;
240         uint256 length = 0;
241         while (temp != 0) {
242             length++;
243             temp >>= 8;
244         }
245         return toHexString(value, length);
246     }
247 
248     
249     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
250         bytes memory buffer = new bytes(2 * length + 2);
251         buffer[0] = "0";
252         buffer[1] = "x";
253         for (uint256 i = 2 * length + 1; i > 1; --i) {
254             buffer[i] = _HEX_SYMBOLS[value & 0xf];
255             value >>= 4;
256         }
257         require(value == 0, "Strings: hex length insufficient");
258         return string(buffer);
259     }
260 }
261 
262 abstract contract ERC165 is IERC165 {
263     
264     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
265         return interfaceId == type(IERC165).interfaceId;
266     }
267 }
268 
269 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
270     using Address for address;
271     using Strings for uint256;
272 
273     
274     string private _name;
275 
276     
277     string private _symbol;
278 
279     
280     mapping(uint256 => address) private _owners;
281 
282     
283     mapping(address => uint256) private _balances;
284 
285     
286     mapping(uint256 => address) private _tokenApprovals;
287 
288     
289     mapping(address => mapping(address => bool)) private _operatorApprovals;
290 
291     
292     constructor(string memory name_, string memory symbol_) {
293         _name = name_;
294         _symbol = symbol_;
295     }
296 
297     
298     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
299         return
300             interfaceId == type(IERC721).interfaceId ||
301             interfaceId == type(IERC721Metadata).interfaceId ||
302             super.supportsInterface(interfaceId);
303     }
304 
305     
306     function balanceOf(address owner) public view virtual override returns (uint256) {
307         require(owner != address(0), "ERC721: balance query for the zero address");
308         return _balances[owner];
309     }
310 
311     
312     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
313         address owner = _owners[tokenId];
314         require(owner != address(0), "ERC721: owner query for nonexistent token");
315         return owner;
316     }
317 
318     
319     function name() public view virtual override returns (string memory) {
320         return _name;
321     }
322 
323     
324     function symbol() public view virtual override returns (string memory) {
325         return _symbol;
326     }
327 
328     
329     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
330         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
331 
332         string memory baseURI = _baseURI();
333         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
334     }
335 
336     
337     function _baseURI() internal view virtual returns (string memory) {
338         return "";
339     }
340 
341     
342     function approve(address to, uint256 tokenId) public virtual override {
343         address owner = ERC721.ownerOf(tokenId);
344         require(to != owner, "ERC721: approval to current owner");
345 
346         require(
347             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
348             "ERC721: approve caller is not owner nor approved for all"
349         );
350 
351         _approve(to, tokenId);
352     }
353 
354     
355     function getApproved(uint256 tokenId) public view virtual override returns (address) {
356         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
357 
358         return _tokenApprovals[tokenId];
359     }
360 
361     
362     function setApprovalForAll(address operator, bool approved) public virtual override {
363         require(operator != _msgSender(), "ERC721: approve to caller");
364 
365         _operatorApprovals[_msgSender()][operator] = approved;
366         emit ApprovalForAll(_msgSender(), operator, approved);
367     }
368 
369     
370     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
371         return _operatorApprovals[owner][operator];
372     }
373 
374     
375     function transferFrom(
376         address from,
377         address to,
378         uint256 tokenId
379     ) public virtual override {
380         
381         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
382 
383         _transfer(from, to, tokenId);
384     }
385 
386     
387     function safeTransferFrom(
388         address from,
389         address to,
390         uint256 tokenId
391     ) public virtual override {
392         safeTransferFrom(from, to, tokenId, "");
393     }
394 
395     
396     function safeTransferFrom(
397         address from,
398         address to,
399         uint256 tokenId,
400         bytes memory _data
401     ) public virtual override {
402         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
403         _safeTransfer(from, to, tokenId, _data);
404     }
405 
406     
407     function _safeTransfer(
408         address from,
409         address to,
410         uint256 tokenId,
411         bytes memory _data
412     ) internal virtual {
413         _transfer(from, to, tokenId);
414         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
415     }
416 
417     
418     function _exists(uint256 tokenId) internal view virtual returns (bool) {
419         return _owners[tokenId] != address(0);
420     }
421 
422     
423     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
424         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
425         address owner = ERC721.ownerOf(tokenId);
426         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
427     }
428 
429     
430     function _safeMint(address to, uint256 tokenId) internal virtual {
431         _safeMint(to, tokenId, "");
432     }
433 
434     
435     function _safeMint(
436         address to,
437         uint256 tokenId,
438         bytes memory _data
439     ) internal virtual {
440         _mint(to, tokenId);
441         require(
442             _checkOnERC721Received(address(0), to, tokenId, _data),
443             "ERC721: transfer to non ERC721Receiver implementer"
444         );
445     }
446 
447     
448     function _mint(address to, uint256 tokenId) internal virtual {
449         require(to != address(0), "ERC721: mint to the zero address");
450         require(!_exists(tokenId), "ERC721: token already minted");
451 
452         _beforeTokenTransfer(address(0), to, tokenId);
453 
454         _balances[to] += 1;
455         _owners[tokenId] = to;
456 
457         emit Transfer(address(0), to, tokenId);
458     }
459 
460     
461     function _burn(uint256 tokenId) internal virtual {
462         address owner = ERC721.ownerOf(tokenId);
463 
464         _beforeTokenTransfer(owner, address(0), tokenId);
465 
466         
467         _approve(address(0), tokenId);
468 
469         _balances[owner] -= 1;
470         delete _owners[tokenId];
471 
472         emit Transfer(owner, address(0), tokenId);
473     }
474 
475     
476     function _transfer(
477         address from,
478         address to,
479         uint256 tokenId
480     ) internal virtual {
481         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
482         require(to != address(0), "ERC721: transfer to the zero address");
483 
484         _beforeTokenTransfer(from, to, tokenId);
485 
486         
487         _approve(address(0), tokenId);
488 
489         _balances[from] -= 1;
490         _balances[to] += 1;
491         _owners[tokenId] = to;
492 
493         emit Transfer(from, to, tokenId);
494     }
495 
496     
497     function _approve(address to, uint256 tokenId) internal virtual {
498         _tokenApprovals[tokenId] = to;
499         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
500     }
501 
502     
503     function _checkOnERC721Received(
504         address from,
505         address to,
506         uint256 tokenId,
507         bytes memory _data
508     ) private returns (bool) {
509         if (to.isContract()) {
510             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
511                 return retval == IERC721Receiver.onERC721Received.selector;
512             } catch (bytes memory reason) {
513                 if (reason.length == 0) {
514                     revert("ERC721: transfer to non ERC721Receiver implementer");
515                 } else {
516                     assembly {
517                         revert(add(32, reason), mload(reason))
518                     }
519                 }
520             }
521         } else {
522             return true;
523         }
524     }
525 
526     
527     function _beforeTokenTransfer(
528         address from,
529         address to,
530         uint256 tokenId
531     ) internal virtual {}
532 }
533 
534 interface IERC721Enumerable is IERC721 {
535     
536     function totalSupply() external view returns (uint256);
537 
538     
539     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
540 
541     
542     function tokenByIndex(uint256 index) external view returns (uint256);
543 }
544 
545 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
546     
547     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
548 
549     
550     mapping(uint256 => uint256) private _ownedTokensIndex;
551 
552     
553     uint256[] private _allTokens;
554 
555     
556     mapping(uint256 => uint256) private _allTokensIndex;
557 
558     
559     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
560         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
561     }
562 
563     
564     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
565         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
566         return _ownedTokens[owner][index];
567     }
568 
569     
570     function totalSupply() public view virtual override returns (uint256) {
571         return _allTokens.length;
572     }
573 
574     
575     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
576         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
577         return _allTokens[index];
578     }
579 
580     
581     function _beforeTokenTransfer(
582         address from,
583         address to,
584         uint256 tokenId
585     ) internal virtual override {
586         super._beforeTokenTransfer(from, to, tokenId);
587 
588         if (from == address(0)) {
589             _addTokenToAllTokensEnumeration(tokenId);
590         } else if (from != to) {
591             _removeTokenFromOwnerEnumeration(from, tokenId);
592         }
593         if (to == address(0)) {
594             _removeTokenFromAllTokensEnumeration(tokenId);
595         } else if (to != from) {
596             _addTokenToOwnerEnumeration(to, tokenId);
597         }
598     }
599 
600     
601     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
602         uint256 length = ERC721.balanceOf(to);
603         _ownedTokens[to][length] = tokenId;
604         _ownedTokensIndex[tokenId] = length;
605     }
606 
607     
608     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
609         _allTokensIndex[tokenId] = _allTokens.length;
610         _allTokens.push(tokenId);
611     }
612 
613     
614     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
615         
616         
617 
618         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
619         uint256 tokenIndex = _ownedTokensIndex[tokenId];
620 
621         
622         if (tokenIndex != lastTokenIndex) {
623             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
624 
625             _ownedTokens[from][tokenIndex] = lastTokenId; 
626             _ownedTokensIndex[lastTokenId] = tokenIndex; 
627         }
628 
629         
630         delete _ownedTokensIndex[tokenId];
631         delete _ownedTokens[from][lastTokenIndex];
632     }
633 
634     
635     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
636         
637         
638 
639         uint256 lastTokenIndex = _allTokens.length - 1;
640         uint256 tokenIndex = _allTokensIndex[tokenId];
641 
642         
643         
644         
645         uint256 lastTokenId = _allTokens[lastTokenIndex];
646 
647         _allTokens[tokenIndex] = lastTokenId; 
648         _allTokensIndex[lastTokenId] = tokenIndex; 
649 
650         
651         delete _allTokensIndex[tokenId];
652         _allTokens.pop();
653     }
654 }
655 
656 abstract contract Pausable is Context {
657     
658     event Paused(address account);
659 
660     
661     event Unpaused(address account);
662 
663     bool private _paused;
664 
665     
666     constructor() {
667         _paused = false;
668     }
669 
670     
671     function paused() public view virtual returns (bool) {
672         return _paused;
673     }
674 
675     
676     modifier whenNotPaused() {
677         require(!paused(), "Pausable: paused");
678         _;
679     }
680 
681     
682     modifier whenPaused() {
683         require(paused(), "Pausable: not paused");
684         _;
685     }
686 
687     
688     function _pause() internal virtual whenNotPaused {
689         _paused = true;
690         emit Paused(_msgSender());
691     }
692 
693     
694     function _unpause() internal virtual whenPaused {
695         _paused = false;
696         emit Unpaused(_msgSender());
697     }
698 }
699 
700 library Counters {
701     struct Counter {
702         
703         
704         
705         uint256 _value; 
706     }
707 
708     function current(Counter storage counter) internal view returns (uint256) {
709         return counter._value;
710     }
711 
712     function increment(Counter storage counter) internal {
713         unchecked {
714             counter._value += 1;
715         }
716     }
717 
718     function decrement(Counter storage counter) internal {
719         uint256 value = counter._value;
720         require(value > 0, "Counter: decrement overflow");
721         unchecked {
722             counter._value = value - 1;
723         }
724     }
725 
726     function reset(Counter storage counter) internal {
727         counter._value = 0;
728     }
729 }
730 
731 abstract contract Ownable is Context {
732     address private _owner;
733 
734     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
735 
736     
737     constructor() {
738         _setOwner(_msgSender());
739     }
740 
741     
742     function owner() public view virtual returns (address) {
743         return _owner;
744     }
745 
746     
747     modifier onlyOwner() {
748         require(owner() == _msgSender(), "Ownable: caller is not the owner");
749         _;
750     }
751 
752     
753     function renounceOwnership() public virtual onlyOwner {
754         _setOwner(address(0));
755     }
756 
757     
758     function transferOwnership(address newOwner) public virtual onlyOwner {
759         require(newOwner != address(0), "Ownable: new owner is the zero address");
760         _setOwner(newOwner);
761     }
762 
763     function _setOwner(address newOwner) private {
764         address oldOwner = _owner;
765         _owner = newOwner;
766         emit OwnershipTransferred(oldOwner, newOwner);
767     }
768 }
769 
770 contract EnchantedValleyMintPass is
771         Context,
772         ERC721,
773         ERC721Enumerable,
774         Pausable,
775         Ownable {
776     using Counters for Counters.Counter;
777 
778     Counters.Counter private _tokenIdCounter;
779 
780     uint public maxSupply = 500;
781     uint public limit = 20;
782     uint public price = 0.032 ether;
783 
784     string public currentTokenURI = "https://arweave.net/x2d2gqZkBIfwlUSzbvnm_04S1iWzYAY_9yE5zcaycRE";
785     string public currentContractURI = "https://arweave.net/MZPyMd5bqhTeN1mz54f0w3Cg3Cu2Lh4b1A7pMOvNsqg";
786 
787     bool public stopSales = false;
788 
789     address payable private bigH; 
790     address payable private stargazer; 
791     address payable private treasury; 
792 
793     constructor(
794         address payable _bigH,
795         address payable _stargazer,
796         address payable _treasury
797     ) ERC721("Enchanted Artifact", "EVART") {
798         bigH = _bigH;
799         stargazer = _stargazer;
800         treasury = _treasury;
801     }
802 
803     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
804         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
805 
806         return _baseURI();
807     }
808 
809     function _baseURI() override internal view returns (string memory) {
810         return currentTokenURI;
811     }
812 
813     function contractURI() public view returns (string memory) {
814         return currentContractURI;
815     }
816 
817     function setCurrentTokenURI(string memory newURI) public onlyOwner {
818         currentTokenURI = newURI;
819     }
820 
821     function setCurrentContractURI(string memory newURI) public onlyOwner {
822         currentContractURI = newURI;
823     }
824 
825     function setPrice(uint price_) public onlyOwner {
826         price = price_;
827     }
828 
829     function setLimit(uint limit_) public onlyOwner {
830         limit = limit_;
831     }
832 
833     function setMaxSupply(uint maxSupply_) public onlyOwner {
834         maxSupply = maxSupply_;
835     }
836 
837     function adminMint(address to, uint number) public payable onlyOwner {
838         require(_tokenIdCounter.current() + number <= maxSupply, "Not enough tokens left");
839 
840         for (uint i = 0 ; i < number ; i ++) {
841             _safeMint(to, _tokenIdCounter.current());
842             _tokenIdCounter.increment();
843         }
844     }
845 
846     function safeMint(uint number, bool isTest) public payable {
847         address to = msg.sender;
848         require(stopSales == false, "Sales are now stopped");
849         require(msg.value >= (price * number), "Not enough value provided to match or exceed price");
850         require(number > 0, "Must request real number of tokens");
851         require(_tokenIdCounter.current() + number <= maxSupply, "Not enough tokens left");
852         require(balanceOf(to) + number <= limit, "You're requesting too many tokens");
853 
854         for (uint i = 0 ; i < number ; i ++) {
855             _safeMint(to, _tokenIdCounter.current());
856             _tokenIdCounter.increment();
857         }
858 
859         uint funds = msg.value;
860         uint five_points = funds / 20; 
861 
862         (bool sentBigH, ) = bigH.call{value:five_points}("");
863         require(sentBigH, 'transfer to bigH failed.');
864         (bool sentStargazer, ) = stargazer.call{value:five_points}("");
865         require(sentStargazer, 'transfer to stargazer failed.');
866 
867         uint remainder = funds - (five_points + five_points);
868         (bool sentTreasury, ) = treasury.call{value:remainder}("");
869         require(sentTreasury, 'transfer to treasury failed.');
870 
871         require (!isTest, 'failing at end due to test mode.');
872     }
873 
874     function setStopSales(bool value) public onlyOwner {
875         stopSales = value;
876     }
877 
878     function pause() public onlyOwner {
879         _pause();
880     }
881 
882     function unpause() public onlyOwner {
883         _unpause();
884     }
885 
886     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
887         internal
888         whenNotPaused
889         override(ERC721, ERC721Enumerable)
890     {
891         super._beforeTokenTransfer(from, to, tokenId);
892     }
893 
894     function supportsInterface(bytes4 interfaceId)
895         public
896         view
897         override(ERC721, ERC721Enumerable)
898         returns (bool)
899     {
900         return super.supportsInterface(interfaceId);
901     }
902 }