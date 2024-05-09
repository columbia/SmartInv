1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 abstract contract ReentrancyGuard {
6     uint256 private constant _NOT_ENTERED = 1;
7     uint256 private constant _ENTERED = 2;
8 
9     uint256 private _status;
10 
11     constructor() {
12         _status = _NOT_ENTERED;
13     }
14 
15     modifier nonReentrant() {
16         // On the first call to nonReentrant, _notEntered will be true
17         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
18 
19         // Any calls to nonReentrant after this point will fail
20         _status = _ENTERED;
21 
22         _;
23 
24         // By storing the original value once again, a refund is triggered (see
25         // https://eips.ethereum.org/EIPS/eip-2200)
26         _status = _NOT_ENTERED;
27     }
28 }
29 
30 
31 library Strings {
32     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
33     uint8 private constant _ADDRESS_LENGTH = 20;
34 
35     function toString(uint256 value) internal pure returns (string memory) {
36         if (value == 0) {
37             return "0";
38         }
39         uint256 temp = value;
40         uint256 digits;
41         while (temp != 0) {
42             digits++;
43             temp /= 10;
44         }
45         bytes memory buffer = new bytes(digits);
46         while (value != 0) {
47             digits -= 1;
48             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
49             value /= 10;
50         }
51         return string(buffer);
52     }
53 
54     function toHexString(uint256 value) internal pure returns (string memory) {
55         if (value == 0) {
56             return "0x00";
57         }
58         uint256 temp = value;
59         uint256 length = 0;
60         while (temp != 0) {
61             length++;
62             temp >>= 8;
63         }
64         return toHexString(value, length);
65     }
66 
67     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
68         bytes memory buffer = new bytes(2 * length + 2);
69         buffer[0] = "0";
70         buffer[1] = "x";
71         for (uint256 i = 2 * length + 1; i > 1; --i) {
72             buffer[i] = _HEX_SYMBOLS[value & 0xf];
73             value >>= 4;
74         }
75         require(value == 0, "Strings: hex length insufficient");
76         return string(buffer);
77     }
78 
79     function toHexString(address addr) internal pure returns (string memory) {
80         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
81     }
82 }
83 
84 
85 abstract contract Context {
86     function _msgSender() internal view virtual returns (address) {
87         return msg.sender;
88     }
89 
90     function _msgData() internal view virtual returns (bytes calldata) {
91         return msg.data;
92     }
93 }
94 
95 
96 abstract contract Ownable is Context {
97     address private _owner;
98 
99     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
100 
101     constructor() {
102         _transferOwnership(_msgSender());
103     }
104 
105     modifier onlyOwner() {
106         _checkOwner();
107         _;
108     }
109 
110     function owner() public view virtual returns (address) {
111         return _owner;
112     }
113 
114     function _checkOwner() internal view virtual {
115         require(owner() == _msgSender(), "Ownable: caller is not the owner");
116     }
117 
118     function renounceOwnership() public virtual onlyOwner {
119         _transferOwnership(address(0));
120     }
121 
122     function transferOwnership(address newOwner) public virtual onlyOwner {
123         require(newOwner != address(0), "Ownable: new owner is the zero address");
124         _transferOwnership(newOwner);
125     }
126 
127     function _transferOwnership(address newOwner) internal virtual {
128         address oldOwner = _owner;
129         _owner = newOwner;
130         emit OwnershipTransferred(oldOwner, newOwner);
131     }
132 }
133 
134 
135 library Address {
136     function isContract(address account) internal view returns (bool) {
137         // This method relies on extcodesize/address.code.length, which returns 0
138         // for contracts in construction, since the code is only stored at the end
139         // of the constructor execution.
140         return account.code.length > 0;
141     }
142 
143     function sendValue(address payable recipient, uint256 amount) internal {
144         require(address(this).balance >= amount, "Address: insufficient balance");
145 
146         (bool success, ) = recipient.call{value: amount}("");
147         require(success, "Address: unable to send value, recipient may have reverted");
148     }
149 
150     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
151         return functionCall(target, data, "Address: low-level call failed");
152     }
153 
154     function functionCall(
155         address target,
156         bytes memory data,
157         string memory errorMessage
158     ) internal returns (bytes memory) {
159         return functionCallWithValue(target, data, 0, errorMessage);
160     }
161 
162     function functionCallWithValue(
163         address target,
164         bytes memory data,
165         uint256 value
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
168     }
169 
170     function functionCallWithValue(
171         address target,
172         bytes memory data,
173         uint256 value,
174         string memory errorMessage
175     ) internal returns (bytes memory) {
176         require(address(this).balance >= value, "Address: insufficient balance for call");
177         require(isContract(target), "Address: call to non-contract");
178 
179         (bool success, bytes memory returndata) = target.call{value: value}(data);
180         return verifyCallResult(success, returndata, errorMessage);
181     }
182 
183     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
184         return functionStaticCall(target, data, "Address: low-level static call failed");
185     }
186 
187     function functionStaticCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal view returns (bytes memory) {
192         require(isContract(target), "Address: static call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.staticcall(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
199         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
200     }
201 
202     function functionDelegateCall(
203         address target,
204         bytes memory data,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(isContract(target), "Address: delegate call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.delegatecall(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     function verifyCallResult(
214         bool success,
215         bytes memory returndata,
216         string memory errorMessage
217     ) internal pure returns (bytes memory) {
218         if (success) {
219             return returndata;
220         } else {
221             // Look for revert reason and bubble it up if present
222             if (returndata.length > 0) {
223                 // The easiest way to bubble the revert reason is using memory via assembly
224                 /// @solidity memory-safe-assembly
225                 assembly {
226                     let returndata_size := mload(returndata)
227                     revert(add(32, returndata), returndata_size)
228                 }
229             } else {
230                 revert(errorMessage);
231             }
232         }
233     }
234 }
235 
236 
237 interface IERC165 {
238     function supportsInterface(bytes4 interfaceId) external view returns (bool);
239 }
240 
241 
242 abstract contract ERC165 is IERC165 {
243     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
244         return interfaceId == type(IERC165).interfaceId;
245     }
246 }
247 
248 
249 interface IERC1155Receiver is IERC165 {
250     function onERC1155Received(
251         address operator,
252         address from,
253         uint256 id,
254         uint256 value,
255         bytes calldata data
256     ) external returns (bytes4);
257 
258     function onERC1155BatchReceived(
259         address operator,
260         address from,
261         uint256[] calldata ids,
262         uint256[] calldata values,
263         bytes calldata data
264     ) external returns (bytes4);
265 }
266 
267 
268 interface IERC1155 is IERC165 {
269     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
270 
271     event TransferBatch(
272         address indexed operator,
273         address indexed from,
274         address indexed to,
275         uint256[] ids,
276         uint256[] values
277     );
278 
279     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
280 
281     event URI(string value, uint256 indexed id);
282 
283     function balanceOf(address account, uint256 id) external view returns (uint256);
284 
285     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
286         external
287         view
288         returns (uint256[] memory);
289 
290     function setApprovalForAll(address operator, bool approved) external;
291 
292     function isApprovedForAll(address account, address operator) external view returns (bool);
293 
294     function safeTransferFrom(
295         address from,
296         address to,
297         uint256 id,
298         uint256 amount,
299         bytes calldata data
300     ) external;
301 
302     function safeBatchTransferFrom(
303         address from,
304         address to,
305         uint256[] calldata ids,
306         uint256[] calldata amounts,
307         bytes calldata data
308     ) external;
309 }
310 
311 
312 interface IERC1155MetadataURI is IERC1155 {
313     function uri(uint256 id) external view returns (string memory);
314 }
315 
316 
317 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
318     using Address for address;
319 
320     // Mapping from token ID to account balances
321     mapping(uint256 => mapping(address => uint256)) private _balances;
322 
323     // Mapping from account to operator approvals
324     mapping(address => mapping(address => bool)) private _operatorApprovals;
325 
326     string private _uri;
327 
328     constructor(string memory uri_) {
329         _setURI(uri_);
330     }
331 
332     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
333         return
334             interfaceId == type(IERC1155).interfaceId ||
335             interfaceId == type(IERC1155MetadataURI).interfaceId ||
336             super.supportsInterface(interfaceId);
337     }
338 
339     function uri(uint256) public view virtual override returns (string memory) {
340         return _uri;
341     }
342 
343     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
344         require(account != address(0), "ERC1155: address zero is not a valid owner");
345         return _balances[id][account];
346     }
347 
348     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
349         public
350         view
351         virtual
352         override
353         returns (uint256[] memory)
354     {
355         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
356 
357         uint256[] memory batchBalances = new uint256[](accounts.length);
358 
359         for (uint256 i = 0; i < accounts.length; ++i) {
360             batchBalances[i] = balanceOf(accounts[i], ids[i]);
361         }
362 
363         return batchBalances;
364     }
365 
366     function setApprovalForAll(address operator, bool approved) public virtual override {
367         _setApprovalForAll(_msgSender(), operator, approved);
368     }
369 
370     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
371         return _operatorApprovals[account][operator];
372     }
373 
374     function safeTransferFrom(
375         address from,
376         address to,
377         uint256 id,
378         uint256 amount,
379         bytes memory data
380     ) public virtual override {
381         require(
382             from == _msgSender() || isApprovedForAll(from, _msgSender()),
383             "ERC1155: caller is not token owner nor approved"
384         );
385         _safeTransferFrom(from, to, id, amount, data);
386     }
387 
388     function safeBatchTransferFrom(
389         address from,
390         address to,
391         uint256[] memory ids,
392         uint256[] memory amounts,
393         bytes memory data
394     ) public virtual override {
395         require(
396             from == _msgSender() || isApprovedForAll(from, _msgSender()),
397             "ERC1155: caller is not token owner nor approved"
398         );
399         _safeBatchTransferFrom(from, to, ids, amounts, data);
400     }
401 
402     function _safeTransferFrom(
403         address from,
404         address to,
405         uint256 id,
406         uint256 amount,
407         bytes memory data
408     ) internal virtual {
409         require(to != address(0), "ERC1155: transfer to the zero address");
410 
411         address operator = _msgSender();
412         uint256[] memory ids = _asSingletonArray(id);
413         uint256[] memory amounts = _asSingletonArray(amount);
414 
415         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
416 
417         uint256 fromBalance = _balances[id][from];
418         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
419         unchecked {
420             _balances[id][from] = fromBalance - amount;
421         }
422         _balances[id][to] += amount;
423 
424         emit TransferSingle(operator, from, to, id, amount);
425 
426         _afterTokenTransfer(operator, from, to, ids, amounts, data);
427 
428         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
429     }
430 
431     function _safeBatchTransferFrom(
432         address from,
433         address to,
434         uint256[] memory ids,
435         uint256[] memory amounts,
436         bytes memory data
437     ) internal virtual {
438         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
439         require(to != address(0), "ERC1155: transfer to the zero address");
440 
441         address operator = _msgSender();
442 
443         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
444 
445         for (uint256 i = 0; i < ids.length; ++i) {
446             uint256 id = ids[i];
447             uint256 amount = amounts[i];
448 
449             uint256 fromBalance = _balances[id][from];
450             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
451             unchecked {
452                 _balances[id][from] = fromBalance - amount;
453             }
454             _balances[id][to] += amount;
455         }
456 
457         emit TransferBatch(operator, from, to, ids, amounts);
458 
459         _afterTokenTransfer(operator, from, to, ids, amounts, data);
460 
461         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
462     }
463 
464     function _setURI(string memory newuri) internal virtual {
465         _uri = newuri;
466     }
467 
468     function _mint(
469         address to,
470         uint256 id,
471         uint256 amount,
472         bytes memory data
473     ) internal virtual {
474         require(to != address(0), "ERC1155: mint to the zero address");
475 
476         address operator = _msgSender();
477         uint256[] memory ids = _asSingletonArray(id);
478         uint256[] memory amounts = _asSingletonArray(amount);
479 
480         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
481 
482         _balances[id][to] += amount;
483         emit TransferSingle(operator, address(0), to, id, amount);
484 
485         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
486 
487         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
488     }
489 
490     function _mintBatch(
491         address to,
492         uint256[] memory ids,
493         uint256[] memory amounts,
494         bytes memory data
495     ) internal virtual {
496         require(to != address(0), "ERC1155: mint to the zero address");
497         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
498 
499         address operator = _msgSender();
500 
501         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
502 
503         for (uint256 i = 0; i < ids.length; i++) {
504             _balances[ids[i]][to] += amounts[i];
505         }
506 
507         emit TransferBatch(operator, address(0), to, ids, amounts);
508 
509         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
510 
511         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
512     }
513 
514     function _burn(
515         address from,
516         uint256 id,
517         uint256 amount
518     ) internal virtual {
519         require(from != address(0), "ERC1155: burn from the zero address");
520 
521         address operator = _msgSender();
522         uint256[] memory ids = _asSingletonArray(id);
523         uint256[] memory amounts = _asSingletonArray(amount);
524 
525         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
526 
527         uint256 fromBalance = _balances[id][from];
528         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
529         unchecked {
530             _balances[id][from] = fromBalance - amount;
531         }
532 
533         emit TransferSingle(operator, from, address(0), id, amount);
534 
535         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
536     }
537 
538     function _burnBatch(
539         address from,
540         uint256[] memory ids,
541         uint256[] memory amounts
542     ) internal virtual {
543         require(from != address(0), "ERC1155: burn from the zero address");
544         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
545 
546         address operator = _msgSender();
547 
548         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
549 
550         for (uint256 i = 0; i < ids.length; i++) {
551             uint256 id = ids[i];
552             uint256 amount = amounts[i];
553 
554             uint256 fromBalance = _balances[id][from];
555             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
556             unchecked {
557                 _balances[id][from] = fromBalance - amount;
558             }
559         }
560 
561         emit TransferBatch(operator, from, address(0), ids, amounts);
562 
563         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
564     }
565 
566     function _setApprovalForAll(
567         address owner,
568         address operator,
569         bool approved
570     ) internal virtual {
571         require(owner != operator, "ERC1155: setting approval status for self");
572         _operatorApprovals[owner][operator] = approved;
573         emit ApprovalForAll(owner, operator, approved);
574     }
575 
576     function _beforeTokenTransfer(
577         address operator,
578         address from,
579         address to,
580         uint256[] memory ids,
581         uint256[] memory amounts,
582         bytes memory data
583     ) internal virtual {}
584 
585     function _afterTokenTransfer(
586         address operator,
587         address from,
588         address to,
589         uint256[] memory ids,
590         uint256[] memory amounts,
591         bytes memory data
592     ) internal virtual {}
593 
594     function _doSafeTransferAcceptanceCheck(
595         address operator,
596         address from,
597         address to,
598         uint256 id,
599         uint256 amount,
600         bytes memory data
601     ) private {
602         if (to.isContract()) {
603             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
604                 if (response != IERC1155Receiver.onERC1155Received.selector) {
605                     revert("ERC1155: ERC1155Receiver rejected tokens");
606                 }
607             } catch Error(string memory reason) {
608                 revert(reason);
609             } catch {
610                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
611             }
612         }
613     }
614 
615     function _doSafeBatchTransferAcceptanceCheck(
616         address operator,
617         address from,
618         address to,
619         uint256[] memory ids,
620         uint256[] memory amounts,
621         bytes memory data
622     ) private {
623         if (to.isContract()) {
624             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
625                 bytes4 response
626             ) {
627                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
628                     revert("ERC1155: ERC1155Receiver rejected tokens");
629                 }
630             } catch Error(string memory reason) {
631                 revert(reason);
632             } catch {
633                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
634             }
635         }
636     }
637 
638     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
639         uint256[] memory array = new uint256[](1);
640         array[0] = element;
641 
642         return array;
643     }
644 }
645 
646 
647 contract NiftyHands is ERC1155, Ownable, ReentrancyGuard {
648   using Strings for uint256;
649 
650   struct Code {
651     uint256 discount;
652     uint256 supply;
653   }
654 
655   uint256 public minPrice = 0.06 ether;
656   // Genesis stock is 9999
657   uint256 public stock = 9999;
658   string public name;
659   string public symbol;
660   string public baseURI;
661 
662   mapping(address => uint256[]) private userTokens;
663   mapping(uint256 => address) private tokenOwners;
664   mapping(string => Code) private codes;
665   mapping(address => uint256) private userSecretBalance;
666   uint256[] private mintedTokens;
667   string[] private codesList;
668   uint256 private maxPerUser = 5;
669   uint256 private maxPerUserSecret = 3;
670   bool private paused = false;
671   bool private secretMintPaused = false;
672 
673 
674   constructor() ERC1155("") {
675     name = "Nifty Hands";
676     symbol = "NiftyHands";
677     setURI("https://nifty-hands.com/nft/json/");
678   }
679 
680   modifier mintCompliance(uint256 _id) {
681     require(!paused, "Nifty error: NFT sales are on pause");
682     require(_id <= stock, "Nifty error: Not enough stock");
683     require(userTokens[tokenOwners[_id]].length <= maxPerUser, "Nifty error: you exceeded the max number of tokens per user");
684     require(tokenOwners[_id] == address(0), "Nifty error: This token has been minted");
685     _;
686   }
687 
688   function mint(address _to, uint256 _id) 
689     public 
690     payable 
691     mintCompliance(_id) 
692     nonReentrant 
693   {
694     require(msg.value >= minPrice || msg.sender == owner(), "Nifty error: Minting fee is below floor price");
695     _mint(_to, _id, 1, "");
696     addToken(_to, _id);
697   }
698 
699   function secretMint(address _to, uint256 _id, string memory _code) 
700     public 
701     payable 
702     mintCompliance(_id) 
703     nonReentrant 
704   {
705     require(!secretMintPaused, "Nifty error: NFT sales are on pause");
706     require(codes[_code].supply > 0 || codes[_code].discount != 0, "Nifty error: code isn't valid or expired");
707     require(msg.value*100 >= minPrice*(100-codes[_code].discount), "Nifty error: price is lower than discounted");
708     require(userSecretBalance[_to] <= maxPerUserSecret, "Nifty error: you exceeded the max number of tokens per user with secret codes");
709     _mint(_to, _id, 1, "");
710     addToken(_to, _id);
711     userSecretBalance[_to]++;
712     codes[_code].supply--;
713   }
714 
715   function _afterTokenTransfer(
716     address operator, 
717     address from, 
718     address to, 
719     uint256[] memory ids, 
720     uint256[] memory amounts, 
721     bytes memory data
722   ) 
723     internal 
724     virtual 
725     override 
726   {
727     if (from != address(0) && to != address(0)) {
728       deleteToken(ids[0]);
729       addToken(to, ids[0]);
730     }
731   }
732 
733   function validateCode(string memory _code) 
734     public 
735     view 
736     returns(uint256) 
737   {
738     require(codes[_code].discount >= 0 && codes[_code].discount <= 100, "Nifty error: code value isn't within [0, 100]");
739     require(codes[_code].supply > 0, "Nifty error: secret code is expired");
740     return codes[_code].discount;
741   }
742 
743   function burn(uint256 _id) public {
744     require(msg.sender == tokenOwners[_id], "Only owner can burn token");
745     _burn(msg.sender, _id, 1);
746     deleteToken(_id);
747   }
748 
749   function tokensOfOwner(address _owner) public view returns(uint256[] memory) {
750     return userTokens[_owner];
751   }
752 
753   function allTokens() public view returns(uint256[] memory) {
754     return mintedTokens;
755   }
756 
757   function supply() public view returns(uint256) {
758     return mintedTokens.length;
759   }
760 
761   function allSecretCodes() public view onlyOwner returns(string[] memory) {
762     return codesList;
763   }
764 
765   function secretCodeSupply(string memory _code) public view onlyOwner returns(uint256) {
766     return codes[_code].supply;
767   }
768 
769   function uri(uint256 _id) public override view returns (string memory) {
770     return string(
771         abi.encodePacked(
772             baseURI,
773             _id.toString(),
774             ".json"
775         )
776     );
777   }
778 
779 
780   // Settings modules
781 
782   function pause() public onlyOwner {
783     paused = !paused;
784   }
785 
786   function secretMintPause() public onlyOwner {
787     secretMintPaused = !secretMintPaused;
788   }
789 
790   function setMinPrice(uint256 _minPrice) public onlyOwner {
791     minPrice = _minPrice;
792   }
793 
794   function setStock(uint256 _stock) public onlyOwner {
795     stock = _stock;
796   }
797 
798   function setURI(string memory _baseURI) public onlyOwner {
799     baseURI = _baseURI;
800   }
801 
802   function setMaxPerUser(uint256 _maxPerUser) public onlyOwner {
803     maxPerUser = _maxPerUser;
804   }
805 
806   function setMaxPerUserSecret(uint256 _maxPerUserSecret) public onlyOwner {
807     maxPerUserSecret = _maxPerUserSecret;
808   }
809 
810   function addCode(string memory _code, Code memory _secretCode) public onlyOwner {
811     require(codes[_code].discount == 0, "Nifty error: code already exist");
812     require(_secretCode.discount >= 0 && _secretCode.discount <= 100, "Nifty error: code value isn't within [0, 100]");
813     codes[_code] = _secretCode;
814     codesList.push(_code);
815   }
816 
817   function deleteCode(string memory _code) public onlyOwner {
818     require(codes[_code].discount > 0, "Nifty error: code doesn't exist");
819     delete codes[_code];
820     deleteTokenFromArrayString(_code, codesList);
821   }
822 
823   function withdrawAll() public payable onlyOwner nonReentrant {
824     require(payable(msg.sender).send(address(this).balance));
825   }
826 
827 
828   // Util modules
829 
830   function addToken(address _to, uint _id) private {
831     userTokens[_to].push(_id);
832     tokenOwners[_id] = _to;
833     mintedTokens.push(_id);
834   }
835 
836   function deleteToken(uint256 _id) private {
837     require (tokenOwners[_id] != address(0), "Nifty error: token with this id has not been minted");
838     //delete from mintedTokens
839     require (deleteTokenFromArray(_id, mintedTokens), "Nifty error: token wasn't found among minted tokens");
840     //delete from userTokens
841     require (deleteTokenFromArray(_id, userTokens[tokenOwners[_id]]), "Nifty error: token wasn't found among user tokens");
842     //delete from tokenOwners
843     delete tokenOwners[_id];
844   }
845 
846   function deleteTokenFromArray(uint256 _id, uint256[] storage array) private returns(bool) {
847     for (uint256 i = 0; i <= mintedTokens.length; i++) {
848       if (array[i] == _id) {
849         array[i] = array[array.length - 1];
850         array.pop();
851         return true;
852       }
853     }
854     return false;
855   }
856 
857   function deleteTokenFromArrayString(string memory _value, string[] storage array) private returns(bool) {
858     for (uint256 i = 0; i <= mintedTokens.length; i++) {
859       if (keccak256(abi.encodePacked((array[i]))) == keccak256(abi.encodePacked((_value)))) {
860         array[i] = array[array.length - 1];
861         array.pop();
862         return true;
863       }
864     }
865     return false;
866   }
867 
868 }