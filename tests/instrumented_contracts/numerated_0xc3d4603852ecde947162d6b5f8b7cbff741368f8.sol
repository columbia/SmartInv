1 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title IERC165
7  * @dev https://eips.ethereum.org/EIPS/eip-165
8  */
9 interface IERC165 {
10     /**
11      * @notice Query if a contract implements an interface
12      * @param interfaceId The interface identifier, as specified in ERC-165
13      * @dev Interface identification is specified in ERC-165. This function
14      * uses less than 30,000 gas.
15      */
16     function supportsInterface(bytes4 interfaceId) external view returns (bool);
17 }
18 
19 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
20 
21 pragma solidity ^0.5.2;
22 
23 
24 /**
25  * @title ERC721 Non-Fungible Token Standard basic interface
26  * @dev see https://eips.ethereum.org/EIPS/eip-721
27  */
28 contract IERC721 is IERC165 {
29     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
30     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
31     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
32 
33     function balanceOf(address owner) public view returns (uint256 balance);
34     function ownerOf(uint256 tokenId) public view returns (address owner);
35 
36     function approve(address to, uint256 tokenId) public;
37     function getApproved(uint256 tokenId) public view returns (address operator);
38 
39     function setApprovalForAll(address operator, bool _approved) public;
40     function isApprovedForAll(address owner, address operator) public view returns (bool);
41 
42     function transferFrom(address from, address to, uint256 tokenId) public;
43     function safeTransferFrom(address from, address to, uint256 tokenId) public;
44 
45     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
46 }
47 
48 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
49 
50 pragma solidity ^0.5.2;
51 
52 /**
53  * @title ERC721 token receiver interface
54  * @dev Interface for any contract that wants to support safeTransfers
55  * from ERC721 asset contracts.
56  */
57 contract IERC721Receiver {
58     /**
59      * @notice Handle the receipt of an NFT
60      * @dev The ERC721 smart contract calls this function on the recipient
61      * after a `safeTransfer`. This function MUST return the function selector,
62      * otherwise the caller will revert the transaction. The selector to be
63      * returned can be obtained as `this.onERC721Received.selector`. This
64      * function MAY throw to revert and reject the transfer.
65      * Note: the ERC721 contract address is always the message sender.
66      * @param operator The address which called `safeTransferFrom` function
67      * @param from The address which previously owned the token
68      * @param tokenId The NFT identifier which is being transferred
69      * @param data Additional data with no specified format
70      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
71      */
72     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
73     public returns (bytes4);
74 }
75 
76 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
77 
78 pragma solidity ^0.5.2;
79 
80 /**
81  * @title SafeMath
82  * @dev Unsigned math operations with safety checks that revert on error
83  */
84 library SafeMath {
85     /**
86      * @dev Multiplies two unsigned integers, reverts on overflow.
87      */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b);
98 
99         return c;
100     }
101 
102     /**
103      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         // Solidity only automatically asserts when dividing by 0
107         require(b > 0);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a);
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125      * @dev Adds two unsigned integers, reverts on overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a);
130 
131         return c;
132     }
133 
134     /**
135      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
136      * reverts when dividing by zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         require(b != 0);
140         return a % b;
141     }
142 }
143 
144 // File: openzeppelin-solidity/contracts/utils/Address.sol
145 
146 pragma solidity ^0.5.2;
147 
148 /**
149  * Utility library of inline functions on addresses
150  */
151 library Address {
152     /**
153      * Returns whether the target address is a contract
154      * @dev This function will return false if invoked during the constructor of a contract,
155      * as the code is not actually created until after the constructor finishes.
156      * @param account address of the account to check
157      * @return whether the target address is a contract
158      */
159     function isContract(address account) internal view returns (bool) {
160         uint256 size;
161         // XXX Currently there is no better way to check if there is a contract in an address
162         // than to check the size of the code at that address.
163         // See https://ethereum.stackexchange.com/a/14016/36603
164         // for more details about how this works.
165         // TODO Check this again before the Serenity release, because all addresses will be
166         // contracts then.
167         // solhint-disable-next-line no-inline-assembly
168         assembly { size := extcodesize(account) }
169         return size > 0;
170     }
171 }
172 
173 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
174 
175 pragma solidity ^0.5.2;
176 
177 
178 /**
179  * @title Counters
180  * @author Matt Condon (@shrugs)
181  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
182  * of elements in a mapping, issuing ERC721 ids, or counting request ids
183  *
184  * Include with `using Counters for Counters.Counter;`
185  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
186  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
187  * directly accessed.
188  */
189 library Counters {
190     using SafeMath for uint256;
191 
192     struct Counter {
193         // This variable should never be directly accessed by users of the library: interactions must be restricted to
194         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
195         // this feature: see https://github.com/ethereum/solidity/issues/4637
196         uint256 _value; // default: 0
197     }
198 
199     function current(Counter storage counter) internal view returns (uint256) {
200         return counter._value;
201     }
202 
203     function increment(Counter storage counter) internal {
204         counter._value += 1;
205     }
206 
207     function decrement(Counter storage counter) internal {
208         counter._value = counter._value.sub(1);
209     }
210 }
211 
212 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
213 
214 pragma solidity ^0.5.2;
215 
216 
217 /**
218  * @title ERC165
219  * @author Matt Condon (@shrugs)
220  * @dev Implements ERC165 using a lookup table.
221  */
222 contract ERC165 is IERC165 {
223     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
224     /*
225      * 0x01ffc9a7 ===
226      *     bytes4(keccak256('supportsInterface(bytes4)'))
227      */
228 
229     /**
230      * @dev a mapping of interface id to whether or not it's supported
231      */
232     mapping(bytes4 => bool) private _supportedInterfaces;
233 
234     /**
235      * @dev A contract implementing SupportsInterfaceWithLookup
236      * implement ERC165 itself
237      */
238     constructor () internal {
239         _registerInterface(_INTERFACE_ID_ERC165);
240     }
241 
242     /**
243      * @dev implement supportsInterface(bytes4) using a lookup table
244      */
245     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
246         return _supportedInterfaces[interfaceId];
247     }
248 
249     /**
250      * @dev internal method for registering an interface
251      */
252     function _registerInterface(bytes4 interfaceId) internal {
253         require(interfaceId != 0xffffffff);
254         _supportedInterfaces[interfaceId] = true;
255     }
256 }
257 
258 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
259 
260 pragma solidity ^0.5.2;
261 
262 
263 
264 
265 
266 
267 
268 /**
269  * @title ERC721 Non-Fungible Token Standard basic implementation
270  * @dev see https://eips.ethereum.org/EIPS/eip-721
271  */
272 contract ERC721 is ERC165, IERC721 {
273     using SafeMath for uint256;
274     using Address for address;
275     using Counters for Counters.Counter;
276 
277     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
278     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
279     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
280 
281     // Mapping from token ID to owner
282     mapping (uint256 => address) private _tokenOwner;
283 
284     // Mapping from token ID to approved address
285     mapping (uint256 => address) private _tokenApprovals;
286 
287     // Mapping from owner to number of owned token
288     mapping (address => Counters.Counter) private _ownedTokensCount;
289 
290     // Mapping from owner to operator approvals
291     mapping (address => mapping (address => bool)) private _operatorApprovals;
292 
293     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
294     /*
295      * 0x80ac58cd ===
296      *     bytes4(keccak256('balanceOf(address)')) ^
297      *     bytes4(keccak256('ownerOf(uint256)')) ^
298      *     bytes4(keccak256('approve(address,uint256)')) ^
299      *     bytes4(keccak256('getApproved(uint256)')) ^
300      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
301      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
302      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
303      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
304      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
305      */
306 
307     constructor () public {
308         // register the supported interfaces to conform to ERC721 via ERC165
309         _registerInterface(_INTERFACE_ID_ERC721);
310     }
311 
312     /**
313      * @dev Gets the balance of the specified address
314      * @param owner address to query the balance of
315      * @return uint256 representing the amount owned by the passed address
316      */
317     function balanceOf(address owner) public view returns (uint256) {
318         require(owner != address(0));
319         return _ownedTokensCount[owner].current();
320     }
321 
322     /**
323      * @dev Gets the owner of the specified token ID
324      * @param tokenId uint256 ID of the token to query the owner of
325      * @return address currently marked as the owner of the given token ID
326      */
327     function ownerOf(uint256 tokenId) public view returns (address) {
328         address owner = _tokenOwner[tokenId];
329         require(owner != address(0));
330         return owner;
331     }
332 
333     /**
334      * @dev Approves another address to transfer the given token ID
335      * The zero address indicates there is no approved address.
336      * There can only be one approved address per token at a given time.
337      * Can only be called by the token owner or an approved operator.
338      * @param to address to be approved for the given token ID
339      * @param tokenId uint256 ID of the token to be approved
340      */
341     function approve(address to, uint256 tokenId) public {
342         address owner = ownerOf(tokenId);
343         require(to != owner);
344         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
345 
346         _tokenApprovals[tokenId] = to;
347         emit Approval(owner, to, tokenId);
348     }
349 
350     /**
351      * @dev Gets the approved address for a token ID, or zero if no address set
352      * Reverts if the token ID does not exist.
353      * @param tokenId uint256 ID of the token to query the approval of
354      * @return address currently approved for the given token ID
355      */
356     function getApproved(uint256 tokenId) public view returns (address) {
357         require(_exists(tokenId));
358         return _tokenApprovals[tokenId];
359     }
360 
361     /**
362      * @dev Sets or unsets the approval of a given operator
363      * An operator is allowed to transfer all tokens of the sender on their behalf
364      * @param to operator address to set the approval
365      * @param approved representing the status of the approval to be set
366      */
367     function setApprovalForAll(address to, bool approved) public {
368         require(to != msg.sender);
369         _operatorApprovals[msg.sender][to] = approved;
370         emit ApprovalForAll(msg.sender, to, approved);
371     }
372 
373     /**
374      * @dev Tells whether an operator is approved by a given owner
375      * @param owner owner address which you want to query the approval of
376      * @param operator operator address which you want to query the approval of
377      * @return bool whether the given operator is approved by the given owner
378      */
379     function isApprovedForAll(address owner, address operator) public view returns (bool) {
380         return _operatorApprovals[owner][operator];
381     }
382 
383     /**
384      * @dev Transfers the ownership of a given token ID to another address
385      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
386      * Requires the msg.sender to be the owner, approved, or operator
387      * @param from current owner of the token
388      * @param to address to receive the ownership of the given token ID
389      * @param tokenId uint256 ID of the token to be transferred
390      */
391     function transferFrom(address from, address to, uint256 tokenId) public {
392         require(_isApprovedOrOwner(msg.sender, tokenId));
393 
394         _transferFrom(from, to, tokenId);
395     }
396 
397     /**
398      * @dev Safely transfers the ownership of a given token ID to another address
399      * If the target address is a contract, it must implement `onERC721Received`,
400      * which is called upon a safe transfer, and return the magic value
401      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
402      * the transfer is reverted.
403      * Requires the msg.sender to be the owner, approved, or operator
404      * @param from current owner of the token
405      * @param to address to receive the ownership of the given token ID
406      * @param tokenId uint256 ID of the token to be transferred
407      */
408     function safeTransferFrom(address from, address to, uint256 tokenId) public {
409         safeTransferFrom(from, to, tokenId, "");
410     }
411 
412     /**
413      * @dev Safely transfers the ownership of a given token ID to another address
414      * If the target address is a contract, it must implement `onERC721Received`,
415      * which is called upon a safe transfer, and return the magic value
416      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
417      * the transfer is reverted.
418      * Requires the msg.sender to be the owner, approved, or operator
419      * @param from current owner of the token
420      * @param to address to receive the ownership of the given token ID
421      * @param tokenId uint256 ID of the token to be transferred
422      * @param _data bytes data to send along with a safe transfer check
423      */
424     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
425         transferFrom(from, to, tokenId);
426         require(_checkOnERC721Received(from, to, tokenId, _data));
427     }
428 
429     /**
430      * @dev Returns whether the specified token exists
431      * @param tokenId uint256 ID of the token to query the existence of
432      * @return bool whether the token exists
433      */
434     function _exists(uint256 tokenId) internal view returns (bool) {
435         address owner = _tokenOwner[tokenId];
436         return owner != address(0);
437     }
438 
439     /**
440      * @dev Returns whether the given spender can transfer a given token ID
441      * @param spender address of the spender to query
442      * @param tokenId uint256 ID of the token to be transferred
443      * @return bool whether the msg.sender is approved for the given token ID,
444      * is an operator of the owner, or is the owner of the token
445      */
446     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
447         address owner = ownerOf(tokenId);
448         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
449     }
450 
451     /**
452      * @dev Internal function to mint a new token
453      * Reverts if the given token ID already exists
454      * @param to The address that will own the minted token
455      * @param tokenId uint256 ID of the token to be minted
456      */
457     function _mint(address to, uint256 tokenId) internal {
458         require(to != address(0));
459         require(!_exists(tokenId));
460 
461         _tokenOwner[tokenId] = to;
462         _ownedTokensCount[to].increment();
463 
464         emit Transfer(address(0), to, tokenId);
465     }
466 
467     /**
468      * @dev Internal function to burn a specific token
469      * Reverts if the token does not exist
470      * Deprecated, use _burn(uint256) instead.
471      * @param owner owner of the token to burn
472      * @param tokenId uint256 ID of the token being burned
473      */
474     function _burn(address owner, uint256 tokenId) internal {
475         require(ownerOf(tokenId) == owner);
476 
477         _clearApproval(tokenId);
478 
479         _ownedTokensCount[owner].decrement();
480         _tokenOwner[tokenId] = address(0);
481 
482         emit Transfer(owner, address(0), tokenId);
483     }
484 
485     /**
486      * @dev Internal function to burn a specific token
487      * Reverts if the token does not exist
488      * @param tokenId uint256 ID of the token being burned
489      */
490     function _burn(uint256 tokenId) internal {
491         _burn(ownerOf(tokenId), tokenId);
492     }
493 
494     /**
495      * @dev Internal function to transfer ownership of a given token ID to another address.
496      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
497      * @param from current owner of the token
498      * @param to address to receive the ownership of the given token ID
499      * @param tokenId uint256 ID of the token to be transferred
500      */
501     function _transferFrom(address from, address to, uint256 tokenId) internal {
502         require(ownerOf(tokenId) == from);
503         require(to != address(0));
504 
505         _clearApproval(tokenId);
506 
507         _ownedTokensCount[from].decrement();
508         _ownedTokensCount[to].increment();
509 
510         _tokenOwner[tokenId] = to;
511 
512         emit Transfer(from, to, tokenId);
513     }
514 
515     /**
516      * @dev Internal function to invoke `onERC721Received` on a target address
517      * The call is not executed if the target address is not a contract
518      * @param from address representing the previous owner of the given token ID
519      * @param to target address that will receive the tokens
520      * @param tokenId uint256 ID of the token to be transferred
521      * @param _data bytes optional data to send along with the call
522      * @return bool whether the call correctly returned the expected magic value
523      */
524     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
525         internal returns (bool)
526     {
527         if (!to.isContract()) {
528             return true;
529         }
530 
531         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
532         return (retval == _ERC721_RECEIVED);
533     }
534 
535     /**
536      * @dev Private function to clear current approval of a given token ID
537      * @param tokenId uint256 ID of the token to be transferred
538      */
539     function _clearApproval(uint256 tokenId) private {
540         if (_tokenApprovals[tokenId] != address(0)) {
541             _tokenApprovals[tokenId] = address(0);
542         }
543     }
544 }
545 
546 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
547 
548 pragma solidity ^0.5.2;
549 
550 
551 /**
552  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
553  * @dev See https://eips.ethereum.org/EIPS/eip-721
554  */
555 contract IERC721Enumerable is IERC721 {
556     function totalSupply() public view returns (uint256);
557     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
558 
559     function tokenByIndex(uint256 index) public view returns (uint256);
560 }
561 
562 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
563 
564 pragma solidity ^0.5.2;
565 
566 
567 
568 
569 /**
570  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
571  * @dev See https://eips.ethereum.org/EIPS/eip-721
572  */
573 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
574     // Mapping from owner to list of owned token IDs
575     mapping(address => uint256[]) private _ownedTokens;
576 
577     // Mapping from token ID to index of the owner tokens list
578     mapping(uint256 => uint256) private _ownedTokensIndex;
579 
580     // Array with all token ids, used for enumeration
581     uint256[] private _allTokens;
582 
583     // Mapping from token id to position in the allTokens array
584     mapping(uint256 => uint256) private _allTokensIndex;
585 
586     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
587     /*
588      * 0x780e9d63 ===
589      *     bytes4(keccak256('totalSupply()')) ^
590      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
591      *     bytes4(keccak256('tokenByIndex(uint256)'))
592      */
593 
594     /**
595      * @dev Constructor function
596      */
597     constructor () public {
598         // register the supported interface to conform to ERC721Enumerable via ERC165
599         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
600     }
601 
602     /**
603      * @dev Gets the token ID at a given index of the tokens list of the requested owner
604      * @param owner address owning the tokens list to be accessed
605      * @param index uint256 representing the index to be accessed of the requested tokens list
606      * @return uint256 token ID at the given index of the tokens list owned by the requested address
607      */
608     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
609         require(index < balanceOf(owner));
610         return _ownedTokens[owner][index];
611     }
612 
613     /**
614      * @dev Gets the total amount of tokens stored by the contract
615      * @return uint256 representing the total amount of tokens
616      */
617     function totalSupply() public view returns (uint256) {
618         return _allTokens.length;
619     }
620 
621     /**
622      * @dev Gets the token ID at a given index of all the tokens in this contract
623      * Reverts if the index is greater or equal to the total number of tokens
624      * @param index uint256 representing the index to be accessed of the tokens list
625      * @return uint256 token ID at the given index of the tokens list
626      */
627     function tokenByIndex(uint256 index) public view returns (uint256) {
628         require(index < totalSupply());
629         return _allTokens[index];
630     }
631 
632     /**
633      * @dev Internal function to transfer ownership of a given token ID to another address.
634      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
635      * @param from current owner of the token
636      * @param to address to receive the ownership of the given token ID
637      * @param tokenId uint256 ID of the token to be transferred
638      */
639     function _transferFrom(address from, address to, uint256 tokenId) internal {
640         super._transferFrom(from, to, tokenId);
641 
642         _removeTokenFromOwnerEnumeration(from, tokenId);
643 
644         _addTokenToOwnerEnumeration(to, tokenId);
645     }
646 
647     /**
648      * @dev Internal function to mint a new token
649      * Reverts if the given token ID already exists
650      * @param to address the beneficiary that will own the minted token
651      * @param tokenId uint256 ID of the token to be minted
652      */
653     function _mint(address to, uint256 tokenId) internal {
654         super._mint(to, tokenId);
655 
656         _addTokenToOwnerEnumeration(to, tokenId);
657 
658         _addTokenToAllTokensEnumeration(tokenId);
659     }
660 
661     /**
662      * @dev Internal function to burn a specific token
663      * Reverts if the token does not exist
664      * Deprecated, use _burn(uint256) instead
665      * @param owner owner of the token to burn
666      * @param tokenId uint256 ID of the token being burned
667      */
668     function _burn(address owner, uint256 tokenId) internal {
669         super._burn(owner, tokenId);
670 
671         _removeTokenFromOwnerEnumeration(owner, tokenId);
672         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
673         _ownedTokensIndex[tokenId] = 0;
674 
675         _removeTokenFromAllTokensEnumeration(tokenId);
676     }
677 
678     /**
679      * @dev Gets the list of token IDs of the requested owner
680      * @param owner address owning the tokens
681      * @return uint256[] List of token IDs owned by the requested address
682      */
683     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
684         return _ownedTokens[owner];
685     }
686 
687     /**
688      * @dev Private function to add a token to this extension's ownership-tracking data structures.
689      * @param to address representing the new owner of the given token ID
690      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
691      */
692     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
693         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
694         _ownedTokens[to].push(tokenId);
695     }
696 
697     /**
698      * @dev Private function to add a token to this extension's token tracking data structures.
699      * @param tokenId uint256 ID of the token to be added to the tokens list
700      */
701     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
702         _allTokensIndex[tokenId] = _allTokens.length;
703         _allTokens.push(tokenId);
704     }
705 
706     /**
707      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
708      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
709      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
710      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
711      * @param from address representing the previous owner of the given token ID
712      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
713      */
714     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
715         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
716         // then delete the last slot (swap and pop).
717 
718         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
719         uint256 tokenIndex = _ownedTokensIndex[tokenId];
720 
721         // When the token to delete is the last token, the swap operation is unnecessary
722         if (tokenIndex != lastTokenIndex) {
723             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
724 
725             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
726             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
727         }
728 
729         // This also deletes the contents at the last position of the array
730         _ownedTokens[from].length--;
731 
732         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
733         // lastTokenId, or just over the end of the array if the token was the last one).
734     }
735 
736     /**
737      * @dev Private function to remove a token from this extension's token tracking data structures.
738      * This has O(1) time complexity, but alters the order of the _allTokens array.
739      * @param tokenId uint256 ID of the token to be removed from the tokens list
740      */
741     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
742         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
743         // then delete the last slot (swap and pop).
744 
745         uint256 lastTokenIndex = _allTokens.length.sub(1);
746         uint256 tokenIndex = _allTokensIndex[tokenId];
747 
748         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
749         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
750         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
751         uint256 lastTokenId = _allTokens[lastTokenIndex];
752 
753         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
754         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
755 
756         // This also deletes the contents at the last position of the array
757         _allTokens.length--;
758         _allTokensIndex[tokenId] = 0;
759     }
760 }
761 
762 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
763 
764 pragma solidity ^0.5.2;
765 
766 
767 /**
768  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
769  * @dev See https://eips.ethereum.org/EIPS/eip-721
770  */
771 contract IERC721Metadata is IERC721 {
772     function name() external view returns (string memory);
773     function symbol() external view returns (string memory);
774     function tokenURI(uint256 tokenId) external view returns (string memory);
775 }
776 
777 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
778 
779 pragma solidity ^0.5.2;
780 
781 
782 
783 
784 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
785     // Token name
786     string private _name;
787 
788     // Token symbol
789     string private _symbol;
790 
791     // Optional mapping for token URIs
792     mapping(uint256 => string) private _tokenURIs;
793 
794     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
795     /*
796      * 0x5b5e139f ===
797      *     bytes4(keccak256('name()')) ^
798      *     bytes4(keccak256('symbol()')) ^
799      *     bytes4(keccak256('tokenURI(uint256)'))
800      */
801 
802     /**
803      * @dev Constructor function
804      */
805     constructor (string memory name, string memory symbol) public {
806         _name = name;
807         _symbol = symbol;
808 
809         // register the supported interfaces to conform to ERC721 via ERC165
810         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
811     }
812 
813     /**
814      * @dev Gets the token name
815      * @return string representing the token name
816      */
817     function name() external view returns (string memory) {
818         return _name;
819     }
820 
821     /**
822      * @dev Gets the token symbol
823      * @return string representing the token symbol
824      */
825     function symbol() external view returns (string memory) {
826         return _symbol;
827     }
828 
829     /**
830      * @dev Returns an URI for a given token ID
831      * Throws if the token ID does not exist. May return an empty string.
832      * @param tokenId uint256 ID of the token to query
833      */
834     function tokenURI(uint256 tokenId) external view returns (string memory) {
835         require(_exists(tokenId));
836         return _tokenURIs[tokenId];
837     }
838 
839     /**
840      * @dev Internal function to set the token URI for a given token
841      * Reverts if the token ID does not exist
842      * @param tokenId uint256 ID of the token to set its URI
843      * @param uri string URI to assign
844      */
845     function _setTokenURI(uint256 tokenId, string memory uri) internal {
846         require(_exists(tokenId));
847         _tokenURIs[tokenId] = uri;
848     }
849 
850     /**
851      * @dev Internal function to burn a specific token
852      * Reverts if the token does not exist
853      * Deprecated, use _burn(uint256) instead
854      * @param owner owner of the token to burn
855      * @param tokenId uint256 ID of the token being burned by the msg.sender
856      */
857     function _burn(address owner, uint256 tokenId) internal {
858         super._burn(owner, tokenId);
859 
860         // Clear metadata (if any)
861         if (bytes(_tokenURIs[tokenId]).length != 0) {
862             delete _tokenURIs[tokenId];
863         }
864     }
865 }
866 
867 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol
868 
869 pragma solidity ^0.5.2;
870 
871 
872 
873 
874 /**
875  * @title Full ERC721 Token
876  * This implementation includes all the required and some optional functionality of the ERC721 standard
877  * Moreover, it includes approve all functionality using operator terminology
878  * @dev see https://eips.ethereum.org/EIPS/eip-721
879  */
880 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
881     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
882         // solhint-disable-previous-line no-empty-blocks
883     }
884 }
885 
886 // File: openzeppelin-solidity/contracts/access/Roles.sol
887 
888 pragma solidity ^0.5.2;
889 
890 /**
891  * @title Roles
892  * @dev Library for managing addresses assigned to a Role.
893  */
894 library Roles {
895     struct Role {
896         mapping (address => bool) bearer;
897     }
898 
899     /**
900      * @dev give an account access to this role
901      */
902     function add(Role storage role, address account) internal {
903         require(account != address(0));
904         require(!has(role, account));
905 
906         role.bearer[account] = true;
907     }
908 
909     /**
910      * @dev remove an account's access to this role
911      */
912     function remove(Role storage role, address account) internal {
913         require(account != address(0));
914         require(has(role, account));
915 
916         role.bearer[account] = false;
917     }
918 
919     /**
920      * @dev check if an account has this role
921      * @return bool
922      */
923     function has(Role storage role, address account) internal view returns (bool) {
924         require(account != address(0));
925         return role.bearer[account];
926     }
927 }
928 
929 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
930 
931 pragma solidity ^0.5.2;
932 
933 
934 contract MinterRole {
935     using Roles for Roles.Role;
936 
937     event MinterAdded(address indexed account);
938     event MinterRemoved(address indexed account);
939 
940     Roles.Role private _minters;
941 
942     constructor () internal {
943         _addMinter(msg.sender);
944     }
945 
946     modifier onlyMinter() {
947         require(isMinter(msg.sender));
948         _;
949     }
950 
951     function isMinter(address account) public view returns (bool) {
952         return _minters.has(account);
953     }
954 
955     function addMinter(address account) public onlyMinter {
956         _addMinter(account);
957     }
958 
959     function renounceMinter() public {
960         _removeMinter(msg.sender);
961     }
962 
963     function _addMinter(address account) internal {
964         _minters.add(account);
965         emit MinterAdded(account);
966     }
967 
968     function _removeMinter(address account) internal {
969         _minters.remove(account);
970         emit MinterRemoved(account);
971     }
972 }
973 
974 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol
975 
976 pragma solidity ^0.5.2;
977 
978 
979 
980 /**
981  * @title ERC721Mintable
982  * @dev ERC721 minting logic
983  */
984 contract ERC721Mintable is ERC721, MinterRole {
985     /**
986      * @dev Function to mint tokens
987      * @param to The address that will receive the minted tokens.
988      * @param tokenId The token id to mint.
989      * @return A boolean that indicates if the operation was successful.
990      */
991     function mint(address to, uint256 tokenId) public onlyMinter returns (bool) {
992         _mint(to, tokenId);
993         return true;
994     }
995 }
996 
997 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721MetadataMintable.sol
998 
999 pragma solidity ^0.5.2;
1000 
1001 
1002 
1003 
1004 /**
1005  * @title ERC721MetadataMintable
1006  * @dev ERC721 minting logic with metadata
1007  */
1008 contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
1009     /**
1010      * @dev Function to mint tokens
1011      * @param to The address that will receive the minted tokens.
1012      * @param tokenId The token id to mint.
1013      * @param tokenURI The token URI of the minted token.
1014      * @return A boolean that indicates if the operation was successful.
1015      */
1016     function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public onlyMinter returns (bool) {
1017         _mint(to, tokenId);
1018         _setTokenURI(tokenId, tokenURI);
1019         return true;
1020     }
1021 }
1022 
1023 // File: contracts/oldNMSST.sol
1024 
1025 pragma solidity ^0.5.2;
1026 
1027 
1028 
1029 
1030 contract NMSST is ERC721Full, ERC721Mintable, ERC721MetadataMintable {
1031   constructor() ERC721Full("Noah Melvin Schumer-Shaprio", "NMSST") public {
1032   }
1033   
1034   string public childName = "Noah Melvin Schumer-Shapiro";
1035 
1036   // Nov 24 2018, 5:23 am EST
1037   uint public childBirthday = 11543054980;
1038   
1039 }