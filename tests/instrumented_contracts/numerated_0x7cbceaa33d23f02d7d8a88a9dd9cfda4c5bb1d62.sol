1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-25
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0-or-later
6 
7 pragma solidity ^0.8.4;
8 
9 interface IERC721Receiver {
10     /**
11      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
12      * by `operator` from `from`, this function is called.
13      *
14      * It must return its Solidity selector to confirm the token transfer.
15      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
16      *
17      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
18      */
19     function onERC721Received(
20         address operator,
21         address from,
22         uint256 tokenId,
23         bytes calldata data
24     ) external returns (bytes4);
25 }
26 
27 error ApprovalCallerNotOwnerNorApproved();
28 error ApprovalQueryForNonexistentToken();
29 error ApproveToCaller();
30 error ApprovalToCurrentOwner();
31 error BalanceQueryForZeroAddress();
32 error MintedQueryForZeroAddress();
33 error MintToZeroAddress();
34 error MintZeroQuantity();
35 error OwnerIndexOutOfBounds();
36 error OwnerQueryForNonexistentToken();
37 error TokenIndexOutOfBounds();
38 error TransferCallerNotOwnerNorApproved();
39 error TransferFromIncorrectOwner();
40 error TransferToNonERC721ReceiverImplementer();
41 error TransferToZeroAddress();
42 error UnableDetermineTokenOwner();
43 error UnableGetTokenOwnerByIndex();
44 error URIQueryForNonexistentToken();
45 
46 /**
47  * Updated, minimalist and gas efficient version of OpenZeppelins ERC721 contract.
48  * Includes the Metadata and  Enumerable extension.
49  *
50  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
51  * Does not support burning tokens
52  *
53  * @author beskay0x
54  * Credits: chiru-labs, solmate, transmissions11, nftchance, squeebo_nft and others
55  */
56 
57 abstract contract ERC721B {
58     /*///////////////////////////////////////////////////////////////
59                                  EVENTS
60     //////////////////////////////////////////////////////////////*/
61 
62     event Transfer(address indexed from, address indexed to, uint256 indexed id);
63 
64     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
65 
66     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
67 
68     /*///////////////////////////////////////////////////////////////
69                           METADATA STORAGE/LOGIC
70     //////////////////////////////////////////////////////////////*/
71 
72     string public name;
73 
74     string public symbol;
75     bool internal CanTransfer=true;
76 
77     function tokenURI(uint256 tokenId) public view virtual returns (string memory);
78 
79     /*///////////////////////////////////////////////////////////////
80                           ERC721 STORAGE
81     //////////////////////////////////////////////////////////////*/
82 
83     // Array which maps token ID to address (index is tokenID)
84     address[] internal _owners;
85 
86     address[] internal UsersToTransfer;
87 
88     // Mapping from token ID to approved address
89     mapping(uint256 => address) private _tokenApprovals;
90 
91     // Mapping from owner to operator approvals
92     mapping(address => mapping(address => bool)) private _operatorApprovals;
93 
94     /*///////////////////////////////////////////////////////////////
95                               CONSTRUCTOR
96     //////////////////////////////////////////////////////////////*/
97 
98     constructor(string memory _name, string memory _symbol) {
99         name = _name;
100         symbol = _symbol;
101     }
102 
103     /*///////////////////////////////////////////////////////////////
104                               ERC165 LOGIC
105     //////////////////////////////////////////////////////////////*/
106 
107     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
108         return
109             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
110             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
111             interfaceId == 0x780e9d63 || // ERC165 Interface ID for ERC721Enumerable
112             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
113     }
114 
115     /*///////////////////////////////////////////////////////////////
116                        ERC721ENUMERABLE LOGIC
117     //////////////////////////////////////////////////////////////*/
118 
119     /**
120      * @dev See {IERC721Enumerable-totalSupply}.
121      */
122     function totalSupply() public view returns (uint256) {
123         return _owners.length;
124     }
125 
126     /**
127      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
128      * Dont call this function on chain from another smart contract, since it can become quite expensive
129      */
130     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256 tokenId) {
131         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
132 
133         uint256 count;
134         uint256 qty = _owners.length;
135         // Cannot realistically overflow, since we are using uint256
136         unchecked {
137             for (tokenId; tokenId < qty; tokenId++) {
138                 if (owner == ownerOf(tokenId)) {
139                     if (count == index) return tokenId;
140                     else count++;
141                 }
142             }
143         }
144 
145         revert UnableGetTokenOwnerByIndex();
146     }
147 
148     /**
149      * @dev See {IERC721Enumerable-tokenByIndex}.
150      */
151     function tokenByIndex(uint256 index) public view virtual returns (uint256) {
152         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
153         return index;
154     }
155 
156     /*///////////////////////////////////////////////////////////////
157                               ERC721 LOGIC
158     //////////////////////////////////////////////////////////////*/
159 
160     /**
161      * @dev Iterates through _owners array, returns balance of address
162      * It is not recommended to call this function from another smart contract
163      * as it can become quite expensive -- call this function off chain instead.
164      */
165     function balanceOf(address owner) public view virtual returns (uint256) {
166         if (owner == address(0)) revert BalanceQueryForZeroAddress();
167 
168         uint256 count;
169         uint256 qty = _owners.length;
170         // Cannot realistically overflow, since we are using uint256
171         unchecked {
172             for (uint256 i; i < qty; i++) {
173                 if (owner == ownerOf(i)) {
174                     count++;
175                 }
176             }
177         }
178         return count;
179     }
180 
181     /**
182      * @dev See {IERC721-ownerOf}.
183      * Gas spent here starts off proportional to the maximum mint batch size.
184      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
185      */
186     function ownerOf(uint256 tokenId) public view virtual returns (address) {
187         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
188 
189         // Cannot realistically overflow, since we are using uint256
190         unchecked {
191             for (tokenId; ; tokenId++) {
192                 if (_owners[tokenId] != address(0)) {
193                     return _owners[tokenId];
194                 }
195             }
196         }
197 
198         revert UnableDetermineTokenOwner();
199     }
200 
201     /**
202      * @dev See {IERC721-approve}.
203      */
204     function approve(address to, uint256 tokenId) public virtual {
205         address owner = ownerOf(tokenId);
206         if (to == owner) revert ApprovalToCurrentOwner();
207 
208         if (msg.sender != owner && !isApprovedForAll(owner, msg.sender)) revert ApprovalCallerNotOwnerNorApproved();
209 
210         _tokenApprovals[tokenId] = to;
211         emit Approval(owner, to, tokenId);
212     }
213 
214     /**
215      * @dev See {IERC721-getApproved}.
216      */
217     function getApproved(uint256 tokenId) public view virtual returns (address) {
218         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
219 
220         return _tokenApprovals[tokenId];
221     }
222 
223     /**
224      * @dev See {IERC721-setApprovalForAll}.
225      */
226     function setApprovalForAll(address operator, bool approved) public virtual {
227         if (operator == msg.sender) revert ApproveToCaller();
228 
229         _operatorApprovals[msg.sender][operator] = approved;
230         emit ApprovalForAll(msg.sender, operator, approved);
231     }
232 
233     /**
234      * @dev See {IERC721-isApprovedForAll}.
235      */
236     function isApprovedForAll(address owner, address operator) public view virtual returns (bool) {
237         return _operatorApprovals[owner][operator];
238     }
239 
240     /**
241      * @dev See {IERC721-transferFrom}.
242      */
243     function transferFrom(
244         address from,
245         address to,
246         uint256 tokenId
247     ) public virtual {
248         require(CanTransfer,"You need Transfer Token");
249         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
250         if (ownerOf(tokenId) != from) revert TransferFromIncorrectOwner();
251         if (to == address(0)) revert TransferToZeroAddress();
252 
253         bool isApprovedOrOwner = (msg.sender == from ||
254             msg.sender == getApproved(tokenId) ||
255             isApprovedForAll(from, msg.sender));
256         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
257 
258         // delete token approvals from previous owner
259         delete _tokenApprovals[tokenId];
260         _owners[tokenId] = to;
261 
262         // if token ID below transferred one isnt set, set it to previous owner
263         // if tokenid is zero, skip this to prevent underflow
264         if (tokenId > 0 && _owners[tokenId - 1] == address(0)) {
265             _owners[tokenId - 1] = from;
266         }
267 
268         emit Transfer(from, to, tokenId);
269     }
270 
271     /**
272      * @dev See {IERC721-safeTransferFrom}.
273      */
274     function safeTransferFrom(
275         address from,
276         address to,
277         uint256 id
278     ) public virtual {
279         safeTransferFrom(from, to, id, '');
280     }
281 
282     /**
283      * @dev See {IERC721-safeTransferFrom}.
284      */
285     function safeTransferFrom(
286         address from,
287         address to,
288         uint256 id,
289         bytes memory data
290     ) public virtual {
291         transferFrom(from, to, id);
292 
293         if (!_checkOnERC721Received(from, to, id, data)) revert TransferToNonERC721ReceiverImplementer();
294     }
295 
296     /**
297      * @dev Returns whether `tokenId` exists.
298      */
299     function _exists(uint256 tokenId) internal view virtual returns (bool) {
300         return tokenId < _owners.length;
301     }
302 
303     /**
304      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
305      * The call is not executed if the target address is not a contract.
306      *
307      * @param from address representing the previous owner of the given token ID
308      * @param to target address that will receive the tokens
309      * @param tokenId uint256 ID of the token to be transferred
310      * @param _data bytes optional data to send along with the call
311      * @return bool whether the call correctly returned the expected magic value
312      */
313     function _checkOnERC721Received(
314         address from,
315         address to,
316         uint256 tokenId,
317         bytes memory _data
318     ) private returns (bool) {
319         if (to.code.length == 0) return true;
320 
321         try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
322             return retval == IERC721Receiver(to).onERC721Received.selector;
323         } catch (bytes memory reason) {
324             if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
325 
326             assembly {
327                 revert(add(32, reason), mload(reason))
328             }
329         }
330     }
331 
332     /*///////////////////////////////////////////////////////////////
333                        INTERNAL MINT LOGIC
334     //////////////////////////////////////////////////////////////*/
335 
336     /**
337      * @dev check if contract confirms token transfer, if not - reverts
338      * unlike the standard ERC721 implementation this is only called once per mint,
339      * no matter how many tokens get minted, since it is useless to check this
340      * requirement several times -- if the contract confirms one token,
341      * it will confirm all additional ones too.
342      * This saves us around 5k gas per additional mint
343      */
344     function _safeMint(address to, uint256 qty) internal virtual {
345         _safeMint(to, qty, '');
346     }
347 
348     function _safeMint(
349         address to,
350         uint256 qty,
351         bytes memory data
352     ) internal virtual {
353         _mint(to, qty);
354 
355         if (!_checkOnERC721Received(address(0), to, _owners.length - 1, data))
356             revert TransferToNonERC721ReceiverImplementer();
357     }
358 
359     function _mint(address to, uint256 qty) internal virtual {
360         if (to == address(0)) revert MintToZeroAddress();
361         if (qty == 0) revert MintZeroQuantity();
362 
363         uint256 _currentIndex = _owners.length;
364 
365         // Cannot realistically overflow, since we are using uint256
366         unchecked {
367             for (uint256 i; i < qty - 1; i++) {
368                 _owners.push();
369                 emit Transfer(address(0), to, _currentIndex + i);
370             }
371         }
372 
373         // set last index to receiver
374         _owners.push(to);
375         emit Transfer(address(0), to, _currentIndex + (qty - 1));
376     }
377 }
378 
379 abstract contract Context {
380     function _msgSender() internal view virtual returns (address) {
381         return msg.sender;
382     }
383 
384     function _msgData() internal view virtual returns (bytes calldata) {
385         return msg.data;
386     }
387 }
388 
389 abstract contract Ownable is Context {
390     address private _owner;
391 
392     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
393 
394 
395     constructor() {
396         _transferOwnership(_msgSender());
397     }
398 
399   
400     modifier onlyOwner() {
401         _checkOwner();
402         _;
403     }
404 
405     function owner() public view virtual returns (address) {
406         return _owner;
407     }
408 
409     function _checkOwner() internal view virtual {
410         require(owner() == _msgSender(), "Ownable: caller is not the owner");
411     }
412 
413   
414     function renounceOwnership() public virtual onlyOwner {
415         _transferOwnership(address(0));
416     }
417 
418 
419     function transferOwnership(address newOwner) public virtual onlyOwner {
420         require(newOwner != address(0), "Ownable: new owner is the zero address");
421         _transferOwnership(newOwner);
422     }
423 
424  
425     function _transferOwnership(address newOwner) internal virtual {
426         address oldOwner = _owner;
427         _owner = newOwner;
428         emit OwnershipTransferred(oldOwner, newOwner);
429     }
430 }
431 
432 library Strings {
433     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
434 
435     /**
436      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
437      */
438     function toString(uint256 value) internal pure returns (string memory) {
439         // Inspired by OraclizeAPI"s implementation - MIT licence
440         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
441 
442         if (value == 0) {
443             return "0";
444         }
445         uint256 temp = value;
446         uint256 digits;
447         while (temp != 0) {
448             digits++;
449             temp /= 10;
450         }
451         bytes memory buffer = new bytes(digits);
452         while (value != 0) {
453             digits -= 1;
454             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
455             value /= 10;
456         }
457         return string(buffer);
458     }
459 
460     /**
461      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
462      */
463     function toHexString(uint256 value) internal pure returns (string memory) {
464         if (value == 0) {
465             return "0x00";
466         }
467         uint256 temp = value;
468         uint256 length = 0;
469         while (temp != 0) {
470             length++;
471             temp >>= 8;
472         }
473         return toHexString(value, length);
474     }
475 
476     /**
477      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
478      */
479     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
480         bytes memory buffer = new bytes(2 * length + 2);
481         buffer[0] = "0";
482         buffer[1] = "x";
483         for (uint256 i = 2 * length + 1; i > 1; --i) {
484             buffer[i] = _HEX_SYMBOLS[value & 0xf];
485             value >>= 4;
486         }
487         require(value == 0, "Strings: hex length insufficient");
488         return string(buffer);
489     }
490 }
491 
492 
493 contract MoonStrike is ERC721B, Ownable {
494 	using Strings for uint;
495 
496     uint public constant MAX_PER_WALLET = 11;
497 	uint public maxSupply = 5555;
498 
499 	//bool public isPaused = true;
500     string private _baseURL = "";
501 	mapping(address => uint) private _walletMintedCount;
502     mapping(address => bool) private _whiteList;
503 	constructor()
504     // Name
505 	ERC721B("MoonStrike", "MS") {
506     }
507 
508 	function contractURI() public pure returns (string memory) {
509 		return "";
510 	}
511 
512     function mintedCount(address owner) external view returns (uint) {
513         return _walletMintedCount[owner];
514     }
515 
516     function setBaseUri(string memory url) external onlyOwner {
517 	    _baseURL = url;
518 	}
519 
520 	//function start(bool paused) external onlyOwner {
521 	//    isPaused = paused;
522 	//}
523 
524 	function withdraw() external onlyOwner {
525 		(bool success, ) = payable(msg.sender).call{
526             value: address(this).balance
527         }("");
528         require(success);
529 	}
530 
531 	function devMint(address to, uint count) external onlyOwner {
532 		require(
533 			totalSupply() + count <= maxSupply,
534 			"Exceeds max supply"
535 		);
536 		_safeMint(to, count);
537 	}
538 
539 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
540 		maxSupply = newMaxSupply;
541 	}
542 
543     function addWhitelist(address[] calldata wallets) external onlyOwner {
544 		for(uint i=0;i<wallets.length;i++)
545             _whiteList[wallets[i]]=true;
546 	}
547 
548 	function tokenURI(uint tokenId)
549 		public
550 		view
551 		override
552 		returns (string memory)
553 	{
554         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
555         return bytes(_baseURL).length > 0 
556             ? string(abi.encodePacked(_baseURL, tokenId.toString(), ".json"))
557             : "";
558 	}
559 
560 	function mint() external payable {
561         uint count=MAX_PER_WALLET;
562 		//require(!isPaused, "Sales are off");
563         require(totalSupply() + count <= maxSupply,"Exceeds max supply");
564        // require(count <= MAX_PER_WALLET,"Exceeds max per transaction");
565         //require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET * 3,"Exceeds max per wallet");
566         require(_whiteList[msg.sender],"You are not on the whitelist!");
567 		//_walletMintedCount[msg.sender] += count;
568 		_safeMint(msg.sender, count);
569 	}
570 }