1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.8.0;
3 
4 interface IERC165 {
5     function supportsInterface(bytes4 interfaceId) external view returns (bool);
6 }
7 
8 
9 interface IERC721 is IERC165 {
10   
11     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
12 
13     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
14 
15     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
16 
17     function balanceOf(address owner) external view returns (uint256 balance);
18 
19     function ownerOf(uint256 tokenId) external view returns (address owner);
20 
21     function safeTransferFrom(
22         address from,
23         address to,
24         uint256 tokenId
25     ) external;
26 
27     function transferFrom(
28         address from,
29         address to,
30         uint256 tokenId
31     ) external;
32 
33     function approve(address to, uint256 tokenId) external;
34 
35     function getApproved(uint256 tokenId) external view returns (address operator);
36 
37     function setApprovalForAll(address operator, bool _approved) external;
38 
39     function isApprovedForAll(address owner, address operator) external view returns (bool);
40 
41     function safeTransferFrom(
42         address from,
43         address to,
44         uint256 tokenId,
45         bytes calldata data
46     ) external;
47 }
48 
49 
50 interface IERC721Receiver {
51    
52     function onERC721Received(
53         address operator,
54         address from,
55         uint256 tokenId,
56         bytes calldata data
57     ) external returns (bytes4);
58 }
59 
60 
61 interface IERC721Metadata is IERC721 {
62    
63     function name() external view returns (string memory);
64     function symbol() external view returns (string memory);
65     function tokenURI(uint256 tokenId) external view returns (string memory);
66 }
67 
68 
69 library Address {
70     function isContract(address account) internal view returns (bool) {
71         return account.code.length > 0;
72     }
73 
74     function sendValue(address payable recipient, uint256 amount) internal {
75         require(address(this).balance >= amount, "Address: insufficient balance");
76 
77         (bool success, ) = recipient.call{value: amount}("");
78         require(success, "Address: unable to send value, recipient may have reverted");
79     }
80 
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82         return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     function functionCall(
86         address target,
87         bytes memory data,
88         string memory errorMessage
89     ) internal returns (bytes memory) {
90         return functionCallWithValue(target, data, 0, errorMessage);
91     }
92 
93     function functionCallWithValue(
94         address target,
95         bytes memory data,
96         uint256 value
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
99     }
100 
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
113 
114     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
115         return functionStaticCall(target, data, "Address: low-level static call failed");
116     }
117 
118     function functionStaticCall(
119         address target,
120         bytes memory data,
121         string memory errorMessage
122     ) internal view returns (bytes memory) {
123         require(isContract(target), "Address: static call to non-contract");
124 
125         (bool success, bytes memory returndata) = target.staticcall(data);
126         return verifyCallResult(success, returndata, errorMessage);
127     }
128 
129     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
130         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
131     }
132 
133     function functionDelegateCall(
134         address target,
135         bytes memory data,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         require(isContract(target), "Address: delegate call to non-contract");
139 
140         (bool success, bytes memory returndata) = target.delegatecall(data);
141         return verifyCallResult(success, returndata, errorMessage);
142     }
143 
144     function verifyCallResult(
145         bool success,
146         bytes memory returndata,
147         string memory errorMessage
148     ) internal pure returns (bytes memory) {
149         if (success) {
150             return returndata;
151         } else {
152             if (returndata.length > 0) {
153                 assembly {
154                     let returndata_size := mload(returndata)
155                     revert(add(32, returndata), returndata_size)
156                 }
157             } else {
158                 revert(errorMessage);
159             }
160         }
161     }
162 }
163 
164 
165 abstract contract Context {
166     function _msgSender() internal view virtual returns (address) {
167         return msg.sender;
168     }
169 
170     function _msgData() internal view virtual returns (bytes calldata) {
171         return msg.data;
172     }
173 }
174 
175 
176 library Strings {
177     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
178     function toString(uint256 value) internal pure returns (string memory) {
179 
180         if (value == 0) {
181             return "0";
182         }
183         uint256 temp = value;
184         uint256 digits;
185         while (temp != 0) {
186             digits++;
187             temp /= 10;
188         }
189         bytes memory buffer = new bytes(digits);
190         while (value != 0) {
191             digits -= 1;
192             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
193             value /= 10;
194         }
195         return string(buffer);
196     }
197 
198     function toHexString(uint256 value) internal pure returns (string memory) {
199         if (value == 0) {
200             return "0x00";
201         }
202         uint256 temp = value;
203         uint256 length = 0;
204         while (temp != 0) {
205             length++;
206             temp >>= 8;
207         }
208         return toHexString(value, length);
209     }
210 
211     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
212         bytes memory buffer = new bytes(2 * length + 2);
213         buffer[0] = "0";
214         buffer[1] = "x";
215         for (uint256 i = 2 * length + 1; i > 1; --i) {
216             buffer[i] = _HEX_SYMBOLS[value & 0xf];
217             value >>= 4;
218         }
219         require(value == 0, "Strings: hex length insufficient");
220         return string(buffer);
221     }
222 }
223 
224 
225 abstract contract ERC165 is IERC165 {
226   
227     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
228         return interfaceId == type(IERC165).interfaceId;
229     }
230 }
231 
232 
233 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
234     using Address for address;
235     using Strings for uint256;
236 
237     string private _name;
238     string private _symbol;
239 
240     mapping(uint256 => address) private _owners;
241     mapping(address => uint256) private _balances;
242     mapping(uint256 => address) private _tokenApprovals;
243 
244     mapping(address => mapping(address => bool)) private _operatorApprovals;
245 
246     constructor(string memory name_, string memory symbol_) {
247         _name = name_;
248         _symbol = symbol_;
249     }
250 
251     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
252         return
253             interfaceId == type(IERC721).interfaceId ||
254             interfaceId == type(IERC721Metadata).interfaceId ||
255             super.supportsInterface(interfaceId);
256     }
257 
258     function balanceOf(address owner) public view virtual override returns (uint256) {
259         require(owner != address(0), "ERC721: balance query for the zero address");
260         return _balances[owner];
261     }
262 
263     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
264         address owner = _owners[tokenId];
265         require(owner != address(0), "ERC721: owner query for nonexistent token");
266         return owner;
267     }
268 
269     function name() public view virtual override returns (string memory) {
270         return _name;
271     }
272 
273     function symbol() public view virtual override returns (string memory) {
274         return _symbol;
275     }
276 
277     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
278         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
279 
280         string memory baseURI = _baseURI();
281         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
282     }
283 
284     function _baseURI() internal view virtual returns (string memory) {
285         return "";
286     }
287 
288     function approve(address to, uint256 tokenId) public virtual override {
289         address owner = ERC721.ownerOf(tokenId);
290         require(to != owner, "ERC721: approval to current owner");
291 
292         require(
293             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
294             "ERC721: approve caller is not owner nor approved for all"
295         );
296 
297         _approve(to, tokenId);
298     }
299 
300     function getApproved(uint256 tokenId) public view virtual override returns (address) {
301         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
302 
303         return _tokenApprovals[tokenId];
304     }
305 
306     function setApprovalForAll(address operator, bool approved) public virtual override {
307         _setApprovalForAll(_msgSender(), operator, approved);
308     }
309 
310     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
311         return _operatorApprovals[owner][operator];
312     }
313 
314     function transferFrom(
315         address from,
316         address to,
317         uint256 tokenId
318     ) public virtual override {
319         //solhint-disable-next-line max-line-length
320         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
321 
322         _transfer(from, to, tokenId);
323     }
324 
325     function safeTransferFrom(
326         address from,
327         address to,
328         uint256 tokenId
329     ) public virtual override {
330         safeTransferFrom(from, to, tokenId, "");
331     }
332 
333     function safeTransferFrom(
334         address from,
335         address to,
336         uint256 tokenId,
337         bytes memory _data
338     ) public virtual override {
339         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
340         _safeTransfer(from, to, tokenId, _data);
341     }
342 
343     function _safeTransfer(
344         address from,
345         address to,
346         uint256 tokenId,
347         bytes memory _data
348     ) internal virtual {
349         _transfer(from, to, tokenId);
350         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
351     }
352 
353     function _exists(uint256 tokenId) internal view virtual returns (bool) {
354         return _owners[tokenId] != address(0);
355     }
356 
357     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
358         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
359         address owner = ERC721.ownerOf(tokenId);
360         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
361     }
362 
363     function _safeMint(address to, uint256 tokenId) internal virtual {
364         _safeMint(to, tokenId, "");
365     }
366 
367     function _safeMint(
368         address to,
369         uint256 tokenId,
370         bytes memory _data
371     ) internal virtual {
372         _mint(to, tokenId);
373         require(
374             _checkOnERC721Received(address(0), to, tokenId, _data),
375             "ERC721: transfer to non ERC721Receiver implementer"
376         );
377     }
378 
379     function _mint(address to, uint256 tokenId) internal virtual {
380         require(to != address(0), "ERC721: mint to the zero address");
381         require(!_exists(tokenId), "ERC721: token already minted");
382 
383         _beforeTokenTransfer(address(0), to, tokenId);
384 
385         _balances[to] += 1;
386         _owners[tokenId] = to;
387 
388         emit Transfer(address(0), to, tokenId);
389 
390         _afterTokenTransfer(address(0), to, tokenId);
391     }
392 
393     function _burn(uint256 tokenId) internal virtual {
394         address owner = ERC721.ownerOf(tokenId);
395 
396         _beforeTokenTransfer(owner, address(0), tokenId);
397 
398         // Clear approvals
399         _approve(address(0), tokenId);
400 
401         _balances[owner] -= 1;
402         delete _owners[tokenId];
403 
404         emit Transfer(owner, address(0), tokenId);
405 
406         _afterTokenTransfer(owner, address(0), tokenId);
407     }
408 
409     function _transfer(
410         address from,
411         address to,
412         uint256 tokenId
413     ) internal virtual {
414         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
415         require(to != address(0), "ERC721: transfer to the zero address");
416 
417         _beforeTokenTransfer(from, to, tokenId);
418 
419         // Clear approvals from the previous owner
420         _approve(address(0), tokenId);
421 
422         _balances[from] -= 1;
423         _balances[to] += 1;
424         _owners[tokenId] = to;
425 
426         emit Transfer(from, to, tokenId);
427 
428         _afterTokenTransfer(from, to, tokenId);
429     }
430 
431     function _approve(address to, uint256 tokenId) internal virtual {
432         _tokenApprovals[tokenId] = to;
433         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
434     }
435 
436     function _setApprovalForAll(
437         address owner,
438         address operator,
439         bool approved
440     ) internal virtual {
441         require(owner != operator, "ERC721: approve to caller");
442         _operatorApprovals[owner][operator] = approved;
443         emit ApprovalForAll(owner, operator, approved);
444     }
445 
446     function _checkOnERC721Received(
447         address from,
448         address to,
449         uint256 tokenId,
450         bytes memory _data
451     ) private returns (bool) {
452         if (to.isContract()) {
453             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
454                 return retval == IERC721Receiver.onERC721Received.selector;
455             } catch (bytes memory reason) {
456                 if (reason.length == 0) {
457                     revert("ERC721: transfer to non ERC721Receiver implementer");
458                 } else {
459                     assembly {
460                         revert(add(32, reason), mload(reason))
461                     }
462                 }
463             }
464         } else {
465             return true;
466         }
467     }
468 
469     function _beforeTokenTransfer(
470         address from,
471         address to,
472         uint256 tokenId
473     ) internal virtual {}
474 
475     function _afterTokenTransfer(
476         address from,
477         address to,
478         uint256 tokenId
479     ) internal virtual {}
480 }
481 
482 
483 library Counters {
484     struct Counter {
485         
486         uint256 _value; // default: 0
487     }
488 
489     function current(Counter storage counter) internal view returns (uint256) {
490         return counter._value;
491     }
492 
493     function increment(Counter storage counter) internal {
494         unchecked {
495             counter._value += 1;
496         }
497     }
498 
499     function decrement(Counter storage counter) internal {
500         uint256 value = counter._value;
501         require(value > 0, "Counter: decrement overflow");
502         unchecked {
503             counter._value = value - 1;
504         }
505     }
506 
507     function reset(Counter storage counter) internal {
508         counter._value = 0;
509     }
510 }
511 
512 
513 abstract contract Ownable is Context {
514     address private _owner;
515 
516     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
517 
518     constructor() {
519         _transferOwnership(_msgSender());
520     }
521 
522     function owner() public view virtual returns (address) {
523         return _owner;
524     }
525 
526     modifier onlyOwner() {
527         require(owner() == _msgSender(), "Ownable: caller is not the owner");
528         _;
529     }
530 
531     function renounceOwnership() public virtual onlyOwner {
532         _transferOwnership(address(0));
533     }
534 
535     function transferOwnership(address newOwner) public virtual onlyOwner {
536         require(newOwner != address(0), "Ownable: new owner is the zero address");
537         _transferOwnership(newOwner);
538     }
539 
540   
541     function _transferOwnership(address newOwner) internal virtual {
542         address oldOwner = _owner;
543         _owner = newOwner;
544         emit OwnershipTransferred(oldOwner, newOwner);
545     }
546 }
547 
548 
549 interface ICryptoWolvesClub {
550     function ownerOf(uint256 _id) external returns(address);
551 }
552 
553 
554 contract CompanionWolfClub is ERC721, Ownable {
555 
556     using Counters for Counters.Counter;
557     Counters.Counter private _tokenIds;
558 
559     string public baseURI = "ipfs://QmfGfvKkRTbpnT8qSDEx23vK13mmsxFUxey2y84Q4TYyMZ/";
560     uint256 public maxToMint = 10000;
561     uint256 public tokenPrice = 0.05 ether;
562     address public founderWallet = 0x445bBe77B3c1bEd42711F716c7c5df4771956376;
563     address public marketingWallet = 0xC5621863419417493686D02006c118aCaaa29bcb;
564     address public devWallet = 0xF5091b9231d3b605F637E3dDcfb92fCc71Df0982;
565 
566     bool public isPaused  = true;
567     mapping(uint256=>bool) public isCryptoWolvesClubUsed;
568 
569     ICryptoWolvesClub public cryptoWolvesClub = ICryptoWolvesClub(0xAb83789d3f152118ebb5AA63190174AE0A6E0e6E);
570 
571     constructor() ERC721("CompanionWolfClub", "CoWC")  {
572          internalMint(_msgSender());
573     }
574 
575     function mint(uint256 _amount) external payable  {
576                 require(!isPaused, "mint: contract paused currently.");
577                 require(_amount > 0, "mint: amount must be positif");
578                 require(msg.value >= _amount * tokenPrice, "mint: value not enough");
579                 for(uint256 i = 0; i < _amount; i++){
580                     internalMint(_msgSender());
581                 }
582     }
583 
584     function mintWithWolf(uint256[] memory _ids) external {
585         require(!isPaused, "mint: contract paused currently.");
586         require(_tokenIds.current() + _ids.length <= maxToMint, "mint: too much token to mint");
587         require(address(cryptoWolvesClub) != address(0), "mint: please set cryptoWolvesClub address");
588         for(uint256 i = 0; i < _ids.length; i++){
589             require(!isCryptoWolvesClubUsed[_ids[i]], "mint: cryptoWolvesClub id already minted");
590             require(cryptoWolvesClub.ownerOf(_ids[i]) == _msgSender(), "mint: you must be the owner of the nft currently");
591             internalMint(_msgSender());
592             isCryptoWolvesClubUsed[_ids[i]] = true;
593         }
594     }
595 
596     function _baseURI() internal view override returns (string memory) {
597         return baseURI;
598     }
599     
600     function exists(uint256 _tokenId) external view returns(bool){
601         return _exists(_tokenId);
602     }
603 
604     function internalMint(address _address) private {
605         _mint(_address, _tokenIds.current());
606         _tokenIds.increment();
607     }
608 
609     function mintOwner(uint256 _amount) external onlyOwner  {
610         require(_amount > 0, "mint: amount must be positif");
611         for(uint256 i = 0; i < _amount; i++){
612             internalMint(_msgSender());
613         }
614     }
615 
616     function setTokenPrice(uint256 _tokenPrice) external onlyOwner {
617         tokenPrice = _tokenPrice;
618     }
619     
620     function setCryptoWolvesClub(address _cryptoWolvesClub) external onlyOwner {
621         cryptoWolvesClub = ICryptoWolvesClub(_cryptoWolvesClub);
622     }
623 
624     function setBaseURI(string memory baseURI_) external onlyOwner {
625         baseURI = baseURI_;
626     }
627 
628     function setPause(bool _isPaused) external onlyOwner {
629         isPaused = _isPaused; 
630     }
631 
632     function setMarketingWallet(address _marketingWallet) external onlyOwner {
633         marketingWallet = _marketingWallet;
634     }
635 
636     function setFounderWallet(address _founderWallet) external onlyOwner {
637         founderWallet = _founderWallet;
638     }
639 
640     function setDevWallet(address _devWallet) external onlyOwner {
641         devWallet = _devWallet;
642     }
643 
644     function withdraw(uint256 _ethAmount, bool _withdrawAll) external onlyOwner returns(bool){
645         uint256 ethBalance = address(this).balance;
646         uint256 ethAmount;
647         if(_withdrawAll){
648             ethAmount = ethBalance;
649         } else {
650             ethAmount = _ethAmount;
651         }
652         require(ethAmount <= ethBalance, "withdraw: eth balance must be larger than amount.");
653         uint256 ethAmountMarketing = uint256(uint256(ethAmount * 30) / 100);
654         uint256 ethAmountFounder = uint256(uint256(ethAmount * 40) / 100);
655         uint256 ethAmountDev = uint256(ethAmount - ethAmountMarketing) - ethAmountFounder;
656         (bool successMarketing,) = payable(marketingWallet).call{value: ethAmountMarketing}(new bytes(0));
657         (bool successFounder,) = payable(founderWallet).call{value: ethAmountFounder}(new bytes(0));
658         (bool successDev,) = payable(devWallet).call{value: ethAmountDev}(new bytes(0));
659         require(successMarketing && successFounder && successDev, "withdraw: transfer error.");
660         return true;
661     }
662 }