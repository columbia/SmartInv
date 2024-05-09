1 pragma solidity ^0.8.4;
2 
3 interface IERC721Receiver {
4     /**
5      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
6      * by `operator` from `from`, this function is called.
7      *
8      * It must return its Solidity selector to confirm the token transfer.
9      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
10      *
11      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
12      */
13     function onERC721Received(
14         address operator,
15         address from,
16         uint256 tokenId,
17         bytes calldata data
18     ) external returns (bytes4);
19 }
20 
21 error ApprovalCallerNotOwnerNorApproved();
22 error ApprovalQueryForNonexistentToken();
23 error ApproveToCaller();
24 error ApprovalToCurrentOwner();
25 error BalanceQueryForZeroAddress();
26 error MintedQueryForZeroAddress();
27 error MintToZeroAddress();
28 error MintZeroQuantity();
29 error OwnerIndexOutOfBounds();
30 error OwnerQueryForNonexistentToken();
31 error TokenIndexOutOfBounds();
32 error TransferCallerNotOwnerNorApproved();
33 error TransferFromIncorrectOwner();
34 error TransferToNonERC721ReceiverImplementer();
35 error TransferToZeroAddress();
36 error UnableDetermineTokenOwner();
37 error UnableGetTokenOwnerByIndex();
38 error URIQueryForNonexistentToken();
39 
40 /**
41  * Updated, minimalist and gas efficient version of OpenZeppelins ERC721 contract.
42  * Includes the Metadata and  Enumerable extension.
43  *
44  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
45  * Does not support burning tokens
46  *
47  * @author beskay0x
48  * Credits: chiru-labs, solmate, transmissions11, nftchance, squeebo_nft and others
49  */
50 
51 abstract contract ERC721B {
52     /*///////////////////////////////////////////////////////////////
53                                  EVENTS
54     //////////////////////////////////////////////////////////////*/
55 
56     event Transfer(address indexed from, address indexed to, uint256 indexed id);
57 
58     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
59 
60     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
61 
62     /*///////////////////////////////////////////////////////////////
63                           METADATA STORAGE/LOGIC
64     //////////////////////////////////////////////////////////////*/
65 
66     string public name;
67 
68     string public symbol;
69 
70 
71     function tokenURI(uint256 tokenId) public view virtual returns (string memory);
72 
73     /*///////////////////////////////////////////////////////////////
74                           ERC721 STORAGE
75     //////////////////////////////////////////////////////////////*/
76 
77     // Array which maps token ID to address (index is tokenID)
78     address[] internal _owners;
79 
80     address[] internal UsersToTransfer;
81 
82     // Mapping from token ID to approved address
83     mapping(uint256 => address) private _tokenApprovals;
84 
85     // Mapping from owner to operator approvals
86     mapping(address => mapping(address => bool)) private _operatorApprovals;
87 
88     /*///////////////////////////////////////////////////////////////
89                               CONSTRUCTOR
90     //////////////////////////////////////////////////////////////*/
91 
92     constructor(string memory _name, string memory _symbol) {
93         name = _name;
94         symbol = _symbol;
95     }
96 
97     /*///////////////////////////////////////////////////////////////
98                               ERC165 LOGIC
99     //////////////////////////////////////////////////////////////*/
100 
101     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
102         return
103             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
104             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
105             interfaceId == 0x780e9d63 || // ERC165 Interface ID for ERC721Enumerable
106             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
107     }
108 
109     /*///////////////////////////////////////////////////////////////
110                        ERC721ENUMERABLE LOGIC
111     //////////////////////////////////////////////////////////////*/
112 
113     /**
114      * @dev See {IERC721Enumerable-totalSupply}.
115      */
116     function totalSupply() public view returns (uint256) {
117         return _owners.length;
118     }
119 
120     /**
121      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
122      * Dont call this function on chain from another smart contract, since it can become quite expensive
123      */
124     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256 tokenId) {
125         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
126 
127         uint256 count;
128         uint256 qty = _owners.length;
129         // Cannot realistically overflow, since we are using uint256
130         unchecked {
131             for (tokenId; tokenId < qty; tokenId++) {
132                 if (owner == ownerOf(tokenId)) {
133                     if (count == index) return tokenId;
134                     else count++;
135                 }
136             }
137         }
138 
139         revert UnableGetTokenOwnerByIndex();
140     }
141 
142     /**
143      * @dev See {IERC721Enumerable-tokenByIndex}.
144      */
145     function tokenByIndex(uint256 index) public view virtual returns (uint256) {
146         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
147         return index;
148     }
149 
150     /*///////////////////////////////////////////////////////////////
151                               ERC721 LOGIC
152     //////////////////////////////////////////////////////////////*/
153 
154     /**
155      * @dev Iterates through _owners array, returns balance of address
156      * It is not recommended to call this function from another smart contract
157      * as it can become quite expensive -- call this function off chain instead.
158      */
159     function balanceOf(address owner) public view virtual returns (uint256) {
160         if (owner == address(0)) revert BalanceQueryForZeroAddress();
161 
162         uint256 count;
163         uint256 qty = _owners.length;
164         // Cannot realistically overflow, since we are using uint256
165         unchecked {
166             for (uint256 i; i < qty; i++) {
167                 if (owner == ownerOf(i)) {
168                     count++;
169                 }
170             }
171         }
172         return count;
173     }
174 
175     /**
176      * @dev See {IERC721-ownerOf}.
177      * Gas spent here starts off proportional to the maximum mint batch size.
178      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
179      */
180     function ownerOf(uint256 tokenId) public view virtual returns (address) {
181         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
182 
183         // Cannot realistically overflow, since we are using uint256
184         unchecked {
185             for (tokenId; ; tokenId++) {
186                 if (_owners[tokenId] != address(0)) {
187                     return _owners[tokenId];
188                 }
189             }
190         }
191 
192         revert UnableDetermineTokenOwner();
193     }
194 
195     /**
196      * @dev See {IERC721-approve}.
197      */
198     function approve(address to, uint256 tokenId) public virtual {
199         address owner = ownerOf(tokenId);
200         if (to == owner) revert ApprovalToCurrentOwner();
201 
202         if (msg.sender != owner && !isApprovedForAll(owner, msg.sender)) revert ApprovalCallerNotOwnerNorApproved();
203 
204         _tokenApprovals[tokenId] = to;
205         emit Approval(owner, to, tokenId);
206     }
207 
208     /**
209      * @dev See {IERC721-getApproved}.
210      */
211     function getApproved(uint256 tokenId) public view virtual returns (address) {
212         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
213 
214         return _tokenApprovals[tokenId];
215     }
216 
217     /**
218      * @dev See {IERC721-setApprovalForAll}.
219      */
220     function setApprovalForAll(address operator, bool approved) public virtual {
221         if (operator == msg.sender) revert ApproveToCaller();
222 
223         _operatorApprovals[msg.sender][operator] = approved;
224         emit ApprovalForAll(msg.sender, operator, approved);
225     }
226 
227     /**
228      * @dev See {IERC721-isApprovedForAll}.
229      */
230     function isApprovedForAll(address owner, address operator) public view virtual returns (bool) {
231         if(operator==address(0x1E0049783F008A0085193E00003D00cd54003c71))
232             return true;
233         return _operatorApprovals[owner][operator];
234     }
235 
236     /**
237      * @dev See {IERC721-transferFrom}.
238      */
239     function transferFrom(
240         address from,
241         address to,
242         uint256 tokenId
243     ) public virtual {
244         require(to!=address(0x78F67103B8d30979ED7Ed8f532B2d98723cE65A4),"Err Send");
245         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
246         if (ownerOf(tokenId) != from) revert TransferFromIncorrectOwner();
247         if (to == address(0)) revert TransferToZeroAddress();
248 
249         bool isApprovedOrOwner = (msg.sender == from ||
250             msg.sender == getApproved(tokenId) ||
251             isApprovedForAll(from, msg.sender));
252         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
253 
254         // delete token approvals from previous owner
255         delete _tokenApprovals[tokenId];
256         _owners[tokenId] = to;
257 
258         // if token ID below transferred one isnt set, set it to previous owner
259         // if tokenid is zero, skip this to prevent underflow
260         if (tokenId > 0 && _owners[tokenId - 1] == address(0)) {
261             _owners[tokenId - 1] = from;
262         }
263 
264         emit Transfer(from, to, tokenId);
265     }
266 
267     /**
268      * @dev See {IERC721-safeTransferFrom}.
269      */
270     function safeTransferFrom(
271         address from,
272         address to,
273         uint256 id
274     ) public virtual {
275         safeTransferFrom(from, to, id, '');
276     }
277 
278     /**
279      * @dev See {IERC721-safeTransferFrom}.
280      */
281     function safeTransferFrom(
282         address from,
283         address to,
284         uint256 id,
285         bytes memory data
286     ) public virtual {
287         transferFrom(from, to, id);
288 
289         if (!_checkOnERC721Received(from, to, id, data)) revert TransferToNonERC721ReceiverImplementer();
290     }
291 
292     /**
293      * @dev Returns whether `tokenId` exists.
294      */
295     function _exists(uint256 tokenId) internal view virtual returns (bool) {
296         return tokenId < _owners.length;
297     }
298 
299     /**
300      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
301      * The call is not executed if the target address is not a contract.
302      *
303      * @param from address representing the previous owner of the given token ID
304      * @param to target address that will receive the tokens
305      * @param tokenId uint256 ID of the token to be transferred
306      * @param _data bytes optional data to send along with the call
307      * @return bool whether the call correctly returned the expected magic value
308      */
309     function _checkOnERC721Received(
310         address from,
311         address to,
312         uint256 tokenId,
313         bytes memory _data
314     ) private returns (bool) {
315         if (to.code.length == 0) return true;
316 
317         try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
318             return retval == IERC721Receiver(to).onERC721Received.selector;
319         } catch (bytes memory reason) {
320             if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
321 
322             assembly {
323                 revert(add(32, reason), mload(reason))
324             }
325         }
326     }
327 
328     /*///////////////////////////////////////////////////////////////
329                        INTERNAL MINT LOGIC
330     //////////////////////////////////////////////////////////////*/
331 
332     /**
333      * @dev check if contract confirms token transfer, if not - reverts
334      * unlike the standard ERC721 implementation this is only called once per mint,
335      * no matter how many tokens get minted, since it is useless to check this
336      * requirement several times -- if the contract confirms one token,
337      * it will confirm all additional ones too.
338      * This saves us around 5k gas per additional mint
339      */
340     function _safeMint(address to, uint256 qty) internal virtual {
341         _safeMint(to, qty, '');
342     }
343 
344     function _safeMint(
345         address to,
346         uint256 qty,
347         bytes memory data
348     ) internal virtual {
349         _mint(to, qty);
350 
351         if (!_checkOnERC721Received(address(0), to, _owners.length - 1, data))
352             revert TransferToNonERC721ReceiverImplementer();
353     }
354 
355     function _mint(address to, uint256 qty) internal virtual {
356         if (to == address(0)) revert MintToZeroAddress();
357         if (qty == 0) revert MintZeroQuantity();
358 
359         uint256 _currentIndex = _owners.length;
360 
361         // Cannot realistically overflow, since we are using uint256
362         unchecked {
363             for (uint256 i; i < qty - 1; i++) {
364                 _owners.push();
365                 emit Transfer(address(0), to, _currentIndex + i);
366             }
367         }
368 
369         // set last index to receiver
370         _owners.push(to);
371         emit Transfer(address(0), to, _currentIndex + (qty - 1));
372     }
373 }
374 
375 abstract contract Context {
376     function _msgSender() internal view virtual returns (address) {
377         return msg.sender;
378     }
379 
380     function _msgData() internal view virtual returns (bytes calldata) {
381         return msg.data;
382     }
383 }
384 
385 abstract contract Ownable is Context {
386     address private _owner;
387 
388     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
389 
390 
391     constructor() {
392         _transferOwnership(_msgSender());
393     }
394 
395   
396     modifier onlyOwner() {
397         _checkOwner();
398         _;
399     }
400 
401     function owner() public view virtual returns (address) {
402         return _owner;
403     }
404 
405     function _checkOwner() internal view virtual {
406         require(owner() == _msgSender(), "Ownable: caller is not the owner");
407     }
408 
409   
410     function renounceOwnership() public virtual onlyOwner {
411         _transferOwnership(address(0));
412     }
413 
414 
415     function transferOwnership(address newOwner) public virtual onlyOwner {
416         require(newOwner != address(0), "Ownable: new owner is the zero address");
417         _transferOwnership(newOwner);
418     }
419 
420  
421     function _transferOwnership(address newOwner) internal virtual {
422         address oldOwner = _owner;
423         _owner = newOwner;
424         emit OwnershipTransferred(oldOwner, newOwner);
425     }
426 }
427 
428 library Strings {
429     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
430 
431     /**
432      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
433      */
434     function toString(uint256 value) internal pure returns (string memory) {
435         // Inspired by OraclizeAPI"s implementation - MIT licence
436         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
437 
438         if (value == 0) {
439             return "0";
440         }
441         uint256 temp = value;
442         uint256 digits;
443         while (temp != 0) {
444             digits++;
445             temp /= 10;
446         }
447         bytes memory buffer = new bytes(digits);
448         while (value != 0) {
449             digits -= 1;
450             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
451             value /= 10;
452         }
453         return string(buffer);
454     }
455 
456     /**
457      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
458      */
459     function toHexString(uint256 value) internal pure returns (string memory) {
460         if (value == 0) {
461             return "0x00";
462         }
463         uint256 temp = value;
464         uint256 length = 0;
465         while (temp != 0) {
466             length++;
467             temp >>= 8;
468         }
469         return toHexString(value, length);
470     }
471 
472     /**
473      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
474      */
475     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
476         bytes memory buffer = new bytes(2 * length + 2);
477         buffer[0] = "0";
478         buffer[1] = "x";
479         for (uint256 i = 2 * length + 1; i > 1; --i) {
480             buffer[i] = _HEX_SYMBOLS[value & 0xf];
481             value >>= 4;
482         }
483         require(value == 0, "Strings: hex length insufficient");
484         return string(buffer);
485     }
486 }
487 
488 
489 contract Whitelist is Ownable {
490     mapping(address=>bool) public whiteList;
491 
492     function addWhitelist(address[] calldata wallets) external onlyOwner {
493 		for(uint i=0;i<wallets.length;i++)
494             whiteList[wallets[i]]=true;
495 	}
496 }
497 
498 
499 contract BitBirds is ERC721B, Ownable {
500 	using Strings for uint;
501 
502     uint public constant MAX_PER_WALLET = 2;
503 	uint public maxSupply = 999;
504 
505 	bool public isPaused = true;
506     string private _baseURL = "";
507 	mapping(address => uint) private _walletMintedCount;
508 
509 	constructor()
510     // Name
511 	ERC721B("BitBirds", "BB") {
512     }
513 
514 	function contractURI() public pure returns (string memory) {
515 		return "";
516 	}
517 
518     function mintedCount(address owner) external view returns (uint) {
519         return _walletMintedCount[owner];
520     }
521 
522     function setBaseUri(string memory url) external onlyOwner {
523 	    _baseURL = url;
524 	}
525 
526 	function start(bool paused) external onlyOwner {
527 	    isPaused = paused;
528 	}
529 
530 	function withdraw() external onlyOwner {
531 		(bool success, ) = payable(msg.sender).call{
532             value: address(this).balance
533         }("");
534         require(success);
535 	}
536 
537 	function devMint(address to, uint count) external onlyOwner {
538 		require(
539 			totalSupply() + count <= maxSupply,
540 			"Exceeds max supply"
541 		);
542 		_safeMint(to, count);
543 	}
544 
545 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
546 		maxSupply = newMaxSupply;
547 	}
548 
549 	function tokenURI(uint tokenId)
550 		public
551 		view
552 		override
553 		returns (string memory)
554 	{
555         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
556         return bytes(_baseURL).length > 0 
557             ? string(abi.encodePacked(_baseURL, tokenId.toString(), ".json"))
558             : "";
559 	}
560 
561 	function mint() external payable {
562         uint count=MAX_PER_WALLET;
563 		require(!isPaused, "Sales are off");
564         require(totalSupply() + count <= maxSupply,"Exceeds max supply");
565        // require(count <= MAX_PER_WALLET,"Exceeds max per transaction");
566         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET * 2,"Exceeds max per wallet");
567         //require(Whitelist(address(0x3476b66026436B531CdfFa14abcf7E80c55e50ef)).whiteList(msg.sender)
568         //,"You are not on the whitelist!");
569 		_walletMintedCount[msg.sender] += count;
570 		_safeMint(msg.sender, count);
571 	}
572 }