1 // File: contracts/Strings.sol
2 
3 pragma solidity ^0.5.2;
4 
5 library Strings {
6   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
7   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
8     bytes memory _ba = bytes(_a);
9     bytes memory _bb = bytes(_b);
10     bytes memory _bc = bytes(_c);
11     bytes memory _bd = bytes(_d);
12     bytes memory _be = bytes(_e);
13     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
14     bytes memory babcde = bytes(abcde);
15     uint k = 0;
16     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
17     for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
18     for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
19     for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
20     for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
21     return string(babcde);
22   }
23 
24   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
25     return strConcat(_a, _b, _c, _d, "");
26   }
27 
28   function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
29     return strConcat(_a, _b, _c, "", "");
30   }
31 
32   function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
33     return strConcat(_a, _b, "", "", "");
34   }
35 
36   function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
37     if (_i == 0) {
38       return "0";
39     }
40     uint j = _i;
41     uint len;
42     while (j != 0) {
43       len++;
44       j /= 10;
45     }
46     bytes memory bstr = new bytes(len);
47     uint k = len - 1;
48     while (_i != 0) {
49       bstr[k--] = byte(uint8(48 + _i % 10));
50       _i /= 10;
51     }
52     return string(bstr);
53   }
54 
55   function fromAddress(address addr) internal pure returns(string memory) {
56     bytes20 addrBytes = bytes20(addr);
57     bytes16 hexAlphabet = "0123456789abcdef";
58     bytes memory result = new bytes(42);
59     result[0] = '0';
60     result[1] = 'x';
61     for (uint i = 0; i < 20; i++) {
62       result[i * 2 + 2] = hexAlphabet[uint8(addrBytes[i] >> 4)];
63       result[i * 2 + 3] = hexAlphabet[uint8(addrBytes[i] & 0x0f)];
64     }
65     return string(result);
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
70 
71 pragma solidity ^0.5.2;
72 
73 /**
74  * @title IERC165
75  * @dev https://eips.ethereum.org/EIPS/eip-165
76  */
77 interface IERC165 {
78     /**
79      * @notice Query if a contract implements an interface
80      * @param interfaceId The interface identifier, as specified in ERC-165
81      * @dev Interface identification is specified in ERC-165. This function
82      * uses less than 30,000 gas.
83      */
84     function supportsInterface(bytes4 interfaceId) external view returns (bool);
85 }
86 
87 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
88 
89 pragma solidity ^0.5.2;
90 
91 
92 /**
93  * @title ERC721 Non-Fungible Token Standard basic interface
94  * @dev see https://eips.ethereum.org/EIPS/eip-721
95  */
96 contract IERC721 is IERC165 {
97     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
98     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
99     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
100 
101     function balanceOf(address owner) public view returns (uint256 balance);
102     function ownerOf(uint256 tokenId) public view returns (address owner);
103 
104     function approve(address to, uint256 tokenId) public;
105     function getApproved(uint256 tokenId) public view returns (address operator);
106 
107     function setApprovalForAll(address operator, bool _approved) public;
108     function isApprovedForAll(address owner, address operator) public view returns (bool);
109 
110     function transferFrom(address from, address to, uint256 tokenId) public;
111     function safeTransferFrom(address from, address to, uint256 tokenId) public;
112 
113     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
114 }
115 
116 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
117 
118 pragma solidity ^0.5.2;
119 
120 /**
121  * @title ERC721 token receiver interface
122  * @dev Interface for any contract that wants to support safeTransfers
123  * from ERC721 asset contracts.
124  */
125 contract IERC721Receiver {
126     /**
127      * @notice Handle the receipt of an NFT
128      * @dev The ERC721 smart contract calls this function on the recipient
129      * after a `safeTransfer`. This function MUST return the function selector,
130      * otherwise the caller will revert the transaction. The selector to be
131      * returned can be obtained as `this.onERC721Received.selector`. This
132      * function MAY throw to revert and reject the transfer.
133      * Note: the ERC721 contract address is always the message sender.
134      * @param operator The address which called `safeTransferFrom` function
135      * @param from The address which previously owned the token
136      * @param tokenId The NFT identifier which is being transferred
137      * @param data Additional data with no specified format
138      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
139      */
140     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
141     public returns (bytes4);
142 }
143 
144 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
145 
146 pragma solidity ^0.5.2;
147 
148 /**
149  * @title SafeMath
150  * @dev Unsigned math operations with safety checks that revert on error
151  */
152 library SafeMath {
153     /**
154      * @dev Multiplies two unsigned integers, reverts on overflow.
155      */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
160         if (a == 0) {
161             return 0;
162         }
163 
164         uint256 c = a * b;
165         require(c / a == b);
166 
167         return c;
168     }
169 
170     /**
171      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         // Solidity only automatically asserts when dividing by 0
175         require(b > 0);
176         uint256 c = a / b;
177         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
178 
179         return c;
180     }
181 
182     /**
183      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
184      */
185     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186         require(b <= a);
187         uint256 c = a - b;
188 
189         return c;
190     }
191 
192     /**
193      * @dev Adds two unsigned integers, reverts on overflow.
194      */
195     function add(uint256 a, uint256 b) internal pure returns (uint256) {
196         uint256 c = a + b;
197         require(c >= a);
198 
199         return c;
200     }
201 
202     /**
203      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
204      * reverts when dividing by zero.
205      */
206     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
207         require(b != 0);
208         return a % b;
209     }
210 }
211 
212 // File: openzeppelin-solidity/contracts/utils/Address.sol
213 
214 pragma solidity ^0.5.2;
215 
216 /**
217  * Utility library of inline functions on addresses
218  */
219 library Address {
220     /**
221      * Returns whether the target address is a contract
222      * @dev This function will return false if invoked during the constructor of a contract,
223      * as the code is not actually created until after the constructor finishes.
224      * @param account address of the account to check
225      * @return whether the target address is a contract
226      */
227     function isContract(address account) internal view returns (bool) {
228         uint256 size;
229         // XXX Currently there is no better way to check if there is a contract in an address
230         // than to check the size of the code at that address.
231         // See https://ethereum.stackexchange.com/a/14016/36603
232         // for more details about how this works.
233         // TODO Check this again before the Serenity release, because all addresses will be
234         // contracts then.
235         // solhint-disable-next-line no-inline-assembly
236         assembly { size := extcodesize(account) }
237         return size > 0;
238     }
239 }
240 
241 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
242 
243 pragma solidity ^0.5.2;
244 
245 
246 /**
247  * @title Counters
248  * @author Matt Condon (@shrugs)
249  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
250  * of elements in a mapping, issuing ERC721 ids, or counting request ids
251  *
252  * Include with `using Counters for Counters.Counter;`
253  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
254  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
255  * directly accessed.
256  */
257 library Counters {
258     using SafeMath for uint256;
259 
260     struct Counter {
261         // This variable should never be directly accessed by users of the library: interactions must be restricted to
262         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
263         // this feature: see https://github.com/ethereum/solidity/issues/4637
264         uint256 _value; // default: 0
265     }
266 
267     function current(Counter storage counter) internal view returns (uint256) {
268         return counter._value;
269     }
270 
271     function increment(Counter storage counter) internal {
272         counter._value += 1;
273     }
274 
275     function decrement(Counter storage counter) internal {
276         counter._value = counter._value.sub(1);
277     }
278 }
279 
280 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
281 
282 pragma solidity ^0.5.2;
283 
284 
285 /**
286  * @title ERC165
287  * @author Matt Condon (@shrugs)
288  * @dev Implements ERC165 using a lookup table.
289  */
290 contract ERC165 is IERC165 {
291     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
292     /*
293      * 0x01ffc9a7 ===
294      *     bytes4(keccak256('supportsInterface(bytes4)'))
295      */
296 
297     /**
298      * @dev a mapping of interface id to whether or not it's supported
299      */
300     mapping(bytes4 => bool) private _supportedInterfaces;
301 
302     /**
303      * @dev A contract implementing SupportsInterfaceWithLookup
304      * implement ERC165 itself
305      */
306     constructor () internal {
307         _registerInterface(_INTERFACE_ID_ERC165);
308     }
309 
310     /**
311      * @dev implement supportsInterface(bytes4) using a lookup table
312      */
313     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
314         return _supportedInterfaces[interfaceId];
315     }
316 
317     /**
318      * @dev internal method for registering an interface
319      */
320     function _registerInterface(bytes4 interfaceId) internal {
321         require(interfaceId != 0xffffffff);
322         _supportedInterfaces[interfaceId] = true;
323     }
324 }
325 
326 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
327 
328 pragma solidity ^0.5.2;
329 
330 
331 
332 
333 
334 
335 
336 /**
337  * @title ERC721 Non-Fungible Token Standard basic implementation
338  * @dev see https://eips.ethereum.org/EIPS/eip-721
339  */
340 contract ERC721 is ERC165, IERC721 {
341     using SafeMath for uint256;
342     using Address for address;
343     using Counters for Counters.Counter;
344 
345     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
346     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
347     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
348 
349     // Mapping from token ID to owner
350     mapping (uint256 => address) private _tokenOwner;
351 
352     // Mapping from token ID to approved address
353     mapping (uint256 => address) private _tokenApprovals;
354 
355     // Mapping from owner to number of owned token
356     mapping (address => Counters.Counter) private _ownedTokensCount;
357 
358     // Mapping from owner to operator approvals
359     mapping (address => mapping (address => bool)) private _operatorApprovals;
360 
361     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
362     /*
363      * 0x80ac58cd ===
364      *     bytes4(keccak256('balanceOf(address)')) ^
365      *     bytes4(keccak256('ownerOf(uint256)')) ^
366      *     bytes4(keccak256('approve(address,uint256)')) ^
367      *     bytes4(keccak256('getApproved(uint256)')) ^
368      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
369      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
370      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
371      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
372      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
373      */
374 
375     constructor () public {
376         // register the supported interfaces to conform to ERC721 via ERC165
377         _registerInterface(_INTERFACE_ID_ERC721);
378     }
379 
380     /**
381      * @dev Gets the balance of the specified address
382      * @param owner address to query the balance of
383      * @return uint256 representing the amount owned by the passed address
384      */
385     function balanceOf(address owner) public view returns (uint256) {
386         require(owner != address(0));
387         return _ownedTokensCount[owner].current();
388     }
389 
390     /**
391      * @dev Gets the owner of the specified token ID
392      * @param tokenId uint256 ID of the token to query the owner of
393      * @return address currently marked as the owner of the given token ID
394      */
395     function ownerOf(uint256 tokenId) public view returns (address) {
396         address owner = _tokenOwner[tokenId];
397         require(owner != address(0));
398         return owner;
399     }
400 
401     /**
402      * @dev Approves another address to transfer the given token ID
403      * The zero address indicates there is no approved address.
404      * There can only be one approved address per token at a given time.
405      * Can only be called by the token owner or an approved operator.
406      * @param to address to be approved for the given token ID
407      * @param tokenId uint256 ID of the token to be approved
408      */
409     function approve(address to, uint256 tokenId) public {
410         address owner = ownerOf(tokenId);
411         require(to != owner);
412         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
413 
414         _tokenApprovals[tokenId] = to;
415         emit Approval(owner, to, tokenId);
416     }
417 
418     /**
419      * @dev Gets the approved address for a token ID, or zero if no address set
420      * Reverts if the token ID does not exist.
421      * @param tokenId uint256 ID of the token to query the approval of
422      * @return address currently approved for the given token ID
423      */
424     function getApproved(uint256 tokenId) public view returns (address) {
425         require(_exists(tokenId));
426         return _tokenApprovals[tokenId];
427     }
428 
429     /**
430      * @dev Sets or unsets the approval of a given operator
431      * An operator is allowed to transfer all tokens of the sender on their behalf
432      * @param to operator address to set the approval
433      * @param approved representing the status of the approval to be set
434      */
435     function setApprovalForAll(address to, bool approved) public {
436         require(to != msg.sender);
437         _operatorApprovals[msg.sender][to] = approved;
438         emit ApprovalForAll(msg.sender, to, approved);
439     }
440 
441     /**
442      * @dev Tells whether an operator is approved by a given owner
443      * @param owner owner address which you want to query the approval of
444      * @param operator operator address which you want to query the approval of
445      * @return bool whether the given operator is approved by the given owner
446      */
447     function isApprovedForAll(address owner, address operator) public view returns (bool) {
448         return _operatorApprovals[owner][operator];
449     }
450 
451     /**
452      * @dev Transfers the ownership of a given token ID to another address
453      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
454      * Requires the msg.sender to be the owner, approved, or operator
455      * @param from current owner of the token
456      * @param to address to receive the ownership of the given token ID
457      * @param tokenId uint256 ID of the token to be transferred
458      */
459     function transferFrom(address from, address to, uint256 tokenId) public {
460         require(_isApprovedOrOwner(msg.sender, tokenId));
461 
462         _transferFrom(from, to, tokenId);
463     }
464 
465     /**
466      * @dev Safely transfers the ownership of a given token ID to another address
467      * If the target address is a contract, it must implement `onERC721Received`,
468      * which is called upon a safe transfer, and return the magic value
469      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
470      * the transfer is reverted.
471      * Requires the msg.sender to be the owner, approved, or operator
472      * @param from current owner of the token
473      * @param to address to receive the ownership of the given token ID
474      * @param tokenId uint256 ID of the token to be transferred
475      */
476     function safeTransferFrom(address from, address to, uint256 tokenId) public {
477         safeTransferFrom(from, to, tokenId, "");
478     }
479 
480     /**
481      * @dev Safely transfers the ownership of a given token ID to another address
482      * If the target address is a contract, it must implement `onERC721Received`,
483      * which is called upon a safe transfer, and return the magic value
484      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
485      * the transfer is reverted.
486      * Requires the msg.sender to be the owner, approved, or operator
487      * @param from current owner of the token
488      * @param to address to receive the ownership of the given token ID
489      * @param tokenId uint256 ID of the token to be transferred
490      * @param _data bytes data to send along with a safe transfer check
491      */
492     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
493         transferFrom(from, to, tokenId);
494         require(_checkOnERC721Received(from, to, tokenId, _data));
495     }
496 
497     /**
498      * @dev Returns whether the specified token exists
499      * @param tokenId uint256 ID of the token to query the existence of
500      * @return bool whether the token exists
501      */
502     function _exists(uint256 tokenId) internal view returns (bool) {
503         address owner = _tokenOwner[tokenId];
504         return owner != address(0);
505     }
506 
507     /**
508      * @dev Returns whether the given spender can transfer a given token ID
509      * @param spender address of the spender to query
510      * @param tokenId uint256 ID of the token to be transferred
511      * @return bool whether the msg.sender is approved for the given token ID,
512      * is an operator of the owner, or is the owner of the token
513      */
514     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
515         address owner = ownerOf(tokenId);
516         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
517     }
518 
519     /**
520      * @dev Internal function to mint a new token
521      * Reverts if the given token ID already exists
522      * @param to The address that will own the minted token
523      * @param tokenId uint256 ID of the token to be minted
524      */
525     function _mint(address to, uint256 tokenId) internal {
526         require(to != address(0));
527         require(!_exists(tokenId));
528 
529         _tokenOwner[tokenId] = to;
530         _ownedTokensCount[to].increment();
531 
532         emit Transfer(address(0), to, tokenId);
533     }
534 
535     /**
536      * @dev Internal function to burn a specific token
537      * Reverts if the token does not exist
538      * Deprecated, use _burn(uint256) instead.
539      * @param owner owner of the token to burn
540      * @param tokenId uint256 ID of the token being burned
541      */
542     function _burn(address owner, uint256 tokenId) internal {
543         require(ownerOf(tokenId) == owner);
544 
545         _clearApproval(tokenId);
546 
547         _ownedTokensCount[owner].decrement();
548         _tokenOwner[tokenId] = address(0);
549 
550         emit Transfer(owner, address(0), tokenId);
551     }
552 
553     /**
554      * @dev Internal function to burn a specific token
555      * Reverts if the token does not exist
556      * @param tokenId uint256 ID of the token being burned
557      */
558     function _burn(uint256 tokenId) internal {
559         _burn(ownerOf(tokenId), tokenId);
560     }
561 
562     /**
563      * @dev Internal function to transfer ownership of a given token ID to another address.
564      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
565      * @param from current owner of the token
566      * @param to address to receive the ownership of the given token ID
567      * @param tokenId uint256 ID of the token to be transferred
568      */
569     function _transferFrom(address from, address to, uint256 tokenId) internal {
570         require(ownerOf(tokenId) == from);
571         require(to != address(0));
572 
573         _clearApproval(tokenId);
574 
575         _ownedTokensCount[from].decrement();
576         _ownedTokensCount[to].increment();
577 
578         _tokenOwner[tokenId] = to;
579 
580         emit Transfer(from, to, tokenId);
581     }
582 
583     /**
584      * @dev Internal function to invoke `onERC721Received` on a target address
585      * The call is not executed if the target address is not a contract
586      * @param from address representing the previous owner of the given token ID
587      * @param to target address that will receive the tokens
588      * @param tokenId uint256 ID of the token to be transferred
589      * @param _data bytes optional data to send along with the call
590      * @return bool whether the call correctly returned the expected magic value
591      */
592     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
593         internal returns (bool)
594     {
595         if (!to.isContract()) {
596             return true;
597         }
598 
599         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
600         return (retval == _ERC721_RECEIVED);
601     }
602 
603     /**
604      * @dev Private function to clear current approval of a given token ID
605      * @param tokenId uint256 ID of the token to be transferred
606      */
607     function _clearApproval(uint256 tokenId) private {
608         if (_tokenApprovals[tokenId] != address(0)) {
609             _tokenApprovals[tokenId] = address(0);
610         }
611     }
612 }
613 
614 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
615 
616 pragma solidity ^0.5.2;
617 
618 
619 /**
620  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
621  * @dev See https://eips.ethereum.org/EIPS/eip-721
622  */
623 contract IERC721Enumerable is IERC721 {
624     function totalSupply() public view returns (uint256);
625     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
626 
627     function tokenByIndex(uint256 index) public view returns (uint256);
628 }
629 
630 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
631 
632 pragma solidity ^0.5.2;
633 
634 
635 
636 
637 /**
638  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
639  * @dev See https://eips.ethereum.org/EIPS/eip-721
640  */
641 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
642     // Mapping from owner to list of owned token IDs
643     mapping(address => uint256[]) private _ownedTokens;
644 
645     // Mapping from token ID to index of the owner tokens list
646     mapping(uint256 => uint256) private _ownedTokensIndex;
647 
648     // Array with all token ids, used for enumeration
649     uint256[] private _allTokens;
650 
651     // Mapping from token id to position in the allTokens array
652     mapping(uint256 => uint256) private _allTokensIndex;
653 
654     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
655     /*
656      * 0x780e9d63 ===
657      *     bytes4(keccak256('totalSupply()')) ^
658      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
659      *     bytes4(keccak256('tokenByIndex(uint256)'))
660      */
661 
662     /**
663      * @dev Constructor function
664      */
665     constructor () public {
666         // register the supported interface to conform to ERC721Enumerable via ERC165
667         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
668     }
669 
670     /**
671      * @dev Gets the token ID at a given index of the tokens list of the requested owner
672      * @param owner address owning the tokens list to be accessed
673      * @param index uint256 representing the index to be accessed of the requested tokens list
674      * @return uint256 token ID at the given index of the tokens list owned by the requested address
675      */
676     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
677         require(index < balanceOf(owner));
678         return _ownedTokens[owner][index];
679     }
680 
681     /**
682      * @dev Gets the total amount of tokens stored by the contract
683      * @return uint256 representing the total amount of tokens
684      */
685     function totalSupply() public view returns (uint256) {
686         return _allTokens.length;
687     }
688 
689     /**
690      * @dev Gets the token ID at a given index of all the tokens in this contract
691      * Reverts if the index is greater or equal to the total number of tokens
692      * @param index uint256 representing the index to be accessed of the tokens list
693      * @return uint256 token ID at the given index of the tokens list
694      */
695     function tokenByIndex(uint256 index) public view returns (uint256) {
696         require(index < totalSupply());
697         return _allTokens[index];
698     }
699 
700     /**
701      * @dev Internal function to transfer ownership of a given token ID to another address.
702      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
703      * @param from current owner of the token
704      * @param to address to receive the ownership of the given token ID
705      * @param tokenId uint256 ID of the token to be transferred
706      */
707     function _transferFrom(address from, address to, uint256 tokenId) internal {
708         super._transferFrom(from, to, tokenId);
709 
710         _removeTokenFromOwnerEnumeration(from, tokenId);
711 
712         _addTokenToOwnerEnumeration(to, tokenId);
713     }
714 
715     /**
716      * @dev Internal function to mint a new token
717      * Reverts if the given token ID already exists
718      * @param to address the beneficiary that will own the minted token
719      * @param tokenId uint256 ID of the token to be minted
720      */
721     function _mint(address to, uint256 tokenId) internal {
722         super._mint(to, tokenId);
723 
724         _addTokenToOwnerEnumeration(to, tokenId);
725 
726         _addTokenToAllTokensEnumeration(tokenId);
727     }
728 
729     /**
730      * @dev Internal function to burn a specific token
731      * Reverts if the token does not exist
732      * Deprecated, use _burn(uint256) instead
733      * @param owner owner of the token to burn
734      * @param tokenId uint256 ID of the token being burned
735      */
736     function _burn(address owner, uint256 tokenId) internal {
737         super._burn(owner, tokenId);
738 
739         _removeTokenFromOwnerEnumeration(owner, tokenId);
740         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
741         _ownedTokensIndex[tokenId] = 0;
742 
743         _removeTokenFromAllTokensEnumeration(tokenId);
744     }
745 
746     /**
747      * @dev Gets the list of token IDs of the requested owner
748      * @param owner address owning the tokens
749      * @return uint256[] List of token IDs owned by the requested address
750      */
751     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
752         return _ownedTokens[owner];
753     }
754 
755     /**
756      * @dev Private function to add a token to this extension's ownership-tracking data structures.
757      * @param to address representing the new owner of the given token ID
758      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
759      */
760     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
761         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
762         _ownedTokens[to].push(tokenId);
763     }
764 
765     /**
766      * @dev Private function to add a token to this extension's token tracking data structures.
767      * @param tokenId uint256 ID of the token to be added to the tokens list
768      */
769     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
770         _allTokensIndex[tokenId] = _allTokens.length;
771         _allTokens.push(tokenId);
772     }
773 
774     /**
775      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
776      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
777      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
778      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
779      * @param from address representing the previous owner of the given token ID
780      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
781      */
782     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
783         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
784         // then delete the last slot (swap and pop).
785 
786         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
787         uint256 tokenIndex = _ownedTokensIndex[tokenId];
788 
789         // When the token to delete is the last token, the swap operation is unnecessary
790         if (tokenIndex != lastTokenIndex) {
791             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
792 
793             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
794             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
795         }
796 
797         // This also deletes the contents at the last position of the array
798         _ownedTokens[from].length--;
799 
800         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
801         // lastTokenId, or just over the end of the array if the token was the last one).
802     }
803 
804     /**
805      * @dev Private function to remove a token from this extension's token tracking data structures.
806      * This has O(1) time complexity, but alters the order of the _allTokens array.
807      * @param tokenId uint256 ID of the token to be removed from the tokens list
808      */
809     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
810         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
811         // then delete the last slot (swap and pop).
812 
813         uint256 lastTokenIndex = _allTokens.length.sub(1);
814         uint256 tokenIndex = _allTokensIndex[tokenId];
815 
816         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
817         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
818         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
819         uint256 lastTokenId = _allTokens[lastTokenIndex];
820 
821         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
822         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
823 
824         // This also deletes the contents at the last position of the array
825         _allTokens.length--;
826         _allTokensIndex[tokenId] = 0;
827     }
828 }
829 
830 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
831 
832 pragma solidity ^0.5.2;
833 
834 
835 /**
836  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
837  * @dev See https://eips.ethereum.org/EIPS/eip-721
838  */
839 contract IERC721Metadata is IERC721 {
840     function name() external view returns (string memory);
841     function symbol() external view returns (string memory);
842     function tokenURI(uint256 tokenId) external view returns (string memory);
843 }
844 
845 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
846 
847 pragma solidity ^0.5.2;
848 
849 
850 
851 
852 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
853     // Token name
854     string private _name;
855 
856     // Token symbol
857     string private _symbol;
858 
859     // Optional mapping for token URIs
860     mapping(uint256 => string) private _tokenURIs;
861 
862     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
863     /*
864      * 0x5b5e139f ===
865      *     bytes4(keccak256('name()')) ^
866      *     bytes4(keccak256('symbol()')) ^
867      *     bytes4(keccak256('tokenURI(uint256)'))
868      */
869 
870     /**
871      * @dev Constructor function
872      */
873     constructor (string memory name, string memory symbol) public {
874         _name = name;
875         _symbol = symbol;
876 
877         // register the supported interfaces to conform to ERC721 via ERC165
878         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
879     }
880 
881     /**
882      * @dev Gets the token name
883      * @return string representing the token name
884      */
885     function name() external view returns (string memory) {
886         return _name;
887     }
888 
889     /**
890      * @dev Gets the token symbol
891      * @return string representing the token symbol
892      */
893     function symbol() external view returns (string memory) {
894         return _symbol;
895     }
896 
897     /**
898      * @dev Returns an URI for a given token ID
899      * Throws if the token ID does not exist. May return an empty string.
900      * @param tokenId uint256 ID of the token to query
901      */
902     function tokenURI(uint256 tokenId) external view returns (string memory) {
903         require(_exists(tokenId));
904         return _tokenURIs[tokenId];
905     }
906 
907     /**
908      * @dev Internal function to set the token URI for a given token
909      * Reverts if the token ID does not exist
910      * @param tokenId uint256 ID of the token to set its URI
911      * @param uri string URI to assign
912      */
913     function _setTokenURI(uint256 tokenId, string memory uri) internal {
914         require(_exists(tokenId));
915         _tokenURIs[tokenId] = uri;
916     }
917 
918     /**
919      * @dev Internal function to burn a specific token
920      * Reverts if the token does not exist
921      * Deprecated, use _burn(uint256) instead
922      * @param owner owner of the token to burn
923      * @param tokenId uint256 ID of the token being burned by the msg.sender
924      */
925     function _burn(address owner, uint256 tokenId) internal {
926         super._burn(owner, tokenId);
927 
928         // Clear metadata (if any)
929         if (bytes(_tokenURIs[tokenId]).length != 0) {
930             delete _tokenURIs[tokenId];
931         }
932     }
933 }
934 
935 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
936 
937 pragma solidity ^0.5.2;
938 
939 
940 
941 
942 /**
943  * @title Full ERC721 Token
944  * This implementation includes all the required and some optional functionality of the ERC721 standard
945  * Moreover, it includes approve all functionality using operator terminology
946  * @dev see https://eips.ethereum.org/EIPS/eip-721
947  */
948 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
949     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
950         // solhint-disable-previous-line no-empty-blocks
951     }
952 }
953 
954 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
955 
956 pragma solidity ^0.5.2;
957 
958 /**
959  * @title Ownable
960  * @dev The Ownable contract has an owner address, and provides basic authorization control
961  * functions, this simplifies the implementation of "user permissions".
962  */
963 contract Ownable {
964     address private _owner;
965 
966     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
967 
968     /**
969      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
970      * account.
971      */
972     constructor () internal {
973         _owner = msg.sender;
974         emit OwnershipTransferred(address(0), _owner);
975     }
976 
977     /**
978      * @return the address of the owner.
979      */
980     function owner() public view returns (address) {
981         return _owner;
982     }
983 
984     /**
985      * @dev Throws if called by any account other than the owner.
986      */
987     modifier onlyOwner() {
988         require(isOwner());
989         _;
990     }
991 
992     /**
993      * @return true if `msg.sender` is the owner of the contract.
994      */
995     function isOwner() public view returns (bool) {
996         return msg.sender == _owner;
997     }
998 
999     /**
1000      * @dev Allows the current owner to relinquish control of the contract.
1001      * It will not be possible to call the functions with the `onlyOwner`
1002      * modifier anymore.
1003      * @notice Renouncing ownership will leave the contract without an owner,
1004      * thereby removing any functionality that is only available to the owner.
1005      */
1006     function renounceOwnership() public onlyOwner {
1007         emit OwnershipTransferred(_owner, address(0));
1008         _owner = address(0);
1009     }
1010 
1011     /**
1012      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1013      * @param newOwner The address to transfer ownership to.
1014      */
1015     function transferOwnership(address newOwner) public onlyOwner {
1016         _transferOwnership(newOwner);
1017     }
1018 
1019     /**
1020      * @dev Transfers control of the contract to a newOwner.
1021      * @param newOwner The address to transfer ownership to.
1022      */
1023     function _transferOwnership(address newOwner) internal {
1024         require(newOwner != address(0));
1025         emit OwnershipTransferred(_owner, newOwner);
1026         _owner = newOwner;
1027     }
1028 }
1029 
1030 // File: contracts/TradeableERC721Token.sol
1031 
1032 pragma solidity ^0.5.2;
1033 
1034 
1035 
1036 
1037 contract OwnableDelegateProxy { }
1038 
1039 contract ProxyRegistry {
1040     mapping(address => OwnableDelegateProxy) public proxies;
1041 }
1042 
1043 /**
1044  * @title TradeableERC721Token
1045  * TradeableERC721Token - ERC721 contract that whitelists a trading address, and has minting functionality.
1046  */
1047 contract TradeableERC721Token is ERC721Full, Ownable {
1048   using Strings for string;
1049 
1050   address proxyRegistryAddress;
1051   uint256 private _currentTokenId = 0;
1052 
1053   constructor(string memory _name, string memory _symbol, address _proxyRegistryAddress) ERC721Full(_name, _symbol) public {
1054     proxyRegistryAddress = _proxyRegistryAddress;
1055   }
1056 
1057   /**
1058     * @dev Mints a token to an address with a tokenURI.
1059     * @param _to address of the future owner of the token
1060     */
1061   function mintTo(address _to) public onlyOwner {
1062     uint256 newTokenId = _getNextTokenId();
1063     _mint(_to, newTokenId);
1064     _incrementTokenId();
1065   }
1066 
1067   /**
1068     * @dev calculates the next token ID based on value of _currentTokenId 
1069     * @return uint256 for the next token ID
1070     */
1071   function _getNextTokenId() private view returns (uint256) {
1072     return _currentTokenId.add(1);
1073   }
1074 
1075   /**
1076     * @dev increments the value of _currentTokenId 
1077     */
1078   function _incrementTokenId() private  {
1079     _currentTokenId++;
1080   }
1081 
1082   function baseTokenURI() public view returns (string memory) {
1083     return "";
1084   }
1085 
1086   function tokenURI(uint256 _tokenId) external view returns (string memory) {
1087     return Strings.strConcat(
1088         baseTokenURI(),
1089         Strings.uint2str(_tokenId)
1090     );
1091   }
1092 
1093   /**
1094    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1095    */
1096   function isApprovedForAll(
1097     address owner,
1098     address operator
1099   )
1100     public
1101     view
1102     returns (bool)
1103   {
1104     // Whitelist OpenSea proxy contract for easy trading.
1105     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1106     if (address(proxyRegistry.proxies(owner)) == operator) {
1107         return true;
1108     }
1109 
1110     return super.isApprovedForAll(owner, operator);
1111   }
1112 }
1113 
1114 // File: contracts/OpenSeaAsset.sol
1115 
1116 pragma solidity ^0.5.2;
1117 
1118 
1119 
1120 /**
1121  * @title OpenSea Asset
1122  * OpenSea Asset - A contract for easily creating custom assets on OpenSea. 
1123  */
1124 contract OpenSeaAsset is TradeableERC721Token {
1125   string private _baseTokenURI;
1126 
1127   constructor(
1128     string memory _name,
1129     string memory _symbol,
1130     address _proxyRegistryAddress,
1131     string memory baseURI
1132   ) TradeableERC721Token(_name, _symbol, _proxyRegistryAddress) public {
1133     _baseTokenURI = Strings.strConcat(baseURI, Strings.fromAddress(address(this)), "/");
1134   }
1135 
1136   function openSeaVersion() public pure returns (string memory) {
1137     return "1.2.0";
1138   }
1139 
1140   function baseTokenURI() public view returns (string memory) {
1141     return _baseTokenURI;
1142   }
1143 
1144   function setBaseTokenURI(string memory uri) public onlyOwner {
1145     _baseTokenURI = uri;
1146   }
1147 }