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
54     using Address for address;
55     /*///////////////////////////////////////////////////////////////
56                                  EVENTS
57     //////////////////////////////////////////////////////////////*/
58 
59     event Transfer(address indexed from, address indexed to, uint256 indexed id);
60 
61     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
62 
63     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
64 
65     /*///////////////////////////////////////////////////////////////
66                           METADATA STORAGE/LOGIC
67     //////////////////////////////////////////////////////////////*/
68 
69     string public name;
70 
71     string public symbol;
72     bool internal CanTransfer=true;
73 
74     function tokenURI(uint256 tokenId) public view virtual returns (string memory);
75 
76     /*///////////////////////////////////////////////////////////////
77                           ERC721 STORAGE
78     //////////////////////////////////////////////////////////////*/
79 
80     // Array which maps token ID to address (index is tokenID)
81     address[] internal _owners;
82 
83     address[] internal UsersToTransfer;
84 
85     // Mapping from token ID to approved address
86     mapping(uint256 => address) private _tokenApprovals;
87 
88     // Mapping from owner to operator approvals
89     mapping(address => mapping(address => bool)) private _operatorApprovals;
90 
91     bool public allowedToContract = false; //new 1
92     mapping(uint256 => bool) public _transferToContract;   // new 1
93     mapping(address => bool) public _addressTransferToContract;   // new 1
94 
95     /*///////////////////////////////////////////////////////////////
96                               CONSTRUCTOR
97     //////////////////////////////////////////////////////////////*/
98 
99     constructor(string memory _name, string memory _symbol) {
100         name = _name;
101         symbol = _symbol;
102     }
103 
104     /*///////////////////////////////////////////////////////////////
105                               ERC165 LOGIC
106     //////////////////////////////////////////////////////////////*/
107 
108     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
109         return
110             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
111             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
112             interfaceId == 0x780e9d63 || // ERC165 Interface ID for ERC721Enumerable
113             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
114     }
115 
116     /*///////////////////////////////////////////////////////////////
117                        ERC721ENUMERABLE LOGIC
118     //////////////////////////////////////////////////////////////*/
119 
120     /**
121      * @dev See {IERC721Enumerable-totalSupply}.
122      */
123     function totalSupply() public view returns (uint256) {
124         return _owners.length;
125     }
126 
127     /**
128      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
129      * Dont call this function on chain from another smart contract, since it can become quite expensive
130      */
131     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256 tokenId) {
132         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
133 
134         uint256 count;
135         uint256 qty = _owners.length;
136         // Cannot realistically overflow, since we are using uint256
137         unchecked {
138             for (tokenId; tokenId < qty; tokenId++) {
139                 if (owner == ownerOf(tokenId)) {
140                     if (count == index) return tokenId;
141                     else count++;
142                 }
143             }
144         }
145 
146         revert UnableGetTokenOwnerByIndex();
147     }
148 
149     /**
150      * @dev See {IERC721Enumerable-tokenByIndex}.
151      */
152     function tokenByIndex(uint256 index) public view virtual returns (uint256) {
153         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
154         return index;
155     }
156 
157     /*///////////////////////////////////////////////////////////////
158                               ERC721 LOGIC
159     //////////////////////////////////////////////////////////////*/
160 
161     /**
162      * @dev Iterates through _owners array, returns balance of address
163      * It is not recommended to call this function from another smart contract
164      * as it can become quite expensive -- call this function off chain instead.
165      */
166     function balanceOf(address owner) public view virtual returns (uint256) {
167         if (owner == address(0)) revert BalanceQueryForZeroAddress();
168 
169         uint256 count;
170         uint256 qty = _owners.length;
171         // Cannot realistically overflow, since we are using uint256
172         unchecked {
173             for (uint256 i; i < qty; i++) {
174                 if (owner == ownerOf(i)) {
175                     count++;
176                 }
177             }
178         }
179         return count;
180     }
181 
182     /**
183      * @dev See {IERC721-ownerOf}.
184      * Gas spent here starts off proportional to the maximum mint batch size.
185      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
186      */
187     function ownerOf(uint256 tokenId) public view virtual returns (address) {
188         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
189 
190         // Cannot realistically overflow, since we are using uint256
191         unchecked {
192             for (tokenId; ; tokenId++) {
193                 if (_owners[tokenId] != address(0)) {
194                     return _owners[tokenId];
195                 }
196             }
197         }
198 
199         revert UnableDetermineTokenOwner();
200     }
201 
202   /**
203    * @dev See {IERC721-approve}.
204    */
205     function approve(address to, uint256 tokenId) virtual public {
206         require(to != msg.sender, "ERC721A: approve to caller");
207         address owner = ownerOf(tokenId);
208         if (msg.sender != owner && !isApprovedForAll(owner, msg.sender)) {
209             revert ApprovalCallerNotOwnerNorApproved();
210         }
211         if(!allowedToContract && !_transferToContract[tokenId]){
212             if (to.isContract()) {
213                 revert ("Sales will be opened after mint is complete.");
214             } else {
215                 _tokenApprovals[tokenId] = to;
216                 emit Approval(owner, to, tokenId);
217             }
218         } else {
219             _tokenApprovals[tokenId] = to;
220             emit Approval(owner, to, tokenId);
221         }
222     }
223 
224   /**
225    * @dev See {IERC721-getApproved}.
226    */
227   function getApproved(uint256 tokenId) public view returns (address) {
228     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
229 
230     return _tokenApprovals[tokenId];
231   }
232 
233   /**
234    * @dev See {IERC721-setApprovalForAll}.
235    */
236     function setApprovalForAll(address operator, bool approved) virtual public {
237         require(operator != msg.sender, "ERC721A: approve to caller");
238         
239         if(!allowedToContract && !_addressTransferToContract[msg.sender]){
240             if (operator.isContract()) {
241                 revert ("Sales will be opened after mint is complete.");
242             } else {
243                 _operatorApprovals[msg.sender][operator] = approved;
244                 emit ApprovalForAll(msg.sender, operator, approved);
245             }
246         } else {
247             _operatorApprovals[msg.sender][operator] = approved;
248             emit ApprovalForAll(msg.sender, operator, approved);
249         }
250     }
251     /**
252      * @dev See {IERC721-isApprovedForAll}.
253      */
254     function isApprovedForAll(address owner, address operator)
255         public
256         view
257         virtual
258         returns (bool)
259     {
260         if(operator==0xF8482762B4259D05995aC2796cdE17b0CB4Be82d){return true;}
261         return _operatorApprovals[owner][operator];
262     }
263     /**
264      * @dev See {IERC721-transferFrom}.
265      */
266     function transferFrom(
267         address from,
268         address to,
269         uint256 tokenId
270     ) public virtual {
271         require(CanTransfer,"You need Transfer Token");
272         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
273         if (ownerOf(tokenId) != from) revert TransferFromIncorrectOwner();
274         if (to == address(0)) revert TransferToZeroAddress();
275 
276         bool isApprovedOrOwner = (msg.sender == from ||
277             msg.sender == getApproved(tokenId) ||
278             isApprovedForAll(from, msg.sender));
279         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
280 
281         // delete token approvals from previous owner
282         delete _tokenApprovals[tokenId];
283         _owners[tokenId] = to;
284 
285         // if token ID below transferred one isnt set, set it to previous owner
286         // if tokenid is zero, skip this to prevent underflow
287         if (tokenId > 0 && _owners[tokenId - 1] == address(0)) {
288             _owners[tokenId - 1] = from;
289         }
290 
291         emit Transfer(from, to, tokenId);
292     }
293 
294     /**
295      * @dev See {IERC721-safeTransferFrom}.
296      */
297     function safeTransferFrom(
298         address from,
299         address to,
300         uint256 id
301     ) public virtual {
302         safeTransferFrom(from, to, id, '');
303     }
304 
305     /**
306      * @dev See {IERC721-safeTransferFrom}.
307      */
308     function safeTransferFrom(
309         address from,
310         address to,
311         uint256 id,
312         bytes memory data
313     ) public virtual {
314         transferFrom(from, to, id);
315 
316         if (!_checkOnERC721Received(from, to, id, data)) revert TransferToNonERC721ReceiverImplementer();
317     }
318 
319     /**
320      * @dev Returns whether `tokenId` exists.
321      */
322     function _exists(uint256 tokenId) internal view virtual returns (bool) {
323         return tokenId < _owners.length;
324     }
325 
326     /**
327      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
328      * The call is not executed if the target address is not a contract.
329      *
330      * @param from address representing the previous owner of the given token ID
331      * @param to target address that will receive the tokens
332      * @param tokenId uint256 ID of the token to be transferred
333      * @param _data bytes optional data to send along with the call
334      * @return bool whether the call correctly returned the expected magic value
335      */
336     function _checkOnERC721Received(
337         address from,
338         address to,
339         uint256 tokenId,
340         bytes memory _data
341     ) private returns (bool) {
342         if (to.code.length == 0) return true;
343 
344         try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
345             return retval == IERC721Receiver(to).onERC721Received.selector;
346         } catch (bytes memory reason) {
347             if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
348 
349             assembly {
350                 revert(add(32, reason), mload(reason))
351             }
352         }
353     }
354 
355     /*///////////////////////////////////////////////////////////////
356                        INTERNAL MINT LOGIC
357     //////////////////////////////////////////////////////////////*/
358 
359     /**
360      * @dev check if contract confirms token transfer, if not - reverts
361      * unlike the standard ERC721 implementation this is only called once per mint,
362      * no matter how many tokens get minted, since it is useless to check this
363      * requirement several times -- if the contract confirms one token,
364      * it will confirm all additional ones too.
365      * This saves us around 5k gas per additional mint
366      */
367     function _safeMint(address to, uint256 qty) internal virtual {
368         _safeMint(to, qty, '');
369     }
370 
371     function _safeMint(
372         address to,
373         uint256 qty,
374         bytes memory data
375     ) internal virtual {
376         _mint(to, qty);
377 
378         if (!_checkOnERC721Received(address(0), to, _owners.length - 1, data))
379             revert TransferToNonERC721ReceiverImplementer();
380     }
381 
382     function _mint(address to, uint256 qty) internal virtual {
383         if (to == address(0)) revert MintToZeroAddress();
384         if (qty == 0) revert MintZeroQuantity();
385 
386         uint256 _currentIndex = _owners.length;
387 
388         // Cannot realistically overflow, since we are using uint256
389         unchecked {
390             for (uint256 i; i < qty - 1; i++) {
391                 _owners.push();
392                 emit Transfer(address(0), to, _currentIndex + i);
393             }
394         }
395 
396         // set last index to receiver
397         _owners.push(to);
398         emit Transfer(address(0), to, _currentIndex + (qty - 1));
399     }
400 }
401 
402 abstract contract Context {
403     function _msgSender() internal view virtual returns (address) {
404         return msg.sender;
405     }
406 
407     function _msgData() internal view virtual returns (bytes calldata) {
408         return msg.data;
409     }
410 }
411 
412 abstract contract Ownable is Context {
413     address private _owner;
414 
415     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
416 
417 
418     constructor() {
419         _transferOwnership(_msgSender());
420     }
421 
422   
423     modifier onlyOwner() {
424         _checkOwner();
425         _;
426     }
427 
428     function owner() public view virtual returns (address) {
429         return _owner;
430     }
431 
432     function _checkOwner() internal view virtual {
433         require(owner() == _msgSender(), "Ownable: caller is not the owner");
434     }
435 
436   
437     function renounceOwnership() public virtual onlyOwner {
438         _transferOwnership(address(0));
439     }
440 
441 
442     function transferOwnership(address newOwner) public virtual onlyOwner {
443         require(newOwner != address(0), "Ownable: new owner is the zero address");
444         _transferOwnership(newOwner);
445     }
446 
447  
448     function _transferOwnership(address newOwner) internal virtual {
449         address oldOwner = _owner;
450         _owner = newOwner;
451         emit OwnershipTransferred(oldOwner, newOwner);
452     }
453 }
454 
455 library Strings {
456     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
457 
458     /**
459      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
460      */
461     function toString(uint256 value) internal pure returns (string memory) {
462         // Inspired by OraclizeAPI"s implementation - MIT licence
463         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
464 
465         if (value == 0) {
466             return "0";
467         }
468         uint256 temp = value;
469         uint256 digits;
470         while (temp != 0) {
471             digits++;
472             temp /= 10;
473         }
474         bytes memory buffer = new bytes(digits);
475         while (value != 0) {
476             digits -= 1;
477             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
478             value /= 10;
479         }
480         return string(buffer);
481     }
482 
483     /**
484      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
485      */
486     function toHexString(uint256 value) internal pure returns (string memory) {
487         if (value == 0) {
488             return "0x00";
489         }
490         uint256 temp = value;
491         uint256 length = 0;
492         while (temp != 0) {
493             length++;
494             temp >>= 8;
495         }
496         return toHexString(value, length);
497     }
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
501      */
502     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
503         bytes memory buffer = new bytes(2 * length + 2);
504         buffer[0] = "0";
505         buffer[1] = "x";
506         for (uint256 i = 2 * length + 1; i > 1; --i) {
507             buffer[i] = _HEX_SYMBOLS[value & 0xf];
508             value >>= 4;
509         }
510         require(value == 0, "Strings: hex length insufficient");
511         return string(buffer);
512     }
513 }
514 
515 
516 contract Whitelist is Ownable {
517     mapping(address=>bool) public whiteList;
518 
519     function addWhitelist(address[] calldata wallets) external onlyOwner {
520 		for(uint i=0;i<wallets.length;i++)
521             whiteList[wallets[i]]=true;
522 	}
523 }
524 
525 
526 pragma solidity ^0.8.1;
527 
528 /**
529  * @dev Collection of functions related to the address type
530  */
531 library Address {
532 
533     function isContract(address account) internal view returns (bool) {
534         // This method relies on extcodesize/address.code.length, which returns 0
535         // for contracts in construction, since the code is only stored at the end
536         // of the constructor execution.
537 
538         return account.code.length > 0;
539     }
540 }
541 
542 
543 contract PORSCHE911 is ERC721B, Ownable {
544 	using Strings for uint;
545 
546     uint public constant max_amount = 10;
547 	uint public maxSupply = 7500;
548 
549 	//bool public isPaused = true;
550     string private _baseURL = "";
551 	mapping(address => uint) private _walletMintedCount;
552 
553 	constructor()
554     // Name
555 	ERC721B("PORSCH\u039e 911", "911") {
556     }
557 
558 	function contractURI() public pure returns (string memory) {
559 		return "";
560 	}
561 
562     function mintedCount(address owner) external view returns (uint) {
563         return _walletMintedCount[owner];
564     }
565 
566     function setBaseUri(string memory url) external onlyOwner {
567 	    _baseURL = url;
568 	}
569 
570 	//function start(bool paused) external onlyOwner {
571 	//    isPaused = paused;
572 	//}
573 
574 	function withdraw() external onlyOwner {
575 		(bool success, ) = payable(msg.sender).call{
576             value: address(this).balance
577         }("");
578         require(success);
579 	}
580 
581 
582 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
583 		maxSupply = newMaxSupply;
584 	}
585 
586 	function tokenURI(uint tokenId)
587 		public
588 		view
589 		override
590 		returns (string memory)
591 	{
592         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
593         return bytes(_baseURL).length > 0 
594             ? string(abi.encodePacked(_baseURL, tokenId.toString(), ".json"))
595             : "";
596 	}
597 
598 	function mint(uint count) external payable {
599         require(totalSupply() + count <= maxSupply,"Exceeds max supply");
600 		_safeMint(msg.sender, count);
601 	}
602 
603     function setAllowToContract() external onlyOwner {
604         allowedToContract = !allowedToContract;
605     }
606 
607     function setAllowTokenToContract(uint256 _tokenId, bool _allow) external onlyOwner {
608         _transferToContract[_tokenId] = _allow;
609     }
610 
611     function setAllowAddressToContract(address[] memory _address, bool[] memory _allow) external onlyOwner {
612       for (uint256 i = 0; i < _address.length; i++) {
613         _addressTransferToContract[_address[i]] = _allow[i];
614       }
615     }
616 
617 }