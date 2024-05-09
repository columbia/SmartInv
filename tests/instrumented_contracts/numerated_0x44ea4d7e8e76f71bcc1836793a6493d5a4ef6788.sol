1 pragma solidity ^0.5.2;
2 
3 contract Ownable {
4     address private _owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12     constructor () internal {
13         _owner = msg.sender;
14         emit OwnershipTransferred(address(0), _owner);
15     }
16 
17     /**
18      * @return the address of the owner.
19      */
20     function owner() public view returns (address) {
21         return _owner;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(isOwner());
29         _;
30     }
31 
32     /**
33      * @return true if `msg.sender` is the owner of the contract.
34      */
35     function isOwner() public view returns (bool) {
36         return msg.sender == _owner;
37     }
38 
39     /**
40      * @dev Allows the current owner to relinquish control of the contract.
41      * It will not be possible to call the functions with the `onlyOwner`
42      * modifier anymore.
43      * @notice Renouncing ownership will leave the contract without an owner,
44      * thereby removing any functionality that is only available to the owner.
45      */
46     function renounceOwnership() public onlyOwner {
47         emit OwnershipTransferred(_owner, address(0));
48         _owner = address(0);
49     }
50 
51     /**
52      * @dev Allows the current owner to transfer control of the contract to a newOwner.
53      * @param newOwner The address to transfer ownership to.
54      */
55     function transferOwnership(address newOwner) public onlyOwner {
56         _transferOwnership(newOwner);
57     }
58 
59     /**
60      * @dev Transfers control of the contract to a newOwner.
61      * @param newOwner The address to transfer ownership to.
62      */
63     function _transferOwnership(address newOwner) internal {
64         require(newOwner != address(0));
65         emit OwnershipTransferred(_owner, newOwner);
66         _owner = newOwner;
67     }
68 }
69 
70 interface IERC165 {
71     /**
72      * @notice Query if a contract implements an interface
73      * @param interfaceId The interface identifier, as specified in ERC-165
74      * @dev Interface identification is specified in ERC-165. This function
75      * uses less than 30,000 gas.
76      */
77     function supportsInterface(bytes4 interfaceId) external view returns (bool);
78 }
79 
80 library SafeMath {
81     /**
82      * @dev Multiplies two unsigned integers, reverts on overflow.
83      */
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b);
94 
95         return c;
96     }
97 
98     /**
99      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
100      */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         // Solidity only automatically asserts when dividing by 0
103         require(b > 0);
104         uint256 c = a / b;
105         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106 
107         return c;
108     }
109 
110     /**
111      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
112      */
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         require(b <= a);
115         uint256 c = a - b;
116 
117         return c;
118     }
119 
120     /**
121      * @dev Adds two unsigned integers, reverts on overflow.
122      */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a);
126 
127         return c;
128     }
129 
130     /**
131      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
132      * reverts when dividing by zero.
133      */
134     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
135         require(b != 0);
136         return a % b;
137     }
138 }
139 
140 library Address {
141     /**
142      * Returns whether the target address is a contract
143      * @dev This function will return false if invoked during the constructor of a contract,
144      * as the code is not actually created until after the constructor finishes.
145      * @param account address of the account to check
146      * @return whether the target address is a contract
147      */
148     function isContract(address account) internal view returns (bool) {
149         uint256 size;
150         // XXX Currently there is no better way to check if there is a contract in an address
151         // than to check the size of the code at that address.
152         // See https://ethereum.stackexchange.com/a/14016/36603
153         // for more details about how this works.
154         // TODO Check this again before the Serenity release, because all addresses will be
155         // contracts then.
156         // solhint-disable-next-line no-inline-assembly
157         assembly { size := extcodesize(account) }
158         return size > 0;
159     }
160 }
161 
162 contract IERC721Receiver {
163     /**
164      * @notice Handle the receipt of an NFT
165      * @dev The ERC721 smart contract calls this function on the recipient
166      * after a `safeTransfer`. This function MUST return the function selector,
167      * otherwise the caller will revert the transaction. The selector to be
168      * returned can be obtained as `this.onERC721Received.selector`. This
169      * function MAY throw to revert and reject the transfer.
170      * Note: the ERC721 contract address is always the message sender.
171      * @param operator The address which called `safeTransferFrom` function
172      * @param from The address which previously owned the token
173      * @param tokenId The NFT identifier which is being transferred
174      * @param data Additional data with no specified format
175      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
176      */
177     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
178     public returns (bytes4);
179 }
180 
181 library Counters {
182     using SafeMath for uint256;
183 
184     struct Counter {
185         // This variable should never be directly accessed by users of the library: interactions must be restricted to
186         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
187         // this feature: see https://github.com/ethereum/solidity/issues/4637
188         uint256 _value; // default: 0
189     }
190 
191     function current(Counter storage counter) internal view returns (uint256) {
192         return counter._value;
193     }
194 
195     function increment(Counter storage counter) internal {
196         counter._value += 1;
197     }
198 
199     function decrement(Counter storage counter) internal {
200         counter._value = counter._value.sub(1);
201     }
202 }
203 
204 contract ERC165 is IERC165 {
205     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
206     /*
207      * 0x01ffc9a7 ===
208      *     bytes4(keccak256('supportsInterface(bytes4)'))
209      */
210 
211     /**
212      * @dev Mapping of interface ids to whether or not it's supported.
213      */
214     mapping(bytes4 => bool) private _supportedInterfaces;
215 
216     /**
217      * @dev A contract implementing SupportsInterfaceWithLookup
218      * implements ERC165 itself.
219      */
220     constructor () internal {
221         _registerInterface(_INTERFACE_ID_ERC165);
222     }
223 
224     /**
225      * @dev Implement supportsInterface(bytes4) using a lookup table.
226      */
227     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
228         return _supportedInterfaces[interfaceId];
229     }
230 
231     /**
232      * @dev Internal method for registering an interface.
233      */
234     function _registerInterface(bytes4 interfaceId) internal {
235         require(interfaceId != 0xffffffff);
236         _supportedInterfaces[interfaceId] = true;
237     }
238 }
239 
240 contract IERC721 is IERC165 {
241     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
242     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
243     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
244 
245     function balanceOf(address owner) public view returns (uint256 balance);
246     function ownerOf(uint256 tokenId) public view returns (address owner);
247 
248     function approve(address to, uint256 tokenId) public;
249     function getApproved(uint256 tokenId) public view returns (address operator);
250 
251     function setApprovalForAll(address operator, bool _approved) public;
252     function isApprovedForAll(address owner, address operator) public view returns (bool);
253 
254     function transferFrom(address from, address to, uint256 tokenId) public;
255     function safeTransferFrom(address from, address to, uint256 tokenId) public;
256 
257     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
258 }
259 
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
301      * @dev Gets the balance of the specified address.
302      * @param owner address to query the balance of
303      * @return uint256 representing the amount owned by the passed address
304      */
305     function balanceOf(address owner) public view returns (uint256) {
306         require(owner != address(0));
307         return _ownedTokensCount[owner].current();
308     }
309 
310     /**
311      * @dev Gets the owner of the specified token ID.
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
351      * An operator is allowed to transfer all tokens of the sender on their behalf.
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
362      * @dev Tells whether an operator is approved by a given owner.
363      * @param owner owner address which you want to query the approval of
364      * @param operator operator address which you want to query the approval of
365      * @return bool whether the given operator is approved by the given owner
366      */
367     function isApprovedForAll(address owner, address operator) public view returns (bool) {
368         return _operatorApprovals[owner][operator];
369     }
370 
371     /**
372      * @dev Transfers the ownership of a given token ID to another address.
373      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
374      * Requires the msg.sender to be the owner, approved, or operator.
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
418      * @dev Returns whether the specified token exists.
419      * @param tokenId uint256 ID of the token to query the existence of
420      * @return bool whether the token exists
421      */
422     function _exists(uint256 tokenId) internal view returns (bool) {
423         address owner = _tokenOwner[tokenId];
424         return owner != address(0);
425     }
426 
427     /**
428      * @dev Returns whether the given spender can transfer a given token ID.
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
440      * @dev Internal function to mint a new token.
441      * Reverts if the given token ID already exists.
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
456      * @dev Internal function to burn a specific token.
457      * Reverts if the token does not exist.
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
474      * @dev Internal function to burn a specific token.
475      * Reverts if the token does not exist.
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
504      * @dev Internal function to invoke `onERC721Received` on a target address.
505      * The call is not executed if the target address is not a contract.
506      * @param from address representing the previous owner of the given token ID
507      * @param to target address that will receive the tokens
508      * @param tokenId uint256 ID of the token to be transferred
509      * @param _data bytes optional data to send along with the call
510      * @return bool whether the call correctly returned the expected magic value
511      */
512     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
513         internal returns (bool)
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
524      * @dev Private function to clear current approval of a given token ID.
525      * @param tokenId uint256 ID of the token to be transferred
526      */
527     function _clearApproval(uint256 tokenId) private {
528         if (_tokenApprovals[tokenId] != address(0)) {
529             _tokenApprovals[tokenId] = address(0);
530         }
531     }
532 }
533 
534 contract IERC721Enumerable is IERC721 {
535     function totalSupply() public view returns (uint256);
536     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
537 
538     function tokenByIndex(uint256 index) public view returns (uint256);
539 }
540 
541 contract IERC721Metadata is IERC721 {
542     function name() external view returns (string memory);
543     function symbol() external view returns (string memory);
544     function tokenURI(uint256 tokenId) external view returns (string memory);
545 }
546 
547 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
548     // Mapping from owner to list of owned token IDs
549     mapping(address => uint256[]) private _ownedTokens;
550 
551     // Mapping from token ID to index of the owner tokens list
552     mapping(uint256 => uint256) private _ownedTokensIndex;
553 
554     // Array with all token ids, used for enumeration
555     uint256[] private _allTokens;
556 
557     // Mapping from token id to position in the allTokens array
558     mapping(uint256 => uint256) private _allTokensIndex;
559 
560     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
561     /*
562      * 0x780e9d63 ===
563      *     bytes4(keccak256('totalSupply()')) ^
564      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
565      *     bytes4(keccak256('tokenByIndex(uint256)'))
566      */
567 
568     /**
569      * @dev Constructor function.
570      */
571     constructor () public {
572         // register the supported interface to conform to ERC721Enumerable via ERC165
573         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
574     }
575 
576     /**
577      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
578      * @param owner address owning the tokens list to be accessed
579      * @param index uint256 representing the index to be accessed of the requested tokens list
580      * @return uint256 token ID at the given index of the tokens list owned by the requested address
581      */
582     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
583         require(index < balanceOf(owner));
584         return _ownedTokens[owner][index];
585     }
586 
587     /**
588      * @dev Gets the total amount of tokens stored by the contract.
589      * @return uint256 representing the total amount of tokens
590      */
591     function totalSupply() public view returns (uint256) {
592         return _allTokens.length;
593     }
594 
595     /**
596      * @dev Gets the token ID at a given index of all the tokens in this contract
597      * Reverts if the index is greater or equal to the total number of tokens.
598      * @param index uint256 representing the index to be accessed of the tokens list
599      * @return uint256 token ID at the given index of the tokens list
600      */
601     function tokenByIndex(uint256 index) public view returns (uint256) {
602         require(index < totalSupply());
603         return _allTokens[index];
604     }
605 
606     /**
607      * @dev Internal function to transfer ownership of a given token ID to another address.
608      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
609      * @param from current owner of the token
610      * @param to address to receive the ownership of the given token ID
611      * @param tokenId uint256 ID of the token to be transferred
612      */
613     function _transferFrom(address from, address to, uint256 tokenId) internal {
614         super._transferFrom(from, to, tokenId);
615 
616         _removeTokenFromOwnerEnumeration(from, tokenId);
617 
618         _addTokenToOwnerEnumeration(to, tokenId);
619     }
620 
621     /**
622      * @dev Internal function to mint a new token.
623      * Reverts if the given token ID already exists.
624      * @param to address the beneficiary that will own the minted token
625      * @param tokenId uint256 ID of the token to be minted
626      */
627     function _mint(address to, uint256 tokenId) internal {
628         super._mint(to, tokenId);
629 
630         _addTokenToOwnerEnumeration(to, tokenId);
631 
632         _addTokenToAllTokensEnumeration(tokenId);
633     }
634 
635     /**
636      * @dev Internal function to burn a specific token.
637      * Reverts if the token does not exist.
638      * Deprecated, use _burn(uint256) instead.
639      * @param owner owner of the token to burn
640      * @param tokenId uint256 ID of the token being burned
641      */
642     function _burn(address owner, uint256 tokenId) internal {
643         super._burn(owner, tokenId);
644 
645         _removeTokenFromOwnerEnumeration(owner, tokenId);
646         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
647         _ownedTokensIndex[tokenId] = 0;
648 
649         _removeTokenFromAllTokensEnumeration(tokenId);
650     }
651 
652     /**
653      * @dev Gets the list of token IDs of the requested owner.
654      * @param owner address owning the tokens
655      * @return uint256[] List of token IDs owned by the requested address
656      */
657     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
658         return _ownedTokens[owner];
659     }
660 
661     /**
662      * @dev Private function to add a token to this extension's ownership-tracking data structures.
663      * @param to address representing the new owner of the given token ID
664      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
665      */
666     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
667         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
668         _ownedTokens[to].push(tokenId);
669     }
670 
671     /**
672      * @dev Private function to add a token to this extension's token tracking data structures.
673      * @param tokenId uint256 ID of the token to be added to the tokens list
674      */
675     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
676         _allTokensIndex[tokenId] = _allTokens.length;
677         _allTokens.push(tokenId);
678     }
679 
680     /**
681      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
682      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
683      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
684      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
685      * @param from address representing the previous owner of the given token ID
686      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
687      */
688     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
689         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
690         // then delete the last slot (swap and pop).
691 
692         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
693         uint256 tokenIndex = _ownedTokensIndex[tokenId];
694 
695         // When the token to delete is the last token, the swap operation is unnecessary
696         if (tokenIndex != lastTokenIndex) {
697             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
698 
699             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
700             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
701         }
702 
703         // This also deletes the contents at the last position of the array
704         _ownedTokens[from].length--;
705 
706         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
707         // lastTokenId, or just over the end of the array if the token was the last one).
708     }
709 
710     /**
711      * @dev Private function to remove a token from this extension's token tracking data structures.
712      * This has O(1) time complexity, but alters the order of the _allTokens array.
713      * @param tokenId uint256 ID of the token to be removed from the tokens list
714      */
715     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
716         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
717         // then delete the last slot (swap and pop).
718 
719         uint256 lastTokenIndex = _allTokens.length.sub(1);
720         uint256 tokenIndex = _allTokensIndex[tokenId];
721 
722         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
723         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
724         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
725         uint256 lastTokenId = _allTokens[lastTokenIndex];
726 
727         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
728         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
729 
730         // This also deletes the contents at the last position of the array
731         _allTokens.length--;
732         _allTokensIndex[tokenId] = 0;
733     }
734 }
735 
736 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
737     // Token name
738     string private _name;
739 
740     // Token symbol
741     string private _symbol;
742 
743     // Optional mapping for token URIs
744     mapping(uint256 => string) private _tokenURIs;
745 
746     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
747     /*
748      * 0x5b5e139f ===
749      *     bytes4(keccak256('name()')) ^
750      *     bytes4(keccak256('symbol()')) ^
751      *     bytes4(keccak256('tokenURI(uint256)'))
752      */
753 
754     /**
755      * @dev Constructor function
756      */
757     constructor (string memory name, string memory symbol) public {
758         _name = name;
759         _symbol = symbol;
760 
761         // register the supported interfaces to conform to ERC721 via ERC165
762         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
763     }
764 
765     /**
766      * @dev Gets the token name.
767      * @return string representing the token name
768      */
769     function name() external view returns (string memory) {
770         return _name;
771     }
772 
773     /**
774      * @dev Gets the token symbol.
775      * @return string representing the token symbol
776      */
777     function symbol() external view returns (string memory) {
778         return _symbol;
779     }
780 
781     /**
782      * @dev Returns an URI for a given token ID.
783      * Throws if the token ID does not exist. May return an empty string.
784      * @param tokenId uint256 ID of the token to query
785      */
786     function tokenURI(uint256 tokenId) external view returns (string memory) {
787         require(_exists(tokenId));
788         return _tokenURIs[tokenId];
789     }
790 
791     /**
792      * @dev Internal function to set the token URI for a given token.
793      * Reverts if the token ID does not exist.
794      * @param tokenId uint256 ID of the token to set its URI
795      * @param uri string URI to assign
796      */
797     function _setTokenURI(uint256 tokenId, string memory uri) internal {
798         require(_exists(tokenId));
799         _tokenURIs[tokenId] = uri;
800     }
801 
802     /**
803      * @dev Internal function to burn a specific token.
804      * Reverts if the token does not exist.
805      * Deprecated, use _burn(uint256) instead.
806      * @param owner owner of the token to burn
807      * @param tokenId uint256 ID of the token being burned by the msg.sender
808      */
809     function _burn(address owner, uint256 tokenId) internal {
810         super._burn(owner, tokenId);
811 
812         // Clear metadata (if any)
813         if (bytes(_tokenURIs[tokenId]).length != 0) {
814             delete _tokenURIs[tokenId];
815         }
816     }
817 }
818 
819 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
820     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
821         // solhint-disable-previous-line no-empty-blocks
822     }
823 }
824 
825 contract ChainmonstersCoreV2 is ERC721Full, Ownable{
826     
827     address public GameContract;
828     string baseAPI = "http://chainmonsters.appspot.com/api/GetMonster/";
829     uint256 public offset = 100000;
830     
831 
832     
833     constructor() ERC721Full("ChainmonstersV2", "CHMONV2") public {
834         
835     }
836     
837     
838     
839     
840     function mintToken(address _to) public {
841         require(msg.sender == GameContract);
842         uint256 newTokenId = _getNextTokenId();
843         _mint(_to, newTokenId);
844     }
845     
846     function setGameContract(address _contract) public onlyOwner {
847         GameContract = _contract;
848     }
849     
850     function setOffset(uint256 _offset) public onlyOwner {
851         offset = _offset;
852     }
853     
854     function setBaseAPI(string memory _api) public onlyOwner {
855         baseAPI = _api;
856     }
857     
858     function tokenURI(uint256 _tokenId) public view returns (string memory) {
859         uint256 _id = offset+_tokenId;
860     return append(baseTokenURI(), uint2str(_id));
861   }
862 
863     /**
864     * @dev calculates the next token ID based on totalSupply
865     * @return uint256 for the next token ID
866     */
867     function _getNextTokenId() private view returns (uint256) {
868         return totalSupply().add(1); 
869     }
870     
871     function baseTokenURI() public view returns (string memory) {
872         return baseAPI;
873     }
874     
875     function append(string memory a, string memory b) internal pure returns (string memory) {
876 
877     return string(abi.encodePacked(a, b));
878 
879 }
880     
881     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
882     if (_i == 0) {
883         return "0";
884     }
885     uint j = _i;
886     uint len;
887     while (j != 0) {
888         len++;
889         j /= 10;
890     }
891     bytes memory bstr = new bytes(len);
892     uint k = len - 1;
893     while (_i != 0) {
894         bstr[k--] = byte(uint8(48 + _i % 10));
895         _i /= 10;
896     }
897     return string(bstr);
898 }
899     
900 } 
901 contract GameLogic {
902 
903     using SafeMath for uint256;
904 
905     uint256 public gasCosts;
906     uint256 public mintCosts;
907     uint256 public mintFee;
908 
909     address payable public backend;
910     ChainmonstersCoreV2 public coreContract;
911     address public core;
912     
913     bool public isGameLogicContract = true;
914 
915     address public admin;
916 
917     address public owner;
918 
919     // token = 0 => not requested yet
920     // token = 1 => requested
921     // token = 2 => minted
922     mapping(uint256 => uint16) public tokenToMinted;
923 
924 
925     // Events
926     event RequestMint(address _from, uint256 _id, uint256 mintFee, uint256 gasFee);
927     event MintToken(uint256 _tokenId, address _owner);
928 
929 
930     constructor(address _core) public {
931         owner = msg.sender;
932         admin = msg.sender;
933         backend = msg.sender;
934         core = _core;
935         coreContract = ChainmonstersCoreV2(_core);
936 
937     }
938 
939     
940 
941     function setGasFee(uint256 _gasFee) public {
942         require(msg.sender == admin);
943         require(_gasFee > 0);
944         gasCosts = _gasFee;
945         
946         mintFee = mintCosts + gasCosts;
947 
948 
949     }
950 
951     function setMintFee(uint256 _mintFee) external {
952         require(msg.sender == admin);
953         require(_mintFee > 0);
954         mintCosts = _mintFee;
955         mintFee = mintCosts + gasCosts;
956 
957         
958     }
959 
960     function setAdmin(address _admin) external {
961         require(msg.sender == admin);
962         require(_admin == address(_admin));
963         admin = _admin;
964     }
965     
966     function setBackend(address payable _backend) external {
967         require(msg.sender == admin);
968         require(_backend == address(_backend));
969         backend = _backend;
970     }
971     
972     function setCoreContract(address _core) external {
973         require(msg.sender == admin);
974         require(_core == address(_core));
975         coreContract = ChainmonstersCoreV2(_core);
976         core = _core;
977     }
978 
979     // _id here is NOT the final tokenID and instead an internal identifier
980     // the core contract later creates the real tokenId
981     // this method does not require the actual owner to call this
982     // which enables us to do promo minting for players during special events
983     // and also other players to gift each other a caught monster ;)
984     function requestMintToken(uint256 _id) payable external {
985         require(tokenToMinted[_id] == 0);
986         require(msg.value == mintFee);
987         backend.transfer(gasCosts);
988         tokenToMinted[_id] = 1;
989 
990         emit RequestMint(msg.sender, _id, mintFee, gasCosts);
991 
992 
993     }
994 
995     // mint method called by server
996     // the gasFee sent by the player makes sure that the system runs without further user interaction required
997     function mintToken(uint256 _id, address _owner) external {
998         require(msg.sender == backend);
999         require(tokenToMinted[_id] == 1);
1000        
1001 
1002         
1003 
1004         // start off with blocking any attemps of creating any duplicates
1005         tokenToMinted[_id] = 2;
1006 
1007         coreContract.mintToken(_owner);
1008 
1009         emit MintToken(_id, _owner);
1010 
1011     }
1012 
1013     function withdrawBalance() external  
1014     {
1015         require(msg.sender == owner);
1016 
1017         // there is never more balancee on this contract than the sum of the mintFee
1018         // since gas costs are handled during each new request automatically
1019         uint256 balance = address(this).balance;
1020         address payable _owner = address(uint160(owner));
1021         _owner.transfer(balance);
1022     }
1023 
1024 }