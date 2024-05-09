1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title IERC165
5  * @dev https://eips.ethereum.org/EIPS/eip-165
6  */
7 interface IERC165 {
8     /**
9      * @notice Query if a contract implements an interface
10      * @param interfaceId The interface identifier, as specified in ERC-165
11      * @dev Interface identification is specified in ERC-165. This function
12      * uses less than 30,000 gas.
13      */
14     function supportsInterface(bytes4 interfaceId) external view returns (bool);
15 }
16 
17 
18 
19 /**
20  * @title ERC721 Non-Fungible Token Standard basic interface
21  * @dev see https://eips.ethereum.org/EIPS/eip-721
22  */
23 contract IERC721 is IERC165 {
24     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
25     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
26     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
27 
28     function balanceOf(address owner) public view returns (uint256 balance);
29     function ownerOf(uint256 tokenId) public view returns (address owner);
30 
31     function approve(address to, uint256 tokenId) public;
32     function getApproved(uint256 tokenId) public view returns (address operator);
33 
34     function setApprovalForAll(address operator, bool _approved) public;
35     function isApprovedForAll(address owner, address operator) public view returns (bool);
36 
37     function transferFrom(address from, address to, uint256 tokenId) public;
38     function safeTransferFrom(address from, address to, uint256 tokenId) public;
39 
40     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
41 }
42 
43 
44 /**
45  * @title ERC721 token receiver interface
46  * @dev Interface for any contract that wants to support safeTransfers
47  * from ERC721 asset contracts.
48  */
49 contract IERC721Receiver {
50     /**
51      * @notice Handle the receipt of an NFT
52      * @dev The ERC721 smart contract calls this function on the recipient
53      * after a `safeTransfer`. This function MUST return the function selector,
54      * otherwise the caller will revert the transaction. The selector to be
55      * returned can be obtained as `this.onERC721Received.selector`. This
56      * function MAY throw to revert and reject the transfer.
57      * Note: the ERC721 contract address is always the message sender.
58      * @param operator The address which called `safeTransferFrom` function
59      * @param from The address which previously owned the token
60      * @param tokenId The NFT identifier which is being transferred
61      * @param data Additional data with no specified format
62      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
63      */
64     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
65     public returns (bytes4);
66 }
67 
68 
69 /**
70  * @title SafeMath
71  * @dev Unsigned math operations with safety checks that revert on error.
72  */
73 library SafeMath {
74     /**
75      * @dev Multiplies two unsigned integers, reverts on overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b);
87 
88         return c;
89     }
90 
91     /**
92      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
93      */
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         // Solidity only automatically asserts when dividing by 0
96         require(b > 0);
97         uint256 c = a / b;
98         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99 
100         return c;
101     }
102 
103     /**
104      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
105      */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         require(b <= a);
108         uint256 c = a - b;
109 
110         return c;
111     }
112 
113     /**
114      * @dev Adds two unsigned integers, reverts on overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a);
119 
120         return c;
121     }
122 
123     /**
124      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
125      * reverts when dividing by zero.
126      */
127     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b != 0);
129         return a % b;
130     }
131 }
132 
133 
134 /**
135  * Utility library of inline functions on addresses
136  */
137 library Address {
138     /**
139      * Returns whether the target address is a contract
140      * @dev This function will return false if invoked during the constructor of a contract,
141      * as the code is not actually created until after the constructor finishes.
142      * @param account address of the account to check
143      * @return whether the target address is a contract
144      */
145     function isContract(address account) internal view returns (bool) {
146         uint256 size;
147         // XXX Currently there is no better way to check if there is a contract in an address
148         // than to check the size of the code at that address.
149         // See https://ethereum.stackexchange.com/a/14016/36603
150         // for more details about how this works.
151         // TODO Check this again before the Serenity release, because all addresses will be
152         // contracts then.
153         // solhint-disable-next-line no-inline-assembly
154         assembly { size := extcodesize(account) }
155         return size > 0;
156     }
157 }
158 
159 
160 
161 /**
162  * @title Counters
163  * @author Matt Condon (@shrugs)
164  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
165  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
166  *
167  * Include with `using Counters for Counters.Counter;`
168  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
169  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
170  * directly accessed.
171  */
172 library Counters {
173     using SafeMath for uint256;
174 
175     struct Counter {
176         // This variable should never be directly accessed by users of the library: interactions must be restricted to
177         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
178         // this feature: see https://github.com/ethereum/solidity/issues/4637
179         uint256 _value; // default: 0
180     }
181 
182     function current(Counter storage counter) internal view returns (uint256) {
183         return counter._value;
184     }
185 
186     function increment(Counter storage counter) internal {
187         counter._value += 1;
188     }
189 
190     function decrement(Counter storage counter) internal {
191         counter._value = counter._value.sub(1);
192     }
193 }
194 
195 
196 
197 /**
198  * @title ERC165
199  * @author Matt Condon (@shrugs)
200  * @dev Implements ERC165 using a lookup table.
201  */
202 contract ERC165 is IERC165 {
203     /*
204      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
205      */
206     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
207 
208     /**
209      * @dev Mapping of interface ids to whether or not it's supported.
210      */
211     mapping(bytes4 => bool) private _supportedInterfaces;
212 
213     /**
214      * @dev A contract implementing SupportsInterfaceWithLookup
215      * implements ERC165 itself.
216      */
217     constructor () internal {
218         _registerInterface(_INTERFACE_ID_ERC165);
219     }
220 
221     /**
222      * @dev Implement supportsInterface(bytes4) using a lookup table.
223      */
224     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
225         return _supportedInterfaces[interfaceId];
226     }
227 
228     /**
229      * @dev Internal method for registering an interface.
230      */
231     function _registerInterface(bytes4 interfaceId) internal {
232         require(interfaceId != 0xffffffff);
233         _supportedInterfaces[interfaceId] = true;
234     }
235 }
236 
237 
238 
239 
240 
241 
242 
243 
244 /**
245  * @title ERC721 Non-Fungible Token Standard basic implementation
246  * @dev see https://eips.ethereum.org/EIPS/eip-721
247  */
248 contract ERC721 is ERC165, IERC721 {
249     using SafeMath for uint256;
250     using Address for address;
251     using Counters for Counters.Counter;
252 
253     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
254     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
255     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
256 
257     // Mapping from token ID to owner
258     mapping (uint256 => address) private _tokenOwner;
259 
260     // Mapping from token ID to approved address
261     mapping (uint256 => address) private _tokenApprovals;
262 
263     // Mapping from owner to number of owned token
264     mapping (address => Counters.Counter) private _ownedTokensCount;
265 
266     // Mapping from owner to operator approvals
267     mapping (address => mapping (address => bool)) private _operatorApprovals;
268 
269     /*
270      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
271      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
272      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
273      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
274      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
275      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
276      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
277      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
278      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
279      *    
280      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
281      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
282      */
283     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
284 
285     constructor () public {
286         // register the supported interfaces to conform to ERC721 via ERC165
287         _registerInterface(_INTERFACE_ID_ERC721);
288     }
289 
290     /**
291      * @dev Gets the balance of the specified address.
292      * @param owner address to query the balance of
293      * @return uint256 representing the amount owned by the passed address
294      */
295     function balanceOf(address owner) public view returns (uint256) {
296         require(owner != address(0));
297         return _ownedTokensCount[owner].current();
298     }
299 
300     /**
301      * @dev Gets the owner of the specified token ID.
302      * @param tokenId uint256 ID of the token to query the owner of
303      * @return address currently marked as the owner of the given token ID
304      */
305     function ownerOf(uint256 tokenId) public view returns (address) {
306         address owner = _tokenOwner[tokenId];
307         require(owner != address(0));
308         return owner;
309     }
310 
311     /**
312      * @dev Approves another address to transfer the given token ID
313      * The zero address indicates there is no approved address.
314      * There can only be one approved address per token at a given time.
315      * Can only be called by the token owner or an approved operator.
316      * @param to address to be approved for the given token ID
317      * @param tokenId uint256 ID of the token to be approved
318      */
319     function approve(address to, uint256 tokenId) public {
320         address owner = ownerOf(tokenId);
321         require(to != owner);
322         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
323 
324         _tokenApprovals[tokenId] = to;
325         emit Approval(owner, to, tokenId);
326     }
327 
328     /**
329      * @dev Gets the approved address for a token ID, or zero if no address set
330      * Reverts if the token ID does not exist.
331      * @param tokenId uint256 ID of the token to query the approval of
332      * @return address currently approved for the given token ID
333      */
334     function getApproved(uint256 tokenId) public view returns (address) {
335         require(_exists(tokenId));
336         return _tokenApprovals[tokenId];
337     }
338 
339     /**
340      * @dev Sets or unsets the approval of a given operator
341      * An operator is allowed to transfer all tokens of the sender on their behalf.
342      * @param to operator address to set the approval
343      * @param approved representing the status of the approval to be set
344      */
345     function setApprovalForAll(address to, bool approved) public {
346         require(to != msg.sender);
347         _operatorApprovals[msg.sender][to] = approved;
348         emit ApprovalForAll(msg.sender, to, approved);
349     }
350 
351     /**
352      * @dev Tells whether an operator is approved by a given owner.
353      * @param owner owner address which you want to query the approval of
354      * @param operator operator address which you want to query the approval of
355      * @return bool whether the given operator is approved by the given owner
356      */
357     function isApprovedForAll(address owner, address operator) public view returns (bool) {
358         return _operatorApprovals[owner][operator];
359     }
360 
361     /**
362      * @dev Transfers the ownership of a given token ID to another address.
363      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
364      * Requires the msg.sender to be the owner, approved, or operator.
365      * @param from current owner of the token
366      * @param to address to receive the ownership of the given token ID
367      * @param tokenId uint256 ID of the token to be transferred
368      */
369     function transferFrom(address from, address to, uint256 tokenId) public {
370         require(_isApprovedOrOwner(msg.sender, tokenId));
371 
372         _transferFrom(from, to, tokenId);
373     }
374 
375     /**
376      * @dev Safely transfers the ownership of a given token ID to another address
377      * If the target address is a contract, it must implement `onERC721Received`,
378      * which is called upon a safe transfer, and return the magic value
379      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
380      * the transfer is reverted.
381      * Requires the msg.sender to be the owner, approved, or operator
382      * @param from current owner of the token
383      * @param to address to receive the ownership of the given token ID
384      * @param tokenId uint256 ID of the token to be transferred
385      */
386     function safeTransferFrom(address from, address to, uint256 tokenId) public {
387         safeTransferFrom(from, to, tokenId, "");
388     }
389 
390     /**
391      * @dev Safely transfers the ownership of a given token ID to another address
392      * If the target address is a contract, it must implement `onERC721Received`,
393      * which is called upon a safe transfer, and return the magic value
394      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
395      * the transfer is reverted.
396      * Requires the msg.sender to be the owner, approved, or operator
397      * @param from current owner of the token
398      * @param to address to receive the ownership of the given token ID
399      * @param tokenId uint256 ID of the token to be transferred
400      * @param _data bytes data to send along with a safe transfer check
401      */
402     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
403         transferFrom(from, to, tokenId);
404         require(_checkOnERC721Received(from, to, tokenId, _data));
405     }
406 
407     /**
408      * @dev Returns whether the specified token exists.
409      * @param tokenId uint256 ID of the token to query the existence of
410      * @return bool whether the token exists
411      */
412     function _exists(uint256 tokenId) internal view returns (bool) {
413         address owner = _tokenOwner[tokenId];
414         return owner != address(0);
415     }
416 
417     /**
418      * @dev Returns whether the given spender can transfer a given token ID.
419      * @param spender address of the spender to query
420      * @param tokenId uint256 ID of the token to be transferred
421      * @return bool whether the msg.sender is approved for the given token ID,
422      * is an operator of the owner, or is the owner of the token
423      */
424     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
425         address owner = ownerOf(tokenId);
426         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
427     }
428 
429     /**
430      * @dev Internal function to mint a new token.
431      * Reverts if the given token ID already exists.
432      * @param to The address that will own the minted token
433      * @param tokenId uint256 ID of the token to be minted
434      */
435     function _mint(address to, uint256 tokenId) internal {
436         require(to != address(0));
437         require(!_exists(tokenId));
438 
439         _tokenOwner[tokenId] = to;
440         _ownedTokensCount[to].increment();
441 
442         emit Transfer(address(0), to, tokenId);
443     }
444 
445     /**
446      * @dev Internal function to burn a specific token.
447      * Reverts if the token does not exist.
448      * Deprecated, use _burn(uint256) instead.
449      * @param owner owner of the token to burn
450      * @param tokenId uint256 ID of the token being burned
451      */
452     function _burn(address owner, uint256 tokenId) internal {
453         require(ownerOf(tokenId) == owner);
454 
455         _clearApproval(tokenId);
456 
457         _ownedTokensCount[owner].decrement();
458         _tokenOwner[tokenId] = address(0);
459 
460         emit Transfer(owner, address(0), tokenId);
461     }
462 
463     /**
464      * @dev Internal function to burn a specific token.
465      * Reverts if the token does not exist.
466      * @param tokenId uint256 ID of the token being burned
467      */
468     function _burn(uint256 tokenId) internal {
469         _burn(ownerOf(tokenId), tokenId);
470     }
471 
472     /**
473      * @dev Internal function to transfer ownership of a given token ID to another address.
474      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
475      * @param from current owner of the token
476      * @param to address to receive the ownership of the given token ID
477      * @param tokenId uint256 ID of the token to be transferred
478      */
479     function _transferFrom(address from, address to, uint256 tokenId) internal {
480         require(ownerOf(tokenId) == from);
481         require(to != address(0));
482 
483         _clearApproval(tokenId);
484 
485         _ownedTokensCount[from].decrement();
486         _ownedTokensCount[to].increment();
487 
488         _tokenOwner[tokenId] = to;
489 
490         emit Transfer(from, to, tokenId);
491     }
492 
493     /**
494      * @dev Internal function to invoke `onERC721Received` on a target address.
495      * The call is not executed if the target address is not a contract.
496      * @param from address representing the previous owner of the given token ID
497      * @param to target address that will receive the tokens
498      * @param tokenId uint256 ID of the token to be transferred
499      * @param _data bytes optional data to send along with the call
500      * @return bool whether the call correctly returned the expected magic value
501      */
502     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
503         internal returns (bool)
504     {
505         if (!to.isContract()) {
506             return true;
507         }
508 
509         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
510         return (retval == _ERC721_RECEIVED);
511     }
512 
513     /**
514      * @dev Private function to clear current approval of a given token ID.
515      * @param tokenId uint256 ID of the token to be transferred
516      */
517     function _clearApproval(uint256 tokenId) private {
518         if (_tokenApprovals[tokenId] != address(0)) {
519             _tokenApprovals[tokenId] = address(0);
520         }
521     }
522 }
523 
524 
525 
526 /**
527  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
528  * @dev See https://eips.ethereum.org/EIPS/eip-721
529  */
530 contract IERC721Enumerable is IERC721 {
531     function totalSupply() public view returns (uint256);
532     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
533 
534     function tokenByIndex(uint256 index) public view returns (uint256);
535 }
536 
537 
538 
539 
540 
541 /**
542  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
543  * @dev See https://eips.ethereum.org/EIPS/eip-721
544  */
545 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
546     // Mapping from owner to list of owned token IDs
547     mapping(address => uint256[]) private _ownedTokens;
548 
549     // Mapping from token ID to index of the owner tokens list
550     mapping(uint256 => uint256) private _ownedTokensIndex;
551 
552     // Array with all token ids, used for enumeration
553     uint256[] private _allTokens;
554 
555     // Mapping from token id to position in the allTokens array
556     mapping(uint256 => uint256) private _allTokensIndex;
557 
558     /* 
559      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
560      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
561      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
562      *      
563      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63  
564      */
565     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
566 
567     /**
568      * @dev Constructor function.
569      */
570     constructor () public {
571         // register the supported interface to conform to ERC721Enumerable via ERC165
572         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
573     }
574 
575     /**
576      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
577      * @param owner address owning the tokens list to be accessed
578      * @param index uint256 representing the index to be accessed of the requested tokens list
579      * @return uint256 token ID at the given index of the tokens list owned by the requested address
580      */
581     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
582         require(index < balanceOf(owner));
583         return _ownedTokens[owner][index];
584     }
585 
586     /**
587      * @dev Gets the total amount of tokens stored by the contract.
588      * @return uint256 representing the total amount of tokens
589      */
590     function totalSupply() public view returns (uint256) {
591         return _allTokens.length;
592     }
593 
594     /**
595      * @dev Gets the token ID at a given index of all the tokens in this contract
596      * Reverts if the index is greater or equal to the total number of tokens.
597      * @param index uint256 representing the index to be accessed of the tokens list
598      * @return uint256 token ID at the given index of the tokens list
599      */
600     function tokenByIndex(uint256 index) public view returns (uint256) {
601         require(index < totalSupply());
602         return _allTokens[index];
603     }
604 
605     /**
606      * @dev Internal function to transfer ownership of a given token ID to another address.
607      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
608      * @param from current owner of the token
609      * @param to address to receive the ownership of the given token ID
610      * @param tokenId uint256 ID of the token to be transferred
611      */
612     function _transferFrom(address from, address to, uint256 tokenId) internal {
613         super._transferFrom(from, to, tokenId);
614 
615         _removeTokenFromOwnerEnumeration(from, tokenId);
616 
617         _addTokenToOwnerEnumeration(to, tokenId);
618     }
619 
620     /**
621      * @dev Internal function to mint a new token.
622      * Reverts if the given token ID already exists.
623      * @param to address the beneficiary that will own the minted token
624      * @param tokenId uint256 ID of the token to be minted
625      */
626     function _mint(address to, uint256 tokenId) internal {
627         super._mint(to, tokenId);
628 
629         _addTokenToOwnerEnumeration(to, tokenId);
630 
631         _addTokenToAllTokensEnumeration(tokenId);
632     }
633 
634     /**
635      * @dev Internal function to burn a specific token.
636      * Reverts if the token does not exist.
637      * Deprecated, use _burn(uint256) instead.
638      * @param owner owner of the token to burn
639      * @param tokenId uint256 ID of the token being burned
640      */
641     function _burn(address owner, uint256 tokenId) internal {
642         super._burn(owner, tokenId);
643 
644         _removeTokenFromOwnerEnumeration(owner, tokenId);
645         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
646         _ownedTokensIndex[tokenId] = 0;
647 
648         _removeTokenFromAllTokensEnumeration(tokenId);
649     }
650 
651     /**
652      * @dev Gets the list of token IDs of the requested owner.
653      * @param owner address owning the tokens
654      * @return uint256[] List of token IDs owned by the requested address
655      */
656     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
657         return _ownedTokens[owner];
658     }
659 
660     /**
661      * @dev Private function to add a token to this extension's ownership-tracking data structures.
662      * @param to address representing the new owner of the given token ID
663      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
664      */
665     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
666         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
667         _ownedTokens[to].push(tokenId);
668     }
669 
670     /**
671      * @dev Private function to add a token to this extension's token tracking data structures.
672      * @param tokenId uint256 ID of the token to be added to the tokens list
673      */
674     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
675         _allTokensIndex[tokenId] = _allTokens.length;
676         _allTokens.push(tokenId);
677     }
678 
679     /**
680      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
681      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
682      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
683      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
684      * @param from address representing the previous owner of the given token ID
685      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
686      */
687     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
688         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
689         // then delete the last slot (swap and pop).
690 
691         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
692         uint256 tokenIndex = _ownedTokensIndex[tokenId];
693 
694         // When the token to delete is the last token, the swap operation is unnecessary
695         if (tokenIndex != lastTokenIndex) {
696             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
697 
698             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
699             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
700         }
701 
702         // This also deletes the contents at the last position of the array
703         _ownedTokens[from].length--;
704 
705         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
706         // lastTokenId, or just over the end of the array if the token was the last one).
707     }
708 
709     /**
710      * @dev Private function to remove a token from this extension's token tracking data structures.
711      * This has O(1) time complexity, but alters the order of the _allTokens array.
712      * @param tokenId uint256 ID of the token to be removed from the tokens list
713      */
714     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
715         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
716         // then delete the last slot (swap and pop).
717 
718         uint256 lastTokenIndex = _allTokens.length.sub(1);
719         uint256 tokenIndex = _allTokensIndex[tokenId];
720 
721         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
722         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
723         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
724         uint256 lastTokenId = _allTokens[lastTokenIndex];
725 
726         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
727         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
728 
729         // This also deletes the contents at the last position of the array
730         _allTokens.length--;
731         _allTokensIndex[tokenId] = 0;
732     }
733 }
734 
735 
736 
737 /**
738  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
739  * @dev See https://eips.ethereum.org/EIPS/eip-721
740  */
741 contract IERC721Metadata is IERC721 {
742     function name() external view returns (string memory);
743     function symbol() external view returns (string memory);
744     function tokenURI(uint256 tokenId) external view returns (string memory);
745 }
746 
747 
748 
749 
750 
751 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
752     // Token name
753     string private _name;
754 
755     // Token symbol
756     string private _symbol;
757 
758     // Optional mapping for token URIs
759     mapping(uint256 => string) private _tokenURIs;
760 
761     /*
762      *     bytes4(keccak256('name()')) == 0x06fdde03
763      *     bytes4(keccak256('symbol()')) == 0x95d89b41
764      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
765      *     
766      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
767      */
768     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
769 
770     /**
771      * @dev Constructor function
772      */
773     constructor (string memory name, string memory symbol) public {
774         _name = name;
775         _symbol = symbol;
776 
777         // register the supported interfaces to conform to ERC721 via ERC165
778         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
779     }
780 
781     /**
782      * @dev Gets the token name.
783      * @return string representing the token name
784      */
785     function name() external view returns (string memory) {
786         return _name;
787     }
788 
789     /**
790      * @dev Gets the token symbol.
791      * @return string representing the token symbol
792      */
793     function symbol() external view returns (string memory) {
794         return _symbol;
795     }
796 
797     /**
798      * @dev Returns an URI for a given token ID.
799      * Throws if the token ID does not exist. May return an empty string.
800      * @param tokenId uint256 ID of the token to query
801      */
802     function tokenURI(uint256 tokenId) external view returns (string memory) {
803         require(_exists(tokenId));
804         return _tokenURIs[tokenId];
805     }
806 
807     /**
808      * @dev Internal function to set the token URI for a given token.
809      * Reverts if the token ID does not exist.
810      * @param tokenId uint256 ID of the token to set its URI
811      * @param uri string URI to assign
812      */
813     function _setTokenURI(uint256 tokenId, string memory uri) internal {
814         require(_exists(tokenId));
815         _tokenURIs[tokenId] = uri;
816     }
817 
818     /**
819      * @dev Internal function to burn a specific token.
820      * Reverts if the token does not exist.
821      * Deprecated, use _burn(uint256) instead.
822      * @param owner owner of the token to burn
823      * @param tokenId uint256 ID of the token being burned by the msg.sender
824      */
825     function _burn(address owner, uint256 tokenId) internal {
826         super._burn(owner, tokenId);
827 
828         // Clear metadata (if any)
829         if (bytes(_tokenURIs[tokenId]).length != 0) {
830             delete _tokenURIs[tokenId];
831         }
832     }
833 }
834 
835 
836 
837 
838 
839 /**
840  * @title Full ERC721 Token
841  * This implementation includes all the required and some optional functionality of the ERC721 standard
842  * Moreover, it includes approve all functionality using operator terminology
843  * @dev see https://eips.ethereum.org/EIPS/eip-721
844  */
845 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
846     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
847         // solhint-disable-previous-line no-empty-blocks
848     }
849 }
850 
851 
852 /**
853  * @title Roles
854  * @dev Library for managing addresses assigned to a Role.
855  */
856 library Roles {
857     struct Role {
858         mapping (address => bool) bearer;
859     }
860 
861     /**
862      * @dev Give an account access to this role.
863      */
864     function add(Role storage role, address account) internal {
865         require(!has(role, account));
866 
867         role.bearer[account] = true;
868     }
869 
870     /**
871      * @dev Remove an account's access to this role.
872      */
873     function remove(Role storage role, address account) internal {
874         require(has(role, account));
875 
876         role.bearer[account] = false;
877     }
878 
879     /**
880      * @dev Check if an account has this role.
881      * @return bool
882      */
883     function has(Role storage role, address account) internal view returns (bool) {
884         require(account != address(0));
885         return role.bearer[account];
886     }
887 }
888 
889 
890 
891 contract Governable {
892     using Roles for Roles.Role;
893 
894     event GovernorAdded(address indexed account);
895     event GovernorRemoved(address indexed account);
896 
897     Roles.Role private _governors;
898 
899     constructor () internal {
900         _addGovernor(msg.sender);
901     }
902 
903     modifier onlyGovernor() {
904         require(isGovernor(msg.sender));
905         _;
906     }
907 
908     function isGovernor(address account) public view returns (bool) {
909         return _governors.has(account);
910     }
911 
912     function addGovernor(address account) public onlyGovernor {
913         _addGovernor(account);
914     }
915 
916     function renounceGovernor() public {
917         _removeGovernor(msg.sender);
918     }
919 
920     function _addGovernor(address account) internal {
921         _governors.add(account);
922         emit GovernorAdded(account);
923     }
924 
925     function _removeGovernor(address account) internal {
926         _governors.remove(account);
927         emit GovernorRemoved(account);
928     }
929 }
930 
931 
932 
933 
934 /**
935  * @title ERC721MetadataMintable
936  * @dev ERC721 minting logic with metadata.
937  */
938 contract ERC721MetadataMintable is ERC721, ERC721Metadata, Governable {
939     /**
940      * @dev Function to mint tokens.
941      * @param to The address that will receive the minted tokens.
942      * @param tokenId The token id to mint.
943      * @param tokenURI The token URI of the minted token.
944      * @return A boolean that indicates if the operation was successful.
945      */
946     function mint(address to, uint256 tokenId, string memory tokenURI)
947         public
948         onlyGovernor
949         returns (bool)
950     {
951         _mint(to, tokenId);
952         _setTokenURI(tokenId, tokenURI);
953         return true;
954     }
955 }
956 
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
988         require(isOwner(), "Ownable: caller is not the owner");
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
1024         require(newOwner != address(0), "Ownable: new owner is the zero address");
1025         emit OwnershipTransferred(_owner, newOwner);
1026         _owner = newOwner;
1027     }
1028 }
1029 
1030 
1031 
1032 
1033 
1034 
1035 contract ERC721Classic is
1036     ERC721Full,
1037     ERC721MetadataMintable,
1038     Ownable
1039 {
1040     constructor(string memory name, string memory symbol)
1041         public
1042         ERC721Full(name, symbol)
1043         Ownable()
1044     {} // solium-disable-line
1045 }