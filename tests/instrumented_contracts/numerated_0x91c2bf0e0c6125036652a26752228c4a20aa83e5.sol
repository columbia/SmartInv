1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11 
12     function toString(uint256 value) internal pure returns (string memory) {
13 
14         if (value == 0) {
15             return "0";
16         }
17         uint256 temp = value;
18         uint256 digits;
19         while (temp != 0) {
20             digits++;
21             temp /= 10;
22         }
23         bytes memory buffer = new bytes(digits);
24         while (value != 0) {
25             digits -= 1;
26             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
27             value /= 10;
28         }
29         return string(buffer);
30     }
31 
32     function toHexString(uint256 value) internal pure returns (string memory) {
33         if (value == 0) {
34             return "0x00";
35         }
36         uint256 temp = value;
37         uint256 length = 0;
38         while (temp != 0) {
39             length++;
40             temp >>= 8;
41         }
42         return toHexString(value, length);
43     }
44 
45 
46     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
47         bytes memory buffer = new bytes(2 * length + 2);
48         buffer[0] = "0";
49         buffer[1] = "x";
50         for (uint256 i = 2 * length + 1; i > 1; --i) {
51             buffer[i] = _HEX_SYMBOLS[value & 0xf];
52             value >>= 4;
53         }
54         require(value == 0, "Strings: hex length insufficient");
55         return string(buffer);
56     }
57 }
58 
59 // File: @openzeppelin/contracts/utils/Context.sol
60 
61 
62 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
63 
64 pragma solidity ^0.8.0;
65 
66 
67 abstract contract Context {
68     function _msgSender() internal view virtual returns (address) {
69         return msg.sender;
70     }
71 
72     function _msgData() internal view virtual returns (bytes calldata) {
73         return msg.data;
74     }
75 }
76 
77 // File: @openzeppelin/contracts/access/Ownable.sol
78 
79 
80 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
81 
82 pragma solidity ^0.8.0;
83 
84 
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     constructor() {
91         _transferOwnership(_msgSender());
92     }
93 
94  
95     function owner() public view virtual returns (address) {
96         return _owner;
97     }
98 
99 
100     modifier onlyOwner() {
101         require(owner() == _msgSender(), "Ownable: caller is not the owner");
102         _;
103     }
104 
105 
106     function renounceOwnership() public virtual onlyOwner {
107         _transferOwnership(address(0));
108     }
109 
110 
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         _transferOwnership(newOwner);
114     }
115 
116 
117     function _transferOwnership(address newOwner) internal virtual {
118         address oldOwner = _owner;
119         _owner = newOwner;
120         emit OwnershipTransferred(oldOwner, newOwner);
121     }
122 }
123 
124 // File: @openzeppelin/contracts/utils/Address.sol
125 
126 
127 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 
132 library Address {
133  
134     function isContract(address account) internal view returns (bool) {
135 
136 
137         uint256 size;
138         assembly {
139             size := extcodesize(account)
140         }
141         return size > 0;
142     }
143 
144 
145     function sendValue(address payable recipient, uint256 amount) internal {
146         require(address(this).balance >= amount, "Address: insufficient balance");
147 
148         (bool success, ) = recipient.call{value: amount}("");
149         require(success, "Address: unable to send value, recipient may have reverted");
150     }
151 
152 
153     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
154         return functionCall(target, data, "Address: low-level call failed");
155     }
156 
157 
158     function functionCall(
159         address target,
160         bytes memory data,
161         string memory errorMessage
162     ) internal returns (bytes memory) {
163         return functionCallWithValue(target, data, 0, errorMessage);
164     }
165 
166     function functionCallWithValue(
167         address target,
168         bytes memory data,
169         uint256 value
170     ) internal returns (bytes memory) {
171         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
172     }
173 
174     function functionCallWithValue(
175         address target,
176         bytes memory data,
177         uint256 value,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         require(address(this).balance >= value, "Address: insufficient balance for call");
181         require(isContract(target), "Address: call to non-contract");
182 
183         (bool success, bytes memory returndata) = target.call{value: value}(data);
184         return verifyCallResult(success, returndata, errorMessage);
185     }
186 
187 
188     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
189         return functionStaticCall(target, data, "Address: low-level static call failed");
190     }
191 
192     function functionStaticCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal view returns (bytes memory) {
197         require(isContract(target), "Address: static call to non-contract");
198 
199         (bool success, bytes memory returndata) = target.staticcall(data);
200         return verifyCallResult(success, returndata, errorMessage);
201     }
202 
203 
204     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
205         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
206     }
207 
208 
209     function functionDelegateCall(
210         address target,
211         bytes memory data,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(isContract(target), "Address: delegate call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.delegatecall(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220 
221     function verifyCallResult(
222         bool success,
223         bytes memory returndata,
224         string memory errorMessage
225     ) internal pure returns (bytes memory) {
226         if (success) {
227             return returndata;
228         } else {
229             if (returndata.length > 0) {
230 
231                 assembly {
232                     let returndata_size := mload(returndata)
233                     revert(add(32, returndata), returndata_size)
234                 }
235             } else {
236                 revert(errorMessage);
237             }
238         }
239     }
240 }
241 
242 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
243 
244 
245 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 interface IERC721Receiver {
250 
251     function onERC721Received(
252         address operator,
253         address from,
254         uint256 tokenId,
255         bytes calldata data
256     ) external returns (bytes4);
257 }
258 
259 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
260 
261 
262 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 
267 interface IERC165 {
268 
269     function supportsInterface(bytes4 interfaceId) external view returns (bool);
270 }
271 
272 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
273 
274 
275 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 
280 abstract contract ERC165 is IERC165 {
281 
282     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
283         return interfaceId == type(IERC165).interfaceId;
284     }
285 }
286 
287 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
288 
289 
290 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
291 
292 pragma solidity ^0.8.0;
293 
294 
295 
296 interface IERC721 is IERC165 {
297 
298     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
299 
300 
301     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
302 
303 
304     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
305 
306 
307     function balanceOf(address owner) external view returns (uint256 balance);
308 
309 
310     function ownerOf(uint256 tokenId) external view returns (address owner);
311 
312 
313     function safeTransferFrom(
314         address from,
315         address to,
316         uint256 tokenId
317     ) external;
318 
319 
320     function transferFrom(
321         address from,
322         address to,
323         uint256 tokenId
324     ) external;
325 
326 
327     function approve(address to, uint256 tokenId) external;
328 
329 
330     function getApproved(uint256 tokenId) external view returns (address operator);
331 
332 
333     function setApprovalForAll(address operator, bool _approved) external;
334 
335     function isApprovedForAll(address owner, address operator) external view returns (bool);
336 
337 
338     function safeTransferFrom(
339         address from,
340         address to,
341         uint256 tokenId,
342         bytes calldata data
343     ) external;
344 }
345 
346 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 
354 
355 interface IERC721Metadata is IERC721 {
356 
357     function name() external view returns (string memory);
358 
359 
360     function symbol() external view returns (string memory);
361 
362 
363     function tokenURI(uint256 tokenId) external view returns (string memory);
364 }
365 
366 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
367 
368 
369 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
370 
371 pragma solidity ^0.8.0;
372 
373 
374 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
375     using Address for address;
376     using Strings for uint256;
377 
378     string private _name;
379 
380     string private _symbol;
381 
382     mapping(uint256 => address) private _owners;
383 
384     mapping(address => uint256) private _balances;
385 
386     mapping(uint256 => address) private _tokenApprovals;
387 
388     mapping(address => mapping(address => bool)) private _operatorApprovals;
389 
390     constructor(string memory name_, string memory symbol_) {
391         _name = name_;
392         _symbol = symbol_;
393     }
394 
395     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
396         return
397             interfaceId == type(IERC721).interfaceId ||
398             interfaceId == type(IERC721Metadata).interfaceId ||
399             super.supportsInterface(interfaceId);
400     }
401 
402 
403     function balanceOf(address owner) public view virtual override returns (uint256) {
404         require(owner != address(0), "ERC721: balance query for the zero address");
405         return _balances[owner];
406     }
407 
408     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
409         address owner = _owners[tokenId];
410         require(owner != address(0), "ERC721: owner query for nonexistent token");
411         return owner;
412     }
413 
414     function name() public view virtual override returns (string memory) {
415         return _name;
416     }
417 
418     function symbol() public view virtual override returns (string memory) {
419         return _symbol;
420     }
421 
422     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
423         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
424 
425         string memory sparrowURI = _sparrowURI();
426         return bytes(sparrowURI).length > 0 ? string(abi.encodePacked(sparrowURI, tokenId.toString())) : "";
427     }
428 
429 
430     function _sparrowURI() internal view virtual returns (string memory) {
431         return "";
432     }
433 
434     function approve(address to, uint256 tokenId) public virtual override {
435         address owner = ERC721.ownerOf(tokenId);
436         require(to != owner, "ERC721: approval to current owner");
437 
438         require(
439             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
440             "ERC721: approve caller is not owner nor approved for all"
441         );
442 
443         _approve(to, tokenId);
444     }
445 
446     function getApproved(uint256 tokenId) public view virtual override returns (address) {
447         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
448 
449         return _tokenApprovals[tokenId];
450     }
451 
452 
453     function setApprovalForAll(address operator, bool approved) public virtual override {
454         _setApprovalForAll(_msgSender(), operator, approved);
455     }
456 
457 
458     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
459         return _operatorApprovals[owner][operator];
460     }
461 
462 
463     function transferFrom(
464         address from,
465         address to,
466         uint256 tokenId
467     ) public virtual override {
468 
469         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
470 
471         _transfer(from, to, tokenId);
472     }
473 
474 
475     function safeTransferFrom(
476         address from,
477         address to,
478         uint256 tokenId
479     ) public virtual override {
480         safeTransferFrom(from, to, tokenId, "");
481     }
482 
483 
484     function safeTransferFrom(
485         address from,
486         address to,
487         uint256 tokenId,
488         bytes memory _data
489     ) public virtual override {
490         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
491         _safeTransfer(from, to, tokenId, _data);
492     }
493 
494     function _safeTransfer(
495         address from,
496         address to,
497         uint256 tokenId,
498         bytes memory _data
499     ) internal virtual {
500         _transfer(from, to, tokenId);
501         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
502     }
503 
504  
505     function _exists(uint256 tokenId) internal view virtual returns (bool) {
506         return _owners[tokenId] != address(0);
507     }
508 
509     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
510         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
511         address owner = ERC721.ownerOf(tokenId);
512         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
513     }
514 
515     function _safeMint(address to, uint256 tokenId) internal virtual {
516         _safeMint(to, tokenId, "");
517     }
518 
519     function _safeMint(
520         address to,
521         uint256 tokenId,
522         bytes memory _data
523     ) internal virtual {
524         _mint(to, tokenId);
525         require(
526             _checkOnERC721Received(address(0), to, tokenId, _data),
527             "ERC721: transfer to non ERC721Receiver implementer"
528         );
529     }
530 
531 
532     function _mint(address to, uint256 tokenId) internal virtual {
533         require(to != address(0), "ERC721: mint to the zero address");
534         require(!_exists(tokenId), "ERC721: token already minted");
535 
536         _beforeTokenTransfer(address(0), to, tokenId);
537 
538         _balances[to] += 1;
539         _owners[tokenId] = to;
540 
541         emit Transfer(address(0), to, tokenId);
542     }
543 
544 
545     function _burn(uint256 tokenId) internal virtual {
546         address owner = ERC721.ownerOf(tokenId);
547 
548         _beforeTokenTransfer(owner, address(0), tokenId);
549 
550         // Clear approvals
551         _approve(address(0), tokenId);
552 
553         _balances[owner] -= 1;
554         delete _owners[tokenId];
555 
556         emit Transfer(owner, address(0), tokenId);
557     }
558 
559 
560     function _transfer(
561         address from,
562         address to,
563         uint256 tokenId
564     ) internal virtual {
565         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
566         require(to != address(0), "ERC721: transfer to the zero address");
567 
568         _beforeTokenTransfer(from, to, tokenId);
569 
570         _approve(address(0), tokenId);
571 
572         _balances[from] -= 1;
573         _balances[to] += 1;
574         _owners[tokenId] = to;
575 
576         emit Transfer(from, to, tokenId);
577     }
578 
579 
580     function _approve(address to, uint256 tokenId) internal virtual {
581         _tokenApprovals[tokenId] = to;
582         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
583     }
584 
585     function _setApprovalForAll(
586         address owner,
587         address operator,
588         bool approved
589     ) internal virtual {
590         require(owner != operator, "ERC721: approve to caller");
591         _operatorApprovals[owner][operator] = approved;
592         emit ApprovalForAll(owner, operator, approved);
593     }
594 
595 
596     function _checkOnERC721Received(
597         address from,
598         address to,
599         uint256 tokenId,
600         bytes memory _data
601     ) private returns (bool) {
602         if (to.isContract()) {
603             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
604                 return retval == IERC721Receiver.onERC721Received.selector;
605             } catch (bytes memory reason) {
606                 if (reason.length == 0) {
607                     revert("ERC721: transfer to non ERC721Receiver implementer");
608                 } else {
609                     assembly {
610                         revert(add(32, reason), mload(reason))
611                     }
612                 }
613             }
614         } else {
615             return true;
616         }
617     }
618 
619 
620     function _beforeTokenTransfer(
621         address from,
622         address to,
623         uint256 tokenId
624     ) internal virtual {}
625 }
626 
627 // File: @openzeppelin/contracts/utils/Counters.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 
635 library Counters {
636     struct Counter {
637 
638         uint256 _value; // default: 0
639     }
640 
641     function current(Counter storage counter) internal view returns (uint256) {
642         return counter._value;
643     }
644 
645     function increment(Counter storage counter) internal {
646         unchecked {
647             counter._value += 1;
648         }
649     }
650 
651     function decrement(Counter storage counter) internal {
652         uint256 value = counter._value;
653         require(value > 0, "Counter: decrement overflow");
654         unchecked {
655             counter._value = value - 1;
656         }
657     }
658 
659     function reset(Counter storage counter) internal {
660         counter._value = 0;
661     }
662 }
663 
664 // File: .deps/Caribbean.sol
665 
666 
667 pragma solidity >=0.7.0 <0.9.0;
668 
669 
670 contract Caribbean is ERC721, Ownable {
671   using Counters for Counters.Counter;  
672   using Strings for uint256;
673 
674   Counters.Counter private _tokenSupply;
675   string public sparrowURI;
676   string public sparrowExtension = ".json"; 
677   uint256 public cost = 0.004 ether; 
678   uint256 public maxSupply = 4444; 
679   uint256 public freeMints = 2222; 
680   uint256 public maxMintAmount = 3; 
681   bool public paused = false;
682   bool public revealed = false;
683   string public DeppUri;
684   mapping(address => bool) public whitelisted;
685   mapping(address => uint256) private freeMintsWallet;
686 
687   constructor(
688     string memory _name,
689     string memory _symbol,
690     string memory _initSparrowURI,
691     string memory _initDeppUri
692   ) ERC721(_name, _symbol) {
693     setSparrowURI(_initSparrowURI);
694     setDeppURI(_initDeppUri);
695   }
696 
697   function totalSupply() public view returns (uint256) {
698     return _tokenSupply.current();
699   }
700 
701   // internal
702   function _sparrowURI() internal view virtual override returns (string memory) {
703     return sparrowURI;
704   }
705   
706   // public
707   function mint(address _to, uint256 _mintAmount) public payable {
708     uint256 supply = _tokenSupply.current();
709     require(!paused);
710     require(_mintAmount > 0);
711     require(_mintAmount <= maxMintAmount);
712     require(supply + _mintAmount <= maxSupply);
713 
714     if (supply + _mintAmount > freeMints) {
715       if(whitelisted[msg.sender] != true) {
716         require(msg.value >= cost * _mintAmount);
717       }
718     }
719     else {
720         require(
721             supply + _mintAmount <= freeMints,
722             "You would exceed the number of free mints"
723         );
724         require(
725             freeMintsWallet[msg.sender] + _mintAmount <= maxMintAmount,
726             "You can only mint 20 assets for free!"
727         );
728         freeMintsWallet[msg.sender] += _mintAmount;
729     }
730 
731     for (uint256 i = 1; i <= _mintAmount; i++) {
732        _tokenSupply.increment();
733       _safeMint(_to, supply + i);
734     }
735   }
736 
737   function tokenURI(uint256 tokenId)
738     public
739     view
740     virtual
741     override
742     returns (string memory)
743   {
744     require(
745       _exists(tokenId),
746       "ERC721Metadata: URI query for nonexistent token"
747     );
748     
749     if(revealed == false) {
750         return DeppUri;
751     }
752 
753     string memory currentSparrowURI = _sparrowURI();
754     return bytes(currentSparrowURI).length > 0
755         ? string(abi.encodePacked(currentSparrowURI, tokenId.toString(), sparrowExtension))
756         : "";
757   }
758 
759   //only owner
760   function reveal() public onlyOwner {
761       revealed = true;
762   }
763   
764   function setCost(uint256 _newCost) public onlyOwner {
765     cost = _newCost;
766   }
767 
768   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
769     maxMintAmount = _newmaxMintAmount;
770   }
771   
772   function setDeppURI(string memory _DeppURI) public onlyOwner {
773     DeppUri = _DeppURI;
774   }
775 
776   function setSparrowURI(string memory _newSparrowURI) public onlyOwner {
777     sparrowURI = _newSparrowURI;
778   }
779 
780   function setSparrowExtension(string memory _newSparrowExtension) public onlyOwner {
781     sparrowExtension = _newSparrowExtension;
782   }
783 
784   function pause(bool _state) public onlyOwner {
785     paused = _state;
786   }
787  
788  function whitelistUser(address _user) public onlyOwner {
789     whitelisted[_user] = true;
790   }
791  
792   function removeWhitelistUser(address _user) public onlyOwner {
793     whitelisted[_user] = false;
794   }
795 
796   function withdraw() public payable onlyOwner {
797 
798     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
799     require(os);
800 
801   }
802 }