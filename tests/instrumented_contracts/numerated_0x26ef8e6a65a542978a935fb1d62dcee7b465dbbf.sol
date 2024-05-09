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
70  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
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
127 /**
128  * @title Roles
129  * @dev Library for managing addresses assigned to a Role.
130  */
131 library Roles {
132     struct Role {
133         mapping (address => bool) bearer;
134     }
135 
136     /**
137      * @dev give an account access to this role
138      */
139     function add(Role storage role, address account) internal {
140         require(account != address(0));
141         require(!has(role, account));
142 
143         role.bearer[account] = true;
144     }
145 
146     /**
147      * @dev remove an account's access to this role
148      */
149     function remove(Role storage role, address account) internal {
150         require(account != address(0));
151         require(has(role, account));
152 
153         role.bearer[account] = false;
154     }
155 
156     /**
157      * @dev check if an account has this role
158      * @return bool
159      */
160     function has(Role storage role, address account) internal view returns (bool) {
161         require(account != address(0));
162         return role.bearer[account];
163     }
164 }
165 
166 
167 
168 
169 
170 
171 /**
172  * @title ERC721 Non-Fungible Token Standard basic interface
173  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
174  */
175 contract IERC721 is IERC165 {
176     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
177     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
178     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
179 
180     function balanceOf(address owner) public view returns (uint256 balance);
181     function ownerOf(uint256 tokenId) public view returns (address owner);
182 
183     function approve(address to, uint256 tokenId) public;
184     function getApproved(uint256 tokenId) public view returns (address operator);
185 
186     function setApprovalForAll(address operator, bool _approved) public;
187     function isApprovedForAll(address owner, address operator) public view returns (bool);
188 
189     function transferFrom(address from, address to, uint256 tokenId) public;
190     function safeTransferFrom(address from, address to, uint256 tokenId) public;
191 
192     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
193 }
194 
195 
196 
197 /**
198  * @title ERC721 token receiver interface
199  * @dev Interface for any contract that wants to support safeTransfers
200  * from ERC721 asset contracts.
201  */
202 contract IERC721Receiver {
203     /**
204      * @notice Handle the receipt of an NFT
205      * @dev The ERC721 smart contract calls this function on the recipient
206      * after a `safeTransfer`. This function MUST return the function selector,
207      * otherwise the caller will revert the transaction. The selector to be
208      * returned can be obtained as `this.onERC721Received.selector`. This
209      * function MAY throw to revert and reject the transfer.
210      * Note: the ERC721 contract address is always the message sender.
211      * @param operator The address which called `safeTransferFrom` function
212      * @param from The address which previously owned the token
213      * @param tokenId The NFT identifier which is being transferred
214      * @param data Additional data with no specified format
215      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
216      */
217     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
218     public returns (bytes4);
219 }
220 
221 
222 
223 
224 /**
225  * Utility library of inline functions on addresses
226  */
227 library Address {
228     /**
229      * Returns whether the target address is a contract
230      * @dev This function will return false if invoked during the constructor of a contract,
231      * as the code is not actually created until after the constructor finishes.
232      * @param account address of the account to check
233      * @return whether the target address is a contract
234      */
235     function isContract(address account) internal view returns (bool) {
236         uint256 size;
237         // XXX Currently there is no better way to check if there is a contract in an address
238         // than to check the size of the code at that address.
239         // See https://ethereum.stackexchange.com/a/14016/36603
240         // for more details about how this works.
241         // TODO Check this again before the Serenity release, because all addresses will be
242         // contracts then.
243         // solhint-disable-next-line no-inline-assembly
244         assembly { size := extcodesize(account) }
245         return size > 0;
246     }
247 }
248 
249 
250 
251 
252 
253 /**
254  * @title Counters
255  * @author Matt Condon (@shrugs)
256  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
257  * of elements in a mapping, issuing ERC721 ids, or counting request ids
258  *
259  * Include with `using Counter for Counter.Counter;`
260  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
261  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
262  * directly accessed.
263  */
264 library Counters {
265     using SafeMath for uint256;
266 
267     struct Counter {
268         // This variable should never be directly accessed by users of the library: interactions must be restricted to
269         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
270         // this feature: see https://github.com/ethereum/solidity/issues/4637
271         uint256 _value; // default: 0
272     }
273 
274     function current(Counter storage counter) internal view returns (uint256) {
275         return counter._value;
276     }
277 
278     function increment(Counter storage counter) internal {
279         counter._value += 1;
280     }
281 
282     function decrement(Counter storage counter) internal {
283         counter._value = counter._value.sub(1);
284     }
285 }
286 
287 
288 
289 /**
290  * @title ERC721 Non-Fungible Token Standard basic implementation
291  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
292  */
293 contract ERC721 is ERC165, IERC721 {
294     using SafeMath for uint256;
295     using Address for address;
296     using Counters for Counters.Counter;
297 
298     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
299     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
300     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
301 
302     // Mapping from token ID to owner
303     mapping (uint256 => address) private _tokenOwner;
304 
305     // Mapping from token ID to approved address
306     mapping (uint256 => address) private _tokenApprovals;
307 
308     // Mapping from owner to number of owned token
309     mapping (address => Counters.Counter) private _ownedTokensCount;
310 
311     // Mapping from owner to operator approvals
312     mapping (address => mapping (address => bool)) private _operatorApprovals;
313 
314     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
315     /*
316      * 0x80ac58cd ===
317      *     bytes4(keccak256('balanceOf(address)')) ^
318      *     bytes4(keccak256('ownerOf(uint256)')) ^
319      *     bytes4(keccak256('approve(address,uint256)')) ^
320      *     bytes4(keccak256('getApproved(uint256)')) ^
321      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
322      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
323      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
324      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
325      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
326      */
327 
328     constructor () public {
329         // register the supported interfaces to conform to ERC721 via ERC165
330         _registerInterface(_INTERFACE_ID_ERC721);
331     }
332 
333     /**
334      * @dev Gets the balance of the specified address
335      * @param owner address to query the balance of
336      * @return uint256 representing the amount owned by the passed address
337      */
338     function balanceOf(address owner) public view returns (uint256) {
339         require(owner != address(0));
340         return _ownedTokensCount[owner].current();
341     }
342 
343     /**
344      * @dev Gets the owner of the specified token ID
345      * @param tokenId uint256 ID of the token to query the owner of
346      * @return address currently marked as the owner of the given token ID
347      */
348     function ownerOf(uint256 tokenId) public view returns (address) {
349         address owner = _tokenOwner[tokenId];
350         require(owner != address(0));
351         return owner;
352     }
353 
354     /**
355      * @dev Approves another address to transfer the given token ID
356      * The zero address indicates there is no approved address.
357      * There can only be one approved address per token at a given time.
358      * Can only be called by the token owner or an approved operator.
359      * @param to address to be approved for the given token ID
360      * @param tokenId uint256 ID of the token to be approved
361      */
362     function approve(address to, uint256 tokenId) public {
363         address owner = ownerOf(tokenId);
364         require(to != owner);
365         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
366 
367         _tokenApprovals[tokenId] = to;
368         emit Approval(owner, to, tokenId);
369     }
370 
371     /**
372      * @dev Gets the approved address for a token ID, or zero if no address set
373      * Reverts if the token ID does not exist.
374      * @param tokenId uint256 ID of the token to query the approval of
375      * @return address currently approved for the given token ID
376      */
377     function getApproved(uint256 tokenId) public view returns (address) {
378         require(_exists(tokenId));
379         return _tokenApprovals[tokenId];
380     }
381 
382     /**
383      * @dev Sets or unsets the approval of a given operator
384      * An operator is allowed to transfer all tokens of the sender on their behalf
385      * @param to operator address to set the approval
386      * @param approved representing the status of the approval to be set
387      */
388     function setApprovalForAll(address to, bool approved) public {
389         require(to != msg.sender);
390         _operatorApprovals[msg.sender][to] = approved;
391         emit ApprovalForAll(msg.sender, to, approved);
392     }
393 
394     /**
395      * @dev Tells whether an operator is approved by a given owner
396      * @param owner owner address which you want to query the approval of
397      * @param operator operator address which you want to query the approval of
398      * @return bool whether the given operator is approved by the given owner
399      */
400     function isApprovedForAll(address owner, address operator) public view returns (bool) {
401         return _operatorApprovals[owner][operator];
402     }
403 
404     /**
405      * @dev Transfers the ownership of a given token ID to another address
406      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
407      * Requires the msg.sender to be the owner, approved, or operator
408      * @param from current owner of the token
409      * @param to address to receive the ownership of the given token ID
410      * @param tokenId uint256 ID of the token to be transferred
411      */
412     function transferFrom(address from, address to, uint256 tokenId) public {
413         require(_isApprovedOrOwner(msg.sender, tokenId));
414 
415         _transferFrom(from, to, tokenId);
416     }
417 
418     /**
419      * @dev Safely transfers the ownership of a given token ID to another address
420      * If the target address is a contract, it must implement `onERC721Received`,
421      * which is called upon a safe transfer, and return the magic value
422      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
423      * the transfer is reverted.
424      * Requires the msg.sender to be the owner, approved, or operator
425      * @param from current owner of the token
426      * @param to address to receive the ownership of the given token ID
427      * @param tokenId uint256 ID of the token to be transferred
428      */
429     function safeTransferFrom(address from, address to, uint256 tokenId) public {
430         safeTransferFrom(from, to, tokenId, "");
431     }
432 
433     /**
434      * @dev Safely transfers the ownership of a given token ID to another address
435      * If the target address is a contract, it must implement `onERC721Received`,
436      * which is called upon a safe transfer, and return the magic value
437      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
438      * the transfer is reverted.
439      * Requires the msg.sender to be the owner, approved, or operator
440      * @param from current owner of the token
441      * @param to address to receive the ownership of the given token ID
442      * @param tokenId uint256 ID of the token to be transferred
443      * @param _data bytes data to send along with a safe transfer check
444      */
445     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
446         transferFrom(from, to, tokenId);
447         require(_checkOnERC721Received(from, to, tokenId, _data));
448     }
449 
450     /**
451      * @dev Returns whether the specified token exists
452      * @param tokenId uint256 ID of the token to query the existence of
453      * @return bool whether the token exists
454      */
455     function _exists(uint256 tokenId) internal view returns (bool) {
456         address owner = _tokenOwner[tokenId];
457         return owner != address(0);
458     }
459 
460     /**
461      * @dev Returns whether the given spender can transfer a given token ID
462      * @param spender address of the spender to query
463      * @param tokenId uint256 ID of the token to be transferred
464      * @return bool whether the msg.sender is approved for the given token ID,
465      * is an operator of the owner, or is the owner of the token
466      */
467     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
468         address owner = ownerOf(tokenId);
469         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
470     }
471 
472     /**
473      * @dev Internal function to mint a new token
474      * Reverts if the given token ID already exists
475      * @param to The address that will own the minted token
476      * @param tokenId uint256 ID of the token to be minted
477      */
478     function _mint(address to, uint256 tokenId) internal {
479         require(to != address(0));
480         require(!_exists(tokenId));
481 
482         _tokenOwner[tokenId] = to;
483         _ownedTokensCount[to].increment();
484 
485         emit Transfer(address(0), to, tokenId);
486     }
487 
488     /**
489      * @dev Internal function to burn a specific token
490      * Reverts if the token does not exist
491      * Deprecated, use _burn(uint256) instead.
492      * @param owner owner of the token to burn
493      * @param tokenId uint256 ID of the token being burned
494      */
495     function _burn(address owner, uint256 tokenId) internal {
496         require(ownerOf(tokenId) == owner);
497 
498         _clearApproval(tokenId);
499 
500         _ownedTokensCount[owner].decrement();
501         _tokenOwner[tokenId] = address(0);
502 
503         emit Transfer(owner, address(0), tokenId);
504     }
505 
506     /**
507      * @dev Internal function to burn a specific token
508      * Reverts if the token does not exist
509      * @param tokenId uint256 ID of the token being burned
510      */
511     function _burn(uint256 tokenId) internal {
512         _burn(ownerOf(tokenId), tokenId);
513     }
514 
515     /**
516      * @dev Internal function to transfer ownership of a given token ID to another address.
517      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
518      * @param from current owner of the token
519      * @param to address to receive the ownership of the given token ID
520      * @param tokenId uint256 ID of the token to be transferred
521      */
522     function _transferFrom(address from, address to, uint256 tokenId) internal {
523         require(ownerOf(tokenId) == from);
524         require(to != address(0));
525 
526         _clearApproval(tokenId);
527 
528         _ownedTokensCount[from].decrement();
529         _ownedTokensCount[to].increment();
530 
531         _tokenOwner[tokenId] = to;
532 
533         emit Transfer(from, to, tokenId);
534     }
535 
536     /**
537      * @dev Internal function to invoke `onERC721Received` on a target address
538      * The call is not executed if the target address is not a contract
539      * @param from address representing the previous owner of the given token ID
540      * @param to target address that will receive the tokens
541      * @param tokenId uint256 ID of the token to be transferred
542      * @param _data bytes optional data to send along with the call
543      * @return bool whether the call correctly returned the expected magic value
544      */
545     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
546         internal returns (bool)
547     {
548         if (!to.isContract()) {
549             return true;
550         }
551 
552         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
553         return (retval == _ERC721_RECEIVED);
554     }
555 
556     /**
557      * @dev Private function to clear current approval of a given token ID
558      * @param tokenId uint256 ID of the token to be transferred
559      */
560     function _clearApproval(uint256 tokenId) private {
561         if (_tokenApprovals[tokenId] != address(0)) {
562             _tokenApprovals[tokenId] = address(0);
563         }
564     }
565 }
566 
567 
568 
569 
570 contract MinterRole {
571     using Roles for Roles.Role;
572 
573     event MinterAdded(address indexed account);
574     event MinterRemoved(address indexed account);
575 
576     Roles.Role private _minters;
577 
578     constructor () internal {
579         _addMinter(msg.sender);
580     }
581 
582     modifier onlyMinter() {
583         require(isMinter(msg.sender));
584         _;
585     }
586 
587     function isMinter(address account) public view returns (bool) {
588         return _minters.has(account);
589     }
590 
591     function addMinter(address account) public onlyMinter {
592         _addMinter(account);
593     }
594 
595     function renounceMinter() public {
596         _removeMinter(msg.sender);
597     }
598 
599     function _addMinter(address account) internal {
600         _minters.add(account);
601         emit MinterAdded(account);
602     }
603 
604     function _removeMinter(address account) internal {
605         _minters.remove(account);
606         emit MinterRemoved(account);
607     }
608 }
609 
610 
611 
612 
613 
614 
615 
616 /**
617  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
618  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
619  */
620 contract IERC721Metadata is IERC721 {
621     function name() external view returns (string memory);
622     function symbol() external view returns (string memory);
623     function tokenURI(uint256 tokenId) external view returns (string memory);
624 }
625 
626 
627 
628 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
629     // Token name
630     string private _name;
631 
632     // Token symbol
633     string private _symbol;
634 
635     // Optional mapping for token URIs
636     mapping(uint256 => string) private _tokenURIs;
637 
638     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
639     /*
640      * 0x5b5e139f ===
641      *     bytes4(keccak256('name()')) ^
642      *     bytes4(keccak256('symbol()')) ^
643      *     bytes4(keccak256('tokenURI(uint256)'))
644      */
645 
646     /**
647      * @dev Constructor function
648      */
649     constructor (string memory name, string memory symbol) public {
650         _name = name;
651         _symbol = symbol;
652 
653         // register the supported interfaces to conform to ERC721 via ERC165
654         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
655     }
656 
657     /**
658      * @dev Gets the token name
659      * @return string representing the token name
660      */
661     function name() external view returns (string memory) {
662         return _name;
663     }
664 
665     /**
666      * @dev Gets the token symbol
667      * @return string representing the token symbol
668      */
669     function symbol() external view returns (string memory) {
670         return _symbol;
671     }
672 
673     /**
674      * @dev Returns an URI for a given token ID
675      * Throws if the token ID does not exist. May return an empty string.
676      * @param tokenId uint256 ID of the token to query
677      */
678     function tokenURI(uint256 tokenId) external view returns (string memory) {
679         require(_exists(tokenId));
680         return _tokenURIs[tokenId];
681     }
682 
683     /**
684      * @dev Internal function to set the token URI for a given token
685      * Reverts if the token ID does not exist
686      * @param tokenId uint256 ID of the token to set its URI
687      * @param uri string URI to assign
688      */
689     function _setTokenURI(uint256 tokenId, string memory uri) internal {
690         require(_exists(tokenId));
691         _tokenURIs[tokenId] = uri;
692     }
693 
694     /**
695      * @dev Internal function to burn a specific token
696      * Reverts if the token does not exist
697      * Deprecated, use _burn(uint256) instead
698      * @param owner owner of the token to burn
699      * @param tokenId uint256 ID of the token being burned by the msg.sender
700      */
701     function _burn(address owner, uint256 tokenId) internal {
702         super._burn(owner, tokenId);
703 
704         // Clear metadata (if any)
705         if (bytes(_tokenURIs[tokenId]).length != 0) {
706             delete _tokenURIs[tokenId];
707         }
708     }
709 }
710 
711 
712 
713 
714 
715 
716 
717 
718 
719 
720 
721 /**
722  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
723  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
724  */
725 contract IERC721Enumerable is IERC721 {
726     function totalSupply() public view returns (uint256);
727     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
728 
729     function tokenByIndex(uint256 index) public view returns (uint256);
730 }
731 
732 
733 
734 
735 /**
736  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
737  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
738  */
739 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
740     // Mapping from owner to list of owned token IDs
741     mapping(address => uint256[]) private _ownedTokens;
742 
743     // Mapping from token ID to index of the owner tokens list
744     mapping(uint256 => uint256) private _ownedTokensIndex;
745 
746     // Array with all token ids, used for enumeration
747     uint256[] private _allTokens;
748 
749     // Mapping from token id to position in the allTokens array
750     mapping(uint256 => uint256) private _allTokensIndex;
751 
752     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
753     /*
754      * 0x780e9d63 ===
755      *     bytes4(keccak256('totalSupply()')) ^
756      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
757      *     bytes4(keccak256('tokenByIndex(uint256)'))
758      */
759 
760     /**
761      * @dev Constructor function
762      */
763     constructor () public {
764         // register the supported interface to conform to ERC721 via ERC165
765         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
766     }
767 
768     /**
769      * @dev Gets the token ID at a given index of the tokens list of the requested owner
770      * @param owner address owning the tokens list to be accessed
771      * @param index uint256 representing the index to be accessed of the requested tokens list
772      * @return uint256 token ID at the given index of the tokens list owned by the requested address
773      */
774     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
775         require(index < balanceOf(owner));
776         return _ownedTokens[owner][index];
777     }
778 
779     /**
780      * @dev Gets the total amount of tokens stored by the contract
781      * @return uint256 representing the total amount of tokens
782      */
783     function totalSupply() public view returns (uint256) {
784         return _allTokens.length;
785     }
786 
787     /**
788      * @dev Gets the token ID at a given index of all the tokens in this contract
789      * Reverts if the index is greater or equal to the total number of tokens
790      * @param index uint256 representing the index to be accessed of the tokens list
791      * @return uint256 token ID at the given index of the tokens list
792      */
793     function tokenByIndex(uint256 index) public view returns (uint256) {
794         require(index < totalSupply());
795         return _allTokens[index];
796     }
797 
798     /**
799      * @dev Internal function to transfer ownership of a given token ID to another address.
800      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
801      * @param from current owner of the token
802      * @param to address to receive the ownership of the given token ID
803      * @param tokenId uint256 ID of the token to be transferred
804      */
805     function _transferFrom(address from, address to, uint256 tokenId) internal {
806         super._transferFrom(from, to, tokenId);
807 
808         _removeTokenFromOwnerEnumeration(from, tokenId);
809 
810         _addTokenToOwnerEnumeration(to, tokenId);
811     }
812 
813     /**
814      * @dev Internal function to mint a new token
815      * Reverts if the given token ID already exists
816      * @param to address the beneficiary that will own the minted token
817      * @param tokenId uint256 ID of the token to be minted
818      */
819     function _mint(address to, uint256 tokenId) internal {
820         super._mint(to, tokenId);
821 
822         _addTokenToOwnerEnumeration(to, tokenId);
823 
824         _addTokenToAllTokensEnumeration(tokenId);
825     }
826 
827     /**
828      * @dev Internal function to burn a specific token
829      * Reverts if the token does not exist
830      * Deprecated, use _burn(uint256) instead
831      * @param owner owner of the token to burn
832      * @param tokenId uint256 ID of the token being burned
833      */
834     function _burn(address owner, uint256 tokenId) internal {
835         super._burn(owner, tokenId);
836 
837         _removeTokenFromOwnerEnumeration(owner, tokenId);
838         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
839         _ownedTokensIndex[tokenId] = 0;
840 
841         _removeTokenFromAllTokensEnumeration(tokenId);
842     }
843 
844     /**
845      * @dev Gets the list of token IDs of the requested owner
846      * @param owner address owning the tokens
847      * @return uint256[] List of token IDs owned by the requested address
848      */
849     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
850         return _ownedTokens[owner];
851     }
852 
853     /**
854      * @dev Private function to add a token to this extension's ownership-tracking data structures.
855      * @param to address representing the new owner of the given token ID
856      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
857      */
858     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
859         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
860         _ownedTokens[to].push(tokenId);
861     }
862 
863     /**
864      * @dev Private function to add a token to this extension's token tracking data structures.
865      * @param tokenId uint256 ID of the token to be added to the tokens list
866      */
867     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
868         _allTokensIndex[tokenId] = _allTokens.length;
869         _allTokens.push(tokenId);
870     }
871 
872     /**
873      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
874      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
875      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
876      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
877      * @param from address representing the previous owner of the given token ID
878      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
879      */
880     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
881         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
882         // then delete the last slot (swap and pop).
883 
884         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
885         uint256 tokenIndex = _ownedTokensIndex[tokenId];
886 
887         // When the token to delete is the last token, the swap operation is unnecessary
888         if (tokenIndex != lastTokenIndex) {
889             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
890 
891             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
892             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
893         }
894 
895         // This also deletes the contents at the last position of the array
896         _ownedTokens[from].length--;
897 
898         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occcupied by
899         // lasTokenId, or just over the end of the array if the token was the last one).
900     }
901 
902     /**
903      * @dev Private function to remove a token from this extension's token tracking data structures.
904      * This has O(1) time complexity, but alters the order of the _allTokens array.
905      * @param tokenId uint256 ID of the token to be removed from the tokens list
906      */
907     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
908         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
909         // then delete the last slot (swap and pop).
910 
911         uint256 lastTokenIndex = _allTokens.length.sub(1);
912         uint256 tokenIndex = _allTokensIndex[tokenId];
913 
914         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
915         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
916         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
917         uint256 lastTokenId = _allTokens[lastTokenIndex];
918 
919         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
920         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
921 
922         // This also deletes the contents at the last position of the array
923         _allTokens.length--;
924         _allTokensIndex[tokenId] = 0;
925     }
926 }
927 
928 
929 
930 /**
931  * @title Full ERC721 Token
932  * This implementation includes all the required and some optional functionality of the ERC721 standard
933  * Moreover, it includes approve all functionality using operator terminology
934  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
935  */
936 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
937     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
938         // solhint-disable-previous-line no-empty-blocks
939     }
940 }
941 
942 
943 
944 
945 
946 
947 
948 /**
949  * @title ERC721MetadataMintable
950  * @dev ERC721 minting logic with metadata
951  */
952 contract ERC721MetadataMintable is ERC721, ERC721Metadata, MinterRole {
953     /**
954      * @dev Function to mint tokens
955      * @param to The address that will receive the minted tokens.
956      * @param tokenId The token id to mint.
957      * @param tokenURI The token URI of the minted token.
958      * @return A boolean that indicates if the operation was successful.
959      */
960     function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public onlyMinter returns (bool) {
961         _mint(to, tokenId);
962         _setTokenURI(tokenId, tokenURI);
963         return true;
964     }
965 }
966 
967 
968 
969 
970 
971 /**
972  * @title ERC721 Burnable Token
973  * @dev ERC721 Token that can be irreversibly burned (destroyed).
974  */
975 contract ERC721Burnable is ERC721 {
976     /**
977      * @dev Burns a specific ERC721 token.
978      * @param tokenId uint256 id of the ERC721 token to be burned.
979      */
980     function burn(uint256 tokenId) public {
981         require(_isApprovedOrOwner(msg.sender, tokenId));
982         _burn(tokenId);
983     }
984 }
985 
986 
987 /**
988  * @title ERC721TEST
989  */
990 contract ERC721TEST is ERC721Full, ERC721MetadataMintable, ERC721Burnable {
991     constructor (string memory name, string memory symbol) public ERC721MetadataMintable() ERC721Full(name, symbol) {
992         // solhint-disable-previous-line no-empty-blocks
993     }
994 }