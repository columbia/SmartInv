1 pragma solidity ^0.5.3;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /Users/daveappleton/Documents/akombalabs/RevenueShareToken/contracts/CommemorativeToken.sol
6 // flattened :  Thursday, 21-Mar-19 00:55:10 UTC
7 contract Ownable {
8     address private _owner;
9 
10     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12     /**
13      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14      * account.
15      */
16     constructor () internal {
17         _owner = msg.sender;
18         emit OwnershipTransferred(address(0), _owner);
19     }
20 
21     /**
22      * @return the address of the owner.
23      */
24     function owner() public view returns (address) {
25         return _owner;
26     }
27 
28     /**
29      * @dev Throws if called by any account other than the owner.
30      */
31     modifier onlyOwner() {
32         require(isOwner());
33         _;
34     }
35 
36     /**
37      * @return true if `msg.sender` is the owner of the contract.
38      */
39     function isOwner() public view returns (bool) {
40         return msg.sender == _owner;
41     }
42 
43     /**
44      * @dev Allows the current owner to relinquish control of the contract.
45      * It will not be possible to call the functions with the `onlyOwner`
46      * modifier anymore.
47      * @notice Renouncing ownership will leave the contract without an owner,
48      * thereby removing any functionality that is only available to the owner.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 library SafeMath {
75     /**
76      * @dev Multiplies two unsigned integers, reverts on overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b);
88 
89         return c;
90     }
91 
92     /**
93      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
94      */
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         // Solidity only automatically asserts when dividing by 0
97         require(b > 0);
98         uint256 c = a / b;
99         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100 
101         return c;
102     }
103 
104     /**
105      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
106      */
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         require(b <= a);
109         uint256 c = a - b;
110 
111         return c;
112     }
113 
114     /**
115      * @dev Adds two unsigned integers, reverts on overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a);
120 
121         return c;
122     }
123 
124     /**
125      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
126      * reverts when dividing by zero.
127      */
128     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129         require(b != 0);
130         return a % b;
131     }
132 }
133 
134 contract IERC721Receiver {
135     /**
136      * @notice Handle the receipt of an NFT
137      * @dev The ERC721 smart contract calls this function on the recipient
138      * after a `safeTransfer`. This function MUST return the function selector,
139      * otherwise the caller will revert the transaction. The selector to be
140      * returned can be obtained as `this.onERC721Received.selector`. This
141      * function MAY throw to revert and reject the transfer.
142      * Note: the ERC721 contract address is always the message sender.
143      * @param operator The address which called `safeTransferFrom` function
144      * @param from The address which previously owned the token
145      * @param tokenId The NFT identifier which is being transferred
146      * @param data Additional data with no specified format
147      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
148      */
149     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
150     public returns (bytes4);
151 }
152 
153 library Address {
154     /**
155      * Returns whether the target address is a contract
156      * @dev This function will return false if invoked during the constructor of a contract,
157      * as the code is not actually created until after the constructor finishes.
158      * @param account address of the account to check
159      * @return whether the target address is a contract
160      */
161     function isContract(address account) internal view returns (bool) {
162         uint256 size;
163         // XXX Currently there is no better way to check if there is a contract in an address
164         // than to check the size of the code at that address.
165         // See https://ethereum.stackexchange.com/a/14016/36603
166         // for more details about how this works.
167         // TODO Check this again before the Serenity release, because all addresses will be
168         // contracts then.
169         // solhint-disable-next-line no-inline-assembly
170         assembly { size := extcodesize(account) }
171         return size > 0;
172     }
173 }
174 
175 interface IERC165 {
176     /**
177      * @notice Query if a contract implements an interface
178      * @param interfaceId The interface identifier, as specified in ERC-165
179      * @dev Interface identification is specified in ERC-165. This function
180      * uses less than 30,000 gas.
181      */
182     function supportsInterface(bytes4 interfaceId) external view returns (bool);
183 }
184 
185 library Counters {
186     using SafeMath for uint256;
187 
188     struct Counter {
189         // This variable should never be directly accessed by users of the library: interactions must be restricted to
190         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
191         // this feature: see https://github.com/ethereum/solidity/issues/4637
192         uint256 _value; // default: 0
193     }
194 
195     function current(Counter storage counter) internal view returns (uint256) {
196         return counter._value;
197     }
198 
199     function increment(Counter storage counter) internal {
200         counter._value += 1;
201     }
202 
203     function decrement(Counter storage counter) internal {
204         counter._value = counter._value.sub(1);
205     }
206 }
207 
208 contract Batcher is Ownable{
209 
210     address public batcher;
211 
212     event NewBatcher(address newMinter);
213 
214     modifier ownerOrBatcher()  {
215         require ((msg.sender == batcher) || isOwner(),"not authorised");
216         _;
217     }
218 
219     function setBatcher (address newBatcher) external onlyOwner {
220         batcher = newBatcher;
221         emit NewBatcher(batcher);
222     }
223 
224 }
225 contract ERC165 is IERC165 {
226     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
227     /*
228      * 0x01ffc9a7 ===
229      *     bytes4(keccak256('supportsInterface(bytes4)'))
230      */
231 
232     /**
233      * @dev a mapping of interface id to whether or not it's supported
234      */
235     mapping(bytes4 => bool) private _supportedInterfaces;
236 
237     /**
238      * @dev A contract implementing SupportsInterfaceWithLookup
239      * implement ERC165 itself
240      */
241     constructor () internal {
242         _registerInterface(_INTERFACE_ID_ERC165);
243     }
244 
245     /**
246      * @dev implement supportsInterface(bytes4) using a lookup table
247      */
248     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
249         return _supportedInterfaces[interfaceId];
250     }
251 
252     /**
253      * @dev internal method for registering an interface
254      */
255     function _registerInterface(bytes4 interfaceId) internal {
256         require(interfaceId != 0xffffffff);
257         _supportedInterfaces[interfaceId] = true;
258     }
259 }
260 
261 contract IERC721 is IERC165 {
262     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
263     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
264     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
265 
266     function balanceOf(address owner) public view returns (uint256 balance);
267     function ownerOf(uint256 tokenId) public view returns (address owner);
268 
269     function approve(address to, uint256 tokenId) public;
270     function getApproved(uint256 tokenId) public view returns (address operator);
271 
272     function setApprovalForAll(address operator, bool _approved) public;
273     function isApprovedForAll(address owner, address operator) public view returns (bool);
274 
275     function transferFrom(address from, address to, uint256 tokenId) public;
276     function safeTransferFrom(address from, address to, uint256 tokenId) public;
277 
278     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
279 }
280 
281 contract ERC721 is ERC165, IERC721 {
282     using SafeMath for uint256;
283     using Address for address;
284     using Counters for Counters.Counter;
285 
286     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
287     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
288     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
289 
290     // Mapping from token ID to owner
291     mapping (uint256 => address) private _tokenOwner;
292 
293     // Mapping from token ID to approved address
294     mapping (uint256 => address) private _tokenApprovals;
295 
296     // Mapping from owner to number of owned token
297     mapping (address => Counters.Counter) private _ownedTokensCount;
298 
299     // Mapping from owner to operator approvals
300     mapping (address => mapping (address => bool)) private _operatorApprovals;
301 
302     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
303     /*
304      * 0x80ac58cd ===
305      *     bytes4(keccak256('balanceOf(address)')) ^
306      *     bytes4(keccak256('ownerOf(uint256)')) ^
307      *     bytes4(keccak256('approve(address,uint256)')) ^
308      *     bytes4(keccak256('getApproved(uint256)')) ^
309      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
310      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
311      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
312      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
313      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
314      */
315 
316     constructor () public {
317         // register the supported interfaces to conform to ERC721 via ERC165
318         _registerInterface(_INTERFACE_ID_ERC721);
319     }
320 
321     /**
322      * @dev Gets the balance of the specified address
323      * @param owner address to query the balance of
324      * @return uint256 representing the amount owned by the passed address
325      */
326     function balanceOf(address owner) public view returns (uint256) {
327         require(owner != address(0));
328         return _ownedTokensCount[owner].current();
329     }
330 
331     /**
332      * @dev Gets the owner of the specified token ID
333      * @param tokenId uint256 ID of the token to query the owner of
334      * @return address currently marked as the owner of the given token ID
335      */
336     function ownerOf(uint256 tokenId) public view returns (address) {
337         address owner = _tokenOwner[tokenId];
338         require(owner != address(0));
339         return owner;
340     }
341 
342     /**
343      * @dev Approves another address to transfer the given token ID
344      * The zero address indicates there is no approved address.
345      * There can only be one approved address per token at a given time.
346      * Can only be called by the token owner or an approved operator.
347      * @param to address to be approved for the given token ID
348      * @param tokenId uint256 ID of the token to be approved
349      */
350     function approve(address to, uint256 tokenId) public {
351         address owner = ownerOf(tokenId);
352         require(to != owner);
353         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
354 
355         _tokenApprovals[tokenId] = to;
356         emit Approval(owner, to, tokenId);
357     }
358 
359     /**
360      * @dev Gets the approved address for a token ID, or zero if no address set
361      * Reverts if the token ID does not exist.
362      * @param tokenId uint256 ID of the token to query the approval of
363      * @return address currently approved for the given token ID
364      */
365     function getApproved(uint256 tokenId) public view returns (address) {
366         require(_exists(tokenId));
367         return _tokenApprovals[tokenId];
368     }
369 
370     /**
371      * @dev Sets or unsets the approval of a given operator
372      * An operator is allowed to transfer all tokens of the sender on their behalf
373      * @param to operator address to set the approval
374      * @param approved representing the status of the approval to be set
375      */
376     function setApprovalForAll(address to, bool approved) public {
377         require(to != msg.sender);
378         _operatorApprovals[msg.sender][to] = approved;
379         emit ApprovalForAll(msg.sender, to, approved);
380     }
381 
382     /**
383      * @dev Tells whether an operator is approved by a given owner
384      * @param owner owner address which you want to query the approval of
385      * @param operator operator address which you want to query the approval of
386      * @return bool whether the given operator is approved by the given owner
387      */
388     function isApprovedForAll(address owner, address operator) public view returns (bool) {
389         return _operatorApprovals[owner][operator];
390     }
391 
392     /**
393      * @dev Transfers the ownership of a given token ID to another address
394      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
395      * Requires the msg.sender to be the owner, approved, or operator
396      * @param from current owner of the token
397      * @param to address to receive the ownership of the given token ID
398      * @param tokenId uint256 ID of the token to be transferred
399      */
400     function transferFrom(address from, address to, uint256 tokenId) public {
401         require(_isApprovedOrOwner(msg.sender, tokenId));
402 
403         _transferFrom(from, to, tokenId);
404     }
405 
406     /**
407      * @dev Safely transfers the ownership of a given token ID to another address
408      * If the target address is a contract, it must implement `onERC721Received`,
409      * which is called upon a safe transfer, and return the magic value
410      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
411      * the transfer is reverted.
412      * Requires the msg.sender to be the owner, approved, or operator
413      * @param from current owner of the token
414      * @param to address to receive the ownership of the given token ID
415      * @param tokenId uint256 ID of the token to be transferred
416      */
417     function safeTransferFrom(address from, address to, uint256 tokenId) public {
418         safeTransferFrom(from, to, tokenId, "");
419     }
420 
421     /**
422      * @dev Safely transfers the ownership of a given token ID to another address
423      * If the target address is a contract, it must implement `onERC721Received`,
424      * which is called upon a safe transfer, and return the magic value
425      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
426      * the transfer is reverted.
427      * Requires the msg.sender to be the owner, approved, or operator
428      * @param from current owner of the token
429      * @param to address to receive the ownership of the given token ID
430      * @param tokenId uint256 ID of the token to be transferred
431      * @param _data bytes data to send along with a safe transfer check
432      */
433     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
434         transferFrom(from, to, tokenId);
435         require(_checkOnERC721Received(from, to, tokenId, _data));
436     }
437 
438     /**
439      * @dev Returns whether the specified token exists
440      * @param tokenId uint256 ID of the token to query the existence of
441      * @return bool whether the token exists
442      */
443     function _exists(uint256 tokenId) internal view returns (bool) {
444         address owner = _tokenOwner[tokenId];
445         return owner != address(0);
446     }
447 
448     /**
449      * @dev Returns whether the given spender can transfer a given token ID
450      * @param spender address of the spender to query
451      * @param tokenId uint256 ID of the token to be transferred
452      * @return bool whether the msg.sender is approved for the given token ID,
453      * is an operator of the owner, or is the owner of the token
454      */
455     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
456         address owner = ownerOf(tokenId);
457         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
458     }
459 
460     /**
461      * @dev Internal function to mint a new token
462      * Reverts if the given token ID already exists
463      * @param to The address that will own the minted token
464      * @param tokenId uint256 ID of the token to be minted
465      */
466     function _mint(address to, uint256 tokenId) internal {
467         require(to != address(0));
468         require(!_exists(tokenId));
469 
470         _tokenOwner[tokenId] = to;
471         _ownedTokensCount[to].increment();
472 
473         emit Transfer(address(0), to, tokenId);
474     }
475 
476     /**
477      * @dev Internal function to burn a specific token
478      * Reverts if the token does not exist
479      * Deprecated, use _burn(uint256) instead.
480      * @param owner owner of the token to burn
481      * @param tokenId uint256 ID of the token being burned
482      */
483     function _burn(address owner, uint256 tokenId) internal {
484         require(ownerOf(tokenId) == owner);
485 
486         _clearApproval(tokenId);
487 
488         _ownedTokensCount[owner].decrement();
489         _tokenOwner[tokenId] = address(0);
490 
491         emit Transfer(owner, address(0), tokenId);
492     }
493 
494     /**
495      * @dev Internal function to burn a specific token
496      * Reverts if the token does not exist
497      * @param tokenId uint256 ID of the token being burned
498      */
499     function _burn(uint256 tokenId) internal {
500         _burn(ownerOf(tokenId), tokenId);
501     }
502 
503     /**
504      * @dev Internal function to transfer ownership of a given token ID to another address.
505      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
506      * @param from current owner of the token
507      * @param to address to receive the ownership of the given token ID
508      * @param tokenId uint256 ID of the token to be transferred
509      */
510     function _transferFrom(address from, address to, uint256 tokenId) internal {
511         require(ownerOf(tokenId) == from);
512         require(to != address(0));
513 
514         _clearApproval(tokenId);
515 
516         _ownedTokensCount[from].decrement();
517         _ownedTokensCount[to].increment();
518 
519         _tokenOwner[tokenId] = to;
520 
521         emit Transfer(from, to, tokenId);
522     }
523 
524     /**
525      * @dev Internal function to invoke `onERC721Received` on a target address
526      * The call is not executed if the target address is not a contract
527      * @param from address representing the previous owner of the given token ID
528      * @param to target address that will receive the tokens
529      * @param tokenId uint256 ID of the token to be transferred
530      * @param _data bytes optional data to send along with the call
531      * @return bool whether the call correctly returned the expected magic value
532      */
533     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
534         internal returns (bool)
535     {
536         if (!to.isContract()) {
537             return true;
538         }
539 
540         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
541         return (retval == _ERC721_RECEIVED);
542     }
543 
544     /**
545      * @dev Private function to clear current approval of a given token ID
546      * @param tokenId uint256 ID of the token to be transferred
547      */
548     function _clearApproval(uint256 tokenId) private {
549         if (_tokenApprovals[tokenId] != address(0)) {
550             _tokenApprovals[tokenId] = address(0);
551         }
552     }
553 }
554 
555 contract IERC721Enumerable is IERC721 {
556     function totalSupply() public view returns (uint256);
557     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
558 
559     function tokenByIndex(uint256 index) public view returns (uint256);
560 }
561 
562 contract IERC721Metadata is IERC721 {
563     function name() external view returns (string memory);
564     function symbol() external view returns (string memory);
565     function tokenURI(uint256 tokenId) external view returns (string memory);
566 }
567 
568 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
569     // Mapping from owner to list of owned token IDs
570     mapping(address => uint256[]) private _ownedTokens;
571 
572     // Mapping from token ID to index of the owner tokens list
573     mapping(uint256 => uint256) private _ownedTokensIndex;
574 
575     // Array with all token ids, used for enumeration
576     uint256[] private _allTokens;
577 
578     // Mapping from token id to position in the allTokens array
579     mapping(uint256 => uint256) private _allTokensIndex;
580 
581     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
582     /*
583      * 0x780e9d63 ===
584      *     bytes4(keccak256('totalSupply()')) ^
585      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
586      *     bytes4(keccak256('tokenByIndex(uint256)'))
587      */
588 
589     /**
590      * @dev Constructor function
591      */
592     constructor () public {
593         // register the supported interface to conform to ERC721Enumerable via ERC165
594         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
595     }
596 
597     /**
598      * @dev Gets the token ID at a given index of the tokens list of the requested owner
599      * @param owner address owning the tokens list to be accessed
600      * @param index uint256 representing the index to be accessed of the requested tokens list
601      * @return uint256 token ID at the given index of the tokens list owned by the requested address
602      */
603     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
604         require(index < balanceOf(owner));
605         return _ownedTokens[owner][index];
606     }
607 
608     /**
609      * @dev Gets the total amount of tokens stored by the contract
610      * @return uint256 representing the total amount of tokens
611      */
612     function totalSupply() public view returns (uint256) {
613         return _allTokens.length;
614     }
615 
616     /**
617      * @dev Gets the token ID at a given index of all the tokens in this contract
618      * Reverts if the index is greater or equal to the total number of tokens
619      * @param index uint256 representing the index to be accessed of the tokens list
620      * @return uint256 token ID at the given index of the tokens list
621      */
622     function tokenByIndex(uint256 index) public view returns (uint256) {
623         require(index < totalSupply());
624         return _allTokens[index];
625     }
626 
627     /**
628      * @dev Internal function to transfer ownership of a given token ID to another address.
629      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
630      * @param from current owner of the token
631      * @param to address to receive the ownership of the given token ID
632      * @param tokenId uint256 ID of the token to be transferred
633      */
634     function _transferFrom(address from, address to, uint256 tokenId) internal {
635         super._transferFrom(from, to, tokenId);
636 
637         _removeTokenFromOwnerEnumeration(from, tokenId);
638 
639         _addTokenToOwnerEnumeration(to, tokenId);
640     }
641 
642     /**
643      * @dev Internal function to mint a new token
644      * Reverts if the given token ID already exists
645      * @param to address the beneficiary that will own the minted token
646      * @param tokenId uint256 ID of the token to be minted
647      */
648     function _mint(address to, uint256 tokenId) internal {
649         super._mint(to, tokenId);
650 
651         _addTokenToOwnerEnumeration(to, tokenId);
652 
653         _addTokenToAllTokensEnumeration(tokenId);
654     }
655 
656     /**
657      * @dev Internal function to burn a specific token
658      * Reverts if the token does not exist
659      * Deprecated, use _burn(uint256) instead
660      * @param owner owner of the token to burn
661      * @param tokenId uint256 ID of the token being burned
662      */
663     function _burn(address owner, uint256 tokenId) internal {
664         super._burn(owner, tokenId);
665 
666         _removeTokenFromOwnerEnumeration(owner, tokenId);
667         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
668         _ownedTokensIndex[tokenId] = 0;
669 
670         _removeTokenFromAllTokensEnumeration(tokenId);
671     }
672 
673     /**
674      * @dev Gets the list of token IDs of the requested owner
675      * @param owner address owning the tokens
676      * @return uint256[] List of token IDs owned by the requested address
677      */
678     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
679         return _ownedTokens[owner];
680     }
681 
682     /**
683      * @dev Private function to add a token to this extension's ownership-tracking data structures.
684      * @param to address representing the new owner of the given token ID
685      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
686      */
687     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
688         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
689         _ownedTokens[to].push(tokenId);
690     }
691 
692     /**
693      * @dev Private function to add a token to this extension's token tracking data structures.
694      * @param tokenId uint256 ID of the token to be added to the tokens list
695      */
696     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
697         _allTokensIndex[tokenId] = _allTokens.length;
698         _allTokens.push(tokenId);
699     }
700 
701     /**
702      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
703      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
704      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
705      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
706      * @param from address representing the previous owner of the given token ID
707      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
708      */
709     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
710         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
711         // then delete the last slot (swap and pop).
712 
713         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
714         uint256 tokenIndex = _ownedTokensIndex[tokenId];
715 
716         // When the token to delete is the last token, the swap operation is unnecessary
717         if (tokenIndex != lastTokenIndex) {
718             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
719 
720             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
721             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
722         }
723 
724         // This also deletes the contents at the last position of the array
725         _ownedTokens[from].length--;
726 
727         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
728         // lastTokenId, or just over the end of the array if the token was the last one).
729     }
730 
731     /**
732      * @dev Private function to remove a token from this extension's token tracking data structures.
733      * This has O(1) time complexity, but alters the order of the _allTokens array.
734      * @param tokenId uint256 ID of the token to be removed from the tokens list
735      */
736     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
737         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
738         // then delete the last slot (swap and pop).
739 
740         uint256 lastTokenIndex = _allTokens.length.sub(1);
741         uint256 tokenIndex = _allTokensIndex[tokenId];
742 
743         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
744         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
745         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
746         uint256 lastTokenId = _allTokens[lastTokenIndex];
747 
748         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
749         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
750 
751         // This also deletes the contents at the last position of the array
752         _allTokens.length--;
753         _allTokensIndex[tokenId] = 0;
754     }
755 }
756 
757 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
758     // Token name
759     string private _name;
760 
761     // Token symbol
762     string private _symbol;
763 
764     // Optional mapping for token URIs
765     mapping(uint256 => string) private _tokenURIs;
766 
767     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
768     /*
769      * 0x5b5e139f ===
770      *     bytes4(keccak256('name()')) ^
771      *     bytes4(keccak256('symbol()')) ^
772      *     bytes4(keccak256('tokenURI(uint256)'))
773      */
774 
775     /**
776      * @dev Constructor function
777      */
778     constructor (string memory name, string memory symbol) public {
779         _name = name;
780         _symbol = symbol;
781 
782         // register the supported interfaces to conform to ERC721 via ERC165
783         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
784     }
785 
786     /**
787      * @dev Gets the token name
788      * @return string representing the token name
789      */
790     function name() external view returns (string memory) {
791         return _name;
792     }
793 
794     /**
795      * @dev Gets the token symbol
796      * @return string representing the token symbol
797      */
798     function symbol() external view returns (string memory) {
799         return _symbol;
800     }
801 
802     /**
803      * @dev Returns an URI for a given token ID
804      * Throws if the token ID does not exist. May return an empty string.
805      * @param tokenId uint256 ID of the token to query
806      */
807     function tokenURI(uint256 tokenId) external view returns (string memory) {
808         require(_exists(tokenId));
809         return _tokenURIs[tokenId];
810     }
811 
812     /**
813      * @dev Internal function to set the token URI for a given token
814      * Reverts if the token ID does not exist
815      * @param tokenId uint256 ID of the token to set its URI
816      * @param uri string URI to assign
817      */
818     function _setTokenURI(uint256 tokenId, string memory uri) internal {
819         require(_exists(tokenId));
820         _tokenURIs[tokenId] = uri;
821     }
822 
823     /**
824      * @dev Internal function to burn a specific token
825      * Reverts if the token does not exist
826      * Deprecated, use _burn(uint256) instead
827      * @param owner owner of the token to burn
828      * @param tokenId uint256 ID of the token being burned by the msg.sender
829      */
830     function _burn(address owner, uint256 tokenId) internal {
831         super._burn(owner, tokenId);
832 
833         // Clear metadata (if any)
834         if (bytes(_tokenURIs[tokenId]).length != 0) {
835             delete _tokenURIs[tokenId];
836         }
837     }
838 }
839 
840 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
841     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
842         // solhint-disable-previous-line no-empty-blocks
843     }
844 }
845 
846 contract CommemorativeToken is ERC721Full, Ownable, Batcher {
847 
848     string name   = "Akomba Commemorative Token";
849     string symbol = "AkCT";
850 
851     uint nextToken;
852 
853 
854     constructor(address newOwner) 
855         public 
856         ERC721Full(name,symbol)
857     {
858         batcher = 0xB6f9E6D9354b0c04E0556A168a8Af07b2439865E;
859         transferOwnership(newOwner);
860     }
861 
862     function mint(address recipient, string memory uri) public ownerOrBatcher {
863         _mint(recipient,nextToken);
864         _setTokenURI(nextToken, uri);
865         nextToken++;
866     }
867 }