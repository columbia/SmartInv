1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * Utility library of inline functions on addresses
69  */
70 library Address {
71     /**
72      * Returns whether the target address is a contract
73      * @dev This function will return false if invoked during the constructor of a contract,
74      * as the code is not actually created until after the constructor finishes.
75      * @param account address of the account to check
76      * @return whether the target address is a contract
77      */
78     function isContract(address account) internal view returns (bool) {
79         uint256 size;
80         // XXX Currently there is no better way to check if there is a contract in an address
81         // than to check the size of the code at that address.
82         // See https://ethereum.stackexchange.com/a/14016/36603
83         // for more details about how this works.
84         // TODO Check this again before the Serenity release, because all addresses will be
85         // contracts then.
86         // solhint-disable-next-line no-inline-assembly
87         assembly { size := extcodesize(account) }
88         return size > 0;
89     }
90 }
91 
92 library Strings {
93   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
94   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
95       bytes memory _ba = bytes(_a);
96       bytes memory _bb = bytes(_b);
97       bytes memory _bc = bytes(_c);
98       bytes memory _bd = bytes(_d);
99       bytes memory _be = bytes(_e);
100       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
101       bytes memory babcde = bytes(abcde);
102       uint k = 0;
103       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
104       for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
105       for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
106       for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
107       for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
108       return string(babcde);
109     }
110 
111     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
112         return strConcat(_a, _b, _c, _d, "");
113     }
114 
115     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
116         return strConcat(_a, _b, _c, "", "");
117     }
118 
119     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
120         return strConcat(_a, _b, "", "", "");
121     }
122 
123     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
124         if (_i == 0) {
125             return "0";
126         }
127         uint j = _i;
128         uint len;
129         while (j != 0) {
130             len++;
131             j /= 10;
132         }
133         bytes memory bstr = new bytes(len);
134         uint k = len - 1;
135         while (_i != 0) {
136             bstr[k--] = byte(uint8(48 + _i % 10));
137             _i /= 10;
138         }
139         return string(bstr);
140     }
141 }
142 
143 /**
144  * @title Ownable
145  * @dev The Ownable contract has an owner address, and provides basic authorization control
146  * functions, this simplifies the implementation of "user permissions".
147  */
148 contract Ownable {
149     address private _owner;
150 
151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153     /**
154      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155      * account.
156      */
157     constructor () internal {
158         _owner = msg.sender;
159         emit OwnershipTransferred(address(0), _owner);
160     }
161 
162     /**
163      * @return the address of the owner.
164      */
165     function owner() public view returns (address) {
166         return _owner;
167     }
168 
169     /**
170      * @dev Throws if called by any account other than the owner.
171      */
172     modifier onlyOwner() {
173         require(isOwner());
174         _;
175     }
176 
177     /**
178      * @return true if `msg.sender` is the owner of the contract.
179      */
180     function isOwner() public view returns (bool) {
181         return msg.sender == _owner;
182     }
183 
184     /**
185      * @dev Allows the current owner to relinquish control of the contract.
186      * @notice Renouncing to ownership will leave the contract without an owner.
187      * It will not be possible to call the functions with the `onlyOwner`
188      * modifier anymore.
189      */
190     function renounceOwnership() public onlyOwner {
191         emit OwnershipTransferred(_owner, address(0));
192         _owner = address(0);
193     }
194 
195     /**
196      * @dev Allows the current owner to transfer control of the contract to a newOwner.
197      * @param newOwner The address to transfer ownership to.
198      */
199     function transferOwnership(address newOwner) public onlyOwner {
200         _transferOwnership(newOwner);
201     }
202 
203     /**
204      * @dev Transfers control of the contract to a newOwner.
205      * @param newOwner The address to transfer ownership to.
206      */
207     function _transferOwnership(address newOwner) internal {
208         require(newOwner != address(0));
209         emit OwnershipTransferred(_owner, newOwner);
210         _owner = newOwner;
211     }
212 }
213 
214 /**
215  * @title IERC165
216  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
217  */
218 interface IERC165 {
219     /**
220      * @notice Query if a contract implements an interface
221      * @param interfaceId The interface identifier, as specified in ERC-165
222      * @dev Interface identification is specified in ERC-165. This function
223      * uses less than 30,000 gas.
224      */
225     function supportsInterface(bytes4 interfaceId) external view returns (bool);
226 }
227 
228 /**
229  * @title ERC165
230  * @author Matt Condon (@shrugs)
231  * @dev Implements ERC165 using a lookup table.
232  */
233 contract ERC165 is IERC165 {
234     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
235     /**
236      * 0x01ffc9a7 ===
237      *     bytes4(keccak256('supportsInterface(bytes4)'))
238      */
239 
240     /**
241      * @dev a mapping of interface id to whether or not it's supported
242      */
243     mapping(bytes4 => bool) private _supportedInterfaces;
244 
245     /**
246      * @dev A contract implementing SupportsInterfaceWithLookup
247      * implement ERC165 itself
248      */
249     constructor () internal {
250         _registerInterface(_INTERFACE_ID_ERC165);
251     }
252 
253     /**
254      * @dev implement supportsInterface(bytes4) using a lookup table
255      */
256     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
257         return _supportedInterfaces[interfaceId];
258     }
259 
260     /**
261      * @dev internal method for registering an interface
262      */
263     function _registerInterface(bytes4 interfaceId) internal {
264         require(interfaceId != 0xffffffff);
265         _supportedInterfaces[interfaceId] = true;
266     }
267 }
268 
269 /**
270  * @title ERC721 Non-Fungible Token Standard basic interface
271  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
272  */
273 contract IERC721 is IERC165 {
274     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
275     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
276     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
277 
278     function balanceOf(address owner) public view returns (uint256 balance);
279     function ownerOf(uint256 tokenId) public view returns (address owner);
280 
281     function approve(address to, uint256 tokenId) public;
282     function getApproved(uint256 tokenId) public view returns (address operator);
283 
284     function setApprovalForAll(address operator, bool _approved) public;
285     function isApprovedForAll(address owner, address operator) public view returns (bool);
286 
287     function transferFrom(address from, address to, uint256 tokenId) public;
288     function safeTransferFrom(address from, address to, uint256 tokenId) public;
289 
290     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
291 }
292 
293 /**
294  * @title ERC721 token receiver interface
295  * @dev Interface for any contract that wants to support safeTransfers
296  * from ERC721 asset contracts.
297  */
298 contract IERC721Receiver {
299     /**
300      * @notice Handle the receipt of an NFT
301      * @dev The ERC721 smart contract calls this function on the recipient
302      * after a `safeTransfer`. This function MUST return the function selector,
303      * otherwise the caller will revert the transaction. The selector to be
304      * returned can be obtained as `this.onERC721Received.selector`. This
305      * function MAY throw to revert and reject the transfer.
306      * Note: the ERC721 contract address is always the message sender.
307      * @param operator The address which called `safeTransferFrom` function
308      * @param from The address which previously owned the token
309      * @param tokenId The NFT identifier which is being transferred
310      * @param data Additional data with no specified format
311      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
312      */
313     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
314     public returns (bytes4);
315 }
316 
317 /**
318  * @title ERC721 Non-Fungible Token Standard basic implementation
319  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
320  */
321 contract ERC721 is ERC165, IERC721 {
322     using SafeMath for uint256;
323     using Address for address;
324 
325     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
326     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
327     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
328 
329     // Mapping from token ID to owner
330     mapping (uint256 => address) private _tokenOwner;
331 
332     // Mapping from token ID to approved address
333     mapping (uint256 => address) private _tokenApprovals;
334 
335     // Mapping from owner to number of owned token
336     mapping (address => uint256) private _ownedTokensCount;
337 
338     // Mapping from owner to operator approvals
339     mapping (address => mapping (address => bool)) private _operatorApprovals;
340 
341     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
342     /*
343      * 0x80ac58cd ===
344      *     bytes4(keccak256('balanceOf(address)')) ^
345      *     bytes4(keccak256('ownerOf(uint256)')) ^
346      *     bytes4(keccak256('approve(address,uint256)')) ^
347      *     bytes4(keccak256('getApproved(uint256)')) ^
348      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
349      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
350      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
351      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
352      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
353      */
354 
355     constructor () public {
356         // register the supported interfaces to conform to ERC721 via ERC165
357         _registerInterface(_INTERFACE_ID_ERC721);
358     }
359 
360     /**
361      * @dev Gets the balance of the specified address
362      * @param owner address to query the balance of
363      * @return uint256 representing the amount owned by the passed address
364      */
365     function balanceOf(address owner) public view returns (uint256) {
366         require(owner != address(0));
367         return _ownedTokensCount[owner];
368     }
369 
370     /**
371      * @dev Gets the owner of the specified token ID
372      * @param tokenId uint256 ID of the token to query the owner of
373      * @return owner address currently marked as the owner of the given token ID
374      */
375     function ownerOf(uint256 tokenId) public view returns (address) {
376         address owner = _tokenOwner[tokenId];
377         require(owner != address(0));
378         return owner;
379     }
380 
381     /**
382      * @dev Approves another address to transfer the given token ID
383      * The zero address indicates there is no approved address.
384      * There can only be one approved address per token at a given time.
385      * Can only be called by the token owner or an approved operator.
386      * @param to address to be approved for the given token ID
387      * @param tokenId uint256 ID of the token to be approved
388      */
389     function approve(address to, uint256 tokenId) public {
390         address owner = ownerOf(tokenId);
391         require(to != owner);
392         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
393 
394         _tokenApprovals[tokenId] = to;
395         emit Approval(owner, to, tokenId);
396     }
397 
398     /**
399      * @dev Gets the approved address for a token ID, or zero if no address set
400      * Reverts if the token ID does not exist.
401      * @param tokenId uint256 ID of the token to query the approval of
402      * @return address currently approved for the given token ID
403      */
404     function getApproved(uint256 tokenId) public view returns (address) {
405         require(_exists(tokenId));
406         return _tokenApprovals[tokenId];
407     }
408 
409     /**
410      * @dev Sets or unsets the approval of a given operator
411      * An operator is allowed to transfer all tokens of the sender on their behalf
412      * @param to operator address to set the approval
413      * @param approved representing the status of the approval to be set
414      */
415     function setApprovalForAll(address to, bool approved) public {
416         require(to != msg.sender);
417         _operatorApprovals[msg.sender][to] = approved;
418         emit ApprovalForAll(msg.sender, to, approved);
419     }
420 
421     /**
422      * @dev Tells whether an operator is approved by a given owner
423      * @param owner owner address which you want to query the approval of
424      * @param operator operator address which you want to query the approval of
425      * @return bool whether the given operator is approved by the given owner
426      */
427     function isApprovedForAll(address owner, address operator) public view returns (bool) {
428         return _operatorApprovals[owner][operator];
429     }
430 
431     /**
432      * @dev Transfers the ownership of a given token ID to another address
433      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
434      * Requires the msg sender to be the owner, approved, or operator
435      * @param from current owner of the token
436      * @param to address to receive the ownership of the given token ID
437      * @param tokenId uint256 ID of the token to be transferred
438     */
439     function transferFrom(address from, address to, uint256 tokenId) public {
440         require(_isApprovedOrOwner(msg.sender, tokenId));
441 
442         _transferFrom(from, to, tokenId);
443     }
444 
445     /**
446      * @dev Safely transfers the ownership of a given token ID to another address
447      * If the target address is a contract, it must implement `onERC721Received`,
448      * which is called upon a safe transfer, and return the magic value
449      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
450      * the transfer is reverted.
451      *
452      * Requires the msg sender to be the owner, approved, or operator
453      * @param from current owner of the token
454      * @param to address to receive the ownership of the given token ID
455      * @param tokenId uint256 ID of the token to be transferred
456     */
457     function safeTransferFrom(address from, address to, uint256 tokenId) public {
458         safeTransferFrom(from, to, tokenId, "");
459     }
460 
461     /**
462      * @dev Safely transfers the ownership of a given token ID to another address
463      * If the target address is a contract, it must implement `onERC721Received`,
464      * which is called upon a safe transfer, and return the magic value
465      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
466      * the transfer is reverted.
467      * Requires the msg sender to be the owner, approved, or operator
468      * @param from current owner of the token
469      * @param to address to receive the ownership of the given token ID
470      * @param tokenId uint256 ID of the token to be transferred
471      * @param _data bytes data to send along with a safe transfer check
472      */
473     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
474         transferFrom(from, to, tokenId);
475         require(_checkOnERC721Received(from, to, tokenId, _data));
476     }
477 
478     /**
479      * @dev Returns whether the specified token exists
480      * @param tokenId uint256 ID of the token to query the existence of
481      * @return whether the token exists
482      */
483     function _exists(uint256 tokenId) internal view returns (bool) {
484         address owner = _tokenOwner[tokenId];
485         return owner != address(0);
486     }
487 
488     /**
489      * @dev Returns whether the given spender can transfer a given token ID
490      * @param spender address of the spender to query
491      * @param tokenId uint256 ID of the token to be transferred
492      * @return bool whether the msg.sender is approved for the given token ID,
493      *    is an operator of the owner, or is the owner of the token
494      */
495     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
496         address owner = ownerOf(tokenId);
497         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
498     }
499 
500     /**
501      * @dev Internal function to mint a new token
502      * Reverts if the given token ID already exists
503      * @param to The address that will own the minted token
504      * @param tokenId uint256 ID of the token to be minted
505      */
506     function _mint(address to, uint256 tokenId) internal {
507         require(to != address(0));
508         require(!_exists(tokenId));
509 
510         _tokenOwner[tokenId] = to;
511         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
512 
513         emit Transfer(address(0), to, tokenId);
514     }
515 
516     /**
517      * @dev Internal function to burn a specific token
518      * Reverts if the token does not exist
519      * Deprecated, use _burn(uint256) instead.
520      * @param owner owner of the token to burn
521      * @param tokenId uint256 ID of the token being burned
522      */
523     function _burn(address owner, uint256 tokenId) internal {
524         require(ownerOf(tokenId) == owner);
525 
526         _clearApproval(tokenId);
527 
528         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
529         _tokenOwner[tokenId] = address(0);
530 
531         emit Transfer(owner, address(0), tokenId);
532     }
533 
534     /**
535      * @dev Internal function to burn a specific token
536      * Reverts if the token does not exist
537      * @param tokenId uint256 ID of the token being burned
538      */
539     function _burn(uint256 tokenId) internal {
540         _burn(ownerOf(tokenId), tokenId);
541     }
542 
543     /**
544      * @dev Internal function to transfer ownership of a given token ID to another address.
545      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
546      * @param from current owner of the token
547      * @param to address to receive the ownership of the given token ID
548      * @param tokenId uint256 ID of the token to be transferred
549     */
550     function _transferFrom(address from, address to, uint256 tokenId) internal {
551         require(ownerOf(tokenId) == from);
552         require(to != address(0));
553 
554         _clearApproval(tokenId);
555 
556         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
557         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
558 
559         _tokenOwner[tokenId] = to;
560 
561         emit Transfer(from, to, tokenId);
562     }
563 
564     /**
565      * @dev Internal function to invoke `onERC721Received` on a target address
566      * The call is not executed if the target address is not a contract
567      * @param from address representing the previous owner of the given token ID
568      * @param to target address that will receive the tokens
569      * @param tokenId uint256 ID of the token to be transferred
570      * @param _data bytes optional data to send along with the call
571      * @return whether the call correctly returned the expected magic value
572      */
573     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
574         internal returns (bool)
575     {
576         if (!to.isContract()) {
577             return true;
578         }
579 
580         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
581         return (retval == _ERC721_RECEIVED);
582     }
583 
584     /**
585      * @dev Private function to clear current approval of a given token ID
586      * @param tokenId uint256 ID of the token to be transferred
587      */
588     function _clearApproval(uint256 tokenId) private {
589         if (_tokenApprovals[tokenId] != address(0)) {
590             _tokenApprovals[tokenId] = address(0);
591         }
592     }
593 }
594 
595 /**
596  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
597  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
598  */
599 contract IERC721Enumerable is IERC721 {
600     function totalSupply() public view returns (uint256);
601     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
602 
603     function tokenByIndex(uint256 index) public view returns (uint256);
604 }
605 
606 /**
607  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
608  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
609  */
610 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
611     // Mapping from owner to list of owned token IDs
612     mapping(address => uint256[]) private _ownedTokens;
613 
614     // Mapping from token ID to index of the owner tokens list
615     mapping(uint256 => uint256) private _ownedTokensIndex;
616 
617     // Array with all token ids, used for enumeration
618     uint256[] private _allTokens;
619 
620     // Mapping from token id to position in the allTokens array
621     mapping(uint256 => uint256) private _allTokensIndex;
622 
623     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
624     /**
625      * 0x780e9d63 ===
626      *     bytes4(keccak256('totalSupply()')) ^
627      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
628      *     bytes4(keccak256('tokenByIndex(uint256)'))
629      */
630 
631     /**
632      * @dev Constructor function
633      */
634     constructor () public {
635         // register the supported interface to conform to ERC721 via ERC165
636         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
637     }
638 
639     /**
640      * @dev Gets the token ID at a given index of the tokens list of the requested owner
641      * @param owner address owning the tokens list to be accessed
642      * @param index uint256 representing the index to be accessed of the requested tokens list
643      * @return uint256 token ID at the given index of the tokens list owned by the requested address
644      */
645     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
646         require(index < balanceOf(owner));
647         return _ownedTokens[owner][index];
648     }
649 
650     /**
651      * @dev Gets the total amount of tokens stored by the contract
652      * @return uint256 representing the total amount of tokens
653      */
654     function totalSupply() public view returns (uint256) {
655         return _allTokens.length;
656     }
657 
658     /**
659      * @dev Gets the token ID at a given index of all the tokens in this contract
660      * Reverts if the index is greater or equal to the total number of tokens
661      * @param index uint256 representing the index to be accessed of the tokens list
662      * @return uint256 token ID at the given index of the tokens list
663      */
664     function tokenByIndex(uint256 index) public view returns (uint256) {
665         require(index < totalSupply());
666         return _allTokens[index];
667     }
668 
669     /**
670      * @dev Internal function to transfer ownership of a given token ID to another address.
671      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
672      * @param from current owner of the token
673      * @param to address to receive the ownership of the given token ID
674      * @param tokenId uint256 ID of the token to be transferred
675     */
676     function _transferFrom(address from, address to, uint256 tokenId) internal {
677         super._transferFrom(from, to, tokenId);
678 
679         _removeTokenFromOwnerEnumeration(from, tokenId);
680 
681         _addTokenToOwnerEnumeration(to, tokenId);
682     }
683 
684     /**
685      * @dev Internal function to mint a new token
686      * Reverts if the given token ID already exists
687      * @param to address the beneficiary that will own the minted token
688      * @param tokenId uint256 ID of the token to be minted
689      */
690     function _mint(address to, uint256 tokenId) internal {
691         super._mint(to, tokenId);
692 
693         _addTokenToOwnerEnumeration(to, tokenId);
694 
695         _addTokenToAllTokensEnumeration(tokenId);
696     }
697 
698     /**
699      * @dev Internal function to burn a specific token
700      * Reverts if the token does not exist
701      * Deprecated, use _burn(uint256) instead
702      * @param owner owner of the token to burn
703      * @param tokenId uint256 ID of the token being burned
704      */
705     function _burn(address owner, uint256 tokenId) internal {
706         super._burn(owner, tokenId);
707 
708         _removeTokenFromOwnerEnumeration(owner, tokenId);
709         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
710         _ownedTokensIndex[tokenId] = 0;
711 
712         _removeTokenFromAllTokensEnumeration(tokenId);
713     }
714 
715     /**
716      * @dev Gets the list of token IDs of the requested owner
717      * @param owner address owning the tokens
718      * @return uint256[] List of token IDs owned by the requested address
719      */
720     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
721         return _ownedTokens[owner];
722     }
723 
724     /**
725      * @dev Private function to add a token to this extension's ownership-tracking data structures.
726      * @param to address representing the new owner of the given token ID
727      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
728      */
729     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
730         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
731         _ownedTokens[to].push(tokenId);
732     }
733 
734     /**
735      * @dev Private function to add a token to this extension's token tracking data structures.
736      * @param tokenId uint256 ID of the token to be added to the tokens list
737      */
738     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
739         _allTokensIndex[tokenId] = _allTokens.length;
740         _allTokens.push(tokenId);
741     }
742 
743     /**
744      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
745      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
746      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
747      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
748      * @param from address representing the previous owner of the given token ID
749      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
750      */
751     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
752         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
753         // then delete the last slot (swap and pop).
754 
755         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
756         uint256 tokenIndex = _ownedTokensIndex[tokenId];
757 
758         // When the token to delete is the last token, the swap operation is unnecessary
759         if (tokenIndex != lastTokenIndex) {
760             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
761 
762             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
763             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
764         }
765 
766         // This also deletes the contents at the last position of the array
767         _ownedTokens[from].length--;
768 
769         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
770         // lasTokenId, or just over the end of the array if the token was the last one).
771     }
772 
773     /**
774      * @dev Private function to remove a token from this extension's token tracking data structures.
775      * This has O(1) time complexity, but alters the order of the _allTokens array.
776      * @param tokenId uint256 ID of the token to be removed from the tokens list
777      */
778     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
779         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
780         // then delete the last slot (swap and pop).
781 
782         uint256 lastTokenIndex = _allTokens.length.sub(1);
783         uint256 tokenIndex = _allTokensIndex[tokenId];
784 
785         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
786         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
787         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
788         uint256 lastTokenId = _allTokens[lastTokenIndex];
789 
790         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
791         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
792 
793         // This also deletes the contents at the last position of the array
794         _allTokens.length--;
795         _allTokensIndex[tokenId] = 0;
796     }
797 }
798 
799 /**
800  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
801  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
802  */
803 contract IERC721Metadata is IERC721 {
804     function name() external view returns (string memory);
805     function symbol() external view returns (string memory);
806     function tokenURI(uint256 tokenId) external view returns (string memory);
807 }
808 
809 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
810     // Token name
811     string private _name;
812 
813     // Token symbol
814     string private _symbol;
815 
816     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
817     /**
818      * 0x5b5e139f ===
819      *     bytes4(keccak256('name()')) ^
820      *     bytes4(keccak256('symbol()')) ^
821      *     bytes4(keccak256('tokenURI(uint256)'))
822      */
823 
824     /**
825      * @dev Constructor function
826      */
827     constructor (string memory name, string memory symbol) public {
828         _name = name;
829         _symbol = symbol;
830 
831         // register the supported interfaces to conform to ERC721 via ERC165
832         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
833     }
834 
835     /**
836      * @dev Gets the token name
837      * @return string representing the token name
838      */
839     function name() external view returns (string memory) {
840         return _name;
841     }
842 
843     /**
844      * @dev Gets the token symbol
845      * @return string representing the token symbol
846      */
847     function symbol() external view returns (string memory) {
848         return _symbol;
849     }
850 }
851 
852 /**
853  * @title Full ERC721 Token
854  * This implementation includes all the required and some optional functionality of the ERC721 standard
855  * Moreover, it includes approve all functionality using operator terminology
856  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
857  */
858 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
859     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
860         // solhint-disable-previous-line no-empty-blocks
861     }
862 }
863 
864 contract OwnableDelegateProxy { }
865 
866 contract ProxyRegistry {
867     mapping(address => OwnableDelegateProxy) public proxies;
868 }
869 
870 /**
871  * @title TradeableERC721Token
872  * TradeableERC721Token - ERC721 contract that whitelists a trading address, and has minting functionality.
873  */
874 contract EZNFT is ERC721Full, Ownable {
875   using Strings for string;
876 
877   address proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
878 
879   constructor() ERC721Full("EZNFT", "EZNFT") public {
880       // solhint-disable-previous-line no-empty-blocks
881   }
882 
883   /**
884     * @dev Mints a token to an address with a tokenURI.
885     * @param _to address of the future owner of the token
886     */
887   function mintTo(address _to) public {
888     uint256 newTokenId = _getNextTokenId();
889     _mint(_to, newTokenId);
890   }
891 
892   /**
893     * @dev calculates the next token ID based on totalSupply
894     * @return uint256 for the next token ID
895     */
896   function _getNextTokenId() private view returns (uint256) {
897     return totalSupply().add(1);
898   }
899 
900   function baseTokenURI() public pure returns (string memory) {
901     return "https://eznft-metadata.etherzaar.com/v1/token/";
902   }
903 
904   function tokenURI(uint256 _tokenId) external view returns (string memory) {
905     return Strings.strConcat(
906         baseTokenURI(),
907         Strings.uint2str(_tokenId)
908     );
909   }
910 
911   /**
912    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
913    */
914   function isApprovedForAll(
915     address owner,
916     address operator
917   )
918     public
919     view
920     returns (bool)
921   {
922     // Whitelist OpenSea proxy contract for easy trading.
923     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
924     if (address(proxyRegistry.proxies(owner)) == operator) {
925         return true;
926     }
927 
928     return super.isApprovedForAll(owner, operator);
929   }
930 }