1 pragma solidity ^0.4.24;
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
94     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
95         bytes memory _ba = bytes(_a);
96         bytes memory _bb = bytes(_b);
97         bytes memory _bc = bytes(_c);
98         bytes memory _bd = bytes(_d);
99         bytes memory _be = bytes(_e);
100         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
101         bytes memory babcde = bytes(abcde);
102         uint k = 0;
103         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
104         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
105         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
106         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
107         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
108         return string(babcde);
109     }
110 
111     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
112         return strConcat(_a, _b, _c, _d, "");
113     }
114 
115     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
116         return strConcat(_a, _b, _c, "", "");
117     }
118 
119     function strConcat(string _a, string _b) internal pure returns (string) {
120         return strConcat(_a, _b, "", "", "");
121     }
122 
123     function uint2str(uint i) internal pure returns (string) {
124         if (i == 0) return "0";
125         uint j = i;
126         uint len;
127         while (j != 0){
128             len++;
129             j /= 10;
130         }
131         bytes memory bstr = new bytes(len);
132         uint k = len - 1;
133         while (i != 0){
134             bstr[k--] = byte(48 + i % 10);
135             i /= 10;
136         }
137         return string(bstr);
138     }
139 }
140 
141 /**
142  * @title Ownable
143  * @dev The Ownable contract has an owner address, and provides basic authorization control
144  * functions, this simplifies the implementation of "user permissions".
145  */
146 contract Ownable {
147     address private _owner;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151     /**
152      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
153      * account.
154      */
155     constructor () internal {
156         _owner = msg.sender;
157         emit OwnershipTransferred(address(0), _owner);
158     }
159 
160     /**
161      * @return the address of the owner.
162      */
163     function owner() public view returns (address) {
164         return _owner;
165     }
166 
167     /**
168      * @dev Throws if called by any account other than the owner.
169      */
170     modifier onlyOwner() {
171         require(isOwner());
172         _;
173     }
174 
175     /**
176      * @return true if `msg.sender` is the owner of the contract.
177      */
178     function isOwner() public view returns (bool) {
179         return msg.sender == _owner;
180     }
181 
182     /**
183      * @dev Allows the current owner to relinquish control of the contract.
184      * @notice Renouncing to ownership will leave the contract without an owner.
185      * It will not be possible to call the functions with the `onlyOwner`
186      * modifier anymore.
187      */
188     function renounceOwnership() public onlyOwner {
189         emit OwnershipTransferred(_owner, address(0));
190         _owner = address(0);
191     }
192 
193     /**
194      * @dev Allows the current owner to transfer control of the contract to a newOwner.
195      * @param newOwner The address to transfer ownership to.
196      */
197     function transferOwnership(address newOwner) public onlyOwner {
198         _transferOwnership(newOwner);
199     }
200 
201     /**
202      * @dev Transfers control of the contract to a newOwner.
203      * @param newOwner The address to transfer ownership to.
204      */
205     function _transferOwnership(address newOwner) internal {
206         require(newOwner != address(0));
207         emit OwnershipTransferred(_owner, newOwner);
208         _owner = newOwner;
209     }
210 }
211 
212 /**
213  * @title IERC165
214  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
215  */
216 interface IERC165 {
217     /**
218      * @notice Query if a contract implements an interface
219      * @param interfaceId The interface identifier, as specified in ERC-165
220      * @dev Interface identification is specified in ERC-165. This function
221      * uses less than 30,000 gas.
222      */
223     function supportsInterface(bytes4 interfaceId) external view returns (bool);
224 }
225 
226 /**
227  * @title ERC165
228  * @author Matt Condon (@shrugs)
229  * @dev Implements ERC165 using a lookup table.
230  */
231 contract ERC165 is IERC165 {
232     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
233     /**
234      * 0x01ffc9a7 ===
235      *     bytes4(keccak256('supportsInterface(bytes4)'))
236      */
237 
238     /**
239      * @dev a mapping of interface id to whether or not it's supported
240      */
241     mapping(bytes4 => bool) private _supportedInterfaces;
242 
243     /**
244      * @dev A contract implementing SupportsInterfaceWithLookup
245      * implement ERC165 itself
246      */
247     constructor () internal {
248         _registerInterface(_INTERFACE_ID_ERC165);
249     }
250 
251     /**
252      * @dev implement supportsInterface(bytes4) using a lookup table
253      */
254     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
255         return _supportedInterfaces[interfaceId];
256     }
257 
258     /**
259      * @dev internal method for registering an interface
260      */
261     function _registerInterface(bytes4 interfaceId) internal {
262         require(interfaceId != 0xffffffff);
263         _supportedInterfaces[interfaceId] = true;
264     }
265 }
266 
267 /**
268  * @title ERC721 Non-Fungible Token Standard basic interface
269  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
270  */
271 contract IERC721 is IERC165 {
272     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
273     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
274     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
275 
276     function balanceOf(address owner) public view returns (uint256 balance);
277     function ownerOf(uint256 tokenId) public view returns (address owner);
278 
279     function approve(address to, uint256 tokenId) public;
280     function getApproved(uint256 tokenId) public view returns (address operator);
281 
282     function setApprovalForAll(address operator, bool _approved) public;
283     function isApprovedForAll(address owner, address operator) public view returns (bool);
284 
285     function transferFrom(address from, address to, uint256 tokenId) public;
286     function safeTransferFrom(address from, address to, uint256 tokenId) public;
287 
288     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
289 }
290 
291 /**
292  * @title ERC721 token receiver interface
293  * @dev Interface for any contract that wants to support safeTransfers
294  * from ERC721 asset contracts.
295  */
296 contract IERC721Receiver {
297     /**
298      * @notice Handle the receipt of an NFT
299      * @dev The ERC721 smart contract calls this function on the recipient
300      * after a `safeTransfer`. This function MUST return the function selector,
301      * otherwise the caller will revert the transaction. The selector to be
302      * returned can be obtained as `this.onERC721Received.selector`. This
303      * function MAY throw to revert and reject the transfer.
304      * Note: the ERC721 contract address is always the message sender.
305      * @param operator The address which called `safeTransferFrom` function
306      * @param from The address which previously owned the token
307      * @param tokenId The NFT identifier which is being transferred
308      * @param data Additional data with no specified format
309      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
310      */
311     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
312     public returns (bytes4);
313 }
314 
315 /**
316  * @title ERC721 Non-Fungible Token Standard basic implementation
317  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
318  */
319 contract ERC721 is ERC165, IERC721 {
320     using SafeMath for uint256;
321     using Address for address;
322 
323     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
324     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
325     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
326 
327     // Mapping from token ID to owner
328     mapping (uint256 => address) private _tokenOwner;
329 
330     // Mapping from token ID to approved address
331     mapping (uint256 => address) private _tokenApprovals;
332 
333     // Mapping from owner to number of owned token
334     mapping (address => uint256) private _ownedTokensCount;
335 
336     // Mapping from owner to operator approvals
337     mapping (address => mapping (address => bool)) private _operatorApprovals;
338 
339     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
340     /*
341      * 0x80ac58cd ===
342      *     bytes4(keccak256('balanceOf(address)')) ^
343      *     bytes4(keccak256('ownerOf(uint256)')) ^
344      *     bytes4(keccak256('approve(address,uint256)')) ^
345      *     bytes4(keccak256('getApproved(uint256)')) ^
346      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
347      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
348      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
349      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
350      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
351      */
352 
353     constructor () public {
354         // register the supported interfaces to conform to ERC721 via ERC165
355         _registerInterface(_INTERFACE_ID_ERC721);
356     }
357 
358     /**
359      * @dev Gets the balance of the specified address
360      * @param owner address to query the balance of
361      * @return uint256 representing the amount owned by the passed address
362      */
363     function balanceOf(address owner) public view returns (uint256) {
364         require(owner != address(0));
365         return _ownedTokensCount[owner];
366     }
367 
368     /**
369      * @dev Gets the owner of the specified token ID
370      * @param tokenId uint256 ID of the token to query the owner of
371      * @return owner address currently marked as the owner of the given token ID
372      */
373     function ownerOf(uint256 tokenId) public view returns (address) {
374         address owner = _tokenOwner[tokenId];
375         require(owner != address(0));
376         return owner;
377     }
378 
379     /**
380      * @dev Approves another address to transfer the given token ID
381      * The zero address indicates there is no approved address.
382      * There can only be one approved address per token at a given time.
383      * Can only be called by the token owner or an approved operator.
384      * @param to address to be approved for the given token ID
385      * @param tokenId uint256 ID of the token to be approved
386      */
387     function approve(address to, uint256 tokenId) public {
388         address owner = ownerOf(tokenId);
389         require(to != owner);
390         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
391 
392         _tokenApprovals[tokenId] = to;
393         emit Approval(owner, to, tokenId);
394     }
395 
396     /**
397      * @dev Gets the approved address for a token ID, or zero if no address set
398      * Reverts if the token ID does not exist.
399      * @param tokenId uint256 ID of the token to query the approval of
400      * @return address currently approved for the given token ID
401      */
402     function getApproved(uint256 tokenId) public view returns (address) {
403         require(_exists(tokenId));
404         return _tokenApprovals[tokenId];
405     }
406 
407     /**
408      * @dev Sets or unsets the approval of a given operator
409      * An operator is allowed to transfer all tokens of the sender on their behalf
410      * @param to operator address to set the approval
411      * @param approved representing the status of the approval to be set
412      */
413     function setApprovalForAll(address to, bool approved) public {
414         require(to != msg.sender);
415         _operatorApprovals[msg.sender][to] = approved;
416         emit ApprovalForAll(msg.sender, to, approved);
417     }
418 
419     /**
420      * @dev Tells whether an operator is approved by a given owner
421      * @param owner owner address which you want to query the approval of
422      * @param operator operator address which you want to query the approval of
423      * @return bool whether the given operator is approved by the given owner
424      */
425     function isApprovedForAll(address owner, address operator) public view returns (bool) {
426         return _operatorApprovals[owner][operator];
427     }
428 
429     /**
430      * @dev Transfers the ownership of a given token ID to another address
431      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
432      * Requires the msg sender to be the owner, approved, or operator
433      * @param from current owner of the token
434      * @param to address to receive the ownership of the given token ID
435      * @param tokenId uint256 ID of the token to be transferred
436     */
437     function transferFrom(address from, address to, uint256 tokenId) public {
438         require(_isApprovedOrOwner(msg.sender, tokenId));
439 
440         _transferFrom(from, to, tokenId);
441     }
442 
443     /**
444      * @dev Safely transfers the ownership of a given token ID to another address
445      * If the target address is a contract, it must implement `onERC721Received`,
446      * which is called upon a safe transfer, and return the magic value
447      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
448      * the transfer is reverted.
449      *
450      * Requires the msg sender to be the owner, approved, or operator
451      * @param from current owner of the token
452      * @param to address to receive the ownership of the given token ID
453      * @param tokenId uint256 ID of the token to be transferred
454     */
455     function safeTransferFrom(address from, address to, uint256 tokenId) public {
456         safeTransferFrom(from, to, tokenId, "");
457     }
458 
459     /**
460      * @dev Safely transfers the ownership of a given token ID to another address
461      * If the target address is a contract, it must implement `onERC721Received`,
462      * which is called upon a safe transfer, and return the magic value
463      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
464      * the transfer is reverted.
465      * Requires the msg sender to be the owner, approved, or operator
466      * @param from current owner of the token
467      * @param to address to receive the ownership of the given token ID
468      * @param tokenId uint256 ID of the token to be transferred
469      * @param _data bytes data to send along with a safe transfer check
470      */
471     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
472         transferFrom(from, to, tokenId);
473         require(_checkOnERC721Received(from, to, tokenId, _data));
474     }
475 
476     /**
477      * @dev Returns whether the specified token exists
478      * @param tokenId uint256 ID of the token to query the existence of
479      * @return whether the token exists
480      */
481     function _exists(uint256 tokenId) internal view returns (bool) {
482         address owner = _tokenOwner[tokenId];
483         return owner != address(0);
484     }
485 
486     /**
487      * @dev Returns whether the given spender can transfer a given token ID
488      * @param spender address of the spender to query
489      * @param tokenId uint256 ID of the token to be transferred
490      * @return bool whether the msg.sender is approved for the given token ID,
491      *    is an operator of the owner, or is the owner of the token
492      */
493     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
494         address owner = ownerOf(tokenId);
495         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
496     }
497 
498     /**
499      * @dev Internal function to mint a new token
500      * Reverts if the given token ID already exists
501      * @param to The address that will own the minted token
502      * @param tokenId uint256 ID of the token to be minted
503      */
504     function _mint(address to, uint256 tokenId) internal {
505         require(to != address(0));
506         require(!_exists(tokenId));
507 
508         _tokenOwner[tokenId] = to;
509         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
510 
511         emit Transfer(address(0), to, tokenId);
512     }
513 
514     /**
515      * @dev Internal function to burn a specific token
516      * Reverts if the token does not exist
517      * Deprecated, use _burn(uint256) instead.
518      * @param owner owner of the token to burn
519      * @param tokenId uint256 ID of the token being burned
520      */
521     function _burn(address owner, uint256 tokenId) internal {
522         require(ownerOf(tokenId) == owner);
523 
524         _clearApproval(tokenId);
525 
526         _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
527         _tokenOwner[tokenId] = address(0);
528 
529         emit Transfer(owner, address(0), tokenId);
530     }
531 
532     /**
533      * @dev Internal function to burn a specific token
534      * Reverts if the token does not exist
535      * @param tokenId uint256 ID of the token being burned
536      */
537     function _burn(uint256 tokenId) internal {
538         _burn(ownerOf(tokenId), tokenId);
539     }
540 
541     /**
542      * @dev Internal function to transfer ownership of a given token ID to another address.
543      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
544      * @param from current owner of the token
545      * @param to address to receive the ownership of the given token ID
546      * @param tokenId uint256 ID of the token to be transferred
547     */
548     function _transferFrom(address from, address to, uint256 tokenId) internal {
549         require(ownerOf(tokenId) == from);
550         require(to != address(0));
551 
552         _clearApproval(tokenId);
553 
554         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
555         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
556 
557         _tokenOwner[tokenId] = to;
558 
559         emit Transfer(from, to, tokenId);
560     }
561 
562     /**
563      * @dev Internal function to invoke `onERC721Received` on a target address
564      * The call is not executed if the target address is not a contract
565      * @param from address representing the previous owner of the given token ID
566      * @param to target address that will receive the tokens
567      * @param tokenId uint256 ID of the token to be transferred
568      * @param _data bytes optional data to send along with the call
569      * @return whether the call correctly returned the expected magic value
570      */
571     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
572         internal returns (bool)
573     {
574         if (!to.isContract()) {
575             return true;
576         }
577 
578         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
579         return (retval == _ERC721_RECEIVED);
580     }
581 
582     /**
583      * @dev Private function to clear current approval of a given token ID
584      * @param tokenId uint256 ID of the token to be transferred
585      */
586     function _clearApproval(uint256 tokenId) private {
587         if (_tokenApprovals[tokenId] != address(0)) {
588             _tokenApprovals[tokenId] = address(0);
589         }
590     }
591 }
592 
593 /**
594  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
595  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
596  */
597 contract IERC721Enumerable is IERC721 {
598     function totalSupply() public view returns (uint256);
599     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
600 
601     function tokenByIndex(uint256 index) public view returns (uint256);
602 }
603 
604 /**
605  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
606  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
607  */
608 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
609     // Mapping from owner to list of owned token IDs
610     mapping(address => uint256[]) private _ownedTokens;
611 
612     // Mapping from token ID to index of the owner tokens list
613     mapping(uint256 => uint256) private _ownedTokensIndex;
614 
615     // Array with all token ids, used for enumeration
616     uint256[] private _allTokens;
617 
618     // Mapping from token id to position in the allTokens array
619     mapping(uint256 => uint256) private _allTokensIndex;
620 
621     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
622     /**
623      * 0x780e9d63 ===
624      *     bytes4(keccak256('totalSupply()')) ^
625      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
626      *     bytes4(keccak256('tokenByIndex(uint256)'))
627      */
628 
629     /**
630      * @dev Constructor function
631      */
632     constructor () public {
633         // register the supported interface to conform to ERC721 via ERC165
634         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
635     }
636 
637     /**
638      * @dev Gets the token ID at a given index of the tokens list of the requested owner
639      * @param owner address owning the tokens list to be accessed
640      * @param index uint256 representing the index to be accessed of the requested tokens list
641      * @return uint256 token ID at the given index of the tokens list owned by the requested address
642      */
643     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
644         require(index < balanceOf(owner));
645         return _ownedTokens[owner][index];
646     }
647 
648     /**
649      * @dev Gets the total amount of tokens stored by the contract
650      * @return uint256 representing the total amount of tokens
651      */
652     function totalSupply() public view returns (uint256) {
653         return _allTokens.length;
654     }
655 
656     /**
657      * @dev Gets the token ID at a given index of all the tokens in this contract
658      * Reverts if the index is greater or equal to the total number of tokens
659      * @param index uint256 representing the index to be accessed of the tokens list
660      * @return uint256 token ID at the given index of the tokens list
661      */
662     function tokenByIndex(uint256 index) public view returns (uint256) {
663         require(index < totalSupply());
664         return _allTokens[index];
665     }
666 
667     /**
668      * @dev Internal function to transfer ownership of a given token ID to another address.
669      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
670      * @param from current owner of the token
671      * @param to address to receive the ownership of the given token ID
672      * @param tokenId uint256 ID of the token to be transferred
673     */
674     function _transferFrom(address from, address to, uint256 tokenId) internal {
675         super._transferFrom(from, to, tokenId);
676 
677         _removeTokenFromOwnerEnumeration(from, tokenId);
678 
679         _addTokenToOwnerEnumeration(to, tokenId);
680     }
681 
682     /**
683      * @dev Internal function to mint a new token
684      * Reverts if the given token ID already exists
685      * @param to address the beneficiary that will own the minted token
686      * @param tokenId uint256 ID of the token to be minted
687      */
688     function _mint(address to, uint256 tokenId) internal {
689         super._mint(to, tokenId);
690 
691         _addTokenToOwnerEnumeration(to, tokenId);
692 
693         _addTokenToAllTokensEnumeration(tokenId);
694     }
695 
696     /**
697      * @dev Internal function to burn a specific token
698      * Reverts if the token does not exist
699      * Deprecated, use _burn(uint256) instead
700      * @param owner owner of the token to burn
701      * @param tokenId uint256 ID of the token being burned
702      */
703     function _burn(address owner, uint256 tokenId) internal {
704         super._burn(owner, tokenId);
705 
706         _removeTokenFromOwnerEnumeration(owner, tokenId);
707         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
708         _ownedTokensIndex[tokenId] = 0;
709 
710         _removeTokenFromAllTokensEnumeration(tokenId);
711     }
712 
713     /**
714      * @dev Gets the list of token IDs of the requested owner
715      * @param owner address owning the tokens
716      * @return uint256[] List of token IDs owned by the requested address
717      */
718     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
719         return _ownedTokens[owner];
720     }
721 
722     /**
723      * @dev Private function to add a token to this extension's ownership-tracking data structures.
724      * @param to address representing the new owner of the given token ID
725      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
726      */
727     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
728         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
729         _ownedTokens[to].push(tokenId);
730     }
731 
732     /**
733      * @dev Private function to add a token to this extension's token tracking data structures.
734      * @param tokenId uint256 ID of the token to be added to the tokens list
735      */
736     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
737         _allTokensIndex[tokenId] = _allTokens.length;
738         _allTokens.push(tokenId);
739     }
740 
741     /**
742      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
743      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
744      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
745      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
746      * @param from address representing the previous owner of the given token ID
747      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
748      */
749     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
750         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
751         // then delete the last slot (swap and pop).
752 
753         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
754         uint256 tokenIndex = _ownedTokensIndex[tokenId];
755 
756         // When the token to delete is the last token, the swap operation is unnecessary
757         if (tokenIndex != lastTokenIndex) {
758             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
759 
760             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
761             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
762         }
763 
764         // This also deletes the contents at the last position of the array
765         _ownedTokens[from].length--;
766 
767         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
768         // lasTokenId, or just over the end of the array if the token was the last one).
769     }
770 
771     /**
772      * @dev Private function to remove a token from this extension's token tracking data structures.
773      * This has O(1) time complexity, but alters the order of the _allTokens array.
774      * @param tokenId uint256 ID of the token to be removed from the tokens list
775      */
776     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
777         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
778         // then delete the last slot (swap and pop).
779 
780         uint256 lastTokenIndex = _allTokens.length.sub(1);
781         uint256 tokenIndex = _allTokensIndex[tokenId];
782 
783         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
784         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
785         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
786         uint256 lastTokenId = _allTokens[lastTokenIndex];
787 
788         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
789         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
790 
791         // This also deletes the contents at the last position of the array
792         _allTokens.length--;
793         _allTokensIndex[tokenId] = 0;
794     }
795 }
796 
797 /**
798  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
799  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
800  */
801 contract IERC721Metadata is IERC721 {
802     function name() external view returns (string memory);
803     function symbol() external view returns (string memory);
804     function tokenURI(uint256 tokenId) external view returns (string memory);
805 }
806 
807 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
808     // Token name
809     string private _name;
810 
811     // Token symbol
812     string private _symbol;
813 
814     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
815     /**
816      * 0x5b5e139f ===
817      *     bytes4(keccak256('name()')) ^
818      *     bytes4(keccak256('symbol()')) ^
819      *     bytes4(keccak256('tokenURI(uint256)'))
820      */
821 
822     /**
823      * @dev Constructor function
824      */
825     constructor (string memory name, string memory symbol) public {
826         _name = name;
827         _symbol = symbol;
828 
829         // register the supported interfaces to conform to ERC721 via ERC165
830         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
831     }
832 
833     /**
834      * @dev Gets the token name
835      * @return string representing the token name
836      */
837     function name() external view returns (string memory) {
838         return _name;
839     }
840 
841     /**
842      * @dev Gets the token symbol
843      * @return string representing the token symbol
844      */
845     function symbol() external view returns (string memory) {
846         return _symbol;
847     }
848 }
849 
850 /**
851  * @title Full ERC721 Token
852  * This implementation includes all the required and some optional functionality of the ERC721 standard
853  * Moreover, it includes approve all functionality using operator terminology
854  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
855  */
856 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
857     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
858         // solhint-disable-previous-line no-empty-blocks
859     }
860 }
861 
862 contract OwnableDelegateProxy { }
863 
864 contract ProxyRegistry {
865     mapping(address => OwnableDelegateProxy) public proxies;
866 }
867 
868 /**
869  * @title TradeableERC721Token
870  * TradeableERC721Token - ERC721 contract that whitelists a trading address, and has minting functionality.
871  */
872 contract TradeableERC721Token is ERC721Full, Ownable {
873   using Strings for string;
874 
875   // Token metadata uri
876   string private baseTokenURI;
877 
878   address proxyRegistryAddress;
879 
880   constructor(string memory _name, string memory _symbol, string memory _baseTokenURI, address _proxyRegistryAddress) ERC721Full(_name, _symbol) public {
881     baseTokenURI = _baseTokenURI;
882     proxyRegistryAddress = _proxyRegistryAddress;
883   }
884 
885   /**
886     * @dev Mints a token to an address with a tokenURI.
887     * @param _to address of the future owner of the token
888     */
889   function mintTo(address _to) public onlyOwner {
890     uint256 newTokenId = _getNextTokenId();
891     _mint(_to, newTokenId);
892   }
893 
894   function setBaseTokenURI(string _baseTokenURI) public onlyOwner {
895     baseTokenURI = _baseTokenURI;
896   }
897 
898   /**
899     * @dev calculates the next token ID based on totalSupply
900     * @return uint256 for the next token ID
901     */
902   function _getNextTokenId() private view returns (uint256) {
903     return totalSupply().add(1);
904   }
905 
906   function tokenURI(uint256 _tokenId) external view returns (string) {
907     return Strings.strConcat(
908         baseTokenURI,
909         Strings.uint2str(_tokenId)
910     );
911   }
912 
913   /**
914    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
915    */
916   function isApprovedForAll(
917     address owner,
918     address operator
919   )
920     public
921     view
922     returns (bool)
923   {
924     // Whitelist OpenSea proxy contract for easy trading.
925     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
926     if (proxyRegistry.proxies(owner) == operator) {
927         return true;
928     }
929 
930     return super.isApprovedForAll(owner, operator);
931   }
932 }
933 
934 contract ToonToken is TradeableERC721Token {
935   constructor() TradeableERC721Token("ToonToken", "Toon", "https://webcartoons-nl.herokuapp.com/toontoken/", 0xa5409ec958c83c3f309868babaca7c86dcb077c1) public {  }
936 }