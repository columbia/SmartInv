1 pragma solidity ^0.5.2;
2 
3 interface IERC165 {
4     /**
5      * @notice Query if a contract implements an interface
6      * @param interfaceId The interface identifier, as specified in ERC-165
7      * @dev Interface identification is specified in ERC-165. This function
8      * uses less than 30,000 gas.
9      */
10     function supportsInterface(bytes4 interfaceId) external view returns (bool);
11 }
12 
13 contract Ownable {
14     address private _owner;
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18     /**
19      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20      * account.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @return the address of the owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner());
39         _;
40     }
41 
42     /**
43      * @return true if `msg.sender` is the owner of the contract.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Allows the current owner to relinquish control of the contract.
51      * It will not be possible to call the functions with the `onlyOwner`
52      * modifier anymore.
53      * @notice Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Allows the current owner to transfer control of the contract to a newOwner.
63      * @param newOwner The address to transfer ownership to.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers control of the contract to a newOwner.
71      * @param newOwner The address to transfer ownership to.
72      */
73     function _transferOwnership(address newOwner) internal {
74         require(newOwner != address(0));
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 }
79 
80 library Address {
81     /**
82      * Returns whether the target address is a contract
83      * @dev This function will return false if invoked during the constructor of a contract,
84      * as the code is not actually created until after the constructor finishes.
85      * @param account address of the account to check
86      * @return whether the target address is a contract
87      */
88     function isContract(address account) internal view returns (bool) {
89         uint256 size;
90         // XXX Currently there is no better way to check if there is a contract in an address
91         // than to check the size of the code at that address.
92         // See https://ethereum.stackexchange.com/a/14016/36603
93         // for more details about how this works.
94         // TODO Check this again before the Serenity release, because all addresses will be
95         // contracts then.
96         // solhint-disable-next-line no-inline-assembly
97         assembly { size := extcodesize(account) }
98         return size > 0;
99     }
100 }
101 
102 contract IERC721Receiver {
103     /**
104      * @notice Handle the receipt of an NFT
105      * @dev The ERC721 smart contract calls this function on the recipient
106      * after a `safeTransfer`. This function MUST return the function selector,
107      * otherwise the caller will revert the transaction. The selector to be
108      * returned can be obtained as `this.onERC721Received.selector`. This
109      * function MAY throw to revert and reject the transfer.
110      * Note: the ERC721 contract address is always the message sender.
111      * @param operator The address which called `safeTransferFrom` function
112      * @param from The address which previously owned the token
113      * @param tokenId The NFT identifier which is being transferred
114      * @param data Additional data with no specified format
115      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
116      */
117     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
118     public returns (bytes4);
119 }
120 
121 library SafeMath {
122     /**
123      * @dev Multiplies two unsigned integers, reverts on overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127         // benefit is lost if 'b' is also tested.
128         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
129         if (a == 0) {
130             return 0;
131         }
132 
133         uint256 c = a * b;
134         require(c / a == b);
135 
136         return c;
137     }
138 
139     /**
140      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
141      */
142     function div(uint256 a, uint256 b) internal pure returns (uint256) {
143         // Solidity only automatically asserts when dividing by 0
144         require(b > 0);
145         uint256 c = a / b;
146         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147 
148         return c;
149     }
150 
151     /**
152      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b <= a);
156         uint256 c = a - b;
157 
158         return c;
159     }
160 
161     /**
162      * @dev Adds two unsigned integers, reverts on overflow.
163      */
164     function add(uint256 a, uint256 b) internal pure returns (uint256) {
165         uint256 c = a + b;
166         require(c >= a);
167 
168         return c;
169     }
170 
171     /**
172      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
173      * reverts when dividing by zero.
174      */
175     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176         require(b != 0);
177         return a % b;
178     }
179 }
180 
181 contract IERC721 is IERC165 {
182     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
183     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
184     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
185 
186     function balanceOf(address owner) public view returns (uint256 balance);
187     function ownerOf(uint256 tokenId) public view returns (address owner);
188 
189     function approve(address to, uint256 tokenId) public;
190     function getApproved(uint256 tokenId) public view returns (address operator);
191 
192     function setApprovalForAll(address operator, bool _approved) public;
193     function isApprovedForAll(address owner, address operator) public view returns (bool);
194 
195     function transferFrom(address from, address to, uint256 tokenId) public;
196     function safeTransferFrom(address from, address to, uint256 tokenId) public;
197 
198     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
199 }
200 
201 contract ERC165 is IERC165 {
202     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
203     /*
204      * 0x01ffc9a7 ===
205      *     bytes4(keccak256('supportsInterface(bytes4)'))
206      */
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
237 library Counters {
238     using SafeMath for uint256;
239 
240     struct Counter {
241         // This variable should never be directly accessed by users of the library: interactions must be restricted to
242         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
243         // this feature: see https://github.com/ethereum/solidity/issues/4637
244         uint256 _value; // default: 0
245     }
246 
247     function current(Counter storage counter) internal view returns (uint256) {
248         return counter._value;
249     }
250 
251     function increment(Counter storage counter) internal {
252         counter._value += 1;
253     }
254 
255     function decrement(Counter storage counter) internal {
256         counter._value = counter._value.sub(1);
257     }
258 }
259 
260 contract IERC721Enumerable is IERC721 {
261     function totalSupply() public view returns (uint256);
262     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
263 
264     function tokenByIndex(uint256 index) public view returns (uint256);
265 }
266 
267 contract IERC721Metadata is IERC721 {
268     function name() external view returns (string memory);
269     function symbol() external view returns (string memory);
270     function tokenURI(uint256 tokenId) external view returns (string memory);
271 }
272 
273 contract ERC721 is ERC165, IERC721 {
274     using SafeMath for uint256;
275     using Address for address;
276     using Counters for Counters.Counter;
277 
278     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
279     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
280     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
281 
282     // Mapping from token ID to owner
283     mapping (uint256 => address) private _tokenOwner;
284 
285     // Mapping from token ID to approved address
286     mapping (uint256 => address) private _tokenApprovals;
287 
288     // Mapping from owner to number of owned token
289     mapping (address => Counters.Counter) private _ownedTokensCount;
290 
291     // Mapping from owner to operator approvals
292     mapping (address => mapping (address => bool)) private _operatorApprovals;
293 
294     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
295     /*
296      * 0x80ac58cd ===
297      *     bytes4(keccak256('balanceOf(address)')) ^
298      *     bytes4(keccak256('ownerOf(uint256)')) ^
299      *     bytes4(keccak256('approve(address,uint256)')) ^
300      *     bytes4(keccak256('getApproved(uint256)')) ^
301      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
302      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
303      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
304      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
305      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
306      */
307 
308     constructor () public {
309         // register the supported interfaces to conform to ERC721 via ERC165
310         _registerInterface(_INTERFACE_ID_ERC721);
311     }
312 
313     /**
314      * @dev Gets the balance of the specified address.
315      * @param owner address to query the balance of
316      * @return uint256 representing the amount owned by the passed address
317      */
318     function balanceOf(address owner) public view returns (uint256) {
319         require(owner != address(0));
320         return _ownedTokensCount[owner].current();
321     }
322 
323     /**
324      * @dev Gets the owner of the specified token ID.
325      * @param tokenId uint256 ID of the token to query the owner of
326      * @return address currently marked as the owner of the given token ID
327      */
328     function ownerOf(uint256 tokenId) public view returns (address) {
329         address owner = _tokenOwner[tokenId];
330         require(owner != address(0));
331         return owner;
332     }
333 
334     /**
335      * @dev Approves another address to transfer the given token ID
336      * The zero address indicates there is no approved address.
337      * There can only be one approved address per token at a given time.
338      * Can only be called by the token owner or an approved operator.
339      * @param to address to be approved for the given token ID
340      * @param tokenId uint256 ID of the token to be approved
341      */
342     function approve(address to, uint256 tokenId) public {
343         address owner = ownerOf(tokenId);
344         require(to != owner);
345         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
346 
347         _tokenApprovals[tokenId] = to;
348         emit Approval(owner, to, tokenId);
349     }
350 
351     /**
352      * @dev Gets the approved address for a token ID, or zero if no address set
353      * Reverts if the token ID does not exist.
354      * @param tokenId uint256 ID of the token to query the approval of
355      * @return address currently approved for the given token ID
356      */
357     function getApproved(uint256 tokenId) public view returns (address) {
358         require(_exists(tokenId));
359         return _tokenApprovals[tokenId];
360     }
361 
362     /**
363      * @dev Sets or unsets the approval of a given operator
364      * An operator is allowed to transfer all tokens of the sender on their behalf.
365      * @param to operator address to set the approval
366      * @param approved representing the status of the approval to be set
367      */
368     function setApprovalForAll(address to, bool approved) public {
369         require(to != msg.sender);
370         _operatorApprovals[msg.sender][to] = approved;
371         emit ApprovalForAll(msg.sender, to, approved);
372     }
373 
374     /**
375      * @dev Tells whether an operator is approved by a given owner.
376      * @param owner owner address which you want to query the approval of
377      * @param operator operator address which you want to query the approval of
378      * @return bool whether the given operator is approved by the given owner
379      */
380     function isApprovedForAll(address owner, address operator) public view returns (bool) {
381         return _operatorApprovals[owner][operator];
382     }
383 
384     /**
385      * @dev Transfers the ownership of a given token ID to another address.
386      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
387      * Requires the msg.sender to be the owner, approved, or operator.
388      * @param from current owner of the token
389      * @param to address to receive the ownership of the given token ID
390      * @param tokenId uint256 ID of the token to be transferred
391      */
392     function transferFrom(address from, address to, uint256 tokenId) public {
393         require(_isApprovedOrOwner(msg.sender, tokenId));
394 
395         _transferFrom(from, to, tokenId);
396     }
397 
398     /**
399      * @dev Safely transfers the ownership of a given token ID to another address
400      * If the target address is a contract, it must implement `onERC721Received`,
401      * which is called upon a safe transfer, and return the magic value
402      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
403      * the transfer is reverted.
404      * Requires the msg.sender to be the owner, approved, or operator
405      * @param from current owner of the token
406      * @param to address to receive the ownership of the given token ID
407      * @param tokenId uint256 ID of the token to be transferred
408      */
409     function safeTransferFrom(address from, address to, uint256 tokenId) public {
410         safeTransferFrom(from, to, tokenId, "");
411     }
412 
413     /**
414      * @dev Safely transfers the ownership of a given token ID to another address
415      * If the target address is a contract, it must implement `onERC721Received`,
416      * which is called upon a safe transfer, and return the magic value
417      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
418      * the transfer is reverted.
419      * Requires the msg.sender to be the owner, approved, or operator
420      * @param from current owner of the token
421      * @param to address to receive the ownership of the given token ID
422      * @param tokenId uint256 ID of the token to be transferred
423      * @param _data bytes data to send along with a safe transfer check
424      */
425     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
426         transferFrom(from, to, tokenId);
427         require(_checkOnERC721Received(from, to, tokenId, _data));
428     }
429 
430     /**
431      * @dev Returns whether the specified token exists.
432      * @param tokenId uint256 ID of the token to query the existence of
433      * @return bool whether the token exists
434      */
435     function _exists(uint256 tokenId) internal view returns (bool) {
436         address owner = _tokenOwner[tokenId];
437         return owner != address(0);
438     }
439 
440     /**
441      * @dev Returns whether the given spender can transfer a given token ID.
442      * @param spender address of the spender to query
443      * @param tokenId uint256 ID of the token to be transferred
444      * @return bool whether the msg.sender is approved for the given token ID,
445      * is an operator of the owner, or is the owner of the token
446      */
447     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
448         address owner = ownerOf(tokenId);
449         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
450     }
451 
452     /**
453      * @dev Internal function to mint a new token.
454      * Reverts if the given token ID already exists.
455      * @param to The address that will own the minted token
456      * @param tokenId uint256 ID of the token to be minted
457      */
458     function _mint(address to, uint256 tokenId) internal {
459         require(to != address(0));
460         require(!_exists(tokenId));
461 
462         _tokenOwner[tokenId] = to;
463         _ownedTokensCount[to].increment();
464 
465         emit Transfer(address(0), to, tokenId);
466     }
467 
468     /**
469      * @dev Internal function to burn a specific token.
470      * Reverts if the token does not exist.
471      * Deprecated, use _burn(uint256) instead.
472      * @param owner owner of the token to burn
473      * @param tokenId uint256 ID of the token being burned
474      */
475     function _burn(address owner, uint256 tokenId) internal {
476         require(ownerOf(tokenId) == owner);
477 
478         _clearApproval(tokenId);
479 
480         _ownedTokensCount[owner].decrement();
481         _tokenOwner[tokenId] = address(0);
482 
483         emit Transfer(owner, address(0), tokenId);
484     }
485 
486     /**
487      * @dev Internal function to burn a specific token.
488      * Reverts if the token does not exist.
489      * @param tokenId uint256 ID of the token being burned
490      */
491     function _burn(uint256 tokenId) internal {
492         _burn(ownerOf(tokenId), tokenId);
493     }
494 
495     /**
496      * @dev Internal function to transfer ownership of a given token ID to another address.
497      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
498      * @param from current owner of the token
499      * @param to address to receive the ownership of the given token ID
500      * @param tokenId uint256 ID of the token to be transferred
501      */
502     function _transferFrom(address from, address to, uint256 tokenId) internal {
503         require(ownerOf(tokenId) == from);
504         require(to != address(0));
505 
506         _clearApproval(tokenId);
507 
508         _ownedTokensCount[from].decrement();
509         _ownedTokensCount[to].increment();
510 
511         _tokenOwner[tokenId] = to;
512 
513         emit Transfer(from, to, tokenId);
514     }
515 
516     /**
517      * @dev Internal function to invoke `onERC721Received` on a target address.
518      * The call is not executed if the target address is not a contract.
519      * @param from address representing the previous owner of the given token ID
520      * @param to target address that will receive the tokens
521      * @param tokenId uint256 ID of the token to be transferred
522      * @param _data bytes optional data to send along with the call
523      * @return bool whether the call correctly returned the expected magic value
524      */
525     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
526         internal returns (bool)
527     {
528         if (!to.isContract()) {
529             return true;
530         }
531 
532         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
533         return (retval == _ERC721_RECEIVED);
534     }
535 
536     /**
537      * @dev Private function to clear current approval of a given token ID.
538      * @param tokenId uint256 ID of the token to be transferred
539      */
540     function _clearApproval(uint256 tokenId) private {
541         if (_tokenApprovals[tokenId] != address(0)) {
542             _tokenApprovals[tokenId] = address(0);
543         }
544     }
545 }
546 
547 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
548     // Token name
549     string private _name;
550 
551     // Token symbol
552     string private _symbol;
553 
554     // Optional mapping for token URIs
555     mapping(uint256 => string) private _tokenURIs;
556 
557     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
558     /*
559      * 0x5b5e139f ===
560      *     bytes4(keccak256('name()')) ^
561      *     bytes4(keccak256('symbol()')) ^
562      *     bytes4(keccak256('tokenURI(uint256)'))
563      */
564 
565     /**
566      * @dev Constructor function
567      */
568     constructor (string memory name, string memory symbol) public {
569         _name = name;
570         _symbol = symbol;
571 
572         // register the supported interfaces to conform to ERC721 via ERC165
573         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
574     }
575 
576     /**
577      * @dev Gets the token name.
578      * @return string representing the token name
579      */
580     function name() external view returns (string memory) {
581         return _name;
582     }
583 
584     /**
585      * @dev Gets the token symbol.
586      * @return string representing the token symbol
587      */
588     function symbol() external view returns (string memory) {
589         return _symbol;
590     }
591 
592     /**
593      * @dev Returns an URI for a given token ID.
594      * Throws if the token ID does not exist. May return an empty string.
595      * @param tokenId uint256 ID of the token to query
596      */
597     function tokenURI(uint256 tokenId) external view returns (string memory) {
598         require(_exists(tokenId));
599         return _tokenURIs[tokenId];
600     }
601 
602     /**
603      * @dev Internal function to set the token URI for a given token.
604      * Reverts if the token ID does not exist.
605      * @param tokenId uint256 ID of the token to set its URI
606      * @param uri string URI to assign
607      */
608     function _setTokenURI(uint256 tokenId, string memory uri) internal {
609         require(_exists(tokenId));
610         _tokenURIs[tokenId] = uri;
611     }
612 
613     /**
614      * @dev Internal function to burn a specific token.
615      * Reverts if the token does not exist.
616      * Deprecated, use _burn(uint256) instead.
617      * @param owner owner of the token to burn
618      * @param tokenId uint256 ID of the token being burned by the msg.sender
619      */
620     function _burn(address owner, uint256 tokenId) internal {
621         super._burn(owner, tokenId);
622 
623         // Clear metadata (if any)
624         if (bytes(_tokenURIs[tokenId]).length != 0) {
625             delete _tokenURIs[tokenId];
626         }
627     }
628 }
629 
630 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
631     // Mapping from owner to list of owned token IDs
632     mapping(address => uint256[]) private _ownedTokens;
633 
634     // Mapping from token ID to index of the owner tokens list
635     mapping(uint256 => uint256) private _ownedTokensIndex;
636 
637     // Array with all token ids, used for enumeration
638     uint256[] private _allTokens;
639 
640     // Mapping from token id to position in the allTokens array
641     mapping(uint256 => uint256) private _allTokensIndex;
642 
643     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
644     /*
645      * 0x780e9d63 ===
646      *     bytes4(keccak256('totalSupply()')) ^
647      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
648      *     bytes4(keccak256('tokenByIndex(uint256)'))
649      */
650 
651     /**
652      * @dev Constructor function.
653      */
654     constructor () public {
655         // register the supported interface to conform to ERC721Enumerable via ERC165
656         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
657     }
658 
659     /**
660      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
661      * @param owner address owning the tokens list to be accessed
662      * @param index uint256 representing the index to be accessed of the requested tokens list
663      * @return uint256 token ID at the given index of the tokens list owned by the requested address
664      */
665     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
666         require(index < balanceOf(owner));
667         return _ownedTokens[owner][index];
668     }
669 
670     /**
671      * @dev Gets the total amount of tokens stored by the contract.
672      * @return uint256 representing the total amount of tokens
673      */
674     function totalSupply() public view returns (uint256) {
675         return _allTokens.length;
676     }
677 
678     /**
679      * @dev Gets the token ID at a given index of all the tokens in this contract
680      * Reverts if the index is greater or equal to the total number of tokens.
681      * @param index uint256 representing the index to be accessed of the tokens list
682      * @return uint256 token ID at the given index of the tokens list
683      */
684     function tokenByIndex(uint256 index) public view returns (uint256) {
685         require(index < totalSupply());
686         return _allTokens[index];
687     }
688 
689     /**
690      * @dev Internal function to transfer ownership of a given token ID to another address.
691      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
692      * @param from current owner of the token
693      * @param to address to receive the ownership of the given token ID
694      * @param tokenId uint256 ID of the token to be transferred
695      */
696     function _transferFrom(address from, address to, uint256 tokenId) internal {
697         super._transferFrom(from, to, tokenId);
698 
699         _removeTokenFromOwnerEnumeration(from, tokenId);
700 
701         _addTokenToOwnerEnumeration(to, tokenId);
702     }
703 
704     /**
705      * @dev Internal function to mint a new token.
706      * Reverts if the given token ID already exists.
707      * @param to address the beneficiary that will own the minted token
708      * @param tokenId uint256 ID of the token to be minted
709      */
710     function _mint(address to, uint256 tokenId) internal {
711         super._mint(to, tokenId);
712 
713         _addTokenToOwnerEnumeration(to, tokenId);
714 
715         _addTokenToAllTokensEnumeration(tokenId);
716     }
717 
718     /**
719      * @dev Internal function to burn a specific token.
720      * Reverts if the token does not exist.
721      * Deprecated, use _burn(uint256) instead.
722      * @param owner owner of the token to burn
723      * @param tokenId uint256 ID of the token being burned
724      */
725     function _burn(address owner, uint256 tokenId) internal {
726         super._burn(owner, tokenId);
727 
728         _removeTokenFromOwnerEnumeration(owner, tokenId);
729         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
730         _ownedTokensIndex[tokenId] = 0;
731 
732         _removeTokenFromAllTokensEnumeration(tokenId);
733     }
734 
735     /**
736      * @dev Gets the list of token IDs of the requested owner.
737      * @param owner address owning the tokens
738      * @return uint256[] List of token IDs owned by the requested address
739      */
740     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
741         return _ownedTokens[owner];
742     }
743 
744     /**
745      * @dev Private function to add a token to this extension's ownership-tracking data structures.
746      * @param to address representing the new owner of the given token ID
747      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
748      */
749     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
750         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
751         _ownedTokens[to].push(tokenId);
752     }
753 
754     /**
755      * @dev Private function to add a token to this extension's token tracking data structures.
756      * @param tokenId uint256 ID of the token to be added to the tokens list
757      */
758     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
759         _allTokensIndex[tokenId] = _allTokens.length;
760         _allTokens.push(tokenId);
761     }
762 
763     /**
764      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
765      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
766      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
767      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
768      * @param from address representing the previous owner of the given token ID
769      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
770      */
771     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
772         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
773         // then delete the last slot (swap and pop).
774 
775         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
776         uint256 tokenIndex = _ownedTokensIndex[tokenId];
777 
778         // When the token to delete is the last token, the swap operation is unnecessary
779         if (tokenIndex != lastTokenIndex) {
780             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
781 
782             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
783             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
784         }
785 
786         // This also deletes the contents at the last position of the array
787         _ownedTokens[from].length--;
788 
789         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
790         // lastTokenId, or just over the end of the array if the token was the last one).
791     }
792 
793     /**
794      * @dev Private function to remove a token from this extension's token tracking data structures.
795      * This has O(1) time complexity, but alters the order of the _allTokens array.
796      * @param tokenId uint256 ID of the token to be removed from the tokens list
797      */
798     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
799         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
800         // then delete the last slot (swap and pop).
801 
802         uint256 lastTokenIndex = _allTokens.length.sub(1);
803         uint256 tokenIndex = _allTokensIndex[tokenId];
804 
805         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
806         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
807         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
808         uint256 lastTokenId = _allTokens[lastTokenIndex];
809 
810         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
811         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
812 
813         // This also deletes the contents at the last position of the array
814         _allTokens.length--;
815         _allTokensIndex[tokenId] = 0;
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