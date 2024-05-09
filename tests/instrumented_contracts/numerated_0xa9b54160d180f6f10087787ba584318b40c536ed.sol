1 pragma solidity >=0.6.0 <0.8.0;
2 
3 abstract contract Context {
4 
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; 
11         return msg.data;
12     }
13 }
14 
15 pragma solidity >=0.6.0 <0.8.0;
16 
17 interface IERC165 {
18 
19     function supportsInterface(bytes4 interfaceId) external view returns (bool);
20 }
21 
22 pragma solidity >=0.6.2 <0.8.0;
23 
24 interface IERC721 is IERC165 {
25     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
26 
27     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
28 
29     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
30 
31     function balanceOf(address owner) external view returns (uint256 balance);
32 
33     function ownerOf(uint256 tokenId) external view returns (address owner);
34 
35     function safeTransferFrom(address from, address to, uint256 tokenId) external;
36 
37     function transferFrom(address from, address to, uint256 tokenId) external;
38 
39     function approve(address to, uint256 tokenId) external;
40 
41     function getApproved(uint256 tokenId) external view returns (address operator);
42 
43     function setApprovalForAll(address operator, bool _approved) external;
44 
45     function isApprovedForAll(address owner, address operator) external view returns (bool);
46 
47     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
48 }
49 
50 pragma solidity >=0.6.2 <0.8.0;
51 
52 interface IERC721Metadata is IERC721 {
53     function name() external view returns (string memory);
54 
55 
56     function symbol() external view returns (string memory);
57 
58     function tokenURI(uint256 tokenId) external view returns (string memory);
59 }
60 
61 pragma solidity >=0.6.2 <0.8.0;
62 
63 interface IERC721Enumerable is IERC721 {
64 
65     function totalSupply() external view returns (uint256);
66 
67     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
68 
69     function tokenByIndex(uint256 index) external view returns (uint256);
70 }
71 
72 pragma solidity >=0.6.0 <0.8.0;
73 
74 interface IERC721Receiver {
75 
76     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
77 }
78 
79 pragma solidity >=0.6.0 <0.8.0;
80 
81 abstract contract ERC165 is IERC165 {
82     
83     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
84 
85     mapping(bytes4 => bool) private _supportedInterfaces;
86 
87     constructor () internal {
88         _registerInterface(_INTERFACE_ID_ERC165);
89     }
90 
91     
92     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
93         return _supportedInterfaces[interfaceId];
94     }
95 
96     function _registerInterface(bytes4 interfaceId) internal virtual {
97         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
98         _supportedInterfaces[interfaceId] = true;
99     }
100 }
101 
102 pragma solidity >=0.6.0 <0.8.0;
103 
104 library SafeMath {
105    
106     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
107         uint256 c = a + b;
108         if (c < a) return (false, 0);
109         return (true, c);
110     }
111 
112     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
113         if (b > a) return (false, 0);
114         return (true, a - b);
115     }
116 
117     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
118         if (a == 0) return (true, 0);
119         uint256 c = a * b;
120         if (c / a != b) return (false, 0);
121         return (true, c);
122     }
123 
124     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
125         if (b == 0) return (false, 0);
126         return (true, a / b);
127     }
128 
129     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         if (b == 0) return (false, 0);
131         return (true, a % b);
132     }
133 
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137         return c;
138     }
139 
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b <= a, "SafeMath: subtraction overflow");
142         return a - b;
143     }
144 
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         if (a == 0) return 0;
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149         return c;
150     }
151 
152     function div(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b > 0, "SafeMath: division by zero");
154         return a / b;
155     }
156 
157     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
158         require(b > 0, "SafeMath: modulo by zero");
159         return a % b;
160     }
161 
162     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         return a - b;
165     }
166 
167     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b > 0, errorMessage);
169         return a / b;
170     }
171 
172     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b > 0, errorMessage);
174         return a % b;
175     }
176 }
177 
178 pragma solidity >=0.6.2 <0.8.0;
179 
180 library Address {
181 
182     function isContract(address account) internal view returns (bool) {
183          uint256 size;
184         assembly { size := extcodesize(account) }
185         return size > 0;
186     }
187 
188     function sendValue(address payable recipient, uint256 amount) internal {
189         require(address(this).balance >= amount, "Address: insufficient balance");
190         (bool success, ) = recipient.call{ value: amount }("");
191         require(success, "Address: unable to send value, recipient may have reverted");
192     }
193 
194     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
195       return functionCall(target, data, "Address: low-level call failed");
196     }
197 
198     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, 0, errorMessage);
200     }
201 
202     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
203         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
204     }
205 
206     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
207         require(address(this).balance >= value, "Address: insufficient balance for call");
208         require(isContract(target), "Address: call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.call{ value: value }(data);
211         return _verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
219         require(isContract(target), "Address: static call to non-contract");
220 
221         (bool success, bytes memory returndata) = target.staticcall(data);
222         return _verifyCallResult(success, returndata, errorMessage);
223     }
224 
225     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
226         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
227     }
228 
229     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
230         require(isContract(target), "Address: delegate call to non-contract");
231 
232         (bool success, bytes memory returndata) = target.delegatecall(data);
233         return _verifyCallResult(success, returndata, errorMessage);
234     }
235 
236     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
237         if (success) {
238             return returndata;
239         } else {
240             if (returndata.length > 0) {
241 
242                 assembly {
243                     let returndata_size := mload(returndata)
244                     revert(add(32, returndata), returndata_size)
245                 }
246             } else {
247                 revert(errorMessage);
248             }
249         }
250     }
251 }
252 
253 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
254 
255 
256 
257 pragma solidity >=0.6.0 <0.8.0;
258 
259 library EnumerableSet {
260 
261     struct Set {
262         // Storage of set values
263         bytes32[] _values;
264 
265         // Position of the value in the `values` array, plus 1 because index 0
266         // means a value is not in the set.
267         mapping (bytes32 => uint256) _indexes;
268     }
269 
270     function _add(Set storage set, bytes32 value) private returns (bool) {
271         if (!_contains(set, value)) {
272             set._values.push(value);
273             set._indexes[value] = set._values.length;
274             return true;
275         } else {
276             return false;
277         }
278     }
279 
280     function _remove(Set storage set, bytes32 value) private returns (bool) {
281         uint256 valueIndex = set._indexes[value];
282         if (valueIndex != 0) { // Equivalent to contains(set, value)
283          
284             uint256 toDeleteIndex = valueIndex - 1;
285             uint256 lastIndex = set._values.length - 1;
286 
287             bytes32 lastvalue = set._values[lastIndex];
288 
289             set._values[toDeleteIndex] = lastvalue;
290             set._indexes[lastvalue] = toDeleteIndex + 1; 
291             set._values.pop();
292 
293             delete set._indexes[value];
294 
295             return true;
296         } else {
297             return false;
298         }
299     }
300 
301     function _contains(Set storage set, bytes32 value) private view returns (bool) {
302         return set._indexes[value] != 0;
303     }
304 
305     function _length(Set storage set) private view returns (uint256) {
306         return set._values.length;
307     }
308 
309     function _at(Set storage set, uint256 index) private view returns (bytes32) {
310         require(set._values.length > index, "EnumerableSet: index out of bounds");
311         return set._values[index];
312     }
313 
314     // Bytes32Set
315 
316     struct Bytes32Set {
317         Set _inner;
318     }
319 
320     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
321         return _add(set._inner, value);
322     }
323 
324     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
325         return _remove(set._inner, value);
326     }
327 
328     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
329         return _contains(set._inner, value);
330     }
331 
332     function length(Bytes32Set storage set) internal view returns (uint256) {
333         return _length(set._inner);
334     }
335 
336     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
337         return _at(set._inner, index);
338     }
339 
340     struct AddressSet {
341         Set _inner;
342     }
343 
344     function add(AddressSet storage set, address value) internal returns (bool) {
345         return _add(set._inner, bytes32(uint256(uint160(value))));
346     }
347 
348     function remove(AddressSet storage set, address value) internal returns (bool) {
349         return _remove(set._inner, bytes32(uint256(uint160(value))));
350     }
351 
352     function contains(AddressSet storage set, address value) internal view returns (bool) {
353         return _contains(set._inner, bytes32(uint256(uint160(value))));
354     }
355 
356     function length(AddressSet storage set) internal view returns (uint256) {
357         return _length(set._inner);
358     }
359 
360     function at(AddressSet storage set, uint256 index) internal view returns (address) {
361         return address(uint160(uint256(_at(set._inner, index))));
362     }
363     struct UintSet {
364         Set _inner;
365     }
366 
367     function add(UintSet storage set, uint256 value) internal returns (bool) {
368         return _add(set._inner, bytes32(value));
369     }
370 
371     function remove(UintSet storage set, uint256 value) internal returns (bool) {
372         return _remove(set._inner, bytes32(value));
373     }
374 
375     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
376         return _contains(set._inner, bytes32(value));
377     }
378 
379     function length(UintSet storage set) internal view returns (uint256) {
380         return _length(set._inner);
381     }
382 
383     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
384         return uint256(_at(set._inner, index));
385     }
386 }
387 
388 pragma solidity >=0.6.0 <0.8.0;
389 
390 library EnumerableMap {
391     
392     struct MapEntry {
393         bytes32 _key;
394         bytes32 _value;
395     }
396 
397     struct Map {
398         MapEntry[] _entries;
399 
400         mapping (bytes32 => uint256) _indexes;
401     }
402 
403     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
404         uint256 keyIndex = map._indexes[key];
405 
406         if (keyIndex == 0) { // Equivalent to !contains(map, key)
407             map._entries.push(MapEntry({ _key: key, _value: value }));
408             map._indexes[key] = map._entries.length;
409             return true;
410         } else {
411             map._entries[keyIndex - 1]._value = value;
412             return false;
413         }
414     }
415 
416     function _remove(Map storage map, bytes32 key) private returns (bool) {
417         uint256 keyIndex = map._indexes[key];
418 
419         if (keyIndex != 0) { 
420 
421             uint256 toDeleteIndex = keyIndex - 1;
422             uint256 lastIndex = map._entries.length - 1;
423         
424             MapEntry storage lastEntry = map._entries[lastIndex];
425 
426             map._entries[toDeleteIndex] = lastEntry;
427             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
428 
429             map._entries.pop();
430 
431             delete map._indexes[key];
432 
433             return true;
434         } else {
435             return false;
436         }
437     }
438 
439 
440     function _contains(Map storage map, bytes32 key) private view returns (bool) {
441         return map._indexes[key] != 0;
442     }
443 
444     function _length(Map storage map) private view returns (uint256) {
445         return map._entries.length;
446     }
447 
448     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
449         require(map._entries.length > index, "EnumerableMap: index out of bounds");
450 
451         MapEntry storage entry = map._entries[index];
452         return (entry._key, entry._value);
453     }
454 
455     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
456         uint256 keyIndex = map._indexes[key];
457         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
458         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
459     }
460 
461     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
462         uint256 keyIndex = map._indexes[key];
463         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
464         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
465     }
466 
467     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
468         uint256 keyIndex = map._indexes[key];
469         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
470         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
471     }
472 
473     struct UintToAddressMap {
474         Map _inner;
475     }
476 
477     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
478         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
479     }
480 
481     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
482         return _remove(map._inner, bytes32(key));
483     }
484 
485     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
486         return _contains(map._inner, bytes32(key));
487     }
488 
489     function length(UintToAddressMap storage map) internal view returns (uint256) {
490         return _length(map._inner);
491     }
492 
493     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
494         (bytes32 key, bytes32 value) = _at(map._inner, index);
495         return (uint256(key), address(uint160(uint256(value))));
496     }
497 
498     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
499         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
500         return (success, address(uint160(uint256(value))));
501     }
502 
503     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
504         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
505     }
506 
507     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
508         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
509     }
510 }
511 
512 pragma solidity >=0.6.0 <0.8.0;
513 
514 library Strings {
515    
516     function toString(uint256 value) internal pure returns (string memory) {
517         if (value == 0) {
518             return "0";
519         }
520         uint256 temp = value;
521         uint256 digits;
522         while (temp != 0) {
523             digits++;
524             temp /= 10;
525         }
526         bytes memory buffer = new bytes(digits);
527         uint256 index = digits - 1;
528         temp = value;
529         while (temp != 0) {
530             buffer[index--] = bytes1(uint8(48 + temp % 10));
531             temp /= 10;
532         }
533         return string(buffer);
534     }
535     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
536         return strConcat(_a, _b, "", "", "");
537     }
538 
539     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
540         return strConcat(_a, _b, _c, "", "");
541     }
542 
543     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
544         return strConcat(_a, _b, _c, _d, "");
545     }
546 
547     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
548         bytes memory _ba = bytes(_a);
549         bytes memory _bb = bytes(_b);
550         bytes memory _bc = bytes(_c);
551         bytes memory _bd = bytes(_d);
552         bytes memory _be = bytes(_e);
553         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
554         bytes memory babcde = bytes(abcde);
555         uint k = 0;
556         uint i = 0;
557         for (i = 0; i < _ba.length; i++) {
558             babcde[k++] = _ba[i];
559         }
560         for (i = 0; i < _bb.length; i++) {
561             babcde[k++] = _bb[i];
562         }
563         for (i = 0; i < _bc.length; i++) {
564             babcde[k++] = _bc[i];
565         }
566         for (i = 0; i < _bd.length; i++) {
567             babcde[k++] = _bd[i];
568         }
569         for (i = 0; i < _be.length; i++) {
570             babcde[k++] = _be[i];
571         }
572         return string(babcde);
573     }
574 
575     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
576         if (_i == 0) {
577             return "0";
578         }
579         uint j = _i;
580         uint len;
581         while (j != 0) {
582             len++;
583             j /= 10;
584         }
585         bytes memory bstr = new bytes(len);
586         uint k = len - 1;
587         while (_i != 0) {
588             bstr[k--] = byte(uint8(48 + _i % 10));
589             _i /= 10;
590         }
591         return string(bstr);
592     }
593 }
594 
595 pragma solidity >=0.6.0 <0.8.0;
596 
597 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
598     using SafeMath for uint256;
599     using Address for address;
600     using EnumerableSet for EnumerableSet.UintSet;
601     using EnumerableMap for EnumerableMap.UintToAddressMap;
602     using Strings for uint256;
603 
604     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
605 
606     mapping (address => EnumerableSet.UintSet) private _holderTokens;
607 
608     EnumerableMap.UintToAddressMap private _tokenOwners;
609 
610     mapping (uint256 => address) private _tokenApprovals;
611 
612     mapping (address => mapping (address => bool)) private _operatorApprovals;
613 
614     string private _name;
615 
616     string private _symbol;
617 
618     mapping (uint256 => string) private _tokenURIs;
619 
620     string private _baseURI;
621 
622     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
623 
624     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
625 
626     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
627 
628     constructor (string memory name_, string memory symbol_) public {
629         _name = name_;
630         _symbol = symbol_;
631 
632         _registerInterface(_INTERFACE_ID_ERC721);
633         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
634         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
635     }
636 
637     function balanceOf(address owner) public view virtual override returns (uint256) {
638         require(owner != address(0), "ERC721: balance query for the zero address");
639         return _holderTokens[owner].length();
640     }
641 
642     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
643         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
644     }
645 
646     function name() public view virtual override returns (string memory) {
647         return _name;
648     }
649 
650     function symbol() public view virtual override returns (string memory) {
651         return _symbol;
652     }
653 
654     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
655         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
656 
657         string memory _tokenURI = _tokenURIs[tokenId];
658         string memory base = baseURI();
659 
660         if (bytes(base).length == 0) {
661             return _tokenURI;
662         }
663         if (bytes(_tokenURI).length > 0) {
664             return string(abi.encodePacked(base, _tokenURI));
665         }
666         return string(abi.encodePacked(base, tokenId.toString()));
667     }
668 
669     function baseURI() public view virtual returns (string memory) {
670         return _baseURI;
671     }
672 
673     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
674         return _holderTokens[owner].at(index);
675     }
676 
677     function totalSupply() public view virtual override returns (uint256) {
678         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
679         return _tokenOwners.length();
680     }
681 
682     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
683         (uint256 tokenId, ) = _tokenOwners.at(index);
684         return tokenId;
685     }
686 
687     function approve(address to, uint256 tokenId) public virtual override {
688         address owner = ERC721.ownerOf(tokenId);
689         require(to != owner, "ERC721: approval to current owner");
690 
691         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
692             "ERC721: approve caller is not owner nor approved for all"
693         );
694 
695         _approve(to, tokenId);
696     }
697 
698     function getApproved(uint256 tokenId) public view virtual override returns (address) {
699         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
700 
701         return _tokenApprovals[tokenId];
702     }
703 
704     function setApprovalForAll(address operator, bool approved) public virtual override {
705         require(operator != _msgSender(), "ERC721: approve to caller");
706 
707         _operatorApprovals[_msgSender()][operator] = approved;
708         emit ApprovalForAll(_msgSender(), operator, approved);
709     }
710 
711     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
712         return _operatorApprovals[owner][operator];
713     }
714 
715     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
716         //solhint-disable-next-line max-line-length
717         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
718 
719         _transfer(from, to, tokenId);
720     }
721 
722     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
723         safeTransferFrom(from, to, tokenId, "");
724     }
725 
726     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
727         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
728         _safeTransfer(from, to, tokenId, _data);
729     }
730 
731     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
732         _transfer(from, to, tokenId);
733         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
734     }
735 
736     function _exists(uint256 tokenId) internal view virtual returns (bool) {
737         return _tokenOwners.contains(tokenId);
738     }
739 
740     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
741         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
742         address owner = ERC721.ownerOf(tokenId);
743         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
744     }
745 
746     function _safeMint(address to, uint256 tokenId) internal virtual {
747         _safeMint(to, tokenId, "");
748     }
749 
750     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
751         _mint(to, tokenId);
752         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
753     }
754 
755     function _mint(address to, uint256 tokenId) internal virtual {
756         require(to != address(0), "ERC721: mint to the zero address");
757         require(!_exists(tokenId), "ERC721: token already minted");
758 
759         _beforeTokenTransfer(address(0), to, tokenId);
760 
761         _holderTokens[to].add(tokenId);
762 
763         _tokenOwners.set(tokenId, to);
764 
765         emit Transfer(address(0), to, tokenId);
766     }
767 
768     function _burn(uint256 tokenId) internal virtual {
769         address owner = ERC721.ownerOf(tokenId); // internal owner
770 
771         _beforeTokenTransfer(owner, address(0), tokenId);
772 
773         _approve(address(0), tokenId);
774 
775         if (bytes(_tokenURIs[tokenId]).length != 0) {
776             delete _tokenURIs[tokenId];
777         }
778 
779         _holderTokens[owner].remove(tokenId);
780 
781         _tokenOwners.remove(tokenId);
782 
783         emit Transfer(owner, address(0), tokenId);
784     }
785 
786     function _transfer(address from, address to, uint256 tokenId) internal virtual {
787         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
788         require(to != address(0), "ERC721: transfer to the zero address");
789 
790         _beforeTokenTransfer(from, to, tokenId);
791 
792         _approve(address(0), tokenId);
793 
794         _holderTokens[from].remove(tokenId);
795         _holderTokens[to].add(tokenId);
796 
797         _tokenOwners.set(tokenId, to);
798 
799         emit Transfer(from, to, tokenId);
800     }
801 
802     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
803         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
804         _tokenURIs[tokenId] = _tokenURI;
805     }
806 
807     function _setBaseURI(string memory baseURI_) internal virtual {
808         _baseURI = baseURI_;
809     }
810 
811     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
812         private returns (bool)
813     {
814         if (!to.isContract()) {
815             return true;
816         }
817         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
818             IERC721Receiver(to).onERC721Received.selector,
819             _msgSender(),
820             from,
821             tokenId,
822             _data
823         ), "ERC721: transfer to non ERC721Receiver implementer");
824         bytes4 retval = abi.decode(returndata, (bytes4));
825         return (retval == _ERC721_RECEIVED);
826     }
827 
828     function _approve(address to, uint256 tokenId) internal virtual {
829         _tokenApprovals[tokenId] = to;
830         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
831     }
832 
833     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
834 }
835 
836 pragma solidity >=0.6.0 <0.8.0;
837 
838 abstract contract Ownable is Context {
839     address private _owner;
840 
841     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
842 
843     constructor () internal {
844         address msgSender = _msgSender();
845         _owner = msgSender;
846         emit OwnershipTransferred(address(0), msgSender);
847     }
848 
849     function owner() public view virtual returns (address) {
850         return _owner;
851     }
852 
853     modifier onlyOwner() {
854         require(owner() == _msgSender(), "Ownable: caller is not the owner");
855         _;
856     }
857 
858     function renounceOwnership() public virtual onlyOwner {
859         emit OwnershipTransferred(_owner, address(0));
860         _owner = address(0);
861     }
862 
863     function transferOwnership(address newOwner) public virtual onlyOwner {
864         require(newOwner != address(0), "Ownable: new owner is the zero address");
865         emit OwnershipTransferred(_owner, newOwner);
866         _owner = newOwner;
867     }
868 }
869 
870 pragma solidity 0.7.0;
871 
872 contract Generatives is ERC721, Ownable {
873     constructor() ERC721("Generatives", "GEN") {
874     }
875     
876     using SafeMath for uint256;
877     
878     struct Project {
879         string name;
880         uint256 pricePerTokenInWei;
881         string projectBaseURI;
882         string projectBaseIpfsURI;
883         uint256 invocations;
884         uint256 maxInvocations;
885     }
886     uint256 constant ONE_MILLION = 1000000;
887     uint256 public nextProjectId;
888     mapping(uint256 => Project) projects;
889     mapping(uint256 => uint256) public tokenIdToProjectId;
890     mapping(uint256 => uint256[]) internal projectIdToTokenIds;
891 
892 
893     
894     function addProject(string memory _projectname, uint256 _pricePerTokenInWei, uint256 _maxInvocations, string memory _projectBaseURI) public onlyOwner {
895 
896         uint256 projectId = nextProjectId;
897         projects[projectId].name = _projectname;
898         projects[projectId].pricePerTokenInWei = _pricePerTokenInWei;
899         projects[projectId].maxInvocations = _maxInvocations;
900         projects[projectId].projectBaseURI = _projectBaseURI;
901         _setBaseURI(_projectBaseURI);
902         nextProjectId = nextProjectId.add(1);
903     }
904 
905     function purchaseToken(uint256 _projectId, uint numberOfTokens) public payable {
906         require(projects[_projectId].invocations.add(numberOfTokens) <= projects[_projectId].maxInvocations, "Purchase would exceed max supply of Tokens");
907         require(projects[_projectId].pricePerTokenInWei.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
908         for(uint i = 0; i < numberOfTokens; i++) {
909             _mintTokens(msg.sender, _projectId);
910         }
911     }
912 
913     function _mintTokens(address _to, uint256 _projectId) internal {
914 
915         uint256 tokenIdToBe = (_projectId * ONE_MILLION) + projects[_projectId].invocations;
916         _safeMint(_to, tokenIdToBe);
917         projects[_projectId].invocations = projects[_projectId].invocations.add(1);
918         tokenIdToProjectId[tokenIdToBe] = _projectId;
919         projectIdToTokenIds[_projectId].push(tokenIdToBe);
920     }
921     
922     function projectDetails(uint256 _projectId) view public returns (string memory projectName,  uint256 pricePerTokenInWei, uint256 maxInvocations, string memory projectBaseURI) {
923         projectName = projects[_projectId].name;
924         pricePerTokenInWei = projects[_projectId].pricePerTokenInWei;
925         maxInvocations = projects[_projectId].maxInvocations;
926         projectBaseURI = projects[_projectId].projectBaseURI;
927     }
928     
929     function updateProjectPricePerTokenInWei(uint256 _projectId, uint256 _pricePerTokenInWei) public onlyOwner {
930         projects[_projectId].pricePerTokenInWei = _pricePerTokenInWei;
931     }
932     
933     function updateProjectMaxInvocations(uint256 _projectId, uint256 _maxInvocations) public onlyOwner {
934         require(_maxInvocations > projects[_projectId].invocations, "You must set max invocations greater than current invocations");
935         projects[_projectId].maxInvocations = _maxInvocations;
936     }
937     
938     function updateProjectBaseURI(uint256 _projectId, string memory _newBaseURI) public onlyOwner {
939         projects[_projectId].projectBaseURI = _newBaseURI;
940     }
941     
942     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
943         return Strings.strConcat(projects[tokenIdToProjectId[_tokenId]].projectBaseURI, Strings.uint2str(_tokenId));
944     }
945 
946     function withdraw() public onlyOwner {
947         uint balance = address(this).balance;
948         msg.sender.transfer(balance);
949     }
950     
951 
952 }