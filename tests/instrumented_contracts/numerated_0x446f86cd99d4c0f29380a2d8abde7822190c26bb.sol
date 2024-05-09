1 //  /$$$$$$$$ /$$                     /$$                        
2 // | $$_____/| $$                    |__/                        
3 // | $$      | $$ /$$   /$$  /$$$$$$$ /$$ /$$   /$$ /$$$$$$/$$$$ 
4 // | $$$$$   | $$| $$  | $$ /$$_____/| $$| $$  | $$| $$_  $$_  $$
5 // | $$__/   | $$| $$  | $$|  $$$$$$ | $$| $$  | $$| $$ \ $$ \ $$
6 // | $$      | $$| $$  | $$ \____  $$| $$| $$  | $$| $$ | $$ | $$
7 // | $$$$$$$$| $$|  $$$$$$$ /$$$$$$$/| $$|  $$$$$$/| $$ | $$ | $$
8 // |________/|__/ \____  $$|_______/ |__/ \______/ |__/ |__/ |__/
9 //                /$$  | $$                                      
10 //               |  $$$$$$/                                      
11 //                \______/                                       
12 //   /$$$$$$  /$$           /$$                                  
13 //  /$$__  $$| $$          | $$                                  
14 // | $$  \__/| $$ /$$   /$$| $$$$$$$                             
15 // | $$      | $$| $$  | $$| $$__  $$                            
16 // | $$      | $$| $$  | $$| $$  \ $$                            
17 // | $$    $$| $$| $$  | $$| $$  | $$                            
18 // |  $$$$$$/| $$|  $$$$$$/| $$$$$$$/                            
19 //  \______/ |__/ \______/ |_______/                             
20                                                                                                          
21 /*
22 #######################################################################################################################
23 #######################################################################################################################
24 
25 Copyright CryptIT GmbH
26 
27 Licensed under the Apache License, Version 2.0 (the "License");
28 you may not use this file except in compliance with the License.
29 You may obtain a copy of the License at
30 
31     https://www.apache.org/licenses/LICENSE-2.0
32 
33 Unless required by applicable law or agreed to in writing, software
34 distributed under the License is distributed on aln "AS IS" BASIS,
35 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
36 See the License for the specific language governing permissions and
37 limitations under the License.
38 
39 #######################################################################################################################
40 #######################################################################################################################
41 
42 */
43 
44 // SPDX-License-Identifier: Apache-2.0
45 pragma solidity 0.8.7;
46 
47 
48 library LibPart {
49     
50     bytes32 public constant TYPE_HASH = keccak256("Part(address account,uint96 value)");
51 
52     struct Part {
53         address payable account;
54         uint96 value;
55     }
56 
57     function hash(Part memory part) internal pure returns (bytes32) {
58         return keccak256(abi.encode(TYPE_HASH, part.account, part.value));
59     }
60 
61 }
62 
63 
64 //pragma abicoder v2;
65 interface RoyaltiesV2 {
66     event RoyaltiesSet(uint256 tokenId, LibPart.Part[] royalties);
67 
68     function getRaribleV2Royalties(uint256 id) external view returns (LibPart.Part[] memory);
69 }
70 
71 
72 abstract contract AbstractRoyalties {
73 
74     mapping (uint256 => LibPart.Part[]) internal royalties;
75 
76     function _saveRoyalties(uint256 id, LibPart.Part[] memory _royalties) internal {
77         uint256 totalValue;
78         for (uint i = 0; i < _royalties.length; i++) {
79             require(_royalties[i].account != address(0x0), "Recipient should be present");
80             require(_royalties[i].value != 0, "Royalty value should be positive");
81             totalValue += _royalties[i].value;
82             royalties[id].push(_royalties[i]);
83         }
84         require(totalValue < 10000, "Royalty total value should be < 10000");
85         _onRoyaltiesSet(id, _royalties);
86     }
87 
88     function _updateAccount(uint256 _id, address _from, address _to) internal {
89         uint length = royalties[_id].length;
90         for(uint i = 0; i < length; i++) {
91             if (royalties[_id][i].account == _from) {
92                 royalties[_id][i].account = payable(address(uint160(_to)));
93             }
94         }
95     }
96 
97     function _onRoyaltiesSet(uint256 id, LibPart.Part[] memory _royalties) virtual internal;
98 }
99 
100 interface IERC165 {
101     function supportsInterface(bytes4 interfaceId) external view returns (bool);
102 }
103 
104 abstract contract ERC165 is IERC165 {
105     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
106         return interfaceId == type(IERC165).interfaceId;
107     }
108 }
109 
110 abstract contract Context {
111     function _msgSender() internal view virtual returns (address) {
112         return msg.sender;
113     }
114 
115     function _msgData() internal view virtual returns (bytes calldata) {
116         return msg.data;
117     }
118 }
119 
120 library Address {
121     
122     function isContract(address account) internal view returns (bool) {
123         uint256 size;
124         assembly {
125             size := extcodesize(account)
126         }
127         return size > 0;
128     }
129 
130     function sendValue(address payable recipient, uint256 amount) internal {
131         require(address(this).balance >= amount, "Address: insufficient balance");
132 
133         (bool success, ) = recipient.call{value: amount}("");
134         require(success, "Address: unable to send value, recipient may have reverted");
135     }
136 
137     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
138         return functionCall(target, data, "Address: low-level call failed");
139     }
140 
141     function functionCall(
142         address target,
143         bytes memory data,
144         string memory errorMessage
145     ) internal returns (bytes memory) {
146         return functionCallWithValue(target, data, 0, errorMessage);
147     }
148 
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value
153     ) internal returns (bytes memory) {
154         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
155     }
156 
157     function functionCallWithValue(
158         address target,
159         bytes memory data,
160         uint256 value,
161         string memory errorMessage
162     ) internal returns (bytes memory) {
163         require(address(this).balance >= value, "Address: insufficient balance for call");
164         require(isContract(target), "Address: call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.call{value: value}(data);
167         return _verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
171         return functionStaticCall(target, data, "Address: low-level static call failed");
172     }
173 
174     function functionStaticCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal view returns (bytes memory) {
179         require(isContract(target), "Address: static call to non-contract");
180 
181         (bool success, bytes memory returndata) = target.staticcall(data);
182         return _verifyCallResult(success, returndata, errorMessage);
183     }
184 
185     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
186         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
187     }
188 
189     function functionDelegateCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(isContract(target), "Address: delegate call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.delegatecall(data);
197         return _verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     function _verifyCallResult(
201         bool success,
202         bytes memory returndata,
203         string memory errorMessage
204     ) private pure returns (bytes memory) {
205         if (success) {
206             return returndata;
207         } else {
208             // Look for revert reason and bubble it up if present
209             if (returndata.length > 0) {
210                 // The easiest way to bubble the revert reason is using memory via assembly
211 
212                 assembly {
213                     let returndata_size := mload(returndata)
214                     revert(add(32, returndata), returndata_size)
215                 }
216             } else {
217                 revert(errorMessage);
218             }
219         }
220     }
221 }
222 
223 library SafeMath {
224 
225     function add(uint256 a, uint256 b) internal pure returns (uint256) {
226         uint256 c = a + b;
227         require(c >= a, "SafeMath: addition overflow");
228 
229         return c;
230     }
231 
232     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233         return sub(a, b, "SafeMath: subtraction overflow");
234     }
235 
236     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b <= a, errorMessage);
238         uint256 c = a - b;
239 
240         return c;
241     }
242 
243     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
244         if (a == 0) {
245             return 0;
246         }
247 
248         uint256 c = a * b;
249         require(c / a == b, "SafeMath: multiplication overflow");
250 
251         return c;
252     }
253 
254 
255     function div(uint256 a, uint256 b) internal pure returns (uint256) {
256         return div(a, b, "SafeMath: division by zero");
257     }
258 
259     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b > 0, errorMessage);
261         uint256 c = a / b;
262         return c;
263     }
264 
265     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
266         return mod(a, b, "SafeMath: modulo by zero");
267     }
268 
269     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b != 0, errorMessage);
271         return a % b;
272     }
273 }
274 
275 
276 interface IERC721 is IERC165 {
277 
278     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
279 
280     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
281 
282     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
283 
284     function balanceOf(address owner) external view returns (uint256 balance);
285 
286     function ownerOf(uint256 tokenId) external view returns (address owner);
287 
288     function safeTransferFrom(
289         address from,
290         address to,
291         uint256 tokenId
292     ) external;
293 
294     function transferFrom(
295         address from,
296         address to,
297         uint256 tokenId
298     ) external;
299 
300     function approve(address to, uint256 tokenId) external;
301 
302     function getApproved(uint256 tokenId) external view returns (address operator);
303 
304     function setApprovalForAll(address operator, bool _approved) external;
305 
306     function isApprovedForAll(address owner, address operator) external view returns (bool);
307 
308     function safeTransferFrom(
309         address from,
310         address to,
311         uint256 tokenId,
312         bytes calldata data
313     ) external;
314 }
315 
316 interface IERC721Enumerable is IERC721 {
317 
318     function totalSupply() external view returns (uint256);
319 
320     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
321 
322     function tokenByIndex(uint256 index) external view returns (uint256);
323 }
324 
325 
326 interface IERC721Metadata is IERC721 {
327     function name() external view returns (string memory);
328 
329     function symbol() external view returns (string memory);
330 
331     function tokenURI(uint256 tokenId) external view returns (string memory);
332 }
333 
334 
335 interface IERC721Receiver {
336     function onERC721Received(
337         address operator,
338         address from,
339         uint256 tokenId,
340         bytes calldata data
341     ) external returns (bytes4);
342 }
343 
344 
345 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
346     using SafeMath for uint256;
347     using Address for address;
348     using Strings for uint256;
349 
350     string private _name;
351     string private _symbol;
352     mapping(uint256 => address) private _owners;
353     mapping(address => uint256) private _balances;
354     mapping(uint256 => address) private _tokenApprovals;
355     mapping(address => mapping(address => bool)) private _operatorApprovals;
356     
357     mapping(uint256 => uint256) private lockTimes;
358 
359     constructor(string memory name_, string memory symbol_) {
360         _name = name_;
361         _symbol = symbol_;
362     }
363 
364     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
365         return
366             interfaceId == type(IERC721).interfaceId ||
367             interfaceId == type(IERC721Metadata).interfaceId ||
368             super.supportsInterface(interfaceId);
369     }
370 
371     function balanceOf(address owner) public view virtual override returns (uint256) {
372         require(owner != address(0), "ERC721: balance query for the zero address");
373         return _balances[owner];
374     }
375 
376     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
377         address owner = _owners[tokenId];
378         require(owner != address(0), "ERC721: owner query for nonexistent token");
379         return owner;
380     }
381 
382     function name() external view virtual override returns (string memory) {
383         return _name;
384     }
385 
386     function symbol() external view virtual override returns (string memory) {
387         return _symbol;
388     }
389 
390     function getApproved(uint256 tokenId) public view virtual override returns (address) {
391         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
392 
393         return _tokenApprovals[tokenId];
394     }
395 
396     function setApprovalForAll(address operator, bool approved) external virtual override {
397         require(operator != _msgSender(), "ERC721: approve to caller");
398 
399         _operatorApprovals[_msgSender()][operator] = approved;
400         emit ApprovalForAll(_msgSender(), operator, approved);
401     }
402 
403     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
404         return _operatorApprovals[owner][operator];
405     }
406     
407     function approve(address to, uint256 tokenId) public override {
408         require(lockTimes[tokenId] < block.timestamp, "Cannot approve locked token");
409 
410         address owner = ERC721.ownerOf(tokenId);
411         require(to != owner, "ERC721: approval to current owner");
412 
413         require(
414             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
415             "ERC721: approve caller is not owner nor approved for all"
416         );
417 
418         _approve(to, tokenId);
419     }
420     
421     function transferFrom(address from, address to, uint256 tokenId) external override {
422         require(lockTimes[tokenId] < block.timestamp, "Cannot transfer locked token");
423         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
424         _transfer(from, to, tokenId);
425     }
426 
427     function safeTransferFrom(address from, address to, uint256 tokenId) external override {
428         safeTransferFrom(from, to, tokenId, "");
429     }
430 
431     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
432         require(lockTimes[tokenId] < block.timestamp, "Cannot transfer locked token");
433         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
434         _safeTransfer(from, to, tokenId, _data);
435     }
436 
437     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal {
438         _transfer(from, to, tokenId);
439         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
440     }
441 
442     function _getLockTime(uint256 tokenId) internal view returns(uint256) {
443         return lockTimes[tokenId];
444     }
445 
446     function _lockForBooking(uint256 tokenId, uint256 lockTime) internal {
447         require(ERC721.ownerOf(tokenId) == _msgSender(), "Only owner can lock");
448         require(lockTime > block.timestamp, "Lock time has to be in the future");
449         require(lockTime > lockTimes[tokenId], "Cannot unlock token");
450         lockTimes[tokenId] = lockTime;
451     }
452     
453     function _safetyUnlock(uint256 tokenId) internal {
454         lockTimes[tokenId] = block.timestamp - 1;
455     }
456 
457     function _exists(uint256 tokenId) internal view virtual returns (bool) {
458         return _owners[tokenId] != address(0);
459     }
460 
461     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
462         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
463         address owner = ERC721.ownerOf(tokenId);
464         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
465     }
466 
467     function _safeMint(address to, uint256 tokenId) internal virtual {
468         _safeMint(to, tokenId, "");
469     }
470 
471     function _safeMint(
472         address to,
473         uint256 tokenId,
474         bytes memory _data
475     ) internal virtual {
476         _mint(to, tokenId);
477         require(
478             _checkOnERC721Received(address(0), to, tokenId, _data),
479             "ERC721: transfer to non ERC721Receiver implementer"
480         );
481     }
482 
483     function _mint(address to, uint256 tokenId) internal virtual {
484         require(to != address(0), "ERC721: mint to the zero address");
485         require(!_exists(tokenId), "ERC721: token already minted");
486 
487         _beforeTokenTransfer(address(0), to, tokenId);
488 
489         _balances[to] += 1;
490         _owners[tokenId] = to;
491 
492         emit Transfer(address(0), to, tokenId);
493     }
494 
495     function _transfer(
496         address from,
497         address to,
498         uint256 tokenId
499     ) internal virtual {
500         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
501         require(to != address(0), "ERC721: transfer to the zero address");
502 
503         _beforeTokenTransfer(from, to, tokenId);
504 
505         _approve(address(0), tokenId);
506 
507         _balances[from] -= 1;
508         _balances[to] += 1;
509         _owners[tokenId] = to;
510 
511         emit Transfer(from, to, tokenId);
512     }
513 
514     function _approve(address to, uint256 tokenId) internal virtual {
515         _tokenApprovals[tokenId] = to;
516         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
517     }
518 
519     function _checkOnERC721Received(
520         address from,
521         address to,
522         uint256 tokenId,
523         bytes memory _data
524     ) private returns (bool) {
525         if (to.isContract()) {
526             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
527                 return retval == IERC721Receiver(to).onERC721Received.selector;
528             } catch (bytes memory reason) {
529                 if (reason.length == 0) {
530                     revert("ERC721: transfer to non ERC721Receiver implementer");
531                 } else {
532                     assembly {
533                         revert(add(32, reason), mload(reason))
534                     }
535                 }
536             }
537         } else {
538             return true;
539         }
540     }
541 
542     function _beforeTokenTransfer(
543         address from,
544         address to,
545         uint256 tokenId
546     ) internal virtual {}
547 }
548 
549 library LibRoyaltiesV2 {
550     bytes4 constant _INTERFACE_ID_ROYALTIES = 0xcad96cca;
551 }
552 
553 //pragma abicoder v2;
554 contract RoyaltiesV2Impl is AbstractRoyalties, RoyaltiesV2 {
555 
556     function getRaribleV2Royalties(uint256 id) override external view returns (LibPart.Part[] memory) {
557         return royalties[id];
558     }
559 
560     function _onRoyaltiesSet(uint256 id, LibPart.Part[] memory _royalties) override internal {
561         emit RoyaltiesSet(id, _royalties);
562     }
563 }
564 
565 library Strings {
566     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
567 
568     function toString(uint256 value) internal pure returns (string memory) {
569 
570         if (value == 0) {
571             return "0";
572         }
573         uint256 temp = value;
574         uint256 digits;
575         while (temp != 0) {
576             digits++;
577             temp /= 10;
578         }
579         bytes memory buffer = new bytes(digits);
580         while (value != 0) {
581             digits -= 1;
582             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
583             value /= 10;
584         }
585         return string(buffer);
586     }
587 
588     function toHexString(uint256 value) internal pure returns (string memory) {
589         if (value == 0) {
590             return "0x00";
591         }
592         uint256 temp = value;
593         uint256 length = 0;
594         while (temp != 0) {
595             length++;
596             temp >>= 8;
597         }
598         return toHexString(value, length);
599     }
600 
601     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
602         bytes memory buffer = new bytes(2 * length + 2);
603         buffer[0] = "0";
604         buffer[1] = "x";
605         for (uint256 i = 2 * length + 1; i > 1; --i) {
606             buffer[i] = _HEX_SYMBOLS[value & 0xf];
607             value >>= 4;
608         }
609         require(value == 0, "Strings: hex length insufficient");
610         return string(buffer);
611     }
612 }
613 
614 abstract contract Ownable is Context {
615     address private _owner;
616 
617     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
618 
619     constructor() {
620         _setOwner(_msgSender());
621     }
622 
623     function owner() public view returns (address) {
624         return _owner;
625     }
626 
627     modifier onlyOwner() {
628         require(owner() == _msgSender(), "Ownable: caller is not the owner");
629         _;
630     }
631 
632     function renounceOwnership() public onlyOwner {
633         _setOwner(address(0));
634     }
635 
636     function transferOwnership(address newOwner) public onlyOwner {
637         require(newOwner != address(0), "Ownable: new owner is the zero address");
638         _setOwner(newOwner);
639     }
640 
641     function _setOwner(address newOwner) private {
642         address oldOwner = _owner;
643         _owner = newOwner;
644         emit OwnershipTransferred(oldOwner, newOwner);
645     }
646 }
647 
648 library Counters {
649     struct Counter {
650         uint256 _value; // default: 0
651     }
652 
653     function current(Counter storage counter) internal view returns (uint256) {
654         return counter._value;
655     }
656 
657     function increment(Counter storage counter) internal {
658         unchecked {
659             counter._value += 1;
660         }
661     }
662 
663     function decrement(Counter storage counter) internal {
664         uint256 value = counter._value;
665         require(value > 0, "Counter: decrement overflow");
666         unchecked {
667             counter._value = value - 1;
668         }
669     }
670 
671     function reset(Counter storage counter) internal {
672         counter._value = 0;
673     }
674 }
675 
676 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
677 
678     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
679     mapping(uint256 => uint256) private _ownedTokensIndex;
680     uint256[] private _allTokens;
681 
682     mapping(uint256 => uint256) private _allTokensIndex;
683 
684     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
685         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
686     }
687 
688     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
689         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
690         return _ownedTokens[owner][index];
691     }
692 
693     function totalSupply() public view virtual override returns (uint256) {
694         return _allTokens.length;
695     }
696 
697     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
698         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
699         return _allTokens[index];
700     }
701 
702     function _beforeTokenTransfer(
703         address from,
704         address to,
705         uint256 tokenId
706     ) internal virtual override {
707         super._beforeTokenTransfer(from, to, tokenId);
708 
709         if (from == address(0)) {
710             _addTokenToAllTokensEnumeration(tokenId);
711         } else if (from != to) {
712             _removeTokenFromOwnerEnumeration(from, tokenId);
713         }
714         if (to == address(0)) {
715             _removeTokenFromAllTokensEnumeration(tokenId);
716         } else if (to != from) {
717             _addTokenToOwnerEnumeration(to, tokenId);
718         }
719     }
720 
721     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
722         uint256 length = ERC721.balanceOf(to);
723         _ownedTokens[to][length] = tokenId;
724         _ownedTokensIndex[tokenId] = length;
725     }
726 
727     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
728         _allTokensIndex[tokenId] = _allTokens.length;
729         _allTokens.push(tokenId);
730     }
731 
732     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
733 
734         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
735         uint256 tokenIndex = _ownedTokensIndex[tokenId];
736 
737         if (tokenIndex != lastTokenIndex) {
738             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
739 
740             _ownedTokens[from][tokenIndex] = lastTokenId;
741             _ownedTokensIndex[lastTokenId] = tokenIndex;
742         }
743 
744         delete _ownedTokensIndex[tokenId];
745         delete _ownedTokens[from][lastTokenIndex];
746     }
747 
748     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
749 
750         uint256 lastTokenIndex = _allTokens.length - 1;
751         uint256 tokenIndex = _allTokensIndex[tokenId];
752 
753         uint256 lastTokenId = _allTokens[lastTokenIndex];
754 
755         _allTokens[tokenIndex] = lastTokenId;
756         _allTokensIndex[lastTokenId] = tokenIndex;
757 
758         delete _allTokensIndex[tokenId];
759         _allTokens.pop();
760     }
761 }                   
762 
763 contract ElysiumClub is ERC721Enumerable, Ownable, RoyaltiesV2Impl {
764 
765     using SafeMath for uint256;
766     using Counters for Counters.Counter;
767     Counters.Counter private _tokenIds;
768 
769     string private _dataHostBaseURI = "ipfs://QmWHx293w768mZkYnqVswPYVzWzUwjCK3qNfqQnYSpVsZ1/";
770     string private _lockedDataHostBaseURI = "ipfs://QmbdjoBLUMCkqZKfXB7n8YSjkVYAPVxrX4UEMkFDgWHNSH/";
771     string private _contractURI = "https://ipfs.io/ipfs/Qmer1bmCfytNAswiTey2jGxZBBf1NXVwPbUSZoQtzAXAMC";
772     string private _placeHolderHash = "ipfs://QmSkArc6e1s7no6F1kEhgnoXQc6fqeaiNTfBxf5z66a2kJ";
773 
774     uint256 public maxMints = 6888;
775     bool public publicBuyEnabled = false;
776     bool public treasuresRevealed = false;
777 
778     mapping(address => bool) private isCollabPartner;
779     mapping(address => uint256) private _userMints;
780     
781     uint256 public maxUserMints = 10;
782 
783     uint256 private _price = 300000000000000000;
784     uint256 private _collabPrice = 400000000000000000;
785     
786     uint96 private _raribleRoyaltyPercentage = 500;
787     address payable _beneficiary = payable(address(0x12CcBd4b15052f261FD472731Db4F353ffc5ee89));
788     address payable _raribleBeneficiary = payable(address(0x12CcBd4b15052f261FD472731Db4F353ffc5ee89));
789 
790     event BeneficiaryChanged(address payable indexed previousBeneficiary, address payable indexed newBeneficiary);
791     event RaribleBeneficiaryChanged(address payable indexed previousBeneficiary, address payable indexed newBeneficiary);
792     event BeneficiaryPaid(address payable beneficiary, uint256 amount);
793     event PriceChange(uint256 previousPrice, uint256 newPrice);
794     event RaribleRoyaltyPercentageChange(uint96 previousPercentage, uint96 newPercentage);
795     event BaseURIChanged(string previousBaseURI, string newBaseURI);
796     event ContractBaseURIChanged(string previousBaseURI, string newBaseURI);
797     event ContractURIChanged(string previousURI, string newURI);
798     event PublicBuyEnabled(bool enabled);
799     event PermanentURI(string _value, uint256 indexed _id);
800 
801     constructor( string memory name, string memory symbol
802     ) ERC721(name, symbol) Ownable() {
803         emit BeneficiaryChanged(payable(address(0)), _beneficiary);
804         emit RaribleBeneficiaryChanged(payable(address(0)), _raribleBeneficiary);
805         emit RaribleRoyaltyPercentageChange(0, _raribleRoyaltyPercentage);
806     }
807 
808     function _mintToken(address owner) internal returns (uint) {
809 
810         _tokenIds.increment();
811         uint256 id = _tokenIds.current();
812         require(id <= maxMints, "Cannot mint more than max");
813 
814         _safeMint(owner, id);
815         _setRoyalties(id, _raribleBeneficiary, _raribleRoyaltyPercentage);
816 
817         emit PermanentURI(_tokenURI(id), id);
818 
819         return id;
820     }
821 
822     /**
823     * @dev Public mint function to mint one token
824     */
825     function mintToken() external payable returns (uint256) {
826 
827         require(publicBuyEnabled, "Public buy is not enabled yet");
828         require(_userMints[msg.sender] <= maxUserMints, "Already minted maximum");
829 
830         uint256 mintPrice = isCollabPartner[_msgSender()] ? _collabPrice : _price;
831         require(msg.value >= mintPrice, "Invalid value sent");
832 
833         uint256 id = _mintToken(_msgSender());
834 
835         (bool sent, ) = _beneficiary.call{value : msg.value}("");
836         require(sent, "Failed to pay beneficiary");
837         emit BeneficiaryPaid(_beneficiary, msg.value);
838         
839         _userMints[msg.sender] = _userMints[msg.sender] + 1;
840 
841         return id;
842     }
843 
844     /**
845     * @dev Public mint function to mint multiple tokens at once
846     * @param count The amount of tokens to mint
847     */
848     function mintMultipleToken(uint256 count) external payable returns (uint256) {
849 
850         require(publicBuyEnabled, "Public buy is not enabled yet");
851         require(_userMints[msg.sender] + count <= maxUserMints, "Already minted maximum");
852 
853         uint256 mintPrice = isCollabPartner[_msgSender()] ? _collabPrice : _price;
854         require(msg.value >= mintPrice.mul(count), "Invalid value sent");
855 
856         for (uint256 i = 0; i < count; i++) {
857             _mintToken(msg.sender);
858         }
859 
860         (bool sent, ) = _beneficiary.call{value : msg.value}("");
861         require(sent, "Failed to pay beneficiary");
862         emit BeneficiaryPaid(_beneficiary, msg.value);
863 
864         _userMints[msg.sender] = _userMints[msg.sender] + count;
865 
866         return count;
867     }
868 
869     /**
870     * @dev Admin function to mint on token to multiple addresses
871     * @param addresses Array of addresses to mint to
872     */
873     function airdrop(address[] memory addresses) external onlyOwner {
874         for (uint256 i = 0; i < addresses.length; i++) {
875             _mintToken(addresses[i]);
876         }
877     }
878 
879     /**
880     * @dev Admin function to mint many tokens
881     * @param count The count to mint
882     * @param receiver The receiver to mint to
883     */
884     function mintMany(uint256 count, address receiver) external onlyOwner {
885         for (uint256 i = 0; i < count; i++) {
886             _mintToken(receiver);
887         }
888     }
889 
890     /**
891     * @dev Get opensea royalty beneficiary
892     */
893     function getBeneficiary() external view returns (address) {
894         return _beneficiary;
895     }
896 
897     /**
898     * @dev Set opensea royalty beneficiary
899     * @param newBeneficiary The new opensea royalty beneficiary
900     */
901     function setBeneficiary(address payable newBeneficiary) external onlyOwner {
902         require(newBeneficiary != address(0), "Beneficiary: new beneficiary is the zero address");
903         address payable prev = _beneficiary;
904         _beneficiary = newBeneficiary;
905         emit BeneficiaryChanged(prev, _beneficiary);
906     }
907 
908     /**
909     * @dev Set rarible royalty beneficiary
910     * @param newBeneficiary The new rarible royalty beneficiary
911     */
912     function setRaribleBeneficiary(address payable newBeneficiary) external onlyOwner {
913         require(newBeneficiary != address(0), "Beneficiary: new rarible beneficiary is the zero address");
914         address payable prev = _raribleBeneficiary;
915         _raribleBeneficiary = newBeneficiary;
916         emit RaribleBeneficiaryChanged(prev, _raribleBeneficiary);
917     }
918 
919     /**
920     * @dev Get the current mint price
921     */
922     function getPrice() external view returns (uint256)  {
923         return _price;
924     }
925 
926     /**
927     * @dev Set the mint price
928     * @param price The new price
929     */
930     function setPrice(uint256 price) external onlyOwner {
931         uint256 prev = _price;
932         _price = price;
933         emit PriceChange(prev, _price);
934     }
935 
936     /**
937     * @dev Set the collab  list reduced mint price
938     * @param price The new price
939     */
940     function setCollabPrice(uint256 price) external onlyOwner {
941         _collabPrice = price;
942     }
943     
944     /**
945     * @dev Set rarible global royalty percentage
946     * @param percentage The new rarible percentage
947     */
948     function setRaribleRoyaltyPercentage(uint96 percentage) external onlyOwner {
949         uint96 prev = _raribleRoyaltyPercentage;
950         _raribleRoyaltyPercentage = percentage;
951         emit RaribleRoyaltyPercentageChange(prev, _raribleRoyaltyPercentage);
952     }
953 
954     /**
955     * @dev Set the base uri for all unlocked token
956     * @param dataHostBaseURI The new base uri
957     */
958     function setDataHostURI(string memory dataHostBaseURI) external onlyOwner {
959         string memory prev = _dataHostBaseURI;
960         _dataHostBaseURI = dataHostBaseURI;
961         emit BaseURIChanged(prev, _dataHostBaseURI);
962     }
963 
964     /**
965     * @dev Set the base URI for the locked metadata
966     * @param lockedDataHostBaseURI new base uri
967     */
968     function setLockedDataHostBaseURI(string memory lockedDataHostBaseURI) external onlyOwner {
969         _lockedDataHostBaseURI = lockedDataHostBaseURI;
970     }
971 
972     /**
973     * @dev Set the contract uri for opensea standart
974     * @param contractURI_ The new contract uri
975     */
976     function setContractURI(string memory contractURI_) external onlyOwner {
977         string memory prev = _contractURI;
978         _contractURI = contractURI_;
979         emit ContractURIChanged(prev, _contractURI);
980     }
981 
982     /**
983     * @dev Get the contract uri for opensea standart
984     */
985     function contractURI() external view returns (string memory) {
986         return _contractURI;
987     }
988 
989     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
990         return string(abi.encodePacked(_dataHostBaseURI, Strings.toString(tokenId)));
991     }
992 
993     function _lockedTokenURI(uint256 tokenId) internal view returns (string memory) {
994         return string(abi.encodePacked(_lockedDataHostBaseURI, Strings.toString(tokenId)));
995     }
996 
997     /**
998     * @dev Get the token URI of a specific id, will return locked metadata if the token is locked
999     * @param tokenId The token id
1000     */
1001     function tokenURI(uint256 tokenId) external view override returns (string memory) {
1002         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1003 
1004         if(treasuresRevealed){
1005             if(_getLockTime(tokenId) > block.timestamp){
1006                 return _lockedTokenURI(tokenId);
1007             }
1008             return _tokenURI(tokenId);
1009         }
1010         return _placeHolderHash;
1011     }
1012 
1013     function _setRoyalties(uint _tokenId, address payable _royaltiesReceipientAddress, uint96 _percentageBasisPoints) internal {
1014         LibPart.Part[] memory _royalties = new LibPart.Part[](1);
1015         _royalties[0].value = _percentageBasisPoints;
1016         _royalties[0].account = _royaltiesReceipientAddress;
1017         _saveRoyalties(_tokenId, _royalties);
1018     }
1019 
1020     /**
1021     * @dev Set Opensea royalties
1022     * @param _tokenId The token id
1023     * @param _royaltiesReceipientAddress The royalty receiver address
1024     * @param _percentageBasisPoints The royalty percentage in basis points
1025     */
1026     function setRoyalties(uint256 _tokenId, address payable _royaltiesReceipientAddress, uint96 _percentageBasisPoints) external onlyOwner {
1027         _setRoyalties(_tokenId, _royaltiesReceipientAddress, _percentageBasisPoints);
1028     }
1029 
1030     /**
1031     * @dev Set placeholder hash for unrevealed metadata
1032     * @param placeHolderHash new placeholder uri
1033     */
1034     function setPlaceHolderHash(string memory placeHolderHash) external onlyOwner {
1035         _placeHolderHash = placeHolderHash;
1036     }
1037     
1038     /**
1039     * @dev Admin function to reveal the actual metadata
1040     */
1041     function revealTreasures() external onlyOwner {
1042         treasuresRevealed = !treasuresRevealed;
1043     }
1044 
1045     /**
1046     * @dev Admin function to release a token from lock
1047     * @param tokenId the token id to unlock
1048     */
1049     function safetyUnlock(uint256 tokenId) external onlyOwner {
1050         _safetyUnlock(tokenId);
1051     }
1052 
1053     /**
1054     * @dev Adds address to collab reduces price
1055     * @param collabAddresses collab address to add
1056     */
1057     function addCollabPartner(address[] memory collabAddresses) external onlyOwner {
1058         for(uint256 i = 0; i < collabAddresses.length; i++){
1059             isCollabPartner[collabAddresses[i]] = true;
1060         }
1061     }
1062 
1063     /**
1064     * @dev Removes address from collab reduces price
1065     * @param collabAddress collab address to remove from list
1066     */
1067     function removeCollabPartner(address collabAddress) external onlyOwner {
1068         require(isCollabPartner[collabAddress] == true, "Not marked as partner");
1069         isCollabPartner[collabAddress] = false;
1070     }
1071 
1072     /**
1073     * @dev Switches the public sale
1074     * @param enabled true if the public mint should be enabled
1075     */
1076     function enablePublicBuy(bool enabled) external onlyOwner {
1077         require(publicBuyEnabled != enabled, "Already set");
1078         publicBuyEnabled = enabled;
1079         emit PublicBuyEnabled(publicBuyEnabled);
1080     }
1081 
1082     /**
1083     * @dev Sets max allowed mints per user address
1084     * @param _maxUserMints The maximum mint count per user address.
1085     */
1086     function setMaxUserMints(uint256 _maxUserMints) external onlyOwner {
1087         maxUserMints = _maxUserMints;
1088     }
1089     
1090     /**
1091     * @dev Count of mints from user
1092     * @param user The address of the user.
1093     */
1094     function userMints(address user) external view returns (uint256) {
1095         return _userMints[user];
1096     }
1097     
1098 
1099     /**
1100     * @dev Get the lock time of a token
1101     * @param tokenId The token id
1102     */
1103     function getLockTime(uint256 tokenId) external view returns(uint256) {
1104         return _getLockTime(tokenId);
1105     }
1106 
1107     /**
1108     * @dev Public function to lock a token, used in the dApp to complete a boocking process.
1109     * A locked token cannot be transferred or unlocked. There is a admin safety to unlock tokens in case of cancel.
1110     * @param tokenId The token id to lock
1111     * @param lockTime The time to lock the token as a unix timestamp
1112     */
1113     function lockForBooking(uint256 tokenId, uint256 lockTime) external {
1114         _lockForBooking(tokenId, lockTime);
1115     }
1116 
1117     /**
1118     * @dev Support Interface for Rarible royalty implementation
1119     */
1120     function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable) returns (bool) {
1121         if(interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES) {
1122             return true;
1123         }
1124         return super.supportsInterface(interfaceId);
1125     }
1126 
1127     function getTime() external view returns (uint256) {
1128         return block.timestamp;
1129     }
1130 }