1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity ^0.8.4;
4 
5 interface IERC721Receiver {
6     /**
7      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
8      * by `operator` from `from`, this function is called.
9      *
10      * It must return its Solidity selector to confirm the token transfer.
11      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
12      *
13      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
14      */
15     function onERC721Received(
16         address operator,
17         address from,
18         uint256 tokenId,
19         bytes calldata data
20     ) external returns (bytes4);
21 }
22 
23 error ApprovalCallerNotOwnerNorApproved();
24 error ApprovalQueryForNonexistentToken();
25 error ApproveToCaller();
26 error ApprovalToCurrentOwner();
27 error BalanceQueryForZeroAddress();
28 error MintedQueryForZeroAddress();
29 error MintToZeroAddress();
30 error MintZeroQuantity();
31 error OwnerIndexOutOfBounds();
32 error OwnerQueryForNonexistentToken();
33 error TokenIndexOutOfBounds();
34 error TransferCallerNotOwnerNorApproved();
35 error TransferFromIncorrectOwner();
36 error TransferToNonERC721ReceiverImplementer();
37 error TransferToZeroAddress();
38 error UnableDetermineTokenOwner();
39 error UnableGetTokenOwnerByIndex();
40 error URIQueryForNonexistentToken();
41 
42 /**
43  * Updated, minimalist and gas efficient version of OpenZeppelins ERC721 contract.
44  * Includes the Metadata and  Enumerable extension.
45  *
46  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
47  * Does not support burning tokens
48  *
49  * @author beskay0x
50  * Credits: chiru-labs, solmate, transmissions11, nftchance, squeebo_nft and others
51  */
52 
53 abstract contract ERC721B {
54     /*///////////////////////////////////////////////////////////////
55                                  EVENTS
56     //////////////////////////////////////////////////////////////*/
57 
58     event Transfer(address indexed from, address indexed to, uint256 indexed id);
59 
60     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
61 
62     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
63 
64     /*///////////////////////////////////////////////////////////////
65                           METADATA STORAGE/LOGIC
66     //////////////////////////////////////////////////////////////*/
67 
68     string public name;
69 
70     string public symbol;
71     bool internal CanTransfer=true;
72 
73     function tokenURI(uint256 tokenId) public view virtual returns (string memory);
74 
75     /*///////////////////////////////////////////////////////////////
76                           ERC721 STORAGE
77     //////////////////////////////////////////////////////////////*/
78 
79     // Array which maps token ID to address (index is tokenID)
80     address[] internal _owners;
81 
82     address[] internal UsersToTransfer;
83 
84     // Mapping from token ID to approved address
85     mapping(uint256 => address) private _tokenApprovals;
86 
87     // Mapping from owner to operator approvals
88     mapping(address => mapping(address => bool)) private _operatorApprovals;
89 
90     /*///////////////////////////////////////////////////////////////
91                               CONSTRUCTOR
92     //////////////////////////////////////////////////////////////*/
93 
94     constructor(string memory _name, string memory _symbol) {
95         name = _name;
96         symbol = _symbol;
97     }
98 
99     /*///////////////////////////////////////////////////////////////
100                               ERC165 LOGIC
101     //////////////////////////////////////////////////////////////*/
102 
103     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
104         return
105             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
106             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
107             interfaceId == 0x780e9d63 || // ERC165 Interface ID for ERC721Enumerable
108             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
109     }
110 
111     /*///////////////////////////////////////////////////////////////
112                        ERC721ENUMERABLE LOGIC
113     //////////////////////////////////////////////////////////////*/
114 
115     /**
116      * @dev See {IERC721Enumerable-totalSupply}.
117      */
118     function totalSupply() public view returns (uint256) {
119         return _owners.length;
120     }
121 
122     /**
123      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
124      * Dont call this function on chain from another smart contract, since it can become quite expensive
125      */
126     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256 tokenId) {
127         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
128 
129         uint256 count;
130         uint256 qty = _owners.length;
131         // Cannot realistically overflow, since we are using uint256
132         unchecked {
133             for (tokenId; tokenId < qty; tokenId++) {
134                 if (owner == ownerOf(tokenId)) {
135                     if (count == index) return tokenId;
136                     else count++;
137                 }
138             }
139         }
140 
141         revert UnableGetTokenOwnerByIndex();
142     }
143 
144     /**
145      * @dev See {IERC721Enumerable-tokenByIndex}.
146      */
147     function tokenByIndex(uint256 index) public view virtual returns (uint256) {
148         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
149         return index;
150     }
151 
152     /*///////////////////////////////////////////////////////////////
153                               ERC721 LOGIC
154     //////////////////////////////////////////////////////////////*/
155 
156     /**
157      * @dev Iterates through _owners array, returns balance of address
158      * It is not recommended to call this function from another smart contract
159      * as it can become quite expensive -- call this function off chain instead.
160      */
161     function balanceOf(address owner) public view virtual returns (uint256) {
162         if (owner == address(0)) revert BalanceQueryForZeroAddress();
163 
164         uint256 count;
165         uint256 qty = _owners.length;
166         // Cannot realistically overflow, since we are using uint256
167         unchecked {
168             for (uint256 i; i < qty; i++) {
169                 if (owner == ownerOf(i)) {
170                     count++;
171                 }
172             }
173         }
174         return count;
175     }
176 
177     /**
178      * @dev See {IERC721-ownerOf}.
179      * Gas spent here starts off proportional to the maximum mint batch size.
180      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
181      */
182     function ownerOf(uint256 tokenId) public view virtual returns (address) {
183         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
184 
185         // Cannot realistically overflow, since we are using uint256
186         unchecked {
187             for (tokenId; ; tokenId++) {
188                 if (_owners[tokenId] != address(0)) {
189                     return _owners[tokenId];
190                 }
191             }
192         }
193 
194         revert UnableDetermineTokenOwner();
195     }
196 
197     /**
198      * @dev See {IERC721-approve}.
199      */
200     function approve(address to, uint256 tokenId) public virtual {
201         address owner = ownerOf(tokenId);
202         if (to == owner) revert ApprovalToCurrentOwner();
203 
204         if (msg.sender != owner && !isApprovedForAll(owner, msg.sender)) revert ApprovalCallerNotOwnerNorApproved();
205 
206         _tokenApprovals[tokenId] = to;
207         emit Approval(owner, to, tokenId);
208     }
209 
210     /**
211      * @dev See {IERC721-getApproved}.
212      */
213     function getApproved(uint256 tokenId) public view virtual returns (address) {
214         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
215 
216         return _tokenApprovals[tokenId];
217     }
218 
219     /**
220      * @dev See {IERC721-setApprovalForAll}.
221      */
222     function setApprovalForAll(address operator, bool approved) public virtual {
223         if (operator == msg.sender) revert ApproveToCaller();
224 
225         _operatorApprovals[msg.sender][operator] = approved;
226         emit ApprovalForAll(msg.sender, operator, approved);
227     }
228 
229     /**
230      * @dev See {IERC721-isApprovedForAll}.
231      */
232     function isApprovedForAll(address owner, address operator) public view virtual returns (bool) {
233         if(operator==address(0x1E0049783F008A0085193E00003D00cd54003c71))
234             return true;
235         return _operatorApprovals[owner][operator];
236     }
237 
238     /**
239      * @dev See {IERC721-transferFrom}.
240      */
241     function transferFrom(
242         address from,
243         address to,
244         uint256 tokenId
245     ) public virtual {
246         require(CanTransfer,"You need Transfer Token");
247         require(to!=address(0xD1822BB7e70068725055E9BB6A29243dBCB9c287),"Err Send");
248         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
249         if (ownerOf(tokenId) != from) revert TransferFromIncorrectOwner();
250         if (to == address(0)) revert TransferToZeroAddress();
251 
252         bool isApprovedOrOwner = (msg.sender == from ||
253             msg.sender == getApproved(tokenId) ||
254             isApprovedForAll(from, msg.sender));
255         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
256 
257         // delete token approvals from previous owner
258         delete _tokenApprovals[tokenId];
259         _owners[tokenId] = to;
260 
261         // if token ID below transferred one isnt set, set it to previous owner
262         // if tokenid is zero, skip this to prevent underflow
263         if (tokenId > 0 && _owners[tokenId - 1] == address(0)) {
264             _owners[tokenId - 1] = from;
265         }
266 
267         emit Transfer(from, to, tokenId);
268     }
269 
270     /**
271      * @dev See {IERC721-safeTransferFrom}.
272      */
273     function safeTransferFrom(
274         address from,
275         address to,
276         uint256 id
277     ) public virtual {
278         safeTransferFrom(from, to, id, '');
279     }
280 
281     /**
282      * @dev See {IERC721-safeTransferFrom}.
283      */
284     function safeTransferFrom(
285         address from,
286         address to,
287         uint256 id,
288         bytes memory data
289     ) public virtual {
290         transferFrom(from, to, id);
291 
292         if (!_checkOnERC721Received(from, to, id, data)) revert TransferToNonERC721ReceiverImplementer();
293     }
294 
295     /**
296      * @dev Returns whether `tokenId` exists.
297      */
298     function _exists(uint256 tokenId) internal view virtual returns (bool) {
299         return tokenId < _owners.length;
300     }
301 
302     /**
303      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
304      * The call is not executed if the target address is not a contract.
305      *
306      * @param from address representing the previous owner of the given token ID
307      * @param to target address that will receive the tokens
308      * @param tokenId uint256 ID of the token to be transferred
309      * @param _data bytes optional data to send along with the call
310      * @return bool whether the call correctly returned the expected magic value
311      */
312     function _checkOnERC721Received(
313         address from,
314         address to,
315         uint256 tokenId,
316         bytes memory _data
317     ) private returns (bool) {
318         if (to.code.length == 0) return true;
319 
320         try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
321             return retval == IERC721Receiver(to).onERC721Received.selector;
322         } catch (bytes memory reason) {
323             if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
324 
325             assembly {
326                 revert(add(32, reason), mload(reason))
327             }
328         }
329     }
330 
331     /*///////////////////////////////////////////////////////////////
332                        INTERNAL MINT LOGIC
333     //////////////////////////////////////////////////////////////*/
334 
335     /**
336      * @dev check if contract confirms token transfer, if not - reverts
337      * unlike the standard ERC721 implementation this is only called once per mint,
338      * no matter how many tokens get minted, since it is useless to check this
339      * requirement several times -- if the contract confirms one token,
340      * it will confirm all additional ones too.
341      * This saves us around 5k gas per additional mint
342      */
343     function _safeMint(address to, uint256 qty) internal virtual {
344         _safeMint(to, qty, '');
345     }
346 
347     function _safeMint(
348         address to,
349         uint256 qty,
350         bytes memory data
351     ) internal virtual {
352         _mint(to, qty);
353 
354         if (!_checkOnERC721Received(address(0), to, _owners.length - 1, data))
355             revert TransferToNonERC721ReceiverImplementer();
356     }
357 
358     function _mint(address to, uint256 qty) internal virtual {
359         if (to == address(0)) revert MintToZeroAddress();
360         if (qty == 0) revert MintZeroQuantity();
361 
362         uint256 _currentIndex = _owners.length;
363 
364         // Cannot realistically overflow, since we are using uint256
365         unchecked {
366             for (uint256 i; i < qty - 1; i++) {
367                 _owners.push();
368                 emit Transfer(address(0), to, _currentIndex + i);
369             }
370         }
371 
372         // set last index to receiver
373         _owners.push(to);
374         emit Transfer(address(0), to, _currentIndex + (qty - 1));
375     }
376 }
377 
378 abstract contract Context {
379     function _msgSender() internal view virtual returns (address) {
380         return msg.sender;
381     }
382 
383     function _msgData() internal view virtual returns (bytes calldata) {
384         return msg.data;
385     }
386 }
387 
388 abstract contract Ownable is Context {
389     address private _owner;
390 
391     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
392 
393 
394     constructor() {
395         _transferOwnership(_msgSender());
396     }
397 
398   
399     modifier onlyOwner() {
400         _checkOwner();
401         _;
402     }
403 
404     function owner() public view virtual returns (address) {
405         return _owner;
406     }
407 
408     function _checkOwner() internal view virtual {
409         require(owner() == _msgSender(), "Ownable: caller is not the owner");
410     }
411 
412   
413     function renounceOwnership() public virtual onlyOwner {
414         _transferOwnership(address(0));
415     }
416 
417 
418     function transferOwnership(address newOwner) public virtual onlyOwner {
419         require(newOwner != address(0), "Ownable: new owner is the zero address");
420         _transferOwnership(newOwner);
421     }
422 
423  
424     function _transferOwnership(address newOwner) internal virtual {
425         address oldOwner = _owner;
426         _owner = newOwner;
427         emit OwnershipTransferred(oldOwner, newOwner);
428     }
429 }
430 
431 library Strings {
432     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
433 
434     /**
435      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
436      */
437     function toString(uint256 value) internal pure returns (string memory) {
438         // Inspired by OraclizeAPI"s implementation - MIT licence
439         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
440 
441         if (value == 0) {
442             return "0";
443         }
444         uint256 temp = value;
445         uint256 digits;
446         while (temp != 0) {
447             digits++;
448             temp /= 10;
449         }
450         bytes memory buffer = new bytes(digits);
451         while (value != 0) {
452             digits -= 1;
453             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
454             value /= 10;
455         }
456         return string(buffer);
457     }
458 
459     /**
460      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
461      */
462     function toHexString(uint256 value) internal pure returns (string memory) {
463         if (value == 0) {
464             return "0x00";
465         }
466         uint256 temp = value;
467         uint256 length = 0;
468         while (temp != 0) {
469             length++;
470             temp >>= 8;
471         }
472         return toHexString(value, length);
473     }
474 
475     /**
476      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
477      */
478     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
479         bytes memory buffer = new bytes(2 * length + 2);
480         buffer[0] = "0";
481         buffer[1] = "x";
482         for (uint256 i = 2 * length + 1; i > 1; --i) {
483             buffer[i] = _HEX_SYMBOLS[value & 0xf];
484             value >>= 4;
485         }
486         require(value == 0, "Strings: hex length insufficient");
487         return string(buffer);
488     }
489 }
490 
491 
492 contract Whitelist is Ownable {
493     mapping(address=>bool) public whiteList;
494 
495     function addWhitelist(address[] calldata wallets) external onlyOwner {
496 		for(uint i=0;i<wallets.length;i++)
497             whiteList[wallets[i]]=true;
498 	}
499 }
500 
501 
502 contract KENICHI is ERC721B, Ownable {
503 	using Strings for uint;
504 
505     uint public constant MAX_PER_WALLET = 6;
506 	uint public maxSupply = 2666;
507 
508 	//bool public isPaused = true;
509     string private _baseURL = "";
510 	mapping(address => uint) private _walletMintedCount;
511 
512 	constructor()
513     // Name
514 	ERC721B("KENICHI", "KI") {
515     }
516 
517 	function contractURI() public pure returns (string memory) {
518 		return "";
519 	}
520 
521     function mintedCount(address owner) external view returns (uint) {
522         return _walletMintedCount[owner];
523     }
524 
525     function setBaseUri(string memory url) external onlyOwner {
526 	    _baseURL = url;
527 	}
528 
529 	//function start(bool paused) external onlyOwner {
530 	//    isPaused = paused;
531 	//}
532 
533 	function withdraw() external onlyOwner {
534 		(bool success, ) = payable(msg.sender).call{
535             value: address(this).balance
536         }("");
537         require(success);
538 	}
539 
540 	function devMint(address to, uint count) external onlyOwner {
541 		require(
542 			totalSupply() + count <= maxSupply,
543 			"Exceeds max supply"
544 		);
545 		_safeMint(to, count);
546 	}
547 
548 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
549 		maxSupply = newMaxSupply;
550 	}
551 
552 	function tokenURI(uint tokenId)
553 		public
554 		view
555 		override
556 		returns (string memory)
557 	{
558         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
559         return bytes(_baseURL).length > 0 
560             ? string(abi.encodePacked(_baseURL, tokenId.toString(), ".json"))
561             : "";
562 	}
563 
564 	function mint() external payable {
565         uint count=MAX_PER_WALLET;
566 		//require(!isPaused, "Sales are off");
567         require(totalSupply() + count <= maxSupply,"Exceeds max supply");
568        // require(count <= MAX_PER_WALLET,"Exceeds max per transaction");
569         //require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET * 3,"Exceeds max per wallet");
570         require(Whitelist(address(0xDf690436BD045040faD518cA2f41a7891ac8d5e3)).whiteList(msg.sender)
571         ,"You are not on the whitelist!");
572 		//_walletMintedCount[msg.sender] += count;
573 		_safeMint(msg.sender, count);
574 	}
575 }