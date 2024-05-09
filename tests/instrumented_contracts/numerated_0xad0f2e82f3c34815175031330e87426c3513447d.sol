1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.9.0;
3 
4 
5 interface IERC165 {
6     
7     function supportsInterface(bytes4 interfaceId) external view returns (bool);
8 }
9 
10 interface IERC721 is IERC165 {
11     
12     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
13 
14     
15     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
16 
17     
18     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
19 
20     
21     function balanceOf(address owner) external view returns (uint256 balance);
22 
23     
24     function ownerOf(uint256 tokenId) external view returns (address owner);
25 
26     
27     function safeTransferFrom(
28         address from,
29         address to,
30         uint256 tokenId
31     ) external;
32 
33     
34     function transferFrom(
35         address from,
36         address to,
37         uint256 tokenId
38     ) external;
39 
40     
41     function approve(address to, uint256 tokenId) external;
42 
43     
44     function getApproved(uint256 tokenId) external view returns (address operator);
45 
46     
47     function setApprovalForAll(address operator, bool _approved) external;
48 
49     
50     function isApprovedForAll(address owner, address operator) external view returns (bool);
51 
52     
53     function safeTransferFrom(
54         address from,
55         address to,
56         uint256 tokenId,
57         bytes calldata data
58     ) external;
59 }
60 
61 interface IERC721Receiver {
62     
63     function onERC721Received(
64         address operator,
65         address from,
66         uint256 tokenId,
67         bytes calldata data
68     ) external returns (bytes4);
69 }
70 
71 interface IERC721Metadata is IERC721 {
72     
73     function name() external view returns (string memory);
74 
75     
76     function symbol() external view returns (string memory);
77 
78     
79     function tokenURI(uint256 tokenId) external view returns (string memory);
80 }
81 
82 library Address {
83     
84     function isContract(address account) internal view returns (bool) {
85         
86         
87         
88 
89         uint256 size;
90         assembly {
91             size := extcodesize(account)
92         }
93         return size > 0;
94     }
95 
96     
97     function sendValue(address payable recipient, uint256 amount) internal {
98         require(address(this).balance >= amount, "Address: insufficient balance");
99 
100         (bool success, ) = recipient.call{value: amount}("");
101         require(success, "Address: unable to send value, recipient may have reverted");
102     }
103 
104     
105     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
106         return functionCall(target, data, "Address: low-level call failed");
107     }
108 
109     
110     function functionCall(
111         address target,
112         bytes memory data,
113         string memory errorMessage
114     ) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     
119     function functionCallWithValue(
120         address target,
121         bytes memory data,
122         uint256 value
123     ) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
125     }
126 
127     
128     function functionCallWithValue(
129         address target,
130         bytes memory data,
131         uint256 value,
132         string memory errorMessage
133     ) internal returns (bytes memory) {
134         require(address(this).balance >= value, "Address: insufficient balance for call");
135         require(isContract(target), "Address: call to non-contract");
136 
137         (bool success, bytes memory returndata) = target.call{value: value}(data);
138         return _verifyCallResult(success, returndata, errorMessage);
139     }
140 
141     
142     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
143         return functionStaticCall(target, data, "Address: low-level static call failed");
144     }
145 
146     
147     function functionStaticCall(
148         address target,
149         bytes memory data,
150         string memory errorMessage
151     ) internal view returns (bytes memory) {
152         require(isContract(target), "Address: static call to non-contract");
153 
154         (bool success, bytes memory returndata) = target.staticcall(data);
155         return _verifyCallResult(success, returndata, errorMessage);
156     }
157 
158     
159     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
160         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
161     }
162 
163     
164     function functionDelegateCall(
165         address target,
166         bytes memory data,
167         string memory errorMessage
168     ) internal returns (bytes memory) {
169         require(isContract(target), "Address: delegate call to non-contract");
170 
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(
176         bool success,
177         bytes memory returndata,
178         string memory errorMessage
179     ) private pure returns (bytes memory) {
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
511                 return retval == IERC721Receiver(to).onERC721Received.selector;
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
534 abstract contract Ownable is Context {
535     address private _owner;
536 
537     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
538 
539     
540     constructor() {
541         _setOwner(_msgSender());
542     }
543 
544     
545     function owner() public view virtual returns (address) {
546         return _owner;
547     }
548 
549     
550     modifier onlyOwner() {
551         require(owner() == _msgSender(), "Ownable: caller is not the owner");
552         _;
553     }
554 
555     
556     function renounceOwnership() public virtual onlyOwner {
557         _setOwner(address(0));
558     }
559 
560     
561     function transferOwnership(address newOwner) public virtual onlyOwner {
562         require(newOwner != address(0), "Ownable: new owner is the zero address");
563         _setOwner(newOwner);
564     }
565 
566     function _setOwner(address newOwner) private {
567         address oldOwner = _owner;
568         _owner = newOwner;
569         emit OwnershipTransferred(oldOwner, newOwner);
570     }
571 }
572 
573 abstract contract BOTB {
574     function balanceOf(address owner) external view virtual returns (uint256 balance);
575 }
576 
577 library Sort {
578     struct BidOffer {
579         address account;
580         uint256 offeredPrice;
581     }
582 
583     function sort(
584         BidOffer[] storage arr,
585         int256 left,
586         int256 right
587     ) internal {
588         int256 i = left;
589         int256 j = right;
590         if (i == j) return;
591         uint256 pivot = arr[uint256(left + (right - left) / 2)].offeredPrice;
592         while (i <= j) {
593             while (arr[uint256(i)].offeredPrice < pivot) i++;
594             while (pivot < arr[uint256(j)].offeredPrice) j--;
595             if (i <= j) {
596                 (arr[uint256(i)].offeredPrice, arr[uint256(j)].offeredPrice) = (
597                     arr[uint256(j)].offeredPrice,
598                     arr[uint256(i)].offeredPrice
599                 );
600                 (arr[uint256(i)].account, arr[uint256(j)].account) = (arr[uint256(j)].account, arr[uint256(i)].account);
601                 i++;
602                 j--;
603             }
604         }
605         if (left < j) sort(arr, left, j);
606         if (i < right) sort(arr, i, right);
607     }
608 }
609 
610 contract FMWWithTicket is Ownable, ERC721 {
611     BOTB public botb;
612 
613     address[] private __payees = [
614         address(0xE7c08dBa10Ce07e1b70e87A355957CC8bfc95DBC), 
615         address(0x35a409031a548A02737Add2b33b37013b0AE3295), 
616         address(0x1c447BD23424903610A2198315831122C99463B9), 
617         address(0x04231ce30049ab88a795c3Dd10A15116E83811B7), 
618         address(0x4dDd7EC653Fc4814ff11996d7d68b6625e4DFDba), 
619         address(0xe6774892A893984F345975f5d4E33C44B460AB30) 
620     ];
621 
622     uint256[] private __shares = [83270, 4170, 5060, 500, 3500, 3500];
623 
624     bool public _tokensLoaded = false;
625 
626     
627     bool public _isTicketSeason = false;
628     bool private _canOpenTicketSeason = true;
629     uint256 private _ticketCounter = 0;
630     
631     bool private _useExternalBotbService = false;
632 
633     uint256 private maxTicketsDefaultValue = 8000;
634 
635     uint256 private ticketToTokenGap = 2000;
636     uint256 private maxTickets = maxTicketsDefaultValue;
637 
638     mapping(address => uint256[]) private usersToTickets;
639     
640 
641     uint256 private totalTokens;
642     
643     uint256 private _tokenCounter = 0;
644 
645     
646     string public baseURI;
647 
648     constructor() ERC721("FloydsWorld", "FMWNFT") {
649         baseURI = "https://floydnft.com/token/";
650         botb = BOTB(0x3a8778A58993bA4B941f85684D74750043A4bB5f);
651         ownerMint(111);
652     }
653 
654     function _baseURI() internal view virtual override returns (string memory) {
655         return baseURI;
656     }
657 
658     function setBaseURI(string memory __baseURI) public onlyOwner {
659         baseURI = __baseURI;
660     }
661 
662     function setUseExternalBotbService(bool value) public onlyOwner {
663         _useExternalBotbService = value;
664     }
665 
666     uint256 private _ticketPrice = 0.11 ether;
667 
668     function openTicketSeason() public onlyOwner {
669         require(_canOpenTicketSeason, "Ticket Season can't be open right now");
670         _isTicketSeason = true;
671         _canOpenTicketSeason = false;
672     }
673 
674     function setIsTicketSeason(bool value) public onlyOwner {
675         _isTicketSeason = value;
676     }
677 
678     function setTicketPrice(uint256 newPrice) public onlyOwner {
679         _ticketPrice = newPrice;
680     }
681 
682     function closeTicketSeason() public onlyOwner {
683         _isTicketSeason = false;
684         if (_ticketCounter < maxTickets) {
685             maxTickets = _ticketCounter;
686         }
687         _canOpenTicketSeason = false;
688     }
689 
690     function resetCanOpenTicketSeason() public onlyOwner {
691         _canOpenTicketSeason = true;
692         _isTicketSeason = false;
693         maxTickets = maxTicketsDefaultValue;
694     }
695 
696     function buyTickets(uint256 howMany, uint256 bullsOnAccount) external payable {
697         uint256 availableBulls = bullsOnAccount;
698         uint256 maxTicketsPerAccount = 1;
699         if (_useExternalBotbService) {
700             availableBulls = botb.balanceOf(msg.sender);
701         }
702         if (availableBulls < 4) {
703             maxTicketsPerAccount = availableBulls;
704         } else {
705             maxTicketsPerAccount = ((availableBulls * 70) / 100);
706             if (((availableBulls * 70) % 100) > 0) {
707                 maxTicketsPerAccount += 1;
708             }
709         }
710         require(_isTicketSeason, "Ticket Season is not Open");
711 
712         require(
713             howMany > 0 && howMany <= (maxTicketsPerAccount - usersToTickets[msg.sender].length),
714             string("Can't buy less than 1 ticket or exceed your maximum")
715         );
716         require(
717             howMany <= (maxTickets - _ticketCounter),
718             string("Can't buy less than 1 ticket or exceed the available ones")
719         );
720         require(msg.value == howMany * _ticketPrice, "Unmatched Ticket price");
721         for (uint64 i = 0; i < howMany; i++) {
722             uint256 ticketId = (ticketToTokenGap + _ticketCounter++);
723             usersToTickets[msg.sender].push(ticketId);
724             _safeMint(msg.sender, ticketId);
725         }
726     }
727 
728     function buyFloyds(uint256 howMany) external payable {
729         require(_tokensLoaded, "Tokens not available yet");
730         require(msg.value == howMany * 0.15 ether, "Each Floyd costs 0.15 ether");
731         require(
732             howMany > 0 && howMany < (totalTokens - _tokenCounter),
733             string("Can't buy less than 1 token or exceed the available ones")
734         );
735         for (uint64 i = 0; i < howMany; i++) {
736             uint256 tkId = getNextToken();
737             _safeMint(msg.sender, tkId);
738         }
739     }
740 
741     function ownerMint(uint256 howMany) public onlyOwner {
742         for (uint64 i = 0; i < howMany; i++) {
743             uint256 tkId = getNextToken();
744             _safeMint(msg.sender, tkId);
745         }
746     }
747 
748     function loadTokens(uint256 howMany) public onlyOwner {
749         totalTokens = howMany;
750         _tokensLoaded = true;
751     }
752 
753     function getNextToken() private returns (uint256) {
754         if (_tokenCounter == ticketToTokenGap) {
755             _tokenCounter += maxTickets;
756         }
757         return _tokenCounter++;
758     }
759 
760     function withdrawAll() public onlyOwner {
761         uint256 balance = address(this).balance;
762         uint256 arrayLength = __payees.length;
763         for (uint256 i = 0; i < arrayLength; i++) {
764             payable(__payees[i]).transfer((balance * __shares[i]) / 100000);
765         }
766         payable(owner()).transfer(balance);
767     }
768 
769     using Sort for Sort.BidOffer[];
770 
771     bool public _isAuctionSeason = false;
772     uint256 private _maxTokensToAuction;
773     uint256 private _minBiddedValue = 2.5 ether;
774     uint256 private _minAllowedValue = 0.15 ether;
775 
776     Sort.BidOffer[] private ds;
777 
778     function startAuction(uint256 howMany) public onlyOwner {
779         _isAuctionSeason = true;
780         _maxTokensToAuction = howMany;
781     }
782 
783     function getHowManyBidsSoFar() public view onlyOwner returns (uint256) {
784         return ds.length;
785     }
786 
787     function bid(uint256 howMany, uint256 offeredPrice) external payable {
788         require(_isAuctionSeason, "Auction is not open");
789         require(
790             msg.value == howMany * offeredPrice,
791             "Eth sent needs to match offered price times how many times you want"
792         );
793         require(
794             offeredPrice >= _minAllowedValue && offeredPrice <= _minBiddedValue,
795             "Offered value must be between 0.15 and 2.5 Eth"
796         );
797         require(howMany > 0, string("Can't bid less than 1 token"));
798 
799         for (uint256 i = 0; i < howMany; i++) {
800             Sort.BidOffer memory bo = Sort.BidOffer(msg.sender, offeredPrice);
801             ds.push(bo);
802         }
803     }
804 
805     function getCurrentMinValue() public onlyOwner returns (uint256) {
806         ds.sort(0, int256(ds.length - 1)); 
807         uint256 startIndex = 0;
808         if (ds.length > _maxTokensToAuction) {
809             startIndex = ds.length - _maxTokensToAuction;
810         }
811         uint256 minValue = ds[startIndex].offeredPrice;
812         return uint256(minValue);
813     }
814 
815     function closeAuction() public onlyOwner {
816         _isAuctionSeason = false;
817         ds.sort(0, int256(ds.length - 1));
818         uint256 startIndex = 0;
819         if (ds.length > _maxTokensToAuction) {
820             startIndex = ds.length - _maxTokensToAuction;
821             for (uint256 i = 0; i < startIndex; i++) {
822                 refund(ds[i].account, ds[i].offeredPrice);
823             }
824         }
825         uint256 minValue = ds[startIndex].offeredPrice;
826         for (uint256 i = startIndex; i < ds.length; i++) {
827             uint256 tkId = getNextToken();
828             _safeMint(ds[i].account, tkId);
829             refund(ds[i].account, ds[i].offeredPrice - minValue);
830         }
831     }
832 
833     function refund(address to, uint256 amount) private {
834         payable(to).transfer(amount);
835     }
836 }