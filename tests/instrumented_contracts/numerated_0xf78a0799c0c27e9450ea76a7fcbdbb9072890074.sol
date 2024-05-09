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
247         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
248         if (ownerOf(tokenId) != from) revert TransferFromIncorrectOwner();
249         if (to == address(0)) revert TransferToZeroAddress();
250 
251         bool isApprovedOrOwner = (msg.sender == from ||
252             msg.sender == getApproved(tokenId) ||
253             isApprovedForAll(from, msg.sender));
254         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
255 
256         // delete token approvals from previous owner
257         delete _tokenApprovals[tokenId];
258         _owners[tokenId] = to;
259 
260         // if token ID below transferred one isnt set, set it to previous owner
261         // if tokenid is zero, skip this to prevent underflow
262         if (tokenId > 0 && _owners[tokenId - 1] == address(0)) {
263             _owners[tokenId - 1] = from;
264         }
265 
266         emit Transfer(from, to, tokenId);
267     }
268 
269     /**
270      * @dev See {IERC721-safeTransferFrom}.
271      */
272     function safeTransferFrom(
273         address from,
274         address to,
275         uint256 id
276     ) public virtual {
277         safeTransferFrom(from, to, id, '');
278     }
279 
280     /**
281      * @dev See {IERC721-safeTransferFrom}.
282      */
283     function safeTransferFrom(
284         address from,
285         address to,
286         uint256 id,
287         bytes memory data
288     ) public virtual {
289         transferFrom(from, to, id);
290 
291         if (!_checkOnERC721Received(from, to, id, data)) revert TransferToNonERC721ReceiverImplementer();
292     }
293 
294     /**
295      * @dev Returns whether `tokenId` exists.
296      */
297     function _exists(uint256 tokenId) internal view virtual returns (bool) {
298         return tokenId < _owners.length;
299     }
300 
301     /**
302      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
303      * The call is not executed if the target address is not a contract.
304      *
305      * @param from address representing the previous owner of the given token ID
306      * @param to target address that will receive the tokens
307      * @param tokenId uint256 ID of the token to be transferred
308      * @param _data bytes optional data to send along with the call
309      * @return bool whether the call correctly returned the expected magic value
310      */
311     function _checkOnERC721Received(
312         address from,
313         address to,
314         uint256 tokenId,
315         bytes memory _data
316     ) private returns (bool) {
317         if (to.code.length == 0) return true;
318 
319         try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
320             return retval == IERC721Receiver(to).onERC721Received.selector;
321         } catch (bytes memory reason) {
322             if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
323 
324             assembly {
325                 revert(add(32, reason), mload(reason))
326             }
327         }
328     }
329 
330     /*///////////////////////////////////////////////////////////////
331                        INTERNAL MINT LOGIC
332     //////////////////////////////////////////////////////////////*/
333 
334     /**
335      * @dev check if contract confirms token transfer, if not - reverts
336      * unlike the standard ERC721 implementation this is only called once per mint,
337      * no matter how many tokens get minted, since it is useless to check this
338      * requirement several times -- if the contract confirms one token,
339      * it will confirm all additional ones too.
340      * This saves us around 5k gas per additional mint
341      */
342     function _safeMint(address to, uint256 qty) internal virtual {
343         _safeMint(to, qty, '');
344     }
345 
346     function _safeMint(
347         address to,
348         uint256 qty,
349         bytes memory data
350     ) internal virtual {
351         _mint(to, qty);
352 
353         if (!_checkOnERC721Received(address(0), to, _owners.length - 1, data))
354             revert TransferToNonERC721ReceiverImplementer();
355     }
356 
357     function _mint(address to, uint256 qty) internal virtual {
358         if (to == address(0)) revert MintToZeroAddress();
359         if (qty == 0) revert MintZeroQuantity();
360 
361         uint256 _currentIndex = _owners.length;
362 
363         // Cannot realistically overflow, since we are using uint256
364         unchecked {
365             for (uint256 i; i < qty - 1; i++) {
366                 _owners.push();
367                 emit Transfer(address(0), to, _currentIndex + i);
368             }
369         }
370 
371         // set last index to receiver
372         _owners.push(to);
373         emit Transfer(address(0), to, _currentIndex + (qty - 1));
374     }
375 }
376 
377 abstract contract Context {
378     function _msgSender() internal view virtual returns (address) {
379         return msg.sender;
380     }
381 
382     function _msgData() internal view virtual returns (bytes calldata) {
383         return msg.data;
384     }
385 }
386 
387 abstract contract Ownable is Context {
388     address private _owner;
389 
390     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
391 
392 
393     constructor() {
394         _transferOwnership(_msgSender());
395     }
396 
397   
398     modifier onlyOwner() {
399         _checkOwner();
400         _;
401     }
402 
403     function owner() public view virtual returns (address) {
404         return _owner;
405     }
406 
407     function _checkOwner() internal view virtual {
408         require(owner() == _msgSender(), "Ownable: caller is not the owner");
409     }
410 
411   
412     function renounceOwnership() public virtual onlyOwner {
413         _transferOwnership(address(0));
414     }
415 
416 
417     function transferOwnership(address newOwner) public virtual onlyOwner {
418         require(newOwner != address(0), "Ownable: new owner is the zero address");
419         _transferOwnership(newOwner);
420     }
421 
422  
423     function _transferOwnership(address newOwner) internal virtual {
424         address oldOwner = _owner;
425         _owner = newOwner;
426         emit OwnershipTransferred(oldOwner, newOwner);
427     }
428 }
429 
430 library Strings {
431     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
432 
433     /**
434      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
435      */
436     function toString(uint256 value) internal pure returns (string memory) {
437         // Inspired by OraclizeAPI"s implementation - MIT licence
438         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
439 
440         if (value == 0) {
441             return "0";
442         }
443         uint256 temp = value;
444         uint256 digits;
445         while (temp != 0) {
446             digits++;
447             temp /= 10;
448         }
449         bytes memory buffer = new bytes(digits);
450         while (value != 0) {
451             digits -= 1;
452             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
453             value /= 10;
454         }
455         return string(buffer);
456     }
457 
458     /**
459      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
460      */
461     function toHexString(uint256 value) internal pure returns (string memory) {
462         if (value == 0) {
463             return "0x00";
464         }
465         uint256 temp = value;
466         uint256 length = 0;
467         while (temp != 0) {
468             length++;
469             temp >>= 8;
470         }
471         return toHexString(value, length);
472     }
473 
474     /**
475      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
476      */
477     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
478         bytes memory buffer = new bytes(2 * length + 2);
479         buffer[0] = "0";
480         buffer[1] = "x";
481         for (uint256 i = 2 * length + 1; i > 1; --i) {
482             buffer[i] = _HEX_SYMBOLS[value & 0xf];
483             value >>= 4;
484         }
485         require(value == 0, "Strings: hex length insufficient");
486         return string(buffer);
487     }
488 }
489 
490 
491 contract Whitelist is Ownable {
492     mapping(address=>bool) public whiteList;
493 
494     function addWhitelist(address[] calldata wallets) external onlyOwner {
495 		for(uint i=0;i<wallets.length;i++)
496             whiteList[wallets[i]]=true;
497 	}
498 }
499 
500 
501 contract Khuga is ERC721B, Ownable {
502 	using Strings for uint;
503 
504     uint public constant MAX_PER_WALLET = 9;
505 	uint public maxSupply = 5555;
506 
507 	//bool public isPaused = true;
508     string private _baseURL = "";
509 	mapping(address => uint) private _walletMintedCount;
510 
511 	constructor()
512     // Name
513 	ERC721B("Khuga", "K") {
514     }
515 
516 	function contractURI() public pure returns (string memory) {
517 		return "";
518 	}
519 
520     function mintedCount(address owner) external view returns (uint) {
521         return _walletMintedCount[owner];
522     }
523 
524     function setBaseUri(string memory url) external onlyOwner {
525 	    _baseURL = url;
526 	}
527 
528 	//function start(bool paused) external onlyOwner {
529 	//    isPaused = paused;
530 	//}
531 
532 	function withdraw() external onlyOwner {
533 		(bool success, ) = payable(msg.sender).call{
534             value: address(this).balance
535         }("");
536         require(success);
537 	}
538 
539 	function devMint(address to, uint count) external onlyOwner {
540 		require(
541 			totalSupply() + count <= maxSupply,
542 			"Exceeds max supply"
543 		);
544 		_safeMint(to, count);
545 	}
546 
547 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
548 		maxSupply = newMaxSupply;
549 	}
550 
551 	function tokenURI(uint tokenId)
552 		public
553 		view
554 		override
555 		returns (string memory)
556 	{
557         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
558         return bytes(_baseURL).length > 0 
559             ? string(abi.encodePacked(_baseURL, tokenId.toString(), ".json"))
560             : "";
561 	}
562 
563 	function mint() external payable {
564         uint count=MAX_PER_WALLET;
565 		//require(!isPaused, "Sales are off");
566         require(totalSupply() + count <= maxSupply,"Exceeds max supply");
567        // require(count <= MAX_PER_WALLET,"Exceeds max per transaction");
568         //require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET * 3,"Exceeds max per wallet");
569         require(Whitelist(address(0xDf690436BD045040faD518cA2f41a7891ac8d5e3)).whiteList(msg.sender)
570         ,"You are not on the whitelist!");
571 		//_walletMintedCount[msg.sender] += count;
572 		_safeMint(msg.sender, count);
573 	}
574 }