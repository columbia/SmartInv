1 // SPDX-License-Identifier: MIT
2 /**
3  * @title TrollTownElixir
4  * @author AhmYieTrollElixir
5  * @dev Used for Ethereum projects compatible with OpenSea
6  */
7 
8 pragma solidity ^0.8.0;
9 interface IERC165 {
10     function supportsInterface(bytes4 interfaceId) external view returns (bool);
11 }
12 
13 pragma solidity ^0.8.0;
14 interface IERC1155 is IERC165 {
15     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
16     event TransferBatch(
17         address indexed operator,
18         address indexed from,
19         address indexed to,
20         uint256[] ids,
21         uint256[] values
22     );
23     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
24     event URI(string value, uint256 indexed id);
25     function balanceOf(address account, uint256 id) external view returns (uint256);
26     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
27         external
28         view
29         returns (uint256[] memory);
30     function setApprovalForAll(address operator, bool approved) external;
31     function isApprovedForAll(address account, address operator) external view returns (bool);
32     function safeTransferFrom(
33         address from,
34         address to,
35         uint256 id,
36         uint256 amount,
37         bytes calldata data
38     ) external;
39     function safeBatchTransferFrom(
40         address from,
41         address to,
42         uint256[] calldata ids,
43         uint256[] calldata amounts,
44         bytes calldata data
45     ) external;
46 }
47 
48 pragma solidity ^0.8.0;
49 interface IERC1155Receiver is IERC165 {
50     function onERC1155Received(
51         address operator,
52         address from,
53         uint256 id,
54         uint256 value,
55         bytes calldata data
56     ) external returns (bytes4);
57     function onERC1155BatchReceived(
58         address operator,
59         address from,
60         uint256[] calldata ids,
61         uint256[] calldata values,
62         bytes calldata data
63     ) external returns (bytes4);
64 }
65 
66 pragma solidity ^0.8.0;
67 interface IERC1155MetadataURI is IERC1155 {
68     function uri(uint256 id) external view returns (string memory);
69 }
70 
71 pragma solidity ^0.8.1;
72 library Address {
73     function isContract(address account) internal view returns (bool) {
74         // for contracts in construction, since the code is only stored at the end
75 
76         return account.code.length > 0;
77     }
78     function sendValue(address payable recipient, uint256 amount) internal {
79         require(address(this).balance >= amount, "Address: insufficient balance");
80 
81         (bool success, ) = recipient.call{value: amount}("");
82         require(success, "Address: unable to send value, recipient may have reverted");
83     }
84     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
85         return functionCall(target, data, "Address: low-level call failed");
86     }
87     function functionCall(
88         address target,
89         bytes memory data,
90         string memory errorMessage
91     ) internal returns (bytes memory) {
92         return functionCallWithValue(target, data, 0, errorMessage);
93     }
94     function functionCallWithValue(
95         address target,
96         bytes memory data,
97         uint256 value
98     ) internal returns (bytes memory) {
99         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
100     }
101     function functionCallWithValue(
102         address target,
103         bytes memory data,
104         uint256 value,
105         string memory errorMessage
106     ) internal returns (bytes memory) {
107         require(address(this).balance >= value, "Address: insufficient balance for call");
108         require(isContract(target), "Address: call to non-contract");
109 
110         (bool success, bytes memory returndata) = target.call{value: value}(data);
111         return verifyCallResult(success, returndata, errorMessage);
112     }
113     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
114         return functionStaticCall(target, data, "Address: low-level static call failed");
115     }
116     function functionStaticCall(
117         address target,
118         bytes memory data,
119         string memory errorMessage
120     ) internal view returns (bytes memory) {
121         require(isContract(target), "Address: static call to non-contract");
122 
123         (bool success, bytes memory returndata) = target.staticcall(data);
124         return verifyCallResult(success, returndata, errorMessage);
125     }
126     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
127         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
128     }
129     function functionDelegateCall(
130         address target,
131         bytes memory data,
132         string memory errorMessage
133     ) internal returns (bytes memory) {
134         require(isContract(target), "Address: delegate call to non-contract");
135 
136         (bool success, bytes memory returndata) = target.delegatecall(data);
137         return verifyCallResult(success, returndata, errorMessage);
138     }
139     function verifyCallResult(
140         bool success,
141         bytes memory returndata,
142         string memory errorMessage
143     ) internal pure returns (bytes memory) {
144         if (success) {
145             return returndata;
146         } else {
147             if (returndata.length > 0) {
148 
149                 assembly {
150                     let returndata_size := mload(returndata)
151                     revert(add(32, returndata), returndata_size)
152                 }
153             } else {
154                 revert(errorMessage);
155             }
156         }
157     }
158 }
159 
160 pragma solidity ^0.8.0;
161 abstract contract Context {
162     function _msgSender() internal view virtual returns (address) {
163         return msg.sender;
164     }
165 
166     function _msgData() internal view virtual returns (bytes calldata) {
167         return msg.data;
168     }
169 }
170 
171 pragma solidity ^0.8.0;
172 abstract contract ERC165 is IERC165 {
173     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
174         return interfaceId == type(IERC165).interfaceId;
175     }
176 }
177 
178 pragma solidity ^0.8.0;
179 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
180     using Address for address;
181     mapping(uint256 => mapping(address => uint256)) private _balances;
182     mapping(address => mapping(address => bool)) private _operatorApprovals;
183     string private _uri;
184     constructor(string memory uri_) {
185         _setURI(uri_);
186     }
187     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
188         return
189             interfaceId == type(IERC1155).interfaceId ||
190             interfaceId == type(IERC1155MetadataURI).interfaceId ||
191             super.supportsInterface(interfaceId);
192     }
193     function uri(uint256) public view virtual override returns (string memory) {
194         return _uri;
195     }
196     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
197         require(account != address(0), "ERC1155: balance query for the zero address");
198         return _balances[id][account];
199     }
200     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
201         public
202         view
203         virtual
204         override
205         returns (uint256[] memory)
206     {
207         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
208 
209         uint256[] memory batchBalances = new uint256[](accounts.length);
210 
211         for (uint256 i = 0; i < accounts.length; ++i) {
212             batchBalances[i] = balanceOf(accounts[i], ids[i]);
213         }
214 
215         return batchBalances;
216     }
217     function setApprovalForAll(address operator, bool approved) public virtual override {
218         _setApprovalForAll(_msgSender(), operator, approved);
219     }
220     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
221         return _operatorApprovals[account][operator];
222     }
223     function safeTransferFrom(
224         address from,
225         address to,
226         uint256 id,
227         uint256 amount,
228         bytes memory data
229     ) public virtual override {
230         require(
231             from == _msgSender() || isApprovedForAll(from, _msgSender()),
232             "ERC1155: caller is not owner nor approved"
233         );
234         _safeTransferFrom(from, to, id, amount, data);
235     }
236     function safeBatchTransferFrom(
237         address from,
238         address to,
239         uint256[] memory ids,
240         uint256[] memory amounts,
241         bytes memory data
242     ) public virtual override {
243         require(
244             from == _msgSender() || isApprovedForAll(from, _msgSender()),
245             "ERC1155: transfer caller is not owner nor approved"
246         );
247         _safeBatchTransferFrom(from, to, ids, amounts, data);
248     }
249     function _safeTransferFrom(
250         address from,
251         address to,
252         uint256 id,
253         uint256 amount,
254         bytes memory data
255     ) internal virtual {
256         require(to != address(0), "ERC1155: transfer to the zero address");
257 
258         address operator = _msgSender();
259 
260         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
261 
262         uint256 fromBalance = _balances[id][from];
263         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
264         unchecked {
265             _balances[id][from] = fromBalance - amount;
266         }
267         _balances[id][to] += amount;
268 
269         emit TransferSingle(operator, from, to, id, amount);
270 
271         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
272     }
273     function _safeBatchTransferFrom(
274         address from,
275         address to,
276         uint256[] memory ids,
277         uint256[] memory amounts,
278         bytes memory data
279     ) internal virtual {
280         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
281         require(to != address(0), "ERC1155: transfer to the zero address");
282 
283         address operator = _msgSender();
284 
285         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
286 
287         for (uint256 i = 0; i < ids.length; ++i) {
288             uint256 id = ids[i];
289             uint256 amount = amounts[i];
290 
291             uint256 fromBalance = _balances[id][from];
292             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
293             unchecked {
294                 _balances[id][from] = fromBalance - amount;
295             }
296             _balances[id][to] += amount;
297         }
298 
299         emit TransferBatch(operator, from, to, ids, amounts);
300 
301         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
302     }
303     function _setURI(string memory newuri) internal virtual {
304         _uri = newuri;
305     }
306     function _mint(
307         address to,
308         uint256 id,
309         uint256 amount,
310         bytes memory data
311     ) internal virtual {
312         require(to != address(0), "ERC1155: mint to the zero address");
313 
314         address operator = _msgSender();
315 
316         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
317 
318         _balances[id][to] += amount;
319         emit TransferSingle(operator, address(0), to, id, amount);
320 
321         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
322     }
323     function _mintBatch(
324         address to,
325         uint256[] memory ids,
326         uint256[] memory amounts,
327         bytes memory data
328     ) internal virtual {
329         require(to != address(0), "ERC1155: mint to the zero address");
330         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
331 
332         address operator = _msgSender();
333 
334         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
335 
336         for (uint256 i = 0; i < ids.length; i++) {
337             _balances[ids[i]][to] += amounts[i];
338         }
339 
340         emit TransferBatch(operator, address(0), to, ids, amounts);
341 
342         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
343     }
344     function _burn(
345         address from,
346         uint256 id,
347         uint256 amount
348     ) internal virtual {
349         require(from != address(0), "ERC1155: burn from the zero address");
350 
351         address operator = _msgSender();
352 
353         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
354 
355         uint256 fromBalance = _balances[id][from];
356         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
357         unchecked {
358             _balances[id][from] = fromBalance - amount;
359         }
360 
361         emit TransferSingle(operator, from, address(0), id, amount);
362     }
363     function _burnBatch(
364         address from,
365         uint256[] memory ids,
366         uint256[] memory amounts
367     ) internal virtual {
368         require(from != address(0), "ERC1155: burn from the zero address");
369         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
370 
371         address operator = _msgSender();
372 
373         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
374 
375         for (uint256 i = 0; i < ids.length; i++) {
376             uint256 id = ids[i];
377             uint256 amount = amounts[i];
378 
379             uint256 fromBalance = _balances[id][from];
380             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
381             unchecked {
382                 _balances[id][from] = fromBalance - amount;
383             }
384         }
385 
386         emit TransferBatch(operator, from, address(0), ids, amounts);
387     }
388     function _setApprovalForAll(
389         address owner,
390         address operator,
391         bool approved
392     ) internal virtual {
393         require(owner != operator, "ERC1155: setting approval status for self");
394         _operatorApprovals[owner][operator] = approved;
395         emit ApprovalForAll(owner, operator, approved);
396     }
397     function _beforeTokenTransfer(
398         address operator,
399         address from,
400         address to,
401         uint256[] memory ids,
402         uint256[] memory amounts,
403         bytes memory data
404     ) internal virtual {}
405 
406     function _doSafeTransferAcceptanceCheck(
407         address operator,
408         address from,
409         address to,
410         uint256 id,
411         uint256 amount,
412         bytes memory data
413     ) private {
414         if (to.isContract()) {
415             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
416                 if (response != IERC1155Receiver.onERC1155Received.selector) {
417                     revert("ERC1155: ERC1155Receiver rejected tokens");
418                 }
419             } catch Error(string memory reason) {
420                 revert(reason);
421             } catch {
422                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
423             }
424         }
425     }
426 
427     function _doSafeBatchTransferAcceptanceCheck(
428         address operator,
429         address from,
430         address to,
431         uint256[] memory ids,
432         uint256[] memory amounts,
433         bytes memory data
434     ) private {
435         if (to.isContract()) {
436             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
437                 bytes4 response
438             ) {
439                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
440                     revert("ERC1155: ERC1155Receiver rejected tokens");
441                 }
442             } catch Error(string memory reason) {
443                 revert(reason);
444             } catch {
445                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
446             }
447         }
448     }
449 
450     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
451         uint256[] memory array = new uint256[](1);
452         array[0] = element;
453 
454         return array;
455     }
456 }
457 
458 pragma solidity ^0.8.0;
459 abstract contract ERC1155Supply is ERC1155 {
460     mapping(uint256 => uint256) private _totalSupply;
461     function totalSupply(uint256 id) public view virtual returns (uint256) {
462         return _totalSupply[id];
463     }
464     function exists(uint256 id) public view virtual returns (bool) {
465         return ERC1155Supply.totalSupply(id) > 0;
466     }
467     function _beforeTokenTransfer(
468         address operator,
469         address from,
470         address to,
471         uint256[] memory ids,
472         uint256[] memory amounts,
473         bytes memory data
474     ) internal virtual override {
475         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
476 
477         if (from == address(0)) {
478             for (uint256 i = 0; i < ids.length; ++i) {
479                 _totalSupply[ids[i]] += amounts[i];
480             }
481         }
482 
483         if (to == address(0)) {
484             for (uint256 i = 0; i < ids.length; ++i) {
485                 _totalSupply[ids[i]] -= amounts[i];
486             }
487         }
488     }
489 }
490 
491 pragma solidity ^0.8.0;
492 abstract contract Ownable is Context {
493     address private _owner;
494 
495     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
496     constructor() {
497         _transferOwnership(_msgSender());
498     }
499     function owner() public view virtual returns (address) {
500         return _owner;
501     }
502     modifier onlyOwner() {
503         require(owner() == _msgSender(), "Ownable: caller is not the owner");
504         _;
505     }
506     function renounceOwnership() public virtual onlyOwner {
507         _transferOwnership(address(0));
508     }
509     function transferOwnership(address newOwner) public virtual onlyOwner {
510         require(newOwner != address(0), "Ownable: new owner is the zero address");
511         _transferOwnership(newOwner);
512     }
513     function _transferOwnership(address newOwner) internal virtual {
514         address oldOwner = _owner;
515         _owner = newOwner;
516         emit OwnershipTransferred(oldOwner, newOwner);
517     }
518 }
519 
520 pragma solidity ^0.8.0;
521 library Strings {
522     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
523     function toString(uint256 value) internal pure returns (string memory) {
524         if (value == 0) {
525             return "0";
526         }
527         uint256 temp = value;
528         uint256 digits;
529         while (temp != 0) {
530             digits++;
531             temp /= 10;
532         }
533         bytes memory buffer = new bytes(digits);
534         while (value != 0) {
535             digits -= 1;
536             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
537             value /= 10;
538         }
539         return string(buffer);
540     }
541     function toHexString(uint256 value) internal pure returns (string memory) {
542         if (value == 0) {
543             return "0x00";
544         }
545         uint256 temp = value;
546         uint256 length = 0;
547         while (temp != 0) {
548             length++;
549             temp >>= 8;
550         }
551         return toHexString(value, length);
552     }
553     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
554         bytes memory buffer = new bytes(2 * length + 2);
555         buffer[0] = "0";
556         buffer[1] = "x";
557         for (uint256 i = 2 * length + 1; i > 1; --i) {
558             buffer[i] = _HEX_SYMBOLS[value & 0xf];
559             value >>= 4;
560         }
561         require(value == 0, "Strings: hex length insufficient");
562         return string(buffer);
563     }
564 }
565 
566 pragma solidity ^0.8.0;
567 abstract contract TrollTown {
568     function balanceOf(address account) public view virtual returns (uint256);
569     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256);
570 }
571 
572 contract TrollTownElixir is ERC1155, Ownable {
573 
574     using Strings for uint256;
575     string  public name;
576     string  public symbol;
577     TrollTown public trolltown;
578     bool public claim = false;
579     bool public makeElixir = false;
580     address public mutationContract;
581     string private baseURI;
582     mapping(address => bool) public isClaimed;
583     mapping(uint256 => bool) public validElixirTypes;
584 
585     bytes32 public merkleRoots;
586 
587     constructor(
588         string memory _name,
589         string memory _symbol,
590         string memory _baseURI, 
591         address _trollAddress,
592         address _mutationContract
593         ) ERC1155(_baseURI) {
594         baseURI = _baseURI;
595         name = _name;
596         symbol = _symbol;
597         validElixirTypes[0] = true;
598         validElixirTypes[1] = true;
599         trolltown = TrollTown(_trollAddress);
600         mutationContract = _mutationContract;
601     }
602 
603     function uri(uint256 typeId) public view override returns (string memory) {
604         require(validElixirTypes[typeId], "URI requested for invalid serum type");
605         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, typeId.toString())) : baseURI;
606     }
607 
608     function _leafFromAddressAndNumTokens(address _a, uint256 _n) private pure returns (bytes32){
609         return keccak256(abi.encodePacked(_a, _n));
610     }
611     
612     function _checkProof(bytes32[] calldata proof, bytes32 _hash) private view returns (bool) {
613         bytes32 el;
614         bytes32 h = _hash;
615         for (uint256 i = 0; i < proof.length; i += 1) {
616             el = proof[i];
617             if (h < el) {
618                 h = keccak256(abi.encodePacked(h, el));
619             } else {
620                 h = keccak256(abi.encodePacked(el, h));
621             }
622         }
623         return h == merkleRoots;
624     }
625 
626     function claimDrop(bytes32[] calldata _proof, uint256 _quantity) external {
627         uint256 currentBal = trolltown.balanceOf(msg.sender);
628         require(claim, "AIRDROP_NOT_YET_STARTED");
629         require(isClaimed[msg.sender] != true, "CLAIMED_ALREADY");
630         require(_quantity > 0, "INVALID_QUANTITY");
631         require(_checkProof(_proof, _leafFromAddressAndNumTokens(msg.sender, _quantity)), "WRONG_PROOF");
632         isClaimed[msg.sender] = true;
633         if(currentBal >= _quantity){
634             _mint(msg.sender, 0, _quantity, "");
635         }else if(_quantity >= currentBal){
636             _mint(msg.sender, 0, currentBal, "");
637         }else{
638             revert("NO_SWEEPING!");
639         }
640     }
641 
642     function makeSuperElixir(uint256 _quantity) external {
643         require(makeElixir, "NOT_YET_STARTED");
644         require(_quantity == 3, "THREE_TIER_1_REQUIRED_TO_MAKE_SUPER_ELIXIR");
645         require(balanceOf(msg.sender, 0) >= 3, "YOU_DONT_HAVE_ENOUGH_ELIXIRS");
646         _burn(msg.sender, 0, 3);
647         _mint(msg.sender, 1, 1, "");
648     }
649 
650     function burnElixirForAddress(uint256 typeId, address burnTokenAddress) external {
651         require(msg.sender == mutationContract, "Invalid burner address");
652         _burn(burnTokenAddress, typeId, 1);
653     }
654 
655     function ownerMint(address _address, uint256 quantity, uint256 typeId) external onlyOwner {
656         _mint(_address, typeId, quantity, "");
657     }
658 
659     function ownerBurn(address _address, uint256 quantity, uint256 typeId) external onlyOwner {
660         _burn(_address, typeId, quantity);
661     }
662 
663     function setAirdropRoot(bytes32 _merkleRoot) external onlyOwner {
664         merkleRoots = _merkleRoot;
665     }
666 
667     function updateBaseUri(string memory _baseURI) external onlyOwner {
668         baseURI = _baseURI;
669     }
670 
671     function flipClaim() external onlyOwner {
672         claim = !claim;
673     }
674 
675     function flipMakeElixir() external onlyOwner {
676         makeElixir = !makeElixir;
677     }
678 
679     function setMutationContract(address mutationContractAddress) external onlyOwner {
680         mutationContract = mutationContractAddress;
681     }
682 
683     function setTrollTownContract(address trolltownContractAddress) external onlyOwner {
684         trolltown = TrollTown(trolltownContractAddress);
685     }
686 
687     function withdraw() external onlyOwner {
688         payable(msg.sender).transfer(address(this).balance);
689     }
690 }