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
18 /**
19  * @title ERC721 Non-Fungible Token Standard basic interface
20  * @dev see https://eips.ethereum.org/EIPS/eip-721
21  */
22 contract IERC721 is IERC165 {
23     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
24     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
25     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
26 
27     function balanceOf(address owner) public view returns (uint256 balance);
28     function ownerOf(uint256 tokenId) public view returns (address owner);
29 
30     function approve(address to, uint256 tokenId) public;
31     function getApproved(uint256 tokenId) public view returns (address operator);
32 
33     function setApprovalForAll(address operator, bool _approved) public;
34     function isApprovedForAll(address owner, address operator) public view returns (bool);
35 
36     function transferFrom(address from, address to, uint256 tokenId) public;
37     function safeTransferFrom(address from, address to, uint256 tokenId) public;
38 
39     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
40 }
41 
42 /**
43  * @title ERC721 token receiver interface
44  * @dev Interface for any contract that wants to support safeTransfers
45  * from ERC721 asset contracts.
46  */
47 contract IERC721Receiver {
48     /**
49      * @notice Handle the receipt of an NFT
50      * @dev The ERC721 smart contract calls this function on the recipient
51      * after a `safeTransfer`. This function MUST return the function selector,
52      * otherwise the caller will revert the transaction. The selector to be
53      * returned can be obtained as `this.onERC721Received.selector`. This
54      * function MAY throw to revert and reject the transfer.
55      * Note: the ERC721 contract address is always the message sender.
56      * @param operator The address which called `safeTransferFrom` function
57      * @param from The address which previously owned the token
58      * @param tokenId The NFT identifier which is being transferred
59      * @param data Additional data with no specified format
60      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
61      */
62     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
63     public returns (bytes4);
64 }
65 
66 /**
67  * @title SafeMath
68  * @dev Unsigned math operations with safety checks that revert on error.
69  */
70 library SafeMath {
71     /**
72      * @dev Multiplies two unsigned integers, reverts on overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b);
84 
85         return c;
86     }
87 
88     /**
89      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
90      */
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         // Solidity only automatically asserts when dividing by 0
93         require(b > 0);
94         uint256 c = a / b;
95         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96 
97         return c;
98     }
99 
100     /**
101      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a);
105         uint256 c = a - b;
106 
107         return c;
108     }
109 
110     /**
111      * @dev Adds two unsigned integers, reverts on overflow.
112      */
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         require(c >= a);
116 
117         return c;
118     }
119 
120     /**
121      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
122      * reverts when dividing by zero.
123      */
124     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
125         require(b != 0);
126         return a % b;
127     }
128 }
129 
130 /**
131  * Utility library of inline functions on addresses
132  */
133 library Address {
134     /**
135      * Returns whether the target address is a contract
136      * @dev This function will return false if invoked during the constructor of a contract,
137      * as the code is not actually created until after the constructor finishes.
138      * @param account address of the account to check
139      * @return whether the target address is a contract
140      */
141     function isContract(address account) internal view returns (bool) {
142         uint256 size;
143         // XXX Currently there is no better way to check if there is a contract in an address
144         // than to check the size of the code at that address.
145         // See https://ethereum.stackexchange.com/a/14016/36603
146         // for more details about how this works.
147         // TODO Check this again before the Serenity release, because all addresses will be
148         // contracts then.
149         // solhint-disable-next-line no-inline-assembly
150         assembly { size := extcodesize(account) }
151         return size > 0;
152     }
153 }
154 
155 
156 /**
157  * @title Counters
158  * @author Matt Condon (@shrugs)
159  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
160  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
161  *
162  * Include with `using Counters for Counters.Counter;`
163  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
164  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
165  * directly accessed.
166  */
167 library Counters {
168     using SafeMath for uint256;
169 
170     struct Counter {
171         // This variable should never be directly accessed by users of the library: interactions must be restricted to
172         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
173         // this feature: see https://github.com/ethereum/solidity/issues/4637
174         uint256 _value; // default: 0
175     }
176 
177     function current(Counter storage counter) internal view returns (uint256) {
178         return counter._value;
179     }
180 
181     function increment(Counter storage counter) internal {
182         counter._value += 1;
183     }
184 
185     function decrement(Counter storage counter) internal {
186         counter._value = counter._value.sub(1);
187     }
188 }
189 
190 
191 /**
192  * @title ERC165
193  * @author Matt Condon (@shrugs)
194  * @dev Implements ERC165 using a lookup table.
195  */
196 contract ERC165 is IERC165 {
197     /*
198      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
199      */
200     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
201 
202     /**
203      * @dev Mapping of interface ids to whether or not it's supported.
204      */
205     mapping(bytes4 => bool) private _supportedInterfaces;
206 
207     /**
208      * @dev A contract implementing SupportsInterfaceWithLookup
209      * implements ERC165 itself.
210      */
211     constructor () internal {
212         _registerInterface(_INTERFACE_ID_ERC165);
213     }
214 
215     /**
216      * @dev Implement supportsInterface(bytes4) using a lookup table.
217      */
218     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
219         return _supportedInterfaces[interfaceId];
220     }
221 
222     /**
223      * @dev Internal method for registering an interface.
224      */
225     function _registerInterface(bytes4 interfaceId) internal {
226         require(interfaceId != 0xffffffff);
227         _supportedInterfaces[interfaceId] = true;
228     }
229 }
230 
231 
232 
233 
234 
235 
236 
237 /**
238  * @title ERC721 Non-Fungible Token Standard basic implementation
239  * @dev see https://eips.ethereum.org/EIPS/eip-721
240  */
241 contract ERC721 is ERC165, IERC721 {
242     using SafeMath for uint256;
243     using Address for address;
244     using Counters for Counters.Counter;
245 
246     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
247     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
248     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
249 
250     // Mapping from token ID to owner
251     mapping (uint256 => address) private _tokenOwner;
252 
253     // Mapping from token ID to approved address
254     mapping (uint256 => address) private _tokenApprovals;
255 
256     // Mapping from owner to number of owned token
257     mapping (address => Counters.Counter) private _ownedTokensCount;
258 
259     // Mapping from owner to operator approvals
260     mapping (address => mapping (address => bool)) private _operatorApprovals;
261 
262     /*
263      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
264      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
265      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
266      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
267      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
268      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
269      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
270      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
271      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
272      *    
273      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
274      *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
275      */
276     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
277 
278     constructor () public {
279         // register the supported interfaces to conform to ERC721 via ERC165
280         _registerInterface(_INTERFACE_ID_ERC721);
281     }
282 
283     /**
284      * @dev Gets the balance of the specified address.
285      * @param owner address to query the balance of
286      * @return uint256 representing the amount owned by the passed address
287      */
288     function balanceOf(address owner) public view returns (uint256) {
289         require(owner != address(0));
290         return _ownedTokensCount[owner].current();
291     }
292 
293     /**
294      * @dev Gets the owner of the specified token ID.
295      * @param tokenId uint256 ID of the token to query the owner of
296      * @return address currently marked as the owner of the given token ID
297      */
298     function ownerOf(uint256 tokenId) public view returns (address) {
299         address owner = _tokenOwner[tokenId];
300         require(owner != address(0));
301         return owner;
302     }
303 
304     /**
305      * @dev Approves another address to transfer the given token ID
306      * The zero address indicates there is no approved address.
307      * There can only be one approved address per token at a given time.
308      * Can only be called by the token owner or an approved operator.
309      * @param to address to be approved for the given token ID
310      * @param tokenId uint256 ID of the token to be approved
311      */
312     function approve(address to, uint256 tokenId) public {
313         address owner = ownerOf(tokenId);
314         require(to != owner);
315         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
316 
317         _tokenApprovals[tokenId] = to;
318         emit Approval(owner, to, tokenId);
319     }
320 
321     /**
322      * @dev Gets the approved address for a token ID, or zero if no address set
323      * Reverts if the token ID does not exist.
324      * @param tokenId uint256 ID of the token to query the approval of
325      * @return address currently approved for the given token ID
326      */
327     function getApproved(uint256 tokenId) public view returns (address) {
328         require(_exists(tokenId));
329         return _tokenApprovals[tokenId];
330     }
331 
332     /**
333      * @dev Sets or unsets the approval of a given operator
334      * An operator is allowed to transfer all tokens of the sender on their behalf.
335      * @param to operator address to set the approval
336      * @param approved representing the status of the approval to be set
337      */
338     function setApprovalForAll(address to, bool approved) public {
339         require(to != msg.sender);
340         _operatorApprovals[msg.sender][to] = approved;
341         emit ApprovalForAll(msg.sender, to, approved);
342     }
343 
344     /**
345      * @dev Tells whether an operator is approved by a given owner.
346      * @param owner owner address which you want to query the approval of
347      * @param operator operator address which you want to query the approval of
348      * @return bool whether the given operator is approved by the given owner
349      */
350     function isApprovedForAll(address owner, address operator) public view returns (bool) {
351         return _operatorApprovals[owner][operator];
352     }
353 
354     /**
355      * @dev Transfers the ownership of a given token ID to another address.
356      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
357      * Requires the msg.sender to be the owner, approved, or operator.
358      * @param from current owner of the token
359      * @param to address to receive the ownership of the given token ID
360      * @param tokenId uint256 ID of the token to be transferred
361      */
362     function transferFrom(address from, address to, uint256 tokenId) public {
363         require(_isApprovedOrOwner(msg.sender, tokenId));
364 
365         _transferFrom(from, to, tokenId);
366     }
367 
368     /**
369      * @dev Safely transfers the ownership of a given token ID to another address
370      * If the target address is a contract, it must implement `onERC721Received`,
371      * which is called upon a safe transfer, and return the magic value
372      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
373      * the transfer is reverted.
374      * Requires the msg.sender to be the owner, approved, or operator
375      * @param from current owner of the token
376      * @param to address to receive the ownership of the given token ID
377      * @param tokenId uint256 ID of the token to be transferred
378      */
379     function safeTransferFrom(address from, address to, uint256 tokenId) public {
380         safeTransferFrom(from, to, tokenId, "");
381     }
382 
383     /**
384      * @dev Safely transfers the ownership of a given token ID to another address
385      * If the target address is a contract, it must implement `onERC721Received`,
386      * which is called upon a safe transfer, and return the magic value
387      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
388      * the transfer is reverted.
389      * Requires the msg.sender to be the owner, approved, or operator
390      * @param from current owner of the token
391      * @param to address to receive the ownership of the given token ID
392      * @param tokenId uint256 ID of the token to be transferred
393      * @param _data bytes data to send along with a safe transfer check
394      */
395     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
396         transferFrom(from, to, tokenId);
397         require(_checkOnERC721Received(from, to, tokenId, _data));
398     }
399 
400     /**
401      * @dev Returns whether the specified token exists.
402      * @param tokenId uint256 ID of the token to query the existence of
403      * @return bool whether the token exists
404      */
405     function _exists(uint256 tokenId) internal view returns (bool) {
406         address owner = _tokenOwner[tokenId];
407         return owner != address(0);
408     }
409 
410     /**
411      * @dev Returns whether the given spender can transfer a given token ID.
412      * @param spender address of the spender to query
413      * @param tokenId uint256 ID of the token to be transferred
414      * @return bool whether the msg.sender is approved for the given token ID,
415      * is an operator of the owner, or is the owner of the token
416      */
417     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
418         address owner = ownerOf(tokenId);
419         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
420     }
421 
422     /**
423      * @dev Internal function to mint a new token.
424      * Reverts if the given token ID already exists.
425      * @param to The address that will own the minted token
426      * @param tokenId uint256 ID of the token to be minted
427      */
428     function _mint(address to, uint256 tokenId) internal {
429         require(to != address(0));
430         require(!_exists(tokenId));
431 
432         _tokenOwner[tokenId] = to;
433         _ownedTokensCount[to].increment();
434 
435         emit Transfer(address(0), to, tokenId);
436     }
437 
438     /**
439      * @dev Internal function to burn a specific token.
440      * Reverts if the token does not exist.
441      * Deprecated, use _burn(uint256) instead.
442      * @param owner owner of the token to burn
443      * @param tokenId uint256 ID of the token being burned
444      */
445     function _burn(address owner, uint256 tokenId) internal {
446         require(ownerOf(tokenId) == owner);
447 
448         _clearApproval(tokenId);
449 
450         _ownedTokensCount[owner].decrement();
451         _tokenOwner[tokenId] = address(0);
452 
453         emit Transfer(owner, address(0), tokenId);
454     }
455 
456     /**
457      * @dev Internal function to burn a specific token.
458      * Reverts if the token does not exist.
459      * @param tokenId uint256 ID of the token being burned
460      */
461     function _burn(uint256 tokenId) internal {
462         _burn(ownerOf(tokenId), tokenId);
463     }
464 
465     /**
466      * @dev Internal function to transfer ownership of a given token ID to another address.
467      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
468      * @param from current owner of the token
469      * @param to address to receive the ownership of the given token ID
470      * @param tokenId uint256 ID of the token to be transferred
471      */
472     function _transferFrom(address from, address to, uint256 tokenId) internal {
473         require(ownerOf(tokenId) == from);
474         require(to != address(0));
475 
476         _clearApproval(tokenId);
477 
478         _ownedTokensCount[from].decrement();
479         _ownedTokensCount[to].increment();
480 
481         _tokenOwner[tokenId] = to;
482 
483         emit Transfer(from, to, tokenId);
484     }
485 
486     /**
487      * @dev Internal function to invoke `onERC721Received` on a target address.
488      * The call is not executed if the target address is not a contract.
489      * @param from address representing the previous owner of the given token ID
490      * @param to target address that will receive the tokens
491      * @param tokenId uint256 ID of the token to be transferred
492      * @param _data bytes optional data to send along with the call
493      * @return bool whether the call correctly returned the expected magic value
494      */
495     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
496         internal returns (bool)
497     {
498         if (!to.isContract()) {
499             return true;
500         }
501 
502         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
503         return (retval == _ERC721_RECEIVED);
504     }
505 
506     /**
507      * @dev Private function to clear current approval of a given token ID.
508      * @param tokenId uint256 ID of the token to be transferred
509      */
510     function _clearApproval(uint256 tokenId) private {
511         if (_tokenApprovals[tokenId] != address(0)) {
512             _tokenApprovals[tokenId] = address(0);
513         }
514     }
515 }
516 
517 
518 /**
519  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
520  * @dev See https://eips.ethereum.org/EIPS/eip-721
521  */
522 contract IERC721Enumerable is IERC721 {
523     function totalSupply() public view returns (uint256);
524     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
525 
526     function tokenByIndex(uint256 index) public view returns (uint256);
527 }
528 
529 
530 
531 
532 /**
533  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
534  * @dev See https://eips.ethereum.org/EIPS/eip-721
535  */
536 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
537     // Mapping from owner to list of owned token IDs
538     mapping(address => uint256[]) private _ownedTokens;
539 
540     // Mapping from token ID to index of the owner tokens list
541     mapping(uint256 => uint256) private _ownedTokensIndex;
542 
543     // Array with all token ids, used for enumeration
544     uint256[] private _allTokens;
545 
546     // Mapping from token id to position in the allTokens array
547     mapping(uint256 => uint256) private _allTokensIndex;
548 
549     /* 
550      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
551      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
552      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
553      *      
554      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63  
555      */
556     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
557 
558     /**
559      * @dev Constructor function.
560      */
561     constructor () public {
562         // register the supported interface to conform to ERC721Enumerable via ERC165
563         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
564     }
565 
566     /**
567      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
568      * @param owner address owning the tokens list to be accessed
569      * @param index uint256 representing the index to be accessed of the requested tokens list
570      * @return uint256 token ID at the given index of the tokens list owned by the requested address
571      */
572     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
573         require(index < balanceOf(owner));
574         return _ownedTokens[owner][index];
575     }
576 
577     /**
578      * @dev Gets the total amount of tokens stored by the contract.
579      * @return uint256 representing the total amount of tokens
580      */
581     function totalSupply() public view returns (uint256) {
582         return _allTokens.length;
583     }
584 
585     /**
586      * @dev Gets the token ID at a given index of all the tokens in this contract
587      * Reverts if the index is greater or equal to the total number of tokens.
588      * @param index uint256 representing the index to be accessed of the tokens list
589      * @return uint256 token ID at the given index of the tokens list
590      */
591     function tokenByIndex(uint256 index) public view returns (uint256) {
592         require(index < totalSupply());
593         return _allTokens[index];
594     }
595 
596     /**
597      * @dev Internal function to transfer ownership of a given token ID to another address.
598      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
599      * @param from current owner of the token
600      * @param to address to receive the ownership of the given token ID
601      * @param tokenId uint256 ID of the token to be transferred
602      */
603     function _transferFrom(address from, address to, uint256 tokenId) internal {
604         super._transferFrom(from, to, tokenId);
605 
606         _removeTokenFromOwnerEnumeration(from, tokenId);
607 
608         _addTokenToOwnerEnumeration(to, tokenId);
609     }
610 
611     /**
612      * @dev Internal function to mint a new token.
613      * Reverts if the given token ID already exists.
614      * @param to address the beneficiary that will own the minted token
615      * @param tokenId uint256 ID of the token to be minted
616      */
617     function _mint(address to, uint256 tokenId) internal {
618         super._mint(to, tokenId);
619 
620         _addTokenToOwnerEnumeration(to, tokenId);
621 
622         _addTokenToAllTokensEnumeration(tokenId);
623     }
624 
625     /**
626      * @dev Internal function to burn a specific token.
627      * Reverts if the token does not exist.
628      * Deprecated, use _burn(uint256) instead.
629      * @param owner owner of the token to burn
630      * @param tokenId uint256 ID of the token being burned
631      */
632     function _burn(address owner, uint256 tokenId) internal {
633         super._burn(owner, tokenId);
634 
635         _removeTokenFromOwnerEnumeration(owner, tokenId);
636         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
637         _ownedTokensIndex[tokenId] = 0;
638 
639         _removeTokenFromAllTokensEnumeration(tokenId);
640     }
641 
642     /**
643      * @dev Gets the list of token IDs of the requested owner.
644      * @param owner address owning the tokens
645      * @return uint256[] List of token IDs owned by the requested address
646      */
647     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
648         return _ownedTokens[owner];
649     }
650 
651     /**
652      * @dev Private function to add a token to this extension's ownership-tracking data structures.
653      * @param to address representing the new owner of the given token ID
654      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
655      */
656     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
657         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
658         _ownedTokens[to].push(tokenId);
659     }
660 
661     /**
662      * @dev Private function to add a token to this extension's token tracking data structures.
663      * @param tokenId uint256 ID of the token to be added to the tokens list
664      */
665     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
666         _allTokensIndex[tokenId] = _allTokens.length;
667         _allTokens.push(tokenId);
668     }
669 
670     /**
671      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
672      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
673      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
674      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
675      * @param from address representing the previous owner of the given token ID
676      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
677      */
678     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
679         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
680         // then delete the last slot (swap and pop).
681 
682         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
683         uint256 tokenIndex = _ownedTokensIndex[tokenId];
684 
685         // When the token to delete is the last token, the swap operation is unnecessary
686         if (tokenIndex != lastTokenIndex) {
687             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
688 
689             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
690             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
691         }
692 
693         // This also deletes the contents at the last position of the array
694         _ownedTokens[from].length--;
695 
696         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
697         // lastTokenId, or just over the end of the array if the token was the last one).
698     }
699 
700     /**
701      * @dev Private function to remove a token from this extension's token tracking data structures.
702      * This has O(1) time complexity, but alters the order of the _allTokens array.
703      * @param tokenId uint256 ID of the token to be removed from the tokens list
704      */
705     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
706         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
707         // then delete the last slot (swap and pop).
708 
709         uint256 lastTokenIndex = _allTokens.length.sub(1);
710         uint256 tokenIndex = _allTokensIndex[tokenId];
711 
712         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
713         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
714         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
715         uint256 lastTokenId = _allTokens[lastTokenIndex];
716 
717         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
718         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
719 
720         // This also deletes the contents at the last position of the array
721         _allTokens.length--;
722         _allTokensIndex[tokenId] = 0;
723     }
724 }
725 
726 
727 /**
728  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
729  * @dev See https://eips.ethereum.org/EIPS/eip-721
730  */
731 contract IERC721Metadata is IERC721 {
732     function name() external view returns (string memory);
733     function symbol() external view returns (string memory);
734     function tokenURI(uint256 tokenId) external view returns (string memory);
735 }
736 
737 
738 
739 
740 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
741     // Token name
742     string private _name;
743 
744     // Token symbol
745     string private _symbol;
746 
747     // Optional mapping for token URIs
748     mapping(uint256 => string) private _tokenURIs;
749 
750     /*
751      *     bytes4(keccak256('name()')) == 0x06fdde03
752      *     bytes4(keccak256('symbol()')) == 0x95d89b41
753      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
754      *     
755      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
756      */
757     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
758 
759     /**
760      * @dev Constructor function
761      */
762     constructor (string memory name, string memory symbol) public {
763         _name = name;
764         _symbol = symbol;
765 
766         // register the supported interfaces to conform to ERC721 via ERC165
767         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
768     }
769 
770     /**
771      * @dev Gets the token name.
772      * @return string representing the token name
773      */
774     function name() external view returns (string memory) {
775         return _name;
776     }
777 
778     /**
779      * @dev Gets the token symbol.
780      * @return string representing the token symbol
781      */
782     function symbol() external view returns (string memory) {
783         return _symbol;
784     }
785 
786     /**
787      * @dev Returns an URI for a given token ID.
788      * Throws if the token ID does not exist. May return an empty string.
789      * @param tokenId uint256 ID of the token to query
790      */
791     function tokenURI(uint256 tokenId) external view returns (string memory) {
792         require(_exists(tokenId));
793         return _tokenURIs[tokenId];
794     }
795 
796     /**
797      * @dev Internal function to set the token URI for a given token.
798      * Reverts if the token ID does not exist.
799      * @param tokenId uint256 ID of the token to set its URI
800      * @param uri string URI to assign
801      */
802     function _setTokenURI(uint256 tokenId, string memory uri) internal {
803         require(_exists(tokenId));
804         _tokenURIs[tokenId] = uri;
805     }
806 
807     /**
808      * @dev Internal function to burn a specific token.
809      * Reverts if the token does not exist.
810      * Deprecated, use _burn(uint256) instead.
811      * @param owner owner of the token to burn
812      * @param tokenId uint256 ID of the token being burned by the msg.sender
813      */
814     function _burn(address owner, uint256 tokenId) internal {
815         super._burn(owner, tokenId);
816 
817         // Clear metadata (if any)
818         if (bytes(_tokenURIs[tokenId]).length != 0) {
819             delete _tokenURIs[tokenId];
820         }
821     }
822 }
823 
824 
825 
826 
827 /**
828  * @title Full ERC721 Token
829  * This implementation includes all the required and some optional functionality of the ERC721 standard
830  * Moreover, it includes approve all functionality using operator terminology
831  * @dev see https://eips.ethereum.org/EIPS/eip-721
832  */
833 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
834     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
835         // solhint-disable-previous-line no-empty-blocks
836     }
837 }
838 
839 /**
840  * @title Ownable
841  * @dev The Ownable contract has an owner address, and provides basic authorization control
842  * functions, this simplifies the implementation of "user permissions".
843  */
844 contract Ownable {
845     address private _owner;
846 
847     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
848 
849     /**
850      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
851      * account.
852      */
853     constructor () internal {
854         _owner = msg.sender;
855         emit OwnershipTransferred(address(0), _owner);
856     }
857 
858     /**
859      * @return the address of the owner.
860      */
861     function owner() public view returns (address) {
862         return _owner;
863     }
864 
865     /**
866      * @dev Throws if called by any account other than the owner.
867      */
868     modifier onlyOwner() {
869         require(isOwner(), "Ownable: caller is not the owner");
870         _;
871     }
872 
873     /**
874      * @return true if `msg.sender` is the owner of the contract.
875      */
876     function isOwner() public view returns (bool) {
877         return msg.sender == _owner;
878     }
879 
880     /**
881      * @dev Allows the current owner to relinquish control of the contract.
882      * It will not be possible to call the functions with the `onlyOwner`
883      * modifier anymore.
884      * @notice Renouncing ownership will leave the contract without an owner,
885      * thereby removing any functionality that is only available to the owner.
886      */
887     function renounceOwnership() public onlyOwner {
888         emit OwnershipTransferred(_owner, address(0));
889         _owner = address(0);
890     }
891 
892     /**
893      * @dev Allows the current owner to transfer control of the contract to a newOwner.
894      * @param newOwner The address to transfer ownership to.
895      */
896     function transferOwnership(address newOwner) public onlyOwner {
897         _transferOwnership(newOwner);
898     }
899 
900     /**
901      * @dev Transfers control of the contract to a newOwner.
902      * @param newOwner The address to transfer ownership to.
903      */
904     function _transferOwnership(address newOwner) internal {
905         require(newOwner != address(0), "Ownable: new owner is the zero address");
906         emit OwnershipTransferred(_owner, newOwner);
907         _owner = newOwner;
908     }
909 }
910 
911 /**
912  * @title Roles
913  * @dev Library for managing addresses assigned to a Role.
914  */
915 library Roles {
916     struct Role {
917         mapping (address => bool) bearer;
918     }
919 
920     /**
921      * @dev Give an account access to this role.
922      */
923     function add(Role storage role, address account) internal {
924         require(!has(role, account));
925 
926         role.bearer[account] = true;
927     }
928 
929     /**
930      * @dev Remove an account's access to this role.
931      */
932     function remove(Role storage role, address account) internal {
933         require(has(role, account));
934 
935         role.bearer[account] = false;
936     }
937 
938     /**
939      * @dev Check if an account has this role.
940      * @return bool
941      */
942     function has(Role storage role, address account) internal view returns (bool) {
943         require(account != address(0));
944         return role.bearer[account];
945     }
946 }
947 
948 
949 contract Governable {
950     using Roles for Roles.Role;
951 
952     event GovernorAdded(address indexed account);
953     event GovernorRemoved(address indexed account);
954 
955     Roles.Role private _governors;
956 
957     constructor () internal {
958         _addGovernor(msg.sender);
959     }
960 
961     modifier onlyGovernor() {
962         require(isGovernor(msg.sender));
963         _;
964     }
965 
966     function isGovernor(address account) public view returns (bool) {
967         return _governors.has(account);
968     }
969 
970     function addGovernor(address account) public onlyGovernor {
971         _addGovernor(account);
972     }
973 
974     function renounceGovernor() public {
975         _removeGovernor(msg.sender);
976     }
977 
978     function _addGovernor(address account) internal {
979         _governors.add(account);
980         emit GovernorAdded(account);
981     }
982 
983     function _removeGovernor(address account) internal {
984         _governors.remove(account);
985         emit GovernorRemoved(account);
986     }
987 }
988 
989 
990 
991 contract GameCardAttributes is ERC721 {
992     // Mapping for token tribe
993     mapping(uint256 => string) private _tokenTribes;
994 
995     // Mapping for token level
996     mapping(uint256 => uint256) private _tokenLevels;
997 
998     // Mapping for token experience
999     mapping(uint256 => uint256) private _tokenExperiences;
1000 
1001     /**
1002      * @dev Returns the tribe of a given token ID.
1003      *      Throws if the token ID does not exist.
1004      * @param tokenId uint256 ID of the token to query
1005      */
1006     function tokenTribe(uint256 tokenId) external view returns (string memory) {
1007         require(_exists(tokenId));
1008         return _tokenTribes[tokenId];
1009     }
1010 
1011     /**
1012      * @dev Returns the level of a given token ID.
1013      *      Throws if the token ID does not exist.
1014      * @param tokenId uint256 ID of the token to query
1015      */
1016     function tokenLevel(uint256 tokenId) external view returns (uint256) {
1017         require(_exists(tokenId));
1018         return _tokenLevels[tokenId];
1019     }
1020 
1021     /**
1022      * @dev Returns the experience of a given token ID.
1023      *      Throws if the token ID does not exist.
1024      * @param tokenId uint256 ID of the token to query
1025      */
1026     function tokenExperience(uint256 tokenId) external view returns (uint256) {
1027         require(_exists(tokenId));
1028         return _tokenExperiences[tokenId];
1029     }
1030 
1031     /**
1032      * @dev Internal function to set the token tribe for a given token.
1033      *      Reverts if the token ID does not exist.
1034      * @param tokenId uint256 ID of the token
1035      * @param tribe srting tribe to assign
1036      */
1037     function _setTokenTribe(uint256 tokenId, string memory tribe) internal {
1038         require(_exists(tokenId));
1039         _tokenTribes[tokenId] = tribe;
1040     }
1041 
1042     /**
1043      * @dev Internal function to set the token level for a given token.
1044      *      Reverts if the token ID does not exist.
1045      * @param tokenId uint256 ID of the token
1046      * @param level uint256 level to assign
1047      */
1048     function _setTokenLevel(uint256 tokenId, uint256 level) internal {
1049         require(_exists(tokenId));
1050         _tokenLevels[tokenId] = level;
1051     }
1052 
1053     /**
1054      * @dev Internal function to set the token experience for a given token.
1055      *      Reverts if the token ID does not exist.
1056      * @param tokenId uint256 ID of the token
1057      * @param experience uint256 experience to assign
1058      */
1059     function _setTokenExperience(uint256 tokenId, uint256 experience) internal {
1060         require(_exists(tokenId));
1061         _tokenExperiences[tokenId] = experience;
1062     }
1063 }
1064 
1065 
1066 
1067 
1068 
1069 
1070 contract GameCardMintable is
1071     ERC721,
1072     ERC721Metadata,
1073     GameCardAttributes,
1074     Governable
1075 {
1076     /**
1077      * @dev Function to mint tokens.
1078      *      Throws if the msg.sender is not governor.
1079      * @param to The address that will receive the minted tokens.
1080      * @param tokenId The token id to mint.
1081      * @param uri The uri of the minted token.
1082      * @param tribe The tribe of the minted token.
1083      * @param level The level of the minted token.
1084      * @param experience The experience of the minted token.
1085      * @return A boolean that indicates if the operation was successful.
1086      */
1087     function mint(
1088         address to,
1089         uint256 tokenId,
1090         string memory uri,
1091         string memory tribe,
1092         uint256 level,
1093         uint256 experience
1094     )
1095         public
1096         onlyGovernor
1097         returns (bool)
1098     {
1099         _mint(to, tokenId);
1100         // ERC721Metadata
1101         _setTokenURI(tokenId, uri);
1102         // GameCardAttributes
1103         _setTokenTribe(tokenId, tribe);
1104         _setTokenLevel(tokenId, level);
1105         _setTokenExperience(tokenId, experience);
1106         return true;
1107     }
1108 
1109     /**
1110      * @dev Function to set the token tribe for a given token.
1111      *      Throws if the msg.sender is not governor.
1112      * @param tokenId uint256 ID of the token
1113      * @param tribe string tribe to assign
1114      * @return A boolean that indicates if the operation was successful.
1115      */
1116     function setTokenTribe(uint256 tokenId, string calldata tribe)
1117         external
1118         onlyGovernor
1119         returns (bool)
1120     {
1121         _setTokenTribe(tokenId, tribe);
1122         return true;
1123     }
1124 
1125     /**
1126      * @dev Function to set the token level for a given token.
1127      *      Throws if the msg.sender is not governor.
1128      * @param tokenId uint256 ID of the token
1129      * @param level uint256 level to assign
1130      * @return A boolean that indicates if the operation was successful.
1131      */
1132     function setTokenLevel(uint256 tokenId, uint256 level)
1133         external
1134         onlyGovernor
1135         returns (bool)
1136     {
1137         _setTokenLevel(tokenId, level);
1138         return true;
1139     }
1140 
1141     /**
1142      * @dev Function to set the token experience for a given token.
1143      *      Throws if the msg.sender is not governor.
1144      * @param tokenId uint256 ID of the token
1145      * @param experience uint256 experience to assign
1146      * @return A boolean that indicates if the operation was successful.
1147      */
1148     function setTokenExperience(uint256 tokenId, uint256 experience)
1149         external
1150         onlyGovernor
1151         returns (bool)
1152     {
1153         _setTokenExperience(tokenId, experience);
1154         return true;
1155     }
1156 }
1157 
1158 
1159 
1160 
1161 
1162 contract GameCard is
1163     ERC721Full,
1164     GameCardMintable,
1165     Ownable
1166 {
1167     constructor(string memory name, string memory symbol)
1168         public
1169         ERC721Full(name, symbol)
1170         Ownable()
1171     {}
1172 }