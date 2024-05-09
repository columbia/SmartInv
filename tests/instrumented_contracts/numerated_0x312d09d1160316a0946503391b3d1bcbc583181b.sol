1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address payable) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this;
13         return msg.data;
14     }
15 }
16 pragma solidity >=0.6.0 <0.8.0;
17 
18 interface IERC165 {
19     function supportsInterface(bytes4 interfaceId) external view returns (bool);
20 }
21 
22 pragma solidity >=0.6.2 <0.8.0;
23 
24 interface IERC721 is IERC165 {
25 
26     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
27 
28     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
29 
30     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
31 
32     function balanceOf(address owner) external view returns (uint256 balance);
33 
34     function ownerOf(uint256 tokenId) external view returns (address owner);
35 
36     function safeTransferFrom(address from, address to, uint256 tokenId) external;
37 
38     function transferFrom(address from, address to, uint256 tokenId) external;
39 
40     function approve(address to, uint256 tokenId) external;
41 
42     function getApproved(uint256 tokenId) external view returns (address operator);
43 
44     function setApprovalForAll(address operator, bool _approved) external;
45 
46     function isApprovedForAll(address owner, address operator) external view returns (bool);
47 
48     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
49 }
50 
51 pragma solidity >=0.6.2 <0.8.0;
52 
53 interface IERC721Metadata is IERC721 {
54 
55     function name() external view returns (string memory);
56 
57     function symbol() external view returns (string memory);
58 
59     function tokenURI(uint256 tokenId) external view returns (string memory);
60 }
61 
62 pragma solidity >=0.6.2 <0.8.0;
63 
64 interface IERC721Enumerable is IERC721 {
65 
66     function totalSupply() external view returns (uint256);
67 
68     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
69 
70     function tokenByIndex(uint256 index) external view returns (uint256);
71 }
72 
73 pragma solidity >=0.6.0 <0.8.0;
74 
75 interface IERC721Receiver {
76     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
77 }
78 
79 
80 
81 pragma solidity >=0.6.0 <0.8.0;
82 
83 abstract contract ERC165 is IERC165 {
84 
85     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
86 
87     mapping(bytes4 => bool) private _supportedInterfaces;
88 
89     constructor () {
90         _registerInterface(_INTERFACE_ID_ERC165);
91     }
92 
93     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
94         return _supportedInterfaces[interfaceId];
95     }
96 
97     function _registerInterface(bytes4 interfaceId) internal virtual {
98         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
99         _supportedInterfaces[interfaceId] = true;
100     }
101 }
102 
103 pragma solidity >=0.6.0 <0.8.0;
104 
105 library SafeMath {
106 
107     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
108         uint256 c = a + b;
109         if (c < a) return (false, 0);
110         return (true, c);
111     }
112 
113     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         if (b > a) return (false, 0);
115         return (true, a - b);
116     }
117 
118     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         if (a == 0) return (true, 0);
120         uint256 c = a * b;
121         if (c / a != b) return (false, 0);
122         return (true, c);
123     }
124 
125     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         if (b == 0) return (false, 0);
127         return (true, a / b);
128     }
129 
130     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         if (b == 0) return (false, 0);
132         return (true, a % b);
133     }
134 
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138         return c;
139     }
140 
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b <= a, "SafeMath: subtraction overflow");
143         return a - b;
144     }
145 
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         if (a == 0) return 0;
148         uint256 c = a * b;
149         require(c / a == b, "SafeMath: multiplication overflow");
150         return c;
151     }
152 
153     function div(uint256 a, uint256 b) internal pure returns (uint256) {
154         require(b > 0, "SafeMath: division by zero");
155         return a / b;
156     }
157 
158     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159         require(b > 0, "SafeMath: modulo by zero");
160         return a % b;
161     }
162 
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         return a - b;
166     }
167 
168     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b > 0, errorMessage);
170         return a / b;
171     }
172 
173     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b > 0, errorMessage);
175         return a % b;
176     }
177 }
178 
179 pragma solidity >=0.6.2 <0.8.0;
180 
181 library Address {
182 
183     function isContract(address account) internal view returns (bool) {
184 
185         uint256 size;
186         assembly { size := extcodesize(account) }
187         return size > 0;
188     }
189 
190     function sendValue(address payable recipient, uint256 amount) internal {
191         require(address(this).balance >= amount, "Address: insufficient balance");
192 
193         (bool success, ) = recipient.call{ value: amount }("");
194         require(success, "Address: unable to send value, recipient may have reverted");
195     }
196 
197     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
198       return functionCall(target, data, "Address: low-level call failed");
199     }
200 
201     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, 0, errorMessage);
203     }
204 
205     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
207     }
208 
209     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
210         require(address(this).balance >= value, "Address: insufficient balance for call");
211         require(isContract(target), "Address: call to non-contract");
212 
213         (bool success, bytes memory returndata) = target.call{ value: value }(data);
214         return _verifyCallResult(success, returndata, errorMessage);
215     }
216 
217     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
218         return functionStaticCall(target, data, "Address: low-level static call failed");
219     }
220 
221     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
222         require(isContract(target), "Address: static call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.staticcall(data);
225         return _verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
229         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
230     }
231 
232     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
233         require(isContract(target), "Address: delegate call to non-contract");
234 
235         (bool success, bytes memory returndata) = target.delegatecall(data);
236         return _verifyCallResult(success, returndata, errorMessage);
237     }
238 
239     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
240         if (success) {
241             return returndata;
242         } else {
243             if (returndata.length > 0) {
244                 assembly {
245                     let returndata_size := mload(returndata)
246                     revert(add(32, returndata), returndata_size)
247                 }
248             } else {
249                 revert(errorMessage);
250             }
251         }
252     }
253 }
254 
255 
256 
257 pragma solidity >=0.6.0 <0.8.0;
258 
259 library EnumerableSet {
260 
261     struct Set {
262         bytes32[] _values;
263         mapping (bytes32 => uint256) _indexes;
264     }
265 
266     function _add(Set storage set, bytes32 value) private returns (bool) {
267         if (!_contains(set, value)) {
268             set._values.push(value);
269             set._indexes[value] = set._values.length;
270             return true;
271         } else {
272             return false;
273         }
274     }
275 
276     function _remove(Set storage set, bytes32 value) private returns (bool) {
277         uint256 valueIndex = set._indexes[value];
278 
279         if (valueIndex != 0) {
280             uint256 toDeleteIndex = valueIndex - 1;
281             uint256 lastIndex = set._values.length - 1;
282 
283             bytes32 lastvalue = set._values[lastIndex];
284 
285             set._values[toDeleteIndex] = lastvalue;
286             set._indexes[lastvalue] = toDeleteIndex + 1;
287             set._values.pop();
288             delete set._indexes[value];
289 
290             return true;
291         } else {
292             return false;
293         }
294     }
295 
296     function _contains(Set storage set, bytes32 value) private view returns (bool) {
297         return set._indexes[value] != 0;
298     }
299 
300     function _length(Set storage set) private view returns (uint256) {
301         return set._values.length;
302     }
303 
304     function _at(Set storage set, uint256 index) private view returns (bytes32) {
305         require(set._values.length > index, "EnumerableSet: index out of bounds");
306         return set._values[index];
307     }
308 
309     struct Bytes32Set {
310         Set _inner;
311     }
312 
313     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
314         return _add(set._inner, value);
315     }
316 
317     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
318         return _remove(set._inner, value);
319     }
320 
321     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
322         return _contains(set._inner, value);
323     }
324 
325     function length(Bytes32Set storage set) internal view returns (uint256) {
326         return _length(set._inner);
327     }
328 
329     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
330         return _at(set._inner, index);
331     }
332 
333     struct AddressSet {
334         Set _inner;
335     }
336 
337     function add(AddressSet storage set, address value) internal returns (bool) {
338         return _add(set._inner, bytes32(uint256(uint160(value))));
339     }
340 
341     function remove(AddressSet storage set, address value) internal returns (bool) {
342         return _remove(set._inner, bytes32(uint256(uint160(value))));
343     }
344 
345     function contains(AddressSet storage set, address value) internal view returns (bool) {
346         return _contains(set._inner, bytes32(uint256(uint160(value))));
347     }
348 
349     function length(AddressSet storage set) internal view returns (uint256) {
350         return _length(set._inner);
351     }
352 
353     function at(AddressSet storage set, uint256 index) internal view returns (address) {
354         return address(uint160(uint256(_at(set._inner, index))));
355     }
356 
357     struct UintSet {
358         Set _inner;
359     }
360 
361     function add(UintSet storage set, uint256 value) internal returns (bool) {
362         return _add(set._inner, bytes32(value));
363     }
364 
365     function remove(UintSet storage set, uint256 value) internal returns (bool) {
366         return _remove(set._inner, bytes32(value));
367     }
368 
369     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
370         return _contains(set._inner, bytes32(value));
371     }
372 
373     function length(UintSet storage set) internal view returns (uint256) {
374         return _length(set._inner);
375     }
376 
377     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
378         return uint256(_at(set._inner, index));
379     }
380 }
381 
382 pragma solidity >=0.6.0 <0.8.0;
383 
384 library EnumerableMap {
385 
386     struct MapEntry {
387         bytes32 _key;
388         bytes32 _value;
389     }
390 
391     struct Map {
392         MapEntry[] _entries;
393 
394         mapping (bytes32 => uint256) _indexes;
395     }
396 
397     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
398         uint256 keyIndex = map._indexes[key];
399 
400         if (keyIndex == 0) {
401             map._entries.push(MapEntry({ _key: key, _value: value }));
402             map._indexes[key] = map._entries.length;
403             return true;
404         } else {
405             map._entries[keyIndex - 1]._value = value;
406             return false;
407         }
408     }
409 
410     function _remove(Map storage map, bytes32 key) private returns (bool) {
411         uint256 keyIndex = map._indexes[key];
412 
413         if (keyIndex != 0) {
414 
415             uint256 toDeleteIndex = keyIndex - 1;
416             uint256 lastIndex = map._entries.length - 1;
417 
418             MapEntry storage lastEntry = map._entries[lastIndex];
419 
420             map._entries[toDeleteIndex] = lastEntry;
421             map._indexes[lastEntry._key] = toDeleteIndex + 1;
422             map._entries.pop();
423 
424             delete map._indexes[key];
425 
426             return true;
427         } else {
428             return false;
429         }
430     }
431 
432     function _contains(Map storage map, bytes32 key) private view returns (bool) {
433         return map._indexes[key] != 0;
434     }
435 
436     function _length(Map storage map) private view returns (uint256) {
437         return map._entries.length;
438     }
439 
440     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
441         require(map._entries.length > index, "EnumerableMap: index out of bounds");
442 
443         MapEntry storage entry = map._entries[index];
444         return (entry._key, entry._value);
445     }
446 
447     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
448         uint256 keyIndex = map._indexes[key];
449         if (keyIndex == 0) return (false, 0);
450         return (true, map._entries[keyIndex - 1]._value);
451     }
452 
453     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
454         uint256 keyIndex = map._indexes[key];
455         require(keyIndex != 0, "EnumerableMap: nonexistent key");
456         return map._entries[keyIndex - 1]._value;
457     }
458 
459     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
460         uint256 keyIndex = map._indexes[key];
461         require(keyIndex != 0, errorMessage);
462         return map._entries[keyIndex - 1]._value;
463     }
464 
465     struct UintToAddressMap {
466         Map _inner;
467     }
468 
469     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
470         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
471     }
472 
473     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
474         return _remove(map._inner, bytes32(key));
475     }
476 
477     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
478         return _contains(map._inner, bytes32(key));
479     }
480 
481     function length(UintToAddressMap storage map) internal view returns (uint256) {
482         return _length(map._inner);
483     }
484 
485     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
486         (bytes32 key, bytes32 value) = _at(map._inner, index);
487         return (uint256(key), address(uint160(uint256(value))));
488     }
489 
490     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
491         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
492         return (success, address(uint160(uint256(value))));
493     }
494 
495     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
496         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
497     }
498 
499     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
500         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
501     }
502 }
503 
504 pragma solidity >=0.6.0 <0.8.0;
505 
506 library Strings {
507 
508     function toString(uint256 value) internal pure returns (string memory) {
509 
510         if (value == 0) {
511             return "0";
512         }
513         uint256 temp = value;
514         uint256 digits;
515         while (temp != 0) {
516             digits++;
517             temp /= 10;
518         }
519         bytes memory buffer = new bytes(digits);
520         uint256 index = digits - 1;
521         temp = value;
522         while (temp != 0) {
523             buffer[index--] = bytes1(uint8(48 + temp % 10));
524             temp /= 10;
525         }
526         return string(buffer);
527     }
528 }
529 
530 pragma solidity >=0.6.0 <0.8.0;
531 
532 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
533     using SafeMath for uint256;
534     using Address for address;
535     using EnumerableSet for EnumerableSet.UintSet;
536     using EnumerableMap for EnumerableMap.UintToAddressMap;
537     using Strings for uint256;
538 
539     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
540     
541     event TokenMinted(address receiver, uint256 tokenId);
542 
543     mapping (address => EnumerableSet.UintSet) private _holderTokens;
544 
545     EnumerableMap.UintToAddressMap private _tokenOwners;
546 
547     mapping (uint256 => address) private _tokenApprovals;
548 
549     mapping (address => mapping (address => bool)) private _operatorApprovals;
550 
551     string private _name;
552 
553     string private _symbol;
554 
555     mapping (uint256 => string) private _tokenURIs;
556 
557     string private _baseURI;
558 
559     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
560 
561     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
562 
563     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
564 
565     constructor (string memory name_, string memory symbol_) {
566         _name = name_;
567         _symbol = symbol_;
568 
569         _registerInterface(_INTERFACE_ID_ERC721);
570         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
571         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
572     }
573 
574     function balanceOf(address owner) public view virtual override returns (uint256) {
575         require(owner != address(0), "ERC721: balance query for the zero address");
576         return _holderTokens[owner].length();
577     }
578 
579     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
580         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
581     }
582 
583     function name() public view virtual override returns (string memory) {
584         return _name;
585     }
586 
587     function symbol() public view virtual override returns (string memory) {
588         return _symbol;
589     }
590 
591     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
592         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
593 
594         string memory _tokenURI = _tokenURIs[tokenId];
595         string memory base = baseURI();
596 
597         if (bytes(base).length == 0) {
598             return _tokenURI;
599         }
600         if (bytes(_tokenURI).length > 0) {
601             return string(abi.encodePacked(base, _tokenURI));
602         }
603         return string(abi.encodePacked(base, tokenId.toString()));
604     }
605 
606     function baseURI() public view virtual returns (string memory) {
607         return _baseURI;
608     }
609 
610     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
611         return _holderTokens[owner].at(index);
612     }
613 
614     function totalSupply() public view virtual override returns (uint256) {
615         return _tokenOwners.length();
616     }
617 
618     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
619         (uint256 tokenId, ) = _tokenOwners.at(index);
620         return tokenId;
621     }
622 
623     function approve(address to, uint256 tokenId) public virtual override {
624         address owner = ERC721.ownerOf(tokenId);
625         require(to != owner, "ERC721: approval to current owner");
626 
627         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
628             "ERC721: approve caller is not owner nor approved for all"
629         );
630 
631         _approve(to, tokenId);
632     }
633 
634     function getApproved(uint256 tokenId) public view virtual override returns (address) {
635         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
636 
637         return _tokenApprovals[tokenId];
638     }
639 
640     function setApprovalForAll(address operator, bool approved) public virtual override {
641         require(operator != _msgSender(), "ERC721: approve to caller");
642 
643         _operatorApprovals[_msgSender()][operator] = approved;
644         emit ApprovalForAll(_msgSender(), operator, approved);
645     }
646 
647     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
648         return _operatorApprovals[owner][operator];
649     }
650 
651     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
652         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
653 
654         _transfer(from, to, tokenId);
655     }
656 
657     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
658         safeTransferFrom(from, to, tokenId, "");
659     }
660 
661     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
662         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
663         _safeTransfer(from, to, tokenId, _data);
664     }
665 
666     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
667         _transfer(from, to, tokenId);
668         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
669     }
670 
671     function _exists(uint256 tokenId) internal view virtual returns (bool) {
672         return _tokenOwners.contains(tokenId);
673     }
674 
675     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
676         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
677         address owner = ERC721.ownerOf(tokenId);
678         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
679     }
680 
681     function _safeMint(address to, uint256 tokenId) internal virtual {
682         _safeMint(to, tokenId, "");
683     }
684 
685     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
686         _mint(to, tokenId);
687         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
688     }
689 
690     function _mint(address to, uint256 tokenId) internal virtual {
691         require(to != address(0), "ERC721: mint to the zero address");
692         require(!_exists(tokenId), "ERC721: token already minted");
693 
694         _beforeTokenTransfer(address(0), to, tokenId);
695 
696         _holderTokens[to].add(tokenId);
697 
698         _tokenOwners.set(tokenId, to);
699 
700         emit Transfer(address(0), to, tokenId);
701         
702         emit TokenMinted(to, tokenId);
703     }
704 
705     function _burn(uint256 tokenId) internal virtual {
706         address owner = ERC721.ownerOf(tokenId);
707 
708         _beforeTokenTransfer(owner, address(0), tokenId);
709 
710         _approve(address(0), tokenId);
711 
712         if (bytes(_tokenURIs[tokenId]).length != 0) {
713             delete _tokenURIs[tokenId];
714         }
715 
716         _holderTokens[owner].remove(tokenId);
717 
718         _tokenOwners.remove(tokenId);
719 
720         emit Transfer(owner, address(0), tokenId);
721     }
722 
723     function _transfer(address from, address to, uint256 tokenId) internal virtual {
724         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
725         require(to != address(0), "ERC721: transfer to the zero address");
726 
727         _beforeTokenTransfer(from, to, tokenId);
728 
729         _approve(address(0), tokenId);
730 
731         _holderTokens[from].remove(tokenId);
732         _holderTokens[to].add(tokenId);
733 
734         _tokenOwners.set(tokenId, to);
735 
736         emit Transfer(from, to, tokenId);
737     }
738 
739     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
740         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
741         _tokenURIs[tokenId] = _tokenURI;
742     }
743 
744     function _setBaseURI(string memory baseURI_) internal virtual {
745         _baseURI = baseURI_;
746     }
747 
748     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
749         private returns (bool)
750     {
751         if (!to.isContract()) {
752             return true;
753         }
754         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
755             IERC721Receiver(to).onERC721Received.selector,
756             _msgSender(),
757             from,
758             tokenId,
759             _data
760         ), "ERC721: transfer to non ERC721Receiver implementer");
761         bytes4 retval = abi.decode(returndata, (bytes4));
762         return (retval == _ERC721_RECEIVED);
763     }
764 
765     function _approve(address to, uint256 tokenId) internal virtual {
766         _tokenApprovals[tokenId] = to;
767         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
768     }
769 
770     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
771 }
772 
773 pragma solidity >=0.6.0 <0.8.0;
774 
775 abstract contract Ownable is Context {
776     address private _owner;
777 
778     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
779 
780     constructor () {
781         address msgSender = _msgSender();
782         _owner = msgSender;
783         emit OwnershipTransferred(address(0), msgSender);
784     }
785 
786     function owner() public view virtual returns (address) {
787         return _owner;
788     }
789 
790     modifier onlyOwner() {
791         require(owner() == _msgSender(), "Ownable: caller is not the owner");
792         _;
793     }
794 
795     function renounceOwnership() public virtual onlyOwner {
796         emit OwnershipTransferred(_owner, address(0));
797         _owner = address(0);
798     }
799 
800     function transferOwnership(address newOwner) public virtual onlyOwner {
801         require(newOwner != address(0), "Ownable: new owner is the zero address");
802         emit OwnershipTransferred(_owner, newOwner);
803         _owner = newOwner;
804     }
805 }
806 
807 pragma solidity ^0.7.0;
808 
809 contract SlumdogeBillionaires is ERC721, Ownable {
810     using SafeMath for uint256;
811 
812     uint256 public startingIndexBlock;
813 
814     uint256 public startingIndex;
815 
816     uint256 public constant SBPrice = 69000000000000000; //0.069 ETH
817 
818     uint public constant maxSBPurchase = 10; // Max 10 NFTs per purchase
819 
820     uint256 public MAX_SBS;
821 
822     bool public saleIsActive = false;
823 
824     uint256 public REVEAL_TIMESTAMP;
825     
826     uint[] internal tokenIndexes;
827     
828     bool public tokensReserved;
829 
830     constructor(string memory name, string memory symbol, uint256 maxNftSupply, uint256 saleStart) ERC721(name, symbol) {
831         MAX_SBS = maxNftSupply;
832         REVEAL_TIMESTAMP = saleStart;
833         tokensReserved = false;
834         setBaseURI("https://slumdoge.s3.ap-southeast-2.amazonaws.com/");
835     }
836 
837     function withdraw() public onlyOwner {
838         uint balance = address(this).balance;
839         msg.sender.transfer(balance);
840     }
841 
842     function reserveSBs() public onlyOwner {
843         require(!tokensReserved, "Tokens already reserved");
844         uint supply = totalSupply();
845         uint i;
846         for (i = 0; i < 35; i++) {
847             _safeMint(msg.sender, supply + i);
848         }
849         tokensReserved = true;
850     }
851 
852     function setRevealTimestamp(uint256 revealTimeStamp) public onlyOwner {
853         REVEAL_TIMESTAMP = revealTimeStamp;
854     } 
855 
856     function setBaseURI(string memory baseURI) public onlyOwner {
857         _setBaseURI(baseURI);
858     }
859     
860     function setTokenURI(uint256 tokenId, string memory _tokenURI) public onlyOwner {
861         _setTokenURI(tokenId, _tokenURI);
862     }
863 
864     function flipSaleState() public onlyOwner {
865         saleIsActive = !saleIsActive;
866     }
867 
868     function mintSB(uint numberOfTokens) public payable returns (uint[] memory) {
869         require(saleIsActive, "Sale must be active to mint SB");
870         require(numberOfTokens <= maxSBPurchase, "Can only mint 10 tokens at a time");
871         require(totalSupply().add(numberOfTokens) <= MAX_SBS, "Purchase would exceed max supply of SBs");
872         require(SBPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
873         uint[] memory mintedIndexes;
874         tokenIndexes = mintedIndexes;
875         for(uint i = 0; i < numberOfTokens; i++) {
876             uint mintIndex = totalSupply();
877             if (totalSupply() < MAX_SBS) {
878                 tokenIndexes.push(mintIndex);
879                 _safeMint(msg.sender, mintIndex);
880             }
881         }
882         if (startingIndexBlock == 0 && (totalSupply() == MAX_SBS || block.timestamp >= REVEAL_TIMESTAMP)) {
883             startingIndexBlock = block.number;
884         } 
885         return tokenIndexes;
886     }
887 
888     function setStartingIndex() public {
889         require(startingIndex == 0, "Starting index is already set");
890         require(startingIndexBlock != 0, "Starting index block must be set");
891         
892         startingIndex = uint(blockhash(startingIndexBlock)) % MAX_SBS;
893         if (block.number.sub(startingIndexBlock) > 255) {
894             startingIndex = uint(blockhash(block.number - 1)) % MAX_SBS;
895         }
896         if (startingIndex == 0) {
897             startingIndex = startingIndex.add(1);
898         }
899     }
900 
901     function emergencySetStartingIndexBlock() public onlyOwner {
902         require(startingIndex == 0, "Starting index is already set");
903         
904         startingIndexBlock = block.number;
905     }
906 }