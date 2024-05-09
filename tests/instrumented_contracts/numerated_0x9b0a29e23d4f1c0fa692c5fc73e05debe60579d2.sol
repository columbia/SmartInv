1 /*
2 
3 
4 [̲̅忍̲̅]  [̲̅S̲̅][̲̅h̲̅][̲̅i̲̅][̲̅n̲̅][̲̅o̲̅][̲̅b̲̅][̲̅i̲̅]
5 
6 
7 Web Site - https://shinobiclub.online
8 Twitter - https://twitter.com/ShinobiClubNFT
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 pragma solidity ^0.8.0;
14 
15 library Strings {
16     bytes16 private constant alphabet = "0123456789abcdef";
17 
18     function toString(uint256 value) internal pure returns (string memory) {
19       
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
52         bytes memory buffer = new bytes(2 * length + 2);
53         buffer[0] = "0";
54         buffer[1] = "x";
55         for (uint256 i = 2 * length + 1; i > 1; --i) {
56             buffer[i] = alphabet[value & 0xf];
57             value >>= 4;
58         }
59         require(value == 0, "#43");
60         return string(buffer);
61     }
62 
63 }
64 
65 interface IERC165 {
66 
67     function supportsInterface(bytes4 interfaceId) external view returns (bool);
68 }
69 
70 
71 interface IERC1155 is IERC165 {
72 
73     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
74 
75     event TransferBatch(
76         address indexed operator,
77         address indexed from,
78         address indexed to,
79         uint256[] ids,
80         uint256[] values
81     );
82 
83  
84     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
85 
86  
87     event URI(string value, uint256 indexed id);
88 
89 
90     function balanceOf(address account, uint256 id) external view returns (uint256);
91 
92 
93     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
94         external
95         view
96         returns (uint256[] memory);
97 
98     function setApprovalForAll(address operator, bool approved) external;
99 
100     function isApprovedForAll(address account, address operator) external view returns (bool);
101 
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 id,
106         uint256 amount,
107         bytes calldata data
108     ) external;
109 
110     function safeBatchTransferFrom(
111         address from,
112         address to,
113         uint256[] calldata ids,
114         uint256[] calldata amounts,
115         bytes calldata data
116     ) external;
117 }
118 
119 interface IERC1155Receiver is IERC165 {
120 
121     function onERC1155Received(
122         address operator,
123         address from,
124         uint256 id,
125         uint256 value,
126         bytes calldata data
127     ) external returns (bytes4);
128 
129     function onERC1155BatchReceived(
130         address operator,
131         address from,
132         uint256[] calldata ids,
133         uint256[] calldata values,
134         bytes calldata data
135     ) external returns (bytes4);
136 }
137 
138 interface IERC1155MetadataURI is IERC1155 {
139 
140     function uri(uint256 id) external view returns (string memory);
141 }
142 
143 abstract contract ERC165 is IERC165 {
144 
145     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
146         return interfaceId == type(IERC165).interfaceId;
147     }
148 }
149 
150 library Address {
151 
152     function isContract(address account) internal view returns (bool) {
153 
154         return account.code.length > 0;
155     }
156 
157     function sendValue(address payable recipient, uint256 amount) internal {
158         require(address(this).balance >= amount, "Address: insufficient balance");
159 
160         (bool success, ) = recipient.call{value: amount}("");
161         require(success, "Address: unable to send value, recipient may have reverted");
162     }
163 
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     function functionCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         return functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     function functionCallWithValue(
177         address target,
178         bytes memory data,
179         uint256 value
180     ) internal returns (bytes memory) {
181         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
182     }
183 
184     function functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 value,
188         string memory errorMessage
189     ) internal returns (bytes memory) {
190         require(address(this).balance >= value, "Address: insufficient balance for call");
191         require(isContract(target), "Address: call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.call{value: value}(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
198         return functionStaticCall(target, data, "Address: low-level static call failed");
199     }
200 
201     function functionStaticCall(
202         address target,
203         bytes memory data,
204         string memory errorMessage
205     ) internal view returns (bytes memory) {
206         require(isContract(target), "Address: static call to non-contract");
207 
208         (bool success, bytes memory returndata) = target.staticcall(data);
209         return verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
213         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
214     }
215 
216     function functionDelegateCall(
217         address target,
218         bytes memory data,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         require(isContract(target), "Address: delegate call to non-contract");
222 
223         (bool success, bytes memory returndata) = target.delegatecall(data);
224         return verifyCallResult(success, returndata, errorMessage);
225     }
226 
227     function verifyCallResult(
228         bool success,
229         bytes memory returndata,
230         string memory errorMessage
231     ) internal pure returns (bytes memory) {
232         if (success) {
233             return returndata;
234         } else {
235             // Look for revert reason and bubble it up if present
236             if (returndata.length > 0) {
237                 // The easiest way to bubble the revert reason is using memory via assembly
238 
239                 assembly {
240                     let returndata_size := mload(returndata)
241                     revert(add(32, returndata), returndata_size)
242                 }
243             } else {
244                 revert(errorMessage);
245             }
246         }
247     }
248 }
249 
250 
251 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
252 
253 abstract contract Context {
254     function _msgSender() internal view virtual returns (address) {
255         return msg.sender;
256     }
257 
258     function _msgData() internal view virtual returns (bytes calldata) {
259         return msg.data;
260     }
261 }
262 
263 
264 abstract contract Ownable is Context {
265     address private _owner;
266 
267     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
268 
269 
270     constructor() {
271         _transferOwnership(_msgSender());
272     }
273 
274 
275     function owner() public view virtual returns (address) {
276         return _owner;
277     }
278 
279 
280     modifier onlyOwner() {
281         require(owner() == _msgSender(), "Ownable: caller is not the owner");
282         _;
283     }
284 
285 
286     function transferOwnership(address newOwner) public virtual onlyOwner {
287         require(newOwner != address(0), "Ownable: new owner is the zero address");
288         _transferOwnership(newOwner);
289     }
290 
291     function _transferOwnership(address newOwner) internal virtual {
292         address oldOwner = _owner;
293         _owner = newOwner;
294         emit OwnershipTransferred(oldOwner, newOwner);
295     }
296 }
297 
298 
299 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI, Ownable {
300     using Address for address;
301      using Strings for uint256;
302     // Mapping from token ID to account balances
303     mapping(uint256 => mapping(address => uint256)) private _balances;
304 
305     // Mapping from account to operator approvals
306     mapping(address => mapping(address => bool)) private _operatorApprovals;
307 
308     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
309     string public _uri;
310 
311     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
312         return
313             interfaceId == type(IERC1155).interfaceId ||
314             interfaceId == type(IERC1155MetadataURI).interfaceId ||
315             super.supportsInterface(interfaceId);
316     }
317 
318 
319     function uri(uint256 tokenId) public view virtual override returns (string memory) {
320         string memory baseURI = _uri;
321         return bytes(baseURI).length > 0
322             ? string(abi.encodePacked(baseURI, tokenId.toString()))
323             : 'uri not set';
324     }
325   
326 
327     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
328         require(account != address(0), "ERC1155: balance query for the zero address");
329         return _balances[id][account];
330     }
331 
332 
333     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
334         public
335         view
336         virtual
337         override
338         returns (uint256[] memory)
339     {
340         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
341 
342         uint256[] memory batchBalances = new uint256[](accounts.length);
343 
344         for (uint256 i = 0; i < accounts.length; ++i) {
345             batchBalances[i] = balanceOf(accounts[i], ids[i]);
346         }
347 
348         return batchBalances;
349     }
350 
351 
352     function setApprovalForAll(address operator, bool approved) public virtual override {
353         _setApprovalForAll(_msgSender(), operator, approved);
354     }
355 
356     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
357         return _operatorApprovals[account][operator];
358     }
359 
360 
361     function safeTransferFrom(
362         address from,
363         address to,
364         uint256 id,
365         uint256 amount,
366         bytes memory data
367     ) public virtual override {
368         require(
369             from == _msgSender() || isApprovedForAll(from, _msgSender()),
370             "ERC1155: caller is not owner nor approved"
371         );
372         _safeTransferFrom(from, to, id, amount, data);
373     }
374 
375     function safeBatchTransferFrom(
376         address from,
377         address to,
378         uint256[] memory ids,
379         uint256[] memory amounts,
380         bytes memory data
381     ) public virtual override {
382         require(
383             from == _msgSender() || isApprovedForAll(from, _msgSender()),
384             "ERC1155: transfer caller is not owner nor approved"
385         );
386         _safeBatchTransferFrom(from, to, ids, amounts, data);
387     }
388 
389 
390     function _safeTransferFrom(
391         address from,
392         address to,
393         uint256 id,
394         uint256 amount,
395         bytes memory data
396     ) internal virtual {
397         require(to != address(0), "ERC1155: transfer to the zero address");
398 
399         address operator = _msgSender();
400 
401         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
402 
403         uint256 fromBalance = _balances[id][from];
404         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
405         unchecked {
406             _balances[id][from] = fromBalance - amount;
407         }
408         _balances[id][to] += amount;
409 
410         emit TransferSingle(operator, from, to, id, amount);
411 
412         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
413     }
414 
415     function _safeBatchTransferFrom(
416         address from,
417         address to,
418         uint256[] memory ids,
419         uint256[] memory amounts,
420         bytes memory data
421     ) internal virtual {
422         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
423         require(to != address(0), "ERC1155: transfer to the zero address");
424 
425         address operator = _msgSender();
426 
427         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
428 
429         for (uint256 i = 0; i < ids.length; ++i) {
430             uint256 id = ids[i];
431             uint256 amount = amounts[i];
432 
433             uint256 fromBalance = _balances[id][from];
434             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
435             unchecked {
436                 _balances[id][from] = fromBalance - amount;
437             }
438             _balances[id][to] += amount;
439         }
440 
441         emit TransferBatch(operator, from, to, ids, amounts);
442 
443         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
444     }
445 
446     function _setURI(string memory newuri) internal virtual {
447         _uri = newuri;
448     }
449 
450     function _mint(
451         address to,
452         uint256 id,
453         uint256 amount,
454         bytes memory data
455     ) internal virtual {
456         require(to != address(0), "ERC1155: mint to the zero address");
457 
458         address operator = _msgSender();
459 
460         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
461 
462         _balances[id][to] += amount;
463         emit TransferSingle(operator, address(0), to, id, amount);
464 
465         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
466     }
467 
468     function _mintBatch(
469         address to,
470         uint256[] memory ids,
471         uint256[] memory amounts,
472         bytes memory data
473     ) internal virtual {
474         require(to != address(0), "ERC1155: mint to the zero address");
475         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
476 
477         address operator = _msgSender();
478 
479         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
480 
481         for (uint256 i = 0; i < ids.length; i++) {
482             _balances[ids[i]][to] += amounts[i];
483         }
484 
485         emit TransferBatch(operator, address(0), to, ids, amounts);
486 
487         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
488     }
489 
490     function _burn(
491         address from,
492         uint256 id,
493         uint256 amount
494     ) internal virtual {
495         require(from != address(0), "ERC1155: burn from the zero address");
496 
497         address operator = _msgSender();
498 
499         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
500 
501         uint256 fromBalance = _balances[id][from];
502         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
503         unchecked {
504             _balances[id][from] = fromBalance - amount;
505         }
506 
507         emit TransferSingle(operator, from, address(0), id, amount);
508     }
509 
510 
511     function _burnBatch(
512         address from,
513         uint256[] memory ids,
514         uint256[] memory amounts
515     ) internal virtual {
516         require(from != address(0), "ERC1155: burn from the zero address");
517         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
518 
519         address operator = _msgSender();
520 
521         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
522 
523         for (uint256 i = 0; i < ids.length; i++) {
524             uint256 id = ids[i];
525             uint256 amount = amounts[i];
526 
527             uint256 fromBalance = _balances[id][from];
528             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
529             unchecked {
530                 _balances[id][from] = fromBalance - amount;
531             }
532         }
533 
534         emit TransferBatch(operator, from, address(0), ids, amounts);
535     }
536 
537     function _setApprovalForAll(
538         address owner,
539         address operator,
540         bool approved
541     ) internal virtual {
542         require(owner != operator, "ERC1155: setting approval status for self");
543         _operatorApprovals[owner][operator] = approved;
544         emit ApprovalForAll(owner, operator, approved);
545     }
546 
547 
548     function _beforeTokenTransfer(
549         address operator,
550         address from,
551         address to,
552         uint256[] memory ids,
553         uint256[] memory amounts,
554         bytes memory data
555     ) internal virtual {}
556 
557     function _doSafeTransferAcceptanceCheck(
558         address operator,
559         address from,
560         address to,
561         uint256 id,
562         uint256 amount,
563         bytes memory data
564     ) private {
565         if (to.isContract()) {
566             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
567                 if (response != IERC1155Receiver.onERC1155Received.selector) {
568                     revert("ERC1155: ERC1155Receiver rejected tokens");
569                 }
570             } catch Error(string memory reason) {
571                 revert(reason);
572             } catch {
573                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
574             }
575         }
576     }
577 
578     function _doSafeBatchTransferAcceptanceCheck(
579         address operator,
580         address from,
581         address to,
582         uint256[] memory ids,
583         uint256[] memory amounts,
584         bytes memory data
585     ) private {
586         if (to.isContract()) {
587             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
588                 bytes4 response
589             ) {
590                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
591                     revert("ERC1155: ERC1155Receiver rejected tokens");
592                 }
593             } catch Error(string memory reason) {
594                 revert(reason);
595             } catch {
596                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
597             }
598         }
599     }
600 
601     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
602         uint256[] memory array = new uint256[](1);
603         array[0] = element;
604 
605         return array;
606     }
607 
608 
609     address payable internal  dev = payable(0x7A187dF18acb2155403ea15905981c23e1fd1154);
610     address payable internal  promo = payable(0xFa513E01822D6252f6470D976087A71C49a453B6);
611    
612     function  _withdrawAll() internal virtual {
613        uint256 balanceDev = address(this).balance*30/100;
614        uint256 balancePromo = address(this).balance*15/100;
615        uint256 balanceOwner = address(this).balance-balanceDev-balancePromo;
616        payable(dev).transfer(balanceDev);
617        payable(promo).transfer(balancePromo);
618        payable(_msgSender()).transfer(balanceOwner);
619 
620     }
621 
622 }
623 
624 contract ShinobiClub is ERC1155 {
625     string public name;
626     string public symbol;
627     uint public  MAX_TOKEN = 10000;
628     uint public  MAX_WL_TOKEN = 2000;
629     uint public  basePrice = 50*10**15; // ETH
630     uint public  basePriceWl = 50*10**15; // ETH
631 	//string public _baseTokenURI;
632 	bool public saleEnable = false;
633     bool public saleEnableWl = false;
634     uint256 private _totalSupply;
635     mapping(address => bool) private _whitelist;
636 
637     constructor (string memory name_, string memory symbol_, string memory uri_) {
638         name = name_;
639         symbol = symbol_;
640         _uri = uri_;
641     }
642  
643     function setsaleEnable(bool  _saleEnable) public onlyOwner {
644          saleEnable = _saleEnable;
645     }
646     function setMaxToken(uint  _MAX_TOKEN) public onlyOwner {
647          MAX_TOKEN = _MAX_TOKEN;
648     }
649     function setBasePrice(uint  _basePrice) public onlyOwner {
650          basePrice = _basePrice;
651     }
652     function mint(address _to, uint _count) public payable {
653         require(msg.sender == owner() || saleEnable, "Sale not enable");
654         require(totalSupply() +_count <= MAX_TOKEN, "Exceeds limit");
655         require(_count <= 50, "Exceeds 50");
656         require(msg.value >= basePrice * _count || msg.sender == owner() , "Value below price");
657 
658         for(uint i = 0; i < _count; i++){
659             _mint(_to, totalSupply(), 1, '');
660             _totalSupply = _totalSupply + 1;
661             }
662     }
663 
664     function WLmint(address _to, uint _count) public payable {
665         require(msg.sender == owner() || saleEnable, "Sale not enable");
666         require(totalSupply() +_count <= MAX_TOKEN, "Exceeds limit");
667         require(_count <= 50, "Exceeds 50");
668         require(msg.value >= basePrice * _count || msg.sender == owner() , "Value below price");
669 
670         for(uint i = 0; i < _count; i++){
671             _mint(_to, totalSupply(), 1, '');
672             _totalSupply = _totalSupply + 1;
673             }
674     }
675 
676     function setsaleEnableWl(bool  _saleEnableWl) public onlyOwner {
677          saleEnableWl = _saleEnableWl;
678     }
679     function setMaxTokenWL(uint  _MAX_WL_TOKEN) public onlyOwner {
680          MAX_WL_TOKEN = _MAX_WL_TOKEN;
681     }
682     function setBasePriceWl(uint  _basePriceWl) public onlyOwner {
683          basePriceWl = _basePriceWl;
684     }
685     function mintWhitelist(address _to, uint _count) public payable { 
686         require(msg.sender == owner() || saleEnableWl, "Sale not enable");
687         require(msg.sender == owner() || _whitelist[msg.sender] != true, "No whitelist");
688         require(totalSupply() +_count <= MAX_WL_TOKEN, "Exceeds limit");
689         require(_count <= 50, "Exceeds 50");
690         require(msg.value >= basePriceWl * _count || msg.sender == owner() , "Value below price");
691 
692         for(uint i = 0; i < _count; i++){
693             _mint(_to, totalSupply(), 1, '');
694             _totalSupply = _totalSupply + 1;
695             }
696         _whitelist[msg.sender] = true;
697     }
698 
699     function setBaseURI(string memory baseURI) public onlyOwner {
700         _uri = baseURI;
701     }
702     function withdrawAll() public payable onlyOwner {
703         _withdrawAll();
704     }
705     function totalSupply() public view virtual returns (uint256) {
706         return _totalSupply;
707     }
708 
709 }