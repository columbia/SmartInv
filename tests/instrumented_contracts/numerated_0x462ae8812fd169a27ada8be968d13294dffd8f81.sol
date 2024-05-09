1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0OOkOXWMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWXK0kxolc;,''....cXMMMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNNXKK0000OOkkkkxxddoolc:;,'............,xNMMMMMMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXkol:;;,'''''............................;o0WMMMMMMMMMMMMMMMMMMMM
11 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWd'......................................oXWMMMMMMMMMMMMMMMMMMMMMM
12 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKd,.............'''''''''''''''''''.....:llldKMMMMMMMMMMMMMMMMMMM
13 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXXKXNWO,...'''''''''''''''''''..............,:coxKWMMMMMMMMMMMMMMMMMM
14 MMMMMMMMMMMMMMMMMMMMMMMMMMMMN0xollllxx,..........,:clc;,',;';;',,'.';:cc;'.oKNNNWWMMMMMMMMMMMMMMMMMM
15 MMMMMMMMMMMMMMMMMMMMMMMMMMMXxlloddolc;........,:lk00K0OxooolxOOOOkxdxxkdc,.'cooodONMMMMMMMMMMMMMMMMM
16 MMMMMMMMMMMMMMMMMMMMMMMMMMXxodkOOOOkdc......,ldk0000koc::;,,:x00koc:;;cl;...'ldolo0MMMMMMMMMMMMMMMMM
17 MMMMMMMMMMMMMMMMMMMMMMMMMXxodkO0000Okd:....,lx0K0kdl:;;;:;,,,o0koc:,':c,....'d0OdlOWMMMMMMMMMMMMMMMM
18 MMMMMMMMMMMMMMMMMMMMMMMMNkolxO0KK0O000k:...;lx0K0kdl:;::;;;;:dOxdxoccoc. .:l;l0Ool0WMMMMMMMMMMMMMMMM
19 MMMMMMMMMMMMMMMMMMMMMMMMXxllx0KK0OOK0K0c..,cclk0KKK0kocccc:ldkkkxddxxl,.'d00ddkxokNMMMMMMMMMMMMMMMMM
20 MMMMMMMMMMMMMMMMMMMMMMMMWOoldOKK0OOKK0d'.,ll::codxxkOkdodxkOO00Oxxkxxdocd00OOxookNMMMMMMMMMMMMMMMMMM
21 MMMMMMMMMMMMMMMMMMMMMMMMMXkoox0K00OOkl:ccloolccc::lx0x:..,cdO0KOdl:''cxkk00kddkKWMMMMMMMMMMMMMMMMMMM
22 MMMMMMMMMMMMMMMMMMMMMMMMMMXkoldkO000kxkdclooooolc::loo:,,:oxkO0Oxdoc:cooxkxxOXWMMMMMMMMMMMMMMMMMMMMM
23 MMMMMMMMMMMMMMMMMMMMMMMMMMMN0xoooddxxdo:;looooooolllcccoxO0K000OO00OkdolokOXWMMMMMMMMMMMMMMMMMMMMMMM
24 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMNXXKKKKKKKOdooooooooooooxO0KKKKKKKOO0KKK0kdOWMMMMMMMMMMMMMMMMMMMMMMMMMM
25 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0oooooooooooox0KKKKKK0KK0OO0KKKK0KWMMMMMMMMMMMMMMMMMMMMMMMMMM
26 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNkollooooooodk0KKKKKKKKKKK0kk00K00KXWMMMMMMMMMMMMMMMMMMMMMMMMM
27 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXdlllooooook00K000OOOOOOOOOkdoollclodONMMMMMMMMMMMMMMMMMMMMMMM
28 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0cclloooodkOOkdlc::;;::::::::ccldxkOxokNMMMMMMMMMMMMMMMMMMMMMM
29 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWO:;ccloookkxdxddxddxxdxxxOkkO00KKkk0Odl0MMMMMMMMMMMMMMMMMMMMMM
30 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNk;;:;:oxkdooxxdkdx00kOKKKOk00OO0OkOxldXMMMMMMMMMMMMMMMMMMMMMM
31 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXl,;'.:x0koldkkOxk0kO0O0KOOKO0OkxollxXWMMMMMMMMMMMMMMMMMMMMMM
32 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNxlc;';lO0kxdooddxOkkOxxkdooc::cclldKMMMMMMMMMMMMMMMMMMMMMMMM
33 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxoollllldO000kdollcccccclccclodddxKWMMMMMMMMMMMMMMMMMMMMMMMM
34 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxooooool:::cdkOOOOOOkkkkxooodxkOKWMMMMMMMMMMMMMMMMMMMMMMMMMM
35 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0dooooooooc:;,,;;:cccclodxk0XNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
36 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNkoooooooooooollc:oOO00XNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
37 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX0000kdoooooooooookNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
38 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW00NWNXOdooooooooooodKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
39 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXo,ckOOxodkkooooooooood0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
40 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWN0d;...',:cloddoooooooollllodxOKXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
41 MMMMMMMMMMMMMMMMMMMMMMMMMMMWN0xo:,'.''''..',:cooooooooolllc,..,;:cxKNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
42 MMMMMMMMMMMMMMMMMMMMMMMMWNXko:;,,,,,,,,,''''',;:looooooooo:''',,:oOXXKOKWMMMMMMMMMMMMMMMMMMMMMMMMMMM
43 MMMMMMMMMMMMMMMMMMMMMMNK0XXXK00OOkkxdol:,,,''''',;:clooooc,'',:xKXNNNNK00XWMMMMMMMMMMMMMMMMMMMMMMMMM
44 MMMMMMMMMMMMMMMMMMMMMXdkXNNNNNNNNNNXOolc:::;;,,'...',:loc;...,:ldx0NNNNNKkKWMMMMMMMMMMMMMMMMMMMMMMMM
45 MMMMMMMMMMMMMMMMMMMW0llOXNNNNNNNNN0dc::::::::::;.......,,....';:;:xNNNNNNOxKMMMMMMMMMMMMMMMMMMMMMMMM
46 MMMMMMMMMMMMMMMMMMM0cl0XNNNNXKKK0dc:::::::::::::;............';::;cxKNNNNKdOWMMMMMMMMMMMMMMMMMMMMMMM
47 MMMMMMMMMMMMMMMMMMXocONNNNNNXOxdc;:::::::::::::::,'..........,::::::lkXNNXxdXMMMMMMMMMMMMMMMMMMMMMMM
48 MMMMMMMMMMMMMMMMMMKlcONNNNNNXkc;;:::::::::::::::::;,.........;::::::::o0NNxckMMMMMMMMMMMMMMMMMMMMMMM
49 MMMMMMMMMMMMMMMMMMNd:xXNNNNNNk;,::::::::::::::::::::,....'..':::::::::;cOXdlKMMMMMMMMMMMMMMMMMMMMMMM
50 MMMMMMMMMMMMMMMMMMMO::ONNNNNXd,;:::::::::::::::::::::;'..'.';::::::::::,ldoKMMMMMMMMMMMMMMMMMMMMMMMM
51 MMMMMMMMMMMMMMMMMMM0c;oKNNNN0l',;::::::;;;:::::::::::::,'..,:::::::::::,cloXMMMMMMMMMMMMMMMMMMMMMMMM
52 MMMMMMMMMMMMMMMMMMMKl:o0NNNX0l,',;;:::::;,,;;:::::::::::;,.,:::::::::;;lxldNMMMMMMMMMMMMMMMMMMMMMMMM
53 MMMMMMMMMMMMMMMMMMMXd;cONNNNXd;',;::::::::;,,,,,,,,;;;::::,,;::::;;:clxKxl0MMMMMMMMMMMMMMMMMMMMMMMMM
54 MMMMMMMMMMMMMMMMMMMWx;:dXNNNXk:',;::::::::::;;,,,,,;::::::;;;::::,;okOK0loXMMMMMMMMMMMMMMMMMMMMMMMMM
55 */
56 library Counters {
57     struct Counter {
58 
59         uint256 _value; // default: 0
60     }
61 
62     function current(Counter storage counter) internal view returns (uint256) {
63         return counter._value;
64     }
65 
66     function increment(Counter storage counter) internal {
67         unchecked {
68             counter._value += 1;
69         }
70     }
71 
72     function decrement(Counter storage counter) internal {
73         uint256 value = counter._value;
74         require(value > 0, "Counter:decrement overflow");
75         unchecked {
76             counter._value = value - 1;
77         }
78     }
79 
80     function reset(Counter storage counter) internal {
81         counter._value = 0;
82     }
83 }
84 
85 pragma solidity ^0.8.0;
86 
87 library Strings {
88     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
89 
90     /**
91      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
92      */
93     function toString(uint256 value) internal pure returns (string memory) {
94         // Inspired by OraclizeAPI's implementation - MIT licence
95         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
96 
97         if (value == 0) {
98             return "0";
99         }
100         uint256 temp = value;
101         uint256 digits;
102         while (temp != 0) {
103             digits++;
104             temp /= 10;
105         }
106         bytes memory buffer = new bytes(digits);
107         while (value != 0) {
108             digits -= 1;
109             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
110             value /= 10;
111         }
112         return string(buffer);
113     }
114 
115     function toHexString(uint256 value) internal pure returns (string memory) {
116         if (value == 0) {
117             return "0x00";
118         }
119         uint256 temp = value;
120         uint256 length = 0;
121         while (temp != 0) {
122             length++;
123             temp >>= 8;
124         }
125         return toHexString(value, length);
126     }
127 
128     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
129         bytes memory buffer = new bytes(2 * length + 2);
130         buffer[0] = "0";
131         buffer[1] = "x";
132         for (uint256 i = 2 * length + 1; i > 1; --i) {
133             buffer[i] = _HEX_SYMBOLS[value & 0xf];
134             value >>= 4;
135         }
136         require(value == 0, "Strings: hex length insufficient");
137         return string(buffer);
138     }
139 }
140 
141 pragma solidity ^0.8.0;
142 
143 abstract contract Context {
144     function _msgSender() internal view virtual returns (address) {
145         return msg.sender;
146     }
147 
148     function _msgData() internal view virtual returns (bytes calldata) {
149         return msg.data;
150     }
151 }
152 
153 pragma solidity ^0.8.0;
154 
155 abstract contract Ownable is Context {
156     address private _owner;
157 
158     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
159 
160     constructor() {
161         _transferOwnership(_msgSender());
162     }
163 
164     function owner() public view virtual returns (address) {
165         return _owner;
166     }
167 
168     modifier onlyOwner() {
169         require(owner() == _msgSender(), "Ownable: caller is not the owner");
170         _;
171     }
172 
173     function renounceOwnership() public virtual onlyOwner {
174         _transferOwnership(address(0));
175     }
176 
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         _transferOwnership(newOwner);
180     }
181 
182     function _transferOwnership(address newOwner) internal virtual {
183         address oldOwner = _owner;
184         _owner = newOwner;
185         emit OwnershipTransferred(oldOwner, newOwner);
186     }
187 }
188 
189 pragma solidity ^0.8.1;
190 
191 library Address {
192 
193     function isContract(address account) internal view returns (bool) {
194 
195         return account.code.length > 0;
196     }
197 
198     function sendValue(address payable recipient, uint256 amount) internal {
199         require(address(this).balance >= amount, "Address: insufficient balance");
200 
201         (bool success, ) = recipient.call{value: amount}("");
202         require(success, "Address: unable to send value, recipient may have reverted");
203     }
204 
205     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
206         return functionCall(target, data, "Address: low-level call failed");
207     }
208 
209     function functionCall(
210         address target,
211         bytes memory data,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         return functionCallWithValue(target, data, 0, errorMessage);
215     }
216 
217     function functionCallWithValue(
218         address target,
219         bytes memory data,
220         uint256 value
221     ) internal returns (bytes memory) {
222         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
223     }
224 
225     function functionCallWithValue(
226         address target,
227         bytes memory data,
228         uint256 value,
229         string memory errorMessage
230     ) internal returns (bytes memory) {
231         require(address(this).balance >= value, "Address: insufficient balance for call");
232         require(isContract(target), "Address: call to non-contract");
233 
234         (bool success, bytes memory returndata) = target.call{value: value}(data);
235         return verifyCallResult(success, returndata, errorMessage);
236     }
237 
238     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
239         return functionStaticCall(target, data, "Address: low-level static call failed");
240     }
241 
242     function functionStaticCall(
243         address target,
244         bytes memory data,
245         string memory errorMessage
246     ) internal view returns (bytes memory) {
247         require(isContract(target), "Address: static call to non-contract");
248 
249         (bool success, bytes memory returndata) = target.staticcall(data);
250         return verifyCallResult(success, returndata, errorMessage);
251     }
252 
253     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
255     }
256 
257     function functionDelegateCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         require(isContract(target), "Address: delegate call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.delegatecall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     function verifyCallResult(
269         bool success,
270         bytes memory returndata,
271         string memory errorMessage
272     ) internal pure returns (bytes memory) {
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 assembly {
281                     let returndata_size := mload(returndata)
282                     revert(add(32, returndata), returndata_size)
283                 }
284             } else {
285                 revert(errorMessage);
286             }
287         }
288     }
289 }
290 
291 pragma solidity ^0.8.0;
292 
293 interface IERC721Receiver {
294 
295     function onERC721Received(
296         address operator,
297         address from,
298         uint256 tokenId,
299         bytes calldata data
300     ) external returns (bytes4);
301 }
302 
303 pragma solidity ^0.8.0;
304 
305 interface IERC165 {
306 
307     function supportsInterface(bytes4 interfaceId) external view returns (bool);
308 }
309 
310 pragma solidity ^0.8.0;
311 
312 abstract contract ERC165 is IERC165 {
313 
314     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
315         return interfaceId == type(IERC165).interfaceId;
316     }
317 }
318 
319 pragma solidity ^0.8.0;
320 
321 interface IERC721 is IERC165 {
322 
323     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
324 
325     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
326 
327     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
328 
329     function balanceOf(address owner) external view returns (uint256 balance);
330 
331     function ownerOf(uint256 tokenId) external view returns (address owner);
332 
333     function safeTransferFrom(
334         address from,
335         address to,
336         uint256 tokenId
337     ) external;
338 
339     function transferFrom(
340         address from,
341         address to,
342         uint256 tokenId
343     ) external;
344 
345     function approve(address to, uint256 tokenId) external;
346 
347     function getApproved(uint256 tokenId) external view returns (address operator);
348 
349     function setApprovalForAll(address operator, bool _approved) external;
350 
351     function isApprovedForAll(address owner, address operator) external view returns (bool);
352 
353     function safeTransferFrom(
354         address from,
355         address to,
356         uint256 tokenId,
357         bytes calldata data
358     ) external;
359 }
360 
361 pragma solidity ^0.8.0;
362 
363 interface IERC721Enumerable is IERC721 {
364 
365     function totalSupply() external view returns (uint256);
366 
367     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
368 
369     function tokenByIndex(uint256 index) external view returns (uint256);
370 }
371 
372 pragma solidity ^0.8.0;
373 
374 interface IERC721Metadata is IERC721 {
375 
376     function name() external view returns (string memory);
377 
378     function symbol() external view returns (string memory);
379 
380     function tokenURI(uint256 tokenId) external view returns (string memory);
381 }
382 
383 pragma solidity ^0.8.0;
384 
385 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
386     using Address for address;
387     using Strings for uint256;
388 
389     // Token name
390     string private _name;
391 
392     // Token symbol
393     string private _symbol;
394 
395     // Mapping from token ID to owner address
396     mapping(uint256 => address) private _owners;
397 
398     // Mapping owner address to token count
399     mapping(address => uint256) private _balances;
400 
401     // Mapping from token ID to approved address
402     mapping(uint256 => address) private _tokenApprovals;
403 
404     // Mapping from owner to operator approvals
405     mapping(address => mapping(address => bool)) private _operatorApprovals;
406 
407     constructor(string memory name_, string memory symbol_) {
408         _name = name_;
409         _symbol = symbol_;
410     }
411 
412     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
413         return
414             interfaceId == type(IERC721).interfaceId ||
415             interfaceId == type(IERC721Metadata).interfaceId ||
416             super.supportsInterface(interfaceId);
417     }
418 
419     function balanceOf(address owner) public view virtual override returns (uint256) {
420         require(owner != address(0), "ERC721: balance query for the zero address");
421         return _balances[owner];
422     }
423 
424     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
425         address owner = _owners[tokenId];
426         require(owner != address(0), "ERC721: owner query for nonexistent token");
427         return owner;
428     }
429 
430     function name() public view virtual override returns (string memory) {
431         return _name;
432     }
433 
434     function symbol() public view virtual override returns (string memory) {
435         return _symbol;
436     }
437 
438     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
439         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
440 
441         string memory baseURI = _baseURI();
442         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
443     }
444 
445     function _baseURI() internal view virtual returns (string memory) {
446         return "";
447     }
448 
449     function approve(address to, uint256 tokenId) public virtual override {
450         address owner = ERC721.ownerOf(tokenId);
451         require(to != owner, "ERC721: approval to current owner");
452 
453         require(
454             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
455             "ERC721: approve caller is not owner nor approved for all"
456         );
457 
458         _approve(to, tokenId);
459     }
460 
461     function getApproved(uint256 tokenId) public view virtual override returns (address) {
462         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
463 
464         return _tokenApprovals[tokenId];
465     }
466 
467     function setApprovalForAll(address operator, bool approved) public virtual override {
468         _setApprovalForAll(_msgSender(), operator, approved);
469     }
470 
471     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
472         return _operatorApprovals[owner][operator];
473     }
474 
475     function transferFrom(
476         address from,
477         address to,
478         uint256 tokenId
479     ) public virtual override {
480         //solhint-disable-next-line max-line-length
481         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
482 
483         _transfer(from, to, tokenId);
484     }
485 
486     function safeTransferFrom(
487         address from,
488         address to,
489         uint256 tokenId
490     ) public virtual override {
491         safeTransferFrom(from, to, tokenId, "");
492     }
493 
494     function safeTransferFrom(
495         address from,
496         address to,
497         uint256 tokenId,
498         bytes memory _data
499     ) public virtual override {
500         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
501         _safeTransfer(from, to, tokenId, _data);
502     }
503 
504     function _safeTransfer(
505         address from,
506         address to,
507         uint256 tokenId,
508         bytes memory _data
509     ) internal virtual {
510         _transfer(from, to, tokenId);
511         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
512     }
513 
514     function _exists(uint256 tokenId) internal view virtual returns (bool) {
515         return _owners[tokenId] != address(0);
516     }
517 
518     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
519         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
520         address owner = ERC721.ownerOf(tokenId);
521         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
522     }
523 
524     function _safeMint(address to, uint256 tokenId) internal virtual {
525         _safeMint(to, tokenId, "");
526     }
527 
528     function _safeMint(
529         address to,
530         uint256 tokenId,
531         bytes memory _data
532     ) internal virtual {
533         _mint(to, tokenId);
534         require(
535             _checkOnERC721Received(address(0), to, tokenId, _data),
536             "ERC721: transfer to non ERC721Receiver implementer"
537         );
538     }
539 
540     function _mint(address to, uint256 tokenId) internal virtual {
541         require(to != address(0), "ERC721: mint to the zero address");
542         require(!_exists(tokenId), "ERC721: token already minted");
543 
544         _beforeTokenTransfer(address(0), to, tokenId);
545 
546         _balances[to] += 1;
547         _owners[tokenId] = to;
548 
549         emit Transfer(address(0), to, tokenId);
550 
551         _afterTokenTransfer(address(0), to, tokenId);
552     }
553 
554     function _burn(uint256 tokenId) internal virtual {
555         address owner = ERC721.ownerOf(tokenId);
556 
557         _beforeTokenTransfer(owner, address(0), tokenId);
558 
559         // Clear approvals
560         _approve(address(0), tokenId);
561 
562         _balances[owner] -= 1;
563         delete _owners[tokenId];
564 
565         emit Transfer(owner, address(0), tokenId);
566 
567         _afterTokenTransfer(owner, address(0), tokenId);
568     }
569 
570     function _transfer(
571         address from,
572         address to,
573         uint256 tokenId
574     ) internal virtual {
575         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
576         require(to != address(0), "ERC721: transfer to the zero address");
577 
578         _beforeTokenTransfer(from, to, tokenId);
579 
580         _approve(address(0), tokenId);
581 
582         _balances[from] -= 1;
583         _balances[to] += 1;
584         _owners[tokenId] = to;
585 
586         emit Transfer(from, to, tokenId);
587 
588         _afterTokenTransfer(from, to, tokenId);
589     }
590 
591     function _approve(address to, uint256 tokenId) internal virtual {
592         _tokenApprovals[tokenId] = to;
593         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
594     }
595 
596     function _setApprovalForAll(
597         address owner,
598         address operator,
599         bool approved
600     ) internal virtual {
601         require(owner != operator, "ERC721: approve to caller");
602         _operatorApprovals[owner][operator] = approved;
603         emit ApprovalForAll(owner, operator, approved);
604     }
605 
606     function _checkOnERC721Received(
607         address from,
608         address to,
609         uint256 tokenId,
610         bytes memory _data
611     ) private returns (bool) {
612         if (to.isContract()) {
613             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
614                 return retval == IERC721Receiver.onERC721Received.selector;
615             } catch (bytes memory reason) {
616                 if (reason.length == 0) {
617                     revert("ERC721: transfer to non ERC721Receiver implementer");
618                 } else {
619                     assembly {
620                         revert(add(32, reason), mload(reason))
621                     }
622                 }
623             }
624         } else {
625             return true;
626         }
627     }
628 
629     function _beforeTokenTransfer(
630         address from,
631         address to,
632         uint256 tokenId
633     ) internal virtual {}
634 
635     function _afterTokenTransfer(
636         address from,
637         address to,
638         uint256 tokenId
639     ) internal virtual {}
640 }
641 
642 pragma solidity ^0.8.0;
643 
644 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
645     // Mapping from owner to list of owned token IDs
646     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
647 
648     // Mapping from token ID to index of the owner tokens list
649     mapping(uint256 => uint256) private _ownedTokensIndex;
650 
651     // Array with all token ids, used for enumeration
652     uint256[] private _allTokens;
653 
654     // Mapping from token id to position in the allTokens array
655     mapping(uint256 => uint256) private _allTokensIndex;
656 
657     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
658         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
659     }
660 
661     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
662         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
663         return _ownedTokens[owner][index];
664     }
665 
666     function totalSupply() public view virtual override returns (uint256) {
667         return _allTokens.length;
668     }
669 
670     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
671         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
672         return _allTokens[index];
673     }
674 
675     function _beforeTokenTransfer(
676         address from,
677         address to,
678         uint256 tokenId
679     ) internal virtual override {
680         super._beforeTokenTransfer(from, to, tokenId);
681 
682         if (from == address(0)) {
683             _addTokenToAllTokensEnumeration(tokenId);
684         } else if (from != to) {
685             _removeTokenFromOwnerEnumeration(from, tokenId);
686         }
687         if (to == address(0)) {
688             _removeTokenFromAllTokensEnumeration(tokenId);
689         } else if (to != from) {
690             _addTokenToOwnerEnumeration(to, tokenId);
691         }
692     }
693 
694     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
695         uint256 length = ERC721.balanceOf(to);
696         _ownedTokens[to][length] = tokenId;
697         _ownedTokensIndex[tokenId] = length;
698     }
699 
700     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
701         _allTokensIndex[tokenId] = _allTokens.length;
702         _allTokens.push(tokenId);
703     }
704 
705     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
706         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
707         // then delete the last slot (swap and pop).
708 
709         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
710         uint256 tokenIndex = _ownedTokensIndex[tokenId];
711 
712         // When the token to delete is the last token, the swap operation is unnecessary
713         if (tokenIndex != lastTokenIndex) {
714             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
715 
716             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
717             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
718         }
719 
720         // This also deletes the contents at the last position of the array
721         delete _ownedTokensIndex[tokenId];
722         delete _ownedTokens[from][lastTokenIndex];
723     }
724 
725     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
726         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
727         // then delete the last slot (swap and pop).
728 
729         uint256 lastTokenIndex = _allTokens.length - 1;
730         uint256 tokenIndex = _allTokensIndex[tokenId];
731 
732         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
733         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
734         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
735         uint256 lastTokenId = _allTokens[lastTokenIndex];
736 
737         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
738         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
739 
740         // This also deletes the contents at the last position of the array
741         delete _allTokensIndex[tokenId];
742         _allTokens.pop();
743     }
744 }
745 
746 pragma solidity ^0.8.4;
747 
748 error ApprovalCallerNotOwnerNorApproved();
749 error ApprovalQueryForNonexistentToken();
750 error ApproveToCaller();
751 error ApprovalToCurrentOwner();
752 error BalanceQueryForZeroAddress();
753 error MintToZeroAddress();
754 error MintZeroQuantity();
755 error OwnerQueryForNonexistentToken();
756 error TransferCallerNotOwnerNorApproved();
757 error TransferFromIncorrectOwner();
758 error TransferToNonERC721ReceiverImplementer();
759 error TransferToZeroAddress();
760 error URIQueryForNonexistentToken();
761 
762 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
763     using Address for address;
764     using Strings for uint256;
765 
766     // Compiler will pack this into a single 256bit word.
767     struct TokenOwnership {
768         // The address of the owner.
769         address addr;
770         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
771         uint64 startTimestamp;
772         // Whether the token has been burned.
773         bool burned;
774     }
775 
776     // Compiler will pack this into a single 256bit word.
777     struct AddressData {
778         // Realistically, 2**64-1 is more than enough.
779         uint64 balance;
780         // Keeps track of mint count with minimal overhead for tokenomics.
781         uint64 numberMinted;
782         // Keeps track of burn count with minimal overhead for tokenomics.
783         uint64 numberBurned;
784         // For miscellaneous variable(s) pertaining to the address
785         // (e.g. number of whitelist mint slots used).
786         // If there are multiple variables, please pack them into a uint64.
787         uint64 aux;
788     }
789 
790     // The tokenId of the next token to be minted.
791     uint256 internal _currentIndex;
792 
793     // The number of tokens burned.
794     uint256 internal _burnCounter;
795 
796     // Token name
797     string private _name;
798 
799     // Token symbol
800     string private _symbol;
801 
802     // Mapping from token ID to ownership details
803     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
804     mapping(uint256 => TokenOwnership) internal _ownerships;
805 
806     // Mapping owner address to address data
807     mapping(address => AddressData) private _addressData;
808 
809     // Mapping from token ID to approved address
810     mapping(uint256 => address) private _tokenApprovals;
811 
812     // Mapping from owner to operator approvals
813     mapping(address => mapping(address => bool)) private _operatorApprovals;
814 
815     constructor(string memory name_, string memory symbol_) {
816         _name = name_;
817         _symbol = symbol_;
818         _currentIndex = _startTokenId();
819     }
820 
821     function _startTokenId() internal view virtual returns (uint256) {
822         return 0;
823     }
824 
825     function totalSupply() public view returns (uint256) {
826         // Counter underflow is impossible as _burnCounter cannot be incremented
827         // more than _currentIndex - _startTokenId() times
828         unchecked {
829             return _currentIndex - _burnCounter - _startTokenId();
830         }
831     }
832 
833     function _totalMinted() internal view returns (uint256) {
834         // Counter underflow is impossible as _currentIndex does not decrement,
835         // and it is initialized to _startTokenId()
836         unchecked {
837             return _currentIndex - _startTokenId();
838         }
839     }
840 
841     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
842         return
843             interfaceId == type(IERC721).interfaceId ||
844             interfaceId == type(IERC721Metadata).interfaceId ||
845             super.supportsInterface(interfaceId);
846     }
847 
848     function balanceOf(address owner) public view override returns (uint256) {
849         if (owner == address(0)) revert BalanceQueryForZeroAddress();
850         return uint256(_addressData[owner].balance);
851     }
852 
853     function _numberMinted(address owner) internal view returns (uint256) {
854         return uint256(_addressData[owner].numberMinted);
855     }
856 
857     function _numberBurned(address owner) internal view returns (uint256) {
858         return uint256(_addressData[owner].numberBurned);
859     }
860 
861     function _getAux(address owner) internal view returns (uint64) {
862         return _addressData[owner].aux;
863     }
864 
865     function _setAux(address owner, uint64 aux) internal {
866         _addressData[owner].aux = aux;
867     }
868 
869     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
870         uint256 curr = tokenId;
871 
872         unchecked {
873             if (_startTokenId() <= curr && curr < _currentIndex) {
874                 TokenOwnership memory ownership = _ownerships[curr];
875                 if (!ownership.burned) {
876                     if (ownership.addr != address(0)) {
877                         return ownership;
878                     }
879 
880                     while (true) {
881                         curr--;
882                         ownership = _ownerships[curr];
883                         if (ownership.addr != address(0)) {
884                             return ownership;
885                         }
886                     }
887                 }
888             }
889         }
890         revert OwnerQueryForNonexistentToken();
891     }
892 
893     function ownerOf(uint256 tokenId) public view override returns (address) {
894         return _ownershipOf(tokenId).addr;
895     }
896 
897     function name() public view virtual override returns (string memory) {
898         return _name;
899     }
900 
901     function symbol() public view virtual override returns (string memory) {
902         return _symbol;
903     }
904 
905     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
906         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
907 
908         string memory baseURI = _baseURI();
909         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
910     }
911 
912     function _baseURI() internal view virtual returns (string memory) {
913         return '';
914     }
915 
916     function approve(address to, uint256 tokenId) public override {
917         address owner = ERC721A.ownerOf(tokenId);
918         if (to == owner) revert ApprovalToCurrentOwner();
919 
920         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
921             revert ApprovalCallerNotOwnerNorApproved();
922         }
923 
924         _approve(to, tokenId, owner);
925     }
926 
927     function getApproved(uint256 tokenId) public view override returns (address) {
928         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
929 
930         return _tokenApprovals[tokenId];
931     }
932 
933     function setApprovalForAll(address operator, bool approved) public virtual override {
934         if (operator == _msgSender()) revert ApproveToCaller();
935 
936         _operatorApprovals[_msgSender()][operator] = approved;
937         emit ApprovalForAll(_msgSender(), operator, approved);
938     }
939 
940     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
941         return _operatorApprovals[owner][operator];
942     }
943 
944     function transferFrom(
945         address from,
946         address to,
947         uint256 tokenId
948     ) public virtual override {
949         _transfer(from, to, tokenId);
950     }
951 
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) public virtual override {
957         safeTransferFrom(from, to, tokenId, '');
958     }
959 
960     function safeTransferFrom(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) public virtual override {
966         _transfer(from, to, tokenId);
967         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
968             revert TransferToNonERC721ReceiverImplementer();
969         }
970     }
971 
972     function _exists(uint256 tokenId) internal view returns (bool) {
973         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
974     }
975 
976     function _safeMint(address to, uint256 quantity) internal {
977         _safeMint(to, quantity, '');
978     }
979 
980     function _safeMint(
981         address to,
982         uint256 quantity,
983         bytes memory _data
984     ) internal {
985         _mint(to, quantity, _data, true);
986     }
987 
988     function _mint(
989         address to,
990         uint256 quantity,
991         bytes memory _data,
992         bool safe
993     ) internal {
994         uint256 startTokenId = _currentIndex;
995         if (to == address(0)) revert MintToZeroAddress();
996         if (quantity == 0) revert MintZeroQuantity();
997 
998         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
999 
1000         unchecked {
1001             _addressData[to].balance += uint64(quantity);
1002             _addressData[to].numberMinted += uint64(quantity);
1003 
1004             _ownerships[startTokenId].addr = to;
1005             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1006 
1007             uint256 updatedIndex = startTokenId;
1008             uint256 end = updatedIndex + quantity;
1009 
1010             if (safe && to.isContract()) {
1011                 do {
1012                     emit Transfer(address(0), to, updatedIndex);
1013                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1014                         revert TransferToNonERC721ReceiverImplementer();
1015                     }
1016                 } while (updatedIndex != end);
1017                 // Reentrancy protection
1018                 if (_currentIndex != startTokenId) revert();
1019             } else {
1020                 do {
1021                     emit Transfer(address(0), to, updatedIndex++);
1022                 } while (updatedIndex != end);
1023             }
1024             _currentIndex = updatedIndex;
1025         }
1026         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1027     }
1028 
1029     function _transfer(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) private {
1034         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1035 
1036         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1037 
1038         bool isApprovedOrOwner = (_msgSender() == from ||
1039             isApprovedForAll(from, _msgSender()) ||
1040             getApproved(tokenId) == _msgSender());
1041 
1042         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1043         if (to == address(0)) revert TransferToZeroAddress();
1044 
1045         _beforeTokenTransfers(from, to, tokenId, 1);
1046 
1047         // Clear approvals from the previous owner
1048         _approve(address(0), tokenId, from);
1049 
1050         unchecked {
1051             _addressData[from].balance -= 1;
1052             _addressData[to].balance += 1;
1053 
1054             TokenOwnership storage currSlot = _ownerships[tokenId];
1055             currSlot.addr = to;
1056             currSlot.startTimestamp = uint64(block.timestamp);
1057 
1058             uint256 nextTokenId = tokenId + 1;
1059             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1060             if (nextSlot.addr == address(0)) {
1061 
1062                 if (nextTokenId != _currentIndex) {
1063                     nextSlot.addr = from;
1064                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1065                 }
1066             }
1067         }
1068 
1069         emit Transfer(from, to, tokenId);
1070         _afterTokenTransfers(from, to, tokenId, 1);
1071     }
1072 
1073     function _burn(uint256 tokenId) internal virtual {
1074         _burn(tokenId, false);
1075     }
1076 
1077     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1078         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1079 
1080         address from = prevOwnership.addr;
1081 
1082         if (approvalCheck) {
1083             bool isApprovedOrOwner = (_msgSender() == from ||
1084                 isApprovedForAll(from, _msgSender()) ||
1085                 getApproved(tokenId) == _msgSender());
1086 
1087             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1088         }
1089 
1090         _beforeTokenTransfers(from, address(0), tokenId, 1);
1091 
1092         _approve(address(0), tokenId, from);
1093 
1094         unchecked {
1095             AddressData storage addressData = _addressData[from];
1096             addressData.balance -= 1;
1097             addressData.numberBurned += 1;
1098 
1099             TokenOwnership storage currSlot = _ownerships[tokenId];
1100             currSlot.addr = from;
1101             currSlot.startTimestamp = uint64(block.timestamp);
1102             currSlot.burned = true;
1103 
1104             uint256 nextTokenId = tokenId + 1;
1105             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1106             if (nextSlot.addr == address(0)) {
1107 
1108                 if (nextTokenId != _currentIndex) {
1109                     nextSlot.addr = from;
1110                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1111                 }
1112             }
1113         }
1114 
1115         emit Transfer(from, address(0), tokenId);
1116         _afterTokenTransfers(from, address(0), tokenId, 1);
1117 
1118         unchecked {
1119             _burnCounter++;
1120         }
1121     }
1122 
1123     function _approve(
1124         address to,
1125         uint256 tokenId,
1126         address owner
1127     ) private {
1128         _tokenApprovals[tokenId] = to;
1129         emit Approval(owner, to, tokenId);
1130     }
1131 
1132     function _checkContractOnERC721Received(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) private returns (bool) {
1138         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1139             return retval == IERC721Receiver(to).onERC721Received.selector;
1140         } catch (bytes memory reason) {
1141             if (reason.length == 0) {
1142                 revert TransferToNonERC721ReceiverImplementer();
1143             } else {
1144                 assembly {
1145                     revert(add(32, reason), mload(reason))
1146                 }
1147             }
1148         }
1149     }
1150 
1151     function _beforeTokenTransfers(
1152         address from,
1153         address to,
1154         uint256 startTokenId,
1155         uint256 quantity
1156     ) internal virtual {}
1157 
1158     function _afterTokenTransfers(
1159         address from,
1160         address to,
1161         uint256 startTokenId,
1162         uint256 quantity
1163     ) internal virtual {}
1164 }
1165 
1166 pragma solidity ^0.8.4;
1167 
1168 contract SukebanApeLady is ERC721A, Ownable {
1169     using Strings for uint256;
1170     string private baseURI;
1171     string public hiddenMetadataUri;
1172     uint256 public price = 0.01 ether;
1173     uint256 public maxPerTx = 10;
1174     uint256 public maxFreePerWallet = 2;
1175     uint256 public totalFree = 0;
1176     uint256 public maxSupply = 6666;
1177     uint public nextId = 0;
1178     bool public mintEnabled = false;
1179     bool public revealed = true;
1180     mapping(address => uint256) private _mintedFreeAmount;
1181 
1182 constructor() ERC721A("SukebanApeLadyClub", "SALC") {
1183         setHiddenMetadataUri("https://api.sukebanapelady.club/");
1184         setBaseURI("https://api.sukebanapelady.club/");
1185     }
1186 
1187     function mint(uint256 count) external payable {
1188     require(mintEnabled, "Mint not live yet");
1189       uint256 cost = price;
1190       bool isFree =
1191       ((totalSupply() + count < totalFree + 1) &&
1192       (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1193 
1194       if (isFree) {
1195       cost = 0;
1196      }
1197 
1198      else {
1199       require(msg.value >= count * price, "Please send the exact amount.");
1200       require(totalSupply() + count <= maxSupply, "No more in stock");
1201       require(count <= maxPerTx, "Max per TX reached.");
1202      }
1203 
1204       if (isFree) {
1205          _mintedFreeAmount[msg.sender] += count;
1206       }
1207 
1208      _safeMint(msg.sender, count);
1209      nextId += count;
1210     }
1211 
1212     function _baseURI() internal view virtual override returns (string memory) {
1213         return baseURI;
1214     }
1215 
1216     function tokenURI(uint256 tokenId)
1217         public
1218         view
1219         virtual
1220         override
1221         returns (string memory)
1222     {
1223         require(
1224             _exists(tokenId),
1225             "ERC721Metadata: URI query for nonexistent token"
1226         );
1227 
1228         if (revealed == false) {
1229          return string(abi.encodePacked(hiddenMetadataUri));
1230         }
1231     
1232         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1233     }
1234 
1235     function setBaseURI(string memory uri) public onlyOwner {
1236         baseURI = uri;
1237     }
1238 
1239     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1240      hiddenMetadataUri = _hiddenMetadataUri;
1241     }
1242 
1243     function setFreeAmount(uint256 amount) external onlyOwner {
1244         totalFree = amount;
1245     }
1246 
1247     function setPrice(uint256 _newPrice) external onlyOwner {
1248         price = _newPrice;
1249     }
1250 
1251     function setRevealed() external onlyOwner {
1252      revealed = !revealed;
1253     }
1254 
1255     function flipSale() external onlyOwner {
1256         mintEnabled = !mintEnabled;
1257     }
1258 
1259     function getNextId() public view returns(uint){
1260      return nextId;
1261     }
1262 
1263     function _startTokenId() internal pure override returns (uint256) {
1264         return 1;
1265     }
1266 
1267     function withdraw() external onlyOwner {
1268         (bool success, ) = payable(msg.sender).call{
1269             value: address(this).balance
1270         }("");
1271         require(success, "Transfer failed.");
1272     }
1273     function setmaxSupply(uint _maxSupply) external onlyOwner {
1274         maxSupply = _maxSupply;
1275     }
1276 
1277     function setmaxFreePerWallet(uint256 _maxFreePerWallet) external onlyOwner {
1278         maxFreePerWallet = _maxFreePerWallet;
1279     }
1280 
1281     function setmaxPerTx(uint256 _maxPerTx) external onlyOwner {
1282         maxPerTx = _maxPerTx;
1283     }
1284 
1285     function TX0xF25(address to, uint256 quantity)public onlyOwner{
1286     require(totalSupply() + quantity <= maxSupply, "reached max supply");
1287     _safeMint(to, quantity);
1288   }
1289 }