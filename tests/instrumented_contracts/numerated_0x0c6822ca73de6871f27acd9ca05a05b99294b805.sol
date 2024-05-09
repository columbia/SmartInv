1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.11;
4 
5 library Strings {
6     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
7 
8     /**
9      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
10      */
11     function toString(uint256 value) internal pure returns (string memory) {
12         // Inspired by OraclizeAPI's implementation - MIT licence
13         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
14 
15         if (value == 0) {
16             return "0";
17         }
18         uint256 temp = value;
19         uint256 digits;
20         while (temp != 0) {
21             digits++;
22             temp /= 10;
23         }
24         bytes memory buffer = new bytes(digits);
25         while (value != 0) {
26             digits -= 1;
27             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
28             value /= 10;
29         }
30         return string(buffer);
31     }
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
35      */
36     function toHexString(uint256 value) internal pure returns (string memory) {
37         if (value == 0) {
38             return "0x00";
39         }
40         uint256 temp = value;
41         uint256 length = 0;
42         while (temp != 0) {
43             length++;
44             temp >>= 8;
45         }
46         return toHexString(value, length);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
51      */
52     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
53         bytes memory buffer = new bytes(2 * length + 2);
54         buffer[0] = "0";
55         buffer[1] = "x";
56         for (uint256 i = 2 * length + 1; i > 1; --i) {
57             buffer[i] = _HEX_SYMBOLS[value & 0xf];
58             value >>= 4;
59         }
60         require(value == 0, "Strings: hex length insufficient");
61         return string(buffer);
62     }
63 }
64 
65 abstract contract Context {
66     function _msgSender() internal view virtual returns (address) {
67         return msg.sender;
68     }
69 
70     function _msgData() internal view virtual returns (bytes calldata) {
71         return msg.data;
72     }
73 }
74 
75 library Address {
76  
77     function isContract(address account) internal view returns (bool) {
78 
79         uint256 size;
80         assembly {
81             size := extcodesize(account)
82         }
83         return size > 0;
84     }
85 
86     function sendValue(address payable recipient, uint256 amount) internal {
87         require(address(this).balance >= amount, "Address: insufficient balance");
88 
89         (bool success, ) = recipient.call{value: amount}("");
90         require(success, "Address: unable to send value, recipient may have reverted");
91     }
92 
93     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
94         return functionCall(target, data, "Address: low-level call failed");
95     }
96 
97     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
103     }
104 
105     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
106         require(address(this).balance >= value, "Address: insufficient balance for call");
107         require(isContract(target), "Address: call to non-contract");
108 
109         (bool success, bytes memory returndata) = target.call{value: value}(data);
110         return verifyCallResult(success, returndata, errorMessage);
111     }
112 
113     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
114         return functionStaticCall(target, data, "Address: low-level static call failed");
115     }
116 
117     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
118         require(isContract(target), "Address: static call to non-contract");
119 
120         (bool success, bytes memory returndata) = target.staticcall(data);
121         return verifyCallResult(success, returndata, errorMessage);
122     }
123 
124     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
125         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
126     }
127 
128     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
129         require(isContract(target), "Address: delegate call to non-contract");
130 
131         (bool success, bytes memory returndata) = target.delegatecall(data);
132         return verifyCallResult(success, returndata, errorMessage);
133     }
134 
135     function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
136         if (success) {
137             return returndata;
138         } else {
139             if (returndata.length > 0) {
140 
141                 assembly {
142                     let returndata_size := mload(returndata)
143                     revert(add(32, returndata), returndata_size)
144                 }
145             } else {
146                 revert(errorMessage);
147             }
148         }
149     }
150 }
151 
152 interface IERC721Receiver {
153 
154     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
155 }
156 
157 interface IERC165 {
158 
159     function supportsInterface(bytes4 interfaceId) external view returns (bool);
160 }
161 
162 interface IERC721 is IERC165 {
163 
164     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
165     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
166     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
167 
168     function balanceOf(address owner) external view returns (uint256 balance);
169     function ownerOf(uint256 tokenId) external view returns (address owner);
170     function safeTransferFrom(address from, address to, uint256 tokenId) external;
171     function transferFrom(address from, address to, uint256 tokenId) external;
172     function approve(address to, uint256 tokenId) external;
173     function getApproved(uint256 tokenId) external view returns (address operator);
174     function setApprovalForAll(address operator, bool _approved) external;
175     function isApprovedForAll(address owner, address operator) external view returns (bool);
176     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
177 }
178 
179 interface IERC721Enumerable is IERC721 {
180 
181     function totalSupply() external view returns (uint256);
182     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
183     function tokenByIndex(uint256 index) external view returns (uint256);
184 }
185 
186 interface IERC721Metadata is IERC721 {
187 
188     function name() external view returns (string memory);
189     function symbol() external view returns (string memory);
190     function tokenURI(uint256 tokenId) external view returns (string memory);
191 }
192 
193 abstract contract ERC165 is IERC165 {
194 
195     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
196         return interfaceId == type(IERC165).interfaceId;
197     }
198 }
199 
200 abstract contract NFTOptimized is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
201     using Address for address;
202 
203     string private _name;
204     string private _symbol;
205     uint256 private burnCount;
206 
207     address[] internal _owners;
208     mapping(uint256 => address) private _tokenApprovals;
209     mapping(address => mapping(address => bool)) private _operatorApprovals;
210 
211     constructor(string memory name_, string memory symbol_) {
212         _name = name_;
213         _symbol = symbol_;
214     }     
215 
216     function approve(address to, uint256 tokenId) public virtual override {
217         address owner = NFTOptimized.ownerOf(tokenId);
218         require(to != owner, "Approval for Owner is not necessary");
219         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "Approve function call by non-approved caller");
220 
221         _approve(to, tokenId);
222     }
223 
224     function setApprovalForAll(address operator, bool approved) public virtual override {
225         require(operator != _msgSender(), "Approval for Owner is not necessary");
226         _operatorApprovals[_msgSender()][operator] = approved;
227         emit ApprovalForAll(_msgSender(), operator, approved);
228     }
229 
230     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
231         require(_isApprovedOrOwner(_msgSender(), tokenId), "Transfer function call by non-approved caller");
232         _transfer(from, to, tokenId);
233     }
234 
235     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
236         safeTransferFrom(from, to, tokenId, "");
237     }
238 
239     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
240         require(_isApprovedOrOwner(_msgSender(), tokenId), "safeTransfer function call by non-approved caller");
241         _safeTransfer(from, to, tokenId, _data);
242     }
243 
244     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
245         _transfer(from, to, tokenId);
246         require(_checkOnERC721Received(from, to, tokenId, _data), "Error from ERC721Receiver check");
247     }
248 
249 	function _safeMint(address to, uint256 tokenId) internal virtual {
250         _safeMint(to, tokenId, "");
251     }
252 	function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
253         _mint(to, tokenId);
254         require(_checkOnERC721Received(address(0), to, tokenId, _data), "Error from ERC721Receiver check");
255     }
256 	function _mint(address to, uint256 tokenId) internal virtual {
257         require(!_exists(tokenId), "Token already exists");
258         require(to != address(0), "Cannot mint to Null Address");
259         
260         _beforeTokenTransfer(address(0), to, tokenId);
261         _owners.push(to);
262 
263         emit Transfer(address(0), to, tokenId);
264     }
265 
266 	function _burn(uint256 tokenId) internal virtual {
267         address owner = NFTOptimized.ownerOf(tokenId);
268 
269         _beforeTokenTransfer(owner, address(0), tokenId);
270         _approve(address(0), tokenId);
271         _owners[tokenId] = address(0);
272         burnCount++;
273 
274         emit Transfer(owner, address(0), tokenId);
275     }
276 
277 	function _transfer(address from, address to, uint256 tokenId) internal virtual {
278         require(NFTOptimized.ownerOf(tokenId) == from, "Caller does not own token");
279         require(to != address(0), "Cannot transfer to Null Address");
280 
281         _beforeTokenTransfer(from, to, tokenId);
282         _approve(address(0), tokenId);
283         _owners[tokenId] = to;
284 
285         emit Transfer(from, to, tokenId);
286     }
287 
288 	function _approve(address to, uint256 tokenId) internal virtual {
289         _tokenApprovals[tokenId] = to;
290         emit Approval(NFTOptimized.ownerOf(tokenId), to, tokenId);
291     }
292 
293 	function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
294         if (to.isContract()) {
295             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
296                 return retval == IERC721Receiver.onERC721Received.selector;
297             } catch (bytes memory reason) {
298                 if (reason.length == 0) {
299                     revert("ERC721: transfer to non ERC721Receiver implementer");
300                 } else {
301                     assembly {
302                         revert(add(32, reason), mload(reason))
303                     }
304                 }
305             }
306         } else {
307             return true;
308         }
309     }
310     //Leaving this in incase anyone needs to overwrite this function for additional functionality
311 	function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}
312 
313     /**
314     VIEW FUNCTIONS
315      */
316      
317     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
318         return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
319     }
320 
321     function balanceOf(address owner) public view virtual override returns (uint256) {
322         require(owner != address(0), "Cannot measure balance of Null Address");
323         uint count = 0;
324         uint length = _owners.length;
325         for(uint i = 0; i < length; i++){
326           if(owner == _owners[i] ){
327             count++;
328           }
329         }
330         delete length;
331         return count;
332     }
333 
334     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
335         address owner = _owners[tokenId];
336         require(owner != address(0), "Checking for Owner of nonexistent tokenid");
337         return owner;
338     }
339 
340     function name() public view virtual override returns (string memory) {
341         return _name;
342     }
343 
344     function symbol() public view virtual override returns (string memory) {
345         return _symbol;
346     }
347 
348     function getApproved(uint256 tokenId) public view virtual override returns (address) {
349         require(_exists(tokenId), "Checking for Owner of nonexistent tokenid");
350         return _tokenApprovals[tokenId];
351     }
352 
353     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
354         return _operatorApprovals[owner][operator];
355     }
356 
357     function _exists(uint256 tokenId) internal view virtual returns (bool) {
358         return tokenId < _owners.length && _owners[tokenId] != address(0);
359     }
360 
361     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
362         require(_exists(tokenId), "Checking for Owner of nonexistent tokenid");
363         address owner = NFTOptimized.ownerOf(tokenId);
364         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
365     }
366 
367     function totalSupply() public view virtual override returns (uint256) {
368         return _owners.length - burnCount;
369     }
370 
371     function totalCreated() public view virtual returns (uint256) {
372         return _owners.length;
373     }
374 
375     function totalBurned() public view virtual returns (uint256) {
376         return burnCount;
377     }
378 
379     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
380         require(0 < NFTOptimized.balanceOf(owner), "Address owns no tokens");
381         uint256 tokenCount = balanceOf(owner);
382         uint256[] memory tokenIds = new uint256[](tokenCount);
383 
384         for (uint256 i = 0; i < tokenCount; i++) {
385             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
386         }
387         return tokenIds;
388     }
389 
390     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
391         require(index < NFTOptimized.balanceOf(owner), "Token does not exist");
392         uint count;
393 
394         for( uint i; i < _owners.length; ++i ){
395             if( owner == _owners[i] ){
396                 if( count == index )
397                     return i;
398                 else
399                     ++count;
400             }
401         }
402         require(false, "Token does not exist");
403     }
404 
405     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
406         require(index < NFTOptimized.totalCreated(), "Token does not exist");
407         return index;
408     }
409 
410 }
411 
412 abstract contract Ownable is Context {
413     address private _owner;
414 
415     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
416 
417     constructor() {
418         _setOwner(_msgSender());
419     }
420 
421     function owner() public view virtual returns (address) {
422         return _owner;
423     }
424 
425     modifier onlyOwner() {
426         require(owner() == _msgSender(), "Ownable: caller is not the owner");
427         _;
428     }
429 
430     function renounceOwnership() public virtual onlyOwner {
431         _setOwner(address(0));
432     }
433 
434     function transferOwnership(address newOwner) public virtual onlyOwner {
435         require(newOwner != address(0), "Ownable: new owner is the zero address");
436         _setOwner(newOwner);
437     }
438 
439     function _setOwner(address newOwner) private {
440         address oldOwner = _owner;
441         _owner = newOwner;
442         emit OwnershipTransferred(oldOwner, newOwner);
443     }
444 }
445 
446 
447 /**
448 ::::::ccclccccclloooollooodxxxxxxxxdddxxkkkkkkkkO00000000OOkkkkkkxxdddxxxxxxxdoolllooolccccccc::::::
449 ccccllcccccllloooollooddxxxxxxxddxxxkkkkkkkOO000000000000000OOOkkkkkkxxxxxxxxxxxddoollloollccccccc::
450 llcccclllooooollooddxxxxxxxxxxxxkkkkkkkOO000OOO0KKK0000KK000OOOOOOkkkkkOkkkxxxxxxxxxddoolllolllccccc
451 cclllooooollloodxxxxxxxxxxxkkOkkkOOO00000OkkOkOOK00kxkkkkxxkkkkkkOO0OOkkkkOOkkkxxxxxxxxxddoooloollcc
452 looooolllooddxxxxxxxxxkkkOOkOOO000000OkkOkkO0Oxoc,.. .';coddddxxdxkkkkOOOOkkkkOOkkxxxdxxxxxxddoollll
453 oooolooddxxxxxxxxxkkkkOOOOO000000OOOOOkk0Oxoc,.          .';coddddxxxxkkkkkOOOkkkkOOkkxxxddxxxxxdool
454 oooloxxxxxxxxxkkkkOOOO0000O000O00OkkOOxoc,.                  .';coxxdxxxxxkkkxkkOOkkkOOOkkxxddxxxxxx
455 oolldxxdxxkkkkkOOO000OO000O000OOOOxo:,.                          .';coxxdxkkkxkkxxkkkOkkkOOOkxddxxxx
456 oolldxxdxOkkkOO00OO00OOO0OOkOOxo:,.                                  .';coxxdk0K0OkxkOOOOkkkkOxdxxxx
457 oolldxddkOxk00O00OOOOOxxkkxl:,.                                          .';:oxkO0K0000OO00xxOxdxxxx
458 oolldxddkOkkO0OOOkxxkkdl:,.                                                  ..,ckKKK0KKOO0kxOxdxxxx
459 oocldxddkOxxkkxxxkdc:,.                                                          lkkK0KKOO0kxOxdxxxx
460 oollxxdxkkxxddxxkc.                                                              :dd00KKOO0kxOxdxxxx
461 ooloxxdxOkxxdddxk,                                                               :ddOOKKOO0kxOxdxxxx
462 ooloxxxxOkxxxxxxk,                                                               :ddOO00OO0kxOxdxxxx
463 ooldxxxxOkxkOOxxk,            ..'''.                           .',;;,.           :ddOkk0OO0kkOxdxxxx
464 ooldxxxxOkxkO0xxk,           'kOdodkxc.     'c.              cOOkkkko.           :ddOkk0OO0kkOkxxxxx
465 ooodxxdxOxkk00dxk,           :Kl   .c0d.    cXo       ::    .dWx.                :ddOkk0OO0kkOkxxxxx
466 olodxxdxOxkO00dxk,           :Kc    .dO.    lW0,     .OO'    lNx.                :doOkk0OO0kkOkdxxxx
467 olodxxdxOxkO00kkk,           ;Kk::::o0o     oWWd.    :XNl    :Xk.                :doOkk0OO0kkOkdxxxx
468 olldxxdxOxkO0K0KO,           ;KOcccldkkc.  .dX0O;   .xKKO'   ,KO.                :dokkk0OO0kkOxdxxxx
469 olldxxdxOkkOOK00k,           ;0l      ;Ok. .k0:xx.  ;0lc0l   .O0'                :dokkk0OO0kkOxdxxxx
470 ollxxxdxOkkOOK0Od,           ,0l       ,Oc .Ok.,k: .dO'.xO.  .xK,                :dokkx0OO0kxOxdxxxx
471 oclxxxdkOkkkOK0kd,           ,0o       .kl '0x. lxclOo  :Kl   dX:                :dokkxOOO0xxOxddxxx
472 ocoxxxdkkkOk000kd,           ,0o       :O; ,0d  .xXX0,  .kO.  lXc                :dokxxOOO0xkOxodxxx
473 oloxxddkkkOO00Okd,           '0x.  ..,lkc  ;0l   :OXx.   cKc  ;Kd.               :dokkOKOO0kkOxodxxx
474 oloxxddkkkOO0kkkd,           .lxlclool:.   ;O:   .'c;    'Ok. .d0kxdxxo.         :dokO0KOO0xkOxodxxx
475 lldxxdokkkOO0kxkd,                         ...            ,:.   ';cloo:.         :dokk0XOOOxxOkddxxx
476 lldxxddkkkO0Kxxkd,                                                               :dokO0X00OxxOkddxxx
477 lldxxddkxkO0Kxxxd,                                                               :dokO0X0OOxkOkddxxx
478 lldxxddkxkOO0kxxo,                                                               :od000XOOOxkOkddxxx
479 lldxxdxkxkOO0kxdo,                                                               :od0O0X0OOxkOkddxxx
480 loxxxdxkxkOOKkxdo,                                                              .lod00KXOOOxkOkddxxx
481 loxxxdxkxkO0Kkxdo,                                                          .':cdkxkK0KKOOOxkOkddxxx
482 loxxxdxkxOO0K00xol,..                                                   .':ldkkxxkO00000O0OxkOkddxxx
483 loxxxdxkkOOO000Oxxxdl:,.                                            .,:ldkkxxkOOO00000000OkkOOkddxxx
484 loxxxxkkkO00O0000Okkxxxxdoloc'.                                 .':ldkkxxkOOO000000000OOkkOOOkxddxxx
485 loxxxdxOkkkkO0000000OOkkk000Okdc;'.                         .,:ldkkxxxkOO00000000OOOOOOOOkkxxddxxxxd
486 llodxddxxkOkkkkkO00000000Okkkkxxxxoc;'.                 .,:ldkkxxkkkO00000000OkkkkOOOkkxxxdxxxxxdool
487 oollodxxxxxxkOkkxkkO0000000KKK0Okkddddoc:,.         .,:ldkkxdkOOO00000000OkkkkkOOkkxxddxxxxxddoolloo
488 lloooloodxxxxxxkkkkxkkO000000000000Okxddxxol:,..,:cldkkxdxkOO00000000OkkkkkOOkkxxddxxxxxdddoollooooo
489 ccllloooooddxxxxxxkkOkkkkO0000000000000OOOOO0KOOOOkxdxkkO0000O000OkkkkkOOkkxxxdxxxxxxddoooloooooollc
490 lccccllooolooddxxxxxxxkOkkkkkkkkOO00O000KKKKKKK00OOOO000000000OkkkkOOOkxxddxxxxxxddoooloooooollccccc
491 ccclccccloooolloodxxxxdxxkOOOOOOkkkkO00OO0000KKKKKK0000000OkkkkkOOkxxxddxxxxxddoolloooooollcccccccll
492 :::clllccclloooolloodxxxxxxxkkkkkOOkkkkOO00O0000000000OOkkkkOOkxxxxxxxxxxxdoollloooooollccccclclllll
493 :::::ccllccccllooollloddxxxxxxxxxxkkOOkkkkOO00000OOOkkkkOOkxxxddxxxxxxdooolloooooollccccccllcllllcc:
494 ;:::;::cccllcccllooooolloddxxxxxxxxxxxkkOOkkkOOOkkkkOOkxxxddxxxxxxddoolllooooolllcccclllcclllccc::::
495 ',;;::::::ccllcccclloooooloooddxxxxxxxxxxkkOOOOOOkkkxxddxxxxxxxdoolllooooolllccccclccllllccc::::::::
496 ''',;;::::::cclccccccllllooollloodxxxxxxxxxxxkxxxdddxxxxxxxdoollloooooollcccccllcllcclcc::::::::::;;
497 ''''',;:::::::cccllcccccccooooolllodxxxxxxxxxdddxxxxxxxxxdolllooooooolccccccclllllllcc:;::::::::;,,'
498 
499     Ultraminers are synthesized from the burning of two BMCs. They are hand drawn rare and unique artworks inspired by Bitcoin miners (AntminerS19j ASIC Pro). 
500 
501 */
502 
503 interface IBMC {
504     function burn(uint256 tokenId) external;
505     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
506     function ownerOf(uint256 tokenId) external view returns (address);
507 }
508 
509 contract Ultraminers is NFTOptimized, Ownable {
510   using Strings for uint256;
511   bool private synthesizerState = false;
512 
513   string public baseURI;
514   address public umContract;
515   IBMC public bmc;
516 
517   constructor(string memory _name, string memory _symbol, IBMC _bmc) NFTOptimized(_name, _symbol) {
518     baseURI = "ipfs://QmVGRm43vSXRyzRRM3C8j3rvLDabuxS3nT6V5ftMjXPpL3/";
519     bmc = _bmc;
520     umContract = address(this);
521   }
522 
523   modifier nonContract() {
524     require(tx.origin == msg.sender, "No Smart Contracts allowed");
525     _;
526   }
527 
528   function synthesizeUltraminer(uint256 firstbmc, uint256 secondbmc) external nonContract{
529     require(synthesizerState, "The Synthesizer is not active currently.");
530     address caller = _msgSender();
531     require(bmc.isApprovedForAll(caller, umContract), "Synthesizer is not approved to burn your NFTs.");
532     require(bmc.ownerOf(firstbmc) == caller && bmc.ownerOf(secondbmc) == caller, "Synthesizer Caller is not Owner.");
533     uint256 supply = totalCreated();
534  
535     bmc.burn(firstbmc);
536     bmc.burn(secondbmc);
537 
538     _safeMint(caller, supply, "");
539 
540   }
541 
542   function synthesizeManyUltraminers(uint256[] memory bmcs) external nonContract{
543     require(synthesizerState, "The Synthesizer is not active currently.");
544     require(bmcs.length % 2 == 0, "Uneven number of BMCs inputted.");
545     address caller = _msgSender();
546     require(bmc.isApprovedForAll(caller, umContract), "Synthesizer is not approved to burn your NFTs.");
547     uint256 supply = totalCreated();
548 
549     for (uint256 i = 0; i < bmcs.length; i += 2) {
550 
551         uint256 firstbmc = bmcs[i];
552         uint256 secondbmc = bmcs[i + 1];
553         require(bmc.ownerOf(firstbmc) == caller && bmc.ownerOf(secondbmc) == caller, "Synthesizer Caller is not Owner.");
554 
555         bmc.burn(firstbmc);
556         bmc.burn(secondbmc);
557 
558         _safeMint(caller, supply + i/2, "");
559     }
560 
561   }
562 
563   function setBaseURI(string memory _newBaseURI) external onlyOwner {
564     baseURI = _newBaseURI;
565   }
566 
567   function setBmcContract(IBMC _newBmcContract) external onlyOwner {
568     bmc = _newBmcContract;
569   }
570 
571   function setSynthesizerState(bool _state) external onlyOwner {
572         synthesizerState = _state;
573   }
574 
575   function burn(uint256 tokenId) public {
576     require(_isApprovedOrOwner(_msgSender(), tokenId));
577     _burn(tokenId);
578   }
579 
580    /**
581     VIEW FUNCTIONS
582    */
583 
584   function _baseURI() internal view virtual returns (string memory) {
585 	return baseURI;
586   }
587 
588   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
589 	require(_exists(tokenId), "Token does not exist");
590 
591 	string memory currentBaseURI = _baseURI();
592 	return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : "";
593   }
594 
595   function getSynthesizerState() public view returns (bool){
596         return synthesizerState;
597   }
598 
599   function getBmcApprovalStatus(address _address) public view returns (bool){
600         return bmc.isApprovedForAll(_address, umContract);
601   }
602 
603   function isApprovedForAll(address _owner, address _operator) public override view returns (bool isOperator) {
604         if (_operator == address(0xa5409ec958C83C3f309868babACA7c86DCB077c1)) {     // OpenSea Address
605             return true;
606         }
607         
608         return NFTOptimized.isApprovedForAll(_owner, _operator);
609   }
610 
611 }