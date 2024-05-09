1 // SPDX-License-Identifier: MIT
2 
3 //  ███████▓█████▓▓╬╬╬╬╬╬╬╬▓███▓╬╬╬╬╬╬╬▓╬╬▓█ 
4 //  ████▓▓▓▓╬╬▓█████╬╬╬╬╬╬███▓╬╬╬╬╬╬╬╬╬╬╬╬╬█ 
5 //  ███▓▓▓▓╬╬╬╬╬╬▓██╬╬╬╬╬╬▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓█ 
6 //  ████▓▓▓╬╬╬╬╬╬╬▓█▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓█ 
7 //  ███▓█▓███████▓▓███▓╬╬╬╬╬╬▓███████▓╬╬╬╬▓█ 
8 //  ████████████████▓█▓╬╬╬╬╬▓▓▓▓▓▓▓▓╬╬╬╬╬╬╬█ 
9 //  ███▓▓▓▓▓▓▓╬╬▓▓▓▓▓█▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓█ 
10 //  ████▓▓▓╬╬╬╬▓▓▓▓▓▓█▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓█ 
11 //  ███▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓█ 
12 //  █████▓▓▓▓▓▓▓▓█▓▓▓█▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓█ 
13 //  █████▓▓▓▓▓▓▓██▓▓▓█▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬██ 
14 //  █████▓▓▓▓▓████▓▓▓█▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬██ 
15 //  ████▓█▓▓▓▓██▓▓▓▓██╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬██ 
16 //  ████▓▓███▓▓▓▓▓▓▓██▓╬╬╬╬╬╬╬╬╬╬╬╬█▓╬▓╬╬▓██ 
17 //  █████▓███▓▓▓▓▓▓▓▓████▓▓╬╬╬╬╬╬╬█▓╬╬╬╬╬▓██ 
18 //  █████▓▓█▓███▓▓▓████╬▓█▓▓╬╬╬▓▓█▓╬╬╬╬╬╬███ 
19 //  ██████▓██▓███████▓╬╬╬▓▓╬▓▓██▓╬╬╬╬╬╬╬▓███ 
20 //  ███████▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬╬╬╬╬╬╬╬╬╬╬████ 
21 //  ███████▓▓██▓▓▓▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓████ 
22 //  ████████▓▓▓█████▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓█████ 
23 //  █████████▓▓▓█▓▓▓▓▓███▓╬╬╬╬╬╬╬╬╬╬╬▓██████ 
24 //  ██████████▓▓▓█▓▓▓╬▓██╬╬╬╬╬╬╬╬╬╬╬▓███████ 
25 //  ███████████▓▓█▓▓▓▓███▓╬╬╬╬╬╬╬╬╬▓████████ 
26 //  ██████████████▓▓▓███▓▓╬╬╬╬╬╬╬╬██████████ 
27 //  ███████████████▓▓▓██▓▓╬╬╬╬╬╬▓███████████
28 
29 //  .____     ___________ ___________________ _______  ________    _________                           
30 //  |    |    \_   _____//  _____/\_   _____/ \      \ \______ \  /   _____/                           
31 //  |    |     |    __)_/   \  ___ |    __)_  /   |   \ |    |  \ \_____  \                            
32 //  |    |___  |        \    \_\  \|        \/    |    \|    `   \/        \                           
33 //  |_______ \/_______  /\______  /_______  /\____|__  /_______  /_______  /                           
34 //          \/        \/        \/        \/         \/        \/        \/                            
35 //  ________  ___________    ______________ ______________                                                
36 //  \_____  \ \_   _____/    \__    ___/   |   \_   _____/                                                
37 //   /   |   \ |    __)        |    | /    ~    \    __)_                                                 
38 //  /    |    \|     \         |    | \    Y    /        \                                                
39 //  \_______  /\___  /         |____|  \___|_  /_______  /                                                
40 //          \/     \/                        \/        \/                                                 
41 //  ___________._____________  ______________________________ ________ __________  _______  ___________
42 //  \_   _____/|   \______   \/   _____/\__    ___/\______   \\_____  \\______   \ \      \ \_   _____/
43 //   |    __)  |   ||       _/\_____  \   |    |    |    |  _/ /   |   \|       _/ /   |   \ |    __)_ 
44 //   |     \   |   ||    |   \/        \  |    |    |    |   \/    |    \    |   \/    |    \|        \
45 //   \___  /   |___||____|_  /_______  /  |____|    |______  /\_______  /____|_  /\____|__  /_______  /
46 //       \/                \/        \/                    \/         \/       \/         \/        \/ 
47 
48 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
49 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
50 
51 pragma solidity ^0.8.0;
52 
53 library MerkleProof {
54 
55     function verify(
56         bytes32[] memory proof,
57         bytes32 root,
58         bytes32 leaf
59     ) internal pure returns (bool) {
60         return processProof(proof, leaf) == root;
61     }
62 
63     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
64         bytes32 computedHash = leaf;
65         for (uint256 i = 0; i < proof.length; i++) {
66             bytes32 proofElement = proof[i];
67             if (computedHash <= proofElement) {
68                 // Hash(current computed hash + current element of the proof)
69                 computedHash = _efficientHash(computedHash, proofElement);
70             } else {
71                 // Hash(current element of the proof + current computed hash)
72                 computedHash = _efficientHash(proofElement, computedHash);
73             }
74         }
75         return computedHash;
76     }
77 
78     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
79         assembly {
80             mstore(0x00, a)
81             mstore(0x20, b)
82             value := keccak256(0x00, 0x40)
83         }
84     }
85 }
86 
87 // File: @openzeppelin/contracts/utils/Strings.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 
95 library Strings {
96     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
97 
98 
99     function toString(uint256 value) internal pure returns (string memory) {
100         // Inspired by OraclizeAPI's implementation - MIT licence
101         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
102 
103         if (value == 0) {
104             return "0";
105         }
106         uint256 temp = value;
107         uint256 digits;
108         while (temp != 0) {
109             digits++;
110             temp /= 10;
111         }
112         bytes memory buffer = new bytes(digits);
113         while (value != 0) {
114             digits -= 1;
115             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
116             value /= 10;
117         }
118         return string(buffer);
119     }
120 
121 
122     function toHexString(uint256 value) internal pure returns (string memory) {
123         if (value == 0) {
124             return "0x00";
125         }
126         uint256 temp = value;
127         uint256 length = 0;
128         while (temp != 0) {
129             length++;
130             temp >>= 8;
131         }
132         return toHexString(value, length);
133     }
134 
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
149 // File: @openzeppelin/contracts/utils/Context.sol
150 
151 //  ───────█████████████████████
152 //  ────████▀─────────────────▀████
153 //  ──███▀───────────────────────▀███
154 //  ─██▀───────────────────────────▀██
155 //  █▀───────────────────────────────▀█
156 //  █─────────────────────────────────█
157 //  █─────────────────────────────────█
158 //  █─────────────────────────────────█
159 //  █───█████─────────────────█████───█
160 //  █──██▓▓▓███─────────────███▓▓▓██──█
161 //  █──██▓▓▓▓▓██───────────██▓▓▓▓▓██──█
162 //  █──██▓▓▓▓▓▓██─────────██▓▓▓▓▓▓██──█
163 //  █▄──████▓▓▓▓██───────██▓▓▓▓████──▄█
164 //  ▀█▄───▀███▓▓▓██─────██▓▓▓███▀───▄█▀
165 //  ──█▄────▀█████▀─────▀█████▀────▄█
166 //  ─▄██───────────▄█─█▄───────────██▄
167 //  ─███───────────██─██───────────███
168 //  ─███───────────────────────────███
169 //  ──▀██──██▀██──█──█──█──██▀██──██▀
170 //  ───▀████▀─██──█──█──█──██─▀████▀
171 //  ────▀██▀──██──█──█──█──██──▀██▀
172 //  ──────────██──█──█──█──██
173 //  ──────────██──█──█──█──██
174 //  ──────────██──█──█──█──██
175 //  ──────────██──█──█──█──██
176 //  ──────────██──█──█──█──██
177 //  ──────────██──█──█──█──██
178 //  ──────────██──█──█──█──██
179 //  ──────────██──█──█──█──██
180 //  ──────────██──█──█──█──██
181 //  ──────────██──█──█──█──██
182 //  ──────────██──█──█──█──██
183 //  ──────────██──█──█──█──██
184 //  ───────────█▄▄█▄▄█▄▄█▄▄█
185 
186 
187 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 abstract contract Context {
192     function _msgSender() internal view virtual returns (address) {
193         return msg.sender;
194     }
195 
196     function _msgData() internal view virtual returns (bytes calldata) {
197         return msg.data;
198     }
199 }
200 
201 // File: @openzeppelin/contracts/access/Ownable.sol
202 
203 
204 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 
209 abstract contract Ownable is Context {
210     address private _owner;
211 
212     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213 
214 
215     constructor() {
216         _transferOwnership(_msgSender());
217     }
218 
219 
220     function owner() public view virtual returns (address) {
221         return _owner;
222     }
223 
224 
225     modifier onlyOwner() {
226         require(owner() == _msgSender(), "Ownable: caller is not the owner");
227         _;
228     }
229 
230       function renounceOwnership() public virtual onlyOwner {
231         _transferOwnership(address(0));
232     }
233 
234 
235     function transferOwnership(address newOwner) public virtual onlyOwner {
236         require(newOwner != address(0), "Ownable: new owner is the zero address");
237         _transferOwnership(newOwner);
238     }
239 
240 
241     function _transferOwnership(address newOwner) internal virtual {
242         address oldOwner = _owner;
243         _owner = newOwner;
244         emit OwnershipTransferred(oldOwner, newOwner);
245     }
246 }
247 
248 // File: @openzeppelin/contracts/utils/Address.sol
249 
250 
251 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
252 
253 pragma solidity ^0.8.1;
254 
255 
256 library Address {
257       function isContract(address account) internal view returns (bool) {
258         // This method relies on extcodesize/address.code.length, which returns 0
259         // for contracts in construction, since the code is only stored at the end
260         // of the constructor execution.
261 
262         return account.code.length > 0;
263     }
264 
265       function sendValue(address payable recipient, uint256 amount) internal {
266         require(address(this).balance >= amount, "Address: insufficient balance");
267 
268         (bool success, ) = recipient.call{value: amount}("");
269         require(success, "Address: unable to send value, recipient may have reverted");
270     }
271 
272       function functionCall(address target, bytes memory data) internal returns (bytes memory) {
273         return functionCall(target, data, "Address: low-level call failed");
274     }
275 
276 
277     function functionCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         return functionCallWithValue(target, data, 0, errorMessage);
283     }
284 
285     function functionCallWithValue(
286         address target,
287         bytes memory data,
288         uint256 value
289     ) internal returns (bytes memory) {
290         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
291     }
292 
293      function functionCallWithValue(
294         address target,
295         bytes memory data,
296         uint256 value,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         require(address(this).balance >= value, "Address: insufficient balance for call");
300         require(isContract(target), "Address: call to non-contract");
301 
302         (bool success, bytes memory returndata) = target.call{value: value}(data);
303         return verifyCallResult(success, returndata, errorMessage);
304     }
305 
306       function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
307         return functionStaticCall(target, data, "Address: low-level static call failed");
308     }
309 
310 
311     function functionStaticCall(
312         address target,
313         bytes memory data,
314         string memory errorMessage
315     ) internal view returns (bytes memory) {
316         require(isContract(target), "Address: static call to non-contract");
317 
318         (bool success, bytes memory returndata) = target.staticcall(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322 
323     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
324         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
325     }
326 
327 
328     function functionDelegateCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         require(isContract(target), "Address: delegate call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.delegatecall(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339 
340     function verifyCallResult(
341         bool success,
342         bytes memory returndata,
343         string memory errorMessage
344     ) internal pure returns (bytes memory) {
345         if (success) {
346             return returndata;
347         } else {
348             // Look for revert reason and bubble it up if present
349             if (returndata.length > 0) {
350                 // The easiest way to bubble the revert reason is using memory via assembly
351 
352                 assembly {
353                     let returndata_size := mload(returndata)
354                     revert(add(32, returndata), returndata_size)
355                 }
356             } else {
357                 revert(errorMessage);
358             }
359         }
360     }
361 }
362 
363 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
364 
365 
366 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 interface IERC721Receiver {
371 
372     function onERC721Received(
373         address operator,
374         address from,
375         uint256 tokenId,
376         bytes calldata data
377     ) external returns (bytes4);
378 }
379 
380 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 interface IERC165 {
388 
389     function supportsInterface(bytes4 interfaceId) external view returns (bool);
390 }
391 
392 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
393 
394 
395 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 
400 abstract contract ERC165 is IERC165 {
401 
402     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
403         return interfaceId == type(IERC165).interfaceId;
404     }
405 }
406 
407 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
408 
409 
410 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 
415 
416 interface IERC721 is IERC165 {
417 
418     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
419 
420     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
421 
422     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
423 
424     function balanceOf(address owner) external view returns (uint256 balance);
425 
426     function ownerOf(uint256 tokenId) external view returns (address owner);
427 
428 
429     function safeTransferFrom(
430         address from,
431         address to,
432         uint256 tokenId,
433         bytes calldata data
434     ) external;
435 
436     function safeTransferFrom(
437         address from,
438         address to,
439         uint256 tokenId
440     ) external;
441 
442     function transferFrom(
443         address from,
444         address to,
445         uint256 tokenId
446     ) external;
447 
448     function approve(address to, uint256 tokenId) external;
449 
450     function setApprovalForAll(address operator, bool _approved) external;
451 
452     function getApproved(uint256 tokenId) external view returns (address operator);
453 
454     function isApprovedForAll(address owner, address operator) external view returns (bool);
455 }
456 
457 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
458 
459 //                                  ,- 
460 //                                 //        
461 //                                /:      ,
462 //                               ;.(     //
463 //                     |   ,     /`|    //
464 //                     |\  |\    |,|   //
465 //                  |  (\  (\    |`|   |(
466 //                  (\  \\  \\   |,|   ;|
467 //              .   ||   \\  \\  |`(   ;( 
468 //              \\   \\  \\  \\  |.\\  ((                              
469 //               \\   \\  \\  \\  \\ \;/:\                 
470 //                 \\  \\  \'. \\_,\\ /\""-._                
471 //                  \\  \\  \ \-"   \/ `;._ ".
472 //                 ___\\-\\-" \ \_  /,  |_ "._\
473 //           _,--""___ \ \,_   "-_"- |".|(._ ".".-.
474 //       _,-"_,--"""__ ) "."-_    "--\ \"("o\_\ "- ".
475 //     ,",-""" _.-'''_-"   "-_"-.__   \ \_\_//\)__"\_)
476 //   ,"    ',-'  ,-""   7"  _ "-.._""_>\__`""'"__ ""``-._
477 //          ;  ," ,-",'/` ,":\.    `   `  `"""___`""-._  ".   )
478 //          ;,"_," ,' /`,"}}::\\         `... \____''' "\  '.|\
479 //         ,","   :  /`/{{)/:::"\__,---._    \  \_____'''\    \
480 //        , ,"_  ;  /`/ ///::::::::' ,-"-\    \__   \____''\ \ \
481 //       ,,"   `;| ";; /}}/::'``':::(._``."-.__  """--    '_\ \ \
482 //      ('       ;// / {;;:'`````':; /`._."""  ""-.._ `"-. " (   )
483 //      /         )(/ <";"'``   ``/ /_.(             "_  "-_"\`);
484 //                (/ <";"``     `/ /`,(                "._ _".\; 
485 //                 |<";"`   ``  / /"-"                    "  
486 //                 <";"` ``    / /__,;   
487 //   
488 //   
489 //   
490 //   
491 //   
492 //   
493 //   
494 
495 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 
500 interface IERC721Enumerable is IERC721 {
501 
502     function totalSupply() external view returns (uint256);
503 
504 
505     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
506 
507 
508     function tokenByIndex(uint256 index) external view returns (uint256);
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
512 
513 
514 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 
519 interface IERC721Metadata is IERC721 {
520 
521     function name() external view returns (string memory);
522 
523     function symbol() external view returns (string memory);
524 
525     function tokenURI(uint256 tokenId) external view returns (string memory);
526 }
527 
528 // File: contracts/finalcontract.sol
529 
530 
531 pragma solidity ^0.8.0;
532 
533 error ApprovalCallerNotOwnerNorApproved();
534 error ApprovalQueryForNonexistentToken();
535 error ApproveToCaller();
536 error ApprovalToCurrentOwner();
537 error BalanceQueryForZeroAddress();
538 error MintedQueryForZeroAddress();
539 error MintToZeroAddress();
540 error MintZeroQuantity();
541 error OwnerIndexOutOfBounds();
542 error OwnerQueryForNonexistentToken();
543 error TokenIndexOutOfBounds();
544 error TransferCallerNotOwnerNorApproved();
545 error TransferFromIncorrectOwner();
546 error TransferToNonERC721ReceiverImplementer();
547 error TransferToZeroAddress();
548 error UnableDetermineTokenOwner();
549 error URIQueryForNonexistentToken();
550 
551 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
552     using Address for address;
553     using Strings for uint256;
554 
555     struct TokenOwnership {
556         address addr;
557         uint64 startTimestamp;
558     }
559 
560     struct AddressData {
561         uint128 balance;
562         uint128 numberMinted;
563     }
564 
565     uint256 internal _currentIndex;
566 
567     // Token name
568     string private _name;
569 
570     // Token symbol
571     string private _symbol;
572 
573     // Mapping from token ID to ownership details
574     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
575     mapping(uint256 => TokenOwnership) internal _ownerships;
576 
577     // Mapping owner address to address data
578     mapping(address => AddressData) private _addressData;
579 
580     // Mapping from token ID to approved address
581     mapping(uint256 => address) private _tokenApprovals;
582 
583     // Mapping from owner to operator approvals
584     mapping(address => mapping(address => bool)) private _operatorApprovals;
585 
586     constructor(string memory name_, string memory symbol_) {
587         _name = name_;
588         _symbol = symbol_;
589     }
590 
591     function totalSupply() public view override returns (uint256) {
592         return _currentIndex;
593     }
594 
595     function tokenByIndex(uint256 index) public view override returns (uint256) {
596         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
597         return index;
598     }
599 
600     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
601         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
602         uint256 numMintedSoFar = totalSupply();
603         uint256 tokenIdsIdx;
604         address currOwnershipAddr;
605 
606         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
607         unchecked {
608             for (uint256 i; i < numMintedSoFar; i++) {
609                 TokenOwnership memory ownership = _ownerships[i];
610                 if (ownership.addr != address(0)) {
611                     currOwnershipAddr = ownership.addr;
612                 }
613                 if (currOwnershipAddr == owner) {
614                     if (tokenIdsIdx == index) {
615                         return i;
616                     }
617                     tokenIdsIdx++;
618                 }
619             }
620         }
621 
622         // Execution should never reach this point.
623         assert(false);
624         return tokenIdsIdx;
625     }
626 
627     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
628         return
629             interfaceId == type(IERC721).interfaceId ||
630             interfaceId == type(IERC721Metadata).interfaceId ||
631             interfaceId == type(IERC721Enumerable).interfaceId ||
632             super.supportsInterface(interfaceId);
633     }
634 
635     function balanceOf(address owner) public view override returns (uint256) {
636         if (owner == address(0)) revert BalanceQueryForZeroAddress();
637         return uint256(_addressData[owner].balance);
638     }
639 
640     function _numberMinted(address owner) internal view returns (uint256) {
641         if (owner == address(0)) revert MintedQueryForZeroAddress();
642         return uint256(_addressData[owner].numberMinted);
643     }
644 
645 
646     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
647         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
648 
649         unchecked {
650             for (uint256 curr = tokenId; curr >= 0; curr--) {
651                 TokenOwnership memory ownership = _ownerships[curr];
652                 if (ownership.addr != address(0)) {
653                     return ownership;
654                 }
655             }
656         }
657 
658         revert UnableDetermineTokenOwner();
659     }
660 
661 
662     function ownerOf(uint256 tokenId) public view override returns (address) {
663         return ownershipOf(tokenId).addr;
664     }
665 
666 
667     function name() public view virtual override returns (string memory) {
668         return _name;
669     }
670 
671 
672     function symbol() public view virtual override returns (string memory) {
673         return _symbol;
674     }
675 
676 
677     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
678         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
679 
680         string memory baseURI = _baseURI();
681         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
682     }
683 
684 
685     function _baseURI() internal view virtual returns (string memory) {
686         return '';
687     }
688 
689 
690     function approve(address to, uint256 tokenId) public override {
691         address owner = ERC721A.ownerOf(tokenId);
692         if (to == owner) revert ApprovalToCurrentOwner();
693 
694         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) revert ApprovalCallerNotOwnerNorApproved();
695 
696         _approve(to, tokenId, owner);
697     }
698 
699 
700     function getApproved(uint256 tokenId) public view override returns (address) {
701         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
702 
703         return _tokenApprovals[tokenId];
704     }
705 
706 
707     function setApprovalForAll(address operator, bool approved) public override {
708         if (operator == _msgSender()) revert ApproveToCaller();
709 
710         _operatorApprovals[_msgSender()][operator] = approved;
711         emit ApprovalForAll(_msgSender(), operator, approved);
712     }
713 
714 
715     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
716         return _operatorApprovals[owner][operator];
717     }
718 
719 
720     function transferFrom(
721         address from,
722         address to,
723         uint256 tokenId
724     ) public virtual override {
725         _transfer(from, to, tokenId);
726     }
727 
728 
729     function safeTransferFrom(
730         address from,
731         address to,
732         uint256 tokenId
733     ) public virtual override {
734         safeTransferFrom(from, to, tokenId, '');
735     }
736 
737 
738     function safeTransferFrom(
739         address from,
740         address to,
741         uint256 tokenId,
742         bytes memory _data
743     ) public override {
744         _transfer(from, to, tokenId);
745         if (!_checkOnERC721Received(from, to, tokenId, _data)) revert TransferToNonERC721ReceiverImplementer();
746     }
747 
748 
749     function _exists(uint256 tokenId) internal view returns (bool) {
750         return tokenId < _currentIndex;
751     }
752 
753     function _safeMint(address to, uint256 quantity) internal {
754         _safeMint(to, quantity, '');
755     }
756 
757 
758     function _safeMint(
759         address to,
760         uint256 quantity,
761         bytes memory _data
762     ) internal {
763         _mint(to, quantity, _data, true);
764     }
765 
766 
767     function _mint(
768         address to,
769         uint256 quantity,
770         bytes memory _data,
771         bool safe
772     ) internal {
773         uint256 startTokenId = _currentIndex;
774         if (to == address(0)) revert MintToZeroAddress();
775         if (quantity == 0) revert MintZeroQuantity();
776 
777         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
778 
779         // Overflows are incredibly unrealistic.
780         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
781         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
782         unchecked {
783             _addressData[to].balance += uint128(quantity);
784             _addressData[to].numberMinted += uint128(quantity);
785 
786             _ownerships[startTokenId].addr = to;
787             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
788 
789             uint256 updatedIndex = startTokenId;
790 
791             for (uint256 i; i < quantity; i++) {
792                 emit Transfer(address(0), to, updatedIndex);
793                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
794                     revert TransferToNonERC721ReceiverImplementer();
795                 }
796 
797                 updatedIndex++;
798             }
799 
800             _currentIndex = updatedIndex;
801         }
802 
803         _afterTokenTransfers(address(0), to, startTokenId, quantity);
804     }
805 
806 
807     function _transfer(
808         address from,
809         address to,
810         uint256 tokenId
811     ) private {
812         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
813 
814         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
815             getApproved(tokenId) == _msgSender() ||
816             isApprovedForAll(prevOwnership.addr, _msgSender()));
817 
818         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
819         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
820         if (to == address(0)) revert TransferToZeroAddress();
821 
822         _beforeTokenTransfers(from, to, tokenId, 1);
823 
824         // Clear approvals from the previous owner
825         _approve(address(0), tokenId, prevOwnership.addr);
826 
827         // Underflow of the sender's balance is impossible because we check for
828         // ownership above and the recipient's balance can't realistically overflow.
829         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
830         unchecked {
831             _addressData[from].balance -= 1;
832             _addressData[to].balance += 1;
833 
834             _ownerships[tokenId].addr = to;
835             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
836 
837             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
838             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
839             uint256 nextTokenId = tokenId + 1;
840             if (_ownerships[nextTokenId].addr == address(0)) {
841                 if (_exists(nextTokenId)) {
842                     _ownerships[nextTokenId].addr = prevOwnership.addr;
843                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
844                 }
845             }
846         }
847 
848         emit Transfer(from, to, tokenId);
849         _afterTokenTransfers(from, to, tokenId, 1);
850     }
851 
852 
853     function _approve(
854         address to,
855         uint256 tokenId,
856         address owner
857     ) private {
858         _tokenApprovals[tokenId] = to;
859         emit Approval(owner, to, tokenId);
860     }
861 
862 
863     function _checkOnERC721Received(
864         address from,
865         address to,
866         uint256 tokenId,
867         bytes memory _data
868     ) private returns (bool) {
869         if (to.isContract()) {
870             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
871                 return retval == IERC721Receiver(to).onERC721Received.selector;
872             } catch (bytes memory reason) {
873                 if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
874                 else {
875                     assembly {
876                         revert(add(32, reason), mload(reason))
877                     }
878                 }
879             }
880         } else {
881             return true;
882         }
883     }
884 
885 
886     function _beforeTokenTransfers(
887         address from,
888         address to,
889         uint256 startTokenId,
890         uint256 quantity
891     ) internal virtual {}
892 
893 
894     function _afterTokenTransfers(
895         address from,
896         address to,
897         uint256 startTokenId,
898         uint256 quantity
899     ) internal virtual {}
900 }
901 
902 
903 
904 contract LEGEND is ERC721A, Ownable{
905     using Strings for uint256;
906     uint256 public constant MAX_SUPPLY = 11111;
907     uint256 public constant MAX_PUBLIC_MINT = 5;
908     uint256 public constant MAX_WHITELIST_MINT = 5;
909     uint256 public PUBLIC_SALE_PRICE = .00 ether;
910     uint256 public WHITELIST_SALE_PRICE = .00 ether;
911 
912     string private  baseTokenUri;
913     string public   placeholderTokenUri;
914 
915     //deploy smart contract, toggle WL, toggle WL when done, toggle publicSale 
916     //2 days later toggle reveal
917     bool public isRevealed;
918     bool public publicSale;
919     bool public whiteListSale;
920     bool public pause;
921     bool public teamMinted;
922 
923     bytes32 private merkleRoot;
924 
925     mapping(address => uint256) public totalPublicMint;
926     mapping(address => uint256) public totalWhitelistMint;
927 
928     constructor() ERC721A("LEGENDS OF THE FIRSTBORNE", "LOTFB"){
929 
930     }
931 
932     modifier callerIsUser() {
933         require(tx.origin == msg.sender, "FIRSTBORNE :: Cannot be called by a contract");
934         _;
935     }
936 
937     function mint(uint256 _quantity) external payable callerIsUser{
938         require(publicSale, "FIRSTBORNE :: Not Yet Active.");
939         require((totalSupply() + _quantity) <= MAX_SUPPLY, "FIRSTBORNE :: Beyond Max Supply");
940         require((totalPublicMint[msg.sender] +_quantity) <= MAX_PUBLIC_MINT, "FIRSTBORNE :: Already minted 3 times!");
941         require(msg.value >= (PUBLIC_SALE_PRICE * _quantity), "FIRSTBORNE :: Below ");
942 
943         totalPublicMint[msg.sender] += _quantity;
944         _safeMint(msg.sender, _quantity);
945     }
946 
947     function whitelistMint(bytes32[] memory _merkleProof, uint256 _quantity) external payable callerIsUser{
948         require(whiteListSale, "FIRSTBORNE :: Minting is on Pause");
949         require((totalSupply() + _quantity) <= MAX_SUPPLY, "FIRSTBORNE :: Cannot mint beyond max supply");
950         require((totalWhitelistMint[msg.sender] + _quantity)  <= MAX_WHITELIST_MINT, "FIRSTBORNE :: Cannot mint beyond whitelist max mint!");
951         require(msg.value >= (WHITELIST_SALE_PRICE * _quantity), "FIRSTBORNE :: Payment is below the price");
952         //create leaf node
953         bytes32 sender = keccak256(abi.encodePacked(msg.sender));
954         require(MerkleProof.verify(_merkleProof, merkleRoot, sender), "FIRSTBORNE :: You are not whitelisted");
955 
956         totalWhitelistMint[msg.sender] += _quantity;
957         _safeMint(msg.sender, _quantity);
958     }
959 
960     function teamMint() external onlyOwner{
961         require(!teamMinted, "FIRSTBORNE :: Team already minted");
962         teamMinted = true;
963         _safeMint(msg.sender, 500);
964     }
965 
966     function _baseURI() internal view virtual override returns (string memory) {
967         return baseTokenUri;
968     }
969 
970     //return uri for certain token
971     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
972         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
973 
974         uint256 trueId = tokenId + 1;
975 
976         if(!isRevealed){
977             return placeholderTokenUri;
978         }
979         //string memory baseURI = _baseURI();
980         return bytes(baseTokenUri).length > 0 ? string(abi.encodePacked(baseTokenUri, trueId.toString(), ".json")) : "";
981     }
982 
983     /// @dev walletOf() function shouldn't be called on-chain due to gas consumption
984     function walletOf() external view returns(uint256[] memory){
985         address _owner = msg.sender;
986         uint256 numberOfOwnedNFT = balanceOf(_owner);
987         uint256[] memory ownerIds = new uint256[](numberOfOwnedNFT);
988 
989         for(uint256 index = 0; index < numberOfOwnedNFT; index++){
990             ownerIds[index] = tokenOfOwnerByIndex(_owner, index);
991         }
992 
993         return ownerIds;
994     }
995 
996     function setTokenUri(string memory _baseTokenUri) external onlyOwner{
997         baseTokenUri = _baseTokenUri;
998     }
999     function setPlaceHolderUri(string memory _placeholderTokenUri) external onlyOwner{
1000         placeholderTokenUri = _placeholderTokenUri;
1001     }
1002 
1003     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner{
1004         merkleRoot = _merkleRoot;
1005     }
1006 
1007     function getMerkleRoot() external view returns (bytes32){
1008         return merkleRoot;
1009     }
1010 
1011     function togglePause() external onlyOwner{
1012         pause = !pause;
1013     }
1014 
1015     function toggleWhiteListSale() external onlyOwner{
1016         whiteListSale = !whiteListSale;
1017     }
1018 
1019     function togglePublicSale() external onlyOwner{
1020         publicSale = !publicSale;
1021     }
1022 
1023      function update_public_price(uint price) external onlyOwner {
1024         PUBLIC_SALE_PRICE = price;
1025     }
1026        function update_preSale_price(uint price) external onlyOwner {
1027         WHITELIST_SALE_PRICE = price;
1028     }
1029 
1030 function AirDrop(address[] memory _wallets, uint _count) public onlyOwner{
1031         require(_wallets.length > 0, "mint at least one token");
1032         require(totalSupply() + _wallets.length <= MAX_SUPPLY, "not enough tokens left");
1033         for (uint i = 0; i < _wallets.length; i++)
1034         {
1035             _safeMint(_wallets[i], _count);
1036         }
1037     }
1038 
1039     function toggleReveal() external onlyOwner{
1040         isRevealed = !isRevealed;
1041     }
1042 
1043     function withdraw() external onlyOwner{
1044 uint _balance = address(this).balance;
1045         payable(owner()).transfer(_balance );//owner
1046 }
1047 }
1048 
1049 
1050 //                                                             ▓▓▓▓▓▓                                                          
1051 //                                                   ░░▓▓▓▓▓▓▓▓▓▓▓▓          ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                    
1052 //                                               ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░                                    
1053 //                                           ▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒                                  
1054 //                                         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                            
1055 //                                       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                        
1056 //                                   ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    ▓▓▓▓                      
1057 //                                 ▓▓▓▓▓▓▓▓▓▓░░░░    ░░░░░░▓▓▓▓▓▓        ▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒  ▒▒░░                      
1058 //                               ██▓▓                                        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                        
1059 //                             ▓▓                                              ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                      
1060 //                                                                             ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                  
1061 //                               ▓▓  ▓▓                                        ▓▓▓▓▓▓▓▓▓▓        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░              
1062 //                             ▓▓▓▓  ▓▓▓▓            ░░▓▓▒▒                    ▓▓▓▓▓▓▓▓▓▓▓▓      ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓              
1063 //                               ▓▓  ▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░      ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓          ▓▓▓▓▓▓▓▓▓▓▓▓            
1064 //                               ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓        ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██          ▓▓▓▓▓▓▓▓▓▓▓▓          
1065 //                             ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒  ▓▓▓▓▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▓          ▒▒▓▓▓▓▓▓▓▓▓▓        
1066 //                           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░▓▓▓▓▒▒▓▓▓▓▓▓▓▓▒▒  ▓▓▓▓▓▓▓▓▒▒  ▒▒▒▒▓▓▓▓▒▒          ░░▓▓▓▓▓▓▓▓▒▒      
1067 //                       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ░░▒▒            ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓        ▓▓▓▓▓▓          ░░▓▓▓▓▓▓▓▓▓▓    
1068 //                     ██▓▓▓▓▓▓  ▓▓▓▓▓▓▓▓▓▓          ░░            ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓        ▓▓▓▓▓▓          ▓▓▓▓▓▓▓▓▓▓    
1069 //                 ░░▒▒▓▓▓▓░░  ▓▓▓▓▓▓▓▓▓▓▓▓                        ░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓        ▒▒▓▓▓▓          ░░▓▓▓▓▓▓▓▓    
1070 //                 ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░                            ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒        ░░▓▓▒▒          ▓▓▓▓▓▓▓▓▒▒  
1071 //               ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░  ██                        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓          ░░▓▓          ░░▓▓▓▓▓▓▓▓  
1072 //       ▒▒▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓░░                        ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓            ▓▓░░          ▓▓▓▓▓▓▓▓  
1073 //       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                          ▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓▓▓              ▒▒            ▓▓▓▓▓▓▓▓
1074 //       ▓▓▓▓▓▓▓▓▓▓▓▓  ██  ██    ▓▓▓▓▓▓▓▓▓▓                            ▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓▓▓              ▓▓▓▓          ▓▓▓▓▓▓▓▓
1075 //       ░░▓▓▓▓▓▓░░▓▓    ▓▓    ░░▓▓▓▓░░                            ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ░░▓▓              ▒▒▓▓          ▓▓▓▓▓▓▓▓
1076 //         ░░▓▓░░      ▓▓░░    ▓▓▓▓                              ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    ▓▓              ░░▓▓          ░░▓▓▓▓▓▓
1077 //             ██  ░░▓▓    ██  ▓▓▒▒  ██                        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓    ▓▓              ░░▓▓            ▓▓▓▓▓▓
1078 //             ░░  ░░▓▓    ▒▒▒▒▓▓▒▒▒▒▒▒                      ▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓    ▓▓              ░░▓▓            ▓▓▓▓▓▓
1079 //                 ▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓                  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░  ░░    ▓▓              ░░▓▓            ▓▓▓▓▓▓
1080 //             ██  ▓▓      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓            ▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓▓▓░░▓▓▓▓                          ░░▓▓            ▓▓▓▓▓▓
1081 //           ▓▓    ▒▒        ▓▓▓▓                ██▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓                                  ░░██            ▓▓▓▓▓▓
1082 //         ▒▒▓▓  ▒▒▓▓        ░░░░            ▒▒▒▒▓▓▓▓▓▓▓▓▓▓██░░      ░░                                    ░░            ▓▓▓▓▓▓
1083 //         ▓▓▒▒  ▓▓                      ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                                              ▓▓▓▓░░
1084 //       ▒▒▒▒  ▒▒▓▓                    ▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒                                                              ▓▓▓▓  
1085 //       ░░  ▒▒▓▓░░                  ▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░                                                            ░░▒▒▓▓▓▓  
1086 //       ▓▓  ▓▓░░                  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                                                ▓▓▓▓░░  
1087 //       ▓▓                        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                ▓▓                                ▓▓▓▓    
1088 //                               ██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                ░░██                            ▓▓▓▓▓▓    
1089 //                             ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                  ▓▓                            ▓▓▓▓░░    
1090 //                             ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                  ▓▓▓▓                          ▓▓▓▓      
1091 //                             ██  ▓▓▓▓▓▓    ░░▓▓▓▓██▓▓                                ▓▓▓▓                        ▓▓▓▓▓▓      
1092 //                             ▓▓  ▓▓▓▓░░      ▓▓▓▓▓▓▒▒                                ▓▓▓▓                        ▓▓▓▓▒▒      
1093 //                             ░░  ▓▓▓▓    ░░▓▓▓▓▓▓▓▓▓▓▓▓                              ▓▓▓▓                        ▓▓░░        
1094 //                                 ▓▓▓▓▒▒  ░░▓▓▓▓▓▓▓▓▓▓▓▓▒▒                            ▓▓▓▓▒▒                    ▒▒▓▓          
1095 //                                 ░░▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                          ▒▒▓▓▓▓▒▒                    ▓▓▓▓          
1096 //                                   ▓▓▓▓    ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                      ▓▓▓▓▓▓▒▒                    ▓▓            
1097 //                                     ▓▓▓▓    ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                  ▓▓▓▓▓▓▓▓▓▓                    ▓▓            
1098 //                                     ▓▓▓▓▓▓    ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██░░          ▓▓▓▓▓▓▓▓▓▓                    ▓▓▓▓            
1099 //                                       ▓▓▓▓▒▒    ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                    ▓▓▓▓            
1100 //                                       ░░▓▓▓▓▓▓    ░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░                    ░░▓▓            
1101 //                                         ░░▓▓▓▓▓▓          ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                          ▓▓            
1102 //                                           ░░▓▓▓▓▓▓▒▒            ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                            ▓▓            
1103 //                                             ░░░░▓▓▓▓▓▓        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░                            ▓▓            
1104 //                                                 ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░                                                  
1105 //                                                   ▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓              ▓▓▓▓▓▓                                      
1106 //                                                 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓░░░░                                      
1107 //                                           ░░▓▓▓▓▓▓▓▓▓▓░░░░      ▓▓▓▓▓▓▓▓▓▓▓▓  ░░░░                                          
1108 //                                         ░░▓▓▓▓▓▓▓▓                  ░░                                                      
1109 //                                         ▓▓▓▓▓▓░░░░                                                                          
1110 //                                       ▓▓▓▓▓▓░░                                                                              
1111 //                                       ▓▓▓▓        ░░▓▓▓▓██▓▓                                                                
1112 //                                       ▓▓▓▓          ▓▓▓▓▓▓▓▓▒▒▒▒▒▒                                                          
1113 //                                       ▓▓▓▓            ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                                      
1114 //                                       ▓▓▒▒            ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                                    
1115 //                                       ░░▓▓▓▓▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒  ▓▓▓▓▓▓▒▒                                                
1116 //                                         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    ▓▓▓▓░░  ▓▓▓▓▓▓                                                
1117 //                                           ░░▓▓▓▓▓▓▓▓██▓▓          ▓▓  ▓▓▓▓▓▓▓▓                                              
1118 //                                         ▓▓    ░░▓▓▒▒                ▓▓  ▓▓▓▓▓▓                                              
1119 //                                         ▒▒▒▒▓▓  ░░░░                ░░▒▒░░▓▓▓▓▒▒                                            
1120 //                                           ▒▒▓▓▓▓▓▓                    ▓▓  ▓▓▓▓▓▓                ░░░░                        
1121 //                                             ░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓      ░░  ░░▓▓▓▓              ░░    ░░                      
1122 //                                                 ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓        ▓▓▓▓              ░░░░  ▒▒  ░░░░▒▒░░            
1123 //                                                   ░░░░░░░░░░░░▓▓▓▓▓▓▓▓      ▓▓▓▓                ░░▒▒░░▒▒▒▒░░                
1124 //                                                                 ▓▓▓▓▓▓      ▓▓▓▓                                            
1125 //                                                                 ▓▓▓▓▓▓▓▓    ▓▓▓▓                                            
1126 //                                                                 ▓▓▓▓▓▓▓▓    ▓▓▓▓                                            
1127 //                                                                 ▓▓▓▓▓▓▓▓    ▓▓▓▓                                            
1128 //                                                                 ▓▓▓▓▓▓▓▓    ▓▓▓▓                                            
1129 //                                                                 ▓▓▓▓▓▓▓▓▒▒▒▒▓▓░░                                            
1130 //                                                                 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                              
1131 //                                                                 ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                              
1132 //                                                               ▓▓▓▓▓▓▓▓  ▓▓▓▓░░                                              
1133 //                                   ██▓▓▓▓▓▓▓▓▓▓▓▓              ▓▓▓▓▓▓▓▓  ▓▓░░                                                
1134 //                                 ██▓▓          ▓▓▓▓            ▓▓▓▓▓▓░░                                                      
1135 //                                 ▓▓░░          ▒▒▓▓          ▒▒▓▓▓▓▓▓                                                        
1136 //                               ▓▓▒▒            ░░▓▓          ▓▓▓▓▓▓▓▓                                                        
1137 //                               ▓▓              ▒▒▓▓        ▒▒▓▓▓▓▒▒░░                                                        
1138 //                               ▓▓            ▒▒▓▓░░      ▒▒▓▓▓▓▓▓                                                            
1139 //                             ▓▓▓▓      ▓▓▒▒▓▓▓▓░░        ▓▓▓▓▓▓░░                                                            
1140 //                             ▓▓▓▓      ░░▓▓▓▓▓▓        ▓▓▓▓▓▓                                                                
1141 //                             ▓▓▓▓                  ▓▓▓▓▓▓██                                                                  
1142 //                               ▓▓▓▓              ▓▓▓▓▓▓▓▓                                                                    
1143 //                               ░░▓▓▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓▓▓