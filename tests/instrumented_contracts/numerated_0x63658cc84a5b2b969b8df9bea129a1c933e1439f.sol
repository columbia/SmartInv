1 pragma solidity ^0.5.2;
2 
3 
4 
5 interface IERC165 {
6     /**
7      * @notice Query if a contract implements an interface
8      * @param interfaceId The interface identifier, as specified in ERC-165
9      * @dev Interface identification is specified in ERC-165. This function
10      * uses less than 30,000 gas.
11      */
12     function supportsInterface(bytes4 interfaceId) external view returns (bool);
13 }
14 
15 contract ERC165 is IERC165 {
16     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
17     /*
18      * 0x01ffc9a7 ===
19      *     bytes4(keccak256('supportsInterface(bytes4)'))
20      */
21 
22     /**
23      * @dev Mapping of interface ids to whether or not it's supported.
24      */
25     mapping(bytes4 => bool) private _supportedInterfaces;
26 
27     /**
28      * @dev A contract implementing SupportsInterfaceWithLookup
29      * implements ERC165 itself.
30      */
31     constructor () internal {
32         _registerInterface(_INTERFACE_ID_ERC165);
33     }
34 
35     /**
36      * @dev Implement supportsInterface(bytes4) using a lookup table.
37      */
38     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
39         return _supportedInterfaces[interfaceId];
40     }
41 
42     /**
43      * @dev Internal method for registering an interface.
44      */
45     function _registerInterface(bytes4 interfaceId) internal {
46         require(interfaceId != 0xffffffff);
47         _supportedInterfaces[interfaceId] = true;
48     }
49 }
50 
51 
52 library SafeMath {
53     /**
54      * @dev Multiplies two unsigned integers, reverts on overflow.
55      */
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
58         // benefit is lost if 'b' is also tested.
59         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
60         if (a == 0) {
61             return 0;
62         }
63 
64         uint256 c = a * b;
65         require(c / a == b);
66 
67         return c;
68     }
69 
70     /**
71      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
72      */
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Solidity only automatically asserts when dividing by 0
75         require(b > 0);
76         uint256 c = a / b;
77         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78 
79         return c;
80     }
81 
82     /**
83      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
84      */
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(b <= a);
87         uint256 c = a - b;
88 
89         return c;
90     }
91 
92     /**
93      * @dev Adds two unsigned integers, reverts on overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a);
98 
99         return c;
100     }
101 
102     /**
103      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
104      * reverts when dividing by zero.
105      */
106     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
107         require(b != 0);
108         return a % b;
109     }
110 }
111 
112 
113 library Counters {
114     using SafeMath for uint256;
115 
116     struct Counter {
117         // This variable should never be directly accessed by users of the library: interactions must be restricted to
118         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
119         // this feature: see https://github.com/ethereum/solidity/issues/4637
120         uint256 _value; // default: 0
121     }
122 
123     function current(Counter storage counter) internal view returns (uint256) {
124         return counter._value;
125     }
126 
127     function increment(Counter storage counter) internal {
128         counter._value += 1;
129     }
130 
131     function decrement(Counter storage counter) internal {
132         counter._value = counter._value.sub(1);
133     }
134 }
135 
136 contract Ownable {
137     address private _owner;
138 
139     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
140 
141     /**
142      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
143      * account.
144      */
145     constructor () internal {
146         _owner = msg.sender;
147         emit OwnershipTransferred(address(0), _owner);
148     }
149 
150     /**
151      * @return the address of the owner.
152      */
153     function owner() public view returns (address) {
154         return _owner;
155     }
156 
157     /**
158      * @dev Throws if called by any account other than the owner.
159      */
160     modifier onlyOwner() {
161         require(isOwner());
162         _;
163     }
164 
165     /**
166      * @return true if `msg.sender` is the owner of the contract.
167      */
168     function isOwner() public view returns (bool) {
169         return msg.sender == _owner;
170     }
171 
172     /**
173      * @dev Allows the current owner to relinquish control of the contract.
174      * It will not be possible to call the functions with the `onlyOwner`
175      * modifier anymore.
176      * @notice Renouncing ownership will leave the contract without an owner,
177      * thereby removing any functionality that is only available to the owner.
178      */
179     function renounceOwnership() public onlyOwner {
180         emit OwnershipTransferred(_owner, address(0));
181         _owner = address(0);
182     }
183 
184     /**
185      * @dev Allows the current owner to transfer control of the contract to a newOwner.
186      * @param newOwner The address to transfer ownership to.
187      */
188     function transferOwnership(address newOwner) public onlyOwner {
189         _transferOwnership(newOwner);
190     }
191 
192     /**
193      * @dev Transfers control of the contract to a newOwner.
194      * @param newOwner The address to transfer ownership to.
195      */
196     function _transferOwnership(address newOwner) internal {
197         require(newOwner != address(0));
198         emit OwnershipTransferred(_owner, newOwner);
199         _owner = newOwner;
200     }
201 }
202 
203 contract IERC721 is IERC165 {
204     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
205     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
206     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
207 
208     function balanceOf(address owner) public view returns (uint256 balance);
209     function ownerOf(uint256 tokenId) public view returns (address owner);
210 
211     function approve(address to, uint256 tokenId) public;
212     function getApproved(uint256 tokenId) public view returns (address operator);
213 
214     function setApprovalForAll(address operator, bool _approved) public;
215     function isApprovedForAll(address owner, address operator) public view returns (bool);
216 
217     function transferFrom(address from, address to, uint256 tokenId) public;
218     function safeTransferFrom(address from, address to, uint256 tokenId) public;
219 
220     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
221 }
222 
223 contract ERC721 is ERC165, IERC721 {
224     using SafeMath for uint256;
225     using Address for address;
226     using Counters for Counters.Counter;
227 
228     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
229     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
230     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
231 
232     // Mapping from token ID to owner
233     mapping (uint256 => address) private _tokenOwner;
234 
235     // Mapping from token ID to approved address
236     mapping (uint256 => address) private _tokenApprovals;
237 
238     // Mapping from owner to number of owned token
239     mapping (address => Counters.Counter) private _ownedTokensCount;
240 
241     // Mapping from owner to operator approvals
242     mapping (address => mapping (address => bool)) private _operatorApprovals;
243 
244     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
245     /*
246      * 0x80ac58cd ===
247      *     bytes4(keccak256('balanceOf(address)')) ^
248      *     bytes4(keccak256('ownerOf(uint256)')) ^
249      *     bytes4(keccak256('approve(address,uint256)')) ^
250      *     bytes4(keccak256('getApproved(uint256)')) ^
251      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
252      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
253      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
254      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
255      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
256      */
257 
258     constructor () public {
259         // register the supported interfaces to conform to ERC721 via ERC165
260         _registerInterface(_INTERFACE_ID_ERC721);
261     }
262 
263     /**
264      * @dev Gets the balance of the specified address.
265      * @param owner address to query the balance of
266      * @return uint256 representing the amount owned by the passed address
267      */
268     function balanceOf(address owner) public view returns (uint256) {
269         require(owner != address(0));
270         return _ownedTokensCount[owner].current();
271     }
272 
273     /**
274      * @dev Gets the owner of the specified token ID.
275      * @param tokenId uint256 ID of the token to query the owner of
276      * @return address currently marked as the owner of the given token ID
277      */
278     function ownerOf(uint256 tokenId) public view returns (address) {
279         address owner = _tokenOwner[tokenId];
280         require(owner != address(0));
281         return owner;
282     }
283 
284     /**
285      * @dev Approves another address to transfer the given token ID
286      * The zero address indicates there is no approved address.
287      * There can only be one approved address per token at a given time.
288      * Can only be called by the token owner or an approved operator.
289      * @param to address to be approved for the given token ID
290      * @param tokenId uint256 ID of the token to be approved
291      */
292     function approve(address to, uint256 tokenId) public {
293         address owner = ownerOf(tokenId);
294         require(to != owner);
295         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
296 
297         _tokenApprovals[tokenId] = to;
298         emit Approval(owner, to, tokenId);
299     }
300 
301     /**
302      * @dev Gets the approved address for a token ID, or zero if no address set
303      * Reverts if the token ID does not exist.
304      * @param tokenId uint256 ID of the token to query the approval of
305      * @return address currently approved for the given token ID
306      */
307     function getApproved(uint256 tokenId) public view returns (address) {
308         require(_exists(tokenId));
309         return _tokenApprovals[tokenId];
310     }
311 
312     /**
313      * @dev Sets or unsets the approval of a given operator
314      * An operator is allowed to transfer all tokens of the sender on their behalf.
315      * @param to operator address to set the approval
316      * @param approved representing the status of the approval to be set
317      */
318     function setApprovalForAll(address to, bool approved) public {
319         require(to != msg.sender);
320         _operatorApprovals[msg.sender][to] = approved;
321         emit ApprovalForAll(msg.sender, to, approved);
322     }
323 
324     /**
325      * @dev Tells whether an operator is approved by a given owner.
326      * @param owner owner address which you want to query the approval of
327      * @param operator operator address which you want to query the approval of
328      * @return bool whether the given operator is approved by the given owner
329      */
330     function isApprovedForAll(address owner, address operator) public view returns (bool) {
331         return _operatorApprovals[owner][operator];
332     }
333 
334     /**
335      * @dev Transfers the ownership of a given token ID to another address.
336      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
337      * Requires the msg.sender to be the owner, approved, or operator.
338      * @param from current owner of the token
339      * @param to address to receive the ownership of the given token ID
340      * @param tokenId uint256 ID of the token to be transferred
341      */
342     function transferFrom(address from, address to, uint256 tokenId) public {
343         require(_isApprovedOrOwner(msg.sender, tokenId));
344 
345         _transferFrom(from, to, tokenId);
346     }
347 
348     /**
349      * @dev Safely transfers the ownership of a given token ID to another address
350      * If the target address is a contract, it must implement `onERC721Received`,
351      * which is called upon a safe transfer, and return the magic value
352      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
353      * the transfer is reverted.
354      * Requires the msg.sender to be the owner, approved, or operator
355      * @param from current owner of the token
356      * @param to address to receive the ownership of the given token ID
357      * @param tokenId uint256 ID of the token to be transferred
358      */
359     function safeTransferFrom(address from, address to, uint256 tokenId) public {
360         safeTransferFrom(from, to, tokenId, "");
361     }
362 
363     /**
364      * @dev Safely transfers the ownership of a given token ID to another address
365      * If the target address is a contract, it must implement `onERC721Received`,
366      * which is called upon a safe transfer, and return the magic value
367      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
368      * the transfer is reverted.
369      * Requires the msg.sender to be the owner, approved, or operator
370      * @param from current owner of the token
371      * @param to address to receive the ownership of the given token ID
372      * @param tokenId uint256 ID of the token to be transferred
373      * @param _data bytes data to send along with a safe transfer check
374      */
375     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
376         transferFrom(from, to, tokenId);
377         require(_checkOnERC721Received(from, to, tokenId, _data));
378     }
379 
380     /**
381      * @dev Returns whether the specified token exists.
382      * @param tokenId uint256 ID of the token to query the existence of
383      * @return bool whether the token exists
384      */
385     function _exists(uint256 tokenId) internal view returns (bool) {
386         address owner = _tokenOwner[tokenId];
387         return owner != address(0);
388     }
389 
390     /**
391      * @dev Returns whether the given spender can transfer a given token ID.
392      * @param spender address of the spender to query
393      * @param tokenId uint256 ID of the token to be transferred
394      * @return bool whether the msg.sender is approved for the given token ID,
395      * is an operator of the owner, or is the owner of the token
396      */
397     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
398         address owner = ownerOf(tokenId);
399         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
400     }
401 
402     /**
403      * @dev Internal function to mint a new token.
404      * Reverts if the given token ID already exists.
405      * @param to The address that will own the minted token
406      * @param tokenId uint256 ID of the token to be minted
407      */
408     function _mint(address to, uint256 tokenId) internal {
409         require(to != address(0));
410         require(!_exists(tokenId));
411 
412         _tokenOwner[tokenId] = to;
413         _ownedTokensCount[to].increment();
414 
415         emit Transfer(address(0), to, tokenId);
416     }
417 
418     /**
419      * @dev Internal function to burn a specific token.
420      * Reverts if the token does not exist.
421      * Deprecated, use _burn(uint256) instead.
422      * @param owner owner of the token to burn
423      * @param tokenId uint256 ID of the token being burned
424      */
425     function _burn(address owner, uint256 tokenId) internal {
426         require(ownerOf(tokenId) == owner);
427 
428         _clearApproval(tokenId);
429 
430         _ownedTokensCount[owner].decrement();
431         _tokenOwner[tokenId] = address(0);
432 
433         emit Transfer(owner, address(0), tokenId);
434     }
435 
436     /**
437      * @dev Internal function to burn a specific token.
438      * Reverts if the token does not exist.
439      * @param tokenId uint256 ID of the token being burned
440      */
441     function _burn(uint256 tokenId) internal {
442         _burn(ownerOf(tokenId), tokenId);
443     }
444 
445     /**
446      * @dev Internal function to transfer ownership of a given token ID to another address.
447      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
448      * @param from current owner of the token
449      * @param to address to receive the ownership of the given token ID
450      * @param tokenId uint256 ID of the token to be transferred
451      */
452     function _transferFrom(address from, address to, uint256 tokenId) internal {
453         require(ownerOf(tokenId) == from);
454         require(to != address(0));
455 
456         _clearApproval(tokenId);
457 
458         _ownedTokensCount[from].decrement();
459         _ownedTokensCount[to].increment();
460 
461         _tokenOwner[tokenId] = to;
462 
463         emit Transfer(from, to, tokenId);
464     }
465 
466     /**
467      * @dev Internal function to invoke `onERC721Received` on a target address.
468      * The call is not executed if the target address is not a contract.
469      * @param from address representing the previous owner of the given token ID
470      * @param to target address that will receive the tokens
471      * @param tokenId uint256 ID of the token to be transferred
472      * @param _data bytes optional data to send along with the call
473      * @return bool whether the call correctly returned the expected magic value
474      */
475     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
476         internal returns (bool)
477     {
478         if (!to.isContract()) {
479             return true;
480         }
481 
482         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
483         return (retval == _ERC721_RECEIVED);
484     }
485 
486     /**
487      * @dev Private function to clear current approval of a given token ID.
488      * @param tokenId uint256 ID of the token to be transferred
489      */
490     function _clearApproval(uint256 tokenId) private {
491         if (_tokenApprovals[tokenId] != address(0)) {
492             _tokenApprovals[tokenId] = address(0);
493         }
494     }
495 }
496 
497 contract IERC721Enumerable is IERC721 {
498     function totalSupply() public view returns (uint256);
499     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
500 
501     function tokenByIndex(uint256 index) public view returns (uint256);
502 }
503 
504 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
505     // Mapping from owner to list of owned token IDs
506     mapping(address => uint256[]) private _ownedTokens;
507 
508     // Mapping from token ID to index of the owner tokens list
509     mapping(uint256 => uint256) private _ownedTokensIndex;
510 
511     // Array with all token ids, used for enumeration
512     uint256[] private _allTokens;
513 
514     // Mapping from token id to position in the allTokens array
515     mapping(uint256 => uint256) private _allTokensIndex;
516 
517     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
518     /*
519      * 0x780e9d63 ===
520      *     bytes4(keccak256('totalSupply()')) ^
521      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
522      *     bytes4(keccak256('tokenByIndex(uint256)'))
523      */
524 
525     /**
526      * @dev Constructor function.
527      */
528     constructor () public {
529         // register the supported interface to conform to ERC721Enumerable via ERC165
530         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
531     }
532 
533     /**
534      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
535      * @param owner address owning the tokens list to be accessed
536      * @param index uint256 representing the index to be accessed of the requested tokens list
537      * @return uint256 token ID at the given index of the tokens list owned by the requested address
538      */
539     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
540         require(index < balanceOf(owner));
541         return _ownedTokens[owner][index];
542     }
543 
544     /**
545      * @dev Gets the total amount of tokens stored by the contract.
546      * @return uint256 representing the total amount of tokens
547      */
548     function totalSupply() public view returns (uint256) {
549         return _allTokens.length;
550     }
551 
552     /**
553      * @dev Gets the token ID at a given index of all the tokens in this contract
554      * Reverts if the index is greater or equal to the total number of tokens.
555      * @param index uint256 representing the index to be accessed of the tokens list
556      * @return uint256 token ID at the given index of the tokens list
557      */
558     function tokenByIndex(uint256 index) public view returns (uint256) {
559         require(index < totalSupply());
560         return _allTokens[index];
561     }
562 
563     /**
564      * @dev Internal function to transfer ownership of a given token ID to another address.
565      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
566      * @param from current owner of the token
567      * @param to address to receive the ownership of the given token ID
568      * @param tokenId uint256 ID of the token to be transferred
569      */
570     function _transferFrom(address from, address to, uint256 tokenId) internal {
571         super._transferFrom(from, to, tokenId);
572 
573         _removeTokenFromOwnerEnumeration(from, tokenId);
574 
575         _addTokenToOwnerEnumeration(to, tokenId);
576     }
577 
578     /**
579      * @dev Internal function to mint a new token.
580      * Reverts if the given token ID already exists.
581      * @param to address the beneficiary that will own the minted token
582      * @param tokenId uint256 ID of the token to be minted
583      */
584     function _mint(address to, uint256 tokenId) internal {
585         super._mint(to, tokenId);
586 
587         _addTokenToOwnerEnumeration(to, tokenId);
588 
589         _addTokenToAllTokensEnumeration(tokenId);
590     }
591 
592     /**
593      * @dev Internal function to burn a specific token.
594      * Reverts if the token does not exist.
595      * Deprecated, use _burn(uint256) instead.
596      * @param owner owner of the token to burn
597      * @param tokenId uint256 ID of the token being burned
598      */
599     function _burn(address owner, uint256 tokenId) internal {
600         super._burn(owner, tokenId);
601 
602         _removeTokenFromOwnerEnumeration(owner, tokenId);
603         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
604         _ownedTokensIndex[tokenId] = 0;
605 
606         _removeTokenFromAllTokensEnumeration(tokenId);
607     }
608 
609     /**
610      * @dev Gets the list of token IDs of the requested owner.
611      * @param owner address owning the tokens
612      * @return uint256[] List of token IDs owned by the requested address
613      */
614     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
615         return _ownedTokens[owner];
616     }
617 
618     /**
619      * @dev Private function to add a token to this extension's ownership-tracking data structures.
620      * @param to address representing the new owner of the given token ID
621      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
622      */
623     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
624         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
625         _ownedTokens[to].push(tokenId);
626     }
627 
628     /**
629      * @dev Private function to add a token to this extension's token tracking data structures.
630      * @param tokenId uint256 ID of the token to be added to the tokens list
631      */
632     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
633         _allTokensIndex[tokenId] = _allTokens.length;
634         _allTokens.push(tokenId);
635     }
636 
637     /**
638      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
639      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
640      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
641      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
642      * @param from address representing the previous owner of the given token ID
643      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
644      */
645     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
646         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
647         // then delete the last slot (swap and pop).
648 
649         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
650         uint256 tokenIndex = _ownedTokensIndex[tokenId];
651 
652         // When the token to delete is the last token, the swap operation is unnecessary
653         if (tokenIndex != lastTokenIndex) {
654             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
655 
656             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
657             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
658         }
659 
660         // This also deletes the contents at the last position of the array
661         _ownedTokens[from].length--;
662 
663         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
664         // lastTokenId, or just over the end of the array if the token was the last one).
665     }
666 
667     /**
668      * @dev Private function to remove a token from this extension's token tracking data structures.
669      * This has O(1) time complexity, but alters the order of the _allTokens array.
670      * @param tokenId uint256 ID of the token to be removed from the tokens list
671      */
672     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
673         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
674         // then delete the last slot (swap and pop).
675 
676         uint256 lastTokenIndex = _allTokens.length.sub(1);
677         uint256 tokenIndex = _allTokensIndex[tokenId];
678 
679         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
680         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
681         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
682         uint256 lastTokenId = _allTokens[lastTokenIndex];
683 
684         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
685         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
686 
687         // This also deletes the contents at the last position of the array
688         _allTokens.length--;
689         _allTokensIndex[tokenId] = 0;
690     }
691 }
692 
693 contract IERC721Metadata is IERC721 {
694     function name() external view returns (string memory);
695     function symbol() external view returns (string memory);
696     function tokenURI(uint256 tokenId) external view returns (string memory);
697 }
698 
699 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
700     // Token name
701     string private _name;
702 
703     // Token symbol
704     string private _symbol;
705 
706     // Optional mapping for token URIs
707     mapping(uint256 => string) private _tokenURIs;
708 
709     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
710     /*
711      * 0x5b5e139f ===
712      *     bytes4(keccak256('name()')) ^
713      *     bytes4(keccak256('symbol()')) ^
714      *     bytes4(keccak256('tokenURI(uint256)'))
715      */
716 
717     /**
718      * @dev Constructor function
719      */
720     constructor (string memory name, string memory symbol) public {
721         _name = name;
722         _symbol = symbol;
723 
724         // register the supported interfaces to conform to ERC721 via ERC165
725         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
726     }
727 
728     /**
729      * @dev Gets the token name.
730      * @return string representing the token name
731      */
732     function name() external view returns (string memory) {
733         return _name;
734     }
735 
736     /**
737      * @dev Gets the token symbol.
738      * @return string representing the token symbol
739      */
740     function symbol() external view returns (string memory) {
741         return _symbol;
742     }
743 
744     /**
745      * @dev Returns an URI for a given token ID.
746      * Throws if the token ID does not exist. May return an empty string.
747      * @param tokenId uint256 ID of the token to query
748      */
749     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
750         require(_exists(tokenId));
751         return _tokenURIs[tokenId];
752     }
753 
754     /**
755      * @dev Internal function to set the token URI for a given token.
756      * Reverts if the token ID does not exist.
757      * @param tokenId uint256 ID of the token to set its URI
758      * @param uri string URI to assign
759      */
760     function _setTokenURI(uint256 tokenId, string memory uri) internal {
761         require(_exists(tokenId));
762         _tokenURIs[tokenId] = uri;
763     }
764 
765     /**
766      * @dev Internal function to burn a specific token.
767      * Reverts if the token does not exist.
768      * Deprecated, use _burn(uint256) instead.
769      * @param owner owner of the token to burn
770      * @param tokenId uint256 ID of the token being burned by the msg.sender
771      */
772     function _burn(address owner, uint256 tokenId) internal {
773         super._burn(owner, tokenId);
774 
775         // Clear metadata (if any)
776         if (bytes(_tokenURIs[tokenId]).length != 0) {
777             delete _tokenURIs[tokenId];
778         }
779     }
780 }
781 contract IERC721Receiver {
782     /**
783      * @notice Handle the receipt of an NFT
784      * @dev The ERC721 smart contract calls this function on the recipient
785      * after a `safeTransfer`. This function MUST return the function selector,
786      * otherwise the caller will revert the transaction. The selector to be
787      * returned can be obtained as `this.onERC721Received.selector`. This
788      * function MAY throw to revert and reject the transfer.
789      * Note: the ERC721 contract address is always the message sender.
790      * @param operator The address which called `safeTransferFrom` function
791      * @param from The address which previously owned the token
792      * @param tokenId The NFT identifier which is being transferred
793      * @param data Additional data with no specified format
794      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
795      */
796     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
797     public returns (bytes4);
798 }
799 
800 library Address {
801     /**
802      * Returns whether the target address is a contract
803      * @dev This function will return false if invoked during the constructor of a contract,
804      * as the code is not actually created until after the constructor finishes.
805      * @param account address of the account to check
806      * @return whether the target address is a contract
807      */
808     function isContract(address account) internal view returns (bool) {
809         uint256 size;
810         // XXX Currently there is no better way to check if there is a contract in an address
811         // than to check the size of the code at that address.
812         // See https://ethereum.stackexchange.com/a/14016/36603
813         // for more details about how this works.
814         // TODO Check this again before the Serenity release, because all addresses will be
815         // contracts then.
816         // solhint-disable-next-line no-inline-assembly
817         assembly { size := extcodesize(account) }
818         return size > 0;
819     }
820 }
821 
822 
823 /*
824 FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE
825 FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE
826 FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE
827 
828 FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE
829 FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE
830 FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE
831 
832 FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE
833 FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE
834 FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE
835 
836 FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE
837 FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE
838 FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE FUNGLE
839 */
840 
841 
842 contract kleee002 is ERC721, ERC721Enumerable, ERC721Metadata, Ownable {
843 
844 
845     uint256 public liveTokenId;
846 
847     uint public price = 100000000000000000;
848 
849     //mapping(uint256 => bytes32) private token2hash;
850     //mapping(uint256 => string) private _tokenMSGs;
851 
852     string public info = "TEXT";
853     bool public infohasnotbeenset = true;
854 
855     string public baseTokenURI = "https://fungle.xyz/tokenURI.php?id=";
856 
857     address private constant minter = 0x1003d51FeF31E52262B1E699f03C789cA6dbEfDC;
858 
859     address payable private constant payrollArtist1 = 0x4257D02E2854C9c86d6975FCd14a1aF4FA65a652;
860     address payable private constant payrollArtist2 = 0x2ea533314069dC9B4dF29E72bD1dFB64cC68456d;
861 
862 
863     event PaymentReceived(address from, uint256 amount);
864     event TokenMinted(address owner, uint256 tokenId);
865 
866     constructor () public ERC721Metadata("KLEEE02", "KLE2") {
867         // solhint-disable-previous-line no-empty-blocks
868     }
869 
870     /**************************************************************************
871     * modifiers
872     ***************************************************************************/
873 
874     modifier onlyMinterAndOwner {
875         require(msg.sender == minter || isOwner() );
876         _;
877     }
878 
879     modifier costs(uint price_) {
880        if (msg.value >= price_) {
881            _;
882        }
883    }
884 
885 
886     /**************************************************************************
887     * Overrides
888     ***************************************************************************/
889 
890 
891 
892     function tokenURI(uint256 tokenId) external view returns (string memory) {
893         require(_exists(tokenId));
894         return strConcat(
895             baseTokenURI,
896             _tokenURI(tokenId)
897         );
898     }
899 
900 
901     /**************************************************************************
902     * functionS
903     ***************************************************************************/
904     function strConcat(string memory a, string memory b) internal pure returns (string memory) {
905         return string(abi.encodePacked(a, b));
906     }
907 
908     function nextTokenId() internal returns(uint256) {
909       liveTokenId = liveTokenId + 1;
910       return liveTokenId;
911     }
912 
913 
914     function () external payable costs(price){
915 
916         payrollArtist1.transfer(msg.value/2);
917         payrollArtist2.transfer(msg.value/2);
918 
919         emit PaymentReceived(msg.sender, msg.value);
920 
921         ___mint(msg.sender);
922     }
923 
924 
925     function createToken(address newowner)
926         onlyMinterAndOwner
927         public
928         returns(string memory)
929     {
930 
931       //hash the color data
932       //bytes32 colordatahash = keccak256(abi.encodePacked(data));
933       ___mint(newowner);
934 
935     }
936 
937 
938     //mint a new token
939     function ___mint(address newowner)
940       internal
941       {
942 
943         //limit the totalSupply
944         require(liveTokenId<=360);
945 
946         uint256 newTokenId = nextTokenId();
947 
948         //mint new token
949         _mint(newowner, newTokenId);
950         _setTokenURI(newTokenId, uint2str(newTokenId));
951 
952         emit TokenMinted(newowner, newTokenId);
953 
954         //2 DO price maths
955         price = price + price/75;
956 
957       }
958 
959 
960     function changeInfo(string memory newstring)
961       public
962       onlyOwner
963     {
964       require(infohasnotbeenset);
965       info = newstring;
966       infohasnotbeenset = false;
967     }
968 
969     function changeBaseTokenURI(string memory newstring)
970       public
971       onlyOwner
972     {
973       baseTokenURI = newstring;
974     }
975 
976 
977     function uint2str(uint _i)
978       internal
979       pure
980       returns (string memory _uintAsString)
981     {
982       if (_i == 0) {
983           return "0";
984       }
985       uint j = _i;
986       uint len;
987       while (j != 0) {
988           len++;
989           j /= 10;
990       }
991       bytes memory bstr = new bytes(len);
992       uint k = len - 1;
993       while (_i != 0) {
994           bstr[k--] = byte(uint8(48 + _i % 10));
995           _i /= 10;
996       }
997       return string(bstr);
998     }
999 
1000 
1001 }