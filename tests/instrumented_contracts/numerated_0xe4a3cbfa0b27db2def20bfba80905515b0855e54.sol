1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.8.0;
3 pragma abicoder v2;
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8     function _msgData() internal view virtual returns (bytes memory) {
9         this;
10         return msg.data;
11     }
12 }
13 interface IERC165 {
14     function supportsInterface(bytes4 interfaceId) external view returns (bool);
15 }
16 interface IERC721 is IERC165 {
17     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
18     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
19     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
20     function balanceOf(address owner) external view returns (uint256 balance);
21     function ownerOf(uint256 tokenId) external view returns (address owner);
22     function safeTransferFrom(address from, address to, uint256 tokenId) external;
23     function transferFrom(address from, address to, uint256 tokenId) external;
24     function approve(address to, uint256 tokenId) external;
25     function getApproved(uint256 tokenId) external view returns (address operator);
26     function setApprovalForAll(address operator, bool _approved) external;
27     function isApprovedForAll(address owner, address operator) external view returns (bool);
28     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
29 }
30 interface IERC721Metadata is IERC721 {
31     function name() external view returns (string memory);
32     function symbol() external view returns (string memory);
33     function tokenURI(uint256 tokenId) external view returns (string memory);
34 }
35 interface IERC721Enumerable is IERC721 {
36     function totalSupply() external view returns (uint256);
37     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
38     function tokenByIndex(uint256 index) external view returns (uint256);
39 }
40 interface IERC721Receiver {
41     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
42 }
43 abstract contract ERC165 is IERC165 {
44     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
45     mapping(bytes4 => bool) private _supportedInterfaces;
46     constructor () internal {
47         _registerInterface(_INTERFACE_ID_ERC165);
48     }
49     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
50         return _supportedInterfaces[interfaceId];
51     }
52     function _registerInterface(bytes4 interfaceId) internal virtual {
53         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
54         _supportedInterfaces[interfaceId] = true;
55     }
56 }
57 library SafeMath {
58     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         uint256 c = a + b;
60         if (c < a) return (false, 0);
61         return (true, c);
62     }
63     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         if (b > a) return (false, 0);
65         return (true, a - b);
66     }
67     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         if (a == 0) return (true, 0);
69         uint256 c = a * b;
70         if (c / a != b) return (false, 0);
71         return (true, c);
72     }
73     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         if (b == 0) return (false, 0);
75         return (true, a / b);
76     }
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         if (b == 0) return (false, 0);
79         return (true, a % b);
80     }
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a, "SafeMath: addition overflow");
84         return c;
85     }
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         require(b <= a, "SafeMath: subtraction overflow");
88         return a - b;
89     }
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         if (a == 0) return 0;
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94         return c;
95     }
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         require(b > 0, "SafeMath: division by zero");
98         return a / b;
99     }
100     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
101         require(b > 0, "SafeMath: modulo by zero");
102         return a % b;
103     }
104     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b <= a, errorMessage);
106         return a - b;
107     }
108     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
109         require(b > 0, errorMessage);
110         return a / b;
111     }
112     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
113         require(b > 0, errorMessage);
114         return a % b;
115     }
116 }
117 library Address {
118     function isContract(address account) internal view returns (bool) {
119         uint256 size;
120         // solhint-disable-next-line no-inline-assembly
121         assembly { size := extcodesize(account) }
122         return size > 0;
123     }
124     function sendValue(address payable recipient, uint256 amount) internal {
125         require(address(this).balance >= amount, "Address: insufficient balance");
126         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
127         (bool success, ) = recipient.call{ value: amount }("");
128         require(success, "Address: unable to send value, recipient may have reverted");
129     }
130     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
131       return functionCall(target, data, "Address: low-level call failed");
132     }
133     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, 0, errorMessage);
135     }
136     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
137         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
138     }
139     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
140         require(address(this).balance >= value, "Address: insufficient balance for call");
141         require(isContract(target), "Address: call to non-contract");
142         // solhint-disable-next-line avoid-low-level-calls
143         (bool success, bytes memory returndata) = target.call{ value: value }(data);
144         return _verifyCallResult(success, returndata, errorMessage);
145     }
146     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
147         return functionStaticCall(target, data, "Address: low-level static call failed");
148     }
149     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
150         require(isContract(target), "Address: static call to non-contract");
151         // solhint-disable-next-line avoid-low-level-calls
152         (bool success, bytes memory returndata) = target.staticcall(data);
153         return _verifyCallResult(success, returndata, errorMessage);
154     }
155     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
156         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
157     }
158     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
159         require(isContract(target), "Address: delegate call to non-contract");
160         // solhint-disable-next-line avoid-low-level-calls
161         (bool success, bytes memory returndata) = target.delegatecall(data);
162         return _verifyCallResult(success, returndata, errorMessage);
163     }
164     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
165         if (success) {
166             return returndata;
167         } else {
168             if (returndata.length > 0) {
169                 // solhint-disable-next-line no-inline-assembly
170                 assembly {
171                     let returndata_size := mload(returndata)
172                     revert(add(32, returndata), returndata_size)
173                 }
174             } else {
175                 revert(errorMessage);
176             }
177         }
178     }
179 }
180 library EnumerableSet {
181     struct Set {
182         bytes32[] _values;
183         mapping (bytes32 => uint256) _indexes;
184     }
185     function _add(Set storage set, bytes32 value) private returns (bool) {
186         if (!_contains(set, value)) {
187             set._values.push(value);
188             set._indexes[value] = set._values.length;
189             return true;
190         } else {
191             return false;
192         }
193     }
194     function _remove(Set storage set, bytes32 value) private returns (bool) {
195         uint256 valueIndex = set._indexes[value];
196         if (valueIndex != 0) {
197             uint256 toDeleteIndex = valueIndex - 1;
198             uint256 lastIndex = set._values.length - 1;
199             bytes32 lastvalue = set._values[lastIndex];
200             set._values[toDeleteIndex] = lastvalue;
201             set._indexes[lastvalue] = toDeleteIndex + 1;
202             set._values.pop();
203             delete set._indexes[value];
204             return true;
205         } else {
206             return false;
207         }
208     }
209     function _contains(Set storage set, bytes32 value) private view returns (bool) {
210         return set._indexes[value] != 0;
211     }
212     function _length(Set storage set) private view returns (uint256) {
213         return set._values.length;
214     }
215     function _at(Set storage set, uint256 index) private view returns (bytes32) {
216         require(set._values.length > index, "EnumerableSet: index out of bounds");
217         return set._values[index];
218     }
219     struct Bytes32Set {
220         Set _inner;
221     }
222     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
223         return _add(set._inner, value);
224     }
225     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
226         return _remove(set._inner, value);
227     }
228     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
229         return _contains(set._inner, value);
230     }
231     function length(Bytes32Set storage set) internal view returns (uint256) {
232         return _length(set._inner);
233     }
234     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
235         return _at(set._inner, index);
236     }
237     struct AddressSet {
238         Set _inner;
239     }
240     function add(AddressSet storage set, address value) internal returns (bool) {
241         return _add(set._inner, bytes32(uint256(uint160(value))));
242     }
243     function remove(AddressSet storage set, address value) internal returns (bool) {
244         return _remove(set._inner, bytes32(uint256(uint160(value))));
245     }
246     function contains(AddressSet storage set, address value) internal view returns (bool) {
247         return _contains(set._inner, bytes32(uint256(uint160(value))));
248     }
249     function length(AddressSet storage set) internal view returns (uint256) {
250         return _length(set._inner);
251     }
252     function at(AddressSet storage set, uint256 index) internal view returns (address) {
253         return address(uint160(uint256(_at(set._inner, index))));
254     }
255     struct UintSet {
256         Set _inner;
257     }
258     function add(UintSet storage set, uint256 value) internal returns (bool) {
259         return _add(set._inner, bytes32(value));
260     }
261     function remove(UintSet storage set, uint256 value) internal returns (bool) {
262         return _remove(set._inner, bytes32(value));
263     }
264     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
265         return _contains(set._inner, bytes32(value));
266     }
267     function length(UintSet storage set) internal view returns (uint256) {
268         return _length(set._inner);
269     }
270     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
271         return uint256(_at(set._inner, index));
272     }
273 }
274 library EnumerableMap {
275     struct MapEntry {
276         bytes32 _key;
277         bytes32 _value;
278     }
279     struct Map {
280         MapEntry[] _entries;
281         mapping (bytes32 => uint256) _indexes;
282     }
283     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
284         uint256 keyIndex = map._indexes[key];
285         if (keyIndex == 0) {
286             map._entries.push(MapEntry({ _key: key, _value: value }));
287             map._indexes[key] = map._entries.length;
288             return true;
289         } else {
290             map._entries[keyIndex - 1]._value = value;
291             return false;
292         }
293     }
294     function _remove(Map storage map, bytes32 key) private returns (bool) {
295         uint256 keyIndex = map._indexes[key];
296         if (keyIndex != 0) {
297             uint256 toDeleteIndex = keyIndex - 1;
298             uint256 lastIndex = map._entries.length - 1;
299             MapEntry storage lastEntry = map._entries[lastIndex];
300             map._entries[toDeleteIndex] = lastEntry;
301             map._indexes[lastEntry._key] = toDeleteIndex + 1;
302             map._entries.pop();
303             delete map._indexes[key];
304             return true;
305         } else {
306             return false;
307         }
308     }
309     function _contains(Map storage map, bytes32 key) private view returns (bool) {
310         return map._indexes[key] != 0;
311     }
312     function _length(Map storage map) private view returns (uint256) {
313         return map._entries.length;
314     }
315     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
316         require(map._entries.length > index, "EnumerableMap: index out of bounds");
317         MapEntry storage entry = map._entries[index];
318         return (entry._key, entry._value);
319     }
320     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
321         uint256 keyIndex = map._indexes[key];
322         if (keyIndex == 0) return (false, 0);
323         return (true, map._entries[keyIndex - 1]._value);
324     }
325     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
326         uint256 keyIndex = map._indexes[key];
327         require(keyIndex != 0, "EnumerableMap: nonexistent key");
328         return map._entries[keyIndex - 1]._value;
329     }
330     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
331         uint256 keyIndex = map._indexes[key];
332         require(keyIndex != 0, errorMessage);
333         return map._entries[keyIndex - 1]._value;
334     }
335     struct UintToAddressMap {
336         Map _inner;
337     }
338     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
339         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
340     }
341     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
342         return _remove(map._inner, bytes32(key));
343     }
344     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
345         return _contains(map._inner, bytes32(key));
346     }
347     function length(UintToAddressMap storage map) internal view returns (uint256) {
348         return _length(map._inner);
349     }
350     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
351         (bytes32 key, bytes32 value) = _at(map._inner, index);
352         return (uint256(key), address(uint160(uint256(value))));
353     }
354     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
355         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
356         return (success, address(uint160(uint256(value))));
357     }
358     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
359         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
360     }
361     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
362         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
363     }
364 }
365 library Strings {
366     function toString(uint256 value) internal pure returns (string memory) {
367         if (value == 0) {
368             return "0";
369         }
370         uint256 temp = value;
371         uint256 digits;
372         while (temp != 0) {
373             digits++;
374             temp /= 10;
375         }
376         bytes memory buffer = new bytes(digits);
377         uint256 index = digits - 1;
378         temp = value;
379         while (temp != 0) {
380             buffer[index--] = bytes1(uint8(48 + temp % 10));
381             temp /= 10;
382         }
383         return string(buffer);
384     }
385 }
386 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
387     using SafeMath for uint256;
388     using Address for address;
389     using EnumerableSet for EnumerableSet.UintSet;
390     using EnumerableMap for EnumerableMap.UintToAddressMap;
391     using Strings for uint256;
392     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
393     mapping (address => EnumerableSet.UintSet) private _holderTokens;
394     EnumerableMap.UintToAddressMap private _tokenOwners;
395     mapping (uint256 => address) private _tokenApprovals;
396     mapping (address => mapping (address => bool)) private _operatorApprovals;
397     string private _name;
398     string private _symbol;
399     mapping (uint256 => string) private _tokenURIs;
400     string private _baseURI;
401     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
402     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
403     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
404     constructor (string memory name_, string memory symbol_) public {
405         _name = name_;
406         _symbol = symbol_;
407         _registerInterface(_INTERFACE_ID_ERC721);
408         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
409         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
410     }
411     function balanceOf(address owner) public view virtual override returns (uint256) {
412         require(owner != address(0), "ERC721: balance query for the zero address");
413         return _holderTokens[owner].length();
414     }
415     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
416         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
417     }
418     function name() public view virtual override returns (string memory) {
419         return _name;
420     }
421     function symbol() public view virtual override returns (string memory) {
422         return _symbol;
423     }
424     function _setName(string memory name_) internal virtual {
425         _name = name_;
426     }
427     function _setSymbol(string memory symbol_) internal virtual {
428         _symbol = symbol_;
429     }
430     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
431         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
432         string memory _tokenURI = _tokenURIs[tokenId];
433         string memory base = baseURI();
434         if (bytes(base).length == 0) {
435             return _tokenURI;
436         }
437         if (bytes(_tokenURI).length > 0) {
438             return string(abi.encodePacked(base, _tokenURI));
439         }
440         return string(abi.encodePacked(base, tokenId.toString()));
441     }
442     function baseURI() public view virtual returns (string memory) {
443         return _baseURI;
444     }
445     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
446         return _holderTokens[owner].at(index);
447     }
448     function totalSupply() public view virtual override returns (uint256) {
449         return _tokenOwners.length();
450     }
451     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
452         (uint256 tokenId, ) = _tokenOwners.at(index);
453         return tokenId;
454     }
455     function approve(address to, uint256 tokenId) public virtual override {
456         address owner = ERC721.ownerOf(tokenId);
457         require(to != owner, "ERC721: approval to current owner");
458         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
459             "ERC721: approve caller is not owner nor approved for all"
460         );
461         _approve(to, tokenId);
462     }
463     function getApproved(uint256 tokenId) public view virtual override returns (address) {
464         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
465         return _tokenApprovals[tokenId];
466     }
467     function setApprovalForAll(address operator, bool approved) public virtual override {
468         require(operator != _msgSender(), "ERC721: approve to caller");
469         _operatorApprovals[_msgSender()][operator] = approved;
470         emit ApprovalForAll(_msgSender(), operator, approved);
471     }
472     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
473         return _operatorApprovals[owner][operator];
474     }
475     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
476         //solhint-disable-next-line max-line-length
477         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
478         _transfer(from, to, tokenId);
479     }
480     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
481         safeTransferFrom(from, to, tokenId, "");
482     }
483     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
484         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
485         _safeTransfer(from, to, tokenId, _data);
486     }
487     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
488         _transfer(from, to, tokenId);
489         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
490     }
491     function _exists(uint256 tokenId) internal view virtual returns (bool) {
492         return _tokenOwners.contains(tokenId);
493     }
494     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
495         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
496         address owner = ERC721.ownerOf(tokenId);
497         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
498     }
499     function _safeMint(address to, uint256 tokenId) internal virtual {
500         _safeMint(to, tokenId, "");
501     }
502     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
503         _mint(to, tokenId);
504         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
505     }
506     function _mint(address to, uint256 tokenId) internal virtual {
507         require(to != address(0), "ERC721: mint to the zero address");
508         require(!_exists(tokenId), "ERC721: token already minted");
509         _beforeTokenTransfer(address(0), to, tokenId);
510         _holderTokens[to].add(tokenId);
511         _tokenOwners.set(tokenId, to);
512         emit Transfer(address(0), to, tokenId);
513     }
514     function _burn(uint256 tokenId) internal virtual {
515         address owner = ERC721.ownerOf(tokenId);
516         _beforeTokenTransfer(owner, address(0), tokenId);
517         _approve(address(0), tokenId);
518         if (bytes(_tokenURIs[tokenId]).length != 0) {
519             delete _tokenURIs[tokenId];
520         }
521         _holderTokens[owner].remove(tokenId);
522         _tokenOwners.remove(tokenId);
523         emit Transfer(owner, address(0), tokenId);
524     }
525     function _transfer(address from, address to, uint256 tokenId) internal virtual {
526         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
527         require(to != address(0), "ERC721: transfer to the zero address");
528         _beforeTokenTransfer(from, to, tokenId);
529         _approve(address(0), tokenId);
530         _holderTokens[from].remove(tokenId);
531         _holderTokens[to].add(tokenId);
532         _tokenOwners.set(tokenId, to);
533         emit Transfer(from, to, tokenId);
534     }
535     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
536         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
537         _tokenURIs[tokenId] = _tokenURI;
538     }
539     function _setBaseURI(string memory baseURI_) internal virtual {
540         _baseURI = baseURI_;
541     }
542     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
543         private returns (bool)
544     {
545         if (!to.isContract()) {
546             return true;
547         }
548         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
549             IERC721Receiver(to).onERC721Received.selector,
550             _msgSender(),
551             from,
552             tokenId,
553             _data
554         ), "ERC721: transfer to non ERC721Receiver implementer");
555         bytes4 retval = abi.decode(returndata, (bytes4));
556         return (retval == _ERC721_RECEIVED);
557     }
558     function _approve(address to, uint256 tokenId) internal virtual {
559         _tokenApprovals[tokenId] = to;
560         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
561     }
562     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
563 }
564 abstract contract Ownable is Context {
565     address private _owner;
566     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
567     constructor () internal {
568         address msgSender = _msgSender();
569         _owner = msgSender;
570         emit OwnershipTransferred(address(0), msgSender);
571     }
572     function owner() public view virtual returns (address) {
573         return _owner;
574     }
575     modifier onlyOwner() {
576         require(owner() == _msgSender(), "Ownable: caller is not the owner");
577         _;
578     }
579     function renounceOwnership() public virtual onlyOwner {
580         emit OwnershipTransferred(_owner, address(0));
581         _owner = address(0);
582     }
583     function transferOwnership(address newOwner) public virtual onlyOwner {
584         require(newOwner != address(0), "Ownable: new owner is the zero address");
585         emit OwnershipTransferred(_owner, newOwner);
586         _owner = newOwner;
587     }
588 }
589 
590 contract WannaPanda is ERC721, Ownable {
591     using SafeMath for uint256;
592     uint256 public PRICE = 70000000000000000;
593     uint public MAX_PURCHASE = 25;
594     uint256 public MAX_PANDAS = 10000;
595     uint256 public DAYS = 5;
596     bool public SELLING = false;
597     bool public RESERVED = true;
598     bool public CHECK_WHITELISTING = true;
599     mapping(address => bool) public whitelister10;
600     mapping(address => bool) public whitelister25;
601     uint256 public whitelisters10Length;
602     uint256 public whitelisters25Length;
603     struct userMintInfo {
604         uint256 mintTimestamp;
605         uint minted;
606     }
607     mapping(address => userMintInfo) userMints;
608     event MintedIDs(uint[] array);
609     constructor() ERC721("WannaPanda", "WP") {}
610     function getSeconds() public view returns(uint256) {
611         uint HOURS = DAYS.mul(24);
612         uint SECONDS = HOURS.mul(3600);
613         return SECONDS;
614     }
615     function checkUserMinting(address userAddress, uint256 timeNow) public view returns(uint) {
616         userMintInfo storage userMint = userMints[userAddress];
617         bool inTime = checkInTime(userAddress, timeNow);
618         if(inTime) {
619             return userMint.minted;
620         }
621         else {
622             return 0;
623         }
624     }
625     function checkInTime(address userAddress, uint256 timeNow) public view returns(bool) {
626         userMintInfo storage userMint = userMints[userAddress];
627         uint256 mintTimestamp = userMint.mintTimestamp;
628         uint256 _seconds = getSeconds();
629         if(timeNow - mintTimestamp < _seconds) {
630             return true;
631         }
632         else {
633             return false;
634         }
635     }
636     function setUserMinting(address userAddress, uint minted, bool inTime, uint256 timeNow) internal {
637         userMintInfo storage userMint = userMints[userAddress];
638         userMint.minted = minted;
639         if(!inTime) {
640             userMint.mintTimestamp = timeNow;
641         }
642     }
643     function withdraw() public onlyOwner {
644         uint balance = address(this).balance;
645         msg.sender.transfer(balance);
646     }
647     function togglePandaPurchase() public onlyOwner {
648         SELLING = !SELLING;
649     }
650     function setDays(uint _days) public onlyOwner {
651         DAYS = _days;
652     }
653     function setMaxPandas(uint256 maxPandas) public onlyOwner {
654         MAX_PANDAS = maxPandas;
655     }
656     function getMaxPandas() public view returns(uint256) {
657         return MAX_PANDAS;
658     }
659     function setMaxPurchase(uint256 maxPurchase) public onlyOwner {
660         MAX_PURCHASE = maxPurchase;
661     }
662     function setBaseURI(string memory baseURI) public onlyOwner {
663         _setBaseURI(baseURI);
664     }
665     function setTokenURI(uint256 tokenId, string memory _tokenURI) public onlyOwner {
666         _setTokenURI(tokenId, _tokenURI);
667     }
668     function setTokenURIMultiple(uint256[] memory tokenId, string[] memory _tokenURI) public onlyOwner {
669         for(uint x=0; x<tokenId.length; x++ ) {
670             _setTokenURI(tokenId[x], _tokenURI[x]);
671         }
672     }
673     function toggleWhiteListing() public onlyOwner {
674         CHECK_WHITELISTING = !CHECK_WHITELISTING;
675     }
676     function isWhiteLister(address _beneficiary) public view returns (uint) {
677         if(whitelister10[_beneficiary]) {
678             return 10;
679         }
680         if(whitelister25[_beneficiary]) {
681             return 25;
682         }
683         return 0;
684     }
685     function addWhitelisters10(address[] memory _whitelister) external onlyOwner {
686         for(uint8 i=0; i<_whitelister.length;i++) {
687             if(isWhiteLister(_whitelister[i]) == 0) {
688                 whitelister10[_whitelister[i]] = true;
689                 whitelisters10Length++;
690             }
691         }
692     }
693     function addWhitelisters25(address[] memory _whitelister) external onlyOwner {
694         for(uint8 i=0; i<_whitelister.length;i++){
695             if(isWhiteLister(_whitelister[i]) == 0) {
696                 whitelister25[_whitelister[i]] = true;
697                 whitelisters25Length++;
698             }
699         }
700     }
701     function removeWhitelisters10(address[] memory _whitelister) external onlyOwner {
702         for(uint8 i=0; i<_whitelister.length;i++) {
703             if(isWhiteLister(_whitelister[i]) == 10) {
704                 whitelister10[_whitelister[i]] = false;
705                 whitelisters10Length--;
706             }
707         }
708     }
709     function removeWhitelisters25(address[] memory _whitelister) external onlyOwner {
710         for(uint8 i=0; i<_whitelister.length;i++) {
711             if(isWhiteLister(_whitelister[i]) == 25) {
712                 whitelister25[_whitelister[i]] = false;
713                 whitelisters25Length--;
714             }
715         }
716     }
717     function mintPandas(uint numberOfTokens, string memory revealingImage) public payable {
718         uint256 timeNow = block.timestamp;
719         uint[] memory array = new uint[](numberOfTokens);
720         require(SELLING, "Panda sale is not active yet");
721         uint alreadyMintedInTime = checkUserMinting(msg.sender, timeNow);
722         bool inTime = checkInTime(msg.sender, timeNow);
723         string memory message;
724         if(CHECK_WHITELISTING) {
725             uint maxMintsAllowed = isWhiteLister(msg.sender);
726             require(maxMintsAllowed > 0, "You are not whitelisted by the owner.");
727             if(maxMintsAllowed == 10) {
728                 message = "Can not mint more than 10 tokens per 5 days";
729             }
730             else if(maxMintsAllowed == 25) {
731                 message = "Can not mint more than 25 tokens per 5 days";
732             }
733             require(numberOfTokens <= maxMintsAllowed, message);
734             require(numberOfTokens.add(alreadyMintedInTime) <= maxMintsAllowed, message);
735         }
736         else {
737             require(numberOfTokens <= MAX_PURCHASE, "Can not mint more than 10 tokens at a time");
738         }
739         
740         require(totalSupply().add(numberOfTokens) <= MAX_PANDAS, "Purchase would exceed max supply of Pandas");
741         require(PRICE.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
742         for(uint i = 0; i < numberOfTokens; i++) {
743             uint mintIndex = totalSupply();
744             array[i] = mintIndex;
745             if (totalSupply() < MAX_PANDAS) {
746                 _safeMint(msg.sender, mintIndex);
747                 _setTokenURI(mintIndex, revealingImage);
748             }
749         }
750         setUserMinting(msg.sender, numberOfTokens.add(alreadyMintedInTime), inTime, timeNow);
751         emit MintedIDs(array);
752     }
753     function reservePandas(uint total, string memory revealingImage) external onlyOwner {
754         require(RESERVED, "You have already reserved the Pandas");
755         uint[] memory array = new uint[](total);
756         require(totalSupply().add(total) <= MAX_PANDAS, "Mint would exceed max supply of Pandas");
757         for(uint i = 0; i < total; i++) {
758             uint mintIndex = totalSupply();
759             array[i] = mintIndex;
760             if (totalSupply() < MAX_PANDAS) {
761                 _safeMint(msg.sender, mintIndex);
762                 _setTokenURI(mintIndex, revealingImage);
763             }
764         }
765         RESERVED = false;
766         emit MintedIDs(array);
767     }
768 }