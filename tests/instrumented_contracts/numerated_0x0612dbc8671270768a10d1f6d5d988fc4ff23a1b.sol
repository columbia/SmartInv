1 // hevm: flattened sources of src/CanvasRegistry.sol
2 // SPDX-License-Identifier: MIT AND AGPL-3.0-only AND Unlicense
3 pragma solidity =0.8.10 >=0.8.0 >=0.8.0 <0.9.0;
4 
5 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 /* pragma solidity ^0.8.0; */
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 /* pragma solidity ^0.8.0; */
34 
35 /* import "../utils/Context.sol"; */
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 ////// lib/openzeppelin-contracts/contracts/utils/Strings.sol
108 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
109 
110 /* pragma solidity ^0.8.0; */
111 
112 /**
113  * @dev String operations.
114  */
115 library Strings {
116     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
117 
118     /**
119      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
120      */
121     function toString(uint256 value) internal pure returns (string memory) {
122         // Inspired by OraclizeAPI's implementation - MIT licence
123         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
124 
125         if (value == 0) {
126             return "0";
127         }
128         uint256 temp = value;
129         uint256 digits;
130         while (temp != 0) {
131             digits++;
132             temp /= 10;
133         }
134         bytes memory buffer = new bytes(digits);
135         while (value != 0) {
136             digits -= 1;
137             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
138             value /= 10;
139         }
140         return string(buffer);
141     }
142 
143     /**
144      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
145      */
146     function toHexString(uint256 value) internal pure returns (string memory) {
147         if (value == 0) {
148             return "0x00";
149         }
150         uint256 temp = value;
151         uint256 length = 0;
152         while (temp != 0) {
153             length++;
154             temp >>= 8;
155         }
156         return toHexString(value, length);
157     }
158 
159     /**
160      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
161      */
162     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
163         bytes memory buffer = new bytes(2 * length + 2);
164         buffer[0] = "0";
165         buffer[1] = "x";
166         for (uint256 i = 2 * length + 1; i > 1; --i) {
167             buffer[i] = _HEX_SYMBOLS[value & 0xf];
168             value >>= 4;
169         }
170         require(value == 0, "Strings: hex length insufficient");
171         return string(buffer);
172     }
173 }
174 
175 ////// lib/solmate/src/tokens/ERC1155.sol
176 /* pragma solidity >=0.8.0; */
177 
178 /// @notice Minimalist and gas efficient standard ERC1155 implementation.
179 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC1155.sol)
180 abstract contract ERC1155 {
181     /*///////////////////////////////////////////////////////////////
182                                 EVENTS
183     //////////////////////////////////////////////////////////////*/
184 
185     event TransferSingle(
186         address indexed operator,
187         address indexed from,
188         address indexed to,
189         uint256 id,
190         uint256 amount
191     );
192 
193     event TransferBatch(
194         address indexed operator,
195         address indexed from,
196         address indexed to,
197         uint256[] ids,
198         uint256[] amounts
199     );
200 
201     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
202 
203     event URI(string value, uint256 indexed id);
204 
205     /*///////////////////////////////////////////////////////////////
206                             ERC1155 STORAGE
207     //////////////////////////////////////////////////////////////*/
208 
209     mapping(address => mapping(uint256 => uint256)) public balanceOf;
210 
211     mapping(address => mapping(address => bool)) public isApprovedForAll;
212 
213     /*///////////////////////////////////////////////////////////////
214                              METADATA LOGIC
215     //////////////////////////////////////////////////////////////*/
216 
217     function uri(uint256 id) public view virtual returns (string memory);
218 
219     /*///////////////////////////////////////////////////////////////
220                              ERC1155 LOGIC
221     //////////////////////////////////////////////////////////////*/
222 
223     function setApprovalForAll(address operator, bool approved) public virtual {
224         isApprovedForAll[msg.sender][operator] = approved;
225 
226         emit ApprovalForAll(msg.sender, operator, approved);
227     }
228 
229     function safeTransferFrom(
230         address from,
231         address to,
232         uint256 id,
233         uint256 amount,
234         bytes memory data
235     ) public virtual {
236         require(msg.sender == from || isApprovedForAll[from][msg.sender], "NOT_AUTHORIZED");
237 
238         balanceOf[from][id] -= amount;
239         balanceOf[to][id] += amount;
240 
241         emit TransferSingle(msg.sender, from, to, id, amount);
242 
243         require(
244             to.code.length == 0
245                 ? to != address(0)
246                 : ERC1155TokenReceiver(to).onERC1155Received(msg.sender, from, id, amount, data) ==
247                     ERC1155TokenReceiver.onERC1155Received.selector,
248             "UNSAFE_RECIPIENT"
249         );
250     }
251 
252     function safeBatchTransferFrom(
253         address from,
254         address to,
255         uint256[] memory ids,
256         uint256[] memory amounts,
257         bytes memory data
258     ) public virtual {
259         uint256 idsLength = ids.length; // Saves MLOADs.
260 
261         require(idsLength == amounts.length, "LENGTH_MISMATCH");
262 
263         require(msg.sender == from || isApprovedForAll[from][msg.sender], "NOT_AUTHORIZED");
264 
265         for (uint256 i = 0; i < idsLength; ) {
266             uint256 id = ids[i];
267             uint256 amount = amounts[i];
268 
269             balanceOf[from][id] -= amount;
270             balanceOf[to][id] += amount;
271 
272             // An array can't have a total length
273             // larger than the max uint256 value.
274             unchecked {
275                 i++;
276             }
277         }
278 
279         emit TransferBatch(msg.sender, from, to, ids, amounts);
280 
281         require(
282             to.code.length == 0
283                 ? to != address(0)
284                 : ERC1155TokenReceiver(to).onERC1155BatchReceived(msg.sender, from, ids, amounts, data) ==
285                     ERC1155TokenReceiver.onERC1155BatchReceived.selector,
286             "UNSAFE_RECIPIENT"
287         );
288     }
289 
290     function balanceOfBatch(address[] memory owners, uint256[] memory ids)
291         public
292         view
293         virtual
294         returns (uint256[] memory balances)
295     {
296         uint256 ownersLength = owners.length; // Saves MLOADs.
297 
298         require(ownersLength == ids.length, "LENGTH_MISMATCH");
299 
300         balances = new uint256[](owners.length);
301 
302         // Unchecked because the only math done is incrementing
303         // the array index counter which cannot possibly overflow.
304         unchecked {
305             for (uint256 i = 0; i < ownersLength; i++) {
306                 balances[i] = balanceOf[owners[i]][ids[i]];
307             }
308         }
309     }
310 
311     /*///////////////////////////////////////////////////////////////
312                               ERC165 LOGIC
313     //////////////////////////////////////////////////////////////*/
314 
315     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
316         return
317             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
318             interfaceId == 0xd9b67a26 || // ERC165 Interface ID for ERC1155
319             interfaceId == 0x0e89341c; // ERC165 Interface ID for ERC1155MetadataURI
320     }
321 
322     /*///////////////////////////////////////////////////////////////
323                         INTERNAL MINT/BURN LOGIC
324     //////////////////////////////////////////////////////////////*/
325 
326     function _mint(
327         address to,
328         uint256 id,
329         uint256 amount,
330         bytes memory data
331     ) internal {
332         balanceOf[to][id] += amount;
333 
334         emit TransferSingle(msg.sender, address(0), to, id, amount);
335 
336         require(
337             to.code.length == 0
338                 ? to != address(0)
339                 : ERC1155TokenReceiver(to).onERC1155Received(msg.sender, address(0), id, amount, data) ==
340                     ERC1155TokenReceiver.onERC1155Received.selector,
341             "UNSAFE_RECIPIENT"
342         );
343     }
344 
345     function _batchMint(
346         address to,
347         uint256[] memory ids,
348         uint256[] memory amounts,
349         bytes memory data
350     ) internal {
351         uint256 idsLength = ids.length; // Saves MLOADs.
352 
353         require(idsLength == amounts.length, "LENGTH_MISMATCH");
354 
355         for (uint256 i = 0; i < idsLength; ) {
356             balanceOf[to][ids[i]] += amounts[i];
357 
358             // An array can't have a total length
359             // larger than the max uint256 value.
360             unchecked {
361                 i++;
362             }
363         }
364 
365         emit TransferBatch(msg.sender, address(0), to, ids, amounts);
366 
367         require(
368             to.code.length == 0
369                 ? to != address(0)
370                 : ERC1155TokenReceiver(to).onERC1155BatchReceived(msg.sender, address(0), ids, amounts, data) ==
371                     ERC1155TokenReceiver.onERC1155BatchReceived.selector,
372             "UNSAFE_RECIPIENT"
373         );
374     }
375 
376     function _batchBurn(
377         address from,
378         uint256[] memory ids,
379         uint256[] memory amounts
380     ) internal {
381         uint256 idsLength = ids.length; // Saves MLOADs.
382 
383         require(idsLength == amounts.length, "LENGTH_MISMATCH");
384 
385         for (uint256 i = 0; i < idsLength; ) {
386             balanceOf[from][ids[i]] -= amounts[i];
387 
388             // An array can't have a total length
389             // larger than the max uint256 value.
390             unchecked {
391                 i++;
392             }
393         }
394 
395         emit TransferBatch(msg.sender, from, address(0), ids, amounts);
396     }
397 
398     function _burn(
399         address from,
400         uint256 id,
401         uint256 amount
402     ) internal {
403         balanceOf[from][id] -= amount;
404 
405         emit TransferSingle(msg.sender, from, address(0), id, amount);
406     }
407 }
408 
409 /// @notice A generic interface for a contract which properly accepts ERC1155 tokens.
410 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC1155.sol)
411 interface ERC1155TokenReceiver {
412     function onERC1155Received(
413         address operator,
414         address from,
415         uint256 id,
416         uint256 amount,
417         bytes calldata data
418     ) external returns (bytes4);
419 
420     function onERC1155BatchReceived(
421         address operator,
422         address from,
423         uint256[] calldata ids,
424         uint256[] calldata amounts,
425         bytes calldata data
426     ) external returns (bytes4);
427 }
428 
429 ////// src/CanvasRegistry.sol
430 /* pragma solidity 0.8.10; */
431 
432 
433 /* import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
434 /* import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol"; */
435 /* import "../lib/solmate/src/tokens/ERC1155.sol"; */
436 
437 contract CanvasRegistry is ERC1155, Ownable {
438     using Strings for uint;
439     string private _uri;
440 
441     event TransferCanvasOwnership(address indexed from, address indexed to, uint indexed tokenId);
442 
443     mapping (uint => address) public canvasOwners;
444     ERC1155 presaleMintPass;
445     uint public mintPrice = 0.01 ether;
446 
447     bool publicSale;
448     bool mintingPaused;
449 
450     constructor(address presaleMintPassAddress, string memory initialURI) {
451         presaleMintPass = ERC1155(presaleMintPassAddress);
452         _uri = initialURI;
453     }
454 
455     function transferCanvasOwnership(uint tokenId, address newOwner) public {
456         require(canvasOwners[tokenId] == msg.sender);
457         canvasOwners[tokenId] = newOwner; 
458         emit TransferCanvasOwnership(msg.sender, newOwner, tokenId);
459     }
460 
461     function mint(uint label, uint amount) public payable {
462         require(publicSale && !mintingPaused, "Presale active");
463         require(msg.value >= mintPrice * amount, "Requires more Ether");
464         require(canvasOwners[label] == address(0), "This CNVS already exists.");
465 
466         canvasOwners[label] = msg.sender; 
467         _mint(msg.sender, label, amount, "");
468     }
469 
470     function gift(uint label, uint amount, address to) public payable {
471         require(publicSale && !mintingPaused, "Presale active");
472         require(msg.value >= mintPrice * amount, "Requires more Ether");
473         require(canvasOwners[label] == address(0), "This CNVS already exists.");
474 
475         canvasOwners[label] = to; 
476         _mint(to, label, amount, "");
477     }
478 
479     function mintPresale(uint label, uint amount) public {
480         require(
481             !publicSale && 
482             !mintingPaused && 
483             (presaleMintPass.balanceOf(msg.sender, 1) > 0 || presaleMintPass.balanceOf(msg.sender, 2) > 0),
484              "You are not elligible for presale."
485         );
486         require(canvasOwners[label] == address(0), "This CNVS already exists.");
487 
488         canvasOwners[label] = msg.sender; 
489         _mint(msg.sender, label, amount, "");
490     }
491 
492     function setMintPrice(uint newMintPrice) public onlyOwner {
493         mintPrice = newMintPrice;
494     }
495 
496     function setURI(string memory newURI) public onlyOwner {
497         _uri = newURI;
498     }
499 
500     /// @dev Can only be activated once, on purpose
501     function setPublicSale() public onlyOwner {
502         publicSale = true;
503     }
504 
505     function setMintingPaused(bool paused) public onlyOwner {
506         mintingPaused = paused;
507     }
508 
509     function uri(uint id) public view virtual override returns (string memory) {
510         return string(abi.encodePacked(_uri, id.toString()));
511     } 
512 
513     function withdrawal(address receiver) public onlyOwner {
514         payable(receiver).transfer(address(this).balance);
515     }
516 }