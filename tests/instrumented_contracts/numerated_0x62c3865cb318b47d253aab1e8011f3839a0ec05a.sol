1 pragma solidity ^0.5.2;
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
17 /**
18  * @title ERC165
19  * @author Matt Condon (@shrugs)
20  * @dev Implements ERC165 using a lookup table.
21  */
22 contract ERC165 is IERC165 {
23     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
24     /*
25      * 0x01ffc9a7 ===
26      *     bytes4(keccak256('supportsInterface(bytes4)'))
27      */
28 
29     /**
30      * @dev a mapping of interface id to whether or not it's supported
31      */
32     mapping(bytes4 => bool) private _supportedInterfaces;
33 
34     /**
35      * @dev A contract implementing SupportsInterfaceWithLookup
36      * implement ERC165 itself
37      */
38     constructor () internal {
39         _registerInterface(_INTERFACE_ID_ERC165);
40     }
41 
42     /**
43      * @dev implement supportsInterface(bytes4) using a lookup table
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
46         return _supportedInterfaces[interfaceId];
47     }
48 
49     /**
50      * @dev internal method for registering an interface
51      */
52     function _registerInterface(bytes4 interfaceId) internal {
53         require(interfaceId != 0xffffffff);
54         _supportedInterfaces[interfaceId] = true;
55     }
56 }
57 
58 /**
59  * @title ERC721 Non-Fungible Token Standard basic interface
60  * @dev see https://eips.ethereum.org/EIPS/eip-721
61  */
62 contract IERC721 is IERC165 {
63     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
64     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
65     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
66 
67     function balanceOf(address owner) public view returns (uint256 balance);
68     function ownerOf(uint256 tokenId) public view returns (address owner);
69 
70     function approve(address to, uint256 tokenId) public;
71     function getApproved(uint256 tokenId) public view returns (address operator);
72 
73     function setApprovalForAll(address operator, bool _approved) public;
74     function isApprovedForAll(address owner, address operator) public view returns (bool);
75 
76     function transferFrom(address from, address to, uint256 tokenId) public;
77     function safeTransferFrom(address from, address to, uint256 tokenId) public;
78 
79     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
80 }
81 
82 /**
83  * @title ERC721 token receiver interface
84  * @dev Interface for any contract that wants to support safeTransfers
85  * from ERC721 asset contracts.
86  */
87 contract IERC721Receiver {
88     /**
89      * @notice Handle the receipt of an NFT
90      * @dev The ERC721 smart contract calls this function on the recipient
91      * after a `safeTransfer`. This function MUST return the function selector,
92      * otherwise the caller will revert the transaction. The selector to be
93      * returned can be obtained as `this.onERC721Received.selector`. This
94      * function MAY throw to revert and reject the transfer.
95      * Note: the ERC721 contract address is always the message sender.
96      * @param operator The address which called `safeTransferFrom` function
97      * @param from The address which previously owned the token
98      * @param tokenId The NFT identifier which is being transferred
99      * @param data Additional data with no specified format
100      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
101      */
102     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
103     public returns (bytes4);
104 }
105 /**
106  * @title Math
107  * @dev Assorted math operations
108  */
109 library Math {
110     /**
111      * @dev Returns the largest of two numbers.
112      */
113     function max(uint256 a, uint256 b) internal pure returns (uint256) {
114         return a >= b ? a : b;
115     }
116 
117     /**
118      * @dev Returns the smallest of two numbers.
119      */
120     function min(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a < b ? a : b;
122     }
123 
124     /**
125      * @dev Calculates the average of two numbers. Since these are integers,
126      * averages of an even and odd number cannot be represented, and will be
127      * rounded down.
128      */
129     function average(uint256 a, uint256 b) internal pure returns (uint256) {
130         // (a + b) / 2 can overflow, so we distribute
131         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
132     }
133 }
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
158 /**
159  * @title SafeMath
160  * @dev Unsigned math operations with safety checks that revert on error
161  */
162 library SafeMath {
163     /**
164      * @dev Multiplies two unsigned integers, reverts on overflow.
165      */
166     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168         // benefit is lost if 'b' is also tested.
169         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
170         if (a == 0) {
171             return 0;
172         }
173 
174         uint256 c = a * b;
175         require(c / a == b);
176 
177         return c;
178     }
179 
180     /**
181      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         // Solidity only automatically asserts when dividing by 0
185         require(b > 0);
186         uint256 c = a / b;
187         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
188 
189         return c;
190     }
191 
192     /**
193      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
194      */
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         require(b <= a);
197         uint256 c = a - b;
198 
199         return c;
200     }
201 
202     /**
203      * @dev Adds two unsigned integers, reverts on overflow.
204      */
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         uint256 c = a + b;
207         require(c >= a);
208 
209         return c;
210     }
211 
212     /**
213      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
214      * reverts when dividing by zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         require(b != 0);
218         return a % b;
219     }
220 }
221 
222 /**
223  * @title Counters
224  * @author Matt Condon (@shrugs)
225  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
226  * of elements in a mapping, issuing ERC721 ids, or counting request ids
227  *
228  * Include with `using Counters for Counters.Counter;`
229  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
230  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
231  * directly accessed.
232  */
233 library Counters {
234     using SafeMath for uint256;
235 
236     struct Counter {
237         // This variable should never be directly accessed by users of the library: interactions must be restricted to
238         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
239         // this feature: see https://github.com/ethereum/solidity/issues/4637
240         uint256 _value; // default: 0
241     }
242 
243     function current(Counter storage counter) internal view returns (uint256) {
244         return counter._value;
245     }
246 
247     function increment(Counter storage counter) internal {
248         counter._value += 1;
249     }
250 
251     function decrement(Counter storage counter) internal {
252         counter._value = counter._value.sub(1);
253     }
254 }
255 
256 /**
257  * @title ERC721 Non-Fungible Token Standard basic implementation
258  * @dev see https://eips.ethereum.org/EIPS/eip-721
259  */
260 contract ERC721 is ERC165, IERC721 {
261     using SafeMath for uint256;
262     using Address for address;
263     using Counters for Counters.Counter;
264 
265     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
266     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
267     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
268 
269     // Mapping from token ID to owner
270     mapping (uint256 => address) private _tokenOwner;
271 
272     // Mapping from token ID to approved address
273     mapping (uint256 => address) private _tokenApprovals;
274 
275     // Mapping from owner to number of owned token
276     mapping (address => Counters.Counter) private _ownedTokensCount;
277 
278     // Mapping from owner to operator approvals
279     mapping (address => mapping (address => bool)) private _operatorApprovals;
280 
281     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
282     /*
283      * 0x80ac58cd ===
284      *     bytes4(keccak256('balanceOf(address)')) ^
285      *     bytes4(keccak256('ownerOf(uint256)')) ^
286      *     bytes4(keccak256('approve(address,uint256)')) ^
287      *     bytes4(keccak256('getApproved(uint256)')) ^
288      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
289      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
290      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
291      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
292      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
293      */
294 
295     constructor () public {
296         // register the supported interfaces to conform to ERC721 via ERC165
297         _registerInterface(_INTERFACE_ID_ERC721);
298     }
299 
300     /**
301      * @dev Gets the balance of the specified address
302      * @param owner address to query the balance of
303      * @return uint256 representing the amount owned by the passed address
304      */
305     function balanceOf(address owner) public view returns (uint256) {
306         require(owner != address(0));
307         return _ownedTokensCount[owner].current();
308     }
309 
310     /**
311      * @dev Gets the owner of the specified token ID
312      * @param tokenId uint256 ID of the token to query the owner of
313      * @return address currently marked as the owner of the given token ID
314      */
315     function ownerOf(uint256 tokenId) public view returns (address) {
316         address owner = _tokenOwner[tokenId];
317         require(owner != address(0));
318         return owner;
319     }
320 
321     /**
322      * @dev Approves another address to transfer the given token ID
323      * The zero address indicates there is no approved address.
324      * There can only be one approved address per token at a given time.
325      * Can only be called by the token owner or an approved operator.
326      * @param to address to be approved for the given token ID
327      * @param tokenId uint256 ID of the token to be approved
328      */
329     function approve(address to, uint256 tokenId) public {
330         address owner = ownerOf(tokenId);
331         require(to != owner);
332         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
333 
334         _tokenApprovals[tokenId] = to;
335         emit Approval(owner, to, tokenId);
336     }
337 
338     /**
339      * @dev Gets the approved address for a token ID, or zero if no address set
340      * Reverts if the token ID does not exist.
341      * @param tokenId uint256 ID of the token to query the approval of
342      * @return address currently approved for the given token ID
343      */
344     function getApproved(uint256 tokenId) public view returns (address) {
345         require(_exists(tokenId));
346         return _tokenApprovals[tokenId];
347     }
348 
349     /**
350      * @dev Sets or unsets the approval of a given operator
351      * An operator is allowed to transfer all tokens of the sender on their behalf
352      * @param to operator address to set the approval
353      * @param approved representing the status of the approval to be set
354      */
355     function setApprovalForAll(address to, bool approved) public {
356         require(to != msg.sender);
357         _operatorApprovals[msg.sender][to] = approved;
358         emit ApprovalForAll(msg.sender, to, approved);
359     }
360 
361     /**
362      * @dev Tells whether an operator is approved by a given owner
363      * @param owner owner address which you want to query the approval of
364      * @param operator operator address which you want to query the approval of
365      * @return bool whether the given operator is approved by the given owner
366      */
367     function isApprovedForAll(address owner, address operator) public view returns (bool) {
368         return _operatorApprovals[owner][operator];
369     }
370 
371     /**
372      * @dev Transfers the ownership of a given token ID to another address
373      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
374      * Requires the msg.sender to be the owner, approved, or operator
375      * @param from current owner of the token
376      * @param to address to receive the ownership of the given token ID
377      * @param tokenId uint256 ID of the token to be transferred
378      */
379     function transferFrom(address from, address to, uint256 tokenId) public {
380         require(_isApprovedOrOwner(msg.sender, tokenId));
381 
382         _transferFrom(from, to, tokenId);
383     }
384 
385     /**
386      * @dev Safely transfers the ownership of a given token ID to another address
387      * If the target address is a contract, it must implement `onERC721Received`,
388      * which is called upon a safe transfer, and return the magic value
389      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
390      * the transfer is reverted.
391      * Requires the msg.sender to be the owner, approved, or operator
392      * @param from current owner of the token
393      * @param to address to receive the ownership of the given token ID
394      * @param tokenId uint256 ID of the token to be transferred
395      */
396     function safeTransferFrom(address from, address to, uint256 tokenId) public {
397         safeTransferFrom(from, to, tokenId, "");
398     }
399 
400     /**
401      * @dev Safely transfers the ownership of a given token ID to another address
402      * If the target address is a contract, it must implement `onERC721Received`,
403      * which is called upon a safe transfer, and return the magic value
404      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
405      * the transfer is reverted.
406      * Requires the msg.sender to be the owner, approved, or operator
407      * @param from current owner of the token
408      * @param to address to receive the ownership of the given token ID
409      * @param tokenId uint256 ID of the token to be transferred
410      * @param _data bytes data to send along with a safe transfer check
411      */
412     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
413         transferFrom(from, to, tokenId);
414         require(_checkOnERC721Received(from, to, tokenId, _data));
415     }
416 
417     /**
418      * @dev Returns whether the specified token exists
419      * @param tokenId uint256 ID of the token to query the existence of
420      * @return bool whether the token exists
421      */
422     function _exists(uint256 tokenId) internal view returns (bool) {
423         address owner = _tokenOwner[tokenId];
424         return owner != address(0);
425     }
426 
427     /**
428      * @dev Returns whether the given spender can transfer a given token ID
429      * @param spender address of the spender to query
430      * @param tokenId uint256 ID of the token to be transferred
431      * @return bool whether the msg.sender is approved for the given token ID,
432      * is an operator of the owner, or is the owner of the token
433      */
434     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
435         address owner = ownerOf(tokenId);
436         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
437     }
438 
439     /**
440      * @dev Internal function to mint a new token
441      * Reverts if the given token ID already exists
442      * @param to The address that will own the minted token
443      * @param tokenId uint256 ID of the token to be minted
444      */
445     function _mint(address to, uint256 tokenId) internal {
446         require(to != address(0));
447         require(!_exists(tokenId));
448 
449         _tokenOwner[tokenId] = to;
450         _ownedTokensCount[to].increment();
451 
452         emit Transfer(address(0), to, tokenId);
453     }
454 
455     /**
456      * @dev Internal function to burn a specific token
457      * Reverts if the token does not exist
458      * Deprecated, use _burn(uint256) instead.
459      * @param owner owner of the token to burn
460      * @param tokenId uint256 ID of the token being burned
461      */
462     function _burn(address owner, uint256 tokenId) internal {
463         require(ownerOf(tokenId) == owner);
464 
465         _clearApproval(tokenId);
466 
467         _ownedTokensCount[owner].decrement();
468         _tokenOwner[tokenId] = address(0);
469 
470         emit Transfer(owner, address(0), tokenId);
471     }
472 
473     /**
474      * @dev Internal function to burn a specific token
475      * Reverts if the token does not exist
476      * @param tokenId uint256 ID of the token being burned
477      */
478     function _burn(uint256 tokenId) internal {
479         _burn(ownerOf(tokenId), tokenId);
480     }
481 
482     /**
483      * @dev Internal function to transfer ownership of a given token ID to another address.
484      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
485      * @param from current owner of the token
486      * @param to address to receive the ownership of the given token ID
487      * @param tokenId uint256 ID of the token to be transferred
488      */
489     function _transferFrom(address from, address to, uint256 tokenId) internal {
490         require(ownerOf(tokenId) == from);
491         require(to != address(0));
492 
493         _clearApproval(tokenId);
494 
495         _ownedTokensCount[from].decrement();
496         _ownedTokensCount[to].increment();
497 
498         _tokenOwner[tokenId] = to;
499 
500         emit Transfer(from, to, tokenId);
501     }
502 
503     /**
504      * @dev Internal function to invoke `onERC721Received` on a target address
505      * The call is not executed if the target address is not a contract
506      * @param from address representing the previous owner of the given token ID
507      * @param to target address that will receive the tokens
508      * @param tokenId uint256 ID of the token to be transferred
509      * @param _data bytes optional data to send along with the call
510      * @return bool whether the call correctly returned the expected magic value
511      */
512     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
513     internal returns (bool)
514     {
515         if (!to.isContract()) {
516             return true;
517         }
518 
519         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
520         return (retval == _ERC721_RECEIVED);
521     }
522 
523     /**
524      * @dev Private function to clear current approval of a given token ID
525      * @param tokenId uint256 ID of the token to be transferred
526      */
527     function _clearApproval(uint256 tokenId) private {
528         if (_tokenApprovals[tokenId] != address(0)) {
529             _tokenApprovals[tokenId] = address(0);
530         }
531     }
532 }
533 
534 /**
535  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
536  * @dev See https://eips.ethereum.org/EIPS/eip-721
537  */
538 contract IERC721Enumerable is IERC721 {
539     function totalSupply() public view returns (uint256);
540     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
541 
542     function tokenByIndex(uint256 index) public view returns (uint256);
543 }
544 /**
545  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
546  * @dev See https://eips.ethereum.org/EIPS/eip-721
547  */
548 contract IERC721Metadata is IERC721 {
549     function name() external view returns (string memory);
550     function symbol() external view returns (string memory);
551     function tokenURI(uint256 tokenId) external view returns (string memory);
552 }
553 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
554     // Token name
555     string private _name;
556 
557     // Token symbol
558     string private _symbol;
559 
560     // Optional mapping for token URIs
561     mapping(uint256 => string) private _tokenURIs;
562 
563     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
564     /*
565      * 0x5b5e139f ===
566      *     bytes4(keccak256('name()')) ^
567      *     bytes4(keccak256('symbol()')) ^
568      *     bytes4(keccak256('tokenURI(uint256)'))
569      */
570 
571     /**
572      * @dev Constructor function
573      */
574     constructor (string memory name, string memory symbol) public {
575         _name = name;
576         _symbol = symbol;
577 
578         // register the supported interfaces to conform to ERC721 via ERC165
579         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
580     }
581 
582     /**
583      * @dev Gets the token name
584      * @return string representing the token name
585      */
586     function name() external view returns (string memory) {
587         return _name;
588     }
589 
590     /**
591      * @dev Gets the token symbol
592      * @return string representing the token symbol
593      */
594     function symbol() external view returns (string memory) {
595         return _symbol;
596     }
597 
598     /**
599      * @dev Returns an URI for a given token ID
600      * Throws if the token ID does not exist. May return an empty string.
601      * @param tokenId uint256 ID of the token to query
602      */
603     function tokenURI(uint256 tokenId) external view returns (string memory) {
604         require(_exists(tokenId));
605         return _tokenURIs[tokenId];
606     }
607 
608     /**
609      * @dev Internal function to set the token URI for a given token
610      * Reverts if the token ID does not exist
611      * @param tokenId uint256 ID of the token to set its URI
612      * @param uri string URI to assign
613      */
614     function _setTokenURI(uint256 tokenId, string memory uri) internal {
615         require(_exists(tokenId));
616         _tokenURIs[tokenId] = uri;
617     }
618 
619     /**
620      * @dev Internal function to burn a specific token
621      * Reverts if the token does not exist
622      * Deprecated, use _burn(uint256) instead
623      * @param owner owner of the token to burn
624      * @param tokenId uint256 ID of the token being burned by the msg.sender
625      */
626     function _burn(address owner, uint256 tokenId) internal {
627         super._burn(owner, tokenId);
628 
629         // Clear metadata (if any)
630         if (bytes(_tokenURIs[tokenId]).length != 0) {
631             delete _tokenURIs[tokenId];
632         }
633     }
634 }
635 
636 /**
637  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
638  * @dev See https://eips.ethereum.org/EIPS/eip-721
639  */
640 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
641     // Mapping from owner to list of owned token IDs
642     mapping(address => uint256[]) private _ownedTokens;
643 
644     // Mapping from token ID to index of the owner tokens list
645     mapping(uint256 => uint256) private _ownedTokensIndex;
646 
647     // Array with all token ids, used for enumeration
648     uint256[] private _allTokens;
649 
650     // Mapping from token id to position in the allTokens array
651     mapping(uint256 => uint256) private _allTokensIndex;
652 
653     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
654     /*
655      * 0x780e9d63 ===
656      *     bytes4(keccak256('totalSupply()')) ^
657      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
658      *     bytes4(keccak256('tokenByIndex(uint256)'))
659      */
660 
661     /**
662      * @dev Constructor function
663      */
664     constructor () public {
665         // register the supported interface to conform to ERC721Enumerable via ERC165
666         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
667     }
668 
669     /**
670      * @dev Gets the token ID at a given index of the tokens list of the requested owner
671      * @param owner address owning the tokens list to be accessed
672      * @param index uint256 representing the index to be accessed of the requested tokens list
673      * @return uint256 token ID at the given index of the tokens list owned by the requested address
674      */
675     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
676         require(index < balanceOf(owner));
677         return _ownedTokens[owner][index];
678     }
679 
680     /**
681      * @dev Gets the total amount of tokens stored by the contract
682      * @return uint256 representing the total amount of tokens
683      */
684     function totalSupply() public view returns (uint256) {
685         return _allTokens.length;
686     }
687 
688     /**
689      * @dev Gets the token ID at a given index of all the tokens in this contract
690      * Reverts if the index is greater or equal to the total number of tokens
691      * @param index uint256 representing the index to be accessed of the tokens list
692      * @return uint256 token ID at the given index of the tokens list
693      */
694     function tokenByIndex(uint256 index) public view returns (uint256) {
695         require(index < totalSupply());
696         return _allTokens[index];
697     }
698 
699     /**
700      * @dev Internal function to transfer ownership of a given token ID to another address.
701      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
702      * @param from current owner of the token
703      * @param to address to receive the ownership of the given token ID
704      * @param tokenId uint256 ID of the token to be transferred
705      */
706     function _transferFrom(address from, address to, uint256 tokenId) internal {
707         super._transferFrom(from, to, tokenId);
708 
709         _removeTokenFromOwnerEnumeration(from, tokenId);
710 
711         _addTokenToOwnerEnumeration(to, tokenId);
712     }
713 
714     /**
715      * @dev Internal function to mint a new token
716      * Reverts if the given token ID already exists
717      * @param to address the beneficiary that will own the minted token
718      * @param tokenId uint256 ID of the token to be minted
719      */
720     function _mint(address to, uint256 tokenId) internal {
721         super._mint(to, tokenId);
722 
723         _addTokenToOwnerEnumeration(to, tokenId);
724 
725         _addTokenToAllTokensEnumeration(tokenId);
726     }
727 
728     /**
729      * @dev Internal function to burn a specific token
730      * Reverts if the token does not exist
731      * Deprecated, use _burn(uint256) instead
732      * @param owner owner of the token to burn
733      * @param tokenId uint256 ID of the token being burned
734      */
735     function _burn(address owner, uint256 tokenId) internal {
736         super._burn(owner, tokenId);
737 
738         _removeTokenFromOwnerEnumeration(owner, tokenId);
739         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
740         _ownedTokensIndex[tokenId] = 0;
741 
742         _removeTokenFromAllTokensEnumeration(tokenId);
743     }
744 
745     /**
746      * @dev Gets the list of token IDs of the requested owner
747      * @param owner address owning the tokens
748      * @return uint256[] List of token IDs owned by the requested address
749      */
750     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
751         return _ownedTokens[owner];
752     }
753 
754     /**
755      * @dev Private function to add a token to this extension's ownership-tracking data structures.
756      * @param to address representing the new owner of the given token ID
757      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
758      */
759     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
760         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
761         _ownedTokens[to].push(tokenId);
762     }
763 
764     /**
765      * @dev Private function to add a token to this extension's token tracking data structures.
766      * @param tokenId uint256 ID of the token to be added to the tokens list
767      */
768     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
769         _allTokensIndex[tokenId] = _allTokens.length;
770         _allTokens.push(tokenId);
771     }
772 
773     /**
774      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
775      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
776      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
777      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
778      * @param from address representing the previous owner of the given token ID
779      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
780      */
781     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
782         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
783         // then delete the last slot (swap and pop).
784 
785         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
786         uint256 tokenIndex = _ownedTokensIndex[tokenId];
787 
788         // When the token to delete is the last token, the swap operation is unnecessary
789         if (tokenIndex != lastTokenIndex) {
790             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
791 
792             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
793             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
794         }
795 
796         // This also deletes the contents at the last position of the array
797         _ownedTokens[from].length--;
798 
799         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
800         // lastTokenId, or just over the end of the array if the token was the last one).
801     }
802 
803     /**
804      * @dev Private function to remove a token from this extension's token tracking data structures.
805      * This has O(1) time complexity, but alters the order of the _allTokens array.
806      * @param tokenId uint256 ID of the token to be removed from the tokens list
807      */
808     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
809         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
810         // then delete the last slot (swap and pop).
811 
812         uint256 lastTokenIndex = _allTokens.length.sub(1);
813         uint256 tokenIndex = _allTokensIndex[tokenId];
814 
815         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
816         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
817         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
818         uint256 lastTokenId = _allTokens[lastTokenIndex];
819 
820         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
821         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
822 
823         // This also deletes the contents at the last position of the array
824         _allTokens.length--;
825         _allTokensIndex[tokenId] = 0;
826     }
827 }
828 /**
829  * @title Full ERC721 Token
830  * This implementation includes all the required and some optional functionality of the ERC721 standard
831  * Moreover, it includes approve all functionality using operator terminology
832  * @dev see https://eips.ethereum.org/EIPS/eip-721
833  */
834 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
835     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
836         // solhint-disable-previous-line no-empty-blocks
837     }
838 }
839 
840 /**
841  * @title Ownable
842  * @dev The Ownable contract has an owner address, and provides basic authorization control
843  * functions, this simplifies the implementation of "user permissions".
844  */
845 contract Ownable {
846     address private _owner;
847 
848     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
849 
850     /**
851      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
852      * account.
853      */
854     constructor () internal {
855         _owner = msg.sender;
856         emit OwnershipTransferred(address(0), _owner);
857     }
858 
859     /**
860      * @return the address of the owner.
861      */
862     function owner() public view returns (address) {
863         return _owner;
864     }
865 
866     /**
867      * @dev Throws if called by any account other than the owner.
868      */
869     modifier onlyOwner() {
870         require(isOwner());
871         _;
872     }
873 
874     /**
875      * @return true if `msg.sender` is the owner of the contract.
876      */
877     function isOwner() public view returns (bool) {
878         return msg.sender == _owner;
879     }
880 
881     /**
882      * @dev Allows the current owner to relinquish control of the contract.
883      * It will not be possible to call the functions with the `onlyOwner`
884      * modifier anymore.
885      * @notice Renouncing ownership will leave the contract without an owner,
886      * thereby removing any functionality that is only available to the owner.
887      */
888     function renounceOwnership() public onlyOwner {
889         emit OwnershipTransferred(_owner, address(0));
890         _owner = address(0);
891     }
892 
893     /**
894      * @dev Allows the current owner to transfer control of the contract to a newOwner.
895      * @param newOwner The address to transfer ownership to.
896      */
897     function transferOwnership(address newOwner) public onlyOwner {
898         _transferOwnership(newOwner);
899     }
900 
901     /**
902      * @dev Transfers control of the contract to a newOwner.
903      * @param newOwner The address to transfer ownership to.
904      */
905     function _transferOwnership(address newOwner) internal {
906         require(newOwner != address(0));
907         emit OwnershipTransferred(_owner, newOwner);
908         _owner = newOwner;
909     }
910 }
911 
912 library Strings {
913 
914     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
915     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
916         bytes memory _ba = bytes(_a);
917         bytes memory _bb = bytes(_b);
918         bytes memory _bc = bytes(_c);
919         bytes memory _bd = bytes(_d);
920         bytes memory _be = bytes(_e);
921         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
922         bytes memory babcde = bytes(abcde);
923         uint k = 0;
924         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
925         for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
926         for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
927         for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
928         for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
929         return string(babcde);
930     }
931 
932     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
933         return strConcat(_a, _b, _c, _d, "");
934     }
935 
936     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
937         return strConcat(_a, _b, _c, "", "");
938     }
939 
940     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
941         return strConcat(_a, _b, "", "", "");
942     }
943 
944     function uint2str(uint i) internal pure returns (string memory) {
945         if (i == 0) return "0";
946         uint j = i;
947         uint len;
948         while (j != 0){
949             len++;
950             j /= 10;
951         }
952         bytes memory bstr = new bytes(len);
953         uint k = len - 1;
954         while (i != 0){
955             bstr[k--] = byte(uint8(48 + i % 10));
956             i /= 10;
957         }
958         return string(bstr);
959     }
960 }
961 
962 
963 contract CryptoCards is ERC721Full, Ownable {
964 
965     string public tokenMetadataBaseURI = "https://apidemo721.nagemon.com/card/";
966     constructor (string memory name, string memory symbol) public ERC721Full(name, symbol) {}
967     function updateBaseURI(string calldata _tokenMetadataBaseURI) onlyOwner external {
968         tokenMetadataBaseURI = _tokenMetadataBaseURI;
969     }
970     function register(address user, uint8 numberToken) onlyOwner external {
971         for (uint8 j = 0; j < numberToken ; j++) {
972             create(user); // Give each new player 5 cards
973         }
974     }
975 
976     function create(address user) private {
977         uint256 tokenId = totalSupply() + 1;
978         _mint(user, tokenId);
979     }
980     /**
981         * @dev Returns an URI for a given token ID
982         * Throws if the token ID does not exist. May return an empty string.
983         * @param _tokenId uint256 ID of the token to query
984         */
985     function tokenURI(uint256 _tokenId) public view returns (string memory) {
986         return Strings.strConcat(
987             tokenMetadataBaseURI,
988             Strings.uint2str(_tokenId)
989         );
990     }
991 }