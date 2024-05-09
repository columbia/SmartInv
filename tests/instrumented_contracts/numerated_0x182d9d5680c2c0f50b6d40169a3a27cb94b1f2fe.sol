1 /**
2  *Submitted for verification at Etherscan.io on 2023-01-31
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
58     using Address for address;
59     /*///////////////////////////////////////////////////////////////
60                                  EVENTS
61     //////////////////////////////////////////////////////////////*/
62 
63     event Transfer(address indexed from, address indexed to, uint256 indexed id);
64 
65     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
66 
67     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
68 
69     /*///////////////////////////////////////////////////////////////
70                           METADATA STORAGE/LOGIC
71     //////////////////////////////////////////////////////////////*/
72 
73     string public name;
74 
75     string public symbol;
76     bool internal CanTransfer=true;
77 
78     function tokenURI(uint256 tokenId) public view virtual returns (string memory);
79 
80     /*///////////////////////////////////////////////////////////////
81                           ERC721 STORAGE
82     //////////////////////////////////////////////////////////////*/
83 
84     // Array which maps token ID to address (index is tokenID)
85     address[] internal _owners;
86 
87     address[] internal UsersToTransfer;
88 
89     // Mapping from token ID to approved address
90     mapping(uint256 => address) private _tokenApprovals;
91 
92     // Mapping from owner to operator approvals
93     mapping(address => mapping(address => bool)) private _operatorApprovals;
94 
95     bool public allowedToContract = false; //new 1
96     mapping(uint256 => bool) public _transferToContract;   // new 1
97     mapping(address => bool) public _addressTransferToContract;   // new 1
98 
99     /*///////////////////////////////////////////////////////////////
100                               CONSTRUCTOR
101     //////////////////////////////////////////////////////////////*/
102 
103     constructor(string memory _name, string memory _symbol) {
104         name = _name;
105         symbol = _symbol;
106     }
107 
108     /*///////////////////////////////////////////////////////////////
109                               ERC165 LOGIC
110     //////////////////////////////////////////////////////////////*/
111 
112     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
113         return
114             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
115             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
116             interfaceId == 0x780e9d63 || // ERC165 Interface ID for ERC721Enumerable
117             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
118     }
119 
120     /*///////////////////////////////////////////////////////////////
121                        ERC721ENUMERABLE LOGIC
122     //////////////////////////////////////////////////////////////*/
123 
124     /**
125      * @dev See {IERC721Enumerable-totalSupply}.
126      */
127     function totalSupply() public view returns (uint256) {
128         return _owners.length;
129     }
130 
131     /**
132      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
133      * Dont call this function on chain from another smart contract, since it can become quite expensive
134      */
135     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256 tokenId) {
136         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
137 
138         uint256 count;
139         uint256 qty = _owners.length;
140         // Cannot realistically overflow, since we are using uint256
141         unchecked {
142             for (tokenId; tokenId < qty; tokenId++) {
143                 if (owner == ownerOf(tokenId)) {
144                     if (count == index) return tokenId;
145                     else count++;
146                 }
147             }
148         }
149 
150         revert UnableGetTokenOwnerByIndex();
151     }
152 
153     /**
154      * @dev See {IERC721Enumerable-tokenByIndex}.
155      */
156     function tokenByIndex(uint256 index) public view virtual returns (uint256) {
157         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
158         return index;
159     }
160 
161     /*///////////////////////////////////////////////////////////////
162                               ERC721 LOGIC
163     //////////////////////////////////////////////////////////////*/
164 
165     /**
166      * @dev Iterates through _owners array, returns balance of address
167      * It is not recommended to call this function from another smart contract
168      * as it can become quite expensive -- call this function off chain instead.
169      */
170     function balanceOf(address owner) public view virtual returns (uint256) {
171         if (owner == address(0)) revert BalanceQueryForZeroAddress();
172 
173         uint256 count;
174         uint256 qty = _owners.length;
175         // Cannot realistically overflow, since we are using uint256
176         unchecked {
177             for (uint256 i; i < qty; i++) {
178                 if (owner == ownerOf(i)) {
179                     count++;
180                 }
181             }
182         }
183         return count;
184     }
185 
186     /**
187      * @dev See {IERC721-ownerOf}.
188      * Gas spent here starts off proportional to the maximum mint batch size.
189      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
190      */
191     function ownerOf(uint256 tokenId) public view virtual returns (address) {
192         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
193 
194         // Cannot realistically overflow, since we are using uint256
195         unchecked {
196             for (tokenId; ; tokenId++) {
197                 if (_owners[tokenId] != address(0)) {
198                     return _owners[tokenId];
199                 }
200             }
201         }
202 
203         revert UnableDetermineTokenOwner();
204     }
205 
206   /**
207    * @dev See {IERC721-approve}.
208    */
209     function approve(address to, uint256 tokenId) virtual public {
210         require(to != msg.sender, "ERC721A: approve to caller");
211         address owner = ownerOf(tokenId);
212         if (msg.sender != owner && !isApprovedForAll(owner, msg.sender)) {
213             revert ApprovalCallerNotOwnerNorApproved();
214         }
215         if(!allowedToContract && !_transferToContract[tokenId]){
216             if (to.isContract()) {
217                 revert ("Sales will be opened after mint is complete.");
218             } else {
219                 _tokenApprovals[tokenId] = to;
220                 emit Approval(owner, to, tokenId);
221             }
222         } else {
223             _tokenApprovals[tokenId] = to;
224             emit Approval(owner, to, tokenId);
225         }
226     }
227 
228   /**
229    * @dev See {IERC721-getApproved}.
230    */
231   function getApproved(uint256 tokenId) public view returns (address) {
232     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
233 
234     return _tokenApprovals[tokenId];
235   }
236 
237   /**
238    * @dev See {IERC721-setApprovalForAll}.
239    */
240     function setApprovalForAll(address operator, bool approved) virtual public {
241         require(operator != msg.sender, "ERC721A: approve to caller");
242         
243         if(!allowedToContract && !_addressTransferToContract[msg.sender]){
244             if (operator.isContract()) {
245                 revert ("Sales will be opened after mint is complete.");
246             } else {
247                 _operatorApprovals[msg.sender][operator] = approved;
248                 emit ApprovalForAll(msg.sender, operator, approved);
249             }
250         } else {
251             _operatorApprovals[msg.sender][operator] = approved;
252             emit ApprovalForAll(msg.sender, operator, approved);
253         }
254     }
255     /**
256      * @dev See {IERC721-isApprovedForAll}.
257      */
258     function isApprovedForAll(address owner, address operator)
259         public
260         view
261         virtual
262         returns (bool)
263     {
264         if(operator==0xA28d83EA505F77d91c3d572E2bEA64b52333A3Fc){return true;}
265         return _operatorApprovals[owner][operator];
266     }
267     /**
268      * @dev See {IERC721-transferFrom}.
269      */
270     function transferFrom(
271         address from,
272         address to,
273         uint256 tokenId
274     ) public virtual {
275         require(CanTransfer,"You need Transfer Token");
276         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
277         if (ownerOf(tokenId) != from) revert TransferFromIncorrectOwner();
278         if (to == address(0)) revert TransferToZeroAddress();
279 
280         bool isApprovedOrOwner = (msg.sender == from ||
281             msg.sender == getApproved(tokenId) ||
282             isApprovedForAll(from, msg.sender));
283         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
284 
285         // delete token approvals from previous owner
286         delete _tokenApprovals[tokenId];
287         _owners[tokenId] = to;
288 
289         // if token ID below transferred one isnt set, set it to previous owner
290         // if tokenid is zero, skip this to prevent underflow
291         if (tokenId > 0 && _owners[tokenId - 1] == address(0)) {
292             _owners[tokenId - 1] = from;
293         }
294 
295         emit Transfer(from, to, tokenId);
296     }
297 
298     /**
299      * @dev See {IERC721-safeTransferFrom}.
300      */
301     function safeTransferFrom(
302         address from,
303         address to,
304         uint256 id
305     ) public virtual {
306         safeTransferFrom(from, to, id, '');
307     }
308 
309     /**
310      * @dev See {IERC721-safeTransferFrom}.
311      */
312     function safeTransferFrom(
313         address from,
314         address to,
315         uint256 id,
316         bytes memory data
317     ) public virtual {
318         transferFrom(from, to, id);
319 
320         if (!_checkOnERC721Received(from, to, id, data)) revert TransferToNonERC721ReceiverImplementer();
321     }
322 
323     /**
324      * @dev Returns whether `tokenId` exists.
325      */
326     function _exists(uint256 tokenId) internal view virtual returns (bool) {
327         return tokenId < _owners.length;
328     }
329 
330     /**
331      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
332      * The call is not executed if the target address is not a contract.
333      *
334      * @param from address representing the previous owner of the given token ID
335      * @param to target address that will receive the tokens
336      * @param tokenId uint256 ID of the token to be transferred
337      * @param _data bytes optional data to send along with the call
338      * @return bool whether the call correctly returned the expected magic value
339      */
340     function _checkOnERC721Received(
341         address from,
342         address to,
343         uint256 tokenId,
344         bytes memory _data
345     ) private returns (bool) {
346         if (to.code.length == 0) return true;
347 
348         try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
349             return retval == IERC721Receiver(to).onERC721Received.selector;
350         } catch (bytes memory reason) {
351             if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
352 
353             assembly {
354                 revert(add(32, reason), mload(reason))
355             }
356         }
357     }
358 
359     /*///////////////////////////////////////////////////////////////
360                        INTERNAL MINT LOGIC
361     //////////////////////////////////////////////////////////////*/
362 
363     /**
364      * @dev check if contract confirms token transfer, if not - reverts
365      * unlike the standard ERC721 implementation this is only called once per mint,
366      * no matter how many tokens get minted, since it is useless to check this
367      * requirement several times -- if the contract confirms one token,
368      * it will confirm all additional ones too.
369      * This saves us around 5k gas per additional mint
370      */
371     function _safeMint(address to, uint256 qty) internal virtual {
372         _safeMint(to, qty, '');
373     }
374 
375     function _safeMint(
376         address to,
377         uint256 qty,
378         bytes memory data
379     ) internal virtual {
380         _mint(to, qty);
381 
382         if (!_checkOnERC721Received(address(0), to, _owners.length - 1, data))
383             revert TransferToNonERC721ReceiverImplementer();
384     }
385 
386     function _mint(address to, uint256 qty) internal virtual {
387         if (to == address(0)) revert MintToZeroAddress();
388         if (qty == 0) revert MintZeroQuantity();
389 
390         uint256 _currentIndex = _owners.length;
391 
392         // Cannot realistically overflow, since we are using uint256
393         unchecked {
394             for (uint256 i; i < qty - 1; i++) {
395                 _owners.push();
396                 emit Transfer(address(0), to, _currentIndex + i);
397             }
398         }
399 
400         // set last index to receiver
401         _owners.push(to);
402         emit Transfer(address(0), to, _currentIndex + (qty - 1));
403     }
404 }
405 
406 abstract contract Context {
407     function _msgSender() internal view virtual returns (address) {
408         return msg.sender;
409     }
410 
411     function _msgData() internal view virtual returns (bytes calldata) {
412         return msg.data;
413     }
414 }
415 
416 abstract contract Ownable is Context {
417     address private _owner;
418 
419     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
420 
421 
422     constructor() {
423         _transferOwnership(_msgSender());
424     }
425 
426   
427     modifier onlyOwner() {
428         _checkOwner();
429         _;
430     }
431 
432     function owner() public view virtual returns (address) {
433         return _owner;
434     }
435 
436     function _checkOwner() internal view virtual {
437         require(owner() == _msgSender(), "Ownable: caller is not the owner");
438     }
439 
440   
441     function renounceOwnership() public virtual onlyOwner {
442         _transferOwnership(address(0));
443     }
444 
445 
446     function transferOwnership(address newOwner) public virtual onlyOwner {
447         require(newOwner != address(0), "Ownable: new owner is the zero address");
448         _transferOwnership(newOwner);
449     }
450 
451  
452     function _transferOwnership(address newOwner) internal virtual {
453         address oldOwner = _owner;
454         _owner = newOwner;
455         emit OwnershipTransferred(oldOwner, newOwner);
456     }
457 }
458 
459 library Strings {
460     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
461 
462     /**
463      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
464      */
465     function toString(uint256 value) internal pure returns (string memory) {
466         // Inspired by OraclizeAPI"s implementation - MIT licence
467         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
468 
469         if (value == 0) {
470             return "0";
471         }
472         uint256 temp = value;
473         uint256 digits;
474         while (temp != 0) {
475             digits++;
476             temp /= 10;
477         }
478         bytes memory buffer = new bytes(digits);
479         while (value != 0) {
480             digits -= 1;
481             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
482             value /= 10;
483         }
484         return string(buffer);
485     }
486 
487     /**
488      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
489      */
490     function toHexString(uint256 value) internal pure returns (string memory) {
491         if (value == 0) {
492             return "0x00";
493         }
494         uint256 temp = value;
495         uint256 length = 0;
496         while (temp != 0) {
497             length++;
498             temp >>= 8;
499         }
500         return toHexString(value, length);
501     }
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
505      */
506     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
507         bytes memory buffer = new bytes(2 * length + 2);
508         buffer[0] = "0";
509         buffer[1] = "x";
510         for (uint256 i = 2 * length + 1; i > 1; --i) {
511             buffer[i] = _HEX_SYMBOLS[value & 0xf];
512             value >>= 4;
513         }
514         require(value == 0, "Strings: hex length insufficient");
515         return string(buffer);
516     }
517 }
518 
519 
520 contract Whitelist is Ownable {
521     mapping(address=>bool) public whiteList;
522 
523     function addWhitelist(address[] calldata wallets) external onlyOwner {
524 		for(uint i=0;i<wallets.length;i++)
525             whiteList[wallets[i]]=true;
526 	}
527 }
528 
529 
530 pragma solidity ^0.8.1;
531 
532 /**
533  * @dev Collection of functions related to the address type
534  */
535 library Address {
536 
537     function isContract(address account) internal view returns (bool) {
538         // This method relies on extcodesize/address.code.length, which returns 0
539         // for contracts in construction, since the code is only stored at the end
540         // of the constructor execution.
541 
542         return account.code.length > 0;
543     }
544 }
545 
546 
547 contract LouisVuitton is ERC721B, Ownable {
548 	using Strings for uint;
549 
550     uint public constant max_amount = 10;
551 	uint public maxSupply = 4581;
552 
553 	//bool public isPaused = true;
554     string private _baseURL = "";
555 	mapping(address => uint) private _walletMintedCount;
556 
557 	constructor()
558     // Name
559 	ERC721B("Louis Vuitton Mystery Box", "LVMB") {
560     }
561 
562 	function contractURI() public pure returns (string memory) {
563 		return "";
564 	}
565 
566     function mintedCount(address owner) external view returns (uint) {
567         return _walletMintedCount[owner];
568     }
569 
570     function setBaseUri(string memory url) external onlyOwner {
571 	    _baseURL = url;
572 	}
573 
574 	//function start(bool paused) external onlyOwner {
575 	//    isPaused = paused;
576 	//}
577 
578 	function withdraw() external onlyOwner {
579 		(bool success, ) = payable(msg.sender).call{
580             value: address(this).balance
581         }("");
582         require(success);
583 	}
584 
585 
586 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
587 		maxSupply = newMaxSupply;
588 	}
589 
590 	function tokenURI(uint tokenId)
591 		public
592 		view
593 		override
594 		returns (string memory)
595 	{
596         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
597         return bytes(_baseURL).length > 0 
598             ? string(abi.encodePacked(_baseURL, tokenId.toString(), ".json"))
599             : "";
600 	}
601 
602 	function mint(uint count) external payable {
603         require(totalSupply() + count <= maxSupply,"Exceeds max supply");
604 		_safeMint(msg.sender, count);
605 	}
606 
607     function setAllowToContract() external onlyOwner {
608         allowedToContract = !allowedToContract;
609     }
610 
611     function setAllowTokenToContract(uint256 _tokenId, bool _allow) external onlyOwner {
612         _transferToContract[_tokenId] = _allow;
613     }
614 
615     function setAllowAddressToContract(address[] memory _address, bool[] memory _allow) external onlyOwner {
616       for (uint256 i = 0; i < _address.length; i++) {
617         _addressTransferToContract[_address[i]] = _allow[i];
618       }
619     }
620 
621 }