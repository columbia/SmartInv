1 // File: contracts/Strings.sol
2 
3 pragma solidity 0.5.00;
4 
5 library Strings {
6   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol MIT licence
7   
8   function Concatenate(string memory a, string memory b) public pure returns (string memory concatenatedString) {
9     bytes memory bytesA = bytes(a);
10     bytes memory bytesB = bytes(b);
11     string memory concatenatedAB = new string(bytesA.length + bytesB.length);
12     bytes memory bytesAB = bytes(concatenatedAB);
13     uint concatendatedIndex = 0;
14     uint index = 0;
15     for (index = 0; index < bytesA.length; index++) {
16       bytesAB[concatendatedIndex++] = bytesA[index];
17     }
18     for (index = 0; index < bytesB.length; index++) {
19       bytesAB[concatendatedIndex++] = bytesB[index];
20     }
21       
22     return string(bytesAB);
23   }
24 
25   function UintToString(uint value) public pure returns (string memory uintAsString) {
26     uint tempValue = value;
27     
28     if (tempValue == 0) {
29       return "0";
30     }
31     uint j = tempValue;
32     uint length;
33     while (j != 0) {
34       length++;
35       j /= 10;
36     }
37     bytes memory byteString = new bytes(length);
38     uint index = length - 1;
39     while (tempValue != 0) {
40       byteString[index--] = byte(uint8(48 + tempValue % 10));
41       tempValue /= 10;
42     }
43     return string(byteString);
44   }
45 }
46 
47 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
48 
49 pragma solidity ^0.5.0;
50 
51 /**
52  * @title IERC165
53  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
54  */
55 interface IERC165 {
56     /**
57      * @notice Query if a contract implements an interface
58      * @param interfaceId The interface identifier, as specified in ERC-165
59      * @dev Interface identification is specified in ERC-165. This function
60      * uses less than 30,000 gas.
61      */
62     function supportsInterface(bytes4 interfaceId) external view returns (bool);
63 }
64 
65 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
66 
67 pragma solidity ^0.5.0;
68 
69 
70 /**
71  * @title ERC721 Non-Fungible Token Standard basic interface
72  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
73  */
74 contract IERC721 is IERC165 {
75     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
76     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
77     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
78 
79     function balanceOf(address owner) public view returns (uint256 balance);
80     function ownerOf(uint256 tokenId) public view returns (address owner);
81 
82     function approve(address to, uint256 tokenId) public;
83     function getApproved(uint256 tokenId) public view returns (address operator);
84 
85     function setApprovalForAll(address operator, bool _approved) public;
86     function isApprovedForAll(address owner, address operator) public view returns (bool);
87 
88     function transferFrom(address from, address to, uint256 tokenId) public;
89     function safeTransferFrom(address from, address to, uint256 tokenId) public;
90 
91     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
92 }
93 
94 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
95 
96 pragma solidity ^0.5.0;
97 
98 /**
99  * @title ERC721 token receiver interface
100  * @dev Interface for any contract that wants to support safeTransfers
101  * from ERC721 asset contracts.
102  */
103 contract IERC721Receiver {
104     /**
105      * @notice Handle the receipt of an NFT
106      * @dev The ERC721 smart contract calls this function on the recipient
107      * after a `safeTransfer`. This function MUST return the function selector,
108      * otherwise the caller will revert the transaction. The selector to be
109      * returned can be obtained as `this.onERC721Received.selector`. This
110      * function MAY throw to revert and reject the transfer.
111      * Note: the ERC721 contract address is always the message sender.
112      * @param operator The address which called `safeTransferFrom` function
113      * @param from The address which previously owned the token
114      * @param tokenId The NFT identifier which is being transferred
115      * @param data Additional data with no specified format
116      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
117      */
118     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
119     public returns (bytes4);
120 }
121 
122 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
123 
124 pragma solidity ^0.5.0;
125 
126 /**
127  * @title SafeMath
128  * @dev Unsigned math operations with safety checks that revert on error
129  */
130 library SafeMath {
131     /**
132     * @dev Multiplies two unsigned integers, reverts on overflow.
133     */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.
137         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
138         if (a == 0) {
139             return 0;
140         }
141 
142         uint256 c = a * b;
143         require(c / a == b);
144 
145         return c;
146     }
147 
148     /**
149     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
150     */
151     function div(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Solidity only automatically asserts when dividing by 0
153         require(b > 0);
154         uint256 c = a / b;
155         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
156 
157         return c;
158     }
159 
160     /**
161     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
162     */
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         require(b <= a);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171     * @dev Adds two unsigned integers, reverts on overflow.
172     */
173     function add(uint256 a, uint256 b) internal pure returns (uint256) {
174         uint256 c = a + b;
175         require(c >= a);
176 
177         return c;
178     }
179 
180     /**
181     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
182     * reverts when dividing by zero.
183     */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b != 0);
186         return a % b;
187     }
188 }
189 
190 // File: openzeppelin-solidity/contracts/utils/Address.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /**
195  * Utility library of inline functions on addresses
196  */
197 library Address {
198     /**
199      * Returns whether the target address is a contract
200      * @dev This function will return false if invoked during the constructor of a contract,
201      * as the code is not actually created until after the constructor finishes.
202      * @param account address of the account to check
203      * @return whether the target address is a contract
204      */
205     function isContract(address account) internal view returns (bool) {
206         uint256 size;
207         // XXX Currently there is no better way to check if there is a contract in an address
208         // than to check the size of the code at that address.
209         // See https://ethereum.stackexchange.com/a/14016/36603
210         // for more details about how this works.
211         // TODO Check this again before the Serenity release, because all addresses will be
212         // contracts then.
213         // solhint-disable-next-line no-inline-assembly
214         assembly { size := extcodesize(account) }
215         return size > 0;
216     }
217 }
218 
219 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
220 
221 pragma solidity ^0.5.0;
222 
223 
224 /**
225  * @title ERC165
226  * @author Matt Condon (@shrugs)
227  * @dev Implements ERC165 using a lookup table.
228  */
229 contract ERC165 is IERC165 {
230     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
231     /**
232      * 0x01ffc9a7 ===
233      *     bytes4(keccak256('supportsInterface(bytes4)'))
234      */
235 
236     /**
237      * @dev a mapping of interface id to whether or not it's supported
238      */
239     mapping(bytes4 => bool) private _supportedInterfaces;
240 
241     /**
242      * @dev A contract implementing SupportsInterfaceWithLookup
243      * implement ERC165 itself
244      */
245     constructor () internal {
246         _registerInterface(_INTERFACE_ID_ERC165);
247     }
248 
249     /**
250      * @dev implement supportsInterface(bytes4) using a lookup table
251      */
252     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
253         return _supportedInterfaces[interfaceId];
254     }
255 
256     /**
257      * @dev internal method for registering an interface
258      */
259     function _registerInterface(bytes4 interfaceId) internal {
260         require(interfaceId != 0xffffffff);
261         _supportedInterfaces[interfaceId] = true;
262     }
263 }
264 
265 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
266 
267 pragma solidity ^0.5.0;
268 
269 
270 
271 
272 
273 
274 /**
275  * @title ERC721 Non-Fungible Token Standard basic implementation
276  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
277  */
278 contract ERC721 is ERC165, IERC721 {
279     using SafeMath for uint256;
280     using Address for address;
281 
282     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
283     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
284     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
285 
286     // Mapping from token ID to owner
287     mapping (uint256 => address) private _tokenOwner;
288 
289     // Mapping from token ID to approved address
290     mapping (uint256 => address) private _tokenApprovals;
291 
292     // Mapping from owner to number of owned token
293     mapping (address => uint256) private _ownedTokensCount;
294 
295     // Mapping from owner to operator approvals
296     mapping (address => mapping (address => bool)) private _operatorApprovals;
297 
298     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
299     /*
300      * 0x80ac58cd ===
301      *     bytes4(keccak256('balanceOf(address)')) ^
302      *     bytes4(keccak256('ownerOf(uint256)')) ^
303      *     bytes4(keccak256('approve(address,uint256)')) ^
304      *     bytes4(keccak256('getApproved(uint256)')) ^
305      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
306      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
307      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
308      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
309      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
310      */
311 
312     constructor () public {
313         // register the supported interfaces to conform to ERC721 via ERC165
314         _registerInterface(_INTERFACE_ID_ERC721);
315     }
316 
317     /**
318      * @dev Gets the balance of the specified address
319      * @param owner address to query the balance of
320      * @return uint256 representing the amount owned by the passed address
321      */
322     function balanceOf(address owner) public view returns (uint256) {
323         require(owner != address(0));
324         return _ownedTokensCount[owner];
325     }
326 
327     /**
328      * @dev Gets the owner of the specified token ID
329      * @param tokenId uint256 ID of the token to query the owner of
330      * @return owner address currently marked as the owner of the given token ID
331      */
332     function ownerOf(uint256 tokenId) public view returns (address) {
333         address owner = _tokenOwner[tokenId];
334         require(owner != address(0));
335         return owner;
336     }
337 
338     /**
339      * @dev Approves another address to transfer the given token ID
340      * The zero address indicates there is no approved address.
341      * There can only be one approved address per token at a given time.
342      * Can only be called by the token owner or an approved operator.
343      * @param to address to be approved for the given token ID
344      * @param tokenId uint256 ID of the token to be approved
345      */
346     function approve(address to, uint256 tokenId) public {
347         address owner = ownerOf(tokenId);
348         require(to != owner);
349         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
350 
351         _tokenApprovals[tokenId] = to;
352         emit Approval(owner, to, tokenId);
353     }
354 
355     /**
356      * @dev Gets the approved address for a token ID, or zero if no address set
357      * Reverts if the token ID does not exist.
358      * @param tokenId uint256 ID of the token to query the approval of
359      * @return address currently approved for the given token ID
360      */
361     function getApproved(uint256 tokenId) public view returns (address) {
362         require(_exists(tokenId));
363         return _tokenApprovals[tokenId];
364     }
365 
366     /**
367      * @dev Sets or unsets the approval of a given operator
368      * An operator is allowed to transfer all tokens of the sender on their behalf
369      * @param to operator address to set the approval
370      * @param approved representing the status of the approval to be set
371      */
372     function setApprovalForAll(address to, bool approved) public {
373         require(to != msg.sender);
374         _operatorApprovals[msg.sender][to] = approved;
375         emit ApprovalForAll(msg.sender, to, approved);
376     }
377 
378     /**
379      * @dev Tells whether an operator is approved by a given owner
380      * @param owner owner address which you want to query the approval of
381      * @param operator operator address which you want to query the approval of
382      * @return bool whether the given operator is approved by the given owner
383      */
384     function isApprovedForAll(address owner, address operator) public view returns (bool) {
385         return _operatorApprovals[owner][operator];
386     }
387 
388     /**
389      * @dev Transfers the ownership of a given token ID to another address
390      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
391      * Requires the msg sender to be the owner, approved, or operator
392      * @param from current owner of the token
393      * @param to address to receive the ownership of the given token ID
394      * @param tokenId uint256 ID of the token to be transferred
395     */
396     function transferFrom(address from, address to, uint256 tokenId) public {
397         require(_isApprovedOrOwner(msg.sender, tokenId));
398 
399         _transferFrom(from, to, tokenId);
400     }
401 
402     /**
403      * @dev Safely transfers the ownership of a given token ID to another address
404      * If the target address is a contract, it must implement `onERC721Received`,
405      * which is called upon a safe transfer, and return the magic value
406      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
407      * the transfer is reverted.
408      *
409      * Requires the msg sender to be the owner, approved, or operator
410      * @param from current owner of the token
411      * @param to address to receive the ownership of the given token ID
412      * @param tokenId uint256 ID of the token to be transferred
413     */
414     function safeTransferFrom(address from, address to, uint256 tokenId) public {
415         safeTransferFrom(from, to, tokenId, "");
416     }
417 
418     /**
419      * @dev Safely transfers the ownership of a given token ID to another address
420      * If the target address is a contract, it must implement `onERC721Received`,
421      * which is called upon a safe transfer, and return the magic value
422      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
423      * the transfer is reverted.
424      * Requires the msg sender to be the owner, approved, or operator
425      * @param from current owner of the token
426      * @param to address to receive the ownership of the given token ID
427      * @param tokenId uint256 ID of the token to be transferred
428      * @param _data bytes data to send along with a safe transfer check
429      */
430     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
431         transferFrom(from, to, tokenId);
432         require(_checkOnERC721Received(from, to, tokenId, _data));
433     }
434 
435     /**
436      * @dev Returns whether the specified token exists
437      * @param tokenId uint256 ID of the token to query the existence of
438      * @return whether the token exists
439      */
440     function _exists(uint256 tokenId) internal view returns (bool) {
441         address owner = _tokenOwner[tokenId];
442         return owner != address(0);
443     }
444 
445     /**
446      * @dev Returns whether the given spender can transfer a given token ID
447      * @param spender address of the spender to query
448      * @param tokenId uint256 ID of the token to be transferred
449      * @return bool whether the msg.sender is approved for the given token ID,
450      *    is an operator of the owner, or is the owner of the token
451      */
452     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
453         address owner = ownerOf(tokenId);
454         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
455     }
456 
457     /**
458      * @dev Internal function to mint a new token
459      * Reverts if the given token ID already exists
460      * @param to The address that will own the minted token
461      * @param tokenId uint256 ID of the token to be minted
462      */
463     function _mint(address to, uint256 tokenId) internal {
464         require(to != address(0));
465         require(!_exists(tokenId));
466 
467         _tokenOwner[tokenId] = to;
468         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
469 
470         emit Transfer(address(0), to, tokenId);
471     }
472 
473     /**
474      * @dev Internal function to burn a specific token
475      * Reverts if the token does not exist
476      * Deprecated, use _burn(uint256) instead.
477      * @param owner owner of the token to burn
478      * @param tokenId uint256 ID of the token being burned
479      */
480     function _burn(address owner, uint256 tokenId) internal {
481         require(ownerOf(tokenId) == owner);
482 
483         _clearApproval(tokenId);
484 
485         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
486         _tokenOwner[tokenId] = address(0);
487 
488         emit Transfer(owner, address(0), tokenId);
489     }
490 
491     /**
492      * @dev Internal function to burn a specific token
493      * Reverts if the token does not exist
494      * @param tokenId uint256 ID of the token being burned
495      */
496     function _burn(uint256 tokenId) internal {
497         _burn(ownerOf(tokenId), tokenId);
498     }
499 
500     /**
501      * @dev Internal function to transfer ownership of a given token ID to another address.
502      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
503      * @param from current owner of the token
504      * @param to address to receive the ownership of the given token ID
505      * @param tokenId uint256 ID of the token to be transferred
506     */
507     function _transferFrom(address from, address to, uint256 tokenId) internal {
508         require(ownerOf(tokenId) == from);
509         require(to != address(0));
510 
511         _clearApproval(tokenId);
512 
513         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
514         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
515 
516         _tokenOwner[tokenId] = to;
517 
518         emit Transfer(from, to, tokenId);
519     }
520 
521     /**
522      * @dev Internal function to invoke `onERC721Received` on a target address
523      * The call is not executed if the target address is not a contract
524      * @param from address representing the previous owner of the given token ID
525      * @param to target address that will receive the tokens
526      * @param tokenId uint256 ID of the token to be transferred
527      * @param _data bytes optional data to send along with the call
528      * @return whether the call correctly returned the expected magic value
529      */
530     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
531         internal returns (bool)
532     {
533         if (!to.isContract()) {
534             return true;
535         }
536 
537         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
538         return (retval == _ERC721_RECEIVED);
539     }
540 
541     /**
542      * @dev Private function to clear current approval of a given token ID
543      * @param tokenId uint256 ID of the token to be transferred
544      */
545     function _clearApproval(uint256 tokenId) private {
546         if (_tokenApprovals[tokenId] != address(0)) {
547             _tokenApprovals[tokenId] = address(0);
548         }
549     }
550 }
551 
552 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
553 
554 pragma solidity ^0.5.0;
555 
556 
557 /**
558  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
559  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
560  */
561 contract IERC721Enumerable is IERC721 {
562     function totalSupply() public view returns (uint256);
563     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
564 
565     function tokenByIndex(uint256 index) public view returns (uint256);
566 }
567 
568 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
569 
570 pragma solidity ^0.5.0;
571 
572 
573 
574 
575 /**
576  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
577  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
578  */
579 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
580     // Mapping from owner to list of owned token IDs
581     mapping(address => uint256[]) private _ownedTokens;
582 
583     // Mapping from token ID to index of the owner tokens list
584     mapping(uint256 => uint256) private _ownedTokensIndex;
585 
586     // Array with all token ids, used for enumeration
587     uint256[] private _allTokens;
588 
589     // Mapping from token id to position in the allTokens array
590     mapping(uint256 => uint256) private _allTokensIndex;
591 
592     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
593     /**
594      * 0x780e9d63 ===
595      *     bytes4(keccak256('totalSupply()')) ^
596      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
597      *     bytes4(keccak256('tokenByIndex(uint256)'))
598      */
599 
600     /**
601      * @dev Constructor function
602      */
603     constructor () public {
604         // register the supported interface to conform to ERC721 via ERC165
605         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
606     }
607 
608     /**
609      * @dev Gets the token ID at a given index of the tokens list of the requested owner
610      * @param owner address owning the tokens list to be accessed
611      * @param index uint256 representing the index to be accessed of the requested tokens list
612      * @return uint256 token ID at the given index of the tokens list owned by the requested address
613      */
614     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
615         require(index < balanceOf(owner));
616         return _ownedTokens[owner][index];
617     }
618 
619     /**
620      * @dev Gets the total amount of tokens stored by the contract
621      * @return uint256 representing the total amount of tokens
622      */
623     function totalSupply() public view returns (uint256) {
624         return _allTokens.length;
625     }
626 
627     /**
628      * @dev Gets the token ID at a given index of all the tokens in this contract
629      * Reverts if the index is greater or equal to the total number of tokens
630      * @param index uint256 representing the index to be accessed of the tokens list
631      * @return uint256 token ID at the given index of the tokens list
632      */
633     function tokenByIndex(uint256 index) public view returns (uint256) {
634         require(index < totalSupply());
635         return _allTokens[index];
636     }
637 
638     /**
639      * @dev Internal function to transfer ownership of a given token ID to another address.
640      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
641      * @param from current owner of the token
642      * @param to address to receive the ownership of the given token ID
643      * @param tokenId uint256 ID of the token to be transferred
644     */
645     function _transferFrom(address from, address to, uint256 tokenId) internal {
646         super._transferFrom(from, to, tokenId);
647 
648         _removeTokenFromOwnerEnumeration(from, tokenId);
649 
650         _addTokenToOwnerEnumeration(to, tokenId);
651     }
652 
653     /**
654      * @dev Internal function to mint a new token
655      * Reverts if the given token ID already exists
656      * @param to address the beneficiary that will own the minted token
657      * @param tokenId uint256 ID of the token to be minted
658      */
659     function _mint(address to, uint256 tokenId) internal {
660         super._mint(to, tokenId);
661 
662         _addTokenToOwnerEnumeration(to, tokenId);
663 
664         _addTokenToAllTokensEnumeration(tokenId);
665     }
666 
667     /**
668      * @dev Internal function to burn a specific token
669      * Reverts if the token does not exist
670      * Deprecated, use _burn(uint256) instead
671      * @param owner owner of the token to burn
672      * @param tokenId uint256 ID of the token being burned
673      */
674     function _burn(address owner, uint256 tokenId) internal {
675         super._burn(owner, tokenId);
676 
677         _removeTokenFromOwnerEnumeration(owner, tokenId);
678         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
679         _ownedTokensIndex[tokenId] = 0;
680 
681         _removeTokenFromAllTokensEnumeration(tokenId);
682     }
683 
684     /**
685      * @dev Gets the list of token IDs of the requested owner
686      * @param owner address owning the tokens
687      * @return uint256[] List of token IDs owned by the requested address
688      */
689     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
690         return _ownedTokens[owner];
691     }
692 
693     /**
694      * @dev Private function to add a token to this extension's ownership-tracking data structures.
695      * @param to address representing the new owner of the given token ID
696      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
697      */
698     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
699         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
700         _ownedTokens[to].push(tokenId);
701     }
702 
703     /**
704      * @dev Private function to add a token to this extension's token tracking data structures.
705      * @param tokenId uint256 ID of the token to be added to the tokens list
706      */
707     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
708         _allTokensIndex[tokenId] = _allTokens.length;
709         _allTokens.push(tokenId);
710     }
711 
712     /**
713      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
714      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
715      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
716      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
717      * @param from address representing the previous owner of the given token ID
718      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
719      */
720     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
721         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
722         // then delete the last slot (swap and pop).
723 
724         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
725         uint256 tokenIndex = _ownedTokensIndex[tokenId];
726 
727         // When the token to delete is the last token, the swap operation is unnecessary
728         if (tokenIndex != lastTokenIndex) {
729             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
730 
731             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
732             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
733         }
734 
735         // This also deletes the contents at the last position of the array
736         _ownedTokens[from].length--;
737 
738         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
739         // lasTokenId, or just over the end of the array if the token was the last one).
740     }
741 
742     /**
743      * @dev Private function to remove a token from this extension's token tracking data structures.
744      * This has O(1) time complexity, but alters the order of the _allTokens array.
745      * @param tokenId uint256 ID of the token to be removed from the tokens list
746      */
747     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
748         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
749         // then delete the last slot (swap and pop).
750 
751         uint256 lastTokenIndex = _allTokens.length.sub(1);
752         uint256 tokenIndex = _allTokensIndex[tokenId];
753 
754         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
755         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
756         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
757         uint256 lastTokenId = _allTokens[lastTokenIndex];
758 
759         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
760         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
761 
762         // This also deletes the contents at the last position of the array
763         _allTokens.length--;
764         _allTokensIndex[tokenId] = 0;
765     }
766 }
767 
768 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
769 
770 pragma solidity ^0.5.0;
771 
772 
773 /**
774  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
775  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
776  */
777 contract IERC721Metadata is IERC721 {
778     function name() external view returns (string memory);
779     function symbol() external view returns (string memory);
780     function tokenURI(uint256 tokenId) external view returns (string memory);
781 }
782 
783 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
784 
785 pragma solidity ^0.5.0;
786 
787 
788 
789 
790 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
791     // Token name
792     string private _name;
793 
794     // Token symbol
795     string private _symbol;
796 
797     // Optional mapping for token URIs
798     mapping(uint256 => string) private _tokenURIs;
799 
800     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
801     /**
802      * 0x5b5e139f ===
803      *     bytes4(keccak256('name()')) ^
804      *     bytes4(keccak256('symbol()')) ^
805      *     bytes4(keccak256('tokenURI(uint256)'))
806      */
807 
808     /**
809      * @dev Constructor function
810      */
811     constructor (string memory name, string memory symbol) public {
812         _name = name;
813         _symbol = symbol;
814 
815         // register the supported interfaces to conform to ERC721 via ERC165
816         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
817     }
818 
819     /**
820      * @dev Gets the token name
821      * @return string representing the token name
822      */
823     function name() external view returns (string memory) {
824         return _name;
825     }
826 
827     /**
828      * @dev Gets the token symbol
829      * @return string representing the token symbol
830      */
831     function symbol() external view returns (string memory) {
832         return _symbol;
833     }
834 
835     /**
836      * @dev Returns an URI for a given token ID
837      * Throws if the token ID does not exist. May return an empty string.
838      * @param tokenId uint256 ID of the token to query
839      */
840     function tokenURI(uint256 tokenId) external view returns (string memory) {
841         require(_exists(tokenId));
842         return _tokenURIs[tokenId];
843     }
844 
845     /**
846      * @dev Internal function to set the token URI for a given token
847      * Reverts if the token ID does not exist
848      * @param tokenId uint256 ID of the token to set its URI
849      * @param uri string URI to assign
850      */
851     function _setTokenURI(uint256 tokenId, string memory uri) internal {
852         require(_exists(tokenId));
853         _tokenURIs[tokenId] = uri;
854     }
855 
856     /**
857      * @dev Internal function to burn a specific token
858      * Reverts if the token does not exist
859      * Deprecated, use _burn(uint256) instead
860      * @param owner owner of the token to burn
861      * @param tokenId uint256 ID of the token being burned by the msg.sender
862      */
863     function _burn(address owner, uint256 tokenId) internal {
864         super._burn(owner, tokenId);
865 
866         // Clear metadata (if any)
867         if (bytes(_tokenURIs[tokenId]).length != 0) {
868             delete _tokenURIs[tokenId];
869         }
870     }
871 }
872 
873 // File: openzeppelin-solidity/contracts/access/Roles.sol
874 
875 pragma solidity ^0.5.0;
876 
877 /**
878  * @title Roles
879  * @dev Library for managing addresses assigned to a Role.
880  */
881 library Roles {
882     struct Role {
883         mapping (address => bool) bearer;
884     }
885 
886     /**
887      * @dev give an account access to this role
888      */
889     function add(Role storage role, address account) internal {
890         require(account != address(0));
891         require(!has(role, account));
892 
893         role.bearer[account] = true;
894     }
895 
896     /**
897      * @dev remove an account's access to this role
898      */
899     function remove(Role storage role, address account) internal {
900         require(account != address(0));
901         require(has(role, account));
902 
903         role.bearer[account] = false;
904     }
905 
906     /**
907      * @dev check if an account has this role
908      * @return bool
909      */
910     function has(Role storage role, address account) internal view returns (bool) {
911         require(account != address(0));
912         return role.bearer[account];
913     }
914 }
915 
916 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
917 
918 pragma solidity ^0.5.0;
919 
920 
921 contract MinterRole {
922     using Roles for Roles.Role;
923 
924     event MinterAdded(address indexed account);
925     event MinterRemoved(address indexed account);
926 
927     Roles.Role private _minters;
928 
929     constructor () internal {
930         _addMinter(msg.sender);
931     }
932 
933     modifier onlyMinter() {
934         require(isMinter(msg.sender));
935         _;
936     }
937 
938     function isMinter(address account) public view returns (bool) {
939         return _minters.has(account);
940     }
941 
942     function addMinter(address account) public onlyMinter {
943         _addMinter(account);
944     }
945 
946     function renounceMinter() public {
947         _removeMinter(msg.sender);
948     }
949 
950     function _addMinter(address account) internal {
951         _minters.add(account);
952         emit MinterAdded(account);
953     }
954 
955     function _removeMinter(address account) internal {
956         _minters.remove(account);
957         emit MinterRemoved(account);
958     }
959 }
960 
961 // File: contracts/BlockHorses.sol
962 
963 pragma solidity 0.5.00;
964 
965 
966 
967 
968 
969 
970 
971 /**
972  * @title Full ERC721 Token
973  * This implementation includes all the required and some optional functionality of the ERC721 standard
974  * Moreover, it includes approve all functionality using operator terminology
975  * @dev see https://github.c/ethereum/EIPs/blob/master/EIPS/eip-721.md
976  */
977 contract BlockHorses is ERC165, ERC721, ERC721Enumerable, IERC721Metadata, MinterRole {
978 
979   // Token name
980   string private _name;
981 
982   // Token symbol
983   string private _symbol;
984 
985   bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
986   /*
987    * 0x5b5e139f ===
988    *     bytes4(keccak256('name()')) ^
989    *     bytes4(keccak256('symbol()')) ^
990    *     bytes4(keccak256('tokenURI(uint256)'))
991    */
992 
993   /**
994    * @dev Constructor function
995    */
996   constructor () public {
997     _name = "BlockHorses";
998     _symbol = "HORSE";
999 
1000     // register the supported interfaces to conform to ERC721 via ERC165
1001     _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1002   }
1003 
1004   /**
1005    * @dev Gets the token name
1006    * @return string representing the token name
1007    */
1008   function name() external view returns (string memory) {
1009     return _name;
1010   }
1011 
1012   /**
1013    * @dev Gets the token symbol
1014    * @return string representing the token symbol
1015    */
1016   function symbol() external view returns (string memory) {
1017     return _symbol;
1018   }
1019 
1020   /**
1021    * @dev Returns an URI for a given token ID
1022    * Throws if the token ID does not exist. May return an empty string.
1023    * @param tokenId uint256 ID of the token to query
1024    */
1025   function tokenURI(uint256 tokenId) external view returns (string memory) {
1026     require(_exists(tokenId));
1027     return Strings.Concatenate(
1028       baseTokenURI(),
1029       Strings.UintToString(tokenId)
1030     );
1031   }
1032     
1033   /**
1034    * @dev Gets the base token URI
1035    * @return string representing the base token URI
1036    */
1037   function baseTokenURI() public pure returns (string memory) {
1038     return "https://blockhorses.github.io/BlockHorses/api/horse/";
1039   }
1040 
1041   /**
1042    * @dev Function to mint tokens
1043    * @param to The address that will receive the minted tokens.
1044    * @return A boolean that indicates if the operation was successful.
1045    */
1046   function mint(address to) public onlyMinter returns (bool) {
1047     uint256 tokenId = _getNextTokenId();
1048     _mint(to, tokenId);
1049     return true;
1050   }
1051 
1052   /**
1053    * @dev Gets the next Token ID (sequential)
1054    * @return next Token ID
1055    */
1056   function _getNextTokenId() private view returns (uint256) {
1057     return totalSupply().add(1);
1058   }
1059 }