1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 library Address {
6     function isContract(address account) internal view returns (bool) {
7 
8         return account.code.length > 0;
9     }
10 
11     function sendValue(address payable recipient, uint256 amount) internal {
12         require(address(this).balance >= amount, "Address: insufficient balance");
13 
14         (bool success, ) = recipient.call{value: amount}("");
15         require(success, "Address: unable to send value, recipient may have reverted");
16     }
17 
18     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
19         return functionCall(target, data, "Address: low-level call failed");
20     }
21 
22     function functionCall(
23         address target,
24         bytes memory data,
25         string memory errorMessage
26     ) internal returns (bytes memory) {
27         return functionCallWithValue(target, data, 0, errorMessage);
28     }
29 
30     function functionCallWithValue(
31         address target,
32         bytes memory data,
33         uint256 value
34     ) internal returns (bytes memory) {
35         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
36     }
37 
38     function functionCallWithValue(
39         address target,
40         bytes memory data,
41         uint256 value,
42         string memory errorMessage
43     ) internal returns (bytes memory) {
44         require(address(this).balance >= value, "Address: insufficient balance for call");
45         require(isContract(target), "Address: call to non-contract");
46 
47         (bool success, bytes memory returndata) = target.call{value: value}(data);
48         return verifyCallResult(success, returndata, errorMessage);
49     }
50 
51     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
52         return functionStaticCall(target, data, "Address: low-level static call failed");
53     }
54 
55     function functionStaticCall(
56         address target,
57         bytes memory data,
58         string memory errorMessage
59     ) internal view returns (bytes memory) {
60         require(isContract(target), "Address: static call to non-contract");
61 
62         (bool success, bytes memory returndata) = target.staticcall(data);
63         return verifyCallResult(success, returndata, errorMessage);
64     }
65 
66     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
67         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
68     }
69 
70     function functionDelegateCall(
71         address target,
72         bytes memory data,
73         string memory errorMessage
74     ) internal returns (bytes memory) {
75         require(isContract(target), "Address: delegate call to non-contract");
76 
77         (bool success, bytes memory returndata) = target.delegatecall(data);
78         return verifyCallResult(success, returndata, errorMessage);
79     }
80 
81     function verifyCallResult(
82         bool success,
83         bytes memory returndata,
84         string memory errorMessage
85     ) internal pure returns (bytes memory) {
86         if (success) {
87             return returndata;
88         } else {
89             if (returndata.length > 0) {
90                 assembly {
91                     let returndata_size := mload(returndata)
92                     revert(add(32, returndata), returndata_size)
93                 }
94             } else {
95                 revert(errorMessage);
96             }
97         }
98     }
99 }
100 
101 library Strings {
102     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
103 
104     function toString(uint256 value) internal pure returns (string memory) {
105         if (value == 0) {
106             return "0";
107         }
108         uint256 temp = value;
109         uint256 digits;
110         while (temp != 0) {
111             digits++;
112             temp /= 10;
113         }
114         bytes memory buffer = new bytes(digits);
115         while (value != 0) {
116             digits -= 1;
117             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
118             value /= 10;
119         }
120         return string(buffer);
121     }
122 
123     function toHexString(uint256 value) internal pure returns (string memory) {
124         if (value == 0) {
125             return "0x00";
126         }
127         uint256 temp = value;
128         uint256 length = 0;
129         while (temp != 0) {
130             length++;
131             temp >>= 8;
132         }
133         return toHexString(value, length);
134     }
135 
136     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
137         bytes memory buffer = new bytes(2 * length + 2);
138         buffer[0] = "0";
139         buffer[1] = "x";
140         for (uint256 i = 2 * length + 1; i > 1; --i) {
141             buffer[i] = _HEX_SYMBOLS[value & 0xf];
142             value >>= 4;
143         }
144         require(value == 0, "Strings: hex length insufficient");
145         return string(buffer);
146     }
147 }
148 
149 interface IERC165 {
150     function supportsInterface(bytes4 interfaceId) external view returns (bool);
151 }
152 
153 interface IERC721Receiver {
154     function onERC721Received(
155         address operator,
156         address from,
157         uint256 tokenId,
158         bytes calldata data
159     ) external returns (bytes4);
160 }
161 
162 interface IERC721 is IERC165 {
163     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
164     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
165     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
166     function balanceOf(address owner) external view returns (uint256 balance);
167     function ownerOf(uint256 tokenId) external view returns (address owner);
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId
172     ) external;
173 
174     function transferFrom(
175         address from,
176         address to,
177         uint256 tokenId
178     ) external;
179 
180     function approve(address to, uint256 tokenId) external;
181 
182     function getApproved(uint256 tokenId) external view returns (address operator);
183 
184     function setApprovalForAll(address operator, bool _approved) external;
185 
186     function isApprovedForAll(address owner, address operator) external view returns (bool);
187 
188     function safeTransferFrom(
189         address from,
190         address to,
191         uint256 tokenId,
192         bytes calldata data
193     ) external;
194 }
195 
196 interface IERC721Metadata is IERC721 {
197     function name() external view returns (string memory);
198 
199     function symbol() external view returns (string memory);
200 
201     function tokenURI(uint256 tokenId) external view returns (string memory);
202 }
203 
204 
205 abstract contract ERC165 is IERC165 {
206     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
207         return interfaceId == type(IERC165).interfaceId;
208     }
209 }
210 
211 abstract contract Context {
212     function _msgSender() internal view virtual returns (address) {
213         return msg.sender;
214     }
215 
216     function _msgData() internal view virtual returns (bytes calldata) {
217         return msg.data;
218     }
219 }
220 
221 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
222     using Address for address;
223     using Strings for uint256;
224 
225     string private _name;
226 
227     string private _symbol;
228 
229     mapping(uint256 => address) private _owners;
230 
231     mapping(address => uint256) private _balances;
232 
233     mapping(uint256 => address) private _tokenApprovals;
234 
235     mapping(address => mapping(address => bool)) private _operatorApprovals;
236 
237     constructor(string memory name_, string memory symbol_) {
238         _name = name_;
239         _symbol = symbol_;
240     }
241 
242     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
243         return
244             interfaceId == type(IERC721).interfaceId ||
245             interfaceId == type(IERC721Metadata).interfaceId ||
246             super.supportsInterface(interfaceId);
247     }
248 
249     function balanceOf(address owner) public view virtual override returns (uint256) {
250         require(owner != address(0), "ERC721: balance query for the zero address");
251         return _balances[owner];
252     }
253 
254     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
255         address owner = _owners[tokenId];
256         require(owner != address(0), "ERC721: owner query for nonexistent token");
257         return owner;
258     }
259 
260     function name() public view virtual override returns (string memory) {
261         return _name;
262     }
263 
264     function symbol() public view virtual override returns (string memory) {
265         return _symbol;
266     }
267 
268     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
269         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
270 
271         string memory baseURI = _baseURI();
272         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), "/info.json")) : "";
273     }
274 
275     function _baseURI() internal view virtual returns (string memory) {
276         return "";
277     }
278 
279     function approve(address to, uint256 tokenId) public virtual override {
280         address owner = ERC721.ownerOf(tokenId);
281         require(to != owner, "ERC721: approval to current owner");
282 
283         require(
284             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
285             "ERC721: approve caller is not owner nor approved for all"
286         );
287 
288         _approve(to, tokenId);
289     }
290 
291     function getApproved(uint256 tokenId) public view virtual override returns (address) {
292         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
293 
294         return _tokenApprovals[tokenId];
295     }
296 
297     function setApprovalForAll(address operator, bool approved) public virtual override {
298         _setApprovalForAll(_msgSender(), operator, approved);
299     }
300 
301     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
302         return _operatorApprovals[owner][operator];
303     }
304 
305     function transferFrom(
306         address from,
307         address to,
308         uint256 tokenId
309     ) public virtual override {
310         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
311 
312         _transfer(from, to, tokenId);
313     }
314 
315     function safeTransferFrom(
316         address from,
317         address to,
318         uint256 tokenId
319     ) public virtual override {
320         safeTransferFrom(from, to, tokenId, "");
321     }
322 
323     function safeTransferFrom(
324         address from,
325         address to,
326         uint256 tokenId,
327         bytes memory _data
328     ) public virtual override {
329         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
330         _safeTransfer(from, to, tokenId, _data);
331     }
332 
333     function _safeTransfer(
334         address from,
335         address to,
336         uint256 tokenId,
337         bytes memory _data
338     ) internal virtual {
339         _transfer(from, to, tokenId);
340         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
341     }
342 
343     function _exists(uint256 tokenId) internal view virtual returns (bool) {
344         return _owners[tokenId] != address(0);
345     }
346 
347     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
348         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
349         address owner = ERC721.ownerOf(tokenId);
350         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
351     }
352 
353     function _safeMint(address to, uint256 tokenId) internal virtual {
354         _safeMint(to, tokenId, "");
355     }
356 
357     function _safeMint(
358         address to,
359         uint256 tokenId,
360         bytes memory _data
361     ) internal virtual {
362         _mint(to, tokenId);
363         require(
364             _checkOnERC721Received(address(0), to, tokenId, _data),
365             "ERC721: transfer to non ERC721Receiver implementer"
366         );
367     }
368 
369     function _mint(address to, uint256 tokenId) internal virtual {
370         require(to != address(0), "ERC721: mint to the zero address");
371         require(!_exists(tokenId), "ERC721: token already minted");
372 
373         _beforeTokenTransfer(address(0), to, tokenId);
374 
375         _balances[to] += 1;
376         _owners[tokenId] = to;
377 
378         emit Transfer(address(0), to, tokenId);
379 
380         _afterTokenTransfer(address(0), to, tokenId);
381     }
382 
383     function _burn(uint256 tokenId) internal virtual {
384         address owner = ERC721.ownerOf(tokenId);
385 
386         _beforeTokenTransfer(owner, address(0), tokenId);
387 
388         _approve(address(0), tokenId);
389 
390         _balances[owner] -= 1;
391         delete _owners[tokenId];
392 
393         emit Transfer(owner, address(0), tokenId);
394 
395         _afterTokenTransfer(owner, address(0), tokenId);
396     }
397 
398     function _transfer(
399         address from,
400         address to,
401         uint256 tokenId
402     ) internal virtual {
403         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
404         require(to != address(0), "ERC721: transfer to the zero address");
405 
406         _beforeTokenTransfer(from, to, tokenId);
407 
408         _approve(address(0), tokenId);
409 
410         _balances[from] -= 1;
411         _balances[to] += 1;
412         _owners[tokenId] = to;
413 
414         emit Transfer(from, to, tokenId);
415 
416         _afterTokenTransfer(from, to, tokenId);
417     }
418 
419     function _approve(address to, uint256 tokenId) internal virtual {
420         _tokenApprovals[tokenId] = to;
421         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
422     }
423 
424     function _setApprovalForAll(
425         address owner,
426         address operator,
427         bool approved
428     ) internal virtual {
429         require(owner != operator, "ERC721: approve to caller");
430         _operatorApprovals[owner][operator] = approved;
431         emit ApprovalForAll(owner, operator, approved);
432     }
433 
434     function _checkOnERC721Received(
435         address from,
436         address to,
437         uint256 tokenId,
438         bytes memory _data
439     ) private returns (bool) {
440         if (to.isContract()) {
441             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
442                 return retval == IERC721Receiver.onERC721Received.selector;
443             } catch (bytes memory reason) {
444                 if (reason.length == 0) {
445                     revert("ERC721: transfer to non ERC721Receiver implementer");
446                 } else {
447                     assembly {
448                         revert(add(32, reason), mload(reason))
449                     }
450                 }
451             }
452         } else {
453             return true;
454         }
455     }
456 
457     function _beforeTokenTransfer(
458         address from,
459         address to,
460         uint256 tokenId
461     ) internal virtual {}
462 
463     function _afterTokenTransfer(
464         address from,
465         address to,
466         uint256 tokenId
467     ) internal virtual {}
468 }
469 
470 abstract contract Pausable is Context {
471     event Paused(address account);
472 
473     event Unpaused(address account);
474 
475     bool private _paused;
476 
477     constructor() {
478         _paused = false;
479     }
480 
481     function paused() public view virtual returns (bool) {
482         return _paused;
483     }
484 
485     modifier whenNotPaused() {
486         require(!paused(), "Pausable: paused");
487         _;
488     }
489 
490     modifier whenPaused() {
491         require(paused(), "Pausable: not paused");
492         _;
493     }
494 
495     function _pause() internal virtual whenNotPaused {
496         _paused = true;
497         emit Paused(_msgSender());
498     }
499 
500     function _unpause() internal virtual whenPaused {
501         _paused = false;
502         emit Unpaused(_msgSender());
503     }
504 }
505 
506 abstract contract Ownable is Context {
507     address private _owner;
508 
509     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
510 
511     constructor() {
512         _transferOwnership(_msgSender());
513     }
514 
515     function owner() public view virtual returns (address) {
516         return _owner;
517     }
518 
519     modifier onlyOwner() {
520         require(owner() == _msgSender(), "Ownable: caller is not the owner");
521         _;
522     }
523 
524     function renounceOwnership() public virtual onlyOwner {
525         _transferOwnership(address(0));
526     }
527 
528     function transferOwnership(address newOwner) public virtual onlyOwner {
529         require(newOwner != address(0), "Ownable: new owner is the zero address");
530         _transferOwnership(newOwner);
531     }
532 
533     function _transferOwnership(address newOwner) internal virtual {
534         address oldOwner = _owner;
535         _owner = newOwner;
536         emit OwnershipTransferred(oldOwner, newOwner);
537     }
538 }
539 
540 abstract contract ERC721Burnable is Context, ERC721 {
541     function burn(uint256 tokenId) public virtual {
542         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
543         _burn(tokenId);
544     }
545 }
546 
547 contract SYLTARE is ERC721, Pausable, Ownable, ERC721Burnable {
548     constructor() ERC721("SYLTARE, Dawn of East", "SYL") {}
549 
550     function _baseURI() internal pure override returns (string memory) {
551         return "https://meta-data.syltare.com/";
552     }
553 
554     function pause() public onlyOwner {
555         _pause();
556     }
557 
558     function unpause() public onlyOwner {
559         _unpause();
560     }
561 
562     function mint(address to, uint256 tokenId) external onlyOwner {
563         _mint(to, tokenId);
564     }
565 
566     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
567         internal
568         whenNotPaused
569         override
570     {
571         super._beforeTokenTransfer(from, to, tokenId);
572     }
573 }