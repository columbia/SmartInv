1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
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
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
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
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 
68 /**
69  * @title IERC165
70  * @dev https://eips.ethereum.org/EIPS/eip-165
71  */
72 interface IERC165 {
73     /**
74      * @notice Query if a contract implements an interface
75      * @param interfaceId The interface identifier, as specified in ERC-165
76      * @dev Interface identification is specified in ERC-165. This function
77      * uses less than 30,000 gas.
78      */
79     function supportsInterface(bytes4 interfaceId) external view returns (bool);
80 }
81 
82 
83 
84 
85 /**
86  * @title ERC165
87  * @author Matt Condon (@shrugs)
88  * @dev Implements ERC165 using a lookup table.
89  */
90 contract ERC165 is IERC165 {
91     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
92     /*
93      * 0x01ffc9a7 ===
94      *     bytes4(keccak256('supportsInterface(bytes4)'))
95      */
96 
97     /**
98      * @dev a mapping of interface id to whether or not it's supported
99      */
100     mapping(bytes4 => bool) private _supportedInterfaces;
101 
102     /**
103      * @dev A contract implementing SupportsInterfaceWithLookup
104      * implement ERC165 itself
105      */
106     constructor () internal {
107         _registerInterface(_INTERFACE_ID_ERC165);
108     }
109 
110     /**
111      * @dev implement supportsInterface(bytes4) using a lookup table
112      */
113     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
114         return _supportedInterfaces[interfaceId];
115     }
116 
117     /**
118      * @dev internal method for registering an interface
119      */
120     function _registerInterface(bytes4 interfaceId) internal {
121         require(interfaceId != 0xffffffff);
122         _supportedInterfaces[interfaceId] = true;
123     }
124 }
125 
126 
127 library Strings {
128     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
129     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
130         bytes memory _ba = bytes(_a);
131         bytes memory _bb = bytes(_b);
132         bytes memory _bc = bytes(_c);
133         bytes memory _bd = bytes(_d);
134         bytes memory _be = bytes(_e);
135         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
136         bytes memory babcde = bytes(abcde);
137         uint k = 0;
138         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
139         for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
140         for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
141         for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
142         for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
143         return string(babcde);
144     }
145 
146     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
147         return strConcat(_a, _b, _c, _d, "");
148     }
149 
150     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
151         return strConcat(_a, _b, _c, "", "");
152     }
153 
154     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
155         return strConcat(_a, _b, "", "", "");
156     }
157 
158     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
159         if (_i == 0) {
160             return "0";
161         }
162         uint j = _i;
163         uint len;
164         while (j != 0) {
165             len++;
166             j /= 10;
167         }
168         bytes memory bstr = new bytes(len);
169         uint k = len - 1;
170         while (_i != 0) {
171             bstr[k--] = byte(uint8(48 + _i % 10));
172             _i /= 10;
173         }
174         return string(bstr);
175     }
176 }
177 
178 
179 
180 
181 
182 
183 
184 
185 
186 
187 /**
188  * @title ERC721 Non-Fungible Token Standard basic interface
189  * @dev see https://eips.ethereum.org/EIPS/eip-721
190  */
191 contract IERC721 is IERC165 {
192     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
193     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
194     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
195 
196     function balanceOf(address owner) public view returns (uint256 balance);
197     function ownerOf(uint256 tokenId) public view returns (address owner);
198 
199     function approve(address to, uint256 tokenId) public;
200     function getApproved(uint256 tokenId) public view returns (address operator);
201 
202     function setApprovalForAll(address operator, bool _approved) public;
203     function isApprovedForAll(address owner, address operator) public view returns (bool);
204 
205     function transferFrom(address from, address to, uint256 tokenId) public;
206     function safeTransferFrom(address from, address to, uint256 tokenId) public;
207 
208     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
209 }
210 
211 
212 
213 /**
214  * @title ERC721 token receiver interface
215  * @dev Interface for any contract that wants to support safeTransfers
216  * from ERC721 asset contracts.
217  */
218 contract IERC721Receiver {
219     /**
220      * @notice Handle the receipt of an NFT
221      * @dev The ERC721 smart contract calls this function on the recipient
222      * after a `safeTransfer`. This function MUST return the function selector,
223      * otherwise the caller will revert the transaction. The selector to be
224      * returned can be obtained as `this.onERC721Received.selector`. This
225      * function MAY throw to revert and reject the transfer.
226      * Note: the ERC721 contract address is always the message sender.
227      * @param operator The address which called `safeTransferFrom` function
228      * @param from The address which previously owned the token
229      * @param tokenId The NFT identifier which is being transferred
230      * @param data Additional data with no specified format
231      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
232      */
233     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
234     public returns (bytes4);
235 }
236 
237 
238 
239 
240 /**
241  * Utility library of inline functions on addresses
242  */
243 library Address {
244     /**
245      * Returns whether the target address is a contract
246      * @dev This function will return false if invoked during the constructor of a contract,
247      * as the code is not actually created until after the constructor finishes.
248      * @param account address of the account to check
249      * @return whether the target address is a contract
250      */
251     function isContract(address account) internal view returns (bool) {
252         uint256 size;
253         // XXX Currently there is no better way to check if there is a contract in an address
254         // than to check the size of the code at that address.
255         // See https://ethereum.stackexchange.com/a/14016/36603
256         // for more details about how this works.
257         // TODO Check this again before the Serenity release, because all addresses will be
258         // contracts then.
259         // solhint-disable-next-line no-inline-assembly
260         assembly { size := extcodesize(account) }
261         return size > 0;
262     }
263 }
264 
265 
266 
267 
268 
269 /**
270  * @title Counters
271  * @author Matt Condon (@shrugs)
272  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
273  * of elements in a mapping, issuing ERC721 ids, or counting request ids
274  *
275  * Include with `using Counters for Counters.Counter;`
276  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
277  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
278  * directly accessed.
279  */
280 library Counters {
281     using SafeMath for uint256;
282 
283     struct Counter {
284         // This variable should never be directly accessed by users of the library: interactions must be restricted to
285         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
286         // this feature: see https://github.com/ethereum/solidity/issues/4637
287         uint256 _value; // default: 0
288     }
289 
290     function current(Counter storage counter) internal view returns (uint256) {
291         return counter._value;
292     }
293 
294     function increment(Counter storage counter) internal {
295         counter._value += 1;
296     }
297 
298     function decrement(Counter storage counter) internal {
299         counter._value = counter._value.sub(1);
300     }
301 }
302 
303 
304 
305 /**
306  * @title ERC721 Non-Fungible Token Standard basic implementation
307  * @dev see https://eips.ethereum.org/EIPS/eip-721
308  */
309 contract ERC721 is ERC165, IERC721 {
310     using SafeMath for uint256;
311     using Address for address;
312     using Counters for Counters.Counter;
313 
314     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
315     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
316     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
317 
318     // Mapping from token ID to owner
319     mapping (uint256 => address) private _tokenOwner;
320 
321     // Mapping from token ID to approved address
322     mapping (uint256 => address) private _tokenApprovals;
323 
324     // Mapping from owner to number of owned token
325     mapping (address => Counters.Counter) private _ownedTokensCount;
326 
327     // Mapping from owner to operator approvals
328     mapping (address => mapping (address => bool)) private _operatorApprovals;
329 
330     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
331     /*
332      * 0x80ac58cd ===
333      *     bytes4(keccak256('balanceOf(address)')) ^
334      *     bytes4(keccak256('ownerOf(uint256)')) ^
335      *     bytes4(keccak256('approve(address,uint256)')) ^
336      *     bytes4(keccak256('getApproved(uint256)')) ^
337      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
338      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
339      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
340      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
341      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
342      */
343 
344     constructor () public {
345         // register the supported interfaces to conform to ERC721 via ERC165
346         _registerInterface(_INTERFACE_ID_ERC721);
347     }
348 
349     /**
350      * @dev Gets the balance of the specified address
351      * @param owner address to query the balance of
352      * @return uint256 representing the amount owned by the passed address
353      */
354     function balanceOf(address owner) public view returns (uint256) {
355         require(owner != address(0));
356         return _ownedTokensCount[owner].current();
357     }
358 
359     /**
360      * @dev Gets the owner of the specified token ID
361      * @param tokenId uint256 ID of the token to query the owner of
362      * @return address currently marked as the owner of the given token ID
363      */
364     function ownerOf(uint256 tokenId) public view returns (address) {
365         address owner = _tokenOwner[tokenId];
366         require(owner != address(0));
367         return owner;
368     }
369 
370     /**
371      * @dev Approves another address to transfer the given token ID
372      * The zero address indicates there is no approved address.
373      * There can only be one approved address per token at a given time.
374      * Can only be called by the token owner or an approved operator.
375      * @param to address to be approved for the given token ID
376      * @param tokenId uint256 ID of the token to be approved
377      */
378     function approve(address to, uint256 tokenId) public {
379         address owner = ownerOf(tokenId);
380         require(to != owner);
381         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
382 
383         _tokenApprovals[tokenId] = to;
384         emit Approval(owner, to, tokenId);
385     }
386 
387     /**
388      * @dev Gets the approved address for a token ID, or zero if no address set
389      * Reverts if the token ID does not exist.
390      * @param tokenId uint256 ID of the token to query the approval of
391      * @return address currently approved for the given token ID
392      */
393     function getApproved(uint256 tokenId) public view returns (address) {
394         require(_exists(tokenId));
395         return _tokenApprovals[tokenId];
396     }
397 
398     /**
399      * @dev Sets or unsets the approval of a given operator
400      * An operator is allowed to transfer all tokens of the sender on their behalf
401      * @param to operator address to set the approval
402      * @param approved representing the status of the approval to be set
403      */
404     function setApprovalForAll(address to, bool approved) public {
405         require(to != msg.sender);
406         _operatorApprovals[msg.sender][to] = approved;
407         emit ApprovalForAll(msg.sender, to, approved);
408     }
409 
410     /**
411      * @dev Tells whether an operator is approved by a given owner
412      * @param owner owner address which you want to query the approval of
413      * @param operator operator address which you want to query the approval of
414      * @return bool whether the given operator is approved by the given owner
415      */
416     function isApprovedForAll(address owner, address operator) public view returns (bool) {
417         return _operatorApprovals[owner][operator];
418     }
419 
420     /**
421      * @dev Transfers the ownership of a given token ID to another address
422      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
423      * Requires the msg.sender to be the owner, approved, or operator
424      * @param from current owner of the token
425      * @param to address to receive the ownership of the given token ID
426      * @param tokenId uint256 ID of the token to be transferred
427      */
428     function transferFrom(address from, address to, uint256 tokenId) public {
429         require(_isApprovedOrOwner(msg.sender, tokenId));
430 
431         _transferFrom(from, to, tokenId);
432     }
433 
434     /**
435      * @dev Safely transfers the ownership of a given token ID to another address
436      * If the target address is a contract, it must implement `onERC721Received`,
437      * which is called upon a safe transfer, and return the magic value
438      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
439      * the transfer is reverted.
440      * Requires the msg.sender to be the owner, approved, or operator
441      * @param from current owner of the token
442      * @param to address to receive the ownership of the given token ID
443      * @param tokenId uint256 ID of the token to be transferred
444      */
445     function safeTransferFrom(address from, address to, uint256 tokenId) public {
446         safeTransferFrom(from, to, tokenId, "");
447     }
448 
449     /**
450      * @dev Safely transfers the ownership of a given token ID to another address
451      * If the target address is a contract, it must implement `onERC721Received`,
452      * which is called upon a safe transfer, and return the magic value
453      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
454      * the transfer is reverted.
455      * Requires the msg.sender to be the owner, approved, or operator
456      * @param from current owner of the token
457      * @param to address to receive the ownership of the given token ID
458      * @param tokenId uint256 ID of the token to be transferred
459      * @param _data bytes data to send along with a safe transfer check
460      */
461     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
462         transferFrom(from, to, tokenId);
463         require(_checkOnERC721Received(from, to, tokenId, _data));
464     }
465 
466     /**
467      * @dev Returns whether the specified token exists
468      * @param tokenId uint256 ID of the token to query the existence of
469      * @return bool whether the token exists
470      */
471     function _exists(uint256 tokenId) internal view returns (bool) {
472         address owner = _tokenOwner[tokenId];
473         return owner != address(0);
474     }
475 
476     /**
477      * @dev Returns whether the given spender can transfer a given token ID
478      * @param spender address of the spender to query
479      * @param tokenId uint256 ID of the token to be transferred
480      * @return bool whether the msg.sender is approved for the given token ID,
481      * is an operator of the owner, or is the owner of the token
482      */
483     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
484         address owner = ownerOf(tokenId);
485         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
486     }
487 
488     /**
489      * @dev Internal function to mint a new token
490      * Reverts if the given token ID already exists
491      * @param to The address that will own the minted token
492      * @param tokenId uint256 ID of the token to be minted
493      */
494     function _mint(address to, uint256 tokenId) internal {
495         require(to != address(0));
496         require(!_exists(tokenId));
497 
498         _tokenOwner[tokenId] = to;
499         _ownedTokensCount[to].increment();
500 
501         emit Transfer(address(0), to, tokenId);
502     }
503 
504     /**
505      * @dev Internal function to burn a specific token
506      * Reverts if the token does not exist
507      * Deprecated, use _burn(uint256) instead.
508      * @param owner owner of the token to burn
509      * @param tokenId uint256 ID of the token being burned
510      */
511     function _burn(address owner, uint256 tokenId) internal {
512         require(ownerOf(tokenId) == owner);
513 
514         _clearApproval(tokenId);
515 
516         _ownedTokensCount[owner].decrement();
517         _tokenOwner[tokenId] = address(0);
518 
519         emit Transfer(owner, address(0), tokenId);
520     }
521 
522     /**
523      * @dev Internal function to burn a specific token
524      * Reverts if the token does not exist
525      * @param tokenId uint256 ID of the token being burned
526      */
527     function _burn(uint256 tokenId) internal {
528         _burn(ownerOf(tokenId), tokenId);
529     }
530 
531     /**
532      * @dev Internal function to transfer ownership of a given token ID to another address.
533      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
534      * @param from current owner of the token
535      * @param to address to receive the ownership of the given token ID
536      * @param tokenId uint256 ID of the token to be transferred
537      */
538     function _transferFrom(address from, address to, uint256 tokenId) internal {
539         require(ownerOf(tokenId) == from);
540         require(to != address(0));
541 
542         _clearApproval(tokenId);
543 
544         _ownedTokensCount[from].decrement();
545         _ownedTokensCount[to].increment();
546 
547         _tokenOwner[tokenId] = to;
548 
549         emit Transfer(from, to, tokenId);
550     }
551 
552     /**
553      * @dev Internal function to invoke `onERC721Received` on a target address
554      * The call is not executed if the target address is not a contract
555      * @param from address representing the previous owner of the given token ID
556      * @param to target address that will receive the tokens
557      * @param tokenId uint256 ID of the token to be transferred
558      * @param _data bytes optional data to send along with the call
559      * @return bool whether the call correctly returned the expected magic value
560      */
561     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
562         internal returns (bool)
563     {
564         if (!to.isContract()) {
565             return true;
566         }
567 
568         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
569         return (retval == _ERC721_RECEIVED);
570     }
571 
572     /**
573      * @dev Private function to clear current approval of a given token ID
574      * @param tokenId uint256 ID of the token to be transferred
575      */
576     function _clearApproval(uint256 tokenId) private {
577         if (_tokenApprovals[tokenId] != address(0)) {
578             _tokenApprovals[tokenId] = address(0);
579         }
580     }
581 }
582 
583 
584 
585 
586 
587 
588 
589 /**
590  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
591  * @dev See https://eips.ethereum.org/EIPS/eip-721
592  */
593 contract IERC721Enumerable is IERC721 {
594     function totalSupply() public view returns (uint256);
595     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
596 
597     function tokenByIndex(uint256 index) public view returns (uint256);
598 }
599 
600 
601 
602 
603 /**
604  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
605  * @dev See https://eips.ethereum.org/EIPS/eip-721
606  */
607 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
608     // Mapping from owner to list of owned token IDs
609     mapping(address => uint256[]) private _ownedTokens;
610 
611     // Mapping from token ID to index of the owner tokens list
612     mapping(uint256 => uint256) private _ownedTokensIndex;
613 
614     // Array with all token ids, used for enumeration
615     uint256[] private _allTokens;
616 
617     // Mapping from token id to position in the allTokens array
618     mapping(uint256 => uint256) private _allTokensIndex;
619 
620     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
621     /*
622      * 0x780e9d63 ===
623      *     bytes4(keccak256('totalSupply()')) ^
624      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
625      *     bytes4(keccak256('tokenByIndex(uint256)'))
626      */
627 
628     /**
629      * @dev Constructor function
630      */
631     constructor () public {
632         // register the supported interface to conform to ERC721Enumerable via ERC165
633         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
634     }
635 
636     /**
637      * @dev Gets the token ID at a given index of the tokens list of the requested owner
638      * @param owner address owning the tokens list to be accessed
639      * @param index uint256 representing the index to be accessed of the requested tokens list
640      * @return uint256 token ID at the given index of the tokens list owned by the requested address
641      */
642     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
643         require(index < balanceOf(owner));
644         return _ownedTokens[owner][index];
645     }
646 
647     /**
648      * @dev Gets the total amount of tokens stored by the contract
649      * @return uint256 representing the total amount of tokens
650      */
651     function totalSupply() public view returns (uint256) {
652         return _allTokens.length;
653     }
654 
655     /**
656      * @dev Gets the token ID at a given index of all the tokens in this contract
657      * Reverts if the index is greater or equal to the total number of tokens
658      * @param index uint256 representing the index to be accessed of the tokens list
659      * @return uint256 token ID at the given index of the tokens list
660      */
661     function tokenByIndex(uint256 index) public view returns (uint256) {
662         require(index < totalSupply());
663         return _allTokens[index];
664     }
665 
666     /**
667      * @dev Internal function to transfer ownership of a given token ID to another address.
668      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
669      * @param from current owner of the token
670      * @param to address to receive the ownership of the given token ID
671      * @param tokenId uint256 ID of the token to be transferred
672      */
673     function _transferFrom(address from, address to, uint256 tokenId) internal {
674         super._transferFrom(from, to, tokenId);
675 
676         _removeTokenFromOwnerEnumeration(from, tokenId);
677 
678         _addTokenToOwnerEnumeration(to, tokenId);
679     }
680 
681     /**
682      * @dev Internal function to mint a new token
683      * Reverts if the given token ID already exists
684      * @param to address the beneficiary that will own the minted token
685      * @param tokenId uint256 ID of the token to be minted
686      */
687     function _mint(address to, uint256 tokenId) internal {
688         super._mint(to, tokenId);
689 
690         _addTokenToOwnerEnumeration(to, tokenId);
691 
692         _addTokenToAllTokensEnumeration(tokenId);
693     }
694 
695     /**
696      * @dev Internal function to burn a specific token
697      * Reverts if the token does not exist
698      * Deprecated, use _burn(uint256) instead
699      * @param owner owner of the token to burn
700      * @param tokenId uint256 ID of the token being burned
701      */
702     function _burn(address owner, uint256 tokenId) internal {
703         super._burn(owner, tokenId);
704 
705         _removeTokenFromOwnerEnumeration(owner, tokenId);
706         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
707         _ownedTokensIndex[tokenId] = 0;
708 
709         _removeTokenFromAllTokensEnumeration(tokenId);
710     }
711 
712     /**
713      * @dev Gets the list of token IDs of the requested owner
714      * @param owner address owning the tokens
715      * @return uint256[] List of token IDs owned by the requested address
716      */
717     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
718         return _ownedTokens[owner];
719     }
720 
721     /**
722      * @dev Private function to add a token to this extension's ownership-tracking data structures.
723      * @param to address representing the new owner of the given token ID
724      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
725      */
726     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
727         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
728         _ownedTokens[to].push(tokenId);
729     }
730 
731     /**
732      * @dev Private function to add a token to this extension's token tracking data structures.
733      * @param tokenId uint256 ID of the token to be added to the tokens list
734      */
735     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
736         _allTokensIndex[tokenId] = _allTokens.length;
737         _allTokens.push(tokenId);
738     }
739 
740     /**
741      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
742      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
743      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
744      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
745      * @param from address representing the previous owner of the given token ID
746      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
747      */
748     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
749         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
750         // then delete the last slot (swap and pop).
751 
752         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
753         uint256 tokenIndex = _ownedTokensIndex[tokenId];
754 
755         // When the token to delete is the last token, the swap operation is unnecessary
756         if (tokenIndex != lastTokenIndex) {
757             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
758 
759             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
760             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
761         }
762 
763         // This also deletes the contents at the last position of the array
764         _ownedTokens[from].length--;
765 
766         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
767         // lastTokenId, or just over the end of the array if the token was the last one).
768     }
769 
770     /**
771      * @dev Private function to remove a token from this extension's token tracking data structures.
772      * This has O(1) time complexity, but alters the order of the _allTokens array.
773      * @param tokenId uint256 ID of the token to be removed from the tokens list
774      */
775     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
776         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
777         // then delete the last slot (swap and pop).
778 
779         uint256 lastTokenIndex = _allTokens.length.sub(1);
780         uint256 tokenIndex = _allTokensIndex[tokenId];
781 
782         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
783         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
784         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
785         uint256 lastTokenId = _allTokens[lastTokenIndex];
786 
787         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
788         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
789 
790         // This also deletes the contents at the last position of the array
791         _allTokens.length--;
792         _allTokensIndex[tokenId] = 0;
793     }
794 }
795 
796 
797 
798 
799 
800 
801 
802 
803 /**
804  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
805  * @dev See https://eips.ethereum.org/EIPS/eip-721
806  */
807 contract IERC721Metadata is IERC721 {
808     function name() external view returns (string memory);
809     function symbol() external view returns (string memory);
810     function tokenURI(uint256 tokenId) external view returns (string memory);
811 }
812 
813 
814 
815 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
816     // Token name
817     string private _name;
818 
819     // Token symbol
820     string private _symbol;
821 
822     // Optional mapping for token URIs
823     mapping(uint256 => string) private _tokenURIs;
824 
825     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
826     /*
827      * 0x5b5e139f ===
828      *     bytes4(keccak256('name()')) ^
829      *     bytes4(keccak256('symbol()')) ^
830      *     bytes4(keccak256('tokenURI(uint256)'))
831      */
832 
833     /**
834      * @dev Constructor function
835      */
836     constructor (string memory name, string memory symbol) public {
837         _name = name;
838         _symbol = symbol;
839 
840         // register the supported interfaces to conform to ERC721 via ERC165
841         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
842     }
843 
844     /**
845      * @dev Gets the token name
846      * @return string representing the token name
847      */
848     function name() external view returns (string memory) {
849         return _name;
850     }
851 
852     /**
853      * @dev Gets the token symbol
854      * @return string representing the token symbol
855      */
856     function symbol() external view returns (string memory) {
857         return _symbol;
858     }
859 
860     /**
861      * @dev Returns an URI for a given token ID
862      * Throws if the token ID does not exist. May return an empty string.
863      * @param tokenId uint256 ID of the token to query
864      */
865     function tokenURI(uint256 tokenId) external view returns (string memory) {
866         require(_exists(tokenId));
867         return _tokenURIs[tokenId];
868     }
869 
870     /**
871      * @dev Internal function to set the token URI for a given token
872      * Reverts if the token ID does not exist
873      * @param tokenId uint256 ID of the token to set its URI
874      * @param uri string URI to assign
875      */
876     function _setTokenURI(uint256 tokenId, string memory uri) internal {
877         require(_exists(tokenId));
878         _tokenURIs[tokenId] = uri;
879     }
880 
881     /**
882      * @dev Internal function to burn a specific token
883      * Reverts if the token does not exist
884      * Deprecated, use _burn(uint256) instead
885      * @param owner owner of the token to burn
886      * @param tokenId uint256 ID of the token being burned by the msg.sender
887      */
888     function _burn(address owner, uint256 tokenId) internal {
889         super._burn(owner, tokenId);
890 
891         // Clear metadata (if any)
892         if (bytes(_tokenURIs[tokenId]).length != 0) {
893             delete _tokenURIs[tokenId];
894         }
895     }
896 }
897 
898 
899 /**
900  * @title Full ERC721 Token
901  * This implementation includes all the required and some optional functionality of the ERC721 standard
902  * Moreover, it includes approve all functionality using operator terminology
903  * @dev see https://eips.ethereum.org/EIPS/eip-721
904  */
905 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
906     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
907         // solhint-disable-previous-line no-empty-blocks
908     }
909 }
910 
911 
912 
913 /**
914  * @title Ownable
915  * @dev The Ownable contract has an owner address, and provides basic authorization control
916  * functions, this simplifies the implementation of "user permissions".
917  */
918 contract Ownable {
919     address private _owner;
920 
921     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
922 
923     /**
924      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
925      * account.
926      */
927     constructor () internal {
928         _owner = msg.sender;
929         emit OwnershipTransferred(address(0), _owner);
930     }
931 
932     /**
933      * @return the address of the owner.
934      */
935     function owner() public view returns (address) {
936         return _owner;
937     }
938 
939     /**
940      * @dev Throws if called by any account other than the owner.
941      */
942     modifier onlyOwner() {
943         require(isOwner());
944         _;
945     }
946 
947     /**
948      * @return true if `msg.sender` is the owner of the contract.
949      */
950     function isOwner() public view returns (bool) {
951         return msg.sender == _owner;
952     }
953 
954     /**
955      * @dev Allows the current owner to relinquish control of the contract.
956      * It will not be possible to call the functions with the `onlyOwner`
957      * modifier anymore.
958      * @notice Renouncing ownership will leave the contract without an owner,
959      * thereby removing any functionality that is only available to the owner.
960      */
961     function renounceOwnership() public onlyOwner {
962         emit OwnershipTransferred(_owner, address(0));
963         _owner = address(0);
964     }
965 
966     /**
967      * @dev Allows the current owner to transfer control of the contract to a newOwner.
968      * @param newOwner The address to transfer ownership to.
969      */
970     function transferOwnership(address newOwner) public onlyOwner {
971         _transferOwnership(newOwner);
972     }
973 
974     /**
975      * @dev Transfers control of the contract to a newOwner.
976      * @param newOwner The address to transfer ownership to.
977      */
978     function _transferOwnership(address newOwner) internal {
979         require(newOwner != address(0));
980         emit OwnershipTransferred(_owner, newOwner);
981         _owner = newOwner;
982     }
983 }
984 
985 
986 
987 contract OwnableDelegateProxy { }
988 
989 contract ProxyRegistry {
990     mapping(address => OwnableDelegateProxy) public proxies;
991 }
992 
993 contract CryptoSkulls is ERC721Full, Ownable {
994     using Strings for string;
995 
996     string public imageHash = "ee45d31baca263402d1ed0a6f3262ced177420365fe10f3dcf069b32b105fef7";
997 
998     address proxyRegistryAddress;
999     string baseTokenURI = "";
1000 
1001     constructor (string memory name,
1002                  string memory symbol,
1003                  address _proxyRegistryAddress)
1004         ERC721Full(name, symbol) public {
1005 
1006         proxyRegistryAddress = _proxyRegistryAddress;
1007     }
1008 
1009     function mint(uint256[] calldata tokenIds) external onlyOwner {
1010         address owner = owner();
1011 
1012         uint256 length = tokenIds.length;
1013 
1014         for (uint256 i = 0; i < length; i++) {
1015             uint256 tokenId = tokenIds[i];
1016 
1017             require(tokenId >= 0 && tokenId <= 9999);
1018 
1019             _mint(owner, tokenId);
1020         }
1021     }
1022 
1023     function setBaseTokenURI(string calldata _baseTokenURI) external onlyOwner {
1024         baseTokenURI = _baseTokenURI;
1025     }
1026 
1027     function setProxyRegistryAddress(address _proxyRegistryAddress) external onlyOwner {
1028         proxyRegistryAddress = _proxyRegistryAddress;
1029     }
1030 
1031     function tokenURI(uint256 _tokenId) external view returns (string memory) {
1032         return Strings.strConcat(
1033             baseTokenURI,
1034             Strings.uint2str(_tokenId)
1035         );
1036     }
1037 
1038     /**
1039      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1040      */
1041     function isApprovedForAll(address owner, address operator) public view returns (bool) {
1042         // Whitelist OpenSea proxy contract for easy trading.
1043         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1044         if (address(proxyRegistry.proxies(owner)) == operator) {
1045             return true;
1046         }
1047 
1048         return super.isApprovedForAll(owner, operator);
1049     }
1050 }