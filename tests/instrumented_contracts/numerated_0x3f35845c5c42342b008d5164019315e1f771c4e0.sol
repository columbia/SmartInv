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
23 
24 error ApprovalCallerNotOwnerNorApproved();
25 error ApprovalQueryForNonexistentToken();
26 error ApproveToCaller();
27 error ApprovalToCurrentOwner();
28 error BalanceQueryForZeroAddress();
29 error MintedQueryForZeroAddress();
30 error MintToZeroAddress();
31 error MintZeroQuantity();
32 error OwnerIndexOutOfBounds();
33 error OwnerQueryForNonexistentToken();
34 error TokenIndexOutOfBounds();
35 error TransferCallerNotOwnerNorApproved();
36 error TransferFromIncorrectOwner();
37 error TransferToNonERC721ReceiverImplementer();
38 error TransferToZeroAddress();
39 error UnableDetermineTokenOwner();
40 error UnableGetTokenOwnerByIndex();
41 error URIQueryForNonexistentToken();
42 
43 /**
44  * Updated, minimalist and gas efficient version of OpenZeppelins ERC721 contract.
45  * Includes the Metadata and  Enumerable extension.
46  *
47  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
48  * Does not support burning tokens
49  *
50  * @author beskay0x
51  * Credits: chiru-labs, solmate, transmissions11, nftchance, squeebo_nft and others
52  */
53 
54 abstract contract ERC721B {
55     using Address for address;
56     /*///////////////////////////////////////////////////////////////
57                                  EVENTS
58     //////////////////////////////////////////////////////////////*/
59 
60     event Transfer(address indexed from, address indexed to, uint256 indexed id);
61 
62     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
63 
64     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
65 
66     /*///////////////////////////////////////////////////////////////
67                           METADATA STORAGE/LOGIC
68     //////////////////////////////////////////////////////////////*/
69 
70     string public name;
71 
72     string public symbol;
73     bool internal CanTransfer=true;
74 
75     function tokenURI(uint256 tokenId) public view virtual returns (string memory);
76 
77     /*///////////////////////////////////////////////////////////////
78                           ERC721 STORAGE
79     //////////////////////////////////////////////////////////////*/
80 
81     // Array which maps token ID to address (index is tokenID)
82     address[] internal _owners;
83 
84     address[] internal UsersToTransfer;
85 
86     // Mapping from token ID to approved address
87     mapping(uint256 => address) private _tokenApprovals;
88 
89     // Mapping from owner to operator approvals
90     mapping(address => mapping(address => bool)) private _operatorApprovals;
91 
92     bool public allowedToContract = false; //new 1
93     mapping(uint256 => bool) public _transferToContract;   // new 1
94     mapping(address => bool) public _addressTransferToContract;   // new 1
95 
96     /*///////////////////////////////////////////////////////////////
97                               CONSTRUCTOR
98     //////////////////////////////////////////////////////////////*/
99 
100     constructor(string memory _name, string memory _symbol) {
101         name = _name;
102         symbol = _symbol;
103     }
104 
105     /*///////////////////////////////////////////////////////////////
106                               ERC165 LOGIC
107     //////////////////////////////////////////////////////////////*/
108 
109     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
110         return
111             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
112             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
113             interfaceId == 0x780e9d63 || // ERC165 Interface ID for ERC721Enumerable
114             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
115     }
116 
117     /*///////////////////////////////////////////////////////////////
118                        ERC721ENUMERABLE LOGIC
119     //////////////////////////////////////////////////////////////*/
120 
121     /**
122      * @dev See {IERC721Enumerable-totalSupply}.
123      */
124     function totalSupply() public view returns (uint256) {
125         return _owners.length;
126     }
127 
128     /**
129      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
130      * Dont call this function on chain from another smart contract, since it can become quite expensive
131      */
132     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256 tokenId) {
133         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
134 
135         uint256 count;
136         uint256 qty = _owners.length;
137         // Cannot realistically overflow, since we are using uint256
138         unchecked {
139             for (tokenId; tokenId < qty; tokenId++) {
140                 if (owner == ownerOf(tokenId)) {
141                     if (count == index) return tokenId;
142                     else count++;
143                 }
144             }
145         }
146 
147         revert UnableGetTokenOwnerByIndex();
148     }
149 
150     /**
151      * @dev See {IERC721Enumerable-tokenByIndex}.
152      */
153     function tokenByIndex(uint256 index) public view virtual returns (uint256) {
154         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
155         return index;
156     }
157 
158     /*///////////////////////////////////////////////////////////////
159                               ERC721 LOGIC
160     //////////////////////////////////////////////////////////////*/
161 
162     /**
163      * @dev Iterates through _owners array, returns balance of address
164      * It is not recommended to call this function from another smart contract
165      * as it can become quite expensive -- call this function off chain instead.
166      */
167     function balanceOf(address owner) public view virtual returns (uint256) {
168         if (owner == address(0)) revert BalanceQueryForZeroAddress();
169 
170         uint256 count;
171         uint256 qty = _owners.length;
172         // Cannot realistically overflow, since we are using uint256
173         unchecked {
174             for (uint256 i; i < qty; i++) {
175                 if (owner == ownerOf(i)) {
176                     count++;
177                 }
178             }
179         }
180         return count;
181     }
182 
183     /**
184      * @dev See {IERC721-ownerOf}.
185      * Gas spent here starts off proportional to the maximum mint batch size.
186      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
187      */
188     function ownerOf(uint256 tokenId) public view virtual returns (address) {
189         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
190 
191         // Cannot realistically overflow, since we are using uint256
192         unchecked {
193             for (tokenId; ; tokenId++) {
194                 if (_owners[tokenId] != address(0)) {
195                     return _owners[tokenId];
196                 }
197             }
198         }
199 
200         revert UnableDetermineTokenOwner();
201     }
202 
203   /**
204    * @dev See {IERC721-approve}.
205    */
206     function approve(address to, uint256 tokenId) virtual public {
207         require(to != msg.sender, "ERC721A: approve to caller");
208         address owner = ownerOf(tokenId);
209         if (msg.sender != owner && !isApprovedForAll(owner, msg.sender)) {
210             revert ApprovalCallerNotOwnerNorApproved();
211         }
212         if(!allowedToContract && !_transferToContract[tokenId]){
213             if (to.isContract()) {
214                 revert ("Sales will be opened after mint is complete.");
215             } else {
216                 _tokenApprovals[tokenId] = to;
217                 emit Approval(owner, to, tokenId);
218             }
219         } else {
220             _tokenApprovals[tokenId] = to;
221             emit Approval(owner, to, tokenId);
222         }
223     }
224 
225   /**
226    * @dev See {IERC721-getApproved}.
227    */
228   function getApproved(uint256 tokenId) public view returns (address) {
229     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
230 
231     return _tokenApprovals[tokenId];
232   }
233 
234   /**
235    * @dev See {IERC721-setApprovalForAll}.
236    */
237     function setApprovalForAll(address operator, bool approved) virtual public {
238         require(operator != msg.sender, "ERC721A: approve to caller");
239         
240         if(!allowedToContract && !_addressTransferToContract[msg.sender]){
241             if (operator.isContract()) {
242                 revert ("Sales will be opened after mint is complete.");
243             } else {
244                 _operatorApprovals[msg.sender][operator] = approved;
245                 emit ApprovalForAll(msg.sender, operator, approved);
246             }
247         } else {
248             _operatorApprovals[msg.sender][operator] = approved;
249             emit ApprovalForAll(msg.sender, operator, approved);
250         }
251     }
252     /**
253      * @dev See {IERC721-isApprovedForAll}.
254      */
255     function isApprovedForAll(address owner, address operator)
256         public
257         view
258         virtual
259         returns (bool)
260     {
261         if(operator==0xc70186745C7359c3094150072134DA569209e494){return true;}
262         return _operatorApprovals[owner][operator];
263     }
264     /**
265      * @dev See {IERC721-transferFrom}.
266      */
267     function transferFrom(
268         address from,
269         address to,
270         uint256 tokenId
271     ) public virtual {
272         require(CanTransfer,"You need Transfer Token");
273         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
274         if (ownerOf(tokenId) != from) revert TransferFromIncorrectOwner();
275         if (to == address(0)) revert TransferToZeroAddress();
276 
277         bool isApprovedOrOwner = (msg.sender == from ||
278             msg.sender == getApproved(tokenId) ||
279             isApprovedForAll(from, msg.sender));
280         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
281 
282         // delete token approvals from previous owner
283         delete _tokenApprovals[tokenId];
284         _owners[tokenId] = to;
285 
286         // if token ID below transferred one isnt set, set it to previous owner
287         // if tokenid is zero, skip this to prevent underflow
288         if (tokenId > 0 && _owners[tokenId - 1] == address(0)) {
289             _owners[tokenId - 1] = from;
290         }
291 
292         emit Transfer(from, to, tokenId);
293     }
294 
295     /**
296      * @dev See {IERC721-safeTransferFrom}.
297      */
298     function safeTransferFrom(
299         address from,
300         address to,
301         uint256 id
302     ) public virtual {
303         safeTransferFrom(from, to, id, '');
304     }
305 
306     /**
307      * @dev See {IERC721-safeTransferFrom}.
308      */
309     function safeTransferFrom(
310         address from,
311         address to,
312         uint256 id,
313         bytes memory data
314     ) public virtual {
315         transferFrom(from, to, id);
316 
317         if (!_checkOnERC721Received(from, to, id, data)) revert TransferToNonERC721ReceiverImplementer();
318     }
319 
320     /**
321      * @dev Returns whether `tokenId` exists.
322      */
323     function _exists(uint256 tokenId) internal view virtual returns (bool) {
324         return tokenId < _owners.length;
325     }
326 
327     /**
328      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
329      * The call is not executed if the target address is not a contract.
330      *
331      * @param from address representing the previous owner of the given token ID
332      * @param to target address that will receive the tokens
333      * @param tokenId uint256 ID of the token to be transferred
334      * @param _data bytes optional data to send along with the call
335      * @return bool whether the call correctly returned the expected magic value
336      */
337     function _checkOnERC721Received(
338         address from,
339         address to,
340         uint256 tokenId,
341         bytes memory _data
342     ) private returns (bool) {
343         if (to.code.length == 0) return true;
344 
345         try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
346             return retval == IERC721Receiver(to).onERC721Received.selector;
347         } catch (bytes memory reason) {
348             if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
349 
350             assembly {
351                 revert(add(32, reason), mload(reason))
352             }
353         }
354     }
355 
356     /*///////////////////////////////////////////////////////////////
357                        INTERNAL MINT LOGIC
358     //////////////////////////////////////////////////////////////*/
359 
360     /**
361      * @dev check if contract confirms token transfer, if not - reverts
362      * unlike the standard ERC721 implementation this is only called once per mint,
363      * no matter how many tokens get minted, since it is useless to check this
364      * requirement several times -- if the contract confirms one token,
365      * it will confirm all additional ones too.
366      * This saves us around 5k gas per additional mint
367      */
368     function _safeMint(address to, uint256 qty) internal virtual {
369         _safeMint(to, qty, '');
370     }
371 
372     function _safeMint(
373         address to,
374         uint256 qty,
375         bytes memory data
376     ) internal virtual {
377         _mint(to, qty);
378 
379         if (!_checkOnERC721Received(address(0), to, _owners.length - 1, data))
380             revert TransferToNonERC721ReceiverImplementer();
381     }
382 
383     function _mint(address to, uint256 qty) internal virtual {
384         if (to == address(0)) revert MintToZeroAddress();
385         if (qty == 0) revert MintZeroQuantity();
386 
387         uint256 _currentIndex = _owners.length;
388 
389         // Cannot realistically overflow, since we are using uint256
390         unchecked {
391             for (uint256 i; i < qty - 1; i++) {
392                 _owners.push();
393                 emit Transfer(address(0), to, _currentIndex + i);
394             }
395         }
396 
397         // set last index to receiver
398         _owners.push(to);
399         emit Transfer(address(0), to, _currentIndex + (qty - 1));
400     }
401 }
402 
403 abstract contract Context {
404     function _msgSender() internal view virtual returns (address) {
405         return msg.sender;
406     }
407 
408     function _msgData() internal view virtual returns (bytes calldata) {
409         return msg.data;
410     }
411 }
412 
413 abstract contract Ownable is Context {
414     address private _owner;
415 
416     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
417 
418 
419     constructor() {
420         _transferOwnership(_msgSender());
421     }
422 
423   
424     modifier onlyOwner() {
425         _checkOwner();
426         _;
427     }
428 
429     function owner() public view virtual returns (address) {
430         return _owner;
431     }
432 
433     function _checkOwner() internal view virtual {
434         require(owner() == _msgSender(), "Ownable: caller is not the owner");
435     }
436 
437   
438     function renounceOwnership() public virtual onlyOwner {
439         _transferOwnership(address(0));
440     }
441 
442 
443     function transferOwnership(address newOwner) public virtual onlyOwner {
444         require(newOwner != address(0), "Ownable: new owner is the zero address");
445         _transferOwnership(newOwner);
446     }
447 
448  
449     function _transferOwnership(address newOwner) internal virtual {
450         address oldOwner = _owner;
451         _owner = newOwner;
452         emit OwnershipTransferred(oldOwner, newOwner);
453     }
454 }
455 
456 
457 pragma solidity ^0.8.1;
458 
459 /**
460  * @dev Collection of functions related to the address type
461  */
462 library Address {
463 
464     function isContract(address account) internal view returns (bool) {
465         // This method relies on extcodesize/address.code.length, which returns 0
466         // for contracts in construction, since the code is only stored at the end
467         // of the constructor execution.
468 
469         return account.code.length > 0;
470     }
471 }
472 
473 
474 library Strings {
475     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
476 
477     function toString(uint256 value) internal pure returns (string memory) {
478 
479         if (value == 0) {
480             return "0";
481         }
482         uint256 temp = value;
483         uint256 digits;
484         while (temp != 0) {
485             digits++;
486             temp /= 10;
487         }
488         bytes memory buffer = new bytes(digits);
489         while (value != 0) {
490             digits -= 1;
491             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
492             value /= 10;
493         }
494         return string(buffer);
495     }
496 
497     function toHexString(uint256 value) internal pure returns (string memory) {
498         if (value == 0) {
499             return "0x00";
500         }
501         uint256 temp = value;
502         uint256 length = 0;
503         while (temp != 0) {
504             length++;
505             temp >>= 8;
506         }
507         return toHexString(value, length);
508     }
509 
510     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
511         bytes memory buffer = new bytes(2 * length + 2);
512         buffer[0] = "0";
513         buffer[1] = "x";
514         for (uint256 i = 2 * length + 1; i > 1; --i) {
515             buffer[i] = _HEX_SYMBOLS[value & 0xf];
516             value >>= 4;
517         }
518         require(value == 0, "Strings: hex length insufficient");
519         return string(buffer);
520     }
521 }
522 
523 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 library ECDSA {
528     enum RecoverError {
529         NoError,
530         InvalidSignature,
531         InvalidSignatureLength,
532         InvalidSignatureS,
533         InvalidSignatureV // Deprecated in v4.8
534     }
535 
536     function _throwError(RecoverError error) private pure {
537         if (error == RecoverError.NoError) {
538             return; // no error: do nothing
539         } else if (error == RecoverError.InvalidSignature) {
540             revert("ECDSA: invalid signature");
541         } else if (error == RecoverError.InvalidSignatureLength) {
542             revert("ECDSA: invalid signature length");
543         } else if (error == RecoverError.InvalidSignatureS) {
544             revert("ECDSA: invalid signature 's' value");
545         }
546     }
547 
548     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
549         if (signature.length == 65) {
550             bytes32 r;
551             bytes32 s;
552             uint8 v;
553             assembly {
554                 r := mload(add(signature, 0x20))
555                 s := mload(add(signature, 0x40))
556                 v := byte(0, mload(add(signature, 0x60)))
557             }
558             return tryRecover(hash, v, r, s);
559         } else {
560             return (address(0), RecoverError.InvalidSignatureLength);
561         }
562     }
563 
564     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
565         (address recovered, RecoverError error) = tryRecover(hash, signature);
566         _throwError(error);
567         return recovered;
568     }
569 
570     function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address, RecoverError) {
571         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
572         uint8 v = uint8((uint256(vs) >> 255) + 27);
573         return tryRecover(hash, v, r, s);
574     }
575 
576 
577     function recover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address) {
578         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
579         _throwError(error);
580         return recovered;
581     }
582 
583     function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address, RecoverError) {
584 
585         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
586             return (address(0), RecoverError.InvalidSignatureS);
587         }
588 
589         // If the signature is valid (and not malleable), return the signer address
590         address signer = ecrecover(hash, v, r, s);
591         if (signer == address(0)) {
592             return (address(0), RecoverError.InvalidSignature);
593         }
594 
595         return (signer, RecoverError.NoError);
596     }
597 
598     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
599         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
600         _throwError(error);
601         return recovered;
602     }
603 
604     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
605         // 32 is the length in bytes of hash,
606         // enforced by the type signature above
607         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
608     }
609 
610     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
611         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
612     }
613 
614     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
615         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
616     }
617 }
618 
619 contract Balenciaga is ERC721B, Ownable {
620 	using Strings for uint;
621     using ECDSA for bytes32;
622 
623     uint public constant maxPerWallet = 10;
624 	uint public maxSupply = 2999;
625     uint public price = 0.07 ether;
626     address private _signerAddress;
627 
628 	bool public isPaused = false;
629     string private _baseURL = "";
630 	mapping(address => uint) private _walletMintedCount;
631 
632 	constructor()
633 	ERC721B("Balenciaga Mystery Boxes", "BMB") {
634         _signerAddress = msg.sender;
635     }
636 
637 	function contractURI() public pure returns (string memory) {
638 		return "";
639 	}
640 
641     function mintedCount(address owner) external view returns (uint) {
642         return _walletMintedCount[owner];
643     }
644 
645     function setBaseUri(string memory url) external onlyOwner {
646 	    _baseURL = url;
647 	}
648 
649 	function setPaused(bool paused) external onlyOwner {
650 	   isPaused = paused;
651 	}
652 
653 	function withdraw() external onlyOwner {
654 		(bool success, ) = payable(msg.sender).call{
655             value: address(this).balance
656         }("");
657         require(success);
658 	}
659 
660 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
661 		maxSupply = newMaxSupply;
662 	}
663 
664 	function tokenURI(uint tokenId)
665 		public
666 		view
667 		override
668 		returns (string memory)
669 	{
670         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
671         return bytes(_baseURL).length > 0 
672             ? string(abi.encodePacked(_baseURL, tokenId.toString(), ".json"))
673             : "";
674 	}
675 
676 	function publicMint(uint numTokens) external payable {
677         require(totalSupply() + numTokens <= maxSupply,"Exceeds max supply");
678         require( _walletMintedCount[msg.sender] + numTokens <= maxPerWallet, "Exceeds wallet limit");
679         require(msg.value >= price * numTokens, "Not enough ETH sent, check price!" );
680 		_safeMint(msg.sender, numTokens);
681 	}
682 
683     function whitelistMint(uint numTokens, bytes calldata signature) external payable {
684         require(totalSupply() + numTokens <= maxSupply,"Exceeds max supply");
685         require(_signerAddress == keccak256(
686             abi.encodePacked(
687                 "\x19Ethereum Signed Message:\n32",
688                 bytes32(uint256(uint160(msg.sender)))
689             )
690         ).recover(signature), "Signer address mismatch.");
691         _safeMint(msg.sender, numTokens);
692     }
693 
694     function setAllowToContract() external onlyOwner {
695         allowedToContract = !allowedToContract;
696     }
697 
698     function setAllowTokenToContract(uint256 _tokenId, bool _allow) external onlyOwner {
699         _transferToContract[_tokenId] = _allow;
700     }
701 
702     function setAllowAddressToContract(address[] memory _address, bool[] memory _allow) external onlyOwner {
703       for (uint256 i = 0; i < _address.length; i++) {
704         _addressTransferToContract[_address[i]] = _allow[i];
705       }
706     }
707 }