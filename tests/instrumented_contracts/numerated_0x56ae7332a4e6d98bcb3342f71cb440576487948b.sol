1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
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
534 abstract contract ReentrancyGuard {
535     
536     
537     
538     
539     
540 
541     
542     
543     
544     
545     
546     uint256 private constant _NOT_ENTERED = 1;
547     uint256 private constant _ENTERED = 2;
548 
549     uint256 private _status;
550 
551     constructor() {
552         _status = _NOT_ENTERED;
553     }
554 
555     
556     modifier nonReentrant() {
557         
558         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
559 
560         
561         _status = _ENTERED;
562 
563         _;
564 
565         
566         
567         _status = _NOT_ENTERED;
568     }
569 }
570 
571 interface Auction {
572   function transferOwnership(address newOwner) external;
573   function withdrawAll() external;
574 }
575 
576 contract FMWAuctionTicket is ERC721, ReentrancyGuard {
577 
578   struct Bid {
579     address account;
580     uint price;
581   }
582 
583   string public baseURI;
584   uint public checkpoint;
585 
586   address payable immutable public deployer;
587 
588   uint constant public firstTokenId = 5972;
589   uint constant public floorPrice = 0.15 ether;
590   Auction constant public auction = Auction(0x73a67e1B7DA8871e8dE742fb381954f61B7C0BB0);
591   bytes32 constant public rootHash = 0xa4f499a7096beab84de93438ff739d722efe89f37a4853e12a372e59a4b654ed;
592 
593   constructor(
594     string memory name_,
595     string memory symbol_,
596     string memory baseURI_
597   ) ERC721(name_, symbol_) {
598     baseURI = baseURI_;
599     deployer = payable(msg.sender);
600   }
601 
602   function totalSupply() external view returns (uint) {
603     return checkpoint;
604   }
605 
606   function _hashBids(Bid[] calldata bids) internal pure returns (bytes32 hash){
607     return keccak256(abi.encode(bids));
608   }
609 
610   function hashBids(Bid[] calldata bids) external pure returns (bytes32 hash) {
611     return _hashBids(bids);
612   }
613 
614   function mintAndRefund(
615     Bid[] calldata bids,
616     uint iterations
617   ) external payable nonReentrant {
618 
619     
620     bytes32 dataHash = _hashBids(bids);
621     require(dataHash == rootHash, "Incorrect bids array");
622 
623     uint _checkpoint = checkpoint;
624     uint bidCount = bids.length;
625     uint left = bidCount - _checkpoint;
626 
627     if (iterations > left) {
628       iterations = left;
629     }
630 
631     uint end = _checkpoint + iterations;
632     uint i;
633 
634     for (i = _checkpoint; i < end; i++) {
635 
636       
637       address payable buyer = payable(bids[i].account);
638       _safeMint(buyer, firstTokenId + i);
639 
640       
641       uint refund = bids[i].price - floorPrice;
642 
643       if (refund > 0) {
644         (bool ok,) = buyer.call{value : refund}("");
645         require(ok, "Failed to refund");
646       }
647     }
648 
649     checkpoint = i;
650 
651     if (i == bidCount) {
652       
653       auction.withdrawAll();
654       auction.transferOwnership(deployer);
655     }
656 
657     {
658       
659       uint balance = address(this).balance;
660       (bool ok,) = deployer.call{value : balance}("");
661       require(ok, "Unable to transfer to deployer");
662     }
663   }
664 
665   function returnOwnership() external {
666     require(msg.sender == deployer, 'Not deployer');
667     auction.transferOwnership(deployer);
668   }
669 
670 }